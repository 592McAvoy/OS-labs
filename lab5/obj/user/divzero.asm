
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 60 11 80 00       	push   $0x801160
  800056:	e8 f5 00 00 00       	call   800150 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80006b:	e8 a2 0b 00 00       	call   800c12 <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800078:	c1 e0 04             	shl    $0x4,%eax
  80007b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800080:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800085:	85 db                	test   %ebx,%ebx
  800087:	7e 07                	jle    800090 <libmain+0x30>
		binaryname = argv[0];
  800089:	8b 06                	mov    (%esi),%eax
  80008b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	56                   	push   %esi
  800094:	53                   	push   %ebx
  800095:	e8 99 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009a:	e8 0a 00 00 00       	call   8000a9 <exit>
}
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a5:	5b                   	pop    %ebx
  8000a6:	5e                   	pop    %esi
  8000a7:	5d                   	pop    %ebp
  8000a8:	c3                   	ret    

008000a9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 1b 0b 00 00       	call   800bd1 <sys_env_destroy>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	c9                   	leave  
  8000ba:	c3                   	ret    

008000bb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	53                   	push   %ebx
  8000bf:	83 ec 04             	sub    $0x4,%esp
  8000c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c5:	8b 13                	mov    (%ebx),%edx
  8000c7:	8d 42 01             	lea    0x1(%edx),%eax
  8000ca:	89 03                	mov    %eax,(%ebx)
  8000cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d8:	74 09                	je     8000e3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000da:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	68 ff 00 00 00       	push   $0xff
  8000eb:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ee:	50                   	push   %eax
  8000ef:	e8 a0 0a 00 00       	call   800b94 <sys_cputs>
		b->idx = 0;
  8000f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	eb db                	jmp    8000da <putch+0x1f>

008000ff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800108:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010f:	00 00 00 
	b.cnt = 0;
  800112:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800119:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011c:	ff 75 0c             	pushl  0xc(%ebp)
  80011f:	ff 75 08             	pushl  0x8(%ebp)
  800122:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800128:	50                   	push   %eax
  800129:	68 bb 00 80 00       	push   $0x8000bb
  80012e:	e8 4a 01 00 00       	call   80027d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800133:	83 c4 08             	add    $0x8,%esp
  800136:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 4c 0a 00 00       	call   800b94 <sys_cputs>

	return b.cnt;
}
  800148:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800156:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800159:	50                   	push   %eax
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	e8 9d ff ff ff       	call   8000ff <vcprintf>
	va_end(ap);

	return cnt;
}
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	57                   	push   %edi
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
  80016a:	83 ec 1c             	sub    $0x1c,%esp
  80016d:	89 c6                	mov    %eax,%esi
  80016f:	89 d7                	mov    %edx,%edi
  800171:	8b 45 08             	mov    0x8(%ebp),%eax
  800174:	8b 55 0c             	mov    0xc(%ebp),%edx
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80017a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800183:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800187:	74 2c                	je     8001b5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800189:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800193:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800196:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800199:	39 c2                	cmp    %eax,%edx
  80019b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80019e:	73 43                	jae    8001e3 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001a0:	83 eb 01             	sub    $0x1,%ebx
  8001a3:	85 db                	test   %ebx,%ebx
  8001a5:	7e 6c                	jle    800213 <printnum+0xaf>
			putch(padc, putdat);
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	57                   	push   %edi
  8001ab:	ff 75 18             	pushl  0x18(%ebp)
  8001ae:	ff d6                	call   *%esi
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb eb                	jmp    8001a0 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	6a 20                	push   $0x20
  8001ba:	6a 00                	push   $0x0
  8001bc:	50                   	push   %eax
  8001bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c3:	89 fa                	mov    %edi,%edx
  8001c5:	89 f0                	mov    %esi,%eax
  8001c7:	e8 98 ff ff ff       	call   800164 <printnum>
		while (--width > 0)
  8001cc:	83 c4 20             	add    $0x20,%esp
  8001cf:	83 eb 01             	sub    $0x1,%ebx
  8001d2:	85 db                	test   %ebx,%ebx
  8001d4:	7e 65                	jle    80023b <printnum+0xd7>
			putch(padc, putdat);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	57                   	push   %edi
  8001da:	6a 20                	push   $0x20
  8001dc:	ff d6                	call   *%esi
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	eb ec                	jmp    8001cf <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	ff 75 18             	pushl  0x18(%ebp)
  8001e9:	83 eb 01             	sub    $0x1,%ebx
  8001ec:	53                   	push   %ebx
  8001ed:	50                   	push   %eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fd:	e8 0e 0d 00 00       	call   800f10 <__udivdi3>
  800202:	83 c4 18             	add    $0x18,%esp
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	89 fa                	mov    %edi,%edx
  800209:	89 f0                	mov    %esi,%eax
  80020b:	e8 54 ff ff ff       	call   800164 <printnum>
  800210:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	57                   	push   %edi
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	ff 75 dc             	pushl  -0x24(%ebp)
  80021d:	ff 75 d8             	pushl  -0x28(%ebp)
  800220:	ff 75 e4             	pushl  -0x1c(%ebp)
  800223:	ff 75 e0             	pushl  -0x20(%ebp)
  800226:	e8 f5 0d 00 00       	call   801020 <__umoddi3>
  80022b:	83 c4 14             	add    $0x14,%esp
  80022e:	0f be 80 78 11 80 00 	movsbl 0x801178(%eax),%eax
  800235:	50                   	push   %eax
  800236:	ff d6                	call   *%esi
  800238:	83 c4 10             	add    $0x10,%esp
}
  80023b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5e                   	pop    %esi
  800240:	5f                   	pop    %edi
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    

00800243 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800249:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80024d:	8b 10                	mov    (%eax),%edx
  80024f:	3b 50 04             	cmp    0x4(%eax),%edx
  800252:	73 0a                	jae    80025e <sprintputch+0x1b>
		*b->buf++ = ch;
  800254:	8d 4a 01             	lea    0x1(%edx),%ecx
  800257:	89 08                	mov    %ecx,(%eax)
  800259:	8b 45 08             	mov    0x8(%ebp),%eax
  80025c:	88 02                	mov    %al,(%edx)
}
  80025e:	5d                   	pop    %ebp
  80025f:	c3                   	ret    

