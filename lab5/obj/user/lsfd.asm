
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 60 22 80 00       	push   $0x802260
  80003e:	e8 be 01 00 00       	call   800201 <cprintf>
	exit();
  800043:	e8 12 01 00 00       	call   80015a <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 08 0f 00 00       	call   800f74 <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 1c 0f 00 00       	call   800fa4 <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 f7                	mov    %esi,%edi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8000b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	68 74 22 80 00       	push   $0x802274
  8000c2:	e8 3a 01 00 00       	call   800201 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 bf 14 00 00       	call   80159b <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 ff                	test   %edi,%edi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	pushl  0x4(%eax)
  8000f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	68 74 22 80 00       	push   $0x802274
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 90 18 00 00       	call   801994 <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80011c:	e8 a2 0b 00 00       	call   800cc3 <sys_getenvid>
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800129:	c1 e0 04             	shl    $0x4,%eax
  80012c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800131:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800136:	85 db                	test   %ebx,%ebx
  800138:	7e 07                	jle    800141 <libmain+0x30>
		binaryname = argv[0];
  80013a:	8b 06                	mov    (%esi),%eax
  80013c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
  800146:	e8 02 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  80014b:	e8 0a 00 00 00       	call   80015a <exit>
}
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800156:	5b                   	pop    %ebx
  800157:	5e                   	pop    %esi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800160:	6a 00                	push   $0x0
  800162:	e8 1b 0b 00 00       	call   800c82 <sys_env_destroy>
}
  800167:	83 c4 10             	add    $0x10,%esp
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	53                   	push   %ebx
  800170:	83 ec 04             	sub    $0x4,%esp
  800173:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800176:	8b 13                	mov    (%ebx),%edx
  800178:	8d 42 01             	lea    0x1(%edx),%eax
  80017b:	89 03                	mov    %eax,(%ebx)
  80017d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800180:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800184:	3d ff 00 00 00       	cmp    $0xff,%eax
  800189:	74 09                	je     800194 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800192:	c9                   	leave  
  800193:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	68 ff 00 00 00       	push   $0xff
  80019c:	8d 43 08             	lea    0x8(%ebx),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 a0 0a 00 00       	call   800c45 <sys_cputs>
		b->idx = 0;
  8001a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	eb db                	jmp    80018b <putch+0x1f>

008001b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c0:	00 00 00 
	b.cnt = 0;
  8001c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001cd:	ff 75 0c             	pushl  0xc(%ebp)
  8001d0:	ff 75 08             	pushl  0x8(%ebp)
  8001d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d9:	50                   	push   %eax
  8001da:	68 6c 01 80 00       	push   $0x80016c
  8001df:	e8 4a 01 00 00       	call   80032e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e4:	83 c4 08             	add    $0x8,%esp
  8001e7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ed:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f3:	50                   	push   %eax
  8001f4:	e8 4c 0a 00 00       	call   800c45 <sys_cputs>

	return b.cnt;
}
  8001f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

00800201 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800207:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020a:	50                   	push   %eax
  80020b:	ff 75 08             	pushl  0x8(%ebp)
  80020e:	e8 9d ff ff ff       	call   8001b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800213:	c9                   	leave  
  800214:	c3                   	ret    

00800215 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	57                   	push   %edi
  800219:	56                   	push   %esi
  80021a:	53                   	push   %ebx
  80021b:	83 ec 1c             	sub    $0x1c,%esp
  80021e:	89 c6                	mov    %eax,%esi
  800220:	89 d7                	mov    %edx,%edi
  800222:	8b 45 08             	mov    0x8(%ebp),%eax
  800225:	8b 55 0c             	mov    0xc(%ebp),%edx
  800228:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80022e:	8b 45 10             	mov    0x10(%ebp),%eax
  800231:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800234:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800238:	74 2c                	je     800266 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80023a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800244:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800247:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80024a:	39 c2                	cmp    %eax,%edx
  80024c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80024f:	73 43                	jae    800294 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800251:	83 eb 01             	sub    $0x1,%ebx
  800254:	85 db                	test   %ebx,%ebx
  800256:	7e 6c                	jle    8002c4 <printnum+0xaf>
			putch(padc, putdat);
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	57                   	push   %edi
  80025c:	ff 75 18             	pushl  0x18(%ebp)
  80025f:	ff d6                	call   *%esi
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	eb eb                	jmp    800251 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	6a 20                	push   $0x20
  80026b:	6a 00                	push   $0x0
  80026d:	50                   	push   %eax
  80026e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800271:	ff 75 e0             	pushl  -0x20(%ebp)
  800274:	89 fa                	mov    %edi,%edx
  800276:	89 f0                	mov    %esi,%eax
  800278:	e8 98 ff ff ff       	call   800215 <printnum>
		while (--width > 0)
  80027d:	83 c4 20             	add    $0x20,%esp
  800280:	83 eb 01             	sub    $0x1,%ebx
  800283:	85 db                	test   %ebx,%ebx
  800285:	7e 65                	jle    8002ec <printnum+0xd7>
			putch(padc, putdat);
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	57                   	push   %edi
  80028b:	6a 20                	push   $0x20
  80028d:	ff d6                	call   *%esi
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	eb ec                	jmp    800280 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	ff 75 18             	pushl  0x18(%ebp)
  80029a:	83 eb 01             	sub    $0x1,%ebx
  80029d:	53                   	push   %ebx
  80029e:	50                   	push   %eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ae:	e8 4d 1d 00 00       	call   802000 <__udivdi3>
  8002b3:	83 c4 18             	add    $0x18,%esp
  8002b6:	52                   	push   %edx
  8002b7:	50                   	push   %eax
  8002b8:	89 fa                	mov    %edi,%edx
  8002ba:	89 f0                	mov    %esi,%eax
  8002bc:	e8 54 ff ff ff       	call   800215 <printnum>
  8002c1:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	57                   	push   %edi
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d7:	e8 34 1e 00 00       	call   802110 <__umoddi3>
  8002dc:	83 c4 14             	add    $0x14,%esp
  8002df:	0f be 80 a6 22 80 00 	movsbl 0x8022a6(%eax),%eax
  8002e6:	50                   	push   %eax
  8002e7:	ff d6                	call   *%esi
  8002e9:	83 c4 10             	add    $0x10,%esp
}
  8002ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ef:	5b                   	pop    %ebx
  8002f0:	5e                   	pop    %esi
  8002f1:	5f                   	pop    %edi
  8002f2:	5d                   	pop    %ebp
  8002f3:	c3                   	ret    

