
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 3c 12 00 00       	call   80127d <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 3f 12 00 00       	call   801297 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 04 20 80 00       	mov    0x802004,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 44 0c 00 00       	call   800cb5 <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 f0 16 80 00       	push   $0x8016f0
  800080:	e8 6e 01 00 00       	call   8001f3 <cprintf>
		if (val == 10)
  800085:	a1 04 20 80 00       	mov    0x802004,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a3:	e8 56 12 00 00       	call   8012fe <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000c2:	e8 ee 0b 00 00       	call   800cb5 <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 c0 16 80 00       	push   $0x8016c0
  8000d1:	e8 1d 01 00 00       	call   8001f3 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 d7 0b 00 00       	call   800cb5 <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 da 16 80 00       	push   $0x8016da
  8000e8:	e8 06 01 00 00       	call   8001f3 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 03 12 00 00       	call   8012fe <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010e:	e8 a2 0b 00 00       	call   800cb5 <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80011b:	c1 e0 04             	shl    $0x4,%eax
  80011e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800123:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800128:	85 db                	test   %ebx,%ebx
  80012a:	7e 07                	jle    800133 <libmain+0x30>
		binaryname = argv[0];
  80012c:	8b 06                	mov    (%esi),%eax
  80012e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800133:	83 ec 08             	sub    $0x8,%esp
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	e8 f6 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013d:	e8 0a 00 00 00       	call   80014c <exit>
}
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800152:	6a 00                	push   $0x0
  800154:	e8 1b 0b 00 00       	call   800c74 <sys_env_destroy>
}
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	c9                   	leave  
  80015d:	c3                   	ret    

0080015e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	53                   	push   %ebx
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800168:	8b 13                	mov    (%ebx),%edx
  80016a:	8d 42 01             	lea    0x1(%edx),%eax
  80016d:	89 03                	mov    %eax,(%ebx)
  80016f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800172:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800176:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017b:	74 09                	je     800186 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800184:	c9                   	leave  
  800185:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 ff 00 00 00       	push   $0xff
  80018e:	8d 43 08             	lea    0x8(%ebx),%eax
  800191:	50                   	push   %eax
  800192:	e8 a0 0a 00 00       	call   800c37 <sys_cputs>
		b->idx = 0;
  800197:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	eb db                	jmp    80017d <putch+0x1f>

008001a2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b2:	00 00 00 
	b.cnt = 0;
  8001b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bf:	ff 75 0c             	pushl  0xc(%ebp)
  8001c2:	ff 75 08             	pushl  0x8(%ebp)
  8001c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cb:	50                   	push   %eax
  8001cc:	68 5e 01 80 00       	push   $0x80015e
  8001d1:	e8 4a 01 00 00       	call   800320 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d6:	83 c4 08             	add    $0x8,%esp
  8001d9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001df:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e5:	50                   	push   %eax
  8001e6:	e8 4c 0a 00 00       	call   800c37 <sys_cputs>

	return b.cnt;
}
  8001eb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

