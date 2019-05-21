
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 e6 0f 00 00       	call   801027 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 fc 11 00 00       	call   801254 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 10 0c 00 00       	call   800c72 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 96 16 80 00       	push   $0x801696
  80006a:	e8 41 01 00 00       	call   8001b0 <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 34 12 00 00       	call   8012bb <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 d4 0b 00 00       	call   800c72 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 80 16 80 00       	push   $0x801680
  8000a8:	e8 03 01 00 00       	call   8001b0 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 00 12 00 00       	call   8012bb <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cb:	e8 a2 0b 00 00       	call   800c72 <sys_getenvid>
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000d8:	c1 e0 04             	shl    $0x4,%eax
  8000db:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e0:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e5:	85 db                	test   %ebx,%ebx
  8000e7:	7e 07                	jle    8000f0 <libmain+0x30>
		binaryname = argv[0];
  8000e9:	8b 06                	mov    (%esi),%eax
  8000eb:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	56                   	push   %esi
  8000f4:	53                   	push   %ebx
  8000f5:	e8 39 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000fa:	e8 0a 00 00 00       	call   800109 <exit>
}
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800105:	5b                   	pop    %ebx
  800106:	5e                   	pop    %esi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    

00800109 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  80010f:	6a 00                	push   $0x0
  800111:	e8 1b 0b 00 00       	call   800c31 <sys_env_destroy>
}
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	c9                   	leave  
  80011a:	c3                   	ret    

0080011b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011b:	55                   	push   %ebp
  80011c:	89 e5                	mov    %esp,%ebp
  80011e:	53                   	push   %ebx
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800125:	8b 13                	mov    (%ebx),%edx
  800127:	8d 42 01             	lea    0x1(%edx),%eax
  80012a:	89 03                	mov    %eax,(%ebx)
  80012c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800133:	3d ff 00 00 00       	cmp    $0xff,%eax
  800138:	74 09                	je     800143 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800141:	c9                   	leave  
  800142:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800143:	83 ec 08             	sub    $0x8,%esp
  800146:	68 ff 00 00 00       	push   $0xff
  80014b:	8d 43 08             	lea    0x8(%ebx),%eax
  80014e:	50                   	push   %eax
  80014f:	e8 a0 0a 00 00       	call   800bf4 <sys_cputs>
		b->idx = 0;
  800154:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	eb db                	jmp    80013a <putch+0x1f>

0080015f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800168:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016f:	00 00 00 
	b.cnt = 0;
  800172:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800179:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017c:	ff 75 0c             	pushl  0xc(%ebp)
  80017f:	ff 75 08             	pushl  0x8(%ebp)
  800182:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	68 1b 01 80 00       	push   $0x80011b
  80018e:	e8 4a 01 00 00       	call   8002dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800193:	83 c4 08             	add    $0x8,%esp
  800196:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a2:	50                   	push   %eax
  8001a3:	e8 4c 0a 00 00       	call   800bf4 <sys_cputs>

	return b.cnt;
}
  8001a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b9:	50                   	push   %eax
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 9d ff ff ff       	call   80015f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    

