
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
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
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 80 15 80 00       	push   $0x801580
  80003f:	e8 61 01 00 00       	call   8001a5 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 d3 0f 00 00       	call   80101c <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 f8 15 80 00       	push   $0x8015f8
  800058:	e8 48 01 00 00       	call   8001a5 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 a8 15 80 00       	push   $0x8015a8
  80006c:	e8 34 01 00 00       	call   8001a5 <cprintf>
	sys_yield();
  800071:	e8 10 0c 00 00       	call   800c86 <sys_yield>
	sys_yield();
  800076:	e8 0b 0c 00 00       	call   800c86 <sys_yield>
	sys_yield();
  80007b:	e8 06 0c 00 00       	call   800c86 <sys_yield>
	sys_yield();
  800080:	e8 01 0c 00 00       	call   800c86 <sys_yield>
	sys_yield();
  800085:	e8 fc 0b 00 00       	call   800c86 <sys_yield>
	sys_yield();
  80008a:	e8 f7 0b 00 00       	call   800c86 <sys_yield>
	sys_yield();
  80008f:	e8 f2 0b 00 00       	call   800c86 <sys_yield>
	sys_yield();
  800094:	e8 ed 0b 00 00       	call   800c86 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 d0 15 80 00 	movl   $0x8015d0,(%esp)
  8000a0:	e8 00 01 00 00       	call   8001a5 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 79 0b 00 00       	call   800c26 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 a2 0b 00 00       	call   800c67 <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000cd:	c1 e0 04             	shl    $0x4,%eax
  8000d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d5:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000da:	85 db                	test   %ebx,%ebx
  8000dc:	7e 07                	jle    8000e5 <libmain+0x30>
		binaryname = argv[0];
  8000de:	8b 06                	mov    (%esi),%eax
  8000e0:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000e5:	83 ec 08             	sub    $0x8,%esp
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	e8 44 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ef:	e8 0a 00 00 00       	call   8000fe <exit>
}
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5d                   	pop    %ebp
  8000fd:	c3                   	ret    

008000fe <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800104:	6a 00                	push   $0x0
  800106:	e8 1b 0b 00 00       	call   800c26 <sys_env_destroy>
}
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	c9                   	leave  
  80010f:	c3                   	ret    

00800110 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	53                   	push   %ebx
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011a:	8b 13                	mov    (%ebx),%edx
  80011c:	8d 42 01             	lea    0x1(%edx),%eax
  80011f:	89 03                	mov    %eax,(%ebx)
  800121:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800124:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800128:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012d:	74 09                	je     800138 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80012f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800136:	c9                   	leave  
  800137:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	68 ff 00 00 00       	push   $0xff
  800140:	8d 43 08             	lea    0x8(%ebx),%eax
  800143:	50                   	push   %eax
  800144:	e8 a0 0a 00 00       	call   800be9 <sys_cputs>
		b->idx = 0;
  800149:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	eb db                	jmp    80012f <putch+0x1f>

