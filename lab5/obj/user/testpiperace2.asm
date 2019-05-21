
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 a1 01 00 00       	call   8001d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 80 24 80 00       	push   $0x802480
  800041:	e8 c2 02 00 00       	call   800308 <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 18 1d 00 00       	call   801d69 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5d                	js     8000b5 <umain+0x82>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 22 11 00 00       	call   80117f <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 64                	js     8000c7 <umain+0x94>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	74 74                	je     8000d9 <umain+0xa6>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800065:	89 f8                	mov    %edi,%eax
  800067:	25 ff 03 00 00       	and    $0x3ff,%eax
	while (kid->env_status == ENV_RUNNABLE)
  80006c:	8d 1c c0             	lea    (%eax,%eax,8),%ebx
  80006f:	c1 e3 04             	shl    $0x4,%ebx
  800072:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800078:	8b 43 54             	mov    0x54(%ebx),%eax
  80007b:	83 f8 02             	cmp    $0x2,%eax
  80007e:	0f 85 d1 00 00 00    	jne    800155 <umain+0x122>
		if (pipeisclosed(p[0]) != 0) {
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	ff 75 e0             	pushl  -0x20(%ebp)
  80008a:	e8 24 1e 00 00       	call   801eb3 <pipeisclosed>
  80008f:	83 c4 10             	add    $0x10,%esp
  800092:	85 c0                	test   %eax,%eax
  800094:	74 e2                	je     800078 <umain+0x45>
			cprintf("\nRACE: pipe appears closed\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 f0 24 80 00       	push   $0x8024f0
  80009e:	e8 65 02 00 00       	call   800308 <cprintf>
			sys_env_destroy(r);
  8000a3:	89 3c 24             	mov    %edi,(%esp)
  8000a6:	e8 de 0c 00 00       	call   800d89 <sys_env_destroy>
			exit();
  8000ab:	e8 6b 01 00 00       	call   80021b <exit>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	eb c3                	jmp    800078 <umain+0x45>
		panic("pipe: %e", r);
  8000b5:	50                   	push   %eax
  8000b6:	68 ce 24 80 00       	push   $0x8024ce
  8000bb:	6a 0d                	push   $0xd
  8000bd:	68 d7 24 80 00       	push   $0x8024d7
  8000c2:	e8 66 01 00 00       	call   80022d <_panic>
		panic("fork: %e", r);
  8000c7:	50                   	push   %eax
  8000c8:	68 00 2a 80 00       	push   $0x802a00
  8000cd:	6a 0f                	push   $0xf
  8000cf:	68 d7 24 80 00       	push   $0x8024d7
  8000d4:	e8 54 01 00 00       	call   80022d <_panic>
		close(p[1]);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000df:	e8 6e 14 00 00       	call   801552 <close>
  8000e4:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e7:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e9:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ee:	eb 42                	jmp    800132 <umain+0xff>
				cprintf("%d.", i);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	53                   	push   %ebx
  8000f4:	68 ec 24 80 00       	push   $0x8024ec
  8000f9:	e8 0a 02 00 00       	call   800308 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800101:	83 ec 08             	sub    $0x8,%esp
  800104:	6a 0a                	push   $0xa
  800106:	ff 75 e0             	pushl  -0x20(%ebp)
  800109:	e8 96 14 00 00       	call   8015a4 <dup>
			sys_yield();
  80010e:	e8 d6 0c 00 00       	call   800de9 <sys_yield>
			close(10);
  800113:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80011a:	e8 33 14 00 00       	call   801552 <close>
			sys_yield();
  80011f:	e8 c5 0c 00 00       	call   800de9 <sys_yield>
		for (i = 0; i < 200; i++) {
  800124:	83 c3 01             	add    $0x1,%ebx
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800130:	74 19                	je     80014b <umain+0x118>
			if (i % 10 == 0)
  800132:	89 d8                	mov    %ebx,%eax
  800134:	f7 ee                	imul   %esi
  800136:	c1 fa 02             	sar    $0x2,%edx
  800139:	89 d8                	mov    %ebx,%eax
  80013b:	c1 f8 1f             	sar    $0x1f,%eax
  80013e:	29 c2                	sub    %eax,%edx
  800140:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800143:	01 c0                	add    %eax,%eax
  800145:	39 c3                	cmp    %eax,%ebx
  800147:	75 b8                	jne    800101 <umain+0xce>
  800149:	eb a5                	jmp    8000f0 <umain+0xbd>
		exit();
  80014b:	e8 cb 00 00 00       	call   80021b <exit>
  800150:	e9 10 ff ff ff       	jmp    800065 <umain+0x32>
		}
	cprintf("child done with loop\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 0c 25 80 00       	push   $0x80250c
  80015d:	e8 a6 01 00 00       	call   800308 <cprintf>
	if (pipeisclosed(p[0]))
  800162:	83 c4 04             	add    $0x4,%esp
  800165:	ff 75 e0             	pushl  -0x20(%ebp)
  800168:	e8 46 1d 00 00       	call   801eb3 <pipeisclosed>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	75 38                	jne    8001ac <umain+0x179>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800174:	83 ec 08             	sub    $0x8,%esp
  800177:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 a2 12 00 00       	call   801425 <fd_lookup>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	85 c0                	test   %eax,%eax
  800188:	78 36                	js     8001c0 <umain+0x18d>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	ff 75 dc             	pushl  -0x24(%ebp)
  800190:	e8 27 12 00 00       	call   8013bc <fd2data>
	cprintf("race didn't happen\n");
  800195:	c7 04 24 3a 25 80 00 	movl   $0x80253a,(%esp)
  80019c:	e8 67 01 00 00       	call   800308 <cprintf>
}
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a7:	5b                   	pop    %ebx
  8001a8:	5e                   	pop    %esi
  8001a9:	5f                   	pop    %edi
  8001aa:	5d                   	pop    %ebp
  8001ab:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 a4 24 80 00       	push   $0x8024a4
  8001b4:	6a 40                	push   $0x40
  8001b6:	68 d7 24 80 00       	push   $0x8024d7
  8001bb:	e8 6d 00 00 00       	call   80022d <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c0:	50                   	push   %eax
  8001c1:	68 22 25 80 00       	push   $0x802522
  8001c6:	6a 42                	push   $0x42
  8001c8:	68 d7 24 80 00       	push   $0x8024d7
  8001cd:	e8 5b 00 00 00       	call   80022d <_panic>

008001d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	e8 e8 0b 00 00       	call   800dca <sys_getenvid>
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8001ea:	c1 e0 04             	shl    $0x4,%eax
  8001ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f7:	85 db                	test   %ebx,%ebx
  8001f9:	7e 07                	jle    800202 <libmain+0x30>
		binaryname = argv[0];
  8001fb:	8b 06                	mov    (%esi),%eax
  8001fd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	56                   	push   %esi
  800206:	53                   	push   %ebx
  800207:	e8 27 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80020c:	e8 0a 00 00 00       	call   80021b <exit>
}
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800217:	5b                   	pop    %ebx
  800218:	5e                   	pop    %esi
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    

0080021b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800221:	6a 00                	push   $0x0
  800223:	e8 61 0b 00 00       	call   800d89 <sys_env_destroy>
}
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	c9                   	leave  
  80022c:	c3                   	ret    

0080022d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	56                   	push   %esi
  800231:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800232:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800235:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80023b:	e8 8a 0b 00 00       	call   800dca <sys_getenvid>
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 0c             	pushl  0xc(%ebp)
  800246:	ff 75 08             	pushl  0x8(%ebp)
  800249:	56                   	push   %esi
  80024a:	50                   	push   %eax
  80024b:	68 58 25 80 00       	push   $0x802558
  800250:	e8 b3 00 00 00       	call   800308 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800255:	83 c4 18             	add    $0x18,%esp
  800258:	53                   	push   %ebx
  800259:	ff 75 10             	pushl  0x10(%ebp)
  80025c:	e8 56 00 00 00       	call   8002b7 <vcprintf>
	cprintf("\n");
  800261:	c7 04 24 13 2b 80 00 	movl   $0x802b13,(%esp)
  800268:	e8 9b 00 00 00       	call   800308 <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800270:	cc                   	int3   
  800271:	eb fd                	jmp    800270 <_panic+0x43>

00800273 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	53                   	push   %ebx
  800277:	83 ec 04             	sub    $0x4,%esp
  80027a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027d:	8b 13                	mov    (%ebx),%edx
  80027f:	8d 42 01             	lea    0x1(%edx),%eax
  800282:	89 03                	mov    %eax,(%ebx)
  800284:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800287:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800290:	74 09                	je     80029b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800292:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800299:	c9                   	leave  
  80029a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	68 ff 00 00 00       	push   $0xff
  8002a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a6:	50                   	push   %eax
  8002a7:	e8 a0 0a 00 00       	call   800d4c <sys_cputs>
		b->idx = 0;
  8002ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	eb db                	jmp    800292 <putch+0x1f>

008002b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c7:	00 00 00 
	b.cnt = 0;
  8002ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d4:	ff 75 0c             	pushl  0xc(%ebp)
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e0:	50                   	push   %eax
  8002e1:	68 73 02 80 00       	push   $0x800273
  8002e6:	e8 4a 01 00 00       	call   800435 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002eb:	83 c4 08             	add    $0x8,%esp
  8002ee:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002fa:	50                   	push   %eax
  8002fb:	e8 4c 0a 00 00       	call   800d4c <sys_cputs>

	return b.cnt;
}
  800300:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800311:	50                   	push   %eax
  800312:	ff 75 08             	pushl  0x8(%ebp)
  800315:	e8 9d ff ff ff       	call   8002b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	57                   	push   %edi
  800320:	56                   	push   %esi
  800321:	53                   	push   %ebx
  800322:	83 ec 1c             	sub    $0x1c,%esp
  800325:	89 c6                	mov    %eax,%esi
  800327:	89 d7                	mov    %edx,%edi
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800335:	8b 45 10             	mov    0x10(%ebp),%eax
  800338:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80033b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80033f:	74 2c                	je     80036d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800344:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80034b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800351:	39 c2                	cmp    %eax,%edx
  800353:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800356:	73 43                	jae    80039b <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800358:	83 eb 01             	sub    $0x1,%ebx
  80035b:	85 db                	test   %ebx,%ebx
  80035d:	7e 6c                	jle    8003cb <printnum+0xaf>
			putch(padc, putdat);
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	57                   	push   %edi
  800363:	ff 75 18             	pushl  0x18(%ebp)
  800366:	ff d6                	call   *%esi
  800368:	83 c4 10             	add    $0x10,%esp
  80036b:	eb eb                	jmp    800358 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	6a 20                	push   $0x20
  800372:	6a 00                	push   $0x0
  800374:	50                   	push   %eax
  800375:	ff 75 e4             	pushl  -0x1c(%ebp)
  800378:	ff 75 e0             	pushl  -0x20(%ebp)
  80037b:	89 fa                	mov    %edi,%edx
  80037d:	89 f0                	mov    %esi,%eax
  80037f:	e8 98 ff ff ff       	call   80031c <printnum>
		while (--width > 0)
  800384:	83 c4 20             	add    $0x20,%esp
  800387:	83 eb 01             	sub    $0x1,%ebx
  80038a:	85 db                	test   %ebx,%ebx
  80038c:	7e 65                	jle    8003f3 <printnum+0xd7>
			putch(padc, putdat);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	57                   	push   %edi
  800392:	6a 20                	push   $0x20
  800394:	ff d6                	call   *%esi
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	eb ec                	jmp    800387 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80039b:	83 ec 0c             	sub    $0xc,%esp
  80039e:	ff 75 18             	pushl  0x18(%ebp)
  8003a1:	83 eb 01             	sub    $0x1,%ebx
  8003a4:	53                   	push   %ebx
  8003a5:	50                   	push   %eax
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8003af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b5:	e8 66 1e 00 00       	call   802220 <__udivdi3>
  8003ba:	83 c4 18             	add    $0x18,%esp
  8003bd:	52                   	push   %edx
  8003be:	50                   	push   %eax
  8003bf:	89 fa                	mov    %edi,%edx
  8003c1:	89 f0                	mov    %esi,%eax
  8003c3:	e8 54 ff ff ff       	call   80031c <printnum>
  8003c8:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	57                   	push   %edi
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	ff 75 e0             	pushl  -0x20(%ebp)
  8003de:	e8 4d 1f 00 00       	call   802330 <__umoddi3>
  8003e3:	83 c4 14             	add    $0x14,%esp
  8003e6:	0f be 80 7b 25 80 00 	movsbl 0x80257b(%eax),%eax
  8003ed:	50                   	push   %eax
  8003ee:	ff d6                	call   *%esi
  8003f0:	83 c4 10             	add    $0x10,%esp
}
  8003f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f6:	5b                   	pop    %ebx
  8003f7:	5e                   	pop    %esi
  8003f8:	5f                   	pop    %edi
  8003f9:	5d                   	pop    %ebp
  8003fa:	c3                   	ret    

008003fb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800401:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800405:	8b 10                	mov    (%eax),%edx
  800407:	3b 50 04             	cmp    0x4(%eax),%edx
  80040a:	73 0a                	jae    800416 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80040f:	89 08                	mov    %ecx,(%eax)
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	88 02                	mov    %al,(%edx)
}
  800416:	5d                   	pop    %ebp
  800417:	c3                   	ret    

00800418 <printfmt>:
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80041e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800421:	50                   	push   %eax
  800422:	ff 75 10             	pushl  0x10(%ebp)
  800425:	ff 75 0c             	pushl  0xc(%ebp)
  800428:	ff 75 08             	pushl  0x8(%ebp)
  80042b:	e8 05 00 00 00       	call   800435 <vprintfmt>
}
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	c9                   	leave  
  800434:	c3                   	ret    