00800260 <printfmt>:
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800266:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800269:	50                   	push   %eax
  80026a:	ff 75 10             	pushl  0x10(%ebp)
  80026d:	ff 75 0c             	pushl  0xc(%ebp)
  800270:	ff 75 08             	pushl  0x8(%ebp)
  800273:	e8 05 00 00 00       	call   80027d <vprintfmt>
}
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <vprintfmt>:
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	57                   	push   %edi
  800281:	56                   	push   %esi
  800282:	53                   	push   %ebx
  800283:	83 ec 3c             	sub    $0x3c,%esp
  800286:	8b 75 08             	mov    0x8(%ebp),%esi
  800289:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80028f:	e9 b4 03 00 00       	jmp    800648 <vprintfmt+0x3cb>
		padc = ' ';
  800294:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800298:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80029f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002b4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b9:	8d 47 01             	lea    0x1(%edi),%eax
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002bf:	0f b6 17             	movzbl (%edi),%edx
  8002c2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c5:	3c 55                	cmp    $0x55,%al
  8002c7:	0f 87 c8 04 00 00    	ja     800795 <vprintfmt+0x518>
  8002cd:	0f b6 c0             	movzbl %al,%eax
  8002d0:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8002d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8002da:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8002e1:	eb d6                	jmp    8002b9 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8002e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002ea:	eb cd                	jmp    8002b9 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8002ec:	0f b6 d2             	movzbl %dl,%edx
  8002ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8002fa:	eb 0c                	jmp    800308 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8002fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002ff:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800303:	eb b4                	jmp    8002b9 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800305:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800308:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800312:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800315:	83 f9 09             	cmp    $0x9,%ecx
  800318:	76 eb                	jbe    800305 <vprintfmt+0x88>
  80031a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80031d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800320:	eb 14                	jmp    800336 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800322:	8b 45 14             	mov    0x14(%ebp),%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032a:	8b 45 14             	mov    0x14(%ebp),%eax
  80032d:	8d 40 04             	lea    0x4(%eax),%eax
  800330:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800333:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800336:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80033a:	0f 89 79 ff ff ff    	jns    8002b9 <vprintfmt+0x3c>
				width = precision, precision = -1;
  800340:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800343:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800346:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80034d:	e9 67 ff ff ff       	jmp    8002b9 <vprintfmt+0x3c>
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	85 c0                	test   %eax,%eax
  800357:	ba 00 00 00 00       	mov    $0x0,%edx
  80035c:	0f 49 d0             	cmovns %eax,%edx
  80035f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800362:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800365:	e9 4f ff ff ff       	jmp    8002b9 <vprintfmt+0x3c>
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80036d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800374:	e9 40 ff ff ff       	jmp    8002b9 <vprintfmt+0x3c>
			lflag++;
  800379:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037f:	e9 35 ff ff ff       	jmp    8002b9 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800384:	8b 45 14             	mov    0x14(%ebp),%eax
  800387:	8d 78 04             	lea    0x4(%eax),%edi
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	53                   	push   %ebx
  80038e:	ff 30                	pushl  (%eax)
  800390:	ff d6                	call   *%esi
			break;
  800392:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800395:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800398:	e9 a8 02 00 00       	jmp    800645 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80039d:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a0:	8d 78 04             	lea    0x4(%eax),%edi
  8003a3:	8b 00                	mov    (%eax),%eax
  8003a5:	99                   	cltd   
  8003a6:	31 d0                	xor    %edx,%eax
  8003a8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003aa:	83 f8 0f             	cmp    $0xf,%eax
  8003ad:	7f 23                	jg     8003d2 <vprintfmt+0x155>
  8003af:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8003b6:	85 d2                	test   %edx,%edx
  8003b8:	74 18                	je     8003d2 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8003ba:	52                   	push   %edx
  8003bb:	68 99 11 80 00       	push   $0x801199
  8003c0:	53                   	push   %ebx
  8003c1:	56                   	push   %esi
  8003c2:	e8 99 fe ff ff       	call   800260 <printfmt>
  8003c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ca:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003cd:	e9 73 02 00 00       	jmp    800645 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8003d2:	50                   	push   %eax
  8003d3:	68 90 11 80 00       	push   $0x801190
  8003d8:	53                   	push   %ebx
  8003d9:	56                   	push   %esi
  8003da:	e8 81 fe ff ff       	call   800260 <printfmt>
  8003df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e5:	e9 5b 02 00 00       	jmp    800645 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ed:	83 c0 04             	add    $0x4,%eax
  8003f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003f8:	85 d2                	test   %edx,%edx
  8003fa:	b8 89 11 80 00       	mov    $0x801189,%eax
  8003ff:	0f 45 c2             	cmovne %edx,%eax
  800402:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800405:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800409:	7e 06                	jle    800411 <vprintfmt+0x194>
  80040b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80040f:	75 0d                	jne    80041e <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800411:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800414:	89 c7                	mov    %eax,%edi
  800416:	03 45 e0             	add    -0x20(%ebp),%eax
  800419:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041c:	eb 53                	jmp    800471 <vprintfmt+0x1f4>
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	ff 75 d8             	pushl  -0x28(%ebp)
  800424:	50                   	push   %eax
  800425:	e8 13 04 00 00       	call   80083d <strnlen>
  80042a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042d:	29 c1                	sub    %eax,%ecx
  80042f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800437:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80043b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80043e:	eb 0f                	jmp    80044f <vprintfmt+0x1d2>
					putch(padc, putdat);
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	53                   	push   %ebx
  800444:	ff 75 e0             	pushl  -0x20(%ebp)
  800447:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800449:	83 ef 01             	sub    $0x1,%edi
  80044c:	83 c4 10             	add    $0x10,%esp
  80044f:	85 ff                	test   %edi,%edi
  800451:	7f ed                	jg     800440 <vprintfmt+0x1c3>
  800453:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800456:	85 d2                	test   %edx,%edx
  800458:	b8 00 00 00 00       	mov    $0x0,%eax
  80045d:	0f 49 c2             	cmovns %edx,%eax
  800460:	29 c2                	sub    %eax,%edx
  800462:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800465:	eb aa                	jmp    800411 <vprintfmt+0x194>
					putch(ch, putdat);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	53                   	push   %ebx
  80046b:	52                   	push   %edx
  80046c:	ff d6                	call   *%esi
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800474:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800476:	83 c7 01             	add    $0x1,%edi
  800479:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80047d:	0f be d0             	movsbl %al,%edx
  800480:	85 d2                	test   %edx,%edx
  800482:	74 4b                	je     8004cf <vprintfmt+0x252>
  800484:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800488:	78 06                	js     800490 <vprintfmt+0x213>
  80048a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048e:	78 1e                	js     8004ae <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800490:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800494:	74 d1                	je     800467 <vprintfmt+0x1ea>
  800496:	0f be c0             	movsbl %al,%eax
  800499:	83 e8 20             	sub    $0x20,%eax
  80049c:	83 f8 5e             	cmp    $0x5e,%eax
  80049f:	76 c6                	jbe    800467 <vprintfmt+0x1ea>
					putch('?', putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	6a 3f                	push   $0x3f
  8004a7:	ff d6                	call   *%esi
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	eb c3                	jmp    800471 <vprintfmt+0x1f4>
  8004ae:	89 cf                	mov    %ecx,%edi
  8004b0:	eb 0e                	jmp    8004c0 <vprintfmt+0x243>
				putch(' ', putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	6a 20                	push   $0x20
  8004b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ee                	jg     8004b2 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	e9 76 01 00 00       	jmp    800645 <vprintfmt+0x3c8>
  8004cf:	89 cf                	mov    %ecx,%edi
  8004d1:	eb ed                	jmp    8004c0 <vprintfmt+0x243>
	if (lflag >= 2)
  8004d3:	83 f9 01             	cmp    $0x1,%ecx
  8004d6:	7f 1f                	jg     8004f7 <vprintfmt+0x27a>
	else if (lflag)
  8004d8:	85 c9                	test   %ecx,%ecx
  8004da:	74 6a                	je     800546 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e4:	89 c1                	mov    %eax,%ecx
  8004e6:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8d 40 04             	lea    0x4(%eax),%eax
  8004f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f5:	eb 17                	jmp    80050e <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8b 50 04             	mov    0x4(%eax),%edx
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800502:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 08             	lea    0x8(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800511:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800516:	85 d2                	test   %edx,%edx
  800518:	0f 89 f8 00 00 00    	jns    800616 <vprintfmt+0x399>
				putch('-', putdat);
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	53                   	push   %ebx
  800522:	6a 2d                	push   $0x2d
  800524:	ff d6                	call   *%esi
				num = -(long long) num;
  800526:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800529:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80052c:	f7 d8                	neg    %eax
  80052e:	83 d2 00             	adc    $0x0,%edx
  800531:	f7 da                	neg    %edx
  800533:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800536:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800539:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80053c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800541:	e9 e1 00 00 00       	jmp    800627 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054e:	99                   	cltd   
  80054f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 40 04             	lea    0x4(%eax),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	eb b1                	jmp    80050e <vprintfmt+0x291>
	if (lflag >= 2)
  80055d:	83 f9 01             	cmp    $0x1,%ecx
  800560:	7f 27                	jg     800589 <vprintfmt+0x30c>
	else if (lflag)
  800562:	85 c9                	test   %ecx,%ecx
  800564:	74 41                	je     8005a7 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	ba 00 00 00 00       	mov    $0x0,%edx
  800570:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800573:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	8d 40 04             	lea    0x4(%eax),%eax
  80057c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800584:	e9 8d 00 00 00       	jmp    800616 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800594:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8d 40 08             	lea    0x8(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a5:	eb 6f                	jmp    800616 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 40 04             	lea    0x4(%eax),%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005c5:	eb 4f                	jmp    800616 <vprintfmt+0x399>
	if (lflag >= 2)
  8005c7:	83 f9 01             	cmp    $0x1,%ecx
  8005ca:	7f 23                	jg     8005ef <vprintfmt+0x372>
	else if (lflag)
  8005cc:	85 c9                	test   %ecx,%ecx
  8005ce:	0f 84 98 00 00 00    	je     80066c <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ed:	eb 17                	jmp    800606 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 50 04             	mov    0x4(%eax),%edx
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	53                   	push   %ebx
  80060a:	6a 30                	push   $0x30
  80060c:	ff d6                	call   *%esi
			goto number;
  80060e:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800611:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800616:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80061a:	74 0b                	je     800627 <vprintfmt+0x3aa>
				putch('+', putdat);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	53                   	push   %ebx
  800620:	6a 2b                	push   $0x2b
  800622:	ff d6                	call   *%esi
  800624:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800627:	83 ec 0c             	sub    $0xc,%esp
  80062a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80062e:	50                   	push   %eax
  80062f:	ff 75 e0             	pushl  -0x20(%ebp)
  800632:	57                   	push   %edi
  800633:	ff 75 dc             	pushl  -0x24(%ebp)
  800636:	ff 75 d8             	pushl  -0x28(%ebp)
  800639:	89 da                	mov    %ebx,%edx
  80063b:	89 f0                	mov    %esi,%eax
  80063d:	e8 22 fb ff ff       	call   800164 <printnum>
			break;
  800642:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800645:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800648:	83 c7 01             	add    $0x1,%edi
  80064b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80064f:	83 f8 25             	cmp    $0x25,%eax
  800652:	0f 84 3c fc ff ff    	je     800294 <vprintfmt+0x17>
			if (ch == '\0')
  800658:	85 c0                	test   %eax,%eax
  80065a:	0f 84 55 01 00 00    	je     8007b5 <vprintfmt+0x538>
			putch(ch, putdat);
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	50                   	push   %eax
  800665:	ff d6                	call   *%esi
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	eb dc                	jmp    800648 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	ba 00 00 00 00       	mov    $0x0,%edx
  800676:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800679:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8d 40 04             	lea    0x4(%eax),%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
  800685:	e9 7c ff ff ff       	jmp    800606 <vprintfmt+0x389>
			putch('0', putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	6a 30                	push   $0x30
  800690:	ff d6                	call   *%esi
			putch('x', putdat);
  800692:	83 c4 08             	add    $0x8,%esp
  800695:	53                   	push   %ebx
  800696:	6a 78                	push   $0x78
  800698:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006aa:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b6:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8006bb:	e9 56 ff ff ff       	jmp    800616 <vprintfmt+0x399>
	if (lflag >= 2)
  8006c0:	83 f9 01             	cmp    $0x1,%ecx
  8006c3:	7f 27                	jg     8006ec <vprintfmt+0x46f>
	else if (lflag)
  8006c5:	85 c9                	test   %ecx,%ecx
  8006c7:	74 44                	je     80070d <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e2:	bf 10 00 00 00       	mov    $0x10,%edi
  8006e7:	e9 2a ff ff ff       	jmp    800616 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8b 50 04             	mov    0x4(%eax),%edx
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8d 40 08             	lea    0x8(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800703:	bf 10 00 00 00       	mov    $0x10,%edi
  800708:	e9 09 ff ff ff       	jmp    800616 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	ba 00 00 00 00       	mov    $0x0,%edx
  800717:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 40 04             	lea    0x4(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800726:	bf 10 00 00 00       	mov    $0x10,%edi
  80072b:	e9 e6 fe ff ff       	jmp    800616 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 78 04             	lea    0x4(%eax),%edi
  800736:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800738:	85 c0                	test   %eax,%eax
  80073a:	74 2d                	je     800769 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80073c:	0f b6 13             	movzbl (%ebx),%edx
  80073f:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800741:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800744:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800747:	0f 8e f8 fe ff ff    	jle    800645 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80074d:	68 e8 12 80 00       	push   $0x8012e8
  800752:	68 99 11 80 00       	push   $0x801199
  800757:	53                   	push   %ebx
  800758:	56                   	push   %esi
  800759:	e8 02 fb ff ff       	call   800260 <printfmt>
  80075e:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800761:	89 7d 14             	mov    %edi,0x14(%ebp)
  800764:	e9 dc fe ff ff       	jmp    800645 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800769:	68 b0 12 80 00       	push   $0x8012b0
  80076e:	68 99 11 80 00       	push   $0x801199
  800773:	53                   	push   %ebx
  800774:	56                   	push   %esi
  800775:	e8 e6 fa ff ff       	call   800260 <printfmt>
  80077a:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80077d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800780:	e9 c0 fe ff ff       	jmp    800645 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	53                   	push   %ebx
  800789:	6a 25                	push   $0x25
  80078b:	ff d6                	call   *%esi
			break;
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	e9 b0 fe ff ff       	jmp    800645 <vprintfmt+0x3c8>
			putch('%', putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	53                   	push   %ebx
  800799:	6a 25                	push   $0x25
  80079b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80079d:	83 c4 10             	add    $0x10,%esp
  8007a0:	89 f8                	mov    %edi,%eax
  8007a2:	eb 03                	jmp    8007a7 <vprintfmt+0x52a>
  8007a4:	83 e8 01             	sub    $0x1,%eax
  8007a7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007ab:	75 f7                	jne    8007a4 <vprintfmt+0x527>
  8007ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007b0:	e9 90 fe ff ff       	jmp    800645 <vprintfmt+0x3c8>
}
  8007b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b8:	5b                   	pop    %ebx
  8007b9:	5e                   	pop    %esi
  8007ba:	5f                   	pop    %edi
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	83 ec 18             	sub    $0x18,%esp
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007cc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	74 26                	je     800804 <vsnprintf+0x47>
  8007de:	85 d2                	test   %edx,%edx
  8007e0:	7e 22                	jle    800804 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e2:	ff 75 14             	pushl  0x14(%ebp)
  8007e5:	ff 75 10             	pushl  0x10(%ebp)
  8007e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007eb:	50                   	push   %eax
  8007ec:	68 43 02 80 00       	push   $0x800243
  8007f1:	e8 87 fa ff ff       	call   80027d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ff:	83 c4 10             	add    $0x10,%esp
}
  800802:	c9                   	leave  
  800803:	c3                   	ret    
		return -E_INVAL;
  800804:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800809:	eb f7                	jmp    800802 <vsnprintf+0x45>

0080080b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800811:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800814:	50                   	push   %eax
  800815:	ff 75 10             	pushl  0x10(%ebp)
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	ff 75 08             	pushl  0x8(%ebp)
  80081e:	e8 9a ff ff ff       	call   8007bd <vsnprintf>
	va_end(ap);

	return rc;
}
  800823:	c9                   	leave  
  800824:	c3                   	ret    

00800825 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80082b:	b8 00 00 00 00       	mov    $0x0,%eax
  800830:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800834:	74 05                	je     80083b <strlen+0x16>
		n++;
  800836:	83 c0 01             	add    $0x1,%eax
  800839:	eb f5                	jmp    800830 <strlen+0xb>
	return n;
}
  80083b:	5d                   	pop    %ebp
  80083c:	c3                   	ret    

0080083d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800843:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800846:	ba 00 00 00 00       	mov    $0x0,%edx
  80084b:	39 c2                	cmp    %eax,%edx
  80084d:	74 0d                	je     80085c <strnlen+0x1f>
  80084f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800853:	74 05                	je     80085a <strnlen+0x1d>
		n++;
  800855:	83 c2 01             	add    $0x1,%edx
  800858:	eb f1                	jmp    80084b <strnlen+0xe>
  80085a:	89 d0                	mov    %edx,%eax
	return n;
}
  80085c:	5d                   	pop    %ebp
  80085d:	c3                   	ret    

0080085e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	53                   	push   %ebx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800868:	ba 00 00 00 00       	mov    $0x0,%edx
  80086d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800871:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800874:	83 c2 01             	add    $0x1,%edx
  800877:	84 c9                	test   %cl,%cl
  800879:	75 f2                	jne    80086d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80087b:	5b                   	pop    %ebx
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	53                   	push   %ebx
  800882:	83 ec 10             	sub    $0x10,%esp
  800885:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800888:	53                   	push   %ebx
  800889:	e8 97 ff ff ff       	call   800825 <strlen>
  80088e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800891:	ff 75 0c             	pushl  0xc(%ebp)
  800894:	01 d8                	add    %ebx,%eax
  800896:	50                   	push   %eax
  800897:	e8 c2 ff ff ff       	call   80085e <strcpy>
	return dst;
}
  80089c:	89 d8                	mov    %ebx,%eax
  80089e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a1:	c9                   	leave  
  8008a2:	c3                   	ret    

008008a3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	56                   	push   %esi
  8008a7:	53                   	push   %ebx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ae:	89 c6                	mov    %eax,%esi
  8008b0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b3:	89 c2                	mov    %eax,%edx
  8008b5:	39 f2                	cmp    %esi,%edx
  8008b7:	74 11                	je     8008ca <strncpy+0x27>
		*dst++ = *src;
  8008b9:	83 c2 01             	add    $0x1,%edx
  8008bc:	0f b6 19             	movzbl (%ecx),%ebx
  8008bf:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c2:	80 fb 01             	cmp    $0x1,%bl
  8008c5:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008c8:	eb eb                	jmp    8008b5 <strncpy+0x12>
	}
	return ret;
}
  8008ca:	5b                   	pop    %ebx
  8008cb:	5e                   	pop    %esi
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	56                   	push   %esi
  8008d2:	53                   	push   %ebx
  8008d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d9:	8b 55 10             	mov    0x10(%ebp),%edx
  8008dc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008de:	85 d2                	test   %edx,%edx
  8008e0:	74 21                	je     800903 <strlcpy+0x35>
  8008e2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008e6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008e8:	39 c2                	cmp    %eax,%edx
  8008ea:	74 14                	je     800900 <strlcpy+0x32>
  8008ec:	0f b6 19             	movzbl (%ecx),%ebx
  8008ef:	84 db                	test   %bl,%bl
  8008f1:	74 0b                	je     8008fe <strlcpy+0x30>
			*dst++ = *src++;
  8008f3:	83 c1 01             	add    $0x1,%ecx
  8008f6:	83 c2 01             	add    $0x1,%edx
  8008f9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008fc:	eb ea                	jmp    8008e8 <strlcpy+0x1a>
  8008fe:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800900:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800903:	29 f0                	sub    %esi,%eax
}
  800905:	5b                   	pop    %ebx
  800906:	5e                   	pop    %esi
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800912:	0f b6 01             	movzbl (%ecx),%eax
  800915:	84 c0                	test   %al,%al
  800917:	74 0c                	je     800925 <strcmp+0x1c>
  800919:	3a 02                	cmp    (%edx),%al
  80091b:	75 08                	jne    800925 <strcmp+0x1c>
		p++, q++;
  80091d:	83 c1 01             	add    $0x1,%ecx
  800920:	83 c2 01             	add    $0x1,%edx
  800923:	eb ed                	jmp    800912 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800925:	0f b6 c0             	movzbl %al,%eax
  800928:	0f b6 12             	movzbl (%edx),%edx
  80092b:	29 d0                	sub    %edx,%eax
}
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	53                   	push   %ebx
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 55 0c             	mov    0xc(%ebp),%edx
  800939:	89 c3                	mov    %eax,%ebx
  80093b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80093e:	eb 06                	jmp    800946 <strncmp+0x17>
		n--, p++, q++;
  800940:	83 c0 01             	add    $0x1,%eax
  800943:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800946:	39 d8                	cmp    %ebx,%eax
  800948:	74 16                	je     800960 <strncmp+0x31>
  80094a:	0f b6 08             	movzbl (%eax),%ecx
  80094d:	84 c9                	test   %cl,%cl
  80094f:	74 04                	je     800955 <strncmp+0x26>
  800951:	3a 0a                	cmp    (%edx),%cl
  800953:	74 eb                	je     800940 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800955:	0f b6 00             	movzbl (%eax),%eax
  800958:	0f b6 12             	movzbl (%edx),%edx
  80095b:	29 d0                	sub    %edx,%eax
}
  80095d:	5b                   	pop    %ebx
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    
		return 0;
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
  800965:	eb f6                	jmp    80095d <strncmp+0x2e>

