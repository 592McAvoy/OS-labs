
obj/user/spawnfaultio.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 04 40 80 00       	mov    0x804004,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 40 25 80 00       	push   $0x802540
  800047:	e8 65 01 00 00       	call   8001b1 <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 5e 25 80 00       	push   $0x80255e
  800056:	68 5e 25 80 00       	push   $0x80255e
  80005b:	e8 34 14 00 00       	call   801494 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(faultio) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 66 25 80 00       	push   $0x802566
  80006f:	6a 09                	push   $0x9
  800071:	68 80 25 80 00       	push   $0x802580
  800076:	e8 5b 00 00 00       	call   8000d6 <_panic>

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	e8 e8 0b 00 00       	call   800c73 <sys_getenvid>
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800093:	c1 e0 04             	shl    $0x4,%eax
  800096:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a0:	85 db                	test   %ebx,%ebx
  8000a2:	7e 07                	jle    8000ab <libmain+0x30>
		binaryname = argv[0];
  8000a4:	8b 06                	mov    (%esi),%eax
  8000a6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ab:	83 ec 08             	sub    $0x8,%esp
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	e8 7e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b5:	e8 0a 00 00 00       	call   8000c4 <exit>
}
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    

008000c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8000ca:	6a 00                	push   $0x0
  8000cc:	e8 61 0b 00 00       	call   800c32 <sys_env_destroy>
}
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    

008000d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000db:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000de:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000e4:	e8 8a 0b 00 00       	call   800c73 <sys_getenvid>
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	ff 75 0c             	pushl  0xc(%ebp)
  8000ef:	ff 75 08             	pushl  0x8(%ebp)
  8000f2:	56                   	push   %esi
  8000f3:	50                   	push   %eax
  8000f4:	68 a0 25 80 00       	push   $0x8025a0
  8000f9:	e8 b3 00 00 00       	call   8001b1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8000fe:	83 c4 18             	add    $0x18,%esp
  800101:	53                   	push   %ebx
  800102:	ff 75 10             	pushl  0x10(%ebp)
  800105:	e8 56 00 00 00       	call   800160 <vcprintf>
	cprintf("\n");
  80010a:	c7 04 24 fa 2a 80 00 	movl   $0x802afa,(%esp)
  800111:	e8 9b 00 00 00       	call   8001b1 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800119:	cc                   	int3   
  80011a:	eb fd                	jmp    800119 <_panic+0x43>

0080011c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	53                   	push   %ebx
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800126:	8b 13                	mov    (%ebx),%edx
  800128:	8d 42 01             	lea    0x1(%edx),%eax
  80012b:	89 03                	mov    %eax,(%ebx)
  80012d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800130:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800134:	3d ff 00 00 00       	cmp    $0xff,%eax
  800139:	74 09                	je     800144 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800142:	c9                   	leave  
  800143:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800144:	83 ec 08             	sub    $0x8,%esp
  800147:	68 ff 00 00 00       	push   $0xff
  80014c:	8d 43 08             	lea    0x8(%ebx),%eax
  80014f:	50                   	push   %eax
  800150:	e8 a0 0a 00 00       	call   800bf5 <sys_cputs>
		b->idx = 0;
  800155:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	eb db                	jmp    80013b <putch+0x1f>

00800160 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800169:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800170:	00 00 00 
	b.cnt = 0;
  800173:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017d:	ff 75 0c             	pushl  0xc(%ebp)
  800180:	ff 75 08             	pushl  0x8(%ebp)
  800183:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800189:	50                   	push   %eax
  80018a:	68 1c 01 80 00       	push   $0x80011c
  80018f:	e8 4a 01 00 00       	call   8002de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800194:	83 c4 08             	add    $0x8,%esp
  800197:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a3:	50                   	push   %eax
  8001a4:	e8 4c 0a 00 00       	call   800bf5 <sys_cputs>

	return b.cnt;
}
  8001a9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ba:	50                   	push   %eax
  8001bb:	ff 75 08             	pushl  0x8(%ebp)
  8001be:	e8 9d ff ff ff       	call   800160 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    

008001c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	57                   	push   %edi
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 1c             	sub    $0x1c,%esp
  8001ce:	89 c6                	mov    %eax,%esi
  8001d0:	89 d7                	mov    %edx,%edi
  8001d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001e4:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e8:	74 2c                	je     800216 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001ff:	73 43                	jae    800244 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800201:	83 eb 01             	sub    $0x1,%ebx
  800204:	85 db                	test   %ebx,%ebx
  800206:	7e 6c                	jle    800274 <printnum+0xaf>
			putch(padc, putdat);
  800208:	83 ec 08             	sub    $0x8,%esp
  80020b:	57                   	push   %edi
  80020c:	ff 75 18             	pushl  0x18(%ebp)
  80020f:	ff d6                	call   *%esi
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	eb eb                	jmp    800201 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	6a 20                	push   $0x20
  80021b:	6a 00                	push   $0x0
  80021d:	50                   	push   %eax
  80021e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800221:	ff 75 e0             	pushl  -0x20(%ebp)
  800224:	89 fa                	mov    %edi,%edx
  800226:	89 f0                	mov    %esi,%eax
  800228:	e8 98 ff ff ff       	call   8001c5 <printnum>
		while (--width > 0)
  80022d:	83 c4 20             	add    $0x20,%esp
  800230:	83 eb 01             	sub    $0x1,%ebx
  800233:	85 db                	test   %ebx,%ebx
  800235:	7e 65                	jle    80029c <printnum+0xd7>
			putch(padc, putdat);
  800237:	83 ec 08             	sub    $0x8,%esp
  80023a:	57                   	push   %edi
  80023b:	6a 20                	push   $0x20
  80023d:	ff d6                	call   *%esi
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	eb ec                	jmp    800230 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	ff 75 18             	pushl  0x18(%ebp)
  80024a:	83 eb 01             	sub    $0x1,%ebx
  80024d:	53                   	push   %ebx
  80024e:	50                   	push   %eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 dc             	pushl  -0x24(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025b:	ff 75 e0             	pushl  -0x20(%ebp)
  80025e:	e8 8d 20 00 00       	call   8022f0 <__udivdi3>
  800263:	83 c4 18             	add    $0x18,%esp
  800266:	52                   	push   %edx
  800267:	50                   	push   %eax
  800268:	89 fa                	mov    %edi,%edx
  80026a:	89 f0                	mov    %esi,%eax
  80026c:	e8 54 ff ff ff       	call   8001c5 <printnum>
  800271:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	57                   	push   %edi
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	ff 75 dc             	pushl  -0x24(%ebp)
  80027e:	ff 75 d8             	pushl  -0x28(%ebp)
  800281:	ff 75 e4             	pushl  -0x1c(%ebp)
  800284:	ff 75 e0             	pushl  -0x20(%ebp)
  800287:	e8 74 21 00 00       	call   802400 <__umoddi3>
  80028c:	83 c4 14             	add    $0x14,%esp
  80028f:	0f be 80 c3 25 80 00 	movsbl 0x8025c3(%eax),%eax
  800296:	50                   	push   %eax
  800297:	ff d6                	call   *%esi
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    

008002a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002aa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ae:	8b 10                	mov    (%eax),%edx
  8002b0:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b3:	73 0a                	jae    8002bf <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b8:	89 08                	mov    %ecx,(%eax)
  8002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bd:	88 02                	mov    %al,(%edx)
}
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    

