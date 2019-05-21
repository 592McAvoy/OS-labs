
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 20 80 00    	pushl  0x802000
  800044:	e8 60 00 00 00       	call   8000a9 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 c9 00 00 00       	call   800127 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800066:	c1 e0 04             	shl    $0x4,%eax
  800069:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006e:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800073:	85 db                	test   %ebx,%ebx
  800075:	7e 07                	jle    80007e <libmain+0x30>
		binaryname = argv[0];
  800077:	8b 06                	mov    (%esi),%eax
  800079:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	umain(argc, argv);
  80007e:	83 ec 08             	sub    $0x8,%esp
  800081:	56                   	push   %esi
  800082:	53                   	push   %ebx
  800083:	e8 ab ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800088:	e8 0a 00 00 00       	call   800097 <exit>
}
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800093:	5b                   	pop    %ebx
  800094:	5e                   	pop    %esi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    

00800097 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800097:	55                   	push   %ebp
  800098:	89 e5                	mov    %esp,%ebp
  80009a:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  80009d:	6a 00                	push   $0x0
  80009f:	e8 42 00 00 00       	call   8000e6 <sys_env_destroy>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	c9                   	leave  
  8000a8:	c3                   	ret    

008000a9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	57                   	push   %edi
  8000ad:	56                   	push   %esi
  8000ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ba:	89 c3                	mov    %eax,%ebx
  8000bc:	89 c7                	mov    %eax,%edi
  8000be:	89 c6                	mov    %eax,%esi
  8000c0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5f                   	pop    %edi
  8000c5:	5d                   	pop    %ebp
  8000c6:	c3                   	ret    

008000c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	57                   	push   %edi
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d7:	89 d1                	mov    %edx,%ecx
  8000d9:	89 d3                	mov    %edx,%ebx
  8000db:	89 d7                	mov    %edx,%edi
  8000dd:	89 d6                	mov    %edx,%esi
  8000df:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e1:	5b                   	pop    %ebx
  8000e2:	5e                   	pop    %esi
  8000e3:	5f                   	pop    %edi
  8000e4:	5d                   	pop    %ebp
  8000e5:	c3                   	ret    

008000e6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	57                   	push   %edi
  8000ea:	56                   	push   %esi
  8000eb:	53                   	push   %ebx
  8000ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fc:	89 cb                	mov    %ecx,%ebx
  8000fe:	89 cf                	mov    %ecx,%edi
  800100:	89 ce                	mov    %ecx,%esi
  800102:	cd 30                	int    $0x30
	if(check && ret > 0)
  800104:	85 c0                	test   %eax,%eax
  800106:	7f 08                	jg     800110 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010b:	5b                   	pop    %ebx
  80010c:	5e                   	pop    %esi
  80010d:	5f                   	pop    %edi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	6a 03                	push   $0x3
  800116:	68 78 11 80 00       	push   $0x801178
  80011b:	6a 33                	push   $0x33
  80011d:	68 95 11 80 00       	push   $0x801195
  800122:	e8 b1 02 00 00       	call   8003d8 <_panic>

00800127 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	57                   	push   %edi
  80012b:	56                   	push   %esi
  80012c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012d:	ba 00 00 00 00       	mov    $0x0,%edx
  800132:	b8 02 00 00 00       	mov    $0x2,%eax
  800137:	89 d1                	mov    %edx,%ecx
  800139:	89 d3                	mov    %edx,%ebx
  80013b:	89 d7                	mov    %edx,%edi
  80013d:	89 d6                	mov    %edx,%esi
  80013f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800141:	5b                   	pop    %ebx
  800142:	5e                   	pop    %esi
  800143:	5f                   	pop    %edi
  800144:	5d                   	pop    %ebp
  800145:	c3                   	ret    

00800146 <sys_yield>:

void
sys_yield(void)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	57                   	push   %edi
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014c:	ba 00 00 00 00       	mov    $0x0,%edx
  800151:	b8 0c 00 00 00       	mov    $0xc,%eax
  800156:	89 d1                	mov    %edx,%ecx
  800158:	89 d3                	mov    %edx,%ebx
  80015a:	89 d7                	mov    %edx,%edi
  80015c:	89 d6                	mov    %edx,%esi
  80015e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	57                   	push   %edi
  800169:	56                   	push   %esi
  80016a:	53                   	push   %ebx
  80016b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016e:	be 00 00 00 00       	mov    $0x0,%esi
  800173:	8b 55 08             	mov    0x8(%ebp),%edx
  800176:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800179:	b8 04 00 00 00       	mov    $0x4,%eax
  80017e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800181:	89 f7                	mov    %esi,%edi
  800183:	cd 30                	int    $0x30
	if(check && ret > 0)
  800185:	85 c0                	test   %eax,%eax
  800187:	7f 08                	jg     800191 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018c:	5b                   	pop    %ebx
  80018d:	5e                   	pop    %esi
  80018e:	5f                   	pop    %edi
  80018f:	5d                   	pop    %ebp
  800190:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	50                   	push   %eax
  800195:	6a 04                	push   $0x4
  800197:	68 78 11 80 00       	push   $0x801178
  80019c:	6a 33                	push   $0x33
  80019e:	68 95 11 80 00       	push   $0x801195
  8001a3:	e8 30 02 00 00       	call   8003d8 <_panic>

008001a8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	57                   	push   %edi
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	7f 08                	jg     8001d3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ce:	5b                   	pop    %ebx
  8001cf:	5e                   	pop    %esi
  8001d0:	5f                   	pop    %edi
  8001d1:	5d                   	pop    %ebp
  8001d2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	50                   	push   %eax
  8001d7:	6a 05                	push   $0x5
  8001d9:	68 78 11 80 00       	push   $0x801178
  8001de:	6a 33                	push   $0x33
  8001e0:	68 95 11 80 00       	push   $0x801195
  8001e5:	e8 ee 01 00 00       	call   8003d8 <_panic>

008001ea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	57                   	push   %edi
  8001ee:	56                   	push   %esi
  8001ef:	53                   	push   %ebx
  8001f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fe:	b8 06 00 00 00       	mov    $0x6,%eax
  800203:	89 df                	mov    %ebx,%edi
  800205:	89 de                	mov    %ebx,%esi
  800207:	cd 30                	int    $0x30
	if(check && ret > 0)
  800209:	85 c0                	test   %eax,%eax
  80020b:	7f 08                	jg     800215 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800210:	5b                   	pop    %ebx
  800211:	5e                   	pop    %esi
  800212:	5f                   	pop    %edi
  800213:	5d                   	pop    %ebp
  800214:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	6a 06                	push   $0x6
  80021b:	68 78 11 80 00       	push   $0x801178
  800220:	6a 33                	push   $0x33
  800222:	68 95 11 80 00       	push   $0x801195
  800227:	e8 ac 01 00 00       	call   8003d8 <_panic>

0080022c <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	57                   	push   %edi
  800230:	56                   	push   %esi
  800231:	53                   	push   %ebx
  800232:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800235:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023a:	8b 55 08             	mov    0x8(%ebp),%edx
  80023d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800242:	89 cb                	mov    %ecx,%ebx
  800244:	89 cf                	mov    %ecx,%edi
  800246:	89 ce                	mov    %ecx,%esi
  800248:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024a:	85 c0                	test   %eax,%eax
  80024c:	7f 08                	jg     800256 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  80024e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800251:	5b                   	pop    %ebx
  800252:	5e                   	pop    %esi
  800253:	5f                   	pop    %edi
  800254:	5d                   	pop    %ebp
  800255:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	6a 0b                	push   $0xb
  80025c:	68 78 11 80 00       	push   $0x801178
  800261:	6a 33                	push   $0x33
  800263:	68 95 11 80 00       	push   $0x801195
  800268:	e8 6b 01 00 00       	call   8003d8 <_panic>

