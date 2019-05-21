
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 63 01 00 00       	call   800194 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 8f 09 00 00       	call   8009d8 <strcpy>
	exit();
  800049:	e8 8f 01 00 00       	call   8001dd <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d0 00 00 00    	jne    800134 <umain+0xe1>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 52 0d 00 00       	call   800dca <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 b9 10 00 00       	call   801141 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 ba 18 00 00       	call   80195b <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 cf 09 00 00       	call   800a83 <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 80 2a 80 00       	mov    $0x802a80,%eax
  8000be:	ba 86 2a 80 00       	mov    $0x802a86,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 b3 2a 80 00       	push   $0x802ab3
  8000cc:	e8 f9 01 00 00       	call   8002ca <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 ce 2a 80 00       	push   $0x802ace
  8000d8:	68 d3 2a 80 00       	push   $0x802ad3
  8000dd:	68 d2 2a 80 00       	push   $0x802ad2
  8000e2:	e8 f7 17 00 00       	call   8018de <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 60 18 00 00       	call   80195b <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 75 09 00 00       	call   800a83 <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 80 2a 80 00       	mov    $0x802a80,%eax
  800118:	ba 86 2a 80 00       	mov    $0x802a86,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 ea 2a 80 00       	push   $0x802aea
  800126:	e8 9f 01 00 00       	call   8002ca <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012b:	cc                   	int3   
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800132:	c9                   	leave  
  800133:	c3                   	ret    
		childofspawn();
  800134:	e8 fa fe ff ff       	call   800033 <childofspawn>
  800139:	e9 26 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  80013e:	50                   	push   %eax
  80013f:	68 8c 2a 80 00       	push   $0x802a8c
  800144:	6a 13                	push   $0x13
  800146:	68 9f 2a 80 00       	push   $0x802a9f
  80014b:	e8 9f 00 00 00       	call   8001ef <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 e0 2f 80 00       	push   $0x802fe0
  800156:	6a 17                	push   $0x17
  800158:	68 9f 2a 80 00       	push   $0x802a9f
  80015d:	e8 8d 00 00 00       	call   8001ef <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 40 80 00    	pushl  0x804004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 63 08 00 00       	call   8009d8 <strcpy>
		exit();
  800175:	e8 63 00 00 00       	call   8001dd <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 e0 2a 80 00       	push   $0x802ae0
  800188:	6a 21                	push   $0x21
  80018a:	68 9f 2a 80 00       	push   $0x802a9f
  80018f:	e8 5b 00 00 00       	call   8001ef <_panic>

00800194 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
  800199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80019f:	e8 e8 0b 00 00       	call   800d8c <sys_getenvid>
  8001a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a9:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8001ac:	c1 e0 04             	shl    $0x4,%eax
  8001af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b4:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b9:	85 db                	test   %ebx,%ebx
  8001bb:	7e 07                	jle    8001c4 <libmain+0x30>
		binaryname = argv[0];
  8001bd:	8b 06                	mov    (%esi),%eax
  8001bf:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	56                   	push   %esi
  8001c8:	53                   	push   %ebx
  8001c9:	e8 85 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001ce:	e8 0a 00 00 00       	call   8001dd <exit>
}
  8001d3:	83 c4 10             	add    $0x10,%esp
  8001d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5d                   	pop    %ebp
  8001dc:	c3                   	ret    

008001dd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8001e3:	6a 00                	push   $0x0
  8001e5:	e8 61 0b 00 00       	call   800d4b <sys_env_destroy>
}
  8001ea:	83 c4 10             	add    $0x10,%esp
  8001ed:	c9                   	leave  
  8001ee:	c3                   	ret    

008001ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	56                   	push   %esi
  8001f3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001f4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f7:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8001fd:	e8 8a 0b 00 00       	call   800d8c <sys_getenvid>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	ff 75 0c             	pushl  0xc(%ebp)
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	56                   	push   %esi
  80020c:	50                   	push   %eax
  80020d:	68 30 2b 80 00       	push   $0x802b30
  800212:	e8 b3 00 00 00       	call   8002ca <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800217:	83 c4 18             	add    $0x18,%esp
  80021a:	53                   	push   %ebx
  80021b:	ff 75 10             	pushl  0x10(%ebp)
  80021e:	e8 56 00 00 00       	call   800279 <vcprintf>
	cprintf("\n");
  800223:	c7 04 24 e2 31 80 00 	movl   $0x8031e2,(%esp)
  80022a:	e8 9b 00 00 00       	call   8002ca <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800232:	cc                   	int3   
  800233:	eb fd                	jmp    800232 <_panic+0x43>

00800235 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	53                   	push   %ebx
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80023f:	8b 13                	mov    (%ebx),%edx
  800241:	8d 42 01             	lea    0x1(%edx),%eax
  800244:	89 03                	mov    %eax,(%ebx)
  800246:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800249:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80024d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800252:	74 09                	je     80025d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800254:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	68 ff 00 00 00       	push   $0xff
  800265:	8d 43 08             	lea    0x8(%ebx),%eax
  800268:	50                   	push   %eax
  800269:	e8 a0 0a 00 00       	call   800d0e <sys_cputs>
		b->idx = 0;
  80026e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	eb db                	jmp    800254 <putch+0x1f>

