
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 a4 01 00 00       	call   8001d5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 c1 0d 00 00       	call   800e0b <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 ea 0d 00 00       	call   800e4e <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 29 0b 00 00       	call   800ba7 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 03 0e 00 00       	call   800e90 <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 e0 12 80 00       	push   $0x8012e0
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 f3 12 80 00       	push   $0x8012f3
  8000a8:	e8 83 01 00 00       	call   800230 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 03 13 80 00       	push   $0x801303
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 f3 12 80 00       	push   $0x8012f3
  8000ba:	e8 71 01 00 00       	call   800230 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 14 13 80 00       	push   $0x801314
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 f3 12 80 00       	push   $0x8012f3
  8000cc:	e8 5f 01 00 00       	call   800230 <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 2c                	js     800112 <dumbfork+0x41>
  8000e6:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	74 3a                	je     800124 <dumbfork+0x53>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ea:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f4:	81 fa 08 20 80 00    	cmp    $0x802008,%edx
  8000fa:	73 44                	jae    800140 <dumbfork+0x6f>
		duppage(envid, addr);
  8000fc:	83 ec 08             	sub    $0x8,%esp
  8000ff:	52                   	push   %edx
  800100:	56                   	push   %esi
  800101:	e8 2d ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800106:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	eb df                	jmp    8000f1 <dumbfork+0x20>
		panic("sys_exofork: %e", envid);
  800112:	50                   	push   %eax
  800113:	68 27 13 80 00       	push   $0x801327
  800118:	6a 37                	push   $0x37
  80011a:	68 f3 12 80 00       	push   $0x8012f3
  80011f:	e8 0c 01 00 00       	call   800230 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800124:	e8 a4 0c 00 00       	call   800dcd <sys_getenvid>
  800129:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012e:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800131:	c1 e0 04             	shl    $0x4,%eax
  800134:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800139:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80013e:	eb 24                	jmp    800164 <dumbfork+0x93>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800146:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014b:	50                   	push   %eax
  80014c:	53                   	push   %ebx
  80014d:	e8 e1 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800152:	83 c4 08             	add    $0x8,%esp
  800155:	6a 02                	push   $0x2
  800157:	53                   	push   %ebx
  800158:	e8 b6 0d 00 00       	call   800f13 <sys_env_set_status>
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	85 c0                	test   %eax,%eax
  800162:	78 09                	js     80016d <dumbfork+0x9c>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800164:	89 d8                	mov    %ebx,%eax
  800166:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800169:	5b                   	pop    %ebx
  80016a:	5e                   	pop    %esi
  80016b:	5d                   	pop    %ebp
  80016c:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016d:	50                   	push   %eax
  80016e:	68 37 13 80 00       	push   $0x801337
  800173:	6a 4c                	push   $0x4c
  800175:	68 f3 12 80 00       	push   $0x8012f3
  80017a:	e8 b1 00 00 00       	call   800230 <_panic>

0080017f <umain>:
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	57                   	push   %edi
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
  800185:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800188:	e8 44 ff ff ff       	call   8000d1 <dumbfork>
  80018d:	89 c7                	mov    %eax,%edi
  80018f:	85 c0                	test   %eax,%eax
  800191:	be 4e 13 80 00       	mov    $0x80134e,%esi
  800196:	b8 55 13 80 00       	mov    $0x801355,%eax
  80019b:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a3:	eb 1f                	jmp    8001c4 <umain+0x45>
  8001a5:	83 fb 13             	cmp    $0x13,%ebx
  8001a8:	7f 23                	jg     8001cd <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
  8001af:	68 5b 13 80 00       	push   $0x80135b
  8001b4:	e8 52 01 00 00       	call   80030b <cprintf>
		sys_yield();
  8001b9:	e8 2e 0c 00 00       	call   800dec <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001be:	83 c3 01             	add    $0x1,%ebx
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 ff                	test   %edi,%edi
  8001c6:	74 dd                	je     8001a5 <umain+0x26>
  8001c8:	83 fb 09             	cmp    $0x9,%ebx
  8001cb:	7e dd                	jle    8001aa <umain+0x2b>
}
  8001cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d0:	5b                   	pop    %ebx
  8001d1:	5e                   	pop    %esi
  8001d2:	5f                   	pop    %edi
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001dd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001e0:	e8 e8 0b 00 00       	call   800dcd <sys_getenvid>
  8001e5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ea:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8001ed:	c1 e0 04             	shl    $0x4,%eax
  8001f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f5:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fa:	85 db                	test   %ebx,%ebx
  8001fc:	7e 07                	jle    800205 <libmain+0x30>
		binaryname = argv[0];
  8001fe:	8b 06                	mov    (%esi),%eax
  800200:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	e8 70 ff ff ff       	call   80017f <umain>

	// exit gracefully
	exit();
  80020f:	e8 0a 00 00 00       	call   80021e <exit>
}
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800224:	6a 00                	push   $0x0
  800226:	e8 61 0b 00 00       	call   800d8c <sys_env_destroy>
}
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	c9                   	leave  
  80022f:	c3                   	ret    

00800230 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800235:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800238:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80023e:	e8 8a 0b 00 00       	call   800dcd <sys_getenvid>
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	ff 75 0c             	pushl  0xc(%ebp)
  800249:	ff 75 08             	pushl  0x8(%ebp)
  80024c:	56                   	push   %esi
  80024d:	50                   	push   %eax
  80024e:	68 78 13 80 00       	push   $0x801378
  800253:	e8 b3 00 00 00       	call   80030b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800258:	83 c4 18             	add    $0x18,%esp
  80025b:	53                   	push   %ebx
  80025c:	ff 75 10             	pushl  0x10(%ebp)
  80025f:	e8 56 00 00 00       	call   8002ba <vcprintf>
	cprintf("\n");
  800264:	c7 04 24 6b 13 80 00 	movl   $0x80136b,(%esp)
  80026b:	e8 9b 00 00 00       	call   80030b <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800273:	cc                   	int3   
  800274:	eb fd                	jmp    800273 <_panic+0x43>

00800276 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	53                   	push   %ebx
  80027a:	83 ec 04             	sub    $0x4,%esp
  80027d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800280:	8b 13                	mov    (%ebx),%edx
  800282:	8d 42 01             	lea    0x1(%edx),%eax
  800285:	89 03                	mov    %eax,(%ebx)
  800287:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800293:	74 09                	je     80029e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800295:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800299:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029c:	c9                   	leave  
  80029d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	68 ff 00 00 00       	push   $0xff
  8002a6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a9:	50                   	push   %eax
  8002aa:	e8 a0 0a 00 00       	call   800d4f <sys_cputs>
		b->idx = 0;
  8002af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	eb db                	jmp    800295 <putch+0x1f>