00800154 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80015d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800164:	00 00 00 
	b.cnt = 0;
  800167:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800171:	ff 75 0c             	pushl  0xc(%ebp)
  800174:	ff 75 08             	pushl  0x8(%ebp)
  800177:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017d:	50                   	push   %eax
  80017e:	68 10 01 80 00       	push   $0x800110
  800183:	e8 4a 01 00 00       	call   8002d2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800188:	83 c4 08             	add    $0x8,%esp
  80018b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800191:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800197:	50                   	push   %eax
  800198:	e8 4c 0a 00 00       	call   800be9 <sys_cputs>

	return b.cnt;
}
  80019d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ab:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ae:	50                   	push   %eax
  8001af:	ff 75 08             	pushl  0x8(%ebp)
  8001b2:	e8 9d ff ff ff       	call   800154 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	57                   	push   %edi
  8001bd:	56                   	push   %esi
  8001be:	53                   	push   %ebx
  8001bf:	83 ec 1c             	sub    $0x1c,%esp
  8001c2:	89 c6                	mov    %eax,%esi
  8001c4:	89 d7                	mov    %edx,%edi
  8001c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001d8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001dc:	74 2c                	je     80020a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001eb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001f3:	73 43                	jae    800238 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001f5:	83 eb 01             	sub    $0x1,%ebx
  8001f8:	85 db                	test   %ebx,%ebx
  8001fa:	7e 6c                	jle    800268 <printnum+0xaf>
			putch(padc, putdat);
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	57                   	push   %edi
  800200:	ff 75 18             	pushl  0x18(%ebp)
  800203:	ff d6                	call   *%esi
  800205:	83 c4 10             	add    $0x10,%esp
  800208:	eb eb                	jmp    8001f5 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	6a 20                	push   $0x20
  80020f:	6a 00                	push   $0x0
  800211:	50                   	push   %eax
  800212:	ff 75 e4             	pushl  -0x1c(%ebp)
  800215:	ff 75 e0             	pushl  -0x20(%ebp)
  800218:	89 fa                	mov    %edi,%edx
  80021a:	89 f0                	mov    %esi,%eax
  80021c:	e8 98 ff ff ff       	call   8001b9 <printnum>
		while (--width > 0)
  800221:	83 c4 20             	add    $0x20,%esp
  800224:	83 eb 01             	sub    $0x1,%ebx
  800227:	85 db                	test   %ebx,%ebx
  800229:	7e 65                	jle    800290 <printnum+0xd7>
			putch(padc, putdat);
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	57                   	push   %edi
  80022f:	6a 20                	push   $0x20
  800231:	ff d6                	call   *%esi
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	eb ec                	jmp    800224 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 18             	pushl  0x18(%ebp)
  80023e:	83 eb 01             	sub    $0x1,%ebx
  800241:	53                   	push   %ebx
  800242:	50                   	push   %eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	ff 75 dc             	pushl  -0x24(%ebp)
  800249:	ff 75 d8             	pushl  -0x28(%ebp)
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	ff 75 e0             	pushl  -0x20(%ebp)
  800252:	e8 c9 10 00 00       	call   801320 <__udivdi3>
  800257:	83 c4 18             	add    $0x18,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	89 fa                	mov    %edi,%edx
  80025e:	89 f0                	mov    %esi,%eax
  800260:	e8 54 ff ff ff       	call   8001b9 <printnum>
  800265:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800268:	83 ec 08             	sub    $0x8,%esp
  80026b:	57                   	push   %edi
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	ff 75 dc             	pushl  -0x24(%ebp)
  800272:	ff 75 d8             	pushl  -0x28(%ebp)
  800275:	ff 75 e4             	pushl  -0x1c(%ebp)
  800278:	ff 75 e0             	pushl  -0x20(%ebp)
  80027b:	e8 b0 11 00 00       	call   801430 <__umoddi3>
  800280:	83 c4 14             	add    $0x14,%esp
  800283:	0f be 80 20 16 80 00 	movsbl 0x801620(%eax),%eax
  80028a:	50                   	push   %eax
  80028b:	ff d6                	call   *%esi
  80028d:	83 c4 10             	add    $0x10,%esp
}
  800290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800293:	5b                   	pop    %ebx
  800294:	5e                   	pop    %esi
  800295:	5f                   	pop    %edi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80029e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a2:	8b 10                	mov    (%eax),%edx
  8002a4:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a7:	73 0a                	jae    8002b3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ac:	89 08                	mov    %ecx,(%eax)
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	88 02                	mov    %al,(%edx)
}
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <printfmt>:
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002bb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002be:	50                   	push   %eax
  8002bf:	ff 75 10             	pushl  0x10(%ebp)
  8002c2:	ff 75 0c             	pushl  0xc(%ebp)
  8002c5:	ff 75 08             	pushl  0x8(%ebp)
  8002c8:	e8 05 00 00 00       	call   8002d2 <vprintfmt>
}
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <vprintfmt>:
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 3c             	sub    $0x3c,%esp
  8002db:	8b 75 08             	mov    0x8(%ebp),%esi
  8002de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e4:	e9 b4 03 00 00       	jmp    80069d <vprintfmt+0x3cb>
		padc = ' ';
  8002e9:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8002ed:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8002f4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002fb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800302:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800309:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8d 47 01             	lea    0x1(%edi),%eax
  800311:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800314:	0f b6 17             	movzbl (%edi),%edx
  800317:	8d 42 dd             	lea    -0x23(%edx),%eax
  80031a:	3c 55                	cmp    $0x55,%al
  80031c:	0f 87 c8 04 00 00    	ja     8007ea <vprintfmt+0x518>
  800322:	0f b6 c0             	movzbl %al,%eax
  800325:	ff 24 85 00 18 80 00 	jmp    *0x801800(,%eax,4)
  80032c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80032f:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800336:	eb d6                	jmp    80030e <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800338:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80033b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80033f:	eb cd                	jmp    80030e <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800341:	0f b6 d2             	movzbl %dl,%edx
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800347:	b8 00 00 00 00       	mov    $0x0,%eax
  80034c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80034f:	eb 0c                	jmp    80035d <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800351:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800354:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800358:	eb b4                	jmp    80030e <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80035a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800360:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800364:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800367:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80036a:	83 f9 09             	cmp    $0x9,%ecx
  80036d:	76 eb                	jbe    80035a <vprintfmt+0x88>
  80036f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800372:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800375:	eb 14                	jmp    80038b <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8d 40 04             	lea    0x4(%eax),%eax
  800385:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038f:	0f 89 79 ff ff ff    	jns    80030e <vprintfmt+0x3c>
				width = precision, precision = -1;
  800395:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800398:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a2:	e9 67 ff ff ff       	jmp    80030e <vprintfmt+0x3c>
  8003a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003aa:	85 c0                	test   %eax,%eax
  8003ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b1:	0f 49 d0             	cmovns %eax,%edx
  8003b4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ba:	e9 4f ff ff ff       	jmp    80030e <vprintfmt+0x3c>
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003c9:	e9 40 ff ff ff       	jmp    80030e <vprintfmt+0x3c>
			lflag++;
  8003ce:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d4:	e9 35 ff ff ff       	jmp    80030e <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8003d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dc:	8d 78 04             	lea    0x4(%eax),%edi
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	53                   	push   %ebx
  8003e3:	ff 30                	pushl  (%eax)
  8003e5:	ff d6                	call   *%esi
			break;
  8003e7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003ea:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ed:	e9 a8 02 00 00       	jmp    80069a <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8003f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f5:	8d 78 04             	lea    0x4(%eax),%edi
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	99                   	cltd   
  8003fb:	31 d0                	xor    %edx,%eax
  8003fd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ff:	83 f8 0f             	cmp    $0xf,%eax
  800402:	7f 23                	jg     800427 <vprintfmt+0x155>
  800404:	8b 14 85 60 19 80 00 	mov    0x801960(,%eax,4),%edx
  80040b:	85 d2                	test   %edx,%edx
  80040d:	74 18                	je     800427 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80040f:	52                   	push   %edx
  800410:	68 41 16 80 00       	push   $0x801641
  800415:	53                   	push   %ebx
  800416:	56                   	push   %esi
  800417:	e8 99 fe ff ff       	call   8002b5 <printfmt>
  80041c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800422:	e9 73 02 00 00       	jmp    80069a <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800427:	50                   	push   %eax
  800428:	68 38 16 80 00       	push   $0x801638
  80042d:	53                   	push   %ebx
  80042e:	56                   	push   %esi
  80042f:	e8 81 fe ff ff       	call   8002b5 <printfmt>
  800434:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800437:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043a:	e9 5b 02 00 00       	jmp    80069a <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	83 c0 04             	add    $0x4,%eax
  800445:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80044d:	85 d2                	test   %edx,%edx
  80044f:	b8 31 16 80 00       	mov    $0x801631,%eax
  800454:	0f 45 c2             	cmovne %edx,%eax
  800457:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80045a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045e:	7e 06                	jle    800466 <vprintfmt+0x194>
  800460:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800464:	75 0d                	jne    800473 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800466:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800469:	89 c7                	mov    %eax,%edi
  80046b:	03 45 e0             	add    -0x20(%ebp),%eax
  80046e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800471:	eb 53                	jmp    8004c6 <vprintfmt+0x1f4>
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	ff 75 d8             	pushl  -0x28(%ebp)
  800479:	50                   	push   %eax
  80047a:	e8 13 04 00 00       	call   800892 <strnlen>
  80047f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800482:	29 c1                	sub    %eax,%ecx
  800484:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80048c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800490:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800493:	eb 0f                	jmp    8004a4 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	53                   	push   %ebx
  800499:	ff 75 e0             	pushl  -0x20(%ebp)
  80049c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80049e:	83 ef 01             	sub    $0x1,%edi
  8004a1:	83 c4 10             	add    $0x10,%esp
  8004a4:	85 ff                	test   %edi,%edi
  8004a6:	7f ed                	jg     800495 <vprintfmt+0x1c3>
  8004a8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ab:	85 d2                	test   %edx,%edx
  8004ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b2:	0f 49 c2             	cmovns %edx,%eax
  8004b5:	29 c2                	sub    %eax,%edx
  8004b7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004ba:	eb aa                	jmp    800466 <vprintfmt+0x194>
					putch(ch, putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	53                   	push   %ebx
  8004c0:	52                   	push   %edx
  8004c1:	ff d6                	call   *%esi
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004cb:	83 c7 01             	add    $0x1,%edi
  8004ce:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004d2:	0f be d0             	movsbl %al,%edx
  8004d5:	85 d2                	test   %edx,%edx
  8004d7:	74 4b                	je     800524 <vprintfmt+0x252>
  8004d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004dd:	78 06                	js     8004e5 <vprintfmt+0x213>
  8004df:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004e3:	78 1e                	js     800503 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004e9:	74 d1                	je     8004bc <vprintfmt+0x1ea>
  8004eb:	0f be c0             	movsbl %al,%eax
  8004ee:	83 e8 20             	sub    $0x20,%eax
  8004f1:	83 f8 5e             	cmp    $0x5e,%eax
  8004f4:	76 c6                	jbe    8004bc <vprintfmt+0x1ea>
					putch('?', putdat);
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	53                   	push   %ebx
  8004fa:	6a 3f                	push   $0x3f
  8004fc:	ff d6                	call   *%esi
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	eb c3                	jmp    8004c6 <vprintfmt+0x1f4>
  800503:	89 cf                	mov    %ecx,%edi
  800505:	eb 0e                	jmp    800515 <vprintfmt+0x243>
				putch(' ', putdat);
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	53                   	push   %ebx
  80050b:	6a 20                	push   $0x20
  80050d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80050f:	83 ef 01             	sub    $0x1,%edi
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	85 ff                	test   %edi,%edi
  800517:	7f ee                	jg     800507 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800519:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80051c:	89 45 14             	mov    %eax,0x14(%ebp)
  80051f:	e9 76 01 00 00       	jmp    80069a <vprintfmt+0x3c8>
  800524:	89 cf                	mov    %ecx,%edi
  800526:	eb ed                	jmp    800515 <vprintfmt+0x243>
	if (lflag >= 2)
  800528:	83 f9 01             	cmp    $0x1,%ecx
  80052b:	7f 1f                	jg     80054c <vprintfmt+0x27a>
	else if (lflag)
  80052d:	85 c9                	test   %ecx,%ecx
  80052f:	74 6a                	je     80059b <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800539:	89 c1                	mov    %eax,%ecx
  80053b:	c1 f9 1f             	sar    $0x1f,%ecx
  80053e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 40 04             	lea    0x4(%eax),%eax
  800547:	89 45 14             	mov    %eax,0x14(%ebp)
  80054a:	eb 17                	jmp    800563 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8b 50 04             	mov    0x4(%eax),%edx
  800552:	8b 00                	mov    (%eax),%eax
  800554:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800557:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8d 40 08             	lea    0x8(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800563:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800566:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80056b:	85 d2                	test   %edx,%edx
  80056d:	0f 89 f8 00 00 00    	jns    80066b <vprintfmt+0x399>
				putch('-', putdat);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	53                   	push   %ebx
  800577:	6a 2d                	push   $0x2d
  800579:	ff d6                	call   *%esi
				num = -(long long) num;
  80057b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80057e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800581:	f7 d8                	neg    %eax
  800583:	83 d2 00             	adc    $0x0,%edx
  800586:	f7 da                	neg    %edx
  800588:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800591:	bf 0a 00 00 00       	mov    $0xa,%edi
  800596:	e9 e1 00 00 00       	jmp    80067c <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	99                   	cltd   
  8005a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 40 04             	lea    0x4(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b0:	eb b1                	jmp    800563 <vprintfmt+0x291>
	if (lflag >= 2)
  8005b2:	83 f9 01             	cmp    $0x1,%ecx
  8005b5:	7f 27                	jg     8005de <vprintfmt+0x30c>
	else if (lflag)
  8005b7:	85 c9                	test   %ecx,%ecx
  8005b9:	74 41                	je     8005fc <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8d 40 04             	lea    0x4(%eax),%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005d9:	e9 8d 00 00 00       	jmp    80066b <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 50 04             	mov    0x4(%eax),%edx
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8d 40 08             	lea    0x8(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005fa:	eb 6f                	jmp    80066b <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800609:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 40 04             	lea    0x4(%eax),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800615:	bf 0a 00 00 00       	mov    $0xa,%edi
  80061a:	eb 4f                	jmp    80066b <vprintfmt+0x399>
	if (lflag >= 2)
  80061c:	83 f9 01             	cmp    $0x1,%ecx
  80061f:	7f 23                	jg     800644 <vprintfmt+0x372>
	else if (lflag)
  800621:	85 c9                	test   %ecx,%ecx
  800623:	0f 84 98 00 00 00    	je     8006c1 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	ba 00 00 00 00       	mov    $0x0,%edx
  800633:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800636:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	eb 17                	jmp    80065b <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 50 04             	mov    0x4(%eax),%edx
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8d 40 08             	lea    0x8(%eax),%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 30                	push   $0x30
  800661:	ff d6                	call   *%esi
			goto number;
  800663:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800666:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  80066b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80066f:	74 0b                	je     80067c <vprintfmt+0x3aa>
				putch('+', putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	53                   	push   %ebx
  800675:	6a 2b                	push   $0x2b
  800677:	ff d6                	call   *%esi
  800679:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80067c:	83 ec 0c             	sub    $0xc,%esp
  80067f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800683:	50                   	push   %eax
  800684:	ff 75 e0             	pushl  -0x20(%ebp)
  800687:	57                   	push   %edi
  800688:	ff 75 dc             	pushl  -0x24(%ebp)
  80068b:	ff 75 d8             	pushl  -0x28(%ebp)
  80068e:	89 da                	mov    %ebx,%edx
  800690:	89 f0                	mov    %esi,%eax
  800692:	e8 22 fb ff ff       	call   8001b9 <printnum>
			break;
  800697:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80069a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80069d:	83 c7 01             	add    $0x1,%edi
  8006a0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a4:	83 f8 25             	cmp    $0x25,%eax
  8006a7:	0f 84 3c fc ff ff    	je     8002e9 <vprintfmt+0x17>
			if (ch == '\0')
  8006ad:	85 c0                	test   %eax,%eax
  8006af:	0f 84 55 01 00 00    	je     80080a <vprintfmt+0x538>
			putch(ch, putdat);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	53                   	push   %ebx
  8006b9:	50                   	push   %eax
  8006ba:	ff d6                	call   *%esi
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	eb dc                	jmp    80069d <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006da:	e9 7c ff ff ff       	jmp    80065b <vprintfmt+0x389>
			putch('0', putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	6a 30                	push   $0x30
  8006e5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006e7:	83 c4 08             	add    $0x8,%esp
  8006ea:	53                   	push   %ebx
  8006eb:	6a 78                	push   $0x78
  8006ed:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006ff:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070b:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800710:	e9 56 ff ff ff       	jmp    80066b <vprintfmt+0x399>
	if (lflag >= 2)
  800715:	83 f9 01             	cmp    $0x1,%ecx
  800718:	7f 27                	jg     800741 <vprintfmt+0x46f>
	else if (lflag)
  80071a:	85 c9                	test   %ecx,%ecx
  80071c:	74 44                	je     800762 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800737:	bf 10 00 00 00       	mov    $0x10,%edi
  80073c:	e9 2a ff ff ff       	jmp    80066b <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 50 04             	mov    0x4(%eax),%edx
  800747:	8b 00                	mov    (%eax),%eax
  800749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 08             	lea    0x8(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800758:	bf 10 00 00 00       	mov    $0x10,%edi
  80075d:	e9 09 ff ff ff       	jmp    80066b <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	ba 00 00 00 00       	mov    $0x0,%edx
  80076c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8d 40 04             	lea    0x4(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077b:	bf 10 00 00 00       	mov    $0x10,%edi
  800780:	e9 e6 fe ff ff       	jmp    80066b <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 78 04             	lea    0x4(%eax),%edi
  80078b:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  80078d:	85 c0                	test   %eax,%eax
  80078f:	74 2d                	je     8007be <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800791:	0f b6 13             	movzbl (%ebx),%edx
  800794:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800796:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800799:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80079c:	0f 8e f8 fe ff ff    	jle    80069a <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007a2:	68 90 17 80 00       	push   $0x801790
  8007a7:	68 41 16 80 00       	push   $0x801641
  8007ac:	53                   	push   %ebx
  8007ad:	56                   	push   %esi
  8007ae:	e8 02 fb ff ff       	call   8002b5 <printfmt>
  8007b3:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007b6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007b9:	e9 dc fe ff ff       	jmp    80069a <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8007be:	68 58 17 80 00       	push   $0x801758
  8007c3:	68 41 16 80 00       	push   $0x801641
  8007c8:	53                   	push   %ebx
  8007c9:	56                   	push   %esi
  8007ca:	e8 e6 fa ff ff       	call   8002b5 <printfmt>
  8007cf:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007d2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007d5:	e9 c0 fe ff ff       	jmp    80069a <vprintfmt+0x3c8>
			putch(ch, putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	53                   	push   %ebx
  8007de:	6a 25                	push   $0x25
  8007e0:	ff d6                	call   *%esi
			break;
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	e9 b0 fe ff ff       	jmp    80069a <vprintfmt+0x3c8>
			putch('%', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	53                   	push   %ebx
  8007ee:	6a 25                	push   $0x25
  8007f0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	89 f8                	mov    %edi,%eax
  8007f7:	eb 03                	jmp    8007fc <vprintfmt+0x52a>
  8007f9:	83 e8 01             	sub    $0x1,%eax
  8007fc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800800:	75 f7                	jne    8007f9 <vprintfmt+0x527>
  800802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800805:	e9 90 fe ff ff       	jmp    80069a <vprintfmt+0x3c8>
}
  80080a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80080d:	5b                   	pop    %ebx
  80080e:	5e                   	pop    %esi
  80080f:	5f                   	pop    %edi
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 18             	sub    $0x18,%esp
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80081e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800821:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800825:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 26                	je     800859 <vsnprintf+0x47>
  800833:	85 d2                	test   %edx,%edx
  800835:	7e 22                	jle    800859 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800837:	ff 75 14             	pushl  0x14(%ebp)
  80083a:	ff 75 10             	pushl  0x10(%ebp)
  80083d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800840:	50                   	push   %eax
  800841:	68 98 02 80 00       	push   $0x800298
  800846:	e8 87 fa ff ff       	call   8002d2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80084b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800854:	83 c4 10             	add    $0x10,%esp
}
  800857:	c9                   	leave  
  800858:	c3                   	ret    
		return -E_INVAL;
  800859:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085e:	eb f7                	jmp    800857 <vsnprintf+0x45>

00800860 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800866:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800869:	50                   	push   %eax
  80086a:	ff 75 10             	pushl  0x10(%ebp)
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 9a ff ff ff       	call   800812 <vsnprintf>
	va_end(ap);

	return rc;
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800880:	b8 00 00 00 00       	mov    $0x0,%eax
  800885:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800889:	74 05                	je     800890 <strlen+0x16>
		n++;
  80088b:	83 c0 01             	add    $0x1,%eax
  80088e:	eb f5                	jmp    800885 <strlen+0xb>
	return n;
}
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800898:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089b:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a0:	39 c2                	cmp    %eax,%edx
  8008a2:	74 0d                	je     8008b1 <strnlen+0x1f>
  8008a4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008a8:	74 05                	je     8008af <strnlen+0x1d>
		n++;
  8008aa:	83 c2 01             	add    $0x1,%edx
  8008ad:	eb f1                	jmp    8008a0 <strnlen+0xe>
  8008af:	89 d0                	mov    %edx,%eax
	return n;
}
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008c6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008c9:	83 c2 01             	add    $0x1,%edx
  8008cc:	84 c9                	test   %cl,%cl
  8008ce:	75 f2                	jne    8008c2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008d0:	5b                   	pop    %ebx
  8008d1:	5d                   	pop    %ebp
  8008d2:	c3                   	ret    

008008d3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	53                   	push   %ebx
  8008d7:	83 ec 10             	sub    $0x10,%esp
  8008da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008dd:	53                   	push   %ebx
  8008de:	e8 97 ff ff ff       	call   80087a <strlen>
  8008e3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	01 d8                	add    %ebx,%eax
  8008eb:	50                   	push   %eax
  8008ec:	e8 c2 ff ff ff       	call   8008b3 <strcpy>
	return dst;
}
  8008f1:	89 d8                	mov    %ebx,%eax
  8008f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	56                   	push   %esi
  8008fc:	53                   	push   %ebx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800903:	89 c6                	mov    %eax,%esi
  800905:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800908:	89 c2                	mov    %eax,%edx
  80090a:	39 f2                	cmp    %esi,%edx
  80090c:	74 11                	je     80091f <strncpy+0x27>
		*dst++ = *src;
  80090e:	83 c2 01             	add    $0x1,%edx
  800911:	0f b6 19             	movzbl (%ecx),%ebx
  800914:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800917:	80 fb 01             	cmp    $0x1,%bl
  80091a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80091d:	eb eb                	jmp    80090a <strncpy+0x12>
	}
	return ret;
}
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	8b 75 08             	mov    0x8(%ebp),%esi
  80092b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092e:	8b 55 10             	mov    0x10(%ebp),%edx
  800931:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800933:	85 d2                	test   %edx,%edx
  800935:	74 21                	je     800958 <strlcpy+0x35>
  800937:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80093b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	74 14                	je     800955 <strlcpy+0x32>
  800941:	0f b6 19             	movzbl (%ecx),%ebx
  800944:	84 db                	test   %bl,%bl
  800946:	74 0b                	je     800953 <strlcpy+0x30>
			*dst++ = *src++;
  800948:	83 c1 01             	add    $0x1,%ecx
  80094b:	83 c2 01             	add    $0x1,%edx
  80094e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800951:	eb ea                	jmp    80093d <strlcpy+0x1a>
  800953:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800955:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800958:	29 f0                	sub    %esi,%eax
}
  80095a:	5b                   	pop    %ebx
  80095b:	5e                   	pop    %esi
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800964:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800967:	0f b6 01             	movzbl (%ecx),%eax
  80096a:	84 c0                	test   %al,%al
  80096c:	74 0c                	je     80097a <strcmp+0x1c>
  80096e:	3a 02                	cmp    (%edx),%al
  800970:	75 08                	jne    80097a <strcmp+0x1c>
		p++, q++;
  800972:	83 c1 01             	add    $0x1,%ecx
  800975:	83 c2 01             	add    $0x1,%edx
  800978:	eb ed                	jmp    800967 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80097a:	0f b6 c0             	movzbl %al,%eax
  80097d:	0f b6 12             	movzbl (%edx),%edx
  800980:	29 d0                	sub    %edx,%eax
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	53                   	push   %ebx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098e:	89 c3                	mov    %eax,%ebx
  800990:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800993:	eb 06                	jmp    80099b <strncmp+0x17>
		n--, p++, q++;
  800995:	83 c0 01             	add    $0x1,%eax
  800998:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80099b:	39 d8                	cmp    %ebx,%eax
  80099d:	74 16                	je     8009b5 <strncmp+0x31>
  80099f:	0f b6 08             	movzbl (%eax),%ecx
  8009a2:	84 c9                	test   %cl,%cl
  8009a4:	74 04                	je     8009aa <strncmp+0x26>
  8009a6:	3a 0a                	cmp    (%edx),%cl
  8009a8:	74 eb                	je     800995 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009aa:	0f b6 00             	movzbl (%eax),%eax
  8009ad:	0f b6 12             	movzbl (%edx),%edx
  8009b0:	29 d0                	sub    %edx,%eax
}
  8009b2:	5b                   	pop    %ebx
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    
		return 0;
  8009b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ba:	eb f6                	jmp    8009b2 <strncmp+0x2e>

008009bc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c6:	0f b6 10             	movzbl (%eax),%edx
  8009c9:	84 d2                	test   %dl,%dl
  8009cb:	74 09                	je     8009d6 <strchr+0x1a>
		if (*s == c)
  8009cd:	38 ca                	cmp    %cl,%dl
  8009cf:	74 0a                	je     8009db <strchr+0x1f>
	for (; *s; s++)
  8009d1:	83 c0 01             	add    $0x1,%eax
  8009d4:	eb f0                	jmp    8009c6 <strchr+0xa>
			return (char *) s;
	return 0;
  8009d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ea:	38 ca                	cmp    %cl,%dl
  8009ec:	74 09                	je     8009f7 <strfind+0x1a>
  8009ee:	84 d2                	test   %dl,%dl
  8009f0:	74 05                	je     8009f7 <strfind+0x1a>
	for (; *s; s++)
  8009f2:	83 c0 01             	add    $0x1,%eax
  8009f5:	eb f0                	jmp    8009e7 <strfind+0xa>
			break;
	return (char *) s;
}
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	57                   	push   %edi
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a02:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a05:	85 c9                	test   %ecx,%ecx
  800a07:	74 31                	je     800a3a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a09:	89 f8                	mov    %edi,%eax
  800a0b:	09 c8                	or     %ecx,%eax
  800a0d:	a8 03                	test   $0x3,%al
  800a0f:	75 23                	jne    800a34 <memset+0x3b>
		c &= 0xFF;
  800a11:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a15:	89 d3                	mov    %edx,%ebx
  800a17:	c1 e3 08             	shl    $0x8,%ebx
  800a1a:	89 d0                	mov    %edx,%eax
  800a1c:	c1 e0 18             	shl    $0x18,%eax
  800a1f:	89 d6                	mov    %edx,%esi
  800a21:	c1 e6 10             	shl    $0x10,%esi
  800a24:	09 f0                	or     %esi,%eax
  800a26:	09 c2                	or     %eax,%edx
  800a28:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a2a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a2d:	89 d0                	mov    %edx,%eax
  800a2f:	fc                   	cld    
  800a30:	f3 ab                	rep stos %eax,%es:(%edi)
  800a32:	eb 06                	jmp    800a3a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	fc                   	cld    
  800a38:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3a:	89 f8                	mov    %edi,%eax
  800a3c:	5b                   	pop    %ebx
  800a3d:	5e                   	pop    %esi
  800a3e:	5f                   	pop    %edi
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	57                   	push   %edi
  800a45:	56                   	push   %esi
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a4f:	39 c6                	cmp    %eax,%esi
  800a51:	73 32                	jae    800a85 <memmove+0x44>
  800a53:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a56:	39 c2                	cmp    %eax,%edx
  800a58:	76 2b                	jbe    800a85 <memmove+0x44>
		s += n;
		d += n;
  800a5a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5d:	89 fe                	mov    %edi,%esi
  800a5f:	09 ce                	or     %ecx,%esi
  800a61:	09 d6                	or     %edx,%esi
  800a63:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a69:	75 0e                	jne    800a79 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a6b:	83 ef 04             	sub    $0x4,%edi
  800a6e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a71:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a74:	fd                   	std    
  800a75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a77:	eb 09                	jmp    800a82 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a79:	83 ef 01             	sub    $0x1,%edi
  800a7c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a7f:	fd                   	std    
  800a80:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a82:	fc                   	cld    
  800a83:	eb 1a                	jmp    800a9f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a85:	89 c2                	mov    %eax,%edx
  800a87:	09 ca                	or     %ecx,%edx
  800a89:	09 f2                	or     %esi,%edx
  800a8b:	f6 c2 03             	test   $0x3,%dl
  800a8e:	75 0a                	jne    800a9a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a90:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a93:	89 c7                	mov    %eax,%edi
  800a95:	fc                   	cld    
  800a96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a98:	eb 05                	jmp    800a9f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a9a:	89 c7                	mov    %eax,%edi
  800a9c:	fc                   	cld    
  800a9d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a9f:	5e                   	pop    %esi
  800aa0:	5f                   	pop    %edi
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa9:	ff 75 10             	pushl  0x10(%ebp)
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	ff 75 08             	pushl  0x8(%ebp)
  800ab2:	e8 8a ff ff ff       	call   800a41 <memmove>
}
  800ab7:	c9                   	leave  
  800ab8:	c3                   	ret    

