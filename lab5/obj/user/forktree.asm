
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 53 0c 00 00       	call   800c95 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 a0 15 80 00       	push   $0x8015a0
  80004c:	e8 82 01 00 00       	call   8001d3 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 25 08 00 00       	call   8008a8 <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 b1 15 80 00       	push   $0x8015b1
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 e2 07 00 00       	call   80088e <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 96 0f 00 00       	call   80104a <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 63 00 00 00       	call   80012c <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 b0 15 80 00       	push   $0x8015b0
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 a2 0b 00 00       	call   800c95 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000fb:	c1 e0 04             	shl    $0x4,%eax
  8000fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800103:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	85 db                	test   %ebx,%ebx
  80010a:	7e 07                	jle    800113 <libmain+0x30>
		binaryname = argv[0];
  80010c:	8b 06                	mov    (%esi),%eax
  80010e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800113:	83 ec 08             	sub    $0x8,%esp
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
  800118:	e8 b1 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80011d:	e8 0a 00 00 00       	call   80012c <exit>
}
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5d                   	pop    %ebp
  80012b:	c3                   	ret    

0080012c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800132:	6a 00                	push   $0x0
  800134:	e8 1b 0b 00 00       	call   800c54 <sys_env_destroy>
}
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    

0080013e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	53                   	push   %ebx
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800148:	8b 13                	mov    (%ebx),%edx
  80014a:	8d 42 01             	lea    0x1(%edx),%eax
  80014d:	89 03                	mov    %eax,(%ebx)
  80014f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800152:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800156:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015b:	74 09                	je     800166 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80015d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800164:	c9                   	leave  
  800165:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	68 ff 00 00 00       	push   $0xff
  80016e:	8d 43 08             	lea    0x8(%ebx),%eax
  800171:	50                   	push   %eax
  800172:	e8 a0 0a 00 00       	call   800c17 <sys_cputs>
		b->idx = 0;
  800177:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80017d:	83 c4 10             	add    $0x10,%esp
  800180:	eb db                	jmp    80015d <putch+0x1f>

00800182 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80018b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800192:	00 00 00 
	b.cnt = 0;
  800195:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80019c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80019f:	ff 75 0c             	pushl  0xc(%ebp)
  8001a2:	ff 75 08             	pushl  0x8(%ebp)
  8001a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ab:	50                   	push   %eax
  8001ac:	68 3e 01 80 00       	push   $0x80013e
  8001b1:	e8 4a 01 00 00       	call   800300 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b6:	83 c4 08             	add    $0x8,%esp
  8001b9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001bf:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c5:	50                   	push   %eax
  8001c6:	e8 4c 0a 00 00       	call   800c17 <sys_cputs>

	return b.cnt;
}
  8001cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001dc:	50                   	push   %eax
  8001dd:	ff 75 08             	pushl  0x8(%ebp)
  8001e0:	e8 9d ff ff ff       	call   800182 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e5:	c9                   	leave  
  8001e6:	c3                   	ret    

008001e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	57                   	push   %edi
  8001eb:	56                   	push   %esi
  8001ec:	53                   	push   %ebx
  8001ed:	83 ec 1c             	sub    $0x1c,%esp
  8001f0:	89 c6                	mov    %eax,%esi
  8001f2:	89 d7                	mov    %edx,%edi
  8001f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800200:	8b 45 10             	mov    0x10(%ebp),%eax
  800203:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800206:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80020a:	74 2c                	je     800238 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80020c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80020f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800216:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800219:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800221:	73 43                	jae    800266 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800223:	83 eb 01             	sub    $0x1,%ebx
  800226:	85 db                	test   %ebx,%ebx
  800228:	7e 6c                	jle    800296 <printnum+0xaf>
			putch(padc, putdat);
  80022a:	83 ec 08             	sub    $0x8,%esp
  80022d:	57                   	push   %edi
  80022e:	ff 75 18             	pushl  0x18(%ebp)
  800231:	ff d6                	call   *%esi
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	eb eb                	jmp    800223 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	6a 20                	push   $0x20
  80023d:	6a 00                	push   $0x0
  80023f:	50                   	push   %eax
  800240:	ff 75 e4             	pushl  -0x1c(%ebp)
  800243:	ff 75 e0             	pushl  -0x20(%ebp)
  800246:	89 fa                	mov    %edi,%edx
  800248:	89 f0                	mov    %esi,%eax
  80024a:	e8 98 ff ff ff       	call   8001e7 <printnum>
		while (--width > 0)
  80024f:	83 c4 20             	add    $0x20,%esp
  800252:	83 eb 01             	sub    $0x1,%ebx
  800255:	85 db                	test   %ebx,%ebx
  800257:	7e 65                	jle    8002be <printnum+0xd7>
			putch(padc, putdat);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	57                   	push   %edi
  80025d:	6a 20                	push   $0x20
  80025f:	ff d6                	call   *%esi
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	eb ec                	jmp    800252 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 18             	pushl  0x18(%ebp)
  80026c:	83 eb 01             	sub    $0x1,%ebx
  80026f:	53                   	push   %ebx
  800270:	50                   	push   %eax
  800271:	83 ec 08             	sub    $0x8,%esp
  800274:	ff 75 dc             	pushl  -0x24(%ebp)
  800277:	ff 75 d8             	pushl  -0x28(%ebp)
  80027a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027d:	ff 75 e0             	pushl  -0x20(%ebp)
  800280:	e8 cb 10 00 00       	call   801350 <__udivdi3>
  800285:	83 c4 18             	add    $0x18,%esp
  800288:	52                   	push   %edx
  800289:	50                   	push   %eax
  80028a:	89 fa                	mov    %edi,%edx
  80028c:	89 f0                	mov    %esi,%eax
  80028e:	e8 54 ff ff ff       	call   8001e7 <printnum>
  800293:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	57                   	push   %edi
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a9:	e8 b2 11 00 00       	call   801460 <__umoddi3>
  8002ae:	83 c4 14             	add    $0x14,%esp
  8002b1:	0f be 80 c0 15 80 00 	movsbl 0x8015c0(%eax),%eax
  8002b8:	50                   	push   %eax
  8002b9:	ff d6                	call   *%esi
  8002bb:	83 c4 10             	add    $0x10,%esp
}
  8002be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d0:	8b 10                	mov    (%eax),%edx
  8002d2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d5:	73 0a                	jae    8002e1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002da:	89 08                	mov    %ecx,(%eax)
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	88 02                	mov    %al,(%edx)
}
  8002e1:	5d                   	pop    %ebp
  8002e2:	c3                   	ret    

