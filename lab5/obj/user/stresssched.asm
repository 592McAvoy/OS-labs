
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b6 00 00 00       	call   8000e7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 a2 0c 00 00       	call   800cdf <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 4b 10 00 00       	call   801094 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 a4 0c 00 00       	call   800cfe <sys_yield>
		return;
  80005a:	eb 6d                	jmp    8000c9 <umain+0x96>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005c:	89 f0                	mov    %esi,%eax
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	8d 14 c0             	lea    (%eax,%eax,8),%edx
  800066:	c1 e2 04             	shl    $0x4,%edx
  800069:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80006f:	eb 02                	jmp    800073 <umain+0x40>
		asm volatile("pause");
  800071:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800073:	8b 42 54             	mov    0x54(%edx),%eax
  800076:	85 c0                	test   %eax,%eax
  800078:	75 f7                	jne    800071 <umain+0x3e>
  80007a:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007f:	e8 7a 0c 00 00       	call   800cfe <sys_yield>
  800084:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800089:	a1 04 20 80 00       	mov    0x802004,%eax
  80008e:	83 c0 01             	add    $0x1,%eax
  800091:	a3 04 20 80 00       	mov    %eax,0x802004
		for (j = 0; j < 10000; j++)
  800096:	83 ea 01             	sub    $0x1,%edx
  800099:	75 ee                	jne    800089 <umain+0x56>
	for (i = 0; i < 10; i++) {
  80009b:	83 eb 01             	sub    $0x1,%ebx
  80009e:	75 df                	jne    80007f <umain+0x4c>
	}

	if (counter != 10*10000)
  8000a0:	a1 04 20 80 00       	mov    0x802004,%eax
  8000a5:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000aa:	75 24                	jne    8000d0 <umain+0x9d>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ac:	a1 08 20 80 00       	mov    0x802008,%eax
  8000b1:	8b 50 60             	mov    0x60(%eax),%edx
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	52                   	push   %edx
  8000bb:	50                   	push   %eax
  8000bc:	68 fb 15 80 00       	push   $0x8015fb
  8000c1:	e8 57 01 00 00       	call   80021d <cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp

}
  8000c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d0:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d5:	50                   	push   %eax
  8000d6:	68 c0 15 80 00       	push   $0x8015c0
  8000db:	6a 21                	push   $0x21
  8000dd:	68 e8 15 80 00       	push   $0x8015e8
  8000e2:	e8 5b 00 00 00       	call   800142 <_panic>

008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	56                   	push   %esi
  8000eb:	53                   	push   %ebx
  8000ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ef:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f2:	e8 e8 0b 00 00       	call   800cdf <sys_getenvid>
  8000f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fc:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000ff:	c1 e0 04             	shl    $0x4,%eax
  800102:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800107:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010c:	85 db                	test   %ebx,%ebx
  80010e:	7e 07                	jle    800117 <libmain+0x30>
		binaryname = argv[0];
  800110:	8b 06                	mov    (%esi),%eax
  800112:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	56                   	push   %esi
  80011b:	53                   	push   %ebx
  80011c:	e8 12 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800121:	e8 0a 00 00 00       	call   800130 <exit>
}
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012c:	5b                   	pop    %ebx
  80012d:	5e                   	pop    %esi
  80012e:	5d                   	pop    %ebp
  80012f:	c3                   	ret    

00800130 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800136:	6a 00                	push   $0x0
  800138:	e8 61 0b 00 00       	call   800c9e <sys_env_destroy>
}
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	56                   	push   %esi
  800146:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800147:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80014a:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800150:	e8 8a 0b 00 00       	call   800cdf <sys_getenvid>
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	ff 75 0c             	pushl  0xc(%ebp)
  80015b:	ff 75 08             	pushl  0x8(%ebp)
  80015e:	56                   	push   %esi
  80015f:	50                   	push   %eax
  800160:	68 24 16 80 00       	push   $0x801624
  800165:	e8 b3 00 00 00       	call   80021d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80016a:	83 c4 18             	add    $0x18,%esp
  80016d:	53                   	push   %ebx
  80016e:	ff 75 10             	pushl  0x10(%ebp)
  800171:	e8 56 00 00 00       	call   8001cc <vcprintf>
	cprintf("\n");
  800176:	c7 04 24 17 16 80 00 	movl   $0x801617,(%esp)
  80017d:	e8 9b 00 00 00       	call   80021d <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800185:	cc                   	int3   
  800186:	eb fd                	jmp    800185 <_panic+0x43>

00800188 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	53                   	push   %ebx
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800192:	8b 13                	mov    (%ebx),%edx
  800194:	8d 42 01             	lea    0x1(%edx),%eax
  800197:	89 03                	mov    %eax,(%ebx)
  800199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a5:	74 09                	je     8001b0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	68 ff 00 00 00       	push   $0xff
  8001b8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bb:	50                   	push   %eax
  8001bc:	e8 a0 0a 00 00       	call   800c61 <sys_cputs>
		b->idx = 0;
  8001c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb db                	jmp    8001a7 <putch+0x1f>

008001cc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001dc:	00 00 00 
	b.cnt = 0;
  8001df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ec:	ff 75 08             	pushl  0x8(%ebp)
  8001ef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f5:	50                   	push   %eax
  8001f6:	68 88 01 80 00       	push   $0x800188
  8001fb:	e8 4a 01 00 00       	call   80034a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800200:	83 c4 08             	add    $0x8,%esp
  800203:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800209:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020f:	50                   	push   %eax
  800210:	e8 4c 0a 00 00       	call   800c61 <sys_cputs>

	return b.cnt;
}
  800215:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    

0080021d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800223:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800226:	50                   	push   %eax
  800227:	ff 75 08             	pushl  0x8(%ebp)
  80022a:	e8 9d ff ff ff       	call   8001cc <vcprintf>
	va_end(ap);

	return cnt;
}
  80022f:	c9                   	leave  
  800230:	c3                   	ret    

00800231 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	57                   	push   %edi
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
  800237:	83 ec 1c             	sub    $0x1c,%esp
  80023a:	89 c6                	mov    %eax,%esi
  80023c:	89 d7                	mov    %edx,%edi
  80023e:	8b 45 08             	mov    0x8(%ebp),%eax
  800241:	8b 55 0c             	mov    0xc(%ebp),%edx
  800244:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800247:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800250:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800254:	74 2c                	je     800282 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800259:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800260:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800263:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800266:	39 c2                	cmp    %eax,%edx
  800268:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80026b:	73 43                	jae    8002b0 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80026d:	83 eb 01             	sub    $0x1,%ebx
  800270:	85 db                	test   %ebx,%ebx
  800272:	7e 6c                	jle    8002e0 <printnum+0xaf>
			putch(padc, putdat);
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	57                   	push   %edi
  800278:	ff 75 18             	pushl  0x18(%ebp)
  80027b:	ff d6                	call   *%esi
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	eb eb                	jmp    80026d <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	6a 20                	push   $0x20
  800287:	6a 00                	push   $0x0
  800289:	50                   	push   %eax
  80028a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028d:	ff 75 e0             	pushl  -0x20(%ebp)
  800290:	89 fa                	mov    %edi,%edx
  800292:	89 f0                	mov    %esi,%eax
  800294:	e8 98 ff ff ff       	call   800231 <printnum>
		while (--width > 0)
  800299:	83 c4 20             	add    $0x20,%esp
  80029c:	83 eb 01             	sub    $0x1,%ebx
  80029f:	85 db                	test   %ebx,%ebx
  8002a1:	7e 65                	jle    800308 <printnum+0xd7>
			putch(padc, putdat);
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	57                   	push   %edi
  8002a7:	6a 20                	push   $0x20
  8002a9:	ff d6                	call   *%esi
  8002ab:	83 c4 10             	add    $0x10,%esp
  8002ae:	eb ec                	jmp    80029c <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	ff 75 18             	pushl  0x18(%ebp)
  8002b6:	83 eb 01             	sub    $0x1,%ebx
  8002b9:	53                   	push   %ebx
  8002ba:	50                   	push   %eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ca:	e8 91 10 00 00       	call   801360 <__udivdi3>
  8002cf:	83 c4 18             	add    $0x18,%esp
  8002d2:	52                   	push   %edx
  8002d3:	50                   	push   %eax
  8002d4:	89 fa                	mov    %edi,%edx
  8002d6:	89 f0                	mov    %esi,%eax
  8002d8:	e8 54 ff ff ff       	call   800231 <printnum>
  8002dd:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002e0:	83 ec 08             	sub    $0x8,%esp
  8002e3:	57                   	push   %edi
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f3:	e8 78 11 00 00       	call   801470 <__umoddi3>
  8002f8:	83 c4 14             	add    $0x14,%esp
  8002fb:	0f be 80 47 16 80 00 	movsbl 0x801647(%eax),%eax
  800302:	50                   	push   %eax
  800303:	ff d6                	call   *%esi
  800305:	83 c4 10             	add    $0x10,%esp
}
  800308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030b:	5b                   	pop    %ebx
  80030c:	5e                   	pop    %esi
  80030d:	5f                   	pop    %edi
  80030e:	5d                   	pop    %ebp
  80030f:	c3                   	ret    