00800435 <vprintfmt>:
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	57                   	push   %edi
  800439:	56                   	push   %esi
  80043a:	53                   	push   %ebx
  80043b:	83 ec 3c             	sub    $0x3c,%esp
  80043e:	8b 75 08             	mov    0x8(%ebp),%esi
  800441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800444:	8b 7d 10             	mov    0x10(%ebp),%edi
  800447:	e9 b4 03 00 00       	jmp    800800 <vprintfmt+0x3cb>
		padc = ' ';
  80044c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800450:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800457:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80045e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800465:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80046c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800471:	8d 47 01             	lea    0x1(%edi),%eax
  800474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800477:	0f b6 17             	movzbl (%edi),%edx
  80047a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80047d:	3c 55                	cmp    $0x55,%al
  80047f:	0f 87 c8 04 00 00    	ja     80094d <vprintfmt+0x518>
  800485:	0f b6 c0             	movzbl %al,%eax
  800488:	ff 24 85 60 27 80 00 	jmp    *0x802760(,%eax,4)
  80048f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800492:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800499:	eb d6                	jmp    800471 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80049e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004a2:	eb cd                	jmp    800471 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8004a4:	0f b6 d2             	movzbl %dl,%edx
  8004a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004af:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8004b2:	eb 0c                	jmp    8004c0 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8004b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004b7:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8004bb:	eb b4                	jmp    800471 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8004bd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004c3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ca:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004cd:	83 f9 09             	cmp    $0x9,%ecx
  8004d0:	76 eb                	jbe    8004bd <vprintfmt+0x88>
  8004d2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d8:	eb 14                	jmp    8004ee <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	8d 40 04             	lea    0x4(%eax),%eax
  8004e8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f2:	0f 89 79 ff ff ff    	jns    800471 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800505:	e9 67 ff ff ff       	jmp    800471 <vprintfmt+0x3c>
  80050a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80050d:	85 c0                	test   %eax,%eax
  80050f:	ba 00 00 00 00       	mov    $0x0,%edx
  800514:	0f 49 d0             	cmovns %eax,%edx
  800517:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80051d:	e9 4f ff ff ff       	jmp    800471 <vprintfmt+0x3c>
  800522:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800525:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80052c:	e9 40 ff ff ff       	jmp    800471 <vprintfmt+0x3c>
			lflag++;
  800531:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800537:	e9 35 ff ff ff       	jmp    800471 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8d 78 04             	lea    0x4(%eax),%edi
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	ff 30                	pushl  (%eax)
  800548:	ff d6                	call   *%esi
			break;
  80054a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80054d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800550:	e9 a8 02 00 00       	jmp    8007fd <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8d 78 04             	lea    0x4(%eax),%edi
  80055b:	8b 00                	mov    (%eax),%eax
  80055d:	99                   	cltd   
  80055e:	31 d0                	xor    %edx,%eax
  800560:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800562:	83 f8 0f             	cmp    $0xf,%eax
  800565:	7f 23                	jg     80058a <vprintfmt+0x155>
  800567:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  80056e:	85 d2                	test   %edx,%edx
  800570:	74 18                	je     80058a <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800572:	52                   	push   %edx
  800573:	68 e1 2a 80 00       	push   $0x802ae1
  800578:	53                   	push   %ebx
  800579:	56                   	push   %esi
  80057a:	e8 99 fe ff ff       	call   800418 <printfmt>
  80057f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800582:	89 7d 14             	mov    %edi,0x14(%ebp)
  800585:	e9 73 02 00 00       	jmp    8007fd <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80058a:	50                   	push   %eax
  80058b:	68 93 25 80 00       	push   $0x802593
  800590:	53                   	push   %ebx
  800591:	56                   	push   %esi
  800592:	e8 81 fe ff ff       	call   800418 <printfmt>
  800597:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80059a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80059d:	e9 5b 02 00 00       	jmp    8007fd <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	83 c0 04             	add    $0x4,%eax
  8005a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005b0:	85 d2                	test   %edx,%edx
  8005b2:	b8 8c 25 80 00       	mov    $0x80258c,%eax
  8005b7:	0f 45 c2             	cmovne %edx,%eax
  8005ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c1:	7e 06                	jle    8005c9 <vprintfmt+0x194>
  8005c3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005c7:	75 0d                	jne    8005d6 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005cc:	89 c7                	mov    %eax,%edi
  8005ce:	03 45 e0             	add    -0x20(%ebp),%eax
  8005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d4:	eb 53                	jmp    800629 <vprintfmt+0x1f4>
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8005dc:	50                   	push   %eax
  8005dd:	e8 13 04 00 00       	call   8009f5 <strnlen>
  8005e2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e5:	29 c1                	sub    %eax,%ecx
  8005e7:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005ef:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f6:	eb 0f                	jmp    800607 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	53                   	push   %ebx
  8005fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ff:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800601:	83 ef 01             	sub    $0x1,%edi
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	85 ff                	test   %edi,%edi
  800609:	7f ed                	jg     8005f8 <vprintfmt+0x1c3>
  80060b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80060e:	85 d2                	test   %edx,%edx
  800610:	b8 00 00 00 00       	mov    $0x0,%eax
  800615:	0f 49 c2             	cmovns %edx,%eax
  800618:	29 c2                	sub    %eax,%edx
  80061a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80061d:	eb aa                	jmp    8005c9 <vprintfmt+0x194>
					putch(ch, putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	53                   	push   %ebx
  800623:	52                   	push   %edx
  800624:	ff d6                	call   *%esi
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80062c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062e:	83 c7 01             	add    $0x1,%edi
  800631:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800635:	0f be d0             	movsbl %al,%edx
  800638:	85 d2                	test   %edx,%edx
  80063a:	74 4b                	je     800687 <vprintfmt+0x252>
  80063c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800640:	78 06                	js     800648 <vprintfmt+0x213>
  800642:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800646:	78 1e                	js     800666 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800648:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80064c:	74 d1                	je     80061f <vprintfmt+0x1ea>
  80064e:	0f be c0             	movsbl %al,%eax
  800651:	83 e8 20             	sub    $0x20,%eax
  800654:	83 f8 5e             	cmp    $0x5e,%eax
  800657:	76 c6                	jbe    80061f <vprintfmt+0x1ea>
					putch('?', putdat);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	53                   	push   %ebx
  80065d:	6a 3f                	push   $0x3f
  80065f:	ff d6                	call   *%esi
  800661:	83 c4 10             	add    $0x10,%esp
  800664:	eb c3                	jmp    800629 <vprintfmt+0x1f4>
  800666:	89 cf                	mov    %ecx,%edi
  800668:	eb 0e                	jmp    800678 <vprintfmt+0x243>
				putch(' ', putdat);
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	53                   	push   %ebx
  80066e:	6a 20                	push   $0x20
  800670:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800672:	83 ef 01             	sub    $0x1,%edi
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	85 ff                	test   %edi,%edi
  80067a:	7f ee                	jg     80066a <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80067c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
  800682:	e9 76 01 00 00       	jmp    8007fd <vprintfmt+0x3c8>
  800687:	89 cf                	mov    %ecx,%edi
  800689:	eb ed                	jmp    800678 <vprintfmt+0x243>
	if (lflag >= 2)
  80068b:	83 f9 01             	cmp    $0x1,%ecx
  80068e:	7f 1f                	jg     8006af <vprintfmt+0x27a>
	else if (lflag)
  800690:	85 c9                	test   %ecx,%ecx
  800692:	74 6a                	je     8006fe <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069c:	89 c1                	mov    %eax,%ecx
  80069e:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ad:	eb 17                	jmp    8006c6 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 50 04             	mov    0x4(%eax),%edx
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8d 40 08             	lea    0x8(%eax),%eax
  8006c3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8006c9:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006ce:	85 d2                	test   %edx,%edx
  8006d0:	0f 89 f8 00 00 00    	jns    8007ce <vprintfmt+0x399>
				putch('-', putdat);
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	53                   	push   %ebx
  8006da:	6a 2d                	push   $0x2d
  8006dc:	ff d6                	call   *%esi
				num = -(long long) num;
  8006de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006e4:	f7 d8                	neg    %eax
  8006e6:	83 d2 00             	adc    $0x0,%edx
  8006e9:	f7 da                	neg    %edx
  8006eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006f4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006f9:	e9 e1 00 00 00       	jmp    8007df <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800706:	99                   	cltd   
  800707:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8d 40 04             	lea    0x4(%eax),%eax
  800710:	89 45 14             	mov    %eax,0x14(%ebp)
  800713:	eb b1                	jmp    8006c6 <vprintfmt+0x291>
	if (lflag >= 2)
  800715:	83 f9 01             	cmp    $0x1,%ecx
  800718:	7f 27                	jg     800741 <vprintfmt+0x30c>
	else if (lflag)
  80071a:	85 c9                	test   %ecx,%ecx
  80071c:	74 41                	je     80075f <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800737:	bf 0a 00 00 00       	mov    $0xa,%edi
  80073c:	e9 8d 00 00 00       	jmp    8007ce <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 50 04             	mov    0x4(%eax),%edx
  800747:	8b 00                	mov    (%eax),%eax
  800749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 08             	lea    0x8(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800758:	bf 0a 00 00 00       	mov    $0xa,%edi
  80075d:	eb 6f                	jmp    8007ce <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	ba 00 00 00 00       	mov    $0x0,%edx
  800769:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 40 04             	lea    0x4(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800778:	bf 0a 00 00 00       	mov    $0xa,%edi
  80077d:	eb 4f                	jmp    8007ce <vprintfmt+0x399>
	if (lflag >= 2)
  80077f:	83 f9 01             	cmp    $0x1,%ecx
  800782:	7f 23                	jg     8007a7 <vprintfmt+0x372>
	else if (lflag)
  800784:	85 c9                	test   %ecx,%ecx
  800786:	0f 84 98 00 00 00    	je     800824 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	ba 00 00 00 00       	mov    $0x0,%edx
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8d 40 04             	lea    0x4(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a5:	eb 17                	jmp    8007be <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8b 50 04             	mov    0x4(%eax),%edx
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 40 08             	lea    0x8(%eax),%eax
  8007bb:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	6a 30                	push   $0x30
  8007c4:	ff d6                	call   *%esi
			goto number;
  8007c6:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007c9:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8007ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007d2:	74 0b                	je     8007df <vprintfmt+0x3aa>
				putch('+', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	53                   	push   %ebx
  8007d8:	6a 2b                	push   $0x2b
  8007da:	ff d6                	call   *%esi
  8007dc:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8007df:	83 ec 0c             	sub    $0xc,%esp
  8007e2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ea:	57                   	push   %edi
  8007eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8007ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f1:	89 da                	mov    %ebx,%edx
  8007f3:	89 f0                	mov    %esi,%eax
  8007f5:	e8 22 fb ff ff       	call   80031c <printnum>
			break;
  8007fa:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	83 c7 01             	add    $0x1,%edi
  800803:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800807:	83 f8 25             	cmp    $0x25,%eax
  80080a:	0f 84 3c fc ff ff    	je     80044c <vprintfmt+0x17>
			if (ch == '\0')
  800810:	85 c0                	test   %eax,%eax
  800812:	0f 84 55 01 00 00    	je     80096d <vprintfmt+0x538>
			putch(ch, putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	50                   	push   %eax
  80081d:	ff d6                	call   *%esi
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	eb dc                	jmp    800800 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	ba 00 00 00 00       	mov    $0x0,%edx
  80082e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800831:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8d 40 04             	lea    0x4(%eax),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
  80083d:	e9 7c ff ff ff       	jmp    8007be <vprintfmt+0x389>
			putch('0', putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	6a 30                	push   $0x30
  800848:	ff d6                	call   *%esi
			putch('x', putdat);
  80084a:	83 c4 08             	add    $0x8,%esp
  80084d:	53                   	push   %ebx
  80084e:	6a 78                	push   $0x78
  800850:	ff d6                	call   *%esi
			num = (unsigned long long)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	ba 00 00 00 00       	mov    $0x0,%edx
  80085c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800862:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 40 04             	lea    0x4(%eax),%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80086e:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800873:	e9 56 ff ff ff       	jmp    8007ce <vprintfmt+0x399>
	if (lflag >= 2)
  800878:	83 f9 01             	cmp    $0x1,%ecx
  80087b:	7f 27                	jg     8008a4 <vprintfmt+0x46f>
	else if (lflag)
  80087d:	85 c9                	test   %ecx,%ecx
  80087f:	74 44                	je     8008c5 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	ba 00 00 00 00       	mov    $0x0,%edx
  80088b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8d 40 04             	lea    0x4(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089a:	bf 10 00 00 00       	mov    $0x10,%edi
  80089f:	e9 2a ff ff ff       	jmp    8007ce <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	8b 50 04             	mov    0x4(%eax),%edx
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 40 08             	lea    0x8(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008bb:	bf 10 00 00 00       	mov    $0x10,%edi
  8008c0:	e9 09 ff ff ff       	jmp    8007ce <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	8d 40 04             	lea    0x4(%eax),%eax
  8008db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008de:	bf 10 00 00 00       	mov    $0x10,%edi
  8008e3:	e9 e6 fe ff ff       	jmp    8007ce <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	8d 78 04             	lea    0x4(%eax),%edi
  8008ee:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	74 2d                	je     800921 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8008f4:	0f b6 13             	movzbl (%ebx),%edx
  8008f7:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008f9:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8008fc:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8008ff:	0f 8e f8 fe ff ff    	jle    8007fd <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800905:	68 e8 26 80 00       	push   $0x8026e8
  80090a:	68 e1 2a 80 00       	push   $0x802ae1
  80090f:	53                   	push   %ebx
  800910:	56                   	push   %esi
  800911:	e8 02 fb ff ff       	call   800418 <printfmt>
  800916:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800919:	89 7d 14             	mov    %edi,0x14(%ebp)
  80091c:	e9 dc fe ff ff       	jmp    8007fd <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800921:	68 b0 26 80 00       	push   $0x8026b0
  800926:	68 e1 2a 80 00       	push   $0x802ae1
  80092b:	53                   	push   %ebx
  80092c:	56                   	push   %esi
  80092d:	e8 e6 fa ff ff       	call   800418 <printfmt>
  800932:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800935:	89 7d 14             	mov    %edi,0x14(%ebp)
  800938:	e9 c0 fe ff ff       	jmp    8007fd <vprintfmt+0x3c8>
			putch(ch, putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	53                   	push   %ebx
  800941:	6a 25                	push   $0x25
  800943:	ff d6                	call   *%esi
			break;
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	e9 b0 fe ff ff       	jmp    8007fd <vprintfmt+0x3c8>
			putch('%', putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	53                   	push   %ebx
  800951:	6a 25                	push   $0x25
  800953:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	89 f8                	mov    %edi,%eax
  80095a:	eb 03                	jmp    80095f <vprintfmt+0x52a>
  80095c:	83 e8 01             	sub    $0x1,%eax
  80095f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800963:	75 f7                	jne    80095c <vprintfmt+0x527>
  800965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800968:	e9 90 fe ff ff       	jmp    8007fd <vprintfmt+0x3c8>
}
  80096d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800970:	5b                   	pop    %ebx
  800971:	5e                   	pop    %esi
  800972:	5f                   	pop    %edi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 18             	sub    $0x18,%esp
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800984:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800988:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80098b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800992:	85 c0                	test   %eax,%eax
  800994:	74 26                	je     8009bc <vsnprintf+0x47>
  800996:	85 d2                	test   %edx,%edx
  800998:	7e 22                	jle    8009bc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80099a:	ff 75 14             	pushl  0x14(%ebp)
  80099d:	ff 75 10             	pushl  0x10(%ebp)
  8009a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	68 fb 03 80 00       	push   $0x8003fb
  8009a9:	e8 87 fa ff ff       	call   800435 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b7:	83 c4 10             	add    $0x10,%esp
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    
		return -E_INVAL;
  8009bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c1:	eb f7                	jmp    8009ba <vsnprintf+0x45>

008009c3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009cc:	50                   	push   %eax
  8009cd:	ff 75 10             	pushl  0x10(%ebp)
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	ff 75 08             	pushl  0x8(%ebp)
  8009d6:	e8 9a ff ff ff       	call   800975 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009db:	c9                   	leave  
  8009dc:	c3                   	ret    

008009dd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ec:	74 05                	je     8009f3 <strlen+0x16>
		n++;
  8009ee:	83 c0 01             	add    $0x1,%eax
  8009f1:	eb f5                	jmp    8009e8 <strlen+0xb>
	return n;
}
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 0d                	je     800a14 <strnlen+0x1f>
  800a07:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a0b:	74 05                	je     800a12 <strnlen+0x1d>
		n++;
  800a0d:	83 c2 01             	add    $0x1,%edx
  800a10:	eb f1                	jmp    800a03 <strnlen+0xe>
  800a12:	89 d0                	mov    %edx,%eax
	return n;
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a20:	ba 00 00 00 00       	mov    $0x0,%edx
  800a25:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a29:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a2c:	83 c2 01             	add    $0x1,%edx
  800a2f:	84 c9                	test   %cl,%cl
  800a31:	75 f2                	jne    800a25 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a33:	5b                   	pop    %ebx
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	53                   	push   %ebx
  800a3a:	83 ec 10             	sub    $0x10,%esp
  800a3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a40:	53                   	push   %ebx
  800a41:	e8 97 ff ff ff       	call   8009dd <strlen>
  800a46:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	01 d8                	add    %ebx,%eax
  800a4e:	50                   	push   %eax
  800a4f:	e8 c2 ff ff ff       	call   800a16 <strcpy>
	return dst;
}
  800a54:	89 d8                	mov    %ebx,%eax
  800a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	56                   	push   %esi
  800a5f:	53                   	push   %ebx
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a66:	89 c6                	mov    %eax,%esi
  800a68:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6b:	89 c2                	mov    %eax,%edx
  800a6d:	39 f2                	cmp    %esi,%edx
  800a6f:	74 11                	je     800a82 <strncpy+0x27>
		*dst++ = *src;
  800a71:	83 c2 01             	add    $0x1,%edx
  800a74:	0f b6 19             	movzbl (%ecx),%ebx
  800a77:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a7a:	80 fb 01             	cmp    $0x1,%bl
  800a7d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a80:	eb eb                	jmp    800a6d <strncpy+0x12>
	}
	return ret;
}
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	56                   	push   %esi
  800a8a:	53                   	push   %ebx
  800a8b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a91:	8b 55 10             	mov    0x10(%ebp),%edx
  800a94:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a96:	85 d2                	test   %edx,%edx
  800a98:	74 21                	je     800abb <strlcpy+0x35>
  800a9a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a9e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800aa0:	39 c2                	cmp    %eax,%edx
  800aa2:	74 14                	je     800ab8 <strlcpy+0x32>
  800aa4:	0f b6 19             	movzbl (%ecx),%ebx
  800aa7:	84 db                	test   %bl,%bl
  800aa9:	74 0b                	je     800ab6 <strlcpy+0x30>
			*dst++ = *src++;
  800aab:	83 c1 01             	add    $0x1,%ecx
  800aae:	83 c2 01             	add    $0x1,%edx
  800ab1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab4:	eb ea                	jmp    800aa0 <strlcpy+0x1a>
  800ab6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ab8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800abb:	29 f0                	sub    %esi,%eax
}
  800abd:	5b                   	pop    %ebx
  800abe:	5e                   	pop    %esi
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aca:	0f b6 01             	movzbl (%ecx),%eax
  800acd:	84 c0                	test   %al,%al
  800acf:	74 0c                	je     800add <strcmp+0x1c>
  800ad1:	3a 02                	cmp    (%edx),%al
  800ad3:	75 08                	jne    800add <strcmp+0x1c>
		p++, q++;
  800ad5:	83 c1 01             	add    $0x1,%ecx
  800ad8:	83 c2 01             	add    $0x1,%edx
  800adb:	eb ed                	jmp    800aca <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800add:	0f b6 c0             	movzbl %al,%eax
  800ae0:	0f b6 12             	movzbl (%edx),%edx
  800ae3:	29 d0                	sub    %edx,%eax
}
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	89 c3                	mov    %eax,%ebx
  800af3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800af6:	eb 06                	jmp    800afe <strncmp+0x17>
		n--, p++, q++;
  800af8:	83 c0 01             	add    $0x1,%eax
  800afb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800afe:	39 d8                	cmp    %ebx,%eax
  800b00:	74 16                	je     800b18 <strncmp+0x31>
  800b02:	0f b6 08             	movzbl (%eax),%ecx
  800b05:	84 c9                	test   %cl,%cl
  800b07:	74 04                	je     800b0d <strncmp+0x26>
  800b09:	3a 0a                	cmp    (%edx),%cl
  800b0b:	74 eb                	je     800af8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0d:	0f b6 00             	movzbl (%eax),%eax
  800b10:	0f b6 12             	movzbl (%edx),%edx
  800b13:	29 d0                	sub    %edx,%eax
}
  800b15:	5b                   	pop    %ebx
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    
		return 0;
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1d:	eb f6                	jmp    800b15 <strncmp+0x2e>

00800b1f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b29:	0f b6 10             	movzbl (%eax),%edx
  800b2c:	84 d2                	test   %dl,%dl
  800b2e:	74 09                	je     800b39 <strchr+0x1a>
		if (*s == c)
  800b30:	38 ca                	cmp    %cl,%dl
  800b32:	74 0a                	je     800b3e <strchr+0x1f>
	for (; *s; s++)
  800b34:	83 c0 01             	add    $0x1,%eax
  800b37:	eb f0                	jmp    800b29 <strchr+0xa>
			return (char *) s;
	return 0;
  800b39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b4a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b4d:	38 ca                	cmp    %cl,%dl
  800b4f:	74 09                	je     800b5a <strfind+0x1a>
  800b51:	84 d2                	test   %dl,%dl
  800b53:	74 05                	je     800b5a <strfind+0x1a>
	for (; *s; s++)
  800b55:	83 c0 01             	add    $0x1,%eax
  800b58:	eb f0                	jmp    800b4a <strfind+0xa>
			break;
	return (char *) s;
}
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	57                   	push   %edi
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b65:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b68:	85 c9                	test   %ecx,%ecx
  800b6a:	74 31                	je     800b9d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b6c:	89 f8                	mov    %edi,%eax
  800b6e:	09 c8                	or     %ecx,%eax
  800b70:	a8 03                	test   $0x3,%al
  800b72:	75 23                	jne    800b97 <memset+0x3b>
		c &= 0xFF;
  800b74:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b78:	89 d3                	mov    %edx,%ebx
  800b7a:	c1 e3 08             	shl    $0x8,%ebx
  800b7d:	89 d0                	mov    %edx,%eax
  800b7f:	c1 e0 18             	shl    $0x18,%eax
  800b82:	89 d6                	mov    %edx,%esi
  800b84:	c1 e6 10             	shl    $0x10,%esi
  800b87:	09 f0                	or     %esi,%eax
  800b89:	09 c2                	or     %eax,%edx
  800b8b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b8d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b90:	89 d0                	mov    %edx,%eax
  800b92:	fc                   	cld    
  800b93:	f3 ab                	rep stos %eax,%es:(%edi)
  800b95:	eb 06                	jmp    800b9d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9a:	fc                   	cld    
  800b9b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b9d:	89 f8                	mov    %edi,%eax
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	57                   	push   %edi
  800ba8:	56                   	push   %esi
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 75 0c             	mov    0xc(%ebp),%esi
  800baf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb2:	39 c6                	cmp    %eax,%esi
  800bb4:	73 32                	jae    800be8 <memmove+0x44>
  800bb6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb9:	39 c2                	cmp    %eax,%edx
  800bbb:	76 2b                	jbe    800be8 <memmove+0x44>
		s += n;
		d += n;
  800bbd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc0:	89 fe                	mov    %edi,%esi
  800bc2:	09 ce                	or     %ecx,%esi
  800bc4:	09 d6                	or     %edx,%esi
  800bc6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bcc:	75 0e                	jne    800bdc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bce:	83 ef 04             	sub    $0x4,%edi
  800bd1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bd7:	fd                   	std    
  800bd8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bda:	eb 09                	jmp    800be5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bdc:	83 ef 01             	sub    $0x1,%edi
  800bdf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be2:	fd                   	std    
  800be3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be5:	fc                   	cld    
  800be6:	eb 1a                	jmp    800c02 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be8:	89 c2                	mov    %eax,%edx
  800bea:	09 ca                	or     %ecx,%edx
  800bec:	09 f2                	or     %esi,%edx
  800bee:	f6 c2 03             	test   $0x3,%dl
  800bf1:	75 0a                	jne    800bfd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bf3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bf6:	89 c7                	mov    %eax,%edi
  800bf8:	fc                   	cld    
  800bf9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bfb:	eb 05                	jmp    800c02 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bfd:	89 c7                	mov    %eax,%edi
  800bff:	fc                   	cld    
  800c00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c02:	5e                   	pop    %esi
  800c03:	5f                   	pop    %edi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c0c:	ff 75 10             	pushl  0x10(%ebp)
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	ff 75 08             	pushl  0x8(%ebp)
  800c15:	e8 8a ff ff ff       	call   800ba4 <memmove>
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c27:	89 c6                	mov    %eax,%esi
  800c29:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c2c:	39 f0                	cmp    %esi,%eax
  800c2e:	74 1c                	je     800c4c <memcmp+0x30>
		if (*s1 != *s2)
  800c30:	0f b6 08             	movzbl (%eax),%ecx
  800c33:	0f b6 1a             	movzbl (%edx),%ebx
  800c36:	38 d9                	cmp    %bl,%cl
  800c38:	75 08                	jne    800c42 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c3a:	83 c0 01             	add    $0x1,%eax
  800c3d:	83 c2 01             	add    $0x1,%edx
  800c40:	eb ea                	jmp    800c2c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c42:	0f b6 c1             	movzbl %cl,%eax
  800c45:	0f b6 db             	movzbl %bl,%ebx
  800c48:	29 d8                	sub    %ebx,%eax
  800c4a:	eb 05                	jmp    800c51 <memcmp+0x35>
	}

	return 0;
  800c4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c5e:	89 c2                	mov    %eax,%edx
  800c60:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c63:	39 d0                	cmp    %edx,%eax
  800c65:	73 09                	jae    800c70 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c67:	38 08                	cmp    %cl,(%eax)
  800c69:	74 05                	je     800c70 <memfind+0x1b>
	for (; s < ends; s++)
  800c6b:	83 c0 01             	add    $0x1,%eax
  800c6e:	eb f3                	jmp    800c63 <memfind+0xe>
			break;
	return (void *) s;
}
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7e:	eb 03                	jmp    800c83 <strtol+0x11>
		s++;
  800c80:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c83:	0f b6 01             	movzbl (%ecx),%eax
  800c86:	3c 20                	cmp    $0x20,%al
  800c88:	74 f6                	je     800c80 <strtol+0xe>
  800c8a:	3c 09                	cmp    $0x9,%al
  800c8c:	74 f2                	je     800c80 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c8e:	3c 2b                	cmp    $0x2b,%al
  800c90:	74 2a                	je     800cbc <strtol+0x4a>
	int neg = 0;
  800c92:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c97:	3c 2d                	cmp    $0x2d,%al
  800c99:	74 2b                	je     800cc6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ca1:	75 0f                	jne    800cb2 <strtol+0x40>
  800ca3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ca6:	74 28                	je     800cd0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ca8:	85 db                	test   %ebx,%ebx
  800caa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800caf:	0f 44 d8             	cmove  %eax,%ebx
  800cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cba:	eb 50                	jmp    800d0c <strtol+0x9a>
		s++;
  800cbc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cbf:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc4:	eb d5                	jmp    800c9b <strtol+0x29>
		s++, neg = 1;
  800cc6:	83 c1 01             	add    $0x1,%ecx
  800cc9:	bf 01 00 00 00       	mov    $0x1,%edi
  800cce:	eb cb                	jmp    800c9b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cd4:	74 0e                	je     800ce4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cd6:	85 db                	test   %ebx,%ebx
  800cd8:	75 d8                	jne    800cb2 <strtol+0x40>
		s++, base = 8;
  800cda:	83 c1 01             	add    $0x1,%ecx
  800cdd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ce2:	eb ce                	jmp    800cb2 <strtol+0x40>
		s += 2, base = 16;
  800ce4:	83 c1 02             	add    $0x2,%ecx
  800ce7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cec:	eb c4                	jmp    800cb2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cee:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cf1:	89 f3                	mov    %esi,%ebx
  800cf3:	80 fb 19             	cmp    $0x19,%bl
  800cf6:	77 29                	ja     800d21 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cf8:	0f be d2             	movsbl %dl,%edx
  800cfb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cfe:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d01:	7d 30                	jge    800d33 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d03:	83 c1 01             	add    $0x1,%ecx
  800d06:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d0a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d0c:	0f b6 11             	movzbl (%ecx),%edx
  800d0f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d12:	89 f3                	mov    %esi,%ebx
  800d14:	80 fb 09             	cmp    $0x9,%bl
  800d17:	77 d5                	ja     800cee <strtol+0x7c>
			dig = *s - '0';
  800d19:	0f be d2             	movsbl %dl,%edx
  800d1c:	83 ea 30             	sub    $0x30,%edx
  800d1f:	eb dd                	jmp    800cfe <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d21:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d24:	89 f3                	mov    %esi,%ebx
  800d26:	80 fb 19             	cmp    $0x19,%bl
  800d29:	77 08                	ja     800d33 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d2b:	0f be d2             	movsbl %dl,%edx
  800d2e:	83 ea 37             	sub    $0x37,%edx
  800d31:	eb cb                	jmp    800cfe <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d37:	74 05                	je     800d3e <strtol+0xcc>
		*endptr = (char *) s;
  800d39:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d3e:	89 c2                	mov    %eax,%edx
  800d40:	f7 da                	neg    %edx
  800d42:	85 ff                	test   %edi,%edi
  800d44:	0f 45 c2             	cmovne %edx,%eax
}
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	57                   	push   %edi
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d52:	b8 00 00 00 00       	mov    $0x0,%eax
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	89 c3                	mov    %eax,%ebx
  800d5f:	89 c7                	mov    %eax,%edi
  800d61:	89 c6                	mov    %eax,%esi
  800d63:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d70:	ba 00 00 00 00       	mov    $0x0,%edx
  800d75:	b8 01 00 00 00       	mov    $0x1,%eax
  800d7a:	89 d1                	mov    %edx,%ecx
  800d7c:	89 d3                	mov    %edx,%ebx
  800d7e:	89 d7                	mov    %edx,%edi
  800d80:	89 d6                	mov    %edx,%esi
  800d82:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d97:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d9f:	89 cb                	mov    %ecx,%ebx
  800da1:	89 cf                	mov    %ecx,%edi
  800da3:	89 ce                	mov    %ecx,%esi
  800da5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	7f 08                	jg     800db3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	50                   	push   %eax
  800db7:	6a 03                	push   $0x3
  800db9:	68 00 29 80 00       	push   $0x802900
  800dbe:	6a 33                	push   $0x33
  800dc0:	68 1d 29 80 00       	push   $0x80291d
  800dc5:	e8 63 f4 ff ff       	call   80022d <_panic>

