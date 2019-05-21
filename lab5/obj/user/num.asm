
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 50 01 00 00       	call   800181 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 43                	jmp    800086 <num+0x53>
		if (bol) {
			printf("%5d ", ++line);
  800043:	a1 00 40 80 00       	mov    0x804000,%eax
  800048:	83 c0 01             	add    $0x1,%eax
  80004b:	a3 00 40 80 00       	mov    %eax,0x804000
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	50                   	push   %eax
  800054:	68 80 21 80 00       	push   $0x802180
  800059:	e8 b6 18 00 00       	call   801914 <printf>
			bol = 0;
  80005e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800065:	00 00 00 
  800068:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	6a 01                	push   $0x1
  800070:	53                   	push   %ebx
  800071:	6a 01                	push   $0x1
  800073:	e8 62 13 00 00       	call   8013da <write>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 f8 01             	cmp    $0x1,%eax
  80007e:	75 24                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800080:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800084:	74 36                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	53                   	push   %ebx
  80008c:	56                   	push   %esi
  80008d:	e8 7c 12 00 00       	call   80130e <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7e 2f                	jle    8000c8 <num+0x95>
		if (bol) {
  800099:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a0:	74 c9                	je     80006b <num+0x38>
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 85 21 80 00       	push   $0x802185
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 a0 21 80 00       	push   $0x8021a0
  8000b7:	e8 20 01 00 00       	call   8001dc <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb be                	jmp    800086 <num+0x53>
	}
	if (n < 0)
  8000c8:	78 07                	js     8000d1 <num+0x9e>
		panic("error reading %s: %e", s, n);
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	68 ab 21 80 00       	push   $0x8021ab
  8000dd:	6a 18                	push   $0x18
  8000df:	68 a0 21 80 00       	push   $0x8021a0
  8000e4:	e8 f3 00 00 00       	call   8001dc <_panic>

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f2:	c7 05 04 30 80 00 c0 	movl   $0x8021c0,0x803004
  8000f9:	21 80 00 
	if (argc == 1)
  8000fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800100:	74 46                	je     800148 <umain+0x5f>
  800102:	8b 45 0c             	mov    0xc(%ebp),%eax
  800105:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800108:	bf 01 00 00 00       	mov    $0x1,%edi
  80010d:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800110:	7d 48                	jge    80015a <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	6a 00                	push   $0x0
  80011a:	ff 33                	pushl  (%ebx)
  80011c:	e8 50 16 00 00       	call   801771 <open>
  800121:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	85 c0                	test   %eax,%eax
  800128:	78 3d                	js     800167 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	ff 33                	pushl  (%ebx)
  80012f:	50                   	push   %eax
  800130:	e8 fe fe ff ff       	call   800033 <num>
				close(f);
  800135:	89 34 24             	mov    %esi,(%esp)
  800138:	e8 93 10 00 00       	call   8011d0 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 c4 21 80 00       	push   $0x8021c4
  800150:	6a 00                	push   $0x0
  800152:	e8 dc fe ff ff       	call   800033 <num>
  800157:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015a:	e8 6b 00 00 00       	call   8001ca <exit>
}
  80015f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	50                   	push   %eax
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	ff 30                	pushl  (%eax)
  800170:	68 cc 21 80 00       	push   $0x8021cc
  800175:	6a 27                	push   $0x27
  800177:	68 a0 21 80 00       	push   $0x8021a0
  80017c:	e8 5b 00 00 00       	call   8001dc <_panic>

00800181 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800189:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80018c:	e8 e8 0b 00 00       	call   800d79 <sys_getenvid>
  800191:	25 ff 03 00 00       	and    $0x3ff,%eax
  800196:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800199:	c1 e0 04             	shl    $0x4,%eax
  80019c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a1:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a6:	85 db                	test   %ebx,%ebx
  8001a8:	7e 07                	jle    8001b1 <libmain+0x30>
		binaryname = argv[0];
  8001aa:	8b 06                	mov    (%esi),%eax
  8001ac:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
  8001b6:	e8 2e ff ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  8001bb:	e8 0a 00 00 00       	call   8001ca <exit>
}
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c6:	5b                   	pop    %ebx
  8001c7:	5e                   	pop    %esi
  8001c8:	5d                   	pop    %ebp
  8001c9:	c3                   	ret    

008001ca <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8001d0:	6a 00                	push   $0x0
  8001d2:	e8 61 0b 00 00       	call   800d38 <sys_env_destroy>
}
  8001d7:	83 c4 10             	add    $0x10,%esp
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    

008001dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001e1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001e4:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001ea:	e8 8a 0b 00 00       	call   800d79 <sys_getenvid>
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	ff 75 0c             	pushl  0xc(%ebp)
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	56                   	push   %esi
  8001f9:	50                   	push   %eax
  8001fa:	68 e8 21 80 00       	push   $0x8021e8
  8001ff:	e8 b3 00 00 00       	call   8002b7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800204:	83 c4 18             	add    $0x18,%esp
  800207:	53                   	push   %ebx
  800208:	ff 75 10             	pushl  0x10(%ebp)
  80020b:	e8 56 00 00 00       	call   800266 <vcprintf>
	cprintf("\n");
  800210:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  800217:	e8 9b 00 00 00       	call   8002b7 <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80021f:	cc                   	int3   
  800220:	eb fd                	jmp    80021f <_panic+0x43>

00800222 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	53                   	push   %ebx
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022c:	8b 13                	mov    (%ebx),%edx
  80022e:	8d 42 01             	lea    0x1(%edx),%eax
  800231:	89 03                	mov    %eax,(%ebx)
  800233:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800236:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80023a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023f:	74 09                	je     80024a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800241:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800248:	c9                   	leave  
  800249:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	68 ff 00 00 00       	push   $0xff
  800252:	8d 43 08             	lea    0x8(%ebx),%eax
  800255:	50                   	push   %eax
  800256:	e8 a0 0a 00 00       	call   800cfb <sys_cputs>
		b->idx = 0;
  80025b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	eb db                	jmp    800241 <putch+0x1f>

00800266 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800276:	00 00 00 
	b.cnt = 0;
  800279:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800280:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028f:	50                   	push   %eax
  800290:	68 22 02 80 00       	push   $0x800222
  800295:	e8 4a 01 00 00       	call   8003e4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80029a:	83 c4 08             	add    $0x8,%esp
  80029d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002a3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a9:	50                   	push   %eax
  8002aa:	e8 4c 0a 00 00       	call   800cfb <sys_cputs>

	return b.cnt;
}
  8002af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b5:	c9                   	leave  
  8002b6:	c3                   	ret    

008002b7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002bd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c0:	50                   	push   %eax
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 9d ff ff ff       	call   800266 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c9:	c9                   	leave  
  8002ca:	c3                   	ret    

008002cb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	57                   	push   %edi
  8002cf:	56                   	push   %esi
  8002d0:	53                   	push   %ebx
  8002d1:	83 ec 1c             	sub    $0x1c,%esp
  8002d4:	89 c6                	mov    %eax,%esi
  8002d6:	89 d7                	mov    %edx,%edi
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002ea:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ee:	74 2c                	je     80031c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800300:	39 c2                	cmp    %eax,%edx
  800302:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800305:	73 43                	jae    80034a <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800307:	83 eb 01             	sub    $0x1,%ebx
  80030a:	85 db                	test   %ebx,%ebx
  80030c:	7e 6c                	jle    80037a <printnum+0xaf>
			putch(padc, putdat);
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	57                   	push   %edi
  800312:	ff 75 18             	pushl  0x18(%ebp)
  800315:	ff d6                	call   *%esi
  800317:	83 c4 10             	add    $0x10,%esp
  80031a:	eb eb                	jmp    800307 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	6a 20                	push   $0x20
  800321:	6a 00                	push   $0x0
  800323:	50                   	push   %eax
  800324:	ff 75 e4             	pushl  -0x1c(%ebp)
  800327:	ff 75 e0             	pushl  -0x20(%ebp)
  80032a:	89 fa                	mov    %edi,%edx
  80032c:	89 f0                	mov    %esi,%eax
  80032e:	e8 98 ff ff ff       	call   8002cb <printnum>
		while (--width > 0)
  800333:	83 c4 20             	add    $0x20,%esp
  800336:	83 eb 01             	sub    $0x1,%ebx
  800339:	85 db                	test   %ebx,%ebx
  80033b:	7e 65                	jle    8003a2 <printnum+0xd7>
			putch(padc, putdat);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	57                   	push   %edi
  800341:	6a 20                	push   $0x20
  800343:	ff d6                	call   *%esi
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	eb ec                	jmp    800336 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	ff 75 18             	pushl  0x18(%ebp)
  800350:	83 eb 01             	sub    $0x1,%ebx
  800353:	53                   	push   %ebx
  800354:	50                   	push   %eax
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	ff 75 dc             	pushl  -0x24(%ebp)
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800361:	ff 75 e0             	pushl  -0x20(%ebp)
  800364:	e8 b7 1b 00 00       	call   801f20 <__udivdi3>
  800369:	83 c4 18             	add    $0x18,%esp
  80036c:	52                   	push   %edx
  80036d:	50                   	push   %eax
  80036e:	89 fa                	mov    %edi,%edx
  800370:	89 f0                	mov    %esi,%eax
  800372:	e8 54 ff ff ff       	call   8002cb <printnum>
  800377:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	57                   	push   %edi
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	ff 75 dc             	pushl  -0x24(%ebp)
  800384:	ff 75 d8             	pushl  -0x28(%ebp)
  800387:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038a:	ff 75 e0             	pushl  -0x20(%ebp)
  80038d:	e8 9e 1c 00 00       	call   802030 <__umoddi3>
  800392:	83 c4 14             	add    $0x14,%esp
  800395:	0f be 80 0b 22 80 00 	movsbl 0x80220b(%eax),%eax
  80039c:	50                   	push   %eax
  80039d:	ff d6                	call   *%esi
  80039f:	83 c4 10             	add    $0x10,%esp
}
  8003a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a5:	5b                   	pop    %ebx
  8003a6:	5e                   	pop    %esi
  8003a7:	5f                   	pop    %edi
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b4:	8b 10                	mov    (%eax),%edx
  8003b6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b9:	73 0a                	jae    8003c5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003be:	89 08                	mov    %ecx,(%eax)
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	88 02                	mov    %al,(%edx)
}
  8003c5:	5d                   	pop    %ebp
  8003c6:	c3                   	ret    

