
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
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
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 00 	movl   $0x802600,0x803000
  800045:	26 80 00 

	cprintf("icode startup\n");
  800048:	68 06 26 80 00       	push   $0x802606
  80004d:	e8 18 02 00 00       	call   80026a <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 15 26 80 00 	movl   $0x802615,(%esp)
  800059:	e8 0c 02 00 00       	call   80026a <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 28 26 80 00       	push   $0x802628
  800068:	e8 b7 16 00 00       	call   801724 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 51 26 80 00       	push   $0x802651
  80007e:	e8 e7 01 00 00       	call   80026a <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 26 12 00 00       	call   8012c1 <read>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7e 21                	jle    8000c3 <umain+0x90>
		sys_cputs(buf, n);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	53                   	push   %ebx
  8000a7:	e8 02 0c 00 00       	call   800cae <sys_cputs>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	eb db                	jmp    80008c <umain+0x59>
		panic("icode: open /motd: %e", fd);
  8000b1:	50                   	push   %eax
  8000b2:	68 2e 26 80 00       	push   $0x80262e
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 44 26 80 00       	push   $0x802644
  8000be:	e8 cc 00 00 00       	call   80018f <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 64 26 80 00       	push   $0x802664
  8000cb:	e8 9a 01 00 00       	call   80026a <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 ab 10 00 00       	call   801183 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 78 26 80 00 	movl   $0x802678,(%esp)
  8000df:	e8 86 01 00 00       	call   80026a <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 8c 26 80 00       	push   $0x80268c
  8000f0:	68 95 26 80 00       	push   $0x802695
  8000f5:	68 9f 26 80 00       	push   $0x80269f
  8000fa:	68 9e 26 80 00       	push   $0x80269e
  8000ff:	e8 35 1c 00 00       	call   801d39 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 bb 26 80 00       	push   $0x8026bb
  800113:	e8 52 01 00 00       	call   80026a <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 a4 26 80 00       	push   $0x8026a4
  800128:	6a 1a                	push   $0x1a
  80012a:	68 44 26 80 00       	push   $0x802644
  80012f:	e8 5b 00 00 00       	call   80018f <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013f:	e8 e8 0b 00 00       	call   800d2c <sys_getenvid>
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80014c:	c1 e0 04             	shl    $0x4,%eax
  80014f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800154:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800159:	85 db                	test   %ebx,%ebx
  80015b:	7e 07                	jle    800164 <libmain+0x30>
		binaryname = argv[0];
  80015d:	8b 06                	mov    (%esi),%eax
  80015f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	e8 c5 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016e:	e8 0a 00 00 00       	call   80017d <exit>
}
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    

0080017d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800183:	6a 00                	push   $0x0
  800185:	e8 61 0b 00 00       	call   800ceb <sys_env_destroy>
}
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800194:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800197:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019d:	e8 8a 0b 00 00       	call   800d2c <sys_getenvid>
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	56                   	push   %esi
  8001ac:	50                   	push   %eax
  8001ad:	68 d8 26 80 00       	push   $0x8026d8
  8001b2:	e8 b3 00 00 00       	call   80026a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b7:	83 c4 18             	add    $0x18,%esp
  8001ba:	53                   	push   %ebx
  8001bb:	ff 75 10             	pushl  0x10(%ebp)
  8001be:	e8 56 00 00 00       	call   800219 <vcprintf>
	cprintf("\n");
  8001c3:	c7 04 24 38 2c 80 00 	movl   $0x802c38,(%esp)
  8001ca:	e8 9b 00 00 00       	call   80026a <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d2:	cc                   	int3   
  8001d3:	eb fd                	jmp    8001d2 <_panic+0x43>

008001d5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 04             	sub    $0x4,%esp
  8001dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001df:	8b 13                	mov    (%ebx),%edx
  8001e1:	8d 42 01             	lea    0x1(%edx),%eax
  8001e4:	89 03                	mov    %eax,(%ebx)
  8001e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f2:	74 09                	je     8001fd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	68 ff 00 00 00       	push   $0xff
  800205:	8d 43 08             	lea    0x8(%ebx),%eax
  800208:	50                   	push   %eax
  800209:	e8 a0 0a 00 00       	call   800cae <sys_cputs>
		b->idx = 0;
  80020e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	eb db                	jmp    8001f4 <putch+0x1f>