008002c1 <printfmt>:
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ca:	50                   	push   %eax
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	ff 75 0c             	pushl  0xc(%ebp)
  8002d1:	ff 75 08             	pushl  0x8(%ebp)
  8002d4:	e8 05 00 00 00       	call   8002de <vprintfmt>
}
  8002d9:	83 c4 10             	add    $0x10,%esp
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <vprintfmt>:
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 3c             	sub    $0x3c,%esp
  8002e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ed:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f0:	e9 b4 03 00 00       	jmp    8006a9 <vprintfmt+0x3cb>
		padc = ' ';
  8002f5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8002f9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800300:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800307:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80030e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800315:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031a:	8d 47 01             	lea    0x1(%edi),%eax
  80031d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800320:	0f b6 17             	movzbl (%edi),%edx
  800323:	8d 42 dd             	lea    -0x23(%edx),%eax
  800326:	3c 55                	cmp    $0x55,%al
  800328:	0f 87 c8 04 00 00    	ja     8007f6 <vprintfmt+0x518>
  80032e:	0f b6 c0             	movzbl %al,%eax
  800331:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  800338:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80033b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800342:	eb d6                	jmp    80031a <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800347:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80034b:	eb cd                	jmp    80031a <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	0f b6 d2             	movzbl %dl,%edx
  800350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80035b:	eb 0c                	jmp    800369 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800360:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800364:	eb b4                	jmp    80031a <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800366:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800369:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800370:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800373:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800376:	83 f9 09             	cmp    $0x9,%ecx
  800379:	76 eb                	jbe    800366 <vprintfmt+0x88>
  80037b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80037e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800381:	eb 14                	jmp    800397 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800383:	8b 45 14             	mov    0x14(%ebp),%eax
  800386:	8b 00                	mov    (%eax),%eax
  800388:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038b:	8b 45 14             	mov    0x14(%ebp),%eax
  80038e:	8d 40 04             	lea    0x4(%eax),%eax
  800391:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039b:	0f 89 79 ff ff ff    	jns    80031a <vprintfmt+0x3c>
				width = precision, precision = -1;
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ae:	e9 67 ff ff ff       	jmp    80031a <vprintfmt+0x3c>
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bd:	0f 49 d0             	cmovns %eax,%edx
  8003c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c6:	e9 4f ff ff ff       	jmp    80031a <vprintfmt+0x3c>
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ce:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003d5:	e9 40 ff ff ff       	jmp    80031a <vprintfmt+0x3c>
			lflag++;
  8003da:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e0:	e9 35 ff ff ff       	jmp    80031a <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	8d 78 04             	lea    0x4(%eax),%edi
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	53                   	push   %ebx
  8003ef:	ff 30                	pushl  (%eax)
  8003f1:	ff d6                	call   *%esi
			break;
  8003f3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f9:	e9 a8 02 00 00       	jmp    8006a6 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8d 78 04             	lea    0x4(%eax),%edi
  800404:	8b 00                	mov    (%eax),%eax
  800406:	99                   	cltd   
  800407:	31 d0                	xor    %edx,%eax
  800409:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040b:	83 f8 0f             	cmp    $0xf,%eax
  80040e:	7f 23                	jg     800433 <vprintfmt+0x155>
  800410:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  800417:	85 d2                	test   %edx,%edx
  800419:	74 18                	je     800433 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80041b:	52                   	push   %edx
  80041c:	68 97 29 80 00       	push   $0x802997
  800421:	53                   	push   %ebx
  800422:	56                   	push   %esi
  800423:	e8 99 fe ff ff       	call   8002c1 <printfmt>
  800428:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80042e:	e9 73 02 00 00       	jmp    8006a6 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800433:	50                   	push   %eax
  800434:	68 db 25 80 00       	push   $0x8025db
  800439:	53                   	push   %ebx
  80043a:	56                   	push   %esi
  80043b:	e8 81 fe ff ff       	call   8002c1 <printfmt>
  800440:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800443:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800446:	e9 5b 02 00 00       	jmp    8006a6 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	83 c0 04             	add    $0x4,%eax
  800451:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800459:	85 d2                	test   %edx,%edx
  80045b:	b8 d4 25 80 00       	mov    $0x8025d4,%eax
  800460:	0f 45 c2             	cmovne %edx,%eax
  800463:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800466:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046a:	7e 06                	jle    800472 <vprintfmt+0x194>
  80046c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800470:	75 0d                	jne    80047f <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800472:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800475:	89 c7                	mov    %eax,%edi
  800477:	03 45 e0             	add    -0x20(%ebp),%eax
  80047a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047d:	eb 53                	jmp    8004d2 <vprintfmt+0x1f4>
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	ff 75 d8             	pushl  -0x28(%ebp)
  800485:	50                   	push   %eax
  800486:	e8 13 04 00 00       	call   80089e <strnlen>
  80048b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048e:	29 c1                	sub    %eax,%ecx
  800490:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800498:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80049c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80049f:	eb 0f                	jmp    8004b0 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004aa:	83 ef 01             	sub    $0x1,%edi
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	85 ff                	test   %edi,%edi
  8004b2:	7f ed                	jg     8004a1 <vprintfmt+0x1c3>
  8004b4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b7:	85 d2                	test   %edx,%edx
  8004b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004be:	0f 49 c2             	cmovns %edx,%eax
  8004c1:	29 c2                	sub    %eax,%edx
  8004c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004c6:	eb aa                	jmp    800472 <vprintfmt+0x194>
					putch(ch, putdat);
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	53                   	push   %ebx
  8004cc:	52                   	push   %edx
  8004cd:	ff d6                	call   *%esi
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d7:	83 c7 01             	add    $0x1,%edi
  8004da:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004de:	0f be d0             	movsbl %al,%edx
  8004e1:	85 d2                	test   %edx,%edx
  8004e3:	74 4b                	je     800530 <vprintfmt+0x252>
  8004e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e9:	78 06                	js     8004f1 <vprintfmt+0x213>
  8004eb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ef:	78 1e                	js     80050f <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f5:	74 d1                	je     8004c8 <vprintfmt+0x1ea>
  8004f7:	0f be c0             	movsbl %al,%eax
  8004fa:	83 e8 20             	sub    $0x20,%eax
  8004fd:	83 f8 5e             	cmp    $0x5e,%eax
  800500:	76 c6                	jbe    8004c8 <vprintfmt+0x1ea>
					putch('?', putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	6a 3f                	push   $0x3f
  800508:	ff d6                	call   *%esi
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	eb c3                	jmp    8004d2 <vprintfmt+0x1f4>
  80050f:	89 cf                	mov    %ecx,%edi
  800511:	eb 0e                	jmp    800521 <vprintfmt+0x243>
				putch(' ', putdat);
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	53                   	push   %ebx
  800517:	6a 20                	push   $0x20
  800519:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80051b:	83 ef 01             	sub    $0x1,%edi
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	85 ff                	test   %edi,%edi
  800523:	7f ee                	jg     800513 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800525:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800528:	89 45 14             	mov    %eax,0x14(%ebp)
  80052b:	e9 76 01 00 00       	jmp    8006a6 <vprintfmt+0x3c8>
  800530:	89 cf                	mov    %ecx,%edi
  800532:	eb ed                	jmp    800521 <vprintfmt+0x243>
	if (lflag >= 2)
  800534:	83 f9 01             	cmp    $0x1,%ecx
  800537:	7f 1f                	jg     800558 <vprintfmt+0x27a>
	else if (lflag)
  800539:	85 c9                	test   %ecx,%ecx
  80053b:	74 6a                	je     8005a7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800545:	89 c1                	mov    %eax,%ecx
  800547:	c1 f9 1f             	sar    $0x1f,%ecx
  80054a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	8d 40 04             	lea    0x4(%eax),%eax
  800553:	89 45 14             	mov    %eax,0x14(%ebp)
  800556:	eb 17                	jmp    80056f <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8b 50 04             	mov    0x4(%eax),%edx
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800563:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8d 40 08             	lea    0x8(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80056f:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800572:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800577:	85 d2                	test   %edx,%edx
  800579:	0f 89 f8 00 00 00    	jns    800677 <vprintfmt+0x399>
				putch('-', putdat);
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	53                   	push   %ebx
  800583:	6a 2d                	push   $0x2d
  800585:	ff d6                	call   *%esi
				num = -(long long) num;
  800587:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80058a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058d:	f7 d8                	neg    %eax
  80058f:	83 d2 00             	adc    $0x0,%edx
  800592:	f7 da                	neg    %edx
  800594:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800597:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059d:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a2:	e9 e1 00 00 00       	jmp    800688 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005af:	99                   	cltd   
  8005b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8d 40 04             	lea    0x4(%eax),%eax
  8005b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bc:	eb b1                	jmp    80056f <vprintfmt+0x291>
	if (lflag >= 2)
  8005be:	83 f9 01             	cmp    $0x1,%ecx
  8005c1:	7f 27                	jg     8005ea <vprintfmt+0x30c>
	else if (lflag)
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	74 41                	je     800608 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
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
  8005e5:	e9 8d 00 00 00       	jmp    800677 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 50 04             	mov    0x4(%eax),%edx
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 08             	lea    0x8(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800601:	bf 0a 00 00 00       	mov    $0xa,%edi
  800606:	eb 6f                	jmp    800677 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	ba 00 00 00 00       	mov    $0x0,%edx
  800612:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800615:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 40 04             	lea    0x4(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800621:	bf 0a 00 00 00       	mov    $0xa,%edi
  800626:	eb 4f                	jmp    800677 <vprintfmt+0x399>
	if (lflag >= 2)
  800628:	83 f9 01             	cmp    $0x1,%ecx
  80062b:	7f 23                	jg     800650 <vprintfmt+0x372>
	else if (lflag)
  80062d:	85 c9                	test   %ecx,%ecx
  80062f:	0f 84 98 00 00 00    	je     8006cd <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	ba 00 00 00 00       	mov    $0x0,%edx
  80063f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800642:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	eb 17                	jmp    800667 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8b 50 04             	mov    0x4(%eax),%edx
  800656:	8b 00                	mov    (%eax),%eax
  800658:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8d 40 08             	lea    0x8(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	6a 30                	push   $0x30
  80066d:	ff d6                	call   *%esi
			goto number;
  80066f:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800672:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800677:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80067b:	74 0b                	je     800688 <vprintfmt+0x3aa>
				putch('+', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 2b                	push   $0x2b
  800683:	ff d6                	call   *%esi
  800685:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80068f:	50                   	push   %eax
  800690:	ff 75 e0             	pushl  -0x20(%ebp)
  800693:	57                   	push   %edi
  800694:	ff 75 dc             	pushl  -0x24(%ebp)
  800697:	ff 75 d8             	pushl  -0x28(%ebp)
  80069a:	89 da                	mov    %ebx,%edx
  80069c:	89 f0                	mov    %esi,%eax
  80069e:	e8 22 fb ff ff       	call   8001c5 <printnum>
			break;
  8006a3:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8006a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a9:	83 c7 01             	add    $0x1,%edi
  8006ac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b0:	83 f8 25             	cmp    $0x25,%eax
  8006b3:	0f 84 3c fc ff ff    	je     8002f5 <vprintfmt+0x17>
			if (ch == '\0')
  8006b9:	85 c0                	test   %eax,%eax
  8006bb:	0f 84 55 01 00 00    	je     800816 <vprintfmt+0x538>
			putch(ch, putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	50                   	push   %eax
  8006c6:	ff d6                	call   *%esi
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	eb dc                	jmp    8006a9 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 04             	lea    0x4(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e6:	e9 7c ff ff ff       	jmp    800667 <vprintfmt+0x389>
			putch('0', putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 30                	push   $0x30
  8006f1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f3:	83 c4 08             	add    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	6a 78                	push   $0x78
  8006f9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80070b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800717:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  80071c:	e9 56 ff ff ff       	jmp    800677 <vprintfmt+0x399>
	if (lflag >= 2)
  800721:	83 f9 01             	cmp    $0x1,%ecx
  800724:	7f 27                	jg     80074d <vprintfmt+0x46f>
	else if (lflag)
  800726:	85 c9                	test   %ecx,%ecx
  800728:	74 44                	je     80076e <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800737:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800743:	bf 10 00 00 00       	mov    $0x10,%edi
  800748:	e9 2a ff ff ff       	jmp    800677 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800758:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8d 40 08             	lea    0x8(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800764:	bf 10 00 00 00       	mov    $0x10,%edi
  800769:	e9 09 ff ff ff       	jmp    800677 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8d 40 04             	lea    0x4(%eax),%eax
  800784:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800787:	bf 10 00 00 00       	mov    $0x10,%edi
  80078c:	e9 e6 fe ff ff       	jmp    800677 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8d 78 04             	lea    0x4(%eax),%edi
  800797:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800799:	85 c0                	test   %eax,%eax
  80079b:	74 2d                	je     8007ca <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80079d:	0f b6 13             	movzbl (%ebx),%edx
  8007a0:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007a2:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8007a5:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007a8:	0f 8e f8 fe ff ff    	jle    8006a6 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007ae:	68 30 27 80 00       	push   $0x802730
  8007b3:	68 97 29 80 00       	push   $0x802997
  8007b8:	53                   	push   %ebx
  8007b9:	56                   	push   %esi
  8007ba:	e8 02 fb ff ff       	call   8002c1 <printfmt>
  8007bf:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007c2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007c5:	e9 dc fe ff ff       	jmp    8006a6 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8007ca:	68 f8 26 80 00       	push   $0x8026f8
  8007cf:	68 97 29 80 00       	push   $0x802997
  8007d4:	53                   	push   %ebx
  8007d5:	56                   	push   %esi
  8007d6:	e8 e6 fa ff ff       	call   8002c1 <printfmt>
  8007db:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007de:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007e1:	e9 c0 fe ff ff       	jmp    8006a6 <vprintfmt+0x3c8>
			putch(ch, putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	53                   	push   %ebx
  8007ea:	6a 25                	push   $0x25
  8007ec:	ff d6                	call   *%esi
			break;
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	e9 b0 fe ff ff       	jmp    8006a6 <vprintfmt+0x3c8>
			putch('%', putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	6a 25                	push   $0x25
  8007fc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	89 f8                	mov    %edi,%eax
  800803:	eb 03                	jmp    800808 <vprintfmt+0x52a>
  800805:	83 e8 01             	sub    $0x1,%eax
  800808:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80080c:	75 f7                	jne    800805 <vprintfmt+0x527>
  80080e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800811:	e9 90 fe ff ff       	jmp    8006a6 <vprintfmt+0x3c8>
}
  800816:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800819:	5b                   	pop    %ebx
  80081a:	5e                   	pop    %esi
  80081b:	5f                   	pop    %edi
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 18             	sub    $0x18,%esp
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80082d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800831:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083b:	85 c0                	test   %eax,%eax
  80083d:	74 26                	je     800865 <vsnprintf+0x47>
  80083f:	85 d2                	test   %edx,%edx
  800841:	7e 22                	jle    800865 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800843:	ff 75 14             	pushl  0x14(%ebp)
  800846:	ff 75 10             	pushl  0x10(%ebp)
  800849:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084c:	50                   	push   %eax
  80084d:	68 a4 02 80 00       	push   $0x8002a4
  800852:	e8 87 fa ff ff       	call   8002de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800860:	83 c4 10             	add    $0x10,%esp
}
  800863:	c9                   	leave  
  800864:	c3                   	ret    
		return -E_INVAL;
  800865:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80086a:	eb f7                	jmp    800863 <vsnprintf+0x45>

0080086c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800872:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800875:	50                   	push   %eax
  800876:	ff 75 10             	pushl  0x10(%ebp)
  800879:	ff 75 0c             	pushl  0xc(%ebp)
  80087c:	ff 75 08             	pushl  0x8(%ebp)
  80087f:	e8 9a ff ff ff       	call   80081e <vsnprintf>
	va_end(ap);

	return rc;
}
  800884:	c9                   	leave  
  800885:	c3                   	ret    

00800886 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80088c:	b8 00 00 00 00       	mov    $0x0,%eax
  800891:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800895:	74 05                	je     80089c <strlen+0x16>
		n++;
  800897:	83 c0 01             	add    $0x1,%eax
  80089a:	eb f5                	jmp    800891 <strlen+0xb>
	return n;
}
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ac:	39 c2                	cmp    %eax,%edx
  8008ae:	74 0d                	je     8008bd <strnlen+0x1f>
  8008b0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008b4:	74 05                	je     8008bb <strnlen+0x1d>
		n++;
  8008b6:	83 c2 01             	add    $0x1,%edx
  8008b9:	eb f1                	jmp    8008ac <strnlen+0xe>
  8008bb:	89 d0                	mov    %edx,%eax
	return n;
}
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    

008008bf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	53                   	push   %ebx
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ce:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008d2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008d5:	83 c2 01             	add    $0x1,%edx
  8008d8:	84 c9                	test   %cl,%cl
  8008da:	75 f2                	jne    8008ce <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008dc:	5b                   	pop    %ebx
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	53                   	push   %ebx
  8008e3:	83 ec 10             	sub    $0x10,%esp
  8008e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e9:	53                   	push   %ebx
  8008ea:	e8 97 ff ff ff       	call   800886 <strlen>
  8008ef:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	01 d8                	add    %ebx,%eax
  8008f7:	50                   	push   %eax
  8008f8:	e8 c2 ff ff ff       	call   8008bf <strcpy>
	return dst;
}
  8008fd:	89 d8                	mov    %ebx,%eax
  8008ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	56                   	push   %esi
  800908:	53                   	push   %ebx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090f:	89 c6                	mov    %eax,%esi
  800911:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800914:	89 c2                	mov    %eax,%edx
  800916:	39 f2                	cmp    %esi,%edx
  800918:	74 11                	je     80092b <strncpy+0x27>
		*dst++ = *src;
  80091a:	83 c2 01             	add    $0x1,%edx
  80091d:	0f b6 19             	movzbl (%ecx),%ebx
  800920:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800923:	80 fb 01             	cmp    $0x1,%bl
  800926:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800929:	eb eb                	jmp    800916 <strncpy+0x12>
	}
	return ret;
}
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	56                   	push   %esi
  800933:	53                   	push   %ebx
  800934:	8b 75 08             	mov    0x8(%ebp),%esi
  800937:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093a:	8b 55 10             	mov    0x10(%ebp),%edx
  80093d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80093f:	85 d2                	test   %edx,%edx
  800941:	74 21                	je     800964 <strlcpy+0x35>
  800943:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800947:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800949:	39 c2                	cmp    %eax,%edx
  80094b:	74 14                	je     800961 <strlcpy+0x32>
  80094d:	0f b6 19             	movzbl (%ecx),%ebx
  800950:	84 db                	test   %bl,%bl
  800952:	74 0b                	je     80095f <strlcpy+0x30>
			*dst++ = *src++;
  800954:	83 c1 01             	add    $0x1,%ecx
  800957:	83 c2 01             	add    $0x1,%edx
  80095a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80095d:	eb ea                	jmp    800949 <strlcpy+0x1a>
  80095f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800961:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800964:	29 f0                	sub    %esi,%eax
}
  800966:	5b                   	pop    %ebx
  800967:	5e                   	pop    %esi
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800973:	0f b6 01             	movzbl (%ecx),%eax
  800976:	84 c0                	test   %al,%al
  800978:	74 0c                	je     800986 <strcmp+0x1c>
  80097a:	3a 02                	cmp    (%edx),%al
  80097c:	75 08                	jne    800986 <strcmp+0x1c>
		p++, q++;
  80097e:	83 c1 01             	add    $0x1,%ecx
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	eb ed                	jmp    800973 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800986:	0f b6 c0             	movzbl %al,%eax
  800989:	0f b6 12             	movzbl (%edx),%edx
  80098c:	29 d0                	sub    %edx,%eax
}
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099a:	89 c3                	mov    %eax,%ebx
  80099c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80099f:	eb 06                	jmp    8009a7 <strncmp+0x17>
		n--, p++, q++;
  8009a1:	83 c0 01             	add    $0x1,%eax
  8009a4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009a7:	39 d8                	cmp    %ebx,%eax
  8009a9:	74 16                	je     8009c1 <strncmp+0x31>
  8009ab:	0f b6 08             	movzbl (%eax),%ecx
  8009ae:	84 c9                	test   %cl,%cl
  8009b0:	74 04                	je     8009b6 <strncmp+0x26>
  8009b2:	3a 0a                	cmp    (%edx),%cl
  8009b4:	74 eb                	je     8009a1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b6:	0f b6 00             	movzbl (%eax),%eax
  8009b9:	0f b6 12             	movzbl (%edx),%edx
  8009bc:	29 d0                	sub    %edx,%eax
}
  8009be:	5b                   	pop    %ebx
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    
		return 0;
  8009c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c6:	eb f6                	jmp    8009be <strncmp+0x2e>

008009c8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d2:	0f b6 10             	movzbl (%eax),%edx
  8009d5:	84 d2                	test   %dl,%dl
  8009d7:	74 09                	je     8009e2 <strchr+0x1a>
		if (*s == c)
  8009d9:	38 ca                	cmp    %cl,%dl
  8009db:	74 0a                	je     8009e7 <strchr+0x1f>
	for (; *s; s++)
  8009dd:	83 c0 01             	add    $0x1,%eax
  8009e0:	eb f0                	jmp    8009d2 <strchr+0xa>
			return (char *) s;
	return 0;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009f6:	38 ca                	cmp    %cl,%dl
  8009f8:	74 09                	je     800a03 <strfind+0x1a>
  8009fa:	84 d2                	test   %dl,%dl
  8009fc:	74 05                	je     800a03 <strfind+0x1a>
	for (; *s; s++)
  8009fe:	83 c0 01             	add    $0x1,%eax
  800a01:	eb f0                	jmp    8009f3 <strfind+0xa>
			break;
	return (char *) s;
}
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	57                   	push   %edi
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a11:	85 c9                	test   %ecx,%ecx
  800a13:	74 31                	je     800a46 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a15:	89 f8                	mov    %edi,%eax
  800a17:	09 c8                	or     %ecx,%eax
  800a19:	a8 03                	test   $0x3,%al
  800a1b:	75 23                	jne    800a40 <memset+0x3b>
		c &= 0xFF;
  800a1d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a21:	89 d3                	mov    %edx,%ebx
  800a23:	c1 e3 08             	shl    $0x8,%ebx
  800a26:	89 d0                	mov    %edx,%eax
  800a28:	c1 e0 18             	shl    $0x18,%eax
  800a2b:	89 d6                	mov    %edx,%esi
  800a2d:	c1 e6 10             	shl    $0x10,%esi
  800a30:	09 f0                	or     %esi,%eax
  800a32:	09 c2                	or     %eax,%edx
  800a34:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a36:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a39:	89 d0                	mov    %edx,%eax
  800a3b:	fc                   	cld    
  800a3c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a3e:	eb 06                	jmp    800a46 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a43:	fc                   	cld    
  800a44:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a46:	89 f8                	mov    %edi,%eax
  800a48:	5b                   	pop    %ebx
  800a49:	5e                   	pop    %esi
  800a4a:	5f                   	pop    %edi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	57                   	push   %edi
  800a51:	56                   	push   %esi
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a58:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a5b:	39 c6                	cmp    %eax,%esi
  800a5d:	73 32                	jae    800a91 <memmove+0x44>
  800a5f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	76 2b                	jbe    800a91 <memmove+0x44>
		s += n;
		d += n;
  800a66:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a69:	89 fe                	mov    %edi,%esi
  800a6b:	09 ce                	or     %ecx,%esi
  800a6d:	09 d6                	or     %edx,%esi
  800a6f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a75:	75 0e                	jne    800a85 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a77:	83 ef 04             	sub    $0x4,%edi
  800a7a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a80:	fd                   	std    
  800a81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a83:	eb 09                	jmp    800a8e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a85:	83 ef 01             	sub    $0x1,%edi
  800a88:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a8b:	fd                   	std    
  800a8c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8e:	fc                   	cld    
  800a8f:	eb 1a                	jmp    800aab <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a91:	89 c2                	mov    %eax,%edx
  800a93:	09 ca                	or     %ecx,%edx
  800a95:	09 f2                	or     %esi,%edx
  800a97:	f6 c2 03             	test   $0x3,%dl
  800a9a:	75 0a                	jne    800aa6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9f:	89 c7                	mov    %eax,%edi
  800aa1:	fc                   	cld    
  800aa2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa4:	eb 05                	jmp    800aab <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	fc                   	cld    
  800aa9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aab:	5e                   	pop    %esi
  800aac:	5f                   	pop    %edi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab5:	ff 75 10             	pushl  0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 8a ff ff ff       	call   800a4d <memmove>
}
  800ac3:	c9                   	leave  
  800ac4:	c3                   	ret    