008003c7 <printfmt>:
{
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003cd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003d0:	50                   	push   %eax
  8003d1:	ff 75 10             	pushl  0x10(%ebp)
  8003d4:	ff 75 0c             	pushl  0xc(%ebp)
  8003d7:	ff 75 08             	pushl  0x8(%ebp)
  8003da:	e8 05 00 00 00       	call   8003e4 <vprintfmt>
}
  8003df:	83 c4 10             	add    $0x10,%esp
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <vprintfmt>:
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	57                   	push   %edi
  8003e8:	56                   	push   %esi
  8003e9:	53                   	push   %ebx
  8003ea:	83 ec 3c             	sub    $0x3c,%esp
  8003ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003f3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003f6:	e9 b4 03 00 00       	jmp    8007af <vprintfmt+0x3cb>
		padc = ' ';
  8003fb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8003ff:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800406:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80040d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800414:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80041b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800420:	8d 47 01             	lea    0x1(%edi),%eax
  800423:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800426:	0f b6 17             	movzbl (%edi),%edx
  800429:	8d 42 dd             	lea    -0x23(%edx),%eax
  80042c:	3c 55                	cmp    $0x55,%al
  80042e:	0f 87 c8 04 00 00    	ja     8008fc <vprintfmt+0x518>
  800434:	0f b6 c0             	movzbl %al,%eax
  800437:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  80043e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800441:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800448:	eb d6                	jmp    800420 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80044d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800451:	eb cd                	jmp    800420 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800453:	0f b6 d2             	movzbl %dl,%edx
  800456:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800459:	b8 00 00 00 00       	mov    $0x0,%eax
  80045e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800461:	eb 0c                	jmp    80046f <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800466:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80046a:	eb b4                	jmp    800420 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80046c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80046f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800472:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800476:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800479:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80047c:	83 f9 09             	cmp    $0x9,%ecx
  80047f:	76 eb                	jbe    80046c <vprintfmt+0x88>
  800481:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800484:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800487:	eb 14                	jmp    80049d <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800489:	8b 45 14             	mov    0x14(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	8d 40 04             	lea    0x4(%eax),%eax
  800497:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80049d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a1:	0f 89 79 ff ff ff    	jns    800420 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8004a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004b4:	e9 67 ff ff ff       	jmp    800420 <vprintfmt+0x3c>
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	85 c0                	test   %eax,%eax
  8004be:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c3:	0f 49 d0             	cmovns %eax,%edx
  8004c6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004cc:	e9 4f ff ff ff       	jmp    800420 <vprintfmt+0x3c>
  8004d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004db:	e9 40 ff ff ff       	jmp    800420 <vprintfmt+0x3c>
			lflag++;
  8004e0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004e6:	e9 35 ff ff ff       	jmp    800420 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8d 78 04             	lea    0x4(%eax),%edi
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	53                   	push   %ebx
  8004f5:	ff 30                	pushl  (%eax)
  8004f7:	ff d6                	call   *%esi
			break;
  8004f9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004fc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004ff:	e9 a8 02 00 00       	jmp    8007ac <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8d 78 04             	lea    0x4(%eax),%edi
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	99                   	cltd   
  80050d:	31 d0                	xor    %edx,%eax
  80050f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800511:	83 f8 0f             	cmp    $0xf,%eax
  800514:	7f 23                	jg     800539 <vprintfmt+0x155>
  800516:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  80051d:	85 d2                	test   %edx,%edx
  80051f:	74 18                	je     800539 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800521:	52                   	push   %edx
  800522:	68 55 26 80 00       	push   $0x802655
  800527:	53                   	push   %ebx
  800528:	56                   	push   %esi
  800529:	e8 99 fe ff ff       	call   8003c7 <printfmt>
  80052e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800531:	89 7d 14             	mov    %edi,0x14(%ebp)
  800534:	e9 73 02 00 00       	jmp    8007ac <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800539:	50                   	push   %eax
  80053a:	68 23 22 80 00       	push   $0x802223
  80053f:	53                   	push   %ebx
  800540:	56                   	push   %esi
  800541:	e8 81 fe ff ff       	call   8003c7 <printfmt>
  800546:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800549:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80054c:	e9 5b 02 00 00       	jmp    8007ac <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	83 c0 04             	add    $0x4,%eax
  800557:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80055f:	85 d2                	test   %edx,%edx
  800561:	b8 1c 22 80 00       	mov    $0x80221c,%eax
  800566:	0f 45 c2             	cmovne %edx,%eax
  800569:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80056c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800570:	7e 06                	jle    800578 <vprintfmt+0x194>
  800572:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800576:	75 0d                	jne    800585 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 c7                	mov    %eax,%edi
  80057d:	03 45 e0             	add    -0x20(%ebp),%eax
  800580:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800583:	eb 53                	jmp    8005d8 <vprintfmt+0x1f4>
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 d8             	pushl  -0x28(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 13 04 00 00       	call   8009a4 <strnlen>
  800591:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800594:	29 c1                	sub    %eax,%ecx
  800596:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80059e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a5:	eb 0f                	jmp    8005b6 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	53                   	push   %ebx
  8005ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ae:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	83 ef 01             	sub    $0x1,%edi
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	85 ff                	test   %edi,%edi
  8005b8:	7f ed                	jg     8005a7 <vprintfmt+0x1c3>
  8005ba:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005bd:	85 d2                	test   %edx,%edx
  8005bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c4:	0f 49 c2             	cmovns %edx,%eax
  8005c7:	29 c2                	sub    %eax,%edx
  8005c9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005cc:	eb aa                	jmp    800578 <vprintfmt+0x194>
					putch(ch, putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	52                   	push   %edx
  8005d3:	ff d6                	call   *%esi
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005db:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005dd:	83 c7 01             	add    $0x1,%edi
  8005e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005e4:	0f be d0             	movsbl %al,%edx
  8005e7:	85 d2                	test   %edx,%edx
  8005e9:	74 4b                	je     800636 <vprintfmt+0x252>
  8005eb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ef:	78 06                	js     8005f7 <vprintfmt+0x213>
  8005f1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005f5:	78 1e                	js     800615 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8005f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005fb:	74 d1                	je     8005ce <vprintfmt+0x1ea>
  8005fd:	0f be c0             	movsbl %al,%eax
  800600:	83 e8 20             	sub    $0x20,%eax
  800603:	83 f8 5e             	cmp    $0x5e,%eax
  800606:	76 c6                	jbe    8005ce <vprintfmt+0x1ea>
					putch('?', putdat);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	53                   	push   %ebx
  80060c:	6a 3f                	push   $0x3f
  80060e:	ff d6                	call   *%esi
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	eb c3                	jmp    8005d8 <vprintfmt+0x1f4>
  800615:	89 cf                	mov    %ecx,%edi
  800617:	eb 0e                	jmp    800627 <vprintfmt+0x243>
				putch(' ', putdat);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 20                	push   $0x20
  80061f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800621:	83 ef 01             	sub    $0x1,%edi
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	85 ff                	test   %edi,%edi
  800629:	7f ee                	jg     800619 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80062b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
  800631:	e9 76 01 00 00       	jmp    8007ac <vprintfmt+0x3c8>
  800636:	89 cf                	mov    %ecx,%edi
  800638:	eb ed                	jmp    800627 <vprintfmt+0x243>
	if (lflag >= 2)
  80063a:	83 f9 01             	cmp    $0x1,%ecx
  80063d:	7f 1f                	jg     80065e <vprintfmt+0x27a>
	else if (lflag)
  80063f:	85 c9                	test   %ecx,%ecx
  800641:	74 6a                	je     8006ad <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064b:	89 c1                	mov    %eax,%ecx
  80064d:	c1 f9 1f             	sar    $0x1f,%ecx
  800650:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8d 40 04             	lea    0x4(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
  80065c:	eb 17                	jmp    800675 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 50 04             	mov    0x4(%eax),%edx
  800664:	8b 00                	mov    (%eax),%eax
  800666:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800669:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 40 08             	lea    0x8(%eax),%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800675:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800678:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80067d:	85 d2                	test   %edx,%edx
  80067f:	0f 89 f8 00 00 00    	jns    80077d <vprintfmt+0x399>
				putch('-', putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	6a 2d                	push   $0x2d
  80068b:	ff d6                	call   *%esi
				num = -(long long) num;
  80068d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800690:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800693:	f7 d8                	neg    %eax
  800695:	83 d2 00             	adc    $0x0,%edx
  800698:	f7 da                	neg    %edx
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006a8:	e9 e1 00 00 00       	jmp    80078e <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b5:	99                   	cltd   
  8006b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8d 40 04             	lea    0x4(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c2:	eb b1                	jmp    800675 <vprintfmt+0x291>
	if (lflag >= 2)
  8006c4:	83 f9 01             	cmp    $0x1,%ecx
  8006c7:	7f 27                	jg     8006f0 <vprintfmt+0x30c>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	74 41                	je     80070e <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 04             	lea    0x4(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006eb:	e9 8d 00 00 00       	jmp    80077d <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8b 50 04             	mov    0x4(%eax),%edx
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 40 08             	lea    0x8(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800707:	bf 0a 00 00 00       	mov    $0xa,%edi
  80070c:	eb 6f                	jmp    80077d <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 40 04             	lea    0x4(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800727:	bf 0a 00 00 00       	mov    $0xa,%edi
  80072c:	eb 4f                	jmp    80077d <vprintfmt+0x399>
	if (lflag >= 2)
  80072e:	83 f9 01             	cmp    $0x1,%ecx
  800731:	7f 23                	jg     800756 <vprintfmt+0x372>
	else if (lflag)
  800733:	85 c9                	test   %ecx,%ecx
  800735:	0f 84 98 00 00 00    	je     8007d3 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8d 40 04             	lea    0x4(%eax),%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
  800754:	eb 17                	jmp    80076d <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 50 04             	mov    0x4(%eax),%edx
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800761:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 40 08             	lea    0x8(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	53                   	push   %ebx
  800771:	6a 30                	push   $0x30
  800773:	ff d6                	call   *%esi
			goto number;
  800775:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800778:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  80077d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800781:	74 0b                	je     80078e <vprintfmt+0x3aa>
				putch('+', putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 2b                	push   $0x2b
  800789:	ff d6                	call   *%esi
  80078b:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80078e:	83 ec 0c             	sub    $0xc,%esp
  800791:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800795:	50                   	push   %eax
  800796:	ff 75 e0             	pushl  -0x20(%ebp)
  800799:	57                   	push   %edi
  80079a:	ff 75 dc             	pushl  -0x24(%ebp)
  80079d:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a0:	89 da                	mov    %ebx,%edx
  8007a2:	89 f0                	mov    %esi,%eax
  8007a4:	e8 22 fb ff ff       	call   8002cb <printnum>
			break;
  8007a9:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007af:	83 c7 01             	add    $0x1,%edi
  8007b2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b6:	83 f8 25             	cmp    $0x25,%eax
  8007b9:	0f 84 3c fc ff ff    	je     8003fb <vprintfmt+0x17>
			if (ch == '\0')
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	0f 84 55 01 00 00    	je     80091c <vprintfmt+0x538>
			putch(ch, putdat);
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	50                   	push   %eax
  8007cc:	ff d6                	call   *%esi
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	eb dc                	jmp    8007af <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ec:	e9 7c ff ff ff       	jmp    80076d <vprintfmt+0x389>
			putch('0', putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	53                   	push   %ebx
  8007f5:	6a 30                	push   $0x30
  8007f7:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f9:	83 c4 08             	add    $0x8,%esp
  8007fc:	53                   	push   %ebx
  8007fd:	6a 78                	push   $0x78
  8007ff:	ff d6                	call   *%esi
			num = (unsigned long long)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800811:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081d:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800822:	e9 56 ff ff ff       	jmp    80077d <vprintfmt+0x399>
	if (lflag >= 2)
  800827:	83 f9 01             	cmp    $0x1,%ecx
  80082a:	7f 27                	jg     800853 <vprintfmt+0x46f>
	else if (lflag)
  80082c:	85 c9                	test   %ecx,%ecx
  80082e:	74 44                	je     800874 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	ba 00 00 00 00       	mov    $0x0,%edx
  80083a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8d 40 04             	lea    0x4(%eax),%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800849:	bf 10 00 00 00       	mov    $0x10,%edi
  80084e:	e9 2a ff ff ff       	jmp    80077d <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8b 50 04             	mov    0x4(%eax),%edx
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8d 40 08             	lea    0x8(%eax),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80086a:	bf 10 00 00 00       	mov    $0x10,%edi
  80086f:	e9 09 ff ff ff       	jmp    80077d <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	ba 00 00 00 00       	mov    $0x0,%edx
  80087e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800881:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8d 40 04             	lea    0x4(%eax),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088d:	bf 10 00 00 00       	mov    $0x10,%edi
  800892:	e9 e6 fe ff ff       	jmp    80077d <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 78 04             	lea    0x4(%eax),%edi
  80089d:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	74 2d                	je     8008d0 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8008a3:	0f b6 13             	movzbl (%ebx),%edx
  8008a6:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008a8:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8008ab:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8008ae:	0f 8e f8 fe ff ff    	jle    8007ac <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8008b4:	68 78 23 80 00       	push   $0x802378
  8008b9:	68 55 26 80 00       	push   $0x802655
  8008be:	53                   	push   %ebx
  8008bf:	56                   	push   %esi
  8008c0:	e8 02 fb ff ff       	call   8003c7 <printfmt>
  8008c5:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008c8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008cb:	e9 dc fe ff ff       	jmp    8007ac <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8008d0:	68 40 23 80 00       	push   $0x802340
  8008d5:	68 55 26 80 00       	push   $0x802655
  8008da:	53                   	push   %ebx
  8008db:	56                   	push   %esi
  8008dc:	e8 e6 fa ff ff       	call   8003c7 <printfmt>
  8008e1:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008e4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008e7:	e9 c0 fe ff ff       	jmp    8007ac <vprintfmt+0x3c8>
			putch(ch, putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	53                   	push   %ebx
  8008f0:	6a 25                	push   $0x25
  8008f2:	ff d6                	call   *%esi
			break;
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	e9 b0 fe ff ff       	jmp    8007ac <vprintfmt+0x3c8>
			putch('%', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 25                	push   $0x25
  800902:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	89 f8                	mov    %edi,%eax
  800909:	eb 03                	jmp    80090e <vprintfmt+0x52a>
  80090b:	83 e8 01             	sub    $0x1,%eax
  80090e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800912:	75 f7                	jne    80090b <vprintfmt+0x527>
  800914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800917:	e9 90 fe ff ff       	jmp    8007ac <vprintfmt+0x3c8>
}
  80091c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5f                   	pop    %edi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 18             	sub    $0x18,%esp
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800930:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800933:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800937:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800941:	85 c0                	test   %eax,%eax
  800943:	74 26                	je     80096b <vsnprintf+0x47>
  800945:	85 d2                	test   %edx,%edx
  800947:	7e 22                	jle    80096b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800949:	ff 75 14             	pushl  0x14(%ebp)
  80094c:	ff 75 10             	pushl  0x10(%ebp)
  80094f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800952:	50                   	push   %eax
  800953:	68 aa 03 80 00       	push   $0x8003aa
  800958:	e8 87 fa ff ff       	call   8003e4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80095d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800960:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800966:	83 c4 10             	add    $0x10,%esp
}
  800969:	c9                   	leave  
  80096a:	c3                   	ret    
		return -E_INVAL;
  80096b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800970:	eb f7                	jmp    800969 <vsnprintf+0x45>

00800972 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800978:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80097b:	50                   	push   %eax
  80097c:	ff 75 10             	pushl  0x10(%ebp)
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	ff 75 08             	pushl  0x8(%ebp)
  800985:	e8 9a ff ff ff       	call   800924 <vsnprintf>
	va_end(ap);

	return rc;
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800992:	b8 00 00 00 00       	mov    $0x0,%eax
  800997:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80099b:	74 05                	je     8009a2 <strlen+0x16>
		n++;
  80099d:	83 c0 01             	add    $0x1,%eax
  8009a0:	eb f5                	jmp    800997 <strlen+0xb>
	return n;
}
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009aa:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b2:	39 c2                	cmp    %eax,%edx
  8009b4:	74 0d                	je     8009c3 <strnlen+0x1f>
  8009b6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009ba:	74 05                	je     8009c1 <strnlen+0x1d>
		n++;
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	eb f1                	jmp    8009b2 <strnlen+0xe>
  8009c1:	89 d0                	mov    %edx,%eax
	return n;
}
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	53                   	push   %ebx
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009d8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009db:	83 c2 01             	add    $0x1,%edx
  8009de:	84 c9                	test   %cl,%cl
  8009e0:	75 f2                	jne    8009d4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	53                   	push   %ebx
  8009e9:	83 ec 10             	sub    $0x10,%esp
  8009ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ef:	53                   	push   %ebx
  8009f0:	e8 97 ff ff ff       	call   80098c <strlen>
  8009f5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	01 d8                	add    %ebx,%eax
  8009fd:	50                   	push   %eax
  8009fe:	e8 c2 ff ff ff       	call   8009c5 <strcpy>
	return dst;
}
  800a03:	89 d8                	mov    %ebx,%eax
  800a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a15:	89 c6                	mov    %eax,%esi
  800a17:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1a:	89 c2                	mov    %eax,%edx
  800a1c:	39 f2                	cmp    %esi,%edx
  800a1e:	74 11                	je     800a31 <strncpy+0x27>
		*dst++ = *src;
  800a20:	83 c2 01             	add    $0x1,%edx
  800a23:	0f b6 19             	movzbl (%ecx),%ebx
  800a26:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a29:	80 fb 01             	cmp    $0x1,%bl
  800a2c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a2f:	eb eb                	jmp    800a1c <strncpy+0x12>
	}
	return ret;
}
  800a31:	5b                   	pop    %ebx
  800a32:	5e                   	pop    %esi
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    

00800a35 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a40:	8b 55 10             	mov    0x10(%ebp),%edx
  800a43:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a45:	85 d2                	test   %edx,%edx
  800a47:	74 21                	je     800a6a <strlcpy+0x35>
  800a49:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a4d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a4f:	39 c2                	cmp    %eax,%edx
  800a51:	74 14                	je     800a67 <strlcpy+0x32>
  800a53:	0f b6 19             	movzbl (%ecx),%ebx
  800a56:	84 db                	test   %bl,%bl
  800a58:	74 0b                	je     800a65 <strlcpy+0x30>
			*dst++ = *src++;
  800a5a:	83 c1 01             	add    $0x1,%ecx
  800a5d:	83 c2 01             	add    $0x1,%edx
  800a60:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a63:	eb ea                	jmp    800a4f <strlcpy+0x1a>
  800a65:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a67:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a6a:	29 f0                	sub    %esi,%eax
}
  800a6c:	5b                   	pop    %ebx
  800a6d:	5e                   	pop    %esi
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a76:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a79:	0f b6 01             	movzbl (%ecx),%eax
  800a7c:	84 c0                	test   %al,%al
  800a7e:	74 0c                	je     800a8c <strcmp+0x1c>
  800a80:	3a 02                	cmp    (%edx),%al
  800a82:	75 08                	jne    800a8c <strcmp+0x1c>
		p++, q++;
  800a84:	83 c1 01             	add    $0x1,%ecx
  800a87:	83 c2 01             	add    $0x1,%edx
  800a8a:	eb ed                	jmp    800a79 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8c:	0f b6 c0             	movzbl %al,%eax
  800a8f:	0f b6 12             	movzbl (%edx),%edx
  800a92:	29 d0                	sub    %edx,%eax
}
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	53                   	push   %ebx
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa0:	89 c3                	mov    %eax,%ebx
  800aa2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa5:	eb 06                	jmp    800aad <strncmp+0x17>
		n--, p++, q++;
  800aa7:	83 c0 01             	add    $0x1,%eax
  800aaa:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aad:	39 d8                	cmp    %ebx,%eax
  800aaf:	74 16                	je     800ac7 <strncmp+0x31>
  800ab1:	0f b6 08             	movzbl (%eax),%ecx
  800ab4:	84 c9                	test   %cl,%cl
  800ab6:	74 04                	je     800abc <strncmp+0x26>
  800ab8:	3a 0a                	cmp    (%edx),%cl
  800aba:	74 eb                	je     800aa7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800abc:	0f b6 00             	movzbl (%eax),%eax
  800abf:	0f b6 12             	movzbl (%edx),%edx
  800ac2:	29 d0                	sub    %edx,%eax
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    
		return 0;
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  800acc:	eb f6                	jmp    800ac4 <strncmp+0x2e>

00800ace <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad8:	0f b6 10             	movzbl (%eax),%edx
  800adb:	84 d2                	test   %dl,%dl
  800add:	74 09                	je     800ae8 <strchr+0x1a>
		if (*s == c)
  800adf:	38 ca                	cmp    %cl,%dl
  800ae1:	74 0a                	je     800aed <strchr+0x1f>
	for (; *s; s++)
  800ae3:	83 c0 01             	add    $0x1,%eax
  800ae6:	eb f0                	jmp    800ad8 <strchr+0xa>
			return (char *) s;
	return 0;
  800ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800afc:	38 ca                	cmp    %cl,%dl
  800afe:	74 09                	je     800b09 <strfind+0x1a>
  800b00:	84 d2                	test   %dl,%dl
  800b02:	74 05                	je     800b09 <strfind+0x1a>
	for (; *s; s++)
  800b04:	83 c0 01             	add    $0x1,%eax
  800b07:	eb f0                	jmp    800af9 <strfind+0xa>
			break;
	return (char *) s;
}
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	57                   	push   %edi
  800b0f:	56                   	push   %esi
  800b10:	53                   	push   %ebx
  800b11:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b17:	85 c9                	test   %ecx,%ecx
  800b19:	74 31                	je     800b4c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b1b:	89 f8                	mov    %edi,%eax
  800b1d:	09 c8                	or     %ecx,%eax
  800b1f:	a8 03                	test   $0x3,%al
  800b21:	75 23                	jne    800b46 <memset+0x3b>
		c &= 0xFF;
  800b23:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b27:	89 d3                	mov    %edx,%ebx
  800b29:	c1 e3 08             	shl    $0x8,%ebx
  800b2c:	89 d0                	mov    %edx,%eax
  800b2e:	c1 e0 18             	shl    $0x18,%eax
  800b31:	89 d6                	mov    %edx,%esi
  800b33:	c1 e6 10             	shl    $0x10,%esi
  800b36:	09 f0                	or     %esi,%eax
  800b38:	09 c2                	or     %eax,%edx
  800b3a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b3c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b3f:	89 d0                	mov    %edx,%eax
  800b41:	fc                   	cld    
  800b42:	f3 ab                	rep stos %eax,%es:(%edi)
  800b44:	eb 06                	jmp    800b4c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	fc                   	cld    
  800b4a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b4c:	89 f8                	mov    %edi,%eax
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b61:	39 c6                	cmp    %eax,%esi
  800b63:	73 32                	jae    800b97 <memmove+0x44>
  800b65:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b68:	39 c2                	cmp    %eax,%edx
  800b6a:	76 2b                	jbe    800b97 <memmove+0x44>
		s += n;
		d += n;
  800b6c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6f:	89 fe                	mov    %edi,%esi
  800b71:	09 ce                	or     %ecx,%esi
  800b73:	09 d6                	or     %edx,%esi
  800b75:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b7b:	75 0e                	jne    800b8b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b7d:	83 ef 04             	sub    $0x4,%edi
  800b80:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b83:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b86:	fd                   	std    
  800b87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b89:	eb 09                	jmp    800b94 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b8b:	83 ef 01             	sub    $0x1,%edi
  800b8e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b91:	fd                   	std    
  800b92:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b94:	fc                   	cld    
  800b95:	eb 1a                	jmp    800bb1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b97:	89 c2                	mov    %eax,%edx
  800b99:	09 ca                	or     %ecx,%edx
  800b9b:	09 f2                	or     %esi,%edx
  800b9d:	f6 c2 03             	test   $0x3,%dl
  800ba0:	75 0a                	jne    800bac <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ba2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	fc                   	cld    
  800ba8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800baa:	eb 05                	jmp    800bb1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bac:	89 c7                	mov    %eax,%edi
  800bae:	fc                   	cld    
  800baf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bbb:	ff 75 10             	pushl  0x10(%ebp)
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	ff 75 08             	pushl  0x8(%ebp)
  800bc4:	e8 8a ff ff ff       	call   800b53 <memmove>
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd6:	89 c6                	mov    %eax,%esi
  800bd8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdb:	39 f0                	cmp    %esi,%eax
  800bdd:	74 1c                	je     800bfb <memcmp+0x30>
		if (*s1 != *s2)
  800bdf:	0f b6 08             	movzbl (%eax),%ecx
  800be2:	0f b6 1a             	movzbl (%edx),%ebx
  800be5:	38 d9                	cmp    %bl,%cl
  800be7:	75 08                	jne    800bf1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be9:	83 c0 01             	add    $0x1,%eax
  800bec:	83 c2 01             	add    $0x1,%edx
  800bef:	eb ea                	jmp    800bdb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bf1:	0f b6 c1             	movzbl %cl,%eax
  800bf4:	0f b6 db             	movzbl %bl,%ebx
  800bf7:	29 d8                	sub    %ebx,%eax
  800bf9:	eb 05                	jmp    800c00 <memcmp+0x35>
	}

	return 0;
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c0d:	89 c2                	mov    %eax,%edx
  800c0f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c12:	39 d0                	cmp    %edx,%eax
  800c14:	73 09                	jae    800c1f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c16:	38 08                	cmp    %cl,(%eax)
  800c18:	74 05                	je     800c1f <memfind+0x1b>
	for (; s < ends; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	eb f3                	jmp    800c12 <memfind+0xe>
			break;
	return (void *) s;
}
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
  800c27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2d:	eb 03                	jmp    800c32 <strtol+0x11>
		s++;
  800c2f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c32:	0f b6 01             	movzbl (%ecx),%eax
  800c35:	3c 20                	cmp    $0x20,%al
  800c37:	74 f6                	je     800c2f <strtol+0xe>
  800c39:	3c 09                	cmp    $0x9,%al
  800c3b:	74 f2                	je     800c2f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c3d:	3c 2b                	cmp    $0x2b,%al
  800c3f:	74 2a                	je     800c6b <strtol+0x4a>
	int neg = 0;
  800c41:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c46:	3c 2d                	cmp    $0x2d,%al
  800c48:	74 2b                	je     800c75 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c50:	75 0f                	jne    800c61 <strtol+0x40>
  800c52:	80 39 30             	cmpb   $0x30,(%ecx)
  800c55:	74 28                	je     800c7f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c57:	85 db                	test   %ebx,%ebx
  800c59:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5e:	0f 44 d8             	cmove  %eax,%ebx
  800c61:	b8 00 00 00 00       	mov    $0x0,%eax
  800c66:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c69:	eb 50                	jmp    800cbb <strtol+0x9a>
		s++;
  800c6b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c6e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c73:	eb d5                	jmp    800c4a <strtol+0x29>
		s++, neg = 1;
  800c75:	83 c1 01             	add    $0x1,%ecx
  800c78:	bf 01 00 00 00       	mov    $0x1,%edi
  800c7d:	eb cb                	jmp    800c4a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c7f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c83:	74 0e                	je     800c93 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	75 d8                	jne    800c61 <strtol+0x40>
		s++, base = 8;
  800c89:	83 c1 01             	add    $0x1,%ecx
  800c8c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c91:	eb ce                	jmp    800c61 <strtol+0x40>
		s += 2, base = 16;
  800c93:	83 c1 02             	add    $0x2,%ecx
  800c96:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c9b:	eb c4                	jmp    800c61 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c9d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ca0:	89 f3                	mov    %esi,%ebx
  800ca2:	80 fb 19             	cmp    $0x19,%bl
  800ca5:	77 29                	ja     800cd0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ca7:	0f be d2             	movsbl %dl,%edx
  800caa:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cad:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cb0:	7d 30                	jge    800ce2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cb2:	83 c1 01             	add    $0x1,%ecx
  800cb5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cbb:	0f b6 11             	movzbl (%ecx),%edx
  800cbe:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cc1:	89 f3                	mov    %esi,%ebx
  800cc3:	80 fb 09             	cmp    $0x9,%bl
  800cc6:	77 d5                	ja     800c9d <strtol+0x7c>
			dig = *s - '0';
  800cc8:	0f be d2             	movsbl %dl,%edx
  800ccb:	83 ea 30             	sub    $0x30,%edx
  800cce:	eb dd                	jmp    800cad <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cd0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cd3:	89 f3                	mov    %esi,%ebx
  800cd5:	80 fb 19             	cmp    $0x19,%bl
  800cd8:	77 08                	ja     800ce2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cda:	0f be d2             	movsbl %dl,%edx
  800cdd:	83 ea 37             	sub    $0x37,%edx
  800ce0:	eb cb                	jmp    800cad <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ce2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce6:	74 05                	je     800ced <strtol+0xcc>
		*endptr = (char *) s;
  800ce8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ceb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ced:	89 c2                	mov    %eax,%edx
  800cef:	f7 da                	neg    %edx
  800cf1:	85 ff                	test   %edi,%edi
  800cf3:	0f 45 c2             	cmovne %edx,%eax
}
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	8b 55 08             	mov    0x8(%ebp),%edx
  800d09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0c:	89 c3                	mov    %eax,%ebx
  800d0e:	89 c7                	mov    %eax,%edi
  800d10:	89 c6                	mov    %eax,%esi
  800d12:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d24:	b8 01 00 00 00       	mov    $0x1,%eax
  800d29:	89 d1                	mov    %edx,%ecx
  800d2b:	89 d3                	mov    %edx,%ebx
  800d2d:	89 d7                	mov    %edx,%edi
  800d2f:	89 d6                	mov    %edx,%esi
  800d31:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
  800d3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4e:	89 cb                	mov    %ecx,%ebx
  800d50:	89 cf                	mov    %ecx,%edi
  800d52:	89 ce                	mov    %ecx,%esi
  800d54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	7f 08                	jg     800d62 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d62:	83 ec 0c             	sub    $0xc,%esp
  800d65:	50                   	push   %eax
  800d66:	6a 03                	push   $0x3
  800d68:	68 80 25 80 00       	push   $0x802580
  800d6d:	6a 33                	push   $0x33
  800d6f:	68 9d 25 80 00       	push   $0x80259d
  800d74:	e8 63 f4 ff ff       	call   8001dc <_panic>

00800d79 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	57                   	push   %edi
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d84:	b8 02 00 00 00       	mov    $0x2,%eax
  800d89:	89 d1                	mov    %edx,%ecx
  800d8b:	89 d3                	mov    %edx,%ebx
  800d8d:	89 d7                	mov    %edx,%edi
  800d8f:	89 d6                	mov    %edx,%esi
  800d91:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <sys_yield>:

void
sys_yield(void)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800da3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da8:	89 d1                	mov    %edx,%ecx
  800daa:	89 d3                	mov    %edx,%ebx
  800dac:	89 d7                	mov    %edx,%edi
  800dae:	89 d6                	mov    %edx,%esi
  800db0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc0:	be 00 00 00 00       	mov    $0x0,%esi
  800dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcb:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd3:	89 f7                	mov    %esi,%edi
  800dd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7f 08                	jg     800de3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800de7:	6a 04                	push   $0x4
  800de9:	68 80 25 80 00       	push   $0x802580
  800dee:	6a 33                	push   $0x33
  800df0:	68 9d 25 80 00       	push   $0x80259d
  800df5:	e8 e2 f3 ff ff       	call   8001dc <_panic>

00800dfa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	b8 05 00 00 00       	mov    $0x5,%eax
  800e0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e11:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e14:	8b 75 18             	mov    0x18(%ebp),%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800e29:	6a 05                	push   $0x5
  800e2b:	68 80 25 80 00       	push   $0x802580
  800e30:	6a 33                	push   $0x33
  800e32:	68 9d 25 80 00       	push   $0x80259d
  800e37:	e8 a0 f3 ff ff       	call   8001dc <_panic>

00800e3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800e50:	b8 06 00 00 00       	mov    $0x6,%eax
  800e55:	89 df                	mov    %ebx,%edi
  800e57:	89 de                	mov    %ebx,%esi
  800e59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7f 08                	jg     800e67 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800e6b:	6a 06                	push   $0x6
  800e6d:	68 80 25 80 00       	push   $0x802580
  800e72:	6a 33                	push   $0x33
  800e74:	68 9d 25 80 00       	push   $0x80259d
  800e79:	e8 5e f3 ff ff       	call   8001dc <_panic>

00800e7e <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e87:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e94:	89 cb                	mov    %ecx,%ebx
  800e96:	89 cf                	mov    %ecx,%edi
  800e98:	89 ce                	mov    %ecx,%esi
  800e9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	7f 08                	jg     800ea8 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea3:	5b                   	pop    %ebx
  800ea4:	5e                   	pop    %esi
  800ea5:	5f                   	pop    %edi
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	50                   	push   %eax
  800eac:	6a 0b                	push   $0xb
  800eae:	68 80 25 80 00       	push   $0x802580
  800eb3:	6a 33                	push   $0x33
  800eb5:	68 9d 25 80 00       	push   $0x80259d
  800eba:	e8 1d f3 ff ff       	call   8001dc <_panic>

00800ebf <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	57                   	push   %edi
  800ec3:	56                   	push   %esi
  800ec4:	53                   	push   %ebx
  800ec5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed8:	89 df                	mov    %ebx,%edi
  800eda:	89 de                	mov    %ebx,%esi
  800edc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	7f 08                	jg     800eea <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	50                   	push   %eax
  800eee:	6a 08                	push   $0x8
  800ef0:	68 80 25 80 00       	push   $0x802580
  800ef5:	6a 33                	push   $0x33
  800ef7:	68 9d 25 80 00       	push   $0x80259d
  800efc:	e8 db f2 ff ff       	call   8001dc <_panic>

00800f01 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
  800f07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f15:	b8 09 00 00 00       	mov    $0x9,%eax
  800f1a:	89 df                	mov    %ebx,%edi
  800f1c:	89 de                	mov    %ebx,%esi
  800f1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	7f 08                	jg     800f2c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2c:	83 ec 0c             	sub    $0xc,%esp
  800f2f:	50                   	push   %eax
  800f30:	6a 09                	push   $0x9
  800f32:	68 80 25 80 00       	push   $0x802580
  800f37:	6a 33                	push   $0x33
  800f39:	68 9d 25 80 00       	push   $0x80259d
  800f3e:	e8 99 f2 ff ff       	call   8001dc <_panic>

00800f43 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	57                   	push   %edi
  800f47:	56                   	push   %esi
  800f48:	53                   	push   %ebx
  800f49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f5c:	89 df                	mov    %ebx,%edi
  800f5e:	89 de                	mov    %ebx,%esi
  800f60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	7f 08                	jg     800f6e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	50                   	push   %eax
  800f72:	6a 0a                	push   $0xa
  800f74:	68 80 25 80 00       	push   $0x802580
  800f79:	6a 33                	push   $0x33
  800f7b:	68 9d 25 80 00       	push   $0x80259d
  800f80:	e8 57 f2 ff ff       	call   8001dc <_panic>

00800f85 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f91:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f96:	be 00 00 00 00       	mov    $0x0,%esi
  800f9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fa1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
  800fae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fbe:	89 cb                	mov    %ecx,%ebx
  800fc0:	89 cf                	mov    %ecx,%edi
  800fc2:	89 ce                	mov    %ecx,%esi
  800fc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	7f 08                	jg     800fd2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcd:	5b                   	pop    %ebx
  800fce:	5e                   	pop    %esi
  800fcf:	5f                   	pop    %edi
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd2:	83 ec 0c             	sub    $0xc,%esp
  800fd5:	50                   	push   %eax
  800fd6:	6a 0e                	push   $0xe
  800fd8:	68 80 25 80 00       	push   $0x802580
  800fdd:	6a 33                	push   $0x33
  800fdf:	68 9d 25 80 00       	push   $0x80259d
  800fe4:	e8 f3 f1 ff ff       	call   8001dc <_panic>

00800fe9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	57                   	push   %edi
  800fed:	56                   	push   %esi
  800fee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fef:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffa:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fff:	89 df                	mov    %ebx,%edi
  801001:	89 de                	mov    %ebx,%esi
  801003:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5f                   	pop    %edi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801010:	b9 00 00 00 00       	mov    $0x0,%ecx
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	b8 10 00 00 00       	mov    $0x10,%eax
  80101d:	89 cb                	mov    %ecx,%ebx
  80101f:	89 cf                	mov    %ecx,%edi
  801021:	89 ce                	mov    %ecx,%esi
  801023:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5f                   	pop    %edi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	05 00 00 00 30       	add    $0x30000000,%eax
  801035:	c1 e8 0c             	shr    $0xc,%eax
}
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801045:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80104a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    

00801051 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801059:	89 c2                	mov    %eax,%edx
  80105b:	c1 ea 16             	shr    $0x16,%edx
  80105e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801065:	f6 c2 01             	test   $0x1,%dl
  801068:	74 2d                	je     801097 <fd_alloc+0x46>
  80106a:	89 c2                	mov    %eax,%edx
  80106c:	c1 ea 0c             	shr    $0xc,%edx
  80106f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801076:	f6 c2 01             	test   $0x1,%dl
  801079:	74 1c                	je     801097 <fd_alloc+0x46>
  80107b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801080:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801085:	75 d2                	jne    801059 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801090:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801095:	eb 0a                	jmp    8010a1 <fd_alloc+0x50>
			*fd_store = fd;
  801097:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80109c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010a9:	83 f8 1f             	cmp    $0x1f,%eax
  8010ac:	77 30                	ja     8010de <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010ae:	c1 e0 0c             	shl    $0xc,%eax
  8010b1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010bc:	f6 c2 01             	test   $0x1,%dl
  8010bf:	74 24                	je     8010e5 <fd_lookup+0x42>
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	c1 ea 0c             	shr    $0xc,%edx
  8010c6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010cd:	f6 c2 01             	test   $0x1,%dl
  8010d0:	74 1a                	je     8010ec <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d5:	89 02                	mov    %eax,(%edx)
	return 0;
  8010d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    
		return -E_INVAL;
  8010de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e3:	eb f7                	jmp    8010dc <fd_lookup+0x39>
		return -E_INVAL;
  8010e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ea:	eb f0                	jmp    8010dc <fd_lookup+0x39>
  8010ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f1:	eb e9                	jmp    8010dc <fd_lookup+0x39>

008010f3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fc:	ba 2c 26 80 00       	mov    $0x80262c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801101:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801106:	39 08                	cmp    %ecx,(%eax)
  801108:	74 33                	je     80113d <dev_lookup+0x4a>
  80110a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80110d:	8b 02                	mov    (%edx),%eax
  80110f:	85 c0                	test   %eax,%eax
  801111:	75 f3                	jne    801106 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801113:	a1 08 40 80 00       	mov    0x804008,%eax
  801118:	8b 40 48             	mov    0x48(%eax),%eax
  80111b:	83 ec 04             	sub    $0x4,%esp
  80111e:	51                   	push   %ecx
  80111f:	50                   	push   %eax
  801120:	68 ac 25 80 00       	push   $0x8025ac
  801125:	e8 8d f1 ff ff       	call   8002b7 <cprintf>
	*dev = 0;
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801133:	83 c4 10             	add    $0x10,%esp
  801136:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    
			*dev = devtab[i];
  80113d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801140:	89 01                	mov    %eax,(%ecx)
			return 0;
  801142:	b8 00 00 00 00       	mov    $0x0,%eax
  801147:	eb f2                	jmp    80113b <dev_lookup+0x48>

00801149 <fd_close>:
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	57                   	push   %edi
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
  80114f:	83 ec 24             	sub    $0x24,%esp
  801152:	8b 75 08             	mov    0x8(%ebp),%esi
  801155:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801158:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801162:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801165:	50                   	push   %eax
  801166:	e8 38 ff ff ff       	call   8010a3 <fd_lookup>
  80116b:	89 c3                	mov    %eax,%ebx
  80116d:	83 c4 10             	add    $0x10,%esp
  801170:	85 c0                	test   %eax,%eax
  801172:	78 05                	js     801179 <fd_close+0x30>
	    || fd != fd2)
  801174:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801177:	74 16                	je     80118f <fd_close+0x46>
		return (must_exist ? r : 0);
  801179:	89 f8                	mov    %edi,%eax
  80117b:	84 c0                	test   %al,%al
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
  801182:	0f 44 d8             	cmove  %eax,%ebx
}
  801185:	89 d8                	mov    %ebx,%eax
  801187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118a:	5b                   	pop    %ebx
  80118b:	5e                   	pop    %esi
  80118c:	5f                   	pop    %edi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801195:	50                   	push   %eax
  801196:	ff 36                	pushl  (%esi)
  801198:	e8 56 ff ff ff       	call   8010f3 <dev_lookup>
  80119d:	89 c3                	mov    %eax,%ebx
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	78 1a                	js     8011c0 <fd_close+0x77>
		if (dev->dev_close)
  8011a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a9:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011ac:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	74 0b                	je     8011c0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	56                   	push   %esi
  8011b9:	ff d0                	call   *%eax
  8011bb:	89 c3                	mov    %eax,%ebx
  8011bd:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011c0:	83 ec 08             	sub    $0x8,%esp
  8011c3:	56                   	push   %esi
  8011c4:	6a 00                	push   $0x0
  8011c6:	e8 71 fc ff ff       	call   800e3c <sys_page_unmap>
	return r;
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	eb b5                	jmp    801185 <fd_close+0x3c>