00800dca <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	b8 02 00 00 00       	mov    $0x2,%eax
  800dda:	89 d1                	mov    %edx,%ecx
  800ddc:	89 d3                	mov    %edx,%ebx
  800dde:	89 d7                	mov    %edx,%edi
  800de0:	89 d6                	mov    %edx,%esi
  800de2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <sys_yield>:

void
sys_yield(void)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800def:	ba 00 00 00 00       	mov    $0x0,%edx
  800df4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df9:	89 d1                	mov    %edx,%ecx
  800dfb:	89 d3                	mov    %edx,%ebx
  800dfd:	89 d7                	mov    %edx,%edi
  800dff:	89 d6                	mov    %edx,%esi
  800e01:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e03:	5b                   	pop    %ebx
  800e04:	5e                   	pop    %esi
  800e05:	5f                   	pop    %edi
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	57                   	push   %edi
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e11:	be 00 00 00 00       	mov    $0x0,%esi
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	b8 04 00 00 00       	mov    $0x4,%eax
  800e21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e24:	89 f7                	mov    %esi,%edi
  800e26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	7f 08                	jg     800e34 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	50                   	push   %eax
  800e38:	6a 04                	push   $0x4
  800e3a:	68 00 29 80 00       	push   $0x802900
  800e3f:	6a 33                	push   $0x33
  800e41:	68 1d 29 80 00       	push   $0x80291d
  800e46:	e8 e2 f3 ff ff       	call   80022d <_panic>