008002ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ca:	00 00 00 
	b.cnt = 0;
  8002cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d7:	ff 75 0c             	pushl  0xc(%ebp)
  8002da:	ff 75 08             	pushl  0x8(%ebp)
  8002dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	68 76 02 80 00       	push   $0x800276
  8002e9:	e8 4a 01 00 00       	call   800438 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ee:	83 c4 08             	add    $0x8,%esp
  8002f1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002fd:	50                   	push   %eax
  8002fe:	e8 4c 0a 00 00       	call   800d4f <sys_cputs>

	return b.cnt;
}
  800303:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800311:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800314:	50                   	push   %eax
  800315:	ff 75 08             	pushl  0x8(%ebp)
  800318:	e8 9d ff ff ff       	call   8002ba <vcprintf>
	va_end(ap);

	return cnt;
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	57                   	push   %edi
  800323:	56                   	push   %esi
  800324:	53                   	push   %ebx
  800325:	83 ec 1c             	sub    $0x1c,%esp
  800328:	89 c6                	mov    %eax,%esi
  80032a:	89 d7                	mov    %edx,%edi
  80032c:	8b 45 08             	mov    0x8(%ebp),%eax
  80032f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800332:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800335:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800338:	8b 45 10             	mov    0x10(%ebp),%eax
  80033b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80033e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800342:	74 2c                	je     800370 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800344:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800347:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80034e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800351:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800354:	39 c2                	cmp    %eax,%edx
  800356:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800359:	73 43                	jae    80039e <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80035b:	83 eb 01             	sub    $0x1,%ebx
  80035e:	85 db                	test   %ebx,%ebx
  800360:	7e 6c                	jle    8003ce <printnum+0xaf>
			putch(padc, putdat);
  800362:	83 ec 08             	sub    $0x8,%esp
  800365:	57                   	push   %edi
  800366:	ff 75 18             	pushl  0x18(%ebp)
  800369:	ff d6                	call   *%esi
  80036b:	83 c4 10             	add    $0x10,%esp
  80036e:	eb eb                	jmp    80035b <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	6a 20                	push   $0x20
  800375:	6a 00                	push   $0x0
  800377:	50                   	push   %eax
  800378:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037b:	ff 75 e0             	pushl  -0x20(%ebp)
  80037e:	89 fa                	mov    %edi,%edx
  800380:	89 f0                	mov    %esi,%eax
  800382:	e8 98 ff ff ff       	call   80031f <printnum>
		while (--width > 0)
  800387:	83 c4 20             	add    $0x20,%esp
  80038a:	83 eb 01             	sub    $0x1,%ebx
  80038d:	85 db                	test   %ebx,%ebx
  80038f:	7e 65                	jle    8003f6 <printnum+0xd7>
			putch(padc, putdat);
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	57                   	push   %edi
  800395:	6a 20                	push   $0x20
  800397:	ff d6                	call   *%esi
  800399:	83 c4 10             	add    $0x10,%esp
  80039c:	eb ec                	jmp    80038a <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 18             	pushl  0x18(%ebp)
  8003a4:	83 eb 01             	sub    $0x1,%ebx
  8003a7:	53                   	push   %ebx
  8003a8:	50                   	push   %eax
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8003af:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b8:	e8 c3 0c 00 00       	call   801080 <__udivdi3>
  8003bd:	83 c4 18             	add    $0x18,%esp
  8003c0:	52                   	push   %edx
  8003c1:	50                   	push   %eax
  8003c2:	89 fa                	mov    %edi,%edx
  8003c4:	89 f0                	mov    %esi,%eax
  8003c6:	e8 54 ff ff ff       	call   80031f <printnum>
  8003cb:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	57                   	push   %edi
  8003d2:	83 ec 04             	sub    $0x4,%esp
  8003d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003de:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e1:	e8 aa 0d 00 00       	call   801190 <__umoddi3>
  8003e6:	83 c4 14             	add    $0x14,%esp
  8003e9:	0f be 80 9b 13 80 00 	movsbl 0x80139b(%eax),%eax
  8003f0:	50                   	push   %eax
  8003f1:	ff d6                	call   *%esi
  8003f3:	83 c4 10             	add    $0x10,%esp
}
  8003f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f9:	5b                   	pop    %ebx
  8003fa:	5e                   	pop    %esi
  8003fb:	5f                   	pop    %edi
  8003fc:	5d                   	pop    %ebp
  8003fd:	c3                   	ret    

008003fe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800404:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800408:	8b 10                	mov    (%eax),%edx
  80040a:	3b 50 04             	cmp    0x4(%eax),%edx
  80040d:	73 0a                	jae    800419 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800412:	89 08                	mov    %ecx,(%eax)
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	88 02                	mov    %al,(%edx)
}
  800419:	5d                   	pop    %ebp
  80041a:	c3                   	ret    