00800219 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800222:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800229:	00 00 00 
	b.cnt = 0;
  80022c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800233:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800236:	ff 75 0c             	pushl  0xc(%ebp)
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800242:	50                   	push   %eax
  800243:	68 d5 01 80 00       	push   $0x8001d5
  800248:	e8 4a 01 00 00       	call   800397 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024d:	83 c4 08             	add    $0x8,%esp
  800250:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800256:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 4c 0a 00 00       	call   800cae <sys_cputs>

	return b.cnt;
}
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800270:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800273:	50                   	push   %eax
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	e8 9d ff ff ff       	call   800219 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 1c             	sub    $0x1c,%esp
  800287:	89 c6                	mov    %eax,%esi
  800289:	89 d7                	mov    %edx,%edi
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800291:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800294:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800297:	8b 45 10             	mov    0x10(%ebp),%eax
  80029a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80029d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002a1:	74 2c                	je     8002cf <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b8:	73 43                	jae    8002fd <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ba:	83 eb 01             	sub    $0x1,%ebx
  8002bd:	85 db                	test   %ebx,%ebx
  8002bf:	7e 6c                	jle    80032d <printnum+0xaf>
			putch(padc, putdat);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	57                   	push   %edi
  8002c5:	ff 75 18             	pushl  0x18(%ebp)
  8002c8:	ff d6                	call   *%esi
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	eb eb                	jmp    8002ba <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	6a 20                	push   $0x20
  8002d4:	6a 00                	push   $0x0
  8002d6:	50                   	push   %eax
  8002d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002da:	ff 75 e0             	pushl  -0x20(%ebp)
  8002dd:	89 fa                	mov    %edi,%edx
  8002df:	89 f0                	mov    %esi,%eax
  8002e1:	e8 98 ff ff ff       	call   80027e <printnum>
		while (--width > 0)
  8002e6:	83 c4 20             	add    $0x20,%esp
  8002e9:	83 eb 01             	sub    $0x1,%ebx
  8002ec:	85 db                	test   %ebx,%ebx
  8002ee:	7e 65                	jle    800355 <printnum+0xd7>
			putch(padc, putdat);
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	57                   	push   %edi
  8002f4:	6a 20                	push   $0x20
  8002f6:	ff d6                	call   *%esi
  8002f8:	83 c4 10             	add    $0x10,%esp
  8002fb:	eb ec                	jmp    8002e9 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	ff 75 18             	pushl  0x18(%ebp)
  800303:	83 eb 01             	sub    $0x1,%ebx
  800306:	53                   	push   %ebx
  800307:	50                   	push   %eax
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	ff 75 dc             	pushl  -0x24(%ebp)
  80030e:	ff 75 d8             	pushl  -0x28(%ebp)
  800311:	ff 75 e4             	pushl  -0x1c(%ebp)
  800314:	ff 75 e0             	pushl  -0x20(%ebp)
  800317:	e8 94 20 00 00       	call   8023b0 <__udivdi3>
  80031c:	83 c4 18             	add    $0x18,%esp
  80031f:	52                   	push   %edx
  800320:	50                   	push   %eax
  800321:	89 fa                	mov    %edi,%edx
  800323:	89 f0                	mov    %esi,%eax
  800325:	e8 54 ff ff ff       	call   80027e <printnum>
  80032a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032d:	83 ec 08             	sub    $0x8,%esp
  800330:	57                   	push   %edi
  800331:	83 ec 04             	sub    $0x4,%esp
  800334:	ff 75 dc             	pushl  -0x24(%ebp)
  800337:	ff 75 d8             	pushl  -0x28(%ebp)
  80033a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033d:	ff 75 e0             	pushl  -0x20(%ebp)
  800340:	e8 7b 21 00 00       	call   8024c0 <__umoddi3>
  800345:	83 c4 14             	add    $0x14,%esp
  800348:	0f be 80 fb 26 80 00 	movsbl 0x8026fb(%eax),%eax
  80034f:	50                   	push   %eax
  800350:	ff d6                	call   *%esi
  800352:	83 c4 10             	add    $0x10,%esp
}
  800355:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800358:	5b                   	pop    %ebx
  800359:	5e                   	pop    %esi
  80035a:	5f                   	pop    %edi
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800363:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800367:	8b 10                	mov    (%eax),%edx
  800369:	3b 50 04             	cmp    0x4(%eax),%edx
  80036c:	73 0a                	jae    800378 <sprintputch+0x1b>
		*b->buf++ = ch;
  80036e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800371:	89 08                	mov    %ecx,(%eax)
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	88 02                	mov    %al,(%edx)
}
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <printfmt>:
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800380:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800383:	50                   	push   %eax
  800384:	ff 75 10             	pushl  0x10(%ebp)
  800387:	ff 75 0c             	pushl  0xc(%ebp)
  80038a:	ff 75 08             	pushl  0x8(%ebp)
  80038d:	e8 05 00 00 00       	call   800397 <vprintfmt>
}
  800392:	83 c4 10             	add    $0x10,%esp
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <vprintfmt>:
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	57                   	push   %edi
  80039b:	56                   	push   %esi
  80039c:	53                   	push   %ebx
  80039d:	83 ec 3c             	sub    $0x3c,%esp
  8003a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a9:	e9 b4 03 00 00       	jmp    800762 <vprintfmt+0x3cb>
		padc = ' ';
  8003ae:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8003b2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8003b9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003ce:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d3:	8d 47 01             	lea    0x1(%edi),%eax
  8003d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d9:	0f b6 17             	movzbl (%edi),%edx
  8003dc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003df:	3c 55                	cmp    $0x55,%al
  8003e1:	0f 87 c8 04 00 00    	ja     8008af <vprintfmt+0x518>
  8003e7:	0f b6 c0             	movzbl %al,%eax
  8003ea:	ff 24 85 e0 28 80 00 	jmp    *0x8028e0(,%eax,4)
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8003f4:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8003fb:	eb d6                	jmp    8003d3 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800400:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800404:	eb cd                	jmp    8003d3 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800406:	0f b6 d2             	movzbl %dl,%edx
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80040c:	b8 00 00 00 00       	mov    $0x0,%eax
  800411:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800414:	eb 0c                	jmp    800422 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800419:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80041d:	eb b4                	jmp    8003d3 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80041f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800422:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800425:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800429:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80042c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80042f:	83 f9 09             	cmp    $0x9,%ecx
  800432:	76 eb                	jbe    80041f <vprintfmt+0x88>
  800434:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800437:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043a:	eb 14                	jmp    800450 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80043c:	8b 45 14             	mov    0x14(%ebp),%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 40 04             	lea    0x4(%eax),%eax
  80044a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800450:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800454:	0f 89 79 ff ff ff    	jns    8003d3 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80045a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800460:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800467:	e9 67 ff ff ff       	jmp    8003d3 <vprintfmt+0x3c>
  80046c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046f:	85 c0                	test   %eax,%eax
  800471:	ba 00 00 00 00       	mov    $0x0,%edx
  800476:	0f 49 d0             	cmovns %eax,%edx
  800479:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80047f:	e9 4f ff ff ff       	jmp    8003d3 <vprintfmt+0x3c>
  800484:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800487:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80048e:	e9 40 ff ff ff       	jmp    8003d3 <vprintfmt+0x3c>
			lflag++;
  800493:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800496:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800499:	e9 35 ff ff ff       	jmp    8003d3 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8d 78 04             	lea    0x4(%eax),%edi
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	53                   	push   %ebx
  8004a8:	ff 30                	pushl  (%eax)
  8004aa:	ff d6                	call   *%esi
			break;
  8004ac:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004af:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b2:	e9 a8 02 00 00       	jmp    80075f <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	8d 78 04             	lea    0x4(%eax),%edi
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	99                   	cltd   
  8004c0:	31 d0                	xor    %edx,%eax
  8004c2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c4:	83 f8 0f             	cmp    $0xf,%eax
  8004c7:	7f 23                	jg     8004ec <vprintfmt+0x155>
  8004c9:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  8004d0:	85 d2                	test   %edx,%edx
  8004d2:	74 18                	je     8004ec <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8004d4:	52                   	push   %edx
  8004d5:	68 51 2b 80 00       	push   $0x802b51
  8004da:	53                   	push   %ebx
  8004db:	56                   	push   %esi
  8004dc:	e8 99 fe ff ff       	call   80037a <printfmt>
  8004e1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e7:	e9 73 02 00 00       	jmp    80075f <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8004ec:	50                   	push   %eax
  8004ed:	68 13 27 80 00       	push   $0x802713
  8004f2:	53                   	push   %ebx
  8004f3:	56                   	push   %esi
  8004f4:	e8 81 fe ff ff       	call   80037a <printfmt>
  8004f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004fc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ff:	e9 5b 02 00 00       	jmp    80075f <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	83 c0 04             	add    $0x4,%eax
  80050a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800512:	85 d2                	test   %edx,%edx
  800514:	b8 0c 27 80 00       	mov    $0x80270c,%eax
  800519:	0f 45 c2             	cmovne %edx,%eax
  80051c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80051f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800523:	7e 06                	jle    80052b <vprintfmt+0x194>
  800525:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800529:	75 0d                	jne    800538 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052e:	89 c7                	mov    %eax,%edi
  800530:	03 45 e0             	add    -0x20(%ebp),%eax
  800533:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800536:	eb 53                	jmp    80058b <vprintfmt+0x1f4>
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	ff 75 d8             	pushl  -0x28(%ebp)
  80053e:	50                   	push   %eax
  80053f:	e8 13 04 00 00       	call   800957 <strnlen>
  800544:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800547:	29 c1                	sub    %eax,%ecx
  800549:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800551:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800555:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800558:	eb 0f                	jmp    800569 <vprintfmt+0x1d2>
					putch(padc, putdat);
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	53                   	push   %ebx
  80055e:	ff 75 e0             	pushl  -0x20(%ebp)
  800561:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800563:	83 ef 01             	sub    $0x1,%edi
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	85 ff                	test   %edi,%edi
  80056b:	7f ed                	jg     80055a <vprintfmt+0x1c3>
  80056d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800570:	85 d2                	test   %edx,%edx
  800572:	b8 00 00 00 00       	mov    $0x0,%eax
  800577:	0f 49 c2             	cmovns %edx,%eax
  80057a:	29 c2                	sub    %eax,%edx
  80057c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80057f:	eb aa                	jmp    80052b <vprintfmt+0x194>
					putch(ch, putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	52                   	push   %edx
  800586:	ff d6                	call   *%esi
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80058e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800590:	83 c7 01             	add    $0x1,%edi
  800593:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800597:	0f be d0             	movsbl %al,%edx
  80059a:	85 d2                	test   %edx,%edx
  80059c:	74 4b                	je     8005e9 <vprintfmt+0x252>
  80059e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a2:	78 06                	js     8005aa <vprintfmt+0x213>
  8005a4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005a8:	78 1e                	js     8005c8 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8005aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ae:	74 d1                	je     800581 <vprintfmt+0x1ea>
  8005b0:	0f be c0             	movsbl %al,%eax
  8005b3:	83 e8 20             	sub    $0x20,%eax
  8005b6:	83 f8 5e             	cmp    $0x5e,%eax
  8005b9:	76 c6                	jbe    800581 <vprintfmt+0x1ea>
					putch('?', putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	53                   	push   %ebx
  8005bf:	6a 3f                	push   $0x3f
  8005c1:	ff d6                	call   *%esi
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	eb c3                	jmp    80058b <vprintfmt+0x1f4>
  8005c8:	89 cf                	mov    %ecx,%edi
  8005ca:	eb 0e                	jmp    8005da <vprintfmt+0x243>
				putch(' ', putdat);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	53                   	push   %ebx
  8005d0:	6a 20                	push   $0x20
  8005d2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d4:	83 ef 01             	sub    $0x1,%edi
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	85 ff                	test   %edi,%edi
  8005dc:	7f ee                	jg     8005cc <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8005de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e4:	e9 76 01 00 00       	jmp    80075f <vprintfmt+0x3c8>
  8005e9:	89 cf                	mov    %ecx,%edi
  8005eb:	eb ed                	jmp    8005da <vprintfmt+0x243>
	if (lflag >= 2)
  8005ed:	83 f9 01             	cmp    $0x1,%ecx
  8005f0:	7f 1f                	jg     800611 <vprintfmt+0x27a>
	else if (lflag)
  8005f2:	85 c9                	test   %ecx,%ecx
  8005f4:	74 6a                	je     800660 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fe:	89 c1                	mov    %eax,%ecx
  800600:	c1 f9 1f             	sar    $0x1f,%ecx
  800603:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 40 04             	lea    0x4(%eax),%eax
  80060c:	89 45 14             	mov    %eax,0x14(%ebp)
  80060f:	eb 17                	jmp    800628 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 50 04             	mov    0x4(%eax),%edx
  800617:	8b 00                	mov    (%eax),%eax
  800619:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 40 08             	lea    0x8(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800628:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80062b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800630:	85 d2                	test   %edx,%edx
  800632:	0f 89 f8 00 00 00    	jns    800730 <vprintfmt+0x399>
				putch('-', putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 2d                	push   $0x2d
  80063e:	ff d6                	call   *%esi
				num = -(long long) num;
  800640:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800643:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800646:	f7 d8                	neg    %eax
  800648:	83 d2 00             	adc    $0x0,%edx
  80064b:	f7 da                	neg    %edx
  80064d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800650:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800653:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800656:	bf 0a 00 00 00       	mov    $0xa,%edi
  80065b:	e9 e1 00 00 00       	jmp    800741 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800668:	99                   	cltd   
  800669:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 40 04             	lea    0x4(%eax),%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
  800675:	eb b1                	jmp    800628 <vprintfmt+0x291>
	if (lflag >= 2)
  800677:	83 f9 01             	cmp    $0x1,%ecx
  80067a:	7f 27                	jg     8006a3 <vprintfmt+0x30c>
	else if (lflag)
  80067c:	85 c9                	test   %ecx,%ecx
  80067e:	74 41                	je     8006c1 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	ba 00 00 00 00       	mov    $0x0,%edx
  80068a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8d 40 04             	lea    0x4(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800699:	bf 0a 00 00 00       	mov    $0xa,%edi
  80069e:	e9 8d 00 00 00       	jmp    800730 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 50 04             	mov    0x4(%eax),%edx
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8d 40 08             	lea    0x8(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ba:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006bf:	eb 6f                	jmp    800730 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006da:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006df:	eb 4f                	jmp    800730 <vprintfmt+0x399>
	if (lflag >= 2)
  8006e1:	83 f9 01             	cmp    $0x1,%ecx
  8006e4:	7f 23                	jg     800709 <vprintfmt+0x372>
	else if (lflag)
  8006e6:	85 c9                	test   %ecx,%ecx
  8006e8:	0f 84 98 00 00 00    	je     800786 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
  800707:	eb 17                	jmp    800720 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 40 08             	lea    0x8(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	53                   	push   %ebx
  800724:	6a 30                	push   $0x30
  800726:	ff d6                	call   *%esi
			goto number;
  800728:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80072b:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800730:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800734:	74 0b                	je     800741 <vprintfmt+0x3aa>
				putch('+', putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	53                   	push   %ebx
  80073a:	6a 2b                	push   $0x2b
  80073c:	ff d6                	call   *%esi
  80073e:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	ff 75 e0             	pushl  -0x20(%ebp)
  80074c:	57                   	push   %edi
  80074d:	ff 75 dc             	pushl  -0x24(%ebp)
  800750:	ff 75 d8             	pushl  -0x28(%ebp)
  800753:	89 da                	mov    %ebx,%edx
  800755:	89 f0                	mov    %esi,%eax
  800757:	e8 22 fb ff ff       	call   80027e <printnum>
			break;
  80075c:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80075f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800762:	83 c7 01             	add    $0x1,%edi
  800765:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800769:	83 f8 25             	cmp    $0x25,%eax
  80076c:	0f 84 3c fc ff ff    	je     8003ae <vprintfmt+0x17>
			if (ch == '\0')
  800772:	85 c0                	test   %eax,%eax
  800774:	0f 84 55 01 00 00    	je     8008cf <vprintfmt+0x538>
			putch(ch, putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	50                   	push   %eax
  80077f:	ff d6                	call   *%esi
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	eb dc                	jmp    800762 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
  80079f:	e9 7c ff ff ff       	jmp    800720 <vprintfmt+0x389>
			putch('0', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	53                   	push   %ebx
  8007a8:	6a 30                	push   $0x30
  8007aa:	ff d6                	call   *%esi
			putch('x', putdat);
  8007ac:	83 c4 08             	add    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	6a 78                	push   $0x78
  8007b2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007c4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 40 04             	lea    0x4(%eax),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d0:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8007d5:	e9 56 ff ff ff       	jmp    800730 <vprintfmt+0x399>
	if (lflag >= 2)
  8007da:	83 f9 01             	cmp    $0x1,%ecx
  8007dd:	7f 27                	jg     800806 <vprintfmt+0x46f>
	else if (lflag)
  8007df:	85 c9                	test   %ecx,%ecx
  8007e1:	74 44                	je     800827 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8d 40 04             	lea    0x4(%eax),%eax
  8007f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fc:	bf 10 00 00 00       	mov    $0x10,%edi
  800801:	e9 2a ff ff ff       	jmp    800730 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 50 04             	mov    0x4(%eax),%edx
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800811:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 08             	lea    0x8(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081d:	bf 10 00 00 00       	mov    $0x10,%edi
  800822:	e9 09 ff ff ff       	jmp    800730 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800834:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	8d 40 04             	lea    0x4(%eax),%eax
  80083d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800840:	bf 10 00 00 00       	mov    $0x10,%edi
  800845:	e9 e6 fe ff ff       	jmp    800730 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8d 78 04             	lea    0x4(%eax),%edi
  800850:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800852:	85 c0                	test   %eax,%eax
  800854:	74 2d                	je     800883 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800856:	0f b6 13             	movzbl (%ebx),%edx
  800859:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80085b:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  80085e:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800861:	0f 8e f8 fe ff ff    	jle    80075f <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800867:	68 68 28 80 00       	push   $0x802868
  80086c:	68 51 2b 80 00       	push   $0x802b51
  800871:	53                   	push   %ebx
  800872:	56                   	push   %esi
  800873:	e8 02 fb ff ff       	call   80037a <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80087b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80087e:	e9 dc fe ff ff       	jmp    80075f <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800883:	68 30 28 80 00       	push   $0x802830
  800888:	68 51 2b 80 00       	push   $0x802b51
  80088d:	53                   	push   %ebx
  80088e:	56                   	push   %esi
  80088f:	e8 e6 fa ff ff       	call   80037a <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800897:	89 7d 14             	mov    %edi,0x14(%ebp)
  80089a:	e9 c0 fe ff ff       	jmp    80075f <vprintfmt+0x3c8>
			putch(ch, putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	6a 25                	push   $0x25
  8008a5:	ff d6                	call   *%esi
			break;
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	e9 b0 fe ff ff       	jmp    80075f <vprintfmt+0x3c8>
			putch('%', putdat);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	53                   	push   %ebx
  8008b3:	6a 25                	push   $0x25
  8008b5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	89 f8                	mov    %edi,%eax
  8008bc:	eb 03                	jmp    8008c1 <vprintfmt+0x52a>
  8008be:	83 e8 01             	sub    $0x1,%eax
  8008c1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008c5:	75 f7                	jne    8008be <vprintfmt+0x527>
  8008c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ca:	e9 90 fe ff ff       	jmp    80075f <vprintfmt+0x3c8>
}
  8008cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d2:	5b                   	pop    %ebx
  8008d3:	5e                   	pop    %esi
  8008d4:	5f                   	pop    %edi
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 18             	sub    $0x18,%esp
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ea:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	74 26                	je     80091e <vsnprintf+0x47>
  8008f8:	85 d2                	test   %edx,%edx
  8008fa:	7e 22                	jle    80091e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008fc:	ff 75 14             	pushl  0x14(%ebp)
  8008ff:	ff 75 10             	pushl  0x10(%ebp)
  800902:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800905:	50                   	push   %eax
  800906:	68 5d 03 80 00       	push   $0x80035d
  80090b:	e8 87 fa ff ff       	call   800397 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800913:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800919:	83 c4 10             	add    $0x10,%esp
}
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    
		return -E_INVAL;
  80091e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800923:	eb f7                	jmp    80091c <vsnprintf+0x45>

00800925 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80092b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80092e:	50                   	push   %eax
  80092f:	ff 75 10             	pushl  0x10(%ebp)
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	ff 75 08             	pushl  0x8(%ebp)
  800938:	e8 9a ff ff ff       	call   8008d7 <vsnprintf>
	va_end(ap);

	return rc;
}
  80093d:	c9                   	leave  
  80093e:	c3                   	ret    

0080093f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80094e:	74 05                	je     800955 <strlen+0x16>
		n++;
  800950:	83 c0 01             	add    $0x1,%eax
  800953:	eb f5                	jmp    80094a <strlen+0xb>
	return n;
}
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800960:	ba 00 00 00 00       	mov    $0x0,%edx
  800965:	39 c2                	cmp    %eax,%edx
  800967:	74 0d                	je     800976 <strnlen+0x1f>
  800969:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80096d:	74 05                	je     800974 <strnlen+0x1d>
		n++;
  80096f:	83 c2 01             	add    $0x1,%edx
  800972:	eb f1                	jmp    800965 <strnlen+0xe>
  800974:	89 d0                	mov    %edx,%eax
	return n;
}
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	53                   	push   %ebx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800982:	ba 00 00 00 00       	mov    $0x0,%edx
  800987:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80098b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80098e:	83 c2 01             	add    $0x1,%edx
  800991:	84 c9                	test   %cl,%cl
  800993:	75 f2                	jne    800987 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800995:	5b                   	pop    %ebx
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	53                   	push   %ebx
  80099c:	83 ec 10             	sub    $0x10,%esp
  80099f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009a2:	53                   	push   %ebx
  8009a3:	e8 97 ff ff ff       	call   80093f <strlen>
  8009a8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009ab:	ff 75 0c             	pushl  0xc(%ebp)
  8009ae:	01 d8                	add    %ebx,%eax
  8009b0:	50                   	push   %eax
  8009b1:	e8 c2 ff ff ff       	call   800978 <strcpy>
	return dst;
}
  8009b6:	89 d8                	mov    %ebx,%eax
  8009b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    

008009bd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c8:	89 c6                	mov    %eax,%esi
  8009ca:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009cd:	89 c2                	mov    %eax,%edx
  8009cf:	39 f2                	cmp    %esi,%edx
  8009d1:	74 11                	je     8009e4 <strncpy+0x27>
		*dst++ = *src;
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	0f b6 19             	movzbl (%ecx),%ebx
  8009d9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009dc:	80 fb 01             	cmp    $0x1,%bl
  8009df:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009e2:	eb eb                	jmp    8009cf <strncpy+0x12>
	}
	return ret;
}
  8009e4:	5b                   	pop    %ebx
  8009e5:	5e                   	pop    %esi
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	56                   	push   %esi
  8009ec:	53                   	push   %ebx
  8009ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f3:	8b 55 10             	mov    0x10(%ebp),%edx
  8009f6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f8:	85 d2                	test   %edx,%edx
  8009fa:	74 21                	je     800a1d <strlcpy+0x35>
  8009fc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a00:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a02:	39 c2                	cmp    %eax,%edx
  800a04:	74 14                	je     800a1a <strlcpy+0x32>
  800a06:	0f b6 19             	movzbl (%ecx),%ebx
  800a09:	84 db                	test   %bl,%bl
  800a0b:	74 0b                	je     800a18 <strlcpy+0x30>
			*dst++ = *src++;
  800a0d:	83 c1 01             	add    $0x1,%ecx
  800a10:	83 c2 01             	add    $0x1,%edx
  800a13:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a16:	eb ea                	jmp    800a02 <strlcpy+0x1a>
  800a18:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a1a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a1d:	29 f0                	sub    %esi,%eax
}
  800a1f:	5b                   	pop    %ebx
  800a20:	5e                   	pop    %esi
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a29:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a2c:	0f b6 01             	movzbl (%ecx),%eax
  800a2f:	84 c0                	test   %al,%al
  800a31:	74 0c                	je     800a3f <strcmp+0x1c>
  800a33:	3a 02                	cmp    (%edx),%al
  800a35:	75 08                	jne    800a3f <strcmp+0x1c>
		p++, q++;
  800a37:	83 c1 01             	add    $0x1,%ecx
  800a3a:	83 c2 01             	add    $0x1,%edx
  800a3d:	eb ed                	jmp    800a2c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3f:	0f b6 c0             	movzbl %al,%eax
  800a42:	0f b6 12             	movzbl (%edx),%edx
  800a45:	29 d0                	sub    %edx,%eax
}
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	53                   	push   %ebx
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a53:	89 c3                	mov    %eax,%ebx
  800a55:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a58:	eb 06                	jmp    800a60 <strncmp+0x17>
		n--, p++, q++;
  800a5a:	83 c0 01             	add    $0x1,%eax
  800a5d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a60:	39 d8                	cmp    %ebx,%eax
  800a62:	74 16                	je     800a7a <strncmp+0x31>
  800a64:	0f b6 08             	movzbl (%eax),%ecx
  800a67:	84 c9                	test   %cl,%cl
  800a69:	74 04                	je     800a6f <strncmp+0x26>
  800a6b:	3a 0a                	cmp    (%edx),%cl
  800a6d:	74 eb                	je     800a5a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6f:	0f b6 00             	movzbl (%eax),%eax
  800a72:	0f b6 12             	movzbl (%edx),%edx
  800a75:	29 d0                	sub    %edx,%eax
}
  800a77:	5b                   	pop    %ebx
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    
		return 0;
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7f:	eb f6                	jmp    800a77 <strncmp+0x2e>

00800a81 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8b:	0f b6 10             	movzbl (%eax),%edx
  800a8e:	84 d2                	test   %dl,%dl
  800a90:	74 09                	je     800a9b <strchr+0x1a>
		if (*s == c)
  800a92:	38 ca                	cmp    %cl,%dl
  800a94:	74 0a                	je     800aa0 <strchr+0x1f>
	for (; *s; s++)
  800a96:	83 c0 01             	add    $0x1,%eax
  800a99:	eb f0                	jmp    800a8b <strchr+0xa>
			return (char *) s;
	return 0;
  800a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa0:	5d                   	pop    %ebp
  800aa1:	c3                   	ret    

00800aa2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aac:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aaf:	38 ca                	cmp    %cl,%dl
  800ab1:	74 09                	je     800abc <strfind+0x1a>
  800ab3:	84 d2                	test   %dl,%dl
  800ab5:	74 05                	je     800abc <strfind+0x1a>
	for (; *s; s++)
  800ab7:	83 c0 01             	add    $0x1,%eax
  800aba:	eb f0                	jmp    800aac <strfind+0xa>
			break;
	return (char *) s;
}
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	57                   	push   %edi
  800ac2:	56                   	push   %esi
  800ac3:	53                   	push   %ebx
  800ac4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aca:	85 c9                	test   %ecx,%ecx
  800acc:	74 31                	je     800aff <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ace:	89 f8                	mov    %edi,%eax
  800ad0:	09 c8                	or     %ecx,%eax
  800ad2:	a8 03                	test   $0x3,%al
  800ad4:	75 23                	jne    800af9 <memset+0x3b>
		c &= 0xFF;
  800ad6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ada:	89 d3                	mov    %edx,%ebx
  800adc:	c1 e3 08             	shl    $0x8,%ebx
  800adf:	89 d0                	mov    %edx,%eax
  800ae1:	c1 e0 18             	shl    $0x18,%eax
  800ae4:	89 d6                	mov    %edx,%esi
  800ae6:	c1 e6 10             	shl    $0x10,%esi
  800ae9:	09 f0                	or     %esi,%eax
  800aeb:	09 c2                	or     %eax,%edx
  800aed:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aef:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800af2:	89 d0                	mov    %edx,%eax
  800af4:	fc                   	cld    
  800af5:	f3 ab                	rep stos %eax,%es:(%edi)
  800af7:	eb 06                	jmp    800aff <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	fc                   	cld    
  800afd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aff:	89 f8                	mov    %edi,%eax
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b14:	39 c6                	cmp    %eax,%esi
  800b16:	73 32                	jae    800b4a <memmove+0x44>
  800b18:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b1b:	39 c2                	cmp    %eax,%edx
  800b1d:	76 2b                	jbe    800b4a <memmove+0x44>
		s += n;
		d += n;
  800b1f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b22:	89 fe                	mov    %edi,%esi
  800b24:	09 ce                	or     %ecx,%esi
  800b26:	09 d6                	or     %edx,%esi
  800b28:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2e:	75 0e                	jne    800b3e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b30:	83 ef 04             	sub    $0x4,%edi
  800b33:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b39:	fd                   	std    
  800b3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3c:	eb 09                	jmp    800b47 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b3e:	83 ef 01             	sub    $0x1,%edi
  800b41:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b44:	fd                   	std    
  800b45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b47:	fc                   	cld    
  800b48:	eb 1a                	jmp    800b64 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4a:	89 c2                	mov    %eax,%edx
  800b4c:	09 ca                	or     %ecx,%edx
  800b4e:	09 f2                	or     %esi,%edx
  800b50:	f6 c2 03             	test   $0x3,%dl
  800b53:	75 0a                	jne    800b5f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b55:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b58:	89 c7                	mov    %eax,%edi
  800b5a:	fc                   	cld    
  800b5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5d:	eb 05                	jmp    800b64 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b5f:	89 c7                	mov    %eax,%edi
  800b61:	fc                   	cld    
  800b62:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b64:	5e                   	pop    %esi
  800b65:	5f                   	pop    %edi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b6e:	ff 75 10             	pushl  0x10(%ebp)
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	ff 75 08             	pushl  0x8(%ebp)
  800b77:	e8 8a ff ff ff       	call   800b06 <memmove>
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b89:	89 c6                	mov    %eax,%esi
  800b8b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b8e:	39 f0                	cmp    %esi,%eax
  800b90:	74 1c                	je     800bae <memcmp+0x30>
		if (*s1 != *s2)
  800b92:	0f b6 08             	movzbl (%eax),%ecx
  800b95:	0f b6 1a             	movzbl (%edx),%ebx
  800b98:	38 d9                	cmp    %bl,%cl
  800b9a:	75 08                	jne    800ba4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b9c:	83 c0 01             	add    $0x1,%eax
  800b9f:	83 c2 01             	add    $0x1,%edx
  800ba2:	eb ea                	jmp    800b8e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ba4:	0f b6 c1             	movzbl %cl,%eax
  800ba7:	0f b6 db             	movzbl %bl,%ebx
  800baa:	29 d8                	sub    %ebx,%eax
  800bac:	eb 05                	jmp    800bb3 <memcmp+0x35>
	}

	return 0;
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bc0:	89 c2                	mov    %eax,%edx
  800bc2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc5:	39 d0                	cmp    %edx,%eax
  800bc7:	73 09                	jae    800bd2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc9:	38 08                	cmp    %cl,(%eax)
  800bcb:	74 05                	je     800bd2 <memfind+0x1b>
	for (; s < ends; s++)
  800bcd:	83 c0 01             	add    $0x1,%eax
  800bd0:	eb f3                	jmp    800bc5 <memfind+0xe>
			break;
	return (void *) s;
}
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be0:	eb 03                	jmp    800be5 <strtol+0x11>
		s++;
  800be2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800be5:	0f b6 01             	movzbl (%ecx),%eax
  800be8:	3c 20                	cmp    $0x20,%al
  800bea:	74 f6                	je     800be2 <strtol+0xe>
  800bec:	3c 09                	cmp    $0x9,%al
  800bee:	74 f2                	je     800be2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bf0:	3c 2b                	cmp    $0x2b,%al
  800bf2:	74 2a                	je     800c1e <strtol+0x4a>
	int neg = 0;
  800bf4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf9:	3c 2d                	cmp    $0x2d,%al
  800bfb:	74 2b                	je     800c28 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bfd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c03:	75 0f                	jne    800c14 <strtol+0x40>
  800c05:	80 39 30             	cmpb   $0x30,(%ecx)
  800c08:	74 28                	je     800c32 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c0a:	85 db                	test   %ebx,%ebx
  800c0c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c11:	0f 44 d8             	cmove  %eax,%ebx
  800c14:	b8 00 00 00 00       	mov    $0x0,%eax
  800c19:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c1c:	eb 50                	jmp    800c6e <strtol+0x9a>
		s++;
  800c1e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c21:	bf 00 00 00 00       	mov    $0x0,%edi
  800c26:	eb d5                	jmp    800bfd <strtol+0x29>
		s++, neg = 1;
  800c28:	83 c1 01             	add    $0x1,%ecx
  800c2b:	bf 01 00 00 00       	mov    $0x1,%edi
  800c30:	eb cb                	jmp    800bfd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c32:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c36:	74 0e                	je     800c46 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c38:	85 db                	test   %ebx,%ebx
  800c3a:	75 d8                	jne    800c14 <strtol+0x40>
		s++, base = 8;
  800c3c:	83 c1 01             	add    $0x1,%ecx
  800c3f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c44:	eb ce                	jmp    800c14 <strtol+0x40>
		s += 2, base = 16;
  800c46:	83 c1 02             	add    $0x2,%ecx
  800c49:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c4e:	eb c4                	jmp    800c14 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c50:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c53:	89 f3                	mov    %esi,%ebx
  800c55:	80 fb 19             	cmp    $0x19,%bl
  800c58:	77 29                	ja     800c83 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c5a:	0f be d2             	movsbl %dl,%edx
  800c5d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c60:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c63:	7d 30                	jge    800c95 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c65:	83 c1 01             	add    $0x1,%ecx
  800c68:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c6c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c6e:	0f b6 11             	movzbl (%ecx),%edx
  800c71:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c74:	89 f3                	mov    %esi,%ebx
  800c76:	80 fb 09             	cmp    $0x9,%bl
  800c79:	77 d5                	ja     800c50 <strtol+0x7c>
			dig = *s - '0';
  800c7b:	0f be d2             	movsbl %dl,%edx
  800c7e:	83 ea 30             	sub    $0x30,%edx
  800c81:	eb dd                	jmp    800c60 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c83:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c86:	89 f3                	mov    %esi,%ebx
  800c88:	80 fb 19             	cmp    $0x19,%bl
  800c8b:	77 08                	ja     800c95 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c8d:	0f be d2             	movsbl %dl,%edx
  800c90:	83 ea 37             	sub    $0x37,%edx
  800c93:	eb cb                	jmp    800c60 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c99:	74 05                	je     800ca0 <strtol+0xcc>
		*endptr = (char *) s;
  800c9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ca0:	89 c2                	mov    %eax,%edx
  800ca2:	f7 da                	neg    %edx
  800ca4:	85 ff                	test   %edi,%edi
  800ca6:	0f 45 c2             	cmovne %edx,%eax
}
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5f                   	pop    %edi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	57                   	push   %edi
  800cb2:	56                   	push   %esi
  800cb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbf:	89 c3                	mov    %eax,%ebx
  800cc1:	89 c7                	mov    %eax,%edi
  800cc3:	89 c6                	mov    %eax,%esi
  800cc5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <sys_cgetc>:

int
sys_cgetc(void)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cdc:	89 d1                	mov    %edx,%ecx
  800cde:	89 d3                	mov    %edx,%ebx
  800ce0:	89 d7                	mov    %edx,%edi
  800ce2:	89 d6                	mov    %edx,%esi
  800ce4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	b8 03 00 00 00       	mov    $0x3,%eax
  800d01:	89 cb                	mov    %ecx,%ebx
  800d03:	89 cf                	mov    %ecx,%edi
  800d05:	89 ce                	mov    %ecx,%esi
  800d07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	7f 08                	jg     800d15 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d15:	83 ec 0c             	sub    $0xc,%esp
  800d18:	50                   	push   %eax
  800d19:	6a 03                	push   $0x3
  800d1b:	68 80 2a 80 00       	push   $0x802a80
  800d20:	6a 33                	push   $0x33
  800d22:	68 9d 2a 80 00       	push   $0x802a9d
  800d27:	e8 63 f4 ff ff       	call   80018f <_panic>

00800d2c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d32:	ba 00 00 00 00       	mov    $0x0,%edx
  800d37:	b8 02 00 00 00       	mov    $0x2,%eax
  800d3c:	89 d1                	mov    %edx,%ecx
  800d3e:	89 d3                	mov    %edx,%ebx
  800d40:	89 d7                	mov    %edx,%edi
  800d42:	89 d6                	mov    %edx,%esi
  800d44:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <sys_yield>:

void
sys_yield(void)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d51:	ba 00 00 00 00       	mov    $0x0,%edx
  800d56:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d5b:	89 d1                	mov    %edx,%ecx
  800d5d:	89 d3                	mov    %edx,%ebx
  800d5f:	89 d7                	mov    %edx,%edi
  800d61:	89 d6                	mov    %edx,%esi
  800d63:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d73:	be 00 00 00 00       	mov    $0x0,%esi
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7e:	b8 04 00 00 00       	mov    $0x4,%eax
  800d83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d86:	89 f7                	mov    %esi,%edi
  800d88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7f 08                	jg     800d96 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	83 ec 0c             	sub    $0xc,%esp
  800d99:	50                   	push   %eax
  800d9a:	6a 04                	push   $0x4
  800d9c:	68 80 2a 80 00       	push   $0x802a80
  800da1:	6a 33                	push   $0x33
  800da3:	68 9d 2a 80 00       	push   $0x802a9d
  800da8:	e8 e2 f3 ff ff       	call   80018f <_panic>

00800dad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbc:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc7:	8b 75 18             	mov    0x18(%ebp),%esi
  800dca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7f 08                	jg     800dd8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	50                   	push   %eax
  800ddc:	6a 05                	push   $0x5
  800dde:	68 80 2a 80 00       	push   $0x802a80
  800de3:	6a 33                	push   $0x33
  800de5:	68 9d 2a 80 00       	push   $0x802a9d
  800dea:	e8 a0 f3 ff ff       	call   80018f <_panic>

00800def <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	b8 06 00 00 00       	mov    $0x6,%eax
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 06                	push   $0x6
  800e20:	68 80 2a 80 00       	push   $0x802a80
  800e25:	6a 33                	push   $0x33
  800e27:	68 9d 2a 80 00       	push   $0x802a9d
  800e2c:	e8 5e f3 ff ff       	call   80018f <_panic>

00800e31 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e47:	89 cb                	mov    %ecx,%ebx
  800e49:	89 cf                	mov    %ecx,%edi
  800e4b:	89 ce                	mov    %ecx,%esi
  800e4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	7f 08                	jg     800e5b <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	50                   	push   %eax
  800e5f:	6a 0b                	push   $0xb
  800e61:	68 80 2a 80 00       	push   $0x802a80
  800e66:	6a 33                	push   $0x33
  800e68:	68 9d 2a 80 00       	push   $0x802a9d
  800e6d:	e8 1d f3 ff ff       	call   80018f <_panic>

00800e72 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	57                   	push   %edi
  800e76:	56                   	push   %esi
  800e77:	53                   	push   %ebx
  800e78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	b8 08 00 00 00       	mov    $0x8,%eax
  800e8b:	89 df                	mov    %ebx,%edi
  800e8d:	89 de                	mov    %ebx,%esi
  800e8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	7f 08                	jg     800e9d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	50                   	push   %eax
  800ea1:	6a 08                	push   $0x8
  800ea3:	68 80 2a 80 00       	push   $0x802a80
  800ea8:	6a 33                	push   $0x33
  800eaa:	68 9d 2a 80 00       	push   $0x802a9d
  800eaf:	e8 db f2 ff ff       	call   80018f <_panic>

