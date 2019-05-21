
obj/user/sbrktest.debug:     file format elf32-i386


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
  80002c:	e8 8a 00 00 00       	call   8000bb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define ALLOCATE_SIZE 4096
#define STRING_SIZE	  64

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 18             	sub    $0x18,%esp
	int i;
	uint32_t start, end;
	char *s;

	start = sys_sbrk(0);
  80003c:	6a 00                	push   $0x0
  80003e:	e8 bb 0e 00 00       	call   800efe <sys_sbrk>
  800043:	89 c6                	mov    %eax,%esi
  800045:	89 c3                	mov    %eax,%ebx
	end = sys_sbrk(ALLOCATE_SIZE);
  800047:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  80004e:	e8 ab 0e 00 00       	call   800efe <sys_sbrk>

	if (end - start < ALLOCATE_SIZE) {
  800053:	29 f0                	sub    %esi,%eax
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  80005d:	76 4a                	jbe    8000a9 <umain+0x76>
		cprintf("sbrk not correctly implemented\n");
	}

	s = (char *) start;
	for ( i = 0; i < STRING_SIZE; i++) {
  80005f:	b9 00 00 00 00       	mov    $0x0,%ecx
		s[i] = 'A' + (i % 26);
  800064:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
  800069:	89 c8                	mov    %ecx,%eax
  80006b:	f7 ef                	imul   %edi
  80006d:	c1 fa 03             	sar    $0x3,%edx
  800070:	89 c8                	mov    %ecx,%eax
  800072:	c1 f8 1f             	sar    $0x1f,%eax
  800075:	29 c2                	sub    %eax,%edx
  800077:	6b d2 1a             	imul   $0x1a,%edx,%edx
  80007a:	89 c8                	mov    %ecx,%eax
  80007c:	29 d0                	sub    %edx,%eax
  80007e:	83 c0 41             	add    $0x41,%eax
  800081:	88 04 19             	mov    %al,(%ecx,%ebx,1)
	for ( i = 0; i < STRING_SIZE; i++) {
  800084:	83 c1 01             	add    $0x1,%ecx
  800087:	83 f9 40             	cmp    $0x40,%ecx
  80008a:	75 dd                	jne    800069 <umain+0x36>
	}
	s[STRING_SIZE] = '\0';
  80008c:	c6 46 40 00          	movb   $0x0,0x40(%esi)

	cprintf("SBRK_TEST(%s)\n", s);
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	56                   	push   %esi
  800094:	68 e0 11 80 00       	push   $0x8011e0
  800099:	e8 0d 01 00 00       	call   8001ab <cprintf>
}
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000a4:	5b                   	pop    %ebx
  8000a5:	5e                   	pop    %esi
  8000a6:	5f                   	pop    %edi
  8000a7:	5d                   	pop    %ebp
  8000a8:	c3                   	ret    
		cprintf("sbrk not correctly implemented\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 c0 11 80 00       	push   $0x8011c0
  8000b1:	e8 f5 00 00 00       	call   8001ab <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	eb a4                	jmp    80005f <umain+0x2c>

008000bb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
  8000c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c6:	e8 a2 0b 00 00       	call   800c6d <sys_getenvid>
  8000cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d0:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000d3:	c1 e0 04             	shl    $0x4,%eax
  8000d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000db:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e0:	85 db                	test   %ebx,%ebx
  8000e2:	7e 07                	jle    8000eb <libmain+0x30>
		binaryname = argv[0];
  8000e4:	8b 06                	mov    (%esi),%eax
  8000e6:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000eb:	83 ec 08             	sub    $0x8,%esp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	e8 3e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f5:	e8 0a 00 00 00       	call   800104 <exit>
}
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5d                   	pop    %ebp
  800103:	c3                   	ret    

00800104 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  80010a:	6a 00                	push   $0x0
  80010c:	e8 1b 0b 00 00       	call   800c2c <sys_env_destroy>
}
  800111:	83 c4 10             	add    $0x10,%esp
  800114:	c9                   	leave  
  800115:	c3                   	ret    

00800116 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	53                   	push   %ebx
  80011a:	83 ec 04             	sub    $0x4,%esp
  80011d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800120:	8b 13                	mov    (%ebx),%edx
  800122:	8d 42 01             	lea    0x1(%edx),%eax
  800125:	89 03                	mov    %eax,(%ebx)
  800127:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800133:	74 09                	je     80013e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800135:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800139:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	68 ff 00 00 00       	push   $0xff
  800146:	8d 43 08             	lea    0x8(%ebx),%eax
  800149:	50                   	push   %eax
  80014a:	e8 a0 0a 00 00       	call   800bef <sys_cputs>
		b->idx = 0;
  80014f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	eb db                	jmp    800135 <putch+0x1f>

0080015a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800163:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016a:	00 00 00 
	b.cnt = 0;
  80016d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800174:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800177:	ff 75 0c             	pushl  0xc(%ebp)
  80017a:	ff 75 08             	pushl  0x8(%ebp)
  80017d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800183:	50                   	push   %eax
  800184:	68 16 01 80 00       	push   $0x800116
  800189:	e8 4a 01 00 00       	call   8002d8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018e:	83 c4 08             	add    $0x8,%esp
  800191:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800197:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019d:	50                   	push   %eax
  80019e:	e8 4c 0a 00 00       	call   800bef <sys_cputs>

	return b.cnt;
}
  8001a3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a9:	c9                   	leave  
  8001aa:	c3                   	ret    

008001ab <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b4:	50                   	push   %eax
  8001b5:	ff 75 08             	pushl  0x8(%ebp)
  8001b8:	e8 9d ff ff ff       	call   80015a <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    

