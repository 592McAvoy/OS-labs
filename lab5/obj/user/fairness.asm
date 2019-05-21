
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 13 0c 00 00       	call   800c53 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 20 80 00 90 	cmpl   $0xeec00090,0x802004
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 d8 00 c0 ee       	mov    0xeec000d8,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 b1 12 80 00       	push   $0x8012b1
  80005d:	e8 2f 01 00 00       	call   800191 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 d8 00 c0 ee       	mov    0xeec000d8,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 f5 0e 00 00       	call   800f6b <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 79 0e 00 00       	call   800f04 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 a0 12 80 00       	push   $0x8012a0
  800097:	e8 f5 00 00 00       	call   800191 <cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb dd                	jmp    80007e <umain+0x4b>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 a2 0b 00 00       	call   800c53 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000b9:	c1 e0 04             	shl    $0x4,%eax
  8000bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c1:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c6:	85 db                	test   %ebx,%ebx
  8000c8:	7e 07                	jle    8000d1 <libmain+0x30>
		binaryname = argv[0];
  8000ca:	8b 06                	mov    (%esi),%eax
  8000cc:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	e8 58 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000db:	e8 0a 00 00 00       	call   8000ea <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5d                   	pop    %ebp
  8000e9:	c3                   	ret    

008000ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000f0:	6a 00                	push   $0x0
  8000f2:	e8 1b 0b 00 00       	call   800c12 <sys_env_destroy>
}
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	c9                   	leave  
  8000fb:	c3                   	ret    

008000fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	53                   	push   %ebx
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800106:	8b 13                	mov    (%ebx),%edx
  800108:	8d 42 01             	lea    0x1(%edx),%eax
  80010b:	89 03                	mov    %eax,(%ebx)
  80010d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800110:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800114:	3d ff 00 00 00       	cmp    $0xff,%eax
  800119:	74 09                	je     800124 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800122:	c9                   	leave  
  800123:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800124:	83 ec 08             	sub    $0x8,%esp
  800127:	68 ff 00 00 00       	push   $0xff
  80012c:	8d 43 08             	lea    0x8(%ebx),%eax
  80012f:	50                   	push   %eax
  800130:	e8 a0 0a 00 00       	call   800bd5 <sys_cputs>
		b->idx = 0;
  800135:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	eb db                	jmp    80011b <putch+0x1f>

00800140 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800149:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800150:	00 00 00 
	b.cnt = 0;
  800153:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015d:	ff 75 0c             	pushl  0xc(%ebp)
  800160:	ff 75 08             	pushl  0x8(%ebp)
  800163:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800169:	50                   	push   %eax
  80016a:	68 fc 00 80 00       	push   $0x8000fc
  80016f:	e8 4a 01 00 00       	call   8002be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800174:	83 c4 08             	add    $0x8,%esp
  800177:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800183:	50                   	push   %eax
  800184:	e8 4c 0a 00 00       	call   800bd5 <sys_cputs>

	return b.cnt;
}
  800189:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018f:	c9                   	leave  
  800190:	c3                   	ret    

00800191 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800197:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019a:	50                   	push   %eax
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 9d ff ff ff       	call   800140 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 1c             	sub    $0x1c,%esp
  8001ae:	89 c6                	mov    %eax,%esi
  8001b0:	89 d7                	mov    %edx,%edi
  8001b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001be:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001c4:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001c8:	74 2c                	je     8001f6 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001d7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001da:	39 c2                	cmp    %eax,%edx
  8001dc:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001df:	73 43                	jae    800224 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001e1:	83 eb 01             	sub    $0x1,%ebx
  8001e4:	85 db                	test   %ebx,%ebx
  8001e6:	7e 6c                	jle    800254 <printnum+0xaf>
			putch(padc, putdat);
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	57                   	push   %edi
  8001ec:	ff 75 18             	pushl  0x18(%ebp)
  8001ef:	ff d6                	call   *%esi
  8001f1:	83 c4 10             	add    $0x10,%esp
  8001f4:	eb eb                	jmp    8001e1 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	6a 20                	push   $0x20
  8001fb:	6a 00                	push   $0x0
  8001fd:	50                   	push   %eax
  8001fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800201:	ff 75 e0             	pushl  -0x20(%ebp)
  800204:	89 fa                	mov    %edi,%edx
  800206:	89 f0                	mov    %esi,%eax
  800208:	e8 98 ff ff ff       	call   8001a5 <printnum>
		while (--width > 0)
  80020d:	83 c4 20             	add    $0x20,%esp
  800210:	83 eb 01             	sub    $0x1,%ebx
  800213:	85 db                	test   %ebx,%ebx
  800215:	7e 65                	jle    80027c <printnum+0xd7>
			putch(padc, putdat);
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	57                   	push   %edi
  80021b:	6a 20                	push   $0x20
  80021d:	ff d6                	call   *%esi
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	eb ec                	jmp    800210 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	ff 75 18             	pushl  0x18(%ebp)
  80022a:	83 eb 01             	sub    $0x1,%ebx
  80022d:	53                   	push   %ebx
  80022e:	50                   	push   %eax
  80022f:	83 ec 08             	sub    $0x8,%esp
  800232:	ff 75 dc             	pushl  -0x24(%ebp)
  800235:	ff 75 d8             	pushl  -0x28(%ebp)
  800238:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023b:	ff 75 e0             	pushl  -0x20(%ebp)
  80023e:	e8 fd 0d 00 00       	call   801040 <__udivdi3>
  800243:	83 c4 18             	add    $0x18,%esp
  800246:	52                   	push   %edx
  800247:	50                   	push   %eax
  800248:	89 fa                	mov    %edi,%edx
  80024a:	89 f0                	mov    %esi,%eax
  80024c:	e8 54 ff ff ff       	call   8001a5 <printnum>
  800251:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	57                   	push   %edi
  800258:	83 ec 04             	sub    $0x4,%esp
  80025b:	ff 75 dc             	pushl  -0x24(%ebp)
  80025e:	ff 75 d8             	pushl  -0x28(%ebp)
  800261:	ff 75 e4             	pushl  -0x1c(%ebp)
  800264:	ff 75 e0             	pushl  -0x20(%ebp)
  800267:	e8 e4 0e 00 00       	call   801150 <__umoddi3>
  80026c:	83 c4 14             	add    $0x14,%esp
  80026f:	0f be 80 d2 12 80 00 	movsbl 0x8012d2(%eax),%eax
  800276:	50                   	push   %eax
  800277:	ff d6                	call   *%esi
  800279:	83 c4 10             	add    $0x10,%esp
}
  80027c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027f:	5b                   	pop    %ebx
  800280:	5e                   	pop    %esi
  800281:	5f                   	pop    %edi
  800282:	5d                   	pop    %ebp
  800283:	c3                   	ret    

00800284 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80028a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028e:	8b 10                	mov    (%eax),%edx
  800290:	3b 50 04             	cmp    0x4(%eax),%edx
  800293:	73 0a                	jae    80029f <sprintputch+0x1b>
		*b->buf++ = ch;
  800295:	8d 4a 01             	lea    0x1(%edx),%ecx
  800298:	89 08                	mov    %ecx,(%eax)
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	88 02                	mov    %al,(%edx)
}
  80029f:	5d                   	pop    %ebp
  8002a0:	c3                   	ret    

008002a1 <printfmt>:
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002aa:	50                   	push   %eax
  8002ab:	ff 75 10             	pushl  0x10(%ebp)
  8002ae:	ff 75 0c             	pushl  0xc(%ebp)
  8002b1:	ff 75 08             	pushl  0x8(%ebp)
  8002b4:	e8 05 00 00 00       	call   8002be <vprintfmt>
}
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    

