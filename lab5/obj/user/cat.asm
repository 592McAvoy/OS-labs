
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fc 00 00 00       	call   80012d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 6c 12 00 00       	call   8012ba <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 1f 13 00 00       	call   801386 <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 20 21 80 00       	push   $0x802120
  80007a:	6a 0d                	push   $0xd
  80007c:	68 3b 21 80 00       	push   $0x80213b
  800081:	e8 02 01 00 00       	call   800188 <_panic>
	if (n < 0)
  800086:	78 07                	js     80008f <cat+0x5c>
		panic("error reading %s: %e", s, n);
}
  800088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	ff 75 0c             	pushl  0xc(%ebp)
  800096:	68 46 21 80 00       	push   $0x802146
  80009b:	6a 0f                	push   $0xf
  80009d:	68 3b 21 80 00       	push   $0x80213b
  8000a2:	e8 e1 00 00 00       	call   800188 <_panic>

008000a7 <umain>:

void
umain(int argc, char **argv)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b3:	c7 05 00 30 80 00 5b 	movl   $0x80215b,0x803000
  8000ba:	21 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bd:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c6:	75 31                	jne    8000f9 <umain+0x52>
		cat(0, "<stdin>");
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 5f 21 80 00       	push   $0x80215f
  8000d0:	6a 00                	push   $0x0
  8000d2:	e8 5c ff ff ff       	call   800033 <cat>
  8000d7:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	50                   	push   %eax
  8000e6:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000e9:	68 67 21 80 00       	push   $0x802167
  8000ee:	e8 cd 17 00 00       	call   8018c0 <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c3 01             	add    $0x1,%ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 12 16 00 00       	call   80171d <open>
  80010b:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	85 c0                	test   %eax,%eax
  800112:	78 ce                	js     8000e2 <umain+0x3b>
				cat(f, argv[i]);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011a:	50                   	push   %eax
  80011b:	e8 13 ff ff ff       	call   800033 <cat>
				close(f);
  800120:	89 34 24             	mov    %esi,(%esp)
  800123:	e8 54 10 00 00       	call   80117c <close>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb c9                	jmp    8000f6 <umain+0x4f>

0080012d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800135:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800138:	e8 e8 0b 00 00       	call   800d25 <sys_getenvid>
  80013d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800142:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800145:	c1 e0 04             	shl    $0x4,%eax
  800148:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014d:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800152:	85 db                	test   %ebx,%ebx
  800154:	7e 07                	jle    80015d <libmain+0x30>
		binaryname = argv[0];
  800156:	8b 06                	mov    (%esi),%eax
  800158:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	e8 40 ff ff ff       	call   8000a7 <umain>

	// exit gracefully
	exit();
  800167:	e8 0a 00 00 00       	call   800176 <exit>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    

00800176 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  80017c:	6a 00                	push   $0x0
  80017e:	e8 61 0b 00 00       	call   800ce4 <sys_env_destroy>
}
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	56                   	push   %esi
  80018c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80018d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800190:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800196:	e8 8a 0b 00 00       	call   800d25 <sys_getenvid>
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	56                   	push   %esi
  8001a5:	50                   	push   %eax
  8001a6:	68 84 21 80 00       	push   $0x802184
  8001ab:	e8 b3 00 00 00       	call   800263 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b0:	83 c4 18             	add    $0x18,%esp
  8001b3:	53                   	push   %ebx
  8001b4:	ff 75 10             	pushl  0x10(%ebp)
  8001b7:	e8 56 00 00 00       	call   800212 <vcprintf>
	cprintf("\n");
  8001bc:	c7 04 24 27 26 80 00 	movl   $0x802627,(%esp)
  8001c3:	e8 9b 00 00 00       	call   800263 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001cb:	cc                   	int3   
  8001cc:	eb fd                	jmp    8001cb <_panic+0x43>

008001ce <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	53                   	push   %ebx
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d8:	8b 13                	mov    (%ebx),%edx
  8001da:	8d 42 01             	lea    0x1(%edx),%eax
  8001dd:	89 03                	mov    %eax,(%ebx)
  8001df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001eb:	74 09                	je     8001f6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ed:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	68 ff 00 00 00       	push   $0xff
  8001fe:	8d 43 08             	lea    0x8(%ebx),%eax
  800201:	50                   	push   %eax
  800202:	e8 a0 0a 00 00       	call   800ca7 <sys_cputs>
		b->idx = 0;
  800207:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	eb db                	jmp    8001ed <putch+0x1f>