00800310 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800316:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80031a:	8b 10                	mov    (%eax),%edx
  80031c:	3b 50 04             	cmp    0x4(%eax),%edx
  80031f:	73 0a                	jae    80032b <sprintputch+0x1b>
		*b->buf++ = ch;
  800321:	8d 4a 01             	lea    0x1(%edx),%ecx
  800324:	89 08                	mov    %ecx,(%eax)
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	88 02                	mov    %al,(%edx)
}
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    

0080032d <printfmt>:
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800333:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800336:	50                   	push   %eax
  800337:	ff 75 10             	pushl  0x10(%ebp)
  80033a:	ff 75 0c             	pushl  0xc(%ebp)
  80033d:	ff 75 08             	pushl  0x8(%ebp)
  800340:	e8 05 00 00 00       	call   80034a <vprintfmt>
}
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	c9                   	leave  
  800349:	c3                   	ret    

0080034a <vprintfmt>:
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	57                   	push   %edi
  80034e:	56                   	push   %esi
  80034f:	53                   	push   %ebx
  800350:	83 ec 3c             	sub    $0x3c,%esp
  800353:	8b 75 08             	mov    0x8(%ebp),%esi
  800356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800359:	8b 7d 10             	mov    0x10(%ebp),%edi
  80035c:	e9 b4 03 00 00       	jmp    800715 <vprintfmt+0x3cb>
		padc = ' ';
  800361:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800365:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80036c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800373:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80037a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800381:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800386:	8d 47 01             	lea    0x1(%edi),%eax
  800389:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038c:	0f b6 17             	movzbl (%edi),%edx
  80038f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800392:	3c 55                	cmp    $0x55,%al
  800394:	0f 87 c8 04 00 00    	ja     800862 <vprintfmt+0x518>
  80039a:	0f b6 c0             	movzbl %al,%eax
  80039d:	ff 24 85 20 18 80 00 	jmp    *0x801820(,%eax,4)
  8003a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8003a7:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8003ae:	eb d6                	jmp    800386 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003b3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003b7:	eb cd                	jmp    800386 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003b9:	0f b6 d2             	movzbl %dl,%edx
  8003bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8003c7:	eb 0c                	jmp    8003d5 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003cc:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003d0:	eb b4                	jmp    800386 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8003d2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003d5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003d8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003dc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003df:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003e2:	83 f9 09             	cmp    $0x9,%ecx
  8003e5:	76 eb                	jbe    8003d2 <vprintfmt+0x88>
  8003e7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ed:	eb 14                	jmp    800403 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fa:	8d 40 04             	lea    0x4(%eax),%eax
  8003fd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800403:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800407:	0f 89 79 ff ff ff    	jns    800386 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80040d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800410:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800413:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80041a:	e9 67 ff ff ff       	jmp    800386 <vprintfmt+0x3c>
  80041f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800422:	85 c0                	test   %eax,%eax
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	0f 49 d0             	cmovns %eax,%edx
  80042c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800432:	e9 4f ff ff ff       	jmp    800386 <vprintfmt+0x3c>
  800437:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80043a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800441:	e9 40 ff ff ff       	jmp    800386 <vprintfmt+0x3c>
			lflag++;
  800446:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800449:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044c:	e9 35 ff ff ff       	jmp    800386 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8d 78 04             	lea    0x4(%eax),%edi
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	53                   	push   %ebx
  80045b:	ff 30                	pushl  (%eax)
  80045d:	ff d6                	call   *%esi
			break;
  80045f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800462:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800465:	e9 a8 02 00 00       	jmp    800712 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	8d 78 04             	lea    0x4(%eax),%edi
  800470:	8b 00                	mov    (%eax),%eax
  800472:	99                   	cltd   
  800473:	31 d0                	xor    %edx,%eax
  800475:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800477:	83 f8 0f             	cmp    $0xf,%eax
  80047a:	7f 23                	jg     80049f <vprintfmt+0x155>
  80047c:	8b 14 85 80 19 80 00 	mov    0x801980(,%eax,4),%edx
  800483:	85 d2                	test   %edx,%edx
  800485:	74 18                	je     80049f <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800487:	52                   	push   %edx
  800488:	68 68 16 80 00       	push   $0x801668
  80048d:	53                   	push   %ebx
  80048e:	56                   	push   %esi
  80048f:	e8 99 fe ff ff       	call   80032d <printfmt>
  800494:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800497:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049a:	e9 73 02 00 00       	jmp    800712 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80049f:	50                   	push   %eax
  8004a0:	68 5f 16 80 00       	push   $0x80165f
  8004a5:	53                   	push   %ebx
  8004a6:	56                   	push   %esi
  8004a7:	e8 81 fe ff ff       	call   80032d <printfmt>
  8004ac:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004af:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b2:	e9 5b 02 00 00       	jmp    800712 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	83 c0 04             	add    $0x4,%eax
  8004bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c3:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004c5:	85 d2                	test   %edx,%edx
  8004c7:	b8 58 16 80 00       	mov    $0x801658,%eax
  8004cc:	0f 45 c2             	cmovne %edx,%eax
  8004cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d6:	7e 06                	jle    8004de <vprintfmt+0x194>
  8004d8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004dc:	75 0d                	jne    8004eb <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e1:	89 c7                	mov    %eax,%edi
  8004e3:	03 45 e0             	add    -0x20(%ebp),%eax
  8004e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e9:	eb 53                	jmp    80053e <vprintfmt+0x1f4>
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8004f1:	50                   	push   %eax
  8004f2:	e8 13 04 00 00       	call   80090a <strnlen>
  8004f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004fa:	29 c1                	sub    %eax,%ecx
  8004fc:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800504:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800508:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	eb 0f                	jmp    80051c <vprintfmt+0x1d2>
					putch(padc, putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	53                   	push   %ebx
  800511:	ff 75 e0             	pushl  -0x20(%ebp)
  800514:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800516:	83 ef 01             	sub    $0x1,%edi
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	85 ff                	test   %edi,%edi
  80051e:	7f ed                	jg     80050d <vprintfmt+0x1c3>
  800520:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800523:	85 d2                	test   %edx,%edx
  800525:	b8 00 00 00 00       	mov    $0x0,%eax
  80052a:	0f 49 c2             	cmovns %edx,%eax
  80052d:	29 c2                	sub    %eax,%edx
  80052f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800532:	eb aa                	jmp    8004de <vprintfmt+0x194>
					putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	53                   	push   %ebx
  800538:	52                   	push   %edx
  800539:	ff d6                	call   *%esi
  80053b:	83 c4 10             	add    $0x10,%esp
  80053e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800541:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800543:	83 c7 01             	add    $0x1,%edi
  800546:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80054a:	0f be d0             	movsbl %al,%edx
  80054d:	85 d2                	test   %edx,%edx
  80054f:	74 4b                	je     80059c <vprintfmt+0x252>
  800551:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800555:	78 06                	js     80055d <vprintfmt+0x213>
  800557:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80055b:	78 1e                	js     80057b <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80055d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800561:	74 d1                	je     800534 <vprintfmt+0x1ea>
  800563:	0f be c0             	movsbl %al,%eax
  800566:	83 e8 20             	sub    $0x20,%eax
  800569:	83 f8 5e             	cmp    $0x5e,%eax
  80056c:	76 c6                	jbe    800534 <vprintfmt+0x1ea>
					putch('?', putdat);
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	53                   	push   %ebx
  800572:	6a 3f                	push   $0x3f
  800574:	ff d6                	call   *%esi
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	eb c3                	jmp    80053e <vprintfmt+0x1f4>
  80057b:	89 cf                	mov    %ecx,%edi
  80057d:	eb 0e                	jmp    80058d <vprintfmt+0x243>
				putch(' ', putdat);
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	53                   	push   %ebx
  800583:	6a 20                	push   $0x20
  800585:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800587:	83 ef 01             	sub    $0x1,%edi
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	85 ff                	test   %edi,%edi
  80058f:	7f ee                	jg     80057f <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800591:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
  800597:	e9 76 01 00 00       	jmp    800712 <vprintfmt+0x3c8>
  80059c:	89 cf                	mov    %ecx,%edi
  80059e:	eb ed                	jmp    80058d <vprintfmt+0x243>
	if (lflag >= 2)
  8005a0:	83 f9 01             	cmp    $0x1,%ecx
  8005a3:	7f 1f                	jg     8005c4 <vprintfmt+0x27a>
	else if (lflag)
  8005a5:	85 c9                	test   %ecx,%ecx
  8005a7:	74 6a                	je     800613 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b1:	89 c1                	mov    %eax,%ecx
  8005b3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8d 40 04             	lea    0x4(%eax),%eax
  8005bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c2:	eb 17                	jmp    8005db <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8b 50 04             	mov    0x4(%eax),%edx
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8d 40 08             	lea    0x8(%eax),%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005db:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005de:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005e3:	85 d2                	test   %edx,%edx
  8005e5:	0f 89 f8 00 00 00    	jns    8006e3 <vprintfmt+0x399>
				putch('-', putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	6a 2d                	push   $0x2d
  8005f1:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005f9:	f7 d8                	neg    %eax
  8005fb:	83 d2 00             	adc    $0x0,%edx
  8005fe:	f7 da                	neg    %edx
  800600:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800603:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800606:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800609:	bf 0a 00 00 00       	mov    $0xa,%edi
  80060e:	e9 e1 00 00 00       	jmp    8006f4 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	99                   	cltd   
  80061c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	eb b1                	jmp    8005db <vprintfmt+0x291>
	if (lflag >= 2)
  80062a:	83 f9 01             	cmp    $0x1,%ecx
  80062d:	7f 27                	jg     800656 <vprintfmt+0x30c>
	else if (lflag)
  80062f:	85 c9                	test   %ecx,%ecx
  800631:	74 41                	je     800674 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	ba 00 00 00 00       	mov    $0x0,%edx
  80063d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800640:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800651:	e9 8d 00 00 00       	jmp    8006e3 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 50 04             	mov    0x4(%eax),%edx
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 08             	lea    0x8(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800672:	eb 6f                	jmp    8006e3 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800692:	eb 4f                	jmp    8006e3 <vprintfmt+0x399>
	if (lflag >= 2)
  800694:	83 f9 01             	cmp    $0x1,%ecx
  800697:	7f 23                	jg     8006bc <vprintfmt+0x372>
	else if (lflag)
  800699:	85 c9                	test   %ecx,%ecx
  80069b:	0f 84 98 00 00 00    	je     800739 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ba:	eb 17                	jmp    8006d3 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 50 04             	mov    0x4(%eax),%edx
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8d 40 08             	lea    0x8(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	6a 30                	push   $0x30
  8006d9:	ff d6                	call   *%esi
			goto number;
  8006db:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006de:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8006e3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006e7:	74 0b                	je     8006f4 <vprintfmt+0x3aa>
				putch('+', putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	6a 2b                	push   $0x2b
  8006ef:	ff d6                	call   *%esi
  8006f1:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006f4:	83 ec 0c             	sub    $0xc,%esp
  8006f7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ff:	57                   	push   %edi
  800700:	ff 75 dc             	pushl  -0x24(%ebp)
  800703:	ff 75 d8             	pushl  -0x28(%ebp)
  800706:	89 da                	mov    %ebx,%edx
  800708:	89 f0                	mov    %esi,%eax
  80070a:	e8 22 fb ff ff       	call   800231 <printnum>
			break;
  80070f:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800712:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	83 c7 01             	add    $0x1,%edi
  800718:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80071c:	83 f8 25             	cmp    $0x25,%eax
  80071f:	0f 84 3c fc ff ff    	je     800361 <vprintfmt+0x17>
			if (ch == '\0')
  800725:	85 c0                	test   %eax,%eax
  800727:	0f 84 55 01 00 00    	je     800882 <vprintfmt+0x538>
			putch(ch, putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	53                   	push   %ebx
  800731:	50                   	push   %eax
  800732:	ff d6                	call   *%esi
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	eb dc                	jmp    800715 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	ba 00 00 00 00       	mov    $0x0,%edx
  800743:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800746:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 40 04             	lea    0x4(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
  800752:	e9 7c ff ff ff       	jmp    8006d3 <vprintfmt+0x389>
			putch('0', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	53                   	push   %ebx
  80075b:	6a 30                	push   $0x30
  80075d:	ff d6                	call   *%esi
			putch('x', putdat);
  80075f:	83 c4 08             	add    $0x8,%esp
  800762:	53                   	push   %ebx
  800763:	6a 78                	push   $0x78
  800765:	ff d6                	call   *%esi
			num = (unsigned long long)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	ba 00 00 00 00       	mov    $0x0,%edx
  800771:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800774:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800777:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 40 04             	lea    0x4(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800783:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800788:	e9 56 ff ff ff       	jmp    8006e3 <vprintfmt+0x399>
	if (lflag >= 2)
  80078d:	83 f9 01             	cmp    $0x1,%ecx
  800790:	7f 27                	jg     8007b9 <vprintfmt+0x46f>
	else if (lflag)
  800792:	85 c9                	test   %ecx,%ecx
  800794:	74 44                	je     8007da <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007af:	bf 10 00 00 00       	mov    $0x10,%edi
  8007b4:	e9 2a ff ff ff       	jmp    8006e3 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 50 04             	mov    0x4(%eax),%edx
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 40 08             	lea    0x8(%eax),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d0:	bf 10 00 00 00       	mov    $0x10,%edi
  8007d5:	e9 09 ff ff ff       	jmp    8006e3 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8d 40 04             	lea    0x4(%eax),%eax
  8007f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f3:	bf 10 00 00 00       	mov    $0x10,%edi
  8007f8:	e9 e6 fe ff ff       	jmp    8006e3 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8d 78 04             	lea    0x4(%eax),%edi
  800803:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800805:	85 c0                	test   %eax,%eax
  800807:	74 2d                	je     800836 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800809:	0f b6 13             	movzbl (%ebx),%edx
  80080c:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80080e:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800811:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800814:	0f 8e f8 fe ff ff    	jle    800712 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80081a:	68 b8 17 80 00       	push   $0x8017b8
  80081f:	68 68 16 80 00       	push   $0x801668
  800824:	53                   	push   %ebx
  800825:	56                   	push   %esi
  800826:	e8 02 fb ff ff       	call   80032d <printfmt>
  80082b:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80082e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800831:	e9 dc fe ff ff       	jmp    800712 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800836:	68 80 17 80 00       	push   $0x801780
  80083b:	68 68 16 80 00       	push   $0x801668
  800840:	53                   	push   %ebx
  800841:	56                   	push   %esi
  800842:	e8 e6 fa ff ff       	call   80032d <printfmt>
  800847:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80084a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80084d:	e9 c0 fe ff ff       	jmp    800712 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	53                   	push   %ebx
  800856:	6a 25                	push   $0x25
  800858:	ff d6                	call   *%esi
			break;
  80085a:	83 c4 10             	add    $0x10,%esp
  80085d:	e9 b0 fe ff ff       	jmp    800712 <vprintfmt+0x3c8>
			putch('%', putdat);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	53                   	push   %ebx
  800866:	6a 25                	push   $0x25
  800868:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086a:	83 c4 10             	add    $0x10,%esp
  80086d:	89 f8                	mov    %edi,%eax
  80086f:	eb 03                	jmp    800874 <vprintfmt+0x52a>
  800871:	83 e8 01             	sub    $0x1,%eax
  800874:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800878:	75 f7                	jne    800871 <vprintfmt+0x527>
  80087a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087d:	e9 90 fe ff ff       	jmp    800712 <vprintfmt+0x3c8>
}
  800882:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800885:	5b                   	pop    %ebx
  800886:	5e                   	pop    %esi
  800887:	5f                   	pop    %edi
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	83 ec 18             	sub    $0x18,%esp
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800896:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800899:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a7:	85 c0                	test   %eax,%eax
  8008a9:	74 26                	je     8008d1 <vsnprintf+0x47>
  8008ab:	85 d2                	test   %edx,%edx
  8008ad:	7e 22                	jle    8008d1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008af:	ff 75 14             	pushl  0x14(%ebp)
  8008b2:	ff 75 10             	pushl  0x10(%ebp)
  8008b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b8:	50                   	push   %eax
  8008b9:	68 10 03 80 00       	push   $0x800310
  8008be:	e8 87 fa ff ff       	call   80034a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cc:	83 c4 10             	add    $0x10,%esp
}
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    
		return -E_INVAL;
  8008d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d6:	eb f7                	jmp    8008cf <vsnprintf+0x45>

008008d8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008de:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e1:	50                   	push   %eax
  8008e2:	ff 75 10             	pushl  0x10(%ebp)
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	ff 75 08             	pushl  0x8(%ebp)
  8008eb:	e8 9a ff ff ff       	call   80088a <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    

008008f2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800901:	74 05                	je     800908 <strlen+0x16>
		n++;
  800903:	83 c0 01             	add    $0x1,%eax
  800906:	eb f5                	jmp    8008fd <strlen+0xb>
	return n;
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800910:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800913:	ba 00 00 00 00       	mov    $0x0,%edx
  800918:	39 c2                	cmp    %eax,%edx
  80091a:	74 0d                	je     800929 <strnlen+0x1f>
  80091c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800920:	74 05                	je     800927 <strnlen+0x1d>
		n++;
  800922:	83 c2 01             	add    $0x1,%edx
  800925:	eb f1                	jmp    800918 <strnlen+0xe>
  800927:	89 d0                	mov    %edx,%eax
	return n;
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800935:	ba 00 00 00 00       	mov    $0x0,%edx
  80093a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80093e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800941:	83 c2 01             	add    $0x1,%edx
  800944:	84 c9                	test   %cl,%cl
  800946:	75 f2                	jne    80093a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800948:	5b                   	pop    %ebx
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	53                   	push   %ebx
  80094f:	83 ec 10             	sub    $0x10,%esp
  800952:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800955:	53                   	push   %ebx
  800956:	e8 97 ff ff ff       	call   8008f2 <strlen>
  80095b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	01 d8                	add    %ebx,%eax
  800963:	50                   	push   %eax
  800964:	e8 c2 ff ff ff       	call   80092b <strcpy>
	return dst;
}
  800969:	89 d8                	mov    %ebx,%eax
  80096b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	56                   	push   %esi
  800974:	53                   	push   %ebx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097b:	89 c6                	mov    %eax,%esi
  80097d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800980:	89 c2                	mov    %eax,%edx
  800982:	39 f2                	cmp    %esi,%edx
  800984:	74 11                	je     800997 <strncpy+0x27>
		*dst++ = *src;
  800986:	83 c2 01             	add    $0x1,%edx
  800989:	0f b6 19             	movzbl (%ecx),%ebx
  80098c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098f:	80 fb 01             	cmp    $0x1,%bl
  800992:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800995:	eb eb                	jmp    800982 <strncpy+0x12>
	}
	return ret;
}
  800997:	5b                   	pop    %ebx
  800998:	5e                   	pop    %esi
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009a9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ab:	85 d2                	test   %edx,%edx
  8009ad:	74 21                	je     8009d0 <strlcpy+0x35>
  8009af:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009b3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009b5:	39 c2                	cmp    %eax,%edx
  8009b7:	74 14                	je     8009cd <strlcpy+0x32>
  8009b9:	0f b6 19             	movzbl (%ecx),%ebx
  8009bc:	84 db                	test   %bl,%bl
  8009be:	74 0b                	je     8009cb <strlcpy+0x30>
			*dst++ = *src++;
  8009c0:	83 c1 01             	add    $0x1,%ecx
  8009c3:	83 c2 01             	add    $0x1,%edx
  8009c6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c9:	eb ea                	jmp    8009b5 <strlcpy+0x1a>
  8009cb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d0:	29 f0                	sub    %esi,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5e                   	pop    %esi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009df:	0f b6 01             	movzbl (%ecx),%eax
  8009e2:	84 c0                	test   %al,%al
  8009e4:	74 0c                	je     8009f2 <strcmp+0x1c>
  8009e6:	3a 02                	cmp    (%edx),%al
  8009e8:	75 08                	jne    8009f2 <strcmp+0x1c>
		p++, q++;
  8009ea:	83 c1 01             	add    $0x1,%ecx
  8009ed:	83 c2 01             	add    $0x1,%edx
  8009f0:	eb ed                	jmp    8009df <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f2:	0f b6 c0             	movzbl %al,%eax
  8009f5:	0f b6 12             	movzbl (%edx),%edx
  8009f8:	29 d0                	sub    %edx,%eax
}
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	53                   	push   %ebx
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a06:	89 c3                	mov    %eax,%ebx
  800a08:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a0b:	eb 06                	jmp    800a13 <strncmp+0x17>
		n--, p++, q++;
  800a0d:	83 c0 01             	add    $0x1,%eax
  800a10:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a13:	39 d8                	cmp    %ebx,%eax
  800a15:	74 16                	je     800a2d <strncmp+0x31>
  800a17:	0f b6 08             	movzbl (%eax),%ecx
  800a1a:	84 c9                	test   %cl,%cl
  800a1c:	74 04                	je     800a22 <strncmp+0x26>
  800a1e:	3a 0a                	cmp    (%edx),%cl
  800a20:	74 eb                	je     800a0d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a22:	0f b6 00             	movzbl (%eax),%eax
  800a25:	0f b6 12             	movzbl (%edx),%edx
  800a28:	29 d0                	sub    %edx,%eax
}
  800a2a:	5b                   	pop    %ebx
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    
		return 0;
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a32:	eb f6                	jmp    800a2a <strncmp+0x2e>

00800a34 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3e:	0f b6 10             	movzbl (%eax),%edx
  800a41:	84 d2                	test   %dl,%dl
  800a43:	74 09                	je     800a4e <strchr+0x1a>
		if (*s == c)
  800a45:	38 ca                	cmp    %cl,%dl
  800a47:	74 0a                	je     800a53 <strchr+0x1f>
	for (; *s; s++)
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	eb f0                	jmp    800a3e <strchr+0xa>
			return (char *) s;
	return 0;
  800a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a62:	38 ca                	cmp    %cl,%dl
  800a64:	74 09                	je     800a6f <strfind+0x1a>
  800a66:	84 d2                	test   %dl,%dl
  800a68:	74 05                	je     800a6f <strfind+0x1a>
	for (; *s; s++)
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	eb f0                	jmp    800a5f <strfind+0xa>
			break;
	return (char *) s;
}
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	57                   	push   %edi
  800a75:	56                   	push   %esi
  800a76:	53                   	push   %ebx
  800a77:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a7d:	85 c9                	test   %ecx,%ecx
  800a7f:	74 31                	je     800ab2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a81:	89 f8                	mov    %edi,%eax
  800a83:	09 c8                	or     %ecx,%eax
  800a85:	a8 03                	test   $0x3,%al
  800a87:	75 23                	jne    800aac <memset+0x3b>
		c &= 0xFF;
  800a89:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a8d:	89 d3                	mov    %edx,%ebx
  800a8f:	c1 e3 08             	shl    $0x8,%ebx
  800a92:	89 d0                	mov    %edx,%eax
  800a94:	c1 e0 18             	shl    $0x18,%eax
  800a97:	89 d6                	mov    %edx,%esi
  800a99:	c1 e6 10             	shl    $0x10,%esi
  800a9c:	09 f0                	or     %esi,%eax
  800a9e:	09 c2                	or     %eax,%edx
  800aa0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aa2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aa5:	89 d0                	mov    %edx,%eax
  800aa7:	fc                   	cld    
  800aa8:	f3 ab                	rep stos %eax,%es:(%edi)
  800aaa:	eb 06                	jmp    800ab2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaf:	fc                   	cld    
  800ab0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ab2:	89 f8                	mov    %edi,%eax
  800ab4:	5b                   	pop    %ebx
  800ab5:	5e                   	pop    %esi
  800ab6:	5f                   	pop    %edi
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	56                   	push   %esi
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac7:	39 c6                	cmp    %eax,%esi
  800ac9:	73 32                	jae    800afd <memmove+0x44>
  800acb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ace:	39 c2                	cmp    %eax,%edx
  800ad0:	76 2b                	jbe    800afd <memmove+0x44>
		s += n;
		d += n;
  800ad2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad5:	89 fe                	mov    %edi,%esi
  800ad7:	09 ce                	or     %ecx,%esi
  800ad9:	09 d6                	or     %edx,%esi
  800adb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae1:	75 0e                	jne    800af1 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae3:	83 ef 04             	sub    $0x4,%edi
  800ae6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aec:	fd                   	std    
  800aed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aef:	eb 09                	jmp    800afa <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800af1:	83 ef 01             	sub    $0x1,%edi
  800af4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800af7:	fd                   	std    
  800af8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800afa:	fc                   	cld    
  800afb:	eb 1a                	jmp    800b17 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afd:	89 c2                	mov    %eax,%edx
  800aff:	09 ca                	or     %ecx,%edx
  800b01:	09 f2                	or     %esi,%edx
  800b03:	f6 c2 03             	test   $0x3,%dl
  800b06:	75 0a                	jne    800b12 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b08:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b0b:	89 c7                	mov    %eax,%edi
  800b0d:	fc                   	cld    
  800b0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b10:	eb 05                	jmp    800b17 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b12:	89 c7                	mov    %eax,%edi
  800b14:	fc                   	cld    
  800b15:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b17:	5e                   	pop    %esi
  800b18:	5f                   	pop    %edi
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b21:	ff 75 10             	pushl  0x10(%ebp)
  800b24:	ff 75 0c             	pushl  0xc(%ebp)
  800b27:	ff 75 08             	pushl  0x8(%ebp)
  800b2a:	e8 8a ff ff ff       	call   800ab9 <memmove>
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	56                   	push   %esi
  800b35:	53                   	push   %ebx
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3c:	89 c6                	mov    %eax,%esi
  800b3e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b41:	39 f0                	cmp    %esi,%eax
  800b43:	74 1c                	je     800b61 <memcmp+0x30>
		if (*s1 != *s2)
  800b45:	0f b6 08             	movzbl (%eax),%ecx
  800b48:	0f b6 1a             	movzbl (%edx),%ebx
  800b4b:	38 d9                	cmp    %bl,%cl
  800b4d:	75 08                	jne    800b57 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4f:	83 c0 01             	add    $0x1,%eax
  800b52:	83 c2 01             	add    $0x1,%edx
  800b55:	eb ea                	jmp    800b41 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b57:	0f b6 c1             	movzbl %cl,%eax
  800b5a:	0f b6 db             	movzbl %bl,%ebx
  800b5d:	29 d8                	sub    %ebx,%eax
  800b5f:	eb 05                	jmp    800b66 <memcmp+0x35>
	}

	return 0;
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b73:	89 c2                	mov    %eax,%edx
  800b75:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b78:	39 d0                	cmp    %edx,%eax
  800b7a:	73 09                	jae    800b85 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b7c:	38 08                	cmp    %cl,(%eax)
  800b7e:	74 05                	je     800b85 <memfind+0x1b>
	for (; s < ends; s++)
  800b80:	83 c0 01             	add    $0x1,%eax
  800b83:	eb f3                	jmp    800b78 <memfind+0xe>
			break;
	return (void *) s;
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b90:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b93:	eb 03                	jmp    800b98 <strtol+0x11>
		s++;
  800b95:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b98:	0f b6 01             	movzbl (%ecx),%eax
  800b9b:	3c 20                	cmp    $0x20,%al
  800b9d:	74 f6                	je     800b95 <strtol+0xe>
  800b9f:	3c 09                	cmp    $0x9,%al
  800ba1:	74 f2                	je     800b95 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ba3:	3c 2b                	cmp    $0x2b,%al
  800ba5:	74 2a                	je     800bd1 <strtol+0x4a>
	int neg = 0;
  800ba7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bac:	3c 2d                	cmp    $0x2d,%al
  800bae:	74 2b                	je     800bdb <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb6:	75 0f                	jne    800bc7 <strtol+0x40>
  800bb8:	80 39 30             	cmpb   $0x30,(%ecx)
  800bbb:	74 28                	je     800be5 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bbd:	85 db                	test   %ebx,%ebx
  800bbf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bc4:	0f 44 d8             	cmove  %eax,%ebx
  800bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bcf:	eb 50                	jmp    800c21 <strtol+0x9a>
		s++;
  800bd1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bd4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd9:	eb d5                	jmp    800bb0 <strtol+0x29>
		s++, neg = 1;
  800bdb:	83 c1 01             	add    $0x1,%ecx
  800bde:	bf 01 00 00 00       	mov    $0x1,%edi
  800be3:	eb cb                	jmp    800bb0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be9:	74 0e                	je     800bf9 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800beb:	85 db                	test   %ebx,%ebx
  800bed:	75 d8                	jne    800bc7 <strtol+0x40>
		s++, base = 8;
  800bef:	83 c1 01             	add    $0x1,%ecx
  800bf2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf7:	eb ce                	jmp    800bc7 <strtol+0x40>
		s += 2, base = 16;
  800bf9:	83 c1 02             	add    $0x2,%ecx
  800bfc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c01:	eb c4                	jmp    800bc7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c03:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c06:	89 f3                	mov    %esi,%ebx
  800c08:	80 fb 19             	cmp    $0x19,%bl
  800c0b:	77 29                	ja     800c36 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c0d:	0f be d2             	movsbl %dl,%edx
  800c10:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c13:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c16:	7d 30                	jge    800c48 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c18:	83 c1 01             	add    $0x1,%ecx
  800c1b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c21:	0f b6 11             	movzbl (%ecx),%edx
  800c24:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c27:	89 f3                	mov    %esi,%ebx
  800c29:	80 fb 09             	cmp    $0x9,%bl
  800c2c:	77 d5                	ja     800c03 <strtol+0x7c>
			dig = *s - '0';
  800c2e:	0f be d2             	movsbl %dl,%edx
  800c31:	83 ea 30             	sub    $0x30,%edx
  800c34:	eb dd                	jmp    800c13 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c36:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c39:	89 f3                	mov    %esi,%ebx
  800c3b:	80 fb 19             	cmp    $0x19,%bl
  800c3e:	77 08                	ja     800c48 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c40:	0f be d2             	movsbl %dl,%edx
  800c43:	83 ea 37             	sub    $0x37,%edx
  800c46:	eb cb                	jmp    800c13 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4c:	74 05                	je     800c53 <strtol+0xcc>
		*endptr = (char *) s;
  800c4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c51:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c53:	89 c2                	mov    %eax,%edx
  800c55:	f7 da                	neg    %edx
  800c57:	85 ff                	test   %edi,%edi
  800c59:	0f 45 c2             	cmovne %edx,%eax
}
  800c5c:	5b                   	pop    %ebx
  800c5d:	5e                   	pop    %esi
  800c5e:	5f                   	pop    %edi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	57                   	push   %edi
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c67:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c72:	89 c3                	mov    %eax,%ebx
  800c74:	89 c7                	mov    %eax,%edi
  800c76:	89 c6                	mov    %eax,%esi
  800c78:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c85:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8f:	89 d1                	mov    %edx,%ecx
  800c91:	89 d3                	mov    %edx,%ebx
  800c93:	89 d7                	mov    %edx,%edi
  800c95:	89 d6                	mov    %edx,%esi
  800c97:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
  800ca4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb4:	89 cb                	mov    %ecx,%ebx
  800cb6:	89 cf                	mov    %ecx,%edi
  800cb8:	89 ce                	mov    %ecx,%esi
  800cba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbc:	85 c0                	test   %eax,%eax
  800cbe:	7f 08                	jg     800cc8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc8:	83 ec 0c             	sub    $0xc,%esp
  800ccb:	50                   	push   %eax
  800ccc:	6a 03                	push   $0x3
  800cce:	68 c0 19 80 00       	push   $0x8019c0
  800cd3:	6a 33                	push   $0x33
  800cd5:	68 dd 19 80 00       	push   $0x8019dd
  800cda:	e8 63 f4 ff ff       	call   800142 <_panic>