008001c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	57                   	push   %edi
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 1c             	sub    $0x1c,%esp
  8001cd:	89 c6                	mov    %eax,%esi
  8001cf:	89 d7                	mov    %edx,%edi
  8001d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001e3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e7:	74 2c                	je     800215 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001f9:	39 c2                	cmp    %eax,%edx
  8001fb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001fe:	73 43                	jae    800243 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800200:	83 eb 01             	sub    $0x1,%ebx
  800203:	85 db                	test   %ebx,%ebx
  800205:	7e 6c                	jle    800273 <printnum+0xaf>
			putch(padc, putdat);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	57                   	push   %edi
  80020b:	ff 75 18             	pushl  0x18(%ebp)
  80020e:	ff d6                	call   *%esi
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	eb eb                	jmp    800200 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	6a 20                	push   $0x20
  80021a:	6a 00                	push   $0x0
  80021c:	50                   	push   %eax
  80021d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800220:	ff 75 e0             	pushl  -0x20(%ebp)
  800223:	89 fa                	mov    %edi,%edx
  800225:	89 f0                	mov    %esi,%eax
  800227:	e8 98 ff ff ff       	call   8001c4 <printnum>
		while (--width > 0)
  80022c:	83 c4 20             	add    $0x20,%esp
  80022f:	83 eb 01             	sub    $0x1,%ebx
  800232:	85 db                	test   %ebx,%ebx
  800234:	7e 65                	jle    80029b <printnum+0xd7>
			putch(padc, putdat);
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	57                   	push   %edi
  80023a:	6a 20                	push   $0x20
  80023c:	ff d6                	call   *%esi
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	eb ec                	jmp    80022f <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	ff 75 18             	pushl  0x18(%ebp)
  800249:	83 eb 01             	sub    $0x1,%ebx
  80024c:	53                   	push   %ebx
  80024d:	50                   	push   %eax
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	ff 75 dc             	pushl  -0x24(%ebp)
  800254:	ff 75 d8             	pushl  -0x28(%ebp)
  800257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025a:	ff 75 e0             	pushl  -0x20(%ebp)
  80025d:	e8 be 11 00 00       	call   801420 <__udivdi3>
  800262:	83 c4 18             	add    $0x18,%esp
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	89 fa                	mov    %edi,%edx
  800269:	89 f0                	mov    %esi,%eax
  80026b:	e8 54 ff ff ff       	call   8001c4 <printnum>
  800270:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	57                   	push   %edi
  800277:	83 ec 04             	sub    $0x4,%esp
  80027a:	ff 75 dc             	pushl  -0x24(%ebp)
  80027d:	ff 75 d8             	pushl  -0x28(%ebp)
  800280:	ff 75 e4             	pushl  -0x1c(%ebp)
  800283:	ff 75 e0             	pushl  -0x20(%ebp)
  800286:	e8 a5 12 00 00       	call   801530 <__umoddi3>
  80028b:	83 c4 14             	add    $0x14,%esp
  80028e:	0f be 80 b3 16 80 00 	movsbl 0x8016b3(%eax),%eax
  800295:	50                   	push   %eax
  800296:	ff d6                	call   *%esi
  800298:	83 c4 10             	add    $0x10,%esp
}
  80029b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029e:	5b                   	pop    %ebx
  80029f:	5e                   	pop    %esi
  8002a0:	5f                   	pop    %edi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ad:	8b 10                	mov    (%eax),%edx
  8002af:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b2:	73 0a                	jae    8002be <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b7:	89 08                	mov    %ecx,(%eax)
  8002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bc:	88 02                	mov    %al,(%edx)
}
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <printfmt>:
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 10             	pushl  0x10(%ebp)
  8002cd:	ff 75 0c             	pushl  0xc(%ebp)
  8002d0:	ff 75 08             	pushl  0x8(%ebp)
  8002d3:	e8 05 00 00 00       	call   8002dd <vprintfmt>
}
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vprintfmt>:
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 3c             	sub    $0x3c,%esp
  8002e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ec:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ef:	e9 b4 03 00 00       	jmp    8006a8 <vprintfmt+0x3cb>
		padc = ' ';
  8002f4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8002f8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8002ff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800306:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80030d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800314:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800319:	8d 47 01             	lea    0x1(%edi),%eax
  80031c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031f:	0f b6 17             	movzbl (%edi),%edx
  800322:	8d 42 dd             	lea    -0x23(%edx),%eax
  800325:	3c 55                	cmp    $0x55,%al
  800327:	0f 87 c8 04 00 00    	ja     8007f5 <vprintfmt+0x518>
  80032d:	0f b6 c0             	movzbl %al,%eax
  800330:	ff 24 85 a0 18 80 00 	jmp    *0x8018a0(,%eax,4)
  800337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80033a:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800341:	eb d6                	jmp    800319 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800346:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80034a:	eb cd                	jmp    800319 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80034c:	0f b6 d2             	movzbl %dl,%edx
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80035a:	eb 0c                	jmp    800368 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80035c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80035f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800363:	eb b4                	jmp    800319 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800365:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800368:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800372:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800375:	83 f9 09             	cmp    $0x9,%ecx
  800378:	76 eb                	jbe    800365 <vprintfmt+0x88>
  80037a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80037d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800380:	eb 14                	jmp    800396 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800382:	8b 45 14             	mov    0x14(%ebp),%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038a:	8b 45 14             	mov    0x14(%ebp),%eax
  80038d:	8d 40 04             	lea    0x4(%eax),%eax
  800390:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800396:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039a:	0f 89 79 ff ff ff    	jns    800319 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8003a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ad:	e9 67 ff ff ff       	jmp    800319 <vprintfmt+0x3c>
  8003b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bc:	0f 49 d0             	cmovns %eax,%edx
  8003bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c5:	e9 4f ff ff ff       	jmp    800319 <vprintfmt+0x3c>
  8003ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003cd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003d4:	e9 40 ff ff ff       	jmp    800319 <vprintfmt+0x3c>
			lflag++;
  8003d9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003df:	e9 35 ff ff ff       	jmp    800319 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8003e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e7:	8d 78 04             	lea    0x4(%eax),%edi
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	53                   	push   %ebx
  8003ee:	ff 30                	pushl  (%eax)
  8003f0:	ff d6                	call   *%esi
			break;
  8003f2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f8:	e9 a8 02 00 00       	jmp    8006a5 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	8d 78 04             	lea    0x4(%eax),%edi
  800403:	8b 00                	mov    (%eax),%eax
  800405:	99                   	cltd   
  800406:	31 d0                	xor    %edx,%eax
  800408:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040a:	83 f8 0f             	cmp    $0xf,%eax
  80040d:	7f 23                	jg     800432 <vprintfmt+0x155>
  80040f:	8b 14 85 00 1a 80 00 	mov    0x801a00(,%eax,4),%edx
  800416:	85 d2                	test   %edx,%edx
  800418:	74 18                	je     800432 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80041a:	52                   	push   %edx
  80041b:	68 d4 16 80 00       	push   $0x8016d4
  800420:	53                   	push   %ebx
  800421:	56                   	push   %esi
  800422:	e8 99 fe ff ff       	call   8002c0 <printfmt>
  800427:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80042d:	e9 73 02 00 00       	jmp    8006a5 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800432:	50                   	push   %eax
  800433:	68 cb 16 80 00       	push   $0x8016cb
  800438:	53                   	push   %ebx
  800439:	56                   	push   %esi
  80043a:	e8 81 fe ff ff       	call   8002c0 <printfmt>
  80043f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800442:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800445:	e9 5b 02 00 00       	jmp    8006a5 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80044a:	8b 45 14             	mov    0x14(%ebp),%eax
  80044d:	83 c0 04             	add    $0x4,%eax
  800450:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800458:	85 d2                	test   %edx,%edx
  80045a:	b8 c4 16 80 00       	mov    $0x8016c4,%eax
  80045f:	0f 45 c2             	cmovne %edx,%eax
  800462:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800465:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800469:	7e 06                	jle    800471 <vprintfmt+0x194>
  80046b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80046f:	75 0d                	jne    80047e <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800471:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800474:	89 c7                	mov    %eax,%edi
  800476:	03 45 e0             	add    -0x20(%ebp),%eax
  800479:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047c:	eb 53                	jmp    8004d1 <vprintfmt+0x1f4>
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	ff 75 d8             	pushl  -0x28(%ebp)
  800484:	50                   	push   %eax
  800485:	e8 13 04 00 00       	call   80089d <strnlen>
  80048a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048d:	29 c1                	sub    %eax,%ecx
  80048f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800492:	83 c4 10             	add    $0x10,%esp
  800495:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800497:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80049b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80049e:	eb 0f                	jmp    8004af <vprintfmt+0x1d2>
					putch(padc, putdat);
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a9:	83 ef 01             	sub    $0x1,%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	85 ff                	test   %edi,%edi
  8004b1:	7f ed                	jg     8004a0 <vprintfmt+0x1c3>
  8004b3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b6:	85 d2                	test   %edx,%edx
  8004b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bd:	0f 49 c2             	cmovns %edx,%eax
  8004c0:	29 c2                	sub    %eax,%edx
  8004c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004c5:	eb aa                	jmp    800471 <vprintfmt+0x194>
					putch(ch, putdat);
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	53                   	push   %ebx
  8004cb:	52                   	push   %edx
  8004cc:	ff d6                	call   *%esi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d6:	83 c7 01             	add    $0x1,%edi
  8004d9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004dd:	0f be d0             	movsbl %al,%edx
  8004e0:	85 d2                	test   %edx,%edx
  8004e2:	74 4b                	je     80052f <vprintfmt+0x252>
  8004e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e8:	78 06                	js     8004f0 <vprintfmt+0x213>
  8004ea:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ee:	78 1e                	js     80050e <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f4:	74 d1                	je     8004c7 <vprintfmt+0x1ea>
  8004f6:	0f be c0             	movsbl %al,%eax
  8004f9:	83 e8 20             	sub    $0x20,%eax
  8004fc:	83 f8 5e             	cmp    $0x5e,%eax
  8004ff:	76 c6                	jbe    8004c7 <vprintfmt+0x1ea>
					putch('?', putdat);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	53                   	push   %ebx
  800505:	6a 3f                	push   $0x3f
  800507:	ff d6                	call   *%esi
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	eb c3                	jmp    8004d1 <vprintfmt+0x1f4>
  80050e:	89 cf                	mov    %ecx,%edi
  800510:	eb 0e                	jmp    800520 <vprintfmt+0x243>
				putch(' ', putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	53                   	push   %ebx
  800516:	6a 20                	push   $0x20
  800518:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80051a:	83 ef 01             	sub    $0x1,%edi
  80051d:	83 c4 10             	add    $0x10,%esp
  800520:	85 ff                	test   %edi,%edi
  800522:	7f ee                	jg     800512 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800524:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800527:	89 45 14             	mov    %eax,0x14(%ebp)
  80052a:	e9 76 01 00 00       	jmp    8006a5 <vprintfmt+0x3c8>
  80052f:	89 cf                	mov    %ecx,%edi
  800531:	eb ed                	jmp    800520 <vprintfmt+0x243>
	if (lflag >= 2)
  800533:	83 f9 01             	cmp    $0x1,%ecx
  800536:	7f 1f                	jg     800557 <vprintfmt+0x27a>
	else if (lflag)
  800538:	85 c9                	test   %ecx,%ecx
  80053a:	74 6a                	je     8005a6 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	89 c1                	mov    %eax,%ecx
  800546:	c1 f9 1f             	sar    $0x1f,%ecx
  800549:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8d 40 04             	lea    0x4(%eax),%eax
  800552:	89 45 14             	mov    %eax,0x14(%ebp)
  800555:	eb 17                	jmp    80056e <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8b 50 04             	mov    0x4(%eax),%edx
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800562:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8d 40 08             	lea    0x8(%eax),%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80056e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800571:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800576:	85 d2                	test   %edx,%edx
  800578:	0f 89 f8 00 00 00    	jns    800676 <vprintfmt+0x399>
				putch('-', putdat);
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	53                   	push   %ebx
  800582:	6a 2d                	push   $0x2d
  800584:	ff d6                	call   *%esi
				num = -(long long) num;
  800586:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800589:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058c:	f7 d8                	neg    %eax
  80058e:	83 d2 00             	adc    $0x0,%edx
  800591:	f7 da                	neg    %edx
  800593:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800596:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800599:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059c:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a1:	e9 e1 00 00 00       	jmp    800687 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	99                   	cltd   
  8005af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bb:	eb b1                	jmp    80056e <vprintfmt+0x291>
	if (lflag >= 2)
  8005bd:	83 f9 01             	cmp    $0x1,%ecx
  8005c0:	7f 27                	jg     8005e9 <vprintfmt+0x30c>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	74 41                	je     800607 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005df:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005e4:	e9 8d 00 00 00       	jmp    800676 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 50 04             	mov    0x4(%eax),%edx
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 08             	lea    0x8(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800600:	bf 0a 00 00 00       	mov    $0xa,%edi
  800605:	eb 6f                	jmp    800676 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	ba 00 00 00 00       	mov    $0x0,%edx
  800611:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800614:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	bf 0a 00 00 00       	mov    $0xa,%edi
  800625:	eb 4f                	jmp    800676 <vprintfmt+0x399>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7f 23                	jg     80064f <vprintfmt+0x372>
	else if (lflag)
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	0f 84 98 00 00 00    	je     8006cc <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	ba 00 00 00 00       	mov    $0x0,%edx
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
  80064d:	eb 17                	jmp    800666 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 50 04             	mov    0x4(%eax),%edx
  800655:	8b 00                	mov    (%eax),%eax
  800657:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8d 40 08             	lea    0x8(%eax),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 30                	push   $0x30
  80066c:	ff d6                	call   *%esi
			goto number;
  80066e:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800671:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800676:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80067a:	74 0b                	je     800687 <vprintfmt+0x3aa>
				putch('+', putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	53                   	push   %ebx
  800680:	6a 2b                	push   $0x2b
  800682:	ff d6                	call   *%esi
  800684:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80068e:	50                   	push   %eax
  80068f:	ff 75 e0             	pushl  -0x20(%ebp)
  800692:	57                   	push   %edi
  800693:	ff 75 dc             	pushl  -0x24(%ebp)
  800696:	ff 75 d8             	pushl  -0x28(%ebp)
  800699:	89 da                	mov    %ebx,%edx
  80069b:	89 f0                	mov    %esi,%eax
  80069d:	e8 22 fb ff ff       	call   8001c4 <printnum>
			break;
  8006a2:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8006a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a8:	83 c7 01             	add    $0x1,%edi
  8006ab:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006af:	83 f8 25             	cmp    $0x25,%eax
  8006b2:	0f 84 3c fc ff ff    	je     8002f4 <vprintfmt+0x17>
			if (ch == '\0')
  8006b8:	85 c0                	test   %eax,%eax
  8006ba:	0f 84 55 01 00 00    	je     800815 <vprintfmt+0x538>
			putch(ch, putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	53                   	push   %ebx
  8006c4:	50                   	push   %eax
  8006c5:	ff d6                	call   *%esi
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	eb dc                	jmp    8006a8 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8d 40 04             	lea    0x4(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e5:	e9 7c ff ff ff       	jmp    800666 <vprintfmt+0x389>
			putch('0', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	6a 30                	push   $0x30
  8006f0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f2:	83 c4 08             	add    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 78                	push   $0x78
  8006f8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800704:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800707:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80070a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8d 40 04             	lea    0x4(%eax),%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800716:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  80071b:	e9 56 ff ff ff       	jmp    800676 <vprintfmt+0x399>
	if (lflag >= 2)
  800720:	83 f9 01             	cmp    $0x1,%ecx
  800723:	7f 27                	jg     80074c <vprintfmt+0x46f>
	else if (lflag)
  800725:	85 c9                	test   %ecx,%ecx
  800727:	74 44                	je     80076d <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	ba 00 00 00 00       	mov    $0x0,%edx
  800733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800736:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800742:	bf 10 00 00 00       	mov    $0x10,%edi
  800747:	e9 2a ff ff ff       	jmp    800676 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 50 04             	mov    0x4(%eax),%edx
  800752:	8b 00                	mov    (%eax),%eax
  800754:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800757:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 40 08             	lea    0x8(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800763:	bf 10 00 00 00       	mov    $0x10,%edi
  800768:	e9 09 ff ff ff       	jmp    800676 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 04             	lea    0x4(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800786:	bf 10 00 00 00       	mov    $0x10,%edi
  80078b:	e9 e6 fe ff ff       	jmp    800676 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8d 78 04             	lea    0x4(%eax),%edi
  800796:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800798:	85 c0                	test   %eax,%eax
  80079a:	74 2d                	je     8007c9 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80079c:	0f b6 13             	movzbl (%ebx),%edx
  80079f:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007a1:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8007a4:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007a7:	0f 8e f8 fe ff ff    	jle    8006a5 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007ad:	68 24 18 80 00       	push   $0x801824
  8007b2:	68 d4 16 80 00       	push   $0x8016d4
  8007b7:	53                   	push   %ebx
  8007b8:	56                   	push   %esi
  8007b9:	e8 02 fb ff ff       	call   8002c0 <printfmt>
  8007be:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007c1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007c4:	e9 dc fe ff ff       	jmp    8006a5 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8007c9:	68 ec 17 80 00       	push   $0x8017ec
  8007ce:	68 d4 16 80 00       	push   $0x8016d4
  8007d3:	53                   	push   %ebx
  8007d4:	56                   	push   %esi
  8007d5:	e8 e6 fa ff ff       	call   8002c0 <printfmt>
  8007da:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007dd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007e0:	e9 c0 fe ff ff       	jmp    8006a5 <vprintfmt+0x3c8>
			putch(ch, putdat);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	53                   	push   %ebx
  8007e9:	6a 25                	push   $0x25
  8007eb:	ff d6                	call   *%esi
			break;
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	e9 b0 fe ff ff       	jmp    8006a5 <vprintfmt+0x3c8>
			putch('%', putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 25                	push   $0x25
  8007fb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 f8                	mov    %edi,%eax
  800802:	eb 03                	jmp    800807 <vprintfmt+0x52a>
  800804:	83 e8 01             	sub    $0x1,%eax
  800807:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80080b:	75 f7                	jne    800804 <vprintfmt+0x527>
  80080d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800810:	e9 90 fe ff ff       	jmp    8006a5 <vprintfmt+0x3c8>
}
  800815:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800818:	5b                   	pop    %ebx
  800819:	5e                   	pop    %esi
  80081a:	5f                   	pop    %edi
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	83 ec 18             	sub    $0x18,%esp
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800829:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80082c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800830:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800833:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083a:	85 c0                	test   %eax,%eax
  80083c:	74 26                	je     800864 <vsnprintf+0x47>
  80083e:	85 d2                	test   %edx,%edx
  800840:	7e 22                	jle    800864 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800842:	ff 75 14             	pushl  0x14(%ebp)
  800845:	ff 75 10             	pushl  0x10(%ebp)
  800848:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084b:	50                   	push   %eax
  80084c:	68 a3 02 80 00       	push   $0x8002a3
  800851:	e8 87 fa ff ff       	call   8002dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800859:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085f:	83 c4 10             	add    $0x10,%esp
}
  800862:	c9                   	leave  
  800863:	c3                   	ret    
		return -E_INVAL;
  800864:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800869:	eb f7                	jmp    800862 <vsnprintf+0x45>

0080086b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800871:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800874:	50                   	push   %eax
  800875:	ff 75 10             	pushl  0x10(%ebp)
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 9a ff ff ff       	call   80081d <vsnprintf>
	va_end(ap);

	return rc;
}
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
  800890:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800894:	74 05                	je     80089b <strlen+0x16>
		n++;
  800896:	83 c0 01             	add    $0x1,%eax
  800899:	eb f5                	jmp    800890 <strlen+0xb>
	return n;
}
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ab:	39 c2                	cmp    %eax,%edx
  8008ad:	74 0d                	je     8008bc <strnlen+0x1f>
  8008af:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008b3:	74 05                	je     8008ba <strnlen+0x1d>
		n++;
  8008b5:	83 c2 01             	add    $0x1,%edx
  8008b8:	eb f1                	jmp    8008ab <strnlen+0xe>
  8008ba:	89 d0                	mov    %edx,%eax
	return n;
}
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	53                   	push   %ebx
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cd:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008d1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008d4:	83 c2 01             	add    $0x1,%edx
  8008d7:	84 c9                	test   %cl,%cl
  8008d9:	75 f2                	jne    8008cd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008db:	5b                   	pop    %ebx
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	53                   	push   %ebx
  8008e2:	83 ec 10             	sub    $0x10,%esp
  8008e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e8:	53                   	push   %ebx
  8008e9:	e8 97 ff ff ff       	call   800885 <strlen>
  8008ee:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	01 d8                	add    %ebx,%eax
  8008f6:	50                   	push   %eax
  8008f7:	e8 c2 ff ff ff       	call   8008be <strcpy>
	return dst;
}
  8008fc:	89 d8                	mov    %ebx,%eax
  8008fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800901:	c9                   	leave  
  800902:	c3                   	ret    

00800903 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	56                   	push   %esi
  800907:	53                   	push   %ebx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090e:	89 c6                	mov    %eax,%esi
  800910:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800913:	89 c2                	mov    %eax,%edx
  800915:	39 f2                	cmp    %esi,%edx
  800917:	74 11                	je     80092a <strncpy+0x27>
		*dst++ = *src;
  800919:	83 c2 01             	add    $0x1,%edx
  80091c:	0f b6 19             	movzbl (%ecx),%ebx
  80091f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800922:	80 fb 01             	cmp    $0x1,%bl
  800925:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800928:	eb eb                	jmp    800915 <strncpy+0x12>
	}
	return ret;
}
  80092a:	5b                   	pop    %ebx
  80092b:	5e                   	pop    %esi
  80092c:	5d                   	pop    %ebp
  80092d:	c3                   	ret    

0080092e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	56                   	push   %esi
  800932:	53                   	push   %ebx
  800933:	8b 75 08             	mov    0x8(%ebp),%esi
  800936:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800939:	8b 55 10             	mov    0x10(%ebp),%edx
  80093c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80093e:	85 d2                	test   %edx,%edx
  800940:	74 21                	je     800963 <strlcpy+0x35>
  800942:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800946:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800948:	39 c2                	cmp    %eax,%edx
  80094a:	74 14                	je     800960 <strlcpy+0x32>
  80094c:	0f b6 19             	movzbl (%ecx),%ebx
  80094f:	84 db                	test   %bl,%bl
  800951:	74 0b                	je     80095e <strlcpy+0x30>
			*dst++ = *src++;
  800953:	83 c1 01             	add    $0x1,%ecx
  800956:	83 c2 01             	add    $0x1,%edx
  800959:	88 5a ff             	mov    %bl,-0x1(%edx)
  80095c:	eb ea                	jmp    800948 <strlcpy+0x1a>
  80095e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800960:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800963:	29 f0                	sub    %esi,%eax
}
  800965:	5b                   	pop    %ebx
  800966:	5e                   	pop    %esi
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800972:	0f b6 01             	movzbl (%ecx),%eax
  800975:	84 c0                	test   %al,%al
  800977:	74 0c                	je     800985 <strcmp+0x1c>
  800979:	3a 02                	cmp    (%edx),%al
  80097b:	75 08                	jne    800985 <strcmp+0x1c>
		p++, q++;
  80097d:	83 c1 01             	add    $0x1,%ecx
  800980:	83 c2 01             	add    $0x1,%edx
  800983:	eb ed                	jmp    800972 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800985:	0f b6 c0             	movzbl %al,%eax
  800988:	0f b6 12             	movzbl (%edx),%edx
  80098b:	29 d0                	sub    %edx,%eax
}
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	53                   	push   %ebx
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
  800999:	89 c3                	mov    %eax,%ebx
  80099b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80099e:	eb 06                	jmp    8009a6 <strncmp+0x17>
		n--, p++, q++;
  8009a0:	83 c0 01             	add    $0x1,%eax
  8009a3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009a6:	39 d8                	cmp    %ebx,%eax
  8009a8:	74 16                	je     8009c0 <strncmp+0x31>
  8009aa:	0f b6 08             	movzbl (%eax),%ecx
  8009ad:	84 c9                	test   %cl,%cl
  8009af:	74 04                	je     8009b5 <strncmp+0x26>
  8009b1:	3a 0a                	cmp    (%edx),%cl
  8009b3:	74 eb                	je     8009a0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b5:	0f b6 00             	movzbl (%eax),%eax
  8009b8:	0f b6 12             	movzbl (%edx),%edx
  8009bb:	29 d0                	sub    %edx,%eax
}
  8009bd:	5b                   	pop    %ebx
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    
		return 0;
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c5:	eb f6                	jmp    8009bd <strncmp+0x2e>