008011d0 <close>:

int
close(int fdnum)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d9:	50                   	push   %eax
  8011da:	ff 75 08             	pushl  0x8(%ebp)
  8011dd:	e8 c1 fe ff ff       	call   8010a3 <fd_lookup>
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	79 02                	jns    8011eb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    
		return fd_close(fd, 1);
  8011eb:	83 ec 08             	sub    $0x8,%esp
  8011ee:	6a 01                	push   $0x1
  8011f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f3:	e8 51 ff ff ff       	call   801149 <fd_close>
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	eb ec                	jmp    8011e9 <close+0x19>

008011fd <close_all>:

void
close_all(void)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	53                   	push   %ebx
  801201:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801204:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801209:	83 ec 0c             	sub    $0xc,%esp
  80120c:	53                   	push   %ebx
  80120d:	e8 be ff ff ff       	call   8011d0 <close>
	for (i = 0; i < MAXFD; i++)
  801212:	83 c3 01             	add    $0x1,%ebx
  801215:	83 c4 10             	add    $0x10,%esp
  801218:	83 fb 20             	cmp    $0x20,%ebx
  80121b:	75 ec                	jne    801209 <close_all+0xc>
}
  80121d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801220:	c9                   	leave  
  801221:	c3                   	ret    

00801222 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	57                   	push   %edi
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80122b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 6c fe ff ff       	call   8010a3 <fd_lookup>
  801237:	89 c3                	mov    %eax,%ebx
  801239:	83 c4 10             	add    $0x10,%esp
  80123c:	85 c0                	test   %eax,%eax
  80123e:	0f 88 81 00 00 00    	js     8012c5 <dup+0xa3>
		return r;
	close(newfdnum);
  801244:	83 ec 0c             	sub    $0xc,%esp
  801247:	ff 75 0c             	pushl  0xc(%ebp)
  80124a:	e8 81 ff ff ff       	call   8011d0 <close>

	newfd = INDEX2FD(newfdnum);
  80124f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801252:	c1 e6 0c             	shl    $0xc,%esi
  801255:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80125b:	83 c4 04             	add    $0x4,%esp
  80125e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801261:	e8 d4 fd ff ff       	call   80103a <fd2data>
  801266:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801268:	89 34 24             	mov    %esi,(%esp)
  80126b:	e8 ca fd ff ff       	call   80103a <fd2data>
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801275:	89 d8                	mov    %ebx,%eax
  801277:	c1 e8 16             	shr    $0x16,%eax
  80127a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801281:	a8 01                	test   $0x1,%al
  801283:	74 11                	je     801296 <dup+0x74>
  801285:	89 d8                	mov    %ebx,%eax
  801287:	c1 e8 0c             	shr    $0xc,%eax
  80128a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801291:	f6 c2 01             	test   $0x1,%dl
  801294:	75 39                	jne    8012cf <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801296:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801299:	89 d0                	mov    %edx,%eax
  80129b:	c1 e8 0c             	shr    $0xc,%eax
  80129e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ad:	50                   	push   %eax
  8012ae:	56                   	push   %esi
  8012af:	6a 00                	push   $0x0
  8012b1:	52                   	push   %edx
  8012b2:	6a 00                	push   $0x0
  8012b4:	e8 41 fb ff ff       	call   800dfa <sys_page_map>
  8012b9:	89 c3                	mov    %eax,%ebx
  8012bb:	83 c4 20             	add    $0x20,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 31                	js     8012f3 <dup+0xd1>
		goto err;

	return newfdnum;
  8012c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012c5:	89 d8                	mov    %ebx,%eax
  8012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ca:	5b                   	pop    %ebx
  8012cb:	5e                   	pop    %esi
  8012cc:	5f                   	pop    %edi
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d6:	83 ec 0c             	sub    $0xc,%esp
  8012d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8012de:	50                   	push   %eax
  8012df:	57                   	push   %edi
  8012e0:	6a 00                	push   $0x0
  8012e2:	53                   	push   %ebx
  8012e3:	6a 00                	push   $0x0
  8012e5:	e8 10 fb ff ff       	call   800dfa <sys_page_map>
  8012ea:	89 c3                	mov    %eax,%ebx
  8012ec:	83 c4 20             	add    $0x20,%esp
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	79 a3                	jns    801296 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012f3:	83 ec 08             	sub    $0x8,%esp
  8012f6:	56                   	push   %esi
  8012f7:	6a 00                	push   $0x0
  8012f9:	e8 3e fb ff ff       	call   800e3c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012fe:	83 c4 08             	add    $0x8,%esp
  801301:	57                   	push   %edi
  801302:	6a 00                	push   $0x0
  801304:	e8 33 fb ff ff       	call   800e3c <sys_page_unmap>
	return r;
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	eb b7                	jmp    8012c5 <dup+0xa3>