008002f4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fe:	8b 10                	mov    (%eax),%edx
  800300:	3b 50 04             	cmp    0x4(%eax),%edx
  800303:	73 0a                	jae    80030f <sprintputch+0x1b>
		*b->buf++ = ch;
  800305:	8d 4a 01             	lea    0x1(%edx),%ecx
  800308:	89 08                	mov    %ecx,(%eax)
  80030a:	8b 45 08             	mov    0x8(%ebp),%eax
  80030d:	88 02                	mov    %al,(%edx)
}
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <printfmt>:
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800317:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031a:	50                   	push   %eax
  80031b:	ff 75 10             	pushl  0x10(%ebp)
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	e8 05 00 00 00       	call   80032e <vprintfmt>
}
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <vprintfmt>:
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	57                   	push   %edi
  800332:	56                   	push   %esi
  800333:	53                   	push   %ebx
  800334:	83 ec 3c             	sub    $0x3c,%esp
  800337:	8b 75 08             	mov    0x8(%ebp),%esi
  80033a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800340:	e9 b4 03 00 00       	jmp    8006f9 <vprintfmt+0x3cb>
		padc = ' ';
  800345:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800349:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800350:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800357:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800365:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8d 47 01             	lea    0x1(%edi),%eax
  80036d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800370:	0f b6 17             	movzbl (%edi),%edx
  800373:	8d 42 dd             	lea    -0x23(%edx),%eax
  800376:	3c 55                	cmp    $0x55,%al
  800378:	0f 87 c8 04 00 00    	ja     800846 <vprintfmt+0x518>
  80037e:	0f b6 c0             	movzbl %al,%eax
  800381:	ff 24 85 80 24 80 00 	jmp    *0x802480(,%eax,4)
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80038b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800392:	eb d6                	jmp    80036a <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800397:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80039b:	eb cd                	jmp    80036a <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	0f b6 d2             	movzbl %dl,%edx
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8003ab:	eb 0c                	jmp    8003b9 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003b0:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003b4:	eb b4                	jmp    80036a <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8003b6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003bc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003c6:	83 f9 09             	cmp    $0x9,%ecx
  8003c9:	76 eb                	jbe    8003b6 <vprintfmt+0x88>
  8003cb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d1:	eb 14                	jmp    8003e7 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8d 40 04             	lea    0x4(%eax),%eax
  8003e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003eb:	0f 89 79 ff ff ff    	jns    80036a <vprintfmt+0x3c>
				width = precision, precision = -1;
  8003f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003fe:	e9 67 ff ff ff       	jmp    80036a <vprintfmt+0x3c>
  800403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800406:	85 c0                	test   %eax,%eax
  800408:	ba 00 00 00 00       	mov    $0x0,%edx
  80040d:	0f 49 d0             	cmovns %eax,%edx
  800410:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800416:	e9 4f ff ff ff       	jmp    80036a <vprintfmt+0x3c>
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80041e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800425:	e9 40 ff ff ff       	jmp    80036a <vprintfmt+0x3c>
			lflag++;
  80042a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80042d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800430:	e9 35 ff ff ff       	jmp    80036a <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800435:	8b 45 14             	mov    0x14(%ebp),%eax
  800438:	8d 78 04             	lea    0x4(%eax),%edi
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	53                   	push   %ebx
  80043f:	ff 30                	pushl  (%eax)
  800441:	ff d6                	call   *%esi
			break;
  800443:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800446:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800449:	e9 a8 02 00 00       	jmp    8006f6 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80044e:	8b 45 14             	mov    0x14(%ebp),%eax
  800451:	8d 78 04             	lea    0x4(%eax),%edi
  800454:	8b 00                	mov    (%eax),%eax
  800456:	99                   	cltd   
  800457:	31 d0                	xor    %edx,%eax
  800459:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045b:	83 f8 0f             	cmp    $0xf,%eax
  80045e:	7f 23                	jg     800483 <vprintfmt+0x155>
  800460:	8b 14 85 e0 25 80 00 	mov    0x8025e0(,%eax,4),%edx
  800467:	85 d2                	test   %edx,%edx
  800469:	74 18                	je     800483 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80046b:	52                   	push   %edx
  80046c:	68 f1 26 80 00       	push   $0x8026f1
  800471:	53                   	push   %ebx
  800472:	56                   	push   %esi
  800473:	e8 99 fe ff ff       	call   800311 <printfmt>
  800478:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80047e:	e9 73 02 00 00       	jmp    8006f6 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800483:	50                   	push   %eax
  800484:	68 be 22 80 00       	push   $0x8022be
  800489:	53                   	push   %ebx
  80048a:	56                   	push   %esi
  80048b:	e8 81 fe ff ff       	call   800311 <printfmt>
  800490:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800493:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800496:	e9 5b 02 00 00       	jmp    8006f6 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	83 c0 04             	add    $0x4,%eax
  8004a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004a9:	85 d2                	test   %edx,%edx
  8004ab:	b8 b7 22 80 00       	mov    $0x8022b7,%eax
  8004b0:	0f 45 c2             	cmovne %edx,%eax
  8004b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ba:	7e 06                	jle    8004c2 <vprintfmt+0x194>
  8004bc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004c0:	75 0d                	jne    8004cf <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c5:	89 c7                	mov    %eax,%edi
  8004c7:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cd:	eb 53                	jmp    800522 <vprintfmt+0x1f4>
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d5:	50                   	push   %eax
  8004d6:	e8 13 04 00 00       	call   8008ee <strnlen>
  8004db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004de:	29 c1                	sub    %eax,%ecx
  8004e0:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004e8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ef:	eb 0f                	jmp    800500 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	53                   	push   %ebx
  8004f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fa:	83 ef 01             	sub    $0x1,%edi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	85 ff                	test   %edi,%edi
  800502:	7f ed                	jg     8004f1 <vprintfmt+0x1c3>
  800504:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800507:	85 d2                	test   %edx,%edx
  800509:	b8 00 00 00 00       	mov    $0x0,%eax
  80050e:	0f 49 c2             	cmovns %edx,%eax
  800511:	29 c2                	sub    %eax,%edx
  800513:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800516:	eb aa                	jmp    8004c2 <vprintfmt+0x194>
					putch(ch, putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	52                   	push   %edx
  80051d:	ff d6                	call   *%esi
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800525:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800527:	83 c7 01             	add    $0x1,%edi
  80052a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80052e:	0f be d0             	movsbl %al,%edx
  800531:	85 d2                	test   %edx,%edx
  800533:	74 4b                	je     800580 <vprintfmt+0x252>
  800535:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800539:	78 06                	js     800541 <vprintfmt+0x213>
  80053b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80053f:	78 1e                	js     80055f <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800541:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800545:	74 d1                	je     800518 <vprintfmt+0x1ea>
  800547:	0f be c0             	movsbl %al,%eax
  80054a:	83 e8 20             	sub    $0x20,%eax
  80054d:	83 f8 5e             	cmp    $0x5e,%eax
  800550:	76 c6                	jbe    800518 <vprintfmt+0x1ea>
					putch('?', putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	53                   	push   %ebx
  800556:	6a 3f                	push   $0x3f
  800558:	ff d6                	call   *%esi
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	eb c3                	jmp    800522 <vprintfmt+0x1f4>
  80055f:	89 cf                	mov    %ecx,%edi
  800561:	eb 0e                	jmp    800571 <vprintfmt+0x243>
				putch(' ', putdat);
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	53                   	push   %ebx
  800567:	6a 20                	push   $0x20
  800569:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80056b:	83 ef 01             	sub    $0x1,%edi
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	85 ff                	test   %edi,%edi
  800573:	7f ee                	jg     800563 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800575:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
  80057b:	e9 76 01 00 00       	jmp    8006f6 <vprintfmt+0x3c8>
  800580:	89 cf                	mov    %ecx,%edi
  800582:	eb ed                	jmp    800571 <vprintfmt+0x243>
	if (lflag >= 2)
  800584:	83 f9 01             	cmp    $0x1,%ecx
  800587:	7f 1f                	jg     8005a8 <vprintfmt+0x27a>
	else if (lflag)
  800589:	85 c9                	test   %ecx,%ecx
  80058b:	74 6a                	je     8005f7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800595:	89 c1                	mov    %eax,%ecx
  800597:	c1 f9 1f             	sar    $0x1f,%ecx
  80059a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8d 40 04             	lea    0x4(%eax),%eax
  8005a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a6:	eb 17                	jmp    8005bf <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8b 50 04             	mov    0x4(%eax),%edx
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 40 08             	lea    0x8(%eax),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005c2:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005c7:	85 d2                	test   %edx,%edx
  8005c9:	0f 89 f8 00 00 00    	jns    8006c7 <vprintfmt+0x399>
				putch('-', putdat);
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	53                   	push   %ebx
  8005d3:	6a 2d                	push   $0x2d
  8005d5:	ff d6                	call   *%esi
				num = -(long long) num;
  8005d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005dd:	f7 d8                	neg    %eax
  8005df:	83 d2 00             	adc    $0x0,%edx
  8005e2:	f7 da                	neg    %edx
  8005e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ea:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ed:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f2:	e9 e1 00 00 00       	jmp    8006d8 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ff:	99                   	cltd   
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 04             	lea    0x4(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
  80060c:	eb b1                	jmp    8005bf <vprintfmt+0x291>
	if (lflag >= 2)
  80060e:	83 f9 01             	cmp    $0x1,%ecx
  800611:	7f 27                	jg     80063a <vprintfmt+0x30c>
	else if (lflag)
  800613:	85 c9                	test   %ecx,%ecx
  800615:	74 41                	je     800658 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	ba 00 00 00 00       	mov    $0x0,%edx
  800621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800624:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 40 04             	lea    0x4(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	bf 0a 00 00 00       	mov    $0xa,%edi
  800635:	e9 8d 00 00 00       	jmp    8006c7 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 50 04             	mov    0x4(%eax),%edx
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 08             	lea    0x8(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800651:	bf 0a 00 00 00       	mov    $0xa,%edi
  800656:	eb 6f                	jmp    8006c7 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	ba 00 00 00 00       	mov    $0x0,%edx
  800662:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800665:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8d 40 04             	lea    0x4(%eax),%eax
  80066e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800671:	bf 0a 00 00 00       	mov    $0xa,%edi
  800676:	eb 4f                	jmp    8006c7 <vprintfmt+0x399>
	if (lflag >= 2)
  800678:	83 f9 01             	cmp    $0x1,%ecx
  80067b:	7f 23                	jg     8006a0 <vprintfmt+0x372>
	else if (lflag)
  80067d:	85 c9                	test   %ecx,%ecx
  80067f:	0f 84 98 00 00 00    	je     80071d <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	ba 00 00 00 00       	mov    $0x0,%edx
  80068f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800692:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
  80069e:	eb 17                	jmp    8006b7 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 08             	lea    0x8(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	53                   	push   %ebx
  8006bb:	6a 30                	push   $0x30
  8006bd:	ff d6                	call   *%esi
			goto number;
  8006bf:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006c2:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8006c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006cb:	74 0b                	je     8006d8 <vprintfmt+0x3aa>
				putch('+', putdat);
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	53                   	push   %ebx
  8006d1:	6a 2b                	push   $0x2b
  8006d3:	ff d6                	call   *%esi
  8006d5:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006d8:	83 ec 0c             	sub    $0xc,%esp
  8006db:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006df:	50                   	push   %eax
  8006e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e3:	57                   	push   %edi
  8006e4:	ff 75 dc             	pushl  -0x24(%ebp)
  8006e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ea:	89 da                	mov    %ebx,%edx
  8006ec:	89 f0                	mov    %esi,%eax
  8006ee:	e8 22 fb ff ff       	call   800215 <printnum>
			break;
  8006f3:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8006f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f9:	83 c7 01             	add    $0x1,%edi
  8006fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800700:	83 f8 25             	cmp    $0x25,%eax
  800703:	0f 84 3c fc ff ff    	je     800345 <vprintfmt+0x17>
			if (ch == '\0')
  800709:	85 c0                	test   %eax,%eax
  80070b:	0f 84 55 01 00 00    	je     800866 <vprintfmt+0x538>
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	50                   	push   %eax
  800716:	ff d6                	call   *%esi
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	eb dc                	jmp    8006f9 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	ba 00 00 00 00       	mov    $0x0,%edx
  800727:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
  800736:	e9 7c ff ff ff       	jmp    8006b7 <vprintfmt+0x389>
			putch('0', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 30                	push   $0x30
  800741:	ff d6                	call   *%esi
			putch('x', putdat);
  800743:	83 c4 08             	add    $0x8,%esp
  800746:	53                   	push   %ebx
  800747:	6a 78                	push   $0x78
  800749:	ff d6                	call   *%esi
			num = (unsigned long long)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	ba 00 00 00 00       	mov    $0x0,%edx
  800755:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800758:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80075b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800767:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  80076c:	e9 56 ff ff ff       	jmp    8006c7 <vprintfmt+0x399>
	if (lflag >= 2)
  800771:	83 f9 01             	cmp    $0x1,%ecx
  800774:	7f 27                	jg     80079d <vprintfmt+0x46f>
	else if (lflag)
  800776:	85 c9                	test   %ecx,%ecx
  800778:	74 44                	je     8007be <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	ba 00 00 00 00       	mov    $0x0,%edx
  800784:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800787:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 40 04             	lea    0x4(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800793:	bf 10 00 00 00       	mov    $0x10,%edi
  800798:	e9 2a ff ff ff       	jmp    8006c7 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 50 04             	mov    0x4(%eax),%edx
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 40 08             	lea    0x8(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b4:	bf 10 00 00 00       	mov    $0x10,%edi
  8007b9:	e9 09 ff ff ff       	jmp    8006c7 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 40 04             	lea    0x4(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d7:	bf 10 00 00 00       	mov    $0x10,%edi
  8007dc:	e9 e6 fe ff ff       	jmp    8006c7 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8d 78 04             	lea    0x4(%eax),%edi
  8007e7:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	74 2d                	je     80081a <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8007ed:	0f b6 13             	movzbl (%ebx),%edx
  8007f0:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007f2:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8007f5:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007f8:	0f 8e f8 fe ff ff    	jle    8006f6 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007fe:	68 14 24 80 00       	push   $0x802414
  800803:	68 f1 26 80 00       	push   $0x8026f1
  800808:	53                   	push   %ebx
  800809:	56                   	push   %esi
  80080a:	e8 02 fb ff ff       	call   800311 <printfmt>
  80080f:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800812:	89 7d 14             	mov    %edi,0x14(%ebp)
  800815:	e9 dc fe ff ff       	jmp    8006f6 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  80081a:	68 dc 23 80 00       	push   $0x8023dc
  80081f:	68 f1 26 80 00       	push   $0x8026f1
  800824:	53                   	push   %ebx
  800825:	56                   	push   %esi
  800826:	e8 e6 fa ff ff       	call   800311 <printfmt>
  80082b:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80082e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800831:	e9 c0 fe ff ff       	jmp    8006f6 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	6a 25                	push   $0x25
  80083c:	ff d6                	call   *%esi
			break;
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	e9 b0 fe ff ff       	jmp    8006f6 <vprintfmt+0x3c8>
			putch('%', putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	53                   	push   %ebx
  80084a:	6a 25                	push   $0x25
  80084c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084e:	83 c4 10             	add    $0x10,%esp
  800851:	89 f8                	mov    %edi,%eax
  800853:	eb 03                	jmp    800858 <vprintfmt+0x52a>
  800855:	83 e8 01             	sub    $0x1,%eax
  800858:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085c:	75 f7                	jne    800855 <vprintfmt+0x527>
  80085e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800861:	e9 90 fe ff ff       	jmp    8006f6 <vprintfmt+0x3c8>
}
  800866:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800869:	5b                   	pop    %ebx
  80086a:	5e                   	pop    %esi
  80086b:	5f                   	pop    %edi
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	83 ec 18             	sub    $0x18,%esp
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800881:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800884:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088b:	85 c0                	test   %eax,%eax
  80088d:	74 26                	je     8008b5 <vsnprintf+0x47>
  80088f:	85 d2                	test   %edx,%edx
  800891:	7e 22                	jle    8008b5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800893:	ff 75 14             	pushl  0x14(%ebp)
  800896:	ff 75 10             	pushl  0x10(%ebp)
  800899:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089c:	50                   	push   %eax
  80089d:	68 f4 02 80 00       	push   $0x8002f4
  8008a2:	e8 87 fa ff ff       	call   80032e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008aa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b0:	83 c4 10             	add    $0x10,%esp
}
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    
		return -E_INVAL;
  8008b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ba:	eb f7                	jmp    8008b3 <vsnprintf+0x45>

008008bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c5:	50                   	push   %eax
  8008c6:	ff 75 10             	pushl  0x10(%ebp)
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	e8 9a ff ff ff       	call   80086e <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d4:	c9                   	leave  
  8008d5:	c3                   	ret    

008008d6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e5:	74 05                	je     8008ec <strlen+0x16>
		n++;
  8008e7:	83 c0 01             	add    $0x1,%eax
  8008ea:	eb f5                	jmp    8008e1 <strlen+0xb>
	return n;
}
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 0d                	je     80090d <strnlen+0x1f>
  800900:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800904:	74 05                	je     80090b <strnlen+0x1d>
		n++;
  800906:	83 c2 01             	add    $0x1,%edx
  800909:	eb f1                	jmp    8008fc <strnlen+0xe>
  80090b:	89 d0                	mov    %edx,%eax
	return n;
}
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800919:	ba 00 00 00 00       	mov    $0x0,%edx
  80091e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800922:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800925:	83 c2 01             	add    $0x1,%edx
  800928:	84 c9                	test   %cl,%cl
  80092a:	75 f2                	jne    80091e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80092c:	5b                   	pop    %ebx
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	53                   	push   %ebx
  800933:	83 ec 10             	sub    $0x10,%esp
  800936:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800939:	53                   	push   %ebx
  80093a:	e8 97 ff ff ff       	call   8008d6 <strlen>
  80093f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	01 d8                	add    %ebx,%eax
  800947:	50                   	push   %eax
  800948:	e8 c2 ff ff ff       	call   80090f <strcpy>
	return dst;
}
  80094d:	89 d8                	mov    %ebx,%eax
  80094f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095f:	89 c6                	mov    %eax,%esi
  800961:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800964:	89 c2                	mov    %eax,%edx
  800966:	39 f2                	cmp    %esi,%edx
  800968:	74 11                	je     80097b <strncpy+0x27>
		*dst++ = *src;
  80096a:	83 c2 01             	add    $0x1,%edx
  80096d:	0f b6 19             	movzbl (%ecx),%ebx
  800970:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800973:	80 fb 01             	cmp    $0x1,%bl
  800976:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800979:	eb eb                	jmp    800966 <strncpy+0x12>
	}
	return ret;
}
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	56                   	push   %esi
  800983:	53                   	push   %ebx
  800984:	8b 75 08             	mov    0x8(%ebp),%esi
  800987:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098a:	8b 55 10             	mov    0x10(%ebp),%edx
  80098d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098f:	85 d2                	test   %edx,%edx
  800991:	74 21                	je     8009b4 <strlcpy+0x35>
  800993:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800997:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800999:	39 c2                	cmp    %eax,%edx
  80099b:	74 14                	je     8009b1 <strlcpy+0x32>
  80099d:	0f b6 19             	movzbl (%ecx),%ebx
  8009a0:	84 db                	test   %bl,%bl
  8009a2:	74 0b                	je     8009af <strlcpy+0x30>
			*dst++ = *src++;
  8009a4:	83 c1 01             	add    $0x1,%ecx
  8009a7:	83 c2 01             	add    $0x1,%edx
  8009aa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ad:	eb ea                	jmp    800999 <strlcpy+0x1a>
  8009af:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009b1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b4:	29 f0                	sub    %esi,%eax
}
  8009b6:	5b                   	pop    %ebx
  8009b7:	5e                   	pop    %esi
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c3:	0f b6 01             	movzbl (%ecx),%eax
  8009c6:	84 c0                	test   %al,%al
  8009c8:	74 0c                	je     8009d6 <strcmp+0x1c>
  8009ca:	3a 02                	cmp    (%edx),%al
  8009cc:	75 08                	jne    8009d6 <strcmp+0x1c>
		p++, q++;
  8009ce:	83 c1 01             	add    $0x1,%ecx
  8009d1:	83 c2 01             	add    $0x1,%edx
  8009d4:	eb ed                	jmp    8009c3 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d6:	0f b6 c0             	movzbl %al,%eax
  8009d9:	0f b6 12             	movzbl (%edx),%edx
  8009dc:	29 d0                	sub    %edx,%eax
}
  8009de:	5d                   	pop    %ebp
  8009df:	c3                   	ret    

008009e0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ea:	89 c3                	mov    %eax,%ebx
  8009ec:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ef:	eb 06                	jmp    8009f7 <strncmp+0x17>
		n--, p++, q++;
  8009f1:	83 c0 01             	add    $0x1,%eax
  8009f4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f7:	39 d8                	cmp    %ebx,%eax
  8009f9:	74 16                	je     800a11 <strncmp+0x31>
  8009fb:	0f b6 08             	movzbl (%eax),%ecx
  8009fe:	84 c9                	test   %cl,%cl
  800a00:	74 04                	je     800a06 <strncmp+0x26>
  800a02:	3a 0a                	cmp    (%edx),%cl
  800a04:	74 eb                	je     8009f1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a06:	0f b6 00             	movzbl (%eax),%eax
  800a09:	0f b6 12             	movzbl (%edx),%edx
  800a0c:	29 d0                	sub    %edx,%eax
}
  800a0e:	5b                   	pop    %ebx
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    
		return 0;
  800a11:	b8 00 00 00 00       	mov    $0x0,%eax
  800a16:	eb f6                	jmp    800a0e <strncmp+0x2e>

00800a18 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a22:	0f b6 10             	movzbl (%eax),%edx
  800a25:	84 d2                	test   %dl,%dl
  800a27:	74 09                	je     800a32 <strchr+0x1a>
		if (*s == c)
  800a29:	38 ca                	cmp    %cl,%dl
  800a2b:	74 0a                	je     800a37 <strchr+0x1f>
	for (; *s; s++)
  800a2d:	83 c0 01             	add    $0x1,%eax
  800a30:	eb f0                	jmp    800a22 <strchr+0xa>
			return (char *) s;
	return 0;
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a43:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a46:	38 ca                	cmp    %cl,%dl
  800a48:	74 09                	je     800a53 <strfind+0x1a>
  800a4a:	84 d2                	test   %dl,%dl
  800a4c:	74 05                	je     800a53 <strfind+0x1a>
	for (; *s; s++)
  800a4e:	83 c0 01             	add    $0x1,%eax
  800a51:	eb f0                	jmp    800a43 <strfind+0xa>
			break;
	return (char *) s;
}
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	57                   	push   %edi
  800a59:	56                   	push   %esi
  800a5a:	53                   	push   %ebx
  800a5b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a61:	85 c9                	test   %ecx,%ecx
  800a63:	74 31                	je     800a96 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a65:	89 f8                	mov    %edi,%eax
  800a67:	09 c8                	or     %ecx,%eax
  800a69:	a8 03                	test   $0x3,%al
  800a6b:	75 23                	jne    800a90 <memset+0x3b>
		c &= 0xFF;
  800a6d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a71:	89 d3                	mov    %edx,%ebx
  800a73:	c1 e3 08             	shl    $0x8,%ebx
  800a76:	89 d0                	mov    %edx,%eax
  800a78:	c1 e0 18             	shl    $0x18,%eax
  800a7b:	89 d6                	mov    %edx,%esi
  800a7d:	c1 e6 10             	shl    $0x10,%esi
  800a80:	09 f0                	or     %esi,%eax
  800a82:	09 c2                	or     %eax,%edx
  800a84:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a86:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a89:	89 d0                	mov    %edx,%eax
  800a8b:	fc                   	cld    
  800a8c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8e:	eb 06                	jmp    800a96 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a93:	fc                   	cld    
  800a94:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a96:	89 f8                	mov    %edi,%eax
  800a98:	5b                   	pop    %ebx
  800a99:	5e                   	pop    %esi
  800a9a:	5f                   	pop    %edi
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	57                   	push   %edi
  800aa1:	56                   	push   %esi
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aab:	39 c6                	cmp    %eax,%esi
  800aad:	73 32                	jae    800ae1 <memmove+0x44>
  800aaf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab2:	39 c2                	cmp    %eax,%edx
  800ab4:	76 2b                	jbe    800ae1 <memmove+0x44>
		s += n;
		d += n;
  800ab6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab9:	89 fe                	mov    %edi,%esi
  800abb:	09 ce                	or     %ecx,%esi
  800abd:	09 d6                	or     %edx,%esi
  800abf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac5:	75 0e                	jne    800ad5 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac7:	83 ef 04             	sub    $0x4,%edi
  800aca:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad0:	fd                   	std    
  800ad1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad3:	eb 09                	jmp    800ade <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad5:	83 ef 01             	sub    $0x1,%edi
  800ad8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800adb:	fd                   	std    
  800adc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ade:	fc                   	cld    
  800adf:	eb 1a                	jmp    800afb <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae1:	89 c2                	mov    %eax,%edx
  800ae3:	09 ca                	or     %ecx,%edx
  800ae5:	09 f2                	or     %esi,%edx
  800ae7:	f6 c2 03             	test   $0x3,%dl
  800aea:	75 0a                	jne    800af6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aef:	89 c7                	mov    %eax,%edi
  800af1:	fc                   	cld    
  800af2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af4:	eb 05                	jmp    800afb <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af6:	89 c7                	mov    %eax,%edi
  800af8:	fc                   	cld    
  800af9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800afb:	5e                   	pop    %esi
  800afc:	5f                   	pop    %edi
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b05:	ff 75 10             	pushl  0x10(%ebp)
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	ff 75 08             	pushl  0x8(%ebp)
  800b0e:	e8 8a ff ff ff       	call   800a9d <memmove>
}
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b20:	89 c6                	mov    %eax,%esi
  800b22:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b25:	39 f0                	cmp    %esi,%eax
  800b27:	74 1c                	je     800b45 <memcmp+0x30>
		if (*s1 != *s2)
  800b29:	0f b6 08             	movzbl (%eax),%ecx
  800b2c:	0f b6 1a             	movzbl (%edx),%ebx
  800b2f:	38 d9                	cmp    %bl,%cl
  800b31:	75 08                	jne    800b3b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	83 c2 01             	add    $0x1,%edx
  800b39:	eb ea                	jmp    800b25 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b3b:	0f b6 c1             	movzbl %cl,%eax
  800b3e:	0f b6 db             	movzbl %bl,%ebx
  800b41:	29 d8                	sub    %ebx,%eax
  800b43:	eb 05                	jmp    800b4a <memcmp+0x35>
	}

	return 0;
  800b45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b5c:	39 d0                	cmp    %edx,%eax
  800b5e:	73 09                	jae    800b69 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b60:	38 08                	cmp    %cl,(%eax)
  800b62:	74 05                	je     800b69 <memfind+0x1b>
	for (; s < ends; s++)
  800b64:	83 c0 01             	add    $0x1,%eax
  800b67:	eb f3                	jmp    800b5c <memfind+0xe>
			break;
	return (void *) s;
}
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b77:	eb 03                	jmp    800b7c <strtol+0x11>
		s++;
  800b79:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b7c:	0f b6 01             	movzbl (%ecx),%eax
  800b7f:	3c 20                	cmp    $0x20,%al
  800b81:	74 f6                	je     800b79 <strtol+0xe>
  800b83:	3c 09                	cmp    $0x9,%al
  800b85:	74 f2                	je     800b79 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b87:	3c 2b                	cmp    $0x2b,%al
  800b89:	74 2a                	je     800bb5 <strtol+0x4a>
	int neg = 0;
  800b8b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b90:	3c 2d                	cmp    $0x2d,%al
  800b92:	74 2b                	je     800bbf <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b94:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b9a:	75 0f                	jne    800bab <strtol+0x40>
  800b9c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9f:	74 28                	je     800bc9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba8:	0f 44 d8             	cmove  %eax,%ebx
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb3:	eb 50                	jmp    800c05 <strtol+0x9a>
		s++;
  800bb5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb8:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbd:	eb d5                	jmp    800b94 <strtol+0x29>
		s++, neg = 1;
  800bbf:	83 c1 01             	add    $0x1,%ecx
  800bc2:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc7:	eb cb                	jmp    800b94 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bcd:	74 0e                	je     800bdd <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bcf:	85 db                	test   %ebx,%ebx
  800bd1:	75 d8                	jne    800bab <strtol+0x40>
		s++, base = 8;
  800bd3:	83 c1 01             	add    $0x1,%ecx
  800bd6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bdb:	eb ce                	jmp    800bab <strtol+0x40>
		s += 2, base = 16;
  800bdd:	83 c1 02             	add    $0x2,%ecx
  800be0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be5:	eb c4                	jmp    800bab <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bea:	89 f3                	mov    %esi,%ebx
  800bec:	80 fb 19             	cmp    $0x19,%bl
  800bef:	77 29                	ja     800c1a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf1:	0f be d2             	movsbl %dl,%edx
  800bf4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bfa:	7d 30                	jge    800c2c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bfc:	83 c1 01             	add    $0x1,%ecx
  800bff:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c03:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c05:	0f b6 11             	movzbl (%ecx),%edx
  800c08:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0b:	89 f3                	mov    %esi,%ebx
  800c0d:	80 fb 09             	cmp    $0x9,%bl
  800c10:	77 d5                	ja     800be7 <strtol+0x7c>
			dig = *s - '0';
  800c12:	0f be d2             	movsbl %dl,%edx
  800c15:	83 ea 30             	sub    $0x30,%edx
  800c18:	eb dd                	jmp    800bf7 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c1a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c1d:	89 f3                	mov    %esi,%ebx
  800c1f:	80 fb 19             	cmp    $0x19,%bl
  800c22:	77 08                	ja     800c2c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c24:	0f be d2             	movsbl %dl,%edx
  800c27:	83 ea 37             	sub    $0x37,%edx
  800c2a:	eb cb                	jmp    800bf7 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c30:	74 05                	je     800c37 <strtol+0xcc>
		*endptr = (char *) s;
  800c32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c35:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c37:	89 c2                	mov    %eax,%edx
  800c39:	f7 da                	neg    %edx
  800c3b:	85 ff                	test   %edi,%edi
  800c3d:	0f 45 c2             	cmovne %edx,%eax
}
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c50:	8b 55 08             	mov    0x8(%ebp),%edx
  800c53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c56:	89 c3                	mov    %eax,%ebx
  800c58:	89 c7                	mov    %eax,%edi
  800c5a:	89 c6                	mov    %eax,%esi
  800c5c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	b8 03 00 00 00       	mov    $0x3,%eax
  800c98:	89 cb                	mov    %ecx,%ebx
  800c9a:	89 cf                	mov    %ecx,%edi
  800c9c:	89 ce                	mov    %ecx,%esi
  800c9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	7f 08                	jg     800cac <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800cb0:	6a 03                	push   $0x3
  800cb2:	68 20 26 80 00       	push   $0x802620
  800cb7:	6a 33                	push   $0x33
  800cb9:	68 3d 26 80 00       	push   $0x80263d
  800cbe:	e8 c1 11 00 00       	call   801e84 <_panic>

