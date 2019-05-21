
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 60 00 00 00       	call   8000a2 <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800052:	e8 c9 00 00 00       	call   800120 <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80005f:	c1 e0 04             	shl    $0x4,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x30>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800096:	6a 00                	push   $0x0
  800098:	e8 42 00 00 00       	call   8000df <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	57                   	push   %edi
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f5:	89 cb                	mov    %ecx,%ebx
  8000f7:	89 cf                	mov    %ecx,%edi
  8000f9:	89 ce                	mov    %ecx,%esi
  8000fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	7f 08                	jg     800109 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	6a 03                	push   $0x3
  80010f:	68 4a 11 80 00       	push   $0x80114a
  800114:	6a 33                	push   $0x33
  800116:	68 67 11 80 00       	push   $0x801167
  80011b:	e8 b1 02 00 00       	call   8003d1 <_panic>

00800120 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
	asm volatile("int %1\n"
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	b8 02 00 00 00       	mov    $0x2,%eax
  800130:	89 d1                	mov    %edx,%ecx
  800132:	89 d3                	mov    %edx,%ebx
  800134:	89 d7                	mov    %edx,%edi
  800136:	89 d6                	mov    %edx,%esi
  800138:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_yield>:

void
sys_yield(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	asm volatile("int %1\n"
  800145:	ba 00 00 00 00       	mov    $0x0,%edx
  80014a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80014f:	89 d1                	mov    %edx,%ecx
  800151:	89 d3                	mov    %edx,%ebx
  800153:	89 d7                	mov    %edx,%edi
  800155:	89 d6                	mov    %edx,%esi
  800157:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	8b 55 08             	mov    0x8(%ebp),%edx
  80016f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800172:	b8 04 00 00 00       	mov    $0x4,%eax
  800177:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017a:	89 f7                	mov    %esi,%edi
  80017c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017e:	85 c0                	test   %eax,%eax
  800180:	7f 08                	jg     80018a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	6a 04                	push   $0x4
  800190:	68 4a 11 80 00       	push   $0x80114a
  800195:	6a 33                	push   $0x33
  800197:	68 67 11 80 00       	push   $0x801167
  80019c:	e8 30 02 00 00       	call   8003d1 <_panic>

008001a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	7f 08                	jg     8001cc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	6a 05                	push   $0x5
  8001d2:	68 4a 11 80 00       	push   $0x80114a
  8001d7:	6a 33                	push   $0x33
  8001d9:	68 67 11 80 00       	push   $0x801167
  8001de:	e8 ee 01 00 00       	call   8003d1 <_panic>

008001e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001fc:	89 df                	mov    %ebx,%edi
  8001fe:	89 de                	mov    %ebx,%esi
  800200:	cd 30                	int    $0x30
	if(check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7f 08                	jg     80020e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800209:	5b                   	pop    %ebx
  80020a:	5e                   	pop    %esi
  80020b:	5f                   	pop    %edi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	6a 06                	push   $0x6
  800214:	68 4a 11 80 00       	push   $0x80114a
  800219:	6a 33                	push   $0x33
  80021b:	68 67 11 80 00       	push   $0x801167
  800220:	e8 ac 01 00 00       	call   8003d1 <_panic>

00800225 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	b8 0b 00 00 00       	mov    $0xb,%eax
  80023b:	89 cb                	mov    %ecx,%ebx
  80023d:	89 cf                	mov    %ecx,%edi
  80023f:	89 ce                	mov    %ecx,%esi
  800241:	cd 30                	int    $0x30
	if(check && ret > 0)
  800243:	85 c0                	test   %eax,%eax
  800245:	7f 08                	jg     80024f <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5f                   	pop    %edi
  80024d:	5d                   	pop    %ebp
  80024e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	50                   	push   %eax
  800253:	6a 0b                	push   $0xb
  800255:	68 4a 11 80 00       	push   $0x80114a
  80025a:	6a 33                	push   $0x33
  80025c:	68 67 11 80 00       	push   $0x801167
  800261:	e8 6b 01 00 00       	call   8003d1 <_panic>

00800266 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	57                   	push   %edi
  80026a:	56                   	push   %esi
  80026b:	53                   	push   %ebx
  80026c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800274:	8b 55 08             	mov    0x8(%ebp),%edx
  800277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027a:	b8 08 00 00 00       	mov    $0x8,%eax
  80027f:	89 df                	mov    %ebx,%edi
  800281:	89 de                	mov    %ebx,%esi
  800283:	cd 30                	int    $0x30
	if(check && ret > 0)
  800285:	85 c0                	test   %eax,%eax
  800287:	7f 08                	jg     800291 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800289:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028c:	5b                   	pop    %ebx
  80028d:	5e                   	pop    %esi
  80028e:	5f                   	pop    %edi
  80028f:	5d                   	pop    %ebp
  800290:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	50                   	push   %eax
  800295:	6a 08                	push   $0x8
  800297:	68 4a 11 80 00       	push   $0x80114a
  80029c:	6a 33                	push   $0x33
  80029e:	68 67 11 80 00       	push   $0x801167
  8002a3:	e8 29 01 00 00       	call   8003d1 <_panic>

008002a8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	57                   	push   %edi
  8002ac:	56                   	push   %esi
  8002ad:	53                   	push   %ebx
  8002ae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c1:	89 df                	mov    %ebx,%edi
  8002c3:	89 de                	mov    %ebx,%esi
  8002c5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	7f 08                	jg     8002d3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ce:	5b                   	pop    %ebx
  8002cf:	5e                   	pop    %esi
  8002d0:	5f                   	pop    %edi
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	50                   	push   %eax
  8002d7:	6a 09                	push   $0x9
  8002d9:	68 4a 11 80 00       	push   $0x80114a
  8002de:	6a 33                	push   $0x33
  8002e0:	68 67 11 80 00       	push   $0x801167
  8002e5:	e8 e7 00 00 00       	call   8003d1 <_panic>

008002ea <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	57                   	push   %edi
  8002ee:	56                   	push   %esi
  8002ef:	53                   	push   %ebx
  8002f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800303:	89 df                	mov    %ebx,%edi
  800305:	89 de                	mov    %ebx,%esi
  800307:	cd 30                	int    $0x30
	if(check && ret > 0)
  800309:	85 c0                	test   %eax,%eax
  80030b:	7f 08                	jg     800315 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800310:	5b                   	pop    %ebx
  800311:	5e                   	pop    %esi
  800312:	5f                   	pop    %edi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	6a 0a                	push   $0xa
  80031b:	68 4a 11 80 00       	push   $0x80114a
  800320:	6a 33                	push   $0x33
  800322:	68 67 11 80 00       	push   $0x801167
  800327:	e8 a5 00 00 00       	call   8003d1 <_panic>

0080032c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	57                   	push   %edi
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
	asm volatile("int %1\n"
  800332:	8b 55 08             	mov    0x8(%ebp),%edx
  800335:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800338:	b8 0d 00 00 00       	mov    $0xd,%eax
  80033d:	be 00 00 00 00       	mov    $0x0,%esi
  800342:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800345:	8b 7d 14             	mov    0x14(%ebp),%edi
  800348:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	57                   	push   %edi
  800353:	56                   	push   %esi
  800354:	53                   	push   %ebx
  800355:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800358:	b9 00 00 00 00       	mov    $0x0,%ecx
  80035d:	8b 55 08             	mov    0x8(%ebp),%edx
  800360:	b8 0e 00 00 00       	mov    $0xe,%eax
  800365:	89 cb                	mov    %ecx,%ebx
  800367:	89 cf                	mov    %ecx,%edi
  800369:	89 ce                	mov    %ecx,%esi
  80036b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80036d:	85 c0                	test   %eax,%eax
  80036f:	7f 08                	jg     800379 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800371:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800374:	5b                   	pop    %ebx
  800375:	5e                   	pop    %esi
  800376:	5f                   	pop    %edi
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	50                   	push   %eax
  80037d:	6a 0e                	push   $0xe
  80037f:	68 4a 11 80 00       	push   $0x80114a
  800384:	6a 33                	push   $0x33
  800386:	68 67 11 80 00       	push   $0x801167
  80038b:	e8 41 00 00 00       	call   8003d1 <_panic>

00800390 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
	asm volatile("int %1\n"
  800396:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039b:	8b 55 08             	mov    0x8(%ebp),%edx
  80039e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003a6:	89 df                	mov    %ebx,%edi
  8003a8:	89 de                	mov    %ebx,%esi
  8003aa:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003ac:	5b                   	pop    %ebx
  8003ad:	5e                   	pop    %esi
  8003ae:	5f                   	pop    %edi
  8003af:	5d                   	pop    %ebp
  8003b0:	c3                   	ret    

008003b1 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	57                   	push   %edi
  8003b5:	56                   	push   %esi
  8003b6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bf:	b8 10 00 00 00       	mov    $0x10,%eax
  8003c4:	89 cb                	mov    %ecx,%ebx
  8003c6:	89 cf                	mov    %ecx,%edi
  8003c8:	89 ce                	mov    %ecx,%esi
  8003ca:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003cc:	5b                   	pop    %ebx
  8003cd:	5e                   	pop    %esi
  8003ce:	5f                   	pop    %edi
  8003cf:	5d                   	pop    %ebp
  8003d0:	c3                   	ret    

008003d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	56                   	push   %esi
  8003d5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003d6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003d9:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003df:	e8 3c fd ff ff       	call   800120 <sys_getenvid>
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ea:	ff 75 08             	pushl  0x8(%ebp)
  8003ed:	56                   	push   %esi
  8003ee:	50                   	push   %eax
  8003ef:	68 78 11 80 00       	push   $0x801178
  8003f4:	e8 b3 00 00 00       	call   8004ac <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003f9:	83 c4 18             	add    $0x18,%esp
  8003fc:	53                   	push   %ebx
  8003fd:	ff 75 10             	pushl  0x10(%ebp)
  800400:	e8 56 00 00 00       	call   80045b <vcprintf>
	cprintf("\n");
  800405:	c7 04 24 9b 11 80 00 	movl   $0x80119b,(%esp)
  80040c:	e8 9b 00 00 00       	call   8004ac <cprintf>
  800411:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800414:	cc                   	int3   
  800415:	eb fd                	jmp    800414 <_panic+0x43>

00800417 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	53                   	push   %ebx
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800421:	8b 13                	mov    (%ebx),%edx
  800423:	8d 42 01             	lea    0x1(%edx),%eax
  800426:	89 03                	mov    %eax,(%ebx)
  800428:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80042b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80042f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800434:	74 09                	je     80043f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800436:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80043a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80043d:	c9                   	leave  
  80043e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	68 ff 00 00 00       	push   $0xff
  800447:	8d 43 08             	lea    0x8(%ebx),%eax
  80044a:	50                   	push   %eax
  80044b:	e8 52 fc ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  800450:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800456:	83 c4 10             	add    $0x10,%esp
  800459:	eb db                	jmp    800436 <putch+0x1f>

0080045b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800464:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80046b:	00 00 00 
	b.cnt = 0;
  80046e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800475:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800478:	ff 75 0c             	pushl  0xc(%ebp)
  80047b:	ff 75 08             	pushl  0x8(%ebp)
  80047e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800484:	50                   	push   %eax
  800485:	68 17 04 80 00       	push   $0x800417
  80048a:	e8 4a 01 00 00       	call   8005d9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80048f:	83 c4 08             	add    $0x8,%esp
  800492:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800498:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80049e:	50                   	push   %eax
  80049f:	e8 fe fb ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  8004a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004aa:	c9                   	leave  
  8004ab:	c3                   	ret    

008004ac <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004b2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004b5:	50                   	push   %eax
  8004b6:	ff 75 08             	pushl  0x8(%ebp)
  8004b9:	e8 9d ff ff ff       	call   80045b <vcprintf>
	va_end(ap);

	return cnt;
}
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	57                   	push   %edi
  8004c4:	56                   	push   %esi
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 1c             	sub    $0x1c,%esp
  8004c9:	89 c6                	mov    %eax,%esi
  8004cb:	89 d7                	mov    %edx,%edi
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004df:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004e3:	74 2c                	je     800511 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004f2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004f5:	39 c2                	cmp    %eax,%edx
  8004f7:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004fa:	73 43                	jae    80053f <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004fc:	83 eb 01             	sub    $0x1,%ebx
  8004ff:	85 db                	test   %ebx,%ebx
  800501:	7e 6c                	jle    80056f <printnum+0xaf>
			putch(padc, putdat);
  800503:	83 ec 08             	sub    $0x8,%esp
  800506:	57                   	push   %edi
  800507:	ff 75 18             	pushl  0x18(%ebp)
  80050a:	ff d6                	call   *%esi
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	eb eb                	jmp    8004fc <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800511:	83 ec 0c             	sub    $0xc,%esp
  800514:	6a 20                	push   $0x20
  800516:	6a 00                	push   $0x0
  800518:	50                   	push   %eax
  800519:	ff 75 e4             	pushl  -0x1c(%ebp)
  80051c:	ff 75 e0             	pushl  -0x20(%ebp)
  80051f:	89 fa                	mov    %edi,%edx
  800521:	89 f0                	mov    %esi,%eax
  800523:	e8 98 ff ff ff       	call   8004c0 <printnum>
		while (--width > 0)
  800528:	83 c4 20             	add    $0x20,%esp
  80052b:	83 eb 01             	sub    $0x1,%ebx
  80052e:	85 db                	test   %ebx,%ebx
  800530:	7e 65                	jle    800597 <printnum+0xd7>
			putch(padc, putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	57                   	push   %edi
  800536:	6a 20                	push   $0x20
  800538:	ff d6                	call   *%esi
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	eb ec                	jmp    80052b <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80053f:	83 ec 0c             	sub    $0xc,%esp
  800542:	ff 75 18             	pushl  0x18(%ebp)
  800545:	83 eb 01             	sub    $0x1,%ebx
  800548:	53                   	push   %ebx
  800549:	50                   	push   %eax
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 dc             	pushl  -0x24(%ebp)
  800550:	ff 75 d8             	pushl  -0x28(%ebp)
  800553:	ff 75 e4             	pushl  -0x1c(%ebp)
  800556:	ff 75 e0             	pushl  -0x20(%ebp)
  800559:	e8 92 09 00 00       	call   800ef0 <__udivdi3>
  80055e:	83 c4 18             	add    $0x18,%esp
  800561:	52                   	push   %edx
  800562:	50                   	push   %eax
  800563:	89 fa                	mov    %edi,%edx
  800565:	89 f0                	mov    %esi,%eax
  800567:	e8 54 ff ff ff       	call   8004c0 <printnum>
  80056c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	57                   	push   %edi
  800573:	83 ec 04             	sub    $0x4,%esp
  800576:	ff 75 dc             	pushl  -0x24(%ebp)
  800579:	ff 75 d8             	pushl  -0x28(%ebp)
  80057c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80057f:	ff 75 e0             	pushl  -0x20(%ebp)
  800582:	e8 79 0a 00 00       	call   801000 <__umoddi3>
  800587:	83 c4 14             	add    $0x14,%esp
  80058a:	0f be 80 9d 11 80 00 	movsbl 0x80119d(%eax),%eax
  800591:	50                   	push   %eax
  800592:	ff d6                	call   *%esi
  800594:	83 c4 10             	add    $0x10,%esp
}
  800597:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80059a:	5b                   	pop    %ebx
  80059b:	5e                   	pop    %esi
  80059c:	5f                   	pop    %edi
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ae:	73 0a                	jae    8005ba <sprintputch+0x1b>
		*b->buf++ = ch;
  8005b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005b3:	89 08                	mov    %ecx,(%eax)
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	88 02                	mov    %al,(%edx)
}
  8005ba:	5d                   	pop    %ebp
  8005bb:	c3                   	ret    

008005bc <printfmt>:
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005c2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005c5:	50                   	push   %eax
  8005c6:	ff 75 10             	pushl  0x10(%ebp)
  8005c9:	ff 75 0c             	pushl  0xc(%ebp)
  8005cc:	ff 75 08             	pushl  0x8(%ebp)
  8005cf:	e8 05 00 00 00       	call   8005d9 <vprintfmt>
}
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vprintfmt>:
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	57                   	push   %edi
  8005dd:	56                   	push   %esi
  8005de:	53                   	push   %ebx
  8005df:	83 ec 3c             	sub    $0x3c,%esp
  8005e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005eb:	e9 b4 03 00 00       	jmp    8009a4 <vprintfmt+0x3cb>
		padc = ' ';
  8005f0:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8005f4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8005fb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800602:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800609:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800610:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800615:	8d 47 01             	lea    0x1(%edi),%eax
  800618:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061b:	0f b6 17             	movzbl (%edi),%edx
  80061e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800621:	3c 55                	cmp    $0x55,%al
  800623:	0f 87 c8 04 00 00    	ja     800af1 <vprintfmt+0x518>
  800629:	0f b6 c0             	movzbl %al,%eax
  80062c:	ff 24 85 80 13 80 00 	jmp    *0x801380(,%eax,4)
  800633:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800636:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80063d:	eb d6                	jmp    800615 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80063f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800642:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800646:	eb cd                	jmp    800615 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800648:	0f b6 d2             	movzbl %dl,%edx
  80064b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80064e:	b8 00 00 00 00       	mov    $0x0,%eax
  800653:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800656:	eb 0c                	jmp    800664 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800658:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80065b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80065f:	eb b4                	jmp    800615 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800661:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800664:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800667:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80066b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80066e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800671:	83 f9 09             	cmp    $0x9,%ecx
  800674:	76 eb                	jbe    800661 <vprintfmt+0x88>
  800676:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800679:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067c:	eb 14                	jmp    800692 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80068f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800692:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800696:	0f 89 79 ff ff ff    	jns    800615 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80069c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80069f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006a9:	e9 67 ff ff ff       	jmp    800615 <vprintfmt+0x3c>
  8006ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b1:	85 c0                	test   %eax,%eax
  8006b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b8:	0f 49 d0             	cmovns %eax,%edx
  8006bb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006c1:	e9 4f ff ff ff       	jmp    800615 <vprintfmt+0x3c>
  8006c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006c9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006d0:	e9 40 ff ff ff       	jmp    800615 <vprintfmt+0x3c>
			lflag++;
  8006d5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006db:	e9 35 ff ff ff       	jmp    800615 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 78 04             	lea    0x4(%eax),%edi
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	53                   	push   %ebx
  8006ea:	ff 30                	pushl  (%eax)
  8006ec:	ff d6                	call   *%esi
			break;
  8006ee:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006f1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006f4:	e9 a8 02 00 00       	jmp    8009a1 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8d 78 04             	lea    0x4(%eax),%edi
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	31 d0                	xor    %edx,%eax
  800704:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800706:	83 f8 0f             	cmp    $0xf,%eax
  800709:	7f 23                	jg     80072e <vprintfmt+0x155>
  80070b:	8b 14 85 e0 14 80 00 	mov    0x8014e0(,%eax,4),%edx
  800712:	85 d2                	test   %edx,%edx
  800714:	74 18                	je     80072e <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800716:	52                   	push   %edx
  800717:	68 be 11 80 00       	push   $0x8011be
  80071c:	53                   	push   %ebx
  80071d:	56                   	push   %esi
  80071e:	e8 99 fe ff ff       	call   8005bc <printfmt>
  800723:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800726:	89 7d 14             	mov    %edi,0x14(%ebp)
  800729:	e9 73 02 00 00       	jmp    8009a1 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80072e:	50                   	push   %eax
  80072f:	68 b5 11 80 00       	push   $0x8011b5
  800734:	53                   	push   %ebx
  800735:	56                   	push   %esi
  800736:	e8 81 fe ff ff       	call   8005bc <printfmt>
  80073b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80073e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800741:	e9 5b 02 00 00       	jmp    8009a1 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	83 c0 04             	add    $0x4,%eax
  80074c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800754:	85 d2                	test   %edx,%edx
  800756:	b8 ae 11 80 00       	mov    $0x8011ae,%eax
  80075b:	0f 45 c2             	cmovne %edx,%eax
  80075e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800761:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800765:	7e 06                	jle    80076d <vprintfmt+0x194>
  800767:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80076b:	75 0d                	jne    80077a <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80076d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800770:	89 c7                	mov    %eax,%edi
  800772:	03 45 e0             	add    -0x20(%ebp),%eax
  800775:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800778:	eb 53                	jmp    8007cd <vprintfmt+0x1f4>
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 d8             	pushl  -0x28(%ebp)
  800780:	50                   	push   %eax
  800781:	e8 13 04 00 00       	call   800b99 <strnlen>
  800786:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800789:	29 c1                	sub    %eax,%ecx
  80078b:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800793:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800797:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80079a:	eb 0f                	jmp    8007ab <vprintfmt+0x1d2>
					putch(padc, putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	53                   	push   %ebx
  8007a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007a3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a5:	83 ef 01             	sub    $0x1,%edi
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	85 ff                	test   %edi,%edi
  8007ad:	7f ed                	jg     80079c <vprintfmt+0x1c3>
  8007af:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007b2:	85 d2                	test   %edx,%edx
  8007b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b9:	0f 49 c2             	cmovns %edx,%eax
  8007bc:	29 c2                	sub    %eax,%edx
  8007be:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007c1:	eb aa                	jmp    80076d <vprintfmt+0x194>
					putch(ch, putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	53                   	push   %ebx
  8007c7:	52                   	push   %edx
  8007c8:	ff d6                	call   *%esi
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007d0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d2:	83 c7 01             	add    $0x1,%edi
  8007d5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d9:	0f be d0             	movsbl %al,%edx
  8007dc:	85 d2                	test   %edx,%edx
  8007de:	74 4b                	je     80082b <vprintfmt+0x252>
  8007e0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007e4:	78 06                	js     8007ec <vprintfmt+0x213>
  8007e6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007ea:	78 1e                	js     80080a <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8007ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007f0:	74 d1                	je     8007c3 <vprintfmt+0x1ea>
  8007f2:	0f be c0             	movsbl %al,%eax
  8007f5:	83 e8 20             	sub    $0x20,%eax
  8007f8:	83 f8 5e             	cmp    $0x5e,%eax
  8007fb:	76 c6                	jbe    8007c3 <vprintfmt+0x1ea>
					putch('?', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	53                   	push   %ebx
  800801:	6a 3f                	push   $0x3f
  800803:	ff d6                	call   *%esi
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	eb c3                	jmp    8007cd <vprintfmt+0x1f4>
  80080a:	89 cf                	mov    %ecx,%edi
  80080c:	eb 0e                	jmp    80081c <vprintfmt+0x243>
				putch(' ', putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	53                   	push   %ebx
  800812:	6a 20                	push   $0x20
  800814:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800816:	83 ef 01             	sub    $0x1,%edi
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	85 ff                	test   %edi,%edi
  80081e:	7f ee                	jg     80080e <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800820:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
  800826:	e9 76 01 00 00       	jmp    8009a1 <vprintfmt+0x3c8>
  80082b:	89 cf                	mov    %ecx,%edi
  80082d:	eb ed                	jmp    80081c <vprintfmt+0x243>
	if (lflag >= 2)
  80082f:	83 f9 01             	cmp    $0x1,%ecx
  800832:	7f 1f                	jg     800853 <vprintfmt+0x27a>
	else if (lflag)
  800834:	85 c9                	test   %ecx,%ecx
  800836:	74 6a                	je     8008a2 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800840:	89 c1                	mov    %eax,%ecx
  800842:	c1 f9 1f             	sar    $0x1f,%ecx
  800845:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8d 40 04             	lea    0x4(%eax),%eax
  80084e:	89 45 14             	mov    %eax,0x14(%ebp)
  800851:	eb 17                	jmp    80086a <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8b 50 04             	mov    0x4(%eax),%edx
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8d 40 08             	lea    0x8(%eax),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80086a:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80086d:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800872:	85 d2                	test   %edx,%edx
  800874:	0f 89 f8 00 00 00    	jns    800972 <vprintfmt+0x399>
				putch('-', putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	53                   	push   %ebx
  80087e:	6a 2d                	push   $0x2d
  800880:	ff d6                	call   *%esi
				num = -(long long) num;
  800882:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800885:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800888:	f7 d8                	neg    %eax
  80088a:	83 d2 00             	adc    $0x0,%edx
  80088d:	f7 da                	neg    %edx
  80088f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800892:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800895:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800898:	bf 0a 00 00 00       	mov    $0xa,%edi
  80089d:	e9 e1 00 00 00       	jmp    800983 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	99                   	cltd   
  8008ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	8d 40 04             	lea    0x4(%eax),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b7:	eb b1                	jmp    80086a <vprintfmt+0x291>
	if (lflag >= 2)
  8008b9:	83 f9 01             	cmp    $0x1,%ecx
  8008bc:	7f 27                	jg     8008e5 <vprintfmt+0x30c>
	else if (lflag)
  8008be:	85 c9                	test   %ecx,%ecx
  8008c0:	74 41                	je     800903 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8d 40 04             	lea    0x4(%eax),%eax
  8008d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008db:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008e0:	e9 8d 00 00 00       	jmp    800972 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e8:	8b 50 04             	mov    0x4(%eax),%edx
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	8d 40 08             	lea    0x8(%eax),%eax
  8008f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008fc:	bf 0a 00 00 00       	mov    $0xa,%edi
  800901:	eb 6f                	jmp    800972 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
  80090d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800910:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8d 40 04             	lea    0x4(%eax),%eax
  800919:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80091c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800921:	eb 4f                	jmp    800972 <vprintfmt+0x399>
	if (lflag >= 2)
  800923:	83 f9 01             	cmp    $0x1,%ecx
  800926:	7f 23                	jg     80094b <vprintfmt+0x372>
	else if (lflag)
  800928:	85 c9                	test   %ecx,%ecx
  80092a:	0f 84 98 00 00 00    	je     8009c8 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	ba 00 00 00 00       	mov    $0x0,%edx
  80093a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	8d 40 04             	lea    0x4(%eax),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	eb 17                	jmp    800962 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	8b 50 04             	mov    0x4(%eax),%edx
  800951:	8b 00                	mov    (%eax),%eax
  800953:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800956:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800959:	8b 45 14             	mov    0x14(%ebp),%eax
  80095c:	8d 40 08             	lea    0x8(%eax),%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	53                   	push   %ebx
  800966:	6a 30                	push   $0x30
  800968:	ff d6                	call   *%esi
			goto number;
  80096a:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80096d:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800972:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800976:	74 0b                	je     800983 <vprintfmt+0x3aa>
				putch('+', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	53                   	push   %ebx
  80097c:	6a 2b                	push   $0x2b
  80097e:	ff d6                	call   *%esi
  800980:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800983:	83 ec 0c             	sub    $0xc,%esp
  800986:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	ff 75 e0             	pushl  -0x20(%ebp)
  80098e:	57                   	push   %edi
  80098f:	ff 75 dc             	pushl  -0x24(%ebp)
  800992:	ff 75 d8             	pushl  -0x28(%ebp)
  800995:	89 da                	mov    %ebx,%edx
  800997:	89 f0                	mov    %esi,%eax
  800999:	e8 22 fb ff ff       	call   8004c0 <printnum>
			break;
  80099e:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a4:	83 c7 01             	add    $0x1,%edi
  8009a7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009ab:	83 f8 25             	cmp    $0x25,%eax
  8009ae:	0f 84 3c fc ff ff    	je     8005f0 <vprintfmt+0x17>
			if (ch == '\0')
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	0f 84 55 01 00 00    	je     800b11 <vprintfmt+0x538>
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	53                   	push   %ebx
  8009c0:	50                   	push   %eax
  8009c1:	ff d6                	call   *%esi
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	eb dc                	jmp    8009a4 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	8b 00                	mov    (%eax),%eax
  8009cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009db:	8d 40 04             	lea    0x4(%eax),%eax
  8009de:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e1:	e9 7c ff ff ff       	jmp    800962 <vprintfmt+0x389>
			putch('0', putdat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	53                   	push   %ebx
  8009ea:	6a 30                	push   $0x30
  8009ec:	ff d6                	call   *%esi
			putch('x', putdat);
  8009ee:	83 c4 08             	add    $0x8,%esp
  8009f1:	53                   	push   %ebx
  8009f2:	6a 78                	push   $0x78
  8009f4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800a00:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a03:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a06:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8d 40 04             	lea    0x4(%eax),%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a12:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a17:	e9 56 ff ff ff       	jmp    800972 <vprintfmt+0x399>
	if (lflag >= 2)
  800a1c:	83 f9 01             	cmp    $0x1,%ecx
  800a1f:	7f 27                	jg     800a48 <vprintfmt+0x46f>
	else if (lflag)
  800a21:	85 c9                	test   %ecx,%ecx
  800a23:	74 44                	je     800a69 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a32:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	8d 40 04             	lea    0x4(%eax),%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a3e:	bf 10 00 00 00       	mov    $0x10,%edi
  800a43:	e9 2a ff ff ff       	jmp    800972 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	8b 50 04             	mov    0x4(%eax),%edx
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a53:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	8d 40 08             	lea    0x8(%eax),%eax
  800a5c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5f:	bf 10 00 00 00       	mov    $0x10,%edi
  800a64:	e9 09 ff ff ff       	jmp    800972 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a73:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a76:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	8d 40 04             	lea    0x4(%eax),%eax
  800a7f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a82:	bf 10 00 00 00       	mov    $0x10,%edi
  800a87:	e9 e6 fe ff ff       	jmp    800972 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8f:	8d 78 04             	lea    0x4(%eax),%edi
  800a92:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800a94:	85 c0                	test   %eax,%eax
  800a96:	74 2d                	je     800ac5 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800a98:	0f b6 13             	movzbl (%ebx),%edx
  800a9b:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a9d:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800aa0:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800aa3:	0f 8e f8 fe ff ff    	jle    8009a1 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800aa9:	68 0c 13 80 00       	push   $0x80130c
  800aae:	68 be 11 80 00       	push   $0x8011be
  800ab3:	53                   	push   %ebx
  800ab4:	56                   	push   %esi
  800ab5:	e8 02 fb ff ff       	call   8005bc <printfmt>
  800aba:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800abd:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ac0:	e9 dc fe ff ff       	jmp    8009a1 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800ac5:	68 d4 12 80 00       	push   $0x8012d4
  800aca:	68 be 11 80 00       	push   $0x8011be
  800acf:	53                   	push   %ebx
  800ad0:	56                   	push   %esi
  800ad1:	e8 e6 fa ff ff       	call   8005bc <printfmt>
  800ad6:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ad9:	89 7d 14             	mov    %edi,0x14(%ebp)
  800adc:	e9 c0 fe ff ff       	jmp    8009a1 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	53                   	push   %ebx
  800ae5:	6a 25                	push   $0x25
  800ae7:	ff d6                	call   *%esi
			break;
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	e9 b0 fe ff ff       	jmp    8009a1 <vprintfmt+0x3c8>
			putch('%', putdat);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	53                   	push   %ebx
  800af5:	6a 25                	push   $0x25
  800af7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af9:	83 c4 10             	add    $0x10,%esp
  800afc:	89 f8                	mov    %edi,%eax
  800afe:	eb 03                	jmp    800b03 <vprintfmt+0x52a>
  800b00:	83 e8 01             	sub    $0x1,%eax
  800b03:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b07:	75 f7                	jne    800b00 <vprintfmt+0x527>
  800b09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b0c:	e9 90 fe ff ff       	jmp    8009a1 <vprintfmt+0x3c8>
}
  800b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b14:	5b                   	pop    %ebx
  800b15:	5e                   	pop    %esi
  800b16:	5f                   	pop    %edi
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	83 ec 18             	sub    $0x18,%esp
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b28:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b2c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b36:	85 c0                	test   %eax,%eax
  800b38:	74 26                	je     800b60 <vsnprintf+0x47>
  800b3a:	85 d2                	test   %edx,%edx
  800b3c:	7e 22                	jle    800b60 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b3e:	ff 75 14             	pushl  0x14(%ebp)
  800b41:	ff 75 10             	pushl  0x10(%ebp)
  800b44:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b47:	50                   	push   %eax
  800b48:	68 9f 05 80 00       	push   $0x80059f
  800b4d:	e8 87 fa ff ff       	call   8005d9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b55:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b5b:	83 c4 10             	add    $0x10,%esp
}
  800b5e:	c9                   	leave  
  800b5f:	c3                   	ret    
		return -E_INVAL;
  800b60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b65:	eb f7                	jmp    800b5e <vsnprintf+0x45>

00800b67 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b70:	50                   	push   %eax
  800b71:	ff 75 10             	pushl  0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 9a ff ff ff       	call   800b19 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b90:	74 05                	je     800b97 <strlen+0x16>
		n++;
  800b92:	83 c0 01             	add    $0x1,%eax
  800b95:	eb f5                	jmp    800b8c <strlen+0xb>
	return n;
}
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	39 c2                	cmp    %eax,%edx
  800ba9:	74 0d                	je     800bb8 <strnlen+0x1f>
  800bab:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800baf:	74 05                	je     800bb6 <strnlen+0x1d>
		n++;
  800bb1:	83 c2 01             	add    $0x1,%edx
  800bb4:	eb f1                	jmp    800ba7 <strnlen+0xe>
  800bb6:	89 d0                	mov    %edx,%eax
	return n;
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	53                   	push   %ebx
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bcd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bd0:	83 c2 01             	add    $0x1,%edx
  800bd3:	84 c9                	test   %cl,%cl
  800bd5:	75 f2                	jne    800bc9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bd7:	5b                   	pop    %ebx
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	53                   	push   %ebx
  800bde:	83 ec 10             	sub    $0x10,%esp
  800be1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800be4:	53                   	push   %ebx
  800be5:	e8 97 ff ff ff       	call   800b81 <strlen>
  800bea:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bed:	ff 75 0c             	pushl  0xc(%ebp)
  800bf0:	01 d8                	add    %ebx,%eax
  800bf2:	50                   	push   %eax
  800bf3:	e8 c2 ff ff ff       	call   800bba <strcpy>
	return dst;
}
  800bf8:	89 d8                	mov    %ebx,%eax
  800bfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0a:	89 c6                	mov    %eax,%esi
  800c0c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	39 f2                	cmp    %esi,%edx
  800c13:	74 11                	je     800c26 <strncpy+0x27>
		*dst++ = *src;
  800c15:	83 c2 01             	add    $0x1,%edx
  800c18:	0f b6 19             	movzbl (%ecx),%ebx
  800c1b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c1e:	80 fb 01             	cmp    $0x1,%bl
  800c21:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c24:	eb eb                	jmp    800c11 <strncpy+0x12>
	}
	return ret;
}
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
  800c2f:	8b 75 08             	mov    0x8(%ebp),%esi
  800c32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c35:	8b 55 10             	mov    0x10(%ebp),%edx
  800c38:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c3a:	85 d2                	test   %edx,%edx
  800c3c:	74 21                	je     800c5f <strlcpy+0x35>
  800c3e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c42:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c44:	39 c2                	cmp    %eax,%edx
  800c46:	74 14                	je     800c5c <strlcpy+0x32>
  800c48:	0f b6 19             	movzbl (%ecx),%ebx
  800c4b:	84 db                	test   %bl,%bl
  800c4d:	74 0b                	je     800c5a <strlcpy+0x30>
			*dst++ = *src++;
  800c4f:	83 c1 01             	add    $0x1,%ecx
  800c52:	83 c2 01             	add    $0x1,%edx
  800c55:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c58:	eb ea                	jmp    800c44 <strlcpy+0x1a>
  800c5a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c5f:	29 f0                	sub    %esi,%eax
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c6e:	0f b6 01             	movzbl (%ecx),%eax
  800c71:	84 c0                	test   %al,%al
  800c73:	74 0c                	je     800c81 <strcmp+0x1c>
  800c75:	3a 02                	cmp    (%edx),%al
  800c77:	75 08                	jne    800c81 <strcmp+0x1c>
		p++, q++;
  800c79:	83 c1 01             	add    $0x1,%ecx
  800c7c:	83 c2 01             	add    $0x1,%edx
  800c7f:	eb ed                	jmp    800c6e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c81:	0f b6 c0             	movzbl %al,%eax
  800c84:	0f b6 12             	movzbl (%edx),%edx
  800c87:	29 d0                	sub    %edx,%eax
}
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	53                   	push   %ebx
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c95:	89 c3                	mov    %eax,%ebx
  800c97:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c9a:	eb 06                	jmp    800ca2 <strncmp+0x17>
		n--, p++, q++;
  800c9c:	83 c0 01             	add    $0x1,%eax
  800c9f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ca2:	39 d8                	cmp    %ebx,%eax
  800ca4:	74 16                	je     800cbc <strncmp+0x31>
  800ca6:	0f b6 08             	movzbl (%eax),%ecx
  800ca9:	84 c9                	test   %cl,%cl
  800cab:	74 04                	je     800cb1 <strncmp+0x26>
  800cad:	3a 0a                	cmp    (%edx),%cl
  800caf:	74 eb                	je     800c9c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb1:	0f b6 00             	movzbl (%eax),%eax
  800cb4:	0f b6 12             	movzbl (%edx),%edx
  800cb7:	29 d0                	sub    %edx,%eax
}
  800cb9:	5b                   	pop    %ebx
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    
		return 0;
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc1:	eb f6                	jmp    800cb9 <strncmp+0x2e>

00800cc3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ccd:	0f b6 10             	movzbl (%eax),%edx
  800cd0:	84 d2                	test   %dl,%dl
  800cd2:	74 09                	je     800cdd <strchr+0x1a>
		if (*s == c)
  800cd4:	38 ca                	cmp    %cl,%dl
  800cd6:	74 0a                	je     800ce2 <strchr+0x1f>
	for (; *s; s++)
  800cd8:	83 c0 01             	add    $0x1,%eax
  800cdb:	eb f0                	jmp    800ccd <strchr+0xa>
			return (char *) s;
	return 0;
  800cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cee:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cf1:	38 ca                	cmp    %cl,%dl
  800cf3:	74 09                	je     800cfe <strfind+0x1a>
  800cf5:	84 d2                	test   %dl,%dl
  800cf7:	74 05                	je     800cfe <strfind+0x1a>
	for (; *s; s++)
  800cf9:	83 c0 01             	add    $0x1,%eax
  800cfc:	eb f0                	jmp    800cee <strfind+0xa>
			break;
	return (char *) s;
}
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d0c:	85 c9                	test   %ecx,%ecx
  800d0e:	74 31                	je     800d41 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d10:	89 f8                	mov    %edi,%eax
  800d12:	09 c8                	or     %ecx,%eax
  800d14:	a8 03                	test   $0x3,%al
  800d16:	75 23                	jne    800d3b <memset+0x3b>
		c &= 0xFF;
  800d18:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d1c:	89 d3                	mov    %edx,%ebx
  800d1e:	c1 e3 08             	shl    $0x8,%ebx
  800d21:	89 d0                	mov    %edx,%eax
  800d23:	c1 e0 18             	shl    $0x18,%eax
  800d26:	89 d6                	mov    %edx,%esi
  800d28:	c1 e6 10             	shl    $0x10,%esi
  800d2b:	09 f0                	or     %esi,%eax
  800d2d:	09 c2                	or     %eax,%edx
  800d2f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d31:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d34:	89 d0                	mov    %edx,%eax
  800d36:	fc                   	cld    
  800d37:	f3 ab                	rep stos %eax,%es:(%edi)
  800d39:	eb 06                	jmp    800d41 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	fc                   	cld    
  800d3f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d41:	89 f8                	mov    %edi,%eax
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d53:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d56:	39 c6                	cmp    %eax,%esi
  800d58:	73 32                	jae    800d8c <memmove+0x44>
  800d5a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d5d:	39 c2                	cmp    %eax,%edx
  800d5f:	76 2b                	jbe    800d8c <memmove+0x44>
		s += n;
		d += n;
  800d61:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d64:	89 fe                	mov    %edi,%esi
  800d66:	09 ce                	or     %ecx,%esi
  800d68:	09 d6                	or     %edx,%esi
  800d6a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d70:	75 0e                	jne    800d80 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d72:	83 ef 04             	sub    $0x4,%edi
  800d75:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d78:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d7b:	fd                   	std    
  800d7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d7e:	eb 09                	jmp    800d89 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d80:	83 ef 01             	sub    $0x1,%edi
  800d83:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d86:	fd                   	std    
  800d87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d89:	fc                   	cld    
  800d8a:	eb 1a                	jmp    800da6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8c:	89 c2                	mov    %eax,%edx
  800d8e:	09 ca                	or     %ecx,%edx
  800d90:	09 f2                	or     %esi,%edx
  800d92:	f6 c2 03             	test   $0x3,%dl
  800d95:	75 0a                	jne    800da1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d97:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d9a:	89 c7                	mov    %eax,%edi
  800d9c:	fc                   	cld    
  800d9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d9f:	eb 05                	jmp    800da6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800da1:	89 c7                	mov    %eax,%edi
  800da3:	fc                   	cld    
  800da4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800db0:	ff 75 10             	pushl  0x10(%ebp)
  800db3:	ff 75 0c             	pushl  0xc(%ebp)
  800db6:	ff 75 08             	pushl  0x8(%ebp)
  800db9:	e8 8a ff ff ff       	call   800d48 <memmove>
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcb:	89 c6                	mov    %eax,%esi
  800dcd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dd0:	39 f0                	cmp    %esi,%eax
  800dd2:	74 1c                	je     800df0 <memcmp+0x30>
		if (*s1 != *s2)
  800dd4:	0f b6 08             	movzbl (%eax),%ecx
  800dd7:	0f b6 1a             	movzbl (%edx),%ebx
  800dda:	38 d9                	cmp    %bl,%cl
  800ddc:	75 08                	jne    800de6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dde:	83 c0 01             	add    $0x1,%eax
  800de1:	83 c2 01             	add    $0x1,%edx
  800de4:	eb ea                	jmp    800dd0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800de6:	0f b6 c1             	movzbl %cl,%eax
  800de9:	0f b6 db             	movzbl %bl,%ebx
  800dec:	29 d8                	sub    %ebx,%eax
  800dee:	eb 05                	jmp    800df5 <memcmp+0x35>
	}

	return 0;
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e02:	89 c2                	mov    %eax,%edx
  800e04:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e07:	39 d0                	cmp    %edx,%eax
  800e09:	73 09                	jae    800e14 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e0b:	38 08                	cmp    %cl,(%eax)
  800e0d:	74 05                	je     800e14 <memfind+0x1b>
	for (; s < ends; s++)
  800e0f:	83 c0 01             	add    $0x1,%eax
  800e12:	eb f3                	jmp    800e07 <memfind+0xe>
			break;
	return (void *) s;
}
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e22:	eb 03                	jmp    800e27 <strtol+0x11>
		s++;
  800e24:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e27:	0f b6 01             	movzbl (%ecx),%eax
  800e2a:	3c 20                	cmp    $0x20,%al
  800e2c:	74 f6                	je     800e24 <strtol+0xe>
  800e2e:	3c 09                	cmp    $0x9,%al
  800e30:	74 f2                	je     800e24 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e32:	3c 2b                	cmp    $0x2b,%al
  800e34:	74 2a                	je     800e60 <strtol+0x4a>
	int neg = 0;
  800e36:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e3b:	3c 2d                	cmp    $0x2d,%al
  800e3d:	74 2b                	je     800e6a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e3f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e45:	75 0f                	jne    800e56 <strtol+0x40>
  800e47:	80 39 30             	cmpb   $0x30,(%ecx)
  800e4a:	74 28                	je     800e74 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e53:	0f 44 d8             	cmove  %eax,%ebx
  800e56:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e5e:	eb 50                	jmp    800eb0 <strtol+0x9a>
		s++;
  800e60:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e63:	bf 00 00 00 00       	mov    $0x0,%edi
  800e68:	eb d5                	jmp    800e3f <strtol+0x29>
		s++, neg = 1;
  800e6a:	83 c1 01             	add    $0x1,%ecx
  800e6d:	bf 01 00 00 00       	mov    $0x1,%edi
  800e72:	eb cb                	jmp    800e3f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e74:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e78:	74 0e                	je     800e88 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e7a:	85 db                	test   %ebx,%ebx
  800e7c:	75 d8                	jne    800e56 <strtol+0x40>
		s++, base = 8;
  800e7e:	83 c1 01             	add    $0x1,%ecx
  800e81:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e86:	eb ce                	jmp    800e56 <strtol+0x40>
		s += 2, base = 16;
  800e88:	83 c1 02             	add    $0x2,%ecx
  800e8b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e90:	eb c4                	jmp    800e56 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e92:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e95:	89 f3                	mov    %esi,%ebx
  800e97:	80 fb 19             	cmp    $0x19,%bl
  800e9a:	77 29                	ja     800ec5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e9c:	0f be d2             	movsbl %dl,%edx
  800e9f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ea2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ea5:	7d 30                	jge    800ed7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ea7:	83 c1 01             	add    $0x1,%ecx
  800eaa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800eb0:	0f b6 11             	movzbl (%ecx),%edx
  800eb3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800eb6:	89 f3                	mov    %esi,%ebx
  800eb8:	80 fb 09             	cmp    $0x9,%bl
  800ebb:	77 d5                	ja     800e92 <strtol+0x7c>
			dig = *s - '0';
  800ebd:	0f be d2             	movsbl %dl,%edx
  800ec0:	83 ea 30             	sub    $0x30,%edx
  800ec3:	eb dd                	jmp    800ea2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ec5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ec8:	89 f3                	mov    %esi,%ebx
  800eca:	80 fb 19             	cmp    $0x19,%bl
  800ecd:	77 08                	ja     800ed7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ecf:	0f be d2             	movsbl %dl,%edx
  800ed2:	83 ea 37             	sub    $0x37,%edx
  800ed5:	eb cb                	jmp    800ea2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ed7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800edb:	74 05                	je     800ee2 <strtol+0xcc>
		*endptr = (char *) s;
  800edd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ee0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ee2:	89 c2                	mov    %eax,%edx
  800ee4:	f7 da                	neg    %edx
  800ee6:	85 ff                	test   %edi,%edi
  800ee8:	0f 45 c2             	cmovne %edx,%eax
}
  800eeb:	5b                   	pop    %ebx
  800eec:	5e                   	pop    %esi
  800eed:	5f                   	pop    %edi
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

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