008001f3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 08             	pushl  0x8(%ebp)
  800200:	e8 9d ff ff ff       	call   8001a2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	57                   	push   %edi
  80020b:	56                   	push   %esi
  80020c:	53                   	push   %ebx
  80020d:	83 ec 1c             	sub    $0x1c,%esp
  800210:	89 c6                	mov    %eax,%esi
  800212:	89 d7                	mov    %edx,%edi
  800214:	8b 45 08             	mov    0x8(%ebp),%eax
  800217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80021d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800220:	8b 45 10             	mov    0x10(%ebp),%eax
  800223:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800226:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80022a:	74 2c                	je     800258 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800236:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800239:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80023c:	39 c2                	cmp    %eax,%edx
  80023e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800241:	73 43                	jae    800286 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800243:	83 eb 01             	sub    $0x1,%ebx
  800246:	85 db                	test   %ebx,%ebx
  800248:	7e 6c                	jle    8002b6 <printnum+0xaf>
			putch(padc, putdat);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	57                   	push   %edi
  80024e:	ff 75 18             	pushl  0x18(%ebp)
  800251:	ff d6                	call   *%esi
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	eb eb                	jmp    800243 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	6a 20                	push   $0x20
  80025d:	6a 00                	push   $0x0
  80025f:	50                   	push   %eax
  800260:	ff 75 e4             	pushl  -0x1c(%ebp)
  800263:	ff 75 e0             	pushl  -0x20(%ebp)
  800266:	89 fa                	mov    %edi,%edx
  800268:	89 f0                	mov    %esi,%eax
  80026a:	e8 98 ff ff ff       	call   800207 <printnum>
		while (--width > 0)
  80026f:	83 c4 20             	add    $0x20,%esp
  800272:	83 eb 01             	sub    $0x1,%ebx
  800275:	85 db                	test   %ebx,%ebx
  800277:	7e 65                	jle    8002de <printnum+0xd7>
			putch(padc, putdat);
  800279:	83 ec 08             	sub    $0x8,%esp
  80027c:	57                   	push   %edi
  80027d:	6a 20                	push   $0x20
  80027f:	ff d6                	call   *%esi
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	eb ec                	jmp    800272 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 75 18             	pushl  0x18(%ebp)
  80028c:	83 eb 01             	sub    $0x1,%ebx
  80028f:	53                   	push   %ebx
  800290:	50                   	push   %eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	ff 75 dc             	pushl  -0x24(%ebp)
  800297:	ff 75 d8             	pushl  -0x28(%ebp)
  80029a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029d:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a0:	e8 bb 11 00 00       	call   801460 <__udivdi3>
  8002a5:	83 c4 18             	add    $0x18,%esp
  8002a8:	52                   	push   %edx
  8002a9:	50                   	push   %eax
  8002aa:	89 fa                	mov    %edi,%edx
  8002ac:	89 f0                	mov    %esi,%eax
  8002ae:	e8 54 ff ff ff       	call   800207 <printnum>
  8002b3:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	57                   	push   %edi
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c9:	e8 a2 12 00 00       	call   801570 <__umoddi3>
  8002ce:	83 c4 14             	add    $0x14,%esp
  8002d1:	0f be 80 20 17 80 00 	movsbl 0x801720(%eax),%eax
  8002d8:	50                   	push   %eax
  8002d9:	ff d6                	call   *%esi
  8002db:	83 c4 10             	add    $0x10,%esp
}
  8002de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	88 02                	mov    %al,(%edx)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <printfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800309:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030c:	50                   	push   %eax
  80030d:	ff 75 10             	pushl  0x10(%ebp)
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 05 00 00 00       	call   800320 <vprintfmt>
}
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <vprintfmt>:
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 3c             	sub    $0x3c,%esp
  800329:	8b 75 08             	mov    0x8(%ebp),%esi
  80032c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800332:	e9 b4 03 00 00       	jmp    8006eb <vprintfmt+0x3cb>
		padc = ' ';
  800337:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  80033b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800342:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800349:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800350:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800357:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035c:	8d 47 01             	lea    0x1(%edi),%eax
  80035f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800362:	0f b6 17             	movzbl (%edi),%edx
  800365:	8d 42 dd             	lea    -0x23(%edx),%eax
  800368:	3c 55                	cmp    $0x55,%al
  80036a:	0f 87 c8 04 00 00    	ja     800838 <vprintfmt+0x518>
  800370:	0f b6 c0             	movzbl %al,%eax
  800373:	ff 24 85 00 19 80 00 	jmp    *0x801900(,%eax,4)
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80037d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800384:	eb d6                	jmp    80035c <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800386:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800389:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80038d:	eb cd                	jmp    80035c <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	0f b6 d2             	movzbl %dl,%edx
  800392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800395:	b8 00 00 00 00       	mov    $0x0,%eax
  80039a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80039d:	eb 0c                	jmp    8003ab <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003a6:	eb b4                	jmp    80035c <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8003a8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ab:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ae:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b8:	83 f9 09             	cmp    $0x9,%ecx
  8003bb:	76 eb                	jbe    8003a8 <vprintfmt+0x88>
  8003bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c3:	eb 14                	jmp    8003d9 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d0:	8d 40 04             	lea    0x4(%eax),%eax
  8003d3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003dd:	0f 89 79 ff ff ff    	jns    80035c <vprintfmt+0x3c>
				width = precision, precision = -1;
  8003e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003f0:	e9 67 ff ff ff       	jmp    80035c <vprintfmt+0x3c>
  8003f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f8:	85 c0                	test   %eax,%eax
  8003fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ff:	0f 49 d0             	cmovns %eax,%edx
  800402:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800408:	e9 4f ff ff ff       	jmp    80035c <vprintfmt+0x3c>
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800410:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800417:	e9 40 ff ff ff       	jmp    80035c <vprintfmt+0x3c>
			lflag++;
  80041c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80041f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800422:	e9 35 ff ff ff       	jmp    80035c <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8d 78 04             	lea    0x4(%eax),%edi
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	53                   	push   %ebx
  800431:	ff 30                	pushl  (%eax)
  800433:	ff d6                	call   *%esi
			break;
  800435:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800438:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043b:	e9 a8 02 00 00       	jmp    8006e8 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	8d 78 04             	lea    0x4(%eax),%edi
  800446:	8b 00                	mov    (%eax),%eax
  800448:	99                   	cltd   
  800449:	31 d0                	xor    %edx,%eax
  80044b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044d:	83 f8 0f             	cmp    $0xf,%eax
  800450:	7f 23                	jg     800475 <vprintfmt+0x155>
  800452:	8b 14 85 60 1a 80 00 	mov    0x801a60(,%eax,4),%edx
  800459:	85 d2                	test   %edx,%edx
  80045b:	74 18                	je     800475 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80045d:	52                   	push   %edx
  80045e:	68 41 17 80 00       	push   $0x801741
  800463:	53                   	push   %ebx
  800464:	56                   	push   %esi
  800465:	e8 99 fe ff ff       	call   800303 <printfmt>
  80046a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800470:	e9 73 02 00 00       	jmp    8006e8 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800475:	50                   	push   %eax
  800476:	68 38 17 80 00       	push   $0x801738
  80047b:	53                   	push   %ebx
  80047c:	56                   	push   %esi
  80047d:	e8 81 fe ff ff       	call   800303 <printfmt>
  800482:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800485:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800488:	e9 5b 02 00 00       	jmp    8006e8 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80048d:	8b 45 14             	mov    0x14(%ebp),%eax
  800490:	83 c0 04             	add    $0x4,%eax
  800493:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80049b:	85 d2                	test   %edx,%edx
  80049d:	b8 31 17 80 00       	mov    $0x801731,%eax
  8004a2:	0f 45 c2             	cmovne %edx,%eax
  8004a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ac:	7e 06                	jle    8004b4 <vprintfmt+0x194>
  8004ae:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004b2:	75 0d                	jne    8004c1 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b7:	89 c7                	mov    %eax,%edi
  8004b9:	03 45 e0             	add    -0x20(%ebp),%eax
  8004bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bf:	eb 53                	jmp    800514 <vprintfmt+0x1f4>
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c7:	50                   	push   %eax
  8004c8:	e8 13 04 00 00       	call   8008e0 <strnlen>
  8004cd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d0:	29 c1                	sub    %eax,%ecx
  8004d2:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004d5:	83 c4 10             	add    $0x10,%esp
  8004d8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004da:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e1:	eb 0f                	jmp    8004f2 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ea:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ec:	83 ef 01             	sub    $0x1,%edi
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	85 ff                	test   %edi,%edi
  8004f4:	7f ed                	jg     8004e3 <vprintfmt+0x1c3>
  8004f6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f9:	85 d2                	test   %edx,%edx
  8004fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800500:	0f 49 c2             	cmovns %edx,%eax
  800503:	29 c2                	sub    %eax,%edx
  800505:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800508:	eb aa                	jmp    8004b4 <vprintfmt+0x194>
					putch(ch, putdat);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	53                   	push   %ebx
  80050e:	52                   	push   %edx
  80050f:	ff d6                	call   *%esi
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800517:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800519:	83 c7 01             	add    $0x1,%edi
  80051c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800520:	0f be d0             	movsbl %al,%edx
  800523:	85 d2                	test   %edx,%edx
  800525:	74 4b                	je     800572 <vprintfmt+0x252>
  800527:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052b:	78 06                	js     800533 <vprintfmt+0x213>
  80052d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800531:	78 1e                	js     800551 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800533:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800537:	74 d1                	je     80050a <vprintfmt+0x1ea>
  800539:	0f be c0             	movsbl %al,%eax
  80053c:	83 e8 20             	sub    $0x20,%eax
  80053f:	83 f8 5e             	cmp    $0x5e,%eax
  800542:	76 c6                	jbe    80050a <vprintfmt+0x1ea>
					putch('?', putdat);
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	53                   	push   %ebx
  800548:	6a 3f                	push   $0x3f
  80054a:	ff d6                	call   *%esi
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	eb c3                	jmp    800514 <vprintfmt+0x1f4>
  800551:	89 cf                	mov    %ecx,%edi
  800553:	eb 0e                	jmp    800563 <vprintfmt+0x243>
				putch(' ', putdat);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	53                   	push   %ebx
  800559:	6a 20                	push   $0x20
  80055b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055d:	83 ef 01             	sub    $0x1,%edi
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	85 ff                	test   %edi,%edi
  800565:	7f ee                	jg     800555 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800567:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80056a:	89 45 14             	mov    %eax,0x14(%ebp)
  80056d:	e9 76 01 00 00       	jmp    8006e8 <vprintfmt+0x3c8>
  800572:	89 cf                	mov    %ecx,%edi
  800574:	eb ed                	jmp    800563 <vprintfmt+0x243>
	if (lflag >= 2)
  800576:	83 f9 01             	cmp    $0x1,%ecx
  800579:	7f 1f                	jg     80059a <vprintfmt+0x27a>
	else if (lflag)
  80057b:	85 c9                	test   %ecx,%ecx
  80057d:	74 6a                	je     8005e9 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800587:	89 c1                	mov    %eax,%ecx
  800589:	c1 f9 1f             	sar    $0x1f,%ecx
  80058c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 40 04             	lea    0x4(%eax),%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
  800598:	eb 17                	jmp    8005b1 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 50 04             	mov    0x4(%eax),%edx
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 08             	lea    0x8(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005b4:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005b9:	85 d2                	test   %edx,%edx
  8005bb:	0f 89 f8 00 00 00    	jns    8006b9 <vprintfmt+0x399>
				putch('-', putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	53                   	push   %ebx
  8005c5:	6a 2d                	push   $0x2d
  8005c7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005cf:	f7 d8                	neg    %eax
  8005d1:	83 d2 00             	adc    $0x0,%edx
  8005d4:	f7 da                	neg    %edx
  8005d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005dc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005df:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005e4:	e9 e1 00 00 00       	jmp    8006ca <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f1:	99                   	cltd   
  8005f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 40 04             	lea    0x4(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fe:	eb b1                	jmp    8005b1 <vprintfmt+0x291>
	if (lflag >= 2)
  800600:	83 f9 01             	cmp    $0x1,%ecx
  800603:	7f 27                	jg     80062c <vprintfmt+0x30c>
	else if (lflag)
  800605:	85 c9                	test   %ecx,%ecx
  800607:	74 41                	je     80064a <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	ba 00 00 00 00       	mov    $0x0,%edx
  800613:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800616:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8d 40 04             	lea    0x4(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800622:	bf 0a 00 00 00       	mov    $0xa,%edi
  800627:	e9 8d 00 00 00       	jmp    8006b9 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 50 04             	mov    0x4(%eax),%edx
  800632:	8b 00                	mov    (%eax),%eax
  800634:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800637:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8d 40 08             	lea    0x8(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800643:	bf 0a 00 00 00       	mov    $0xa,%edi
  800648:	eb 6f                	jmp    8006b9 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	ba 00 00 00 00       	mov    $0x0,%edx
  800654:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800657:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8d 40 04             	lea    0x4(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800663:	bf 0a 00 00 00       	mov    $0xa,%edi
  800668:	eb 4f                	jmp    8006b9 <vprintfmt+0x399>
	if (lflag >= 2)
  80066a:	83 f9 01             	cmp    $0x1,%ecx
  80066d:	7f 23                	jg     800692 <vprintfmt+0x372>
	else if (lflag)
  80066f:	85 c9                	test   %ecx,%ecx
  800671:	0f 84 98 00 00 00    	je     80070f <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	ba 00 00 00 00       	mov    $0x0,%edx
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 04             	lea    0x4(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
  800690:	eb 17                	jmp    8006a9 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 50 04             	mov    0x4(%eax),%edx
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 08             	lea    0x8(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	53                   	push   %ebx
  8006ad:	6a 30                	push   $0x30
  8006af:	ff d6                	call   *%esi
			goto number;
  8006b1:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006b4:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8006b9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006bd:	74 0b                	je     8006ca <vprintfmt+0x3aa>
				putch('+', putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	53                   	push   %ebx
  8006c3:	6a 2b                	push   $0x2b
  8006c5:	ff d6                	call   *%esi
  8006c7:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006ca:	83 ec 0c             	sub    $0xc,%esp
  8006cd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d1:	50                   	push   %eax
  8006d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d5:	57                   	push   %edi
  8006d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8006d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8006dc:	89 da                	mov    %ebx,%edx
  8006de:	89 f0                	mov    %esi,%eax
  8006e0:	e8 22 fb ff ff       	call   800207 <printnum>
			break;
  8006e5:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8006e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006eb:	83 c7 01             	add    $0x1,%edi
  8006ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f2:	83 f8 25             	cmp    $0x25,%eax
  8006f5:	0f 84 3c fc ff ff    	je     800337 <vprintfmt+0x17>
			if (ch == '\0')
  8006fb:	85 c0                	test   %eax,%eax
  8006fd:	0f 84 55 01 00 00    	je     800858 <vprintfmt+0x538>
			putch(ch, putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	50                   	push   %eax
  800708:	ff d6                	call   *%esi
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	eb dc                	jmp    8006eb <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	ba 00 00 00 00       	mov    $0x0,%edx
  800719:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8d 40 04             	lea    0x4(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
  800728:	e9 7c ff ff ff       	jmp    8006a9 <vprintfmt+0x389>
			putch('0', putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	53                   	push   %ebx
  800731:	6a 30                	push   $0x30
  800733:	ff d6                	call   *%esi
			putch('x', putdat);
  800735:	83 c4 08             	add    $0x8,%esp
  800738:	53                   	push   %ebx
  800739:	6a 78                	push   $0x78
  80073b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
  800747:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80074d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8d 40 04             	lea    0x4(%eax),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800759:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  80075e:	e9 56 ff ff ff       	jmp    8006b9 <vprintfmt+0x399>
	if (lflag >= 2)
  800763:	83 f9 01             	cmp    $0x1,%ecx
  800766:	7f 27                	jg     80078f <vprintfmt+0x46f>
	else if (lflag)
  800768:	85 c9                	test   %ecx,%ecx
  80076a:	74 44                	je     8007b0 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	ba 00 00 00 00       	mov    $0x0,%edx
  800776:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800779:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8d 40 04             	lea    0x4(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800785:	bf 10 00 00 00       	mov    $0x10,%edi
  80078a:	e9 2a ff ff ff       	jmp    8006b9 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 50 04             	mov    0x4(%eax),%edx
  800795:	8b 00                	mov    (%eax),%eax
  800797:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8d 40 08             	lea    0x8(%eax),%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a6:	bf 10 00 00 00       	mov    $0x10,%edi
  8007ab:	e9 09 ff ff ff       	jmp    8006b9 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 40 04             	lea    0x4(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c9:	bf 10 00 00 00       	mov    $0x10,%edi
  8007ce:	e9 e6 fe ff ff       	jmp    8006b9 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8d 78 04             	lea    0x4(%eax),%edi
  8007d9:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8007db:	85 c0                	test   %eax,%eax
  8007dd:	74 2d                	je     80080c <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8007df:	0f b6 13             	movzbl (%ebx),%edx
  8007e2:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007e4:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8007e7:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007ea:	0f 8e f8 fe ff ff    	jle    8006e8 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007f0:	68 90 18 80 00       	push   $0x801890
  8007f5:	68 41 17 80 00       	push   $0x801741
  8007fa:	53                   	push   %ebx
  8007fb:	56                   	push   %esi
  8007fc:	e8 02 fb ff ff       	call   800303 <printfmt>
  800801:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800804:	89 7d 14             	mov    %edi,0x14(%ebp)
  800807:	e9 dc fe ff ff       	jmp    8006e8 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  80080c:	68 58 18 80 00       	push   $0x801858
  800811:	68 41 17 80 00       	push   $0x801741
  800816:	53                   	push   %ebx
  800817:	56                   	push   %esi
  800818:	e8 e6 fa ff ff       	call   800303 <printfmt>
  80081d:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800820:	89 7d 14             	mov    %edi,0x14(%ebp)
  800823:	e9 c0 fe ff ff       	jmp    8006e8 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	53                   	push   %ebx
  80082c:	6a 25                	push   $0x25
  80082e:	ff d6                	call   *%esi
			break;
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	e9 b0 fe ff ff       	jmp    8006e8 <vprintfmt+0x3c8>
			putch('%', putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	53                   	push   %ebx
  80083c:	6a 25                	push   $0x25
  80083e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	89 f8                	mov    %edi,%eax
  800845:	eb 03                	jmp    80084a <vprintfmt+0x52a>
  800847:	83 e8 01             	sub    $0x1,%eax
  80084a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80084e:	75 f7                	jne    800847 <vprintfmt+0x527>
  800850:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800853:	e9 90 fe ff ff       	jmp    8006e8 <vprintfmt+0x3c8>
}
  800858:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80085b:	5b                   	pop    %ebx
  80085c:	5e                   	pop    %esi
  80085d:	5f                   	pop    %edi
  80085e:	5d                   	pop    %ebp
  80085f:	c3                   	ret    

00800860 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	83 ec 18             	sub    $0x18,%esp
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80086c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800873:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800876:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80087d:	85 c0                	test   %eax,%eax
  80087f:	74 26                	je     8008a7 <vsnprintf+0x47>
  800881:	85 d2                	test   %edx,%edx
  800883:	7e 22                	jle    8008a7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800885:	ff 75 14             	pushl  0x14(%ebp)
  800888:	ff 75 10             	pushl  0x10(%ebp)
  80088b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80088e:	50                   	push   %eax
  80088f:	68 e6 02 80 00       	push   $0x8002e6
  800894:	e8 87 fa ff ff       	call   800320 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80089f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
}
  8008a5:	c9                   	leave  
  8008a6:	c3                   	ret    
		return -E_INVAL;
  8008a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ac:	eb f7                	jmp    8008a5 <vsnprintf+0x45>

008008ae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b7:	50                   	push   %eax
  8008b8:	ff 75 10             	pushl  0x10(%ebp)
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	ff 75 08             	pushl  0x8(%ebp)
  8008c1:	e8 9a ff ff ff       	call   800860 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    

008008c8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d7:	74 05                	je     8008de <strlen+0x16>
		n++;
  8008d9:	83 c0 01             	add    $0x1,%eax
  8008dc:	eb f5                	jmp    8008d3 <strlen+0xb>
	return n;
}
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ee:	39 c2                	cmp    %eax,%edx
  8008f0:	74 0d                	je     8008ff <strnlen+0x1f>
  8008f2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008f6:	74 05                	je     8008fd <strnlen+0x1d>
		n++;
  8008f8:	83 c2 01             	add    $0x1,%edx
  8008fb:	eb f1                	jmp    8008ee <strnlen+0xe>
  8008fd:	89 d0                	mov    %edx,%eax
	return n;
}
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	53                   	push   %ebx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80090b:	ba 00 00 00 00       	mov    $0x0,%edx
  800910:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800914:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800917:	83 c2 01             	add    $0x1,%edx
  80091a:	84 c9                	test   %cl,%cl
  80091c:	75 f2                	jne    800910 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80091e:	5b                   	pop    %ebx
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	53                   	push   %ebx
  800925:	83 ec 10             	sub    $0x10,%esp
  800928:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80092b:	53                   	push   %ebx
  80092c:	e8 97 ff ff ff       	call   8008c8 <strlen>
  800931:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	01 d8                	add    %ebx,%eax
  800939:	50                   	push   %eax
  80093a:	e8 c2 ff ff ff       	call   800901 <strcpy>
	return dst;
}
  80093f:	89 d8                	mov    %ebx,%eax
  800941:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800951:	89 c6                	mov    %eax,%esi
  800953:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800956:	89 c2                	mov    %eax,%edx
  800958:	39 f2                	cmp    %esi,%edx
  80095a:	74 11                	je     80096d <strncpy+0x27>
		*dst++ = *src;
  80095c:	83 c2 01             	add    $0x1,%edx
  80095f:	0f b6 19             	movzbl (%ecx),%ebx
  800962:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800965:	80 fb 01             	cmp    $0x1,%bl
  800968:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80096b:	eb eb                	jmp    800958 <strncpy+0x12>
	}
	return ret;
}
  80096d:	5b                   	pop    %ebx
  80096e:	5e                   	pop    %esi
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	56                   	push   %esi
  800975:	53                   	push   %ebx
  800976:	8b 75 08             	mov    0x8(%ebp),%esi
  800979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097c:	8b 55 10             	mov    0x10(%ebp),%edx
  80097f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800981:	85 d2                	test   %edx,%edx
  800983:	74 21                	je     8009a6 <strlcpy+0x35>
  800985:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800989:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80098b:	39 c2                	cmp    %eax,%edx
  80098d:	74 14                	je     8009a3 <strlcpy+0x32>
  80098f:	0f b6 19             	movzbl (%ecx),%ebx
  800992:	84 db                	test   %bl,%bl
  800994:	74 0b                	je     8009a1 <strlcpy+0x30>
			*dst++ = *src++;
  800996:	83 c1 01             	add    $0x1,%ecx
  800999:	83 c2 01             	add    $0x1,%edx
  80099c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80099f:	eb ea                	jmp    80098b <strlcpy+0x1a>
  8009a1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009a3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a6:	29 f0                	sub    %esi,%eax
}
  8009a8:	5b                   	pop    %ebx
  8009a9:	5e                   	pop    %esi
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b5:	0f b6 01             	movzbl (%ecx),%eax
  8009b8:	84 c0                	test   %al,%al
  8009ba:	74 0c                	je     8009c8 <strcmp+0x1c>
  8009bc:	3a 02                	cmp    (%edx),%al
  8009be:	75 08                	jne    8009c8 <strcmp+0x1c>
		p++, q++;
  8009c0:	83 c1 01             	add    $0x1,%ecx
  8009c3:	83 c2 01             	add    $0x1,%edx
  8009c6:	eb ed                	jmp    8009b5 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c8:	0f b6 c0             	movzbl %al,%eax
  8009cb:	0f b6 12             	movzbl (%edx),%edx
  8009ce:	29 d0                	sub    %edx,%eax
}
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 c3                	mov    %eax,%ebx
  8009de:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009e1:	eb 06                	jmp    8009e9 <strncmp+0x17>
		n--, p++, q++;
  8009e3:	83 c0 01             	add    $0x1,%eax
  8009e6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e9:	39 d8                	cmp    %ebx,%eax
  8009eb:	74 16                	je     800a03 <strncmp+0x31>
  8009ed:	0f b6 08             	movzbl (%eax),%ecx
  8009f0:	84 c9                	test   %cl,%cl
  8009f2:	74 04                	je     8009f8 <strncmp+0x26>
  8009f4:	3a 0a                	cmp    (%edx),%cl
  8009f6:	74 eb                	je     8009e3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f8:	0f b6 00             	movzbl (%eax),%eax
  8009fb:	0f b6 12             	movzbl (%edx),%edx
  8009fe:	29 d0                	sub    %edx,%eax
}
  800a00:	5b                   	pop    %ebx
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    
		return 0;
  800a03:	b8 00 00 00 00       	mov    $0x0,%eax
  800a08:	eb f6                	jmp    800a00 <strncmp+0x2e>

00800a0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a14:	0f b6 10             	movzbl (%eax),%edx
  800a17:	84 d2                	test   %dl,%dl
  800a19:	74 09                	je     800a24 <strchr+0x1a>
		if (*s == c)
  800a1b:	38 ca                	cmp    %cl,%dl
  800a1d:	74 0a                	je     800a29 <strchr+0x1f>
	for (; *s; s++)
  800a1f:	83 c0 01             	add    $0x1,%eax
  800a22:	eb f0                	jmp    800a14 <strchr+0xa>
			return (char *) s;
	return 0;
  800a24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a35:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a38:	38 ca                	cmp    %cl,%dl
  800a3a:	74 09                	je     800a45 <strfind+0x1a>
  800a3c:	84 d2                	test   %dl,%dl
  800a3e:	74 05                	je     800a45 <strfind+0x1a>
	for (; *s; s++)
  800a40:	83 c0 01             	add    $0x1,%eax
  800a43:	eb f0                	jmp    800a35 <strfind+0xa>
			break;
	return (char *) s;
}
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	57                   	push   %edi
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a53:	85 c9                	test   %ecx,%ecx
  800a55:	74 31                	je     800a88 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a57:	89 f8                	mov    %edi,%eax
  800a59:	09 c8                	or     %ecx,%eax
  800a5b:	a8 03                	test   $0x3,%al
  800a5d:	75 23                	jne    800a82 <memset+0x3b>
		c &= 0xFF;
  800a5f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a63:	89 d3                	mov    %edx,%ebx
  800a65:	c1 e3 08             	shl    $0x8,%ebx
  800a68:	89 d0                	mov    %edx,%eax
  800a6a:	c1 e0 18             	shl    $0x18,%eax
  800a6d:	89 d6                	mov    %edx,%esi
  800a6f:	c1 e6 10             	shl    $0x10,%esi
  800a72:	09 f0                	or     %esi,%eax
  800a74:	09 c2                	or     %eax,%edx
  800a76:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a78:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a7b:	89 d0                	mov    %edx,%eax
  800a7d:	fc                   	cld    
  800a7e:	f3 ab                	rep stos %eax,%es:(%edi)
  800a80:	eb 06                	jmp    800a88 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	fc                   	cld    
  800a86:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a88:	89 f8                	mov    %edi,%eax
  800a8a:	5b                   	pop    %ebx
  800a8b:	5e                   	pop    %esi
  800a8c:	5f                   	pop    %edi
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	57                   	push   %edi
  800a93:	56                   	push   %esi
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a9d:	39 c6                	cmp    %eax,%esi
  800a9f:	73 32                	jae    800ad3 <memmove+0x44>
  800aa1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aa4:	39 c2                	cmp    %eax,%edx
  800aa6:	76 2b                	jbe    800ad3 <memmove+0x44>
		s += n;
		d += n;
  800aa8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aab:	89 fe                	mov    %edi,%esi
  800aad:	09 ce                	or     %ecx,%esi
  800aaf:	09 d6                	or     %edx,%esi
  800ab1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab7:	75 0e                	jne    800ac7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab9:	83 ef 04             	sub    $0x4,%edi
  800abc:	8d 72 fc             	lea    -0x4(%edx),%esi
  800abf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ac2:	fd                   	std    
  800ac3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac5:	eb 09                	jmp    800ad0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac7:	83 ef 01             	sub    $0x1,%edi
  800aca:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800acd:	fd                   	std    
  800ace:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ad0:	fc                   	cld    
  800ad1:	eb 1a                	jmp    800aed <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad3:	89 c2                	mov    %eax,%edx
  800ad5:	09 ca                	or     %ecx,%edx
  800ad7:	09 f2                	or     %esi,%edx
  800ad9:	f6 c2 03             	test   $0x3,%dl
  800adc:	75 0a                	jne    800ae8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ade:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ae1:	89 c7                	mov    %eax,%edi
  800ae3:	fc                   	cld    
  800ae4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae6:	eb 05                	jmp    800aed <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae8:	89 c7                	mov    %eax,%edi
  800aea:	fc                   	cld    
  800aeb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aed:	5e                   	pop    %esi
  800aee:	5f                   	pop    %edi
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af7:	ff 75 10             	pushl  0x10(%ebp)
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	ff 75 08             	pushl  0x8(%ebp)
  800b00:	e8 8a ff ff ff       	call   800a8f <memmove>
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b12:	89 c6                	mov    %eax,%esi
  800b14:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b17:	39 f0                	cmp    %esi,%eax
  800b19:	74 1c                	je     800b37 <memcmp+0x30>
		if (*s1 != *s2)
  800b1b:	0f b6 08             	movzbl (%eax),%ecx
  800b1e:	0f b6 1a             	movzbl (%edx),%ebx
  800b21:	38 d9                	cmp    %bl,%cl
  800b23:	75 08                	jne    800b2d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b25:	83 c0 01             	add    $0x1,%eax
  800b28:	83 c2 01             	add    $0x1,%edx
  800b2b:	eb ea                	jmp    800b17 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b2d:	0f b6 c1             	movzbl %cl,%eax
  800b30:	0f b6 db             	movzbl %bl,%ebx
  800b33:	29 d8                	sub    %ebx,%eax
  800b35:	eb 05                	jmp    800b3c <memcmp+0x35>
	}

	return 0;
  800b37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b49:	89 c2                	mov    %eax,%edx
  800b4b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b4e:	39 d0                	cmp    %edx,%eax
  800b50:	73 09                	jae    800b5b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b52:	38 08                	cmp    %cl,(%eax)
  800b54:	74 05                	je     800b5b <memfind+0x1b>
	for (; s < ends; s++)
  800b56:	83 c0 01             	add    $0x1,%eax
  800b59:	eb f3                	jmp    800b4e <memfind+0xe>
			break;
	return (void *) s;
}
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	57                   	push   %edi
  800b61:	56                   	push   %esi
  800b62:	53                   	push   %ebx
  800b63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b69:	eb 03                	jmp    800b6e <strtol+0x11>
		s++;
  800b6b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b6e:	0f b6 01             	movzbl (%ecx),%eax
  800b71:	3c 20                	cmp    $0x20,%al
  800b73:	74 f6                	je     800b6b <strtol+0xe>
  800b75:	3c 09                	cmp    $0x9,%al
  800b77:	74 f2                	je     800b6b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b79:	3c 2b                	cmp    $0x2b,%al
  800b7b:	74 2a                	je     800ba7 <strtol+0x4a>
	int neg = 0;
  800b7d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b82:	3c 2d                	cmp    $0x2d,%al
  800b84:	74 2b                	je     800bb1 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b86:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b8c:	75 0f                	jne    800b9d <strtol+0x40>
  800b8e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b91:	74 28                	je     800bbb <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b93:	85 db                	test   %ebx,%ebx
  800b95:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b9a:	0f 44 d8             	cmove  %eax,%ebx
  800b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ba5:	eb 50                	jmp    800bf7 <strtol+0x9a>
		s++;
  800ba7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800baa:	bf 00 00 00 00       	mov    $0x0,%edi
  800baf:	eb d5                	jmp    800b86 <strtol+0x29>
		s++, neg = 1;
  800bb1:	83 c1 01             	add    $0x1,%ecx
  800bb4:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb9:	eb cb                	jmp    800b86 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bbf:	74 0e                	je     800bcf <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bc1:	85 db                	test   %ebx,%ebx
  800bc3:	75 d8                	jne    800b9d <strtol+0x40>
		s++, base = 8;
  800bc5:	83 c1 01             	add    $0x1,%ecx
  800bc8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bcd:	eb ce                	jmp    800b9d <strtol+0x40>
		s += 2, base = 16;
  800bcf:	83 c1 02             	add    $0x2,%ecx
  800bd2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd7:	eb c4                	jmp    800b9d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bdc:	89 f3                	mov    %esi,%ebx
  800bde:	80 fb 19             	cmp    $0x19,%bl
  800be1:	77 29                	ja     800c0c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800be3:	0f be d2             	movsbl %dl,%edx
  800be6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bec:	7d 30                	jge    800c1e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bee:	83 c1 01             	add    $0x1,%ecx
  800bf1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bf5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bf7:	0f b6 11             	movzbl (%ecx),%edx
  800bfa:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bfd:	89 f3                	mov    %esi,%ebx
  800bff:	80 fb 09             	cmp    $0x9,%bl
  800c02:	77 d5                	ja     800bd9 <strtol+0x7c>
			dig = *s - '0';
  800c04:	0f be d2             	movsbl %dl,%edx
  800c07:	83 ea 30             	sub    $0x30,%edx
  800c0a:	eb dd                	jmp    800be9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c0c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c0f:	89 f3                	mov    %esi,%ebx
  800c11:	80 fb 19             	cmp    $0x19,%bl
  800c14:	77 08                	ja     800c1e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c16:	0f be d2             	movsbl %dl,%edx
  800c19:	83 ea 37             	sub    $0x37,%edx
  800c1c:	eb cb                	jmp    800be9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c22:	74 05                	je     800c29 <strtol+0xcc>
		*endptr = (char *) s;
  800c24:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c27:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c29:	89 c2                	mov    %eax,%edx
  800c2b:	f7 da                	neg    %edx
  800c2d:	85 ff                	test   %edi,%edi
  800c2f:	0f 45 c2             	cmovne %edx,%eax
}
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	89 c3                	mov    %eax,%ebx
  800c4a:	89 c7                	mov    %eax,%edi
  800c4c:	89 c6                	mov    %eax,%esi
  800c4e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c60:	b8 01 00 00 00       	mov    $0x1,%eax
  800c65:	89 d1                	mov    %edx,%ecx
  800c67:	89 d3                	mov    %edx,%ebx
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	89 d6                	mov    %edx,%esi
  800c6d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
  800c7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	b8 03 00 00 00       	mov    $0x3,%eax
  800c8a:	89 cb                	mov    %ecx,%ebx
  800c8c:	89 cf                	mov    %ecx,%edi
  800c8e:	89 ce                	mov    %ecx,%esi
  800c90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c92:	85 c0                	test   %eax,%eax
  800c94:	7f 08                	jg     800c9e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9e:	83 ec 0c             	sub    $0xc,%esp
  800ca1:	50                   	push   %eax
  800ca2:	6a 03                	push   $0x3
  800ca4:	68 a0 1a 80 00       	push   $0x801aa0
  800ca9:	6a 33                	push   $0x33
  800cab:	68 bd 1a 80 00       	push   $0x801abd
  800cb0:	e8 d1 06 00 00       	call   801386 <_panic>

00800cb5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc5:	89 d1                	mov    %edx,%ecx
  800cc7:	89 d3                	mov    %edx,%ebx
  800cc9:	89 d7                	mov    %edx,%edi
  800ccb:	89 d6                	mov    %edx,%esi
  800ccd:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_yield>:

void
sys_yield(void)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ce4:	89 d1                	mov    %edx,%ecx
  800ce6:	89 d3                	mov    %edx,%ebx
  800ce8:	89 d7                	mov    %edx,%edi
  800cea:	89 d6                	mov    %edx,%esi
  800cec:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfc:	be 00 00 00 00       	mov    $0x0,%esi
  800d01:	8b 55 08             	mov    0x8(%ebp),%edx
  800d04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d07:	b8 04 00 00 00       	mov    $0x4,%eax
  800d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0f:	89 f7                	mov    %esi,%edi
  800d11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7f 08                	jg     800d1f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	50                   	push   %eax
  800d23:	6a 04                	push   $0x4
  800d25:	68 a0 1a 80 00       	push   $0x801aa0
  800d2a:	6a 33                	push   $0x33
  800d2c:	68 bd 1a 80 00       	push   $0x801abd
  800d31:	e8 50 06 00 00       	call   801386 <_panic>

00800d36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d45:	b8 05 00 00 00       	mov    $0x5,%eax
  800d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d50:	8b 75 18             	mov    0x18(%ebp),%esi
  800d53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7f 08                	jg     800d61 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d65:	6a 05                	push   $0x5
  800d67:	68 a0 1a 80 00       	push   $0x801aa0
  800d6c:	6a 33                	push   $0x33
  800d6e:	68 bd 1a 80 00       	push   $0x801abd
  800d73:	e8 0e 06 00 00       	call   801386 <_panic>

00800d78 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d8c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	89 de                	mov    %ebx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800da7:	6a 06                	push   $0x6
  800da9:	68 a0 1a 80 00       	push   $0x801aa0
  800dae:	6a 33                	push   $0x33
  800db0:	68 bd 1a 80 00       	push   $0x801abd
  800db5:	e8 cc 05 00 00       	call   801386 <_panic>

00800dba <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd0:	89 cb                	mov    %ecx,%ebx
  800dd2:	89 cf                	mov    %ecx,%edi
  800dd4:	89 ce                	mov    %ecx,%esi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 0b                	push   $0xb
  800dea:	68 a0 1a 80 00       	push   $0x801aa0
  800def:	6a 33                	push   $0x33
  800df1:	68 bd 1a 80 00       	push   $0x801abd
  800df6:	e8 8b 05 00 00       	call   801386 <_panic>

00800dfb <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 08                	push   $0x8
  800e2c:	68 a0 1a 80 00       	push   $0x801aa0
  800e31:	6a 33                	push   $0x33
  800e33:	68 bd 1a 80 00       	push   $0x801abd
  800e38:	e8 49 05 00 00       	call   801386 <_panic>

00800e3d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	b8 09 00 00 00       	mov    $0x9,%eax
  800e56:	89 df                	mov    %ebx,%edi
  800e58:	89 de                	mov    %ebx,%esi
  800e5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7f 08                	jg     800e68 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5f                   	pop    %edi
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	50                   	push   %eax
  800e6c:	6a 09                	push   $0x9
  800e6e:	68 a0 1a 80 00       	push   $0x801aa0
  800e73:	6a 33                	push   $0x33
  800e75:	68 bd 1a 80 00       	push   $0x801abd
  800e7a:	e8 07 05 00 00       	call   801386 <_panic>

00800e7f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e93:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e98:	89 df                	mov    %ebx,%edi
  800e9a:	89 de                	mov    %ebx,%esi
  800e9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	7f 08                	jg     800eaa <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eaa:	83 ec 0c             	sub    $0xc,%esp
  800ead:	50                   	push   %eax
  800eae:	6a 0a                	push   $0xa
  800eb0:	68 a0 1a 80 00       	push   $0x801aa0
  800eb5:	6a 33                	push   $0x33
  800eb7:	68 bd 1a 80 00       	push   $0x801abd
  800ebc:	e8 c5 04 00 00       	call   801386 <_panic>

00800ec1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	57                   	push   %edi
  800ec5:	56                   	push   %esi
  800ec6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ed2:	be 00 00 00 00       	mov    $0x0,%esi
  800ed7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eda:	8b 7d 14             	mov    0x14(%ebp),%edi
  800edd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	57                   	push   %edi
  800ee8:	56                   	push   %esi
  800ee9:	53                   	push   %ebx
  800eea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eed:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800efa:	89 cb                	mov    %ecx,%ebx
  800efc:	89 cf                	mov    %ecx,%edi
  800efe:	89 ce                	mov    %ecx,%esi
  800f00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	7f 08                	jg     800f0e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0e:	83 ec 0c             	sub    $0xc,%esp
  800f11:	50                   	push   %eax
  800f12:	6a 0e                	push   $0xe
  800f14:	68 a0 1a 80 00       	push   $0x801aa0
  800f19:	6a 33                	push   $0x33
  800f1b:	68 bd 1a 80 00       	push   $0x801abd
  800f20:	e8 61 04 00 00       	call   801386 <_panic>

00800f25 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f36:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f3b:	89 df                	mov    %ebx,%edi
  800f3d:	89 de                	mov    %ebx,%esi
  800f3f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	b8 10 00 00 00       	mov    $0x10,%eax
  800f59:	89 cb                	mov    %ecx,%ebx
  800f5b:	89 cf                	mov    %ecx,%edi
  800f5d:	89 ce                	mov    %ecx,%esi
  800f5f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	53                   	push   %ebx
  800f6a:	83 ec 04             	sub    $0x4,%esp
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f70:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  800f72:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f76:	0f 84 90 00 00 00    	je     80100c <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  800f7c:	89 d8                	mov    %ebx,%eax
  800f7e:	c1 e8 16             	shr    $0x16,%eax
  800f81:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f88:	a8 01                	test   $0x1,%al
  800f8a:	0f 84 90 00 00 00    	je     801020 <pgfault+0xba>
  800f90:	89 d8                	mov    %ebx,%eax
  800f92:	c1 e8 0c             	shr    $0xc,%eax
  800f95:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f9c:	a9 01 08 00 00       	test   $0x801,%eax
  800fa1:	74 7d                	je     801020 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  800fa3:	83 ec 04             	sub    $0x4,%esp
  800fa6:	6a 07                	push   $0x7
  800fa8:	68 00 f0 7f 00       	push   $0x7ff000
  800fad:	6a 00                	push   $0x0
  800faf:	e8 3f fd ff ff       	call   800cf3 <sys_page_alloc>
  800fb4:	83 c4 10             	add    $0x10,%esp
  800fb7:	85 c0                	test   %eax,%eax
  800fb9:	78 79                	js     801034 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  800fbb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  800fc1:	83 ec 04             	sub    $0x4,%esp
  800fc4:	68 00 10 00 00       	push   $0x1000
  800fc9:	53                   	push   %ebx
  800fca:	68 00 f0 7f 00       	push   $0x7ff000
  800fcf:	e8 bb fa ff ff       	call   800a8f <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  800fd4:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fdb:	53                   	push   %ebx
  800fdc:	6a 00                	push   $0x0
  800fde:	68 00 f0 7f 00       	push   $0x7ff000
  800fe3:	6a 00                	push   $0x0
  800fe5:	e8 4c fd ff ff       	call   800d36 <sys_page_map>
  800fea:	83 c4 20             	add    $0x20,%esp
  800fed:	85 c0                	test   %eax,%eax
  800fef:	78 55                	js     801046 <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  800ff1:	83 ec 08             	sub    $0x8,%esp
  800ff4:	68 00 f0 7f 00       	push   $0x7ff000
  800ff9:	6a 00                	push   $0x0
  800ffb:	e8 78 fd ff ff       	call   800d78 <sys_page_unmap>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	85 c0                	test   %eax,%eax
  801005:	78 51                	js     801058 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  80100c:	83 ec 04             	sub    $0x4,%esp
  80100f:	68 cc 1a 80 00       	push   $0x801acc
  801014:	6a 21                	push   $0x21
  801016:	68 54 1b 80 00       	push   $0x801b54
  80101b:	e8 66 03 00 00       	call   801386 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  801020:	83 ec 04             	sub    $0x4,%esp
  801023:	68 f8 1a 80 00       	push   $0x801af8
  801028:	6a 24                	push   $0x24
  80102a:	68 54 1b 80 00       	push   $0x801b54
  80102f:	e8 52 03 00 00       	call   801386 <_panic>
		panic("sys_page_alloc: %e\n", r);
  801034:	50                   	push   %eax
  801035:	68 5f 1b 80 00       	push   $0x801b5f
  80103a:	6a 2e                	push   $0x2e
  80103c:	68 54 1b 80 00       	push   $0x801b54
  801041:	e8 40 03 00 00       	call   801386 <_panic>
		panic("sys_page_map: %e\n", r);
  801046:	50                   	push   %eax
  801047:	68 73 1b 80 00       	push   $0x801b73
  80104c:	6a 34                	push   $0x34
  80104e:	68 54 1b 80 00       	push   $0x801b54
  801053:	e8 2e 03 00 00       	call   801386 <_panic>
		panic("sys_page_unmap: %e\n", r);
  801058:	50                   	push   %eax
  801059:	68 85 1b 80 00       	push   $0x801b85
  80105e:	6a 37                	push   $0x37
  801060:	68 54 1b 80 00       	push   $0x801b54
  801065:	e8 1c 03 00 00       	call   801386 <_panic>

0080106a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
  801070:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801073:	68 66 0f 80 00       	push   $0x800f66
  801078:	e8 4f 03 00 00       	call   8013cc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80107d:	b8 07 00 00 00       	mov    $0x7,%eax
  801082:	cd 30                	int    $0x30
  801084:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 30                	js     8010be <fork+0x54>
  80108e:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801090:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801095:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801099:	0f 85 a5 00 00 00    	jne    801144 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  80109f:	e8 11 fc ff ff       	call   800cb5 <sys_getenvid>
  8010a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010a9:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8010ac:	c1 e0 04             	shl    $0x4,%eax
  8010af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010b4:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  8010b9:	e9 75 01 00 00       	jmp    801233 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  8010be:	50                   	push   %eax
  8010bf:	68 99 1b 80 00       	push   $0x801b99
  8010c4:	68 83 00 00 00       	push   $0x83
  8010c9:	68 54 1b 80 00       	push   $0x801b54
  8010ce:	e8 b3 02 00 00       	call   801386 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8010d3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010da:	83 ec 0c             	sub    $0xc,%esp
  8010dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8010e2:	50                   	push   %eax
  8010e3:	56                   	push   %esi
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	6a 00                	push   $0x0
  8010e8:	e8 49 fc ff ff       	call   800d36 <sys_page_map>
  8010ed:	83 c4 20             	add    $0x20,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	79 3e                	jns    801132 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8010f4:	50                   	push   %eax
  8010f5:	68 73 1b 80 00       	push   $0x801b73
  8010fa:	6a 50                	push   $0x50
  8010fc:	68 54 1b 80 00       	push   $0x801b54
  801101:	e8 80 02 00 00       	call   801386 <_panic>
			panic("sys_page_map: %e\n", r);
  801106:	50                   	push   %eax
  801107:	68 73 1b 80 00       	push   $0x801b73
  80110c:	6a 54                	push   $0x54
  80110e:	68 54 1b 80 00       	push   $0x801b54
  801113:	e8 6e 02 00 00       	call   801386 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	6a 05                	push   $0x5
  80111d:	56                   	push   %esi
  80111e:	57                   	push   %edi
  80111f:	56                   	push   %esi
  801120:	6a 00                	push   $0x0
  801122:	e8 0f fc ff ff       	call   800d36 <sys_page_map>
  801127:	83 c4 20             	add    $0x20,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	0f 88 ab 00 00 00    	js     8011dd <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801132:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801138:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80113e:	0f 84 ab 00 00 00    	je     8011ef <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  801144:	89 d8                	mov    %ebx,%eax
  801146:	c1 e8 16             	shr    $0x16,%eax
  801149:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801150:	a8 01                	test   $0x1,%al
  801152:	74 de                	je     801132 <fork+0xc8>
  801154:	89 d8                	mov    %ebx,%eax
  801156:	c1 e8 0c             	shr    $0xc,%eax
  801159:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801160:	f6 c2 01             	test   $0x1,%dl
  801163:	74 cd                	je     801132 <fork+0xc8>
  801165:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  80116b:	74 c5                	je     801132 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  80116d:	89 c6                	mov    %eax,%esi
  80116f:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  801172:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801179:	f6 c6 04             	test   $0x4,%dh
  80117c:	0f 85 51 ff ff ff    	jne    8010d3 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  801182:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801189:	a9 02 08 00 00       	test   $0x802,%eax
  80118e:	74 88                	je     801118 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	68 05 08 00 00       	push   $0x805
  801198:	56                   	push   %esi
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	6a 00                	push   $0x0
  80119d:	e8 94 fb ff ff       	call   800d36 <sys_page_map>
  8011a2:	83 c4 20             	add    $0x20,%esp
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	0f 88 59 ff ff ff    	js     801106 <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8011ad:	83 ec 0c             	sub    $0xc,%esp
  8011b0:	68 05 08 00 00       	push   $0x805
  8011b5:	56                   	push   %esi
  8011b6:	6a 00                	push   $0x0
  8011b8:	56                   	push   %esi
  8011b9:	6a 00                	push   $0x0
  8011bb:	e8 76 fb ff ff       	call   800d36 <sys_page_map>
  8011c0:	83 c4 20             	add    $0x20,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	0f 89 67 ff ff ff    	jns    801132 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8011cb:	50                   	push   %eax
  8011cc:	68 73 1b 80 00       	push   $0x801b73
  8011d1:	6a 56                	push   $0x56
  8011d3:	68 54 1b 80 00       	push   $0x801b54
  8011d8:	e8 a9 01 00 00       	call   801386 <_panic>
			panic("sys_page_map: %e\n", r);
  8011dd:	50                   	push   %eax
  8011de:	68 73 1b 80 00       	push   $0x801b73
  8011e3:	6a 5a                	push   $0x5a
  8011e5:	68 54 1b 80 00       	push   $0x801b54
  8011ea:	e8 97 01 00 00       	call   801386 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8011ef:	83 ec 04             	sub    $0x4,%esp
  8011f2:	6a 07                	push   $0x7
  8011f4:	68 00 f0 bf ee       	push   $0xeebff000
  8011f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011fc:	e8 f2 fa ff ff       	call   800cf3 <sys_page_alloc>
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	78 36                	js     80123e <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	68 37 14 80 00       	push   $0x801437
  801210:	ff 75 e4             	pushl  -0x1c(%ebp)
  801213:	e8 67 fc ff ff       	call   800e7f <sys_env_set_pgfault_upcall>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	78 34                	js     801253 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80121f:	83 ec 08             	sub    $0x8,%esp
  801222:	6a 02                	push   $0x2
  801224:	ff 75 e4             	pushl  -0x1c(%ebp)
  801227:	e8 cf fb ff ff       	call   800dfb <sys_env_set_status>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	78 35                	js     801268 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  801233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801239:	5b                   	pop    %ebx
  80123a:	5e                   	pop    %esi
  80123b:	5f                   	pop    %edi
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  80123e:	50                   	push   %eax
  80123f:	68 5f 1b 80 00       	push   $0x801b5f
  801244:	68 95 00 00 00       	push   $0x95
  801249:	68 54 1b 80 00       	push   $0x801b54
  80124e:	e8 33 01 00 00       	call   801386 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801253:	50                   	push   %eax
  801254:	68 34 1b 80 00       	push   $0x801b34
  801259:	68 98 00 00 00       	push   $0x98
  80125e:	68 54 1b 80 00       	push   $0x801b54
  801263:	e8 1e 01 00 00       	call   801386 <_panic>
		panic("sys_env_set_status: %e\n", r);
  801268:	50                   	push   %eax
  801269:	68 a9 1b 80 00       	push   $0x801ba9
  80126e:	68 9b 00 00 00       	push   $0x9b
  801273:	68 54 1b 80 00       	push   $0x801b54
  801278:	e8 09 01 00 00       	call   801386 <_panic>

0080127d <sfork>:

// Challenge!
int
sfork(void)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801283:	68 c1 1b 80 00       	push   $0x801bc1
  801288:	68 a4 00 00 00       	push   $0xa4
  80128d:	68 54 1b 80 00       	push   $0x801b54
  801292:	e8 ef 00 00 00       	call   801386 <_panic>

00801297 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	56                   	push   %esi
  80129b:	53                   	push   %ebx
  80129c:	8b 75 08             	mov    0x8(%ebp),%esi
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  8012a5:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8012a7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8012ac:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	50                   	push   %eax
  8012b3:	e8 2c fc ff ff       	call   800ee4 <sys_ipc_recv>
	if (from_env_store)
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	85 f6                	test   %esi,%esi
  8012bd:	74 14                	je     8012d3 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  8012bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	78 09                	js     8012d1 <ipc_recv+0x3a>
  8012c8:	8b 15 08 20 80 00    	mov    0x802008,%edx
  8012ce:	8b 52 78             	mov    0x78(%edx),%edx
  8012d1:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  8012d3:	85 db                	test   %ebx,%ebx
  8012d5:	74 14                	je     8012eb <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  8012d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	78 09                	js     8012e9 <ipc_recv+0x52>
  8012e0:	8b 15 08 20 80 00    	mov    0x802008,%edx
  8012e6:	8b 52 7c             	mov    0x7c(%edx),%edx
  8012e9:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 08                	js     8012f7 <ipc_recv+0x60>
  8012ef:	a1 08 20 80 00       	mov    0x802008,%eax
  8012f4:	8b 40 74             	mov    0x74(%eax),%eax
}
  8012f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  801307:	85 c0                	test   %eax,%eax
  801309:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80130e:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801311:	ff 75 14             	pushl  0x14(%ebp)
  801314:	50                   	push   %eax
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	ff 75 08             	pushl  0x8(%ebp)
  80131b:	e8 a1 fb ff ff       	call   800ec1 <sys_ipc_try_send>
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	85 c0                	test   %eax,%eax
  801325:	78 02                	js     801329 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  801327:	c9                   	leave  
  801328:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  801329:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80132c:	75 07                	jne    801335 <ipc_send+0x37>
		sys_yield();
  80132e:	e8 a1 f9 ff ff       	call   800cd4 <sys_yield>
}
  801333:	eb f2                	jmp    801327 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  801335:	50                   	push   %eax
  801336:	68 d7 1b 80 00       	push   $0x801bd7
  80133b:	6a 3c                	push   $0x3c
  80133d:	68 eb 1b 80 00       	push   $0x801beb
  801342:	e8 3f 00 00 00       	call   801386 <_panic>