00800eb4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	b8 09 00 00 00       	mov    $0x9,%eax
  800ecd:	89 df                	mov    %ebx,%edi
  800ecf:	89 de                	mov    %ebx,%esi
  800ed1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	7f 08                	jg     800edf <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	50                   	push   %eax
  800ee3:	6a 09                	push   $0x9
  800ee5:	68 80 2a 80 00       	push   $0x802a80
  800eea:	6a 33                	push   $0x33
  800eec:	68 9d 2a 80 00       	push   $0x802a9d
  800ef1:	e8 99 f2 ff ff       	call   80018f <_panic>

00800ef6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
  800efc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f04:	8b 55 08             	mov    0x8(%ebp),%edx
  800f07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f0f:	89 df                	mov    %ebx,%edi
  800f11:	89 de                	mov    %ebx,%esi
  800f13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f15:	85 c0                	test   %eax,%eax
  800f17:	7f 08                	jg     800f21 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f21:	83 ec 0c             	sub    $0xc,%esp
  800f24:	50                   	push   %eax
  800f25:	6a 0a                	push   $0xa
  800f27:	68 80 2a 80 00       	push   $0x802a80
  800f2c:	6a 33                	push   $0x33
  800f2e:	68 9d 2a 80 00       	push   $0x802a9d
  800f33:	e8 57 f2 ff ff       	call   80018f <_panic>

00800f38 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f44:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f49:	be 00 00 00 00       	mov    $0x0,%esi
  800f4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f51:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f54:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
  800f61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f71:	89 cb                	mov    %ecx,%ebx
  800f73:	89 cf                	mov    %ecx,%edi
  800f75:	89 ce                	mov    %ecx,%esi
  800f77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	7f 08                	jg     800f85 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f85:	83 ec 0c             	sub    $0xc,%esp
  800f88:	50                   	push   %eax
  800f89:	6a 0e                	push   $0xe
  800f8b:	68 80 2a 80 00       	push   $0x802a80
  800f90:	6a 33                	push   $0x33
  800f92:	68 9d 2a 80 00       	push   $0x802a9d
  800f97:	e8 f3 f1 ff ff       	call   80018f <_panic>

00800f9c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  800faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fad:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fb2:	89 df                	mov    %ebx,%edi
  800fb4:	89 de                	mov    %ebx,%esi
  800fb6:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd0:	89 cb                	mov    %ecx,%ebx
  800fd2:	89 cf                	mov    %ecx,%edi
  800fd4:	89 ce                	mov    %ecx,%esi
  800fd6:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	05 00 00 00 30       	add    $0x30000000,%eax
  800fe8:	c1 e8 0c             	shr    $0xc,%eax
}
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ff8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ffd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    

00801004 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80100c:	89 c2                	mov    %eax,%edx
  80100e:	c1 ea 16             	shr    $0x16,%edx
  801011:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801018:	f6 c2 01             	test   $0x1,%dl
  80101b:	74 2d                	je     80104a <fd_alloc+0x46>
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	c1 ea 0c             	shr    $0xc,%edx
  801022:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801029:	f6 c2 01             	test   $0x1,%dl
  80102c:	74 1c                	je     80104a <fd_alloc+0x46>
  80102e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801033:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801038:	75 d2                	jne    80100c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801043:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801048:	eb 0a                	jmp    801054 <fd_alloc+0x50>
			*fd_store = fd;
  80104a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80104f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80105c:	83 f8 1f             	cmp    $0x1f,%eax
  80105f:	77 30                	ja     801091 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801061:	c1 e0 0c             	shl    $0xc,%eax
  801064:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801069:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80106f:	f6 c2 01             	test   $0x1,%dl
  801072:	74 24                	je     801098 <fd_lookup+0x42>
  801074:	89 c2                	mov    %eax,%edx
  801076:	c1 ea 0c             	shr    $0xc,%edx
  801079:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801080:	f6 c2 01             	test   $0x1,%dl
  801083:	74 1a                	je     80109f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801085:	8b 55 0c             	mov    0xc(%ebp),%edx
  801088:	89 02                	mov    %eax,(%edx)
	return 0;
  80108a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    
		return -E_INVAL;
  801091:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801096:	eb f7                	jmp    80108f <fd_lookup+0x39>
		return -E_INVAL;
  801098:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109d:	eb f0                	jmp    80108f <fd_lookup+0x39>
  80109f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a4:	eb e9                	jmp    80108f <fd_lookup+0x39>

008010a6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010af:	ba 28 2b 80 00       	mov    $0x802b28,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8010b4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010b9:	39 08                	cmp    %ecx,(%eax)
  8010bb:	74 33                	je     8010f0 <dev_lookup+0x4a>
  8010bd:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010c0:	8b 02                	mov    (%edx),%eax
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	75 f3                	jne    8010b9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8010cb:	8b 40 48             	mov    0x48(%eax),%eax
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	51                   	push   %ecx
  8010d2:	50                   	push   %eax
  8010d3:	68 ac 2a 80 00       	push   $0x802aac
  8010d8:	e8 8d f1 ff ff       	call   80026a <cprintf>
	*dev = 0;
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    
			*dev = devtab[i];
  8010f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fa:	eb f2                	jmp    8010ee <dev_lookup+0x48>

008010fc <fd_close>:
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	57                   	push   %edi
  801100:	56                   	push   %esi
  801101:	53                   	push   %ebx
  801102:	83 ec 24             	sub    $0x24,%esp
  801105:	8b 75 08             	mov    0x8(%ebp),%esi
  801108:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80110b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80110e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801115:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801118:	50                   	push   %eax
  801119:	e8 38 ff ff ff       	call   801056 <fd_lookup>
  80111e:	89 c3                	mov    %eax,%ebx
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	78 05                	js     80112c <fd_close+0x30>
	    || fd != fd2)
  801127:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80112a:	74 16                	je     801142 <fd_close+0x46>
		return (must_exist ? r : 0);
  80112c:	89 f8                	mov    %edi,%eax
  80112e:	84 c0                	test   %al,%al
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
  801135:	0f 44 d8             	cmove  %eax,%ebx
}
  801138:	89 d8                	mov    %ebx,%eax
  80113a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113d:	5b                   	pop    %ebx
  80113e:	5e                   	pop    %esi
  80113f:	5f                   	pop    %edi
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801142:	83 ec 08             	sub    $0x8,%esp
  801145:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801148:	50                   	push   %eax
  801149:	ff 36                	pushl  (%esi)
  80114b:	e8 56 ff ff ff       	call   8010a6 <dev_lookup>
  801150:	89 c3                	mov    %eax,%ebx
  801152:	83 c4 10             	add    $0x10,%esp
  801155:	85 c0                	test   %eax,%eax
  801157:	78 1a                	js     801173 <fd_close+0x77>
		if (dev->dev_close)
  801159:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80115c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80115f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801164:	85 c0                	test   %eax,%eax
  801166:	74 0b                	je     801173 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	56                   	push   %esi
  80116c:	ff d0                	call   *%eax
  80116e:	89 c3                	mov    %eax,%ebx
  801170:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801173:	83 ec 08             	sub    $0x8,%esp
  801176:	56                   	push   %esi
  801177:	6a 00                	push   $0x0
  801179:	e8 71 fc ff ff       	call   800def <sys_page_unmap>
	return r;
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	eb b5                	jmp    801138 <fd_close+0x3c>

00801183 <close>:

int
close(int fdnum)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801189:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80118c:	50                   	push   %eax
  80118d:	ff 75 08             	pushl  0x8(%ebp)
  801190:	e8 c1 fe ff ff       	call   801056 <fd_lookup>
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	79 02                	jns    80119e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    
		return fd_close(fd, 1);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	6a 01                	push   $0x1
  8011a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a6:	e8 51 ff ff ff       	call   8010fc <fd_close>
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	eb ec                	jmp    80119c <close+0x19>

008011b0 <close_all>:

void
close_all(void)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	53                   	push   %ebx
  8011b4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011b7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011bc:	83 ec 0c             	sub    $0xc,%esp
  8011bf:	53                   	push   %ebx
  8011c0:	e8 be ff ff ff       	call   801183 <close>
	for (i = 0; i < MAXFD; i++)
  8011c5:	83 c3 01             	add    $0x1,%ebx
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	83 fb 20             	cmp    $0x20,%ebx
  8011ce:	75 ec                	jne    8011bc <close_all+0xc>
}
  8011d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    

008011d5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	57                   	push   %edi
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
  8011db:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e1:	50                   	push   %eax
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	e8 6c fe ff ff       	call   801056 <fd_lookup>
  8011ea:	89 c3                	mov    %eax,%ebx
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	0f 88 81 00 00 00    	js     801278 <dup+0xa3>
		return r;
	close(newfdnum);
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	e8 81 ff ff ff       	call   801183 <close>

	newfd = INDEX2FD(newfdnum);
  801202:	8b 75 0c             	mov    0xc(%ebp),%esi
  801205:	c1 e6 0c             	shl    $0xc,%esi
  801208:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80120e:	83 c4 04             	add    $0x4,%esp
  801211:	ff 75 e4             	pushl  -0x1c(%ebp)
  801214:	e8 d4 fd ff ff       	call   800fed <fd2data>
  801219:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80121b:	89 34 24             	mov    %esi,(%esp)
  80121e:	e8 ca fd ff ff       	call   800fed <fd2data>
  801223:	83 c4 10             	add    $0x10,%esp
  801226:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801228:	89 d8                	mov    %ebx,%eax
  80122a:	c1 e8 16             	shr    $0x16,%eax
  80122d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801234:	a8 01                	test   $0x1,%al
  801236:	74 11                	je     801249 <dup+0x74>
  801238:	89 d8                	mov    %ebx,%eax
  80123a:	c1 e8 0c             	shr    $0xc,%eax
  80123d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801244:	f6 c2 01             	test   $0x1,%dl
  801247:	75 39                	jne    801282 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801249:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80124c:	89 d0                	mov    %edx,%eax
  80124e:	c1 e8 0c             	shr    $0xc,%eax
  801251:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801258:	83 ec 0c             	sub    $0xc,%esp
  80125b:	25 07 0e 00 00       	and    $0xe07,%eax
  801260:	50                   	push   %eax
  801261:	56                   	push   %esi
  801262:	6a 00                	push   $0x0
  801264:	52                   	push   %edx
  801265:	6a 00                	push   $0x0
  801267:	e8 41 fb ff ff       	call   800dad <sys_page_map>
  80126c:	89 c3                	mov    %eax,%ebx
  80126e:	83 c4 20             	add    $0x20,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	78 31                	js     8012a6 <dup+0xd1>
		goto err;

	return newfdnum;
  801275:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801278:	89 d8                	mov    %ebx,%eax
  80127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801282:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	25 07 0e 00 00       	and    $0xe07,%eax
  801291:	50                   	push   %eax
  801292:	57                   	push   %edi
  801293:	6a 00                	push   $0x0
  801295:	53                   	push   %ebx
  801296:	6a 00                	push   $0x0
  801298:	e8 10 fb ff ff       	call   800dad <sys_page_map>
  80129d:	89 c3                	mov    %eax,%ebx
  80129f:	83 c4 20             	add    $0x20,%esp
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	79 a3                	jns    801249 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	56                   	push   %esi
  8012aa:	6a 00                	push   $0x0
  8012ac:	e8 3e fb ff ff       	call   800def <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012b1:	83 c4 08             	add    $0x8,%esp
  8012b4:	57                   	push   %edi
  8012b5:	6a 00                	push   $0x0
  8012b7:	e8 33 fb ff ff       	call   800def <sys_page_unmap>
	return r;
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	eb b7                	jmp    801278 <dup+0xa3>

008012c1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	53                   	push   %ebx
  8012c5:	83 ec 1c             	sub    $0x1c,%esp
  8012c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ce:	50                   	push   %eax
  8012cf:	53                   	push   %ebx
  8012d0:	e8 81 fd ff ff       	call   801056 <fd_lookup>
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	78 3f                	js     80131b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e2:	50                   	push   %eax
  8012e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e6:	ff 30                	pushl  (%eax)
  8012e8:	e8 b9 fd ff ff       	call   8010a6 <dev_lookup>
  8012ed:	83 c4 10             	add    $0x10,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	78 27                	js     80131b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f7:	8b 42 08             	mov    0x8(%edx),%eax
  8012fa:	83 e0 03             	and    $0x3,%eax
  8012fd:	83 f8 01             	cmp    $0x1,%eax
  801300:	74 1e                	je     801320 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801305:	8b 40 08             	mov    0x8(%eax),%eax
  801308:	85 c0                	test   %eax,%eax
  80130a:	74 35                	je     801341 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80130c:	83 ec 04             	sub    $0x4,%esp
  80130f:	ff 75 10             	pushl  0x10(%ebp)
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	52                   	push   %edx
  801316:	ff d0                	call   *%eax
  801318:	83 c4 10             	add    $0x10,%esp
}
  80131b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801320:	a1 04 40 80 00       	mov    0x804004,%eax
  801325:	8b 40 48             	mov    0x48(%eax),%eax
  801328:	83 ec 04             	sub    $0x4,%esp
  80132b:	53                   	push   %ebx
  80132c:	50                   	push   %eax
  80132d:	68 ed 2a 80 00       	push   $0x802aed
  801332:	e8 33 ef ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133f:	eb da                	jmp    80131b <read+0x5a>
		return -E_NOT_SUPP;
  801341:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801346:	eb d3                	jmp    80131b <read+0x5a>

00801348 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	57                   	push   %edi
  80134c:	56                   	push   %esi
  80134d:	53                   	push   %ebx
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	8b 7d 08             	mov    0x8(%ebp),%edi
  801354:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801357:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135c:	39 f3                	cmp    %esi,%ebx
  80135e:	73 23                	jae    801383 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801360:	83 ec 04             	sub    $0x4,%esp
  801363:	89 f0                	mov    %esi,%eax
  801365:	29 d8                	sub    %ebx,%eax
  801367:	50                   	push   %eax
  801368:	89 d8                	mov    %ebx,%eax
  80136a:	03 45 0c             	add    0xc(%ebp),%eax
  80136d:	50                   	push   %eax
  80136e:	57                   	push   %edi
  80136f:	e8 4d ff ff ff       	call   8012c1 <read>
		if (m < 0)
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	85 c0                	test   %eax,%eax
  801379:	78 06                	js     801381 <readn+0x39>
			return m;
		if (m == 0)
  80137b:	74 06                	je     801383 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80137d:	01 c3                	add    %eax,%ebx
  80137f:	eb db                	jmp    80135c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801381:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801383:	89 d8                	mov    %ebx,%eax
  801385:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801388:	5b                   	pop    %ebx
  801389:	5e                   	pop    %esi
  80138a:	5f                   	pop    %edi
  80138b:	5d                   	pop    %ebp
  80138c:	c3                   	ret    