00800967 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800971:	0f b6 10             	movzbl (%eax),%edx
  800974:	84 d2                	test   %dl,%dl
  800976:	74 09                	je     800981 <strchr+0x1a>
		if (*s == c)
  800978:	38 ca                	cmp    %cl,%dl
  80097a:	74 0a                	je     800986 <strchr+0x1f>
	for (; *s; s++)
  80097c:	83 c0 01             	add    $0x1,%eax
  80097f:	eb f0                	jmp    800971 <strchr+0xa>
			return (char *) s;
	return 0;
  800981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800992:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800995:	38 ca                	cmp    %cl,%dl
  800997:	74 09                	je     8009a2 <strfind+0x1a>
  800999:	84 d2                	test   %dl,%dl
  80099b:	74 05                	je     8009a2 <strfind+0x1a>
	for (; *s; s++)
  80099d:	83 c0 01             	add    $0x1,%eax
  8009a0:	eb f0                	jmp    800992 <strfind+0xa>
			break;
	return (char *) s;
}
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	57                   	push   %edi
  8009a8:	56                   	push   %esi
  8009a9:	53                   	push   %ebx
  8009aa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009b0:	85 c9                	test   %ecx,%ecx
  8009b2:	74 31                	je     8009e5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b4:	89 f8                	mov    %edi,%eax
  8009b6:	09 c8                	or     %ecx,%eax
  8009b8:	a8 03                	test   $0x3,%al
  8009ba:	75 23                	jne    8009df <memset+0x3b>
		c &= 0xFF;
  8009bc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c0:	89 d3                	mov    %edx,%ebx
  8009c2:	c1 e3 08             	shl    $0x8,%ebx
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	c1 e0 18             	shl    $0x18,%eax
  8009ca:	89 d6                	mov    %edx,%esi
  8009cc:	c1 e6 10             	shl    $0x10,%esi
  8009cf:	09 f0                	or     %esi,%eax
  8009d1:	09 c2                	or     %eax,%edx
  8009d3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009d5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d8:	89 d0                	mov    %edx,%eax
  8009da:	fc                   	cld    
  8009db:	f3 ab                	rep stos %eax,%es:(%edi)
  8009dd:	eb 06                	jmp    8009e5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e2:	fc                   	cld    
  8009e3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e5:	89 f8                	mov    %edi,%eax
  8009e7:	5b                   	pop    %ebx
  8009e8:	5e                   	pop    %esi
  8009e9:	5f                   	pop    %edi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	57                   	push   %edi
  8009f0:	56                   	push   %esi
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009fa:	39 c6                	cmp    %eax,%esi
  8009fc:	73 32                	jae    800a30 <memmove+0x44>
  8009fe:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a01:	39 c2                	cmp    %eax,%edx
  800a03:	76 2b                	jbe    800a30 <memmove+0x44>
		s += n;
		d += n;
  800a05:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a08:	89 fe                	mov    %edi,%esi
  800a0a:	09 ce                	or     %ecx,%esi
  800a0c:	09 d6                	or     %edx,%esi
  800a0e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a14:	75 0e                	jne    800a24 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a16:	83 ef 04             	sub    $0x4,%edi
  800a19:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a1c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a1f:	fd                   	std    
  800a20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a22:	eb 09                	jmp    800a2d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a24:	83 ef 01             	sub    $0x1,%edi
  800a27:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a2a:	fd                   	std    
  800a2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a2d:	fc                   	cld    
  800a2e:	eb 1a                	jmp    800a4a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a30:	89 c2                	mov    %eax,%edx
  800a32:	09 ca                	or     %ecx,%edx
  800a34:	09 f2                	or     %esi,%edx
  800a36:	f6 c2 03             	test   $0x3,%dl
  800a39:	75 0a                	jne    800a45 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a3e:	89 c7                	mov    %eax,%edi
  800a40:	fc                   	cld    
  800a41:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a43:	eb 05                	jmp    800a4a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a45:	89 c7                	mov    %eax,%edi
  800a47:	fc                   	cld    
  800a48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a4a:	5e                   	pop    %esi
  800a4b:	5f                   	pop    %edi
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a54:	ff 75 10             	pushl  0x10(%ebp)
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	ff 75 08             	pushl  0x8(%ebp)
  800a5d:	e8 8a ff ff ff       	call   8009ec <memmove>
}
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    

