
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 60 11 80 00       	push   $0x801160
  80003e:	e8 0b 01 00 00       	call   80014e <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 04 20 80 00       	mov    0x802004,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 6e 11 80 00       	push   $0x80116e
  800054:	e8 f5 00 00 00       	call   80014e <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800069:	e8 a2 0b 00 00       	call   800c10 <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800076:	c1 e0 04             	shl    $0x4,%eax
  800079:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007e:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800083:	85 db                	test   %ebx,%ebx
  800085:	7e 07                	jle    80008e <libmain+0x30>
		binaryname = argv[0];
  800087:	8b 06                	mov    (%esi),%eax
  800089:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	56                   	push   %esi
  800092:	53                   	push   %ebx
  800093:	e8 9b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800098:	e8 0a 00 00 00       	call   8000a7 <exit>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a3:	5b                   	pop    %ebx
  8000a4:	5e                   	pop    %esi
  8000a5:	5d                   	pop    %ebp
  8000a6:	c3                   	ret    

008000a7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000ad:	6a 00                	push   $0x0
  8000af:	e8 1b 0b 00 00       	call   800bcf <sys_env_destroy>
}
  8000b4:	83 c4 10             	add    $0x10,%esp
  8000b7:	c9                   	leave  
  8000b8:	c3                   	ret    

008000b9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b9:	55                   	push   %ebp
  8000ba:	89 e5                	mov    %esp,%ebp
  8000bc:	53                   	push   %ebx
  8000bd:	83 ec 04             	sub    $0x4,%esp
  8000c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c3:	8b 13                	mov    (%ebx),%edx
  8000c5:	8d 42 01             	lea    0x1(%edx),%eax
  8000c8:	89 03                	mov    %eax,(%ebx)
  8000ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d6:	74 09                	je     8000e1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	68 ff 00 00 00       	push   $0xff
  8000e9:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ec:	50                   	push   %eax
  8000ed:	e8 a0 0a 00 00       	call   800b92 <sys_cputs>
		b->idx = 0;
  8000f2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	eb db                	jmp    8000d8 <putch+0x1f>

008000fd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000fd:	55                   	push   %ebp
  8000fe:	89 e5                	mov    %esp,%ebp
  800100:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800106:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010d:	00 00 00 
	b.cnt = 0;
  800110:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800117:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011a:	ff 75 0c             	pushl  0xc(%ebp)
  80011d:	ff 75 08             	pushl  0x8(%ebp)
  800120:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800126:	50                   	push   %eax
  800127:	68 b9 00 80 00       	push   $0x8000b9
  80012c:	e8 4a 01 00 00       	call   80027b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800131:	83 c4 08             	add    $0x8,%esp
  800134:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800140:	50                   	push   %eax
  800141:	e8 4c 0a 00 00       	call   800b92 <sys_cputs>

	return b.cnt;
}
  800146:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014c:	c9                   	leave  
  80014d:	c3                   	ret    

0080014e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800154:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800157:	50                   	push   %eax
  800158:	ff 75 08             	pushl  0x8(%ebp)
  80015b:	e8 9d ff ff ff       	call   8000fd <vcprintf>
	va_end(ap);

	return cnt;
}
  800160:	c9                   	leave  
  800161:	c3                   	ret    

00800162 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	57                   	push   %edi
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
  800168:	83 ec 1c             	sub    $0x1c,%esp
  80016b:	89 c6                	mov    %eax,%esi
  80016d:	89 d7                	mov    %edx,%edi
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	8b 55 0c             	mov    0xc(%ebp),%edx
  800175:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800178:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80017b:	8b 45 10             	mov    0x10(%ebp),%eax
  80017e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800181:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800185:	74 2c                	je     8001b3 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800187:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800191:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800194:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800197:	39 c2                	cmp    %eax,%edx
  800199:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80019c:	73 43                	jae    8001e1 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80019e:	83 eb 01             	sub    $0x1,%ebx
  8001a1:	85 db                	test   %ebx,%ebx
  8001a3:	7e 6c                	jle    800211 <printnum+0xaf>
			putch(padc, putdat);
  8001a5:	83 ec 08             	sub    $0x8,%esp
  8001a8:	57                   	push   %edi
  8001a9:	ff 75 18             	pushl  0x18(%ebp)
  8001ac:	ff d6                	call   *%esi
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	eb eb                	jmp    80019e <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	6a 20                	push   $0x20
  8001b8:	6a 00                	push   $0x0
  8001ba:	50                   	push   %eax
  8001bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001be:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c1:	89 fa                	mov    %edi,%edx
  8001c3:	89 f0                	mov    %esi,%eax
  8001c5:	e8 98 ff ff ff       	call   800162 <printnum>
		while (--width > 0)
  8001ca:	83 c4 20             	add    $0x20,%esp
  8001cd:	83 eb 01             	sub    $0x1,%ebx
  8001d0:	85 db                	test   %ebx,%ebx
  8001d2:	7e 65                	jle    800239 <printnum+0xd7>
			putch(padc, putdat);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	57                   	push   %edi
  8001d8:	6a 20                	push   $0x20
  8001da:	ff d6                	call   *%esi
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	eb ec                	jmp    8001cd <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	ff 75 18             	pushl  0x18(%ebp)
  8001e7:	83 eb 01             	sub    $0x1,%ebx
  8001ea:	53                   	push   %ebx
  8001eb:	50                   	push   %eax
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fb:	e8 10 0d 00 00       	call   800f10 <__udivdi3>
  800200:	83 c4 18             	add    $0x18,%esp
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	89 fa                	mov    %edi,%edx
  800207:	89 f0                	mov    %esi,%eax
  800209:	e8 54 ff ff ff       	call   800162 <printnum>
  80020e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	57                   	push   %edi
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	ff 75 dc             	pushl  -0x24(%ebp)
  80021b:	ff 75 d8             	pushl  -0x28(%ebp)
  80021e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800221:	ff 75 e0             	pushl  -0x20(%ebp)
  800224:	e8 f7 0d 00 00       	call   801020 <__umoddi3>
  800229:	83 c4 14             	add    $0x14,%esp
  80022c:	0f be 80 8f 11 80 00 	movsbl 0x80118f(%eax),%eax
  800233:	50                   	push   %eax
  800234:	ff d6                	call   *%esi
  800236:	83 c4 10             	add    $0x10,%esp
}
  800239:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023c:	5b                   	pop    %ebx
  80023d:	5e                   	pop    %esi
  80023e:	5f                   	pop    %edi
  80023f:	5d                   	pop    %ebp
  800240:	c3                   	ret    

