
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 c2 01 00 00       	call   8001f3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 a0 24 80 00       	push   $0x8024a0
  800040:	e8 e4 02 00 00       	call   800329 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 64 1e 00 00       	call   801eb4 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 76                	js     8000cd <umain+0x9a>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 44 11 00 00       	call   8011a0 <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 7d                	js     8000df <umain+0xac>
		panic("fork: %e", r);
	if (r == 0) {
  800062:	0f 84 89 00 00 00    	je     8000f1 <umain+0xbe>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	56                   	push   %esi
  80006c:	68 f1 24 80 00       	push   $0x8024f1
  800071:	e8 b3 02 00 00       	call   800329 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800076:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007c:	83 c4 08             	add    $0x8,%esp
  80007f:	8d 04 f6             	lea    (%esi,%esi,8),%eax
  800082:	69 c0 39 8e e3 38    	imul   $0x38e38e39,%eax,%eax
  800088:	50                   	push   %eax
  800089:	68 fc 24 80 00       	push   $0x8024fc
  80008e:	e8 96 02 00 00       	call   800329 <cprintf>
	dup(p[0], 10);
  800093:	83 c4 08             	add    $0x8,%esp
  800096:	6a 0a                	push   $0xa
  800098:	ff 75 f0             	pushl  -0x10(%ebp)
  80009b:	e8 14 16 00 00       	call   8016b4 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	8d 1c f6             	lea    (%esi,%esi,8),%ebx
  8000a6:	c1 e3 04             	shl    $0x4,%ebx
  8000a9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000af:	8b 43 54             	mov    0x54(%ebx),%eax
  8000b2:	83 f8 02             	cmp    $0x2,%eax
  8000b5:	0f 85 94 00 00 00    	jne    80014f <umain+0x11c>
		dup(p[0], 10);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	6a 0a                	push   $0xa
  8000c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c3:	e8 ec 15 00 00       	call   8016b4 <dup>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	eb e2                	jmp    8000af <umain+0x7c>
		panic("pipe: %e", r);
  8000cd:	50                   	push   %eax
  8000ce:	68 b9 24 80 00       	push   $0x8024b9
  8000d3:	6a 0d                	push   $0xd
  8000d5:	68 c2 24 80 00       	push   $0x8024c2
  8000da:	e8 6f 01 00 00       	call   80024e <_panic>
		panic("fork: %e", r);
  8000df:	50                   	push   %eax
  8000e0:	68 40 2a 80 00       	push   $0x802a40
  8000e5:	6a 10                	push   $0x10
  8000e7:	68 c2 24 80 00       	push   $0x8024c2
  8000ec:	e8 5d 01 00 00       	call   80024e <_panic>
		close(p[1]);
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000f7:	e8 66 15 00 00       	call   801662 <close>
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	bb c8 00 00 00       	mov    $0xc8,%ebx
  800104:	eb 1f                	jmp    800125 <umain+0xf2>
				cprintf("RACE: pipe appears closed\n");
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 d6 24 80 00       	push   $0x8024d6
  80010e:	e8 16 02 00 00       	call   800329 <cprintf>
				exit();
  800113:	e8 24 01 00 00       	call   80023c <exit>
  800118:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  80011b:	e8 ea 0c 00 00       	call   800e0a <sys_yield>
		for (i=0; i<max; i++) {
  800120:	83 eb 01             	sub    $0x1,%ebx
  800123:	74 14                	je     800139 <umain+0x106>
			if(pipeisclosed(p[0])){
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	ff 75 f0             	pushl  -0x10(%ebp)
  80012b:	e8 ce 1e 00 00       	call   801ffe <pipeisclosed>
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	85 c0                	test   %eax,%eax
  800135:	74 e4                	je     80011b <umain+0xe8>
  800137:	eb cd                	jmp    800106 <umain+0xd3>
		ipc_recv(0,0,0);
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	6a 00                	push   $0x0
  800140:	6a 00                	push   $0x0
  800142:	e8 86 12 00 00       	call   8013cd <ipc_recv>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	e9 19 ff ff ff       	jmp    800068 <umain+0x35>

	cprintf("child done with loop\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 07 25 80 00       	push   $0x802507
  800157:	e8 cd 01 00 00       	call   800329 <cprintf>
	if (pipeisclosed(p[0]))
  80015c:	83 c4 04             	add    $0x4,%esp
  80015f:	ff 75 f0             	pushl  -0x10(%ebp)
  800162:	e8 97 1e 00 00       	call   801ffe <pipeisclosed>
  800167:	83 c4 10             	add    $0x10,%esp
  80016a:	85 c0                	test   %eax,%eax
  80016c:	75 48                	jne    8001b6 <umain+0x183>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800174:	50                   	push   %eax
  800175:	ff 75 f0             	pushl  -0x10(%ebp)
  800178:	e8 b8 13 00 00       	call   801535 <fd_lookup>
  80017d:	83 c4 10             	add    $0x10,%esp
  800180:	85 c0                	test   %eax,%eax
  800182:	78 46                	js     8001ca <umain+0x197>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	ff 75 ec             	pushl  -0x14(%ebp)
  80018a:	e8 3d 13 00 00       	call   8014cc <fd2data>
	if (pageref(va) != 3+1)
  80018f:	89 04 24             	mov    %eax,(%esp)
  800192:	e8 11 1b 00 00       	call   801ca8 <pageref>
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	83 f8 04             	cmp    $0x4,%eax
  80019d:	74 3d                	je     8001dc <umain+0x1a9>
		cprintf("\nchild detected race\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 35 25 80 00       	push   $0x802535
  8001a7:	e8 7d 01 00 00       	call   800329 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5d                   	pop    %ebp
  8001b5:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b6:	83 ec 04             	sub    $0x4,%esp
  8001b9:	68 60 25 80 00       	push   $0x802560
  8001be:	6a 3a                	push   $0x3a
  8001c0:	68 c2 24 80 00       	push   $0x8024c2
  8001c5:	e8 84 00 00 00       	call   80024e <_panic>
		panic("cannot look up p[0]: %e", r);
  8001ca:	50                   	push   %eax
  8001cb:	68 1d 25 80 00       	push   $0x80251d
  8001d0:	6a 3c                	push   $0x3c
  8001d2:	68 c2 24 80 00       	push   $0x8024c2
  8001d7:	e8 72 00 00 00       	call   80024e <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	68 c8 00 00 00       	push   $0xc8
  8001e4:	68 4b 25 80 00       	push   $0x80254b
  8001e9:	e8 3b 01 00 00       	call   800329 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
}
  8001f1:	eb bc                	jmp    8001af <umain+0x17c>

008001f3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	56                   	push   %esi
  8001f7:	53                   	push   %ebx
  8001f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001fb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001fe:	e8 e8 0b 00 00       	call   800deb <sys_getenvid>
  800203:	25 ff 03 00 00       	and    $0x3ff,%eax
  800208:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80020b:	c1 e0 04             	shl    $0x4,%eax
  80020e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800213:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800218:	85 db                	test   %ebx,%ebx
  80021a:	7e 07                	jle    800223 <libmain+0x30>
		binaryname = argv[0];
  80021c:	8b 06                	mov    (%esi),%eax
  80021e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	e8 06 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80022d:	e8 0a 00 00 00       	call   80023c <exit>
}
  800232:	83 c4 10             	add    $0x10,%esp
  800235:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800238:	5b                   	pop    %ebx
  800239:	5e                   	pop    %esi
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    

0080023c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800242:	6a 00                	push   $0x0
  800244:	e8 61 0b 00 00       	call   800daa <sys_env_destroy>
}
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	56                   	push   %esi
  800252:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800253:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800256:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80025c:	e8 8a 0b 00 00       	call   800deb <sys_getenvid>
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	56                   	push   %esi
  80026b:	50                   	push   %eax
  80026c:	68 94 25 80 00       	push   $0x802594
  800271:	e8 b3 00 00 00       	call   800329 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800276:	83 c4 18             	add    $0x18,%esp
  800279:	53                   	push   %ebx
  80027a:	ff 75 10             	pushl  0x10(%ebp)
  80027d:	e8 56 00 00 00       	call   8002d8 <vcprintf>
	cprintf("\n");
  800282:	c7 04 24 b7 24 80 00 	movl   $0x8024b7,(%esp)
  800289:	e8 9b 00 00 00       	call   800329 <cprintf>
  80028e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800291:	cc                   	int3   
  800292:	eb fd                	jmp    800291 <_panic+0x43>

00800294 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	53                   	push   %ebx
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80029e:	8b 13                	mov    (%ebx),%edx
  8002a0:	8d 42 01             	lea    0x1(%edx),%eax
  8002a3:	89 03                	mov    %eax,(%ebx)
  8002a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b1:	74 09                	je     8002bc <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002bc:	83 ec 08             	sub    $0x8,%esp
  8002bf:	68 ff 00 00 00       	push   $0xff
  8002c4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c7:	50                   	push   %eax
  8002c8:	e8 a0 0a 00 00       	call   800d6d <sys_cputs>
		b->idx = 0;
  8002cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	eb db                	jmp    8002b3 <putch+0x1f>

008002d8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e8:	00 00 00 
	b.cnt = 0;
  8002eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800301:	50                   	push   %eax
  800302:	68 94 02 80 00       	push   $0x800294
  800307:	e8 4a 01 00 00       	call   800456 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80030c:	83 c4 08             	add    $0x8,%esp
  80030f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800315:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	e8 4c 0a 00 00       	call   800d6d <sys_cputs>

	return b.cnt;
}
  800321:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80032f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800332:	50                   	push   %eax
  800333:	ff 75 08             	pushl  0x8(%ebp)
  800336:	e8 9d ff ff ff       	call   8002d8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80033b:	c9                   	leave  
  80033c:	c3                   	ret    

0080033d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
  800343:	83 ec 1c             	sub    $0x1c,%esp
  800346:	89 c6                	mov    %eax,%esi
  800348:	89 d7                	mov    %edx,%edi
  80034a:	8b 45 08             	mov    0x8(%ebp),%eax
  80034d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800350:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800353:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800356:	8b 45 10             	mov    0x10(%ebp),%eax
  800359:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80035c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800360:	74 2c                	je     80038e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800365:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80036c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80036f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800372:	39 c2                	cmp    %eax,%edx
  800374:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800377:	73 43                	jae    8003bc <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800379:	83 eb 01             	sub    $0x1,%ebx
  80037c:	85 db                	test   %ebx,%ebx
  80037e:	7e 6c                	jle    8003ec <printnum+0xaf>
			putch(padc, putdat);
  800380:	83 ec 08             	sub    $0x8,%esp
  800383:	57                   	push   %edi
  800384:	ff 75 18             	pushl  0x18(%ebp)
  800387:	ff d6                	call   *%esi
  800389:	83 c4 10             	add    $0x10,%esp
  80038c:	eb eb                	jmp    800379 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	6a 20                	push   $0x20
  800393:	6a 00                	push   $0x0
  800395:	50                   	push   %eax
  800396:	ff 75 e4             	pushl  -0x1c(%ebp)
  800399:	ff 75 e0             	pushl  -0x20(%ebp)
  80039c:	89 fa                	mov    %edi,%edx
  80039e:	89 f0                	mov    %esi,%eax
  8003a0:	e8 98 ff ff ff       	call   80033d <printnum>
		while (--width > 0)
  8003a5:	83 c4 20             	add    $0x20,%esp
  8003a8:	83 eb 01             	sub    $0x1,%ebx
  8003ab:	85 db                	test   %ebx,%ebx
  8003ad:	7e 65                	jle    800414 <printnum+0xd7>
			putch(padc, putdat);
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	57                   	push   %edi
  8003b3:	6a 20                	push   $0x20
  8003b5:	ff d6                	call   *%esi
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	eb ec                	jmp    8003a8 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003bc:	83 ec 0c             	sub    $0xc,%esp
  8003bf:	ff 75 18             	pushl  0x18(%ebp)
  8003c2:	83 eb 01             	sub    $0x1,%ebx
  8003c5:	53                   	push   %ebx
  8003c6:	50                   	push   %eax
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8003cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003d6:	e8 65 1e 00 00       	call   802240 <__udivdi3>
  8003db:	83 c4 18             	add    $0x18,%esp
  8003de:	52                   	push   %edx
  8003df:	50                   	push   %eax
  8003e0:	89 fa                	mov    %edi,%edx
  8003e2:	89 f0                	mov    %esi,%eax
  8003e4:	e8 54 ff ff ff       	call   80033d <printnum>
  8003e9:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	57                   	push   %edi
  8003f0:	83 ec 04             	sub    $0x4,%esp
  8003f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8003f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8003f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ff:	e8 4c 1f 00 00       	call   802350 <__umoddi3>
  800404:	83 c4 14             	add    $0x14,%esp
  800407:	0f be 80 b7 25 80 00 	movsbl 0x8025b7(%eax),%eax
  80040e:	50                   	push   %eax
  80040f:	ff d6                	call   *%esi
  800411:	83 c4 10             	add    $0x10,%esp
}
  800414:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800417:	5b                   	pop    %ebx
  800418:	5e                   	pop    %esi
  800419:	5f                   	pop    %edi
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    

0080041c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800422:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800426:	8b 10                	mov    (%eax),%edx
  800428:	3b 50 04             	cmp    0x4(%eax),%edx
  80042b:	73 0a                	jae    800437 <sprintputch+0x1b>
		*b->buf++ = ch;
  80042d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800430:	89 08                	mov    %ecx,(%eax)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	88 02                	mov    %al,(%edx)
}
  800437:	5d                   	pop    %ebp
  800438:	c3                   	ret    

00800439 <printfmt>:
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80043f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800442:	50                   	push   %eax
  800443:	ff 75 10             	pushl  0x10(%ebp)
  800446:	ff 75 0c             	pushl  0xc(%ebp)
  800449:	ff 75 08             	pushl  0x8(%ebp)
  80044c:	e8 05 00 00 00       	call   800456 <vprintfmt>
}
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	c9                   	leave  
  800455:	c3                   	ret    