00800212 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800222:	00 00 00 
	b.cnt = 0;
  800225:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022f:	ff 75 0c             	pushl  0xc(%ebp)
  800232:	ff 75 08             	pushl  0x8(%ebp)
  800235:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023b:	50                   	push   %eax
  80023c:	68 ce 01 80 00       	push   $0x8001ce
  800241:	e8 4a 01 00 00       	call   800390 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800246:	83 c4 08             	add    $0x8,%esp
  800249:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80024f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800255:	50                   	push   %eax
  800256:	e8 4c 0a 00 00       	call   800ca7 <sys_cputs>

	return b.cnt;
}
  80025b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800269:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80026c:	50                   	push   %eax
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 9d ff ff ff       	call   800212 <vcprintf>
	va_end(ap);

	return cnt;
}
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	57                   	push   %edi
  80027b:	56                   	push   %esi
  80027c:	53                   	push   %ebx
  80027d:	83 ec 1c             	sub    $0x1c,%esp
  800280:	89 c6                	mov    %eax,%esi
  800282:	89 d7                	mov    %edx,%edi
  800284:	8b 45 08             	mov    0x8(%ebp),%eax
  800287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800290:	8b 45 10             	mov    0x10(%ebp),%eax
  800293:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800296:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80029a:	74 2c                	je     8002c8 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002a9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002ac:	39 c2                	cmp    %eax,%edx
  8002ae:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b1:	73 43                	jae    8002f6 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b3:	83 eb 01             	sub    $0x1,%ebx
  8002b6:	85 db                	test   %ebx,%ebx
  8002b8:	7e 6c                	jle    800326 <printnum+0xaf>
			putch(padc, putdat);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	57                   	push   %edi
  8002be:	ff 75 18             	pushl  0x18(%ebp)
  8002c1:	ff d6                	call   *%esi
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	eb eb                	jmp    8002b3 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	6a 20                	push   $0x20
  8002cd:	6a 00                	push   $0x0
  8002cf:	50                   	push   %eax
  8002d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d6:	89 fa                	mov    %edi,%edx
  8002d8:	89 f0                	mov    %esi,%eax
  8002da:	e8 98 ff ff ff       	call   800277 <printnum>
		while (--width > 0)
  8002df:	83 c4 20             	add    $0x20,%esp
  8002e2:	83 eb 01             	sub    $0x1,%ebx
  8002e5:	85 db                	test   %ebx,%ebx
  8002e7:	7e 65                	jle    80034e <printnum+0xd7>
			putch(padc, putdat);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	57                   	push   %edi
  8002ed:	6a 20                	push   $0x20
  8002ef:	ff d6                	call   *%esi
  8002f1:	83 c4 10             	add    $0x10,%esp
  8002f4:	eb ec                	jmp    8002e2 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	ff 75 18             	pushl  0x18(%ebp)
  8002fc:	83 eb 01             	sub    $0x1,%ebx
  8002ff:	53                   	push   %ebx
  800300:	50                   	push   %eax
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 75 dc             	pushl  -0x24(%ebp)
  800307:	ff 75 d8             	pushl  -0x28(%ebp)
  80030a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030d:	ff 75 e0             	pushl  -0x20(%ebp)
  800310:	e8 bb 1b 00 00       	call   801ed0 <__udivdi3>
  800315:	83 c4 18             	add    $0x18,%esp
  800318:	52                   	push   %edx
  800319:	50                   	push   %eax
  80031a:	89 fa                	mov    %edi,%edx
  80031c:	89 f0                	mov    %esi,%eax
  80031e:	e8 54 ff ff ff       	call   800277 <printnum>
  800323:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	57                   	push   %edi
  80032a:	83 ec 04             	sub    $0x4,%esp
  80032d:	ff 75 dc             	pushl  -0x24(%ebp)
  800330:	ff 75 d8             	pushl  -0x28(%ebp)
  800333:	ff 75 e4             	pushl  -0x1c(%ebp)
  800336:	ff 75 e0             	pushl  -0x20(%ebp)
  800339:	e8 a2 1c 00 00       	call   801fe0 <__umoddi3>
  80033e:	83 c4 14             	add    $0x14,%esp
  800341:	0f be 80 a7 21 80 00 	movsbl 0x8021a7(%eax),%eax
  800348:	50                   	push   %eax
  800349:	ff d6                	call   *%esi
  80034b:	83 c4 10             	add    $0x10,%esp
}
  80034e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800360:	8b 10                	mov    (%eax),%edx
  800362:	3b 50 04             	cmp    0x4(%eax),%edx
  800365:	73 0a                	jae    800371 <sprintputch+0x1b>
		*b->buf++ = ch;
  800367:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036a:	89 08                	mov    %ecx,(%eax)
  80036c:	8b 45 08             	mov    0x8(%ebp),%eax
  80036f:	88 02                	mov    %al,(%edx)
}
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <printfmt>:
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800379:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037c:	50                   	push   %eax
  80037d:	ff 75 10             	pushl  0x10(%ebp)
  800380:	ff 75 0c             	pushl  0xc(%ebp)
  800383:	ff 75 08             	pushl  0x8(%ebp)
  800386:	e8 05 00 00 00       	call   800390 <vprintfmt>
}
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <vprintfmt>:
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 3c             	sub    $0x3c,%esp
  800399:	8b 75 08             	mov    0x8(%ebp),%esi
  80039c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039f:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a2:	e9 b4 03 00 00       	jmp    80075b <vprintfmt+0x3cb>
		padc = ' ';
  8003a7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8003ab:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8003b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003b9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003cc:	8d 47 01             	lea    0x1(%edi),%eax
  8003cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d2:	0f b6 17             	movzbl (%edi),%edx
  8003d5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d8:	3c 55                	cmp    $0x55,%al
  8003da:	0f 87 c8 04 00 00    	ja     8008a8 <vprintfmt+0x518>
  8003e0:	0f b6 c0             	movzbl %al,%eax
  8003e3:	ff 24 85 80 23 80 00 	jmp    *0x802380(,%eax,4)
  8003ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8003ed:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8003f4:	eb d6                	jmp    8003cc <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003fd:	eb cd                	jmp    8003cc <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	0f b6 d2             	movzbl %dl,%edx
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800405:	b8 00 00 00 00       	mov    $0x0,%eax
  80040a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80040d:	eb 0c                	jmp    80041b <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800412:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800416:	eb b4                	jmp    8003cc <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800418:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80041b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80041e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800422:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800425:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800428:	83 f9 09             	cmp    $0x9,%ecx
  80042b:	76 eb                	jbe    800418 <vprintfmt+0x88>
  80042d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800433:	eb 14                	jmp    800449 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800435:	8b 45 14             	mov    0x14(%ebp),%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043d:	8b 45 14             	mov    0x14(%ebp),%eax
  800440:	8d 40 04             	lea    0x4(%eax),%eax
  800443:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800449:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044d:	0f 89 79 ff ff ff    	jns    8003cc <vprintfmt+0x3c>
				width = precision, precision = -1;
  800453:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800456:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800459:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800460:	e9 67 ff ff ff       	jmp    8003cc <vprintfmt+0x3c>
  800465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	ba 00 00 00 00       	mov    $0x0,%edx
  80046f:	0f 49 d0             	cmovns %eax,%edx
  800472:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800475:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800478:	e9 4f ff ff ff       	jmp    8003cc <vprintfmt+0x3c>
  80047d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800480:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800487:	e9 40 ff ff ff       	jmp    8003cc <vprintfmt+0x3c>
			lflag++;
  80048c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80048f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800492:	e9 35 ff ff ff       	jmp    8003cc <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 78 04             	lea    0x4(%eax),%edi
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	53                   	push   %ebx
  8004a1:	ff 30                	pushl  (%eax)
  8004a3:	ff d6                	call   *%esi
			break;
  8004a5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004a8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004ab:	e9 a8 02 00 00       	jmp    800758 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	8d 78 04             	lea    0x4(%eax),%edi
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	99                   	cltd   
  8004b9:	31 d0                	xor    %edx,%eax
  8004bb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004bd:	83 f8 0f             	cmp    $0xf,%eax
  8004c0:	7f 23                	jg     8004e5 <vprintfmt+0x155>
  8004c2:	8b 14 85 e0 24 80 00 	mov    0x8024e0(,%eax,4),%edx
  8004c9:	85 d2                	test   %edx,%edx
  8004cb:	74 18                	je     8004e5 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8004cd:	52                   	push   %edx
  8004ce:	68 f5 25 80 00       	push   $0x8025f5
  8004d3:	53                   	push   %ebx
  8004d4:	56                   	push   %esi
  8004d5:	e8 99 fe ff ff       	call   800373 <printfmt>
  8004da:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004dd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e0:	e9 73 02 00 00       	jmp    800758 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8004e5:	50                   	push   %eax
  8004e6:	68 bf 21 80 00       	push   $0x8021bf
  8004eb:	53                   	push   %ebx
  8004ec:	56                   	push   %esi
  8004ed:	e8 81 fe ff ff       	call   800373 <printfmt>
  8004f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004f8:	e9 5b 02 00 00       	jmp    800758 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	83 c0 04             	add    $0x4,%eax
  800503:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80050b:	85 d2                	test   %edx,%edx
  80050d:	b8 b8 21 80 00       	mov    $0x8021b8,%eax
  800512:	0f 45 c2             	cmovne %edx,%eax
  800515:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800518:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80051c:	7e 06                	jle    800524 <vprintfmt+0x194>
  80051e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800522:	75 0d                	jne    800531 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800524:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800527:	89 c7                	mov    %eax,%edi
  800529:	03 45 e0             	add    -0x20(%ebp),%eax
  80052c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80052f:	eb 53                	jmp    800584 <vprintfmt+0x1f4>
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	ff 75 d8             	pushl  -0x28(%ebp)
  800537:	50                   	push   %eax
  800538:	e8 13 04 00 00       	call   800950 <strnlen>
  80053d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800540:	29 c1                	sub    %eax,%ecx
  800542:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80054a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80054e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800551:	eb 0f                	jmp    800562 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800553:	83 ec 08             	sub    $0x8,%esp
  800556:	53                   	push   %ebx
  800557:	ff 75 e0             	pushl  -0x20(%ebp)
  80055a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80055c:	83 ef 01             	sub    $0x1,%edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f ed                	jg     800553 <vprintfmt+0x1c3>
  800566:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800569:	85 d2                	test   %edx,%edx
  80056b:	b8 00 00 00 00       	mov    $0x0,%eax
  800570:	0f 49 c2             	cmovns %edx,%eax
  800573:	29 c2                	sub    %eax,%edx
  800575:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800578:	eb aa                	jmp    800524 <vprintfmt+0x194>
					putch(ch, putdat);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	53                   	push   %ebx
  80057e:	52                   	push   %edx
  80057f:	ff d6                	call   *%esi
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800587:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800589:	83 c7 01             	add    $0x1,%edi
  80058c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800590:	0f be d0             	movsbl %al,%edx
  800593:	85 d2                	test   %edx,%edx
  800595:	74 4b                	je     8005e2 <vprintfmt+0x252>
  800597:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80059b:	78 06                	js     8005a3 <vprintfmt+0x213>
  80059d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005a1:	78 1e                	js     8005c1 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005a7:	74 d1                	je     80057a <vprintfmt+0x1ea>
  8005a9:	0f be c0             	movsbl %al,%eax
  8005ac:	83 e8 20             	sub    $0x20,%eax
  8005af:	83 f8 5e             	cmp    $0x5e,%eax
  8005b2:	76 c6                	jbe    80057a <vprintfmt+0x1ea>
					putch('?', putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	53                   	push   %ebx
  8005b8:	6a 3f                	push   $0x3f
  8005ba:	ff d6                	call   *%esi
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	eb c3                	jmp    800584 <vprintfmt+0x1f4>
  8005c1:	89 cf                	mov    %ecx,%edi
  8005c3:	eb 0e                	jmp    8005d3 <vprintfmt+0x243>
				putch(' ', putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	6a 20                	push   $0x20
  8005cb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005cd:	83 ef 01             	sub    $0x1,%edi
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	85 ff                	test   %edi,%edi
  8005d5:	7f ee                	jg     8005c5 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dd:	e9 76 01 00 00       	jmp    800758 <vprintfmt+0x3c8>
  8005e2:	89 cf                	mov    %ecx,%edi
  8005e4:	eb ed                	jmp    8005d3 <vprintfmt+0x243>
	if (lflag >= 2)
  8005e6:	83 f9 01             	cmp    $0x1,%ecx
  8005e9:	7f 1f                	jg     80060a <vprintfmt+0x27a>
	else if (lflag)
  8005eb:	85 c9                	test   %ecx,%ecx
  8005ed:	74 6a                	je     800659 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f7:	89 c1                	mov    %eax,%ecx
  8005f9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
  800608:	eb 17                	jmp    800621 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 50 04             	mov    0x4(%eax),%edx
  800610:	8b 00                	mov    (%eax),%eax
  800612:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800615:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 40 08             	lea    0x8(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800621:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800624:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800629:	85 d2                	test   %edx,%edx
  80062b:	0f 89 f8 00 00 00    	jns    800729 <vprintfmt+0x399>
				putch('-', putdat);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	53                   	push   %ebx
  800635:	6a 2d                	push   $0x2d
  800637:	ff d6                	call   *%esi
				num = -(long long) num;
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80063f:	f7 d8                	neg    %eax
  800641:	83 d2 00             	adc    $0x0,%edx
  800644:	f7 da                	neg    %edx
  800646:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800649:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80064f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800654:	e9 e1 00 00 00       	jmp    80073a <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	99                   	cltd   
  800662:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
  80066e:	eb b1                	jmp    800621 <vprintfmt+0x291>
	if (lflag >= 2)
  800670:	83 f9 01             	cmp    $0x1,%ecx
  800673:	7f 27                	jg     80069c <vprintfmt+0x30c>
	else if (lflag)
  800675:	85 c9                	test   %ecx,%ecx
  800677:	74 41                	je     8006ba <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	ba 00 00 00 00       	mov    $0x0,%edx
  800683:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800686:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800692:	bf 0a 00 00 00       	mov    $0xa,%edi
  800697:	e9 8d 00 00 00       	jmp    800729 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 50 04             	mov    0x4(%eax),%edx
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8d 40 08             	lea    0x8(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006b8:	eb 6f                	jmp    800729 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8d 40 04             	lea    0x4(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006d8:	eb 4f                	jmp    800729 <vprintfmt+0x399>
	if (lflag >= 2)
  8006da:	83 f9 01             	cmp    $0x1,%ecx
  8006dd:	7f 23                	jg     800702 <vprintfmt+0x372>
	else if (lflag)
  8006df:	85 c9                	test   %ecx,%ecx
  8006e1:	0f 84 98 00 00 00    	je     80077f <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8d 40 04             	lea    0x4(%eax),%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800700:	eb 17                	jmp    800719 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 50 04             	mov    0x4(%eax),%edx
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8d 40 08             	lea    0x8(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 30                	push   $0x30
  80071f:	ff d6                	call   *%esi
			goto number;
  800721:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800724:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800729:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80072d:	74 0b                	je     80073a <vprintfmt+0x3aa>
				putch('+', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	53                   	push   %ebx
  800733:	6a 2b                	push   $0x2b
  800735:	ff d6                	call   *%esi
  800737:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800741:	50                   	push   %eax
  800742:	ff 75 e0             	pushl  -0x20(%ebp)
  800745:	57                   	push   %edi
  800746:	ff 75 dc             	pushl  -0x24(%ebp)
  800749:	ff 75 d8             	pushl  -0x28(%ebp)
  80074c:	89 da                	mov    %ebx,%edx
  80074e:	89 f0                	mov    %esi,%eax
  800750:	e8 22 fb ff ff       	call   800277 <printnum>
			break;
  800755:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800758:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075b:	83 c7 01             	add    $0x1,%edi
  80075e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800762:	83 f8 25             	cmp    $0x25,%eax
  800765:	0f 84 3c fc ff ff    	je     8003a7 <vprintfmt+0x17>
			if (ch == '\0')
  80076b:	85 c0                	test   %eax,%eax
  80076d:	0f 84 55 01 00 00    	je     8008c8 <vprintfmt+0x538>
			putch(ch, putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	50                   	push   %eax
  800778:	ff d6                	call   *%esi
  80077a:	83 c4 10             	add    $0x10,%esp
  80077d:	eb dc                	jmp    80075b <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	ba 00 00 00 00       	mov    $0x0,%edx
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
  800798:	e9 7c ff ff ff       	jmp    800719 <vprintfmt+0x389>
			putch('0', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	53                   	push   %ebx
  8007a1:	6a 30                	push   $0x30
  8007a3:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a5:	83 c4 08             	add    $0x8,%esp
  8007a8:	53                   	push   %ebx
  8007a9:	6a 78                	push   $0x78
  8007ab:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007bd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 40 04             	lea    0x4(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c9:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8007ce:	e9 56 ff ff ff       	jmp    800729 <vprintfmt+0x399>
	if (lflag >= 2)
  8007d3:	83 f9 01             	cmp    $0x1,%ecx
  8007d6:	7f 27                	jg     8007ff <vprintfmt+0x46f>
	else if (lflag)
  8007d8:	85 c9                	test   %ecx,%ecx
  8007da:	74 44                	je     800820 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8d 40 04             	lea    0x4(%eax),%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f5:	bf 10 00 00 00       	mov    $0x10,%edi
  8007fa:	e9 2a ff ff ff       	jmp    800729 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 50 04             	mov    0x4(%eax),%edx
  800805:	8b 00                	mov    (%eax),%eax
  800807:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8d 40 08             	lea    0x8(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800816:	bf 10 00 00 00       	mov    $0x10,%edi
  80081b:	e9 09 ff ff ff       	jmp    800729 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	ba 00 00 00 00       	mov    $0x0,%edx
  80082a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8d 40 04             	lea    0x4(%eax),%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800839:	bf 10 00 00 00       	mov    $0x10,%edi
  80083e:	e9 e6 fe ff ff       	jmp    800729 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	8d 78 04             	lea    0x4(%eax),%edi
  800849:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  80084b:	85 c0                	test   %eax,%eax
  80084d:	74 2d                	je     80087c <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80084f:	0f b6 13             	movzbl (%ebx),%edx
  800852:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800854:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800857:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80085a:	0f 8e f8 fe ff ff    	jle    800758 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800860:	68 14 23 80 00       	push   $0x802314
  800865:	68 f5 25 80 00       	push   $0x8025f5
  80086a:	53                   	push   %ebx
  80086b:	56                   	push   %esi
  80086c:	e8 02 fb ff ff       	call   800373 <printfmt>
  800871:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800874:	89 7d 14             	mov    %edi,0x14(%ebp)
  800877:	e9 dc fe ff ff       	jmp    800758 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  80087c:	68 dc 22 80 00       	push   $0x8022dc
  800881:	68 f5 25 80 00       	push   $0x8025f5
  800886:	53                   	push   %ebx
  800887:	56                   	push   %esi
  800888:	e8 e6 fa ff ff       	call   800373 <printfmt>
  80088d:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800890:	89 7d 14             	mov    %edi,0x14(%ebp)
  800893:	e9 c0 fe ff ff       	jmp    800758 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	6a 25                	push   $0x25
  80089e:	ff d6                	call   *%esi
			break;
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	e9 b0 fe ff ff       	jmp    800758 <vprintfmt+0x3c8>
			putch('%', putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	53                   	push   %ebx
  8008ac:	6a 25                	push   $0x25
  8008ae:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 f8                	mov    %edi,%eax
  8008b5:	eb 03                	jmp    8008ba <vprintfmt+0x52a>
  8008b7:	83 e8 01             	sub    $0x1,%eax
  8008ba:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008be:	75 f7                	jne    8008b7 <vprintfmt+0x527>
  8008c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c3:	e9 90 fe ff ff       	jmp    800758 <vprintfmt+0x3c8>
}
  8008c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008cb:	5b                   	pop    %ebx
  8008cc:	5e                   	pop    %esi
  8008cd:	5f                   	pop    %edi
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 18             	sub    $0x18,%esp
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	74 26                	je     800917 <vsnprintf+0x47>
  8008f1:	85 d2                	test   %edx,%edx
  8008f3:	7e 22                	jle    800917 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f5:	ff 75 14             	pushl  0x14(%ebp)
  8008f8:	ff 75 10             	pushl  0x10(%ebp)
  8008fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008fe:	50                   	push   %eax
  8008ff:	68 56 03 80 00       	push   $0x800356
  800904:	e8 87 fa ff ff       	call   800390 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80090f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800912:	83 c4 10             	add    $0x10,%esp
}
  800915:	c9                   	leave  
  800916:	c3                   	ret    
		return -E_INVAL;
  800917:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80091c:	eb f7                	jmp    800915 <vsnprintf+0x45>

0080091e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800924:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800927:	50                   	push   %eax
  800928:	ff 75 10             	pushl  0x10(%ebp)
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	ff 75 08             	pushl  0x8(%ebp)
  800931:	e8 9a ff ff ff       	call   8008d0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800936:	c9                   	leave  
  800937:	c3                   	ret    

00800938 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80093e:	b8 00 00 00 00       	mov    $0x0,%eax
  800943:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800947:	74 05                	je     80094e <strlen+0x16>
		n++;
  800949:	83 c0 01             	add    $0x1,%eax
  80094c:	eb f5                	jmp    800943 <strlen+0xb>
	return n;
}
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 0d                	je     80096f <strnlen+0x1f>
  800962:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800966:	74 05                	je     80096d <strnlen+0x1d>
		n++;
  800968:	83 c2 01             	add    $0x1,%edx
  80096b:	eb f1                	jmp    80095e <strnlen+0xe>
  80096d:	89 d0                	mov    %edx,%eax
	return n;
}
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	53                   	push   %ebx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80097b:	ba 00 00 00 00       	mov    $0x0,%edx
  800980:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800984:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800987:	83 c2 01             	add    $0x1,%edx
  80098a:	84 c9                	test   %cl,%cl
  80098c:	75 f2                	jne    800980 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80098e:	5b                   	pop    %ebx
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	53                   	push   %ebx
  800995:	83 ec 10             	sub    $0x10,%esp
  800998:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80099b:	53                   	push   %ebx
  80099c:	e8 97 ff ff ff       	call   800938 <strlen>
  8009a1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	01 d8                	add    %ebx,%eax
  8009a9:	50                   	push   %eax
  8009aa:	e8 c2 ff ff ff       	call   800971 <strcpy>
	return dst;
}
  8009af:	89 d8                	mov    %ebx,%eax
  8009b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009b4:	c9                   	leave  
  8009b5:	c3                   	ret    

008009b6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	56                   	push   %esi
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c1:	89 c6                	mov    %eax,%esi
  8009c3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c6:	89 c2                	mov    %eax,%edx
  8009c8:	39 f2                	cmp    %esi,%edx
  8009ca:	74 11                	je     8009dd <strncpy+0x27>
		*dst++ = *src;
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	0f b6 19             	movzbl (%ecx),%ebx
  8009d2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009d5:	80 fb 01             	cmp    $0x1,%bl
  8009d8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009db:	eb eb                	jmp    8009c8 <strncpy+0x12>
	}
	return ret;
}
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	56                   	push   %esi
  8009e5:	53                   	push   %ebx
  8009e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ec:	8b 55 10             	mov    0x10(%ebp),%edx
  8009ef:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f1:	85 d2                	test   %edx,%edx
  8009f3:	74 21                	je     800a16 <strlcpy+0x35>
  8009f5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009f9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009fb:	39 c2                	cmp    %eax,%edx
  8009fd:	74 14                	je     800a13 <strlcpy+0x32>
  8009ff:	0f b6 19             	movzbl (%ecx),%ebx
  800a02:	84 db                	test   %bl,%bl
  800a04:	74 0b                	je     800a11 <strlcpy+0x30>
			*dst++ = *src++;
  800a06:	83 c1 01             	add    $0x1,%ecx
  800a09:	83 c2 01             	add    $0x1,%edx
  800a0c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a0f:	eb ea                	jmp    8009fb <strlcpy+0x1a>
  800a11:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a13:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a16:	29 f0                	sub    %esi,%eax
}
  800a18:	5b                   	pop    %ebx
  800a19:	5e                   	pop    %esi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a25:	0f b6 01             	movzbl (%ecx),%eax
  800a28:	84 c0                	test   %al,%al
  800a2a:	74 0c                	je     800a38 <strcmp+0x1c>
  800a2c:	3a 02                	cmp    (%edx),%al
  800a2e:	75 08                	jne    800a38 <strcmp+0x1c>
		p++, q++;
  800a30:	83 c1 01             	add    $0x1,%ecx
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	eb ed                	jmp    800a25 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a38:	0f b6 c0             	movzbl %al,%eax
  800a3b:	0f b6 12             	movzbl (%edx),%edx
  800a3e:	29 d0                	sub    %edx,%eax
}
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	53                   	push   %ebx
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4c:	89 c3                	mov    %eax,%ebx
  800a4e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a51:	eb 06                	jmp    800a59 <strncmp+0x17>
		n--, p++, q++;
  800a53:	83 c0 01             	add    $0x1,%eax
  800a56:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a59:	39 d8                	cmp    %ebx,%eax
  800a5b:	74 16                	je     800a73 <strncmp+0x31>
  800a5d:	0f b6 08             	movzbl (%eax),%ecx
  800a60:	84 c9                	test   %cl,%cl
  800a62:	74 04                	je     800a68 <strncmp+0x26>
  800a64:	3a 0a                	cmp    (%edx),%cl
  800a66:	74 eb                	je     800a53 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a68:	0f b6 00             	movzbl (%eax),%eax
  800a6b:	0f b6 12             	movzbl (%edx),%edx
  800a6e:	29 d0                	sub    %edx,%eax
}
  800a70:	5b                   	pop    %ebx
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    
		return 0;
  800a73:	b8 00 00 00 00       	mov    $0x0,%eax
  800a78:	eb f6                	jmp    800a70 <strncmp+0x2e>

00800a7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a84:	0f b6 10             	movzbl (%eax),%edx
  800a87:	84 d2                	test   %dl,%dl
  800a89:	74 09                	je     800a94 <strchr+0x1a>
		if (*s == c)
  800a8b:	38 ca                	cmp    %cl,%dl
  800a8d:	74 0a                	je     800a99 <strchr+0x1f>
	for (; *s; s++)
  800a8f:	83 c0 01             	add    $0x1,%eax
  800a92:	eb f0                	jmp    800a84 <strchr+0xa>
			return (char *) s;
	return 0;
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aa8:	38 ca                	cmp    %cl,%dl
  800aaa:	74 09                	je     800ab5 <strfind+0x1a>
  800aac:	84 d2                	test   %dl,%dl
  800aae:	74 05                	je     800ab5 <strfind+0x1a>
	for (; *s; s++)
  800ab0:	83 c0 01             	add    $0x1,%eax
  800ab3:	eb f0                	jmp    800aa5 <strfind+0xa>
			break;
	return (char *) s;
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	57                   	push   %edi
  800abb:	56                   	push   %esi
  800abc:	53                   	push   %ebx
  800abd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac3:	85 c9                	test   %ecx,%ecx
  800ac5:	74 31                	je     800af8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac7:	89 f8                	mov    %edi,%eax
  800ac9:	09 c8                	or     %ecx,%eax
  800acb:	a8 03                	test   $0x3,%al
  800acd:	75 23                	jne    800af2 <memset+0x3b>
		c &= 0xFF;
  800acf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad3:	89 d3                	mov    %edx,%ebx
  800ad5:	c1 e3 08             	shl    $0x8,%ebx
  800ad8:	89 d0                	mov    %edx,%eax
  800ada:	c1 e0 18             	shl    $0x18,%eax
  800add:	89 d6                	mov    %edx,%esi
  800adf:	c1 e6 10             	shl    $0x10,%esi
  800ae2:	09 f0                	or     %esi,%eax
  800ae4:	09 c2                	or     %eax,%edx
  800ae6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ae8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aeb:	89 d0                	mov    %edx,%eax
  800aed:	fc                   	cld    
  800aee:	f3 ab                	rep stos %eax,%es:(%edi)
  800af0:	eb 06                	jmp    800af8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	fc                   	cld    
  800af6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800af8:	89 f8                	mov    %edi,%eax
  800afa:	5b                   	pop    %ebx
  800afb:	5e                   	pop    %esi
  800afc:	5f                   	pop    %edi
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	57                   	push   %edi
  800b03:	56                   	push   %esi
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b0d:	39 c6                	cmp    %eax,%esi
  800b0f:	73 32                	jae    800b43 <memmove+0x44>
  800b11:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b14:	39 c2                	cmp    %eax,%edx
  800b16:	76 2b                	jbe    800b43 <memmove+0x44>
		s += n;
		d += n;
  800b18:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1b:	89 fe                	mov    %edi,%esi
  800b1d:	09 ce                	or     %ecx,%esi
  800b1f:	09 d6                	or     %edx,%esi
  800b21:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b27:	75 0e                	jne    800b37 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b29:	83 ef 04             	sub    $0x4,%edi
  800b2c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b2f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b32:	fd                   	std    
  800b33:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b35:	eb 09                	jmp    800b40 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b37:	83 ef 01             	sub    $0x1,%edi
  800b3a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b3d:	fd                   	std    
  800b3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b40:	fc                   	cld    
  800b41:	eb 1a                	jmp    800b5d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b43:	89 c2                	mov    %eax,%edx
  800b45:	09 ca                	or     %ecx,%edx
  800b47:	09 f2                	or     %esi,%edx
  800b49:	f6 c2 03             	test   $0x3,%dl
  800b4c:	75 0a                	jne    800b58 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b4e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b51:	89 c7                	mov    %eax,%edi
  800b53:	fc                   	cld    
  800b54:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b56:	eb 05                	jmp    800b5d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b58:	89 c7                	mov    %eax,%edi
  800b5a:	fc                   	cld    
  800b5b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b5d:	5e                   	pop    %esi
  800b5e:	5f                   	pop    %edi
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b67:	ff 75 10             	pushl  0x10(%ebp)
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	ff 75 08             	pushl  0x8(%ebp)
  800b70:	e8 8a ff ff ff       	call   800aff <memmove>
}
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b82:	89 c6                	mov    %eax,%esi
  800b84:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b87:	39 f0                	cmp    %esi,%eax
  800b89:	74 1c                	je     800ba7 <memcmp+0x30>
		if (*s1 != *s2)
  800b8b:	0f b6 08             	movzbl (%eax),%ecx
  800b8e:	0f b6 1a             	movzbl (%edx),%ebx
  800b91:	38 d9                	cmp    %bl,%cl
  800b93:	75 08                	jne    800b9d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b95:	83 c0 01             	add    $0x1,%eax
  800b98:	83 c2 01             	add    $0x1,%edx
  800b9b:	eb ea                	jmp    800b87 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b9d:	0f b6 c1             	movzbl %cl,%eax
  800ba0:	0f b6 db             	movzbl %bl,%ebx
  800ba3:	29 d8                	sub    %ebx,%eax
  800ba5:	eb 05                	jmp    800bac <memcmp+0x35>
	}

	return 0;
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bbe:	39 d0                	cmp    %edx,%eax
  800bc0:	73 09                	jae    800bcb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc2:	38 08                	cmp    %cl,(%eax)
  800bc4:	74 05                	je     800bcb <memfind+0x1b>
	for (; s < ends; s++)
  800bc6:	83 c0 01             	add    $0x1,%eax
  800bc9:	eb f3                	jmp    800bbe <memfind+0xe>
			break;
	return (void *) s;
}
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
  800bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd9:	eb 03                	jmp    800bde <strtol+0x11>
		s++;
  800bdb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bde:	0f b6 01             	movzbl (%ecx),%eax
  800be1:	3c 20                	cmp    $0x20,%al
  800be3:	74 f6                	je     800bdb <strtol+0xe>
  800be5:	3c 09                	cmp    $0x9,%al
  800be7:	74 f2                	je     800bdb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800be9:	3c 2b                	cmp    $0x2b,%al
  800beb:	74 2a                	je     800c17 <strtol+0x4a>
	int neg = 0;
  800bed:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf2:	3c 2d                	cmp    $0x2d,%al
  800bf4:	74 2b                	je     800c21 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bfc:	75 0f                	jne    800c0d <strtol+0x40>
  800bfe:	80 39 30             	cmpb   $0x30,(%ecx)
  800c01:	74 28                	je     800c2b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c03:	85 db                	test   %ebx,%ebx
  800c05:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c0a:	0f 44 d8             	cmove  %eax,%ebx
  800c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c12:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c15:	eb 50                	jmp    800c67 <strtol+0x9a>
		s++;
  800c17:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c1a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1f:	eb d5                	jmp    800bf6 <strtol+0x29>
		s++, neg = 1;
  800c21:	83 c1 01             	add    $0x1,%ecx
  800c24:	bf 01 00 00 00       	mov    $0x1,%edi
  800c29:	eb cb                	jmp    800bf6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c2f:	74 0e                	je     800c3f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c31:	85 db                	test   %ebx,%ebx
  800c33:	75 d8                	jne    800c0d <strtol+0x40>
		s++, base = 8;
  800c35:	83 c1 01             	add    $0x1,%ecx
  800c38:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c3d:	eb ce                	jmp    800c0d <strtol+0x40>
		s += 2, base = 16;
  800c3f:	83 c1 02             	add    $0x2,%ecx
  800c42:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c47:	eb c4                	jmp    800c0d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c49:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c4c:	89 f3                	mov    %esi,%ebx
  800c4e:	80 fb 19             	cmp    $0x19,%bl
  800c51:	77 29                	ja     800c7c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c53:	0f be d2             	movsbl %dl,%edx
  800c56:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c59:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c5c:	7d 30                	jge    800c8e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c5e:	83 c1 01             	add    $0x1,%ecx
  800c61:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c65:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c67:	0f b6 11             	movzbl (%ecx),%edx
  800c6a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c6d:	89 f3                	mov    %esi,%ebx
  800c6f:	80 fb 09             	cmp    $0x9,%bl
  800c72:	77 d5                	ja     800c49 <strtol+0x7c>
			dig = *s - '0';
  800c74:	0f be d2             	movsbl %dl,%edx
  800c77:	83 ea 30             	sub    $0x30,%edx
  800c7a:	eb dd                	jmp    800c59 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c7c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c7f:	89 f3                	mov    %esi,%ebx
  800c81:	80 fb 19             	cmp    $0x19,%bl
  800c84:	77 08                	ja     800c8e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c86:	0f be d2             	movsbl %dl,%edx
  800c89:	83 ea 37             	sub    $0x37,%edx
  800c8c:	eb cb                	jmp    800c59 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c92:	74 05                	je     800c99 <strtol+0xcc>
		*endptr = (char *) s;
  800c94:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c97:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c99:	89 c2                	mov    %eax,%edx
  800c9b:	f7 da                	neg    %edx
  800c9d:	85 ff                	test   %edi,%edi
  800c9f:	0f 45 c2             	cmovne %edx,%eax
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5f                   	pop    %edi
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	57                   	push   %edi
  800cab:	56                   	push   %esi
  800cac:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cad:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb8:	89 c3                	mov    %eax,%ebx
  800cba:	89 c7                	mov    %eax,%edi
  800cbc:	89 c6                	mov    %eax,%esi
  800cbe:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfa:	89 cb                	mov    %ecx,%ebx
  800cfc:	89 cf                	mov    %ecx,%edi
  800cfe:	89 ce                	mov    %ecx,%esi
  800d00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d02:	85 c0                	test   %eax,%eax
  800d04:	7f 08                	jg     800d0e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0e:	83 ec 0c             	sub    $0xc,%esp
  800d11:	50                   	push   %eax
  800d12:	6a 03                	push   $0x3
  800d14:	68 20 25 80 00       	push   $0x802520
  800d19:	6a 33                	push   $0x33
  800d1b:	68 3d 25 80 00       	push   $0x80253d
  800d20:	e8 63 f4 ff ff       	call   800188 <_panic>