00800241 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800247:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80024b:	8b 10                	mov    (%eax),%edx
  80024d:	3b 50 04             	cmp    0x4(%eax),%edx
  800250:	73 0a                	jae    80025c <sprintputch+0x1b>
		*b->buf++ = ch;
  800252:	8d 4a 01             	lea    0x1(%edx),%ecx
  800255:	89 08                	mov    %ecx,(%eax)
  800257:	8b 45 08             	mov    0x8(%ebp),%eax
  80025a:	88 02                	mov    %al,(%edx)
}
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    

0080025e <printfmt>:
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800264:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800267:	50                   	push   %eax
  800268:	ff 75 10             	pushl  0x10(%ebp)
  80026b:	ff 75 0c             	pushl  0xc(%ebp)
  80026e:	ff 75 08             	pushl  0x8(%ebp)
  800271:	e8 05 00 00 00       	call   80027b <vprintfmt>
}
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <vprintfmt>:
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 3c             	sub    $0x3c,%esp
  800284:	8b 75 08             	mov    0x8(%ebp),%esi
  800287:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80028d:	e9 b4 03 00 00       	jmp    800646 <vprintfmt+0x3cb>
		padc = ' ';
  800292:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800296:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80029d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002a4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b7:	8d 47 01             	lea    0x1(%edi),%eax
  8002ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002bd:	0f b6 17             	movzbl (%edi),%edx
  8002c0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c3:	3c 55                	cmp    $0x55,%al
  8002c5:	0f 87 c8 04 00 00    	ja     800793 <vprintfmt+0x518>
  8002cb:	0f b6 c0             	movzbl %al,%eax
  8002ce:	ff 24 85 80 13 80 00 	jmp    *0x801380(,%eax,4)
  8002d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8002d8:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8002df:	eb d6                	jmp    8002b7 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8002e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002e8:	eb cd                	jmp    8002b7 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8002ea:	0f b6 d2             	movzbl %dl,%edx
  8002ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8002f8:	eb 0c                	jmp    800306 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002fd:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800301:	eb b4                	jmp    8002b7 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800303:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800306:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800309:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800310:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800313:	83 f9 09             	cmp    $0x9,%ecx
  800316:	76 eb                	jbe    800303 <vprintfmt+0x88>
  800318:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80031b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031e:	eb 14                	jmp    800334 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800320:	8b 45 14             	mov    0x14(%ebp),%eax
  800323:	8b 00                	mov    (%eax),%eax
  800325:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800328:	8b 45 14             	mov    0x14(%ebp),%eax
  80032b:	8d 40 04             	lea    0x4(%eax),%eax
  80032e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800334:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800338:	0f 89 79 ff ff ff    	jns    8002b7 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80033e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800341:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800344:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80034b:	e9 67 ff ff ff       	jmp    8002b7 <vprintfmt+0x3c>
  800350:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800353:	85 c0                	test   %eax,%eax
  800355:	ba 00 00 00 00       	mov    $0x0,%edx
  80035a:	0f 49 d0             	cmovns %eax,%edx
  80035d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800363:	e9 4f ff ff ff       	jmp    8002b7 <vprintfmt+0x3c>
  800368:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80036b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800372:	e9 40 ff ff ff       	jmp    8002b7 <vprintfmt+0x3c>
			lflag++;
  800377:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037d:	e9 35 ff ff ff       	jmp    8002b7 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800382:	8b 45 14             	mov    0x14(%ebp),%eax
  800385:	8d 78 04             	lea    0x4(%eax),%edi
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	53                   	push   %ebx
  80038c:	ff 30                	pushl  (%eax)
  80038e:	ff d6                	call   *%esi
			break;
  800390:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800393:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800396:	e9 a8 02 00 00       	jmp    800643 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80039b:	8b 45 14             	mov    0x14(%ebp),%eax
  80039e:	8d 78 04             	lea    0x4(%eax),%edi
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	99                   	cltd   
  8003a4:	31 d0                	xor    %edx,%eax
  8003a6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a8:	83 f8 0f             	cmp    $0xf,%eax
  8003ab:	7f 23                	jg     8003d0 <vprintfmt+0x155>
  8003ad:	8b 14 85 e0 14 80 00 	mov    0x8014e0(,%eax,4),%edx
  8003b4:	85 d2                	test   %edx,%edx
  8003b6:	74 18                	je     8003d0 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8003b8:	52                   	push   %edx
  8003b9:	68 b0 11 80 00       	push   $0x8011b0
  8003be:	53                   	push   %ebx
  8003bf:	56                   	push   %esi
  8003c0:	e8 99 fe ff ff       	call   80025e <printfmt>
  8003c5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003cb:	e9 73 02 00 00       	jmp    800643 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8003d0:	50                   	push   %eax
  8003d1:	68 a7 11 80 00       	push   $0x8011a7
  8003d6:	53                   	push   %ebx
  8003d7:	56                   	push   %esi
  8003d8:	e8 81 fe ff ff       	call   80025e <printfmt>
  8003dd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e3:	e9 5b 02 00 00       	jmp    800643 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	83 c0 04             	add    $0x4,%eax
  8003ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003f6:	85 d2                	test   %edx,%edx
  8003f8:	b8 a0 11 80 00       	mov    $0x8011a0,%eax
  8003fd:	0f 45 c2             	cmovne %edx,%eax
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800403:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800407:	7e 06                	jle    80040f <vprintfmt+0x194>
  800409:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80040d:	75 0d                	jne    80041c <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80040f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800412:	89 c7                	mov    %eax,%edi
  800414:	03 45 e0             	add    -0x20(%ebp),%eax
  800417:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041a:	eb 53                	jmp    80046f <vprintfmt+0x1f4>
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 d8             	pushl  -0x28(%ebp)
  800422:	50                   	push   %eax
  800423:	e8 13 04 00 00       	call   80083b <strnlen>
  800428:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042b:	29 c1                	sub    %eax,%ecx
  80042d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800435:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80043c:	eb 0f                	jmp    80044d <vprintfmt+0x1d2>
					putch(padc, putdat);
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	53                   	push   %ebx
  800442:	ff 75 e0             	pushl  -0x20(%ebp)
  800445:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800447:	83 ef 01             	sub    $0x1,%edi
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	85 ff                	test   %edi,%edi
  80044f:	7f ed                	jg     80043e <vprintfmt+0x1c3>
  800451:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800454:	85 d2                	test   %edx,%edx
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
  80045b:	0f 49 c2             	cmovns %edx,%eax
  80045e:	29 c2                	sub    %eax,%edx
  800460:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800463:	eb aa                	jmp    80040f <vprintfmt+0x194>
					putch(ch, putdat);
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	53                   	push   %ebx
  800469:	52                   	push   %edx
  80046a:	ff d6                	call   *%esi
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800472:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800474:	83 c7 01             	add    $0x1,%edi
  800477:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80047b:	0f be d0             	movsbl %al,%edx
  80047e:	85 d2                	test   %edx,%edx
  800480:	74 4b                	je     8004cd <vprintfmt+0x252>
  800482:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800486:	78 06                	js     80048e <vprintfmt+0x213>
  800488:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048c:	78 1e                	js     8004ac <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80048e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800492:	74 d1                	je     800465 <vprintfmt+0x1ea>
  800494:	0f be c0             	movsbl %al,%eax
  800497:	83 e8 20             	sub    $0x20,%eax
  80049a:	83 f8 5e             	cmp    $0x5e,%eax
  80049d:	76 c6                	jbe    800465 <vprintfmt+0x1ea>
					putch('?', putdat);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	53                   	push   %ebx
  8004a3:	6a 3f                	push   $0x3f
  8004a5:	ff d6                	call   *%esi
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	eb c3                	jmp    80046f <vprintfmt+0x1f4>
  8004ac:	89 cf                	mov    %ecx,%edi
  8004ae:	eb 0e                	jmp    8004be <vprintfmt+0x243>
				putch(' ', putdat);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	53                   	push   %ebx
  8004b4:	6a 20                	push   $0x20
  8004b6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004b8:	83 ef 01             	sub    $0x1,%edi
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	85 ff                	test   %edi,%edi
  8004c0:	7f ee                	jg     8004b0 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004c8:	e9 76 01 00 00       	jmp    800643 <vprintfmt+0x3c8>
  8004cd:	89 cf                	mov    %ecx,%edi
  8004cf:	eb ed                	jmp    8004be <vprintfmt+0x243>
	if (lflag >= 2)
  8004d1:	83 f9 01             	cmp    $0x1,%ecx
  8004d4:	7f 1f                	jg     8004f5 <vprintfmt+0x27a>
	else if (lflag)
  8004d6:	85 c9                	test   %ecx,%ecx
  8004d8:	74 6a                	je     800544 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e2:	89 c1                	mov    %eax,%ecx
  8004e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	8d 40 04             	lea    0x4(%eax),%eax
  8004f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f3:	eb 17                	jmp    80050c <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8004f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f8:	8b 50 04             	mov    0x4(%eax),%edx
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800500:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800503:	8b 45 14             	mov    0x14(%ebp),%eax
  800506:	8d 40 08             	lea    0x8(%eax),%eax
  800509:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050c:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80050f:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800514:	85 d2                	test   %edx,%edx
  800516:	0f 89 f8 00 00 00    	jns    800614 <vprintfmt+0x399>
				putch('-', putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	53                   	push   %ebx
  800520:	6a 2d                	push   $0x2d
  800522:	ff d6                	call   *%esi
				num = -(long long) num;
  800524:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800527:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80052a:	f7 d8                	neg    %eax
  80052c:	83 d2 00             	adc    $0x0,%edx
  80052f:	f7 da                	neg    %edx
  800531:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800534:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800537:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80053a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80053f:	e9 e1 00 00 00       	jmp    800625 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054c:	99                   	cltd   
  80054d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8d 40 04             	lea    0x4(%eax),%eax
  800556:	89 45 14             	mov    %eax,0x14(%ebp)
  800559:	eb b1                	jmp    80050c <vprintfmt+0x291>
	if (lflag >= 2)
  80055b:	83 f9 01             	cmp    $0x1,%ecx
  80055e:	7f 27                	jg     800587 <vprintfmt+0x30c>
	else if (lflag)
  800560:	85 c9                	test   %ecx,%ecx
  800562:	74 41                	je     8005a5 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	ba 00 00 00 00       	mov    $0x0,%edx
  80056e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800571:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800582:	e9 8d 00 00 00       	jmp    800614 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 50 04             	mov    0x4(%eax),%edx
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800592:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 40 08             	lea    0x8(%eax),%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059e:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a3:	eb 6f                	jmp    800614 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005be:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005c3:	eb 4f                	jmp    800614 <vprintfmt+0x399>
	if (lflag >= 2)
  8005c5:	83 f9 01             	cmp    $0x1,%ecx
  8005c8:	7f 23                	jg     8005ed <vprintfmt+0x372>
	else if (lflag)
  8005ca:	85 c9                	test   %ecx,%ecx
  8005cc:	0f 84 98 00 00 00    	je     80066a <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	eb 17                	jmp    800604 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 50 04             	mov    0x4(%eax),%edx
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 40 08             	lea    0x8(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	53                   	push   %ebx
  800608:	6a 30                	push   $0x30
  80060a:	ff d6                	call   *%esi
			goto number;
  80060c:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80060f:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800614:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800618:	74 0b                	je     800625 <vprintfmt+0x3aa>
				putch('+', putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	6a 2b                	push   $0x2b
  800620:	ff d6                	call   *%esi
  800622:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80062c:	50                   	push   %eax
  80062d:	ff 75 e0             	pushl  -0x20(%ebp)
  800630:	57                   	push   %edi
  800631:	ff 75 dc             	pushl  -0x24(%ebp)
  800634:	ff 75 d8             	pushl  -0x28(%ebp)
  800637:	89 da                	mov    %ebx,%edx
  800639:	89 f0                	mov    %esi,%eax
  80063b:	e8 22 fb ff ff       	call   800162 <printnum>
			break;
  800640:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800643:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800646:	83 c7 01             	add    $0x1,%edi
  800649:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80064d:	83 f8 25             	cmp    $0x25,%eax
  800650:	0f 84 3c fc ff ff    	je     800292 <vprintfmt+0x17>
			if (ch == '\0')
  800656:	85 c0                	test   %eax,%eax
  800658:	0f 84 55 01 00 00    	je     8007b3 <vprintfmt+0x538>
			putch(ch, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	53                   	push   %ebx
  800662:	50                   	push   %eax
  800663:	ff d6                	call   *%esi
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	eb dc                	jmp    800646 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
  800683:	e9 7c ff ff ff       	jmp    800604 <vprintfmt+0x389>
			putch('0', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 30                	push   $0x30
  80068e:	ff d6                	call   *%esi
			putch('x', putdat);
  800690:	83 c4 08             	add    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	6a 78                	push   $0x78
  800696:	ff d6                	call   *%esi
			num = (unsigned long long)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006a8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8d 40 04             	lea    0x4(%eax),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b4:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8006b9:	e9 56 ff ff ff       	jmp    800614 <vprintfmt+0x399>
	if (lflag >= 2)
  8006be:	83 f9 01             	cmp    $0x1,%ecx
  8006c1:	7f 27                	jg     8006ea <vprintfmt+0x46f>
	else if (lflag)
  8006c3:	85 c9                	test   %ecx,%ecx
  8006c5:	74 44                	je     80070b <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 40 04             	lea    0x4(%eax),%eax
  8006dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e0:	bf 10 00 00 00       	mov    $0x10,%edi
  8006e5:	e9 2a ff ff ff       	jmp    800614 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 50 04             	mov    0x4(%eax),%edx
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8d 40 08             	lea    0x8(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800701:	bf 10 00 00 00       	mov    $0x10,%edi
  800706:	e9 09 ff ff ff       	jmp    800614 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	ba 00 00 00 00       	mov    $0x0,%edx
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 40 04             	lea    0x4(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800724:	bf 10 00 00 00       	mov    $0x10,%edi
  800729:	e9 e6 fe ff ff       	jmp    800614 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 78 04             	lea    0x4(%eax),%edi
  800734:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800736:	85 c0                	test   %eax,%eax
  800738:	74 2d                	je     800767 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80073a:	0f b6 13             	movzbl (%ebx),%edx
  80073d:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80073f:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800742:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800745:	0f 8e f8 fe ff ff    	jle    800643 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80074b:	68 00 13 80 00       	push   $0x801300
  800750:	68 b0 11 80 00       	push   $0x8011b0
  800755:	53                   	push   %ebx
  800756:	56                   	push   %esi
  800757:	e8 02 fb ff ff       	call   80025e <printfmt>
  80075c:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80075f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800762:	e9 dc fe ff ff       	jmp    800643 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800767:	68 c8 12 80 00       	push   $0x8012c8
  80076c:	68 b0 11 80 00       	push   $0x8011b0
  800771:	53                   	push   %ebx
  800772:	56                   	push   %esi
  800773:	e8 e6 fa ff ff       	call   80025e <printfmt>
  800778:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80077b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80077e:	e9 c0 fe ff ff       	jmp    800643 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 25                	push   $0x25
  800789:	ff d6                	call   *%esi
			break;
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	e9 b0 fe ff ff       	jmp    800643 <vprintfmt+0x3c8>
			putch('%', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	53                   	push   %ebx
  800797:	6a 25                	push   $0x25
  800799:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 f8                	mov    %edi,%eax
  8007a0:	eb 03                	jmp    8007a5 <vprintfmt+0x52a>
  8007a2:	83 e8 01             	sub    $0x1,%eax
  8007a5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a9:	75 f7                	jne    8007a2 <vprintfmt+0x527>
  8007ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ae:	e9 90 fe ff ff       	jmp    800643 <vprintfmt+0x3c8>
}
  8007b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b6:	5b                   	pop    %ebx
  8007b7:	5e                   	pop    %esi
  8007b8:	5f                   	pop    %edi
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	83 ec 18             	sub    $0x18,%esp
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ca:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007ce:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d8:	85 c0                	test   %eax,%eax
  8007da:	74 26                	je     800802 <vsnprintf+0x47>
  8007dc:	85 d2                	test   %edx,%edx
  8007de:	7e 22                	jle    800802 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e0:	ff 75 14             	pushl  0x14(%ebp)
  8007e3:	ff 75 10             	pushl  0x10(%ebp)
  8007e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e9:	50                   	push   %eax
  8007ea:	68 41 02 80 00       	push   $0x800241
  8007ef:	e8 87 fa ff ff       	call   80027b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
}
  800800:	c9                   	leave  
  800801:	c3                   	ret    
		return -E_INVAL;
  800802:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800807:	eb f7                	jmp    800800 <vsnprintf+0x45>

00800809 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80080f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800812:	50                   	push   %eax
  800813:	ff 75 10             	pushl  0x10(%ebp)
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	ff 75 08             	pushl  0x8(%ebp)
  80081c:	e8 9a ff ff ff       	call   8007bb <vsnprintf>
	va_end(ap);

	return rc;
}
  800821:	c9                   	leave  
  800822:	c3                   	ret    

00800823 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800829:	b8 00 00 00 00       	mov    $0x0,%eax
  80082e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800832:	74 05                	je     800839 <strlen+0x16>
		n++;
  800834:	83 c0 01             	add    $0x1,%eax
  800837:	eb f5                	jmp    80082e <strlen+0xb>
	return n;
}
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800841:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800844:	ba 00 00 00 00       	mov    $0x0,%edx
  800849:	39 c2                	cmp    %eax,%edx
  80084b:	74 0d                	je     80085a <strnlen+0x1f>
  80084d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800851:	74 05                	je     800858 <strnlen+0x1d>
		n++;
  800853:	83 c2 01             	add    $0x1,%edx
  800856:	eb f1                	jmp    800849 <strnlen+0xe>
  800858:	89 d0                	mov    %edx,%eax
	return n;
}
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	53                   	push   %ebx
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800866:	ba 00 00 00 00       	mov    $0x0,%edx
  80086b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80086f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800872:	83 c2 01             	add    $0x1,%edx
  800875:	84 c9                	test   %cl,%cl
  800877:	75 f2                	jne    80086b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800879:	5b                   	pop    %ebx
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	53                   	push   %ebx
  800880:	83 ec 10             	sub    $0x10,%esp
  800883:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800886:	53                   	push   %ebx
  800887:	e8 97 ff ff ff       	call   800823 <strlen>
  80088c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	01 d8                	add    %ebx,%eax
  800894:	50                   	push   %eax
  800895:	e8 c2 ff ff ff       	call   80085c <strcpy>
	return dst;
}
  80089a:	89 d8                	mov    %ebx,%eax
  80089c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089f:	c9                   	leave  
  8008a0:	c3                   	ret    

008008a1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	56                   	push   %esi
  8008a5:	53                   	push   %ebx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ac:	89 c6                	mov    %eax,%esi
  8008ae:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b1:	89 c2                	mov    %eax,%edx
  8008b3:	39 f2                	cmp    %esi,%edx
  8008b5:	74 11                	je     8008c8 <strncpy+0x27>
		*dst++ = *src;
  8008b7:	83 c2 01             	add    $0x1,%edx
  8008ba:	0f b6 19             	movzbl (%ecx),%ebx
  8008bd:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c0:	80 fb 01             	cmp    $0x1,%bl
  8008c3:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008c6:	eb eb                	jmp    8008b3 <strncpy+0x12>
	}
	return ret;
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	56                   	push   %esi
  8008d0:	53                   	push   %ebx
  8008d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d7:	8b 55 10             	mov    0x10(%ebp),%edx
  8008da:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008dc:	85 d2                	test   %edx,%edx
  8008de:	74 21                	je     800901 <strlcpy+0x35>
  8008e0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008e4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008e6:	39 c2                	cmp    %eax,%edx
  8008e8:	74 14                	je     8008fe <strlcpy+0x32>
  8008ea:	0f b6 19             	movzbl (%ecx),%ebx
  8008ed:	84 db                	test   %bl,%bl
  8008ef:	74 0b                	je     8008fc <strlcpy+0x30>
			*dst++ = *src++;
  8008f1:	83 c1 01             	add    $0x1,%ecx
  8008f4:	83 c2 01             	add    $0x1,%edx
  8008f7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008fa:	eb ea                	jmp    8008e6 <strlcpy+0x1a>
  8008fc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008fe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800901:	29 f0                	sub    %esi,%eax
}
  800903:	5b                   	pop    %ebx
  800904:	5e                   	pop    %esi
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800910:	0f b6 01             	movzbl (%ecx),%eax
  800913:	84 c0                	test   %al,%al
  800915:	74 0c                	je     800923 <strcmp+0x1c>
  800917:	3a 02                	cmp    (%edx),%al
  800919:	75 08                	jne    800923 <strcmp+0x1c>
		p++, q++;
  80091b:	83 c1 01             	add    $0x1,%ecx
  80091e:	83 c2 01             	add    $0x1,%edx
  800921:	eb ed                	jmp    800910 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800923:	0f b6 c0             	movzbl %al,%eax
  800926:	0f b6 12             	movzbl (%edx),%edx
  800929:	29 d0                	sub    %edx,%eax
}
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	89 c3                	mov    %eax,%ebx
  800939:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80093c:	eb 06                	jmp    800944 <strncmp+0x17>
		n--, p++, q++;
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800944:	39 d8                	cmp    %ebx,%eax
  800946:	74 16                	je     80095e <strncmp+0x31>
  800948:	0f b6 08             	movzbl (%eax),%ecx
  80094b:	84 c9                	test   %cl,%cl
  80094d:	74 04                	je     800953 <strncmp+0x26>
  80094f:	3a 0a                	cmp    (%edx),%cl
  800951:	74 eb                	je     80093e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800953:	0f b6 00             	movzbl (%eax),%eax
  800956:	0f b6 12             	movzbl (%edx),%edx
  800959:	29 d0                	sub    %edx,%eax
}
  80095b:	5b                   	pop    %ebx
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    
		return 0;
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	eb f6                	jmp    80095b <strncmp+0x2e>