008001bf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	57                   	push   %edi
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 1c             	sub    $0x1c,%esp
  8001c8:	89 c6                	mov    %eax,%esi
  8001ca:	89 d7                	mov    %edx,%edi
  8001cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001db:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001de:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e2:	74 2c                	je     800210 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001f4:	39 c2                	cmp    %eax,%edx
  8001f6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001f9:	73 43                	jae    80023e <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001fb:	83 eb 01             	sub    $0x1,%ebx
  8001fe:	85 db                	test   %ebx,%ebx
  800200:	7e 6c                	jle    80026e <printnum+0xaf>
			putch(padc, putdat);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	57                   	push   %edi
  800206:	ff 75 18             	pushl  0x18(%ebp)
  800209:	ff d6                	call   *%esi
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	eb eb                	jmp    8001fb <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	6a 20                	push   $0x20
  800215:	6a 00                	push   $0x0
  800217:	50                   	push   %eax
  800218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021b:	ff 75 e0             	pushl  -0x20(%ebp)
  80021e:	89 fa                	mov    %edi,%edx
  800220:	89 f0                	mov    %esi,%eax
  800222:	e8 98 ff ff ff       	call   8001bf <printnum>
		while (--width > 0)
  800227:	83 c4 20             	add    $0x20,%esp
  80022a:	83 eb 01             	sub    $0x1,%ebx
  80022d:	85 db                	test   %ebx,%ebx
  80022f:	7e 65                	jle    800296 <printnum+0xd7>
			putch(padc, putdat);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	57                   	push   %edi
  800235:	6a 20                	push   $0x20
  800237:	ff d6                	call   *%esi
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	eb ec                	jmp    80022a <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 18             	pushl  0x18(%ebp)
  800244:	83 eb 01             	sub    $0x1,%ebx
  800247:	53                   	push   %ebx
  800248:	50                   	push   %eax
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	ff 75 dc             	pushl  -0x24(%ebp)
  80024f:	ff 75 d8             	pushl  -0x28(%ebp)
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 e0             	pushl  -0x20(%ebp)
  800258:	e8 13 0d 00 00       	call   800f70 <__udivdi3>
  80025d:	83 c4 18             	add    $0x18,%esp
  800260:	52                   	push   %edx
  800261:	50                   	push   %eax
  800262:	89 fa                	mov    %edi,%edx
  800264:	89 f0                	mov    %esi,%eax
  800266:	e8 54 ff ff ff       	call   8001bf <printnum>
  80026b:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026e:	83 ec 08             	sub    $0x8,%esp
  800271:	57                   	push   %edi
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	ff 75 dc             	pushl  -0x24(%ebp)
  800278:	ff 75 d8             	pushl  -0x28(%ebp)
  80027b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027e:	ff 75 e0             	pushl  -0x20(%ebp)
  800281:	e8 fa 0d 00 00       	call   801080 <__umoddi3>
  800286:	83 c4 14             	add    $0x14,%esp
  800289:	0f be 80 f9 11 80 00 	movsbl 0x8011f9(%eax),%eax
  800290:	50                   	push   %eax
  800291:	ff d6                	call   *%esi
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a8:	8b 10                	mov    (%eax),%edx
  8002aa:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ad:	73 0a                	jae    8002b9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b2:	89 08                	mov    %ecx,(%eax)
  8002b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b7:	88 02                	mov    %al,(%edx)
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <printfmt>:
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c4:	50                   	push   %eax
  8002c5:	ff 75 10             	pushl  0x10(%ebp)
  8002c8:	ff 75 0c             	pushl  0xc(%ebp)
  8002cb:	ff 75 08             	pushl  0x8(%ebp)
  8002ce:	e8 05 00 00 00       	call   8002d8 <vprintfmt>
}
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <vprintfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 3c             	sub    $0x3c,%esp
  8002e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ea:	e9 b4 03 00 00       	jmp    8006a3 <vprintfmt+0x3cb>
		padc = ' ';
  8002ef:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8002f3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8002fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800301:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800308:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80030f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800314:	8d 47 01             	lea    0x1(%edi),%eax
  800317:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031a:	0f b6 17             	movzbl (%edi),%edx
  80031d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800320:	3c 55                	cmp    $0x55,%al
  800322:	0f 87 c8 04 00 00    	ja     8007f0 <vprintfmt+0x518>
  800328:	0f b6 c0             	movzbl %al,%eax
  80032b:	ff 24 85 e0 13 80 00 	jmp    *0x8013e0(,%eax,4)
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800335:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80033c:	eb d6                	jmp    800314 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800341:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800345:	eb cd                	jmp    800314 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800347:	0f b6 d2             	movzbl %dl,%edx
  80034a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80034d:	b8 00 00 00 00       	mov    $0x0,%eax
  800352:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800355:	eb 0c                	jmp    800363 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80035a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80035e:	eb b4                	jmp    800314 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800360:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800363:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800366:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800370:	83 f9 09             	cmp    $0x9,%ecx
  800373:	76 eb                	jbe    800360 <vprintfmt+0x88>
  800375:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800378:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037b:	eb 14                	jmp    800391 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80037d:	8b 45 14             	mov    0x14(%ebp),%eax
  800380:	8b 00                	mov    (%eax),%eax
  800382:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800385:	8b 45 14             	mov    0x14(%ebp),%eax
  800388:	8d 40 04             	lea    0x4(%eax),%eax
  80038b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800391:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800395:	0f 89 79 ff ff ff    	jns    800314 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80039b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a8:	e9 67 ff ff ff       	jmp    800314 <vprintfmt+0x3c>
  8003ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b0:	85 c0                	test   %eax,%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b7:	0f 49 d0             	cmovns %eax,%edx
  8003ba:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c0:	e9 4f ff ff ff       	jmp    800314 <vprintfmt+0x3c>
  8003c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003cf:	e9 40 ff ff ff       	jmp    800314 <vprintfmt+0x3c>
			lflag++;
  8003d4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003da:	e9 35 ff ff ff       	jmp    800314 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	8d 78 04             	lea    0x4(%eax),%edi
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	53                   	push   %ebx
  8003e9:	ff 30                	pushl  (%eax)
  8003eb:	ff d6                	call   *%esi
			break;
  8003ed:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f3:	e9 a8 02 00 00       	jmp    8006a0 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8003f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fb:	8d 78 04             	lea    0x4(%eax),%edi
  8003fe:	8b 00                	mov    (%eax),%eax
  800400:	99                   	cltd   
  800401:	31 d0                	xor    %edx,%eax
  800403:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800405:	83 f8 0f             	cmp    $0xf,%eax
  800408:	7f 23                	jg     80042d <vprintfmt+0x155>
  80040a:	8b 14 85 40 15 80 00 	mov    0x801540(,%eax,4),%edx
  800411:	85 d2                	test   %edx,%edx
  800413:	74 18                	je     80042d <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800415:	52                   	push   %edx
  800416:	68 1a 12 80 00       	push   $0x80121a
  80041b:	53                   	push   %ebx
  80041c:	56                   	push   %esi
  80041d:	e8 99 fe ff ff       	call   8002bb <printfmt>
  800422:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800425:	89 7d 14             	mov    %edi,0x14(%ebp)
  800428:	e9 73 02 00 00       	jmp    8006a0 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80042d:	50                   	push   %eax
  80042e:	68 11 12 80 00       	push   $0x801211
  800433:	53                   	push   %ebx
  800434:	56                   	push   %esi
  800435:	e8 81 fe ff ff       	call   8002bb <printfmt>
  80043a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800440:	e9 5b 02 00 00       	jmp    8006a0 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800445:	8b 45 14             	mov    0x14(%ebp),%eax
  800448:	83 c0 04             	add    $0x4,%eax
  80044b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80044e:	8b 45 14             	mov    0x14(%ebp),%eax
  800451:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800453:	85 d2                	test   %edx,%edx
  800455:	b8 0a 12 80 00       	mov    $0x80120a,%eax
  80045a:	0f 45 c2             	cmovne %edx,%eax
  80045d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800460:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800464:	7e 06                	jle    80046c <vprintfmt+0x194>
  800466:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80046a:	75 0d                	jne    800479 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80046f:	89 c7                	mov    %eax,%edi
  800471:	03 45 e0             	add    -0x20(%ebp),%eax
  800474:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800477:	eb 53                	jmp    8004cc <vprintfmt+0x1f4>
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 d8             	pushl  -0x28(%ebp)
  80047f:	50                   	push   %eax
  800480:	e8 13 04 00 00       	call   800898 <strnlen>
  800485:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800488:	29 c1                	sub    %eax,%ecx
  80048a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80048d:	83 c4 10             	add    $0x10,%esp
  800490:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800492:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800499:	eb 0f                	jmp    8004aa <vprintfmt+0x1d2>
					putch(padc, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	53                   	push   %ebx
  80049f:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a4:	83 ef 01             	sub    $0x1,%edi
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	85 ff                	test   %edi,%edi
  8004ac:	7f ed                	jg     80049b <vprintfmt+0x1c3>
  8004ae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b1:	85 d2                	test   %edx,%edx
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	0f 49 c2             	cmovns %edx,%eax
  8004bb:	29 c2                	sub    %eax,%edx
  8004bd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004c0:	eb aa                	jmp    80046c <vprintfmt+0x194>
					putch(ch, putdat);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	53                   	push   %ebx
  8004c6:	52                   	push   %edx
  8004c7:	ff d6                	call   *%esi
  8004c9:	83 c4 10             	add    $0x10,%esp
  8004cc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004cf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d1:	83 c7 01             	add    $0x1,%edi
  8004d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004d8:	0f be d0             	movsbl %al,%edx
  8004db:	85 d2                	test   %edx,%edx
  8004dd:	74 4b                	je     80052a <vprintfmt+0x252>
  8004df:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e3:	78 06                	js     8004eb <vprintfmt+0x213>
  8004e5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004e9:	78 1e                	js     800509 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8004eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004ef:	74 d1                	je     8004c2 <vprintfmt+0x1ea>
  8004f1:	0f be c0             	movsbl %al,%eax
  8004f4:	83 e8 20             	sub    $0x20,%eax
  8004f7:	83 f8 5e             	cmp    $0x5e,%eax
  8004fa:	76 c6                	jbe    8004c2 <vprintfmt+0x1ea>
					putch('?', putdat);
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	53                   	push   %ebx
  800500:	6a 3f                	push   $0x3f
  800502:	ff d6                	call   *%esi
  800504:	83 c4 10             	add    $0x10,%esp
  800507:	eb c3                	jmp    8004cc <vprintfmt+0x1f4>
  800509:	89 cf                	mov    %ecx,%edi
  80050b:	eb 0e                	jmp    80051b <vprintfmt+0x243>
				putch(' ', putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	53                   	push   %ebx
  800511:	6a 20                	push   $0x20
  800513:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800515:	83 ef 01             	sub    $0x1,%edi
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	85 ff                	test   %edi,%edi
  80051d:	7f ee                	jg     80050d <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80051f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800522:	89 45 14             	mov    %eax,0x14(%ebp)
  800525:	e9 76 01 00 00       	jmp    8006a0 <vprintfmt+0x3c8>
  80052a:	89 cf                	mov    %ecx,%edi
  80052c:	eb ed                	jmp    80051b <vprintfmt+0x243>
	if (lflag >= 2)
  80052e:	83 f9 01             	cmp    $0x1,%ecx
  800531:	7f 1f                	jg     800552 <vprintfmt+0x27a>
	else if (lflag)
  800533:	85 c9                	test   %ecx,%ecx
  800535:	74 6a                	je     8005a1 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053f:	89 c1                	mov    %eax,%ecx
  800541:	c1 f9 1f             	sar    $0x1f,%ecx
  800544:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 40 04             	lea    0x4(%eax),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
  800550:	eb 17                	jmp    800569 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8b 50 04             	mov    0x4(%eax),%edx
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8d 40 08             	lea    0x8(%eax),%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800569:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80056c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800571:	85 d2                	test   %edx,%edx
  800573:	0f 89 f8 00 00 00    	jns    800671 <vprintfmt+0x399>
				putch('-', putdat);
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	53                   	push   %ebx
  80057d:	6a 2d                	push   $0x2d
  80057f:	ff d6                	call   *%esi
				num = -(long long) num;
  800581:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800584:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800587:	f7 d8                	neg    %eax
  800589:	83 d2 00             	adc    $0x0,%edx
  80058c:	f7 da                	neg    %edx
  80058e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800591:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800594:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800597:	bf 0a 00 00 00       	mov    $0xa,%edi
  80059c:	e9 e1 00 00 00       	jmp    800682 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a9:	99                   	cltd   
  8005aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 40 04             	lea    0x4(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b6:	eb b1                	jmp    800569 <vprintfmt+0x291>
	if (lflag >= 2)
  8005b8:	83 f9 01             	cmp    $0x1,%ecx
  8005bb:	7f 27                	jg     8005e4 <vprintfmt+0x30c>
	else if (lflag)
  8005bd:	85 c9                	test   %ecx,%ecx
  8005bf:	74 41                	je     800602 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8d 40 04             	lea    0x4(%eax),%eax
  8005d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005da:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005df:	e9 8d 00 00 00       	jmp    800671 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 50 04             	mov    0x4(%eax),%edx
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 40 08             	lea    0x8(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fb:	bf 0a 00 00 00       	mov    $0xa,%edi
  800600:	eb 6f                	jmp    800671 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	ba 00 00 00 00       	mov    $0x0,%edx
  80060c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8d 40 04             	lea    0x4(%eax),%eax
  800618:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800620:	eb 4f                	jmp    800671 <vprintfmt+0x399>
	if (lflag >= 2)
  800622:	83 f9 01             	cmp    $0x1,%ecx
  800625:	7f 23                	jg     80064a <vprintfmt+0x372>
	else if (lflag)
  800627:	85 c9                	test   %ecx,%ecx
  800629:	0f 84 98 00 00 00    	je     8006c7 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	ba 00 00 00 00       	mov    $0x0,%edx
  800639:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
  800648:	eb 17                	jmp    800661 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 50 04             	mov    0x4(%eax),%edx
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800655:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 40 08             	lea    0x8(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	6a 30                	push   $0x30
  800667:	ff d6                	call   *%esi
			goto number;
  800669:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80066c:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800671:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800675:	74 0b                	je     800682 <vprintfmt+0x3aa>
				putch('+', putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	6a 2b                	push   $0x2b
  80067d:	ff d6                	call   *%esi
  80067f:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800682:	83 ec 0c             	sub    $0xc,%esp
  800685:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800689:	50                   	push   %eax
  80068a:	ff 75 e0             	pushl  -0x20(%ebp)
  80068d:	57                   	push   %edi
  80068e:	ff 75 dc             	pushl  -0x24(%ebp)
  800691:	ff 75 d8             	pushl  -0x28(%ebp)
  800694:	89 da                	mov    %ebx,%edx
  800696:	89 f0                	mov    %esi,%eax
  800698:	e8 22 fb ff ff       	call   8001bf <printnum>
			break;
  80069d:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8006a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a3:	83 c7 01             	add    $0x1,%edi
  8006a6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006aa:	83 f8 25             	cmp    $0x25,%eax
  8006ad:	0f 84 3c fc ff ff    	je     8002ef <vprintfmt+0x17>
			if (ch == '\0')
  8006b3:	85 c0                	test   %eax,%eax
  8006b5:	0f 84 55 01 00 00    	je     800810 <vprintfmt+0x538>
			putch(ch, putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	50                   	push   %eax
  8006c0:	ff d6                	call   *%esi
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	eb dc                	jmp    8006a3 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 40 04             	lea    0x4(%eax),%eax
  8006dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e0:	e9 7c ff ff ff       	jmp    800661 <vprintfmt+0x389>
			putch('0', putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	6a 30                	push   $0x30
  8006eb:	ff d6                	call   *%esi
			putch('x', putdat);
  8006ed:	83 c4 08             	add    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	6a 78                	push   $0x78
  8006f3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800702:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800705:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 40 04             	lea    0x4(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800711:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800716:	e9 56 ff ff ff       	jmp    800671 <vprintfmt+0x399>
	if (lflag >= 2)
  80071b:	83 f9 01             	cmp    $0x1,%ecx
  80071e:	7f 27                	jg     800747 <vprintfmt+0x46f>
	else if (lflag)
  800720:	85 c9                	test   %ecx,%ecx
  800722:	74 44                	je     800768 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
  80072e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800731:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8d 40 04             	lea    0x4(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073d:	bf 10 00 00 00       	mov    $0x10,%edi
  800742:	e9 2a ff ff ff       	jmp    800671 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 50 04             	mov    0x4(%eax),%edx
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800752:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8d 40 08             	lea    0x8(%eax),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075e:	bf 10 00 00 00       	mov    $0x10,%edi
  800763:	e9 09 ff ff ff       	jmp    800671 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	ba 00 00 00 00       	mov    $0x0,%edx
  800772:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800775:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8d 40 04             	lea    0x4(%eax),%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800781:	bf 10 00 00 00       	mov    $0x10,%edi
  800786:	e9 e6 fe ff ff       	jmp    800671 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 78 04             	lea    0x4(%eax),%edi
  800791:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800793:	85 c0                	test   %eax,%eax
  800795:	74 2d                	je     8007c4 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800797:	0f b6 13             	movzbl (%ebx),%edx
  80079a:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80079c:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  80079f:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007a2:	0f 8e f8 fe ff ff    	jle    8006a0 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007a8:	68 68 13 80 00       	push   $0x801368
  8007ad:	68 1a 12 80 00       	push   $0x80121a
  8007b2:	53                   	push   %ebx
  8007b3:	56                   	push   %esi
  8007b4:	e8 02 fb ff ff       	call   8002bb <printfmt>
  8007b9:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007bc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007bf:	e9 dc fe ff ff       	jmp    8006a0 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8007c4:	68 30 13 80 00       	push   $0x801330
  8007c9:	68 1a 12 80 00       	push   $0x80121a
  8007ce:	53                   	push   %ebx
  8007cf:	56                   	push   %esi
  8007d0:	e8 e6 fa ff ff       	call   8002bb <printfmt>
  8007d5:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007d8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007db:	e9 c0 fe ff ff       	jmp    8006a0 <vprintfmt+0x3c8>
			putch(ch, putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	53                   	push   %ebx
  8007e4:	6a 25                	push   $0x25
  8007e6:	ff d6                	call   *%esi
			break;
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	e9 b0 fe ff ff       	jmp    8006a0 <vprintfmt+0x3c8>
			putch('%', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	6a 25                	push   $0x25
  8007f6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	89 f8                	mov    %edi,%eax
  8007fd:	eb 03                	jmp    800802 <vprintfmt+0x52a>
  8007ff:	83 e8 01             	sub    $0x1,%eax
  800802:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800806:	75 f7                	jne    8007ff <vprintfmt+0x527>
  800808:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080b:	e9 90 fe ff ff       	jmp    8006a0 <vprintfmt+0x3c8>
}
  800810:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800813:	5b                   	pop    %ebx
  800814:	5e                   	pop    %esi
  800815:	5f                   	pop    %edi
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	83 ec 18             	sub    $0x18,%esp
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800824:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800827:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80082b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80082e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800835:	85 c0                	test   %eax,%eax
  800837:	74 26                	je     80085f <vsnprintf+0x47>
  800839:	85 d2                	test   %edx,%edx
  80083b:	7e 22                	jle    80085f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80083d:	ff 75 14             	pushl  0x14(%ebp)
  800840:	ff 75 10             	pushl  0x10(%ebp)
  800843:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800846:	50                   	push   %eax
  800847:	68 9e 02 80 00       	push   $0x80029e
  80084c:	e8 87 fa ff ff       	call   8002d8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800854:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085a:	83 c4 10             	add    $0x10,%esp
}
  80085d:	c9                   	leave  
  80085e:	c3                   	ret    
		return -E_INVAL;
  80085f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800864:	eb f7                	jmp    80085d <vsnprintf+0x45>

00800866 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80086f:	50                   	push   %eax
  800870:	ff 75 10             	pushl  0x10(%ebp)
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	ff 75 08             	pushl  0x8(%ebp)
  800879:	e8 9a ff ff ff       	call   800818 <vsnprintf>
	va_end(ap);

	return rc;
}
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800886:	b8 00 00 00 00       	mov    $0x0,%eax
  80088b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80088f:	74 05                	je     800896 <strlen+0x16>
		n++;
  800891:	83 c0 01             	add    $0x1,%eax
  800894:	eb f5                	jmp    80088b <strlen+0xb>
	return n;
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	74 0d                	je     8008b7 <strnlen+0x1f>
  8008aa:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ae:	74 05                	je     8008b5 <strnlen+0x1d>
		n++;
  8008b0:	83 c2 01             	add    $0x1,%edx
  8008b3:	eb f1                	jmp    8008a6 <strnlen+0xe>
  8008b5:	89 d0                	mov    %edx,%eax
	return n;
}
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	53                   	push   %ebx
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008cf:	83 c2 01             	add    $0x1,%edx
  8008d2:	84 c9                	test   %cl,%cl
  8008d4:	75 f2                	jne    8008c8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008d6:	5b                   	pop    %ebx
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	53                   	push   %ebx
  8008dd:	83 ec 10             	sub    $0x10,%esp
  8008e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e3:	53                   	push   %ebx
  8008e4:	e8 97 ff ff ff       	call   800880 <strlen>
  8008e9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	01 d8                	add    %ebx,%eax
  8008f1:	50                   	push   %eax
  8008f2:	e8 c2 ff ff ff       	call   8008b9 <strcpy>
	return dst;
}
  8008f7:	89 d8                	mov    %ebx,%eax
  8008f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	56                   	push   %esi
  800902:	53                   	push   %ebx
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800909:	89 c6                	mov    %eax,%esi
  80090b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80090e:	89 c2                	mov    %eax,%edx
  800910:	39 f2                	cmp    %esi,%edx
  800912:	74 11                	je     800925 <strncpy+0x27>
		*dst++ = *src;
  800914:	83 c2 01             	add    $0x1,%edx
  800917:	0f b6 19             	movzbl (%ecx),%ebx
  80091a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80091d:	80 fb 01             	cmp    $0x1,%bl
  800920:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800923:	eb eb                	jmp    800910 <strncpy+0x12>
	}
	return ret;
}
  800925:	5b                   	pop    %ebx
  800926:	5e                   	pop    %esi
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	56                   	push   %esi
  80092d:	53                   	push   %ebx
  80092e:	8b 75 08             	mov    0x8(%ebp),%esi
  800931:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800934:	8b 55 10             	mov    0x10(%ebp),%edx
  800937:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800939:	85 d2                	test   %edx,%edx
  80093b:	74 21                	je     80095e <strlcpy+0x35>
  80093d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800941:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800943:	39 c2                	cmp    %eax,%edx
  800945:	74 14                	je     80095b <strlcpy+0x32>
  800947:	0f b6 19             	movzbl (%ecx),%ebx
  80094a:	84 db                	test   %bl,%bl
  80094c:	74 0b                	je     800959 <strlcpy+0x30>
			*dst++ = *src++;
  80094e:	83 c1 01             	add    $0x1,%ecx
  800951:	83 c2 01             	add    $0x1,%edx
  800954:	88 5a ff             	mov    %bl,-0x1(%edx)
  800957:	eb ea                	jmp    800943 <strlcpy+0x1a>
  800959:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80095b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80095e:	29 f0                	sub    %esi,%eax
}
  800960:	5b                   	pop    %ebx
  800961:	5e                   	pop    %esi
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80096d:	0f b6 01             	movzbl (%ecx),%eax
  800970:	84 c0                	test   %al,%al
  800972:	74 0c                	je     800980 <strcmp+0x1c>
  800974:	3a 02                	cmp    (%edx),%al
  800976:	75 08                	jne    800980 <strcmp+0x1c>
		p++, q++;
  800978:	83 c1 01             	add    $0x1,%ecx
  80097b:	83 c2 01             	add    $0x1,%edx
  80097e:	eb ed                	jmp    80096d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800980:	0f b6 c0             	movzbl %al,%eax
  800983:	0f b6 12             	movzbl (%edx),%edx
  800986:	29 d0                	sub    %edx,%eax
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	53                   	push   %ebx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
  800994:	89 c3                	mov    %eax,%ebx
  800996:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800999:	eb 06                	jmp    8009a1 <strncmp+0x17>
		n--, p++, q++;
  80099b:	83 c0 01             	add    $0x1,%eax
  80099e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009a1:	39 d8                	cmp    %ebx,%eax
  8009a3:	74 16                	je     8009bb <strncmp+0x31>
  8009a5:	0f b6 08             	movzbl (%eax),%ecx
  8009a8:	84 c9                	test   %cl,%cl
  8009aa:	74 04                	je     8009b0 <strncmp+0x26>
  8009ac:	3a 0a                	cmp    (%edx),%cl
  8009ae:	74 eb                	je     80099b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b0:	0f b6 00             	movzbl (%eax),%eax
  8009b3:	0f b6 12             	movzbl (%edx),%edx
  8009b6:	29 d0                	sub    %edx,%eax
}
  8009b8:	5b                   	pop    %ebx
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    
		return 0;
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c0:	eb f6                	jmp    8009b8 <strncmp+0x2e>

008009c2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009cc:	0f b6 10             	movzbl (%eax),%edx
  8009cf:	84 d2                	test   %dl,%dl
  8009d1:	74 09                	je     8009dc <strchr+0x1a>
		if (*s == c)
  8009d3:	38 ca                	cmp    %cl,%dl
  8009d5:	74 0a                	je     8009e1 <strchr+0x1f>
	for (; *s; s++)
  8009d7:	83 c0 01             	add    $0x1,%eax
  8009da:	eb f0                	jmp    8009cc <strchr+0xa>
			return (char *) s;
	return 0;
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ed:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009f0:	38 ca                	cmp    %cl,%dl
  8009f2:	74 09                	je     8009fd <strfind+0x1a>
  8009f4:	84 d2                	test   %dl,%dl
  8009f6:	74 05                	je     8009fd <strfind+0x1a>
	for (; *s; s++)
  8009f8:	83 c0 01             	add    $0x1,%eax
  8009fb:	eb f0                	jmp    8009ed <strfind+0xa>
			break;
	return (char *) s;
}
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	57                   	push   %edi
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a0b:	85 c9                	test   %ecx,%ecx
  800a0d:	74 31                	je     800a40 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0f:	89 f8                	mov    %edi,%eax
  800a11:	09 c8                	or     %ecx,%eax
  800a13:	a8 03                	test   $0x3,%al
  800a15:	75 23                	jne    800a3a <memset+0x3b>
		c &= 0xFF;
  800a17:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1b:	89 d3                	mov    %edx,%ebx
  800a1d:	c1 e3 08             	shl    $0x8,%ebx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	c1 e0 18             	shl    $0x18,%eax
  800a25:	89 d6                	mov    %edx,%esi
  800a27:	c1 e6 10             	shl    $0x10,%esi
  800a2a:	09 f0                	or     %esi,%eax
  800a2c:	09 c2                	or     %eax,%edx
  800a2e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a30:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a33:	89 d0                	mov    %edx,%eax
  800a35:	fc                   	cld    
  800a36:	f3 ab                	rep stos %eax,%es:(%edi)
  800a38:	eb 06                	jmp    800a40 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	fc                   	cld    
  800a3e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a40:	89 f8                	mov    %edi,%eax
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5f                   	pop    %edi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	57                   	push   %edi
  800a4b:	56                   	push   %esi
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a52:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a55:	39 c6                	cmp    %eax,%esi
  800a57:	73 32                	jae    800a8b <memmove+0x44>
  800a59:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5c:	39 c2                	cmp    %eax,%edx
  800a5e:	76 2b                	jbe    800a8b <memmove+0x44>
		s += n;
		d += n;
  800a60:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a63:	89 fe                	mov    %edi,%esi
  800a65:	09 ce                	or     %ecx,%esi
  800a67:	09 d6                	or     %edx,%esi
  800a69:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6f:	75 0e                	jne    800a7f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a71:	83 ef 04             	sub    $0x4,%edi
  800a74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a77:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7a:	fd                   	std    
  800a7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7d:	eb 09                	jmp    800a88 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a7f:	83 ef 01             	sub    $0x1,%edi
  800a82:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a85:	fd                   	std    
  800a86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a88:	fc                   	cld    
  800a89:	eb 1a                	jmp    800aa5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8b:	89 c2                	mov    %eax,%edx
  800a8d:	09 ca                	or     %ecx,%edx
  800a8f:	09 f2                	or     %esi,%edx
  800a91:	f6 c2 03             	test   $0x3,%dl
  800a94:	75 0a                	jne    800aa0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a96:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a99:	89 c7                	mov    %eax,%edi
  800a9b:	fc                   	cld    
  800a9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9e:	eb 05                	jmp    800aa5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aa0:	89 c7                	mov    %eax,%edi
  800aa2:	fc                   	cld    
  800aa3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa5:	5e                   	pop    %esi
  800aa6:	5f                   	pop    %edi
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aaf:	ff 75 10             	pushl  0x10(%ebp)
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	ff 75 08             	pushl  0x8(%ebp)
  800ab8:	e8 8a ff ff ff       	call   800a47 <memmove>
}
  800abd:	c9                   	leave  
  800abe:	c3                   	ret    

00800abf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	56                   	push   %esi
  800ac3:	53                   	push   %ebx
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aca:	89 c6                	mov    %eax,%esi
  800acc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acf:	39 f0                	cmp    %esi,%eax
  800ad1:	74 1c                	je     800aef <memcmp+0x30>
		if (*s1 != *s2)
  800ad3:	0f b6 08             	movzbl (%eax),%ecx
  800ad6:	0f b6 1a             	movzbl (%edx),%ebx
  800ad9:	38 d9                	cmp    %bl,%cl
  800adb:	75 08                	jne    800ae5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800add:	83 c0 01             	add    $0x1,%eax
  800ae0:	83 c2 01             	add    $0x1,%edx
  800ae3:	eb ea                	jmp    800acf <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ae5:	0f b6 c1             	movzbl %cl,%eax
  800ae8:	0f b6 db             	movzbl %bl,%ebx
  800aeb:	29 d8                	sub    %ebx,%eax
  800aed:	eb 05                	jmp    800af4 <memcmp+0x35>
	}

	return 0;
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b01:	89 c2                	mov    %eax,%edx
  800b03:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b06:	39 d0                	cmp    %edx,%eax
  800b08:	73 09                	jae    800b13 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b0a:	38 08                	cmp    %cl,(%eax)
  800b0c:	74 05                	je     800b13 <memfind+0x1b>
	for (; s < ends; s++)
  800b0e:	83 c0 01             	add    $0x1,%eax
  800b11:	eb f3                	jmp    800b06 <memfind+0xe>
			break;
	return (void *) s;
}
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	57                   	push   %edi
  800b19:	56                   	push   %esi
  800b1a:	53                   	push   %ebx
  800b1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b21:	eb 03                	jmp    800b26 <strtol+0x11>
		s++;
  800b23:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b26:	0f b6 01             	movzbl (%ecx),%eax
  800b29:	3c 20                	cmp    $0x20,%al
  800b2b:	74 f6                	je     800b23 <strtol+0xe>
  800b2d:	3c 09                	cmp    $0x9,%al
  800b2f:	74 f2                	je     800b23 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b31:	3c 2b                	cmp    $0x2b,%al
  800b33:	74 2a                	je     800b5f <strtol+0x4a>
	int neg = 0;
  800b35:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b3a:	3c 2d                	cmp    $0x2d,%al
  800b3c:	74 2b                	je     800b69 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b44:	75 0f                	jne    800b55 <strtol+0x40>
  800b46:	80 39 30             	cmpb   $0x30,(%ecx)
  800b49:	74 28                	je     800b73 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b52:	0f 44 d8             	cmove  %eax,%ebx
  800b55:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b5d:	eb 50                	jmp    800baf <strtol+0x9a>
		s++;
  800b5f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b62:	bf 00 00 00 00       	mov    $0x0,%edi
  800b67:	eb d5                	jmp    800b3e <strtol+0x29>
		s++, neg = 1;
  800b69:	83 c1 01             	add    $0x1,%ecx
  800b6c:	bf 01 00 00 00       	mov    $0x1,%edi
  800b71:	eb cb                	jmp    800b3e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b73:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b77:	74 0e                	je     800b87 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	75 d8                	jne    800b55 <strtol+0x40>
		s++, base = 8;
  800b7d:	83 c1 01             	add    $0x1,%ecx
  800b80:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b85:	eb ce                	jmp    800b55 <strtol+0x40>
		s += 2, base = 16;
  800b87:	83 c1 02             	add    $0x2,%ecx
  800b8a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b8f:	eb c4                	jmp    800b55 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b91:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b94:	89 f3                	mov    %esi,%ebx
  800b96:	80 fb 19             	cmp    $0x19,%bl
  800b99:	77 29                	ja     800bc4 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b9b:	0f be d2             	movsbl %dl,%edx
  800b9e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ba4:	7d 30                	jge    800bd6 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ba6:	83 c1 01             	add    $0x1,%ecx
  800ba9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bad:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800baf:	0f b6 11             	movzbl (%ecx),%edx
  800bb2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bb5:	89 f3                	mov    %esi,%ebx
  800bb7:	80 fb 09             	cmp    $0x9,%bl
  800bba:	77 d5                	ja     800b91 <strtol+0x7c>
			dig = *s - '0';
  800bbc:	0f be d2             	movsbl %dl,%edx
  800bbf:	83 ea 30             	sub    $0x30,%edx
  800bc2:	eb dd                	jmp    800ba1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bc4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bc7:	89 f3                	mov    %esi,%ebx
  800bc9:	80 fb 19             	cmp    $0x19,%bl
  800bcc:	77 08                	ja     800bd6 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bce:	0f be d2             	movsbl %dl,%edx
  800bd1:	83 ea 37             	sub    $0x37,%edx
  800bd4:	eb cb                	jmp    800ba1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bda:	74 05                	je     800be1 <strtol+0xcc>
		*endptr = (char *) s;
  800bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bdf:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800be1:	89 c2                	mov    %eax,%edx
  800be3:	f7 da                	neg    %edx
  800be5:	85 ff                	test   %edi,%edi
  800be7:	0f 45 c2             	cmovne %edx,%eax
}
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c00:	89 c3                	mov    %eax,%ebx
  800c02:	89 c7                	mov    %eax,%edi
  800c04:	89 c6                	mov    %eax,%esi
  800c06:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	57                   	push   %edi
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c13:	ba 00 00 00 00       	mov    $0x0,%edx
  800c18:	b8 01 00 00 00       	mov    $0x1,%eax
  800c1d:	89 d1                	mov    %edx,%ecx
  800c1f:	89 d3                	mov    %edx,%ebx
  800c21:	89 d7                	mov    %edx,%edi
  800c23:	89 d6                	mov    %edx,%esi
  800c25:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c42:	89 cb                	mov    %ecx,%ebx
  800c44:	89 cf                	mov    %ecx,%edi
  800c46:	89 ce                	mov    %ecx,%esi
  800c48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	7f 08                	jg     800c56 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	6a 03                	push   $0x3
  800c5c:	68 80 15 80 00       	push   $0x801580
  800c61:	6a 33                	push   $0x33
  800c63:	68 9d 15 80 00       	push   $0x80159d
  800c68:	e8 b1 02 00 00       	call   800f1e <_panic>