00800ac5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad0:	89 c6                	mov    %eax,%esi
  800ad2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad5:	39 f0                	cmp    %esi,%eax
  800ad7:	74 1c                	je     800af5 <memcmp+0x30>
		if (*s1 != *s2)
  800ad9:	0f b6 08             	movzbl (%eax),%ecx
  800adc:	0f b6 1a             	movzbl (%edx),%ebx
  800adf:	38 d9                	cmp    %bl,%cl
  800ae1:	75 08                	jne    800aeb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae3:	83 c0 01             	add    $0x1,%eax
  800ae6:	83 c2 01             	add    $0x1,%edx
  800ae9:	eb ea                	jmp    800ad5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aeb:	0f b6 c1             	movzbl %cl,%eax
  800aee:	0f b6 db             	movzbl %bl,%ebx
  800af1:	29 d8                	sub    %ebx,%eax
  800af3:	eb 05                	jmp    800afa <memcmp+0x35>
	}

	return 0;
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afa:	5b                   	pop    %ebx
  800afb:	5e                   	pop    %esi
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b07:	89 c2                	mov    %eax,%edx
  800b09:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b0c:	39 d0                	cmp    %edx,%eax
  800b0e:	73 09                	jae    800b19 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b10:	38 08                	cmp    %cl,(%eax)
  800b12:	74 05                	je     800b19 <memfind+0x1b>
	for (; s < ends; s++)
  800b14:	83 c0 01             	add    $0x1,%eax
  800b17:	eb f3                	jmp    800b0c <memfind+0xe>
			break;
	return (void *) s;
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	57                   	push   %edi
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
  800b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b24:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b27:	eb 03                	jmp    800b2c <strtol+0x11>
		s++;
  800b29:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b2c:	0f b6 01             	movzbl (%ecx),%eax
  800b2f:	3c 20                	cmp    $0x20,%al
  800b31:	74 f6                	je     800b29 <strtol+0xe>
  800b33:	3c 09                	cmp    $0x9,%al
  800b35:	74 f2                	je     800b29 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b37:	3c 2b                	cmp    $0x2b,%al
  800b39:	74 2a                	je     800b65 <strtol+0x4a>
	int neg = 0;
  800b3b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b40:	3c 2d                	cmp    $0x2d,%al
  800b42:	74 2b                	je     800b6f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b44:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b4a:	75 0f                	jne    800b5b <strtol+0x40>
  800b4c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b4f:	74 28                	je     800b79 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b51:	85 db                	test   %ebx,%ebx
  800b53:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b58:	0f 44 d8             	cmove  %eax,%ebx
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b60:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b63:	eb 50                	jmp    800bb5 <strtol+0x9a>
		s++;
  800b65:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b68:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6d:	eb d5                	jmp    800b44 <strtol+0x29>
		s++, neg = 1;
  800b6f:	83 c1 01             	add    $0x1,%ecx
  800b72:	bf 01 00 00 00       	mov    $0x1,%edi
  800b77:	eb cb                	jmp    800b44 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b79:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b7d:	74 0e                	je     800b8d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b7f:	85 db                	test   %ebx,%ebx
  800b81:	75 d8                	jne    800b5b <strtol+0x40>
		s++, base = 8;
  800b83:	83 c1 01             	add    $0x1,%ecx
  800b86:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b8b:	eb ce                	jmp    800b5b <strtol+0x40>
		s += 2, base = 16;
  800b8d:	83 c1 02             	add    $0x2,%ecx
  800b90:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b95:	eb c4                	jmp    800b5b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b97:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b9a:	89 f3                	mov    %esi,%ebx
  800b9c:	80 fb 19             	cmp    $0x19,%bl
  800b9f:	77 29                	ja     800bca <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ba1:	0f be d2             	movsbl %dl,%edx
  800ba4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800baa:	7d 30                	jge    800bdc <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bac:	83 c1 01             	add    $0x1,%ecx
  800baf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb5:	0f b6 11             	movzbl (%ecx),%edx
  800bb8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bbb:	89 f3                	mov    %esi,%ebx
  800bbd:	80 fb 09             	cmp    $0x9,%bl
  800bc0:	77 d5                	ja     800b97 <strtol+0x7c>
			dig = *s - '0';
  800bc2:	0f be d2             	movsbl %dl,%edx
  800bc5:	83 ea 30             	sub    $0x30,%edx
  800bc8:	eb dd                	jmp    800ba7 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bca:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bcd:	89 f3                	mov    %esi,%ebx
  800bcf:	80 fb 19             	cmp    $0x19,%bl
  800bd2:	77 08                	ja     800bdc <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bd4:	0f be d2             	movsbl %dl,%edx
  800bd7:	83 ea 37             	sub    $0x37,%edx
  800bda:	eb cb                	jmp    800ba7 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be0:	74 05                	je     800be7 <strtol+0xcc>
		*endptr = (char *) s;
  800be2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800be7:	89 c2                	mov    %eax,%edx
  800be9:	f7 da                	neg    %edx
  800beb:	85 ff                	test   %edi,%edi
  800bed:	0f 45 c2             	cmovne %edx,%eax
}
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800c00:	8b 55 08             	mov    0x8(%ebp),%edx
  800c03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c06:	89 c3                	mov    %eax,%ebx
  800c08:	89 c7                	mov    %eax,%edi
  800c0a:	89 c6                	mov    %eax,%esi
  800c0c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c19:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c23:	89 d1                	mov    %edx,%ecx
  800c25:	89 d3                	mov    %edx,%ebx
  800c27:	89 d7                	mov    %edx,%edi
  800c29:	89 d6                	mov    %edx,%esi
  800c2b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c40:	8b 55 08             	mov    0x8(%ebp),%edx
  800c43:	b8 03 00 00 00       	mov    $0x3,%eax
  800c48:	89 cb                	mov    %ecx,%ebx
  800c4a:	89 cf                	mov    %ecx,%edi
  800c4c:	89 ce                	mov    %ecx,%esi
  800c4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c50:	85 c0                	test   %eax,%eax
  800c52:	7f 08                	jg     800c5c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5c:	83 ec 0c             	sub    $0xc,%esp
  800c5f:	50                   	push   %eax
  800c60:	6a 03                	push   $0x3
  800c62:	68 40 29 80 00       	push   $0x802940
  800c67:	6a 33                	push   $0x33
  800c69:	68 5d 29 80 00       	push   $0x80295d
  800c6e:	e8 63 f4 ff ff       	call   8000d6 <_panic>

00800c73 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c79:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c83:	89 d1                	mov    %edx,%ecx
  800c85:	89 d3                	mov    %edx,%ebx
  800c87:	89 d7                	mov    %edx,%edi
  800c89:	89 d6                	mov    %edx,%esi
  800c8b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5f                   	pop    %edi
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <sys_yield>:

void
sys_yield(void)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c98:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ca2:	89 d1                	mov    %edx,%ecx
  800ca4:	89 d3                	mov    %edx,%ebx
  800ca6:	89 d7                	mov    %edx,%edi
  800ca8:	89 d6                	mov    %edx,%esi
  800caa:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cba:	be 00 00 00 00       	mov    $0x0,%esi
  800cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc5:	b8 04 00 00 00       	mov    $0x4,%eax
  800cca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccd:	89 f7                	mov    %esi,%edi
  800ccf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	7f 08                	jg     800cdd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdd:	83 ec 0c             	sub    $0xc,%esp
  800ce0:	50                   	push   %eax
  800ce1:	6a 04                	push   $0x4
  800ce3:	68 40 29 80 00       	push   $0x802940
  800ce8:	6a 33                	push   $0x33
  800cea:	68 5d 29 80 00       	push   $0x80295d
  800cef:	e8 e2 f3 ff ff       	call   8000d6 <_panic>

00800cf4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d03:	b8 05 00 00 00       	mov    $0x5,%eax
  800d08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7f 08                	jg     800d1f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d23:	6a 05                	push   $0x5
  800d25:	68 40 29 80 00       	push   $0x802940
  800d2a:	6a 33                	push   $0x33
  800d2c:	68 5d 29 80 00       	push   $0x80295d
  800d31:	e8 a0 f3 ff ff       	call   8000d6 <_panic>

00800d36 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4f:	89 df                	mov    %ebx,%edi
  800d51:	89 de                	mov    %ebx,%esi
  800d53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7f 08                	jg     800d61 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d65:	6a 06                	push   $0x6
  800d67:	68 40 29 80 00       	push   $0x802940
  800d6c:	6a 33                	push   $0x33
  800d6e:	68 5d 29 80 00       	push   $0x80295d
  800d73:	e8 5e f3 ff ff       	call   8000d6 <_panic>

00800d78 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d8e:	89 cb                	mov    %ecx,%ebx
  800d90:	89 cf                	mov    %ecx,%edi
  800d92:	89 ce                	mov    %ecx,%esi
  800d94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	83 ec 0c             	sub    $0xc,%esp
  800da5:	50                   	push   %eax
  800da6:	6a 0b                	push   $0xb
  800da8:	68 40 29 80 00       	push   $0x802940
  800dad:	6a 33                	push   $0x33
  800daf:	68 5d 29 80 00       	push   $0x80295d
  800db4:	e8 1d f3 ff ff       	call   8000d6 <_panic>

00800db9 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd2:	89 df                	mov    %ebx,%edi
  800dd4:	89 de                	mov    %ebx,%esi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800de8:	6a 08                	push   $0x8
  800dea:	68 40 29 80 00       	push   $0x802940
  800def:	6a 33                	push   $0x33
  800df1:	68 5d 29 80 00       	push   $0x80295d
  800df6:	e8 db f2 ff ff       	call   8000d6 <_panic>