0080130e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	53                   	push   %ebx
  801312:	83 ec 1c             	sub    $0x1c,%esp
  801315:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801318:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131b:	50                   	push   %eax
  80131c:	53                   	push   %ebx
  80131d:	e8 81 fd ff ff       	call   8010a3 <fd_lookup>
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 3f                	js     801368 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132f:	50                   	push   %eax
  801330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801333:	ff 30                	pushl  (%eax)
  801335:	e8 b9 fd ff ff       	call   8010f3 <dev_lookup>
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 27                	js     801368 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801341:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801344:	8b 42 08             	mov    0x8(%edx),%eax
  801347:	83 e0 03             	and    $0x3,%eax
  80134a:	83 f8 01             	cmp    $0x1,%eax
  80134d:	74 1e                	je     80136d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801352:	8b 40 08             	mov    0x8(%eax),%eax
  801355:	85 c0                	test   %eax,%eax
  801357:	74 35                	je     80138e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	ff 75 10             	pushl  0x10(%ebp)
  80135f:	ff 75 0c             	pushl  0xc(%ebp)
  801362:	52                   	push   %edx
  801363:	ff d0                	call   *%eax
  801365:	83 c4 10             	add    $0x10,%esp
}
  801368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80136d:	a1 08 40 80 00       	mov    0x804008,%eax
  801372:	8b 40 48             	mov    0x48(%eax),%eax
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	53                   	push   %ebx
  801379:	50                   	push   %eax
  80137a:	68 f0 25 80 00       	push   $0x8025f0
  80137f:	e8 33 ef ff ff       	call   8002b7 <cprintf>
		return -E_INVAL;
  801384:	83 c4 10             	add    $0x10,%esp
  801387:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138c:	eb da                	jmp    801368 <read+0x5a>
		return -E_NOT_SUPP;
  80138e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801393:	eb d3                	jmp    801368 <read+0x5a>

