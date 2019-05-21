
obj/user/faultwrite.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	*(unsigned*)0 = 0;
  800033:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003a:	00 00 00 
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 c9 00 00 00       	call   800117 <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800056:	c1 e0 04             	shl    $0x4,%eax
  800059:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005e:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800063:	85 db                	test   %ebx,%ebx
  800065:	7e 07                	jle    80006e <libmain+0x30>
		binaryname = argv[0];
  800067:	8b 06                	mov    (%esi),%eax
  800069:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	56                   	push   %esi
  800072:	53                   	push   %ebx
  800073:	e8 bb ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800078:	e8 0a 00 00 00       	call   800087 <exit>
}
  80007d:	83 c4 10             	add    $0x10,%esp
  800080:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800083:	5b                   	pop    %ebx
  800084:	5e                   	pop    %esi
  800085:	5d                   	pop    %ebp
  800086:	c3                   	ret    

00800087 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800087:	55                   	push   %ebp
  800088:	89 e5                	mov    %esp,%ebp
  80008a:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  80008d:	6a 00                	push   $0x0
  80008f:	e8 42 00 00 00       	call   8000d6 <sys_env_destroy>
}
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	c9                   	leave  
  800098:	c3                   	ret    

00800099 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	57                   	push   %edi
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000aa:	89 c3                	mov    %eax,%ebx
  8000ac:	89 c7                	mov    %eax,%edi
  8000ae:	89 c6                	mov    %eax,%esi
  8000b0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b2:	5b                   	pop    %ebx
  8000b3:	5e                   	pop    %esi
  8000b4:	5f                   	pop    %edi
  8000b5:	5d                   	pop    %ebp
  8000b6:	c3                   	ret    

008000b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c7:	89 d1                	mov    %edx,%ecx
  8000c9:	89 d3                	mov    %edx,%ebx
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	89 d6                	mov    %edx,%esi
  8000cf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5f                   	pop    %edi
  8000d4:	5d                   	pop    %ebp
  8000d5:	c3                   	ret    

008000d6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	57                   	push   %edi
  8000da:	56                   	push   %esi
  8000db:	53                   	push   %ebx
  8000dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ec:	89 cb                	mov    %ecx,%ebx
  8000ee:	89 cf                	mov    %ecx,%edi
  8000f0:	89 ce                	mov    %ecx,%esi
  8000f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	7f 08                	jg     800100 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fb:	5b                   	pop    %ebx
  8000fc:	5e                   	pop    %esi
  8000fd:	5f                   	pop    %edi
  8000fe:	5d                   	pop    %ebp
  8000ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	50                   	push   %eax
  800104:	6a 03                	push   $0x3
  800106:	68 4a 11 80 00       	push   $0x80114a
  80010b:	6a 33                	push   $0x33
  80010d:	68 67 11 80 00       	push   $0x801167
  800112:	e8 b1 02 00 00       	call   8003c8 <_panic>

00800117 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	57                   	push   %edi
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011d:	ba 00 00 00 00       	mov    $0x0,%edx
  800122:	b8 02 00 00 00       	mov    $0x2,%eax
  800127:	89 d1                	mov    %edx,%ecx
  800129:	89 d3                	mov    %edx,%ebx
  80012b:	89 d7                	mov    %edx,%edi
  80012d:	89 d6                	mov    %edx,%esi
  80012f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5f                   	pop    %edi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <sys_yield>:

void
sys_yield(void)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	57                   	push   %edi
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013c:	ba 00 00 00 00       	mov    $0x0,%edx
  800141:	b8 0c 00 00 00       	mov    $0xc,%eax
  800146:	89 d1                	mov    %edx,%ecx
  800148:	89 d3                	mov    %edx,%ebx
  80014a:	89 d7                	mov    %edx,%edi
  80014c:	89 d6                	mov    %edx,%esi
  80014e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800150:	5b                   	pop    %ebx
  800151:	5e                   	pop    %esi
  800152:	5f                   	pop    %edi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	57                   	push   %edi
  800159:	56                   	push   %esi
  80015a:	53                   	push   %ebx
  80015b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015e:	be 00 00 00 00       	mov    $0x0,%esi
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
  800166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800169:	b8 04 00 00 00       	mov    $0x4,%eax
  80016e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800171:	89 f7                	mov    %esi,%edi
  800173:	cd 30                	int    $0x30
	if(check && ret > 0)
  800175:	85 c0                	test   %eax,%eax
  800177:	7f 08                	jg     800181 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	6a 04                	push   $0x4
  800187:	68 4a 11 80 00       	push   $0x80114a
  80018c:	6a 33                	push   $0x33
  80018e:	68 67 11 80 00       	push   $0x801167
  800193:	e8 30 02 00 00       	call   8003c8 <_panic>

00800198 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
  80019e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	7f 08                	jg     8001c3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001be:	5b                   	pop    %ebx
  8001bf:	5e                   	pop    %esi
  8001c0:	5f                   	pop    %edi
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	50                   	push   %eax
  8001c7:	6a 05                	push   $0x5
  8001c9:	68 4a 11 80 00       	push   $0x80114a
  8001ce:	6a 33                	push   $0x33
  8001d0:	68 67 11 80 00       	push   $0x801167
  8001d5:	e8 ee 01 00 00       	call   8003c8 <_panic>

008001da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	57                   	push   %edi
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
  8001e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f3:	89 df                	mov    %ebx,%edi
  8001f5:	89 de                	mov    %ebx,%esi
  8001f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f9:	85 c0                	test   %eax,%eax
  8001fb:	7f 08                	jg     800205 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800200:	5b                   	pop    %ebx
  800201:	5e                   	pop    %esi
  800202:	5f                   	pop    %edi
  800203:	5d                   	pop    %ebp
  800204:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	50                   	push   %eax
  800209:	6a 06                	push   $0x6
  80020b:	68 4a 11 80 00       	push   $0x80114a
  800210:	6a 33                	push   $0x33
  800212:	68 67 11 80 00       	push   $0x801167
  800217:	e8 ac 01 00 00       	call   8003c8 <_panic>

0080021c <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	57                   	push   %edi
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800225:	b9 00 00 00 00       	mov    $0x0,%ecx
  80022a:	8b 55 08             	mov    0x8(%ebp),%edx
  80022d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800232:	89 cb                	mov    %ecx,%ebx
  800234:	89 cf                	mov    %ecx,%edi
  800236:	89 ce                	mov    %ecx,%esi
  800238:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023a:	85 c0                	test   %eax,%eax
  80023c:	7f 08                	jg     800246 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  80023e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800241:	5b                   	pop    %ebx
  800242:	5e                   	pop    %esi
  800243:	5f                   	pop    %edi
  800244:	5d                   	pop    %ebp
  800245:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	50                   	push   %eax
  80024a:	6a 0b                	push   $0xb
  80024c:	68 4a 11 80 00       	push   $0x80114a
  800251:	6a 33                	push   $0x33
  800253:	68 67 11 80 00       	push   $0x801167
  800258:	e8 6b 01 00 00       	call   8003c8 <_panic>

0080025d <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	57                   	push   %edi
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
  800263:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800266:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026b:	8b 55 08             	mov    0x8(%ebp),%edx
  80026e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800271:	b8 08 00 00 00       	mov    $0x8,%eax
  800276:	89 df                	mov    %ebx,%edi
  800278:	89 de                	mov    %ebx,%esi
  80027a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027c:	85 c0                	test   %eax,%eax
  80027e:	7f 08                	jg     800288 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800283:	5b                   	pop    %ebx
  800284:	5e                   	pop    %esi
  800285:	5f                   	pop    %edi
  800286:	5d                   	pop    %ebp
  800287:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	50                   	push   %eax
  80028c:	6a 08                	push   $0x8
  80028e:	68 4a 11 80 00       	push   $0x80114a
  800293:	6a 33                	push   $0x33
  800295:	68 67 11 80 00       	push   $0x801167
  80029a:	e8 29 01 00 00       	call   8003c8 <_panic>