00800279 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800282:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800289:	00 00 00 
	b.cnt = 0;
  80028c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800293:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a2:	50                   	push   %eax
  8002a3:	68 35 02 80 00       	push   $0x800235
  8002a8:	e8 4a 01 00 00       	call   8003f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ad:	83 c4 08             	add    $0x8,%esp
  8002b0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002b6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002bc:	50                   	push   %eax
  8002bd:	e8 4c 0a 00 00       	call   800d0e <sys_cputs>

	return b.cnt;
}
  8002c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 08             	pushl  0x8(%ebp)
  8002d7:	e8 9d ff ff ff       	call   800279 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 1c             	sub    $0x1c,%esp
  8002e7:	89 c6                	mov    %eax,%esi
  8002e9:	89 d7                	mov    %edx,%edi
  8002eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002fd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800301:	74 2c                	je     80032f <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800303:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800306:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80030d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800313:	39 c2                	cmp    %eax,%edx
  800315:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800318:	73 43                	jae    80035d <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80031a:	83 eb 01             	sub    $0x1,%ebx
  80031d:	85 db                	test   %ebx,%ebx
  80031f:	7e 6c                	jle    80038d <printnum+0xaf>
			putch(padc, putdat);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	57                   	push   %edi
  800325:	ff 75 18             	pushl  0x18(%ebp)
  800328:	ff d6                	call   *%esi
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	eb eb                	jmp    80031a <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	6a 20                	push   $0x20
  800334:	6a 00                	push   $0x0
  800336:	50                   	push   %eax
  800337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033a:	ff 75 e0             	pushl  -0x20(%ebp)
  80033d:	89 fa                	mov    %edi,%edx
  80033f:	89 f0                	mov    %esi,%eax
  800341:	e8 98 ff ff ff       	call   8002de <printnum>
		while (--width > 0)
  800346:	83 c4 20             	add    $0x20,%esp
  800349:	83 eb 01             	sub    $0x1,%ebx
  80034c:	85 db                	test   %ebx,%ebx
  80034e:	7e 65                	jle    8003b5 <printnum+0xd7>
			putch(padc, putdat);
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	57                   	push   %edi
  800354:	6a 20                	push   $0x20
  800356:	ff d6                	call   *%esi
  800358:	83 c4 10             	add    $0x10,%esp
  80035b:	eb ec                	jmp    800349 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80035d:	83 ec 0c             	sub    $0xc,%esp
  800360:	ff 75 18             	pushl  0x18(%ebp)
  800363:	83 eb 01             	sub    $0x1,%ebx
  800366:	53                   	push   %ebx
  800367:	50                   	push   %eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	ff 75 dc             	pushl  -0x24(%ebp)
  80036e:	ff 75 d8             	pushl  -0x28(%ebp)
  800371:	ff 75 e4             	pushl  -0x1c(%ebp)
  800374:	ff 75 e0             	pushl  -0x20(%ebp)
  800377:	e8 a4 24 00 00       	call   802820 <__udivdi3>
  80037c:	83 c4 18             	add    $0x18,%esp
  80037f:	52                   	push   %edx
  800380:	50                   	push   %eax
  800381:	89 fa                	mov    %edi,%edx
  800383:	89 f0                	mov    %esi,%eax
  800385:	e8 54 ff ff ff       	call   8002de <printnum>
  80038a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	57                   	push   %edi
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	ff 75 dc             	pushl  -0x24(%ebp)
  800397:	ff 75 d8             	pushl  -0x28(%ebp)
  80039a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039d:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a0:	e8 8b 25 00 00       	call   802930 <__umoddi3>
  8003a5:	83 c4 14             	add    $0x14,%esp
  8003a8:	0f be 80 53 2b 80 00 	movsbl 0x802b53(%eax),%eax
  8003af:	50                   	push   %eax
  8003b0:	ff d6                	call   *%esi
  8003b2:	83 c4 10             	add    $0x10,%esp
}
  8003b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5f                   	pop    %edi
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c7:	8b 10                	mov    (%eax),%edx
  8003c9:	3b 50 04             	cmp    0x4(%eax),%edx
  8003cc:	73 0a                	jae    8003d8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d1:	89 08                	mov    %ecx,(%eax)
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	88 02                	mov    %al,(%edx)
}
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <printfmt>:
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003e0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e3:	50                   	push   %eax
  8003e4:	ff 75 10             	pushl  0x10(%ebp)
  8003e7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ea:	ff 75 08             	pushl  0x8(%ebp)
  8003ed:	e8 05 00 00 00       	call   8003f7 <vprintfmt>
}
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <vprintfmt>:
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	57                   	push   %edi
  8003fb:	56                   	push   %esi
  8003fc:	53                   	push   %ebx
  8003fd:	83 ec 3c             	sub    $0x3c,%esp
  800400:	8b 75 08             	mov    0x8(%ebp),%esi
  800403:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800406:	8b 7d 10             	mov    0x10(%ebp),%edi
  800409:	e9 b4 03 00 00       	jmp    8007c2 <vprintfmt+0x3cb>
		padc = ' ';
  80040e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800412:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800419:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800420:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800427:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80042e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800433:	8d 47 01             	lea    0x1(%edi),%eax
  800436:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800439:	0f b6 17             	movzbl (%edi),%edx
  80043c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80043f:	3c 55                	cmp    $0x55,%al
  800441:	0f 87 c8 04 00 00    	ja     80090f <vprintfmt+0x518>
  800447:	0f b6 c0             	movzbl %al,%eax
  80044a:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800454:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80045b:	eb d6                	jmp    800433 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800460:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800464:	eb cd                	jmp    800433 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800466:	0f b6 d2             	movzbl %dl,%edx
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80046c:	b8 00 00 00 00       	mov    $0x0,%eax
  800471:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800474:	eb 0c                	jmp    800482 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800476:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800479:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80047d:	eb b4                	jmp    800433 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80047f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800482:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800485:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800489:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80048c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048f:	83 f9 09             	cmp    $0x9,%ecx
  800492:	76 eb                	jbe    80047f <vprintfmt+0x88>
  800494:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800497:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049a:	eb 14                	jmp    8004b0 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80049c:	8b 45 14             	mov    0x14(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 40 04             	lea    0x4(%eax),%eax
  8004aa:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b4:	0f 89 79 ff ff ff    	jns    800433 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8004ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004c7:	e9 67 ff ff ff       	jmp    800433 <vprintfmt+0x3c>
  8004cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	0f 49 d0             	cmovns %eax,%edx
  8004d9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004df:	e9 4f ff ff ff       	jmp    800433 <vprintfmt+0x3c>
  8004e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004e7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004ee:	e9 40 ff ff ff       	jmp    800433 <vprintfmt+0x3c>
			lflag++;
  8004f3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f9:	e9 35 ff ff ff       	jmp    800433 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	8d 78 04             	lea    0x4(%eax),%edi
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	53                   	push   %ebx
  800508:	ff 30                	pushl  (%eax)
  80050a:	ff d6                	call   *%esi
			break;
  80050c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80050f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800512:	e9 a8 02 00 00       	jmp    8007bf <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8d 78 04             	lea    0x4(%eax),%edi
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
  800520:	31 d0                	xor    %edx,%eax
  800522:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800524:	83 f8 0f             	cmp    $0xf,%eax
  800527:	7f 23                	jg     80054c <vprintfmt+0x155>
  800529:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  800530:	85 d2                	test   %edx,%edx
  800532:	74 18                	je     80054c <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800534:	52                   	push   %edx
  800535:	68 43 30 80 00       	push   $0x803043
  80053a:	53                   	push   %ebx
  80053b:	56                   	push   %esi
  80053c:	e8 99 fe ff ff       	call   8003da <printfmt>
  800541:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800544:	89 7d 14             	mov    %edi,0x14(%ebp)
  800547:	e9 73 02 00 00       	jmp    8007bf <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80054c:	50                   	push   %eax
  80054d:	68 6b 2b 80 00       	push   $0x802b6b
  800552:	53                   	push   %ebx
  800553:	56                   	push   %esi
  800554:	e8 81 fe ff ff       	call   8003da <printfmt>
  800559:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80055f:	e9 5b 02 00 00       	jmp    8007bf <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	83 c0 04             	add    $0x4,%eax
  80056a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800572:	85 d2                	test   %edx,%edx
  800574:	b8 64 2b 80 00       	mov    $0x802b64,%eax
  800579:	0f 45 c2             	cmovne %edx,%eax
  80057c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80057f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800583:	7e 06                	jle    80058b <vprintfmt+0x194>
  800585:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800589:	75 0d                	jne    800598 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80058e:	89 c7                	mov    %eax,%edi
  800590:	03 45 e0             	add    -0x20(%ebp),%eax
  800593:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800596:	eb 53                	jmp    8005eb <vprintfmt+0x1f4>
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 d8             	pushl  -0x28(%ebp)
  80059e:	50                   	push   %eax
  80059f:	e8 13 04 00 00       	call   8009b7 <strnlen>
  8005a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a7:	29 c1                	sub    %eax,%ecx
  8005a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005b1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b8:	eb 0f                	jmp    8005c9 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	53                   	push   %ebx
  8005be:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	83 ef 01             	sub    $0x1,%edi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	85 ff                	test   %edi,%edi
  8005cb:	7f ed                	jg     8005ba <vprintfmt+0x1c3>
  8005cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005d0:	85 d2                	test   %edx,%edx
  8005d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d7:	0f 49 c2             	cmovns %edx,%eax
  8005da:	29 c2                	sub    %eax,%edx
  8005dc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005df:	eb aa                	jmp    80058b <vprintfmt+0x194>
					putch(ch, putdat);
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	53                   	push   %ebx
  8005e5:	52                   	push   %edx
  8005e6:	ff d6                	call   *%esi
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ee:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f0:	83 c7 01             	add    $0x1,%edi
  8005f3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005f7:	0f be d0             	movsbl %al,%edx
  8005fa:	85 d2                	test   %edx,%edx
  8005fc:	74 4b                	je     800649 <vprintfmt+0x252>
  8005fe:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800602:	78 06                	js     80060a <vprintfmt+0x213>
  800604:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800608:	78 1e                	js     800628 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80060a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80060e:	74 d1                	je     8005e1 <vprintfmt+0x1ea>
  800610:	0f be c0             	movsbl %al,%eax
  800613:	83 e8 20             	sub    $0x20,%eax
  800616:	83 f8 5e             	cmp    $0x5e,%eax
  800619:	76 c6                	jbe    8005e1 <vprintfmt+0x1ea>
					putch('?', putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	6a 3f                	push   $0x3f
  800621:	ff d6                	call   *%esi
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	eb c3                	jmp    8005eb <vprintfmt+0x1f4>
  800628:	89 cf                	mov    %ecx,%edi
  80062a:	eb 0e                	jmp    80063a <vprintfmt+0x243>
				putch(' ', putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	53                   	push   %ebx
  800630:	6a 20                	push   $0x20
  800632:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800634:	83 ef 01             	sub    $0x1,%edi
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	85 ff                	test   %edi,%edi
  80063c:	7f ee                	jg     80062c <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80063e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800641:	89 45 14             	mov    %eax,0x14(%ebp)
  800644:	e9 76 01 00 00       	jmp    8007bf <vprintfmt+0x3c8>
  800649:	89 cf                	mov    %ecx,%edi
  80064b:	eb ed                	jmp    80063a <vprintfmt+0x243>
	if (lflag >= 2)
  80064d:	83 f9 01             	cmp    $0x1,%ecx
  800650:	7f 1f                	jg     800671 <vprintfmt+0x27a>
	else if (lflag)
  800652:	85 c9                	test   %ecx,%ecx
  800654:	74 6a                	je     8006c0 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065e:	89 c1                	mov    %eax,%ecx
  800660:	c1 f9 1f             	sar    $0x1f,%ecx
  800663:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8d 40 04             	lea    0x4(%eax),%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
  80066f:	eb 17                	jmp    800688 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 50 04             	mov    0x4(%eax),%edx
  800677:	8b 00                	mov    (%eax),%eax
  800679:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 08             	lea    0x8(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800688:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80068b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800690:	85 d2                	test   %edx,%edx
  800692:	0f 89 f8 00 00 00    	jns    800790 <vprintfmt+0x399>
				putch('-', putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	6a 2d                	push   $0x2d
  80069e:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006a6:	f7 d8                	neg    %eax
  8006a8:	83 d2 00             	adc    $0x0,%edx
  8006ab:	f7 da                	neg    %edx
  8006ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006bb:	e9 e1 00 00 00       	jmp    8007a1 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c8:	99                   	cltd   
  8006c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8d 40 04             	lea    0x4(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d5:	eb b1                	jmp    800688 <vprintfmt+0x291>
	if (lflag >= 2)
  8006d7:	83 f9 01             	cmp    $0x1,%ecx
  8006da:	7f 27                	jg     800703 <vprintfmt+0x30c>
	else if (lflag)
  8006dc:	85 c9                	test   %ecx,%ecx
  8006de:	74 41                	je     800721 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 40 04             	lea    0x4(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006fe:	e9 8d 00 00 00       	jmp    800790 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8b 50 04             	mov    0x4(%eax),%edx
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8d 40 08             	lea    0x8(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80071f:	eb 6f                	jmp    800790 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
  80072b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8d 40 04             	lea    0x4(%eax),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80073f:	eb 4f                	jmp    800790 <vprintfmt+0x399>
	if (lflag >= 2)
  800741:	83 f9 01             	cmp    $0x1,%ecx
  800744:	7f 23                	jg     800769 <vprintfmt+0x372>
	else if (lflag)
  800746:	85 c9                	test   %ecx,%ecx
  800748:	0f 84 98 00 00 00    	je     8007e6 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
  800758:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
  800767:	eb 17                	jmp    800780 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 50 04             	mov    0x4(%eax),%edx
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800774:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8d 40 08             	lea    0x8(%eax),%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	6a 30                	push   $0x30
  800786:	ff d6                	call   *%esi
			goto number;
  800788:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80078b:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800790:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800794:	74 0b                	je     8007a1 <vprintfmt+0x3aa>
				putch('+', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	6a 2b                	push   $0x2b
  80079c:	ff d6                	call   *%esi
  80079e:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8007a1:	83 ec 0c             	sub    $0xc,%esp
  8007a4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007a8:	50                   	push   %eax
  8007a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ac:	57                   	push   %edi
  8007ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8007b3:	89 da                	mov    %ebx,%edx
  8007b5:	89 f0                	mov    %esi,%eax
  8007b7:	e8 22 fb ff ff       	call   8002de <printnum>
			break;
  8007bc:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c2:	83 c7 01             	add    $0x1,%edi
  8007c5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007c9:	83 f8 25             	cmp    $0x25,%eax
  8007cc:	0f 84 3c fc ff ff    	je     80040e <vprintfmt+0x17>
			if (ch == '\0')
  8007d2:	85 c0                	test   %eax,%eax
  8007d4:	0f 84 55 01 00 00    	je     80092f <vprintfmt+0x538>
			putch(ch, putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	53                   	push   %ebx
  8007de:	50                   	push   %eax
  8007df:	ff d6                	call   *%esi
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	eb dc                	jmp    8007c2 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8d 40 04             	lea    0x4(%eax),%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ff:	e9 7c ff ff ff       	jmp    800780 <vprintfmt+0x389>
			putch('0', putdat);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	53                   	push   %ebx
  800808:	6a 30                	push   $0x30
  80080a:	ff d6                	call   *%esi
			putch('x', putdat);
  80080c:	83 c4 08             	add    $0x8,%esp
  80080f:	53                   	push   %ebx
  800810:	6a 78                	push   $0x78
  800812:	ff d6                	call   *%esi
			num = (unsigned long long)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800821:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800824:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8d 40 04             	lea    0x4(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800830:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800835:	e9 56 ff ff ff       	jmp    800790 <vprintfmt+0x399>
	if (lflag >= 2)
  80083a:	83 f9 01             	cmp    $0x1,%ecx
  80083d:	7f 27                	jg     800866 <vprintfmt+0x46f>
	else if (lflag)
  80083f:	85 c9                	test   %ecx,%ecx
  800841:	74 44                	je     800887 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	ba 00 00 00 00       	mov    $0x0,%edx
  80084d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800850:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8d 40 04             	lea    0x4(%eax),%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085c:	bf 10 00 00 00       	mov    $0x10,%edi
  800861:	e9 2a ff ff ff       	jmp    800790 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 50 04             	mov    0x4(%eax),%edx
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800871:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 40 08             	lea    0x8(%eax),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087d:	bf 10 00 00 00       	mov    $0x10,%edi
  800882:	e9 09 ff ff ff       	jmp    800790 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	ba 00 00 00 00       	mov    $0x0,%edx
  800891:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800894:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 40 04             	lea    0x4(%eax),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a0:	bf 10 00 00 00       	mov    $0x10,%edi
  8008a5:	e9 e6 fe ff ff       	jmp    800790 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 78 04             	lea    0x4(%eax),%edi
  8008b0:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8008b2:	85 c0                	test   %eax,%eax
  8008b4:	74 2d                	je     8008e3 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8008b6:	0f b6 13             	movzbl (%ebx),%edx
  8008b9:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008bb:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8008be:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8008c1:	0f 8e f8 fe ff ff    	jle    8007bf <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8008c7:	68 c0 2c 80 00       	push   $0x802cc0
  8008cc:	68 43 30 80 00       	push   $0x803043
  8008d1:	53                   	push   %ebx
  8008d2:	56                   	push   %esi
  8008d3:	e8 02 fb ff ff       	call   8003da <printfmt>
  8008d8:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008db:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008de:	e9 dc fe ff ff       	jmp    8007bf <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8008e3:	68 88 2c 80 00       	push   $0x802c88
  8008e8:	68 43 30 80 00       	push   $0x803043
  8008ed:	53                   	push   %ebx
  8008ee:	56                   	push   %esi
  8008ef:	e8 e6 fa ff ff       	call   8003da <printfmt>
  8008f4:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008f7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008fa:	e9 c0 fe ff ff       	jmp    8007bf <vprintfmt+0x3c8>
			putch(ch, putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	53                   	push   %ebx
  800903:	6a 25                	push   $0x25
  800905:	ff d6                	call   *%esi
			break;
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	e9 b0 fe ff ff       	jmp    8007bf <vprintfmt+0x3c8>
			putch('%', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	53                   	push   %ebx
  800913:	6a 25                	push   $0x25
  800915:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	89 f8                	mov    %edi,%eax
  80091c:	eb 03                	jmp    800921 <vprintfmt+0x52a>
  80091e:	83 e8 01             	sub    $0x1,%eax
  800921:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800925:	75 f7                	jne    80091e <vprintfmt+0x527>
  800927:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092a:	e9 90 fe ff ff       	jmp    8007bf <vprintfmt+0x3c8>
}
  80092f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800932:	5b                   	pop    %ebx
  800933:	5e                   	pop    %esi
  800934:	5f                   	pop    %edi
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 18             	sub    $0x18,%esp
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800943:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800946:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80094a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80094d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800954:	85 c0                	test   %eax,%eax
  800956:	74 26                	je     80097e <vsnprintf+0x47>
  800958:	85 d2                	test   %edx,%edx
  80095a:	7e 22                	jle    80097e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80095c:	ff 75 14             	pushl  0x14(%ebp)
  80095f:	ff 75 10             	pushl  0x10(%ebp)
  800962:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800965:	50                   	push   %eax
  800966:	68 bd 03 80 00       	push   $0x8003bd
  80096b:	e8 87 fa ff ff       	call   8003f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800973:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800979:	83 c4 10             	add    $0x10,%esp
}
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    
		return -E_INVAL;
  80097e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800983:	eb f7                	jmp    80097c <vsnprintf+0x45>

00800985 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80098b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80098e:	50                   	push   %eax
  80098f:	ff 75 10             	pushl  0x10(%ebp)
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	ff 75 08             	pushl  0x8(%ebp)
  800998:	e8 9a ff ff ff       	call   800937 <vsnprintf>
	va_end(ap);

	return rc;
}
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    

0080099f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009aa:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ae:	74 05                	je     8009b5 <strlen+0x16>
		n++;
  8009b0:	83 c0 01             	add    $0x1,%eax
  8009b3:	eb f5                	jmp    8009aa <strlen+0xb>
	return n;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	39 c2                	cmp    %eax,%edx
  8009c7:	74 0d                	je     8009d6 <strnlen+0x1f>
  8009c9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009cd:	74 05                	je     8009d4 <strnlen+0x1d>
		n++;
  8009cf:	83 c2 01             	add    $0x1,%edx
  8009d2:	eb f1                	jmp    8009c5 <strnlen+0xe>
  8009d4:	89 d0                	mov    %edx,%eax
	return n;
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	53                   	push   %ebx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009eb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009ee:	83 c2 01             	add    $0x1,%edx
  8009f1:	84 c9                	test   %cl,%cl
  8009f3:	75 f2                	jne    8009e7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009f5:	5b                   	pop    %ebx
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	53                   	push   %ebx
  8009fc:	83 ec 10             	sub    $0x10,%esp
  8009ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a02:	53                   	push   %ebx
  800a03:	e8 97 ff ff ff       	call   80099f <strlen>
  800a08:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	01 d8                	add    %ebx,%eax
  800a10:	50                   	push   %eax
  800a11:	e8 c2 ff ff ff       	call   8009d8 <strcpy>
	return dst;
}
  800a16:	89 d8                	mov    %ebx,%eax
  800a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a1b:	c9                   	leave  
  800a1c:	c3                   	ret    

00800a1d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	56                   	push   %esi
  800a21:	53                   	push   %ebx
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a28:	89 c6                	mov    %eax,%esi
  800a2a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a2d:	89 c2                	mov    %eax,%edx
  800a2f:	39 f2                	cmp    %esi,%edx
  800a31:	74 11                	je     800a44 <strncpy+0x27>
		*dst++ = *src;
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	0f b6 19             	movzbl (%ecx),%ebx
  800a39:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a3c:	80 fb 01             	cmp    $0x1,%bl
  800a3f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a42:	eb eb                	jmp    800a2f <strncpy+0x12>
	}
	return ret;
}
  800a44:	5b                   	pop    %ebx
  800a45:	5e                   	pop    %esi
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a53:	8b 55 10             	mov    0x10(%ebp),%edx
  800a56:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a58:	85 d2                	test   %edx,%edx
  800a5a:	74 21                	je     800a7d <strlcpy+0x35>
  800a5c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a60:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	74 14                	je     800a7a <strlcpy+0x32>
  800a66:	0f b6 19             	movzbl (%ecx),%ebx
  800a69:	84 db                	test   %bl,%bl
  800a6b:	74 0b                	je     800a78 <strlcpy+0x30>
			*dst++ = *src++;
  800a6d:	83 c1 01             	add    $0x1,%ecx
  800a70:	83 c2 01             	add    $0x1,%edx
  800a73:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a76:	eb ea                	jmp    800a62 <strlcpy+0x1a>
  800a78:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a7a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a7d:	29 f0                	sub    %esi,%eax
}
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a8c:	0f b6 01             	movzbl (%ecx),%eax
  800a8f:	84 c0                	test   %al,%al
  800a91:	74 0c                	je     800a9f <strcmp+0x1c>
  800a93:	3a 02                	cmp    (%edx),%al
  800a95:	75 08                	jne    800a9f <strcmp+0x1c>
		p++, q++;
  800a97:	83 c1 01             	add    $0x1,%ecx
  800a9a:	83 c2 01             	add    $0x1,%edx
  800a9d:	eb ed                	jmp    800a8c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9f:	0f b6 c0             	movzbl %al,%eax
  800aa2:	0f b6 12             	movzbl (%edx),%edx
  800aa5:	29 d0                	sub    %edx,%eax
}
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	89 c3                	mov    %eax,%ebx
  800ab5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ab8:	eb 06                	jmp    800ac0 <strncmp+0x17>
		n--, p++, q++;
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac0:	39 d8                	cmp    %ebx,%eax
  800ac2:	74 16                	je     800ada <strncmp+0x31>
  800ac4:	0f b6 08             	movzbl (%eax),%ecx
  800ac7:	84 c9                	test   %cl,%cl
  800ac9:	74 04                	je     800acf <strncmp+0x26>
  800acb:	3a 0a                	cmp    (%edx),%cl
  800acd:	74 eb                	je     800aba <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800acf:	0f b6 00             	movzbl (%eax),%eax
  800ad2:	0f b6 12             	movzbl (%edx),%edx
  800ad5:	29 d0                	sub    %edx,%eax
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    
		return 0;
  800ada:	b8 00 00 00 00       	mov    $0x0,%eax
  800adf:	eb f6                	jmp    800ad7 <strncmp+0x2e>

00800ae1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aeb:	0f b6 10             	movzbl (%eax),%edx
  800aee:	84 d2                	test   %dl,%dl
  800af0:	74 09                	je     800afb <strchr+0x1a>
		if (*s == c)
  800af2:	38 ca                	cmp    %cl,%dl
  800af4:	74 0a                	je     800b00 <strchr+0x1f>
	for (; *s; s++)
  800af6:	83 c0 01             	add    $0x1,%eax
  800af9:	eb f0                	jmp    800aeb <strchr+0xa>
			return (char *) s;
	return 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b0c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b0f:	38 ca                	cmp    %cl,%dl
  800b11:	74 09                	je     800b1c <strfind+0x1a>
  800b13:	84 d2                	test   %dl,%dl
  800b15:	74 05                	je     800b1c <strfind+0x1a>
	for (; *s; s++)
  800b17:	83 c0 01             	add    $0x1,%eax
  800b1a:	eb f0                	jmp    800b0c <strfind+0xa>
			break;
	return (char *) s;
}
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	57                   	push   %edi
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b2a:	85 c9                	test   %ecx,%ecx
  800b2c:	74 31                	je     800b5f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b2e:	89 f8                	mov    %edi,%eax
  800b30:	09 c8                	or     %ecx,%eax
  800b32:	a8 03                	test   $0x3,%al
  800b34:	75 23                	jne    800b59 <memset+0x3b>
		c &= 0xFF;
  800b36:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b3a:	89 d3                	mov    %edx,%ebx
  800b3c:	c1 e3 08             	shl    $0x8,%ebx
  800b3f:	89 d0                	mov    %edx,%eax
  800b41:	c1 e0 18             	shl    $0x18,%eax
  800b44:	89 d6                	mov    %edx,%esi
  800b46:	c1 e6 10             	shl    $0x10,%esi
  800b49:	09 f0                	or     %esi,%eax
  800b4b:	09 c2                	or     %eax,%edx
  800b4d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b4f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b52:	89 d0                	mov    %edx,%eax
  800b54:	fc                   	cld    
  800b55:	f3 ab                	rep stos %eax,%es:(%edi)
  800b57:	eb 06                	jmp    800b5f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	fc                   	cld    
  800b5d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b5f:	89 f8                	mov    %edi,%eax
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b71:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b74:	39 c6                	cmp    %eax,%esi
  800b76:	73 32                	jae    800baa <memmove+0x44>
  800b78:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b7b:	39 c2                	cmp    %eax,%edx
  800b7d:	76 2b                	jbe    800baa <memmove+0x44>
		s += n;
		d += n;
  800b7f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b82:	89 fe                	mov    %edi,%esi
  800b84:	09 ce                	or     %ecx,%esi
  800b86:	09 d6                	or     %edx,%esi
  800b88:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b8e:	75 0e                	jne    800b9e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b90:	83 ef 04             	sub    $0x4,%edi
  800b93:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b96:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b99:	fd                   	std    
  800b9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9c:	eb 09                	jmp    800ba7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b9e:	83 ef 01             	sub    $0x1,%edi
  800ba1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba4:	fd                   	std    
  800ba5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ba7:	fc                   	cld    
  800ba8:	eb 1a                	jmp    800bc4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baa:	89 c2                	mov    %eax,%edx
  800bac:	09 ca                	or     %ecx,%edx
  800bae:	09 f2                	or     %esi,%edx
  800bb0:	f6 c2 03             	test   $0x3,%dl
  800bb3:	75 0a                	jne    800bbf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bb5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bb8:	89 c7                	mov    %eax,%edi
  800bba:	fc                   	cld    
  800bbb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bbd:	eb 05                	jmp    800bc4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bbf:	89 c7                	mov    %eax,%edi
  800bc1:	fc                   	cld    
  800bc2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bce:	ff 75 10             	pushl  0x10(%ebp)
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 8a ff ff ff       	call   800b66 <memmove>
}
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    

00800bde <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be9:	89 c6                	mov    %eax,%esi
  800beb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bee:	39 f0                	cmp    %esi,%eax
  800bf0:	74 1c                	je     800c0e <memcmp+0x30>
		if (*s1 != *s2)
  800bf2:	0f b6 08             	movzbl (%eax),%ecx
  800bf5:	0f b6 1a             	movzbl (%edx),%ebx
  800bf8:	38 d9                	cmp    %bl,%cl
  800bfa:	75 08                	jne    800c04 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	83 c2 01             	add    $0x1,%edx
  800c02:	eb ea                	jmp    800bee <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c04:	0f b6 c1             	movzbl %cl,%eax
  800c07:	0f b6 db             	movzbl %bl,%ebx
  800c0a:	29 d8                	sub    %ebx,%eax
  800c0c:	eb 05                	jmp    800c13 <memcmp+0x35>
	}

	return 0;
  800c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c13:	5b                   	pop    %ebx
  800c14:	5e                   	pop    %esi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c20:	89 c2                	mov    %eax,%edx
  800c22:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c25:	39 d0                	cmp    %edx,%eax
  800c27:	73 09                	jae    800c32 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c29:	38 08                	cmp    %cl,(%eax)
  800c2b:	74 05                	je     800c32 <memfind+0x1b>
	for (; s < ends; s++)
  800c2d:	83 c0 01             	add    $0x1,%eax
  800c30:	eb f3                	jmp    800c25 <memfind+0xe>
			break;
	return (void *) s;
}
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
  800c3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c40:	eb 03                	jmp    800c45 <strtol+0x11>
		s++;
  800c42:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c45:	0f b6 01             	movzbl (%ecx),%eax
  800c48:	3c 20                	cmp    $0x20,%al
  800c4a:	74 f6                	je     800c42 <strtol+0xe>
  800c4c:	3c 09                	cmp    $0x9,%al
  800c4e:	74 f2                	je     800c42 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c50:	3c 2b                	cmp    $0x2b,%al
  800c52:	74 2a                	je     800c7e <strtol+0x4a>
	int neg = 0;
  800c54:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c59:	3c 2d                	cmp    $0x2d,%al
  800c5b:	74 2b                	je     800c88 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c63:	75 0f                	jne    800c74 <strtol+0x40>
  800c65:	80 39 30             	cmpb   $0x30,(%ecx)
  800c68:	74 28                	je     800c92 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c6a:	85 db                	test   %ebx,%ebx
  800c6c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c71:	0f 44 d8             	cmove  %eax,%ebx
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c7c:	eb 50                	jmp    800cce <strtol+0x9a>
		s++;
  800c7e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c81:	bf 00 00 00 00       	mov    $0x0,%edi
  800c86:	eb d5                	jmp    800c5d <strtol+0x29>
		s++, neg = 1;
  800c88:	83 c1 01             	add    $0x1,%ecx
  800c8b:	bf 01 00 00 00       	mov    $0x1,%edi
  800c90:	eb cb                	jmp    800c5d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c92:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c96:	74 0e                	je     800ca6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c98:	85 db                	test   %ebx,%ebx
  800c9a:	75 d8                	jne    800c74 <strtol+0x40>
		s++, base = 8;
  800c9c:	83 c1 01             	add    $0x1,%ecx
  800c9f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca4:	eb ce                	jmp    800c74 <strtol+0x40>
		s += 2, base = 16;
  800ca6:	83 c1 02             	add    $0x2,%ecx
  800ca9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cae:	eb c4                	jmp    800c74 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cb3:	89 f3                	mov    %esi,%ebx
  800cb5:	80 fb 19             	cmp    $0x19,%bl
  800cb8:	77 29                	ja     800ce3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cba:	0f be d2             	movsbl %dl,%edx
  800cbd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cc3:	7d 30                	jge    800cf5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cc5:	83 c1 01             	add    $0x1,%ecx
  800cc8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ccc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cce:	0f b6 11             	movzbl (%ecx),%edx
  800cd1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd4:	89 f3                	mov    %esi,%ebx
  800cd6:	80 fb 09             	cmp    $0x9,%bl
  800cd9:	77 d5                	ja     800cb0 <strtol+0x7c>
			dig = *s - '0';
  800cdb:	0f be d2             	movsbl %dl,%edx
  800cde:	83 ea 30             	sub    $0x30,%edx
  800ce1:	eb dd                	jmp    800cc0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ce3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ce6:	89 f3                	mov    %esi,%ebx
  800ce8:	80 fb 19             	cmp    $0x19,%bl
  800ceb:	77 08                	ja     800cf5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ced:	0f be d2             	movsbl %dl,%edx
  800cf0:	83 ea 37             	sub    $0x37,%edx
  800cf3:	eb cb                	jmp    800cc0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf9:	74 05                	je     800d00 <strtol+0xcc>
		*endptr = (char *) s;
  800cfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cfe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d00:	89 c2                	mov    %eax,%edx
  800d02:	f7 da                	neg    %edx
  800d04:	85 ff                	test   %edi,%edi
  800d06:	0f 45 c2             	cmovne %edx,%eax
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1f:	89 c3                	mov    %eax,%ebx
  800d21:	89 c7                	mov    %eax,%edi
  800d23:	89 c6                	mov    %eax,%esi
  800d25:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_cgetc>:

int
sys_cgetc(void)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d32:	ba 00 00 00 00       	mov    $0x0,%edx
  800d37:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3c:	89 d1                	mov    %edx,%ecx
  800d3e:	89 d3                	mov    %edx,%ebx
  800d40:	89 d7                	mov    %edx,%edi
  800d42:	89 d6                	mov    %edx,%esi
  800d44:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
  800d51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d61:	89 cb                	mov    %ecx,%ebx
  800d63:	89 cf                	mov    %ecx,%edi
  800d65:	89 ce                	mov    %ecx,%esi
  800d67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7f 08                	jg     800d75 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d75:	83 ec 0c             	sub    $0xc,%esp
  800d78:	50                   	push   %eax
  800d79:	6a 03                	push   $0x3
  800d7b:	68 e0 2e 80 00       	push   $0x802ee0
  800d80:	6a 33                	push   $0x33
  800d82:	68 fd 2e 80 00       	push   $0x802efd
  800d87:	e8 63 f4 ff ff       	call   8001ef <_panic>

00800d8c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d92:	ba 00 00 00 00       	mov    $0x0,%edx
  800d97:	b8 02 00 00 00       	mov    $0x2,%eax
  800d9c:	89 d1                	mov    %edx,%ecx
  800d9e:	89 d3                	mov    %edx,%ebx
  800da0:	89 d7                	mov    %edx,%edi
  800da2:	89 d6                	mov    %edx,%esi
  800da4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <sys_yield>:

void
sys_yield(void)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db1:	ba 00 00 00 00       	mov    $0x0,%edx
  800db6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dbb:	89 d1                	mov    %edx,%ecx
  800dbd:	89 d3                	mov    %edx,%ebx
  800dbf:	89 d7                	mov    %edx,%edi
  800dc1:	89 d6                	mov    %edx,%esi
  800dc3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
  800dd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd3:	be 00 00 00 00       	mov    $0x0,%esi
  800dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	b8 04 00 00 00       	mov    $0x4,%eax
  800de3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de6:	89 f7                	mov    %esi,%edi
  800de8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dea:	85 c0                	test   %eax,%eax
  800dec:	7f 08                	jg     800df6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	50                   	push   %eax
  800dfa:	6a 04                	push   $0x4
  800dfc:	68 e0 2e 80 00       	push   $0x802ee0
  800e01:	6a 33                	push   $0x33
  800e03:	68 fd 2e 80 00       	push   $0x802efd
  800e08:	e8 e2 f3 ff ff       	call   8001ef <_panic>

00800e0d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	b8 05 00 00 00       	mov    $0x5,%eax
  800e21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e24:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e27:	8b 75 18             	mov    0x18(%ebp),%esi
  800e2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7f 08                	jg     800e38 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	50                   	push   %eax
  800e3c:	6a 05                	push   $0x5
  800e3e:	68 e0 2e 80 00       	push   $0x802ee0
  800e43:	6a 33                	push   $0x33
  800e45:	68 fd 2e 80 00       	push   $0x802efd
  800e4a:	e8 a0 f3 ff ff       	call   8001ef <_panic>

00800e4f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	b8 06 00 00 00       	mov    $0x6,%eax
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	89 de                	mov    %ebx,%esi
  800e6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7f 08                	jg     800e7a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	50                   	push   %eax
  800e7e:	6a 06                	push   $0x6
  800e80:	68 e0 2e 80 00       	push   $0x802ee0
  800e85:	6a 33                	push   $0x33
  800e87:	68 fd 2e 80 00       	push   $0x802efd
  800e8c:	e8 5e f3 ff ff       	call   8001ef <_panic>

00800e91 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ea7:	89 cb                	mov    %ecx,%ebx
  800ea9:	89 cf                	mov    %ecx,%edi
  800eab:	89 ce                	mov    %ecx,%esi
  800ead:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	7f 08                	jg     800ebb <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebb:	83 ec 0c             	sub    $0xc,%esp
  800ebe:	50                   	push   %eax
  800ebf:	6a 0b                	push   $0xb
  800ec1:	68 e0 2e 80 00       	push   $0x802ee0
  800ec6:	6a 33                	push   $0x33
  800ec8:	68 fd 2e 80 00       	push   $0x802efd
  800ecd:	e8 1d f3 ff ff       	call   8001ef <_panic>

00800ed2 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	b8 08 00 00 00       	mov    $0x8,%eax
  800eeb:	89 df                	mov    %ebx,%edi
  800eed:	89 de                	mov    %ebx,%esi
  800eef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	7f 08                	jg     800efd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	83 ec 0c             	sub    $0xc,%esp
  800f00:	50                   	push   %eax
  800f01:	6a 08                	push   $0x8
  800f03:	68 e0 2e 80 00       	push   $0x802ee0
  800f08:	6a 33                	push   $0x33
  800f0a:	68 fd 2e 80 00       	push   $0x802efd
  800f0f:	e8 db f2 ff ff       	call   8001ef <_panic>

00800f14 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	57                   	push   %edi
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
  800f1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f22:	8b 55 08             	mov    0x8(%ebp),%edx
  800f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f28:	b8 09 00 00 00       	mov    $0x9,%eax
  800f2d:	89 df                	mov    %ebx,%edi
  800f2f:	89 de                	mov    %ebx,%esi
  800f31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f33:	85 c0                	test   %eax,%eax
  800f35:	7f 08                	jg     800f3f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5f                   	pop    %edi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	50                   	push   %eax
  800f43:	6a 09                	push   $0x9
  800f45:	68 e0 2e 80 00       	push   $0x802ee0
  800f4a:	6a 33                	push   $0x33
  800f4c:	68 fd 2e 80 00       	push   $0x802efd
  800f51:	e8 99 f2 ff ff       	call   8001ef <_panic>

00800f56 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
  800f5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6f:	89 df                	mov    %ebx,%edi
  800f71:	89 de                	mov    %ebx,%esi
  800f73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	7f 08                	jg     800f81 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f81:	83 ec 0c             	sub    $0xc,%esp
  800f84:	50                   	push   %eax
  800f85:	6a 0a                	push   $0xa
  800f87:	68 e0 2e 80 00       	push   $0x802ee0
  800f8c:	6a 33                	push   $0x33
  800f8e:	68 fd 2e 80 00       	push   $0x802efd
  800f93:	e8 57 f2 ff ff       	call   8001ef <_panic>

00800f98 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa9:	be 00 00 00 00       	mov    $0x0,%esi
  800fae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fb4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
  800fc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fd1:	89 cb                	mov    %ecx,%ebx
  800fd3:	89 cf                	mov    %ecx,%edi
  800fd5:	89 ce                	mov    %ecx,%esi
  800fd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	7f 08                	jg     800fe5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	50                   	push   %eax
  800fe9:	6a 0e                	push   $0xe
  800feb:	68 e0 2e 80 00       	push   $0x802ee0
  800ff0:	6a 33                	push   $0x33
  800ff2:	68 fd 2e 80 00       	push   $0x802efd
  800ff7:	e8 f3 f1 ff ff       	call   8001ef <_panic>

00800ffc <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
	asm volatile("int %1\n"
  801002:	bb 00 00 00 00       	mov    $0x0,%ebx
  801007:	8b 55 08             	mov    0x8(%ebp),%edx
  80100a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801012:	89 df                	mov    %ebx,%edi
  801014:	89 de                	mov    %ebx,%esi
  801016:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
	asm volatile("int %1\n"
  801023:	b9 00 00 00 00       	mov    $0x0,%ecx
  801028:	8b 55 08             	mov    0x8(%ebp),%edx
  80102b:	b8 10 00 00 00       	mov    $0x10,%eax
  801030:	89 cb                	mov    %ecx,%ebx
  801032:	89 cf                	mov    %ecx,%edi
  801034:	89 ce                	mov    %ecx,%esi
  801036:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	53                   	push   %ebx
  801041:	83 ec 04             	sub    $0x4,%esp
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801047:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  801049:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80104d:	0f 84 90 00 00 00    	je     8010e3 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  801053:	89 d8                	mov    %ebx,%eax
  801055:	c1 e8 16             	shr    $0x16,%eax
  801058:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80105f:	a8 01                	test   $0x1,%al
  801061:	0f 84 90 00 00 00    	je     8010f7 <pgfault+0xba>
  801067:	89 d8                	mov    %ebx,%eax
  801069:	c1 e8 0c             	shr    $0xc,%eax
  80106c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801073:	a9 01 08 00 00       	test   $0x801,%eax
  801078:	74 7d                	je     8010f7 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	6a 07                	push   $0x7
  80107f:	68 00 f0 7f 00       	push   $0x7ff000
  801084:	6a 00                	push   $0x0
  801086:	e8 3f fd ff ff       	call   800dca <sys_page_alloc>
  80108b:	83 c4 10             	add    $0x10,%esp
  80108e:	85 c0                	test   %eax,%eax
  801090:	78 79                	js     80110b <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  801092:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  801098:	83 ec 04             	sub    $0x4,%esp
  80109b:	68 00 10 00 00       	push   $0x1000
  8010a0:	53                   	push   %ebx
  8010a1:	68 00 f0 7f 00       	push   $0x7ff000
  8010a6:	e8 bb fa ff ff       	call   800b66 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  8010ab:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010b2:	53                   	push   %ebx
  8010b3:	6a 00                	push   $0x0
  8010b5:	68 00 f0 7f 00       	push   $0x7ff000
  8010ba:	6a 00                	push   $0x0
  8010bc:	e8 4c fd ff ff       	call   800e0d <sys_page_map>
  8010c1:	83 c4 20             	add    $0x20,%esp
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	78 55                	js     80111d <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  8010c8:	83 ec 08             	sub    $0x8,%esp
  8010cb:	68 00 f0 7f 00       	push   $0x7ff000
  8010d0:	6a 00                	push   $0x0
  8010d2:	e8 78 fd ff ff       	call   800e4f <sys_page_unmap>
  8010d7:	83 c4 10             	add    $0x10,%esp
  8010da:	85 c0                	test   %eax,%eax
  8010dc:	78 51                	js     80112f <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  8010de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 0c 2f 80 00       	push   $0x802f0c
  8010eb:	6a 21                	push   $0x21
  8010ed:	68 94 2f 80 00       	push   $0x802f94
  8010f2:	e8 f8 f0 ff ff       	call   8001ef <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  8010f7:	83 ec 04             	sub    $0x4,%esp
  8010fa:	68 38 2f 80 00       	push   $0x802f38
  8010ff:	6a 24                	push   $0x24
  801101:	68 94 2f 80 00       	push   $0x802f94
  801106:	e8 e4 f0 ff ff       	call   8001ef <_panic>
		panic("sys_page_alloc: %e\n", r);
  80110b:	50                   	push   %eax
  80110c:	68 9f 2f 80 00       	push   $0x802f9f
  801111:	6a 2e                	push   $0x2e
  801113:	68 94 2f 80 00       	push   $0x802f94
  801118:	e8 d2 f0 ff ff       	call   8001ef <_panic>
		panic("sys_page_map: %e\n", r);
  80111d:	50                   	push   %eax
  80111e:	68 b3 2f 80 00       	push   $0x802fb3
  801123:	6a 34                	push   $0x34
  801125:	68 94 2f 80 00       	push   $0x802f94
  80112a:	e8 c0 f0 ff ff       	call   8001ef <_panic>
		panic("sys_page_unmap: %e\n", r);
  80112f:	50                   	push   %eax
  801130:	68 c5 2f 80 00       	push   $0x802fc5
  801135:	6a 37                	push   $0x37
  801137:	68 94 2f 80 00       	push   $0x802f94
  80113c:	e8 ae f0 ff ff       	call   8001ef <_panic>

00801141 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	57                   	push   %edi
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
  801147:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  80114a:	68 3d 10 80 00       	push   $0x80103d
  80114f:	e8 58 08 00 00       	call   8019ac <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801154:	b8 07 00 00 00       	mov    $0x7,%eax
  801159:	cd 30                	int    $0x30
  80115b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	78 30                	js     801195 <fork+0x54>
  801165:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801167:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80116c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801170:	0f 85 a5 00 00 00    	jne    80121b <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  801176:	e8 11 fc ff ff       	call   800d8c <sys_getenvid>
  80117b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801180:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  801183:	c1 e0 04             	shl    $0x4,%eax
  801186:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80118b:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801190:	e9 75 01 00 00       	jmp    80130a <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  801195:	50                   	push   %eax
  801196:	68 d9 2f 80 00       	push   $0x802fd9
  80119b:	68 83 00 00 00       	push   $0x83
  8011a0:	68 94 2f 80 00       	push   $0x802f94
  8011a5:	e8 45 f0 ff ff       	call   8001ef <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8011aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b9:	50                   	push   %eax
  8011ba:	56                   	push   %esi
  8011bb:	57                   	push   %edi
  8011bc:	56                   	push   %esi
  8011bd:	6a 00                	push   $0x0
  8011bf:	e8 49 fc ff ff       	call   800e0d <sys_page_map>
  8011c4:	83 c4 20             	add    $0x20,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	79 3e                	jns    801209 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8011cb:	50                   	push   %eax
  8011cc:	68 b3 2f 80 00       	push   $0x802fb3
  8011d1:	6a 50                	push   $0x50
  8011d3:	68 94 2f 80 00       	push   $0x802f94
  8011d8:	e8 12 f0 ff ff       	call   8001ef <_panic>
			panic("sys_page_map: %e\n", r);
  8011dd:	50                   	push   %eax
  8011de:	68 b3 2f 80 00       	push   $0x802fb3
  8011e3:	6a 54                	push   $0x54
  8011e5:	68 94 2f 80 00       	push   $0x802f94
  8011ea:	e8 00 f0 ff ff       	call   8001ef <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	6a 05                	push   $0x5
  8011f4:	56                   	push   %esi
  8011f5:	57                   	push   %edi
  8011f6:	56                   	push   %esi
  8011f7:	6a 00                	push   $0x0
  8011f9:	e8 0f fc ff ff       	call   800e0d <sys_page_map>
  8011fe:	83 c4 20             	add    $0x20,%esp
  801201:	85 c0                	test   %eax,%eax
  801203:	0f 88 ab 00 00 00    	js     8012b4 <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801209:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80120f:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801215:	0f 84 ab 00 00 00    	je     8012c6 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  80121b:	89 d8                	mov    %ebx,%eax
  80121d:	c1 e8 16             	shr    $0x16,%eax
  801220:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801227:	a8 01                	test   $0x1,%al
  801229:	74 de                	je     801209 <fork+0xc8>
  80122b:	89 d8                	mov    %ebx,%eax
  80122d:	c1 e8 0c             	shr    $0xc,%eax
  801230:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801237:	f6 c2 01             	test   $0x1,%dl
  80123a:	74 cd                	je     801209 <fork+0xc8>
  80123c:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801242:	74 c5                	je     801209 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  801244:	89 c6                	mov    %eax,%esi
  801246:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  801249:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801250:	f6 c6 04             	test   $0x4,%dh
  801253:	0f 85 51 ff ff ff    	jne    8011aa <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  801259:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801260:	a9 02 08 00 00       	test   $0x802,%eax
  801265:	74 88                	je     8011ef <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	68 05 08 00 00       	push   $0x805
  80126f:	56                   	push   %esi
  801270:	57                   	push   %edi
  801271:	56                   	push   %esi
  801272:	6a 00                	push   $0x0
  801274:	e8 94 fb ff ff       	call   800e0d <sys_page_map>
  801279:	83 c4 20             	add    $0x20,%esp
  80127c:	85 c0                	test   %eax,%eax
  80127e:	0f 88 59 ff ff ff    	js     8011dd <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801284:	83 ec 0c             	sub    $0xc,%esp
  801287:	68 05 08 00 00       	push   $0x805
  80128c:	56                   	push   %esi
  80128d:	6a 00                	push   $0x0
  80128f:	56                   	push   %esi
  801290:	6a 00                	push   $0x0
  801292:	e8 76 fb ff ff       	call   800e0d <sys_page_map>
  801297:	83 c4 20             	add    $0x20,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	0f 89 67 ff ff ff    	jns    801209 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8012a2:	50                   	push   %eax
  8012a3:	68 b3 2f 80 00       	push   $0x802fb3
  8012a8:	6a 56                	push   $0x56
  8012aa:	68 94 2f 80 00       	push   $0x802f94
  8012af:	e8 3b ef ff ff       	call   8001ef <_panic>
			panic("sys_page_map: %e\n", r);
  8012b4:	50                   	push   %eax
  8012b5:	68 b3 2f 80 00       	push   $0x802fb3
  8012ba:	6a 5a                	push   $0x5a
  8012bc:	68 94 2f 80 00       	push   $0x802f94
  8012c1:	e8 29 ef ff ff       	call   8001ef <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	6a 07                	push   $0x7
  8012cb:	68 00 f0 bf ee       	push   $0xeebff000
  8012d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012d3:	e8 f2 fa ff ff       	call   800dca <sys_page_alloc>
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	78 36                	js     801315 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8012df:	83 ec 08             	sub    $0x8,%esp
  8012e2:	68 17 1a 80 00       	push   $0x801a17
  8012e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012ea:	e8 67 fc ff ff       	call   800f56 <sys_env_set_pgfault_upcall>
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	78 34                	js     80132a <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	6a 02                	push   $0x2
  8012fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012fe:	e8 cf fb ff ff       	call   800ed2 <sys_env_set_status>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 35                	js     80133f <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  80130a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80130d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801310:	5b                   	pop    %ebx
  801311:	5e                   	pop    %esi
  801312:	5f                   	pop    %edi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  801315:	50                   	push   %eax
  801316:	68 9f 2f 80 00       	push   $0x802f9f
  80131b:	68 95 00 00 00       	push   $0x95
  801320:	68 94 2f 80 00       	push   $0x802f94
  801325:	e8 c5 ee ff ff       	call   8001ef <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  80132a:	50                   	push   %eax
  80132b:	68 74 2f 80 00       	push   $0x802f74
  801330:	68 98 00 00 00       	push   $0x98
  801335:	68 94 2f 80 00       	push   $0x802f94
  80133a:	e8 b0 ee ff ff       	call   8001ef <_panic>
		panic("sys_env_set_status: %e\n", r);
  80133f:	50                   	push   %eax
  801340:	68 e9 2f 80 00       	push   $0x802fe9
  801345:	68 9b 00 00 00       	push   $0x9b
  80134a:	68 94 2f 80 00       	push   $0x802f94
  80134f:	e8 9b ee ff ff       	call   8001ef <_panic>

00801354 <sfork>:

// Challenge!
int
sfork(void)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80135a:	68 01 30 80 00       	push   $0x803001
  80135f:	68 a4 00 00 00       	push   $0xa4
  801364:	68 94 2f 80 00       	push   $0x802f94
  801369:	e8 81 ee ff ff       	call   8001ef <_panic>

0080136e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	57                   	push   %edi
  801372:	56                   	push   %esi
  801373:	53                   	push   %ebx
  801374:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80137a:	6a 00                	push   $0x0
  80137c:	ff 75 08             	pushl  0x8(%ebp)
  80137f:	e8 00 0e 00 00       	call   802184 <open>
  801384:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	0f 88 ff 04 00 00    	js     801894 <spawn+0x526>
  801395:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	68 00 02 00 00       	push   $0x200
  80139f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8013a5:	50                   	push   %eax
  8013a6:	51                   	push   %ecx
  8013a7:	e8 fc 09 00 00       	call   801da8 <readn>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	3d 00 02 00 00       	cmp    $0x200,%eax
  8013b4:	75 60                	jne    801416 <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  8013b6:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8013bd:	45 4c 46 
  8013c0:	75 54                	jne    801416 <spawn+0xa8>
  8013c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8013c7:	cd 30                	int    $0x30
  8013c9:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8013cf:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	0f 88 ab 04 00 00    	js     801888 <spawn+0x51a>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8013dd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013e2:	8d 34 c0             	lea    (%eax,%eax,8),%esi
  8013e5:	c1 e6 04             	shl    $0x4,%esi
  8013e8:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8013ee:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8013f4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8013f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8013fb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801401:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801407:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80140c:	be 00 00 00 00       	mov    $0x0,%esi
  801411:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801414:	eb 4b                	jmp    801461 <spawn+0xf3>
		close(fd);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80141f:	e8 bf 07 00 00       	call   801be3 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801424:	83 c4 0c             	add    $0xc,%esp
  801427:	68 7f 45 4c 46       	push   $0x464c457f
  80142c:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801432:	68 17 30 80 00       	push   $0x803017
  801437:	e8 8e ee ff ff       	call   8002ca <cprintf>
		return -E_NOT_EXEC;
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801446:	ff ff ff 
  801449:	e9 46 04 00 00       	jmp    801894 <spawn+0x526>
		string_size += strlen(argv[argc]) + 1;
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	50                   	push   %eax
  801452:	e8 48 f5 ff ff       	call   80099f <strlen>
  801457:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80145b:	83 c3 01             	add    $0x1,%ebx
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801468:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80146b:	85 c0                	test   %eax,%eax
  80146d:	75 df                	jne    80144e <spawn+0xe0>
  80146f:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801475:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80147b:	bf 00 10 40 00       	mov    $0x401000,%edi
  801480:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801482:	89 fa                	mov    %edi,%edx
  801484:	83 e2 fc             	and    $0xfffffffc,%edx
  801487:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80148e:	29 c2                	sub    %eax,%edx
  801490:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801496:	8d 42 f8             	lea    -0x8(%edx),%eax
  801499:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80149e:	0f 86 13 04 00 00    	jbe    8018b7 <spawn+0x549>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	6a 07                	push   $0x7
  8014a9:	68 00 00 40 00       	push   $0x400000
  8014ae:	6a 00                	push   $0x0
  8014b0:	e8 15 f9 ff ff       	call   800dca <sys_page_alloc>
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	0f 88 fc 03 00 00    	js     8018bc <spawn+0x54e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8014c0:	be 00 00 00 00       	mov    $0x0,%esi
  8014c5:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8014cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014ce:	eb 30                	jmp    801500 <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  8014d0:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8014d6:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8014dc:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8014e5:	57                   	push   %edi
  8014e6:	e8 ed f4 ff ff       	call   8009d8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8014eb:	83 c4 04             	add    $0x4,%esp
  8014ee:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8014f1:	e8 a9 f4 ff ff       	call   80099f <strlen>
  8014f6:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8014fa:	83 c6 01             	add    $0x1,%esi
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801506:	7f c8                	jg     8014d0 <spawn+0x162>
	}
	argv_store[argc] = 0;
  801508:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80150e:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801514:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80151b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801521:	0f 85 86 00 00 00    	jne    8015ad <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801527:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  80152d:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801533:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801536:	89 d0                	mov    %edx,%eax
  801538:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80153e:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801541:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801546:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	6a 07                	push   $0x7
  801551:	68 00 d0 bf ee       	push   $0xeebfd000
  801556:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80155c:	68 00 00 40 00       	push   $0x400000
  801561:	6a 00                	push   $0x0
  801563:	e8 a5 f8 ff ff       	call   800e0d <sys_page_map>
  801568:	89 c3                	mov    %eax,%ebx
  80156a:	83 c4 20             	add    $0x20,%esp
  80156d:	85 c0                	test   %eax,%eax
  80156f:	0f 88 4f 03 00 00    	js     8018c4 <spawn+0x556>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801575:	83 ec 08             	sub    $0x8,%esp
  801578:	68 00 00 40 00       	push   $0x400000
  80157d:	6a 00                	push   $0x0
  80157f:	e8 cb f8 ff ff       	call   800e4f <sys_page_unmap>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	0f 88 33 03 00 00    	js     8018c4 <spawn+0x556>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801591:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801597:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80159e:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8015a5:	00 00 00 
  8015a8:	e9 4f 01 00 00       	jmp    8016fc <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8015ad:	68 b8 30 80 00       	push   $0x8030b8
  8015b2:	68 31 30 80 00       	push   $0x803031
  8015b7:	68 f2 00 00 00       	push   $0xf2
  8015bc:	68 46 30 80 00       	push   $0x803046
  8015c1:	e8 29 ec ff ff       	call   8001ef <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	6a 07                	push   $0x7
  8015cb:	68 00 00 40 00       	push   $0x400000
  8015d0:	6a 00                	push   $0x0
  8015d2:	e8 f3 f7 ff ff       	call   800dca <sys_page_alloc>
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	0f 88 c0 02 00 00    	js     8018a2 <spawn+0x534>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8015eb:	01 f0                	add    %esi,%eax
  8015ed:	50                   	push   %eax
  8015ee:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8015f4:	e8 76 08 00 00       	call   801e6f <seek>
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	0f 88 a5 02 00 00    	js     8018a9 <spawn+0x53b>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801604:	83 ec 04             	sub    $0x4,%esp
  801607:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80160d:	29 f0                	sub    %esi,%eax
  80160f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801614:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801619:	0f 47 c1             	cmova  %ecx,%eax
  80161c:	50                   	push   %eax
  80161d:	68 00 00 40 00       	push   $0x400000
  801622:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801628:	e8 7b 07 00 00       	call   801da8 <readn>
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	0f 88 78 02 00 00    	js     8018b0 <spawn+0x542>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801638:	83 ec 0c             	sub    $0xc,%esp
  80163b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801641:	53                   	push   %ebx
  801642:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801648:	68 00 00 40 00       	push   $0x400000
  80164d:	6a 00                	push   $0x0
  80164f:	e8 b9 f7 ff ff       	call   800e0d <sys_page_map>
  801654:	83 c4 20             	add    $0x20,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 7c                	js     8016d7 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80165b:	83 ec 08             	sub    $0x8,%esp
  80165e:	68 00 00 40 00       	push   $0x400000
  801663:	6a 00                	push   $0x0
  801665:	e8 e5 f7 ff ff       	call   800e4f <sys_page_unmap>
  80166a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80166d:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801673:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801679:	89 fe                	mov    %edi,%esi
  80167b:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801681:	76 69                	jbe    8016ec <spawn+0x37e>
		if (i >= filesz) {
  801683:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801689:	0f 87 37 ff ff ff    	ja     8015c6 <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80168f:	83 ec 04             	sub    $0x4,%esp
  801692:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801698:	53                   	push   %ebx
  801699:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80169f:	e8 26 f7 ff ff       	call   800dca <sys_page_alloc>
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	79 c2                	jns    80166d <spawn+0x2ff>
  8016ab:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8016ad:	83 ec 0c             	sub    $0xc,%esp
  8016b0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8016b6:	e8 90 f6 ff ff       	call   800d4b <sys_env_destroy>
	close(fd);
  8016bb:	83 c4 04             	add    $0x4,%esp
  8016be:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8016c4:	e8 1a 05 00 00       	call   801be3 <close>
	return r;
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8016d2:	e9 bd 01 00 00       	jmp    801894 <spawn+0x526>
				panic("spawn: sys_page_map data: %e", r);
  8016d7:	50                   	push   %eax
  8016d8:	68 52 30 80 00       	push   $0x803052
  8016dd:	68 25 01 00 00       	push   $0x125
  8016e2:	68 46 30 80 00       	push   $0x803046
  8016e7:	e8 03 eb ff ff       	call   8001ef <_panic>
  8016ec:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8016f2:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8016f9:	83 c6 20             	add    $0x20,%esi
  8016fc:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801703:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801709:	7e 6d                	jle    801778 <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  80170b:	83 3e 01             	cmpl   $0x1,(%esi)
  80170e:	75 e2                	jne    8016f2 <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801710:	8b 46 18             	mov    0x18(%esi),%eax
  801713:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801716:	83 f8 01             	cmp    $0x1,%eax
  801719:	19 c0                	sbb    %eax,%eax
  80171b:	83 e0 fe             	and    $0xfffffffe,%eax
  80171e:	83 c0 07             	add    $0x7,%eax
  801721:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801727:	8b 4e 04             	mov    0x4(%esi),%ecx
  80172a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801730:	8b 56 10             	mov    0x10(%esi),%edx
  801733:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801739:	8b 7e 14             	mov    0x14(%esi),%edi
  80173c:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801742:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801745:	89 d8                	mov    %ebx,%eax
  801747:	25 ff 0f 00 00       	and    $0xfff,%eax
  80174c:	74 1a                	je     801768 <spawn+0x3fa>
		va -= i;
  80174e:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801750:	01 c7                	add    %eax,%edi
  801752:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801758:	01 c2                	add    %eax,%edx
  80175a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801760:	29 c1                	sub    %eax,%ecx
  801762:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801768:	bf 00 00 00 00       	mov    $0x0,%edi
  80176d:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801773:	e9 01 ff ff ff       	jmp    801679 <spawn+0x30b>
	close(fd);
  801778:	83 ec 0c             	sub    $0xc,%esp
  80177b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801781:	e8 5d 04 00 00       	call   801be3 <close>
  801786:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	uint8_t *addr;
	int r;

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  801789:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80178e:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801794:	eb 0e                	jmp    8017a4 <spawn+0x436>
  801796:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80179c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8017a2:	74 6f                	je     801813 <spawn+0x4a5>
		if ((uvpd[PDX(addr)] & PTE_P) 
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	c1 e8 16             	shr    $0x16,%eax
  8017a9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017b0:	a8 01                	test   $0x1,%al
  8017b2:	74 e2                	je     801796 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_P) 
  8017b4:	89 d8                	mov    %ebx,%eax
  8017b6:	c1 e8 0c             	shr    $0xc,%eax
  8017b9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017c0:	f6 c2 01             	test   $0x1,%dl
  8017c3:	74 d1                	je     801796 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_U) 
  8017c5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017cc:	f6 c2 04             	test   $0x4,%dl
  8017cf:	74 c5                	je     801796 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_SHARE)){
  8017d1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017d8:	f6 c6 04             	test   $0x4,%dh
  8017db:	74 b9                	je     801796 <spawn+0x428>
			if((r = sys_page_map(0, (void*)addr, child, (void*)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8017dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017e4:	83 ec 0c             	sub    $0xc,%esp
  8017e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017ec:	50                   	push   %eax
  8017ed:	53                   	push   %ebx
  8017ee:	56                   	push   %esi
  8017ef:	53                   	push   %ebx
  8017f0:	6a 00                	push   $0x0
  8017f2:	e8 16 f6 ff ff       	call   800e0d <sys_page_map>
  8017f7:	83 c4 20             	add    $0x20,%esp
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	79 98                	jns    801796 <spawn+0x428>
				panic("copy_shared_pages: %e\n", r);
  8017fe:	50                   	push   %eax
  8017ff:	68 6f 30 80 00       	push   $0x80306f
  801804:	68 3a 01 00 00       	push   $0x13a
  801809:	68 46 30 80 00       	push   $0x803046
  80180e:	e8 dc e9 ff ff       	call   8001ef <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801813:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80181a:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801826:	50                   	push   %eax
  801827:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80182d:	e8 e2 f6 ff ff       	call   800f14 <sys_env_set_trapframe>
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	85 c0                	test   %eax,%eax
  801837:	78 25                	js     80185e <spawn+0x4f0>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	6a 02                	push   $0x2
  80183e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801844:	e8 89 f6 ff ff       	call   800ed2 <sys_env_set_status>
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 23                	js     801873 <spawn+0x505>
	return child;
  801850:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801856:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80185c:	eb 36                	jmp    801894 <spawn+0x526>
		panic("sys_env_set_trapframe: %e", r);
  80185e:	50                   	push   %eax
  80185f:	68 86 30 80 00       	push   $0x803086
  801864:	68 86 00 00 00       	push   $0x86
  801869:	68 46 30 80 00       	push   $0x803046
  80186e:	e8 7c e9 ff ff       	call   8001ef <_panic>
		panic("sys_env_set_status: %e", r);
  801873:	50                   	push   %eax
  801874:	68 a0 30 80 00       	push   $0x8030a0
  801879:	68 89 00 00 00       	push   $0x89
  80187e:	68 46 30 80 00       	push   $0x803046
  801883:	e8 67 e9 ff ff       	call   8001ef <_panic>
		return r;
  801888:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80188e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801894:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80189a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5f                   	pop    %edi
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    
  8018a2:	89 c7                	mov    %eax,%edi
  8018a4:	e9 04 fe ff ff       	jmp    8016ad <spawn+0x33f>
  8018a9:	89 c7                	mov    %eax,%edi
  8018ab:	e9 fd fd ff ff       	jmp    8016ad <spawn+0x33f>
  8018b0:	89 c7                	mov    %eax,%edi
  8018b2:	e9 f6 fd ff ff       	jmp    8016ad <spawn+0x33f>
		return -E_NO_MEM;
  8018b7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  8018bc:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8018c2:	eb d0                	jmp    801894 <spawn+0x526>
	sys_page_unmap(0, UTEMP);
  8018c4:	83 ec 08             	sub    $0x8,%esp
  8018c7:	68 00 00 40 00       	push   $0x400000
  8018cc:	6a 00                	push   $0x0
  8018ce:	e8 7c f5 ff ff       	call   800e4f <sys_page_unmap>
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8018dc:	eb b6                	jmp    801894 <spawn+0x526>

008018de <spawnl>:
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	57                   	push   %edi
  8018e2:	56                   	push   %esi
  8018e3:	53                   	push   %ebx
  8018e4:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8018e7:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8018ea:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8018ef:	8d 4a 04             	lea    0x4(%edx),%ecx
  8018f2:	83 3a 00             	cmpl   $0x0,(%edx)
  8018f5:	74 07                	je     8018fe <spawnl+0x20>
		argc++;
  8018f7:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8018fa:	89 ca                	mov    %ecx,%edx
  8018fc:	eb f1                	jmp    8018ef <spawnl+0x11>
	const char *argv[argc+2];
  8018fe:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801905:	83 e2 f0             	and    $0xfffffff0,%edx
  801908:	29 d4                	sub    %edx,%esp
  80190a:	8d 54 24 03          	lea    0x3(%esp),%edx
  80190e:	c1 ea 02             	shr    $0x2,%edx
  801911:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801918:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80191a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80191d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801924:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80192b:	00 
	va_start(vl, arg0);
  80192c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80192f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
  801936:	eb 0b                	jmp    801943 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801938:	83 c0 01             	add    $0x1,%eax
  80193b:	8b 39                	mov    (%ecx),%edi
  80193d:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801940:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801943:	39 d0                	cmp    %edx,%eax
  801945:	75 f1                	jne    801938 <spawnl+0x5a>
	return spawn(prog, argv);
  801947:	83 ec 08             	sub    $0x8,%esp
  80194a:	56                   	push   %esi
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	e8 1b fa ff ff       	call   80136e <spawn>
}
  801953:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5f                   	pop    %edi
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    

0080195b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801963:	85 f6                	test   %esi,%esi
  801965:	74 15                	je     80197c <wait+0x21>
	e = &envs[ENVX(envid)];
  801967:	89 f0                	mov    %esi,%eax
  801969:	25 ff 03 00 00       	and    $0x3ff,%eax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80196e:	8d 1c c0             	lea    (%eax,%eax,8),%ebx
  801971:	c1 e3 04             	shl    $0x4,%ebx
  801974:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80197a:	eb 1b                	jmp    801997 <wait+0x3c>
	assert(envid != 0);
  80197c:	68 de 30 80 00       	push   $0x8030de
  801981:	68 31 30 80 00       	push   $0x803031
  801986:	6a 09                	push   $0x9
  801988:	68 e9 30 80 00       	push   $0x8030e9
  80198d:	e8 5d e8 ff ff       	call   8001ef <_panic>
		sys_yield();
  801992:	e8 14 f4 ff ff       	call   800dab <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801997:	8b 43 48             	mov    0x48(%ebx),%eax
  80199a:	39 f0                	cmp    %esi,%eax
  80199c:	75 07                	jne    8019a5 <wait+0x4a>
  80199e:	8b 43 54             	mov    0x54(%ebx),%eax
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	75 ed                	jne    801992 <wait+0x37>
}
  8019a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a8:	5b                   	pop    %ebx
  8019a9:	5e                   	pop    %esi
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    

008019ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8019b2:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  8019b9:	74 0a                	je     8019c5 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	a3 08 50 80 00       	mov    %eax,0x805008
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	6a 07                	push   $0x7
  8019ca:	68 00 f0 bf ee       	push   $0xeebff000
  8019cf:	6a 00                	push   $0x0
  8019d1:	e8 f4 f3 ff ff       	call   800dca <sys_page_alloc>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 28                	js     801a05 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	68 17 1a 80 00       	push   $0x801a17
  8019e5:	6a 00                	push   $0x0
  8019e7:	e8 6a f5 ff ff       	call   800f56 <sys_env_set_pgfault_upcall>
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	79 c8                	jns    8019bb <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8019f3:	50                   	push   %eax
  8019f4:	68 74 2f 80 00       	push   $0x802f74
  8019f9:	6a 23                	push   $0x23
  8019fb:	68 0c 31 80 00       	push   $0x80310c
  801a00:	e8 ea e7 ff ff       	call   8001ef <_panic>
			panic("set_pgfault_handler %e\n",r);
  801a05:	50                   	push   %eax
  801a06:	68 f4 30 80 00       	push   $0x8030f4
  801a0b:	6a 21                	push   $0x21
  801a0d:	68 0c 31 80 00       	push   $0x80310c
  801a12:	e8 d8 e7 ff ff       	call   8001ef <_panic>

00801a17 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801a17:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801a18:	a1 08 50 80 00       	mov    0x805008,%eax
	call *%eax
  801a1d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801a1f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  801a22:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  801a26:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  801a2a:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801a2d:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801a2f:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801a33:	83 c4 08             	add    $0x8,%esp
	popal
  801a36:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801a37:	83 c4 04             	add    $0x4,%esp
	popfl
  801a3a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801a3b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801a3c:	c3                   	ret    

00801a3d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	05 00 00 00 30       	add    $0x30000000,%eax
  801a48:	c1 e8 0c             	shr    $0xc,%eax
}
  801a4b:	5d                   	pop    %ebp
  801a4c:	c3                   	ret    

00801a4d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801a58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a5d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    

00801a64 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801a6c:	89 c2                	mov    %eax,%edx
  801a6e:	c1 ea 16             	shr    $0x16,%edx
  801a71:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801a78:	f6 c2 01             	test   $0x1,%dl
  801a7b:	74 2d                	je     801aaa <fd_alloc+0x46>
  801a7d:	89 c2                	mov    %eax,%edx
  801a7f:	c1 ea 0c             	shr    $0xc,%edx
  801a82:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a89:	f6 c2 01             	test   $0x1,%dl
  801a8c:	74 1c                	je     801aaa <fd_alloc+0x46>
  801a8e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801a93:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801a98:	75 d2                	jne    801a6c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801aa3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801aa8:	eb 0a                	jmp    801ab4 <fd_alloc+0x50>
			*fd_store = fd;
  801aaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aad:	89 01                	mov    %eax,(%ecx)
			return 0;
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    

00801ab6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801abc:	83 f8 1f             	cmp    $0x1f,%eax
  801abf:	77 30                	ja     801af1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801ac1:	c1 e0 0c             	shl    $0xc,%eax
  801ac4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ac9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801acf:	f6 c2 01             	test   $0x1,%dl
  801ad2:	74 24                	je     801af8 <fd_lookup+0x42>
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	c1 ea 0c             	shr    $0xc,%edx
  801ad9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ae0:	f6 c2 01             	test   $0x1,%dl
  801ae3:	74 1a                	je     801aff <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae8:	89 02                	mov    %eax,(%edx)
	return 0;
  801aea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aef:	5d                   	pop    %ebp
  801af0:	c3                   	ret    
		return -E_INVAL;
  801af1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af6:	eb f7                	jmp    801aef <fd_lookup+0x39>
		return -E_INVAL;
  801af8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801afd:	eb f0                	jmp    801aef <fd_lookup+0x39>
  801aff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b04:	eb e9                	jmp    801aef <fd_lookup+0x39>

00801b06 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 08             	sub    $0x8,%esp
  801b0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b0f:	ba 9c 31 80 00       	mov    $0x80319c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801b14:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801b19:	39 08                	cmp    %ecx,(%eax)
  801b1b:	74 33                	je     801b50 <dev_lookup+0x4a>
  801b1d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801b20:	8b 02                	mov    (%edx),%eax
  801b22:	85 c0                	test   %eax,%eax
  801b24:	75 f3                	jne    801b19 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b26:	a1 04 50 80 00       	mov    0x805004,%eax
  801b2b:	8b 40 48             	mov    0x48(%eax),%eax
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	51                   	push   %ecx
  801b32:	50                   	push   %eax
  801b33:	68 1c 31 80 00       	push   $0x80311c
  801b38:	e8 8d e7 ff ff       	call   8002ca <cprintf>
	*dev = 0;
  801b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    
			*dev = devtab[i];
  801b50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b53:	89 01                	mov    %eax,(%ecx)
			return 0;
  801b55:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5a:	eb f2                	jmp    801b4e <dev_lookup+0x48>

00801b5c <fd_close>:
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	57                   	push   %edi
  801b60:	56                   	push   %esi
  801b61:	53                   	push   %ebx
  801b62:	83 ec 24             	sub    $0x24,%esp
  801b65:	8b 75 08             	mov    0x8(%ebp),%esi
  801b68:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b6b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b6e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b6f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801b75:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b78:	50                   	push   %eax
  801b79:	e8 38 ff ff ff       	call   801ab6 <fd_lookup>
  801b7e:	89 c3                	mov    %eax,%ebx
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 05                	js     801b8c <fd_close+0x30>
	    || fd != fd2)
  801b87:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801b8a:	74 16                	je     801ba2 <fd_close+0x46>
		return (must_exist ? r : 0);
  801b8c:	89 f8                	mov    %edi,%eax
  801b8e:	84 c0                	test   %al,%al
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
  801b95:	0f 44 d8             	cmove  %eax,%ebx
}
  801b98:	89 d8                	mov    %ebx,%eax
  801b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5f                   	pop    %edi
  801ba0:	5d                   	pop    %ebp
  801ba1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ba8:	50                   	push   %eax
  801ba9:	ff 36                	pushl  (%esi)
  801bab:	e8 56 ff ff ff       	call   801b06 <dev_lookup>
  801bb0:	89 c3                	mov    %eax,%ebx
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 1a                	js     801bd3 <fd_close+0x77>
		if (dev->dev_close)
  801bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bbc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801bbf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	74 0b                	je     801bd3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801bc8:	83 ec 0c             	sub    $0xc,%esp
  801bcb:	56                   	push   %esi
  801bcc:	ff d0                	call   *%eax
  801bce:	89 c3                	mov    %eax,%ebx
  801bd0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801bd3:	83 ec 08             	sub    $0x8,%esp
  801bd6:	56                   	push   %esi
  801bd7:	6a 00                	push   $0x0
  801bd9:	e8 71 f2 ff ff       	call   800e4f <sys_page_unmap>
	return r;
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	eb b5                	jmp    801b98 <fd_close+0x3c>