00800cc3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd3:	89 d1                	mov    %edx,%ecx
  800cd5:	89 d3                	mov    %edx,%ebx
  800cd7:	89 d7                	mov    %edx,%edi
  800cd9:	89 d6                	mov    %edx,%esi
  800cdb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <sys_yield>:

void
sys_yield(void)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ced:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cf2:	89 d1                	mov    %edx,%ecx
  800cf4:	89 d3                	mov    %edx,%ebx
  800cf6:	89 d7                	mov    %edx,%edi
  800cf8:	89 d6                	mov    %edx,%esi
  800cfa:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfc:	5b                   	pop    %ebx
  800cfd:	5e                   	pop    %esi
  800cfe:	5f                   	pop    %edi
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0a:	be 00 00 00 00       	mov    $0x0,%esi
  800d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d15:	b8 04 00 00 00       	mov    $0x4,%eax
  800d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1d:	89 f7                	mov    %esi,%edi
  800d1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d21:	85 c0                	test   %eax,%eax
  800d23:	7f 08                	jg     800d2d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	50                   	push   %eax
  800d31:	6a 04                	push   $0x4
  800d33:	68 20 26 80 00       	push   $0x802620
  800d38:	6a 33                	push   $0x33
  800d3a:	68 3d 26 80 00       	push   $0x80263d
  800d3f:	e8 40 11 00 00       	call   801e84 <_panic>

00800d44 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	b8 05 00 00 00       	mov    $0x5,%eax
  800d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 05                	push   $0x5
  800d75:	68 20 26 80 00       	push   $0x802620
  800d7a:	6a 33                	push   $0x33
  800d7c:	68 3d 26 80 00       	push   $0x80263d
  800d81:	e8 fe 10 00 00       	call   801e84 <_panic>

00800d86 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9f:	89 df                	mov    %ebx,%edi
  800da1:	89 de                	mov    %ebx,%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 06                	push   $0x6
  800db7:	68 20 26 80 00       	push   $0x802620
  800dbc:	6a 33                	push   $0x33
  800dbe:	68 3d 26 80 00       	push   $0x80263d
  800dc3:	e8 bc 10 00 00       	call   801e84 <_panic>

00800dc8 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dde:	89 cb                	mov    %ecx,%ebx
  800de0:	89 cf                	mov    %ecx,%edi
  800de2:	89 ce                	mov    %ecx,%esi
  800de4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7f 08                	jg     800df2 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	50                   	push   %eax
  800df6:	6a 0b                	push   $0xb
  800df8:	68 20 26 80 00       	push   $0x802620
  800dfd:	6a 33                	push   $0x33
  800dff:	68 3d 26 80 00       	push   $0x80263d
  800e04:	e8 7b 10 00 00       	call   801e84 <_panic>