0080026d <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	57                   	push   %edi
  800271:	56                   	push   %esi
  800272:	53                   	push   %ebx
  800273:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800276:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027b:	8b 55 08             	mov    0x8(%ebp),%edx
  80027e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800281:	b8 08 00 00 00       	mov    $0x8,%eax
  800286:	89 df                	mov    %ebx,%edi
  800288:	89 de                	mov    %ebx,%esi
  80028a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028c:	85 c0                	test   %eax,%eax
  80028e:	7f 08                	jg     800298 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800293:	5b                   	pop    %ebx
  800294:	5e                   	pop    %esi
  800295:	5f                   	pop    %edi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	50                   	push   %eax
  80029c:	6a 08                	push   $0x8
  80029e:	68 78 11 80 00       	push   $0x801178
  8002a3:	6a 33                	push   $0x33
  8002a5:	68 95 11 80 00       	push   $0x801195
  8002aa:	e8 29 01 00 00       	call   8003d8 <_panic>

008002af <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	57                   	push   %edi
  8002b3:	56                   	push   %esi
  8002b4:	53                   	push   %ebx
  8002b5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c3:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c8:	89 df                	mov    %ebx,%edi
  8002ca:	89 de                	mov    %ebx,%esi
  8002cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ce:	85 c0                	test   %eax,%eax
  8002d0:	7f 08                	jg     8002da <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d5:	5b                   	pop    %ebx
  8002d6:	5e                   	pop    %esi
  8002d7:	5f                   	pop    %edi
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	50                   	push   %eax
  8002de:	6a 09                	push   $0x9
  8002e0:	68 78 11 80 00       	push   $0x801178
  8002e5:	6a 33                	push   $0x33
  8002e7:	68 95 11 80 00       	push   $0x801195
  8002ec:	e8 e7 00 00 00       	call   8003d8 <_panic>

008002f1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	57                   	push   %edi
  8002f5:	56                   	push   %esi
  8002f6:	53                   	push   %ebx
  8002f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800302:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800305:	b8 0a 00 00 00       	mov    $0xa,%eax
  80030a:	89 df                	mov    %ebx,%edi
  80030c:	89 de                	mov    %ebx,%esi
  80030e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800310:	85 c0                	test   %eax,%eax
  800312:	7f 08                	jg     80031c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800314:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800317:	5b                   	pop    %ebx
  800318:	5e                   	pop    %esi
  800319:	5f                   	pop    %edi
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	50                   	push   %eax
  800320:	6a 0a                	push   $0xa
  800322:	68 78 11 80 00       	push   $0x801178
  800327:	6a 33                	push   $0x33
  800329:	68 95 11 80 00       	push   $0x801195
  80032e:	e8 a5 00 00 00       	call   8003d8 <_panic>

00800333 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	57                   	push   %edi
  800337:	56                   	push   %esi
  800338:	53                   	push   %ebx
	asm volatile("int %1\n"
  800339:	8b 55 08             	mov    0x8(%ebp),%edx
  80033c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800344:	be 00 00 00 00       	mov    $0x0,%esi
  800349:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80034c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	57                   	push   %edi
  80035a:	56                   	push   %esi
  80035b:	53                   	push   %ebx
  80035c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800364:	8b 55 08             	mov    0x8(%ebp),%edx
  800367:	b8 0e 00 00 00       	mov    $0xe,%eax
  80036c:	89 cb                	mov    %ecx,%ebx
  80036e:	89 cf                	mov    %ecx,%edi
  800370:	89 ce                	mov    %ecx,%esi
  800372:	cd 30                	int    $0x30
	if(check && ret > 0)
  800374:	85 c0                	test   %eax,%eax
  800376:	7f 08                	jg     800380 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037b:	5b                   	pop    %ebx
  80037c:	5e                   	pop    %esi
  80037d:	5f                   	pop    %edi
  80037e:	5d                   	pop    %ebp
  80037f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800380:	83 ec 0c             	sub    $0xc,%esp
  800383:	50                   	push   %eax
  800384:	6a 0e                	push   $0xe
  800386:	68 78 11 80 00       	push   $0x801178
  80038b:	6a 33                	push   $0x33
  80038d:	68 95 11 80 00       	push   $0x801195
  800392:	e8 41 00 00 00       	call   8003d8 <_panic>

00800397 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	57                   	push   %edi
  80039b:	56                   	push   %esi
  80039c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80039d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003ad:	89 df                	mov    %ebx,%edi
  8003af:	89 de                	mov    %ebx,%esi
  8003b1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003b3:	5b                   	pop    %ebx
  8003b4:	5e                   	pop    %esi
  8003b5:	5f                   	pop    %edi
  8003b6:	5d                   	pop    %ebp
  8003b7:	c3                   	ret    

008003b8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	57                   	push   %edi
  8003bc:	56                   	push   %esi
  8003bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8003cb:	89 cb                	mov    %ecx,%ebx
  8003cd:	89 cf                	mov    %ecx,%edi
  8003cf:	89 ce                	mov    %ecx,%esi
  8003d1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003d3:	5b                   	pop    %ebx
  8003d4:	5e                   	pop    %esi
  8003d5:	5f                   	pop    %edi
  8003d6:	5d                   	pop    %ebp
  8003d7:	c3                   	ret    

008003d8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	56                   	push   %esi
  8003dc:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003dd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003e0:	8b 35 04 20 80 00    	mov    0x802004,%esi
  8003e6:	e8 3c fd ff ff       	call   800127 <sys_getenvid>
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	ff 75 0c             	pushl  0xc(%ebp)
  8003f1:	ff 75 08             	pushl  0x8(%ebp)
  8003f4:	56                   	push   %esi
  8003f5:	50                   	push   %eax
  8003f6:	68 a4 11 80 00       	push   $0x8011a4
  8003fb:	e8 b3 00 00 00       	call   8004b3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800400:	83 c4 18             	add    $0x18,%esp
  800403:	53                   	push   %ebx
  800404:	ff 75 10             	pushl  0x10(%ebp)
  800407:	e8 56 00 00 00       	call   800462 <vcprintf>
	cprintf("\n");
  80040c:	c7 04 24 6c 11 80 00 	movl   $0x80116c,(%esp)
  800413:	e8 9b 00 00 00       	call   8004b3 <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80041b:	cc                   	int3   
  80041c:	eb fd                	jmp    80041b <_panic+0x43>

0080041e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	53                   	push   %ebx
  800422:	83 ec 04             	sub    $0x4,%esp
  800425:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800428:	8b 13                	mov    (%ebx),%edx
  80042a:	8d 42 01             	lea    0x1(%edx),%eax
  80042d:	89 03                	mov    %eax,(%ebx)
  80042f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800432:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800436:	3d ff 00 00 00       	cmp    $0xff,%eax
  80043b:	74 09                	je     800446 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80043d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800444:	c9                   	leave  
  800445:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	68 ff 00 00 00       	push   $0xff
  80044e:	8d 43 08             	lea    0x8(%ebx),%eax
  800451:	50                   	push   %eax
  800452:	e8 52 fc ff ff       	call   8000a9 <sys_cputs>
		b->idx = 0;
  800457:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80045d:	83 c4 10             	add    $0x10,%esp
  800460:	eb db                	jmp    80043d <putch+0x1f>

00800462 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80046b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800472:	00 00 00 
	b.cnt = 0;
  800475:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80047c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80047f:	ff 75 0c             	pushl  0xc(%ebp)
  800482:	ff 75 08             	pushl  0x8(%ebp)
  800485:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80048b:	50                   	push   %eax
  80048c:	68 1e 04 80 00       	push   $0x80041e
  800491:	e8 4a 01 00 00       	call   8005e0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800496:	83 c4 08             	add    $0x8,%esp
  800499:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80049f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 fe fb ff ff       	call   8000a9 <sys_cputs>

	return b.cnt;
}
  8004ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004b9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004bc:	50                   	push   %eax
  8004bd:	ff 75 08             	pushl  0x8(%ebp)
  8004c0:	e8 9d ff ff ff       	call   800462 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	57                   	push   %edi
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 1c             	sub    $0x1c,%esp
  8004d0:	89 c6                	mov    %eax,%esi
  8004d2:	89 d7                	mov    %edx,%edi
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004e6:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004ea:	74 2c                	je     800518 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004f9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004fc:	39 c2                	cmp    %eax,%edx
  8004fe:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800501:	73 43                	jae    800546 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800503:	83 eb 01             	sub    $0x1,%ebx
  800506:	85 db                	test   %ebx,%ebx
  800508:	7e 6c                	jle    800576 <printnum+0xaf>
			putch(padc, putdat);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	57                   	push   %edi
  80050e:	ff 75 18             	pushl  0x18(%ebp)
  800511:	ff d6                	call   *%esi
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	eb eb                	jmp    800503 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	6a 20                	push   $0x20
  80051d:	6a 00                	push   $0x0
  80051f:	50                   	push   %eax
  800520:	ff 75 e4             	pushl  -0x1c(%ebp)
  800523:	ff 75 e0             	pushl  -0x20(%ebp)
  800526:	89 fa                	mov    %edi,%edx
  800528:	89 f0                	mov    %esi,%eax
  80052a:	e8 98 ff ff ff       	call   8004c7 <printnum>
		while (--width > 0)
  80052f:	83 c4 20             	add    $0x20,%esp
  800532:	83 eb 01             	sub    $0x1,%ebx
  800535:	85 db                	test   %ebx,%ebx
  800537:	7e 65                	jle    80059e <printnum+0xd7>
			putch(padc, putdat);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	57                   	push   %edi
  80053d:	6a 20                	push   $0x20
  80053f:	ff d6                	call   *%esi
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	eb ec                	jmp    800532 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	ff 75 18             	pushl  0x18(%ebp)
  80054c:	83 eb 01             	sub    $0x1,%ebx
  80054f:	53                   	push   %ebx
  800550:	50                   	push   %eax
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	ff 75 dc             	pushl  -0x24(%ebp)
  800557:	ff 75 d8             	pushl  -0x28(%ebp)
  80055a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80055d:	ff 75 e0             	pushl  -0x20(%ebp)
  800560:	e8 9b 09 00 00       	call   800f00 <__udivdi3>
  800565:	83 c4 18             	add    $0x18,%esp
  800568:	52                   	push   %edx
  800569:	50                   	push   %eax
  80056a:	89 fa                	mov    %edi,%edx
  80056c:	89 f0                	mov    %esi,%eax
  80056e:	e8 54 ff ff ff       	call   8004c7 <printnum>
  800573:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	57                   	push   %edi
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	ff 75 dc             	pushl  -0x24(%ebp)
  800580:	ff 75 d8             	pushl  -0x28(%ebp)
  800583:	ff 75 e4             	pushl  -0x1c(%ebp)
  800586:	ff 75 e0             	pushl  -0x20(%ebp)
  800589:	e8 82 0a 00 00       	call   801010 <__umoddi3>
  80058e:	83 c4 14             	add    $0x14,%esp
  800591:	0f be 80 c7 11 80 00 	movsbl 0x8011c7(%eax),%eax
  800598:	50                   	push   %eax
  800599:	ff d6                	call   *%esi
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005a1:	5b                   	pop    %ebx
  8005a2:	5e                   	pop    %esi
  8005a3:	5f                   	pop    %edi
  8005a4:	5d                   	pop    %ebp
  8005a5:	c3                   	ret    