00800c6d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c73:	ba 00 00 00 00       	mov    $0x0,%edx
  800c78:	b8 02 00 00 00       	mov    $0x2,%eax
  800c7d:	89 d1                	mov    %edx,%ecx
  800c7f:	89 d3                	mov    %edx,%ebx
  800c81:	89 d7                	mov    %edx,%edi
  800c83:	89 d6                	mov    %edx,%esi
  800c85:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_yield>:

void
sys_yield(void)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c92:	ba 00 00 00 00       	mov    $0x0,%edx
  800c97:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c9c:	89 d1                	mov    %edx,%ecx
  800c9e:	89 d3                	mov    %edx,%ebx
  800ca0:	89 d7                	mov    %edx,%edi
  800ca2:	89 d6                	mov    %edx,%esi
  800ca4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb4:	be 00 00 00 00       	mov    $0x0,%esi
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbf:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc7:	89 f7                	mov    %esi,%edi
  800cc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	7f 08                	jg     800cd7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	83 ec 0c             	sub    $0xc,%esp
  800cda:	50                   	push   %eax
  800cdb:	6a 04                	push   $0x4
  800cdd:	68 80 15 80 00       	push   $0x801580
  800ce2:	6a 33                	push   $0x33
  800ce4:	68 9d 15 80 00       	push   $0x80159d
  800ce9:	e8 30 02 00 00       	call   800f1e <_panic>