008009c7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d1:	0f b6 10             	movzbl (%eax),%edx
  8009d4:	84 d2                	test   %dl,%dl
  8009d6:	74 09                	je     8009e1 <strchr+0x1a>
		if (*s == c)
  8009d8:	38 ca                	cmp    %cl,%dl
  8009da:	74 0a                	je     8009e6 <strchr+0x1f>
	for (; *s; s++)
  8009dc:	83 c0 01             	add    $0x1,%eax
  8009df:	eb f0                	jmp    8009d1 <strchr+0xa>
			return (char *) s;
	return 0;
  8009e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009f5:	38 ca                	cmp    %cl,%dl
  8009f7:	74 09                	je     800a02 <strfind+0x1a>
  8009f9:	84 d2                	test   %dl,%dl
  8009fb:	74 05                	je     800a02 <strfind+0x1a>
	for (; *s; s++)
  8009fd:	83 c0 01             	add    $0x1,%eax
  800a00:	eb f0                	jmp    8009f2 <strfind+0xa>
			break;
	return (char *) s;
}
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	57                   	push   %edi
  800a08:	56                   	push   %esi
  800a09:	53                   	push   %ebx
  800a0a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a10:	85 c9                	test   %ecx,%ecx
  800a12:	74 31                	je     800a45 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a14:	89 f8                	mov    %edi,%eax
  800a16:	09 c8                	or     %ecx,%eax
  800a18:	a8 03                	test   $0x3,%al
  800a1a:	75 23                	jne    800a3f <memset+0x3b>
		c &= 0xFF;
  800a1c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a20:	89 d3                	mov    %edx,%ebx
  800a22:	c1 e3 08             	shl    $0x8,%ebx
  800a25:	89 d0                	mov    %edx,%eax
  800a27:	c1 e0 18             	shl    $0x18,%eax
  800a2a:	89 d6                	mov    %edx,%esi
  800a2c:	c1 e6 10             	shl    $0x10,%esi
  800a2f:	09 f0                	or     %esi,%eax
  800a31:	09 c2                	or     %eax,%edx
  800a33:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a35:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a38:	89 d0                	mov    %edx,%eax
  800a3a:	fc                   	cld    
  800a3b:	f3 ab                	rep stos %eax,%es:(%edi)
  800a3d:	eb 06                	jmp    800a45 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	fc                   	cld    
  800a43:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a45:	89 f8                	mov    %edi,%eax
  800a47:	5b                   	pop    %ebx
  800a48:	5e                   	pop    %esi
  800a49:	5f                   	pop    %edi
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	57                   	push   %edi
  800a50:	56                   	push   %esi
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a57:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a5a:	39 c6                	cmp    %eax,%esi
  800a5c:	73 32                	jae    800a90 <memmove+0x44>
  800a5e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a61:	39 c2                	cmp    %eax,%edx
  800a63:	76 2b                	jbe    800a90 <memmove+0x44>
		s += n;
		d += n;
  800a65:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a68:	89 fe                	mov    %edi,%esi
  800a6a:	09 ce                	or     %ecx,%esi
  800a6c:	09 d6                	or     %edx,%esi
  800a6e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a74:	75 0e                	jne    800a84 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a76:	83 ef 04             	sub    $0x4,%edi
  800a79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7f:	fd                   	std    
  800a80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a82:	eb 09                	jmp    800a8d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a84:	83 ef 01             	sub    $0x1,%edi
  800a87:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a8a:	fd                   	std    
  800a8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8d:	fc                   	cld    
  800a8e:	eb 1a                	jmp    800aaa <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a90:	89 c2                	mov    %eax,%edx
  800a92:	09 ca                	or     %ecx,%edx
  800a94:	09 f2                	or     %esi,%edx
  800a96:	f6 c2 03             	test   $0x3,%dl
  800a99:	75 0a                	jne    800aa5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9e:	89 c7                	mov    %eax,%edi
  800aa0:	fc                   	cld    
  800aa1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa3:	eb 05                	jmp    800aaa <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aa5:	89 c7                	mov    %eax,%edi
  800aa7:	fc                   	cld    
  800aa8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aaa:	5e                   	pop    %esi
  800aab:	5f                   	pop    %edi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab4:	ff 75 10             	pushl  0x10(%ebp)
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	ff 75 08             	pushl  0x8(%ebp)
  800abd:	e8 8a ff ff ff       	call   800a4c <memmove>
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	56                   	push   %esi
  800ac8:	53                   	push   %ebx
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acf:	89 c6                	mov    %eax,%esi
  800ad1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad4:	39 f0                	cmp    %esi,%eax
  800ad6:	74 1c                	je     800af4 <memcmp+0x30>
		if (*s1 != *s2)
  800ad8:	0f b6 08             	movzbl (%eax),%ecx
  800adb:	0f b6 1a             	movzbl (%edx),%ebx
  800ade:	38 d9                	cmp    %bl,%cl
  800ae0:	75 08                	jne    800aea <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae2:	83 c0 01             	add    $0x1,%eax
  800ae5:	83 c2 01             	add    $0x1,%edx
  800ae8:	eb ea                	jmp    800ad4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aea:	0f b6 c1             	movzbl %cl,%eax
  800aed:	0f b6 db             	movzbl %bl,%ebx
  800af0:	29 d8                	sub    %ebx,%eax
  800af2:	eb 05                	jmp    800af9 <memcmp+0x35>
	}

	return 0;
  800af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af9:	5b                   	pop    %ebx
  800afa:	5e                   	pop    %esi
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b0b:	39 d0                	cmp    %edx,%eax
  800b0d:	73 09                	jae    800b18 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b0f:	38 08                	cmp    %cl,(%eax)
  800b11:	74 05                	je     800b18 <memfind+0x1b>
	for (; s < ends; s++)
  800b13:	83 c0 01             	add    $0x1,%eax
  800b16:	eb f3                	jmp    800b0b <memfind+0xe>
			break;
	return (void *) s;
}
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	57                   	push   %edi
  800b1e:	56                   	push   %esi
  800b1f:	53                   	push   %ebx
  800b20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b26:	eb 03                	jmp    800b2b <strtol+0x11>
		s++;
  800b28:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b2b:	0f b6 01             	movzbl (%ecx),%eax
  800b2e:	3c 20                	cmp    $0x20,%al
  800b30:	74 f6                	je     800b28 <strtol+0xe>
  800b32:	3c 09                	cmp    $0x9,%al
  800b34:	74 f2                	je     800b28 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b36:	3c 2b                	cmp    $0x2b,%al
  800b38:	74 2a                	je     800b64 <strtol+0x4a>
	int neg = 0;
  800b3a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b3f:	3c 2d                	cmp    $0x2d,%al
  800b41:	74 2b                	je     800b6e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b43:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b49:	75 0f                	jne    800b5a <strtol+0x40>
  800b4b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b4e:	74 28                	je     800b78 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b50:	85 db                	test   %ebx,%ebx
  800b52:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b57:	0f 44 d8             	cmove  %eax,%ebx
  800b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b62:	eb 50                	jmp    800bb4 <strtol+0x9a>
		s++;
  800b64:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b67:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6c:	eb d5                	jmp    800b43 <strtol+0x29>
		s++, neg = 1;
  800b6e:	83 c1 01             	add    $0x1,%ecx
  800b71:	bf 01 00 00 00       	mov    $0x1,%edi
  800b76:	eb cb                	jmp    800b43 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b78:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b7c:	74 0e                	je     800b8c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b7e:	85 db                	test   %ebx,%ebx
  800b80:	75 d8                	jne    800b5a <strtol+0x40>
		s++, base = 8;
  800b82:	83 c1 01             	add    $0x1,%ecx
  800b85:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b8a:	eb ce                	jmp    800b5a <strtol+0x40>
		s += 2, base = 16;
  800b8c:	83 c1 02             	add    $0x2,%ecx
  800b8f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b94:	eb c4                	jmp    800b5a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b96:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b99:	89 f3                	mov    %esi,%ebx
  800b9b:	80 fb 19             	cmp    $0x19,%bl
  800b9e:	77 29                	ja     800bc9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ba0:	0f be d2             	movsbl %dl,%edx
  800ba3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ba9:	7d 30                	jge    800bdb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bab:	83 c1 01             	add    $0x1,%ecx
  800bae:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb4:	0f b6 11             	movzbl (%ecx),%edx
  800bb7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bba:	89 f3                	mov    %esi,%ebx
  800bbc:	80 fb 09             	cmp    $0x9,%bl
  800bbf:	77 d5                	ja     800b96 <strtol+0x7c>
			dig = *s - '0';
  800bc1:	0f be d2             	movsbl %dl,%edx
  800bc4:	83 ea 30             	sub    $0x30,%edx
  800bc7:	eb dd                	jmp    800ba6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bc9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bcc:	89 f3                	mov    %esi,%ebx
  800bce:	80 fb 19             	cmp    $0x19,%bl
  800bd1:	77 08                	ja     800bdb <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bd3:	0f be d2             	movsbl %dl,%edx
  800bd6:	83 ea 37             	sub    $0x37,%edx
  800bd9:	eb cb                	jmp    800ba6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdf:	74 05                	je     800be6 <strtol+0xcc>
		*endptr = (char *) s;
  800be1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800be6:	89 c2                	mov    %eax,%edx
  800be8:	f7 da                	neg    %edx
  800bea:	85 ff                	test   %edi,%edi
  800bec:	0f 45 c2             	cmovne %edx,%eax
}
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800bff:	8b 55 08             	mov    0x8(%ebp),%edx
  800c02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c05:	89 c3                	mov    %eax,%ebx
  800c07:	89 c7                	mov    %eax,%edi
  800c09:	89 c6                	mov    %eax,%esi
  800c0b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5f                   	pop    %edi
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c18:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c22:	89 d1                	mov    %edx,%ecx
  800c24:	89 d3                	mov    %edx,%ebx
  800c26:	89 d7                	mov    %edx,%edi
  800c28:	89 d6                	mov    %edx,%esi
  800c2a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c2c:	5b                   	pop    %ebx
  800c2d:	5e                   	pop    %esi
  800c2e:	5f                   	pop    %edi
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c42:	b8 03 00 00 00       	mov    $0x3,%eax
  800c47:	89 cb                	mov    %ecx,%ebx
  800c49:	89 cf                	mov    %ecx,%edi
  800c4b:	89 ce                	mov    %ecx,%esi
  800c4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	7f 08                	jg     800c5b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5b:	83 ec 0c             	sub    $0xc,%esp
  800c5e:	50                   	push   %eax
  800c5f:	6a 03                	push   $0x3
  800c61:	68 40 1a 80 00       	push   $0x801a40
  800c66:	6a 33                	push   $0x33
  800c68:	68 5d 1a 80 00       	push   $0x801a5d
  800c6d:	e8 d1 06 00 00       	call   801343 <_panic>