008002e3 <printfmt>:
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ec:	50                   	push   %eax
  8002ed:	ff 75 10             	pushl  0x10(%ebp)
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	e8 05 00 00 00       	call   800300 <vprintfmt>
}
  8002fb:	83 c4 10             	add    $0x10,%esp
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <vprintfmt>:
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	57                   	push   %edi
  800304:	56                   	push   %esi
  800305:	53                   	push   %ebx
  800306:	83 ec 3c             	sub    $0x3c,%esp
  800309:	8b 75 08             	mov    0x8(%ebp),%esi
  80030c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800312:	e9 b4 03 00 00       	jmp    8006cb <vprintfmt+0x3cb>
		padc = ' ';
  800317:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  80031b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800322:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800329:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800330:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800337:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80033c:	8d 47 01             	lea    0x1(%edi),%eax
  80033f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800342:	0f b6 17             	movzbl (%edi),%edx
  800345:	8d 42 dd             	lea    -0x23(%edx),%eax
  800348:	3c 55                	cmp    $0x55,%al
  80034a:	0f 87 c8 04 00 00    	ja     800818 <vprintfmt+0x518>
  800350:	0f b6 c0             	movzbl %al,%eax
  800353:	ff 24 85 a0 17 80 00 	jmp    *0x8017a0(,%eax,4)
  80035a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80035d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800364:	eb d6                	jmp    80033c <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800369:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036d:	eb cd                	jmp    80033c <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80036f:	0f b6 d2             	movzbl %dl,%edx
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800375:	b8 00 00 00 00       	mov    $0x0,%eax
  80037a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80037d:	eb 0c                	jmp    80038b <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800382:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800386:	eb b4                	jmp    80033c <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800388:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800392:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800395:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800398:	83 f9 09             	cmp    $0x9,%ecx
  80039b:	76 eb                	jbe    800388 <vprintfmt+0x88>
  80039d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a3:	eb 14                	jmp    8003b9 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	8d 40 04             	lea    0x4(%eax),%eax
  8003b3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bd:	0f 89 79 ff ff ff    	jns    80033c <vprintfmt+0x3c>
				width = precision, precision = -1;
  8003c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d0:	e9 67 ff ff ff       	jmp    80033c <vprintfmt+0x3c>
  8003d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d8:	85 c0                	test   %eax,%eax
  8003da:	ba 00 00 00 00       	mov    $0x0,%edx
  8003df:	0f 49 d0             	cmovns %eax,%edx
  8003e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e8:	e9 4f ff ff ff       	jmp    80033c <vprintfmt+0x3c>
  8003ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003f7:	e9 40 ff ff ff       	jmp    80033c <vprintfmt+0x3c>
			lflag++;
  8003fc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800402:	e9 35 ff ff ff       	jmp    80033c <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8d 78 04             	lea    0x4(%eax),%edi
  80040d:	83 ec 08             	sub    $0x8,%esp
  800410:	53                   	push   %ebx
  800411:	ff 30                	pushl  (%eax)
  800413:	ff d6                	call   *%esi
			break;
  800415:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800418:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80041b:	e9 a8 02 00 00       	jmp    8006c8 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800420:	8b 45 14             	mov    0x14(%ebp),%eax
  800423:	8d 78 04             	lea    0x4(%eax),%edi
  800426:	8b 00                	mov    (%eax),%eax
  800428:	99                   	cltd   
  800429:	31 d0                	xor    %edx,%eax
  80042b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042d:	83 f8 0f             	cmp    $0xf,%eax
  800430:	7f 23                	jg     800455 <vprintfmt+0x155>
  800432:	8b 14 85 00 19 80 00 	mov    0x801900(,%eax,4),%edx
  800439:	85 d2                	test   %edx,%edx
  80043b:	74 18                	je     800455 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80043d:	52                   	push   %edx
  80043e:	68 e1 15 80 00       	push   $0x8015e1
  800443:	53                   	push   %ebx
  800444:	56                   	push   %esi
  800445:	e8 99 fe ff ff       	call   8002e3 <printfmt>
  80044a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800450:	e9 73 02 00 00       	jmp    8006c8 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800455:	50                   	push   %eax
  800456:	68 d8 15 80 00       	push   $0x8015d8
  80045b:	53                   	push   %ebx
  80045c:	56                   	push   %esi
  80045d:	e8 81 fe ff ff       	call   8002e3 <printfmt>
  800462:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800468:	e9 5b 02 00 00       	jmp    8006c8 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	83 c0 04             	add    $0x4,%eax
  800473:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80047b:	85 d2                	test   %edx,%edx
  80047d:	b8 d1 15 80 00       	mov    $0x8015d1,%eax
  800482:	0f 45 c2             	cmovne %edx,%eax
  800485:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800488:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048c:	7e 06                	jle    800494 <vprintfmt+0x194>
  80048e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800492:	75 0d                	jne    8004a1 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800494:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800497:	89 c7                	mov    %eax,%edi
  800499:	03 45 e0             	add    -0x20(%ebp),%eax
  80049c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049f:	eb 53                	jmp    8004f4 <vprintfmt+0x1f4>
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a7:	50                   	push   %eax
  8004a8:	e8 13 04 00 00       	call   8008c0 <strnlen>
  8004ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b0:	29 c1                	sub    %eax,%ecx
  8004b2:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004ba:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004be:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c1:	eb 0f                	jmp    8004d2 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	53                   	push   %ebx
  8004c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ca:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cc:	83 ef 01             	sub    $0x1,%edi
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	85 ff                	test   %edi,%edi
  8004d4:	7f ed                	jg     8004c3 <vprintfmt+0x1c3>
  8004d6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d9:	85 d2                	test   %edx,%edx
  8004db:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e0:	0f 49 c2             	cmovns %edx,%eax
  8004e3:	29 c2                	sub    %eax,%edx
  8004e5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e8:	eb aa                	jmp    800494 <vprintfmt+0x194>
					putch(ch, putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	52                   	push   %edx
  8004ef:	ff d6                	call   *%esi
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f9:	83 c7 01             	add    $0x1,%edi
  8004fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800500:	0f be d0             	movsbl %al,%edx
  800503:	85 d2                	test   %edx,%edx
  800505:	74 4b                	je     800552 <vprintfmt+0x252>
  800507:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050b:	78 06                	js     800513 <vprintfmt+0x213>
  80050d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800511:	78 1e                	js     800531 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800513:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800517:	74 d1                	je     8004ea <vprintfmt+0x1ea>
  800519:	0f be c0             	movsbl %al,%eax
  80051c:	83 e8 20             	sub    $0x20,%eax
  80051f:	83 f8 5e             	cmp    $0x5e,%eax
  800522:	76 c6                	jbe    8004ea <vprintfmt+0x1ea>
					putch('?', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	53                   	push   %ebx
  800528:	6a 3f                	push   $0x3f
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	eb c3                	jmp    8004f4 <vprintfmt+0x1f4>
  800531:	89 cf                	mov    %ecx,%edi
  800533:	eb 0e                	jmp    800543 <vprintfmt+0x243>
				putch(' ', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 20                	push   $0x20
  80053b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053d:	83 ef 01             	sub    $0x1,%edi
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	85 ff                	test   %edi,%edi
  800545:	7f ee                	jg     800535 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	e9 76 01 00 00       	jmp    8006c8 <vprintfmt+0x3c8>
  800552:	89 cf                	mov    %ecx,%edi
  800554:	eb ed                	jmp    800543 <vprintfmt+0x243>
	if (lflag >= 2)
  800556:	83 f9 01             	cmp    $0x1,%ecx
  800559:	7f 1f                	jg     80057a <vprintfmt+0x27a>
	else if (lflag)
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	74 6a                	je     8005c9 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800567:	89 c1                	mov    %eax,%ecx
  800569:	c1 f9 1f             	sar    $0x1f,%ecx
  80056c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 40 04             	lea    0x4(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
  800578:	eb 17                	jmp    800591 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8b 50 04             	mov    0x4(%eax),%edx
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800585:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8d 40 08             	lea    0x8(%eax),%eax
  80058e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800591:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800594:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800599:	85 d2                	test   %edx,%edx
  80059b:	0f 89 f8 00 00 00    	jns    800699 <vprintfmt+0x399>
				putch('-', putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	6a 2d                	push   $0x2d
  8005a7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005af:	f7 d8                	neg    %eax
  8005b1:	83 d2 00             	adc    $0x0,%edx
  8005b4:	f7 da                	neg    %edx
  8005b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005bc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005bf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005c4:	e9 e1 00 00 00       	jmp    8006aa <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	99                   	cltd   
  8005d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	eb b1                	jmp    800591 <vprintfmt+0x291>
	if (lflag >= 2)
  8005e0:	83 f9 01             	cmp    $0x1,%ecx
  8005e3:	7f 27                	jg     80060c <vprintfmt+0x30c>
	else if (lflag)
  8005e5:	85 c9                	test   %ecx,%ecx
  8005e7:	74 41                	je     80062a <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800602:	bf 0a 00 00 00       	mov    $0xa,%edi
  800607:	e9 8d 00 00 00       	jmp    800699 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 50 04             	mov    0x4(%eax),%edx
  800612:	8b 00                	mov    (%eax),%eax
  800614:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800617:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 40 08             	lea    0x8(%eax),%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800623:	bf 0a 00 00 00       	mov    $0xa,%edi
  800628:	eb 6f                	jmp    800699 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	ba 00 00 00 00       	mov    $0x0,%edx
  800634:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800637:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8d 40 04             	lea    0x4(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800643:	bf 0a 00 00 00       	mov    $0xa,%edi
  800648:	eb 4f                	jmp    800699 <vprintfmt+0x399>
	if (lflag >= 2)
  80064a:	83 f9 01             	cmp    $0x1,%ecx
  80064d:	7f 23                	jg     800672 <vprintfmt+0x372>
	else if (lflag)
  80064f:	85 c9                	test   %ecx,%ecx
  800651:	0f 84 98 00 00 00    	je     8006ef <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 40 04             	lea    0x4(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
  800670:	eb 17                	jmp    800689 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 50 04             	mov    0x4(%eax),%edx
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 40 08             	lea    0x8(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	53                   	push   %ebx
  80068d:	6a 30                	push   $0x30
  80068f:	ff d6                	call   *%esi
			goto number;
  800691:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800694:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800699:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80069d:	74 0b                	je     8006aa <vprintfmt+0x3aa>
				putch('+', putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	53                   	push   %ebx
  8006a3:	6a 2b                	push   $0x2b
  8006a5:	ff d6                	call   *%esi
  8006a7:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b5:	57                   	push   %edi
  8006b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8006b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8006bc:	89 da                	mov    %ebx,%edx
  8006be:	89 f0                	mov    %esi,%eax
  8006c0:	e8 22 fb ff ff       	call   8001e7 <printnum>
			break;
  8006c5:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8006c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cb:	83 c7 01             	add    $0x1,%edi
  8006ce:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d2:	83 f8 25             	cmp    $0x25,%eax
  8006d5:	0f 84 3c fc ff ff    	je     800317 <vprintfmt+0x17>
			if (ch == '\0')
  8006db:	85 c0                	test   %eax,%eax
  8006dd:	0f 84 55 01 00 00    	je     800838 <vprintfmt+0x538>
			putch(ch, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	50                   	push   %eax
  8006e8:	ff d6                	call   *%esi
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	eb dc                	jmp    8006cb <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
  800708:	e9 7c ff ff ff       	jmp    800689 <vprintfmt+0x389>
			putch('0', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	6a 30                	push   $0x30
  800713:	ff d6                	call   *%esi
			putch('x', putdat);
  800715:	83 c4 08             	add    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	6a 78                	push   $0x78
  80071b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	ba 00 00 00 00       	mov    $0x0,%edx
  800727:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80072d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 40 04             	lea    0x4(%eax),%eax
  800736:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800739:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  80073e:	e9 56 ff ff ff       	jmp    800699 <vprintfmt+0x399>
	if (lflag >= 2)
  800743:	83 f9 01             	cmp    $0x1,%ecx
  800746:	7f 27                	jg     80076f <vprintfmt+0x46f>
	else if (lflag)
  800748:	85 c9                	test   %ecx,%ecx
  80074a:	74 44                	je     800790 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800759:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8d 40 04             	lea    0x4(%eax),%eax
  800762:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800765:	bf 10 00 00 00       	mov    $0x10,%edi
  80076a:	e9 2a ff ff ff       	jmp    800699 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 50 04             	mov    0x4(%eax),%edx
  800775:	8b 00                	mov    (%eax),%eax
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 08             	lea    0x8(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800786:	bf 10 00 00 00       	mov    $0x10,%edi
  80078b:	e9 09 ff ff ff       	jmp    800699 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a9:	bf 10 00 00 00       	mov    $0x10,%edi
  8007ae:	e9 e6 fe ff ff       	jmp    800699 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8d 78 04             	lea    0x4(%eax),%edi
  8007b9:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	74 2d                	je     8007ec <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8007bf:	0f b6 13             	movzbl (%ebx),%edx
  8007c2:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007c4:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8007c7:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007ca:	0f 8e f8 fe ff ff    	jle    8006c8 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007d0:	68 30 17 80 00       	push   $0x801730
  8007d5:	68 e1 15 80 00       	push   $0x8015e1
  8007da:	53                   	push   %ebx
  8007db:	56                   	push   %esi
  8007dc:	e8 02 fb ff ff       	call   8002e3 <printfmt>
  8007e1:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007e4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007e7:	e9 dc fe ff ff       	jmp    8006c8 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8007ec:	68 f8 16 80 00       	push   $0x8016f8
  8007f1:	68 e1 15 80 00       	push   $0x8015e1
  8007f6:	53                   	push   %ebx
  8007f7:	56                   	push   %esi
  8007f8:	e8 e6 fa ff ff       	call   8002e3 <printfmt>
  8007fd:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800800:	89 7d 14             	mov    %edi,0x14(%ebp)
  800803:	e9 c0 fe ff ff       	jmp    8006c8 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	53                   	push   %ebx
  80080c:	6a 25                	push   $0x25
  80080e:	ff d6                	call   *%esi
			break;
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	e9 b0 fe ff ff       	jmp    8006c8 <vprintfmt+0x3c8>
			putch('%', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 25                	push   $0x25
  80081e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 f8                	mov    %edi,%eax
  800825:	eb 03                	jmp    80082a <vprintfmt+0x52a>
  800827:	83 e8 01             	sub    $0x1,%eax
  80082a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80082e:	75 f7                	jne    800827 <vprintfmt+0x527>
  800830:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800833:	e9 90 fe ff ff       	jmp    8006c8 <vprintfmt+0x3c8>
}
  800838:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80083b:	5b                   	pop    %ebx
  80083c:	5e                   	pop    %esi
  80083d:	5f                   	pop    %edi
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 18             	sub    $0x18,%esp
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80084c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80084f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800853:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80085d:	85 c0                	test   %eax,%eax
  80085f:	74 26                	je     800887 <vsnprintf+0x47>
  800861:	85 d2                	test   %edx,%edx
  800863:	7e 22                	jle    800887 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800865:	ff 75 14             	pushl  0x14(%ebp)
  800868:	ff 75 10             	pushl  0x10(%ebp)
  80086b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80086e:	50                   	push   %eax
  80086f:	68 c6 02 80 00       	push   $0x8002c6
  800874:	e8 87 fa ff ff       	call   800300 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80087f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800882:	83 c4 10             	add    $0x10,%esp
}
  800885:	c9                   	leave  
  800886:	c3                   	ret    
		return -E_INVAL;
  800887:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088c:	eb f7                	jmp    800885 <vsnprintf+0x45>

0080088e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800894:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800897:	50                   	push   %eax
  800898:	ff 75 10             	pushl  0x10(%ebp)
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	ff 75 08             	pushl  0x8(%ebp)
  8008a1:	e8 9a ff ff ff       	call   800840 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a6:	c9                   	leave  
  8008a7:	c3                   	ret    

008008a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b7:	74 05                	je     8008be <strlen+0x16>
		n++;
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	eb f5                	jmp    8008b3 <strlen+0xb>
	return n;
}
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ce:	39 c2                	cmp    %eax,%edx
  8008d0:	74 0d                	je     8008df <strnlen+0x1f>
  8008d2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008d6:	74 05                	je     8008dd <strnlen+0x1d>
		n++;
  8008d8:	83 c2 01             	add    $0x1,%edx
  8008db:	eb f1                	jmp    8008ce <strnlen+0xe>
  8008dd:	89 d0                	mov    %edx,%eax
	return n;
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008f7:	83 c2 01             	add    $0x1,%edx
  8008fa:	84 c9                	test   %cl,%cl
  8008fc:	75 f2                	jne    8008f0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008fe:	5b                   	pop    %ebx
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	53                   	push   %ebx
  800905:	83 ec 10             	sub    $0x10,%esp
  800908:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80090b:	53                   	push   %ebx
  80090c:	e8 97 ff ff ff       	call   8008a8 <strlen>
  800911:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	01 d8                	add    %ebx,%eax
  800919:	50                   	push   %eax
  80091a:	e8 c2 ff ff ff       	call   8008e1 <strcpy>
	return dst;
}
  80091f:	89 d8                	mov    %ebx,%eax
  800921:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800924:	c9                   	leave  
  800925:	c3                   	ret    

00800926 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	56                   	push   %esi
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800931:	89 c6                	mov    %eax,%esi
  800933:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800936:	89 c2                	mov    %eax,%edx
  800938:	39 f2                	cmp    %esi,%edx
  80093a:	74 11                	je     80094d <strncpy+0x27>
		*dst++ = *src;
  80093c:	83 c2 01             	add    $0x1,%edx
  80093f:	0f b6 19             	movzbl (%ecx),%ebx
  800942:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800945:	80 fb 01             	cmp    $0x1,%bl
  800948:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80094b:	eb eb                	jmp    800938 <strncpy+0x12>
	}
	return ret;
}
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 75 08             	mov    0x8(%ebp),%esi
  800959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095c:	8b 55 10             	mov    0x10(%ebp),%edx
  80095f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800961:	85 d2                	test   %edx,%edx
  800963:	74 21                	je     800986 <strlcpy+0x35>
  800965:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800969:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80096b:	39 c2                	cmp    %eax,%edx
  80096d:	74 14                	je     800983 <strlcpy+0x32>
  80096f:	0f b6 19             	movzbl (%ecx),%ebx
  800972:	84 db                	test   %bl,%bl
  800974:	74 0b                	je     800981 <strlcpy+0x30>
			*dst++ = *src++;
  800976:	83 c1 01             	add    $0x1,%ecx
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80097f:	eb ea                	jmp    80096b <strlcpy+0x1a>
  800981:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800983:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800986:	29 f0                	sub    %esi,%eax
}
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800995:	0f b6 01             	movzbl (%ecx),%eax
  800998:	84 c0                	test   %al,%al
  80099a:	74 0c                	je     8009a8 <strcmp+0x1c>
  80099c:	3a 02                	cmp    (%edx),%al
  80099e:	75 08                	jne    8009a8 <strcmp+0x1c>
		p++, q++;
  8009a0:	83 c1 01             	add    $0x1,%ecx
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	eb ed                	jmp    800995 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 c0             	movzbl %al,%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 c3                	mov    %eax,%ebx
  8009be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c1:	eb 06                	jmp    8009c9 <strncmp+0x17>
		n--, p++, q++;
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009c9:	39 d8                	cmp    %ebx,%eax
  8009cb:	74 16                	je     8009e3 <strncmp+0x31>
  8009cd:	0f b6 08             	movzbl (%eax),%ecx
  8009d0:	84 c9                	test   %cl,%cl
  8009d2:	74 04                	je     8009d8 <strncmp+0x26>
  8009d4:	3a 0a                	cmp    (%edx),%cl
  8009d6:	74 eb                	je     8009c3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    
		return 0;
  8009e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e8:	eb f6                	jmp    8009e0 <strncmp+0x2e>

008009ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f4:	0f b6 10             	movzbl (%eax),%edx
  8009f7:	84 d2                	test   %dl,%dl
  8009f9:	74 09                	je     800a04 <strchr+0x1a>
		if (*s == c)
  8009fb:	38 ca                	cmp    %cl,%dl
  8009fd:	74 0a                	je     800a09 <strchr+0x1f>
	for (; *s; s++)
  8009ff:	83 c0 01             	add    $0x1,%eax
  800a02:	eb f0                	jmp    8009f4 <strchr+0xa>
			return (char *) s;
	return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a18:	38 ca                	cmp    %cl,%dl
  800a1a:	74 09                	je     800a25 <strfind+0x1a>
  800a1c:	84 d2                	test   %dl,%dl
  800a1e:	74 05                	je     800a25 <strfind+0x1a>
	for (; *s; s++)
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	eb f0                	jmp    800a15 <strfind+0xa>
			break;
	return (char *) s;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	74 31                	je     800a68 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a37:	89 f8                	mov    %edi,%eax
  800a39:	09 c8                	or     %ecx,%eax
  800a3b:	a8 03                	test   $0x3,%al
  800a3d:	75 23                	jne    800a62 <memset+0x3b>
		c &= 0xFF;
  800a3f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a43:	89 d3                	mov    %edx,%ebx
  800a45:	c1 e3 08             	shl    $0x8,%ebx
  800a48:	89 d0                	mov    %edx,%eax
  800a4a:	c1 e0 18             	shl    $0x18,%eax
  800a4d:	89 d6                	mov    %edx,%esi
  800a4f:	c1 e6 10             	shl    $0x10,%esi
  800a52:	09 f0                	or     %esi,%eax
  800a54:	09 c2                	or     %eax,%edx
  800a56:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a58:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	fc                   	cld    
  800a5e:	f3 ab                	rep stos %eax,%es:(%edi)
  800a60:	eb 06                	jmp    800a68 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	fc                   	cld    
  800a66:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a68:	89 f8                	mov    %edi,%eax
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5f                   	pop    %edi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	57                   	push   %edi
  800a73:	56                   	push   %esi
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a7d:	39 c6                	cmp    %eax,%esi
  800a7f:	73 32                	jae    800ab3 <memmove+0x44>
  800a81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a84:	39 c2                	cmp    %eax,%edx
  800a86:	76 2b                	jbe    800ab3 <memmove+0x44>
		s += n;
		d += n;
  800a88:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8b:	89 fe                	mov    %edi,%esi
  800a8d:	09 ce                	or     %ecx,%esi
  800a8f:	09 d6                	or     %edx,%esi
  800a91:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a97:	75 0e                	jne    800aa7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a99:	83 ef 04             	sub    $0x4,%edi
  800a9c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a9f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa2:	fd                   	std    
  800aa3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa5:	eb 09                	jmp    800ab0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa7:	83 ef 01             	sub    $0x1,%edi
  800aaa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aad:	fd                   	std    
  800aae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab0:	fc                   	cld    
  800ab1:	eb 1a                	jmp    800acd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab3:	89 c2                	mov    %eax,%edx
  800ab5:	09 ca                	or     %ecx,%edx
  800ab7:	09 f2                	or     %esi,%edx
  800ab9:	f6 c2 03             	test   $0x3,%dl
  800abc:	75 0a                	jne    800ac8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800abe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac1:	89 c7                	mov    %eax,%edi
  800ac3:	fc                   	cld    
  800ac4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac6:	eb 05                	jmp    800acd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ac8:	89 c7                	mov    %eax,%edi
  800aca:	fc                   	cld    
  800acb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acd:	5e                   	pop    %esi
  800ace:	5f                   	pop    %edi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad7:	ff 75 10             	pushl  0x10(%ebp)
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	ff 75 08             	pushl  0x8(%ebp)
  800ae0:	e8 8a ff ff ff       	call   800a6f <memmove>
}
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	56                   	push   %esi
  800aeb:	53                   	push   %ebx
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 c6                	mov    %eax,%esi
  800af4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af7:	39 f0                	cmp    %esi,%eax
  800af9:	74 1c                	je     800b17 <memcmp+0x30>
		if (*s1 != *s2)
  800afb:	0f b6 08             	movzbl (%eax),%ecx
  800afe:	0f b6 1a             	movzbl (%edx),%ebx
  800b01:	38 d9                	cmp    %bl,%cl
  800b03:	75 08                	jne    800b0d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	83 c2 01             	add    $0x1,%edx
  800b0b:	eb ea                	jmp    800af7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b0d:	0f b6 c1             	movzbl %cl,%eax
  800b10:	0f b6 db             	movzbl %bl,%ebx
  800b13:	29 d8                	sub    %ebx,%eax
  800b15:	eb 05                	jmp    800b1c <memcmp+0x35>
	}

	return 0;
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1c:	5b                   	pop    %ebx
  800b1d:	5e                   	pop    %esi
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b29:	89 c2                	mov    %eax,%edx
  800b2b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b2e:	39 d0                	cmp    %edx,%eax
  800b30:	73 09                	jae    800b3b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b32:	38 08                	cmp    %cl,(%eax)
  800b34:	74 05                	je     800b3b <memfind+0x1b>
	for (; s < ends; s++)
  800b36:	83 c0 01             	add    $0x1,%eax
  800b39:	eb f3                	jmp    800b2e <memfind+0xe>
			break;
	return (void *) s;
}
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	57                   	push   %edi
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
  800b43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b49:	eb 03                	jmp    800b4e <strtol+0x11>
		s++;
  800b4b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b4e:	0f b6 01             	movzbl (%ecx),%eax
  800b51:	3c 20                	cmp    $0x20,%al
  800b53:	74 f6                	je     800b4b <strtol+0xe>
  800b55:	3c 09                	cmp    $0x9,%al
  800b57:	74 f2                	je     800b4b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b59:	3c 2b                	cmp    $0x2b,%al
  800b5b:	74 2a                	je     800b87 <strtol+0x4a>
	int neg = 0;
  800b5d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b62:	3c 2d                	cmp    $0x2d,%al
  800b64:	74 2b                	je     800b91 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b66:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b6c:	75 0f                	jne    800b7d <strtol+0x40>
  800b6e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b71:	74 28                	je     800b9b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b73:	85 db                	test   %ebx,%ebx
  800b75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7a:	0f 44 d8             	cmove  %eax,%ebx
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b85:	eb 50                	jmp    800bd7 <strtol+0x9a>
		s++;
  800b87:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8f:	eb d5                	jmp    800b66 <strtol+0x29>
		s++, neg = 1;
  800b91:	83 c1 01             	add    $0x1,%ecx
  800b94:	bf 01 00 00 00       	mov    $0x1,%edi
  800b99:	eb cb                	jmp    800b66 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b9f:	74 0e                	je     800baf <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	75 d8                	jne    800b7d <strtol+0x40>
		s++, base = 8;
  800ba5:	83 c1 01             	add    $0x1,%ecx
  800ba8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bad:	eb ce                	jmp    800b7d <strtol+0x40>
		s += 2, base = 16;
  800baf:	83 c1 02             	add    $0x2,%ecx
  800bb2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bb7:	eb c4                	jmp    800b7d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bb9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bbc:	89 f3                	mov    %esi,%ebx
  800bbe:	80 fb 19             	cmp    $0x19,%bl
  800bc1:	77 29                	ja     800bec <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bc3:	0f be d2             	movsbl %dl,%edx
  800bc6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bc9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bcc:	7d 30                	jge    800bfe <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bd7:	0f b6 11             	movzbl (%ecx),%edx
  800bda:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	80 fb 09             	cmp    $0x9,%bl
  800be2:	77 d5                	ja     800bb9 <strtol+0x7c>
			dig = *s - '0';
  800be4:	0f be d2             	movsbl %dl,%edx
  800be7:	83 ea 30             	sub    $0x30,%edx
  800bea:	eb dd                	jmp    800bc9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bec:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bef:	89 f3                	mov    %esi,%ebx
  800bf1:	80 fb 19             	cmp    $0x19,%bl
  800bf4:	77 08                	ja     800bfe <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bf6:	0f be d2             	movsbl %dl,%edx
  800bf9:	83 ea 37             	sub    $0x37,%edx
  800bfc:	eb cb                	jmp    800bc9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c02:	74 05                	je     800c09 <strtol+0xcc>
		*endptr = (char *) s;
  800c04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c07:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c09:	89 c2                	mov    %eax,%edx
  800c0b:	f7 da                	neg    %edx
  800c0d:	85 ff                	test   %edi,%edi
  800c0f:	0f 45 c2             	cmovne %edx,%eax
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	8b 55 08             	mov    0x8(%ebp),%edx
  800c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c28:	89 c3                	mov    %eax,%ebx
  800c2a:	89 c7                	mov    %eax,%edi
  800c2c:	89 c6                	mov    %eax,%esi
  800c2e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	b8 01 00 00 00       	mov    $0x1,%eax
  800c45:	89 d1                	mov    %edx,%ecx
  800c47:	89 d3                	mov    %edx,%ebx
  800c49:	89 d7                	mov    %edx,%edi
  800c4b:	89 d6                	mov    %edx,%esi
  800c4d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	b8 03 00 00 00       	mov    $0x3,%eax
  800c6a:	89 cb                	mov    %ecx,%ebx
  800c6c:	89 cf                	mov    %ecx,%edi
  800c6e:	89 ce                	mov    %ecx,%esi
  800c70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	7f 08                	jg     800c7e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	50                   	push   %eax
  800c82:	6a 03                	push   $0x3
  800c84:	68 40 19 80 00       	push   $0x801940
  800c89:	6a 33                	push   $0x33
  800c8b:	68 5d 19 80 00       	push   $0x80195d
  800c90:	e8 e2 05 00 00       	call   801277 <_panic>

00800c95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca5:	89 d1                	mov    %edx,%ecx
  800ca7:	89 d3                	mov    %edx,%ebx
  800ca9:	89 d7                	mov    %edx,%edi
  800cab:	89 d6                	mov    %edx,%esi
  800cad:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_yield>:

void
sys_yield(void)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdc:	be 00 00 00 00       	mov    $0x0,%esi
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce7:	b8 04 00 00 00       	mov    $0x4,%eax
  800cec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cef:	89 f7                	mov    %esi,%edi
  800cf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7f 08                	jg     800cff <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	50                   	push   %eax
  800d03:	6a 04                	push   $0x4
  800d05:	68 40 19 80 00       	push   $0x801940
  800d0a:	6a 33                	push   $0x33
  800d0c:	68 5d 19 80 00       	push   $0x80195d
  800d11:	e8 61 05 00 00       	call   801277 <_panic>

00800d16 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d30:	8b 75 18             	mov    0x18(%ebp),%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d45:	6a 05                	push   $0x5
  800d47:	68 40 19 80 00       	push   $0x801940
  800d4c:	6a 33                	push   $0x33
  800d4e:	68 5d 19 80 00       	push   $0x80195d
  800d53:	e8 1f 05 00 00       	call   801277 <_panic>

00800d58 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d6c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d71:	89 df                	mov    %ebx,%edi
  800d73:	89 de                	mov    %ebx,%esi
  800d75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7f 08                	jg     800d83 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d87:	6a 06                	push   $0x6
  800d89:	68 40 19 80 00       	push   $0x801940
  800d8e:	6a 33                	push   $0x33
  800d90:	68 5d 19 80 00       	push   $0x80195d
  800d95:	e8 dd 04 00 00       	call   801277 <_panic>

00800d9a <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db0:	89 cb                	mov    %ecx,%ebx
  800db2:	89 cf                	mov    %ecx,%edi
  800db4:	89 ce                	mov    %ecx,%esi
  800db6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db8:	85 c0                	test   %eax,%eax
  800dba:	7f 08                	jg     800dc4 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbf:	5b                   	pop    %ebx
  800dc0:	5e                   	pop    %esi
  800dc1:	5f                   	pop    %edi
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc4:	83 ec 0c             	sub    $0xc,%esp
  800dc7:	50                   	push   %eax
  800dc8:	6a 0b                	push   $0xb
  800dca:	68 40 19 80 00       	push   $0x801940
  800dcf:	6a 33                	push   $0x33
  800dd1:	68 5d 19 80 00       	push   $0x80195d
  800dd6:	e8 9c 04 00 00       	call   801277 <_panic>

00800ddb <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	57                   	push   %edi
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
  800de1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800def:	b8 08 00 00 00       	mov    $0x8,%eax
  800df4:	89 df                	mov    %ebx,%edi
  800df6:	89 de                	mov    %ebx,%esi
  800df8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	7f 08                	jg     800e06 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	83 ec 0c             	sub    $0xc,%esp
  800e09:	50                   	push   %eax
  800e0a:	6a 08                	push   $0x8
  800e0c:	68 40 19 80 00       	push   $0x801940
  800e11:	6a 33                	push   $0x33
  800e13:	68 5d 19 80 00       	push   $0x80195d
  800e18:	e8 5a 04 00 00       	call   801277 <_panic>

00800e1d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	57                   	push   %edi
  800e21:	56                   	push   %esi
  800e22:	53                   	push   %ebx
  800e23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	b8 09 00 00 00       	mov    $0x9,%eax
  800e36:	89 df                	mov    %ebx,%edi
  800e38:	89 de                	mov    %ebx,%esi
  800e3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7f 08                	jg     800e48 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	50                   	push   %eax
  800e4c:	6a 09                	push   $0x9
  800e4e:	68 40 19 80 00       	push   $0x801940
  800e53:	6a 33                	push   $0x33
  800e55:	68 5d 19 80 00       	push   $0x80195d
  800e5a:	e8 18 04 00 00       	call   801277 <_panic>

00800e5f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	57                   	push   %edi
  800e63:	56                   	push   %esi
  800e64:	53                   	push   %ebx
  800e65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e73:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e78:	89 df                	mov    %ebx,%edi
  800e7a:	89 de                	mov    %ebx,%esi
  800e7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	7f 08                	jg     800e8a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8a:	83 ec 0c             	sub    $0xc,%esp
  800e8d:	50                   	push   %eax
  800e8e:	6a 0a                	push   $0xa
  800e90:	68 40 19 80 00       	push   $0x801940
  800e95:	6a 33                	push   $0x33
  800e97:	68 5d 19 80 00       	push   $0x80195d
  800e9c:	e8 d6 03 00 00       	call   801277 <_panic>

00800ea1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ead:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb2:	be 00 00 00 00       	mov    $0x0,%esi
  800eb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ebd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ebf:	5b                   	pop    %ebx
  800ec0:	5e                   	pop    %esi
  800ec1:	5f                   	pop    %edi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	57                   	push   %edi
  800ec8:	56                   	push   %esi
  800ec9:	53                   	push   %ebx
  800eca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ecd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eda:	89 cb                	mov    %ecx,%ebx
  800edc:	89 cf                	mov    %ecx,%edi
  800ede:	89 ce                	mov    %ecx,%esi
  800ee0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	7f 08                	jg     800eee <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eee:	83 ec 0c             	sub    $0xc,%esp
  800ef1:	50                   	push   %eax
  800ef2:	6a 0e                	push   $0xe
  800ef4:	68 40 19 80 00       	push   $0x801940
  800ef9:	6a 33                	push   $0x33
  800efb:	68 5d 19 80 00       	push   $0x80195d
  800f00:	e8 72 03 00 00       	call   801277 <_panic>

00800f05 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	57                   	push   %edi
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f1b:	89 df                	mov    %ebx,%edi
  800f1d:	89 de                	mov    %ebx,%esi
  800f1f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	57                   	push   %edi
  800f2a:	56                   	push   %esi
  800f2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f31:	8b 55 08             	mov    0x8(%ebp),%edx
  800f34:	b8 10 00 00 00       	mov    $0x10,%eax
  800f39:	89 cb                	mov    %ecx,%ebx
  800f3b:	89 cf                	mov    %ecx,%edi
  800f3d:	89 ce                	mov    %ecx,%esi
  800f3f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	53                   	push   %ebx
  800f4a:	83 ec 04             	sub    $0x4,%esp
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f50:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  800f52:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f56:	0f 84 90 00 00 00    	je     800fec <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  800f5c:	89 d8                	mov    %ebx,%eax
  800f5e:	c1 e8 16             	shr    $0x16,%eax
  800f61:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f68:	a8 01                	test   $0x1,%al
  800f6a:	0f 84 90 00 00 00    	je     801000 <pgfault+0xba>
  800f70:	89 d8                	mov    %ebx,%eax
  800f72:	c1 e8 0c             	shr    $0xc,%eax
  800f75:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f7c:	a9 01 08 00 00       	test   $0x801,%eax
  800f81:	74 7d                	je     801000 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  800f83:	83 ec 04             	sub    $0x4,%esp
  800f86:	6a 07                	push   $0x7
  800f88:	68 00 f0 7f 00       	push   $0x7ff000
  800f8d:	6a 00                	push   $0x0
  800f8f:	e8 3f fd ff ff       	call   800cd3 <sys_page_alloc>
  800f94:	83 c4 10             	add    $0x10,%esp
  800f97:	85 c0                	test   %eax,%eax
  800f99:	78 79                	js     801014 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  800f9b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 00 10 00 00       	push   $0x1000
  800fa9:	53                   	push   %ebx
  800faa:	68 00 f0 7f 00       	push   $0x7ff000
  800faf:	e8 bb fa ff ff       	call   800a6f <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  800fb4:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fbb:	53                   	push   %ebx
  800fbc:	6a 00                	push   $0x0
  800fbe:	68 00 f0 7f 00       	push   $0x7ff000
  800fc3:	6a 00                	push   $0x0
  800fc5:	e8 4c fd ff ff       	call   800d16 <sys_page_map>
  800fca:	83 c4 20             	add    $0x20,%esp
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	78 55                	js     801026 <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  800fd1:	83 ec 08             	sub    $0x8,%esp
  800fd4:	68 00 f0 7f 00       	push   $0x7ff000
  800fd9:	6a 00                	push   $0x0
  800fdb:	e8 78 fd ff ff       	call   800d58 <sys_page_unmap>
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	78 51                	js     801038 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  800fe7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fea:	c9                   	leave  
  800feb:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  800fec:	83 ec 04             	sub    $0x4,%esp
  800fef:	68 6c 19 80 00       	push   $0x80196c
  800ff4:	6a 21                	push   $0x21
  800ff6:	68 f4 19 80 00       	push   $0x8019f4
  800ffb:	e8 77 02 00 00       	call   801277 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  801000:	83 ec 04             	sub    $0x4,%esp
  801003:	68 98 19 80 00       	push   $0x801998
  801008:	6a 24                	push   $0x24
  80100a:	68 f4 19 80 00       	push   $0x8019f4
  80100f:	e8 63 02 00 00       	call   801277 <_panic>
		panic("sys_page_alloc: %e\n", r);
  801014:	50                   	push   %eax
  801015:	68 ff 19 80 00       	push   $0x8019ff
  80101a:	6a 2e                	push   $0x2e
  80101c:	68 f4 19 80 00       	push   $0x8019f4
  801021:	e8 51 02 00 00       	call   801277 <_panic>
		panic("sys_page_map: %e\n", r);
  801026:	50                   	push   %eax
  801027:	68 13 1a 80 00       	push   $0x801a13
  80102c:	6a 34                	push   $0x34
  80102e:	68 f4 19 80 00       	push   $0x8019f4
  801033:	e8 3f 02 00 00       	call   801277 <_panic>
		panic("sys_page_unmap: %e\n", r);
  801038:	50                   	push   %eax
  801039:	68 25 1a 80 00       	push   $0x801a25
  80103e:	6a 37                	push   $0x37
  801040:	68 f4 19 80 00       	push   $0x8019f4
  801045:	e8 2d 02 00 00       	call   801277 <_panic>

0080104a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
  801050:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801053:	68 46 0f 80 00       	push   $0x800f46
  801058:	e8 60 02 00 00       	call   8012bd <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80105d:	b8 07 00 00 00       	mov    $0x7,%eax
  801062:	cd 30                	int    $0x30
  801064:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	85 c0                	test   %eax,%eax
  80106c:	78 30                	js     80109e <fork+0x54>
  80106e:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801070:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801075:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801079:	0f 85 a5 00 00 00    	jne    801124 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  80107f:	e8 11 fc ff ff       	call   800c95 <sys_getenvid>
  801084:	25 ff 03 00 00       	and    $0x3ff,%eax
  801089:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80108c:	c1 e0 04             	shl    $0x4,%eax
  80108f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801094:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801099:	e9 75 01 00 00       	jmp    801213 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  80109e:	50                   	push   %eax
  80109f:	68 39 1a 80 00       	push   $0x801a39
  8010a4:	68 83 00 00 00       	push   $0x83
  8010a9:	68 f4 19 80 00       	push   $0x8019f4
  8010ae:	e8 c4 01 00 00       	call   801277 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8010b3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ba:	83 ec 0c             	sub    $0xc,%esp
  8010bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c2:	50                   	push   %eax
  8010c3:	56                   	push   %esi
  8010c4:	57                   	push   %edi
  8010c5:	56                   	push   %esi
  8010c6:	6a 00                	push   $0x0
  8010c8:	e8 49 fc ff ff       	call   800d16 <sys_page_map>
  8010cd:	83 c4 20             	add    $0x20,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	79 3e                	jns    801112 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8010d4:	50                   	push   %eax
  8010d5:	68 13 1a 80 00       	push   $0x801a13
  8010da:	6a 50                	push   $0x50
  8010dc:	68 f4 19 80 00       	push   $0x8019f4
  8010e1:	e8 91 01 00 00       	call   801277 <_panic>
			panic("sys_page_map: %e\n", r);
  8010e6:	50                   	push   %eax
  8010e7:	68 13 1a 80 00       	push   $0x801a13
  8010ec:	6a 54                	push   $0x54
  8010ee:	68 f4 19 80 00       	push   $0x8019f4
  8010f3:	e8 7f 01 00 00       	call   801277 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8010f8:	83 ec 0c             	sub    $0xc,%esp
  8010fb:	6a 05                	push   $0x5
  8010fd:	56                   	push   %esi
  8010fe:	57                   	push   %edi
  8010ff:	56                   	push   %esi
  801100:	6a 00                	push   $0x0
  801102:	e8 0f fc ff ff       	call   800d16 <sys_page_map>
  801107:	83 c4 20             	add    $0x20,%esp
  80110a:	85 c0                	test   %eax,%eax
  80110c:	0f 88 ab 00 00 00    	js     8011bd <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801112:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801118:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80111e:	0f 84 ab 00 00 00    	je     8011cf <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  801124:	89 d8                	mov    %ebx,%eax
  801126:	c1 e8 16             	shr    $0x16,%eax
  801129:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801130:	a8 01                	test   $0x1,%al
  801132:	74 de                	je     801112 <fork+0xc8>
  801134:	89 d8                	mov    %ebx,%eax
  801136:	c1 e8 0c             	shr    $0xc,%eax
  801139:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801140:	f6 c2 01             	test   $0x1,%dl
  801143:	74 cd                	je     801112 <fork+0xc8>
  801145:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  80114b:	74 c5                	je     801112 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  80114d:	89 c6                	mov    %eax,%esi
  80114f:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  801152:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801159:	f6 c6 04             	test   $0x4,%dh
  80115c:	0f 85 51 ff ff ff    	jne    8010b3 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  801162:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801169:	a9 02 08 00 00       	test   $0x802,%eax
  80116e:	74 88                	je     8010f8 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	68 05 08 00 00       	push   $0x805
  801178:	56                   	push   %esi
  801179:	57                   	push   %edi
  80117a:	56                   	push   %esi
  80117b:	6a 00                	push   $0x0
  80117d:	e8 94 fb ff ff       	call   800d16 <sys_page_map>
  801182:	83 c4 20             	add    $0x20,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	0f 88 59 ff ff ff    	js     8010e6 <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  80118d:	83 ec 0c             	sub    $0xc,%esp
  801190:	68 05 08 00 00       	push   $0x805
  801195:	56                   	push   %esi
  801196:	6a 00                	push   $0x0
  801198:	56                   	push   %esi
  801199:	6a 00                	push   $0x0
  80119b:	e8 76 fb ff ff       	call   800d16 <sys_page_map>
  8011a0:	83 c4 20             	add    $0x20,%esp
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	0f 89 67 ff ff ff    	jns    801112 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8011ab:	50                   	push   %eax
  8011ac:	68 13 1a 80 00       	push   $0x801a13
  8011b1:	6a 56                	push   $0x56
  8011b3:	68 f4 19 80 00       	push   $0x8019f4
  8011b8:	e8 ba 00 00 00       	call   801277 <_panic>
			panic("sys_page_map: %e\n", r);
  8011bd:	50                   	push   %eax
  8011be:	68 13 1a 80 00       	push   $0x801a13
  8011c3:	6a 5a                	push   $0x5a
  8011c5:	68 f4 19 80 00       	push   $0x8019f4
  8011ca:	e8 a8 00 00 00       	call   801277 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8011cf:	83 ec 04             	sub    $0x4,%esp
  8011d2:	6a 07                	push   $0x7
  8011d4:	68 00 f0 bf ee       	push   $0xeebff000
  8011d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011dc:	e8 f2 fa ff ff       	call   800cd3 <sys_page_alloc>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 36                	js     80121e <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	68 28 13 80 00       	push   $0x801328
  8011f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f3:	e8 67 fc ff ff       	call   800e5f <sys_env_set_pgfault_upcall>
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	78 34                	js     801233 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011ff:	83 ec 08             	sub    $0x8,%esp
  801202:	6a 02                	push   $0x2
  801204:	ff 75 e4             	pushl  -0x1c(%ebp)
  801207:	e8 cf fb ff ff       	call   800ddb <sys_env_set_status>
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	78 35                	js     801248 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  801213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  80121e:	50                   	push   %eax
  80121f:	68 ff 19 80 00       	push   $0x8019ff
  801224:	68 95 00 00 00       	push   $0x95
  801229:	68 f4 19 80 00       	push   $0x8019f4
  80122e:	e8 44 00 00 00       	call   801277 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801233:	50                   	push   %eax
  801234:	68 d4 19 80 00       	push   $0x8019d4
  801239:	68 98 00 00 00       	push   $0x98
  80123e:	68 f4 19 80 00       	push   $0x8019f4
  801243:	e8 2f 00 00 00       	call   801277 <_panic>
		panic("sys_env_set_status: %e\n", r);
  801248:	50                   	push   %eax
  801249:	68 49 1a 80 00       	push   $0x801a49
  80124e:	68 9b 00 00 00       	push   $0x9b
  801253:	68 f4 19 80 00       	push   $0x8019f4
  801258:	e8 1a 00 00 00       	call   801277 <_panic>

0080125d <sfork>:

// Challenge!
int
sfork(void)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801263:	68 61 1a 80 00       	push   $0x801a61
  801268:	68 a4 00 00 00       	push   $0xa4
  80126d:	68 f4 19 80 00       	push   $0x8019f4
  801272:	e8 00 00 00 00       	call   801277 <_panic>

00801277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	56                   	push   %esi
  80127b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80127c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80127f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801285:	e8 0b fa ff ff       	call   800c95 <sys_getenvid>
  80128a:	83 ec 0c             	sub    $0xc,%esp
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	ff 75 08             	pushl  0x8(%ebp)
  801293:	56                   	push   %esi
  801294:	50                   	push   %eax
  801295:	68 78 1a 80 00       	push   $0x801a78
  80129a:	e8 34 ef ff ff       	call   8001d3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80129f:	83 c4 18             	add    $0x18,%esp
  8012a2:	53                   	push   %ebx
  8012a3:	ff 75 10             	pushl  0x10(%ebp)
  8012a6:	e8 d7 ee ff ff       	call   800182 <vcprintf>
	cprintf("\n");
  8012ab:	c7 04 24 af 15 80 00 	movl   $0x8015af,(%esp)
  8012b2:	e8 1c ef ff ff       	call   8001d3 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8012ba:	cc                   	int3   
  8012bb:	eb fd                	jmp    8012ba <_panic+0x43>

008012bd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8012c3:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8012ca:	74 0a                	je     8012d6 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8012d6:	83 ec 04             	sub    $0x4,%esp
  8012d9:	6a 07                	push   $0x7
  8012db:	68 00 f0 bf ee       	push   $0xeebff000
  8012e0:	6a 00                	push   $0x0
  8012e2:	e8 ec f9 ff ff       	call   800cd3 <sys_page_alloc>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	78 28                	js     801316 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8012ee:	83 ec 08             	sub    $0x8,%esp
  8012f1:	68 28 13 80 00       	push   $0x801328
  8012f6:	6a 00                	push   $0x0
  8012f8:	e8 62 fb ff ff       	call   800e5f <sys_env_set_pgfault_upcall>
  8012fd:	83 c4 10             	add    $0x10,%esp
  801300:	85 c0                	test   %eax,%eax
  801302:	79 c8                	jns    8012cc <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  801304:	50                   	push   %eax
  801305:	68 d4 19 80 00       	push   $0x8019d4
  80130a:	6a 23                	push   $0x23
  80130c:	68 b4 1a 80 00       	push   $0x801ab4
  801311:	e8 61 ff ff ff       	call   801277 <_panic>
			panic("set_pgfault_handler %e\n",r);
  801316:	50                   	push   %eax
  801317:	68 9c 1a 80 00       	push   $0x801a9c
  80131c:	6a 21                	push   $0x21
  80131e:	68 b4 1a 80 00       	push   $0x801ab4
  801323:	e8 4f ff ff ff       	call   801277 <_panic>

00801328 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801328:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801329:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  80132e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801330:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  801333:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  801337:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80133b:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80133e:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801340:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801344:	83 c4 08             	add    $0x8,%esp
	popal
  801347:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801348:	83 c4 04             	add    $0x4,%esp
	popfl
  80134b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80134c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80134d:	c3                   	ret    
  80134e:	66 90                	xchg   %ax,%ax

00801350 <__udivdi3>:
  801350:	55                   	push   %ebp
  801351:	57                   	push   %edi
  801352:	56                   	push   %esi
  801353:	53                   	push   %ebx
  801354:	83 ec 1c             	sub    $0x1c,%esp
  801357:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80135b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80135f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801363:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801367:	85 d2                	test   %edx,%edx
  801369:	75 4d                	jne    8013b8 <__udivdi3+0x68>
  80136b:	39 f3                	cmp    %esi,%ebx
  80136d:	76 19                	jbe    801388 <__udivdi3+0x38>
  80136f:	31 ff                	xor    %edi,%edi
  801371:	89 e8                	mov    %ebp,%eax
  801373:	89 f2                	mov    %esi,%edx
  801375:	f7 f3                	div    %ebx
  801377:	89 fa                	mov    %edi,%edx
  801379:	83 c4 1c             	add    $0x1c,%esp
  80137c:	5b                   	pop    %ebx
  80137d:	5e                   	pop    %esi
  80137e:	5f                   	pop    %edi
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    
  801381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801388:	89 d9                	mov    %ebx,%ecx
  80138a:	85 db                	test   %ebx,%ebx
  80138c:	75 0b                	jne    801399 <__udivdi3+0x49>
  80138e:	b8 01 00 00 00       	mov    $0x1,%eax
  801393:	31 d2                	xor    %edx,%edx
  801395:	f7 f3                	div    %ebx
  801397:	89 c1                	mov    %eax,%ecx
  801399:	31 d2                	xor    %edx,%edx
  80139b:	89 f0                	mov    %esi,%eax
  80139d:	f7 f1                	div    %ecx
  80139f:	89 c6                	mov    %eax,%esi
  8013a1:	89 e8                	mov    %ebp,%eax
  8013a3:	89 f7                	mov    %esi,%edi
  8013a5:	f7 f1                	div    %ecx
  8013a7:	89 fa                	mov    %edi,%edx
  8013a9:	83 c4 1c             	add    $0x1c,%esp
  8013ac:	5b                   	pop    %ebx
  8013ad:	5e                   	pop    %esi
  8013ae:	5f                   	pop    %edi
  8013af:	5d                   	pop    %ebp
  8013b0:	c3                   	ret    
  8013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013b8:	39 f2                	cmp    %esi,%edx
  8013ba:	77 1c                	ja     8013d8 <__udivdi3+0x88>
  8013bc:	0f bd fa             	bsr    %edx,%edi
  8013bf:	83 f7 1f             	xor    $0x1f,%edi
  8013c2:	75 2c                	jne    8013f0 <__udivdi3+0xa0>
  8013c4:	39 f2                	cmp    %esi,%edx
  8013c6:	72 06                	jb     8013ce <__udivdi3+0x7e>
  8013c8:	31 c0                	xor    %eax,%eax
  8013ca:	39 eb                	cmp    %ebp,%ebx
  8013cc:	77 a9                	ja     801377 <__udivdi3+0x27>
  8013ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8013d3:	eb a2                	jmp    801377 <__udivdi3+0x27>
  8013d5:	8d 76 00             	lea    0x0(%esi),%esi
  8013d8:	31 ff                	xor    %edi,%edi
  8013da:	31 c0                	xor    %eax,%eax
  8013dc:	89 fa                	mov    %edi,%edx
  8013de:	83 c4 1c             	add    $0x1c,%esp
  8013e1:	5b                   	pop    %ebx
  8013e2:	5e                   	pop    %esi
  8013e3:	5f                   	pop    %edi
  8013e4:	5d                   	pop    %ebp
  8013e5:	c3                   	ret    
  8013e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013ed:	8d 76 00             	lea    0x0(%esi),%esi
  8013f0:	89 f9                	mov    %edi,%ecx
  8013f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8013f7:	29 f8                	sub    %edi,%eax
  8013f9:	d3 e2                	shl    %cl,%edx
  8013fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013ff:	89 c1                	mov    %eax,%ecx
  801401:	89 da                	mov    %ebx,%edx
  801403:	d3 ea                	shr    %cl,%edx
  801405:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801409:	09 d1                	or     %edx,%ecx
  80140b:	89 f2                	mov    %esi,%edx
  80140d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801411:	89 f9                	mov    %edi,%ecx
  801413:	d3 e3                	shl    %cl,%ebx
  801415:	89 c1                	mov    %eax,%ecx
  801417:	d3 ea                	shr    %cl,%edx
  801419:	89 f9                	mov    %edi,%ecx
  80141b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80141f:	89 eb                	mov    %ebp,%ebx
  801421:	d3 e6                	shl    %cl,%esi
  801423:	89 c1                	mov    %eax,%ecx
  801425:	d3 eb                	shr    %cl,%ebx
  801427:	09 de                	or     %ebx,%esi
  801429:	89 f0                	mov    %esi,%eax
  80142b:	f7 74 24 08          	divl   0x8(%esp)
  80142f:	89 d6                	mov    %edx,%esi
  801431:	89 c3                	mov    %eax,%ebx
  801433:	f7 64 24 0c          	mull   0xc(%esp)
  801437:	39 d6                	cmp    %edx,%esi
  801439:	72 15                	jb     801450 <__udivdi3+0x100>
  80143b:	89 f9                	mov    %edi,%ecx
  80143d:	d3 e5                	shl    %cl,%ebp
  80143f:	39 c5                	cmp    %eax,%ebp
  801441:	73 04                	jae    801447 <__udivdi3+0xf7>
  801443:	39 d6                	cmp    %edx,%esi
  801445:	74 09                	je     801450 <__udivdi3+0x100>
  801447:	89 d8                	mov    %ebx,%eax
  801449:	31 ff                	xor    %edi,%edi
  80144b:	e9 27 ff ff ff       	jmp    801377 <__udivdi3+0x27>
  801450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801453:	31 ff                	xor    %edi,%edi
  801455:	e9 1d ff ff ff       	jmp    801377 <__udivdi3+0x27>
  80145a:	66 90                	xchg   %ax,%ax
  80145c:	66 90                	xchg   %ax,%ax
  80145e:	66 90                	xchg   %ax,%ax

00801460 <__umoddi3>:
  801460:	55                   	push   %ebp
  801461:	57                   	push   %edi
  801462:	56                   	push   %esi
  801463:	53                   	push   %ebx
  801464:	83 ec 1c             	sub    $0x1c,%esp
  801467:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80146b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80146f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801477:	89 da                	mov    %ebx,%edx
  801479:	85 c0                	test   %eax,%eax
  80147b:	75 43                	jne    8014c0 <__umoddi3+0x60>
  80147d:	39 df                	cmp    %ebx,%edi
  80147f:	76 17                	jbe    801498 <__umoddi3+0x38>
  801481:	89 f0                	mov    %esi,%eax
  801483:	f7 f7                	div    %edi
  801485:	89 d0                	mov    %edx,%eax
  801487:	31 d2                	xor    %edx,%edx
  801489:	83 c4 1c             	add    $0x1c,%esp
  80148c:	5b                   	pop    %ebx
  80148d:	5e                   	pop    %esi
  80148e:	5f                   	pop    %edi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    
  801491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801498:	89 fd                	mov    %edi,%ebp
  80149a:	85 ff                	test   %edi,%edi
  80149c:	75 0b                	jne    8014a9 <__umoddi3+0x49>
  80149e:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a3:	31 d2                	xor    %edx,%edx
  8014a5:	f7 f7                	div    %edi
  8014a7:	89 c5                	mov    %eax,%ebp
  8014a9:	89 d8                	mov    %ebx,%eax
  8014ab:	31 d2                	xor    %edx,%edx
  8014ad:	f7 f5                	div    %ebp
  8014af:	89 f0                	mov    %esi,%eax
  8014b1:	f7 f5                	div    %ebp
  8014b3:	89 d0                	mov    %edx,%eax
  8014b5:	eb d0                	jmp    801487 <__umoddi3+0x27>
  8014b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014be:	66 90                	xchg   %ax,%ax
  8014c0:	89 f1                	mov    %esi,%ecx
  8014c2:	39 d8                	cmp    %ebx,%eax
  8014c4:	76 0a                	jbe    8014d0 <__umoddi3+0x70>
  8014c6:	89 f0                	mov    %esi,%eax
  8014c8:	83 c4 1c             	add    $0x1c,%esp
  8014cb:	5b                   	pop    %ebx
  8014cc:	5e                   	pop    %esi
  8014cd:	5f                   	pop    %edi
  8014ce:	5d                   	pop    %ebp
  8014cf:	c3                   	ret    
  8014d0:	0f bd e8             	bsr    %eax,%ebp
  8014d3:	83 f5 1f             	xor    $0x1f,%ebp
  8014d6:	75 20                	jne    8014f8 <__umoddi3+0x98>
  8014d8:	39 d8                	cmp    %ebx,%eax
  8014da:	0f 82 b0 00 00 00    	jb     801590 <__umoddi3+0x130>
  8014e0:	39 f7                	cmp    %esi,%edi
  8014e2:	0f 86 a8 00 00 00    	jbe    801590 <__umoddi3+0x130>
  8014e8:	89 c8                	mov    %ecx,%eax
  8014ea:	83 c4 1c             	add    $0x1c,%esp
  8014ed:	5b                   	pop    %ebx
  8014ee:	5e                   	pop    %esi
  8014ef:	5f                   	pop    %edi
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    
  8014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8014f8:	89 e9                	mov    %ebp,%ecx
  8014fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8014ff:	29 ea                	sub    %ebp,%edx
  801501:	d3 e0                	shl    %cl,%eax
  801503:	89 44 24 08          	mov    %eax,0x8(%esp)
  801507:	89 d1                	mov    %edx,%ecx
  801509:	89 f8                	mov    %edi,%eax
  80150b:	d3 e8                	shr    %cl,%eax
  80150d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801511:	89 54 24 04          	mov    %edx,0x4(%esp)
  801515:	8b 54 24 04          	mov    0x4(%esp),%edx
  801519:	09 c1                	or     %eax,%ecx
  80151b:	89 d8                	mov    %ebx,%eax
  80151d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801521:	89 e9                	mov    %ebp,%ecx
  801523:	d3 e7                	shl    %cl,%edi
  801525:	89 d1                	mov    %edx,%ecx
  801527:	d3 e8                	shr    %cl,%eax
  801529:	89 e9                	mov    %ebp,%ecx
  80152b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80152f:	d3 e3                	shl    %cl,%ebx
  801531:	89 c7                	mov    %eax,%edi
  801533:	89 d1                	mov    %edx,%ecx
  801535:	89 f0                	mov    %esi,%eax
  801537:	d3 e8                	shr    %cl,%eax
  801539:	89 e9                	mov    %ebp,%ecx
  80153b:	89 fa                	mov    %edi,%edx
  80153d:	d3 e6                	shl    %cl,%esi
  80153f:	09 d8                	or     %ebx,%eax
  801541:	f7 74 24 08          	divl   0x8(%esp)
  801545:	89 d1                	mov    %edx,%ecx
  801547:	89 f3                	mov    %esi,%ebx
  801549:	f7 64 24 0c          	mull   0xc(%esp)
  80154d:	89 c6                	mov    %eax,%esi
  80154f:	89 d7                	mov    %edx,%edi
  801551:	39 d1                	cmp    %edx,%ecx
  801553:	72 06                	jb     80155b <__umoddi3+0xfb>
  801555:	75 10                	jne    801567 <__umoddi3+0x107>
  801557:	39 c3                	cmp    %eax,%ebx
  801559:	73 0c                	jae    801567 <__umoddi3+0x107>
  80155b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80155f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801563:	89 d7                	mov    %edx,%edi
  801565:	89 c6                	mov    %eax,%esi
  801567:	89 ca                	mov    %ecx,%edx
  801569:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80156e:	29 f3                	sub    %esi,%ebx
  801570:	19 fa                	sbb    %edi,%edx
  801572:	89 d0                	mov    %edx,%eax
  801574:	d3 e0                	shl    %cl,%eax
  801576:	89 e9                	mov    %ebp,%ecx
  801578:	d3 eb                	shr    %cl,%ebx
  80157a:	d3 ea                	shr    %cl,%edx
  80157c:	09 d8                	or     %ebx,%eax
  80157e:	83 c4 1c             	add    $0x1c,%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    
  801586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80158d:	8d 76 00             	lea    0x0(%esi),%esi
  801590:	89 da                	mov    %ebx,%edx
  801592:	29 fe                	sub    %edi,%esi
  801594:	19 c2                	sbb    %eax,%edx
  801596:	89 f1                	mov    %esi,%ecx
  801598:	89 c8                	mov    %ecx,%eax
  80159a:	e9 4b ff ff ff       	jmp    8014ea <__umoddi3+0x8a>
