
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 20 12 80 00       	push   $0x801220
  80004a:	e8 21 01 00 00       	call   800170 <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 de 0b 00 00       	call   800c32 <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 95 0b 00 00       	call   800bf1 <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 72 0e 00 00       	call   800ee3 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008b:	e8 a2 0b 00 00       	call   800c32 <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800098:	c1 e0 04             	shl    $0x4,%eax
  80009b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a0:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a5:	85 db                	test   %ebx,%ebx
  8000a7:	7e 07                	jle    8000b0 <libmain+0x30>
		binaryname = argv[0];
  8000a9:	8b 06                	mov    (%esi),%eax
  8000ab:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
  8000b5:	e8 a7 ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000ba:	e8 0a 00 00 00       	call   8000c9 <exit>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5d                   	pop    %ebp
  8000c8:	c3                   	ret    

008000c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c9:	55                   	push   %ebp
  8000ca:	89 e5                	mov    %esp,%ebp
  8000cc:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000cf:	6a 00                	push   $0x0
  8000d1:	e8 1b 0b 00 00       	call   800bf1 <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	53                   	push   %ebx
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000e5:	8b 13                	mov    (%ebx),%edx
  8000e7:	8d 42 01             	lea    0x1(%edx),%eax
  8000ea:	89 03                	mov    %eax,(%ebx)
  8000ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000f8:	74 09                	je     800103 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000fa:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800101:	c9                   	leave  
  800102:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 ff 00 00 00       	push   $0xff
  80010b:	8d 43 08             	lea    0x8(%ebx),%eax
  80010e:	50                   	push   %eax
  80010f:	e8 a0 0a 00 00       	call   800bb4 <sys_cputs>
		b->idx = 0;
  800114:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011a:	83 c4 10             	add    $0x10,%esp
  80011d:	eb db                	jmp    8000fa <putch+0x1f>

0080011f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800128:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80012f:	00 00 00 
	b.cnt = 0;
  800132:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800139:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800148:	50                   	push   %eax
  800149:	68 db 00 80 00       	push   $0x8000db
  80014e:	e8 4a 01 00 00       	call   80029d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800153:	83 c4 08             	add    $0x8,%esp
  800156:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80015c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800162:	50                   	push   %eax
  800163:	e8 4c 0a 00 00       	call   800bb4 <sys_cputs>

	return b.cnt;
}
  800168:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800176:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800179:	50                   	push   %eax
  80017a:	ff 75 08             	pushl  0x8(%ebp)
  80017d:	e8 9d ff ff ff       	call   80011f <vcprintf>
	va_end(ap);

	return cnt;
}
  800182:	c9                   	leave  
  800183:	c3                   	ret    

00800184 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	57                   	push   %edi
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
  80018a:	83 ec 1c             	sub    $0x1c,%esp
  80018d:	89 c6                	mov    %eax,%esi
  80018f:	89 d7                	mov    %edx,%edi
  800191:	8b 45 08             	mov    0x8(%ebp),%eax
  800194:	8b 55 0c             	mov    0xc(%ebp),%edx
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80019a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80019d:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001a3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001a7:	74 2c                	je     8001d5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001b6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001b9:	39 c2                	cmp    %eax,%edx
  8001bb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001be:	73 43                	jae    800203 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001c0:	83 eb 01             	sub    $0x1,%ebx
  8001c3:	85 db                	test   %ebx,%ebx
  8001c5:	7e 6c                	jle    800233 <printnum+0xaf>
			putch(padc, putdat);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	57                   	push   %edi
  8001cb:	ff 75 18             	pushl  0x18(%ebp)
  8001ce:	ff d6                	call   *%esi
  8001d0:	83 c4 10             	add    $0x10,%esp
  8001d3:	eb eb                	jmp    8001c0 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	6a 20                	push   $0x20
  8001da:	6a 00                	push   $0x0
  8001dc:	50                   	push   %eax
  8001dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e3:	89 fa                	mov    %edi,%edx
  8001e5:	89 f0                	mov    %esi,%eax
  8001e7:	e8 98 ff ff ff       	call   800184 <printnum>
		while (--width > 0)
  8001ec:	83 c4 20             	add    $0x20,%esp
  8001ef:	83 eb 01             	sub    $0x1,%ebx
  8001f2:	85 db                	test   %ebx,%ebx
  8001f4:	7e 65                	jle    80025b <printnum+0xd7>
			putch(padc, putdat);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	57                   	push   %edi
  8001fa:	6a 20                	push   $0x20
  8001fc:	ff d6                	call   *%esi
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	eb ec                	jmp    8001ef <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	ff 75 18             	pushl  0x18(%ebp)
  800209:	83 eb 01             	sub    $0x1,%ebx
  80020c:	53                   	push   %ebx
  80020d:	50                   	push   %eax
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	ff 75 dc             	pushl  -0x24(%ebp)
  800214:	ff 75 d8             	pushl  -0x28(%ebp)
  800217:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 9e 0d 00 00       	call   800fc0 <__udivdi3>
  800222:	83 c4 18             	add    $0x18,%esp
  800225:	52                   	push   %edx
  800226:	50                   	push   %eax
  800227:	89 fa                	mov    %edi,%edx
  800229:	89 f0                	mov    %esi,%eax
  80022b:	e8 54 ff ff ff       	call   800184 <printnum>
  800230:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	57                   	push   %edi
  800237:	83 ec 04             	sub    $0x4,%esp
  80023a:	ff 75 dc             	pushl  -0x24(%ebp)
  80023d:	ff 75 d8             	pushl  -0x28(%ebp)
  800240:	ff 75 e4             	pushl  -0x1c(%ebp)
  800243:	ff 75 e0             	pushl  -0x20(%ebp)
  800246:	e8 85 0e 00 00       	call   8010d0 <__umoddi3>
  80024b:	83 c4 14             	add    $0x14,%esp
  80024e:	0f be 80 46 12 80 00 	movsbl 0x801246(%eax),%eax
  800255:	50                   	push   %eax
  800256:	ff d6                	call   *%esi
  800258:	83 c4 10             	add    $0x10,%esp
}
  80025b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025e:	5b                   	pop    %ebx
  80025f:	5e                   	pop    %esi
  800260:	5f                   	pop    %edi
  800261:	5d                   	pop    %ebp
  800262:	c3                   	ret    

00800263 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800269:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80026d:	8b 10                	mov    (%eax),%edx
  80026f:	3b 50 04             	cmp    0x4(%eax),%edx
  800272:	73 0a                	jae    80027e <sprintputch+0x1b>
		*b->buf++ = ch;
  800274:	8d 4a 01             	lea    0x1(%edx),%ecx
  800277:	89 08                	mov    %ecx,(%eax)
  800279:	8b 45 08             	mov    0x8(%ebp),%eax
  80027c:	88 02                	mov    %al,(%edx)
}
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    