00800e09 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e17:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1d:	b8 08 00 00 00       	mov    $0x8,%eax
  800e22:	89 df                	mov    %ebx,%edi
  800e24:	89 de                	mov    %ebx,%esi
  800e26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	7f 08                	jg     800e34 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800e38:	6a 08                	push   $0x8
  800e3a:	68 20 26 80 00       	push   $0x802620
  800e3f:	6a 33                	push   $0x33
  800e41:	68 3d 26 80 00       	push   $0x80263d
  800e46:	e8 39 10 00 00       	call   801e84 <_panic>

00800e4b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5f:	b8 09 00 00 00       	mov    $0x9,%eax
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7f 08                	jg     800e76 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800e7a:	6a 09                	push   $0x9
  800e7c:	68 20 26 80 00       	push   $0x802620
  800e81:	6a 33                	push   $0x33
  800e83:	68 3d 26 80 00       	push   $0x80263d
  800e88:	e8 f7 0f 00 00       	call   801e84 <_panic>

00800e8d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800ea1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7f 08                	jg     800eb8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800ebc:	6a 0a                	push   $0xa
  800ebe:	68 20 26 80 00       	push   $0x802620
  800ec3:	6a 33                	push   $0x33
  800ec5:	68 3d 26 80 00       	push   $0x80263d
  800eca:	e8 b5 0f 00 00       	call   801e84 <_panic>

00800ecf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ee0:	be 00 00 00 00       	mov    $0x0,%esi
  800ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eeb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f00:	8b 55 08             	mov    0x8(%ebp),%edx
  800f03:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f08:	89 cb                	mov    %ecx,%ebx
  800f0a:	89 cf                	mov    %ecx,%edi
  800f0c:	89 ce                	mov    %ecx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	6a 0e                	push   $0xe
  800f22:	68 20 26 80 00       	push   $0x802620
  800f27:	6a 33                	push   $0x33
  800f29:	68 3d 26 80 00       	push   $0x80263d
  800f2e:	e8 51 0f 00 00       	call   801e84 <_panic>

00800f33 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f44:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f49:	89 df                	mov    %ebx,%edi
  800f4b:	89 de                	mov    %ebx,%esi
  800f4d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f4f:	5b                   	pop    %ebx
  800f50:	5e                   	pop    %esi
  800f51:	5f                   	pop    %edi
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	57                   	push   %edi
  800f58:	56                   	push   %esi
  800f59:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	b8 10 00 00 00       	mov    $0x10,%eax
  800f67:	89 cb                	mov    %ecx,%ebx
  800f69:	89 cf                	mov    %ecx,%edi
  800f6b:	89 ce                	mov    %ecx,%esi
  800f6d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800f80:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800f82:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800f85:	83 3a 01             	cmpl   $0x1,(%edx)
  800f88:	7e 09                	jle    800f93 <argstart+0x1f>
  800f8a:	ba 71 22 80 00       	mov    $0x802271,%edx
  800f8f:	85 c9                	test   %ecx,%ecx
  800f91:	75 05                	jne    800f98 <argstart+0x24>
  800f93:	ba 00 00 00 00       	mov    $0x0,%edx
  800f98:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800f9b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <argnext>:

int
argnext(struct Argstate *args)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 04             	sub    $0x4,%esp
  800fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800fae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800fb5:	8b 43 08             	mov    0x8(%ebx),%eax
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	74 72                	je     80102e <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  800fbc:	80 38 00             	cmpb   $0x0,(%eax)
  800fbf:	75 48                	jne    801009 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800fc1:	8b 0b                	mov    (%ebx),%ecx
  800fc3:	83 39 01             	cmpl   $0x1,(%ecx)
  800fc6:	74 58                	je     801020 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  800fc8:	8b 53 04             	mov    0x4(%ebx),%edx
  800fcb:	8b 42 04             	mov    0x4(%edx),%eax
  800fce:	80 38 2d             	cmpb   $0x2d,(%eax)
  800fd1:	75 4d                	jne    801020 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  800fd3:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800fd7:	74 47                	je     801020 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800fd9:	83 c0 01             	add    $0x1,%eax
  800fdc:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800fdf:	83 ec 04             	sub    $0x4,%esp
  800fe2:	8b 01                	mov    (%ecx),%eax
  800fe4:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800feb:	50                   	push   %eax
  800fec:	8d 42 08             	lea    0x8(%edx),%eax
  800fef:	50                   	push   %eax
  800ff0:	83 c2 04             	add    $0x4,%edx
  800ff3:	52                   	push   %edx
  800ff4:	e8 a4 fa ff ff       	call   800a9d <memmove>
		(*args->argc)--;
  800ff9:	8b 03                	mov    (%ebx),%eax
  800ffb:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800ffe:	8b 43 08             	mov    0x8(%ebx),%eax
  801001:	83 c4 10             	add    $0x10,%esp
  801004:	80 38 2d             	cmpb   $0x2d,(%eax)
  801007:	74 11                	je     80101a <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801009:	8b 53 08             	mov    0x8(%ebx),%edx
  80100c:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80100f:	83 c2 01             	add    $0x1,%edx
  801012:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801018:	c9                   	leave  
  801019:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80101a:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80101e:	75 e9                	jne    801009 <argnext+0x65>
	args->curarg = 0;
  801020:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801027:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80102c:	eb e7                	jmp    801015 <argnext+0x71>
		return -1;
  80102e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801033:	eb e0                	jmp    801015 <argnext+0x71>

00801035 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	53                   	push   %ebx
  801039:	83 ec 04             	sub    $0x4,%esp
  80103c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80103f:	8b 43 08             	mov    0x8(%ebx),%eax
  801042:	85 c0                	test   %eax,%eax
  801044:	74 12                	je     801058 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  801046:	80 38 00             	cmpb   $0x0,(%eax)
  801049:	74 12                	je     80105d <argnextvalue+0x28>
		args->argvalue = args->curarg;
  80104b:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  80104e:	c7 43 08 71 22 80 00 	movl   $0x802271,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801055:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    
	} else if (*args->argc > 1) {
  80105d:	8b 13                	mov    (%ebx),%edx
  80105f:	83 3a 01             	cmpl   $0x1,(%edx)
  801062:	7f 10                	jg     801074 <argnextvalue+0x3f>
		args->argvalue = 0;
  801064:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80106b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801072:	eb e1                	jmp    801055 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801074:	8b 43 04             	mov    0x4(%ebx),%eax
  801077:	8b 48 04             	mov    0x4(%eax),%ecx
  80107a:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80107d:	83 ec 04             	sub    $0x4,%esp
  801080:	8b 12                	mov    (%edx),%edx
  801082:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801089:	52                   	push   %edx
  80108a:	8d 50 08             	lea    0x8(%eax),%edx
  80108d:	52                   	push   %edx
  80108e:	83 c0 04             	add    $0x4,%eax
  801091:	50                   	push   %eax
  801092:	e8 06 fa ff ff       	call   800a9d <memmove>
		(*args->argc)--;
  801097:	8b 03                	mov    (%ebx),%eax
  801099:	83 28 01             	subl   $0x1,(%eax)
  80109c:	83 c4 10             	add    $0x10,%esp
  80109f:	eb b4                	jmp    801055 <argnextvalue+0x20>

008010a1 <argvalue>:
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8010aa:	8b 42 0c             	mov    0xc(%edx),%eax
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	74 02                	je     8010b3 <argvalue+0x12>
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	52                   	push   %edx
  8010b7:	e8 79 ff ff ff       	call   801035 <argnextvalue>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	eb f0                	jmp    8010b1 <argvalue+0x10>

008010c1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	05 00 00 00 30       	add    $0x30000000,%eax
  8010cc:	c1 e8 0c             	shr    $0xc,%eax
}
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    

008010d1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010e1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010f0:	89 c2                	mov    %eax,%edx
  8010f2:	c1 ea 16             	shr    $0x16,%edx
  8010f5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010fc:	f6 c2 01             	test   $0x1,%dl
  8010ff:	74 2d                	je     80112e <fd_alloc+0x46>
  801101:	89 c2                	mov    %eax,%edx
  801103:	c1 ea 0c             	shr    $0xc,%edx
  801106:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80110d:	f6 c2 01             	test   $0x1,%dl
  801110:	74 1c                	je     80112e <fd_alloc+0x46>
  801112:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801117:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80111c:	75 d2                	jne    8010f0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801127:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80112c:	eb 0a                	jmp    801138 <fd_alloc+0x50>
			*fd_store = fd;
  80112e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801131:	89 01                	mov    %eax,(%ecx)
			return 0;
  801133:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801140:	83 f8 1f             	cmp    $0x1f,%eax
  801143:	77 30                	ja     801175 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801145:	c1 e0 0c             	shl    $0xc,%eax
  801148:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80114d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801153:	f6 c2 01             	test   $0x1,%dl
  801156:	74 24                	je     80117c <fd_lookup+0x42>
  801158:	89 c2                	mov    %eax,%edx
  80115a:	c1 ea 0c             	shr    $0xc,%edx
  80115d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801164:	f6 c2 01             	test   $0x1,%dl
  801167:	74 1a                	je     801183 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116c:	89 02                	mov    %eax,(%edx)
	return 0;
  80116e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801173:	5d                   	pop    %ebp
  801174:	c3                   	ret    
		return -E_INVAL;
  801175:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117a:	eb f7                	jmp    801173 <fd_lookup+0x39>
		return -E_INVAL;
  80117c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801181:	eb f0                	jmp    801173 <fd_lookup+0x39>
  801183:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801188:	eb e9                	jmp    801173 <fd_lookup+0x39>

0080118a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801193:	ba c8 26 80 00       	mov    $0x8026c8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801198:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80119d:	39 08                	cmp    %ecx,(%eax)
  80119f:	74 33                	je     8011d4 <dev_lookup+0x4a>
  8011a1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011a4:	8b 02                	mov    (%edx),%eax
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	75 f3                	jne    80119d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011aa:	a1 04 40 80 00       	mov    0x804004,%eax
  8011af:	8b 40 48             	mov    0x48(%eax),%eax
  8011b2:	83 ec 04             	sub    $0x4,%esp
  8011b5:	51                   	push   %ecx
  8011b6:	50                   	push   %eax
  8011b7:	68 4c 26 80 00       	push   $0x80264c
  8011bc:	e8 40 f0 ff ff       	call   800201 <cprintf>
	*dev = 0;
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    
			*dev = devtab[i];
  8011d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011de:	eb f2                	jmp    8011d2 <dev_lookup+0x48>

008011e0 <fd_close>:
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	57                   	push   %edi
  8011e4:	56                   	push   %esi
  8011e5:	53                   	push   %ebx
  8011e6:	83 ec 24             	sub    $0x24,%esp
  8011e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011f2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011f9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011fc:	50                   	push   %eax
  8011fd:	e8 38 ff ff ff       	call   80113a <fd_lookup>
  801202:	89 c3                	mov    %eax,%ebx
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	85 c0                	test   %eax,%eax
  801209:	78 05                	js     801210 <fd_close+0x30>
	    || fd != fd2)
  80120b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80120e:	74 16                	je     801226 <fd_close+0x46>
		return (must_exist ? r : 0);
  801210:	89 f8                	mov    %edi,%eax
  801212:	84 c0                	test   %al,%al
  801214:	b8 00 00 00 00       	mov    $0x0,%eax
  801219:	0f 44 d8             	cmove  %eax,%ebx
}
  80121c:	89 d8                	mov    %ebx,%eax
  80121e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801221:	5b                   	pop    %ebx
  801222:	5e                   	pop    %esi
  801223:	5f                   	pop    %edi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801226:	83 ec 08             	sub    $0x8,%esp
  801229:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80122c:	50                   	push   %eax
  80122d:	ff 36                	pushl  (%esi)
  80122f:	e8 56 ff ff ff       	call   80118a <dev_lookup>
  801234:	89 c3                	mov    %eax,%ebx
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 1a                	js     801257 <fd_close+0x77>
		if (dev->dev_close)
  80123d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801240:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801243:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801248:	85 c0                	test   %eax,%eax
  80124a:	74 0b                	je     801257 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80124c:	83 ec 0c             	sub    $0xc,%esp
  80124f:	56                   	push   %esi
  801250:	ff d0                	call   *%eax
  801252:	89 c3                	mov    %eax,%ebx
  801254:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	56                   	push   %esi
  80125b:	6a 00                	push   $0x0
  80125d:	e8 24 fb ff ff       	call   800d86 <sys_page_unmap>
	return r;
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	eb b5                	jmp    80121c <fd_close+0x3c>

00801267 <close>:

int
close(int fdnum)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80126d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801270:	50                   	push   %eax
  801271:	ff 75 08             	pushl  0x8(%ebp)
  801274:	e8 c1 fe ff ff       	call   80113a <fd_lookup>
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	85 c0                	test   %eax,%eax
  80127e:	79 02                	jns    801282 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    
		return fd_close(fd, 1);
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	6a 01                	push   $0x1
  801287:	ff 75 f4             	pushl  -0xc(%ebp)
  80128a:	e8 51 ff ff ff       	call   8011e0 <fd_close>
  80128f:	83 c4 10             	add    $0x10,%esp
  801292:	eb ec                	jmp    801280 <close+0x19>

00801294 <close_all>:

void
close_all(void)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	53                   	push   %ebx
  801298:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80129b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012a0:	83 ec 0c             	sub    $0xc,%esp
  8012a3:	53                   	push   %ebx
  8012a4:	e8 be ff ff ff       	call   801267 <close>
	for (i = 0; i < MAXFD; i++)
  8012a9:	83 c3 01             	add    $0x1,%ebx
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	83 fb 20             	cmp    $0x20,%ebx
  8012b2:	75 ec                	jne    8012a0 <close_all+0xc>
}
  8012b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	57                   	push   %edi
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c5:	50                   	push   %eax
  8012c6:	ff 75 08             	pushl  0x8(%ebp)
  8012c9:	e8 6c fe ff ff       	call   80113a <fd_lookup>
  8012ce:	89 c3                	mov    %eax,%ebx
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	0f 88 81 00 00 00    	js     80135c <dup+0xa3>
		return r;
	close(newfdnum);
  8012db:	83 ec 0c             	sub    $0xc,%esp
  8012de:	ff 75 0c             	pushl  0xc(%ebp)
  8012e1:	e8 81 ff ff ff       	call   801267 <close>

	newfd = INDEX2FD(newfdnum);
  8012e6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012e9:	c1 e6 0c             	shl    $0xc,%esi
  8012ec:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012f2:	83 c4 04             	add    $0x4,%esp
  8012f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012f8:	e8 d4 fd ff ff       	call   8010d1 <fd2data>
  8012fd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012ff:	89 34 24             	mov    %esi,(%esp)
  801302:	e8 ca fd ff ff       	call   8010d1 <fd2data>
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80130c:	89 d8                	mov    %ebx,%eax
  80130e:	c1 e8 16             	shr    $0x16,%eax
  801311:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801318:	a8 01                	test   $0x1,%al
  80131a:	74 11                	je     80132d <dup+0x74>
  80131c:	89 d8                	mov    %ebx,%eax
  80131e:	c1 e8 0c             	shr    $0xc,%eax
  801321:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801328:	f6 c2 01             	test   $0x1,%dl
  80132b:	75 39                	jne    801366 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80132d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801330:	89 d0                	mov    %edx,%eax
  801332:	c1 e8 0c             	shr    $0xc,%eax
  801335:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80133c:	83 ec 0c             	sub    $0xc,%esp
  80133f:	25 07 0e 00 00       	and    $0xe07,%eax
  801344:	50                   	push   %eax
  801345:	56                   	push   %esi
  801346:	6a 00                	push   $0x0
  801348:	52                   	push   %edx
  801349:	6a 00                	push   $0x0
  80134b:	e8 f4 f9 ff ff       	call   800d44 <sys_page_map>
  801350:	89 c3                	mov    %eax,%ebx
  801352:	83 c4 20             	add    $0x20,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	78 31                	js     80138a <dup+0xd1>
		goto err;

	return newfdnum;
  801359:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80135c:	89 d8                	mov    %ebx,%eax
  80135e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801361:	5b                   	pop    %ebx
  801362:	5e                   	pop    %esi
  801363:	5f                   	pop    %edi
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801366:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80136d:	83 ec 0c             	sub    $0xc,%esp
  801370:	25 07 0e 00 00       	and    $0xe07,%eax
  801375:	50                   	push   %eax
  801376:	57                   	push   %edi
  801377:	6a 00                	push   $0x0
  801379:	53                   	push   %ebx
  80137a:	6a 00                	push   $0x0
  80137c:	e8 c3 f9 ff ff       	call   800d44 <sys_page_map>
  801381:	89 c3                	mov    %eax,%ebx
  801383:	83 c4 20             	add    $0x20,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	79 a3                	jns    80132d <dup+0x74>
	sys_page_unmap(0, newfd);
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	56                   	push   %esi
  80138e:	6a 00                	push   $0x0
  801390:	e8 f1 f9 ff ff       	call   800d86 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801395:	83 c4 08             	add    $0x8,%esp
  801398:	57                   	push   %edi
  801399:	6a 00                	push   $0x0
  80139b:	e8 e6 f9 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	eb b7                	jmp    80135c <dup+0xa3>

008013a5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	53                   	push   %ebx
  8013a9:	83 ec 1c             	sub    $0x1c,%esp
  8013ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b2:	50                   	push   %eax
  8013b3:	53                   	push   %ebx
  8013b4:	e8 81 fd ff ff       	call   80113a <fd_lookup>
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 3f                	js     8013ff <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c6:	50                   	push   %eax
  8013c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ca:	ff 30                	pushl  (%eax)
  8013cc:	e8 b9 fd ff ff       	call   80118a <dev_lookup>
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	78 27                	js     8013ff <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013db:	8b 42 08             	mov    0x8(%edx),%eax
  8013de:	83 e0 03             	and    $0x3,%eax
  8013e1:	83 f8 01             	cmp    $0x1,%eax
  8013e4:	74 1e                	je     801404 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e9:	8b 40 08             	mov    0x8(%eax),%eax
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	74 35                	je     801425 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	ff 75 10             	pushl  0x10(%ebp)
  8013f6:	ff 75 0c             	pushl  0xc(%ebp)
  8013f9:	52                   	push   %edx
  8013fa:	ff d0                	call   *%eax
  8013fc:	83 c4 10             	add    $0x10,%esp
}
  8013ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801402:	c9                   	leave  
  801403:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801404:	a1 04 40 80 00       	mov    0x804004,%eax
  801409:	8b 40 48             	mov    0x48(%eax),%eax
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	53                   	push   %ebx
  801410:	50                   	push   %eax
  801411:	68 8d 26 80 00       	push   $0x80268d
  801416:	e8 e6 ed ff ff       	call   800201 <cprintf>
		return -E_INVAL;
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801423:	eb da                	jmp    8013ff <read+0x5a>
		return -E_NOT_SUPP;
  801425:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80142a:	eb d3                	jmp    8013ff <read+0x5a>

0080142c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	57                   	push   %edi
  801430:	56                   	push   %esi
  801431:	53                   	push   %ebx
  801432:	83 ec 0c             	sub    $0xc,%esp
  801435:	8b 7d 08             	mov    0x8(%ebp),%edi
  801438:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80143b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801440:	39 f3                	cmp    %esi,%ebx
  801442:	73 23                	jae    801467 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801444:	83 ec 04             	sub    $0x4,%esp
  801447:	89 f0                	mov    %esi,%eax
  801449:	29 d8                	sub    %ebx,%eax
  80144b:	50                   	push   %eax
  80144c:	89 d8                	mov    %ebx,%eax
  80144e:	03 45 0c             	add    0xc(%ebp),%eax
  801451:	50                   	push   %eax
  801452:	57                   	push   %edi
  801453:	e8 4d ff ff ff       	call   8013a5 <read>
		if (m < 0)
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 06                	js     801465 <readn+0x39>
			return m;
		if (m == 0)
  80145f:	74 06                	je     801467 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801461:	01 c3                	add    %eax,%ebx
  801463:	eb db                	jmp    801440 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801465:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801467:	89 d8                	mov    %ebx,%eax
  801469:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5e                   	pop    %esi
  80146e:	5f                   	pop    %edi
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    

00801471 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	53                   	push   %ebx
  801475:	83 ec 1c             	sub    $0x1c,%esp
  801478:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147e:	50                   	push   %eax
  80147f:	53                   	push   %ebx
  801480:	e8 b5 fc ff ff       	call   80113a <fd_lookup>
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 3a                	js     8014c6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801496:	ff 30                	pushl  (%eax)
  801498:	e8 ed fc ff ff       	call   80118a <dev_lookup>
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 22                	js     8014c6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ab:	74 1e                	je     8014cb <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b0:	8b 52 0c             	mov    0xc(%edx),%edx
  8014b3:	85 d2                	test   %edx,%edx
  8014b5:	74 35                	je     8014ec <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	ff 75 10             	pushl  0x10(%ebp)
  8014bd:	ff 75 0c             	pushl  0xc(%ebp)
  8014c0:	50                   	push   %eax
  8014c1:	ff d2                	call   *%edx
  8014c3:	83 c4 10             	add    $0x10,%esp
}
  8014c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d0:	8b 40 48             	mov    0x48(%eax),%eax
  8014d3:	83 ec 04             	sub    $0x4,%esp
  8014d6:	53                   	push   %ebx
  8014d7:	50                   	push   %eax
  8014d8:	68 a9 26 80 00       	push   $0x8026a9
  8014dd:	e8 1f ed ff ff       	call   800201 <cprintf>
		return -E_INVAL;
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ea:	eb da                	jmp    8014c6 <write+0x55>
		return -E_NOT_SUPP;
  8014ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f1:	eb d3                	jmp    8014c6 <write+0x55>

008014f3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 35 fc ff ff       	call   80113a <fd_lookup>
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	78 0e                	js     80151a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80150c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801512:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801515:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	53                   	push   %ebx
  801520:	83 ec 1c             	sub    $0x1c,%esp
  801523:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801526:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801529:	50                   	push   %eax
  80152a:	53                   	push   %ebx
  80152b:	e8 0a fc ff ff       	call   80113a <fd_lookup>
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	78 37                	js     80156e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153d:	50                   	push   %eax
  80153e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801541:	ff 30                	pushl  (%eax)
  801543:	e8 42 fc ff ff       	call   80118a <dev_lookup>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 1f                	js     80156e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80154f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801552:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801556:	74 1b                	je     801573 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155b:	8b 52 18             	mov    0x18(%edx),%edx
  80155e:	85 d2                	test   %edx,%edx
  801560:	74 32                	je     801594 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	50                   	push   %eax
  801569:	ff d2                	call   *%edx
  80156b:	83 c4 10             	add    $0x10,%esp
}
  80156e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801571:	c9                   	leave  
  801572:	c3                   	ret    
			thisenv->env_id, fdnum);
  801573:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801578:	8b 40 48             	mov    0x48(%eax),%eax
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	53                   	push   %ebx
  80157f:	50                   	push   %eax
  801580:	68 6c 26 80 00       	push   $0x80266c
  801585:	e8 77 ec ff ff       	call   800201 <cprintf>
		return -E_INVAL;
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801592:	eb da                	jmp    80156e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801594:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801599:	eb d3                	jmp    80156e <ftruncate+0x52>

0080159b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	53                   	push   %ebx
  80159f:	83 ec 1c             	sub    $0x1c,%esp
  8015a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a8:	50                   	push   %eax
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 89 fb ff ff       	call   80113a <fd_lookup>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	78 4b                	js     801603 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b8:	83 ec 08             	sub    $0x8,%esp
  8015bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015be:	50                   	push   %eax
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	ff 30                	pushl  (%eax)
  8015c4:	e8 c1 fb ff ff       	call   80118a <dev_lookup>
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 33                	js     801603 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015d7:	74 2f                	je     801608 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015e3:	00 00 00 
	stat->st_isdir = 0;
  8015e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015ed:	00 00 00 
	stat->st_dev = dev;
  8015f0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	53                   	push   %ebx
  8015fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fd:	ff 50 14             	call   *0x14(%eax)
  801600:	83 c4 10             	add    $0x10,%esp
}
  801603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801606:	c9                   	leave  
  801607:	c3                   	ret    
		return -E_NOT_SUPP;
  801608:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80160d:	eb f4                	jmp    801603 <fstat+0x68>

0080160f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	6a 00                	push   $0x0
  801619:	ff 75 08             	pushl  0x8(%ebp)
  80161c:	e8 e7 01 00 00       	call   801808 <open>
  801621:	89 c3                	mov    %eax,%ebx
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	85 c0                	test   %eax,%eax
  801628:	78 1b                	js     801645 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80162a:	83 ec 08             	sub    $0x8,%esp
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	50                   	push   %eax
  801631:	e8 65 ff ff ff       	call   80159b <fstat>
  801636:	89 c6                	mov    %eax,%esi
	close(fd);
  801638:	89 1c 24             	mov    %ebx,(%esp)
  80163b:	e8 27 fc ff ff       	call   801267 <close>
	return r;
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	89 f3                	mov    %esi,%ebx
}
  801645:	89 d8                	mov    %ebx,%eax
  801647:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164a:	5b                   	pop    %ebx
  80164b:	5e                   	pop    %esi
  80164c:	5d                   	pop    %ebp
  80164d:	c3                   	ret    

0080164e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
  801653:	89 c6                	mov    %eax,%esi
  801655:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801657:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80165e:	74 27                	je     801687 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801660:	6a 07                	push   $0x7
  801662:	68 00 50 80 00       	push   $0x805000
  801667:	56                   	push   %esi
  801668:	ff 35 00 40 80 00    	pushl  0x804000
  80166e:	e8 be 08 00 00       	call   801f31 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801673:	83 c4 0c             	add    $0xc,%esp
  801676:	6a 00                	push   $0x0
  801678:	53                   	push   %ebx
  801679:	6a 00                	push   $0x0
  80167b:	e8 4a 08 00 00       	call   801eca <ipc_recv>
}
  801680:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801683:	5b                   	pop    %ebx
  801684:	5e                   	pop    %esi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801687:	83 ec 0c             	sub    $0xc,%esp
  80168a:	6a 01                	push   $0x1
  80168c:	e8 e9 08 00 00       	call   801f7a <ipc_find_env>
  801691:	a3 00 40 80 00       	mov    %eax,0x804000
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	eb c5                	jmp    801660 <fsipc+0x12>

