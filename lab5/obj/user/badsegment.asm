
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800045:	e8 c9 00 00 00       	call   800113 <sys_getenvid>
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800052:	c1 e0 04             	shl    $0x4,%eax
  800055:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005a:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005f:	85 db                	test   %ebx,%ebx
  800061:	7e 07                	jle    80006a <libmain+0x30>
		binaryname = argv[0];
  800063:	8b 06                	mov    (%esi),%eax
  800065:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	56                   	push   %esi
  80006e:	53                   	push   %ebx
  80006f:	e8 bf ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800074:	e8 0a 00 00 00       	call   800083 <exit>
}
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007f:	5b                   	pop    %ebx
  800080:	5e                   	pop    %esi
  800081:	5d                   	pop    %ebp
  800082:	c3                   	ret    

00800083 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800083:	55                   	push   %ebp
  800084:	89 e5                	mov    %esp,%ebp
  800086:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800089:	6a 00                	push   $0x0
  80008b:	e8 42 00 00 00       	call   8000d2 <sys_env_destroy>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	c9                   	leave  
  800094:	c3                   	ret    

00800095 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800095:	55                   	push   %ebp
  800096:	89 e5                	mov    %esp,%ebp
  800098:	57                   	push   %edi
  800099:	56                   	push   %esi
  80009a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a6:	89 c3                	mov    %eax,%ebx
  8000a8:	89 c7                	mov    %eax,%edi
  8000aa:	89 c6                	mov    %eax,%esi
  8000ac:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ae:	5b                   	pop    %ebx
  8000af:	5e                   	pop    %esi
  8000b0:	5f                   	pop    %edi
  8000b1:	5d                   	pop    %ebp
  8000b2:	c3                   	ret    

008000b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b3:	55                   	push   %ebp
  8000b4:	89 e5                	mov    %esp,%ebp
  8000b6:	57                   	push   %edi
  8000b7:	56                   	push   %esi
  8000b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c3:	89 d1                	mov    %edx,%ecx
  8000c5:	89 d3                	mov    %edx,%ebx
  8000c7:	89 d7                	mov    %edx,%edi
  8000c9:	89 d6                	mov    %edx,%esi
  8000cb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
  8000d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e8:	89 cb                	mov    %ecx,%ebx
  8000ea:	89 cf                	mov    %ecx,%edi
  8000ec:	89 ce                	mov    %ecx,%esi
  8000ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	7f 08                	jg     8000fc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5f                   	pop    %edi
  8000fa:	5d                   	pop    %ebp
  8000fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	50                   	push   %eax
  800100:	6a 03                	push   $0x3
  800102:	68 4a 11 80 00       	push   $0x80114a
  800107:	6a 33                	push   $0x33
  800109:	68 67 11 80 00       	push   $0x801167
  80010e:	e8 b1 02 00 00       	call   8003c4 <_panic>

