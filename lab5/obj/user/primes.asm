
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 c5 00 00 00       	call   8000f6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 84 12 00 00       	call   8012d0 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 20 80 00       	mov    0x802004,%eax
  800053:	8b 40 60             	mov    0x60(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 a0 16 80 00       	push   $0x8016a0
  800060:	e8 c7 01 00 00       	call   80022c <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 39 10 00 00       	call   8010a3 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 07                	js     80007a <primeproc+0x47>
		panic("fork: %e", id);
	if (id == 0)
  800073:	74 ca                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800075:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800078:	eb 20                	jmp    80009a <primeproc+0x67>
		panic("fork: %e", id);
  80007a:	50                   	push   %eax
  80007b:	68 60 1b 80 00       	push   $0x801b60
  800080:	6a 1a                	push   $0x1a
  800082:	68 ac 16 80 00       	push   $0x8016ac
  800087:	e8 c5 00 00 00       	call   800151 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	51                   	push   %ecx
  800091:	57                   	push   %edi
  800092:	e8 a0 12 00 00       	call   801337 <ipc_send>
  800097:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 00                	push   $0x0
  80009f:	6a 00                	push   $0x0
  8000a1:	56                   	push   %esi
  8000a2:	e8 29 12 00 00       	call   8012d0 <ipc_recv>
  8000a7:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000a9:	99                   	cltd   
  8000aa:	f7 fb                	idiv   %ebx
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	85 d2                	test   %edx,%edx
  8000b1:	74 e7                	je     80009a <primeproc+0x67>
  8000b3:	eb d7                	jmp    80008c <primeproc+0x59>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 e4 0f 00 00       	call   8010a3 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1a                	js     8000df <umain+0x2a>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	74 25                	je     8000f1 <umain+0x3c>
		ipc_send(id, i, 0, 0);
  8000cc:	6a 00                	push   $0x0
  8000ce:	6a 00                	push   $0x0
  8000d0:	53                   	push   %ebx
  8000d1:	56                   	push   %esi
  8000d2:	e8 60 12 00 00       	call   801337 <ipc_send>
	for (i = 2; ; i++)
  8000d7:	83 c3 01             	add    $0x1,%ebx
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	eb ed                	jmp    8000cc <umain+0x17>
		panic("fork: %e", id);
  8000df:	50                   	push   %eax
  8000e0:	68 60 1b 80 00       	push   $0x801b60
  8000e5:	6a 2d                	push   $0x2d
  8000e7:	68 ac 16 80 00       	push   $0x8016ac
  8000ec:	e8 60 00 00 00       	call   800151 <_panic>
		primeproc();
  8000f1:	e8 3d ff ff ff       	call   800033 <primeproc>

008000f6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	56                   	push   %esi
  8000fa:	53                   	push   %ebx
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800101:	e8 e8 0b 00 00       	call   800cee <sys_getenvid>
  800106:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010b:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80010e:	c1 e0 04             	shl    $0x4,%eax
  800111:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800116:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011b:	85 db                	test   %ebx,%ebx
  80011d:	7e 07                	jle    800126 <libmain+0x30>
		binaryname = argv[0];
  80011f:	8b 06                	mov    (%esi),%eax
  800121:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	56                   	push   %esi
  80012a:	53                   	push   %ebx
  80012b:	e8 85 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  800130:	e8 0a 00 00 00       	call   80013f <exit>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013b:	5b                   	pop    %ebx
  80013c:	5e                   	pop    %esi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800145:	6a 00                	push   $0x0
  800147:	e8 61 0b 00 00       	call   800cad <sys_env_destroy>
}
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	c9                   	leave  
  800150:	c3                   	ret    

00800151 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	56                   	push   %esi
  800155:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800156:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800159:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80015f:	e8 8a 0b 00 00       	call   800cee <sys_getenvid>
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	ff 75 0c             	pushl  0xc(%ebp)
  80016a:	ff 75 08             	pushl  0x8(%ebp)
  80016d:	56                   	push   %esi
  80016e:	50                   	push   %eax
  80016f:	68 c4 16 80 00       	push   $0x8016c4
  800174:	e8 b3 00 00 00       	call   80022c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800179:	83 c4 18             	add    $0x18,%esp
  80017c:	53                   	push   %ebx
  80017d:	ff 75 10             	pushl  0x10(%ebp)
  800180:	e8 56 00 00 00       	call   8001db <vcprintf>
	cprintf("\n");
  800185:	c7 04 24 31 1b 80 00 	movl   $0x801b31,(%esp)
  80018c:	e8 9b 00 00 00       	call   80022c <cprintf>
  800191:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800194:	cc                   	int3   
  800195:	eb fd                	jmp    800194 <_panic+0x43>

00800197 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a1:	8b 13                	mov    (%ebx),%edx
  8001a3:	8d 42 01             	lea    0x1(%edx),%eax
  8001a6:	89 03                	mov    %eax,(%ebx)
  8001a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	74 09                	je     8001bf <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	68 ff 00 00 00       	push   $0xff
  8001c7:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ca:	50                   	push   %eax
  8001cb:	e8 a0 0a 00 00       	call   800c70 <sys_cputs>
		b->idx = 0;
  8001d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	eb db                	jmp    8001b6 <putch+0x1f>

008001db <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001eb:	00 00 00 
	b.cnt = 0;
  8001ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	68 97 01 80 00       	push   $0x800197
  80020a:	e8 4a 01 00 00       	call   800359 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020f:	83 c4 08             	add    $0x8,%esp
  800212:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800218:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	e8 4c 0a 00 00       	call   800c70 <sys_cputs>

	return b.cnt;
}
  800224:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800232:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800235:	50                   	push   %eax
  800236:	ff 75 08             	pushl  0x8(%ebp)
  800239:	e8 9d ff ff ff       	call   8001db <vcprintf>
	va_end(ap);

	return cnt;
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 1c             	sub    $0x1c,%esp
  800249:	89 c6                	mov    %eax,%esi
  80024b:	89 d7                	mov    %edx,%edi
  80024d:	8b 45 08             	mov    0x8(%ebp),%eax
  800250:	8b 55 0c             	mov    0xc(%ebp),%edx
  800253:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800256:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800259:	8b 45 10             	mov    0x10(%ebp),%eax
  80025c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80025f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800263:	74 2c                	je     800291 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800265:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800268:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80026f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800272:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800275:	39 c2                	cmp    %eax,%edx
  800277:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80027a:	73 43                	jae    8002bf <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80027c:	83 eb 01             	sub    $0x1,%ebx
  80027f:	85 db                	test   %ebx,%ebx
  800281:	7e 6c                	jle    8002ef <printnum+0xaf>
			putch(padc, putdat);
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	57                   	push   %edi
  800287:	ff 75 18             	pushl  0x18(%ebp)
  80028a:	ff d6                	call   *%esi
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	eb eb                	jmp    80027c <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	6a 20                	push   $0x20
  800296:	6a 00                	push   $0x0
  800298:	50                   	push   %eax
  800299:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029c:	ff 75 e0             	pushl  -0x20(%ebp)
  80029f:	89 fa                	mov    %edi,%edx
  8002a1:	89 f0                	mov    %esi,%eax
  8002a3:	e8 98 ff ff ff       	call   800240 <printnum>
		while (--width > 0)
  8002a8:	83 c4 20             	add    $0x20,%esp
  8002ab:	83 eb 01             	sub    $0x1,%ebx
  8002ae:	85 db                	test   %ebx,%ebx
  8002b0:	7e 65                	jle    800317 <printnum+0xd7>
			putch(padc, putdat);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	57                   	push   %edi
  8002b6:	6a 20                	push   $0x20
  8002b8:	ff d6                	call   *%esi
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	eb ec                	jmp    8002ab <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	ff 75 18             	pushl  0x18(%ebp)
  8002c5:	83 eb 01             	sub    $0x1,%ebx
  8002c8:	53                   	push   %ebx
  8002c9:	50                   	push   %eax
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d9:	e8 72 11 00 00       	call   801450 <__udivdi3>
  8002de:	83 c4 18             	add    $0x18,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	89 fa                	mov    %edi,%edx
  8002e5:	89 f0                	mov    %esi,%eax
  8002e7:	e8 54 ff ff ff       	call   800240 <printnum>
  8002ec:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ef:	83 ec 08             	sub    $0x8,%esp
  8002f2:	57                   	push   %edi
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800302:	e8 59 12 00 00       	call   801560 <__umoddi3>
  800307:	83 c4 14             	add    $0x14,%esp
  80030a:	0f be 80 e7 16 80 00 	movsbl 0x8016e7(%eax),%eax
  800311:	50                   	push   %eax
  800312:	ff d6                	call   *%esi
  800314:	83 c4 10             	add    $0x10,%esp
}
  800317:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031a:	5b                   	pop    %ebx
  80031b:	5e                   	pop    %esi
  80031c:	5f                   	pop    %edi
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    

0080031f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800325:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	3b 50 04             	cmp    0x4(%eax),%edx
  80032e:	73 0a                	jae    80033a <sprintputch+0x1b>
		*b->buf++ = ch;
  800330:	8d 4a 01             	lea    0x1(%edx),%ecx
  800333:	89 08                	mov    %ecx,(%eax)
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	88 02                	mov    %al,(%edx)
}
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    