00800456 <vprintfmt>:
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	57                   	push   %edi
  80045a:	56                   	push   %esi
  80045b:	53                   	push   %ebx
  80045c:	83 ec 3c             	sub    $0x3c,%esp
  80045f:	8b 75 08             	mov    0x8(%ebp),%esi
  800462:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800465:	8b 7d 10             	mov    0x10(%ebp),%edi
  800468:	e9 b4 03 00 00       	jmp    800821 <vprintfmt+0x3cb>
		padc = ' ';
  80046d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800471:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800478:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80047f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800486:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80048d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800492:	8d 47 01             	lea    0x1(%edi),%eax
  800495:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800498:	0f b6 17             	movzbl (%edi),%edx
  80049b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80049e:	3c 55                	cmp    $0x55,%al
  8004a0:	0f 87 c8 04 00 00    	ja     80096e <vprintfmt+0x518>
  8004a6:	0f b6 c0             	movzbl %al,%eax
  8004a9:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  8004b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8004b3:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8004ba:	eb d6                	jmp    800492 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8004bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004bf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004c3:	eb cd                	jmp    800492 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8004c5:	0f b6 d2             	movzbl %dl,%edx
  8004c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8004d3:	eb 0c                	jmp    8004e1 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004d8:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8004dc:	eb b4                	jmp    800492 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8004de:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004e1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004e4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004e8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004eb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004ee:	83 f9 09             	cmp    $0x9,%ecx
  8004f1:	76 eb                	jbe    8004de <vprintfmt+0x88>
  8004f3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f9:	eb 14                	jmp    80050f <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800503:	8b 45 14             	mov    0x14(%ebp),%eax
  800506:	8d 40 04             	lea    0x4(%eax),%eax
  800509:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80050f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800513:	0f 89 79 ff ff ff    	jns    800492 <vprintfmt+0x3c>
				width = precision, precision = -1;
  800519:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800526:	e9 67 ff ff ff       	jmp    800492 <vprintfmt+0x3c>
  80052b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052e:	85 c0                	test   %eax,%eax
  800530:	ba 00 00 00 00       	mov    $0x0,%edx
  800535:	0f 49 d0             	cmovns %eax,%edx
  800538:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80053e:	e9 4f ff ff ff       	jmp    800492 <vprintfmt+0x3c>
  800543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800546:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80054d:	e9 40 ff ff ff       	jmp    800492 <vprintfmt+0x3c>
			lflag++;
  800552:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800555:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800558:	e9 35 ff ff ff       	jmp    800492 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8d 78 04             	lea    0x4(%eax),%edi
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	53                   	push   %ebx
  800567:	ff 30                	pushl  (%eax)
  800569:	ff d6                	call   *%esi
			break;
  80056b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80056e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800571:	e9 a8 02 00 00       	jmp    80081e <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	8d 78 04             	lea    0x4(%eax),%edi
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	99                   	cltd   
  80057f:	31 d0                	xor    %edx,%eax
  800581:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800583:	83 f8 0f             	cmp    $0xf,%eax
  800586:	7f 23                	jg     8005ab <vprintfmt+0x155>
  800588:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  80058f:	85 d2                	test   %edx,%edx
  800591:	74 18                	je     8005ab <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800593:	52                   	push   %edx
  800594:	68 41 2b 80 00       	push   $0x802b41
  800599:	53                   	push   %ebx
  80059a:	56                   	push   %esi
  80059b:	e8 99 fe ff ff       	call   800439 <printfmt>
  8005a0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a6:	e9 73 02 00 00       	jmp    80081e <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8005ab:	50                   	push   %eax
  8005ac:	68 cf 25 80 00       	push   $0x8025cf
  8005b1:	53                   	push   %ebx
  8005b2:	56                   	push   %esi
  8005b3:	e8 81 fe ff ff       	call   800439 <printfmt>
  8005b8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005bb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005be:	e9 5b 02 00 00       	jmp    80081e <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	83 c0 04             	add    $0x4,%eax
  8005c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005d1:	85 d2                	test   %edx,%edx
  8005d3:	b8 c8 25 80 00       	mov    $0x8025c8,%eax
  8005d8:	0f 45 c2             	cmovne %edx,%eax
  8005db:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e2:	7e 06                	jle    8005ea <vprintfmt+0x194>
  8005e4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005e8:	75 0d                	jne    8005f7 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005ed:	89 c7                	mov    %eax,%edi
  8005ef:	03 45 e0             	add    -0x20(%ebp),%eax
  8005f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f5:	eb 53                	jmp    80064a <vprintfmt+0x1f4>
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8005fd:	50                   	push   %eax
  8005fe:	e8 13 04 00 00       	call   800a16 <strnlen>
  800603:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800606:	29 c1                	sub    %eax,%ecx
  800608:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800610:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800614:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800617:	eb 0f                	jmp    800628 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	ff 75 e0             	pushl  -0x20(%ebp)
  800620:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800622:	83 ef 01             	sub    $0x1,%edi
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	85 ff                	test   %edi,%edi
  80062a:	7f ed                	jg     800619 <vprintfmt+0x1c3>
  80062c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80062f:	85 d2                	test   %edx,%edx
  800631:	b8 00 00 00 00       	mov    $0x0,%eax
  800636:	0f 49 c2             	cmovns %edx,%eax
  800639:	29 c2                	sub    %eax,%edx
  80063b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80063e:	eb aa                	jmp    8005ea <vprintfmt+0x194>
					putch(ch, putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	53                   	push   %ebx
  800644:	52                   	push   %edx
  800645:	ff d6                	call   *%esi
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80064d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064f:	83 c7 01             	add    $0x1,%edi
  800652:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800656:	0f be d0             	movsbl %al,%edx
  800659:	85 d2                	test   %edx,%edx
  80065b:	74 4b                	je     8006a8 <vprintfmt+0x252>
  80065d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800661:	78 06                	js     800669 <vprintfmt+0x213>
  800663:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800667:	78 1e                	js     800687 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800669:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80066d:	74 d1                	je     800640 <vprintfmt+0x1ea>
  80066f:	0f be c0             	movsbl %al,%eax
  800672:	83 e8 20             	sub    $0x20,%eax
  800675:	83 f8 5e             	cmp    $0x5e,%eax
  800678:	76 c6                	jbe    800640 <vprintfmt+0x1ea>
					putch('?', putdat);
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	53                   	push   %ebx
  80067e:	6a 3f                	push   $0x3f
  800680:	ff d6                	call   *%esi
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	eb c3                	jmp    80064a <vprintfmt+0x1f4>
  800687:	89 cf                	mov    %ecx,%edi
  800689:	eb 0e                	jmp    800699 <vprintfmt+0x243>
				putch(' ', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 20                	push   $0x20
  800691:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800693:	83 ef 01             	sub    $0x1,%edi
  800696:	83 c4 10             	add    $0x10,%esp
  800699:	85 ff                	test   %edi,%edi
  80069b:	7f ee                	jg     80068b <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80069d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a3:	e9 76 01 00 00       	jmp    80081e <vprintfmt+0x3c8>
  8006a8:	89 cf                	mov    %ecx,%edi
  8006aa:	eb ed                	jmp    800699 <vprintfmt+0x243>
	if (lflag >= 2)
  8006ac:	83 f9 01             	cmp    $0x1,%ecx
  8006af:	7f 1f                	jg     8006d0 <vprintfmt+0x27a>
	else if (lflag)
  8006b1:	85 c9                	test   %ecx,%ecx
  8006b3:	74 6a                	je     80071f <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	89 c1                	mov    %eax,%ecx
  8006bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 40 04             	lea    0x4(%eax),%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ce:	eb 17                	jmp    8006e7 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8b 50 04             	mov    0x4(%eax),%edx
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 08             	lea    0x8(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8006ea:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006ef:	85 d2                	test   %edx,%edx
  8006f1:	0f 89 f8 00 00 00    	jns    8007ef <vprintfmt+0x399>
				putch('-', putdat);
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	53                   	push   %ebx
  8006fb:	6a 2d                	push   $0x2d
  8006fd:	ff d6                	call   *%esi
				num = -(long long) num;
  8006ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800702:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800705:	f7 d8                	neg    %eax
  800707:	83 d2 00             	adc    $0x0,%edx
  80070a:	f7 da                	neg    %edx
  80070c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800712:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800715:	bf 0a 00 00 00       	mov    $0xa,%edi
  80071a:	e9 e1 00 00 00       	jmp    800800 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800727:	99                   	cltd   
  800728:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8d 40 04             	lea    0x4(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
  800734:	eb b1                	jmp    8006e7 <vprintfmt+0x291>
	if (lflag >= 2)
  800736:	83 f9 01             	cmp    $0x1,%ecx
  800739:	7f 27                	jg     800762 <vprintfmt+0x30c>
	else if (lflag)
  80073b:	85 c9                	test   %ecx,%ecx
  80073d:	74 41                	je     800780 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	ba 00 00 00 00       	mov    $0x0,%edx
  800749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 04             	lea    0x4(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800758:	bf 0a 00 00 00       	mov    $0xa,%edi
  80075d:	e9 8d 00 00 00       	jmp    8007ef <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 50 04             	mov    0x4(%eax),%edx
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 08             	lea    0x8(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800779:	bf 0a 00 00 00       	mov    $0xa,%edi
  80077e:	eb 6f                	jmp    8007ef <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	ba 00 00 00 00       	mov    $0x0,%edx
  80078a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8d 40 04             	lea    0x4(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800799:	bf 0a 00 00 00       	mov    $0xa,%edi
  80079e:	eb 4f                	jmp    8007ef <vprintfmt+0x399>
	if (lflag >= 2)
  8007a0:	83 f9 01             	cmp    $0x1,%ecx
  8007a3:	7f 23                	jg     8007c8 <vprintfmt+0x372>
	else if (lflag)
  8007a5:	85 c9                	test   %ecx,%ecx
  8007a7:	0f 84 98 00 00 00    	je     800845 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8d 40 04             	lea    0x4(%eax),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c6:	eb 17                	jmp    8007df <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 08             	lea    0x8(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	6a 30                	push   $0x30
  8007e5:	ff d6                	call   *%esi
			goto number;
  8007e7:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007ea:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8007ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007f3:	74 0b                	je     800800 <vprintfmt+0x3aa>
				putch('+', putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 2b                	push   $0x2b
  8007fb:	ff d6                	call   *%esi
  8007fd:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800800:	83 ec 0c             	sub    $0xc,%esp
  800803:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800807:	50                   	push   %eax
  800808:	ff 75 e0             	pushl  -0x20(%ebp)
  80080b:	57                   	push   %edi
  80080c:	ff 75 dc             	pushl  -0x24(%ebp)
  80080f:	ff 75 d8             	pushl  -0x28(%ebp)
  800812:	89 da                	mov    %ebx,%edx
  800814:	89 f0                	mov    %esi,%eax
  800816:	e8 22 fb ff ff       	call   80033d <printnum>
			break;
  80081b:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80081e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800821:	83 c7 01             	add    $0x1,%edi
  800824:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800828:	83 f8 25             	cmp    $0x25,%eax
  80082b:	0f 84 3c fc ff ff    	je     80046d <vprintfmt+0x17>
			if (ch == '\0')
  800831:	85 c0                	test   %eax,%eax
  800833:	0f 84 55 01 00 00    	je     80098e <vprintfmt+0x538>
			putch(ch, putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	53                   	push   %ebx
  80083d:	50                   	push   %eax
  80083e:	ff d6                	call   *%esi
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	eb dc                	jmp    800821 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	ba 00 00 00 00       	mov    $0x0,%edx
  80084f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800852:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	8d 40 04             	lea    0x4(%eax),%eax
  80085b:	89 45 14             	mov    %eax,0x14(%ebp)
  80085e:	e9 7c ff ff ff       	jmp    8007df <vprintfmt+0x389>
			putch('0', putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	53                   	push   %ebx
  800867:	6a 30                	push   $0x30
  800869:	ff d6                	call   *%esi
			putch('x', putdat);
  80086b:	83 c4 08             	add    $0x8,%esp
  80086e:	53                   	push   %ebx
  80086f:	6a 78                	push   $0x78
  800871:	ff d6                	call   *%esi
			num = (unsigned long long)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	ba 00 00 00 00       	mov    $0x0,%edx
  80087d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800880:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800883:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	8d 40 04             	lea    0x4(%eax),%eax
  80088c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088f:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800894:	e9 56 ff ff ff       	jmp    8007ef <vprintfmt+0x399>
	if (lflag >= 2)
  800899:	83 f9 01             	cmp    $0x1,%ecx
  80089c:	7f 27                	jg     8008c5 <vprintfmt+0x46f>
	else if (lflag)
  80089e:	85 c9                	test   %ecx,%ecx
  8008a0:	74 44                	je     8008e6 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 40 04             	lea    0x4(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008bb:	bf 10 00 00 00       	mov    $0x10,%edi
  8008c0:	e9 2a ff ff ff       	jmp    8007ef <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8b 50 04             	mov    0x4(%eax),%edx
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	8d 40 08             	lea    0x8(%eax),%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008dc:	bf 10 00 00 00       	mov    $0x10,%edi
  8008e1:	e9 09 ff ff ff       	jmp    8007ef <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	8d 40 04             	lea    0x4(%eax),%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ff:	bf 10 00 00 00       	mov    $0x10,%edi
  800904:	e9 e6 fe ff ff       	jmp    8007ef <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8d 78 04             	lea    0x4(%eax),%edi
  80090f:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800911:	85 c0                	test   %eax,%eax
  800913:	74 2d                	je     800942 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800915:	0f b6 13             	movzbl (%ebx),%edx
  800918:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80091a:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  80091d:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800920:	0f 8e f8 fe ff ff    	jle    80081e <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800926:	68 24 27 80 00       	push   $0x802724
  80092b:	68 41 2b 80 00       	push   $0x802b41
  800930:	53                   	push   %ebx
  800931:	56                   	push   %esi
  800932:	e8 02 fb ff ff       	call   800439 <printfmt>
  800937:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80093a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80093d:	e9 dc fe ff ff       	jmp    80081e <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800942:	68 ec 26 80 00       	push   $0x8026ec
  800947:	68 41 2b 80 00       	push   $0x802b41
  80094c:	53                   	push   %ebx
  80094d:	56                   	push   %esi
  80094e:	e8 e6 fa ff ff       	call   800439 <printfmt>
  800953:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800956:	89 7d 14             	mov    %edi,0x14(%ebp)
  800959:	e9 c0 fe ff ff       	jmp    80081e <vprintfmt+0x3c8>
			putch(ch, putdat);
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	53                   	push   %ebx
  800962:	6a 25                	push   $0x25
  800964:	ff d6                	call   *%esi
			break;
  800966:	83 c4 10             	add    $0x10,%esp
  800969:	e9 b0 fe ff ff       	jmp    80081e <vprintfmt+0x3c8>
			putch('%', putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	53                   	push   %ebx
  800972:	6a 25                	push   $0x25
  800974:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 f8                	mov    %edi,%eax
  80097b:	eb 03                	jmp    800980 <vprintfmt+0x52a>
  80097d:	83 e8 01             	sub    $0x1,%eax
  800980:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800984:	75 f7                	jne    80097d <vprintfmt+0x527>
  800986:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800989:	e9 90 fe ff ff       	jmp    80081e <vprintfmt+0x3c8>
}
  80098e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800991:	5b                   	pop    %ebx
  800992:	5e                   	pop    %esi
  800993:	5f                   	pop    %edi
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	83 ec 18             	sub    $0x18,%esp
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009b3:	85 c0                	test   %eax,%eax
  8009b5:	74 26                	je     8009dd <vsnprintf+0x47>
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	7e 22                	jle    8009dd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009bb:	ff 75 14             	pushl  0x14(%ebp)
  8009be:	ff 75 10             	pushl  0x10(%ebp)
  8009c1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c4:	50                   	push   %eax
  8009c5:	68 1c 04 80 00       	push   $0x80041c
  8009ca:	e8 87 fa ff ff       	call   800456 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d8:	83 c4 10             	add    $0x10,%esp
}
  8009db:	c9                   	leave  
  8009dc:	c3                   	ret    
		return -E_INVAL;
  8009dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e2:	eb f7                	jmp    8009db <vsnprintf+0x45>

008009e4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ea:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009ed:	50                   	push   %eax
  8009ee:	ff 75 10             	pushl  0x10(%ebp)
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	e8 9a ff ff ff       	call   800996 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
  800a09:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a0d:	74 05                	je     800a14 <strlen+0x16>
		n++;
  800a0f:	83 c0 01             	add    $0x1,%eax
  800a12:	eb f5                	jmp    800a09 <strlen+0xb>
	return n;
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a24:	39 c2                	cmp    %eax,%edx
  800a26:	74 0d                	je     800a35 <strnlen+0x1f>
  800a28:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a2c:	74 05                	je     800a33 <strnlen+0x1d>
		n++;
  800a2e:	83 c2 01             	add    $0x1,%edx
  800a31:	eb f1                	jmp    800a24 <strnlen+0xe>
  800a33:	89 d0                	mov    %edx,%eax
	return n;
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a41:	ba 00 00 00 00       	mov    $0x0,%edx
  800a46:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a4a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a4d:	83 c2 01             	add    $0x1,%edx
  800a50:	84 c9                	test   %cl,%cl
  800a52:	75 f2                	jne    800a46 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a54:	5b                   	pop    %ebx
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	53                   	push   %ebx
  800a5b:	83 ec 10             	sub    $0x10,%esp
  800a5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a61:	53                   	push   %ebx
  800a62:	e8 97 ff ff ff       	call   8009fe <strlen>
  800a67:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	01 d8                	add    %ebx,%eax
  800a6f:	50                   	push   %eax
  800a70:	e8 c2 ff ff ff       	call   800a37 <strcpy>
	return dst;
}
  800a75:	89 d8                	mov    %ebx,%eax
  800a77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a87:	89 c6                	mov    %eax,%esi
  800a89:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8c:	89 c2                	mov    %eax,%edx
  800a8e:	39 f2                	cmp    %esi,%edx
  800a90:	74 11                	je     800aa3 <strncpy+0x27>
		*dst++ = *src;
  800a92:	83 c2 01             	add    $0x1,%edx
  800a95:	0f b6 19             	movzbl (%ecx),%ebx
  800a98:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a9b:	80 fb 01             	cmp    $0x1,%bl
  800a9e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800aa1:	eb eb                	jmp    800a8e <strncpy+0x12>
	}
	return ret;
}
  800aa3:	5b                   	pop    %ebx
  800aa4:	5e                   	pop    %esi
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	56                   	push   %esi
  800aab:	53                   	push   %ebx
  800aac:	8b 75 08             	mov    0x8(%ebp),%esi
  800aaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab2:	8b 55 10             	mov    0x10(%ebp),%edx
  800ab5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab7:	85 d2                	test   %edx,%edx
  800ab9:	74 21                	je     800adc <strlcpy+0x35>
  800abb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800abf:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ac1:	39 c2                	cmp    %eax,%edx
  800ac3:	74 14                	je     800ad9 <strlcpy+0x32>
  800ac5:	0f b6 19             	movzbl (%ecx),%ebx
  800ac8:	84 db                	test   %bl,%bl
  800aca:	74 0b                	je     800ad7 <strlcpy+0x30>
			*dst++ = *src++;
  800acc:	83 c1 01             	add    $0x1,%ecx
  800acf:	83 c2 01             	add    $0x1,%edx
  800ad2:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ad5:	eb ea                	jmp    800ac1 <strlcpy+0x1a>
  800ad7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ad9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800adc:	29 f0                	sub    %esi,%eax
}
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aeb:	0f b6 01             	movzbl (%ecx),%eax
  800aee:	84 c0                	test   %al,%al
  800af0:	74 0c                	je     800afe <strcmp+0x1c>
  800af2:	3a 02                	cmp    (%edx),%al
  800af4:	75 08                	jne    800afe <strcmp+0x1c>
		p++, q++;
  800af6:	83 c1 01             	add    $0x1,%ecx
  800af9:	83 c2 01             	add    $0x1,%edx
  800afc:	eb ed                	jmp    800aeb <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800afe:	0f b6 c0             	movzbl %al,%eax
  800b01:	0f b6 12             	movzbl (%edx),%edx
  800b04:	29 d0                	sub    %edx,%eax
}
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	53                   	push   %ebx
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b12:	89 c3                	mov    %eax,%ebx
  800b14:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b17:	eb 06                	jmp    800b1f <strncmp+0x17>
		n--, p++, q++;
  800b19:	83 c0 01             	add    $0x1,%eax
  800b1c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b1f:	39 d8                	cmp    %ebx,%eax
  800b21:	74 16                	je     800b39 <strncmp+0x31>
  800b23:	0f b6 08             	movzbl (%eax),%ecx
  800b26:	84 c9                	test   %cl,%cl
  800b28:	74 04                	je     800b2e <strncmp+0x26>
  800b2a:	3a 0a                	cmp    (%edx),%cl
  800b2c:	74 eb                	je     800b19 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2e:	0f b6 00             	movzbl (%eax),%eax
  800b31:	0f b6 12             	movzbl (%edx),%edx
  800b34:	29 d0                	sub    %edx,%eax
}
  800b36:	5b                   	pop    %ebx
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    
		return 0;
  800b39:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3e:	eb f6                	jmp    800b36 <strncmp+0x2e>

00800b40 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b4a:	0f b6 10             	movzbl (%eax),%edx
  800b4d:	84 d2                	test   %dl,%dl
  800b4f:	74 09                	je     800b5a <strchr+0x1a>
		if (*s == c)
  800b51:	38 ca                	cmp    %cl,%dl
  800b53:	74 0a                	je     800b5f <strchr+0x1f>
	for (; *s; s++)
  800b55:	83 c0 01             	add    $0x1,%eax
  800b58:	eb f0                	jmp    800b4a <strchr+0xa>
			return (char *) s;
	return 0;
  800b5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b6e:	38 ca                	cmp    %cl,%dl
  800b70:	74 09                	je     800b7b <strfind+0x1a>
  800b72:	84 d2                	test   %dl,%dl
  800b74:	74 05                	je     800b7b <strfind+0x1a>
	for (; *s; s++)
  800b76:	83 c0 01             	add    $0x1,%eax
  800b79:	eb f0                	jmp    800b6b <strfind+0xa>
			break;
	return (char *) s;
}
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	57                   	push   %edi
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
  800b83:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b89:	85 c9                	test   %ecx,%ecx
  800b8b:	74 31                	je     800bbe <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b8d:	89 f8                	mov    %edi,%eax
  800b8f:	09 c8                	or     %ecx,%eax
  800b91:	a8 03                	test   $0x3,%al
  800b93:	75 23                	jne    800bb8 <memset+0x3b>
		c &= 0xFF;
  800b95:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b99:	89 d3                	mov    %edx,%ebx
  800b9b:	c1 e3 08             	shl    $0x8,%ebx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	c1 e0 18             	shl    $0x18,%eax
  800ba3:	89 d6                	mov    %edx,%esi
  800ba5:	c1 e6 10             	shl    $0x10,%esi
  800ba8:	09 f0                	or     %esi,%eax
  800baa:	09 c2                	or     %eax,%edx
  800bac:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bae:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bb1:	89 d0                	mov    %edx,%eax
  800bb3:	fc                   	cld    
  800bb4:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb6:	eb 06                	jmp    800bbe <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	fc                   	cld    
  800bbc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bbe:	89 f8                	mov    %edi,%eax
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd3:	39 c6                	cmp    %eax,%esi
  800bd5:	73 32                	jae    800c09 <memmove+0x44>
  800bd7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bda:	39 c2                	cmp    %eax,%edx
  800bdc:	76 2b                	jbe    800c09 <memmove+0x44>
		s += n;
		d += n;
  800bde:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be1:	89 fe                	mov    %edi,%esi
  800be3:	09 ce                	or     %ecx,%esi
  800be5:	09 d6                	or     %edx,%esi
  800be7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bed:	75 0e                	jne    800bfd <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bef:	83 ef 04             	sub    $0x4,%edi
  800bf2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bf8:	fd                   	std    
  800bf9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bfb:	eb 09                	jmp    800c06 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bfd:	83 ef 01             	sub    $0x1,%edi
  800c00:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c03:	fd                   	std    
  800c04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c06:	fc                   	cld    
  800c07:	eb 1a                	jmp    800c23 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c09:	89 c2                	mov    %eax,%edx
  800c0b:	09 ca                	or     %ecx,%edx
  800c0d:	09 f2                	or     %esi,%edx
  800c0f:	f6 c2 03             	test   $0x3,%dl
  800c12:	75 0a                	jne    800c1e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c14:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c17:	89 c7                	mov    %eax,%edi
  800c19:	fc                   	cld    
  800c1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1c:	eb 05                	jmp    800c23 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c1e:	89 c7                	mov    %eax,%edi
  800c20:	fc                   	cld    
  800c21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c23:	5e                   	pop    %esi
  800c24:	5f                   	pop    %edi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c2d:	ff 75 10             	pushl  0x10(%ebp)
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	ff 75 08             	pushl  0x8(%ebp)
  800c36:	e8 8a ff ff ff       	call   800bc5 <memmove>
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	56                   	push   %esi
  800c41:	53                   	push   %ebx
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c48:	89 c6                	mov    %eax,%esi
  800c4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c4d:	39 f0                	cmp    %esi,%eax
  800c4f:	74 1c                	je     800c6d <memcmp+0x30>
		if (*s1 != *s2)
  800c51:	0f b6 08             	movzbl (%eax),%ecx
  800c54:	0f b6 1a             	movzbl (%edx),%ebx
  800c57:	38 d9                	cmp    %bl,%cl
  800c59:	75 08                	jne    800c63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c5b:	83 c0 01             	add    $0x1,%eax
  800c5e:	83 c2 01             	add    $0x1,%edx
  800c61:	eb ea                	jmp    800c4d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c63:	0f b6 c1             	movzbl %cl,%eax
  800c66:	0f b6 db             	movzbl %bl,%ebx
  800c69:	29 d8                	sub    %ebx,%eax
  800c6b:	eb 05                	jmp    800c72 <memcmp+0x35>
	}

	return 0;
  800c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c7f:	89 c2                	mov    %eax,%edx
  800c81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c84:	39 d0                	cmp    %edx,%eax
  800c86:	73 09                	jae    800c91 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c88:	38 08                	cmp    %cl,(%eax)
  800c8a:	74 05                	je     800c91 <memfind+0x1b>
	for (; s < ends; s++)
  800c8c:	83 c0 01             	add    $0x1,%eax
  800c8f:	eb f3                	jmp    800c84 <memfind+0xe>
			break;
	return (void *) s;
}
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c9f:	eb 03                	jmp    800ca4 <strtol+0x11>
		s++;
  800ca1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ca4:	0f b6 01             	movzbl (%ecx),%eax
  800ca7:	3c 20                	cmp    $0x20,%al
  800ca9:	74 f6                	je     800ca1 <strtol+0xe>
  800cab:	3c 09                	cmp    $0x9,%al
  800cad:	74 f2                	je     800ca1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800caf:	3c 2b                	cmp    $0x2b,%al
  800cb1:	74 2a                	je     800cdd <strtol+0x4a>
	int neg = 0;
  800cb3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cb8:	3c 2d                	cmp    $0x2d,%al
  800cba:	74 2b                	je     800ce7 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cbc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cc2:	75 0f                	jne    800cd3 <strtol+0x40>
  800cc4:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc7:	74 28                	je     800cf1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc9:	85 db                	test   %ebx,%ebx
  800ccb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd0:	0f 44 d8             	cmove  %eax,%ebx
  800cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cdb:	eb 50                	jmp    800d2d <strtol+0x9a>
		s++;
  800cdd:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ce0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce5:	eb d5                	jmp    800cbc <strtol+0x29>
		s++, neg = 1;
  800ce7:	83 c1 01             	add    $0x1,%ecx
  800cea:	bf 01 00 00 00       	mov    $0x1,%edi
  800cef:	eb cb                	jmp    800cbc <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cf5:	74 0e                	je     800d05 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cf7:	85 db                	test   %ebx,%ebx
  800cf9:	75 d8                	jne    800cd3 <strtol+0x40>
		s++, base = 8;
  800cfb:	83 c1 01             	add    $0x1,%ecx
  800cfe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d03:	eb ce                	jmp    800cd3 <strtol+0x40>
		s += 2, base = 16;
  800d05:	83 c1 02             	add    $0x2,%ecx
  800d08:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d0d:	eb c4                	jmp    800cd3 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d0f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d12:	89 f3                	mov    %esi,%ebx
  800d14:	80 fb 19             	cmp    $0x19,%bl
  800d17:	77 29                	ja     800d42 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d19:	0f be d2             	movsbl %dl,%edx
  800d1c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d1f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d22:	7d 30                	jge    800d54 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d24:	83 c1 01             	add    $0x1,%ecx
  800d27:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d2b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d2d:	0f b6 11             	movzbl (%ecx),%edx
  800d30:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d33:	89 f3                	mov    %esi,%ebx
  800d35:	80 fb 09             	cmp    $0x9,%bl
  800d38:	77 d5                	ja     800d0f <strtol+0x7c>
			dig = *s - '0';
  800d3a:	0f be d2             	movsbl %dl,%edx
  800d3d:	83 ea 30             	sub    $0x30,%edx
  800d40:	eb dd                	jmp    800d1f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d42:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d45:	89 f3                	mov    %esi,%ebx
  800d47:	80 fb 19             	cmp    $0x19,%bl
  800d4a:	77 08                	ja     800d54 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d4c:	0f be d2             	movsbl %dl,%edx
  800d4f:	83 ea 37             	sub    $0x37,%edx
  800d52:	eb cb                	jmp    800d1f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d58:	74 05                	je     800d5f <strtol+0xcc>
		*endptr = (char *) s;
  800d5a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d5d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d5f:	89 c2                	mov    %eax,%edx
  800d61:	f7 da                	neg    %edx
  800d63:	85 ff                	test   %edi,%edi
  800d65:	0f 45 c2             	cmovne %edx,%eax
}
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7e:	89 c3                	mov    %eax,%ebx
  800d80:	89 c7                	mov    %eax,%edi
  800d82:	89 c6                	mov    %eax,%esi
  800d84:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <sys_cgetc>:

int
sys_cgetc(void)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d91:	ba 00 00 00 00       	mov    $0x0,%edx
  800d96:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9b:	89 d1                	mov    %edx,%ecx
  800d9d:	89 d3                	mov    %edx,%ebx
  800d9f:	89 d7                	mov    %edx,%edi
  800da1:	89 d6                	mov    %edx,%esi
  800da3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc0:	89 cb                	mov    %ecx,%ebx
  800dc2:	89 cf                	mov    %ecx,%edi
  800dc4:	89 ce                	mov    %ecx,%esi
  800dc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7f 08                	jg     800dd4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	50                   	push   %eax
  800dd8:	6a 03                	push   $0x3
  800dda:	68 40 29 80 00       	push   $0x802940
  800ddf:	6a 33                	push   $0x33
  800de1:	68 5d 29 80 00       	push   $0x80295d
  800de6:	e8 63 f4 ff ff       	call   80024e <_panic>

00800deb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df1:	ba 00 00 00 00       	mov    $0x0,%edx
  800df6:	b8 02 00 00 00       	mov    $0x2,%eax
  800dfb:	89 d1                	mov    %edx,%ecx
  800dfd:	89 d3                	mov    %edx,%ebx
  800dff:	89 d7                	mov    %edx,%edi
  800e01:	89 d6                	mov    %edx,%esi
  800e03:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sys_yield>:

void
sys_yield(void)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e10:	ba 00 00 00 00       	mov    $0x0,%edx
  800e15:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e1a:	89 d1                	mov    %edx,%ecx
  800e1c:	89 d3                	mov    %edx,%ebx
  800e1e:	89 d7                	mov    %edx,%edi
  800e20:	89 d6                	mov    %edx,%esi
  800e22:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e32:	be 00 00 00 00       	mov    $0x0,%esi
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e45:	89 f7                	mov    %esi,%edi
  800e47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	7f 08                	jg     800e55 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	50                   	push   %eax
  800e59:	6a 04                	push   $0x4
  800e5b:	68 40 29 80 00       	push   $0x802940
  800e60:	6a 33                	push   $0x33
  800e62:	68 5d 29 80 00       	push   $0x80295d
  800e67:	e8 e2 f3 ff ff       	call   80024e <_panic>

00800e6c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	b8 05 00 00 00       	mov    $0x5,%eax
  800e80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e83:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e86:	8b 75 18             	mov    0x18(%ebp),%esi
  800e89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	7f 08                	jg     800e97 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	50                   	push   %eax
  800e9b:	6a 05                	push   $0x5
  800e9d:	68 40 29 80 00       	push   $0x802940
  800ea2:	6a 33                	push   $0x33
  800ea4:	68 5d 29 80 00       	push   $0x80295d
  800ea9:	e8 a0 f3 ff ff       	call   80024e <_panic>

00800eae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec2:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec7:	89 df                	mov    %ebx,%edi
  800ec9:	89 de                	mov    %ebx,%esi
  800ecb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	7f 08                	jg     800ed9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed9:	83 ec 0c             	sub    $0xc,%esp
  800edc:	50                   	push   %eax
  800edd:	6a 06                	push   $0x6
  800edf:	68 40 29 80 00       	push   $0x802940
  800ee4:	6a 33                	push   $0x33
  800ee6:	68 5d 29 80 00       	push   $0x80295d
  800eeb:	e8 5e f3 ff ff       	call   80024e <_panic>

00800ef0 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	57                   	push   %edi
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f06:	89 cb                	mov    %ecx,%ebx
  800f08:	89 cf                	mov    %ecx,%edi
  800f0a:	89 ce                	mov    %ecx,%esi
  800f0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	7f 08                	jg     800f1a <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1a:	83 ec 0c             	sub    $0xc,%esp
  800f1d:	50                   	push   %eax
  800f1e:	6a 0b                	push   $0xb
  800f20:	68 40 29 80 00       	push   $0x802940
  800f25:	6a 33                	push   $0x33
  800f27:	68 5d 29 80 00       	push   $0x80295d
  800f2c:	e8 1d f3 ff ff       	call   80024e <_panic>

00800f31 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	57                   	push   %edi
  800f35:	56                   	push   %esi
  800f36:	53                   	push   %ebx
  800f37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	b8 08 00 00 00       	mov    $0x8,%eax
  800f4a:	89 df                	mov    %ebx,%edi
  800f4c:	89 de                	mov    %ebx,%esi
  800f4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f50:	85 c0                	test   %eax,%eax
  800f52:	7f 08                	jg     800f5c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	50                   	push   %eax
  800f60:	6a 08                	push   $0x8
  800f62:	68 40 29 80 00       	push   $0x802940
  800f67:	6a 33                	push   $0x33
  800f69:	68 5d 29 80 00       	push   $0x80295d
  800f6e:	e8 db f2 ff ff       	call   80024e <_panic>

00800f73 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
  800f79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f87:	b8 09 00 00 00       	mov    $0x9,%eax
  800f8c:	89 df                	mov    %ebx,%edi
  800f8e:	89 de                	mov    %ebx,%esi
  800f90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f92:	85 c0                	test   %eax,%eax
  800f94:	7f 08                	jg     800f9e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f99:	5b                   	pop    %ebx
  800f9a:	5e                   	pop    %esi
  800f9b:	5f                   	pop    %edi
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9e:	83 ec 0c             	sub    $0xc,%esp
  800fa1:	50                   	push   %eax
  800fa2:	6a 09                	push   $0x9
  800fa4:	68 40 29 80 00       	push   $0x802940
  800fa9:	6a 33                	push   $0x33
  800fab:	68 5d 29 80 00       	push   $0x80295d
  800fb0:	e8 99 f2 ff ff       	call   80024e <_panic>

00800fb5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
  800fbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fce:	89 df                	mov    %ebx,%edi
  800fd0:	89 de                	mov    %ebx,%esi
  800fd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7f 08                	jg     800fe0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	50                   	push   %eax
  800fe4:	6a 0a                	push   $0xa
  800fe6:	68 40 29 80 00       	push   $0x802940
  800feb:	6a 33                	push   $0x33
  800fed:	68 5d 29 80 00       	push   $0x80295d
  800ff2:	e8 57 f2 ff ff       	call   80024e <_panic>

00800ff7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  801000:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801003:	b8 0d 00 00 00       	mov    $0xd,%eax
  801008:	be 00 00 00 00       	mov    $0x0,%esi
  80100d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801010:	8b 7d 14             	mov    0x14(%ebp),%edi
  801013:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
  801020:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801023:	b9 00 00 00 00       	mov    $0x0,%ecx
  801028:	8b 55 08             	mov    0x8(%ebp),%edx
  80102b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801030:	89 cb                	mov    %ecx,%ebx
  801032:	89 cf                	mov    %ecx,%edi
  801034:	89 ce                	mov    %ecx,%esi
  801036:	cd 30                	int    $0x30
	if(check && ret > 0)
  801038:	85 c0                	test   %eax,%eax
  80103a:	7f 08                	jg     801044 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80103c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	50                   	push   %eax
  801048:	6a 0e                	push   $0xe
  80104a:	68 40 29 80 00       	push   $0x802940
  80104f:	6a 33                	push   $0x33
  801051:	68 5d 29 80 00       	push   $0x80295d
  801056:	e8 f3 f1 ff ff       	call   80024e <_panic>

0080105b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
	asm volatile("int %1\n"
  801061:	bb 00 00 00 00       	mov    $0x0,%ebx
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106c:	b8 0f 00 00 00       	mov    $0xf,%eax
  801071:	89 df                	mov    %ebx,%edi
  801073:	89 de                	mov    %ebx,%esi
  801075:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801077:	5b                   	pop    %ebx
  801078:	5e                   	pop    %esi
  801079:	5f                   	pop    %edi
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	57                   	push   %edi
  801080:	56                   	push   %esi
  801081:	53                   	push   %ebx
	asm volatile("int %1\n"
  801082:	b9 00 00 00 00       	mov    $0x0,%ecx
  801087:	8b 55 08             	mov    0x8(%ebp),%edx
  80108a:	b8 10 00 00 00       	mov    $0x10,%eax
  80108f:	89 cb                	mov    %ecx,%ebx
  801091:	89 cf                	mov    %ecx,%edi
  801093:	89 ce                	mov    %ecx,%esi
  801095:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5f                   	pop    %edi
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	53                   	push   %ebx
  8010a0:	83 ec 04             	sub    $0x4,%esp
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010a6:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  8010a8:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010ac:	0f 84 90 00 00 00    	je     801142 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  8010b2:	89 d8                	mov    %ebx,%eax
  8010b4:	c1 e8 16             	shr    $0x16,%eax
  8010b7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010be:	a8 01                	test   $0x1,%al
  8010c0:	0f 84 90 00 00 00    	je     801156 <pgfault+0xba>
  8010c6:	89 d8                	mov    %ebx,%eax
  8010c8:	c1 e8 0c             	shr    $0xc,%eax
  8010cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010d2:	a9 01 08 00 00       	test   $0x801,%eax
  8010d7:	74 7d                	je     801156 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8010d9:	83 ec 04             	sub    $0x4,%esp
  8010dc:	6a 07                	push   $0x7
  8010de:	68 00 f0 7f 00       	push   $0x7ff000
  8010e3:	6a 00                	push   $0x0
  8010e5:	e8 3f fd ff ff       	call   800e29 <sys_page_alloc>
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	78 79                	js     80116a <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  8010f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  8010f7:	83 ec 04             	sub    $0x4,%esp
  8010fa:	68 00 10 00 00       	push   $0x1000
  8010ff:	53                   	push   %ebx
  801100:	68 00 f0 7f 00       	push   $0x7ff000
  801105:	e8 bb fa ff ff       	call   800bc5 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  80110a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801111:	53                   	push   %ebx
  801112:	6a 00                	push   $0x0
  801114:	68 00 f0 7f 00       	push   $0x7ff000
  801119:	6a 00                	push   $0x0
  80111b:	e8 4c fd ff ff       	call   800e6c <sys_page_map>
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	78 55                	js     80117c <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	68 00 f0 7f 00       	push   $0x7ff000
  80112f:	6a 00                	push   $0x0
  801131:	e8 78 fd ff ff       	call   800eae <sys_page_unmap>
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	85 c0                	test   %eax,%eax
  80113b:	78 51                	js     80118e <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  80113d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801140:	c9                   	leave  
  801141:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  801142:	83 ec 04             	sub    $0x4,%esp
  801145:	68 6c 29 80 00       	push   $0x80296c
  80114a:	6a 21                	push   $0x21
  80114c:	68 f4 29 80 00       	push   $0x8029f4
  801151:	e8 f8 f0 ff ff       	call   80024e <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  801156:	83 ec 04             	sub    $0x4,%esp
  801159:	68 98 29 80 00       	push   $0x802998
  80115e:	6a 24                	push   $0x24
  801160:	68 f4 29 80 00       	push   $0x8029f4
  801165:	e8 e4 f0 ff ff       	call   80024e <_panic>
		panic("sys_page_alloc: %e\n", r);
  80116a:	50                   	push   %eax
  80116b:	68 ff 29 80 00       	push   $0x8029ff
  801170:	6a 2e                	push   $0x2e
  801172:	68 f4 29 80 00       	push   $0x8029f4
  801177:	e8 d2 f0 ff ff       	call   80024e <_panic>
		panic("sys_page_map: %e\n", r);
  80117c:	50                   	push   %eax
  80117d:	68 13 2a 80 00       	push   $0x802a13
  801182:	6a 34                	push   $0x34
  801184:	68 f4 29 80 00       	push   $0x8029f4
  801189:	e8 c0 f0 ff ff       	call   80024e <_panic>
		panic("sys_page_unmap: %e\n", r);
  80118e:	50                   	push   %eax
  80118f:	68 25 2a 80 00       	push   $0x802a25
  801194:	6a 37                	push   $0x37
  801196:	68 f4 29 80 00       	push   $0x8029f4
  80119b:	e8 ae f0 ff ff       	call   80024e <_panic>

008011a0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	57                   	push   %edi
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  8011a9:	68 9c 10 80 00       	push   $0x80109c
  8011ae:	e8 f3 0f 00 00       	call   8021a6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8011b8:	cd 30                	int    $0x30
  8011ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	78 30                	js     8011f4 <fork+0x54>
  8011c4:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8011c6:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8011cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011cf:	0f 85 a5 00 00 00    	jne    80127a <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011d5:	e8 11 fc ff ff       	call   800deb <sys_getenvid>
  8011da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011df:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8011e2:	c1 e0 04             	shl    $0x4,%eax
  8011e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011ea:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011ef:	e9 75 01 00 00       	jmp    801369 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  8011f4:	50                   	push   %eax
  8011f5:	68 39 2a 80 00       	push   $0x802a39
  8011fa:	68 83 00 00 00       	push   $0x83
  8011ff:	68 f4 29 80 00       	push   $0x8029f4
  801204:	e8 45 f0 ff ff       	call   80024e <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801209:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	25 07 0e 00 00       	and    $0xe07,%eax
  801218:	50                   	push   %eax
  801219:	56                   	push   %esi
  80121a:	57                   	push   %edi
  80121b:	56                   	push   %esi
  80121c:	6a 00                	push   $0x0
  80121e:	e8 49 fc ff ff       	call   800e6c <sys_page_map>
  801223:	83 c4 20             	add    $0x20,%esp
  801226:	85 c0                	test   %eax,%eax
  801228:	79 3e                	jns    801268 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  80122a:	50                   	push   %eax
  80122b:	68 13 2a 80 00       	push   $0x802a13
  801230:	6a 50                	push   $0x50
  801232:	68 f4 29 80 00       	push   $0x8029f4
  801237:	e8 12 f0 ff ff       	call   80024e <_panic>
			panic("sys_page_map: %e\n", r);
  80123c:	50                   	push   %eax
  80123d:	68 13 2a 80 00       	push   $0x802a13
  801242:	6a 54                	push   $0x54
  801244:	68 f4 29 80 00       	push   $0x8029f4
  801249:	e8 00 f0 ff ff       	call   80024e <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	6a 05                	push   $0x5
  801253:	56                   	push   %esi
  801254:	57                   	push   %edi
  801255:	56                   	push   %esi
  801256:	6a 00                	push   $0x0
  801258:	e8 0f fc ff ff       	call   800e6c <sys_page_map>
  80125d:	83 c4 20             	add    $0x20,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	0f 88 ab 00 00 00    	js     801313 <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801268:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80126e:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801274:	0f 84 ab 00 00 00    	je     801325 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  80127a:	89 d8                	mov    %ebx,%eax
  80127c:	c1 e8 16             	shr    $0x16,%eax
  80127f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801286:	a8 01                	test   $0x1,%al
  801288:	74 de                	je     801268 <fork+0xc8>
  80128a:	89 d8                	mov    %ebx,%eax
  80128c:	c1 e8 0c             	shr    $0xc,%eax
  80128f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801296:	f6 c2 01             	test   $0x1,%dl
  801299:	74 cd                	je     801268 <fork+0xc8>
  80129b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8012a1:	74 c5                	je     801268 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  8012a3:	89 c6                	mov    %eax,%esi
  8012a5:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  8012a8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012af:	f6 c6 04             	test   $0x4,%dh
  8012b2:	0f 85 51 ff ff ff    	jne    801209 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  8012b8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012bf:	a9 02 08 00 00       	test   $0x802,%eax
  8012c4:	74 88                	je     80124e <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8012c6:	83 ec 0c             	sub    $0xc,%esp
  8012c9:	68 05 08 00 00       	push   $0x805
  8012ce:	56                   	push   %esi
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	6a 00                	push   $0x0
  8012d3:	e8 94 fb ff ff       	call   800e6c <sys_page_map>
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	0f 88 59 ff ff ff    	js     80123c <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	68 05 08 00 00       	push   $0x805
  8012eb:	56                   	push   %esi
  8012ec:	6a 00                	push   $0x0
  8012ee:	56                   	push   %esi
  8012ef:	6a 00                	push   $0x0
  8012f1:	e8 76 fb ff ff       	call   800e6c <sys_page_map>
  8012f6:	83 c4 20             	add    $0x20,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	0f 89 67 ff ff ff    	jns    801268 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801301:	50                   	push   %eax
  801302:	68 13 2a 80 00       	push   $0x802a13
  801307:	6a 56                	push   $0x56
  801309:	68 f4 29 80 00       	push   $0x8029f4
  80130e:	e8 3b ef ff ff       	call   80024e <_panic>
			panic("sys_page_map: %e\n", r);
  801313:	50                   	push   %eax
  801314:	68 13 2a 80 00       	push   $0x802a13
  801319:	6a 5a                	push   $0x5a
  80131b:	68 f4 29 80 00       	push   $0x8029f4
  801320:	e8 29 ef ff ff       	call   80024e <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	6a 07                	push   $0x7
  80132a:	68 00 f0 bf ee       	push   $0xeebff000
  80132f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801332:	e8 f2 fa ff ff       	call   800e29 <sys_page_alloc>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	85 c0                	test   %eax,%eax
  80133c:	78 36                	js     801374 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80133e:	83 ec 08             	sub    $0x8,%esp
  801341:	68 11 22 80 00       	push   $0x802211
  801346:	ff 75 e4             	pushl  -0x1c(%ebp)
  801349:	e8 67 fc ff ff       	call   800fb5 <sys_env_set_pgfault_upcall>
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	85 c0                	test   %eax,%eax
  801353:	78 34                	js     801389 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801355:	83 ec 08             	sub    $0x8,%esp
  801358:	6a 02                	push   $0x2
  80135a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80135d:	e8 cf fb ff ff       	call   800f31 <sys_env_set_status>
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	85 c0                	test   %eax,%eax
  801367:	78 35                	js     80139e <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  801369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80136f:	5b                   	pop    %ebx
  801370:	5e                   	pop    %esi
  801371:	5f                   	pop    %edi
  801372:	5d                   	pop    %ebp
  801373:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  801374:	50                   	push   %eax
  801375:	68 ff 29 80 00       	push   $0x8029ff
  80137a:	68 95 00 00 00       	push   $0x95
  80137f:	68 f4 29 80 00       	push   $0x8029f4
  801384:	e8 c5 ee ff ff       	call   80024e <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801389:	50                   	push   %eax
  80138a:	68 d4 29 80 00       	push   $0x8029d4
  80138f:	68 98 00 00 00       	push   $0x98
  801394:	68 f4 29 80 00       	push   $0x8029f4
  801399:	e8 b0 ee ff ff       	call   80024e <_panic>
		panic("sys_env_set_status: %e\n", r);
  80139e:	50                   	push   %eax
  80139f:	68 49 2a 80 00       	push   $0x802a49
  8013a4:	68 9b 00 00 00       	push   $0x9b
  8013a9:	68 f4 29 80 00       	push   $0x8029f4
  8013ae:	e8 9b ee ff ff       	call   80024e <_panic>

008013b3 <sfork>:

// Challenge!
int
sfork(void)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8013b9:	68 61 2a 80 00       	push   $0x802a61
  8013be:	68 a4 00 00 00       	push   $0xa4
  8013c3:	68 f4 29 80 00       	push   $0x8029f4
  8013c8:	e8 81 ee ff ff       	call   80024e <_panic>

008013cd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	56                   	push   %esi
  8013d1:	53                   	push   %ebx
  8013d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  8013db:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8013dd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8013e2:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  8013e5:	83 ec 0c             	sub    $0xc,%esp
  8013e8:	50                   	push   %eax
  8013e9:	e8 2c fc ff ff       	call   80101a <sys_ipc_recv>
	if (from_env_store)
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	85 f6                	test   %esi,%esi
  8013f3:	74 14                	je     801409 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  8013f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 09                	js     801407 <ipc_recv+0x3a>
  8013fe:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801404:	8b 52 78             	mov    0x78(%edx),%edx
  801407:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  801409:	85 db                	test   %ebx,%ebx
  80140b:	74 14                	je     801421 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  80140d:	ba 00 00 00 00       	mov    $0x0,%edx
  801412:	85 c0                	test   %eax,%eax
  801414:	78 09                	js     80141f <ipc_recv+0x52>
  801416:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80141c:	8b 52 7c             	mov    0x7c(%edx),%edx
  80141f:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  801421:	85 c0                	test   %eax,%eax
  801423:	78 08                	js     80142d <ipc_recv+0x60>
  801425:	a1 04 40 80 00       	mov    0x804004,%eax
  80142a:	8b 40 74             	mov    0x74(%eax),%eax
}
  80142d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5d                   	pop    %ebp
  801433:	c3                   	ret    

00801434 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  80143d:	85 c0                	test   %eax,%eax
  80143f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801444:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801447:	ff 75 14             	pushl  0x14(%ebp)
  80144a:	50                   	push   %eax
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	e8 a1 fb ff ff       	call   800ff7 <sys_ipc_try_send>
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 02                	js     80145f <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  80145f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801462:	75 07                	jne    80146b <ipc_send+0x37>
		sys_yield();
  801464:	e8 a1 f9 ff ff       	call   800e0a <sys_yield>
}
  801469:	eb f2                	jmp    80145d <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  80146b:	50                   	push   %eax
  80146c:	68 77 2a 80 00       	push   $0x802a77
  801471:	6a 3c                	push   $0x3c
  801473:	68 8b 2a 80 00       	push   $0x802a8b
  801478:	e8 d1 ed ff ff       	call   80024e <_panic>

0080147d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801483:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  801488:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80148b:	c1 e0 04             	shl    $0x4,%eax
  80148e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801493:	8b 40 50             	mov    0x50(%eax),%eax
  801496:	39 c8                	cmp    %ecx,%eax
  801498:	74 12                	je     8014ac <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80149a:	83 c2 01             	add    $0x1,%edx
  80149d:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8014a3:	75 e3                	jne    801488 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 0e                	jmp    8014ba <ipc_find_env+0x3d>
			return envs[i].env_id;
  8014ac:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8014af:	c1 e0 04             	shl    $0x4,%eax
  8014b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014b7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    

008014bc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	05 00 00 00 30       	add    $0x30000000,%eax
  8014c7:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014dc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    

008014e3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014eb:	89 c2                	mov    %eax,%edx
  8014ed:	c1 ea 16             	shr    $0x16,%edx
  8014f0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014f7:	f6 c2 01             	test   $0x1,%dl
  8014fa:	74 2d                	je     801529 <fd_alloc+0x46>
  8014fc:	89 c2                	mov    %eax,%edx
  8014fe:	c1 ea 0c             	shr    $0xc,%edx
  801501:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801508:	f6 c2 01             	test   $0x1,%dl
  80150b:	74 1c                	je     801529 <fd_alloc+0x46>
  80150d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801512:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801517:	75 d2                	jne    8014eb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801522:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801527:	eb 0a                	jmp    801533 <fd_alloc+0x50>
			*fd_store = fd;
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    

00801535 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80153b:	83 f8 1f             	cmp    $0x1f,%eax
  80153e:	77 30                	ja     801570 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801540:	c1 e0 0c             	shl    $0xc,%eax
  801543:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801548:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80154e:	f6 c2 01             	test   $0x1,%dl
  801551:	74 24                	je     801577 <fd_lookup+0x42>
  801553:	89 c2                	mov    %eax,%edx
  801555:	c1 ea 0c             	shr    $0xc,%edx
  801558:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80155f:	f6 c2 01             	test   $0x1,%dl
  801562:	74 1a                	je     80157e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801564:	8b 55 0c             	mov    0xc(%ebp),%edx
  801567:	89 02                	mov    %eax,(%edx)
	return 0;
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    
		return -E_INVAL;
  801570:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801575:	eb f7                	jmp    80156e <fd_lookup+0x39>
		return -E_INVAL;
  801577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157c:	eb f0                	jmp    80156e <fd_lookup+0x39>
  80157e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801583:	eb e9                	jmp    80156e <fd_lookup+0x39>

00801585 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158e:	ba 18 2b 80 00       	mov    $0x802b18,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801593:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801598:	39 08                	cmp    %ecx,(%eax)
  80159a:	74 33                	je     8015cf <dev_lookup+0x4a>
  80159c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80159f:	8b 02                	mov    (%edx),%eax
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	75 f3                	jne    801598 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015a5:	a1 04 40 80 00       	mov    0x804004,%eax
  8015aa:	8b 40 48             	mov    0x48(%eax),%eax
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	51                   	push   %ecx
  8015b1:	50                   	push   %eax
  8015b2:	68 98 2a 80 00       	push   $0x802a98
  8015b7:	e8 6d ed ff ff       	call   800329 <cprintf>
	*dev = 0;
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    
			*dev = devtab[i];
  8015cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d9:	eb f2                	jmp    8015cd <dev_lookup+0x48>

008015db <fd_close>:
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	57                   	push   %edi
  8015df:	56                   	push   %esi
  8015e0:	53                   	push   %ebx
  8015e1:	83 ec 24             	sub    $0x24,%esp
  8015e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8015e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ed:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015ee:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015f4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015f7:	50                   	push   %eax
  8015f8:	e8 38 ff ff ff       	call   801535 <fd_lookup>
  8015fd:	89 c3                	mov    %eax,%ebx
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	78 05                	js     80160b <fd_close+0x30>
	    || fd != fd2)
  801606:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801609:	74 16                	je     801621 <fd_close+0x46>
		return (must_exist ? r : 0);
  80160b:	89 f8                	mov    %edi,%eax
  80160d:	84 c0                	test   %al,%al
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax
  801614:	0f 44 d8             	cmove  %eax,%ebx
}
  801617:	89 d8                	mov    %ebx,%eax
  801619:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161c:	5b                   	pop    %ebx
  80161d:	5e                   	pop    %esi
  80161e:	5f                   	pop    %edi
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801627:	50                   	push   %eax
  801628:	ff 36                	pushl  (%esi)
  80162a:	e8 56 ff ff ff       	call   801585 <dev_lookup>
  80162f:	89 c3                	mov    %eax,%ebx
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	85 c0                	test   %eax,%eax
  801636:	78 1a                	js     801652 <fd_close+0x77>
		if (dev->dev_close)
  801638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80163e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801643:	85 c0                	test   %eax,%eax
  801645:	74 0b                	je     801652 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801647:	83 ec 0c             	sub    $0xc,%esp
  80164a:	56                   	push   %esi
  80164b:	ff d0                	call   *%eax
  80164d:	89 c3                	mov    %eax,%ebx
  80164f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801652:	83 ec 08             	sub    $0x8,%esp
  801655:	56                   	push   %esi
  801656:	6a 00                	push   $0x0
  801658:	e8 51 f8 ff ff       	call   800eae <sys_page_unmap>
	return r;
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	eb b5                	jmp    801617 <fd_close+0x3c>