00800e4b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e62:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e65:	8b 75 18             	mov    0x18(%ebp),%esi
  800e68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7f 08                	jg     800e76 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	83 ec 0c             	sub    $0xc,%esp
  800e79:	50                   	push   %eax
  800e7a:	6a 05                	push   $0x5
  800e7c:	68 00 29 80 00       	push   $0x802900
  800e81:	6a 33                	push   $0x33
  800e83:	68 1d 29 80 00       	push   $0x80291d
  800e88:	e8 a0 f3 ff ff       	call   80022d <_panic>

00800e8d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea1:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7f 08                	jg     800eb8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb8:	83 ec 0c             	sub    $0xc,%esp
  800ebb:	50                   	push   %eax
  800ebc:	6a 06                	push   $0x6
  800ebe:	68 00 29 80 00       	push   $0x802900
  800ec3:	6a 33                	push   $0x33
  800ec5:	68 1d 29 80 00       	push   $0x80291d
  800eca:	e8 5e f3 ff ff       	call   80022d <_panic>

00800ecf <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ee5:	89 cb                	mov    %ecx,%ebx
  800ee7:	89 cf                	mov    %ecx,%edi
  800ee9:	89 ce                	mov    %ecx,%esi
  800eeb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eed:	85 c0                	test   %eax,%eax
  800eef:	7f 08                	jg     800ef9 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef9:	83 ec 0c             	sub    $0xc,%esp
  800efc:	50                   	push   %eax
  800efd:	6a 0b                	push   $0xb
  800eff:	68 00 29 80 00       	push   $0x802900
  800f04:	6a 33                	push   $0x33
  800f06:	68 1d 29 80 00       	push   $0x80291d
  800f0b:	e8 1d f3 ff ff       	call   80022d <_panic>

00800f10 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
  800f16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	b8 08 00 00 00       	mov    $0x8,%eax
  800f29:	89 df                	mov    %ebx,%edi
  800f2b:	89 de                	mov    %ebx,%esi
  800f2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	7f 08                	jg     800f3b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5f                   	pop    %edi
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3b:	83 ec 0c             	sub    $0xc,%esp
  800f3e:	50                   	push   %eax
  800f3f:	6a 08                	push   $0x8
  800f41:	68 00 29 80 00       	push   $0x802900
  800f46:	6a 33                	push   $0x33
  800f48:	68 1d 29 80 00       	push   $0x80291d
  800f4d:	e8 db f2 ff ff       	call   80022d <_panic>

00800f52 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
  800f58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	b8 09 00 00 00       	mov    $0x9,%eax
  800f6b:	89 df                	mov    %ebx,%edi
  800f6d:	89 de                	mov    %ebx,%esi
  800f6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	7f 08                	jg     800f7d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f78:	5b                   	pop    %ebx
  800f79:	5e                   	pop    %esi
  800f7a:	5f                   	pop    %edi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7d:	83 ec 0c             	sub    $0xc,%esp
  800f80:	50                   	push   %eax
  800f81:	6a 09                	push   $0x9
  800f83:	68 00 29 80 00       	push   $0x802900
  800f88:	6a 33                	push   $0x33
  800f8a:	68 1d 29 80 00       	push   $0x80291d
  800f8f:	e8 99 f2 ff ff       	call   80022d <_panic>

00800f94 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
  800f9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fad:	89 df                	mov    %ebx,%edi
  800faf:	89 de                	mov    %ebx,%esi
  800fb1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	7f 08                	jg     800fbf <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fba:	5b                   	pop    %ebx
  800fbb:	5e                   	pop    %esi
  800fbc:	5f                   	pop    %edi
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	50                   	push   %eax
  800fc3:	6a 0a                	push   $0xa
  800fc5:	68 00 29 80 00       	push   $0x802900
  800fca:	6a 33                	push   $0x33
  800fcc:	68 1d 29 80 00       	push   $0x80291d
  800fd1:	e8 57 f2 ff ff       	call   80022d <_panic>

00800fd6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	57                   	push   %edi
  800fda:	56                   	push   %esi
  800fdb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe7:	be 00 00 00 00       	mov    $0x0,%esi
  800fec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fef:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	57                   	push   %edi
  800ffd:	56                   	push   %esi
  800ffe:	53                   	push   %ebx
  800fff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801002:	b9 00 00 00 00       	mov    $0x0,%ecx
  801007:	8b 55 08             	mov    0x8(%ebp),%edx
  80100a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80100f:	89 cb                	mov    %ecx,%ebx
  801011:	89 cf                	mov    %ecx,%edi
  801013:	89 ce                	mov    %ecx,%esi
  801015:	cd 30                	int    $0x30
	if(check && ret > 0)
  801017:	85 c0                	test   %eax,%eax
  801019:	7f 08                	jg     801023 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801023:	83 ec 0c             	sub    $0xc,%esp
  801026:	50                   	push   %eax
  801027:	6a 0e                	push   $0xe
  801029:	68 00 29 80 00       	push   $0x802900
  80102e:	6a 33                	push   $0x33
  801030:	68 1d 29 80 00       	push   $0x80291d
  801035:	e8 f3 f1 ff ff       	call   80022d <_panic>

0080103a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801040:	bb 00 00 00 00       	mov    $0x0,%ebx
  801045:	8b 55 08             	mov    0x8(%ebp),%edx
  801048:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801050:	89 df                	mov    %ebx,%edi
  801052:	89 de                	mov    %ebx,%esi
  801054:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5f                   	pop    %edi
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
	asm volatile("int %1\n"
  801061:	b9 00 00 00 00       	mov    $0x0,%ecx
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	b8 10 00 00 00       	mov    $0x10,%eax
  80106e:	89 cb                	mov    %ecx,%ebx
  801070:	89 cf                	mov    %ecx,%edi
  801072:	89 ce                	mov    %ecx,%esi
  801074:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801076:	5b                   	pop    %ebx
  801077:	5e                   	pop    %esi
  801078:	5f                   	pop    %edi
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	53                   	push   %ebx
  80107f:	83 ec 04             	sub    $0x4,%esp
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801085:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  801087:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80108b:	0f 84 90 00 00 00    	je     801121 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  801091:	89 d8                	mov    %ebx,%eax
  801093:	c1 e8 16             	shr    $0x16,%eax
  801096:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80109d:	a8 01                	test   $0x1,%al
  80109f:	0f 84 90 00 00 00    	je     801135 <pgfault+0xba>
  8010a5:	89 d8                	mov    %ebx,%eax
  8010a7:	c1 e8 0c             	shr    $0xc,%eax
  8010aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010b1:	a9 01 08 00 00       	test   $0x801,%eax
  8010b6:	74 7d                	je     801135 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8010b8:	83 ec 04             	sub    $0x4,%esp
  8010bb:	6a 07                	push   $0x7
  8010bd:	68 00 f0 7f 00       	push   $0x7ff000
  8010c2:	6a 00                	push   $0x0
  8010c4:	e8 3f fd ff ff       	call   800e08 <sys_page_alloc>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	78 79                	js     801149 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  8010d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 00 10 00 00       	push   $0x1000
  8010de:	53                   	push   %ebx
  8010df:	68 00 f0 7f 00       	push   $0x7ff000
  8010e4:	e8 bb fa ff ff       	call   800ba4 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  8010e9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010f0:	53                   	push   %ebx
  8010f1:	6a 00                	push   $0x0
  8010f3:	68 00 f0 7f 00       	push   $0x7ff000
  8010f8:	6a 00                	push   $0x0
  8010fa:	e8 4c fd ff ff       	call   800e4b <sys_page_map>
  8010ff:	83 c4 20             	add    $0x20,%esp
  801102:	85 c0                	test   %eax,%eax
  801104:	78 55                	js     80115b <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801106:	83 ec 08             	sub    $0x8,%esp
  801109:	68 00 f0 7f 00       	push   $0x7ff000
  80110e:	6a 00                	push   $0x0
  801110:	e8 78 fd ff ff       	call   800e8d <sys_page_unmap>
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	85 c0                	test   %eax,%eax
  80111a:	78 51                	js     80116d <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  80111c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80111f:	c9                   	leave  
  801120:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  801121:	83 ec 04             	sub    $0x4,%esp
  801124:	68 2c 29 80 00       	push   $0x80292c
  801129:	6a 21                	push   $0x21
  80112b:	68 b4 29 80 00       	push   $0x8029b4
  801130:	e8 f8 f0 ff ff       	call   80022d <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  801135:	83 ec 04             	sub    $0x4,%esp
  801138:	68 58 29 80 00       	push   $0x802958
  80113d:	6a 24                	push   $0x24
  80113f:	68 b4 29 80 00       	push   $0x8029b4
  801144:	e8 e4 f0 ff ff       	call   80022d <_panic>
		panic("sys_page_alloc: %e\n", r);
  801149:	50                   	push   %eax
  80114a:	68 bf 29 80 00       	push   $0x8029bf
  80114f:	6a 2e                	push   $0x2e
  801151:	68 b4 29 80 00       	push   $0x8029b4
  801156:	e8 d2 f0 ff ff       	call   80022d <_panic>
		panic("sys_page_map: %e\n", r);
  80115b:	50                   	push   %eax
  80115c:	68 d3 29 80 00       	push   $0x8029d3
  801161:	6a 34                	push   $0x34
  801163:	68 b4 29 80 00       	push   $0x8029b4
  801168:	e8 c0 f0 ff ff       	call   80022d <_panic>
		panic("sys_page_unmap: %e\n", r);
  80116d:	50                   	push   %eax
  80116e:	68 e5 29 80 00       	push   $0x8029e5
  801173:	6a 37                	push   $0x37
  801175:	68 b4 29 80 00       	push   $0x8029b4
  80117a:	e8 ae f0 ff ff       	call   80022d <_panic>

0080117f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	57                   	push   %edi
  801183:	56                   	push   %esi
  801184:	53                   	push   %ebx
  801185:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801188:	68 7b 10 80 00       	push   $0x80107b
  80118d:	e8 c9 0e 00 00       	call   80205b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801192:	b8 07 00 00 00       	mov    $0x7,%eax
  801197:	cd 30                	int    $0x30
  801199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	78 30                	js     8011d3 <fork+0x54>
  8011a3:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8011a5:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8011aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011ae:	0f 85 a5 00 00 00    	jne    801259 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011b4:	e8 11 fc ff ff       	call   800dca <sys_getenvid>
  8011b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011be:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8011c1:	c1 e0 04             	shl    $0x4,%eax
  8011c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011c9:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011ce:	e9 75 01 00 00       	jmp    801348 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  8011d3:	50                   	push   %eax
  8011d4:	68 f9 29 80 00       	push   $0x8029f9
  8011d9:	68 83 00 00 00       	push   $0x83
  8011de:	68 b4 29 80 00       	push   $0x8029b4
  8011e3:	e8 45 f0 ff ff       	call   80022d <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8011e8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8011f7:	50                   	push   %eax
  8011f8:	56                   	push   %esi
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	6a 00                	push   $0x0
  8011fd:	e8 49 fc ff ff       	call   800e4b <sys_page_map>
  801202:	83 c4 20             	add    $0x20,%esp
  801205:	85 c0                	test   %eax,%eax
  801207:	79 3e                	jns    801247 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801209:	50                   	push   %eax
  80120a:	68 d3 29 80 00       	push   $0x8029d3
  80120f:	6a 50                	push   $0x50
  801211:	68 b4 29 80 00       	push   $0x8029b4
  801216:	e8 12 f0 ff ff       	call   80022d <_panic>
			panic("sys_page_map: %e\n", r);
  80121b:	50                   	push   %eax
  80121c:	68 d3 29 80 00       	push   $0x8029d3
  801221:	6a 54                	push   $0x54
  801223:	68 b4 29 80 00       	push   $0x8029b4
  801228:	e8 00 f0 ff ff       	call   80022d <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	6a 05                	push   $0x5
  801232:	56                   	push   %esi
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	6a 00                	push   $0x0
  801237:	e8 0f fc ff ff       	call   800e4b <sys_page_map>
  80123c:	83 c4 20             	add    $0x20,%esp
  80123f:	85 c0                	test   %eax,%eax
  801241:	0f 88 ab 00 00 00    	js     8012f2 <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801247:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80124d:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801253:	0f 84 ab 00 00 00    	je     801304 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  801259:	89 d8                	mov    %ebx,%eax
  80125b:	c1 e8 16             	shr    $0x16,%eax
  80125e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801265:	a8 01                	test   $0x1,%al
  801267:	74 de                	je     801247 <fork+0xc8>
  801269:	89 d8                	mov    %ebx,%eax
  80126b:	c1 e8 0c             	shr    $0xc,%eax
  80126e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801275:	f6 c2 01             	test   $0x1,%dl
  801278:	74 cd                	je     801247 <fork+0xc8>
  80127a:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801280:	74 c5                	je     801247 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  801282:	89 c6                	mov    %eax,%esi
  801284:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  801287:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80128e:	f6 c6 04             	test   $0x4,%dh
  801291:	0f 85 51 ff ff ff    	jne    8011e8 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  801297:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80129e:	a9 02 08 00 00       	test   $0x802,%eax
  8012a3:	74 88                	je     80122d <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	68 05 08 00 00       	push   $0x805
  8012ad:	56                   	push   %esi
  8012ae:	57                   	push   %edi
  8012af:	56                   	push   %esi
  8012b0:	6a 00                	push   $0x0
  8012b2:	e8 94 fb ff ff       	call   800e4b <sys_page_map>
  8012b7:	83 c4 20             	add    $0x20,%esp
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	0f 88 59 ff ff ff    	js     80121b <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	68 05 08 00 00       	push   $0x805
  8012ca:	56                   	push   %esi
  8012cb:	6a 00                	push   $0x0
  8012cd:	56                   	push   %esi
  8012ce:	6a 00                	push   $0x0
  8012d0:	e8 76 fb ff ff       	call   800e4b <sys_page_map>
  8012d5:	83 c4 20             	add    $0x20,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	0f 89 67 ff ff ff    	jns    801247 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8012e0:	50                   	push   %eax
  8012e1:	68 d3 29 80 00       	push   $0x8029d3
  8012e6:	6a 56                	push   $0x56
  8012e8:	68 b4 29 80 00       	push   $0x8029b4
  8012ed:	e8 3b ef ff ff       	call   80022d <_panic>
			panic("sys_page_map: %e\n", r);
  8012f2:	50                   	push   %eax
  8012f3:	68 d3 29 80 00       	push   $0x8029d3
  8012f8:	6a 5a                	push   $0x5a
  8012fa:	68 b4 29 80 00       	push   $0x8029b4
  8012ff:	e8 29 ef ff ff       	call   80022d <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801304:	83 ec 04             	sub    $0x4,%esp
  801307:	6a 07                	push   $0x7
  801309:	68 00 f0 bf ee       	push   $0xeebff000
  80130e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801311:	e8 f2 fa ff ff       	call   800e08 <sys_page_alloc>
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	78 36                	js     801353 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	68 c6 20 80 00       	push   $0x8020c6
  801325:	ff 75 e4             	pushl  -0x1c(%ebp)
  801328:	e8 67 fc ff ff       	call   800f94 <sys_env_set_pgfault_upcall>
  80132d:	83 c4 10             	add    $0x10,%esp
  801330:	85 c0                	test   %eax,%eax
  801332:	78 34                	js     801368 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	6a 02                	push   $0x2
  801339:	ff 75 e4             	pushl  -0x1c(%ebp)
  80133c:	e8 cf fb ff ff       	call   800f10 <sys_env_set_status>
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	78 35                	js     80137d <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  801348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80134b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134e:	5b                   	pop    %ebx
  80134f:	5e                   	pop    %esi
  801350:	5f                   	pop    %edi
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  801353:	50                   	push   %eax
  801354:	68 bf 29 80 00       	push   $0x8029bf
  801359:	68 95 00 00 00       	push   $0x95
  80135e:	68 b4 29 80 00       	push   $0x8029b4
  801363:	e8 c5 ee ff ff       	call   80022d <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801368:	50                   	push   %eax
  801369:	68 94 29 80 00       	push   $0x802994
  80136e:	68 98 00 00 00       	push   $0x98
  801373:	68 b4 29 80 00       	push   $0x8029b4
  801378:	e8 b0 ee ff ff       	call   80022d <_panic>
		panic("sys_env_set_status: %e\n", r);
  80137d:	50                   	push   %eax
  80137e:	68 09 2a 80 00       	push   $0x802a09
  801383:	68 9b 00 00 00       	push   $0x9b
  801388:	68 b4 29 80 00       	push   $0x8029b4
  80138d:	e8 9b ee ff ff       	call   80022d <_panic>

00801392 <sfork>:

// Challenge!
int
sfork(void)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801398:	68 21 2a 80 00       	push   $0x802a21
  80139d:	68 a4 00 00 00       	push   $0xa4
  8013a2:	68 b4 29 80 00       	push   $0x8029b4
  8013a7:	e8 81 ee ff ff       	call   80022d <_panic>

008013ac <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	05 00 00 00 30       	add    $0x30000000,%eax
  8013b7:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013db:	89 c2                	mov    %eax,%edx
  8013dd:	c1 ea 16             	shr    $0x16,%edx
  8013e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013e7:	f6 c2 01             	test   $0x1,%dl
  8013ea:	74 2d                	je     801419 <fd_alloc+0x46>
  8013ec:	89 c2                	mov    %eax,%edx
  8013ee:	c1 ea 0c             	shr    $0xc,%edx
  8013f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f8:	f6 c2 01             	test   $0x1,%dl
  8013fb:	74 1c                	je     801419 <fd_alloc+0x46>
  8013fd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801402:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801407:	75 d2                	jne    8013db <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801412:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801417:	eb 0a                	jmp    801423 <fd_alloc+0x50>
			*fd_store = fd;
  801419:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80142b:	83 f8 1f             	cmp    $0x1f,%eax
  80142e:	77 30                	ja     801460 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801430:	c1 e0 0c             	shl    $0xc,%eax
  801433:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801438:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80143e:	f6 c2 01             	test   $0x1,%dl
  801441:	74 24                	je     801467 <fd_lookup+0x42>
  801443:	89 c2                	mov    %eax,%edx
  801445:	c1 ea 0c             	shr    $0xc,%edx
  801448:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	74 1a                	je     80146e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801454:	8b 55 0c             	mov    0xc(%ebp),%edx
  801457:	89 02                	mov    %eax,(%edx)
	return 0;
  801459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    
		return -E_INVAL;
  801460:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801465:	eb f7                	jmp    80145e <fd_lookup+0x39>
		return -E_INVAL;
  801467:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146c:	eb f0                	jmp    80145e <fd_lookup+0x39>
  80146e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801473:	eb e9                	jmp    80145e <fd_lookup+0x39>

00801475 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80147e:	ba b8 2a 80 00       	mov    $0x802ab8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801483:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801488:	39 08                	cmp    %ecx,(%eax)
  80148a:	74 33                	je     8014bf <dev_lookup+0x4a>
  80148c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80148f:	8b 02                	mov    (%edx),%eax
  801491:	85 c0                	test   %eax,%eax
  801493:	75 f3                	jne    801488 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801495:	a1 04 40 80 00       	mov    0x804004,%eax
  80149a:	8b 40 48             	mov    0x48(%eax),%eax
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	51                   	push   %ecx
  8014a1:	50                   	push   %eax
  8014a2:	68 38 2a 80 00       	push   $0x802a38
  8014a7:	e8 5c ee ff ff       	call   800308 <cprintf>
	*dev = 0;
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    
			*dev = devtab[i];
  8014bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c9:	eb f2                	jmp    8014bd <dev_lookup+0x48>

008014cb <fd_close>:
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	57                   	push   %edi
  8014cf:	56                   	push   %esi
  8014d0:	53                   	push   %ebx
  8014d1:	83 ec 24             	sub    $0x24,%esp
  8014d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014dd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014de:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014e4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e7:	50                   	push   %eax
  8014e8:	e8 38 ff ff ff       	call   801425 <fd_lookup>
  8014ed:	89 c3                	mov    %eax,%ebx
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 05                	js     8014fb <fd_close+0x30>
	    || fd != fd2)
  8014f6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014f9:	74 16                	je     801511 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014fb:	89 f8                	mov    %edi,%eax
  8014fd:	84 c0                	test   %al,%al
  8014ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801504:	0f 44 d8             	cmove  %eax,%ebx
}
  801507:	89 d8                	mov    %ebx,%eax
  801509:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150c:	5b                   	pop    %ebx
  80150d:	5e                   	pop    %esi
  80150e:	5f                   	pop    %edi
  80150f:	5d                   	pop    %ebp
  801510:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801517:	50                   	push   %eax
  801518:	ff 36                	pushl  (%esi)
  80151a:	e8 56 ff ff ff       	call   801475 <dev_lookup>
  80151f:	89 c3                	mov    %eax,%ebx
  801521:	83 c4 10             	add    $0x10,%esp
  801524:	85 c0                	test   %eax,%eax
  801526:	78 1a                	js     801542 <fd_close+0x77>
		if (dev->dev_close)
  801528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80152e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801533:	85 c0                	test   %eax,%eax
  801535:	74 0b                	je     801542 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801537:	83 ec 0c             	sub    $0xc,%esp
  80153a:	56                   	push   %esi
  80153b:	ff d0                	call   *%eax
  80153d:	89 c3                	mov    %eax,%ebx
  80153f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	56                   	push   %esi
  801546:	6a 00                	push   $0x0
  801548:	e8 40 f9 ff ff       	call   800e8d <sys_page_unmap>
	return r;
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	eb b5                	jmp    801507 <fd_close+0x3c>