00800ab9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	56                   	push   %esi
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac4:	89 c6                	mov    %eax,%esi
  800ac6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac9:	39 f0                	cmp    %esi,%eax
  800acb:	74 1c                	je     800ae9 <memcmp+0x30>
		if (*s1 != *s2)
  800acd:	0f b6 08             	movzbl (%eax),%ecx
  800ad0:	0f b6 1a             	movzbl (%edx),%ebx
  800ad3:	38 d9                	cmp    %bl,%cl
  800ad5:	75 08                	jne    800adf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ad7:	83 c0 01             	add    $0x1,%eax
  800ada:	83 c2 01             	add    $0x1,%edx
  800add:	eb ea                	jmp    800ac9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800adf:	0f b6 c1             	movzbl %cl,%eax
  800ae2:	0f b6 db             	movzbl %bl,%ebx
  800ae5:	29 d8                	sub    %ebx,%eax
  800ae7:	eb 05                	jmp    800aee <memcmp+0x35>
	}

	return 0;
  800ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aee:	5b                   	pop    %ebx
  800aef:	5e                   	pop    %esi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800afb:	89 c2                	mov    %eax,%edx
  800afd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b00:	39 d0                	cmp    %edx,%eax
  800b02:	73 09                	jae    800b0d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b04:	38 08                	cmp    %cl,(%eax)
  800b06:	74 05                	je     800b0d <memfind+0x1b>
	for (; s < ends; s++)
  800b08:	83 c0 01             	add    $0x1,%eax
  800b0b:	eb f3                	jmp    800b00 <memfind+0xe>
			break;
	return (void *) s;
}
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	57                   	push   %edi
  800b13:	56                   	push   %esi
  800b14:	53                   	push   %ebx
  800b15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b18:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1b:	eb 03                	jmp    800b20 <strtol+0x11>
		s++;
  800b1d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b20:	0f b6 01             	movzbl (%ecx),%eax
  800b23:	3c 20                	cmp    $0x20,%al
  800b25:	74 f6                	je     800b1d <strtol+0xe>
  800b27:	3c 09                	cmp    $0x9,%al
  800b29:	74 f2                	je     800b1d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b2b:	3c 2b                	cmp    $0x2b,%al
  800b2d:	74 2a                	je     800b59 <strtol+0x4a>
	int neg = 0;
  800b2f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b34:	3c 2d                	cmp    $0x2d,%al
  800b36:	74 2b                	je     800b63 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b38:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b3e:	75 0f                	jne    800b4f <strtol+0x40>
  800b40:	80 39 30             	cmpb   $0x30,(%ecx)
  800b43:	74 28                	je     800b6d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b45:	85 db                	test   %ebx,%ebx
  800b47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b4c:	0f 44 d8             	cmove  %eax,%ebx
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b54:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b57:	eb 50                	jmp    800ba9 <strtol+0x9a>
		s++;
  800b59:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b5c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b61:	eb d5                	jmp    800b38 <strtol+0x29>
		s++, neg = 1;
  800b63:	83 c1 01             	add    $0x1,%ecx
  800b66:	bf 01 00 00 00       	mov    $0x1,%edi
  800b6b:	eb cb                	jmp    800b38 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b71:	74 0e                	je     800b81 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b73:	85 db                	test   %ebx,%ebx
  800b75:	75 d8                	jne    800b4f <strtol+0x40>
		s++, base = 8;
  800b77:	83 c1 01             	add    $0x1,%ecx
  800b7a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b7f:	eb ce                	jmp    800b4f <strtol+0x40>
		s += 2, base = 16;
  800b81:	83 c1 02             	add    $0x2,%ecx
  800b84:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b89:	eb c4                	jmp    800b4f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b8b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8e:	89 f3                	mov    %esi,%ebx
  800b90:	80 fb 19             	cmp    $0x19,%bl
  800b93:	77 29                	ja     800bbe <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b95:	0f be d2             	movsbl %dl,%edx
  800b98:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b9b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b9e:	7d 30                	jge    800bd0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ba0:	83 c1 01             	add    $0x1,%ecx
  800ba3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ba7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ba9:	0f b6 11             	movzbl (%ecx),%edx
  800bac:	8d 72 d0             	lea    -0x30(%edx),%esi
  800baf:	89 f3                	mov    %esi,%ebx
  800bb1:	80 fb 09             	cmp    $0x9,%bl
  800bb4:	77 d5                	ja     800b8b <strtol+0x7c>
			dig = *s - '0';
  800bb6:	0f be d2             	movsbl %dl,%edx
  800bb9:	83 ea 30             	sub    $0x30,%edx
  800bbc:	eb dd                	jmp    800b9b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bbe:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bc1:	89 f3                	mov    %esi,%ebx
  800bc3:	80 fb 19             	cmp    $0x19,%bl
  800bc6:	77 08                	ja     800bd0 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bc8:	0f be d2             	movsbl %dl,%edx
  800bcb:	83 ea 37             	sub    $0x37,%edx
  800bce:	eb cb                	jmp    800b9b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd4:	74 05                	je     800bdb <strtol+0xcc>
		*endptr = (char *) s;
  800bd6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bdb:	89 c2                	mov    %eax,%edx
  800bdd:	f7 da                	neg    %edx
  800bdf:	85 ff                	test   %edi,%edi
  800be1:	0f 45 c2             	cmovne %edx,%eax
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bef:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfa:	89 c3                	mov    %eax,%ebx
  800bfc:	89 c7                	mov    %eax,%edi
  800bfe:	89 c6                	mov    %eax,%esi
  800c00:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c12:	b8 01 00 00 00       	mov    $0x1,%eax
  800c17:	89 d1                	mov    %edx,%ecx
  800c19:	89 d3                	mov    %edx,%ebx
  800c1b:	89 d7                	mov    %edx,%edi
  800c1d:	89 d6                	mov    %edx,%esi
  800c1f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
  800c2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	b8 03 00 00 00       	mov    $0x3,%eax
  800c3c:	89 cb                	mov    %ecx,%ebx
  800c3e:	89 cf                	mov    %ecx,%edi
  800c40:	89 ce                	mov    %ecx,%esi
  800c42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c44:	85 c0                	test   %eax,%eax
  800c46:	7f 08                	jg     800c50 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5f                   	pop    %edi
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c50:	83 ec 0c             	sub    $0xc,%esp
  800c53:	50                   	push   %eax
  800c54:	6a 03                	push   $0x3
  800c56:	68 a0 19 80 00       	push   $0x8019a0
  800c5b:	6a 33                	push   $0x33
  800c5d:	68 bd 19 80 00       	push   $0x8019bd
  800c62:	e8 e2 05 00 00       	call   801249 <_panic>