008002be <vprintfmt>:
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	57                   	push   %edi
  8002c2:	56                   	push   %esi
  8002c3:	53                   	push   %ebx
  8002c4:	83 ec 3c             	sub    $0x3c,%esp
  8002c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002cd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d0:	e9 b4 03 00 00       	jmp    800689 <vprintfmt+0x3cb>
		padc = ' ';
  8002d5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8002d9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8002e0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002e7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8d 47 01             	lea    0x1(%edi),%eax
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800300:	0f b6 17             	movzbl (%edi),%edx
  800303:	8d 42 dd             	lea    -0x23(%edx),%eax
  800306:	3c 55                	cmp    $0x55,%al
  800308:	0f 87 c8 04 00 00    	ja     8007d6 <vprintfmt+0x518>
  80030e:	0f b6 c0             	movzbl %al,%eax
  800311:	ff 24 85 c0 14 80 00 	jmp    *0x8014c0(,%eax,4)
  800318:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80031b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800322:	eb d6                	jmp    8002fa <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800327:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80032b:	eb cd                	jmp    8002fa <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	0f b6 d2             	movzbl %dl,%edx
  800330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800333:	b8 00 00 00 00       	mov    $0x0,%eax
  800338:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80033b:	eb 0c                	jmp    800349 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800340:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800344:	eb b4                	jmp    8002fa <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800346:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800349:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800350:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800353:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800356:	83 f9 09             	cmp    $0x9,%ecx
  800359:	76 eb                	jbe    800346 <vprintfmt+0x88>
  80035b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80035e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800361:	eb 14                	jmp    800377 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800363:	8b 45 14             	mov    0x14(%ebp),%eax
  800366:	8b 00                	mov    (%eax),%eax
  800368:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036b:	8b 45 14             	mov    0x14(%ebp),%eax
  80036e:	8d 40 04             	lea    0x4(%eax),%eax
  800371:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800377:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80037b:	0f 89 79 ff ff ff    	jns    8002fa <vprintfmt+0x3c>
				width = precision, precision = -1;
  800381:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800384:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800387:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80038e:	e9 67 ff ff ff       	jmp    8002fa <vprintfmt+0x3c>
  800393:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800396:	85 c0                	test   %eax,%eax
  800398:	ba 00 00 00 00       	mov    $0x0,%edx
  80039d:	0f 49 d0             	cmovns %eax,%edx
  8003a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a6:	e9 4f ff ff ff       	jmp    8002fa <vprintfmt+0x3c>
  8003ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ae:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003b5:	e9 40 ff ff ff       	jmp    8002fa <vprintfmt+0x3c>
			lflag++;
  8003ba:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003c0:	e9 35 ff ff ff       	jmp    8002fa <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	8d 78 04             	lea    0x4(%eax),%edi
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	53                   	push   %ebx
  8003cf:	ff 30                	pushl  (%eax)
  8003d1:	ff d6                	call   *%esi
			break;
  8003d3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d9:	e9 a8 02 00 00       	jmp    800686 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8003de:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e1:	8d 78 04             	lea    0x4(%eax),%edi
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	99                   	cltd   
  8003e7:	31 d0                	xor    %edx,%eax
  8003e9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003eb:	83 f8 0f             	cmp    $0xf,%eax
  8003ee:	7f 23                	jg     800413 <vprintfmt+0x155>
  8003f0:	8b 14 85 20 16 80 00 	mov    0x801620(,%eax,4),%edx
  8003f7:	85 d2                	test   %edx,%edx
  8003f9:	74 18                	je     800413 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8003fb:	52                   	push   %edx
  8003fc:	68 f3 12 80 00       	push   $0x8012f3
  800401:	53                   	push   %ebx
  800402:	56                   	push   %esi
  800403:	e8 99 fe ff ff       	call   8002a1 <printfmt>
  800408:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80040b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040e:	e9 73 02 00 00       	jmp    800686 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800413:	50                   	push   %eax
  800414:	68 ea 12 80 00       	push   $0x8012ea
  800419:	53                   	push   %ebx
  80041a:	56                   	push   %esi
  80041b:	e8 81 fe ff ff       	call   8002a1 <printfmt>
  800420:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800423:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800426:	e9 5b 02 00 00       	jmp    800686 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	83 c0 04             	add    $0x4,%eax
  800431:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800439:	85 d2                	test   %edx,%edx
  80043b:	b8 e3 12 80 00       	mov    $0x8012e3,%eax
  800440:	0f 45 c2             	cmovne %edx,%eax
  800443:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800446:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044a:	7e 06                	jle    800452 <vprintfmt+0x194>
  80044c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800450:	75 0d                	jne    80045f <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800452:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800455:	89 c7                	mov    %eax,%edi
  800457:	03 45 e0             	add    -0x20(%ebp),%eax
  80045a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045d:	eb 53                	jmp    8004b2 <vprintfmt+0x1f4>
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	ff 75 d8             	pushl  -0x28(%ebp)
  800465:	50                   	push   %eax
  800466:	e8 13 04 00 00       	call   80087e <strnlen>
  80046b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046e:	29 c1                	sub    %eax,%ecx
  800470:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800478:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80047c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047f:	eb 0f                	jmp    800490 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	53                   	push   %ebx
  800485:	ff 75 e0             	pushl  -0x20(%ebp)
  800488:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048a:	83 ef 01             	sub    $0x1,%edi
  80048d:	83 c4 10             	add    $0x10,%esp
  800490:	85 ff                	test   %edi,%edi
  800492:	7f ed                	jg     800481 <vprintfmt+0x1c3>
  800494:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800497:	85 d2                	test   %edx,%edx
  800499:	b8 00 00 00 00       	mov    $0x0,%eax
  80049e:	0f 49 c2             	cmovns %edx,%eax
  8004a1:	29 c2                	sub    %eax,%edx
  8004a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004a6:	eb aa                	jmp    800452 <vprintfmt+0x194>
					putch(ch, putdat);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	52                   	push   %edx
  8004ad:	ff d6                	call   *%esi
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b7:	83 c7 01             	add    $0x1,%edi
  8004ba:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004be:	0f be d0             	movsbl %al,%edx
  8004c1:	85 d2                	test   %edx,%edx
  8004c3:	74 4b                	je     800510 <vprintfmt+0x252>
  8004c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c9:	78 06                	js     8004d1 <vprintfmt+0x213>
  8004cb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004cf:	78 1e                	js     8004ef <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d5:	74 d1                	je     8004a8 <vprintfmt+0x1ea>
  8004d7:	0f be c0             	movsbl %al,%eax
  8004da:	83 e8 20             	sub    $0x20,%eax
  8004dd:	83 f8 5e             	cmp    $0x5e,%eax
  8004e0:	76 c6                	jbe    8004a8 <vprintfmt+0x1ea>
					putch('?', putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	6a 3f                	push   $0x3f
  8004e8:	ff d6                	call   *%esi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	eb c3                	jmp    8004b2 <vprintfmt+0x1f4>
  8004ef:	89 cf                	mov    %ecx,%edi
  8004f1:	eb 0e                	jmp    800501 <vprintfmt+0x243>
				putch(' ', putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	6a 20                	push   $0x20
  8004f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fb:	83 ef 01             	sub    $0x1,%edi
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	85 ff                	test   %edi,%edi
  800503:	7f ee                	jg     8004f3 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800505:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	e9 76 01 00 00       	jmp    800686 <vprintfmt+0x3c8>
  800510:	89 cf                	mov    %ecx,%edi
  800512:	eb ed                	jmp    800501 <vprintfmt+0x243>
	if (lflag >= 2)
  800514:	83 f9 01             	cmp    $0x1,%ecx
  800517:	7f 1f                	jg     800538 <vprintfmt+0x27a>
	else if (lflag)
  800519:	85 c9                	test   %ecx,%ecx
  80051b:	74 6a                	je     800587 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800525:	89 c1                	mov    %eax,%ecx
  800527:	c1 f9 1f             	sar    $0x1f,%ecx
  80052a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8d 40 04             	lea    0x4(%eax),%eax
  800533:	89 45 14             	mov    %eax,0x14(%ebp)
  800536:	eb 17                	jmp    80054f <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	8b 50 04             	mov    0x4(%eax),%edx
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800543:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	8d 40 08             	lea    0x8(%eax),%eax
  80054c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80054f:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800552:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800557:	85 d2                	test   %edx,%edx
  800559:	0f 89 f8 00 00 00    	jns    800657 <vprintfmt+0x399>
				putch('-', putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	53                   	push   %ebx
  800563:	6a 2d                	push   $0x2d
  800565:	ff d6                	call   *%esi
				num = -(long long) num;
  800567:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80056a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80056d:	f7 d8                	neg    %eax
  80056f:	83 d2 00             	adc    $0x0,%edx
  800572:	f7 da                	neg    %edx
  800574:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800577:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800582:	e9 e1 00 00 00       	jmp    800668 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	99                   	cltd   
  800590:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8d 40 04             	lea    0x4(%eax),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
  80059c:	eb b1                	jmp    80054f <vprintfmt+0x291>
	if (lflag >= 2)
  80059e:	83 f9 01             	cmp    $0x1,%ecx
  8005a1:	7f 27                	jg     8005ca <vprintfmt+0x30c>
	else if (lflag)
  8005a3:	85 c9                	test   %ecx,%ecx
  8005a5:	74 41                	je     8005e8 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 40 04             	lea    0x4(%eax),%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005c5:	e9 8d 00 00 00       	jmp    800657 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8b 50 04             	mov    0x4(%eax),%edx
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8d 40 08             	lea    0x8(%eax),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005e6:	eb 6f                	jmp    800657 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 04             	lea    0x4(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800601:	bf 0a 00 00 00       	mov    $0xa,%edi
  800606:	eb 4f                	jmp    800657 <vprintfmt+0x399>
	if (lflag >= 2)
  800608:	83 f9 01             	cmp    $0x1,%ecx
  80060b:	7f 23                	jg     800630 <vprintfmt+0x372>
	else if (lflag)
  80060d:	85 c9                	test   %ecx,%ecx
  80060f:	0f 84 98 00 00 00    	je     8006ad <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	ba 00 00 00 00       	mov    $0x0,%edx
  80061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800622:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 40 04             	lea    0x4(%eax),%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
  80062e:	eb 17                	jmp    800647 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 50 04             	mov    0x4(%eax),%edx
  800636:	8b 00                	mov    (%eax),%eax
  800638:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 40 08             	lea    0x8(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	53                   	push   %ebx
  80064b:	6a 30                	push   $0x30
  80064d:	ff d6                	call   *%esi
			goto number;
  80064f:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800652:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800657:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80065b:	74 0b                	je     800668 <vprintfmt+0x3aa>
				putch('+', putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	53                   	push   %ebx
  800661:	6a 2b                	push   $0x2b
  800663:	ff d6                	call   *%esi
  800665:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80066f:	50                   	push   %eax
  800670:	ff 75 e0             	pushl  -0x20(%ebp)
  800673:	57                   	push   %edi
  800674:	ff 75 dc             	pushl  -0x24(%ebp)
  800677:	ff 75 d8             	pushl  -0x28(%ebp)
  80067a:	89 da                	mov    %ebx,%edx
  80067c:	89 f0                	mov    %esi,%eax
  80067e:	e8 22 fb ff ff       	call   8001a5 <printnum>
			break;
  800683:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800686:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800689:	83 c7 01             	add    $0x1,%edi
  80068c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800690:	83 f8 25             	cmp    $0x25,%eax
  800693:	0f 84 3c fc ff ff    	je     8002d5 <vprintfmt+0x17>
			if (ch == '\0')
  800699:	85 c0                	test   %eax,%eax
  80069b:	0f 84 55 01 00 00    	je     8007f6 <vprintfmt+0x538>
			putch(ch, putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	50                   	push   %eax
  8006a6:	ff d6                	call   *%esi
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	eb dc                	jmp    800689 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8d 40 04             	lea    0x4(%eax),%eax
  8006c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c6:	e9 7c ff ff ff       	jmp    800647 <vprintfmt+0x389>
			putch('0', putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	6a 30                	push   $0x30
  8006d1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d3:	83 c4 08             	add    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	6a 78                	push   $0x78
  8006d9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006eb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8d 40 04             	lea    0x4(%eax),%eax
  8006f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f7:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8006fc:	e9 56 ff ff ff       	jmp    800657 <vprintfmt+0x399>
	if (lflag >= 2)
  800701:	83 f9 01             	cmp    $0x1,%ecx
  800704:	7f 27                	jg     80072d <vprintfmt+0x46f>
	else if (lflag)
  800706:	85 c9                	test   %ecx,%ecx
  800708:	74 44                	je     80074e <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	ba 00 00 00 00       	mov    $0x0,%edx
  800714:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800717:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8d 40 04             	lea    0x4(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800723:	bf 10 00 00 00       	mov    $0x10,%edi
  800728:	e9 2a ff ff ff       	jmp    800657 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 50 04             	mov    0x4(%eax),%edx
  800733:	8b 00                	mov    (%eax),%eax
  800735:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800738:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8d 40 08             	lea    0x8(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800744:	bf 10 00 00 00       	mov    $0x10,%edi
  800749:	e9 09 ff ff ff       	jmp    800657 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
  800758:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800767:	bf 10 00 00 00       	mov    $0x10,%edi
  80076c:	e9 e6 fe ff ff       	jmp    800657 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8d 78 04             	lea    0x4(%eax),%edi
  800777:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800779:	85 c0                	test   %eax,%eax
  80077b:	74 2d                	je     8007aa <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80077d:	0f b6 13             	movzbl (%ebx),%edx
  800780:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800782:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800785:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800788:	0f 8e f8 fe ff ff    	jle    800686 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80078e:	68 40 14 80 00       	push   $0x801440
  800793:	68 f3 12 80 00       	push   $0x8012f3
  800798:	53                   	push   %ebx
  800799:	56                   	push   %esi
  80079a:	e8 02 fb ff ff       	call   8002a1 <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007a2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007a5:	e9 dc fe ff ff       	jmp    800686 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8007aa:	68 08 14 80 00       	push   $0x801408
  8007af:	68 f3 12 80 00       	push   $0x8012f3
  8007b4:	53                   	push   %ebx
  8007b5:	56                   	push   %esi
  8007b6:	e8 e6 fa ff ff       	call   8002a1 <printfmt>
  8007bb:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007be:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007c1:	e9 c0 fe ff ff       	jmp    800686 <vprintfmt+0x3c8>
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	6a 25                	push   $0x25
  8007cc:	ff d6                	call   *%esi
			break;
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	e9 b0 fe ff ff       	jmp    800686 <vprintfmt+0x3c8>
			putch('%', putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	53                   	push   %ebx
  8007da:	6a 25                	push   $0x25
  8007dc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	89 f8                	mov    %edi,%eax
  8007e3:	eb 03                	jmp    8007e8 <vprintfmt+0x52a>
  8007e5:	83 e8 01             	sub    $0x1,%eax
  8007e8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007ec:	75 f7                	jne    8007e5 <vprintfmt+0x527>
  8007ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f1:	e9 90 fe ff ff       	jmp    800686 <vprintfmt+0x3c8>
}
  8007f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f9:	5b                   	pop    %ebx
  8007fa:	5e                   	pop    %esi
  8007fb:	5f                   	pop    %edi
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80080a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80080d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800811:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80081b:	85 c0                	test   %eax,%eax
  80081d:	74 26                	je     800845 <vsnprintf+0x47>
  80081f:	85 d2                	test   %edx,%edx
  800821:	7e 22                	jle    800845 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800823:	ff 75 14             	pushl  0x14(%ebp)
  800826:	ff 75 10             	pushl  0x10(%ebp)
  800829:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80082c:	50                   	push   %eax
  80082d:	68 84 02 80 00       	push   $0x800284
  800832:	e8 87 fa ff ff       	call   8002be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80083a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80083d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800840:	83 c4 10             	add    $0x10,%esp
}
  800843:	c9                   	leave  
  800844:	c3                   	ret    
		return -E_INVAL;
  800845:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084a:	eb f7                	jmp    800843 <vsnprintf+0x45>

0080084c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800852:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800855:	50                   	push   %eax
  800856:	ff 75 10             	pushl  0x10(%ebp)
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	ff 75 08             	pushl  0x8(%ebp)
  80085f:	e8 9a ff ff ff       	call   8007fe <vsnprintf>
	va_end(ap);

	return rc;
}
  800864:	c9                   	leave  
  800865:	c3                   	ret    

00800866 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80086c:	b8 00 00 00 00       	mov    $0x0,%eax
  800871:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800875:	74 05                	je     80087c <strlen+0x16>
		n++;
  800877:	83 c0 01             	add    $0x1,%eax
  80087a:	eb f5                	jmp    800871 <strlen+0xb>
	return n;
}
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800884:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800887:	ba 00 00 00 00       	mov    $0x0,%edx
  80088c:	39 c2                	cmp    %eax,%edx
  80088e:	74 0d                	je     80089d <strnlen+0x1f>
  800890:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800894:	74 05                	je     80089b <strnlen+0x1d>
		n++;
  800896:	83 c2 01             	add    $0x1,%edx
  800899:	eb f1                	jmp    80088c <strnlen+0xe>
  80089b:	89 d0                	mov    %edx,%eax
	return n;
}
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ae:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008b2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008b5:	83 c2 01             	add    $0x1,%edx
  8008b8:	84 c9                	test   %cl,%cl
  8008ba:	75 f2                	jne    8008ae <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008bc:	5b                   	pop    %ebx
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    

008008bf <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	53                   	push   %ebx
  8008c3:	83 ec 10             	sub    $0x10,%esp
  8008c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c9:	53                   	push   %ebx
  8008ca:	e8 97 ff ff ff       	call   800866 <strlen>
  8008cf:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	01 d8                	add    %ebx,%eax
  8008d7:	50                   	push   %eax
  8008d8:	e8 c2 ff ff ff       	call   80089f <strcpy>
	return dst;
}
  8008dd:	89 d8                	mov    %ebx,%eax
  8008df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    

008008e4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ef:	89 c6                	mov    %eax,%esi
  8008f1:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f4:	89 c2                	mov    %eax,%edx
  8008f6:	39 f2                	cmp    %esi,%edx
  8008f8:	74 11                	je     80090b <strncpy+0x27>
		*dst++ = *src;
  8008fa:	83 c2 01             	add    $0x1,%edx
  8008fd:	0f b6 19             	movzbl (%ecx),%ebx
  800900:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800903:	80 fb 01             	cmp    $0x1,%bl
  800906:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800909:	eb eb                	jmp    8008f6 <strncpy+0x12>
	}
	return ret;
}
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	56                   	push   %esi
  800913:	53                   	push   %ebx
  800914:	8b 75 08             	mov    0x8(%ebp),%esi
  800917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091a:	8b 55 10             	mov    0x10(%ebp),%edx
  80091d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80091f:	85 d2                	test   %edx,%edx
  800921:	74 21                	je     800944 <strlcpy+0x35>
  800923:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800927:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800929:	39 c2                	cmp    %eax,%edx
  80092b:	74 14                	je     800941 <strlcpy+0x32>
  80092d:	0f b6 19             	movzbl (%ecx),%ebx
  800930:	84 db                	test   %bl,%bl
  800932:	74 0b                	je     80093f <strlcpy+0x30>
			*dst++ = *src++;
  800934:	83 c1 01             	add    $0x1,%ecx
  800937:	83 c2 01             	add    $0x1,%edx
  80093a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80093d:	eb ea                	jmp    800929 <strlcpy+0x1a>
  80093f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800941:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800944:	29 f0                	sub    %esi,%eax
}
  800946:	5b                   	pop    %ebx
  800947:	5e                   	pop    %esi
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800953:	0f b6 01             	movzbl (%ecx),%eax
  800956:	84 c0                	test   %al,%al
  800958:	74 0c                	je     800966 <strcmp+0x1c>
  80095a:	3a 02                	cmp    (%edx),%al
  80095c:	75 08                	jne    800966 <strcmp+0x1c>
		p++, q++;
  80095e:	83 c1 01             	add    $0x1,%ecx
  800961:	83 c2 01             	add    $0x1,%edx
  800964:	eb ed                	jmp    800953 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	0f b6 12             	movzbl (%edx),%edx
  80096c:	29 d0                	sub    %edx,%eax
}
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	53                   	push   %ebx
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097a:	89 c3                	mov    %eax,%ebx
  80097c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80097f:	eb 06                	jmp    800987 <strncmp+0x17>
		n--, p++, q++;
  800981:	83 c0 01             	add    $0x1,%eax
  800984:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800987:	39 d8                	cmp    %ebx,%eax
  800989:	74 16                	je     8009a1 <strncmp+0x31>
  80098b:	0f b6 08             	movzbl (%eax),%ecx
  80098e:	84 c9                	test   %cl,%cl
  800990:	74 04                	je     800996 <strncmp+0x26>
  800992:	3a 0a                	cmp    (%edx),%cl
  800994:	74 eb                	je     800981 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800996:	0f b6 00             	movzbl (%eax),%eax
  800999:	0f b6 12             	movzbl (%edx),%edx
  80099c:	29 d0                	sub    %edx,%eax
}
  80099e:	5b                   	pop    %ebx
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    
		return 0;
  8009a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a6:	eb f6                	jmp    80099e <strncmp+0x2e>