00800280 <printfmt>:
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800286:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800289:	50                   	push   %eax
  80028a:	ff 75 10             	pushl  0x10(%ebp)
  80028d:	ff 75 0c             	pushl  0xc(%ebp)
  800290:	ff 75 08             	pushl  0x8(%ebp)
  800293:	e8 05 00 00 00       	call   80029d <vprintfmt>
}
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <vprintfmt>:
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 3c             	sub    $0x3c,%esp
  8002a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002af:	e9 b4 03 00 00       	jmp    800668 <vprintfmt+0x3cb>
		padc = ' ';
  8002b4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8002b8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8002bf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002c6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002d9:	8d 47 01             	lea    0x1(%edi),%eax
  8002dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002df:	0f b6 17             	movzbl (%edi),%edx
  8002e2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e5:	3c 55                	cmp    $0x55,%al
  8002e7:	0f 87 c8 04 00 00    	ja     8007b5 <vprintfmt+0x518>
  8002ed:	0f b6 c0             	movzbl %al,%eax
  8002f0:	ff 24 85 20 14 80 00 	jmp    *0x801420(,%eax,4)
  8002f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8002fa:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800301:	eb d6                	jmp    8002d9 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800306:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80030a:	eb cd                	jmp    8002d9 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	0f b6 d2             	movzbl %dl,%edx
  80030f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800312:	b8 00 00 00 00       	mov    $0x0,%eax
  800317:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80031a:	eb 0c                	jmp    800328 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80031c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80031f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800323:	eb b4                	jmp    8002d9 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800325:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800328:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80032b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800332:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800335:	83 f9 09             	cmp    $0x9,%ecx
  800338:	76 eb                	jbe    800325 <vprintfmt+0x88>
  80033a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800340:	eb 14                	jmp    800356 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800342:	8b 45 14             	mov    0x14(%ebp),%eax
  800345:	8b 00                	mov    (%eax),%eax
  800347:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034a:	8b 45 14             	mov    0x14(%ebp),%eax
  80034d:	8d 40 04             	lea    0x4(%eax),%eax
  800350:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800353:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800356:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80035a:	0f 89 79 ff ff ff    	jns    8002d9 <vprintfmt+0x3c>
				width = precision, precision = -1;
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800366:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80036d:	e9 67 ff ff ff       	jmp    8002d9 <vprintfmt+0x3c>
  800372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	ba 00 00 00 00       	mov    $0x0,%edx
  80037c:	0f 49 d0             	cmovns %eax,%edx
  80037f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800385:	e9 4f ff ff ff       	jmp    8002d9 <vprintfmt+0x3c>
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80038d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800394:	e9 40 ff ff ff       	jmp    8002d9 <vprintfmt+0x3c>
			lflag++;
  800399:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039f:	e9 35 ff ff ff       	jmp    8002d9 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8003a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a7:	8d 78 04             	lea    0x4(%eax),%edi
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	53                   	push   %ebx
  8003ae:	ff 30                	pushl  (%eax)
  8003b0:	ff d6                	call   *%esi
			break;
  8003b2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b8:	e9 a8 02 00 00       	jmp    800665 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8003bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c0:	8d 78 04             	lea    0x4(%eax),%edi
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	99                   	cltd   
  8003c6:	31 d0                	xor    %edx,%eax
  8003c8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ca:	83 f8 0f             	cmp    $0xf,%eax
  8003cd:	7f 23                	jg     8003f2 <vprintfmt+0x155>
  8003cf:	8b 14 85 80 15 80 00 	mov    0x801580(,%eax,4),%edx
  8003d6:	85 d2                	test   %edx,%edx
  8003d8:	74 18                	je     8003f2 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8003da:	52                   	push   %edx
  8003db:	68 67 12 80 00       	push   $0x801267
  8003e0:	53                   	push   %ebx
  8003e1:	56                   	push   %esi
  8003e2:	e8 99 fe ff ff       	call   800280 <printfmt>
  8003e7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ea:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003ed:	e9 73 02 00 00       	jmp    800665 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8003f2:	50                   	push   %eax
  8003f3:	68 5e 12 80 00       	push   $0x80125e
  8003f8:	53                   	push   %ebx
  8003f9:	56                   	push   %esi
  8003fa:	e8 81 fe ff ff       	call   800280 <printfmt>
  8003ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800402:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800405:	e9 5b 02 00 00       	jmp    800665 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80040a:	8b 45 14             	mov    0x14(%ebp),%eax
  80040d:	83 c0 04             	add    $0x4,%eax
  800410:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800413:	8b 45 14             	mov    0x14(%ebp),%eax
  800416:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800418:	85 d2                	test   %edx,%edx
  80041a:	b8 57 12 80 00       	mov    $0x801257,%eax
  80041f:	0f 45 c2             	cmovne %edx,%eax
  800422:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800425:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800429:	7e 06                	jle    800431 <vprintfmt+0x194>
  80042b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80042f:	75 0d                	jne    80043e <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800431:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800434:	89 c7                	mov    %eax,%edi
  800436:	03 45 e0             	add    -0x20(%ebp),%eax
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043c:	eb 53                	jmp    800491 <vprintfmt+0x1f4>
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 d8             	pushl  -0x28(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 13 04 00 00       	call   80085d <strnlen>
  80044a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044d:	29 c1                	sub    %eax,%ecx
  80044f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800452:	83 c4 10             	add    $0x10,%esp
  800455:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800457:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80045b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	eb 0f                	jmp    80046f <vprintfmt+0x1d2>
					putch(padc, putdat);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	53                   	push   %ebx
  800464:	ff 75 e0             	pushl  -0x20(%ebp)
  800467:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800469:	83 ef 01             	sub    $0x1,%edi
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	85 ff                	test   %edi,%edi
  800471:	7f ed                	jg     800460 <vprintfmt+0x1c3>
  800473:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800476:	85 d2                	test   %edx,%edx
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
  80047d:	0f 49 c2             	cmovns %edx,%eax
  800480:	29 c2                	sub    %eax,%edx
  800482:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800485:	eb aa                	jmp    800431 <vprintfmt+0x194>
					putch(ch, putdat);
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	53                   	push   %ebx
  80048b:	52                   	push   %edx
  80048c:	ff d6                	call   *%esi
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800494:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800496:	83 c7 01             	add    $0x1,%edi
  800499:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80049d:	0f be d0             	movsbl %al,%edx
  8004a0:	85 d2                	test   %edx,%edx
  8004a2:	74 4b                	je     8004ef <vprintfmt+0x252>
  8004a4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a8:	78 06                	js     8004b0 <vprintfmt+0x213>
  8004aa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ae:	78 1e                	js     8004ce <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b4:	74 d1                	je     800487 <vprintfmt+0x1ea>
  8004b6:	0f be c0             	movsbl %al,%eax
  8004b9:	83 e8 20             	sub    $0x20,%eax
  8004bc:	83 f8 5e             	cmp    $0x5e,%eax
  8004bf:	76 c6                	jbe    800487 <vprintfmt+0x1ea>
					putch('?', putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	6a 3f                	push   $0x3f
  8004c7:	ff d6                	call   *%esi
  8004c9:	83 c4 10             	add    $0x10,%esp
  8004cc:	eb c3                	jmp    800491 <vprintfmt+0x1f4>
  8004ce:	89 cf                	mov    %ecx,%edi
  8004d0:	eb 0e                	jmp    8004e0 <vprintfmt+0x243>
				putch(' ', putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	53                   	push   %ebx
  8004d6:	6a 20                	push   $0x20
  8004d8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004da:	83 ef 01             	sub    $0x1,%edi
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	85 ff                	test   %edi,%edi
  8004e2:	7f ee                	jg     8004d2 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ea:	e9 76 01 00 00       	jmp    800665 <vprintfmt+0x3c8>
  8004ef:	89 cf                	mov    %ecx,%edi
  8004f1:	eb ed                	jmp    8004e0 <vprintfmt+0x243>
	if (lflag >= 2)
  8004f3:	83 f9 01             	cmp    $0x1,%ecx
  8004f6:	7f 1f                	jg     800517 <vprintfmt+0x27a>
	else if (lflag)
  8004f8:	85 c9                	test   %ecx,%ecx
  8004fa:	74 6a                	je     800566 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800504:	89 c1                	mov    %eax,%ecx
  800506:	c1 f9 1f             	sar    $0x1f,%ecx
  800509:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80050c:	8b 45 14             	mov    0x14(%ebp),%eax
  80050f:	8d 40 04             	lea    0x4(%eax),%eax
  800512:	89 45 14             	mov    %eax,0x14(%ebp)
  800515:	eb 17                	jmp    80052e <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8b 50 04             	mov    0x4(%eax),%edx
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800522:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 40 08             	lea    0x8(%eax),%eax
  80052b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80052e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800531:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800536:	85 d2                	test   %edx,%edx
  800538:	0f 89 f8 00 00 00    	jns    800636 <vprintfmt+0x399>
				putch('-', putdat);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	53                   	push   %ebx
  800542:	6a 2d                	push   $0x2d
  800544:	ff d6                	call   *%esi
				num = -(long long) num;
  800546:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800549:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80054c:	f7 d8                	neg    %eax
  80054e:	83 d2 00             	adc    $0x0,%edx
  800551:	f7 da                	neg    %edx
  800553:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800556:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800559:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80055c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800561:	e9 e1 00 00 00       	jmp    800647 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056e:	99                   	cltd   
  80056f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8d 40 04             	lea    0x4(%eax),%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
  80057b:	eb b1                	jmp    80052e <vprintfmt+0x291>
	if (lflag >= 2)
  80057d:	83 f9 01             	cmp    $0x1,%ecx
  800580:	7f 27                	jg     8005a9 <vprintfmt+0x30c>
	else if (lflag)
  800582:	85 c9                	test   %ecx,%ecx
  800584:	74 41                	je     8005c7 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	ba 00 00 00 00       	mov    $0x0,%edx
  800590:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800593:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 40 04             	lea    0x4(%eax),%eax
  80059c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059f:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a4:	e9 8d 00 00 00       	jmp    800636 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 50 04             	mov    0x4(%eax),%edx
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 40 08             	lea    0x8(%eax),%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005c5:	eb 6f                	jmp    800636 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 40 04             	lea    0x4(%eax),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005e5:	eb 4f                	jmp    800636 <vprintfmt+0x399>
	if (lflag >= 2)
  8005e7:	83 f9 01             	cmp    $0x1,%ecx
  8005ea:	7f 23                	jg     80060f <vprintfmt+0x372>
	else if (lflag)
  8005ec:	85 c9                	test   %ecx,%ecx
  8005ee:	0f 84 98 00 00 00    	je     80068c <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
  80060d:	eb 17                	jmp    800626 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8b 50 04             	mov    0x4(%eax),%edx
  800615:	8b 00                	mov    (%eax),%eax
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 40 08             	lea    0x8(%eax),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	53                   	push   %ebx
  80062a:	6a 30                	push   $0x30
  80062c:	ff d6                	call   *%esi
			goto number;
  80062e:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800631:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800636:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80063a:	74 0b                	je     800647 <vprintfmt+0x3aa>
				putch('+', putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	6a 2b                	push   $0x2b
  800642:	ff d6                	call   *%esi
  800644:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80064e:	50                   	push   %eax
  80064f:	ff 75 e0             	pushl  -0x20(%ebp)
  800652:	57                   	push   %edi
  800653:	ff 75 dc             	pushl  -0x24(%ebp)
  800656:	ff 75 d8             	pushl  -0x28(%ebp)
  800659:	89 da                	mov    %ebx,%edx
  80065b:	89 f0                	mov    %esi,%eax
  80065d:	e8 22 fb ff ff       	call   800184 <printnum>
			break;
  800662:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800665:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800668:	83 c7 01             	add    $0x1,%edi
  80066b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80066f:	83 f8 25             	cmp    $0x25,%eax
  800672:	0f 84 3c fc ff ff    	je     8002b4 <vprintfmt+0x17>
			if (ch == '\0')
  800678:	85 c0                	test   %eax,%eax
  80067a:	0f 84 55 01 00 00    	je     8007d5 <vprintfmt+0x538>
			putch(ch, putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	50                   	push   %eax
  800685:	ff d6                	call   *%esi
  800687:	83 c4 10             	add    $0x10,%esp
  80068a:	eb dc                	jmp    800668 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800699:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	e9 7c ff ff ff       	jmp    800626 <vprintfmt+0x389>
			putch('0', putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	53                   	push   %ebx
  8006ae:	6a 30                	push   $0x30
  8006b0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b2:	83 c4 08             	add    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 78                	push   $0x78
  8006b8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006ca:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 40 04             	lea    0x4(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d6:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8006db:	e9 56 ff ff ff       	jmp    800636 <vprintfmt+0x399>
	if (lflag >= 2)
  8006e0:	83 f9 01             	cmp    $0x1,%ecx
  8006e3:	7f 27                	jg     80070c <vprintfmt+0x46f>
	else if (lflag)
  8006e5:	85 c9                	test   %ecx,%ecx
  8006e7:	74 44                	je     80072d <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8d 40 04             	lea    0x4(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800702:	bf 10 00 00 00       	mov    $0x10,%edi
  800707:	e9 2a ff ff ff       	jmp    800636 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8b 50 04             	mov    0x4(%eax),%edx
  800712:	8b 00                	mov    (%eax),%eax
  800714:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800717:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8d 40 08             	lea    0x8(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800723:	bf 10 00 00 00       	mov    $0x10,%edi
  800728:	e9 09 ff ff ff       	jmp    800636 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	ba 00 00 00 00       	mov    $0x0,%edx
  800737:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800746:	bf 10 00 00 00       	mov    $0x10,%edi
  80074b:	e9 e6 fe ff ff       	jmp    800636 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8d 78 04             	lea    0x4(%eax),%edi
  800756:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800758:	85 c0                	test   %eax,%eax
  80075a:	74 2d                	je     800789 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80075c:	0f b6 13             	movzbl (%ebx),%edx
  80075f:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800761:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800764:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800767:	0f 8e f8 fe ff ff    	jle    800665 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80076d:	68 b4 13 80 00       	push   $0x8013b4
  800772:	68 67 12 80 00       	push   $0x801267
  800777:	53                   	push   %ebx
  800778:	56                   	push   %esi
  800779:	e8 02 fb ff ff       	call   800280 <printfmt>
  80077e:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800781:	89 7d 14             	mov    %edi,0x14(%ebp)
  800784:	e9 dc fe ff ff       	jmp    800665 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800789:	68 7c 13 80 00       	push   $0x80137c
  80078e:	68 67 12 80 00       	push   $0x801267
  800793:	53                   	push   %ebx
  800794:	56                   	push   %esi
  800795:	e8 e6 fa ff ff       	call   800280 <printfmt>
  80079a:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80079d:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007a0:	e9 c0 fe ff ff       	jmp    800665 <vprintfmt+0x3c8>
			putch(ch, putdat);
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	53                   	push   %ebx
  8007a9:	6a 25                	push   $0x25
  8007ab:	ff d6                	call   *%esi
			break;
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	e9 b0 fe ff ff       	jmp    800665 <vprintfmt+0x3c8>
			putch('%', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	6a 25                	push   $0x25
  8007bb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	89 f8                	mov    %edi,%eax
  8007c2:	eb 03                	jmp    8007c7 <vprintfmt+0x52a>
  8007c4:	83 e8 01             	sub    $0x1,%eax
  8007c7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007cb:	75 f7                	jne    8007c4 <vprintfmt+0x527>
  8007cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d0:	e9 90 fe ff ff       	jmp    800665 <vprintfmt+0x3c8>
}
  8007d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d8:	5b                   	pop    %ebx
  8007d9:	5e                   	pop    %esi
  8007da:	5f                   	pop    %edi
  8007db:	5d                   	pop    %ebp
  8007dc:	c3                   	ret    

008007dd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 18             	sub    $0x18,%esp
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ec:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007fa:	85 c0                	test   %eax,%eax
  8007fc:	74 26                	je     800824 <vsnprintf+0x47>
  8007fe:	85 d2                	test   %edx,%edx
  800800:	7e 22                	jle    800824 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800802:	ff 75 14             	pushl  0x14(%ebp)
  800805:	ff 75 10             	pushl  0x10(%ebp)
  800808:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80080b:	50                   	push   %eax
  80080c:	68 63 02 80 00       	push   $0x800263
  800811:	e8 87 fa ff ff       	call   80029d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800819:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80081f:	83 c4 10             	add    $0x10,%esp
}
  800822:	c9                   	leave  
  800823:	c3                   	ret    
		return -E_INVAL;
  800824:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800829:	eb f7                	jmp    800822 <vsnprintf+0x45>

0080082b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800831:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800834:	50                   	push   %eax
  800835:	ff 75 10             	pushl  0x10(%ebp)
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	ff 75 08             	pushl  0x8(%ebp)
  80083e:	e8 9a ff ff ff       	call   8007dd <vsnprintf>
	va_end(ap);

	return rc;
}
  800843:	c9                   	leave  
  800844:	c3                   	ret    

00800845 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800854:	74 05                	je     80085b <strlen+0x16>
		n++;
  800856:	83 c0 01             	add    $0x1,%eax
  800859:	eb f5                	jmp    800850 <strlen+0xb>
	return n;
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800863:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800866:	ba 00 00 00 00       	mov    $0x0,%edx
  80086b:	39 c2                	cmp    %eax,%edx
  80086d:	74 0d                	je     80087c <strnlen+0x1f>
  80086f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800873:	74 05                	je     80087a <strnlen+0x1d>
		n++;
  800875:	83 c2 01             	add    $0x1,%edx
  800878:	eb f1                	jmp    80086b <strnlen+0xe>
  80087a:	89 d0                	mov    %edx,%eax
	return n;
}
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	53                   	push   %ebx
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800888:	ba 00 00 00 00       	mov    $0x0,%edx
  80088d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800891:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800894:	83 c2 01             	add    $0x1,%edx
  800897:	84 c9                	test   %cl,%cl
  800899:	75 f2                	jne    80088d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80089b:	5b                   	pop    %ebx
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	53                   	push   %ebx
  8008a2:	83 ec 10             	sub    $0x10,%esp
  8008a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a8:	53                   	push   %ebx
  8008a9:	e8 97 ff ff ff       	call   800845 <strlen>
  8008ae:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	50                   	push   %eax
  8008b7:	e8 c2 ff ff ff       	call   80087e <strcpy>
	return dst;
}
  8008bc:	89 d8                	mov    %ebx,%eax
  8008be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	56                   	push   %esi
  8008c7:	53                   	push   %ebx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ce:	89 c6                	mov    %eax,%esi
  8008d0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d3:	89 c2                	mov    %eax,%edx
  8008d5:	39 f2                	cmp    %esi,%edx
  8008d7:	74 11                	je     8008ea <strncpy+0x27>
		*dst++ = *src;
  8008d9:	83 c2 01             	add    $0x1,%edx
  8008dc:	0f b6 19             	movzbl (%ecx),%ebx
  8008df:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e2:	80 fb 01             	cmp    $0x1,%bl
  8008e5:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008e8:	eb eb                	jmp    8008d5 <strncpy+0x12>
	}
	return ret;
}
  8008ea:	5b                   	pop    %ebx
  8008eb:	5e                   	pop    %esi
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	56                   	push   %esi
  8008f2:	53                   	push   %ebx
  8008f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f9:	8b 55 10             	mov    0x10(%ebp),%edx
  8008fc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008fe:	85 d2                	test   %edx,%edx
  800900:	74 21                	je     800923 <strlcpy+0x35>
  800902:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800906:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800908:	39 c2                	cmp    %eax,%edx
  80090a:	74 14                	je     800920 <strlcpy+0x32>
  80090c:	0f b6 19             	movzbl (%ecx),%ebx
  80090f:	84 db                	test   %bl,%bl
  800911:	74 0b                	je     80091e <strlcpy+0x30>
			*dst++ = *src++;
  800913:	83 c1 01             	add    $0x1,%ecx
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	88 5a ff             	mov    %bl,-0x1(%edx)
  80091c:	eb ea                	jmp    800908 <strlcpy+0x1a>
  80091e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800920:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800923:	29 f0                	sub    %esi,%eax
}
  800925:	5b                   	pop    %ebx
  800926:	5e                   	pop    %esi
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800932:	0f b6 01             	movzbl (%ecx),%eax
  800935:	84 c0                	test   %al,%al
  800937:	74 0c                	je     800945 <strcmp+0x1c>
  800939:	3a 02                	cmp    (%edx),%al
  80093b:	75 08                	jne    800945 <strcmp+0x1c>
		p++, q++;
  80093d:	83 c1 01             	add    $0x1,%ecx
  800940:	83 c2 01             	add    $0x1,%edx
  800943:	eb ed                	jmp    800932 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800945:	0f b6 c0             	movzbl %al,%eax
  800948:	0f b6 12             	movzbl (%edx),%edx
  80094b:	29 d0                	sub    %edx,%eax
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	53                   	push   %ebx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 55 0c             	mov    0xc(%ebp),%edx
  800959:	89 c3                	mov    %eax,%ebx
  80095b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80095e:	eb 06                	jmp    800966 <strncmp+0x17>
		n--, p++, q++;
  800960:	83 c0 01             	add    $0x1,%eax
  800963:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800966:	39 d8                	cmp    %ebx,%eax
  800968:	74 16                	je     800980 <strncmp+0x31>
  80096a:	0f b6 08             	movzbl (%eax),%ecx
  80096d:	84 c9                	test   %cl,%cl
  80096f:	74 04                	je     800975 <strncmp+0x26>
  800971:	3a 0a                	cmp    (%edx),%cl
  800973:	74 eb                	je     800960 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800975:	0f b6 00             	movzbl (%eax),%eax
  800978:	0f b6 12             	movzbl (%edx),%edx
  80097b:	29 d0                	sub    %edx,%eax
}
  80097d:	5b                   	pop    %ebx
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    
		return 0;
  800980:	b8 00 00 00 00       	mov    $0x0,%eax
  800985:	eb f6                	jmp    80097d <strncmp+0x2e>

00800987 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800991:	0f b6 10             	movzbl (%eax),%edx
  800994:	84 d2                	test   %dl,%dl
  800996:	74 09                	je     8009a1 <strchr+0x1a>
		if (*s == c)
  800998:	38 ca                	cmp    %cl,%dl
  80099a:	74 0a                	je     8009a6 <strchr+0x1f>
	for (; *s; s++)
  80099c:	83 c0 01             	add    $0x1,%eax
  80099f:	eb f0                	jmp    800991 <strchr+0xa>
			return (char *) s;
	return 0;
  8009a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b5:	38 ca                	cmp    %cl,%dl
  8009b7:	74 09                	je     8009c2 <strfind+0x1a>
  8009b9:	84 d2                	test   %dl,%dl
  8009bb:	74 05                	je     8009c2 <strfind+0x1a>
	for (; *s; s++)
  8009bd:	83 c0 01             	add    $0x1,%eax
  8009c0:	eb f0                	jmp    8009b2 <strfind+0xa>
			break;
	return (char *) s;
}
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	57                   	push   %edi
  8009c8:	56                   	push   %esi
  8009c9:	53                   	push   %ebx
  8009ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d0:	85 c9                	test   %ecx,%ecx
  8009d2:	74 31                	je     800a05 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d4:	89 f8                	mov    %edi,%eax
  8009d6:	09 c8                	or     %ecx,%eax
  8009d8:	a8 03                	test   $0x3,%al
  8009da:	75 23                	jne    8009ff <memset+0x3b>
		c &= 0xFF;
  8009dc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e0:	89 d3                	mov    %edx,%ebx
  8009e2:	c1 e3 08             	shl    $0x8,%ebx
  8009e5:	89 d0                	mov    %edx,%eax
  8009e7:	c1 e0 18             	shl    $0x18,%eax
  8009ea:	89 d6                	mov    %edx,%esi
  8009ec:	c1 e6 10             	shl    $0x10,%esi
  8009ef:	09 f0                	or     %esi,%eax
  8009f1:	09 c2                	or     %eax,%edx
  8009f3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	fc                   	cld    
  8009fb:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fd:	eb 06                	jmp    800a05 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	fc                   	cld    
  800a03:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a05:	89 f8                	mov    %edi,%eax
  800a07:	5b                   	pop    %ebx
  800a08:	5e                   	pop    %esi
  800a09:	5f                   	pop    %edi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	57                   	push   %edi
  800a10:	56                   	push   %esi
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a17:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1a:	39 c6                	cmp    %eax,%esi
  800a1c:	73 32                	jae    800a50 <memmove+0x44>
  800a1e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a21:	39 c2                	cmp    %eax,%edx
  800a23:	76 2b                	jbe    800a50 <memmove+0x44>
		s += n;
		d += n;
  800a25:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a28:	89 fe                	mov    %edi,%esi
  800a2a:	09 ce                	or     %ecx,%esi
  800a2c:	09 d6                	or     %edx,%esi
  800a2e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a34:	75 0e                	jne    800a44 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a36:	83 ef 04             	sub    $0x4,%edi
  800a39:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a3c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a3f:	fd                   	std    
  800a40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a42:	eb 09                	jmp    800a4d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a44:	83 ef 01             	sub    $0x1,%edi
  800a47:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4a:	fd                   	std    
  800a4b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a4d:	fc                   	cld    
  800a4e:	eb 1a                	jmp    800a6a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a50:	89 c2                	mov    %eax,%edx
  800a52:	09 ca                	or     %ecx,%edx
  800a54:	09 f2                	or     %esi,%edx
  800a56:	f6 c2 03             	test   $0x3,%dl
  800a59:	75 0a                	jne    800a65 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a5b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a5e:	89 c7                	mov    %eax,%edi
  800a60:	fc                   	cld    
  800a61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a63:	eb 05                	jmp    800a6a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a65:	89 c7                	mov    %eax,%edi
  800a67:	fc                   	cld    
  800a68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6a:	5e                   	pop    %esi
  800a6b:	5f                   	pop    %edi
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a74:	ff 75 10             	pushl  0x10(%ebp)
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 8a ff ff ff       	call   800a0c <memmove>
}
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8f:	89 c6                	mov    %eax,%esi
  800a91:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a94:	39 f0                	cmp    %esi,%eax
  800a96:	74 1c                	je     800ab4 <memcmp+0x30>
		if (*s1 != *s2)
  800a98:	0f b6 08             	movzbl (%eax),%ecx
  800a9b:	0f b6 1a             	movzbl (%edx),%ebx
  800a9e:	38 d9                	cmp    %bl,%cl
  800aa0:	75 08                	jne    800aaa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa2:	83 c0 01             	add    $0x1,%eax
  800aa5:	83 c2 01             	add    $0x1,%edx
  800aa8:	eb ea                	jmp    800a94 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aaa:	0f b6 c1             	movzbl %cl,%eax
  800aad:	0f b6 db             	movzbl %bl,%ebx
  800ab0:	29 d8                	sub    %ebx,%eax
  800ab2:	eb 05                	jmp    800ab9 <memcmp+0x35>
	}

	return 0;
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab9:	5b                   	pop    %ebx
  800aba:	5e                   	pop    %esi
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac6:	89 c2                	mov    %eax,%edx
  800ac8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800acb:	39 d0                	cmp    %edx,%eax
  800acd:	73 09                	jae    800ad8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800acf:	38 08                	cmp    %cl,(%eax)
  800ad1:	74 05                	je     800ad8 <memfind+0x1b>
	for (; s < ends; s++)
  800ad3:	83 c0 01             	add    $0x1,%eax
  800ad6:	eb f3                	jmp    800acb <memfind+0xe>
			break;
	return (void *) s;
}
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	57                   	push   %edi
  800ade:	56                   	push   %esi
  800adf:	53                   	push   %ebx
  800ae0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae6:	eb 03                	jmp    800aeb <strtol+0x11>
		s++;
  800ae8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aeb:	0f b6 01             	movzbl (%ecx),%eax
  800aee:	3c 20                	cmp    $0x20,%al
  800af0:	74 f6                	je     800ae8 <strtol+0xe>
  800af2:	3c 09                	cmp    $0x9,%al
  800af4:	74 f2                	je     800ae8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800af6:	3c 2b                	cmp    $0x2b,%al
  800af8:	74 2a                	je     800b24 <strtol+0x4a>
	int neg = 0;
  800afa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aff:	3c 2d                	cmp    $0x2d,%al
  800b01:	74 2b                	je     800b2e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b03:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b09:	75 0f                	jne    800b1a <strtol+0x40>
  800b0b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b0e:	74 28                	je     800b38 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b10:	85 db                	test   %ebx,%ebx
  800b12:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b17:	0f 44 d8             	cmove  %eax,%ebx
  800b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b22:	eb 50                	jmp    800b74 <strtol+0x9a>
		s++;
  800b24:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b27:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2c:	eb d5                	jmp    800b03 <strtol+0x29>
		s++, neg = 1;
  800b2e:	83 c1 01             	add    $0x1,%ecx
  800b31:	bf 01 00 00 00       	mov    $0x1,%edi
  800b36:	eb cb                	jmp    800b03 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b38:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b3c:	74 0e                	je     800b4c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b3e:	85 db                	test   %ebx,%ebx
  800b40:	75 d8                	jne    800b1a <strtol+0x40>
		s++, base = 8;
  800b42:	83 c1 01             	add    $0x1,%ecx
  800b45:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b4a:	eb ce                	jmp    800b1a <strtol+0x40>
		s += 2, base = 16;
  800b4c:	83 c1 02             	add    $0x2,%ecx
  800b4f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b54:	eb c4                	jmp    800b1a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b56:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b59:	89 f3                	mov    %esi,%ebx
  800b5b:	80 fb 19             	cmp    $0x19,%bl
  800b5e:	77 29                	ja     800b89 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b60:	0f be d2             	movsbl %dl,%edx
  800b63:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b66:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b69:	7d 30                	jge    800b9b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b6b:	83 c1 01             	add    $0x1,%ecx
  800b6e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b72:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b74:	0f b6 11             	movzbl (%ecx),%edx
  800b77:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b7a:	89 f3                	mov    %esi,%ebx
  800b7c:	80 fb 09             	cmp    $0x9,%bl
  800b7f:	77 d5                	ja     800b56 <strtol+0x7c>
			dig = *s - '0';
  800b81:	0f be d2             	movsbl %dl,%edx
  800b84:	83 ea 30             	sub    $0x30,%edx
  800b87:	eb dd                	jmp    800b66 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b89:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b8c:	89 f3                	mov    %esi,%ebx
  800b8e:	80 fb 19             	cmp    $0x19,%bl
  800b91:	77 08                	ja     800b9b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b93:	0f be d2             	movsbl %dl,%edx
  800b96:	83 ea 37             	sub    $0x37,%edx
  800b99:	eb cb                	jmp    800b66 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9f:	74 05                	je     800ba6 <strtol+0xcc>
		*endptr = (char *) s;
  800ba1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ba6:	89 c2                	mov    %eax,%edx
  800ba8:	f7 da                	neg    %edx
  800baa:	85 ff                	test   %edi,%edi
  800bac:	0f 45 c2             	cmovne %edx,%eax
}
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bba:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc5:	89 c3                	mov    %eax,%ebx
  800bc7:	89 c7                	mov    %eax,%edi
  800bc9:	89 c6                	mov    %eax,%esi
  800bcb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5f                   	pop    %edi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	57                   	push   %edi
  800bd6:	56                   	push   %esi
  800bd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  800be2:	89 d1                	mov    %edx,%ecx
  800be4:	89 d3                	mov    %edx,%ebx
  800be6:	89 d7                	mov    %edx,%edi
  800be8:	89 d6                	mov    %edx,%esi
  800bea:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5f                   	pop    %edi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
  800bf7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bff:	8b 55 08             	mov    0x8(%ebp),%edx
  800c02:	b8 03 00 00 00       	mov    $0x3,%eax
  800c07:	89 cb                	mov    %ecx,%ebx
  800c09:	89 cf                	mov    %ecx,%edi
  800c0b:	89 ce                	mov    %ecx,%esi
  800c0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0f:	85 c0                	test   %eax,%eax
  800c11:	7f 08                	jg     800c1b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c16:	5b                   	pop    %ebx
  800c17:	5e                   	pop    %esi
  800c18:	5f                   	pop    %edi
  800c19:	5d                   	pop    %ebp
  800c1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1b:	83 ec 0c             	sub    $0xc,%esp
  800c1e:	50                   	push   %eax
  800c1f:	6a 03                	push   $0x3
  800c21:	68 c0 15 80 00       	push   $0x8015c0
  800c26:	6a 33                	push   $0x33
  800c28:	68 dd 15 80 00       	push   $0x8015dd
  800c2d:	e8 42 03 00 00       	call   800f74 <_panic>

