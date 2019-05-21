
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 e0 11 80 00       	push   $0x8011e0
  80003e:	e8 cf 01 00 00       	call   800212 <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 20 80 00 	cmpl   $0x0,0x802020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 20 80 00 	mov    %eax,0x802020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 20 80 00 	cmp    %eax,0x802020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 28 12 80 00       	push   $0x801228
  800095:	e8 78 01 00 00       	call   800212 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 87 12 80 00       	push   $0x801287
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 78 12 80 00       	push   $0x801278
  8000b3:	e8 7f 00 00 00       	call   800137 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 5b 12 80 00       	push   $0x80125b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 78 12 80 00       	push   $0x801278
  8000c5:	e8 6d 00 00 00       	call   800137 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 00 12 80 00       	push   $0x801200
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 78 12 80 00       	push   $0x801278
  8000d7:	e8 5b 00 00 00       	call   800137 <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e7:	e8 e8 0b 00 00       	call   800cd4 <sys_getenvid>
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000f4:	c1 e0 04             	shl    $0x4,%eax
  8000f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fc:	a3 20 20 c0 00       	mov    %eax,0xc02020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800101:	85 db                	test   %ebx,%ebx
  800103:	7e 07                	jle    80010c <libmain+0x30>
		binaryname = argv[0];
  800105:	8b 06                	mov    (%esi),%eax
  800107:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
  800111:	e8 1d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800116:	e8 0a 00 00 00       	call   800125 <exit>
}
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  80012b:	6a 00                	push   $0x0
  80012d:	e8 61 0b 00 00       	call   800c93 <sys_env_destroy>
}
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	c9                   	leave  
  800136:	c3                   	ret    

00800137 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80013c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80013f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800145:	e8 8a 0b 00 00       	call   800cd4 <sys_getenvid>
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	ff 75 0c             	pushl  0xc(%ebp)
  800150:	ff 75 08             	pushl  0x8(%ebp)
  800153:	56                   	push   %esi
  800154:	50                   	push   %eax
  800155:	68 a8 12 80 00       	push   $0x8012a8
  80015a:	e8 b3 00 00 00       	call   800212 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80015f:	83 c4 18             	add    $0x18,%esp
  800162:	53                   	push   %ebx
  800163:	ff 75 10             	pushl  0x10(%ebp)
  800166:	e8 56 00 00 00       	call   8001c1 <vcprintf>
	cprintf("\n");
  80016b:	c7 04 24 76 12 80 00 	movl   $0x801276,(%esp)
  800172:	e8 9b 00 00 00       	call   800212 <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80017a:	cc                   	int3   
  80017b:	eb fd                	jmp    80017a <_panic+0x43>

0080017d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	53                   	push   %ebx
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800187:	8b 13                	mov    (%ebx),%edx
  800189:	8d 42 01             	lea    0x1(%edx),%eax
  80018c:	89 03                	mov    %eax,(%ebx)
  80018e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800191:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800195:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019a:	74 09                	je     8001a5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80019c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001a5:	83 ec 08             	sub    $0x8,%esp
  8001a8:	68 ff 00 00 00       	push   $0xff
  8001ad:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 a0 0a 00 00       	call   800c56 <sys_cputs>
		b->idx = 0;
  8001b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	eb db                	jmp    80019c <putch+0x1f>

008001c1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d1:	00 00 00 
	b.cnt = 0;
  8001d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001db:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001de:	ff 75 0c             	pushl  0xc(%ebp)
  8001e1:	ff 75 08             	pushl  0x8(%ebp)
  8001e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	68 7d 01 80 00       	push   $0x80017d
  8001f0:	e8 4a 01 00 00       	call   80033f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f5:	83 c4 08             	add    $0x8,%esp
  8001f8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001fe:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	e8 4c 0a 00 00       	call   800c56 <sys_cputs>

	return b.cnt;
}
  80020a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800218:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80021b:	50                   	push   %eax
  80021c:	ff 75 08             	pushl  0x8(%ebp)
  80021f:	e8 9d ff ff ff       	call   8001c1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800224:	c9                   	leave  
  800225:	c3                   	ret    

00800226 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	57                   	push   %edi
  80022a:	56                   	push   %esi
  80022b:	53                   	push   %ebx
  80022c:	83 ec 1c             	sub    $0x1c,%esp
  80022f:	89 c6                	mov    %eax,%esi
  800231:	89 d7                	mov    %edx,%edi
  800233:	8b 45 08             	mov    0x8(%ebp),%eax
  800236:	8b 55 0c             	mov    0xc(%ebp),%edx
  800239:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80023c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80023f:	8b 45 10             	mov    0x10(%ebp),%eax
  800242:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800245:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800249:	74 2c                	je     800277 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80024b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800255:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800258:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80025b:	39 c2                	cmp    %eax,%edx
  80025d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800260:	73 43                	jae    8002a5 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800262:	83 eb 01             	sub    $0x1,%ebx
  800265:	85 db                	test   %ebx,%ebx
  800267:	7e 6c                	jle    8002d5 <printnum+0xaf>
			putch(padc, putdat);
  800269:	83 ec 08             	sub    $0x8,%esp
  80026c:	57                   	push   %edi
  80026d:	ff 75 18             	pushl  0x18(%ebp)
  800270:	ff d6                	call   *%esi
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	eb eb                	jmp    800262 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	6a 20                	push   $0x20
  80027c:	6a 00                	push   $0x0
  80027e:	50                   	push   %eax
  80027f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800282:	ff 75 e0             	pushl  -0x20(%ebp)
  800285:	89 fa                	mov    %edi,%edx
  800287:	89 f0                	mov    %esi,%eax
  800289:	e8 98 ff ff ff       	call   800226 <printnum>
		while (--width > 0)
  80028e:	83 c4 20             	add    $0x20,%esp
  800291:	83 eb 01             	sub    $0x1,%ebx
  800294:	85 db                	test   %ebx,%ebx
  800296:	7e 65                	jle    8002fd <printnum+0xd7>
			putch(padc, putdat);
  800298:	83 ec 08             	sub    $0x8,%esp
  80029b:	57                   	push   %edi
  80029c:	6a 20                	push   $0x20
  80029e:	ff d6                	call   *%esi
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	eb ec                	jmp    800291 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	ff 75 18             	pushl  0x18(%ebp)
  8002ab:	83 eb 01             	sub    $0x1,%ebx
  8002ae:	53                   	push   %ebx
  8002af:	50                   	push   %eax
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bf:	e8 cc 0c 00 00       	call   800f90 <__udivdi3>
  8002c4:	83 c4 18             	add    $0x18,%esp
  8002c7:	52                   	push   %edx
  8002c8:	50                   	push   %eax
  8002c9:	89 fa                	mov    %edi,%edx
  8002cb:	89 f0                	mov    %esi,%eax
  8002cd:	e8 54 ff ff ff       	call   800226 <printnum>
  8002d2:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	57                   	push   %edi
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e8:	e8 b3 0d 00 00       	call   8010a0 <__umoddi3>
  8002ed:	83 c4 14             	add    $0x14,%esp
  8002f0:	0f be 80 cb 12 80 00 	movsbl 0x8012cb(%eax),%eax
  8002f7:	50                   	push   %eax
  8002f8:	ff d6                	call   *%esi
  8002fa:	83 c4 10             	add    $0x10,%esp
}
  8002fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80030b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80030f:	8b 10                	mov    (%eax),%edx
  800311:	3b 50 04             	cmp    0x4(%eax),%edx
  800314:	73 0a                	jae    800320 <sprintputch+0x1b>
		*b->buf++ = ch;
  800316:	8d 4a 01             	lea    0x1(%edx),%ecx
  800319:	89 08                	mov    %ecx,(%eax)
  80031b:	8b 45 08             	mov    0x8(%ebp),%eax
  80031e:	88 02                	mov    %al,(%edx)
}
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <printfmt>:
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800328:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80032b:	50                   	push   %eax
  80032c:	ff 75 10             	pushl  0x10(%ebp)
  80032f:	ff 75 0c             	pushl  0xc(%ebp)
  800332:	ff 75 08             	pushl  0x8(%ebp)
  800335:	e8 05 00 00 00       	call   80033f <vprintfmt>
}
  80033a:	83 c4 10             	add    $0x10,%esp
  80033d:	c9                   	leave  
  80033e:	c3                   	ret    