00800d25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	b8 02 00 00 00       	mov    $0x2,%eax
  800d35:	89 d1                	mov    %edx,%ecx
  800d37:	89 d3                	mov    %edx,%ebx
  800d39:	89 d7                	mov    %edx,%edi
  800d3b:	89 d6                	mov    %edx,%esi
  800d3d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_yield>:

void
sys_yield(void)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d54:	89 d1                	mov    %edx,%ecx
  800d56:	89 d3                	mov    %edx,%ebx
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	89 d6                	mov    %edx,%esi
  800d5c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6c:	be 00 00 00 00       	mov    $0x0,%esi
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d77:	b8 04 00 00 00       	mov    $0x4,%eax
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7f:	89 f7                	mov    %esi,%edi
  800d81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7f 08                	jg     800d8f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	50                   	push   %eax
  800d93:	6a 04                	push   $0x4
  800d95:	68 20 25 80 00       	push   $0x802520
  800d9a:	6a 33                	push   $0x33
  800d9c:	68 3d 25 80 00       	push   $0x80253d
  800da1:	e8 e2 f3 ff ff       	call   800188 <_panic>

00800da6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
  800dac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db5:	b8 05 00 00 00       	mov    $0x5,%eax
  800dba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc0:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc5:	85 c0                	test   %eax,%eax
  800dc7:	7f 08                	jg     800dd1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcc:	5b                   	pop    %ebx
  800dcd:	5e                   	pop    %esi
  800dce:	5f                   	pop    %edi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd1:	83 ec 0c             	sub    $0xc,%esp
  800dd4:	50                   	push   %eax
  800dd5:	6a 05                	push   $0x5
  800dd7:	68 20 25 80 00       	push   $0x802520
  800ddc:	6a 33                	push   $0x33
  800dde:	68 3d 25 80 00       	push   $0x80253d
  800de3:	e8 a0 f3 ff ff       	call   800188 <_panic>