0080138d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	53                   	push   %ebx
  801391:	83 ec 1c             	sub    $0x1c,%esp
  801394:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801397:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139a:	50                   	push   %eax
  80139b:	53                   	push   %ebx
  80139c:	e8 b5 fc ff ff       	call   801056 <fd_lookup>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 3a                	js     8013e2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a8:	83 ec 08             	sub    $0x8,%esp
  8013ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ae:	50                   	push   %eax
  8013af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b2:	ff 30                	pushl  (%eax)
  8013b4:	e8 ed fc ff ff       	call   8010a6 <dev_lookup>
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 22                	js     8013e2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013c7:	74 1e                	je     8013e7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8013cf:	85 d2                	test   %edx,%edx
  8013d1:	74 35                	je     801408 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	ff 75 10             	pushl  0x10(%ebp)
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	50                   	push   %eax
  8013dd:	ff d2                	call   *%edx
  8013df:	83 c4 10             	add    $0x10,%esp
}
  8013e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e7:	a1 04 40 80 00       	mov    0x804004,%eax
  8013ec:	8b 40 48             	mov    0x48(%eax),%eax
  8013ef:	83 ec 04             	sub    $0x4,%esp
  8013f2:	53                   	push   %ebx
  8013f3:	50                   	push   %eax
  8013f4:	68 09 2b 80 00       	push   $0x802b09
  8013f9:	e8 6c ee ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801406:	eb da                	jmp    8013e2 <write+0x55>
		return -E_NOT_SUPP;
  801408:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140d:	eb d3                	jmp    8013e2 <write+0x55>

0080140f <seek>:

int
seek(int fdnum, off_t offset)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801415:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801418:	50                   	push   %eax
  801419:	ff 75 08             	pushl  0x8(%ebp)
  80141c:	e8 35 fc ff ff       	call   801056 <fd_lookup>
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	78 0e                	js     801436 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	53                   	push   %ebx
  80143c:	83 ec 1c             	sub    $0x1c,%esp
  80143f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801442:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801445:	50                   	push   %eax
  801446:	53                   	push   %ebx
  801447:	e8 0a fc ff ff       	call   801056 <fd_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 37                	js     80148a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801459:	50                   	push   %eax
  80145a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145d:	ff 30                	pushl  (%eax)
  80145f:	e8 42 fc ff ff       	call   8010a6 <dev_lookup>
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 1f                	js     80148a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801472:	74 1b                	je     80148f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801477:	8b 52 18             	mov    0x18(%edx),%edx
  80147a:	85 d2                	test   %edx,%edx
  80147c:	74 32                	je     8014b0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	ff 75 0c             	pushl  0xc(%ebp)
  801484:	50                   	push   %eax
  801485:	ff d2                	call   *%edx
  801487:	83 c4 10             	add    $0x10,%esp
}
  80148a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80148f:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801494:	8b 40 48             	mov    0x48(%eax),%eax
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	53                   	push   %ebx
  80149b:	50                   	push   %eax
  80149c:	68 cc 2a 80 00       	push   $0x802acc
  8014a1:	e8 c4 ed ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ae:	eb da                	jmp    80148a <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b5:	eb d3                	jmp    80148a <ftruncate+0x52>

008014b7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 1c             	sub    $0x1c,%esp
  8014be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c4:	50                   	push   %eax
  8014c5:	ff 75 08             	pushl  0x8(%ebp)
  8014c8:	e8 89 fb ff ff       	call   801056 <fd_lookup>
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	78 4b                	js     80151f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014da:	50                   	push   %eax
  8014db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014de:	ff 30                	pushl  (%eax)
  8014e0:	e8 c1 fb ff ff       	call   8010a6 <dev_lookup>
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	78 33                	js     80151f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ef:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014f3:	74 2f                	je     801524 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014f5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014f8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014ff:	00 00 00 
	stat->st_isdir = 0;
  801502:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801509:	00 00 00 
	stat->st_dev = dev;
  80150c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801512:	83 ec 08             	sub    $0x8,%esp
  801515:	53                   	push   %ebx
  801516:	ff 75 f0             	pushl  -0x10(%ebp)
  801519:	ff 50 14             	call   *0x14(%eax)
  80151c:	83 c4 10             	add    $0x10,%esp
}
  80151f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801522:	c9                   	leave  
  801523:	c3                   	ret    
		return -E_NOT_SUPP;
  801524:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801529:	eb f4                	jmp    80151f <fstat+0x68>

0080152b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	56                   	push   %esi
  80152f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801530:	83 ec 08             	sub    $0x8,%esp
  801533:	6a 00                	push   $0x0
  801535:	ff 75 08             	pushl  0x8(%ebp)
  801538:	e8 e7 01 00 00       	call   801724 <open>
  80153d:	89 c3                	mov    %eax,%ebx
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	78 1b                	js     801561 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801546:	83 ec 08             	sub    $0x8,%esp
  801549:	ff 75 0c             	pushl  0xc(%ebp)
  80154c:	50                   	push   %eax
  80154d:	e8 65 ff ff ff       	call   8014b7 <fstat>
  801552:	89 c6                	mov    %eax,%esi
	close(fd);
  801554:	89 1c 24             	mov    %ebx,(%esp)
  801557:	e8 27 fc ff ff       	call   801183 <close>
	return r;
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	89 f3                	mov    %esi,%ebx
}
  801561:	89 d8                	mov    %ebx,%eax
  801563:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801566:	5b                   	pop    %ebx
  801567:	5e                   	pop    %esi
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
  80156f:	89 c6                	mov    %eax,%esi
  801571:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801573:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80157a:	74 27                	je     8015a3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80157c:	6a 07                	push   $0x7
  80157e:	68 00 50 80 00       	push   $0x805000
  801583:	56                   	push   %esi
  801584:	ff 35 00 40 80 00    	pushl  0x804000
  80158a:	e8 51 0d 00 00       	call   8022e0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80158f:	83 c4 0c             	add    $0xc,%esp
  801592:	6a 00                	push   $0x0
  801594:	53                   	push   %ebx
  801595:	6a 00                	push   $0x0
  801597:	e8 dd 0c 00 00       	call   802279 <ipc_recv>
}
  80159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159f:	5b                   	pop    %ebx
  8015a0:	5e                   	pop    %esi
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015a3:	83 ec 0c             	sub    $0xc,%esp
  8015a6:	6a 01                	push   $0x1
  8015a8:	e8 7c 0d 00 00       	call   802329 <ipc_find_env>
  8015ad:	a3 00 40 80 00       	mov    %eax,0x804000
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	eb c5                	jmp    80157c <fsipc+0x12>

008015b7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d5:	b8 02 00 00 00       	mov    $0x2,%eax
  8015da:	e8 8b ff ff ff       	call   80156a <fsipc>
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <devfile_flush>:
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ed:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8015fc:	e8 69 ff ff ff       	call   80156a <fsipc>
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <devfile_stat>:
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	53                   	push   %ebx
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8b 40 0c             	mov    0xc(%eax),%eax
  801613:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801618:	ba 00 00 00 00       	mov    $0x0,%edx
  80161d:	b8 05 00 00 00       	mov    $0x5,%eax
  801622:	e8 43 ff ff ff       	call   80156a <fsipc>
  801627:	85 c0                	test   %eax,%eax
  801629:	78 2c                	js     801657 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	68 00 50 80 00       	push   $0x805000
  801633:	53                   	push   %ebx
  801634:	e8 3f f3 ff ff       	call   800978 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801639:	a1 80 50 80 00       	mov    0x805080,%eax
  80163e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801644:	a1 84 50 80 00       	mov    0x805084,%eax
  801649:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <devfile_write>:
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 0c             	sub    $0xc,%esp
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801665:	8b 55 08             	mov    0x8(%ebp),%edx
  801668:	8b 52 0c             	mov    0xc(%edx),%edx
  80166b:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801671:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801676:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80167b:	0f 47 c2             	cmova  %edx,%eax
  80167e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801683:	50                   	push   %eax
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	68 08 50 80 00       	push   $0x805008
  80168c:	e8 75 f4 ff ff       	call   800b06 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801691:	ba 00 00 00 00       	mov    $0x0,%edx
  801696:	b8 04 00 00 00       	mov    $0x4,%eax
  80169b:	e8 ca fe ff ff       	call   80156a <fsipc>
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <devfile_read>:
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	56                   	push   %esi
  8016a6:	53                   	push   %ebx
  8016a7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016b5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c0:	b8 03 00 00 00       	mov    $0x3,%eax
  8016c5:	e8 a0 fe ff ff       	call   80156a <fsipc>
  8016ca:	89 c3                	mov    %eax,%ebx
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 1f                	js     8016ef <devfile_read+0x4d>
	assert(r <= n);
  8016d0:	39 f0                	cmp    %esi,%eax
  8016d2:	77 24                	ja     8016f8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016d4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d9:	7f 33                	jg     80170e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	50                   	push   %eax
  8016df:	68 00 50 80 00       	push   $0x805000
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	e8 1a f4 ff ff       	call   800b06 <memmove>
	return r;
  8016ec:	83 c4 10             	add    $0x10,%esp
}
  8016ef:	89 d8                	mov    %ebx,%eax
  8016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    
	assert(r <= n);
  8016f8:	68 38 2b 80 00       	push   $0x802b38
  8016fd:	68 3f 2b 80 00       	push   $0x802b3f
  801702:	6a 7c                	push   $0x7c
  801704:	68 54 2b 80 00       	push   $0x802b54
  801709:	e8 81 ea ff ff       	call   80018f <_panic>
	assert(r <= PGSIZE);
  80170e:	68 5f 2b 80 00       	push   $0x802b5f
  801713:	68 3f 2b 80 00       	push   $0x802b3f
  801718:	6a 7d                	push   $0x7d
  80171a:	68 54 2b 80 00       	push   $0x802b54
  80171f:	e8 6b ea ff ff       	call   80018f <_panic>

00801724 <open>:
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	56                   	push   %esi
  801728:	53                   	push   %ebx
  801729:	83 ec 1c             	sub    $0x1c,%esp
  80172c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80172f:	56                   	push   %esi
  801730:	e8 0a f2 ff ff       	call   80093f <strlen>
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80173d:	7f 6c                	jg     8017ab <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80173f:	83 ec 0c             	sub    $0xc,%esp
  801742:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801745:	50                   	push   %eax
  801746:	e8 b9 f8 ff ff       	call   801004 <fd_alloc>
  80174b:	89 c3                	mov    %eax,%ebx
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	85 c0                	test   %eax,%eax
  801752:	78 3c                	js     801790 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	56                   	push   %esi
  801758:	68 00 50 80 00       	push   $0x805000
  80175d:	e8 16 f2 ff ff       	call   800978 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801762:	8b 45 0c             	mov    0xc(%ebp),%eax
  801765:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80176a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176d:	b8 01 00 00 00       	mov    $0x1,%eax
  801772:	e8 f3 fd ff ff       	call   80156a <fsipc>
  801777:	89 c3                	mov    %eax,%ebx
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	85 c0                	test   %eax,%eax
  80177e:	78 19                	js     801799 <open+0x75>
	return fd2num(fd);
  801780:	83 ec 0c             	sub    $0xc,%esp
  801783:	ff 75 f4             	pushl  -0xc(%ebp)
  801786:	e8 52 f8 ff ff       	call   800fdd <fd2num>
  80178b:	89 c3                	mov    %eax,%ebx
  80178d:	83 c4 10             	add    $0x10,%esp
}
  801790:	89 d8                	mov    %ebx,%eax
  801792:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801795:	5b                   	pop    %ebx
  801796:	5e                   	pop    %esi
  801797:	5d                   	pop    %ebp
  801798:	c3                   	ret    
		fd_close(fd, 0);
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	6a 00                	push   $0x0
  80179e:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a1:	e8 56 f9 ff ff       	call   8010fc <fd_close>
		return r;
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	eb e5                	jmp    801790 <open+0x6c>
		return -E_BAD_PATH;
  8017ab:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017b0:	eb de                	jmp    801790 <open+0x6c>