00801be3 <close>:

int
close(int fdnum)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bec:	50                   	push   %eax
  801bed:	ff 75 08             	pushl  0x8(%ebp)
  801bf0:	e8 c1 fe ff ff       	call   801ab6 <fd_lookup>
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	79 02                	jns    801bfe <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    
		return fd_close(fd, 1);
  801bfe:	83 ec 08             	sub    $0x8,%esp
  801c01:	6a 01                	push   $0x1
  801c03:	ff 75 f4             	pushl  -0xc(%ebp)
  801c06:	e8 51 ff ff ff       	call   801b5c <fd_close>
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	eb ec                	jmp    801bfc <close+0x19>

00801c10 <close_all>:

void
close_all(void)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	53                   	push   %ebx
  801c14:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801c17:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	53                   	push   %ebx
  801c20:	e8 be ff ff ff       	call   801be3 <close>
	for (i = 0; i < MAXFD; i++)
  801c25:	83 c3 01             	add    $0x1,%ebx
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	83 fb 20             	cmp    $0x20,%ebx
  801c2e:	75 ec                	jne    801c1c <close_all+0xc>
}
  801c30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	57                   	push   %edi
  801c39:	56                   	push   %esi
  801c3a:	53                   	push   %ebx
  801c3b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801c3e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c41:	50                   	push   %eax
  801c42:	ff 75 08             	pushl  0x8(%ebp)
  801c45:	e8 6c fe ff ff       	call   801ab6 <fd_lookup>
  801c4a:	89 c3                	mov    %eax,%ebx
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	0f 88 81 00 00 00    	js     801cd8 <dup+0xa3>
		return r;
	close(newfdnum);
  801c57:	83 ec 0c             	sub    $0xc,%esp
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	e8 81 ff ff ff       	call   801be3 <close>

	newfd = INDEX2FD(newfdnum);
  801c62:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c65:	c1 e6 0c             	shl    $0xc,%esi
  801c68:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801c6e:	83 c4 04             	add    $0x4,%esp
  801c71:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c74:	e8 d4 fd ff ff       	call   801a4d <fd2data>
  801c79:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c7b:	89 34 24             	mov    %esi,(%esp)
  801c7e:	e8 ca fd ff ff       	call   801a4d <fd2data>
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801c88:	89 d8                	mov    %ebx,%eax
  801c8a:	c1 e8 16             	shr    $0x16,%eax
  801c8d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c94:	a8 01                	test   $0x1,%al
  801c96:	74 11                	je     801ca9 <dup+0x74>
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	c1 e8 0c             	shr    $0xc,%eax
  801c9d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ca4:	f6 c2 01             	test   $0x1,%dl
  801ca7:	75 39                	jne    801ce2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ca9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cac:	89 d0                	mov    %edx,%eax
  801cae:	c1 e8 0c             	shr    $0xc,%eax
  801cb1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	25 07 0e 00 00       	and    $0xe07,%eax
  801cc0:	50                   	push   %eax
  801cc1:	56                   	push   %esi
  801cc2:	6a 00                	push   $0x0
  801cc4:	52                   	push   %edx
  801cc5:	6a 00                	push   $0x0
  801cc7:	e8 41 f1 ff ff       	call   800e0d <sys_page_map>
  801ccc:	89 c3                	mov    %eax,%ebx
  801cce:	83 c4 20             	add    $0x20,%esp
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 31                	js     801d06 <dup+0xd1>
		goto err;

	return newfdnum;
  801cd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801cd8:	89 d8                	mov    %ebx,%eax
  801cda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cdd:	5b                   	pop    %ebx
  801cde:	5e                   	pop    %esi
  801cdf:	5f                   	pop    %edi
  801ce0:	5d                   	pop    %ebp
  801ce1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ce2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ce9:	83 ec 0c             	sub    $0xc,%esp
  801cec:	25 07 0e 00 00       	and    $0xe07,%eax
  801cf1:	50                   	push   %eax
  801cf2:	57                   	push   %edi
  801cf3:	6a 00                	push   $0x0
  801cf5:	53                   	push   %ebx
  801cf6:	6a 00                	push   $0x0
  801cf8:	e8 10 f1 ff ff       	call   800e0d <sys_page_map>
  801cfd:	89 c3                	mov    %eax,%ebx
  801cff:	83 c4 20             	add    $0x20,%esp
  801d02:	85 c0                	test   %eax,%eax
  801d04:	79 a3                	jns    801ca9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801d06:	83 ec 08             	sub    $0x8,%esp
  801d09:	56                   	push   %esi
  801d0a:	6a 00                	push   $0x0
  801d0c:	e8 3e f1 ff ff       	call   800e4f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801d11:	83 c4 08             	add    $0x8,%esp
  801d14:	57                   	push   %edi
  801d15:	6a 00                	push   $0x0
  801d17:	e8 33 f1 ff ff       	call   800e4f <sys_page_unmap>
	return r;
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	eb b7                	jmp    801cd8 <dup+0xa3>

