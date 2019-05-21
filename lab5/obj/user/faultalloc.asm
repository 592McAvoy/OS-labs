
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
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
  800040:	68 60 12 80 00       	push   $0x801260
  800045:	e8 b6 01 00 00       	call   800200 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 a2 0c 00 00       	call   800d00 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 ac 12 80 00       	push   $0x8012ac
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 48 08 00 00       	call   8008bb <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 80 12 80 00       	push   $0x801280
  800085:	6a 0e                	push   $0xe
  800087:	68 6a 12 80 00       	push   $0x80126a
  80008c:	e8 94 00 00 00       	call   800125 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 d2 0e 00 00       	call   800f73 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 7c 12 80 00       	push   $0x80127c
  8000ae:	e8 4d 01 00 00       	call   800200 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 7c 12 80 00       	push   $0x80127c
  8000c0:	e8 3b 01 00 00       	call   800200 <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d5:	e8 e8 0b 00 00       	call   800cc2 <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000e2:	c1 e0 04             	shl    $0x4,%eax
  8000e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ea:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ef:	85 db                	test   %ebx,%ebx
  8000f1:	7e 07                	jle    8000fa <libmain+0x30>
		binaryname = argv[0];
  8000f3:	8b 06                	mov    (%esi),%eax
  8000f5:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	56                   	push   %esi
  8000fe:	53                   	push   %ebx
  8000ff:	e8 8d ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800104:	e8 0a 00 00 00       	call   800113 <exit>
}
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800119:	6a 00                	push   $0x0
  80011b:	e8 61 0b 00 00       	call   800c81 <sys_env_destroy>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	c9                   	leave  
  800124:	c3                   	ret    

00800125 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80012a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80012d:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800133:	e8 8a 0b 00 00       	call   800cc2 <sys_getenvid>
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 0c             	pushl  0xc(%ebp)
  80013e:	ff 75 08             	pushl  0x8(%ebp)
  800141:	56                   	push   %esi
  800142:	50                   	push   %eax
  800143:	68 d8 12 80 00       	push   $0x8012d8
  800148:	e8 b3 00 00 00       	call   800200 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80014d:	83 c4 18             	add    $0x18,%esp
  800150:	53                   	push   %ebx
  800151:	ff 75 10             	pushl  0x10(%ebp)
  800154:	e8 56 00 00 00       	call   8001af <vcprintf>
	cprintf("\n");
  800159:	c7 04 24 c1 16 80 00 	movl   $0x8016c1,(%esp)
  800160:	e8 9b 00 00 00       	call   800200 <cprintf>
  800165:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800168:	cc                   	int3   
  800169:	eb fd                	jmp    800168 <_panic+0x43>

0080016b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	53                   	push   %ebx
  80016f:	83 ec 04             	sub    $0x4,%esp
  800172:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800175:	8b 13                	mov    (%ebx),%edx
  800177:	8d 42 01             	lea    0x1(%edx),%eax
  80017a:	89 03                	mov    %eax,(%ebx)
  80017c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800183:	3d ff 00 00 00       	cmp    $0xff,%eax
  800188:	74 09                	je     800193 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800191:	c9                   	leave  
  800192:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	68 ff 00 00 00       	push   $0xff
  80019b:	8d 43 08             	lea    0x8(%ebx),%eax
  80019e:	50                   	push   %eax
  80019f:	e8 a0 0a 00 00       	call   800c44 <sys_cputs>
		b->idx = 0;
  8001a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001aa:	83 c4 10             	add    $0x10,%esp
  8001ad:	eb db                	jmp    80018a <putch+0x1f>

008001af <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001bf:	00 00 00 
	b.cnt = 0;
  8001c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001cc:	ff 75 0c             	pushl  0xc(%ebp)
  8001cf:	ff 75 08             	pushl  0x8(%ebp)
  8001d2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d8:	50                   	push   %eax
  8001d9:	68 6b 01 80 00       	push   $0x80016b
  8001de:	e8 4a 01 00 00       	call   80032d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e3:	83 c4 08             	add    $0x8,%esp
  8001e6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ec:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f2:	50                   	push   %eax
  8001f3:	e8 4c 0a 00 00       	call   800c44 <sys_cputs>

	return b.cnt;
}
  8001f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800206:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800209:	50                   	push   %eax
  80020a:	ff 75 08             	pushl  0x8(%ebp)
  80020d:	e8 9d ff ff ff       	call   8001af <vcprintf>
	va_end(ap);

	return cnt;
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	57                   	push   %edi
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
  80021a:	83 ec 1c             	sub    $0x1c,%esp
  80021d:	89 c6                	mov    %eax,%esi
  80021f:	89 d7                	mov    %edx,%edi
  800221:	8b 45 08             	mov    0x8(%ebp),%eax
  800224:	8b 55 0c             	mov    0xc(%ebp),%edx
  800227:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80022d:	8b 45 10             	mov    0x10(%ebp),%eax
  800230:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800233:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800237:	74 2c                	je     800265 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800239:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800243:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800246:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800249:	39 c2                	cmp    %eax,%edx
  80024b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80024e:	73 43                	jae    800293 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800250:	83 eb 01             	sub    $0x1,%ebx
  800253:	85 db                	test   %ebx,%ebx
  800255:	7e 6c                	jle    8002c3 <printnum+0xaf>
			putch(padc, putdat);
  800257:	83 ec 08             	sub    $0x8,%esp
  80025a:	57                   	push   %edi
  80025b:	ff 75 18             	pushl  0x18(%ebp)
  80025e:	ff d6                	call   *%esi
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	eb eb                	jmp    800250 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	6a 20                	push   $0x20
  80026a:	6a 00                	push   $0x0
  80026c:	50                   	push   %eax
  80026d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800270:	ff 75 e0             	pushl  -0x20(%ebp)
  800273:	89 fa                	mov    %edi,%edx
  800275:	89 f0                	mov    %esi,%eax
  800277:	e8 98 ff ff ff       	call   800214 <printnum>
		while (--width > 0)
  80027c:	83 c4 20             	add    $0x20,%esp
  80027f:	83 eb 01             	sub    $0x1,%ebx
  800282:	85 db                	test   %ebx,%ebx
  800284:	7e 65                	jle    8002eb <printnum+0xd7>
			putch(padc, putdat);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	57                   	push   %edi
  80028a:	6a 20                	push   $0x20
  80028c:	ff d6                	call   *%esi
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	eb ec                	jmp    80027f <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	ff 75 18             	pushl  0x18(%ebp)
  800299:	83 eb 01             	sub    $0x1,%ebx
  80029c:	53                   	push   %ebx
  80029d:	50                   	push   %eax
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ad:	e8 5e 0d 00 00       	call   801010 <__udivdi3>
  8002b2:	83 c4 18             	add    $0x18,%esp
  8002b5:	52                   	push   %edx
  8002b6:	50                   	push   %eax
  8002b7:	89 fa                	mov    %edi,%edx
  8002b9:	89 f0                	mov    %esi,%eax
  8002bb:	e8 54 ff ff ff       	call   800214 <printnum>
  8002c0:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	57                   	push   %edi
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d6:	e8 45 0e 00 00       	call   801120 <__umoddi3>
  8002db:	83 c4 14             	add    $0x14,%esp
  8002de:	0f be 80 fb 12 80 00 	movsbl 0x8012fb(%eax),%eax
  8002e5:	50                   	push   %eax
  8002e6:	ff d6                	call   *%esi
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ee:	5b                   	pop    %ebx
  8002ef:	5e                   	pop    %esi
  8002f0:	5f                   	pop    %edi
  8002f1:	5d                   	pop    %ebp
  8002f2:	c3                   	ret    