008009a8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b2:	0f b6 10             	movzbl (%eax),%edx
  8009b5:	84 d2                	test   %dl,%dl
  8009b7:	74 09                	je     8009c2 <strchr+0x1a>
		if (*s == c)
  8009b9:	38 ca                	cmp    %cl,%dl
  8009bb:	74 0a                	je     8009c7 <strchr+0x1f>
	for (; *s; s++)
  8009bd:	83 c0 01             	add    $0x1,%eax
  8009c0:	eb f0                	jmp    8009b2 <strchr+0xa>
			return (char *) s;
	return 0;
  8009c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009d6:	38 ca                	cmp    %cl,%dl
  8009d8:	74 09                	je     8009e3 <strfind+0x1a>
  8009da:	84 d2                	test   %dl,%dl
  8009dc:	74 05                	je     8009e3 <strfind+0x1a>
	for (; *s; s++)
  8009de:	83 c0 01             	add    $0x1,%eax
  8009e1:	eb f0                	jmp    8009d3 <strfind+0xa>
			break;
	return (char *) s;
}
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	57                   	push   %edi
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f1:	85 c9                	test   %ecx,%ecx
  8009f3:	74 31                	je     800a26 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f5:	89 f8                	mov    %edi,%eax
  8009f7:	09 c8                	or     %ecx,%eax
  8009f9:	a8 03                	test   $0x3,%al
  8009fb:	75 23                	jne    800a20 <memset+0x3b>
		c &= 0xFF;
  8009fd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a01:	89 d3                	mov    %edx,%ebx
  800a03:	c1 e3 08             	shl    $0x8,%ebx
  800a06:	89 d0                	mov    %edx,%eax
  800a08:	c1 e0 18             	shl    $0x18,%eax
  800a0b:	89 d6                	mov    %edx,%esi
  800a0d:	c1 e6 10             	shl    $0x10,%esi
  800a10:	09 f0                	or     %esi,%eax
  800a12:	09 c2                	or     %eax,%edx
  800a14:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a16:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a19:	89 d0                	mov    %edx,%eax
  800a1b:	fc                   	cld    
  800a1c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a1e:	eb 06                	jmp    800a26 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a23:	fc                   	cld    
  800a24:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a26:	89 f8                	mov    %edi,%eax
  800a28:	5b                   	pop    %ebx
  800a29:	5e                   	pop    %esi
  800a2a:	5f                   	pop    %edi
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	57                   	push   %edi
  800a31:	56                   	push   %esi
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a38:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a3b:	39 c6                	cmp    %eax,%esi
  800a3d:	73 32                	jae    800a71 <memmove+0x44>
  800a3f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	76 2b                	jbe    800a71 <memmove+0x44>
		s += n;
		d += n;
  800a46:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a49:	89 fe                	mov    %edi,%esi
  800a4b:	09 ce                	or     %ecx,%esi
  800a4d:	09 d6                	or     %edx,%esi
  800a4f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a55:	75 0e                	jne    800a65 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a57:	83 ef 04             	sub    $0x4,%edi
  800a5a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a5d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a60:	fd                   	std    
  800a61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a63:	eb 09                	jmp    800a6e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a65:	83 ef 01             	sub    $0x1,%edi
  800a68:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a6b:	fd                   	std    
  800a6c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a6e:	fc                   	cld    
  800a6f:	eb 1a                	jmp    800a8b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a71:	89 c2                	mov    %eax,%edx
  800a73:	09 ca                	or     %ecx,%edx
  800a75:	09 f2                	or     %esi,%edx
  800a77:	f6 c2 03             	test   $0x3,%dl
  800a7a:	75 0a                	jne    800a86 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a7c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a7f:	89 c7                	mov    %eax,%edi
  800a81:	fc                   	cld    
  800a82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a84:	eb 05                	jmp    800a8b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a86:	89 c7                	mov    %eax,%edi
  800a88:	fc                   	cld    
  800a89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a8b:	5e                   	pop    %esi
  800a8c:	5f                   	pop    %edi
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a95:	ff 75 10             	pushl  0x10(%ebp)
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	ff 75 08             	pushl  0x8(%ebp)
  800a9e:	e8 8a ff ff ff       	call   800a2d <memmove>
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	56                   	push   %esi
  800aa9:	53                   	push   %ebx
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab0:	89 c6                	mov    %eax,%esi
  800ab2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ab5:	39 f0                	cmp    %esi,%eax
  800ab7:	74 1c                	je     800ad5 <memcmp+0x30>
		if (*s1 != *s2)
  800ab9:	0f b6 08             	movzbl (%eax),%ecx
  800abc:	0f b6 1a             	movzbl (%edx),%ebx
  800abf:	38 d9                	cmp    %bl,%cl
  800ac1:	75 08                	jne    800acb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ac3:	83 c0 01             	add    $0x1,%eax
  800ac6:	83 c2 01             	add    $0x1,%edx
  800ac9:	eb ea                	jmp    800ab5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800acb:	0f b6 c1             	movzbl %cl,%eax
  800ace:	0f b6 db             	movzbl %bl,%ebx
  800ad1:	29 d8                	sub    %ebx,%eax
  800ad3:	eb 05                	jmp    800ada <memcmp+0x35>
	}

	return 0;
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ada:	5b                   	pop    %ebx
  800adb:	5e                   	pop    %esi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ae7:	89 c2                	mov    %eax,%edx
  800ae9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aec:	39 d0                	cmp    %edx,%eax
  800aee:	73 09                	jae    800af9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af0:	38 08                	cmp    %cl,(%eax)
  800af2:	74 05                	je     800af9 <memfind+0x1b>
	for (; s < ends; s++)
  800af4:	83 c0 01             	add    $0x1,%eax
  800af7:	eb f3                	jmp    800aec <memfind+0xe>
			break;
	return (void *) s;
}
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	57                   	push   %edi
  800aff:	56                   	push   %esi
  800b00:	53                   	push   %ebx
  800b01:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b04:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b07:	eb 03                	jmp    800b0c <strtol+0x11>
		s++;
  800b09:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b0c:	0f b6 01             	movzbl (%ecx),%eax
  800b0f:	3c 20                	cmp    $0x20,%al
  800b11:	74 f6                	je     800b09 <strtol+0xe>
  800b13:	3c 09                	cmp    $0x9,%al
  800b15:	74 f2                	je     800b09 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b17:	3c 2b                	cmp    $0x2b,%al
  800b19:	74 2a                	je     800b45 <strtol+0x4a>
	int neg = 0;
  800b1b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b20:	3c 2d                	cmp    $0x2d,%al
  800b22:	74 2b                	je     800b4f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b24:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b2a:	75 0f                	jne    800b3b <strtol+0x40>
  800b2c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b2f:	74 28                	je     800b59 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b31:	85 db                	test   %ebx,%ebx
  800b33:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b38:	0f 44 d8             	cmove  %eax,%ebx
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b43:	eb 50                	jmp    800b95 <strtol+0x9a>
		s++;
  800b45:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b48:	bf 00 00 00 00       	mov    $0x0,%edi
  800b4d:	eb d5                	jmp    800b24 <strtol+0x29>
		s++, neg = 1;
  800b4f:	83 c1 01             	add    $0x1,%ecx
  800b52:	bf 01 00 00 00       	mov    $0x1,%edi
  800b57:	eb cb                	jmp    800b24 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b59:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b5d:	74 0e                	je     800b6d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b5f:	85 db                	test   %ebx,%ebx
  800b61:	75 d8                	jne    800b3b <strtol+0x40>
		s++, base = 8;
  800b63:	83 c1 01             	add    $0x1,%ecx
  800b66:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b6b:	eb ce                	jmp    800b3b <strtol+0x40>
		s += 2, base = 16;
  800b6d:	83 c1 02             	add    $0x2,%ecx
  800b70:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b75:	eb c4                	jmp    800b3b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b77:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b7a:	89 f3                	mov    %esi,%ebx
  800b7c:	80 fb 19             	cmp    $0x19,%bl
  800b7f:	77 29                	ja     800baa <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b81:	0f be d2             	movsbl %dl,%edx
  800b84:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b87:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b8a:	7d 30                	jge    800bbc <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b8c:	83 c1 01             	add    $0x1,%ecx
  800b8f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b93:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b95:	0f b6 11             	movzbl (%ecx),%edx
  800b98:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b9b:	89 f3                	mov    %esi,%ebx
  800b9d:	80 fb 09             	cmp    $0x9,%bl
  800ba0:	77 d5                	ja     800b77 <strtol+0x7c>
			dig = *s - '0';
  800ba2:	0f be d2             	movsbl %dl,%edx
  800ba5:	83 ea 30             	sub    $0x30,%edx
  800ba8:	eb dd                	jmp    800b87 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800baa:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bad:	89 f3                	mov    %esi,%ebx
  800baf:	80 fb 19             	cmp    $0x19,%bl
  800bb2:	77 08                	ja     800bbc <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bb4:	0f be d2             	movsbl %dl,%edx
  800bb7:	83 ea 37             	sub    $0x37,%edx
  800bba:	eb cb                	jmp    800b87 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc0:	74 05                	je     800bc7 <strtol+0xcc>
		*endptr = (char *) s;
  800bc2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bc7:	89 c2                	mov    %eax,%edx
  800bc9:	f7 da                	neg    %edx
  800bcb:	85 ff                	test   %edi,%edi
  800bcd:	0f 45 c2             	cmovne %edx,%eax
}
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800be0:	8b 55 08             	mov    0x8(%ebp),%edx
  800be3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be6:	89 c3                	mov    %eax,%ebx
  800be8:	89 c7                	mov    %eax,%edi
  800bea:	89 c6                	mov    %eax,%esi
  800bec:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  800c03:	89 d1                	mov    %edx,%ecx
  800c05:	89 d3                	mov    %edx,%ebx
  800c07:	89 d7                	mov    %edx,%edi
  800c09:	89 d6                	mov    %edx,%esi
  800c0b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5f                   	pop    %edi
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	89 cb                	mov    %ecx,%ebx
  800c2a:	89 cf                	mov    %ecx,%edi
  800c2c:	89 ce                	mov    %ecx,%esi
  800c2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	7f 08                	jg     800c3c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 03                	push   $0x3
  800c42:	68 60 16 80 00       	push   $0x801660
  800c47:	6a 33                	push   $0x33
  800c49:	68 7d 16 80 00       	push   $0x80167d
  800c4e:	e8 a0 03 00 00       	call   800ff3 <_panic>

