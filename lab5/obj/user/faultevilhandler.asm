
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 35 01 00 00       	call   80017c <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 20 00 10 f0       	push   $0xf0100020
  80004f:	6a 00                	push   $0x0
  800051:	e8 b2 02 00 00       	call   800308 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800070:	e8 c9 00 00 00       	call   80013e <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80007d:	c1 e0 04             	shl    $0x4,%eax
  800080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800085:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008a:	85 db                	test   %ebx,%ebx
  80008c:	7e 07                	jle    800095 <libmain+0x30>
		binaryname = argv[0];
  80008e:	8b 06                	mov    (%esi),%eax
  800090:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800095:	83 ec 08             	sub    $0x8,%esp
  800098:	56                   	push   %esi
  800099:	53                   	push   %ebx
  80009a:	e8 94 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009f:	e8 0a 00 00 00       	call   8000ae <exit>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000aa:	5b                   	pop    %ebx
  8000ab:	5e                   	pop    %esi
  8000ac:	5d                   	pop    %ebp
  8000ad:	c3                   	ret    

008000ae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 42 00 00 00       	call   8000fd <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d1:	89 c3                	mov    %eax,%ebx
  8000d3:	89 c7                	mov    %eax,%edi
  8000d5:	89 c6                	mov    %eax,%esi
  8000d7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d9:	5b                   	pop    %ebx
  8000da:	5e                   	pop    %esi
  8000db:	5f                   	pop    %edi
  8000dc:	5d                   	pop    %ebp
  8000dd:	c3                   	ret    

008000de <sys_cgetc>:

int
sys_cgetc(void)
{
  8000de:	55                   	push   %ebp
  8000df:	89 e5                	mov    %esp,%ebp
  8000e1:	57                   	push   %edi
  8000e2:	56                   	push   %esi
  8000e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	89 d3                	mov    %edx,%ebx
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	89 d6                	mov    %edx,%esi
  8000f6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f8:	5b                   	pop    %ebx
  8000f9:	5e                   	pop    %esi
  8000fa:	5f                   	pop    %edi
  8000fb:	5d                   	pop    %ebp
  8000fc:	c3                   	ret    

008000fd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fd:	55                   	push   %ebp
  8000fe:	89 e5                	mov    %esp,%ebp
  800100:	57                   	push   %edi
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800106:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010b:	8b 55 08             	mov    0x8(%ebp),%edx
  80010e:	b8 03 00 00 00       	mov    $0x3,%eax
  800113:	89 cb                	mov    %ecx,%ebx
  800115:	89 cf                	mov    %ecx,%edi
  800117:	89 ce                	mov    %ecx,%esi
  800119:	cd 30                	int    $0x30
	if(check && ret > 0)
  80011b:	85 c0                	test   %eax,%eax
  80011d:	7f 08                	jg     800127 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5f                   	pop    %edi
  800125:	5d                   	pop    %ebp
  800126:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	6a 03                	push   $0x3
  80012d:	68 6a 11 80 00       	push   $0x80116a
  800132:	6a 33                	push   $0x33
  800134:	68 87 11 80 00       	push   $0x801187
  800139:	e8 b1 02 00 00       	call   8003ef <_panic>

0080013e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	57                   	push   %edi
  800142:	56                   	push   %esi
  800143:	53                   	push   %ebx
	asm volatile("int %1\n"
  800144:	ba 00 00 00 00       	mov    $0x0,%edx
  800149:	b8 02 00 00 00       	mov    $0x2,%eax
  80014e:	89 d1                	mov    %edx,%ecx
  800150:	89 d3                	mov    %edx,%ebx
  800152:	89 d7                	mov    %edx,%edi
  800154:	89 d6                	mov    %edx,%esi
  800156:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800158:	5b                   	pop    %ebx
  800159:	5e                   	pop    %esi
  80015a:	5f                   	pop    %edi
  80015b:	5d                   	pop    %ebp
  80015c:	c3                   	ret    

0080015d <sys_yield>:

void
sys_yield(void)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	57                   	push   %edi
  800161:	56                   	push   %esi
  800162:	53                   	push   %ebx
	asm volatile("int %1\n"
  800163:	ba 00 00 00 00       	mov    $0x0,%edx
  800168:	b8 0c 00 00 00       	mov    $0xc,%eax
  80016d:	89 d1                	mov    %edx,%ecx
  80016f:	89 d3                	mov    %edx,%ebx
  800171:	89 d7                	mov    %edx,%edi
  800173:	89 d6                	mov    %edx,%esi
  800175:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800177:	5b                   	pop    %ebx
  800178:	5e                   	pop    %esi
  800179:	5f                   	pop    %edi
  80017a:	5d                   	pop    %ebp
  80017b:	c3                   	ret    

0080017c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	57                   	push   %edi
  800180:	56                   	push   %esi
  800181:	53                   	push   %ebx
  800182:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800185:	be 00 00 00 00       	mov    $0x0,%esi
  80018a:	8b 55 08             	mov    0x8(%ebp),%edx
  80018d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800190:	b8 04 00 00 00       	mov    $0x4,%eax
  800195:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800198:	89 f7                	mov    %esi,%edi
  80019a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019c:	85 c0                	test   %eax,%eax
  80019e:	7f 08                	jg     8001a8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a3:	5b                   	pop    %ebx
  8001a4:	5e                   	pop    %esi
  8001a5:	5f                   	pop    %edi
  8001a6:	5d                   	pop    %ebp
  8001a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	50                   	push   %eax
  8001ac:	6a 04                	push   $0x4
  8001ae:	68 6a 11 80 00       	push   $0x80116a
  8001b3:	6a 33                	push   $0x33
  8001b5:	68 87 11 80 00       	push   $0x801187
  8001ba:	e8 30 02 00 00       	call   8003ef <_panic>

008001bf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	57                   	push   %edi
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ce:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d9:	8b 75 18             	mov    0x18(%ebp),%esi
  8001dc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001de:	85 c0                	test   %eax,%eax
  8001e0:	7f 08                	jg     8001ea <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e5:	5b                   	pop    %ebx
  8001e6:	5e                   	pop    %esi
  8001e7:	5f                   	pop    %edi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	50                   	push   %eax
  8001ee:	6a 05                	push   $0x5
  8001f0:	68 6a 11 80 00       	push   $0x80116a
  8001f5:	6a 33                	push   $0x33
  8001f7:	68 87 11 80 00       	push   $0x801187
  8001fc:	e8 ee 01 00 00       	call   8003ef <_panic>

00800201 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	57                   	push   %edi
  800205:	56                   	push   %esi
  800206:	53                   	push   %ebx
  800207:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020f:	8b 55 08             	mov    0x8(%ebp),%edx
  800212:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800215:	b8 06 00 00 00       	mov    $0x6,%eax
  80021a:	89 df                	mov    %ebx,%edi
  80021c:	89 de                	mov    %ebx,%esi
  80021e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800220:	85 c0                	test   %eax,%eax
  800222:	7f 08                	jg     80022c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800224:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800227:	5b                   	pop    %ebx
  800228:	5e                   	pop    %esi
  800229:	5f                   	pop    %edi
  80022a:	5d                   	pop    %ebp
  80022b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	6a 06                	push   $0x6
  800232:	68 6a 11 80 00       	push   $0x80116a
  800237:	6a 33                	push   $0x33
  800239:	68 87 11 80 00       	push   $0x801187
  80023e:	e8 ac 01 00 00       	call   8003ef <_panic>

00800243 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	57                   	push   %edi
  800247:	56                   	push   %esi
  800248:	53                   	push   %ebx
  800249:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80024c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800251:	8b 55 08             	mov    0x8(%ebp),%edx
  800254:	b8 0b 00 00 00       	mov    $0xb,%eax
  800259:	89 cb                	mov    %ecx,%ebx
  80025b:	89 cf                	mov    %ecx,%edi
  80025d:	89 ce                	mov    %ecx,%esi
  80025f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800261:	85 c0                	test   %eax,%eax
  800263:	7f 08                	jg     80026d <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800265:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800268:	5b                   	pop    %ebx
  800269:	5e                   	pop    %esi
  80026a:	5f                   	pop    %edi
  80026b:	5d                   	pop    %ebp
  80026c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	50                   	push   %eax
  800271:	6a 0b                	push   $0xb
  800273:	68 6a 11 80 00       	push   $0x80116a
  800278:	6a 33                	push   $0x33
  80027a:	68 87 11 80 00       	push   $0x801187
  80027f:	e8 6b 01 00 00       	call   8003ef <_panic>

00800284 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	57                   	push   %edi
  800288:	56                   	push   %esi
  800289:	53                   	push   %ebx
  80028a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80028d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800292:	8b 55 08             	mov    0x8(%ebp),%edx
  800295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800298:	b8 08 00 00 00       	mov    $0x8,%eax
  80029d:	89 df                	mov    %ebx,%edi
  80029f:	89 de                	mov    %ebx,%esi
  8002a1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a3:	85 c0                	test   %eax,%eax
  8002a5:	7f 08                	jg     8002af <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002aa:	5b                   	pop    %ebx
  8002ab:	5e                   	pop    %esi
  8002ac:	5f                   	pop    %edi
  8002ad:	5d                   	pop    %ebp
  8002ae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002af:	83 ec 0c             	sub    $0xc,%esp
  8002b2:	50                   	push   %eax
  8002b3:	6a 08                	push   $0x8
  8002b5:	68 6a 11 80 00       	push   $0x80116a
  8002ba:	6a 33                	push   $0x33
  8002bc:	68 87 11 80 00       	push   $0x801187
  8002c1:	e8 29 01 00 00       	call   8003ef <_panic>

008002c6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	57                   	push   %edi
  8002ca:	56                   	push   %esi
  8002cb:	53                   	push   %ebx
  8002cc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002da:	b8 09 00 00 00       	mov    $0x9,%eax
  8002df:	89 df                	mov    %ebx,%edi
  8002e1:	89 de                	mov    %ebx,%esi
  8002e3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	7f 08                	jg     8002f1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ec:	5b                   	pop    %ebx
  8002ed:	5e                   	pop    %esi
  8002ee:	5f                   	pop    %edi
  8002ef:	5d                   	pop    %ebp
  8002f0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	6a 09                	push   $0x9
  8002f7:	68 6a 11 80 00       	push   $0x80116a
  8002fc:	6a 33                	push   $0x33
  8002fe:	68 87 11 80 00       	push   $0x801187
  800303:	e8 e7 00 00 00       	call   8003ef <_panic>

00800308 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	57                   	push   %edi
  80030c:	56                   	push   %esi
  80030d:	53                   	push   %ebx
  80030e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800311:	bb 00 00 00 00       	mov    $0x0,%ebx
  800316:	8b 55 08             	mov    0x8(%ebp),%edx
  800319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800321:	89 df                	mov    %ebx,%edi
  800323:	89 de                	mov    %ebx,%esi
  800325:	cd 30                	int    $0x30
	if(check && ret > 0)
  800327:	85 c0                	test   %eax,%eax
  800329:	7f 08                	jg     800333 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80032b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032e:	5b                   	pop    %ebx
  80032f:	5e                   	pop    %esi
  800330:	5f                   	pop    %edi
  800331:	5d                   	pop    %ebp
  800332:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	50                   	push   %eax
  800337:	6a 0a                	push   $0xa
  800339:	68 6a 11 80 00       	push   $0x80116a
  80033e:	6a 33                	push   $0x33
  800340:	68 87 11 80 00       	push   $0x801187
  800345:	e8 a5 00 00 00       	call   8003ef <_panic>

0080034a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	57                   	push   %edi
  80034e:	56                   	push   %esi
  80034f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800350:	8b 55 08             	mov    0x8(%ebp),%edx
  800353:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800356:	b8 0d 00 00 00       	mov    $0xd,%eax
  80035b:	be 00 00 00 00       	mov    $0x0,%esi
  800360:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800363:	8b 7d 14             	mov    0x14(%ebp),%edi
  800366:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800368:	5b                   	pop    %ebx
  800369:	5e                   	pop    %esi
  80036a:	5f                   	pop    %edi
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	57                   	push   %edi
  800371:	56                   	push   %esi
  800372:	53                   	push   %ebx
  800373:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800376:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037b:	8b 55 08             	mov    0x8(%ebp),%edx
  80037e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800383:	89 cb                	mov    %ecx,%ebx
  800385:	89 cf                	mov    %ecx,%edi
  800387:	89 ce                	mov    %ecx,%esi
  800389:	cd 30                	int    $0x30
	if(check && ret > 0)
  80038b:	85 c0                	test   %eax,%eax
  80038d:	7f 08                	jg     800397 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80038f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800392:	5b                   	pop    %ebx
  800393:	5e                   	pop    %esi
  800394:	5f                   	pop    %edi
  800395:	5d                   	pop    %ebp
  800396:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800397:	83 ec 0c             	sub    $0xc,%esp
  80039a:	50                   	push   %eax
  80039b:	6a 0e                	push   $0xe
  80039d:	68 6a 11 80 00       	push   $0x80116a
  8003a2:	6a 33                	push   $0x33
  8003a4:	68 87 11 80 00       	push   $0x801187
  8003a9:	e8 41 00 00 00       	call   8003ef <_panic>

008003ae <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	57                   	push   %edi
  8003b2:	56                   	push   %esi
  8003b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003bf:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003c4:	89 df                	mov    %ebx,%edi
  8003c6:	89 de                	mov    %ebx,%esi
  8003c8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003ca:	5b                   	pop    %ebx
  8003cb:	5e                   	pop    %esi
  8003cc:	5f                   	pop    %edi
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	57                   	push   %edi
  8003d3:	56                   	push   %esi
  8003d4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003da:	8b 55 08             	mov    0x8(%ebp),%edx
  8003dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8003e2:	89 cb                	mov    %ecx,%ebx
  8003e4:	89 cf                	mov    %ecx,%edi
  8003e6:	89 ce                	mov    %ecx,%esi
  8003e8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003ea:	5b                   	pop    %ebx
  8003eb:	5e                   	pop    %esi
  8003ec:	5f                   	pop    %edi
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	56                   	push   %esi
  8003f3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003f4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f7:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003fd:	e8 3c fd ff ff       	call   80013e <sys_getenvid>
  800402:	83 ec 0c             	sub    $0xc,%esp
  800405:	ff 75 0c             	pushl  0xc(%ebp)
  800408:	ff 75 08             	pushl  0x8(%ebp)
  80040b:	56                   	push   %esi
  80040c:	50                   	push   %eax
  80040d:	68 98 11 80 00       	push   $0x801198
  800412:	e8 b3 00 00 00       	call   8004ca <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800417:	83 c4 18             	add    $0x18,%esp
  80041a:	53                   	push   %ebx
  80041b:	ff 75 10             	pushl  0x10(%ebp)
  80041e:	e8 56 00 00 00       	call   800479 <vcprintf>
	cprintf("\n");
  800423:	c7 04 24 bb 11 80 00 	movl   $0x8011bb,(%esp)
  80042a:	e8 9b 00 00 00       	call   8004ca <cprintf>
  80042f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800432:	cc                   	int3   
  800433:	eb fd                	jmp    800432 <_panic+0x43>

00800435 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	53                   	push   %ebx
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80043f:	8b 13                	mov    (%ebx),%edx
  800441:	8d 42 01             	lea    0x1(%edx),%eax
  800444:	89 03                	mov    %eax,(%ebx)
  800446:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800449:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80044d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800452:	74 09                	je     80045d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800454:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800458:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	68 ff 00 00 00       	push   $0xff
  800465:	8d 43 08             	lea    0x8(%ebx),%eax
  800468:	50                   	push   %eax
  800469:	e8 52 fc ff ff       	call   8000c0 <sys_cputs>
		b->idx = 0;
  80046e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	eb db                	jmp    800454 <putch+0x1f>

00800479 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800482:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800489:	00 00 00 
	b.cnt = 0;
  80048c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800493:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800496:	ff 75 0c             	pushl  0xc(%ebp)
  800499:	ff 75 08             	pushl  0x8(%ebp)
  80049c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a2:	50                   	push   %eax
  8004a3:	68 35 04 80 00       	push   $0x800435
  8004a8:	e8 4a 01 00 00       	call   8005f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ad:	83 c4 08             	add    $0x8,%esp
  8004b0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004bc:	50                   	push   %eax
  8004bd:	e8 fe fb ff ff       	call   8000c0 <sys_cputs>

	return b.cnt;
}
  8004c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004c8:	c9                   	leave  
  8004c9:	c3                   	ret    

008004ca <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
  8004cd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d3:	50                   	push   %eax
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	e8 9d ff ff ff       	call   800479 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004dc:	c9                   	leave  
  8004dd:	c3                   	ret    

008004de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	57                   	push   %edi
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	83 ec 1c             	sub    $0x1c,%esp
  8004e7:	89 c6                	mov    %eax,%esi
  8004e9:	89 d7                	mov    %edx,%edi
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004fd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800501:	74 2c                	je     80052f <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800503:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800506:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80050d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800510:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800513:	39 c2                	cmp    %eax,%edx
  800515:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800518:	73 43                	jae    80055d <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051a:	83 eb 01             	sub    $0x1,%ebx
  80051d:	85 db                	test   %ebx,%ebx
  80051f:	7e 6c                	jle    80058d <printnum+0xaf>
			putch(padc, putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	57                   	push   %edi
  800525:	ff 75 18             	pushl  0x18(%ebp)
  800528:	ff d6                	call   *%esi
  80052a:	83 c4 10             	add    $0x10,%esp
  80052d:	eb eb                	jmp    80051a <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	6a 20                	push   $0x20
  800534:	6a 00                	push   $0x0
  800536:	50                   	push   %eax
  800537:	ff 75 e4             	pushl  -0x1c(%ebp)
  80053a:	ff 75 e0             	pushl  -0x20(%ebp)
  80053d:	89 fa                	mov    %edi,%edx
  80053f:	89 f0                	mov    %esi,%eax
  800541:	e8 98 ff ff ff       	call   8004de <printnum>
		while (--width > 0)
  800546:	83 c4 20             	add    $0x20,%esp
  800549:	83 eb 01             	sub    $0x1,%ebx
  80054c:	85 db                	test   %ebx,%ebx
  80054e:	7e 65                	jle    8005b5 <printnum+0xd7>
			putch(padc, putdat);
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	57                   	push   %edi
  800554:	6a 20                	push   $0x20
  800556:	ff d6                	call   *%esi
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	eb ec                	jmp    800549 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80055d:	83 ec 0c             	sub    $0xc,%esp
  800560:	ff 75 18             	pushl  0x18(%ebp)
  800563:	83 eb 01             	sub    $0x1,%ebx
  800566:	53                   	push   %ebx
  800567:	50                   	push   %eax
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 dc             	pushl  -0x24(%ebp)
  80056e:	ff 75 d8             	pushl  -0x28(%ebp)
  800571:	ff 75 e4             	pushl  -0x1c(%ebp)
  800574:	ff 75 e0             	pushl  -0x20(%ebp)
  800577:	e8 94 09 00 00       	call   800f10 <__udivdi3>
  80057c:	83 c4 18             	add    $0x18,%esp
  80057f:	52                   	push   %edx
  800580:	50                   	push   %eax
  800581:	89 fa                	mov    %edi,%edx
  800583:	89 f0                	mov    %esi,%eax
  800585:	e8 54 ff ff ff       	call   8004de <printnum>
  80058a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	57                   	push   %edi
  800591:	83 ec 04             	sub    $0x4,%esp
  800594:	ff 75 dc             	pushl  -0x24(%ebp)
  800597:	ff 75 d8             	pushl  -0x28(%ebp)
  80059a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059d:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a0:	e8 7b 0a 00 00       	call   801020 <__umoddi3>
  8005a5:	83 c4 14             	add    $0x14,%esp
  8005a8:	0f be 80 bd 11 80 00 	movsbl 0x8011bd(%eax),%eax
  8005af:	50                   	push   %eax
  8005b0:	ff d6                	call   *%esi
  8005b2:	83 c4 10             	add    $0x10,%esp
}
  8005b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b8:	5b                   	pop    %ebx
  8005b9:	5e                   	pop    %esi
  8005ba:	5f                   	pop    %edi
  8005bb:	5d                   	pop    %ebp
  8005bc:	c3                   	ret    

008005bd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005bd:	55                   	push   %ebp
  8005be:	89 e5                	mov    %esp,%ebp
  8005c0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005c3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c7:	8b 10                	mov    (%eax),%edx
  8005c9:	3b 50 04             	cmp    0x4(%eax),%edx
  8005cc:	73 0a                	jae    8005d8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005d1:	89 08                	mov    %ecx,(%eax)
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	88 02                	mov    %al,(%edx)
}
  8005d8:	5d                   	pop    %ebp
  8005d9:	c3                   	ret    

008005da <printfmt>:
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005e0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 10             	pushl  0x10(%ebp)
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 05 00 00 00       	call   8005f7 <vprintfmt>
}
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	c9                   	leave  
  8005f6:	c3                   	ret    