0080029f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	57                   	push   %edi
  8002a3:	56                   	push   %esi
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b3:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b8:	89 df                	mov    %ebx,%edi
  8002ba:	89 de                	mov    %ebx,%esi
  8002bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002be:	85 c0                	test   %eax,%eax
  8002c0:	7f 08                	jg     8002ca <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c5:	5b                   	pop    %ebx
  8002c6:	5e                   	pop    %esi
  8002c7:	5f                   	pop    %edi
  8002c8:	5d                   	pop    %ebp
  8002c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	50                   	push   %eax
  8002ce:	6a 09                	push   $0x9
  8002d0:	68 4a 11 80 00       	push   $0x80114a
  8002d5:	6a 33                	push   $0x33
  8002d7:	68 67 11 80 00       	push   $0x801167
  8002dc:	e8 e7 00 00 00       	call   8003c8 <_panic>

008002e1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	57                   	push   %edi
  8002e5:	56                   	push   %esi
  8002e6:	53                   	push   %ebx
  8002e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002fa:	89 df                	mov    %ebx,%edi
  8002fc:	89 de                	mov    %ebx,%esi
  8002fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800300:	85 c0                	test   %eax,%eax
  800302:	7f 08                	jg     80030c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800307:	5b                   	pop    %ebx
  800308:	5e                   	pop    %esi
  800309:	5f                   	pop    %edi
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80030c:	83 ec 0c             	sub    $0xc,%esp
  80030f:	50                   	push   %eax
  800310:	6a 0a                	push   $0xa
  800312:	68 4a 11 80 00       	push   $0x80114a
  800317:	6a 33                	push   $0x33
  800319:	68 67 11 80 00       	push   $0x801167
  80031e:	e8 a5 00 00 00       	call   8003c8 <_panic>

00800323 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	57                   	push   %edi
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
	asm volatile("int %1\n"
  800329:	8b 55 08             	mov    0x8(%ebp),%edx
  80032c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800334:	be 00 00 00 00       	mov    $0x0,%esi
  800339:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80033c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80033f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800341:	5b                   	pop    %ebx
  800342:	5e                   	pop    %esi
  800343:	5f                   	pop    %edi
  800344:	5d                   	pop    %ebp
  800345:	c3                   	ret    

00800346 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	57                   	push   %edi
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
  80034c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80034f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800354:	8b 55 08             	mov    0x8(%ebp),%edx
  800357:	b8 0e 00 00 00       	mov    $0xe,%eax
  80035c:	89 cb                	mov    %ecx,%ebx
  80035e:	89 cf                	mov    %ecx,%edi
  800360:	89 ce                	mov    %ecx,%esi
  800362:	cd 30                	int    $0x30
	if(check && ret > 0)
  800364:	85 c0                	test   %eax,%eax
  800366:	7f 08                	jg     800370 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800368:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036b:	5b                   	pop    %ebx
  80036c:	5e                   	pop    %esi
  80036d:	5f                   	pop    %edi
  80036e:	5d                   	pop    %ebp
  80036f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	6a 0e                	push   $0xe
  800376:	68 4a 11 80 00       	push   $0x80114a
  80037b:	6a 33                	push   $0x33
  80037d:	68 67 11 80 00       	push   $0x801167
  800382:	e8 41 00 00 00       	call   8003c8 <_panic>

00800387 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	57                   	push   %edi
  80038b:	56                   	push   %esi
  80038c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80038d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800392:	8b 55 08             	mov    0x8(%ebp),%edx
  800395:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800398:	b8 0f 00 00 00       	mov    $0xf,%eax
  80039d:	89 df                	mov    %ebx,%edi
  80039f:	89 de                	mov    %ebx,%esi
  8003a1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003a3:	5b                   	pop    %ebx
  8003a4:	5e                   	pop    %esi
  8003a5:	5f                   	pop    %edi
  8003a6:	5d                   	pop    %ebp
  8003a7:	c3                   	ret    

008003a8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	57                   	push   %edi
  8003ac:	56                   	push   %esi
  8003ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8003bb:	89 cb                	mov    %ecx,%ebx
  8003bd:	89 cf                	mov    %ecx,%edi
  8003bf:	89 ce                	mov    %ecx,%esi
  8003c1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003c3:	5b                   	pop    %ebx
  8003c4:	5e                   	pop    %esi
  8003c5:	5f                   	pop    %edi
  8003c6:	5d                   	pop    %ebp
  8003c7:	c3                   	ret    

008003c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	56                   	push   %esi
  8003cc:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003cd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003d0:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003d6:	e8 3c fd ff ff       	call   800117 <sys_getenvid>
  8003db:	83 ec 0c             	sub    $0xc,%esp
  8003de:	ff 75 0c             	pushl  0xc(%ebp)
  8003e1:	ff 75 08             	pushl  0x8(%ebp)
  8003e4:	56                   	push   %esi
  8003e5:	50                   	push   %eax
  8003e6:	68 78 11 80 00       	push   $0x801178
  8003eb:	e8 b3 00 00 00       	call   8004a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003f0:	83 c4 18             	add    $0x18,%esp
  8003f3:	53                   	push   %ebx
  8003f4:	ff 75 10             	pushl  0x10(%ebp)
  8003f7:	e8 56 00 00 00       	call   800452 <vcprintf>
	cprintf("\n");
  8003fc:	c7 04 24 9b 11 80 00 	movl   $0x80119b,(%esp)
  800403:	e8 9b 00 00 00       	call   8004a3 <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80040b:	cc                   	int3   
  80040c:	eb fd                	jmp    80040b <_panic+0x43>

0080040e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	53                   	push   %ebx
  800412:	83 ec 04             	sub    $0x4,%esp
  800415:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800418:	8b 13                	mov    (%ebx),%edx
  80041a:	8d 42 01             	lea    0x1(%edx),%eax
  80041d:	89 03                	mov    %eax,(%ebx)
  80041f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800422:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800426:	3d ff 00 00 00       	cmp    $0xff,%eax
  80042b:	74 09                	je     800436 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80042d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800431:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800434:	c9                   	leave  
  800435:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	68 ff 00 00 00       	push   $0xff
  80043e:	8d 43 08             	lea    0x8(%ebx),%eax
  800441:	50                   	push   %eax
  800442:	e8 52 fc ff ff       	call   800099 <sys_cputs>
		b->idx = 0;
  800447:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	eb db                	jmp    80042d <putch+0x1f>

00800452 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
  800455:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80045b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800462:	00 00 00 
	b.cnt = 0;
  800465:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80046c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80046f:	ff 75 0c             	pushl  0xc(%ebp)
  800472:	ff 75 08             	pushl  0x8(%ebp)
  800475:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80047b:	50                   	push   %eax
  80047c:	68 0e 04 80 00       	push   $0x80040e
  800481:	e8 4a 01 00 00       	call   8005d0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800486:	83 c4 08             	add    $0x8,%esp
  800489:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80048f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800495:	50                   	push   %eax
  800496:	e8 fe fb ff ff       	call   800099 <sys_cputs>

	return b.cnt;
}
  80049b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004ac:	50                   	push   %eax
  8004ad:	ff 75 08             	pushl  0x8(%ebp)
  8004b0:	e8 9d ff ff ff       	call   800452 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	57                   	push   %edi
  8004bb:	56                   	push   %esi
  8004bc:	53                   	push   %ebx
  8004bd:	83 ec 1c             	sub    $0x1c,%esp
  8004c0:	89 c6                	mov    %eax,%esi
  8004c2:	89 d7                	mov    %edx,%edi
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004d6:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004da:	74 2c                	je     800508 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004df:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004f1:	73 43                	jae    800536 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004f3:	83 eb 01             	sub    $0x1,%ebx
  8004f6:	85 db                	test   %ebx,%ebx
  8004f8:	7e 6c                	jle    800566 <printnum+0xaf>
			putch(padc, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	57                   	push   %edi
  8004fe:	ff 75 18             	pushl  0x18(%ebp)
  800501:	ff d6                	call   *%esi
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb eb                	jmp    8004f3 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	6a 20                	push   $0x20
  80050d:	6a 00                	push   $0x0
  80050f:	50                   	push   %eax
  800510:	ff 75 e4             	pushl  -0x1c(%ebp)
  800513:	ff 75 e0             	pushl  -0x20(%ebp)
  800516:	89 fa                	mov    %edi,%edx
  800518:	89 f0                	mov    %esi,%eax
  80051a:	e8 98 ff ff ff       	call   8004b7 <printnum>
		while (--width > 0)
  80051f:	83 c4 20             	add    $0x20,%esp
  800522:	83 eb 01             	sub    $0x1,%ebx
  800525:	85 db                	test   %ebx,%ebx
  800527:	7e 65                	jle    80058e <printnum+0xd7>
			putch(padc, putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	57                   	push   %edi
  80052d:	6a 20                	push   $0x20
  80052f:	ff d6                	call   *%esi
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	eb ec                	jmp    800522 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800536:	83 ec 0c             	sub    $0xc,%esp
  800539:	ff 75 18             	pushl  0x18(%ebp)
  80053c:	83 eb 01             	sub    $0x1,%ebx
  80053f:	53                   	push   %ebx
  800540:	50                   	push   %eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 dc             	pushl  -0x24(%ebp)
  800547:	ff 75 d8             	pushl  -0x28(%ebp)
  80054a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80054d:	ff 75 e0             	pushl  -0x20(%ebp)
  800550:	e8 9b 09 00 00       	call   800ef0 <__udivdi3>
  800555:	83 c4 18             	add    $0x18,%esp
  800558:	52                   	push   %edx
  800559:	50                   	push   %eax
  80055a:	89 fa                	mov    %edi,%edx
  80055c:	89 f0                	mov    %esi,%eax
  80055e:	e8 54 ff ff ff       	call   8004b7 <printnum>
  800563:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	57                   	push   %edi
  80056a:	83 ec 04             	sub    $0x4,%esp
  80056d:	ff 75 dc             	pushl  -0x24(%ebp)
  800570:	ff 75 d8             	pushl  -0x28(%ebp)
  800573:	ff 75 e4             	pushl  -0x1c(%ebp)
  800576:	ff 75 e0             	pushl  -0x20(%ebp)
  800579:	e8 82 0a 00 00       	call   801000 <__umoddi3>
  80057e:	83 c4 14             	add    $0x14,%esp
  800581:	0f be 80 9d 11 80 00 	movsbl 0x80119d(%eax),%eax
  800588:	50                   	push   %eax
  800589:	ff d6                	call   *%esi
  80058b:	83 c4 10             	add    $0x10,%esp
}
  80058e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800591:	5b                   	pop    %ebx
  800592:	5e                   	pop    %esi
  800593:	5f                   	pop    %edi
  800594:	5d                   	pop    %ebp
  800595:	c3                   	ret    

00800596 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80059c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005a0:	8b 10                	mov    (%eax),%edx
  8005a2:	3b 50 04             	cmp    0x4(%eax),%edx
  8005a5:	73 0a                	jae    8005b1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005aa:	89 08                	mov    %ecx,(%eax)
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	88 02                	mov    %al,(%edx)
}
  8005b1:	5d                   	pop    %ebp
  8005b2:	c3                   	ret    