00800c32 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c38:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3d:	b8 02 00 00 00       	mov    $0x2,%eax
  800c42:	89 d1                	mov    %edx,%ecx
  800c44:	89 d3                	mov    %edx,%ebx
  800c46:	89 d7                	mov    %edx,%edi
  800c48:	89 d6                	mov    %edx,%esi
  800c4a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4c:	5b                   	pop    %ebx
  800c4d:	5e                   	pop    %esi
  800c4e:	5f                   	pop    %edi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <sys_yield>:

void
sys_yield(void)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	57                   	push   %edi
  800c55:	56                   	push   %esi
  800c56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c57:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c61:	89 d1                	mov    %edx,%ecx
  800c63:	89 d3                	mov    %edx,%ebx
  800c65:	89 d7                	mov    %edx,%edi
  800c67:	89 d6                	mov    %edx,%esi
  800c69:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
  800c76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c79:	be 00 00 00 00       	mov    $0x0,%esi
  800c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c84:	b8 04 00 00 00       	mov    $0x4,%eax
  800c89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8c:	89 f7                	mov    %esi,%edi
  800c8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c90:	85 c0                	test   %eax,%eax
  800c92:	7f 08                	jg     800c9c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	50                   	push   %eax
  800ca0:	6a 04                	push   $0x4
  800ca2:	68 c0 15 80 00       	push   $0x8015c0
  800ca7:	6a 33                	push   $0x33
  800ca9:	68 dd 15 80 00       	push   $0x8015dd
  800cae:	e8 c1 02 00 00       	call   800f74 <_panic>