00800965 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096f:	0f b6 10             	movzbl (%eax),%edx
  800972:	84 d2                	test   %dl,%dl
  800974:	74 09                	je     80097f <strchr+0x1a>
		if (*s == c)
  800976:	38 ca                	cmp    %cl,%dl
  800978:	74 0a                	je     800984 <strchr+0x1f>
	for (; *s; s++)
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	eb f0                	jmp    80096f <strchr+0xa>
			return (char *) s;
	return 0;
  80097f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800990:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800993:	38 ca                	cmp    %cl,%dl
  800995:	74 09                	je     8009a0 <strfind+0x1a>
  800997:	84 d2                	test   %dl,%dl
  800999:	74 05                	je     8009a0 <strfind+0x1a>
	for (; *s; s++)
  80099b:	83 c0 01             	add    $0x1,%eax
  80099e:	eb f0                	jmp    800990 <strfind+0xa>
			break;
	return (char *) s;
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	57                   	push   %edi
  8009a6:	56                   	push   %esi
  8009a7:	53                   	push   %ebx
  8009a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ae:	85 c9                	test   %ecx,%ecx
  8009b0:	74 31                	je     8009e3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b2:	89 f8                	mov    %edi,%eax
  8009b4:	09 c8                	or     %ecx,%eax
  8009b6:	a8 03                	test   $0x3,%al
  8009b8:	75 23                	jne    8009dd <memset+0x3b>
		c &= 0xFF;
  8009ba:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009be:	89 d3                	mov    %edx,%ebx
  8009c0:	c1 e3 08             	shl    $0x8,%ebx
  8009c3:	89 d0                	mov    %edx,%eax
  8009c5:	c1 e0 18             	shl    $0x18,%eax
  8009c8:	89 d6                	mov    %edx,%esi
  8009ca:	c1 e6 10             	shl    $0x10,%esi
  8009cd:	09 f0                	or     %esi,%eax
  8009cf:	09 c2                	or     %eax,%edx
  8009d1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009d3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d6:	89 d0                	mov    %edx,%eax
  8009d8:	fc                   	cld    
  8009d9:	f3 ab                	rep stos %eax,%es:(%edi)
  8009db:	eb 06                	jmp    8009e3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e0:	fc                   	cld    
  8009e1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e3:	89 f8                	mov    %edi,%eax
  8009e5:	5b                   	pop    %ebx
  8009e6:	5e                   	pop    %esi
  8009e7:	5f                   	pop    %edi
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	57                   	push   %edi
  8009ee:	56                   	push   %esi
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f8:	39 c6                	cmp    %eax,%esi
  8009fa:	73 32                	jae    800a2e <memmove+0x44>
  8009fc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ff:	39 c2                	cmp    %eax,%edx
  800a01:	76 2b                	jbe    800a2e <memmove+0x44>
		s += n;
		d += n;
  800a03:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a06:	89 fe                	mov    %edi,%esi
  800a08:	09 ce                	or     %ecx,%esi
  800a0a:	09 d6                	or     %edx,%esi
  800a0c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a12:	75 0e                	jne    800a22 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a14:	83 ef 04             	sub    $0x4,%edi
  800a17:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a1d:	fd                   	std    
  800a1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a20:	eb 09                	jmp    800a2b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a22:	83 ef 01             	sub    $0x1,%edi
  800a25:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a28:	fd                   	std    
  800a29:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a2b:	fc                   	cld    
  800a2c:	eb 1a                	jmp    800a48 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2e:	89 c2                	mov    %eax,%edx
  800a30:	09 ca                	or     %ecx,%edx
  800a32:	09 f2                	or     %esi,%edx
  800a34:	f6 c2 03             	test   $0x3,%dl
  800a37:	75 0a                	jne    800a43 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a39:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a3c:	89 c7                	mov    %eax,%edi
  800a3e:	fc                   	cld    
  800a3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a41:	eb 05                	jmp    800a48 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a43:	89 c7                	mov    %eax,%edi
  800a45:	fc                   	cld    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a48:	5e                   	pop    %esi
  800a49:	5f                   	pop    %edi
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a52:	ff 75 10             	pushl  0x10(%ebp)
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	ff 75 08             	pushl  0x8(%ebp)
  800a5b:	e8 8a ff ff ff       	call   8009ea <memmove>
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	56                   	push   %esi
  800a66:	53                   	push   %ebx
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6d:	89 c6                	mov    %eax,%esi
  800a6f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a72:	39 f0                	cmp    %esi,%eax
  800a74:	74 1c                	je     800a92 <memcmp+0x30>
		if (*s1 != *s2)
  800a76:	0f b6 08             	movzbl (%eax),%ecx
  800a79:	0f b6 1a             	movzbl (%edx),%ebx
  800a7c:	38 d9                	cmp    %bl,%cl
  800a7e:	75 08                	jne    800a88 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a80:	83 c0 01             	add    $0x1,%eax
  800a83:	83 c2 01             	add    $0x1,%edx
  800a86:	eb ea                	jmp    800a72 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a88:	0f b6 c1             	movzbl %cl,%eax
  800a8b:	0f b6 db             	movzbl %bl,%ebx
  800a8e:	29 d8                	sub    %ebx,%eax
  800a90:	eb 05                	jmp    800a97 <memcmp+0x35>
	}

	return 0;
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa4:	89 c2                	mov    %eax,%edx
  800aa6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa9:	39 d0                	cmp    %edx,%eax
  800aab:	73 09                	jae    800ab6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aad:	38 08                	cmp    %cl,(%eax)
  800aaf:	74 05                	je     800ab6 <memfind+0x1b>
	for (; s < ends; s++)
  800ab1:	83 c0 01             	add    $0x1,%eax
  800ab4:	eb f3                	jmp    800aa9 <memfind+0xe>
			break;
	return (void *) s;
}
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	57                   	push   %edi
  800abc:	56                   	push   %esi
  800abd:	53                   	push   %ebx
  800abe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac4:	eb 03                	jmp    800ac9 <strtol+0x11>
		s++;
  800ac6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ac9:	0f b6 01             	movzbl (%ecx),%eax
  800acc:	3c 20                	cmp    $0x20,%al
  800ace:	74 f6                	je     800ac6 <strtol+0xe>
  800ad0:	3c 09                	cmp    $0x9,%al
  800ad2:	74 f2                	je     800ac6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ad4:	3c 2b                	cmp    $0x2b,%al
  800ad6:	74 2a                	je     800b02 <strtol+0x4a>
	int neg = 0;
  800ad8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800add:	3c 2d                	cmp    $0x2d,%al
  800adf:	74 2b                	je     800b0c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae7:	75 0f                	jne    800af8 <strtol+0x40>
  800ae9:	80 39 30             	cmpb   $0x30,(%ecx)
  800aec:	74 28                	je     800b16 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aee:	85 db                	test   %ebx,%ebx
  800af0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af5:	0f 44 d8             	cmove  %eax,%ebx
  800af8:	b8 00 00 00 00       	mov    $0x0,%eax
  800afd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b00:	eb 50                	jmp    800b52 <strtol+0x9a>
		s++;
  800b02:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b05:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0a:	eb d5                	jmp    800ae1 <strtol+0x29>
		s++, neg = 1;
  800b0c:	83 c1 01             	add    $0x1,%ecx
  800b0f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b14:	eb cb                	jmp    800ae1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b16:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b1a:	74 0e                	je     800b2a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b1c:	85 db                	test   %ebx,%ebx
  800b1e:	75 d8                	jne    800af8 <strtol+0x40>
		s++, base = 8;
  800b20:	83 c1 01             	add    $0x1,%ecx
  800b23:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b28:	eb ce                	jmp    800af8 <strtol+0x40>
		s += 2, base = 16;
  800b2a:	83 c1 02             	add    $0x2,%ecx
  800b2d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b32:	eb c4                	jmp    800af8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b34:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b37:	89 f3                	mov    %esi,%ebx
  800b39:	80 fb 19             	cmp    $0x19,%bl
  800b3c:	77 29                	ja     800b67 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b3e:	0f be d2             	movsbl %dl,%edx
  800b41:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b44:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b47:	7d 30                	jge    800b79 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b49:	83 c1 01             	add    $0x1,%ecx
  800b4c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b50:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b52:	0f b6 11             	movzbl (%ecx),%edx
  800b55:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b58:	89 f3                	mov    %esi,%ebx
  800b5a:	80 fb 09             	cmp    $0x9,%bl
  800b5d:	77 d5                	ja     800b34 <strtol+0x7c>
			dig = *s - '0';
  800b5f:	0f be d2             	movsbl %dl,%edx
  800b62:	83 ea 30             	sub    $0x30,%edx
  800b65:	eb dd                	jmp    800b44 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b67:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b6a:	89 f3                	mov    %esi,%ebx
  800b6c:	80 fb 19             	cmp    $0x19,%bl
  800b6f:	77 08                	ja     800b79 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b71:	0f be d2             	movsbl %dl,%edx
  800b74:	83 ea 37             	sub    $0x37,%edx
  800b77:	eb cb                	jmp    800b44 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7d:	74 05                	je     800b84 <strtol+0xcc>
		*endptr = (char *) s;
  800b7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b82:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	f7 da                	neg    %edx
  800b88:	85 ff                	test   %edi,%edi
  800b8a:	0f 45 c2             	cmovne %edx,%eax
}
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	57                   	push   %edi
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba3:	89 c3                	mov    %eax,%ebx
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	89 c6                	mov    %eax,%esi
  800ba9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bab:	5b                   	pop    %ebx
  800bac:	5e                   	pop    %esi
  800bad:	5f                   	pop    %edi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbb:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc0:	89 d1                	mov    %edx,%ecx
  800bc2:	89 d3                	mov    %edx,%ebx
  800bc4:	89 d7                	mov    %edx,%edi
  800bc6:	89 d6                	mov    %edx,%esi
  800bc8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bca:	5b                   	pop    %ebx
  800bcb:	5e                   	pop    %esi
  800bcc:	5f                   	pop    %edi
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	57                   	push   %edi
  800bd3:	56                   	push   %esi
  800bd4:	53                   	push   %ebx
  800bd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800be0:	b8 03 00 00 00       	mov    $0x3,%eax
  800be5:	89 cb                	mov    %ecx,%ebx
  800be7:	89 cf                	mov    %ecx,%edi
  800be9:	89 ce                	mov    %ecx,%esi
  800beb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bed:	85 c0                	test   %eax,%eax
  800bef:	7f 08                	jg     800bf9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5f                   	pop    %edi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf9:	83 ec 0c             	sub    $0xc,%esp
  800bfc:	50                   	push   %eax
  800bfd:	6a 03                	push   $0x3
  800bff:	68 20 15 80 00       	push   $0x801520
  800c04:	6a 33                	push   $0x33
  800c06:	68 3d 15 80 00       	push   $0x80153d
  800c0b:	e8 b1 02 00 00       	call   800ec1 <_panic>

