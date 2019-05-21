
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 8e 11 80 00       	push   $0x80118e
  800053:	e8 07 01 00 00       	call   80015f <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 80 11 80 00       	push   $0x801180
  800065:	e8 f5 00 00 00       	call   80015f <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800077:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80007a:	e8 a2 0b 00 00       	call   800c21 <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800087:	c1 e0 04             	shl    $0x4,%eax
  80008a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008f:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800094:	85 db                	test   %ebx,%ebx
  800096:	7e 07                	jle    80009f <libmain+0x30>
		binaryname = argv[0];
  800098:	8b 06                	mov    (%esi),%eax
  80009a:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
  8000a4:	e8 8a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a9:	e8 0a 00 00 00       	call   8000b8 <exit>
}
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b4:	5b                   	pop    %ebx
  8000b5:	5e                   	pop    %esi
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000be:	6a 00                	push   $0x0
  8000c0:	e8 1b 0b 00 00       	call   800be0 <sys_env_destroy>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	53                   	push   %ebx
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d4:	8b 13                	mov    (%ebx),%edx
  8000d6:	8d 42 01             	lea    0x1(%edx),%eax
  8000d9:	89 03                	mov    %eax,(%ebx)
  8000db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000de:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e7:	74 09                	je     8000f2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f2:	83 ec 08             	sub    $0x8,%esp
  8000f5:	68 ff 00 00 00       	push   $0xff
  8000fa:	8d 43 08             	lea    0x8(%ebx),%eax
  8000fd:	50                   	push   %eax
  8000fe:	e8 a0 0a 00 00       	call   800ba3 <sys_cputs>
		b->idx = 0;
  800103:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	eb db                	jmp    8000e9 <putch+0x1f>

0080010e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800117:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011e:	00 00 00 
	b.cnt = 0;
  800121:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800128:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80012b:	ff 75 0c             	pushl  0xc(%ebp)
  80012e:	ff 75 08             	pushl  0x8(%ebp)
  800131:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800137:	50                   	push   %eax
  800138:	68 ca 00 80 00       	push   $0x8000ca
  80013d:	e8 4a 01 00 00       	call   80028c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800142:	83 c4 08             	add    $0x8,%esp
  800145:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80014b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800151:	50                   	push   %eax
  800152:	e8 4c 0a 00 00       	call   800ba3 <sys_cputs>

	return b.cnt;
}
  800157:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800165:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800168:	50                   	push   %eax
  800169:	ff 75 08             	pushl  0x8(%ebp)
  80016c:	e8 9d ff ff ff       	call   80010e <vcprintf>
	va_end(ap);

	return cnt;
}
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	57                   	push   %edi
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
  800179:	83 ec 1c             	sub    $0x1c,%esp
  80017c:	89 c6                	mov    %eax,%esi
  80017e:	89 d7                	mov    %edx,%edi
  800180:	8b 45 08             	mov    0x8(%ebp),%eax
  800183:	8b 55 0c             	mov    0xc(%ebp),%edx
  800186:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800189:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80018c:	8b 45 10             	mov    0x10(%ebp),%eax
  80018f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800192:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800196:	74 2c                	je     8001c4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800198:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001a8:	39 c2                	cmp    %eax,%edx
  8001aa:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001ad:	73 43                	jae    8001f2 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001af:	83 eb 01             	sub    $0x1,%ebx
  8001b2:	85 db                	test   %ebx,%ebx
  8001b4:	7e 6c                	jle    800222 <printnum+0xaf>
			putch(padc, putdat);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	57                   	push   %edi
  8001ba:	ff 75 18             	pushl  0x18(%ebp)
  8001bd:	ff d6                	call   *%esi
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	eb eb                	jmp    8001af <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	6a 20                	push   $0x20
  8001c9:	6a 00                	push   $0x0
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d2:	89 fa                	mov    %edi,%edx
  8001d4:	89 f0                	mov    %esi,%eax
  8001d6:	e8 98 ff ff ff       	call   800173 <printnum>
		while (--width > 0)
  8001db:	83 c4 20             	add    $0x20,%esp
  8001de:	83 eb 01             	sub    $0x1,%ebx
  8001e1:	85 db                	test   %ebx,%ebx
  8001e3:	7e 65                	jle    80024a <printnum+0xd7>
			putch(padc, putdat);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	57                   	push   %edi
  8001e9:	6a 20                	push   $0x20
  8001eb:	ff d6                	call   *%esi
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	eb ec                	jmp    8001de <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	ff 75 18             	pushl  0x18(%ebp)
  8001f8:	83 eb 01             	sub    $0x1,%ebx
  8001fb:	53                   	push   %ebx
  8001fc:	50                   	push   %eax
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	ff 75 dc             	pushl  -0x24(%ebp)
  800203:	ff 75 d8             	pushl  -0x28(%ebp)
  800206:	ff 75 e4             	pushl  -0x1c(%ebp)
  800209:	ff 75 e0             	pushl  -0x20(%ebp)
  80020c:	e8 0f 0d 00 00       	call   800f20 <__udivdi3>
  800211:	83 c4 18             	add    $0x18,%esp
  800214:	52                   	push   %edx
  800215:	50                   	push   %eax
  800216:	89 fa                	mov    %edi,%edx
  800218:	89 f0                	mov    %esi,%eax
  80021a:	e8 54 ff ff ff       	call   800173 <printnum>
  80021f:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	57                   	push   %edi
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	ff 75 d8             	pushl  -0x28(%ebp)
  80022f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800232:	ff 75 e0             	pushl  -0x20(%ebp)
  800235:	e8 f6 0d 00 00       	call   801030 <__umoddi3>
  80023a:	83 c4 14             	add    $0x14,%esp
  80023d:	0f be 80 b2 11 80 00 	movsbl 0x8011b2(%eax),%eax
  800244:	50                   	push   %eax
  800245:	ff d6                	call   *%esi
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024d:	5b                   	pop    %ebx
  80024e:	5e                   	pop    %esi
  80024f:	5f                   	pop    %edi
  800250:	5d                   	pop    %ebp
  800251:	c3                   	ret    