00800c72 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c78:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7d:	b8 02 00 00 00       	mov    $0x2,%eax
  800c82:	89 d1                	mov    %edx,%ecx
  800c84:	89 d3                	mov    %edx,%ebx
  800c86:	89 d7                	mov    %edx,%edi
  800c88:	89 d6                	mov    %edx,%esi
  800c8a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <sys_yield>:

void
sys_yield(void)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c97:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ca1:	89 d1                	mov    %edx,%ecx
  800ca3:	89 d3                	mov    %edx,%ebx
  800ca5:	89 d7                	mov    %edx,%edi
  800ca7:	89 d6                	mov    %edx,%esi
  800ca9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	be 00 00 00 00       	mov    $0x0,%esi
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccc:	89 f7                	mov    %esi,%edi
  800cce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	7f 08                	jg     800cdc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5f                   	pop    %edi
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdc:	83 ec 0c             	sub    $0xc,%esp
  800cdf:	50                   	push   %eax
  800ce0:	6a 04                	push   $0x4
  800ce2:	68 40 1a 80 00       	push   $0x801a40
  800ce7:	6a 33                	push   $0x33
  800ce9:	68 5d 1a 80 00       	push   $0x801a5d
  800cee:	e8 50 06 00 00       	call   801343 <_panic>