00800a64 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6f:	89 c6                	mov    %eax,%esi
  800a71:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a74:	39 f0                	cmp    %esi,%eax
  800a76:	74 1c                	je     800a94 <memcmp+0x30>
		if (*s1 != *s2)
  800a78:	0f b6 08             	movzbl (%eax),%ecx
  800a7b:	0f b6 1a             	movzbl (%edx),%ebx
  800a7e:	38 d9                	cmp    %bl,%cl
  800a80:	75 08                	jne    800a8a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a82:	83 c0 01             	add    $0x1,%eax
  800a85:	83 c2 01             	add    $0x1,%edx
  800a88:	eb ea                	jmp    800a74 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a8a:	0f b6 c1             	movzbl %cl,%eax
  800a8d:	0f b6 db             	movzbl %bl,%ebx
  800a90:	29 d8                	sub    %ebx,%eax
  800a92:	eb 05                	jmp    800a99 <memcmp+0x35>
	}

	return 0;
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a99:	5b                   	pop    %ebx
  800a9a:	5e                   	pop    %esi
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa6:	89 c2                	mov    %eax,%edx
  800aa8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aab:	39 d0                	cmp    %edx,%eax
  800aad:	73 09                	jae    800ab8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aaf:	38 08                	cmp    %cl,(%eax)
  800ab1:	74 05                	je     800ab8 <memfind+0x1b>
	for (; s < ends; s++)
  800ab3:	83 c0 01             	add    $0x1,%eax
  800ab6:	eb f3                	jmp    800aab <memfind+0xe>
			break;
	return (void *) s;
}
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	57                   	push   %edi
  800abe:	56                   	push   %esi
  800abf:	53                   	push   %ebx
  800ac0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac6:	eb 03                	jmp    800acb <strtol+0x11>
		s++;
  800ac8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800acb:	0f b6 01             	movzbl (%ecx),%eax
  800ace:	3c 20                	cmp    $0x20,%al
  800ad0:	74 f6                	je     800ac8 <strtol+0xe>
  800ad2:	3c 09                	cmp    $0x9,%al
  800ad4:	74 f2                	je     800ac8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ad6:	3c 2b                	cmp    $0x2b,%al
  800ad8:	74 2a                	je     800b04 <strtol+0x4a>
	int neg = 0;
  800ada:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800adf:	3c 2d                	cmp    $0x2d,%al
  800ae1:	74 2b                	je     800b0e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae9:	75 0f                	jne    800afa <strtol+0x40>
  800aeb:	80 39 30             	cmpb   $0x30,(%ecx)
  800aee:	74 28                	je     800b18 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af0:	85 db                	test   %ebx,%ebx
  800af2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af7:	0f 44 d8             	cmove  %eax,%ebx
  800afa:	b8 00 00 00 00       	mov    $0x0,%eax
  800aff:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b02:	eb 50                	jmp    800b54 <strtol+0x9a>
		s++;
  800b04:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b07:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0c:	eb d5                	jmp    800ae3 <strtol+0x29>
		s++, neg = 1;
  800b0e:	83 c1 01             	add    $0x1,%ecx
  800b11:	bf 01 00 00 00       	mov    $0x1,%edi
  800b16:	eb cb                	jmp    800ae3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b18:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b1c:	74 0e                	je     800b2c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b1e:	85 db                	test   %ebx,%ebx
  800b20:	75 d8                	jne    800afa <strtol+0x40>
		s++, base = 8;
  800b22:	83 c1 01             	add    $0x1,%ecx
  800b25:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b2a:	eb ce                	jmp    800afa <strtol+0x40>
		s += 2, base = 16;
  800b2c:	83 c1 02             	add    $0x2,%ecx
  800b2f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b34:	eb c4                	jmp    800afa <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b36:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b39:	89 f3                	mov    %esi,%ebx
  800b3b:	80 fb 19             	cmp    $0x19,%bl
  800b3e:	77 29                	ja     800b69 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b40:	0f be d2             	movsbl %dl,%edx
  800b43:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b46:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b49:	7d 30                	jge    800b7b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b4b:	83 c1 01             	add    $0x1,%ecx
  800b4e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b52:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b54:	0f b6 11             	movzbl (%ecx),%edx
  800b57:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b5a:	89 f3                	mov    %esi,%ebx
  800b5c:	80 fb 09             	cmp    $0x9,%bl
  800b5f:	77 d5                	ja     800b36 <strtol+0x7c>
			dig = *s - '0';
  800b61:	0f be d2             	movsbl %dl,%edx
  800b64:	83 ea 30             	sub    $0x30,%edx
  800b67:	eb dd                	jmp    800b46 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b69:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b6c:	89 f3                	mov    %esi,%ebx
  800b6e:	80 fb 19             	cmp    $0x19,%bl
  800b71:	77 08                	ja     800b7b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b73:	0f be d2             	movsbl %dl,%edx
  800b76:	83 ea 37             	sub    $0x37,%edx
  800b79:	eb cb                	jmp    800b46 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7f:	74 05                	je     800b86 <strtol+0xcc>
		*endptr = (char *) s;
  800b81:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b84:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b86:	89 c2                	mov    %eax,%edx
  800b88:	f7 da                	neg    %edx
  800b8a:	85 ff                	test   %edi,%edi
  800b8c:	0f 45 c2             	cmovne %edx,%eax
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba5:	89 c3                	mov    %eax,%ebx
  800ba7:	89 c7                	mov    %eax,%edi
  800ba9:	89 c6                	mov    %eax,%esi
  800bab:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5f                   	pop    %edi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	57                   	push   %edi
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc2:	89 d1                	mov    %edx,%ecx
  800bc4:	89 d3                	mov    %edx,%ebx
  800bc6:	89 d7                	mov    %edx,%edi
  800bc8:	89 d6                	mov    %edx,%esi
  800bca:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bcc:	5b                   	pop    %ebx
  800bcd:	5e                   	pop    %esi
  800bce:	5f                   	pop    %edi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	b8 03 00 00 00       	mov    $0x3,%eax
  800be7:	89 cb                	mov    %ecx,%ebx
  800be9:	89 cf                	mov    %ecx,%edi
  800beb:	89 ce                	mov    %ecx,%esi
  800bed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	7f 08                	jg     800bfb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	50                   	push   %eax
  800bff:	6a 03                	push   $0x3
  800c01:	68 00 15 80 00       	push   $0x801500
  800c06:	6a 33                	push   $0x33
  800c08:	68 1d 15 80 00       	push   $0x80151d
  800c0d:	e8 b1 02 00 00       	call   800ec3 <_panic>