00800252 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800258:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1b>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800275:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 10             	pushl  0x10(%ebp)
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	ff 75 08             	pushl  0x8(%ebp)
  800282:	e8 05 00 00 00       	call   80028c <vprintfmt>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <vprintfmt>:
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 3c             	sub    $0x3c,%esp
  800295:	8b 75 08             	mov    0x8(%ebp),%esi
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029e:	e9 b4 03 00 00       	jmp    800657 <vprintfmt+0x3cb>
		padc = ' ';
  8002a3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8002a7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8002ae:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002b5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c8:	8d 47 01             	lea    0x1(%edi),%eax
  8002cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ce:	0f b6 17             	movzbl (%edi),%edx
  8002d1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d4:	3c 55                	cmp    $0x55,%al
  8002d6:	0f 87 c8 04 00 00    	ja     8007a4 <vprintfmt+0x518>
  8002dc:	0f b6 c0             	movzbl %al,%eax
  8002df:	ff 24 85 a0 13 80 00 	jmp    *0x8013a0(,%eax,4)
  8002e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8002e9:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8002f0:	eb d6                	jmp    8002c8 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8002f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002f5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002f9:	eb cd                	jmp    8002c8 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8002fb:	0f b6 d2             	movzbl %dl,%edx
  8002fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800309:	eb 0c                	jmp    800317 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80030b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80030e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800312:	eb b4                	jmp    8002c8 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800314:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800317:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80031a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80031e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800321:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800324:	83 f9 09             	cmp    $0x9,%ecx
  800327:	76 eb                	jbe    800314 <vprintfmt+0x88>
  800329:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032f:	eb 14                	jmp    800345 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800331:	8b 45 14             	mov    0x14(%ebp),%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800339:	8b 45 14             	mov    0x14(%ebp),%eax
  80033c:	8d 40 04             	lea    0x4(%eax),%eax
  80033f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800349:	0f 89 79 ff ff ff    	jns    8002c8 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80034f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800352:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800355:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80035c:	e9 67 ff ff ff       	jmp    8002c8 <vprintfmt+0x3c>
  800361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800364:	85 c0                	test   %eax,%eax
  800366:	ba 00 00 00 00       	mov    $0x0,%edx
  80036b:	0f 49 d0             	cmovns %eax,%edx
  80036e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800374:	e9 4f ff ff ff       	jmp    8002c8 <vprintfmt+0x3c>
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80037c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800383:	e9 40 ff ff ff       	jmp    8002c8 <vprintfmt+0x3c>
			lflag++;
  800388:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038e:	e9 35 ff ff ff       	jmp    8002c8 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800393:	8b 45 14             	mov    0x14(%ebp),%eax
  800396:	8d 78 04             	lea    0x4(%eax),%edi
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	53                   	push   %ebx
  80039d:	ff 30                	pushl  (%eax)
  80039f:	ff d6                	call   *%esi
			break;
  8003a1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a7:	e9 a8 02 00 00       	jmp    800654 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8003ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8003af:	8d 78 04             	lea    0x4(%eax),%edi
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	99                   	cltd   
  8003b5:	31 d0                	xor    %edx,%eax
  8003b7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b9:	83 f8 0f             	cmp    $0xf,%eax
  8003bc:	7f 23                	jg     8003e1 <vprintfmt+0x155>
  8003be:	8b 14 85 00 15 80 00 	mov    0x801500(,%eax,4),%edx
  8003c5:	85 d2                	test   %edx,%edx
  8003c7:	74 18                	je     8003e1 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8003c9:	52                   	push   %edx
  8003ca:	68 d3 11 80 00       	push   $0x8011d3
  8003cf:	53                   	push   %ebx
  8003d0:	56                   	push   %esi
  8003d1:	e8 99 fe ff ff       	call   80026f <printfmt>
  8003d6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003dc:	e9 73 02 00 00       	jmp    800654 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8003e1:	50                   	push   %eax
  8003e2:	68 ca 11 80 00       	push   $0x8011ca
  8003e7:	53                   	push   %ebx
  8003e8:	56                   	push   %esi
  8003e9:	e8 81 fe ff ff       	call   80026f <printfmt>
  8003ee:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f4:	e9 5b 02 00 00       	jmp    800654 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	83 c0 04             	add    $0x4,%eax
  8003ff:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800407:	85 d2                	test   %edx,%edx
  800409:	b8 c3 11 80 00       	mov    $0x8011c3,%eax
  80040e:	0f 45 c2             	cmovne %edx,%eax
  800411:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800414:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800418:	7e 06                	jle    800420 <vprintfmt+0x194>
  80041a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80041e:	75 0d                	jne    80042d <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800420:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800423:	89 c7                	mov    %eax,%edi
  800425:	03 45 e0             	add    -0x20(%ebp),%eax
  800428:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042b:	eb 53                	jmp    800480 <vprintfmt+0x1f4>
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	ff 75 d8             	pushl  -0x28(%ebp)
  800433:	50                   	push   %eax
  800434:	e8 13 04 00 00       	call   80084c <strnlen>
  800439:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80043c:	29 c1                	sub    %eax,%ecx
  80043e:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800446:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80044a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80044d:	eb 0f                	jmp    80045e <vprintfmt+0x1d2>
					putch(padc, putdat);
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	53                   	push   %ebx
  800453:	ff 75 e0             	pushl  -0x20(%ebp)
  800456:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800458:	83 ef 01             	sub    $0x1,%edi
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	85 ff                	test   %edi,%edi
  800460:	7f ed                	jg     80044f <vprintfmt+0x1c3>
  800462:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800465:	85 d2                	test   %edx,%edx
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	0f 49 c2             	cmovns %edx,%eax
  80046f:	29 c2                	sub    %eax,%edx
  800471:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800474:	eb aa                	jmp    800420 <vprintfmt+0x194>
					putch(ch, putdat);
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	53                   	push   %ebx
  80047a:	52                   	push   %edx
  80047b:	ff d6                	call   *%esi
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800483:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800485:	83 c7 01             	add    $0x1,%edi
  800488:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80048c:	0f be d0             	movsbl %al,%edx
  80048f:	85 d2                	test   %edx,%edx
  800491:	74 4b                	je     8004de <vprintfmt+0x252>
  800493:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800497:	78 06                	js     80049f <vprintfmt+0x213>
  800499:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80049d:	78 1e                	js     8004bd <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80049f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a3:	74 d1                	je     800476 <vprintfmt+0x1ea>
  8004a5:	0f be c0             	movsbl %al,%eax
  8004a8:	83 e8 20             	sub    $0x20,%eax
  8004ab:	83 f8 5e             	cmp    $0x5e,%eax
  8004ae:	76 c6                	jbe    800476 <vprintfmt+0x1ea>
					putch('?', putdat);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	53                   	push   %ebx
  8004b4:	6a 3f                	push   $0x3f
  8004b6:	ff d6                	call   *%esi
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	eb c3                	jmp    800480 <vprintfmt+0x1f4>
  8004bd:	89 cf                	mov    %ecx,%edi
  8004bf:	eb 0e                	jmp    8004cf <vprintfmt+0x243>
				putch(' ', putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	6a 20                	push   $0x20
  8004c7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004c9:	83 ef 01             	sub    $0x1,%edi
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	85 ff                	test   %edi,%edi
  8004d1:	7f ee                	jg     8004c1 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004d9:	e9 76 01 00 00       	jmp    800654 <vprintfmt+0x3c8>
  8004de:	89 cf                	mov    %ecx,%edi
  8004e0:	eb ed                	jmp    8004cf <vprintfmt+0x243>
	if (lflag >= 2)
  8004e2:	83 f9 01             	cmp    $0x1,%ecx
  8004e5:	7f 1f                	jg     800506 <vprintfmt+0x27a>
	else if (lflag)
  8004e7:	85 c9                	test   %ecx,%ecx
  8004e9:	74 6a                	je     800555 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f3:	89 c1                	mov    %eax,%ecx
  8004f5:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8d 40 04             	lea    0x4(%eax),%eax
  800501:	89 45 14             	mov    %eax,0x14(%ebp)
  800504:	eb 17                	jmp    80051d <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8b 50 04             	mov    0x4(%eax),%edx
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800511:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 40 08             	lea    0x8(%eax),%eax
  80051a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80051d:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800520:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800525:	85 d2                	test   %edx,%edx
  800527:	0f 89 f8 00 00 00    	jns    800625 <vprintfmt+0x399>
				putch('-', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 2d                	push   $0x2d
  800533:	ff d6                	call   *%esi
				num = -(long long) num;
  800535:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800538:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80053b:	f7 d8                	neg    %eax
  80053d:	83 d2 00             	adc    $0x0,%edx
  800540:	f7 da                	neg    %edx
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800545:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800548:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800550:	e9 e1 00 00 00       	jmp    800636 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	99                   	cltd   
  80055e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8d 40 04             	lea    0x4(%eax),%eax
  800567:	89 45 14             	mov    %eax,0x14(%ebp)
  80056a:	eb b1                	jmp    80051d <vprintfmt+0x291>
	if (lflag >= 2)
  80056c:	83 f9 01             	cmp    $0x1,%ecx
  80056f:	7f 27                	jg     800598 <vprintfmt+0x30c>
	else if (lflag)
  800571:	85 c9                	test   %ecx,%ecx
  800573:	74 41                	je     8005b6 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	ba 00 00 00 00       	mov    $0x0,%edx
  80057f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800582:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 40 04             	lea    0x4(%eax),%eax
  80058b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800593:	e9 8d 00 00 00       	jmp    800625 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 50 04             	mov    0x4(%eax),%edx
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005af:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005b4:	eb 6f                	jmp    800625 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8d 40 04             	lea    0x4(%eax),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005d4:	eb 4f                	jmp    800625 <vprintfmt+0x399>
	if (lflag >= 2)
  8005d6:	83 f9 01             	cmp    $0x1,%ecx
  8005d9:	7f 23                	jg     8005fe <vprintfmt+0x372>
	else if (lflag)
  8005db:	85 c9                	test   %ecx,%ecx
  8005dd:	0f 84 98 00 00 00    	je     80067b <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8d 40 04             	lea    0x4(%eax),%eax
  8005f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fc:	eb 17                	jmp    800615 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8b 50 04             	mov    0x4(%eax),%edx
  800604:	8b 00                	mov    (%eax),%eax
  800606:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800609:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 40 08             	lea    0x8(%eax),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	53                   	push   %ebx
  800619:	6a 30                	push   $0x30
  80061b:	ff d6                	call   *%esi
			goto number;
  80061d:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800620:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800625:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800629:	74 0b                	je     800636 <vprintfmt+0x3aa>
				putch('+', putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	53                   	push   %ebx
  80062f:	6a 2b                	push   $0x2b
  800631:	ff d6                	call   *%esi
  800633:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800636:	83 ec 0c             	sub    $0xc,%esp
  800639:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80063d:	50                   	push   %eax
  80063e:	ff 75 e0             	pushl  -0x20(%ebp)
  800641:	57                   	push   %edi
  800642:	ff 75 dc             	pushl  -0x24(%ebp)
  800645:	ff 75 d8             	pushl  -0x28(%ebp)
  800648:	89 da                	mov    %ebx,%edx
  80064a:	89 f0                	mov    %esi,%eax
  80064c:	e8 22 fb ff ff       	call   800173 <printnum>
			break;
  800651:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800654:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800657:	83 c7 01             	add    $0x1,%edi
  80065a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065e:	83 f8 25             	cmp    $0x25,%eax
  800661:	0f 84 3c fc ff ff    	je     8002a3 <vprintfmt+0x17>
			if (ch == '\0')
  800667:	85 c0                	test   %eax,%eax
  800669:	0f 84 55 01 00 00    	je     8007c4 <vprintfmt+0x538>
			putch(ch, putdat);
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	53                   	push   %ebx
  800673:	50                   	push   %eax
  800674:	ff d6                	call   *%esi
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	eb dc                	jmp    800657 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800688:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8d 40 04             	lea    0x4(%eax),%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
  800694:	e9 7c ff ff ff       	jmp    800615 <vprintfmt+0x389>
			putch('0', putdat);
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	53                   	push   %ebx
  80069d:	6a 30                	push   $0x30
  80069f:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a1:	83 c4 08             	add    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	6a 78                	push   $0x78
  8006a7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006b9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8d 40 04             	lea    0x4(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c5:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8006ca:	e9 56 ff ff ff       	jmp    800625 <vprintfmt+0x399>
	if (lflag >= 2)
  8006cf:	83 f9 01             	cmp    $0x1,%ecx
  8006d2:	7f 27                	jg     8006fb <vprintfmt+0x46f>
	else if (lflag)
  8006d4:	85 c9                	test   %ecx,%ecx
  8006d6:	74 44                	je     80071c <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f1:	bf 10 00 00 00       	mov    $0x10,%edi
  8006f6:	e9 2a ff ff ff       	jmp    800625 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 50 04             	mov    0x4(%eax),%edx
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800706:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8d 40 08             	lea    0x8(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800712:	bf 10 00 00 00       	mov    $0x10,%edi
  800717:	e9 09 ff ff ff       	jmp    800625 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800729:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800735:	bf 10 00 00 00       	mov    $0x10,%edi
  80073a:	e9 e6 fe ff ff       	jmp    800625 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 78 04             	lea    0x4(%eax),%edi
  800745:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800747:	85 c0                	test   %eax,%eax
  800749:	74 2d                	je     800778 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80074b:	0f b6 13             	movzbl (%ebx),%edx
  80074e:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800750:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800753:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800756:	0f 8e f8 fe ff ff    	jle    800654 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80075c:	68 20 13 80 00       	push   $0x801320
  800761:	68 d3 11 80 00       	push   $0x8011d3
  800766:	53                   	push   %ebx
  800767:	56                   	push   %esi
  800768:	e8 02 fb ff ff       	call   80026f <printfmt>
  80076d:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800770:	89 7d 14             	mov    %edi,0x14(%ebp)
  800773:	e9 dc fe ff ff       	jmp    800654 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800778:	68 e8 12 80 00       	push   $0x8012e8
  80077d:	68 d3 11 80 00       	push   $0x8011d3
  800782:	53                   	push   %ebx
  800783:	56                   	push   %esi
  800784:	e8 e6 fa ff ff       	call   80026f <printfmt>
  800789:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80078c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80078f:	e9 c0 fe ff ff       	jmp    800654 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	53                   	push   %ebx
  800798:	6a 25                	push   $0x25
  80079a:	ff d6                	call   *%esi
			break;
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	e9 b0 fe ff ff       	jmp    800654 <vprintfmt+0x3c8>
			putch('%', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	53                   	push   %ebx
  8007a8:	6a 25                	push   $0x25
  8007aa:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 f8                	mov    %edi,%eax
  8007b1:	eb 03                	jmp    8007b6 <vprintfmt+0x52a>
  8007b3:	83 e8 01             	sub    $0x1,%eax
  8007b6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007ba:	75 f7                	jne    8007b3 <vprintfmt+0x527>
  8007bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007bf:	e9 90 fe ff ff       	jmp    800654 <vprintfmt+0x3c8>
}
  8007c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007c7:	5b                   	pop    %ebx
  8007c8:	5e                   	pop    %esi
  8007c9:	5f                   	pop    %edi
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	83 ec 18             	sub    $0x18,%esp
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007db:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007df:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	74 26                	je     800813 <vsnprintf+0x47>
  8007ed:	85 d2                	test   %edx,%edx
  8007ef:	7e 22                	jle    800813 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f1:	ff 75 14             	pushl  0x14(%ebp)
  8007f4:	ff 75 10             	pushl  0x10(%ebp)
  8007f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007fa:	50                   	push   %eax
  8007fb:	68 52 02 80 00       	push   $0x800252
  800800:	e8 87 fa ff ff       	call   80028c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800808:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80080e:	83 c4 10             	add    $0x10,%esp
}
  800811:	c9                   	leave  
  800812:	c3                   	ret    
		return -E_INVAL;
  800813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800818:	eb f7                	jmp    800811 <vsnprintf+0x45>

0080081a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800820:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800823:	50                   	push   %eax
  800824:	ff 75 10             	pushl  0x10(%ebp)
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	ff 75 08             	pushl  0x8(%ebp)
  80082d:	e8 9a ff ff ff       	call   8007cc <vsnprintf>
	va_end(ap);

	return rc;
}
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800843:	74 05                	je     80084a <strlen+0x16>
		n++;
  800845:	83 c0 01             	add    $0x1,%eax
  800848:	eb f5                	jmp    80083f <strlen+0xb>
	return n;
}
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800852:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800855:	ba 00 00 00 00       	mov    $0x0,%edx
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 0d                	je     80086b <strnlen+0x1f>
  80085e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800862:	74 05                	je     800869 <strnlen+0x1d>
		n++;
  800864:	83 c2 01             	add    $0x1,%edx
  800867:	eb f1                	jmp    80085a <strnlen+0xe>
  800869:	89 d0                	mov    %edx,%eax
	return n;
}
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    

0080086d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	53                   	push   %ebx
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800877:	ba 00 00 00 00       	mov    $0x0,%edx
  80087c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800880:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800883:	83 c2 01             	add    $0x1,%edx
  800886:	84 c9                	test   %cl,%cl
  800888:	75 f2                	jne    80087c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80088a:	5b                   	pop    %ebx
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	53                   	push   %ebx
  800891:	83 ec 10             	sub    $0x10,%esp
  800894:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800897:	53                   	push   %ebx
  800898:	e8 97 ff ff ff       	call   800834 <strlen>
  80089d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	01 d8                	add    %ebx,%eax
  8008a5:	50                   	push   %eax
  8008a6:	e8 c2 ff ff ff       	call   80086d <strcpy>
	return dst;
}
  8008ab:	89 d8                	mov    %ebx,%eax
  8008ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    