00800cb3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc2:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cca:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccd:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	7f 08                	jg     800cde <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cde:	83 ec 0c             	sub    $0xc,%esp
  800ce1:	50                   	push   %eax
  800ce2:	6a 05                	push   $0x5
  800ce4:	68 c0 15 80 00       	push   $0x8015c0
  800ce9:	6a 33                	push   $0x33
  800ceb:	68 dd 15 80 00       	push   $0x8015dd
  800cf0:	e8 7f 02 00 00       	call   800f74 <_panic>

00800cf5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
  800cfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d03:	8b 55 08             	mov    0x8(%ebp),%edx
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	b8 06 00 00 00       	mov    $0x6,%eax
  800d0e:	89 df                	mov    %ebx,%edi
  800d10:	89 de                	mov    %ebx,%esi
  800d12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d14:	85 c0                	test   %eax,%eax
  800d16:	7f 08                	jg     800d20 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d20:	83 ec 0c             	sub    $0xc,%esp
  800d23:	50                   	push   %eax
  800d24:	6a 06                	push   $0x6
  800d26:	68 c0 15 80 00       	push   $0x8015c0
  800d2b:	6a 33                	push   $0x33
  800d2d:	68 dd 15 80 00       	push   $0x8015dd
  800d32:	e8 3d 02 00 00       	call   800f74 <_panic>