00800cdf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	57                   	push   %edi
  800ce3:	56                   	push   %esi
  800ce4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cea:	b8 02 00 00 00       	mov    $0x2,%eax
  800cef:	89 d1                	mov    %edx,%ecx
  800cf1:	89 d3                	mov    %edx,%ebx
  800cf3:	89 d7                	mov    %edx,%edi
  800cf5:	89 d6                	mov    %edx,%esi
  800cf7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <sys_yield>:

void
sys_yield(void)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d04:	ba 00 00 00 00       	mov    $0x0,%edx
  800d09:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d0e:	89 d1                	mov    %edx,%ecx
  800d10:	89 d3                	mov    %edx,%ebx
  800d12:	89 d7                	mov    %edx,%edi
  800d14:	89 d6                	mov    %edx,%esi
  800d16:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d26:	be 00 00 00 00       	mov    $0x0,%esi
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d31:	b8 04 00 00 00       	mov    $0x4,%eax
  800d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d39:	89 f7                	mov    %esi,%edi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 04                	push   $0x4
  800d4f:	68 c0 19 80 00       	push   $0x8019c0
  800d54:	6a 33                	push   $0x33
  800d56:	68 dd 19 80 00       	push   $0x8019dd
  800d5b:	e8 e2 f3 ff ff       	call   800142 <_panic>