0080033f <vprintfmt>:
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	57                   	push   %edi
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
  800345:	83 ec 3c             	sub    $0x3c,%esp
  800348:	8b 75 08             	mov    0x8(%ebp),%esi
  80034b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80034e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800351:	e9 b4 03 00 00       	jmp    80070a <vprintfmt+0x3cb>
		padc = ' ';
  800356:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  80035a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800361:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800368:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80036f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800376:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037b:	8d 47 01             	lea    0x1(%edi),%eax
  80037e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800381:	0f b6 17             	movzbl (%edi),%edx
  800384:	8d 42 dd             	lea    -0x23(%edx),%eax
  800387:	3c 55                	cmp    $0x55,%al
  800389:	0f 87 c8 04 00 00    	ja     800857 <vprintfmt+0x518>
  80038f:	0f b6 c0             	movzbl %al,%eax
  800392:	ff 24 85 a0 14 80 00 	jmp    *0x8014a0(,%eax,4)
  800399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80039c:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8003a3:	eb d6                	jmp    80037b <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003ac:	eb cd                	jmp    80037b <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	0f b6 d2             	movzbl %dl,%edx
  8003b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8003bc:	eb 0c                	jmp    8003ca <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c1:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003c5:	eb b4                	jmp    80037b <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8003c7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ca:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003cd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003d1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003d4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003d7:	83 f9 09             	cmp    $0x9,%ecx
  8003da:	76 eb                	jbe    8003c7 <vprintfmt+0x88>
  8003dc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e2:	eb 14                	jmp    8003f8 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8003e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ef:	8d 40 04             	lea    0x4(%eax),%eax
  8003f2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fc:	0f 89 79 ff ff ff    	jns    80037b <vprintfmt+0x3c>
				width = precision, precision = -1;
  800402:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800405:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800408:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80040f:	e9 67 ff ff ff       	jmp    80037b <vprintfmt+0x3c>
  800414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800417:	85 c0                	test   %eax,%eax
  800419:	ba 00 00 00 00       	mov    $0x0,%edx
  80041e:	0f 49 d0             	cmovns %eax,%edx
  800421:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800424:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800427:	e9 4f ff ff ff       	jmp    80037b <vprintfmt+0x3c>
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80042f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800436:	e9 40 ff ff ff       	jmp    80037b <vprintfmt+0x3c>
			lflag++;
  80043b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800441:	e9 35 ff ff ff       	jmp    80037b <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800446:	8b 45 14             	mov    0x14(%ebp),%eax
  800449:	8d 78 04             	lea    0x4(%eax),%edi
  80044c:	83 ec 08             	sub    $0x8,%esp
  80044f:	53                   	push   %ebx
  800450:	ff 30                	pushl  (%eax)
  800452:	ff d6                	call   *%esi
			break;
  800454:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800457:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80045a:	e9 a8 02 00 00       	jmp    800707 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	8d 78 04             	lea    0x4(%eax),%edi
  800465:	8b 00                	mov    (%eax),%eax
  800467:	99                   	cltd   
  800468:	31 d0                	xor    %edx,%eax
  80046a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80046c:	83 f8 0f             	cmp    $0xf,%eax
  80046f:	7f 23                	jg     800494 <vprintfmt+0x155>
  800471:	8b 14 85 00 16 80 00 	mov    0x801600(,%eax,4),%edx
  800478:	85 d2                	test   %edx,%edx
  80047a:	74 18                	je     800494 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80047c:	52                   	push   %edx
  80047d:	68 ec 12 80 00       	push   $0x8012ec
  800482:	53                   	push   %ebx
  800483:	56                   	push   %esi
  800484:	e8 99 fe ff ff       	call   800322 <printfmt>
  800489:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80048c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80048f:	e9 73 02 00 00       	jmp    800707 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800494:	50                   	push   %eax
  800495:	68 e3 12 80 00       	push   $0x8012e3
  80049a:	53                   	push   %ebx
  80049b:	56                   	push   %esi
  80049c:	e8 81 fe ff ff       	call   800322 <printfmt>
  8004a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a7:	e9 5b 02 00 00       	jmp    800707 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	83 c0 04             	add    $0x4,%eax
  8004b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004ba:	85 d2                	test   %edx,%edx
  8004bc:	b8 dc 12 80 00       	mov    $0x8012dc,%eax
  8004c1:	0f 45 c2             	cmovne %edx,%eax
  8004c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cb:	7e 06                	jle    8004d3 <vprintfmt+0x194>
  8004cd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004d1:	75 0d                	jne    8004e0 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d6:	89 c7                	mov    %eax,%edi
  8004d8:	03 45 e0             	add    -0x20(%ebp),%eax
  8004db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004de:	eb 53                	jmp    800533 <vprintfmt+0x1f4>
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	e8 13 04 00 00       	call   8008ff <strnlen>
  8004ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ef:	29 c1                	sub    %eax,%ecx
  8004f1:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004f4:	83 c4 10             	add    $0x10,%esp
  8004f7:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004f9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800500:	eb 0f                	jmp    800511 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	ff 75 e0             	pushl  -0x20(%ebp)
  800509:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	83 ef 01             	sub    $0x1,%edi
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	85 ff                	test   %edi,%edi
  800513:	7f ed                	jg     800502 <vprintfmt+0x1c3>
  800515:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800518:	85 d2                	test   %edx,%edx
  80051a:	b8 00 00 00 00       	mov    $0x0,%eax
  80051f:	0f 49 c2             	cmovns %edx,%eax
  800522:	29 c2                	sub    %eax,%edx
  800524:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800527:	eb aa                	jmp    8004d3 <vprintfmt+0x194>
					putch(ch, putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	53                   	push   %ebx
  80052d:	52                   	push   %edx
  80052e:	ff d6                	call   *%esi
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800536:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800538:	83 c7 01             	add    $0x1,%edi
  80053b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053f:	0f be d0             	movsbl %al,%edx
  800542:	85 d2                	test   %edx,%edx
  800544:	74 4b                	je     800591 <vprintfmt+0x252>
  800546:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054a:	78 06                	js     800552 <vprintfmt+0x213>
  80054c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800550:	78 1e                	js     800570 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800552:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800556:	74 d1                	je     800529 <vprintfmt+0x1ea>
  800558:	0f be c0             	movsbl %al,%eax
  80055b:	83 e8 20             	sub    $0x20,%eax
  80055e:	83 f8 5e             	cmp    $0x5e,%eax
  800561:	76 c6                	jbe    800529 <vprintfmt+0x1ea>
					putch('?', putdat);
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	53                   	push   %ebx
  800567:	6a 3f                	push   $0x3f
  800569:	ff d6                	call   *%esi
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	eb c3                	jmp    800533 <vprintfmt+0x1f4>
  800570:	89 cf                	mov    %ecx,%edi
  800572:	eb 0e                	jmp    800582 <vprintfmt+0x243>
				putch(' ', putdat);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	53                   	push   %ebx
  800578:	6a 20                	push   $0x20
  80057a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80057c:	83 ef 01             	sub    $0x1,%edi
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	85 ff                	test   %edi,%edi
  800584:	7f ee                	jg     800574 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800586:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
  80058c:	e9 76 01 00 00       	jmp    800707 <vprintfmt+0x3c8>
  800591:	89 cf                	mov    %ecx,%edi
  800593:	eb ed                	jmp    800582 <vprintfmt+0x243>
	if (lflag >= 2)
  800595:	83 f9 01             	cmp    $0x1,%ecx
  800598:	7f 1f                	jg     8005b9 <vprintfmt+0x27a>
	else if (lflag)
  80059a:	85 c9                	test   %ecx,%ecx
  80059c:	74 6a                	je     800608 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a6:	89 c1                	mov    %eax,%ecx
  8005a8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ab:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b7:	eb 17                	jmp    8005d0 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8b 50 04             	mov    0x4(%eax),%edx
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 08             	lea    0x8(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005d3:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005d8:	85 d2                	test   %edx,%edx
  8005da:	0f 89 f8 00 00 00    	jns    8006d8 <vprintfmt+0x399>
				putch('-', putdat);
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	53                   	push   %ebx
  8005e4:	6a 2d                	push   $0x2d
  8005e6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005ee:	f7 d8                	neg    %eax
  8005f0:	83 d2 00             	adc    $0x0,%edx
  8005f3:	f7 da                	neg    %edx
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005fe:	bf 0a 00 00 00       	mov    $0xa,%edi
  800603:	e9 e1 00 00 00       	jmp    8006e9 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800610:	99                   	cltd   
  800611:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 40 04             	lea    0x4(%eax),%eax
  80061a:	89 45 14             	mov    %eax,0x14(%ebp)
  80061d:	eb b1                	jmp    8005d0 <vprintfmt+0x291>
	if (lflag >= 2)
  80061f:	83 f9 01             	cmp    $0x1,%ecx
  800622:	7f 27                	jg     80064b <vprintfmt+0x30c>
	else if (lflag)
  800624:	85 c9                	test   %ecx,%ecx
  800626:	74 41                	je     800669 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800635:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 04             	lea    0x4(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800641:	bf 0a 00 00 00       	mov    $0xa,%edi
  800646:	e9 8d 00 00 00       	jmp    8006d8 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 50 04             	mov    0x4(%eax),%edx
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800656:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 40 08             	lea    0x8(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800662:	bf 0a 00 00 00       	mov    $0xa,%edi
  800667:	eb 6f                	jmp    8006d8 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
  800673:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800676:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8d 40 04             	lea    0x4(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800682:	bf 0a 00 00 00       	mov    $0xa,%edi
  800687:	eb 4f                	jmp    8006d8 <vprintfmt+0x399>
	if (lflag >= 2)
  800689:	83 f9 01             	cmp    $0x1,%ecx
  80068c:	7f 23                	jg     8006b1 <vprintfmt+0x372>
	else if (lflag)
  80068e:	85 c9                	test   %ecx,%ecx
  800690:	0f 84 98 00 00 00    	je     80072e <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8006af:	eb 17                	jmp    8006c8 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 08             	lea    0x8(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	6a 30                	push   $0x30
  8006ce:	ff d6                	call   *%esi
			goto number;
  8006d0:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006d3:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8006d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006dc:	74 0b                	je     8006e9 <vprintfmt+0x3aa>
				putch('+', putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	53                   	push   %ebx
  8006e2:	6a 2b                	push   $0x2b
  8006e4:	ff d6                	call   *%esi
  8006e6:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006e9:	83 ec 0c             	sub    $0xc,%esp
  8006ec:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f4:	57                   	push   %edi
  8006f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8006f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fb:	89 da                	mov    %ebx,%edx
  8006fd:	89 f0                	mov    %esi,%eax
  8006ff:	e8 22 fb ff ff       	call   800226 <printnum>
			break;
  800704:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800707:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	83 c7 01             	add    $0x1,%edi
  80070d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800711:	83 f8 25             	cmp    $0x25,%eax
  800714:	0f 84 3c fc ff ff    	je     800356 <vprintfmt+0x17>
			if (ch == '\0')
  80071a:	85 c0                	test   %eax,%eax
  80071c:	0f 84 55 01 00 00    	je     800877 <vprintfmt+0x538>
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	53                   	push   %ebx
  800726:	50                   	push   %eax
  800727:	ff d6                	call   *%esi
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	eb dc                	jmp    80070a <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	ba 00 00 00 00       	mov    $0x0,%edx
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
  800747:	e9 7c ff ff ff       	jmp    8006c8 <vprintfmt+0x389>
			putch('0', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	53                   	push   %ebx
  800750:	6a 30                	push   $0x30
  800752:	ff d6                	call   *%esi
			putch('x', putdat);
  800754:	83 c4 08             	add    $0x8,%esp
  800757:	53                   	push   %ebx
  800758:	6a 78                	push   $0x78
  80075a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	ba 00 00 00 00       	mov    $0x0,%edx
  800766:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800769:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80076c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 40 04             	lea    0x4(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800778:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  80077d:	e9 56 ff ff ff       	jmp    8006d8 <vprintfmt+0x399>
	if (lflag >= 2)
  800782:	83 f9 01             	cmp    $0x1,%ecx
  800785:	7f 27                	jg     8007ae <vprintfmt+0x46f>
	else if (lflag)
  800787:	85 c9                	test   %ecx,%ecx
  800789:	74 44                	je     8007cf <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	ba 00 00 00 00       	mov    $0x0,%edx
  800795:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800798:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8d 40 04             	lea    0x4(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a4:	bf 10 00 00 00       	mov    $0x10,%edi
  8007a9:	e9 2a ff ff ff       	jmp    8006d8 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8b 50 04             	mov    0x4(%eax),%edx
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8d 40 08             	lea    0x8(%eax),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c5:	bf 10 00 00 00       	mov    $0x10,%edi
  8007ca:	e9 09 ff ff ff       	jmp    8006d8 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8d 40 04             	lea    0x4(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e8:	bf 10 00 00 00       	mov    $0x10,%edi
  8007ed:	e9 e6 fe ff ff       	jmp    8006d8 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8d 78 04             	lea    0x4(%eax),%edi
  8007f8:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8007fa:	85 c0                	test   %eax,%eax
  8007fc:	74 2d                	je     80082b <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8007fe:	0f b6 13             	movzbl (%ebx),%edx
  800801:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800803:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800806:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800809:	0f 8e f8 fe ff ff    	jle    800707 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80080f:	68 3c 14 80 00       	push   $0x80143c
  800814:	68 ec 12 80 00       	push   $0x8012ec
  800819:	53                   	push   %ebx
  80081a:	56                   	push   %esi
  80081b:	e8 02 fb ff ff       	call   800322 <printfmt>
  800820:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800823:	89 7d 14             	mov    %edi,0x14(%ebp)
  800826:	e9 dc fe ff ff       	jmp    800707 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  80082b:	68 04 14 80 00       	push   $0x801404
  800830:	68 ec 12 80 00       	push   $0x8012ec
  800835:	53                   	push   %ebx
  800836:	56                   	push   %esi
  800837:	e8 e6 fa ff ff       	call   800322 <printfmt>
  80083c:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80083f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800842:	e9 c0 fe ff ff       	jmp    800707 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	53                   	push   %ebx
  80084b:	6a 25                	push   $0x25
  80084d:	ff d6                	call   *%esi
			break;
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	e9 b0 fe ff ff       	jmp    800707 <vprintfmt+0x3c8>
			putch('%', putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	53                   	push   %ebx
  80085b:	6a 25                	push   $0x25
  80085d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	89 f8                	mov    %edi,%eax
  800864:	eb 03                	jmp    800869 <vprintfmt+0x52a>
  800866:	83 e8 01             	sub    $0x1,%eax
  800869:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80086d:	75 f7                	jne    800866 <vprintfmt+0x527>
  80086f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800872:	e9 90 fe ff ff       	jmp    800707 <vprintfmt+0x3c8>
}
  800877:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5f                   	pop    %edi
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	83 ec 18             	sub    $0x18,%esp
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800892:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089c:	85 c0                	test   %eax,%eax
  80089e:	74 26                	je     8008c6 <vsnprintf+0x47>
  8008a0:	85 d2                	test   %edx,%edx
  8008a2:	7e 22                	jle    8008c6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a4:	ff 75 14             	pushl  0x14(%ebp)
  8008a7:	ff 75 10             	pushl  0x10(%ebp)
  8008aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ad:	50                   	push   %eax
  8008ae:	68 05 03 80 00       	push   $0x800305
  8008b3:	e8 87 fa ff ff       	call   80033f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
}
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    
		return -E_INVAL;
  8008c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008cb:	eb f7                	jmp    8008c4 <vsnprintf+0x45>

008008cd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d6:	50                   	push   %eax
  8008d7:	ff 75 10             	pushl  0x10(%ebp)
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	ff 75 08             	pushl  0x8(%ebp)
  8008e0:	e8 9a ff ff ff       	call   80087f <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e5:	c9                   	leave  
  8008e6:	c3                   	ret    

008008e7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f6:	74 05                	je     8008fd <strlen+0x16>
		n++;
  8008f8:	83 c0 01             	add    $0x1,%eax
  8008fb:	eb f5                	jmp    8008f2 <strlen+0xb>
	return n;
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800905:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
  80090d:	39 c2                	cmp    %eax,%edx
  80090f:	74 0d                	je     80091e <strnlen+0x1f>
  800911:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800915:	74 05                	je     80091c <strnlen+0x1d>
		n++;
  800917:	83 c2 01             	add    $0x1,%edx
  80091a:	eb f1                	jmp    80090d <strnlen+0xe>
  80091c:	89 d0                	mov    %edx,%eax
	return n;
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	53                   	push   %ebx
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80092a:	ba 00 00 00 00       	mov    $0x0,%edx
  80092f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800933:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800936:	83 c2 01             	add    $0x1,%edx
  800939:	84 c9                	test   %cl,%cl
  80093b:	75 f2                	jne    80092f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80093d:	5b                   	pop    %ebx
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	53                   	push   %ebx
  800944:	83 ec 10             	sub    $0x10,%esp
  800947:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80094a:	53                   	push   %ebx
  80094b:	e8 97 ff ff ff       	call   8008e7 <strlen>
  800950:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	01 d8                	add    %ebx,%eax
  800958:	50                   	push   %eax
  800959:	e8 c2 ff ff ff       	call   800920 <strcpy>
	return dst;
}
  80095e:	89 d8                	mov    %ebx,%eax
  800960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800963:	c9                   	leave  
  800964:	c3                   	ret    

00800965 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	56                   	push   %esi
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800970:	89 c6                	mov    %eax,%esi
  800972:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800975:	89 c2                	mov    %eax,%edx
  800977:	39 f2                	cmp    %esi,%edx
  800979:	74 11                	je     80098c <strncpy+0x27>
		*dst++ = *src;
  80097b:	83 c2 01             	add    $0x1,%edx
  80097e:	0f b6 19             	movzbl (%ecx),%ebx
  800981:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800984:	80 fb 01             	cmp    $0x1,%bl
  800987:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80098a:	eb eb                	jmp    800977 <strncpy+0x12>
	}
	return ret;
}
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	8b 75 08             	mov    0x8(%ebp),%esi
  800998:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099b:	8b 55 10             	mov    0x10(%ebp),%edx
  80099e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a0:	85 d2                	test   %edx,%edx
  8009a2:	74 21                	je     8009c5 <strlcpy+0x35>
  8009a4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009a8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009aa:	39 c2                	cmp    %eax,%edx
  8009ac:	74 14                	je     8009c2 <strlcpy+0x32>
  8009ae:	0f b6 19             	movzbl (%ecx),%ebx
  8009b1:	84 db                	test   %bl,%bl
  8009b3:	74 0b                	je     8009c0 <strlcpy+0x30>
			*dst++ = *src++;
  8009b5:	83 c1 01             	add    $0x1,%ecx
  8009b8:	83 c2 01             	add    $0x1,%edx
  8009bb:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009be:	eb ea                	jmp    8009aa <strlcpy+0x1a>
  8009c0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009c2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009c5:	29 f0                	sub    %esi,%eax
}
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009d4:	0f b6 01             	movzbl (%ecx),%eax
  8009d7:	84 c0                	test   %al,%al
  8009d9:	74 0c                	je     8009e7 <strcmp+0x1c>
  8009db:	3a 02                	cmp    (%edx),%al
  8009dd:	75 08                	jne    8009e7 <strcmp+0x1c>
		p++, q++;
  8009df:	83 c1 01             	add    $0x1,%ecx
  8009e2:	83 c2 01             	add    $0x1,%edx
  8009e5:	eb ed                	jmp    8009d4 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e7:	0f b6 c0             	movzbl %al,%eax
  8009ea:	0f b6 12             	movzbl (%edx),%edx
  8009ed:	29 d0                	sub    %edx,%eax
}
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	53                   	push   %ebx
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fb:	89 c3                	mov    %eax,%ebx
  8009fd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a00:	eb 06                	jmp    800a08 <strncmp+0x17>
		n--, p++, q++;
  800a02:	83 c0 01             	add    $0x1,%eax
  800a05:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a08:	39 d8                	cmp    %ebx,%eax
  800a0a:	74 16                	je     800a22 <strncmp+0x31>
  800a0c:	0f b6 08             	movzbl (%eax),%ecx
  800a0f:	84 c9                	test   %cl,%cl
  800a11:	74 04                	je     800a17 <strncmp+0x26>
  800a13:	3a 0a                	cmp    (%edx),%cl
  800a15:	74 eb                	je     800a02 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a17:	0f b6 00             	movzbl (%eax),%eax
  800a1a:	0f b6 12             	movzbl (%edx),%edx
  800a1d:	29 d0                	sub    %edx,%eax
}
  800a1f:	5b                   	pop    %ebx
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    
		return 0;
  800a22:	b8 00 00 00 00       	mov    $0x0,%eax
  800a27:	eb f6                	jmp    800a1f <strncmp+0x2e>

00800a29 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a33:	0f b6 10             	movzbl (%eax),%edx
  800a36:	84 d2                	test   %dl,%dl
  800a38:	74 09                	je     800a43 <strchr+0x1a>
		if (*s == c)
  800a3a:	38 ca                	cmp    %cl,%dl
  800a3c:	74 0a                	je     800a48 <strchr+0x1f>
	for (; *s; s++)
  800a3e:	83 c0 01             	add    $0x1,%eax
  800a41:	eb f0                	jmp    800a33 <strchr+0xa>
			return (char *) s;
	return 0;
  800a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a54:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a57:	38 ca                	cmp    %cl,%dl
  800a59:	74 09                	je     800a64 <strfind+0x1a>
  800a5b:	84 d2                	test   %dl,%dl
  800a5d:	74 05                	je     800a64 <strfind+0x1a>
	for (; *s; s++)
  800a5f:	83 c0 01             	add    $0x1,%eax
  800a62:	eb f0                	jmp    800a54 <strfind+0xa>
			break;
	return (char *) s;
}
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	57                   	push   %edi
  800a6a:	56                   	push   %esi
  800a6b:	53                   	push   %ebx
  800a6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a72:	85 c9                	test   %ecx,%ecx
  800a74:	74 31                	je     800aa7 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a76:	89 f8                	mov    %edi,%eax
  800a78:	09 c8                	or     %ecx,%eax
  800a7a:	a8 03                	test   $0x3,%al
  800a7c:	75 23                	jne    800aa1 <memset+0x3b>
		c &= 0xFF;
  800a7e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a82:	89 d3                	mov    %edx,%ebx
  800a84:	c1 e3 08             	shl    $0x8,%ebx
  800a87:	89 d0                	mov    %edx,%eax
  800a89:	c1 e0 18             	shl    $0x18,%eax
  800a8c:	89 d6                	mov    %edx,%esi
  800a8e:	c1 e6 10             	shl    $0x10,%esi
  800a91:	09 f0                	or     %esi,%eax
  800a93:	09 c2                	or     %eax,%edx
  800a95:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a97:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a9a:	89 d0                	mov    %edx,%eax
  800a9c:	fc                   	cld    
  800a9d:	f3 ab                	rep stos %eax,%es:(%edi)
  800a9f:	eb 06                	jmp    800aa7 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa4:	fc                   	cld    
  800aa5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aa7:	89 f8                	mov    %edi,%eax
  800aa9:	5b                   	pop    %ebx
  800aaa:	5e                   	pop    %esi
  800aab:	5f                   	pop    %edi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	57                   	push   %edi
  800ab2:	56                   	push   %esi
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800abc:	39 c6                	cmp    %eax,%esi
  800abe:	73 32                	jae    800af2 <memmove+0x44>
  800ac0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac3:	39 c2                	cmp    %eax,%edx
  800ac5:	76 2b                	jbe    800af2 <memmove+0x44>
		s += n;
		d += n;
  800ac7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aca:	89 fe                	mov    %edi,%esi
  800acc:	09 ce                	or     %ecx,%esi
  800ace:	09 d6                	or     %edx,%esi
  800ad0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad6:	75 0e                	jne    800ae6 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad8:	83 ef 04             	sub    $0x4,%edi
  800adb:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ade:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae1:	fd                   	std    
  800ae2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae4:	eb 09                	jmp    800aef <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae6:	83 ef 01             	sub    $0x1,%edi
  800ae9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aec:	fd                   	std    
  800aed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aef:	fc                   	cld    
  800af0:	eb 1a                	jmp    800b0c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af2:	89 c2                	mov    %eax,%edx
  800af4:	09 ca                	or     %ecx,%edx
  800af6:	09 f2                	or     %esi,%edx
  800af8:	f6 c2 03             	test   $0x3,%dl
  800afb:	75 0a                	jne    800b07 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800afd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b00:	89 c7                	mov    %eax,%edi
  800b02:	fc                   	cld    
  800b03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b05:	eb 05                	jmp    800b0c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b07:	89 c7                	mov    %eax,%edi
  800b09:	fc                   	cld    
  800b0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b0c:	5e                   	pop    %esi
  800b0d:	5f                   	pop    %edi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b16:	ff 75 10             	pushl  0x10(%ebp)
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	ff 75 08             	pushl  0x8(%ebp)
  800b1f:	e8 8a ff ff ff       	call   800aae <memmove>
}
  800b24:	c9                   	leave  
  800b25:	c3                   	ret    

00800b26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	56                   	push   %esi
  800b2a:	53                   	push   %ebx
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b31:	89 c6                	mov    %eax,%esi
  800b33:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b36:	39 f0                	cmp    %esi,%eax
  800b38:	74 1c                	je     800b56 <memcmp+0x30>
		if (*s1 != *s2)
  800b3a:	0f b6 08             	movzbl (%eax),%ecx
  800b3d:	0f b6 1a             	movzbl (%edx),%ebx
  800b40:	38 d9                	cmp    %bl,%cl
  800b42:	75 08                	jne    800b4c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b44:	83 c0 01             	add    $0x1,%eax
  800b47:	83 c2 01             	add    $0x1,%edx
  800b4a:	eb ea                	jmp    800b36 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b4c:	0f b6 c1             	movzbl %cl,%eax
  800b4f:	0f b6 db             	movzbl %bl,%ebx
  800b52:	29 d8                	sub    %ebx,%eax
  800b54:	eb 05                	jmp    800b5b <memcmp+0x35>
	}

	return 0;
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b68:	89 c2                	mov    %eax,%edx
  800b6a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b6d:	39 d0                	cmp    %edx,%eax
  800b6f:	73 09                	jae    800b7a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b71:	38 08                	cmp    %cl,(%eax)
  800b73:	74 05                	je     800b7a <memfind+0x1b>
	for (; s < ends; s++)
  800b75:	83 c0 01             	add    $0x1,%eax
  800b78:	eb f3                	jmp    800b6d <memfind+0xe>
			break;
	return (void *) s;
}
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b88:	eb 03                	jmp    800b8d <strtol+0x11>
		s++;
  800b8a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b8d:	0f b6 01             	movzbl (%ecx),%eax
  800b90:	3c 20                	cmp    $0x20,%al
  800b92:	74 f6                	je     800b8a <strtol+0xe>
  800b94:	3c 09                	cmp    $0x9,%al
  800b96:	74 f2                	je     800b8a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b98:	3c 2b                	cmp    $0x2b,%al
  800b9a:	74 2a                	je     800bc6 <strtol+0x4a>
	int neg = 0;
  800b9c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ba1:	3c 2d                	cmp    $0x2d,%al
  800ba3:	74 2b                	je     800bd0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bab:	75 0f                	jne    800bbc <strtol+0x40>
  800bad:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb0:	74 28                	je     800bda <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb2:	85 db                	test   %ebx,%ebx
  800bb4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb9:	0f 44 d8             	cmove  %eax,%ebx
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bc4:	eb 50                	jmp    800c16 <strtol+0x9a>
		s++;
  800bc6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bc9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bce:	eb d5                	jmp    800ba5 <strtol+0x29>
		s++, neg = 1;
  800bd0:	83 c1 01             	add    $0x1,%ecx
  800bd3:	bf 01 00 00 00       	mov    $0x1,%edi
  800bd8:	eb cb                	jmp    800ba5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bda:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bde:	74 0e                	je     800bee <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800be0:	85 db                	test   %ebx,%ebx
  800be2:	75 d8                	jne    800bbc <strtol+0x40>
		s++, base = 8;
  800be4:	83 c1 01             	add    $0x1,%ecx
  800be7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bec:	eb ce                	jmp    800bbc <strtol+0x40>
		s += 2, base = 16;
  800bee:	83 c1 02             	add    $0x2,%ecx
  800bf1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bf6:	eb c4                	jmp    800bbc <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bf8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bfb:	89 f3                	mov    %esi,%ebx
  800bfd:	80 fb 19             	cmp    $0x19,%bl
  800c00:	77 29                	ja     800c2b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c02:	0f be d2             	movsbl %dl,%edx
  800c05:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c08:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c0b:	7d 30                	jge    800c3d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c0d:	83 c1 01             	add    $0x1,%ecx
  800c10:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c14:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c16:	0f b6 11             	movzbl (%ecx),%edx
  800c19:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c1c:	89 f3                	mov    %esi,%ebx
  800c1e:	80 fb 09             	cmp    $0x9,%bl
  800c21:	77 d5                	ja     800bf8 <strtol+0x7c>
			dig = *s - '0';
  800c23:	0f be d2             	movsbl %dl,%edx
  800c26:	83 ea 30             	sub    $0x30,%edx
  800c29:	eb dd                	jmp    800c08 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c2b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c2e:	89 f3                	mov    %esi,%ebx
  800c30:	80 fb 19             	cmp    $0x19,%bl
  800c33:	77 08                	ja     800c3d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c35:	0f be d2             	movsbl %dl,%edx
  800c38:	83 ea 37             	sub    $0x37,%edx
  800c3b:	eb cb                	jmp    800c08 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c41:	74 05                	je     800c48 <strtol+0xcc>
		*endptr = (char *) s;
  800c43:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c46:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c48:	89 c2                	mov    %eax,%edx
  800c4a:	f7 da                	neg    %edx
  800c4c:	85 ff                	test   %edi,%edi
  800c4e:	0f 45 c2             	cmovne %edx,%eax
}
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	57                   	push   %edi
  800c5a:	56                   	push   %esi
  800c5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c61:	8b 55 08             	mov    0x8(%ebp),%edx
  800c64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c67:	89 c3                	mov    %eax,%ebx
  800c69:	89 c7                	mov    %eax,%edi
  800c6b:	89 c6                	mov    %eax,%esi
  800c6d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c84:	89 d1                	mov    %edx,%ecx
  800c86:	89 d3                	mov    %edx,%ebx
  800c88:	89 d7                	mov    %edx,%edi
  800c8a:	89 d6                	mov    %edx,%esi
  800c8c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca9:	89 cb                	mov    %ecx,%ebx
  800cab:	89 cf                	mov    %ecx,%edi
  800cad:	89 ce                	mov    %ecx,%esi
  800caf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	7f 08                	jg     800cbd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbd:	83 ec 0c             	sub    $0xc,%esp
  800cc0:	50                   	push   %eax
  800cc1:	6a 03                	push   $0x3
  800cc3:	68 40 16 80 00       	push   $0x801640
  800cc8:	6a 33                	push   $0x33
  800cca:	68 5d 16 80 00       	push   $0x80165d
  800ccf:	e8 63 f4 ff ff       	call   800137 <_panic>

