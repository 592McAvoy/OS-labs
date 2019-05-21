
obj/user/evilhello.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
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
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	6a 64                	push   $0x64
  80003b:	68 0c 00 10 f0       	push   $0xf010000c
  800040:	e8 60 00 00 00       	call   8000a5 <sys_cputs>
}
  800045:	83 c4 10             	add    $0x10,%esp
  800048:	c9                   	leave  
  800049:	c3                   	ret    

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800055:	e8 c9 00 00 00       	call   800123 <sys_getenvid>
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800062:	c1 e0 04             	shl    $0x4,%eax
  800065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006a:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006f:	85 db                	test   %ebx,%ebx
  800071:	7e 07                	jle    80007a <libmain+0x30>
		binaryname = argv[0];
  800073:	8b 06                	mov    (%esi),%eax
  800075:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80007a:	83 ec 08             	sub    $0x8,%esp
  80007d:	56                   	push   %esi
  80007e:	53                   	push   %ebx
  80007f:	e8 af ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800084:	e8 0a 00 00 00       	call   800093 <exit>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    

00800093 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800099:	6a 00                	push   $0x0
  80009b:	e8 42 00 00 00       	call   8000e2 <sys_env_destroy>
}
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	89 c7                	mov    %eax,%edi
  8000ba:	89 c6                	mov    %eax,%esi
  8000bc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000be:	5b                   	pop    %ebx
  8000bf:	5e                   	pop    %esi
  8000c0:	5f                   	pop    %edi
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	57                   	push   %edi
  8000c7:	56                   	push   %esi
  8000c8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d3:	89 d1                	mov    %edx,%ecx
  8000d5:	89 d3                	mov    %edx,%ebx
  8000d7:	89 d7                	mov    %edx,%edi
  8000d9:	89 d6                	mov    %edx,%esi
  8000db:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    

008000e2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	57                   	push   %edi
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f8:	89 cb                	mov    %ecx,%ebx
  8000fa:	89 cf                	mov    %ecx,%edi
  8000fc:	89 ce                	mov    %ecx,%esi
  8000fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800100:	85 c0                	test   %eax,%eax
  800102:	7f 08                	jg     80010c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5f                   	pop    %edi
  80010a:	5d                   	pop    %ebp
  80010b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	50                   	push   %eax
  800110:	6a 03                	push   $0x3
  800112:	68 6a 11 80 00       	push   $0x80116a
  800117:	6a 33                	push   $0x33
  800119:	68 87 11 80 00       	push   $0x801187
  80011e:	e8 b1 02 00 00       	call   8003d4 <_panic>