0080041b <printfmt>:
{
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800421:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800424:	50                   	push   %eax
  800425:	ff 75 10             	pushl  0x10(%ebp)
  800428:	ff 75 0c             	pushl  0xc(%ebp)
  80042b:	ff 75 08             	pushl  0x8(%ebp)
  80042e:	e8 05 00 00 00       	call   800438 <vprintfmt>
}
  800433:	83 c4 10             	add    $0x10,%esp
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <vprintfmt>:
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	57                   	push   %edi
  80043c:	56                   	push   %esi
  80043d:	53                   	push   %ebx
  80043e:	83 ec 3c             	sub    $0x3c,%esp
  800441:	8b 75 08             	mov    0x8(%ebp),%esi
  800444:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800447:	8b 7d 10             	mov    0x10(%ebp),%edi
  80044a:	e9 b4 03 00 00       	jmp    800803 <vprintfmt+0x3cb>
		padc = ' ';
  80044f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800453:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80045a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800461:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800468:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80046f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800474:	8d 47 01             	lea    0x1(%edi),%eax
  800477:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047a:	0f b6 17             	movzbl (%edi),%edx
  80047d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800480:	3c 55                	cmp    $0x55,%al
  800482:	0f 87 c8 04 00 00    	ja     800950 <vprintfmt+0x518>
  800488:	0f b6 c0             	movzbl %al,%eax
  80048b:	ff 24 85 80 15 80 00 	jmp    *0x801580(,%eax,4)
  800492:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800495:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80049c:	eb d6                	jmp    800474 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80049e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004a1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004a5:	eb cd                	jmp    800474 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	0f b6 d2             	movzbl %dl,%edx
  8004aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8004b5:	eb 0c                	jmp    8004c3 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8004b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004ba:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8004be:	eb b4                	jmp    800474 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8004c0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004ca:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004cd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004d0:	83 f9 09             	cmp    $0x9,%ecx
  8004d3:	76 eb                	jbe    8004c0 <vprintfmt+0x88>
  8004d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004db:	eb 14                	jmp    8004f1 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e8:	8d 40 04             	lea    0x4(%eax),%eax
  8004eb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f5:	0f 89 79 ff ff ff    	jns    800474 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8004fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800501:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800508:	e9 67 ff ff ff       	jmp    800474 <vprintfmt+0x3c>
  80050d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800510:	85 c0                	test   %eax,%eax
  800512:	ba 00 00 00 00       	mov    $0x0,%edx
  800517:	0f 49 d0             	cmovns %eax,%edx
  80051a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80051d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800520:	e9 4f ff ff ff       	jmp    800474 <vprintfmt+0x3c>
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800528:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80052f:	e9 40 ff ff ff       	jmp    800474 <vprintfmt+0x3c>
			lflag++;
  800534:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800537:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80053a:	e9 35 ff ff ff       	jmp    800474 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8d 78 04             	lea    0x4(%eax),%edi
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	53                   	push   %ebx
  800549:	ff 30                	pushl  (%eax)
  80054b:	ff d6                	call   *%esi
			break;
  80054d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800550:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800553:	e9 a8 02 00 00       	jmp    800800 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8d 78 04             	lea    0x4(%eax),%edi
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	99                   	cltd   
  800561:	31 d0                	xor    %edx,%eax
  800563:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800565:	83 f8 0f             	cmp    $0xf,%eax
  800568:	7f 23                	jg     80058d <vprintfmt+0x155>
  80056a:	8b 14 85 e0 16 80 00 	mov    0x8016e0(,%eax,4),%edx
  800571:	85 d2                	test   %edx,%edx
  800573:	74 18                	je     80058d <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800575:	52                   	push   %edx
  800576:	68 bc 13 80 00       	push   $0x8013bc
  80057b:	53                   	push   %ebx
  80057c:	56                   	push   %esi
  80057d:	e8 99 fe ff ff       	call   80041b <printfmt>
  800582:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800585:	89 7d 14             	mov    %edi,0x14(%ebp)
  800588:	e9 73 02 00 00       	jmp    800800 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80058d:	50                   	push   %eax
  80058e:	68 b3 13 80 00       	push   $0x8013b3
  800593:	53                   	push   %ebx
  800594:	56                   	push   %esi
  800595:	e8 81 fe ff ff       	call   80041b <printfmt>
  80059a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80059d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005a0:	e9 5b 02 00 00       	jmp    800800 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	83 c0 04             	add    $0x4,%eax
  8005ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005b3:	85 d2                	test   %edx,%edx
  8005b5:	b8 ac 13 80 00       	mov    $0x8013ac,%eax
  8005ba:	0f 45 c2             	cmovne %edx,%eax
  8005bd:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c4:	7e 06                	jle    8005cc <vprintfmt+0x194>
  8005c6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005ca:	75 0d                	jne    8005d9 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005cf:	89 c7                	mov    %eax,%edi
  8005d1:	03 45 e0             	add    -0x20(%ebp),%eax
  8005d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d7:	eb 53                	jmp    80062c <vprintfmt+0x1f4>
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8005df:	50                   	push   %eax
  8005e0:	e8 13 04 00 00       	call   8009f8 <strnlen>
  8005e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e8:	29 c1                	sub    %eax,%ecx
  8005ea:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005f2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f9:	eb 0f                	jmp    80060a <vprintfmt+0x1d2>
					putch(padc, putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800602:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800604:	83 ef 01             	sub    $0x1,%edi
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	85 ff                	test   %edi,%edi
  80060c:	7f ed                	jg     8005fb <vprintfmt+0x1c3>
  80060e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800611:	85 d2                	test   %edx,%edx
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	0f 49 c2             	cmovns %edx,%eax
  80061b:	29 c2                	sub    %eax,%edx
  80061d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800620:	eb aa                	jmp    8005cc <vprintfmt+0x194>
					putch(ch, putdat);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	53                   	push   %ebx
  800626:	52                   	push   %edx
  800627:	ff d6                	call   *%esi
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80062f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800631:	83 c7 01             	add    $0x1,%edi
  800634:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800638:	0f be d0             	movsbl %al,%edx
  80063b:	85 d2                	test   %edx,%edx
  80063d:	74 4b                	je     80068a <vprintfmt+0x252>
  80063f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800643:	78 06                	js     80064b <vprintfmt+0x213>
  800645:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800649:	78 1e                	js     800669 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80064b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80064f:	74 d1                	je     800622 <vprintfmt+0x1ea>
  800651:	0f be c0             	movsbl %al,%eax
  800654:	83 e8 20             	sub    $0x20,%eax
  800657:	83 f8 5e             	cmp    $0x5e,%eax
  80065a:	76 c6                	jbe    800622 <vprintfmt+0x1ea>
					putch('?', putdat);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	53                   	push   %ebx
  800660:	6a 3f                	push   $0x3f
  800662:	ff d6                	call   *%esi
  800664:	83 c4 10             	add    $0x10,%esp
  800667:	eb c3                	jmp    80062c <vprintfmt+0x1f4>
  800669:	89 cf                	mov    %ecx,%edi
  80066b:	eb 0e                	jmp    80067b <vprintfmt+0x243>
				putch(' ', putdat);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	53                   	push   %ebx
  800671:	6a 20                	push   $0x20
  800673:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800675:	83 ef 01             	sub    $0x1,%edi
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	85 ff                	test   %edi,%edi
  80067d:	7f ee                	jg     80066d <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80067f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
  800685:	e9 76 01 00 00       	jmp    800800 <vprintfmt+0x3c8>
  80068a:	89 cf                	mov    %ecx,%edi
  80068c:	eb ed                	jmp    80067b <vprintfmt+0x243>
	if (lflag >= 2)
  80068e:	83 f9 01             	cmp    $0x1,%ecx
  800691:	7f 1f                	jg     8006b2 <vprintfmt+0x27a>
	else if (lflag)
  800693:	85 c9                	test   %ecx,%ecx
  800695:	74 6a                	je     800701 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b0:	eb 17                	jmp    8006c9 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 50 04             	mov    0x4(%eax),%edx
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 40 08             	lea    0x8(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8006cc:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006d1:	85 d2                	test   %edx,%edx
  8006d3:	0f 89 f8 00 00 00    	jns    8007d1 <vprintfmt+0x399>
				putch('-', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 2d                	push   $0x2d
  8006df:	ff d6                	call   *%esi
				num = -(long long) num;
  8006e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006e7:	f7 d8                	neg    %eax
  8006e9:	83 d2 00             	adc    $0x0,%edx
  8006ec:	f7 da                	neg    %edx
  8006ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006f7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006fc:	e9 e1 00 00 00       	jmp    8007e2 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800709:	99                   	cltd   
  80070a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8d 40 04             	lea    0x4(%eax),%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
  800716:	eb b1                	jmp    8006c9 <vprintfmt+0x291>
	if (lflag >= 2)
  800718:	83 f9 01             	cmp    $0x1,%ecx
  80071b:	7f 27                	jg     800744 <vprintfmt+0x30c>
	else if (lflag)
  80071d:	85 c9                	test   %ecx,%ecx
  80071f:	74 41                	je     800762 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
  80072b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8d 40 04             	lea    0x4(%eax),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80073f:	e9 8d 00 00 00       	jmp    8007d1 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 50 04             	mov    0x4(%eax),%edx
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 40 08             	lea    0x8(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800760:	eb 6f                	jmp    8007d1 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	ba 00 00 00 00       	mov    $0x0,%edx
  80076c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8d 40 04             	lea    0x4(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80077b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800780:	eb 4f                	jmp    8007d1 <vprintfmt+0x399>
	if (lflag >= 2)
  800782:	83 f9 01             	cmp    $0x1,%ecx
  800785:	7f 23                	jg     8007aa <vprintfmt+0x372>
	else if (lflag)
  800787:	85 c9                	test   %ecx,%ecx
  800789:	0f 84 98 00 00 00    	je     800827 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	ba 00 00 00 00       	mov    $0x0,%edx
  800799:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8d 40 04             	lea    0x4(%eax),%eax
  8007a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a8:	eb 17                	jmp    8007c1 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 50 04             	mov    0x4(%eax),%edx
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8d 40 08             	lea    0x8(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	53                   	push   %ebx
  8007c5:	6a 30                	push   $0x30
  8007c7:	ff d6                	call   *%esi
			goto number;
  8007c9:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007cc:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8007d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007d5:	74 0b                	je     8007e2 <vprintfmt+0x3aa>
				putch('+', putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	53                   	push   %ebx
  8007db:	6a 2b                	push   $0x2b
  8007dd:	ff d6                	call   *%esi
  8007df:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8007e2:	83 ec 0c             	sub    $0xc,%esp
  8007e5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007e9:	50                   	push   %eax
  8007ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ed:	57                   	push   %edi
  8007ee:	ff 75 dc             	pushl  -0x24(%ebp)
  8007f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f4:	89 da                	mov    %ebx,%edx
  8007f6:	89 f0                	mov    %esi,%eax
  8007f8:	e8 22 fb ff ff       	call   80031f <printnum>
			break;
  8007fd:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800800:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800803:	83 c7 01             	add    $0x1,%edi
  800806:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80080a:	83 f8 25             	cmp    $0x25,%eax
  80080d:	0f 84 3c fc ff ff    	je     80044f <vprintfmt+0x17>
			if (ch == '\0')
  800813:	85 c0                	test   %eax,%eax
  800815:	0f 84 55 01 00 00    	je     800970 <vprintfmt+0x538>
			putch(ch, putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	53                   	push   %ebx
  80081f:	50                   	push   %eax
  800820:	ff d6                	call   *%esi
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	eb dc                	jmp    800803 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800834:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	8d 40 04             	lea    0x4(%eax),%eax
  80083d:	89 45 14             	mov    %eax,0x14(%ebp)
  800840:	e9 7c ff ff ff       	jmp    8007c1 <vprintfmt+0x389>
			putch('0', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	53                   	push   %ebx
  800849:	6a 30                	push   $0x30
  80084b:	ff d6                	call   *%esi
			putch('x', putdat);
  80084d:	83 c4 08             	add    $0x8,%esp
  800850:	53                   	push   %ebx
  800851:	6a 78                	push   $0x78
  800853:	ff d6                	call   *%esi
			num = (unsigned long long)
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	ba 00 00 00 00       	mov    $0x0,%edx
  80085f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800862:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800865:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 40 04             	lea    0x4(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800871:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800876:	e9 56 ff ff ff       	jmp    8007d1 <vprintfmt+0x399>
	if (lflag >= 2)
  80087b:	83 f9 01             	cmp    $0x1,%ecx
  80087e:	7f 27                	jg     8008a7 <vprintfmt+0x46f>
	else if (lflag)
  800880:	85 c9                	test   %ecx,%ecx
  800882:	74 44                	je     8008c8 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	ba 00 00 00 00       	mov    $0x0,%edx
  80088e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800891:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	8d 40 04             	lea    0x4(%eax),%eax
  80089a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089d:	bf 10 00 00 00       	mov    $0x10,%edi
  8008a2:	e9 2a ff ff ff       	jmp    8007d1 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8b 50 04             	mov    0x4(%eax),%edx
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 40 08             	lea    0x8(%eax),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008be:	bf 10 00 00 00       	mov    $0x10,%edi
  8008c3:	e9 09 ff ff ff       	jmp    8007d1 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8d 40 04             	lea    0x4(%eax),%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e1:	bf 10 00 00 00       	mov    $0x10,%edi
  8008e6:	e9 e6 fe ff ff       	jmp    8007d1 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	8d 78 04             	lea    0x4(%eax),%edi
  8008f1:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	74 2d                	je     800924 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8008f7:	0f b6 13             	movzbl (%ebx),%edx
  8008fa:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008fc:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8008ff:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800902:	0f 8e f8 fe ff ff    	jle    800800 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800908:	68 0c 15 80 00       	push   $0x80150c
  80090d:	68 bc 13 80 00       	push   $0x8013bc
  800912:	53                   	push   %ebx
  800913:	56                   	push   %esi
  800914:	e8 02 fb ff ff       	call   80041b <printfmt>
  800919:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80091c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80091f:	e9 dc fe ff ff       	jmp    800800 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800924:	68 d4 14 80 00       	push   $0x8014d4
  800929:	68 bc 13 80 00       	push   $0x8013bc
  80092e:	53                   	push   %ebx
  80092f:	56                   	push   %esi
  800930:	e8 e6 fa ff ff       	call   80041b <printfmt>
  800935:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800938:	89 7d 14             	mov    %edi,0x14(%ebp)
  80093b:	e9 c0 fe ff ff       	jmp    800800 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	53                   	push   %ebx
  800944:	6a 25                	push   $0x25
  800946:	ff d6                	call   *%esi
			break;
  800948:	83 c4 10             	add    $0x10,%esp
  80094b:	e9 b0 fe ff ff       	jmp    800800 <vprintfmt+0x3c8>
			putch('%', putdat);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	53                   	push   %ebx
  800954:	6a 25                	push   $0x25
  800956:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800958:	83 c4 10             	add    $0x10,%esp
  80095b:	89 f8                	mov    %edi,%eax
  80095d:	eb 03                	jmp    800962 <vprintfmt+0x52a>
  80095f:	83 e8 01             	sub    $0x1,%eax
  800962:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800966:	75 f7                	jne    80095f <vprintfmt+0x527>
  800968:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096b:	e9 90 fe ff ff       	jmp    800800 <vprintfmt+0x3c8>
}
  800970:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800973:	5b                   	pop    %ebx
  800974:	5e                   	pop    %esi
  800975:	5f                   	pop    %edi
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	83 ec 18             	sub    $0x18,%esp
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80098b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800995:	85 c0                	test   %eax,%eax
  800997:	74 26                	je     8009bf <vsnprintf+0x47>
  800999:	85 d2                	test   %edx,%edx
  80099b:	7e 22                	jle    8009bf <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80099d:	ff 75 14             	pushl  0x14(%ebp)
  8009a0:	ff 75 10             	pushl  0x10(%ebp)
  8009a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a6:	50                   	push   %eax
  8009a7:	68 fe 03 80 00       	push   $0x8003fe
  8009ac:	e8 87 fa ff ff       	call   800438 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
}
  8009bd:	c9                   	leave  
  8009be:	c3                   	ret    
		return -E_INVAL;
  8009bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c4:	eb f7                	jmp    8009bd <vsnprintf+0x45>

008009c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009cc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009cf:	50                   	push   %eax
  8009d0:	ff 75 10             	pushl  0x10(%ebp)
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	ff 75 08             	pushl  0x8(%ebp)
  8009d9:	e8 9a ff ff ff       	call   800978 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ef:	74 05                	je     8009f6 <strlen+0x16>
		n++;
  8009f1:	83 c0 01             	add    $0x1,%eax
  8009f4:	eb f5                	jmp    8009eb <strlen+0xb>
	return n;
}
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a01:	ba 00 00 00 00       	mov    $0x0,%edx
  800a06:	39 c2                	cmp    %eax,%edx
  800a08:	74 0d                	je     800a17 <strnlen+0x1f>
  800a0a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a0e:	74 05                	je     800a15 <strnlen+0x1d>
		n++;
  800a10:	83 c2 01             	add    $0x1,%edx
  800a13:	eb f1                	jmp    800a06 <strnlen+0xe>
  800a15:	89 d0                	mov    %edx,%eax
	return n;
}
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a23:	ba 00 00 00 00       	mov    $0x0,%edx
  800a28:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a2c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a2f:	83 c2 01             	add    $0x1,%edx
  800a32:	84 c9                	test   %cl,%cl
  800a34:	75 f2                	jne    800a28 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a36:	5b                   	pop    %ebx
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	53                   	push   %ebx
  800a3d:	83 ec 10             	sub    $0x10,%esp
  800a40:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a43:	53                   	push   %ebx
  800a44:	e8 97 ff ff ff       	call   8009e0 <strlen>
  800a49:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	01 d8                	add    %ebx,%eax
  800a51:	50                   	push   %eax
  800a52:	e8 c2 ff ff ff       	call   800a19 <strcpy>
	return dst;
}
  800a57:	89 d8                	mov    %ebx,%eax
  800a59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a5c:	c9                   	leave  
  800a5d:	c3                   	ret    

00800a5e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	56                   	push   %esi
  800a62:	53                   	push   %ebx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a69:	89 c6                	mov    %eax,%esi
  800a6b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6e:	89 c2                	mov    %eax,%edx
  800a70:	39 f2                	cmp    %esi,%edx
  800a72:	74 11                	je     800a85 <strncpy+0x27>
		*dst++ = *src;
  800a74:	83 c2 01             	add    $0x1,%edx
  800a77:	0f b6 19             	movzbl (%ecx),%ebx
  800a7a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a7d:	80 fb 01             	cmp    $0x1,%bl
  800a80:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a83:	eb eb                	jmp    800a70 <strncpy+0x12>
	}
	return ret;
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	56                   	push   %esi
  800a8d:	53                   	push   %ebx
  800a8e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a94:	8b 55 10             	mov    0x10(%ebp),%edx
  800a97:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a99:	85 d2                	test   %edx,%edx
  800a9b:	74 21                	je     800abe <strlcpy+0x35>
  800a9d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800aa1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800aa3:	39 c2                	cmp    %eax,%edx
  800aa5:	74 14                	je     800abb <strlcpy+0x32>
  800aa7:	0f b6 19             	movzbl (%ecx),%ebx
  800aaa:	84 db                	test   %bl,%bl
  800aac:	74 0b                	je     800ab9 <strlcpy+0x30>
			*dst++ = *src++;
  800aae:	83 c1 01             	add    $0x1,%ecx
  800ab1:	83 c2 01             	add    $0x1,%edx
  800ab4:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab7:	eb ea                	jmp    800aa3 <strlcpy+0x1a>
  800ab9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800abb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800abe:	29 f0                	sub    %esi,%eax
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800acd:	0f b6 01             	movzbl (%ecx),%eax
  800ad0:	84 c0                	test   %al,%al
  800ad2:	74 0c                	je     800ae0 <strcmp+0x1c>
  800ad4:	3a 02                	cmp    (%edx),%al
  800ad6:	75 08                	jne    800ae0 <strcmp+0x1c>
		p++, q++;
  800ad8:	83 c1 01             	add    $0x1,%ecx
  800adb:	83 c2 01             	add    $0x1,%edx
  800ade:	eb ed                	jmp    800acd <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae0:	0f b6 c0             	movzbl %al,%eax
  800ae3:	0f b6 12             	movzbl (%edx),%edx
  800ae6:	29 d0                	sub    %edx,%eax
}
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	89 c3                	mov    %eax,%ebx
  800af6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800af9:	eb 06                	jmp    800b01 <strncmp+0x17>
		n--, p++, q++;
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b01:	39 d8                	cmp    %ebx,%eax
  800b03:	74 16                	je     800b1b <strncmp+0x31>
  800b05:	0f b6 08             	movzbl (%eax),%ecx
  800b08:	84 c9                	test   %cl,%cl
  800b0a:	74 04                	je     800b10 <strncmp+0x26>
  800b0c:	3a 0a                	cmp    (%edx),%cl
  800b0e:	74 eb                	je     800afb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b10:	0f b6 00             	movzbl (%eax),%eax
  800b13:	0f b6 12             	movzbl (%edx),%edx
  800b16:	29 d0                	sub    %edx,%eax
}
  800b18:	5b                   	pop    %ebx
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    
		return 0;
  800b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b20:	eb f6                	jmp    800b18 <strncmp+0x2e>

00800b22 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b2c:	0f b6 10             	movzbl (%eax),%edx
  800b2f:	84 d2                	test   %dl,%dl
  800b31:	74 09                	je     800b3c <strchr+0x1a>
		if (*s == c)
  800b33:	38 ca                	cmp    %cl,%dl
  800b35:	74 0a                	je     800b41 <strchr+0x1f>
	for (; *s; s++)
  800b37:	83 c0 01             	add    $0x1,%eax
  800b3a:	eb f0                	jmp    800b2c <strchr+0xa>
			return (char *) s;
	return 0;
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b4d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b50:	38 ca                	cmp    %cl,%dl
  800b52:	74 09                	je     800b5d <strfind+0x1a>
  800b54:	84 d2                	test   %dl,%dl
  800b56:	74 05                	je     800b5d <strfind+0x1a>
	for (; *s; s++)
  800b58:	83 c0 01             	add    $0x1,%eax
  800b5b:	eb f0                	jmp    800b4d <strfind+0xa>
			break;
	return (char *) s;
}
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	57                   	push   %edi
  800b63:	56                   	push   %esi
  800b64:	53                   	push   %ebx
  800b65:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b68:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b6b:	85 c9                	test   %ecx,%ecx
  800b6d:	74 31                	je     800ba0 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b6f:	89 f8                	mov    %edi,%eax
  800b71:	09 c8                	or     %ecx,%eax
  800b73:	a8 03                	test   $0x3,%al
  800b75:	75 23                	jne    800b9a <memset+0x3b>
		c &= 0xFF;
  800b77:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b7b:	89 d3                	mov    %edx,%ebx
  800b7d:	c1 e3 08             	shl    $0x8,%ebx
  800b80:	89 d0                	mov    %edx,%eax
  800b82:	c1 e0 18             	shl    $0x18,%eax
  800b85:	89 d6                	mov    %edx,%esi
  800b87:	c1 e6 10             	shl    $0x10,%esi
  800b8a:	09 f0                	or     %esi,%eax
  800b8c:	09 c2                	or     %eax,%edx
  800b8e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b90:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b93:	89 d0                	mov    %edx,%eax
  800b95:	fc                   	cld    
  800b96:	f3 ab                	rep stos %eax,%es:(%edi)
  800b98:	eb 06                	jmp    800ba0 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	fc                   	cld    
  800b9e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ba0:	89 f8                	mov    %edi,%eax
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5f                   	pop    %edi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb5:	39 c6                	cmp    %eax,%esi
  800bb7:	73 32                	jae    800beb <memmove+0x44>
  800bb9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bbc:	39 c2                	cmp    %eax,%edx
  800bbe:	76 2b                	jbe    800beb <memmove+0x44>
		s += n;
		d += n;
  800bc0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc3:	89 fe                	mov    %edi,%esi
  800bc5:	09 ce                	or     %ecx,%esi
  800bc7:	09 d6                	or     %edx,%esi
  800bc9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bcf:	75 0e                	jne    800bdf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bd1:	83 ef 04             	sub    $0x4,%edi
  800bd4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bda:	fd                   	std    
  800bdb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bdd:	eb 09                	jmp    800be8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bdf:	83 ef 01             	sub    $0x1,%edi
  800be2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be5:	fd                   	std    
  800be6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be8:	fc                   	cld    
  800be9:	eb 1a                	jmp    800c05 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800beb:	89 c2                	mov    %eax,%edx
  800bed:	09 ca                	or     %ecx,%edx
  800bef:	09 f2                	or     %esi,%edx
  800bf1:	f6 c2 03             	test   $0x3,%dl
  800bf4:	75 0a                	jne    800c00 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bf6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	fc                   	cld    
  800bfc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bfe:	eb 05                	jmp    800c05 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c00:	89 c7                	mov    %eax,%edi
  800c02:	fc                   	cld    
  800c03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c0f:	ff 75 10             	pushl  0x10(%ebp)
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	ff 75 08             	pushl  0x8(%ebp)
  800c18:	e8 8a ff ff ff       	call   800ba7 <memmove>
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2a:	89 c6                	mov    %eax,%esi
  800c2c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c2f:	39 f0                	cmp    %esi,%eax
  800c31:	74 1c                	je     800c4f <memcmp+0x30>
		if (*s1 != *s2)
  800c33:	0f b6 08             	movzbl (%eax),%ecx
  800c36:	0f b6 1a             	movzbl (%edx),%ebx
  800c39:	38 d9                	cmp    %bl,%cl
  800c3b:	75 08                	jne    800c45 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c3d:	83 c0 01             	add    $0x1,%eax
  800c40:	83 c2 01             	add    $0x1,%edx
  800c43:	eb ea                	jmp    800c2f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c45:	0f b6 c1             	movzbl %cl,%eax
  800c48:	0f b6 db             	movzbl %bl,%ebx
  800c4b:	29 d8                	sub    %ebx,%eax
  800c4d:	eb 05                	jmp    800c54 <memcmp+0x35>
	}

	return 0;
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c66:	39 d0                	cmp    %edx,%eax
  800c68:	73 09                	jae    800c73 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c6a:	38 08                	cmp    %cl,(%eax)
  800c6c:	74 05                	je     800c73 <memfind+0x1b>
	for (; s < ends; s++)
  800c6e:	83 c0 01             	add    $0x1,%eax
  800c71:	eb f3                	jmp    800c66 <memfind+0xe>
			break;
	return (void *) s;
}
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c81:	eb 03                	jmp    800c86 <strtol+0x11>
		s++;
  800c83:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c86:	0f b6 01             	movzbl (%ecx),%eax
  800c89:	3c 20                	cmp    $0x20,%al
  800c8b:	74 f6                	je     800c83 <strtol+0xe>
  800c8d:	3c 09                	cmp    $0x9,%al
  800c8f:	74 f2                	je     800c83 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c91:	3c 2b                	cmp    $0x2b,%al
  800c93:	74 2a                	je     800cbf <strtol+0x4a>
	int neg = 0;
  800c95:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c9a:	3c 2d                	cmp    $0x2d,%al
  800c9c:	74 2b                	je     800cc9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ca4:	75 0f                	jne    800cb5 <strtol+0x40>
  800ca6:	80 39 30             	cmpb   $0x30,(%ecx)
  800ca9:	74 28                	je     800cd3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cab:	85 db                	test   %ebx,%ebx
  800cad:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cb2:	0f 44 d8             	cmove  %eax,%ebx
  800cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cba:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cbd:	eb 50                	jmp    800d0f <strtol+0x9a>
		s++;
  800cbf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cc2:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc7:	eb d5                	jmp    800c9e <strtol+0x29>
		s++, neg = 1;
  800cc9:	83 c1 01             	add    $0x1,%ecx
  800ccc:	bf 01 00 00 00       	mov    $0x1,%edi
  800cd1:	eb cb                	jmp    800c9e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cd7:	74 0e                	je     800ce7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cd9:	85 db                	test   %ebx,%ebx
  800cdb:	75 d8                	jne    800cb5 <strtol+0x40>
		s++, base = 8;
  800cdd:	83 c1 01             	add    $0x1,%ecx
  800ce0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ce5:	eb ce                	jmp    800cb5 <strtol+0x40>
		s += 2, base = 16;
  800ce7:	83 c1 02             	add    $0x2,%ecx
  800cea:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cef:	eb c4                	jmp    800cb5 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cf1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cf4:	89 f3                	mov    %esi,%ebx
  800cf6:	80 fb 19             	cmp    $0x19,%bl
  800cf9:	77 29                	ja     800d24 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cfb:	0f be d2             	movsbl %dl,%edx
  800cfe:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d01:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d04:	7d 30                	jge    800d36 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d06:	83 c1 01             	add    $0x1,%ecx
  800d09:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d0d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d0f:	0f b6 11             	movzbl (%ecx),%edx
  800d12:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d15:	89 f3                	mov    %esi,%ebx
  800d17:	80 fb 09             	cmp    $0x9,%bl
  800d1a:	77 d5                	ja     800cf1 <strtol+0x7c>
			dig = *s - '0';
  800d1c:	0f be d2             	movsbl %dl,%edx
  800d1f:	83 ea 30             	sub    $0x30,%edx
  800d22:	eb dd                	jmp    800d01 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d24:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d27:	89 f3                	mov    %esi,%ebx
  800d29:	80 fb 19             	cmp    $0x19,%bl
  800d2c:	77 08                	ja     800d36 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d2e:	0f be d2             	movsbl %dl,%edx
  800d31:	83 ea 37             	sub    $0x37,%edx
  800d34:	eb cb                	jmp    800d01 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d3a:	74 05                	je     800d41 <strtol+0xcc>
		*endptr = (char *) s;
  800d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d41:	89 c2                	mov    %eax,%edx
  800d43:	f7 da                	neg    %edx
  800d45:	85 ff                	test   %edi,%edi
  800d47:	0f 45 c2             	cmovne %edx,%eax
}
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d55:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d60:	89 c3                	mov    %eax,%ebx
  800d62:	89 c7                	mov    %eax,%edi
  800d64:	89 c6                	mov    %eax,%esi
  800d66:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <sys_cgetc>:

int
sys_cgetc(void)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d73:	ba 00 00 00 00       	mov    $0x0,%edx
  800d78:	b8 01 00 00 00       	mov    $0x1,%eax
  800d7d:	89 d1                	mov    %edx,%ecx
  800d7f:	89 d3                	mov    %edx,%ebx
  800d81:	89 d7                	mov    %edx,%edi
  800d83:	89 d6                	mov    %edx,%esi
  800d85:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	b8 03 00 00 00       	mov    $0x3,%eax
  800da2:	89 cb                	mov    %ecx,%ebx
  800da4:	89 cf                	mov    %ecx,%edi
  800da6:	89 ce                	mov    %ecx,%esi
  800da8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	7f 08                	jg     800db6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	50                   	push   %eax
  800dba:	6a 03                	push   $0x3
  800dbc:	68 20 17 80 00       	push   $0x801720
  800dc1:	6a 33                	push   $0x33
  800dc3:	68 3d 17 80 00       	push   $0x80173d
  800dc8:	e8 63 f4 ff ff       	call   800230 <_panic>

00800dcd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd8:	b8 02 00 00 00       	mov    $0x2,%eax
  800ddd:	89 d1                	mov    %edx,%ecx
  800ddf:	89 d3                	mov    %edx,%ebx
  800de1:	89 d7                	mov    %edx,%edi
  800de3:	89 d6                	mov    %edx,%esi
  800de5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <sys_yield>:

void
sys_yield(void)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df2:	ba 00 00 00 00       	mov    $0x0,%edx
  800df7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dfc:	89 d1                	mov    %edx,%ecx
  800dfe:	89 d3                	mov    %edx,%ebx
  800e00:	89 d7                	mov    %edx,%edi
  800e02:	89 d6                	mov    %edx,%esi
  800e04:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
  800e11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e14:	be 00 00 00 00       	mov    $0x0,%esi
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	b8 04 00 00 00       	mov    $0x4,%eax
  800e24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e27:	89 f7                	mov    %esi,%edi
  800e29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2b:	85 c0                	test   %eax,%eax
  800e2d:	7f 08                	jg     800e37 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5f                   	pop    %edi
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e37:	83 ec 0c             	sub    $0xc,%esp
  800e3a:	50                   	push   %eax
  800e3b:	6a 04                	push   $0x4
  800e3d:	68 20 17 80 00       	push   $0x801720
  800e42:	6a 33                	push   $0x33
  800e44:	68 3d 17 80 00       	push   $0x80173d
  800e49:	e8 e2 f3 ff ff       	call   800230 <_panic>

00800e4e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	57                   	push   %edi
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5d:	b8 05 00 00 00       	mov    $0x5,%eax
  800e62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e65:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e68:	8b 75 18             	mov    0x18(%ebp),%esi
  800e6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	7f 08                	jg     800e79 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e79:	83 ec 0c             	sub    $0xc,%esp
  800e7c:	50                   	push   %eax
  800e7d:	6a 05                	push   $0x5
  800e7f:	68 20 17 80 00       	push   $0x801720
  800e84:	6a 33                	push   $0x33
  800e86:	68 3d 17 80 00       	push   $0x80173d
  800e8b:	e8 a0 f3 ff ff       	call   800230 <_panic>