00800dfb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800e0f:	b8 09 00 00 00       	mov    $0x9,%eax
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800e2a:	6a 09                	push   $0x9
  800e2c:	68 40 29 80 00       	push   $0x802940
  800e31:	6a 33                	push   $0x33
  800e33:	68 5d 29 80 00       	push   $0x80295d
  800e38:	e8 99 f2 ff ff       	call   8000d6 <_panic>

00800e3d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e56:	89 df                	mov    %ebx,%edi
  800e58:	89 de                	mov    %ebx,%esi
  800e5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7f 08                	jg     800e68 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e6c:	6a 0a                	push   $0xa
  800e6e:	68 40 29 80 00       	push   $0x802940
  800e73:	6a 33                	push   $0x33
  800e75:	68 5d 29 80 00       	push   $0x80295d
  800e7a:	e8 57 f2 ff ff       	call   8000d6 <_panic>

00800e7f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e90:	be 00 00 00 00       	mov    $0x0,%esi
  800e95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e98:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eab:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb8:	89 cb                	mov    %ecx,%ebx
  800eba:	89 cf                	mov    %ecx,%edi
  800ebc:	89 ce                	mov    %ecx,%esi
  800ebe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	7f 08                	jg     800ecc <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	50                   	push   %eax
  800ed0:	6a 0e                	push   $0xe
  800ed2:	68 40 29 80 00       	push   $0x802940
  800ed7:	6a 33                	push   $0x33
  800ed9:	68 5d 29 80 00       	push   $0x80295d
  800ede:	e8 f3 f1 ff ff       	call   8000d6 <_panic>

00800ee3 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef4:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ef9:	89 df                	mov    %ebx,%edi
  800efb:	89 de                	mov    %ebx,%esi
  800efd:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	b8 10 00 00 00       	mov    $0x10,%eax
  800f17:	89 cb                	mov    %ecx,%ebx
  800f19:	89 cf                	mov    %ecx,%edi
  800f1b:	89 ce                	mov    %ecx,%esi
  800f1d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f1f:	5b                   	pop    %ebx
  800f20:	5e                   	pop    %esi
  800f21:	5f                   	pop    %edi
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    

00800f24 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  800f30:	6a 00                	push   $0x0
  800f32:	ff 75 08             	pushl  0x8(%ebp)
  800f35:	e8 1e 0d 00 00       	call   801c58 <open>
  800f3a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	85 c0                	test   %eax,%eax
  800f45:	0f 88 ff 04 00 00    	js     80144a <spawn+0x526>
  800f4b:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 00 02 00 00       	push   $0x200
  800f55:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800f5b:	50                   	push   %eax
  800f5c:	51                   	push   %ecx
  800f5d:	e8 1a 09 00 00       	call   80187c <readn>
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6a:	75 60                	jne    800fcc <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  800f6c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  800f73:	45 4c 46 
  800f76:	75 54                	jne    800fcc <spawn+0xa8>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f78:	b8 07 00 00 00       	mov    $0x7,%eax
  800f7d:	cd 30                	int    $0x30
  800f7f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  800f85:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	0f 88 ab 04 00 00    	js     80143e <spawn+0x51a>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  800f93:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f98:	8d 34 c0             	lea    (%eax,%eax,8),%esi
  800f9b:	c1 e6 04             	shl    $0x4,%esi
  800f9e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  800fa4:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  800faa:	b9 11 00 00 00       	mov    $0x11,%ecx
  800faf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  800fb1:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  800fb7:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  800fbd:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  800fc2:	be 00 00 00 00       	mov    $0x0,%esi
  800fc7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800fca:	eb 4b                	jmp    801017 <spawn+0xf3>
		close(fd);
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  800fd5:	e8 dd 06 00 00       	call   8016b7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  800fda:	83 c4 0c             	add    $0xc,%esp
  800fdd:	68 7f 45 4c 46       	push   $0x464c457f
  800fe2:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  800fe8:	68 6b 29 80 00       	push   $0x80296b
  800fed:	e8 bf f1 ff ff       	call   8001b1 <cprintf>
		return -E_NOT_EXEC;
  800ff2:	83 c4 10             	add    $0x10,%esp
  800ff5:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  800ffc:	ff ff ff 
  800fff:	e9 46 04 00 00       	jmp    80144a <spawn+0x526>
		string_size += strlen(argv[argc]) + 1;
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	50                   	push   %eax
  801008:	e8 79 f8 ff ff       	call   800886 <strlen>
  80100d:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801011:	83 c3 01             	add    $0x1,%ebx
  801014:	83 c4 10             	add    $0x10,%esp
  801017:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80101e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801021:	85 c0                	test   %eax,%eax
  801023:	75 df                	jne    801004 <spawn+0xe0>
  801025:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80102b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801031:	bf 00 10 40 00       	mov    $0x401000,%edi
  801036:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801038:	89 fa                	mov    %edi,%edx
  80103a:	83 e2 fc             	and    $0xfffffffc,%edx
  80103d:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801044:	29 c2                	sub    %eax,%edx
  801046:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80104c:	8d 42 f8             	lea    -0x8(%edx),%eax
  80104f:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801054:	0f 86 13 04 00 00    	jbe    80146d <spawn+0x549>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80105a:	83 ec 04             	sub    $0x4,%esp
  80105d:	6a 07                	push   $0x7
  80105f:	68 00 00 40 00       	push   $0x400000
  801064:	6a 00                	push   $0x0
  801066:	e8 46 fc ff ff       	call   800cb1 <sys_page_alloc>
  80106b:	83 c4 10             	add    $0x10,%esp
  80106e:	85 c0                	test   %eax,%eax
  801070:	0f 88 fc 03 00 00    	js     801472 <spawn+0x54e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801076:	be 00 00 00 00       	mov    $0x0,%esi
  80107b:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801081:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801084:	eb 30                	jmp    8010b6 <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  801086:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80108c:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801092:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801095:	83 ec 08             	sub    $0x8,%esp
  801098:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80109b:	57                   	push   %edi
  80109c:	e8 1e f8 ff ff       	call   8008bf <strcpy>
		string_store += strlen(argv[i]) + 1;
  8010a1:	83 c4 04             	add    $0x4,%esp
  8010a4:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8010a7:	e8 da f7 ff ff       	call   800886 <strlen>
  8010ac:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8010b0:	83 c6 01             	add    $0x1,%esi
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8010bc:	7f c8                	jg     801086 <spawn+0x162>
	}
	argv_store[argc] = 0;
  8010be:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8010c4:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8010ca:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8010d1:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8010d7:	0f 85 86 00 00 00    	jne    801163 <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8010dd:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8010e3:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  8010e9:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8010f4:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8010f7:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8010fc:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801102:	83 ec 0c             	sub    $0xc,%esp
  801105:	6a 07                	push   $0x7
  801107:	68 00 d0 bf ee       	push   $0xeebfd000
  80110c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801112:	68 00 00 40 00       	push   $0x400000
  801117:	6a 00                	push   $0x0
  801119:	e8 d6 fb ff ff       	call   800cf4 <sys_page_map>
  80111e:	89 c3                	mov    %eax,%ebx
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	0f 88 4f 03 00 00    	js     80147a <spawn+0x556>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	68 00 00 40 00       	push   $0x400000
  801133:	6a 00                	push   $0x0
  801135:	e8 fc fb ff ff       	call   800d36 <sys_page_unmap>
  80113a:	89 c3                	mov    %eax,%ebx
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	85 c0                	test   %eax,%eax
  801141:	0f 88 33 03 00 00    	js     80147a <spawn+0x556>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801147:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80114d:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801154:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  80115b:	00 00 00 
  80115e:	e9 4f 01 00 00       	jmp    8012b2 <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801163:	68 0c 2a 80 00       	push   $0x802a0c
  801168:	68 85 29 80 00       	push   $0x802985
  80116d:	68 f2 00 00 00       	push   $0xf2
  801172:	68 9a 29 80 00       	push   $0x80299a
  801177:	e8 5a ef ff ff       	call   8000d6 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80117c:	83 ec 04             	sub    $0x4,%esp
  80117f:	6a 07                	push   $0x7
  801181:	68 00 00 40 00       	push   $0x400000
  801186:	6a 00                	push   $0x0
  801188:	e8 24 fb ff ff       	call   800cb1 <sys_page_alloc>
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	0f 88 c0 02 00 00    	js     801458 <spawn+0x534>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8011a1:	01 f0                	add    %esi,%eax
  8011a3:	50                   	push   %eax
  8011a4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8011aa:	e8 94 07 00 00       	call   801943 <seek>
  8011af:	83 c4 10             	add    $0x10,%esp
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	0f 88 a5 02 00 00    	js     80145f <spawn+0x53b>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8011c3:	29 f0                	sub    %esi,%eax
  8011c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8011ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8011cf:	0f 47 c1             	cmova  %ecx,%eax
  8011d2:	50                   	push   %eax
  8011d3:	68 00 00 40 00       	push   $0x400000
  8011d8:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8011de:	e8 99 06 00 00       	call   80187c <readn>
  8011e3:	83 c4 10             	add    $0x10,%esp
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	0f 88 78 02 00 00    	js     801466 <spawn+0x542>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8011f7:	53                   	push   %ebx
  8011f8:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8011fe:	68 00 00 40 00       	push   $0x400000
  801203:	6a 00                	push   $0x0
  801205:	e8 ea fa ff ff       	call   800cf4 <sys_page_map>
  80120a:	83 c4 20             	add    $0x20,%esp
  80120d:	85 c0                	test   %eax,%eax
  80120f:	78 7c                	js     80128d <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	68 00 00 40 00       	push   $0x400000
  801219:	6a 00                	push   $0x0
  80121b:	e8 16 fb ff ff       	call   800d36 <sys_page_unmap>
  801220:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801223:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801229:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80122f:	89 fe                	mov    %edi,%esi
  801231:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801237:	76 69                	jbe    8012a2 <spawn+0x37e>
		if (i >= filesz) {
  801239:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80123f:	0f 87 37 ff ff ff    	ja     80117c <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801245:	83 ec 04             	sub    $0x4,%esp
  801248:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80124e:	53                   	push   %ebx
  80124f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801255:	e8 57 fa ff ff       	call   800cb1 <sys_page_alloc>
  80125a:	83 c4 10             	add    $0x10,%esp
  80125d:	85 c0                	test   %eax,%eax
  80125f:	79 c2                	jns    801223 <spawn+0x2ff>
  801261:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801263:	83 ec 0c             	sub    $0xc,%esp
  801266:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80126c:	e8 c1 f9 ff ff       	call   800c32 <sys_env_destroy>
	close(fd);
  801271:	83 c4 04             	add    $0x4,%esp
  801274:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80127a:	e8 38 04 00 00       	call   8016b7 <close>
	return r;
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801288:	e9 bd 01 00 00       	jmp    80144a <spawn+0x526>
				panic("spawn: sys_page_map data: %e", r);
  80128d:	50                   	push   %eax
  80128e:	68 a6 29 80 00       	push   $0x8029a6
  801293:	68 25 01 00 00       	push   $0x125
  801298:	68 9a 29 80 00       	push   $0x80299a
  80129d:	e8 34 ee ff ff       	call   8000d6 <_panic>
  8012a2:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8012a8:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8012af:	83 c6 20             	add    $0x20,%esi
  8012b2:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8012b9:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8012bf:	7e 6d                	jle    80132e <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  8012c1:	83 3e 01             	cmpl   $0x1,(%esi)
  8012c4:	75 e2                	jne    8012a8 <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8012c6:	8b 46 18             	mov    0x18(%esi),%eax
  8012c9:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8012cc:	83 f8 01             	cmp    $0x1,%eax
  8012cf:	19 c0                	sbb    %eax,%eax
  8012d1:	83 e0 fe             	and    $0xfffffffe,%eax
  8012d4:	83 c0 07             	add    $0x7,%eax
  8012d7:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8012dd:	8b 4e 04             	mov    0x4(%esi),%ecx
  8012e0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8012e6:	8b 56 10             	mov    0x10(%esi),%edx
  8012e9:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8012ef:	8b 7e 14             	mov    0x14(%esi),%edi
  8012f2:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8012f8:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8012fb:	89 d8                	mov    %ebx,%eax
  8012fd:	25 ff 0f 00 00       	and    $0xfff,%eax
  801302:	74 1a                	je     80131e <spawn+0x3fa>
		va -= i;
  801304:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801306:	01 c7                	add    %eax,%edi
  801308:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  80130e:	01 c2                	add    %eax,%edx
  801310:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801316:	29 c1                	sub    %eax,%ecx
  801318:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80131e:	bf 00 00 00 00       	mov    $0x0,%edi
  801323:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801329:	e9 01 ff ff ff       	jmp    80122f <spawn+0x30b>
	close(fd);
  80132e:	83 ec 0c             	sub    $0xc,%esp
  801331:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801337:	e8 7b 03 00 00       	call   8016b7 <close>
  80133c:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	uint8_t *addr;
	int r;

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  80133f:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801344:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  80134a:	eb 0e                	jmp    80135a <spawn+0x436>
  80134c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801352:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801358:	74 6f                	je     8013c9 <spawn+0x4a5>
		if ((uvpd[PDX(addr)] & PTE_P) 
  80135a:	89 d8                	mov    %ebx,%eax
  80135c:	c1 e8 16             	shr    $0x16,%eax
  80135f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801366:	a8 01                	test   $0x1,%al
  801368:	74 e2                	je     80134c <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_P) 
  80136a:	89 d8                	mov    %ebx,%eax
  80136c:	c1 e8 0c             	shr    $0xc,%eax
  80136f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801376:	f6 c2 01             	test   $0x1,%dl
  801379:	74 d1                	je     80134c <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_U) 
  80137b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801382:	f6 c2 04             	test   $0x4,%dl
  801385:	74 c5                	je     80134c <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801387:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80138e:	f6 c6 04             	test   $0x4,%dh
  801391:	74 b9                	je     80134c <spawn+0x428>
			if((r = sys_page_map(0, (void*)addr, child, (void*)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801393:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80139a:	83 ec 0c             	sub    $0xc,%esp
  80139d:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a2:	50                   	push   %eax
  8013a3:	53                   	push   %ebx
  8013a4:	56                   	push   %esi
  8013a5:	53                   	push   %ebx
  8013a6:	6a 00                	push   $0x0
  8013a8:	e8 47 f9 ff ff       	call   800cf4 <sys_page_map>
  8013ad:	83 c4 20             	add    $0x20,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	79 98                	jns    80134c <spawn+0x428>
				panic("copy_shared_pages: %e\n", r);
  8013b4:	50                   	push   %eax
  8013b5:	68 c3 29 80 00       	push   $0x8029c3
  8013ba:	68 3a 01 00 00       	push   $0x13a
  8013bf:	68 9a 29 80 00       	push   $0x80299a
  8013c4:	e8 0d ed ff ff       	call   8000d6 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8013c9:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8013d0:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8013d3:	83 ec 08             	sub    $0x8,%esp
  8013d6:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8013dc:	50                   	push   %eax
  8013dd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8013e3:	e8 13 fa ff ff       	call   800dfb <sys_env_set_trapframe>
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	78 25                	js     801414 <spawn+0x4f0>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8013ef:	83 ec 08             	sub    $0x8,%esp
  8013f2:	6a 02                	push   $0x2
  8013f4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8013fa:	e8 ba f9 ff ff       	call   800db9 <sys_env_set_status>
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 23                	js     801429 <spawn+0x505>
	return child;
  801406:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80140c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801412:	eb 36                	jmp    80144a <spawn+0x526>
		panic("sys_env_set_trapframe: %e", r);
  801414:	50                   	push   %eax
  801415:	68 da 29 80 00       	push   $0x8029da
  80141a:	68 86 00 00 00       	push   $0x86
  80141f:	68 9a 29 80 00       	push   $0x80299a
  801424:	e8 ad ec ff ff       	call   8000d6 <_panic>
		panic("sys_env_set_status: %e", r);
  801429:	50                   	push   %eax
  80142a:	68 f4 29 80 00       	push   $0x8029f4
  80142f:	68 89 00 00 00       	push   $0x89
  801434:	68 9a 29 80 00       	push   $0x80299a
  801439:	e8 98 ec ff ff       	call   8000d6 <_panic>
		return r;
  80143e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801444:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80144a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801450:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801453:	5b                   	pop    %ebx
  801454:	5e                   	pop    %esi
  801455:	5f                   	pop    %edi
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    
  801458:	89 c7                	mov    %eax,%edi
  80145a:	e9 04 fe ff ff       	jmp    801263 <spawn+0x33f>
  80145f:	89 c7                	mov    %eax,%edi
  801461:	e9 fd fd ff ff       	jmp    801263 <spawn+0x33f>
  801466:	89 c7                	mov    %eax,%edi
  801468:	e9 f6 fd ff ff       	jmp    801263 <spawn+0x33f>
		return -E_NO_MEM;
  80146d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  801472:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801478:	eb d0                	jmp    80144a <spawn+0x526>
	sys_page_unmap(0, UTEMP);
  80147a:	83 ec 08             	sub    $0x8,%esp
  80147d:	68 00 00 40 00       	push   $0x400000
  801482:	6a 00                	push   $0x0
  801484:	e8 ad f8 ff ff       	call   800d36 <sys_page_unmap>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801492:	eb b6                	jmp    80144a <spawn+0x526>

00801494 <spawnl>:
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	57                   	push   %edi
  801498:	56                   	push   %esi
  801499:	53                   	push   %ebx
  80149a:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  80149d:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8014a0:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8014a5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014a8:	83 3a 00             	cmpl   $0x0,(%edx)
  8014ab:	74 07                	je     8014b4 <spawnl+0x20>
		argc++;
  8014ad:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8014b0:	89 ca                	mov    %ecx,%edx
  8014b2:	eb f1                	jmp    8014a5 <spawnl+0x11>
	const char *argv[argc+2];
  8014b4:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8014bb:	83 e2 f0             	and    $0xfffffff0,%edx
  8014be:	29 d4                	sub    %edx,%esp
  8014c0:	8d 54 24 03          	lea    0x3(%esp),%edx
  8014c4:	c1 ea 02             	shr    $0x2,%edx
  8014c7:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8014ce:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8014d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d3:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8014da:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8014e1:	00 
	va_start(vl, arg0);
  8014e2:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8014e5:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ec:	eb 0b                	jmp    8014f9 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  8014ee:	83 c0 01             	add    $0x1,%eax
  8014f1:	8b 39                	mov    (%ecx),%edi
  8014f3:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8014f6:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8014f9:	39 d0                	cmp    %edx,%eax
  8014fb:	75 f1                	jne    8014ee <spawnl+0x5a>
	return spawn(prog, argv);
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	56                   	push   %esi
  801501:	ff 75 08             	pushl  0x8(%ebp)
  801504:	e8 1b fa ff ff       	call   800f24 <spawn>
}
  801509:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150c:	5b                   	pop    %ebx
  80150d:	5e                   	pop    %esi
  80150e:	5f                   	pop    %edi
  80150f:	5d                   	pop    %ebp
  801510:	c3                   	ret    

00801511 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	05 00 00 00 30       	add    $0x30000000,%eax
  80151c:	c1 e8 0c             	shr    $0xc,%eax
}
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80152c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801531:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801540:	89 c2                	mov    %eax,%edx
  801542:	c1 ea 16             	shr    $0x16,%edx
  801545:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80154c:	f6 c2 01             	test   $0x1,%dl
  80154f:	74 2d                	je     80157e <fd_alloc+0x46>
  801551:	89 c2                	mov    %eax,%edx
  801553:	c1 ea 0c             	shr    $0xc,%edx
  801556:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80155d:	f6 c2 01             	test   $0x1,%dl
  801560:	74 1c                	je     80157e <fd_alloc+0x46>
  801562:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801567:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80156c:	75 d2                	jne    801540 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801577:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80157c:	eb 0a                	jmp    801588 <fd_alloc+0x50>
			*fd_store = fd;
  80157e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801581:	89 01                	mov    %eax,(%ecx)
			return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    

0080158a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801590:	83 f8 1f             	cmp    $0x1f,%eax
  801593:	77 30                	ja     8015c5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801595:	c1 e0 0c             	shl    $0xc,%eax
  801598:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80159d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015a3:	f6 c2 01             	test   $0x1,%dl
  8015a6:	74 24                	je     8015cc <fd_lookup+0x42>
  8015a8:	89 c2                	mov    %eax,%edx
  8015aa:	c1 ea 0c             	shr    $0xc,%edx
  8015ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b4:	f6 c2 01             	test   $0x1,%dl
  8015b7:	74 1a                	je     8015d3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	89 02                	mov    %eax,(%edx)
	return 0;
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    
		return -E_INVAL;
  8015c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ca:	eb f7                	jmp    8015c3 <fd_lookup+0x39>
		return -E_INVAL;
  8015cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d1:	eb f0                	jmp    8015c3 <fd_lookup+0x39>
  8015d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d8:	eb e9                	jmp    8015c3 <fd_lookup+0x39>

008015da <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e3:	ba b4 2a 80 00       	mov    $0x802ab4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8015e8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015ed:	39 08                	cmp    %ecx,(%eax)
  8015ef:	74 33                	je     801624 <dev_lookup+0x4a>
  8015f1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8015f4:	8b 02                	mov    (%edx),%eax
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	75 f3                	jne    8015ed <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8015ff:	8b 40 48             	mov    0x48(%eax),%eax
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	51                   	push   %ecx
  801606:	50                   	push   %eax
  801607:	68 34 2a 80 00       	push   $0x802a34
  80160c:	e8 a0 eb ff ff       	call   8001b1 <cprintf>
	*dev = 0;
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    
			*dev = devtab[i];
  801624:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801627:	89 01                	mov    %eax,(%ecx)
			return 0;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
  80162e:	eb f2                	jmp    801622 <dev_lookup+0x48>

00801630 <fd_close>:
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	57                   	push   %edi
  801634:	56                   	push   %esi
  801635:	53                   	push   %ebx
  801636:	83 ec 24             	sub    $0x24,%esp
  801639:	8b 75 08             	mov    0x8(%ebp),%esi
  80163c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80163f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801642:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801643:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801649:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80164c:	50                   	push   %eax
  80164d:	e8 38 ff ff ff       	call   80158a <fd_lookup>
  801652:	89 c3                	mov    %eax,%ebx
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 05                	js     801660 <fd_close+0x30>
	    || fd != fd2)
  80165b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80165e:	74 16                	je     801676 <fd_close+0x46>
		return (must_exist ? r : 0);
  801660:	89 f8                	mov    %edi,%eax
  801662:	84 c0                	test   %al,%al
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	0f 44 d8             	cmove  %eax,%ebx
}
  80166c:	89 d8                	mov    %ebx,%eax
  80166e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5f                   	pop    %edi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80167c:	50                   	push   %eax
  80167d:	ff 36                	pushl  (%esi)
  80167f:	e8 56 ff ff ff       	call   8015da <dev_lookup>
  801684:	89 c3                	mov    %eax,%ebx
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	85 c0                	test   %eax,%eax
  80168b:	78 1a                	js     8016a7 <fd_close+0x77>
		if (dev->dev_close)
  80168d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801690:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801693:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801698:	85 c0                	test   %eax,%eax
  80169a:	74 0b                	je     8016a7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	56                   	push   %esi
  8016a0:	ff d0                	call   *%eax
  8016a2:	89 c3                	mov    %eax,%ebx
  8016a4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016a7:	83 ec 08             	sub    $0x8,%esp
  8016aa:	56                   	push   %esi
  8016ab:	6a 00                	push   $0x0
  8016ad:	e8 84 f6 ff ff       	call   800d36 <sys_page_unmap>
	return r;
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	eb b5                	jmp    80166c <fd_close+0x3c>