00801552 <close>:

int
close(int fdnum)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801558:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 08             	pushl  0x8(%ebp)
  80155f:	e8 c1 fe ff ff       	call   801425 <fd_lookup>
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	79 02                	jns    80156d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    
		return fd_close(fd, 1);
  80156d:	83 ec 08             	sub    $0x8,%esp
  801570:	6a 01                	push   $0x1
  801572:	ff 75 f4             	pushl  -0xc(%ebp)
  801575:	e8 51 ff ff ff       	call   8014cb <fd_close>
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	eb ec                	jmp    80156b <close+0x19>

0080157f <close_all>:

void
close_all(void)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	53                   	push   %ebx
  801583:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801586:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80158b:	83 ec 0c             	sub    $0xc,%esp
  80158e:	53                   	push   %ebx
  80158f:	e8 be ff ff ff       	call   801552 <close>
	for (i = 0; i < MAXFD; i++)
  801594:	83 c3 01             	add    $0x1,%ebx
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	83 fb 20             	cmp    $0x20,%ebx
  80159d:	75 ec                	jne    80158b <close_all+0xc>
}
  80159f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	57                   	push   %edi
  8015a8:	56                   	push   %esi
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	ff 75 08             	pushl  0x8(%ebp)
  8015b4:	e8 6c fe ff ff       	call   801425 <fd_lookup>
  8015b9:	89 c3                	mov    %eax,%ebx
  8015bb:	83 c4 10             	add    $0x10,%esp
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	0f 88 81 00 00 00    	js     801647 <dup+0xa3>
		return r;
	close(newfdnum);
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 81 ff ff ff       	call   801552 <close>

	newfd = INDEX2FD(newfdnum);
  8015d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015d4:	c1 e6 0c             	shl    $0xc,%esi
  8015d7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015dd:	83 c4 04             	add    $0x4,%esp
  8015e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015e3:	e8 d4 fd ff ff       	call   8013bc <fd2data>
  8015e8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015ea:	89 34 24             	mov    %esi,(%esp)
  8015ed:	e8 ca fd ff ff       	call   8013bc <fd2data>
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015f7:	89 d8                	mov    %ebx,%eax
  8015f9:	c1 e8 16             	shr    $0x16,%eax
  8015fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801603:	a8 01                	test   $0x1,%al
  801605:	74 11                	je     801618 <dup+0x74>
  801607:	89 d8                	mov    %ebx,%eax
  801609:	c1 e8 0c             	shr    $0xc,%eax
  80160c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801613:	f6 c2 01             	test   $0x1,%dl
  801616:	75 39                	jne    801651 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801618:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80161b:	89 d0                	mov    %edx,%eax
  80161d:	c1 e8 0c             	shr    $0xc,%eax
  801620:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801627:	83 ec 0c             	sub    $0xc,%esp
  80162a:	25 07 0e 00 00       	and    $0xe07,%eax
  80162f:	50                   	push   %eax
  801630:	56                   	push   %esi
  801631:	6a 00                	push   $0x0
  801633:	52                   	push   %edx
  801634:	6a 00                	push   $0x0
  801636:	e8 10 f8 ff ff       	call   800e4b <sys_page_map>
  80163b:	89 c3                	mov    %eax,%ebx
  80163d:	83 c4 20             	add    $0x20,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 31                	js     801675 <dup+0xd1>
		goto err;

	return newfdnum;
  801644:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801647:	89 d8                	mov    %ebx,%eax
  801649:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5f                   	pop    %edi
  80164f:	5d                   	pop    %ebp
  801650:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801651:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	25 07 0e 00 00       	and    $0xe07,%eax
  801660:	50                   	push   %eax
  801661:	57                   	push   %edi
  801662:	6a 00                	push   $0x0
  801664:	53                   	push   %ebx
  801665:	6a 00                	push   $0x0
  801667:	e8 df f7 ff ff       	call   800e4b <sys_page_map>
  80166c:	89 c3                	mov    %eax,%ebx
  80166e:	83 c4 20             	add    $0x20,%esp
  801671:	85 c0                	test   %eax,%eax
  801673:	79 a3                	jns    801618 <dup+0x74>
	sys_page_unmap(0, newfd);
  801675:	83 ec 08             	sub    $0x8,%esp
  801678:	56                   	push   %esi
  801679:	6a 00                	push   $0x0
  80167b:	e8 0d f8 ff ff       	call   800e8d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801680:	83 c4 08             	add    $0x8,%esp
  801683:	57                   	push   %edi
  801684:	6a 00                	push   $0x0
  801686:	e8 02 f8 ff ff       	call   800e8d <sys_page_unmap>
	return r;
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	eb b7                	jmp    801647 <dup+0xa3>

00801690 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	53                   	push   %ebx
  801694:	83 ec 1c             	sub    $0x1c,%esp
  801697:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	53                   	push   %ebx
  80169f:	e8 81 fd ff ff       	call   801425 <fd_lookup>
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	78 3f                	js     8016ea <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ab:	83 ec 08             	sub    $0x8,%esp
  8016ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b1:	50                   	push   %eax
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	ff 30                	pushl  (%eax)
  8016b7:	e8 b9 fd ff ff       	call   801475 <dev_lookup>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 27                	js     8016ea <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c6:	8b 42 08             	mov    0x8(%edx),%eax
  8016c9:	83 e0 03             	and    $0x3,%eax
  8016cc:	83 f8 01             	cmp    $0x1,%eax
  8016cf:	74 1e                	je     8016ef <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d4:	8b 40 08             	mov    0x8(%eax),%eax
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	74 35                	je     801710 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	52                   	push   %edx
  8016e5:	ff d0                	call   *%eax
  8016e7:	83 c4 10             	add    $0x10,%esp
}
  8016ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016ef:	a1 04 40 80 00       	mov    0x804004,%eax
  8016f4:	8b 40 48             	mov    0x48(%eax),%eax
  8016f7:	83 ec 04             	sub    $0x4,%esp
  8016fa:	53                   	push   %ebx
  8016fb:	50                   	push   %eax
  8016fc:	68 7c 2a 80 00       	push   $0x802a7c
  801701:	e8 02 ec ff ff       	call   800308 <cprintf>
		return -E_INVAL;
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170e:	eb da                	jmp    8016ea <read+0x5a>
		return -E_NOT_SUPP;
  801710:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801715:	eb d3                	jmp    8016ea <read+0x5a>