00800d37 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d40:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d4d:	89 cb                	mov    %ecx,%ebx
  800d4f:	89 cf                	mov    %ecx,%edi
  800d51:	89 ce                	mov    %ecx,%esi
  800d53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7f 08                	jg     800d61 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5c:	5b                   	pop    %ebx
  800d5d:	5e                   	pop    %esi
  800d5e:	5f                   	pop    %edi
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d61:	83 ec 0c             	sub    $0xc,%esp
  800d64:	50                   	push   %eax
  800d65:	6a 0b                	push   $0xb
  800d67:	68 c0 15 80 00       	push   $0x8015c0
  800d6c:	6a 33                	push   $0x33
  800d6e:	68 dd 15 80 00       	push   $0x8015dd
  800d73:	e8 fc 01 00 00       	call   800f74 <_panic>

00800d78 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	89 de                	mov    %ebx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	50                   	push   %eax
  800da7:	6a 08                	push   $0x8
  800da9:	68 c0 15 80 00       	push   $0x8015c0
  800dae:	6a 33                	push   $0x33
  800db0:	68 dd 15 80 00       	push   $0x8015dd
  800db5:	e8 ba 01 00 00       	call   800f74 <_panic>

00800dba <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dce:	b8 09 00 00 00       	mov    $0x9,%eax
  800dd3:	89 df                	mov    %ebx,%edi
  800dd5:	89 de                	mov    %ebx,%esi
  800dd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7f 08                	jg     800de5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	50                   	push   %eax
  800de9:	6a 09                	push   $0x9
  800deb:	68 c0 15 80 00       	push   $0x8015c0
  800df0:	6a 33                	push   $0x33
  800df2:	68 dd 15 80 00       	push   $0x8015dd
  800df7:	e8 78 01 00 00       	call   800f74 <_panic>