00800cee <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	b8 05 00 00 00       	mov    $0x5,%eax
  800d02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d05:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d08:	8b 75 18             	mov    0x18(%ebp),%esi
  800d0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	7f 08                	jg     800d19 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	50                   	push   %eax
  800d1d:	6a 05                	push   $0x5
  800d1f:	68 80 15 80 00       	push   $0x801580
  800d24:	6a 33                	push   $0x33
  800d26:	68 9d 15 80 00       	push   $0x80159d
  800d2b:	e8 ee 01 00 00       	call   800f1e <_panic>

00800d30 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	b8 06 00 00 00       	mov    $0x6,%eax
  800d49:	89 df                	mov    %ebx,%edi
  800d4b:	89 de                	mov    %ebx,%esi
  800d4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7f 08                	jg     800d5b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5b:	83 ec 0c             	sub    $0xc,%esp
  800d5e:	50                   	push   %eax
  800d5f:	6a 06                	push   $0x6
  800d61:	68 80 15 80 00       	push   $0x801580
  800d66:	6a 33                	push   $0x33
  800d68:	68 9d 15 80 00       	push   $0x80159d
  800d6d:	e8 ac 01 00 00       	call   800f1e <_panic>

00800d72 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d88:	89 cb                	mov    %ecx,%ebx
  800d8a:	89 cf                	mov    %ecx,%edi
  800d8c:	89 ce                	mov    %ecx,%esi
  800d8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 0b                	push   $0xb
  800da2:	68 80 15 80 00       	push   $0x801580
  800da7:	6a 33                	push   $0x33
  800da9:	68 9d 15 80 00       	push   $0x80159d
  800dae:	e8 6b 01 00 00       	call   800f1e <_panic>