00800cf3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	b8 05 00 00 00       	mov    $0x5,%eax
  800d07:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0d:	8b 75 18             	mov    0x18(%ebp),%esi
  800d10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d12:	85 c0                	test   %eax,%eax
  800d14:	7f 08                	jg     800d1e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1e:	83 ec 0c             	sub    $0xc,%esp
  800d21:	50                   	push   %eax
  800d22:	6a 05                	push   $0x5
  800d24:	68 40 1a 80 00       	push   $0x801a40
  800d29:	6a 33                	push   $0x33
  800d2b:	68 5d 1a 80 00       	push   $0x801a5d
  800d30:	e8 0e 06 00 00       	call   801343 <_panic>

00800d35 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
  800d46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d49:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4e:	89 df                	mov    %ebx,%edi
  800d50:	89 de                	mov    %ebx,%esi
  800d52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7f 08                	jg     800d60 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	83 ec 0c             	sub    $0xc,%esp
  800d63:	50                   	push   %eax
  800d64:	6a 06                	push   $0x6
  800d66:	68 40 1a 80 00       	push   $0x801a40
  800d6b:	6a 33                	push   $0x33
  800d6d:	68 5d 1a 80 00       	push   $0x801a5d
  800d72:	e8 cc 05 00 00       	call   801343 <_panic>

00800d77 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d80:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d85:	8b 55 08             	mov    0x8(%ebp),%edx
  800d88:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d8d:	89 cb                	mov    %ecx,%ebx
  800d8f:	89 cf                	mov    %ecx,%edi
  800d91:	89 ce                	mov    %ecx,%esi
  800d93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d95:	85 c0                	test   %eax,%eax
  800d97:	7f 08                	jg     800da1 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9c:	5b                   	pop    %ebx
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da1:	83 ec 0c             	sub    $0xc,%esp
  800da4:	50                   	push   %eax
  800da5:	6a 0b                	push   $0xb
  800da7:	68 40 1a 80 00       	push   $0x801a40
  800dac:	6a 33                	push   $0x33
  800dae:	68 5d 1a 80 00       	push   $0x801a5d
  800db3:	e8 8b 05 00 00       	call   801343 <_panic>

00800db8 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcc:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd1:	89 df                	mov    %ebx,%edi
  800dd3:	89 de                	mov    %ebx,%esi
  800dd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7f 08                	jg     800de3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de3:	83 ec 0c             	sub    $0xc,%esp
  800de6:	50                   	push   %eax
  800de7:	6a 08                	push   $0x8
  800de9:	68 40 1a 80 00       	push   $0x801a40
  800dee:	6a 33                	push   $0x33
  800df0:	68 5d 1a 80 00       	push   $0x801a5d
  800df5:	e8 49 05 00 00       	call   801343 <_panic>

00800dfa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 09                	push   $0x9
  800e2b:	68 40 1a 80 00       	push   $0x801a40
  800e30:	6a 33                	push   $0x33
  800e32:	68 5d 1a 80 00       	push   $0x801a5d
  800e37:	e8 07 05 00 00       	call   801343 <_panic>

00800e3c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
  800e42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e50:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e55:	89 df                	mov    %ebx,%edi
  800e57:	89 de                	mov    %ebx,%esi
  800e59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7f 08                	jg     800e67 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	50                   	push   %eax
  800e6b:	6a 0a                	push   $0xa
  800e6d:	68 40 1a 80 00       	push   $0x801a40
  800e72:	6a 33                	push   $0x33
  800e74:	68 5d 1a 80 00       	push   $0x801a5d
  800e79:	e8 c5 04 00 00       	call   801343 <_panic>

00800e7e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e8f:	be 00 00 00 00       	mov    $0x0,%esi
  800e94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb7:	89 cb                	mov    %ecx,%ebx
  800eb9:	89 cf                	mov    %ecx,%edi
  800ebb:	89 ce                	mov    %ecx,%esi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 0e                	push   $0xe
  800ed1:	68 40 1a 80 00       	push   $0x801a40
  800ed6:	6a 33                	push   $0x33
  800ed8:	68 5d 1a 80 00       	push   $0x801a5d
  800edd:	e8 61 04 00 00       	call   801343 <_panic>

00800ee2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ef8:	89 df                	mov    %ebx,%edi
  800efa:	89 de                	mov    %ebx,%esi
  800efc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f09:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	b8 10 00 00 00       	mov    $0x10,%eax
  800f16:	89 cb                	mov    %ecx,%ebx
  800f18:	89 cf                	mov    %ecx,%edi
  800f1a:	89 ce                	mov    %ecx,%esi
  800f1c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	53                   	push   %ebx
  800f27:	83 ec 04             	sub    $0x4,%esp
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f2d:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  800f2f:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f33:	0f 84 90 00 00 00    	je     800fc9 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  800f39:	89 d8                	mov    %ebx,%eax
  800f3b:	c1 e8 16             	shr    $0x16,%eax
  800f3e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f45:	a8 01                	test   $0x1,%al
  800f47:	0f 84 90 00 00 00    	je     800fdd <pgfault+0xba>
  800f4d:	89 d8                	mov    %ebx,%eax
  800f4f:	c1 e8 0c             	shr    $0xc,%eax
  800f52:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f59:	a9 01 08 00 00       	test   $0x801,%eax
  800f5e:	74 7d                	je     800fdd <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  800f60:	83 ec 04             	sub    $0x4,%esp
  800f63:	6a 07                	push   $0x7
  800f65:	68 00 f0 7f 00       	push   $0x7ff000
  800f6a:	6a 00                	push   $0x0
  800f6c:	e8 3f fd ff ff       	call   800cb0 <sys_page_alloc>
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	85 c0                	test   %eax,%eax
  800f76:	78 79                	js     800ff1 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  800f78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  800f7e:	83 ec 04             	sub    $0x4,%esp
  800f81:	68 00 10 00 00       	push   $0x1000
  800f86:	53                   	push   %ebx
  800f87:	68 00 f0 7f 00       	push   $0x7ff000
  800f8c:	e8 bb fa ff ff       	call   800a4c <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  800f91:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f98:	53                   	push   %ebx
  800f99:	6a 00                	push   $0x0
  800f9b:	68 00 f0 7f 00       	push   $0x7ff000
  800fa0:	6a 00                	push   $0x0
  800fa2:	e8 4c fd ff ff       	call   800cf3 <sys_page_map>
  800fa7:	83 c4 20             	add    $0x20,%esp
  800faa:	85 c0                	test   %eax,%eax
  800fac:	78 55                	js     801003 <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  800fae:	83 ec 08             	sub    $0x8,%esp
  800fb1:	68 00 f0 7f 00       	push   $0x7ff000
  800fb6:	6a 00                	push   $0x0
  800fb8:	e8 78 fd ff ff       	call   800d35 <sys_page_unmap>
  800fbd:	83 c4 10             	add    $0x10,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	78 51                	js     801015 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  800fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	68 6c 1a 80 00       	push   $0x801a6c
  800fd1:	6a 21                	push   $0x21
  800fd3:	68 f4 1a 80 00       	push   $0x801af4
  800fd8:	e8 66 03 00 00       	call   801343 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  800fdd:	83 ec 04             	sub    $0x4,%esp
  800fe0:	68 98 1a 80 00       	push   $0x801a98
  800fe5:	6a 24                	push   $0x24
  800fe7:	68 f4 1a 80 00       	push   $0x801af4
  800fec:	e8 52 03 00 00       	call   801343 <_panic>
		panic("sys_page_alloc: %e\n", r);
  800ff1:	50                   	push   %eax
  800ff2:	68 ff 1a 80 00       	push   $0x801aff
  800ff7:	6a 2e                	push   $0x2e
  800ff9:	68 f4 1a 80 00       	push   $0x801af4
  800ffe:	e8 40 03 00 00       	call   801343 <_panic>
		panic("sys_page_map: %e\n", r);
  801003:	50                   	push   %eax
  801004:	68 13 1b 80 00       	push   $0x801b13
  801009:	6a 34                	push   $0x34
  80100b:	68 f4 1a 80 00       	push   $0x801af4
  801010:	e8 2e 03 00 00       	call   801343 <_panic>
		panic("sys_page_unmap: %e\n", r);
  801015:	50                   	push   %eax
  801016:	68 25 1b 80 00       	push   $0x801b25
  80101b:	6a 37                	push   $0x37
  80101d:	68 f4 1a 80 00       	push   $0x801af4
  801022:	e8 1c 03 00 00       	call   801343 <_panic>