008002f3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fd:	8b 10                	mov    (%eax),%edx
  8002ff:	3b 50 04             	cmp    0x4(%eax),%edx
  800302:	73 0a                	jae    80030e <sprintputch+0x1b>
		*b->buf++ = ch;
  800304:	8d 4a 01             	lea    0x1(%edx),%ecx
  800307:	89 08                	mov    %ecx,(%eax)
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	88 02                	mov    %al,(%edx)
}
  80030e:	5d                   	pop    %ebp
  80030f:	c3                   	ret    

00800310 <printfmt>:
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800316:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800319:	50                   	push   %eax
  80031a:	ff 75 10             	pushl  0x10(%ebp)
  80031d:	ff 75 0c             	pushl  0xc(%ebp)
  800320:	ff 75 08             	pushl  0x8(%ebp)
  800323:	e8 05 00 00 00       	call   80032d <vprintfmt>
}
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <vprintfmt>:
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	57                   	push   %edi
  800331:	56                   	push   %esi
  800332:	53                   	push   %ebx
  800333:	83 ec 3c             	sub    $0x3c,%esp
  800336:	8b 75 08             	mov    0x8(%ebp),%esi
  800339:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033f:	e9 b4 03 00 00       	jmp    8006f8 <vprintfmt+0x3cb>
		padc = ' ';
  800344:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800348:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80034f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800356:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800364:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800369:	8d 47 01             	lea    0x1(%edi),%eax
  80036c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036f:	0f b6 17             	movzbl (%edi),%edx
  800372:	8d 42 dd             	lea    -0x23(%edx),%eax
  800375:	3c 55                	cmp    $0x55,%al
  800377:	0f 87 c8 04 00 00    	ja     800845 <vprintfmt+0x518>
  80037d:	0f b6 c0             	movzbl %al,%eax
  800380:	ff 24 85 e0 14 80 00 	jmp    *0x8014e0(,%eax,4)
  800387:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80038a:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800391:	eb d6                	jmp    800369 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800396:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80039a:	eb cd                	jmp    800369 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	0f b6 d2             	movzbl %dl,%edx
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8003aa:	eb 0c                	jmp    8003b8 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8003ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003af:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003b3:	eb b4                	jmp    800369 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8003b5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003bb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003bf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003c5:	83 f9 09             	cmp    $0x9,%ecx
  8003c8:	76 eb                	jbe    8003b5 <vprintfmt+0x88>
  8003ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d0:	eb 14                	jmp    8003e6 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8003d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 40 04             	lea    0x4(%eax),%eax
  8003e0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ea:	0f 89 79 ff ff ff    	jns    800369 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8003f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003fd:	e9 67 ff ff ff       	jmp    800369 <vprintfmt+0x3c>
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	85 c0                	test   %eax,%eax
  800407:	ba 00 00 00 00       	mov    $0x0,%edx
  80040c:	0f 49 d0             	cmovns %eax,%edx
  80040f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800412:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800415:	e9 4f ff ff ff       	jmp    800369 <vprintfmt+0x3c>
  80041a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80041d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800424:	e9 40 ff ff ff       	jmp    800369 <vprintfmt+0x3c>
			lflag++;
  800429:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80042f:	e9 35 ff ff ff       	jmp    800369 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8d 78 04             	lea    0x4(%eax),%edi
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	53                   	push   %ebx
  80043e:	ff 30                	pushl  (%eax)
  800440:	ff d6                	call   *%esi
			break;
  800442:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800445:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800448:	e9 a8 02 00 00       	jmp    8006f5 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 78 04             	lea    0x4(%eax),%edi
  800453:	8b 00                	mov    (%eax),%eax
  800455:	99                   	cltd   
  800456:	31 d0                	xor    %edx,%eax
  800458:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045a:	83 f8 0f             	cmp    $0xf,%eax
  80045d:	7f 23                	jg     800482 <vprintfmt+0x155>
  80045f:	8b 14 85 40 16 80 00 	mov    0x801640(,%eax,4),%edx
  800466:	85 d2                	test   %edx,%edx
  800468:	74 18                	je     800482 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80046a:	52                   	push   %edx
  80046b:	68 1c 13 80 00       	push   $0x80131c
  800470:	53                   	push   %ebx
  800471:	56                   	push   %esi
  800472:	e8 99 fe ff ff       	call   800310 <printfmt>
  800477:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80047d:	e9 73 02 00 00       	jmp    8006f5 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800482:	50                   	push   %eax
  800483:	68 13 13 80 00       	push   $0x801313
  800488:	53                   	push   %ebx
  800489:	56                   	push   %esi
  80048a:	e8 81 fe ff ff       	call   800310 <printfmt>
  80048f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800492:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800495:	e9 5b 02 00 00       	jmp    8006f5 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	83 c0 04             	add    $0x4,%eax
  8004a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004a8:	85 d2                	test   %edx,%edx
  8004aa:	b8 0c 13 80 00       	mov    $0x80130c,%eax
  8004af:	0f 45 c2             	cmovne %edx,%eax
  8004b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b9:	7e 06                	jle    8004c1 <vprintfmt+0x194>
  8004bb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004bf:	75 0d                	jne    8004ce <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c4:	89 c7                	mov    %eax,%edi
  8004c6:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cc:	eb 53                	jmp    800521 <vprintfmt+0x1f4>
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d4:	50                   	push   %eax
  8004d5:	e8 13 04 00 00       	call   8008ed <strnlen>
  8004da:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004dd:	29 c1                	sub    %eax,%ecx
  8004df:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004e7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ee:	eb 0f                	jmp    8004ff <vprintfmt+0x1d2>
					putch(padc, putdat);
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	53                   	push   %ebx
  8004f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f9:	83 ef 01             	sub    $0x1,%edi
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	85 ff                	test   %edi,%edi
  800501:	7f ed                	jg     8004f0 <vprintfmt+0x1c3>
  800503:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800506:	85 d2                	test   %edx,%edx
  800508:	b8 00 00 00 00       	mov    $0x0,%eax
  80050d:	0f 49 c2             	cmovns %edx,%eax
  800510:	29 c2                	sub    %eax,%edx
  800512:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800515:	eb aa                	jmp    8004c1 <vprintfmt+0x194>
					putch(ch, putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	53                   	push   %ebx
  80051b:	52                   	push   %edx
  80051c:	ff d6                	call   *%esi
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800524:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800526:	83 c7 01             	add    $0x1,%edi
  800529:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80052d:	0f be d0             	movsbl %al,%edx
  800530:	85 d2                	test   %edx,%edx
  800532:	74 4b                	je     80057f <vprintfmt+0x252>
  800534:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800538:	78 06                	js     800540 <vprintfmt+0x213>
  80053a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80053e:	78 1e                	js     80055e <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800540:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800544:	74 d1                	je     800517 <vprintfmt+0x1ea>
  800546:	0f be c0             	movsbl %al,%eax
  800549:	83 e8 20             	sub    $0x20,%eax
  80054c:	83 f8 5e             	cmp    $0x5e,%eax
  80054f:	76 c6                	jbe    800517 <vprintfmt+0x1ea>
					putch('?', putdat);
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	53                   	push   %ebx
  800555:	6a 3f                	push   $0x3f
  800557:	ff d6                	call   *%esi
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	eb c3                	jmp    800521 <vprintfmt+0x1f4>
  80055e:	89 cf                	mov    %ecx,%edi
  800560:	eb 0e                	jmp    800570 <vprintfmt+0x243>
				putch(' ', putdat);
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	53                   	push   %ebx
  800566:	6a 20                	push   $0x20
  800568:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80056a:	83 ef 01             	sub    $0x1,%edi
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	85 ff                	test   %edi,%edi
  800572:	7f ee                	jg     800562 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800574:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
  80057a:	e9 76 01 00 00       	jmp    8006f5 <vprintfmt+0x3c8>
  80057f:	89 cf                	mov    %ecx,%edi
  800581:	eb ed                	jmp    800570 <vprintfmt+0x243>
	if (lflag >= 2)
  800583:	83 f9 01             	cmp    $0x1,%ecx
  800586:	7f 1f                	jg     8005a7 <vprintfmt+0x27a>
	else if (lflag)
  800588:	85 c9                	test   %ecx,%ecx
  80058a:	74 6a                	je     8005f6 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800594:	89 c1                	mov    %eax,%ecx
  800596:	c1 f9 1f             	sar    $0x1f,%ecx
  800599:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8d 40 04             	lea    0x4(%eax),%eax
  8005a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a5:	eb 17                	jmp    8005be <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 50 04             	mov    0x4(%eax),%edx
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8d 40 08             	lea    0x8(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005be:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005c1:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005c6:	85 d2                	test   %edx,%edx
  8005c8:	0f 89 f8 00 00 00    	jns    8006c6 <vprintfmt+0x399>
				putch('-', putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	6a 2d                	push   $0x2d
  8005d4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005dc:	f7 d8                	neg    %eax
  8005de:	83 d2 00             	adc    $0x0,%edx
  8005e1:	f7 da                	neg    %edx
  8005e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ec:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f1:	e9 e1 00 00 00       	jmp    8006d7 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fe:	99                   	cltd   
  8005ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8d 40 04             	lea    0x4(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
  80060b:	eb b1                	jmp    8005be <vprintfmt+0x291>
	if (lflag >= 2)
  80060d:	83 f9 01             	cmp    $0x1,%ecx
  800610:	7f 27                	jg     800639 <vprintfmt+0x30c>
	else if (lflag)
  800612:	85 c9                	test   %ecx,%ecx
  800614:	74 41                	je     800657 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	ba 00 00 00 00       	mov    $0x0,%edx
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800634:	e9 8d 00 00 00       	jmp    8006c6 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 50 04             	mov    0x4(%eax),%edx
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800644:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 40 08             	lea    0x8(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800650:	bf 0a 00 00 00       	mov    $0xa,%edi
  800655:	eb 6f                	jmp    8006c6 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 40 04             	lea    0x4(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800670:	bf 0a 00 00 00       	mov    $0xa,%edi
  800675:	eb 4f                	jmp    8006c6 <vprintfmt+0x399>
	if (lflag >= 2)
  800677:	83 f9 01             	cmp    $0x1,%ecx
  80067a:	7f 23                	jg     80069f <vprintfmt+0x372>
	else if (lflag)
  80067c:	85 c9                	test   %ecx,%ecx
  80067e:	0f 84 98 00 00 00    	je     80071c <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8d 40 04             	lea    0x4(%eax),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
  80069d:	eb 17                	jmp    8006b6 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 50 04             	mov    0x4(%eax),%edx
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 40 08             	lea    0x8(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	53                   	push   %ebx
  8006ba:	6a 30                	push   $0x30
  8006bc:	ff d6                	call   *%esi
			goto number;
  8006be:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006c1:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8006c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006ca:	74 0b                	je     8006d7 <vprintfmt+0x3aa>
				putch('+', putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	53                   	push   %ebx
  8006d0:	6a 2b                	push   $0x2b
  8006d2:	ff d6                	call   *%esi
  8006d4:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006de:	50                   	push   %eax
  8006df:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e2:	57                   	push   %edi
  8006e3:	ff 75 dc             	pushl  -0x24(%ebp)
  8006e6:	ff 75 d8             	pushl  -0x28(%ebp)
  8006e9:	89 da                	mov    %ebx,%edx
  8006eb:	89 f0                	mov    %esi,%eax
  8006ed:	e8 22 fb ff ff       	call   800214 <printnum>
			break;
  8006f2:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8006f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f8:	83 c7 01             	add    $0x1,%edi
  8006fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ff:	83 f8 25             	cmp    $0x25,%eax
  800702:	0f 84 3c fc ff ff    	je     800344 <vprintfmt+0x17>
			if (ch == '\0')
  800708:	85 c0                	test   %eax,%eax
  80070a:	0f 84 55 01 00 00    	je     800865 <vprintfmt+0x538>
			putch(ch, putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	53                   	push   %ebx
  800714:	50                   	push   %eax
  800715:	ff d6                	call   *%esi
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	eb dc                	jmp    8006f8 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800729:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
  800735:	e9 7c ff ff ff       	jmp    8006b6 <vprintfmt+0x389>
			putch('0', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	6a 30                	push   $0x30
  800740:	ff d6                	call   *%esi
			putch('x', putdat);
  800742:	83 c4 08             	add    $0x8,%esp
  800745:	53                   	push   %ebx
  800746:	6a 78                	push   $0x78
  800748:	ff d6                	call   *%esi
			num = (unsigned long long)
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	ba 00 00 00 00       	mov    $0x0,%edx
  800754:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800757:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80075a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8d 40 04             	lea    0x4(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800766:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  80076b:	e9 56 ff ff ff       	jmp    8006c6 <vprintfmt+0x399>
	if (lflag >= 2)
  800770:	83 f9 01             	cmp    $0x1,%ecx
  800773:	7f 27                	jg     80079c <vprintfmt+0x46f>
	else if (lflag)
  800775:	85 c9                	test   %ecx,%ecx
  800777:	74 44                	je     8007bd <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
  800783:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800786:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 40 04             	lea    0x4(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800792:	bf 10 00 00 00       	mov    $0x10,%edi
  800797:	e9 2a ff ff ff       	jmp    8006c6 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 50 04             	mov    0x4(%eax),%edx
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8d 40 08             	lea    0x8(%eax),%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b3:	bf 10 00 00 00       	mov    $0x10,%edi
  8007b8:	e9 09 ff ff ff       	jmp    8006c6 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d6:	bf 10 00 00 00       	mov    $0x10,%edi
  8007db:	e9 e6 fe ff ff       	jmp    8006c6 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 78 04             	lea    0x4(%eax),%edi
  8007e6:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8007e8:	85 c0                	test   %eax,%eax
  8007ea:	74 2d                	je     800819 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8007ec:	0f b6 13             	movzbl (%ebx),%edx
  8007ef:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007f1:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8007f4:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007f7:	0f 8e f8 fe ff ff    	jle    8006f5 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8007fd:	68 6c 14 80 00       	push   $0x80146c
  800802:	68 1c 13 80 00       	push   $0x80131c
  800807:	53                   	push   %ebx
  800808:	56                   	push   %esi
  800809:	e8 02 fb ff ff       	call   800310 <printfmt>
  80080e:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800811:	89 7d 14             	mov    %edi,0x14(%ebp)
  800814:	e9 dc fe ff ff       	jmp    8006f5 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800819:	68 34 14 80 00       	push   $0x801434
  80081e:	68 1c 13 80 00       	push   $0x80131c
  800823:	53                   	push   %ebx
  800824:	56                   	push   %esi
  800825:	e8 e6 fa ff ff       	call   800310 <printfmt>
  80082a:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80082d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800830:	e9 c0 fe ff ff       	jmp    8006f5 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	53                   	push   %ebx
  800839:	6a 25                	push   $0x25
  80083b:	ff d6                	call   *%esi
			break;
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	e9 b0 fe ff ff       	jmp    8006f5 <vprintfmt+0x3c8>
			putch('%', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	53                   	push   %ebx
  800849:	6a 25                	push   $0x25
  80084b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	89 f8                	mov    %edi,%eax
  800852:	eb 03                	jmp    800857 <vprintfmt+0x52a>
  800854:	83 e8 01             	sub    $0x1,%eax
  800857:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085b:	75 f7                	jne    800854 <vprintfmt+0x527>
  80085d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800860:	e9 90 fe ff ff       	jmp    8006f5 <vprintfmt+0x3c8>
}
  800865:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800868:	5b                   	pop    %ebx
  800869:	5e                   	pop    %esi
  80086a:	5f                   	pop    %edi
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    

0080086d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	83 ec 18             	sub    $0x18,%esp
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800880:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088a:	85 c0                	test   %eax,%eax
  80088c:	74 26                	je     8008b4 <vsnprintf+0x47>
  80088e:	85 d2                	test   %edx,%edx
  800890:	7e 22                	jle    8008b4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800892:	ff 75 14             	pushl  0x14(%ebp)
  800895:	ff 75 10             	pushl  0x10(%ebp)
  800898:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089b:	50                   	push   %eax
  80089c:	68 f3 02 80 00       	push   $0x8002f3
  8008a1:	e8 87 fa ff ff       	call   80032d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008af:	83 c4 10             	add    $0x10,%esp
}
  8008b2:	c9                   	leave  
  8008b3:	c3                   	ret    
		return -E_INVAL;
  8008b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b9:	eb f7                	jmp    8008b2 <vsnprintf+0x45>

008008bb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c4:	50                   	push   %eax
  8008c5:	ff 75 10             	pushl  0x10(%ebp)
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 9a ff ff ff       	call   80086d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e4:	74 05                	je     8008eb <strlen+0x16>
		n++;
  8008e6:	83 c0 01             	add    $0x1,%eax
  8008e9:	eb f5                	jmp    8008e0 <strlen+0xb>
	return n;
}
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	74 0d                	je     80090c <strnlen+0x1f>
  8008ff:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800903:	74 05                	je     80090a <strnlen+0x1d>
		n++;
  800905:	83 c2 01             	add    $0x1,%edx
  800908:	eb f1                	jmp    8008fb <strnlen+0xe>
  80090a:	89 d0                	mov    %edx,%eax
	return n;
}
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	53                   	push   %ebx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
  80091d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800921:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800924:	83 c2 01             	add    $0x1,%edx
  800927:	84 c9                	test   %cl,%cl
  800929:	75 f2                	jne    80091d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80092b:	5b                   	pop    %ebx
  80092c:	5d                   	pop    %ebp
  80092d:	c3                   	ret    

0080092e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	53                   	push   %ebx
  800932:	83 ec 10             	sub    $0x10,%esp
  800935:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800938:	53                   	push   %ebx
  800939:	e8 97 ff ff ff       	call   8008d5 <strlen>
  80093e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	01 d8                	add    %ebx,%eax
  800946:	50                   	push   %eax
  800947:	e8 c2 ff ff ff       	call   80090e <strcpy>
	return dst;
}
  80094c:	89 d8                	mov    %ebx,%eax
  80094e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800951:	c9                   	leave  
  800952:	c3                   	ret    

00800953 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	56                   	push   %esi
  800957:	53                   	push   %ebx
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095e:	89 c6                	mov    %eax,%esi
  800960:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800963:	89 c2                	mov    %eax,%edx
  800965:	39 f2                	cmp    %esi,%edx
  800967:	74 11                	je     80097a <strncpy+0x27>
		*dst++ = *src;
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	0f b6 19             	movzbl (%ecx),%ebx
  80096f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800972:	80 fb 01             	cmp    $0x1,%bl
  800975:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800978:	eb eb                	jmp    800965 <strncpy+0x12>
	}
	return ret;
}
  80097a:	5b                   	pop    %ebx
  80097b:	5e                   	pop    %esi
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	56                   	push   %esi
  800982:	53                   	push   %ebx
  800983:	8b 75 08             	mov    0x8(%ebp),%esi
  800986:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800989:	8b 55 10             	mov    0x10(%ebp),%edx
  80098c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098e:	85 d2                	test   %edx,%edx
  800990:	74 21                	je     8009b3 <strlcpy+0x35>
  800992:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800996:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800998:	39 c2                	cmp    %eax,%edx
  80099a:	74 14                	je     8009b0 <strlcpy+0x32>
  80099c:	0f b6 19             	movzbl (%ecx),%ebx
  80099f:	84 db                	test   %bl,%bl
  8009a1:	74 0b                	je     8009ae <strlcpy+0x30>
			*dst++ = *src++;
  8009a3:	83 c1 01             	add    $0x1,%ecx
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ac:	eb ea                	jmp    800998 <strlcpy+0x1a>
  8009ae:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009b0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b3:	29 f0                	sub    %esi,%eax
}
  8009b5:	5b                   	pop    %ebx
  8009b6:	5e                   	pop    %esi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c2:	0f b6 01             	movzbl (%ecx),%eax
  8009c5:	84 c0                	test   %al,%al
  8009c7:	74 0c                	je     8009d5 <strcmp+0x1c>
  8009c9:	3a 02                	cmp    (%edx),%al
  8009cb:	75 08                	jne    8009d5 <strcmp+0x1c>
		p++, q++;
  8009cd:	83 c1 01             	add    $0x1,%ecx
  8009d0:	83 c2 01             	add    $0x1,%edx
  8009d3:	eb ed                	jmp    8009c2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d5:	0f b6 c0             	movzbl %al,%eax
  8009d8:	0f b6 12             	movzbl (%edx),%edx
  8009db:	29 d0                	sub    %edx,%eax
}
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e9:	89 c3                	mov    %eax,%ebx
  8009eb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ee:	eb 06                	jmp    8009f6 <strncmp+0x17>
		n--, p++, q++;
  8009f0:	83 c0 01             	add    $0x1,%eax
  8009f3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f6:	39 d8                	cmp    %ebx,%eax
  8009f8:	74 16                	je     800a10 <strncmp+0x31>
  8009fa:	0f b6 08             	movzbl (%eax),%ecx
  8009fd:	84 c9                	test   %cl,%cl
  8009ff:	74 04                	je     800a05 <strncmp+0x26>
  800a01:	3a 0a                	cmp    (%edx),%cl
  800a03:	74 eb                	je     8009f0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a05:	0f b6 00             	movzbl (%eax),%eax
  800a08:	0f b6 12             	movzbl (%edx),%edx
  800a0b:	29 d0                	sub    %edx,%eax
}
  800a0d:	5b                   	pop    %ebx
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    
		return 0;
  800a10:	b8 00 00 00 00       	mov    $0x0,%eax
  800a15:	eb f6                	jmp    800a0d <strncmp+0x2e>

00800a17 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a21:	0f b6 10             	movzbl (%eax),%edx
  800a24:	84 d2                	test   %dl,%dl
  800a26:	74 09                	je     800a31 <strchr+0x1a>
		if (*s == c)
  800a28:	38 ca                	cmp    %cl,%dl
  800a2a:	74 0a                	je     800a36 <strchr+0x1f>
	for (; *s; s++)
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	eb f0                	jmp    800a21 <strchr+0xa>
			return (char *) s;
	return 0;
  800a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a42:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a45:	38 ca                	cmp    %cl,%dl
  800a47:	74 09                	je     800a52 <strfind+0x1a>
  800a49:	84 d2                	test   %dl,%dl
  800a4b:	74 05                	je     800a52 <strfind+0x1a>
	for (; *s; s++)
  800a4d:	83 c0 01             	add    $0x1,%eax
  800a50:	eb f0                	jmp    800a42 <strfind+0xa>
			break;
	return (char *) s;
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	57                   	push   %edi
  800a58:	56                   	push   %esi
  800a59:	53                   	push   %ebx
  800a5a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a60:	85 c9                	test   %ecx,%ecx
  800a62:	74 31                	je     800a95 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a64:	89 f8                	mov    %edi,%eax
  800a66:	09 c8                	or     %ecx,%eax
  800a68:	a8 03                	test   $0x3,%al
  800a6a:	75 23                	jne    800a8f <memset+0x3b>
		c &= 0xFF;
  800a6c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a70:	89 d3                	mov    %edx,%ebx
  800a72:	c1 e3 08             	shl    $0x8,%ebx
  800a75:	89 d0                	mov    %edx,%eax
  800a77:	c1 e0 18             	shl    $0x18,%eax
  800a7a:	89 d6                	mov    %edx,%esi
  800a7c:	c1 e6 10             	shl    $0x10,%esi
  800a7f:	09 f0                	or     %esi,%eax
  800a81:	09 c2                	or     %eax,%edx
  800a83:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a85:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a88:	89 d0                	mov    %edx,%eax
  800a8a:	fc                   	cld    
  800a8b:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8d:	eb 06                	jmp    800a95 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	fc                   	cld    
  800a93:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a95:	89 f8                	mov    %edi,%eax
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	57                   	push   %edi
  800aa0:	56                   	push   %esi
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aaa:	39 c6                	cmp    %eax,%esi
  800aac:	73 32                	jae    800ae0 <memmove+0x44>
  800aae:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab1:	39 c2                	cmp    %eax,%edx
  800ab3:	76 2b                	jbe    800ae0 <memmove+0x44>
		s += n;
		d += n;
  800ab5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab8:	89 fe                	mov    %edi,%esi
  800aba:	09 ce                	or     %ecx,%esi
  800abc:	09 d6                	or     %edx,%esi
  800abe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac4:	75 0e                	jne    800ad4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac6:	83 ef 04             	sub    $0x4,%edi
  800ac9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acf:	fd                   	std    
  800ad0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad2:	eb 09                	jmp    800add <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad4:	83 ef 01             	sub    $0x1,%edi
  800ad7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ada:	fd                   	std    
  800adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800add:	fc                   	cld    
  800ade:	eb 1a                	jmp    800afa <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	09 ca                	or     %ecx,%edx
  800ae4:	09 f2                	or     %esi,%edx
  800ae6:	f6 c2 03             	test   $0x3,%dl
  800ae9:	75 0a                	jne    800af5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aeb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aee:	89 c7                	mov    %eax,%edi
  800af0:	fc                   	cld    
  800af1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af3:	eb 05                	jmp    800afa <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af5:	89 c7                	mov    %eax,%edi
  800af7:	fc                   	cld    
  800af8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800afa:	5e                   	pop    %esi
  800afb:	5f                   	pop    %edi
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b04:	ff 75 10             	pushl  0x10(%ebp)
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	ff 75 08             	pushl  0x8(%ebp)
  800b0d:	e8 8a ff ff ff       	call   800a9c <memmove>
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1f:	89 c6                	mov    %eax,%esi
  800b21:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b24:	39 f0                	cmp    %esi,%eax
  800b26:	74 1c                	je     800b44 <memcmp+0x30>
		if (*s1 != *s2)
  800b28:	0f b6 08             	movzbl (%eax),%ecx
  800b2b:	0f b6 1a             	movzbl (%edx),%ebx
  800b2e:	38 d9                	cmp    %bl,%cl
  800b30:	75 08                	jne    800b3a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b32:	83 c0 01             	add    $0x1,%eax
  800b35:	83 c2 01             	add    $0x1,%edx
  800b38:	eb ea                	jmp    800b24 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b3a:	0f b6 c1             	movzbl %cl,%eax
  800b3d:	0f b6 db             	movzbl %bl,%ebx
  800b40:	29 d8                	sub    %ebx,%eax
  800b42:	eb 05                	jmp    800b49 <memcmp+0x35>
	}

	return 0;
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b56:	89 c2                	mov    %eax,%edx
  800b58:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b5b:	39 d0                	cmp    %edx,%eax
  800b5d:	73 09                	jae    800b68 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5f:	38 08                	cmp    %cl,(%eax)
  800b61:	74 05                	je     800b68 <memfind+0x1b>
	for (; s < ends; s++)
  800b63:	83 c0 01             	add    $0x1,%eax
  800b66:	eb f3                	jmp    800b5b <memfind+0xe>
			break;
	return (void *) s;
}
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b76:	eb 03                	jmp    800b7b <strtol+0x11>
		s++;
  800b78:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b7b:	0f b6 01             	movzbl (%ecx),%eax
  800b7e:	3c 20                	cmp    $0x20,%al
  800b80:	74 f6                	je     800b78 <strtol+0xe>
  800b82:	3c 09                	cmp    $0x9,%al
  800b84:	74 f2                	je     800b78 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b86:	3c 2b                	cmp    $0x2b,%al
  800b88:	74 2a                	je     800bb4 <strtol+0x4a>
	int neg = 0;
  800b8a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8f:	3c 2d                	cmp    $0x2d,%al
  800b91:	74 2b                	je     800bbe <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b93:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b99:	75 0f                	jne    800baa <strtol+0x40>
  800b9b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9e:	74 28                	je     800bc8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba0:	85 db                	test   %ebx,%ebx
  800ba2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba7:	0f 44 d8             	cmove  %eax,%ebx
  800baa:	b8 00 00 00 00       	mov    $0x0,%eax
  800baf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb2:	eb 50                	jmp    800c04 <strtol+0x9a>
		s++;
  800bb4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbc:	eb d5                	jmp    800b93 <strtol+0x29>
		s++, neg = 1;
  800bbe:	83 c1 01             	add    $0x1,%ecx
  800bc1:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc6:	eb cb                	jmp    800b93 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bcc:	74 0e                	je     800bdc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bce:	85 db                	test   %ebx,%ebx
  800bd0:	75 d8                	jne    800baa <strtol+0x40>
		s++, base = 8;
  800bd2:	83 c1 01             	add    $0x1,%ecx
  800bd5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bda:	eb ce                	jmp    800baa <strtol+0x40>
		s += 2, base = 16;
  800bdc:	83 c1 02             	add    $0x2,%ecx
  800bdf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be4:	eb c4                	jmp    800baa <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be9:	89 f3                	mov    %esi,%ebx
  800beb:	80 fb 19             	cmp    $0x19,%bl
  800bee:	77 29                	ja     800c19 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf0:	0f be d2             	movsbl %dl,%edx
  800bf3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf9:	7d 30                	jge    800c2b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bfb:	83 c1 01             	add    $0x1,%ecx
  800bfe:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c02:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c04:	0f b6 11             	movzbl (%ecx),%edx
  800c07:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0a:	89 f3                	mov    %esi,%ebx
  800c0c:	80 fb 09             	cmp    $0x9,%bl
  800c0f:	77 d5                	ja     800be6 <strtol+0x7c>
			dig = *s - '0';
  800c11:	0f be d2             	movsbl %dl,%edx
  800c14:	83 ea 30             	sub    $0x30,%edx
  800c17:	eb dd                	jmp    800bf6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c19:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c1c:	89 f3                	mov    %esi,%ebx
  800c1e:	80 fb 19             	cmp    $0x19,%bl
  800c21:	77 08                	ja     800c2b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c23:	0f be d2             	movsbl %dl,%edx
  800c26:	83 ea 37             	sub    $0x37,%edx
  800c29:	eb cb                	jmp    800bf6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2f:	74 05                	je     800c36 <strtol+0xcc>
		*endptr = (char *) s;
  800c31:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c34:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c36:	89 c2                	mov    %eax,%edx
  800c38:	f7 da                	neg    %edx
  800c3a:	85 ff                	test   %edi,%edi
  800c3c:	0f 45 c2             	cmovne %edx,%eax
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c55:	89 c3                	mov    %eax,%ebx
  800c57:	89 c7                	mov    %eax,%edi
  800c59:	89 c6                	mov    %eax,%esi
  800c5b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c68:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c72:	89 d1                	mov    %edx,%ecx
  800c74:	89 d3                	mov    %edx,%ebx
  800c76:	89 d7                	mov    %edx,%edi
  800c78:	89 d6                	mov    %edx,%esi
  800c7a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c92:	b8 03 00 00 00       	mov    $0x3,%eax
  800c97:	89 cb                	mov    %ecx,%ebx
  800c99:	89 cf                	mov    %ecx,%edi
  800c9b:	89 ce                	mov    %ecx,%esi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 03                	push   $0x3
  800cb1:	68 80 16 80 00       	push   $0x801680
  800cb6:	6a 33                	push   $0x33
  800cb8:	68 9d 16 80 00       	push   $0x80169d
  800cbd:	e8 63 f4 ff ff       	call   800125 <_panic>

00800cc2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccd:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd2:	89 d1                	mov    %edx,%ecx
  800cd4:	89 d3                	mov    %edx,%ebx
  800cd6:	89 d7                	mov    %edx,%edi
  800cd8:	89 d6                	mov    %edx,%esi
  800cda:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <sys_yield>:

void
sys_yield(void)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cec:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cf1:	89 d1                	mov    %edx,%ecx
  800cf3:	89 d3                	mov    %edx,%ebx
  800cf5:	89 d7                	mov    %edx,%edi
  800cf7:	89 d6                	mov    %edx,%esi
  800cf9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d09:	be 00 00 00 00       	mov    $0x0,%esi
  800d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d14:	b8 04 00 00 00       	mov    $0x4,%eax
  800d19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1c:	89 f7                	mov    %esi,%edi
  800d1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	7f 08                	jg     800d2c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2c:	83 ec 0c             	sub    $0xc,%esp
  800d2f:	50                   	push   %eax
  800d30:	6a 04                	push   $0x4
  800d32:	68 80 16 80 00       	push   $0x801680
  800d37:	6a 33                	push   $0x33
  800d39:	68 9d 16 80 00       	push   $0x80169d
  800d3e:	e8 e2 f3 ff ff       	call   800125 <_panic>

00800d43 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d52:	b8 05 00 00 00       	mov    $0x5,%eax
  800d57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5d:	8b 75 18             	mov    0x18(%ebp),%esi
  800d60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d62:	85 c0                	test   %eax,%eax
  800d64:	7f 08                	jg     800d6e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	50                   	push   %eax
  800d72:	6a 05                	push   $0x5
  800d74:	68 80 16 80 00       	push   $0x801680
  800d79:	6a 33                	push   $0x33
  800d7b:	68 9d 16 80 00       	push   $0x80169d
  800d80:	e8 a0 f3 ff ff       	call   800125 <_panic>

00800d85 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9e:	89 df                	mov    %ebx,%edi
  800da0:	89 de                	mov    %ebx,%esi
  800da2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	7f 08                	jg     800db0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	50                   	push   %eax
  800db4:	6a 06                	push   $0x6
  800db6:	68 80 16 80 00       	push   $0x801680
  800dbb:	6a 33                	push   $0x33
  800dbd:	68 9d 16 80 00       	push   $0x80169d
  800dc2:	e8 5e f3 ff ff       	call   800125 <_panic>

00800dc7 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ddd:	89 cb                	mov    %ecx,%ebx
  800ddf:	89 cf                	mov    %ecx,%edi
  800de1:	89 ce                	mov    %ecx,%esi
  800de3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de5:	85 c0                	test   %eax,%eax
  800de7:	7f 08                	jg     800df1 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800de9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dec:	5b                   	pop    %ebx
  800ded:	5e                   	pop    %esi
  800dee:	5f                   	pop    %edi
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df1:	83 ec 0c             	sub    $0xc,%esp
  800df4:	50                   	push   %eax
  800df5:	6a 0b                	push   $0xb
  800df7:	68 80 16 80 00       	push   $0x801680
  800dfc:	6a 33                	push   $0x33
  800dfe:	68 9d 16 80 00       	push   $0x80169d
  800e03:	e8 1d f3 ff ff       	call   800125 <_panic>

00800e08 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	57                   	push   %edi
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	b8 08 00 00 00       	mov    $0x8,%eax
  800e21:	89 df                	mov    %ebx,%edi
  800e23:	89 de                	mov    %ebx,%esi
  800e25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e27:	85 c0                	test   %eax,%eax
  800e29:	7f 08                	jg     800e33 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	50                   	push   %eax
  800e37:	6a 08                	push   $0x8
  800e39:	68 80 16 80 00       	push   $0x801680
  800e3e:	6a 33                	push   $0x33
  800e40:	68 9d 16 80 00       	push   $0x80169d
  800e45:	e8 db f2 ff ff       	call   800125 <_panic>

00800e4a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	57                   	push   %edi
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
  800e50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e58:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e63:	89 df                	mov    %ebx,%edi
  800e65:	89 de                	mov    %ebx,%esi
  800e67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	7f 08                	jg     800e75 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	83 ec 0c             	sub    $0xc,%esp
  800e78:	50                   	push   %eax
  800e79:	6a 09                	push   $0x9
  800e7b:	68 80 16 80 00       	push   $0x801680
  800e80:	6a 33                	push   $0x33
  800e82:	68 9d 16 80 00       	push   $0x80169d
  800e87:	e8 99 f2 ff ff       	call   800125 <_panic>

00800e8c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea5:	89 df                	mov    %ebx,%edi
  800ea7:	89 de                	mov    %ebx,%esi
  800ea9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eab:	85 c0                	test   %eax,%eax
  800ead:	7f 08                	jg     800eb7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb7:	83 ec 0c             	sub    $0xc,%esp
  800eba:	50                   	push   %eax
  800ebb:	6a 0a                	push   $0xa
  800ebd:	68 80 16 80 00       	push   $0x801680
  800ec2:	6a 33                	push   $0x33
  800ec4:	68 9d 16 80 00       	push   $0x80169d
  800ec9:	e8 57 f2 ff ff       	call   800125 <_panic>

00800ece <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edf:	be 00 00 00 00       	mov    $0x0,%esi
  800ee4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eea:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    

00800ef1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
  800ef7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f07:	89 cb                	mov    %ecx,%ebx
  800f09:	89 cf                	mov    %ecx,%edi
  800f0b:	89 ce                	mov    %ecx,%esi
  800f0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7f 08                	jg     800f1b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	50                   	push   %eax
  800f1f:	6a 0e                	push   $0xe
  800f21:	68 80 16 80 00       	push   $0x801680
  800f26:	6a 33                	push   $0x33
  800f28:	68 9d 16 80 00       	push   $0x80169d
  800f2d:	e8 f3 f1 ff ff       	call   800125 <_panic>

00800f32 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f43:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f48:	89 df                	mov    %ebx,%edi
  800f4a:	89 de                	mov    %ebx,%esi
  800f4c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f61:	b8 10 00 00 00       	mov    $0x10,%eax
  800f66:	89 cb                	mov    %ecx,%ebx
  800f68:	89 cf                	mov    %ecx,%edi
  800f6a:	89 ce                	mov    %ecx,%esi
  800f6c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f79:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800f80:	74 0a                	je     800f8c <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  800f8c:	83 ec 04             	sub    $0x4,%esp
  800f8f:	6a 07                	push   $0x7
  800f91:	68 00 f0 bf ee       	push   $0xeebff000
  800f96:	6a 00                	push   $0x0
  800f98:	e8 63 fd ff ff       	call   800d00 <sys_page_alloc>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	78 28                	js     800fcc <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  800fa4:	83 ec 08             	sub    $0x8,%esp
  800fa7:	68 de 0f 80 00       	push   $0x800fde
  800fac:	6a 00                	push   $0x0
  800fae:	e8 d9 fe ff ff       	call   800e8c <sys_env_set_pgfault_upcall>
  800fb3:	83 c4 10             	add    $0x10,%esp
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	79 c8                	jns    800f82 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  800fba:	50                   	push   %eax
  800fbb:	68 d4 16 80 00       	push   $0x8016d4
  800fc0:	6a 23                	push   $0x23
  800fc2:	68 c3 16 80 00       	push   $0x8016c3
  800fc7:	e8 59 f1 ff ff       	call   800125 <_panic>
			panic("set_pgfault_handler %e\n",r);
  800fcc:	50                   	push   %eax
  800fcd:	68 ab 16 80 00       	push   $0x8016ab
  800fd2:	6a 21                	push   $0x21
  800fd4:	68 c3 16 80 00       	push   $0x8016c3
  800fd9:	e8 47 f1 ff ff       	call   800125 <_panic>

00800fde <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800fde:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fdf:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800fe4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fe6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  800fe9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  800fed:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  800ff1:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800ff4:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  800ff6:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  800ffa:	83 c4 08             	add    $0x8,%esp
	popal
  800ffd:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800ffe:	83 c4 04             	add    $0x4,%esp
	popfl
  801001:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801002:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801003:	c3                   	ret    
  801004:	66 90                	xchg   %ax,%ax
  801006:	66 90                	xchg   %ax,%ax
  801008:	66 90                	xchg   %ax,%ax
  80100a:	66 90                	xchg   %ax,%ax
  80100c:	66 90                	xchg   %ax,%ax
  80100e:	66 90                	xchg   %ax,%ax

00801010 <__udivdi3>:
  801010:	55                   	push   %ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
  801014:	83 ec 1c             	sub    $0x1c,%esp
  801017:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80101b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80101f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801023:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801027:	85 d2                	test   %edx,%edx
  801029:	75 4d                	jne    801078 <__udivdi3+0x68>
  80102b:	39 f3                	cmp    %esi,%ebx
  80102d:	76 19                	jbe    801048 <__udivdi3+0x38>
  80102f:	31 ff                	xor    %edi,%edi
  801031:	89 e8                	mov    %ebp,%eax
  801033:	89 f2                	mov    %esi,%edx
  801035:	f7 f3                	div    %ebx
  801037:	89 fa                	mov    %edi,%edx
  801039:	83 c4 1c             	add    $0x1c,%esp
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    
  801041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801048:	89 d9                	mov    %ebx,%ecx
  80104a:	85 db                	test   %ebx,%ebx
  80104c:	75 0b                	jne    801059 <__udivdi3+0x49>
  80104e:	b8 01 00 00 00       	mov    $0x1,%eax
  801053:	31 d2                	xor    %edx,%edx
  801055:	f7 f3                	div    %ebx
  801057:	89 c1                	mov    %eax,%ecx
  801059:	31 d2                	xor    %edx,%edx
  80105b:	89 f0                	mov    %esi,%eax
  80105d:	f7 f1                	div    %ecx
  80105f:	89 c6                	mov    %eax,%esi
  801061:	89 e8                	mov    %ebp,%eax
  801063:	89 f7                	mov    %esi,%edi
  801065:	f7 f1                	div    %ecx
  801067:	89 fa                	mov    %edi,%edx
  801069:	83 c4 1c             	add    $0x1c,%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
  801071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801078:	39 f2                	cmp    %esi,%edx
  80107a:	77 1c                	ja     801098 <__udivdi3+0x88>
  80107c:	0f bd fa             	bsr    %edx,%edi
  80107f:	83 f7 1f             	xor    $0x1f,%edi
  801082:	75 2c                	jne    8010b0 <__udivdi3+0xa0>
  801084:	39 f2                	cmp    %esi,%edx
  801086:	72 06                	jb     80108e <__udivdi3+0x7e>
  801088:	31 c0                	xor    %eax,%eax
  80108a:	39 eb                	cmp    %ebp,%ebx
  80108c:	77 a9                	ja     801037 <__udivdi3+0x27>
  80108e:	b8 01 00 00 00       	mov    $0x1,%eax
  801093:	eb a2                	jmp    801037 <__udivdi3+0x27>
  801095:	8d 76 00             	lea    0x0(%esi),%esi
  801098:	31 ff                	xor    %edi,%edi
  80109a:	31 c0                	xor    %eax,%eax
  80109c:	89 fa                	mov    %edi,%edx
  80109e:	83 c4 1c             	add    $0x1c,%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    
  8010a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010ad:	8d 76 00             	lea    0x0(%esi),%esi
  8010b0:	89 f9                	mov    %edi,%ecx
  8010b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8010b7:	29 f8                	sub    %edi,%eax
  8010b9:	d3 e2                	shl    %cl,%edx
  8010bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010bf:	89 c1                	mov    %eax,%ecx
  8010c1:	89 da                	mov    %ebx,%edx
  8010c3:	d3 ea                	shr    %cl,%edx
  8010c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010c9:	09 d1                	or     %edx,%ecx
  8010cb:	89 f2                	mov    %esi,%edx
  8010cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010d1:	89 f9                	mov    %edi,%ecx
  8010d3:	d3 e3                	shl    %cl,%ebx
  8010d5:	89 c1                	mov    %eax,%ecx
  8010d7:	d3 ea                	shr    %cl,%edx
  8010d9:	89 f9                	mov    %edi,%ecx
  8010db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010df:	89 eb                	mov    %ebp,%ebx
  8010e1:	d3 e6                	shl    %cl,%esi
  8010e3:	89 c1                	mov    %eax,%ecx
  8010e5:	d3 eb                	shr    %cl,%ebx
  8010e7:	09 de                	or     %ebx,%esi
  8010e9:	89 f0                	mov    %esi,%eax
  8010eb:	f7 74 24 08          	divl   0x8(%esp)
  8010ef:	89 d6                	mov    %edx,%esi
  8010f1:	89 c3                	mov    %eax,%ebx
  8010f3:	f7 64 24 0c          	mull   0xc(%esp)
  8010f7:	39 d6                	cmp    %edx,%esi
  8010f9:	72 15                	jb     801110 <__udivdi3+0x100>
  8010fb:	89 f9                	mov    %edi,%ecx
  8010fd:	d3 e5                	shl    %cl,%ebp
  8010ff:	39 c5                	cmp    %eax,%ebp
  801101:	73 04                	jae    801107 <__udivdi3+0xf7>
  801103:	39 d6                	cmp    %edx,%esi
  801105:	74 09                	je     801110 <__udivdi3+0x100>
  801107:	89 d8                	mov    %ebx,%eax
  801109:	31 ff                	xor    %edi,%edi
  80110b:	e9 27 ff ff ff       	jmp    801037 <__udivdi3+0x27>
  801110:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801113:	31 ff                	xor    %edi,%edi
  801115:	e9 1d ff ff ff       	jmp    801037 <__udivdi3+0x27>
  80111a:	66 90                	xchg   %ax,%ax
  80111c:	66 90                	xchg   %ax,%ax
  80111e:	66 90                	xchg   %ax,%ax

00801120 <__umoddi3>:
  801120:	55                   	push   %ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
  801124:	83 ec 1c             	sub    $0x1c,%esp
  801127:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80112b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80112f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801137:	89 da                	mov    %ebx,%edx
  801139:	85 c0                	test   %eax,%eax
  80113b:	75 43                	jne    801180 <__umoddi3+0x60>
  80113d:	39 df                	cmp    %ebx,%edi
  80113f:	76 17                	jbe    801158 <__umoddi3+0x38>
  801141:	89 f0                	mov    %esi,%eax
  801143:	f7 f7                	div    %edi
  801145:	89 d0                	mov    %edx,%eax
  801147:	31 d2                	xor    %edx,%edx
  801149:	83 c4 1c             	add    $0x1c,%esp
  80114c:	5b                   	pop    %ebx
  80114d:	5e                   	pop    %esi
  80114e:	5f                   	pop    %edi
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    
  801151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801158:	89 fd                	mov    %edi,%ebp
  80115a:	85 ff                	test   %edi,%edi
  80115c:	75 0b                	jne    801169 <__umoddi3+0x49>
  80115e:	b8 01 00 00 00       	mov    $0x1,%eax
  801163:	31 d2                	xor    %edx,%edx
  801165:	f7 f7                	div    %edi
  801167:	89 c5                	mov    %eax,%ebp
  801169:	89 d8                	mov    %ebx,%eax
  80116b:	31 d2                	xor    %edx,%edx
  80116d:	f7 f5                	div    %ebp
  80116f:	89 f0                	mov    %esi,%eax
  801171:	f7 f5                	div    %ebp
  801173:	89 d0                	mov    %edx,%eax
  801175:	eb d0                	jmp    801147 <__umoddi3+0x27>
  801177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80117e:	66 90                	xchg   %ax,%ax
  801180:	89 f1                	mov    %esi,%ecx
  801182:	39 d8                	cmp    %ebx,%eax
  801184:	76 0a                	jbe    801190 <__umoddi3+0x70>
  801186:	89 f0                	mov    %esi,%eax
  801188:	83 c4 1c             	add    $0x1c,%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    
  801190:	0f bd e8             	bsr    %eax,%ebp
  801193:	83 f5 1f             	xor    $0x1f,%ebp
  801196:	75 20                	jne    8011b8 <__umoddi3+0x98>
  801198:	39 d8                	cmp    %ebx,%eax
  80119a:	0f 82 b0 00 00 00    	jb     801250 <__umoddi3+0x130>
  8011a0:	39 f7                	cmp    %esi,%edi
  8011a2:	0f 86 a8 00 00 00    	jbe    801250 <__umoddi3+0x130>
  8011a8:	89 c8                	mov    %ecx,%eax
  8011aa:	83 c4 1c             	add    $0x1c,%esp
  8011ad:	5b                   	pop    %ebx
  8011ae:	5e                   	pop    %esi
  8011af:	5f                   	pop    %edi
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    
  8011b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011b8:	89 e9                	mov    %ebp,%ecx
  8011ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8011bf:	29 ea                	sub    %ebp,%edx
  8011c1:	d3 e0                	shl    %cl,%eax
  8011c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011c7:	89 d1                	mov    %edx,%ecx
  8011c9:	89 f8                	mov    %edi,%eax
  8011cb:	d3 e8                	shr    %cl,%eax
  8011cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8011d9:	09 c1                	or     %eax,%ecx
  8011db:	89 d8                	mov    %ebx,%eax
  8011dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011e1:	89 e9                	mov    %ebp,%ecx
  8011e3:	d3 e7                	shl    %cl,%edi
  8011e5:	89 d1                	mov    %edx,%ecx
  8011e7:	d3 e8                	shr    %cl,%eax
  8011e9:	89 e9                	mov    %ebp,%ecx
  8011eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011ef:	d3 e3                	shl    %cl,%ebx
  8011f1:	89 c7                	mov    %eax,%edi
  8011f3:	89 d1                	mov    %edx,%ecx
  8011f5:	89 f0                	mov    %esi,%eax
  8011f7:	d3 e8                	shr    %cl,%eax
  8011f9:	89 e9                	mov    %ebp,%ecx
  8011fb:	89 fa                	mov    %edi,%edx
  8011fd:	d3 e6                	shl    %cl,%esi
  8011ff:	09 d8                	or     %ebx,%eax
  801201:	f7 74 24 08          	divl   0x8(%esp)
  801205:	89 d1                	mov    %edx,%ecx
  801207:	89 f3                	mov    %esi,%ebx
  801209:	f7 64 24 0c          	mull   0xc(%esp)
  80120d:	89 c6                	mov    %eax,%esi
  80120f:	89 d7                	mov    %edx,%edi
  801211:	39 d1                	cmp    %edx,%ecx
  801213:	72 06                	jb     80121b <__umoddi3+0xfb>
  801215:	75 10                	jne    801227 <__umoddi3+0x107>
  801217:	39 c3                	cmp    %eax,%ebx
  801219:	73 0c                	jae    801227 <__umoddi3+0x107>
  80121b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80121f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801223:	89 d7                	mov    %edx,%edi
  801225:	89 c6                	mov    %eax,%esi
  801227:	89 ca                	mov    %ecx,%edx
  801229:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80122e:	29 f3                	sub    %esi,%ebx
  801230:	19 fa                	sbb    %edi,%edx
  801232:	89 d0                	mov    %edx,%eax
  801234:	d3 e0                	shl    %cl,%eax
  801236:	89 e9                	mov    %ebp,%ecx
  801238:	d3 eb                	shr    %cl,%ebx
  80123a:	d3 ea                	shr    %cl,%edx
  80123c:	09 d8                	or     %ebx,%eax
  80123e:	83 c4 1c             	add    $0x1c,%esp
  801241:	5b                   	pop    %ebx
  801242:	5e                   	pop    %esi
  801243:	5f                   	pop    %edi
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    
  801246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80124d:	8d 76 00             	lea    0x0(%esi),%esi
  801250:	89 da                	mov    %ebx,%edx
  801252:	29 fe                	sub    %edi,%esi
  801254:	19 c2                	sbb    %eax,%edx
  801256:	89 f1                	mov    %esi,%ecx
  801258:	89 c8                	mov    %ecx,%eax
  80125a:	e9 4b ff ff ff       	jmp    8011aa <__umoddi3+0x8a>