00800c53 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c59:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c63:	89 d1                	mov    %edx,%ecx
  800c65:	89 d3                	mov    %edx,%ebx
  800c67:	89 d7                	mov    %edx,%edi
  800c69:	89 d6                	mov    %edx,%esi
  800c6b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <sys_yield>:

void
sys_yield(void)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c78:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c82:	89 d1                	mov    %edx,%ecx
  800c84:	89 d3                	mov    %edx,%ebx
  800c86:	89 d7                	mov    %edx,%edi
  800c88:	89 d6                	mov    %edx,%esi
  800c8a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9a:	be 00 00 00 00       	mov    $0x0,%esi
  800c9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca5:	b8 04 00 00 00       	mov    $0x4,%eax
  800caa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cad:	89 f7                	mov    %esi,%edi
  800caf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	7f 08                	jg     800cbd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800cc1:	6a 04                	push   $0x4
  800cc3:	68 60 16 80 00       	push   $0x801660
  800cc8:	6a 33                	push   $0x33
  800cca:	68 7d 16 80 00       	push   $0x80167d
  800ccf:	e8 1f 03 00 00       	call   800ff3 <_panic>

00800cd4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ceb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cee:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7f 08                	jg     800cff <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d03:	6a 05                	push   $0x5
  800d05:	68 60 16 80 00       	push   $0x801660
  800d0a:	6a 33                	push   $0x33
  800d0c:	68 7d 16 80 00       	push   $0x80167d
  800d11:	e8 dd 02 00 00       	call   800ff3 <_panic>

