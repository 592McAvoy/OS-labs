
obj/user/faultread.debug:     file format elf32-i386


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

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800039:	ff 35 00 00 00 00    	pushl  0x0
  80003f:	68 60 11 80 00       	push   $0x801160
  800044:	e8 f5 00 00 00       	call   80013e <cprintf>
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
  800059:	e8 a2 0b 00 00       	call   800c00 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800066:	c1 e0 04             	shl    $0x4,%eax
  800069:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006e:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800073:	85 db                	test   %ebx,%ebx
  800075:	7e 07                	jle    80007e <libmain+0x30>
		binaryname = argv[0];
  800077:	8b 06                	mov    (%esi),%eax
  800079:	a3 00 20 80 00       	mov    %eax,0x802000

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
  80009f:	e8 1b 0b 00 00       	call   800bbf <sys_env_destroy>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	c9                   	leave  
  8000a8:	c3                   	ret    

008000a9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b3:	8b 13                	mov    (%ebx),%edx
  8000b5:	8d 42 01             	lea    0x1(%edx),%eax
  8000b8:	89 03                	mov    %eax,(%ebx)
  8000ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000bd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000c6:	74 09                	je     8000d1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000c8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	68 ff 00 00 00       	push   $0xff
  8000d9:	8d 43 08             	lea    0x8(%ebx),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 a0 0a 00 00       	call   800b82 <sys_cputs>
		b->idx = 0;
  8000e2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	eb db                	jmp    8000c8 <putch+0x1f>

008000ed <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000fd:	00 00 00 
	b.cnt = 0;
  800100:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800107:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80010a:	ff 75 0c             	pushl  0xc(%ebp)
  80010d:	ff 75 08             	pushl  0x8(%ebp)
  800110:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800116:	50                   	push   %eax
  800117:	68 a9 00 80 00       	push   $0x8000a9
  80011c:	e8 4a 01 00 00       	call   80026b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800121:	83 c4 08             	add    $0x8,%esp
  800124:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80012a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800130:	50                   	push   %eax
  800131:	e8 4c 0a 00 00       	call   800b82 <sys_cputs>

	return b.cnt;
}
  800136:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    

0080013e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800144:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800147:	50                   	push   %eax
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	e8 9d ff ff ff       	call   8000ed <vcprintf>
	va_end(ap);

	return cnt;
}
  800150:	c9                   	leave  
  800151:	c3                   	ret    

00800152 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	57                   	push   %edi
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
  800158:	83 ec 1c             	sub    $0x1c,%esp
  80015b:	89 c6                	mov    %eax,%esi
  80015d:	89 d7                	mov    %edx,%edi
  80015f:	8b 45 08             	mov    0x8(%ebp),%eax
  800162:	8b 55 0c             	mov    0xc(%ebp),%edx
  800165:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800168:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80016b:	8b 45 10             	mov    0x10(%ebp),%eax
  80016e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800171:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800175:	74 2c                	je     8001a3 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800177:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800181:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800184:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800187:	39 c2                	cmp    %eax,%edx
  800189:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80018c:	73 43                	jae    8001d1 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80018e:	83 eb 01             	sub    $0x1,%ebx
  800191:	85 db                	test   %ebx,%ebx
  800193:	7e 6c                	jle    800201 <printnum+0xaf>
			putch(padc, putdat);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	57                   	push   %edi
  800199:	ff 75 18             	pushl  0x18(%ebp)
  80019c:	ff d6                	call   *%esi
  80019e:	83 c4 10             	add    $0x10,%esp
  8001a1:	eb eb                	jmp    80018e <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	6a 20                	push   $0x20
  8001a8:	6a 00                	push   $0x0
  8001aa:	50                   	push   %eax
  8001ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b1:	89 fa                	mov    %edi,%edx
  8001b3:	89 f0                	mov    %esi,%eax
  8001b5:	e8 98 ff ff ff       	call   800152 <printnum>
		while (--width > 0)
  8001ba:	83 c4 20             	add    $0x20,%esp
  8001bd:	83 eb 01             	sub    $0x1,%ebx
  8001c0:	85 db                	test   %ebx,%ebx
  8001c2:	7e 65                	jle    800229 <printnum+0xd7>
			putch(padc, putdat);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	57                   	push   %edi
  8001c8:	6a 20                	push   $0x20
  8001ca:	ff d6                	call   *%esi
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	eb ec                	jmp    8001bd <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	ff 75 18             	pushl  0x18(%ebp)
  8001d7:	83 eb 01             	sub    $0x1,%ebx
  8001da:	53                   	push   %ebx
  8001db:	50                   	push   %eax
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001eb:	e8 10 0d 00 00       	call   800f00 <__udivdi3>
  8001f0:	83 c4 18             	add    $0x18,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	89 fa                	mov    %edi,%edx
  8001f7:	89 f0                	mov    %esi,%eax
  8001f9:	e8 54 ff ff ff       	call   800152 <printnum>
  8001fe:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	57                   	push   %edi
  800205:	83 ec 04             	sub    $0x4,%esp
  800208:	ff 75 dc             	pushl  -0x24(%ebp)
  80020b:	ff 75 d8             	pushl  -0x28(%ebp)
  80020e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800211:	ff 75 e0             	pushl  -0x20(%ebp)
  800214:	e8 f7 0d 00 00       	call   801010 <__umoddi3>
  800219:	83 c4 14             	add    $0x14,%esp
  80021c:	0f be 80 88 11 80 00 	movsbl 0x801188(%eax),%eax
  800223:	50                   	push   %eax
  800224:	ff d6                	call   *%esi
  800226:	83 c4 10             	add    $0x10,%esp
}
  800229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022c:	5b                   	pop    %ebx
  80022d:	5e                   	pop    %esi
  80022e:	5f                   	pop    %edi
  80022f:	5d                   	pop    %ebp
  800230:	c3                   	ret    