00801395 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	57                   	push   %edi
  801399:	56                   	push   %esi
  80139a:	53                   	push   %ebx
  80139b:	83 ec 0c             	sub    $0xc,%esp
  80139e:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a9:	39 f3                	cmp    %esi,%ebx
  8013ab:	73 23                	jae    8013d0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	89 f0                	mov    %esi,%eax
  8013b2:	29 d8                	sub    %ebx,%eax
  8013b4:	50                   	push   %eax
  8013b5:	89 d8                	mov    %ebx,%eax
  8013b7:	03 45 0c             	add    0xc(%ebp),%eax
  8013ba:	50                   	push   %eax
  8013bb:	57                   	push   %edi
  8013bc:	e8 4d ff ff ff       	call   80130e <read>
		if (m < 0)
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 06                	js     8013ce <readn+0x39>
			return m;
		if (m == 0)
  8013c8:	74 06                	je     8013d0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013ca:	01 c3                	add    %eax,%ebx
  8013cc:	eb db                	jmp    8013a9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ce:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013d0:	89 d8                	mov    %ebx,%eax
  8013d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d5:	5b                   	pop    %ebx
  8013d6:	5e                   	pop    %esi
  8013d7:	5f                   	pop    %edi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 1c             	sub    $0x1c,%esp
  8013e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e7:	50                   	push   %eax
  8013e8:	53                   	push   %ebx
  8013e9:	e8 b5 fc ff ff       	call   8010a3 <fd_lookup>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	78 3a                	js     80142f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f5:	83 ec 08             	sub    $0x8,%esp
  8013f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fb:	50                   	push   %eax
  8013fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ff:	ff 30                	pushl  (%eax)
  801401:	e8 ed fc ff ff       	call   8010f3 <dev_lookup>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 22                	js     80142f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80140d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801410:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801414:	74 1e                	je     801434 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801419:	8b 52 0c             	mov    0xc(%edx),%edx
  80141c:	85 d2                	test   %edx,%edx
  80141e:	74 35                	je     801455 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	ff 75 10             	pushl  0x10(%ebp)
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	50                   	push   %eax
  80142a:	ff d2                	call   *%edx
  80142c:	83 c4 10             	add    $0x10,%esp
}
  80142f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801432:	c9                   	leave  
  801433:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801434:	a1 08 40 80 00       	mov    0x804008,%eax
  801439:	8b 40 48             	mov    0x48(%eax),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	53                   	push   %ebx
  801440:	50                   	push   %eax
  801441:	68 0c 26 80 00       	push   $0x80260c
  801446:	e8 6c ee ff ff       	call   8002b7 <cprintf>
		return -E_INVAL;
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801453:	eb da                	jmp    80142f <write+0x55>
		return -E_NOT_SUPP;
  801455:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145a:	eb d3                	jmp    80142f <write+0x55>

0080145c <seek>:

int
seek(int fdnum, off_t offset)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801465:	50                   	push   %eax
  801466:	ff 75 08             	pushl  0x8(%ebp)
  801469:	e8 35 fc ff ff       	call   8010a3 <fd_lookup>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 0e                	js     801483 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801475:	8b 55 0c             	mov    0xc(%ebp),%edx
  801478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80147e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	53                   	push   %ebx
  801489:	83 ec 1c             	sub    $0x1c,%esp
  80148c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	53                   	push   %ebx
  801494:	e8 0a fc ff ff       	call   8010a3 <fd_lookup>
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 37                	js     8014d7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a0:	83 ec 08             	sub    $0x8,%esp
  8014a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a6:	50                   	push   %eax
  8014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014aa:	ff 30                	pushl  (%eax)
  8014ac:	e8 42 fc ff ff       	call   8010f3 <dev_lookup>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 1f                	js     8014d7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014bf:	74 1b                	je     8014dc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c4:	8b 52 18             	mov    0x18(%edx),%edx
  8014c7:	85 d2                	test   %edx,%edx
  8014c9:	74 32                	je     8014fd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	ff 75 0c             	pushl  0xc(%ebp)
  8014d1:	50                   	push   %eax
  8014d2:	ff d2                	call   *%edx
  8014d4:	83 c4 10             	add    $0x10,%esp
}
  8014d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014dc:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e1:	8b 40 48             	mov    0x48(%eax),%eax
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	53                   	push   %ebx
  8014e8:	50                   	push   %eax
  8014e9:	68 cc 25 80 00       	push   $0x8025cc
  8014ee:	e8 c4 ed ff ff       	call   8002b7 <cprintf>
		return -E_INVAL;
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fb:	eb da                	jmp    8014d7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801502:	eb d3                	jmp    8014d7 <ftruncate+0x52>

00801504 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	53                   	push   %ebx
  801508:	83 ec 1c             	sub    $0x1c,%esp
  80150b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801511:	50                   	push   %eax
  801512:	ff 75 08             	pushl  0x8(%ebp)
  801515:	e8 89 fb ff ff       	call   8010a3 <fd_lookup>
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 4b                	js     80156c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801521:	83 ec 08             	sub    $0x8,%esp
  801524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801527:	50                   	push   %eax
  801528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152b:	ff 30                	pushl  (%eax)
  80152d:	e8 c1 fb ff ff       	call   8010f3 <dev_lookup>
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	85 c0                	test   %eax,%eax
  801537:	78 33                	js     80156c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801540:	74 2f                	je     801571 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801542:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801545:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80154c:	00 00 00 
	stat->st_isdir = 0;
  80154f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801556:	00 00 00 
	stat->st_dev = dev;
  801559:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	53                   	push   %ebx
  801563:	ff 75 f0             	pushl  -0x10(%ebp)
  801566:	ff 50 14             	call   *0x14(%eax)
  801569:	83 c4 10             	add    $0x10,%esp
}
  80156c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156f:	c9                   	leave  
  801570:	c3                   	ret    
		return -E_NOT_SUPP;
  801571:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801576:	eb f4                	jmp    80156c <fstat+0x68>

00801578 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	56                   	push   %esi
  80157c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80157d:	83 ec 08             	sub    $0x8,%esp
  801580:	6a 00                	push   $0x0
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	e8 e7 01 00 00       	call   801771 <open>
  80158a:	89 c3                	mov    %eax,%ebx
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 1b                	js     8015ae <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	50                   	push   %eax
  80159a:	e8 65 ff ff ff       	call   801504 <fstat>
  80159f:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a1:	89 1c 24             	mov    %ebx,(%esp)
  8015a4:	e8 27 fc ff ff       	call   8011d0 <close>
	return r;
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	89 f3                	mov    %esi,%ebx
}
  8015ae:	89 d8                	mov    %ebx,%eax
  8015b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b3:	5b                   	pop    %ebx
  8015b4:	5e                   	pop    %esi
  8015b5:	5d                   	pop    %ebp
  8015b6:	c3                   	ret    

008015b7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	56                   	push   %esi
  8015bb:	53                   	push   %ebx
  8015bc:	89 c6                	mov    %eax,%esi
  8015be:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015c0:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8015c7:	74 27                	je     8015f0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015c9:	6a 07                	push   $0x7
  8015cb:	68 00 50 80 00       	push   $0x805000
  8015d0:	56                   	push   %esi
  8015d1:	ff 35 04 40 80 00    	pushl  0x804004
  8015d7:	e8 78 08 00 00       	call   801e54 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015dc:	83 c4 0c             	add    $0xc,%esp
  8015df:	6a 00                	push   $0x0
  8015e1:	53                   	push   %ebx
  8015e2:	6a 00                	push   $0x0
  8015e4:	e8 04 08 00 00       	call   801ded <ipc_recv>
}
  8015e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ec:	5b                   	pop    %ebx
  8015ed:	5e                   	pop    %esi
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f0:	83 ec 0c             	sub    $0xc,%esp
  8015f3:	6a 01                	push   $0x1
  8015f5:	e8 a3 08 00 00       	call   801e9d <ipc_find_env>
  8015fa:	a3 04 40 80 00       	mov    %eax,0x804004
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	eb c5                	jmp    8015c9 <fsipc+0x12>