00800dfc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	50                   	push   %eax
  800e2b:	6a 0a                	push   $0xa
  800e2d:	68 c0 15 80 00       	push   $0x8015c0
  800e32:	6a 33                	push   $0x33
  800e34:	68 dd 15 80 00       	push   $0x8015dd
  800e39:	e8 36 01 00 00       	call   800f74 <_panic>

00800e3e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	57                   	push   %edi
  800e42:	56                   	push   %esi
  800e43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e4f:	be 00 00 00 00       	mov    $0x0,%esi
  800e54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e57:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    

00800e61 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
  800e67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e77:	89 cb                	mov    %ecx,%ebx
  800e79:	89 cf                	mov    %ecx,%edi
  800e7b:	89 ce                	mov    %ecx,%esi
  800e7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	7f 08                	jg     800e8b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8b:	83 ec 0c             	sub    $0xc,%esp
  800e8e:	50                   	push   %eax
  800e8f:	6a 0e                	push   $0xe
  800e91:	68 c0 15 80 00       	push   $0x8015c0
  800e96:	6a 33                	push   $0x33
  800e98:	68 dd 15 80 00       	push   $0x8015dd
  800e9d:	e8 d2 00 00 00       	call   800f74 <_panic>

00800ea2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	b8 10 00 00 00       	mov    $0x10,%eax
  800ed6:	89 cb                	mov    %ecx,%ebx
  800ed8:	89 cf                	mov    %ecx,%edi
  800eda:	89 ce                	mov    %ecx,%esi
  800edc:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800ee9:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800ef0:	74 0a                	je     800efc <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  800efc:	83 ec 04             	sub    $0x4,%esp
  800eff:	6a 07                	push   $0x7
  800f01:	68 00 f0 bf ee       	push   $0xeebff000
  800f06:	6a 00                	push   $0x0
  800f08:	e8 63 fd ff ff       	call   800c70 <sys_page_alloc>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	78 28                	js     800f3c <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	68 4e 0f 80 00       	push   $0x800f4e
  800f1c:	6a 00                	push   $0x0
  800f1e:	e8 d9 fe ff ff       	call   800dfc <sys_env_set_pgfault_upcall>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	85 c0                	test   %eax,%eax
  800f28:	79 c8                	jns    800ef2 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  800f2a:	50                   	push   %eax
  800f2b:	68 14 16 80 00       	push   $0x801614
  800f30:	6a 23                	push   $0x23
  800f32:	68 03 16 80 00       	push   $0x801603
  800f37:	e8 38 00 00 00       	call   800f74 <_panic>
			panic("set_pgfault_handler %e\n",r);
  800f3c:	50                   	push   %eax
  800f3d:	68 eb 15 80 00       	push   $0x8015eb
  800f42:	6a 21                	push   $0x21
  800f44:	68 03 16 80 00       	push   $0x801603
  800f49:	e8 26 00 00 00       	call   800f74 <_panic>