00800e90 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea4:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea9:	89 df                	mov    %ebx,%edi
  800eab:	89 de                	mov    %ebx,%esi
  800ead:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	7f 08                	jg     800ebb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebb:	83 ec 0c             	sub    $0xc,%esp
  800ebe:	50                   	push   %eax
  800ebf:	6a 06                	push   $0x6
  800ec1:	68 20 17 80 00       	push   $0x801720
  800ec6:	6a 33                	push   $0x33
  800ec8:	68 3d 17 80 00       	push   $0x80173d
  800ecd:	e8 5e f3 ff ff       	call   800230 <_panic>

00800ed2 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ee8:	89 cb                	mov    %ecx,%ebx
  800eea:	89 cf                	mov    %ecx,%edi
  800eec:	89 ce                	mov    %ecx,%esi
  800eee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	7f 08                	jg     800efc <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	83 ec 0c             	sub    $0xc,%esp
  800eff:	50                   	push   %eax
  800f00:	6a 0b                	push   $0xb
  800f02:	68 20 17 80 00       	push   $0x801720
  800f07:	6a 33                	push   $0x33
  800f09:	68 3d 17 80 00       	push   $0x80173d
  800f0e:	e8 1d f3 ff ff       	call   800230 <_panic>

00800f13 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f27:	b8 08 00 00 00       	mov    $0x8,%eax
  800f2c:	89 df                	mov    %ebx,%edi
  800f2e:	89 de                	mov    %ebx,%esi
  800f30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f32:	85 c0                	test   %eax,%eax
  800f34:	7f 08                	jg     800f3e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5f                   	pop    %edi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3e:	83 ec 0c             	sub    $0xc,%esp
  800f41:	50                   	push   %eax
  800f42:	6a 08                	push   $0x8
  800f44:	68 20 17 80 00       	push   $0x801720
  800f49:	6a 33                	push   $0x33
  800f4b:	68 3d 17 80 00       	push   $0x80173d
  800f50:	e8 db f2 ff ff       	call   800230 <_panic>

