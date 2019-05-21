
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800040:	e8 c9 00 00 00       	call   80010e <sys_getenvid>
  800045:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004a:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80004d:	c1 e0 04             	shl    $0x4,%eax
  800050:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800055:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005a:	85 db                	test   %ebx,%ebx
  80005c:	7e 07                	jle    800065 <libmain+0x30>
		binaryname = argv[0];
  80005e:	8b 06                	mov    (%esi),%eax
  800060:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800065:	83 ec 08             	sub    $0x8,%esp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	e8 c4 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006f:	e8 0a 00 00 00       	call   80007e <exit>
}
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007a:	5b                   	pop    %ebx
  80007b:	5e                   	pop    %esi
  80007c:	5d                   	pop    %ebp
  80007d:	c3                   	ret    

0080007e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800084:	6a 00                	push   $0x0
  800086:	e8 42 00 00 00       	call   8000cd <sys_env_destroy>
}
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	c9                   	leave  
  80008f:	c3                   	ret    

00800090 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	57                   	push   %edi
  800094:	56                   	push   %esi
  800095:	53                   	push   %ebx
	asm volatile("int %1\n"
  800096:	b8 00 00 00 00       	mov    $0x0,%eax
  80009b:	8b 55 08             	mov    0x8(%ebp),%edx
  80009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a1:	89 c3                	mov    %eax,%ebx
  8000a3:	89 c7                	mov    %eax,%edi
  8000a5:	89 c6                	mov    %eax,%esi
  8000a7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000a9:	5b                   	pop    %ebx
  8000aa:	5e                   	pop    %esi
  8000ab:	5f                   	pop    %edi
  8000ac:	5d                   	pop    %ebp
  8000ad:	c3                   	ret    

008000ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8000be:	89 d1                	mov    %edx,%ecx
  8000c0:	89 d3                	mov    %edx,%ebx
  8000c2:	89 d7                	mov    %edx,%edi
  8000c4:	89 d6                	mov    %edx,%esi
  8000c6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5f                   	pop    %edi
  8000cb:	5d                   	pop    %ebp
  8000cc:	c3                   	ret    

008000cd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	57                   	push   %edi
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000db:	8b 55 08             	mov    0x8(%ebp),%edx
  8000de:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e3:	89 cb                	mov    %ecx,%ebx
  8000e5:	89 cf                	mov    %ecx,%edi
  8000e7:	89 ce                	mov    %ecx,%esi
  8000e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000eb:	85 c0                	test   %eax,%eax
  8000ed:	7f 08                	jg     8000f7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f2:	5b                   	pop    %ebx
  8000f3:	5e                   	pop    %esi
  8000f4:	5f                   	pop    %edi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f7:	83 ec 0c             	sub    $0xc,%esp
  8000fa:	50                   	push   %eax
  8000fb:	6a 03                	push   $0x3
  8000fd:	68 4a 11 80 00       	push   $0x80114a
  800102:	6a 33                	push   $0x33
  800104:	68 67 11 80 00       	push   $0x801167
  800109:	e8 b1 02 00 00       	call   8003bf <_panic>

0080010e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	57                   	push   %edi
  800112:	56                   	push   %esi
  800113:	53                   	push   %ebx
	asm volatile("int %1\n"
  800114:	ba 00 00 00 00       	mov    $0x0,%edx
  800119:	b8 02 00 00 00       	mov    $0x2,%eax
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	89 d3                	mov    %edx,%ebx
  800122:	89 d7                	mov    %edx,%edi
  800124:	89 d6                	mov    %edx,%esi
  800126:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5f                   	pop    %edi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    

0080012d <sys_yield>:

void
sys_yield(void)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	57                   	push   %edi
  800131:	56                   	push   %esi
  800132:	53                   	push   %ebx
	asm volatile("int %1\n"
  800133:	ba 00 00 00 00       	mov    $0x0,%edx
  800138:	b8 0c 00 00 00       	mov    $0xc,%eax
  80013d:	89 d1                	mov    %edx,%ecx
  80013f:	89 d3                	mov    %edx,%ebx
  800141:	89 d7                	mov    %edx,%edi
  800143:	89 d6                	mov    %edx,%esi
  800145:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800147:	5b                   	pop    %ebx
  800148:	5e                   	pop    %esi
  800149:	5f                   	pop    %edi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	57                   	push   %edi
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
  800152:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800155:	be 00 00 00 00       	mov    $0x0,%esi
  80015a:	8b 55 08             	mov    0x8(%ebp),%edx
  80015d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800160:	b8 04 00 00 00       	mov    $0x4,%eax
  800165:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800168:	89 f7                	mov    %esi,%edi
  80016a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80016c:	85 c0                	test   %eax,%eax
  80016e:	7f 08                	jg     800178 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800170:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5f                   	pop    %edi
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	50                   	push   %eax
  80017c:	6a 04                	push   $0x4
  80017e:	68 4a 11 80 00       	push   $0x80114a
  800183:	6a 33                	push   $0x33
  800185:	68 67 11 80 00       	push   $0x801167
  80018a:	e8 30 02 00 00       	call   8003bf <_panic>

0080018f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	57                   	push   %edi
  800193:	56                   	push   %esi
  800194:	53                   	push   %ebx
  800195:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800198:	8b 55 08             	mov    0x8(%ebp),%edx
  80019b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019e:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	7f 08                	jg     8001ba <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b5:	5b                   	pop    %ebx
  8001b6:	5e                   	pop    %esi
  8001b7:	5f                   	pop    %edi
  8001b8:	5d                   	pop    %ebp
  8001b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	6a 05                	push   $0x5
  8001c0:	68 4a 11 80 00       	push   $0x80114a
  8001c5:	6a 33                	push   $0x33
  8001c7:	68 67 11 80 00       	push   $0x801167
  8001cc:	e8 ee 01 00 00       	call   8003bf <_panic>

008001d1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	57                   	push   %edi
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001df:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e5:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ea:	89 df                	mov    %ebx,%edi
  8001ec:	89 de                	mov    %ebx,%esi
  8001ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	7f 08                	jg     8001fc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5e                   	pop    %esi
  8001f9:	5f                   	pop    %edi
  8001fa:	5d                   	pop    %ebp
  8001fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	50                   	push   %eax
  800200:	6a 06                	push   $0x6
  800202:	68 4a 11 80 00       	push   $0x80114a
  800207:	6a 33                	push   $0x33
  800209:	68 67 11 80 00       	push   $0x801167
  80020e:	e8 ac 01 00 00       	call   8003bf <_panic>

00800213 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	57                   	push   %edi
  800217:	56                   	push   %esi
  800218:	53                   	push   %ebx
  800219:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800221:	8b 55 08             	mov    0x8(%ebp),%edx
  800224:	b8 0b 00 00 00       	mov    $0xb,%eax
  800229:	89 cb                	mov    %ecx,%ebx
  80022b:	89 cf                	mov    %ecx,%edi
  80022d:	89 ce                	mov    %ecx,%esi
  80022f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800231:	85 c0                	test   %eax,%eax
  800233:	7f 08                	jg     80023d <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800235:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800238:	5b                   	pop    %ebx
  800239:	5e                   	pop    %esi
  80023a:	5f                   	pop    %edi
  80023b:	5d                   	pop    %ebp
  80023c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	50                   	push   %eax
  800241:	6a 0b                	push   $0xb
  800243:	68 4a 11 80 00       	push   $0x80114a
  800248:	6a 33                	push   $0x33
  80024a:	68 67 11 80 00       	push   $0x801167
  80024f:	e8 6b 01 00 00       	call   8003bf <_panic>

00800254 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	57                   	push   %edi
  800258:	56                   	push   %esi
  800259:	53                   	push   %ebx
  80025a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800262:	8b 55 08             	mov    0x8(%ebp),%edx
  800265:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800268:	b8 08 00 00 00       	mov    $0x8,%eax
  80026d:	89 df                	mov    %ebx,%edi
  80026f:	89 de                	mov    %ebx,%esi
  800271:	cd 30                	int    $0x30
	if(check && ret > 0)
  800273:	85 c0                	test   %eax,%eax
  800275:	7f 08                	jg     80027f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5e                   	pop    %esi
  80027c:	5f                   	pop    %edi
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	50                   	push   %eax
  800283:	6a 08                	push   $0x8
  800285:	68 4a 11 80 00       	push   $0x80114a
  80028a:	6a 33                	push   $0x33
  80028c:	68 67 11 80 00       	push   $0x801167
  800291:	e8 29 01 00 00       	call   8003bf <_panic>

00800296 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	57                   	push   %edi
  80029a:	56                   	push   %esi
  80029b:	53                   	push   %ebx
  80029c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80029f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002aa:	b8 09 00 00 00       	mov    $0x9,%eax
  8002af:	89 df                	mov    %ebx,%edi
  8002b1:	89 de                	mov    %ebx,%esi
  8002b3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b5:	85 c0                	test   %eax,%eax
  8002b7:	7f 08                	jg     8002c1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bc:	5b                   	pop    %ebx
  8002bd:	5e                   	pop    %esi
  8002be:	5f                   	pop    %edi
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	50                   	push   %eax
  8002c5:	6a 09                	push   $0x9
  8002c7:	68 4a 11 80 00       	push   $0x80114a
  8002cc:	6a 33                	push   $0x33
  8002ce:	68 67 11 80 00       	push   $0x801167
  8002d3:	e8 e7 00 00 00       	call   8003bf <_panic>

008002d8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002f1:	89 df                	mov    %ebx,%edi
  8002f3:	89 de                	mov    %ebx,%esi
  8002f5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f7:	85 c0                	test   %eax,%eax
  8002f9:	7f 08                	jg     800303 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fe:	5b                   	pop    %ebx
  8002ff:	5e                   	pop    %esi
  800300:	5f                   	pop    %edi
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800303:	83 ec 0c             	sub    $0xc,%esp
  800306:	50                   	push   %eax
  800307:	6a 0a                	push   $0xa
  800309:	68 4a 11 80 00       	push   $0x80114a
  80030e:	6a 33                	push   $0x33
  800310:	68 67 11 80 00       	push   $0x801167
  800315:	e8 a5 00 00 00       	call   8003bf <_panic>

0080031a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800320:	8b 55 08             	mov    0x8(%ebp),%edx
  800323:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800326:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032b:	be 00 00 00 00       	mov    $0x0,%esi
  800330:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800333:	8b 7d 14             	mov    0x14(%ebp),%edi
  800336:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800338:	5b                   	pop    %ebx
  800339:	5e                   	pop    %esi
  80033a:	5f                   	pop    %edi
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    

0080033d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
  800343:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800346:	b9 00 00 00 00       	mov    $0x0,%ecx
  80034b:	8b 55 08             	mov    0x8(%ebp),%edx
  80034e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800353:	89 cb                	mov    %ecx,%ebx
  800355:	89 cf                	mov    %ecx,%edi
  800357:	89 ce                	mov    %ecx,%esi
  800359:	cd 30                	int    $0x30
	if(check && ret > 0)
  80035b:	85 c0                	test   %eax,%eax
  80035d:	7f 08                	jg     800367 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800362:	5b                   	pop    %ebx
  800363:	5e                   	pop    %esi
  800364:	5f                   	pop    %edi
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	50                   	push   %eax
  80036b:	6a 0e                	push   $0xe
  80036d:	68 4a 11 80 00       	push   $0x80114a
  800372:	6a 33                	push   $0x33
  800374:	68 67 11 80 00       	push   $0x801167
  800379:	e8 41 00 00 00       	call   8003bf <_panic>

0080037e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	57                   	push   %edi
  800382:	56                   	push   %esi
  800383:	53                   	push   %ebx
	asm volatile("int %1\n"
  800384:	bb 00 00 00 00       	mov    $0x0,%ebx
  800389:	8b 55 08             	mov    0x8(%ebp),%edx
  80038c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80038f:	b8 0f 00 00 00       	mov    $0xf,%eax
  800394:	89 df                	mov    %ebx,%edi
  800396:	89 de                	mov    %ebx,%esi
  800398:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80039a:	5b                   	pop    %ebx
  80039b:	5e                   	pop    %esi
  80039c:	5f                   	pop    %edi
  80039d:	5d                   	pop    %ebp
  80039e:	c3                   	ret    

0080039f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	57                   	push   %edi
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ad:	b8 10 00 00 00       	mov    $0x10,%eax
  8003b2:	89 cb                	mov    %ecx,%ebx
  8003b4:	89 cf                	mov    %ecx,%edi
  8003b6:	89 ce                	mov    %ecx,%esi
  8003b8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	56                   	push   %esi
  8003c3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003c4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003c7:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003cd:	e8 3c fd ff ff       	call   80010e <sys_getenvid>
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	ff 75 0c             	pushl  0xc(%ebp)
  8003d8:	ff 75 08             	pushl  0x8(%ebp)
  8003db:	56                   	push   %esi
  8003dc:	50                   	push   %eax
  8003dd:	68 78 11 80 00       	push   $0x801178
  8003e2:	e8 b3 00 00 00       	call   80049a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003e7:	83 c4 18             	add    $0x18,%esp
  8003ea:	53                   	push   %ebx
  8003eb:	ff 75 10             	pushl  0x10(%ebp)
  8003ee:	e8 56 00 00 00       	call   800449 <vcprintf>
	cprintf("\n");
  8003f3:	c7 04 24 9b 11 80 00 	movl   $0x80119b,(%esp)
  8003fa:	e8 9b 00 00 00       	call   80049a <cprintf>
  8003ff:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800402:	cc                   	int3   
  800403:	eb fd                	jmp    800402 <_panic+0x43>

00800405 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	53                   	push   %ebx
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80040f:	8b 13                	mov    (%ebx),%edx
  800411:	8d 42 01             	lea    0x1(%edx),%eax
  800414:	89 03                	mov    %eax,(%ebx)
  800416:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800419:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80041d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800422:	74 09                	je     80042d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800424:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	68 ff 00 00 00       	push   $0xff
  800435:	8d 43 08             	lea    0x8(%ebx),%eax
  800438:	50                   	push   %eax
  800439:	e8 52 fc ff ff       	call   800090 <sys_cputs>
		b->idx = 0;
  80043e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	eb db                	jmp    800424 <putch+0x1f>

00800449 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800452:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800459:	00 00 00 
	b.cnt = 0;
  80045c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800463:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800466:	ff 75 0c             	pushl  0xc(%ebp)
  800469:	ff 75 08             	pushl  0x8(%ebp)
  80046c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800472:	50                   	push   %eax
  800473:	68 05 04 80 00       	push   $0x800405
  800478:	e8 4a 01 00 00       	call   8005c7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80047d:	83 c4 08             	add    $0x8,%esp
  800480:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800486:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80048c:	50                   	push   %eax
  80048d:	e8 fe fb ff ff       	call   800090 <sys_cputs>

	return b.cnt;
}
  800492:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800498:	c9                   	leave  
  800499:	c3                   	ret    

0080049a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004a3:	50                   	push   %eax
  8004a4:	ff 75 08             	pushl  0x8(%ebp)
  8004a7:	e8 9d ff ff ff       	call   800449 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	57                   	push   %edi
  8004b2:	56                   	push   %esi
  8004b3:	53                   	push   %ebx
  8004b4:	83 ec 1c             	sub    $0x1c,%esp
  8004b7:	89 c6                	mov    %eax,%esi
  8004b9:	89 d7                	mov    %edx,%edi
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004cd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004d1:	74 2c                	je     8004ff <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004e8:	73 43                	jae    80052d <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004ea:	83 eb 01             	sub    $0x1,%ebx
  8004ed:	85 db                	test   %ebx,%ebx
  8004ef:	7e 6c                	jle    80055d <printnum+0xaf>
			putch(padc, putdat);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	57                   	push   %edi
  8004f5:	ff 75 18             	pushl  0x18(%ebp)
  8004f8:	ff d6                	call   *%esi
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	eb eb                	jmp    8004ea <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8004ff:	83 ec 0c             	sub    $0xc,%esp
  800502:	6a 20                	push   $0x20
  800504:	6a 00                	push   $0x0
  800506:	50                   	push   %eax
  800507:	ff 75 e4             	pushl  -0x1c(%ebp)
  80050a:	ff 75 e0             	pushl  -0x20(%ebp)
  80050d:	89 fa                	mov    %edi,%edx
  80050f:	89 f0                	mov    %esi,%eax
  800511:	e8 98 ff ff ff       	call   8004ae <printnum>
		while (--width > 0)
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	83 eb 01             	sub    $0x1,%ebx
  80051c:	85 db                	test   %ebx,%ebx
  80051e:	7e 65                	jle    800585 <printnum+0xd7>
			putch(padc, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	57                   	push   %edi
  800524:	6a 20                	push   $0x20
  800526:	ff d6                	call   *%esi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	eb ec                	jmp    800519 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	ff 75 18             	pushl  0x18(%ebp)
  800533:	83 eb 01             	sub    $0x1,%ebx
  800536:	53                   	push   %ebx
  800537:	50                   	push   %eax
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	ff 75 dc             	pushl  -0x24(%ebp)
  80053e:	ff 75 d8             	pushl  -0x28(%ebp)
  800541:	ff 75 e4             	pushl  -0x1c(%ebp)
  800544:	ff 75 e0             	pushl  -0x20(%ebp)
  800547:	e8 94 09 00 00       	call   800ee0 <__udivdi3>
  80054c:	83 c4 18             	add    $0x18,%esp
  80054f:	52                   	push   %edx
  800550:	50                   	push   %eax
  800551:	89 fa                	mov    %edi,%edx
  800553:	89 f0                	mov    %esi,%eax
  800555:	e8 54 ff ff ff       	call   8004ae <printnum>
  80055a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	57                   	push   %edi
  800561:	83 ec 04             	sub    $0x4,%esp
  800564:	ff 75 dc             	pushl  -0x24(%ebp)
  800567:	ff 75 d8             	pushl  -0x28(%ebp)
  80056a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056d:	ff 75 e0             	pushl  -0x20(%ebp)
  800570:	e8 7b 0a 00 00       	call   800ff0 <__umoddi3>
  800575:	83 c4 14             	add    $0x14,%esp
  800578:	0f be 80 9d 11 80 00 	movsbl 0x80119d(%eax),%eax
  80057f:	50                   	push   %eax
  800580:	ff d6                	call   *%esi
  800582:	83 c4 10             	add    $0x10,%esp
}
  800585:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800588:	5b                   	pop    %ebx
  800589:	5e                   	pop    %esi
  80058a:	5f                   	pop    %edi
  80058b:	5d                   	pop    %ebp
  80058c:	c3                   	ret    

0080058d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80058d:	55                   	push   %ebp
  80058e:	89 e5                	mov    %esp,%ebp
  800590:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800593:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800597:	8b 10                	mov    (%eax),%edx
  800599:	3b 50 04             	cmp    0x4(%eax),%edx
  80059c:	73 0a                	jae    8005a8 <sprintputch+0x1b>
		*b->buf++ = ch;
  80059e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005a1:	89 08                	mov    %ecx,(%eax)
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	88 02                	mov    %al,(%edx)
}
  8005a8:	5d                   	pop    %ebp
  8005a9:	c3                   	ret    

008005aa <printfmt>:
{
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005b0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005b3:	50                   	push   %eax
  8005b4:	ff 75 10             	pushl  0x10(%ebp)
  8005b7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ba:	ff 75 08             	pushl  0x8(%ebp)
  8005bd:	e8 05 00 00 00       	call   8005c7 <vprintfmt>
}
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vprintfmt>:
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	57                   	push   %edi
  8005cb:	56                   	push   %esi
  8005cc:	53                   	push   %ebx
  8005cd:	83 ec 3c             	sub    $0x3c,%esp
  8005d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005d9:	e9 b4 03 00 00       	jmp    800992 <vprintfmt+0x3cb>
		padc = ' ';
  8005de:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8005e2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8005e9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005f0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005fe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800603:	8d 47 01             	lea    0x1(%edi),%eax
  800606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800609:	0f b6 17             	movzbl (%edi),%edx
  80060c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80060f:	3c 55                	cmp    $0x55,%al
  800611:	0f 87 c8 04 00 00    	ja     800adf <vprintfmt+0x518>
  800617:	0f b6 c0             	movzbl %al,%eax
  80061a:	ff 24 85 80 13 80 00 	jmp    *0x801380(,%eax,4)
  800621:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800624:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80062b:	eb d6                	jmp    800603 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80062d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800630:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800634:	eb cd                	jmp    800603 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800636:	0f b6 d2             	movzbl %dl,%edx
  800639:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80063c:	b8 00 00 00 00       	mov    $0x0,%eax
  800641:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800644:	eb 0c                	jmp    800652 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800646:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800649:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80064d:	eb b4                	jmp    800603 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80064f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800652:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800655:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800659:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80065c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80065f:	83 f9 09             	cmp    $0x9,%ecx
  800662:	76 eb                	jbe    80064f <vprintfmt+0x88>
  800664:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	eb 14                	jmp    800680 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 40 04             	lea    0x4(%eax),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80067d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800680:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800684:	0f 89 79 ff ff ff    	jns    800603 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80068a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80068d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800690:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800697:	e9 67 ff ff ff       	jmp    800603 <vprintfmt+0x3c>
  80069c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069f:	85 c0                	test   %eax,%eax
  8006a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a6:	0f 49 d0             	cmovns %eax,%edx
  8006a9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006af:	e9 4f ff ff ff       	jmp    800603 <vprintfmt+0x3c>
  8006b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006b7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006be:	e9 40 ff ff ff       	jmp    800603 <vprintfmt+0x3c>
			lflag++;
  8006c3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006c9:	e9 35 ff ff ff       	jmp    800603 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 78 04             	lea    0x4(%eax),%edi
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	ff 30                	pushl  (%eax)
  8006da:	ff d6                	call   *%esi
			break;
  8006dc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006df:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006e2:	e9 a8 02 00 00       	jmp    80098f <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 78 04             	lea    0x4(%eax),%edi
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	99                   	cltd   
  8006f0:	31 d0                	xor    %edx,%eax
  8006f2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006f4:	83 f8 0f             	cmp    $0xf,%eax
  8006f7:	7f 23                	jg     80071c <vprintfmt+0x155>
  8006f9:	8b 14 85 e0 14 80 00 	mov    0x8014e0(,%eax,4),%edx
  800700:	85 d2                	test   %edx,%edx
  800702:	74 18                	je     80071c <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800704:	52                   	push   %edx
  800705:	68 be 11 80 00       	push   $0x8011be
  80070a:	53                   	push   %ebx
  80070b:	56                   	push   %esi
  80070c:	e8 99 fe ff ff       	call   8005aa <printfmt>
  800711:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800714:	89 7d 14             	mov    %edi,0x14(%ebp)
  800717:	e9 73 02 00 00       	jmp    80098f <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80071c:	50                   	push   %eax
  80071d:	68 b5 11 80 00       	push   $0x8011b5
  800722:	53                   	push   %ebx
  800723:	56                   	push   %esi
  800724:	e8 81 fe ff ff       	call   8005aa <printfmt>
  800729:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80072c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80072f:	e9 5b 02 00 00       	jmp    80098f <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	83 c0 04             	add    $0x4,%eax
  80073a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800742:	85 d2                	test   %edx,%edx
  800744:	b8 ae 11 80 00       	mov    $0x8011ae,%eax
  800749:	0f 45 c2             	cmovne %edx,%eax
  80074c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80074f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800753:	7e 06                	jle    80075b <vprintfmt+0x194>
  800755:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800759:	75 0d                	jne    800768 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80075b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80075e:	89 c7                	mov    %eax,%edi
  800760:	03 45 e0             	add    -0x20(%ebp),%eax
  800763:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800766:	eb 53                	jmp    8007bb <vprintfmt+0x1f4>
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 d8             	pushl  -0x28(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 13 04 00 00       	call   800b87 <strnlen>
  800774:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800777:	29 c1                	sub    %eax,%ecx
  800779:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800781:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800785:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800788:	eb 0f                	jmp    800799 <vprintfmt+0x1d2>
					putch(padc, putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	53                   	push   %ebx
  80078e:	ff 75 e0             	pushl  -0x20(%ebp)
  800791:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800793:	83 ef 01             	sub    $0x1,%edi
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	85 ff                	test   %edi,%edi
  80079b:	7f ed                	jg     80078a <vprintfmt+0x1c3>
  80079d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007a0:	85 d2                	test   %edx,%edx
  8007a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a7:	0f 49 c2             	cmovns %edx,%eax
  8007aa:	29 c2                	sub    %eax,%edx
  8007ac:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007af:	eb aa                	jmp    80075b <vprintfmt+0x194>
					putch(ch, putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	53                   	push   %ebx
  8007b5:	52                   	push   %edx
  8007b6:	ff d6                	call   *%esi
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007be:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c0:	83 c7 01             	add    $0x1,%edi
  8007c3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007c7:	0f be d0             	movsbl %al,%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	74 4b                	je     800819 <vprintfmt+0x252>
  8007ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007d2:	78 06                	js     8007da <vprintfmt+0x213>
  8007d4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007d8:	78 1e                	js     8007f8 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8007da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007de:	74 d1                	je     8007b1 <vprintfmt+0x1ea>
  8007e0:	0f be c0             	movsbl %al,%eax
  8007e3:	83 e8 20             	sub    $0x20,%eax
  8007e6:	83 f8 5e             	cmp    $0x5e,%eax
  8007e9:	76 c6                	jbe    8007b1 <vprintfmt+0x1ea>
					putch('?', putdat);
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	53                   	push   %ebx
  8007ef:	6a 3f                	push   $0x3f
  8007f1:	ff d6                	call   *%esi
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	eb c3                	jmp    8007bb <vprintfmt+0x1f4>
  8007f8:	89 cf                	mov    %ecx,%edi
  8007fa:	eb 0e                	jmp    80080a <vprintfmt+0x243>
				putch(' ', putdat);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	53                   	push   %ebx
  800800:	6a 20                	push   $0x20
  800802:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800804:	83 ef 01             	sub    $0x1,%edi
  800807:	83 c4 10             	add    $0x10,%esp
  80080a:	85 ff                	test   %edi,%edi
  80080c:	7f ee                	jg     8007fc <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80080e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
  800814:	e9 76 01 00 00       	jmp    80098f <vprintfmt+0x3c8>
  800819:	89 cf                	mov    %ecx,%edi
  80081b:	eb ed                	jmp    80080a <vprintfmt+0x243>
	if (lflag >= 2)
  80081d:	83 f9 01             	cmp    $0x1,%ecx
  800820:	7f 1f                	jg     800841 <vprintfmt+0x27a>
	else if (lflag)
  800822:	85 c9                	test   %ecx,%ecx
  800824:	74 6a                	je     800890 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082e:	89 c1                	mov    %eax,%ecx
  800830:	c1 f9 1f             	sar    $0x1f,%ecx
  800833:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 04             	lea    0x4(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
  80083f:	eb 17                	jmp    800858 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8b 50 04             	mov    0x4(%eax),%edx
  800847:	8b 00                	mov    (%eax),%eax
  800849:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8d 40 08             	lea    0x8(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800858:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80085b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800860:	85 d2                	test   %edx,%edx
  800862:	0f 89 f8 00 00 00    	jns    800960 <vprintfmt+0x399>
				putch('-', putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	53                   	push   %ebx
  80086c:	6a 2d                	push   $0x2d
  80086e:	ff d6                	call   *%esi
				num = -(long long) num;
  800870:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800873:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800876:	f7 d8                	neg    %eax
  800878:	83 d2 00             	adc    $0x0,%edx
  80087b:	f7 da                	neg    %edx
  80087d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800880:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800883:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800886:	bf 0a 00 00 00       	mov    $0xa,%edi
  80088b:	e9 e1 00 00 00       	jmp    800971 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800898:	99                   	cltd   
  800899:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8d 40 04             	lea    0x4(%eax),%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	eb b1                	jmp    800858 <vprintfmt+0x291>
	if (lflag >= 2)
  8008a7:	83 f9 01             	cmp    $0x1,%ecx
  8008aa:	7f 27                	jg     8008d3 <vprintfmt+0x30c>
	else if (lflag)
  8008ac:	85 c9                	test   %ecx,%ecx
  8008ae:	74 41                	je     8008f1 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8d 40 04             	lea    0x4(%eax),%eax
  8008c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008c9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008ce:	e9 8d 00 00 00       	jmp    800960 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8d 40 08             	lea    0x8(%eax),%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ea:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008ef:	eb 6f                	jmp    800960 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	8d 40 04             	lea    0x4(%eax),%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80090f:	eb 4f                	jmp    800960 <vprintfmt+0x399>
	if (lflag >= 2)
  800911:	83 f9 01             	cmp    $0x1,%ecx
  800914:	7f 23                	jg     800939 <vprintfmt+0x372>
	else if (lflag)
  800916:	85 c9                	test   %ecx,%ecx
  800918:	0f 84 98 00 00 00    	je     8009b6 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	ba 00 00 00 00       	mov    $0x0,%edx
  800928:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	8d 40 04             	lea    0x4(%eax),%eax
  800934:	89 45 14             	mov    %eax,0x14(%ebp)
  800937:	eb 17                	jmp    800950 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8b 50 04             	mov    0x4(%eax),%edx
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800944:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8d 40 08             	lea    0x8(%eax),%eax
  80094d:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	53                   	push   %ebx
  800954:	6a 30                	push   $0x30
  800956:	ff d6                	call   *%esi
			goto number;
  800958:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80095b:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800960:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800964:	74 0b                	je     800971 <vprintfmt+0x3aa>
				putch('+', putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	53                   	push   %ebx
  80096a:	6a 2b                	push   $0x2b
  80096c:	ff d6                	call   *%esi
  80096e:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800971:	83 ec 0c             	sub    $0xc,%esp
  800974:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800978:	50                   	push   %eax
  800979:	ff 75 e0             	pushl  -0x20(%ebp)
  80097c:	57                   	push   %edi
  80097d:	ff 75 dc             	pushl  -0x24(%ebp)
  800980:	ff 75 d8             	pushl  -0x28(%ebp)
  800983:	89 da                	mov    %ebx,%edx
  800985:	89 f0                	mov    %esi,%eax
  800987:	e8 22 fb ff ff       	call   8004ae <printnum>
			break;
  80098c:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80098f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800992:	83 c7 01             	add    $0x1,%edi
  800995:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800999:	83 f8 25             	cmp    $0x25,%eax
  80099c:	0f 84 3c fc ff ff    	je     8005de <vprintfmt+0x17>
			if (ch == '\0')
  8009a2:	85 c0                	test   %eax,%eax
  8009a4:	0f 84 55 01 00 00    	je     800aff <vprintfmt+0x538>
			putch(ch, putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	53                   	push   %ebx
  8009ae:	50                   	push   %eax
  8009af:	ff d6                	call   *%esi
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	eb dc                	jmp    800992 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	8d 40 04             	lea    0x4(%eax),%eax
  8009cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cf:	e9 7c ff ff ff       	jmp    800950 <vprintfmt+0x389>
			putch('0', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	53                   	push   %ebx
  8009d8:	6a 30                	push   $0x30
  8009da:	ff d6                	call   *%esi
			putch('x', putdat);
  8009dc:	83 c4 08             	add    $0x8,%esp
  8009df:	53                   	push   %ebx
  8009e0:	6a 78                	push   $0x78
  8009e2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	8b 00                	mov    (%eax),%eax
  8009e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009f4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	8d 40 04             	lea    0x4(%eax),%eax
  8009fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a00:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a05:	e9 56 ff ff ff       	jmp    800960 <vprintfmt+0x399>
	if (lflag >= 2)
  800a0a:	83 f9 01             	cmp    $0x1,%ecx
  800a0d:	7f 27                	jg     800a36 <vprintfmt+0x46f>
	else if (lflag)
  800a0f:	85 c9                	test   %ecx,%ecx
  800a11:	74 44                	je     800a57 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	8b 00                	mov    (%eax),%eax
  800a18:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a20:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8d 40 04             	lea    0x4(%eax),%eax
  800a29:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a2c:	bf 10 00 00 00       	mov    $0x10,%edi
  800a31:	e9 2a ff ff ff       	jmp    800960 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	8b 50 04             	mov    0x4(%eax),%edx
  800a3c:	8b 00                	mov    (%eax),%eax
  800a3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a41:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	8d 40 08             	lea    0x8(%eax),%eax
  800a4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a4d:	bf 10 00 00 00       	mov    $0x10,%edi
  800a52:	e9 09 ff ff ff       	jmp    800960 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	8b 00                	mov    (%eax),%eax
  800a5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a64:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	8d 40 04             	lea    0x4(%eax),%eax
  800a6d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a70:	bf 10 00 00 00       	mov    $0x10,%edi
  800a75:	e9 e6 fe ff ff       	jmp    800960 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	8d 78 04             	lea    0x4(%eax),%edi
  800a80:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800a82:	85 c0                	test   %eax,%eax
  800a84:	74 2d                	je     800ab3 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800a86:	0f b6 13             	movzbl (%ebx),%edx
  800a89:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a8b:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800a8e:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a91:	0f 8e f8 fe ff ff    	jle    80098f <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800a97:	68 0c 13 80 00       	push   $0x80130c
  800a9c:	68 be 11 80 00       	push   $0x8011be
  800aa1:	53                   	push   %ebx
  800aa2:	56                   	push   %esi
  800aa3:	e8 02 fb ff ff       	call   8005aa <printfmt>
  800aa8:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800aab:	89 7d 14             	mov    %edi,0x14(%ebp)
  800aae:	e9 dc fe ff ff       	jmp    80098f <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800ab3:	68 d4 12 80 00       	push   $0x8012d4
  800ab8:	68 be 11 80 00       	push   $0x8011be
  800abd:	53                   	push   %ebx
  800abe:	56                   	push   %esi
  800abf:	e8 e6 fa ff ff       	call   8005aa <printfmt>
  800ac4:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ac7:	89 7d 14             	mov    %edi,0x14(%ebp)
  800aca:	e9 c0 fe ff ff       	jmp    80098f <vprintfmt+0x3c8>
			putch(ch, putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	53                   	push   %ebx
  800ad3:	6a 25                	push   $0x25
  800ad5:	ff d6                	call   *%esi
			break;
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	e9 b0 fe ff ff       	jmp    80098f <vprintfmt+0x3c8>
			putch('%', putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	53                   	push   %ebx
  800ae3:	6a 25                	push   $0x25
  800ae5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 f8                	mov    %edi,%eax
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x52a>
  800aee:	83 e8 01             	sub    $0x1,%eax
  800af1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800af5:	75 f7                	jne    800aee <vprintfmt+0x527>
  800af7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afa:	e9 90 fe ff ff       	jmp    80098f <vprintfmt+0x3c8>
}
  800aff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5f                   	pop    %edi
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 18             	sub    $0x18,%esp
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b16:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b1a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b24:	85 c0                	test   %eax,%eax
  800b26:	74 26                	je     800b4e <vsnprintf+0x47>
  800b28:	85 d2                	test   %edx,%edx
  800b2a:	7e 22                	jle    800b4e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b2c:	ff 75 14             	pushl  0x14(%ebp)
  800b2f:	ff 75 10             	pushl  0x10(%ebp)
  800b32:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b35:	50                   	push   %eax
  800b36:	68 8d 05 80 00       	push   $0x80058d
  800b3b:	e8 87 fa ff ff       	call   8005c7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b43:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b49:	83 c4 10             	add    $0x10,%esp
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    
		return -E_INVAL;
  800b4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b53:	eb f7                	jmp    800b4c <vsnprintf+0x45>

00800b55 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b5b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b5e:	50                   	push   %eax
  800b5f:	ff 75 10             	pushl  0x10(%ebp)
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	e8 9a ff ff ff       	call   800b07 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b6d:	c9                   	leave  
  800b6e:	c3                   	ret    

00800b6f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b75:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b7e:	74 05                	je     800b85 <strlen+0x16>
		n++;
  800b80:	83 c0 01             	add    $0x1,%eax
  800b83:	eb f5                	jmp    800b7a <strlen+0xb>
	return n;
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b90:	ba 00 00 00 00       	mov    $0x0,%edx
  800b95:	39 c2                	cmp    %eax,%edx
  800b97:	74 0d                	je     800ba6 <strnlen+0x1f>
  800b99:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b9d:	74 05                	je     800ba4 <strnlen+0x1d>
		n++;
  800b9f:	83 c2 01             	add    $0x1,%edx
  800ba2:	eb f1                	jmp    800b95 <strnlen+0xe>
  800ba4:	89 d0                	mov    %edx,%eax
	return n;
}
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	53                   	push   %ebx
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bbb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bbe:	83 c2 01             	add    $0x1,%edx
  800bc1:	84 c9                	test   %cl,%cl
  800bc3:	75 f2                	jne    800bb7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	53                   	push   %ebx
  800bcc:	83 ec 10             	sub    $0x10,%esp
  800bcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bd2:	53                   	push   %ebx
  800bd3:	e8 97 ff ff ff       	call   800b6f <strlen>
  800bd8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	01 d8                	add    %ebx,%eax
  800be0:	50                   	push   %eax
  800be1:	e8 c2 ff ff ff       	call   800ba8 <strcpy>
	return dst;
}
  800be6:	89 d8                	mov    %ebx,%eax
  800be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf8:	89 c6                	mov    %eax,%esi
  800bfa:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bfd:	89 c2                	mov    %eax,%edx
  800bff:	39 f2                	cmp    %esi,%edx
  800c01:	74 11                	je     800c14 <strncpy+0x27>
		*dst++ = *src;
  800c03:	83 c2 01             	add    $0x1,%edx
  800c06:	0f b6 19             	movzbl (%ecx),%ebx
  800c09:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c0c:	80 fb 01             	cmp    $0x1,%bl
  800c0f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c12:	eb eb                	jmp    800bff <strncpy+0x12>
	}
	return ret;
}
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c23:	8b 55 10             	mov    0x10(%ebp),%edx
  800c26:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c28:	85 d2                	test   %edx,%edx
  800c2a:	74 21                	je     800c4d <strlcpy+0x35>
  800c2c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c30:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c32:	39 c2                	cmp    %eax,%edx
  800c34:	74 14                	je     800c4a <strlcpy+0x32>
  800c36:	0f b6 19             	movzbl (%ecx),%ebx
  800c39:	84 db                	test   %bl,%bl
  800c3b:	74 0b                	je     800c48 <strlcpy+0x30>
			*dst++ = *src++;
  800c3d:	83 c1 01             	add    $0x1,%ecx
  800c40:	83 c2 01             	add    $0x1,%edx
  800c43:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c46:	eb ea                	jmp    800c32 <strlcpy+0x1a>
  800c48:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c4a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c4d:	29 f0                	sub    %esi,%eax
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c59:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c5c:	0f b6 01             	movzbl (%ecx),%eax
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 0c                	je     800c6f <strcmp+0x1c>
  800c63:	3a 02                	cmp    (%edx),%al
  800c65:	75 08                	jne    800c6f <strcmp+0x1c>
		p++, q++;
  800c67:	83 c1 01             	add    $0x1,%ecx
  800c6a:	83 c2 01             	add    $0x1,%edx
  800c6d:	eb ed                	jmp    800c5c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6f:	0f b6 c0             	movzbl %al,%eax
  800c72:	0f b6 12             	movzbl (%edx),%edx
  800c75:	29 d0                	sub    %edx,%eax
}
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	53                   	push   %ebx
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c83:	89 c3                	mov    %eax,%ebx
  800c85:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c88:	eb 06                	jmp    800c90 <strncmp+0x17>
		n--, p++, q++;
  800c8a:	83 c0 01             	add    $0x1,%eax
  800c8d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c90:	39 d8                	cmp    %ebx,%eax
  800c92:	74 16                	je     800caa <strncmp+0x31>
  800c94:	0f b6 08             	movzbl (%eax),%ecx
  800c97:	84 c9                	test   %cl,%cl
  800c99:	74 04                	je     800c9f <strncmp+0x26>
  800c9b:	3a 0a                	cmp    (%edx),%cl
  800c9d:	74 eb                	je     800c8a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9f:	0f b6 00             	movzbl (%eax),%eax
  800ca2:	0f b6 12             	movzbl (%edx),%edx
  800ca5:	29 d0                	sub    %edx,%eax
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    
		return 0;
  800caa:	b8 00 00 00 00       	mov    $0x0,%eax
  800caf:	eb f6                	jmp    800ca7 <strncmp+0x2e>

00800cb1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cbb:	0f b6 10             	movzbl (%eax),%edx
  800cbe:	84 d2                	test   %dl,%dl
  800cc0:	74 09                	je     800ccb <strchr+0x1a>
		if (*s == c)
  800cc2:	38 ca                	cmp    %cl,%dl
  800cc4:	74 0a                	je     800cd0 <strchr+0x1f>
	for (; *s; s++)
  800cc6:	83 c0 01             	add    $0x1,%eax
  800cc9:	eb f0                	jmp    800cbb <strchr+0xa>
			return (char *) s;
	return 0;
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cdc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cdf:	38 ca                	cmp    %cl,%dl
  800ce1:	74 09                	je     800cec <strfind+0x1a>
  800ce3:	84 d2                	test   %dl,%dl
  800ce5:	74 05                	je     800cec <strfind+0x1a>
	for (; *s; s++)
  800ce7:	83 c0 01             	add    $0x1,%eax
  800cea:	eb f0                	jmp    800cdc <strfind+0xa>
			break;
	return (char *) s;
}
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cfa:	85 c9                	test   %ecx,%ecx
  800cfc:	74 31                	je     800d2f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cfe:	89 f8                	mov    %edi,%eax
  800d00:	09 c8                	or     %ecx,%eax
  800d02:	a8 03                	test   $0x3,%al
  800d04:	75 23                	jne    800d29 <memset+0x3b>
		c &= 0xFF;
  800d06:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d0a:	89 d3                	mov    %edx,%ebx
  800d0c:	c1 e3 08             	shl    $0x8,%ebx
  800d0f:	89 d0                	mov    %edx,%eax
  800d11:	c1 e0 18             	shl    $0x18,%eax
  800d14:	89 d6                	mov    %edx,%esi
  800d16:	c1 e6 10             	shl    $0x10,%esi
  800d19:	09 f0                	or     %esi,%eax
  800d1b:	09 c2                	or     %eax,%edx
  800d1d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d1f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d22:	89 d0                	mov    %edx,%eax
  800d24:	fc                   	cld    
  800d25:	f3 ab                	rep stos %eax,%es:(%edi)
  800d27:	eb 06                	jmp    800d2f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	fc                   	cld    
  800d2d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d2f:	89 f8                	mov    %edi,%eax
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d44:	39 c6                	cmp    %eax,%esi
  800d46:	73 32                	jae    800d7a <memmove+0x44>
  800d48:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d4b:	39 c2                	cmp    %eax,%edx
  800d4d:	76 2b                	jbe    800d7a <memmove+0x44>
		s += n;
		d += n;
  800d4f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d52:	89 fe                	mov    %edi,%esi
  800d54:	09 ce                	or     %ecx,%esi
  800d56:	09 d6                	or     %edx,%esi
  800d58:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d5e:	75 0e                	jne    800d6e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d60:	83 ef 04             	sub    $0x4,%edi
  800d63:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d66:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d69:	fd                   	std    
  800d6a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d6c:	eb 09                	jmp    800d77 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d6e:	83 ef 01             	sub    $0x1,%edi
  800d71:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d74:	fd                   	std    
  800d75:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d77:	fc                   	cld    
  800d78:	eb 1a                	jmp    800d94 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d7a:	89 c2                	mov    %eax,%edx
  800d7c:	09 ca                	or     %ecx,%edx
  800d7e:	09 f2                	or     %esi,%edx
  800d80:	f6 c2 03             	test   $0x3,%dl
  800d83:	75 0a                	jne    800d8f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d85:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d88:	89 c7                	mov    %eax,%edi
  800d8a:	fc                   	cld    
  800d8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d8d:	eb 05                	jmp    800d94 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d8f:	89 c7                	mov    %eax,%edi
  800d91:	fc                   	cld    
  800d92:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d9e:	ff 75 10             	pushl  0x10(%ebp)
  800da1:	ff 75 0c             	pushl  0xc(%ebp)
  800da4:	ff 75 08             	pushl  0x8(%ebp)
  800da7:	e8 8a ff ff ff       	call   800d36 <memmove>
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db9:	89 c6                	mov    %eax,%esi
  800dbb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbe:	39 f0                	cmp    %esi,%eax
  800dc0:	74 1c                	je     800dde <memcmp+0x30>
		if (*s1 != *s2)
  800dc2:	0f b6 08             	movzbl (%eax),%ecx
  800dc5:	0f b6 1a             	movzbl (%edx),%ebx
  800dc8:	38 d9                	cmp    %bl,%cl
  800dca:	75 08                	jne    800dd4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dcc:	83 c0 01             	add    $0x1,%eax
  800dcf:	83 c2 01             	add    $0x1,%edx
  800dd2:	eb ea                	jmp    800dbe <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dd4:	0f b6 c1             	movzbl %cl,%eax
  800dd7:	0f b6 db             	movzbl %bl,%ebx
  800dda:	29 d8                	sub    %ebx,%eax
  800ddc:	eb 05                	jmp    800de3 <memcmp+0x35>
	}

	return 0;
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800df0:	89 c2                	mov    %eax,%edx
  800df2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df5:	39 d0                	cmp    %edx,%eax
  800df7:	73 09                	jae    800e02 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800df9:	38 08                	cmp    %cl,(%eax)
  800dfb:	74 05                	je     800e02 <memfind+0x1b>
	for (; s < ends; s++)
  800dfd:	83 c0 01             	add    $0x1,%eax
  800e00:	eb f3                	jmp    800df5 <memfind+0xe>
			break;
	return (void *) s;
}
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e10:	eb 03                	jmp    800e15 <strtol+0x11>
		s++;
  800e12:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e15:	0f b6 01             	movzbl (%ecx),%eax
  800e18:	3c 20                	cmp    $0x20,%al
  800e1a:	74 f6                	je     800e12 <strtol+0xe>
  800e1c:	3c 09                	cmp    $0x9,%al
  800e1e:	74 f2                	je     800e12 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e20:	3c 2b                	cmp    $0x2b,%al
  800e22:	74 2a                	je     800e4e <strtol+0x4a>
	int neg = 0;
  800e24:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e29:	3c 2d                	cmp    $0x2d,%al
  800e2b:	74 2b                	je     800e58 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e2d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e33:	75 0f                	jne    800e44 <strtol+0x40>
  800e35:	80 39 30             	cmpb   $0x30,(%ecx)
  800e38:	74 28                	je     800e62 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e41:	0f 44 d8             	cmove  %eax,%ebx
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
  800e49:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e4c:	eb 50                	jmp    800e9e <strtol+0x9a>
		s++;
  800e4e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e51:	bf 00 00 00 00       	mov    $0x0,%edi
  800e56:	eb d5                	jmp    800e2d <strtol+0x29>
		s++, neg = 1;
  800e58:	83 c1 01             	add    $0x1,%ecx
  800e5b:	bf 01 00 00 00       	mov    $0x1,%edi
  800e60:	eb cb                	jmp    800e2d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e62:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e66:	74 0e                	je     800e76 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e68:	85 db                	test   %ebx,%ebx
  800e6a:	75 d8                	jne    800e44 <strtol+0x40>
		s++, base = 8;
  800e6c:	83 c1 01             	add    $0x1,%ecx
  800e6f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e74:	eb ce                	jmp    800e44 <strtol+0x40>
		s += 2, base = 16;
  800e76:	83 c1 02             	add    $0x2,%ecx
  800e79:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e7e:	eb c4                	jmp    800e44 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e80:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e83:	89 f3                	mov    %esi,%ebx
  800e85:	80 fb 19             	cmp    $0x19,%bl
  800e88:	77 29                	ja     800eb3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e8a:	0f be d2             	movsbl %dl,%edx
  800e8d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e90:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e93:	7d 30                	jge    800ec5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e95:	83 c1 01             	add    $0x1,%ecx
  800e98:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e9c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e9e:	0f b6 11             	movzbl (%ecx),%edx
  800ea1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ea4:	89 f3                	mov    %esi,%ebx
  800ea6:	80 fb 09             	cmp    $0x9,%bl
  800ea9:	77 d5                	ja     800e80 <strtol+0x7c>
			dig = *s - '0';
  800eab:	0f be d2             	movsbl %dl,%edx
  800eae:	83 ea 30             	sub    $0x30,%edx
  800eb1:	eb dd                	jmp    800e90 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eb3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eb6:	89 f3                	mov    %esi,%ebx
  800eb8:	80 fb 19             	cmp    $0x19,%bl
  800ebb:	77 08                	ja     800ec5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ebd:	0f be d2             	movsbl %dl,%edx
  800ec0:	83 ea 37             	sub    $0x37,%edx
  800ec3:	eb cb                	jmp    800e90 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ec5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec9:	74 05                	je     800ed0 <strtol+0xcc>
		*endptr = (char *) s;
  800ecb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ece:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ed0:	89 c2                	mov    %eax,%edx
  800ed2:	f7 da                	neg    %edx
  800ed4:	85 ff                	test   %edi,%edi
  800ed6:	0f 45 c2             	cmovne %edx,%eax
}
  800ed9:	5b                   	pop    %ebx
  800eda:	5e                   	pop    %esi
  800edb:	5f                   	pop    %edi
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    
  800ede:	66 90                	xchg   %ax,%ax

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
