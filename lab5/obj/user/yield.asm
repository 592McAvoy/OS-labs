
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 04 20 80 00       	mov    0x802004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 a0 11 80 00       	push   $0x8011a0
  800048:	e8 3d 01 00 00       	call   80018a <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 11 0c 00 00       	call   800c6b <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 04 20 80 00       	mov    0x802004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 c0 11 80 00       	push   $0x8011c0
  80006c:	e8 19 01 00 00       	call   80018a <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 04 20 80 00       	mov    0x802004,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 ec 11 80 00       	push   $0x8011ec
  80008d:	e8 f8 00 00 00       	call   80018a <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a5:	e8 a2 0b 00 00       	call   800c4c <sys_getenvid>
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000b2:	c1 e0 04             	shl    $0x4,%eax
  8000b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ba:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	85 db                	test   %ebx,%ebx
  8000c1:	7e 07                	jle    8000ca <libmain+0x30>
		binaryname = argv[0];
  8000c3:	8b 06                	mov    (%esi),%eax
  8000c5:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	e8 5f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d4:	e8 0a 00 00 00       	call   8000e3 <exit>
}
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000e9:	6a 00                	push   $0x0
  8000eb:	e8 1b 0b 00 00       	call   800c0b <sys_env_destroy>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	c9                   	leave  
  8000f4:	c3                   	ret    

008000f5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ff:	8b 13                	mov    (%ebx),%edx
  800101:	8d 42 01             	lea    0x1(%edx),%eax
  800104:	89 03                	mov    %eax,(%ebx)
  800106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800109:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800112:	74 09                	je     80011d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800114:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011b:	c9                   	leave  
  80011c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 ff 00 00 00       	push   $0xff
  800125:	8d 43 08             	lea    0x8(%ebx),%eax
  800128:	50                   	push   %eax
  800129:	e8 a0 0a 00 00       	call   800bce <sys_cputs>
		b->idx = 0;
  80012e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	eb db                	jmp    800114 <putch+0x1f>

00800139 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800142:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800149:	00 00 00 
	b.cnt = 0;
  80014c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800153:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800156:	ff 75 0c             	pushl  0xc(%ebp)
  800159:	ff 75 08             	pushl  0x8(%ebp)
  80015c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800162:	50                   	push   %eax
  800163:	68 f5 00 80 00       	push   $0x8000f5
  800168:	e8 4a 01 00 00       	call   8002b7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80016d:	83 c4 08             	add    $0x8,%esp
  800170:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800176:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 4c 0a 00 00       	call   800bce <sys_cputs>

	return b.cnt;
}
  800182:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800188:	c9                   	leave  
  800189:	c3                   	ret    

0080018a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800190:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800193:	50                   	push   %eax
  800194:	ff 75 08             	pushl  0x8(%ebp)
  800197:	e8 9d ff ff ff       	call   800139 <vcprintf>
	va_end(ap);

	return cnt;
}
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	57                   	push   %edi
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	83 ec 1c             	sub    $0x1c,%esp
  8001a7:	89 c6                	mov    %eax,%esi
  8001a9:	89 d7                	mov    %edx,%edi
  8001ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001bd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001c1:	74 2c                	je     8001ef <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001d3:	39 c2                	cmp    %eax,%edx
  8001d5:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001d8:	73 43                	jae    80021d <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001da:	83 eb 01             	sub    $0x1,%ebx
  8001dd:	85 db                	test   %ebx,%ebx
  8001df:	7e 6c                	jle    80024d <printnum+0xaf>
			putch(padc, putdat);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	57                   	push   %edi
  8001e5:	ff 75 18             	pushl  0x18(%ebp)
  8001e8:	ff d6                	call   *%esi
  8001ea:	83 c4 10             	add    $0x10,%esp
  8001ed:	eb eb                	jmp    8001da <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	6a 20                	push   $0x20
  8001f4:	6a 00                	push   $0x0
  8001f6:	50                   	push   %eax
  8001f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fd:	89 fa                	mov    %edi,%edx
  8001ff:	89 f0                	mov    %esi,%eax
  800201:	e8 98 ff ff ff       	call   80019e <printnum>
		while (--width > 0)
  800206:	83 c4 20             	add    $0x20,%esp
  800209:	83 eb 01             	sub    $0x1,%ebx
  80020c:	85 db                	test   %ebx,%ebx
  80020e:	7e 65                	jle    800275 <printnum+0xd7>
			putch(padc, putdat);
  800210:	83 ec 08             	sub    $0x8,%esp
  800213:	57                   	push   %edi
  800214:	6a 20                	push   $0x20
  800216:	ff d6                	call   *%esi
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	eb ec                	jmp    800209 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	ff 75 18             	pushl  0x18(%ebp)
  800223:	83 eb 01             	sub    $0x1,%ebx
  800226:	53                   	push   %ebx
  800227:	50                   	push   %eax
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	ff 75 dc             	pushl  -0x24(%ebp)
  80022e:	ff 75 d8             	pushl  -0x28(%ebp)
  800231:	ff 75 e4             	pushl  -0x1c(%ebp)
  800234:	ff 75 e0             	pushl  -0x20(%ebp)
  800237:	e8 14 0d 00 00       	call   800f50 <__udivdi3>
  80023c:	83 c4 18             	add    $0x18,%esp
  80023f:	52                   	push   %edx
  800240:	50                   	push   %eax
  800241:	89 fa                	mov    %edi,%edx
  800243:	89 f0                	mov    %esi,%eax
  800245:	e8 54 ff ff ff       	call   80019e <printnum>
  80024a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	57                   	push   %edi
  800251:	83 ec 04             	sub    $0x4,%esp
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025d:	ff 75 e0             	pushl  -0x20(%ebp)
  800260:	e8 fb 0d 00 00       	call   801060 <__umoddi3>
  800265:	83 c4 14             	add    $0x14,%esp
  800268:	0f be 80 15 12 80 00 	movsbl 0x801215(%eax),%eax
  80026f:	50                   	push   %eax
  800270:	ff d6                	call   *%esi
  800272:	83 c4 10             	add    $0x10,%esp
}
  800275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800283:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800287:	8b 10                	mov    (%eax),%edx
  800289:	3b 50 04             	cmp    0x4(%eax),%edx
  80028c:	73 0a                	jae    800298 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800291:	89 08                	mov    %ecx,(%eax)
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
  800296:	88 02                	mov    %al,(%edx)
}
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    

0080029a <printfmt>:
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a3:	50                   	push   %eax
  8002a4:	ff 75 10             	pushl  0x10(%ebp)
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	e8 05 00 00 00       	call   8002b7 <vprintfmt>
}
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	c9                   	leave  
  8002b6:	c3                   	ret    