00801d21 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	53                   	push   %ebx
  801d25:	83 ec 1c             	sub    $0x1c,%esp
  801d28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d2e:	50                   	push   %eax
  801d2f:	53                   	push   %ebx
  801d30:	e8 81 fd ff ff       	call   801ab6 <fd_lookup>
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	78 3f                	js     801d7b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d3c:	83 ec 08             	sub    $0x8,%esp
  801d3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d42:	50                   	push   %eax
  801d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d46:	ff 30                	pushl  (%eax)
  801d48:	e8 b9 fd ff ff       	call   801b06 <dev_lookup>
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	85 c0                	test   %eax,%eax
  801d52:	78 27                	js     801d7b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d57:	8b 42 08             	mov    0x8(%edx),%eax
  801d5a:	83 e0 03             	and    $0x3,%eax
  801d5d:	83 f8 01             	cmp    $0x1,%eax
  801d60:	74 1e                	je     801d80 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	8b 40 08             	mov    0x8(%eax),%eax
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	74 35                	je     801da1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	ff 75 10             	pushl  0x10(%ebp)
  801d72:	ff 75 0c             	pushl  0xc(%ebp)
  801d75:	52                   	push   %edx
  801d76:	ff d0                	call   *%eax
  801d78:	83 c4 10             	add    $0x10,%esp
}
  801d7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d80:	a1 04 50 80 00       	mov    0x805004,%eax
  801d85:	8b 40 48             	mov    0x48(%eax),%eax
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	53                   	push   %ebx
  801d8c:	50                   	push   %eax
  801d8d:	68 60 31 80 00       	push   $0x803160
  801d92:	e8 33 e5 ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d9f:	eb da                	jmp    801d7b <read+0x5a>
		return -E_NOT_SUPP;
  801da1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801da6:	eb d3                	jmp    801d7b <read+0x5a>