00800cd4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdf:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce4:	89 d1                	mov    %edx,%ecx
  800ce6:	89 d3                	mov    %edx,%ebx
  800ce8:	89 d7                	mov    %edx,%edi
  800cea:	89 d6                	mov    %edx,%esi
  800cec:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_yield>:

void
sys_yield(void)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfe:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d03:	89 d1                	mov    %edx,%ecx
  800d05:	89 d3                	mov    %edx,%ebx
  800d07:	89 d7                	mov    %edx,%edi
  800d09:	89 d6                	mov    %edx,%esi
  800d0b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1b:	be 00 00 00 00       	mov    $0x0,%esi
  800d20:	8b 55 08             	mov    0x8(%ebp),%edx
  800d23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d26:	b8 04 00 00 00       	mov    $0x4,%eax
  800d2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2e:	89 f7                	mov    %esi,%edi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 04                	push   $0x4
  800d44:	68 40 16 80 00       	push   $0x801640
  800d49:	6a 33                	push   $0x33
  800d4b:	68 5d 16 80 00       	push   $0x80165d
  800d50:	e8 e2 f3 ff ff       	call   800137 <_panic>

00800d55 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d64:	b8 05 00 00 00       	mov    $0x5,%eax
  800d69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7f 08                	jg     800d80 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	50                   	push   %eax
  800d84:	6a 05                	push   $0x5
  800d86:	68 40 16 80 00       	push   $0x801640
  800d8b:	6a 33                	push   $0x33
  800d8d:	68 5d 16 80 00       	push   $0x80165d
  800d92:	e8 a0 f3 ff ff       	call   800137 <_panic>