008002b7 <vprintfmt>:
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	57                   	push   %edi
  8002bb:	56                   	push   %esi
  8002bc:	53                   	push   %ebx
  8002bd:	83 ec 3c             	sub    $0x3c,%esp
  8002c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c9:	e9 b4 03 00 00       	jmp    800682 <vprintfmt+0x3cb>
		padc = ' ';
  8002ce:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8002d2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8002d9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ee:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002f3:	8d 47 01             	lea    0x1(%edi),%eax
  8002f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002f9:	0f b6 17             	movzbl (%edi),%edx
  8002fc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ff:	3c 55                	cmp    $0x55,%al
  800301:	0f 87 c8 04 00 00    	ja     8007cf <vprintfmt+0x518>
  800307:	0f b6 c0             	movzbl %al,%eax
  80030a:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  800311:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800314:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80031b:	eb d6                	jmp    8002f3 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800320:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800324:	eb cd                	jmp    8002f3 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800326:	0f b6 d2             	movzbl %dl,%edx
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80032c:	b8 00 00 00 00       	mov    $0x0,%eax
  800331:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800334:	eb 0c                	jmp    800342 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800336:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800339:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80033d:	eb b4                	jmp    8002f3 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80033f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800342:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800345:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800349:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80034c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80034f:	83 f9 09             	cmp    $0x9,%ecx
  800352:	76 eb                	jbe    80033f <vprintfmt+0x88>
  800354:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800357:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035a:	eb 14                	jmp    800370 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80035c:	8b 45 14             	mov    0x14(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800364:	8b 45 14             	mov    0x14(%ebp),%eax
  800367:	8d 40 04             	lea    0x4(%eax),%eax
  80036a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800370:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800374:	0f 89 79 ff ff ff    	jns    8002f3 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80037a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80037d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800380:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800387:	e9 67 ff ff ff       	jmp    8002f3 <vprintfmt+0x3c>
  80038c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038f:	85 c0                	test   %eax,%eax
  800391:	ba 00 00 00 00       	mov    $0x0,%edx
  800396:	0f 49 d0             	cmovns %eax,%edx
  800399:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039f:	e9 4f ff ff ff       	jmp    8002f3 <vprintfmt+0x3c>
  8003a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003ae:	e9 40 ff ff ff       	jmp    8002f3 <vprintfmt+0x3c>
			lflag++;
  8003b3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b9:	e9 35 ff ff ff       	jmp    8002f3 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 78 04             	lea    0x4(%eax),%edi
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	53                   	push   %ebx
  8003c8:	ff 30                	pushl  (%eax)
  8003ca:	ff d6                	call   *%esi
			break;
  8003cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003cf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d2:	e9 a8 02 00 00       	jmp    80067f <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8d 78 04             	lea    0x4(%eax),%edi
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	99                   	cltd   
  8003e0:	31 d0                	xor    %edx,%eax
  8003e2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e4:	83 f8 0f             	cmp    $0xf,%eax
  8003e7:	7f 23                	jg     80040c <vprintfmt+0x155>
  8003e9:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  8003f0:	85 d2                	test   %edx,%edx
  8003f2:	74 18                	je     80040c <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8003f4:	52                   	push   %edx
  8003f5:	68 36 12 80 00       	push   $0x801236
  8003fa:	53                   	push   %ebx
  8003fb:	56                   	push   %esi
  8003fc:	e8 99 fe ff ff       	call   80029a <printfmt>
  800401:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800404:	89 7d 14             	mov    %edi,0x14(%ebp)
  800407:	e9 73 02 00 00       	jmp    80067f <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80040c:	50                   	push   %eax
  80040d:	68 2d 12 80 00       	push   $0x80122d
  800412:	53                   	push   %ebx
  800413:	56                   	push   %esi
  800414:	e8 81 fe ff ff       	call   80029a <printfmt>
  800419:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80041f:	e9 5b 02 00 00       	jmp    80067f <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	83 c0 04             	add    $0x4,%eax
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80042d:	8b 45 14             	mov    0x14(%ebp),%eax
  800430:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800432:	85 d2                	test   %edx,%edx
  800434:	b8 26 12 80 00       	mov    $0x801226,%eax
  800439:	0f 45 c2             	cmovne %edx,%eax
  80043c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80043f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800443:	7e 06                	jle    80044b <vprintfmt+0x194>
  800445:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800449:	75 0d                	jne    800458 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80044e:	89 c7                	mov    %eax,%edi
  800450:	03 45 e0             	add    -0x20(%ebp),%eax
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800456:	eb 53                	jmp    8004ab <vprintfmt+0x1f4>
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 d8             	pushl  -0x28(%ebp)
  80045e:	50                   	push   %eax
  80045f:	e8 13 04 00 00       	call   800877 <strnlen>
  800464:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800467:	29 c1                	sub    %eax,%ecx
  800469:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800471:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800475:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800478:	eb 0f                	jmp    800489 <vprintfmt+0x1d2>
					putch(padc, putdat);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	53                   	push   %ebx
  80047e:	ff 75 e0             	pushl  -0x20(%ebp)
  800481:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800483:	83 ef 01             	sub    $0x1,%edi
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	85 ff                	test   %edi,%edi
  80048b:	7f ed                	jg     80047a <vprintfmt+0x1c3>
  80048d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800490:	85 d2                	test   %edx,%edx
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
  800497:	0f 49 c2             	cmovns %edx,%eax
  80049a:	29 c2                	sub    %eax,%edx
  80049c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80049f:	eb aa                	jmp    80044b <vprintfmt+0x194>
					putch(ch, putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	52                   	push   %edx
  8004a6:	ff d6                	call   *%esi
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ae:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b0:	83 c7 01             	add    $0x1,%edi
  8004b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b7:	0f be d0             	movsbl %al,%edx
  8004ba:	85 d2                	test   %edx,%edx
  8004bc:	74 4b                	je     800509 <vprintfmt+0x252>
  8004be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c2:	78 06                	js     8004ca <vprintfmt+0x213>
  8004c4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004c8:	78 1e                	js     8004e8 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004ce:	74 d1                	je     8004a1 <vprintfmt+0x1ea>
  8004d0:	0f be c0             	movsbl %al,%eax
  8004d3:	83 e8 20             	sub    $0x20,%eax
  8004d6:	83 f8 5e             	cmp    $0x5e,%eax
  8004d9:	76 c6                	jbe    8004a1 <vprintfmt+0x1ea>
					putch('?', putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	53                   	push   %ebx
  8004df:	6a 3f                	push   $0x3f
  8004e1:	ff d6                	call   *%esi
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	eb c3                	jmp    8004ab <vprintfmt+0x1f4>
  8004e8:	89 cf                	mov    %ecx,%edi
  8004ea:	eb 0e                	jmp    8004fa <vprintfmt+0x243>
				putch(' ', putdat);
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	53                   	push   %ebx
  8004f0:	6a 20                	push   $0x20
  8004f2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f4:	83 ef 01             	sub    $0x1,%edi
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	85 ff                	test   %edi,%edi
  8004fc:	7f ee                	jg     8004ec <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8004fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800501:	89 45 14             	mov    %eax,0x14(%ebp)
  800504:	e9 76 01 00 00       	jmp    80067f <vprintfmt+0x3c8>
  800509:	89 cf                	mov    %ecx,%edi
  80050b:	eb ed                	jmp    8004fa <vprintfmt+0x243>
	if (lflag >= 2)
  80050d:	83 f9 01             	cmp    $0x1,%ecx
  800510:	7f 1f                	jg     800531 <vprintfmt+0x27a>
	else if (lflag)
  800512:	85 c9                	test   %ecx,%ecx
  800514:	74 6a                	je     800580 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051e:	89 c1                	mov    %eax,%ecx
  800520:	c1 f9 1f             	sar    $0x1f,%ecx
  800523:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8d 40 04             	lea    0x4(%eax),%eax
  80052c:	89 45 14             	mov    %eax,0x14(%ebp)
  80052f:	eb 17                	jmp    800548 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8b 50 04             	mov    0x4(%eax),%edx
  800537:	8b 00                	mov    (%eax),%eax
  800539:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8d 40 08             	lea    0x8(%eax),%eax
  800545:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800548:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80054b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800550:	85 d2                	test   %edx,%edx
  800552:	0f 89 f8 00 00 00    	jns    800650 <vprintfmt+0x399>
				putch('-', putdat);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	53                   	push   %ebx
  80055c:	6a 2d                	push   $0x2d
  80055e:	ff d6                	call   *%esi
				num = -(long long) num;
  800560:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800563:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800566:	f7 d8                	neg    %eax
  800568:	83 d2 00             	adc    $0x0,%edx
  80056b:	f7 da                	neg    %edx
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800573:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800576:	bf 0a 00 00 00       	mov    $0xa,%edi
  80057b:	e9 e1 00 00 00       	jmp    800661 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800588:	99                   	cltd   
  800589:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
  800595:	eb b1                	jmp    800548 <vprintfmt+0x291>
	if (lflag >= 2)
  800597:	83 f9 01             	cmp    $0x1,%ecx
  80059a:	7f 27                	jg     8005c3 <vprintfmt+0x30c>
	else if (lflag)
  80059c:	85 c9                	test   %ecx,%ecx
  80059e:	74 41                	je     8005e1 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8d 40 04             	lea    0x4(%eax),%eax
  8005b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005be:	e9 8d 00 00 00       	jmp    800650 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8b 50 04             	mov    0x4(%eax),%edx
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8d 40 08             	lea    0x8(%eax),%eax
  8005d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005da:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005df:	eb 6f                	jmp    800650 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8d 40 04             	lea    0x4(%eax),%eax
  8005f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fa:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005ff:	eb 4f                	jmp    800650 <vprintfmt+0x399>
	if (lflag >= 2)
  800601:	83 f9 01             	cmp    $0x1,%ecx
  800604:	7f 23                	jg     800629 <vprintfmt+0x372>
	else if (lflag)
  800606:	85 c9                	test   %ecx,%ecx
  800608:	0f 84 98 00 00 00    	je     8006a6 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
  800627:	eb 17                	jmp    800640 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8b 50 04             	mov    0x4(%eax),%edx
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800634:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8d 40 08             	lea    0x8(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	53                   	push   %ebx
  800644:	6a 30                	push   $0x30
  800646:	ff d6                	call   *%esi
			goto number;
  800648:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80064b:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800650:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800654:	74 0b                	je     800661 <vprintfmt+0x3aa>
				putch('+', putdat);
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	53                   	push   %ebx
  80065a:	6a 2b                	push   $0x2b
  80065c:	ff d6                	call   *%esi
  80065e:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800668:	50                   	push   %eax
  800669:	ff 75 e0             	pushl  -0x20(%ebp)
  80066c:	57                   	push   %edi
  80066d:	ff 75 dc             	pushl  -0x24(%ebp)
  800670:	ff 75 d8             	pushl  -0x28(%ebp)
  800673:	89 da                	mov    %ebx,%edx
  800675:	89 f0                	mov    %esi,%eax
  800677:	e8 22 fb ff ff       	call   80019e <printnum>
			break;
  80067c:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80067f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800682:	83 c7 01             	add    $0x1,%edi
  800685:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800689:	83 f8 25             	cmp    $0x25,%eax
  80068c:	0f 84 3c fc ff ff    	je     8002ce <vprintfmt+0x17>
			if (ch == '\0')
  800692:	85 c0                	test   %eax,%eax
  800694:	0f 84 55 01 00 00    	je     8007ef <vprintfmt+0x538>
			putch(ch, putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	53                   	push   %ebx
  80069e:	50                   	push   %eax
  80069f:	ff d6                	call   *%esi
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	eb dc                	jmp    800682 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bf:	e9 7c ff ff ff       	jmp    800640 <vprintfmt+0x389>
			putch('0', putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	6a 30                	push   $0x30
  8006ca:	ff d6                	call   *%esi
			putch('x', putdat);
  8006cc:	83 c4 08             	add    $0x8,%esp
  8006cf:	53                   	push   %ebx
  8006d0:	6a 78                	push   $0x78
  8006d2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006e4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f0:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8006f5:	e9 56 ff ff ff       	jmp    800650 <vprintfmt+0x399>
	if (lflag >= 2)
  8006fa:	83 f9 01             	cmp    $0x1,%ecx
  8006fd:	7f 27                	jg     800726 <vprintfmt+0x46f>
	else if (lflag)
  8006ff:	85 c9                	test   %ecx,%ecx
  800701:	74 44                	je     800747 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	ba 00 00 00 00       	mov    $0x0,%edx
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 40 04             	lea    0x4(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071c:	bf 10 00 00 00       	mov    $0x10,%edi
  800721:	e9 2a ff ff ff       	jmp    800650 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 50 04             	mov    0x4(%eax),%edx
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800731:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8d 40 08             	lea    0x8(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073d:	bf 10 00 00 00       	mov    $0x10,%edi
  800742:	e9 09 ff ff ff       	jmp    800650 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800754:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8d 40 04             	lea    0x4(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800760:	bf 10 00 00 00       	mov    $0x10,%edi
  800765:	e9 e6 fe ff ff       	jmp    800650 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8d 78 04             	lea    0x4(%eax),%edi
  800770:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800772:	85 c0                	test   %eax,%eax
  800774:	74 2d                	je     8007a3 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800776:	0f b6 13             	movzbl (%ebx),%edx
  800779:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80077b:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  80077e:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800781:	0f 8e f8 fe ff ff    	jle    80067f <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800787:	68 84 13 80 00       	push   $0x801384
  80078c:	68 36 12 80 00       	push   $0x801236
  800791:	53                   	push   %ebx
  800792:	56                   	push   %esi
  800793:	e8 02 fb ff ff       	call   80029a <printfmt>
  800798:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80079b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80079e:	e9 dc fe ff ff       	jmp    80067f <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8007a3:	68 4c 13 80 00       	push   $0x80134c
  8007a8:	68 36 12 80 00       	push   $0x801236
  8007ad:	53                   	push   %ebx
  8007ae:	56                   	push   %esi
  8007af:	e8 e6 fa ff ff       	call   80029a <printfmt>
  8007b4:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007b7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007ba:	e9 c0 fe ff ff       	jmp    80067f <vprintfmt+0x3c8>
			putch(ch, putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	6a 25                	push   $0x25
  8007c5:	ff d6                	call   *%esi
			break;
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	e9 b0 fe ff ff       	jmp    80067f <vprintfmt+0x3c8>
			putch('%', putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	53                   	push   %ebx
  8007d3:	6a 25                	push   $0x25
  8007d5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 f8                	mov    %edi,%eax
  8007dc:	eb 03                	jmp    8007e1 <vprintfmt+0x52a>
  8007de:	83 e8 01             	sub    $0x1,%eax
  8007e1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007e5:	75 f7                	jne    8007de <vprintfmt+0x527>
  8007e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ea:	e9 90 fe ff ff       	jmp    80067f <vprintfmt+0x3c8>
}
  8007ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f2:	5b                   	pop    %ebx
  8007f3:	5e                   	pop    %esi
  8007f4:	5f                   	pop    %edi
  8007f5:	5d                   	pop    %ebp
  8007f6:	c3                   	ret    

008007f7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	83 ec 18             	sub    $0x18,%esp
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800803:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800806:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80080a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80080d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800814:	85 c0                	test   %eax,%eax
  800816:	74 26                	je     80083e <vsnprintf+0x47>
  800818:	85 d2                	test   %edx,%edx
  80081a:	7e 22                	jle    80083e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80081c:	ff 75 14             	pushl  0x14(%ebp)
  80081f:	ff 75 10             	pushl  0x10(%ebp)
  800822:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800825:	50                   	push   %eax
  800826:	68 7d 02 80 00       	push   $0x80027d
  80082b:	e8 87 fa ff ff       	call   8002b7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800833:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800839:	83 c4 10             	add    $0x10,%esp
}
  80083c:	c9                   	leave  
  80083d:	c3                   	ret    
		return -E_INVAL;
  80083e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800843:	eb f7                	jmp    80083c <vsnprintf+0x45>

00800845 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80084b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80084e:	50                   	push   %eax
  80084f:	ff 75 10             	pushl  0x10(%ebp)
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	ff 75 08             	pushl  0x8(%ebp)
  800858:	e8 9a ff ff ff       	call   8007f7 <vsnprintf>
	va_end(ap);

	return rc;
}
  80085d:	c9                   	leave  
  80085e:	c3                   	ret    

0080085f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800865:	b8 00 00 00 00       	mov    $0x0,%eax
  80086a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80086e:	74 05                	je     800875 <strlen+0x16>
		n++;
  800870:	83 c0 01             	add    $0x1,%eax
  800873:	eb f5                	jmp    80086a <strlen+0xb>
	return n;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800880:	ba 00 00 00 00       	mov    $0x0,%edx
  800885:	39 c2                	cmp    %eax,%edx
  800887:	74 0d                	je     800896 <strnlen+0x1f>
  800889:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80088d:	74 05                	je     800894 <strnlen+0x1d>
		n++;
  80088f:	83 c2 01             	add    $0x1,%edx
  800892:	eb f1                	jmp    800885 <strnlen+0xe>
  800894:	89 d0                	mov    %edx,%eax
	return n;
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	53                   	push   %ebx
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ab:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ae:	83 c2 01             	add    $0x1,%edx
  8008b1:	84 c9                	test   %cl,%cl
  8008b3:	75 f2                	jne    8008a7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008b5:	5b                   	pop    %ebx
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	83 ec 10             	sub    $0x10,%esp
  8008bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c2:	53                   	push   %ebx
  8008c3:	e8 97 ff ff ff       	call   80085f <strlen>
  8008c8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	01 d8                	add    %ebx,%eax
  8008d0:	50                   	push   %eax
  8008d1:	e8 c2 ff ff ff       	call   800898 <strcpy>
	return dst;
}
  8008d6:	89 d8                	mov    %ebx,%eax
  8008d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	56                   	push   %esi
  8008e1:	53                   	push   %ebx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e8:	89 c6                	mov    %eax,%esi
  8008ea:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ed:	89 c2                	mov    %eax,%edx
  8008ef:	39 f2                	cmp    %esi,%edx
  8008f1:	74 11                	je     800904 <strncpy+0x27>
		*dst++ = *src;
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	0f b6 19             	movzbl (%ecx),%ebx
  8008f9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008fc:	80 fb 01             	cmp    $0x1,%bl
  8008ff:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800902:	eb eb                	jmp    8008ef <strncpy+0x12>
	}
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5e                   	pop    %esi
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	56                   	push   %esi
  80090c:	53                   	push   %ebx
  80090d:	8b 75 08             	mov    0x8(%ebp),%esi
  800910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800913:	8b 55 10             	mov    0x10(%ebp),%edx
  800916:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800918:	85 d2                	test   %edx,%edx
  80091a:	74 21                	je     80093d <strlcpy+0x35>
  80091c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800920:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800922:	39 c2                	cmp    %eax,%edx
  800924:	74 14                	je     80093a <strlcpy+0x32>
  800926:	0f b6 19             	movzbl (%ecx),%ebx
  800929:	84 db                	test   %bl,%bl
  80092b:	74 0b                	je     800938 <strlcpy+0x30>
			*dst++ = *src++;
  80092d:	83 c1 01             	add    $0x1,%ecx
  800930:	83 c2 01             	add    $0x1,%edx
  800933:	88 5a ff             	mov    %bl,-0x1(%edx)
  800936:	eb ea                	jmp    800922 <strlcpy+0x1a>
  800938:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80093a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80093d:	29 f0                	sub    %esi,%eax
}
  80093f:	5b                   	pop    %ebx
  800940:	5e                   	pop    %esi
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    

00800943 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80094c:	0f b6 01             	movzbl (%ecx),%eax
  80094f:	84 c0                	test   %al,%al
  800951:	74 0c                	je     80095f <strcmp+0x1c>
  800953:	3a 02                	cmp    (%edx),%al
  800955:	75 08                	jne    80095f <strcmp+0x1c>
		p++, q++;
  800957:	83 c1 01             	add    $0x1,%ecx
  80095a:	83 c2 01             	add    $0x1,%edx
  80095d:	eb ed                	jmp    80094c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80095f:	0f b6 c0             	movzbl %al,%eax
  800962:	0f b6 12             	movzbl (%edx),%edx
  800965:	29 d0                	sub    %edx,%eax
}
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
  800973:	89 c3                	mov    %eax,%ebx
  800975:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800978:	eb 06                	jmp    800980 <strncmp+0x17>
		n--, p++, q++;
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800980:	39 d8                	cmp    %ebx,%eax
  800982:	74 16                	je     80099a <strncmp+0x31>
  800984:	0f b6 08             	movzbl (%eax),%ecx
  800987:	84 c9                	test   %cl,%cl
  800989:	74 04                	je     80098f <strncmp+0x26>
  80098b:	3a 0a                	cmp    (%edx),%cl
  80098d:	74 eb                	je     80097a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80098f:	0f b6 00             	movzbl (%eax),%eax
  800992:	0f b6 12             	movzbl (%edx),%edx
  800995:	29 d0                	sub    %edx,%eax
}
  800997:	5b                   	pop    %ebx
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    
		return 0;
  80099a:	b8 00 00 00 00       	mov    $0x0,%eax
  80099f:	eb f6                	jmp    800997 <strncmp+0x2e>

008009a1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ab:	0f b6 10             	movzbl (%eax),%edx
  8009ae:	84 d2                	test   %dl,%dl
  8009b0:	74 09                	je     8009bb <strchr+0x1a>
		if (*s == c)
  8009b2:	38 ca                	cmp    %cl,%dl
  8009b4:	74 0a                	je     8009c0 <strchr+0x1f>
	for (; *s; s++)
  8009b6:	83 c0 01             	add    $0x1,%eax
  8009b9:	eb f0                	jmp    8009ab <strchr+0xa>
			return (char *) s;
	return 0;
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009cc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009cf:	38 ca                	cmp    %cl,%dl
  8009d1:	74 09                	je     8009dc <strfind+0x1a>
  8009d3:	84 d2                	test   %dl,%dl
  8009d5:	74 05                	je     8009dc <strfind+0x1a>
	for (; *s; s++)
  8009d7:	83 c0 01             	add    $0x1,%eax
  8009da:	eb f0                	jmp    8009cc <strfind+0xa>
			break;
	return (char *) s;
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	57                   	push   %edi
  8009e2:	56                   	push   %esi
  8009e3:	53                   	push   %ebx
  8009e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ea:	85 c9                	test   %ecx,%ecx
  8009ec:	74 31                	je     800a1f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ee:	89 f8                	mov    %edi,%eax
  8009f0:	09 c8                	or     %ecx,%eax
  8009f2:	a8 03                	test   $0x3,%al
  8009f4:	75 23                	jne    800a19 <memset+0x3b>
		c &= 0xFF;
  8009f6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009fa:	89 d3                	mov    %edx,%ebx
  8009fc:	c1 e3 08             	shl    $0x8,%ebx
  8009ff:	89 d0                	mov    %edx,%eax
  800a01:	c1 e0 18             	shl    $0x18,%eax
  800a04:	89 d6                	mov    %edx,%esi
  800a06:	c1 e6 10             	shl    $0x10,%esi
  800a09:	09 f0                	or     %esi,%eax
  800a0b:	09 c2                	or     %eax,%edx
  800a0d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a0f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	fc                   	cld    
  800a15:	f3 ab                	rep stos %eax,%es:(%edi)
  800a17:	eb 06                	jmp    800a1f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	fc                   	cld    
  800a1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a1f:	89 f8                	mov    %edi,%eax
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5f                   	pop    %edi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	57                   	push   %edi
  800a2a:	56                   	push   %esi
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a34:	39 c6                	cmp    %eax,%esi
  800a36:	73 32                	jae    800a6a <memmove+0x44>
  800a38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a3b:	39 c2                	cmp    %eax,%edx
  800a3d:	76 2b                	jbe    800a6a <memmove+0x44>
		s += n;
		d += n;
  800a3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a42:	89 fe                	mov    %edi,%esi
  800a44:	09 ce                	or     %ecx,%esi
  800a46:	09 d6                	or     %edx,%esi
  800a48:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4e:	75 0e                	jne    800a5e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a50:	83 ef 04             	sub    $0x4,%edi
  800a53:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a56:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a59:	fd                   	std    
  800a5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5c:	eb 09                	jmp    800a67 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a5e:	83 ef 01             	sub    $0x1,%edi
  800a61:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a64:	fd                   	std    
  800a65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a67:	fc                   	cld    
  800a68:	eb 1a                	jmp    800a84 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6a:	89 c2                	mov    %eax,%edx
  800a6c:	09 ca                	or     %ecx,%edx
  800a6e:	09 f2                	or     %esi,%edx
  800a70:	f6 c2 03             	test   $0x3,%dl
  800a73:	75 0a                	jne    800a7f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a78:	89 c7                	mov    %eax,%edi
  800a7a:	fc                   	cld    
  800a7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7d:	eb 05                	jmp    800a84 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a7f:	89 c7                	mov    %eax,%edi
  800a81:	fc                   	cld    
  800a82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a84:	5e                   	pop    %esi
  800a85:	5f                   	pop    %edi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a8e:	ff 75 10             	pushl  0x10(%ebp)
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	e8 8a ff ff ff       	call   800a26 <memmove>
}
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    

00800a9e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	56                   	push   %esi
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa9:	89 c6                	mov    %eax,%esi
  800aab:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aae:	39 f0                	cmp    %esi,%eax
  800ab0:	74 1c                	je     800ace <memcmp+0x30>
		if (*s1 != *s2)
  800ab2:	0f b6 08             	movzbl (%eax),%ecx
  800ab5:	0f b6 1a             	movzbl (%edx),%ebx
  800ab8:	38 d9                	cmp    %bl,%cl
  800aba:	75 08                	jne    800ac4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800abc:	83 c0 01             	add    $0x1,%eax
  800abf:	83 c2 01             	add    $0x1,%edx
  800ac2:	eb ea                	jmp    800aae <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ac4:	0f b6 c1             	movzbl %cl,%eax
  800ac7:	0f b6 db             	movzbl %bl,%ebx
  800aca:	29 d8                	sub    %ebx,%eax
  800acc:	eb 05                	jmp    800ad3 <memcmp+0x35>
	}

	return 0;
  800ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad3:	5b                   	pop    %ebx
  800ad4:	5e                   	pop    %esi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae5:	39 d0                	cmp    %edx,%eax
  800ae7:	73 09                	jae    800af2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae9:	38 08                	cmp    %cl,(%eax)
  800aeb:	74 05                	je     800af2 <memfind+0x1b>
	for (; s < ends; s++)
  800aed:	83 c0 01             	add    $0x1,%eax
  800af0:	eb f3                	jmp    800ae5 <memfind+0xe>
			break;
	return (void *) s;
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b00:	eb 03                	jmp    800b05 <strtol+0x11>
		s++;
  800b02:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b05:	0f b6 01             	movzbl (%ecx),%eax
  800b08:	3c 20                	cmp    $0x20,%al
  800b0a:	74 f6                	je     800b02 <strtol+0xe>
  800b0c:	3c 09                	cmp    $0x9,%al
  800b0e:	74 f2                	je     800b02 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b10:	3c 2b                	cmp    $0x2b,%al
  800b12:	74 2a                	je     800b3e <strtol+0x4a>
	int neg = 0;
  800b14:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b19:	3c 2d                	cmp    $0x2d,%al
  800b1b:	74 2b                	je     800b48 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b23:	75 0f                	jne    800b34 <strtol+0x40>
  800b25:	80 39 30             	cmpb   $0x30,(%ecx)
  800b28:	74 28                	je     800b52 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b2a:	85 db                	test   %ebx,%ebx
  800b2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b31:	0f 44 d8             	cmove  %eax,%ebx
  800b34:	b8 00 00 00 00       	mov    $0x0,%eax
  800b39:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b3c:	eb 50                	jmp    800b8e <strtol+0x9a>
		s++;
  800b3e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b41:	bf 00 00 00 00       	mov    $0x0,%edi
  800b46:	eb d5                	jmp    800b1d <strtol+0x29>
		s++, neg = 1;
  800b48:	83 c1 01             	add    $0x1,%ecx
  800b4b:	bf 01 00 00 00       	mov    $0x1,%edi
  800b50:	eb cb                	jmp    800b1d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b52:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b56:	74 0e                	je     800b66 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	75 d8                	jne    800b34 <strtol+0x40>
		s++, base = 8;
  800b5c:	83 c1 01             	add    $0x1,%ecx
  800b5f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b64:	eb ce                	jmp    800b34 <strtol+0x40>
		s += 2, base = 16;
  800b66:	83 c1 02             	add    $0x2,%ecx
  800b69:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b6e:	eb c4                	jmp    800b34 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b70:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b73:	89 f3                	mov    %esi,%ebx
  800b75:	80 fb 19             	cmp    $0x19,%bl
  800b78:	77 29                	ja     800ba3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b7a:	0f be d2             	movsbl %dl,%edx
  800b7d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b80:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b83:	7d 30                	jge    800bb5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b85:	83 c1 01             	add    $0x1,%ecx
  800b88:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b8c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b8e:	0f b6 11             	movzbl (%ecx),%edx
  800b91:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b94:	89 f3                	mov    %esi,%ebx
  800b96:	80 fb 09             	cmp    $0x9,%bl
  800b99:	77 d5                	ja     800b70 <strtol+0x7c>
			dig = *s - '0';
  800b9b:	0f be d2             	movsbl %dl,%edx
  800b9e:	83 ea 30             	sub    $0x30,%edx
  800ba1:	eb dd                	jmp    800b80 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ba3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ba6:	89 f3                	mov    %esi,%ebx
  800ba8:	80 fb 19             	cmp    $0x19,%bl
  800bab:	77 08                	ja     800bb5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bad:	0f be d2             	movsbl %dl,%edx
  800bb0:	83 ea 37             	sub    $0x37,%edx
  800bb3:	eb cb                	jmp    800b80 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb9:	74 05                	je     800bc0 <strtol+0xcc>
		*endptr = (char *) s;
  800bbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bc0:	89 c2                	mov    %eax,%edx
  800bc2:	f7 da                	neg    %edx
  800bc4:	85 ff                	test   %edi,%edi
  800bc6:	0f 45 c2             	cmovne %edx,%eax
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdf:	89 c3                	mov    %eax,%ebx
  800be1:	89 c7                	mov    %eax,%edi
  800be3:	89 c6                	mov    %eax,%esi
  800be5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be7:	5b                   	pop    %ebx
  800be8:	5e                   	pop    %esi
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <sys_cgetc>:

int
sys_cgetc(void)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	57                   	push   %edi
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfc:	89 d1                	mov    %edx,%ecx
  800bfe:	89 d3                	mov    %edx,%ebx
  800c00:	89 d7                	mov    %edx,%edi
  800c02:	89 d6                	mov    %edx,%esi
  800c04:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c21:	89 cb                	mov    %ecx,%ebx
  800c23:	89 cf                	mov    %ecx,%edi
  800c25:	89 ce                	mov    %ecx,%esi
  800c27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c29:	85 c0                	test   %eax,%eax
  800c2b:	7f 08                	jg     800c35 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c35:	83 ec 0c             	sub    $0xc,%esp
  800c38:	50                   	push   %eax
  800c39:	6a 03                	push   $0x3
  800c3b:	68 a0 15 80 00       	push   $0x8015a0
  800c40:	6a 33                	push   $0x33
  800c42:	68 bd 15 80 00       	push   $0x8015bd
  800c47:	e8 b1 02 00 00       	call   800efd <_panic>

00800c4c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c52:	ba 00 00 00 00       	mov    $0x0,%edx
  800c57:	b8 02 00 00 00       	mov    $0x2,%eax
  800c5c:	89 d1                	mov    %edx,%ecx
  800c5e:	89 d3                	mov    %edx,%ebx
  800c60:	89 d7                	mov    %edx,%edi
  800c62:	89 d6                	mov    %edx,%esi
  800c64:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <sys_yield>:

void
sys_yield(void)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	ba 00 00 00 00       	mov    $0x0,%edx
  800c76:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c7b:	89 d1                	mov    %edx,%ecx
  800c7d:	89 d3                	mov    %edx,%ebx
  800c7f:	89 d7                	mov    %edx,%edi
  800c81:	89 d6                	mov    %edx,%esi
  800c83:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c93:	be 00 00 00 00       	mov    $0x0,%esi
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9e:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca6:	89 f7                	mov    %esi,%edi
  800ca8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 04                	push   $0x4
  800cbc:	68 a0 15 80 00       	push   $0x8015a0
  800cc1:	6a 33                	push   $0x33
  800cc3:	68 bd 15 80 00       	push   $0x8015bd
  800cc8:	e8 30 02 00 00       	call   800efd <_panic>

00800ccd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce7:	8b 75 18             	mov    0x18(%ebp),%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 05                	push   $0x5
  800cfe:	68 a0 15 80 00       	push   $0x8015a0
  800d03:	6a 33                	push   $0x33
  800d05:	68 bd 15 80 00       	push   $0x8015bd
  800d0a:	e8 ee 01 00 00       	call   800efd <_panic>

00800d0f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d23:	b8 06 00 00 00       	mov    $0x6,%eax
  800d28:	89 df                	mov    %ebx,%edi
  800d2a:	89 de                	mov    %ebx,%esi
  800d2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 06                	push   $0x6
  800d40:	68 a0 15 80 00       	push   $0x8015a0
  800d45:	6a 33                	push   $0x33
  800d47:	68 bd 15 80 00       	push   $0x8015bd
  800d4c:	e8 ac 01 00 00       	call   800efd <_panic>

00800d51 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d62:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d67:	89 cb                	mov    %ecx,%ebx
  800d69:	89 cf                	mov    %ecx,%edi
  800d6b:	89 ce                	mov    %ecx,%esi
  800d6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6f:	85 c0                	test   %eax,%eax
  800d71:	7f 08                	jg     800d7b <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7b:	83 ec 0c             	sub    $0xc,%esp
  800d7e:	50                   	push   %eax
  800d7f:	6a 0b                	push   $0xb
  800d81:	68 a0 15 80 00       	push   $0x8015a0
  800d86:	6a 33                	push   $0x33
  800d88:	68 bd 15 80 00       	push   $0x8015bd
  800d8d:	e8 6b 01 00 00       	call   800efd <_panic>

00800d92 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
  800d98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	b8 08 00 00 00       	mov    $0x8,%eax
  800dab:	89 df                	mov    %ebx,%edi
  800dad:	89 de                	mov    %ebx,%esi
  800daf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db1:	85 c0                	test   %eax,%eax
  800db3:	7f 08                	jg     800dbd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbd:	83 ec 0c             	sub    $0xc,%esp
  800dc0:	50                   	push   %eax
  800dc1:	6a 08                	push   $0x8
  800dc3:	68 a0 15 80 00       	push   $0x8015a0
  800dc8:	6a 33                	push   $0x33
  800dca:	68 bd 15 80 00       	push   $0x8015bd
  800dcf:	e8 29 01 00 00       	call   800efd <_panic>

00800dd4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	53                   	push   %ebx
  800dda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de8:	b8 09 00 00 00       	mov    $0x9,%eax
  800ded:	89 df                	mov    %ebx,%edi
  800def:	89 de                	mov    %ebx,%esi
  800df1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df3:	85 c0                	test   %eax,%eax
  800df5:	7f 08                	jg     800dff <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dff:	83 ec 0c             	sub    $0xc,%esp
  800e02:	50                   	push   %eax
  800e03:	6a 09                	push   $0x9
  800e05:	68 a0 15 80 00       	push   $0x8015a0
  800e0a:	6a 33                	push   $0x33
  800e0c:	68 bd 15 80 00       	push   $0x8015bd
  800e11:	e8 e7 00 00 00       	call   800efd <_panic>

00800e16 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2f:	89 df                	mov    %ebx,%edi
  800e31:	89 de                	mov    %ebx,%esi
  800e33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e35:	85 c0                	test   %eax,%eax
  800e37:	7f 08                	jg     800e41 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	50                   	push   %eax
  800e45:	6a 0a                	push   $0xa
  800e47:	68 a0 15 80 00       	push   $0x8015a0
  800e4c:	6a 33                	push   $0x33
  800e4e:	68 bd 15 80 00       	push   $0x8015bd
  800e53:	e8 a5 00 00 00       	call   800efd <_panic>

00800e58 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e69:	be 00 00 00 00       	mov    $0x0,%esi
  800e6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e71:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e74:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
  800e81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e91:	89 cb                	mov    %ecx,%ebx
  800e93:	89 cf                	mov    %ecx,%edi
  800e95:	89 ce                	mov    %ecx,%esi
  800e97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7f 08                	jg     800ea5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	50                   	push   %eax
  800ea9:	6a 0e                	push   $0xe
  800eab:	68 a0 15 80 00       	push   $0x8015a0
  800eb0:	6a 33                	push   $0x33
  800eb2:	68 bd 15 80 00       	push   $0x8015bd
  800eb7:	e8 41 00 00 00       	call   800efd <_panic>

00800ebc <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ed2:	89 df                	mov    %ebx,%edi
  800ed4:	89 de                	mov    %ebx,%esi
  800ed6:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ed8:	5b                   	pop    %ebx
  800ed9:	5e                   	pop    %esi
  800eda:	5f                   	pop    %edi
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ef0:	89 cb                	mov    %ecx,%ebx
  800ef2:	89 cf                	mov    %ecx,%edi
  800ef4:	89 ce                	mov    %ecx,%esi
  800ef6:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800f02:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f05:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f0b:	e8 3c fd ff ff       	call   800c4c <sys_getenvid>
  800f10:	83 ec 0c             	sub    $0xc,%esp
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	56                   	push   %esi
  800f1a:	50                   	push   %eax
  800f1b:	68 cc 15 80 00       	push   $0x8015cc
  800f20:	e8 65 f2 ff ff       	call   80018a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f25:	83 c4 18             	add    $0x18,%esp
  800f28:	53                   	push   %ebx
  800f29:	ff 75 10             	pushl  0x10(%ebp)
  800f2c:	e8 08 f2 ff ff       	call   800139 <vcprintf>
	cprintf("\n");
  800f31:	c7 04 24 f0 15 80 00 	movl   $0x8015f0,(%esp)
  800f38:	e8 4d f2 ff ff       	call   80018a <cprintf>
  800f3d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f40:	cc                   	int3   
  800f41:	eb fd                	jmp    800f40 <_panic+0x43>
  800f43:	66 90                	xchg   %ax,%ax
  800f45:	66 90                	xchg   %ax,%ax
  800f47:	66 90                	xchg   %ax,%ax
  800f49:	66 90                	xchg   %ax,%ax
  800f4b:	66 90                	xchg   %ax,%ax
  800f4d:	66 90                	xchg   %ax,%ax
  800f4f:	90                   	nop

00800f50 <__udivdi3>:
  800f50:	55                   	push   %ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
  800f54:	83 ec 1c             	sub    $0x1c,%esp
  800f57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f67:	85 d2                	test   %edx,%edx
  800f69:	75 4d                	jne    800fb8 <__udivdi3+0x68>
  800f6b:	39 f3                	cmp    %esi,%ebx
  800f6d:	76 19                	jbe    800f88 <__udivdi3+0x38>
  800f6f:	31 ff                	xor    %edi,%edi
  800f71:	89 e8                	mov    %ebp,%eax
  800f73:	89 f2                	mov    %esi,%edx
  800f75:	f7 f3                	div    %ebx
  800f77:	89 fa                	mov    %edi,%edx
  800f79:	83 c4 1c             	add    $0x1c,%esp
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    
  800f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f88:	89 d9                	mov    %ebx,%ecx
  800f8a:	85 db                	test   %ebx,%ebx
  800f8c:	75 0b                	jne    800f99 <__udivdi3+0x49>
  800f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f93:	31 d2                	xor    %edx,%edx
  800f95:	f7 f3                	div    %ebx
  800f97:	89 c1                	mov    %eax,%ecx
  800f99:	31 d2                	xor    %edx,%edx
  800f9b:	89 f0                	mov    %esi,%eax
  800f9d:	f7 f1                	div    %ecx
  800f9f:	89 c6                	mov    %eax,%esi
  800fa1:	89 e8                	mov    %ebp,%eax
  800fa3:	89 f7                	mov    %esi,%edi
  800fa5:	f7 f1                	div    %ecx
  800fa7:	89 fa                	mov    %edi,%edx
  800fa9:	83 c4 1c             	add    $0x1c,%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    
  800fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fb8:	39 f2                	cmp    %esi,%edx
  800fba:	77 1c                	ja     800fd8 <__udivdi3+0x88>
  800fbc:	0f bd fa             	bsr    %edx,%edi
  800fbf:	83 f7 1f             	xor    $0x1f,%edi
  800fc2:	75 2c                	jne    800ff0 <__udivdi3+0xa0>
  800fc4:	39 f2                	cmp    %esi,%edx
  800fc6:	72 06                	jb     800fce <__udivdi3+0x7e>
  800fc8:	31 c0                	xor    %eax,%eax
  800fca:	39 eb                	cmp    %ebp,%ebx
  800fcc:	77 a9                	ja     800f77 <__udivdi3+0x27>
  800fce:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd3:	eb a2                	jmp    800f77 <__udivdi3+0x27>
  800fd5:	8d 76 00             	lea    0x0(%esi),%esi
  800fd8:	31 ff                	xor    %edi,%edi
  800fda:	31 c0                	xor    %eax,%eax
  800fdc:	89 fa                	mov    %edi,%edx
  800fde:	83 c4 1c             	add    $0x1c,%esp
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    
  800fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fed:	8d 76 00             	lea    0x0(%esi),%esi
  800ff0:	89 f9                	mov    %edi,%ecx
  800ff2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ff7:	29 f8                	sub    %edi,%eax
  800ff9:	d3 e2                	shl    %cl,%edx
  800ffb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fff:	89 c1                	mov    %eax,%ecx
  801001:	89 da                	mov    %ebx,%edx
  801003:	d3 ea                	shr    %cl,%edx
  801005:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801009:	09 d1                	or     %edx,%ecx
  80100b:	89 f2                	mov    %esi,%edx
  80100d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801011:	89 f9                	mov    %edi,%ecx
  801013:	d3 e3                	shl    %cl,%ebx
  801015:	89 c1                	mov    %eax,%ecx
  801017:	d3 ea                	shr    %cl,%edx
  801019:	89 f9                	mov    %edi,%ecx
  80101b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80101f:	89 eb                	mov    %ebp,%ebx
  801021:	d3 e6                	shl    %cl,%esi
  801023:	89 c1                	mov    %eax,%ecx
  801025:	d3 eb                	shr    %cl,%ebx
  801027:	09 de                	or     %ebx,%esi
  801029:	89 f0                	mov    %esi,%eax
  80102b:	f7 74 24 08          	divl   0x8(%esp)
  80102f:	89 d6                	mov    %edx,%esi
  801031:	89 c3                	mov    %eax,%ebx
  801033:	f7 64 24 0c          	mull   0xc(%esp)
  801037:	39 d6                	cmp    %edx,%esi
  801039:	72 15                	jb     801050 <__udivdi3+0x100>
  80103b:	89 f9                	mov    %edi,%ecx
  80103d:	d3 e5                	shl    %cl,%ebp
  80103f:	39 c5                	cmp    %eax,%ebp
  801041:	73 04                	jae    801047 <__udivdi3+0xf7>
  801043:	39 d6                	cmp    %edx,%esi
  801045:	74 09                	je     801050 <__udivdi3+0x100>
  801047:	89 d8                	mov    %ebx,%eax
  801049:	31 ff                	xor    %edi,%edi
  80104b:	e9 27 ff ff ff       	jmp    800f77 <__udivdi3+0x27>
  801050:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801053:	31 ff                	xor    %edi,%edi
  801055:	e9 1d ff ff ff       	jmp    800f77 <__udivdi3+0x27>
  80105a:	66 90                	xchg   %ax,%ax
  80105c:	66 90                	xchg   %ax,%ax
  80105e:	66 90                	xchg   %ax,%ax

00801060 <__umoddi3>:
  801060:	55                   	push   %ebp
  801061:	57                   	push   %edi
  801062:	56                   	push   %esi
  801063:	53                   	push   %ebx
  801064:	83 ec 1c             	sub    $0x1c,%esp
  801067:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80106b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80106f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801077:	89 da                	mov    %ebx,%edx
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 43                	jne    8010c0 <__umoddi3+0x60>
  80107d:	39 df                	cmp    %ebx,%edi
  80107f:	76 17                	jbe    801098 <__umoddi3+0x38>
  801081:	89 f0                	mov    %esi,%eax
  801083:	f7 f7                	div    %edi
  801085:	89 d0                	mov    %edx,%eax
  801087:	31 d2                	xor    %edx,%edx
  801089:	83 c4 1c             	add    $0x1c,%esp
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5f                   	pop    %edi
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    
  801091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801098:	89 fd                	mov    %edi,%ebp
  80109a:	85 ff                	test   %edi,%edi
  80109c:	75 0b                	jne    8010a9 <__umoddi3+0x49>
  80109e:	b8 01 00 00 00       	mov    $0x1,%eax
  8010a3:	31 d2                	xor    %edx,%edx
  8010a5:	f7 f7                	div    %edi
  8010a7:	89 c5                	mov    %eax,%ebp
  8010a9:	89 d8                	mov    %ebx,%eax
  8010ab:	31 d2                	xor    %edx,%edx
  8010ad:	f7 f5                	div    %ebp
  8010af:	89 f0                	mov    %esi,%eax
  8010b1:	f7 f5                	div    %ebp
  8010b3:	89 d0                	mov    %edx,%eax
  8010b5:	eb d0                	jmp    801087 <__umoddi3+0x27>
  8010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010be:	66 90                	xchg   %ax,%ax
  8010c0:	89 f1                	mov    %esi,%ecx
  8010c2:	39 d8                	cmp    %ebx,%eax
  8010c4:	76 0a                	jbe    8010d0 <__umoddi3+0x70>
  8010c6:	89 f0                	mov    %esi,%eax
  8010c8:	83 c4 1c             	add    $0x1c,%esp
  8010cb:	5b                   	pop    %ebx
  8010cc:	5e                   	pop    %esi
  8010cd:	5f                   	pop    %edi
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    
  8010d0:	0f bd e8             	bsr    %eax,%ebp
  8010d3:	83 f5 1f             	xor    $0x1f,%ebp
  8010d6:	75 20                	jne    8010f8 <__umoddi3+0x98>
  8010d8:	39 d8                	cmp    %ebx,%eax
  8010da:	0f 82 b0 00 00 00    	jb     801190 <__umoddi3+0x130>
  8010e0:	39 f7                	cmp    %esi,%edi
  8010e2:	0f 86 a8 00 00 00    	jbe    801190 <__umoddi3+0x130>
  8010e8:	89 c8                	mov    %ecx,%eax
  8010ea:	83 c4 1c             	add    $0x1c,%esp
  8010ed:	5b                   	pop    %ebx
  8010ee:	5e                   	pop    %esi
  8010ef:	5f                   	pop    %edi
  8010f0:	5d                   	pop    %ebp
  8010f1:	c3                   	ret    
  8010f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010f8:	89 e9                	mov    %ebp,%ecx
  8010fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8010ff:	29 ea                	sub    %ebp,%edx
  801101:	d3 e0                	shl    %cl,%eax
  801103:	89 44 24 08          	mov    %eax,0x8(%esp)
  801107:	89 d1                	mov    %edx,%ecx
  801109:	89 f8                	mov    %edi,%eax
  80110b:	d3 e8                	shr    %cl,%eax
  80110d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801111:	89 54 24 04          	mov    %edx,0x4(%esp)
  801115:	8b 54 24 04          	mov    0x4(%esp),%edx
  801119:	09 c1                	or     %eax,%ecx
  80111b:	89 d8                	mov    %ebx,%eax
  80111d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801121:	89 e9                	mov    %ebp,%ecx
  801123:	d3 e7                	shl    %cl,%edi
  801125:	89 d1                	mov    %edx,%ecx
  801127:	d3 e8                	shr    %cl,%eax
  801129:	89 e9                	mov    %ebp,%ecx
  80112b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80112f:	d3 e3                	shl    %cl,%ebx
  801131:	89 c7                	mov    %eax,%edi
  801133:	89 d1                	mov    %edx,%ecx
  801135:	89 f0                	mov    %esi,%eax
  801137:	d3 e8                	shr    %cl,%eax
  801139:	89 e9                	mov    %ebp,%ecx
  80113b:	89 fa                	mov    %edi,%edx
  80113d:	d3 e6                	shl    %cl,%esi
  80113f:	09 d8                	or     %ebx,%eax
  801141:	f7 74 24 08          	divl   0x8(%esp)
  801145:	89 d1                	mov    %edx,%ecx
  801147:	89 f3                	mov    %esi,%ebx
  801149:	f7 64 24 0c          	mull   0xc(%esp)
  80114d:	89 c6                	mov    %eax,%esi
  80114f:	89 d7                	mov    %edx,%edi
  801151:	39 d1                	cmp    %edx,%ecx
  801153:	72 06                	jb     80115b <__umoddi3+0xfb>
  801155:	75 10                	jne    801167 <__umoddi3+0x107>
  801157:	39 c3                	cmp    %eax,%ebx
  801159:	73 0c                	jae    801167 <__umoddi3+0x107>
  80115b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80115f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801163:	89 d7                	mov    %edx,%edi
  801165:	89 c6                	mov    %eax,%esi
  801167:	89 ca                	mov    %ecx,%edx
  801169:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80116e:	29 f3                	sub    %esi,%ebx
  801170:	19 fa                	sbb    %edi,%edx
  801172:	89 d0                	mov    %edx,%eax
  801174:	d3 e0                	shl    %cl,%eax
  801176:	89 e9                	mov    %ebp,%ecx
  801178:	d3 eb                	shr    %cl,%ebx
  80117a:	d3 ea                	shr    %cl,%edx
  80117c:	09 d8                	or     %ebx,%eax
  80117e:	83 c4 1c             	add    $0x1c,%esp
  801181:	5b                   	pop    %ebx
  801182:	5e                   	pop    %esi
  801183:	5f                   	pop    %edi
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    
  801186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80118d:	8d 76 00             	lea    0x0(%esi),%esi
  801190:	89 da                	mov    %ebx,%edx
  801192:	29 fe                	sub    %edi,%esi
  801194:	19 c2                	sbb    %eax,%edx
  801196:	89 f1                	mov    %esi,%ecx
  801198:	89 c8                	mov    %ecx,%eax
  80119a:	e9 4b ff ff ff       	jmp    8010ea <__umoddi3+0x8a>