00801662 <close>:

int
close(int fdnum)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801668:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	e8 c1 fe ff ff       	call   801535 <fd_lookup>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	79 02                	jns    80167d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    
		return fd_close(fd, 1);
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	6a 01                	push   $0x1
  801682:	ff 75 f4             	pushl  -0xc(%ebp)
  801685:	e8 51 ff ff ff       	call   8015db <fd_close>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	eb ec                	jmp    80167b <close+0x19>

0080168f <close_all>:

void
close_all(void)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	53                   	push   %ebx
  801693:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801696:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80169b:	83 ec 0c             	sub    $0xc,%esp
  80169e:	53                   	push   %ebx
  80169f:	e8 be ff ff ff       	call   801662 <close>
	for (i = 0; i < MAXFD; i++)
  8016a4:	83 c3 01             	add    $0x1,%ebx
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	83 fb 20             	cmp    $0x20,%ebx
  8016ad:	75 ec                	jne    80169b <close_all+0xc>
}
  8016af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	57                   	push   %edi
  8016b8:	56                   	push   %esi
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016c0:	50                   	push   %eax
  8016c1:	ff 75 08             	pushl  0x8(%ebp)
  8016c4:	e8 6c fe ff ff       	call   801535 <fd_lookup>
  8016c9:	89 c3                	mov    %eax,%ebx
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	0f 88 81 00 00 00    	js     801757 <dup+0xa3>
		return r;
	close(newfdnum);
  8016d6:	83 ec 0c             	sub    $0xc,%esp
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	e8 81 ff ff ff       	call   801662 <close>

	newfd = INDEX2FD(newfdnum);
  8016e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016e4:	c1 e6 0c             	shl    $0xc,%esi
  8016e7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016ed:	83 c4 04             	add    $0x4,%esp
  8016f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016f3:	e8 d4 fd ff ff       	call   8014cc <fd2data>
  8016f8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016fa:	89 34 24             	mov    %esi,(%esp)
  8016fd:	e8 ca fd ff ff       	call   8014cc <fd2data>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801707:	89 d8                	mov    %ebx,%eax
  801709:	c1 e8 16             	shr    $0x16,%eax
  80170c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801713:	a8 01                	test   $0x1,%al
  801715:	74 11                	je     801728 <dup+0x74>
  801717:	89 d8                	mov    %ebx,%eax
  801719:	c1 e8 0c             	shr    $0xc,%eax
  80171c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801723:	f6 c2 01             	test   $0x1,%dl
  801726:	75 39                	jne    801761 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801728:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80172b:	89 d0                	mov    %edx,%eax
  80172d:	c1 e8 0c             	shr    $0xc,%eax
  801730:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801737:	83 ec 0c             	sub    $0xc,%esp
  80173a:	25 07 0e 00 00       	and    $0xe07,%eax
  80173f:	50                   	push   %eax
  801740:	56                   	push   %esi
  801741:	6a 00                	push   $0x0
  801743:	52                   	push   %edx
  801744:	6a 00                	push   $0x0
  801746:	e8 21 f7 ff ff       	call   800e6c <sys_page_map>
  80174b:	89 c3                	mov    %eax,%ebx
  80174d:	83 c4 20             	add    $0x20,%esp
  801750:	85 c0                	test   %eax,%eax
  801752:	78 31                	js     801785 <dup+0xd1>
		goto err;

	return newfdnum;
  801754:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801757:	89 d8                	mov    %ebx,%eax
  801759:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175c:	5b                   	pop    %ebx
  80175d:	5e                   	pop    %esi
  80175e:	5f                   	pop    %edi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801761:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801768:	83 ec 0c             	sub    $0xc,%esp
  80176b:	25 07 0e 00 00       	and    $0xe07,%eax
  801770:	50                   	push   %eax
  801771:	57                   	push   %edi
  801772:	6a 00                	push   $0x0
  801774:	53                   	push   %ebx
  801775:	6a 00                	push   $0x0
  801777:	e8 f0 f6 ff ff       	call   800e6c <sys_page_map>
  80177c:	89 c3                	mov    %eax,%ebx
  80177e:	83 c4 20             	add    $0x20,%esp
  801781:	85 c0                	test   %eax,%eax
  801783:	79 a3                	jns    801728 <dup+0x74>
	sys_page_unmap(0, newfd);
  801785:	83 ec 08             	sub    $0x8,%esp
  801788:	56                   	push   %esi
  801789:	6a 00                	push   $0x0
  80178b:	e8 1e f7 ff ff       	call   800eae <sys_page_unmap>
	sys_page_unmap(0, nva);
  801790:	83 c4 08             	add    $0x8,%esp
  801793:	57                   	push   %edi
  801794:	6a 00                	push   $0x0
  801796:	e8 13 f7 ff ff       	call   800eae <sys_page_unmap>
	return r;
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	eb b7                	jmp    801757 <dup+0xa3>