008005b3 <printfmt>:
{
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005b9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005bc:	50                   	push   %eax
  8005bd:	ff 75 10             	pushl  0x10(%ebp)
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 05 00 00 00       	call   8005d0 <vprintfmt>
}
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <vprintfmt>:
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	57                   	push   %edi
  8005d4:	56                   	push   %esi
  8005d5:	53                   	push   %ebx
  8005d6:	83 ec 3c             	sub    $0x3c,%esp
  8005d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8005dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005df:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005e2:	e9 b4 03 00 00       	jmp    80099b <vprintfmt+0x3cb>
		padc = ' ';
  8005e7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8005eb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8005f2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005f9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800600:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800607:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060c:	8d 47 01             	lea    0x1(%edi),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	0f b6 17             	movzbl (%edi),%edx
  800615:	8d 42 dd             	lea    -0x23(%edx),%eax
  800618:	3c 55                	cmp    $0x55,%al
  80061a:	0f 87 c8 04 00 00    	ja     800ae8 <vprintfmt+0x518>
  800620:	0f b6 c0             	movzbl %al,%eax
  800623:	ff 24 85 80 13 80 00 	jmp    *0x801380(,%eax,4)
  80062a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80062d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800634:	eb d6                	jmp    80060c <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800636:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800639:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80063d:	eb cd                	jmp    80060c <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80063f:	0f b6 d2             	movzbl %dl,%edx
  800642:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800645:	b8 00 00 00 00       	mov    $0x0,%eax
  80064a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80064d:	eb 0c                	jmp    80065b <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80064f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800652:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800656:	eb b4                	jmp    80060c <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800658:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80065b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80065e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800662:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800665:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800668:	83 f9 09             	cmp    $0x9,%ecx
  80066b:	76 eb                	jbe    800658 <vprintfmt+0x88>
  80066d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800670:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800673:	eb 14                	jmp    800689 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 40 04             	lea    0x4(%eax),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800686:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800689:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068d:	0f 89 79 ff ff ff    	jns    80060c <vprintfmt+0x3c>
				width = precision, precision = -1;
  800693:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800696:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800699:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006a0:	e9 67 ff ff ff       	jmp    80060c <vprintfmt+0x3c>
  8006a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a8:	85 c0                	test   %eax,%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8006af:	0f 49 d0             	cmovns %eax,%edx
  8006b2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006b8:	e9 4f ff ff ff       	jmp    80060c <vprintfmt+0x3c>
  8006bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006c0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006c7:	e9 40 ff ff ff       	jmp    80060c <vprintfmt+0x3c>
			lflag++;
  8006cc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006d2:	e9 35 ff ff ff       	jmp    80060c <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 78 04             	lea    0x4(%eax),%edi
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	ff 30                	pushl  (%eax)
  8006e3:	ff d6                	call   *%esi
			break;
  8006e5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006e8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006eb:	e9 a8 02 00 00       	jmp    800998 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 78 04             	lea    0x4(%eax),%edi
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	99                   	cltd   
  8006f9:	31 d0                	xor    %edx,%eax
  8006fb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006fd:	83 f8 0f             	cmp    $0xf,%eax
  800700:	7f 23                	jg     800725 <vprintfmt+0x155>
  800702:	8b 14 85 e0 14 80 00 	mov    0x8014e0(,%eax,4),%edx
  800709:	85 d2                	test   %edx,%edx
  80070b:	74 18                	je     800725 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80070d:	52                   	push   %edx
  80070e:	68 be 11 80 00       	push   $0x8011be
  800713:	53                   	push   %ebx
  800714:	56                   	push   %esi
  800715:	e8 99 fe ff ff       	call   8005b3 <printfmt>
  80071a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80071d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800720:	e9 73 02 00 00       	jmp    800998 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800725:	50                   	push   %eax
  800726:	68 b5 11 80 00       	push   $0x8011b5
  80072b:	53                   	push   %ebx
  80072c:	56                   	push   %esi
  80072d:	e8 81 fe ff ff       	call   8005b3 <printfmt>
  800732:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800735:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800738:	e9 5b 02 00 00       	jmp    800998 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	83 c0 04             	add    $0x4,%eax
  800743:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80074b:	85 d2                	test   %edx,%edx
  80074d:	b8 ae 11 80 00       	mov    $0x8011ae,%eax
  800752:	0f 45 c2             	cmovne %edx,%eax
  800755:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800758:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075c:	7e 06                	jle    800764 <vprintfmt+0x194>
  80075e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800762:	75 0d                	jne    800771 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800764:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800767:	89 c7                	mov    %eax,%edi
  800769:	03 45 e0             	add    -0x20(%ebp),%eax
  80076c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076f:	eb 53                	jmp    8007c4 <vprintfmt+0x1f4>
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 d8             	pushl  -0x28(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 13 04 00 00       	call   800b90 <strnlen>
  80077d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800780:	29 c1                	sub    %eax,%ecx
  800782:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80078a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80078e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800791:	eb 0f                	jmp    8007a2 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	53                   	push   %ebx
  800797:	ff 75 e0             	pushl  -0x20(%ebp)
  80079a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80079c:	83 ef 01             	sub    $0x1,%edi
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	85 ff                	test   %edi,%edi
  8007a4:	7f ed                	jg     800793 <vprintfmt+0x1c3>
  8007a6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007a9:	85 d2                	test   %edx,%edx
  8007ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b0:	0f 49 c2             	cmovns %edx,%eax
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007b8:	eb aa                	jmp    800764 <vprintfmt+0x194>
					putch(ch, putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	53                   	push   %ebx
  8007be:	52                   	push   %edx
  8007bf:	ff d6                	call   *%esi
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007c7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c9:	83 c7 01             	add    $0x1,%edi
  8007cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d0:	0f be d0             	movsbl %al,%edx
  8007d3:	85 d2                	test   %edx,%edx
  8007d5:	74 4b                	je     800822 <vprintfmt+0x252>
  8007d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007db:	78 06                	js     8007e3 <vprintfmt+0x213>
  8007dd:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007e1:	78 1e                	js     800801 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8007e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007e7:	74 d1                	je     8007ba <vprintfmt+0x1ea>
  8007e9:	0f be c0             	movsbl %al,%eax
  8007ec:	83 e8 20             	sub    $0x20,%eax
  8007ef:	83 f8 5e             	cmp    $0x5e,%eax
  8007f2:	76 c6                	jbe    8007ba <vprintfmt+0x1ea>
					putch('?', putdat);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	53                   	push   %ebx
  8007f8:	6a 3f                	push   $0x3f
  8007fa:	ff d6                	call   *%esi
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	eb c3                	jmp    8007c4 <vprintfmt+0x1f4>
  800801:	89 cf                	mov    %ecx,%edi
  800803:	eb 0e                	jmp    800813 <vprintfmt+0x243>
				putch(' ', putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	6a 20                	push   $0x20
  80080b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80080d:	83 ef 01             	sub    $0x1,%edi
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	85 ff                	test   %edi,%edi
  800815:	7f ee                	jg     800805 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800817:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	e9 76 01 00 00       	jmp    800998 <vprintfmt+0x3c8>
  800822:	89 cf                	mov    %ecx,%edi
  800824:	eb ed                	jmp    800813 <vprintfmt+0x243>
	if (lflag >= 2)
  800826:	83 f9 01             	cmp    $0x1,%ecx
  800829:	7f 1f                	jg     80084a <vprintfmt+0x27a>
	else if (lflag)
  80082b:	85 c9                	test   %ecx,%ecx
  80082d:	74 6a                	je     800899 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800837:	89 c1                	mov    %eax,%ecx
  800839:	c1 f9 1f             	sar    $0x1f,%ecx
  80083c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8d 40 04             	lea    0x4(%eax),%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
  800848:	eb 17                	jmp    800861 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8b 50 04             	mov    0x4(%eax),%edx
  800850:	8b 00                	mov    (%eax),%eax
  800852:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800855:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8d 40 08             	lea    0x8(%eax),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800861:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800864:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800869:	85 d2                	test   %edx,%edx
  80086b:	0f 89 f8 00 00 00    	jns    800969 <vprintfmt+0x399>
				putch('-', putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	53                   	push   %ebx
  800875:	6a 2d                	push   $0x2d
  800877:	ff d6                	call   *%esi
				num = -(long long) num;
  800879:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80087c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80087f:	f7 d8                	neg    %eax
  800881:	83 d2 00             	adc    $0x0,%edx
  800884:	f7 da                	neg    %edx
  800886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800889:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80088f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800894:	e9 e1 00 00 00       	jmp    80097a <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a1:	99                   	cltd   
  8008a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 40 04             	lea    0x4(%eax),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	eb b1                	jmp    800861 <vprintfmt+0x291>
	if (lflag >= 2)
  8008b0:	83 f9 01             	cmp    $0x1,%ecx
  8008b3:	7f 27                	jg     8008dc <vprintfmt+0x30c>
	else if (lflag)
  8008b5:	85 c9                	test   %ecx,%ecx
  8008b7:	74 41                	je     8008fa <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8d 40 04             	lea    0x4(%eax),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008d2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008d7:	e9 8d 00 00 00       	jmp    800969 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8b 50 04             	mov    0x4(%eax),%edx
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ed:	8d 40 08             	lea    0x8(%eax),%eax
  8008f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008f8:	eb 6f                	jmp    800969 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800904:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800907:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	8d 40 04             	lea    0x4(%eax),%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800913:	bf 0a 00 00 00       	mov    $0xa,%edi
  800918:	eb 4f                	jmp    800969 <vprintfmt+0x399>
	if (lflag >= 2)
  80091a:	83 f9 01             	cmp    $0x1,%ecx
  80091d:	7f 23                	jg     800942 <vprintfmt+0x372>
	else if (lflag)
  80091f:	85 c9                	test   %ecx,%ecx
  800921:	0f 84 98 00 00 00    	je     8009bf <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	ba 00 00 00 00       	mov    $0x0,%edx
  800931:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800934:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	8d 40 04             	lea    0x4(%eax),%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	eb 17                	jmp    800959 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8b 50 04             	mov    0x4(%eax),%edx
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8d 40 08             	lea    0x8(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	53                   	push   %ebx
  80095d:	6a 30                	push   $0x30
  80095f:	ff d6                	call   *%esi
			goto number;
  800961:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800964:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800969:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80096d:	74 0b                	je     80097a <vprintfmt+0x3aa>
				putch('+', putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	53                   	push   %ebx
  800973:	6a 2b                	push   $0x2b
  800975:	ff d6                	call   *%esi
  800977:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	ff 75 e0             	pushl  -0x20(%ebp)
  800985:	57                   	push   %edi
  800986:	ff 75 dc             	pushl  -0x24(%ebp)
  800989:	ff 75 d8             	pushl  -0x28(%ebp)
  80098c:	89 da                	mov    %ebx,%edx
  80098e:	89 f0                	mov    %esi,%eax
  800990:	e8 22 fb ff ff       	call   8004b7 <printnum>
			break;
  800995:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800998:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099b:	83 c7 01             	add    $0x1,%edi
  80099e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009a2:	83 f8 25             	cmp    $0x25,%eax
  8009a5:	0f 84 3c fc ff ff    	je     8005e7 <vprintfmt+0x17>
			if (ch == '\0')
  8009ab:	85 c0                	test   %eax,%eax
  8009ad:	0f 84 55 01 00 00    	je     800b08 <vprintfmt+0x538>
			putch(ch, putdat);
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	53                   	push   %ebx
  8009b7:	50                   	push   %eax
  8009b8:	ff d6                	call   *%esi
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	eb dc                	jmp    80099b <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	8b 00                	mov    (%eax),%eax
  8009c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8d 40 04             	lea    0x4(%eax),%eax
  8009d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d8:	e9 7c ff ff ff       	jmp    800959 <vprintfmt+0x389>
			putch('0', putdat);
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	53                   	push   %ebx
  8009e1:	6a 30                	push   $0x30
  8009e3:	ff d6                	call   *%esi
			putch('x', putdat);
  8009e5:	83 c4 08             	add    $0x8,%esp
  8009e8:	53                   	push   %ebx
  8009e9:	6a 78                	push   $0x78
  8009eb:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009fd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	8d 40 04             	lea    0x4(%eax),%eax
  800a06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a09:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a0e:	e9 56 ff ff ff       	jmp    800969 <vprintfmt+0x399>
	if (lflag >= 2)
  800a13:	83 f9 01             	cmp    $0x1,%ecx
  800a16:	7f 27                	jg     800a3f <vprintfmt+0x46f>
	else if (lflag)
  800a18:	85 c9                	test   %ecx,%ecx
  800a1a:	74 44                	je     800a60 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	ba 00 00 00 00       	mov    $0x0,%edx
  800a26:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a29:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	8d 40 04             	lea    0x4(%eax),%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a35:	bf 10 00 00 00       	mov    $0x10,%edi
  800a3a:	e9 2a ff ff ff       	jmp    800969 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	8b 50 04             	mov    0x4(%eax),%edx
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	8d 40 08             	lea    0x8(%eax),%eax
  800a53:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a56:	bf 10 00 00 00       	mov    $0x10,%edi
  800a5b:	e9 09 ff ff ff       	jmp    800969 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	8b 00                	mov    (%eax),%eax
  800a65:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a6d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a70:	8b 45 14             	mov    0x14(%ebp),%eax
  800a73:	8d 40 04             	lea    0x4(%eax),%eax
  800a76:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a79:	bf 10 00 00 00       	mov    $0x10,%edi
  800a7e:	e9 e6 fe ff ff       	jmp    800969 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	8d 78 04             	lea    0x4(%eax),%edi
  800a89:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800a8b:	85 c0                	test   %eax,%eax
  800a8d:	74 2d                	je     800abc <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800a8f:	0f b6 13             	movzbl (%ebx),%edx
  800a92:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a94:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800a97:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a9a:	0f 8e f8 fe ff ff    	jle    800998 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800aa0:	68 0c 13 80 00       	push   $0x80130c
  800aa5:	68 be 11 80 00       	push   $0x8011be
  800aaa:	53                   	push   %ebx
  800aab:	56                   	push   %esi
  800aac:	e8 02 fb ff ff       	call   8005b3 <printfmt>
  800ab1:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ab4:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ab7:	e9 dc fe ff ff       	jmp    800998 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800abc:	68 d4 12 80 00       	push   $0x8012d4
  800ac1:	68 be 11 80 00       	push   $0x8011be
  800ac6:	53                   	push   %ebx
  800ac7:	56                   	push   %esi
  800ac8:	e8 e6 fa ff ff       	call   8005b3 <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ad0:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ad3:	e9 c0 fe ff ff       	jmp    800998 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	53                   	push   %ebx
  800adc:	6a 25                	push   $0x25
  800ade:	ff d6                	call   *%esi
			break;
  800ae0:	83 c4 10             	add    $0x10,%esp
  800ae3:	e9 b0 fe ff ff       	jmp    800998 <vprintfmt+0x3c8>
			putch('%', putdat);
  800ae8:	83 ec 08             	sub    $0x8,%esp
  800aeb:	53                   	push   %ebx
  800aec:	6a 25                	push   $0x25
  800aee:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	89 f8                	mov    %edi,%eax
  800af5:	eb 03                	jmp    800afa <vprintfmt+0x52a>
  800af7:	83 e8 01             	sub    $0x1,%eax
  800afa:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800afe:	75 f7                	jne    800af7 <vprintfmt+0x527>
  800b00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b03:	e9 90 fe ff ff       	jmp    800998 <vprintfmt+0x3c8>
}
  800b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5f                   	pop    %edi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 18             	sub    $0x18,%esp
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b23:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b2d:	85 c0                	test   %eax,%eax
  800b2f:	74 26                	je     800b57 <vsnprintf+0x47>
  800b31:	85 d2                	test   %edx,%edx
  800b33:	7e 22                	jle    800b57 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b35:	ff 75 14             	pushl  0x14(%ebp)
  800b38:	ff 75 10             	pushl  0x10(%ebp)
  800b3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b3e:	50                   	push   %eax
  800b3f:	68 96 05 80 00       	push   $0x800596
  800b44:	e8 87 fa ff ff       	call   8005d0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b4c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b52:	83 c4 10             	add    $0x10,%esp
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    
		return -E_INVAL;
  800b57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b5c:	eb f7                	jmp    800b55 <vsnprintf+0x45>

00800b5e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b64:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b67:	50                   	push   %eax
  800b68:	ff 75 10             	pushl  0x10(%ebp)
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 9a ff ff ff       	call   800b10 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b87:	74 05                	je     800b8e <strlen+0x16>
		n++;
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	eb f5                	jmp    800b83 <strlen+0xb>
	return n;
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b99:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9e:	39 c2                	cmp    %eax,%edx
  800ba0:	74 0d                	je     800baf <strnlen+0x1f>
  800ba2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ba6:	74 05                	je     800bad <strnlen+0x1d>
		n++;
  800ba8:	83 c2 01             	add    $0x1,%edx
  800bab:	eb f1                	jmp    800b9e <strnlen+0xe>
  800bad:	89 d0                	mov    %edx,%eax
	return n;
}
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	53                   	push   %ebx
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bc4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bc7:	83 c2 01             	add    $0x1,%edx
  800bca:	84 c9                	test   %cl,%cl
  800bcc:	75 f2                	jne    800bc0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	53                   	push   %ebx
  800bd5:	83 ec 10             	sub    $0x10,%esp
  800bd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bdb:	53                   	push   %ebx
  800bdc:	e8 97 ff ff ff       	call   800b78 <strlen>
  800be1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	01 d8                	add    %ebx,%eax
  800be9:	50                   	push   %eax
  800bea:	e8 c2 ff ff ff       	call   800bb1 <strcpy>
	return dst;
}
  800bef:	89 d8                	mov    %ebx,%eax
  800bf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c01:	89 c6                	mov    %eax,%esi
  800c03:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c06:	89 c2                	mov    %eax,%edx
  800c08:	39 f2                	cmp    %esi,%edx
  800c0a:	74 11                	je     800c1d <strncpy+0x27>
		*dst++ = *src;
  800c0c:	83 c2 01             	add    $0x1,%edx
  800c0f:	0f b6 19             	movzbl (%ecx),%ebx
  800c12:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c15:	80 fb 01             	cmp    $0x1,%bl
  800c18:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c1b:	eb eb                	jmp    800c08 <strncpy+0x12>
	}
	return ret;
}
  800c1d:	5b                   	pop    %ebx
  800c1e:	5e                   	pop    %esi
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
  800c26:	8b 75 08             	mov    0x8(%ebp),%esi
  800c29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2c:	8b 55 10             	mov    0x10(%ebp),%edx
  800c2f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c31:	85 d2                	test   %edx,%edx
  800c33:	74 21                	je     800c56 <strlcpy+0x35>
  800c35:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c39:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c3b:	39 c2                	cmp    %eax,%edx
  800c3d:	74 14                	je     800c53 <strlcpy+0x32>
  800c3f:	0f b6 19             	movzbl (%ecx),%ebx
  800c42:	84 db                	test   %bl,%bl
  800c44:	74 0b                	je     800c51 <strlcpy+0x30>
			*dst++ = *src++;
  800c46:	83 c1 01             	add    $0x1,%ecx
  800c49:	83 c2 01             	add    $0x1,%edx
  800c4c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c4f:	eb ea                	jmp    800c3b <strlcpy+0x1a>
  800c51:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c53:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c56:	29 f0                	sub    %esi,%eax
}
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c65:	0f b6 01             	movzbl (%ecx),%eax
  800c68:	84 c0                	test   %al,%al
  800c6a:	74 0c                	je     800c78 <strcmp+0x1c>
  800c6c:	3a 02                	cmp    (%edx),%al
  800c6e:	75 08                	jne    800c78 <strcmp+0x1c>
		p++, q++;
  800c70:	83 c1 01             	add    $0x1,%ecx
  800c73:	83 c2 01             	add    $0x1,%edx
  800c76:	eb ed                	jmp    800c65 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c78:	0f b6 c0             	movzbl %al,%eax
  800c7b:	0f b6 12             	movzbl (%edx),%edx
  800c7e:	29 d0                	sub    %edx,%eax
}
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	53                   	push   %ebx
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8c:	89 c3                	mov    %eax,%ebx
  800c8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c91:	eb 06                	jmp    800c99 <strncmp+0x17>
		n--, p++, q++;
  800c93:	83 c0 01             	add    $0x1,%eax
  800c96:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c99:	39 d8                	cmp    %ebx,%eax
  800c9b:	74 16                	je     800cb3 <strncmp+0x31>
  800c9d:	0f b6 08             	movzbl (%eax),%ecx
  800ca0:	84 c9                	test   %cl,%cl
  800ca2:	74 04                	je     800ca8 <strncmp+0x26>
  800ca4:	3a 0a                	cmp    (%edx),%cl
  800ca6:	74 eb                	je     800c93 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca8:	0f b6 00             	movzbl (%eax),%eax
  800cab:	0f b6 12             	movzbl (%edx),%edx
  800cae:	29 d0                	sub    %edx,%eax
}
  800cb0:	5b                   	pop    %ebx
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    
		return 0;
  800cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb8:	eb f6                	jmp    800cb0 <strncmp+0x2e>