00801604 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8b 40 0c             	mov    0xc(%eax),%eax
  801610:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801615:	8b 45 0c             	mov    0xc(%ebp),%eax
  801618:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80161d:	ba 00 00 00 00       	mov    $0x0,%edx
  801622:	b8 02 00 00 00       	mov    $0x2,%eax
  801627:	e8 8b ff ff ff       	call   8015b7 <fsipc>
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <devfile_flush>:
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	8b 40 0c             	mov    0xc(%eax),%eax
  80163a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80163f:	ba 00 00 00 00       	mov    $0x0,%edx
  801644:	b8 06 00 00 00       	mov    $0x6,%eax
  801649:	e8 69 ff ff ff       	call   8015b7 <fsipc>
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <devfile_stat>:
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	53                   	push   %ebx
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8b 40 0c             	mov    0xc(%eax),%eax
  801660:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801665:	ba 00 00 00 00       	mov    $0x0,%edx
  80166a:	b8 05 00 00 00       	mov    $0x5,%eax
  80166f:	e8 43 ff ff ff       	call   8015b7 <fsipc>
  801674:	85 c0                	test   %eax,%eax
  801676:	78 2c                	js     8016a4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	68 00 50 80 00       	push   $0x805000
  801680:	53                   	push   %ebx
  801681:	e8 3f f3 ff ff       	call   8009c5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801686:	a1 80 50 80 00       	mov    0x805080,%eax
  80168b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801691:	a1 84 50 80 00       	mov    0x805084,%eax
  801696:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <devfile_write>:
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 0c             	sub    $0xc,%esp
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8016b8:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8016be:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016c3:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016c8:	0f 47 c2             	cmova  %edx,%eax
  8016cb:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8016d0:	50                   	push   %eax
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	68 08 50 80 00       	push   $0x805008
  8016d9:	e8 75 f4 ff ff       	call   800b53 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e8:	e8 ca fe ff ff       	call   8015b7 <fsipc>
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <devfile_read>:
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	56                   	push   %esi
  8016f3:	53                   	push   %ebx
  8016f4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8016fd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801702:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801708:	ba 00 00 00 00       	mov    $0x0,%edx
  80170d:	b8 03 00 00 00       	mov    $0x3,%eax
  801712:	e8 a0 fe ff ff       	call   8015b7 <fsipc>
  801717:	89 c3                	mov    %eax,%ebx
  801719:	85 c0                	test   %eax,%eax
  80171b:	78 1f                	js     80173c <devfile_read+0x4d>
	assert(r <= n);
  80171d:	39 f0                	cmp    %esi,%eax
  80171f:	77 24                	ja     801745 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801721:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801726:	7f 33                	jg     80175b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	50                   	push   %eax
  80172c:	68 00 50 80 00       	push   $0x805000
  801731:	ff 75 0c             	pushl  0xc(%ebp)
  801734:	e8 1a f4 ff ff       	call   800b53 <memmove>
	return r;
  801739:	83 c4 10             	add    $0x10,%esp
}
  80173c:	89 d8                	mov    %ebx,%eax
  80173e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    
	assert(r <= n);
  801745:	68 3c 26 80 00       	push   $0x80263c
  80174a:	68 43 26 80 00       	push   $0x802643
  80174f:	6a 7c                	push   $0x7c
  801751:	68 58 26 80 00       	push   $0x802658
  801756:	e8 81 ea ff ff       	call   8001dc <_panic>
	assert(r <= PGSIZE);
  80175b:	68 63 26 80 00       	push   $0x802663
  801760:	68 43 26 80 00       	push   $0x802643
  801765:	6a 7d                	push   $0x7d
  801767:	68 58 26 80 00       	push   $0x802658
  80176c:	e8 6b ea ff ff       	call   8001dc <_panic>

00801771 <open>:
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	56                   	push   %esi
  801775:	53                   	push   %ebx
  801776:	83 ec 1c             	sub    $0x1c,%esp
  801779:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80177c:	56                   	push   %esi
  80177d:	e8 0a f2 ff ff       	call   80098c <strlen>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80178a:	7f 6c                	jg     8017f8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801792:	50                   	push   %eax
  801793:	e8 b9 f8 ff ff       	call   801051 <fd_alloc>
  801798:	89 c3                	mov    %eax,%ebx
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	85 c0                	test   %eax,%eax
  80179f:	78 3c                	js     8017dd <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	56                   	push   %esi
  8017a5:	68 00 50 80 00       	push   $0x805000
  8017aa:	e8 16 f2 ff ff       	call   8009c5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8017bf:	e8 f3 fd ff ff       	call   8015b7 <fsipc>
  8017c4:	89 c3                	mov    %eax,%ebx
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 19                	js     8017e6 <open+0x75>
	return fd2num(fd);
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d3:	e8 52 f8 ff ff       	call   80102a <fd2num>
  8017d8:	89 c3                	mov    %eax,%ebx
  8017da:	83 c4 10             	add    $0x10,%esp
}
  8017dd:	89 d8                	mov    %ebx,%eax
  8017df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e2:	5b                   	pop    %ebx
  8017e3:	5e                   	pop    %esi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    
		fd_close(fd, 0);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	6a 00                	push   $0x0
  8017eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ee:	e8 56 f9 ff ff       	call   801149 <fd_close>
		return r;
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	eb e5                	jmp    8017dd <open+0x6c>
		return -E_BAD_PATH;
  8017f8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017fd:	eb de                	jmp    8017dd <open+0x6c>

008017ff <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801805:	ba 00 00 00 00       	mov    $0x0,%edx
  80180a:	b8 08 00 00 00       	mov    $0x8,%eax
  80180f:	e8 a3 fd ff ff       	call   8015b7 <fsipc>
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801816:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80181a:	7f 01                	jg     80181d <writebuf+0x7>
  80181c:	c3                   	ret    
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	53                   	push   %ebx
  801821:	83 ec 08             	sub    $0x8,%esp
  801824:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801826:	ff 70 04             	pushl  0x4(%eax)
  801829:	8d 40 10             	lea    0x10(%eax),%eax
  80182c:	50                   	push   %eax
  80182d:	ff 33                	pushl  (%ebx)
  80182f:	e8 a6 fb ff ff       	call   8013da <write>
		if (result > 0)
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	7e 03                	jle    80183e <writebuf+0x28>
			b->result += result;
  80183b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80183e:	39 43 04             	cmp    %eax,0x4(%ebx)
  801841:	74 0d                	je     801850 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801843:	85 c0                	test   %eax,%eax
  801845:	ba 00 00 00 00       	mov    $0x0,%edx
  80184a:	0f 4f c2             	cmovg  %edx,%eax
  80184d:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801850:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <putch>:

static void
putch(int ch, void *thunk)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	53                   	push   %ebx
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80185f:	8b 53 04             	mov    0x4(%ebx),%edx
  801862:	8d 42 01             	lea    0x1(%edx),%eax
  801865:	89 43 04             	mov    %eax,0x4(%ebx)
  801868:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80186b:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80186f:	3d 00 01 00 00       	cmp    $0x100,%eax
  801874:	74 06                	je     80187c <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	5b                   	pop    %ebx
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    
		writebuf(b);
  80187c:	89 d8                	mov    %ebx,%eax
  80187e:	e8 93 ff ff ff       	call   801816 <writebuf>
		b->idx = 0;
  801883:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80188a:	eb ea                	jmp    801876 <putch+0x21>

0080188c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80189e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018a5:	00 00 00 
	b.result = 0;
  8018a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018af:	00 00 00 
	b.error = 1;
  8018b2:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018b9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018bc:	ff 75 10             	pushl  0x10(%ebp)
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018c8:	50                   	push   %eax
  8018c9:	68 55 18 80 00       	push   $0x801855
  8018ce:	e8 11 eb ff ff       	call   8003e4 <vprintfmt>
	if (b.idx > 0)
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8018dd:	7f 11                	jg     8018f0 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8018df:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    
		writebuf(&b);
  8018f0:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018f6:	e8 1b ff ff ff       	call   801816 <writebuf>
  8018fb:	eb e2                	jmp    8018df <vfprintf+0x53>

008018fd <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801903:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801906:	50                   	push   %eax
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 08             	pushl  0x8(%ebp)
  80190d:	e8 7a ff ff ff       	call   80188c <vfprintf>
	va_end(ap);

	return cnt;
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <printf>:

int
printf(const char *fmt, ...)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80191a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80191d:	50                   	push   %eax
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	6a 01                	push   $0x1
  801923:	e8 64 ff ff ff       	call   80188c <vfprintf>
	va_end(ap);

	return cnt;
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	56                   	push   %esi
  80192e:	53                   	push   %ebx
  80192f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	e8 fd f6 ff ff       	call   80103a <fd2data>
  80193d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	68 6f 26 80 00       	push   $0x80266f
  801947:	53                   	push   %ebx
  801948:	e8 78 f0 ff ff       	call   8009c5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80194d:	8b 46 04             	mov    0x4(%esi),%eax
  801950:	2b 06                	sub    (%esi),%eax
  801952:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801958:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80195f:	00 00 00 
	stat->st_dev = &devpipe;
  801962:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801969:	30 80 00 
	return 0;
}
  80196c:	b8 00 00 00 00       	mov    $0x0,%eax
  801971:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801974:	5b                   	pop    %ebx
  801975:	5e                   	pop    %esi
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    

00801978 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	53                   	push   %ebx
  80197c:	83 ec 0c             	sub    $0xc,%esp
  80197f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801982:	53                   	push   %ebx
  801983:	6a 00                	push   $0x0
  801985:	e8 b2 f4 ff ff       	call   800e3c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80198a:	89 1c 24             	mov    %ebx,(%esp)
  80198d:	e8 a8 f6 ff ff       	call   80103a <fd2data>
  801992:	83 c4 08             	add    $0x8,%esp
  801995:	50                   	push   %eax
  801996:	6a 00                	push   $0x0
  801998:	e8 9f f4 ff ff       	call   800e3c <sys_page_unmap>
}
  80199d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <_pipeisclosed>:
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 1c             	sub    $0x1c,%esp
  8019ab:	89 c7                	mov    %eax,%edi
  8019ad:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019af:	a1 08 40 80 00       	mov    0x804008,%eax
  8019b4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019b7:	83 ec 0c             	sub    $0xc,%esp
  8019ba:	57                   	push   %edi
  8019bb:	e8 1c 05 00 00       	call   801edc <pageref>
  8019c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019c3:	89 34 24             	mov    %esi,(%esp)
  8019c6:	e8 11 05 00 00       	call   801edc <pageref>
		nn = thisenv->env_runs;
  8019cb:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8019d1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	39 cb                	cmp    %ecx,%ebx
  8019d9:	74 1b                	je     8019f6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019db:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019de:	75 cf                	jne    8019af <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019e0:	8b 42 58             	mov    0x58(%edx),%eax
  8019e3:	6a 01                	push   $0x1
  8019e5:	50                   	push   %eax
  8019e6:	53                   	push   %ebx
  8019e7:	68 76 26 80 00       	push   $0x802676
  8019ec:	e8 c6 e8 ff ff       	call   8002b7 <cprintf>
  8019f1:	83 c4 10             	add    $0x10,%esp
  8019f4:	eb b9                	jmp    8019af <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019f6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019f9:	0f 94 c0             	sete   %al
  8019fc:	0f b6 c0             	movzbl %al,%eax
}
  8019ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5e                   	pop    %esi
  801a04:	5f                   	pop    %edi
  801a05:	5d                   	pop    %ebp
  801a06:	c3                   	ret    

00801a07 <devpipe_write>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	57                   	push   %edi
  801a0b:	56                   	push   %esi
  801a0c:	53                   	push   %ebx
  801a0d:	83 ec 28             	sub    $0x28,%esp
  801a10:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a13:	56                   	push   %esi
  801a14:	e8 21 f6 ff ff       	call   80103a <fd2data>
  801a19:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a23:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a26:	74 4f                	je     801a77 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a28:	8b 43 04             	mov    0x4(%ebx),%eax
  801a2b:	8b 0b                	mov    (%ebx),%ecx
  801a2d:	8d 51 20             	lea    0x20(%ecx),%edx
  801a30:	39 d0                	cmp    %edx,%eax
  801a32:	72 14                	jb     801a48 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a34:	89 da                	mov    %ebx,%edx
  801a36:	89 f0                	mov    %esi,%eax
  801a38:	e8 65 ff ff ff       	call   8019a2 <_pipeisclosed>
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	75 3b                	jne    801a7c <devpipe_write+0x75>
			sys_yield();
  801a41:	e8 52 f3 ff ff       	call   800d98 <sys_yield>
  801a46:	eb e0                	jmp    801a28 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a4b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a4f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a52:	89 c2                	mov    %eax,%edx
  801a54:	c1 fa 1f             	sar    $0x1f,%edx
  801a57:	89 d1                	mov    %edx,%ecx
  801a59:	c1 e9 1b             	shr    $0x1b,%ecx
  801a5c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a5f:	83 e2 1f             	and    $0x1f,%edx
  801a62:	29 ca                	sub    %ecx,%edx
  801a64:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a68:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a6c:	83 c0 01             	add    $0x1,%eax
  801a6f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a72:	83 c7 01             	add    $0x1,%edi
  801a75:	eb ac                	jmp    801a23 <devpipe_write+0x1c>
	return i;
  801a77:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7a:	eb 05                	jmp    801a81 <devpipe_write+0x7a>
				return 0;
  801a7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5f                   	pop    %edi
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <devpipe_read>:
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	57                   	push   %edi
  801a8d:	56                   	push   %esi
  801a8e:	53                   	push   %ebx
  801a8f:	83 ec 18             	sub    $0x18,%esp
  801a92:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a95:	57                   	push   %edi
  801a96:	e8 9f f5 ff ff       	call   80103a <fd2data>
  801a9b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	be 00 00 00 00       	mov    $0x0,%esi
  801aa5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801aa8:	75 14                	jne    801abe <devpipe_read+0x35>
	return i;
  801aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801aad:	eb 02                	jmp    801ab1 <devpipe_read+0x28>
				return i;
  801aaf:	89 f0                	mov    %esi,%eax
}
  801ab1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
			sys_yield();
  801ab9:	e8 da f2 ff ff       	call   800d98 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801abe:	8b 03                	mov    (%ebx),%eax
  801ac0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ac3:	75 18                	jne    801add <devpipe_read+0x54>
			if (i > 0)
  801ac5:	85 f6                	test   %esi,%esi
  801ac7:	75 e6                	jne    801aaf <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ac9:	89 da                	mov    %ebx,%edx
  801acb:	89 f8                	mov    %edi,%eax
  801acd:	e8 d0 fe ff ff       	call   8019a2 <_pipeisclosed>
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	74 e3                	je     801ab9 <devpipe_read+0x30>
				return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb d4                	jmp    801ab1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801add:	99                   	cltd   
  801ade:	c1 ea 1b             	shr    $0x1b,%edx
  801ae1:	01 d0                	add    %edx,%eax
  801ae3:	83 e0 1f             	and    $0x1f,%eax
  801ae6:	29 d0                	sub    %edx,%eax
  801ae8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801aed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801af3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801af6:	83 c6 01             	add    $0x1,%esi
  801af9:	eb aa                	jmp    801aa5 <devpipe_read+0x1c>