00800113 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	57                   	push   %edi
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
	asm volatile("int %1\n"
  800119:	ba 00 00 00 00       	mov    $0x0,%edx
  80011e:	b8 02 00 00 00       	mov    $0x2,%eax
  800123:	89 d1                	mov    %edx,%ecx
  800125:	89 d3                	mov    %edx,%ebx
  800127:	89 d7                	mov    %edx,%edi
  800129:	89 d6                	mov    %edx,%esi
  80012b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <sys_yield>:

void
sys_yield(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
  800157:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015a:	be 00 00 00 00       	mov    $0x0,%esi
  80015f:	8b 55 08             	mov    0x8(%ebp),%edx
  800162:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800165:	b8 04 00 00 00       	mov    $0x4,%eax
  80016a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016d:	89 f7                	mov    %esi,%edi
  80016f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800171:	85 c0                	test   %eax,%eax
  800173:	7f 08                	jg     80017d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800178:	5b                   	pop    %ebx
  800179:	5e                   	pop    %esi
  80017a:	5f                   	pop    %edi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	6a 04                	push   $0x4
  800183:	68 4a 11 80 00       	push   $0x80114a
  800188:	6a 33                	push   $0x33
  80018a:	68 67 11 80 00       	push   $0x801167
  80018f:	e8 30 02 00 00       	call   8003c4 <_panic>

00800194 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019d:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	7f 08                	jg     8001bf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ba:	5b                   	pop    %ebx
  8001bb:	5e                   	pop    %esi
  8001bc:	5f                   	pop    %edi
  8001bd:	5d                   	pop    %ebp
  8001be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	50                   	push   %eax
  8001c3:	6a 05                	push   $0x5
  8001c5:	68 4a 11 80 00       	push   $0x80114a
  8001ca:	6a 33                	push   $0x33
  8001cc:	68 67 11 80 00       	push   $0x801167
  8001d1:	e8 ee 01 00 00       	call   8003c4 <_panic>

008001d6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	57                   	push   %edi
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ea:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ef:	89 df                	mov    %ebx,%edi
  8001f1:	89 de                	mov    %ebx,%esi
  8001f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f5:	85 c0                	test   %eax,%eax
  8001f7:	7f 08                	jg     800201 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5f                   	pop    %edi
  8001ff:	5d                   	pop    %ebp
  800200:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	50                   	push   %eax
  800205:	6a 06                	push   $0x6
  800207:	68 4a 11 80 00       	push   $0x80114a
  80020c:	6a 33                	push   $0x33
  80020e:	68 67 11 80 00       	push   $0x801167
  800213:	e8 ac 01 00 00       	call   8003c4 <_panic>

00800218 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	57                   	push   %edi
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800221:	b9 00 00 00 00       	mov    $0x0,%ecx
  800226:	8b 55 08             	mov    0x8(%ebp),%edx
  800229:	b8 0b 00 00 00       	mov    $0xb,%eax
  80022e:	89 cb                	mov    %ecx,%ebx
  800230:	89 cf                	mov    %ecx,%edi
  800232:	89 ce                	mov    %ecx,%esi
  800234:	cd 30                	int    $0x30
	if(check && ret > 0)
  800236:	85 c0                	test   %eax,%eax
  800238:	7f 08                	jg     800242 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	50                   	push   %eax
  800246:	6a 0b                	push   $0xb
  800248:	68 4a 11 80 00       	push   $0x80114a
  80024d:	6a 33                	push   $0x33
  80024f:	68 67 11 80 00       	push   $0x801167
  800254:	e8 6b 01 00 00       	call   8003c4 <_panic>

00800259 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	57                   	push   %edi
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800262:	bb 00 00 00 00       	mov    $0x0,%ebx
  800267:	8b 55 08             	mov    0x8(%ebp),%edx
  80026a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026d:	b8 08 00 00 00       	mov    $0x8,%eax
  800272:	89 df                	mov    %ebx,%edi
  800274:	89 de                	mov    %ebx,%esi
  800276:	cd 30                	int    $0x30
	if(check && ret > 0)
  800278:	85 c0                	test   %eax,%eax
  80027a:	7f 08                	jg     800284 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80027c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027f:	5b                   	pop    %ebx
  800280:	5e                   	pop    %esi
  800281:	5f                   	pop    %edi
  800282:	5d                   	pop    %ebp
  800283:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	50                   	push   %eax
  800288:	6a 08                	push   $0x8
  80028a:	68 4a 11 80 00       	push   $0x80114a
  80028f:	6a 33                	push   $0x33
  800291:	68 67 11 80 00       	push   $0x801167
  800296:	e8 29 01 00 00       	call   8003c4 <_panic>

0080029b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	57                   	push   %edi
  80029f:	56                   	push   %esi
  8002a0:	53                   	push   %ebx
  8002a1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002af:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b4:	89 df                	mov    %ebx,%edi
  8002b6:	89 de                	mov    %ebx,%esi
  8002b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	7f 08                	jg     8002c6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c6:	83 ec 0c             	sub    $0xc,%esp
  8002c9:	50                   	push   %eax
  8002ca:	6a 09                	push   $0x9
  8002cc:	68 4a 11 80 00       	push   $0x80114a
  8002d1:	6a 33                	push   $0x33
  8002d3:	68 67 11 80 00       	push   $0x801167
  8002d8:	e8 e7 00 00 00       	call   8003c4 <_panic>

008002dd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002f6:	89 df                	mov    %ebx,%edi
  8002f8:	89 de                	mov    %ebx,%esi
  8002fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	7f 08                	jg     800308 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800303:	5b                   	pop    %ebx
  800304:	5e                   	pop    %esi
  800305:	5f                   	pop    %edi
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	50                   	push   %eax
  80030c:	6a 0a                	push   $0xa
  80030e:	68 4a 11 80 00       	push   $0x80114a
  800313:	6a 33                	push   $0x33
  800315:	68 67 11 80 00       	push   $0x801167
  80031a:	e8 a5 00 00 00       	call   8003c4 <_panic>

0080031f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	57                   	push   %edi
  800323:	56                   	push   %esi
  800324:	53                   	push   %ebx
	asm volatile("int %1\n"
  800325:	8b 55 08             	mov    0x8(%ebp),%edx
  800328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800330:	be 00 00 00 00       	mov    $0x0,%esi
  800335:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800338:	8b 7d 14             	mov    0x14(%ebp),%edi
  80033b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80033d:	5b                   	pop    %ebx
  80033e:	5e                   	pop    %esi
  80033f:	5f                   	pop    %edi
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    

00800342 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	57                   	push   %edi
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
  800348:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80034b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800350:	8b 55 08             	mov    0x8(%ebp),%edx
  800353:	b8 0e 00 00 00       	mov    $0xe,%eax
  800358:	89 cb                	mov    %ecx,%ebx
  80035a:	89 cf                	mov    %ecx,%edi
  80035c:	89 ce                	mov    %ecx,%esi
  80035e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800360:	85 c0                	test   %eax,%eax
  800362:	7f 08                	jg     80036c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800364:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800367:	5b                   	pop    %ebx
  800368:	5e                   	pop    %esi
  800369:	5f                   	pop    %edi
  80036a:	5d                   	pop    %ebp
  80036b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	50                   	push   %eax
  800370:	6a 0e                	push   $0xe
  800372:	68 4a 11 80 00       	push   $0x80114a
  800377:	6a 33                	push   $0x33
  800379:	68 67 11 80 00       	push   $0x801167
  80037e:	e8 41 00 00 00       	call   8003c4 <_panic>

00800383 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	57                   	push   %edi
  800387:	56                   	push   %esi
  800388:	53                   	push   %ebx
	asm volatile("int %1\n"
  800389:	bb 00 00 00 00       	mov    $0x0,%ebx
  80038e:	8b 55 08             	mov    0x8(%ebp),%edx
  800391:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800394:	b8 0f 00 00 00       	mov    $0xf,%eax
  800399:	89 df                	mov    %ebx,%edi
  80039b:	89 de                	mov    %ebx,%esi
  80039d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80039f:	5b                   	pop    %ebx
  8003a0:	5e                   	pop    %esi
  8003a1:	5f                   	pop    %edi
  8003a2:	5d                   	pop    %ebp
  8003a3:	c3                   	ret    

008003a4 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	57                   	push   %edi
  8003a8:	56                   	push   %esi
  8003a9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003af:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b2:	b8 10 00 00 00       	mov    $0x10,%eax
  8003b7:	89 cb                	mov    %ecx,%ebx
  8003b9:	89 cf                	mov    %ecx,%edi
  8003bb:	89 ce                	mov    %ecx,%esi
  8003bd:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003bf:	5b                   	pop    %ebx
  8003c0:	5e                   	pop    %esi
  8003c1:	5f                   	pop    %edi
  8003c2:	5d                   	pop    %ebp
  8003c3:	c3                   	ret    

008003c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	56                   	push   %esi
  8003c8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003c9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003cc:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003d2:	e8 3c fd ff ff       	call   800113 <sys_getenvid>
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	ff 75 0c             	pushl  0xc(%ebp)
  8003dd:	ff 75 08             	pushl  0x8(%ebp)
  8003e0:	56                   	push   %esi
  8003e1:	50                   	push   %eax
  8003e2:	68 78 11 80 00       	push   $0x801178
  8003e7:	e8 b3 00 00 00       	call   80049f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003ec:	83 c4 18             	add    $0x18,%esp
  8003ef:	53                   	push   %ebx
  8003f0:	ff 75 10             	pushl  0x10(%ebp)
  8003f3:	e8 56 00 00 00       	call   80044e <vcprintf>
	cprintf("\n");
  8003f8:	c7 04 24 9b 11 80 00 	movl   $0x80119b,(%esp)
  8003ff:	e8 9b 00 00 00       	call   80049f <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800407:	cc                   	int3   
  800408:	eb fd                	jmp    800407 <_panic+0x43>

0080040a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	53                   	push   %ebx
  80040e:	83 ec 04             	sub    $0x4,%esp
  800411:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800414:	8b 13                	mov    (%ebx),%edx
  800416:	8d 42 01             	lea    0x1(%edx),%eax
  800419:	89 03                	mov    %eax,(%ebx)
  80041b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80041e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800422:	3d ff 00 00 00       	cmp    $0xff,%eax
  800427:	74 09                	je     800432 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800429:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80042d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800430:	c9                   	leave  
  800431:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	68 ff 00 00 00       	push   $0xff
  80043a:	8d 43 08             	lea    0x8(%ebx),%eax
  80043d:	50                   	push   %eax
  80043e:	e8 52 fc ff ff       	call   800095 <sys_cputs>
		b->idx = 0;
  800443:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	eb db                	jmp    800429 <putch+0x1f>

0080044e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800457:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80045e:	00 00 00 
	b.cnt = 0;
  800461:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800468:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80046b:	ff 75 0c             	pushl  0xc(%ebp)
  80046e:	ff 75 08             	pushl  0x8(%ebp)
  800471:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800477:	50                   	push   %eax
  800478:	68 0a 04 80 00       	push   $0x80040a
  80047d:	e8 4a 01 00 00       	call   8005cc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800482:	83 c4 08             	add    $0x8,%esp
  800485:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80048b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 fe fb ff ff       	call   800095 <sys_cputs>

	return b.cnt;
}
  800497:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80049d:	c9                   	leave  
  80049e:	c3                   	ret    

0080049f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004a8:	50                   	push   %eax
  8004a9:	ff 75 08             	pushl  0x8(%ebp)
  8004ac:	e8 9d ff ff ff       	call   80044e <vcprintf>
	va_end(ap);

	return cnt;
}
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	57                   	push   %edi
  8004b7:	56                   	push   %esi
  8004b8:	53                   	push   %ebx
  8004b9:	83 ec 1c             	sub    $0x1c,%esp
  8004bc:	89 c6                	mov    %eax,%esi
  8004be:	89 d7                	mov    %edx,%edi
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004d2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004d6:	74 2c                	je     800504 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e8:	39 c2                	cmp    %eax,%edx
  8004ea:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004ed:	73 43                	jae    800532 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004ef:	83 eb 01             	sub    $0x1,%ebx
  8004f2:	85 db                	test   %ebx,%ebx
  8004f4:	7e 6c                	jle    800562 <printnum+0xaf>
			putch(padc, putdat);
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	57                   	push   %edi
  8004fa:	ff 75 18             	pushl  0x18(%ebp)
  8004fd:	ff d6                	call   *%esi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	eb eb                	jmp    8004ef <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	6a 20                	push   $0x20
  800509:	6a 00                	push   $0x0
  80050b:	50                   	push   %eax
  80050c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80050f:	ff 75 e0             	pushl  -0x20(%ebp)
  800512:	89 fa                	mov    %edi,%edx
  800514:	89 f0                	mov    %esi,%eax
  800516:	e8 98 ff ff ff       	call   8004b3 <printnum>
		while (--width > 0)
  80051b:	83 c4 20             	add    $0x20,%esp
  80051e:	83 eb 01             	sub    $0x1,%ebx
  800521:	85 db                	test   %ebx,%ebx
  800523:	7e 65                	jle    80058a <printnum+0xd7>
			putch(padc, putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	57                   	push   %edi
  800529:	6a 20                	push   $0x20
  80052b:	ff d6                	call   *%esi
  80052d:	83 c4 10             	add    $0x10,%esp
  800530:	eb ec                	jmp    80051e <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800532:	83 ec 0c             	sub    $0xc,%esp
  800535:	ff 75 18             	pushl  0x18(%ebp)
  800538:	83 eb 01             	sub    $0x1,%ebx
  80053b:	53                   	push   %ebx
  80053c:	50                   	push   %eax
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	ff 75 dc             	pushl  -0x24(%ebp)
  800543:	ff 75 d8             	pushl  -0x28(%ebp)
  800546:	ff 75 e4             	pushl  -0x1c(%ebp)
  800549:	ff 75 e0             	pushl  -0x20(%ebp)
  80054c:	e8 9f 09 00 00       	call   800ef0 <__udivdi3>
  800551:	83 c4 18             	add    $0x18,%esp
  800554:	52                   	push   %edx
  800555:	50                   	push   %eax
  800556:	89 fa                	mov    %edi,%edx
  800558:	89 f0                	mov    %esi,%eax
  80055a:	e8 54 ff ff ff       	call   8004b3 <printnum>
  80055f:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	57                   	push   %edi
  800566:	83 ec 04             	sub    $0x4,%esp
  800569:	ff 75 dc             	pushl  -0x24(%ebp)
  80056c:	ff 75 d8             	pushl  -0x28(%ebp)
  80056f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800572:	ff 75 e0             	pushl  -0x20(%ebp)
  800575:	e8 86 0a 00 00       	call   801000 <__umoddi3>
  80057a:	83 c4 14             	add    $0x14,%esp
  80057d:	0f be 80 9d 11 80 00 	movsbl 0x80119d(%eax),%eax
  800584:	50                   	push   %eax
  800585:	ff d6                	call   *%esi
  800587:	83 c4 10             	add    $0x10,%esp
}
  80058a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80058d:	5b                   	pop    %ebx
  80058e:	5e                   	pop    %esi
  80058f:	5f                   	pop    %edi
  800590:	5d                   	pop    %ebp
  800591:	c3                   	ret    

00800592 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800598:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80059c:	8b 10                	mov    (%eax),%edx
  80059e:	3b 50 04             	cmp    0x4(%eax),%edx
  8005a1:	73 0a                	jae    8005ad <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005a6:	89 08                	mov    %ecx,(%eax)
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	88 02                	mov    %al,(%edx)
}
  8005ad:	5d                   	pop    %ebp
  8005ae:	c3                   	ret    

008005af <printfmt>:
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005b5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005b8:	50                   	push   %eax
  8005b9:	ff 75 10             	pushl  0x10(%ebp)
  8005bc:	ff 75 0c             	pushl  0xc(%ebp)
  8005bf:	ff 75 08             	pushl  0x8(%ebp)
  8005c2:	e8 05 00 00 00       	call   8005cc <vprintfmt>
}
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	c9                   	leave  
  8005cb:	c3                   	ret    