00800231 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800237:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80023b:	8b 10                	mov    (%eax),%edx
  80023d:	3b 50 04             	cmp    0x4(%eax),%edx
  800240:	73 0a                	jae    80024c <sprintputch+0x1b>
		*b->buf++ = ch;
  800242:	8d 4a 01             	lea    0x1(%edx),%ecx
  800245:	89 08                	mov    %ecx,(%eax)
  800247:	8b 45 08             	mov    0x8(%ebp),%eax
  80024a:	88 02                	mov    %al,(%edx)
}
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <printfmt>:
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800254:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800257:	50                   	push   %eax
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 0c             	pushl  0xc(%ebp)
  80025e:	ff 75 08             	pushl  0x8(%ebp)
  800261:	e8 05 00 00 00       	call   80026b <vprintfmt>
}
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <vprintfmt>:
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	57                   	push   %edi
  80026f:	56                   	push   %esi
  800270:	53                   	push   %ebx
  800271:	83 ec 3c             	sub    $0x3c,%esp
  800274:	8b 75 08             	mov    0x8(%ebp),%esi
  800277:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80027a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80027d:	e9 b4 03 00 00       	jmp    800636 <vprintfmt+0x3cb>
		padc = ' ';
  800282:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800286:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80028d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800294:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80029b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a7:	8d 47 01             	lea    0x1(%edi),%eax
  8002aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ad:	0f b6 17             	movzbl (%edi),%edx
  8002b0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b3:	3c 55                	cmp    $0x55,%al
  8002b5:	0f 87 c8 04 00 00    	ja     800783 <vprintfmt+0x518>
  8002bb:	0f b6 c0             	movzbl %al,%eax
  8002be:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8002c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8002c8:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8002cf:	eb d6                	jmp    8002a7 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8002d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002d4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002d8:	eb cd                	jmp    8002a7 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8002da:	0f b6 d2             	movzbl %dl,%edx
  8002dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8002e8:	eb 0c                	jmp    8002f6 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8002ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002ed:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8002f1:	eb b4                	jmp    8002a7 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8002f3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002f6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002f9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002fd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800300:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800303:	83 f9 09             	cmp    $0x9,%ecx
  800306:	76 eb                	jbe    8002f3 <vprintfmt+0x88>
  800308:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80030b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030e:	eb 14                	jmp    800324 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800310:	8b 45 14             	mov    0x14(%ebp),%eax
  800313:	8b 00                	mov    (%eax),%eax
  800315:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800318:	8b 45 14             	mov    0x14(%ebp),%eax
  80031b:	8d 40 04             	lea    0x4(%eax),%eax
  80031e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800321:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800324:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800328:	0f 89 79 ff ff ff    	jns    8002a7 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80032e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800331:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800334:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80033b:	e9 67 ff ff ff       	jmp    8002a7 <vprintfmt+0x3c>
  800340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800343:	85 c0                	test   %eax,%eax
  800345:	ba 00 00 00 00       	mov    $0x0,%edx
  80034a:	0f 49 d0             	cmovns %eax,%edx
  80034d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800353:	e9 4f ff ff ff       	jmp    8002a7 <vprintfmt+0x3c>
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800362:	e9 40 ff ff ff       	jmp    8002a7 <vprintfmt+0x3c>
			lflag++;
  800367:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80036d:	e9 35 ff ff ff       	jmp    8002a7 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800372:	8b 45 14             	mov    0x14(%ebp),%eax
  800375:	8d 78 04             	lea    0x4(%eax),%edi
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	53                   	push   %ebx
  80037c:	ff 30                	pushl  (%eax)
  80037e:	ff d6                	call   *%esi
			break;
  800380:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800383:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800386:	e9 a8 02 00 00       	jmp    800633 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80038b:	8b 45 14             	mov    0x14(%ebp),%eax
  80038e:	8d 78 04             	lea    0x4(%eax),%edi
  800391:	8b 00                	mov    (%eax),%eax
  800393:	99                   	cltd   
  800394:	31 d0                	xor    %edx,%eax
  800396:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800398:	83 f8 0f             	cmp    $0xf,%eax
  80039b:	7f 23                	jg     8003c0 <vprintfmt+0x155>
  80039d:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8003a4:	85 d2                	test   %edx,%edx
  8003a6:	74 18                	je     8003c0 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8003a8:	52                   	push   %edx
  8003a9:	68 a9 11 80 00       	push   $0x8011a9
  8003ae:	53                   	push   %ebx
  8003af:	56                   	push   %esi
  8003b0:	e8 99 fe ff ff       	call   80024e <printfmt>
  8003b5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003bb:	e9 73 02 00 00       	jmp    800633 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8003c0:	50                   	push   %eax
  8003c1:	68 a0 11 80 00       	push   $0x8011a0
  8003c6:	53                   	push   %ebx
  8003c7:	56                   	push   %esi
  8003c8:	e8 81 fe ff ff       	call   80024e <printfmt>
  8003cd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d3:	e9 5b 02 00 00       	jmp    800633 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	83 c0 04             	add    $0x4,%eax
  8003de:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003e6:	85 d2                	test   %edx,%edx
  8003e8:	b8 99 11 80 00       	mov    $0x801199,%eax
  8003ed:	0f 45 c2             	cmovne %edx,%eax
  8003f0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f7:	7e 06                	jle    8003ff <vprintfmt+0x194>
  8003f9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003fd:	75 0d                	jne    80040c <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800402:	89 c7                	mov    %eax,%edi
  800404:	03 45 e0             	add    -0x20(%ebp),%eax
  800407:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040a:	eb 53                	jmp    80045f <vprintfmt+0x1f4>
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	ff 75 d8             	pushl  -0x28(%ebp)
  800412:	50                   	push   %eax
  800413:	e8 13 04 00 00       	call   80082b <strnlen>
  800418:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80041b:	29 c1                	sub    %eax,%ecx
  80041d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800420:	83 c4 10             	add    $0x10,%esp
  800423:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800425:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800429:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80042c:	eb 0f                	jmp    80043d <vprintfmt+0x1d2>
					putch(padc, putdat);
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	53                   	push   %ebx
  800432:	ff 75 e0             	pushl  -0x20(%ebp)
  800435:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800437:	83 ef 01             	sub    $0x1,%edi
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	85 ff                	test   %edi,%edi
  80043f:	7f ed                	jg     80042e <vprintfmt+0x1c3>
  800441:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800444:	85 d2                	test   %edx,%edx
  800446:	b8 00 00 00 00       	mov    $0x0,%eax
  80044b:	0f 49 c2             	cmovns %edx,%eax
  80044e:	29 c2                	sub    %eax,%edx
  800450:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800453:	eb aa                	jmp    8003ff <vprintfmt+0x194>
					putch(ch, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	53                   	push   %ebx
  800459:	52                   	push   %edx
  80045a:	ff d6                	call   *%esi
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800462:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800464:	83 c7 01             	add    $0x1,%edi
  800467:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80046b:	0f be d0             	movsbl %al,%edx
  80046e:	85 d2                	test   %edx,%edx
  800470:	74 4b                	je     8004bd <vprintfmt+0x252>
  800472:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800476:	78 06                	js     80047e <vprintfmt+0x213>
  800478:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80047c:	78 1e                	js     80049c <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80047e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800482:	74 d1                	je     800455 <vprintfmt+0x1ea>
  800484:	0f be c0             	movsbl %al,%eax
  800487:	83 e8 20             	sub    $0x20,%eax
  80048a:	83 f8 5e             	cmp    $0x5e,%eax
  80048d:	76 c6                	jbe    800455 <vprintfmt+0x1ea>
					putch('?', putdat);
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	53                   	push   %ebx
  800493:	6a 3f                	push   $0x3f
  800495:	ff d6                	call   *%esi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	eb c3                	jmp    80045f <vprintfmt+0x1f4>
  80049c:	89 cf                	mov    %ecx,%edi
  80049e:	eb 0e                	jmp    8004ae <vprintfmt+0x243>
				putch(' ', putdat);
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	6a 20                	push   $0x20
  8004a6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a8:	83 ef 01             	sub    $0x1,%edi
  8004ab:	83 c4 10             	add    $0x10,%esp
  8004ae:	85 ff                	test   %edi,%edi
  8004b0:	7f ee                	jg     8004a0 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b8:	e9 76 01 00 00       	jmp    800633 <vprintfmt+0x3c8>
  8004bd:	89 cf                	mov    %ecx,%edi
  8004bf:	eb ed                	jmp    8004ae <vprintfmt+0x243>
	if (lflag >= 2)
  8004c1:	83 f9 01             	cmp    $0x1,%ecx
  8004c4:	7f 1f                	jg     8004e5 <vprintfmt+0x27a>
	else if (lflag)
  8004c6:	85 c9                	test   %ecx,%ecx
  8004c8:	74 6a                	je     800534 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d2:	89 c1                	mov    %eax,%ecx
  8004d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8004d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 40 04             	lea    0x4(%eax),%eax
  8004e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e3:	eb 17                	jmp    8004fc <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8004e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e8:	8b 50 04             	mov    0x4(%eax),%edx
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	8d 40 08             	lea    0x8(%eax),%eax
  8004f9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8004ff:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800504:	85 d2                	test   %edx,%edx
  800506:	0f 89 f8 00 00 00    	jns    800604 <vprintfmt+0x399>
				putch('-', putdat);
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	53                   	push   %ebx
  800510:	6a 2d                	push   $0x2d
  800512:	ff d6                	call   *%esi
				num = -(long long) num;
  800514:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800517:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80051a:	f7 d8                	neg    %eax
  80051c:	83 d2 00             	adc    $0x0,%edx
  80051f:	f7 da                	neg    %edx
  800521:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800524:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800527:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80052a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80052f:	e9 e1 00 00 00       	jmp    800615 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053c:	99                   	cltd   
  80053d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8d 40 04             	lea    0x4(%eax),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
  800549:	eb b1                	jmp    8004fc <vprintfmt+0x291>
	if (lflag >= 2)
  80054b:	83 f9 01             	cmp    $0x1,%ecx
  80054e:	7f 27                	jg     800577 <vprintfmt+0x30c>
	else if (lflag)
  800550:	85 c9                	test   %ecx,%ecx
  800552:	74 41                	je     800595 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	ba 00 00 00 00       	mov    $0x0,%edx
  80055e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800561:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8d 40 04             	lea    0x4(%eax),%eax
  80056a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800572:	e9 8d 00 00 00       	jmp    800604 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 50 04             	mov    0x4(%eax),%edx
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800582:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 40 08             	lea    0x8(%eax),%eax
  80058b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800593:	eb 6f                	jmp    800604 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	ba 00 00 00 00       	mov    $0x0,%edx
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8d 40 04             	lea    0x4(%eax),%eax
  8005ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ae:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005b3:	eb 4f                	jmp    800604 <vprintfmt+0x399>
	if (lflag >= 2)
  8005b5:	83 f9 01             	cmp    $0x1,%ecx
  8005b8:	7f 23                	jg     8005dd <vprintfmt+0x372>
	else if (lflag)
  8005ba:	85 c9                	test   %ecx,%ecx
  8005bc:	0f 84 98 00 00 00    	je     80065a <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8d 40 04             	lea    0x4(%eax),%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005db:	eb 17                	jmp    8005f4 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 50 04             	mov    0x4(%eax),%edx
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 40 08             	lea    0x8(%eax),%eax
  8005f1:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 30                	push   $0x30
  8005fa:	ff d6                	call   *%esi
			goto number;
  8005fc:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8005ff:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800604:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800608:	74 0b                	je     800615 <vprintfmt+0x3aa>
				putch('+', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 2b                	push   $0x2b
  800610:	ff d6                	call   *%esi
  800612:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800615:	83 ec 0c             	sub    $0xc,%esp
  800618:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80061c:	50                   	push   %eax
  80061d:	ff 75 e0             	pushl  -0x20(%ebp)
  800620:	57                   	push   %edi
  800621:	ff 75 dc             	pushl  -0x24(%ebp)
  800624:	ff 75 d8             	pushl  -0x28(%ebp)
  800627:	89 da                	mov    %ebx,%edx
  800629:	89 f0                	mov    %esi,%eax
  80062b:	e8 22 fb ff ff       	call   800152 <printnum>
			break;
  800630:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800633:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800636:	83 c7 01             	add    $0x1,%edi
  800639:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80063d:	83 f8 25             	cmp    $0x25,%eax
  800640:	0f 84 3c fc ff ff    	je     800282 <vprintfmt+0x17>
			if (ch == '\0')
  800646:	85 c0                	test   %eax,%eax
  800648:	0f 84 55 01 00 00    	je     8007a3 <vprintfmt+0x538>
			putch(ch, putdat);
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	53                   	push   %ebx
  800652:	50                   	push   %eax
  800653:	ff d6                	call   *%esi
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb dc                	jmp    800636 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	ba 00 00 00 00       	mov    $0x0,%edx
  800664:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800667:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 40 04             	lea    0x4(%eax),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
  800673:	e9 7c ff ff ff       	jmp    8005f4 <vprintfmt+0x389>
			putch('0', putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	6a 30                	push   $0x30
  80067e:	ff d6                	call   *%esi
			putch('x', putdat);
  800680:	83 c4 08             	add    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 78                	push   $0x78
  800686:	ff d6                	call   *%esi
			num = (unsigned long long)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	ba 00 00 00 00       	mov    $0x0,%edx
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800695:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800698:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a4:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8006a9:	e9 56 ff ff ff       	jmp    800604 <vprintfmt+0x399>
	if (lflag >= 2)
  8006ae:	83 f9 01             	cmp    $0x1,%ecx
  8006b1:	7f 27                	jg     8006da <vprintfmt+0x46f>
	else if (lflag)
  8006b3:	85 c9                	test   %ecx,%ecx
  8006b5:	74 44                	je     8006fb <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 40 04             	lea    0x4(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d0:	bf 10 00 00 00       	mov    $0x10,%edi
  8006d5:	e9 2a ff ff ff       	jmp    800604 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 40 08             	lea    0x8(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f1:	bf 10 00 00 00       	mov    $0x10,%edi
  8006f6:	e9 09 ff ff ff       	jmp    800604 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800714:	bf 10 00 00 00       	mov    $0x10,%edi
  800719:	e9 e6 fe ff ff       	jmp    800604 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 78 04             	lea    0x4(%eax),%edi
  800724:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800726:	85 c0                	test   %eax,%eax
  800728:	74 2d                	je     800757 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80072a:	0f b6 13             	movzbl (%ebx),%edx
  80072d:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80072f:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800732:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800735:	0f 8e f8 fe ff ff    	jle    800633 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80073b:	68 f8 12 80 00       	push   $0x8012f8
  800740:	68 a9 11 80 00       	push   $0x8011a9
  800745:	53                   	push   %ebx
  800746:	56                   	push   %esi
  800747:	e8 02 fb ff ff       	call   80024e <printfmt>
  80074c:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80074f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800752:	e9 dc fe ff ff       	jmp    800633 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800757:	68 c0 12 80 00       	push   $0x8012c0
  80075c:	68 a9 11 80 00       	push   $0x8011a9
  800761:	53                   	push   %ebx
  800762:	56                   	push   %esi
  800763:	e8 e6 fa ff ff       	call   80024e <printfmt>
  800768:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80076b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80076e:	e9 c0 fe ff ff       	jmp    800633 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	6a 25                	push   $0x25
  800779:	ff d6                	call   *%esi
			break;
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	e9 b0 fe ff ff       	jmp    800633 <vprintfmt+0x3c8>
			putch('%', putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 25                	push   $0x25
  800789:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	89 f8                	mov    %edi,%eax
  800790:	eb 03                	jmp    800795 <vprintfmt+0x52a>
  800792:	83 e8 01             	sub    $0x1,%eax
  800795:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800799:	75 f7                	jne    800792 <vprintfmt+0x527>
  80079b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079e:	e9 90 fe ff ff       	jmp    800633 <vprintfmt+0x3c8>
}
  8007a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a6:	5b                   	pop    %ebx
  8007a7:	5e                   	pop    %esi
  8007a8:	5f                   	pop    %edi
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	83 ec 18             	sub    $0x18,%esp
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ba:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007be:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c8:	85 c0                	test   %eax,%eax
  8007ca:	74 26                	je     8007f2 <vsnprintf+0x47>
  8007cc:	85 d2                	test   %edx,%edx
  8007ce:	7e 22                	jle    8007f2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d0:	ff 75 14             	pushl  0x14(%ebp)
  8007d3:	ff 75 10             	pushl  0x10(%ebp)
  8007d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d9:	50                   	push   %eax
  8007da:	68 31 02 80 00       	push   $0x800231
  8007df:	e8 87 fa ff ff       	call   80026b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
}
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    
		return -E_INVAL;
  8007f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f7:	eb f7                	jmp    8007f0 <vsnprintf+0x45>

008007f9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ff:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800802:	50                   	push   %eax
  800803:	ff 75 10             	pushl  0x10(%ebp)
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	ff 75 08             	pushl  0x8(%ebp)
  80080c:	e8 9a ff ff ff       	call   8007ab <vsnprintf>
	va_end(ap);

	return rc;
}
  800811:	c9                   	leave  
  800812:	c3                   	ret    

00800813 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800819:	b8 00 00 00 00       	mov    $0x0,%eax
  80081e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800822:	74 05                	je     800829 <strlen+0x16>
		n++;
  800824:	83 c0 01             	add    $0x1,%eax
  800827:	eb f5                	jmp    80081e <strlen+0xb>
	return n;
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800831:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800834:	ba 00 00 00 00       	mov    $0x0,%edx
  800839:	39 c2                	cmp    %eax,%edx
  80083b:	74 0d                	je     80084a <strnlen+0x1f>
  80083d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800841:	74 05                	je     800848 <strnlen+0x1d>
		n++;
  800843:	83 c2 01             	add    $0x1,%edx
  800846:	eb f1                	jmp    800839 <strnlen+0xe>
  800848:	89 d0                	mov    %edx,%eax
	return n;
}
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	53                   	push   %ebx
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800856:	ba 00 00 00 00       	mov    $0x0,%edx
  80085b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80085f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800862:	83 c2 01             	add    $0x1,%edx
  800865:	84 c9                	test   %cl,%cl
  800867:	75 f2                	jne    80085b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800869:	5b                   	pop    %ebx
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	53                   	push   %ebx
  800870:	83 ec 10             	sub    $0x10,%esp
  800873:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800876:	53                   	push   %ebx
  800877:	e8 97 ff ff ff       	call   800813 <strlen>
  80087c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	01 d8                	add    %ebx,%eax
  800884:	50                   	push   %eax
  800885:	e8 c2 ff ff ff       	call   80084c <strcpy>
	return dst;
}
  80088a:	89 d8                	mov    %ebx,%eax
  80088c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088f:	c9                   	leave  
  800890:	c3                   	ret    

00800891 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	56                   	push   %esi
  800895:	53                   	push   %ebx
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089c:	89 c6                	mov    %eax,%esi
  80089e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a1:	89 c2                	mov    %eax,%edx
  8008a3:	39 f2                	cmp    %esi,%edx
  8008a5:	74 11                	je     8008b8 <strncpy+0x27>
		*dst++ = *src;
  8008a7:	83 c2 01             	add    $0x1,%edx
  8008aa:	0f b6 19             	movzbl (%ecx),%ebx
  8008ad:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b0:	80 fb 01             	cmp    $0x1,%bl
  8008b3:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008b6:	eb eb                	jmp    8008a3 <strncpy+0x12>
	}
	return ret;
}
  8008b8:	5b                   	pop    %ebx
  8008b9:	5e                   	pop    %esi
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	56                   	push   %esi
  8008c0:	53                   	push   %ebx
  8008c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c7:	8b 55 10             	mov    0x10(%ebp),%edx
  8008ca:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008cc:	85 d2                	test   %edx,%edx
  8008ce:	74 21                	je     8008f1 <strlcpy+0x35>
  8008d0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008d4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008d6:	39 c2                	cmp    %eax,%edx
  8008d8:	74 14                	je     8008ee <strlcpy+0x32>
  8008da:	0f b6 19             	movzbl (%ecx),%ebx
  8008dd:	84 db                	test   %bl,%bl
  8008df:	74 0b                	je     8008ec <strlcpy+0x30>
			*dst++ = *src++;
  8008e1:	83 c1 01             	add    $0x1,%ecx
  8008e4:	83 c2 01             	add    $0x1,%edx
  8008e7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008ea:	eb ea                	jmp    8008d6 <strlcpy+0x1a>
  8008ec:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008ee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f1:	29 f0                	sub    %esi,%eax
}
  8008f3:	5b                   	pop    %ebx
  8008f4:	5e                   	pop    %esi
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800900:	0f b6 01             	movzbl (%ecx),%eax
  800903:	84 c0                	test   %al,%al
  800905:	74 0c                	je     800913 <strcmp+0x1c>
  800907:	3a 02                	cmp    (%edx),%al
  800909:	75 08                	jne    800913 <strcmp+0x1c>
		p++, q++;
  80090b:	83 c1 01             	add    $0x1,%ecx
  80090e:	83 c2 01             	add    $0x1,%edx
  800911:	eb ed                	jmp    800900 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800913:	0f b6 c0             	movzbl %al,%eax
  800916:	0f b6 12             	movzbl (%edx),%edx
  800919:	29 d0                	sub    %edx,%eax
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	53                   	push   %ebx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 55 0c             	mov    0xc(%ebp),%edx
  800927:	89 c3                	mov    %eax,%ebx
  800929:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80092c:	eb 06                	jmp    800934 <strncmp+0x17>
		n--, p++, q++;
  80092e:	83 c0 01             	add    $0x1,%eax
  800931:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800934:	39 d8                	cmp    %ebx,%eax
  800936:	74 16                	je     80094e <strncmp+0x31>
  800938:	0f b6 08             	movzbl (%eax),%ecx
  80093b:	84 c9                	test   %cl,%cl
  80093d:	74 04                	je     800943 <strncmp+0x26>
  80093f:	3a 0a                	cmp    (%edx),%cl
  800941:	74 eb                	je     80092e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800943:	0f b6 00             	movzbl (%eax),%eax
  800946:	0f b6 12             	movzbl (%edx),%edx
  800949:	29 d0                	sub    %edx,%eax
}
  80094b:	5b                   	pop    %ebx
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    
		return 0;
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
  800953:	eb f6                	jmp    80094b <strncmp+0x2e>