008016b7 <close>:

int
close(int fdnum)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c0:	50                   	push   %eax
  8016c1:	ff 75 08             	pushl  0x8(%ebp)
  8016c4:	e8 c1 fe ff ff       	call   80158a <fd_lookup>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	79 02                	jns    8016d2 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    
		return fd_close(fd, 1);
  8016d2:	83 ec 08             	sub    $0x8,%esp
  8016d5:	6a 01                	push   $0x1
  8016d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016da:	e8 51 ff ff ff       	call   801630 <fd_close>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	eb ec                	jmp    8016d0 <close+0x19>

008016e4 <close_all>:

void
close_all(void)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016eb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016f0:	83 ec 0c             	sub    $0xc,%esp
  8016f3:	53                   	push   %ebx
  8016f4:	e8 be ff ff ff       	call   8016b7 <close>
	for (i = 0; i < MAXFD; i++)
  8016f9:	83 c3 01             	add    $0x1,%ebx
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	83 fb 20             	cmp    $0x20,%ebx
  801702:	75 ec                	jne    8016f0 <close_all+0xc>
}
  801704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	57                   	push   %edi
  80170d:	56                   	push   %esi
  80170e:	53                   	push   %ebx
  80170f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801712:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801715:	50                   	push   %eax
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 6c fe ff ff       	call   80158a <fd_lookup>
  80171e:	89 c3                	mov    %eax,%ebx
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	0f 88 81 00 00 00    	js     8017ac <dup+0xa3>
		return r;
	close(newfdnum);
  80172b:	83 ec 0c             	sub    $0xc,%esp
  80172e:	ff 75 0c             	pushl  0xc(%ebp)
  801731:	e8 81 ff ff ff       	call   8016b7 <close>

	newfd = INDEX2FD(newfdnum);
  801736:	8b 75 0c             	mov    0xc(%ebp),%esi
  801739:	c1 e6 0c             	shl    $0xc,%esi
  80173c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801742:	83 c4 04             	add    $0x4,%esp
  801745:	ff 75 e4             	pushl  -0x1c(%ebp)
  801748:	e8 d4 fd ff ff       	call   801521 <fd2data>
  80174d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80174f:	89 34 24             	mov    %esi,(%esp)
  801752:	e8 ca fd ff ff       	call   801521 <fd2data>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80175c:	89 d8                	mov    %ebx,%eax
  80175e:	c1 e8 16             	shr    $0x16,%eax
  801761:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801768:	a8 01                	test   $0x1,%al
  80176a:	74 11                	je     80177d <dup+0x74>
  80176c:	89 d8                	mov    %ebx,%eax
  80176e:	c1 e8 0c             	shr    $0xc,%eax
  801771:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801778:	f6 c2 01             	test   $0x1,%dl
  80177b:	75 39                	jne    8017b6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80177d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801780:	89 d0                	mov    %edx,%eax
  801782:	c1 e8 0c             	shr    $0xc,%eax
  801785:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	25 07 0e 00 00       	and    $0xe07,%eax
  801794:	50                   	push   %eax
  801795:	56                   	push   %esi
  801796:	6a 00                	push   $0x0
  801798:	52                   	push   %edx
  801799:	6a 00                	push   $0x0
  80179b:	e8 54 f5 ff ff       	call   800cf4 <sys_page_map>
  8017a0:	89 c3                	mov    %eax,%ebx
  8017a2:	83 c4 20             	add    $0x20,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 31                	js     8017da <dup+0xd1>
		goto err;

	return newfdnum;
  8017a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017ac:	89 d8                	mov    %ebx,%eax
  8017ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b1:	5b                   	pop    %ebx
  8017b2:	5e                   	pop    %esi
  8017b3:	5f                   	pop    %edi
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017bd:	83 ec 0c             	sub    $0xc,%esp
  8017c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8017c5:	50                   	push   %eax
  8017c6:	57                   	push   %edi
  8017c7:	6a 00                	push   $0x0
  8017c9:	53                   	push   %ebx
  8017ca:	6a 00                	push   $0x0
  8017cc:	e8 23 f5 ff ff       	call   800cf4 <sys_page_map>
  8017d1:	89 c3                	mov    %eax,%ebx
  8017d3:	83 c4 20             	add    $0x20,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	79 a3                	jns    80177d <dup+0x74>
	sys_page_unmap(0, newfd);
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	56                   	push   %esi
  8017de:	6a 00                	push   $0x0
  8017e0:	e8 51 f5 ff ff       	call   800d36 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017e5:	83 c4 08             	add    $0x8,%esp
  8017e8:	57                   	push   %edi
  8017e9:	6a 00                	push   $0x0
  8017eb:	e8 46 f5 ff ff       	call   800d36 <sys_page_unmap>
	return r;
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	eb b7                	jmp    8017ac <dup+0xa3>