00800de8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	b8 06 00 00 00       	mov    $0x6,%eax
  800e01:	89 df                	mov    %ebx,%edi
  800e03:	89 de                	mov    %ebx,%esi
  800e05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7f 08                	jg     800e13 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	50                   	push   %eax
  800e17:	6a 06                	push   $0x6
  800e19:	68 20 25 80 00       	push   $0x802520
  800e1e:	6a 33                	push   $0x33
  800e20:	68 3d 25 80 00       	push   $0x80253d
  800e25:	e8 5e f3 ff ff       	call   800188 <_panic>

00800e2a <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e38:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e40:	89 cb                	mov    %ecx,%ebx
  800e42:	89 cf                	mov    %ecx,%edi
  800e44:	89 ce                	mov    %ecx,%esi
  800e46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	7f 08                	jg     800e54 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	50                   	push   %eax
  800e58:	6a 0b                	push   $0xb
  800e5a:	68 20 25 80 00       	push   $0x802520
  800e5f:	6a 33                	push   $0x33
  800e61:	68 3d 25 80 00       	push   $0x80253d
  800e66:	e8 1d f3 ff ff       	call   800188 <_panic>

00800e6b <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e84:	89 df                	mov    %ebx,%edi
  800e86:	89 de                	mov    %ebx,%esi
  800e88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7f 08                	jg     800e96 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	50                   	push   %eax
  800e9a:	6a 08                	push   $0x8
  800e9c:	68 20 25 80 00       	push   $0x802520
  800ea1:	6a 33                	push   $0x33
  800ea3:	68 3d 25 80 00       	push   $0x80253d
  800ea8:	e8 db f2 ff ff       	call   800188 <_panic>

00800ead <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec6:	89 df                	mov    %ebx,%edi
  800ec8:	89 de                	mov    %ebx,%esi
  800eca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7f 08                	jg     800ed8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	50                   	push   %eax
  800edc:	6a 09                	push   $0x9
  800ede:	68 20 25 80 00       	push   $0x802520
  800ee3:	6a 33                	push   $0x33
  800ee5:	68 3d 25 80 00       	push   $0x80253d
  800eea:	e8 99 f2 ff ff       	call   800188 <_panic>

00800eef <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f08:	89 df                	mov    %ebx,%edi
  800f0a:	89 de                	mov    %ebx,%esi
  800f0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	7f 08                	jg     800f1a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1a:	83 ec 0c             	sub    $0xc,%esp
  800f1d:	50                   	push   %eax
  800f1e:	6a 0a                	push   $0xa
  800f20:	68 20 25 80 00       	push   $0x802520
  800f25:	6a 33                	push   $0x33
  800f27:	68 3d 25 80 00       	push   $0x80253d
  800f2c:	e8 57 f2 ff ff       	call   800188 <_panic>

00800f31 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	57                   	push   %edi
  800f35:	56                   	push   %esi
  800f36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f37:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f42:	be 00 00 00 00       	mov    $0x0,%esi
  800f47:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f4d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f4f:	5b                   	pop    %ebx
  800f50:	5e                   	pop    %esi
  800f51:	5f                   	pop    %edi
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	57                   	push   %edi
  800f58:	56                   	push   %esi
  800f59:	53                   	push   %ebx
  800f5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f6a:	89 cb                	mov    %ecx,%ebx
  800f6c:	89 cf                	mov    %ecx,%edi
  800f6e:	89 ce                	mov    %ecx,%esi
  800f70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f72:	85 c0                	test   %eax,%eax
  800f74:	7f 08                	jg     800f7e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	50                   	push   %eax
  800f82:	6a 0e                	push   $0xe
  800f84:	68 20 25 80 00       	push   $0x802520
  800f89:	6a 33                	push   $0x33
  800f8b:	68 3d 25 80 00       	push   $0x80253d
  800f90:	e8 f3 f1 ff ff       	call   800188 <_panic>

00800f95 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa6:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fab:	89 df                	mov    %ebx,%edi
  800fad:	89 de                	mov    %ebx,%esi
  800faf:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc4:	b8 10 00 00 00       	mov    $0x10,%eax
  800fc9:	89 cb                	mov    %ecx,%ebx
  800fcb:	89 cf                	mov    %ecx,%edi
  800fcd:	89 ce                	mov    %ecx,%esi
  800fcf:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	05 00 00 00 30       	add    $0x30000000,%eax
  800fe1:	c1 e8 0c             	shr    $0xc,%eax
}
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ff1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ff6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801005:	89 c2                	mov    %eax,%edx
  801007:	c1 ea 16             	shr    $0x16,%edx
  80100a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801011:	f6 c2 01             	test   $0x1,%dl
  801014:	74 2d                	je     801043 <fd_alloc+0x46>
  801016:	89 c2                	mov    %eax,%edx
  801018:	c1 ea 0c             	shr    $0xc,%edx
  80101b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801022:	f6 c2 01             	test   $0x1,%dl
  801025:	74 1c                	je     801043 <fd_alloc+0x46>
  801027:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80102c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801031:	75 d2                	jne    801005 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80103c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801041:	eb 0a                	jmp    80104d <fd_alloc+0x50>
			*fd_store = fd;
  801043:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801046:	89 01                	mov    %eax,(%ecx)
			return 0;
  801048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801055:	83 f8 1f             	cmp    $0x1f,%eax
  801058:	77 30                	ja     80108a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80105a:	c1 e0 0c             	shl    $0xc,%eax
  80105d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801062:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801068:	f6 c2 01             	test   $0x1,%dl
  80106b:	74 24                	je     801091 <fd_lookup+0x42>
  80106d:	89 c2                	mov    %eax,%edx
  80106f:	c1 ea 0c             	shr    $0xc,%edx
  801072:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801079:	f6 c2 01             	test   $0x1,%dl
  80107c:	74 1a                	je     801098 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80107e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801081:	89 02                	mov    %eax,(%edx)
	return 0;
  801083:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    
		return -E_INVAL;
  80108a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108f:	eb f7                	jmp    801088 <fd_lookup+0x39>
		return -E_INVAL;
  801091:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801096:	eb f0                	jmp    801088 <fd_lookup+0x39>
  801098:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109d:	eb e9                	jmp    801088 <fd_lookup+0x39>

0080109f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 08             	sub    $0x8,%esp
  8010a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a8:	ba cc 25 80 00       	mov    $0x8025cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8010ad:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010b2:	39 08                	cmp    %ecx,(%eax)
  8010b4:	74 33                	je     8010e9 <dev_lookup+0x4a>
  8010b6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010b9:	8b 02                	mov    (%edx),%eax
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	75 f3                	jne    8010b2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010bf:	a1 20 60 80 00       	mov    0x806020,%eax
  8010c4:	8b 40 48             	mov    0x48(%eax),%eax
  8010c7:	83 ec 04             	sub    $0x4,%esp
  8010ca:	51                   	push   %ecx
  8010cb:	50                   	push   %eax
  8010cc:	68 4c 25 80 00       	push   $0x80254c
  8010d1:	e8 8d f1 ff ff       	call   800263 <cprintf>
	*dev = 0;
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010e7:	c9                   	leave  
  8010e8:	c3                   	ret    
			*dev = devtab[i];
  8010e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ec:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f3:	eb f2                	jmp    8010e7 <dev_lookup+0x48>

008010f5 <fd_close>:
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
  8010fb:	83 ec 24             	sub    $0x24,%esp
  8010fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801101:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801104:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801107:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801108:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80110e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801111:	50                   	push   %eax
  801112:	e8 38 ff ff ff       	call   80104f <fd_lookup>
  801117:	89 c3                	mov    %eax,%ebx
  801119:	83 c4 10             	add    $0x10,%esp
  80111c:	85 c0                	test   %eax,%eax
  80111e:	78 05                	js     801125 <fd_close+0x30>
	    || fd != fd2)
  801120:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801123:	74 16                	je     80113b <fd_close+0x46>
		return (must_exist ? r : 0);
  801125:	89 f8                	mov    %edi,%eax
  801127:	84 c0                	test   %al,%al
  801129:	b8 00 00 00 00       	mov    $0x0,%eax
  80112e:	0f 44 d8             	cmove  %eax,%ebx
}
  801131:	89 d8                	mov    %ebx,%eax
  801133:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801136:	5b                   	pop    %ebx
  801137:	5e                   	pop    %esi
  801138:	5f                   	pop    %edi
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	ff 36                	pushl  (%esi)
  801144:	e8 56 ff ff ff       	call   80109f <dev_lookup>
  801149:	89 c3                	mov    %eax,%ebx
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	85 c0                	test   %eax,%eax
  801150:	78 1a                	js     80116c <fd_close+0x77>
		if (dev->dev_close)
  801152:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801155:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801158:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80115d:	85 c0                	test   %eax,%eax
  80115f:	74 0b                	je     80116c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	56                   	push   %esi
  801165:	ff d0                	call   *%eax
  801167:	89 c3                	mov    %eax,%ebx
  801169:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80116c:	83 ec 08             	sub    $0x8,%esp
  80116f:	56                   	push   %esi
  801170:	6a 00                	push   $0x0
  801172:	e8 71 fc ff ff       	call   800de8 <sys_page_unmap>
	return r;
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	eb b5                	jmp    801131 <fd_close+0x3c>

0080117c <close>:

int
close(int fdnum)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801185:	50                   	push   %eax
  801186:	ff 75 08             	pushl  0x8(%ebp)
  801189:	e8 c1 fe ff ff       	call   80104f <fd_lookup>
  80118e:	83 c4 10             	add    $0x10,%esp
  801191:	85 c0                	test   %eax,%eax
  801193:	79 02                	jns    801197 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801195:	c9                   	leave  
  801196:	c3                   	ret    
		return fd_close(fd, 1);
  801197:	83 ec 08             	sub    $0x8,%esp
  80119a:	6a 01                	push   $0x1
  80119c:	ff 75 f4             	pushl  -0xc(%ebp)
  80119f:	e8 51 ff ff ff       	call   8010f5 <fd_close>
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	eb ec                	jmp    801195 <close+0x19>

008011a9 <close_all>:

void
close_all(void)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	53                   	push   %ebx
  8011ad:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011b0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	53                   	push   %ebx
  8011b9:	e8 be ff ff ff       	call   80117c <close>
	for (i = 0; i < MAXFD; i++)
  8011be:	83 c3 01             	add    $0x1,%ebx
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	83 fb 20             	cmp    $0x20,%ebx
  8011c7:	75 ec                	jne    8011b5 <close_all+0xc>
}
  8011c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	57                   	push   %edi
  8011d2:	56                   	push   %esi
  8011d3:	53                   	push   %ebx
  8011d4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	ff 75 08             	pushl  0x8(%ebp)
  8011de:	e8 6c fe ff ff       	call   80104f <fd_lookup>
  8011e3:	89 c3                	mov    %eax,%ebx
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	0f 88 81 00 00 00    	js     801271 <dup+0xa3>
		return r;
	close(newfdnum);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	ff 75 0c             	pushl  0xc(%ebp)
  8011f6:	e8 81 ff ff ff       	call   80117c <close>

	newfd = INDEX2FD(newfdnum);
  8011fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011fe:	c1 e6 0c             	shl    $0xc,%esi
  801201:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801207:	83 c4 04             	add    $0x4,%esp
  80120a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80120d:	e8 d4 fd ff ff       	call   800fe6 <fd2data>
  801212:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801214:	89 34 24             	mov    %esi,(%esp)
  801217:	e8 ca fd ff ff       	call   800fe6 <fd2data>
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801221:	89 d8                	mov    %ebx,%eax
  801223:	c1 e8 16             	shr    $0x16,%eax
  801226:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80122d:	a8 01                	test   $0x1,%al
  80122f:	74 11                	je     801242 <dup+0x74>
  801231:	89 d8                	mov    %ebx,%eax
  801233:	c1 e8 0c             	shr    $0xc,%eax
  801236:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80123d:	f6 c2 01             	test   $0x1,%dl
  801240:	75 39                	jne    80127b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801245:	89 d0                	mov    %edx,%eax
  801247:	c1 e8 0c             	shr    $0xc,%eax
  80124a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	25 07 0e 00 00       	and    $0xe07,%eax
  801259:	50                   	push   %eax
  80125a:	56                   	push   %esi
  80125b:	6a 00                	push   $0x0
  80125d:	52                   	push   %edx
  80125e:	6a 00                	push   $0x0
  801260:	e8 41 fb ff ff       	call   800da6 <sys_page_map>
  801265:	89 c3                	mov    %eax,%ebx
  801267:	83 c4 20             	add    $0x20,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	78 31                	js     80129f <dup+0xd1>
		goto err;

	return newfdnum;
  80126e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801271:	89 d8                	mov    %ebx,%eax
  801273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80127b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801282:	83 ec 0c             	sub    $0xc,%esp
  801285:	25 07 0e 00 00       	and    $0xe07,%eax
  80128a:	50                   	push   %eax
  80128b:	57                   	push   %edi
  80128c:	6a 00                	push   $0x0
  80128e:	53                   	push   %ebx
  80128f:	6a 00                	push   $0x0
  801291:	e8 10 fb ff ff       	call   800da6 <sys_page_map>
  801296:	89 c3                	mov    %eax,%ebx
  801298:	83 c4 20             	add    $0x20,%esp
  80129b:	85 c0                	test   %eax,%eax
  80129d:	79 a3                	jns    801242 <dup+0x74>
	sys_page_unmap(0, newfd);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	56                   	push   %esi
  8012a3:	6a 00                	push   $0x0
  8012a5:	e8 3e fb ff ff       	call   800de8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012aa:	83 c4 08             	add    $0x8,%esp
  8012ad:	57                   	push   %edi
  8012ae:	6a 00                	push   $0x0
  8012b0:	e8 33 fb ff ff       	call   800de8 <sys_page_unmap>
	return r;
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	eb b7                	jmp    801271 <dup+0xa3>

008012ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 1c             	sub    $0x1c,%esp
  8012c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c7:	50                   	push   %eax
  8012c8:	53                   	push   %ebx
  8012c9:	e8 81 fd ff ff       	call   80104f <fd_lookup>
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	78 3f                	js     801314 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012db:	50                   	push   %eax
  8012dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012df:	ff 30                	pushl  (%eax)
  8012e1:	e8 b9 fd ff ff       	call   80109f <dev_lookup>
  8012e6:	83 c4 10             	add    $0x10,%esp
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	78 27                	js     801314 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f0:	8b 42 08             	mov    0x8(%edx),%eax
  8012f3:	83 e0 03             	and    $0x3,%eax
  8012f6:	83 f8 01             	cmp    $0x1,%eax
  8012f9:	74 1e                	je     801319 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fe:	8b 40 08             	mov    0x8(%eax),%eax
  801301:	85 c0                	test   %eax,%eax
  801303:	74 35                	je     80133a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801305:	83 ec 04             	sub    $0x4,%esp
  801308:	ff 75 10             	pushl  0x10(%ebp)
  80130b:	ff 75 0c             	pushl  0xc(%ebp)
  80130e:	52                   	push   %edx
  80130f:	ff d0                	call   *%eax
  801311:	83 c4 10             	add    $0x10,%esp
}
  801314:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801317:	c9                   	leave  
  801318:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801319:	a1 20 60 80 00       	mov    0x806020,%eax
  80131e:	8b 40 48             	mov    0x48(%eax),%eax
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	53                   	push   %ebx
  801325:	50                   	push   %eax
  801326:	68 90 25 80 00       	push   $0x802590
  80132b:	e8 33 ef ff ff       	call   800263 <cprintf>
		return -E_INVAL;
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801338:	eb da                	jmp    801314 <read+0x5a>
		return -E_NOT_SUPP;
  80133a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133f:	eb d3                	jmp    801314 <read+0x5a>

00801341 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	57                   	push   %edi
  801345:	56                   	push   %esi
  801346:	53                   	push   %ebx
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80134d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801350:	bb 00 00 00 00       	mov    $0x0,%ebx
  801355:	39 f3                	cmp    %esi,%ebx
  801357:	73 23                	jae    80137c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	89 f0                	mov    %esi,%eax
  80135e:	29 d8                	sub    %ebx,%eax
  801360:	50                   	push   %eax
  801361:	89 d8                	mov    %ebx,%eax
  801363:	03 45 0c             	add    0xc(%ebp),%eax
  801366:	50                   	push   %eax
  801367:	57                   	push   %edi
  801368:	e8 4d ff ff ff       	call   8012ba <read>
		if (m < 0)
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	85 c0                	test   %eax,%eax
  801372:	78 06                	js     80137a <readn+0x39>
			return m;
		if (m == 0)
  801374:	74 06                	je     80137c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801376:	01 c3                	add    %eax,%ebx
  801378:	eb db                	jmp    801355 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80137a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80137c:	89 d8                	mov    %ebx,%eax
  80137e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801381:	5b                   	pop    %ebx
  801382:	5e                   	pop    %esi
  801383:	5f                   	pop    %edi
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	53                   	push   %ebx
  80138a:	83 ec 1c             	sub    $0x1c,%esp
  80138d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801390:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801393:	50                   	push   %eax
  801394:	53                   	push   %ebx
  801395:	e8 b5 fc ff ff       	call   80104f <fd_lookup>
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 3a                	js     8013db <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a1:	83 ec 08             	sub    $0x8,%esp
  8013a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a7:	50                   	push   %eax
  8013a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ab:	ff 30                	pushl  (%eax)
  8013ad:	e8 ed fc ff ff       	call   80109f <dev_lookup>
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 22                	js     8013db <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013c0:	74 1e                	je     8013e0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c5:	8b 52 0c             	mov    0xc(%edx),%edx
  8013c8:	85 d2                	test   %edx,%edx
  8013ca:	74 35                	je     801401 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	ff 75 10             	pushl  0x10(%ebp)
  8013d2:	ff 75 0c             	pushl  0xc(%ebp)
  8013d5:	50                   	push   %eax
  8013d6:	ff d2                	call   *%edx
  8013d8:	83 c4 10             	add    $0x10,%esp
}
  8013db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e0:	a1 20 60 80 00       	mov    0x806020,%eax
  8013e5:	8b 40 48             	mov    0x48(%eax),%eax
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	53                   	push   %ebx
  8013ec:	50                   	push   %eax
  8013ed:	68 ac 25 80 00       	push   $0x8025ac
  8013f2:	e8 6c ee ff ff       	call   800263 <cprintf>
		return -E_INVAL;
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ff:	eb da                	jmp    8013db <write+0x55>
		return -E_NOT_SUPP;
  801401:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801406:	eb d3                	jmp    8013db <write+0x55>

00801408 <seek>:

int
seek(int fdnum, off_t offset)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80140e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801411:	50                   	push   %eax
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 35 fc ff ff       	call   80104f <fd_lookup>
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 0e                	js     80142f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801421:	8b 55 0c             	mov    0xc(%ebp),%edx
  801424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801427:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80142a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	53                   	push   %ebx
  801435:	83 ec 1c             	sub    $0x1c,%esp
  801438:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80143b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80143e:	50                   	push   %eax
  80143f:	53                   	push   %ebx
  801440:	e8 0a fc ff ff       	call   80104f <fd_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 37                	js     801483 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801452:	50                   	push   %eax
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	ff 30                	pushl  (%eax)
  801458:	e8 42 fc ff ff       	call   80109f <dev_lookup>
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	78 1f                	js     801483 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801467:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80146b:	74 1b                	je     801488 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80146d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801470:	8b 52 18             	mov    0x18(%edx),%edx
  801473:	85 d2                	test   %edx,%edx
  801475:	74 32                	je     8014a9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801477:	83 ec 08             	sub    $0x8,%esp
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	50                   	push   %eax
  80147e:	ff d2                	call   *%edx
  801480:	83 c4 10             	add    $0x10,%esp
}
  801483:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801486:	c9                   	leave  
  801487:	c3                   	ret    
			thisenv->env_id, fdnum);
  801488:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80148d:	8b 40 48             	mov    0x48(%eax),%eax
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	53                   	push   %ebx
  801494:	50                   	push   %eax
  801495:	68 6c 25 80 00       	push   $0x80256c
  80149a:	e8 c4 ed ff ff       	call   800263 <cprintf>
		return -E_INVAL;
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a7:	eb da                	jmp    801483 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ae:	eb d3                	jmp    801483 <ftruncate+0x52>

008014b0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	53                   	push   %ebx
  8014b4:	83 ec 1c             	sub    $0x1c,%esp
  8014b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014bd:	50                   	push   %eax
  8014be:	ff 75 08             	pushl  0x8(%ebp)
  8014c1:	e8 89 fb ff ff       	call   80104f <fd_lookup>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	78 4b                	js     801518 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014cd:	83 ec 08             	sub    $0x8,%esp
  8014d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d3:	50                   	push   %eax
  8014d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d7:	ff 30                	pushl  (%eax)
  8014d9:	e8 c1 fb ff ff       	call   80109f <dev_lookup>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 33                	js     801518 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014ec:	74 2f                	je     80151d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014ee:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014f1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014f8:	00 00 00 
	stat->st_isdir = 0;
  8014fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801502:	00 00 00 
	stat->st_dev = dev;
  801505:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	53                   	push   %ebx
  80150f:	ff 75 f0             	pushl  -0x10(%ebp)
  801512:	ff 50 14             	call   *0x14(%eax)
  801515:	83 c4 10             	add    $0x10,%esp
}
  801518:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    
		return -E_NOT_SUPP;
  80151d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801522:	eb f4                	jmp    801518 <fstat+0x68>

00801524 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	56                   	push   %esi
  801528:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	6a 00                	push   $0x0
  80152e:	ff 75 08             	pushl  0x8(%ebp)
  801531:	e8 e7 01 00 00       	call   80171d <open>
  801536:	89 c3                	mov    %eax,%ebx
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 1b                	js     80155a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	50                   	push   %eax
  801546:	e8 65 ff ff ff       	call   8014b0 <fstat>
  80154b:	89 c6                	mov    %eax,%esi
	close(fd);
  80154d:	89 1c 24             	mov    %ebx,(%esp)
  801550:	e8 27 fc ff ff       	call   80117c <close>
	return r;
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	89 f3                	mov    %esi,%ebx
}
  80155a:	89 d8                	mov    %ebx,%eax
  80155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    

00801563 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
  801568:	89 c6                	mov    %eax,%esi
  80156a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80156c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801573:	74 27                	je     80159c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801575:	6a 07                	push   $0x7
  801577:	68 00 70 80 00       	push   $0x807000
  80157c:	56                   	push   %esi
  80157d:	ff 35 00 40 80 00    	pushl  0x804000
  801583:	e8 78 08 00 00       	call   801e00 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801588:	83 c4 0c             	add    $0xc,%esp
  80158b:	6a 00                	push   $0x0
  80158d:	53                   	push   %ebx
  80158e:	6a 00                	push   $0x0
  801590:	e8 04 08 00 00       	call   801d99 <ipc_recv>
}
  801595:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801598:	5b                   	pop    %ebx
  801599:	5e                   	pop    %esi
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	6a 01                	push   $0x1
  8015a1:	e8 a3 08 00 00       	call   801e49 <ipc_find_env>
  8015a6:	a3 00 40 80 00       	mov    %eax,0x804000
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	eb c5                	jmp    801575 <fsipc+0x12>