00800955 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095f:	0f b6 10             	movzbl (%eax),%edx
  800962:	84 d2                	test   %dl,%dl
  800964:	74 09                	je     80096f <strchr+0x1a>
		if (*s == c)
  800966:	38 ca                	cmp    %cl,%dl
  800968:	74 0a                	je     800974 <strchr+0x1f>
	for (; *s; s++)
  80096a:	83 c0 01             	add    $0x1,%eax
  80096d:	eb f0                	jmp    80095f <strchr+0xa>
			return (char *) s;
	return 0;
  80096f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800980:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800983:	38 ca                	cmp    %cl,%dl
  800985:	74 09                	je     800990 <strfind+0x1a>
  800987:	84 d2                	test   %dl,%dl
  800989:	74 05                	je     800990 <strfind+0x1a>
	for (; *s; s++)
  80098b:	83 c0 01             	add    $0x1,%eax
  80098e:	eb f0                	jmp    800980 <strfind+0xa>
			break;
	return (char *) s;
}
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	57                   	push   %edi
  800996:	56                   	push   %esi
  800997:	53                   	push   %ebx
  800998:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80099e:	85 c9                	test   %ecx,%ecx
  8009a0:	74 31                	je     8009d3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a2:	89 f8                	mov    %edi,%eax
  8009a4:	09 c8                	or     %ecx,%eax
  8009a6:	a8 03                	test   $0x3,%al
  8009a8:	75 23                	jne    8009cd <memset+0x3b>
		c &= 0xFF;
  8009aa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ae:	89 d3                	mov    %edx,%ebx
  8009b0:	c1 e3 08             	shl    $0x8,%ebx
  8009b3:	89 d0                	mov    %edx,%eax
  8009b5:	c1 e0 18             	shl    $0x18,%eax
  8009b8:	89 d6                	mov    %edx,%esi
  8009ba:	c1 e6 10             	shl    $0x10,%esi
  8009bd:	09 f0                	or     %esi,%eax
  8009bf:	09 c2                	or     %eax,%edx
  8009c1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009c3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009c6:	89 d0                	mov    %edx,%eax
  8009c8:	fc                   	cld    
  8009c9:	f3 ab                	rep stos %eax,%es:(%edi)
  8009cb:	eb 06                	jmp    8009d3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d0:	fc                   	cld    
  8009d1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009d3:	89 f8                	mov    %edi,%eax
  8009d5:	5b                   	pop    %ebx
  8009d6:	5e                   	pop    %esi
  8009d7:	5f                   	pop    %edi
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	57                   	push   %edi
  8009de:	56                   	push   %esi
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e8:	39 c6                	cmp    %eax,%esi
  8009ea:	73 32                	jae    800a1e <memmove+0x44>
  8009ec:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ef:	39 c2                	cmp    %eax,%edx
  8009f1:	76 2b                	jbe    800a1e <memmove+0x44>
		s += n;
		d += n;
  8009f3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f6:	89 fe                	mov    %edi,%esi
  8009f8:	09 ce                	or     %ecx,%esi
  8009fa:	09 d6                	or     %edx,%esi
  8009fc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a02:	75 0e                	jne    800a12 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a04:	83 ef 04             	sub    $0x4,%edi
  800a07:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a0a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a0d:	fd                   	std    
  800a0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a10:	eb 09                	jmp    800a1b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a12:	83 ef 01             	sub    $0x1,%edi
  800a15:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a18:	fd                   	std    
  800a19:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a1b:	fc                   	cld    
  800a1c:	eb 1a                	jmp    800a38 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1e:	89 c2                	mov    %eax,%edx
  800a20:	09 ca                	or     %ecx,%edx
  800a22:	09 f2                	or     %esi,%edx
  800a24:	f6 c2 03             	test   $0x3,%dl
  800a27:	75 0a                	jne    800a33 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a29:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a2c:	89 c7                	mov    %eax,%edi
  800a2e:	fc                   	cld    
  800a2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a31:	eb 05                	jmp    800a38 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a33:	89 c7                	mov    %eax,%edi
  800a35:	fc                   	cld    
  800a36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a38:	5e                   	pop    %esi
  800a39:	5f                   	pop    %edi
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a42:	ff 75 10             	pushl  0x10(%ebp)
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	ff 75 08             	pushl  0x8(%ebp)
  800a4b:	e8 8a ff ff ff       	call   8009da <memmove>
}
  800a50:	c9                   	leave  
  800a51:	c3                   	ret    