00800c12 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c18:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1d:	b8 02 00 00 00       	mov    $0x2,%eax
  800c22:	89 d1                	mov    %edx,%ecx
  800c24:	89 d3                	mov    %edx,%ebx
  800c26:	89 d7                	mov    %edx,%edi
  800c28:	89 d6                	mov    %edx,%esi
  800c2a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c2c:	5b                   	pop    %ebx
  800c2d:	5e                   	pop    %esi
  800c2e:	5f                   	pop    %edi
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <sys_yield>:

void
sys_yield(void)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c41:	89 d1                	mov    %edx,%ecx
  800c43:	89 d3                	mov    %edx,%ebx
  800c45:	89 d7                	mov    %edx,%edi
  800c47:	89 d6                	mov    %edx,%esi
  800c49:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5f                   	pop    %edi
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	57                   	push   %edi
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
  800c56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c59:	be 00 00 00 00       	mov    $0x0,%esi
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c64:	b8 04 00 00 00       	mov    $0x4,%eax
  800c69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6c:	89 f7                	mov    %esi,%edi
  800c6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c70:	85 c0                	test   %eax,%eax
  800c72:	7f 08                	jg     800c7c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c77:	5b                   	pop    %ebx
  800c78:	5e                   	pop    %esi
  800c79:	5f                   	pop    %edi
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7c:	83 ec 0c             	sub    $0xc,%esp
  800c7f:	50                   	push   %eax
  800c80:	6a 04                	push   $0x4
  800c82:	68 00 15 80 00       	push   $0x801500
  800c87:	6a 33                	push   $0x33
  800c89:	68 1d 15 80 00       	push   $0x80151d
  800c8e:	e8 30 02 00 00       	call   800ec3 <_panic>