00801afb <pipe>:
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b06:	50                   	push   %eax
  801b07:	e8 45 f5 ff ff       	call   801051 <fd_alloc>
  801b0c:	89 c3                	mov    %eax,%ebx
  801b0e:	83 c4 10             	add    $0x10,%esp
  801b11:	85 c0                	test   %eax,%eax
  801b13:	0f 88 23 01 00 00    	js     801c3c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	68 07 04 00 00       	push   $0x407
  801b21:	ff 75 f4             	pushl  -0xc(%ebp)
  801b24:	6a 00                	push   $0x0
  801b26:	e8 8c f2 ff ff       	call   800db7 <sys_page_alloc>
  801b2b:	89 c3                	mov    %eax,%ebx
  801b2d:	83 c4 10             	add    $0x10,%esp
  801b30:	85 c0                	test   %eax,%eax
  801b32:	0f 88 04 01 00 00    	js     801c3c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801b38:	83 ec 0c             	sub    $0xc,%esp
  801b3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b3e:	50                   	push   %eax
  801b3f:	e8 0d f5 ff ff       	call   801051 <fd_alloc>
  801b44:	89 c3                	mov    %eax,%ebx
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	0f 88 db 00 00 00    	js     801c2c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	68 07 04 00 00       	push   $0x407
  801b59:	ff 75 f0             	pushl  -0x10(%ebp)
  801b5c:	6a 00                	push   $0x0
  801b5e:	e8 54 f2 ff ff       	call   800db7 <sys_page_alloc>
  801b63:	89 c3                	mov    %eax,%ebx
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	0f 88 bc 00 00 00    	js     801c2c <pipe+0x131>
	va = fd2data(fd0);
  801b70:	83 ec 0c             	sub    $0xc,%esp
  801b73:	ff 75 f4             	pushl  -0xc(%ebp)
  801b76:	e8 bf f4 ff ff       	call   80103a <fd2data>
  801b7b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b7d:	83 c4 0c             	add    $0xc,%esp
  801b80:	68 07 04 00 00       	push   $0x407
  801b85:	50                   	push   %eax
  801b86:	6a 00                	push   $0x0
  801b88:	e8 2a f2 ff ff       	call   800db7 <sys_page_alloc>
  801b8d:	89 c3                	mov    %eax,%ebx
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	85 c0                	test   %eax,%eax
  801b94:	0f 88 82 00 00 00    	js     801c1c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b9a:	83 ec 0c             	sub    $0xc,%esp
  801b9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba0:	e8 95 f4 ff ff       	call   80103a <fd2data>
  801ba5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bac:	50                   	push   %eax
  801bad:	6a 00                	push   $0x0
  801baf:	56                   	push   %esi
  801bb0:	6a 00                	push   $0x0
  801bb2:	e8 43 f2 ff ff       	call   800dfa <sys_page_map>
  801bb7:	89 c3                	mov    %eax,%ebx
  801bb9:	83 c4 20             	add    $0x20,%esp
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 4e                	js     801c0e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801bc0:	a1 24 30 80 00       	mov    0x803024,%eax
  801bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc8:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcd:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801bd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd7:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	ff 75 f4             	pushl  -0xc(%ebp)
  801be9:	e8 3c f4 ff ff       	call   80102a <fd2num>
  801bee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801bf3:	83 c4 04             	add    $0x4,%esp
  801bf6:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf9:	e8 2c f4 ff ff       	call   80102a <fd2num>
  801bfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c01:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c0c:	eb 2e                	jmp    801c3c <pipe+0x141>
	sys_page_unmap(0, va);
  801c0e:	83 ec 08             	sub    $0x8,%esp
  801c11:	56                   	push   %esi
  801c12:	6a 00                	push   $0x0
  801c14:	e8 23 f2 ff ff       	call   800e3c <sys_page_unmap>
  801c19:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c1c:	83 ec 08             	sub    $0x8,%esp
  801c1f:	ff 75 f0             	pushl  -0x10(%ebp)
  801c22:	6a 00                	push   $0x0
  801c24:	e8 13 f2 ff ff       	call   800e3c <sys_page_unmap>
  801c29:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c2c:	83 ec 08             	sub    $0x8,%esp
  801c2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c32:	6a 00                	push   $0x0
  801c34:	e8 03 f2 ff ff       	call   800e3c <sys_page_unmap>
  801c39:	83 c4 10             	add    $0x10,%esp
}
  801c3c:	89 d8                	mov    %ebx,%eax
  801c3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c41:	5b                   	pop    %ebx
  801c42:	5e                   	pop    %esi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <pipeisclosed>:
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	e8 4c f4 ff ff       	call   8010a3 <fd_lookup>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 18                	js     801c76 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c5e:	83 ec 0c             	sub    $0xc,%esp
  801c61:	ff 75 f4             	pushl  -0xc(%ebp)
  801c64:	e8 d1 f3 ff ff       	call   80103a <fd2data>
	return _pipeisclosed(fd, p);
  801c69:	89 c2                	mov    %eax,%edx
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	e8 2f fd ff ff       	call   8019a2 <_pipeisclosed>
  801c73:	83 c4 10             	add    $0x10,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7d:	c3                   	ret    

00801c7e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c84:	68 8e 26 80 00       	push   $0x80268e
  801c89:	ff 75 0c             	pushl  0xc(%ebp)
  801c8c:	e8 34 ed ff ff       	call   8009c5 <strcpy>
	return 0;
}
  801c91:	b8 00 00 00 00       	mov    $0x0,%eax
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <devcons_write>:
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	57                   	push   %edi
  801c9c:	56                   	push   %esi
  801c9d:	53                   	push   %ebx
  801c9e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ca4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ca9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801caf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cb2:	73 31                	jae    801ce5 <devcons_write+0x4d>
		m = n - tot;
  801cb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cb7:	29 f3                	sub    %esi,%ebx
  801cb9:	83 fb 7f             	cmp    $0x7f,%ebx
  801cbc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801cc1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	53                   	push   %ebx
  801cc8:	89 f0                	mov    %esi,%eax
  801cca:	03 45 0c             	add    0xc(%ebp),%eax
  801ccd:	50                   	push   %eax
  801cce:	57                   	push   %edi
  801ccf:	e8 7f ee ff ff       	call   800b53 <memmove>
		sys_cputs(buf, m);
  801cd4:	83 c4 08             	add    $0x8,%esp
  801cd7:	53                   	push   %ebx
  801cd8:	57                   	push   %edi
  801cd9:	e8 1d f0 ff ff       	call   800cfb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801cde:	01 de                	add    %ebx,%esi
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	eb ca                	jmp    801caf <devcons_write+0x17>
}
  801ce5:	89 f0                	mov    %esi,%eax
  801ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5f                   	pop    %edi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    

00801cef <devcons_read>:
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 08             	sub    $0x8,%esp
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801cfa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cfe:	74 21                	je     801d21 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801d00:	e8 14 f0 ff ff       	call   800d19 <sys_cgetc>
  801d05:	85 c0                	test   %eax,%eax
  801d07:	75 07                	jne    801d10 <devcons_read+0x21>
		sys_yield();
  801d09:	e8 8a f0 ff ff       	call   800d98 <sys_yield>
  801d0e:	eb f0                	jmp    801d00 <devcons_read+0x11>
	if (c < 0)
  801d10:	78 0f                	js     801d21 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801d12:	83 f8 04             	cmp    $0x4,%eax
  801d15:	74 0c                	je     801d23 <devcons_read+0x34>
	*(char*)vbuf = c;
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	88 02                	mov    %al,(%edx)
	return 1;
  801d1c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    
		return 0;
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	eb f7                	jmp    801d21 <devcons_read+0x32>

00801d2a <cputchar>:
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d36:	6a 01                	push   $0x1
  801d38:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d3b:	50                   	push   %eax
  801d3c:	e8 ba ef ff ff       	call   800cfb <sys_cputs>
}
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <getchar>:
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d4c:	6a 01                	push   $0x1
  801d4e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d51:	50                   	push   %eax
  801d52:	6a 00                	push   $0x0
  801d54:	e8 b5 f5 ff ff       	call   80130e <read>
	if (r < 0)
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 06                	js     801d66 <getchar+0x20>
	if (r < 1)
  801d60:	74 06                	je     801d68 <getchar+0x22>
	return c;
  801d62:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    
		return -E_EOF;
  801d68:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d6d:	eb f7                	jmp    801d66 <getchar+0x20>

00801d6f <iscons>:
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d78:	50                   	push   %eax
  801d79:	ff 75 08             	pushl  0x8(%ebp)
  801d7c:	e8 22 f3 ff ff       	call   8010a3 <fd_lookup>
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	85 c0                	test   %eax,%eax
  801d86:	78 11                	js     801d99 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801d91:	39 10                	cmp    %edx,(%eax)
  801d93:	0f 94 c0             	sete   %al
  801d96:	0f b6 c0             	movzbl %al,%eax
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <opencons>:
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801da1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da4:	50                   	push   %eax
  801da5:	e8 a7 f2 ff ff       	call   801051 <fd_alloc>
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	85 c0                	test   %eax,%eax
  801daf:	78 3a                	js     801deb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801db1:	83 ec 04             	sub    $0x4,%esp
  801db4:	68 07 04 00 00       	push   $0x407
  801db9:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbc:	6a 00                	push   $0x0
  801dbe:	e8 f4 ef ff ff       	call   800db7 <sys_page_alloc>
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	78 21                	js     801deb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcd:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801dd3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ddf:	83 ec 0c             	sub    $0xc,%esp
  801de2:	50                   	push   %eax
  801de3:	e8 42 f2 ff ff       	call   80102a <fd2num>
  801de8:	83 c4 10             	add    $0x10,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	8b 75 08             	mov    0x8(%ebp),%esi
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  801dfb:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801dfd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e02:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	50                   	push   %eax
  801e09:	e8 9a f1 ff ff       	call   800fa8 <sys_ipc_recv>
	if (from_env_store)
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	85 f6                	test   %esi,%esi
  801e13:	74 14                	je     801e29 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  801e15:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 09                	js     801e27 <ipc_recv+0x3a>
  801e1e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e24:	8b 52 78             	mov    0x78(%edx),%edx
  801e27:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  801e29:	85 db                	test   %ebx,%ebx
  801e2b:	74 14                	je     801e41 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  801e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 09                	js     801e3f <ipc_recv+0x52>
  801e36:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e3c:	8b 52 7c             	mov    0x7c(%edx),%edx
  801e3f:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  801e41:	85 c0                	test   %eax,%eax
  801e43:	78 08                	js     801e4d <ipc_recv+0x60>
  801e45:	a1 08 40 80 00       	mov    0x804008,%eax
  801e4a:	8b 40 74             	mov    0x74(%eax),%eax
}
  801e4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e50:	5b                   	pop    %ebx
  801e51:	5e                   	pop    %esi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    

00801e54 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 08             	sub    $0x8,%esp
  801e5a:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e64:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801e67:	ff 75 14             	pushl  0x14(%ebp)
  801e6a:	50                   	push   %eax
  801e6b:	ff 75 0c             	pushl  0xc(%ebp)
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	e8 0f f1 ff ff       	call   800f85 <sys_ipc_try_send>
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	78 02                	js     801e7f <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  801e7f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e82:	75 07                	jne    801e8b <ipc_send+0x37>
		sys_yield();
  801e84:	e8 0f ef ff ff       	call   800d98 <sys_yield>
}
  801e89:	eb f2                	jmp    801e7d <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  801e8b:	50                   	push   %eax
  801e8c:	68 9a 26 80 00       	push   $0x80269a
  801e91:	6a 3c                	push   $0x3c
  801e93:	68 ae 26 80 00       	push   $0x8026ae
  801e98:	e8 3f e3 ff ff       	call   8001dc <_panic>