008005f7 <vprintfmt>:
{
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	57                   	push   %edi
  8005fb:	56                   	push   %esi
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 3c             	sub    $0x3c,%esp
  800600:	8b 75 08             	mov    0x8(%ebp),%esi
  800603:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800606:	8b 7d 10             	mov    0x10(%ebp),%edi
  800609:	e9 b4 03 00 00       	jmp    8009c2 <vprintfmt+0x3cb>
		padc = ' ';
  80060e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800612:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800619:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800620:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800627:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80062e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800633:	8d 47 01             	lea    0x1(%edi),%eax
  800636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800639:	0f b6 17             	movzbl (%edi),%edx
  80063c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80063f:	3c 55                	cmp    $0x55,%al
  800641:	0f 87 c8 04 00 00    	ja     800b0f <vprintfmt+0x518>
  800647:	0f b6 c0             	movzbl %al,%eax
  80064a:	ff 24 85 a0 13 80 00 	jmp    *0x8013a0(,%eax,4)
  800651:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800654:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80065b:	eb d6                	jmp    800633 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80065d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800660:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800664:	eb cd                	jmp    800633 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800666:	0f b6 d2             	movzbl %dl,%edx
  800669:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80066c:	b8 00 00 00 00       	mov    $0x0,%eax
  800671:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800674:	eb 0c                	jmp    800682 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800676:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800679:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80067d:	eb b4                	jmp    800633 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80067f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800682:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800685:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800689:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80068c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80068f:	83 f9 09             	cmp    $0x9,%ecx
  800692:	76 eb                	jbe    80067f <vprintfmt+0x88>
  800694:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800697:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069a:	eb 14                	jmp    8006b0 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b4:	0f 89 79 ff ff ff    	jns    800633 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8006ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006c7:	e9 67 ff ff ff       	jmp    800633 <vprintfmt+0x3c>
  8006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cf:	85 c0                	test   %eax,%eax
  8006d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d6:	0f 49 d0             	cmovns %eax,%edx
  8006d9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006df:	e9 4f ff ff ff       	jmp    800633 <vprintfmt+0x3c>
  8006e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006ee:	e9 40 ff ff ff       	jmp    800633 <vprintfmt+0x3c>
			lflag++;
  8006f3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006f9:	e9 35 ff ff ff       	jmp    800633 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 78 04             	lea    0x4(%eax),%edi
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	ff 30                	pushl  (%eax)
  80070a:	ff d6                	call   *%esi
			break;
  80070c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80070f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800712:	e9 a8 02 00 00       	jmp    8009bf <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 78 04             	lea    0x4(%eax),%edi
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	99                   	cltd   
  800720:	31 d0                	xor    %edx,%eax
  800722:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800724:	83 f8 0f             	cmp    $0xf,%eax
  800727:	7f 23                	jg     80074c <vprintfmt+0x155>
  800729:	8b 14 85 00 15 80 00 	mov    0x801500(,%eax,4),%edx
  800730:	85 d2                	test   %edx,%edx
  800732:	74 18                	je     80074c <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800734:	52                   	push   %edx
  800735:	68 de 11 80 00       	push   $0x8011de
  80073a:	53                   	push   %ebx
  80073b:	56                   	push   %esi
  80073c:	e8 99 fe ff ff       	call   8005da <printfmt>
  800741:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800744:	89 7d 14             	mov    %edi,0x14(%ebp)
  800747:	e9 73 02 00 00       	jmp    8009bf <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80074c:	50                   	push   %eax
  80074d:	68 d5 11 80 00       	push   $0x8011d5
  800752:	53                   	push   %ebx
  800753:	56                   	push   %esi
  800754:	e8 81 fe ff ff       	call   8005da <printfmt>
  800759:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80075c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80075f:	e9 5b 02 00 00       	jmp    8009bf <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 c0 04             	add    $0x4,%eax
  80076a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800772:	85 d2                	test   %edx,%edx
  800774:	b8 ce 11 80 00       	mov    $0x8011ce,%eax
  800779:	0f 45 c2             	cmovne %edx,%eax
  80077c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80077f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800783:	7e 06                	jle    80078b <vprintfmt+0x194>
  800785:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800789:	75 0d                	jne    800798 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80078b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80078e:	89 c7                	mov    %eax,%edi
  800790:	03 45 e0             	add    -0x20(%ebp),%eax
  800793:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800796:	eb 53                	jmp    8007eb <vprintfmt+0x1f4>
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 d8             	pushl  -0x28(%ebp)
  80079e:	50                   	push   %eax
  80079f:	e8 13 04 00 00       	call   800bb7 <strnlen>
  8007a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007a7:	29 c1                	sub    %eax,%ecx
  8007a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007b1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b8:	eb 0f                	jmp    8007c9 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	53                   	push   %ebx
  8007be:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c3:	83 ef 01             	sub    $0x1,%edi
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	85 ff                	test   %edi,%edi
  8007cb:	7f ed                	jg     8007ba <vprintfmt+0x1c3>
  8007cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007d0:	85 d2                	test   %edx,%edx
  8007d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d7:	0f 49 c2             	cmovns %edx,%eax
  8007da:	29 c2                	sub    %eax,%edx
  8007dc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007df:	eb aa                	jmp    80078b <vprintfmt+0x194>
					putch(ch, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	52                   	push   %edx
  8007e6:	ff d6                	call   *%esi
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ee:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f0:	83 c7 01             	add    $0x1,%edi
  8007f3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f7:	0f be d0             	movsbl %al,%edx
  8007fa:	85 d2                	test   %edx,%edx
  8007fc:	74 4b                	je     800849 <vprintfmt+0x252>
  8007fe:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800802:	78 06                	js     80080a <vprintfmt+0x213>
  800804:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800808:	78 1e                	js     800828 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80080a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80080e:	74 d1                	je     8007e1 <vprintfmt+0x1ea>
  800810:	0f be c0             	movsbl %al,%eax
  800813:	83 e8 20             	sub    $0x20,%eax
  800816:	83 f8 5e             	cmp    $0x5e,%eax
  800819:	76 c6                	jbe    8007e1 <vprintfmt+0x1ea>
					putch('?', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	53                   	push   %ebx
  80081f:	6a 3f                	push   $0x3f
  800821:	ff d6                	call   *%esi
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	eb c3                	jmp    8007eb <vprintfmt+0x1f4>
  800828:	89 cf                	mov    %ecx,%edi
  80082a:	eb 0e                	jmp    80083a <vprintfmt+0x243>
				putch(' ', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	6a 20                	push   $0x20
  800832:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800834:	83 ef 01             	sub    $0x1,%edi
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	85 ff                	test   %edi,%edi
  80083c:	7f ee                	jg     80082c <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80083e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
  800844:	e9 76 01 00 00       	jmp    8009bf <vprintfmt+0x3c8>
  800849:	89 cf                	mov    %ecx,%edi
  80084b:	eb ed                	jmp    80083a <vprintfmt+0x243>
	if (lflag >= 2)
  80084d:	83 f9 01             	cmp    $0x1,%ecx
  800850:	7f 1f                	jg     800871 <vprintfmt+0x27a>
	else if (lflag)
  800852:	85 c9                	test   %ecx,%ecx
  800854:	74 6a                	je     8008c0 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	89 c1                	mov    %eax,%ecx
  800860:	c1 f9 1f             	sar    $0x1f,%ecx
  800863:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8d 40 04             	lea    0x4(%eax),%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	eb 17                	jmp    800888 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 50 04             	mov    0x4(%eax),%edx
  800877:	8b 00                	mov    (%eax),%eax
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 40 08             	lea    0x8(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800888:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80088b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800890:	85 d2                	test   %edx,%edx
  800892:	0f 89 f8 00 00 00    	jns    800990 <vprintfmt+0x399>
				putch('-', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	6a 2d                	push   $0x2d
  80089e:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8008a6:	f7 d8                	neg    %eax
  8008a8:	83 d2 00             	adc    $0x0,%edx
  8008ab:	f7 da                	neg    %edx
  8008ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008bb:	e9 e1 00 00 00       	jmp    8009a1 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c8:	99                   	cltd   
  8008c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8d 40 04             	lea    0x4(%eax),%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	eb b1                	jmp    800888 <vprintfmt+0x291>
	if (lflag >= 2)
  8008d7:	83 f9 01             	cmp    $0x1,%ecx
  8008da:	7f 27                	jg     800903 <vprintfmt+0x30c>
	else if (lflag)
  8008dc:	85 c9                	test   %ecx,%ecx
  8008de:	74 41                	je     800921 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	8d 40 04             	lea    0x4(%eax),%eax
  8008f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008fe:	e9 8d 00 00 00       	jmp    800990 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	8b 50 04             	mov    0x4(%eax),%edx
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8d 40 08             	lea    0x8(%eax),%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80091a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80091f:	eb 6f                	jmp    800990 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	ba 00 00 00 00       	mov    $0x0,%edx
  80092b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8d 40 04             	lea    0x4(%eax),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80093a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80093f:	eb 4f                	jmp    800990 <vprintfmt+0x399>
	if (lflag >= 2)
  800941:	83 f9 01             	cmp    $0x1,%ecx
  800944:	7f 23                	jg     800969 <vprintfmt+0x372>
	else if (lflag)
  800946:	85 c9                	test   %ecx,%ecx
  800948:	0f 84 98 00 00 00    	je     8009e6 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	ba 00 00 00 00       	mov    $0x0,%edx
  800958:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8d 40 04             	lea    0x4(%eax),%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	eb 17                	jmp    800980 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	8b 50 04             	mov    0x4(%eax),%edx
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800974:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8d 40 08             	lea    0x8(%eax),%eax
  80097d:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	53                   	push   %ebx
  800984:	6a 30                	push   $0x30
  800986:	ff d6                	call   *%esi
			goto number;
  800988:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80098b:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800990:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800994:	74 0b                	je     8009a1 <vprintfmt+0x3aa>
				putch('+', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	53                   	push   %ebx
  80099a:	6a 2b                	push   $0x2b
  80099c:	ff d6                	call   *%esi
  80099e:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009a1:	83 ec 0c             	sub    $0xc,%esp
  8009a4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009a8:	50                   	push   %eax
  8009a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8009ac:	57                   	push   %edi
  8009ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8009b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8009b3:	89 da                	mov    %ebx,%edx
  8009b5:	89 f0                	mov    %esi,%eax
  8009b7:	e8 22 fb ff ff       	call   8004de <printnum>
			break;
  8009bc:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c2:	83 c7 01             	add    $0x1,%edi
  8009c5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c9:	83 f8 25             	cmp    $0x25,%eax
  8009cc:	0f 84 3c fc ff ff    	je     80060e <vprintfmt+0x17>
			if (ch == '\0')
  8009d2:	85 c0                	test   %eax,%eax
  8009d4:	0f 84 55 01 00 00    	je     800b2f <vprintfmt+0x538>
			putch(ch, putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	53                   	push   %ebx
  8009de:	50                   	push   %eax
  8009df:	ff d6                	call   *%esi
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	eb dc                	jmp    8009c2 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	8b 00                	mov    (%eax),%eax
  8009eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f9:	8d 40 04             	lea    0x4(%eax),%eax
  8009fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ff:	e9 7c ff ff ff       	jmp    800980 <vprintfmt+0x389>
			putch('0', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	53                   	push   %ebx
  800a08:	6a 30                	push   $0x30
  800a0a:	ff d6                	call   *%esi
			putch('x', putdat);
  800a0c:	83 c4 08             	add    $0x8,%esp
  800a0f:	53                   	push   %ebx
  800a10:	6a 78                	push   $0x78
  800a12:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8b 00                	mov    (%eax),%eax
  800a19:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a21:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a24:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	8d 40 04             	lea    0x4(%eax),%eax
  800a2d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a30:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a35:	e9 56 ff ff ff       	jmp    800990 <vprintfmt+0x399>
	if (lflag >= 2)
  800a3a:	83 f9 01             	cmp    $0x1,%ecx
  800a3d:	7f 27                	jg     800a66 <vprintfmt+0x46f>
	else if (lflag)
  800a3f:	85 c9                	test   %ecx,%ecx
  800a41:	74 44                	je     800a87 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	8b 00                	mov    (%eax),%eax
  800a48:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a50:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	8d 40 04             	lea    0x4(%eax),%eax
  800a59:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5c:	bf 10 00 00 00       	mov    $0x10,%edi
  800a61:	e9 2a ff ff ff       	jmp    800990 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	8b 50 04             	mov    0x4(%eax),%edx
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a71:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	8d 40 08             	lea    0x8(%eax),%eax
  800a7a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a7d:	bf 10 00 00 00       	mov    $0x10,%edi
  800a82:	e9 09 ff ff ff       	jmp    800990 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a94:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	8d 40 04             	lea    0x4(%eax),%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa0:	bf 10 00 00 00       	mov    $0x10,%edi
  800aa5:	e9 e6 fe ff ff       	jmp    800990 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	8d 78 04             	lea    0x4(%eax),%edi
  800ab0:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800ab2:	85 c0                	test   %eax,%eax
  800ab4:	74 2d                	je     800ae3 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800ab6:	0f b6 13             	movzbl (%ebx),%edx
  800ab9:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800abb:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800abe:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800ac1:	0f 8e f8 fe ff ff    	jle    8009bf <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800ac7:	68 2c 13 80 00       	push   $0x80132c
  800acc:	68 de 11 80 00       	push   $0x8011de
  800ad1:	53                   	push   %ebx
  800ad2:	56                   	push   %esi
  800ad3:	e8 02 fb ff ff       	call   8005da <printfmt>
  800ad8:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800adb:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ade:	e9 dc fe ff ff       	jmp    8009bf <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800ae3:	68 f4 12 80 00       	push   $0x8012f4
  800ae8:	68 de 11 80 00       	push   $0x8011de
  800aed:	53                   	push   %ebx
  800aee:	56                   	push   %esi
  800aef:	e8 e6 fa ff ff       	call   8005da <printfmt>
  800af4:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800af7:	89 7d 14             	mov    %edi,0x14(%ebp)
  800afa:	e9 c0 fe ff ff       	jmp    8009bf <vprintfmt+0x3c8>
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	53                   	push   %ebx
  800b03:	6a 25                	push   $0x25
  800b05:	ff d6                	call   *%esi
			break;
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	e9 b0 fe ff ff       	jmp    8009bf <vprintfmt+0x3c8>
			putch('%', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	53                   	push   %ebx
  800b13:	6a 25                	push   $0x25
  800b15:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b17:	83 c4 10             	add    $0x10,%esp
  800b1a:	89 f8                	mov    %edi,%eax
  800b1c:	eb 03                	jmp    800b21 <vprintfmt+0x52a>
  800b1e:	83 e8 01             	sub    $0x1,%eax
  800b21:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b25:	75 f7                	jne    800b1e <vprintfmt+0x527>
  800b27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b2a:	e9 90 fe ff ff       	jmp    8009bf <vprintfmt+0x3c8>
}
  800b2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5f                   	pop    %edi
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	83 ec 18             	sub    $0x18,%esp
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b46:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b4a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b54:	85 c0                	test   %eax,%eax
  800b56:	74 26                	je     800b7e <vsnprintf+0x47>
  800b58:	85 d2                	test   %edx,%edx
  800b5a:	7e 22                	jle    800b7e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5c:	ff 75 14             	pushl  0x14(%ebp)
  800b5f:	ff 75 10             	pushl  0x10(%ebp)
  800b62:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 bd 05 80 00       	push   $0x8005bd
  800b6b:	e8 87 fa ff ff       	call   8005f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b79:	83 c4 10             	add    $0x10,%esp
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    
		return -E_INVAL;
  800b7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b83:	eb f7                	jmp    800b7c <vsnprintf+0x45>

00800b85 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b8e:	50                   	push   %eax
  800b8f:	ff 75 10             	pushl  0x10(%ebp)
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	ff 75 08             	pushl  0x8(%ebp)
  800b98:	e8 9a ff ff ff       	call   800b37 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  800baa:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bae:	74 05                	je     800bb5 <strlen+0x16>
		n++;
  800bb0:	83 c0 01             	add    $0x1,%eax
  800bb3:	eb f5                	jmp    800baa <strlen+0xb>
	return n;
}
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc5:	39 c2                	cmp    %eax,%edx
  800bc7:	74 0d                	je     800bd6 <strnlen+0x1f>
  800bc9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bcd:	74 05                	je     800bd4 <strnlen+0x1d>
		n++;
  800bcf:	83 c2 01             	add    $0x1,%edx
  800bd2:	eb f1                	jmp    800bc5 <strnlen+0xe>
  800bd4:	89 d0                	mov    %edx,%eax
	return n;
}
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	53                   	push   %ebx
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800be2:	ba 00 00 00 00       	mov    $0x0,%edx
  800be7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800beb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	84 c9                	test   %cl,%cl
  800bf3:	75 f2                	jne    800be7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bf5:	5b                   	pop    %ebx
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	53                   	push   %ebx
  800bfc:	83 ec 10             	sub    $0x10,%esp
  800bff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c02:	53                   	push   %ebx
  800c03:	e8 97 ff ff ff       	call   800b9f <strlen>
  800c08:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	01 d8                	add    %ebx,%eax
  800c10:	50                   	push   %eax
  800c11:	e8 c2 ff ff ff       	call   800bd8 <strcpy>
	return dst;
}
  800c16:	89 d8                	mov    %ebx,%eax
  800c18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c28:	89 c6                	mov    %eax,%esi
  800c2a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c2d:	89 c2                	mov    %eax,%edx
  800c2f:	39 f2                	cmp    %esi,%edx
  800c31:	74 11                	je     800c44 <strncpy+0x27>
		*dst++ = *src;
  800c33:	83 c2 01             	add    $0x1,%edx
  800c36:	0f b6 19             	movzbl (%ecx),%ebx
  800c39:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c3c:	80 fb 01             	cmp    $0x1,%bl
  800c3f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c42:	eb eb                	jmp    800c2f <strncpy+0x12>
	}
	return ret;
}
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c53:	8b 55 10             	mov    0x10(%ebp),%edx
  800c56:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c58:	85 d2                	test   %edx,%edx
  800c5a:	74 21                	je     800c7d <strlcpy+0x35>
  800c5c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c60:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c62:	39 c2                	cmp    %eax,%edx
  800c64:	74 14                	je     800c7a <strlcpy+0x32>
  800c66:	0f b6 19             	movzbl (%ecx),%ebx
  800c69:	84 db                	test   %bl,%bl
  800c6b:	74 0b                	je     800c78 <strlcpy+0x30>
			*dst++ = *src++;
  800c6d:	83 c1 01             	add    $0x1,%ecx
  800c70:	83 c2 01             	add    $0x1,%edx
  800c73:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c76:	eb ea                	jmp    800c62 <strlcpy+0x1a>
  800c78:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c7a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c7d:	29 f0                	sub    %esi,%eax
}
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c89:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c8c:	0f b6 01             	movzbl (%ecx),%eax
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 0c                	je     800c9f <strcmp+0x1c>
  800c93:	3a 02                	cmp    (%edx),%al
  800c95:	75 08                	jne    800c9f <strcmp+0x1c>
		p++, q++;
  800c97:	83 c1 01             	add    $0x1,%ecx
  800c9a:	83 c2 01             	add    $0x1,%edx
  800c9d:	eb ed                	jmp    800c8c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9f:	0f b6 c0             	movzbl %al,%eax
  800ca2:	0f b6 12             	movzbl (%edx),%edx
  800ca5:	29 d0                	sub    %edx,%eax
}
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	53                   	push   %ebx
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	89 c3                	mov    %eax,%ebx
  800cb5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cb8:	eb 06                	jmp    800cc0 <strncmp+0x17>
		n--, p++, q++;
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cc0:	39 d8                	cmp    %ebx,%eax
  800cc2:	74 16                	je     800cda <strncmp+0x31>
  800cc4:	0f b6 08             	movzbl (%eax),%ecx
  800cc7:	84 c9                	test   %cl,%cl
  800cc9:	74 04                	je     800ccf <strncmp+0x26>
  800ccb:	3a 0a                	cmp    (%edx),%cl
  800ccd:	74 eb                	je     800cba <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ccf:	0f b6 00             	movzbl (%eax),%eax
  800cd2:	0f b6 12             	movzbl (%edx),%edx
  800cd5:	29 d0                	sub    %edx,%eax
}
  800cd7:	5b                   	pop    %ebx
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    
		return 0;
  800cda:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdf:	eb f6                	jmp    800cd7 <strncmp+0x2e>

00800ce1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ceb:	0f b6 10             	movzbl (%eax),%edx
  800cee:	84 d2                	test   %dl,%dl
  800cf0:	74 09                	je     800cfb <strchr+0x1a>
		if (*s == c)
  800cf2:	38 ca                	cmp    %cl,%dl
  800cf4:	74 0a                	je     800d00 <strchr+0x1f>
	for (; *s; s++)
  800cf6:	83 c0 01             	add    $0x1,%eax
  800cf9:	eb f0                	jmp    800ceb <strchr+0xa>
			return (char *) s;
	return 0;
  800cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d0c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d0f:	38 ca                	cmp    %cl,%dl
  800d11:	74 09                	je     800d1c <strfind+0x1a>
  800d13:	84 d2                	test   %dl,%dl
  800d15:	74 05                	je     800d1c <strfind+0x1a>
	for (; *s; s++)
  800d17:	83 c0 01             	add    $0x1,%eax
  800d1a:	eb f0                	jmp    800d0c <strfind+0xa>
			break;
	return (char *) s;
}
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d2a:	85 c9                	test   %ecx,%ecx
  800d2c:	74 31                	je     800d5f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d2e:	89 f8                	mov    %edi,%eax
  800d30:	09 c8                	or     %ecx,%eax
  800d32:	a8 03                	test   $0x3,%al
  800d34:	75 23                	jne    800d59 <memset+0x3b>
		c &= 0xFF;
  800d36:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d3a:	89 d3                	mov    %edx,%ebx
  800d3c:	c1 e3 08             	shl    $0x8,%ebx
  800d3f:	89 d0                	mov    %edx,%eax
  800d41:	c1 e0 18             	shl    $0x18,%eax
  800d44:	89 d6                	mov    %edx,%esi
  800d46:	c1 e6 10             	shl    $0x10,%esi
  800d49:	09 f0                	or     %esi,%eax
  800d4b:	09 c2                	or     %eax,%edx
  800d4d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d4f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d52:	89 d0                	mov    %edx,%eax
  800d54:	fc                   	cld    
  800d55:	f3 ab                	rep stos %eax,%es:(%edi)
  800d57:	eb 06                	jmp    800d5f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	fc                   	cld    
  800d5d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d5f:	89 f8                	mov    %edi,%eax
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d71:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d74:	39 c6                	cmp    %eax,%esi
  800d76:	73 32                	jae    800daa <memmove+0x44>
  800d78:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d7b:	39 c2                	cmp    %eax,%edx
  800d7d:	76 2b                	jbe    800daa <memmove+0x44>
		s += n;
		d += n;
  800d7f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d82:	89 fe                	mov    %edi,%esi
  800d84:	09 ce                	or     %ecx,%esi
  800d86:	09 d6                	or     %edx,%esi
  800d88:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d8e:	75 0e                	jne    800d9e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d90:	83 ef 04             	sub    $0x4,%edi
  800d93:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d96:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d99:	fd                   	std    
  800d9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d9c:	eb 09                	jmp    800da7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d9e:	83 ef 01             	sub    $0x1,%edi
  800da1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800da4:	fd                   	std    
  800da5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800da7:	fc                   	cld    
  800da8:	eb 1a                	jmp    800dc4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800daa:	89 c2                	mov    %eax,%edx
  800dac:	09 ca                	or     %ecx,%edx
  800dae:	09 f2                	or     %esi,%edx
  800db0:	f6 c2 03             	test   $0x3,%dl
  800db3:	75 0a                	jne    800dbf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800db5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800db8:	89 c7                	mov    %eax,%edi
  800dba:	fc                   	cld    
  800dbb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dbd:	eb 05                	jmp    800dc4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800dbf:	89 c7                	mov    %eax,%edi
  800dc1:	fc                   	cld    
  800dc2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dce:	ff 75 10             	pushl  0x10(%ebp)
  800dd1:	ff 75 0c             	pushl  0xc(%ebp)
  800dd4:	ff 75 08             	pushl  0x8(%ebp)
  800dd7:	e8 8a ff ff ff       	call   800d66 <memmove>
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de9:	89 c6                	mov    %eax,%esi
  800deb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dee:	39 f0                	cmp    %esi,%eax
  800df0:	74 1c                	je     800e0e <memcmp+0x30>
		if (*s1 != *s2)
  800df2:	0f b6 08             	movzbl (%eax),%ecx
  800df5:	0f b6 1a             	movzbl (%edx),%ebx
  800df8:	38 d9                	cmp    %bl,%cl
  800dfa:	75 08                	jne    800e04 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dfc:	83 c0 01             	add    $0x1,%eax
  800dff:	83 c2 01             	add    $0x1,%edx
  800e02:	eb ea                	jmp    800dee <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e04:	0f b6 c1             	movzbl %cl,%eax
  800e07:	0f b6 db             	movzbl %bl,%ebx
  800e0a:	29 d8                	sub    %ebx,%eax
  800e0c:	eb 05                	jmp    800e13 <memcmp+0x35>
	}

	return 0;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e20:	89 c2                	mov    %eax,%edx
  800e22:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e25:	39 d0                	cmp    %edx,%eax
  800e27:	73 09                	jae    800e32 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e29:	38 08                	cmp    %cl,(%eax)
  800e2b:	74 05                	je     800e32 <memfind+0x1b>
	for (; s < ends; s++)
  800e2d:	83 c0 01             	add    $0x1,%eax
  800e30:	eb f3                	jmp    800e25 <memfind+0xe>
			break;
	return (void *) s;
}
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    