00800d97 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 06 00 00 00       	mov    $0x6,%eax
  800db0:	89 df                	mov    %ebx,%edi
  800db2:	89 de                	mov    %ebx,%esi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	50                   	push   %eax
  800dc6:	6a 06                	push   $0x6
  800dc8:	68 40 16 80 00       	push   $0x801640
  800dcd:	6a 33                	push   $0x33
  800dcf:	68 5d 16 80 00       	push   $0x80165d
  800dd4:	e8 5e f3 ff ff       	call   800137 <_panic>

00800dd9 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dea:	b8 0b 00 00 00       	mov    $0xb,%eax
  800def:	89 cb                	mov    %ecx,%ebx
  800df1:	89 cf                	mov    %ecx,%edi
  800df3:	89 ce                	mov    %ecx,%esi
  800df5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	7f 08                	jg     800e03 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	50                   	push   %eax
  800e07:	6a 0b                	push   $0xb
  800e09:	68 40 16 80 00       	push   $0x801640
  800e0e:	6a 33                	push   $0x33
  800e10:	68 5d 16 80 00       	push   $0x80165d
  800e15:	e8 1d f3 ff ff       	call   800137 <_panic>

00800e1a <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e33:	89 df                	mov    %ebx,%edi
  800e35:	89 de                	mov    %ebx,%esi
  800e37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	7f 08                	jg     800e45 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e45:	83 ec 0c             	sub    $0xc,%esp
  800e48:	50                   	push   %eax
  800e49:	6a 08                	push   $0x8
  800e4b:	68 40 16 80 00       	push   $0x801640
  800e50:	6a 33                	push   $0x33
  800e52:	68 5d 16 80 00       	push   $0x80165d
  800e57:	e8 db f2 ff ff       	call   800137 <_panic>