00801da8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	57                   	push   %edi
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
  801dae:	83 ec 0c             	sub    $0xc,%esp
  801db1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801db4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801db7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dbc:	39 f3                	cmp    %esi,%ebx
  801dbe:	73 23                	jae    801de3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801dc0:	83 ec 04             	sub    $0x4,%esp
  801dc3:	89 f0                	mov    %esi,%eax
  801dc5:	29 d8                	sub    %ebx,%eax
  801dc7:	50                   	push   %eax
  801dc8:	89 d8                	mov    %ebx,%eax
  801dca:	03 45 0c             	add    0xc(%ebp),%eax
  801dcd:	50                   	push   %eax
  801dce:	57                   	push   %edi
  801dcf:	e8 4d ff ff ff       	call   801d21 <read>
		if (m < 0)
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	78 06                	js     801de1 <readn+0x39>
			return m;
		if (m == 0)
  801ddb:	74 06                	je     801de3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ddd:	01 c3                	add    %eax,%ebx
  801ddf:	eb db                	jmp    801dbc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801de1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801de3:	89 d8                	mov    %ebx,%eax
  801de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de8:	5b                   	pop    %ebx
  801de9:	5e                   	pop    %esi
  801dea:	5f                   	pop    %edi
  801deb:	5d                   	pop    %ebp
  801dec:	c3                   	ret    