008008b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bd:	89 c6                	mov    %eax,%esi
  8008bf:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c2:	89 c2                	mov    %eax,%edx
  8008c4:	39 f2                	cmp    %esi,%edx
  8008c6:	74 11                	je     8008d9 <strncpy+0x27>
		*dst++ = *src;
  8008c8:	83 c2 01             	add    $0x1,%edx
  8008cb:	0f b6 19             	movzbl (%ecx),%ebx
  8008ce:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d1:	80 fb 01             	cmp    $0x1,%bl
  8008d4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008d7:	eb eb                	jmp    8008c4 <strncpy+0x12>
	}
	return ret;
}
  8008d9:	5b                   	pop    %ebx
  8008da:	5e                   	pop    %esi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	56                   	push   %esi
  8008e1:	53                   	push   %ebx
  8008e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e8:	8b 55 10             	mov    0x10(%ebp),%edx
  8008eb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ed:	85 d2                	test   %edx,%edx
  8008ef:	74 21                	je     800912 <strlcpy+0x35>
  8008f1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008f7:	39 c2                	cmp    %eax,%edx
  8008f9:	74 14                	je     80090f <strlcpy+0x32>
  8008fb:	0f b6 19             	movzbl (%ecx),%ebx
  8008fe:	84 db                	test   %bl,%bl
  800900:	74 0b                	je     80090d <strlcpy+0x30>
			*dst++ = *src++;
  800902:	83 c1 01             	add    $0x1,%ecx
  800905:	83 c2 01             	add    $0x1,%edx
  800908:	88 5a ff             	mov    %bl,-0x1(%edx)
  80090b:	eb ea                	jmp    8008f7 <strlcpy+0x1a>
  80090d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800912:	29 f0                	sub    %esi,%eax
}
  800914:	5b                   	pop    %ebx
  800915:	5e                   	pop    %esi
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800921:	0f b6 01             	movzbl (%ecx),%eax
  800924:	84 c0                	test   %al,%al
  800926:	74 0c                	je     800934 <strcmp+0x1c>
  800928:	3a 02                	cmp    (%edx),%al
  80092a:	75 08                	jne    800934 <strcmp+0x1c>
		p++, q++;
  80092c:	83 c1 01             	add    $0x1,%ecx
  80092f:	83 c2 01             	add    $0x1,%edx
  800932:	eb ed                	jmp    800921 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800934:	0f b6 c0             	movzbl %al,%eax
  800937:	0f b6 12             	movzbl (%edx),%edx
  80093a:	29 d0                	sub    %edx,%eax
}
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	53                   	push   %ebx
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 55 0c             	mov    0xc(%ebp),%edx
  800948:	89 c3                	mov    %eax,%ebx
  80094a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80094d:	eb 06                	jmp    800955 <strncmp+0x17>
		n--, p++, q++;
  80094f:	83 c0 01             	add    $0x1,%eax
  800952:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800955:	39 d8                	cmp    %ebx,%eax
  800957:	74 16                	je     80096f <strncmp+0x31>
  800959:	0f b6 08             	movzbl (%eax),%ecx
  80095c:	84 c9                	test   %cl,%cl
  80095e:	74 04                	je     800964 <strncmp+0x26>
  800960:	3a 0a                	cmp    (%edx),%cl
  800962:	74 eb                	je     80094f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800964:	0f b6 00             	movzbl (%eax),%eax
  800967:	0f b6 12             	movzbl (%edx),%edx
  80096a:	29 d0                	sub    %edx,%eax
}
  80096c:	5b                   	pop    %ebx
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    
		return 0;
  80096f:	b8 00 00 00 00       	mov    $0x0,%eax
  800974:	eb f6                	jmp    80096c <strncmp+0x2e>