00800e5c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 09 00 00 00       	mov    $0x9,%eax
  800e75:	89 df                	mov    %ebx,%edi
  800e77:	89 de                	mov    %ebx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 09                	push   $0x9
  800e8d:	68 40 16 80 00       	push   $0x801640
  800e92:	6a 33                	push   $0x33
  800e94:	68 5d 16 80 00       	push   $0x80165d
  800e99:	e8 99 f2 ff ff       	call   800137 <_panic>

00800e9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb7:	89 df                	mov    %ebx,%edi
  800eb9:	89 de                	mov    %ebx,%esi
  800ebb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	7f 08                	jg     800ec9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec9:	83 ec 0c             	sub    $0xc,%esp
  800ecc:	50                   	push   %eax
  800ecd:	6a 0a                	push   $0xa
  800ecf:	68 40 16 80 00       	push   $0x801640
  800ed4:	6a 33                	push   $0x33
  800ed6:	68 5d 16 80 00       	push   $0x80165d
  800edb:	e8 57 f2 ff ff       	call   800137 <_panic>

00800ee0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef1:	be 00 00 00 00       	mov    $0x0,%esi
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f19:	89 cb                	mov    %ecx,%ebx
  800f1b:	89 cf                	mov    %ecx,%edi
  800f1d:	89 ce                	mov    %ecx,%esi
  800f1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7f 08                	jg     800f2d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	50                   	push   %eax
  800f31:	6a 0e                	push   $0xe
  800f33:	68 40 16 80 00       	push   $0x801640
  800f38:	6a 33                	push   $0x33
  800f3a:	68 5d 16 80 00       	push   $0x80165d
  800f3f:	e8 f3 f1 ff ff       	call   800137 <_panic>