00800f4e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f4e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f4f:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800f54:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f56:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  800f59:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  800f5d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  800f61:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800f64:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  800f66:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  800f6a:	83 c4 08             	add    $0x8,%esp
	popal
  800f6d:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800f6e:	83 c4 04             	add    $0x4,%esp
	popfl
  800f71:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800f72:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800f73:	c3                   	ret    

00800f74 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800f79:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f7c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f82:	e8 ab fc ff ff       	call   800c32 <sys_getenvid>
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	ff 75 0c             	pushl  0xc(%ebp)
  800f8d:	ff 75 08             	pushl  0x8(%ebp)
  800f90:	56                   	push   %esi
  800f91:	50                   	push   %eax
  800f92:	68 34 16 80 00       	push   $0x801634
  800f97:	e8 d4 f1 ff ff       	call   800170 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f9c:	83 c4 18             	add    $0x18,%esp
  800f9f:	53                   	push   %ebx
  800fa0:	ff 75 10             	pushl  0x10(%ebp)
  800fa3:	e8 77 f1 ff ff       	call   80011f <vcprintf>
	cprintf("\n");
  800fa8:	c7 04 24 01 16 80 00 	movl   $0x801601,(%esp)
  800faf:	e8 bc f1 ff ff       	call   800170 <cprintf>
  800fb4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800fb7:	cc                   	int3   
  800fb8:	eb fd                	jmp    800fb7 <_panic+0x43>
  800fba:	66 90                	xchg   %ax,%ax
  800fbc:	66 90                	xchg   %ax,%ax
  800fbe:	66 90                	xchg   %ax,%ax

00800fc0 <__udivdi3>:
  800fc0:	55                   	push   %ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
  800fc4:	83 ec 1c             	sub    $0x1c,%esp
  800fc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800fcb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800fcf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fd3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fd7:	85 d2                	test   %edx,%edx
  800fd9:	75 4d                	jne    801028 <__udivdi3+0x68>
  800fdb:	39 f3                	cmp    %esi,%ebx
  800fdd:	76 19                	jbe    800ff8 <__udivdi3+0x38>
  800fdf:	31 ff                	xor    %edi,%edi
  800fe1:	89 e8                	mov    %ebp,%eax
  800fe3:	89 f2                	mov    %esi,%edx
  800fe5:	f7 f3                	div    %ebx
  800fe7:	89 fa                	mov    %edi,%edx
  800fe9:	83 c4 1c             	add    $0x1c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	89 d9                	mov    %ebx,%ecx
  800ffa:	85 db                	test   %ebx,%ebx
  800ffc:	75 0b                	jne    801009 <__udivdi3+0x49>
  800ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  801003:	31 d2                	xor    %edx,%edx
  801005:	f7 f3                	div    %ebx
  801007:	89 c1                	mov    %eax,%ecx
  801009:	31 d2                	xor    %edx,%edx
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	f7 f1                	div    %ecx
  80100f:	89 c6                	mov    %eax,%esi
  801011:	89 e8                	mov    %ebp,%eax
  801013:	89 f7                	mov    %esi,%edi
  801015:	f7 f1                	div    %ecx
  801017:	89 fa                	mov    %edi,%edx
  801019:	83 c4 1c             	add    $0x1c,%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    
  801021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801028:	39 f2                	cmp    %esi,%edx
  80102a:	77 1c                	ja     801048 <__udivdi3+0x88>
  80102c:	0f bd fa             	bsr    %edx,%edi
  80102f:	83 f7 1f             	xor    $0x1f,%edi
  801032:	75 2c                	jne    801060 <__udivdi3+0xa0>
  801034:	39 f2                	cmp    %esi,%edx
  801036:	72 06                	jb     80103e <__udivdi3+0x7e>
  801038:	31 c0                	xor    %eax,%eax
  80103a:	39 eb                	cmp    %ebp,%ebx
  80103c:	77 a9                	ja     800fe7 <__udivdi3+0x27>
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
  801043:	eb a2                	jmp    800fe7 <__udivdi3+0x27>
  801045:	8d 76 00             	lea    0x0(%esi),%esi
  801048:	31 ff                	xor    %edi,%edi
  80104a:	31 c0                	xor    %eax,%eax
  80104c:	89 fa                	mov    %edi,%edx
  80104e:	83 c4 1c             	add    $0x1c,%esp
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5f                   	pop    %edi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    
  801056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80105d:	8d 76 00             	lea    0x0(%esi),%esi
  801060:	89 f9                	mov    %edi,%ecx
  801062:	b8 20 00 00 00       	mov    $0x20,%eax
  801067:	29 f8                	sub    %edi,%eax
  801069:	d3 e2                	shl    %cl,%edx
  80106b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80106f:	89 c1                	mov    %eax,%ecx
  801071:	89 da                	mov    %ebx,%edx
  801073:	d3 ea                	shr    %cl,%edx
  801075:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801079:	09 d1                	or     %edx,%ecx
  80107b:	89 f2                	mov    %esi,%edx
  80107d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801081:	89 f9                	mov    %edi,%ecx
  801083:	d3 e3                	shl    %cl,%ebx
  801085:	89 c1                	mov    %eax,%ecx
  801087:	d3 ea                	shr    %cl,%edx
  801089:	89 f9                	mov    %edi,%ecx
  80108b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80108f:	89 eb                	mov    %ebp,%ebx
  801091:	d3 e6                	shl    %cl,%esi
  801093:	89 c1                	mov    %eax,%ecx
  801095:	d3 eb                	shr    %cl,%ebx
  801097:	09 de                	or     %ebx,%esi
  801099:	89 f0                	mov    %esi,%eax
  80109b:	f7 74 24 08          	divl   0x8(%esp)
  80109f:	89 d6                	mov    %edx,%esi
  8010a1:	89 c3                	mov    %eax,%ebx
  8010a3:	f7 64 24 0c          	mull   0xc(%esp)
  8010a7:	39 d6                	cmp    %edx,%esi
  8010a9:	72 15                	jb     8010c0 <__udivdi3+0x100>
  8010ab:	89 f9                	mov    %edi,%ecx
  8010ad:	d3 e5                	shl    %cl,%ebp
  8010af:	39 c5                	cmp    %eax,%ebp
  8010b1:	73 04                	jae    8010b7 <__udivdi3+0xf7>
  8010b3:	39 d6                	cmp    %edx,%esi
  8010b5:	74 09                	je     8010c0 <__udivdi3+0x100>
  8010b7:	89 d8                	mov    %ebx,%eax
  8010b9:	31 ff                	xor    %edi,%edi
  8010bb:	e9 27 ff ff ff       	jmp    800fe7 <__udivdi3+0x27>
  8010c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010c3:	31 ff                	xor    %edi,%edi
  8010c5:	e9 1d ff ff ff       	jmp    800fe7 <__udivdi3+0x27>
  8010ca:	66 90                	xchg   %ax,%ax
  8010cc:	66 90                	xchg   %ax,%ax
  8010ce:	66 90                	xchg   %ax,%ax

