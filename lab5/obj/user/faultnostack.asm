
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 de 03 80 00       	push   $0x8003de
  80003e:	6a 00                	push   $0x0
  800040:	e8 b2 02 00 00       	call   8002f7 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005f:	e8 c9 00 00 00       	call   80012d <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80006c:	c1 e0 04             	shl    $0x4,%eax
  80006f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800074:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800079:	85 db                	test   %ebx,%ebx
  80007b:	7e 07                	jle    800084 <libmain+0x30>
		binaryname = argv[0];
  80007d:	8b 06                	mov    (%esi),%eax
  80007f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	56                   	push   %esi
  800088:	53                   	push   %ebx
  800089:	e8 a5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008e:	e8 0a 00 00 00       	call   80009d <exit>
}
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800099:	5b                   	pop    %ebx
  80009a:	5e                   	pop    %esi
  80009b:	5d                   	pop    %ebp
  80009c:	c3                   	ret    

0080009d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009d:	55                   	push   %ebp
  80009e:	89 e5                	mov    %esp,%ebp
  8000a0:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000a3:	6a 00                	push   $0x0
  8000a5:	e8 42 00 00 00       	call   8000ec <sys_env_destroy>
}
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	57                   	push   %edi
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c0:	89 c3                	mov    %eax,%ebx
  8000c2:	89 c7                	mov    %eax,%edi
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5f                   	pop    %edi
  8000cb:	5d                   	pop    %ebp
  8000cc:	c3                   	ret    

008000cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	57                   	push   %edi
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000dd:	89 d1                	mov    %edx,%ecx
  8000df:	89 d3                	mov    %edx,%ebx
  8000e1:	89 d7                	mov    %edx,%edi
  8000e3:	89 d6                	mov    %edx,%esi
  8000e5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e7:	5b                   	pop    %ebx
  8000e8:	5e                   	pop    %esi
  8000e9:	5f                   	pop    %edi
  8000ea:	5d                   	pop    %ebp
  8000eb:	c3                   	ret    

008000ec <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	57                   	push   %edi
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fd:	b8 03 00 00 00       	mov    $0x3,%eax
  800102:	89 cb                	mov    %ecx,%ebx
  800104:	89 cf                	mov    %ecx,%edi
  800106:	89 ce                	mov    %ecx,%esi
  800108:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010a:	85 c0                	test   %eax,%eax
  80010c:	7f 08                	jg     800116 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800111:	5b                   	pop    %ebx
  800112:	5e                   	pop    %esi
  800113:	5f                   	pop    %edi
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	50                   	push   %eax
  80011a:	6a 03                	push   $0x3
  80011c:	68 ea 11 80 00       	push   $0x8011ea
  800121:	6a 33                	push   $0x33
  800123:	68 07 12 80 00       	push   $0x801207
  800128:	e8 d7 02 00 00       	call   800404 <_panic>