0080169b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016af:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	b8 02 00 00 00       	mov    $0x2,%eax
  8016be:	e8 8b ff ff ff       	call   80164e <fsipc>
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <devfile_flush>:
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016db:	b8 06 00 00 00       	mov    $0x6,%eax
  8016e0:	e8 69 ff ff ff       	call   80164e <fsipc>
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <devfile_stat>:
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	53                   	push   %ebx
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801701:	b8 05 00 00 00       	mov    $0x5,%eax
  801706:	e8 43 ff ff ff       	call   80164e <fsipc>
  80170b:	85 c0                	test   %eax,%eax
  80170d:	78 2c                	js     80173b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	68 00 50 80 00       	push   $0x805000
  801717:	53                   	push   %ebx
  801718:	e8 f2 f1 ff ff       	call   80090f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80171d:	a1 80 50 80 00       	mov    0x805080,%eax
  801722:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801728:	a1 84 50 80 00       	mov    0x805084,%eax
  80172d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <devfile_write>:
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 0c             	sub    $0xc,%esp
  801746:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801749:	8b 55 08             	mov    0x8(%ebp),%edx
  80174c:	8b 52 0c             	mov    0xc(%edx),%edx
  80174f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801755:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80175a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80175f:	0f 47 c2             	cmova  %edx,%eax
  801762:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801767:	50                   	push   %eax
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	68 08 50 80 00       	push   $0x805008
  801770:	e8 28 f3 ff ff       	call   800a9d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	b8 04 00 00 00       	mov    $0x4,%eax
  80177f:	e8 ca fe ff ff       	call   80164e <fsipc>
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <devfile_read>:
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	56                   	push   %esi
  80178a:	53                   	push   %ebx
  80178b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8b 40 0c             	mov    0xc(%eax),%eax
  801794:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801799:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80179f:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a9:	e8 a0 fe ff ff       	call   80164e <fsipc>
  8017ae:	89 c3                	mov    %eax,%ebx
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	78 1f                	js     8017d3 <devfile_read+0x4d>
	assert(r <= n);
  8017b4:	39 f0                	cmp    %esi,%eax
  8017b6:	77 24                	ja     8017dc <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017b8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017bd:	7f 33                	jg     8017f2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	50                   	push   %eax
  8017c3:	68 00 50 80 00       	push   $0x805000
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	e8 cd f2 ff ff       	call   800a9d <memmove>
	return r;
  8017d0:	83 c4 10             	add    $0x10,%esp
}
  8017d3:	89 d8                	mov    %ebx,%eax
  8017d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    
	assert(r <= n);
  8017dc:	68 d8 26 80 00       	push   $0x8026d8
  8017e1:	68 df 26 80 00       	push   $0x8026df
  8017e6:	6a 7c                	push   $0x7c
  8017e8:	68 f4 26 80 00       	push   $0x8026f4
  8017ed:	e8 92 06 00 00       	call   801e84 <_panic>
	assert(r <= PGSIZE);
  8017f2:	68 ff 26 80 00       	push   $0x8026ff
  8017f7:	68 df 26 80 00       	push   $0x8026df
  8017fc:	6a 7d                	push   $0x7d
  8017fe:	68 f4 26 80 00       	push   $0x8026f4
  801803:	e8 7c 06 00 00       	call   801e84 <_panic>

00801808 <open>:
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	83 ec 1c             	sub    $0x1c,%esp
  801810:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801813:	56                   	push   %esi
  801814:	e8 bd f0 ff ff       	call   8008d6 <strlen>
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801821:	7f 6c                	jg     80188f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801823:	83 ec 0c             	sub    $0xc,%esp
  801826:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801829:	50                   	push   %eax
  80182a:	e8 b9 f8 ff ff       	call   8010e8 <fd_alloc>
  80182f:	89 c3                	mov    %eax,%ebx
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	85 c0                	test   %eax,%eax
  801836:	78 3c                	js     801874 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	56                   	push   %esi
  80183c:	68 00 50 80 00       	push   $0x805000
  801841:	e8 c9 f0 ff ff       	call   80090f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801846:	8b 45 0c             	mov    0xc(%ebp),%eax
  801849:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80184e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801851:	b8 01 00 00 00       	mov    $0x1,%eax
  801856:	e8 f3 fd ff ff       	call   80164e <fsipc>
  80185b:	89 c3                	mov    %eax,%ebx
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	85 c0                	test   %eax,%eax
  801862:	78 19                	js     80187d <open+0x75>
	return fd2num(fd);
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	ff 75 f4             	pushl  -0xc(%ebp)
  80186a:	e8 52 f8 ff ff       	call   8010c1 <fd2num>
  80186f:	89 c3                	mov    %eax,%ebx
  801871:	83 c4 10             	add    $0x10,%esp
}
  801874:	89 d8                	mov    %ebx,%eax
  801876:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801879:	5b                   	pop    %ebx
  80187a:	5e                   	pop    %esi
  80187b:	5d                   	pop    %ebp
  80187c:	c3                   	ret    
		fd_close(fd, 0);
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	6a 00                	push   $0x0
  801882:	ff 75 f4             	pushl  -0xc(%ebp)
  801885:	e8 56 f9 ff ff       	call   8011e0 <fd_close>
		return r;
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	eb e5                	jmp    801874 <open+0x6c>
		return -E_BAD_PATH;
  80188f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801894:	eb de                	jmp    801874 <open+0x6c>

00801896 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80189c:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8018a6:	e8 a3 fd ff ff       	call   80164e <fsipc>
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8018ad:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8018b1:	7f 01                	jg     8018b4 <writebuf+0x7>
  8018b3:	c3                   	ret    
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 08             	sub    $0x8,%esp
  8018bb:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8018bd:	ff 70 04             	pushl  0x4(%eax)
  8018c0:	8d 40 10             	lea    0x10(%eax),%eax
  8018c3:	50                   	push   %eax
  8018c4:	ff 33                	pushl  (%ebx)
  8018c6:	e8 a6 fb ff ff       	call   801471 <write>
		if (result > 0)
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	7e 03                	jle    8018d5 <writebuf+0x28>
			b->result += result;
  8018d2:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8018d5:	39 43 04             	cmp    %eax,0x4(%ebx)
  8018d8:	74 0d                	je     8018e7 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e1:	0f 4f c2             	cmovg  %edx,%eax
  8018e4:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8018e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <putch>:

static void
putch(int ch, void *thunk)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8018f6:	8b 53 04             	mov    0x4(%ebx),%edx
  8018f9:	8d 42 01             	lea    0x1(%edx),%eax
  8018fc:	89 43 04             	mov    %eax,0x4(%ebx)
  8018ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801902:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801906:	3d 00 01 00 00       	cmp    $0x100,%eax
  80190b:	74 06                	je     801913 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80190d:	83 c4 04             	add    $0x4,%esp
  801910:	5b                   	pop    %ebx
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    
		writebuf(b);
  801913:	89 d8                	mov    %ebx,%eax
  801915:	e8 93 ff ff ff       	call   8018ad <writebuf>
		b->idx = 0;
  80191a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801921:	eb ea                	jmp    80190d <putch+0x21>

00801923 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801935:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80193c:	00 00 00 
	b.result = 0;
  80193f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801946:	00 00 00 
	b.error = 1;
  801949:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801950:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801953:	ff 75 10             	pushl  0x10(%ebp)
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80195f:	50                   	push   %eax
  801960:	68 ec 18 80 00       	push   $0x8018ec
  801965:	e8 c4 e9 ff ff       	call   80032e <vprintfmt>
	if (b.idx > 0)
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801974:	7f 11                	jg     801987 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801976:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80197c:	85 c0                	test   %eax,%eax
  80197e:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    
		writebuf(&b);
  801987:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80198d:	e8 1b ff ff ff       	call   8018ad <writebuf>
  801992:	eb e2                	jmp    801976 <vfprintf+0x53>

00801994 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80199a:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80199d:	50                   	push   %eax
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	e8 7a ff ff ff       	call   801923 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <printf>:

int
printf(const char *fmt, ...)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019b1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8019b4:	50                   	push   %eax
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 01                	push   $0x1
  8019ba:	e8 64 ff ff ff       	call   801923 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	56                   	push   %esi
  8019c5:	53                   	push   %ebx
  8019c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	e8 fd f6 ff ff       	call   8010d1 <fd2data>
  8019d4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019d6:	83 c4 08             	add    $0x8,%esp
  8019d9:	68 0b 27 80 00       	push   $0x80270b
  8019de:	53                   	push   %ebx
  8019df:	e8 2b ef ff ff       	call   80090f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019e4:	8b 46 04             	mov    0x4(%esi),%eax
  8019e7:	2b 06                	sub    (%esi),%eax
  8019e9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019f6:	00 00 00 
	stat->st_dev = &devpipe;
  8019f9:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a00:	30 80 00 
	return 0;
}
  801a03:	b8 00 00 00 00       	mov    $0x0,%eax
  801a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    

00801a0f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	53                   	push   %ebx
  801a13:	83 ec 0c             	sub    $0xc,%esp
  801a16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a19:	53                   	push   %ebx
  801a1a:	6a 00                	push   $0x0
  801a1c:	e8 65 f3 ff ff       	call   800d86 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a21:	89 1c 24             	mov    %ebx,(%esp)
  801a24:	e8 a8 f6 ff ff       	call   8010d1 <fd2data>
  801a29:	83 c4 08             	add    $0x8,%esp
  801a2c:	50                   	push   %eax
  801a2d:	6a 00                	push   $0x0
  801a2f:	e8 52 f3 ff ff       	call   800d86 <sys_page_unmap>
}
  801a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <_pipeisclosed>:
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	57                   	push   %edi
  801a3d:	56                   	push   %esi
  801a3e:	53                   	push   %ebx
  801a3f:	83 ec 1c             	sub    $0x1c,%esp
  801a42:	89 c7                	mov    %eax,%edi
  801a44:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a46:	a1 04 40 80 00       	mov    0x804004,%eax
  801a4b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a4e:	83 ec 0c             	sub    $0xc,%esp
  801a51:	57                   	push   %edi
  801a52:	e8 62 05 00 00       	call   801fb9 <pageref>
  801a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a5a:	89 34 24             	mov    %esi,(%esp)
  801a5d:	e8 57 05 00 00       	call   801fb9 <pageref>
		nn = thisenv->env_runs;
  801a62:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a68:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	39 cb                	cmp    %ecx,%ebx
  801a70:	74 1b                	je     801a8d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a75:	75 cf                	jne    801a46 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a77:	8b 42 58             	mov    0x58(%edx),%eax
  801a7a:	6a 01                	push   $0x1
  801a7c:	50                   	push   %eax
  801a7d:	53                   	push   %ebx
  801a7e:	68 12 27 80 00       	push   $0x802712
  801a83:	e8 79 e7 ff ff       	call   800201 <cprintf>
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	eb b9                	jmp    801a46 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a8d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a90:	0f 94 c0             	sete   %al
  801a93:	0f b6 c0             	movzbl %al,%eax
}
  801a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a99:	5b                   	pop    %ebx
  801a9a:	5e                   	pop    %esi
  801a9b:	5f                   	pop    %edi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    

00801a9e <devpipe_write>:
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	57                   	push   %edi
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 28             	sub    $0x28,%esp
  801aa7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801aaa:	56                   	push   %esi
  801aab:	e8 21 f6 ff ff       	call   8010d1 <fd2data>
  801ab0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	bf 00 00 00 00       	mov    $0x0,%edi
  801aba:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801abd:	74 4f                	je     801b0e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801abf:	8b 43 04             	mov    0x4(%ebx),%eax
  801ac2:	8b 0b                	mov    (%ebx),%ecx
  801ac4:	8d 51 20             	lea    0x20(%ecx),%edx
  801ac7:	39 d0                	cmp    %edx,%eax
  801ac9:	72 14                	jb     801adf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801acb:	89 da                	mov    %ebx,%edx
  801acd:	89 f0                	mov    %esi,%eax
  801acf:	e8 65 ff ff ff       	call   801a39 <_pipeisclosed>
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	75 3b                	jne    801b13 <devpipe_write+0x75>
			sys_yield();
  801ad8:	e8 05 f2 ff ff       	call   800ce2 <sys_yield>
  801add:	eb e0                	jmp    801abf <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801adf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ae2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ae6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ae9:	89 c2                	mov    %eax,%edx
  801aeb:	c1 fa 1f             	sar    $0x1f,%edx
  801aee:	89 d1                	mov    %edx,%ecx
  801af0:	c1 e9 1b             	shr    $0x1b,%ecx
  801af3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801af6:	83 e2 1f             	and    $0x1f,%edx
  801af9:	29 ca                	sub    %ecx,%edx
  801afb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b03:	83 c0 01             	add    $0x1,%eax
  801b06:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b09:	83 c7 01             	add    $0x1,%edi
  801b0c:	eb ac                	jmp    801aba <devpipe_write+0x1c>
	return i;
  801b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b11:	eb 05                	jmp    801b18 <devpipe_write+0x7a>
				return 0;
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5f                   	pop    %edi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    

00801b20 <devpipe_read>:
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	57                   	push   %edi
  801b24:	56                   	push   %esi
  801b25:	53                   	push   %ebx
  801b26:	83 ec 18             	sub    $0x18,%esp
  801b29:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b2c:	57                   	push   %edi
  801b2d:	e8 9f f5 ff ff       	call   8010d1 <fd2data>
  801b32:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b34:	83 c4 10             	add    $0x10,%esp
  801b37:	be 00 00 00 00       	mov    $0x0,%esi
  801b3c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b3f:	75 14                	jne    801b55 <devpipe_read+0x35>
	return i;
  801b41:	8b 45 10             	mov    0x10(%ebp),%eax
  801b44:	eb 02                	jmp    801b48 <devpipe_read+0x28>
				return i;
  801b46:	89 f0                	mov    %esi,%eax
}
  801b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4b:	5b                   	pop    %ebx
  801b4c:	5e                   	pop    %esi
  801b4d:	5f                   	pop    %edi
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    
			sys_yield();
  801b50:	e8 8d f1 ff ff       	call   800ce2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b55:	8b 03                	mov    (%ebx),%eax
  801b57:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b5a:	75 18                	jne    801b74 <devpipe_read+0x54>
			if (i > 0)
  801b5c:	85 f6                	test   %esi,%esi
  801b5e:	75 e6                	jne    801b46 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b60:	89 da                	mov    %ebx,%edx
  801b62:	89 f8                	mov    %edi,%eax
  801b64:	e8 d0 fe ff ff       	call   801a39 <_pipeisclosed>
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	74 e3                	je     801b50 <devpipe_read+0x30>
				return 0;
  801b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b72:	eb d4                	jmp    801b48 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b74:	99                   	cltd   
  801b75:	c1 ea 1b             	shr    $0x1b,%edx
  801b78:	01 d0                	add    %edx,%eax
  801b7a:	83 e0 1f             	and    $0x1f,%eax
  801b7d:	29 d0                	sub    %edx,%eax
  801b7f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b87:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b8a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b8d:	83 c6 01             	add    $0x1,%esi
  801b90:	eb aa                	jmp    801b3c <devpipe_read+0x1c>