00800d60 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	7f 08                	jg     800d8b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8b:	83 ec 0c             	sub    $0xc,%esp
  800d8e:	50                   	push   %eax
  800d8f:	6a 05                	push   $0x5
  800d91:	68 c0 19 80 00       	push   $0x8019c0
  800d96:	6a 33                	push   $0x33
  800d98:	68 dd 19 80 00       	push   $0x8019dd
  800d9d:	e8 a0 f3 ff ff       	call   800142 <_panic>

00800da2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbb:	89 df                	mov    %ebx,%edi
  800dbd:	89 de                	mov    %ebx,%esi
  800dbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	7f 08                	jg     800dcd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	83 ec 0c             	sub    $0xc,%esp
  800dd0:	50                   	push   %eax
  800dd1:	6a 06                	push   $0x6
  800dd3:	68 c0 19 80 00       	push   $0x8019c0
  800dd8:	6a 33                	push   $0x33
  800dda:	68 dd 19 80 00       	push   $0x8019dd
  800ddf:	e8 5e f3 ff ff       	call   800142 <_panic>

00800de4 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
  800dea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ded:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dfa:	89 cb                	mov    %ecx,%ebx
  800dfc:	89 cf                	mov    %ecx,%edi
  800dfe:	89 ce                	mov    %ecx,%esi
  800e00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7f 08                	jg     800e0e <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	50                   	push   %eax
  800e12:	6a 0b                	push   $0xb
  800e14:	68 c0 19 80 00       	push   $0x8019c0
  800e19:	6a 33                	push   $0x33
  800e1b:	68 dd 19 80 00       	push   $0x8019dd
  800e20:	e8 1d f3 ff ff       	call   800142 <_panic>