008017b2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8017c2:	e8 a3 fd ff ff       	call   80156a <fsipc>
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	57                   	push   %edi
  8017cd:	56                   	push   %esi
  8017ce:	53                   	push   %ebx
  8017cf:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8017d5:	6a 00                	push   $0x0
  8017d7:	ff 75 08             	pushl  0x8(%ebp)
  8017da:	e8 45 ff ff ff       	call   801724 <open>
  8017df:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	0f 88 ff 04 00 00    	js     801cef <spawn+0x526>
  8017f0:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 00 02 00 00       	push   $0x200
  8017fa:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801800:	50                   	push   %eax
  801801:	51                   	push   %ecx
  801802:	e8 41 fb ff ff       	call   801348 <readn>
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80180f:	75 60                	jne    801871 <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  801811:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801818:	45 4c 46 
  80181b:	75 54                	jne    801871 <spawn+0xa8>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80181d:	b8 07 00 00 00       	mov    $0x7,%eax
  801822:	cd 30                	int    $0x30
  801824:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80182a:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801830:	85 c0                	test   %eax,%eax
  801832:	0f 88 ab 04 00 00    	js     801ce3 <spawn+0x51a>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801838:	25 ff 03 00 00       	and    $0x3ff,%eax
  80183d:	8d 34 c0             	lea    (%eax,%eax,8),%esi
  801840:	c1 e6 04             	shl    $0x4,%esi
  801843:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801849:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80184f:	b9 11 00 00 00       	mov    $0x11,%ecx
  801854:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801856:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80185c:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801862:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801867:	be 00 00 00 00       	mov    $0x0,%esi
  80186c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80186f:	eb 4b                	jmp    8018bc <spawn+0xf3>
		close(fd);
  801871:	83 ec 0c             	sub    $0xc,%esp
  801874:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80187a:	e8 04 f9 ff ff       	call   801183 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80187f:	83 c4 0c             	add    $0xc,%esp
  801882:	68 7f 45 4c 46       	push   $0x464c457f
  801887:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80188d:	68 6b 2b 80 00       	push   $0x802b6b
  801892:	e8 d3 e9 ff ff       	call   80026a <cprintf>
		return -E_NOT_EXEC;
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8018a1:	ff ff ff 
  8018a4:	e9 46 04 00 00       	jmp    801cef <spawn+0x526>
		string_size += strlen(argv[argc]) + 1;
  8018a9:	83 ec 0c             	sub    $0xc,%esp
  8018ac:	50                   	push   %eax
  8018ad:	e8 8d f0 ff ff       	call   80093f <strlen>
  8018b2:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8018b6:	83 c3 01             	add    $0x1,%ebx
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8018c3:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	75 df                	jne    8018a9 <spawn+0xe0>
  8018ca:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8018d0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8018d6:	bf 00 10 40 00       	mov    $0x401000,%edi
  8018db:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8018dd:	89 fa                	mov    %edi,%edx
  8018df:	83 e2 fc             	and    $0xfffffffc,%edx
  8018e2:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8018e9:	29 c2                	sub    %eax,%edx
  8018eb:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8018f1:	8d 42 f8             	lea    -0x8(%edx),%eax
  8018f4:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8018f9:	0f 86 13 04 00 00    	jbe    801d12 <spawn+0x549>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	6a 07                	push   $0x7
  801904:	68 00 00 40 00       	push   $0x400000
  801909:	6a 00                	push   $0x0
  80190b:	e8 5a f4 ff ff       	call   800d6a <sys_page_alloc>
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	85 c0                	test   %eax,%eax
  801915:	0f 88 fc 03 00 00    	js     801d17 <spawn+0x54e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80191b:	be 00 00 00 00       	mov    $0x0,%esi
  801920:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801926:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801929:	eb 30                	jmp    80195b <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  80192b:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801931:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801937:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80193a:	83 ec 08             	sub    $0x8,%esp
  80193d:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801940:	57                   	push   %edi
  801941:	e8 32 f0 ff ff       	call   800978 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801946:	83 c4 04             	add    $0x4,%esp
  801949:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80194c:	e8 ee ef ff ff       	call   80093f <strlen>
  801951:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801955:	83 c6 01             	add    $0x1,%esi
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801961:	7f c8                	jg     80192b <spawn+0x162>
	}
	argv_store[argc] = 0;
  801963:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801969:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80196f:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801976:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80197c:	0f 85 86 00 00 00    	jne    801a08 <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801982:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801988:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  80198e:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801991:	89 d0                	mov    %edx,%eax
  801993:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801999:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80199c:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8019a1:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8019a7:	83 ec 0c             	sub    $0xc,%esp
  8019aa:	6a 07                	push   $0x7
  8019ac:	68 00 d0 bf ee       	push   $0xeebfd000
  8019b1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8019b7:	68 00 00 40 00       	push   $0x400000
  8019bc:	6a 00                	push   $0x0
  8019be:	e8 ea f3 ff ff       	call   800dad <sys_page_map>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 20             	add    $0x20,%esp
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	0f 88 4f 03 00 00    	js     801d1f <spawn+0x556>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	68 00 00 40 00       	push   $0x400000
  8019d8:	6a 00                	push   $0x0
  8019da:	e8 10 f4 ff ff       	call   800def <sys_page_unmap>
  8019df:	89 c3                	mov    %eax,%ebx
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	0f 88 33 03 00 00    	js     801d1f <spawn+0x556>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8019ec:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8019f2:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019f9:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801a00:	00 00 00 
  801a03:	e9 4f 01 00 00       	jmp    801b57 <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a08:	68 f8 2b 80 00       	push   $0x802bf8
  801a0d:	68 3f 2b 80 00       	push   $0x802b3f
  801a12:	68 f2 00 00 00       	push   $0xf2
  801a17:	68 85 2b 80 00       	push   $0x802b85
  801a1c:	e8 6e e7 ff ff       	call   80018f <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a21:	83 ec 04             	sub    $0x4,%esp
  801a24:	6a 07                	push   $0x7
  801a26:	68 00 00 40 00       	push   $0x400000
  801a2b:	6a 00                	push   $0x0
  801a2d:	e8 38 f3 ff ff       	call   800d6a <sys_page_alloc>
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	85 c0                	test   %eax,%eax
  801a37:	0f 88 c0 02 00 00    	js     801cfd <spawn+0x534>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801a46:	01 f0                	add    %esi,%eax
  801a48:	50                   	push   %eax
  801a49:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a4f:	e8 bb f9 ff ff       	call   80140f <seek>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	85 c0                	test   %eax,%eax
  801a59:	0f 88 a5 02 00 00    	js     801d04 <spawn+0x53b>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801a68:	29 f0                	sub    %esi,%eax
  801a6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a6f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801a74:	0f 47 c1             	cmova  %ecx,%eax
  801a77:	50                   	push   %eax
  801a78:	68 00 00 40 00       	push   $0x400000
  801a7d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a83:	e8 c0 f8 ff ff       	call   801348 <readn>
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	0f 88 78 02 00 00    	js     801d0b <spawn+0x542>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a9c:	53                   	push   %ebx
  801a9d:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801aa3:	68 00 00 40 00       	push   $0x400000
  801aa8:	6a 00                	push   $0x0
  801aaa:	e8 fe f2 ff ff       	call   800dad <sys_page_map>
  801aaf:	83 c4 20             	add    $0x20,%esp
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 7c                	js     801b32 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	68 00 00 40 00       	push   $0x400000
  801abe:	6a 00                	push   $0x0
  801ac0:	e8 2a f3 ff ff       	call   800def <sys_page_unmap>
  801ac5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801ac8:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801ace:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ad4:	89 fe                	mov    %edi,%esi
  801ad6:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801adc:	76 69                	jbe    801b47 <spawn+0x37e>
		if (i >= filesz) {
  801ade:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801ae4:	0f 87 37 ff ff ff    	ja     801a21 <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801aea:	83 ec 04             	sub    $0x4,%esp
  801aed:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801af3:	53                   	push   %ebx
  801af4:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801afa:	e8 6b f2 ff ff       	call   800d6a <sys_page_alloc>
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	79 c2                	jns    801ac8 <spawn+0x2ff>
  801b06:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801b08:	83 ec 0c             	sub    $0xc,%esp
  801b0b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b11:	e8 d5 f1 ff ff       	call   800ceb <sys_env_destroy>
	close(fd);
  801b16:	83 c4 04             	add    $0x4,%esp
  801b19:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b1f:	e8 5f f6 ff ff       	call   801183 <close>
	return r;
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801b2d:	e9 bd 01 00 00       	jmp    801cef <spawn+0x526>
				panic("spawn: sys_page_map data: %e", r);
  801b32:	50                   	push   %eax
  801b33:	68 91 2b 80 00       	push   $0x802b91
  801b38:	68 25 01 00 00       	push   $0x125
  801b3d:	68 85 2b 80 00       	push   $0x802b85
  801b42:	e8 48 e6 ff ff       	call   80018f <_panic>
  801b47:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b4d:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801b54:	83 c6 20             	add    $0x20,%esi
  801b57:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801b5e:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801b64:	7e 6d                	jle    801bd3 <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  801b66:	83 3e 01             	cmpl   $0x1,(%esi)
  801b69:	75 e2                	jne    801b4d <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b6b:	8b 46 18             	mov    0x18(%esi),%eax
  801b6e:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801b71:	83 f8 01             	cmp    $0x1,%eax
  801b74:	19 c0                	sbb    %eax,%eax
  801b76:	83 e0 fe             	and    $0xfffffffe,%eax
  801b79:	83 c0 07             	add    $0x7,%eax
  801b7c:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b82:	8b 4e 04             	mov    0x4(%esi),%ecx
  801b85:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801b8b:	8b 56 10             	mov    0x10(%esi),%edx
  801b8e:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801b94:	8b 7e 14             	mov    0x14(%esi),%edi
  801b97:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801b9d:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ba7:	74 1a                	je     801bc3 <spawn+0x3fa>
		va -= i;
  801ba9:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801bab:	01 c7                	add    %eax,%edi
  801bad:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801bb3:	01 c2                	add    %eax,%edx
  801bb5:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801bbb:	29 c1                	sub    %eax,%ecx
  801bbd:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801bc3:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc8:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801bce:	e9 01 ff ff ff       	jmp    801ad4 <spawn+0x30b>
	close(fd);
  801bd3:	83 ec 0c             	sub    $0xc,%esp
  801bd6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bdc:	e8 a2 f5 ff ff       	call   801183 <close>
  801be1:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	uint8_t *addr;
	int r;

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  801be4:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801be9:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801bef:	eb 0e                	jmp    801bff <spawn+0x436>
  801bf1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bf7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801bfd:	74 6f                	je     801c6e <spawn+0x4a5>
		if ((uvpd[PDX(addr)] & PTE_P) 
  801bff:	89 d8                	mov    %ebx,%eax
  801c01:	c1 e8 16             	shr    $0x16,%eax
  801c04:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c0b:	a8 01                	test   $0x1,%al
  801c0d:	74 e2                	je     801bf1 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_P) 
  801c0f:	89 d8                	mov    %ebx,%eax
  801c11:	c1 e8 0c             	shr    $0xc,%eax
  801c14:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c1b:	f6 c2 01             	test   $0x1,%dl
  801c1e:	74 d1                	je     801bf1 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_U) 
  801c20:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c27:	f6 c2 04             	test   $0x4,%dl
  801c2a:	74 c5                	je     801bf1 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801c2c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c33:	f6 c6 04             	test   $0x4,%dh
  801c36:	74 b9                	je     801bf1 <spawn+0x428>
			if((r = sys_page_map(0, (void*)addr, child, (void*)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801c38:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c3f:	83 ec 0c             	sub    $0xc,%esp
  801c42:	25 07 0e 00 00       	and    $0xe07,%eax
  801c47:	50                   	push   %eax
  801c48:	53                   	push   %ebx
  801c49:	56                   	push   %esi
  801c4a:	53                   	push   %ebx
  801c4b:	6a 00                	push   $0x0
  801c4d:	e8 5b f1 ff ff       	call   800dad <sys_page_map>
  801c52:	83 c4 20             	add    $0x20,%esp
  801c55:	85 c0                	test   %eax,%eax
  801c57:	79 98                	jns    801bf1 <spawn+0x428>
				panic("copy_shared_pages: %e\n", r);
  801c59:	50                   	push   %eax
  801c5a:	68 ae 2b 80 00       	push   $0x802bae
  801c5f:	68 3a 01 00 00       	push   $0x13a
  801c64:	68 85 2b 80 00       	push   $0x802b85
  801c69:	e8 21 e5 ff ff       	call   80018f <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801c6e:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801c75:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801c78:	83 ec 08             	sub    $0x8,%esp
  801c7b:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801c81:	50                   	push   %eax
  801c82:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c88:	e8 27 f2 ff ff       	call   800eb4 <sys_env_set_trapframe>
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 25                	js     801cb9 <spawn+0x4f0>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801c94:	83 ec 08             	sub    $0x8,%esp
  801c97:	6a 02                	push   $0x2
  801c99:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c9f:	e8 ce f1 ff ff       	call   800e72 <sys_env_set_status>
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	78 23                	js     801cce <spawn+0x505>
	return child;
  801cab:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801cb1:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801cb7:	eb 36                	jmp    801cef <spawn+0x526>
		panic("sys_env_set_trapframe: %e", r);
  801cb9:	50                   	push   %eax
  801cba:	68 c5 2b 80 00       	push   $0x802bc5
  801cbf:	68 86 00 00 00       	push   $0x86
  801cc4:	68 85 2b 80 00       	push   $0x802b85
  801cc9:	e8 c1 e4 ff ff       	call   80018f <_panic>
		panic("sys_env_set_status: %e", r);
  801cce:	50                   	push   %eax
  801ccf:	68 df 2b 80 00       	push   $0x802bdf
  801cd4:	68 89 00 00 00       	push   $0x89
  801cd9:	68 85 2b 80 00       	push   $0x802b85
  801cde:	e8 ac e4 ff ff       	call   80018f <_panic>
		return r;
  801ce3:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ce9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801cef:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    
  801cfd:	89 c7                	mov    %eax,%edi
  801cff:	e9 04 fe ff ff       	jmp    801b08 <spawn+0x33f>
  801d04:	89 c7                	mov    %eax,%edi
  801d06:	e9 fd fd ff ff       	jmp    801b08 <spawn+0x33f>
  801d0b:	89 c7                	mov    %eax,%edi
  801d0d:	e9 f6 fd ff ff       	jmp    801b08 <spawn+0x33f>
		return -E_NO_MEM;
  801d12:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  801d17:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801d1d:	eb d0                	jmp    801cef <spawn+0x526>
	sys_page_unmap(0, UTEMP);
  801d1f:	83 ec 08             	sub    $0x8,%esp
  801d22:	68 00 00 40 00       	push   $0x400000
  801d27:	6a 00                	push   $0x0
  801d29:	e8 c1 f0 ff ff       	call   800def <sys_page_unmap>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801d37:	eb b6                	jmp    801cef <spawn+0x526>

00801d39 <spawnl>:
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	57                   	push   %edi
  801d3d:	56                   	push   %esi
  801d3e:	53                   	push   %ebx
  801d3f:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801d42:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801d4a:	8d 4a 04             	lea    0x4(%edx),%ecx
  801d4d:	83 3a 00             	cmpl   $0x0,(%edx)
  801d50:	74 07                	je     801d59 <spawnl+0x20>
		argc++;
  801d52:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801d55:	89 ca                	mov    %ecx,%edx
  801d57:	eb f1                	jmp    801d4a <spawnl+0x11>
	const char *argv[argc+2];
  801d59:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801d60:	83 e2 f0             	and    $0xfffffff0,%edx
  801d63:	29 d4                	sub    %edx,%esp
  801d65:	8d 54 24 03          	lea    0x3(%esp),%edx
  801d69:	c1 ea 02             	shr    $0x2,%edx
  801d6c:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801d73:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d78:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801d7f:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801d86:	00 
	va_start(vl, arg0);
  801d87:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801d8a:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d91:	eb 0b                	jmp    801d9e <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801d93:	83 c0 01             	add    $0x1,%eax
  801d96:	8b 39                	mov    (%ecx),%edi
  801d98:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801d9b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801d9e:	39 d0                	cmp    %edx,%eax
  801da0:	75 f1                	jne    801d93 <spawnl+0x5a>
	return spawn(prog, argv);
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	56                   	push   %esi
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	e8 1b fa ff ff       	call   8017c9 <spawn>
}
  801dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db1:	5b                   	pop    %ebx
  801db2:	5e                   	pop    %esi
  801db3:	5f                   	pop    %edi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    

00801db6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	56                   	push   %esi
  801dba:	53                   	push   %ebx
  801dbb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dbe:	83 ec 0c             	sub    $0xc,%esp
  801dc1:	ff 75 08             	pushl  0x8(%ebp)
  801dc4:	e8 24 f2 ff ff       	call   800fed <fd2data>
  801dc9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dcb:	83 c4 08             	add    $0x8,%esp
  801dce:	68 20 2c 80 00       	push   $0x802c20
  801dd3:	53                   	push   %ebx
  801dd4:	e8 9f eb ff ff       	call   800978 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dd9:	8b 46 04             	mov    0x4(%esi),%eax
  801ddc:	2b 06                	sub    (%esi),%eax
  801dde:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801de4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801deb:	00 00 00 
	stat->st_dev = &devpipe;
  801dee:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801df5:	30 80 00 
	return 0;
}
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    

00801e04 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	53                   	push   %ebx
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e0e:	53                   	push   %ebx
  801e0f:	6a 00                	push   $0x0
  801e11:	e8 d9 ef ff ff       	call   800def <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e16:	89 1c 24             	mov    %ebx,(%esp)
  801e19:	e8 cf f1 ff ff       	call   800fed <fd2data>
  801e1e:	83 c4 08             	add    $0x8,%esp
  801e21:	50                   	push   %eax
  801e22:	6a 00                	push   $0x0
  801e24:	e8 c6 ef ff ff       	call   800def <sys_page_unmap>
}
  801e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <_pipeisclosed>:
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 1c             	sub    $0x1c,%esp
  801e37:	89 c7                	mov    %eax,%edi
  801e39:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e3b:	a1 04 40 80 00       	mov    0x804004,%eax
  801e40:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	57                   	push   %edi
  801e47:	e8 1c 05 00 00       	call   802368 <pageref>
  801e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e4f:	89 34 24             	mov    %esi,(%esp)
  801e52:	e8 11 05 00 00       	call   802368 <pageref>
		nn = thisenv->env_runs;
  801e57:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e5d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	39 cb                	cmp    %ecx,%ebx
  801e65:	74 1b                	je     801e82 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e67:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e6a:	75 cf                	jne    801e3b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e6c:	8b 42 58             	mov    0x58(%edx),%eax
  801e6f:	6a 01                	push   $0x1
  801e71:	50                   	push   %eax
  801e72:	53                   	push   %ebx
  801e73:	68 27 2c 80 00       	push   $0x802c27
  801e78:	e8 ed e3 ff ff       	call   80026a <cprintf>
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	eb b9                	jmp    801e3b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e82:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e85:	0f 94 c0             	sete   %al
  801e88:	0f b6 c0             	movzbl %al,%eax
}
  801e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5e                   	pop    %esi
  801e90:	5f                   	pop    %edi
  801e91:	5d                   	pop    %ebp
  801e92:	c3                   	ret    