00800e34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e40:	eb 03                	jmp    800e45 <strtol+0x11>
		s++;
  800e42:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e45:	0f b6 01             	movzbl (%ecx),%eax
  800e48:	3c 20                	cmp    $0x20,%al
  800e4a:	74 f6                	je     800e42 <strtol+0xe>
  800e4c:	3c 09                	cmp    $0x9,%al
  800e4e:	74 f2                	je     800e42 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e50:	3c 2b                	cmp    $0x2b,%al
  800e52:	74 2a                	je     800e7e <strtol+0x4a>
	int neg = 0;
  800e54:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e59:	3c 2d                	cmp    $0x2d,%al
  800e5b:	74 2b                	je     800e88 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e5d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e63:	75 0f                	jne    800e74 <strtol+0x40>
  800e65:	80 39 30             	cmpb   $0x30,(%ecx)
  800e68:	74 28                	je     800e92 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e6a:	85 db                	test   %ebx,%ebx
  800e6c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e71:	0f 44 d8             	cmove  %eax,%ebx
  800e74:	b8 00 00 00 00       	mov    $0x0,%eax
  800e79:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e7c:	eb 50                	jmp    800ece <strtol+0x9a>
		s++;
  800e7e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e81:	bf 00 00 00 00       	mov    $0x0,%edi
  800e86:	eb d5                	jmp    800e5d <strtol+0x29>
		s++, neg = 1;
  800e88:	83 c1 01             	add    $0x1,%ecx
  800e8b:	bf 01 00 00 00       	mov    $0x1,%edi
  800e90:	eb cb                	jmp    800e5d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e92:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e96:	74 0e                	je     800ea6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e98:	85 db                	test   %ebx,%ebx
  800e9a:	75 d8                	jne    800e74 <strtol+0x40>
		s++, base = 8;
  800e9c:	83 c1 01             	add    $0x1,%ecx
  800e9f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ea4:	eb ce                	jmp    800e74 <strtol+0x40>
		s += 2, base = 16;
  800ea6:	83 c1 02             	add    $0x2,%ecx
  800ea9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800eae:	eb c4                	jmp    800e74 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800eb0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800eb3:	89 f3                	mov    %esi,%ebx
  800eb5:	80 fb 19             	cmp    $0x19,%bl
  800eb8:	77 29                	ja     800ee3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800eba:	0f be d2             	movsbl %dl,%edx
  800ebd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ec0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ec3:	7d 30                	jge    800ef5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ec5:	83 c1 01             	add    $0x1,%ecx
  800ec8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ecc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ece:	0f b6 11             	movzbl (%ecx),%edx
  800ed1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ed4:	89 f3                	mov    %esi,%ebx
  800ed6:	80 fb 09             	cmp    $0x9,%bl
  800ed9:	77 d5                	ja     800eb0 <strtol+0x7c>
			dig = *s - '0';
  800edb:	0f be d2             	movsbl %dl,%edx
  800ede:	83 ea 30             	sub    $0x30,%edx
  800ee1:	eb dd                	jmp    800ec0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ee3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ee6:	89 f3                	mov    %esi,%ebx
  800ee8:	80 fb 19             	cmp    $0x19,%bl
  800eeb:	77 08                	ja     800ef5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800eed:	0f be d2             	movsbl %dl,%edx
  800ef0:	83 ea 37             	sub    $0x37,%edx
  800ef3:	eb cb                	jmp    800ec0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ef5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef9:	74 05                	je     800f00 <strtol+0xcc>
		*endptr = (char *) s;
  800efb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800efe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f00:	89 c2                	mov    %eax,%edx
  800f02:	f7 da                	neg    %edx
  800f04:	85 ff                	test   %edi,%edi
  800f06:	0f 45 c2             	cmovne %edx,%eax
}
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    
  800f0e:	66 90                	xchg   %ax,%ax