008017a0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 1c             	sub    $0x1c,%esp
  8017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ad:	50                   	push   %eax
  8017ae:	53                   	push   %ebx
  8017af:	e8 81 fd ff ff       	call   801535 <fd_lookup>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 3f                	js     8017fa <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c1:	50                   	push   %eax
  8017c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c5:	ff 30                	pushl  (%eax)
  8017c7:	e8 b9 fd ff ff       	call   801585 <dev_lookup>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 27                	js     8017fa <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d6:	8b 42 08             	mov    0x8(%edx),%eax
  8017d9:	83 e0 03             	and    $0x3,%eax
  8017dc:	83 f8 01             	cmp    $0x1,%eax
  8017df:	74 1e                	je     8017ff <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e4:	8b 40 08             	mov    0x8(%eax),%eax
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	74 35                	je     801820 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	ff 75 10             	pushl  0x10(%ebp)
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	52                   	push   %edx
  8017f5:	ff d0                	call   *%eax
  8017f7:	83 c4 10             	add    $0x10,%esp
}
  8017fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ff:	a1 04 40 80 00       	mov    0x804004,%eax
  801804:	8b 40 48             	mov    0x48(%eax),%eax
  801807:	83 ec 04             	sub    $0x4,%esp
  80180a:	53                   	push   %ebx
  80180b:	50                   	push   %eax
  80180c:	68 dc 2a 80 00       	push   $0x802adc
  801811:	e8 13 eb ff ff       	call   800329 <cprintf>
		return -E_INVAL;
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181e:	eb da                	jmp    8017fa <read+0x5a>
		return -E_NOT_SUPP;
  801820:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801825:	eb d3                	jmp    8017fa <read+0x5a>