00800a52 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	56                   	push   %esi
  800a56:	53                   	push   %ebx
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5d:	89 c6                	mov    %eax,%esi
  800a5f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a62:	39 f0                	cmp    %esi,%eax
  800a64:	74 1c                	je     800a82 <memcmp+0x30>
		if (*s1 != *s2)
  800a66:	0f b6 08             	movzbl (%eax),%ecx
  800a69:	0f b6 1a             	movzbl (%edx),%ebx
  800a6c:	38 d9                	cmp    %bl,%cl
  800a6e:	75 08                	jne    800a78 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a70:	83 c0 01             	add    $0x1,%eax
  800a73:	83 c2 01             	add    $0x1,%edx
  800a76:	eb ea                	jmp    800a62 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a78:	0f b6 c1             	movzbl %cl,%eax
  800a7b:	0f b6 db             	movzbl %bl,%ebx
  800a7e:	29 d8                	sub    %ebx,%eax
  800a80:	eb 05                	jmp    800a87 <memcmp+0x35>
	}

	return 0;
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a87:	5b                   	pop    %ebx
  800a88:	5e                   	pop    %esi
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a94:	89 c2                	mov    %eax,%edx
  800a96:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a99:	39 d0                	cmp    %edx,%eax
  800a9b:	73 09                	jae    800aa6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9d:	38 08                	cmp    %cl,(%eax)
  800a9f:	74 05                	je     800aa6 <memfind+0x1b>
	for (; s < ends; s++)
  800aa1:	83 c0 01             	add    $0x1,%eax
  800aa4:	eb f3                	jmp    800a99 <memfind+0xe>
			break;
	return (void *) s;
}
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	57                   	push   %edi
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
  800aae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab4:	eb 03                	jmp    800ab9 <strtol+0x11>
		s++;
  800ab6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ab9:	0f b6 01             	movzbl (%ecx),%eax
  800abc:	3c 20                	cmp    $0x20,%al
  800abe:	74 f6                	je     800ab6 <strtol+0xe>
  800ac0:	3c 09                	cmp    $0x9,%al
  800ac2:	74 f2                	je     800ab6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ac4:	3c 2b                	cmp    $0x2b,%al
  800ac6:	74 2a                	je     800af2 <strtol+0x4a>
	int neg = 0;
  800ac8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800acd:	3c 2d                	cmp    $0x2d,%al
  800acf:	74 2b                	je     800afc <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ad7:	75 0f                	jne    800ae8 <strtol+0x40>
  800ad9:	80 39 30             	cmpb   $0x30,(%ecx)
  800adc:	74 28                	je     800b06 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ade:	85 db                	test   %ebx,%ebx
  800ae0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae5:	0f 44 d8             	cmove  %eax,%ebx
  800ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  800aed:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af0:	eb 50                	jmp    800b42 <strtol+0x9a>
		s++;
  800af2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800af5:	bf 00 00 00 00       	mov    $0x0,%edi
  800afa:	eb d5                	jmp    800ad1 <strtol+0x29>
		s++, neg = 1;
  800afc:	83 c1 01             	add    $0x1,%ecx
  800aff:	bf 01 00 00 00       	mov    $0x1,%edi
  800b04:	eb cb                	jmp    800ad1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b06:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b0a:	74 0e                	je     800b1a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b0c:	85 db                	test   %ebx,%ebx
  800b0e:	75 d8                	jne    800ae8 <strtol+0x40>
		s++, base = 8;
  800b10:	83 c1 01             	add    $0x1,%ecx
  800b13:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b18:	eb ce                	jmp    800ae8 <strtol+0x40>
		s += 2, base = 16;
  800b1a:	83 c1 02             	add    $0x2,%ecx
  800b1d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b22:	eb c4                	jmp    800ae8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b24:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b27:	89 f3                	mov    %esi,%ebx
  800b29:	80 fb 19             	cmp    $0x19,%bl
  800b2c:	77 29                	ja     800b57 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b2e:	0f be d2             	movsbl %dl,%edx
  800b31:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b34:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b37:	7d 30                	jge    800b69 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b39:	83 c1 01             	add    $0x1,%ecx
  800b3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b42:	0f b6 11             	movzbl (%ecx),%edx
  800b45:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b48:	89 f3                	mov    %esi,%ebx
  800b4a:	80 fb 09             	cmp    $0x9,%bl
  800b4d:	77 d5                	ja     800b24 <strtol+0x7c>
			dig = *s - '0';
  800b4f:	0f be d2             	movsbl %dl,%edx
  800b52:	83 ea 30             	sub    $0x30,%edx
  800b55:	eb dd                	jmp    800b34 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b57:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b5a:	89 f3                	mov    %esi,%ebx
  800b5c:	80 fb 19             	cmp    $0x19,%bl
  800b5f:	77 08                	ja     800b69 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b61:	0f be d2             	movsbl %dl,%edx
  800b64:	83 ea 37             	sub    $0x37,%edx
  800b67:	eb cb                	jmp    800b34 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6d:	74 05                	je     800b74 <strtol+0xcc>
		*endptr = (char *) s;
  800b6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b72:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b74:	89 c2                	mov    %eax,%edx
  800b76:	f7 da                	neg    %edx
  800b78:	85 ff                	test   %edi,%edi
  800b7a:	0f 45 c2             	cmovne %edx,%eax
}
  800b7d:	5b                   	pop    %ebx
  800b7e:	5e                   	pop    %esi
  800b7f:	5f                   	pop    %edi
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b88:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b93:	89 c3                	mov    %eax,%ebx
  800b95:	89 c7                	mov    %eax,%edi
  800b97:	89 c6                	mov    %eax,%esi
  800b99:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bab:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb0:	89 d1                	mov    %edx,%ecx
  800bb2:	89 d3                	mov    %edx,%ebx
  800bb4:	89 d7                	mov    %edx,%edi
  800bb6:	89 d6                	mov    %edx,%esi
  800bb8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5e                   	pop    %esi
  800bbc:	5f                   	pop    %edi
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd0:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd5:	89 cb                	mov    %ecx,%ebx
  800bd7:	89 cf                	mov    %ecx,%edi
  800bd9:	89 ce                	mov    %ecx,%esi
  800bdb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bdd:	85 c0                	test   %eax,%eax
  800bdf:	7f 08                	jg     800be9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be9:	83 ec 0c             	sub    $0xc,%esp
  800bec:	50                   	push   %eax
  800bed:	6a 03                	push   $0x3
  800bef:	68 00 15 80 00       	push   $0x801500
  800bf4:	6a 33                	push   $0x33
  800bf6:	68 1d 15 80 00       	push   $0x80151d
  800bfb:	e8 b1 02 00 00       	call   800eb1 <_panic>

