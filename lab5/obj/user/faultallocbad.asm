
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 40 12 80 00       	push   $0x801240
  800045:	e8 a1 01 00 00       	call   8001eb <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 8d 0c 00 00       	call   800ceb <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 8c 12 80 00       	push   $0x80128c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 33 08 00 00       	call   8008a6 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 60 12 80 00       	push   $0x801260
  800085:	6a 0f                	push   $0xf
  800087:	68 4a 12 80 00       	push   $0x80124a
  80008c:	e8 7f 00 00 00       	call   800110 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 bd 0e 00 00       	call   800f5e <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 7f 0b 00 00       	call   800c2f <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 e8 0b 00 00       	call   800cad <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000cd:	c1 e0 04             	shl    $0x4,%eax
  8000d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d5:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000da:	85 db                	test   %ebx,%ebx
  8000dc:	7e 07                	jle    8000e5 <libmain+0x30>
		binaryname = argv[0];
  8000de:	8b 06                	mov    (%esi),%eax
  8000e0:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000e5:	83 ec 08             	sub    $0x8,%esp
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	e8 a2 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000ef:	e8 0a 00 00 00       	call   8000fe <exit>
}
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5d                   	pop    %ebp
  8000fd:	c3                   	ret    

008000fe <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800104:	6a 00                	push   $0x0
  800106:	e8 61 0b 00 00       	call   800c6c <sys_env_destroy>
}
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	c9                   	leave  
  80010f:	c3                   	ret    

00800110 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800115:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800118:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80011e:	e8 8a 0b 00 00       	call   800cad <sys_getenvid>
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	ff 75 0c             	pushl  0xc(%ebp)
  800129:	ff 75 08             	pushl  0x8(%ebp)
  80012c:	56                   	push   %esi
  80012d:	50                   	push   %eax
  80012e:	68 b8 12 80 00       	push   $0x8012b8
  800133:	e8 b3 00 00 00       	call   8001eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800138:	83 c4 18             	add    $0x18,%esp
  80013b:	53                   	push   %ebx
  80013c:	ff 75 10             	pushl  0x10(%ebp)
  80013f:	e8 56 00 00 00       	call   80019a <vcprintf>
	cprintf("\n");
  800144:	c7 04 24 a1 16 80 00 	movl   $0x8016a1,(%esp)
  80014b:	e8 9b 00 00 00       	call   8001eb <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800153:	cc                   	int3   
  800154:	eb fd                	jmp    800153 <_panic+0x43>

00800156 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	53                   	push   %ebx
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800160:	8b 13                	mov    (%ebx),%edx
  800162:	8d 42 01             	lea    0x1(%edx),%eax
  800165:	89 03                	mov    %eax,(%ebx)
  800167:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800173:	74 09                	je     80017e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800175:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	68 ff 00 00 00       	push   $0xff
  800186:	8d 43 08             	lea    0x8(%ebx),%eax
  800189:	50                   	push   %eax
  80018a:	e8 a0 0a 00 00       	call   800c2f <sys_cputs>
		b->idx = 0;
  80018f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	eb db                	jmp    800175 <putch+0x1f>

0080019a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001aa:	00 00 00 
	b.cnt = 0;
  8001ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c3:	50                   	push   %eax
  8001c4:	68 56 01 80 00       	push   $0x800156
  8001c9:	e8 4a 01 00 00       	call   800318 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ce:	83 c4 08             	add    $0x8,%esp
  8001d1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	e8 4c 0a 00 00       	call   800c2f <sys_cputs>

	return b.cnt;
}
  8001e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f4:	50                   	push   %eax
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	e8 9d ff ff ff       	call   80019a <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	57                   	push   %edi
  800203:	56                   	push   %esi
  800204:	53                   	push   %ebx
  800205:	83 ec 1c             	sub    $0x1c,%esp
  800208:	89 c6                	mov    %eax,%esi
  80020a:	89 d7                	mov    %edx,%edi
  80020c:	8b 45 08             	mov    0x8(%ebp),%eax
  80020f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800212:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800215:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800218:	8b 45 10             	mov    0x10(%ebp),%eax
  80021b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80021e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800222:	74 2c                	je     800250 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800224:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800227:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80022e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800231:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800234:	39 c2                	cmp    %eax,%edx
  800236:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800239:	73 43                	jae    80027e <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80023b:	83 eb 01             	sub    $0x1,%ebx
  80023e:	85 db                	test   %ebx,%ebx
  800240:	7e 6c                	jle    8002ae <printnum+0xaf>
			putch(padc, putdat);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	57                   	push   %edi
  800246:	ff 75 18             	pushl  0x18(%ebp)
  800249:	ff d6                	call   *%esi
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	eb eb                	jmp    80023b <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 20                	push   $0x20
  800255:	6a 00                	push   $0x0
  800257:	50                   	push   %eax
  800258:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025b:	ff 75 e0             	pushl  -0x20(%ebp)
  80025e:	89 fa                	mov    %edi,%edx
  800260:	89 f0                	mov    %esi,%eax
  800262:	e8 98 ff ff ff       	call   8001ff <printnum>
		while (--width > 0)
  800267:	83 c4 20             	add    $0x20,%esp
  80026a:	83 eb 01             	sub    $0x1,%ebx
  80026d:	85 db                	test   %ebx,%ebx
  80026f:	7e 65                	jle    8002d6 <printnum+0xd7>
			putch(padc, putdat);
  800271:	83 ec 08             	sub    $0x8,%esp
  800274:	57                   	push   %edi
  800275:	6a 20                	push   $0x20
  800277:	ff d6                	call   *%esi
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	eb ec                	jmp    80026a <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 18             	pushl  0x18(%ebp)
  800284:	83 eb 01             	sub    $0x1,%ebx
  800287:	53                   	push   %ebx
  800288:	50                   	push   %eax
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	ff 75 dc             	pushl  -0x24(%ebp)
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	ff 75 e4             	pushl  -0x1c(%ebp)
  800295:	ff 75 e0             	pushl  -0x20(%ebp)
  800298:	e8 53 0d 00 00       	call   800ff0 <__udivdi3>
  80029d:	83 c4 18             	add    $0x18,%esp
  8002a0:	52                   	push   %edx
  8002a1:	50                   	push   %eax
  8002a2:	89 fa                	mov    %edi,%edx
  8002a4:	89 f0                	mov    %esi,%eax
  8002a6:	e8 54 ff ff ff       	call   8001ff <printnum>
  8002ab:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	57                   	push   %edi
  8002b2:	83 ec 04             	sub    $0x4,%esp
  8002b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c1:	e8 3a 0e 00 00       	call   801100 <__umoddi3>
  8002c6:	83 c4 14             	add    $0x14,%esp
  8002c9:	0f be 80 db 12 80 00 	movsbl 0x8012db(%eax),%eax
  8002d0:	50                   	push   %eax
  8002d1:	ff d6                	call   *%esi
  8002d3:	83 c4 10             	add    $0x10,%esp
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    