00801347 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80134d:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  801352:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801355:	c1 e0 04             	shl    $0x4,%eax
  801358:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80135d:	8b 40 50             	mov    0x50(%eax),%eax
  801360:	39 c8                	cmp    %ecx,%eax
  801362:	74 12                	je     801376 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801364:	83 c2 01             	add    $0x1,%edx
  801367:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80136d:	75 e3                	jne    801352 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
  801374:	eb 0e                	jmp    801384 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801376:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801379:	c1 e0 04             	shl    $0x4,%eax
  80137c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801381:	8b 40 48             	mov    0x48(%eax),%eax
}
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	56                   	push   %esi
  80138a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80138b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80138e:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801394:	e8 1c f9 ff ff       	call   800cb5 <sys_getenvid>
  801399:	83 ec 0c             	sub    $0xc,%esp
  80139c:	ff 75 0c             	pushl  0xc(%ebp)
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	56                   	push   %esi
  8013a3:	50                   	push   %eax
  8013a4:	68 f8 1b 80 00       	push   $0x801bf8
  8013a9:	e8 45 ee ff ff       	call   8001f3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8013ae:	83 c4 18             	add    $0x18,%esp
  8013b1:	53                   	push   %ebx
  8013b2:	ff 75 10             	pushl  0x10(%ebp)
  8013b5:	e8 e8 ed ff ff       	call   8001a2 <vcprintf>
	cprintf("\n");
  8013ba:	c7 04 24 71 1b 80 00 	movl   $0x801b71,(%esp)
  8013c1:	e8 2d ee ff ff       	call   8001f3 <cprintf>
  8013c6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8013c9:	cc                   	int3   
  8013ca:	eb fd                	jmp    8013c9 <_panic+0x43>