00800976 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800980:	0f b6 10             	movzbl (%eax),%edx
  800983:	84 d2                	test   %dl,%dl
  800985:	74 09                	je     800990 <strchr+0x1a>
		if (*s == c)
  800987:	38 ca                	cmp    %cl,%dl
  800989:	74 0a                	je     800995 <strchr+0x1f>
	for (; *s; s++)
  80098b:	83 c0 01             	add    $0x1,%eax
  80098e:	eb f0                	jmp    800980 <strchr+0xa>
			return (char *) s;
	return 0;
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009a4:	38 ca                	cmp    %cl,%dl
  8009a6:	74 09                	je     8009b1 <strfind+0x1a>
  8009a8:	84 d2                	test   %dl,%dl
  8009aa:	74 05                	je     8009b1 <strfind+0x1a>
	for (; *s; s++)
  8009ac:	83 c0 01             	add    $0x1,%eax
  8009af:	eb f0                	jmp    8009a1 <strfind+0xa>
			break;
	return (char *) s;
}
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	57                   	push   %edi
  8009b7:	56                   	push   %esi
  8009b8:	53                   	push   %ebx
  8009b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009bf:	85 c9                	test   %ecx,%ecx
  8009c1:	74 31                	je     8009f4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c3:	89 f8                	mov    %edi,%eax
  8009c5:	09 c8                	or     %ecx,%eax
  8009c7:	a8 03                	test   $0x3,%al
  8009c9:	75 23                	jne    8009ee <memset+0x3b>
		c &= 0xFF;
  8009cb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009cf:	89 d3                	mov    %edx,%ebx
  8009d1:	c1 e3 08             	shl    $0x8,%ebx
  8009d4:	89 d0                	mov    %edx,%eax
  8009d6:	c1 e0 18             	shl    $0x18,%eax
  8009d9:	89 d6                	mov    %edx,%esi
  8009db:	c1 e6 10             	shl    $0x10,%esi
  8009de:	09 f0                	or     %esi,%eax
  8009e0:	09 c2                	or     %eax,%edx
  8009e2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009e4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e7:	89 d0                	mov    %edx,%eax
  8009e9:	fc                   	cld    
  8009ea:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ec:	eb 06                	jmp    8009f4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f1:	fc                   	cld    
  8009f2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009f4:	89 f8                	mov    %edi,%eax
  8009f6:	5b                   	pop    %ebx
  8009f7:	5e                   	pop    %esi
  8009f8:	5f                   	pop    %edi
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	57                   	push   %edi
  8009ff:	56                   	push   %esi
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a06:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a09:	39 c6                	cmp    %eax,%esi
  800a0b:	73 32                	jae    800a3f <memmove+0x44>
  800a0d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a10:	39 c2                	cmp    %eax,%edx
  800a12:	76 2b                	jbe    800a3f <memmove+0x44>
		s += n;
		d += n;
  800a14:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a17:	89 fe                	mov    %edi,%esi
  800a19:	09 ce                	or     %ecx,%esi
  800a1b:	09 d6                	or     %edx,%esi
  800a1d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a23:	75 0e                	jne    800a33 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a25:	83 ef 04             	sub    $0x4,%edi
  800a28:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a2b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a2e:	fd                   	std    
  800a2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a31:	eb 09                	jmp    800a3c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a33:	83 ef 01             	sub    $0x1,%edi
  800a36:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a39:	fd                   	std    
  800a3a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a3c:	fc                   	cld    
  800a3d:	eb 1a                	jmp    800a59 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3f:	89 c2                	mov    %eax,%edx
  800a41:	09 ca                	or     %ecx,%edx
  800a43:	09 f2                	or     %esi,%edx
  800a45:	f6 c2 03             	test   $0x3,%dl
  800a48:	75 0a                	jne    800a54 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a4a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a4d:	89 c7                	mov    %eax,%edi
  800a4f:	fc                   	cld    
  800a50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a52:	eb 05                	jmp    800a59 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a54:	89 c7                	mov    %eax,%edi
  800a56:	fc                   	cld    
  800a57:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a59:	5e                   	pop    %esi
  800a5a:	5f                   	pop    %edi
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a63:	ff 75 10             	pushl  0x10(%ebp)
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	ff 75 08             	pushl  0x8(%ebp)
  800a6c:	e8 8a ff ff ff       	call   8009fb <memmove>
}
  800a71:	c9                   	leave  
  800a72:	c3                   	ret    