008005cc <vprintfmt>:
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  8005cf:	57                   	push   %edi
  8005d0:	56                   	push   %esi
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 3c             	sub    $0x3c,%esp
  8005d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005db:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005de:	e9 b4 03 00 00       	jmp    800997 <vprintfmt+0x3cb>
		padc = ' ';
  8005e3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8005e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8005ee:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005fc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800603:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800608:	8d 47 01             	lea    0x1(%edi),%eax
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80060e:	0f b6 17             	movzbl (%edi),%edx
  800611:	8d 42 dd             	lea    -0x23(%edx),%eax
  800614:	3c 55                	cmp    $0x55,%al
  800616:	0f 87 c8 04 00 00    	ja     800ae4 <vprintfmt+0x518>
  80061c:	0f b6 c0             	movzbl %al,%eax
  80061f:	ff 24 85 80 13 80 00 	jmp    *0x801380(,%eax,4)
  800626:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800629:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800630:	eb d6                	jmp    800608 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800632:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800635:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800639:	eb cd                	jmp    800608 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80063b:	0f b6 d2             	movzbl %dl,%edx
  80063e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800641:	b8 00 00 00 00       	mov    $0x0,%eax
  800646:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800649:	eb 0c                	jmp    800657 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80064b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80064e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800652:	eb b4                	jmp    800608 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800654:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800657:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80065a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80065e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800661:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800664:	83 f9 09             	cmp    $0x9,%ecx
  800667:	76 eb                	jbe    800654 <vprintfmt+0x88>
  800669:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	eb 14                	jmp    800685 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8d 40 04             	lea    0x4(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800682:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800685:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800689:	0f 89 79 ff ff ff    	jns    800608 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800692:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800695:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80069c:	e9 67 ff ff ff       	jmp    800608 <vprintfmt+0x3c>
  8006a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a4:	85 c0                	test   %eax,%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ab:	0f 49 d0             	cmovns %eax,%edx
  8006ae:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006b4:	e9 4f ff ff ff       	jmp    800608 <vprintfmt+0x3c>
  8006b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006bc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006c3:	e9 40 ff ff ff       	jmp    800608 <vprintfmt+0x3c>
			lflag++;
  8006c8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006ce:	e9 35 ff ff ff       	jmp    800608 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8d 78 04             	lea    0x4(%eax),%edi
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	ff 30                	pushl  (%eax)
  8006df:	ff d6                	call   *%esi
			break;
  8006e1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006e4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006e7:	e9 a8 02 00 00       	jmp    800994 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 78 04             	lea    0x4(%eax),%edi
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	99                   	cltd   
  8006f5:	31 d0                	xor    %edx,%eax
  8006f7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006f9:	83 f8 0f             	cmp    $0xf,%eax
  8006fc:	7f 23                	jg     800721 <vprintfmt+0x155>
  8006fe:	8b 14 85 e0 14 80 00 	mov    0x8014e0(,%eax,4),%edx
  800705:	85 d2                	test   %edx,%edx
  800707:	74 18                	je     800721 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800709:	52                   	push   %edx
  80070a:	68 be 11 80 00       	push   $0x8011be
  80070f:	53                   	push   %ebx
  800710:	56                   	push   %esi
  800711:	e8 99 fe ff ff       	call   8005af <printfmt>
  800716:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800719:	89 7d 14             	mov    %edi,0x14(%ebp)
  80071c:	e9 73 02 00 00       	jmp    800994 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800721:	50                   	push   %eax
  800722:	68 b5 11 80 00       	push   $0x8011b5
  800727:	53                   	push   %ebx
  800728:	56                   	push   %esi
  800729:	e8 81 fe ff ff       	call   8005af <printfmt>
  80072e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800731:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800734:	e9 5b 02 00 00       	jmp    800994 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	83 c0 04             	add    $0x4,%eax
  80073f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800747:	85 d2                	test   %edx,%edx
  800749:	b8 ae 11 80 00       	mov    $0x8011ae,%eax
  80074e:	0f 45 c2             	cmovne %edx,%eax
  800751:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800754:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800758:	7e 06                	jle    800760 <vprintfmt+0x194>
  80075a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80075e:	75 0d                	jne    80076d <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800760:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800763:	89 c7                	mov    %eax,%edi
  800765:	03 45 e0             	add    -0x20(%ebp),%eax
  800768:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076b:	eb 53                	jmp    8007c0 <vprintfmt+0x1f4>
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 d8             	pushl  -0x28(%ebp)
  800773:	50                   	push   %eax
  800774:	e8 13 04 00 00       	call   800b8c <strnlen>
  800779:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80077c:	29 c1                	sub    %eax,%ecx
  80077e:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800786:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80078d:	eb 0f                	jmp    80079e <vprintfmt+0x1d2>
					putch(padc, putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	53                   	push   %ebx
  800793:	ff 75 e0             	pushl  -0x20(%ebp)
  800796:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800798:	83 ef 01             	sub    $0x1,%edi
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	85 ff                	test   %edi,%edi
  8007a0:	7f ed                	jg     80078f <vprintfmt+0x1c3>
  8007a2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007a5:	85 d2                	test   %edx,%edx
  8007a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ac:	0f 49 c2             	cmovns %edx,%eax
  8007af:	29 c2                	sub    %eax,%edx
  8007b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007b4:	eb aa                	jmp    800760 <vprintfmt+0x194>
					putch(ch, putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	52                   	push   %edx
  8007bb:	ff d6                	call   *%esi
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007c3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c5:	83 c7 01             	add    $0x1,%edi
  8007c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007cc:	0f be d0             	movsbl %al,%edx
  8007cf:	85 d2                	test   %edx,%edx
  8007d1:	74 4b                	je     80081e <vprintfmt+0x252>
  8007d3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007d7:	78 06                	js     8007df <vprintfmt+0x213>
  8007d9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007dd:	78 1e                	js     8007fd <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8007df:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007e3:	74 d1                	je     8007b6 <vprintfmt+0x1ea>
  8007e5:	0f be c0             	movsbl %al,%eax
  8007e8:	83 e8 20             	sub    $0x20,%eax
  8007eb:	83 f8 5e             	cmp    $0x5e,%eax
  8007ee:	76 c6                	jbe    8007b6 <vprintfmt+0x1ea>
					putch('?', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	6a 3f                	push   $0x3f
  8007f6:	ff d6                	call   *%esi
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	eb c3                	jmp    8007c0 <vprintfmt+0x1f4>
  8007fd:	89 cf                	mov    %ecx,%edi
  8007ff:	eb 0e                	jmp    80080f <vprintfmt+0x243>
				putch(' ', putdat);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	53                   	push   %ebx
  800805:	6a 20                	push   $0x20
  800807:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800809:	83 ef 01             	sub    $0x1,%edi
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	85 ff                	test   %edi,%edi
  800811:	7f ee                	jg     800801 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800813:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
  800819:	e9 76 01 00 00       	jmp    800994 <vprintfmt+0x3c8>
  80081e:	89 cf                	mov    %ecx,%edi
  800820:	eb ed                	jmp    80080f <vprintfmt+0x243>
	if (lflag >= 2)
  800822:	83 f9 01             	cmp    $0x1,%ecx
  800825:	7f 1f                	jg     800846 <vprintfmt+0x27a>
	else if (lflag)
  800827:	85 c9                	test   %ecx,%ecx
  800829:	74 6a                	je     800895 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 c1                	mov    %eax,%ecx
  800835:	c1 f9 1f             	sar    $0x1f,%ecx
  800838:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8d 40 04             	lea    0x4(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
  800844:	eb 17                	jmp    80085d <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800851:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8d 40 08             	lea    0x8(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80085d:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800860:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800865:	85 d2                	test   %edx,%edx
  800867:	0f 89 f8 00 00 00    	jns    800965 <vprintfmt+0x399>
				putch('-', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	53                   	push   %ebx
  800871:	6a 2d                	push   $0x2d
  800873:	ff d6                	call   *%esi
				num = -(long long) num;
  800875:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800878:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80087b:	f7 d8                	neg    %eax
  80087d:	83 d2 00             	adc    $0x0,%edx
  800880:	f7 da                	neg    %edx
  800882:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800885:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800888:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80088b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800890:	e9 e1 00 00 00       	jmp    800976 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089d:	99                   	cltd   
  80089e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8d 40 04             	lea    0x4(%eax),%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008aa:	eb b1                	jmp    80085d <vprintfmt+0x291>
	if (lflag >= 2)
  8008ac:	83 f9 01             	cmp    $0x1,%ecx
  8008af:	7f 27                	jg     8008d8 <vprintfmt+0x30c>
	else if (lflag)
  8008b1:	85 c9                	test   %ecx,%ecx
  8008b3:	74 41                	je     8008f6 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8d 40 04             	lea    0x4(%eax),%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ce:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008d3:	e9 8d 00 00 00       	jmp    800965 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8b 50 04             	mov    0x4(%eax),%edx
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8d 40 08             	lea    0x8(%eax),%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ef:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008f4:	eb 6f                	jmp    800965 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800900:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800903:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	8d 40 04             	lea    0x4(%eax),%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800914:	eb 4f                	jmp    800965 <vprintfmt+0x399>
	if (lflag >= 2)
  800916:	83 f9 01             	cmp    $0x1,%ecx
  800919:	7f 23                	jg     80093e <vprintfmt+0x372>
	else if (lflag)
  80091b:	85 c9                	test   %ecx,%ecx
  80091d:	0f 84 98 00 00 00    	je     8009bb <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	ba 00 00 00 00       	mov    $0x0,%edx
  80092d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800930:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8d 40 04             	lea    0x4(%eax),%eax
  800939:	89 45 14             	mov    %eax,0x14(%ebp)
  80093c:	eb 17                	jmp    800955 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	8b 50 04             	mov    0x4(%eax),%edx
  800944:	8b 00                	mov    (%eax),%eax
  800946:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800949:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8d 40 08             	lea    0x8(%eax),%eax
  800952:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	53                   	push   %ebx
  800959:	6a 30                	push   $0x30
  80095b:	ff d6                	call   *%esi
			goto number;
  80095d:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800960:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800965:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800969:	74 0b                	je     800976 <vprintfmt+0x3aa>
				putch('+', putdat);
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	53                   	push   %ebx
  80096f:	6a 2b                	push   $0x2b
  800971:	ff d6                	call   *%esi
  800973:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800976:	83 ec 0c             	sub    $0xc,%esp
  800979:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	ff 75 e0             	pushl  -0x20(%ebp)
  800981:	57                   	push   %edi
  800982:	ff 75 dc             	pushl  -0x24(%ebp)
  800985:	ff 75 d8             	pushl  -0x28(%ebp)
  800988:	89 da                	mov    %ebx,%edx
  80098a:	89 f0                	mov    %esi,%eax
  80098c:	e8 22 fb ff ff       	call   8004b3 <printnum>
			break;
  800991:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800994:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800997:	83 c7 01             	add    $0x1,%edi
  80099a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80099e:	83 f8 25             	cmp    $0x25,%eax
  8009a1:	0f 84 3c fc ff ff    	je     8005e3 <vprintfmt+0x17>
			if (ch == '\0')
  8009a7:	85 c0                	test   %eax,%eax
  8009a9:	0f 84 55 01 00 00    	je     800b04 <vprintfmt+0x538>
			putch(ch, putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	53                   	push   %ebx
  8009b3:	50                   	push   %eax
  8009b4:	ff d6                	call   *%esi
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb dc                	jmp    800997 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8d 40 04             	lea    0x4(%eax),%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d4:	e9 7c ff ff ff       	jmp    800955 <vprintfmt+0x389>
			putch('0', putdat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	53                   	push   %ebx
  8009dd:	6a 30                	push   $0x30
  8009df:	ff d6                	call   *%esi
			putch('x', putdat);
  8009e1:	83 c4 08             	add    $0x8,%esp
  8009e4:	53                   	push   %ebx
  8009e5:	6a 78                	push   $0x78
  8009e7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009f9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	8d 40 04             	lea    0x4(%eax),%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a05:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a0a:	e9 56 ff ff ff       	jmp    800965 <vprintfmt+0x399>
	if (lflag >= 2)
  800a0f:	83 f9 01             	cmp    $0x1,%ecx
  800a12:	7f 27                	jg     800a3b <vprintfmt+0x46f>
	else if (lflag)
  800a14:	85 c9                	test   %ecx,%ecx
  800a16:	74 44                	je     800a5c <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	8b 00                	mov    (%eax),%eax
  800a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a22:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a25:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	8d 40 04             	lea    0x4(%eax),%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a31:	bf 10 00 00 00       	mov    $0x10,%edi
  800a36:	e9 2a ff ff ff       	jmp    800965 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3e:	8b 50 04             	mov    0x4(%eax),%edx
  800a41:	8b 00                	mov    (%eax),%eax
  800a43:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a46:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	8d 40 08             	lea    0x8(%eax),%eax
  800a4f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a52:	bf 10 00 00 00       	mov    $0x10,%edi
  800a57:	e9 09 ff ff ff       	jmp    800965 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	ba 00 00 00 00       	mov    $0x0,%edx
  800a66:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a69:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	8d 40 04             	lea    0x4(%eax),%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a75:	bf 10 00 00 00       	mov    $0x10,%edi
  800a7a:	e9 e6 fe ff ff       	jmp    800965 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8d 78 04             	lea    0x4(%eax),%edi
  800a85:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800a87:	85 c0                	test   %eax,%eax
  800a89:	74 2d                	je     800ab8 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800a8b:	0f b6 13             	movzbl (%ebx),%edx
  800a8e:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a90:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800a93:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a96:	0f 8e f8 fe ff ff    	jle    800994 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800a9c:	68 0c 13 80 00       	push   $0x80130c
  800aa1:	68 be 11 80 00       	push   $0x8011be
  800aa6:	53                   	push   %ebx
  800aa7:	56                   	push   %esi
  800aa8:	e8 02 fb ff ff       	call   8005af <printfmt>
  800aad:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ab0:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ab3:	e9 dc fe ff ff       	jmp    800994 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800ab8:	68 d4 12 80 00       	push   $0x8012d4
  800abd:	68 be 11 80 00       	push   $0x8011be
  800ac2:	53                   	push   %ebx
  800ac3:	56                   	push   %esi
  800ac4:	e8 e6 fa ff ff       	call   8005af <printfmt>
  800ac9:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800acc:	89 7d 14             	mov    %edi,0x14(%ebp)
  800acf:	e9 c0 fe ff ff       	jmp    800994 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800ad4:	83 ec 08             	sub    $0x8,%esp
  800ad7:	53                   	push   %ebx
  800ad8:	6a 25                	push   $0x25
  800ada:	ff d6                	call   *%esi
			break;
  800adc:	83 c4 10             	add    $0x10,%esp
  800adf:	e9 b0 fe ff ff       	jmp    800994 <vprintfmt+0x3c8>
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	53                   	push   %ebx
  800ae8:	6a 25                	push   $0x25
  800aea:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	89 f8                	mov    %edi,%eax
  800af1:	eb 03                	jmp    800af6 <vprintfmt+0x52a>
  800af3:	83 e8 01             	sub    $0x1,%eax
  800af6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800afa:	75 f7                	jne    800af3 <vprintfmt+0x527>
  800afc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aff:	e9 90 fe ff ff       	jmp    800994 <vprintfmt+0x3c8>
}
  800b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b07:	5b                   	pop    %ebx
  800b08:	5e                   	pop    %esi
  800b09:	5f                   	pop    %edi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 18             	sub    $0x18,%esp
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b1f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b29:	85 c0                	test   %eax,%eax
  800b2b:	74 26                	je     800b53 <vsnprintf+0x47>
  800b2d:	85 d2                	test   %edx,%edx
  800b2f:	7e 22                	jle    800b53 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b31:	ff 75 14             	pushl  0x14(%ebp)
  800b34:	ff 75 10             	pushl  0x10(%ebp)
  800b37:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	68 92 05 80 00       	push   $0x800592
  800b40:	e8 87 fa ff ff       	call   8005cc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b48:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    
		return -E_INVAL;
  800b53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b58:	eb f7                	jmp    800b51 <vsnprintf+0x45>

00800b5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b60:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b63:	50                   	push   %eax
  800b64:	ff 75 10             	pushl  0x10(%ebp)
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	e8 9a ff ff ff       	call   800b0c <vsnprintf>
	va_end(ap);

	return rc;
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b83:	74 05                	je     800b8a <strlen+0x16>
		n++;
  800b85:	83 c0 01             	add    $0x1,%eax
  800b88:	eb f5                	jmp    800b7f <strlen+0xb>
	return n;
}
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b95:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9a:	39 c2                	cmp    %eax,%edx
  800b9c:	74 0d                	je     800bab <strnlen+0x1f>
  800b9e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ba2:	74 05                	je     800ba9 <strnlen+0x1d>
		n++;
  800ba4:	83 c2 01             	add    $0x1,%edx
  800ba7:	eb f1                	jmp    800b9a <strnlen+0xe>
  800ba9:	89 d0                	mov    %edx,%eax
	return n;
}
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	53                   	push   %ebx
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbc:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bc0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bc3:	83 c2 01             	add    $0x1,%edx
  800bc6:	84 c9                	test   %cl,%cl
  800bc8:	75 f2                	jne    800bbc <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bca:	5b                   	pop    %ebx
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	53                   	push   %ebx
  800bd1:	83 ec 10             	sub    $0x10,%esp
  800bd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bd7:	53                   	push   %ebx
  800bd8:	e8 97 ff ff ff       	call   800b74 <strlen>
  800bdd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800be0:	ff 75 0c             	pushl  0xc(%ebp)
  800be3:	01 d8                	add    %ebx,%eax
  800be5:	50                   	push   %eax
  800be6:	e8 c2 ff ff ff       	call   800bad <strcpy>
	return dst;
}
  800beb:	89 d8                	mov    %ebx,%eax
  800bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    

00800bf2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfd:	89 c6                	mov    %eax,%esi
  800bff:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c02:	89 c2                	mov    %eax,%edx
  800c04:	39 f2                	cmp    %esi,%edx
  800c06:	74 11                	je     800c19 <strncpy+0x27>
		*dst++ = *src;
  800c08:	83 c2 01             	add    $0x1,%edx
  800c0b:	0f b6 19             	movzbl (%ecx),%ebx
  800c0e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c11:	80 fb 01             	cmp    $0x1,%bl
  800c14:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c17:	eb eb                	jmp    800c04 <strncpy+0x12>
	}
	return ret;
}
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	8b 75 08             	mov    0x8(%ebp),%esi
  800c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c28:	8b 55 10             	mov    0x10(%ebp),%edx
  800c2b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c2d:	85 d2                	test   %edx,%edx
  800c2f:	74 21                	je     800c52 <strlcpy+0x35>
  800c31:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c35:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c37:	39 c2                	cmp    %eax,%edx
  800c39:	74 14                	je     800c4f <strlcpy+0x32>
  800c3b:	0f b6 19             	movzbl (%ecx),%ebx
  800c3e:	84 db                	test   %bl,%bl
  800c40:	74 0b                	je     800c4d <strlcpy+0x30>
			*dst++ = *src++;
  800c42:	83 c1 01             	add    $0x1,%ecx
  800c45:	83 c2 01             	add    $0x1,%edx
  800c48:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c4b:	eb ea                	jmp    800c37 <strlcpy+0x1a>
  800c4d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c4f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c52:	29 f0                	sub    %esi,%eax
}
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c61:	0f b6 01             	movzbl (%ecx),%eax
  800c64:	84 c0                	test   %al,%al
  800c66:	74 0c                	je     800c74 <strcmp+0x1c>
  800c68:	3a 02                	cmp    (%edx),%al
  800c6a:	75 08                	jne    800c74 <strcmp+0x1c>
		p++, q++;
  800c6c:	83 c1 01             	add    $0x1,%ecx
  800c6f:	83 c2 01             	add    $0x1,%edx
  800c72:	eb ed                	jmp    800c61 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c74:	0f b6 c0             	movzbl %al,%eax
  800c77:	0f b6 12             	movzbl (%edx),%edx
  800c7a:	29 d0                	sub    %edx,%eax
}
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	53                   	push   %ebx
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c88:	89 c3                	mov    %eax,%ebx
  800c8a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c8d:	eb 06                	jmp    800c95 <strncmp+0x17>
		n--, p++, q++;
  800c8f:	83 c0 01             	add    $0x1,%eax
  800c92:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c95:	39 d8                	cmp    %ebx,%eax
  800c97:	74 16                	je     800caf <strncmp+0x31>
  800c99:	0f b6 08             	movzbl (%eax),%ecx
  800c9c:	84 c9                	test   %cl,%cl
  800c9e:	74 04                	je     800ca4 <strncmp+0x26>
  800ca0:	3a 0a                	cmp    (%edx),%cl
  800ca2:	74 eb                	je     800c8f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca4:	0f b6 00             	movzbl (%eax),%eax
  800ca7:	0f b6 12             	movzbl (%edx),%edx
  800caa:	29 d0                	sub    %edx,%eax
}
  800cac:	5b                   	pop    %ebx
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    
		return 0;
  800caf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb4:	eb f6                	jmp    800cac <strncmp+0x2e>