008005a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005a6:	55                   	push   %ebp
  8005a7:	89 e5                	mov    %esp,%ebp
  8005a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005ac:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005b0:	8b 10                	mov    (%eax),%edx
  8005b2:	3b 50 04             	cmp    0x4(%eax),%edx
  8005b5:	73 0a                	jae    8005c1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005ba:	89 08                	mov    %ecx,(%eax)
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	88 02                	mov    %al,(%edx)
}
  8005c1:	5d                   	pop    %ebp
  8005c2:	c3                   	ret    

008005c3 <printfmt>:
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005c9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 10             	pushl  0x10(%ebp)
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	e8 05 00 00 00       	call   8005e0 <vprintfmt>
}
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <vprintfmt>:
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	57                   	push   %edi
  8005e4:	56                   	push   %esi
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 3c             	sub    $0x3c,%esp
  8005e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005f2:	e9 b4 03 00 00       	jmp    8009ab <vprintfmt+0x3cb>
		padc = ' ';
  8005f7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8005fb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800602:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800609:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800610:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800617:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80061c:	8d 47 01             	lea    0x1(%edi),%eax
  80061f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800622:	0f b6 17             	movzbl (%edi),%edx
  800625:	8d 42 dd             	lea    -0x23(%edx),%eax
  800628:	3c 55                	cmp    $0x55,%al
  80062a:	0f 87 c8 04 00 00    	ja     800af8 <vprintfmt+0x518>
  800630:	0f b6 c0             	movzbl %al,%eax
  800633:	ff 24 85 a0 13 80 00 	jmp    *0x8013a0(,%eax,4)
  80063a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80063d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800644:	eb d6                	jmp    80061c <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800646:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800649:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80064d:	eb cd                	jmp    80061c <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80064f:	0f b6 d2             	movzbl %dl,%edx
  800652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800655:	b8 00 00 00 00       	mov    $0x0,%eax
  80065a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80065d:	eb 0c                	jmp    80066b <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80065f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800662:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800666:	eb b4                	jmp    80061c <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800668:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80066b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80066e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800672:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800675:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800678:	83 f9 09             	cmp    $0x9,%ecx
  80067b:	76 eb                	jbe    800668 <vprintfmt+0x88>
  80067d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800680:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800683:	eb 14                	jmp    800699 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800696:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800699:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069d:	0f 89 79 ff ff ff    	jns    80061c <vprintfmt+0x3c>
				width = precision, precision = -1;
  8006a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006b0:	e9 67 ff ff ff       	jmp    80061c <vprintfmt+0x3c>
  8006b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b8:	85 c0                	test   %eax,%eax
  8006ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bf:	0f 49 d0             	cmovns %eax,%edx
  8006c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006c8:	e9 4f ff ff ff       	jmp    80061c <vprintfmt+0x3c>
  8006cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006d0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006d7:	e9 40 ff ff ff       	jmp    80061c <vprintfmt+0x3c>
			lflag++;
  8006dc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006e2:	e9 35 ff ff ff       	jmp    80061c <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 78 04             	lea    0x4(%eax),%edi
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	ff 30                	pushl  (%eax)
  8006f3:	ff d6                	call   *%esi
			break;
  8006f5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006f8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006fb:	e9 a8 02 00 00       	jmp    8009a8 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 78 04             	lea    0x4(%eax),%edi
  800706:	8b 00                	mov    (%eax),%eax
  800708:	99                   	cltd   
  800709:	31 d0                	xor    %edx,%eax
  80070b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80070d:	83 f8 0f             	cmp    $0xf,%eax
  800710:	7f 23                	jg     800735 <vprintfmt+0x155>
  800712:	8b 14 85 00 15 80 00 	mov    0x801500(,%eax,4),%edx
  800719:	85 d2                	test   %edx,%edx
  80071b:	74 18                	je     800735 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80071d:	52                   	push   %edx
  80071e:	68 e8 11 80 00       	push   $0x8011e8
  800723:	53                   	push   %ebx
  800724:	56                   	push   %esi
  800725:	e8 99 fe ff ff       	call   8005c3 <printfmt>
  80072a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80072d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800730:	e9 73 02 00 00       	jmp    8009a8 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800735:	50                   	push   %eax
  800736:	68 df 11 80 00       	push   $0x8011df
  80073b:	53                   	push   %ebx
  80073c:	56                   	push   %esi
  80073d:	e8 81 fe ff ff       	call   8005c3 <printfmt>
  800742:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800745:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800748:	e9 5b 02 00 00       	jmp    8009a8 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	83 c0 04             	add    $0x4,%eax
  800753:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80075b:	85 d2                	test   %edx,%edx
  80075d:	b8 d8 11 80 00       	mov    $0x8011d8,%eax
  800762:	0f 45 c2             	cmovne %edx,%eax
  800765:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800768:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076c:	7e 06                	jle    800774 <vprintfmt+0x194>
  80076e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800772:	75 0d                	jne    800781 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800774:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800777:	89 c7                	mov    %eax,%edi
  800779:	03 45 e0             	add    -0x20(%ebp),%eax
  80077c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077f:	eb 53                	jmp    8007d4 <vprintfmt+0x1f4>
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 d8             	pushl  -0x28(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 13 04 00 00       	call   800ba0 <strnlen>
  80078d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800790:	29 c1                	sub    %eax,%ecx
  800792:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80079a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80079e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a1:	eb 0f                	jmp    8007b2 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8007aa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ac:	83 ef 01             	sub    $0x1,%edi
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	85 ff                	test   %edi,%edi
  8007b4:	7f ed                	jg     8007a3 <vprintfmt+0x1c3>
  8007b6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007b9:	85 d2                	test   %edx,%edx
  8007bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c0:	0f 49 c2             	cmovns %edx,%eax
  8007c3:	29 c2                	sub    %eax,%edx
  8007c5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007c8:	eb aa                	jmp    800774 <vprintfmt+0x194>
					putch(ch, putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	52                   	push   %edx
  8007cf:	ff d6                	call   *%esi
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007d7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d9:	83 c7 01             	add    $0x1,%edi
  8007dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e0:	0f be d0             	movsbl %al,%edx
  8007e3:	85 d2                	test   %edx,%edx
  8007e5:	74 4b                	je     800832 <vprintfmt+0x252>
  8007e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007eb:	78 06                	js     8007f3 <vprintfmt+0x213>
  8007ed:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007f1:	78 1e                	js     800811 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8007f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007f7:	74 d1                	je     8007ca <vprintfmt+0x1ea>
  8007f9:	0f be c0             	movsbl %al,%eax
  8007fc:	83 e8 20             	sub    $0x20,%eax
  8007ff:	83 f8 5e             	cmp    $0x5e,%eax
  800802:	76 c6                	jbe    8007ca <vprintfmt+0x1ea>
					putch('?', putdat);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	53                   	push   %ebx
  800808:	6a 3f                	push   $0x3f
  80080a:	ff d6                	call   *%esi
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	eb c3                	jmp    8007d4 <vprintfmt+0x1f4>
  800811:	89 cf                	mov    %ecx,%edi
  800813:	eb 0e                	jmp    800823 <vprintfmt+0x243>
				putch(' ', putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	53                   	push   %ebx
  800819:	6a 20                	push   $0x20
  80081b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80081d:	83 ef 01             	sub    $0x1,%edi
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	85 ff                	test   %edi,%edi
  800825:	7f ee                	jg     800815 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800827:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
  80082d:	e9 76 01 00 00       	jmp    8009a8 <vprintfmt+0x3c8>
  800832:	89 cf                	mov    %ecx,%edi
  800834:	eb ed                	jmp    800823 <vprintfmt+0x243>
	if (lflag >= 2)
  800836:	83 f9 01             	cmp    $0x1,%ecx
  800839:	7f 1f                	jg     80085a <vprintfmt+0x27a>
	else if (lflag)
  80083b:	85 c9                	test   %ecx,%ecx
  80083d:	74 6a                	je     8008a9 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800847:	89 c1                	mov    %eax,%ecx
  800849:	c1 f9 1f             	sar    $0x1f,%ecx
  80084c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8d 40 04             	lea    0x4(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
  800858:	eb 17                	jmp    800871 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8b 50 04             	mov    0x4(%eax),%edx
  800860:	8b 00                	mov    (%eax),%eax
  800862:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800865:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 40 08             	lea    0x8(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800871:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800874:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800879:	85 d2                	test   %edx,%edx
  80087b:	0f 89 f8 00 00 00    	jns    800979 <vprintfmt+0x399>
				putch('-', putdat);
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	53                   	push   %ebx
  800885:	6a 2d                	push   $0x2d
  800887:	ff d6                	call   *%esi
				num = -(long long) num;
  800889:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80088f:	f7 d8                	neg    %eax
  800891:	83 d2 00             	adc    $0x0,%edx
  800894:	f7 da                	neg    %edx
  800896:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800899:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80089f:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008a4:	e9 e1 00 00 00       	jmp    80098a <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b1:	99                   	cltd   
  8008b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 40 04             	lea    0x4(%eax),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008be:	eb b1                	jmp    800871 <vprintfmt+0x291>
	if (lflag >= 2)
  8008c0:	83 f9 01             	cmp    $0x1,%ecx
  8008c3:	7f 27                	jg     8008ec <vprintfmt+0x30c>
	else if (lflag)
  8008c5:	85 c9                	test   %ecx,%ecx
  8008c7:	74 41                	je     80090a <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8d 40 04             	lea    0x4(%eax),%eax
  8008df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008e7:	e9 8d 00 00 00       	jmp    800979 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8b 50 04             	mov    0x4(%eax),%edx
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	8d 40 08             	lea    0x8(%eax),%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800903:	bf 0a 00 00 00       	mov    $0xa,%edi
  800908:	eb 6f                	jmp    800979 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
  800914:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800917:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8d 40 04             	lea    0x4(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800923:	bf 0a 00 00 00       	mov    $0xa,%edi
  800928:	eb 4f                	jmp    800979 <vprintfmt+0x399>
	if (lflag >= 2)
  80092a:	83 f9 01             	cmp    $0x1,%ecx
  80092d:	7f 23                	jg     800952 <vprintfmt+0x372>
	else if (lflag)
  80092f:	85 c9                	test   %ecx,%ecx
  800931:	0f 84 98 00 00 00    	je     8009cf <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	ba 00 00 00 00       	mov    $0x0,%edx
  800941:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800944:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8d 40 04             	lea    0x4(%eax),%eax
  80094d:	89 45 14             	mov    %eax,0x14(%ebp)
  800950:	eb 17                	jmp    800969 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	8b 50 04             	mov    0x4(%eax),%edx
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8d 40 08             	lea    0x8(%eax),%eax
  800966:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	53                   	push   %ebx
  80096d:	6a 30                	push   $0x30
  80096f:	ff d6                	call   *%esi
			goto number;
  800971:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800974:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800979:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80097d:	74 0b                	je     80098a <vprintfmt+0x3aa>
				putch('+', putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	6a 2b                	push   $0x2b
  800985:	ff d6                	call   *%esi
  800987:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80098a:	83 ec 0c             	sub    $0xc,%esp
  80098d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800991:	50                   	push   %eax
  800992:	ff 75 e0             	pushl  -0x20(%ebp)
  800995:	57                   	push   %edi
  800996:	ff 75 dc             	pushl  -0x24(%ebp)
  800999:	ff 75 d8             	pushl  -0x28(%ebp)
  80099c:	89 da                	mov    %ebx,%edx
  80099e:	89 f0                	mov    %esi,%eax
  8009a0:	e8 22 fb ff ff       	call   8004c7 <printnum>
			break;
  8009a5:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ab:	83 c7 01             	add    $0x1,%edi
  8009ae:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009b2:	83 f8 25             	cmp    $0x25,%eax
  8009b5:	0f 84 3c fc ff ff    	je     8005f7 <vprintfmt+0x17>
			if (ch == '\0')
  8009bb:	85 c0                	test   %eax,%eax
  8009bd:	0f 84 55 01 00 00    	je     800b18 <vprintfmt+0x538>
			putch(ch, putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	53                   	push   %ebx
  8009c7:	50                   	push   %eax
  8009c8:	ff d6                	call   *%esi
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	eb dc                	jmp    8009ab <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	8d 40 04             	lea    0x4(%eax),%eax
  8009e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e8:	e9 7c ff ff ff       	jmp    800969 <vprintfmt+0x389>
			putch('0', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	6a 30                	push   $0x30
  8009f3:	ff d6                	call   *%esi
			putch('x', putdat);
  8009f5:	83 c4 08             	add    $0x8,%esp
  8009f8:	53                   	push   %ebx
  8009f9:	6a 78                	push   $0x78
  8009fb:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	ba 00 00 00 00       	mov    $0x0,%edx
  800a07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a0d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	8d 40 04             	lea    0x4(%eax),%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a19:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a1e:	e9 56 ff ff ff       	jmp    800979 <vprintfmt+0x399>
	if (lflag >= 2)
  800a23:	83 f9 01             	cmp    $0x1,%ecx
  800a26:	7f 27                	jg     800a4f <vprintfmt+0x46f>
	else if (lflag)
  800a28:	85 c9                	test   %ecx,%ecx
  800a2a:	74 44                	je     800a70 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	8b 00                	mov    (%eax),%eax
  800a31:	ba 00 00 00 00       	mov    $0x0,%edx
  800a36:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a39:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	8d 40 04             	lea    0x4(%eax),%eax
  800a42:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a45:	bf 10 00 00 00       	mov    $0x10,%edi
  800a4a:	e9 2a ff ff ff       	jmp    800979 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	8b 50 04             	mov    0x4(%eax),%edx
  800a55:	8b 00                	mov    (%eax),%eax
  800a57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a5a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	8d 40 08             	lea    0x8(%eax),%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a66:	bf 10 00 00 00       	mov    $0x10,%edi
  800a6b:	e9 09 ff ff ff       	jmp    800979 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a70:	8b 45 14             	mov    0x14(%ebp),%eax
  800a73:	8b 00                	mov    (%eax),%eax
  800a75:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a80:	8b 45 14             	mov    0x14(%ebp),%eax
  800a83:	8d 40 04             	lea    0x4(%eax),%eax
  800a86:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a89:	bf 10 00 00 00       	mov    $0x10,%edi
  800a8e:	e9 e6 fe ff ff       	jmp    800979 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	8d 78 04             	lea    0x4(%eax),%edi
  800a99:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800a9b:	85 c0                	test   %eax,%eax
  800a9d:	74 2d                	je     800acc <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800a9f:	0f b6 13             	movzbl (%ebx),%edx
  800aa2:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800aa4:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800aa7:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800aaa:	0f 8e f8 fe ff ff    	jle    8009a8 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800ab0:	68 38 13 80 00       	push   $0x801338
  800ab5:	68 e8 11 80 00       	push   $0x8011e8
  800aba:	53                   	push   %ebx
  800abb:	56                   	push   %esi
  800abc:	e8 02 fb ff ff       	call   8005c3 <printfmt>
  800ac1:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ac4:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ac7:	e9 dc fe ff ff       	jmp    8009a8 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800acc:	68 00 13 80 00       	push   $0x801300
  800ad1:	68 e8 11 80 00       	push   $0x8011e8
  800ad6:	53                   	push   %ebx
  800ad7:	56                   	push   %esi
  800ad8:	e8 e6 fa ff ff       	call   8005c3 <printfmt>
  800add:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ae0:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ae3:	e9 c0 fe ff ff       	jmp    8009a8 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800ae8:	83 ec 08             	sub    $0x8,%esp
  800aeb:	53                   	push   %ebx
  800aec:	6a 25                	push   $0x25
  800aee:	ff d6                	call   *%esi
			break;
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	e9 b0 fe ff ff       	jmp    8009a8 <vprintfmt+0x3c8>
			putch('%', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	53                   	push   %ebx
  800afc:	6a 25                	push   $0x25
  800afe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	89 f8                	mov    %edi,%eax
  800b05:	eb 03                	jmp    800b0a <vprintfmt+0x52a>
  800b07:	83 e8 01             	sub    $0x1,%eax
  800b0a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b0e:	75 f7                	jne    800b07 <vprintfmt+0x527>
  800b10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b13:	e9 90 fe ff ff       	jmp    8009a8 <vprintfmt+0x3c8>
}
  800b18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5f                   	pop    %edi
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	83 ec 18             	sub    $0x18,%esp
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b33:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	74 26                	je     800b67 <vsnprintf+0x47>
  800b41:	85 d2                	test   %edx,%edx
  800b43:	7e 22                	jle    800b67 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b45:	ff 75 14             	pushl  0x14(%ebp)
  800b48:	ff 75 10             	pushl  0x10(%ebp)
  800b4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4e:	50                   	push   %eax
  800b4f:	68 a6 05 80 00       	push   $0x8005a6
  800b54:	e8 87 fa ff ff       	call   8005e0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b62:	83 c4 10             	add    $0x10,%esp
}
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    
		return -E_INVAL;
  800b67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b6c:	eb f7                	jmp    800b65 <vsnprintf+0x45>

00800b6e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b74:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b77:	50                   	push   %eax
  800b78:	ff 75 10             	pushl  0x10(%ebp)
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 9a ff ff ff       	call   800b20 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b97:	74 05                	je     800b9e <strlen+0x16>
		n++;
  800b99:	83 c0 01             	add    $0x1,%eax
  800b9c:	eb f5                	jmp    800b93 <strlen+0xb>
	return n;
}
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bae:	39 c2                	cmp    %eax,%edx
  800bb0:	74 0d                	je     800bbf <strnlen+0x1f>
  800bb2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bb6:	74 05                	je     800bbd <strnlen+0x1d>
		n++;
  800bb8:	83 c2 01             	add    $0x1,%edx
  800bbb:	eb f1                	jmp    800bae <strnlen+0xe>
  800bbd:	89 d0                	mov    %edx,%eax
	return n;
}
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bd4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bd7:	83 c2 01             	add    $0x1,%edx
  800bda:	84 c9                	test   %cl,%cl
  800bdc:	75 f2                	jne    800bd0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	53                   	push   %ebx
  800be5:	83 ec 10             	sub    $0x10,%esp
  800be8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800beb:	53                   	push   %ebx
  800bec:	e8 97 ff ff ff       	call   800b88 <strlen>
  800bf1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bf4:	ff 75 0c             	pushl  0xc(%ebp)
  800bf7:	01 d8                	add    %ebx,%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 c2 ff ff ff       	call   800bc1 <strcpy>
	return dst;
}
  800bff:	89 d8                	mov    %ebx,%eax
  800c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	56                   	push   %esi
  800c0a:	53                   	push   %ebx
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c11:	89 c6                	mov    %eax,%esi
  800c13:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c16:	89 c2                	mov    %eax,%edx
  800c18:	39 f2                	cmp    %esi,%edx
  800c1a:	74 11                	je     800c2d <strncpy+0x27>
		*dst++ = *src;
  800c1c:	83 c2 01             	add    $0x1,%edx
  800c1f:	0f b6 19             	movzbl (%ecx),%ebx
  800c22:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c25:	80 fb 01             	cmp    $0x1,%bl
  800c28:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c2b:	eb eb                	jmp    800c18 <strncpy+0x12>
	}
	return ret;
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	56                   	push   %esi
  800c35:	53                   	push   %ebx
  800c36:	8b 75 08             	mov    0x8(%ebp),%esi
  800c39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3c:	8b 55 10             	mov    0x10(%ebp),%edx
  800c3f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c41:	85 d2                	test   %edx,%edx
  800c43:	74 21                	je     800c66 <strlcpy+0x35>
  800c45:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c49:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c4b:	39 c2                	cmp    %eax,%edx
  800c4d:	74 14                	je     800c63 <strlcpy+0x32>
  800c4f:	0f b6 19             	movzbl (%ecx),%ebx
  800c52:	84 db                	test   %bl,%bl
  800c54:	74 0b                	je     800c61 <strlcpy+0x30>
			*dst++ = *src++;
  800c56:	83 c1 01             	add    $0x1,%ecx
  800c59:	83 c2 01             	add    $0x1,%edx
  800c5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c5f:	eb ea                	jmp    800c4b <strlcpy+0x1a>
  800c61:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c63:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c66:	29 f0                	sub    %esi,%eax
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c72:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c75:	0f b6 01             	movzbl (%ecx),%eax
  800c78:	84 c0                	test   %al,%al
  800c7a:	74 0c                	je     800c88 <strcmp+0x1c>
  800c7c:	3a 02                	cmp    (%edx),%al
  800c7e:	75 08                	jne    800c88 <strcmp+0x1c>
		p++, q++;
  800c80:	83 c1 01             	add    $0x1,%ecx
  800c83:	83 c2 01             	add    $0x1,%edx
  800c86:	eb ed                	jmp    800c75 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c88:	0f b6 c0             	movzbl %al,%eax
  800c8b:	0f b6 12             	movzbl (%edx),%edx
  800c8e:	29 d0                	sub    %edx,%eax
}
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	53                   	push   %ebx
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	89 c3                	mov    %eax,%ebx
  800c9e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ca1:	eb 06                	jmp    800ca9 <strncmp+0x17>
		n--, p++, q++;
  800ca3:	83 c0 01             	add    $0x1,%eax
  800ca6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ca9:	39 d8                	cmp    %ebx,%eax
  800cab:	74 16                	je     800cc3 <strncmp+0x31>
  800cad:	0f b6 08             	movzbl (%eax),%ecx
  800cb0:	84 c9                	test   %cl,%cl
  800cb2:	74 04                	je     800cb8 <strncmp+0x26>
  800cb4:	3a 0a                	cmp    (%edx),%cl
  800cb6:	74 eb                	je     800ca3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb8:	0f b6 00             	movzbl (%eax),%eax
  800cbb:	0f b6 12             	movzbl (%edx),%edx
  800cbe:	29 d0                	sub    %edx,%eax
}
  800cc0:	5b                   	pop    %ebx
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    
		return 0;
  800cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc8:	eb f6                	jmp    800cc0 <strncmp+0x2e>

00800cca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd4:	0f b6 10             	movzbl (%eax),%edx
  800cd7:	84 d2                	test   %dl,%dl
  800cd9:	74 09                	je     800ce4 <strchr+0x1a>
		if (*s == c)
  800cdb:	38 ca                	cmp    %cl,%dl
  800cdd:	74 0a                	je     800ce9 <strchr+0x1f>
	for (; *s; s++)
  800cdf:	83 c0 01             	add    $0x1,%eax
  800ce2:	eb f0                	jmp    800cd4 <strchr+0xa>
			return (char *) s;
	return 0;
  800ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cf8:	38 ca                	cmp    %cl,%dl
  800cfa:	74 09                	je     800d05 <strfind+0x1a>
  800cfc:	84 d2                	test   %dl,%dl
  800cfe:	74 05                	je     800d05 <strfind+0x1a>
	for (; *s; s++)
  800d00:	83 c0 01             	add    $0x1,%eax
  800d03:	eb f0                	jmp    800cf5 <strfind+0xa>
			break;
	return (char *) s;
}
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d13:	85 c9                	test   %ecx,%ecx
  800d15:	74 31                	je     800d48 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d17:	89 f8                	mov    %edi,%eax
  800d19:	09 c8                	or     %ecx,%eax
  800d1b:	a8 03                	test   $0x3,%al
  800d1d:	75 23                	jne    800d42 <memset+0x3b>
		c &= 0xFF;
  800d1f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d23:	89 d3                	mov    %edx,%ebx
  800d25:	c1 e3 08             	shl    $0x8,%ebx
  800d28:	89 d0                	mov    %edx,%eax
  800d2a:	c1 e0 18             	shl    $0x18,%eax
  800d2d:	89 d6                	mov    %edx,%esi
  800d2f:	c1 e6 10             	shl    $0x10,%esi
  800d32:	09 f0                	or     %esi,%eax
  800d34:	09 c2                	or     %eax,%edx
  800d36:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d38:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d3b:	89 d0                	mov    %edx,%eax
  800d3d:	fc                   	cld    
  800d3e:	f3 ab                	rep stos %eax,%es:(%edi)
  800d40:	eb 06                	jmp    800d48 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	fc                   	cld    
  800d46:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d48:	89 f8                	mov    %edi,%eax
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d5d:	39 c6                	cmp    %eax,%esi
  800d5f:	73 32                	jae    800d93 <memmove+0x44>
  800d61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d64:	39 c2                	cmp    %eax,%edx
  800d66:	76 2b                	jbe    800d93 <memmove+0x44>
		s += n;
		d += n;
  800d68:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6b:	89 fe                	mov    %edi,%esi
  800d6d:	09 ce                	or     %ecx,%esi
  800d6f:	09 d6                	or     %edx,%esi
  800d71:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d77:	75 0e                	jne    800d87 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d79:	83 ef 04             	sub    $0x4,%edi
  800d7c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d7f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d82:	fd                   	std    
  800d83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d85:	eb 09                	jmp    800d90 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d87:	83 ef 01             	sub    $0x1,%edi
  800d8a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d8d:	fd                   	std    
  800d8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d90:	fc                   	cld    
  800d91:	eb 1a                	jmp    800dad <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d93:	89 c2                	mov    %eax,%edx
  800d95:	09 ca                	or     %ecx,%edx
  800d97:	09 f2                	or     %esi,%edx
  800d99:	f6 c2 03             	test   $0x3,%dl
  800d9c:	75 0a                	jne    800da8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d9e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800da1:	89 c7                	mov    %eax,%edi
  800da3:	fc                   	cld    
  800da4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da6:	eb 05                	jmp    800dad <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800da8:	89 c7                	mov    %eax,%edi
  800daa:	fc                   	cld    
  800dab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800db7:	ff 75 10             	pushl  0x10(%ebp)
  800dba:	ff 75 0c             	pushl  0xc(%ebp)
  800dbd:	ff 75 08             	pushl  0x8(%ebp)
  800dc0:	e8 8a ff ff ff       	call   800d4f <memmove>
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd2:	89 c6                	mov    %eax,%esi
  800dd4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dd7:	39 f0                	cmp    %esi,%eax
  800dd9:	74 1c                	je     800df7 <memcmp+0x30>
		if (*s1 != *s2)
  800ddb:	0f b6 08             	movzbl (%eax),%ecx
  800dde:	0f b6 1a             	movzbl (%edx),%ebx
  800de1:	38 d9                	cmp    %bl,%cl
  800de3:	75 08                	jne    800ded <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800de5:	83 c0 01             	add    $0x1,%eax
  800de8:	83 c2 01             	add    $0x1,%edx
  800deb:	eb ea                	jmp    800dd7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ded:	0f b6 c1             	movzbl %cl,%eax
  800df0:	0f b6 db             	movzbl %bl,%ebx
  800df3:	29 d8                	sub    %ebx,%eax
  800df5:	eb 05                	jmp    800dfc <memcmp+0x35>
	}

	return 0;
  800df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfc:	5b                   	pop    %ebx
  800dfd:	5e                   	pop    %esi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e09:	89 c2                	mov    %eax,%edx
  800e0b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e0e:	39 d0                	cmp    %edx,%eax
  800e10:	73 09                	jae    800e1b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e12:	38 08                	cmp    %cl,(%eax)
  800e14:	74 05                	je     800e1b <memfind+0x1b>
	for (; s < ends; s++)
  800e16:	83 c0 01             	add    $0x1,%eax
  800e19:	eb f3                	jmp    800e0e <memfind+0xe>
			break;
	return (void *) s;
}
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    