008015b0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bc:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8015d3:	e8 8b ff ff ff       	call   801563 <fsipc>
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <devfile_flush>:
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e6:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8015eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f0:	b8 06 00 00 00       	mov    $0x6,%eax
  8015f5:	e8 69 ff ff ff       	call   801563 <fsipc>
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <devfile_stat>:
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	53                   	push   %ebx
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	8b 40 0c             	mov    0xc(%eax),%eax
  80160c:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801611:	ba 00 00 00 00       	mov    $0x0,%edx
  801616:	b8 05 00 00 00       	mov    $0x5,%eax
  80161b:	e8 43 ff ff ff       	call   801563 <fsipc>
  801620:	85 c0                	test   %eax,%eax
  801622:	78 2c                	js     801650 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	68 00 70 80 00       	push   $0x807000
  80162c:	53                   	push   %ebx
  80162d:	e8 3f f3 ff ff       	call   800971 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801632:	a1 80 70 80 00       	mov    0x807080,%eax
  801637:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80163d:	a1 84 70 80 00       	mov    0x807084,%eax
  801642:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801650:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <devfile_write>:
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80165e:	8b 55 08             	mov    0x8(%ebp),%edx
  801661:	8b 52 0c             	mov    0xc(%edx),%edx
  801664:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80166a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80166f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801674:	0f 47 c2             	cmova  %edx,%eax
  801677:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80167c:	50                   	push   %eax
  80167d:	ff 75 0c             	pushl  0xc(%ebp)
  801680:	68 08 70 80 00       	push   $0x807008
  801685:	e8 75 f4 ff ff       	call   800aff <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80168a:	ba 00 00 00 00       	mov    $0x0,%edx
  80168f:	b8 04 00 00 00       	mov    $0x4,%eax
  801694:	e8 ca fe ff ff       	call   801563 <fsipc>
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <devfile_read>:
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	56                   	push   %esi
  80169f:	53                   	push   %ebx
  8016a0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a9:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8016ae:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8016be:	e8 a0 fe ff ff       	call   801563 <fsipc>
  8016c3:	89 c3                	mov    %eax,%ebx
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 1f                	js     8016e8 <devfile_read+0x4d>
	assert(r <= n);
  8016c9:	39 f0                	cmp    %esi,%eax
  8016cb:	77 24                	ja     8016f1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016cd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d2:	7f 33                	jg     801707 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	50                   	push   %eax
  8016d8:	68 00 70 80 00       	push   $0x807000
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	e8 1a f4 ff ff       	call   800aff <memmove>
	return r;
  8016e5:	83 c4 10             	add    $0x10,%esp
}
  8016e8:	89 d8                	mov    %ebx,%eax
  8016ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5e                   	pop    %esi
  8016ef:	5d                   	pop    %ebp
  8016f0:	c3                   	ret    
	assert(r <= n);
  8016f1:	68 dc 25 80 00       	push   $0x8025dc
  8016f6:	68 e3 25 80 00       	push   $0x8025e3
  8016fb:	6a 7c                	push   $0x7c
  8016fd:	68 f8 25 80 00       	push   $0x8025f8
  801702:	e8 81 ea ff ff       	call   800188 <_panic>
	assert(r <= PGSIZE);
  801707:	68 03 26 80 00       	push   $0x802603
  80170c:	68 e3 25 80 00       	push   $0x8025e3
  801711:	6a 7d                	push   $0x7d
  801713:	68 f8 25 80 00       	push   $0x8025f8
  801718:	e8 6b ea ff ff       	call   800188 <_panic>

0080171d <open>:
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
  801722:	83 ec 1c             	sub    $0x1c,%esp
  801725:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801728:	56                   	push   %esi
  801729:	e8 0a f2 ff ff       	call   800938 <strlen>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801736:	7f 6c                	jg     8017a4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801738:	83 ec 0c             	sub    $0xc,%esp
  80173b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173e:	50                   	push   %eax
  80173f:	e8 b9 f8 ff ff       	call   800ffd <fd_alloc>
  801744:	89 c3                	mov    %eax,%ebx
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	85 c0                	test   %eax,%eax
  80174b:	78 3c                	js     801789 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	56                   	push   %esi
  801751:	68 00 70 80 00       	push   $0x807000
  801756:	e8 16 f2 ff ff       	call   800971 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80175b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175e:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801766:	b8 01 00 00 00       	mov    $0x1,%eax
  80176b:	e8 f3 fd ff ff       	call   801563 <fsipc>
  801770:	89 c3                	mov    %eax,%ebx
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	78 19                	js     801792 <open+0x75>
	return fd2num(fd);
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	ff 75 f4             	pushl  -0xc(%ebp)
  80177f:	e8 52 f8 ff ff       	call   800fd6 <fd2num>
  801784:	89 c3                	mov    %eax,%ebx
  801786:	83 c4 10             	add    $0x10,%esp
}
  801789:	89 d8                	mov    %ebx,%eax
  80178b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178e:	5b                   	pop    %ebx
  80178f:	5e                   	pop    %esi
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    
		fd_close(fd, 0);
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	6a 00                	push   $0x0
  801797:	ff 75 f4             	pushl  -0xc(%ebp)
  80179a:	e8 56 f9 ff ff       	call   8010f5 <fd_close>
		return r;
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	eb e5                	jmp    801789 <open+0x6c>
		return -E_BAD_PATH;
  8017a4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017a9:	eb de                	jmp    801789 <open+0x6c>

008017ab <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8017bb:	e8 a3 fd ff ff       	call   801563 <fsipc>
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8017c2:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8017c6:	7f 01                	jg     8017c9 <writebuf+0x7>
  8017c8:	c3                   	ret    
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	53                   	push   %ebx
  8017cd:	83 ec 08             	sub    $0x8,%esp
  8017d0:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8017d2:	ff 70 04             	pushl  0x4(%eax)
  8017d5:	8d 40 10             	lea    0x10(%eax),%eax
  8017d8:	50                   	push   %eax
  8017d9:	ff 33                	pushl  (%ebx)
  8017db:	e8 a6 fb ff ff       	call   801386 <write>
		if (result > 0)
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	7e 03                	jle    8017ea <writebuf+0x28>
			b->result += result;
  8017e7:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8017ea:	39 43 04             	cmp    %eax,0x4(%ebx)
  8017ed:	74 0d                	je     8017fc <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f6:	0f 4f c2             	cmovg  %edx,%eax
  8017f9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <putch>:

static void
putch(int ch, void *thunk)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	53                   	push   %ebx
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80180b:	8b 53 04             	mov    0x4(%ebx),%edx
  80180e:	8d 42 01             	lea    0x1(%edx),%eax
  801811:	89 43 04             	mov    %eax,0x4(%ebx)
  801814:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801817:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80181b:	3d 00 01 00 00       	cmp    $0x100,%eax
  801820:	74 06                	je     801828 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801822:	83 c4 04             	add    $0x4,%esp
  801825:	5b                   	pop    %ebx
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    
		writebuf(b);
  801828:	89 d8                	mov    %ebx,%eax
  80182a:	e8 93 ff ff ff       	call   8017c2 <writebuf>
		b->idx = 0;
  80182f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801836:	eb ea                	jmp    801822 <putch+0x21>

00801838 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80184a:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801851:	00 00 00 
	b.result = 0;
  801854:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80185b:	00 00 00 
	b.error = 1;
  80185e:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801865:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801868:	ff 75 10             	pushl  0x10(%ebp)
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801874:	50                   	push   %eax
  801875:	68 01 18 80 00       	push   $0x801801
  80187a:	e8 11 eb ff ff       	call   800390 <vprintfmt>
	if (b.idx > 0)
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801889:	7f 11                	jg     80189c <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80188b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801891:	85 c0                	test   %eax,%eax
  801893:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    
		writebuf(&b);
  80189c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018a2:	e8 1b ff ff ff       	call   8017c2 <writebuf>
  8018a7:	eb e2                	jmp    80188b <vfprintf+0x53>

008018a9 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018af:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8018b2:	50                   	push   %eax
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	e8 7a ff ff ff       	call   801838 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <printf>:

int
printf(const char *fmt, ...)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8018c9:	50                   	push   %eax
  8018ca:	ff 75 08             	pushl  0x8(%ebp)
  8018cd:	6a 01                	push   $0x1
  8018cf:	e8 64 ff ff ff       	call   801838 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	56                   	push   %esi
  8018da:	53                   	push   %ebx
  8018db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	e8 fd f6 ff ff       	call   800fe6 <fd2data>
  8018e9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018eb:	83 c4 08             	add    $0x8,%esp
  8018ee:	68 0f 26 80 00       	push   $0x80260f
  8018f3:	53                   	push   %ebx
  8018f4:	e8 78 f0 ff ff       	call   800971 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018f9:	8b 46 04             	mov    0x4(%esi),%eax
  8018fc:	2b 06                	sub    (%esi),%eax
  8018fe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801904:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80190b:	00 00 00 
	stat->st_dev = &devpipe;
  80190e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801915:	30 80 00 
	return 0;
}
  801918:	b8 00 00 00 00       	mov    $0x0,%eax
  80191d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801920:	5b                   	pop    %ebx
  801921:	5e                   	pop    %esi
  801922:	5d                   	pop    %ebp
  801923:	c3                   	ret    

00801924 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	53                   	push   %ebx
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80192e:	53                   	push   %ebx
  80192f:	6a 00                	push   $0x0
  801931:	e8 b2 f4 ff ff       	call   800de8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801936:	89 1c 24             	mov    %ebx,(%esp)
  801939:	e8 a8 f6 ff ff       	call   800fe6 <fd2data>
  80193e:	83 c4 08             	add    $0x8,%esp
  801941:	50                   	push   %eax
  801942:	6a 00                	push   $0x0
  801944:	e8 9f f4 ff ff       	call   800de8 <sys_page_unmap>
}
  801949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <_pipeisclosed>:
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	57                   	push   %edi
  801952:	56                   	push   %esi
  801953:	53                   	push   %ebx
  801954:	83 ec 1c             	sub    $0x1c,%esp
  801957:	89 c7                	mov    %eax,%edi
  801959:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80195b:	a1 20 60 80 00       	mov    0x806020,%eax
  801960:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801963:	83 ec 0c             	sub    $0xc,%esp
  801966:	57                   	push   %edi
  801967:	e8 1c 05 00 00       	call   801e88 <pageref>
  80196c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80196f:	89 34 24             	mov    %esi,(%esp)
  801972:	e8 11 05 00 00       	call   801e88 <pageref>
		nn = thisenv->env_runs;
  801977:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80197d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	39 cb                	cmp    %ecx,%ebx
  801985:	74 1b                	je     8019a2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801987:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80198a:	75 cf                	jne    80195b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80198c:	8b 42 58             	mov    0x58(%edx),%eax
  80198f:	6a 01                	push   $0x1
  801991:	50                   	push   %eax
  801992:	53                   	push   %ebx
  801993:	68 16 26 80 00       	push   $0x802616
  801998:	e8 c6 e8 ff ff       	call   800263 <cprintf>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	eb b9                	jmp    80195b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019a2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019a5:	0f 94 c0             	sete   %al
  8019a8:	0f b6 c0             	movzbl %al,%eax
}
  8019ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5e                   	pop    %esi
  8019b0:	5f                   	pop    %edi
  8019b1:	5d                   	pop    %ebp
  8019b2:	c3                   	ret    

008019b3 <devpipe_write>:
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	57                   	push   %edi
  8019b7:	56                   	push   %esi
  8019b8:	53                   	push   %ebx
  8019b9:	83 ec 28             	sub    $0x28,%esp
  8019bc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8019bf:	56                   	push   %esi
  8019c0:	e8 21 f6 ff ff       	call   800fe6 <fd2data>
  8019c5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8019cf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019d2:	74 4f                	je     801a23 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019d4:	8b 43 04             	mov    0x4(%ebx),%eax
  8019d7:	8b 0b                	mov    (%ebx),%ecx
  8019d9:	8d 51 20             	lea    0x20(%ecx),%edx
  8019dc:	39 d0                	cmp    %edx,%eax
  8019de:	72 14                	jb     8019f4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8019e0:	89 da                	mov    %ebx,%edx
  8019e2:	89 f0                	mov    %esi,%eax
  8019e4:	e8 65 ff ff ff       	call   80194e <_pipeisclosed>
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	75 3b                	jne    801a28 <devpipe_write+0x75>
			sys_yield();
  8019ed:	e8 52 f3 ff ff       	call   800d44 <sys_yield>
  8019f2:	eb e0                	jmp    8019d4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019f7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019fb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019fe:	89 c2                	mov    %eax,%edx
  801a00:	c1 fa 1f             	sar    $0x1f,%edx
  801a03:	89 d1                	mov    %edx,%ecx
  801a05:	c1 e9 1b             	shr    $0x1b,%ecx
  801a08:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a0b:	83 e2 1f             	and    $0x1f,%edx
  801a0e:	29 ca                	sub    %ecx,%edx
  801a10:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a14:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a18:	83 c0 01             	add    $0x1,%eax
  801a1b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a1e:	83 c7 01             	add    $0x1,%edi
  801a21:	eb ac                	jmp    8019cf <devpipe_write+0x1c>
	return i;
  801a23:	8b 45 10             	mov    0x10(%ebp),%eax
  801a26:	eb 05                	jmp    801a2d <devpipe_write+0x7a>
				return 0;
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5f                   	pop    %edi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    

00801a35 <devpipe_read>:
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	57                   	push   %edi
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
  801a3b:	83 ec 18             	sub    $0x18,%esp
  801a3e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a41:	57                   	push   %edi
  801a42:	e8 9f f5 ff ff       	call   800fe6 <fd2data>
  801a47:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	be 00 00 00 00       	mov    $0x0,%esi
  801a51:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a54:	75 14                	jne    801a6a <devpipe_read+0x35>
	return i;
  801a56:	8b 45 10             	mov    0x10(%ebp),%eax
  801a59:	eb 02                	jmp    801a5d <devpipe_read+0x28>
				return i;
  801a5b:	89 f0                	mov    %esi,%eax
}
  801a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    
			sys_yield();
  801a65:	e8 da f2 ff ff       	call   800d44 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801a6a:	8b 03                	mov    (%ebx),%eax
  801a6c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a6f:	75 18                	jne    801a89 <devpipe_read+0x54>
			if (i > 0)
  801a71:	85 f6                	test   %esi,%esi
  801a73:	75 e6                	jne    801a5b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801a75:	89 da                	mov    %ebx,%edx
  801a77:	89 f8                	mov    %edi,%eax
  801a79:	e8 d0 fe ff ff       	call   80194e <_pipeisclosed>
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	74 e3                	je     801a65 <devpipe_read+0x30>
				return 0;
  801a82:	b8 00 00 00 00       	mov    $0x0,%eax
  801a87:	eb d4                	jmp    801a5d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a89:	99                   	cltd   
  801a8a:	c1 ea 1b             	shr    $0x1b,%edx
  801a8d:	01 d0                	add    %edx,%eax
  801a8f:	83 e0 1f             	and    $0x1f,%eax
  801a92:	29 d0                	sub    %edx,%eax
  801a94:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a9c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a9f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801aa2:	83 c6 01             	add    $0x1,%esi
  801aa5:	eb aa                	jmp    801a51 <devpipe_read+0x1c>