00800e25 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e33:	8b 55 08             	mov    0x8(%ebp),%edx
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	b8 08 00 00 00       	mov    $0x8,%eax
  800e3e:	89 df                	mov    %ebx,%edi
  800e40:	89 de                	mov    %ebx,%esi
  800e42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	7f 08                	jg     800e50 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	50                   	push   %eax
  800e54:	6a 08                	push   $0x8
  800e56:	68 c0 19 80 00       	push   $0x8019c0
  800e5b:	6a 33                	push   $0x33
  800e5d:	68 dd 19 80 00       	push   $0x8019dd
  800e62:	e8 db f2 ff ff       	call   800142 <_panic>

00800e67 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	b8 09 00 00 00       	mov    $0x9,%eax
  800e80:	89 df                	mov    %ebx,%edi
  800e82:	89 de                	mov    %ebx,%esi
  800e84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e86:	85 c0                	test   %eax,%eax
  800e88:	7f 08                	jg     800e92 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e92:	83 ec 0c             	sub    $0xc,%esp
  800e95:	50                   	push   %eax
  800e96:	6a 09                	push   $0x9
  800e98:	68 c0 19 80 00       	push   $0x8019c0
  800e9d:	6a 33                	push   $0x33
  800e9f:	68 dd 19 80 00       	push   $0x8019dd
  800ea4:	e8 99 f2 ff ff       	call   800142 <_panic>