00800cba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc4:	0f b6 10             	movzbl (%eax),%edx
  800cc7:	84 d2                	test   %dl,%dl
  800cc9:	74 09                	je     800cd4 <strchr+0x1a>
		if (*s == c)
  800ccb:	38 ca                	cmp    %cl,%dl
  800ccd:	74 0a                	je     800cd9 <strchr+0x1f>
	for (; *s; s++)
  800ccf:	83 c0 01             	add    $0x1,%eax
  800cd2:	eb f0                	jmp    800cc4 <strchr+0xa>
			return (char *) s;
	return 0;
  800cd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ce8:	38 ca                	cmp    %cl,%dl
  800cea:	74 09                	je     800cf5 <strfind+0x1a>
  800cec:	84 d2                	test   %dl,%dl
  800cee:	74 05                	je     800cf5 <strfind+0x1a>
	for (; *s; s++)
  800cf0:	83 c0 01             	add    $0x1,%eax
  800cf3:	eb f0                	jmp    800ce5 <strfind+0xa>
			break;
	return (char *) s;
}
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d03:	85 c9                	test   %ecx,%ecx
  800d05:	74 31                	je     800d38 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d07:	89 f8                	mov    %edi,%eax
  800d09:	09 c8                	or     %ecx,%eax
  800d0b:	a8 03                	test   $0x3,%al
  800d0d:	75 23                	jne    800d32 <memset+0x3b>
		c &= 0xFF;
  800d0f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d13:	89 d3                	mov    %edx,%ebx
  800d15:	c1 e3 08             	shl    $0x8,%ebx
  800d18:	89 d0                	mov    %edx,%eax
  800d1a:	c1 e0 18             	shl    $0x18,%eax
  800d1d:	89 d6                	mov    %edx,%esi
  800d1f:	c1 e6 10             	shl    $0x10,%esi
  800d22:	09 f0                	or     %esi,%eax
  800d24:	09 c2                	or     %eax,%edx
  800d26:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d28:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d2b:	89 d0                	mov    %edx,%eax
  800d2d:	fc                   	cld    
  800d2e:	f3 ab                	rep stos %eax,%es:(%edi)
  800d30:	eb 06                	jmp    800d38 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	fc                   	cld    
  800d36:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d38:	89 f8                	mov    %edi,%eax
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d4d:	39 c6                	cmp    %eax,%esi
  800d4f:	73 32                	jae    800d83 <memmove+0x44>
  800d51:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d54:	39 c2                	cmp    %eax,%edx
  800d56:	76 2b                	jbe    800d83 <memmove+0x44>
		s += n;
		d += n;
  800d58:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d5b:	89 fe                	mov    %edi,%esi
  800d5d:	09 ce                	or     %ecx,%esi
  800d5f:	09 d6                	or     %edx,%esi
  800d61:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d67:	75 0e                	jne    800d77 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d69:	83 ef 04             	sub    $0x4,%edi
  800d6c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d6f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d72:	fd                   	std    
  800d73:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d75:	eb 09                	jmp    800d80 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d77:	83 ef 01             	sub    $0x1,%edi
  800d7a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d7d:	fd                   	std    
  800d7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d80:	fc                   	cld    
  800d81:	eb 1a                	jmp    800d9d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d83:	89 c2                	mov    %eax,%edx
  800d85:	09 ca                	or     %ecx,%edx
  800d87:	09 f2                	or     %esi,%edx
  800d89:	f6 c2 03             	test   $0x3,%dl
  800d8c:	75 0a                	jne    800d98 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d8e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d91:	89 c7                	mov    %eax,%edi
  800d93:	fc                   	cld    
  800d94:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d96:	eb 05                	jmp    800d9d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d98:	89 c7                	mov    %eax,%edi
  800d9a:	fc                   	cld    
  800d9b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800da7:	ff 75 10             	pushl  0x10(%ebp)
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 8a ff ff ff       	call   800d3f <memmove>
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc2:	89 c6                	mov    %eax,%esi
  800dc4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dc7:	39 f0                	cmp    %esi,%eax
  800dc9:	74 1c                	je     800de7 <memcmp+0x30>
		if (*s1 != *s2)
  800dcb:	0f b6 08             	movzbl (%eax),%ecx
  800dce:	0f b6 1a             	movzbl (%edx),%ebx
  800dd1:	38 d9                	cmp    %bl,%cl
  800dd3:	75 08                	jne    800ddd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dd5:	83 c0 01             	add    $0x1,%eax
  800dd8:	83 c2 01             	add    $0x1,%edx
  800ddb:	eb ea                	jmp    800dc7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ddd:	0f b6 c1             	movzbl %cl,%eax
  800de0:	0f b6 db             	movzbl %bl,%ebx
  800de3:	29 d8                	sub    %ebx,%eax
  800de5:	eb 05                	jmp    800dec <memcmp+0x35>
	}

	return 0;
  800de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dec:	5b                   	pop    %ebx
  800ded:	5e                   	pop    %esi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800df9:	89 c2                	mov    %eax,%edx
  800dfb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dfe:	39 d0                	cmp    %edx,%eax
  800e00:	73 09                	jae    800e0b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e02:	38 08                	cmp    %cl,(%eax)
  800e04:	74 05                	je     800e0b <memfind+0x1b>
	for (; s < ends; s++)
  800e06:	83 c0 01             	add    $0x1,%eax
  800e09:	eb f3                	jmp    800dfe <memfind+0xe>
			break;
	return (void *) s;
}
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e19:	eb 03                	jmp    800e1e <strtol+0x11>
		s++;
  800e1b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e1e:	0f b6 01             	movzbl (%ecx),%eax
  800e21:	3c 20                	cmp    $0x20,%al
  800e23:	74 f6                	je     800e1b <strtol+0xe>
  800e25:	3c 09                	cmp    $0x9,%al
  800e27:	74 f2                	je     800e1b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e29:	3c 2b                	cmp    $0x2b,%al
  800e2b:	74 2a                	je     800e57 <strtol+0x4a>
	int neg = 0;
  800e2d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e32:	3c 2d                	cmp    $0x2d,%al
  800e34:	74 2b                	je     800e61 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e36:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e3c:	75 0f                	jne    800e4d <strtol+0x40>
  800e3e:	80 39 30             	cmpb   $0x30,(%ecx)
  800e41:	74 28                	je     800e6b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e43:	85 db                	test   %ebx,%ebx
  800e45:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4a:	0f 44 d8             	cmove  %eax,%ebx
  800e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e52:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e55:	eb 50                	jmp    800ea7 <strtol+0x9a>
		s++;
  800e57:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e5a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e5f:	eb d5                	jmp    800e36 <strtol+0x29>
		s++, neg = 1;
  800e61:	83 c1 01             	add    $0x1,%ecx
  800e64:	bf 01 00 00 00       	mov    $0x1,%edi
  800e69:	eb cb                	jmp    800e36 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e6b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e6f:	74 0e                	je     800e7f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e71:	85 db                	test   %ebx,%ebx
  800e73:	75 d8                	jne    800e4d <strtol+0x40>
		s++, base = 8;
  800e75:	83 c1 01             	add    $0x1,%ecx
  800e78:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e7d:	eb ce                	jmp    800e4d <strtol+0x40>
		s += 2, base = 16;
  800e7f:	83 c1 02             	add    $0x2,%ecx
  800e82:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e87:	eb c4                	jmp    800e4d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e89:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e8c:	89 f3                	mov    %esi,%ebx
  800e8e:	80 fb 19             	cmp    $0x19,%bl
  800e91:	77 29                	ja     800ebc <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e93:	0f be d2             	movsbl %dl,%edx
  800e96:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e99:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e9c:	7d 30                	jge    800ece <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e9e:	83 c1 01             	add    $0x1,%ecx
  800ea1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ea5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ea7:	0f b6 11             	movzbl (%ecx),%edx
  800eaa:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ead:	89 f3                	mov    %esi,%ebx
  800eaf:	80 fb 09             	cmp    $0x9,%bl
  800eb2:	77 d5                	ja     800e89 <strtol+0x7c>
			dig = *s - '0';
  800eb4:	0f be d2             	movsbl %dl,%edx
  800eb7:	83 ea 30             	sub    $0x30,%edx
  800eba:	eb dd                	jmp    800e99 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ebc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ebf:	89 f3                	mov    %esi,%ebx
  800ec1:	80 fb 19             	cmp    $0x19,%bl
  800ec4:	77 08                	ja     800ece <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ec6:	0f be d2             	movsbl %dl,%edx
  800ec9:	83 ea 37             	sub    $0x37,%edx
  800ecc:	eb cb                	jmp    800e99 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ece:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed2:	74 05                	je     800ed9 <strtol+0xcc>
		*endptr = (char *) s;
  800ed4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ed7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ed9:	89 c2                	mov    %eax,%edx
  800edb:	f7 da                	neg    %edx
  800edd:	85 ff                	test   %edi,%edi
  800edf:	0f 45 c2             	cmovne %edx,%eax
}
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
  800ee7:	66 90                	xchg   %ax,%ax
  800ee9:	66 90                	xchg   %ax,%ax
  800eeb:	66 90                	xchg   %ax,%ax
  800eed:	66 90                	xchg   %ax,%ax
  800eef:	90                   	nop