00801aa7 <pipe>:
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	56                   	push   %esi
  801aab:	53                   	push   %ebx
  801aac:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801aaf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab2:	50                   	push   %eax
  801ab3:	e8 45 f5 ff ff       	call   800ffd <fd_alloc>
  801ab8:	89 c3                	mov    %eax,%ebx
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	85 c0                	test   %eax,%eax
  801abf:	0f 88 23 01 00 00    	js     801be8 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	68 07 04 00 00       	push   $0x407
  801acd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad0:	6a 00                	push   $0x0
  801ad2:	e8 8c f2 ff ff       	call   800d63 <sys_page_alloc>
  801ad7:	89 c3                	mov    %eax,%ebx
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	85 c0                	test   %eax,%eax
  801ade:	0f 88 04 01 00 00    	js     801be8 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ae4:	83 ec 0c             	sub    $0xc,%esp
  801ae7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aea:	50                   	push   %eax
  801aeb:	e8 0d f5 ff ff       	call   800ffd <fd_alloc>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	85 c0                	test   %eax,%eax
  801af7:	0f 88 db 00 00 00    	js     801bd8 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	68 07 04 00 00       	push   $0x407
  801b05:	ff 75 f0             	pushl  -0x10(%ebp)
  801b08:	6a 00                	push   $0x0
  801b0a:	e8 54 f2 ff ff       	call   800d63 <sys_page_alloc>
  801b0f:	89 c3                	mov    %eax,%ebx
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	85 c0                	test   %eax,%eax
  801b16:	0f 88 bc 00 00 00    	js     801bd8 <pipe+0x131>
	va = fd2data(fd0);
  801b1c:	83 ec 0c             	sub    $0xc,%esp
  801b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b22:	e8 bf f4 ff ff       	call   800fe6 <fd2data>
  801b27:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b29:	83 c4 0c             	add    $0xc,%esp
  801b2c:	68 07 04 00 00       	push   $0x407
  801b31:	50                   	push   %eax
  801b32:	6a 00                	push   $0x0
  801b34:	e8 2a f2 ff ff       	call   800d63 <sys_page_alloc>
  801b39:	89 c3                	mov    %eax,%ebx
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	0f 88 82 00 00 00    	js     801bc8 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b46:	83 ec 0c             	sub    $0xc,%esp
  801b49:	ff 75 f0             	pushl  -0x10(%ebp)
  801b4c:	e8 95 f4 ff ff       	call   800fe6 <fd2data>
  801b51:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b58:	50                   	push   %eax
  801b59:	6a 00                	push   $0x0
  801b5b:	56                   	push   %esi
  801b5c:	6a 00                	push   $0x0
  801b5e:	e8 43 f2 ff ff       	call   800da6 <sys_page_map>
  801b63:	89 c3                	mov    %eax,%ebx
  801b65:	83 c4 20             	add    $0x20,%esp
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	78 4e                	js     801bba <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801b6c:	a1 20 30 80 00       	mov    0x803020,%eax
  801b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b74:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b79:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801b80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b83:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b88:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	ff 75 f4             	pushl  -0xc(%ebp)
  801b95:	e8 3c f4 ff ff       	call   800fd6 <fd2num>
  801b9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b9d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b9f:	83 c4 04             	add    $0x4,%esp
  801ba2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba5:	e8 2c f4 ff ff       	call   800fd6 <fd2num>
  801baa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bad:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bb8:	eb 2e                	jmp    801be8 <pipe+0x141>
	sys_page_unmap(0, va);
  801bba:	83 ec 08             	sub    $0x8,%esp
  801bbd:	56                   	push   %esi
  801bbe:	6a 00                	push   $0x0
  801bc0:	e8 23 f2 ff ff       	call   800de8 <sys_page_unmap>
  801bc5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	ff 75 f0             	pushl  -0x10(%ebp)
  801bce:	6a 00                	push   $0x0
  801bd0:	e8 13 f2 ff ff       	call   800de8 <sys_page_unmap>
  801bd5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801bd8:	83 ec 08             	sub    $0x8,%esp
  801bdb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bde:	6a 00                	push   $0x0
  801be0:	e8 03 f2 ff ff       	call   800de8 <sys_page_unmap>
  801be5:	83 c4 10             	add    $0x10,%esp
}
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bed:	5b                   	pop    %ebx
  801bee:	5e                   	pop    %esi
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    

00801bf1 <pipeisclosed>:
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bf7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfa:	50                   	push   %eax
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	e8 4c f4 ff ff       	call   80104f <fd_lookup>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 18                	js     801c22 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c0a:	83 ec 0c             	sub    $0xc,%esp
  801c0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c10:	e8 d1 f3 ff ff       	call   800fe6 <fd2data>
	return _pipeisclosed(fd, p);
  801c15:	89 c2                	mov    %eax,%edx
  801c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1a:	e8 2f fd ff ff       	call   80194e <_pipeisclosed>
  801c1f:	83 c4 10             	add    $0x10,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801c24:	b8 00 00 00 00       	mov    $0x0,%eax
  801c29:	c3                   	ret    

00801c2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c30:	68 2e 26 80 00       	push   $0x80262e
  801c35:	ff 75 0c             	pushl  0xc(%ebp)
  801c38:	e8 34 ed ff ff       	call   800971 <strcpy>
	return 0;
}
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <devcons_write>:
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	57                   	push   %edi
  801c48:	56                   	push   %esi
  801c49:	53                   	push   %ebx
  801c4a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c50:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c55:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c5b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c5e:	73 31                	jae    801c91 <devcons_write+0x4d>
		m = n - tot;
  801c60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c63:	29 f3                	sub    %esi,%ebx
  801c65:	83 fb 7f             	cmp    $0x7f,%ebx
  801c68:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c6d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	53                   	push   %ebx
  801c74:	89 f0                	mov    %esi,%eax
  801c76:	03 45 0c             	add    0xc(%ebp),%eax
  801c79:	50                   	push   %eax
  801c7a:	57                   	push   %edi
  801c7b:	e8 7f ee ff ff       	call   800aff <memmove>
		sys_cputs(buf, m);
  801c80:	83 c4 08             	add    $0x8,%esp
  801c83:	53                   	push   %ebx
  801c84:	57                   	push   %edi
  801c85:	e8 1d f0 ff ff       	call   800ca7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c8a:	01 de                	add    %ebx,%esi
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	eb ca                	jmp    801c5b <devcons_write+0x17>
}
  801c91:	89 f0                	mov    %esi,%eax
  801c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5f                   	pop    %edi
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    

00801c9b <devcons_read>:
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 08             	sub    $0x8,%esp
  801ca1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ca6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801caa:	74 21                	je     801ccd <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801cac:	e8 14 f0 ff ff       	call   800cc5 <sys_cgetc>
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	75 07                	jne    801cbc <devcons_read+0x21>
		sys_yield();
  801cb5:	e8 8a f0 ff ff       	call   800d44 <sys_yield>
  801cba:	eb f0                	jmp    801cac <devcons_read+0x11>
	if (c < 0)
  801cbc:	78 0f                	js     801ccd <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801cbe:	83 f8 04             	cmp    $0x4,%eax
  801cc1:	74 0c                	je     801ccf <devcons_read+0x34>
	*(char*)vbuf = c;
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	88 02                	mov    %al,(%edx)
	return 1;
  801cc8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    
		return 0;
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd4:	eb f7                	jmp    801ccd <devcons_read+0x32>

00801cd6 <cputchar>:
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ce2:	6a 01                	push   $0x1
  801ce4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ce7:	50                   	push   %eax
  801ce8:	e8 ba ef ff ff       	call   800ca7 <sys_cputs>
}
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <getchar>:
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801cf8:	6a 01                	push   $0x1
  801cfa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cfd:	50                   	push   %eax
  801cfe:	6a 00                	push   $0x0
  801d00:	e8 b5 f5 ff ff       	call   8012ba <read>
	if (r < 0)
  801d05:	83 c4 10             	add    $0x10,%esp
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 06                	js     801d12 <getchar+0x20>
	if (r < 1)
  801d0c:	74 06                	je     801d14 <getchar+0x22>
	return c;
  801d0e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    
		return -E_EOF;
  801d14:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d19:	eb f7                	jmp    801d12 <getchar+0x20>

00801d1b <iscons>:
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d24:	50                   	push   %eax
  801d25:	ff 75 08             	pushl  0x8(%ebp)
  801d28:	e8 22 f3 ff ff       	call   80104f <fd_lookup>
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 11                	js     801d45 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d37:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d3d:	39 10                	cmp    %edx,(%eax)
  801d3f:	0f 94 c0             	sete   %al
  801d42:	0f b6 c0             	movzbl %al,%eax
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <opencons>:
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d50:	50                   	push   %eax
  801d51:	e8 a7 f2 ff ff       	call   800ffd <fd_alloc>
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 3a                	js     801d97 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	68 07 04 00 00       	push   $0x407
  801d65:	ff 75 f4             	pushl  -0xc(%ebp)
  801d68:	6a 00                	push   $0x0
  801d6a:	e8 f4 ef ff ff       	call   800d63 <sys_page_alloc>
  801d6f:	83 c4 10             	add    $0x10,%esp
  801d72:	85 c0                	test   %eax,%eax
  801d74:	78 21                	js     801d97 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d79:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d7f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d84:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d8b:	83 ec 0c             	sub    $0xc,%esp
  801d8e:	50                   	push   %eax
  801d8f:	e8 42 f2 ff ff       	call   800fd6 <fd2num>
  801d94:	83 c4 10             	add    $0x10,%esp
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	56                   	push   %esi
  801d9d:	53                   	push   %ebx
  801d9e:	8b 75 08             	mov    0x8(%ebp),%esi
  801da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  801da7:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801da9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801dae:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	50                   	push   %eax
  801db5:	e8 9a f1 ff ff       	call   800f54 <sys_ipc_recv>
	if (from_env_store)
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	85 f6                	test   %esi,%esi
  801dbf:	74 14                	je     801dd5 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  801dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	78 09                	js     801dd3 <ipc_recv+0x3a>
  801dca:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801dd0:	8b 52 78             	mov    0x78(%edx),%edx
  801dd3:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  801dd5:	85 db                	test   %ebx,%ebx
  801dd7:	74 14                	je     801ded <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  801dd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 09                	js     801deb <ipc_recv+0x52>
  801de2:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801de8:	8b 52 7c             	mov    0x7c(%edx),%edx
  801deb:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 08                	js     801df9 <ipc_recv+0x60>
  801df1:	a1 20 60 80 00       	mov    0x806020,%eax
  801df6:	8b 40 74             	mov    0x74(%eax),%eax
}
  801df9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfc:	5b                   	pop    %ebx
  801dfd:	5e                   	pop    %esi
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    

00801e00 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 08             	sub    $0x8,%esp
  801e06:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e10:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801e13:	ff 75 14             	pushl  0x14(%ebp)
  801e16:	50                   	push   %eax
  801e17:	ff 75 0c             	pushl  0xc(%ebp)
  801e1a:	ff 75 08             	pushl  0x8(%ebp)
  801e1d:	e8 0f f1 ff ff       	call   800f31 <sys_ipc_try_send>
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	85 c0                	test   %eax,%eax
  801e27:	78 02                	js     801e2b <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  801e2b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e2e:	75 07                	jne    801e37 <ipc_send+0x37>
		sys_yield();
  801e30:	e8 0f ef ff ff       	call   800d44 <sys_yield>
}
  801e35:	eb f2                	jmp    801e29 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  801e37:	50                   	push   %eax
  801e38:	68 3a 26 80 00       	push   $0x80263a
  801e3d:	6a 3c                	push   $0x3c
  801e3f:	68 4e 26 80 00       	push   $0x80264e
  801e44:	e8 3f e3 ff ff       	call   800188 <_panic>

00801e49 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e4f:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  801e54:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801e57:	c1 e0 04             	shl    $0x4,%eax
  801e5a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e5f:	8b 40 50             	mov    0x50(%eax),%eax
  801e62:	39 c8                	cmp    %ecx,%eax
  801e64:	74 12                	je     801e78 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801e66:	83 c2 01             	add    $0x1,%edx
  801e69:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  801e6f:	75 e3                	jne    801e54 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
  801e76:	eb 0e                	jmp    801e86 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801e78:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801e7b:	c1 e0 04             	shl    $0x4,%eax
  801e7e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e83:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    