00800d16 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d2f:	89 df                	mov    %ebx,%edi
  800d31:	89 de                	mov    %ebx,%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d45:	6a 06                	push   $0x6
  800d47:	68 60 16 80 00       	push   $0x801660
  800d4c:	6a 33                	push   $0x33
  800d4e:	68 7d 16 80 00       	push   $0x80167d
  800d53:	e8 9b 02 00 00       	call   800ff3 <_panic>

00800d58 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d6e:	89 cb                	mov    %ecx,%ebx
  800d70:	89 cf                	mov    %ecx,%edi
  800d72:	89 ce                	mov    %ecx,%esi
  800d74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d76:	85 c0                	test   %eax,%eax
  800d78:	7f 08                	jg     800d82 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7d:	5b                   	pop    %ebx
  800d7e:	5e                   	pop    %esi
  800d7f:	5f                   	pop    %edi
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d82:	83 ec 0c             	sub    $0xc,%esp
  800d85:	50                   	push   %eax
  800d86:	6a 0b                	push   $0xb
  800d88:	68 60 16 80 00       	push   $0x801660
  800d8d:	6a 33                	push   $0x33
  800d8f:	68 7d 16 80 00       	push   $0x80167d
  800d94:	e8 5a 02 00 00       	call   800ff3 <_panic>