008002de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e8:	8b 10                	mov    (%eax),%edx
  8002ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ed:	73 0a                	jae    8002f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f2:	89 08                	mov    %ecx,(%eax)
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	88 02                	mov    %al,(%edx)
}
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <printfmt>:
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800301:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800304:	50                   	push   %eax
  800305:	ff 75 10             	pushl  0x10(%ebp)
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	e8 05 00 00 00       	call   800318 <vprintfmt>
}
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <vprintfmt>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	57                   	push   %edi
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 3c             	sub    $0x3c,%esp
  800321:	8b 75 08             	mov    0x8(%ebp),%esi
  800324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800327:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032a:	e9 b4 03 00 00       	jmp    8006e3 <vprintfmt+0x3cb>
		padc = ' ';
  80032f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800333:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80033a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800341:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800348:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80034f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800354:	8d 47 01             	lea    0x1(%edi),%eax
  800357:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035a:	0f b6 17             	movzbl (%edi),%edx
  80035d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800360:	3c 55                	cmp    $0x55,%al
  800362:	0f 87 c8 04 00 00    	ja     800830 <vprintfmt+0x518>
  800368:	0f b6 c0             	movzbl %al,%eax
  80036b:	ff 24 85 c0 14 80 00 	jmp    *0x8014c0(,%eax,4)
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800375:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80037c:	eb d6                	jmp    800354 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80037e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800381:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800385:	eb cd                	jmp    800354 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800387:	0f b6 d2             	movzbl %dl,%edx
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80038d:	b8 00 00 00 00       	mov    $0x0,%eax
  800392:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800395:	eb 0c                	jmp    8003a3 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80039a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80039e:	eb b4                	jmp    800354 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8003a0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003aa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ad:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b0:	83 f9 09             	cmp    $0x9,%ecx
  8003b3:	76 eb                	jbe    8003a0 <vprintfmt+0x88>
  8003b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bb:	eb 14                	jmp    8003d1 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8003bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	8d 40 04             	lea    0x4(%eax),%eax
  8003cb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d5:	0f 89 79 ff ff ff    	jns    800354 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8003db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e8:	e9 67 ff ff ff       	jmp    800354 <vprintfmt+0x3c>
  8003ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f0:	85 c0                	test   %eax,%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f7:	0f 49 d0             	cmovns %eax,%edx
  8003fa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800400:	e9 4f ff ff ff       	jmp    800354 <vprintfmt+0x3c>
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800408:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80040f:	e9 40 ff ff ff       	jmp    800354 <vprintfmt+0x3c>
			lflag++;
  800414:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041a:	e9 35 ff ff ff       	jmp    800354 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80041f:	8b 45 14             	mov    0x14(%ebp),%eax
  800422:	8d 78 04             	lea    0x4(%eax),%edi
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	53                   	push   %ebx
  800429:	ff 30                	pushl  (%eax)
  80042b:	ff d6                	call   *%esi
			break;
  80042d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800430:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800433:	e9 a8 02 00 00       	jmp    8006e0 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 78 04             	lea    0x4(%eax),%edi
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	99                   	cltd   
  800441:	31 d0                	xor    %edx,%eax
  800443:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800445:	83 f8 0f             	cmp    $0xf,%eax
  800448:	7f 23                	jg     80046d <vprintfmt+0x155>
  80044a:	8b 14 85 20 16 80 00 	mov    0x801620(,%eax,4),%edx
  800451:	85 d2                	test   %edx,%edx
  800453:	74 18                	je     80046d <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800455:	52                   	push   %edx
  800456:	68 fc 12 80 00       	push   $0x8012fc
  80045b:	53                   	push   %ebx
  80045c:	56                   	push   %esi
  80045d:	e8 99 fe ff ff       	call   8002fb <printfmt>
  800462:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
  800468:	e9 73 02 00 00       	jmp    8006e0 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80046d:	50                   	push   %eax
  80046e:	68 f3 12 80 00       	push   $0x8012f3
  800473:	53                   	push   %ebx
  800474:	56                   	push   %esi
  800475:	e8 81 fe ff ff       	call   8002fb <printfmt>
  80047a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800480:	e9 5b 02 00 00       	jmp    8006e0 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	83 c0 04             	add    $0x4,%eax
  80048b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800493:	85 d2                	test   %edx,%edx
  800495:	b8 ec 12 80 00       	mov    $0x8012ec,%eax
  80049a:	0f 45 c2             	cmovne %edx,%eax
  80049d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a4:	7e 06                	jle    8004ac <vprintfmt+0x194>
  8004a6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004aa:	75 0d                	jne    8004b9 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004af:	89 c7                	mov    %eax,%edi
  8004b1:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b7:	eb 53                	jmp    80050c <vprintfmt+0x1f4>
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bf:	50                   	push   %eax
  8004c0:	e8 13 04 00 00       	call   8008d8 <strnlen>
  8004c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c8:	29 c1                	sub    %eax,%ecx
  8004ca:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004d2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d9:	eb 0f                	jmp    8004ea <vprintfmt+0x1d2>
					putch(padc, putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	53                   	push   %ebx
  8004df:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e4:	83 ef 01             	sub    $0x1,%edi
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	85 ff                	test   %edi,%edi
  8004ec:	7f ed                	jg     8004db <vprintfmt+0x1c3>
  8004ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f1:	85 d2                	test   %edx,%edx
  8004f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f8:	0f 49 c2             	cmovns %edx,%eax
  8004fb:	29 c2                	sub    %eax,%edx
  8004fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800500:	eb aa                	jmp    8004ac <vprintfmt+0x194>
					putch(ch, putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	52                   	push   %edx
  800507:	ff d6                	call   *%esi
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800511:	83 c7 01             	add    $0x1,%edi
  800514:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800518:	0f be d0             	movsbl %al,%edx
  80051b:	85 d2                	test   %edx,%edx
  80051d:	74 4b                	je     80056a <vprintfmt+0x252>
  80051f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800523:	78 06                	js     80052b <vprintfmt+0x213>
  800525:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800529:	78 1e                	js     800549 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80052b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80052f:	74 d1                	je     800502 <vprintfmt+0x1ea>
  800531:	0f be c0             	movsbl %al,%eax
  800534:	83 e8 20             	sub    $0x20,%eax
  800537:	83 f8 5e             	cmp    $0x5e,%eax
  80053a:	76 c6                	jbe    800502 <vprintfmt+0x1ea>
					putch('?', putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	6a 3f                	push   $0x3f
  800542:	ff d6                	call   *%esi
  800544:	83 c4 10             	add    $0x10,%esp
  800547:	eb c3                	jmp    80050c <vprintfmt+0x1f4>
  800549:	89 cf                	mov    %ecx,%edi
  80054b:	eb 0e                	jmp    80055b <vprintfmt+0x243>
				putch(' ', putdat);
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	53                   	push   %ebx
  800551:	6a 20                	push   $0x20
  800553:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800555:	83 ef 01             	sub    $0x1,%edi
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	85 ff                	test   %edi,%edi
  80055d:	7f ee                	jg     80054d <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80055f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800562:	89 45 14             	mov    %eax,0x14(%ebp)
  800565:	e9 76 01 00 00       	jmp    8006e0 <vprintfmt+0x3c8>
  80056a:	89 cf                	mov    %ecx,%edi
  80056c:	eb ed                	jmp    80055b <vprintfmt+0x243>
	if (lflag >= 2)
  80056e:	83 f9 01             	cmp    $0x1,%ecx
  800571:	7f 1f                	jg     800592 <vprintfmt+0x27a>
	else if (lflag)
  800573:	85 c9                	test   %ecx,%ecx
  800575:	74 6a                	je     8005e1 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057f:	89 c1                	mov    %eax,%ecx
  800581:	c1 f9 1f             	sar    $0x1f,%ecx
  800584:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	eb 17                	jmp    8005a9 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8b 50 04             	mov    0x4(%eax),%edx
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 40 08             	lea    0x8(%eax),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005ac:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005b1:	85 d2                	test   %edx,%edx
  8005b3:	0f 89 f8 00 00 00    	jns    8006b1 <vprintfmt+0x399>
				putch('-', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	53                   	push   %ebx
  8005bd:	6a 2d                	push   $0x2d
  8005bf:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005c7:	f7 d8                	neg    %eax
  8005c9:	83 d2 00             	adc    $0x0,%edx
  8005cc:	f7 da                	neg    %edx
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005dc:	e9 e1 00 00 00       	jmp    8006c2 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e9:	99                   	cltd   
  8005ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 40 04             	lea    0x4(%eax),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f6:	eb b1                	jmp    8005a9 <vprintfmt+0x291>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7f 27                	jg     800624 <vprintfmt+0x30c>
	else if (lflag)
  8005fd:	85 c9                	test   %ecx,%ecx
  8005ff:	74 41                	je     800642 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	ba 00 00 00 00       	mov    $0x0,%edx
  80060b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8d 40 04             	lea    0x4(%eax),%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80061f:	e9 8d 00 00 00       	jmp    8006b1 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8b 50 04             	mov    0x4(%eax),%edx
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 40 08             	lea    0x8(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800640:	eb 6f                	jmp    8006b1 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
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
  800660:	eb 4f                	jmp    8006b1 <vprintfmt+0x399>
	if (lflag >= 2)
  800662:	83 f9 01             	cmp    $0x1,%ecx
  800665:	7f 23                	jg     80068a <vprintfmt+0x372>
	else if (lflag)
  800667:	85 c9                	test   %ecx,%ecx
  800669:	0f 84 98 00 00 00    	je     800707 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	ba 00 00 00 00       	mov    $0x0,%edx
  800679:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 04             	lea    0x4(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
  800688:	eb 17                	jmp    8006a1 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 50 04             	mov    0x4(%eax),%edx
  800690:	8b 00                	mov    (%eax),%eax
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800695:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8d 40 08             	lea    0x8(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	6a 30                	push   $0x30
  8006a7:	ff d6                	call   *%esi
			goto number;
  8006a9:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006ac:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8006b1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006b5:	74 0b                	je     8006c2 <vprintfmt+0x3aa>
				putch('+', putdat);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	53                   	push   %ebx
  8006bb:	6a 2b                	push   $0x2b
  8006bd:	ff d6                	call   *%esi
  8006bf:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006c2:	83 ec 0c             	sub    $0xc,%esp
  8006c5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006c9:	50                   	push   %eax
  8006ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8006cd:	57                   	push   %edi
  8006ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8006d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8006d4:	89 da                	mov    %ebx,%edx
  8006d6:	89 f0                	mov    %esi,%eax
  8006d8:	e8 22 fb ff ff       	call   8001ff <printnum>
			break;
  8006dd:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8006e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e3:	83 c7 01             	add    $0x1,%edi
  8006e6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ea:	83 f8 25             	cmp    $0x25,%eax
  8006ed:	0f 84 3c fc ff ff    	je     80032f <vprintfmt+0x17>
			if (ch == '\0')
  8006f3:	85 c0                	test   %eax,%eax
  8006f5:	0f 84 55 01 00 00    	je     800850 <vprintfmt+0x538>
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	53                   	push   %ebx
  8006ff:	50                   	push   %eax
  800700:	ff d6                	call   *%esi
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	eb dc                	jmp    8006e3 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	ba 00 00 00 00       	mov    $0x0,%edx
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 40 04             	lea    0x4(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
  800720:	e9 7c ff ff ff       	jmp    8006a1 <vprintfmt+0x389>
			putch('0', putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	53                   	push   %ebx
  800729:	6a 30                	push   $0x30
  80072b:	ff d6                	call   *%esi
			putch('x', putdat);
  80072d:	83 c4 08             	add    $0x8,%esp
  800730:	53                   	push   %ebx
  800731:	6a 78                	push   $0x78
  800733:	ff d6                	call   *%esi
			num = (unsigned long long)
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	ba 00 00 00 00       	mov    $0x0,%edx
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800745:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8d 40 04             	lea    0x4(%eax),%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800751:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800756:	e9 56 ff ff ff       	jmp    8006b1 <vprintfmt+0x399>
	if (lflag >= 2)
  80075b:	83 f9 01             	cmp    $0x1,%ecx
  80075e:	7f 27                	jg     800787 <vprintfmt+0x46f>
	else if (lflag)
  800760:	85 c9                	test   %ecx,%ecx
  800762:	74 44                	je     8007a8 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	ba 00 00 00 00       	mov    $0x0,%edx
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800771:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 40 04             	lea    0x4(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077d:	bf 10 00 00 00       	mov    $0x10,%edi
  800782:	e9 2a ff ff ff       	jmp    8006b1 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 50 04             	mov    0x4(%eax),%edx
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800792:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8d 40 08             	lea    0x8(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079e:	bf 10 00 00 00       	mov    $0x10,%edi
  8007a3:	e9 09 ff ff ff       	jmp    8006b1 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8d 40 04             	lea    0x4(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c1:	bf 10 00 00 00       	mov    $0x10,%edi
  8007c6:	e9 e6 fe ff ff       	jmp    8006b1 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8d 78 04             	lea    0x4(%eax),%edi
  8007d1:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	74 2d                	je     800804 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8007d7:	0f b6 13             	movzbl (%ebx),%edx
  8007da:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007dc:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8007df:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007e2:	0f 8e f8 fe ff ff    	jle    8006e0 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007e8:	68 4c 14 80 00       	push   $0x80144c
  8007ed:	68 fc 12 80 00       	push   $0x8012fc
  8007f2:	53                   	push   %ebx
  8007f3:	56                   	push   %esi
  8007f4:	e8 02 fb ff ff       	call   8002fb <printfmt>
  8007f9:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007fc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007ff:	e9 dc fe ff ff       	jmp    8006e0 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800804:	68 14 14 80 00       	push   $0x801414
  800809:	68 fc 12 80 00       	push   $0x8012fc
  80080e:	53                   	push   %ebx
  80080f:	56                   	push   %esi
  800810:	e8 e6 fa ff ff       	call   8002fb <printfmt>
  800815:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800818:	89 7d 14             	mov    %edi,0x14(%ebp)
  80081b:	e9 c0 fe ff ff       	jmp    8006e0 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 25                	push   $0x25
  800826:	ff d6                	call   *%esi
			break;
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	e9 b0 fe ff ff       	jmp    8006e0 <vprintfmt+0x3c8>
			putch('%', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	53                   	push   %ebx
  800834:	6a 25                	push   $0x25
  800836:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	89 f8                	mov    %edi,%eax
  80083d:	eb 03                	jmp    800842 <vprintfmt+0x52a>
  80083f:	83 e8 01             	sub    $0x1,%eax
  800842:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800846:	75 f7                	jne    80083f <vprintfmt+0x527>
  800848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084b:	e9 90 fe ff ff       	jmp    8006e0 <vprintfmt+0x3c8>
}
  800850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800853:	5b                   	pop    %ebx
  800854:	5e                   	pop    %esi
  800855:	5f                   	pop    %edi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 18             	sub    $0x18,%esp
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800864:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800867:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800875:	85 c0                	test   %eax,%eax
  800877:	74 26                	je     80089f <vsnprintf+0x47>
  800879:	85 d2                	test   %edx,%edx
  80087b:	7e 22                	jle    80089f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087d:	ff 75 14             	pushl  0x14(%ebp)
  800880:	ff 75 10             	pushl  0x10(%ebp)
  800883:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800886:	50                   	push   %eax
  800887:	68 de 02 80 00       	push   $0x8002de
  80088c:	e8 87 fa ff ff       	call   800318 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800894:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089a:	83 c4 10             	add    $0x10,%esp
}
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    
		return -E_INVAL;
  80089f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a4:	eb f7                	jmp    80089d <vsnprintf+0x45>

008008a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ac:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008af:	50                   	push   %eax
  8008b0:	ff 75 10             	pushl  0x10(%ebp)
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	ff 75 08             	pushl  0x8(%ebp)
  8008b9:	e8 9a ff ff ff       	call   800858 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008cf:	74 05                	je     8008d6 <strlen+0x16>
		n++;
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	eb f5                	jmp    8008cb <strlen+0xb>
	return n;
}
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e6:	39 c2                	cmp    %eax,%edx
  8008e8:	74 0d                	je     8008f7 <strnlen+0x1f>
  8008ea:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ee:	74 05                	je     8008f5 <strnlen+0x1d>
		n++;
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	eb f1                	jmp    8008e6 <strnlen+0xe>
  8008f5:	89 d0                	mov    %edx,%eax
	return n;
}
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800903:	ba 00 00 00 00       	mov    $0x0,%edx
  800908:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80090c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80090f:	83 c2 01             	add    $0x1,%edx
  800912:	84 c9                	test   %cl,%cl
  800914:	75 f2                	jne    800908 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800916:	5b                   	pop    %ebx
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	53                   	push   %ebx
  80091d:	83 ec 10             	sub    $0x10,%esp
  800920:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800923:	53                   	push   %ebx
  800924:	e8 97 ff ff ff       	call   8008c0 <strlen>
  800929:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	01 d8                	add    %ebx,%eax
  800931:	50                   	push   %eax
  800932:	e8 c2 ff ff ff       	call   8008f9 <strcpy>
	return dst;
}
  800937:	89 d8                	mov    %ebx,%eax
  800939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    

0080093e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	56                   	push   %esi
  800942:	53                   	push   %ebx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800949:	89 c6                	mov    %eax,%esi
  80094b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094e:	89 c2                	mov    %eax,%edx
  800950:	39 f2                	cmp    %esi,%edx
  800952:	74 11                	je     800965 <strncpy+0x27>
		*dst++ = *src;
  800954:	83 c2 01             	add    $0x1,%edx
  800957:	0f b6 19             	movzbl (%ecx),%ebx
  80095a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095d:	80 fb 01             	cmp    $0x1,%bl
  800960:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800963:	eb eb                	jmp    800950 <strncpy+0x12>
	}
	return ret;
}
  800965:	5b                   	pop    %ebx
  800966:	5e                   	pop    %esi
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	56                   	push   %esi
  80096d:	53                   	push   %ebx
  80096e:	8b 75 08             	mov    0x8(%ebp),%esi
  800971:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800974:	8b 55 10             	mov    0x10(%ebp),%edx
  800977:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800979:	85 d2                	test   %edx,%edx
  80097b:	74 21                	je     80099e <strlcpy+0x35>
  80097d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800981:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800983:	39 c2                	cmp    %eax,%edx
  800985:	74 14                	je     80099b <strlcpy+0x32>
  800987:	0f b6 19             	movzbl (%ecx),%ebx
  80098a:	84 db                	test   %bl,%bl
  80098c:	74 0b                	je     800999 <strlcpy+0x30>
			*dst++ = *src++;
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	88 5a ff             	mov    %bl,-0x1(%edx)
  800997:	eb ea                	jmp    800983 <strlcpy+0x1a>
  800999:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80099b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099e:	29 f0                	sub    %esi,%eax
}
  8009a0:	5b                   	pop    %ebx
  8009a1:	5e                   	pop    %esi
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 0c                	je     8009c0 <strcmp+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	75 08                	jne    8009c0 <strcmp+0x1c>
		p++, q++;
  8009b8:	83 c1 01             	add    $0x1,%ecx
  8009bb:	83 c2 01             	add    $0x1,%edx
  8009be:	eb ed                	jmp    8009ad <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c0:	0f b6 c0             	movzbl %al,%eax
  8009c3:	0f b6 12             	movzbl (%edx),%edx
  8009c6:	29 d0                	sub    %edx,%eax
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d4:	89 c3                	mov    %eax,%ebx
  8009d6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d9:	eb 06                	jmp    8009e1 <strncmp+0x17>
		n--, p++, q++;
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e1:	39 d8                	cmp    %ebx,%eax
  8009e3:	74 16                	je     8009fb <strncmp+0x31>
  8009e5:	0f b6 08             	movzbl (%eax),%ecx
  8009e8:	84 c9                	test   %cl,%cl
  8009ea:	74 04                	je     8009f0 <strncmp+0x26>
  8009ec:	3a 0a                	cmp    (%edx),%cl
  8009ee:	74 eb                	je     8009db <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f0:	0f b6 00             	movzbl (%eax),%eax
  8009f3:	0f b6 12             	movzbl (%edx),%edx
  8009f6:	29 d0                	sub    %edx,%eax
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    
		return 0;
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800a00:	eb f6                	jmp    8009f8 <strncmp+0x2e>

00800a02 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0c:	0f b6 10             	movzbl (%eax),%edx
  800a0f:	84 d2                	test   %dl,%dl
  800a11:	74 09                	je     800a1c <strchr+0x1a>
		if (*s == c)
  800a13:	38 ca                	cmp    %cl,%dl
  800a15:	74 0a                	je     800a21 <strchr+0x1f>
	for (; *s; s++)
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	eb f0                	jmp    800a0c <strchr+0xa>
			return (char *) s;
	return 0;
  800a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a30:	38 ca                	cmp    %cl,%dl
  800a32:	74 09                	je     800a3d <strfind+0x1a>
  800a34:	84 d2                	test   %dl,%dl
  800a36:	74 05                	je     800a3d <strfind+0x1a>
	for (; *s; s++)
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	eb f0                	jmp    800a2d <strfind+0xa>
			break;
	return (char *) s;
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	57                   	push   %edi
  800a43:	56                   	push   %esi
  800a44:	53                   	push   %ebx
  800a45:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4b:	85 c9                	test   %ecx,%ecx
  800a4d:	74 31                	je     800a80 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4f:	89 f8                	mov    %edi,%eax
  800a51:	09 c8                	or     %ecx,%eax
  800a53:	a8 03                	test   $0x3,%al
  800a55:	75 23                	jne    800a7a <memset+0x3b>
		c &= 0xFF;
  800a57:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5b:	89 d3                	mov    %edx,%ebx
  800a5d:	c1 e3 08             	shl    $0x8,%ebx
  800a60:	89 d0                	mov    %edx,%eax
  800a62:	c1 e0 18             	shl    $0x18,%eax
  800a65:	89 d6                	mov    %edx,%esi
  800a67:	c1 e6 10             	shl    $0x10,%esi
  800a6a:	09 f0                	or     %esi,%eax
  800a6c:	09 c2                	or     %eax,%edx
  800a6e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a70:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a73:	89 d0                	mov    %edx,%eax
  800a75:	fc                   	cld    
  800a76:	f3 ab                	rep stos %eax,%es:(%edi)
  800a78:	eb 06                	jmp    800a80 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	fc                   	cld    
  800a7e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a80:	89 f8                	mov    %edi,%eax
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5f                   	pop    %edi
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a95:	39 c6                	cmp    %eax,%esi
  800a97:	73 32                	jae    800acb <memmove+0x44>
  800a99:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9c:	39 c2                	cmp    %eax,%edx
  800a9e:	76 2b                	jbe    800acb <memmove+0x44>
		s += n;
		d += n;
  800aa0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa3:	89 fe                	mov    %edi,%esi
  800aa5:	09 ce                	or     %ecx,%esi
  800aa7:	09 d6                	or     %edx,%esi
  800aa9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaf:	75 0e                	jne    800abf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1a                	jmp    800ae5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acb:	89 c2                	mov    %eax,%edx
  800acd:	09 ca                	or     %ecx,%edx
  800acf:	09 f2                	or     %esi,%edx
  800ad1:	f6 c2 03             	test   $0x3,%dl
  800ad4:	75 0a                	jne    800ae0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	fc                   	cld    
  800adc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ade:	eb 05                	jmp    800ae5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae0:	89 c7                	mov    %eax,%edi
  800ae2:	fc                   	cld    
  800ae3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae5:	5e                   	pop    %esi
  800ae6:	5f                   	pop    %edi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aef:	ff 75 10             	pushl  0x10(%ebp)
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	ff 75 08             	pushl  0x8(%ebp)
  800af8:	e8 8a ff ff ff       	call   800a87 <memmove>
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	56                   	push   %esi
  800b03:	53                   	push   %ebx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0a:	89 c6                	mov    %eax,%esi
  800b0c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0f:	39 f0                	cmp    %esi,%eax
  800b11:	74 1c                	je     800b2f <memcmp+0x30>
		if (*s1 != *s2)
  800b13:	0f b6 08             	movzbl (%eax),%ecx
  800b16:	0f b6 1a             	movzbl (%edx),%ebx
  800b19:	38 d9                	cmp    %bl,%cl
  800b1b:	75 08                	jne    800b25 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b1d:	83 c0 01             	add    $0x1,%eax
  800b20:	83 c2 01             	add    $0x1,%edx
  800b23:	eb ea                	jmp    800b0f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b25:	0f b6 c1             	movzbl %cl,%eax
  800b28:	0f b6 db             	movzbl %bl,%ebx
  800b2b:	29 d8                	sub    %ebx,%eax
  800b2d:	eb 05                	jmp    800b34 <memcmp+0x35>
	}

	return 0;
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b41:	89 c2                	mov    %eax,%edx
  800b43:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b46:	39 d0                	cmp    %edx,%eax
  800b48:	73 09                	jae    800b53 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4a:	38 08                	cmp    %cl,(%eax)
  800b4c:	74 05                	je     800b53 <memfind+0x1b>
	for (; s < ends; s++)
  800b4e:	83 c0 01             	add    $0x1,%eax
  800b51:	eb f3                	jmp    800b46 <memfind+0xe>
			break;
	return (void *) s;
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	57                   	push   %edi
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
  800b5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b61:	eb 03                	jmp    800b66 <strtol+0x11>
		s++;
  800b63:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b66:	0f b6 01             	movzbl (%ecx),%eax
  800b69:	3c 20                	cmp    $0x20,%al
  800b6b:	74 f6                	je     800b63 <strtol+0xe>
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	74 f2                	je     800b63 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b71:	3c 2b                	cmp    $0x2b,%al
  800b73:	74 2a                	je     800b9f <strtol+0x4a>
	int neg = 0;
  800b75:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7a:	3c 2d                	cmp    $0x2d,%al
  800b7c:	74 2b                	je     800ba9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b84:	75 0f                	jne    800b95 <strtol+0x40>
  800b86:	80 39 30             	cmpb   $0x30,(%ecx)
  800b89:	74 28                	je     800bb3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8b:	85 db                	test   %ebx,%ebx
  800b8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b92:	0f 44 d8             	cmove  %eax,%ebx
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9d:	eb 50                	jmp    800bef <strtol+0x9a>
		s++;
  800b9f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba7:	eb d5                	jmp    800b7e <strtol+0x29>
		s++, neg = 1;
  800ba9:	83 c1 01             	add    $0x1,%ecx
  800bac:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb1:	eb cb                	jmp    800b7e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb7:	74 0e                	je     800bc7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bb9:	85 db                	test   %ebx,%ebx
  800bbb:	75 d8                	jne    800b95 <strtol+0x40>
		s++, base = 8;
  800bbd:	83 c1 01             	add    $0x1,%ecx
  800bc0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc5:	eb ce                	jmp    800b95 <strtol+0x40>
		s += 2, base = 16;
  800bc7:	83 c1 02             	add    $0x2,%ecx
  800bca:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bcf:	eb c4                	jmp    800b95 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd4:	89 f3                	mov    %esi,%ebx
  800bd6:	80 fb 19             	cmp    $0x19,%bl
  800bd9:	77 29                	ja     800c04 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bdb:	0f be d2             	movsbl %dl,%edx
  800bde:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be4:	7d 30                	jge    800c16 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be6:	83 c1 01             	add    $0x1,%ecx
  800be9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bed:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bef:	0f b6 11             	movzbl (%ecx),%edx
  800bf2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf5:	89 f3                	mov    %esi,%ebx
  800bf7:	80 fb 09             	cmp    $0x9,%bl
  800bfa:	77 d5                	ja     800bd1 <strtol+0x7c>
			dig = *s - '0';
  800bfc:	0f be d2             	movsbl %dl,%edx
  800bff:	83 ea 30             	sub    $0x30,%edx
  800c02:	eb dd                	jmp    800be1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c04:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c07:	89 f3                	mov    %esi,%ebx
  800c09:	80 fb 19             	cmp    $0x19,%bl
  800c0c:	77 08                	ja     800c16 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c0e:	0f be d2             	movsbl %dl,%edx
  800c11:	83 ea 37             	sub    $0x37,%edx
  800c14:	eb cb                	jmp    800be1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1a:	74 05                	je     800c21 <strtol+0xcc>
		*endptr = (char *) s;
  800c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c21:	89 c2                	mov    %eax,%edx
  800c23:	f7 da                	neg    %edx
  800c25:	85 ff                	test   %edi,%edi
  800c27:	0f 45 c2             	cmovne %edx,%eax
}
  800c2a:	5b                   	pop    %ebx
  800c2b:	5e                   	pop    %esi
  800c2c:	5f                   	pop    %edi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c40:	89 c3                	mov    %eax,%ebx
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	89 c6                	mov    %eax,%esi
  800c46:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	57                   	push   %edi
  800c51:	56                   	push   %esi
  800c52:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c53:	ba 00 00 00 00       	mov    $0x0,%edx
  800c58:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5d:	89 d1                	mov    %edx,%ecx
  800c5f:	89 d3                	mov    %edx,%ebx
  800c61:	89 d7                	mov    %edx,%edi
  800c63:	89 d6                	mov    %edx,%esi
  800c65:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c82:	89 cb                	mov    %ecx,%ebx
  800c84:	89 cf                	mov    %ecx,%edi
  800c86:	89 ce                	mov    %ecx,%esi
  800c88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	7f 08                	jg     800c96 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	50                   	push   %eax
  800c9a:	6a 03                	push   $0x3
  800c9c:	68 60 16 80 00       	push   $0x801660
  800ca1:	6a 33                	push   $0x33
  800ca3:	68 7d 16 80 00       	push   $0x80167d
  800ca8:	e8 63 f4 ff ff       	call   800110 <_panic>

00800cad <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb8:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbd:	89 d1                	mov    %edx,%ecx
  800cbf:	89 d3                	mov    %edx,%ebx
  800cc1:	89 d7                	mov    %edx,%edi
  800cc3:	89 d6                	mov    %edx,%esi
  800cc5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <sys_yield>:

void
sys_yield(void)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cdc:	89 d1                	mov    %edx,%ecx
  800cde:	89 d3                	mov    %edx,%ebx
  800ce0:	89 d7                	mov    %edx,%edi
  800ce2:	89 d6                	mov    %edx,%esi
  800ce4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf4:	be 00 00 00 00       	mov    $0x0,%esi
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cff:	b8 04 00 00 00       	mov    $0x4,%eax
  800d04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d07:	89 f7                	mov    %esi,%edi
  800d09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 04                	push   $0x4
  800d1d:	68 60 16 80 00       	push   $0x801660
  800d22:	6a 33                	push   $0x33
  800d24:	68 7d 16 80 00       	push   $0x80167d
  800d29:	e8 e2 f3 ff ff       	call   800110 <_panic>

00800d2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d48:	8b 75 18             	mov    0x18(%ebp),%esi
  800d4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	50                   	push   %eax
  800d5d:	6a 05                	push   $0x5
  800d5f:	68 60 16 80 00       	push   $0x801660
  800d64:	6a 33                	push   $0x33
  800d66:	68 7d 16 80 00       	push   $0x80167d
  800d6b:	e8 a0 f3 ff ff       	call   800110 <_panic>

00800d70 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 06 00 00 00       	mov    $0x6,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 06                	push   $0x6
  800da1:	68 60 16 80 00       	push   $0x801660
  800da6:	6a 33                	push   $0x33
  800da8:	68 7d 16 80 00       	push   $0x80167d
  800dad:	e8 5e f3 ff ff       	call   800110 <_panic>

00800db2 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc8:	89 cb                	mov    %ecx,%ebx
  800dca:	89 cf                	mov    %ecx,%edi
  800dcc:	89 ce                	mov    %ecx,%esi
  800dce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7f 08                	jg     800ddc <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
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
  800de0:	6a 0b                	push   $0xb
  800de2:	68 60 16 80 00       	push   $0x801660
  800de7:	6a 33                	push   $0x33
  800de9:	68 7d 16 80 00       	push   $0x80167d
  800dee:	e8 1d f3 ff ff       	call   800110 <_panic>

00800df3 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e07:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0c:	89 df                	mov    %ebx,%edi
  800e0e:	89 de                	mov    %ebx,%esi
  800e10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7f 08                	jg     800e1e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1e:	83 ec 0c             	sub    $0xc,%esp
  800e21:	50                   	push   %eax
  800e22:	6a 08                	push   $0x8
  800e24:	68 60 16 80 00       	push   $0x801660
  800e29:	6a 33                	push   $0x33
  800e2b:	68 7d 16 80 00       	push   $0x80167d
  800e30:	e8 db f2 ff ff       	call   800110 <_panic>

00800e35 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	57                   	push   %edi
  800e39:	56                   	push   %esi
  800e3a:	53                   	push   %ebx
  800e3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e43:	8b 55 08             	mov    0x8(%ebp),%edx
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4e:	89 df                	mov    %ebx,%edi
  800e50:	89 de                	mov    %ebx,%esi
  800e52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e54:	85 c0                	test   %eax,%eax
  800e56:	7f 08                	jg     800e60 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e60:	83 ec 0c             	sub    $0xc,%esp
  800e63:	50                   	push   %eax
  800e64:	6a 09                	push   $0x9
  800e66:	68 60 16 80 00       	push   $0x801660
  800e6b:	6a 33                	push   $0x33
  800e6d:	68 7d 16 80 00       	push   $0x80167d
  800e72:	e8 99 f2 ff ff       	call   800110 <_panic>

00800e77 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e90:	89 df                	mov    %ebx,%edi
  800e92:	89 de                	mov    %ebx,%esi
  800e94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e96:	85 c0                	test   %eax,%eax
  800e98:	7f 08                	jg     800ea2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	50                   	push   %eax
  800ea6:	6a 0a                	push   $0xa
  800ea8:	68 60 16 80 00       	push   $0x801660
  800ead:	6a 33                	push   $0x33
  800eaf:	68 7d 16 80 00       	push   $0x80167d
  800eb4:	e8 57 f2 ff ff       	call   800110 <_panic>

00800eb9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eca:	be 00 00 00 00       	mov    $0x0,%esi
  800ecf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
  800ee2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef2:	89 cb                	mov    %ecx,%ebx
  800ef4:	89 cf                	mov    %ecx,%edi
  800ef6:	89 ce                	mov    %ecx,%esi
  800ef8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efa:	85 c0                	test   %eax,%eax
  800efc:	7f 08                	jg     800f06 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f06:	83 ec 0c             	sub    $0xc,%esp
  800f09:	50                   	push   %eax
  800f0a:	6a 0e                	push   $0xe
  800f0c:	68 60 16 80 00       	push   $0x801660
  800f11:	6a 33                	push   $0x33
  800f13:	68 7d 16 80 00       	push   $0x80167d
  800f18:	e8 f3 f1 ff ff       	call   800110 <_panic>

00800f1d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f33:	89 df                	mov    %ebx,%edi
  800f35:	89 de                	mov    %ebx,%esi
  800f37:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5f                   	pop    %edi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f44:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	b8 10 00 00 00       	mov    $0x10,%eax
  800f51:	89 cb                	mov    %ecx,%ebx
  800f53:	89 cf                	mov    %ecx,%edi
  800f55:	89 ce                	mov    %ecx,%esi
  800f57:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f64:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800f6b:	74 0a                	je     800f77 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  800f77:	83 ec 04             	sub    $0x4,%esp
  800f7a:	6a 07                	push   $0x7
  800f7c:	68 00 f0 bf ee       	push   $0xeebff000
  800f81:	6a 00                	push   $0x0
  800f83:	e8 63 fd ff ff       	call   800ceb <sys_page_alloc>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	78 28                	js     800fb7 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	68 c9 0f 80 00       	push   $0x800fc9
  800f97:	6a 00                	push   $0x0
  800f99:	e8 d9 fe ff ff       	call   800e77 <sys_env_set_pgfault_upcall>
  800f9e:	83 c4 10             	add    $0x10,%esp
  800fa1:	85 c0                	test   %eax,%eax
  800fa3:	79 c8                	jns    800f6d <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  800fa5:	50                   	push   %eax
  800fa6:	68 b4 16 80 00       	push   $0x8016b4
  800fab:	6a 23                	push   $0x23
  800fad:	68 a3 16 80 00       	push   $0x8016a3
  800fb2:	e8 59 f1 ff ff       	call   800110 <_panic>
			panic("set_pgfault_handler %e\n",r);
  800fb7:	50                   	push   %eax
  800fb8:	68 8b 16 80 00       	push   $0x80168b
  800fbd:	6a 21                	push   $0x21
  800fbf:	68 a3 16 80 00       	push   $0x8016a3
  800fc4:	e8 47 f1 ff ff       	call   800110 <_panic>

00800fc9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800fc9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fca:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800fcf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fd1:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  800fd4:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  800fd8:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  800fdc:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800fdf:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  800fe1:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  800fe5:	83 c4 08             	add    $0x8,%esp
	popal
  800fe8:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800fe9:	83 c4 04             	add    $0x4,%esp
	popfl
  800fec:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800fed:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800fee:	c3                   	ret    
  800fef:	90                   	nop

00800ff0 <__udivdi3>:
  800ff0:	55                   	push   %ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 1c             	sub    $0x1c,%esp
  800ff7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800ffb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800fff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801003:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801007:	85 d2                	test   %edx,%edx
  801009:	75 4d                	jne    801058 <__udivdi3+0x68>
  80100b:	39 f3                	cmp    %esi,%ebx
  80100d:	76 19                	jbe    801028 <__udivdi3+0x38>
  80100f:	31 ff                	xor    %edi,%edi
  801011:	89 e8                	mov    %ebp,%eax
  801013:	89 f2                	mov    %esi,%edx
  801015:	f7 f3                	div    %ebx
  801017:	89 fa                	mov    %edi,%edx
  801019:	83 c4 1c             	add    $0x1c,%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    
  801021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801028:	89 d9                	mov    %ebx,%ecx
  80102a:	85 db                	test   %ebx,%ebx
  80102c:	75 0b                	jne    801039 <__udivdi3+0x49>
  80102e:	b8 01 00 00 00       	mov    $0x1,%eax
  801033:	31 d2                	xor    %edx,%edx
  801035:	f7 f3                	div    %ebx
  801037:	89 c1                	mov    %eax,%ecx
  801039:	31 d2                	xor    %edx,%edx
  80103b:	89 f0                	mov    %esi,%eax
  80103d:	f7 f1                	div    %ecx
  80103f:	89 c6                	mov    %eax,%esi
  801041:	89 e8                	mov    %ebp,%eax
  801043:	89 f7                	mov    %esi,%edi
  801045:	f7 f1                	div    %ecx
  801047:	89 fa                	mov    %edi,%edx
  801049:	83 c4 1c             	add    $0x1c,%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    
  801051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801058:	39 f2                	cmp    %esi,%edx
  80105a:	77 1c                	ja     801078 <__udivdi3+0x88>
  80105c:	0f bd fa             	bsr    %edx,%edi
  80105f:	83 f7 1f             	xor    $0x1f,%edi
  801062:	75 2c                	jne    801090 <__udivdi3+0xa0>
  801064:	39 f2                	cmp    %esi,%edx
  801066:	72 06                	jb     80106e <__udivdi3+0x7e>
  801068:	31 c0                	xor    %eax,%eax
  80106a:	39 eb                	cmp    %ebp,%ebx
  80106c:	77 a9                	ja     801017 <__udivdi3+0x27>
  80106e:	b8 01 00 00 00       	mov    $0x1,%eax
  801073:	eb a2                	jmp    801017 <__udivdi3+0x27>
  801075:	8d 76 00             	lea    0x0(%esi),%esi
  801078:	31 ff                	xor    %edi,%edi
  80107a:	31 c0                	xor    %eax,%eax
  80107c:	89 fa                	mov    %edi,%edx
  80107e:	83 c4 1c             	add    $0x1c,%esp
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    
  801086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80108d:	8d 76 00             	lea    0x0(%esi),%esi
  801090:	89 f9                	mov    %edi,%ecx
  801092:	b8 20 00 00 00       	mov    $0x20,%eax
  801097:	29 f8                	sub    %edi,%eax
  801099:	d3 e2                	shl    %cl,%edx
  80109b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80109f:	89 c1                	mov    %eax,%ecx
  8010a1:	89 da                	mov    %ebx,%edx
  8010a3:	d3 ea                	shr    %cl,%edx
  8010a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010a9:	09 d1                	or     %edx,%ecx
  8010ab:	89 f2                	mov    %esi,%edx
  8010ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010b1:	89 f9                	mov    %edi,%ecx
  8010b3:	d3 e3                	shl    %cl,%ebx
  8010b5:	89 c1                	mov    %eax,%ecx
  8010b7:	d3 ea                	shr    %cl,%edx
  8010b9:	89 f9                	mov    %edi,%ecx
  8010bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010bf:	89 eb                	mov    %ebp,%ebx
  8010c1:	d3 e6                	shl    %cl,%esi
  8010c3:	89 c1                	mov    %eax,%ecx
  8010c5:	d3 eb                	shr    %cl,%ebx
  8010c7:	09 de                	or     %ebx,%esi
  8010c9:	89 f0                	mov    %esi,%eax
  8010cb:	f7 74 24 08          	divl   0x8(%esp)
  8010cf:	89 d6                	mov    %edx,%esi
  8010d1:	89 c3                	mov    %eax,%ebx
  8010d3:	f7 64 24 0c          	mull   0xc(%esp)
  8010d7:	39 d6                	cmp    %edx,%esi
  8010d9:	72 15                	jb     8010f0 <__udivdi3+0x100>
  8010db:	89 f9                	mov    %edi,%ecx
  8010dd:	d3 e5                	shl    %cl,%ebp
  8010df:	39 c5                	cmp    %eax,%ebp
  8010e1:	73 04                	jae    8010e7 <__udivdi3+0xf7>
  8010e3:	39 d6                	cmp    %edx,%esi
  8010e5:	74 09                	je     8010f0 <__udivdi3+0x100>
  8010e7:	89 d8                	mov    %ebx,%eax
  8010e9:	31 ff                	xor    %edi,%edi
  8010eb:	e9 27 ff ff ff       	jmp    801017 <__udivdi3+0x27>
  8010f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010f3:	31 ff                	xor    %edi,%edi
  8010f5:	e9 1d ff ff ff       	jmp    801017 <__udivdi3+0x27>
  8010fa:	66 90                	xchg   %ax,%ax
  8010fc:	66 90                	xchg   %ax,%ax
  8010fe:	66 90                	xchg   %ax,%ax

00801100 <__umoddi3>:
  801100:	55                   	push   %ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 1c             	sub    $0x1c,%esp
  801107:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80110b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80110f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801113:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801117:	89 da                	mov    %ebx,%edx
  801119:	85 c0                	test   %eax,%eax
  80111b:	75 43                	jne    801160 <__umoddi3+0x60>
  80111d:	39 df                	cmp    %ebx,%edi
  80111f:	76 17                	jbe    801138 <__umoddi3+0x38>
  801121:	89 f0                	mov    %esi,%eax
  801123:	f7 f7                	div    %edi
  801125:	89 d0                	mov    %edx,%eax
  801127:	31 d2                	xor    %edx,%edx
  801129:	83 c4 1c             	add    $0x1c,%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    
  801131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801138:	89 fd                	mov    %edi,%ebp
  80113a:	85 ff                	test   %edi,%edi
  80113c:	75 0b                	jne    801149 <__umoddi3+0x49>
  80113e:	b8 01 00 00 00       	mov    $0x1,%eax
  801143:	31 d2                	xor    %edx,%edx
  801145:	f7 f7                	div    %edi
  801147:	89 c5                	mov    %eax,%ebp
  801149:	89 d8                	mov    %ebx,%eax
  80114b:	31 d2                	xor    %edx,%edx
  80114d:	f7 f5                	div    %ebp
  80114f:	89 f0                	mov    %esi,%eax
  801151:	f7 f5                	div    %ebp
  801153:	89 d0                	mov    %edx,%eax
  801155:	eb d0                	jmp    801127 <__umoddi3+0x27>
  801157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80115e:	66 90                	xchg   %ax,%ax
  801160:	89 f1                	mov    %esi,%ecx
  801162:	39 d8                	cmp    %ebx,%eax
  801164:	76 0a                	jbe    801170 <__umoddi3+0x70>
  801166:	89 f0                	mov    %esi,%eax
  801168:	83 c4 1c             	add    $0x1c,%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5f                   	pop    %edi
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    
  801170:	0f bd e8             	bsr    %eax,%ebp
  801173:	83 f5 1f             	xor    $0x1f,%ebp
  801176:	75 20                	jne    801198 <__umoddi3+0x98>
  801178:	39 d8                	cmp    %ebx,%eax
  80117a:	0f 82 b0 00 00 00    	jb     801230 <__umoddi3+0x130>
  801180:	39 f7                	cmp    %esi,%edi
  801182:	0f 86 a8 00 00 00    	jbe    801230 <__umoddi3+0x130>
  801188:	89 c8                	mov    %ecx,%eax
  80118a:	83 c4 1c             	add    $0x1c,%esp
  80118d:	5b                   	pop    %ebx
  80118e:	5e                   	pop    %esi
  80118f:	5f                   	pop    %edi
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    
  801192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801198:	89 e9                	mov    %ebp,%ecx
  80119a:	ba 20 00 00 00       	mov    $0x20,%edx
  80119f:	29 ea                	sub    %ebp,%edx
  8011a1:	d3 e0                	shl    %cl,%eax
  8011a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011a7:	89 d1                	mov    %edx,%ecx
  8011a9:	89 f8                	mov    %edi,%eax
  8011ab:	d3 e8                	shr    %cl,%eax
  8011ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8011b9:	09 c1                	or     %eax,%ecx
  8011bb:	89 d8                	mov    %ebx,%eax
  8011bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011c1:	89 e9                	mov    %ebp,%ecx
  8011c3:	d3 e7                	shl    %cl,%edi
  8011c5:	89 d1                	mov    %edx,%ecx
  8011c7:	d3 e8                	shr    %cl,%eax
  8011c9:	89 e9                	mov    %ebp,%ecx
  8011cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011cf:	d3 e3                	shl    %cl,%ebx
  8011d1:	89 c7                	mov    %eax,%edi
  8011d3:	89 d1                	mov    %edx,%ecx
  8011d5:	89 f0                	mov    %esi,%eax
  8011d7:	d3 e8                	shr    %cl,%eax
  8011d9:	89 e9                	mov    %ebp,%ecx
  8011db:	89 fa                	mov    %edi,%edx
  8011dd:	d3 e6                	shl    %cl,%esi
  8011df:	09 d8                	or     %ebx,%eax
  8011e1:	f7 74 24 08          	divl   0x8(%esp)
  8011e5:	89 d1                	mov    %edx,%ecx
  8011e7:	89 f3                	mov    %esi,%ebx
  8011e9:	f7 64 24 0c          	mull   0xc(%esp)
  8011ed:	89 c6                	mov    %eax,%esi
  8011ef:	89 d7                	mov    %edx,%edi
  8011f1:	39 d1                	cmp    %edx,%ecx
  8011f3:	72 06                	jb     8011fb <__umoddi3+0xfb>
  8011f5:	75 10                	jne    801207 <__umoddi3+0x107>
  8011f7:	39 c3                	cmp    %eax,%ebx
  8011f9:	73 0c                	jae    801207 <__umoddi3+0x107>
  8011fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8011ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801203:	89 d7                	mov    %edx,%edi
  801205:	89 c6                	mov    %eax,%esi
  801207:	89 ca                	mov    %ecx,%edx
  801209:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80120e:	29 f3                	sub    %esi,%ebx
  801210:	19 fa                	sbb    %edi,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	d3 e0                	shl    %cl,%eax
  801216:	89 e9                	mov    %ebp,%ecx
  801218:	d3 eb                	shr    %cl,%ebx
  80121a:	d3 ea                	shr    %cl,%edx
  80121c:	09 d8                	or     %ebx,%eax
  80121e:	83 c4 1c             	add    $0x1c,%esp
  801221:	5b                   	pop    %ebx
  801222:	5e                   	pop    %esi
  801223:	5f                   	pop    %edi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    
  801226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80122d:	8d 76 00             	lea    0x0(%esi),%esi
  801230:	89 da                	mov    %ebx,%edx
  801232:	29 fe                	sub    %edi,%esi
  801234:	19 c2                	sbb    %eax,%edx
  801236:	89 f1                	mov    %esi,%ecx
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	e9 4b ff ff ff       	jmp    80118a <__umoddi3+0x8a>