00801027 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
  80102d:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801030:	68 23 0f 80 00       	push   $0x800f23
  801035:	e8 4f 03 00 00       	call   801389 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80103a:	b8 07 00 00 00       	mov    $0x7,%eax
  80103f:	cd 30                	int    $0x30
  801041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	78 30                	js     80107b <fork+0x54>
  80104b:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  80104d:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801052:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801056:	0f 85 a5 00 00 00    	jne    801101 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  80105c:	e8 11 fc ff ff       	call   800c72 <sys_getenvid>
  801061:	25 ff 03 00 00       	and    $0x3ff,%eax
  801066:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  801069:	c1 e0 04             	shl    $0x4,%eax
  80106c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801071:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801076:	e9 75 01 00 00       	jmp    8011f0 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  80107b:	50                   	push   %eax
  80107c:	68 39 1b 80 00       	push   $0x801b39
  801081:	68 83 00 00 00       	push   $0x83
  801086:	68 f4 1a 80 00       	push   $0x801af4
  80108b:	e8 b3 02 00 00       	call   801343 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801090:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	25 07 0e 00 00       	and    $0xe07,%eax
  80109f:	50                   	push   %eax
  8010a0:	56                   	push   %esi
  8010a1:	57                   	push   %edi
  8010a2:	56                   	push   %esi
  8010a3:	6a 00                	push   $0x0
  8010a5:	e8 49 fc ff ff       	call   800cf3 <sys_page_map>
  8010aa:	83 c4 20             	add    $0x20,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	79 3e                	jns    8010ef <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8010b1:	50                   	push   %eax
  8010b2:	68 13 1b 80 00       	push   $0x801b13
  8010b7:	6a 50                	push   $0x50
  8010b9:	68 f4 1a 80 00       	push   $0x801af4
  8010be:	e8 80 02 00 00       	call   801343 <_panic>
			panic("sys_page_map: %e\n", r);
  8010c3:	50                   	push   %eax
  8010c4:	68 13 1b 80 00       	push   $0x801b13
  8010c9:	6a 54                	push   $0x54
  8010cb:	68 f4 1a 80 00       	push   $0x801af4
  8010d0:	e8 6e 02 00 00       	call   801343 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8010d5:	83 ec 0c             	sub    $0xc,%esp
  8010d8:	6a 05                	push   $0x5
  8010da:	56                   	push   %esi
  8010db:	57                   	push   %edi
  8010dc:	56                   	push   %esi
  8010dd:	6a 00                	push   $0x0
  8010df:	e8 0f fc ff ff       	call   800cf3 <sys_page_map>
  8010e4:	83 c4 20             	add    $0x20,%esp
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	0f 88 ab 00 00 00    	js     80119a <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8010ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010f5:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8010fb:	0f 84 ab 00 00 00    	je     8011ac <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  801101:	89 d8                	mov    %ebx,%eax
  801103:	c1 e8 16             	shr    $0x16,%eax
  801106:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80110d:	a8 01                	test   $0x1,%al
  80110f:	74 de                	je     8010ef <fork+0xc8>
  801111:	89 d8                	mov    %ebx,%eax
  801113:	c1 e8 0c             	shr    $0xc,%eax
  801116:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80111d:	f6 c2 01             	test   $0x1,%dl
  801120:	74 cd                	je     8010ef <fork+0xc8>
  801122:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801128:	74 c5                	je     8010ef <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  80112a:	89 c6                	mov    %eax,%esi
  80112c:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  80112f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801136:	f6 c6 04             	test   $0x4,%dh
  801139:	0f 85 51 ff ff ff    	jne    801090 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  80113f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801146:	a9 02 08 00 00       	test   $0x802,%eax
  80114b:	74 88                	je     8010d5 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  80114d:	83 ec 0c             	sub    $0xc,%esp
  801150:	68 05 08 00 00       	push   $0x805
  801155:	56                   	push   %esi
  801156:	57                   	push   %edi
  801157:	56                   	push   %esi
  801158:	6a 00                	push   $0x0
  80115a:	e8 94 fb ff ff       	call   800cf3 <sys_page_map>
  80115f:	83 c4 20             	add    $0x20,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	0f 88 59 ff ff ff    	js     8010c3 <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  80116a:	83 ec 0c             	sub    $0xc,%esp
  80116d:	68 05 08 00 00       	push   $0x805
  801172:	56                   	push   %esi
  801173:	6a 00                	push   $0x0
  801175:	56                   	push   %esi
  801176:	6a 00                	push   $0x0
  801178:	e8 76 fb ff ff       	call   800cf3 <sys_page_map>
  80117d:	83 c4 20             	add    $0x20,%esp
  801180:	85 c0                	test   %eax,%eax
  801182:	0f 89 67 ff ff ff    	jns    8010ef <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801188:	50                   	push   %eax
  801189:	68 13 1b 80 00       	push   $0x801b13
  80118e:	6a 56                	push   $0x56
  801190:	68 f4 1a 80 00       	push   $0x801af4
  801195:	e8 a9 01 00 00       	call   801343 <_panic>
			panic("sys_page_map: %e\n", r);
  80119a:	50                   	push   %eax
  80119b:	68 13 1b 80 00       	push   $0x801b13
  8011a0:	6a 5a                	push   $0x5a
  8011a2:	68 f4 1a 80 00       	push   $0x801af4
  8011a7:	e8 97 01 00 00       	call   801343 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	6a 07                	push   $0x7
  8011b1:	68 00 f0 bf ee       	push   $0xeebff000
  8011b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b9:	e8 f2 fa ff ff       	call   800cb0 <sys_page_alloc>
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	78 36                	js     8011fb <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	68 f4 13 80 00       	push   $0x8013f4
  8011cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011d0:	e8 67 fc ff ff       	call   800e3c <sys_env_set_pgfault_upcall>
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	78 34                	js     801210 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011dc:	83 ec 08             	sub    $0x8,%esp
  8011df:	6a 02                	push   $0x2
  8011e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011e4:	e8 cf fb ff ff       	call   800db8 <sys_env_set_status>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	78 35                	js     801225 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  8011f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f6:	5b                   	pop    %ebx
  8011f7:	5e                   	pop    %esi
  8011f8:	5f                   	pop    %edi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  8011fb:	50                   	push   %eax
  8011fc:	68 ff 1a 80 00       	push   $0x801aff
  801201:	68 95 00 00 00       	push   $0x95
  801206:	68 f4 1a 80 00       	push   $0x801af4
  80120b:	e8 33 01 00 00       	call   801343 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801210:	50                   	push   %eax
  801211:	68 d4 1a 80 00       	push   $0x801ad4
  801216:	68 98 00 00 00       	push   $0x98
  80121b:	68 f4 1a 80 00       	push   $0x801af4
  801220:	e8 1e 01 00 00       	call   801343 <_panic>
		panic("sys_env_set_status: %e\n", r);
  801225:	50                   	push   %eax
  801226:	68 49 1b 80 00       	push   $0x801b49
  80122b:	68 9b 00 00 00       	push   $0x9b
  801230:	68 f4 1a 80 00       	push   $0x801af4
  801235:	e8 09 01 00 00       	call   801343 <_panic>

0080123a <sfork>:

// Challenge!
int
sfork(void)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801240:	68 61 1b 80 00       	push   $0x801b61
  801245:	68 a4 00 00 00       	push   $0xa4
  80124a:	68 f4 1a 80 00       	push   $0x801af4
  80124f:	e8 ef 00 00 00       	call   801343 <_panic>