00801827 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	57                   	push   %edi
  80182b:	56                   	push   %esi
  80182c:	53                   	push   %ebx
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	8b 7d 08             	mov    0x8(%ebp),%edi
  801833:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801836:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183b:	39 f3                	cmp    %esi,%ebx
  80183d:	73 23                	jae    801862 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	89 f0                	mov    %esi,%eax
  801844:	29 d8                	sub    %ebx,%eax
  801846:	50                   	push   %eax
  801847:	89 d8                	mov    %ebx,%eax
  801849:	03 45 0c             	add    0xc(%ebp),%eax
  80184c:	50                   	push   %eax
  80184d:	57                   	push   %edi
  80184e:	e8 4d ff ff ff       	call   8017a0 <read>
		if (m < 0)
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	85 c0                	test   %eax,%eax
  801858:	78 06                	js     801860 <readn+0x39>
			return m;
		if (m == 0)
  80185a:	74 06                	je     801862 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80185c:	01 c3                	add    %eax,%ebx
  80185e:	eb db                	jmp    80183b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801860:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801862:	89 d8                	mov    %ebx,%eax
  801864:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5f                   	pop    %edi
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    

0080186c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	53                   	push   %ebx
  801870:	83 ec 1c             	sub    $0x1c,%esp
  801873:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801876:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801879:	50                   	push   %eax
  80187a:	53                   	push   %ebx
  80187b:	e8 b5 fc ff ff       	call   801535 <fd_lookup>
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	85 c0                	test   %eax,%eax
  801885:	78 3a                	js     8018c1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188d:	50                   	push   %eax
  80188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801891:	ff 30                	pushl  (%eax)
  801893:	e8 ed fc ff ff       	call   801585 <dev_lookup>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 22                	js     8018c1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a6:	74 1e                	je     8018c6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ae:	85 d2                	test   %edx,%edx
  8018b0:	74 35                	je     8018e7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	ff 75 10             	pushl  0x10(%ebp)
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	50                   	push   %eax
  8018bc:	ff d2                	call   *%edx
  8018be:	83 c4 10             	add    $0x10,%esp
}
  8018c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8018cb:	8b 40 48             	mov    0x48(%eax),%eax
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	53                   	push   %ebx
  8018d2:	50                   	push   %eax
  8018d3:	68 f8 2a 80 00       	push   $0x802af8
  8018d8:	e8 4c ea ff ff       	call   800329 <cprintf>
		return -E_INVAL;
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e5:	eb da                	jmp    8018c1 <write+0x55>
		return -E_NOT_SUPP;
  8018e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018ec:	eb d3                	jmp    8018c1 <write+0x55>