008013cc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8013d2:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  8013d9:	74 0a                	je     8013e5 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	6a 07                	push   $0x7
  8013ea:	68 00 f0 bf ee       	push   $0xeebff000
  8013ef:	6a 00                	push   $0x0
  8013f1:	e8 fd f8 ff ff       	call   800cf3 <sys_page_alloc>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 28                	js     801425 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	68 37 14 80 00       	push   $0x801437
  801405:	6a 00                	push   $0x0
  801407:	e8 73 fa ff ff       	call   800e7f <sys_env_set_pgfault_upcall>
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	79 c8                	jns    8013db <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  801413:	50                   	push   %eax
  801414:	68 34 1b 80 00       	push   $0x801b34
  801419:	6a 23                	push   $0x23
  80141b:	68 34 1c 80 00       	push   $0x801c34
  801420:	e8 61 ff ff ff       	call   801386 <_panic>
			panic("set_pgfault_handler %e\n",r);
  801425:	50                   	push   %eax
  801426:	68 1c 1c 80 00       	push   $0x801c1c
  80142b:	6a 21                	push   $0x21
  80142d:	68 34 1c 80 00       	push   $0x801c34
  801432:	e8 4f ff ff ff       	call   801386 <_panic>

00801437 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801437:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801438:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  80143d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80143f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  801442:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  801446:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80144a:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80144d:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80144f:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801453:	83 c4 08             	add    $0x8,%esp
	popal
  801456:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801457:	83 c4 04             	add    $0x4,%esp
	popfl
  80145a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80145b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80145c:	c3                   	ret    
  80145d:	66 90                	xchg   %ax,%ax
  80145f:	90                   	nop