00801ded <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	53                   	push   %ebx
  801df1:	83 ec 1c             	sub    $0x1c,%esp
  801df4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801df7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dfa:	50                   	push   %eax
  801dfb:	53                   	push   %ebx
  801dfc:	e8 b5 fc ff ff       	call   801ab6 <fd_lookup>
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	85 c0                	test   %eax,%eax
  801e06:	78 3a                	js     801e42 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e08:	83 ec 08             	sub    $0x8,%esp
  801e0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0e:	50                   	push   %eax
  801e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e12:	ff 30                	pushl  (%eax)
  801e14:	e8 ed fc ff ff       	call   801b06 <dev_lookup>
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	78 22                	js     801e42 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e23:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e27:	74 1e                	je     801e47 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2c:	8b 52 0c             	mov    0xc(%edx),%edx
  801e2f:	85 d2                	test   %edx,%edx
  801e31:	74 35                	je     801e68 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	ff 75 10             	pushl  0x10(%ebp)
  801e39:	ff 75 0c             	pushl  0xc(%ebp)
  801e3c:	50                   	push   %eax
  801e3d:	ff d2                	call   *%edx
  801e3f:	83 c4 10             	add    $0x10,%esp
}
  801e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e47:	a1 04 50 80 00       	mov    0x805004,%eax
  801e4c:	8b 40 48             	mov    0x48(%eax),%eax
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	53                   	push   %ebx
  801e53:	50                   	push   %eax
  801e54:	68 7c 31 80 00       	push   $0x80317c
  801e59:	e8 6c e4 ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e66:	eb da                	jmp    801e42 <write+0x55>
		return -E_NOT_SUPP;
  801e68:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e6d:	eb d3                	jmp    801e42 <write+0x55>

00801e6f <seek>:

int
seek(int fdnum, off_t offset)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e78:	50                   	push   %eax
  801e79:	ff 75 08             	pushl  0x8(%ebp)
  801e7c:	e8 35 fc ff ff       	call   801ab6 <fd_lookup>
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	85 c0                	test   %eax,%eax
  801e86:	78 0e                	js     801e96 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801e88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	53                   	push   %ebx
  801e9c:	83 ec 1c             	sub    $0x1c,%esp
  801e9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ea2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea5:	50                   	push   %eax
  801ea6:	53                   	push   %ebx
  801ea7:	e8 0a fc ff ff       	call   801ab6 <fd_lookup>
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 37                	js     801eea <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801eb3:	83 ec 08             	sub    $0x8,%esp
  801eb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb9:	50                   	push   %eax
  801eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebd:	ff 30                	pushl  (%eax)
  801ebf:	e8 42 fc ff ff       	call   801b06 <dev_lookup>
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	78 1f                	js     801eea <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ece:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ed2:	74 1b                	je     801eef <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ed4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed7:	8b 52 18             	mov    0x18(%edx),%edx
  801eda:	85 d2                	test   %edx,%edx
  801edc:	74 32                	je     801f10 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ede:	83 ec 08             	sub    $0x8,%esp
  801ee1:	ff 75 0c             	pushl  0xc(%ebp)
  801ee4:	50                   	push   %eax
  801ee5:	ff d2                	call   *%edx
  801ee7:	83 c4 10             	add    $0x10,%esp
}
  801eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    
			thisenv->env_id, fdnum);
  801eef:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ef4:	8b 40 48             	mov    0x48(%eax),%eax
  801ef7:	83 ec 04             	sub    $0x4,%esp
  801efa:	53                   	push   %ebx
  801efb:	50                   	push   %eax
  801efc:	68 3c 31 80 00       	push   $0x80313c
  801f01:	e8 c4 e3 ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f0e:	eb da                	jmp    801eea <ftruncate+0x52>
		return -E_NOT_SUPP;
  801f10:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f15:	eb d3                	jmp    801eea <ftruncate+0x52>

00801f17 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	53                   	push   %ebx
  801f1b:	83 ec 1c             	sub    $0x1c,%esp
  801f1e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f21:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f24:	50                   	push   %eax
  801f25:	ff 75 08             	pushl  0x8(%ebp)
  801f28:	e8 89 fb ff ff       	call   801ab6 <fd_lookup>
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	85 c0                	test   %eax,%eax
  801f32:	78 4b                	js     801f7f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f34:	83 ec 08             	sub    $0x8,%esp
  801f37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3a:	50                   	push   %eax
  801f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3e:	ff 30                	pushl  (%eax)
  801f40:	e8 c1 fb ff ff       	call   801b06 <dev_lookup>
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 33                	js     801f7f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801f53:	74 2f                	je     801f84 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801f55:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801f58:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801f5f:	00 00 00 
	stat->st_isdir = 0;
  801f62:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f69:	00 00 00 
	stat->st_dev = dev;
  801f6c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801f72:	83 ec 08             	sub    $0x8,%esp
  801f75:	53                   	push   %ebx
  801f76:	ff 75 f0             	pushl  -0x10(%ebp)
  801f79:	ff 50 14             	call   *0x14(%eax)
  801f7c:	83 c4 10             	add    $0x10,%esp
}
  801f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    
		return -E_NOT_SUPP;
  801f84:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f89:	eb f4                	jmp    801f7f <fstat+0x68>

00801f8b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	56                   	push   %esi
  801f8f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801f90:	83 ec 08             	sub    $0x8,%esp
  801f93:	6a 00                	push   $0x0
  801f95:	ff 75 08             	pushl  0x8(%ebp)
  801f98:	e8 e7 01 00 00       	call   802184 <open>
  801f9d:	89 c3                	mov    %eax,%ebx
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	78 1b                	js     801fc1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	50                   	push   %eax
  801fad:	e8 65 ff ff ff       	call   801f17 <fstat>
  801fb2:	89 c6                	mov    %eax,%esi
	close(fd);
  801fb4:	89 1c 24             	mov    %ebx,(%esp)
  801fb7:	e8 27 fc ff ff       	call   801be3 <close>
	return r;
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	89 f3                	mov    %esi,%ebx
}
  801fc1:	89 d8                	mov    %ebx,%eax
  801fc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc6:	5b                   	pop    %ebx
  801fc7:	5e                   	pop    %esi
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    

00801fca <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	56                   	push   %esi
  801fce:	53                   	push   %ebx
  801fcf:	89 c6                	mov    %eax,%esi
  801fd1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801fd3:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801fda:	74 27                	je     802003 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801fdc:	6a 07                	push   $0x7
  801fde:	68 00 60 80 00       	push   $0x806000
  801fe3:	56                   	push   %esi
  801fe4:	ff 35 00 50 80 00    	pushl  0x805000
  801fea:	e8 64 07 00 00       	call   802753 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801fef:	83 c4 0c             	add    $0xc,%esp
  801ff2:	6a 00                	push   $0x0
  801ff4:	53                   	push   %ebx
  801ff5:	6a 00                	push   $0x0
  801ff7:	e8 f0 06 00 00       	call   8026ec <ipc_recv>
}
  801ffc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fff:	5b                   	pop    %ebx
  802000:	5e                   	pop    %esi
  802001:	5d                   	pop    %ebp
  802002:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	6a 01                	push   $0x1
  802008:	e8 8f 07 00 00       	call   80279c <ipc_find_env>
  80200d:	a3 00 50 80 00       	mov    %eax,0x805000
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	eb c5                	jmp    801fdc <fsipc+0x12>

00802017 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	8b 40 0c             	mov    0xc(%eax),%eax
  802023:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802030:	ba 00 00 00 00       	mov    $0x0,%edx
  802035:	b8 02 00 00 00       	mov    $0x2,%eax
  80203a:	e8 8b ff ff ff       	call   801fca <fsipc>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <devfile_flush>:
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	8b 40 0c             	mov    0xc(%eax),%eax
  80204d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802052:	ba 00 00 00 00       	mov    $0x0,%edx
  802057:	b8 06 00 00 00       	mov    $0x6,%eax
  80205c:	e8 69 ff ff ff       	call   801fca <fsipc>
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <devfile_stat>:
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	53                   	push   %ebx
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 40 0c             	mov    0xc(%eax),%eax
  802073:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802078:	ba 00 00 00 00       	mov    $0x0,%edx
  80207d:	b8 05 00 00 00       	mov    $0x5,%eax
  802082:	e8 43 ff ff ff       	call   801fca <fsipc>
  802087:	85 c0                	test   %eax,%eax
  802089:	78 2c                	js     8020b7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80208b:	83 ec 08             	sub    $0x8,%esp
  80208e:	68 00 60 80 00       	push   $0x806000
  802093:	53                   	push   %ebx
  802094:	e8 3f e9 ff ff       	call   8009d8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802099:	a1 80 60 80 00       	mov    0x806080,%eax
  80209e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020a4:	a1 84 60 80 00       	mov    0x806084,%eax
  8020a9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <devfile_write>:
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 0c             	sub    $0xc,%esp
  8020c2:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8020c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c8:	8b 52 0c             	mov    0xc(%edx),%edx
  8020cb:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8020d1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8020d6:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8020db:	0f 47 c2             	cmova  %edx,%eax
  8020de:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8020e3:	50                   	push   %eax
  8020e4:	ff 75 0c             	pushl  0xc(%ebp)
  8020e7:	68 08 60 80 00       	push   $0x806008
  8020ec:	e8 75 ea ff ff       	call   800b66 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8020f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f6:	b8 04 00 00 00       	mov    $0x4,%eax
  8020fb:	e8 ca fe ff ff       	call   801fca <fsipc>
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <devfile_read>:
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	56                   	push   %esi
  802106:	53                   	push   %ebx
  802107:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	8b 40 0c             	mov    0xc(%eax),%eax
  802110:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802115:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80211b:	ba 00 00 00 00       	mov    $0x0,%edx
  802120:	b8 03 00 00 00       	mov    $0x3,%eax
  802125:	e8 a0 fe ff ff       	call   801fca <fsipc>
  80212a:	89 c3                	mov    %eax,%ebx
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 1f                	js     80214f <devfile_read+0x4d>
	assert(r <= n);
  802130:	39 f0                	cmp    %esi,%eax
  802132:	77 24                	ja     802158 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802134:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802139:	7f 33                	jg     80216e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	50                   	push   %eax
  80213f:	68 00 60 80 00       	push   $0x806000
  802144:	ff 75 0c             	pushl  0xc(%ebp)
  802147:	e8 1a ea ff ff       	call   800b66 <memmove>
	return r;
  80214c:	83 c4 10             	add    $0x10,%esp
}
  80214f:	89 d8                	mov    %ebx,%eax
  802151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802154:	5b                   	pop    %ebx
  802155:	5e                   	pop    %esi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    
	assert(r <= n);
  802158:	68 ac 31 80 00       	push   $0x8031ac
  80215d:	68 31 30 80 00       	push   $0x803031
  802162:	6a 7c                	push   $0x7c
  802164:	68 b3 31 80 00       	push   $0x8031b3
  802169:	e8 81 e0 ff ff       	call   8001ef <_panic>
	assert(r <= PGSIZE);
  80216e:	68 be 31 80 00       	push   $0x8031be
  802173:	68 31 30 80 00       	push   $0x803031
  802178:	6a 7d                	push   $0x7d
  80217a:	68 b3 31 80 00       	push   $0x8031b3
  80217f:	e8 6b e0 ff ff       	call   8001ef <_panic>

00802184 <open>:
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	56                   	push   %esi
  802188:	53                   	push   %ebx
  802189:	83 ec 1c             	sub    $0x1c,%esp
  80218c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80218f:	56                   	push   %esi
  802190:	e8 0a e8 ff ff       	call   80099f <strlen>
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80219d:	7f 6c                	jg     80220b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80219f:	83 ec 0c             	sub    $0xc,%esp
  8021a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a5:	50                   	push   %eax
  8021a6:	e8 b9 f8 ff ff       	call   801a64 <fd_alloc>
  8021ab:	89 c3                	mov    %eax,%ebx
  8021ad:	83 c4 10             	add    $0x10,%esp
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	78 3c                	js     8021f0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8021b4:	83 ec 08             	sub    $0x8,%esp
  8021b7:	56                   	push   %esi
  8021b8:	68 00 60 80 00       	push   $0x806000
  8021bd:	e8 16 e8 ff ff       	call   8009d8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8021c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c5:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8021ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d2:	e8 f3 fd ff ff       	call   801fca <fsipc>
  8021d7:	89 c3                	mov    %eax,%ebx
  8021d9:	83 c4 10             	add    $0x10,%esp
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	78 19                	js     8021f9 <open+0x75>
	return fd2num(fd);
  8021e0:	83 ec 0c             	sub    $0xc,%esp
  8021e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e6:	e8 52 f8 ff ff       	call   801a3d <fd2num>
  8021eb:	89 c3                	mov    %eax,%ebx
  8021ed:	83 c4 10             	add    $0x10,%esp
}
  8021f0:	89 d8                	mov    %ebx,%eax
  8021f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f5:	5b                   	pop    %ebx
  8021f6:	5e                   	pop    %esi
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    
		fd_close(fd, 0);
  8021f9:	83 ec 08             	sub    $0x8,%esp
  8021fc:	6a 00                	push   $0x0
  8021fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802201:	e8 56 f9 ff ff       	call   801b5c <fd_close>
		return r;
  802206:	83 c4 10             	add    $0x10,%esp
  802209:	eb e5                	jmp    8021f0 <open+0x6c>
		return -E_BAD_PATH;
  80220b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802210:	eb de                	jmp    8021f0 <open+0x6c>

00802212 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802218:	ba 00 00 00 00       	mov    $0x0,%edx
  80221d:	b8 08 00 00 00       	mov    $0x8,%eax
  802222:	e8 a3 fd ff ff       	call   801fca <fsipc>
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	56                   	push   %esi
  80222d:	53                   	push   %ebx
  80222e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802231:	83 ec 0c             	sub    $0xc,%esp
  802234:	ff 75 08             	pushl  0x8(%ebp)
  802237:	e8 11 f8 ff ff       	call   801a4d <fd2data>
  80223c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80223e:	83 c4 08             	add    $0x8,%esp
  802241:	68 ca 31 80 00       	push   $0x8031ca
  802246:	53                   	push   %ebx
  802247:	e8 8c e7 ff ff       	call   8009d8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80224c:	8b 46 04             	mov    0x4(%esi),%eax
  80224f:	2b 06                	sub    (%esi),%eax
  802251:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802257:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80225e:	00 00 00 
	stat->st_dev = &devpipe;
  802261:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  802268:	40 80 00 
	return 0;
}
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802273:	5b                   	pop    %ebx
  802274:	5e                   	pop    %esi
  802275:	5d                   	pop    %ebp
  802276:	c3                   	ret    