00800db3 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 08 00 00 00       	mov    $0x8,%eax
  800dcc:	89 df                	mov    %ebx,%edi
  800dce:	89 de                	mov    %ebx,%esi
  800dd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7f 08                	jg     800dde <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dde:	83 ec 0c             	sub    $0xc,%esp
  800de1:	50                   	push   %eax
  800de2:	6a 08                	push   $0x8
  800de4:	68 80 15 80 00       	push   $0x801580
  800de9:	6a 33                	push   $0x33
  800deb:	68 9d 15 80 00       	push   $0x80159d
  800df0:	e8 29 01 00 00       	call   800f1e <_panic>

00800df5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0e:	89 df                	mov    %ebx,%edi
  800e10:	89 de                	mov    %ebx,%esi
  800e12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	7f 08                	jg     800e20 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	50                   	push   %eax
  800e24:	6a 09                	push   $0x9
  800e26:	68 80 15 80 00       	push   $0x801580
  800e2b:	6a 33                	push   $0x33
  800e2d:	68 9d 15 80 00       	push   $0x80159d
  800e32:	e8 e7 00 00 00       	call   800f1e <_panic>

00800e37 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e50:	89 df                	mov    %ebx,%edi
  800e52:	89 de                	mov    %ebx,%esi
  800e54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e56:	85 c0                	test   %eax,%eax
  800e58:	7f 08                	jg     800e62 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	50                   	push   %eax
  800e66:	6a 0a                	push   $0xa
  800e68:	68 80 15 80 00       	push   $0x801580
  800e6d:	6a 33                	push   $0x33
  800e6f:	68 9d 15 80 00       	push   $0x80159d
  800e74:	e8 a5 00 00 00       	call   800f1e <_panic>