00800f44 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f55:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f5a:	89 df                	mov    %ebx,%edi
  800f5c:	89 de                	mov    %ebx,%esi
  800f5e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f70:	8b 55 08             	mov    0x8(%ebp),%edx
  800f73:	b8 10 00 00 00       	mov    $0x10,%eax
  800f78:	89 cb                	mov    %ecx,%ebx
  800f7a:	89 cf                	mov    %ecx,%edi
  800f7c:	89 ce                	mov    %ecx,%esi
  800f7e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    
  800f85:	66 90                	xchg   %ax,%ax
  800f87:	66 90                	xchg   %ax,%ax
  800f89:	66 90                	xchg   %ax,%ax
  800f8b:	66 90                	xchg   %ax,%ax
  800f8d:	66 90                	xchg   %ax,%ax
  800f8f:	90                   	nop

00800f90 <__udivdi3>:
  800f90:	55                   	push   %ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 1c             	sub    $0x1c,%esp
  800f97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fa3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fa7:	85 d2                	test   %edx,%edx
  800fa9:	75 4d                	jne    800ff8 <__udivdi3+0x68>
  800fab:	39 f3                	cmp    %esi,%ebx
  800fad:	76 19                	jbe    800fc8 <__udivdi3+0x38>
  800faf:	31 ff                	xor    %edi,%edi
  800fb1:	89 e8                	mov    %ebp,%eax
  800fb3:	89 f2                	mov    %esi,%edx
  800fb5:	f7 f3                	div    %ebx
  800fb7:	89 fa                	mov    %edi,%edx
  800fb9:	83 c4 1c             	add    $0x1c,%esp
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    
  800fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	89 d9                	mov    %ebx,%ecx
  800fca:	85 db                	test   %ebx,%ebx
  800fcc:	75 0b                	jne    800fd9 <__udivdi3+0x49>
  800fce:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd3:	31 d2                	xor    %edx,%edx
  800fd5:	f7 f3                	div    %ebx
  800fd7:	89 c1                	mov    %eax,%ecx
  800fd9:	31 d2                	xor    %edx,%edx
  800fdb:	89 f0                	mov    %esi,%eax
  800fdd:	f7 f1                	div    %ecx
  800fdf:	89 c6                	mov    %eax,%esi
  800fe1:	89 e8                	mov    %ebp,%eax
  800fe3:	89 f7                	mov    %esi,%edi
  800fe5:	f7 f1                	div    %ecx
  800fe7:	89 fa                	mov    %edi,%edx
  800fe9:	83 c4 1c             	add    $0x1c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	39 f2                	cmp    %esi,%edx
  800ffa:	77 1c                	ja     801018 <__udivdi3+0x88>
  800ffc:	0f bd fa             	bsr    %edx,%edi
  800fff:	83 f7 1f             	xor    $0x1f,%edi
  801002:	75 2c                	jne    801030 <__udivdi3+0xa0>
  801004:	39 f2                	cmp    %esi,%edx
  801006:	72 06                	jb     80100e <__udivdi3+0x7e>
  801008:	31 c0                	xor    %eax,%eax
  80100a:	39 eb                	cmp    %ebp,%ebx
  80100c:	77 a9                	ja     800fb7 <__udivdi3+0x27>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	eb a2                	jmp    800fb7 <__udivdi3+0x27>
  801015:	8d 76 00             	lea    0x0(%esi),%esi
  801018:	31 ff                	xor    %edi,%edi
  80101a:	31 c0                	xor    %eax,%eax
  80101c:	89 fa                	mov    %edi,%edx
  80101e:	83 c4 1c             	add    $0x1c,%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
  801026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80102d:	8d 76 00             	lea    0x0(%esi),%esi
  801030:	89 f9                	mov    %edi,%ecx
  801032:	b8 20 00 00 00       	mov    $0x20,%eax
  801037:	29 f8                	sub    %edi,%eax
  801039:	d3 e2                	shl    %cl,%edx
  80103b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80103f:	89 c1                	mov    %eax,%ecx
  801041:	89 da                	mov    %ebx,%edx
  801043:	d3 ea                	shr    %cl,%edx
  801045:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801049:	09 d1                	or     %edx,%ecx
  80104b:	89 f2                	mov    %esi,%edx
  80104d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801051:	89 f9                	mov    %edi,%ecx
  801053:	d3 e3                	shl    %cl,%ebx
  801055:	89 c1                	mov    %eax,%ecx
  801057:	d3 ea                	shr    %cl,%edx
  801059:	89 f9                	mov    %edi,%ecx
  80105b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80105f:	89 eb                	mov    %ebp,%ebx
  801061:	d3 e6                	shl    %cl,%esi
  801063:	89 c1                	mov    %eax,%ecx
  801065:	d3 eb                	shr    %cl,%ebx
  801067:	09 de                	or     %ebx,%esi
  801069:	89 f0                	mov    %esi,%eax
  80106b:	f7 74 24 08          	divl   0x8(%esp)
  80106f:	89 d6                	mov    %edx,%esi
  801071:	89 c3                	mov    %eax,%ebx
  801073:	f7 64 24 0c          	mull   0xc(%esp)
  801077:	39 d6                	cmp    %edx,%esi
  801079:	72 15                	jb     801090 <__udivdi3+0x100>
  80107b:	89 f9                	mov    %edi,%ecx
  80107d:	d3 e5                	shl    %cl,%ebp
  80107f:	39 c5                	cmp    %eax,%ebp
  801081:	73 04                	jae    801087 <__udivdi3+0xf7>
  801083:	39 d6                	cmp    %edx,%esi
  801085:	74 09                	je     801090 <__udivdi3+0x100>
  801087:	89 d8                	mov    %ebx,%eax
  801089:	31 ff                	xor    %edi,%edi
  80108b:	e9 27 ff ff ff       	jmp    800fb7 <__udivdi3+0x27>
  801090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801093:	31 ff                	xor    %edi,%edi
  801095:	e9 1d ff ff ff       	jmp    800fb7 <__udivdi3+0x27>
  80109a:	66 90                	xchg   %ax,%ax
  80109c:	66 90                	xchg   %ax,%ax
  80109e:	66 90                	xchg   %ax,%ax