00800c10 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	57                   	push   %edi
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c16:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c20:	89 d1                	mov    %edx,%ecx
  800c22:	89 d3                	mov    %edx,%ebx
  800c24:	89 d7                	mov    %edx,%edi
  800c26:	89 d6                	mov    %edx,%esi
  800c28:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c2a:	5b                   	pop    %ebx
  800c2b:	5e                   	pop    %esi
  800c2c:	5f                   	pop    %edi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <sys_yield>:

void
sys_yield(void)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c35:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c3f:	89 d1                	mov    %edx,%ecx
  800c41:	89 d3                	mov    %edx,%ebx
  800c43:	89 d7                	mov    %edx,%edi
  800c45:	89 d6                	mov    %edx,%esi
  800c47:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c49:	5b                   	pop    %ebx
  800c4a:	5e                   	pop    %esi
  800c4b:	5f                   	pop    %edi
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c57:	be 00 00 00 00       	mov    $0x0,%esi
  800c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c62:	b8 04 00 00 00       	mov    $0x4,%eax
  800c67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6a:	89 f7                	mov    %esi,%edi
  800c6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6e:	85 c0                	test   %eax,%eax
  800c70:	7f 08                	jg     800c7a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7a:	83 ec 0c             	sub    $0xc,%esp
  800c7d:	50                   	push   %eax
  800c7e:	6a 04                	push   $0x4
  800c80:	68 20 15 80 00       	push   $0x801520
  800c85:	6a 33                	push   $0x33
  800c87:	68 3d 15 80 00       	push   $0x80153d
  800c8c:	e8 30 02 00 00       	call   800ec1 <_panic>