00800f55 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
  800f5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	b8 09 00 00 00       	mov    $0x9,%eax
  800f6e:	89 df                	mov    %ebx,%edi
  800f70:	89 de                	mov    %ebx,%esi
  800f72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	7f 08                	jg     800f80 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	50                   	push   %eax
  800f84:	6a 09                	push   $0x9
  800f86:	68 20 17 80 00       	push   $0x801720
  800f8b:	6a 33                	push   $0x33
  800f8d:	68 3d 17 80 00       	push   $0x80173d
  800f92:	e8 99 f2 ff ff       	call   800230 <_panic>

00800f97 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
  800f9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fab:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb0:	89 df                	mov    %ebx,%edi
  800fb2:	89 de                	mov    %ebx,%esi
  800fb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	7f 08                	jg     800fc2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	50                   	push   %eax
  800fc6:	6a 0a                	push   $0xa
  800fc8:	68 20 17 80 00       	push   $0x801720
  800fcd:	6a 33                	push   $0x33
  800fcf:	68 3d 17 80 00       	push   $0x80173d
  800fd4:	e8 57 f2 ff ff       	call   800230 <_panic>

00800fd9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fea:	be 00 00 00 00       	mov    $0x0,%esi
  800fef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5f                   	pop    %edi
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    

00800ffc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
  801002:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801005:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801012:	89 cb                	mov    %ecx,%ebx
  801014:	89 cf                	mov    %ecx,%edi
  801016:	89 ce                	mov    %ecx,%esi
  801018:	cd 30                	int    $0x30
	if(check && ret > 0)
  80101a:	85 c0                	test   %eax,%eax
  80101c:	7f 08                	jg     801026 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80101e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801026:	83 ec 0c             	sub    $0xc,%esp
  801029:	50                   	push   %eax
  80102a:	6a 0e                	push   $0xe
  80102c:	68 20 17 80 00       	push   $0x801720
  801031:	6a 33                	push   $0x33
  801033:	68 3d 17 80 00       	push   $0x80173d
  801038:	e8 f3 f1 ff ff       	call   800230 <_panic>