00800e79 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e8a:	be 00 00 00 00       	mov    $0x0,%esi
  800e8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e92:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e95:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
  800ea2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ead:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb2:	89 cb                	mov    %ecx,%ebx
  800eb4:	89 cf                	mov    %ecx,%edi
  800eb6:	89 ce                	mov    %ecx,%esi
  800eb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	7f 08                	jg     800ec6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec1:	5b                   	pop    %ebx
  800ec2:	5e                   	pop    %esi
  800ec3:	5f                   	pop    %edi
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec6:	83 ec 0c             	sub    $0xc,%esp
  800ec9:	50                   	push   %eax
  800eca:	6a 0e                	push   $0xe
  800ecc:	68 80 15 80 00       	push   $0x801580
  800ed1:	6a 33                	push   $0x33
  800ed3:	68 9d 15 80 00       	push   $0x80159d
  800ed8:	e8 41 00 00 00       	call   800f1e <_panic>

00800edd <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ef3:	89 df                	mov    %ebx,%edi
  800ef5:	89 de                	mov    %ebx,%esi
  800ef7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    

00800efe <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	b8 10 00 00 00       	mov    $0x10,%eax
  800f11:	89 cb                	mov    %ecx,%ebx
  800f13:	89 cf                	mov    %ecx,%edi
  800f15:	89 ce                	mov    %ecx,%esi
  800f17:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    