00800c91 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cab:	8b 75 18             	mov    0x18(%ebp),%esi
  800cae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb0:	85 c0                	test   %eax,%eax
  800cb2:	7f 08                	jg     800cbc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbc:	83 ec 0c             	sub    $0xc,%esp
  800cbf:	50                   	push   %eax
  800cc0:	6a 05                	push   $0x5
  800cc2:	68 20 15 80 00       	push   $0x801520
  800cc7:	6a 33                	push   $0x33
  800cc9:	68 3d 15 80 00       	push   $0x80153d
  800cce:	e8 ee 01 00 00       	call   800ec1 <_panic>

00800cd3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce7:	b8 06 00 00 00       	mov    $0x6,%eax
  800cec:	89 df                	mov    %ebx,%edi
  800cee:	89 de                	mov    %ebx,%esi
  800cf0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf2:	85 c0                	test   %eax,%eax
  800cf4:	7f 08                	jg     800cfe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfe:	83 ec 0c             	sub    $0xc,%esp
  800d01:	50                   	push   %eax
  800d02:	6a 06                	push   $0x6
  800d04:	68 20 15 80 00       	push   $0x801520
  800d09:	6a 33                	push   $0x33
  800d0b:	68 3d 15 80 00       	push   $0x80153d
  800d10:	e8 ac 01 00 00       	call   800ec1 <_panic>