00801717 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	57                   	push   %edi
  80171b:	56                   	push   %esi
  80171c:	53                   	push   %ebx
  80171d:	83 ec 0c             	sub    $0xc,%esp
  801720:	8b 7d 08             	mov    0x8(%ebp),%edi
  801723:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801726:	bb 00 00 00 00       	mov    $0x0,%ebx
  80172b:	39 f3                	cmp    %esi,%ebx
  80172d:	73 23                	jae    801752 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	89 f0                	mov    %esi,%eax
  801734:	29 d8                	sub    %ebx,%eax
  801736:	50                   	push   %eax
  801737:	89 d8                	mov    %ebx,%eax
  801739:	03 45 0c             	add    0xc(%ebp),%eax
  80173c:	50                   	push   %eax
  80173d:	57                   	push   %edi
  80173e:	e8 4d ff ff ff       	call   801690 <read>
		if (m < 0)
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	85 c0                	test   %eax,%eax
  801748:	78 06                	js     801750 <readn+0x39>
			return m;
		if (m == 0)
  80174a:	74 06                	je     801752 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80174c:	01 c3                	add    %eax,%ebx
  80174e:	eb db                	jmp    80172b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801750:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801752:	89 d8                	mov    %ebx,%eax
  801754:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801757:	5b                   	pop    %ebx
  801758:	5e                   	pop    %esi
  801759:	5f                   	pop    %edi
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	53                   	push   %ebx
  801760:	83 ec 1c             	sub    $0x1c,%esp
  801763:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801766:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801769:	50                   	push   %eax
  80176a:	53                   	push   %ebx
  80176b:	e8 b5 fc ff ff       	call   801425 <fd_lookup>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	85 c0                	test   %eax,%eax
  801775:	78 3a                	js     8017b1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801777:	83 ec 08             	sub    $0x8,%esp
  80177a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177d:	50                   	push   %eax
  80177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801781:	ff 30                	pushl  (%eax)
  801783:	e8 ed fc ff ff       	call   801475 <dev_lookup>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 22                	js     8017b1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801796:	74 1e                	je     8017b6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179b:	8b 52 0c             	mov    0xc(%edx),%edx
  80179e:	85 d2                	test   %edx,%edx
  8017a0:	74 35                	je     8017d7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	ff 75 10             	pushl  0x10(%ebp)
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	50                   	push   %eax
  8017ac:	ff d2                	call   *%edx
  8017ae:	83 c4 10             	add    $0x10,%esp
}
  8017b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b6:	a1 04 40 80 00       	mov    0x804004,%eax
  8017bb:	8b 40 48             	mov    0x48(%eax),%eax
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	53                   	push   %ebx
  8017c2:	50                   	push   %eax
  8017c3:	68 98 2a 80 00       	push   $0x802a98
  8017c8:	e8 3b eb ff ff       	call   800308 <cprintf>
		return -E_INVAL;
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d5:	eb da                	jmp    8017b1 <write+0x55>
		return -E_NOT_SUPP;
  8017d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017dc:	eb d3                	jmp    8017b1 <write+0x55>

008017de <seek>:

int
seek(int fdnum, off_t offset)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e7:	50                   	push   %eax
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	e8 35 fc ff ff       	call   801425 <fd_lookup>
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	78 0e                	js     801805 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	53                   	push   %ebx
  80180b:	83 ec 1c             	sub    $0x1c,%esp
  80180e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801811:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801814:	50                   	push   %eax
  801815:	53                   	push   %ebx
  801816:	e8 0a fc ff ff       	call   801425 <fd_lookup>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 37                	js     801859 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801828:	50                   	push   %eax
  801829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182c:	ff 30                	pushl  (%eax)
  80182e:	e8 42 fc ff ff       	call   801475 <dev_lookup>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	78 1f                	js     801859 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80183a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801841:	74 1b                	je     80185e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801846:	8b 52 18             	mov    0x18(%edx),%edx
  801849:	85 d2                	test   %edx,%edx
  80184b:	74 32                	je     80187f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80184d:	83 ec 08             	sub    $0x8,%esp
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	50                   	push   %eax
  801854:	ff d2                	call   *%edx
  801856:	83 c4 10             	add    $0x10,%esp
}
  801859:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80185e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801863:	8b 40 48             	mov    0x48(%eax),%eax
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	53                   	push   %ebx
  80186a:	50                   	push   %eax
  80186b:	68 58 2a 80 00       	push   $0x802a58
  801870:	e8 93 ea ff ff       	call   800308 <cprintf>
		return -E_INVAL;
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80187d:	eb da                	jmp    801859 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80187f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801884:	eb d3                	jmp    801859 <ftruncate+0x52>

00801886 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	83 ec 1c             	sub    $0x1c,%esp
  80188d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801890:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801893:	50                   	push   %eax
  801894:	ff 75 08             	pushl  0x8(%ebp)
  801897:	e8 89 fb ff ff       	call   801425 <fd_lookup>
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 4b                	js     8018ee <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a9:	50                   	push   %eax
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ad:	ff 30                	pushl  (%eax)
  8018af:	e8 c1 fb ff ff       	call   801475 <dev_lookup>
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 33                	js     8018ee <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018be:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018c2:	74 2f                	je     8018f3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018c4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018c7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018ce:	00 00 00 
	stat->st_isdir = 0;
  8018d1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018d8:	00 00 00 
	stat->st_dev = dev;
  8018db:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	53                   	push   %ebx
  8018e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e8:	ff 50 14             	call   *0x14(%eax)
  8018eb:	83 c4 10             	add    $0x10,%esp
}
  8018ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    
		return -E_NOT_SUPP;
  8018f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f8:	eb f4                	jmp    8018ee <fstat+0x68>

008018fa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	56                   	push   %esi
  8018fe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018ff:	83 ec 08             	sub    $0x8,%esp
  801902:	6a 00                	push   $0x0
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	e8 e7 01 00 00       	call   801af3 <open>
  80190c:	89 c3                	mov    %eax,%ebx
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	85 c0                	test   %eax,%eax
  801913:	78 1b                	js     801930 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	50                   	push   %eax
  80191c:	e8 65 ff ff ff       	call   801886 <fstat>
  801921:	89 c6                	mov    %eax,%esi
	close(fd);
  801923:	89 1c 24             	mov    %ebx,(%esp)
  801926:	e8 27 fc ff ff       	call   801552 <close>
	return r;
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	89 f3                	mov    %esi,%ebx
}
  801930:	89 d8                	mov    %ebx,%eax
  801932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    

00801939 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	56                   	push   %esi
  80193d:	53                   	push   %ebx
  80193e:	89 c6                	mov    %eax,%esi
  801940:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801942:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801949:	74 27                	je     801972 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80194b:	6a 07                	push   $0x7
  80194d:	68 00 50 80 00       	push   $0x805000
  801952:	56                   	push   %esi
  801953:	ff 35 00 40 80 00    	pushl  0x804000
  801959:	e8 f5 07 00 00       	call   802153 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80195e:	83 c4 0c             	add    $0xc,%esp
  801961:	6a 00                	push   $0x0
  801963:	53                   	push   %ebx
  801964:	6a 00                	push   $0x0
  801966:	e8 81 07 00 00       	call   8020ec <ipc_recv>
}
  80196b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196e:	5b                   	pop    %ebx
  80196f:	5e                   	pop    %esi
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801972:	83 ec 0c             	sub    $0xc,%esp
  801975:	6a 01                	push   $0x1
  801977:	e8 20 08 00 00       	call   80219c <ipc_find_env>
  80197c:	a3 00 40 80 00       	mov    %eax,0x804000
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	eb c5                	jmp    80194b <fsipc+0x12>

00801986 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8b 40 0c             	mov    0xc(%eax),%eax
  801992:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80199f:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8019a9:	e8 8b ff ff ff       	call   801939 <fsipc>
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <devfile_flush>:
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019bc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c6:	b8 06 00 00 00       	mov    $0x6,%eax
  8019cb:	e8 69 ff ff ff       	call   801939 <fsipc>
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <devfile_stat>:
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ec:	b8 05 00 00 00       	mov    $0x5,%eax
  8019f1:	e8 43 ff ff ff       	call   801939 <fsipc>
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 2c                	js     801a26 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019fa:	83 ec 08             	sub    $0x8,%esp
  8019fd:	68 00 50 80 00       	push   $0x805000
  801a02:	53                   	push   %ebx
  801a03:	e8 0e f0 ff ff       	call   800a16 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a08:	a1 80 50 80 00       	mov    0x805080,%eax
  801a0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a13:	a1 84 50 80 00       	mov    0x805084,%eax
  801a18:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <devfile_write>:
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 0c             	sub    $0xc,%esp
  801a31:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a34:	8b 55 08             	mov    0x8(%ebp),%edx
  801a37:	8b 52 0c             	mov    0xc(%edx),%edx
  801a3a:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801a40:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a45:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a4a:	0f 47 c2             	cmova  %edx,%eax
  801a4d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a52:	50                   	push   %eax
  801a53:	ff 75 0c             	pushl  0xc(%ebp)
  801a56:	68 08 50 80 00       	push   $0x805008
  801a5b:	e8 44 f1 ff ff       	call   800ba4 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a60:	ba 00 00 00 00       	mov    $0x0,%edx
  801a65:	b8 04 00 00 00       	mov    $0x4,%eax
  801a6a:	e8 ca fe ff ff       	call   801939 <fsipc>
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <devfile_read>:
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	56                   	push   %esi
  801a75:	53                   	push   %ebx
  801a76:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a84:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8f:	b8 03 00 00 00       	mov    $0x3,%eax
  801a94:	e8 a0 fe ff ff       	call   801939 <fsipc>
  801a99:	89 c3                	mov    %eax,%ebx
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 1f                	js     801abe <devfile_read+0x4d>
	assert(r <= n);
  801a9f:	39 f0                	cmp    %esi,%eax
  801aa1:	77 24                	ja     801ac7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801aa3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aa8:	7f 33                	jg     801add <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	50                   	push   %eax
  801aae:	68 00 50 80 00       	push   $0x805000
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	e8 e9 f0 ff ff       	call   800ba4 <memmove>
	return r;
  801abb:	83 c4 10             	add    $0x10,%esp
}
  801abe:	89 d8                	mov    %ebx,%eax
  801ac0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5e                   	pop    %esi
  801ac5:	5d                   	pop    %ebp
  801ac6:	c3                   	ret    
	assert(r <= n);
  801ac7:	68 c8 2a 80 00       	push   $0x802ac8
  801acc:	68 cf 2a 80 00       	push   $0x802acf
  801ad1:	6a 7c                	push   $0x7c
  801ad3:	68 e4 2a 80 00       	push   $0x802ae4
  801ad8:	e8 50 e7 ff ff       	call   80022d <_panic>
	assert(r <= PGSIZE);
  801add:	68 ef 2a 80 00       	push   $0x802aef
  801ae2:	68 cf 2a 80 00       	push   $0x802acf
  801ae7:	6a 7d                	push   $0x7d
  801ae9:	68 e4 2a 80 00       	push   $0x802ae4
  801aee:	e8 3a e7 ff ff       	call   80022d <_panic>

00801af3 <open>:
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	83 ec 1c             	sub    $0x1c,%esp
  801afb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801afe:	56                   	push   %esi
  801aff:	e8 d9 ee ff ff       	call   8009dd <strlen>
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b0c:	7f 6c                	jg     801b7a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b0e:	83 ec 0c             	sub    $0xc,%esp
  801b11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b14:	50                   	push   %eax
  801b15:	e8 b9 f8 ff ff       	call   8013d3 <fd_alloc>
  801b1a:	89 c3                	mov    %eax,%ebx
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	78 3c                	js     801b5f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b23:	83 ec 08             	sub    $0x8,%esp
  801b26:	56                   	push   %esi
  801b27:	68 00 50 80 00       	push   $0x805000
  801b2c:	e8 e5 ee ff ff       	call   800a16 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b41:	e8 f3 fd ff ff       	call   801939 <fsipc>
  801b46:	89 c3                	mov    %eax,%ebx
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 19                	js     801b68 <open+0x75>
	return fd2num(fd);
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	ff 75 f4             	pushl  -0xc(%ebp)
  801b55:	e8 52 f8 ff ff       	call   8013ac <fd2num>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
}
  801b5f:	89 d8                	mov    %ebx,%eax
  801b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    
		fd_close(fd, 0);
  801b68:	83 ec 08             	sub    $0x8,%esp
  801b6b:	6a 00                	push   $0x0
  801b6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b70:	e8 56 f9 ff ff       	call   8014cb <fd_close>
		return r;
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	eb e5                	jmp    801b5f <open+0x6c>
		return -E_BAD_PATH;
  801b7a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b7f:	eb de                	jmp    801b5f <open+0x6c>

00801b81 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b87:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b91:	e8 a3 fd ff ff       	call   801939 <fsipc>
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	56                   	push   %esi
  801b9c:	53                   	push   %ebx
  801b9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ba0:	83 ec 0c             	sub    $0xc,%esp
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	e8 11 f8 ff ff       	call   8013bc <fd2data>
  801bab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bad:	83 c4 08             	add    $0x8,%esp
  801bb0:	68 fb 2a 80 00       	push   $0x802afb
  801bb5:	53                   	push   %ebx
  801bb6:	e8 5b ee ff ff       	call   800a16 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bbb:	8b 46 04             	mov    0x4(%esi),%eax
  801bbe:	2b 06                	sub    (%esi),%eax
  801bc0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bc6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bcd:	00 00 00 
	stat->st_dev = &devpipe;
  801bd0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bd7:	30 80 00 
	return 0;
}
  801bda:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be2:	5b                   	pop    %ebx
  801be3:	5e                   	pop    %esi
  801be4:	5d                   	pop    %ebp
  801be5:	c3                   	ret    

00801be6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	53                   	push   %ebx
  801bea:	83 ec 0c             	sub    $0xc,%esp
  801bed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bf0:	53                   	push   %ebx
  801bf1:	6a 00                	push   $0x0
  801bf3:	e8 95 f2 ff ff       	call   800e8d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bf8:	89 1c 24             	mov    %ebx,(%esp)
  801bfb:	e8 bc f7 ff ff       	call   8013bc <fd2data>
  801c00:	83 c4 08             	add    $0x8,%esp
  801c03:	50                   	push   %eax
  801c04:	6a 00                	push   $0x0
  801c06:	e8 82 f2 ff ff       	call   800e8d <sys_page_unmap>
}
  801c0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <_pipeisclosed>:
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	57                   	push   %edi
  801c14:	56                   	push   %esi
  801c15:	53                   	push   %ebx
  801c16:	83 ec 1c             	sub    $0x1c,%esp
  801c19:	89 c7                	mov    %eax,%edi
  801c1b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c1d:	a1 04 40 80 00       	mov    0x804004,%eax
  801c22:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c25:	83 ec 0c             	sub    $0xc,%esp
  801c28:	57                   	push   %edi
  801c29:	e8 ad 05 00 00       	call   8021db <pageref>
  801c2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c31:	89 34 24             	mov    %esi,(%esp)
  801c34:	e8 a2 05 00 00       	call   8021db <pageref>
		nn = thisenv->env_runs;
  801c39:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c3f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	39 cb                	cmp    %ecx,%ebx
  801c47:	74 1b                	je     801c64 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c49:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c4c:	75 cf                	jne    801c1d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c4e:	8b 42 58             	mov    0x58(%edx),%eax
  801c51:	6a 01                	push   $0x1
  801c53:	50                   	push   %eax
  801c54:	53                   	push   %ebx
  801c55:	68 02 2b 80 00       	push   $0x802b02
  801c5a:	e8 a9 e6 ff ff       	call   800308 <cprintf>
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	eb b9                	jmp    801c1d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c64:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c67:	0f 94 c0             	sete   %al
  801c6a:	0f b6 c0             	movzbl %al,%eax
}
  801c6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    