00800a73 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7e:	89 c6                	mov    %eax,%esi
  800a80:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a83:	39 f0                	cmp    %esi,%eax
  800a85:	74 1c                	je     800aa3 <memcmp+0x30>
		if (*s1 != *s2)
  800a87:	0f b6 08             	movzbl (%eax),%ecx
  800a8a:	0f b6 1a             	movzbl (%edx),%ebx
  800a8d:	38 d9                	cmp    %bl,%cl
  800a8f:	75 08                	jne    800a99 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a91:	83 c0 01             	add    $0x1,%eax
  800a94:	83 c2 01             	add    $0x1,%edx
  800a97:	eb ea                	jmp    800a83 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a99:	0f b6 c1             	movzbl %cl,%eax
  800a9c:	0f b6 db             	movzbl %bl,%ebx
  800a9f:	29 d8                	sub    %ebx,%eax
  800aa1:	eb 05                	jmp    800aa8 <memcmp+0x35>
	}

	return 0;
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa8:	5b                   	pop    %ebx
  800aa9:	5e                   	pop    %esi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab5:	89 c2                	mov    %eax,%edx
  800ab7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aba:	39 d0                	cmp    %edx,%eax
  800abc:	73 09                	jae    800ac7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800abe:	38 08                	cmp    %cl,(%eax)
  800ac0:	74 05                	je     800ac7 <memfind+0x1b>
	for (; s < ends; s++)
  800ac2:	83 c0 01             	add    $0x1,%eax
  800ac5:	eb f3                	jmp    800aba <memfind+0xe>
			break;
	return (void *) s;
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	57                   	push   %edi
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ad5:	eb 03                	jmp    800ada <strtol+0x11>
		s++;
  800ad7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ada:	0f b6 01             	movzbl (%ecx),%eax
  800add:	3c 20                	cmp    $0x20,%al
  800adf:	74 f6                	je     800ad7 <strtol+0xe>
  800ae1:	3c 09                	cmp    $0x9,%al
  800ae3:	74 f2                	je     800ad7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ae5:	3c 2b                	cmp    $0x2b,%al
  800ae7:	74 2a                	je     800b13 <strtol+0x4a>
	int neg = 0;
  800ae9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aee:	3c 2d                	cmp    $0x2d,%al
  800af0:	74 2b                	je     800b1d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800af8:	75 0f                	jne    800b09 <strtol+0x40>
  800afa:	80 39 30             	cmpb   $0x30,(%ecx)
  800afd:	74 28                	je     800b27 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aff:	85 db                	test   %ebx,%ebx
  800b01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b06:	0f 44 d8             	cmove  %eax,%ebx
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b11:	eb 50                	jmp    800b63 <strtol+0x9a>
		s++;
  800b13:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b16:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1b:	eb d5                	jmp    800af2 <strtol+0x29>
		s++, neg = 1;
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	bf 01 00 00 00       	mov    $0x1,%edi
  800b25:	eb cb                	jmp    800af2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b27:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b2b:	74 0e                	je     800b3b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b2d:	85 db                	test   %ebx,%ebx
  800b2f:	75 d8                	jne    800b09 <strtol+0x40>
		s++, base = 8;
  800b31:	83 c1 01             	add    $0x1,%ecx
  800b34:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b39:	eb ce                	jmp    800b09 <strtol+0x40>
		s += 2, base = 16;
  800b3b:	83 c1 02             	add    $0x2,%ecx
  800b3e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b43:	eb c4                	jmp    800b09 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b45:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b48:	89 f3                	mov    %esi,%ebx
  800b4a:	80 fb 19             	cmp    $0x19,%bl
  800b4d:	77 29                	ja     800b78 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b4f:	0f be d2             	movsbl %dl,%edx
  800b52:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b55:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b58:	7d 30                	jge    800b8a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b5a:	83 c1 01             	add    $0x1,%ecx
  800b5d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b61:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b63:	0f b6 11             	movzbl (%ecx),%edx
  800b66:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b69:	89 f3                	mov    %esi,%ebx
  800b6b:	80 fb 09             	cmp    $0x9,%bl
  800b6e:	77 d5                	ja     800b45 <strtol+0x7c>
			dig = *s - '0';
  800b70:	0f be d2             	movsbl %dl,%edx
  800b73:	83 ea 30             	sub    $0x30,%edx
  800b76:	eb dd                	jmp    800b55 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b78:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b7b:	89 f3                	mov    %esi,%ebx
  800b7d:	80 fb 19             	cmp    $0x19,%bl
  800b80:	77 08                	ja     800b8a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b82:	0f be d2             	movsbl %dl,%edx
  800b85:	83 ea 37             	sub    $0x37,%edx
  800b88:	eb cb                	jmp    800b55 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8e:	74 05                	je     800b95 <strtol+0xcc>
		*endptr = (char *) s;
  800b90:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b93:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	f7 da                	neg    %edx
  800b99:	85 ff                	test   %edi,%edi
  800b9b:	0f 45 c2             	cmovne %edx,%eax
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bae:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb4:	89 c3                	mov    %eax,%ebx
  800bb6:	89 c7                	mov    %eax,%edi
  800bb8:	89 c6                	mov    %eax,%esi
  800bba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5f                   	pop    %edi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	57                   	push   %edi
  800bc5:	56                   	push   %esi
  800bc6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcc:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd1:	89 d1                	mov    %edx,%ecx
  800bd3:	89 d3                	mov    %edx,%ebx
  800bd5:	89 d7                	mov    %edx,%edi
  800bd7:	89 d6                	mov    %edx,%esi
  800bd9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bdb:	5b                   	pop    %ebx
  800bdc:	5e                   	pop    %esi
  800bdd:	5f                   	pop    %edi
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	57                   	push   %edi
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
  800be6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf6:	89 cb                	mov    %ecx,%ebx
  800bf8:	89 cf                	mov    %ecx,%edi
  800bfa:	89 ce                	mov    %ecx,%esi
  800bfc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfe:	85 c0                	test   %eax,%eax
  800c00:	7f 08                	jg     800c0a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5f                   	pop    %edi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	50                   	push   %eax
  800c0e:	6a 03                	push   $0x3
  800c10:	68 40 15 80 00       	push   $0x801540
  800c15:	6a 33                	push   $0x33
  800c17:	68 5d 15 80 00       	push   $0x80155d
  800c1c:	e8 b1 02 00 00       	call   800ed2 <_panic>