0080012d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	57                   	push   %edi
  800131:	56                   	push   %esi
  800132:	53                   	push   %ebx
	asm volatile("int %1\n"
  800133:	ba 00 00 00 00       	mov    $0x0,%edx
  800138:	b8 02 00 00 00       	mov    $0x2,%eax
  80013d:	89 d1                	mov    %edx,%ecx
  80013f:	89 d3                	mov    %edx,%ebx
  800141:	89 d7                	mov    %edx,%edi
  800143:	89 d6                	mov    %edx,%esi
  800145:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800147:	5b                   	pop    %ebx
  800148:	5e                   	pop    %esi
  800149:	5f                   	pop    %edi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <sys_yield>:

void
sys_yield(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	57                   	push   %edi
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
	asm volatile("int %1\n"
  800152:	ba 00 00 00 00       	mov    $0x0,%edx
  800157:	b8 0c 00 00 00       	mov    $0xc,%eax
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	89 d3                	mov    %edx,%ebx
  800160:	89 d7                	mov    %edx,%edi
  800162:	89 d6                	mov    %edx,%esi
  800164:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800166:	5b                   	pop    %ebx
  800167:	5e                   	pop    %esi
  800168:	5f                   	pop    %edi
  800169:	5d                   	pop    %ebp
  80016a:	c3                   	ret    

0080016b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	57                   	push   %edi
  80016f:	56                   	push   %esi
  800170:	53                   	push   %ebx
  800171:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800174:	be 00 00 00 00       	mov    $0x0,%esi
  800179:	8b 55 08             	mov    0x8(%ebp),%edx
  80017c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017f:	b8 04 00 00 00       	mov    $0x4,%eax
  800184:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800187:	89 f7                	mov    %esi,%edi
  800189:	cd 30                	int    $0x30
	if(check && ret > 0)
  80018b:	85 c0                	test   %eax,%eax
  80018d:	7f 08                	jg     800197 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800192:	5b                   	pop    %ebx
  800193:	5e                   	pop    %esi
  800194:	5f                   	pop    %edi
  800195:	5d                   	pop    %ebp
  800196:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	50                   	push   %eax
  80019b:	6a 04                	push   $0x4
  80019d:	68 ea 11 80 00       	push   $0x8011ea
  8001a2:	6a 33                	push   $0x33
  8001a4:	68 07 12 80 00       	push   $0x801207
  8001a9:	e8 56 02 00 00       	call   800404 <_panic>

008001ae <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	57                   	push   %edi
  8001b2:	56                   	push   %esi
  8001b3:	53                   	push   %ebx
  8001b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	7f 08                	jg     8001d9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d4:	5b                   	pop    %ebx
  8001d5:	5e                   	pop    %esi
  8001d6:	5f                   	pop    %edi
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	50                   	push   %eax
  8001dd:	6a 05                	push   $0x5
  8001df:	68 ea 11 80 00       	push   $0x8011ea
  8001e4:	6a 33                	push   $0x33
  8001e6:	68 07 12 80 00       	push   $0x801207
  8001eb:	e8 14 02 00 00       	call   800404 <_panic>

008001f0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800201:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800204:	b8 06 00 00 00       	mov    $0x6,%eax
  800209:	89 df                	mov    %ebx,%edi
  80020b:	89 de                	mov    %ebx,%esi
  80020d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020f:	85 c0                	test   %eax,%eax
  800211:	7f 08                	jg     80021b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800213:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5f                   	pop    %edi
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	50                   	push   %eax
  80021f:	6a 06                	push   $0x6
  800221:	68 ea 11 80 00       	push   $0x8011ea
  800226:	6a 33                	push   $0x33
  800228:	68 07 12 80 00       	push   $0x801207
  80022d:	e8 d2 01 00 00       	call   800404 <_panic>

00800232 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800240:	8b 55 08             	mov    0x8(%ebp),%edx
  800243:	b8 0b 00 00 00       	mov    $0xb,%eax
  800248:	89 cb                	mov    %ecx,%ebx
  80024a:	89 cf                	mov    %ecx,%edi
  80024c:	89 ce                	mov    %ecx,%esi
  80024e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800250:	85 c0                	test   %eax,%eax
  800252:	7f 08                	jg     80025c <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800254:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800257:	5b                   	pop    %ebx
  800258:	5e                   	pop    %esi
  800259:	5f                   	pop    %edi
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	6a 0b                	push   $0xb
  800262:	68 ea 11 80 00       	push   $0x8011ea
  800267:	6a 33                	push   $0x33
  800269:	68 07 12 80 00       	push   $0x801207
  80026e:	e8 91 01 00 00       	call   800404 <_panic>

00800273 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	57                   	push   %edi
  800277:	56                   	push   %esi
  800278:	53                   	push   %ebx
  800279:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800281:	8b 55 08             	mov    0x8(%ebp),%edx
  800284:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800287:	b8 08 00 00 00       	mov    $0x8,%eax
  80028c:	89 df                	mov    %ebx,%edi
  80028e:	89 de                	mov    %ebx,%esi
  800290:	cd 30                	int    $0x30
	if(check && ret > 0)
  800292:	85 c0                	test   %eax,%eax
  800294:	7f 08                	jg     80029e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029e:	83 ec 0c             	sub    $0xc,%esp
  8002a1:	50                   	push   %eax
  8002a2:	6a 08                	push   $0x8
  8002a4:	68 ea 11 80 00       	push   $0x8011ea
  8002a9:	6a 33                	push   $0x33
  8002ab:	68 07 12 80 00       	push   $0x801207
  8002b0:	e8 4f 01 00 00       	call   800404 <_panic>

008002b5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	57                   	push   %edi
  8002b9:	56                   	push   %esi
  8002ba:	53                   	push   %ebx
  8002bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c9:	b8 09 00 00 00       	mov    $0x9,%eax
  8002ce:	89 df                	mov    %ebx,%edi
  8002d0:	89 de                	mov    %ebx,%esi
  8002d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d4:	85 c0                	test   %eax,%eax
  8002d6:	7f 08                	jg     8002e0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002db:	5b                   	pop    %ebx
  8002dc:	5e                   	pop    %esi
  8002dd:	5f                   	pop    %edi
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	50                   	push   %eax
  8002e4:	6a 09                	push   $0x9
  8002e6:	68 ea 11 80 00       	push   $0x8011ea
  8002eb:	6a 33                	push   $0x33
  8002ed:	68 07 12 80 00       	push   $0x801207
  8002f2:	e8 0d 01 00 00       	call   800404 <_panic>

008002f7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
  8002fd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800300:	bb 00 00 00 00       	mov    $0x0,%ebx
  800305:	8b 55 08             	mov    0x8(%ebp),%edx
  800308:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800310:	89 df                	mov    %ebx,%edi
  800312:	89 de                	mov    %ebx,%esi
  800314:	cd 30                	int    $0x30
	if(check && ret > 0)
  800316:	85 c0                	test   %eax,%eax
  800318:	7f 08                	jg     800322 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80031a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031d:	5b                   	pop    %ebx
  80031e:	5e                   	pop    %esi
  80031f:	5f                   	pop    %edi
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800322:	83 ec 0c             	sub    $0xc,%esp
  800325:	50                   	push   %eax
  800326:	6a 0a                	push   $0xa
  800328:	68 ea 11 80 00       	push   $0x8011ea
  80032d:	6a 33                	push   $0x33
  80032f:	68 07 12 80 00       	push   $0x801207
  800334:	e8 cb 00 00 00       	call   800404 <_panic>

00800339 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	57                   	push   %edi
  80033d:	56                   	push   %esi
  80033e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800345:	b8 0d 00 00 00       	mov    $0xd,%eax
  80034a:	be 00 00 00 00       	mov    $0x0,%esi
  80034f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800352:	8b 7d 14             	mov    0x14(%ebp),%edi
  800355:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800357:	5b                   	pop    %ebx
  800358:	5e                   	pop    %esi
  800359:	5f                   	pop    %edi
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	57                   	push   %edi
  800360:	56                   	push   %esi
  800361:	53                   	push   %ebx
  800362:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800365:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036a:	8b 55 08             	mov    0x8(%ebp),%edx
  80036d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800372:	89 cb                	mov    %ecx,%ebx
  800374:	89 cf                	mov    %ecx,%edi
  800376:	89 ce                	mov    %ecx,%esi
  800378:	cd 30                	int    $0x30
	if(check && ret > 0)
  80037a:	85 c0                	test   %eax,%eax
  80037c:	7f 08                	jg     800386 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80037e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800381:	5b                   	pop    %ebx
  800382:	5e                   	pop    %esi
  800383:	5f                   	pop    %edi
  800384:	5d                   	pop    %ebp
  800385:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	50                   	push   %eax
  80038a:	6a 0e                	push   $0xe
  80038c:	68 ea 11 80 00       	push   $0x8011ea
  800391:	6a 33                	push   $0x33
  800393:	68 07 12 80 00       	push   $0x801207
  800398:	e8 67 00 00 00       	call   800404 <_panic>

0080039d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	57                   	push   %edi
  8003a1:	56                   	push   %esi
  8003a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ae:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003b3:	89 df                	mov    %ebx,%edi
  8003b5:	89 de                	mov    %ebx,%esi
  8003b7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003b9:	5b                   	pop    %ebx
  8003ba:	5e                   	pop    %esi
  8003bb:	5f                   	pop    %edi
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    

008003be <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	57                   	push   %edi
  8003c2:	56                   	push   %esi
  8003c3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003cc:	b8 10 00 00 00       	mov    $0x10,%eax
  8003d1:	89 cb                	mov    %ecx,%ebx
  8003d3:	89 cf                	mov    %ecx,%edi
  8003d5:	89 ce                	mov    %ecx,%esi
  8003d7:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003d9:	5b                   	pop    %ebx
  8003da:	5e                   	pop    %esi
  8003db:	5f                   	pop    %edi
  8003dc:	5d                   	pop    %ebp
  8003dd:	c3                   	ret    

008003de <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8003de:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8003df:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8003e4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8003e6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  8003e9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  8003ed:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8003f1:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8003f4:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8003f6:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8003fa:	83 c4 08             	add    $0x8,%esp
	popal
  8003fd:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8003fe:	83 c4 04             	add    $0x4,%esp
	popfl
  800401:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800402:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800403:	c3                   	ret    

00800404 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	56                   	push   %esi
  800408:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800409:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80040c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800412:	e8 16 fd ff ff       	call   80012d <sys_getenvid>
  800417:	83 ec 0c             	sub    $0xc,%esp
  80041a:	ff 75 0c             	pushl  0xc(%ebp)
  80041d:	ff 75 08             	pushl  0x8(%ebp)
  800420:	56                   	push   %esi
  800421:	50                   	push   %eax
  800422:	68 18 12 80 00       	push   $0x801218
  800427:	e8 b3 00 00 00       	call   8004df <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80042c:	83 c4 18             	add    $0x18,%esp
  80042f:	53                   	push   %ebx
  800430:	ff 75 10             	pushl  0x10(%ebp)
  800433:	e8 56 00 00 00       	call   80048e <vcprintf>
	cprintf("\n");
  800438:	c7 04 24 d6 15 80 00 	movl   $0x8015d6,(%esp)
  80043f:	e8 9b 00 00 00       	call   8004df <cprintf>
  800444:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800447:	cc                   	int3   
  800448:	eb fd                	jmp    800447 <_panic+0x43>

0080044a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	53                   	push   %ebx
  80044e:	83 ec 04             	sub    $0x4,%esp
  800451:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800454:	8b 13                	mov    (%ebx),%edx
  800456:	8d 42 01             	lea    0x1(%edx),%eax
  800459:	89 03                	mov    %eax,(%ebx)
  80045b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80045e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800462:	3d ff 00 00 00       	cmp    $0xff,%eax
  800467:	74 09                	je     800472 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800469:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80046d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800470:	c9                   	leave  
  800471:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	68 ff 00 00 00       	push   $0xff
  80047a:	8d 43 08             	lea    0x8(%ebx),%eax
  80047d:	50                   	push   %eax
  80047e:	e8 2c fc ff ff       	call   8000af <sys_cputs>
		b->idx = 0;
  800483:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	eb db                	jmp    800469 <putch+0x1f>

0080048e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800497:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80049e:	00 00 00 
	b.cnt = 0;
  8004a1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004ab:	ff 75 0c             	pushl  0xc(%ebp)
  8004ae:	ff 75 08             	pushl  0x8(%ebp)
  8004b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b7:	50                   	push   %eax
  8004b8:	68 4a 04 80 00       	push   $0x80044a
  8004bd:	e8 4a 01 00 00       	call   80060c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004c2:	83 c4 08             	add    $0x8,%esp
  8004c5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004cb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004d1:	50                   	push   %eax
  8004d2:	e8 d8 fb ff ff       	call   8000af <sys_cputs>

	return b.cnt;
}
  8004d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004dd:	c9                   	leave  
  8004de:	c3                   	ret    

008004df <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004df:	55                   	push   %ebp
  8004e0:	89 e5                	mov    %esp,%ebp
  8004e2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004e5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004e8:	50                   	push   %eax
  8004e9:	ff 75 08             	pushl  0x8(%ebp)
  8004ec:	e8 9d ff ff ff       	call   80048e <vcprintf>
	va_end(ap);

	return cnt;
}
  8004f1:	c9                   	leave  
  8004f2:	c3                   	ret    

008004f3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004f3:	55                   	push   %ebp
  8004f4:	89 e5                	mov    %esp,%ebp
  8004f6:	57                   	push   %edi
  8004f7:	56                   	push   %esi
  8004f8:	53                   	push   %ebx
  8004f9:	83 ec 1c             	sub    $0x1c,%esp
  8004fc:	89 c6                	mov    %eax,%esi
  8004fe:	89 d7                	mov    %edx,%edi
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800509:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80050c:	8b 45 10             	mov    0x10(%ebp),%eax
  80050f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800512:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800516:	74 2c                	je     800544 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800518:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800522:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800525:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80052d:	73 43                	jae    800572 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052f:	83 eb 01             	sub    $0x1,%ebx
  800532:	85 db                	test   %ebx,%ebx
  800534:	7e 6c                	jle    8005a2 <printnum+0xaf>
			putch(padc, putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	57                   	push   %edi
  80053a:	ff 75 18             	pushl  0x18(%ebp)
  80053d:	ff d6                	call   *%esi
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	eb eb                	jmp    80052f <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	6a 20                	push   $0x20
  800549:	6a 00                	push   $0x0
  80054b:	50                   	push   %eax
  80054c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80054f:	ff 75 e0             	pushl  -0x20(%ebp)
  800552:	89 fa                	mov    %edi,%edx
  800554:	89 f0                	mov    %esi,%eax
  800556:	e8 98 ff ff ff       	call   8004f3 <printnum>
		while (--width > 0)
  80055b:	83 c4 20             	add    $0x20,%esp
  80055e:	83 eb 01             	sub    $0x1,%ebx
  800561:	85 db                	test   %ebx,%ebx
  800563:	7e 65                	jle    8005ca <printnum+0xd7>
			putch(padc, putdat);
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	57                   	push   %edi
  800569:	6a 20                	push   $0x20
  80056b:	ff d6                	call   *%esi
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	eb ec                	jmp    80055e <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800572:	83 ec 0c             	sub    $0xc,%esp
  800575:	ff 75 18             	pushl  0x18(%ebp)
  800578:	83 eb 01             	sub    $0x1,%ebx
  80057b:	53                   	push   %ebx
  80057c:	50                   	push   %eax
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	ff 75 dc             	pushl  -0x24(%ebp)
  800583:	ff 75 d8             	pushl  -0x28(%ebp)
  800586:	ff 75 e4             	pushl  -0x1c(%ebp)
  800589:	ff 75 e0             	pushl  -0x20(%ebp)
  80058c:	e8 ff 09 00 00       	call   800f90 <__udivdi3>
  800591:	83 c4 18             	add    $0x18,%esp
  800594:	52                   	push   %edx
  800595:	50                   	push   %eax
  800596:	89 fa                	mov    %edi,%edx
  800598:	89 f0                	mov    %esi,%eax
  80059a:	e8 54 ff ff ff       	call   8004f3 <printnum>
  80059f:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	57                   	push   %edi
  8005a6:	83 ec 04             	sub    $0x4,%esp
  8005a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8005ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8005af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b5:	e8 e6 0a 00 00       	call   8010a0 <__umoddi3>
  8005ba:	83 c4 14             	add    $0x14,%esp
  8005bd:	0f be 80 3b 12 80 00 	movsbl 0x80123b(%eax),%eax
  8005c4:	50                   	push   %eax
  8005c5:	ff d6                	call   *%esi
  8005c7:	83 c4 10             	add    $0x10,%esp
}
  8005ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005cd:	5b                   	pop    %ebx
  8005ce:	5e                   	pop    %esi
  8005cf:	5f                   	pop    %edi
  8005d0:	5d                   	pop    %ebp
  8005d1:	c3                   	ret    

008005d2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005d8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005dc:	8b 10                	mov    (%eax),%edx
  8005de:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e1:	73 0a                	jae    8005ed <sprintputch+0x1b>
		*b->buf++ = ch;
  8005e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005e6:	89 08                	mov    %ecx,(%eax)
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	88 02                	mov    %al,(%edx)
}
  8005ed:	5d                   	pop    %ebp
  8005ee:	c3                   	ret    