008010a0 <__umoddi3>:
  8010a0:	55                   	push   %ebp
  8010a1:	57                   	push   %edi
  8010a2:	56                   	push   %esi
  8010a3:	53                   	push   %ebx
  8010a4:	83 ec 1c             	sub    $0x1c,%esp
  8010a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010b7:	89 da                	mov    %ebx,%edx
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	75 43                	jne    801100 <__umoddi3+0x60>
  8010bd:	39 df                	cmp    %ebx,%edi
  8010bf:	76 17                	jbe    8010d8 <__umoddi3+0x38>
  8010c1:	89 f0                	mov    %esi,%eax
  8010c3:	f7 f7                	div    %edi
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	31 d2                	xor    %edx,%edx
  8010c9:	83 c4 1c             	add    $0x1c,%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    
  8010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d8:	89 fd                	mov    %edi,%ebp
  8010da:	85 ff                	test   %edi,%edi
  8010dc:	75 0b                	jne    8010e9 <__umoddi3+0x49>
  8010de:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e3:	31 d2                	xor    %edx,%edx
  8010e5:	f7 f7                	div    %edi
  8010e7:	89 c5                	mov    %eax,%ebp
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	31 d2                	xor    %edx,%edx
  8010ed:	f7 f5                	div    %ebp
  8010ef:	89 f0                	mov    %esi,%eax
  8010f1:	f7 f5                	div    %ebp
  8010f3:	89 d0                	mov    %edx,%eax
  8010f5:	eb d0                	jmp    8010c7 <__umoddi3+0x27>
  8010f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010fe:	66 90                	xchg   %ax,%ax
  801100:	89 f1                	mov    %esi,%ecx
  801102:	39 d8                	cmp    %ebx,%eax
  801104:	76 0a                	jbe    801110 <__umoddi3+0x70>
  801106:	89 f0                	mov    %esi,%eax
  801108:	83 c4 1c             	add    $0x1c,%esp
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5f                   	pop    %edi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    
  801110:	0f bd e8             	bsr    %eax,%ebp
  801113:	83 f5 1f             	xor    $0x1f,%ebp
  801116:	75 20                	jne    801138 <__umoddi3+0x98>
  801118:	39 d8                	cmp    %ebx,%eax
  80111a:	0f 82 b0 00 00 00    	jb     8011d0 <__umoddi3+0x130>
  801120:	39 f7                	cmp    %esi,%edi
  801122:	0f 86 a8 00 00 00    	jbe    8011d0 <__umoddi3+0x130>
  801128:	89 c8                	mov    %ecx,%eax
  80112a:	83 c4 1c             	add    $0x1c,%esp
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    
  801132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801138:	89 e9                	mov    %ebp,%ecx
  80113a:	ba 20 00 00 00       	mov    $0x20,%edx
  80113f:	29 ea                	sub    %ebp,%edx
  801141:	d3 e0                	shl    %cl,%eax
  801143:	89 44 24 08          	mov    %eax,0x8(%esp)
  801147:	89 d1                	mov    %edx,%ecx
  801149:	89 f8                	mov    %edi,%eax
  80114b:	d3 e8                	shr    %cl,%eax
  80114d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801151:	89 54 24 04          	mov    %edx,0x4(%esp)
  801155:	8b 54 24 04          	mov    0x4(%esp),%edx
  801159:	09 c1                	or     %eax,%ecx
  80115b:	89 d8                	mov    %ebx,%eax
  80115d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801161:	89 e9                	mov    %ebp,%ecx
  801163:	d3 e7                	shl    %cl,%edi
  801165:	89 d1                	mov    %edx,%ecx
  801167:	d3 e8                	shr    %cl,%eax
  801169:	89 e9                	mov    %ebp,%ecx
  80116b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80116f:	d3 e3                	shl    %cl,%ebx
  801171:	89 c7                	mov    %eax,%edi
  801173:	89 d1                	mov    %edx,%ecx
  801175:	89 f0                	mov    %esi,%eax
  801177:	d3 e8                	shr    %cl,%eax
  801179:	89 e9                	mov    %ebp,%ecx
  80117b:	89 fa                	mov    %edi,%edx
  80117d:	d3 e6                	shl    %cl,%esi
  80117f:	09 d8                	or     %ebx,%eax
  801181:	f7 74 24 08          	divl   0x8(%esp)
  801185:	89 d1                	mov    %edx,%ecx
  801187:	89 f3                	mov    %esi,%ebx
  801189:	f7 64 24 0c          	mull   0xc(%esp)
  80118d:	89 c6                	mov    %eax,%esi
  80118f:	89 d7                	mov    %edx,%edi
  801191:	39 d1                	cmp    %edx,%ecx
  801193:	72 06                	jb     80119b <__umoddi3+0xfb>
  801195:	75 10                	jne    8011a7 <__umoddi3+0x107>
  801197:	39 c3                	cmp    %eax,%ebx
  801199:	73 0c                	jae    8011a7 <__umoddi3+0x107>
  80119b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80119f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011a3:	89 d7                	mov    %edx,%edi
  8011a5:	89 c6                	mov    %eax,%esi
  8011a7:	89 ca                	mov    %ecx,%edx
  8011a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011ae:	29 f3                	sub    %esi,%ebx
  8011b0:	19 fa                	sbb    %edi,%edx
  8011b2:	89 d0                	mov    %edx,%eax
  8011b4:	d3 e0                	shl    %cl,%eax
  8011b6:	89 e9                	mov    %ebp,%ecx
  8011b8:	d3 eb                	shr    %cl,%ebx
  8011ba:	d3 ea                	shr    %cl,%edx
  8011bc:	09 d8                	or     %ebx,%eax
  8011be:	83 c4 1c             	add    $0x1c,%esp
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    
  8011c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011cd:	8d 76 00             	lea    0x0(%esi),%esi
  8011d0:	89 da                	mov    %ebx,%edx
  8011d2:	29 fe                	sub    %edi,%esi
  8011d4:	19 c2                	sbb    %eax,%edx
  8011d6:	89 f1                	mov    %esi,%ecx
  8011d8:	89 c8                	mov    %ecx,%eax
  8011da:	e9 4b ff ff ff       	jmp    80112a <__umoddi3+0x8a>