00801e88 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e8e:	89 d0                	mov    %edx,%eax
  801e90:	c1 e8 16             	shr    $0x16,%eax
  801e93:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801e9f:	f6 c1 01             	test   $0x1,%cl
  801ea2:	74 1d                	je     801ec1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ea4:	c1 ea 0c             	shr    $0xc,%edx
  801ea7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801eae:	f6 c2 01             	test   $0x1,%dl
  801eb1:	74 0e                	je     801ec1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801eb3:	c1 ea 0c             	shr    $0xc,%edx
  801eb6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ebd:	ef 
  801ebe:	0f b7 c0             	movzwl %ax,%eax
}
  801ec1:	5d                   	pop    %ebp
  801ec2:	c3                   	ret    
  801ec3:	66 90                	xchg   %ax,%ax
  801ec5:	66 90                	xchg   %ax,%ax
  801ec7:	66 90                	xchg   %ax,%ax
  801ec9:	66 90                	xchg   %ax,%ax
  801ecb:	66 90                	xchg   %ax,%ax
  801ecd:	66 90                	xchg   %ax,%ax
  801ecf:	90                   	nop

00801ed0 <__udivdi3>:
  801ed0:	55                   	push   %ebp
  801ed1:	57                   	push   %edi
  801ed2:	56                   	push   %esi
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 1c             	sub    $0x1c,%esp
  801ed7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801edb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ee3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ee7:	85 d2                	test   %edx,%edx
  801ee9:	75 4d                	jne    801f38 <__udivdi3+0x68>
  801eeb:	39 f3                	cmp    %esi,%ebx
  801eed:	76 19                	jbe    801f08 <__udivdi3+0x38>
  801eef:	31 ff                	xor    %edi,%edi
  801ef1:	89 e8                	mov    %ebp,%eax
  801ef3:	89 f2                	mov    %esi,%edx
  801ef5:	f7 f3                	div    %ebx
  801ef7:	89 fa                	mov    %edi,%edx
  801ef9:	83 c4 1c             	add    $0x1c,%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5f                   	pop    %edi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    
  801f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f08:	89 d9                	mov    %ebx,%ecx
  801f0a:	85 db                	test   %ebx,%ebx
  801f0c:	75 0b                	jne    801f19 <__udivdi3+0x49>
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	31 d2                	xor    %edx,%edx
  801f15:	f7 f3                	div    %ebx
  801f17:	89 c1                	mov    %eax,%ecx
  801f19:	31 d2                	xor    %edx,%edx
  801f1b:	89 f0                	mov    %esi,%eax
  801f1d:	f7 f1                	div    %ecx
  801f1f:	89 c6                	mov    %eax,%esi
  801f21:	89 e8                	mov    %ebp,%eax
  801f23:	89 f7                	mov    %esi,%edi
  801f25:	f7 f1                	div    %ecx
  801f27:	89 fa                	mov    %edi,%edx
  801f29:	83 c4 1c             	add    $0x1c,%esp
  801f2c:	5b                   	pop    %ebx
  801f2d:	5e                   	pop    %esi
  801f2e:	5f                   	pop    %edi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    
  801f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f38:	39 f2                	cmp    %esi,%edx
  801f3a:	77 1c                	ja     801f58 <__udivdi3+0x88>
  801f3c:	0f bd fa             	bsr    %edx,%edi
  801f3f:	83 f7 1f             	xor    $0x1f,%edi
  801f42:	75 2c                	jne    801f70 <__udivdi3+0xa0>
  801f44:	39 f2                	cmp    %esi,%edx
  801f46:	72 06                	jb     801f4e <__udivdi3+0x7e>
  801f48:	31 c0                	xor    %eax,%eax
  801f4a:	39 eb                	cmp    %ebp,%ebx
  801f4c:	77 a9                	ja     801ef7 <__udivdi3+0x27>
  801f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f53:	eb a2                	jmp    801ef7 <__udivdi3+0x27>
  801f55:	8d 76 00             	lea    0x0(%esi),%esi
  801f58:	31 ff                	xor    %edi,%edi
  801f5a:	31 c0                	xor    %eax,%eax
  801f5c:	89 fa                	mov    %edi,%edx
  801f5e:	83 c4 1c             	add    $0x1c,%esp
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5f                   	pop    %edi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    
  801f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f6d:	8d 76 00             	lea    0x0(%esi),%esi
  801f70:	89 f9                	mov    %edi,%ecx
  801f72:	b8 20 00 00 00       	mov    $0x20,%eax
  801f77:	29 f8                	sub    %edi,%eax
  801f79:	d3 e2                	shl    %cl,%edx
  801f7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f7f:	89 c1                	mov    %eax,%ecx
  801f81:	89 da                	mov    %ebx,%edx
  801f83:	d3 ea                	shr    %cl,%edx
  801f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f89:	09 d1                	or     %edx,%ecx
  801f8b:	89 f2                	mov    %esi,%edx
  801f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f91:	89 f9                	mov    %edi,%ecx
  801f93:	d3 e3                	shl    %cl,%ebx
  801f95:	89 c1                	mov    %eax,%ecx
  801f97:	d3 ea                	shr    %cl,%edx
  801f99:	89 f9                	mov    %edi,%ecx
  801f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f9f:	89 eb                	mov    %ebp,%ebx
  801fa1:	d3 e6                	shl    %cl,%esi
  801fa3:	89 c1                	mov    %eax,%ecx
  801fa5:	d3 eb                	shr    %cl,%ebx
  801fa7:	09 de                	or     %ebx,%esi
  801fa9:	89 f0                	mov    %esi,%eax
  801fab:	f7 74 24 08          	divl   0x8(%esp)
  801faf:	89 d6                	mov    %edx,%esi
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	f7 64 24 0c          	mull   0xc(%esp)
  801fb7:	39 d6                	cmp    %edx,%esi
  801fb9:	72 15                	jb     801fd0 <__udivdi3+0x100>
  801fbb:	89 f9                	mov    %edi,%ecx
  801fbd:	d3 e5                	shl    %cl,%ebp
  801fbf:	39 c5                	cmp    %eax,%ebp
  801fc1:	73 04                	jae    801fc7 <__udivdi3+0xf7>
  801fc3:	39 d6                	cmp    %edx,%esi
  801fc5:	74 09                	je     801fd0 <__udivdi3+0x100>
  801fc7:	89 d8                	mov    %ebx,%eax
  801fc9:	31 ff                	xor    %edi,%edi
  801fcb:	e9 27 ff ff ff       	jmp    801ef7 <__udivdi3+0x27>
  801fd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fd3:	31 ff                	xor    %edi,%edi
  801fd5:	e9 1d ff ff ff       	jmp    801ef7 <__udivdi3+0x27>
  801fda:	66 90                	xchg   %ax,%ax
  801fdc:	66 90                	xchg   %ax,%ax
  801fde:	66 90                	xchg   %ax,%ax

00801fe0 <__umoddi3>:
  801fe0:	55                   	push   %ebp
  801fe1:	57                   	push   %edi
  801fe2:	56                   	push   %esi
  801fe3:	53                   	push   %ebx
  801fe4:	83 ec 1c             	sub    $0x1c,%esp
  801fe7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801feb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fef:	8b 74 24 30          	mov    0x30(%esp),%esi
  801ff3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ff7:	89 da                	mov    %ebx,%edx
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 43                	jne    802040 <__umoddi3+0x60>
  801ffd:	39 df                	cmp    %ebx,%edi
  801fff:	76 17                	jbe    802018 <__umoddi3+0x38>
  802001:	89 f0                	mov    %esi,%eax
  802003:	f7 f7                	div    %edi
  802005:	89 d0                	mov    %edx,%eax
  802007:	31 d2                	xor    %edx,%edx
  802009:	83 c4 1c             	add    $0x1c,%esp
  80200c:	5b                   	pop    %ebx
  80200d:	5e                   	pop    %esi
  80200e:	5f                   	pop    %edi
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    
  802011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802018:	89 fd                	mov    %edi,%ebp
  80201a:	85 ff                	test   %edi,%edi
  80201c:	75 0b                	jne    802029 <__umoddi3+0x49>
  80201e:	b8 01 00 00 00       	mov    $0x1,%eax
  802023:	31 d2                	xor    %edx,%edx
  802025:	f7 f7                	div    %edi
  802027:	89 c5                	mov    %eax,%ebp
  802029:	89 d8                	mov    %ebx,%eax
  80202b:	31 d2                	xor    %edx,%edx
  80202d:	f7 f5                	div    %ebp
  80202f:	89 f0                	mov    %esi,%eax
  802031:	f7 f5                	div    %ebp
  802033:	89 d0                	mov    %edx,%eax
  802035:	eb d0                	jmp    802007 <__umoddi3+0x27>
  802037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80203e:	66 90                	xchg   %ax,%ax
  802040:	89 f1                	mov    %esi,%ecx
  802042:	39 d8                	cmp    %ebx,%eax
  802044:	76 0a                	jbe    802050 <__umoddi3+0x70>
  802046:	89 f0                	mov    %esi,%eax
  802048:	83 c4 1c             	add    $0x1c,%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    
  802050:	0f bd e8             	bsr    %eax,%ebp
  802053:	83 f5 1f             	xor    $0x1f,%ebp
  802056:	75 20                	jne    802078 <__umoddi3+0x98>
  802058:	39 d8                	cmp    %ebx,%eax
  80205a:	0f 82 b0 00 00 00    	jb     802110 <__umoddi3+0x130>
  802060:	39 f7                	cmp    %esi,%edi
  802062:	0f 86 a8 00 00 00    	jbe    802110 <__umoddi3+0x130>
  802068:	89 c8                	mov    %ecx,%eax
  80206a:	83 c4 1c             	add    $0x1c,%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5f                   	pop    %edi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    
  802072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802078:	89 e9                	mov    %ebp,%ecx
  80207a:	ba 20 00 00 00       	mov    $0x20,%edx
  80207f:	29 ea                	sub    %ebp,%edx
  802081:	d3 e0                	shl    %cl,%eax
  802083:	89 44 24 08          	mov    %eax,0x8(%esp)
  802087:	89 d1                	mov    %edx,%ecx
  802089:	89 f8                	mov    %edi,%eax
  80208b:	d3 e8                	shr    %cl,%eax
  80208d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802091:	89 54 24 04          	mov    %edx,0x4(%esp)
  802095:	8b 54 24 04          	mov    0x4(%esp),%edx
  802099:	09 c1                	or     %eax,%ecx
  80209b:	89 d8                	mov    %ebx,%eax
  80209d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020a1:	89 e9                	mov    %ebp,%ecx
  8020a3:	d3 e7                	shl    %cl,%edi
  8020a5:	89 d1                	mov    %edx,%ecx
  8020a7:	d3 e8                	shr    %cl,%eax
  8020a9:	89 e9                	mov    %ebp,%ecx
  8020ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020af:	d3 e3                	shl    %cl,%ebx
  8020b1:	89 c7                	mov    %eax,%edi
  8020b3:	89 d1                	mov    %edx,%ecx
  8020b5:	89 f0                	mov    %esi,%eax
  8020b7:	d3 e8                	shr    %cl,%eax
  8020b9:	89 e9                	mov    %ebp,%ecx
  8020bb:	89 fa                	mov    %edi,%edx
  8020bd:	d3 e6                	shl    %cl,%esi
  8020bf:	09 d8                	or     %ebx,%eax
  8020c1:	f7 74 24 08          	divl   0x8(%esp)
  8020c5:	89 d1                	mov    %edx,%ecx
  8020c7:	89 f3                	mov    %esi,%ebx
  8020c9:	f7 64 24 0c          	mull   0xc(%esp)
  8020cd:	89 c6                	mov    %eax,%esi
  8020cf:	89 d7                	mov    %edx,%edi
  8020d1:	39 d1                	cmp    %edx,%ecx
  8020d3:	72 06                	jb     8020db <__umoddi3+0xfb>
  8020d5:	75 10                	jne    8020e7 <__umoddi3+0x107>
  8020d7:	39 c3                	cmp    %eax,%ebx
  8020d9:	73 0c                	jae    8020e7 <__umoddi3+0x107>
  8020db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8020df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8020e3:	89 d7                	mov    %edx,%edi
  8020e5:	89 c6                	mov    %eax,%esi
  8020e7:	89 ca                	mov    %ecx,%edx
  8020e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020ee:	29 f3                	sub    %esi,%ebx
  8020f0:	19 fa                	sbb    %edi,%edx
  8020f2:	89 d0                	mov    %edx,%eax
  8020f4:	d3 e0                	shl    %cl,%eax
  8020f6:	89 e9                	mov    %ebp,%ecx
  8020f8:	d3 eb                	shr    %cl,%ebx
  8020fa:	d3 ea                	shr    %cl,%edx
  8020fc:	09 d8                	or     %ebx,%eax
  8020fe:	83 c4 1c             	add    $0x1c,%esp
  802101:	5b                   	pop    %ebx
  802102:	5e                   	pop    %esi
  802103:	5f                   	pop    %edi
  802104:	5d                   	pop    %ebp
  802105:	c3                   	ret    
  802106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80210d:	8d 76 00             	lea    0x0(%esi),%esi
  802110:	89 da                	mov    %ebx,%edx
  802112:	29 fe                	sub    %edi,%esi
  802114:	19 c2                	sbb    %eax,%edx
  802116:	89 f1                	mov    %esi,%ecx
  802118:	89 c8                	mov    %ecx,%eax
  80211a:	e9 4b ff ff ff       	jmp    80206a <__umoddi3+0x8a>
