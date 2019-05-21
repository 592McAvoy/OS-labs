
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $14");	// page fault
  800033:	cd 0e                	int    $0xe
}
  800035:	c3                   	ret    

00800036 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800041:	e8 c9 00 00 00       	call   80010f <sys_getenvid>
  800046:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004b:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80004e:	c1 e0 04             	shl    $0x4,%eax
  800051:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800056:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005b:	85 db                	test   %ebx,%ebx
  80005d:	7e 07                	jle    800066 <libmain+0x30>
		binaryname = argv[0];
  80005f:	8b 06                	mov    (%esi),%eax
  800061:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	e8 c3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800070:	e8 0a 00 00 00       	call   80007f <exit>
}
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007b:	5b                   	pop    %ebx
  80007c:	5e                   	pop    %esi
  80007d:	5d                   	pop    %ebp
  80007e:	c3                   	ret    

0080007f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007f:	55                   	push   %ebp
  800080:	89 e5                	mov    %esp,%ebp
  800082:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800085:	6a 00                	push   $0x0
  800087:	e8 42 00 00 00       	call   8000ce <sys_env_destroy>
}
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	c9                   	leave  
  800090:	c3                   	ret    

00800091 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	57                   	push   %edi
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
	asm volatile("int %1\n"
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
  80009c:	8b 55 08             	mov    0x8(%ebp),%edx
  80009f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a2:	89 c3                	mov    %eax,%ebx
  8000a4:	89 c7                	mov    %eax,%edi
  8000a6:	89 c6                	mov    %eax,%esi
  8000a8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000aa:	5b                   	pop    %ebx
  8000ab:	5e                   	pop    %esi
  8000ac:	5f                   	pop    %edi
  8000ad:	5d                   	pop    %ebp
  8000ae:	c3                   	ret    

008000af <sys_cgetc>:

int
sys_cgetc(void)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	57                   	push   %edi
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8000bf:	89 d1                	mov    %edx,%ecx
  8000c1:	89 d3                	mov    %edx,%ebx
  8000c3:	89 d7                	mov    %edx,%edi
  8000c5:	89 d6                	mov    %edx,%esi
  8000c7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    

008000ce <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	57                   	push   %edi
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
  8000d4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8000df:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e4:	89 cb                	mov    %ecx,%ebx
  8000e6:	89 cf                	mov    %ecx,%edi
  8000e8:	89 ce                	mov    %ecx,%esi
  8000ea:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	7f 08                	jg     8000f8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 03                	push   $0x3
  8000fe:	68 4a 11 80 00       	push   $0x80114a
  800103:	6a 33                	push   $0x33
  800105:	68 67 11 80 00       	push   $0x801167
  80010a:	e8 b1 02 00 00       	call   8003c0 <_panic>

0080010f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	57                   	push   %edi
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
	asm volatile("int %1\n"
  800115:	ba 00 00 00 00       	mov    $0x0,%edx
  80011a:	b8 02 00 00 00       	mov    $0x2,%eax
  80011f:	89 d1                	mov    %edx,%ecx
  800121:	89 d3                	mov    %edx,%ebx
  800123:	89 d7                	mov    %edx,%edi
  800125:	89 d6                	mov    %edx,%esi
  800127:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800129:	5b                   	pop    %ebx
  80012a:	5e                   	pop    %esi
  80012b:	5f                   	pop    %edi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <sys_yield>:

void
sys_yield(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	57                   	push   %edi
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
	asm volatile("int %1\n"
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	b8 0c 00 00 00       	mov    $0xc,%eax
  80013e:	89 d1                	mov    %edx,%ecx
  800140:	89 d3                	mov    %edx,%ebx
  800142:	89 d7                	mov    %edx,%edi
  800144:	89 d6                	mov    %edx,%esi
  800146:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5f                   	pop    %edi
  80014b:	5d                   	pop    %ebp
  80014c:	c3                   	ret    

0080014d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800156:	be 00 00 00 00       	mov    $0x0,%esi
  80015b:	8b 55 08             	mov    0x8(%ebp),%edx
  80015e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800161:	b8 04 00 00 00       	mov    $0x4,%eax
  800166:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800169:	89 f7                	mov    %esi,%edi
  80016b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80016d:	85 c0                	test   %eax,%eax
  80016f:	7f 08                	jg     800179 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	50                   	push   %eax
  80017d:	6a 04                	push   $0x4
  80017f:	68 4a 11 80 00       	push   $0x80114a
  800184:	6a 33                	push   $0x33
  800186:	68 67 11 80 00       	push   $0x801167
  80018b:	e8 30 02 00 00       	call   8003c0 <_panic>

00800190 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800199:	8b 55 08             	mov    0x8(%ebp),%edx
  80019c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019f:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001aa:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ad:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001af:	85 c0                	test   %eax,%eax
  8001b1:	7f 08                	jg     8001bb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b6:	5b                   	pop    %ebx
  8001b7:	5e                   	pop    %esi
  8001b8:	5f                   	pop    %edi
  8001b9:	5d                   	pop    %ebp
  8001ba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	50                   	push   %eax
  8001bf:	6a 05                	push   $0x5
  8001c1:	68 4a 11 80 00       	push   $0x80114a
  8001c6:	6a 33                	push   $0x33
  8001c8:	68 67 11 80 00       	push   $0x801167
  8001cd:	e8 ee 01 00 00       	call   8003c0 <_panic>

008001d2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	57                   	push   %edi
  8001d6:	56                   	push   %esi
  8001d7:	53                   	push   %ebx
  8001d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8001eb:	89 df                	mov    %ebx,%edi
  8001ed:	89 de                	mov    %ebx,%esi
  8001ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	7f 08                	jg     8001fd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f8:	5b                   	pop    %ebx
  8001f9:	5e                   	pop    %esi
  8001fa:	5f                   	pop    %edi
  8001fb:	5d                   	pop    %ebp
  8001fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	50                   	push   %eax
  800201:	6a 06                	push   $0x6
  800203:	68 4a 11 80 00       	push   $0x80114a
  800208:	6a 33                	push   $0x33
  80020a:	68 67 11 80 00       	push   $0x801167
  80020f:	e8 ac 01 00 00       	call   8003c0 <_panic>

00800214 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	57                   	push   %edi
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
  80021a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800222:	8b 55 08             	mov    0x8(%ebp),%edx
  800225:	b8 0b 00 00 00       	mov    $0xb,%eax
  80022a:	89 cb                	mov    %ecx,%ebx
  80022c:	89 cf                	mov    %ecx,%edi
  80022e:	89 ce                	mov    %ecx,%esi
  800230:	cd 30                	int    $0x30
	if(check && ret > 0)
  800232:	85 c0                	test   %eax,%eax
  800234:	7f 08                	jg     80023e <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800239:	5b                   	pop    %ebx
  80023a:	5e                   	pop    %esi
  80023b:	5f                   	pop    %edi
  80023c:	5d                   	pop    %ebp
  80023d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	50                   	push   %eax
  800242:	6a 0b                	push   $0xb
  800244:	68 4a 11 80 00       	push   $0x80114a
  800249:	6a 33                	push   $0x33
  80024b:	68 67 11 80 00       	push   $0x801167
  800250:	e8 6b 01 00 00       	call   8003c0 <_panic>

00800255 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	57                   	push   %edi
  800259:	56                   	push   %esi
  80025a:	53                   	push   %ebx
  80025b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800263:	8b 55 08             	mov    0x8(%ebp),%edx
  800266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800269:	b8 08 00 00 00       	mov    $0x8,%eax
  80026e:	89 df                	mov    %ebx,%edi
  800270:	89 de                	mov    %ebx,%esi
  800272:	cd 30                	int    $0x30
	if(check && ret > 0)
  800274:	85 c0                	test   %eax,%eax
  800276:	7f 08                	jg     800280 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027b:	5b                   	pop    %ebx
  80027c:	5e                   	pop    %esi
  80027d:	5f                   	pop    %edi
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	6a 08                	push   $0x8
  800286:	68 4a 11 80 00       	push   $0x80114a
  80028b:	6a 33                	push   $0x33
  80028d:	68 67 11 80 00       	push   $0x801167
  800292:	e8 29 01 00 00       	call   8003c0 <_panic>

00800297 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	57                   	push   %edi
  80029b:	56                   	push   %esi
  80029c:	53                   	push   %ebx
  80029d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ab:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b0:	89 df                	mov    %ebx,%edi
  8002b2:	89 de                	mov    %ebx,%esi
  8002b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	7f 08                	jg     8002c2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bd:	5b                   	pop    %ebx
  8002be:	5e                   	pop    %esi
  8002bf:	5f                   	pop    %edi
  8002c0:	5d                   	pop    %ebp
  8002c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	50                   	push   %eax
  8002c6:	6a 09                	push   $0x9
  8002c8:	68 4a 11 80 00       	push   $0x80114a
  8002cd:	6a 33                	push   $0x33
  8002cf:	68 67 11 80 00       	push   $0x801167
  8002d4:	e8 e7 00 00 00       	call   8003c0 <_panic>

008002d9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	57                   	push   %edi
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002f2:	89 df                	mov    %ebx,%edi
  8002f4:	89 de                	mov    %ebx,%esi
  8002f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f8:	85 c0                	test   %eax,%eax
  8002fa:	7f 08                	jg     800304 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ff:	5b                   	pop    %ebx
  800300:	5e                   	pop    %esi
  800301:	5f                   	pop    %edi
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	6a 0a                	push   $0xa
  80030a:	68 4a 11 80 00       	push   $0x80114a
  80030f:	6a 33                	push   $0x33
  800311:	68 67 11 80 00       	push   $0x801167
  800316:	e8 a5 00 00 00       	call   8003c0 <_panic>

0080031b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
	asm volatile("int %1\n"
  800321:	8b 55 08             	mov    0x8(%ebp),%edx
  800324:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800327:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032c:	be 00 00 00 00       	mov    $0x0,%esi
  800331:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800334:	8b 7d 14             	mov    0x14(%ebp),%edi
  800337:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800339:	5b                   	pop    %ebx
  80033a:	5e                   	pop    %esi
  80033b:	5f                   	pop    %edi
  80033c:	5d                   	pop    %ebp
  80033d:	c3                   	ret    

0080033e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	57                   	push   %edi
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
  800344:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800347:	b9 00 00 00 00       	mov    $0x0,%ecx
  80034c:	8b 55 08             	mov    0x8(%ebp),%edx
  80034f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800354:	89 cb                	mov    %ecx,%ebx
  800356:	89 cf                	mov    %ecx,%edi
  800358:	89 ce                	mov    %ecx,%esi
  80035a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80035c:	85 c0                	test   %eax,%eax
  80035e:	7f 08                	jg     800368 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800363:	5b                   	pop    %ebx
  800364:	5e                   	pop    %esi
  800365:	5f                   	pop    %edi
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	50                   	push   %eax
  80036c:	6a 0e                	push   $0xe
  80036e:	68 4a 11 80 00       	push   $0x80114a
  800373:	6a 33                	push   $0x33
  800375:	68 67 11 80 00       	push   $0x801167
  80037a:	e8 41 00 00 00       	call   8003c0 <_panic>

0080037f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	57                   	push   %edi
  800383:	56                   	push   %esi
  800384:	53                   	push   %ebx
	asm volatile("int %1\n"
  800385:	bb 00 00 00 00       	mov    $0x0,%ebx
  80038a:	8b 55 08             	mov    0x8(%ebp),%edx
  80038d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800390:	b8 0f 00 00 00       	mov    $0xf,%eax
  800395:	89 df                	mov    %ebx,%edi
  800397:	89 de                	mov    %ebx,%esi
  800399:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80039b:	5b                   	pop    %ebx
  80039c:	5e                   	pop    %esi
  80039d:	5f                   	pop    %edi
  80039e:	5d                   	pop    %ebp
  80039f:	c3                   	ret    

008003a0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ae:	b8 10 00 00 00       	mov    $0x10,%eax
  8003b3:	89 cb                	mov    %ecx,%ebx
  8003b5:	89 cf                	mov    %ecx,%edi
  8003b7:	89 ce                	mov    %ecx,%esi
  8003b9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003bb:	5b                   	pop    %ebx
  8003bc:	5e                   	pop    %esi
  8003bd:	5f                   	pop    %edi
  8003be:	5d                   	pop    %ebp
  8003bf:	c3                   	ret    

008003c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	56                   	push   %esi
  8003c4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003c5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003c8:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003ce:	e8 3c fd ff ff       	call   80010f <sys_getenvid>
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	ff 75 0c             	pushl  0xc(%ebp)
  8003d9:	ff 75 08             	pushl  0x8(%ebp)
  8003dc:	56                   	push   %esi
  8003dd:	50                   	push   %eax
  8003de:	68 78 11 80 00       	push   $0x801178
  8003e3:	e8 b3 00 00 00       	call   80049b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003e8:	83 c4 18             	add    $0x18,%esp
  8003eb:	53                   	push   %ebx
  8003ec:	ff 75 10             	pushl  0x10(%ebp)
  8003ef:	e8 56 00 00 00       	call   80044a <vcprintf>
	cprintf("\n");
  8003f4:	c7 04 24 9b 11 80 00 	movl   $0x80119b,(%esp)
  8003fb:	e8 9b 00 00 00       	call   80049b <cprintf>
  800400:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800403:	cc                   	int3   
  800404:	eb fd                	jmp    800403 <_panic+0x43>

00800406 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	53                   	push   %ebx
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800410:	8b 13                	mov    (%ebx),%edx
  800412:	8d 42 01             	lea    0x1(%edx),%eax
  800415:	89 03                	mov    %eax,(%ebx)
  800417:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80041a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80041e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800423:	74 09                	je     80042e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800425:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800429:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	68 ff 00 00 00       	push   $0xff
  800436:	8d 43 08             	lea    0x8(%ebx),%eax
  800439:	50                   	push   %eax
  80043a:	e8 52 fc ff ff       	call   800091 <sys_cputs>
		b->idx = 0;
  80043f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	eb db                	jmp    800425 <putch+0x1f>

0080044a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800453:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80045a:	00 00 00 
	b.cnt = 0;
  80045d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800464:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800467:	ff 75 0c             	pushl  0xc(%ebp)
  80046a:	ff 75 08             	pushl  0x8(%ebp)
  80046d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800473:	50                   	push   %eax
  800474:	68 06 04 80 00       	push   $0x800406
  800479:	e8 4a 01 00 00       	call   8005c8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80047e:	83 c4 08             	add    $0x8,%esp
  800481:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800487:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80048d:	50                   	push   %eax
  80048e:	e8 fe fb ff ff       	call   800091 <sys_cputs>

	return b.cnt;
}
  800493:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800499:	c9                   	leave  
  80049a:	c3                   	ret    

0080049b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004a4:	50                   	push   %eax
  8004a5:	ff 75 08             	pushl  0x8(%ebp)
  8004a8:	e8 9d ff ff ff       	call   80044a <vcprintf>
	va_end(ap);

	return cnt;
}
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    

008004af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004af:	55                   	push   %ebp
  8004b0:	89 e5                	mov    %esp,%ebp
  8004b2:	57                   	push   %edi
  8004b3:	56                   	push   %esi
  8004b4:	53                   	push   %ebx
  8004b5:	83 ec 1c             	sub    $0x1c,%esp
  8004b8:	89 c6                	mov    %eax,%esi
  8004ba:	89 d7                	mov    %edx,%edi
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004ce:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004d2:	74 2c                	je     800500 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e4:	39 c2                	cmp    %eax,%edx
  8004e6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004e9:	73 43                	jae    80052e <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004eb:	83 eb 01             	sub    $0x1,%ebx
  8004ee:	85 db                	test   %ebx,%ebx
  8004f0:	7e 6c                	jle    80055e <printnum+0xaf>
			putch(padc, putdat);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	57                   	push   %edi
  8004f6:	ff 75 18             	pushl  0x18(%ebp)
  8004f9:	ff d6                	call   *%esi
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	eb eb                	jmp    8004eb <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800500:	83 ec 0c             	sub    $0xc,%esp
  800503:	6a 20                	push   $0x20
  800505:	6a 00                	push   $0x0
  800507:	50                   	push   %eax
  800508:	ff 75 e4             	pushl  -0x1c(%ebp)
  80050b:	ff 75 e0             	pushl  -0x20(%ebp)
  80050e:	89 fa                	mov    %edi,%edx
  800510:	89 f0                	mov    %esi,%eax
  800512:	e8 98 ff ff ff       	call   8004af <printnum>
		while (--width > 0)
  800517:	83 c4 20             	add    $0x20,%esp
  80051a:	83 eb 01             	sub    $0x1,%ebx
  80051d:	85 db                	test   %ebx,%ebx
  80051f:	7e 65                	jle    800586 <printnum+0xd7>
			putch(padc, putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	57                   	push   %edi
  800525:	6a 20                	push   $0x20
  800527:	ff d6                	call   *%esi
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	eb ec                	jmp    80051a <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	ff 75 18             	pushl  0x18(%ebp)
  800534:	83 eb 01             	sub    $0x1,%ebx
  800537:	53                   	push   %ebx
  800538:	50                   	push   %eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 dc             	pushl  -0x24(%ebp)
  80053f:	ff 75 d8             	pushl  -0x28(%ebp)
  800542:	ff 75 e4             	pushl  -0x1c(%ebp)
  800545:	ff 75 e0             	pushl  -0x20(%ebp)
  800548:	e8 93 09 00 00       	call   800ee0 <__udivdi3>
  80054d:	83 c4 18             	add    $0x18,%esp
  800550:	52                   	push   %edx
  800551:	50                   	push   %eax
  800552:	89 fa                	mov    %edi,%edx
  800554:	89 f0                	mov    %esi,%eax
  800556:	e8 54 ff ff ff       	call   8004af <printnum>
  80055b:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	57                   	push   %edi
  800562:	83 ec 04             	sub    $0x4,%esp
  800565:	ff 75 dc             	pushl  -0x24(%ebp)
  800568:	ff 75 d8             	pushl  -0x28(%ebp)
  80056b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056e:	ff 75 e0             	pushl  -0x20(%ebp)
  800571:	e8 7a 0a 00 00       	call   800ff0 <__umoddi3>
  800576:	83 c4 14             	add    $0x14,%esp
  800579:	0f be 80 9d 11 80 00 	movsbl 0x80119d(%eax),%eax
  800580:	50                   	push   %eax
  800581:	ff d6                	call   *%esi
  800583:	83 c4 10             	add    $0x10,%esp
}
  800586:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800589:	5b                   	pop    %ebx
  80058a:	5e                   	pop    %esi
  80058b:	5f                   	pop    %edi
  80058c:	5d                   	pop    %ebp
  80058d:	c3                   	ret    

0080058e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800594:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800598:	8b 10                	mov    (%eax),%edx
  80059a:	3b 50 04             	cmp    0x4(%eax),%edx
  80059d:	73 0a                	jae    8005a9 <sprintputch+0x1b>
		*b->buf++ = ch;
  80059f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005a2:	89 08                	mov    %ecx,(%eax)
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	88 02                	mov    %al,(%edx)
}
  8005a9:	5d                   	pop    %ebp
  8005aa:	c3                   	ret    

008005ab <printfmt>:
{
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005b1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005b4:	50                   	push   %eax
  8005b5:	ff 75 10             	pushl  0x10(%ebp)
  8005b8:	ff 75 0c             	pushl  0xc(%ebp)
  8005bb:	ff 75 08             	pushl  0x8(%ebp)
  8005be:	e8 05 00 00 00       	call   8005c8 <vprintfmt>
}
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	c9                   	leave  
  8005c7:	c3                   	ret    

008005c8 <vprintfmt>:
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	57                   	push   %edi
  8005cc:	56                   	push   %esi
  8005cd:	53                   	push   %ebx
  8005ce:	83 ec 3c             	sub    $0x3c,%esp
  8005d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005da:	e9 b4 03 00 00       	jmp    800993 <vprintfmt+0x3cb>
		padc = ' ';
  8005df:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8005e3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8005ea:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800604:	8d 47 01             	lea    0x1(%edi),%eax
  800607:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80060a:	0f b6 17             	movzbl (%edi),%edx
  80060d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800610:	3c 55                	cmp    $0x55,%al
  800612:	0f 87 c8 04 00 00    	ja     800ae0 <vprintfmt+0x518>
  800618:	0f b6 c0             	movzbl %al,%eax
  80061b:	ff 24 85 80 13 80 00 	jmp    *0x801380(,%eax,4)
  800622:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800625:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80062c:	eb d6                	jmp    800604 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80062e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800631:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800635:	eb cd                	jmp    800604 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800637:	0f b6 d2             	movzbl %dl,%edx
  80063a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80063d:	b8 00 00 00 00       	mov    $0x0,%eax
  800642:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800645:	eb 0c                	jmp    800653 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800647:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80064a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80064e:	eb b4                	jmp    800604 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800650:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800653:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800656:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80065a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80065d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800660:	83 f9 09             	cmp    $0x9,%ecx
  800663:	76 eb                	jbe    800650 <vprintfmt+0x88>
  800665:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800668:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066b:	eb 14                	jmp    800681 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80067e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800681:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800685:	0f 89 79 ff ff ff    	jns    800604 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80068b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80068e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800691:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800698:	e9 67 ff ff ff       	jmp    800604 <vprintfmt+0x3c>
  80069d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a0:	85 c0                	test   %eax,%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	0f 49 d0             	cmovns %eax,%edx
  8006aa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006b0:	e9 4f ff ff ff       	jmp    800604 <vprintfmt+0x3c>
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006b8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006bf:	e9 40 ff ff ff       	jmp    800604 <vprintfmt+0x3c>
			lflag++;
  8006c4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006ca:	e9 35 ff ff ff       	jmp    800604 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8d 78 04             	lea    0x4(%eax),%edi
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	53                   	push   %ebx
  8006d9:	ff 30                	pushl  (%eax)
  8006db:	ff d6                	call   *%esi
			break;
  8006dd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006e0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006e3:	e9 a8 02 00 00       	jmp    800990 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 78 04             	lea    0x4(%eax),%edi
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	31 d0                	xor    %edx,%eax
  8006f3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006f5:	83 f8 0f             	cmp    $0xf,%eax
  8006f8:	7f 23                	jg     80071d <vprintfmt+0x155>
  8006fa:	8b 14 85 e0 14 80 00 	mov    0x8014e0(,%eax,4),%edx
  800701:	85 d2                	test   %edx,%edx
  800703:	74 18                	je     80071d <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800705:	52                   	push   %edx
  800706:	68 be 11 80 00       	push   $0x8011be
  80070b:	53                   	push   %ebx
  80070c:	56                   	push   %esi
  80070d:	e8 99 fe ff ff       	call   8005ab <printfmt>
  800712:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800715:	89 7d 14             	mov    %edi,0x14(%ebp)
  800718:	e9 73 02 00 00       	jmp    800990 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80071d:	50                   	push   %eax
  80071e:	68 b5 11 80 00       	push   $0x8011b5
  800723:	53                   	push   %ebx
  800724:	56                   	push   %esi
  800725:	e8 81 fe ff ff       	call   8005ab <printfmt>
  80072a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80072d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800730:	e9 5b 02 00 00       	jmp    800990 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	83 c0 04             	add    $0x4,%eax
  80073b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800743:	85 d2                	test   %edx,%edx
  800745:	b8 ae 11 80 00       	mov    $0x8011ae,%eax
  80074a:	0f 45 c2             	cmovne %edx,%eax
  80074d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800750:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800754:	7e 06                	jle    80075c <vprintfmt+0x194>
  800756:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80075a:	75 0d                	jne    800769 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80075c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80075f:	89 c7                	mov    %eax,%edi
  800761:	03 45 e0             	add    -0x20(%ebp),%eax
  800764:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800767:	eb 53                	jmp    8007bc <vprintfmt+0x1f4>
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 d8             	pushl  -0x28(%ebp)
  80076f:	50                   	push   %eax
  800770:	e8 13 04 00 00       	call   800b88 <strnlen>
  800775:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800778:	29 c1                	sub    %eax,%ecx
  80077a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800782:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800786:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800789:	eb 0f                	jmp    80079a <vprintfmt+0x1d2>
					putch(padc, putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	53                   	push   %ebx
  80078f:	ff 75 e0             	pushl  -0x20(%ebp)
  800792:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800794:	83 ef 01             	sub    $0x1,%edi
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	85 ff                	test   %edi,%edi
  80079c:	7f ed                	jg     80078b <vprintfmt+0x1c3>
  80079e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007a1:	85 d2                	test   %edx,%edx
  8007a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a8:	0f 49 c2             	cmovns %edx,%eax
  8007ab:	29 c2                	sub    %eax,%edx
  8007ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007b0:	eb aa                	jmp    80075c <vprintfmt+0x194>
					putch(ch, putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	52                   	push   %edx
  8007b7:	ff d6                	call   *%esi
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007bf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c1:	83 c7 01             	add    $0x1,%edi
  8007c4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007c8:	0f be d0             	movsbl %al,%edx
  8007cb:	85 d2                	test   %edx,%edx
  8007cd:	74 4b                	je     80081a <vprintfmt+0x252>
  8007cf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007d3:	78 06                	js     8007db <vprintfmt+0x213>
  8007d5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007d9:	78 1e                	js     8007f9 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8007db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007df:	74 d1                	je     8007b2 <vprintfmt+0x1ea>
  8007e1:	0f be c0             	movsbl %al,%eax
  8007e4:	83 e8 20             	sub    $0x20,%eax
  8007e7:	83 f8 5e             	cmp    $0x5e,%eax
  8007ea:	76 c6                	jbe    8007b2 <vprintfmt+0x1ea>
					putch('?', putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	53                   	push   %ebx
  8007f0:	6a 3f                	push   $0x3f
  8007f2:	ff d6                	call   *%esi
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	eb c3                	jmp    8007bc <vprintfmt+0x1f4>
  8007f9:	89 cf                	mov    %ecx,%edi
  8007fb:	eb 0e                	jmp    80080b <vprintfmt+0x243>
				putch(' ', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	53                   	push   %ebx
  800801:	6a 20                	push   $0x20
  800803:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800805:	83 ef 01             	sub    $0x1,%edi
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	85 ff                	test   %edi,%edi
  80080d:	7f ee                	jg     8007fd <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80080f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800812:	89 45 14             	mov    %eax,0x14(%ebp)
  800815:	e9 76 01 00 00       	jmp    800990 <vprintfmt+0x3c8>
  80081a:	89 cf                	mov    %ecx,%edi
  80081c:	eb ed                	jmp    80080b <vprintfmt+0x243>
	if (lflag >= 2)
  80081e:	83 f9 01             	cmp    $0x1,%ecx
  800821:	7f 1f                	jg     800842 <vprintfmt+0x27a>
	else if (lflag)
  800823:	85 c9                	test   %ecx,%ecx
  800825:	74 6a                	je     800891 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082f:	89 c1                	mov    %eax,%ecx
  800831:	c1 f9 1f             	sar    $0x1f,%ecx
  800834:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	8d 40 04             	lea    0x4(%eax),%eax
  80083d:	89 45 14             	mov    %eax,0x14(%ebp)
  800840:	eb 17                	jmp    800859 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 50 04             	mov    0x4(%eax),%edx
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8d 40 08             	lea    0x8(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800859:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80085c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800861:	85 d2                	test   %edx,%edx
  800863:	0f 89 f8 00 00 00    	jns    800961 <vprintfmt+0x399>
				putch('-', putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	53                   	push   %ebx
  80086d:	6a 2d                	push   $0x2d
  80086f:	ff d6                	call   *%esi
				num = -(long long) num;
  800871:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800874:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800877:	f7 d8                	neg    %eax
  800879:	83 d2 00             	adc    $0x0,%edx
  80087c:	f7 da                	neg    %edx
  80087e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800881:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800884:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800887:	bf 0a 00 00 00       	mov    $0xa,%edi
  80088c:	e9 e1 00 00 00       	jmp    800972 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800899:	99                   	cltd   
  80089a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 40 04             	lea    0x4(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a6:	eb b1                	jmp    800859 <vprintfmt+0x291>
	if (lflag >= 2)
  8008a8:	83 f9 01             	cmp    $0x1,%ecx
  8008ab:	7f 27                	jg     8008d4 <vprintfmt+0x30c>
	else if (lflag)
  8008ad:	85 c9                	test   %ecx,%ecx
  8008af:	74 41                	je     8008f2 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8d 40 04             	lea    0x4(%eax),%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ca:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008cf:	e9 8d 00 00 00       	jmp    800961 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	8b 50 04             	mov    0x4(%eax),%edx
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8d 40 08             	lea    0x8(%eax),%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008eb:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008f0:	eb 6f                	jmp    800961 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8d 40 04             	lea    0x4(%eax),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800910:	eb 4f                	jmp    800961 <vprintfmt+0x399>
	if (lflag >= 2)
  800912:	83 f9 01             	cmp    $0x1,%ecx
  800915:	7f 23                	jg     80093a <vprintfmt+0x372>
	else if (lflag)
  800917:	85 c9                	test   %ecx,%ecx
  800919:	0f 84 98 00 00 00    	je     8009b7 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
  800929:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8d 40 04             	lea    0x4(%eax),%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	eb 17                	jmp    800951 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8b 50 04             	mov    0x4(%eax),%edx
  800940:	8b 00                	mov    (%eax),%eax
  800942:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800945:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8d 40 08             	lea    0x8(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	53                   	push   %ebx
  800955:	6a 30                	push   $0x30
  800957:	ff d6                	call   *%esi
			goto number;
  800959:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80095c:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800961:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800965:	74 0b                	je     800972 <vprintfmt+0x3aa>
				putch('+', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	53                   	push   %ebx
  80096b:	6a 2b                	push   $0x2b
  80096d:	ff d6                	call   *%esi
  80096f:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800972:	83 ec 0c             	sub    $0xc,%esp
  800975:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800979:	50                   	push   %eax
  80097a:	ff 75 e0             	pushl  -0x20(%ebp)
  80097d:	57                   	push   %edi
  80097e:	ff 75 dc             	pushl  -0x24(%ebp)
  800981:	ff 75 d8             	pushl  -0x28(%ebp)
  800984:	89 da                	mov    %ebx,%edx
  800986:	89 f0                	mov    %esi,%eax
  800988:	e8 22 fb ff ff       	call   8004af <printnum>
			break;
  80098d:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800990:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800993:	83 c7 01             	add    $0x1,%edi
  800996:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80099a:	83 f8 25             	cmp    $0x25,%eax
  80099d:	0f 84 3c fc ff ff    	je     8005df <vprintfmt+0x17>
			if (ch == '\0')
  8009a3:	85 c0                	test   %eax,%eax
  8009a5:	0f 84 55 01 00 00    	je     800b00 <vprintfmt+0x538>
			putch(ch, putdat);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	53                   	push   %ebx
  8009af:	50                   	push   %eax
  8009b0:	ff d6                	call   *%esi
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	eb dc                	jmp    800993 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ca:	8d 40 04             	lea    0x4(%eax),%eax
  8009cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d0:	e9 7c ff ff ff       	jmp    800951 <vprintfmt+0x389>
			putch('0', putdat);
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	53                   	push   %ebx
  8009d9:	6a 30                	push   $0x30
  8009db:	ff d6                	call   *%esi
			putch('x', putdat);
  8009dd:	83 c4 08             	add    $0x8,%esp
  8009e0:	53                   	push   %ebx
  8009e1:	6a 78                	push   $0x78
  8009e3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e8:	8b 00                	mov    (%eax),%eax
  8009ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009f5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	8d 40 04             	lea    0x4(%eax),%eax
  8009fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a01:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a06:	e9 56 ff ff ff       	jmp    800961 <vprintfmt+0x399>
	if (lflag >= 2)
  800a0b:	83 f9 01             	cmp    $0x1,%ecx
  800a0e:	7f 27                	jg     800a37 <vprintfmt+0x46f>
	else if (lflag)
  800a10:	85 c9                	test   %ecx,%ecx
  800a12:	74 44                	je     800a58 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8b 00                	mov    (%eax),%eax
  800a19:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a21:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	8d 40 04             	lea    0x4(%eax),%eax
  800a2a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a2d:	bf 10 00 00 00       	mov    $0x10,%edi
  800a32:	e9 2a ff ff ff       	jmp    800961 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	8b 50 04             	mov    0x4(%eax),%edx
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a42:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	8d 40 08             	lea    0x8(%eax),%eax
  800a4b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a4e:	bf 10 00 00 00       	mov    $0x10,%edi
  800a53:	e9 09 ff ff ff       	jmp    800961 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	8b 00                	mov    (%eax),%eax
  800a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a62:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a65:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	8d 40 04             	lea    0x4(%eax),%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a71:	bf 10 00 00 00       	mov    $0x10,%edi
  800a76:	e9 e6 fe ff ff       	jmp    800961 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8d 78 04             	lea    0x4(%eax),%edi
  800a81:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800a83:	85 c0                	test   %eax,%eax
  800a85:	74 2d                	je     800ab4 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800a87:	0f b6 13             	movzbl (%ebx),%edx
  800a8a:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a8c:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800a8f:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a92:	0f 8e f8 fe ff ff    	jle    800990 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800a98:	68 0c 13 80 00       	push   $0x80130c
  800a9d:	68 be 11 80 00       	push   $0x8011be
  800aa2:	53                   	push   %ebx
  800aa3:	56                   	push   %esi
  800aa4:	e8 02 fb ff ff       	call   8005ab <printfmt>
  800aa9:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800aac:	89 7d 14             	mov    %edi,0x14(%ebp)
  800aaf:	e9 dc fe ff ff       	jmp    800990 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800ab4:	68 d4 12 80 00       	push   $0x8012d4
  800ab9:	68 be 11 80 00       	push   $0x8011be
  800abe:	53                   	push   %ebx
  800abf:	56                   	push   %esi
  800ac0:	e8 e6 fa ff ff       	call   8005ab <printfmt>
  800ac5:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ac8:	89 7d 14             	mov    %edi,0x14(%ebp)
  800acb:	e9 c0 fe ff ff       	jmp    800990 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	53                   	push   %ebx
  800ad4:	6a 25                	push   $0x25
  800ad6:	ff d6                	call   *%esi
			break;
  800ad8:	83 c4 10             	add    $0x10,%esp
  800adb:	e9 b0 fe ff ff       	jmp    800990 <vprintfmt+0x3c8>
			putch('%', putdat);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	53                   	push   %ebx
  800ae4:	6a 25                	push   $0x25
  800ae6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae8:	83 c4 10             	add    $0x10,%esp
  800aeb:	89 f8                	mov    %edi,%eax
  800aed:	eb 03                	jmp    800af2 <vprintfmt+0x52a>
  800aef:	83 e8 01             	sub    $0x1,%eax
  800af2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800af6:	75 f7                	jne    800aef <vprintfmt+0x527>
  800af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afb:	e9 90 fe ff ff       	jmp    800990 <vprintfmt+0x3c8>
}
  800b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b17:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b1b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b25:	85 c0                	test   %eax,%eax
  800b27:	74 26                	je     800b4f <vsnprintf+0x47>
  800b29:	85 d2                	test   %edx,%edx
  800b2b:	7e 22                	jle    800b4f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b2d:	ff 75 14             	pushl  0x14(%ebp)
  800b30:	ff 75 10             	pushl  0x10(%ebp)
  800b33:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b36:	50                   	push   %eax
  800b37:	68 8e 05 80 00       	push   $0x80058e
  800b3c:	e8 87 fa ff ff       	call   8005c8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b44:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b4a:	83 c4 10             	add    $0x10,%esp
}
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    
		return -E_INVAL;
  800b4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b54:	eb f7                	jmp    800b4d <vsnprintf+0x45>

00800b56 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b5c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b5f:	50                   	push   %eax
  800b60:	ff 75 10             	pushl  0x10(%ebp)
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	ff 75 08             	pushl  0x8(%ebp)
  800b69:	e8 9a ff ff ff       	call   800b08 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b7f:	74 05                	je     800b86 <strlen+0x16>
		n++;
  800b81:	83 c0 01             	add    $0x1,%eax
  800b84:	eb f5                	jmp    800b7b <strlen+0xb>
	return n;
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b91:	ba 00 00 00 00       	mov    $0x0,%edx
  800b96:	39 c2                	cmp    %eax,%edx
  800b98:	74 0d                	je     800ba7 <strnlen+0x1f>
  800b9a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b9e:	74 05                	je     800ba5 <strnlen+0x1d>
		n++;
  800ba0:	83 c2 01             	add    $0x1,%edx
  800ba3:	eb f1                	jmp    800b96 <strnlen+0xe>
  800ba5:	89 d0                	mov    %edx,%eax
	return n;
}
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bbc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bbf:	83 c2 01             	add    $0x1,%edx
  800bc2:	84 c9                	test   %cl,%cl
  800bc4:	75 f2                	jne    800bb8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	53                   	push   %ebx
  800bcd:	83 ec 10             	sub    $0x10,%esp
  800bd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bd3:	53                   	push   %ebx
  800bd4:	e8 97 ff ff ff       	call   800b70 <strlen>
  800bd9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	01 d8                	add    %ebx,%eax
  800be1:	50                   	push   %eax
  800be2:	e8 c2 ff ff ff       	call   800ba9 <strcpy>
	return dst;
}
  800be7:	89 d8                	mov    %ebx,%eax
  800be9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	89 c6                	mov    %eax,%esi
  800bfb:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bfe:	89 c2                	mov    %eax,%edx
  800c00:	39 f2                	cmp    %esi,%edx
  800c02:	74 11                	je     800c15 <strncpy+0x27>
		*dst++ = *src;
  800c04:	83 c2 01             	add    $0x1,%edx
  800c07:	0f b6 19             	movzbl (%ecx),%ebx
  800c0a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c0d:	80 fb 01             	cmp    $0x1,%bl
  800c10:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c13:	eb eb                	jmp    800c00 <strncpy+0x12>
	}
	return ret;
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
  800c1e:	8b 75 08             	mov    0x8(%ebp),%esi
  800c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c24:	8b 55 10             	mov    0x10(%ebp),%edx
  800c27:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c29:	85 d2                	test   %edx,%edx
  800c2b:	74 21                	je     800c4e <strlcpy+0x35>
  800c2d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c31:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c33:	39 c2                	cmp    %eax,%edx
  800c35:	74 14                	je     800c4b <strlcpy+0x32>
  800c37:	0f b6 19             	movzbl (%ecx),%ebx
  800c3a:	84 db                	test   %bl,%bl
  800c3c:	74 0b                	je     800c49 <strlcpy+0x30>
			*dst++ = *src++;
  800c3e:	83 c1 01             	add    $0x1,%ecx
  800c41:	83 c2 01             	add    $0x1,%edx
  800c44:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c47:	eb ea                	jmp    800c33 <strlcpy+0x1a>
  800c49:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c4b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c4e:	29 f0                	sub    %esi,%eax
}
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c5d:	0f b6 01             	movzbl (%ecx),%eax
  800c60:	84 c0                	test   %al,%al
  800c62:	74 0c                	je     800c70 <strcmp+0x1c>
  800c64:	3a 02                	cmp    (%edx),%al
  800c66:	75 08                	jne    800c70 <strcmp+0x1c>
		p++, q++;
  800c68:	83 c1 01             	add    $0x1,%ecx
  800c6b:	83 c2 01             	add    $0x1,%edx
  800c6e:	eb ed                	jmp    800c5d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c70:	0f b6 c0             	movzbl %al,%eax
  800c73:	0f b6 12             	movzbl (%edx),%edx
  800c76:	29 d0                	sub    %edx,%eax
}
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	53                   	push   %ebx
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c84:	89 c3                	mov    %eax,%ebx
  800c86:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c89:	eb 06                	jmp    800c91 <strncmp+0x17>
		n--, p++, q++;
  800c8b:	83 c0 01             	add    $0x1,%eax
  800c8e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c91:	39 d8                	cmp    %ebx,%eax
  800c93:	74 16                	je     800cab <strncmp+0x31>
  800c95:	0f b6 08             	movzbl (%eax),%ecx
  800c98:	84 c9                	test   %cl,%cl
  800c9a:	74 04                	je     800ca0 <strncmp+0x26>
  800c9c:	3a 0a                	cmp    (%edx),%cl
  800c9e:	74 eb                	je     800c8b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca0:	0f b6 00             	movzbl (%eax),%eax
  800ca3:	0f b6 12             	movzbl (%edx),%edx
  800ca6:	29 d0                	sub    %edx,%eax
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		return 0;
  800cab:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb0:	eb f6                	jmp    800ca8 <strncmp+0x2e>

00800cb2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cbc:	0f b6 10             	movzbl (%eax),%edx
  800cbf:	84 d2                	test   %dl,%dl
  800cc1:	74 09                	je     800ccc <strchr+0x1a>
		if (*s == c)
  800cc3:	38 ca                	cmp    %cl,%dl
  800cc5:	74 0a                	je     800cd1 <strchr+0x1f>
	for (; *s; s++)
  800cc7:	83 c0 01             	add    $0x1,%eax
  800cca:	eb f0                	jmp    800cbc <strchr+0xa>
			return (char *) s;
	return 0;
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cdd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ce0:	38 ca                	cmp    %cl,%dl
  800ce2:	74 09                	je     800ced <strfind+0x1a>
  800ce4:	84 d2                	test   %dl,%dl
  800ce6:	74 05                	je     800ced <strfind+0x1a>
	for (; *s; s++)
  800ce8:	83 c0 01             	add    $0x1,%eax
  800ceb:	eb f0                	jmp    800cdd <strfind+0xa>
			break;
	return (char *) s;
}
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
  800cf5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cfb:	85 c9                	test   %ecx,%ecx
  800cfd:	74 31                	je     800d30 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cff:	89 f8                	mov    %edi,%eax
  800d01:	09 c8                	or     %ecx,%eax
  800d03:	a8 03                	test   $0x3,%al
  800d05:	75 23                	jne    800d2a <memset+0x3b>
		c &= 0xFF;
  800d07:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d0b:	89 d3                	mov    %edx,%ebx
  800d0d:	c1 e3 08             	shl    $0x8,%ebx
  800d10:	89 d0                	mov    %edx,%eax
  800d12:	c1 e0 18             	shl    $0x18,%eax
  800d15:	89 d6                	mov    %edx,%esi
  800d17:	c1 e6 10             	shl    $0x10,%esi
  800d1a:	09 f0                	or     %esi,%eax
  800d1c:	09 c2                	or     %eax,%edx
  800d1e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d20:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d23:	89 d0                	mov    %edx,%eax
  800d25:	fc                   	cld    
  800d26:	f3 ab                	rep stos %eax,%es:(%edi)
  800d28:	eb 06                	jmp    800d30 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	fc                   	cld    
  800d2e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d30:	89 f8                	mov    %edi,%eax
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d42:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d45:	39 c6                	cmp    %eax,%esi
  800d47:	73 32                	jae    800d7b <memmove+0x44>
  800d49:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d4c:	39 c2                	cmp    %eax,%edx
  800d4e:	76 2b                	jbe    800d7b <memmove+0x44>
		s += n;
		d += n;
  800d50:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d53:	89 fe                	mov    %edi,%esi
  800d55:	09 ce                	or     %ecx,%esi
  800d57:	09 d6                	or     %edx,%esi
  800d59:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d5f:	75 0e                	jne    800d6f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d61:	83 ef 04             	sub    $0x4,%edi
  800d64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d67:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d6a:	fd                   	std    
  800d6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d6d:	eb 09                	jmp    800d78 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d6f:	83 ef 01             	sub    $0x1,%edi
  800d72:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d75:	fd                   	std    
  800d76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d78:	fc                   	cld    
  800d79:	eb 1a                	jmp    800d95 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d7b:	89 c2                	mov    %eax,%edx
  800d7d:	09 ca                	or     %ecx,%edx
  800d7f:	09 f2                	or     %esi,%edx
  800d81:	f6 c2 03             	test   $0x3,%dl
  800d84:	75 0a                	jne    800d90 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d86:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d89:	89 c7                	mov    %eax,%edi
  800d8b:	fc                   	cld    
  800d8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d8e:	eb 05                	jmp    800d95 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d90:	89 c7                	mov    %eax,%edi
  800d92:	fc                   	cld    
  800d93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d9f:	ff 75 10             	pushl  0x10(%ebp)
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 8a ff ff ff       	call   800d37 <memmove>
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbf:	39 f0                	cmp    %esi,%eax
  800dc1:	74 1c                	je     800ddf <memcmp+0x30>
		if (*s1 != *s2)
  800dc3:	0f b6 08             	movzbl (%eax),%ecx
  800dc6:	0f b6 1a             	movzbl (%edx),%ebx
  800dc9:	38 d9                	cmp    %bl,%cl
  800dcb:	75 08                	jne    800dd5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dcd:	83 c0 01             	add    $0x1,%eax
  800dd0:	83 c2 01             	add    $0x1,%edx
  800dd3:	eb ea                	jmp    800dbf <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dd5:	0f b6 c1             	movzbl %cl,%eax
  800dd8:	0f b6 db             	movzbl %bl,%ebx
  800ddb:	29 d8                	sub    %ebx,%eax
  800ddd:	eb 05                	jmp    800de4 <memcmp+0x35>
	}

	return 0;
  800ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800df1:	89 c2                	mov    %eax,%edx
  800df3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df6:	39 d0                	cmp    %edx,%eax
  800df8:	73 09                	jae    800e03 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dfa:	38 08                	cmp    %cl,(%eax)
  800dfc:	74 05                	je     800e03 <memfind+0x1b>
	for (; s < ends; s++)
  800dfe:	83 c0 01             	add    $0x1,%eax
  800e01:	eb f3                	jmp    800df6 <memfind+0xe>
			break;
	return (void *) s;
}
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e11:	eb 03                	jmp    800e16 <strtol+0x11>
		s++;
  800e13:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e16:	0f b6 01             	movzbl (%ecx),%eax
  800e19:	3c 20                	cmp    $0x20,%al
  800e1b:	74 f6                	je     800e13 <strtol+0xe>
  800e1d:	3c 09                	cmp    $0x9,%al
  800e1f:	74 f2                	je     800e13 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e21:	3c 2b                	cmp    $0x2b,%al
  800e23:	74 2a                	je     800e4f <strtol+0x4a>
	int neg = 0;
  800e25:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e2a:	3c 2d                	cmp    $0x2d,%al
  800e2c:	74 2b                	je     800e59 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e2e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e34:	75 0f                	jne    800e45 <strtol+0x40>
  800e36:	80 39 30             	cmpb   $0x30,(%ecx)
  800e39:	74 28                	je     800e63 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e3b:	85 db                	test   %ebx,%ebx
  800e3d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e42:	0f 44 d8             	cmove  %eax,%ebx
  800e45:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e4d:	eb 50                	jmp    800e9f <strtol+0x9a>
		s++;
  800e4f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e52:	bf 00 00 00 00       	mov    $0x0,%edi
  800e57:	eb d5                	jmp    800e2e <strtol+0x29>
		s++, neg = 1;
  800e59:	83 c1 01             	add    $0x1,%ecx
  800e5c:	bf 01 00 00 00       	mov    $0x1,%edi
  800e61:	eb cb                	jmp    800e2e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e63:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e67:	74 0e                	je     800e77 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e69:	85 db                	test   %ebx,%ebx
  800e6b:	75 d8                	jne    800e45 <strtol+0x40>
		s++, base = 8;
  800e6d:	83 c1 01             	add    $0x1,%ecx
  800e70:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e75:	eb ce                	jmp    800e45 <strtol+0x40>
		s += 2, base = 16;
  800e77:	83 c1 02             	add    $0x2,%ecx
  800e7a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e7f:	eb c4                	jmp    800e45 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e81:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e84:	89 f3                	mov    %esi,%ebx
  800e86:	80 fb 19             	cmp    $0x19,%bl
  800e89:	77 29                	ja     800eb4 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e8b:	0f be d2             	movsbl %dl,%edx
  800e8e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e91:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e94:	7d 30                	jge    800ec6 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e96:	83 c1 01             	add    $0x1,%ecx
  800e99:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e9d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e9f:	0f b6 11             	movzbl (%ecx),%edx
  800ea2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ea5:	89 f3                	mov    %esi,%ebx
  800ea7:	80 fb 09             	cmp    $0x9,%bl
  800eaa:	77 d5                	ja     800e81 <strtol+0x7c>
			dig = *s - '0';
  800eac:	0f be d2             	movsbl %dl,%edx
  800eaf:	83 ea 30             	sub    $0x30,%edx
  800eb2:	eb dd                	jmp    800e91 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eb4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eb7:	89 f3                	mov    %esi,%ebx
  800eb9:	80 fb 19             	cmp    $0x19,%bl
  800ebc:	77 08                	ja     800ec6 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ebe:	0f be d2             	movsbl %dl,%edx
  800ec1:	83 ea 37             	sub    $0x37,%edx
  800ec4:	eb cb                	jmp    800e91 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ec6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eca:	74 05                	je     800ed1 <strtol+0xcc>
		*endptr = (char *) s;
  800ecc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ecf:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ed1:	89 c2                	mov    %eax,%edx
  800ed3:	f7 da                	neg    %edx
  800ed5:	85 ff                	test   %edi,%edi
  800ed7:	0f 45 c2             	cmovne %edx,%eax
}
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    
  800edf:	90                   	nop

00800ee0 <__udivdi3>:
  800ee0:	55                   	push   %ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 1c             	sub    $0x1c,%esp
  800ee7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800eeb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800eef:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ef3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ef7:	85 d2                	test   %edx,%edx
  800ef9:	75 4d                	jne    800f48 <__udivdi3+0x68>
  800efb:	39 f3                	cmp    %esi,%ebx
  800efd:	76 19                	jbe    800f18 <__udivdi3+0x38>
  800eff:	31 ff                	xor    %edi,%edi
  800f01:	89 e8                	mov    %ebp,%eax
  800f03:	89 f2                	mov    %esi,%edx
  800f05:	f7 f3                	div    %ebx
  800f07:	89 fa                	mov    %edi,%edx
  800f09:	83 c4 1c             	add    $0x1c,%esp
  800f0c:	5b                   	pop    %ebx
  800f0d:	5e                   	pop    %esi
  800f0e:	5f                   	pop    %edi
  800f0f:	5d                   	pop    %ebp
  800f10:	c3                   	ret    
  800f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f18:	89 d9                	mov    %ebx,%ecx
  800f1a:	85 db                	test   %ebx,%ebx
  800f1c:	75 0b                	jne    800f29 <__udivdi3+0x49>
  800f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f23:	31 d2                	xor    %edx,%edx
  800f25:	f7 f3                	div    %ebx
  800f27:	89 c1                	mov    %eax,%ecx
  800f29:	31 d2                	xor    %edx,%edx
  800f2b:	89 f0                	mov    %esi,%eax
  800f2d:	f7 f1                	div    %ecx
  800f2f:	89 c6                	mov    %eax,%esi
  800f31:	89 e8                	mov    %ebp,%eax
  800f33:	89 f7                	mov    %esi,%edi
  800f35:	f7 f1                	div    %ecx
  800f37:	89 fa                	mov    %edi,%edx
  800f39:	83 c4 1c             	add    $0x1c,%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
  800f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f48:	39 f2                	cmp    %esi,%edx
  800f4a:	77 1c                	ja     800f68 <__udivdi3+0x88>
  800f4c:	0f bd fa             	bsr    %edx,%edi
  800f4f:	83 f7 1f             	xor    $0x1f,%edi
  800f52:	75 2c                	jne    800f80 <__udivdi3+0xa0>
  800f54:	39 f2                	cmp    %esi,%edx
  800f56:	72 06                	jb     800f5e <__udivdi3+0x7e>
  800f58:	31 c0                	xor    %eax,%eax
  800f5a:	39 eb                	cmp    %ebp,%ebx
  800f5c:	77 a9                	ja     800f07 <__udivdi3+0x27>
  800f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f63:	eb a2                	jmp    800f07 <__udivdi3+0x27>
  800f65:	8d 76 00             	lea    0x0(%esi),%esi
  800f68:	31 ff                	xor    %edi,%edi
  800f6a:	31 c0                	xor    %eax,%eax
  800f6c:	89 fa                	mov    %edi,%edx
  800f6e:	83 c4 1c             	add    $0x1c,%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
  800f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f7d:	8d 76 00             	lea    0x0(%esi),%esi
  800f80:	89 f9                	mov    %edi,%ecx
  800f82:	b8 20 00 00 00       	mov    $0x20,%eax
  800f87:	29 f8                	sub    %edi,%eax
  800f89:	d3 e2                	shl    %cl,%edx
  800f8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f8f:	89 c1                	mov    %eax,%ecx
  800f91:	89 da                	mov    %ebx,%edx
  800f93:	d3 ea                	shr    %cl,%edx
  800f95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f99:	09 d1                	or     %edx,%ecx
  800f9b:	89 f2                	mov    %esi,%edx
  800f9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fa1:	89 f9                	mov    %edi,%ecx
  800fa3:	d3 e3                	shl    %cl,%ebx
  800fa5:	89 c1                	mov    %eax,%ecx
  800fa7:	d3 ea                	shr    %cl,%edx
  800fa9:	89 f9                	mov    %edi,%ecx
  800fab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800faf:	89 eb                	mov    %ebp,%ebx
  800fb1:	d3 e6                	shl    %cl,%esi
  800fb3:	89 c1                	mov    %eax,%ecx
  800fb5:	d3 eb                	shr    %cl,%ebx
  800fb7:	09 de                	or     %ebx,%esi
  800fb9:	89 f0                	mov    %esi,%eax
  800fbb:	f7 74 24 08          	divl   0x8(%esp)
  800fbf:	89 d6                	mov    %edx,%esi
  800fc1:	89 c3                	mov    %eax,%ebx
  800fc3:	f7 64 24 0c          	mull   0xc(%esp)
  800fc7:	39 d6                	cmp    %edx,%esi
  800fc9:	72 15                	jb     800fe0 <__udivdi3+0x100>
  800fcb:	89 f9                	mov    %edi,%ecx
  800fcd:	d3 e5                	shl    %cl,%ebp
  800fcf:	39 c5                	cmp    %eax,%ebp
  800fd1:	73 04                	jae    800fd7 <__udivdi3+0xf7>
  800fd3:	39 d6                	cmp    %edx,%esi
  800fd5:	74 09                	je     800fe0 <__udivdi3+0x100>
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	31 ff                	xor    %edi,%edi
  800fdb:	e9 27 ff ff ff       	jmp    800f07 <__udivdi3+0x27>
  800fe0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fe3:	31 ff                	xor    %edi,%edi
  800fe5:	e9 1d ff ff ff       	jmp    800f07 <__udivdi3+0x27>
  800fea:	66 90                	xchg   %ax,%ax
  800fec:	66 90                	xchg   %ax,%ax
  800fee:	66 90                	xchg   %ax,%ax

00800ff0 <__umoddi3>:
  800ff0:	55                   	push   %ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 1c             	sub    $0x1c,%esp
  800ff7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ffb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800fff:	8b 74 24 30          	mov    0x30(%esp),%esi
  801003:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801007:	89 da                	mov    %ebx,%edx
  801009:	85 c0                	test   %eax,%eax
  80100b:	75 43                	jne    801050 <__umoddi3+0x60>
  80100d:	39 df                	cmp    %ebx,%edi
  80100f:	76 17                	jbe    801028 <__umoddi3+0x38>
  801011:	89 f0                	mov    %esi,%eax
  801013:	f7 f7                	div    %edi
  801015:	89 d0                	mov    %edx,%eax
  801017:	31 d2                	xor    %edx,%edx
  801019:	83 c4 1c             	add    $0x1c,%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    
  801021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801028:	89 fd                	mov    %edi,%ebp
  80102a:	85 ff                	test   %edi,%edi
  80102c:	75 0b                	jne    801039 <__umoddi3+0x49>
  80102e:	b8 01 00 00 00       	mov    $0x1,%eax
  801033:	31 d2                	xor    %edx,%edx
  801035:	f7 f7                	div    %edi
  801037:	89 c5                	mov    %eax,%ebp
  801039:	89 d8                	mov    %ebx,%eax
  80103b:	31 d2                	xor    %edx,%edx
  80103d:	f7 f5                	div    %ebp
  80103f:	89 f0                	mov    %esi,%eax
  801041:	f7 f5                	div    %ebp
  801043:	89 d0                	mov    %edx,%eax
  801045:	eb d0                	jmp    801017 <__umoddi3+0x27>
  801047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80104e:	66 90                	xchg   %ax,%ax
  801050:	89 f1                	mov    %esi,%ecx
  801052:	39 d8                	cmp    %ebx,%eax
  801054:	76 0a                	jbe    801060 <__umoddi3+0x70>
  801056:	89 f0                	mov    %esi,%eax
  801058:	83 c4 1c             	add    $0x1c,%esp
  80105b:	5b                   	pop    %ebx
  80105c:	5e                   	pop    %esi
  80105d:	5f                   	pop    %edi
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    
  801060:	0f bd e8             	bsr    %eax,%ebp
  801063:	83 f5 1f             	xor    $0x1f,%ebp
  801066:	75 20                	jne    801088 <__umoddi3+0x98>
  801068:	39 d8                	cmp    %ebx,%eax
  80106a:	0f 82 b0 00 00 00    	jb     801120 <__umoddi3+0x130>
  801070:	39 f7                	cmp    %esi,%edi
  801072:	0f 86 a8 00 00 00    	jbe    801120 <__umoddi3+0x130>
  801078:	89 c8                	mov    %ecx,%eax
  80107a:	83 c4 1c             	add    $0x1c,%esp
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    
  801082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801088:	89 e9                	mov    %ebp,%ecx
  80108a:	ba 20 00 00 00       	mov    $0x20,%edx
  80108f:	29 ea                	sub    %ebp,%edx
  801091:	d3 e0                	shl    %cl,%eax
  801093:	89 44 24 08          	mov    %eax,0x8(%esp)
  801097:	89 d1                	mov    %edx,%ecx
  801099:	89 f8                	mov    %edi,%eax
  80109b:	d3 e8                	shr    %cl,%eax
  80109d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010a9:	09 c1                	or     %eax,%ecx
  8010ab:	89 d8                	mov    %ebx,%eax
  8010ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010b1:	89 e9                	mov    %ebp,%ecx
  8010b3:	d3 e7                	shl    %cl,%edi
  8010b5:	89 d1                	mov    %edx,%ecx
  8010b7:	d3 e8                	shr    %cl,%eax
  8010b9:	89 e9                	mov    %ebp,%ecx
  8010bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010bf:	d3 e3                	shl    %cl,%ebx
  8010c1:	89 c7                	mov    %eax,%edi
  8010c3:	89 d1                	mov    %edx,%ecx
  8010c5:	89 f0                	mov    %esi,%eax
  8010c7:	d3 e8                	shr    %cl,%eax
  8010c9:	89 e9                	mov    %ebp,%ecx
  8010cb:	89 fa                	mov    %edi,%edx
  8010cd:	d3 e6                	shl    %cl,%esi
  8010cf:	09 d8                	or     %ebx,%eax
  8010d1:	f7 74 24 08          	divl   0x8(%esp)
  8010d5:	89 d1                	mov    %edx,%ecx
  8010d7:	89 f3                	mov    %esi,%ebx
  8010d9:	f7 64 24 0c          	mull   0xc(%esp)
  8010dd:	89 c6                	mov    %eax,%esi
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	39 d1                	cmp    %edx,%ecx
  8010e3:	72 06                	jb     8010eb <__umoddi3+0xfb>
  8010e5:	75 10                	jne    8010f7 <__umoddi3+0x107>
  8010e7:	39 c3                	cmp    %eax,%ebx
  8010e9:	73 0c                	jae    8010f7 <__umoddi3+0x107>
  8010eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010f3:	89 d7                	mov    %edx,%edi
  8010f5:	89 c6                	mov    %eax,%esi
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010fe:	29 f3                	sub    %esi,%ebx
  801100:	19 fa                	sbb    %edi,%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	d3 e0                	shl    %cl,%eax
  801106:	89 e9                	mov    %ebp,%ecx
  801108:	d3 eb                	shr    %cl,%ebx
  80110a:	d3 ea                	shr    %cl,%edx
  80110c:	09 d8                	or     %ebx,%eax
  80110e:	83 c4 1c             	add    $0x1c,%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
  801116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80111d:	8d 76 00             	lea    0x0(%esi),%esi
  801120:	89 da                	mov    %ebx,%edx
  801122:	29 fe                	sub    %edi,%esi
  801124:	19 c2                	sbb    %eax,%edx
  801126:	89 f1                	mov    %esi,%ecx
  801128:	89 c8                	mov    %ecx,%eax
  80112a:	e9 4b ff ff ff       	jmp    80107a <__umoddi3+0x8a>