008018ee <seek>:

int
seek(int fdnum, off_t offset)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f7:	50                   	push   %eax
  8018f8:	ff 75 08             	pushl  0x8(%ebp)
  8018fb:	e8 35 fc ff ff       	call   801535 <fd_lookup>
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	85 c0                	test   %eax,%eax
  801905:	78 0e                	js     801915 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801910:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	53                   	push   %ebx
  80191b:	83 ec 1c             	sub    $0x1c,%esp
  80191e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801921:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801924:	50                   	push   %eax
  801925:	53                   	push   %ebx
  801926:	e8 0a fc ff ff       	call   801535 <fd_lookup>
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 37                	js     801969 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801938:	50                   	push   %eax
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193c:	ff 30                	pushl  (%eax)
  80193e:	e8 42 fc ff ff       	call   801585 <dev_lookup>
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	78 1f                	js     801969 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801951:	74 1b                	je     80196e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801956:	8b 52 18             	mov    0x18(%edx),%edx
  801959:	85 d2                	test   %edx,%edx
  80195b:	74 32                	je     80198f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	50                   	push   %eax
  801964:	ff d2                	call   *%edx
  801966:	83 c4 10             	add    $0x10,%esp
}
  801969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80196e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801973:	8b 40 48             	mov    0x48(%eax),%eax
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	53                   	push   %ebx
  80197a:	50                   	push   %eax
  80197b:	68 b8 2a 80 00       	push   $0x802ab8
  801980:	e8 a4 e9 ff ff       	call   800329 <cprintf>
		return -E_INVAL;
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198d:	eb da                	jmp    801969 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80198f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801994:	eb d3                	jmp    801969 <ftruncate+0x52>

00801996 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	53                   	push   %ebx
  80199a:	83 ec 1c             	sub    $0x1c,%esp
  80199d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	e8 89 fb ff ff       	call   801535 <fd_lookup>
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 4b                	js     8019fe <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b3:	83 ec 08             	sub    $0x8,%esp
  8019b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b9:	50                   	push   %eax
  8019ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bd:	ff 30                	pushl  (%eax)
  8019bf:	e8 c1 fb ff ff       	call   801585 <dev_lookup>
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 33                	js     8019fe <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ce:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019d2:	74 2f                	je     801a03 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019d4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019d7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019de:	00 00 00 
	stat->st_isdir = 0;
  8019e1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019e8:	00 00 00 
	stat->st_dev = dev;
  8019eb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	53                   	push   %ebx
  8019f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f8:	ff 50 14             	call   *0x14(%eax)
  8019fb:	83 c4 10             	add    $0x10,%esp
}
  8019fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    
		return -E_NOT_SUPP;
  801a03:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a08:	eb f4                	jmp    8019fe <fstat+0x68>

00801a0a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	56                   	push   %esi
  801a0e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	6a 00                	push   $0x0
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	e8 e7 01 00 00       	call   801c03 <open>
  801a1c:	89 c3                	mov    %eax,%ebx
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	85 c0                	test   %eax,%eax
  801a23:	78 1b                	js     801a40 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a25:	83 ec 08             	sub    $0x8,%esp
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	50                   	push   %eax
  801a2c:	e8 65 ff ff ff       	call   801996 <fstat>
  801a31:	89 c6                	mov    %eax,%esi
	close(fd);
  801a33:	89 1c 24             	mov    %ebx,(%esp)
  801a36:	e8 27 fc ff ff       	call   801662 <close>
	return r;
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	89 f3                	mov    %esi,%ebx
}
  801a40:	89 d8                	mov    %ebx,%eax
  801a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	56                   	push   %esi
  801a4d:	53                   	push   %ebx
  801a4e:	89 c6                	mov    %eax,%esi
  801a50:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a52:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a59:	74 27                	je     801a82 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a5b:	6a 07                	push   $0x7
  801a5d:	68 00 50 80 00       	push   $0x805000
  801a62:	56                   	push   %esi
  801a63:	ff 35 00 40 80 00    	pushl  0x804000
  801a69:	e8 c6 f9 ff ff       	call   801434 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a6e:	83 c4 0c             	add    $0xc,%esp
  801a71:	6a 00                	push   $0x0
  801a73:	53                   	push   %ebx
  801a74:	6a 00                	push   $0x0
  801a76:	e8 52 f9 ff ff       	call   8013cd <ipc_recv>
}
  801a7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7e:	5b                   	pop    %ebx
  801a7f:	5e                   	pop    %esi
  801a80:	5d                   	pop    %ebp
  801a81:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	6a 01                	push   $0x1
  801a87:	e8 f1 f9 ff ff       	call   80147d <ipc_find_env>
  801a8c:	a3 00 40 80 00       	mov    %eax,0x804000
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	eb c5                	jmp    801a5b <fsipc+0x12>

00801a96 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab4:	b8 02 00 00 00       	mov    $0x2,%eax
  801ab9:	e8 8b ff ff ff       	call   801a49 <fsipc>
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <devfile_flush>:
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  801acc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad6:	b8 06 00 00 00       	mov    $0x6,%eax
  801adb:	e8 69 ff ff ff       	call   801a49 <fsipc>
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <devfile_stat>:
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	8b 40 0c             	mov    0xc(%eax),%eax
  801af2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801af7:	ba 00 00 00 00       	mov    $0x0,%edx
  801afc:	b8 05 00 00 00       	mov    $0x5,%eax
  801b01:	e8 43 ff ff ff       	call   801a49 <fsipc>
  801b06:	85 c0                	test   %eax,%eax
  801b08:	78 2c                	js     801b36 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	68 00 50 80 00       	push   $0x805000
  801b12:	53                   	push   %ebx
  801b13:	e8 1f ef ff ff       	call   800a37 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b18:	a1 80 50 80 00       	mov    0x805080,%eax
  801b1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b23:	a1 84 50 80 00       	mov    0x805084,%eax
  801b28:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <devfile_write>:
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 0c             	sub    $0xc,%esp
  801b41:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b44:	8b 55 08             	mov    0x8(%ebp),%edx
  801b47:	8b 52 0c             	mov    0xc(%edx),%edx
  801b4a:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801b50:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b55:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b5a:	0f 47 c2             	cmova  %edx,%eax
  801b5d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801b62:	50                   	push   %eax
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	68 08 50 80 00       	push   $0x805008
  801b6b:	e8 55 f0 ff ff       	call   800bc5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801b70:	ba 00 00 00 00       	mov    $0x0,%edx
  801b75:	b8 04 00 00 00       	mov    $0x4,%eax
  801b7a:	e8 ca fe ff ff       	call   801a49 <fsipc>
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <devfile_read>:
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	56                   	push   %esi
  801b85:	53                   	push   %ebx
  801b86:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b94:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9f:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba4:	e8 a0 fe ff ff       	call   801a49 <fsipc>
  801ba9:	89 c3                	mov    %eax,%ebx
  801bab:	85 c0                	test   %eax,%eax
  801bad:	78 1f                	js     801bce <devfile_read+0x4d>
	assert(r <= n);
  801baf:	39 f0                	cmp    %esi,%eax
  801bb1:	77 24                	ja     801bd7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bb3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bb8:	7f 33                	jg     801bed <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	50                   	push   %eax
  801bbe:	68 00 50 80 00       	push   $0x805000
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	e8 fa ef ff ff       	call   800bc5 <memmove>
	return r;
  801bcb:	83 c4 10             	add    $0x10,%esp
}
  801bce:	89 d8                	mov    %ebx,%eax
  801bd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5d                   	pop    %ebp
  801bd6:	c3                   	ret    
	assert(r <= n);
  801bd7:	68 28 2b 80 00       	push   $0x802b28
  801bdc:	68 2f 2b 80 00       	push   $0x802b2f
  801be1:	6a 7c                	push   $0x7c
  801be3:	68 44 2b 80 00       	push   $0x802b44
  801be8:	e8 61 e6 ff ff       	call   80024e <_panic>
	assert(r <= PGSIZE);
  801bed:	68 4f 2b 80 00       	push   $0x802b4f
  801bf2:	68 2f 2b 80 00       	push   $0x802b2f
  801bf7:	6a 7d                	push   $0x7d
  801bf9:	68 44 2b 80 00       	push   $0x802b44
  801bfe:	e8 4b e6 ff ff       	call   80024e <_panic>

00801c03 <open>:
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
  801c08:	83 ec 1c             	sub    $0x1c,%esp
  801c0b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c0e:	56                   	push   %esi
  801c0f:	e8 ea ed ff ff       	call   8009fe <strlen>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c1c:	7f 6c                	jg     801c8a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c24:	50                   	push   %eax
  801c25:	e8 b9 f8 ff ff       	call   8014e3 <fd_alloc>
  801c2a:	89 c3                	mov    %eax,%ebx
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 3c                	js     801c6f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c33:	83 ec 08             	sub    $0x8,%esp
  801c36:	56                   	push   %esi
  801c37:	68 00 50 80 00       	push   $0x805000
  801c3c:	e8 f6 ed ff ff       	call   800a37 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c44:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c51:	e8 f3 fd ff ff       	call   801a49 <fsipc>
  801c56:	89 c3                	mov    %eax,%ebx
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 19                	js     801c78 <open+0x75>
	return fd2num(fd);
  801c5f:	83 ec 0c             	sub    $0xc,%esp
  801c62:	ff 75 f4             	pushl  -0xc(%ebp)
  801c65:	e8 52 f8 ff ff       	call   8014bc <fd2num>
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	83 c4 10             	add    $0x10,%esp
}
  801c6f:	89 d8                	mov    %ebx,%eax
  801c71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
		fd_close(fd, 0);
  801c78:	83 ec 08             	sub    $0x8,%esp
  801c7b:	6a 00                	push   $0x0
  801c7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c80:	e8 56 f9 ff ff       	call   8015db <fd_close>
		return r;
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	eb e5                	jmp    801c6f <open+0x6c>
		return -E_BAD_PATH;
  801c8a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c8f:	eb de                	jmp    801c6f <open+0x6c>

00801c91 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c97:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9c:	b8 08 00 00 00       	mov    $0x8,%eax
  801ca1:	e8 a3 fd ff ff       	call   801a49 <fsipc>
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cae:	89 d0                	mov    %edx,%eax
  801cb0:	c1 e8 16             	shr    $0x16,%eax
  801cb3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801cbf:	f6 c1 01             	test   $0x1,%cl
  801cc2:	74 1d                	je     801ce1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801cc4:	c1 ea 0c             	shr    $0xc,%edx
  801cc7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801cce:	f6 c2 01             	test   $0x1,%dl
  801cd1:	74 0e                	je     801ce1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cd3:	c1 ea 0c             	shr    $0xc,%edx
  801cd6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801cdd:	ef 
  801cde:	0f b7 c0             	movzwl %ax,%eax
}
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	56                   	push   %esi
  801ce7:	53                   	push   %ebx
  801ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	e8 d6 f7 ff ff       	call   8014cc <fd2data>
  801cf6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cf8:	83 c4 08             	add    $0x8,%esp
  801cfb:	68 5b 2b 80 00       	push   $0x802b5b
  801d00:	53                   	push   %ebx
  801d01:	e8 31 ed ff ff       	call   800a37 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d06:	8b 46 04             	mov    0x4(%esi),%eax
  801d09:	2b 06                	sub    (%esi),%eax
  801d0b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d11:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d18:	00 00 00 
	stat->st_dev = &devpipe;
  801d1b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d22:	30 80 00 
	return 0;
}
  801d25:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5e                   	pop    %esi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    