00800c00 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	57                   	push   %edi
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c06:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c10:	89 d1                	mov    %edx,%ecx
  800c12:	89 d3                	mov    %edx,%ebx
  800c14:	89 d7                	mov    %edx,%edi
  800c16:	89 d6                	mov    %edx,%esi
  800c18:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <sys_yield>:

void
sys_yield(void)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c25:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c2f:	89 d1                	mov    %edx,%ecx
  800c31:	89 d3                	mov    %edx,%ebx
  800c33:	89 d7                	mov    %edx,%edi
  800c35:	89 d6                	mov    %edx,%esi
  800c37:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c39:	5b                   	pop    %ebx
  800c3a:	5e                   	pop    %esi
  800c3b:	5f                   	pop    %edi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	57                   	push   %edi
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c47:	be 00 00 00 00       	mov    $0x0,%esi
  800c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c52:	b8 04 00 00 00       	mov    $0x4,%eax
  800c57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5a:	89 f7                	mov    %esi,%edi
  800c5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	7f 08                	jg     800c6a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	6a 04                	push   $0x4
  800c70:	68 00 15 80 00       	push   $0x801500
  800c75:	6a 33                	push   $0x33
  800c77:	68 1d 15 80 00       	push   $0x80151d
  800c7c:	e8 30 02 00 00       	call   800eb1 <_panic>