00800f1e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800f23:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f26:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f2c:	e8 3c fd ff ff       	call   800c6d <sys_getenvid>
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	ff 75 0c             	pushl  0xc(%ebp)
  800f37:	ff 75 08             	pushl  0x8(%ebp)
  800f3a:	56                   	push   %esi
  800f3b:	50                   	push   %eax
  800f3c:	68 ac 15 80 00       	push   $0x8015ac
  800f41:	e8 65 f2 ff ff       	call   8001ab <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f46:	83 c4 18             	add    $0x18,%esp
  800f49:	53                   	push   %ebx
  800f4a:	ff 75 10             	pushl  0x10(%ebp)
  800f4d:	e8 08 f2 ff ff       	call   80015a <vcprintf>
	cprintf("\n");
  800f52:	c7 04 24 ed 11 80 00 	movl   $0x8011ed,(%esp)
  800f59:	e8 4d f2 ff ff       	call   8001ab <cprintf>
  800f5e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f61:	cc                   	int3   
  800f62:	eb fd                	jmp    800f61 <_panic+0x43>
  800f64:	66 90                	xchg   %ax,%ax
  800f66:	66 90                	xchg   %ax,%ax
  800f68:	66 90                	xchg   %ax,%ax
  800f6a:	66 90                	xchg   %ax,%ax
  800f6c:	66 90                	xchg   %ax,%ax
  800f6e:	66 90                	xchg   %ax,%ax

00800f70 <__udivdi3>:
  800f70:	55                   	push   %ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 1c             	sub    $0x1c,%esp
  800f77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f87:	85 d2                	test   %edx,%edx
  800f89:	75 4d                	jne    800fd8 <__udivdi3+0x68>
  800f8b:	39 f3                	cmp    %esi,%ebx
  800f8d:	76 19                	jbe    800fa8 <__udivdi3+0x38>
  800f8f:	31 ff                	xor    %edi,%edi
  800f91:	89 e8                	mov    %ebp,%eax
  800f93:	89 f2                	mov    %esi,%edx
  800f95:	f7 f3                	div    %ebx
  800f97:	89 fa                	mov    %edi,%edx
  800f99:	83 c4 1c             	add    $0x1c,%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    
  800fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa8:	89 d9                	mov    %ebx,%ecx
  800faa:	85 db                	test   %ebx,%ebx
  800fac:	75 0b                	jne    800fb9 <__udivdi3+0x49>
  800fae:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb3:	31 d2                	xor    %edx,%edx
  800fb5:	f7 f3                	div    %ebx
  800fb7:	89 c1                	mov    %eax,%ecx
  800fb9:	31 d2                	xor    %edx,%edx
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	f7 f1                	div    %ecx
  800fbf:	89 c6                	mov    %eax,%esi
  800fc1:	89 e8                	mov    %ebp,%eax
  800fc3:	89 f7                	mov    %esi,%edi
  800fc5:	f7 f1                	div    %ecx
  800fc7:	89 fa                	mov    %edi,%edx
  800fc9:	83 c4 1c             	add    $0x1c,%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
  800fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	39 f2                	cmp    %esi,%edx
  800fda:	77 1c                	ja     800ff8 <__udivdi3+0x88>
  800fdc:	0f bd fa             	bsr    %edx,%edi
  800fdf:	83 f7 1f             	xor    $0x1f,%edi
  800fe2:	75 2c                	jne    801010 <__udivdi3+0xa0>
  800fe4:	39 f2                	cmp    %esi,%edx
  800fe6:	72 06                	jb     800fee <__udivdi3+0x7e>
  800fe8:	31 c0                	xor    %eax,%eax
  800fea:	39 eb                	cmp    %ebp,%ebx
  800fec:	77 a9                	ja     800f97 <__udivdi3+0x27>
  800fee:	b8 01 00 00 00       	mov    $0x1,%eax
  800ff3:	eb a2                	jmp    800f97 <__udivdi3+0x27>
  800ff5:	8d 76 00             	lea    0x0(%esi),%esi
  800ff8:	31 ff                	xor    %edi,%edi
  800ffa:	31 c0                	xor    %eax,%eax
  800ffc:	89 fa                	mov    %edi,%edx
  800ffe:	83 c4 1c             	add    $0x1c,%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
  801006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80100d:	8d 76 00             	lea    0x0(%esi),%esi
  801010:	89 f9                	mov    %edi,%ecx
  801012:	b8 20 00 00 00       	mov    $0x20,%eax
  801017:	29 f8                	sub    %edi,%eax
  801019:	d3 e2                	shl    %cl,%edx
  80101b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80101f:	89 c1                	mov    %eax,%ecx
  801021:	89 da                	mov    %ebx,%edx
  801023:	d3 ea                	shr    %cl,%edx
  801025:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801029:	09 d1                	or     %edx,%ecx
  80102b:	89 f2                	mov    %esi,%edx
  80102d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801031:	89 f9                	mov    %edi,%ecx
  801033:	d3 e3                	shl    %cl,%ebx
  801035:	89 c1                	mov    %eax,%ecx
  801037:	d3 ea                	shr    %cl,%edx
  801039:	89 f9                	mov    %edi,%ecx
  80103b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80103f:	89 eb                	mov    %ebp,%ebx
  801041:	d3 e6                	shl    %cl,%esi
  801043:	89 c1                	mov    %eax,%ecx
  801045:	d3 eb                	shr    %cl,%ebx
  801047:	09 de                	or     %ebx,%esi
  801049:	89 f0                	mov    %esi,%eax
  80104b:	f7 74 24 08          	divl   0x8(%esp)
  80104f:	89 d6                	mov    %edx,%esi
  801051:	89 c3                	mov    %eax,%ebx
  801053:	f7 64 24 0c          	mull   0xc(%esp)
  801057:	39 d6                	cmp    %edx,%esi
  801059:	72 15                	jb     801070 <__udivdi3+0x100>
  80105b:	89 f9                	mov    %edi,%ecx
  80105d:	d3 e5                	shl    %cl,%ebp
  80105f:	39 c5                	cmp    %eax,%ebp
  801061:	73 04                	jae    801067 <__udivdi3+0xf7>
  801063:	39 d6                	cmp    %edx,%esi
  801065:	74 09                	je     801070 <__udivdi3+0x100>
  801067:	89 d8                	mov    %ebx,%eax
  801069:	31 ff                	xor    %edi,%edi
  80106b:	e9 27 ff ff ff       	jmp    800f97 <__udivdi3+0x27>
  801070:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801073:	31 ff                	xor    %edi,%edi
  801075:	e9 1d ff ff ff       	jmp    800f97 <__udivdi3+0x27>
  80107a:	66 90                	xchg   %ax,%ax
  80107c:	66 90                	xchg   %ax,%ax
  80107e:	66 90                	xchg   %ax,%ax