00800d99 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dad:	b8 08 00 00 00       	mov    $0x8,%eax
  800db2:	89 df                	mov    %ebx,%edi
  800db4:	89 de                	mov    %ebx,%esi
  800db6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db8:	85 c0                	test   %eax,%eax
  800dba:	7f 08                	jg     800dc4 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800dc8:	6a 08                	push   $0x8
  800dca:	68 60 16 80 00       	push   $0x801660
  800dcf:	6a 33                	push   $0x33
  800dd1:	68 7d 16 80 00       	push   $0x80167d
  800dd6:	e8 18 02 00 00       	call   800ff3 <_panic>

00800ddb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800def:	b8 09 00 00 00       	mov    $0x9,%eax
  800df4:	89 df                	mov    %ebx,%edi
  800df6:	89 de                	mov    %ebx,%esi
  800df8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	7f 08                	jg     800e06 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800e0a:	6a 09                	push   $0x9
  800e0c:	68 60 16 80 00       	push   $0x801660
  800e11:	6a 33                	push   $0x33
  800e13:	68 7d 16 80 00       	push   $0x80167d
  800e18:	e8 d6 01 00 00       	call   800ff3 <_panic>

00800e1d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e36:	89 df                	mov    %ebx,%edi
  800e38:	89 de                	mov    %ebx,%esi
  800e3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7f 08                	jg     800e48 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e4c:	6a 0a                	push   $0xa
  800e4e:	68 60 16 80 00       	push   $0x801660
  800e53:	6a 33                	push   $0x33
  800e55:	68 7d 16 80 00       	push   $0x80167d
  800e5a:	e8 94 01 00 00       	call   800ff3 <_panic>

00800e5f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	57                   	push   %edi
  800e63:	56                   	push   %esi
  800e64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e70:	be 00 00 00 00       	mov    $0x0,%esi
  800e75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e78:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
  800e88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e98:	89 cb                	mov    %ecx,%ebx
  800e9a:	89 cf                	mov    %ecx,%edi
  800e9c:	89 ce                	mov    %ecx,%esi
  800e9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	7f 08                	jg     800eac <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eac:	83 ec 0c             	sub    $0xc,%esp
  800eaf:	50                   	push   %eax
  800eb0:	6a 0e                	push   $0xe
  800eb2:	68 60 16 80 00       	push   $0x801660
  800eb7:	6a 33                	push   $0x33
  800eb9:	68 7d 16 80 00       	push   $0x80167d
  800ebe:	e8 30 01 00 00       	call   800ff3 <_panic>

00800ec3 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed4:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ed9:	89 df                	mov    %ebx,%edi
  800edb:	89 de                	mov    %ebx,%esi
  800edd:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	57                   	push   %edi
  800ee8:	56                   	push   %esi
  800ee9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ef7:	89 cb                	mov    %ecx,%ebx
  800ef9:	89 cf                	mov    %ecx,%edi
  800efb:	89 ce                	mov    %ecx,%esi
  800efd:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	8b 75 08             	mov    0x8(%ebp),%esi
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  800f12:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  800f14:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800f19:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	e8 5d ff ff ff       	call   800e82 <sys_ipc_recv>
	if (from_env_store)
  800f25:	83 c4 10             	add    $0x10,%esp
  800f28:	85 f6                	test   %esi,%esi
  800f2a:	74 14                	je     800f40 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  800f2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f31:	85 c0                	test   %eax,%eax
  800f33:	78 09                	js     800f3e <ipc_recv+0x3a>
  800f35:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800f3b:	8b 52 78             	mov    0x78(%edx),%edx
  800f3e:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  800f40:	85 db                	test   %ebx,%ebx
  800f42:	74 14                	je     800f58 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  800f44:	ba 00 00 00 00       	mov    $0x0,%edx
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	78 09                	js     800f56 <ipc_recv+0x52>
  800f4d:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800f53:	8b 52 7c             	mov    0x7c(%edx),%edx
  800f56:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	78 08                	js     800f64 <ipc_recv+0x60>
  800f5c:	a1 04 20 80 00       	mov    0x802004,%eax
  800f61:	8b 40 74             	mov    0x74(%eax),%eax
}
  800f64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	83 ec 08             	sub    $0x8,%esp
  800f71:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  800f74:	85 c0                	test   %eax,%eax
  800f76:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800f7b:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  800f7e:	ff 75 14             	pushl  0x14(%ebp)
  800f81:	50                   	push   %eax
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	ff 75 08             	pushl  0x8(%ebp)
  800f88:	e8 d2 fe ff ff       	call   800e5f <sys_ipc_try_send>
  800f8d:	83 c4 10             	add    $0x10,%esp
  800f90:	85 c0                	test   %eax,%eax
  800f92:	78 02                	js     800f96 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  800f96:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800f99:	75 07                	jne    800fa2 <ipc_send+0x37>
		sys_yield();
  800f9b:	e8 d2 fc ff ff       	call   800c72 <sys_yield>
}
  800fa0:	eb f2                	jmp    800f94 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  800fa2:	50                   	push   %eax
  800fa3:	68 8b 16 80 00       	push   $0x80168b
  800fa8:	6a 3c                	push   $0x3c
  800faa:	68 9f 16 80 00       	push   $0x80169f
  800faf:	e8 3f 00 00 00       	call   800ff3 <_panic>