00800c81 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c90:	b8 05 00 00 00       	mov    $0x5,%eax
  800c95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c98:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c9b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	7f 08                	jg     800cac <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	50                   	push   %eax
  800cb0:	6a 05                	push   $0x5
  800cb2:	68 00 15 80 00       	push   $0x801500
  800cb7:	6a 33                	push   $0x33
  800cb9:	68 1d 15 80 00       	push   $0x80151d
  800cbe:	e8 ee 01 00 00       	call   800eb1 <_panic>

00800cc3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd7:	b8 06 00 00 00       	mov    $0x6,%eax
  800cdc:	89 df                	mov    %ebx,%edi
  800cde:	89 de                	mov    %ebx,%esi
  800ce0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	7f 08                	jg     800cee <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cee:	83 ec 0c             	sub    $0xc,%esp
  800cf1:	50                   	push   %eax
  800cf2:	6a 06                	push   $0x6
  800cf4:	68 00 15 80 00       	push   $0x801500
  800cf9:	6a 33                	push   $0x33
  800cfb:	68 1d 15 80 00       	push   $0x80151d
  800d00:	e8 ac 01 00 00       	call   800eb1 <_panic>

00800d05 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
  800d0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1b:	89 cb                	mov    %ecx,%ebx
  800d1d:	89 cf                	mov    %ecx,%edi
  800d1f:	89 ce                	mov    %ecx,%esi
  800d21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7f 08                	jg     800d2f <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	50                   	push   %eax
  800d33:	6a 0b                	push   $0xb
  800d35:	68 00 15 80 00       	push   $0x801500
  800d3a:	6a 33                	push   $0x33
  800d3c:	68 1d 15 80 00       	push   $0x80151d
  800d41:	e8 6b 01 00 00       	call   800eb1 <_panic>

