// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>
#include <inc/mmu.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>
#include <kern/pmap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display a stack backtrace", mon_backtrace },
	{ "showmappings", "Display the physical page mappings \
	and corresponding permission bits that apply to the pages at virtual addresses", mon_showmappings},
	{ "changeperm", "change the permissions of any mapping in the current address space", mon_changeperm},
	{ "dump", "Dump the contents of a range of memory given either a virtual or physical address range", mon_dump},
};

/***** Implementations of basic kernel monitor commands *****/
int 
mon_showmappings(int argc, char **argv, struct Trapframe *tf){
	if(argc != 3){
		cprintf("usage: showmappings [from_addr] [to_addr]\n",argc);
		return 0;
	}
	physaddr_t from = ROUNDDOWN(strtol(argv[1],NULL, 16),PGSIZE);
	physaddr_t to = ROUNDUP(strtol(argv[2],NULL, 16),PGSIZE);

	cprintf("|%10s|%10s|%8s|%8s|%8s|\n","PADDR","VADDR","PTE_P","PTE_W","PTE_U");
	for(physaddr_t i=from;i<=to;i+=PGSIZE){
		void* va = KADDR(i);
		cprintf("|0x%08x|0x%08x|", i, va);
		pte_t* pte = pgdir_walk(kern_pgdir, va, 0);
		if(pte){
			cprintf("%8x|%8x|%8x|\n", (*pte & PTE_P)>0, (*pte & PTE_W)>0,(*pte & PTE_U)>0);
		}
		else{
			cprintf("%8x|%8x|%8x|\n", 0, 0, 0);
		}
	}
	return 0;
}

int 
mon_changeperm(int argc, char **argv, struct Trapframe *tf){
	if(argc != 4){
		cprintf("usage: changeperm [addr] [clr/set] [ur/uw/kw]\n",argc);
		return 0;
	}
	
	physaddr_t addr = strtol(argv[1],NULL, 16);
	char* type = argv[2];
	char* perm = argv[3];
	
	void* va = KADDR(addr);
	pte_t* pte = pgdir_walk(kern_pgdir, va, 0);
	if(!pte){
		cprintf("invalid addr:%8x\n",addr);
		return 0;
	}
	

	if(!strcmp(type,"clr")){		
		if(!strcmp(perm, "ur") || !strcmp(perm, "uw")){
			*pte = (*pte) & ~PTE_U;
		}
		else if(!strcmp(perm, "kw")){
			*pte = (*pte) & ~PTE_W;
		}
		else{
			cprintf("invalid permisson:%4s\n",perm);
		}
		return 0;
	}
	else if(!strcmp(type,"set")){		
		if(!strcmp(perm, "ur")){
			*pte = (*pte) | PTE_U;
		}
		else if(!strcmp(perm, "uw")){
			*pte = (*pte) | PTE_U | PTE_W;
		}
		else if(!strcmp(perm, "kw")){
			*pte = (*pte) | PTE_W;
		}
		else{
			cprintf("invalid permisson:%4s\n",perm);
		}
		return 0;
	}
	else{
		cprintf("invalid action:%4s\n",type);
	}

	
	return 0;
}

int 
mon_dump(int argc, char **argv, struct Trapframe *tf){
	if(argc != 4){
		cprintf("usage: dump [v/p] [addr] [range]\n",argc);
		return 0;
	}

	char* type = argv[1];
	uint32_t range = strtol(argv[3], NULL, 10);

	uintptr_t va = 0;
	if(!strcmp(type, "p")){//physical addr
		va = (uintptr_t)KADDR(strtol(argv[2],NULL,16));
	}
	else if(!strcmp(type, "v")){//virtual addr
		va = strtol(argv[2],NULL,16);
	}
	else{
		cprintf("invalid address type:%4s\n",type);
		return 0;
	}

	va = ROUNDDOWN(va, sizeof(uint32_t));
	uintptr_t va_to = ROUNDUP(va+range,sizeof(uint32_t));
	cprintf("%10s |%12s\n","VADDR","CONTENT");
	for(;va<va_to;va+=sizeof(uint32_t)){
		pte_t* pte = pgdir_walk(kern_pgdir,(void*)va,0);
		if(!pte || !(*pte & PTE_P)){
			cprintf("invalid address: 0x%8x\n",va);
			break;
		}
		uint32_t cont = *(uint32_t*)va;
		cprintf("0x%8x | %02x %02x %02x %02x\n",va,(cont>>0)&0xFF,(cont>>8)&0xFF,(cont>>16)&0xFF,(cont>>24)&0xFF);
	}	
	return 0;
}

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

// Lab1 only
// read the pointer to the retaddr on the stack
static uint32_t
read_pretaddr() {
    uint32_t pretaddr;
    __asm __volatile("leal 4(%%ebp), %0" : "=r" (pretaddr)); 
    return pretaddr;
}

void
do_overflow(void)
{
    cprintf("Overflow success\n");
}

void
start_overflow(void)
{
	// You should use a techique similar to buffer overflow
	// to invoke the do_overflow function and
	// the procedure must return normally.

    // And you must use the "cprintf" function with %n specifier
    // you augmented in the "Exercise 9" to do this job.

    // hint: You can use the read_pretaddr function to retrieve 
    //       the pointer to the function call return address;

    char str[256] = {};
    int nstr = 0;
    char *pret_addr;

	// Your code here.
    
	pret_addr = (char*)read_pretaddr();
	//ret to do_overflow
	cprintf("old rip: %lx\n", *(uint32_t*)pret_addr);
	cprintf("%45d%n\n",nstr, pret_addr);//0x2d
	cprintf("%9d%n\n",nstr, pret_addr+1);//0x09
	cprintf("new rip: %lx\n", *(uint32_t*)pret_addr);

	//ret to mon_bacKtrace from do_overflow
	//cprintf("old rip up: %lx\n", *((uint32_t*)pret_addr+1));
	cprintf("%36d%n\n",nstr, pret_addr+4);//0x24
	cprintf("%10d%n\n", nstr, pret_addr+5);//0x0a
	cprintf("%16d%n\n",nstr, pret_addr+6);//0x10
	cprintf("%240d%n\n",nstr, pret_addr+7);//0xf0
	//cprintf("new rip up: %lx\n", *((uint32_t*)pret_addr+1));
	
}

void
overflow_me(void)
{
    start_overflow();
	cprintf("");
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	cprintf("Stack backtrace:\n");
	uint32_t ebp = read_ebp();
	while(ebp!=0){
		uint32_t eip = *(int*)(ebp+4);
		cprintf("  eip %08x  ebp %08x  args %08x %08x %08x %08x %08x\n",
				eip, ebp,
				*(int*)(ebp+8),*(int*)(ebp+12),*(int*)(ebp+16),*(int*)(ebp+20),*(int*)(ebp+24));
		struct Eipdebuginfo info;
		if(debuginfo_eip(eip,&info)>=0){
			cprintf("         %s:%d %.*s+%d\n",
			info.eip_file, info.eip_line,
			info.eip_fn_namelen, info.eip_fn_name, eip-info.eip_fn_addr);
		}
		ebp = *(int*)ebp;
	}

	overflow_me();
    	cprintf("Backtrace success\n");
		cprintf("debug\n");
	return 0;
}




/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