00800c21 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c27:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2c:	b8 02 00 00 00       	mov    $0x2,%eax
  800c31:	89 d1                	mov    %edx,%ecx
  800c33:	89 d3                	mov    %edx,%ebx
  800c35:	89 d7                	mov    %edx,%edi
  800c37:	89 d6                	mov    %edx,%esi
  800c39:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_yield>:

void
sys_yield(void)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c46:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c50:	89 d1                	mov    %edx,%ecx
  800c52:	89 d3                	mov    %edx,%ebx
  800c54:	89 d7                	mov    %edx,%edi
  800c56:	89 d6                	mov    %edx,%esi
  800c58:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	57                   	push   %edi
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
  800c65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c68:	be 00 00 00 00       	mov    $0x0,%esi
  800c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c73:	b8 04 00 00 00       	mov    $0x4,%eax
  800c78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c7b:	89 f7                	mov    %esi,%edi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 04                	push   $0x4
  800c91:	68 40 15 80 00       	push   $0x801540
  800c96:	6a 33                	push   $0x33
  800c98:	68 5d 15 80 00       	push   $0x80155d
  800c9d:	e8 30 02 00 00       	call   800ed2 <_panic>

00800ca2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	b8 05 00 00 00       	mov    $0x5,%eax
  800cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cbc:	8b 75 18             	mov    0x18(%ebp),%esi
  800cbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7f 08                	jg     800ccd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccd:	83 ec 0c             	sub    $0xc,%esp
  800cd0:	50                   	push   %eax
  800cd1:	6a 05                	push   $0x5
  800cd3:	68 40 15 80 00       	push   $0x801540
  800cd8:	6a 33                	push   $0x33
  800cda:	68 5d 15 80 00       	push   $0x80155d
  800cdf:	e8 ee 01 00 00       	call   800ed2 <_panic>

00800ce4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	b8 06 00 00 00       	mov    $0x6,%eax
  800cfd:	89 df                	mov    %ebx,%edi
  800cff:	89 de                	mov    %ebx,%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 06                	push   $0x6
  800d15:	68 40 15 80 00       	push   $0x801540
  800d1a:	6a 33                	push   $0x33
  800d1c:	68 5d 15 80 00       	push   $0x80155d
  800d21:	e8 ac 01 00 00       	call   800ed2 <_panic>

00800d26 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d3c:	89 cb                	mov    %ecx,%ebx
  800d3e:	89 cf                	mov    %ecx,%edi
  800d40:	89 ce                	mov    %ecx,%esi
  800d42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d44:	85 c0                	test   %eax,%eax
  800d46:	7f 08                	jg     800d50 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d50:	83 ec 0c             	sub    $0xc,%esp
  800d53:	50                   	push   %eax
  800d54:	6a 0b                	push   $0xb
  800d56:	68 40 15 80 00       	push   $0x801540
  800d5b:	6a 33                	push   $0x33
  800d5d:	68 5d 15 80 00       	push   $0x80155d
  800d62:	e8 6b 01 00 00       	call   800ed2 <_panic>

00800d67 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d80:	89 df                	mov    %ebx,%edi
  800d82:	89 de                	mov    %ebx,%esi
  800d84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d86:	85 c0                	test   %eax,%eax
  800d88:	7f 08                	jg     800d92 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8d:	5b                   	pop    %ebx
  800d8e:	5e                   	pop    %esi
  800d8f:	5f                   	pop    %edi
  800d90:	5d                   	pop    %ebp
  800d91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d92:	83 ec 0c             	sub    $0xc,%esp
  800d95:	50                   	push   %eax
  800d96:	6a 08                	push   $0x8
  800d98:	68 40 15 80 00       	push   $0x801540
  800d9d:	6a 33                	push   $0x33
  800d9f:	68 5d 15 80 00       	push   $0x80155d
  800da4:	e8 29 01 00 00       	call   800ed2 <_panic>

00800da9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbd:	b8 09 00 00 00       	mov    $0x9,%eax
  800dc2:	89 df                	mov    %ebx,%edi
  800dc4:	89 de                	mov    %ebx,%esi
  800dc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7f 08                	jg     800dd4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800dd8:	6a 09                	push   $0x9
  800dda:	68 40 15 80 00       	push   $0x801540
  800ddf:	6a 33                	push   $0x33
  800de1:	68 5d 15 80 00       	push   $0x80155d
  800de6:	e8 e7 00 00 00       	call   800ed2 <_panic>

00800deb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
  800df1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e04:	89 df                	mov    %ebx,%edi
  800e06:	89 de                	mov    %ebx,%esi
  800e08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	7f 08                	jg     800e16 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e11:	5b                   	pop    %ebx
  800e12:	5e                   	pop    %esi
  800e13:	5f                   	pop    %edi
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e16:	83 ec 0c             	sub    $0xc,%esp
  800e19:	50                   	push   %eax
  800e1a:	6a 0a                	push   $0xa
  800e1c:	68 40 15 80 00       	push   $0x801540
  800e21:	6a 33                	push   $0x33
  800e23:	68 5d 15 80 00       	push   $0x80155d
  800e28:	e8 a5 00 00 00       	call   800ed2 <_panic>