00800c67 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c72:	b8 02 00 00 00       	mov    $0x2,%eax
  800c77:	89 d1                	mov    %edx,%ecx
  800c79:	89 d3                	mov    %edx,%ebx
  800c7b:	89 d7                	mov    %edx,%edi
  800c7d:	89 d6                	mov    %edx,%esi
  800c7f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <sys_yield>:

void
sys_yield(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c96:	89 d1                	mov    %edx,%ecx
  800c98:	89 d3                	mov    %edx,%ebx
  800c9a:	89 d7                	mov    %edx,%edi
  800c9c:	89 d6                	mov    %edx,%esi
  800c9e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cae:	be 00 00 00 00       	mov    $0x0,%esi
  800cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	b8 04 00 00 00       	mov    $0x4,%eax
  800cbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc1:	89 f7                	mov    %esi,%edi
  800cc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	7f 08                	jg     800cd1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd1:	83 ec 0c             	sub    $0xc,%esp
  800cd4:	50                   	push   %eax
  800cd5:	6a 04                	push   $0x4
  800cd7:	68 a0 19 80 00       	push   $0x8019a0
  800cdc:	6a 33                	push   $0x33
  800cde:	68 bd 19 80 00       	push   $0x8019bd
  800ce3:	e8 61 05 00 00       	call   801249 <_panic>

00800ce8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf7:	b8 05 00 00 00       	mov    $0x5,%eax
  800cfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cff:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d02:	8b 75 18             	mov    0x18(%ebp),%esi
  800d05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d07:	85 c0                	test   %eax,%eax
  800d09:	7f 08                	jg     800d13 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d13:	83 ec 0c             	sub    $0xc,%esp
  800d16:	50                   	push   %eax
  800d17:	6a 05                	push   $0x5
  800d19:	68 a0 19 80 00       	push   $0x8019a0
  800d1e:	6a 33                	push   $0x33
  800d20:	68 bd 19 80 00       	push   $0x8019bd
  800d25:	e8 1f 05 00 00       	call   801249 <_panic>

00800d2a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7f 08                	jg     800d55 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	50                   	push   %eax
  800d59:	6a 06                	push   $0x6
  800d5b:	68 a0 19 80 00       	push   $0x8019a0
  800d60:	6a 33                	push   $0x33
  800d62:	68 bd 19 80 00       	push   $0x8019bd
  800d67:	e8 dd 04 00 00       	call   801249 <_panic>

00800d6c <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	57                   	push   %edi
  800d70:	56                   	push   %esi
  800d71:	53                   	push   %ebx
  800d72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d82:	89 cb                	mov    %ecx,%ebx
  800d84:	89 cf                	mov    %ecx,%edi
  800d86:	89 ce                	mov    %ecx,%esi
  800d88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7f 08                	jg     800d96 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	83 ec 0c             	sub    $0xc,%esp
  800d99:	50                   	push   %eax
  800d9a:	6a 0b                	push   $0xb
  800d9c:	68 a0 19 80 00       	push   $0x8019a0
  800da1:	6a 33                	push   $0x33
  800da3:	68 bd 19 80 00       	push   $0x8019bd
  800da8:	e8 9c 04 00 00       	call   801249 <_panic>

00800dad <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc1:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7f 08                	jg     800dd8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	50                   	push   %eax
  800ddc:	6a 08                	push   $0x8
  800dde:	68 a0 19 80 00       	push   $0x8019a0
  800de3:	6a 33                	push   $0x33
  800de5:	68 bd 19 80 00       	push   $0x8019bd
  800dea:	e8 5a 04 00 00       	call   801249 <_panic>

00800def <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	b8 09 00 00 00       	mov    $0x9,%eax
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 09                	push   $0x9
  800e20:	68 a0 19 80 00       	push   $0x8019a0
  800e25:	6a 33                	push   $0x33
  800e27:	68 bd 19 80 00       	push   $0x8019bd
  800e2c:	e8 18 04 00 00       	call   801249 <_panic>

00800e31 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4a:	89 df                	mov    %ebx,%edi
  800e4c:	89 de                	mov    %ebx,%esi
  800e4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	50                   	push   %eax
  800e60:	6a 0a                	push   $0xa
  800e62:	68 a0 19 80 00       	push   $0x8019a0
  800e67:	6a 33                	push   $0x33
  800e69:	68 bd 19 80 00       	push   $0x8019bd
  800e6e:	e8 d6 03 00 00       	call   801249 <_panic>

00800e73 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e84:	be 00 00 00 00       	mov    $0x0,%esi
  800e89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eac:	89 cb                	mov    %ecx,%ebx
  800eae:	89 cf                	mov    %ecx,%edi
  800eb0:	89 ce                	mov    %ecx,%esi
  800eb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	7f 08                	jg     800ec0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebb:	5b                   	pop    %ebx
  800ebc:	5e                   	pop    %esi
  800ebd:	5f                   	pop    %edi
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec0:	83 ec 0c             	sub    $0xc,%esp
  800ec3:	50                   	push   %eax
  800ec4:	6a 0e                	push   $0xe
  800ec6:	68 a0 19 80 00       	push   $0x8019a0
  800ecb:	6a 33                	push   $0x33
  800ecd:	68 bd 19 80 00       	push   $0x8019bd
  800ed2:	e8 72 03 00 00       	call   801249 <_panic>

00800ed7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800edd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eed:	89 df                	mov    %ebx,%edi
  800eef:	89 de                	mov    %ebx,%esi
  800ef1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	b8 10 00 00 00       	mov    $0x10,%eax
  800f0b:	89 cb                	mov    %ecx,%ebx
  800f0d:	89 cf                	mov    %ecx,%edi
  800f0f:	89 ce                	mov    %ecx,%esi
  800f11:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f13:	5b                   	pop    %ebx
  800f14:	5e                   	pop    %esi
  800f15:	5f                   	pop    %edi
  800f16:	5d                   	pop    %ebp
  800f17:	c3                   	ret    

00800f18 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	53                   	push   %ebx
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f22:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  800f24:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f28:	0f 84 90 00 00 00    	je     800fbe <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  800f2e:	89 d8                	mov    %ebx,%eax
  800f30:	c1 e8 16             	shr    $0x16,%eax
  800f33:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f3a:	a8 01                	test   $0x1,%al
  800f3c:	0f 84 90 00 00 00    	je     800fd2 <pgfault+0xba>
  800f42:	89 d8                	mov    %ebx,%eax
  800f44:	c1 e8 0c             	shr    $0xc,%eax
  800f47:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f4e:	a9 01 08 00 00       	test   $0x801,%eax
  800f53:	74 7d                	je     800fd2 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  800f55:	83 ec 04             	sub    $0x4,%esp
  800f58:	6a 07                	push   $0x7
  800f5a:	68 00 f0 7f 00       	push   $0x7ff000
  800f5f:	6a 00                	push   $0x0
  800f61:	e8 3f fd ff ff       	call   800ca5 <sys_page_alloc>
  800f66:	83 c4 10             	add    $0x10,%esp
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	78 79                	js     800fe6 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  800f6d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 00 10 00 00       	push   $0x1000
  800f7b:	53                   	push   %ebx
  800f7c:	68 00 f0 7f 00       	push   $0x7ff000
  800f81:	e8 bb fa ff ff       	call   800a41 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  800f86:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f8d:	53                   	push   %ebx
  800f8e:	6a 00                	push   $0x0
  800f90:	68 00 f0 7f 00       	push   $0x7ff000
  800f95:	6a 00                	push   $0x0
  800f97:	e8 4c fd ff ff       	call   800ce8 <sys_page_map>
  800f9c:	83 c4 20             	add    $0x20,%esp
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	78 55                	js     800ff8 <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	68 00 f0 7f 00       	push   $0x7ff000
  800fab:	6a 00                	push   $0x0
  800fad:	e8 78 fd ff ff       	call   800d2a <sys_page_unmap>
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	78 51                	js     80100a <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  800fb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  800fbe:	83 ec 04             	sub    $0x4,%esp
  800fc1:	68 cc 19 80 00       	push   $0x8019cc
  800fc6:	6a 21                	push   $0x21
  800fc8:	68 54 1a 80 00       	push   $0x801a54
  800fcd:	e8 77 02 00 00       	call   801249 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  800fd2:	83 ec 04             	sub    $0x4,%esp
  800fd5:	68 f8 19 80 00       	push   $0x8019f8
  800fda:	6a 24                	push   $0x24
  800fdc:	68 54 1a 80 00       	push   $0x801a54
  800fe1:	e8 63 02 00 00       	call   801249 <_panic>
		panic("sys_page_alloc: %e\n", r);
  800fe6:	50                   	push   %eax
  800fe7:	68 5f 1a 80 00       	push   $0x801a5f
  800fec:	6a 2e                	push   $0x2e
  800fee:	68 54 1a 80 00       	push   $0x801a54
  800ff3:	e8 51 02 00 00       	call   801249 <_panic>
		panic("sys_page_map: %e\n", r);
  800ff8:	50                   	push   %eax
  800ff9:	68 73 1a 80 00       	push   $0x801a73
  800ffe:	6a 34                	push   $0x34
  801000:	68 54 1a 80 00       	push   $0x801a54
  801005:	e8 3f 02 00 00       	call   801249 <_panic>
		panic("sys_page_unmap: %e\n", r);
  80100a:	50                   	push   %eax
  80100b:	68 85 1a 80 00       	push   $0x801a85
  801010:	6a 37                	push   $0x37
  801012:	68 54 1a 80 00       	push   $0x801a54
  801017:	e8 2d 02 00 00       	call   801249 <_panic>

0080101c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
  801022:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801025:	68 18 0f 80 00       	push   $0x800f18
  80102a:	e8 60 02 00 00       	call   80128f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80102f:	b8 07 00 00 00       	mov    $0x7,%eax
  801034:	cd 30                	int    $0x30
  801036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	85 c0                	test   %eax,%eax
  80103e:	78 30                	js     801070 <fork+0x54>
  801040:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801042:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801047:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80104b:	0f 85 a5 00 00 00    	jne    8010f6 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  801051:	e8 11 fc ff ff       	call   800c67 <sys_getenvid>
  801056:	25 ff 03 00 00       	and    $0x3ff,%eax
  80105b:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80105e:	c1 e0 04             	shl    $0x4,%eax
  801061:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801066:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80106b:	e9 75 01 00 00       	jmp    8011e5 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  801070:	50                   	push   %eax
  801071:	68 99 1a 80 00       	push   $0x801a99
  801076:	68 83 00 00 00       	push   $0x83
  80107b:	68 54 1a 80 00       	push   $0x801a54
  801080:	e8 c4 01 00 00       	call   801249 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801085:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80108c:	83 ec 0c             	sub    $0xc,%esp
  80108f:	25 07 0e 00 00       	and    $0xe07,%eax
  801094:	50                   	push   %eax
  801095:	56                   	push   %esi
  801096:	57                   	push   %edi
  801097:	56                   	push   %esi
  801098:	6a 00                	push   $0x0
  80109a:	e8 49 fc ff ff       	call   800ce8 <sys_page_map>
  80109f:	83 c4 20             	add    $0x20,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	79 3e                	jns    8010e4 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8010a6:	50                   	push   %eax
  8010a7:	68 73 1a 80 00       	push   $0x801a73
  8010ac:	6a 50                	push   $0x50
  8010ae:	68 54 1a 80 00       	push   $0x801a54
  8010b3:	e8 91 01 00 00       	call   801249 <_panic>
			panic("sys_page_map: %e\n", r);
  8010b8:	50                   	push   %eax
  8010b9:	68 73 1a 80 00       	push   $0x801a73
  8010be:	6a 54                	push   $0x54
  8010c0:	68 54 1a 80 00       	push   $0x801a54
  8010c5:	e8 7f 01 00 00       	call   801249 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	6a 05                	push   $0x5
  8010cf:	56                   	push   %esi
  8010d0:	57                   	push   %edi
  8010d1:	56                   	push   %esi
  8010d2:	6a 00                	push   $0x0
  8010d4:	e8 0f fc ff ff       	call   800ce8 <sys_page_map>
  8010d9:	83 c4 20             	add    $0x20,%esp
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	0f 88 ab 00 00 00    	js     80118f <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8010e4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010ea:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8010f0:	0f 84 ab 00 00 00    	je     8011a1 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  8010f6:	89 d8                	mov    %ebx,%eax
  8010f8:	c1 e8 16             	shr    $0x16,%eax
  8010fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801102:	a8 01                	test   $0x1,%al
  801104:	74 de                	je     8010e4 <fork+0xc8>
  801106:	89 d8                	mov    %ebx,%eax
  801108:	c1 e8 0c             	shr    $0xc,%eax
  80110b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801112:	f6 c2 01             	test   $0x1,%dl
  801115:	74 cd                	je     8010e4 <fork+0xc8>
  801117:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  80111d:	74 c5                	je     8010e4 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  80111f:	89 c6                	mov    %eax,%esi
  801121:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  801124:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80112b:	f6 c6 04             	test   $0x4,%dh
  80112e:	0f 85 51 ff ff ff    	jne    801085 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  801134:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80113b:	a9 02 08 00 00       	test   $0x802,%eax
  801140:	74 88                	je     8010ca <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	68 05 08 00 00       	push   $0x805
  80114a:	56                   	push   %esi
  80114b:	57                   	push   %edi
  80114c:	56                   	push   %esi
  80114d:	6a 00                	push   $0x0
  80114f:	e8 94 fb ff ff       	call   800ce8 <sys_page_map>
  801154:	83 c4 20             	add    $0x20,%esp
  801157:	85 c0                	test   %eax,%eax
  801159:	0f 88 59 ff ff ff    	js     8010b8 <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	68 05 08 00 00       	push   $0x805
  801167:	56                   	push   %esi
  801168:	6a 00                	push   $0x0
  80116a:	56                   	push   %esi
  80116b:	6a 00                	push   $0x0
  80116d:	e8 76 fb ff ff       	call   800ce8 <sys_page_map>
  801172:	83 c4 20             	add    $0x20,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	0f 89 67 ff ff ff    	jns    8010e4 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  80117d:	50                   	push   %eax
  80117e:	68 73 1a 80 00       	push   $0x801a73
  801183:	6a 56                	push   $0x56
  801185:	68 54 1a 80 00       	push   $0x801a54
  80118a:	e8 ba 00 00 00       	call   801249 <_panic>
			panic("sys_page_map: %e\n", r);
  80118f:	50                   	push   %eax
  801190:	68 73 1a 80 00       	push   $0x801a73
  801195:	6a 5a                	push   $0x5a
  801197:	68 54 1a 80 00       	push   $0x801a54
  80119c:	e8 a8 00 00 00       	call   801249 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	6a 07                	push   $0x7
  8011a6:	68 00 f0 bf ee       	push   $0xeebff000
  8011ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ae:	e8 f2 fa ff ff       	call   800ca5 <sys_page_alloc>
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	78 36                	js     8011f0 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8011ba:	83 ec 08             	sub    $0x8,%esp
  8011bd:	68 fa 12 80 00       	push   $0x8012fa
  8011c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011c5:	e8 67 fc ff ff       	call   800e31 <sys_env_set_pgfault_upcall>
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	78 34                	js     801205 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	6a 02                	push   $0x2
  8011d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011d9:	e8 cf fb ff ff       	call   800dad <sys_env_set_status>
  8011de:	83 c4 10             	add    $0x10,%esp
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	78 35                	js     80121a <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  8011e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011eb:	5b                   	pop    %ebx
  8011ec:	5e                   	pop    %esi
  8011ed:	5f                   	pop    %edi
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  8011f0:	50                   	push   %eax
  8011f1:	68 5f 1a 80 00       	push   $0x801a5f
  8011f6:	68 95 00 00 00       	push   $0x95
  8011fb:	68 54 1a 80 00       	push   $0x801a54
  801200:	e8 44 00 00 00       	call   801249 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801205:	50                   	push   %eax
  801206:	68 34 1a 80 00       	push   $0x801a34
  80120b:	68 98 00 00 00       	push   $0x98
  801210:	68 54 1a 80 00       	push   $0x801a54
  801215:	e8 2f 00 00 00       	call   801249 <_panic>
		panic("sys_env_set_status: %e\n", r);
  80121a:	50                   	push   %eax
  80121b:	68 a9 1a 80 00       	push   $0x801aa9
  801220:	68 9b 00 00 00       	push   $0x9b
  801225:	68 54 1a 80 00       	push   $0x801a54
  80122a:	e8 1a 00 00 00       	call   801249 <_panic>

0080122f <sfork>:

// Challenge!
int
sfork(void)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801235:	68 c1 1a 80 00       	push   $0x801ac1
  80123a:	68 a4 00 00 00       	push   $0xa4
  80123f:	68 54 1a 80 00       	push   $0x801a54
  801244:	e8 00 00 00 00       	call   801249 <_panic>

00801249 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	56                   	push   %esi
  80124d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80124e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801251:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801257:	e8 0b fa ff ff       	call   800c67 <sys_getenvid>
  80125c:	83 ec 0c             	sub    $0xc,%esp
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	ff 75 08             	pushl  0x8(%ebp)
  801265:	56                   	push   %esi
  801266:	50                   	push   %eax
  801267:	68 d8 1a 80 00       	push   $0x801ad8
  80126c:	e8 34 ef ff ff       	call   8001a5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801271:	83 c4 18             	add    $0x18,%esp
  801274:	53                   	push   %ebx
  801275:	ff 75 10             	pushl  0x10(%ebp)
  801278:	e8 d7 ee ff ff       	call   800154 <vcprintf>
	cprintf("\n");
  80127d:	c7 04 24 14 16 80 00 	movl   $0x801614,(%esp)
  801284:	e8 1c ef ff ff       	call   8001a5 <cprintf>
  801289:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80128c:	cc                   	int3   
  80128d:	eb fd                	jmp    80128c <_panic+0x43>

0080128f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801295:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80129c:	74 0a                	je     8012a8 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	6a 07                	push   $0x7
  8012ad:	68 00 f0 bf ee       	push   $0xeebff000
  8012b2:	6a 00                	push   $0x0
  8012b4:	e8 ec f9 ff ff       	call   800ca5 <sys_page_alloc>
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	78 28                	js     8012e8 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	68 fa 12 80 00       	push   $0x8012fa
  8012c8:	6a 00                	push   $0x0
  8012ca:	e8 62 fb ff ff       	call   800e31 <sys_env_set_pgfault_upcall>
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	79 c8                	jns    80129e <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8012d6:	50                   	push   %eax
  8012d7:	68 34 1a 80 00       	push   $0x801a34
  8012dc:	6a 23                	push   $0x23
  8012de:	68 14 1b 80 00       	push   $0x801b14
  8012e3:	e8 61 ff ff ff       	call   801249 <_panic>
			panic("set_pgfault_handler %e\n",r);
  8012e8:	50                   	push   %eax
  8012e9:	68 fc 1a 80 00       	push   $0x801afc
  8012ee:	6a 21                	push   $0x21
  8012f0:	68 14 1b 80 00       	push   $0x801b14
  8012f5:	e8 4f ff ff ff       	call   801249 <_panic>

008012fa <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8012fa:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8012fb:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801300:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801302:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  801305:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  801309:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80130d:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801310:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801312:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801316:	83 c4 08             	add    $0x8,%esp
	popal
  801319:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80131a:	83 c4 04             	add    $0x4,%esp
	popfl
  80131d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80131e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80131f:	c3                   	ret    

00801320 <__udivdi3>:
  801320:	55                   	push   %ebp
  801321:	57                   	push   %edi
  801322:	56                   	push   %esi
  801323:	53                   	push   %ebx
  801324:	83 ec 1c             	sub    $0x1c,%esp
  801327:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80132b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80132f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801333:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801337:	85 d2                	test   %edx,%edx
  801339:	75 4d                	jne    801388 <__udivdi3+0x68>
  80133b:	39 f3                	cmp    %esi,%ebx
  80133d:	76 19                	jbe    801358 <__udivdi3+0x38>
  80133f:	31 ff                	xor    %edi,%edi
  801341:	89 e8                	mov    %ebp,%eax
  801343:	89 f2                	mov    %esi,%edx
  801345:	f7 f3                	div    %ebx
  801347:	89 fa                	mov    %edi,%edx
  801349:	83 c4 1c             	add    $0x1c,%esp
  80134c:	5b                   	pop    %ebx
  80134d:	5e                   	pop    %esi
  80134e:	5f                   	pop    %edi
  80134f:	5d                   	pop    %ebp
  801350:	c3                   	ret    
  801351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801358:	89 d9                	mov    %ebx,%ecx
  80135a:	85 db                	test   %ebx,%ebx
  80135c:	75 0b                	jne    801369 <__udivdi3+0x49>
  80135e:	b8 01 00 00 00       	mov    $0x1,%eax
  801363:	31 d2                	xor    %edx,%edx
  801365:	f7 f3                	div    %ebx
  801367:	89 c1                	mov    %eax,%ecx
  801369:	31 d2                	xor    %edx,%edx
  80136b:	89 f0                	mov    %esi,%eax
  80136d:	f7 f1                	div    %ecx
  80136f:	89 c6                	mov    %eax,%esi
  801371:	89 e8                	mov    %ebp,%eax
  801373:	89 f7                	mov    %esi,%edi
  801375:	f7 f1                	div    %ecx
  801377:	89 fa                	mov    %edi,%edx
  801379:	83 c4 1c             	add    $0x1c,%esp
  80137c:	5b                   	pop    %ebx
  80137d:	5e                   	pop    %esi
  80137e:	5f                   	pop    %edi
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    
  801381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801388:	39 f2                	cmp    %esi,%edx
  80138a:	77 1c                	ja     8013a8 <__udivdi3+0x88>
  80138c:	0f bd fa             	bsr    %edx,%edi
  80138f:	83 f7 1f             	xor    $0x1f,%edi
  801392:	75 2c                	jne    8013c0 <__udivdi3+0xa0>
  801394:	39 f2                	cmp    %esi,%edx
  801396:	72 06                	jb     80139e <__udivdi3+0x7e>
  801398:	31 c0                	xor    %eax,%eax
  80139a:	39 eb                	cmp    %ebp,%ebx
  80139c:	77 a9                	ja     801347 <__udivdi3+0x27>
  80139e:	b8 01 00 00 00       	mov    $0x1,%eax
  8013a3:	eb a2                	jmp    801347 <__udivdi3+0x27>
  8013a5:	8d 76 00             	lea    0x0(%esi),%esi
  8013a8:	31 ff                	xor    %edi,%edi
  8013aa:	31 c0                	xor    %eax,%eax
  8013ac:	89 fa                	mov    %edi,%edx
  8013ae:	83 c4 1c             	add    $0x1c,%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5f                   	pop    %edi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    
  8013b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013bd:	8d 76 00             	lea    0x0(%esi),%esi
  8013c0:	89 f9                	mov    %edi,%ecx
  8013c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8013c7:	29 f8                	sub    %edi,%eax
  8013c9:	d3 e2                	shl    %cl,%edx
  8013cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013cf:	89 c1                	mov    %eax,%ecx
  8013d1:	89 da                	mov    %ebx,%edx
  8013d3:	d3 ea                	shr    %cl,%edx
  8013d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8013d9:	09 d1                	or     %edx,%ecx
  8013db:	89 f2                	mov    %esi,%edx
  8013dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013e1:	89 f9                	mov    %edi,%ecx
  8013e3:	d3 e3                	shl    %cl,%ebx
  8013e5:	89 c1                	mov    %eax,%ecx
  8013e7:	d3 ea                	shr    %cl,%edx
  8013e9:	89 f9                	mov    %edi,%ecx
  8013eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013ef:	89 eb                	mov    %ebp,%ebx
  8013f1:	d3 e6                	shl    %cl,%esi
  8013f3:	89 c1                	mov    %eax,%ecx
  8013f5:	d3 eb                	shr    %cl,%ebx
  8013f7:	09 de                	or     %ebx,%esi
  8013f9:	89 f0                	mov    %esi,%eax
  8013fb:	f7 74 24 08          	divl   0x8(%esp)
  8013ff:	89 d6                	mov    %edx,%esi
  801401:	89 c3                	mov    %eax,%ebx
  801403:	f7 64 24 0c          	mull   0xc(%esp)
  801407:	39 d6                	cmp    %edx,%esi
  801409:	72 15                	jb     801420 <__udivdi3+0x100>
  80140b:	89 f9                	mov    %edi,%ecx
  80140d:	d3 e5                	shl    %cl,%ebp
  80140f:	39 c5                	cmp    %eax,%ebp
  801411:	73 04                	jae    801417 <__udivdi3+0xf7>
  801413:	39 d6                	cmp    %edx,%esi
  801415:	74 09                	je     801420 <__udivdi3+0x100>
  801417:	89 d8                	mov    %ebx,%eax
  801419:	31 ff                	xor    %edi,%edi
  80141b:	e9 27 ff ff ff       	jmp    801347 <__udivdi3+0x27>
  801420:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801423:	31 ff                	xor    %edi,%edi
  801425:	e9 1d ff ff ff       	jmp    801347 <__udivdi3+0x27>
  80142a:	66 90                	xchg   %ax,%ax
  80142c:	66 90                	xchg   %ax,%ax
  80142e:	66 90                	xchg   %ax,%ax

00801430 <__umoddi3>:
  801430:	55                   	push   %ebp
  801431:	57                   	push   %edi
  801432:	56                   	push   %esi
  801433:	53                   	push   %ebx
  801434:	83 ec 1c             	sub    $0x1c,%esp
  801437:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80143b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80143f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801447:	89 da                	mov    %ebx,%edx
  801449:	85 c0                	test   %eax,%eax
  80144b:	75 43                	jne    801490 <__umoddi3+0x60>
  80144d:	39 df                	cmp    %ebx,%edi
  80144f:	76 17                	jbe    801468 <__umoddi3+0x38>
  801451:	89 f0                	mov    %esi,%eax
  801453:	f7 f7                	div    %edi
  801455:	89 d0                	mov    %edx,%eax
  801457:	31 d2                	xor    %edx,%edx
  801459:	83 c4 1c             	add    $0x1c,%esp
  80145c:	5b                   	pop    %ebx
  80145d:	5e                   	pop    %esi
  80145e:	5f                   	pop    %edi
  80145f:	5d                   	pop    %ebp
  801460:	c3                   	ret    
  801461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801468:	89 fd                	mov    %edi,%ebp
  80146a:	85 ff                	test   %edi,%edi
  80146c:	75 0b                	jne    801479 <__umoddi3+0x49>
  80146e:	b8 01 00 00 00       	mov    $0x1,%eax
  801473:	31 d2                	xor    %edx,%edx
  801475:	f7 f7                	div    %edi
  801477:	89 c5                	mov    %eax,%ebp
  801479:	89 d8                	mov    %ebx,%eax
  80147b:	31 d2                	xor    %edx,%edx
  80147d:	f7 f5                	div    %ebp
  80147f:	89 f0                	mov    %esi,%eax
  801481:	f7 f5                	div    %ebp
  801483:	89 d0                	mov    %edx,%eax
  801485:	eb d0                	jmp    801457 <__umoddi3+0x27>
  801487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80148e:	66 90                	xchg   %ax,%ax
  801490:	89 f1                	mov    %esi,%ecx
  801492:	39 d8                	cmp    %ebx,%eax
  801494:	76 0a                	jbe    8014a0 <__umoddi3+0x70>
  801496:	89 f0                	mov    %esi,%eax
  801498:	83 c4 1c             	add    $0x1c,%esp
  80149b:	5b                   	pop    %ebx
  80149c:	5e                   	pop    %esi
  80149d:	5f                   	pop    %edi
  80149e:	5d                   	pop    %ebp
  80149f:	c3                   	ret    
  8014a0:	0f bd e8             	bsr    %eax,%ebp
  8014a3:	83 f5 1f             	xor    $0x1f,%ebp
  8014a6:	75 20                	jne    8014c8 <__umoddi3+0x98>
  8014a8:	39 d8                	cmp    %ebx,%eax
  8014aa:	0f 82 b0 00 00 00    	jb     801560 <__umoddi3+0x130>
  8014b0:	39 f7                	cmp    %esi,%edi
  8014b2:	0f 86 a8 00 00 00    	jbe    801560 <__umoddi3+0x130>
  8014b8:	89 c8                	mov    %ecx,%eax
  8014ba:	83 c4 1c             	add    $0x1c,%esp
  8014bd:	5b                   	pop    %ebx
  8014be:	5e                   	pop    %esi
  8014bf:	5f                   	pop    %edi
  8014c0:	5d                   	pop    %ebp
  8014c1:	c3                   	ret    
  8014c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8014c8:	89 e9                	mov    %ebp,%ecx
  8014ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8014cf:	29 ea                	sub    %ebp,%edx
  8014d1:	d3 e0                	shl    %cl,%eax
  8014d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014d7:	89 d1                	mov    %edx,%ecx
  8014d9:	89 f8                	mov    %edi,%eax
  8014db:	d3 e8                	shr    %cl,%eax
  8014dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8014e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8014e9:	09 c1                	or     %eax,%ecx
  8014eb:	89 d8                	mov    %ebx,%eax
  8014ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014f1:	89 e9                	mov    %ebp,%ecx
  8014f3:	d3 e7                	shl    %cl,%edi
  8014f5:	89 d1                	mov    %edx,%ecx
  8014f7:	d3 e8                	shr    %cl,%eax
  8014f9:	89 e9                	mov    %ebp,%ecx
  8014fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014ff:	d3 e3                	shl    %cl,%ebx
  801501:	89 c7                	mov    %eax,%edi
  801503:	89 d1                	mov    %edx,%ecx
  801505:	89 f0                	mov    %esi,%eax
  801507:	d3 e8                	shr    %cl,%eax
  801509:	89 e9                	mov    %ebp,%ecx
  80150b:	89 fa                	mov    %edi,%edx
  80150d:	d3 e6                	shl    %cl,%esi
  80150f:	09 d8                	or     %ebx,%eax
  801511:	f7 74 24 08          	divl   0x8(%esp)
  801515:	89 d1                	mov    %edx,%ecx
  801517:	89 f3                	mov    %esi,%ebx
  801519:	f7 64 24 0c          	mull   0xc(%esp)
  80151d:	89 c6                	mov    %eax,%esi
  80151f:	89 d7                	mov    %edx,%edi
  801521:	39 d1                	cmp    %edx,%ecx
  801523:	72 06                	jb     80152b <__umoddi3+0xfb>
  801525:	75 10                	jne    801537 <__umoddi3+0x107>
  801527:	39 c3                	cmp    %eax,%ebx
  801529:	73 0c                	jae    801537 <__umoddi3+0x107>
  80152b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80152f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801533:	89 d7                	mov    %edx,%edi
  801535:	89 c6                	mov    %eax,%esi
  801537:	89 ca                	mov    %ecx,%edx
  801539:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80153e:	29 f3                	sub    %esi,%ebx
  801540:	19 fa                	sbb    %edi,%edx
  801542:	89 d0                	mov    %edx,%eax
  801544:	d3 e0                	shl    %cl,%eax
  801546:	89 e9                	mov    %ebp,%ecx
  801548:	d3 eb                	shr    %cl,%ebx
  80154a:	d3 ea                	shr    %cl,%edx
  80154c:	09 d8                	or     %ebx,%eax
  80154e:	83 c4 1c             	add    $0x1c,%esp
  801551:	5b                   	pop    %ebx
  801552:	5e                   	pop    %esi
  801553:	5f                   	pop    %edi
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    
  801556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80155d:	8d 76 00             	lea    0x0(%esi),%esi
  801560:	89 da                	mov    %ebx,%edx
  801562:	29 fe                	sub    %edi,%esi
  801564:	19 c2                	sbb    %eax,%edx
  801566:	89 f1                	mov    %esi,%ecx
  801568:	89 c8                	mov    %ecx,%eax
  80156a:	e9 4b ff ff ff       	jmp    8014ba <__umoddi3+0x8a>