00801b92 <pipe>:
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	56                   	push   %esi
  801b96:	53                   	push   %ebx
  801b97:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9d:	50                   	push   %eax
  801b9e:	e8 45 f5 ff ff       	call   8010e8 <fd_alloc>
  801ba3:	89 c3                	mov    %eax,%ebx
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	0f 88 23 01 00 00    	js     801cd3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	68 07 04 00 00       	push   $0x407
  801bb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbb:	6a 00                	push   $0x0
  801bbd:	e8 3f f1 ff ff       	call   800d01 <sys_page_alloc>
  801bc2:	89 c3                	mov    %eax,%ebx
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	0f 88 04 01 00 00    	js     801cd3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bd5:	50                   	push   %eax
  801bd6:	e8 0d f5 ff ff       	call   8010e8 <fd_alloc>
  801bdb:	89 c3                	mov    %eax,%ebx
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	85 c0                	test   %eax,%eax
  801be2:	0f 88 db 00 00 00    	js     801cc3 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	68 07 04 00 00       	push   $0x407
  801bf0:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf3:	6a 00                	push   $0x0
  801bf5:	e8 07 f1 ff ff       	call   800d01 <sys_page_alloc>
  801bfa:	89 c3                	mov    %eax,%ebx
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	85 c0                	test   %eax,%eax
  801c01:	0f 88 bc 00 00 00    	js     801cc3 <pipe+0x131>
	va = fd2data(fd0);
  801c07:	83 ec 0c             	sub    $0xc,%esp
  801c0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0d:	e8 bf f4 ff ff       	call   8010d1 <fd2data>
  801c12:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c14:	83 c4 0c             	add    $0xc,%esp
  801c17:	68 07 04 00 00       	push   $0x407
  801c1c:	50                   	push   %eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	e8 dd f0 ff ff       	call   800d01 <sys_page_alloc>
  801c24:	89 c3                	mov    %eax,%ebx
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	0f 88 82 00 00 00    	js     801cb3 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	ff 75 f0             	pushl  -0x10(%ebp)
  801c37:	e8 95 f4 ff ff       	call   8010d1 <fd2data>
  801c3c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c43:	50                   	push   %eax
  801c44:	6a 00                	push   $0x0
  801c46:	56                   	push   %esi
  801c47:	6a 00                	push   $0x0
  801c49:	e8 f6 f0 ff ff       	call   800d44 <sys_page_map>
  801c4e:	89 c3                	mov    %eax,%ebx
  801c50:	83 c4 20             	add    $0x20,%esp
  801c53:	85 c0                	test   %eax,%eax
  801c55:	78 4e                	js     801ca5 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c57:	a1 20 30 80 00       	mov    0x803020,%eax
  801c5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c64:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c6e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c73:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c7a:	83 ec 0c             	sub    $0xc,%esp
  801c7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c80:	e8 3c f4 ff ff       	call   8010c1 <fd2num>
  801c85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c88:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c8a:	83 c4 04             	add    $0x4,%esp
  801c8d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c90:	e8 2c f4 ff ff       	call   8010c1 <fd2num>
  801c95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c98:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ca3:	eb 2e                	jmp    801cd3 <pipe+0x141>
	sys_page_unmap(0, va);
  801ca5:	83 ec 08             	sub    $0x8,%esp
  801ca8:	56                   	push   %esi
  801ca9:	6a 00                	push   $0x0
  801cab:	e8 d6 f0 ff ff       	call   800d86 <sys_page_unmap>
  801cb0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cb3:	83 ec 08             	sub    $0x8,%esp
  801cb6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb9:	6a 00                	push   $0x0
  801cbb:	e8 c6 f0 ff ff       	call   800d86 <sys_page_unmap>
  801cc0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801cc3:	83 ec 08             	sub    $0x8,%esp
  801cc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc9:	6a 00                	push   $0x0
  801ccb:	e8 b6 f0 ff ff       	call   800d86 <sys_page_unmap>
  801cd0:	83 c4 10             	add    $0x10,%esp
}
  801cd3:	89 d8                	mov    %ebx,%eax
  801cd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd8:	5b                   	pop    %ebx
  801cd9:	5e                   	pop    %esi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    

00801cdc <pipeisclosed>:
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ce2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce5:	50                   	push   %eax
  801ce6:	ff 75 08             	pushl  0x8(%ebp)
  801ce9:	e8 4c f4 ff ff       	call   80113a <fd_lookup>
  801cee:	83 c4 10             	add    $0x10,%esp
  801cf1:	85 c0                	test   %eax,%eax
  801cf3:	78 18                	js     801d0d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801cf5:	83 ec 0c             	sub    $0xc,%esp
  801cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfb:	e8 d1 f3 ff ff       	call   8010d1 <fd2data>
	return _pipeisclosed(fd, p);
  801d00:	89 c2                	mov    %eax,%edx
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	e8 2f fd ff ff       	call   801a39 <_pipeisclosed>
  801d0a:	83 c4 10             	add    $0x10,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	c3                   	ret    

00801d15 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d1b:	68 2a 27 80 00       	push   $0x80272a
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	e8 e7 eb ff ff       	call   80090f <strcpy>
	return 0;
}
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <devcons_write>:
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	57                   	push   %edi
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d3b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d40:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d46:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d49:	73 31                	jae    801d7c <devcons_write+0x4d>
		m = n - tot;
  801d4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d4e:	29 f3                	sub    %esi,%ebx
  801d50:	83 fb 7f             	cmp    $0x7f,%ebx
  801d53:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d58:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d5b:	83 ec 04             	sub    $0x4,%esp
  801d5e:	53                   	push   %ebx
  801d5f:	89 f0                	mov    %esi,%eax
  801d61:	03 45 0c             	add    0xc(%ebp),%eax
  801d64:	50                   	push   %eax
  801d65:	57                   	push   %edi
  801d66:	e8 32 ed ff ff       	call   800a9d <memmove>
		sys_cputs(buf, m);
  801d6b:	83 c4 08             	add    $0x8,%esp
  801d6e:	53                   	push   %ebx
  801d6f:	57                   	push   %edi
  801d70:	e8 d0 ee ff ff       	call   800c45 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d75:	01 de                	add    %ebx,%esi
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	eb ca                	jmp    801d46 <devcons_write+0x17>
}
  801d7c:	89 f0                	mov    %esi,%eax
  801d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d81:	5b                   	pop    %ebx
  801d82:	5e                   	pop    %esi
  801d83:	5f                   	pop    %edi
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    

00801d86 <devcons_read>:
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d95:	74 21                	je     801db8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801d97:	e8 c7 ee ff ff       	call   800c63 <sys_cgetc>
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	75 07                	jne    801da7 <devcons_read+0x21>
		sys_yield();
  801da0:	e8 3d ef ff ff       	call   800ce2 <sys_yield>
  801da5:	eb f0                	jmp    801d97 <devcons_read+0x11>
	if (c < 0)
  801da7:	78 0f                	js     801db8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801da9:	83 f8 04             	cmp    $0x4,%eax
  801dac:	74 0c                	je     801dba <devcons_read+0x34>
	*(char*)vbuf = c;
  801dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db1:	88 02                	mov    %al,(%edx)
	return 1;
  801db3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    
		return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	eb f7                	jmp    801db8 <devcons_read+0x32>

00801dc1 <cputchar>:
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801dcd:	6a 01                	push   $0x1
  801dcf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dd2:	50                   	push   %eax
  801dd3:	e8 6d ee ff ff       	call   800c45 <sys_cputs>
}
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <getchar>:
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801de3:	6a 01                	push   $0x1
  801de5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801de8:	50                   	push   %eax
  801de9:	6a 00                	push   $0x0
  801deb:	e8 b5 f5 ff ff       	call   8013a5 <read>
	if (r < 0)
  801df0:	83 c4 10             	add    $0x10,%esp
  801df3:	85 c0                	test   %eax,%eax
  801df5:	78 06                	js     801dfd <getchar+0x20>
	if (r < 1)
  801df7:	74 06                	je     801dff <getchar+0x22>
	return c;
  801df9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    
		return -E_EOF;
  801dff:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e04:	eb f7                	jmp    801dfd <getchar+0x20>

00801e06 <iscons>:
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0f:	50                   	push   %eax
  801e10:	ff 75 08             	pushl  0x8(%ebp)
  801e13:	e8 22 f3 ff ff       	call   80113a <fd_lookup>
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	78 11                	js     801e30 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e22:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e28:	39 10                	cmp    %edx,(%eax)
  801e2a:	0f 94 c0             	sete   %al
  801e2d:	0f b6 c0             	movzbl %al,%eax
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <opencons>:
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3b:	50                   	push   %eax
  801e3c:	e8 a7 f2 ff ff       	call   8010e8 <fd_alloc>
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	85 c0                	test   %eax,%eax
  801e46:	78 3a                	js     801e82 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	68 07 04 00 00       	push   $0x407
  801e50:	ff 75 f4             	pushl  -0xc(%ebp)
  801e53:	6a 00                	push   $0x0
  801e55:	e8 a7 ee ff ff       	call   800d01 <sys_page_alloc>
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	78 21                	js     801e82 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e6a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	50                   	push   %eax
  801e7a:	e8 42 f2 ff ff       	call   8010c1 <fd2num>
  801e7f:	83 c4 10             	add    $0x10,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	56                   	push   %esi
  801e88:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e89:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e8c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e92:	e8 2c ee ff ff       	call   800cc3 <sys_getenvid>
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	ff 75 0c             	pushl  0xc(%ebp)
  801e9d:	ff 75 08             	pushl  0x8(%ebp)
  801ea0:	56                   	push   %esi
  801ea1:	50                   	push   %eax
  801ea2:	68 38 27 80 00       	push   $0x802738
  801ea7:	e8 55 e3 ff ff       	call   800201 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801eac:	83 c4 18             	add    $0x18,%esp
  801eaf:	53                   	push   %ebx
  801eb0:	ff 75 10             	pushl  0x10(%ebp)
  801eb3:	e8 f8 e2 ff ff       	call   8001b0 <vcprintf>
	cprintf("\n");
  801eb8:	c7 04 24 70 22 80 00 	movl   $0x802270,(%esp)
  801ebf:	e8 3d e3 ff ff       	call   800201 <cprintf>
  801ec4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ec7:	cc                   	int3   
  801ec8:	eb fd                	jmp    801ec7 <_panic+0x43>

00801eca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	56                   	push   %esi
  801ece:	53                   	push   %ebx
  801ecf:	8b 75 08             	mov    0x8(%ebp),%esi
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  801ed8:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801eda:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801edf:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	50                   	push   %eax
  801ee6:	e8 07 f0 ff ff       	call   800ef2 <sys_ipc_recv>
	if (from_env_store)
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	85 f6                	test   %esi,%esi
  801ef0:	74 14                	je     801f06 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	78 09                	js     801f04 <ipc_recv+0x3a>
  801efb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f01:	8b 52 78             	mov    0x78(%edx),%edx
  801f04:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  801f06:	85 db                	test   %ebx,%ebx
  801f08:	74 14                	je     801f1e <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  801f0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 09                	js     801f1c <ipc_recv+0x52>
  801f13:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f19:	8b 52 7c             	mov    0x7c(%edx),%edx
  801f1c:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 08                	js     801f2a <ipc_recv+0x60>
  801f22:	a1 04 40 80 00       	mov    0x804004,%eax
  801f27:	8b 40 74             	mov    0x74(%eax),%eax
}
  801f2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2d:	5b                   	pop    %ebx
  801f2e:	5e                   	pop    %esi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    

00801f31 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 08             	sub    $0x8,%esp
  801f37:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f41:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801f44:	ff 75 14             	pushl  0x14(%ebp)
  801f47:	50                   	push   %eax
  801f48:	ff 75 0c             	pushl  0xc(%ebp)
  801f4b:	ff 75 08             	pushl  0x8(%ebp)
  801f4e:	e8 7c ef ff ff       	call   800ecf <sys_ipc_try_send>
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	85 c0                	test   %eax,%eax
  801f58:	78 02                	js     801f5c <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  801f5c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f5f:	75 07                	jne    801f68 <ipc_send+0x37>
		sys_yield();
  801f61:	e8 7c ed ff ff       	call   800ce2 <sys_yield>
}
  801f66:	eb f2                	jmp    801f5a <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  801f68:	50                   	push   %eax
  801f69:	68 5c 27 80 00       	push   $0x80275c
  801f6e:	6a 3c                	push   $0x3c
  801f70:	68 70 27 80 00       	push   $0x802770
  801f75:	e8 0a ff ff ff       	call   801e84 <_panic>