00800fb4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800fba:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  800fbf:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  800fc2:	c1 e0 04             	shl    $0x4,%eax
  800fc5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fca:	8b 40 50             	mov    0x50(%eax),%eax
  800fcd:	39 c8                	cmp    %ecx,%eax
  800fcf:	74 12                	je     800fe3 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  800fd1:	83 c2 01             	add    $0x1,%edx
  800fd4:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800fda:	75 e3                	jne    800fbf <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe1:	eb 0e                	jmp    800ff1 <ipc_find_env+0x3d>
			return envs[i].env_id;
  800fe3:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  800fe6:	c1 e0 04             	shl    $0x4,%eax
  800fe9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fee:	8b 40 48             	mov    0x48(%eax),%eax
}
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    

00800ff3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800ff8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ffb:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801001:	e8 4d fc ff ff       	call   800c53 <sys_getenvid>
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	ff 75 08             	pushl  0x8(%ebp)
  80100f:	56                   	push   %esi
  801010:	50                   	push   %eax
  801011:	68 ac 16 80 00       	push   $0x8016ac
  801016:	e8 76 f1 ff ff       	call   800191 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80101b:	83 c4 18             	add    $0x18,%esp
  80101e:	53                   	push   %ebx
  80101f:	ff 75 10             	pushl  0x10(%ebp)
  801022:	e8 19 f1 ff ff       	call   800140 <vcprintf>
	cprintf("\n");
  801027:	c7 04 24 af 12 80 00 	movl   $0x8012af,(%esp)
  80102e:	e8 5e f1 ff ff       	call   800191 <cprintf>
  801033:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801036:	cc                   	int3   
  801037:	eb fd                	jmp    801036 <_panic+0x43>
  801039:	66 90                	xchg   %ax,%ax
  80103b:	66 90                	xchg   %ax,%ax
  80103d:	66 90                	xchg   %ax,%ax
  80103f:	90                   	nop

00801040 <__udivdi3>:
  801040:	55                   	push   %ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	83 ec 1c             	sub    $0x1c,%esp
  801047:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80104b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80104f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801053:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801057:	85 d2                	test   %edx,%edx
  801059:	75 4d                	jne    8010a8 <__udivdi3+0x68>
  80105b:	39 f3                	cmp    %esi,%ebx
  80105d:	76 19                	jbe    801078 <__udivdi3+0x38>
  80105f:	31 ff                	xor    %edi,%edi
  801061:	89 e8                	mov    %ebp,%eax
  801063:	89 f2                	mov    %esi,%edx
  801065:	f7 f3                	div    %ebx
  801067:	89 fa                	mov    %edi,%edx
  801069:	83 c4 1c             	add    $0x1c,%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
  801071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801078:	89 d9                	mov    %ebx,%ecx
  80107a:	85 db                	test   %ebx,%ebx
  80107c:	75 0b                	jne    801089 <__udivdi3+0x49>
  80107e:	b8 01 00 00 00       	mov    $0x1,%eax
  801083:	31 d2                	xor    %edx,%edx
  801085:	f7 f3                	div    %ebx
  801087:	89 c1                	mov    %eax,%ecx
  801089:	31 d2                	xor    %edx,%edx
  80108b:	89 f0                	mov    %esi,%eax
  80108d:	f7 f1                	div    %ecx
  80108f:	89 c6                	mov    %eax,%esi
  801091:	89 e8                	mov    %ebp,%eax
  801093:	89 f7                	mov    %esi,%edi
  801095:	f7 f1                	div    %ecx
  801097:	89 fa                	mov    %edi,%edx
  801099:	83 c4 1c             	add    $0x1c,%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    
  8010a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010a8:	39 f2                	cmp    %esi,%edx
  8010aa:	77 1c                	ja     8010c8 <__udivdi3+0x88>
  8010ac:	0f bd fa             	bsr    %edx,%edi
  8010af:	83 f7 1f             	xor    $0x1f,%edi
  8010b2:	75 2c                	jne    8010e0 <__udivdi3+0xa0>
  8010b4:	39 f2                	cmp    %esi,%edx
  8010b6:	72 06                	jb     8010be <__udivdi3+0x7e>
  8010b8:	31 c0                	xor    %eax,%eax
  8010ba:	39 eb                	cmp    %ebp,%ebx
  8010bc:	77 a9                	ja     801067 <__udivdi3+0x27>
  8010be:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c3:	eb a2                	jmp    801067 <__udivdi3+0x27>
  8010c5:	8d 76 00             	lea    0x0(%esi),%esi
  8010c8:	31 ff                	xor    %edi,%edi
  8010ca:	31 c0                	xor    %eax,%eax
  8010cc:	89 fa                	mov    %edi,%edx
  8010ce:	83 c4 1c             	add    $0x1c,%esp
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    
  8010d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010dd:	8d 76 00             	lea    0x0(%esi),%esi
  8010e0:	89 f9                	mov    %edi,%ecx
  8010e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8010e7:	29 f8                	sub    %edi,%eax
  8010e9:	d3 e2                	shl    %cl,%edx
  8010eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010ef:	89 c1                	mov    %eax,%ecx
  8010f1:	89 da                	mov    %ebx,%edx
  8010f3:	d3 ea                	shr    %cl,%edx
  8010f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010f9:	09 d1                	or     %edx,%ecx
  8010fb:	89 f2                	mov    %esi,%edx
  8010fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801101:	89 f9                	mov    %edi,%ecx
  801103:	d3 e3                	shl    %cl,%ebx
  801105:	89 c1                	mov    %eax,%ecx
  801107:	d3 ea                	shr    %cl,%edx
  801109:	89 f9                	mov    %edi,%ecx
  80110b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80110f:	89 eb                	mov    %ebp,%ebx
  801111:	d3 e6                	shl    %cl,%esi
  801113:	89 c1                	mov    %eax,%ecx
  801115:	d3 eb                	shr    %cl,%ebx
  801117:	09 de                	or     %ebx,%esi
  801119:	89 f0                	mov    %esi,%eax
  80111b:	f7 74 24 08          	divl   0x8(%esp)
  80111f:	89 d6                	mov    %edx,%esi
  801121:	89 c3                	mov    %eax,%ebx
  801123:	f7 64 24 0c          	mull   0xc(%esp)
  801127:	39 d6                	cmp    %edx,%esi
  801129:	72 15                	jb     801140 <__udivdi3+0x100>
  80112b:	89 f9                	mov    %edi,%ecx
  80112d:	d3 e5                	shl    %cl,%ebp
  80112f:	39 c5                	cmp    %eax,%ebp
  801131:	73 04                	jae    801137 <__udivdi3+0xf7>
  801133:	39 d6                	cmp    %edx,%esi
  801135:	74 09                	je     801140 <__udivdi3+0x100>
  801137:	89 d8                	mov    %ebx,%eax
  801139:	31 ff                	xor    %edi,%edi
  80113b:	e9 27 ff ff ff       	jmp    801067 <__udivdi3+0x27>
  801140:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801143:	31 ff                	xor    %edi,%edi
  801145:	e9 1d ff ff ff       	jmp    801067 <__udivdi3+0x27>
  80114a:	66 90                	xchg   %ax,%ax
  80114c:	66 90                	xchg   %ax,%ax
  80114e:	66 90                	xchg   %ax,%ax