00800c93 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca2:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800caa:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cad:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	7f 08                	jg     800cbe <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbe:	83 ec 0c             	sub    $0xc,%esp
  800cc1:	50                   	push   %eax
  800cc2:	6a 05                	push   $0x5
  800cc4:	68 00 15 80 00       	push   $0x801500
  800cc9:	6a 33                	push   $0x33
  800ccb:	68 1d 15 80 00       	push   $0x80151d
  800cd0:	e8 ee 01 00 00       	call   800ec3 <_panic>

00800cd5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
  800cdb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cde:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce9:	b8 06 00 00 00       	mov    $0x6,%eax
  800cee:	89 df                	mov    %ebx,%edi
  800cf0:	89 de                	mov    %ebx,%esi
  800cf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 06                	push   $0x6
  800d06:	68 00 15 80 00       	push   $0x801500
  800d0b:	6a 33                	push   $0x33
  800d0d:	68 1d 15 80 00       	push   $0x80151d
  800d12:	e8 ac 01 00 00       	call   800ec3 <_panic>

00800d17 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d20:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2d:	89 cb                	mov    %ecx,%ebx
  800d2f:	89 cf                	mov    %ecx,%edi
  800d31:	89 ce                	mov    %ecx,%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d41:	83 ec 0c             	sub    $0xc,%esp
  800d44:	50                   	push   %eax
  800d45:	6a 0b                	push   $0xb
  800d47:	68 00 15 80 00       	push   $0x801500
  800d4c:	6a 33                	push   $0x33
  800d4e:	68 1d 15 80 00       	push   $0x80151d
  800d53:	e8 6b 01 00 00       	call   800ec3 <_panic>

00800d58 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d71:	89 df                	mov    %ebx,%edi
  800d73:	89 de                	mov    %ebx,%esi
  800d75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7f 08                	jg     800d83 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	50                   	push   %eax
  800d87:	6a 08                	push   $0x8
  800d89:	68 00 15 80 00       	push   $0x801500
  800d8e:	6a 33                	push   $0x33
  800d90:	68 1d 15 80 00       	push   $0x80151d
  800d95:	e8 29 01 00 00       	call   800ec3 <_panic>

00800d9a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dae:	b8 09 00 00 00       	mov    $0x9,%eax
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	89 de                	mov    %ebx,%esi
  800db7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7f 08                	jg     800dc5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	50                   	push   %eax
  800dc9:	6a 09                	push   $0x9
  800dcb:	68 00 15 80 00       	push   $0x801500
  800dd0:	6a 33                	push   $0x33
  800dd2:	68 1d 15 80 00       	push   $0x80151d
  800dd7:	e8 e7 00 00 00       	call   800ec3 <_panic>