00800d46 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5a:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5f:	89 df                	mov    %ebx,%edi
  800d61:	89 de                	mov    %ebx,%esi
  800d63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d65:	85 c0                	test   %eax,%eax
  800d67:	7f 08                	jg     800d71 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d71:	83 ec 0c             	sub    $0xc,%esp
  800d74:	50                   	push   %eax
  800d75:	6a 08                	push   $0x8
  800d77:	68 00 15 80 00       	push   $0x801500
  800d7c:	6a 33                	push   $0x33
  800d7e:	68 1d 15 80 00       	push   $0x80151d
  800d83:	e8 29 01 00 00       	call   800eb1 <_panic>

00800d88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	b8 09 00 00 00       	mov    $0x9,%eax
  800da1:	89 df                	mov    %ebx,%edi
  800da3:	89 de                	mov    %ebx,%esi
  800da5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	7f 08                	jg     800db3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800db7:	6a 09                	push   $0x9
  800db9:	68 00 15 80 00       	push   $0x801500
  800dbe:	6a 33                	push   $0x33
  800dc0:	68 1d 15 80 00       	push   $0x80151d
  800dc5:	e8 e7 00 00 00       	call   800eb1 <_panic>

00800dca <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
  800dd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de3:	89 df                	mov    %ebx,%edi
  800de5:	89 de                	mov    %ebx,%esi
  800de7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7f 08                	jg     800df5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	50                   	push   %eax
  800df9:	6a 0a                	push   $0xa
  800dfb:	68 00 15 80 00       	push   $0x801500
  800e00:	6a 33                	push   $0x33
  800e02:	68 1d 15 80 00       	push   $0x80151d
  800e07:	e8 a5 00 00 00       	call   800eb1 <_panic>