00801d31 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	53                   	push   %ebx
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d3b:	53                   	push   %ebx
  801d3c:	6a 00                	push   $0x0
  801d3e:	e8 6b f1 ff ff       	call   800eae <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d43:	89 1c 24             	mov    %ebx,(%esp)
  801d46:	e8 81 f7 ff ff       	call   8014cc <fd2data>
  801d4b:	83 c4 08             	add    $0x8,%esp
  801d4e:	50                   	push   %eax
  801d4f:	6a 00                	push   $0x0
  801d51:	e8 58 f1 ff ff       	call   800eae <sys_page_unmap>
}
  801d56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <_pipeisclosed>:
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	57                   	push   %edi
  801d5f:	56                   	push   %esi
  801d60:	53                   	push   %ebx
  801d61:	83 ec 1c             	sub    $0x1c,%esp
  801d64:	89 c7                	mov    %eax,%edi
  801d66:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d68:	a1 04 40 80 00       	mov    0x804004,%eax
  801d6d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	57                   	push   %edi
  801d74:	e8 2f ff ff ff       	call   801ca8 <pageref>
  801d79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d7c:	89 34 24             	mov    %esi,(%esp)
  801d7f:	e8 24 ff ff ff       	call   801ca8 <pageref>
		nn = thisenv->env_runs;
  801d84:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d8a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	39 cb                	cmp    %ecx,%ebx
  801d92:	74 1b                	je     801daf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d94:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d97:	75 cf                	jne    801d68 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d99:	8b 42 58             	mov    0x58(%edx),%eax
  801d9c:	6a 01                	push   $0x1
  801d9e:	50                   	push   %eax
  801d9f:	53                   	push   %ebx
  801da0:	68 62 2b 80 00       	push   $0x802b62
  801da5:	e8 7f e5 ff ff       	call   800329 <cprintf>
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	eb b9                	jmp    801d68 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801daf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801db2:	0f 94 c0             	sete   %al
  801db5:	0f b6 c0             	movzbl %al,%eax
}
  801db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    

00801dc0 <devpipe_write>:
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	57                   	push   %edi
  801dc4:	56                   	push   %esi
  801dc5:	53                   	push   %ebx
  801dc6:	83 ec 28             	sub    $0x28,%esp
  801dc9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dcc:	56                   	push   %esi
  801dcd:	e8 fa f6 ff ff       	call   8014cc <fd2data>
  801dd2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ddc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ddf:	74 4f                	je     801e30 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801de1:	8b 43 04             	mov    0x4(%ebx),%eax
  801de4:	8b 0b                	mov    (%ebx),%ecx
  801de6:	8d 51 20             	lea    0x20(%ecx),%edx
  801de9:	39 d0                	cmp    %edx,%eax
  801deb:	72 14                	jb     801e01 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ded:	89 da                	mov    %ebx,%edx
  801def:	89 f0                	mov    %esi,%eax
  801df1:	e8 65 ff ff ff       	call   801d5b <_pipeisclosed>
  801df6:	85 c0                	test   %eax,%eax
  801df8:	75 3b                	jne    801e35 <devpipe_write+0x75>
			sys_yield();
  801dfa:	e8 0b f0 ff ff       	call   800e0a <sys_yield>
  801dff:	eb e0                	jmp    801de1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e04:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e08:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e0b:	89 c2                	mov    %eax,%edx
  801e0d:	c1 fa 1f             	sar    $0x1f,%edx
  801e10:	89 d1                	mov    %edx,%ecx
  801e12:	c1 e9 1b             	shr    $0x1b,%ecx
  801e15:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e18:	83 e2 1f             	and    $0x1f,%edx
  801e1b:	29 ca                	sub    %ecx,%edx
  801e1d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e21:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e25:	83 c0 01             	add    $0x1,%eax
  801e28:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e2b:	83 c7 01             	add    $0x1,%edi
  801e2e:	eb ac                	jmp    801ddc <devpipe_write+0x1c>
	return i;
  801e30:	8b 45 10             	mov    0x10(%ebp),%eax
  801e33:	eb 05                	jmp    801e3a <devpipe_write+0x7a>
				return 0;
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5e                   	pop    %esi
  801e3f:	5f                   	pop    %edi
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    

00801e42 <devpipe_read>:
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 18             	sub    $0x18,%esp
  801e4b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e4e:	57                   	push   %edi
  801e4f:	e8 78 f6 ff ff       	call   8014cc <fd2data>
  801e54:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	be 00 00 00 00       	mov    $0x0,%esi
  801e5e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e61:	75 14                	jne    801e77 <devpipe_read+0x35>
	return i;
  801e63:	8b 45 10             	mov    0x10(%ebp),%eax
  801e66:	eb 02                	jmp    801e6a <devpipe_read+0x28>
				return i;
  801e68:	89 f0                	mov    %esi,%eax
}
  801e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e6d:	5b                   	pop    %ebx
  801e6e:	5e                   	pop    %esi
  801e6f:	5f                   	pop    %edi
  801e70:	5d                   	pop    %ebp
  801e71:	c3                   	ret    
			sys_yield();
  801e72:	e8 93 ef ff ff       	call   800e0a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e77:	8b 03                	mov    (%ebx),%eax
  801e79:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e7c:	75 18                	jne    801e96 <devpipe_read+0x54>
			if (i > 0)
  801e7e:	85 f6                	test   %esi,%esi
  801e80:	75 e6                	jne    801e68 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e82:	89 da                	mov    %ebx,%edx
  801e84:	89 f8                	mov    %edi,%eax
  801e86:	e8 d0 fe ff ff       	call   801d5b <_pipeisclosed>
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	74 e3                	je     801e72 <devpipe_read+0x30>
				return 0;
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e94:	eb d4                	jmp    801e6a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e96:	99                   	cltd   
  801e97:	c1 ea 1b             	shr    $0x1b,%edx
  801e9a:	01 d0                	add    %edx,%eax
  801e9c:	83 e0 1f             	and    $0x1f,%eax
  801e9f:	29 d0                	sub    %edx,%eax
  801ea1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eac:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eaf:	83 c6 01             	add    $0x1,%esi
  801eb2:	eb aa                	jmp    801e5e <devpipe_read+0x1c>

00801eb4 <pipe>:
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	56                   	push   %esi
  801eb8:	53                   	push   %ebx
  801eb9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ebc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebf:	50                   	push   %eax
  801ec0:	e8 1e f6 ff ff       	call   8014e3 <fd_alloc>
  801ec5:	89 c3                	mov    %eax,%ebx
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	0f 88 23 01 00 00    	js     801ff5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed2:	83 ec 04             	sub    $0x4,%esp
  801ed5:	68 07 04 00 00       	push   $0x407
  801eda:	ff 75 f4             	pushl  -0xc(%ebp)
  801edd:	6a 00                	push   $0x0
  801edf:	e8 45 ef ff ff       	call   800e29 <sys_page_alloc>
  801ee4:	89 c3                	mov    %eax,%ebx
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	0f 88 04 01 00 00    	js     801ff5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef7:	50                   	push   %eax
  801ef8:	e8 e6 f5 ff ff       	call   8014e3 <fd_alloc>
  801efd:	89 c3                	mov    %eax,%ebx
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	85 c0                	test   %eax,%eax
  801f04:	0f 88 db 00 00 00    	js     801fe5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	68 07 04 00 00       	push   $0x407
  801f12:	ff 75 f0             	pushl  -0x10(%ebp)
  801f15:	6a 00                	push   $0x0
  801f17:	e8 0d ef ff ff       	call   800e29 <sys_page_alloc>
  801f1c:	89 c3                	mov    %eax,%ebx
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	85 c0                	test   %eax,%eax
  801f23:	0f 88 bc 00 00 00    	js     801fe5 <pipe+0x131>
	va = fd2data(fd0);
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2f:	e8 98 f5 ff ff       	call   8014cc <fd2data>
  801f34:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f36:	83 c4 0c             	add    $0xc,%esp
  801f39:	68 07 04 00 00       	push   $0x407
  801f3e:	50                   	push   %eax
  801f3f:	6a 00                	push   $0x0
  801f41:	e8 e3 ee ff ff       	call   800e29 <sys_page_alloc>
  801f46:	89 c3                	mov    %eax,%ebx
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	0f 88 82 00 00 00    	js     801fd5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	ff 75 f0             	pushl  -0x10(%ebp)
  801f59:	e8 6e f5 ff ff       	call   8014cc <fd2data>
  801f5e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f65:	50                   	push   %eax
  801f66:	6a 00                	push   $0x0
  801f68:	56                   	push   %esi
  801f69:	6a 00                	push   $0x0
  801f6b:	e8 fc ee ff ff       	call   800e6c <sys_page_map>
  801f70:	89 c3                	mov    %eax,%ebx
  801f72:	83 c4 20             	add    $0x20,%esp
  801f75:	85 c0                	test   %eax,%eax
  801f77:	78 4e                	js     801fc7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f79:	a1 20 30 80 00       	mov    0x803020,%eax
  801f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f81:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f86:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f90:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f95:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa2:	e8 15 f5 ff ff       	call   8014bc <fd2num>
  801fa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801faa:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fac:	83 c4 04             	add    $0x4,%esp
  801faf:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb2:	e8 05 f5 ff ff       	call   8014bc <fd2num>
  801fb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fba:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fc5:	eb 2e                	jmp    801ff5 <pipe+0x141>
	sys_page_unmap(0, va);
  801fc7:	83 ec 08             	sub    $0x8,%esp
  801fca:	56                   	push   %esi
  801fcb:	6a 00                	push   $0x0
  801fcd:	e8 dc ee ff ff       	call   800eae <sys_page_unmap>
  801fd2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fd5:	83 ec 08             	sub    $0x8,%esp
  801fd8:	ff 75 f0             	pushl  -0x10(%ebp)
  801fdb:	6a 00                	push   $0x0
  801fdd:	e8 cc ee ff ff       	call   800eae <sys_page_unmap>
  801fe2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fe5:	83 ec 08             	sub    $0x8,%esp
  801fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  801feb:	6a 00                	push   $0x0
  801fed:	e8 bc ee ff ff       	call   800eae <sys_page_unmap>
  801ff2:	83 c4 10             	add    $0x10,%esp
}
  801ff5:	89 d8                	mov    %ebx,%eax
  801ff7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ffa:	5b                   	pop    %ebx
  801ffb:	5e                   	pop    %esi
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    

00801ffe <pipeisclosed>:
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802004:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802007:	50                   	push   %eax
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	e8 25 f5 ff ff       	call   801535 <fd_lookup>
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	85 c0                	test   %eax,%eax
  802015:	78 18                	js     80202f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	ff 75 f4             	pushl  -0xc(%ebp)
  80201d:	e8 aa f4 ff ff       	call   8014cc <fd2data>
	return _pipeisclosed(fd, p);
  802022:	89 c2                	mov    %eax,%edx
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	e8 2f fd ff ff       	call   801d5b <_pipeisclosed>
  80202c:	83 c4 10             	add    $0x10,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
  802036:	c3                   	ret    

00802037 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80203d:	68 7a 2b 80 00       	push   $0x802b7a
  802042:	ff 75 0c             	pushl  0xc(%ebp)
  802045:	e8 ed e9 ff ff       	call   800a37 <strcpy>
	return 0;
}
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <devcons_write>:
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	57                   	push   %edi
  802055:	56                   	push   %esi
  802056:	53                   	push   %ebx
  802057:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80205d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802062:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802068:	3b 75 10             	cmp    0x10(%ebp),%esi
  80206b:	73 31                	jae    80209e <devcons_write+0x4d>
		m = n - tot;
  80206d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802070:	29 f3                	sub    %esi,%ebx
  802072:	83 fb 7f             	cmp    $0x7f,%ebx
  802075:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80207a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	53                   	push   %ebx
  802081:	89 f0                	mov    %esi,%eax
  802083:	03 45 0c             	add    0xc(%ebp),%eax
  802086:	50                   	push   %eax
  802087:	57                   	push   %edi
  802088:	e8 38 eb ff ff       	call   800bc5 <memmove>
		sys_cputs(buf, m);
  80208d:	83 c4 08             	add    $0x8,%esp
  802090:	53                   	push   %ebx
  802091:	57                   	push   %edi
  802092:	e8 d6 ec ff ff       	call   800d6d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802097:	01 de                	add    %ebx,%esi
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	eb ca                	jmp    802068 <devcons_write+0x17>
}
  80209e:	89 f0                	mov    %esi,%eax
  8020a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a3:	5b                   	pop    %ebx
  8020a4:	5e                   	pop    %esi
  8020a5:	5f                   	pop    %edi
  8020a6:	5d                   	pop    %ebp
  8020a7:	c3                   	ret    

008020a8 <devcons_read>:
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 08             	sub    $0x8,%esp
  8020ae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b7:	74 21                	je     8020da <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020b9:	e8 cd ec ff ff       	call   800d8b <sys_cgetc>
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	75 07                	jne    8020c9 <devcons_read+0x21>
		sys_yield();
  8020c2:	e8 43 ed ff ff       	call   800e0a <sys_yield>
  8020c7:	eb f0                	jmp    8020b9 <devcons_read+0x11>
	if (c < 0)
  8020c9:	78 0f                	js     8020da <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020cb:	83 f8 04             	cmp    $0x4,%eax
  8020ce:	74 0c                	je     8020dc <devcons_read+0x34>
	*(char*)vbuf = c;
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	88 02                	mov    %al,(%edx)
	return 1;
  8020d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    
		return 0;
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e1:	eb f7                	jmp    8020da <devcons_read+0x32>

008020e3 <cputchar>:
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020ef:	6a 01                	push   $0x1
  8020f1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f4:	50                   	push   %eax
  8020f5:	e8 73 ec ff ff       	call   800d6d <sys_cputs>
}
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <getchar>:
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802105:	6a 01                	push   $0x1
  802107:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80210a:	50                   	push   %eax
  80210b:	6a 00                	push   $0x0
  80210d:	e8 8e f6 ff ff       	call   8017a0 <read>
	if (r < 0)
  802112:	83 c4 10             	add    $0x10,%esp
  802115:	85 c0                	test   %eax,%eax
  802117:	78 06                	js     80211f <getchar+0x20>
	if (r < 1)
  802119:	74 06                	je     802121 <getchar+0x22>
	return c;
  80211b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    
		return -E_EOF;
  802121:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802126:	eb f7                	jmp    80211f <getchar+0x20>