00800e2d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	57                   	push   %edi
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e33:	8b 55 08             	mov    0x8(%ebp),%edx
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3e:	be 00 00 00 00       	mov    $0x0,%esi
  800e43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e46:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e49:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e66:	89 cb                	mov    %ecx,%ebx
  800e68:	89 cf                	mov    %ecx,%edi
  800e6a:	89 ce                	mov    %ecx,%esi
  800e6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7f 08                	jg     800e7a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	50                   	push   %eax
  800e7e:	6a 0e                	push   $0xe
  800e80:	68 40 15 80 00       	push   $0x801540
  800e85:	6a 33                	push   $0x33
  800e87:	68 5d 15 80 00       	push   $0x80155d
  800e8c:	e8 41 00 00 00       	call   800ed2 <_panic>

00800e91 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ea7:	89 df                	mov    %ebx,%edi
  800ea9:	89 de                	mov    %ebx,%esi
  800eab:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec0:	b8 10 00 00 00       	mov    $0x10,%eax
  800ec5:	89 cb                	mov    %ecx,%ebx
  800ec7:	89 cf                	mov    %ecx,%edi
  800ec9:	89 ce                	mov    %ecx,%esi
  800ecb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ecd:	5b                   	pop    %ebx
  800ece:	5e                   	pop    %esi
  800ecf:	5f                   	pop    %edi
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800ed7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800eda:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ee0:	e8 3c fd ff ff       	call   800c21 <sys_getenvid>
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	ff 75 08             	pushl  0x8(%ebp)
  800eee:	56                   	push   %esi
  800eef:	50                   	push   %eax
  800ef0:	68 6c 15 80 00       	push   $0x80156c
  800ef5:	e8 65 f2 ff ff       	call   80015f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800efa:	83 c4 18             	add    $0x18,%esp
  800efd:	53                   	push   %ebx
  800efe:	ff 75 10             	pushl  0x10(%ebp)
  800f01:	e8 08 f2 ff ff       	call   80010e <vcprintf>
	cprintf("\n");
  800f06:	c7 04 24 8c 11 80 00 	movl   $0x80118c,(%esp)
  800f0d:	e8 4d f2 ff ff       	call   80015f <cprintf>
  800f12:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f15:	cc                   	int3   
  800f16:	eb fd                	jmp    800f15 <_panic+0x43>
  800f18:	66 90                	xchg   %ax,%ax
  800f1a:	66 90                	xchg   %ax,%ax
  800f1c:	66 90                	xchg   %ax,%ax
  800f1e:	66 90                	xchg   %ax,%ax

00800f20 <__udivdi3>:
  800f20:	55                   	push   %ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 1c             	sub    $0x1c,%esp
  800f27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f37:	85 d2                	test   %edx,%edx
  800f39:	75 4d                	jne    800f88 <__udivdi3+0x68>
  800f3b:	39 f3                	cmp    %esi,%ebx
  800f3d:	76 19                	jbe    800f58 <__udivdi3+0x38>
  800f3f:	31 ff                	xor    %edi,%edi
  800f41:	89 e8                	mov    %ebp,%eax
  800f43:	89 f2                	mov    %esi,%edx
  800f45:	f7 f3                	div    %ebx
  800f47:	89 fa                	mov    %edi,%edx
  800f49:	83 c4 1c             	add    $0x1c,%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    
  800f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f58:	89 d9                	mov    %ebx,%ecx
  800f5a:	85 db                	test   %ebx,%ebx
  800f5c:	75 0b                	jne    800f69 <__udivdi3+0x49>
  800f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f63:	31 d2                	xor    %edx,%edx
  800f65:	f7 f3                	div    %ebx
  800f67:	89 c1                	mov    %eax,%ecx
  800f69:	31 d2                	xor    %edx,%edx
  800f6b:	89 f0                	mov    %esi,%eax
  800f6d:	f7 f1                	div    %ecx
  800f6f:	89 c6                	mov    %eax,%esi
  800f71:	89 e8                	mov    %ebp,%eax
  800f73:	89 f7                	mov    %esi,%edi
  800f75:	f7 f1                	div    %ecx
  800f77:	89 fa                	mov    %edi,%edx
  800f79:	83 c4 1c             	add    $0x1c,%esp
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    
  800f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f88:	39 f2                	cmp    %esi,%edx
  800f8a:	77 1c                	ja     800fa8 <__udivdi3+0x88>
  800f8c:	0f bd fa             	bsr    %edx,%edi
  800f8f:	83 f7 1f             	xor    $0x1f,%edi
  800f92:	75 2c                	jne    800fc0 <__udivdi3+0xa0>
  800f94:	39 f2                	cmp    %esi,%edx
  800f96:	72 06                	jb     800f9e <__udivdi3+0x7e>
  800f98:	31 c0                	xor    %eax,%eax
  800f9a:	39 eb                	cmp    %ebp,%ebx
  800f9c:	77 a9                	ja     800f47 <__udivdi3+0x27>
  800f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800fa3:	eb a2                	jmp    800f47 <__udivdi3+0x27>
  800fa5:	8d 76 00             	lea    0x0(%esi),%esi
  800fa8:	31 ff                	xor    %edi,%edi
  800faa:	31 c0                	xor    %eax,%eax
  800fac:	89 fa                	mov    %edi,%edx
  800fae:	83 c4 1c             	add    $0x1c,%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    
  800fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fbd:	8d 76 00             	lea    0x0(%esi),%esi
  800fc0:	89 f9                	mov    %edi,%ecx
  800fc2:	b8 20 00 00 00       	mov    $0x20,%eax
  800fc7:	29 f8                	sub    %edi,%eax
  800fc9:	d3 e2                	shl    %cl,%edx
  800fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fcf:	89 c1                	mov    %eax,%ecx
  800fd1:	89 da                	mov    %ebx,%edx
  800fd3:	d3 ea                	shr    %cl,%edx
  800fd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fd9:	09 d1                	or     %edx,%ecx
  800fdb:	89 f2                	mov    %esi,%edx
  800fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fe1:	89 f9                	mov    %edi,%ecx
  800fe3:	d3 e3                	shl    %cl,%ebx
  800fe5:	89 c1                	mov    %eax,%ecx
  800fe7:	d3 ea                	shr    %cl,%edx
  800fe9:	89 f9                	mov    %edi,%ecx
  800feb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fef:	89 eb                	mov    %ebp,%ebx
  800ff1:	d3 e6                	shl    %cl,%esi
  800ff3:	89 c1                	mov    %eax,%ecx
  800ff5:	d3 eb                	shr    %cl,%ebx
  800ff7:	09 de                	or     %ebx,%esi
  800ff9:	89 f0                	mov    %esi,%eax
  800ffb:	f7 74 24 08          	divl   0x8(%esp)
  800fff:	89 d6                	mov    %edx,%esi
  801001:	89 c3                	mov    %eax,%ebx
  801003:	f7 64 24 0c          	mull   0xc(%esp)
  801007:	39 d6                	cmp    %edx,%esi
  801009:	72 15                	jb     801020 <__udivdi3+0x100>
  80100b:	89 f9                	mov    %edi,%ecx
  80100d:	d3 e5                	shl    %cl,%ebp
  80100f:	39 c5                	cmp    %eax,%ebp
  801011:	73 04                	jae    801017 <__udivdi3+0xf7>
  801013:	39 d6                	cmp    %edx,%esi
  801015:	74 09                	je     801020 <__udivdi3+0x100>
  801017:	89 d8                	mov    %ebx,%eax
  801019:	31 ff                	xor    %edi,%edi
  80101b:	e9 27 ff ff ff       	jmp    800f47 <__udivdi3+0x27>
  801020:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801023:	31 ff                	xor    %edi,%edi
  801025:	e9 1d ff ff ff       	jmp    800f47 <__udivdi3+0x27>
  80102a:	66 90                	xchg   %ax,%ax
  80102c:	66 90                	xchg   %ax,%ax
  80102e:	66 90                	xchg   %ax,%ax