00801460 <__udivdi3>:
  801460:	55                   	push   %ebp
  801461:	57                   	push   %edi
  801462:	56                   	push   %esi
  801463:	53                   	push   %ebx
  801464:	83 ec 1c             	sub    $0x1c,%esp
  801467:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80146b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80146f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801473:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801477:	85 d2                	test   %edx,%edx
  801479:	75 4d                	jne    8014c8 <__udivdi3+0x68>
  80147b:	39 f3                	cmp    %esi,%ebx
  80147d:	76 19                	jbe    801498 <__udivdi3+0x38>
  80147f:	31 ff                	xor    %edi,%edi
  801481:	89 e8                	mov    %ebp,%eax
  801483:	89 f2                	mov    %esi,%edx
  801485:	f7 f3                	div    %ebx
  801487:	89 fa                	mov    %edi,%edx
  801489:	83 c4 1c             	add    $0x1c,%esp
  80148c:	5b                   	pop    %ebx
  80148d:	5e                   	pop    %esi
  80148e:	5f                   	pop    %edi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    
  801491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801498:	89 d9                	mov    %ebx,%ecx
  80149a:	85 db                	test   %ebx,%ebx
  80149c:	75 0b                	jne    8014a9 <__udivdi3+0x49>
  80149e:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a3:	31 d2                	xor    %edx,%edx
  8014a5:	f7 f3                	div    %ebx
  8014a7:	89 c1                	mov    %eax,%ecx
  8014a9:	31 d2                	xor    %edx,%edx
  8014ab:	89 f0                	mov    %esi,%eax
  8014ad:	f7 f1                	div    %ecx
  8014af:	89 c6                	mov    %eax,%esi
  8014b1:	89 e8                	mov    %ebp,%eax
  8014b3:	89 f7                	mov    %esi,%edi
  8014b5:	f7 f1                	div    %ecx
  8014b7:	89 fa                	mov    %edi,%edx
  8014b9:	83 c4 1c             	add    $0x1c,%esp
  8014bc:	5b                   	pop    %ebx
  8014bd:	5e                   	pop    %esi
  8014be:	5f                   	pop    %edi
  8014bf:	5d                   	pop    %ebp
  8014c0:	c3                   	ret    
  8014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014c8:	39 f2                	cmp    %esi,%edx
  8014ca:	77 1c                	ja     8014e8 <__udivdi3+0x88>
  8014cc:	0f bd fa             	bsr    %edx,%edi
  8014cf:	83 f7 1f             	xor    $0x1f,%edi
  8014d2:	75 2c                	jne    801500 <__udivdi3+0xa0>
  8014d4:	39 f2                	cmp    %esi,%edx
  8014d6:	72 06                	jb     8014de <__udivdi3+0x7e>
  8014d8:	31 c0                	xor    %eax,%eax
  8014da:	39 eb                	cmp    %ebp,%ebx
  8014dc:	77 a9                	ja     801487 <__udivdi3+0x27>
  8014de:	b8 01 00 00 00       	mov    $0x1,%eax
  8014e3:	eb a2                	jmp    801487 <__udivdi3+0x27>
  8014e5:	8d 76 00             	lea    0x0(%esi),%esi
  8014e8:	31 ff                	xor    %edi,%edi
  8014ea:	31 c0                	xor    %eax,%eax
  8014ec:	89 fa                	mov    %edi,%edx
  8014ee:	83 c4 1c             	add    $0x1c,%esp
  8014f1:	5b                   	pop    %ebx
  8014f2:	5e                   	pop    %esi
  8014f3:	5f                   	pop    %edi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    
  8014f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014fd:	8d 76 00             	lea    0x0(%esi),%esi
  801500:	89 f9                	mov    %edi,%ecx
  801502:	b8 20 00 00 00       	mov    $0x20,%eax
  801507:	29 f8                	sub    %edi,%eax
  801509:	d3 e2                	shl    %cl,%edx
  80150b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80150f:	89 c1                	mov    %eax,%ecx
  801511:	89 da                	mov    %ebx,%edx
  801513:	d3 ea                	shr    %cl,%edx
  801515:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801519:	09 d1                	or     %edx,%ecx
  80151b:	89 f2                	mov    %esi,%edx
  80151d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801521:	89 f9                	mov    %edi,%ecx
  801523:	d3 e3                	shl    %cl,%ebx
  801525:	89 c1                	mov    %eax,%ecx
  801527:	d3 ea                	shr    %cl,%edx
  801529:	89 f9                	mov    %edi,%ecx
  80152b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80152f:	89 eb                	mov    %ebp,%ebx
  801531:	d3 e6                	shl    %cl,%esi
  801533:	89 c1                	mov    %eax,%ecx
  801535:	d3 eb                	shr    %cl,%ebx
  801537:	09 de                	or     %ebx,%esi
  801539:	89 f0                	mov    %esi,%eax
  80153b:	f7 74 24 08          	divl   0x8(%esp)
  80153f:	89 d6                	mov    %edx,%esi
  801541:	89 c3                	mov    %eax,%ebx
  801543:	f7 64 24 0c          	mull   0xc(%esp)
  801547:	39 d6                	cmp    %edx,%esi
  801549:	72 15                	jb     801560 <__udivdi3+0x100>
  80154b:	89 f9                	mov    %edi,%ecx
  80154d:	d3 e5                	shl    %cl,%ebp
  80154f:	39 c5                	cmp    %eax,%ebp
  801551:	73 04                	jae    801557 <__udivdi3+0xf7>
  801553:	39 d6                	cmp    %edx,%esi
  801555:	74 09                	je     801560 <__udivdi3+0x100>
  801557:	89 d8                	mov    %ebx,%eax
  801559:	31 ff                	xor    %edi,%edi
  80155b:	e9 27 ff ff ff       	jmp    801487 <__udivdi3+0x27>
  801560:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801563:	31 ff                	xor    %edi,%edi
  801565:	e9 1d ff ff ff       	jmp    801487 <__udivdi3+0x27>
  80156a:	66 90                	xchg   %ax,%ax
  80156c:	66 90                	xchg   %ax,%ax
  80156e:	66 90                	xchg   %ax,%ax