00800ef0 <__udivdi3>:
  800ef0:	55                   	push   %ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
  800ef4:	83 ec 1c             	sub    $0x1c,%esp
  800ef7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800efb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800eff:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f07:	85 d2                	test   %edx,%edx
  800f09:	75 4d                	jne    800f58 <__udivdi3+0x68>
  800f0b:	39 f3                	cmp    %esi,%ebx
  800f0d:	76 19                	jbe    800f28 <__udivdi3+0x38>
  800f0f:	31 ff                	xor    %edi,%edi
  800f11:	89 e8                	mov    %ebp,%eax
  800f13:	89 f2                	mov    %esi,%edx
  800f15:	f7 f3                	div    %ebx
  800f17:	89 fa                	mov    %edi,%edx
  800f19:	83 c4 1c             	add    $0x1c,%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
  800f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f28:	89 d9                	mov    %ebx,%ecx
  800f2a:	85 db                	test   %ebx,%ebx
  800f2c:	75 0b                	jne    800f39 <__udivdi3+0x49>
  800f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f33:	31 d2                	xor    %edx,%edx
  800f35:	f7 f3                	div    %ebx
  800f37:	89 c1                	mov    %eax,%ecx
  800f39:	31 d2                	xor    %edx,%edx
  800f3b:	89 f0                	mov    %esi,%eax
  800f3d:	f7 f1                	div    %ecx
  800f3f:	89 c6                	mov    %eax,%esi
  800f41:	89 e8                	mov    %ebp,%eax
  800f43:	89 f7                	mov    %esi,%edi
  800f45:	f7 f1                	div    %ecx
  800f47:	89 fa                	mov    %edi,%edx
  800f49:	83 c4 1c             	add    $0x1c,%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    
  800f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f58:	39 f2                	cmp    %esi,%edx
  800f5a:	77 1c                	ja     800f78 <__udivdi3+0x88>
  800f5c:	0f bd fa             	bsr    %edx,%edi
  800f5f:	83 f7 1f             	xor    $0x1f,%edi
  800f62:	75 2c                	jne    800f90 <__udivdi3+0xa0>
  800f64:	39 f2                	cmp    %esi,%edx
  800f66:	72 06                	jb     800f6e <__udivdi3+0x7e>
  800f68:	31 c0                	xor    %eax,%eax
  800f6a:	39 eb                	cmp    %ebp,%ebx
  800f6c:	77 a9                	ja     800f17 <__udivdi3+0x27>
  800f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f73:	eb a2                	jmp    800f17 <__udivdi3+0x27>
  800f75:	8d 76 00             	lea    0x0(%esi),%esi
  800f78:	31 ff                	xor    %edi,%edi
  800f7a:	31 c0                	xor    %eax,%eax
  800f7c:	89 fa                	mov    %edi,%edx
  800f7e:	83 c4 1c             	add    $0x1c,%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
  800f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f8d:	8d 76 00             	lea    0x0(%esi),%esi
  800f90:	89 f9                	mov    %edi,%ecx
  800f92:	b8 20 00 00 00       	mov    $0x20,%eax
  800f97:	29 f8                	sub    %edi,%eax
  800f99:	d3 e2                	shl    %cl,%edx
  800f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f9f:	89 c1                	mov    %eax,%ecx
  800fa1:	89 da                	mov    %ebx,%edx
  800fa3:	d3 ea                	shr    %cl,%edx
  800fa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fa9:	09 d1                	or     %edx,%ecx
  800fab:	89 f2                	mov    %esi,%edx
  800fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fb1:	89 f9                	mov    %edi,%ecx
  800fb3:	d3 e3                	shl    %cl,%ebx
  800fb5:	89 c1                	mov    %eax,%ecx
  800fb7:	d3 ea                	shr    %cl,%edx
  800fb9:	89 f9                	mov    %edi,%ecx
  800fbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fbf:	89 eb                	mov    %ebp,%ebx
  800fc1:	d3 e6                	shl    %cl,%esi
  800fc3:	89 c1                	mov    %eax,%ecx
  800fc5:	d3 eb                	shr    %cl,%ebx
  800fc7:	09 de                	or     %ebx,%esi
  800fc9:	89 f0                	mov    %esi,%eax
  800fcb:	f7 74 24 08          	divl   0x8(%esp)
  800fcf:	89 d6                	mov    %edx,%esi
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	f7 64 24 0c          	mull   0xc(%esp)
  800fd7:	39 d6                	cmp    %edx,%esi
  800fd9:	72 15                	jb     800ff0 <__udivdi3+0x100>
  800fdb:	89 f9                	mov    %edi,%ecx
  800fdd:	d3 e5                	shl    %cl,%ebp
  800fdf:	39 c5                	cmp    %eax,%ebp
  800fe1:	73 04                	jae    800fe7 <__udivdi3+0xf7>
  800fe3:	39 d6                	cmp    %edx,%esi
  800fe5:	74 09                	je     800ff0 <__udivdi3+0x100>
  800fe7:	89 d8                	mov    %ebx,%eax
  800fe9:	31 ff                	xor    %edi,%edi
  800feb:	e9 27 ff ff ff       	jmp    800f17 <__udivdi3+0x27>
  800ff0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800ff3:	31 ff                	xor    %edi,%edi
  800ff5:	e9 1d ff ff ff       	jmp    800f17 <__udivdi3+0x27>
  800ffa:	66 90                	xchg   %ax,%ax
  800ffc:	66 90                	xchg   %ax,%ax
  800ffe:	66 90                	xchg   %ax,%ax