00801f7a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f80:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  801f85:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801f88:	c1 e0 04             	shl    $0x4,%eax
  801f8b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f90:	8b 40 50             	mov    0x50(%eax),%eax
  801f93:	39 c8                	cmp    %ecx,%eax
  801f95:	74 12                	je     801fa9 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801f97:	83 c2 01             	add    $0x1,%edx
  801f9a:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  801fa0:	75 e3                	jne    801f85 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa7:	eb 0e                	jmp    801fb7 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801fa9:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801fac:	c1 e0 04             	shl    $0x4,%eax
  801faf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fb4:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    

00801fb9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fbf:	89 d0                	mov    %edx,%eax
  801fc1:	c1 e8 16             	shr    $0x16,%eax
  801fc4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fd0:	f6 c1 01             	test   $0x1,%cl
  801fd3:	74 1d                	je     801ff2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fd5:	c1 ea 0c             	shr    $0xc,%edx
  801fd8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fdf:	f6 c2 01             	test   $0x1,%dl
  801fe2:	74 0e                	je     801ff2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fe4:	c1 ea 0c             	shr    $0xc,%edx
  801fe7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fee:	ef 
  801fef:	0f b7 c0             	movzwl %ax,%eax
}
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    
  801ff4:	66 90                	xchg   %ax,%ax
  801ff6:	66 90                	xchg   %ax,%ax
  801ff8:	66 90                	xchg   %ax,%ax
  801ffa:	66 90                	xchg   %ax,%ax
  801ffc:	66 90                	xchg   %ax,%ax
  801ffe:	66 90                	xchg   %ax,%ax

00802000 <__udivdi3>:
  802000:	55                   	push   %ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	83 ec 1c             	sub    $0x1c,%esp
  802007:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80200b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80200f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802013:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802017:	85 d2                	test   %edx,%edx
  802019:	75 4d                	jne    802068 <__udivdi3+0x68>
  80201b:	39 f3                	cmp    %esi,%ebx
  80201d:	76 19                	jbe    802038 <__udivdi3+0x38>
  80201f:	31 ff                	xor    %edi,%edi
  802021:	89 e8                	mov    %ebp,%eax
  802023:	89 f2                	mov    %esi,%edx
  802025:	f7 f3                	div    %ebx
  802027:	89 fa                	mov    %edi,%edx
  802029:	83 c4 1c             	add    $0x1c,%esp
  80202c:	5b                   	pop    %ebx
  80202d:	5e                   	pop    %esi
  80202e:	5f                   	pop    %edi
  80202f:	5d                   	pop    %ebp
  802030:	c3                   	ret    
  802031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802038:	89 d9                	mov    %ebx,%ecx
  80203a:	85 db                	test   %ebx,%ebx
  80203c:	75 0b                	jne    802049 <__udivdi3+0x49>
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	31 d2                	xor    %edx,%edx
  802045:	f7 f3                	div    %ebx
  802047:	89 c1                	mov    %eax,%ecx
  802049:	31 d2                	xor    %edx,%edx
  80204b:	89 f0                	mov    %esi,%eax
  80204d:	f7 f1                	div    %ecx
  80204f:	89 c6                	mov    %eax,%esi
  802051:	89 e8                	mov    %ebp,%eax
  802053:	89 f7                	mov    %esi,%edi
  802055:	f7 f1                	div    %ecx
  802057:	89 fa                	mov    %edi,%edx
  802059:	83 c4 1c             	add    $0x1c,%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5e                   	pop    %esi
  80205e:	5f                   	pop    %edi
  80205f:	5d                   	pop    %ebp
  802060:	c3                   	ret    
  802061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802068:	39 f2                	cmp    %esi,%edx
  80206a:	77 1c                	ja     802088 <__udivdi3+0x88>
  80206c:	0f bd fa             	bsr    %edx,%edi
  80206f:	83 f7 1f             	xor    $0x1f,%edi
  802072:	75 2c                	jne    8020a0 <__udivdi3+0xa0>
  802074:	39 f2                	cmp    %esi,%edx
  802076:	72 06                	jb     80207e <__udivdi3+0x7e>
  802078:	31 c0                	xor    %eax,%eax
  80207a:	39 eb                	cmp    %ebp,%ebx
  80207c:	77 a9                	ja     802027 <__udivdi3+0x27>
  80207e:	b8 01 00 00 00       	mov    $0x1,%eax
  802083:	eb a2                	jmp    802027 <__udivdi3+0x27>
  802085:	8d 76 00             	lea    0x0(%esi),%esi
  802088:	31 ff                	xor    %edi,%edi
  80208a:	31 c0                	xor    %eax,%eax
  80208c:	89 fa                	mov    %edi,%edx
  80208e:	83 c4 1c             	add    $0x1c,%esp
  802091:	5b                   	pop    %ebx
  802092:	5e                   	pop    %esi
  802093:	5f                   	pop    %edi
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    
  802096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80209d:	8d 76 00             	lea    0x0(%esi),%esi
  8020a0:	89 f9                	mov    %edi,%ecx
  8020a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020a7:	29 f8                	sub    %edi,%eax
  8020a9:	d3 e2                	shl    %cl,%edx
  8020ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020af:	89 c1                	mov    %eax,%ecx
  8020b1:	89 da                	mov    %ebx,%edx
  8020b3:	d3 ea                	shr    %cl,%edx
  8020b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020b9:	09 d1                	or     %edx,%ecx
  8020bb:	89 f2                	mov    %esi,%edx
  8020bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020c1:	89 f9                	mov    %edi,%ecx
  8020c3:	d3 e3                	shl    %cl,%ebx
  8020c5:	89 c1                	mov    %eax,%ecx
  8020c7:	d3 ea                	shr    %cl,%edx
  8020c9:	89 f9                	mov    %edi,%ecx
  8020cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020cf:	89 eb                	mov    %ebp,%ebx
  8020d1:	d3 e6                	shl    %cl,%esi
  8020d3:	89 c1                	mov    %eax,%ecx
  8020d5:	d3 eb                	shr    %cl,%ebx
  8020d7:	09 de                	or     %ebx,%esi
  8020d9:	89 f0                	mov    %esi,%eax
  8020db:	f7 74 24 08          	divl   0x8(%esp)
  8020df:	89 d6                	mov    %edx,%esi
  8020e1:	89 c3                	mov    %eax,%ebx
  8020e3:	f7 64 24 0c          	mull   0xc(%esp)
  8020e7:	39 d6                	cmp    %edx,%esi
  8020e9:	72 15                	jb     802100 <__udivdi3+0x100>
  8020eb:	89 f9                	mov    %edi,%ecx
  8020ed:	d3 e5                	shl    %cl,%ebp
  8020ef:	39 c5                	cmp    %eax,%ebp
  8020f1:	73 04                	jae    8020f7 <__udivdi3+0xf7>
  8020f3:	39 d6                	cmp    %edx,%esi
  8020f5:	74 09                	je     802100 <__udivdi3+0x100>
  8020f7:	89 d8                	mov    %ebx,%eax
  8020f9:	31 ff                	xor    %edi,%edi
  8020fb:	e9 27 ff ff ff       	jmp    802027 <__udivdi3+0x27>
  802100:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802103:	31 ff                	xor    %edi,%edi
  802105:	e9 1d ff ff ff       	jmp    802027 <__udivdi3+0x27>
  80210a:	66 90                	xchg   %ax,%ax
  80210c:	66 90                	xchg   %ax,%ax
  80210e:	66 90                	xchg   %ax,%ax

00802110 <__umoddi3>:
  802110:	55                   	push   %ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 1c             	sub    $0x1c,%esp
  802117:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80211b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80211f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802127:	89 da                	mov    %ebx,%edx
  802129:	85 c0                	test   %eax,%eax
  80212b:	75 43                	jne    802170 <__umoddi3+0x60>
  80212d:	39 df                	cmp    %ebx,%edi
  80212f:	76 17                	jbe    802148 <__umoddi3+0x38>
  802131:	89 f0                	mov    %esi,%eax
  802133:	f7 f7                	div    %edi
  802135:	89 d0                	mov    %edx,%eax
  802137:	31 d2                	xor    %edx,%edx
  802139:	83 c4 1c             	add    $0x1c,%esp
  80213c:	5b                   	pop    %ebx
  80213d:	5e                   	pop    %esi
  80213e:	5f                   	pop    %edi
  80213f:	5d                   	pop    %ebp
  802140:	c3                   	ret    
  802141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802148:	89 fd                	mov    %edi,%ebp
  80214a:	85 ff                	test   %edi,%edi
  80214c:	75 0b                	jne    802159 <__umoddi3+0x49>
  80214e:	b8 01 00 00 00       	mov    $0x1,%eax
  802153:	31 d2                	xor    %edx,%edx
  802155:	f7 f7                	div    %edi
  802157:	89 c5                	mov    %eax,%ebp
  802159:	89 d8                	mov    %ebx,%eax
  80215b:	31 d2                	xor    %edx,%edx
  80215d:	f7 f5                	div    %ebp
  80215f:	89 f0                	mov    %esi,%eax
  802161:	f7 f5                	div    %ebp
  802163:	89 d0                	mov    %edx,%eax
  802165:	eb d0                	jmp    802137 <__umoddi3+0x27>
  802167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80216e:	66 90                	xchg   %ax,%ax
  802170:	89 f1                	mov    %esi,%ecx
  802172:	39 d8                	cmp    %ebx,%eax
  802174:	76 0a                	jbe    802180 <__umoddi3+0x70>
  802176:	89 f0                	mov    %esi,%eax
  802178:	83 c4 1c             	add    $0x1c,%esp
  80217b:	5b                   	pop    %ebx
  80217c:	5e                   	pop    %esi
  80217d:	5f                   	pop    %edi
  80217e:	5d                   	pop    %ebp
  80217f:	c3                   	ret    
  802180:	0f bd e8             	bsr    %eax,%ebp
  802183:	83 f5 1f             	xor    $0x1f,%ebp
  802186:	75 20                	jne    8021a8 <__umoddi3+0x98>
  802188:	39 d8                	cmp    %ebx,%eax
  80218a:	0f 82 b0 00 00 00    	jb     802240 <__umoddi3+0x130>
  802190:	39 f7                	cmp    %esi,%edi
  802192:	0f 86 a8 00 00 00    	jbe    802240 <__umoddi3+0x130>
  802198:	89 c8                	mov    %ecx,%eax
  80219a:	83 c4 1c             	add    $0x1c,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5f                   	pop    %edi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    
  8021a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021a8:	89 e9                	mov    %ebp,%ecx
  8021aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8021af:	29 ea                	sub    %ebp,%edx
  8021b1:	d3 e0                	shl    %cl,%eax
  8021b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b7:	89 d1                	mov    %edx,%ecx
  8021b9:	89 f8                	mov    %edi,%eax
  8021bb:	d3 e8                	shr    %cl,%eax
  8021bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021c9:	09 c1                	or     %eax,%ecx
  8021cb:	89 d8                	mov    %ebx,%eax
  8021cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021d1:	89 e9                	mov    %ebp,%ecx
  8021d3:	d3 e7                	shl    %cl,%edi
  8021d5:	89 d1                	mov    %edx,%ecx
  8021d7:	d3 e8                	shr    %cl,%eax
  8021d9:	89 e9                	mov    %ebp,%ecx
  8021db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021df:	d3 e3                	shl    %cl,%ebx
  8021e1:	89 c7                	mov    %eax,%edi
  8021e3:	89 d1                	mov    %edx,%ecx
  8021e5:	89 f0                	mov    %esi,%eax
  8021e7:	d3 e8                	shr    %cl,%eax
  8021e9:	89 e9                	mov    %ebp,%ecx
  8021eb:	89 fa                	mov    %edi,%edx
  8021ed:	d3 e6                	shl    %cl,%esi
  8021ef:	09 d8                	or     %ebx,%eax
  8021f1:	f7 74 24 08          	divl   0x8(%esp)
  8021f5:	89 d1                	mov    %edx,%ecx
  8021f7:	89 f3                	mov    %esi,%ebx
  8021f9:	f7 64 24 0c          	mull   0xc(%esp)
  8021fd:	89 c6                	mov    %eax,%esi
  8021ff:	89 d7                	mov    %edx,%edi
  802201:	39 d1                	cmp    %edx,%ecx
  802203:	72 06                	jb     80220b <__umoddi3+0xfb>
  802205:	75 10                	jne    802217 <__umoddi3+0x107>
  802207:	39 c3                	cmp    %eax,%ebx
  802209:	73 0c                	jae    802217 <__umoddi3+0x107>
  80220b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80220f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802213:	89 d7                	mov    %edx,%edi
  802215:	89 c6                	mov    %eax,%esi
  802217:	89 ca                	mov    %ecx,%edx
  802219:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80221e:	29 f3                	sub    %esi,%ebx
  802220:	19 fa                	sbb    %edi,%edx
  802222:	89 d0                	mov    %edx,%eax
  802224:	d3 e0                	shl    %cl,%eax
  802226:	89 e9                	mov    %ebp,%ecx
  802228:	d3 eb                	shr    %cl,%ebx
  80222a:	d3 ea                	shr    %cl,%edx
  80222c:	09 d8                	or     %ebx,%eax
  80222e:	83 c4 1c             	add    $0x1c,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
  802236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80223d:	8d 76 00             	lea    0x0(%esi),%esi
  802240:	89 da                	mov    %ebx,%edx
  802242:	29 fe                	sub    %edi,%esi
  802244:	19 c2                	sbb    %eax,%edx
  802246:	89 f1                	mov    %esi,%ecx
  802248:	89 c8                	mov    %ecx,%eax
  80224a:	e9 4b ff ff ff       	jmp    80219a <__umoddi3+0x8a>