00802277 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	53                   	push   %ebx
  80227b:	83 ec 0c             	sub    $0xc,%esp
  80227e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802281:	53                   	push   %ebx
  802282:	6a 00                	push   $0x0
  802284:	e8 c6 eb ff ff       	call   800e4f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802289:	89 1c 24             	mov    %ebx,(%esp)
  80228c:	e8 bc f7 ff ff       	call   801a4d <fd2data>
  802291:	83 c4 08             	add    $0x8,%esp
  802294:	50                   	push   %eax
  802295:	6a 00                	push   $0x0
  802297:	e8 b3 eb ff ff       	call   800e4f <sys_page_unmap>
}
  80229c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <_pipeisclosed>:
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	57                   	push   %edi
  8022a5:	56                   	push   %esi
  8022a6:	53                   	push   %ebx
  8022a7:	83 ec 1c             	sub    $0x1c,%esp
  8022aa:	89 c7                	mov    %eax,%edi
  8022ac:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022ae:	a1 04 50 80 00       	mov    0x805004,%eax
  8022b3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022b6:	83 ec 0c             	sub    $0xc,%esp
  8022b9:	57                   	push   %edi
  8022ba:	e8 1c 05 00 00       	call   8027db <pageref>
  8022bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022c2:	89 34 24             	mov    %esi,(%esp)
  8022c5:	e8 11 05 00 00       	call   8027db <pageref>
		nn = thisenv->env_runs;
  8022ca:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8022d0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022d3:	83 c4 10             	add    $0x10,%esp
  8022d6:	39 cb                	cmp    %ecx,%ebx
  8022d8:	74 1b                	je     8022f5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022da:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022dd:	75 cf                	jne    8022ae <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022df:	8b 42 58             	mov    0x58(%edx),%eax
  8022e2:	6a 01                	push   $0x1
  8022e4:	50                   	push   %eax
  8022e5:	53                   	push   %ebx
  8022e6:	68 d1 31 80 00       	push   $0x8031d1
  8022eb:	e8 da df ff ff       	call   8002ca <cprintf>
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	eb b9                	jmp    8022ae <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022f8:	0f 94 c0             	sete   %al
  8022fb:	0f b6 c0             	movzbl %al,%eax
}
  8022fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    

00802306 <devpipe_write>:
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	57                   	push   %edi
  80230a:	56                   	push   %esi
  80230b:	53                   	push   %ebx
  80230c:	83 ec 28             	sub    $0x28,%esp
  80230f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802312:	56                   	push   %esi
  802313:	e8 35 f7 ff ff       	call   801a4d <fd2data>
  802318:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	bf 00 00 00 00       	mov    $0x0,%edi
  802322:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802325:	74 4f                	je     802376 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802327:	8b 43 04             	mov    0x4(%ebx),%eax
  80232a:	8b 0b                	mov    (%ebx),%ecx
  80232c:	8d 51 20             	lea    0x20(%ecx),%edx
  80232f:	39 d0                	cmp    %edx,%eax
  802331:	72 14                	jb     802347 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802333:	89 da                	mov    %ebx,%edx
  802335:	89 f0                	mov    %esi,%eax
  802337:	e8 65 ff ff ff       	call   8022a1 <_pipeisclosed>
  80233c:	85 c0                	test   %eax,%eax
  80233e:	75 3b                	jne    80237b <devpipe_write+0x75>
			sys_yield();
  802340:	e8 66 ea ff ff       	call   800dab <sys_yield>
  802345:	eb e0                	jmp    802327 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80234a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80234e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802351:	89 c2                	mov    %eax,%edx
  802353:	c1 fa 1f             	sar    $0x1f,%edx
  802356:	89 d1                	mov    %edx,%ecx
  802358:	c1 e9 1b             	shr    $0x1b,%ecx
  80235b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80235e:	83 e2 1f             	and    $0x1f,%edx
  802361:	29 ca                	sub    %ecx,%edx
  802363:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802367:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80236b:	83 c0 01             	add    $0x1,%eax
  80236e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802371:	83 c7 01             	add    $0x1,%edi
  802374:	eb ac                	jmp    802322 <devpipe_write+0x1c>
	return i;
  802376:	8b 45 10             	mov    0x10(%ebp),%eax
  802379:	eb 05                	jmp    802380 <devpipe_write+0x7a>
				return 0;
  80237b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802383:	5b                   	pop    %ebx
  802384:	5e                   	pop    %esi
  802385:	5f                   	pop    %edi
  802386:	5d                   	pop    %ebp
  802387:	c3                   	ret    

00802388 <devpipe_read>:
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	57                   	push   %edi
  80238c:	56                   	push   %esi
  80238d:	53                   	push   %ebx
  80238e:	83 ec 18             	sub    $0x18,%esp
  802391:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802394:	57                   	push   %edi
  802395:	e8 b3 f6 ff ff       	call   801a4d <fd2data>
  80239a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80239c:	83 c4 10             	add    $0x10,%esp
  80239f:	be 00 00 00 00       	mov    $0x0,%esi
  8023a4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023a7:	75 14                	jne    8023bd <devpipe_read+0x35>
	return i;
  8023a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ac:	eb 02                	jmp    8023b0 <devpipe_read+0x28>
				return i;
  8023ae:	89 f0                	mov    %esi,%eax
}
  8023b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023b3:	5b                   	pop    %ebx
  8023b4:	5e                   	pop    %esi
  8023b5:	5f                   	pop    %edi
  8023b6:	5d                   	pop    %ebp
  8023b7:	c3                   	ret    
			sys_yield();
  8023b8:	e8 ee e9 ff ff       	call   800dab <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023bd:	8b 03                	mov    (%ebx),%eax
  8023bf:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023c2:	75 18                	jne    8023dc <devpipe_read+0x54>
			if (i > 0)
  8023c4:	85 f6                	test   %esi,%esi
  8023c6:	75 e6                	jne    8023ae <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023c8:	89 da                	mov    %ebx,%edx
  8023ca:	89 f8                	mov    %edi,%eax
  8023cc:	e8 d0 fe ff ff       	call   8022a1 <_pipeisclosed>
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	74 e3                	je     8023b8 <devpipe_read+0x30>
				return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	eb d4                	jmp    8023b0 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023dc:	99                   	cltd   
  8023dd:	c1 ea 1b             	shr    $0x1b,%edx
  8023e0:	01 d0                	add    %edx,%eax
  8023e2:	83 e0 1f             	and    $0x1f,%eax
  8023e5:	29 d0                	sub    %edx,%eax
  8023e7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023ef:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023f2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023f5:	83 c6 01             	add    $0x1,%esi
  8023f8:	eb aa                	jmp    8023a4 <devpipe_read+0x1c>

008023fa <pipe>:
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	56                   	push   %esi
  8023fe:	53                   	push   %ebx
  8023ff:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802405:	50                   	push   %eax
  802406:	e8 59 f6 ff ff       	call   801a64 <fd_alloc>
  80240b:	89 c3                	mov    %eax,%ebx
  80240d:	83 c4 10             	add    $0x10,%esp
  802410:	85 c0                	test   %eax,%eax
  802412:	0f 88 23 01 00 00    	js     80253b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802418:	83 ec 04             	sub    $0x4,%esp
  80241b:	68 07 04 00 00       	push   $0x407
  802420:	ff 75 f4             	pushl  -0xc(%ebp)
  802423:	6a 00                	push   $0x0
  802425:	e8 a0 e9 ff ff       	call   800dca <sys_page_alloc>
  80242a:	89 c3                	mov    %eax,%ebx
  80242c:	83 c4 10             	add    $0x10,%esp
  80242f:	85 c0                	test   %eax,%eax
  802431:	0f 88 04 01 00 00    	js     80253b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802437:	83 ec 0c             	sub    $0xc,%esp
  80243a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80243d:	50                   	push   %eax
  80243e:	e8 21 f6 ff ff       	call   801a64 <fd_alloc>
  802443:	89 c3                	mov    %eax,%ebx
  802445:	83 c4 10             	add    $0x10,%esp
  802448:	85 c0                	test   %eax,%eax
  80244a:	0f 88 db 00 00 00    	js     80252b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	68 07 04 00 00       	push   $0x407
  802458:	ff 75 f0             	pushl  -0x10(%ebp)
  80245b:	6a 00                	push   $0x0
  80245d:	e8 68 e9 ff ff       	call   800dca <sys_page_alloc>
  802462:	89 c3                	mov    %eax,%ebx
  802464:	83 c4 10             	add    $0x10,%esp
  802467:	85 c0                	test   %eax,%eax
  802469:	0f 88 bc 00 00 00    	js     80252b <pipe+0x131>
	va = fd2data(fd0);
  80246f:	83 ec 0c             	sub    $0xc,%esp
  802472:	ff 75 f4             	pushl  -0xc(%ebp)
  802475:	e8 d3 f5 ff ff       	call   801a4d <fd2data>
  80247a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80247c:	83 c4 0c             	add    $0xc,%esp
  80247f:	68 07 04 00 00       	push   $0x407
  802484:	50                   	push   %eax
  802485:	6a 00                	push   $0x0
  802487:	e8 3e e9 ff ff       	call   800dca <sys_page_alloc>
  80248c:	89 c3                	mov    %eax,%ebx
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	85 c0                	test   %eax,%eax
  802493:	0f 88 82 00 00 00    	js     80251b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802499:	83 ec 0c             	sub    $0xc,%esp
  80249c:	ff 75 f0             	pushl  -0x10(%ebp)
  80249f:	e8 a9 f5 ff ff       	call   801a4d <fd2data>
  8024a4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024ab:	50                   	push   %eax
  8024ac:	6a 00                	push   $0x0
  8024ae:	56                   	push   %esi
  8024af:	6a 00                	push   $0x0
  8024b1:	e8 57 e9 ff ff       	call   800e0d <sys_page_map>
  8024b6:	89 c3                	mov    %eax,%ebx
  8024b8:	83 c4 20             	add    $0x20,%esp
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	78 4e                	js     80250d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024bf:	a1 28 40 80 00       	mov    0x804028,%eax
  8024c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024e2:	83 ec 0c             	sub    $0xc,%esp
  8024e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e8:	e8 50 f5 ff ff       	call   801a3d <fd2num>
  8024ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024f0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024f2:	83 c4 04             	add    $0x4,%esp
  8024f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8024f8:	e8 40 f5 ff ff       	call   801a3d <fd2num>
  8024fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802500:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802503:	83 c4 10             	add    $0x10,%esp
  802506:	bb 00 00 00 00       	mov    $0x0,%ebx
  80250b:	eb 2e                	jmp    80253b <pipe+0x141>
	sys_page_unmap(0, va);
  80250d:	83 ec 08             	sub    $0x8,%esp
  802510:	56                   	push   %esi
  802511:	6a 00                	push   $0x0
  802513:	e8 37 e9 ff ff       	call   800e4f <sys_page_unmap>
  802518:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80251b:	83 ec 08             	sub    $0x8,%esp
  80251e:	ff 75 f0             	pushl  -0x10(%ebp)
  802521:	6a 00                	push   $0x0
  802523:	e8 27 e9 ff ff       	call   800e4f <sys_page_unmap>
  802528:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80252b:	83 ec 08             	sub    $0x8,%esp
  80252e:	ff 75 f4             	pushl  -0xc(%ebp)
  802531:	6a 00                	push   $0x0
  802533:	e8 17 e9 ff ff       	call   800e4f <sys_page_unmap>
  802538:	83 c4 10             	add    $0x10,%esp
}
  80253b:	89 d8                	mov    %ebx,%eax
  80253d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802540:	5b                   	pop    %ebx
  802541:	5e                   	pop    %esi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    

00802544 <pipeisclosed>:
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80254a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80254d:	50                   	push   %eax
  80254e:	ff 75 08             	pushl  0x8(%ebp)
  802551:	e8 60 f5 ff ff       	call   801ab6 <fd_lookup>
  802556:	83 c4 10             	add    $0x10,%esp
  802559:	85 c0                	test   %eax,%eax
  80255b:	78 18                	js     802575 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80255d:	83 ec 0c             	sub    $0xc,%esp
  802560:	ff 75 f4             	pushl  -0xc(%ebp)
  802563:	e8 e5 f4 ff ff       	call   801a4d <fd2data>
	return _pipeisclosed(fd, p);
  802568:	89 c2                	mov    %eax,%edx
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	e8 2f fd ff ff       	call   8022a1 <_pipeisclosed>
  802572:	83 c4 10             	add    $0x10,%esp
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802577:	b8 00 00 00 00       	mov    $0x0,%eax
  80257c:	c3                   	ret    

0080257d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802583:	68 e9 31 80 00       	push   $0x8031e9
  802588:	ff 75 0c             	pushl  0xc(%ebp)
  80258b:	e8 48 e4 ff ff       	call   8009d8 <strcpy>
	return 0;
}
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <devcons_write>:
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	57                   	push   %edi
  80259b:	56                   	push   %esi
  80259c:	53                   	push   %ebx
  80259d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025a3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025a8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025b1:	73 31                	jae    8025e4 <devcons_write+0x4d>
		m = n - tot;
  8025b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025b6:	29 f3                	sub    %esi,%ebx
  8025b8:	83 fb 7f             	cmp    $0x7f,%ebx
  8025bb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025c0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	53                   	push   %ebx
  8025c7:	89 f0                	mov    %esi,%eax
  8025c9:	03 45 0c             	add    0xc(%ebp),%eax
  8025cc:	50                   	push   %eax
  8025cd:	57                   	push   %edi
  8025ce:	e8 93 e5 ff ff       	call   800b66 <memmove>
		sys_cputs(buf, m);
  8025d3:	83 c4 08             	add    $0x8,%esp
  8025d6:	53                   	push   %ebx
  8025d7:	57                   	push   %edi
  8025d8:	e8 31 e7 ff ff       	call   800d0e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025dd:	01 de                	add    %ebx,%esi
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	eb ca                	jmp    8025ae <devcons_write+0x17>
}
  8025e4:	89 f0                	mov    %esi,%eax
  8025e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025e9:	5b                   	pop    %ebx
  8025ea:	5e                   	pop    %esi
  8025eb:	5f                   	pop    %edi
  8025ec:	5d                   	pop    %ebp
  8025ed:	c3                   	ret    

008025ee <devcons_read>:
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	83 ec 08             	sub    $0x8,%esp
  8025f4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025fd:	74 21                	je     802620 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025ff:	e8 28 e7 ff ff       	call   800d2c <sys_cgetc>
  802604:	85 c0                	test   %eax,%eax
  802606:	75 07                	jne    80260f <devcons_read+0x21>
		sys_yield();
  802608:	e8 9e e7 ff ff       	call   800dab <sys_yield>
  80260d:	eb f0                	jmp    8025ff <devcons_read+0x11>
	if (c < 0)
  80260f:	78 0f                	js     802620 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802611:	83 f8 04             	cmp    $0x4,%eax
  802614:	74 0c                	je     802622 <devcons_read+0x34>
	*(char*)vbuf = c;
  802616:	8b 55 0c             	mov    0xc(%ebp),%edx
  802619:	88 02                	mov    %al,(%edx)
	return 1;
  80261b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802620:	c9                   	leave  
  802621:	c3                   	ret    
		return 0;
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
  802627:	eb f7                	jmp    802620 <devcons_read+0x32>

00802629 <cputchar>:
{
  802629:	55                   	push   %ebp
  80262a:	89 e5                	mov    %esp,%ebp
  80262c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802635:	6a 01                	push   $0x1
  802637:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80263a:	50                   	push   %eax
  80263b:	e8 ce e6 ff ff       	call   800d0e <sys_cputs>
}
  802640:	83 c4 10             	add    $0x10,%esp
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <getchar>:
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80264b:	6a 01                	push   $0x1
  80264d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802650:	50                   	push   %eax
  802651:	6a 00                	push   $0x0
  802653:	e8 c9 f6 ff ff       	call   801d21 <read>
	if (r < 0)
  802658:	83 c4 10             	add    $0x10,%esp
  80265b:	85 c0                	test   %eax,%eax
  80265d:	78 06                	js     802665 <getchar+0x20>
	if (r < 1)
  80265f:	74 06                	je     802667 <getchar+0x22>
	return c;
  802661:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802665:	c9                   	leave  
  802666:	c3                   	ret    
		return -E_EOF;
  802667:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80266c:	eb f7                	jmp    802665 <getchar+0x20>