00801000 <__umoddi3>:
  801000:	55                   	push   %ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 1c             	sub    $0x1c,%esp
  801007:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80100b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80100f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801017:	89 da                	mov    %ebx,%edx
  801019:	85 c0                	test   %eax,%eax
  80101b:	75 43                	jne    801060 <__umoddi3+0x60>
  80101d:	39 df                	cmp    %ebx,%edi
  80101f:	76 17                	jbe    801038 <__umoddi3+0x38>
  801021:	89 f0                	mov    %esi,%eax
  801023:	f7 f7                	div    %edi
  801025:	89 d0                	mov    %edx,%eax
  801027:	31 d2                	xor    %edx,%edx
  801029:	83 c4 1c             	add    $0x1c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801038:	89 fd                	mov    %edi,%ebp
  80103a:	85 ff                	test   %edi,%edi
  80103c:	75 0b                	jne    801049 <__umoddi3+0x49>
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
  801043:	31 d2                	xor    %edx,%edx
  801045:	f7 f7                	div    %edi
  801047:	89 c5                	mov    %eax,%ebp
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	31 d2                	xor    %edx,%edx
  80104d:	f7 f5                	div    %ebp
  80104f:	89 f0                	mov    %esi,%eax
  801051:	f7 f5                	div    %ebp
  801053:	89 d0                	mov    %edx,%eax
  801055:	eb d0                	jmp    801027 <__umoddi3+0x27>
  801057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80105e:	66 90                	xchg   %ax,%ax
  801060:	89 f1                	mov    %esi,%ecx
  801062:	39 d8                	cmp    %ebx,%eax
  801064:	76 0a                	jbe    801070 <__umoddi3+0x70>
  801066:	89 f0                	mov    %esi,%eax
  801068:	83 c4 1c             	add    $0x1c,%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    
  801070:	0f bd e8             	bsr    %eax,%ebp
  801073:	83 f5 1f             	xor    $0x1f,%ebp
  801076:	75 20                	jne    801098 <__umoddi3+0x98>
  801078:	39 d8                	cmp    %ebx,%eax
  80107a:	0f 82 b0 00 00 00    	jb     801130 <__umoddi3+0x130>
  801080:	39 f7                	cmp    %esi,%edi
  801082:	0f 86 a8 00 00 00    	jbe    801130 <__umoddi3+0x130>
  801088:	89 c8                	mov    %ecx,%eax
  80108a:	83 c4 1c             	add    $0x1c,%esp
  80108d:	5b                   	pop    %ebx
  80108e:	5e                   	pop    %esi
  80108f:	5f                   	pop    %edi
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    
  801092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801098:	89 e9                	mov    %ebp,%ecx
  80109a:	ba 20 00 00 00       	mov    $0x20,%edx
  80109f:	29 ea                	sub    %ebp,%edx
  8010a1:	d3 e0                	shl    %cl,%eax
  8010a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010a7:	89 d1                	mov    %edx,%ecx
  8010a9:	89 f8                	mov    %edi,%eax
  8010ab:	d3 e8                	shr    %cl,%eax
  8010ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010b9:	09 c1                	or     %eax,%ecx
  8010bb:	89 d8                	mov    %ebx,%eax
  8010bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010c1:	89 e9                	mov    %ebp,%ecx
  8010c3:	d3 e7                	shl    %cl,%edi
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	d3 e8                	shr    %cl,%eax
  8010c9:	89 e9                	mov    %ebp,%ecx
  8010cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010cf:	d3 e3                	shl    %cl,%ebx
  8010d1:	89 c7                	mov    %eax,%edi
  8010d3:	89 d1                	mov    %edx,%ecx
  8010d5:	89 f0                	mov    %esi,%eax
  8010d7:	d3 e8                	shr    %cl,%eax
  8010d9:	89 e9                	mov    %ebp,%ecx
  8010db:	89 fa                	mov    %edi,%edx
  8010dd:	d3 e6                	shl    %cl,%esi
  8010df:	09 d8                	or     %ebx,%eax
  8010e1:	f7 74 24 08          	divl   0x8(%esp)
  8010e5:	89 d1                	mov    %edx,%ecx
  8010e7:	89 f3                	mov    %esi,%ebx
  8010e9:	f7 64 24 0c          	mull   0xc(%esp)
  8010ed:	89 c6                	mov    %eax,%esi
  8010ef:	89 d7                	mov    %edx,%edi
  8010f1:	39 d1                	cmp    %edx,%ecx
  8010f3:	72 06                	jb     8010fb <__umoddi3+0xfb>
  8010f5:	75 10                	jne    801107 <__umoddi3+0x107>
  8010f7:	39 c3                	cmp    %eax,%ebx
  8010f9:	73 0c                	jae    801107 <__umoddi3+0x107>
  8010fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801103:	89 d7                	mov    %edx,%edi
  801105:	89 c6                	mov    %eax,%esi
  801107:	89 ca                	mov    %ecx,%edx
  801109:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80110e:	29 f3                	sub    %esi,%ebx
  801110:	19 fa                	sbb    %edi,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	d3 e0                	shl    %cl,%eax
  801116:	89 e9                	mov    %ebp,%ecx
  801118:	d3 eb                	shr    %cl,%ebx
  80111a:	d3 ea                	shr    %cl,%edx
  80111c:	09 d8                	or     %ebx,%eax
  80111e:	83 c4 1c             	add    $0x1c,%esp
  801121:	5b                   	pop    %ebx
  801122:	5e                   	pop    %esi
  801123:	5f                   	pop    %edi
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    
  801126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80112d:	8d 76 00             	lea    0x0(%esi),%esi
  801130:	89 da                	mov    %ebx,%edx
  801132:	29 fe                	sub    %edi,%esi
  801134:	19 c2                	sbb    %eax,%edx
  801136:	89 f1                	mov    %esi,%ecx
  801138:	89 c8                	mov    %ecx,%eax
  80113a:	e9 4b ff ff ff       	jmp    80108a <__umoddi3+0x8a>