008005ef <printfmt>:
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005f5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005f8:	50                   	push   %eax
  8005f9:	ff 75 10             	pushl  0x10(%ebp)
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	ff 75 08             	pushl  0x8(%ebp)
  800602:	e8 05 00 00 00       	call   80060c <vprintfmt>
}
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	c9                   	leave  
  80060b:	c3                   	ret    

0080060c <vprintfmt>:
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	57                   	push   %edi
  800610:	56                   	push   %esi
  800611:	53                   	push   %ebx
  800612:	83 ec 3c             	sub    $0x3c,%esp
  800615:	8b 75 08             	mov    0x8(%ebp),%esi
  800618:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80061b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80061e:	e9 b4 03 00 00       	jmp    8009d7 <vprintfmt+0x3cb>
		padc = ' ';
  800623:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800627:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80062e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800635:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80063c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800643:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800648:	8d 47 01             	lea    0x1(%edi),%eax
  80064b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064e:	0f b6 17             	movzbl (%edi),%edx
  800651:	8d 42 dd             	lea    -0x23(%edx),%eax
  800654:	3c 55                	cmp    $0x55,%al
  800656:	0f 87 c8 04 00 00    	ja     800b24 <vprintfmt+0x518>
  80065c:	0f b6 c0             	movzbl %al,%eax
  80065f:	ff 24 85 20 14 80 00 	jmp    *0x801420(,%eax,4)
  800666:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800669:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800670:	eb d6                	jmp    800648 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800672:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800675:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800679:	eb cd                	jmp    800648 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	0f b6 d2             	movzbl %dl,%edx
  80067e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800681:	b8 00 00 00 00       	mov    $0x0,%eax
  800686:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800689:	eb 0c                	jmp    800697 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80068b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80068e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800692:	eb b4                	jmp    800648 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800694:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800697:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80069a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80069e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8006a1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006a4:	83 f9 09             	cmp    $0x9,%ecx
  8006a7:	76 eb                	jbe    800694 <vprintfmt+0x88>
  8006a9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006af:	eb 14                	jmp    8006c5 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8d 40 04             	lea    0x4(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c9:	0f 89 79 ff ff ff    	jns    800648 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8006cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006dc:	e9 67 ff ff ff       	jmp    800648 <vprintfmt+0x3c>
  8006e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e4:	85 c0                	test   %eax,%eax
  8006e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006eb:	0f 49 d0             	cmovns %eax,%edx
  8006ee:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006f4:	e9 4f ff ff ff       	jmp    800648 <vprintfmt+0x3c>
  8006f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006fc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800703:	e9 40 ff ff ff       	jmp    800648 <vprintfmt+0x3c>
			lflag++;
  800708:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80070b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80070e:	e9 35 ff ff ff       	jmp    800648 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 78 04             	lea    0x4(%eax),%edi
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	ff 30                	pushl  (%eax)
  80071f:	ff d6                	call   *%esi
			break;
  800721:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800724:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800727:	e9 a8 02 00 00       	jmp    8009d4 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 78 04             	lea    0x4(%eax),%edi
  800732:	8b 00                	mov    (%eax),%eax
  800734:	99                   	cltd   
  800735:	31 d0                	xor    %edx,%eax
  800737:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800739:	83 f8 0f             	cmp    $0xf,%eax
  80073c:	7f 23                	jg     800761 <vprintfmt+0x155>
  80073e:	8b 14 85 80 15 80 00 	mov    0x801580(,%eax,4),%edx
  800745:	85 d2                	test   %edx,%edx
  800747:	74 18                	je     800761 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800749:	52                   	push   %edx
  80074a:	68 5c 12 80 00       	push   $0x80125c
  80074f:	53                   	push   %ebx
  800750:	56                   	push   %esi
  800751:	e8 99 fe ff ff       	call   8005ef <printfmt>
  800756:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800759:	89 7d 14             	mov    %edi,0x14(%ebp)
  80075c:	e9 73 02 00 00       	jmp    8009d4 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800761:	50                   	push   %eax
  800762:	68 53 12 80 00       	push   $0x801253
  800767:	53                   	push   %ebx
  800768:	56                   	push   %esi
  800769:	e8 81 fe ff ff       	call   8005ef <printfmt>
  80076e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800771:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800774:	e9 5b 02 00 00       	jmp    8009d4 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	83 c0 04             	add    $0x4,%eax
  80077f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800787:	85 d2                	test   %edx,%edx
  800789:	b8 4c 12 80 00       	mov    $0x80124c,%eax
  80078e:	0f 45 c2             	cmovne %edx,%eax
  800791:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800794:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800798:	7e 06                	jle    8007a0 <vprintfmt+0x194>
  80079a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80079e:	75 0d                	jne    8007ad <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007a3:	89 c7                	mov    %eax,%edi
  8007a5:	03 45 e0             	add    -0x20(%ebp),%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007ab:	eb 53                	jmp    800800 <vprintfmt+0x1f4>
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	e8 13 04 00 00       	call   800bcc <strnlen>
  8007b9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007bc:	29 c1                	sub    %eax,%ecx
  8007be:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007c6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007cd:	eb 0f                	jmp    8007de <vprintfmt+0x1d2>
					putch(padc, putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	53                   	push   %ebx
  8007d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d8:	83 ef 01             	sub    $0x1,%edi
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	85 ff                	test   %edi,%edi
  8007e0:	7f ed                	jg     8007cf <vprintfmt+0x1c3>
  8007e2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007e5:	85 d2                	test   %edx,%edx
  8007e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ec:	0f 49 c2             	cmovns %edx,%eax
  8007ef:	29 c2                	sub    %eax,%edx
  8007f1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007f4:	eb aa                	jmp    8007a0 <vprintfmt+0x194>
					putch(ch, putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	52                   	push   %edx
  8007fb:	ff d6                	call   *%esi
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800803:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800805:	83 c7 01             	add    $0x1,%edi
  800808:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80080c:	0f be d0             	movsbl %al,%edx
  80080f:	85 d2                	test   %edx,%edx
  800811:	74 4b                	je     80085e <vprintfmt+0x252>
  800813:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800817:	78 06                	js     80081f <vprintfmt+0x213>
  800819:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80081d:	78 1e                	js     80083d <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80081f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800823:	74 d1                	je     8007f6 <vprintfmt+0x1ea>
  800825:	0f be c0             	movsbl %al,%eax
  800828:	83 e8 20             	sub    $0x20,%eax
  80082b:	83 f8 5e             	cmp    $0x5e,%eax
  80082e:	76 c6                	jbe    8007f6 <vprintfmt+0x1ea>
					putch('?', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	53                   	push   %ebx
  800834:	6a 3f                	push   $0x3f
  800836:	ff d6                	call   *%esi
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	eb c3                	jmp    800800 <vprintfmt+0x1f4>
  80083d:	89 cf                	mov    %ecx,%edi
  80083f:	eb 0e                	jmp    80084f <vprintfmt+0x243>
				putch(' ', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	53                   	push   %ebx
  800845:	6a 20                	push   $0x20
  800847:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800849:	83 ef 01             	sub    $0x1,%edi
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	85 ff                	test   %edi,%edi
  800851:	7f ee                	jg     800841 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800853:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	e9 76 01 00 00       	jmp    8009d4 <vprintfmt+0x3c8>
  80085e:	89 cf                	mov    %ecx,%edi
  800860:	eb ed                	jmp    80084f <vprintfmt+0x243>
	if (lflag >= 2)
  800862:	83 f9 01             	cmp    $0x1,%ecx
  800865:	7f 1f                	jg     800886 <vprintfmt+0x27a>
	else if (lflag)
  800867:	85 c9                	test   %ecx,%ecx
  800869:	74 6a                	je     8008d5 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800873:	89 c1                	mov    %eax,%ecx
  800875:	c1 f9 1f             	sar    $0x1f,%ecx
  800878:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8d 40 04             	lea    0x4(%eax),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
  800884:	eb 17                	jmp    80089d <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	8b 50 04             	mov    0x4(%eax),%edx
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800891:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	8d 40 08             	lea    0x8(%eax),%eax
  80089a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80089d:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8008a0:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8008a5:	85 d2                	test   %edx,%edx
  8008a7:	0f 89 f8 00 00 00    	jns    8009a5 <vprintfmt+0x399>
				putch('-', putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	53                   	push   %ebx
  8008b1:	6a 2d                	push   $0x2d
  8008b3:	ff d6                	call   *%esi
				num = -(long long) num;
  8008b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8008bb:	f7 d8                	neg    %eax
  8008bd:	83 d2 00             	adc    $0x0,%edx
  8008c0:	f7 da                	neg    %edx
  8008c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008cb:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008d0:	e9 e1 00 00 00       	jmp    8009b6 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008dd:	99                   	cltd   
  8008de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8d 40 04             	lea    0x4(%eax),%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ea:	eb b1                	jmp    80089d <vprintfmt+0x291>
	if (lflag >= 2)
  8008ec:	83 f9 01             	cmp    $0x1,%ecx
  8008ef:	7f 27                	jg     800918 <vprintfmt+0x30c>
	else if (lflag)
  8008f1:	85 c9                	test   %ecx,%ecx
  8008f3:	74 41                	je     800936 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800902:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8d 40 04             	lea    0x4(%eax),%eax
  80090b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800913:	e9 8d 00 00 00       	jmp    8009a5 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	8b 50 04             	mov    0x4(%eax),%edx
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800923:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	8d 40 08             	lea    0x8(%eax),%eax
  80092c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80092f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800934:	eb 6f                	jmp    8009a5 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800936:	8b 45 14             	mov    0x14(%ebp),%eax
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	ba 00 00 00 00       	mov    $0x0,%edx
  800940:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800943:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8d 40 04             	lea    0x4(%eax),%eax
  80094c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80094f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800954:	eb 4f                	jmp    8009a5 <vprintfmt+0x399>
	if (lflag >= 2)
  800956:	83 f9 01             	cmp    $0x1,%ecx
  800959:	7f 23                	jg     80097e <vprintfmt+0x372>
	else if (lflag)
  80095b:	85 c9                	test   %ecx,%ecx
  80095d:	0f 84 98 00 00 00    	je     8009fb <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	ba 00 00 00 00       	mov    $0x0,%edx
  80096d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800970:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8d 40 04             	lea    0x4(%eax),%eax
  800979:	89 45 14             	mov    %eax,0x14(%ebp)
  80097c:	eb 17                	jmp    800995 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	8b 50 04             	mov    0x4(%eax),%edx
  800984:	8b 00                	mov    (%eax),%eax
  800986:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800989:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8d 40 08             	lea    0x8(%eax),%eax
  800992:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	53                   	push   %ebx
  800999:	6a 30                	push   $0x30
  80099b:	ff d6                	call   *%esi
			goto number;
  80099d:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8009a0:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8009a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8009a9:	74 0b                	je     8009b6 <vprintfmt+0x3aa>
				putch('+', putdat);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	53                   	push   %ebx
  8009af:	6a 2b                	push   $0x2b
  8009b1:	ff d6                	call   *%esi
  8009b3:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009b6:	83 ec 0c             	sub    $0xc,%esp
  8009b9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	ff 75 e0             	pushl  -0x20(%ebp)
  8009c1:	57                   	push   %edi
  8009c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8009c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8009c8:	89 da                	mov    %ebx,%edx
  8009ca:	89 f0                	mov    %esi,%eax
  8009cc:	e8 22 fb ff ff       	call   8004f3 <printnum>
			break;
  8009d1:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d7:	83 c7 01             	add    $0x1,%edi
  8009da:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009de:	83 f8 25             	cmp    $0x25,%eax
  8009e1:	0f 84 3c fc ff ff    	je     800623 <vprintfmt+0x17>
			if (ch == '\0')
  8009e7:	85 c0                	test   %eax,%eax
  8009e9:	0f 84 55 01 00 00    	je     800b44 <vprintfmt+0x538>
			putch(ch, putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	53                   	push   %ebx
  8009f3:	50                   	push   %eax
  8009f4:	ff d6                	call   *%esi
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	eb dc                	jmp    8009d7 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	8b 00                	mov    (%eax),%eax
  800a00:	ba 00 00 00 00       	mov    $0x0,%edx
  800a05:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a08:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8d 40 04             	lea    0x4(%eax),%eax
  800a11:	89 45 14             	mov    %eax,0x14(%ebp)
  800a14:	e9 7c ff ff ff       	jmp    800995 <vprintfmt+0x389>
			putch('0', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	53                   	push   %ebx
  800a1d:	6a 30                	push   $0x30
  800a1f:	ff d6                	call   *%esi
			putch('x', putdat);
  800a21:	83 c4 08             	add    $0x8,%esp
  800a24:	53                   	push   %ebx
  800a25:	6a 78                	push   $0x78
  800a27:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	8b 00                	mov    (%eax),%eax
  800a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a33:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a36:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a39:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	8d 40 04             	lea    0x4(%eax),%eax
  800a42:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a45:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a4a:	e9 56 ff ff ff       	jmp    8009a5 <vprintfmt+0x399>
	if (lflag >= 2)
  800a4f:	83 f9 01             	cmp    $0x1,%ecx
  800a52:	7f 27                	jg     800a7b <vprintfmt+0x46f>
	else if (lflag)
  800a54:	85 c9                	test   %ecx,%ecx
  800a56:	74 44                	je     800a9c <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
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
  800a76:	e9 2a ff ff ff       	jmp    8009a5 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8b 50 04             	mov    0x4(%eax),%edx
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a86:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a89:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8c:	8d 40 08             	lea    0x8(%eax),%eax
  800a8f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a92:	bf 10 00 00 00       	mov    $0x10,%edi
  800a97:	e9 09 ff ff ff       	jmp    8009a5 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	8d 40 04             	lea    0x4(%eax),%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab5:	bf 10 00 00 00       	mov    $0x10,%edi
  800aba:	e9 e6 fe ff ff       	jmp    8009a5 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	8d 78 04             	lea    0x4(%eax),%edi
  800ac5:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800ac7:	85 c0                	test   %eax,%eax
  800ac9:	74 2d                	je     800af8 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800acb:	0f b6 13             	movzbl (%ebx),%edx
  800ace:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ad0:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800ad3:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800ad6:	0f 8e f8 fe ff ff    	jle    8009d4 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800adc:	68 ac 13 80 00       	push   $0x8013ac
  800ae1:	68 5c 12 80 00       	push   $0x80125c
  800ae6:	53                   	push   %ebx
  800ae7:	56                   	push   %esi
  800ae8:	e8 02 fb ff ff       	call   8005ef <printfmt>
  800aed:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800af0:	89 7d 14             	mov    %edi,0x14(%ebp)
  800af3:	e9 dc fe ff ff       	jmp    8009d4 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800af8:	68 74 13 80 00       	push   $0x801374
  800afd:	68 5c 12 80 00       	push   $0x80125c
  800b02:	53                   	push   %ebx
  800b03:	56                   	push   %esi
  800b04:	e8 e6 fa ff ff       	call   8005ef <printfmt>
  800b09:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800b0c:	89 7d 14             	mov    %edi,0x14(%ebp)
  800b0f:	e9 c0 fe ff ff       	jmp    8009d4 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	53                   	push   %ebx
  800b18:	6a 25                	push   $0x25
  800b1a:	ff d6                	call   *%esi
			break;
  800b1c:	83 c4 10             	add    $0x10,%esp
  800b1f:	e9 b0 fe ff ff       	jmp    8009d4 <vprintfmt+0x3c8>
			putch('%', putdat);
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	53                   	push   %ebx
  800b28:	6a 25                	push   $0x25
  800b2a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b2c:	83 c4 10             	add    $0x10,%esp
  800b2f:	89 f8                	mov    %edi,%eax
  800b31:	eb 03                	jmp    800b36 <vprintfmt+0x52a>
  800b33:	83 e8 01             	sub    $0x1,%eax
  800b36:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b3a:	75 f7                	jne    800b33 <vprintfmt+0x527>
  800b3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b3f:	e9 90 fe ff ff       	jmp    8009d4 <vprintfmt+0x3c8>
}
  800b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 18             	sub    $0x18,%esp
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b5b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b5f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b69:	85 c0                	test   %eax,%eax
  800b6b:	74 26                	je     800b93 <vsnprintf+0x47>
  800b6d:	85 d2                	test   %edx,%edx
  800b6f:	7e 22                	jle    800b93 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b71:	ff 75 14             	pushl  0x14(%ebp)
  800b74:	ff 75 10             	pushl  0x10(%ebp)
  800b77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b7a:	50                   	push   %eax
  800b7b:	68 d2 05 80 00       	push   $0x8005d2
  800b80:	e8 87 fa ff ff       	call   80060c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
}
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    
		return -E_INVAL;
  800b93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b98:	eb f7                	jmp    800b91 <vsnprintf+0x45>

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ba3:	50                   	push   %eax
  800ba4:	ff 75 10             	pushl  0x10(%ebp)
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	ff 75 08             	pushl  0x8(%ebp)
  800bad:	e8 9a ff ff ff       	call   800b4c <vsnprintf>
	va_end(ap);

	return rc;
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bba:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bc3:	74 05                	je     800bca <strlen+0x16>
		n++;
  800bc5:	83 c0 01             	add    $0x1,%eax
  800bc8:	eb f5                	jmp    800bbf <strlen+0xb>
	return n;
}
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bda:	39 c2                	cmp    %eax,%edx
  800bdc:	74 0d                	je     800beb <strnlen+0x1f>
  800bde:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800be2:	74 05                	je     800be9 <strnlen+0x1d>
		n++;
  800be4:	83 c2 01             	add    $0x1,%edx
  800be7:	eb f1                	jmp    800bda <strnlen+0xe>
  800be9:	89 d0                	mov    %edx,%eax
	return n;
}
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	53                   	push   %ebx
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfc:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c00:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c03:	83 c2 01             	add    $0x1,%edx
  800c06:	84 c9                	test   %cl,%cl
  800c08:	75 f2                	jne    800bfc <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c0a:	5b                   	pop    %ebx
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	53                   	push   %ebx
  800c11:	83 ec 10             	sub    $0x10,%esp
  800c14:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c17:	53                   	push   %ebx
  800c18:	e8 97 ff ff ff       	call   800bb4 <strlen>
  800c1d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	01 d8                	add    %ebx,%eax
  800c25:	50                   	push   %eax
  800c26:	e8 c2 ff ff ff       	call   800bed <strcpy>
	return dst;
}
  800c2b:	89 d8                	mov    %ebx,%eax
  800c2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3d:	89 c6                	mov    %eax,%esi
  800c3f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c42:	89 c2                	mov    %eax,%edx
  800c44:	39 f2                	cmp    %esi,%edx
  800c46:	74 11                	je     800c59 <strncpy+0x27>
		*dst++ = *src;
  800c48:	83 c2 01             	add    $0x1,%edx
  800c4b:	0f b6 19             	movzbl (%ecx),%ebx
  800c4e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c51:	80 fb 01             	cmp    $0x1,%bl
  800c54:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c57:	eb eb                	jmp    800c44 <strncpy+0x12>
	}
	return ret;
}
  800c59:	5b                   	pop    %ebx
  800c5a:	5e                   	pop    %esi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    

00800c5d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	8b 75 08             	mov    0x8(%ebp),%esi
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	8b 55 10             	mov    0x10(%ebp),%edx
  800c6b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c6d:	85 d2                	test   %edx,%edx
  800c6f:	74 21                	je     800c92 <strlcpy+0x35>
  800c71:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c75:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c77:	39 c2                	cmp    %eax,%edx
  800c79:	74 14                	je     800c8f <strlcpy+0x32>
  800c7b:	0f b6 19             	movzbl (%ecx),%ebx
  800c7e:	84 db                	test   %bl,%bl
  800c80:	74 0b                	je     800c8d <strlcpy+0x30>
			*dst++ = *src++;
  800c82:	83 c1 01             	add    $0x1,%ecx
  800c85:	83 c2 01             	add    $0x1,%edx
  800c88:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c8b:	eb ea                	jmp    800c77 <strlcpy+0x1a>
  800c8d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c8f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c92:	29 f0                	sub    %esi,%eax
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ca1:	0f b6 01             	movzbl (%ecx),%eax
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 0c                	je     800cb4 <strcmp+0x1c>
  800ca8:	3a 02                	cmp    (%edx),%al
  800caa:	75 08                	jne    800cb4 <strcmp+0x1c>
		p++, q++;
  800cac:	83 c1 01             	add    $0x1,%ecx
  800caf:	83 c2 01             	add    $0x1,%edx
  800cb2:	eb ed                	jmp    800ca1 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb4:	0f b6 c0             	movzbl %al,%eax
  800cb7:	0f b6 12             	movzbl (%edx),%edx
  800cba:	29 d0                	sub    %edx,%eax
}
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	53                   	push   %ebx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc8:	89 c3                	mov    %eax,%ebx
  800cca:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ccd:	eb 06                	jmp    800cd5 <strncmp+0x17>
		n--, p++, q++;
  800ccf:	83 c0 01             	add    $0x1,%eax
  800cd2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cd5:	39 d8                	cmp    %ebx,%eax
  800cd7:	74 16                	je     800cef <strncmp+0x31>
  800cd9:	0f b6 08             	movzbl (%eax),%ecx
  800cdc:	84 c9                	test   %cl,%cl
  800cde:	74 04                	je     800ce4 <strncmp+0x26>
  800ce0:	3a 0a                	cmp    (%edx),%cl
  800ce2:	74 eb                	je     800ccf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce4:	0f b6 00             	movzbl (%eax),%eax
  800ce7:	0f b6 12             	movzbl (%edx),%edx
  800cea:	29 d0                	sub    %edx,%eax
}
  800cec:	5b                   	pop    %ebx
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    
		return 0;
  800cef:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf4:	eb f6                	jmp    800cec <strncmp+0x2e>