00800ddc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df5:	89 df                	mov    %ebx,%edi
  800df7:	89 de                	mov    %ebx,%esi
  800df9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	7f 08                	jg     800e07 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	50                   	push   %eax
  800e0b:	6a 0a                	push   $0xa
  800e0d:	68 00 15 80 00       	push   $0x801500
  800e12:	6a 33                	push   $0x33
  800e14:	68 1d 15 80 00       	push   $0x80151d
  800e19:	e8 a5 00 00 00       	call   800ec3 <_panic>

00800e1e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e2f:	be 00 00 00 00       	mov    $0x0,%esi
  800e34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e37:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e57:	89 cb                	mov    %ecx,%ebx
  800e59:	89 cf                	mov    %ecx,%edi
  800e5b:	89 ce                	mov    %ecx,%esi
  800e5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7f 08                	jg     800e6b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	50                   	push   %eax
  800e6f:	6a 0e                	push   $0xe
  800e71:	68 00 15 80 00       	push   $0x801500
  800e76:	6a 33                	push   $0x33
  800e78:	68 1d 15 80 00       	push   $0x80151d
  800e7d:	e8 41 00 00 00       	call   800ec3 <_panic>

00800e82 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e93:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e98:	89 df                	mov    %ebx,%edi
  800e9a:	89 de                	mov    %ebx,%esi
  800e9c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	b8 10 00 00 00       	mov    $0x10,%eax
  800eb6:	89 cb                	mov    %ecx,%ebx
  800eb8:	89 cf                	mov    %ecx,%edi
  800eba:	89 ce                	mov    %ecx,%esi
  800ebc:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800ec8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ecb:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ed1:	e8 3c fd ff ff       	call   800c12 <sys_getenvid>
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	ff 75 0c             	pushl  0xc(%ebp)
  800edc:	ff 75 08             	pushl  0x8(%ebp)
  800edf:	56                   	push   %esi
  800ee0:	50                   	push   %eax
  800ee1:	68 2c 15 80 00       	push   $0x80152c
  800ee6:	e8 65 f2 ff ff       	call   800150 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800eeb:	83 c4 18             	add    $0x18,%esp
  800eee:	53                   	push   %ebx
  800eef:	ff 75 10             	pushl  0x10(%ebp)
  800ef2:	e8 08 f2 ff ff       	call   8000ff <vcprintf>
	cprintf("\n");
  800ef7:	c7 04 24 6c 11 80 00 	movl   $0x80116c,(%esp)
  800efe:	e8 4d f2 ff ff       	call   800150 <cprintf>
  800f03:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f06:	cc                   	int3   
  800f07:	eb fd                	jmp    800f06 <_panic+0x43>
  800f09:	66 90                	xchg   %ax,%ax
  800f0b:	66 90                	xchg   %ax,%ax
  800f0d:	66 90                	xchg   %ax,%ax
  800f0f:	90                   	nop

00800f10 <__udivdi3>:
  800f10:	55                   	push   %ebp
  800f11:	57                   	push   %edi
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
  800f14:	83 ec 1c             	sub    $0x1c,%esp
  800f17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f27:	85 d2                	test   %edx,%edx
  800f29:	75 4d                	jne    800f78 <__udivdi3+0x68>
  800f2b:	39 f3                	cmp    %esi,%ebx
  800f2d:	76 19                	jbe    800f48 <__udivdi3+0x38>
  800f2f:	31 ff                	xor    %edi,%edi
  800f31:	89 e8                	mov    %ebp,%eax
  800f33:	89 f2                	mov    %esi,%edx
  800f35:	f7 f3                	div    %ebx
  800f37:	89 fa                	mov    %edi,%edx
  800f39:	83 c4 1c             	add    $0x1c,%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
  800f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f48:	89 d9                	mov    %ebx,%ecx
  800f4a:	85 db                	test   %ebx,%ebx
  800f4c:	75 0b                	jne    800f59 <__udivdi3+0x49>
  800f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f53:	31 d2                	xor    %edx,%edx
  800f55:	f7 f3                	div    %ebx
  800f57:	89 c1                	mov    %eax,%ecx
  800f59:	31 d2                	xor    %edx,%edx
  800f5b:	89 f0                	mov    %esi,%eax
  800f5d:	f7 f1                	div    %ecx
  800f5f:	89 c6                	mov    %eax,%esi
  800f61:	89 e8                	mov    %ebp,%eax
  800f63:	89 f7                	mov    %esi,%edi
  800f65:	f7 f1                	div    %ecx
  800f67:	89 fa                	mov    %edi,%edx
  800f69:	83 c4 1c             	add    $0x1c,%esp
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    
  800f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f78:	39 f2                	cmp    %esi,%edx
  800f7a:	77 1c                	ja     800f98 <__udivdi3+0x88>
  800f7c:	0f bd fa             	bsr    %edx,%edi
  800f7f:	83 f7 1f             	xor    $0x1f,%edi
  800f82:	75 2c                	jne    800fb0 <__udivdi3+0xa0>
  800f84:	39 f2                	cmp    %esi,%edx
  800f86:	72 06                	jb     800f8e <__udivdi3+0x7e>
  800f88:	31 c0                	xor    %eax,%eax
  800f8a:	39 eb                	cmp    %ebp,%ebx
  800f8c:	77 a9                	ja     800f37 <__udivdi3+0x27>
  800f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f93:	eb a2                	jmp    800f37 <__udivdi3+0x27>
  800f95:	8d 76 00             	lea    0x0(%esi),%esi
  800f98:	31 ff                	xor    %edi,%edi
  800f9a:	31 c0                	xor    %eax,%eax
  800f9c:	89 fa                	mov    %edi,%edx
  800f9e:	83 c4 1c             	add    $0x1c,%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    
  800fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fad:	8d 76 00             	lea    0x0(%esi),%esi
  800fb0:	89 f9                	mov    %edi,%ecx
  800fb2:	b8 20 00 00 00       	mov    $0x20,%eax
  800fb7:	29 f8                	sub    %edi,%eax
  800fb9:	d3 e2                	shl    %cl,%edx
  800fbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fbf:	89 c1                	mov    %eax,%ecx
  800fc1:	89 da                	mov    %ebx,%edx
  800fc3:	d3 ea                	shr    %cl,%edx
  800fc5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fc9:	09 d1                	or     %edx,%ecx
  800fcb:	89 f2                	mov    %esi,%edx
  800fcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fd1:	89 f9                	mov    %edi,%ecx
  800fd3:	d3 e3                	shl    %cl,%ebx
  800fd5:	89 c1                	mov    %eax,%ecx
  800fd7:	d3 ea                	shr    %cl,%edx
  800fd9:	89 f9                	mov    %edi,%ecx
  800fdb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fdf:	89 eb                	mov    %ebp,%ebx
  800fe1:	d3 e6                	shl    %cl,%esi
  800fe3:	89 c1                	mov    %eax,%ecx
  800fe5:	d3 eb                	shr    %cl,%ebx
  800fe7:	09 de                	or     %ebx,%esi
  800fe9:	89 f0                	mov    %esi,%eax
  800feb:	f7 74 24 08          	divl   0x8(%esp)
  800fef:	89 d6                	mov    %edx,%esi
  800ff1:	89 c3                	mov    %eax,%ebx
  800ff3:	f7 64 24 0c          	mull   0xc(%esp)
  800ff7:	39 d6                	cmp    %edx,%esi
  800ff9:	72 15                	jb     801010 <__udivdi3+0x100>
  800ffb:	89 f9                	mov    %edi,%ecx
  800ffd:	d3 e5                	shl    %cl,%ebp
  800fff:	39 c5                	cmp    %eax,%ebp
  801001:	73 04                	jae    801007 <__udivdi3+0xf7>
  801003:	39 d6                	cmp    %edx,%esi
  801005:	74 09                	je     801010 <__udivdi3+0x100>
  801007:	89 d8                	mov    %ebx,%eax
  801009:	31 ff                	xor    %edi,%edi
  80100b:	e9 27 ff ff ff       	jmp    800f37 <__udivdi3+0x27>
  801010:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801013:	31 ff                	xor    %edi,%edi
  801015:	e9 1d ff ff ff       	jmp    800f37 <__udivdi3+0x27>
  80101a:	66 90                	xchg   %ax,%ax
  80101c:	66 90                	xchg   %ax,%ax
  80101e:	66 90                	xchg   %ax,%ax