00802128 <iscons>:
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80212e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802131:	50                   	push   %eax
  802132:	ff 75 08             	pushl  0x8(%ebp)
  802135:	e8 fb f3 ff ff       	call   801535 <fd_lookup>
  80213a:	83 c4 10             	add    $0x10,%esp
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 11                	js     802152 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80214a:	39 10                	cmp    %edx,(%eax)
  80214c:	0f 94 c0             	sete   %al
  80214f:	0f b6 c0             	movzbl %al,%eax
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <opencons>:
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80215a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215d:	50                   	push   %eax
  80215e:	e8 80 f3 ff ff       	call   8014e3 <fd_alloc>
  802163:	83 c4 10             	add    $0x10,%esp
  802166:	85 c0                	test   %eax,%eax
  802168:	78 3a                	js     8021a4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80216a:	83 ec 04             	sub    $0x4,%esp
  80216d:	68 07 04 00 00       	push   $0x407
  802172:	ff 75 f4             	pushl  -0xc(%ebp)
  802175:	6a 00                	push   $0x0
  802177:	e8 ad ec ff ff       	call   800e29 <sys_page_alloc>
  80217c:	83 c4 10             	add    $0x10,%esp
  80217f:	85 c0                	test   %eax,%eax
  802181:	78 21                	js     8021a4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80218c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802198:	83 ec 0c             	sub    $0xc,%esp
  80219b:	50                   	push   %eax
  80219c:	e8 1b f3 ff ff       	call   8014bc <fd2num>
  8021a1:	83 c4 10             	add    $0x10,%esp
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8021ac:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8021b3:	74 0a                	je     8021bf <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	6a 07                	push   $0x7
  8021c4:	68 00 f0 bf ee       	push   $0xeebff000
  8021c9:	6a 00                	push   $0x0
  8021cb:	e8 59 ec ff ff       	call   800e29 <sys_page_alloc>
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	78 28                	js     8021ff <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8021d7:	83 ec 08             	sub    $0x8,%esp
  8021da:	68 11 22 80 00       	push   $0x802211
  8021df:	6a 00                	push   $0x0
  8021e1:	e8 cf ed ff ff       	call   800fb5 <sys_env_set_pgfault_upcall>
  8021e6:	83 c4 10             	add    $0x10,%esp
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	79 c8                	jns    8021b5 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8021ed:	50                   	push   %eax
  8021ee:	68 d4 29 80 00       	push   $0x8029d4
  8021f3:	6a 23                	push   $0x23
  8021f5:	68 9e 2b 80 00       	push   $0x802b9e
  8021fa:	e8 4f e0 ff ff       	call   80024e <_panic>
			panic("set_pgfault_handler %e\n",r);
  8021ff:	50                   	push   %eax
  802200:	68 86 2b 80 00       	push   $0x802b86
  802205:	6a 21                	push   $0x21
  802207:	68 9e 2b 80 00       	push   $0x802b9e
  80220c:	e8 3d e0 ff ff       	call   80024e <_panic>

00802211 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802211:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802212:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802217:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802219:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  80221c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  802220:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802224:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802227:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802229:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80222d:	83 c4 08             	add    $0x8,%esp
	popal
  802230:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802231:	83 c4 04             	add    $0x4,%esp
	popfl
  802234:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802235:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802236:	c3                   	ret    
  802237:	66 90                	xchg   %ax,%ax
  802239:	66 90                	xchg   %ax,%ax
  80223b:	66 90                	xchg   %ax,%ax
  80223d:	66 90                	xchg   %ax,%ax
  80223f:	90                   	nop

00802240 <__udivdi3>:
  802240:	55                   	push   %ebp
  802241:	57                   	push   %edi
  802242:	56                   	push   %esi
  802243:	53                   	push   %ebx
  802244:	83 ec 1c             	sub    $0x1c,%esp
  802247:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80224b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80224f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802253:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802257:	85 d2                	test   %edx,%edx
  802259:	75 4d                	jne    8022a8 <__udivdi3+0x68>
  80225b:	39 f3                	cmp    %esi,%ebx
  80225d:	76 19                	jbe    802278 <__udivdi3+0x38>
  80225f:	31 ff                	xor    %edi,%edi
  802261:	89 e8                	mov    %ebp,%eax
  802263:	89 f2                	mov    %esi,%edx
  802265:	f7 f3                	div    %ebx
  802267:	89 fa                	mov    %edi,%edx
  802269:	83 c4 1c             	add    $0x1c,%esp
  80226c:	5b                   	pop    %ebx
  80226d:	5e                   	pop    %esi
  80226e:	5f                   	pop    %edi
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    
  802271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802278:	89 d9                	mov    %ebx,%ecx
  80227a:	85 db                	test   %ebx,%ebx
  80227c:	75 0b                	jne    802289 <__udivdi3+0x49>
  80227e:	b8 01 00 00 00       	mov    $0x1,%eax
  802283:	31 d2                	xor    %edx,%edx
  802285:	f7 f3                	div    %ebx
  802287:	89 c1                	mov    %eax,%ecx
  802289:	31 d2                	xor    %edx,%edx
  80228b:	89 f0                	mov    %esi,%eax
  80228d:	f7 f1                	div    %ecx
  80228f:	89 c6                	mov    %eax,%esi
  802291:	89 e8                	mov    %ebp,%eax
  802293:	89 f7                	mov    %esi,%edi
  802295:	f7 f1                	div    %ecx
  802297:	89 fa                	mov    %edi,%edx
  802299:	83 c4 1c             	add    $0x1c,%esp
  80229c:	5b                   	pop    %ebx
  80229d:	5e                   	pop    %esi
  80229e:	5f                   	pop    %edi
  80229f:	5d                   	pop    %ebp
  8022a0:	c3                   	ret    
  8022a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a8:	39 f2                	cmp    %esi,%edx
  8022aa:	77 1c                	ja     8022c8 <__udivdi3+0x88>
  8022ac:	0f bd fa             	bsr    %edx,%edi
  8022af:	83 f7 1f             	xor    $0x1f,%edi
  8022b2:	75 2c                	jne    8022e0 <__udivdi3+0xa0>
  8022b4:	39 f2                	cmp    %esi,%edx
  8022b6:	72 06                	jb     8022be <__udivdi3+0x7e>
  8022b8:	31 c0                	xor    %eax,%eax
  8022ba:	39 eb                	cmp    %ebp,%ebx
  8022bc:	77 a9                	ja     802267 <__udivdi3+0x27>
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	eb a2                	jmp    802267 <__udivdi3+0x27>
  8022c5:	8d 76 00             	lea    0x0(%esi),%esi
  8022c8:	31 ff                	xor    %edi,%edi
  8022ca:	31 c0                	xor    %eax,%eax
  8022cc:	89 fa                	mov    %edi,%edx
  8022ce:	83 c4 1c             	add    $0x1c,%esp
  8022d1:	5b                   	pop    %ebx
  8022d2:	5e                   	pop    %esi
  8022d3:	5f                   	pop    %edi
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    
  8022d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022dd:	8d 76 00             	lea    0x0(%esi),%esi
  8022e0:	89 f9                	mov    %edi,%ecx
  8022e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022e7:	29 f8                	sub    %edi,%eax
  8022e9:	d3 e2                	shl    %cl,%edx
  8022eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022ef:	89 c1                	mov    %eax,%ecx
  8022f1:	89 da                	mov    %ebx,%edx
  8022f3:	d3 ea                	shr    %cl,%edx
  8022f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022f9:	09 d1                	or     %edx,%ecx
  8022fb:	89 f2                	mov    %esi,%edx
  8022fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802301:	89 f9                	mov    %edi,%ecx
  802303:	d3 e3                	shl    %cl,%ebx
  802305:	89 c1                	mov    %eax,%ecx
  802307:	d3 ea                	shr    %cl,%edx
  802309:	89 f9                	mov    %edi,%ecx
  80230b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80230f:	89 eb                	mov    %ebp,%ebx
  802311:	d3 e6                	shl    %cl,%esi
  802313:	89 c1                	mov    %eax,%ecx
  802315:	d3 eb                	shr    %cl,%ebx
  802317:	09 de                	or     %ebx,%esi
  802319:	89 f0                	mov    %esi,%eax
  80231b:	f7 74 24 08          	divl   0x8(%esp)
  80231f:	89 d6                	mov    %edx,%esi
  802321:	89 c3                	mov    %eax,%ebx
  802323:	f7 64 24 0c          	mull   0xc(%esp)
  802327:	39 d6                	cmp    %edx,%esi
  802329:	72 15                	jb     802340 <__udivdi3+0x100>
  80232b:	89 f9                	mov    %edi,%ecx
  80232d:	d3 e5                	shl    %cl,%ebp
  80232f:	39 c5                	cmp    %eax,%ebp
  802331:	73 04                	jae    802337 <__udivdi3+0xf7>
  802333:	39 d6                	cmp    %edx,%esi
  802335:	74 09                	je     802340 <__udivdi3+0x100>
  802337:	89 d8                	mov    %ebx,%eax
  802339:	31 ff                	xor    %edi,%edi
  80233b:	e9 27 ff ff ff       	jmp    802267 <__udivdi3+0x27>
  802340:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802343:	31 ff                	xor    %edi,%edi
  802345:	e9 1d ff ff ff       	jmp    802267 <__udivdi3+0x27>
  80234a:	66 90                	xchg   %ax,%ax
  80234c:	66 90                	xchg   %ax,%ax
  80234e:	66 90                	xchg   %ax,%ax

00802350 <__umoddi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80235b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80235f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802363:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802367:	89 da                	mov    %ebx,%edx
  802369:	85 c0                	test   %eax,%eax
  80236b:	75 43                	jne    8023b0 <__umoddi3+0x60>
  80236d:	39 df                	cmp    %ebx,%edi
  80236f:	76 17                	jbe    802388 <__umoddi3+0x38>
  802371:	89 f0                	mov    %esi,%eax
  802373:	f7 f7                	div    %edi
  802375:	89 d0                	mov    %edx,%eax
  802377:	31 d2                	xor    %edx,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 fd                	mov    %edi,%ebp
  80238a:	85 ff                	test   %edi,%edi
  80238c:	75 0b                	jne    802399 <__umoddi3+0x49>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f7                	div    %edi
  802397:	89 c5                	mov    %eax,%ebp
  802399:	89 d8                	mov    %ebx,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	f7 f5                	div    %ebp
  80239f:	89 f0                	mov    %esi,%eax
  8023a1:	f7 f5                	div    %ebp
  8023a3:	89 d0                	mov    %edx,%eax
  8023a5:	eb d0                	jmp    802377 <__umoddi3+0x27>
  8023a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ae:	66 90                	xchg   %ax,%ax
  8023b0:	89 f1                	mov    %esi,%ecx
  8023b2:	39 d8                	cmp    %ebx,%eax
  8023b4:	76 0a                	jbe    8023c0 <__umoddi3+0x70>
  8023b6:	89 f0                	mov    %esi,%eax
  8023b8:	83 c4 1c             	add    $0x1c,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5f                   	pop    %edi
  8023be:	5d                   	pop    %ebp
  8023bf:	c3                   	ret    
  8023c0:	0f bd e8             	bsr    %eax,%ebp
  8023c3:	83 f5 1f             	xor    $0x1f,%ebp
  8023c6:	75 20                	jne    8023e8 <__umoddi3+0x98>
  8023c8:	39 d8                	cmp    %ebx,%eax
  8023ca:	0f 82 b0 00 00 00    	jb     802480 <__umoddi3+0x130>
  8023d0:	39 f7                	cmp    %esi,%edi
  8023d2:	0f 86 a8 00 00 00    	jbe    802480 <__umoddi3+0x130>
  8023d8:	89 c8                	mov    %ecx,%eax
  8023da:	83 c4 1c             	add    $0x1c,%esp
  8023dd:	5b                   	pop    %ebx
  8023de:	5e                   	pop    %esi
  8023df:	5f                   	pop    %edi
  8023e0:	5d                   	pop    %ebp
  8023e1:	c3                   	ret    
  8023e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023e8:	89 e9                	mov    %ebp,%ecx
  8023ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8023ef:	29 ea                	sub    %ebp,%edx
  8023f1:	d3 e0                	shl    %cl,%eax
  8023f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023f7:	89 d1                	mov    %edx,%ecx
  8023f9:	89 f8                	mov    %edi,%eax
  8023fb:	d3 e8                	shr    %cl,%eax
  8023fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802401:	89 54 24 04          	mov    %edx,0x4(%esp)
  802405:	8b 54 24 04          	mov    0x4(%esp),%edx
  802409:	09 c1                	or     %eax,%ecx
  80240b:	89 d8                	mov    %ebx,%eax
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 e9                	mov    %ebp,%ecx
  802413:	d3 e7                	shl    %cl,%edi
  802415:	89 d1                	mov    %edx,%ecx
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80241f:	d3 e3                	shl    %cl,%ebx
  802421:	89 c7                	mov    %eax,%edi
  802423:	89 d1                	mov    %edx,%ecx
  802425:	89 f0                	mov    %esi,%eax
  802427:	d3 e8                	shr    %cl,%eax
  802429:	89 e9                	mov    %ebp,%ecx
  80242b:	89 fa                	mov    %edi,%edx
  80242d:	d3 e6                	shl    %cl,%esi
  80242f:	09 d8                	or     %ebx,%eax
  802431:	f7 74 24 08          	divl   0x8(%esp)
  802435:	89 d1                	mov    %edx,%ecx
  802437:	89 f3                	mov    %esi,%ebx
  802439:	f7 64 24 0c          	mull   0xc(%esp)
  80243d:	89 c6                	mov    %eax,%esi
  80243f:	89 d7                	mov    %edx,%edi
  802441:	39 d1                	cmp    %edx,%ecx
  802443:	72 06                	jb     80244b <__umoddi3+0xfb>
  802445:	75 10                	jne    802457 <__umoddi3+0x107>
  802447:	39 c3                	cmp    %eax,%ebx
  802449:	73 0c                	jae    802457 <__umoddi3+0x107>
  80244b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80244f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802453:	89 d7                	mov    %edx,%edi
  802455:	89 c6                	mov    %eax,%esi
  802457:	89 ca                	mov    %ecx,%edx
  802459:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80245e:	29 f3                	sub    %esi,%ebx
  802460:	19 fa                	sbb    %edi,%edx
  802462:	89 d0                	mov    %edx,%eax
  802464:	d3 e0                	shl    %cl,%eax
  802466:	89 e9                	mov    %ebp,%ecx
  802468:	d3 eb                	shr    %cl,%ebx
  80246a:	d3 ea                	shr    %cl,%edx
  80246c:	09 d8                	or     %ebx,%eax
  80246e:	83 c4 1c             	add    $0x1c,%esp
  802471:	5b                   	pop    %ebx
  802472:	5e                   	pop    %esi
  802473:	5f                   	pop    %edi
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    
  802476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	89 da                	mov    %ebx,%edx
  802482:	29 fe                	sub    %edi,%esi
  802484:	19 c2                	sbb    %eax,%edx
  802486:	89 f1                	mov    %esi,%ecx
  802488:	89 c8                	mov    %ecx,%eax
  80248a:	e9 4b ff ff ff       	jmp    8023da <__umoddi3+0x8a>