0080103d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
	asm volatile("int %1\n"
  801043:	bb 00 00 00 00       	mov    $0x0,%ebx
  801048:	8b 55 08             	mov    0x8(%ebp),%edx
  80104b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801053:	89 df                	mov    %ebx,%edi
  801055:	89 de                	mov    %ebx,%esi
  801057:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    

0080105e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	57                   	push   %edi
  801062:	56                   	push   %esi
  801063:	53                   	push   %ebx
	asm volatile("int %1\n"
  801064:	b9 00 00 00 00       	mov    $0x0,%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	b8 10 00 00 00       	mov    $0x10,%eax
  801071:	89 cb                	mov    %ecx,%ebx
  801073:	89 cf                	mov    %ecx,%edi
  801075:	89 ce                	mov    %ecx,%esi
  801077:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5f                   	pop    %edi
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    
  80107e:	66 90                	xchg   %ax,%ax

00801080 <__udivdi3>:
  801080:	55                   	push   %ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 1c             	sub    $0x1c,%esp
  801087:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80108b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80108f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801093:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801097:	85 d2                	test   %edx,%edx
  801099:	75 4d                	jne    8010e8 <__udivdi3+0x68>
  80109b:	39 f3                	cmp    %esi,%ebx
  80109d:	76 19                	jbe    8010b8 <__udivdi3+0x38>
  80109f:	31 ff                	xor    %edi,%edi
  8010a1:	89 e8                	mov    %ebp,%eax
  8010a3:	89 f2                	mov    %esi,%edx
  8010a5:	f7 f3                	div    %ebx
  8010a7:	89 fa                	mov    %edi,%edx
  8010a9:	83 c4 1c             	add    $0x1c,%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
  8010b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010b8:	89 d9                	mov    %ebx,%ecx
  8010ba:	85 db                	test   %ebx,%ebx
  8010bc:	75 0b                	jne    8010c9 <__udivdi3+0x49>
  8010be:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f3                	div    %ebx
  8010c7:	89 c1                	mov    %eax,%ecx
  8010c9:	31 d2                	xor    %edx,%edx
  8010cb:	89 f0                	mov    %esi,%eax
  8010cd:	f7 f1                	div    %ecx
  8010cf:	89 c6                	mov    %eax,%esi
  8010d1:	89 e8                	mov    %ebp,%eax
  8010d3:	89 f7                	mov    %esi,%edi
  8010d5:	f7 f1                	div    %ecx
  8010d7:	89 fa                	mov    %edi,%edx
  8010d9:	83 c4 1c             	add    $0x1c,%esp
  8010dc:	5b                   	pop    %ebx
  8010dd:	5e                   	pop    %esi
  8010de:	5f                   	pop    %edi
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    
  8010e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010e8:	39 f2                	cmp    %esi,%edx
  8010ea:	77 1c                	ja     801108 <__udivdi3+0x88>
  8010ec:	0f bd fa             	bsr    %edx,%edi
  8010ef:	83 f7 1f             	xor    $0x1f,%edi
  8010f2:	75 2c                	jne    801120 <__udivdi3+0xa0>
  8010f4:	39 f2                	cmp    %esi,%edx
  8010f6:	72 06                	jb     8010fe <__udivdi3+0x7e>
  8010f8:	31 c0                	xor    %eax,%eax
  8010fa:	39 eb                	cmp    %ebp,%ebx
  8010fc:	77 a9                	ja     8010a7 <__udivdi3+0x27>
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801103:	eb a2                	jmp    8010a7 <__udivdi3+0x27>
  801105:	8d 76 00             	lea    0x0(%esi),%esi
  801108:	31 ff                	xor    %edi,%edi
  80110a:	31 c0                	xor    %eax,%eax
  80110c:	89 fa                	mov    %edi,%edx
  80110e:	83 c4 1c             	add    $0x1c,%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
  801116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80111d:	8d 76 00             	lea    0x0(%esi),%esi
  801120:	89 f9                	mov    %edi,%ecx
  801122:	b8 20 00 00 00       	mov    $0x20,%eax
  801127:	29 f8                	sub    %edi,%eax
  801129:	d3 e2                	shl    %cl,%edx
  80112b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80112f:	89 c1                	mov    %eax,%ecx
  801131:	89 da                	mov    %ebx,%edx
  801133:	d3 ea                	shr    %cl,%edx
  801135:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801139:	09 d1                	or     %edx,%ecx
  80113b:	89 f2                	mov    %esi,%edx
  80113d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801141:	89 f9                	mov    %edi,%ecx
  801143:	d3 e3                	shl    %cl,%ebx
  801145:	89 c1                	mov    %eax,%ecx
  801147:	d3 ea                	shr    %cl,%edx
  801149:	89 f9                	mov    %edi,%ecx
  80114b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80114f:	89 eb                	mov    %ebp,%ebx
  801151:	d3 e6                	shl    %cl,%esi
  801153:	89 c1                	mov    %eax,%ecx
  801155:	d3 eb                	shr    %cl,%ebx
  801157:	09 de                	or     %ebx,%esi
  801159:	89 f0                	mov    %esi,%eax
  80115b:	f7 74 24 08          	divl   0x8(%esp)
  80115f:	89 d6                	mov    %edx,%esi
  801161:	89 c3                	mov    %eax,%ebx
  801163:	f7 64 24 0c          	mull   0xc(%esp)
  801167:	39 d6                	cmp    %edx,%esi
  801169:	72 15                	jb     801180 <__udivdi3+0x100>
  80116b:	89 f9                	mov    %edi,%ecx
  80116d:	d3 e5                	shl    %cl,%ebp
  80116f:	39 c5                	cmp    %eax,%ebp
  801171:	73 04                	jae    801177 <__udivdi3+0xf7>
  801173:	39 d6                	cmp    %edx,%esi
  801175:	74 09                	je     801180 <__udivdi3+0x100>
  801177:	89 d8                	mov    %ebx,%eax
  801179:	31 ff                	xor    %edi,%edi
  80117b:	e9 27 ff ff ff       	jmp    8010a7 <__udivdi3+0x27>
  801180:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801183:	31 ff                	xor    %edi,%edi
  801185:	e9 1d ff ff ff       	jmp    8010a7 <__udivdi3+0x27>
  80118a:	66 90                	xchg   %ax,%ax
  80118c:	66 90                	xchg   %ax,%ax
  80118e:	66 90                	xchg   %ax,%ax

00801190 <__umoddi3>:
  801190:	55                   	push   %ebp
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	83 ec 1c             	sub    $0x1c,%esp
  801197:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80119b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80119f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8011a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8011a7:	89 da                	mov    %ebx,%edx
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	75 43                	jne    8011f0 <__umoddi3+0x60>
  8011ad:	39 df                	cmp    %ebx,%edi
  8011af:	76 17                	jbe    8011c8 <__umoddi3+0x38>
  8011b1:	89 f0                	mov    %esi,%eax
  8011b3:	f7 f7                	div    %edi
  8011b5:	89 d0                	mov    %edx,%eax
  8011b7:	31 d2                	xor    %edx,%edx
  8011b9:	83 c4 1c             	add    $0x1c,%esp
  8011bc:	5b                   	pop    %ebx
  8011bd:	5e                   	pop    %esi
  8011be:	5f                   	pop    %edi
  8011bf:	5d                   	pop    %ebp
  8011c0:	c3                   	ret    
  8011c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011c8:	89 fd                	mov    %edi,%ebp
  8011ca:	85 ff                	test   %edi,%edi
  8011cc:	75 0b                	jne    8011d9 <__umoddi3+0x49>
  8011ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8011d3:	31 d2                	xor    %edx,%edx
  8011d5:	f7 f7                	div    %edi
  8011d7:	89 c5                	mov    %eax,%ebp
  8011d9:	89 d8                	mov    %ebx,%eax
  8011db:	31 d2                	xor    %edx,%edx
  8011dd:	f7 f5                	div    %ebp
  8011df:	89 f0                	mov    %esi,%eax
  8011e1:	f7 f5                	div    %ebp
  8011e3:	89 d0                	mov    %edx,%eax
  8011e5:	eb d0                	jmp    8011b7 <__umoddi3+0x27>
  8011e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011ee:	66 90                	xchg   %ax,%ax
  8011f0:	89 f1                	mov    %esi,%ecx
  8011f2:	39 d8                	cmp    %ebx,%eax
  8011f4:	76 0a                	jbe    801200 <__umoddi3+0x70>
  8011f6:	89 f0                	mov    %esi,%eax
  8011f8:	83 c4 1c             	add    $0x1c,%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    
  801200:	0f bd e8             	bsr    %eax,%ebp
  801203:	83 f5 1f             	xor    $0x1f,%ebp
  801206:	75 20                	jne    801228 <__umoddi3+0x98>
  801208:	39 d8                	cmp    %ebx,%eax
  80120a:	0f 82 b0 00 00 00    	jb     8012c0 <__umoddi3+0x130>
  801210:	39 f7                	cmp    %esi,%edi
  801212:	0f 86 a8 00 00 00    	jbe    8012c0 <__umoddi3+0x130>
  801218:	89 c8                	mov    %ecx,%eax
  80121a:	83 c4 1c             	add    $0x1c,%esp
  80121d:	5b                   	pop    %ebx
  80121e:	5e                   	pop    %esi
  80121f:	5f                   	pop    %edi
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    
  801222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801228:	89 e9                	mov    %ebp,%ecx
  80122a:	ba 20 00 00 00       	mov    $0x20,%edx
  80122f:	29 ea                	sub    %ebp,%edx
  801231:	d3 e0                	shl    %cl,%eax
  801233:	89 44 24 08          	mov    %eax,0x8(%esp)
  801237:	89 d1                	mov    %edx,%ecx
  801239:	89 f8                	mov    %edi,%eax
  80123b:	d3 e8                	shr    %cl,%eax
  80123d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801241:	89 54 24 04          	mov    %edx,0x4(%esp)
  801245:	8b 54 24 04          	mov    0x4(%esp),%edx
  801249:	09 c1                	or     %eax,%ecx
  80124b:	89 d8                	mov    %ebx,%eax
  80124d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801251:	89 e9                	mov    %ebp,%ecx
  801253:	d3 e7                	shl    %cl,%edi
  801255:	89 d1                	mov    %edx,%ecx
  801257:	d3 e8                	shr    %cl,%eax
  801259:	89 e9                	mov    %ebp,%ecx
  80125b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80125f:	d3 e3                	shl    %cl,%ebx
  801261:	89 c7                	mov    %eax,%edi
  801263:	89 d1                	mov    %edx,%ecx
  801265:	89 f0                	mov    %esi,%eax
  801267:	d3 e8                	shr    %cl,%eax
  801269:	89 e9                	mov    %ebp,%ecx
  80126b:	89 fa                	mov    %edi,%edx
  80126d:	d3 e6                	shl    %cl,%esi
  80126f:	09 d8                	or     %ebx,%eax
  801271:	f7 74 24 08          	divl   0x8(%esp)
  801275:	89 d1                	mov    %edx,%ecx
  801277:	89 f3                	mov    %esi,%ebx
  801279:	f7 64 24 0c          	mull   0xc(%esp)
  80127d:	89 c6                	mov    %eax,%esi
  80127f:	89 d7                	mov    %edx,%edi
  801281:	39 d1                	cmp    %edx,%ecx
  801283:	72 06                	jb     80128b <__umoddi3+0xfb>
  801285:	75 10                	jne    801297 <__umoddi3+0x107>
  801287:	39 c3                	cmp    %eax,%ebx
  801289:	73 0c                	jae    801297 <__umoddi3+0x107>
  80128b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80128f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801293:	89 d7                	mov    %edx,%edi
  801295:	89 c6                	mov    %eax,%esi
  801297:	89 ca                	mov    %ecx,%edx
  801299:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80129e:	29 f3                	sub    %esi,%ebx
  8012a0:	19 fa                	sbb    %edi,%edx
  8012a2:	89 d0                	mov    %edx,%eax
  8012a4:	d3 e0                	shl    %cl,%eax
  8012a6:	89 e9                	mov    %ebp,%ecx
  8012a8:	d3 eb                	shr    %cl,%ebx
  8012aa:	d3 ea                	shr    %cl,%edx
  8012ac:	09 d8                	or     %ebx,%eax
  8012ae:	83 c4 1c             	add    $0x1c,%esp
  8012b1:	5b                   	pop    %ebx
  8012b2:	5e                   	pop    %esi
  8012b3:	5f                   	pop    %edi
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    
  8012b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012bd:	8d 76 00             	lea    0x0(%esi),%esi
  8012c0:	89 da                	mov    %ebx,%edx
  8012c2:	29 fe                	sub    %edi,%esi
  8012c4:	19 c2                	sbb    %eax,%edx
  8012c6:	89 f1                	mov    %esi,%ecx
  8012c8:	89 c8                	mov    %ecx,%eax
  8012ca:	e9 4b ff ff ff       	jmp    80121a <__umoddi3+0x8a>