0080033c <printfmt>:
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800342:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 05 00 00 00       	call   800359 <vprintfmt>
}
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <vprintfmt>:
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	57                   	push   %edi
  80035d:	56                   	push   %esi
  80035e:	53                   	push   %ebx
  80035f:	83 ec 3c             	sub    $0x3c,%esp
  800362:	8b 75 08             	mov    0x8(%ebp),%esi
  800365:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800368:	8b 7d 10             	mov    0x10(%ebp),%edi
  80036b:	e9 b4 03 00 00       	jmp    800724 <vprintfmt+0x3cb>
		padc = ' ';
  800370:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800374:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80037b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800382:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800389:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800390:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800395:	8d 47 01             	lea    0x1(%edi),%eax
  800398:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039b:	0f b6 17             	movzbl (%edi),%edx
  80039e:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a1:	3c 55                	cmp    $0x55,%al
  8003a3:	0f 87 c8 04 00 00    	ja     800871 <vprintfmt+0x518>
  8003a9:	0f b6 c0             	movzbl %al,%eax
  8003ac:	ff 24 85 c0 18 80 00 	jmp    *0x8018c0(,%eax,4)
  8003b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8003b6:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8003bd:	eb d6                	jmp    800395 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003c2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003c6:	eb cd                	jmp    800395 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003c8:	0f b6 d2             	movzbl %dl,%edx
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8003d6:	eb 0c                	jmp    8003e4 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003db:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003df:	eb b4                	jmp    800395 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8003e1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003e4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003e7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003eb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ee:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003f1:	83 f9 09             	cmp    $0x9,%ecx
  8003f4:	76 eb                	jbe    8003e1 <vprintfmt+0x88>
  8003f6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fc:	eb 14                	jmp    800412 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	8d 40 04             	lea    0x4(%eax),%eax
  80040c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800412:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800416:	0f 89 79 ff ff ff    	jns    800395 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80041c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800422:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800429:	e9 67 ff ff ff       	jmp    800395 <vprintfmt+0x3c>
  80042e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800431:	85 c0                	test   %eax,%eax
  800433:	ba 00 00 00 00       	mov    $0x0,%edx
  800438:	0f 49 d0             	cmovns %eax,%edx
  80043b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80043e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800441:	e9 4f ff ff ff       	jmp    800395 <vprintfmt+0x3c>
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800449:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800450:	e9 40 ff ff ff       	jmp    800395 <vprintfmt+0x3c>
			lflag++;
  800455:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80045b:	e9 35 ff ff ff       	jmp    800395 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800460:	8b 45 14             	mov    0x14(%ebp),%eax
  800463:	8d 78 04             	lea    0x4(%eax),%edi
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	53                   	push   %ebx
  80046a:	ff 30                	pushl  (%eax)
  80046c:	ff d6                	call   *%esi
			break;
  80046e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800474:	e9 a8 02 00 00       	jmp    800721 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	8d 78 04             	lea    0x4(%eax),%edi
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	99                   	cltd   
  800482:	31 d0                	xor    %edx,%eax
  800484:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800486:	83 f8 0f             	cmp    $0xf,%eax
  800489:	7f 23                	jg     8004ae <vprintfmt+0x155>
  80048b:	8b 14 85 20 1a 80 00 	mov    0x801a20(,%eax,4),%edx
  800492:	85 d2                	test   %edx,%edx
  800494:	74 18                	je     8004ae <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800496:	52                   	push   %edx
  800497:	68 08 17 80 00       	push   $0x801708
  80049c:	53                   	push   %ebx
  80049d:	56                   	push   %esi
  80049e:	e8 99 fe ff ff       	call   80033c <printfmt>
  8004a3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004a9:	e9 73 02 00 00       	jmp    800721 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8004ae:	50                   	push   %eax
  8004af:	68 ff 16 80 00       	push   $0x8016ff
  8004b4:	53                   	push   %ebx
  8004b5:	56                   	push   %esi
  8004b6:	e8 81 fe ff ff       	call   80033c <printfmt>
  8004bb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004be:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c1:	e9 5b 02 00 00       	jmp    800721 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c9:	83 c0 04             	add    $0x4,%eax
  8004cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004d4:	85 d2                	test   %edx,%edx
  8004d6:	b8 f8 16 80 00       	mov    $0x8016f8,%eax
  8004db:	0f 45 c2             	cmovne %edx,%eax
  8004de:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e5:	7e 06                	jle    8004ed <vprintfmt+0x194>
  8004e7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004eb:	75 0d                	jne    8004fa <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	89 c7                	mov    %eax,%edi
  8004f2:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f8:	eb 53                	jmp    80054d <vprintfmt+0x1f4>
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800500:	50                   	push   %eax
  800501:	e8 13 04 00 00       	call   800919 <strnlen>
  800506:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800509:	29 c1                	sub    %eax,%ecx
  80050b:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800513:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800517:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80051a:	eb 0f                	jmp    80052b <vprintfmt+0x1d2>
					putch(padc, putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	53                   	push   %ebx
  800520:	ff 75 e0             	pushl  -0x20(%ebp)
  800523:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800525:	83 ef 01             	sub    $0x1,%edi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	85 ff                	test   %edi,%edi
  80052d:	7f ed                	jg     80051c <vprintfmt+0x1c3>
  80052f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800532:	85 d2                	test   %edx,%edx
  800534:	b8 00 00 00 00       	mov    $0x0,%eax
  800539:	0f 49 c2             	cmovns %edx,%eax
  80053c:	29 c2                	sub    %eax,%edx
  80053e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800541:	eb aa                	jmp    8004ed <vprintfmt+0x194>
					putch(ch, putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	52                   	push   %edx
  800548:	ff d6                	call   *%esi
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800550:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800552:	83 c7 01             	add    $0x1,%edi
  800555:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800559:	0f be d0             	movsbl %al,%edx
  80055c:	85 d2                	test   %edx,%edx
  80055e:	74 4b                	je     8005ab <vprintfmt+0x252>
  800560:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800564:	78 06                	js     80056c <vprintfmt+0x213>
  800566:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056a:	78 1e                	js     80058a <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80056c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800570:	74 d1                	je     800543 <vprintfmt+0x1ea>
  800572:	0f be c0             	movsbl %al,%eax
  800575:	83 e8 20             	sub    $0x20,%eax
  800578:	83 f8 5e             	cmp    $0x5e,%eax
  80057b:	76 c6                	jbe    800543 <vprintfmt+0x1ea>
					putch('?', putdat);
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	53                   	push   %ebx
  800581:	6a 3f                	push   $0x3f
  800583:	ff d6                	call   *%esi
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	eb c3                	jmp    80054d <vprintfmt+0x1f4>
  80058a:	89 cf                	mov    %ecx,%edi
  80058c:	eb 0e                	jmp    80059c <vprintfmt+0x243>
				putch(' ', putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	53                   	push   %ebx
  800592:	6a 20                	push   $0x20
  800594:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800596:	83 ef 01             	sub    $0x1,%edi
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	85 ff                	test   %edi,%edi
  80059e:	7f ee                	jg     80058e <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a6:	e9 76 01 00 00       	jmp    800721 <vprintfmt+0x3c8>
  8005ab:	89 cf                	mov    %ecx,%edi
  8005ad:	eb ed                	jmp    80059c <vprintfmt+0x243>
	if (lflag >= 2)
  8005af:	83 f9 01             	cmp    $0x1,%ecx
  8005b2:	7f 1f                	jg     8005d3 <vprintfmt+0x27a>
	else if (lflag)
  8005b4:	85 c9                	test   %ecx,%ecx
  8005b6:	74 6a                	je     800622 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c0:	89 c1                	mov    %eax,%ecx
  8005c2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d1:	eb 17                	jmp    8005ea <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 50 04             	mov    0x4(%eax),%edx
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 08             	lea    0x8(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005ed:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005f2:	85 d2                	test   %edx,%edx
  8005f4:	0f 89 f8 00 00 00    	jns    8006f2 <vprintfmt+0x399>
				putch('-', putdat);
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	53                   	push   %ebx
  8005fe:	6a 2d                	push   $0x2d
  800600:	ff d6                	call   *%esi
				num = -(long long) num;
  800602:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800605:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800608:	f7 d8                	neg    %eax
  80060a:	83 d2 00             	adc    $0x0,%edx
  80060d:	f7 da                	neg    %edx
  80060f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800612:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800615:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800618:	bf 0a 00 00 00       	mov    $0xa,%edi
  80061d:	e9 e1 00 00 00       	jmp    800703 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062a:	99                   	cltd   
  80062b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 40 04             	lea    0x4(%eax),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	eb b1                	jmp    8005ea <vprintfmt+0x291>
	if (lflag >= 2)
  800639:	83 f9 01             	cmp    $0x1,%ecx
  80063c:	7f 27                	jg     800665 <vprintfmt+0x30c>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	74 41                	je     800683 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	ba 00 00 00 00       	mov    $0x0,%edx
  80064c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8d 40 04             	lea    0x4(%eax),%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800660:	e9 8d 00 00 00       	jmp    8006f2 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800670:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8d 40 08             	lea    0x8(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800681:	eb 6f                	jmp    8006f2 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	ba 00 00 00 00       	mov    $0x0,%edx
  80068d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800690:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 40 04             	lea    0x4(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069c:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006a1:	eb 4f                	jmp    8006f2 <vprintfmt+0x399>
	if (lflag >= 2)
  8006a3:	83 f9 01             	cmp    $0x1,%ecx
  8006a6:	7f 23                	jg     8006cb <vprintfmt+0x372>
	else if (lflag)
  8006a8:	85 c9                	test   %ecx,%ecx
  8006aa:	0f 84 98 00 00 00    	je     800748 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 40 04             	lea    0x4(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c9:	eb 17                	jmp    8006e2 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 50 04             	mov    0x4(%eax),%edx
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 40 08             	lea    0x8(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	53                   	push   %ebx
  8006e6:	6a 30                	push   $0x30
  8006e8:	ff d6                	call   *%esi
			goto number;
  8006ea:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006ed:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8006f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006f6:	74 0b                	je     800703 <vprintfmt+0x3aa>
				putch('+', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	6a 2b                	push   $0x2b
  8006fe:	ff d6                	call   *%esi
  800700:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800703:	83 ec 0c             	sub    $0xc,%esp
  800706:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80070a:	50                   	push   %eax
  80070b:	ff 75 e0             	pushl  -0x20(%ebp)
  80070e:	57                   	push   %edi
  80070f:	ff 75 dc             	pushl  -0x24(%ebp)
  800712:	ff 75 d8             	pushl  -0x28(%ebp)
  800715:	89 da                	mov    %ebx,%edx
  800717:	89 f0                	mov    %esi,%eax
  800719:	e8 22 fb ff ff       	call   800240 <printnum>
			break;
  80071e:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800721:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800724:	83 c7 01             	add    $0x1,%edi
  800727:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072b:	83 f8 25             	cmp    $0x25,%eax
  80072e:	0f 84 3c fc ff ff    	je     800370 <vprintfmt+0x17>
			if (ch == '\0')
  800734:	85 c0                	test   %eax,%eax
  800736:	0f 84 55 01 00 00    	je     800891 <vprintfmt+0x538>
			putch(ch, putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	53                   	push   %ebx
  800740:	50                   	push   %eax
  800741:	ff d6                	call   *%esi
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	eb dc                	jmp    800724 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	ba 00 00 00 00       	mov    $0x0,%edx
  800752:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800755:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8d 40 04             	lea    0x4(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
  800761:	e9 7c ff ff ff       	jmp    8006e2 <vprintfmt+0x389>
			putch('0', putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	53                   	push   %ebx
  80076a:	6a 30                	push   $0x30
  80076c:	ff d6                	call   *%esi
			putch('x', putdat);
  80076e:	83 c4 08             	add    $0x8,%esp
  800771:	53                   	push   %ebx
  800772:	6a 78                	push   $0x78
  800774:	ff d6                	call   *%esi
			num = (unsigned long long)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	ba 00 00 00 00       	mov    $0x0,%edx
  800780:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800783:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800786:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 40 04             	lea    0x4(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800792:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800797:	e9 56 ff ff ff       	jmp    8006f2 <vprintfmt+0x399>
	if (lflag >= 2)
  80079c:	83 f9 01             	cmp    $0x1,%ecx
  80079f:	7f 27                	jg     8007c8 <vprintfmt+0x46f>
	else if (lflag)
  8007a1:	85 c9                	test   %ecx,%ecx
  8007a3:	74 44                	je     8007e9 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8007af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 40 04             	lea    0x4(%eax),%eax
  8007bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007be:	bf 10 00 00 00       	mov    $0x10,%edi
  8007c3:	e9 2a ff ff ff       	jmp    8006f2 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 08             	lea    0x8(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007df:	bf 10 00 00 00       	mov    $0x10,%edi
  8007e4:	e9 09 ff ff ff       	jmp    8006f2 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 40 04             	lea    0x4(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800802:	bf 10 00 00 00       	mov    $0x10,%edi
  800807:	e9 e6 fe ff ff       	jmp    8006f2 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8d 78 04             	lea    0x4(%eax),%edi
  800812:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800814:	85 c0                	test   %eax,%eax
  800816:	74 2d                	je     800845 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800818:	0f b6 13             	movzbl (%ebx),%edx
  80081b:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80081d:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800820:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800823:	0f 8e f8 fe ff ff    	jle    800721 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800829:	68 58 18 80 00       	push   $0x801858
  80082e:	68 08 17 80 00       	push   $0x801708
  800833:	53                   	push   %ebx
  800834:	56                   	push   %esi
  800835:	e8 02 fb ff ff       	call   80033c <printfmt>
  80083a:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80083d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800840:	e9 dc fe ff ff       	jmp    800721 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800845:	68 20 18 80 00       	push   $0x801820
  80084a:	68 08 17 80 00       	push   $0x801708
  80084f:	53                   	push   %ebx
  800850:	56                   	push   %esi
  800851:	e8 e6 fa ff ff       	call   80033c <printfmt>
  800856:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800859:	89 7d 14             	mov    %edi,0x14(%ebp)
  80085c:	e9 c0 fe ff ff       	jmp    800721 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	53                   	push   %ebx
  800865:	6a 25                	push   $0x25
  800867:	ff d6                	call   *%esi
			break;
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	e9 b0 fe ff ff       	jmp    800721 <vprintfmt+0x3c8>
			putch('%', putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	53                   	push   %ebx
  800875:	6a 25                	push   $0x25
  800877:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800879:	83 c4 10             	add    $0x10,%esp
  80087c:	89 f8                	mov    %edi,%eax
  80087e:	eb 03                	jmp    800883 <vprintfmt+0x52a>
  800880:	83 e8 01             	sub    $0x1,%eax
  800883:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800887:	75 f7                	jne    800880 <vprintfmt+0x527>
  800889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088c:	e9 90 fe ff ff       	jmp    800721 <vprintfmt+0x3c8>
}
  800891:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800894:	5b                   	pop    %ebx
  800895:	5e                   	pop    %esi
  800896:	5f                   	pop    %edi
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 18             	sub    $0x18,%esp
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ac:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	74 26                	je     8008e0 <vsnprintf+0x47>
  8008ba:	85 d2                	test   %edx,%edx
  8008bc:	7e 22                	jle    8008e0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008be:	ff 75 14             	pushl  0x14(%ebp)
  8008c1:	ff 75 10             	pushl  0x10(%ebp)
  8008c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c7:	50                   	push   %eax
  8008c8:	68 1f 03 80 00       	push   $0x80031f
  8008cd:	e8 87 fa ff ff       	call   800359 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008db:	83 c4 10             	add    $0x10,%esp
}
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    
		return -E_INVAL;
  8008e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e5:	eb f7                	jmp    8008de <vsnprintf+0x45>

008008e7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ed:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f0:	50                   	push   %eax
  8008f1:	ff 75 10             	pushl  0x10(%ebp)
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	ff 75 08             	pushl  0x8(%ebp)
  8008fa:	e8 9a ff ff ff       	call   800899 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800907:	b8 00 00 00 00       	mov    $0x0,%eax
  80090c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800910:	74 05                	je     800917 <strlen+0x16>
		n++;
  800912:	83 c0 01             	add    $0x1,%eax
  800915:	eb f5                	jmp    80090c <strlen+0xb>
	return n;
}
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800922:	ba 00 00 00 00       	mov    $0x0,%edx
  800927:	39 c2                	cmp    %eax,%edx
  800929:	74 0d                	je     800938 <strnlen+0x1f>
  80092b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80092f:	74 05                	je     800936 <strnlen+0x1d>
		n++;
  800931:	83 c2 01             	add    $0x1,%edx
  800934:	eb f1                	jmp    800927 <strnlen+0xe>
  800936:	89 d0                	mov    %edx,%eax
	return n;
}
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	53                   	push   %ebx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800944:	ba 00 00 00 00       	mov    $0x0,%edx
  800949:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800950:	83 c2 01             	add    $0x1,%edx
  800953:	84 c9                	test   %cl,%cl
  800955:	75 f2                	jne    800949 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800957:	5b                   	pop    %ebx
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	83 ec 10             	sub    $0x10,%esp
  800961:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800964:	53                   	push   %ebx
  800965:	e8 97 ff ff ff       	call   800901 <strlen>
  80096a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096d:	ff 75 0c             	pushl  0xc(%ebp)
  800970:	01 d8                	add    %ebx,%eax
  800972:	50                   	push   %eax
  800973:	e8 c2 ff ff ff       	call   80093a <strcpy>
	return dst;
}
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	56                   	push   %esi
  800983:	53                   	push   %ebx
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098a:	89 c6                	mov    %eax,%esi
  80098c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098f:	89 c2                	mov    %eax,%edx
  800991:	39 f2                	cmp    %esi,%edx
  800993:	74 11                	je     8009a6 <strncpy+0x27>
		*dst++ = *src;
  800995:	83 c2 01             	add    $0x1,%edx
  800998:	0f b6 19             	movzbl (%ecx),%ebx
  80099b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099e:	80 fb 01             	cmp    $0x1,%bl
  8009a1:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a4:	eb eb                	jmp    800991 <strncpy+0x12>
	}
	return ret;
}
  8009a6:	5b                   	pop    %ebx
  8009a7:	5e                   	pop    %esi
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	56                   	push   %esi
  8009ae:	53                   	push   %ebx
  8009af:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b5:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ba:	85 d2                	test   %edx,%edx
  8009bc:	74 21                	je     8009df <strlcpy+0x35>
  8009be:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 14                	je     8009dc <strlcpy+0x32>
  8009c8:	0f b6 19             	movzbl (%ecx),%ebx
  8009cb:	84 db                	test   %bl,%bl
  8009cd:	74 0b                	je     8009da <strlcpy+0x30>
			*dst++ = *src++;
  8009cf:	83 c1 01             	add    $0x1,%ecx
  8009d2:	83 c2 01             	add    $0x1,%edx
  8009d5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d8:	eb ea                	jmp    8009c4 <strlcpy+0x1a>
  8009da:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009dc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009df:	29 f0                	sub    %esi,%eax
}
  8009e1:	5b                   	pop    %ebx
  8009e2:	5e                   	pop    %esi
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ee:	0f b6 01             	movzbl (%ecx),%eax
  8009f1:	84 c0                	test   %al,%al
  8009f3:	74 0c                	je     800a01 <strcmp+0x1c>
  8009f5:	3a 02                	cmp    (%edx),%al
  8009f7:	75 08                	jne    800a01 <strcmp+0x1c>
		p++, q++;
  8009f9:	83 c1 01             	add    $0x1,%ecx
  8009fc:	83 c2 01             	add    $0x1,%edx
  8009ff:	eb ed                	jmp    8009ee <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a01:	0f b6 c0             	movzbl %al,%eax
  800a04:	0f b6 12             	movzbl (%edx),%edx
  800a07:	29 d0                	sub    %edx,%eax
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	53                   	push   %ebx
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	89 c3                	mov    %eax,%ebx
  800a17:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a1a:	eb 06                	jmp    800a22 <strncmp+0x17>
		n--, p++, q++;
  800a1c:	83 c0 01             	add    $0x1,%eax
  800a1f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a22:	39 d8                	cmp    %ebx,%eax
  800a24:	74 16                	je     800a3c <strncmp+0x31>
  800a26:	0f b6 08             	movzbl (%eax),%ecx
  800a29:	84 c9                	test   %cl,%cl
  800a2b:	74 04                	je     800a31 <strncmp+0x26>
  800a2d:	3a 0a                	cmp    (%edx),%cl
  800a2f:	74 eb                	je     800a1c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a31:	0f b6 00             	movzbl (%eax),%eax
  800a34:	0f b6 12             	movzbl (%edx),%edx
  800a37:	29 d0                	sub    %edx,%eax
}
  800a39:	5b                   	pop    %ebx
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    
		return 0;
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a41:	eb f6                	jmp    800a39 <strncmp+0x2e>

00800a43 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4d:	0f b6 10             	movzbl (%eax),%edx
  800a50:	84 d2                	test   %dl,%dl
  800a52:	74 09                	je     800a5d <strchr+0x1a>
		if (*s == c)
  800a54:	38 ca                	cmp    %cl,%dl
  800a56:	74 0a                	je     800a62 <strchr+0x1f>
	for (; *s; s++)
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	eb f0                	jmp    800a4d <strchr+0xa>
			return (char *) s;
	return 0;
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a71:	38 ca                	cmp    %cl,%dl
  800a73:	74 09                	je     800a7e <strfind+0x1a>
  800a75:	84 d2                	test   %dl,%dl
  800a77:	74 05                	je     800a7e <strfind+0x1a>
	for (; *s; s++)
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	eb f0                	jmp    800a6e <strfind+0xa>
			break;
	return (char *) s;
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	57                   	push   %edi
  800a84:	56                   	push   %esi
  800a85:	53                   	push   %ebx
  800a86:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a89:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8c:	85 c9                	test   %ecx,%ecx
  800a8e:	74 31                	je     800ac1 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a90:	89 f8                	mov    %edi,%eax
  800a92:	09 c8                	or     %ecx,%eax
  800a94:	a8 03                	test   $0x3,%al
  800a96:	75 23                	jne    800abb <memset+0x3b>
		c &= 0xFF;
  800a98:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9c:	89 d3                	mov    %edx,%ebx
  800a9e:	c1 e3 08             	shl    $0x8,%ebx
  800aa1:	89 d0                	mov    %edx,%eax
  800aa3:	c1 e0 18             	shl    $0x18,%eax
  800aa6:	89 d6                	mov    %edx,%esi
  800aa8:	c1 e6 10             	shl    $0x10,%esi
  800aab:	09 f0                	or     %esi,%eax
  800aad:	09 c2                	or     %eax,%edx
  800aaf:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab4:	89 d0                	mov    %edx,%eax
  800ab6:	fc                   	cld    
  800ab7:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab9:	eb 06                	jmp    800ac1 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	fc                   	cld    
  800abf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ac1:	89 f8                	mov    %edi,%eax
  800ac3:	5b                   	pop    %ebx
  800ac4:	5e                   	pop    %esi
  800ac5:	5f                   	pop    %edi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	57                   	push   %edi
  800acc:	56                   	push   %esi
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad6:	39 c6                	cmp    %eax,%esi
  800ad8:	73 32                	jae    800b0c <memmove+0x44>
  800ada:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800add:	39 c2                	cmp    %eax,%edx
  800adf:	76 2b                	jbe    800b0c <memmove+0x44>
		s += n;
		d += n;
  800ae1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae4:	89 fe                	mov    %edi,%esi
  800ae6:	09 ce                	or     %ecx,%esi
  800ae8:	09 d6                	or     %edx,%esi
  800aea:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af0:	75 0e                	jne    800b00 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af2:	83 ef 04             	sub    $0x4,%edi
  800af5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800afb:	fd                   	std    
  800afc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afe:	eb 09                	jmp    800b09 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b00:	83 ef 01             	sub    $0x1,%edi
  800b03:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b06:	fd                   	std    
  800b07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b09:	fc                   	cld    
  800b0a:	eb 1a                	jmp    800b26 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0c:	89 c2                	mov    %eax,%edx
  800b0e:	09 ca                	or     %ecx,%edx
  800b10:	09 f2                	or     %esi,%edx
  800b12:	f6 c2 03             	test   $0x3,%dl
  800b15:	75 0a                	jne    800b21 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1a:	89 c7                	mov    %eax,%edi
  800b1c:	fc                   	cld    
  800b1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1f:	eb 05                	jmp    800b26 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b21:	89 c7                	mov    %eax,%edi
  800b23:	fc                   	cld    
  800b24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b26:	5e                   	pop    %esi
  800b27:	5f                   	pop    %edi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b30:	ff 75 10             	pushl  0x10(%ebp)
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	ff 75 08             	pushl  0x8(%ebp)
  800b39:	e8 8a ff ff ff       	call   800ac8 <memmove>
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	56                   	push   %esi
  800b44:	53                   	push   %ebx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4b:	89 c6                	mov    %eax,%esi
  800b4d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b50:	39 f0                	cmp    %esi,%eax
  800b52:	74 1c                	je     800b70 <memcmp+0x30>
		if (*s1 != *s2)
  800b54:	0f b6 08             	movzbl (%eax),%ecx
  800b57:	0f b6 1a             	movzbl (%edx),%ebx
  800b5a:	38 d9                	cmp    %bl,%cl
  800b5c:	75 08                	jne    800b66 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b5e:	83 c0 01             	add    $0x1,%eax
  800b61:	83 c2 01             	add    $0x1,%edx
  800b64:	eb ea                	jmp    800b50 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b66:	0f b6 c1             	movzbl %cl,%eax
  800b69:	0f b6 db             	movzbl %bl,%ebx
  800b6c:	29 d8                	sub    %ebx,%eax
  800b6e:	eb 05                	jmp    800b75 <memcmp+0x35>
	}

	return 0;
  800b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b87:	39 d0                	cmp    %edx,%eax
  800b89:	73 09                	jae    800b94 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b8b:	38 08                	cmp    %cl,(%eax)
  800b8d:	74 05                	je     800b94 <memfind+0x1b>
	for (; s < ends; s++)
  800b8f:	83 c0 01             	add    $0x1,%eax
  800b92:	eb f3                	jmp    800b87 <memfind+0xe>
			break;
	return (void *) s;
}
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
  800b9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba2:	eb 03                	jmp    800ba7 <strtol+0x11>
		s++;
  800ba4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba7:	0f b6 01             	movzbl (%ecx),%eax
  800baa:	3c 20                	cmp    $0x20,%al
  800bac:	74 f6                	je     800ba4 <strtol+0xe>
  800bae:	3c 09                	cmp    $0x9,%al
  800bb0:	74 f2                	je     800ba4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb2:	3c 2b                	cmp    $0x2b,%al
  800bb4:	74 2a                	je     800be0 <strtol+0x4a>
	int neg = 0;
  800bb6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bbb:	3c 2d                	cmp    $0x2d,%al
  800bbd:	74 2b                	je     800bea <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc5:	75 0f                	jne    800bd6 <strtol+0x40>
  800bc7:	80 39 30             	cmpb   $0x30,(%ecx)
  800bca:	74 28                	je     800bf4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bcc:	85 db                	test   %ebx,%ebx
  800bce:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd3:	0f 44 d8             	cmove  %eax,%ebx
  800bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bde:	eb 50                	jmp    800c30 <strtol+0x9a>
		s++;
  800be0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be3:	bf 00 00 00 00       	mov    $0x0,%edi
  800be8:	eb d5                	jmp    800bbf <strtol+0x29>
		s++, neg = 1;
  800bea:	83 c1 01             	add    $0x1,%ecx
  800bed:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf2:	eb cb                	jmp    800bbf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf8:	74 0e                	je     800c08 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bfa:	85 db                	test   %ebx,%ebx
  800bfc:	75 d8                	jne    800bd6 <strtol+0x40>
		s++, base = 8;
  800bfe:	83 c1 01             	add    $0x1,%ecx
  800c01:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c06:	eb ce                	jmp    800bd6 <strtol+0x40>
		s += 2, base = 16;
  800c08:	83 c1 02             	add    $0x2,%ecx
  800c0b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c10:	eb c4                	jmp    800bd6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c12:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c15:	89 f3                	mov    %esi,%ebx
  800c17:	80 fb 19             	cmp    $0x19,%bl
  800c1a:	77 29                	ja     800c45 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c1c:	0f be d2             	movsbl %dl,%edx
  800c1f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c22:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c25:	7d 30                	jge    800c57 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c27:	83 c1 01             	add    $0x1,%ecx
  800c2a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c30:	0f b6 11             	movzbl (%ecx),%edx
  800c33:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c36:	89 f3                	mov    %esi,%ebx
  800c38:	80 fb 09             	cmp    $0x9,%bl
  800c3b:	77 d5                	ja     800c12 <strtol+0x7c>
			dig = *s - '0';
  800c3d:	0f be d2             	movsbl %dl,%edx
  800c40:	83 ea 30             	sub    $0x30,%edx
  800c43:	eb dd                	jmp    800c22 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c45:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c48:	89 f3                	mov    %esi,%ebx
  800c4a:	80 fb 19             	cmp    $0x19,%bl
  800c4d:	77 08                	ja     800c57 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c4f:	0f be d2             	movsbl %dl,%edx
  800c52:	83 ea 37             	sub    $0x37,%edx
  800c55:	eb cb                	jmp    800c22 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5b:	74 05                	je     800c62 <strtol+0xcc>
		*endptr = (char *) s;
  800c5d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c60:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c62:	89 c2                	mov    %eax,%edx
  800c64:	f7 da                	neg    %edx
  800c66:	85 ff                	test   %edi,%edi
  800c68:	0f 45 c2             	cmovne %edx,%eax
}
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	89 c3                	mov    %eax,%ebx
  800c83:	89 c7                	mov    %eax,%edi
  800c85:	89 c6                	mov    %eax,%esi
  800c87:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c89:	5b                   	pop    %ebx
  800c8a:	5e                   	pop    %esi
  800c8b:	5f                   	pop    %edi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c94:	ba 00 00 00 00       	mov    $0x0,%edx
  800c99:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9e:	89 d1                	mov    %edx,%ecx
  800ca0:	89 d3                	mov    %edx,%ebx
  800ca2:	89 d7                	mov    %edx,%edi
  800ca4:	89 d6                	mov    %edx,%esi
  800ca6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
  800cb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbe:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc3:	89 cb                	mov    %ecx,%ebx
  800cc5:	89 cf                	mov    %ecx,%edi
  800cc7:	89 ce                	mov    %ecx,%esi
  800cc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	7f 08                	jg     800cd7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800cdb:	6a 03                	push   $0x3
  800cdd:	68 60 1a 80 00       	push   $0x801a60
  800ce2:	6a 33                	push   $0x33
  800ce4:	68 7d 1a 80 00       	push   $0x801a7d
  800ce9:	e8 63 f4 ff ff       	call   800151 <_panic>

00800cee <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf9:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfe:	89 d1                	mov    %edx,%ecx
  800d00:	89 d3                	mov    %edx,%ebx
  800d02:	89 d7                	mov    %edx,%edi
  800d04:	89 d6                	mov    %edx,%esi
  800d06:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <sys_yield>:

void
sys_yield(void)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d13:	ba 00 00 00 00       	mov    $0x0,%edx
  800d18:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d1d:	89 d1                	mov    %edx,%ecx
  800d1f:	89 d3                	mov    %edx,%ebx
  800d21:	89 d7                	mov    %edx,%edi
  800d23:	89 d6                	mov    %edx,%esi
  800d25:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
  800d32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d35:	be 00 00 00 00       	mov    $0x0,%esi
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	b8 04 00 00 00       	mov    $0x4,%eax
  800d45:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d48:	89 f7                	mov    %esi,%edi
  800d4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	7f 08                	jg     800d58 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d53:	5b                   	pop    %ebx
  800d54:	5e                   	pop    %esi
  800d55:	5f                   	pop    %edi
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d58:	83 ec 0c             	sub    $0xc,%esp
  800d5b:	50                   	push   %eax
  800d5c:	6a 04                	push   $0x4
  800d5e:	68 60 1a 80 00       	push   $0x801a60
  800d63:	6a 33                	push   $0x33
  800d65:	68 7d 1a 80 00       	push   $0x801a7d
  800d6a:	e8 e2 f3 ff ff       	call   800151 <_panic>

00800d6f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
  800d75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d86:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d89:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	7f 08                	jg     800d9a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 05                	push   $0x5
  800da0:	68 60 1a 80 00       	push   $0x801a60
  800da5:	6a 33                	push   $0x33
  800da7:	68 7d 1a 80 00       	push   $0x801a7d
  800dac:	e8 a0 f3 ff ff       	call   800151 <_panic>

00800db1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc5:	b8 06 00 00 00       	mov    $0x6,%eax
  800dca:	89 df                	mov    %ebx,%edi
  800dcc:	89 de                	mov    %ebx,%esi
  800dce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7f 08                	jg     800ddc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	50                   	push   %eax
  800de0:	6a 06                	push   $0x6
  800de2:	68 60 1a 80 00       	push   $0x801a60
  800de7:	6a 33                	push   $0x33
  800de9:	68 7d 1a 80 00       	push   $0x801a7d
  800dee:	e8 5e f3 ff ff       	call   800151 <_panic>

00800df3 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e09:	89 cb                	mov    %ecx,%ebx
  800e0b:	89 cf                	mov    %ecx,%edi
  800e0d:	89 ce                	mov    %ecx,%esi
  800e0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7f 08                	jg     800e1d <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	50                   	push   %eax
  800e21:	6a 0b                	push   $0xb
  800e23:	68 60 1a 80 00       	push   $0x801a60
  800e28:	6a 33                	push   $0x33
  800e2a:	68 7d 1a 80 00       	push   $0x801a7d
  800e2f:	e8 1d f3 ff ff       	call   800151 <_panic>

00800e34 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e42:	8b 55 08             	mov    0x8(%ebp),%edx
  800e45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e48:	b8 08 00 00 00       	mov    $0x8,%eax
  800e4d:	89 df                	mov    %ebx,%edi
  800e4f:	89 de                	mov    %ebx,%esi
  800e51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	7f 08                	jg     800e5f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	50                   	push   %eax
  800e63:	6a 08                	push   $0x8
  800e65:	68 60 1a 80 00       	push   $0x801a60
  800e6a:	6a 33                	push   $0x33
  800e6c:	68 7d 1a 80 00       	push   $0x801a7d
  800e71:	e8 db f2 ff ff       	call   800151 <_panic>

00800e76 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
  800e7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e8f:	89 df                	mov    %ebx,%edi
  800e91:	89 de                	mov    %ebx,%esi
  800e93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7f 08                	jg     800ea1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	83 ec 0c             	sub    $0xc,%esp
  800ea4:	50                   	push   %eax
  800ea5:	6a 09                	push   $0x9
  800ea7:	68 60 1a 80 00       	push   $0x801a60
  800eac:	6a 33                	push   $0x33
  800eae:	68 7d 1a 80 00       	push   $0x801a7d
  800eb3:	e8 99 f2 ff ff       	call   800151 <_panic>

00800eb8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
  800ebe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed1:	89 df                	mov    %ebx,%edi
  800ed3:	89 de                	mov    %ebx,%esi
  800ed5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	7f 08                	jg     800ee3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee3:	83 ec 0c             	sub    $0xc,%esp
  800ee6:	50                   	push   %eax
  800ee7:	6a 0a                	push   $0xa
  800ee9:	68 60 1a 80 00       	push   $0x801a60
  800eee:	6a 33                	push   $0x33
  800ef0:	68 7d 1a 80 00       	push   $0x801a7d
  800ef5:	e8 57 f2 ff ff       	call   800151 <_panic>

00800efa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	57                   	push   %edi
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f00:	8b 55 08             	mov    0x8(%ebp),%edx
  800f03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f06:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0b:	be 00 00 00 00       	mov    $0x0,%esi
  800f10:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f13:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f16:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
  800f23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f33:	89 cb                	mov    %ecx,%ebx
  800f35:	89 cf                	mov    %ecx,%edi
  800f37:	89 ce                	mov    %ecx,%esi
  800f39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	7f 08                	jg     800f47 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5f                   	pop    %edi
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	50                   	push   %eax
  800f4b:	6a 0e                	push   $0xe
  800f4d:	68 60 1a 80 00       	push   $0x801a60
  800f52:	6a 33                	push   $0x33
  800f54:	68 7d 1a 80 00       	push   $0x801a7d
  800f59:	e8 f3 f1 ff ff       	call   800151 <_panic>

00800f5e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f74:	89 df                	mov    %ebx,%edi
  800f76:	89 de                	mov    %ebx,%esi
  800f78:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	b8 10 00 00 00       	mov    $0x10,%eax
  800f92:	89 cb                	mov    %ecx,%ebx
  800f94:	89 cf                	mov    %ecx,%edi
  800f96:	89 ce                	mov    %ecx,%esi
  800f98:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	53                   	push   %ebx
  800fa3:	83 ec 04             	sub    $0x4,%esp
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fa9:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  800fab:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800faf:	0f 84 90 00 00 00    	je     801045 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  800fb5:	89 d8                	mov    %ebx,%eax
  800fb7:	c1 e8 16             	shr    $0x16,%eax
  800fba:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fc1:	a8 01                	test   $0x1,%al
  800fc3:	0f 84 90 00 00 00    	je     801059 <pgfault+0xba>
  800fc9:	89 d8                	mov    %ebx,%eax
  800fcb:	c1 e8 0c             	shr    $0xc,%eax
  800fce:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd5:	a9 01 08 00 00       	test   $0x801,%eax
  800fda:	74 7d                	je     801059 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	6a 07                	push   $0x7
  800fe1:	68 00 f0 7f 00       	push   $0x7ff000
  800fe6:	6a 00                	push   $0x0
  800fe8:	e8 3f fd ff ff       	call   800d2c <sys_page_alloc>
  800fed:	83 c4 10             	add    $0x10,%esp
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	78 79                	js     80106d <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  800ff4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  800ffa:	83 ec 04             	sub    $0x4,%esp
  800ffd:	68 00 10 00 00       	push   $0x1000
  801002:	53                   	push   %ebx
  801003:	68 00 f0 7f 00       	push   $0x7ff000
  801008:	e8 bb fa ff ff       	call   800ac8 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  80100d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801014:	53                   	push   %ebx
  801015:	6a 00                	push   $0x0
  801017:	68 00 f0 7f 00       	push   $0x7ff000
  80101c:	6a 00                	push   $0x0
  80101e:	e8 4c fd ff ff       	call   800d6f <sys_page_map>
  801023:	83 c4 20             	add    $0x20,%esp
  801026:	85 c0                	test   %eax,%eax
  801028:	78 55                	js     80107f <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  80102a:	83 ec 08             	sub    $0x8,%esp
  80102d:	68 00 f0 7f 00       	push   $0x7ff000
  801032:	6a 00                	push   $0x0
  801034:	e8 78 fd ff ff       	call   800db1 <sys_page_unmap>
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	85 c0                	test   %eax,%eax
  80103e:	78 51                	js     801091 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  801040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801043:	c9                   	leave  
  801044:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	68 8c 1a 80 00       	push   $0x801a8c
  80104d:	6a 21                	push   $0x21
  80104f:	68 14 1b 80 00       	push   $0x801b14
  801054:	e8 f8 f0 ff ff       	call   800151 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  801059:	83 ec 04             	sub    $0x4,%esp
  80105c:	68 b8 1a 80 00       	push   $0x801ab8
  801061:	6a 24                	push   $0x24
  801063:	68 14 1b 80 00       	push   $0x801b14
  801068:	e8 e4 f0 ff ff       	call   800151 <_panic>
		panic("sys_page_alloc: %e\n", r);
  80106d:	50                   	push   %eax
  80106e:	68 1f 1b 80 00       	push   $0x801b1f
  801073:	6a 2e                	push   $0x2e
  801075:	68 14 1b 80 00       	push   $0x801b14
  80107a:	e8 d2 f0 ff ff       	call   800151 <_panic>
		panic("sys_page_map: %e\n", r);
  80107f:	50                   	push   %eax
  801080:	68 33 1b 80 00       	push   $0x801b33
  801085:	6a 34                	push   $0x34
  801087:	68 14 1b 80 00       	push   $0x801b14
  80108c:	e8 c0 f0 ff ff       	call   800151 <_panic>
		panic("sys_page_unmap: %e\n", r);
  801091:	50                   	push   %eax
  801092:	68 45 1b 80 00       	push   $0x801b45
  801097:	6a 37                	push   $0x37
  801099:	68 14 1b 80 00       	push   $0x801b14
  80109e:	e8 ae f0 ff ff       	call   800151 <_panic>

008010a3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
  8010a9:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  8010ac:	68 9f 0f 80 00       	push   $0x800f9f
  8010b1:	e8 09 03 00 00       	call   8013bf <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010b6:	b8 07 00 00 00       	mov    $0x7,%eax
  8010bb:	cd 30                	int    $0x30
  8010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8010c0:	83 c4 10             	add    $0x10,%esp
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	78 30                	js     8010f7 <fork+0x54>
  8010c7:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8010c9:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010d2:	0f 85 a5 00 00 00    	jne    80117d <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010d8:	e8 11 fc ff ff       	call   800cee <sys_getenvid>
  8010dd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010e2:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8010e5:	c1 e0 04             	shl    $0x4,%eax
  8010e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ed:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  8010f2:	e9 75 01 00 00       	jmp    80126c <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  8010f7:	50                   	push   %eax
  8010f8:	68 59 1b 80 00       	push   $0x801b59
  8010fd:	68 83 00 00 00       	push   $0x83
  801102:	68 14 1b 80 00       	push   $0x801b14
  801107:	e8 45 f0 ff ff       	call   800151 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  80110c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801113:	83 ec 0c             	sub    $0xc,%esp
  801116:	25 07 0e 00 00       	and    $0xe07,%eax
  80111b:	50                   	push   %eax
  80111c:	56                   	push   %esi
  80111d:	57                   	push   %edi
  80111e:	56                   	push   %esi
  80111f:	6a 00                	push   $0x0
  801121:	e8 49 fc ff ff       	call   800d6f <sys_page_map>
  801126:	83 c4 20             	add    $0x20,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	79 3e                	jns    80116b <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  80112d:	50                   	push   %eax
  80112e:	68 33 1b 80 00       	push   $0x801b33
  801133:	6a 50                	push   $0x50
  801135:	68 14 1b 80 00       	push   $0x801b14
  80113a:	e8 12 f0 ff ff       	call   800151 <_panic>
			panic("sys_page_map: %e\n", r);
  80113f:	50                   	push   %eax
  801140:	68 33 1b 80 00       	push   $0x801b33
  801145:	6a 54                	push   $0x54
  801147:	68 14 1b 80 00       	push   $0x801b14
  80114c:	e8 00 f0 ff ff       	call   800151 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  801151:	83 ec 0c             	sub    $0xc,%esp
  801154:	6a 05                	push   $0x5
  801156:	56                   	push   %esi
  801157:	57                   	push   %edi
  801158:	56                   	push   %esi
  801159:	6a 00                	push   $0x0
  80115b:	e8 0f fc ff ff       	call   800d6f <sys_page_map>
  801160:	83 c4 20             	add    $0x20,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	0f 88 ab 00 00 00    	js     801216 <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  80116b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801171:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801177:	0f 84 ab 00 00 00    	je     801228 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  80117d:	89 d8                	mov    %ebx,%eax
  80117f:	c1 e8 16             	shr    $0x16,%eax
  801182:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801189:	a8 01                	test   $0x1,%al
  80118b:	74 de                	je     80116b <fork+0xc8>
  80118d:	89 d8                	mov    %ebx,%eax
  80118f:	c1 e8 0c             	shr    $0xc,%eax
  801192:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801199:	f6 c2 01             	test   $0x1,%dl
  80119c:	74 cd                	je     80116b <fork+0xc8>
  80119e:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8011a4:	74 c5                	je     80116b <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  8011a6:	89 c6                	mov    %eax,%esi
  8011a8:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  8011ab:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011b2:	f6 c6 04             	test   $0x4,%dh
  8011b5:	0f 85 51 ff ff ff    	jne    80110c <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  8011bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011c2:	a9 02 08 00 00       	test   $0x802,%eax
  8011c7:	74 88                	je     801151 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8011c9:	83 ec 0c             	sub    $0xc,%esp
  8011cc:	68 05 08 00 00       	push   $0x805
  8011d1:	56                   	push   %esi
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	6a 00                	push   $0x0
  8011d6:	e8 94 fb ff ff       	call   800d6f <sys_page_map>
  8011db:	83 c4 20             	add    $0x20,%esp
  8011de:	85 c0                	test   %eax,%eax
  8011e0:	0f 88 59 ff ff ff    	js     80113f <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8011e6:	83 ec 0c             	sub    $0xc,%esp
  8011e9:	68 05 08 00 00       	push   $0x805
  8011ee:	56                   	push   %esi
  8011ef:	6a 00                	push   $0x0
  8011f1:	56                   	push   %esi
  8011f2:	6a 00                	push   $0x0
  8011f4:	e8 76 fb ff ff       	call   800d6f <sys_page_map>
  8011f9:	83 c4 20             	add    $0x20,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	0f 89 67 ff ff ff    	jns    80116b <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801204:	50                   	push   %eax
  801205:	68 33 1b 80 00       	push   $0x801b33
  80120a:	6a 56                	push   $0x56
  80120c:	68 14 1b 80 00       	push   $0x801b14
  801211:	e8 3b ef ff ff       	call   800151 <_panic>
			panic("sys_page_map: %e\n", r);
  801216:	50                   	push   %eax
  801217:	68 33 1b 80 00       	push   $0x801b33
  80121c:	6a 5a                	push   $0x5a
  80121e:	68 14 1b 80 00       	push   $0x801b14
  801223:	e8 29 ef ff ff       	call   800151 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801228:	83 ec 04             	sub    $0x4,%esp
  80122b:	6a 07                	push   $0x7
  80122d:	68 00 f0 bf ee       	push   $0xeebff000
  801232:	ff 75 e4             	pushl  -0x1c(%ebp)
  801235:	e8 f2 fa ff ff       	call   800d2c <sys_page_alloc>
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	85 c0                	test   %eax,%eax
  80123f:	78 36                	js     801277 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801241:	83 ec 08             	sub    $0x8,%esp
  801244:	68 2a 14 80 00       	push   $0x80142a
  801249:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124c:	e8 67 fc ff ff       	call   800eb8 <sys_env_set_pgfault_upcall>
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	85 c0                	test   %eax,%eax
  801256:	78 34                	js     80128c <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	6a 02                	push   $0x2
  80125d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801260:	e8 cf fb ff ff       	call   800e34 <sys_env_set_status>
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	85 c0                	test   %eax,%eax
  80126a:	78 35                	js     8012a1 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  80126c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80126f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801272:	5b                   	pop    %ebx
  801273:	5e                   	pop    %esi
  801274:	5f                   	pop    %edi
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  801277:	50                   	push   %eax
  801278:	68 1f 1b 80 00       	push   $0x801b1f
  80127d:	68 95 00 00 00       	push   $0x95
  801282:	68 14 1b 80 00       	push   $0x801b14
  801287:	e8 c5 ee ff ff       	call   800151 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  80128c:	50                   	push   %eax
  80128d:	68 f4 1a 80 00       	push   $0x801af4
  801292:	68 98 00 00 00       	push   $0x98
  801297:	68 14 1b 80 00       	push   $0x801b14
  80129c:	e8 b0 ee ff ff       	call   800151 <_panic>
		panic("sys_env_set_status: %e\n", r);
  8012a1:	50                   	push   %eax
  8012a2:	68 69 1b 80 00       	push   $0x801b69
  8012a7:	68 9b 00 00 00       	push   $0x9b
  8012ac:	68 14 1b 80 00       	push   $0x801b14
  8012b1:	e8 9b ee ff ff       	call   800151 <_panic>

008012b6 <sfork>:

// Challenge!
int
sfork(void)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012bc:	68 81 1b 80 00       	push   $0x801b81
  8012c1:	68 a4 00 00 00       	push   $0xa4
  8012c6:	68 14 1b 80 00       	push   $0x801b14
  8012cb:	e8 81 ee ff ff       	call   800151 <_panic>

008012d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
  8012d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  8012de:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8012e0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8012e5:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	50                   	push   %eax
  8012ec:	e8 2c fc ff ff       	call   800f1d <sys_ipc_recv>
	if (from_env_store)
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	85 f6                	test   %esi,%esi
  8012f6:	74 14                	je     80130c <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  8012f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	78 09                	js     80130a <ipc_recv+0x3a>
  801301:	8b 15 04 20 80 00    	mov    0x802004,%edx
  801307:	8b 52 78             	mov    0x78(%edx),%edx
  80130a:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  80130c:	85 db                	test   %ebx,%ebx
  80130e:	74 14                	je     801324 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  801310:	ba 00 00 00 00       	mov    $0x0,%edx
  801315:	85 c0                	test   %eax,%eax
  801317:	78 09                	js     801322 <ipc_recv+0x52>
  801319:	8b 15 04 20 80 00    	mov    0x802004,%edx
  80131f:	8b 52 7c             	mov    0x7c(%edx),%edx
  801322:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  801324:	85 c0                	test   %eax,%eax
  801326:	78 08                	js     801330 <ipc_recv+0x60>
  801328:	a1 04 20 80 00       	mov    0x802004,%eax
  80132d:	8b 40 74             	mov    0x74(%eax),%eax
}
  801330:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801333:	5b                   	pop    %ebx
  801334:	5e                   	pop    %esi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  801340:	85 c0                	test   %eax,%eax
  801342:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801347:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  80134a:	ff 75 14             	pushl  0x14(%ebp)
  80134d:	50                   	push   %eax
  80134e:	ff 75 0c             	pushl  0xc(%ebp)
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 a1 fb ff ff       	call   800efa <sys_ipc_try_send>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 02                	js     801362 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  801360:	c9                   	leave  
  801361:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  801362:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801365:	75 07                	jne    80136e <ipc_send+0x37>
		sys_yield();
  801367:	e8 a1 f9 ff ff       	call   800d0d <sys_yield>
}
  80136c:	eb f2                	jmp    801360 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  80136e:	50                   	push   %eax
  80136f:	68 97 1b 80 00       	push   $0x801b97
  801374:	6a 3c                	push   $0x3c
  801376:	68 ab 1b 80 00       	push   $0x801bab
  80137b:	e8 d1 ed ff ff       	call   800151 <_panic>

00801380 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801386:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  80138b:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80138e:	c1 e0 04             	shl    $0x4,%eax
  801391:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801396:	8b 40 50             	mov    0x50(%eax),%eax
  801399:	39 c8                	cmp    %ecx,%eax
  80139b:	74 12                	je     8013af <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80139d:	83 c2 01             	add    $0x1,%edx
  8013a0:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8013a6:	75 e3                	jne    80138b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8013a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ad:	eb 0e                	jmp    8013bd <ipc_find_env+0x3d>
			return envs[i].env_id;
  8013af:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8013b2:	c1 e0 04             	shl    $0x4,%eax
  8013b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013ba:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013bd:	5d                   	pop    %ebp
  8013be:	c3                   	ret    

008013bf <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8013c5:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8013cc:	74 0a                	je     8013d8 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	6a 07                	push   $0x7
  8013dd:	68 00 f0 bf ee       	push   $0xeebff000
  8013e2:	6a 00                	push   $0x0
  8013e4:	e8 43 f9 ff ff       	call   800d2c <sys_page_alloc>
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 28                	js     801418 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	68 2a 14 80 00       	push   $0x80142a
  8013f8:	6a 00                	push   $0x0
  8013fa:	e8 b9 fa ff ff       	call   800eb8 <sys_env_set_pgfault_upcall>
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	79 c8                	jns    8013ce <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  801406:	50                   	push   %eax
  801407:	68 f4 1a 80 00       	push   $0x801af4
  80140c:	6a 23                	push   $0x23
  80140e:	68 cd 1b 80 00       	push   $0x801bcd
  801413:	e8 39 ed ff ff       	call   800151 <_panic>
			panic("set_pgfault_handler %e\n",r);
  801418:	50                   	push   %eax
  801419:	68 b5 1b 80 00       	push   $0x801bb5
  80141e:	6a 21                	push   $0x21
  801420:	68 cd 1b 80 00       	push   $0x801bcd
  801425:	e8 27 ed ff ff       	call   800151 <_panic>

0080142a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80142a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80142b:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801430:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801432:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  801435:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  801439:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80143d:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801440:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801442:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801446:	83 c4 08             	add    $0x8,%esp
	popal
  801449:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80144a:	83 c4 04             	add    $0x4,%esp
	popfl
  80144d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80144e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80144f:	c3                   	ret    

00801450 <__udivdi3>:
  801450:	55                   	push   %ebp
  801451:	57                   	push   %edi
  801452:	56                   	push   %esi
  801453:	53                   	push   %ebx
  801454:	83 ec 1c             	sub    $0x1c,%esp
  801457:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80145b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80145f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801463:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801467:	85 d2                	test   %edx,%edx
  801469:	75 4d                	jne    8014b8 <__udivdi3+0x68>
  80146b:	39 f3                	cmp    %esi,%ebx
  80146d:	76 19                	jbe    801488 <__udivdi3+0x38>
  80146f:	31 ff                	xor    %edi,%edi
  801471:	89 e8                	mov    %ebp,%eax
  801473:	89 f2                	mov    %esi,%edx
  801475:	f7 f3                	div    %ebx
  801477:	89 fa                	mov    %edi,%edx
  801479:	83 c4 1c             	add    $0x1c,%esp
  80147c:	5b                   	pop    %ebx
  80147d:	5e                   	pop    %esi
  80147e:	5f                   	pop    %edi
  80147f:	5d                   	pop    %ebp
  801480:	c3                   	ret    
  801481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801488:	89 d9                	mov    %ebx,%ecx
  80148a:	85 db                	test   %ebx,%ebx
  80148c:	75 0b                	jne    801499 <__udivdi3+0x49>
  80148e:	b8 01 00 00 00       	mov    $0x1,%eax
  801493:	31 d2                	xor    %edx,%edx
  801495:	f7 f3                	div    %ebx
  801497:	89 c1                	mov    %eax,%ecx
  801499:	31 d2                	xor    %edx,%edx
  80149b:	89 f0                	mov    %esi,%eax
  80149d:	f7 f1                	div    %ecx
  80149f:	89 c6                	mov    %eax,%esi
  8014a1:	89 e8                	mov    %ebp,%eax
  8014a3:	89 f7                	mov    %esi,%edi
  8014a5:	f7 f1                	div    %ecx
  8014a7:	89 fa                	mov    %edi,%edx
  8014a9:	83 c4 1c             	add    $0x1c,%esp
  8014ac:	5b                   	pop    %ebx
  8014ad:	5e                   	pop    %esi
  8014ae:	5f                   	pop    %edi
  8014af:	5d                   	pop    %ebp
  8014b0:	c3                   	ret    
  8014b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014b8:	39 f2                	cmp    %esi,%edx
  8014ba:	77 1c                	ja     8014d8 <__udivdi3+0x88>
  8014bc:	0f bd fa             	bsr    %edx,%edi
  8014bf:	83 f7 1f             	xor    $0x1f,%edi
  8014c2:	75 2c                	jne    8014f0 <__udivdi3+0xa0>
  8014c4:	39 f2                	cmp    %esi,%edx
  8014c6:	72 06                	jb     8014ce <__udivdi3+0x7e>
  8014c8:	31 c0                	xor    %eax,%eax
  8014ca:	39 eb                	cmp    %ebp,%ebx
  8014cc:	77 a9                	ja     801477 <__udivdi3+0x27>
  8014ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8014d3:	eb a2                	jmp    801477 <__udivdi3+0x27>
  8014d5:	8d 76 00             	lea    0x0(%esi),%esi
  8014d8:	31 ff                	xor    %edi,%edi
  8014da:	31 c0                	xor    %eax,%eax
  8014dc:	89 fa                	mov    %edi,%edx
  8014de:	83 c4 1c             	add    $0x1c,%esp
  8014e1:	5b                   	pop    %ebx
  8014e2:	5e                   	pop    %esi
  8014e3:	5f                   	pop    %edi
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    
  8014e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014ed:	8d 76 00             	lea    0x0(%esi),%esi
  8014f0:	89 f9                	mov    %edi,%ecx
  8014f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8014f7:	29 f8                	sub    %edi,%eax
  8014f9:	d3 e2                	shl    %cl,%edx
  8014fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014ff:	89 c1                	mov    %eax,%ecx
  801501:	89 da                	mov    %ebx,%edx
  801503:	d3 ea                	shr    %cl,%edx
  801505:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801509:	09 d1                	or     %edx,%ecx
  80150b:	89 f2                	mov    %esi,%edx
  80150d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801511:	89 f9                	mov    %edi,%ecx
  801513:	d3 e3                	shl    %cl,%ebx
  801515:	89 c1                	mov    %eax,%ecx
  801517:	d3 ea                	shr    %cl,%edx
  801519:	89 f9                	mov    %edi,%ecx
  80151b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80151f:	89 eb                	mov    %ebp,%ebx
  801521:	d3 e6                	shl    %cl,%esi
  801523:	89 c1                	mov    %eax,%ecx
  801525:	d3 eb                	shr    %cl,%ebx
  801527:	09 de                	or     %ebx,%esi
  801529:	89 f0                	mov    %esi,%eax
  80152b:	f7 74 24 08          	divl   0x8(%esp)
  80152f:	89 d6                	mov    %edx,%esi
  801531:	89 c3                	mov    %eax,%ebx
  801533:	f7 64 24 0c          	mull   0xc(%esp)
  801537:	39 d6                	cmp    %edx,%esi
  801539:	72 15                	jb     801550 <__udivdi3+0x100>
  80153b:	89 f9                	mov    %edi,%ecx
  80153d:	d3 e5                	shl    %cl,%ebp
  80153f:	39 c5                	cmp    %eax,%ebp
  801541:	73 04                	jae    801547 <__udivdi3+0xf7>
  801543:	39 d6                	cmp    %edx,%esi
  801545:	74 09                	je     801550 <__udivdi3+0x100>
  801547:	89 d8                	mov    %ebx,%eax
  801549:	31 ff                	xor    %edi,%edi
  80154b:	e9 27 ff ff ff       	jmp    801477 <__udivdi3+0x27>
  801550:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801553:	31 ff                	xor    %edi,%edi
  801555:	e9 1d ff ff ff       	jmp    801477 <__udivdi3+0x27>
  80155a:	66 90                	xchg   %ax,%ax
  80155c:	66 90                	xchg   %ax,%ax
  80155e:	66 90                	xchg   %ax,%ax

00801560 <__umoddi3>:
  801560:	55                   	push   %ebp
  801561:	57                   	push   %edi
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	83 ec 1c             	sub    $0x1c,%esp
  801567:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80156b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80156f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801573:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801577:	89 da                	mov    %ebx,%edx
  801579:	85 c0                	test   %eax,%eax
  80157b:	75 43                	jne    8015c0 <__umoddi3+0x60>
  80157d:	39 df                	cmp    %ebx,%edi
  80157f:	76 17                	jbe    801598 <__umoddi3+0x38>
  801581:	89 f0                	mov    %esi,%eax
  801583:	f7 f7                	div    %edi
  801585:	89 d0                	mov    %edx,%eax
  801587:	31 d2                	xor    %edx,%edx
  801589:	83 c4 1c             	add    $0x1c,%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5f                   	pop    %edi
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    
  801591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801598:	89 fd                	mov    %edi,%ebp
  80159a:	85 ff                	test   %edi,%edi
  80159c:	75 0b                	jne    8015a9 <__umoddi3+0x49>
  80159e:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a3:	31 d2                	xor    %edx,%edx
  8015a5:	f7 f7                	div    %edi
  8015a7:	89 c5                	mov    %eax,%ebp
  8015a9:	89 d8                	mov    %ebx,%eax
  8015ab:	31 d2                	xor    %edx,%edx
  8015ad:	f7 f5                	div    %ebp
  8015af:	89 f0                	mov    %esi,%eax
  8015b1:	f7 f5                	div    %ebp
  8015b3:	89 d0                	mov    %edx,%eax
  8015b5:	eb d0                	jmp    801587 <__umoddi3+0x27>
  8015b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015be:	66 90                	xchg   %ax,%ax
  8015c0:	89 f1                	mov    %esi,%ecx
  8015c2:	39 d8                	cmp    %ebx,%eax
  8015c4:	76 0a                	jbe    8015d0 <__umoddi3+0x70>
  8015c6:	89 f0                	mov    %esi,%eax
  8015c8:	83 c4 1c             	add    $0x1c,%esp
  8015cb:	5b                   	pop    %ebx
  8015cc:	5e                   	pop    %esi
  8015cd:	5f                   	pop    %edi
  8015ce:	5d                   	pop    %ebp
  8015cf:	c3                   	ret    
  8015d0:	0f bd e8             	bsr    %eax,%ebp
  8015d3:	83 f5 1f             	xor    $0x1f,%ebp
  8015d6:	75 20                	jne    8015f8 <__umoddi3+0x98>
  8015d8:	39 d8                	cmp    %ebx,%eax
  8015da:	0f 82 b0 00 00 00    	jb     801690 <__umoddi3+0x130>
  8015e0:	39 f7                	cmp    %esi,%edi
  8015e2:	0f 86 a8 00 00 00    	jbe    801690 <__umoddi3+0x130>
  8015e8:	89 c8                	mov    %ecx,%eax
  8015ea:	83 c4 1c             	add    $0x1c,%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5e                   	pop    %esi
  8015ef:	5f                   	pop    %edi
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    
  8015f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8015f8:	89 e9                	mov    %ebp,%ecx
  8015fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8015ff:	29 ea                	sub    %ebp,%edx
  801601:	d3 e0                	shl    %cl,%eax
  801603:	89 44 24 08          	mov    %eax,0x8(%esp)
  801607:	89 d1                	mov    %edx,%ecx
  801609:	89 f8                	mov    %edi,%eax
  80160b:	d3 e8                	shr    %cl,%eax
  80160d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801611:	89 54 24 04          	mov    %edx,0x4(%esp)
  801615:	8b 54 24 04          	mov    0x4(%esp),%edx
  801619:	09 c1                	or     %eax,%ecx
  80161b:	89 d8                	mov    %ebx,%eax
  80161d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801621:	89 e9                	mov    %ebp,%ecx
  801623:	d3 e7                	shl    %cl,%edi
  801625:	89 d1                	mov    %edx,%ecx
  801627:	d3 e8                	shr    %cl,%eax
  801629:	89 e9                	mov    %ebp,%ecx
  80162b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80162f:	d3 e3                	shl    %cl,%ebx
  801631:	89 c7                	mov    %eax,%edi
  801633:	89 d1                	mov    %edx,%ecx
  801635:	89 f0                	mov    %esi,%eax
  801637:	d3 e8                	shr    %cl,%eax
  801639:	89 e9                	mov    %ebp,%ecx
  80163b:	89 fa                	mov    %edi,%edx
  80163d:	d3 e6                	shl    %cl,%esi
  80163f:	09 d8                	or     %ebx,%eax
  801641:	f7 74 24 08          	divl   0x8(%esp)
  801645:	89 d1                	mov    %edx,%ecx
  801647:	89 f3                	mov    %esi,%ebx
  801649:	f7 64 24 0c          	mull   0xc(%esp)
  80164d:	89 c6                	mov    %eax,%esi
  80164f:	89 d7                	mov    %edx,%edi
  801651:	39 d1                	cmp    %edx,%ecx
  801653:	72 06                	jb     80165b <__umoddi3+0xfb>
  801655:	75 10                	jne    801667 <__umoddi3+0x107>
  801657:	39 c3                	cmp    %eax,%ebx
  801659:	73 0c                	jae    801667 <__umoddi3+0x107>
  80165b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80165f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801663:	89 d7                	mov    %edx,%edi
  801665:	89 c6                	mov    %eax,%esi
  801667:	89 ca                	mov    %ecx,%edx
  801669:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80166e:	29 f3                	sub    %esi,%ebx
  801670:	19 fa                	sbb    %edi,%edx
  801672:	89 d0                	mov    %edx,%eax
  801674:	d3 e0                	shl    %cl,%eax
  801676:	89 e9                	mov    %ebp,%ecx
  801678:	d3 eb                	shr    %cl,%ebx
  80167a:	d3 ea                	shr    %cl,%edx
  80167c:	09 d8                	or     %ebx,%eax
  80167e:	83 c4 1c             	add    $0x1c,%esp
  801681:	5b                   	pop    %ebx
  801682:	5e                   	pop    %esi
  801683:	5f                   	pop    %edi
  801684:	5d                   	pop    %ebp
  801685:	c3                   	ret    
  801686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80168d:	8d 76 00             	lea    0x0(%esi),%esi
  801690:	89 da                	mov    %ebx,%edx
  801692:	29 fe                	sub    %edi,%esi
  801694:	19 c2                	sbb    %eax,%edx
  801696:	89 f1                	mov    %esi,%ecx
  801698:	89 c8                	mov    %ecx,%eax
  80169a:	e9 4b ff ff ff       	jmp    8015ea <__umoddi3+0x8a>