00801030 <__umoddi3>:
  801030:	55                   	push   %ebp
  801031:	57                   	push   %edi
  801032:	56                   	push   %esi
  801033:	53                   	push   %ebx
  801034:	83 ec 1c             	sub    $0x1c,%esp
  801037:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80103b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80103f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801043:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801047:	89 da                	mov    %ebx,%edx
  801049:	85 c0                	test   %eax,%eax
  80104b:	75 43                	jne    801090 <__umoddi3+0x60>
  80104d:	39 df                	cmp    %ebx,%edi
  80104f:	76 17                	jbe    801068 <__umoddi3+0x38>
  801051:	89 f0                	mov    %esi,%eax
  801053:	f7 f7                	div    %edi
  801055:	89 d0                	mov    %edx,%eax
  801057:	31 d2                	xor    %edx,%edx
  801059:	83 c4 1c             	add    $0x1c,%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
  801061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801068:	89 fd                	mov    %edi,%ebp
  80106a:	85 ff                	test   %edi,%edi
  80106c:	75 0b                	jne    801079 <__umoddi3+0x49>
  80106e:	b8 01 00 00 00       	mov    $0x1,%eax
  801073:	31 d2                	xor    %edx,%edx
  801075:	f7 f7                	div    %edi
  801077:	89 c5                	mov    %eax,%ebp
  801079:	89 d8                	mov    %ebx,%eax
  80107b:	31 d2                	xor    %edx,%edx
  80107d:	f7 f5                	div    %ebp
  80107f:	89 f0                	mov    %esi,%eax
  801081:	f7 f5                	div    %ebp
  801083:	89 d0                	mov    %edx,%eax
  801085:	eb d0                	jmp    801057 <__umoddi3+0x27>
  801087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80108e:	66 90                	xchg   %ax,%ax
  801090:	89 f1                	mov    %esi,%ecx
  801092:	39 d8                	cmp    %ebx,%eax
  801094:	76 0a                	jbe    8010a0 <__umoddi3+0x70>
  801096:	89 f0                	mov    %esi,%eax
  801098:	83 c4 1c             	add    $0x1c,%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    
  8010a0:	0f bd e8             	bsr    %eax,%ebp
  8010a3:	83 f5 1f             	xor    $0x1f,%ebp
  8010a6:	75 20                	jne    8010c8 <__umoddi3+0x98>
  8010a8:	39 d8                	cmp    %ebx,%eax
  8010aa:	0f 82 b0 00 00 00    	jb     801160 <__umoddi3+0x130>
  8010b0:	39 f7                	cmp    %esi,%edi
  8010b2:	0f 86 a8 00 00 00    	jbe    801160 <__umoddi3+0x130>
  8010b8:	89 c8                	mov    %ecx,%eax
  8010ba:	83 c4 1c             	add    $0x1c,%esp
  8010bd:	5b                   	pop    %ebx
  8010be:	5e                   	pop    %esi
  8010bf:	5f                   	pop    %edi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    
  8010c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010c8:	89 e9                	mov    %ebp,%ecx
  8010ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8010cf:	29 ea                	sub    %ebp,%edx
  8010d1:	d3 e0                	shl    %cl,%eax
  8010d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010d7:	89 d1                	mov    %edx,%ecx
  8010d9:	89 f8                	mov    %edi,%eax
  8010db:	d3 e8                	shr    %cl,%eax
  8010dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010e9:	09 c1                	or     %eax,%ecx
  8010eb:	89 d8                	mov    %ebx,%eax
  8010ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010f1:	89 e9                	mov    %ebp,%ecx
  8010f3:	d3 e7                	shl    %cl,%edi
  8010f5:	89 d1                	mov    %edx,%ecx
  8010f7:	d3 e8                	shr    %cl,%eax
  8010f9:	89 e9                	mov    %ebp,%ecx
  8010fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010ff:	d3 e3                	shl    %cl,%ebx
  801101:	89 c7                	mov    %eax,%edi
  801103:	89 d1                	mov    %edx,%ecx
  801105:	89 f0                	mov    %esi,%eax
  801107:	d3 e8                	shr    %cl,%eax
  801109:	89 e9                	mov    %ebp,%ecx
  80110b:	89 fa                	mov    %edi,%edx
  80110d:	d3 e6                	shl    %cl,%esi
  80110f:	09 d8                	or     %ebx,%eax
  801111:	f7 74 24 08          	divl   0x8(%esp)
  801115:	89 d1                	mov    %edx,%ecx
  801117:	89 f3                	mov    %esi,%ebx
  801119:	f7 64 24 0c          	mull   0xc(%esp)
  80111d:	89 c6                	mov    %eax,%esi
  80111f:	89 d7                	mov    %edx,%edi
  801121:	39 d1                	cmp    %edx,%ecx
  801123:	72 06                	jb     80112b <__umoddi3+0xfb>
  801125:	75 10                	jne    801137 <__umoddi3+0x107>
  801127:	39 c3                	cmp    %eax,%ebx
  801129:	73 0c                	jae    801137 <__umoddi3+0x107>
  80112b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80112f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801133:	89 d7                	mov    %edx,%edi
  801135:	89 c6                	mov    %eax,%esi
  801137:	89 ca                	mov    %ecx,%edx
  801139:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80113e:	29 f3                	sub    %esi,%ebx
  801140:	19 fa                	sbb    %edi,%edx
  801142:	89 d0                	mov    %edx,%eax
  801144:	d3 e0                	shl    %cl,%eax
  801146:	89 e9                	mov    %ebp,%ecx
  801148:	d3 eb                	shr    %cl,%ebx
  80114a:	d3 ea                	shr    %cl,%edx
  80114c:	09 d8                	or     %ebx,%eax
  80114e:	83 c4 1c             	add    $0x1c,%esp
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    
  801156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80115d:	8d 76 00             	lea    0x0(%esi),%esi
  801160:	89 da                	mov    %ebx,%edx
  801162:	29 fe                	sub    %edi,%esi
  801164:	19 c2                	sbb    %eax,%edx
  801166:	89 f1                	mov    %esi,%ecx
  801168:	89 c8                	mov    %ecx,%eax
  80116a:	e9 4b ff ff ff       	jmp    8010ba <__umoddi3+0x8a>