008017f5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 1c             	sub    $0x1c,%esp
  8017fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801802:	50                   	push   %eax
  801803:	53                   	push   %ebx
  801804:	e8 81 fd ff ff       	call   80158a <fd_lookup>
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 3f                	js     80184f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801816:	50                   	push   %eax
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181a:	ff 30                	pushl  (%eax)
  80181c:	e8 b9 fd ff ff       	call   8015da <dev_lookup>
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	85 c0                	test   %eax,%eax
  801826:	78 27                	js     80184f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182b:	8b 42 08             	mov    0x8(%edx),%eax
  80182e:	83 e0 03             	and    $0x3,%eax
  801831:	83 f8 01             	cmp    $0x1,%eax
  801834:	74 1e                	je     801854 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801839:	8b 40 08             	mov    0x8(%eax),%eax
  80183c:	85 c0                	test   %eax,%eax
  80183e:	74 35                	je     801875 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	ff 75 10             	pushl  0x10(%ebp)
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	52                   	push   %edx
  80184a:	ff d0                	call   *%eax
  80184c:	83 c4 10             	add    $0x10,%esp
}
  80184f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801852:	c9                   	leave  
  801853:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801854:	a1 04 40 80 00       	mov    0x804004,%eax
  801859:	8b 40 48             	mov    0x48(%eax),%eax
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	53                   	push   %ebx
  801860:	50                   	push   %eax
  801861:	68 78 2a 80 00       	push   $0x802a78
  801866:	e8 46 e9 ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801873:	eb da                	jmp    80184f <read+0x5a>
		return -E_NOT_SUPP;
  801875:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187a:	eb d3                	jmp    80184f <read+0x5a>

0080187c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	57                   	push   %edi
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
  801882:	83 ec 0c             	sub    $0xc,%esp
  801885:	8b 7d 08             	mov    0x8(%ebp),%edi
  801888:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80188b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801890:	39 f3                	cmp    %esi,%ebx
  801892:	73 23                	jae    8018b7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	89 f0                	mov    %esi,%eax
  801899:	29 d8                	sub    %ebx,%eax
  80189b:	50                   	push   %eax
  80189c:	89 d8                	mov    %ebx,%eax
  80189e:	03 45 0c             	add    0xc(%ebp),%eax
  8018a1:	50                   	push   %eax
  8018a2:	57                   	push   %edi
  8018a3:	e8 4d ff ff ff       	call   8017f5 <read>
		if (m < 0)
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 06                	js     8018b5 <readn+0x39>
			return m;
		if (m == 0)
  8018af:	74 06                	je     8018b7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8018b1:	01 c3                	add    %eax,%ebx
  8018b3:	eb db                	jmp    801890 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018b5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bc:	5b                   	pop    %ebx
  8018bd:	5e                   	pop    %esi
  8018be:	5f                   	pop    %edi
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    

008018c1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 1c             	sub    $0x1c,%esp
  8018c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ce:	50                   	push   %eax
  8018cf:	53                   	push   %ebx
  8018d0:	e8 b5 fc ff ff       	call   80158a <fd_lookup>
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 3a                	js     801916 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e2:	50                   	push   %eax
  8018e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e6:	ff 30                	pushl  (%eax)
  8018e8:	e8 ed fc ff ff       	call   8015da <dev_lookup>
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 22                	js     801916 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fb:	74 1e                	je     80191b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801900:	8b 52 0c             	mov    0xc(%edx),%edx
  801903:	85 d2                	test   %edx,%edx
  801905:	74 35                	je     80193c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	ff 75 10             	pushl  0x10(%ebp)
  80190d:	ff 75 0c             	pushl  0xc(%ebp)
  801910:	50                   	push   %eax
  801911:	ff d2                	call   *%edx
  801913:	83 c4 10             	add    $0x10,%esp
}
  801916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801919:	c9                   	leave  
  80191a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80191b:	a1 04 40 80 00       	mov    0x804004,%eax
  801920:	8b 40 48             	mov    0x48(%eax),%eax
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	53                   	push   %ebx
  801927:	50                   	push   %eax
  801928:	68 94 2a 80 00       	push   $0x802a94
  80192d:	e8 7f e8 ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80193a:	eb da                	jmp    801916 <write+0x55>
		return -E_NOT_SUPP;
  80193c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801941:	eb d3                	jmp    801916 <write+0x55>

00801943 <seek>:

int
seek(int fdnum, off_t offset)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801949:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194c:	50                   	push   %eax
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	e8 35 fc ff ff       	call   80158a <fd_lookup>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 0e                	js     80196a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801962:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	53                   	push   %ebx
  801970:	83 ec 1c             	sub    $0x1c,%esp
  801973:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801976:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801979:	50                   	push   %eax
  80197a:	53                   	push   %ebx
  80197b:	e8 0a fc ff ff       	call   80158a <fd_lookup>
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	85 c0                	test   %eax,%eax
  801985:	78 37                	js     8019be <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801987:	83 ec 08             	sub    $0x8,%esp
  80198a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198d:	50                   	push   %eax
  80198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801991:	ff 30                	pushl  (%eax)
  801993:	e8 42 fc ff ff       	call   8015da <dev_lookup>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	78 1f                	js     8019be <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80199f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019a6:	74 1b                	je     8019c3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ab:	8b 52 18             	mov    0x18(%edx),%edx
  8019ae:	85 d2                	test   %edx,%edx
  8019b0:	74 32                	je     8019e4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	50                   	push   %eax
  8019b9:	ff d2                	call   *%edx
  8019bb:	83 c4 10             	add    $0x10,%esp
}
  8019be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019c3:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019c8:	8b 40 48             	mov    0x48(%eax),%eax
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	53                   	push   %ebx
  8019cf:	50                   	push   %eax
  8019d0:	68 54 2a 80 00       	push   $0x802a54
  8019d5:	e8 d7 e7 ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e2:	eb da                	jmp    8019be <ftruncate+0x52>
		return -E_NOT_SUPP;
  8019e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019e9:	eb d3                	jmp    8019be <ftruncate+0x52>

008019eb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	53                   	push   %ebx
  8019ef:	83 ec 1c             	sub    $0x1c,%esp
  8019f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	e8 89 fb ff ff       	call   80158a <fd_lookup>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 4b                	js     801a53 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0e:	50                   	push   %eax
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	ff 30                	pushl  (%eax)
  801a14:	e8 c1 fb ff ff       	call   8015da <dev_lookup>
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	78 33                	js     801a53 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a23:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a27:	74 2f                	je     801a58 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a29:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a2c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a33:	00 00 00 
	stat->st_isdir = 0;
  801a36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a3d:	00 00 00 
	stat->st_dev = dev;
  801a40:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	53                   	push   %ebx
  801a4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a4d:	ff 50 14             	call   *0x14(%eax)
  801a50:	83 c4 10             	add    $0x10,%esp
}
  801a53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    
		return -E_NOT_SUPP;
  801a58:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a5d:	eb f4                	jmp    801a53 <fstat+0x68>

00801a5f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a64:	83 ec 08             	sub    $0x8,%esp
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 08             	pushl  0x8(%ebp)
  801a6c:	e8 e7 01 00 00       	call   801c58 <open>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	85 c0                	test   %eax,%eax
  801a78:	78 1b                	js     801a95 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a7a:	83 ec 08             	sub    $0x8,%esp
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	50                   	push   %eax
  801a81:	e8 65 ff ff ff       	call   8019eb <fstat>
  801a86:	89 c6                	mov    %eax,%esi
	close(fd);
  801a88:	89 1c 24             	mov    %ebx,(%esp)
  801a8b:	e8 27 fc ff ff       	call   8016b7 <close>
	return r;
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	89 f3                	mov    %esi,%ebx
}
  801a95:	89 d8                	mov    %ebx,%eax
  801a97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5e                   	pop    %esi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    

00801a9e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	56                   	push   %esi
  801aa2:	53                   	push   %ebx
  801aa3:	89 c6                	mov    %eax,%esi
  801aa5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801aa7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801aae:	74 27                	je     801ad7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ab0:	6a 07                	push   $0x7
  801ab2:	68 00 50 80 00       	push   $0x805000
  801ab7:	56                   	push   %esi
  801ab8:	ff 35 00 40 80 00    	pushl  0x804000
  801abe:	e8 64 07 00 00       	call   802227 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ac3:	83 c4 0c             	add    $0xc,%esp
  801ac6:	6a 00                	push   $0x0
  801ac8:	53                   	push   %ebx
  801ac9:	6a 00                	push   $0x0
  801acb:	e8 f0 06 00 00       	call   8021c0 <ipc_recv>
}
  801ad0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ad7:	83 ec 0c             	sub    $0xc,%esp
  801ada:	6a 01                	push   $0x1
  801adc:	e8 8f 07 00 00       	call   802270 <ipc_find_env>
  801ae1:	a3 00 40 80 00       	mov    %eax,0x804000
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	eb c5                	jmp    801ab0 <fsipc+0x12>

00801aeb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	8b 40 0c             	mov    0xc(%eax),%eax
  801af7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aff:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b04:	ba 00 00 00 00       	mov    $0x0,%edx
  801b09:	b8 02 00 00 00       	mov    $0x2,%eax
  801b0e:	e8 8b ff ff ff       	call   801a9e <fsipc>
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <devfile_flush>:
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b21:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b26:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2b:	b8 06 00 00 00       	mov    $0x6,%eax
  801b30:	e8 69 ff ff ff       	call   801a9e <fsipc>
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <devfile_stat>:
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	53                   	push   %ebx
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	8b 40 0c             	mov    0xc(%eax),%eax
  801b47:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b51:	b8 05 00 00 00       	mov    $0x5,%eax
  801b56:	e8 43 ff ff ff       	call   801a9e <fsipc>
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 2c                	js     801b8b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b5f:	83 ec 08             	sub    $0x8,%esp
  801b62:	68 00 50 80 00       	push   $0x805000
  801b67:	53                   	push   %ebx
  801b68:	e8 52 ed ff ff       	call   8008bf <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b6d:	a1 80 50 80 00       	mov    0x805080,%eax
  801b72:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b78:	a1 84 50 80 00       	mov    0x805084,%eax
  801b7d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b83:	83 c4 10             	add    $0x10,%esp
  801b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <devfile_write>:
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 0c             	sub    $0xc,%esp
  801b96:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b99:	8b 55 08             	mov    0x8(%ebp),%edx
  801b9c:	8b 52 0c             	mov    0xc(%edx),%edx
  801b9f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801ba5:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801baa:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801baf:	0f 47 c2             	cmova  %edx,%eax
  801bb2:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801bb7:	50                   	push   %eax
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	68 08 50 80 00       	push   $0x805008
  801bc0:	e8 88 ee ff ff       	call   800a4d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801bc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bca:	b8 04 00 00 00       	mov    $0x4,%eax
  801bcf:	e8 ca fe ff ff       	call   801a9e <fsipc>
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <devfile_read>:
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	8b 40 0c             	mov    0xc(%eax),%eax
  801be4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801be9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bef:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf4:	b8 03 00 00 00       	mov    $0x3,%eax
  801bf9:	e8 a0 fe ff ff       	call   801a9e <fsipc>
  801bfe:	89 c3                	mov    %eax,%ebx
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 1f                	js     801c23 <devfile_read+0x4d>
	assert(r <= n);
  801c04:	39 f0                	cmp    %esi,%eax
  801c06:	77 24                	ja     801c2c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c08:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c0d:	7f 33                	jg     801c42 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	50                   	push   %eax
  801c13:	68 00 50 80 00       	push   $0x805000
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	e8 2d ee ff ff       	call   800a4d <memmove>
	return r;
  801c20:	83 c4 10             	add    $0x10,%esp
}
  801c23:	89 d8                	mov    %ebx,%eax
  801c25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c28:	5b                   	pop    %ebx
  801c29:	5e                   	pop    %esi
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    
	assert(r <= n);
  801c2c:	68 c4 2a 80 00       	push   $0x802ac4
  801c31:	68 85 29 80 00       	push   $0x802985
  801c36:	6a 7c                	push   $0x7c
  801c38:	68 cb 2a 80 00       	push   $0x802acb
  801c3d:	e8 94 e4 ff ff       	call   8000d6 <_panic>
	assert(r <= PGSIZE);
  801c42:	68 d6 2a 80 00       	push   $0x802ad6
  801c47:	68 85 29 80 00       	push   $0x802985
  801c4c:	6a 7d                	push   $0x7d
  801c4e:	68 cb 2a 80 00       	push   $0x802acb
  801c53:	e8 7e e4 ff ff       	call   8000d6 <_panic>