00801c75 <devpipe_write>:
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	57                   	push   %edi
  801c79:	56                   	push   %esi
  801c7a:	53                   	push   %ebx
  801c7b:	83 ec 28             	sub    $0x28,%esp
  801c7e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c81:	56                   	push   %esi
  801c82:	e8 35 f7 ff ff       	call   8013bc <fd2data>
  801c87:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c89:	83 c4 10             	add    $0x10,%esp
  801c8c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c91:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c94:	74 4f                	je     801ce5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c96:	8b 43 04             	mov    0x4(%ebx),%eax
  801c99:	8b 0b                	mov    (%ebx),%ecx
  801c9b:	8d 51 20             	lea    0x20(%ecx),%edx
  801c9e:	39 d0                	cmp    %edx,%eax
  801ca0:	72 14                	jb     801cb6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ca2:	89 da                	mov    %ebx,%edx
  801ca4:	89 f0                	mov    %esi,%eax
  801ca6:	e8 65 ff ff ff       	call   801c10 <_pipeisclosed>
  801cab:	85 c0                	test   %eax,%eax
  801cad:	75 3b                	jne    801cea <devpipe_write+0x75>
			sys_yield();
  801caf:	e8 35 f1 ff ff       	call   800de9 <sys_yield>
  801cb4:	eb e0                	jmp    801c96 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cbd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cc0:	89 c2                	mov    %eax,%edx
  801cc2:	c1 fa 1f             	sar    $0x1f,%edx
  801cc5:	89 d1                	mov    %edx,%ecx
  801cc7:	c1 e9 1b             	shr    $0x1b,%ecx
  801cca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ccd:	83 e2 1f             	and    $0x1f,%edx
  801cd0:	29 ca                	sub    %ecx,%edx
  801cd2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cd6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cda:	83 c0 01             	add    $0x1,%eax
  801cdd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ce0:	83 c7 01             	add    $0x1,%edi
  801ce3:	eb ac                	jmp    801c91 <devpipe_write+0x1c>
	return i;
  801ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce8:	eb 05                	jmp    801cef <devpipe_write+0x7a>
				return 0;
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf2:	5b                   	pop    %ebx
  801cf3:	5e                   	pop    %esi
  801cf4:	5f                   	pop    %edi
  801cf5:	5d                   	pop    %ebp
  801cf6:	c3                   	ret    

00801cf7 <devpipe_read>:
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	57                   	push   %edi
  801cfb:	56                   	push   %esi
  801cfc:	53                   	push   %ebx
  801cfd:	83 ec 18             	sub    $0x18,%esp
  801d00:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d03:	57                   	push   %edi
  801d04:	e8 b3 f6 ff ff       	call   8013bc <fd2data>
  801d09:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	be 00 00 00 00       	mov    $0x0,%esi
  801d13:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d16:	75 14                	jne    801d2c <devpipe_read+0x35>
	return i;
  801d18:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1b:	eb 02                	jmp    801d1f <devpipe_read+0x28>
				return i;
  801d1d:	89 f0                	mov    %esi,%eax
}
  801d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d22:	5b                   	pop    %ebx
  801d23:	5e                   	pop    %esi
  801d24:	5f                   	pop    %edi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    
			sys_yield();
  801d27:	e8 bd f0 ff ff       	call   800de9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d2c:	8b 03                	mov    (%ebx),%eax
  801d2e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d31:	75 18                	jne    801d4b <devpipe_read+0x54>
			if (i > 0)
  801d33:	85 f6                	test   %esi,%esi
  801d35:	75 e6                	jne    801d1d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d37:	89 da                	mov    %ebx,%edx
  801d39:	89 f8                	mov    %edi,%eax
  801d3b:	e8 d0 fe ff ff       	call   801c10 <_pipeisclosed>
  801d40:	85 c0                	test   %eax,%eax
  801d42:	74 e3                	je     801d27 <devpipe_read+0x30>
				return 0;
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
  801d49:	eb d4                	jmp    801d1f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d4b:	99                   	cltd   
  801d4c:	c1 ea 1b             	shr    $0x1b,%edx
  801d4f:	01 d0                	add    %edx,%eax
  801d51:	83 e0 1f             	and    $0x1f,%eax
  801d54:	29 d0                	sub    %edx,%eax
  801d56:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d5e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d61:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d64:	83 c6 01             	add    $0x1,%esi
  801d67:	eb aa                	jmp    801d13 <devpipe_read+0x1c>

00801d69 <pipe>:
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	56                   	push   %esi
  801d6d:	53                   	push   %ebx
  801d6e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d74:	50                   	push   %eax
  801d75:	e8 59 f6 ff ff       	call   8013d3 <fd_alloc>
  801d7a:	89 c3                	mov    %eax,%ebx
  801d7c:	83 c4 10             	add    $0x10,%esp
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	0f 88 23 01 00 00    	js     801eaa <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	68 07 04 00 00       	push   $0x407
  801d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d92:	6a 00                	push   $0x0
  801d94:	e8 6f f0 ff ff       	call   800e08 <sys_page_alloc>
  801d99:	89 c3                	mov    %eax,%ebx
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	0f 88 04 01 00 00    	js     801eaa <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801da6:	83 ec 0c             	sub    $0xc,%esp
  801da9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dac:	50                   	push   %eax
  801dad:	e8 21 f6 ff ff       	call   8013d3 <fd_alloc>
  801db2:	89 c3                	mov    %eax,%ebx
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	85 c0                	test   %eax,%eax
  801db9:	0f 88 db 00 00 00    	js     801e9a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	68 07 04 00 00       	push   $0x407
  801dc7:	ff 75 f0             	pushl  -0x10(%ebp)
  801dca:	6a 00                	push   $0x0
  801dcc:	e8 37 f0 ff ff       	call   800e08 <sys_page_alloc>
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	0f 88 bc 00 00 00    	js     801e9a <pipe+0x131>
	va = fd2data(fd0);
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	ff 75 f4             	pushl  -0xc(%ebp)
  801de4:	e8 d3 f5 ff ff       	call   8013bc <fd2data>
  801de9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801deb:	83 c4 0c             	add    $0xc,%esp
  801dee:	68 07 04 00 00       	push   $0x407
  801df3:	50                   	push   %eax
  801df4:	6a 00                	push   $0x0
  801df6:	e8 0d f0 ff ff       	call   800e08 <sys_page_alloc>
  801dfb:	89 c3                	mov    %eax,%ebx
  801dfd:	83 c4 10             	add    $0x10,%esp
  801e00:	85 c0                	test   %eax,%eax
  801e02:	0f 88 82 00 00 00    	js     801e8a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0e:	e8 a9 f5 ff ff       	call   8013bc <fd2data>
  801e13:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e1a:	50                   	push   %eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	56                   	push   %esi
  801e1e:	6a 00                	push   $0x0
  801e20:	e8 26 f0 ff ff       	call   800e4b <sys_page_map>
  801e25:	89 c3                	mov    %eax,%ebx
  801e27:	83 c4 20             	add    $0x20,%esp
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	78 4e                	js     801e7c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e2e:	a1 20 30 80 00       	mov    0x803020,%eax
  801e33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e36:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e45:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	ff 75 f4             	pushl  -0xc(%ebp)
  801e57:	e8 50 f5 ff ff       	call   8013ac <fd2num>
  801e5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e5f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e61:	83 c4 04             	add    $0x4,%esp
  801e64:	ff 75 f0             	pushl  -0x10(%ebp)
  801e67:	e8 40 f5 ff ff       	call   8013ac <fd2num>
  801e6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e6f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e7a:	eb 2e                	jmp    801eaa <pipe+0x141>
	sys_page_unmap(0, va);
  801e7c:	83 ec 08             	sub    $0x8,%esp
  801e7f:	56                   	push   %esi
  801e80:	6a 00                	push   $0x0
  801e82:	e8 06 f0 ff ff       	call   800e8d <sys_page_unmap>
  801e87:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e8a:	83 ec 08             	sub    $0x8,%esp
  801e8d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e90:	6a 00                	push   $0x0
  801e92:	e8 f6 ef ff ff       	call   800e8d <sys_page_unmap>
  801e97:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e9a:	83 ec 08             	sub    $0x8,%esp
  801e9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea0:	6a 00                	push   $0x0
  801ea2:	e8 e6 ef ff ff       	call   800e8d <sys_page_unmap>
  801ea7:	83 c4 10             	add    $0x10,%esp
}
  801eaa:	89 d8                	mov    %ebx,%eax
  801eac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    

00801eb3 <pipeisclosed>:
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebc:	50                   	push   %eax
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	e8 60 f5 ff ff       	call   801425 <fd_lookup>
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	78 18                	js     801ee4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ecc:	83 ec 0c             	sub    $0xc,%esp
  801ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed2:	e8 e5 f4 ff ff       	call   8013bc <fd2data>
	return _pipeisclosed(fd, p);
  801ed7:	89 c2                	mov    %eax,%edx
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	e8 2f fd ff ff       	call   801c10 <_pipeisclosed>
  801ee1:	83 c4 10             	add    $0x10,%esp
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eeb:	c3                   	ret    

00801eec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ef2:	68 1a 2b 80 00       	push   $0x802b1a
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	e8 17 eb ff ff       	call   800a16 <strcpy>
	return 0;
}
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <devcons_write>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	57                   	push   %edi
  801f0a:	56                   	push   %esi
  801f0b:	53                   	push   %ebx
  801f0c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f12:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f17:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f1d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f20:	73 31                	jae    801f53 <devcons_write+0x4d>
		m = n - tot;
  801f22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f25:	29 f3                	sub    %esi,%ebx
  801f27:	83 fb 7f             	cmp    $0x7f,%ebx
  801f2a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f2f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	53                   	push   %ebx
  801f36:	89 f0                	mov    %esi,%eax
  801f38:	03 45 0c             	add    0xc(%ebp),%eax
  801f3b:	50                   	push   %eax
  801f3c:	57                   	push   %edi
  801f3d:	e8 62 ec ff ff       	call   800ba4 <memmove>
		sys_cputs(buf, m);
  801f42:	83 c4 08             	add    $0x8,%esp
  801f45:	53                   	push   %ebx
  801f46:	57                   	push   %edi
  801f47:	e8 00 ee ff ff       	call   800d4c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f4c:	01 de                	add    %ebx,%esi
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	eb ca                	jmp    801f1d <devcons_write+0x17>
}
  801f53:	89 f0                	mov    %esi,%eax
  801f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f58:	5b                   	pop    %ebx
  801f59:	5e                   	pop    %esi
  801f5a:	5f                   	pop    %edi
  801f5b:	5d                   	pop    %ebp
  801f5c:	c3                   	ret    

00801f5d <devcons_read>:
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 08             	sub    $0x8,%esp
  801f63:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f6c:	74 21                	je     801f8f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801f6e:	e8 f7 ed ff ff       	call   800d6a <sys_cgetc>
  801f73:	85 c0                	test   %eax,%eax
  801f75:	75 07                	jne    801f7e <devcons_read+0x21>
		sys_yield();
  801f77:	e8 6d ee ff ff       	call   800de9 <sys_yield>
  801f7c:	eb f0                	jmp    801f6e <devcons_read+0x11>
	if (c < 0)
  801f7e:	78 0f                	js     801f8f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801f80:	83 f8 04             	cmp    $0x4,%eax
  801f83:	74 0c                	je     801f91 <devcons_read+0x34>
	*(char*)vbuf = c;
  801f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f88:	88 02                	mov    %al,(%edx)
	return 1;
  801f8a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    
		return 0;
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
  801f96:	eb f7                	jmp    801f8f <devcons_read+0x32>

00801f98 <cputchar>:
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fa4:	6a 01                	push   $0x1
  801fa6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa9:	50                   	push   %eax
  801faa:	e8 9d ed ff ff       	call   800d4c <sys_cputs>
}
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <getchar>:
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fba:	6a 01                	push   $0x1
  801fbc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fbf:	50                   	push   %eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	e8 c9 f6 ff ff       	call   801690 <read>
	if (r < 0)
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	78 06                	js     801fd4 <getchar+0x20>
	if (r < 1)
  801fce:	74 06                	je     801fd6 <getchar+0x22>
	return c;
  801fd0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    
		return -E_EOF;
  801fd6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fdb:	eb f7                	jmp    801fd4 <getchar+0x20>

00801fdd <iscons>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe6:	50                   	push   %eax
  801fe7:	ff 75 08             	pushl  0x8(%ebp)
  801fea:	e8 36 f4 ff ff       	call   801425 <fd_lookup>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	78 11                	js     802007 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fff:	39 10                	cmp    %edx,(%eax)
  802001:	0f 94 c0             	sete   %al
  802004:	0f b6 c0             	movzbl %al,%eax
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <opencons>:
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80200f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802012:	50                   	push   %eax
  802013:	e8 bb f3 ff ff       	call   8013d3 <fd_alloc>
  802018:	83 c4 10             	add    $0x10,%esp
  80201b:	85 c0                	test   %eax,%eax
  80201d:	78 3a                	js     802059 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	68 07 04 00 00       	push   $0x407
  802027:	ff 75 f4             	pushl  -0xc(%ebp)
  80202a:	6a 00                	push   $0x0
  80202c:	e8 d7 ed ff ff       	call   800e08 <sys_page_alloc>
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	85 c0                	test   %eax,%eax
  802036:	78 21                	js     802059 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802041:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802046:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80204d:	83 ec 0c             	sub    $0xc,%esp
  802050:	50                   	push   %eax
  802051:	e8 56 f3 ff ff       	call   8013ac <fd2num>
  802056:	83 c4 10             	add    $0x10,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802061:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802068:	74 0a                	je     802074 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  802074:	83 ec 04             	sub    $0x4,%esp
  802077:	6a 07                	push   $0x7
  802079:	68 00 f0 bf ee       	push   $0xeebff000
  80207e:	6a 00                	push   $0x0
  802080:	e8 83 ed ff ff       	call   800e08 <sys_page_alloc>
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	85 c0                	test   %eax,%eax
  80208a:	78 28                	js     8020b4 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  80208c:	83 ec 08             	sub    $0x8,%esp
  80208f:	68 c6 20 80 00       	push   $0x8020c6
  802094:	6a 00                	push   $0x0
  802096:	e8 f9 ee ff ff       	call   800f94 <sys_env_set_pgfault_upcall>
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	79 c8                	jns    80206a <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8020a2:	50                   	push   %eax
  8020a3:	68 94 29 80 00       	push   $0x802994
  8020a8:	6a 23                	push   $0x23
  8020aa:	68 3e 2b 80 00       	push   $0x802b3e
  8020af:	e8 79 e1 ff ff       	call   80022d <_panic>
			panic("set_pgfault_handler %e\n",r);
  8020b4:	50                   	push   %eax
  8020b5:	68 26 2b 80 00       	push   $0x802b26
  8020ba:	6a 21                	push   $0x21
  8020bc:	68 3e 2b 80 00       	push   $0x802b3e
  8020c1:	e8 67 e1 ff ff       	call   80022d <_panic>