00801080 <__umoddi3>:
  801080:	55                   	push   %ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 1c             	sub    $0x1c,%esp
  801087:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80108b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80108f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801097:	89 da                	mov    %ebx,%edx
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 43                	jne    8010e0 <__umoddi3+0x60>
  80109d:	39 df                	cmp    %ebx,%edi
  80109f:	76 17                	jbe    8010b8 <__umoddi3+0x38>
  8010a1:	89 f0                	mov    %esi,%eax
  8010a3:	f7 f7                	div    %edi
  8010a5:	89 d0                	mov    %edx,%eax
  8010a7:	31 d2                	xor    %edx,%edx
  8010a9:	83 c4 1c             	add    $0x1c,%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
  8010b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010b8:	89 fd                	mov    %edi,%ebp
  8010ba:	85 ff                	test   %edi,%edi
  8010bc:	75 0b                	jne    8010c9 <__umoddi3+0x49>
  8010be:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f7                	div    %edi
  8010c7:	89 c5                	mov    %eax,%ebp
  8010c9:	89 d8                	mov    %ebx,%eax
  8010cb:	31 d2                	xor    %edx,%edx
  8010cd:	f7 f5                	div    %ebp
  8010cf:	89 f0                	mov    %esi,%eax
  8010d1:	f7 f5                	div    %ebp
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	eb d0                	jmp    8010a7 <__umoddi3+0x27>
  8010d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010de:	66 90                	xchg   %ax,%ax
  8010e0:	89 f1                	mov    %esi,%ecx
  8010e2:	39 d8                	cmp    %ebx,%eax
  8010e4:	76 0a                	jbe    8010f0 <__umoddi3+0x70>
  8010e6:	89 f0                	mov    %esi,%eax
  8010e8:	83 c4 1c             	add    $0x1c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
  8010f0:	0f bd e8             	bsr    %eax,%ebp
  8010f3:	83 f5 1f             	xor    $0x1f,%ebp
  8010f6:	75 20                	jne    801118 <__umoddi3+0x98>
  8010f8:	39 d8                	cmp    %ebx,%eax
  8010fa:	0f 82 b0 00 00 00    	jb     8011b0 <__umoddi3+0x130>
  801100:	39 f7                	cmp    %esi,%edi
  801102:	0f 86 a8 00 00 00    	jbe    8011b0 <__umoddi3+0x130>
  801108:	89 c8                	mov    %ecx,%eax
  80110a:	83 c4 1c             	add    $0x1c,%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
  801112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801118:	89 e9                	mov    %ebp,%ecx
  80111a:	ba 20 00 00 00       	mov    $0x20,%edx
  80111f:	29 ea                	sub    %ebp,%edx
  801121:	d3 e0                	shl    %cl,%eax
  801123:	89 44 24 08          	mov    %eax,0x8(%esp)
  801127:	89 d1                	mov    %edx,%ecx
  801129:	89 f8                	mov    %edi,%eax
  80112b:	d3 e8                	shr    %cl,%eax
  80112d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801131:	89 54 24 04          	mov    %edx,0x4(%esp)
  801135:	8b 54 24 04          	mov    0x4(%esp),%edx
  801139:	09 c1                	or     %eax,%ecx
  80113b:	89 d8                	mov    %ebx,%eax
  80113d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801141:	89 e9                	mov    %ebp,%ecx
  801143:	d3 e7                	shl    %cl,%edi
  801145:	89 d1                	mov    %edx,%ecx
  801147:	d3 e8                	shr    %cl,%eax
  801149:	89 e9                	mov    %ebp,%ecx
  80114b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80114f:	d3 e3                	shl    %cl,%ebx
  801151:	89 c7                	mov    %eax,%edi
  801153:	89 d1                	mov    %edx,%ecx
  801155:	89 f0                	mov    %esi,%eax
  801157:	d3 e8                	shr    %cl,%eax
  801159:	89 e9                	mov    %ebp,%ecx
  80115b:	89 fa                	mov    %edi,%edx
  80115d:	d3 e6                	shl    %cl,%esi
  80115f:	09 d8                	or     %ebx,%eax
  801161:	f7 74 24 08          	divl   0x8(%esp)
  801165:	89 d1                	mov    %edx,%ecx
  801167:	89 f3                	mov    %esi,%ebx
  801169:	f7 64 24 0c          	mull   0xc(%esp)
  80116d:	89 c6                	mov    %eax,%esi
  80116f:	89 d7                	mov    %edx,%edi
  801171:	39 d1                	cmp    %edx,%ecx
  801173:	72 06                	jb     80117b <__umoddi3+0xfb>
  801175:	75 10                	jne    801187 <__umoddi3+0x107>
  801177:	39 c3                	cmp    %eax,%ebx
  801179:	73 0c                	jae    801187 <__umoddi3+0x107>
  80117b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80117f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801183:	89 d7                	mov    %edx,%edi
  801185:	89 c6                	mov    %eax,%esi
  801187:	89 ca                	mov    %ecx,%edx
  801189:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80118e:	29 f3                	sub    %esi,%ebx
  801190:	19 fa                	sbb    %edi,%edx
  801192:	89 d0                	mov    %edx,%eax
  801194:	d3 e0                	shl    %cl,%eax
  801196:	89 e9                	mov    %ebp,%ecx
  801198:	d3 eb                	shr    %cl,%ebx
  80119a:	d3 ea                	shr    %cl,%edx
  80119c:	09 d8                	or     %ebx,%eax
  80119e:	83 c4 1c             	add    $0x1c,%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    
  8011a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011ad:	8d 76 00             	lea    0x0(%esi),%esi
  8011b0:	89 da                	mov    %ebx,%edx
  8011b2:	29 fe                	sub    %edi,%esi
  8011b4:	19 c2                	sbb    %eax,%edx
  8011b6:	89 f1                	mov    %esi,%ecx
  8011b8:	89 c8                	mov    %ecx,%eax
  8011ba:	e9 4b ff ff ff       	jmp    80110a <__umoddi3+0x8a>