00800cb6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc0:	0f b6 10             	movzbl (%eax),%edx
  800cc3:	84 d2                	test   %dl,%dl
  800cc5:	74 09                	je     800cd0 <strchr+0x1a>
		if (*s == c)
  800cc7:	38 ca                	cmp    %cl,%dl
  800cc9:	74 0a                	je     800cd5 <strchr+0x1f>
	for (; *s; s++)
  800ccb:	83 c0 01             	add    $0x1,%eax
  800cce:	eb f0                	jmp    800cc0 <strchr+0xa>
			return (char *) s;
	return 0;
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ce4:	38 ca                	cmp    %cl,%dl
  800ce6:	74 09                	je     800cf1 <strfind+0x1a>
  800ce8:	84 d2                	test   %dl,%dl
  800cea:	74 05                	je     800cf1 <strfind+0x1a>
	for (; *s; s++)
  800cec:	83 c0 01             	add    $0x1,%eax
  800cef:	eb f0                	jmp    800ce1 <strfind+0xa>
			break;
	return (char *) s;
}
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cfc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cff:	85 c9                	test   %ecx,%ecx
  800d01:	74 31                	je     800d34 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d03:	89 f8                	mov    %edi,%eax
  800d05:	09 c8                	or     %ecx,%eax
  800d07:	a8 03                	test   $0x3,%al
  800d09:	75 23                	jne    800d2e <memset+0x3b>
		c &= 0xFF;
  800d0b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d0f:	89 d3                	mov    %edx,%ebx
  800d11:	c1 e3 08             	shl    $0x8,%ebx
  800d14:	89 d0                	mov    %edx,%eax
  800d16:	c1 e0 18             	shl    $0x18,%eax
  800d19:	89 d6                	mov    %edx,%esi
  800d1b:	c1 e6 10             	shl    $0x10,%esi
  800d1e:	09 f0                	or     %esi,%eax
  800d20:	09 c2                	or     %eax,%edx
  800d22:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d24:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d27:	89 d0                	mov    %edx,%eax
  800d29:	fc                   	cld    
  800d2a:	f3 ab                	rep stos %eax,%es:(%edi)
  800d2c:	eb 06                	jmp    800d34 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	fc                   	cld    
  800d32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d34:	89 f8                	mov    %edi,%eax
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d49:	39 c6                	cmp    %eax,%esi
  800d4b:	73 32                	jae    800d7f <memmove+0x44>
  800d4d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d50:	39 c2                	cmp    %eax,%edx
  800d52:	76 2b                	jbe    800d7f <memmove+0x44>
		s += n;
		d += n;
  800d54:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d57:	89 fe                	mov    %edi,%esi
  800d59:	09 ce                	or     %ecx,%esi
  800d5b:	09 d6                	or     %edx,%esi
  800d5d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d63:	75 0e                	jne    800d73 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d65:	83 ef 04             	sub    $0x4,%edi
  800d68:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d6b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d6e:	fd                   	std    
  800d6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d71:	eb 09                	jmp    800d7c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d73:	83 ef 01             	sub    $0x1,%edi
  800d76:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d79:	fd                   	std    
  800d7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d7c:	fc                   	cld    
  800d7d:	eb 1a                	jmp    800d99 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d7f:	89 c2                	mov    %eax,%edx
  800d81:	09 ca                	or     %ecx,%edx
  800d83:	09 f2                	or     %esi,%edx
  800d85:	f6 c2 03             	test   $0x3,%dl
  800d88:	75 0a                	jne    800d94 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d8a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d8d:	89 c7                	mov    %eax,%edi
  800d8f:	fc                   	cld    
  800d90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d92:	eb 05                	jmp    800d99 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d94:	89 c7                	mov    %eax,%edi
  800d96:	fc                   	cld    
  800d97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800da3:	ff 75 10             	pushl  0x10(%ebp)
  800da6:	ff 75 0c             	pushl  0xc(%ebp)
  800da9:	ff 75 08             	pushl  0x8(%ebp)
  800dac:	e8 8a ff ff ff       	call   800d3b <memmove>
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbe:	89 c6                	mov    %eax,%esi
  800dc0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dc3:	39 f0                	cmp    %esi,%eax
  800dc5:	74 1c                	je     800de3 <memcmp+0x30>
		if (*s1 != *s2)
  800dc7:	0f b6 08             	movzbl (%eax),%ecx
  800dca:	0f b6 1a             	movzbl (%edx),%ebx
  800dcd:	38 d9                	cmp    %bl,%cl
  800dcf:	75 08                	jne    800dd9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dd1:	83 c0 01             	add    $0x1,%eax
  800dd4:	83 c2 01             	add    $0x1,%edx
  800dd7:	eb ea                	jmp    800dc3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dd9:	0f b6 c1             	movzbl %cl,%eax
  800ddc:	0f b6 db             	movzbl %bl,%ebx
  800ddf:	29 d8                	sub    %ebx,%eax
  800de1:	eb 05                	jmp    800de8 <memcmp+0x35>
	}

	return 0;
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800df5:	89 c2                	mov    %eax,%edx
  800df7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dfa:	39 d0                	cmp    %edx,%eax
  800dfc:	73 09                	jae    800e07 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dfe:	38 08                	cmp    %cl,(%eax)
  800e00:	74 05                	je     800e07 <memfind+0x1b>
	for (; s < ends; s++)
  800e02:	83 c0 01             	add    $0x1,%eax
  800e05:	eb f3                	jmp    800dfa <memfind+0xe>
			break;
	return (void *) s;
}
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e15:	eb 03                	jmp    800e1a <strtol+0x11>
		s++;
  800e17:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e1a:	0f b6 01             	movzbl (%ecx),%eax
  800e1d:	3c 20                	cmp    $0x20,%al
  800e1f:	74 f6                	je     800e17 <strtol+0xe>
  800e21:	3c 09                	cmp    $0x9,%al
  800e23:	74 f2                	je     800e17 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e25:	3c 2b                	cmp    $0x2b,%al
  800e27:	74 2a                	je     800e53 <strtol+0x4a>
	int neg = 0;
  800e29:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e2e:	3c 2d                	cmp    $0x2d,%al
  800e30:	74 2b                	je     800e5d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e32:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e38:	75 0f                	jne    800e49 <strtol+0x40>
  800e3a:	80 39 30             	cmpb   $0x30,(%ecx)
  800e3d:	74 28                	je     800e67 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e3f:	85 db                	test   %ebx,%ebx
  800e41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e46:	0f 44 d8             	cmove  %eax,%ebx
  800e49:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e51:	eb 50                	jmp    800ea3 <strtol+0x9a>
		s++;
  800e53:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e56:	bf 00 00 00 00       	mov    $0x0,%edi
  800e5b:	eb d5                	jmp    800e32 <strtol+0x29>
		s++, neg = 1;
  800e5d:	83 c1 01             	add    $0x1,%ecx
  800e60:	bf 01 00 00 00       	mov    $0x1,%edi
  800e65:	eb cb                	jmp    800e32 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e67:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e6b:	74 0e                	je     800e7b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	75 d8                	jne    800e49 <strtol+0x40>
		s++, base = 8;
  800e71:	83 c1 01             	add    $0x1,%ecx
  800e74:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e79:	eb ce                	jmp    800e49 <strtol+0x40>
		s += 2, base = 16;
  800e7b:	83 c1 02             	add    $0x2,%ecx
  800e7e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e83:	eb c4                	jmp    800e49 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e85:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e88:	89 f3                	mov    %esi,%ebx
  800e8a:	80 fb 19             	cmp    $0x19,%bl
  800e8d:	77 29                	ja     800eb8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e8f:	0f be d2             	movsbl %dl,%edx
  800e92:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e95:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e98:	7d 30                	jge    800eca <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e9a:	83 c1 01             	add    $0x1,%ecx
  800e9d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ea1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ea3:	0f b6 11             	movzbl (%ecx),%edx
  800ea6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ea9:	89 f3                	mov    %esi,%ebx
  800eab:	80 fb 09             	cmp    $0x9,%bl
  800eae:	77 d5                	ja     800e85 <strtol+0x7c>
			dig = *s - '0';
  800eb0:	0f be d2             	movsbl %dl,%edx
  800eb3:	83 ea 30             	sub    $0x30,%edx
  800eb6:	eb dd                	jmp    800e95 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eb8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ebb:	89 f3                	mov    %esi,%ebx
  800ebd:	80 fb 19             	cmp    $0x19,%bl
  800ec0:	77 08                	ja     800eca <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ec2:	0f be d2             	movsbl %dl,%edx
  800ec5:	83 ea 37             	sub    $0x37,%edx
  800ec8:	eb cb                	jmp    800e95 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ece:	74 05                	je     800ed5 <strtol+0xcc>
		*endptr = (char *) s;
  800ed0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ed3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ed5:	89 c2                	mov    %eax,%edx
  800ed7:	f7 da                	neg    %edx
  800ed9:	85 ff                	test   %edi,%edi
  800edb:	0f 45 c2             	cmovne %edx,%eax
}
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    
  800ee3:	66 90                	xchg   %ax,%ax
  800ee5:	66 90                	xchg   %ax,%ax
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