00800cf6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d00:	0f b6 10             	movzbl (%eax),%edx
  800d03:	84 d2                	test   %dl,%dl
  800d05:	74 09                	je     800d10 <strchr+0x1a>
		if (*s == c)
  800d07:	38 ca                	cmp    %cl,%dl
  800d09:	74 0a                	je     800d15 <strchr+0x1f>
	for (; *s; s++)
  800d0b:	83 c0 01             	add    $0x1,%eax
  800d0e:	eb f0                	jmp    800d00 <strchr+0xa>
			return (char *) s;
	return 0;
  800d10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d21:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d24:	38 ca                	cmp    %cl,%dl
  800d26:	74 09                	je     800d31 <strfind+0x1a>
  800d28:	84 d2                	test   %dl,%dl
  800d2a:	74 05                	je     800d31 <strfind+0x1a>
	for (; *s; s++)
  800d2c:	83 c0 01             	add    $0x1,%eax
  800d2f:	eb f0                	jmp    800d21 <strfind+0xa>
			break;
	return (char *) s;
}
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d3f:	85 c9                	test   %ecx,%ecx
  800d41:	74 31                	je     800d74 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d43:	89 f8                	mov    %edi,%eax
  800d45:	09 c8                	or     %ecx,%eax
  800d47:	a8 03                	test   $0x3,%al
  800d49:	75 23                	jne    800d6e <memset+0x3b>
		c &= 0xFF;
  800d4b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d4f:	89 d3                	mov    %edx,%ebx
  800d51:	c1 e3 08             	shl    $0x8,%ebx
  800d54:	89 d0                	mov    %edx,%eax
  800d56:	c1 e0 18             	shl    $0x18,%eax
  800d59:	89 d6                	mov    %edx,%esi
  800d5b:	c1 e6 10             	shl    $0x10,%esi
  800d5e:	09 f0                	or     %esi,%eax
  800d60:	09 c2                	or     %eax,%edx
  800d62:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d64:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d67:	89 d0                	mov    %edx,%eax
  800d69:	fc                   	cld    
  800d6a:	f3 ab                	rep stos %eax,%es:(%edi)
  800d6c:	eb 06                	jmp    800d74 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	fc                   	cld    
  800d72:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d74:	89 f8                	mov    %edi,%eax
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d89:	39 c6                	cmp    %eax,%esi
  800d8b:	73 32                	jae    800dbf <memmove+0x44>
  800d8d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d90:	39 c2                	cmp    %eax,%edx
  800d92:	76 2b                	jbe    800dbf <memmove+0x44>
		s += n;
		d += n;
  800d94:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d97:	89 fe                	mov    %edi,%esi
  800d99:	09 ce                	or     %ecx,%esi
  800d9b:	09 d6                	or     %edx,%esi
  800d9d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800da3:	75 0e                	jne    800db3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800da5:	83 ef 04             	sub    $0x4,%edi
  800da8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dab:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dae:	fd                   	std    
  800daf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800db1:	eb 09                	jmp    800dbc <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800db3:	83 ef 01             	sub    $0x1,%edi
  800db6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800db9:	fd                   	std    
  800dba:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dbc:	fc                   	cld    
  800dbd:	eb 1a                	jmp    800dd9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dbf:	89 c2                	mov    %eax,%edx
  800dc1:	09 ca                	or     %ecx,%edx
  800dc3:	09 f2                	or     %esi,%edx
  800dc5:	f6 c2 03             	test   $0x3,%dl
  800dc8:	75 0a                	jne    800dd4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dca:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dcd:	89 c7                	mov    %eax,%edi
  800dcf:	fc                   	cld    
  800dd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dd2:	eb 05                	jmp    800dd9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800dd4:	89 c7                	mov    %eax,%edi
  800dd6:	fc                   	cld    
  800dd7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800de3:	ff 75 10             	pushl  0x10(%ebp)
  800de6:	ff 75 0c             	pushl  0xc(%ebp)
  800de9:	ff 75 08             	pushl  0x8(%ebp)
  800dec:	e8 8a ff ff ff       	call   800d7b <memmove>
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfe:	89 c6                	mov    %eax,%esi
  800e00:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e03:	39 f0                	cmp    %esi,%eax
  800e05:	74 1c                	je     800e23 <memcmp+0x30>
		if (*s1 != *s2)
  800e07:	0f b6 08             	movzbl (%eax),%ecx
  800e0a:	0f b6 1a             	movzbl (%edx),%ebx
  800e0d:	38 d9                	cmp    %bl,%cl
  800e0f:	75 08                	jne    800e19 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e11:	83 c0 01             	add    $0x1,%eax
  800e14:	83 c2 01             	add    $0x1,%edx
  800e17:	eb ea                	jmp    800e03 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e19:	0f b6 c1             	movzbl %cl,%eax
  800e1c:	0f b6 db             	movzbl %bl,%ebx
  800e1f:	29 d8                	sub    %ebx,%eax
  800e21:	eb 05                	jmp    800e28 <memcmp+0x35>
	}

	return 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e35:	89 c2                	mov    %eax,%edx
  800e37:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e3a:	39 d0                	cmp    %edx,%eax
  800e3c:	73 09                	jae    800e47 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e3e:	38 08                	cmp    %cl,(%eax)
  800e40:	74 05                	je     800e47 <memfind+0x1b>
	for (; s < ends; s++)
  800e42:	83 c0 01             	add    $0x1,%eax
  800e45:	eb f3                	jmp    800e3a <memfind+0xe>
			break;
	return (void *) s;
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	eb 03                	jmp    800e5a <strtol+0x11>
		s++;
  800e57:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e5a:	0f b6 01             	movzbl (%ecx),%eax
  800e5d:	3c 20                	cmp    $0x20,%al
  800e5f:	74 f6                	je     800e57 <strtol+0xe>
  800e61:	3c 09                	cmp    $0x9,%al
  800e63:	74 f2                	je     800e57 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e65:	3c 2b                	cmp    $0x2b,%al
  800e67:	74 2a                	je     800e93 <strtol+0x4a>
	int neg = 0;
  800e69:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e6e:	3c 2d                	cmp    $0x2d,%al
  800e70:	74 2b                	je     800e9d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e72:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e78:	75 0f                	jne    800e89 <strtol+0x40>
  800e7a:	80 39 30             	cmpb   $0x30,(%ecx)
  800e7d:	74 28                	je     800ea7 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e7f:	85 db                	test   %ebx,%ebx
  800e81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e86:	0f 44 d8             	cmove  %eax,%ebx
  800e89:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e91:	eb 50                	jmp    800ee3 <strtol+0x9a>
		s++;
  800e93:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e96:	bf 00 00 00 00       	mov    $0x0,%edi
  800e9b:	eb d5                	jmp    800e72 <strtol+0x29>
		s++, neg = 1;
  800e9d:	83 c1 01             	add    $0x1,%ecx
  800ea0:	bf 01 00 00 00       	mov    $0x1,%edi
  800ea5:	eb cb                	jmp    800e72 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eab:	74 0e                	je     800ebb <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ead:	85 db                	test   %ebx,%ebx
  800eaf:	75 d8                	jne    800e89 <strtol+0x40>
		s++, base = 8;
  800eb1:	83 c1 01             	add    $0x1,%ecx
  800eb4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800eb9:	eb ce                	jmp    800e89 <strtol+0x40>
		s += 2, base = 16;
  800ebb:	83 c1 02             	add    $0x2,%ecx
  800ebe:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ec3:	eb c4                	jmp    800e89 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ec5:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ec8:	89 f3                	mov    %esi,%ebx
  800eca:	80 fb 19             	cmp    $0x19,%bl
  800ecd:	77 29                	ja     800ef8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ecf:	0f be d2             	movsbl %dl,%edx
  800ed2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ed5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ed8:	7d 30                	jge    800f0a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800eda:	83 c1 01             	add    $0x1,%ecx
  800edd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ee3:	0f b6 11             	movzbl (%ecx),%edx
  800ee6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ee9:	89 f3                	mov    %esi,%ebx
  800eeb:	80 fb 09             	cmp    $0x9,%bl
  800eee:	77 d5                	ja     800ec5 <strtol+0x7c>
			dig = *s - '0';
  800ef0:	0f be d2             	movsbl %dl,%edx
  800ef3:	83 ea 30             	sub    $0x30,%edx
  800ef6:	eb dd                	jmp    800ed5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ef8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800efb:	89 f3                	mov    %esi,%ebx
  800efd:	80 fb 19             	cmp    $0x19,%bl
  800f00:	77 08                	ja     800f0a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f02:	0f be d2             	movsbl %dl,%edx
  800f05:	83 ea 37             	sub    $0x37,%edx
  800f08:	eb cb                	jmp    800ed5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0e:	74 05                	je     800f15 <strtol+0xcc>
		*endptr = (char *) s;
  800f10:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f13:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f15:	89 c2                	mov    %eax,%edx
  800f17:	f7 da                	neg    %edx
  800f19:	85 ff                	test   %edi,%edi
  800f1b:	0f 45 c2             	cmovne %edx,%eax
}
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f29:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800f30:	74 0a                	je     800f3c <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  800f3c:	83 ec 04             	sub    $0x4,%esp
  800f3f:	6a 07                	push   $0x7
  800f41:	68 00 f0 bf ee       	push   $0xeebff000
  800f46:	6a 00                	push   $0x0
  800f48:	e8 1e f2 ff ff       	call   80016b <sys_page_alloc>
  800f4d:	83 c4 10             	add    $0x10,%esp
  800f50:	85 c0                	test   %eax,%eax
  800f52:	78 28                	js     800f7c <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	68 de 03 80 00       	push   $0x8003de
  800f5c:	6a 00                	push   $0x0
  800f5e:	e8 94 f3 ff ff       	call   8002f7 <sys_env_set_pgfault_upcall>
  800f63:	83 c4 10             	add    $0x10,%esp
  800f66:	85 c0                	test   %eax,%eax
  800f68:	79 c8                	jns    800f32 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  800f6a:	50                   	push   %eax
  800f6b:	68 e8 15 80 00       	push   $0x8015e8
  800f70:	6a 23                	push   $0x23
  800f72:	68 d8 15 80 00       	push   $0x8015d8
  800f77:	e8 88 f4 ff ff       	call   800404 <_panic>
			panic("set_pgfault_handler %e\n",r);
  800f7c:	50                   	push   %eax
  800f7d:	68 c0 15 80 00       	push   $0x8015c0
  800f82:	6a 21                	push   $0x21
  800f84:	68 d8 15 80 00       	push   $0x8015d8
  800f89:	e8 76 f4 ff ff       	call   800404 <_panic>
  800f8e:	66 90                	xchg   %ax,%ax