00801c58 <open>:
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	56                   	push   %esi
  801c5c:	53                   	push   %ebx
  801c5d:	83 ec 1c             	sub    $0x1c,%esp
  801c60:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c63:	56                   	push   %esi
  801c64:	e8 1d ec ff ff       	call   800886 <strlen>
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c71:	7f 6c                	jg     801cdf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c79:	50                   	push   %eax
  801c7a:	e8 b9 f8 ff ff       	call   801538 <fd_alloc>
  801c7f:	89 c3                	mov    %eax,%ebx
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	85 c0                	test   %eax,%eax
  801c86:	78 3c                	js     801cc4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c88:	83 ec 08             	sub    $0x8,%esp
  801c8b:	56                   	push   %esi
  801c8c:	68 00 50 80 00       	push   $0x805000
  801c91:	e8 29 ec ff ff       	call   8008bf <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c99:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca6:	e8 f3 fd ff ff       	call   801a9e <fsipc>
  801cab:	89 c3                	mov    %eax,%ebx
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	78 19                	js     801ccd <open+0x75>
	return fd2num(fd);
  801cb4:	83 ec 0c             	sub    $0xc,%esp
  801cb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cba:	e8 52 f8 ff ff       	call   801511 <fd2num>
  801cbf:	89 c3                	mov    %eax,%ebx
  801cc1:	83 c4 10             	add    $0x10,%esp
}
  801cc4:	89 d8                	mov    %ebx,%eax
  801cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5e                   	pop    %esi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
		fd_close(fd, 0);
  801ccd:	83 ec 08             	sub    $0x8,%esp
  801cd0:	6a 00                	push   $0x0
  801cd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd5:	e8 56 f9 ff ff       	call   801630 <fd_close>
		return r;
  801cda:	83 c4 10             	add    $0x10,%esp
  801cdd:	eb e5                	jmp    801cc4 <open+0x6c>
		return -E_BAD_PATH;
  801cdf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ce4:	eb de                	jmp    801cc4 <open+0x6c>

00801ce6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cec:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf1:	b8 08 00 00 00       	mov    $0x8,%eax
  801cf6:	e8 a3 fd ff ff       	call   801a9e <fsipc>
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	56                   	push   %esi
  801d01:	53                   	push   %ebx
  801d02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	ff 75 08             	pushl  0x8(%ebp)
  801d0b:	e8 11 f8 ff ff       	call   801521 <fd2data>
  801d10:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d12:	83 c4 08             	add    $0x8,%esp
  801d15:	68 e2 2a 80 00       	push   $0x802ae2
  801d1a:	53                   	push   %ebx
  801d1b:	e8 9f eb ff ff       	call   8008bf <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d20:	8b 46 04             	mov    0x4(%esi),%eax
  801d23:	2b 06                	sub    (%esi),%eax
  801d25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d2b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d32:	00 00 00 
	stat->st_dev = &devpipe;
  801d35:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d3c:	30 80 00 
	return 0;
}
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d47:	5b                   	pop    %ebx
  801d48:	5e                   	pop    %esi
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	53                   	push   %ebx
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d55:	53                   	push   %ebx
  801d56:	6a 00                	push   $0x0
  801d58:	e8 d9 ef ff ff       	call   800d36 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d5d:	89 1c 24             	mov    %ebx,(%esp)
  801d60:	e8 bc f7 ff ff       	call   801521 <fd2data>
  801d65:	83 c4 08             	add    $0x8,%esp
  801d68:	50                   	push   %eax
  801d69:	6a 00                	push   $0x0
  801d6b:	e8 c6 ef ff ff       	call   800d36 <sys_page_unmap>
}
  801d70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <_pipeisclosed>:
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	57                   	push   %edi
  801d79:	56                   	push   %esi
  801d7a:	53                   	push   %ebx
  801d7b:	83 ec 1c             	sub    $0x1c,%esp
  801d7e:	89 c7                	mov    %eax,%edi
  801d80:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d82:	a1 04 40 80 00       	mov    0x804004,%eax
  801d87:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d8a:	83 ec 0c             	sub    $0xc,%esp
  801d8d:	57                   	push   %edi
  801d8e:	e8 1c 05 00 00       	call   8022af <pageref>
  801d93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d96:	89 34 24             	mov    %esi,(%esp)
  801d99:	e8 11 05 00 00       	call   8022af <pageref>
		nn = thisenv->env_runs;
  801d9e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801da4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	39 cb                	cmp    %ecx,%ebx
  801dac:	74 1b                	je     801dc9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801db1:	75 cf                	jne    801d82 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801db3:	8b 42 58             	mov    0x58(%edx),%eax
  801db6:	6a 01                	push   $0x1
  801db8:	50                   	push   %eax
  801db9:	53                   	push   %ebx
  801dba:	68 e9 2a 80 00       	push   $0x802ae9
  801dbf:	e8 ed e3 ff ff       	call   8001b1 <cprintf>
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	eb b9                	jmp    801d82 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dc9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dcc:	0f 94 c0             	sete   %al
  801dcf:	0f b6 c0             	movzbl %al,%eax
}
  801dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5f                   	pop    %edi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    

00801dda <devpipe_write>:
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	57                   	push   %edi
  801dde:	56                   	push   %esi
  801ddf:	53                   	push   %ebx
  801de0:	83 ec 28             	sub    $0x28,%esp
  801de3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801de6:	56                   	push   %esi
  801de7:	e8 35 f7 ff ff       	call   801521 <fd2data>
  801dec:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dee:	83 c4 10             	add    $0x10,%esp
  801df1:	bf 00 00 00 00       	mov    $0x0,%edi
  801df6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801df9:	74 4f                	je     801e4a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dfb:	8b 43 04             	mov    0x4(%ebx),%eax
  801dfe:	8b 0b                	mov    (%ebx),%ecx
  801e00:	8d 51 20             	lea    0x20(%ecx),%edx
  801e03:	39 d0                	cmp    %edx,%eax
  801e05:	72 14                	jb     801e1b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e07:	89 da                	mov    %ebx,%edx
  801e09:	89 f0                	mov    %esi,%eax
  801e0b:	e8 65 ff ff ff       	call   801d75 <_pipeisclosed>
  801e10:	85 c0                	test   %eax,%eax
  801e12:	75 3b                	jne    801e4f <devpipe_write+0x75>
			sys_yield();
  801e14:	e8 79 ee ff ff       	call   800c92 <sys_yield>
  801e19:	eb e0                	jmp    801dfb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e1e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e22:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e25:	89 c2                	mov    %eax,%edx
  801e27:	c1 fa 1f             	sar    $0x1f,%edx
  801e2a:	89 d1                	mov    %edx,%ecx
  801e2c:	c1 e9 1b             	shr    $0x1b,%ecx
  801e2f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e32:	83 e2 1f             	and    $0x1f,%edx
  801e35:	29 ca                	sub    %ecx,%edx
  801e37:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e3b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e3f:	83 c0 01             	add    $0x1,%eax
  801e42:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e45:	83 c7 01             	add    $0x1,%edi
  801e48:	eb ac                	jmp    801df6 <devpipe_write+0x1c>
	return i;
  801e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4d:	eb 05                	jmp    801e54 <devpipe_write+0x7a>
				return 0;
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5f                   	pop    %edi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    

00801e5c <devpipe_read>:
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	57                   	push   %edi
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
  801e62:	83 ec 18             	sub    $0x18,%esp
  801e65:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e68:	57                   	push   %edi
  801e69:	e8 b3 f6 ff ff       	call   801521 <fd2data>
  801e6e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e70:	83 c4 10             	add    $0x10,%esp
  801e73:	be 00 00 00 00       	mov    $0x0,%esi
  801e78:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e7b:	75 14                	jne    801e91 <devpipe_read+0x35>
	return i;
  801e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e80:	eb 02                	jmp    801e84 <devpipe_read+0x28>
				return i;
  801e82:	89 f0                	mov    %esi,%eax
}
  801e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
			sys_yield();
  801e8c:	e8 01 ee ff ff       	call   800c92 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e91:	8b 03                	mov    (%ebx),%eax
  801e93:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e96:	75 18                	jne    801eb0 <devpipe_read+0x54>
			if (i > 0)
  801e98:	85 f6                	test   %esi,%esi
  801e9a:	75 e6                	jne    801e82 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e9c:	89 da                	mov    %ebx,%edx
  801e9e:	89 f8                	mov    %edi,%eax
  801ea0:	e8 d0 fe ff ff       	call   801d75 <_pipeisclosed>
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	74 e3                	je     801e8c <devpipe_read+0x30>
				return 0;
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	eb d4                	jmp    801e84 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801eb0:	99                   	cltd   
  801eb1:	c1 ea 1b             	shr    $0x1b,%edx
  801eb4:	01 d0                	add    %edx,%eax
  801eb6:	83 e0 1f             	and    $0x1f,%eax
  801eb9:	29 d0                	sub    %edx,%eax
  801ebb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ec3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ec6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ec9:	83 c6 01             	add    $0x1,%esi
  801ecc:	eb aa                	jmp    801e78 <devpipe_read+0x1c>

00801ece <pipe>:
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	56                   	push   %esi
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ed6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed9:	50                   	push   %eax
  801eda:	e8 59 f6 ff ff       	call   801538 <fd_alloc>
  801edf:	89 c3                	mov    %eax,%ebx
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	0f 88 23 01 00 00    	js     80200f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	68 07 04 00 00       	push   $0x407
  801ef4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef7:	6a 00                	push   $0x0
  801ef9:	e8 b3 ed ff ff       	call   800cb1 <sys_page_alloc>
  801efe:	89 c3                	mov    %eax,%ebx
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	85 c0                	test   %eax,%eax
  801f05:	0f 88 04 01 00 00    	js     80200f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f11:	50                   	push   %eax
  801f12:	e8 21 f6 ff ff       	call   801538 <fd_alloc>
  801f17:	89 c3                	mov    %eax,%ebx
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	0f 88 db 00 00 00    	js     801fff <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	68 07 04 00 00       	push   $0x407
  801f2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2f:	6a 00                	push   $0x0
  801f31:	e8 7b ed ff ff       	call   800cb1 <sys_page_alloc>
  801f36:	89 c3                	mov    %eax,%ebx
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	0f 88 bc 00 00 00    	js     801fff <pipe+0x131>
	va = fd2data(fd0);
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	ff 75 f4             	pushl  -0xc(%ebp)
  801f49:	e8 d3 f5 ff ff       	call   801521 <fd2data>
  801f4e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f50:	83 c4 0c             	add    $0xc,%esp
  801f53:	68 07 04 00 00       	push   $0x407
  801f58:	50                   	push   %eax
  801f59:	6a 00                	push   $0x0
  801f5b:	e8 51 ed ff ff       	call   800cb1 <sys_page_alloc>
  801f60:	89 c3                	mov    %eax,%ebx
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	0f 88 82 00 00 00    	js     801fef <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	ff 75 f0             	pushl  -0x10(%ebp)
  801f73:	e8 a9 f5 ff ff       	call   801521 <fd2data>
  801f78:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f7f:	50                   	push   %eax
  801f80:	6a 00                	push   $0x0
  801f82:	56                   	push   %esi
  801f83:	6a 00                	push   $0x0
  801f85:	e8 6a ed ff ff       	call   800cf4 <sys_page_map>
  801f8a:	89 c3                	mov    %eax,%ebx
  801f8c:	83 c4 20             	add    $0x20,%esp
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	78 4e                	js     801fe1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f93:	a1 20 30 80 00       	mov    0x803020,%eax
  801f98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fa7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801faa:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbc:	e8 50 f5 ff ff       	call   801511 <fd2num>
  801fc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fc6:	83 c4 04             	add    $0x4,%esp
  801fc9:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcc:	e8 40 f5 ff ff       	call   801511 <fd2num>
  801fd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fdf:	eb 2e                	jmp    80200f <pipe+0x141>
	sys_page_unmap(0, va);
  801fe1:	83 ec 08             	sub    $0x8,%esp
  801fe4:	56                   	push   %esi
  801fe5:	6a 00                	push   $0x0
  801fe7:	e8 4a ed ff ff       	call   800d36 <sys_page_unmap>
  801fec:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fef:	83 ec 08             	sub    $0x8,%esp
  801ff2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff5:	6a 00                	push   $0x0
  801ff7:	e8 3a ed ff ff       	call   800d36 <sys_page_unmap>
  801ffc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fff:	83 ec 08             	sub    $0x8,%esp
  802002:	ff 75 f4             	pushl  -0xc(%ebp)
  802005:	6a 00                	push   $0x0
  802007:	e8 2a ed ff ff       	call   800d36 <sys_page_unmap>
  80200c:	83 c4 10             	add    $0x10,%esp
}
  80200f:	89 d8                	mov    %ebx,%eax
  802011:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802014:	5b                   	pop    %ebx
  802015:	5e                   	pop    %esi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    

00802018 <pipeisclosed>:
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802021:	50                   	push   %eax
  802022:	ff 75 08             	pushl  0x8(%ebp)
  802025:	e8 60 f5 ff ff       	call   80158a <fd_lookup>
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 18                	js     802049 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802031:	83 ec 0c             	sub    $0xc,%esp
  802034:	ff 75 f4             	pushl  -0xc(%ebp)
  802037:	e8 e5 f4 ff ff       	call   801521 <fd2data>
	return _pipeisclosed(fd, p);
  80203c:	89 c2                	mov    %eax,%edx
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	e8 2f fd ff ff       	call   801d75 <_pipeisclosed>
  802046:	83 c4 10             	add    $0x10,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	c3                   	ret    

00802051 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802057:	68 01 2b 80 00       	push   $0x802b01
  80205c:	ff 75 0c             	pushl  0xc(%ebp)
  80205f:	e8 5b e8 ff ff       	call   8008bf <strcpy>
	return 0;
}
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <devcons_write>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	57                   	push   %edi
  80206f:	56                   	push   %esi
  802070:	53                   	push   %ebx
  802071:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802077:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80207c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802082:	3b 75 10             	cmp    0x10(%ebp),%esi
  802085:	73 31                	jae    8020b8 <devcons_write+0x4d>
		m = n - tot;
  802087:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80208a:	29 f3                	sub    %esi,%ebx
  80208c:	83 fb 7f             	cmp    $0x7f,%ebx
  80208f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802094:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	53                   	push   %ebx
  80209b:	89 f0                	mov    %esi,%eax
  80209d:	03 45 0c             	add    0xc(%ebp),%eax
  8020a0:	50                   	push   %eax
  8020a1:	57                   	push   %edi
  8020a2:	e8 a6 e9 ff ff       	call   800a4d <memmove>
		sys_cputs(buf, m);
  8020a7:	83 c4 08             	add    $0x8,%esp
  8020aa:	53                   	push   %ebx
  8020ab:	57                   	push   %edi
  8020ac:	e8 44 eb ff ff       	call   800bf5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020b1:	01 de                	add    %ebx,%esi
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	eb ca                	jmp    802082 <devcons_write+0x17>
}
  8020b8:	89 f0                	mov    %esi,%eax
  8020ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020bd:	5b                   	pop    %ebx
  8020be:	5e                   	pop    %esi
  8020bf:	5f                   	pop    %edi
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    