00801254 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	56                   	push   %esi
  801258:	53                   	push   %ebx
  801259:	8b 75 08             	mov    0x8(%ebp),%esi
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  801262:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801264:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801269:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	50                   	push   %eax
  801270:	e8 2c fc ff ff       	call   800ea1 <sys_ipc_recv>
	if (from_env_store)
  801275:	83 c4 10             	add    $0x10,%esp
  801278:	85 f6                	test   %esi,%esi
  80127a:	74 14                	je     801290 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  80127c:	ba 00 00 00 00       	mov    $0x0,%edx
  801281:	85 c0                	test   %eax,%eax
  801283:	78 09                	js     80128e <ipc_recv+0x3a>
  801285:	8b 15 04 20 80 00    	mov    0x802004,%edx
  80128b:	8b 52 78             	mov    0x78(%edx),%edx
  80128e:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  801290:	85 db                	test   %ebx,%ebx
  801292:	74 14                	je     8012a8 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  801294:	ba 00 00 00 00       	mov    $0x0,%edx
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 09                	js     8012a6 <ipc_recv+0x52>
  80129d:	8b 15 04 20 80 00    	mov    0x802004,%edx
  8012a3:	8b 52 7c             	mov    0x7c(%edx),%edx
  8012a6:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	78 08                	js     8012b4 <ipc_recv+0x60>
  8012ac:	a1 04 20 80 00       	mov    0x802004,%eax
  8012b1:	8b 40 74             	mov    0x74(%eax),%eax
}
  8012b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 08             	sub    $0x8,%esp
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8012cb:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8012ce:	ff 75 14             	pushl  0x14(%ebp)
  8012d1:	50                   	push   %eax
  8012d2:	ff 75 0c             	pushl  0xc(%ebp)
  8012d5:	ff 75 08             	pushl  0x8(%ebp)
  8012d8:	e8 a1 fb ff ff       	call   800e7e <sys_ipc_try_send>
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	78 02                	js     8012e6 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  8012e6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012e9:	75 07                	jne    8012f2 <ipc_send+0x37>
		sys_yield();
  8012eb:	e8 a1 f9 ff ff       	call   800c91 <sys_yield>
}
  8012f0:	eb f2                	jmp    8012e4 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  8012f2:	50                   	push   %eax
  8012f3:	68 77 1b 80 00       	push   $0x801b77
  8012f8:	6a 3c                	push   $0x3c
  8012fa:	68 8b 1b 80 00       	push   $0x801b8b
  8012ff:	e8 3f 00 00 00       	call   801343 <_panic>

00801304 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80130a:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  80130f:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801312:	c1 e0 04             	shl    $0x4,%eax
  801315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131a:	8b 40 50             	mov    0x50(%eax),%eax
  80131d:	39 c8                	cmp    %ecx,%eax
  80131f:	74 12                	je     801333 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801321:	83 c2 01             	add    $0x1,%edx
  801324:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80132a:	75 e3                	jne    80130f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80132c:	b8 00 00 00 00       	mov    $0x0,%eax
  801331:	eb 0e                	jmp    801341 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801333:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801336:	c1 e0 04             	shl    $0x4,%eax
  801339:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80133e:	8b 40 48             	mov    0x48(%eax),%eax
}
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	56                   	push   %esi
  801347:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801348:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80134b:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801351:	e8 1c f9 ff ff       	call   800c72 <sys_getenvid>
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	ff 75 0c             	pushl  0xc(%ebp)
  80135c:	ff 75 08             	pushl  0x8(%ebp)
  80135f:	56                   	push   %esi
  801360:	50                   	push   %eax
  801361:	68 98 1b 80 00       	push   $0x801b98
  801366:	e8 45 ee ff ff       	call   8001b0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80136b:	83 c4 18             	add    $0x18,%esp
  80136e:	53                   	push   %ebx
  80136f:	ff 75 10             	pushl  0x10(%ebp)
  801372:	e8 e8 ed ff ff       	call   80015f <vcprintf>
	cprintf("\n");
  801377:	c7 04 24 11 1b 80 00 	movl   $0x801b11,(%esp)
  80137e:	e8 2d ee ff ff       	call   8001b0 <cprintf>
  801383:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801386:	cc                   	int3   
  801387:	eb fd                	jmp    801386 <_panic+0x43>

00801389 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80138f:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801396:	74 0a                	je     8013a2 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	6a 07                	push   $0x7
  8013a7:	68 00 f0 bf ee       	push   $0xeebff000
  8013ac:	6a 00                	push   $0x0
  8013ae:	e8 fd f8 ff ff       	call   800cb0 <sys_page_alloc>
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 28                	js     8013e2 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	68 f4 13 80 00       	push   $0x8013f4
  8013c2:	6a 00                	push   $0x0
  8013c4:	e8 73 fa ff ff       	call   800e3c <sys_env_set_pgfault_upcall>
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	79 c8                	jns    801398 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8013d0:	50                   	push   %eax
  8013d1:	68 d4 1a 80 00       	push   $0x801ad4
  8013d6:	6a 23                	push   $0x23
  8013d8:	68 d4 1b 80 00       	push   $0x801bd4
  8013dd:	e8 61 ff ff ff       	call   801343 <_panic>
			panic("set_pgfault_handler %e\n",r);
  8013e2:	50                   	push   %eax
  8013e3:	68 bc 1b 80 00       	push   $0x801bbc
  8013e8:	6a 21                	push   $0x21
  8013ea:	68 d4 1b 80 00       	push   $0x801bd4
  8013ef:	e8 4f ff ff ff       	call   801343 <_panic>

008013f4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8013f4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8013f5:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8013fa:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8013fc:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  8013ff:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  801403:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  801407:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80140a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80140c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801410:	83 c4 08             	add    $0x8,%esp
	popal
  801413:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801414:	83 c4 04             	add    $0x4,%esp
	popfl
  801417:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801418:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801419:	c3                   	ret    
  80141a:	66 90                	xchg   %ax,%ax
  80141c:	66 90                	xchg   %ax,%ax
  80141e:	66 90                	xchg   %ax,%ax

00801420 <__udivdi3>:
  801420:	55                   	push   %ebp
  801421:	57                   	push   %edi
  801422:	56                   	push   %esi
  801423:	53                   	push   %ebx
  801424:	83 ec 1c             	sub    $0x1c,%esp
  801427:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80142b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80142f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801433:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801437:	85 d2                	test   %edx,%edx
  801439:	75 4d                	jne    801488 <__udivdi3+0x68>
  80143b:	39 f3                	cmp    %esi,%ebx
  80143d:	76 19                	jbe    801458 <__udivdi3+0x38>
  80143f:	31 ff                	xor    %edi,%edi
  801441:	89 e8                	mov    %ebp,%eax
  801443:	89 f2                	mov    %esi,%edx
  801445:	f7 f3                	div    %ebx
  801447:	89 fa                	mov    %edi,%edx
  801449:	83 c4 1c             	add    $0x1c,%esp
  80144c:	5b                   	pop    %ebx
  80144d:	5e                   	pop    %esi
  80144e:	5f                   	pop    %edi
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    
  801451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801458:	89 d9                	mov    %ebx,%ecx
  80145a:	85 db                	test   %ebx,%ebx
  80145c:	75 0b                	jne    801469 <__udivdi3+0x49>
  80145e:	b8 01 00 00 00       	mov    $0x1,%eax
  801463:	31 d2                	xor    %edx,%edx
  801465:	f7 f3                	div    %ebx
  801467:	89 c1                	mov    %eax,%ecx
  801469:	31 d2                	xor    %edx,%edx
  80146b:	89 f0                	mov    %esi,%eax
  80146d:	f7 f1                	div    %ecx
  80146f:	89 c6                	mov    %eax,%esi
  801471:	89 e8                	mov    %ebp,%eax
  801473:	89 f7                	mov    %esi,%edi
  801475:	f7 f1                	div    %ecx
  801477:	89 fa                	mov    %edi,%edx
  801479:	83 c4 1c             	add    $0x1c,%esp
  80147c:	5b                   	pop    %ebx
  80147d:	5e                   	pop    %esi
  80147e:	5f                   	pop    %edi
  80147f:	5d                   	pop    %ebp
  801480:	c3                   	ret    
  801481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801488:	39 f2                	cmp    %esi,%edx
  80148a:	77 1c                	ja     8014a8 <__udivdi3+0x88>
  80148c:	0f bd fa             	bsr    %edx,%edi
  80148f:	83 f7 1f             	xor    $0x1f,%edi
  801492:	75 2c                	jne    8014c0 <__udivdi3+0xa0>
  801494:	39 f2                	cmp    %esi,%edx
  801496:	72 06                	jb     80149e <__udivdi3+0x7e>
  801498:	31 c0                	xor    %eax,%eax
  80149a:	39 eb                	cmp    %ebp,%ebx
  80149c:	77 a9                	ja     801447 <__udivdi3+0x27>
  80149e:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a3:	eb a2                	jmp    801447 <__udivdi3+0x27>
  8014a5:	8d 76 00             	lea    0x0(%esi),%esi
  8014a8:	31 ff                	xor    %edi,%edi
  8014aa:	31 c0                	xor    %eax,%eax
  8014ac:	89 fa                	mov    %edi,%edx
  8014ae:	83 c4 1c             	add    $0x1c,%esp
  8014b1:	5b                   	pop    %ebx
  8014b2:	5e                   	pop    %esi
  8014b3:	5f                   	pop    %edi
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    
  8014b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014bd:	8d 76 00             	lea    0x0(%esi),%esi
  8014c0:	89 f9                	mov    %edi,%ecx
  8014c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8014c7:	29 f8                	sub    %edi,%eax
  8014c9:	d3 e2                	shl    %cl,%edx
  8014cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014cf:	89 c1                	mov    %eax,%ecx
  8014d1:	89 da                	mov    %ebx,%edx
  8014d3:	d3 ea                	shr    %cl,%edx
  8014d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8014d9:	09 d1                	or     %edx,%ecx
  8014db:	89 f2                	mov    %esi,%edx
  8014dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014e1:	89 f9                	mov    %edi,%ecx
  8014e3:	d3 e3                	shl    %cl,%ebx
  8014e5:	89 c1                	mov    %eax,%ecx
  8014e7:	d3 ea                	shr    %cl,%edx
  8014e9:	89 f9                	mov    %edi,%ecx
  8014eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014ef:	89 eb                	mov    %ebp,%ebx
  8014f1:	d3 e6                	shl    %cl,%esi
  8014f3:	89 c1                	mov    %eax,%ecx
  8014f5:	d3 eb                	shr    %cl,%ebx
  8014f7:	09 de                	or     %ebx,%esi
  8014f9:	89 f0                	mov    %esi,%eax
  8014fb:	f7 74 24 08          	divl   0x8(%esp)
  8014ff:	89 d6                	mov    %edx,%esi
  801501:	89 c3                	mov    %eax,%ebx
  801503:	f7 64 24 0c          	mull   0xc(%esp)
  801507:	39 d6                	cmp    %edx,%esi
  801509:	72 15                	jb     801520 <__udivdi3+0x100>
  80150b:	89 f9                	mov    %edi,%ecx
  80150d:	d3 e5                	shl    %cl,%ebp
  80150f:	39 c5                	cmp    %eax,%ebp
  801511:	73 04                	jae    801517 <__udivdi3+0xf7>
  801513:	39 d6                	cmp    %edx,%esi
  801515:	74 09                	je     801520 <__udivdi3+0x100>
  801517:	89 d8                	mov    %ebx,%eax
  801519:	31 ff                	xor    %edi,%edi
  80151b:	e9 27 ff ff ff       	jmp    801447 <__udivdi3+0x27>
  801520:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801523:	31 ff                	xor    %edi,%edi
  801525:	e9 1d ff ff ff       	jmp    801447 <__udivdi3+0x27>
  80152a:	66 90                	xchg   %ax,%ax
  80152c:	66 90                	xchg   %ax,%ax
  80152e:	66 90                	xchg   %ax,%ax