008020c6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8020c6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8020c7:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8020cc:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8020ce:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  8020d1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  8020d5:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8020d9:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8020dc:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8020de:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8020e2:	83 c4 08             	add    $0x8,%esp
	popal
  8020e5:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8020e6:	83 c4 04             	add    $0x4,%esp
	popfl
  8020e9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8020ea:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8020eb:	c3                   	ret    

008020ec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	56                   	push   %esi
  8020f0:	53                   	push   %ebx
  8020f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8020f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  8020fa:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8020fc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802101:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	50                   	push   %eax
  802108:	e8 ec ee ff ff       	call   800ff9 <sys_ipc_recv>
	if (from_env_store)
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	85 f6                	test   %esi,%esi
  802112:	74 14                	je     802128 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  802114:	ba 00 00 00 00       	mov    $0x0,%edx
  802119:	85 c0                	test   %eax,%eax
  80211b:	78 09                	js     802126 <ipc_recv+0x3a>
  80211d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802123:	8b 52 78             	mov    0x78(%edx),%edx
  802126:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  802128:	85 db                	test   %ebx,%ebx
  80212a:	74 14                	je     802140 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  80212c:	ba 00 00 00 00       	mov    $0x0,%edx
  802131:	85 c0                	test   %eax,%eax
  802133:	78 09                	js     80213e <ipc_recv+0x52>
  802135:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80213b:	8b 52 7c             	mov    0x7c(%edx),%edx
  80213e:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  802140:	85 c0                	test   %eax,%eax
  802142:	78 08                	js     80214c <ipc_recv+0x60>
  802144:	a1 04 40 80 00       	mov    0x804004,%eax
  802149:	8b 40 74             	mov    0x74(%eax),%eax
}
  80214c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80214f:	5b                   	pop    %ebx
  802150:	5e                   	pop    %esi
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    

00802153 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 08             	sub    $0x8,%esp
  802159:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  80215c:	85 c0                	test   %eax,%eax
  80215e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802163:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802166:	ff 75 14             	pushl  0x14(%ebp)
  802169:	50                   	push   %eax
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	ff 75 08             	pushl  0x8(%ebp)
  802170:	e8 61 ee ff ff       	call   800fd6 <sys_ipc_try_send>
  802175:	83 c4 10             	add    $0x10,%esp
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 02                	js     80217e <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  80217e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802181:	75 07                	jne    80218a <ipc_send+0x37>
		sys_yield();
  802183:	e8 61 ec ff ff       	call   800de9 <sys_yield>
}
  802188:	eb f2                	jmp    80217c <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  80218a:	50                   	push   %eax
  80218b:	68 4c 2b 80 00       	push   $0x802b4c
  802190:	6a 3c                	push   $0x3c
  802192:	68 60 2b 80 00       	push   $0x802b60
  802197:	e8 91 e0 ff ff       	call   80022d <_panic>

0080219c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a2:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  8021a7:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8021aa:	c1 e0 04             	shl    $0x4,%eax
  8021ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021b2:	8b 40 50             	mov    0x50(%eax),%eax
  8021b5:	39 c8                	cmp    %ecx,%eax
  8021b7:	74 12                	je     8021cb <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8021b9:	83 c2 01             	add    $0x1,%edx
  8021bc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8021c2:	75 e3                	jne    8021a7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c9:	eb 0e                	jmp    8021d9 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8021cb:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8021ce:	c1 e0 04             	shl    $0x4,%eax
  8021d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d9:	5d                   	pop    %ebp
  8021da:	c3                   	ret    

008021db <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021e1:	89 d0                	mov    %edx,%eax
  8021e3:	c1 e8 16             	shr    $0x16,%eax
  8021e6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021f2:	f6 c1 01             	test   $0x1,%cl
  8021f5:	74 1d                	je     802214 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021f7:	c1 ea 0c             	shr    $0xc,%edx
  8021fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802201:	f6 c2 01             	test   $0x1,%dl
  802204:	74 0e                	je     802214 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802206:	c1 ea 0c             	shr    $0xc,%edx
  802209:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802210:	ef 
  802211:	0f b7 c0             	movzwl %ax,%eax
}
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    
  802216:	66 90                	xchg   %ax,%ax
  802218:	66 90                	xchg   %ax,%ax
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	66 90                	xchg   %ax,%ax
  80221e:	66 90                	xchg   %ax,%ax

00802220 <__udivdi3>:
  802220:	55                   	push   %ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 1c             	sub    $0x1c,%esp
  802227:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80222b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80222f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802233:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802237:	85 d2                	test   %edx,%edx
  802239:	75 4d                	jne    802288 <__udivdi3+0x68>
  80223b:	39 f3                	cmp    %esi,%ebx
  80223d:	76 19                	jbe    802258 <__udivdi3+0x38>
  80223f:	31 ff                	xor    %edi,%edi
  802241:	89 e8                	mov    %ebp,%eax
  802243:	89 f2                	mov    %esi,%edx
  802245:	f7 f3                	div    %ebx
  802247:	89 fa                	mov    %edi,%edx
  802249:	83 c4 1c             	add    $0x1c,%esp
  80224c:	5b                   	pop    %ebx
  80224d:	5e                   	pop    %esi
  80224e:	5f                   	pop    %edi
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    
  802251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802258:	89 d9                	mov    %ebx,%ecx
  80225a:	85 db                	test   %ebx,%ebx
  80225c:	75 0b                	jne    802269 <__udivdi3+0x49>
  80225e:	b8 01 00 00 00       	mov    $0x1,%eax
  802263:	31 d2                	xor    %edx,%edx
  802265:	f7 f3                	div    %ebx
  802267:	89 c1                	mov    %eax,%ecx
  802269:	31 d2                	xor    %edx,%edx
  80226b:	89 f0                	mov    %esi,%eax
  80226d:	f7 f1                	div    %ecx
  80226f:	89 c6                	mov    %eax,%esi
  802271:	89 e8                	mov    %ebp,%eax
  802273:	89 f7                	mov    %esi,%edi
  802275:	f7 f1                	div    %ecx
  802277:	89 fa                	mov    %edi,%edx
  802279:	83 c4 1c             	add    $0x1c,%esp
  80227c:	5b                   	pop    %ebx
  80227d:	5e                   	pop    %esi
  80227e:	5f                   	pop    %edi
  80227f:	5d                   	pop    %ebp
  802280:	c3                   	ret    
  802281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802288:	39 f2                	cmp    %esi,%edx
  80228a:	77 1c                	ja     8022a8 <__udivdi3+0x88>
  80228c:	0f bd fa             	bsr    %edx,%edi
  80228f:	83 f7 1f             	xor    $0x1f,%edi
  802292:	75 2c                	jne    8022c0 <__udivdi3+0xa0>
  802294:	39 f2                	cmp    %esi,%edx
  802296:	72 06                	jb     80229e <__udivdi3+0x7e>
  802298:	31 c0                	xor    %eax,%eax
  80229a:	39 eb                	cmp    %ebp,%ebx
  80229c:	77 a9                	ja     802247 <__udivdi3+0x27>
  80229e:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a3:	eb a2                	jmp    802247 <__udivdi3+0x27>
  8022a5:	8d 76 00             	lea    0x0(%esi),%esi
  8022a8:	31 ff                	xor    %edi,%edi
  8022aa:	31 c0                	xor    %eax,%eax
  8022ac:	89 fa                	mov    %edi,%edx
  8022ae:	83 c4 1c             	add    $0x1c,%esp
  8022b1:	5b                   	pop    %ebx
  8022b2:	5e                   	pop    %esi
  8022b3:	5f                   	pop    %edi
  8022b4:	5d                   	pop    %ebp
  8022b5:	c3                   	ret    
  8022b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022bd:	8d 76 00             	lea    0x0(%esi),%esi
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022c7:	29 f8                	sub    %edi,%eax
  8022c9:	d3 e2                	shl    %cl,%edx
  8022cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	89 da                	mov    %ebx,%edx
  8022d3:	d3 ea                	shr    %cl,%edx
  8022d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d9:	09 d1                	or     %edx,%ecx
  8022db:	89 f2                	mov    %esi,%edx
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e3                	shl    %cl,%ebx
  8022e5:	89 c1                	mov    %eax,%ecx
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	89 f9                	mov    %edi,%ecx
  8022eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ef:	89 eb                	mov    %ebp,%ebx
  8022f1:	d3 e6                	shl    %cl,%esi
  8022f3:	89 c1                	mov    %eax,%ecx
  8022f5:	d3 eb                	shr    %cl,%ebx
  8022f7:	09 de                	or     %ebx,%esi
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	f7 74 24 08          	divl   0x8(%esp)
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c3                	mov    %eax,%ebx
  802303:	f7 64 24 0c          	mull   0xc(%esp)
  802307:	39 d6                	cmp    %edx,%esi
  802309:	72 15                	jb     802320 <__udivdi3+0x100>
  80230b:	89 f9                	mov    %edi,%ecx
  80230d:	d3 e5                	shl    %cl,%ebp
  80230f:	39 c5                	cmp    %eax,%ebp
  802311:	73 04                	jae    802317 <__udivdi3+0xf7>
  802313:	39 d6                	cmp    %edx,%esi
  802315:	74 09                	je     802320 <__udivdi3+0x100>
  802317:	89 d8                	mov    %ebx,%eax
  802319:	31 ff                	xor    %edi,%edi
  80231b:	e9 27 ff ff ff       	jmp    802247 <__udivdi3+0x27>
  802320:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802323:	31 ff                	xor    %edi,%edi
  802325:	e9 1d ff ff ff       	jmp    802247 <__udivdi3+0x27>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__umoddi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80233b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802343:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802347:	89 da                	mov    %ebx,%edx
  802349:	85 c0                	test   %eax,%eax
  80234b:	75 43                	jne    802390 <__umoddi3+0x60>
  80234d:	39 df                	cmp    %ebx,%edi
  80234f:	76 17                	jbe    802368 <__umoddi3+0x38>
  802351:	89 f0                	mov    %esi,%eax
  802353:	f7 f7                	div    %edi
  802355:	89 d0                	mov    %edx,%eax
  802357:	31 d2                	xor    %edx,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	89 fd                	mov    %edi,%ebp
  80236a:	85 ff                	test   %edi,%edi
  80236c:	75 0b                	jne    802379 <__umoddi3+0x49>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f7                	div    %edi
  802377:	89 c5                	mov    %eax,%ebp
  802379:	89 d8                	mov    %ebx,%eax
  80237b:	31 d2                	xor    %edx,%edx
  80237d:	f7 f5                	div    %ebp
  80237f:	89 f0                	mov    %esi,%eax
  802381:	f7 f5                	div    %ebp
  802383:	89 d0                	mov    %edx,%eax
  802385:	eb d0                	jmp    802357 <__umoddi3+0x27>
  802387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238e:	66 90                	xchg   %ax,%ax
  802390:	89 f1                	mov    %esi,%ecx
  802392:	39 d8                	cmp    %ebx,%eax
  802394:	76 0a                	jbe    8023a0 <__umoddi3+0x70>
  802396:	89 f0                	mov    %esi,%eax
  802398:	83 c4 1c             	add    $0x1c,%esp
  80239b:	5b                   	pop    %ebx
  80239c:	5e                   	pop    %esi
  80239d:	5f                   	pop    %edi
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    
  8023a0:	0f bd e8             	bsr    %eax,%ebp
  8023a3:	83 f5 1f             	xor    $0x1f,%ebp
  8023a6:	75 20                	jne    8023c8 <__umoddi3+0x98>
  8023a8:	39 d8                	cmp    %ebx,%eax
  8023aa:	0f 82 b0 00 00 00    	jb     802460 <__umoddi3+0x130>
  8023b0:	39 f7                	cmp    %esi,%edi
  8023b2:	0f 86 a8 00 00 00    	jbe    802460 <__umoddi3+0x130>
  8023b8:	89 c8                	mov    %ecx,%eax
  8023ba:	83 c4 1c             	add    $0x1c,%esp
  8023bd:	5b                   	pop    %ebx
  8023be:	5e                   	pop    %esi
  8023bf:	5f                   	pop    %edi
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    
  8023c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023c8:	89 e9                	mov    %ebp,%ecx
  8023ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8023cf:	29 ea                	sub    %ebp,%edx
  8023d1:	d3 e0                	shl    %cl,%eax
  8023d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023d7:	89 d1                	mov    %edx,%ecx
  8023d9:	89 f8                	mov    %edi,%eax
  8023db:	d3 e8                	shr    %cl,%eax
  8023dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023e9:	09 c1                	or     %eax,%ecx
  8023eb:	89 d8                	mov    %ebx,%eax
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 e9                	mov    %ebp,%ecx
  8023f3:	d3 e7                	shl    %cl,%edi
  8023f5:	89 d1                	mov    %edx,%ecx
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ff:	d3 e3                	shl    %cl,%ebx
  802401:	89 c7                	mov    %eax,%edi
  802403:	89 d1                	mov    %edx,%ecx
  802405:	89 f0                	mov    %esi,%eax
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 fa                	mov    %edi,%edx
  80240d:	d3 e6                	shl    %cl,%esi
  80240f:	09 d8                	or     %ebx,%eax
  802411:	f7 74 24 08          	divl   0x8(%esp)
  802415:	89 d1                	mov    %edx,%ecx
  802417:	89 f3                	mov    %esi,%ebx
  802419:	f7 64 24 0c          	mull   0xc(%esp)
  80241d:	89 c6                	mov    %eax,%esi
  80241f:	89 d7                	mov    %edx,%edi
  802421:	39 d1                	cmp    %edx,%ecx
  802423:	72 06                	jb     80242b <__umoddi3+0xfb>
  802425:	75 10                	jne    802437 <__umoddi3+0x107>
  802427:	39 c3                	cmp    %eax,%ebx
  802429:	73 0c                	jae    802437 <__umoddi3+0x107>
  80242b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80242f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802433:	89 d7                	mov    %edx,%edi
  802435:	89 c6                	mov    %eax,%esi
  802437:	89 ca                	mov    %ecx,%edx
  802439:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80243e:	29 f3                	sub    %esi,%ebx
  802440:	19 fa                	sbb    %edi,%edx
  802442:	89 d0                	mov    %edx,%eax
  802444:	d3 e0                	shl    %cl,%eax
  802446:	89 e9                	mov    %ebp,%ecx
  802448:	d3 eb                	shr    %cl,%ebx
  80244a:	d3 ea                	shr    %cl,%edx
  80244c:	09 d8                	or     %ebx,%eax
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	89 da                	mov    %ebx,%edx
  802462:	29 fe                	sub    %edi,%esi
  802464:	19 c2                	sbb    %eax,%edx
  802466:	89 f1                	mov    %esi,%ecx
  802468:	89 c8                	mov    %ecx,%eax
  80246a:	e9 4b ff ff ff       	jmp    8023ba <__umoddi3+0x8a>