00800ea9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec2:	89 df                	mov    %ebx,%edi
  800ec4:	89 de                	mov    %ebx,%esi
  800ec6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	7f 08                	jg     800ed4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecf:	5b                   	pop    %ebx
  800ed0:	5e                   	pop    %esi
  800ed1:	5f                   	pop    %edi
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	50                   	push   %eax
  800ed8:	6a 0a                	push   $0xa
  800eda:	68 c0 19 80 00       	push   $0x8019c0
  800edf:	6a 33                	push   $0x33
  800ee1:	68 dd 19 80 00       	push   $0x8019dd
  800ee6:	e8 57 f2 ff ff       	call   800142 <_panic>

00800eeb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800efc:	be 00 00 00 00       	mov    $0x0,%esi
  800f01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f04:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f07:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    

00800f0e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	57                   	push   %edi
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
  800f14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f24:	89 cb                	mov    %ecx,%ebx
  800f26:	89 cf                	mov    %ecx,%edi
  800f28:	89 ce                	mov    %ecx,%esi
  800f2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7f 08                	jg     800f38 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	83 ec 0c             	sub    $0xc,%esp
  800f3b:	50                   	push   %eax
  800f3c:	6a 0e                	push   $0xe
  800f3e:	68 c0 19 80 00       	push   $0x8019c0
  800f43:	6a 33                	push   $0x33
  800f45:	68 dd 19 80 00       	push   $0x8019dd
  800f4a:	e8 f3 f1 ff ff       	call   800142 <_panic>

00800f4f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f60:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f65:	89 df                	mov    %ebx,%edi
  800f67:	89 de                	mov    %ebx,%esi
  800f69:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f76:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	b8 10 00 00 00       	mov    $0x10,%eax
  800f83:	89 cb                	mov    %ecx,%ebx
  800f85:	89 cf                	mov    %ecx,%edi
  800f87:	89 ce                	mov    %ecx,%esi
  800f89:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f8b:	5b                   	pop    %ebx
  800f8c:	5e                   	pop    %esi
  800f8d:	5f                   	pop    %edi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	53                   	push   %ebx
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f9a:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  800f9c:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fa0:	0f 84 90 00 00 00    	je     801036 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  800fa6:	89 d8                	mov    %ebx,%eax
  800fa8:	c1 e8 16             	shr    $0x16,%eax
  800fab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fb2:	a8 01                	test   $0x1,%al
  800fb4:	0f 84 90 00 00 00    	je     80104a <pgfault+0xba>
  800fba:	89 d8                	mov    %ebx,%eax
  800fbc:	c1 e8 0c             	shr    $0xc,%eax
  800fbf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fc6:	a9 01 08 00 00       	test   $0x801,%eax
  800fcb:	74 7d                	je     80104a <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  800fcd:	83 ec 04             	sub    $0x4,%esp
  800fd0:	6a 07                	push   $0x7
  800fd2:	68 00 f0 7f 00       	push   $0x7ff000
  800fd7:	6a 00                	push   $0x0
  800fd9:	e8 3f fd ff ff       	call   800d1d <sys_page_alloc>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	78 79                	js     80105e <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  800fe5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  800feb:	83 ec 04             	sub    $0x4,%esp
  800fee:	68 00 10 00 00       	push   $0x1000
  800ff3:	53                   	push   %ebx
  800ff4:	68 00 f0 7f 00       	push   $0x7ff000
  800ff9:	e8 bb fa ff ff       	call   800ab9 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  800ffe:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801005:	53                   	push   %ebx
  801006:	6a 00                	push   $0x0
  801008:	68 00 f0 7f 00       	push   $0x7ff000
  80100d:	6a 00                	push   $0x0
  80100f:	e8 4c fd ff ff       	call   800d60 <sys_page_map>
  801014:	83 c4 20             	add    $0x20,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	78 55                	js     801070 <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  80101b:	83 ec 08             	sub    $0x8,%esp
  80101e:	68 00 f0 7f 00       	push   $0x7ff000
  801023:	6a 00                	push   $0x0
  801025:	e8 78 fd ff ff       	call   800da2 <sys_page_unmap>
  80102a:	83 c4 10             	add    $0x10,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	78 51                	js     801082 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  801031:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801034:	c9                   	leave  
  801035:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  801036:	83 ec 04             	sub    $0x4,%esp
  801039:	68 ec 19 80 00       	push   $0x8019ec
  80103e:	6a 21                	push   $0x21
  801040:	68 74 1a 80 00       	push   $0x801a74
  801045:	e8 f8 f0 ff ff       	call   800142 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  80104a:	83 ec 04             	sub    $0x4,%esp
  80104d:	68 18 1a 80 00       	push   $0x801a18
  801052:	6a 24                	push   $0x24
  801054:	68 74 1a 80 00       	push   $0x801a74
  801059:	e8 e4 f0 ff ff       	call   800142 <_panic>
		panic("sys_page_alloc: %e\n", r);
  80105e:	50                   	push   %eax
  80105f:	68 7f 1a 80 00       	push   $0x801a7f
  801064:	6a 2e                	push   $0x2e
  801066:	68 74 1a 80 00       	push   $0x801a74
  80106b:	e8 d2 f0 ff ff       	call   800142 <_panic>
		panic("sys_page_map: %e\n", r);
  801070:	50                   	push   %eax
  801071:	68 93 1a 80 00       	push   $0x801a93
  801076:	6a 34                	push   $0x34
  801078:	68 74 1a 80 00       	push   $0x801a74
  80107d:	e8 c0 f0 ff ff       	call   800142 <_panic>
		panic("sys_page_unmap: %e\n", r);
  801082:	50                   	push   %eax
  801083:	68 a5 1a 80 00       	push   $0x801aa5
  801088:	6a 37                	push   $0x37
  80108a:	68 74 1a 80 00       	push   $0x801a74
  80108f:	e8 ae f0 ff ff       	call   800142 <_panic>

00801094 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  80109d:	68 90 0f 80 00       	push   $0x800f90
  8010a2:	e8 1a 02 00 00       	call   8012c1 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010a7:	b8 07 00 00 00       	mov    $0x7,%eax
  8010ac:	cd 30                	int    $0x30
  8010ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	78 30                	js     8010e8 <fork+0x54>
  8010b8:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010c3:	0f 85 a5 00 00 00    	jne    80116e <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010c9:	e8 11 fc ff ff       	call   800cdf <sys_getenvid>
  8010ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010d3:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8010d6:	c1 e0 04             	shl    $0x4,%eax
  8010d9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010de:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  8010e3:	e9 75 01 00 00       	jmp    80125d <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  8010e8:	50                   	push   %eax
  8010e9:	68 b9 1a 80 00       	push   $0x801ab9
  8010ee:	68 83 00 00 00       	push   $0x83
  8010f3:	68 74 1a 80 00       	push   $0x801a74
  8010f8:	e8 45 f0 ff ff       	call   800142 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8010fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801104:	83 ec 0c             	sub    $0xc,%esp
  801107:	25 07 0e 00 00       	and    $0xe07,%eax
  80110c:	50                   	push   %eax
  80110d:	56                   	push   %esi
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	6a 00                	push   $0x0
  801112:	e8 49 fc ff ff       	call   800d60 <sys_page_map>
  801117:	83 c4 20             	add    $0x20,%esp
  80111a:	85 c0                	test   %eax,%eax
  80111c:	79 3e                	jns    80115c <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  80111e:	50                   	push   %eax
  80111f:	68 93 1a 80 00       	push   $0x801a93
  801124:	6a 50                	push   $0x50
  801126:	68 74 1a 80 00       	push   $0x801a74
  80112b:	e8 12 f0 ff ff       	call   800142 <_panic>
			panic("sys_page_map: %e\n", r);
  801130:	50                   	push   %eax
  801131:	68 93 1a 80 00       	push   $0x801a93
  801136:	6a 54                	push   $0x54
  801138:	68 74 1a 80 00       	push   $0x801a74
  80113d:	e8 00 f0 ff ff       	call   800142 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	6a 05                	push   $0x5
  801147:	56                   	push   %esi
  801148:	57                   	push   %edi
  801149:	56                   	push   %esi
  80114a:	6a 00                	push   $0x0
  80114c:	e8 0f fc ff ff       	call   800d60 <sys_page_map>
  801151:	83 c4 20             	add    $0x20,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	0f 88 ab 00 00 00    	js     801207 <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  80115c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801162:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801168:	0f 84 ab 00 00 00    	je     801219 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  80116e:	89 d8                	mov    %ebx,%eax
  801170:	c1 e8 16             	shr    $0x16,%eax
  801173:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80117a:	a8 01                	test   $0x1,%al
  80117c:	74 de                	je     80115c <fork+0xc8>
  80117e:	89 d8                	mov    %ebx,%eax
  801180:	c1 e8 0c             	shr    $0xc,%eax
  801183:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80118a:	f6 c2 01             	test   $0x1,%dl
  80118d:	74 cd                	je     80115c <fork+0xc8>
  80118f:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801195:	74 c5                	je     80115c <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  801197:	89 c6                	mov    %eax,%esi
  801199:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  80119c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a3:	f6 c6 04             	test   $0x4,%dh
  8011a6:	0f 85 51 ff ff ff    	jne    8010fd <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  8011ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b3:	a9 02 08 00 00       	test   $0x802,%eax
  8011b8:	74 88                	je     801142 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	68 05 08 00 00       	push   $0x805
  8011c2:	56                   	push   %esi
  8011c3:	57                   	push   %edi
  8011c4:	56                   	push   %esi
  8011c5:	6a 00                	push   $0x0
  8011c7:	e8 94 fb ff ff       	call   800d60 <sys_page_map>
  8011cc:	83 c4 20             	add    $0x20,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	0f 88 59 ff ff ff    	js     801130 <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	68 05 08 00 00       	push   $0x805
  8011df:	56                   	push   %esi
  8011e0:	6a 00                	push   $0x0
  8011e2:	56                   	push   %esi
  8011e3:	6a 00                	push   $0x0
  8011e5:	e8 76 fb ff ff       	call   800d60 <sys_page_map>
  8011ea:	83 c4 20             	add    $0x20,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	0f 89 67 ff ff ff    	jns    80115c <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8011f5:	50                   	push   %eax
  8011f6:	68 93 1a 80 00       	push   $0x801a93
  8011fb:	6a 56                	push   $0x56
  8011fd:	68 74 1a 80 00       	push   $0x801a74
  801202:	e8 3b ef ff ff       	call   800142 <_panic>
			panic("sys_page_map: %e\n", r);
  801207:	50                   	push   %eax
  801208:	68 93 1a 80 00       	push   $0x801a93
  80120d:	6a 5a                	push   $0x5a
  80120f:	68 74 1a 80 00       	push   $0x801a74
  801214:	e8 29 ef ff ff       	call   800142 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	6a 07                	push   $0x7
  80121e:	68 00 f0 bf ee       	push   $0xeebff000
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	e8 f2 fa ff ff       	call   800d1d <sys_page_alloc>
  80122b:	83 c4 10             	add    $0x10,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 36                	js     801268 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	68 2c 13 80 00       	push   $0x80132c
  80123a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80123d:	e8 67 fc ff ff       	call   800ea9 <sys_env_set_pgfault_upcall>
  801242:	83 c4 10             	add    $0x10,%esp
  801245:	85 c0                	test   %eax,%eax
  801247:	78 34                	js     80127d <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	6a 02                	push   $0x2
  80124e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801251:	e8 cf fb ff ff       	call   800e25 <sys_env_set_status>
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	78 35                	js     801292 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  80125d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5f                   	pop    %edi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  801268:	50                   	push   %eax
  801269:	68 7f 1a 80 00       	push   $0x801a7f
  80126e:	68 95 00 00 00       	push   $0x95
  801273:	68 74 1a 80 00       	push   $0x801a74
  801278:	e8 c5 ee ff ff       	call   800142 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  80127d:	50                   	push   %eax
  80127e:	68 54 1a 80 00       	push   $0x801a54
  801283:	68 98 00 00 00       	push   $0x98
  801288:	68 74 1a 80 00       	push   $0x801a74
  80128d:	e8 b0 ee ff ff       	call   800142 <_panic>
		panic("sys_env_set_status: %e\n", r);
  801292:	50                   	push   %eax
  801293:	68 c9 1a 80 00       	push   $0x801ac9
  801298:	68 9b 00 00 00       	push   $0x9b
  80129d:	68 74 1a 80 00       	push   $0x801a74
  8012a2:	e8 9b ee ff ff       	call   800142 <_panic>