00800d15 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2b:	89 cb                	mov    %ecx,%ebx
  800d2d:	89 cf                	mov    %ecx,%edi
  800d2f:	89 ce                	mov    %ecx,%esi
  800d31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7f 08                	jg     800d3f <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	50                   	push   %eax
  800d43:	6a 0b                	push   $0xb
  800d45:	68 20 15 80 00       	push   $0x801520
  800d4a:	6a 33                	push   $0x33
  800d4c:	68 3d 15 80 00       	push   $0x80153d
  800d51:	e8 6b 01 00 00       	call   800ec1 <_panic>

00800d56 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
  800d5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	b8 08 00 00 00       	mov    $0x8,%eax
  800d6f:	89 df                	mov    %ebx,%edi
  800d71:	89 de                	mov    %ebx,%esi
  800d73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7f 08                	jg     800d81 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 08                	push   $0x8
  800d87:	68 20 15 80 00       	push   $0x801520
  800d8c:	6a 33                	push   $0x33
  800d8e:	68 3d 15 80 00       	push   $0x80153d
  800d93:	e8 29 01 00 00       	call   800ec1 <_panic>

00800d98 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dac:	b8 09 00 00 00       	mov    $0x9,%eax
  800db1:	89 df                	mov    %ebx,%edi
  800db3:	89 de                	mov    %ebx,%esi
  800db5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 09                	push   $0x9
  800dc9:	68 20 15 80 00       	push   $0x801520
  800dce:	6a 33                	push   $0x33
  800dd0:	68 3d 15 80 00       	push   $0x80153d
  800dd5:	e8 e7 00 00 00       	call   800ec1 <_panic>