00801e93 <devpipe_write>:
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	57                   	push   %edi
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
  801e99:	83 ec 28             	sub    $0x28,%esp
  801e9c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e9f:	56                   	push   %esi
  801ea0:	e8 48 f1 ff ff       	call   800fed <fd2data>
  801ea5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	bf 00 00 00 00       	mov    $0x0,%edi
  801eaf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eb2:	74 4f                	je     801f03 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801eb4:	8b 43 04             	mov    0x4(%ebx),%eax
  801eb7:	8b 0b                	mov    (%ebx),%ecx
  801eb9:	8d 51 20             	lea    0x20(%ecx),%edx
  801ebc:	39 d0                	cmp    %edx,%eax
  801ebe:	72 14                	jb     801ed4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ec0:	89 da                	mov    %ebx,%edx
  801ec2:	89 f0                	mov    %esi,%eax
  801ec4:	e8 65 ff ff ff       	call   801e2e <_pipeisclosed>
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	75 3b                	jne    801f08 <devpipe_write+0x75>
			sys_yield();
  801ecd:	e8 79 ee ff ff       	call   800d4b <sys_yield>
  801ed2:	eb e0                	jmp    801eb4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ed4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ed7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801edb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ede:	89 c2                	mov    %eax,%edx
  801ee0:	c1 fa 1f             	sar    $0x1f,%edx
  801ee3:	89 d1                	mov    %edx,%ecx
  801ee5:	c1 e9 1b             	shr    $0x1b,%ecx
  801ee8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eeb:	83 e2 1f             	and    $0x1f,%edx
  801eee:	29 ca                	sub    %ecx,%edx
  801ef0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ef4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ef8:	83 c0 01             	add    $0x1,%eax
  801efb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801efe:	83 c7 01             	add    $0x1,%edi
  801f01:	eb ac                	jmp    801eaf <devpipe_write+0x1c>
	return i;
  801f03:	8b 45 10             	mov    0x10(%ebp),%eax
  801f06:	eb 05                	jmp    801f0d <devpipe_write+0x7a>
				return 0;
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    

00801f15 <devpipe_read>:
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	57                   	push   %edi
  801f19:	56                   	push   %esi
  801f1a:	53                   	push   %ebx
  801f1b:	83 ec 18             	sub    $0x18,%esp
  801f1e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f21:	57                   	push   %edi
  801f22:	e8 c6 f0 ff ff       	call   800fed <fd2data>
  801f27:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	be 00 00 00 00       	mov    $0x0,%esi
  801f31:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f34:	75 14                	jne    801f4a <devpipe_read+0x35>
	return i;
  801f36:	8b 45 10             	mov    0x10(%ebp),%eax
  801f39:	eb 02                	jmp    801f3d <devpipe_read+0x28>
				return i;
  801f3b:	89 f0                	mov    %esi,%eax
}
  801f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f40:	5b                   	pop    %ebx
  801f41:	5e                   	pop    %esi
  801f42:	5f                   	pop    %edi
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    
			sys_yield();
  801f45:	e8 01 ee ff ff       	call   800d4b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f4a:	8b 03                	mov    (%ebx),%eax
  801f4c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f4f:	75 18                	jne    801f69 <devpipe_read+0x54>
			if (i > 0)
  801f51:	85 f6                	test   %esi,%esi
  801f53:	75 e6                	jne    801f3b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f55:	89 da                	mov    %ebx,%edx
  801f57:	89 f8                	mov    %edi,%eax
  801f59:	e8 d0 fe ff ff       	call   801e2e <_pipeisclosed>
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	74 e3                	je     801f45 <devpipe_read+0x30>
				return 0;
  801f62:	b8 00 00 00 00       	mov    $0x0,%eax
  801f67:	eb d4                	jmp    801f3d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f69:	99                   	cltd   
  801f6a:	c1 ea 1b             	shr    $0x1b,%edx
  801f6d:	01 d0                	add    %edx,%eax
  801f6f:	83 e0 1f             	and    $0x1f,%eax
  801f72:	29 d0                	sub    %edx,%eax
  801f74:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f7c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f7f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f82:	83 c6 01             	add    $0x1,%esi
  801f85:	eb aa                	jmp    801f31 <devpipe_read+0x1c>

00801f87 <pipe>:
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	56                   	push   %esi
  801f8b:	53                   	push   %ebx
  801f8c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f92:	50                   	push   %eax
  801f93:	e8 6c f0 ff ff       	call   801004 <fd_alloc>
  801f98:	89 c3                	mov    %eax,%ebx
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 88 23 01 00 00    	js     8020c8 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	68 07 04 00 00       	push   $0x407
  801fad:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb0:	6a 00                	push   $0x0
  801fb2:	e8 b3 ed ff ff       	call   800d6a <sys_page_alloc>
  801fb7:	89 c3                	mov    %eax,%ebx
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	0f 88 04 01 00 00    	js     8020c8 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fca:	50                   	push   %eax
  801fcb:	e8 34 f0 ff ff       	call   801004 <fd_alloc>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	0f 88 db 00 00 00    	js     8020b8 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fdd:	83 ec 04             	sub    $0x4,%esp
  801fe0:	68 07 04 00 00       	push   $0x407
  801fe5:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 7b ed ff ff       	call   800d6a <sys_page_alloc>
  801fef:	89 c3                	mov    %eax,%ebx
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	0f 88 bc 00 00 00    	js     8020b8 <pipe+0x131>
	va = fd2data(fd0);
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	ff 75 f4             	pushl  -0xc(%ebp)
  802002:	e8 e6 ef ff ff       	call   800fed <fd2data>
  802007:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802009:	83 c4 0c             	add    $0xc,%esp
  80200c:	68 07 04 00 00       	push   $0x407
  802011:	50                   	push   %eax
  802012:	6a 00                	push   $0x0
  802014:	e8 51 ed ff ff       	call   800d6a <sys_page_alloc>
  802019:	89 c3                	mov    %eax,%ebx
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	85 c0                	test   %eax,%eax
  802020:	0f 88 82 00 00 00    	js     8020a8 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	ff 75 f0             	pushl  -0x10(%ebp)
  80202c:	e8 bc ef ff ff       	call   800fed <fd2data>
  802031:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802038:	50                   	push   %eax
  802039:	6a 00                	push   $0x0
  80203b:	56                   	push   %esi
  80203c:	6a 00                	push   $0x0
  80203e:	e8 6a ed ff ff       	call   800dad <sys_page_map>
  802043:	89 c3                	mov    %eax,%ebx
  802045:	83 c4 20             	add    $0x20,%esp
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 4e                	js     80209a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80204c:	a1 20 30 80 00       	mov    0x803020,%eax
  802051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802054:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802059:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802060:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802063:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802068:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	ff 75 f4             	pushl  -0xc(%ebp)
  802075:	e8 63 ef ff ff       	call   800fdd <fd2num>
  80207a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80207d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80207f:	83 c4 04             	add    $0x4,%esp
  802082:	ff 75 f0             	pushl  -0x10(%ebp)
  802085:	e8 53 ef ff ff       	call   800fdd <fd2num>
  80208a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	bb 00 00 00 00       	mov    $0x0,%ebx
  802098:	eb 2e                	jmp    8020c8 <pipe+0x141>
	sys_page_unmap(0, va);
  80209a:	83 ec 08             	sub    $0x8,%esp
  80209d:	56                   	push   %esi
  80209e:	6a 00                	push   $0x0
  8020a0:	e8 4a ed ff ff       	call   800def <sys_page_unmap>
  8020a5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020a8:	83 ec 08             	sub    $0x8,%esp
  8020ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ae:	6a 00                	push   $0x0
  8020b0:	e8 3a ed ff ff       	call   800def <sys_page_unmap>
  8020b5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8020be:	6a 00                	push   $0x0
  8020c0:	e8 2a ed ff ff       	call   800def <sys_page_unmap>
  8020c5:	83 c4 10             	add    $0x10,%esp
}
  8020c8:	89 d8                	mov    %ebx,%eax
  8020ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cd:	5b                   	pop    %ebx
  8020ce:	5e                   	pop    %esi
  8020cf:	5d                   	pop    %ebp
  8020d0:	c3                   	ret    

008020d1 <pipeisclosed>:
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020da:	50                   	push   %eax
  8020db:	ff 75 08             	pushl  0x8(%ebp)
  8020de:	e8 73 ef ff ff       	call   801056 <fd_lookup>
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	78 18                	js     802102 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020ea:	83 ec 0c             	sub    $0xc,%esp
  8020ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f0:	e8 f8 ee ff ff       	call   800fed <fd2data>
	return _pipeisclosed(fd, p);
  8020f5:	89 c2                	mov    %eax,%edx
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	e8 2f fd ff ff       	call   801e2e <_pipeisclosed>
  8020ff:	83 c4 10             	add    $0x10,%esp
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	c3                   	ret    

0080210a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802110:	68 3f 2c 80 00       	push   $0x802c3f
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	e8 5b e8 ff ff       	call   800978 <strcpy>
	return 0;
}
  80211d:	b8 00 00 00 00       	mov    $0x0,%eax
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <devcons_write>:
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	57                   	push   %edi
  802128:	56                   	push   %esi
  802129:	53                   	push   %ebx
  80212a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802130:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802135:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80213b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80213e:	73 31                	jae    802171 <devcons_write+0x4d>
		m = n - tot;
  802140:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802143:	29 f3                	sub    %esi,%ebx
  802145:	83 fb 7f             	cmp    $0x7f,%ebx
  802148:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80214d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	53                   	push   %ebx
  802154:	89 f0                	mov    %esi,%eax
  802156:	03 45 0c             	add    0xc(%ebp),%eax
  802159:	50                   	push   %eax
  80215a:	57                   	push   %edi
  80215b:	e8 a6 e9 ff ff       	call   800b06 <memmove>
		sys_cputs(buf, m);
  802160:	83 c4 08             	add    $0x8,%esp
  802163:	53                   	push   %ebx
  802164:	57                   	push   %edi
  802165:	e8 44 eb ff ff       	call   800cae <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80216a:	01 de                	add    %ebx,%esi
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	eb ca                	jmp    80213b <devcons_write+0x17>
}
  802171:	89 f0                	mov    %esi,%eax
  802173:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802176:	5b                   	pop    %ebx
  802177:	5e                   	pop    %esi
  802178:	5f                   	pop    %edi
  802179:	5d                   	pop    %ebp
  80217a:	c3                   	ret    

0080217b <devcons_read>:
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 08             	sub    $0x8,%esp
  802181:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80218a:	74 21                	je     8021ad <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80218c:	e8 3b eb ff ff       	call   800ccc <sys_cgetc>
  802191:	85 c0                	test   %eax,%eax
  802193:	75 07                	jne    80219c <devcons_read+0x21>
		sys_yield();
  802195:	e8 b1 eb ff ff       	call   800d4b <sys_yield>
  80219a:	eb f0                	jmp    80218c <devcons_read+0x11>
	if (c < 0)
  80219c:	78 0f                	js     8021ad <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80219e:	83 f8 04             	cmp    $0x4,%eax
  8021a1:	74 0c                	je     8021af <devcons_read+0x34>
	*(char*)vbuf = c;
  8021a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a6:	88 02                	mov    %al,(%edx)
	return 1;
  8021a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    
		return 0;
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b4:	eb f7                	jmp    8021ad <devcons_read+0x32>

008021b6 <cputchar>:
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021c2:	6a 01                	push   $0x1
  8021c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c7:	50                   	push   %eax
  8021c8:	e8 e1 ea ff ff       	call   800cae <sys_cputs>
}
  8021cd:	83 c4 10             	add    $0x10,%esp
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <getchar>:
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021d8:	6a 01                	push   $0x1
  8021da:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021dd:	50                   	push   %eax
  8021de:	6a 00                	push   $0x0
  8021e0:	e8 dc f0 ff ff       	call   8012c1 <read>
	if (r < 0)
  8021e5:	83 c4 10             	add    $0x10,%esp
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	78 06                	js     8021f2 <getchar+0x20>
	if (r < 1)
  8021ec:	74 06                	je     8021f4 <getchar+0x22>
	return c;
  8021ee:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    
		return -E_EOF;
  8021f4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021f9:	eb f7                	jmp    8021f2 <getchar+0x20>