00800f10 <__udivdi3>:
  800f10:	55                   	push   %ebp
  800f11:	57                   	push   %edi
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
  800f14:	83 ec 1c             	sub    $0x1c,%esp
  800f17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f27:	85 d2                	test   %edx,%edx
  800f29:	75 4d                	jne    800f78 <__udivdi3+0x68>
  800f2b:	39 f3                	cmp    %esi,%ebx
  800f2d:	76 19                	jbe    800f48 <__udivdi3+0x38>
  800f2f:	31 ff                	xor    %edi,%edi
  800f31:	89 e8                	mov    %ebp,%eax
  800f33:	89 f2                	mov    %esi,%edx
  800f35:	f7 f3                	div    %ebx
  800f37:	89 fa                	mov    %edi,%edx
  800f39:	83 c4 1c             	add    $0x1c,%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
  800f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f48:	89 d9                	mov    %ebx,%ecx
  800f4a:	85 db                	test   %ebx,%ebx
  800f4c:	75 0b                	jne    800f59 <__udivdi3+0x49>
  800f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f53:	31 d2                	xor    %edx,%edx
  800f55:	f7 f3                	div    %ebx
  800f57:	89 c1                	mov    %eax,%ecx
  800f59:	31 d2                	xor    %edx,%edx
  800f5b:	89 f0                	mov    %esi,%eax
  800f5d:	f7 f1                	div    %ecx
  800f5f:	89 c6                	mov    %eax,%esi
  800f61:	89 e8                	mov    %ebp,%eax
  800f63:	89 f7                	mov    %esi,%edi
  800f65:	f7 f1                	div    %ecx
  800f67:	89 fa                	mov    %edi,%edx
  800f69:	83 c4 1c             	add    $0x1c,%esp
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    
  800f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f78:	39 f2                	cmp    %esi,%edx
  800f7a:	77 1c                	ja     800f98 <__udivdi3+0x88>
  800f7c:	0f bd fa             	bsr    %edx,%edi
  800f7f:	83 f7 1f             	xor    $0x1f,%edi
  800f82:	75 2c                	jne    800fb0 <__udivdi3+0xa0>
  800f84:	39 f2                	cmp    %esi,%edx
  800f86:	72 06                	jb     800f8e <__udivdi3+0x7e>
  800f88:	31 c0                	xor    %eax,%eax
  800f8a:	39 eb                	cmp    %ebp,%ebx
  800f8c:	77 a9                	ja     800f37 <__udivdi3+0x27>
  800f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f93:	eb a2                	jmp    800f37 <__udivdi3+0x27>
  800f95:	8d 76 00             	lea    0x0(%esi),%esi
  800f98:	31 ff                	xor    %edi,%edi
  800f9a:	31 c0                	xor    %eax,%eax
  800f9c:	89 fa                	mov    %edi,%edx
  800f9e:	83 c4 1c             	add    $0x1c,%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    
  800fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fad:	8d 76 00             	lea    0x0(%esi),%esi
  800fb0:	89 f9                	mov    %edi,%ecx
  800fb2:	b8 20 00 00 00       	mov    $0x20,%eax
  800fb7:	29 f8                	sub    %edi,%eax
  800fb9:	d3 e2                	shl    %cl,%edx
  800fbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fbf:	89 c1                	mov    %eax,%ecx
  800fc1:	89 da                	mov    %ebx,%edx
  800fc3:	d3 ea                	shr    %cl,%edx
  800fc5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fc9:	09 d1                	or     %edx,%ecx
  800fcb:	89 f2                	mov    %esi,%edx
  800fcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fd1:	89 f9                	mov    %edi,%ecx
  800fd3:	d3 e3                	shl    %cl,%ebx
  800fd5:	89 c1                	mov    %eax,%ecx
  800fd7:	d3 ea                	shr    %cl,%edx
  800fd9:	89 f9                	mov    %edi,%ecx
  800fdb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fdf:	89 eb                	mov    %ebp,%ebx
  800fe1:	d3 e6                	shl    %cl,%esi
  800fe3:	89 c1                	mov    %eax,%ecx
  800fe5:	d3 eb                	shr    %cl,%ebx
  800fe7:	09 de                	or     %ebx,%esi
  800fe9:	89 f0                	mov    %esi,%eax
  800feb:	f7 74 24 08          	divl   0x8(%esp)
  800fef:	89 d6                	mov    %edx,%esi
  800ff1:	89 c3                	mov    %eax,%ebx
  800ff3:	f7 64 24 0c          	mull   0xc(%esp)
  800ff7:	39 d6                	cmp    %edx,%esi
  800ff9:	72 15                	jb     801010 <__udivdi3+0x100>
  800ffb:	89 f9                	mov    %edi,%ecx
  800ffd:	d3 e5                	shl    %cl,%ebp
  800fff:	39 c5                	cmp    %eax,%ebp
  801001:	73 04                	jae    801007 <__udivdi3+0xf7>
  801003:	39 d6                	cmp    %edx,%esi
  801005:	74 09                	je     801010 <__udivdi3+0x100>
  801007:	89 d8                	mov    %ebx,%eax
  801009:	31 ff                	xor    %edi,%edi
  80100b:	e9 27 ff ff ff       	jmp    800f37 <__udivdi3+0x27>
  801010:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801013:	31 ff                	xor    %edi,%edi
  801015:	e9 1d ff ff ff       	jmp    800f37 <__udivdi3+0x27>
  80101a:	66 90                	xchg   %ax,%ax
  80101c:	66 90                	xchg   %ax,%ax
  80101e:	66 90                	xchg   %ax,%ax