00801530 <__umoddi3>:
  801530:	55                   	push   %ebp
  801531:	57                   	push   %edi
  801532:	56                   	push   %esi
  801533:	53                   	push   %ebx
  801534:	83 ec 1c             	sub    $0x1c,%esp
  801537:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80153b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80153f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801543:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801547:	89 da                	mov    %ebx,%edx
  801549:	85 c0                	test   %eax,%eax
  80154b:	75 43                	jne    801590 <__umoddi3+0x60>
  80154d:	39 df                	cmp    %ebx,%edi
  80154f:	76 17                	jbe    801568 <__umoddi3+0x38>
  801551:	89 f0                	mov    %esi,%eax
  801553:	f7 f7                	div    %edi
  801555:	89 d0                	mov    %edx,%eax
  801557:	31 d2                	xor    %edx,%edx
  801559:	83 c4 1c             	add    $0x1c,%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5f                   	pop    %edi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
  801561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801568:	89 fd                	mov    %edi,%ebp
  80156a:	85 ff                	test   %edi,%edi
  80156c:	75 0b                	jne    801579 <__umoddi3+0x49>
  80156e:	b8 01 00 00 00       	mov    $0x1,%eax
  801573:	31 d2                	xor    %edx,%edx
  801575:	f7 f7                	div    %edi
  801577:	89 c5                	mov    %eax,%ebp
  801579:	89 d8                	mov    %ebx,%eax
  80157b:	31 d2                	xor    %edx,%edx
  80157d:	f7 f5                	div    %ebp
  80157f:	89 f0                	mov    %esi,%eax
  801581:	f7 f5                	div    %ebp
  801583:	89 d0                	mov    %edx,%eax
  801585:	eb d0                	jmp    801557 <__umoddi3+0x27>
  801587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80158e:	66 90                	xchg   %ax,%ax
  801590:	89 f1                	mov    %esi,%ecx
  801592:	39 d8                	cmp    %ebx,%eax
  801594:	76 0a                	jbe    8015a0 <__umoddi3+0x70>
  801596:	89 f0                	mov    %esi,%eax
  801598:	83 c4 1c             	add    $0x1c,%esp
  80159b:	5b                   	pop    %ebx
  80159c:	5e                   	pop    %esi
  80159d:	5f                   	pop    %edi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    
  8015a0:	0f bd e8             	bsr    %eax,%ebp
  8015a3:	83 f5 1f             	xor    $0x1f,%ebp
  8015a6:	75 20                	jne    8015c8 <__umoddi3+0x98>
  8015a8:	39 d8                	cmp    %ebx,%eax
  8015aa:	0f 82 b0 00 00 00    	jb     801660 <__umoddi3+0x130>
  8015b0:	39 f7                	cmp    %esi,%edi
  8015b2:	0f 86 a8 00 00 00    	jbe    801660 <__umoddi3+0x130>
  8015b8:	89 c8                	mov    %ecx,%eax
  8015ba:	83 c4 1c             	add    $0x1c,%esp
  8015bd:	5b                   	pop    %ebx
  8015be:	5e                   	pop    %esi
  8015bf:	5f                   	pop    %edi
  8015c0:	5d                   	pop    %ebp
  8015c1:	c3                   	ret    
  8015c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8015c8:	89 e9                	mov    %ebp,%ecx
  8015ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8015cf:	29 ea                	sub    %ebp,%edx
  8015d1:	d3 e0                	shl    %cl,%eax
  8015d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015d7:	89 d1                	mov    %edx,%ecx
  8015d9:	89 f8                	mov    %edi,%eax
  8015db:	d3 e8                	shr    %cl,%eax
  8015dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8015e9:	09 c1                	or     %eax,%ecx
  8015eb:	89 d8                	mov    %ebx,%eax
  8015ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015f1:	89 e9                	mov    %ebp,%ecx
  8015f3:	d3 e7                	shl    %cl,%edi
  8015f5:	89 d1                	mov    %edx,%ecx
  8015f7:	d3 e8                	shr    %cl,%eax
  8015f9:	89 e9                	mov    %ebp,%ecx
  8015fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015ff:	d3 e3                	shl    %cl,%ebx
  801601:	89 c7                	mov    %eax,%edi
  801603:	89 d1                	mov    %edx,%ecx
  801605:	89 f0                	mov    %esi,%eax
  801607:	d3 e8                	shr    %cl,%eax
  801609:	89 e9                	mov    %ebp,%ecx
  80160b:	89 fa                	mov    %edi,%edx
  80160d:	d3 e6                	shl    %cl,%esi
  80160f:	09 d8                	or     %ebx,%eax
  801611:	f7 74 24 08          	divl   0x8(%esp)
  801615:	89 d1                	mov    %edx,%ecx
  801617:	89 f3                	mov    %esi,%ebx
  801619:	f7 64 24 0c          	mull   0xc(%esp)
  80161d:	89 c6                	mov    %eax,%esi
  80161f:	89 d7                	mov    %edx,%edi
  801621:	39 d1                	cmp    %edx,%ecx
  801623:	72 06                	jb     80162b <__umoddi3+0xfb>
  801625:	75 10                	jne    801637 <__umoddi3+0x107>
  801627:	39 c3                	cmp    %eax,%ebx
  801629:	73 0c                	jae    801637 <__umoddi3+0x107>
  80162b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80162f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801633:	89 d7                	mov    %edx,%edi
  801635:	89 c6                	mov    %eax,%esi
  801637:	89 ca                	mov    %ecx,%edx
  801639:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80163e:	29 f3                	sub    %esi,%ebx
  801640:	19 fa                	sbb    %edi,%edx
  801642:	89 d0                	mov    %edx,%eax
  801644:	d3 e0                	shl    %cl,%eax
  801646:	89 e9                	mov    %ebp,%ecx
  801648:	d3 eb                	shr    %cl,%ebx
  80164a:	d3 ea                	shr    %cl,%edx
  80164c:	09 d8                	or     %ebx,%eax
  80164e:	83 c4 1c             	add    $0x1c,%esp
  801651:	5b                   	pop    %ebx
  801652:	5e                   	pop    %esi
  801653:	5f                   	pop    %edi
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    
  801656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80165d:	8d 76 00             	lea    0x0(%esi),%esi
  801660:	89 da                	mov    %ebx,%edx
  801662:	29 fe                	sub    %edi,%esi
  801664:	19 c2                	sbb    %eax,%edx
  801666:	89 f1                	mov    %esi,%ecx
  801668:	89 c8                	mov    %ecx,%eax
  80166a:	e9 4b ff ff ff       	jmp    8015ba <__umoddi3+0x8a>