008012a7 <sfork>:

// Challenge!
int
sfork(void)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012ad:	68 e1 1a 80 00       	push   $0x801ae1
  8012b2:	68 a4 00 00 00       	push   $0xa4
  8012b7:	68 74 1a 80 00       	push   $0x801a74
  8012bc:	e8 81 ee ff ff       	call   800142 <_panic>

008012c1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8012c7:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  8012ce:	74 0a                	je     8012da <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	6a 07                	push   $0x7
  8012df:	68 00 f0 bf ee       	push   $0xeebff000
  8012e4:	6a 00                	push   $0x0
  8012e6:	e8 32 fa ff ff       	call   800d1d <sys_page_alloc>
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 28                	js     80131a <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8012f2:	83 ec 08             	sub    $0x8,%esp
  8012f5:	68 2c 13 80 00       	push   $0x80132c
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 a8 fb ff ff       	call   800ea9 <sys_env_set_pgfault_upcall>
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	79 c8                	jns    8012d0 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  801308:	50                   	push   %eax
  801309:	68 54 1a 80 00       	push   $0x801a54
  80130e:	6a 23                	push   $0x23
  801310:	68 0f 1b 80 00       	push   $0x801b0f
  801315:	e8 28 ee ff ff       	call   800142 <_panic>
			panic("set_pgfault_handler %e\n",r);
  80131a:	50                   	push   %eax
  80131b:	68 f7 1a 80 00       	push   $0x801af7
  801320:	6a 21                	push   $0x21
  801322:	68 0f 1b 80 00       	push   $0x801b0f
  801327:	e8 16 ee ff ff       	call   800142 <_panic>

0080132c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80132c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80132d:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  801332:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801334:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  801337:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  80133b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80133f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801342:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801344:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801348:	83 c4 08             	add    $0x8,%esp
	popal
  80134b:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80134c:	83 c4 04             	add    $0x4,%esp
	popfl
  80134f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801350:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801351:	c3                   	ret    
  801352:	66 90                	xchg   %ax,%ax
  801354:	66 90                	xchg   %ax,%ax
  801356:	66 90                	xchg   %ax,%ax
  801358:	66 90                	xchg   %ax,%ax
  80135a:	66 90                	xchg   %ax,%ax
  80135c:	66 90                	xchg   %ax,%ax
  80135e:	66 90                	xchg   %ax,%ax

00801360 <__udivdi3>:
  801360:	55                   	push   %ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	83 ec 1c             	sub    $0x1c,%esp
  801367:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80136b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80136f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801373:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801377:	85 d2                	test   %edx,%edx
  801379:	75 4d                	jne    8013c8 <__udivdi3+0x68>
  80137b:	39 f3                	cmp    %esi,%ebx
  80137d:	76 19                	jbe    801398 <__udivdi3+0x38>
  80137f:	31 ff                	xor    %edi,%edi
  801381:	89 e8                	mov    %ebp,%eax
  801383:	89 f2                	mov    %esi,%edx
  801385:	f7 f3                	div    %ebx
  801387:	89 fa                	mov    %edi,%edx
  801389:	83 c4 1c             	add    $0x1c,%esp
  80138c:	5b                   	pop    %ebx
  80138d:	5e                   	pop    %esi
  80138e:	5f                   	pop    %edi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    
  801391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801398:	89 d9                	mov    %ebx,%ecx
  80139a:	85 db                	test   %ebx,%ebx
  80139c:	75 0b                	jne    8013a9 <__udivdi3+0x49>
  80139e:	b8 01 00 00 00       	mov    $0x1,%eax
  8013a3:	31 d2                	xor    %edx,%edx
  8013a5:	f7 f3                	div    %ebx
  8013a7:	89 c1                	mov    %eax,%ecx
  8013a9:	31 d2                	xor    %edx,%edx
  8013ab:	89 f0                	mov    %esi,%eax
  8013ad:	f7 f1                	div    %ecx
  8013af:	89 c6                	mov    %eax,%esi
  8013b1:	89 e8                	mov    %ebp,%eax
  8013b3:	89 f7                	mov    %esi,%edi
  8013b5:	f7 f1                	div    %ecx
  8013b7:	89 fa                	mov    %edi,%edx
  8013b9:	83 c4 1c             	add    $0x1c,%esp
  8013bc:	5b                   	pop    %ebx
  8013bd:	5e                   	pop    %esi
  8013be:	5f                   	pop    %edi
  8013bf:	5d                   	pop    %ebp
  8013c0:	c3                   	ret    
  8013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013c8:	39 f2                	cmp    %esi,%edx
  8013ca:	77 1c                	ja     8013e8 <__udivdi3+0x88>
  8013cc:	0f bd fa             	bsr    %edx,%edi
  8013cf:	83 f7 1f             	xor    $0x1f,%edi
  8013d2:	75 2c                	jne    801400 <__udivdi3+0xa0>
  8013d4:	39 f2                	cmp    %esi,%edx
  8013d6:	72 06                	jb     8013de <__udivdi3+0x7e>
  8013d8:	31 c0                	xor    %eax,%eax
  8013da:	39 eb                	cmp    %ebp,%ebx
  8013dc:	77 a9                	ja     801387 <__udivdi3+0x27>
  8013de:	b8 01 00 00 00       	mov    $0x1,%eax
  8013e3:	eb a2                	jmp    801387 <__udivdi3+0x27>
  8013e5:	8d 76 00             	lea    0x0(%esi),%esi
  8013e8:	31 ff                	xor    %edi,%edi
  8013ea:	31 c0                	xor    %eax,%eax
  8013ec:	89 fa                	mov    %edi,%edx
  8013ee:	83 c4 1c             	add    $0x1c,%esp
  8013f1:	5b                   	pop    %ebx
  8013f2:	5e                   	pop    %esi
  8013f3:	5f                   	pop    %edi
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    
  8013f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013fd:	8d 76 00             	lea    0x0(%esi),%esi
  801400:	89 f9                	mov    %edi,%ecx
  801402:	b8 20 00 00 00       	mov    $0x20,%eax
  801407:	29 f8                	sub    %edi,%eax
  801409:	d3 e2                	shl    %cl,%edx
  80140b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80140f:	89 c1                	mov    %eax,%ecx
  801411:	89 da                	mov    %ebx,%edx
  801413:	d3 ea                	shr    %cl,%edx
  801415:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801419:	09 d1                	or     %edx,%ecx
  80141b:	89 f2                	mov    %esi,%edx
  80141d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801421:	89 f9                	mov    %edi,%ecx
  801423:	d3 e3                	shl    %cl,%ebx
  801425:	89 c1                	mov    %eax,%ecx
  801427:	d3 ea                	shr    %cl,%edx
  801429:	89 f9                	mov    %edi,%ecx
  80142b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80142f:	89 eb                	mov    %ebp,%ebx
  801431:	d3 e6                	shl    %cl,%esi
  801433:	89 c1                	mov    %eax,%ecx
  801435:	d3 eb                	shr    %cl,%ebx
  801437:	09 de                	or     %ebx,%esi
  801439:	89 f0                	mov    %esi,%eax
  80143b:	f7 74 24 08          	divl   0x8(%esp)
  80143f:	89 d6                	mov    %edx,%esi
  801441:	89 c3                	mov    %eax,%ebx
  801443:	f7 64 24 0c          	mull   0xc(%esp)
  801447:	39 d6                	cmp    %edx,%esi
  801449:	72 15                	jb     801460 <__udivdi3+0x100>
  80144b:	89 f9                	mov    %edi,%ecx
  80144d:	d3 e5                	shl    %cl,%ebp
  80144f:	39 c5                	cmp    %eax,%ebp
  801451:	73 04                	jae    801457 <__udivdi3+0xf7>
  801453:	39 d6                	cmp    %edx,%esi
  801455:	74 09                	je     801460 <__udivdi3+0x100>
  801457:	89 d8                	mov    %ebx,%eax
  801459:	31 ff                	xor    %edi,%edi
  80145b:	e9 27 ff ff ff       	jmp    801387 <__udivdi3+0x27>
  801460:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801463:	31 ff                	xor    %edi,%edi
  801465:	e9 1d ff ff ff       	jmp    801387 <__udivdi3+0x27>
  80146a:	66 90                	xchg   %ax,%ax
  80146c:	66 90                	xchg   %ax,%ax
  80146e:	66 90                	xchg   %ax,%ax