0080266e <iscons>:
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802674:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802677:	50                   	push   %eax
  802678:	ff 75 08             	pushl  0x8(%ebp)
  80267b:	e8 36 f4 ff ff       	call   801ab6 <fd_lookup>
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	85 c0                	test   %eax,%eax
  802685:	78 11                	js     802698 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802690:	39 10                	cmp    %edx,(%eax)
  802692:	0f 94 c0             	sete   %al
  802695:	0f b6 c0             	movzbl %al,%eax
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <opencons>:
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
  80269d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026a3:	50                   	push   %eax
  8026a4:	e8 bb f3 ff ff       	call   801a64 <fd_alloc>
  8026a9:	83 c4 10             	add    $0x10,%esp
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	78 3a                	js     8026ea <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026b0:	83 ec 04             	sub    $0x4,%esp
  8026b3:	68 07 04 00 00       	push   $0x407
  8026b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bb:	6a 00                	push   $0x0
  8026bd:	e8 08 e7 ff ff       	call   800dca <sys_page_alloc>
  8026c2:	83 c4 10             	add    $0x10,%esp
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	78 21                	js     8026ea <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8026d2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026de:	83 ec 0c             	sub    $0xc,%esp
  8026e1:	50                   	push   %eax
  8026e2:	e8 56 f3 ff ff       	call   801a3d <fd2num>
  8026e7:	83 c4 10             	add    $0x10,%esp
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	56                   	push   %esi
  8026f0:	53                   	push   %ebx
  8026f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8026f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  8026fa:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8026fc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802701:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  802704:	83 ec 0c             	sub    $0xc,%esp
  802707:	50                   	push   %eax
  802708:	e8 ae e8 ff ff       	call   800fbb <sys_ipc_recv>
	if (from_env_store)
  80270d:	83 c4 10             	add    $0x10,%esp
  802710:	85 f6                	test   %esi,%esi
  802712:	74 14                	je     802728 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  802714:	ba 00 00 00 00       	mov    $0x0,%edx
  802719:	85 c0                	test   %eax,%eax
  80271b:	78 09                	js     802726 <ipc_recv+0x3a>
  80271d:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802723:	8b 52 78             	mov    0x78(%edx),%edx
  802726:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  802728:	85 db                	test   %ebx,%ebx
  80272a:	74 14                	je     802740 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  80272c:	ba 00 00 00 00       	mov    $0x0,%edx
  802731:	85 c0                	test   %eax,%eax
  802733:	78 09                	js     80273e <ipc_recv+0x52>
  802735:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80273b:	8b 52 7c             	mov    0x7c(%edx),%edx
  80273e:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  802740:	85 c0                	test   %eax,%eax
  802742:	78 08                	js     80274c <ipc_recv+0x60>
  802744:	a1 04 50 80 00       	mov    0x805004,%eax
  802749:	8b 40 74             	mov    0x74(%eax),%eax
}
  80274c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5d                   	pop    %ebp
  802752:	c3                   	ret    

00802753 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
  802756:	83 ec 08             	sub    $0x8,%esp
  802759:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  80275c:	85 c0                	test   %eax,%eax
  80275e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802763:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802766:	ff 75 14             	pushl  0x14(%ebp)
  802769:	50                   	push   %eax
  80276a:	ff 75 0c             	pushl  0xc(%ebp)
  80276d:	ff 75 08             	pushl  0x8(%ebp)
  802770:	e8 23 e8 ff ff       	call   800f98 <sys_ipc_try_send>
  802775:	83 c4 10             	add    $0x10,%esp
  802778:	85 c0                	test   %eax,%eax
  80277a:	78 02                	js     80277e <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  80277e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802781:	75 07                	jne    80278a <ipc_send+0x37>
		sys_yield();
  802783:	e8 23 e6 ff ff       	call   800dab <sys_yield>
}
  802788:	eb f2                	jmp    80277c <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  80278a:	50                   	push   %eax
  80278b:	68 f5 31 80 00       	push   $0x8031f5
  802790:	6a 3c                	push   $0x3c
  802792:	68 09 32 80 00       	push   $0x803209
  802797:	e8 53 da ff ff       	call   8001ef <_panic>

0080279c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027a2:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  8027a7:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8027aa:	c1 e0 04             	shl    $0x4,%eax
  8027ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027b2:	8b 40 50             	mov    0x50(%eax),%eax
  8027b5:	39 c8                	cmp    %ecx,%eax
  8027b7:	74 12                	je     8027cb <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8027b9:	83 c2 01             	add    $0x1,%edx
  8027bc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8027c2:	75 e3                	jne    8027a7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8027c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c9:	eb 0e                	jmp    8027d9 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8027cb:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8027ce:	c1 e0 04             	shl    $0x4,%eax
  8027d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027d6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027d9:	5d                   	pop    %ebp
  8027da:	c3                   	ret    

008027db <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027e1:	89 d0                	mov    %edx,%eax
  8027e3:	c1 e8 16             	shr    $0x16,%eax
  8027e6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8027f2:	f6 c1 01             	test   $0x1,%cl
  8027f5:	74 1d                	je     802814 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8027f7:	c1 ea 0c             	shr    $0xc,%edx
  8027fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802801:	f6 c2 01             	test   $0x1,%dl
  802804:	74 0e                	je     802814 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802806:	c1 ea 0c             	shr    $0xc,%edx
  802809:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802810:	ef 
  802811:	0f b7 c0             	movzwl %ax,%eax
}
  802814:	5d                   	pop    %ebp
  802815:	c3                   	ret    
  802816:	66 90                	xchg   %ax,%ax
  802818:	66 90                	xchg   %ax,%ax
  80281a:	66 90                	xchg   %ax,%ax
  80281c:	66 90                	xchg   %ax,%ax
  80281e:	66 90                	xchg   %ax,%ax

00802820 <__udivdi3>:
  802820:	55                   	push   %ebp
  802821:	57                   	push   %edi
  802822:	56                   	push   %esi
  802823:	53                   	push   %ebx
  802824:	83 ec 1c             	sub    $0x1c,%esp
  802827:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80282b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80282f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802833:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802837:	85 d2                	test   %edx,%edx
  802839:	75 4d                	jne    802888 <__udivdi3+0x68>
  80283b:	39 f3                	cmp    %esi,%ebx
  80283d:	76 19                	jbe    802858 <__udivdi3+0x38>
  80283f:	31 ff                	xor    %edi,%edi
  802841:	89 e8                	mov    %ebp,%eax
  802843:	89 f2                	mov    %esi,%edx
  802845:	f7 f3                	div    %ebx
  802847:	89 fa                	mov    %edi,%edx
  802849:	83 c4 1c             	add    $0x1c,%esp
  80284c:	5b                   	pop    %ebx
  80284d:	5e                   	pop    %esi
  80284e:	5f                   	pop    %edi
  80284f:	5d                   	pop    %ebp
  802850:	c3                   	ret    
  802851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802858:	89 d9                	mov    %ebx,%ecx
  80285a:	85 db                	test   %ebx,%ebx
  80285c:	75 0b                	jne    802869 <__udivdi3+0x49>
  80285e:	b8 01 00 00 00       	mov    $0x1,%eax
  802863:	31 d2                	xor    %edx,%edx
  802865:	f7 f3                	div    %ebx
  802867:	89 c1                	mov    %eax,%ecx
  802869:	31 d2                	xor    %edx,%edx
  80286b:	89 f0                	mov    %esi,%eax
  80286d:	f7 f1                	div    %ecx
  80286f:	89 c6                	mov    %eax,%esi
  802871:	89 e8                	mov    %ebp,%eax
  802873:	89 f7                	mov    %esi,%edi
  802875:	f7 f1                	div    %ecx
  802877:	89 fa                	mov    %edi,%edx
  802879:	83 c4 1c             	add    $0x1c,%esp
  80287c:	5b                   	pop    %ebx
  80287d:	5e                   	pop    %esi
  80287e:	5f                   	pop    %edi
  80287f:	5d                   	pop    %ebp
  802880:	c3                   	ret    
  802881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802888:	39 f2                	cmp    %esi,%edx
  80288a:	77 1c                	ja     8028a8 <__udivdi3+0x88>
  80288c:	0f bd fa             	bsr    %edx,%edi
  80288f:	83 f7 1f             	xor    $0x1f,%edi
  802892:	75 2c                	jne    8028c0 <__udivdi3+0xa0>
  802894:	39 f2                	cmp    %esi,%edx
  802896:	72 06                	jb     80289e <__udivdi3+0x7e>
  802898:	31 c0                	xor    %eax,%eax
  80289a:	39 eb                	cmp    %ebp,%ebx
  80289c:	77 a9                	ja     802847 <__udivdi3+0x27>
  80289e:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a3:	eb a2                	jmp    802847 <__udivdi3+0x27>
  8028a5:	8d 76 00             	lea    0x0(%esi),%esi
  8028a8:	31 ff                	xor    %edi,%edi
  8028aa:	31 c0                	xor    %eax,%eax
  8028ac:	89 fa                	mov    %edi,%edx
  8028ae:	83 c4 1c             	add    $0x1c,%esp
  8028b1:	5b                   	pop    %ebx
  8028b2:	5e                   	pop    %esi
  8028b3:	5f                   	pop    %edi
  8028b4:	5d                   	pop    %ebp
  8028b5:	c3                   	ret    
  8028b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028bd:	8d 76 00             	lea    0x0(%esi),%esi
  8028c0:	89 f9                	mov    %edi,%ecx
  8028c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028c7:	29 f8                	sub    %edi,%eax
  8028c9:	d3 e2                	shl    %cl,%edx
  8028cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028cf:	89 c1                	mov    %eax,%ecx
  8028d1:	89 da                	mov    %ebx,%edx
  8028d3:	d3 ea                	shr    %cl,%edx
  8028d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028d9:	09 d1                	or     %edx,%ecx
  8028db:	89 f2                	mov    %esi,%edx
  8028dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028e1:	89 f9                	mov    %edi,%ecx
  8028e3:	d3 e3                	shl    %cl,%ebx
  8028e5:	89 c1                	mov    %eax,%ecx
  8028e7:	d3 ea                	shr    %cl,%edx
  8028e9:	89 f9                	mov    %edi,%ecx
  8028eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028ef:	89 eb                	mov    %ebp,%ebx
  8028f1:	d3 e6                	shl    %cl,%esi
  8028f3:	89 c1                	mov    %eax,%ecx
  8028f5:	d3 eb                	shr    %cl,%ebx
  8028f7:	09 de                	or     %ebx,%esi
  8028f9:	89 f0                	mov    %esi,%eax
  8028fb:	f7 74 24 08          	divl   0x8(%esp)
  8028ff:	89 d6                	mov    %edx,%esi
  802901:	89 c3                	mov    %eax,%ebx
  802903:	f7 64 24 0c          	mull   0xc(%esp)
  802907:	39 d6                	cmp    %edx,%esi
  802909:	72 15                	jb     802920 <__udivdi3+0x100>
  80290b:	89 f9                	mov    %edi,%ecx
  80290d:	d3 e5                	shl    %cl,%ebp
  80290f:	39 c5                	cmp    %eax,%ebp
  802911:	73 04                	jae    802917 <__udivdi3+0xf7>
  802913:	39 d6                	cmp    %edx,%esi
  802915:	74 09                	je     802920 <__udivdi3+0x100>
  802917:	89 d8                	mov    %ebx,%eax
  802919:	31 ff                	xor    %edi,%edi
  80291b:	e9 27 ff ff ff       	jmp    802847 <__udivdi3+0x27>
  802920:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802923:	31 ff                	xor    %edi,%edi
  802925:	e9 1d ff ff ff       	jmp    802847 <__udivdi3+0x27>
  80292a:	66 90                	xchg   %ax,%ax
  80292c:	66 90                	xchg   %ax,%ax
  80292e:	66 90                	xchg   %ax,%ax

00802930 <__umoddi3>:
  802930:	55                   	push   %ebp
  802931:	57                   	push   %edi
  802932:	56                   	push   %esi
  802933:	53                   	push   %ebx
  802934:	83 ec 1c             	sub    $0x1c,%esp
  802937:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80293b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80293f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802943:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802947:	89 da                	mov    %ebx,%edx
  802949:	85 c0                	test   %eax,%eax
  80294b:	75 43                	jne    802990 <__umoddi3+0x60>
  80294d:	39 df                	cmp    %ebx,%edi
  80294f:	76 17                	jbe    802968 <__umoddi3+0x38>
  802951:	89 f0                	mov    %esi,%eax
  802953:	f7 f7                	div    %edi
  802955:	89 d0                	mov    %edx,%eax
  802957:	31 d2                	xor    %edx,%edx
  802959:	83 c4 1c             	add    $0x1c,%esp
  80295c:	5b                   	pop    %ebx
  80295d:	5e                   	pop    %esi
  80295e:	5f                   	pop    %edi
  80295f:	5d                   	pop    %ebp
  802960:	c3                   	ret    
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	89 fd                	mov    %edi,%ebp
  80296a:	85 ff                	test   %edi,%edi
  80296c:	75 0b                	jne    802979 <__umoddi3+0x49>
  80296e:	b8 01 00 00 00       	mov    $0x1,%eax
  802973:	31 d2                	xor    %edx,%edx
  802975:	f7 f7                	div    %edi
  802977:	89 c5                	mov    %eax,%ebp
  802979:	89 d8                	mov    %ebx,%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	f7 f5                	div    %ebp
  80297f:	89 f0                	mov    %esi,%eax
  802981:	f7 f5                	div    %ebp
  802983:	89 d0                	mov    %edx,%eax
  802985:	eb d0                	jmp    802957 <__umoddi3+0x27>
  802987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80298e:	66 90                	xchg   %ax,%ax
  802990:	89 f1                	mov    %esi,%ecx
  802992:	39 d8                	cmp    %ebx,%eax
  802994:	76 0a                	jbe    8029a0 <__umoddi3+0x70>
  802996:	89 f0                	mov    %esi,%eax
  802998:	83 c4 1c             	add    $0x1c,%esp
  80299b:	5b                   	pop    %ebx
  80299c:	5e                   	pop    %esi
  80299d:	5f                   	pop    %edi
  80299e:	5d                   	pop    %ebp
  80299f:	c3                   	ret    
  8029a0:	0f bd e8             	bsr    %eax,%ebp
  8029a3:	83 f5 1f             	xor    $0x1f,%ebp
  8029a6:	75 20                	jne    8029c8 <__umoddi3+0x98>
  8029a8:	39 d8                	cmp    %ebx,%eax
  8029aa:	0f 82 b0 00 00 00    	jb     802a60 <__umoddi3+0x130>
  8029b0:	39 f7                	cmp    %esi,%edi
  8029b2:	0f 86 a8 00 00 00    	jbe    802a60 <__umoddi3+0x130>
  8029b8:	89 c8                	mov    %ecx,%eax
  8029ba:	83 c4 1c             	add    $0x1c,%esp
  8029bd:	5b                   	pop    %ebx
  8029be:	5e                   	pop    %esi
  8029bf:	5f                   	pop    %edi
  8029c0:	5d                   	pop    %ebp
  8029c1:	c3                   	ret    
  8029c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029c8:	89 e9                	mov    %ebp,%ecx
  8029ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8029cf:	29 ea                	sub    %ebp,%edx
  8029d1:	d3 e0                	shl    %cl,%eax
  8029d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029d7:	89 d1                	mov    %edx,%ecx
  8029d9:	89 f8                	mov    %edi,%eax
  8029db:	d3 e8                	shr    %cl,%eax
  8029dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029e9:	09 c1                	or     %eax,%ecx
  8029eb:	89 d8                	mov    %ebx,%eax
  8029ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029f1:	89 e9                	mov    %ebp,%ecx
  8029f3:	d3 e7                	shl    %cl,%edi
  8029f5:	89 d1                	mov    %edx,%ecx
  8029f7:	d3 e8                	shr    %cl,%eax
  8029f9:	89 e9                	mov    %ebp,%ecx
  8029fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029ff:	d3 e3                	shl    %cl,%ebx
  802a01:	89 c7                	mov    %eax,%edi
  802a03:	89 d1                	mov    %edx,%ecx
  802a05:	89 f0                	mov    %esi,%eax
  802a07:	d3 e8                	shr    %cl,%eax
  802a09:	89 e9                	mov    %ebp,%ecx
  802a0b:	89 fa                	mov    %edi,%edx
  802a0d:	d3 e6                	shl    %cl,%esi
  802a0f:	09 d8                	or     %ebx,%eax
  802a11:	f7 74 24 08          	divl   0x8(%esp)
  802a15:	89 d1                	mov    %edx,%ecx
  802a17:	89 f3                	mov    %esi,%ebx
  802a19:	f7 64 24 0c          	mull   0xc(%esp)
  802a1d:	89 c6                	mov    %eax,%esi
  802a1f:	89 d7                	mov    %edx,%edi
  802a21:	39 d1                	cmp    %edx,%ecx
  802a23:	72 06                	jb     802a2b <__umoddi3+0xfb>
  802a25:	75 10                	jne    802a37 <__umoddi3+0x107>
  802a27:	39 c3                	cmp    %eax,%ebx
  802a29:	73 0c                	jae    802a37 <__umoddi3+0x107>
  802a2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a33:	89 d7                	mov    %edx,%edi
  802a35:	89 c6                	mov    %eax,%esi
  802a37:	89 ca                	mov    %ecx,%edx
  802a39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a3e:	29 f3                	sub    %esi,%ebx
  802a40:	19 fa                	sbb    %edi,%edx
  802a42:	89 d0                	mov    %edx,%eax
  802a44:	d3 e0                	shl    %cl,%eax
  802a46:	89 e9                	mov    %ebp,%ecx
  802a48:	d3 eb                	shr    %cl,%ebx
  802a4a:	d3 ea                	shr    %cl,%edx
  802a4c:	09 d8                	or     %ebx,%eax
  802a4e:	83 c4 1c             	add    $0x1c,%esp
  802a51:	5b                   	pop    %ebx
  802a52:	5e                   	pop    %esi
  802a53:	5f                   	pop    %edi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    
  802a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a5d:	8d 76 00             	lea    0x0(%esi),%esi
  802a60:	89 da                	mov    %ebx,%edx
  802a62:	29 fe                	sub    %edi,%esi
  802a64:	19 c2                	sbb    %eax,%edx
  802a66:	89 f1                	mov    %esi,%ecx
  802a68:	89 c8                	mov    %ecx,%eax
  802a6a:	e9 4b ff ff ff       	jmp    8029ba <__umoddi3+0x8a>