00801e9d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ea3:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  801ea8:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801eab:	c1 e0 04             	shl    $0x4,%eax
  801eae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801eb3:	8b 40 50             	mov    0x50(%eax),%eax
  801eb6:	39 c8                	cmp    %ecx,%eax
  801eb8:	74 12                	je     801ecc <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801eba:	83 c2 01             	add    $0x1,%edx
  801ebd:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  801ec3:	75 e3                	jne    801ea8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	eb 0e                	jmp    801eda <ipc_find_env+0x3d>
			return envs[i].env_id;
  801ecc:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801ecf:	c1 e0 04             	shl    $0x4,%eax
  801ed2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ed7:	8b 40 48             	mov    0x48(%eax),%eax
}
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    

00801edc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ee2:	89 d0                	mov    %edx,%eax
  801ee4:	c1 e8 16             	shr    $0x16,%eax
  801ee7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ef3:	f6 c1 01             	test   $0x1,%cl
  801ef6:	74 1d                	je     801f15 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ef8:	c1 ea 0c             	shr    $0xc,%edx
  801efb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f02:	f6 c2 01             	test   $0x1,%dl
  801f05:	74 0e                	je     801f15 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f07:	c1 ea 0c             	shr    $0xc,%edx
  801f0a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f11:	ef 
  801f12:	0f b7 c0             	movzwl %ax,%eax
}
  801f15:	5d                   	pop    %ebp
  801f16:	c3                   	ret    
  801f17:	66 90                	xchg   %ax,%ax
  801f19:	66 90                	xchg   %ax,%ax
  801f1b:	66 90                	xchg   %ax,%ax
  801f1d:	66 90                	xchg   %ax,%ax
  801f1f:	90                   	nop

00801f20 <__udivdi3>:
  801f20:	55                   	push   %ebp
  801f21:	57                   	push   %edi
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	83 ec 1c             	sub    $0x1c,%esp
  801f27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f37:	85 d2                	test   %edx,%edx
  801f39:	75 4d                	jne    801f88 <__udivdi3+0x68>
  801f3b:	39 f3                	cmp    %esi,%ebx
  801f3d:	76 19                	jbe    801f58 <__udivdi3+0x38>
  801f3f:	31 ff                	xor    %edi,%edi
  801f41:	89 e8                	mov    %ebp,%eax
  801f43:	89 f2                	mov    %esi,%edx
  801f45:	f7 f3                	div    %ebx
  801f47:	89 fa                	mov    %edi,%edx
  801f49:	83 c4 1c             	add    $0x1c,%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5f                   	pop    %edi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    
  801f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f58:	89 d9                	mov    %ebx,%ecx
  801f5a:	85 db                	test   %ebx,%ebx
  801f5c:	75 0b                	jne    801f69 <__udivdi3+0x49>
  801f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f63:	31 d2                	xor    %edx,%edx
  801f65:	f7 f3                	div    %ebx
  801f67:	89 c1                	mov    %eax,%ecx
  801f69:	31 d2                	xor    %edx,%edx
  801f6b:	89 f0                	mov    %esi,%eax
  801f6d:	f7 f1                	div    %ecx
  801f6f:	89 c6                	mov    %eax,%esi
  801f71:	89 e8                	mov    %ebp,%eax
  801f73:	89 f7                	mov    %esi,%edi
  801f75:	f7 f1                	div    %ecx
  801f77:	89 fa                	mov    %edi,%edx
  801f79:	83 c4 1c             	add    $0x1c,%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5f                   	pop    %edi
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    
  801f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f88:	39 f2                	cmp    %esi,%edx
  801f8a:	77 1c                	ja     801fa8 <__udivdi3+0x88>
  801f8c:	0f bd fa             	bsr    %edx,%edi
  801f8f:	83 f7 1f             	xor    $0x1f,%edi
  801f92:	75 2c                	jne    801fc0 <__udivdi3+0xa0>
  801f94:	39 f2                	cmp    %esi,%edx
  801f96:	72 06                	jb     801f9e <__udivdi3+0x7e>
  801f98:	31 c0                	xor    %eax,%eax
  801f9a:	39 eb                	cmp    %ebp,%ebx
  801f9c:	77 a9                	ja     801f47 <__udivdi3+0x27>
  801f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa3:	eb a2                	jmp    801f47 <__udivdi3+0x27>
  801fa5:	8d 76 00             	lea    0x0(%esi),%esi
  801fa8:	31 ff                	xor    %edi,%edi
  801faa:	31 c0                	xor    %eax,%eax
  801fac:	89 fa                	mov    %edi,%edx
  801fae:	83 c4 1c             	add    $0x1c,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
  801fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	89 f9                	mov    %edi,%ecx
  801fc2:	b8 20 00 00 00       	mov    $0x20,%eax
  801fc7:	29 f8                	sub    %edi,%eax
  801fc9:	d3 e2                	shl    %cl,%edx
  801fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fcf:	89 c1                	mov    %eax,%ecx
  801fd1:	89 da                	mov    %ebx,%edx
  801fd3:	d3 ea                	shr    %cl,%edx
  801fd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801fd9:	09 d1                	or     %edx,%ecx
  801fdb:	89 f2                	mov    %esi,%edx
  801fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fe1:	89 f9                	mov    %edi,%ecx
  801fe3:	d3 e3                	shl    %cl,%ebx
  801fe5:	89 c1                	mov    %eax,%ecx
  801fe7:	d3 ea                	shr    %cl,%edx
  801fe9:	89 f9                	mov    %edi,%ecx
  801feb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fef:	89 eb                	mov    %ebp,%ebx
  801ff1:	d3 e6                	shl    %cl,%esi
  801ff3:	89 c1                	mov    %eax,%ecx
  801ff5:	d3 eb                	shr    %cl,%ebx
  801ff7:	09 de                	or     %ebx,%esi
  801ff9:	89 f0                	mov    %esi,%eax
  801ffb:	f7 74 24 08          	divl   0x8(%esp)
  801fff:	89 d6                	mov    %edx,%esi
  802001:	89 c3                	mov    %eax,%ebx
  802003:	f7 64 24 0c          	mull   0xc(%esp)
  802007:	39 d6                	cmp    %edx,%esi
  802009:	72 15                	jb     802020 <__udivdi3+0x100>
  80200b:	89 f9                	mov    %edi,%ecx
  80200d:	d3 e5                	shl    %cl,%ebp
  80200f:	39 c5                	cmp    %eax,%ebp
  802011:	73 04                	jae    802017 <__udivdi3+0xf7>
  802013:	39 d6                	cmp    %edx,%esi
  802015:	74 09                	je     802020 <__udivdi3+0x100>
  802017:	89 d8                	mov    %ebx,%eax
  802019:	31 ff                	xor    %edi,%edi
  80201b:	e9 27 ff ff ff       	jmp    801f47 <__udivdi3+0x27>
  802020:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802023:	31 ff                	xor    %edi,%edi
  802025:	e9 1d ff ff ff       	jmp    801f47 <__udivdi3+0x27>
  80202a:	66 90                	xchg   %ax,%ax
  80202c:	66 90                	xchg   %ax,%ax
  80202e:	66 90                	xchg   %ax,%ax

00802030 <__umoddi3>:
  802030:	55                   	push   %ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 1c             	sub    $0x1c,%esp
  802037:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80203b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80203f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802043:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802047:	89 da                	mov    %ebx,%edx
  802049:	85 c0                	test   %eax,%eax
  80204b:	75 43                	jne    802090 <__umoddi3+0x60>
  80204d:	39 df                	cmp    %ebx,%edi
  80204f:	76 17                	jbe    802068 <__umoddi3+0x38>
  802051:	89 f0                	mov    %esi,%eax
  802053:	f7 f7                	div    %edi
  802055:	89 d0                	mov    %edx,%eax
  802057:	31 d2                	xor    %edx,%edx
  802059:	83 c4 1c             	add    $0x1c,%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5e                   	pop    %esi
  80205e:	5f                   	pop    %edi
  80205f:	5d                   	pop    %ebp
  802060:	c3                   	ret    
  802061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802068:	89 fd                	mov    %edi,%ebp
  80206a:	85 ff                	test   %edi,%edi
  80206c:	75 0b                	jne    802079 <__umoddi3+0x49>
  80206e:	b8 01 00 00 00       	mov    $0x1,%eax
  802073:	31 d2                	xor    %edx,%edx
  802075:	f7 f7                	div    %edi
  802077:	89 c5                	mov    %eax,%ebp
  802079:	89 d8                	mov    %ebx,%eax
  80207b:	31 d2                	xor    %edx,%edx
  80207d:	f7 f5                	div    %ebp
  80207f:	89 f0                	mov    %esi,%eax
  802081:	f7 f5                	div    %ebp
  802083:	89 d0                	mov    %edx,%eax
  802085:	eb d0                	jmp    802057 <__umoddi3+0x27>
  802087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80208e:	66 90                	xchg   %ax,%ax
  802090:	89 f1                	mov    %esi,%ecx
  802092:	39 d8                	cmp    %ebx,%eax
  802094:	76 0a                	jbe    8020a0 <__umoddi3+0x70>
  802096:	89 f0                	mov    %esi,%eax
  802098:	83 c4 1c             	add    $0x1c,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5f                   	pop    %edi
  80209e:	5d                   	pop    %ebp
  80209f:	c3                   	ret    
  8020a0:	0f bd e8             	bsr    %eax,%ebp
  8020a3:	83 f5 1f             	xor    $0x1f,%ebp
  8020a6:	75 20                	jne    8020c8 <__umoddi3+0x98>
  8020a8:	39 d8                	cmp    %ebx,%eax
  8020aa:	0f 82 b0 00 00 00    	jb     802160 <__umoddi3+0x130>
  8020b0:	39 f7                	cmp    %esi,%edi
  8020b2:	0f 86 a8 00 00 00    	jbe    802160 <__umoddi3+0x130>
  8020b8:	89 c8                	mov    %ecx,%eax
  8020ba:	83 c4 1c             	add    $0x1c,%esp
  8020bd:	5b                   	pop    %ebx
  8020be:	5e                   	pop    %esi
  8020bf:	5f                   	pop    %edi
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    
  8020c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020c8:	89 e9                	mov    %ebp,%ecx
  8020ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8020cf:	29 ea                	sub    %ebp,%edx
  8020d1:	d3 e0                	shl    %cl,%eax
  8020d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d7:	89 d1                	mov    %edx,%ecx
  8020d9:	89 f8                	mov    %edi,%eax
  8020db:	d3 e8                	shr    %cl,%eax
  8020dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020e9:	09 c1                	or     %eax,%ecx
  8020eb:	89 d8                	mov    %ebx,%eax
  8020ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020f1:	89 e9                	mov    %ebp,%ecx
  8020f3:	d3 e7                	shl    %cl,%edi
  8020f5:	89 d1                	mov    %edx,%ecx
  8020f7:	d3 e8                	shr    %cl,%eax
  8020f9:	89 e9                	mov    %ebp,%ecx
  8020fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020ff:	d3 e3                	shl    %cl,%ebx
  802101:	89 c7                	mov    %eax,%edi
  802103:	89 d1                	mov    %edx,%ecx
  802105:	89 f0                	mov    %esi,%eax
  802107:	d3 e8                	shr    %cl,%eax
  802109:	89 e9                	mov    %ebp,%ecx
  80210b:	89 fa                	mov    %edi,%edx
  80210d:	d3 e6                	shl    %cl,%esi
  80210f:	09 d8                	or     %ebx,%eax
  802111:	f7 74 24 08          	divl   0x8(%esp)
  802115:	89 d1                	mov    %edx,%ecx
  802117:	89 f3                	mov    %esi,%ebx
  802119:	f7 64 24 0c          	mull   0xc(%esp)
  80211d:	89 c6                	mov    %eax,%esi
  80211f:	89 d7                	mov    %edx,%edi
  802121:	39 d1                	cmp    %edx,%ecx
  802123:	72 06                	jb     80212b <__umoddi3+0xfb>
  802125:	75 10                	jne    802137 <__umoddi3+0x107>
  802127:	39 c3                	cmp    %eax,%ebx
  802129:	73 0c                	jae    802137 <__umoddi3+0x107>
  80212b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80212f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802133:	89 d7                	mov    %edx,%edi
  802135:	89 c6                	mov    %eax,%esi
  802137:	89 ca                	mov    %ecx,%edx
  802139:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80213e:	29 f3                	sub    %esi,%ebx
  802140:	19 fa                	sbb    %edi,%edx
  802142:	89 d0                	mov    %edx,%eax
  802144:	d3 e0                	shl    %cl,%eax
  802146:	89 e9                	mov    %ebp,%ecx
  802148:	d3 eb                	shr    %cl,%ebx
  80214a:	d3 ea                	shr    %cl,%edx
  80214c:	09 d8                	or     %ebx,%eax
  80214e:	83 c4 1c             	add    $0x1c,%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    
  802156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80215d:	8d 76 00             	lea    0x0(%esi),%esi
  802160:	89 da                	mov    %ebx,%edx
  802162:	29 fe                	sub    %edi,%esi
  802164:	19 c2                	sbb    %eax,%edx
  802166:	89 f1                	mov    %esi,%ecx
  802168:	89 c8                	mov    %ecx,%eax
  80216a:	e9 4b ff ff ff       	jmp    8020ba <__umoddi3+0x8a>