00801470 <__umoddi3>:
  801470:	55                   	push   %ebp
  801471:	57                   	push   %edi
  801472:	56                   	push   %esi
  801473:	53                   	push   %ebx
  801474:	83 ec 1c             	sub    $0x1c,%esp
  801477:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80147b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80147f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801483:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801487:	89 da                	mov    %ebx,%edx
  801489:	85 c0                	test   %eax,%eax
  80148b:	75 43                	jne    8014d0 <__umoddi3+0x60>
  80148d:	39 df                	cmp    %ebx,%edi
  80148f:	76 17                	jbe    8014a8 <__umoddi3+0x38>
  801491:	89 f0                	mov    %esi,%eax
  801493:	f7 f7                	div    %edi
  801495:	89 d0                	mov    %edx,%eax
  801497:	31 d2                	xor    %edx,%edx
  801499:	83 c4 1c             	add    $0x1c,%esp
  80149c:	5b                   	pop    %ebx
  80149d:	5e                   	pop    %esi
  80149e:	5f                   	pop    %edi
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    
  8014a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014a8:	89 fd                	mov    %edi,%ebp
  8014aa:	85 ff                	test   %edi,%edi
  8014ac:	75 0b                	jne    8014b9 <__umoddi3+0x49>
  8014ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8014b3:	31 d2                	xor    %edx,%edx
  8014b5:	f7 f7                	div    %edi
  8014b7:	89 c5                	mov    %eax,%ebp
  8014b9:	89 d8                	mov    %ebx,%eax
  8014bb:	31 d2                	xor    %edx,%edx
  8014bd:	f7 f5                	div    %ebp
  8014bf:	89 f0                	mov    %esi,%eax
  8014c1:	f7 f5                	div    %ebp
  8014c3:	89 d0                	mov    %edx,%eax
  8014c5:	eb d0                	jmp    801497 <__umoddi3+0x27>
  8014c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014ce:	66 90                	xchg   %ax,%ax
  8014d0:	89 f1                	mov    %esi,%ecx
  8014d2:	39 d8                	cmp    %ebx,%eax
  8014d4:	76 0a                	jbe    8014e0 <__umoddi3+0x70>
  8014d6:	89 f0                	mov    %esi,%eax
  8014d8:	83 c4 1c             	add    $0x1c,%esp
  8014db:	5b                   	pop    %ebx
  8014dc:	5e                   	pop    %esi
  8014dd:	5f                   	pop    %edi
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    
  8014e0:	0f bd e8             	bsr    %eax,%ebp
  8014e3:	83 f5 1f             	xor    $0x1f,%ebp
  8014e6:	75 20                	jne    801508 <__umoddi3+0x98>
  8014e8:	39 d8                	cmp    %ebx,%eax
  8014ea:	0f 82 b0 00 00 00    	jb     8015a0 <__umoddi3+0x130>
  8014f0:	39 f7                	cmp    %esi,%edi
  8014f2:	0f 86 a8 00 00 00    	jbe    8015a0 <__umoddi3+0x130>
  8014f8:	89 c8                	mov    %ecx,%eax
  8014fa:	83 c4 1c             	add    $0x1c,%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5f                   	pop    %edi
  801500:	5d                   	pop    %ebp
  801501:	c3                   	ret    
  801502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801508:	89 e9                	mov    %ebp,%ecx
  80150a:	ba 20 00 00 00       	mov    $0x20,%edx
  80150f:	29 ea                	sub    %ebp,%edx
  801511:	d3 e0                	shl    %cl,%eax
  801513:	89 44 24 08          	mov    %eax,0x8(%esp)
  801517:	89 d1                	mov    %edx,%ecx
  801519:	89 f8                	mov    %edi,%eax
  80151b:	d3 e8                	shr    %cl,%eax
  80151d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801521:	89 54 24 04          	mov    %edx,0x4(%esp)
  801525:	8b 54 24 04          	mov    0x4(%esp),%edx
  801529:	09 c1                	or     %eax,%ecx
  80152b:	89 d8                	mov    %ebx,%eax
  80152d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801531:	89 e9                	mov    %ebp,%ecx
  801533:	d3 e7                	shl    %cl,%edi
  801535:	89 d1                	mov    %edx,%ecx
  801537:	d3 e8                	shr    %cl,%eax
  801539:	89 e9                	mov    %ebp,%ecx
  80153b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80153f:	d3 e3                	shl    %cl,%ebx
  801541:	89 c7                	mov    %eax,%edi
  801543:	89 d1                	mov    %edx,%ecx
  801545:	89 f0                	mov    %esi,%eax
  801547:	d3 e8                	shr    %cl,%eax
  801549:	89 e9                	mov    %ebp,%ecx
  80154b:	89 fa                	mov    %edi,%edx
  80154d:	d3 e6                	shl    %cl,%esi
  80154f:	09 d8                	or     %ebx,%eax
  801551:	f7 74 24 08          	divl   0x8(%esp)
  801555:	89 d1                	mov    %edx,%ecx
  801557:	89 f3                	mov    %esi,%ebx
  801559:	f7 64 24 0c          	mull   0xc(%esp)
  80155d:	89 c6                	mov    %eax,%esi
  80155f:	89 d7                	mov    %edx,%edi
  801561:	39 d1                	cmp    %edx,%ecx
  801563:	72 06                	jb     80156b <__umoddi3+0xfb>
  801565:	75 10                	jne    801577 <__umoddi3+0x107>
  801567:	39 c3                	cmp    %eax,%ebx
  801569:	73 0c                	jae    801577 <__umoddi3+0x107>
  80156b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80156f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801573:	89 d7                	mov    %edx,%edi
  801575:	89 c6                	mov    %eax,%esi
  801577:	89 ca                	mov    %ecx,%edx
  801579:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80157e:	29 f3                	sub    %esi,%ebx
  801580:	19 fa                	sbb    %edi,%edx
  801582:	89 d0                	mov    %edx,%eax
  801584:	d3 e0                	shl    %cl,%eax
  801586:	89 e9                	mov    %ebp,%ecx
  801588:	d3 eb                	shr    %cl,%ebx
  80158a:	d3 ea                	shr    %cl,%edx
  80158c:	09 d8                	or     %ebx,%eax
  80158e:	83 c4 1c             	add    $0x1c,%esp
  801591:	5b                   	pop    %ebx
  801592:	5e                   	pop    %esi
  801593:	5f                   	pop    %edi
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    
  801596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80159d:	8d 76 00             	lea    0x0(%esi),%esi
  8015a0:	89 da                	mov    %ebx,%edx
  8015a2:	29 fe                	sub    %edi,%esi
  8015a4:	19 c2                	sbb    %eax,%edx
  8015a6:	89 f1                	mov    %esi,%ecx
  8015a8:	89 c8                	mov    %ecx,%eax
  8015aa:	e9 4b ff ff ff       	jmp    8014fa <__umoddi3+0x8a>