008020c2 <devcons_read>:
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 08             	sub    $0x8,%esp
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020d1:	74 21                	je     8020f4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020d3:	e8 3b eb ff ff       	call   800c13 <sys_cgetc>
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	75 07                	jne    8020e3 <devcons_read+0x21>
		sys_yield();
  8020dc:	e8 b1 eb ff ff       	call   800c92 <sys_yield>
  8020e1:	eb f0                	jmp    8020d3 <devcons_read+0x11>
	if (c < 0)
  8020e3:	78 0f                	js     8020f4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020e5:	83 f8 04             	cmp    $0x4,%eax
  8020e8:	74 0c                	je     8020f6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ed:	88 02                	mov    %al,(%edx)
	return 1;
  8020ef:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    
		return 0;
  8020f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fb:	eb f7                	jmp    8020f4 <devcons_read+0x32>

008020fd <cputchar>:
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802109:	6a 01                	push   $0x1
  80210b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80210e:	50                   	push   %eax
  80210f:	e8 e1 ea ff ff       	call   800bf5 <sys_cputs>
}
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <getchar>:
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80211f:	6a 01                	push   $0x1
  802121:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802124:	50                   	push   %eax
  802125:	6a 00                	push   $0x0
  802127:	e8 c9 f6 ff ff       	call   8017f5 <read>
	if (r < 0)
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	85 c0                	test   %eax,%eax
  802131:	78 06                	js     802139 <getchar+0x20>
	if (r < 1)
  802133:	74 06                	je     80213b <getchar+0x22>
	return c;
  802135:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    
		return -E_EOF;
  80213b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802140:	eb f7                	jmp    802139 <getchar+0x20>

00802142 <iscons>:
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802148:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214b:	50                   	push   %eax
  80214c:	ff 75 08             	pushl  0x8(%ebp)
  80214f:	e8 36 f4 ff ff       	call   80158a <fd_lookup>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	78 11                	js     80216c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802164:	39 10                	cmp    %edx,(%eax)
  802166:	0f 94 c0             	sete   %al
  802169:	0f b6 c0             	movzbl %al,%eax
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <opencons>:
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802174:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802177:	50                   	push   %eax
  802178:	e8 bb f3 ff ff       	call   801538 <fd_alloc>
  80217d:	83 c4 10             	add    $0x10,%esp
  802180:	85 c0                	test   %eax,%eax
  802182:	78 3a                	js     8021be <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802184:	83 ec 04             	sub    $0x4,%esp
  802187:	68 07 04 00 00       	push   $0x407
  80218c:	ff 75 f4             	pushl  -0xc(%ebp)
  80218f:	6a 00                	push   $0x0
  802191:	e8 1b eb ff ff       	call   800cb1 <sys_page_alloc>
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	85 c0                	test   %eax,%eax
  80219b:	78 21                	js     8021be <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021b2:	83 ec 0c             	sub    $0xc,%esp
  8021b5:	50                   	push   %eax
  8021b6:	e8 56 f3 ff ff       	call   801511 <fd2num>
  8021bb:	83 c4 10             	add    $0x10,%esp
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	56                   	push   %esi
  8021c4:	53                   	push   %ebx
  8021c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8021c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  8021ce:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8021d0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021d5:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  8021d8:	83 ec 0c             	sub    $0xc,%esp
  8021db:	50                   	push   %eax
  8021dc:	e8 c1 ec ff ff       	call   800ea2 <sys_ipc_recv>
	if (from_env_store)
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	85 f6                	test   %esi,%esi
  8021e6:	74 14                	je     8021fc <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  8021e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	78 09                	js     8021fa <ipc_recv+0x3a>
  8021f1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8021f7:	8b 52 78             	mov    0x78(%edx),%edx
  8021fa:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  8021fc:	85 db                	test   %ebx,%ebx
  8021fe:	74 14                	je     802214 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  802200:	ba 00 00 00 00       	mov    $0x0,%edx
  802205:	85 c0                	test   %eax,%eax
  802207:	78 09                	js     802212 <ipc_recv+0x52>
  802209:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80220f:	8b 52 7c             	mov    0x7c(%edx),%edx
  802212:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  802214:	85 c0                	test   %eax,%eax
  802216:	78 08                	js     802220 <ipc_recv+0x60>
  802218:	a1 04 40 80 00       	mov    0x804004,%eax
  80221d:	8b 40 74             	mov    0x74(%eax),%eax
}
  802220:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802223:	5b                   	pop    %ebx
  802224:	5e                   	pop    %esi
  802225:	5d                   	pop    %ebp
  802226:	c3                   	ret    

00802227 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 08             	sub    $0x8,%esp
  80222d:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  802230:	85 c0                	test   %eax,%eax
  802232:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802237:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80223a:	ff 75 14             	pushl  0x14(%ebp)
  80223d:	50                   	push   %eax
  80223e:	ff 75 0c             	pushl  0xc(%ebp)
  802241:	ff 75 08             	pushl  0x8(%ebp)
  802244:	e8 36 ec ff ff       	call   800e7f <sys_ipc_try_send>
  802249:	83 c4 10             	add    $0x10,%esp
  80224c:	85 c0                	test   %eax,%eax
  80224e:	78 02                	js     802252 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  802252:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802255:	75 07                	jne    80225e <ipc_send+0x37>
		sys_yield();
  802257:	e8 36 ea ff ff       	call   800c92 <sys_yield>
}
  80225c:	eb f2                	jmp    802250 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  80225e:	50                   	push   %eax
  80225f:	68 0d 2b 80 00       	push   $0x802b0d
  802264:	6a 3c                	push   $0x3c
  802266:	68 21 2b 80 00       	push   $0x802b21
  80226b:	e8 66 de ff ff       	call   8000d6 <_panic>

00802270 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802276:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  80227b:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80227e:	c1 e0 04             	shl    $0x4,%eax
  802281:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802286:	8b 40 50             	mov    0x50(%eax),%eax
  802289:	39 c8                	cmp    %ecx,%eax
  80228b:	74 12                	je     80229f <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80228d:	83 c2 01             	add    $0x1,%edx
  802290:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  802296:	75 e3                	jne    80227b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
  80229d:	eb 0e                	jmp    8022ad <ipc_find_env+0x3d>
			return envs[i].env_id;
  80229f:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8022a2:	c1 e0 04             	shl    $0x4,%eax
  8022a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022aa:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022ad:	5d                   	pop    %ebp
  8022ae:	c3                   	ret    

008022af <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022b5:	89 d0                	mov    %edx,%eax
  8022b7:	c1 e8 16             	shr    $0x16,%eax
  8022ba:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022c6:	f6 c1 01             	test   $0x1,%cl
  8022c9:	74 1d                	je     8022e8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022cb:	c1 ea 0c             	shr    $0xc,%edx
  8022ce:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022d5:	f6 c2 01             	test   $0x1,%dl
  8022d8:	74 0e                	je     8022e8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022da:	c1 ea 0c             	shr    $0xc,%edx
  8022dd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022e4:	ef 
  8022e5:	0f b7 c0             	movzwl %ax,%eax
}
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <__udivdi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 1c             	sub    $0x1c,%esp
  8022f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802303:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802307:	85 d2                	test   %edx,%edx
  802309:	75 4d                	jne    802358 <__udivdi3+0x68>
  80230b:	39 f3                	cmp    %esi,%ebx
  80230d:	76 19                	jbe    802328 <__udivdi3+0x38>
  80230f:	31 ff                	xor    %edi,%edi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f2                	mov    %esi,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	89 d9                	mov    %ebx,%ecx
  80232a:	85 db                	test   %ebx,%ebx
  80232c:	75 0b                	jne    802339 <__udivdi3+0x49>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 c1                	mov    %eax,%ecx
  802339:	31 d2                	xor    %edx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	f7 f1                	div    %ecx
  80233f:	89 c6                	mov    %eax,%esi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f7                	mov    %esi,%edi
  802345:	f7 f1                	div    %ecx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	77 1c                	ja     802378 <__udivdi3+0x88>
  80235c:	0f bd fa             	bsr    %edx,%edi
  80235f:	83 f7 1f             	xor    $0x1f,%edi
  802362:	75 2c                	jne    802390 <__udivdi3+0xa0>
  802364:	39 f2                	cmp    %esi,%edx
  802366:	72 06                	jb     80236e <__udivdi3+0x7e>
  802368:	31 c0                	xor    %eax,%eax
  80236a:	39 eb                	cmp    %ebp,%ebx
  80236c:	77 a9                	ja     802317 <__udivdi3+0x27>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	eb a2                	jmp    802317 <__udivdi3+0x27>
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	31 c0                	xor    %eax,%eax
  80237c:	89 fa                	mov    %edi,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 f9                	mov    %edi,%ecx
  802392:	b8 20 00 00 00       	mov    $0x20,%eax
  802397:	29 f8                	sub    %edi,%eax
  802399:	d3 e2                	shl    %cl,%edx
  80239b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	d3 ea                	shr    %cl,%edx
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 d1                	or     %edx,%ecx
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 c1                	mov    %eax,%ecx
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	89 eb                	mov    %ebp,%ebx
  8023c1:	d3 e6                	shl    %cl,%esi
  8023c3:	89 c1                	mov    %eax,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 de                	or     %ebx,%esi
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	f7 74 24 08          	divl   0x8(%esp)
  8023cf:	89 d6                	mov    %edx,%esi
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	f7 64 24 0c          	mull   0xc(%esp)
  8023d7:	39 d6                	cmp    %edx,%esi
  8023d9:	72 15                	jb     8023f0 <__udivdi3+0x100>
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e5                	shl    %cl,%ebp
  8023df:	39 c5                	cmp    %eax,%ebp
  8023e1:	73 04                	jae    8023e7 <__udivdi3+0xf7>
  8023e3:	39 d6                	cmp    %edx,%esi
  8023e5:	74 09                	je     8023f0 <__udivdi3+0x100>
  8023e7:	89 d8                	mov    %ebx,%eax
  8023e9:	31 ff                	xor    %edi,%edi
  8023eb:	e9 27 ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 1d ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__umoddi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80240b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80240f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802417:	89 da                	mov    %ebx,%edx
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 43                	jne    802460 <__umoddi3+0x60>
  80241d:	39 df                	cmp    %ebx,%edi
  80241f:	76 17                	jbe    802438 <__umoddi3+0x38>
  802421:	89 f0                	mov    %esi,%eax
  802423:	f7 f7                	div    %edi
  802425:	89 d0                	mov    %edx,%eax
  802427:	31 d2                	xor    %edx,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 fd                	mov    %edi,%ebp
  80243a:	85 ff                	test   %edi,%edi
  80243c:	75 0b                	jne    802449 <__umoddi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f7                	div    %edi
  802447:	89 c5                	mov    %eax,%ebp
  802449:	89 d8                	mov    %ebx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f5                	div    %ebp
  80244f:	89 f0                	mov    %esi,%eax
  802451:	f7 f5                	div    %ebp
  802453:	89 d0                	mov    %edx,%eax
  802455:	eb d0                	jmp    802427 <__umoddi3+0x27>
  802457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245e:	66 90                	xchg   %ax,%ax
  802460:	89 f1                	mov    %esi,%ecx
  802462:	39 d8                	cmp    %ebx,%eax
  802464:	76 0a                	jbe    802470 <__umoddi3+0x70>
  802466:	89 f0                	mov    %esi,%eax
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	0f bd e8             	bsr    %eax,%ebp
  802473:	83 f5 1f             	xor    $0x1f,%ebp
  802476:	75 20                	jne    802498 <__umoddi3+0x98>
  802478:	39 d8                	cmp    %ebx,%eax
  80247a:	0f 82 b0 00 00 00    	jb     802530 <__umoddi3+0x130>
  802480:	39 f7                	cmp    %esi,%edi
  802482:	0f 86 a8 00 00 00    	jbe    802530 <__umoddi3+0x130>
  802488:	89 c8                	mov    %ecx,%eax
  80248a:	83 c4 1c             	add    $0x1c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
  802492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	ba 20 00 00 00       	mov    $0x20,%edx
  80249f:	29 ea                	sub    %ebp,%edx
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024b9:	09 c1                	or     %eax,%ecx
  8024bb:	89 d8                	mov    %ebx,%eax
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e7                	shl    %cl,%edi
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 c7                	mov    %eax,%edi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	d3 e6                	shl    %cl,%esi
  8024df:	09 d8                	or     %ebx,%eax
  8024e1:	f7 74 24 08          	divl   0x8(%esp)
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	89 f3                	mov    %esi,%ebx
  8024e9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d7                	mov    %edx,%edi
  8024f1:	39 d1                	cmp    %edx,%ecx
  8024f3:	72 06                	jb     8024fb <__umoddi3+0xfb>
  8024f5:	75 10                	jne    802507 <__umoddi3+0x107>
  8024f7:	39 c3                	cmp    %eax,%ebx
  8024f9:	73 0c                	jae    802507 <__umoddi3+0x107>
  8024fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802503:	89 d7                	mov    %edx,%edi
  802505:	89 c6                	mov    %eax,%esi
  802507:	89 ca                	mov    %ecx,%edx
  802509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250e:	29 f3                	sub    %esi,%ebx
  802510:	19 fa                	sbb    %edi,%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	d3 e0                	shl    %cl,%eax
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	d3 eb                	shr    %cl,%ebx
  80251a:	d3 ea                	shr    %cl,%edx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 da                	mov    %ebx,%edx
  802532:	29 fe                	sub    %edi,%esi
  802534:	19 c2                	sbb    %eax,%edx
  802536:	89 f1                	mov    %esi,%ecx
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	e9 4b ff ff ff       	jmp    80248a <__umoddi3+0x8a>