00800dda <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df3:	89 df                	mov    %ebx,%edi
  800df5:	89 de                	mov    %ebx,%esi
  800df7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	7f 08                	jg     800e05 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	50                   	push   %eax
  800e09:	6a 0a                	push   $0xa
  800e0b:	68 20 15 80 00       	push   $0x801520
  800e10:	6a 33                	push   $0x33
  800e12:	68 3d 15 80 00       	push   $0x80153d
  800e17:	e8 a5 00 00 00       	call   800ec1 <_panic>

00800e1c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	57                   	push   %edi
  800e20:	56                   	push   %esi
  800e21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e2d:	be 00 00 00 00       	mov    $0x0,%esi
  800e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e38:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
  800e45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e50:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e55:	89 cb                	mov    %ecx,%ebx
  800e57:	89 cf                	mov    %ecx,%edi
  800e59:	89 ce                	mov    %ecx,%esi
  800e5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	7f 08                	jg     800e69 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	50                   	push   %eax
  800e6d:	6a 0e                	push   $0xe
  800e6f:	68 20 15 80 00       	push   $0x801520
  800e74:	6a 33                	push   $0x33
  800e76:	68 3d 15 80 00       	push   $0x80153d
  800e7b:	e8 41 00 00 00       	call   800ec1 <_panic>