00801150 <__umoddi3>:
  801150:	55                   	push   %ebp
  801151:	57                   	push   %edi
  801152:	56                   	push   %esi
  801153:	53                   	push   %ebx
  801154:	83 ec 1c             	sub    $0x1c,%esp
  801157:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80115b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80115f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801163:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801167:	89 da                	mov    %ebx,%edx
  801169:	85 c0                	test   %eax,%eax
  80116b:	75 43                	jne    8011b0 <__umoddi3+0x60>
  80116d:	39 df                	cmp    %ebx,%edi
  80116f:	76 17                	jbe    801188 <__umoddi3+0x38>
  801171:	89 f0                	mov    %esi,%eax
  801173:	f7 f7                	div    %edi
  801175:	89 d0                	mov    %edx,%eax
  801177:	31 d2                	xor    %edx,%edx
  801179:	83 c4 1c             	add    $0x1c,%esp
  80117c:	5b                   	pop    %ebx
  80117d:	5e                   	pop    %esi
  80117e:	5f                   	pop    %edi
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    
  801181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801188:	89 fd                	mov    %edi,%ebp
  80118a:	85 ff                	test   %edi,%edi
  80118c:	75 0b                	jne    801199 <__umoddi3+0x49>
  80118e:	b8 01 00 00 00       	mov    $0x1,%eax
  801193:	31 d2                	xor    %edx,%edx
  801195:	f7 f7                	div    %edi
  801197:	89 c5                	mov    %eax,%ebp
  801199:	89 d8                	mov    %ebx,%eax
  80119b:	31 d2                	xor    %edx,%edx
  80119d:	f7 f5                	div    %ebp
  80119f:	89 f0                	mov    %esi,%eax
  8011a1:	f7 f5                	div    %ebp
  8011a3:	89 d0                	mov    %edx,%eax
  8011a5:	eb d0                	jmp    801177 <__umoddi3+0x27>
  8011a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011ae:	66 90                	xchg   %ax,%ax
  8011b0:	89 f1                	mov    %esi,%ecx
  8011b2:	39 d8                	cmp    %ebx,%eax
  8011b4:	76 0a                	jbe    8011c0 <__umoddi3+0x70>
  8011b6:	89 f0                	mov    %esi,%eax
  8011b8:	83 c4 1c             	add    $0x1c,%esp
  8011bb:	5b                   	pop    %ebx
  8011bc:	5e                   	pop    %esi
  8011bd:	5f                   	pop    %edi
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    
  8011c0:	0f bd e8             	bsr    %eax,%ebp
  8011c3:	83 f5 1f             	xor    $0x1f,%ebp
  8011c6:	75 20                	jne    8011e8 <__umoddi3+0x98>
  8011c8:	39 d8                	cmp    %ebx,%eax
  8011ca:	0f 82 b0 00 00 00    	jb     801280 <__umoddi3+0x130>
  8011d0:	39 f7                	cmp    %esi,%edi
  8011d2:	0f 86 a8 00 00 00    	jbe    801280 <__umoddi3+0x130>
  8011d8:	89 c8                	mov    %ecx,%eax
  8011da:	83 c4 1c             	add    $0x1c,%esp
  8011dd:	5b                   	pop    %ebx
  8011de:	5e                   	pop    %esi
  8011df:	5f                   	pop    %edi
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
  8011e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011e8:	89 e9                	mov    %ebp,%ecx
  8011ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8011ef:	29 ea                	sub    %ebp,%edx
  8011f1:	d3 e0                	shl    %cl,%eax
  8011f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011f7:	89 d1                	mov    %edx,%ecx
  8011f9:	89 f8                	mov    %edi,%eax
  8011fb:	d3 e8                	shr    %cl,%eax
  8011fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801201:	89 54 24 04          	mov    %edx,0x4(%esp)
  801205:	8b 54 24 04          	mov    0x4(%esp),%edx
  801209:	09 c1                	or     %eax,%ecx
  80120b:	89 d8                	mov    %ebx,%eax
  80120d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801211:	89 e9                	mov    %ebp,%ecx
  801213:	d3 e7                	shl    %cl,%edi
  801215:	89 d1                	mov    %edx,%ecx
  801217:	d3 e8                	shr    %cl,%eax
  801219:	89 e9                	mov    %ebp,%ecx
  80121b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80121f:	d3 e3                	shl    %cl,%ebx
  801221:	89 c7                	mov    %eax,%edi
  801223:	89 d1                	mov    %edx,%ecx
  801225:	89 f0                	mov    %esi,%eax
  801227:	d3 e8                	shr    %cl,%eax
  801229:	89 e9                	mov    %ebp,%ecx
  80122b:	89 fa                	mov    %edi,%edx
  80122d:	d3 e6                	shl    %cl,%esi
  80122f:	09 d8                	or     %ebx,%eax
  801231:	f7 74 24 08          	divl   0x8(%esp)
  801235:	89 d1                	mov    %edx,%ecx
  801237:	89 f3                	mov    %esi,%ebx
  801239:	f7 64 24 0c          	mull   0xc(%esp)
  80123d:	89 c6                	mov    %eax,%esi
  80123f:	89 d7                	mov    %edx,%edi
  801241:	39 d1                	cmp    %edx,%ecx
  801243:	72 06                	jb     80124b <__umoddi3+0xfb>
  801245:	75 10                	jne    801257 <__umoddi3+0x107>
  801247:	39 c3                	cmp    %eax,%ebx
  801249:	73 0c                	jae    801257 <__umoddi3+0x107>
  80124b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80124f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801253:	89 d7                	mov    %edx,%edi
  801255:	89 c6                	mov    %eax,%esi
  801257:	89 ca                	mov    %ecx,%edx
  801259:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80125e:	29 f3                	sub    %esi,%ebx
  801260:	19 fa                	sbb    %edi,%edx
  801262:	89 d0                	mov    %edx,%eax
  801264:	d3 e0                	shl    %cl,%eax
  801266:	89 e9                	mov    %ebp,%ecx
  801268:	d3 eb                	shr    %cl,%ebx
  80126a:	d3 ea                	shr    %cl,%edx
  80126c:	09 d8                	or     %ebx,%eax
  80126e:	83 c4 1c             	add    $0x1c,%esp
  801271:	5b                   	pop    %ebx
  801272:	5e                   	pop    %esi
  801273:	5f                   	pop    %edi
  801274:	5d                   	pop    %ebp
  801275:	c3                   	ret    
  801276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80127d:	8d 76 00             	lea    0x0(%esi),%esi
  801280:	89 da                	mov    %ebx,%edx
  801282:	29 fe                	sub    %edi,%esi
  801284:	19 c2                	sbb    %eax,%edx
  801286:	89 f1                	mov    %esi,%ecx
  801288:	89 c8                	mov    %ecx,%eax
  80128a:	e9 4b ff ff ff       	jmp    8011da <__umoddi3+0x8a>