00800e1d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	57                   	push   %edi
  800e21:	56                   	push   %esi
  800e22:	53                   	push   %ebx
  800e23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e29:	eb 03                	jmp    800e2e <strtol+0x11>
		s++;
  800e2b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e2e:	0f b6 01             	movzbl (%ecx),%eax
  800e31:	3c 20                	cmp    $0x20,%al
  800e33:	74 f6                	je     800e2b <strtol+0xe>
  800e35:	3c 09                	cmp    $0x9,%al
  800e37:	74 f2                	je     800e2b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e39:	3c 2b                	cmp    $0x2b,%al
  800e3b:	74 2a                	je     800e67 <strtol+0x4a>
	int neg = 0;
  800e3d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e42:	3c 2d                	cmp    $0x2d,%al
  800e44:	74 2b                	je     800e71 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e46:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e4c:	75 0f                	jne    800e5d <strtol+0x40>
  800e4e:	80 39 30             	cmpb   $0x30,(%ecx)
  800e51:	74 28                	je     800e7b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e53:	85 db                	test   %ebx,%ebx
  800e55:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e5a:	0f 44 d8             	cmove  %eax,%ebx
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e62:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e65:	eb 50                	jmp    800eb7 <strtol+0x9a>
		s++;
  800e67:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e6a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e6f:	eb d5                	jmp    800e46 <strtol+0x29>
		s++, neg = 1;
  800e71:	83 c1 01             	add    $0x1,%ecx
  800e74:	bf 01 00 00 00       	mov    $0x1,%edi
  800e79:	eb cb                	jmp    800e46 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e7f:	74 0e                	je     800e8f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e81:	85 db                	test   %ebx,%ebx
  800e83:	75 d8                	jne    800e5d <strtol+0x40>
		s++, base = 8;
  800e85:	83 c1 01             	add    $0x1,%ecx
  800e88:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e8d:	eb ce                	jmp    800e5d <strtol+0x40>
		s += 2, base = 16;
  800e8f:	83 c1 02             	add    $0x2,%ecx
  800e92:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e97:	eb c4                	jmp    800e5d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e99:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e9c:	89 f3                	mov    %esi,%ebx
  800e9e:	80 fb 19             	cmp    $0x19,%bl
  800ea1:	77 29                	ja     800ecc <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ea3:	0f be d2             	movsbl %dl,%edx
  800ea6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ea9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800eac:	7d 30                	jge    800ede <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800eae:	83 c1 01             	add    $0x1,%ecx
  800eb1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eb5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800eb7:	0f b6 11             	movzbl (%ecx),%edx
  800eba:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ebd:	89 f3                	mov    %esi,%ebx
  800ebf:	80 fb 09             	cmp    $0x9,%bl
  800ec2:	77 d5                	ja     800e99 <strtol+0x7c>
			dig = *s - '0';
  800ec4:	0f be d2             	movsbl %dl,%edx
  800ec7:	83 ea 30             	sub    $0x30,%edx
  800eca:	eb dd                	jmp    800ea9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ecc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ecf:	89 f3                	mov    %esi,%ebx
  800ed1:	80 fb 19             	cmp    $0x19,%bl
  800ed4:	77 08                	ja     800ede <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ed6:	0f be d2             	movsbl %dl,%edx
  800ed9:	83 ea 37             	sub    $0x37,%edx
  800edc:	eb cb                	jmp    800ea9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ede:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee2:	74 05                	je     800ee9 <strtol+0xcc>
		*endptr = (char *) s;
  800ee4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ee7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ee9:	89 c2                	mov    %eax,%edx
  800eeb:	f7 da                	neg    %edx
  800eed:	85 ff                	test   %edi,%edi
  800eef:	0f 45 c2             	cmovne %edx,%eax
}
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5f                   	pop    %edi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    
  800ef7:	66 90                	xchg   %ax,%ax
  800ef9:	66 90                	xchg   %ax,%ax
  800efb:	66 90                	xchg   %ax,%ax
  800efd:	66 90                	xchg   %ax,%ax
  800eff:	90                   	nop