00800e80 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e91:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e96:	89 df                	mov    %ebx,%edi
  800e98:	89 de                	mov    %ebx,%esi
  800e9a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	b8 10 00 00 00       	mov    $0x10,%eax
  800eb4:	89 cb                	mov    %ecx,%ebx
  800eb6:	89 cf                	mov    %ecx,%edi
  800eb8:	89 ce                	mov    %ecx,%esi
  800eba:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    

00800ec1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800ec6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ec9:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ecf:	e8 3c fd ff ff       	call   800c10 <sys_getenvid>
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	ff 75 0c             	pushl  0xc(%ebp)
  800eda:	ff 75 08             	pushl  0x8(%ebp)
  800edd:	56                   	push   %esi
  800ede:	50                   	push   %eax
  800edf:	68 4c 15 80 00       	push   $0x80154c
  800ee4:	e8 65 f2 ff ff       	call   80014e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ee9:	83 c4 18             	add    $0x18,%esp
  800eec:	53                   	push   %ebx
  800eed:	ff 75 10             	pushl  0x10(%ebp)
  800ef0:	e8 08 f2 ff ff       	call   8000fd <vcprintf>
	cprintf("\n");
  800ef5:	c7 04 24 6c 11 80 00 	movl   $0x80116c,(%esp)
  800efc:	e8 4d f2 ff ff       	call   80014e <cprintf>
  800f01:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f04:	cc                   	int3   
  800f05:	eb fd                	jmp    800f04 <_panic+0x43>
  800f07:	66 90                	xchg   %ax,%ax
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