008021fb <iscons>:
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802201:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802204:	50                   	push   %eax
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	e8 49 ee ff ff       	call   801056 <fd_lookup>
  80220d:	83 c4 10             	add    $0x10,%esp
  802210:	85 c0                	test   %eax,%eax
  802212:	78 11                	js     802225 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80221d:	39 10                	cmp    %edx,(%eax)
  80221f:	0f 94 c0             	sete   %al
  802222:	0f b6 c0             	movzbl %al,%eax
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <opencons>:
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80222d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802230:	50                   	push   %eax
  802231:	e8 ce ed ff ff       	call   801004 <fd_alloc>
  802236:	83 c4 10             	add    $0x10,%esp
  802239:	85 c0                	test   %eax,%eax
  80223b:	78 3a                	js     802277 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	68 07 04 00 00       	push   $0x407
  802245:	ff 75 f4             	pushl  -0xc(%ebp)
  802248:	6a 00                	push   $0x0
  80224a:	e8 1b eb ff ff       	call   800d6a <sys_page_alloc>
  80224f:	83 c4 10             	add    $0x10,%esp
  802252:	85 c0                	test   %eax,%eax
  802254:	78 21                	js     802277 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80225f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80226b:	83 ec 0c             	sub    $0xc,%esp
  80226e:	50                   	push   %eax
  80226f:	e8 69 ed ff ff       	call   800fdd <fd2num>
  802274:	83 c4 10             	add    $0x10,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	56                   	push   %esi
  80227d:	53                   	push   %ebx
  80227e:	8b 75 08             	mov    0x8(%ebp),%esi
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  802287:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802289:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80228e:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	50                   	push   %eax
  802295:	e8 c1 ec ff ff       	call   800f5b <sys_ipc_recv>
	if (from_env_store)
  80229a:	83 c4 10             	add    $0x10,%esp
  80229d:	85 f6                	test   %esi,%esi
  80229f:	74 14                	je     8022b5 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  8022a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 09                	js     8022b3 <ipc_recv+0x3a>
  8022aa:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8022b0:	8b 52 78             	mov    0x78(%edx),%edx
  8022b3:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  8022b5:	85 db                	test   %ebx,%ebx
  8022b7:	74 14                	je     8022cd <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  8022b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	78 09                	js     8022cb <ipc_recv+0x52>
  8022c2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8022c8:	8b 52 7c             	mov    0x7c(%edx),%edx
  8022cb:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	78 08                	js     8022d9 <ipc_recv+0x60>
  8022d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8022d6:	8b 40 74             	mov    0x74(%eax),%eax
}
  8022d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5d                   	pop    %ebp
  8022df:	c3                   	ret    

008022e0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	83 ec 08             	sub    $0x8,%esp
  8022e6:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022f0:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8022f3:	ff 75 14             	pushl  0x14(%ebp)
  8022f6:	50                   	push   %eax
  8022f7:	ff 75 0c             	pushl  0xc(%ebp)
  8022fa:	ff 75 08             	pushl  0x8(%ebp)
  8022fd:	e8 36 ec ff ff       	call   800f38 <sys_ipc_try_send>
  802302:	83 c4 10             	add    $0x10,%esp
  802305:	85 c0                	test   %eax,%eax
  802307:	78 02                	js     80230b <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  802309:	c9                   	leave  
  80230a:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  80230b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80230e:	75 07                	jne    802317 <ipc_send+0x37>
		sys_yield();
  802310:	e8 36 ea ff ff       	call   800d4b <sys_yield>
}
  802315:	eb f2                	jmp    802309 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  802317:	50                   	push   %eax
  802318:	68 4b 2c 80 00       	push   $0x802c4b
  80231d:	6a 3c                	push   $0x3c
  80231f:	68 5f 2c 80 00       	push   $0x802c5f
  802324:	e8 66 de ff ff       	call   80018f <_panic>

00802329 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80232f:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  802334:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802337:	c1 e0 04             	shl    $0x4,%eax
  80233a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80233f:	8b 40 50             	mov    0x50(%eax),%eax
  802342:	39 c8                	cmp    %ecx,%eax
  802344:	74 12                	je     802358 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802346:	83 c2 01             	add    $0x1,%edx
  802349:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80234f:	75 e3                	jne    802334 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802351:	b8 00 00 00 00       	mov    $0x0,%eax
  802356:	eb 0e                	jmp    802366 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802358:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80235b:	c1 e0 04             	shl    $0x4,%eax
  80235e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802363:	8b 40 48             	mov    0x48(%eax),%eax
}
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    

00802368 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80236e:	89 d0                	mov    %edx,%eax
  802370:	c1 e8 16             	shr    $0x16,%eax
  802373:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80237a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80237f:	f6 c1 01             	test   $0x1,%cl
  802382:	74 1d                	je     8023a1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802384:	c1 ea 0c             	shr    $0xc,%edx
  802387:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80238e:	f6 c2 01             	test   $0x1,%dl
  802391:	74 0e                	je     8023a1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802393:	c1 ea 0c             	shr    $0xc,%edx
  802396:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80239d:	ef 
  80239e:	0f b7 c0             	movzwl %ax,%eax
}
  8023a1:	5d                   	pop    %ebp
  8023a2:	c3                   	ret    
  8023a3:	66 90                	xchg   %ax,%ax
  8023a5:	66 90                	xchg   %ax,%ax
  8023a7:	66 90                	xchg   %ax,%ax
  8023a9:	66 90                	xchg   %ax,%ax
  8023ab:	66 90                	xchg   %ax,%ax
  8023ad:	66 90                	xchg   %ax,%ax
  8023af:	90                   	nop

008023b0 <__udivdi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023c7:	85 d2                	test   %edx,%edx
  8023c9:	75 4d                	jne    802418 <__udivdi3+0x68>
  8023cb:	39 f3                	cmp    %esi,%ebx
  8023cd:	76 19                	jbe    8023e8 <__udivdi3+0x38>
  8023cf:	31 ff                	xor    %edi,%edi
  8023d1:	89 e8                	mov    %ebp,%eax
  8023d3:	89 f2                	mov    %esi,%edx
  8023d5:	f7 f3                	div    %ebx
  8023d7:	89 fa                	mov    %edi,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 d9                	mov    %ebx,%ecx
  8023ea:	85 db                	test   %ebx,%ebx
  8023ec:	75 0b                	jne    8023f9 <__udivdi3+0x49>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f3                	div    %ebx
  8023f7:	89 c1                	mov    %eax,%ecx
  8023f9:	31 d2                	xor    %edx,%edx
  8023fb:	89 f0                	mov    %esi,%eax
  8023fd:	f7 f1                	div    %ecx
  8023ff:	89 c6                	mov    %eax,%esi
  802401:	89 e8                	mov    %ebp,%eax
  802403:	89 f7                	mov    %esi,%edi
  802405:	f7 f1                	div    %ecx
  802407:	89 fa                	mov    %edi,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	39 f2                	cmp    %esi,%edx
  80241a:	77 1c                	ja     802438 <__udivdi3+0x88>
  80241c:	0f bd fa             	bsr    %edx,%edi
  80241f:	83 f7 1f             	xor    $0x1f,%edi
  802422:	75 2c                	jne    802450 <__udivdi3+0xa0>
  802424:	39 f2                	cmp    %esi,%edx
  802426:	72 06                	jb     80242e <__udivdi3+0x7e>
  802428:	31 c0                	xor    %eax,%eax
  80242a:	39 eb                	cmp    %ebp,%ebx
  80242c:	77 a9                	ja     8023d7 <__udivdi3+0x27>
  80242e:	b8 01 00 00 00       	mov    $0x1,%eax
  802433:	eb a2                	jmp    8023d7 <__udivdi3+0x27>
  802435:	8d 76 00             	lea    0x0(%esi),%esi
  802438:	31 ff                	xor    %edi,%edi
  80243a:	31 c0                	xor    %eax,%eax
  80243c:	89 fa                	mov    %edi,%edx
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	89 f9                	mov    %edi,%ecx
  802452:	b8 20 00 00 00       	mov    $0x20,%eax
  802457:	29 f8                	sub    %edi,%eax
  802459:	d3 e2                	shl    %cl,%edx
  80245b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80245f:	89 c1                	mov    %eax,%ecx
  802461:	89 da                	mov    %ebx,%edx
  802463:	d3 ea                	shr    %cl,%edx
  802465:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802469:	09 d1                	or     %edx,%ecx
  80246b:	89 f2                	mov    %esi,%edx
  80246d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802471:	89 f9                	mov    %edi,%ecx
  802473:	d3 e3                	shl    %cl,%ebx
  802475:	89 c1                	mov    %eax,%ecx
  802477:	d3 ea                	shr    %cl,%edx
  802479:	89 f9                	mov    %edi,%ecx
  80247b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80247f:	89 eb                	mov    %ebp,%ebx
  802481:	d3 e6                	shl    %cl,%esi
  802483:	89 c1                	mov    %eax,%ecx
  802485:	d3 eb                	shr    %cl,%ebx
  802487:	09 de                	or     %ebx,%esi
  802489:	89 f0                	mov    %esi,%eax
  80248b:	f7 74 24 08          	divl   0x8(%esp)
  80248f:	89 d6                	mov    %edx,%esi
  802491:	89 c3                	mov    %eax,%ebx
  802493:	f7 64 24 0c          	mull   0xc(%esp)
  802497:	39 d6                	cmp    %edx,%esi
  802499:	72 15                	jb     8024b0 <__udivdi3+0x100>
  80249b:	89 f9                	mov    %edi,%ecx
  80249d:	d3 e5                	shl    %cl,%ebp
  80249f:	39 c5                	cmp    %eax,%ebp
  8024a1:	73 04                	jae    8024a7 <__udivdi3+0xf7>
  8024a3:	39 d6                	cmp    %edx,%esi
  8024a5:	74 09                	je     8024b0 <__udivdi3+0x100>
  8024a7:	89 d8                	mov    %ebx,%eax
  8024a9:	31 ff                	xor    %edi,%edi
  8024ab:	e9 27 ff ff ff       	jmp    8023d7 <__udivdi3+0x27>
  8024b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024b3:	31 ff                	xor    %edi,%edi
  8024b5:	e9 1d ff ff ff       	jmp    8023d7 <__udivdi3+0x27>
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <__umoddi3>:
  8024c0:	55                   	push   %ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	53                   	push   %ebx
  8024c4:	83 ec 1c             	sub    $0x1c,%esp
  8024c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024d7:	89 da                	mov    %ebx,%edx
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 43                	jne    802520 <__umoddi3+0x60>
  8024dd:	39 df                	cmp    %ebx,%edi
  8024df:	76 17                	jbe    8024f8 <__umoddi3+0x38>
  8024e1:	89 f0                	mov    %esi,%eax
  8024e3:	f7 f7                	div    %edi
  8024e5:	89 d0                	mov    %edx,%eax
  8024e7:	31 d2                	xor    %edx,%edx
  8024e9:	83 c4 1c             	add    $0x1c,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    
  8024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	89 fd                	mov    %edi,%ebp
  8024fa:	85 ff                	test   %edi,%edi
  8024fc:	75 0b                	jne    802509 <__umoddi3+0x49>
  8024fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802503:	31 d2                	xor    %edx,%edx
  802505:	f7 f7                	div    %edi
  802507:	89 c5                	mov    %eax,%ebp
  802509:	89 d8                	mov    %ebx,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	f7 f5                	div    %ebp
  80250f:	89 f0                	mov    %esi,%eax
  802511:	f7 f5                	div    %ebp
  802513:	89 d0                	mov    %edx,%eax
  802515:	eb d0                	jmp    8024e7 <__umoddi3+0x27>
  802517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80251e:	66 90                	xchg   %ax,%ax
  802520:	89 f1                	mov    %esi,%ecx
  802522:	39 d8                	cmp    %ebx,%eax
  802524:	76 0a                	jbe    802530 <__umoddi3+0x70>
  802526:	89 f0                	mov    %esi,%eax
  802528:	83 c4 1c             	add    $0x1c,%esp
  80252b:	5b                   	pop    %ebx
  80252c:	5e                   	pop    %esi
  80252d:	5f                   	pop    %edi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    
  802530:	0f bd e8             	bsr    %eax,%ebp
  802533:	83 f5 1f             	xor    $0x1f,%ebp
  802536:	75 20                	jne    802558 <__umoddi3+0x98>
  802538:	39 d8                	cmp    %ebx,%eax
  80253a:	0f 82 b0 00 00 00    	jb     8025f0 <__umoddi3+0x130>
  802540:	39 f7                	cmp    %esi,%edi
  802542:	0f 86 a8 00 00 00    	jbe    8025f0 <__umoddi3+0x130>
  802548:	89 c8                	mov    %ecx,%eax
  80254a:	83 c4 1c             	add    $0x1c,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    
  802552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	ba 20 00 00 00       	mov    $0x20,%edx
  80255f:	29 ea                	sub    %ebp,%edx
  802561:	d3 e0                	shl    %cl,%eax
  802563:	89 44 24 08          	mov    %eax,0x8(%esp)
  802567:	89 d1                	mov    %edx,%ecx
  802569:	89 f8                	mov    %edi,%eax
  80256b:	d3 e8                	shr    %cl,%eax
  80256d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802571:	89 54 24 04          	mov    %edx,0x4(%esp)
  802575:	8b 54 24 04          	mov    0x4(%esp),%edx
  802579:	09 c1                	or     %eax,%ecx
  80257b:	89 d8                	mov    %ebx,%eax
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 e9                	mov    %ebp,%ecx
  802583:	d3 e7                	shl    %cl,%edi
  802585:	89 d1                	mov    %edx,%ecx
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258f:	d3 e3                	shl    %cl,%ebx
  802591:	89 c7                	mov    %eax,%edi
  802593:	89 d1                	mov    %edx,%ecx
  802595:	89 f0                	mov    %esi,%eax
  802597:	d3 e8                	shr    %cl,%eax
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	89 fa                	mov    %edi,%edx
  80259d:	d3 e6                	shl    %cl,%esi
  80259f:	09 d8                	or     %ebx,%eax
  8025a1:	f7 74 24 08          	divl   0x8(%esp)
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	89 f3                	mov    %esi,%ebx
  8025a9:	f7 64 24 0c          	mull   0xc(%esp)
  8025ad:	89 c6                	mov    %eax,%esi
  8025af:	89 d7                	mov    %edx,%edi
  8025b1:	39 d1                	cmp    %edx,%ecx
  8025b3:	72 06                	jb     8025bb <__umoddi3+0xfb>
  8025b5:	75 10                	jne    8025c7 <__umoddi3+0x107>
  8025b7:	39 c3                	cmp    %eax,%ebx
  8025b9:	73 0c                	jae    8025c7 <__umoddi3+0x107>
  8025bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025c3:	89 d7                	mov    %edx,%edi
  8025c5:	89 c6                	mov    %eax,%esi
  8025c7:	89 ca                	mov    %ecx,%edx
  8025c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ce:	29 f3                	sub    %esi,%ebx
  8025d0:	19 fa                	sbb    %edi,%edx
  8025d2:	89 d0                	mov    %edx,%eax
  8025d4:	d3 e0                	shl    %cl,%eax
  8025d6:	89 e9                	mov    %ebp,%ecx
  8025d8:	d3 eb                	shr    %cl,%ebx
  8025da:	d3 ea                	shr    %cl,%edx
  8025dc:	09 d8                	or     %ebx,%eax
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	89 da                	mov    %ebx,%edx
  8025f2:	29 fe                	sub    %edi,%esi
  8025f4:	19 c2                	sbb    %eax,%edx
  8025f6:	89 f1                	mov    %esi,%ecx
  8025f8:	89 c8                	mov    %ecx,%eax
  8025fa:	e9 4b ff ff ff       	jmp    80254a <__umoddi3+0x8a>