00800f00 <__udivdi3>:
  800f00:	55                   	push   %ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
  800f04:	83 ec 1c             	sub    $0x1c,%esp
  800f07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f0b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f13:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f17:	85 d2                	test   %edx,%edx
  800f19:	75 4d                	jne    800f68 <__udivdi3+0x68>
  800f1b:	39 f3                	cmp    %esi,%ebx
  800f1d:	76 19                	jbe    800f38 <__udivdi3+0x38>
  800f1f:	31 ff                	xor    %edi,%edi
  800f21:	89 e8                	mov    %ebp,%eax
  800f23:	89 f2                	mov    %esi,%edx
  800f25:	f7 f3                	div    %ebx
  800f27:	89 fa                	mov    %edi,%edx
  800f29:	83 c4 1c             	add    $0x1c,%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
  800f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f38:	89 d9                	mov    %ebx,%ecx
  800f3a:	85 db                	test   %ebx,%ebx
  800f3c:	75 0b                	jne    800f49 <__udivdi3+0x49>
  800f3e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f43:	31 d2                	xor    %edx,%edx
  800f45:	f7 f3                	div    %ebx
  800f47:	89 c1                	mov    %eax,%ecx
  800f49:	31 d2                	xor    %edx,%edx
  800f4b:	89 f0                	mov    %esi,%eax
  800f4d:	f7 f1                	div    %ecx
  800f4f:	89 c6                	mov    %eax,%esi
  800f51:	89 e8                	mov    %ebp,%eax
  800f53:	89 f7                	mov    %esi,%edi
  800f55:	f7 f1                	div    %ecx
  800f57:	89 fa                	mov    %edi,%edx
  800f59:	83 c4 1c             	add    $0x1c,%esp
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    
  800f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f68:	39 f2                	cmp    %esi,%edx
  800f6a:	77 1c                	ja     800f88 <__udivdi3+0x88>
  800f6c:	0f bd fa             	bsr    %edx,%edi
  800f6f:	83 f7 1f             	xor    $0x1f,%edi
  800f72:	75 2c                	jne    800fa0 <__udivdi3+0xa0>
  800f74:	39 f2                	cmp    %esi,%edx
  800f76:	72 06                	jb     800f7e <__udivdi3+0x7e>
  800f78:	31 c0                	xor    %eax,%eax
  800f7a:	39 eb                	cmp    %ebp,%ebx
  800f7c:	77 a9                	ja     800f27 <__udivdi3+0x27>
  800f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f83:	eb a2                	jmp    800f27 <__udivdi3+0x27>
  800f85:	8d 76 00             	lea    0x0(%esi),%esi
  800f88:	31 ff                	xor    %edi,%edi
  800f8a:	31 c0                	xor    %eax,%eax
  800f8c:	89 fa                	mov    %edi,%edx
  800f8e:	83 c4 1c             	add    $0x1c,%esp
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    
  800f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f9d:	8d 76 00             	lea    0x0(%esi),%esi
  800fa0:	89 f9                	mov    %edi,%ecx
  800fa2:	b8 20 00 00 00       	mov    $0x20,%eax
  800fa7:	29 f8                	sub    %edi,%eax
  800fa9:	d3 e2                	shl    %cl,%edx
  800fab:	89 54 24 08          	mov    %edx,0x8(%esp)
  800faf:	89 c1                	mov    %eax,%ecx
  800fb1:	89 da                	mov    %ebx,%edx
  800fb3:	d3 ea                	shr    %cl,%edx
  800fb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fb9:	09 d1                	or     %edx,%ecx
  800fbb:	89 f2                	mov    %esi,%edx
  800fbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fc1:	89 f9                	mov    %edi,%ecx
  800fc3:	d3 e3                	shl    %cl,%ebx
  800fc5:	89 c1                	mov    %eax,%ecx
  800fc7:	d3 ea                	shr    %cl,%edx
  800fc9:	89 f9                	mov    %edi,%ecx
  800fcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fcf:	89 eb                	mov    %ebp,%ebx
  800fd1:	d3 e6                	shl    %cl,%esi
  800fd3:	89 c1                	mov    %eax,%ecx
  800fd5:	d3 eb                	shr    %cl,%ebx
  800fd7:	09 de                	or     %ebx,%esi
  800fd9:	89 f0                	mov    %esi,%eax
  800fdb:	f7 74 24 08          	divl   0x8(%esp)
  800fdf:	89 d6                	mov    %edx,%esi
  800fe1:	89 c3                	mov    %eax,%ebx
  800fe3:	f7 64 24 0c          	mull   0xc(%esp)
  800fe7:	39 d6                	cmp    %edx,%esi
  800fe9:	72 15                	jb     801000 <__udivdi3+0x100>
  800feb:	89 f9                	mov    %edi,%ecx
  800fed:	d3 e5                	shl    %cl,%ebp
  800fef:	39 c5                	cmp    %eax,%ebp
  800ff1:	73 04                	jae    800ff7 <__udivdi3+0xf7>
  800ff3:	39 d6                	cmp    %edx,%esi
  800ff5:	74 09                	je     801000 <__udivdi3+0x100>
  800ff7:	89 d8                	mov    %ebx,%eax
  800ff9:	31 ff                	xor    %edi,%edi
  800ffb:	e9 27 ff ff ff       	jmp    800f27 <__udivdi3+0x27>
  801000:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801003:	31 ff                	xor    %edi,%edi
  801005:	e9 1d ff ff ff       	jmp    800f27 <__udivdi3+0x27>
  80100a:	66 90                	xchg   %ax,%ax
  80100c:	66 90                	xchg   %ax,%ax
  80100e:	66 90                	xchg   %ax,%ax