00800f90 <__udivdi3>:
  800f90:	55                   	push   %ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 1c             	sub    $0x1c,%esp
  800f97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fa3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fa7:	85 d2                	test   %edx,%edx
  800fa9:	75 4d                	jne    800ff8 <__udivdi3+0x68>
  800fab:	39 f3                	cmp    %esi,%ebx
  800fad:	76 19                	jbe    800fc8 <__udivdi3+0x38>
  800faf:	31 ff                	xor    %edi,%edi
  800fb1:	89 e8                	mov    %ebp,%eax
  800fb3:	89 f2                	mov    %esi,%edx
  800fb5:	f7 f3                	div    %ebx
  800fb7:	89 fa                	mov    %edi,%edx
  800fb9:	83 c4 1c             	add    $0x1c,%esp
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    
  800fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	89 d9                	mov    %ebx,%ecx
  800fca:	85 db                	test   %ebx,%ebx
  800fcc:	75 0b                	jne    800fd9 <__udivdi3+0x49>
  800fce:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd3:	31 d2                	xor    %edx,%edx
  800fd5:	f7 f3                	div    %ebx
  800fd7:	89 c1                	mov    %eax,%ecx
  800fd9:	31 d2                	xor    %edx,%edx
  800fdb:	89 f0                	mov    %esi,%eax
  800fdd:	f7 f1                	div    %ecx
  800fdf:	89 c6                	mov    %eax,%esi
  800fe1:	89 e8                	mov    %ebp,%eax
  800fe3:	89 f7                	mov    %esi,%edi
  800fe5:	f7 f1                	div    %ecx
  800fe7:	89 fa                	mov    %edi,%edx
  800fe9:	83 c4 1c             	add    $0x1c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	39 f2                	cmp    %esi,%edx
  800ffa:	77 1c                	ja     801018 <__udivdi3+0x88>
  800ffc:	0f bd fa             	bsr    %edx,%edi
  800fff:	83 f7 1f             	xor    $0x1f,%edi
  801002:	75 2c                	jne    801030 <__udivdi3+0xa0>
  801004:	39 f2                	cmp    %esi,%edx
  801006:	72 06                	jb     80100e <__udivdi3+0x7e>
  801008:	31 c0                	xor    %eax,%eax
  80100a:	39 eb                	cmp    %ebp,%ebx
  80100c:	77 a9                	ja     800fb7 <__udivdi3+0x27>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	eb a2                	jmp    800fb7 <__udivdi3+0x27>
  801015:	8d 76 00             	lea    0x0(%esi),%esi
  801018:	31 ff                	xor    %edi,%edi
  80101a:	31 c0                	xor    %eax,%eax
  80101c:	89 fa                	mov    %edi,%edx
  80101e:	83 c4 1c             	add    $0x1c,%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
  801026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80102d:	8d 76 00             	lea    0x0(%esi),%esi
  801030:	89 f9                	mov    %edi,%ecx
  801032:	b8 20 00 00 00       	mov    $0x20,%eax
  801037:	29 f8                	sub    %edi,%eax
  801039:	d3 e2                	shl    %cl,%edx
  80103b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80103f:	89 c1                	mov    %eax,%ecx
  801041:	89 da                	mov    %ebx,%edx
  801043:	d3 ea                	shr    %cl,%edx
  801045:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801049:	09 d1                	or     %edx,%ecx
  80104b:	89 f2                	mov    %esi,%edx
  80104d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801051:	89 f9                	mov    %edi,%ecx
  801053:	d3 e3                	shl    %cl,%ebx
  801055:	89 c1                	mov    %eax,%ecx
  801057:	d3 ea                	shr    %cl,%edx
  801059:	89 f9                	mov    %edi,%ecx
  80105b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80105f:	89 eb                	mov    %ebp,%ebx
  801061:	d3 e6                	shl    %cl,%esi
  801063:	89 c1                	mov    %eax,%ecx
  801065:	d3 eb                	shr    %cl,%ebx
  801067:	09 de                	or     %ebx,%esi
  801069:	89 f0                	mov    %esi,%eax
  80106b:	f7 74 24 08          	divl   0x8(%esp)
  80106f:	89 d6                	mov    %edx,%esi
  801071:	89 c3                	mov    %eax,%ebx
  801073:	f7 64 24 0c          	mull   0xc(%esp)
  801077:	39 d6                	cmp    %edx,%esi
  801079:	72 15                	jb     801090 <__udivdi3+0x100>
  80107b:	89 f9                	mov    %edi,%ecx
  80107d:	d3 e5                	shl    %cl,%ebp
  80107f:	39 c5                	cmp    %eax,%ebp
  801081:	73 04                	jae    801087 <__udivdi3+0xf7>
  801083:	39 d6                	cmp    %edx,%esi
  801085:	74 09                	je     801090 <__udivdi3+0x100>
  801087:	89 d8                	mov    %ebx,%eax
  801089:	31 ff                	xor    %edi,%edi
  80108b:	e9 27 ff ff ff       	jmp    800fb7 <__udivdi3+0x27>
  801090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801093:	31 ff                	xor    %edi,%edi
  801095:	e9 1d ff ff ff       	jmp    800fb7 <__udivdi3+0x27>
  80109a:	66 90                	xchg   %ax,%ax
  80109c:	66 90                	xchg   %ax,%ax
  80109e:	66 90                	xchg   %ax,%ax