00800e0c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	57                   	push   %edi
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e1d:	be 00 00 00 00       	mov    $0x0,%esi
  800e22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e25:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e28:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e38:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e45:	89 cb                	mov    %ecx,%ebx
  800e47:	89 cf                	mov    %ecx,%edi
  800e49:	89 ce                	mov    %ecx,%esi
  800e4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	7f 08                	jg     800e59 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	50                   	push   %eax
  800e5d:	6a 0e                	push   $0xe
  800e5f:	68 00 15 80 00       	push   $0x801500
  800e64:	6a 33                	push   $0x33
  800e66:	68 1d 15 80 00       	push   $0x80151d
  800e6b:	e8 41 00 00 00       	call   800eb1 <_panic>

00800e70 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e86:	89 df                	mov    %ebx,%edi
  800e88:	89 de                	mov    %ebx,%esi
  800e8a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    

00800e91 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	b8 10 00 00 00       	mov    $0x10,%eax
  800ea4:	89 cb                	mov    %ecx,%ebx
  800ea6:	89 cf                	mov    %ecx,%edi
  800ea8:	89 ce                	mov    %ecx,%esi
  800eaa:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    

00800eb1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800eb6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800eb9:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ebf:	e8 3c fd ff ff       	call   800c00 <sys_getenvid>
  800ec4:	83 ec 0c             	sub    $0xc,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	ff 75 08             	pushl  0x8(%ebp)
  800ecd:	56                   	push   %esi
  800ece:	50                   	push   %eax
  800ecf:	68 2c 15 80 00       	push   $0x80152c
  800ed4:	e8 65 f2 ff ff       	call   80013e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ed9:	83 c4 18             	add    $0x18,%esp
  800edc:	53                   	push   %ebx
  800edd:	ff 75 10             	pushl  0x10(%ebp)
  800ee0:	e8 08 f2 ff ff       	call   8000ed <vcprintf>
	cprintf("\n");
  800ee5:	c7 04 24 7c 11 80 00 	movl   $0x80117c,(%esp)
  800eec:	e8 4d f2 ff ff       	call   80013e <cprintf>
  800ef1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ef4:	cc                   	int3   
  800ef5:	eb fd                	jmp    800ef4 <_panic+0x43>
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