00800123 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	57                   	push   %edi
  800127:	56                   	push   %esi
  800128:	53                   	push   %ebx
	asm volatile("int %1\n"
  800129:	ba 00 00 00 00       	mov    $0x0,%edx
  80012e:	b8 02 00 00 00       	mov    $0x2,%eax
  800133:	89 d1                	mov    %edx,%ecx
  800135:	89 d3                	mov    %edx,%ebx
  800137:	89 d7                	mov    %edx,%edi
  800139:	89 d6                	mov    %edx,%esi
  80013b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013d:	5b                   	pop    %ebx
  80013e:	5e                   	pop    %esi
  80013f:	5f                   	pop    %edi
  800140:	5d                   	pop    %ebp
  800141:	c3                   	ret    

00800142 <sys_yield>:

void
sys_yield(void)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	57                   	push   %edi
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
	asm volatile("int %1\n"
  800148:	ba 00 00 00 00       	mov    $0x0,%edx
  80014d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800152:	89 d1                	mov    %edx,%ecx
  800154:	89 d3                	mov    %edx,%ebx
  800156:	89 d7                	mov    %edx,%edi
  800158:	89 d6                	mov    %edx,%esi
  80015a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80015c:	5b                   	pop    %ebx
  80015d:	5e                   	pop    %esi
  80015e:	5f                   	pop    %edi
  80015f:	5d                   	pop    %ebp
  800160:	c3                   	ret    

00800161 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800161:	55                   	push   %ebp
  800162:	89 e5                	mov    %esp,%ebp
  800164:	57                   	push   %edi
  800165:	56                   	push   %esi
  800166:	53                   	push   %ebx
  800167:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016a:	be 00 00 00 00       	mov    $0x0,%esi
  80016f:	8b 55 08             	mov    0x8(%ebp),%edx
  800172:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800175:	b8 04 00 00 00       	mov    $0x4,%eax
  80017a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017d:	89 f7                	mov    %esi,%edi
  80017f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800181:	85 c0                	test   %eax,%eax
  800183:	7f 08                	jg     80018d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800188:	5b                   	pop    %ebx
  800189:	5e                   	pop    %esi
  80018a:	5f                   	pop    %edi
  80018b:	5d                   	pop    %ebp
  80018c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	50                   	push   %eax
  800191:	6a 04                	push   $0x4
  800193:	68 6a 11 80 00       	push   $0x80116a
  800198:	6a 33                	push   $0x33
  80019a:	68 87 11 80 00       	push   $0x801187
  80019f:	e8 30 02 00 00       	call   8003d4 <_panic>

008001a4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	57                   	push   %edi
  8001a8:	56                   	push   %esi
  8001a9:	53                   	push   %ebx
  8001aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001be:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c3:	85 c0                	test   %eax,%eax
  8001c5:	7f 08                	jg     8001cf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ca:	5b                   	pop    %ebx
  8001cb:	5e                   	pop    %esi
  8001cc:	5f                   	pop    %edi
  8001cd:	5d                   	pop    %ebp
  8001ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	50                   	push   %eax
  8001d3:	6a 05                	push   $0x5
  8001d5:	68 6a 11 80 00       	push   $0x80116a
  8001da:	6a 33                	push   $0x33
  8001dc:	68 87 11 80 00       	push   $0x801187
  8001e1:	e8 ee 01 00 00       	call   8003d4 <_panic>

008001e6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	57                   	push   %edi
  8001ea:	56                   	push   %esi
  8001eb:	53                   	push   %ebx
  8001ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fa:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ff:	89 df                	mov    %ebx,%edi
  800201:	89 de                	mov    %ebx,%esi
  800203:	cd 30                	int    $0x30
	if(check && ret > 0)
  800205:	85 c0                	test   %eax,%eax
  800207:	7f 08                	jg     800211 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5e                   	pop    %esi
  80020e:	5f                   	pop    %edi
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	6a 06                	push   $0x6
  800217:	68 6a 11 80 00       	push   $0x80116a
  80021c:	6a 33                	push   $0x33
  80021e:	68 87 11 80 00       	push   $0x801187
  800223:	e8 ac 01 00 00       	call   8003d4 <_panic>

00800228 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	57                   	push   %edi
  80022c:	56                   	push   %esi
  80022d:	53                   	push   %ebx
  80022e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800231:	b9 00 00 00 00       	mov    $0x0,%ecx
  800236:	8b 55 08             	mov    0x8(%ebp),%edx
  800239:	b8 0b 00 00 00       	mov    $0xb,%eax
  80023e:	89 cb                	mov    %ecx,%ebx
  800240:	89 cf                	mov    %ecx,%edi
  800242:	89 ce                	mov    %ecx,%esi
  800244:	cd 30                	int    $0x30
	if(check && ret > 0)
  800246:	85 c0                	test   %eax,%eax
  800248:	7f 08                	jg     800252 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  80024a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024d:	5b                   	pop    %ebx
  80024e:	5e                   	pop    %esi
  80024f:	5f                   	pop    %edi
  800250:	5d                   	pop    %ebp
  800251:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	50                   	push   %eax
  800256:	6a 0b                	push   $0xb
  800258:	68 6a 11 80 00       	push   $0x80116a
  80025d:	6a 33                	push   $0x33
  80025f:	68 87 11 80 00       	push   $0x801187
  800264:	e8 6b 01 00 00       	call   8003d4 <_panic>

00800269 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	57                   	push   %edi
  80026d:	56                   	push   %esi
  80026e:	53                   	push   %ebx
  80026f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800272:	bb 00 00 00 00       	mov    $0x0,%ebx
  800277:	8b 55 08             	mov    0x8(%ebp),%edx
  80027a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027d:	b8 08 00 00 00       	mov    $0x8,%eax
  800282:	89 df                	mov    %ebx,%edi
  800284:	89 de                	mov    %ebx,%esi
  800286:	cd 30                	int    $0x30
	if(check && ret > 0)
  800288:	85 c0                	test   %eax,%eax
  80028a:	7f 08                	jg     800294 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80028c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028f:	5b                   	pop    %ebx
  800290:	5e                   	pop    %esi
  800291:	5f                   	pop    %edi
  800292:	5d                   	pop    %ebp
  800293:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	6a 08                	push   $0x8
  80029a:	68 6a 11 80 00       	push   $0x80116a
  80029f:	6a 33                	push   $0x33
  8002a1:	68 87 11 80 00       	push   $0x801187
  8002a6:	e8 29 01 00 00       	call   8003d4 <_panic>

008002ab <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	57                   	push   %edi
  8002af:	56                   	push   %esi
  8002b0:	53                   	push   %ebx
  8002b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bf:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c4:	89 df                	mov    %ebx,%edi
  8002c6:	89 de                	mov    %ebx,%esi
  8002c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	7f 08                	jg     8002d6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d1:	5b                   	pop    %ebx
  8002d2:	5e                   	pop    %esi
  8002d3:	5f                   	pop    %edi
  8002d4:	5d                   	pop    %ebp
  8002d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	6a 09                	push   $0x9
  8002dc:	68 6a 11 80 00       	push   $0x80116a
  8002e1:	6a 33                	push   $0x33
  8002e3:	68 87 11 80 00       	push   $0x801187
  8002e8:	e8 e7 00 00 00       	call   8003d4 <_panic>

008002ed <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800301:	b8 0a 00 00 00       	mov    $0xa,%eax
  800306:	89 df                	mov    %ebx,%edi
  800308:	89 de                	mov    %ebx,%esi
  80030a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80030c:	85 c0                	test   %eax,%eax
  80030e:	7f 08                	jg     800318 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800313:	5b                   	pop    %ebx
  800314:	5e                   	pop    %esi
  800315:	5f                   	pop    %edi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	6a 0a                	push   $0xa
  80031e:	68 6a 11 80 00       	push   $0x80116a
  800323:	6a 33                	push   $0x33
  800325:	68 87 11 80 00       	push   $0x801187
  80032a:	e8 a5 00 00 00       	call   8003d4 <_panic>

0080032f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	57                   	push   %edi
  800333:	56                   	push   %esi
  800334:	53                   	push   %ebx
	asm volatile("int %1\n"
  800335:	8b 55 08             	mov    0x8(%ebp),%edx
  800338:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800340:	be 00 00 00 00       	mov    $0x0,%esi
  800345:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800348:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	57                   	push   %edi
  800356:	56                   	push   %esi
  800357:	53                   	push   %ebx
  800358:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800360:	8b 55 08             	mov    0x8(%ebp),%edx
  800363:	b8 0e 00 00 00       	mov    $0xe,%eax
  800368:	89 cb                	mov    %ecx,%ebx
  80036a:	89 cf                	mov    %ecx,%edi
  80036c:	89 ce                	mov    %ecx,%esi
  80036e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800370:	85 c0                	test   %eax,%eax
  800372:	7f 08                	jg     80037c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800377:	5b                   	pop    %ebx
  800378:	5e                   	pop    %esi
  800379:	5f                   	pop    %edi
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	6a 0e                	push   $0xe
  800382:	68 6a 11 80 00       	push   $0x80116a
  800387:	6a 33                	push   $0x33
  800389:	68 87 11 80 00       	push   $0x801187
  80038e:	e8 41 00 00 00       	call   8003d4 <_panic>

00800393 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	57                   	push   %edi
  800397:	56                   	push   %esi
  800398:	53                   	push   %ebx
	asm volatile("int %1\n"
  800399:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039e:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a4:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003a9:	89 df                	mov    %ebx,%edi
  8003ab:	89 de                	mov    %ebx,%esi
  8003ad:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003af:	5b                   	pop    %ebx
  8003b0:	5e                   	pop    %esi
  8003b1:	5f                   	pop    %edi
  8003b2:	5d                   	pop    %ebp
  8003b3:	c3                   	ret    

008003b4 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	57                   	push   %edi
  8003b8:	56                   	push   %esi
  8003b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8003c7:	89 cb                	mov    %ecx,%ebx
  8003c9:	89 cf                	mov    %ecx,%edi
  8003cb:	89 ce                	mov    %ecx,%esi
  8003cd:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003cf:	5b                   	pop    %ebx
  8003d0:	5e                   	pop    %esi
  8003d1:	5f                   	pop    %edi
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	56                   	push   %esi
  8003d8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003d9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003dc:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003e2:	e8 3c fd ff ff       	call   800123 <sys_getenvid>
  8003e7:	83 ec 0c             	sub    $0xc,%esp
  8003ea:	ff 75 0c             	pushl  0xc(%ebp)
  8003ed:	ff 75 08             	pushl  0x8(%ebp)
  8003f0:	56                   	push   %esi
  8003f1:	50                   	push   %eax
  8003f2:	68 98 11 80 00       	push   $0x801198
  8003f7:	e8 b3 00 00 00       	call   8004af <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003fc:	83 c4 18             	add    $0x18,%esp
  8003ff:	53                   	push   %ebx
  800400:	ff 75 10             	pushl  0x10(%ebp)
  800403:	e8 56 00 00 00       	call   80045e <vcprintf>
	cprintf("\n");
  800408:	c7 04 24 bb 11 80 00 	movl   $0x8011bb,(%esp)
  80040f:	e8 9b 00 00 00       	call   8004af <cprintf>
  800414:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800417:	cc                   	int3   
  800418:	eb fd                	jmp    800417 <_panic+0x43>

0080041a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	53                   	push   %ebx
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800424:	8b 13                	mov    (%ebx),%edx
  800426:	8d 42 01             	lea    0x1(%edx),%eax
  800429:	89 03                	mov    %eax,(%ebx)
  80042b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80042e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800432:	3d ff 00 00 00       	cmp    $0xff,%eax
  800437:	74 09                	je     800442 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800439:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80043d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800440:	c9                   	leave  
  800441:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	68 ff 00 00 00       	push   $0xff
  80044a:	8d 43 08             	lea    0x8(%ebx),%eax
  80044d:	50                   	push   %eax
  80044e:	e8 52 fc ff ff       	call   8000a5 <sys_cputs>
		b->idx = 0;
  800453:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	eb db                	jmp    800439 <putch+0x1f>

0080045e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800467:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80046e:	00 00 00 
	b.cnt = 0;
  800471:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800478:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80047b:	ff 75 0c             	pushl  0xc(%ebp)
  80047e:	ff 75 08             	pushl  0x8(%ebp)
  800481:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800487:	50                   	push   %eax
  800488:	68 1a 04 80 00       	push   $0x80041a
  80048d:	e8 4a 01 00 00       	call   8005dc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800492:	83 c4 08             	add    $0x8,%esp
  800495:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80049b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004a1:	50                   	push   %eax
  8004a2:	e8 fe fb ff ff       	call   8000a5 <sys_cputs>

	return b.cnt;
}
  8004a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    

008004af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004af:	55                   	push   %ebp
  8004b0:	89 e5                	mov    %esp,%ebp
  8004b2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004b5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004b8:	50                   	push   %eax
  8004b9:	ff 75 08             	pushl  0x8(%ebp)
  8004bc:	e8 9d ff ff ff       	call   80045e <vcprintf>
	va_end(ap);

	return cnt;
}
  8004c1:	c9                   	leave  
  8004c2:	c3                   	ret    

008004c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
  8004c6:	57                   	push   %edi
  8004c7:	56                   	push   %esi
  8004c8:	53                   	push   %ebx
  8004c9:	83 ec 1c             	sub    $0x1c,%esp
  8004cc:	89 c6                	mov    %eax,%esi
  8004ce:	89 d7                	mov    %edx,%edi
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004df:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004e2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004e6:	74 2c                	je     800514 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004f8:	39 c2                	cmp    %eax,%edx
  8004fa:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004fd:	73 43                	jae    800542 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004ff:	83 eb 01             	sub    $0x1,%ebx
  800502:	85 db                	test   %ebx,%ebx
  800504:	7e 6c                	jle    800572 <printnum+0xaf>
			putch(padc, putdat);
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	57                   	push   %edi
  80050a:	ff 75 18             	pushl  0x18(%ebp)
  80050d:	ff d6                	call   *%esi
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	eb eb                	jmp    8004ff <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800514:	83 ec 0c             	sub    $0xc,%esp
  800517:	6a 20                	push   $0x20
  800519:	6a 00                	push   $0x0
  80051b:	50                   	push   %eax
  80051c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80051f:	ff 75 e0             	pushl  -0x20(%ebp)
  800522:	89 fa                	mov    %edi,%edx
  800524:	89 f0                	mov    %esi,%eax
  800526:	e8 98 ff ff ff       	call   8004c3 <printnum>
		while (--width > 0)
  80052b:	83 c4 20             	add    $0x20,%esp
  80052e:	83 eb 01             	sub    $0x1,%ebx
  800531:	85 db                	test   %ebx,%ebx
  800533:	7e 65                	jle    80059a <printnum+0xd7>
			putch(padc, putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	57                   	push   %edi
  800539:	6a 20                	push   $0x20
  80053b:	ff d6                	call   *%esi
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	eb ec                	jmp    80052e <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800542:	83 ec 0c             	sub    $0xc,%esp
  800545:	ff 75 18             	pushl  0x18(%ebp)
  800548:	83 eb 01             	sub    $0x1,%ebx
  80054b:	53                   	push   %ebx
  80054c:	50                   	push   %eax
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	ff 75 dc             	pushl  -0x24(%ebp)
  800553:	ff 75 d8             	pushl  -0x28(%ebp)
  800556:	ff 75 e4             	pushl  -0x1c(%ebp)
  800559:	ff 75 e0             	pushl  -0x20(%ebp)
  80055c:	e8 9f 09 00 00       	call   800f00 <__udivdi3>
  800561:	83 c4 18             	add    $0x18,%esp
  800564:	52                   	push   %edx
  800565:	50                   	push   %eax
  800566:	89 fa                	mov    %edi,%edx
  800568:	89 f0                	mov    %esi,%eax
  80056a:	e8 54 ff ff ff       	call   8004c3 <printnum>
  80056f:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	57                   	push   %edi
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	ff 75 dc             	pushl  -0x24(%ebp)
  80057c:	ff 75 d8             	pushl  -0x28(%ebp)
  80057f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800582:	ff 75 e0             	pushl  -0x20(%ebp)
  800585:	e8 86 0a 00 00       	call   801010 <__umoddi3>
  80058a:	83 c4 14             	add    $0x14,%esp
  80058d:	0f be 80 bd 11 80 00 	movsbl 0x8011bd(%eax),%eax
  800594:	50                   	push   %eax
  800595:	ff d6                	call   *%esi
  800597:	83 c4 10             	add    $0x10,%esp
}
  80059a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80059d:	5b                   	pop    %ebx
  80059e:	5e                   	pop    %esi
  80059f:	5f                   	pop    %edi
  8005a0:	5d                   	pop    %ebp
  8005a1:	c3                   	ret    

008005a2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005a8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005ac:	8b 10                	mov    (%eax),%edx
  8005ae:	3b 50 04             	cmp    0x4(%eax),%edx
  8005b1:	73 0a                	jae    8005bd <sprintputch+0x1b>
		*b->buf++ = ch;
  8005b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005b6:	89 08                	mov    %ecx,(%eax)
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	88 02                	mov    %al,(%edx)
}
  8005bd:	5d                   	pop    %ebp
  8005be:	c3                   	ret    

008005bf <printfmt>:
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005c5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005c8:	50                   	push   %eax
  8005c9:	ff 75 10             	pushl  0x10(%ebp)
  8005cc:	ff 75 0c             	pushl  0xc(%ebp)
  8005cf:	ff 75 08             	pushl  0x8(%ebp)
  8005d2:	e8 05 00 00 00       	call   8005dc <vprintfmt>
}
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <vprintfmt>:
{
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	57                   	push   %edi
  8005e0:	56                   	push   %esi
  8005e1:	53                   	push   %ebx
  8005e2:	83 ec 3c             	sub    $0x3c,%esp
  8005e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005eb:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005ee:	e9 b4 03 00 00       	jmp    8009a7 <vprintfmt+0x3cb>
		padc = ' ';
  8005f3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8005f7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8005fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800605:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80060c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800613:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800618:	8d 47 01             	lea    0x1(%edi),%eax
  80061b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061e:	0f b6 17             	movzbl (%edi),%edx
  800621:	8d 42 dd             	lea    -0x23(%edx),%eax
  800624:	3c 55                	cmp    $0x55,%al
  800626:	0f 87 c8 04 00 00    	ja     800af4 <vprintfmt+0x518>
  80062c:	0f b6 c0             	movzbl %al,%eax
  80062f:	ff 24 85 a0 13 80 00 	jmp    *0x8013a0(,%eax,4)
  800636:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800639:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800640:	eb d6                	jmp    800618 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800642:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800645:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800649:	eb cd                	jmp    800618 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80064b:	0f b6 d2             	movzbl %dl,%edx
  80064e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800651:	b8 00 00 00 00       	mov    $0x0,%eax
  800656:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800659:	eb 0c                	jmp    800667 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80065b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80065e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800662:	eb b4                	jmp    800618 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800664:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800667:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80066a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80066e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800671:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800674:	83 f9 09             	cmp    $0x9,%ecx
  800677:	76 eb                	jbe    800664 <vprintfmt+0x88>
  800679:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	eb 14                	jmp    800695 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800692:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800695:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800699:	0f 89 79 ff ff ff    	jns    800618 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80069f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006ac:	e9 67 ff ff ff       	jmp    800618 <vprintfmt+0x3c>
  8006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b4:	85 c0                	test   %eax,%eax
  8006b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bb:	0f 49 d0             	cmovns %eax,%edx
  8006be:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006c4:	e9 4f ff ff ff       	jmp    800618 <vprintfmt+0x3c>
  8006c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006cc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006d3:	e9 40 ff ff ff       	jmp    800618 <vprintfmt+0x3c>
			lflag++;
  8006d8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006de:	e9 35 ff ff ff       	jmp    800618 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8d 78 04             	lea    0x4(%eax),%edi
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	ff 30                	pushl  (%eax)
  8006ef:	ff d6                	call   *%esi
			break;
  8006f1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006f4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006f7:	e9 a8 02 00 00       	jmp    8009a4 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8d 78 04             	lea    0x4(%eax),%edi
  800702:	8b 00                	mov    (%eax),%eax
  800704:	99                   	cltd   
  800705:	31 d0                	xor    %edx,%eax
  800707:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800709:	83 f8 0f             	cmp    $0xf,%eax
  80070c:	7f 23                	jg     800731 <vprintfmt+0x155>
  80070e:	8b 14 85 00 15 80 00 	mov    0x801500(,%eax,4),%edx
  800715:	85 d2                	test   %edx,%edx
  800717:	74 18                	je     800731 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800719:	52                   	push   %edx
  80071a:	68 de 11 80 00       	push   $0x8011de
  80071f:	53                   	push   %ebx
  800720:	56                   	push   %esi
  800721:	e8 99 fe ff ff       	call   8005bf <printfmt>
  800726:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800729:	89 7d 14             	mov    %edi,0x14(%ebp)
  80072c:	e9 73 02 00 00       	jmp    8009a4 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800731:	50                   	push   %eax
  800732:	68 d5 11 80 00       	push   $0x8011d5
  800737:	53                   	push   %ebx
  800738:	56                   	push   %esi
  800739:	e8 81 fe ff ff       	call   8005bf <printfmt>
  80073e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800741:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800744:	e9 5b 02 00 00       	jmp    8009a4 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800757:	85 d2                	test   %edx,%edx
  800759:	b8 ce 11 80 00       	mov    $0x8011ce,%eax
  80075e:	0f 45 c2             	cmovne %edx,%eax
  800761:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800764:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800768:	7e 06                	jle    800770 <vprintfmt+0x194>
  80076a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80076e:	75 0d                	jne    80077d <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800770:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800773:	89 c7                	mov    %eax,%edi
  800775:	03 45 e0             	add    -0x20(%ebp),%eax
  800778:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077b:	eb 53                	jmp    8007d0 <vprintfmt+0x1f4>
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 d8             	pushl  -0x28(%ebp)
  800783:	50                   	push   %eax
  800784:	e8 13 04 00 00       	call   800b9c <strnlen>
  800789:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80078c:	29 c1                	sub    %eax,%ecx
  80078e:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800796:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80079d:	eb 0f                	jmp    8007ae <vprintfmt+0x1d2>
					putch(padc, putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007a6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a8:	83 ef 01             	sub    $0x1,%edi
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	85 ff                	test   %edi,%edi
  8007b0:	7f ed                	jg     80079f <vprintfmt+0x1c3>
  8007b2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007b5:	85 d2                	test   %edx,%edx
  8007b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bc:	0f 49 c2             	cmovns %edx,%eax
  8007bf:	29 c2                	sub    %eax,%edx
  8007c1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007c4:	eb aa                	jmp    800770 <vprintfmt+0x194>
					putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	52                   	push   %edx
  8007cb:	ff d6                	call   *%esi
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007d3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d5:	83 c7 01             	add    $0x1,%edi
  8007d8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007dc:	0f be d0             	movsbl %al,%edx
  8007df:	85 d2                	test   %edx,%edx
  8007e1:	74 4b                	je     80082e <vprintfmt+0x252>
  8007e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007e7:	78 06                	js     8007ef <vprintfmt+0x213>
  8007e9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007ed:	78 1e                	js     80080d <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8007ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007f3:	74 d1                	je     8007c6 <vprintfmt+0x1ea>
  8007f5:	0f be c0             	movsbl %al,%eax
  8007f8:	83 e8 20             	sub    $0x20,%eax
  8007fb:	83 f8 5e             	cmp    $0x5e,%eax
  8007fe:	76 c6                	jbe    8007c6 <vprintfmt+0x1ea>
					putch('?', putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	53                   	push   %ebx
  800804:	6a 3f                	push   $0x3f
  800806:	ff d6                	call   *%esi
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	eb c3                	jmp    8007d0 <vprintfmt+0x1f4>
  80080d:	89 cf                	mov    %ecx,%edi
  80080f:	eb 0e                	jmp    80081f <vprintfmt+0x243>
				putch(' ', putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	53                   	push   %ebx
  800815:	6a 20                	push   $0x20
  800817:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800819:	83 ef 01             	sub    $0x1,%edi
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	85 ff                	test   %edi,%edi
  800821:	7f ee                	jg     800811 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800823:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800826:	89 45 14             	mov    %eax,0x14(%ebp)
  800829:	e9 76 01 00 00       	jmp    8009a4 <vprintfmt+0x3c8>
  80082e:	89 cf                	mov    %ecx,%edi
  800830:	eb ed                	jmp    80081f <vprintfmt+0x243>
	if (lflag >= 2)
  800832:	83 f9 01             	cmp    $0x1,%ecx
  800835:	7f 1f                	jg     800856 <vprintfmt+0x27a>
	else if (lflag)
  800837:	85 c9                	test   %ecx,%ecx
  800839:	74 6a                	je     8008a5 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800843:	89 c1                	mov    %eax,%ecx
  800845:	c1 f9 1f             	sar    $0x1f,%ecx
  800848:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	8d 40 04             	lea    0x4(%eax),%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
  800854:	eb 17                	jmp    80086d <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 50 04             	mov    0x4(%eax),%edx
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800861:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 40 08             	lea    0x8(%eax),%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80086d:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800870:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800875:	85 d2                	test   %edx,%edx
  800877:	0f 89 f8 00 00 00    	jns    800975 <vprintfmt+0x399>
				putch('-', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	53                   	push   %ebx
  800881:	6a 2d                	push   $0x2d
  800883:	ff d6                	call   *%esi
				num = -(long long) num;
  800885:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800888:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80088b:	f7 d8                	neg    %eax
  80088d:	83 d2 00             	adc    $0x0,%edx
  800890:	f7 da                	neg    %edx
  800892:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800895:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800898:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80089b:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008a0:	e9 e1 00 00 00       	jmp    800986 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ad:	99                   	cltd   
  8008ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8d 40 04             	lea    0x4(%eax),%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	eb b1                	jmp    80086d <vprintfmt+0x291>
	if (lflag >= 2)
  8008bc:	83 f9 01             	cmp    $0x1,%ecx
  8008bf:	7f 27                	jg     8008e8 <vprintfmt+0x30c>
	else if (lflag)
  8008c1:	85 c9                	test   %ecx,%ecx
  8008c3:	74 41                	je     800906 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	8d 40 04             	lea    0x4(%eax),%eax
  8008db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008de:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008e3:	e9 8d 00 00 00       	jmp    800975 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	8b 50 04             	mov    0x4(%eax),%edx
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	8d 40 08             	lea    0x8(%eax),%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ff:	bf 0a 00 00 00       	mov    $0xa,%edi
  800904:	eb 6f                	jmp    800975 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	ba 00 00 00 00       	mov    $0x0,%edx
  800910:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800913:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800916:	8b 45 14             	mov    0x14(%ebp),%eax
  800919:	8d 40 04             	lea    0x4(%eax),%eax
  80091c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80091f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800924:	eb 4f                	jmp    800975 <vprintfmt+0x399>
	if (lflag >= 2)
  800926:	83 f9 01             	cmp    $0x1,%ecx
  800929:	7f 23                	jg     80094e <vprintfmt+0x372>
	else if (lflag)
  80092b:	85 c9                	test   %ecx,%ecx
  80092d:	0f 84 98 00 00 00    	je     8009cb <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	ba 00 00 00 00       	mov    $0x0,%edx
  80093d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800940:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8d 40 04             	lea    0x4(%eax),%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
  80094c:	eb 17                	jmp    800965 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8b 50 04             	mov    0x4(%eax),%edx
  800954:	8b 00                	mov    (%eax),%eax
  800956:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800959:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	8d 40 08             	lea    0x8(%eax),%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	53                   	push   %ebx
  800969:	6a 30                	push   $0x30
  80096b:	ff d6                	call   *%esi
			goto number;
  80096d:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800970:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800975:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800979:	74 0b                	je     800986 <vprintfmt+0x3aa>
				putch('+', putdat);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	53                   	push   %ebx
  80097f:	6a 2b                	push   $0x2b
  800981:	ff d6                	call   *%esi
  800983:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80098d:	50                   	push   %eax
  80098e:	ff 75 e0             	pushl  -0x20(%ebp)
  800991:	57                   	push   %edi
  800992:	ff 75 dc             	pushl  -0x24(%ebp)
  800995:	ff 75 d8             	pushl  -0x28(%ebp)
  800998:	89 da                	mov    %ebx,%edx
  80099a:	89 f0                	mov    %esi,%eax
  80099c:	e8 22 fb ff ff       	call   8004c3 <printnum>
			break;
  8009a1:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a7:	83 c7 01             	add    $0x1,%edi
  8009aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009ae:	83 f8 25             	cmp    $0x25,%eax
  8009b1:	0f 84 3c fc ff ff    	je     8005f3 <vprintfmt+0x17>
			if (ch == '\0')
  8009b7:	85 c0                	test   %eax,%eax
  8009b9:	0f 84 55 01 00 00    	je     800b14 <vprintfmt+0x538>
			putch(ch, putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	53                   	push   %ebx
  8009c3:	50                   	push   %eax
  8009c4:	ff d6                	call   *%esi
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	eb dc                	jmp    8009a7 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009db:	8b 45 14             	mov    0x14(%ebp),%eax
  8009de:	8d 40 04             	lea    0x4(%eax),%eax
  8009e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e4:	e9 7c ff ff ff       	jmp    800965 <vprintfmt+0x389>
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	53                   	push   %ebx
  8009ed:	6a 30                	push   $0x30
  8009ef:	ff d6                	call   *%esi
			putch('x', putdat);
  8009f1:	83 c4 08             	add    $0x8,%esp
  8009f4:	53                   	push   %ebx
  8009f5:	6a 78                	push   $0x78
  8009f7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800a03:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a06:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a09:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	8d 40 04             	lea    0x4(%eax),%eax
  800a12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a15:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a1a:	e9 56 ff ff ff       	jmp    800975 <vprintfmt+0x399>
	if (lflag >= 2)
  800a1f:	83 f9 01             	cmp    $0x1,%ecx
  800a22:	7f 27                	jg     800a4b <vprintfmt+0x46f>
	else if (lflag)
  800a24:	85 c9                	test   %ecx,%ecx
  800a26:	74 44                	je     800a6c <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	8b 00                	mov    (%eax),%eax
  800a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a32:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a35:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	8d 40 04             	lea    0x4(%eax),%eax
  800a3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a41:	bf 10 00 00 00       	mov    $0x10,%edi
  800a46:	e9 2a ff ff ff       	jmp    800975 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4e:	8b 50 04             	mov    0x4(%eax),%edx
  800a51:	8b 00                	mov    (%eax),%eax
  800a53:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a56:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a59:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5c:	8d 40 08             	lea    0x8(%eax),%eax
  800a5f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a62:	bf 10 00 00 00       	mov    $0x10,%edi
  800a67:	e9 09 ff ff ff       	jmp    800975 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	8b 00                	mov    (%eax),%eax
  800a71:	ba 00 00 00 00       	mov    $0x0,%edx
  800a76:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a79:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	8d 40 04             	lea    0x4(%eax),%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a85:	bf 10 00 00 00       	mov    $0x10,%edi
  800a8a:	e9 e6 fe ff ff       	jmp    800975 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8d 78 04             	lea    0x4(%eax),%edi
  800a95:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800a97:	85 c0                	test   %eax,%eax
  800a99:	74 2d                	je     800ac8 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800a9b:	0f b6 13             	movzbl (%ebx),%edx
  800a9e:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800aa0:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800aa3:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800aa6:	0f 8e f8 fe ff ff    	jle    8009a4 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800aac:	68 2c 13 80 00       	push   $0x80132c
  800ab1:	68 de 11 80 00       	push   $0x8011de
  800ab6:	53                   	push   %ebx
  800ab7:	56                   	push   %esi
  800ab8:	e8 02 fb ff ff       	call   8005bf <printfmt>
  800abd:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ac0:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ac3:	e9 dc fe ff ff       	jmp    8009a4 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800ac8:	68 f4 12 80 00       	push   $0x8012f4
  800acd:	68 de 11 80 00       	push   $0x8011de
  800ad2:	53                   	push   %ebx
  800ad3:	56                   	push   %esi
  800ad4:	e8 e6 fa ff ff       	call   8005bf <printfmt>
  800ad9:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800adc:	89 7d 14             	mov    %edi,0x14(%ebp)
  800adf:	e9 c0 fe ff ff       	jmp    8009a4 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	53                   	push   %ebx
  800ae8:	6a 25                	push   $0x25
  800aea:	ff d6                	call   *%esi
			break;
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	e9 b0 fe ff ff       	jmp    8009a4 <vprintfmt+0x3c8>
			putch('%', putdat);
  800af4:	83 ec 08             	sub    $0x8,%esp
  800af7:	53                   	push   %ebx
  800af8:	6a 25                	push   $0x25
  800afa:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	89 f8                	mov    %edi,%eax
  800b01:	eb 03                	jmp    800b06 <vprintfmt+0x52a>
  800b03:	83 e8 01             	sub    $0x1,%eax
  800b06:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b0a:	75 f7                	jne    800b03 <vprintfmt+0x527>
  800b0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b0f:	e9 90 fe ff ff       	jmp    8009a4 <vprintfmt+0x3c8>
}
  800b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b17:	5b                   	pop    %ebx
  800b18:	5e                   	pop    %esi
  800b19:	5f                   	pop    %edi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 18             	sub    $0x18,%esp
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b2f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b39:	85 c0                	test   %eax,%eax
  800b3b:	74 26                	je     800b63 <vsnprintf+0x47>
  800b3d:	85 d2                	test   %edx,%edx
  800b3f:	7e 22                	jle    800b63 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b41:	ff 75 14             	pushl  0x14(%ebp)
  800b44:	ff 75 10             	pushl  0x10(%ebp)
  800b47:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4a:	50                   	push   %eax
  800b4b:	68 a2 05 80 00       	push   $0x8005a2
  800b50:	e8 87 fa ff ff       	call   8005dc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b58:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    
		return -E_INVAL;
  800b63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b68:	eb f7                	jmp    800b61 <vsnprintf+0x45>

00800b6a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b70:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b73:	50                   	push   %eax
  800b74:	ff 75 10             	pushl  0x10(%ebp)
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	ff 75 08             	pushl  0x8(%ebp)
  800b7d:	e8 9a ff ff ff       	call   800b1c <vsnprintf>
	va_end(ap);

	return rc;
}
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b93:	74 05                	je     800b9a <strlen+0x16>
		n++;
  800b95:	83 c0 01             	add    $0x1,%eax
  800b98:	eb f5                	jmp    800b8f <strlen+0xb>
	return n;
}
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 0d                	je     800bbb <strnlen+0x1f>
  800bae:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bb2:	74 05                	je     800bb9 <strnlen+0x1d>
		n++;
  800bb4:	83 c2 01             	add    $0x1,%edx
  800bb7:	eb f1                	jmp    800baa <strnlen+0xe>
  800bb9:	89 d0                	mov    %edx,%eax
	return n;
}
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	53                   	push   %ebx
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcc:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bd0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bd3:	83 c2 01             	add    $0x1,%edx
  800bd6:	84 c9                	test   %cl,%cl
  800bd8:	75 f2                	jne    800bcc <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bda:	5b                   	pop    %ebx
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	53                   	push   %ebx
  800be1:	83 ec 10             	sub    $0x10,%esp
  800be4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800be7:	53                   	push   %ebx
  800be8:	e8 97 ff ff ff       	call   800b84 <strlen>
  800bed:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	01 d8                	add    %ebx,%eax
  800bf5:	50                   	push   %eax
  800bf6:	e8 c2 ff ff ff       	call   800bbd <strcpy>
	return dst;
}
  800bfb:	89 d8                	mov    %ebx,%eax
  800bfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	56                   	push   %esi
  800c06:	53                   	push   %ebx
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	89 c6                	mov    %eax,%esi
  800c0f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	39 f2                	cmp    %esi,%edx
  800c16:	74 11                	je     800c29 <strncpy+0x27>
		*dst++ = *src;
  800c18:	83 c2 01             	add    $0x1,%edx
  800c1b:	0f b6 19             	movzbl (%ecx),%ebx
  800c1e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c21:	80 fb 01             	cmp    $0x1,%bl
  800c24:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c27:	eb eb                	jmp    800c14 <strncpy+0x12>
	}
	return ret;
}
  800c29:	5b                   	pop    %ebx
  800c2a:	5e                   	pop    %esi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	8b 75 08             	mov    0x8(%ebp),%esi
  800c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c38:	8b 55 10             	mov    0x10(%ebp),%edx
  800c3b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c3d:	85 d2                	test   %edx,%edx
  800c3f:	74 21                	je     800c62 <strlcpy+0x35>
  800c41:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c45:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c47:	39 c2                	cmp    %eax,%edx
  800c49:	74 14                	je     800c5f <strlcpy+0x32>
  800c4b:	0f b6 19             	movzbl (%ecx),%ebx
  800c4e:	84 db                	test   %bl,%bl
  800c50:	74 0b                	je     800c5d <strlcpy+0x30>
			*dst++ = *src++;
  800c52:	83 c1 01             	add    $0x1,%ecx
  800c55:	83 c2 01             	add    $0x1,%edx
  800c58:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c5b:	eb ea                	jmp    800c47 <strlcpy+0x1a>
  800c5d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c5f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c62:	29 f0                	sub    %esi,%eax
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c71:	0f b6 01             	movzbl (%ecx),%eax
  800c74:	84 c0                	test   %al,%al
  800c76:	74 0c                	je     800c84 <strcmp+0x1c>
  800c78:	3a 02                	cmp    (%edx),%al
  800c7a:	75 08                	jne    800c84 <strcmp+0x1c>
		p++, q++;
  800c7c:	83 c1 01             	add    $0x1,%ecx
  800c7f:	83 c2 01             	add    $0x1,%edx
  800c82:	eb ed                	jmp    800c71 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c84:	0f b6 c0             	movzbl %al,%eax
  800c87:	0f b6 12             	movzbl (%edx),%edx
  800c8a:	29 d0                	sub    %edx,%eax
}
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	53                   	push   %ebx
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c98:	89 c3                	mov    %eax,%ebx
  800c9a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c9d:	eb 06                	jmp    800ca5 <strncmp+0x17>
		n--, p++, q++;
  800c9f:	83 c0 01             	add    $0x1,%eax
  800ca2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ca5:	39 d8                	cmp    %ebx,%eax
  800ca7:	74 16                	je     800cbf <strncmp+0x31>
  800ca9:	0f b6 08             	movzbl (%eax),%ecx
  800cac:	84 c9                	test   %cl,%cl
  800cae:	74 04                	je     800cb4 <strncmp+0x26>
  800cb0:	3a 0a                	cmp    (%edx),%cl
  800cb2:	74 eb                	je     800c9f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb4:	0f b6 00             	movzbl (%eax),%eax
  800cb7:	0f b6 12             	movzbl (%edx),%edx
  800cba:	29 d0                	sub    %edx,%eax
}
  800cbc:	5b                   	pop    %ebx
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    
		return 0;
  800cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc4:	eb f6                	jmp    800cbc <strncmp+0x2e>