008010d0 <__umoddi3>:
  8010d0:	55                   	push   %ebp
  8010d1:	57                   	push   %edi
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	83 ec 1c             	sub    $0x1c,%esp
  8010d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010e7:	89 da                	mov    %ebx,%edx
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	75 43                	jne    801130 <__umoddi3+0x60>
  8010ed:	39 df                	cmp    %ebx,%edi
  8010ef:	76 17                	jbe    801108 <__umoddi3+0x38>
  8010f1:	89 f0                	mov    %esi,%eax
  8010f3:	f7 f7                	div    %edi
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	31 d2                	xor    %edx,%edx
  8010f9:	83 c4 1c             	add    $0x1c,%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	5f                   	pop    %edi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    
  801101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801108:	89 fd                	mov    %edi,%ebp
  80110a:	85 ff                	test   %edi,%edi
  80110c:	75 0b                	jne    801119 <__umoddi3+0x49>
  80110e:	b8 01 00 00 00       	mov    $0x1,%eax
  801113:	31 d2                	xor    %edx,%edx
  801115:	f7 f7                	div    %edi
  801117:	89 c5                	mov    %eax,%ebp
  801119:	89 d8                	mov    %ebx,%eax
  80111b:	31 d2                	xor    %edx,%edx
  80111d:	f7 f5                	div    %ebp
  80111f:	89 f0                	mov    %esi,%eax
  801121:	f7 f5                	div    %ebp
  801123:	89 d0                	mov    %edx,%eax
  801125:	eb d0                	jmp    8010f7 <__umoddi3+0x27>
  801127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80112e:	66 90                	xchg   %ax,%ax
  801130:	89 f1                	mov    %esi,%ecx
  801132:	39 d8                	cmp    %ebx,%eax
  801134:	76 0a                	jbe    801140 <__umoddi3+0x70>
  801136:	89 f0                	mov    %esi,%eax
  801138:	83 c4 1c             	add    $0x1c,%esp
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5f                   	pop    %edi
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    
  801140:	0f bd e8             	bsr    %eax,%ebp
  801143:	83 f5 1f             	xor    $0x1f,%ebp
  801146:	75 20                	jne    801168 <__umoddi3+0x98>
  801148:	39 d8                	cmp    %ebx,%eax
  80114a:	0f 82 b0 00 00 00    	jb     801200 <__umoddi3+0x130>
  801150:	39 f7                	cmp    %esi,%edi
  801152:	0f 86 a8 00 00 00    	jbe    801200 <__umoddi3+0x130>
  801158:	89 c8                	mov    %ecx,%eax
  80115a:	83 c4 1c             	add    $0x1c,%esp
  80115d:	5b                   	pop    %ebx
  80115e:	5e                   	pop    %esi
  80115f:	5f                   	pop    %edi
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    
  801162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801168:	89 e9                	mov    %ebp,%ecx
  80116a:	ba 20 00 00 00       	mov    $0x20,%edx
  80116f:	29 ea                	sub    %ebp,%edx
  801171:	d3 e0                	shl    %cl,%eax
  801173:	89 44 24 08          	mov    %eax,0x8(%esp)
  801177:	89 d1                	mov    %edx,%ecx
  801179:	89 f8                	mov    %edi,%eax
  80117b:	d3 e8                	shr    %cl,%eax
  80117d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801181:	89 54 24 04          	mov    %edx,0x4(%esp)
  801185:	8b 54 24 04          	mov    0x4(%esp),%edx
  801189:	09 c1                	or     %eax,%ecx
  80118b:	89 d8                	mov    %ebx,%eax
  80118d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801191:	89 e9                	mov    %ebp,%ecx
  801193:	d3 e7                	shl    %cl,%edi
  801195:	89 d1                	mov    %edx,%ecx
  801197:	d3 e8                	shr    %cl,%eax
  801199:	89 e9                	mov    %ebp,%ecx
  80119b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80119f:	d3 e3                	shl    %cl,%ebx
  8011a1:	89 c7                	mov    %eax,%edi
  8011a3:	89 d1                	mov    %edx,%ecx
  8011a5:	89 f0                	mov    %esi,%eax
  8011a7:	d3 e8                	shr    %cl,%eax
  8011a9:	89 e9                	mov    %ebp,%ecx
  8011ab:	89 fa                	mov    %edi,%edx
  8011ad:	d3 e6                	shl    %cl,%esi
  8011af:	09 d8                	or     %ebx,%eax
  8011b1:	f7 74 24 08          	divl   0x8(%esp)
  8011b5:	89 d1                	mov    %edx,%ecx
  8011b7:	89 f3                	mov    %esi,%ebx
  8011b9:	f7 64 24 0c          	mull   0xc(%esp)
  8011bd:	89 c6                	mov    %eax,%esi
  8011bf:	89 d7                	mov    %edx,%edi
  8011c1:	39 d1                	cmp    %edx,%ecx
  8011c3:	72 06                	jb     8011cb <__umoddi3+0xfb>
  8011c5:	75 10                	jne    8011d7 <__umoddi3+0x107>
  8011c7:	39 c3                	cmp    %eax,%ebx
  8011c9:	73 0c                	jae    8011d7 <__umoddi3+0x107>
  8011cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8011cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011d3:	89 d7                	mov    %edx,%edi
  8011d5:	89 c6                	mov    %eax,%esi
  8011d7:	89 ca                	mov    %ecx,%edx
  8011d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011de:	29 f3                	sub    %esi,%ebx
  8011e0:	19 fa                	sbb    %edi,%edx
  8011e2:	89 d0                	mov    %edx,%eax
  8011e4:	d3 e0                	shl    %cl,%eax
  8011e6:	89 e9                	mov    %ebp,%ecx
  8011e8:	d3 eb                	shr    %cl,%ebx
  8011ea:	d3 ea                	shr    %cl,%edx
  8011ec:	09 d8                	or     %ebx,%eax
  8011ee:	83 c4 1c             	add    $0x1c,%esp
  8011f1:	5b                   	pop    %ebx
  8011f2:	5e                   	pop    %esi
  8011f3:	5f                   	pop    %edi
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    
  8011f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011fd:	8d 76 00             	lea    0x0(%esi),%esi
  801200:	89 da                	mov    %ebx,%edx
  801202:	29 fe                	sub    %edi,%esi
  801204:	19 c2                	sbb    %eax,%edx
  801206:	89 f1                	mov    %esi,%ecx
  801208:	89 c8                	mov    %ecx,%eax
  80120a:	e9 4b ff ff ff       	jmp    80115a <__umoddi3+0x8a>