00801570 <__umoddi3>:
  801570:	55                   	push   %ebp
  801571:	57                   	push   %edi
  801572:	56                   	push   %esi
  801573:	53                   	push   %ebx
  801574:	83 ec 1c             	sub    $0x1c,%esp
  801577:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80157b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80157f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801583:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801587:	89 da                	mov    %ebx,%edx
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 43                	jne    8015d0 <__umoddi3+0x60>
  80158d:	39 df                	cmp    %ebx,%edi
  80158f:	76 17                	jbe    8015a8 <__umoddi3+0x38>
  801591:	89 f0                	mov    %esi,%eax
  801593:	f7 f7                	div    %edi
  801595:	89 d0                	mov    %edx,%eax
  801597:	31 d2                	xor    %edx,%edx
  801599:	83 c4 1c             	add    $0x1c,%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	5f                   	pop    %edi
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    
  8015a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015a8:	89 fd                	mov    %edi,%ebp
  8015aa:	85 ff                	test   %edi,%edi
  8015ac:	75 0b                	jne    8015b9 <__umoddi3+0x49>
  8015ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b3:	31 d2                	xor    %edx,%edx
  8015b5:	f7 f7                	div    %edi
  8015b7:	89 c5                	mov    %eax,%ebp
  8015b9:	89 d8                	mov    %ebx,%eax
  8015bb:	31 d2                	xor    %edx,%edx
  8015bd:	f7 f5                	div    %ebp
  8015bf:	89 f0                	mov    %esi,%eax
  8015c1:	f7 f5                	div    %ebp
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	eb d0                	jmp    801597 <__umoddi3+0x27>
  8015c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015ce:	66 90                	xchg   %ax,%ax
  8015d0:	89 f1                	mov    %esi,%ecx
  8015d2:	39 d8                	cmp    %ebx,%eax
  8015d4:	76 0a                	jbe    8015e0 <__umoddi3+0x70>
  8015d6:	89 f0                	mov    %esi,%eax
  8015d8:	83 c4 1c             	add    $0x1c,%esp
  8015db:	5b                   	pop    %ebx
  8015dc:	5e                   	pop    %esi
  8015dd:	5f                   	pop    %edi
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    
  8015e0:	0f bd e8             	bsr    %eax,%ebp
  8015e3:	83 f5 1f             	xor    $0x1f,%ebp
  8015e6:	75 20                	jne    801608 <__umoddi3+0x98>
  8015e8:	39 d8                	cmp    %ebx,%eax
  8015ea:	0f 82 b0 00 00 00    	jb     8016a0 <__umoddi3+0x130>
  8015f0:	39 f7                	cmp    %esi,%edi
  8015f2:	0f 86 a8 00 00 00    	jbe    8016a0 <__umoddi3+0x130>
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	83 c4 1c             	add    $0x1c,%esp
  8015fd:	5b                   	pop    %ebx
  8015fe:	5e                   	pop    %esi
  8015ff:	5f                   	pop    %edi
  801600:	5d                   	pop    %ebp
  801601:	c3                   	ret    
  801602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801608:	89 e9                	mov    %ebp,%ecx
  80160a:	ba 20 00 00 00       	mov    $0x20,%edx
  80160f:	29 ea                	sub    %ebp,%edx
  801611:	d3 e0                	shl    %cl,%eax
  801613:	89 44 24 08          	mov    %eax,0x8(%esp)
  801617:	89 d1                	mov    %edx,%ecx
  801619:	89 f8                	mov    %edi,%eax
  80161b:	d3 e8                	shr    %cl,%eax
  80161d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801621:	89 54 24 04          	mov    %edx,0x4(%esp)
  801625:	8b 54 24 04          	mov    0x4(%esp),%edx
  801629:	09 c1                	or     %eax,%ecx
  80162b:	89 d8                	mov    %ebx,%eax
  80162d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801631:	89 e9                	mov    %ebp,%ecx
  801633:	d3 e7                	shl    %cl,%edi
  801635:	89 d1                	mov    %edx,%ecx
  801637:	d3 e8                	shr    %cl,%eax
  801639:	89 e9                	mov    %ebp,%ecx
  80163b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80163f:	d3 e3                	shl    %cl,%ebx
  801641:	89 c7                	mov    %eax,%edi
  801643:	89 d1                	mov    %edx,%ecx
  801645:	89 f0                	mov    %esi,%eax
  801647:	d3 e8                	shr    %cl,%eax
  801649:	89 e9                	mov    %ebp,%ecx
  80164b:	89 fa                	mov    %edi,%edx
  80164d:	d3 e6                	shl    %cl,%esi
  80164f:	09 d8                	or     %ebx,%eax
  801651:	f7 74 24 08          	divl   0x8(%esp)
  801655:	89 d1                	mov    %edx,%ecx
  801657:	89 f3                	mov    %esi,%ebx
  801659:	f7 64 24 0c          	mull   0xc(%esp)
  80165d:	89 c6                	mov    %eax,%esi
  80165f:	89 d7                	mov    %edx,%edi
  801661:	39 d1                	cmp    %edx,%ecx
  801663:	72 06                	jb     80166b <__umoddi3+0xfb>
  801665:	75 10                	jne    801677 <__umoddi3+0x107>
  801667:	39 c3                	cmp    %eax,%ebx
  801669:	73 0c                	jae    801677 <__umoddi3+0x107>
  80166b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80166f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801673:	89 d7                	mov    %edx,%edi
  801675:	89 c6                	mov    %eax,%esi
  801677:	89 ca                	mov    %ecx,%edx
  801679:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80167e:	29 f3                	sub    %esi,%ebx
  801680:	19 fa                	sbb    %edi,%edx
  801682:	89 d0                	mov    %edx,%eax
  801684:	d3 e0                	shl    %cl,%eax
  801686:	89 e9                	mov    %ebp,%ecx
  801688:	d3 eb                	shr    %cl,%ebx
  80168a:	d3 ea                	shr    %cl,%edx
  80168c:	09 d8                	or     %ebx,%eax
  80168e:	83 c4 1c             	add    $0x1c,%esp
  801691:	5b                   	pop    %ebx
  801692:	5e                   	pop    %esi
  801693:	5f                   	pop    %edi
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    
  801696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80169d:	8d 76 00             	lea    0x0(%esi),%esi
  8016a0:	89 da                	mov    %ebx,%edx
  8016a2:	29 fe                	sub    %edi,%esi
  8016a4:	19 c2                	sbb    %eax,%edx
  8016a6:	89 f1                	mov    %esi,%ecx
  8016a8:	89 c8                	mov    %ecx,%eax
  8016aa:	e9 4b ff ff ff       	jmp    8015fa <__umoddi3+0x8a>