00801010 <__umoddi3>:
  801010:	55                   	push   %ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
  801014:	83 ec 1c             	sub    $0x1c,%esp
  801017:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80101b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80101f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801023:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801027:	89 da                	mov    %ebx,%edx
  801029:	85 c0                	test   %eax,%eax
  80102b:	75 43                	jne    801070 <__umoddi3+0x60>
  80102d:	39 df                	cmp    %ebx,%edi
  80102f:	76 17                	jbe    801048 <__umoddi3+0x38>
  801031:	89 f0                	mov    %esi,%eax
  801033:	f7 f7                	div    %edi
  801035:	89 d0                	mov    %edx,%eax
  801037:	31 d2                	xor    %edx,%edx
  801039:	83 c4 1c             	add    $0x1c,%esp
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    
  801041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801048:	89 fd                	mov    %edi,%ebp
  80104a:	85 ff                	test   %edi,%edi
  80104c:	75 0b                	jne    801059 <__umoddi3+0x49>
  80104e:	b8 01 00 00 00       	mov    $0x1,%eax
  801053:	31 d2                	xor    %edx,%edx
  801055:	f7 f7                	div    %edi
  801057:	89 c5                	mov    %eax,%ebp
  801059:	89 d8                	mov    %ebx,%eax
  80105b:	31 d2                	xor    %edx,%edx
  80105d:	f7 f5                	div    %ebp
  80105f:	89 f0                	mov    %esi,%eax
  801061:	f7 f5                	div    %ebp
  801063:	89 d0                	mov    %edx,%eax
  801065:	eb d0                	jmp    801037 <__umoddi3+0x27>
  801067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80106e:	66 90                	xchg   %ax,%ax
  801070:	89 f1                	mov    %esi,%ecx
  801072:	39 d8                	cmp    %ebx,%eax
  801074:	76 0a                	jbe    801080 <__umoddi3+0x70>
  801076:	89 f0                	mov    %esi,%eax
  801078:	83 c4 1c             	add    $0x1c,%esp
  80107b:	5b                   	pop    %ebx
  80107c:	5e                   	pop    %esi
  80107d:	5f                   	pop    %edi
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    
  801080:	0f bd e8             	bsr    %eax,%ebp
  801083:	83 f5 1f             	xor    $0x1f,%ebp
  801086:	75 20                	jne    8010a8 <__umoddi3+0x98>
  801088:	39 d8                	cmp    %ebx,%eax
  80108a:	0f 82 b0 00 00 00    	jb     801140 <__umoddi3+0x130>
  801090:	39 f7                	cmp    %esi,%edi
  801092:	0f 86 a8 00 00 00    	jbe    801140 <__umoddi3+0x130>
  801098:	89 c8                	mov    %ecx,%eax
  80109a:	83 c4 1c             	add    $0x1c,%esp
  80109d:	5b                   	pop    %ebx
  80109e:	5e                   	pop    %esi
  80109f:	5f                   	pop    %edi
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    
  8010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010a8:	89 e9                	mov    %ebp,%ecx
  8010aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8010af:	29 ea                	sub    %ebp,%edx
  8010b1:	d3 e0                	shl    %cl,%eax
  8010b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010b7:	89 d1                	mov    %edx,%ecx
  8010b9:	89 f8                	mov    %edi,%eax
  8010bb:	d3 e8                	shr    %cl,%eax
  8010bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010c9:	09 c1                	or     %eax,%ecx
  8010cb:	89 d8                	mov    %ebx,%eax
  8010cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010d1:	89 e9                	mov    %ebp,%ecx
  8010d3:	d3 e7                	shl    %cl,%edi
  8010d5:	89 d1                	mov    %edx,%ecx
  8010d7:	d3 e8                	shr    %cl,%eax
  8010d9:	89 e9                	mov    %ebp,%ecx
  8010db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010df:	d3 e3                	shl    %cl,%ebx
  8010e1:	89 c7                	mov    %eax,%edi
  8010e3:	89 d1                	mov    %edx,%ecx
  8010e5:	89 f0                	mov    %esi,%eax
  8010e7:	d3 e8                	shr    %cl,%eax
  8010e9:	89 e9                	mov    %ebp,%ecx
  8010eb:	89 fa                	mov    %edi,%edx
  8010ed:	d3 e6                	shl    %cl,%esi
  8010ef:	09 d8                	or     %ebx,%eax
  8010f1:	f7 74 24 08          	divl   0x8(%esp)
  8010f5:	89 d1                	mov    %edx,%ecx
  8010f7:	89 f3                	mov    %esi,%ebx
  8010f9:	f7 64 24 0c          	mull   0xc(%esp)
  8010fd:	89 c6                	mov    %eax,%esi
  8010ff:	89 d7                	mov    %edx,%edi
  801101:	39 d1                	cmp    %edx,%ecx
  801103:	72 06                	jb     80110b <__umoddi3+0xfb>
  801105:	75 10                	jne    801117 <__umoddi3+0x107>
  801107:	39 c3                	cmp    %eax,%ebx
  801109:	73 0c                	jae    801117 <__umoddi3+0x107>
  80110b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80110f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801113:	89 d7                	mov    %edx,%edi
  801115:	89 c6                	mov    %eax,%esi
  801117:	89 ca                	mov    %ecx,%edx
  801119:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80111e:	29 f3                	sub    %esi,%ebx
  801120:	19 fa                	sbb    %edi,%edx
  801122:	89 d0                	mov    %edx,%eax
  801124:	d3 e0                	shl    %cl,%eax
  801126:	89 e9                	mov    %ebp,%ecx
  801128:	d3 eb                	shr    %cl,%ebx
  80112a:	d3 ea                	shr    %cl,%edx
  80112c:	09 d8                	or     %ebx,%eax
  80112e:	83 c4 1c             	add    $0x1c,%esp
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    
  801136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80113d:	8d 76 00             	lea    0x0(%esi),%esi
  801140:	89 da                	mov    %ebx,%edx
  801142:	29 fe                	sub    %edi,%esi
  801144:	19 c2                	sbb    %eax,%edx
  801146:	89 f1                	mov    %esi,%ecx
  801148:	89 c8                	mov    %ecx,%eax
  80114a:	e9 4b ff ff ff       	jmp    80109a <__umoddi3+0x8a>