008010a0 <__umoddi3>:
  8010a0:	55                   	push   %ebp
  8010a1:	57                   	push   %edi
  8010a2:	56                   	push   %esi
  8010a3:	53                   	push   %ebx
  8010a4:	83 ec 1c             	sub    $0x1c,%esp
  8010a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010b7:	89 da                	mov    %ebx,%edx
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	75 43                	jne    801100 <__umoddi3+0x60>
  8010bd:	39 df                	cmp    %ebx,%edi
  8010bf:	76 17                	jbe    8010d8 <__umoddi3+0x38>
  8010c1:	89 f0                	mov    %esi,%eax
  8010c3:	f7 f7                	div    %edi
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	31 d2                	xor    %edx,%edx
  8010c9:	83 c4 1c             	add    $0x1c,%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    
  8010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d8:	89 fd                	mov    %edi,%ebp
  8010da:	85 ff                	test   %edi,%edi
  8010dc:	75 0b                	jne    8010e9 <__umoddi3+0x49>
  8010de:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e3:	31 d2                	xor    %edx,%edx
  8010e5:	f7 f7                	div    %edi
  8010e7:	89 c5                	mov    %eax,%ebp
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	31 d2                	xor    %edx,%edx
  8010ed:	f7 f5                	div    %ebp
  8010ef:	89 f0                	mov    %esi,%eax
  8010f1:	f7 f5                	div    %ebp
  8010f3:	89 d0                	mov    %edx,%eax
  8010f5:	eb d0                	jmp    8010c7 <__umoddi3+0x27>
  8010f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010fe:	66 90                	xchg   %ax,%ax
  801100:	89 f1                	mov    %esi,%ecx
  801102:	39 d8                	cmp    %ebx,%eax
  801104:	76 0a                	jbe    801110 <__umoddi3+0x70>
  801106:	89 f0                	mov    %esi,%eax
  801108:	83 c4 1c             	add    $0x1c,%esp
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5f                   	pop    %edi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    
  801110:	0f bd e8             	bsr    %eax,%ebp
  801113:	83 f5 1f             	xor    $0x1f,%ebp
  801116:	75 20                	jne    801138 <__umoddi3+0x98>
  801118:	39 d8                	cmp    %ebx,%eax
  80111a:	0f 82 b0 00 00 00    	jb     8011d0 <__umoddi3+0x130>
  801120:	39 f7                	cmp    %esi,%edi
  801122:	0f 86 a8 00 00 00    	jbe    8011d0 <__umoddi3+0x130>
  801128:	89 c8                	mov    %ecx,%eax
  80112a:	83 c4 1c             	add    $0x1c,%esp
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    
  801132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801138:	89 e9                	mov    %ebp,%ecx
  80113a:	ba 20 00 00 00       	mov    $0x20,%edx
  80113f:	29 ea                	sub    %ebp,%edx
  801141:	d3 e0                	shl    %cl,%eax
  801143:	89 44 24 08          	mov    %eax,0x8(%esp)
  801147:	89 d1                	mov    %edx,%ecx
  801149:	89 f8                	mov    %edi,%eax
  80114b:	d3 e8                	shr    %cl,%eax
  80114d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801151:	89 54 24 04          	mov    %edx,0x4(%esp)
  801155:	8b 54 24 04          	mov    0x4(%esp),%edx
  801159:	09 c1                	or     %eax,%ecx
  80115b:	89 d8                	mov    %ebx,%eax
  80115d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801161:	89 e9                	mov    %ebp,%ecx
  801163:	d3 e7                	shl    %cl,%edi
  801165:	89 d1                	mov    %edx,%ecx
  801167:	d3 e8                	shr    %cl,%eax
  801169:	89 e9                	mov    %ebp,%ecx
  80116b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80116f:	d3 e3                	shl    %cl,%ebx
  801171:	89 c7                	mov    %eax,%edi
  801173:	89 d1                	mov    %edx,%ecx
  801175:	89 f0                	mov    %esi,%eax
  801177:	d3 e8                	shr    %cl,%eax
  801179:	89 e9                	mov    %ebp,%ecx
  80117b:	89 fa                	mov    %edi,%edx
  80117d:	d3 e6                	shl    %cl,%esi
  80117f:	09 d8                	or     %ebx,%eax
  801181:	f7 74 24 08          	divl   0x8(%esp)
  801185:	89 d1                	mov    %edx,%ecx
  801187:	89 f3                	mov    %esi,%ebx
  801189:	f7 64 24 0c          	mull   0xc(%esp)
  80118d:	89 c6                	mov    %eax,%esi
  80118f:	89 d7                	mov    %edx,%edi
  801191:	39 d1                	cmp    %edx,%ecx
  801193:	72 06                	jb     80119b <__umoddi3+0xfb>
  801195:	75 10                	jne    8011a7 <__umoddi3+0x107>
  801197:	39 c3                	cmp    %eax,%ebx
  801199:	73 0c                	jae    8011a7 <__umoddi3+0x107>
  80119b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80119f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011a3:	89 d7                	mov    %edx,%edi
  8011a5:	89 c6                	mov    %eax,%esi
  8011a7:	89 ca                	mov    %ecx,%edx
  8011a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011ae:	29 f3                	sub    %esi,%ebx
  8011b0:	19 fa                	sbb    %edi,%edx
  8011b2:	89 d0                	mov    %edx,%eax
  8011b4:	d3 e0                	shl    %cl,%eax
  8011b6:	89 e9                	mov    %ebp,%ecx
  8011b8:	d3 eb                	shr    %cl,%ebx
  8011ba:	d3 ea                	shr    %cl,%edx
  8011bc:	09 d8                	or     %ebx,%eax
  8011be:	83 c4 1c             	add    $0x1c,%esp
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    
  8011c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011cd:	8d 76 00             	lea    0x0(%esi),%esi
  8011d0:	89 da                	mov    %ebx,%edx
  8011d2:	29 fe                	sub    %edi,%esi
  8011d4:	19 c2                	sbb    %eax,%edx
  8011d6:	89 f1                	mov    %esi,%ecx
  8011d8:	89 c8                	mov    %ecx,%eax
  8011da:	e9 4b ff ff ff       	jmp    80112a <__umoddi3+0x8a>