00801020 <__umoddi3>:
  801020:	55                   	push   %ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	83 ec 1c             	sub    $0x1c,%esp
  801027:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80102b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80102f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801033:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801037:	89 da                	mov    %ebx,%edx
  801039:	85 c0                	test   %eax,%eax
  80103b:	75 43                	jne    801080 <__umoddi3+0x60>
  80103d:	39 df                	cmp    %ebx,%edi
  80103f:	76 17                	jbe    801058 <__umoddi3+0x38>
  801041:	89 f0                	mov    %esi,%eax
  801043:	f7 f7                	div    %edi
  801045:	89 d0                	mov    %edx,%eax
  801047:	31 d2                	xor    %edx,%edx
  801049:	83 c4 1c             	add    $0x1c,%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    
  801051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801058:	89 fd                	mov    %edi,%ebp
  80105a:	85 ff                	test   %edi,%edi
  80105c:	75 0b                	jne    801069 <__umoddi3+0x49>
  80105e:	b8 01 00 00 00       	mov    $0x1,%eax
  801063:	31 d2                	xor    %edx,%edx
  801065:	f7 f7                	div    %edi
  801067:	89 c5                	mov    %eax,%ebp
  801069:	89 d8                	mov    %ebx,%eax
  80106b:	31 d2                	xor    %edx,%edx
  80106d:	f7 f5                	div    %ebp
  80106f:	89 f0                	mov    %esi,%eax
  801071:	f7 f5                	div    %ebp
  801073:	89 d0                	mov    %edx,%eax
  801075:	eb d0                	jmp    801047 <__umoddi3+0x27>
  801077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80107e:	66 90                	xchg   %ax,%ax
  801080:	89 f1                	mov    %esi,%ecx
  801082:	39 d8                	cmp    %ebx,%eax
  801084:	76 0a                	jbe    801090 <__umoddi3+0x70>
  801086:	89 f0                	mov    %esi,%eax
  801088:	83 c4 1c             	add    $0x1c,%esp
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    
  801090:	0f bd e8             	bsr    %eax,%ebp
  801093:	83 f5 1f             	xor    $0x1f,%ebp
  801096:	75 20                	jne    8010b8 <__umoddi3+0x98>
  801098:	39 d8                	cmp    %ebx,%eax
  80109a:	0f 82 b0 00 00 00    	jb     801150 <__umoddi3+0x130>
  8010a0:	39 f7                	cmp    %esi,%edi
  8010a2:	0f 86 a8 00 00 00    	jbe    801150 <__umoddi3+0x130>
  8010a8:	89 c8                	mov    %ecx,%eax
  8010aa:	83 c4 1c             	add    $0x1c,%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
  8010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010b8:	89 e9                	mov    %ebp,%ecx
  8010ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8010bf:	29 ea                	sub    %ebp,%edx
  8010c1:	d3 e0                	shl    %cl,%eax
  8010c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010c7:	89 d1                	mov    %edx,%ecx
  8010c9:	89 f8                	mov    %edi,%eax
  8010cb:	d3 e8                	shr    %cl,%eax
  8010cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010d9:	09 c1                	or     %eax,%ecx
  8010db:	89 d8                	mov    %ebx,%eax
  8010dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010e1:	89 e9                	mov    %ebp,%ecx
  8010e3:	d3 e7                	shl    %cl,%edi
  8010e5:	89 d1                	mov    %edx,%ecx
  8010e7:	d3 e8                	shr    %cl,%eax
  8010e9:	89 e9                	mov    %ebp,%ecx
  8010eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010ef:	d3 e3                	shl    %cl,%ebx
  8010f1:	89 c7                	mov    %eax,%edi
  8010f3:	89 d1                	mov    %edx,%ecx
  8010f5:	89 f0                	mov    %esi,%eax
  8010f7:	d3 e8                	shr    %cl,%eax
  8010f9:	89 e9                	mov    %ebp,%ecx
  8010fb:	89 fa                	mov    %edi,%edx
  8010fd:	d3 e6                	shl    %cl,%esi
  8010ff:	09 d8                	or     %ebx,%eax
  801101:	f7 74 24 08          	divl   0x8(%esp)
  801105:	89 d1                	mov    %edx,%ecx
  801107:	89 f3                	mov    %esi,%ebx
  801109:	f7 64 24 0c          	mull   0xc(%esp)
  80110d:	89 c6                	mov    %eax,%esi
  80110f:	89 d7                	mov    %edx,%edi
  801111:	39 d1                	cmp    %edx,%ecx
  801113:	72 06                	jb     80111b <__umoddi3+0xfb>
  801115:	75 10                	jne    801127 <__umoddi3+0x107>
  801117:	39 c3                	cmp    %eax,%ebx
  801119:	73 0c                	jae    801127 <__umoddi3+0x107>
  80111b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80111f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801123:	89 d7                	mov    %edx,%edi
  801125:	89 c6                	mov    %eax,%esi
  801127:	89 ca                	mov    %ecx,%edx
  801129:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80112e:	29 f3                	sub    %esi,%ebx
  801130:	19 fa                	sbb    %edi,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	d3 e0                	shl    %cl,%eax
  801136:	89 e9                	mov    %ebp,%ecx
  801138:	d3 eb                	shr    %cl,%ebx
  80113a:	d3 ea                	shr    %cl,%edx
  80113c:	09 d8                	or     %ebx,%eax
  80113e:	83 c4 1c             	add    $0x1c,%esp
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    
  801146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80114d:	8d 76 00             	lea    0x0(%esi),%esi
  801150:	89 da                	mov    %ebx,%edx
  801152:	29 fe                	sub    %edi,%esi
  801154:	19 c2                	sbb    %eax,%edx
  801156:	89 f1                	mov    %esi,%ecx
  801158:	89 c8                	mov    %ecx,%eax
  80115a:	e9 4b ff ff ff       	jmp    8010aa <__umoddi3+0x8a>