00801020 <__umoddi3>:
  801020:	55                   	push   %ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	83 ec 1c             	sub    $0x1c,%esp
  801027:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80102b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80102f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801033:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801037:	89 da                	mov    %ebx,%edx
  801039:	85 c0                	test   %eax,%eax
  80103b:	75 43                	jne    801080 <__umoddi3+0x60>
  80103d:	39 df                	cmp    %ebx,%edi
  80103f:	76 17                	jbe    801058 <__umoddi3+0x38>
  801041:	89 f0                	mov    %esi,%eax
  801043:	f7 f7                	div    %edi
  801045:	89 d0                	mov    %edx,%eax
  801047:	31 d2                	xor    %edx,%edx
  801049:	83 c4 1c             	add    $0x1c,%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    
  801051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801058:	89 fd                	mov    %edi,%ebp
  80105a:	85 ff                	test   %edi,%edi
  80105c:	75 0b                	jne    801069 <__umoddi3+0x49>
  80105e:	b8 01 00 00 00       	mov    $0x1,%eax
  801063:	31 d2                	xor    %edx,%edx
  801065:	f7 f7                	div    %edi
  801067:	89 c5                	mov    %eax,%ebp
  801069:	89 d8                	mov    %ebx,%eax
  80106b:	31 d2                	xor    %edx,%edx
  80106d:	f7 f5                	div    %ebp
  80106f:	89 f0                	mov    %esi,%eax
  801071:	f7 f5                	div    %ebp
  801073:	89 d0                	mov    %edx,%eax
  801075:	eb d0                	jmp    801047 <__umoddi3+0x27>
  801077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80107e:	66 90                	xchg   %ax,%ax
  801080:	89 f1                	mov    %esi,%ecx
  801082:	39 d8                	cmp    %ebx,%eax
  801084:	76 0a                	jbe    801090 <__umoddi3+0x70>
  801086:	89 f0                	mov    %esi,%eax
  801088:	83 c4 1c             	add    $0x1c,%esp
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    
  801090:	0f bd e8             	bsr    %eax,%ebp
  801093:	83 f5 1f             	xor    $0x1f,%ebp
  801096:	75 20                	jne    8010b8 <__umoddi3+0x98>
  801098:	39 d8                	cmp    %ebx,%eax
  80109a:	0f 82 b0 00 00 00    	jb     801150 <__umoddi3+0x130>
  8010a0:	39 f7                	cmp    %esi,%edi
  8010a2:	0f 86 a8 00 00 00    	jbe    801150 <__umoddi3+0x130>
  8010a8:	89 c8                	mov    %ecx,%eax
  8010aa:	83 c4 1c             	add    $0x1c,%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
  8010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010b8:	89 e9                	mov    %ebp,%ecx
  8010ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8010bf:	29 ea                	sub    %ebp,%edx
  8010c1:	d3 e0                	shl    %cl,%eax
  8010c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010c7:	89 d1                	mov    %edx,%ecx
  8010c9:	89 f8                	mov    %edi,%eax
  8010cb:	d3 e8                	shr    %cl,%eax
  8010cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010d9:	09 c1                	or     %eax,%ecx
  8010db:	89 d8                	mov    %ebx,%eax
  8010dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010e1:	89 e9                	mov    %ebp,%ecx
  8010e3:	d3 e7                	shl    %cl,%edi
  8010e5:	89 d1                	mov    %edx,%ecx
  8010e7:	d3 e8                	shr    %cl,%eax
  8010e9:	89 e9                	mov    %ebp,%ecx
  8010eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010ef:	d3 e3                	shl    %cl,%ebx
  8010f1:	89 c7                	mov    %eax,%edi
  8010f3:	89 d1                	mov    %edx,%ecx
  8010f5:	89 f0                	mov    %esi,%eax
  8010f7:	d3 e8                	shr    %cl,%eax
  8010f9:	89 e9                	mov    %ebp,%ecx
  8010fb:	89 fa                	mov    %edi,%edx
  8010fd:	d3 e6                	shl    %cl,%esi
  8010ff:	09 d8                	or     %ebx,%eax
  801101:	f7 74 24 08          	divl   0x8(%esp)
  801105:	89 d1                	mov    %edx,%ecx
  801107:	89 f3                	mov    %esi,%ebx
  801109:	f7 64 24 0c          	mull   0xc(%esp)
  80110d:	89 c6                	mov    %eax,%esi
  80110f:	89 d7                	mov    %edx,%edi
  801111:	39 d1                	cmp    %edx,%ecx
  801113:	72 06                	jb     80111b <__umoddi3+0xfb>
  801115:	75 10                	jne    801127 <__umoddi3+0x107>
  801117:	39 c3                	cmp    %eax,%ebx
  801119:	73 0c                	jae    801127 <__umoddi3+0x107>
  80111b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80111f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801123:	89 d7                	mov    %edx,%edi
  801125:	89 c6                	mov    %eax,%esi
  801127:	89 ca                	mov    %ecx,%edx
  801129:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80112e:	29 f3                	sub    %esi,%ebx
  801130:	19 fa                	sbb    %edi,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	d3 e0                	shl    %cl,%eax
  801136:	89 e9                	mov    %ebp,%ecx
  801138:	d3 eb                	shr    %cl,%ebx
  80113a:	d3 ea                	shr    %cl,%edx
  80113c:	09 d8                	or     %ebx,%eax
  80113e:	83 c4 1c             	add    $0x1c,%esp
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    
  801146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80114d:	8d 76 00             	lea    0x0(%esi),%esi
  801150:	89 da                	mov    %ebx,%edx
  801152:	29 fe                	sub    %edi,%esi
  801154:	19 c2                	sbb    %eax,%edx
  801156:	89 f1                	mov    %esi,%ecx
  801158:	89 c8                	mov    %ecx,%eax
  80115a:	e9 4b ff ff ff       	jmp    8010aa <__umoddi3+0x8a>