00800cc6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd0:	0f b6 10             	movzbl (%eax),%edx
  800cd3:	84 d2                	test   %dl,%dl
  800cd5:	74 09                	je     800ce0 <strchr+0x1a>
		if (*s == c)
  800cd7:	38 ca                	cmp    %cl,%dl
  800cd9:	74 0a                	je     800ce5 <strchr+0x1f>
	for (; *s; s++)
  800cdb:	83 c0 01             	add    $0x1,%eax
  800cde:	eb f0                	jmp    800cd0 <strchr+0xa>
			return (char *) s;
	return 0;
  800ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cf4:	38 ca                	cmp    %cl,%dl
  800cf6:	74 09                	je     800d01 <strfind+0x1a>
  800cf8:	84 d2                	test   %dl,%dl
  800cfa:	74 05                	je     800d01 <strfind+0x1a>
	for (; *s; s++)
  800cfc:	83 c0 01             	add    $0x1,%eax
  800cff:	eb f0                	jmp    800cf1 <strfind+0xa>
			break;
	return (char *) s;
}
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d0f:	85 c9                	test   %ecx,%ecx
  800d11:	74 31                	je     800d44 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d13:	89 f8                	mov    %edi,%eax
  800d15:	09 c8                	or     %ecx,%eax
  800d17:	a8 03                	test   $0x3,%al
  800d19:	75 23                	jne    800d3e <memset+0x3b>
		c &= 0xFF;
  800d1b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d1f:	89 d3                	mov    %edx,%ebx
  800d21:	c1 e3 08             	shl    $0x8,%ebx
  800d24:	89 d0                	mov    %edx,%eax
  800d26:	c1 e0 18             	shl    $0x18,%eax
  800d29:	89 d6                	mov    %edx,%esi
  800d2b:	c1 e6 10             	shl    $0x10,%esi
  800d2e:	09 f0                	or     %esi,%eax
  800d30:	09 c2                	or     %eax,%edx
  800d32:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d34:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d37:	89 d0                	mov    %edx,%eax
  800d39:	fc                   	cld    
  800d3a:	f3 ab                	rep stos %eax,%es:(%edi)
  800d3c:	eb 06                	jmp    800d44 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	fc                   	cld    
  800d42:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d44:	89 f8                	mov    %edi,%eax
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d59:	39 c6                	cmp    %eax,%esi
  800d5b:	73 32                	jae    800d8f <memmove+0x44>
  800d5d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d60:	39 c2                	cmp    %eax,%edx
  800d62:	76 2b                	jbe    800d8f <memmove+0x44>
		s += n;
		d += n;
  800d64:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d67:	89 fe                	mov    %edi,%esi
  800d69:	09 ce                	or     %ecx,%esi
  800d6b:	09 d6                	or     %edx,%esi
  800d6d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d73:	75 0e                	jne    800d83 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d75:	83 ef 04             	sub    $0x4,%edi
  800d78:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d7b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d7e:	fd                   	std    
  800d7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d81:	eb 09                	jmp    800d8c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d83:	83 ef 01             	sub    $0x1,%edi
  800d86:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d89:	fd                   	std    
  800d8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d8c:	fc                   	cld    
  800d8d:	eb 1a                	jmp    800da9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8f:	89 c2                	mov    %eax,%edx
  800d91:	09 ca                	or     %ecx,%edx
  800d93:	09 f2                	or     %esi,%edx
  800d95:	f6 c2 03             	test   $0x3,%dl
  800d98:	75 0a                	jne    800da4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d9a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d9d:	89 c7                	mov    %eax,%edi
  800d9f:	fc                   	cld    
  800da0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da2:	eb 05                	jmp    800da9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800da4:	89 c7                	mov    %eax,%edi
  800da6:	fc                   	cld    
  800da7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800db3:	ff 75 10             	pushl  0x10(%ebp)
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	ff 75 08             	pushl  0x8(%ebp)
  800dbc:	e8 8a ff ff ff       	call   800d4b <memmove>
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dce:	89 c6                	mov    %eax,%esi
  800dd0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dd3:	39 f0                	cmp    %esi,%eax
  800dd5:	74 1c                	je     800df3 <memcmp+0x30>
		if (*s1 != *s2)
  800dd7:	0f b6 08             	movzbl (%eax),%ecx
  800dda:	0f b6 1a             	movzbl (%edx),%ebx
  800ddd:	38 d9                	cmp    %bl,%cl
  800ddf:	75 08                	jne    800de9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800de1:	83 c0 01             	add    $0x1,%eax
  800de4:	83 c2 01             	add    $0x1,%edx
  800de7:	eb ea                	jmp    800dd3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800de9:	0f b6 c1             	movzbl %cl,%eax
  800dec:	0f b6 db             	movzbl %bl,%ebx
  800def:	29 d8                	sub    %ebx,%eax
  800df1:	eb 05                	jmp    800df8 <memcmp+0x35>
	}

	return 0;
  800df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e05:	89 c2                	mov    %eax,%edx
  800e07:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e0a:	39 d0                	cmp    %edx,%eax
  800e0c:	73 09                	jae    800e17 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e0e:	38 08                	cmp    %cl,(%eax)
  800e10:	74 05                	je     800e17 <memfind+0x1b>
	for (; s < ends; s++)
  800e12:	83 c0 01             	add    $0x1,%eax
  800e15:	eb f3                	jmp    800e0a <memfind+0xe>
			break;
	return (void *) s;
}
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e22:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e25:	eb 03                	jmp    800e2a <strtol+0x11>
		s++;
  800e27:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e2a:	0f b6 01             	movzbl (%ecx),%eax
  800e2d:	3c 20                	cmp    $0x20,%al
  800e2f:	74 f6                	je     800e27 <strtol+0xe>
  800e31:	3c 09                	cmp    $0x9,%al
  800e33:	74 f2                	je     800e27 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e35:	3c 2b                	cmp    $0x2b,%al
  800e37:	74 2a                	je     800e63 <strtol+0x4a>
	int neg = 0;
  800e39:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e3e:	3c 2d                	cmp    $0x2d,%al
  800e40:	74 2b                	je     800e6d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e42:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e48:	75 0f                	jne    800e59 <strtol+0x40>
  800e4a:	80 39 30             	cmpb   $0x30,(%ecx)
  800e4d:	74 28                	je     800e77 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e4f:	85 db                	test   %ebx,%ebx
  800e51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e56:	0f 44 d8             	cmove  %eax,%ebx
  800e59:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e61:	eb 50                	jmp    800eb3 <strtol+0x9a>
		s++;
  800e63:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e66:	bf 00 00 00 00       	mov    $0x0,%edi
  800e6b:	eb d5                	jmp    800e42 <strtol+0x29>
		s++, neg = 1;
  800e6d:	83 c1 01             	add    $0x1,%ecx
  800e70:	bf 01 00 00 00       	mov    $0x1,%edi
  800e75:	eb cb                	jmp    800e42 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e77:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e7b:	74 0e                	je     800e8b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e7d:	85 db                	test   %ebx,%ebx
  800e7f:	75 d8                	jne    800e59 <strtol+0x40>
		s++, base = 8;
  800e81:	83 c1 01             	add    $0x1,%ecx
  800e84:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e89:	eb ce                	jmp    800e59 <strtol+0x40>
		s += 2, base = 16;
  800e8b:	83 c1 02             	add    $0x2,%ecx
  800e8e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e93:	eb c4                	jmp    800e59 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e95:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e98:	89 f3                	mov    %esi,%ebx
  800e9a:	80 fb 19             	cmp    $0x19,%bl
  800e9d:	77 29                	ja     800ec8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e9f:	0f be d2             	movsbl %dl,%edx
  800ea2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ea5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ea8:	7d 30                	jge    800eda <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800eaa:	83 c1 01             	add    $0x1,%ecx
  800ead:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eb1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800eb3:	0f b6 11             	movzbl (%ecx),%edx
  800eb6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800eb9:	89 f3                	mov    %esi,%ebx
  800ebb:	80 fb 09             	cmp    $0x9,%bl
  800ebe:	77 d5                	ja     800e95 <strtol+0x7c>
			dig = *s - '0';
  800ec0:	0f be d2             	movsbl %dl,%edx
  800ec3:	83 ea 30             	sub    $0x30,%edx
  800ec6:	eb dd                	jmp    800ea5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ec8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ecb:	89 f3                	mov    %esi,%ebx
  800ecd:	80 fb 19             	cmp    $0x19,%bl
  800ed0:	77 08                	ja     800eda <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ed2:	0f be d2             	movsbl %dl,%edx
  800ed5:	83 ea 37             	sub    $0x37,%edx
  800ed8:	eb cb                	jmp    800ea5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ede:	74 05                	je     800ee5 <strtol+0xcc>
		*endptr = (char *) s;
  800ee0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ee3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ee5:	89 c2                	mov    %eax,%edx
  800ee7:	f7 da                	neg    %edx
  800ee9:	85 ff                	test   %edi,%edi
  800eeb:	0f 45 c2             	cmovne %edx,%eax
}
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    
  800ef3:	66 90                	xchg   %ax,%ax
  800ef5:	66 90                	xchg   %ax,%ax
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
