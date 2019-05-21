
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 99 01 00 00       	call   8001ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 c0 24 80 00       	push   $0x8024c0
  800043:	e8 a3 1a 00 00       	call   801aeb <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 76 17 00 00       	call   8017d6 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 42 80 00       	push   $0x804220
  80006d:	53                   	push   %ebx
  80006e:	e8 9c 16 00 00       	call   80170f <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 f2 10 00 00       	call   801177 <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 e9 00 00 00    	js     800178 <umain+0x145>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	75 7b                	jne    80010c <umain+0xd9>
		seek(fd, 0);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	6a 00                	push   $0x0
  800096:	53                   	push   %ebx
  800097:	e8 3a 17 00 00       	call   8017d6 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 28 25 80 00 	movl   $0x802528,(%esp)
  8000a3:	e8 58 02 00 00       	call   800300 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 40 80 00       	push   $0x804020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 54 16 00 00       	call   80170f <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 20 40 80 00       	push   $0x804020
  8000cf:	68 20 42 80 00       	push   $0x804220
  8000d4:	e8 3b 0b 00 00       	call   800c14 <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 f2 24 80 00       	push   $0x8024f2
  8000ec:	e8 0f 02 00 00       	call   800300 <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 da 16 00 00       	call   8017d6 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 46 14 00 00       	call   80154a <close>
		exit();
  800104:	e8 0a 01 00 00       	call   800213 <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 c9 1d 00 00       	call   801ede <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 40 80 00       	push   $0x804020
  800122:	53                   	push   %ebx
  800123:	e8 e7 15 00 00       	call   80170f <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 0b 25 80 00       	push   $0x80250b
  80013b:	e8 c0 01 00 00       	call   800300 <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 02 14 00 00       	call   80154a <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800148:	cc                   	int3   

	breakpoint();
}
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    
		panic("open motd: %e", fd);
  800154:	50                   	push   %eax
  800155:	68 c5 24 80 00       	push   $0x8024c5
  80015a:	6a 0c                	push   $0xc
  80015c:	68 d3 24 80 00       	push   $0x8024d3
  800161:	e8 bf 00 00 00       	call   800225 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 e8 24 80 00       	push   $0x8024e8
  80016c:	6a 0f                	push   $0xf
  80016e:	68 d3 24 80 00       	push   $0x8024d3
  800173:	e8 ad 00 00 00       	call   800225 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 a0 2a 80 00       	push   $0x802aa0
  80017e:	6a 12                	push   $0x12
  800180:	68 d3 24 80 00       	push   $0x8024d3
  800185:	e8 9b 00 00 00       	call   800225 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 6c 25 80 00       	push   $0x80256c
  800194:	6a 17                	push   $0x17
  800196:	68 d3 24 80 00       	push   $0x8024d3
  80019b:	e8 85 00 00 00       	call   800225 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 98 25 80 00       	push   $0x802598
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 d3 24 80 00       	push   $0x8024d3
  8001af:	e8 71 00 00 00       	call   800225 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 d0 25 80 00       	push   $0x8025d0
  8001be:	6a 21                	push   $0x21
  8001c0:	68 d3 24 80 00       	push   $0x8024d3
  8001c5:	e8 5b 00 00 00       	call   800225 <_panic>

008001ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d5:	e8 e8 0b 00 00       	call   800dc2 <sys_getenvid>
  8001da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001df:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8001e2:	c1 e0 04             	shl    $0x4,%eax
  8001e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ea:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ef:	85 db                	test   %ebx,%ebx
  8001f1:	7e 07                	jle    8001fa <libmain+0x30>
		binaryname = argv[0];
  8001f3:	8b 06                	mov    (%esi),%eax
  8001f5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	56                   	push   %esi
  8001fe:	53                   	push   %ebx
  8001ff:	e8 2f fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800204:	e8 0a 00 00 00       	call   800213 <exit>
}
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020f:	5b                   	pop    %ebx
  800210:	5e                   	pop    %esi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    

00800213 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800219:	6a 00                	push   $0x0
  80021b:	e8 61 0b 00 00       	call   800d81 <sys_env_destroy>
}
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	c9                   	leave  
  800224:	c3                   	ret    

00800225 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	56                   	push   %esi
  800229:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80022a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800233:	e8 8a 0b 00 00       	call   800dc2 <sys_getenvid>
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	56                   	push   %esi
  800242:	50                   	push   %eax
  800243:	68 00 26 80 00       	push   $0x802600
  800248:	e8 b3 00 00 00       	call   800300 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80024d:	83 c4 18             	add    $0x18,%esp
  800250:	53                   	push   %ebx
  800251:	ff 75 10             	pushl  0x10(%ebp)
  800254:	e8 56 00 00 00       	call   8002af <vcprintf>
	cprintf("\n");
  800259:	c7 04 24 09 25 80 00 	movl   $0x802509,(%esp)
  800260:	e8 9b 00 00 00       	call   800300 <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800268:	cc                   	int3   
  800269:	eb fd                	jmp    800268 <_panic+0x43>

0080026b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	53                   	push   %ebx
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800275:	8b 13                	mov    (%ebx),%edx
  800277:	8d 42 01             	lea    0x1(%edx),%eax
  80027a:	89 03                	mov    %eax,(%ebx)
  80027c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80027f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800283:	3d ff 00 00 00       	cmp    $0xff,%eax
  800288:	74 09                	je     800293 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80028a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80028e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800291:	c9                   	leave  
  800292:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800293:	83 ec 08             	sub    $0x8,%esp
  800296:	68 ff 00 00 00       	push   $0xff
  80029b:	8d 43 08             	lea    0x8(%ebx),%eax
  80029e:	50                   	push   %eax
  80029f:	e8 a0 0a 00 00       	call   800d44 <sys_cputs>
		b->idx = 0;
  8002a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	eb db                	jmp    80028a <putch+0x1f>

008002af <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002bf:	00 00 00 
	b.cnt = 0;
  8002c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002cc:	ff 75 0c             	pushl  0xc(%ebp)
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d8:	50                   	push   %eax
  8002d9:	68 6b 02 80 00       	push   $0x80026b
  8002de:	e8 4a 01 00 00       	call   80042d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e3:	83 c4 08             	add    $0x8,%esp
  8002e6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002ec:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f2:	50                   	push   %eax
  8002f3:	e8 4c 0a 00 00       	call   800d44 <sys_cputs>

	return b.cnt;
}
  8002f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800306:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800309:	50                   	push   %eax
  80030a:	ff 75 08             	pushl  0x8(%ebp)
  80030d:	e8 9d ff ff ff       	call   8002af <vcprintf>
	va_end(ap);

	return cnt;
}
  800312:	c9                   	leave  
  800313:	c3                   	ret    

00800314 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 1c             	sub    $0x1c,%esp
  80031d:	89 c6                	mov    %eax,%esi
  80031f:	89 d7                	mov    %edx,%edi
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	8b 55 0c             	mov    0xc(%ebp),%edx
  800327:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80032a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80032d:	8b 45 10             	mov    0x10(%ebp),%eax
  800330:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800333:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800337:	74 2c                	je     800365 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800339:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800343:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800346:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80034e:	73 43                	jae    800393 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800350:	83 eb 01             	sub    $0x1,%ebx
  800353:	85 db                	test   %ebx,%ebx
  800355:	7e 6c                	jle    8003c3 <printnum+0xaf>
			putch(padc, putdat);
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	57                   	push   %edi
  80035b:	ff 75 18             	pushl  0x18(%ebp)
  80035e:	ff d6                	call   *%esi
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb eb                	jmp    800350 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	6a 20                	push   $0x20
  80036a:	6a 00                	push   $0x0
  80036c:	50                   	push   %eax
  80036d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800370:	ff 75 e0             	pushl  -0x20(%ebp)
  800373:	89 fa                	mov    %edi,%edx
  800375:	89 f0                	mov    %esi,%eax
  800377:	e8 98 ff ff ff       	call   800314 <printnum>
		while (--width > 0)
  80037c:	83 c4 20             	add    $0x20,%esp
  80037f:	83 eb 01             	sub    $0x1,%ebx
  800382:	85 db                	test   %ebx,%ebx
  800384:	7e 65                	jle    8003eb <printnum+0xd7>
			putch(padc, putdat);
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	57                   	push   %edi
  80038a:	6a 20                	push   $0x20
  80038c:	ff d6                	call   *%esi
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	eb ec                	jmp    80037f <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 18             	pushl  0x18(%ebp)
  800399:	83 eb 01             	sub    $0x1,%ebx
  80039c:	53                   	push   %ebx
  80039d:	50                   	push   %eax
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ad:	e8 ae 1e 00 00       	call   802260 <__udivdi3>
  8003b2:	83 c4 18             	add    $0x18,%esp
  8003b5:	52                   	push   %edx
  8003b6:	50                   	push   %eax
  8003b7:	89 fa                	mov    %edi,%edx
  8003b9:	89 f0                	mov    %esi,%eax
  8003bb:	e8 54 ff ff ff       	call   800314 <printnum>
  8003c0:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	57                   	push   %edi
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8003cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003d6:	e8 95 1f 00 00       	call   802370 <__umoddi3>
  8003db:	83 c4 14             	add    $0x14,%esp
  8003de:	0f be 80 23 26 80 00 	movsbl 0x802623(%eax),%eax
  8003e5:	50                   	push   %eax
  8003e6:	ff d6                	call   *%esi
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ee:	5b                   	pop    %ebx
  8003ef:	5e                   	pop    %esi
  8003f0:	5f                   	pop    %edi
  8003f1:	5d                   	pop    %ebp
  8003f2:	c3                   	ret    

008003f3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003fd:	8b 10                	mov    (%eax),%edx
  8003ff:	3b 50 04             	cmp    0x4(%eax),%edx
  800402:	73 0a                	jae    80040e <sprintputch+0x1b>
		*b->buf++ = ch;
  800404:	8d 4a 01             	lea    0x1(%edx),%ecx
  800407:	89 08                	mov    %ecx,(%eax)
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	88 02                	mov    %al,(%edx)
}
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <printfmt>:
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800416:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800419:	50                   	push   %eax
  80041a:	ff 75 10             	pushl  0x10(%ebp)
  80041d:	ff 75 0c             	pushl  0xc(%ebp)
  800420:	ff 75 08             	pushl  0x8(%ebp)
  800423:	e8 05 00 00 00       	call   80042d <vprintfmt>
}
  800428:	83 c4 10             	add    $0x10,%esp
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    

0080042d <vprintfmt>:
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	57                   	push   %edi
  800431:	56                   	push   %esi
  800432:	53                   	push   %ebx
  800433:	83 ec 3c             	sub    $0x3c,%esp
  800436:	8b 75 08             	mov    0x8(%ebp),%esi
  800439:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80043c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043f:	e9 b4 03 00 00       	jmp    8007f8 <vprintfmt+0x3cb>
		padc = ' ';
  800444:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800448:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80044f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800456:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80045d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800464:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8d 47 01             	lea    0x1(%edi),%eax
  80046c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046f:	0f b6 17             	movzbl (%edi),%edx
  800472:	8d 42 dd             	lea    -0x23(%edx),%eax
  800475:	3c 55                	cmp    $0x55,%al
  800477:	0f 87 c8 04 00 00    	ja     800945 <vprintfmt+0x518>
  80047d:	0f b6 c0             	movzbl %al,%eax
  800480:	ff 24 85 00 28 80 00 	jmp    *0x802800(,%eax,4)
  800487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80048a:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800491:	eb d6                	jmp    800469 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800496:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80049a:	eb cd                	jmp    800469 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80049c:	0f b6 d2             	movzbl %dl,%edx
  80049f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8004aa:	eb 0c                	jmp    8004b8 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8004ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004af:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8004b3:	eb b4                	jmp    800469 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8004b5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004bf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004c5:	83 f9 09             	cmp    $0x9,%ecx
  8004c8:	76 eb                	jbe    8004b5 <vprintfmt+0x88>
  8004ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d0:	eb 14                	jmp    8004e6 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8004d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d5:	8b 00                	mov    (%eax),%eax
  8004d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 40 04             	lea    0x4(%eax),%eax
  8004e0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ea:	0f 89 79 ff ff ff    	jns    800469 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8004f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004fd:	e9 67 ff ff ff       	jmp    800469 <vprintfmt+0x3c>
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	85 c0                	test   %eax,%eax
  800507:	ba 00 00 00 00       	mov    $0x0,%edx
  80050c:	0f 49 d0             	cmovns %eax,%edx
  80050f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800512:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800515:	e9 4f ff ff ff       	jmp    800469 <vprintfmt+0x3c>
  80051a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80051d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800524:	e9 40 ff ff ff       	jmp    800469 <vprintfmt+0x3c>
			lflag++;
  800529:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80052c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80052f:	e9 35 ff ff ff       	jmp    800469 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 78 04             	lea    0x4(%eax),%edi
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	ff 30                	pushl  (%eax)
  800540:	ff d6                	call   *%esi
			break;
  800542:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800545:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800548:	e9 a8 02 00 00       	jmp    8007f5 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	8d 78 04             	lea    0x4(%eax),%edi
  800553:	8b 00                	mov    (%eax),%eax
  800555:	99                   	cltd   
  800556:	31 d0                	xor    %edx,%eax
  800558:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055a:	83 f8 0f             	cmp    $0xf,%eax
  80055d:	7f 23                	jg     800582 <vprintfmt+0x155>
  80055f:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  800566:	85 d2                	test   %edx,%edx
  800568:	74 18                	je     800582 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  80056a:	52                   	push   %edx
  80056b:	68 81 2b 80 00       	push   $0x802b81
  800570:	53                   	push   %ebx
  800571:	56                   	push   %esi
  800572:	e8 99 fe ff ff       	call   800410 <printfmt>
  800577:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80057d:	e9 73 02 00 00       	jmp    8007f5 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800582:	50                   	push   %eax
  800583:	68 3b 26 80 00       	push   $0x80263b
  800588:	53                   	push   %ebx
  800589:	56                   	push   %esi
  80058a:	e8 81 fe ff ff       	call   800410 <printfmt>
  80058f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800592:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800595:	e9 5b 02 00 00       	jmp    8007f5 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	83 c0 04             	add    $0x4,%eax
  8005a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005a8:	85 d2                	test   %edx,%edx
  8005aa:	b8 34 26 80 00       	mov    $0x802634,%eax
  8005af:	0f 45 c2             	cmovne %edx,%eax
  8005b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b9:	7e 06                	jle    8005c1 <vprintfmt+0x194>
  8005bb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005bf:	75 0d                	jne    8005ce <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c4:	89 c7                	mov    %eax,%edi
  8005c6:	03 45 e0             	add    -0x20(%ebp),%eax
  8005c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cc:	eb 53                	jmp    800621 <vprintfmt+0x1f4>
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d4:	50                   	push   %eax
  8005d5:	e8 13 04 00 00       	call   8009ed <strnlen>
  8005da:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005dd:	29 c1                	sub    %eax,%ecx
  8005df:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005e7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ee:	eb 0f                	jmp    8005ff <vprintfmt+0x1d2>
					putch(padc, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f9:	83 ef 01             	sub    $0x1,%edi
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	85 ff                	test   %edi,%edi
  800601:	7f ed                	jg     8005f0 <vprintfmt+0x1c3>
  800603:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800606:	85 d2                	test   %edx,%edx
  800608:	b8 00 00 00 00       	mov    $0x0,%eax
  80060d:	0f 49 c2             	cmovns %edx,%eax
  800610:	29 c2                	sub    %eax,%edx
  800612:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800615:	eb aa                	jmp    8005c1 <vprintfmt+0x194>
					putch(ch, putdat);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	52                   	push   %edx
  80061c:	ff d6                	call   *%esi
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800624:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800626:	83 c7 01             	add    $0x1,%edi
  800629:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80062d:	0f be d0             	movsbl %al,%edx
  800630:	85 d2                	test   %edx,%edx
  800632:	74 4b                	je     80067f <vprintfmt+0x252>
  800634:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800638:	78 06                	js     800640 <vprintfmt+0x213>
  80063a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80063e:	78 1e                	js     80065e <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800640:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800644:	74 d1                	je     800617 <vprintfmt+0x1ea>
  800646:	0f be c0             	movsbl %al,%eax
  800649:	83 e8 20             	sub    $0x20,%eax
  80064c:	83 f8 5e             	cmp    $0x5e,%eax
  80064f:	76 c6                	jbe    800617 <vprintfmt+0x1ea>
					putch('?', putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	6a 3f                	push   $0x3f
  800657:	ff d6                	call   *%esi
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	eb c3                	jmp    800621 <vprintfmt+0x1f4>
  80065e:	89 cf                	mov    %ecx,%edi
  800660:	eb 0e                	jmp    800670 <vprintfmt+0x243>
				putch(' ', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	6a 20                	push   $0x20
  800668:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80066a:	83 ef 01             	sub    $0x1,%edi
  80066d:	83 c4 10             	add    $0x10,%esp
  800670:	85 ff                	test   %edi,%edi
  800672:	7f ee                	jg     800662 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800674:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
  80067a:	e9 76 01 00 00       	jmp    8007f5 <vprintfmt+0x3c8>
  80067f:	89 cf                	mov    %ecx,%edi
  800681:	eb ed                	jmp    800670 <vprintfmt+0x243>
	if (lflag >= 2)
  800683:	83 f9 01             	cmp    $0x1,%ecx
  800686:	7f 1f                	jg     8006a7 <vprintfmt+0x27a>
	else if (lflag)
  800688:	85 c9                	test   %ecx,%ecx
  80068a:	74 6a                	je     8006f6 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800694:	89 c1                	mov    %eax,%ecx
  800696:	c1 f9 1f             	sar    $0x1f,%ecx
  800699:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	eb 17                	jmp    8006be <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 50 04             	mov    0x4(%eax),%edx
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8d 40 08             	lea    0x8(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006be:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8006c1:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006c6:	85 d2                	test   %edx,%edx
  8006c8:	0f 89 f8 00 00 00    	jns    8007c6 <vprintfmt+0x399>
				putch('-', putdat);
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	53                   	push   %ebx
  8006d2:	6a 2d                	push   $0x2d
  8006d4:	ff d6                	call   *%esi
				num = -(long long) num;
  8006d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dc:	f7 d8                	neg    %eax
  8006de:	83 d2 00             	adc    $0x0,%edx
  8006e1:	f7 da                	neg    %edx
  8006e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ec:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006f1:	e9 e1 00 00 00       	jmp    8007d7 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fe:	99                   	cltd   
  8006ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
  80070b:	eb b1                	jmp    8006be <vprintfmt+0x291>
	if (lflag >= 2)
  80070d:	83 f9 01             	cmp    $0x1,%ecx
  800710:	7f 27                	jg     800739 <vprintfmt+0x30c>
	else if (lflag)
  800712:	85 c9                	test   %ecx,%ecx
  800714:	74 41                	je     800757 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800723:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8d 40 04             	lea    0x4(%eax),%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800734:	e9 8d 00 00 00       	jmp    8007c6 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8b 50 04             	mov    0x4(%eax),%edx
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 08             	lea    0x8(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800750:	bf 0a 00 00 00       	mov    $0xa,%edi
  800755:	eb 6f                	jmp    8007c6 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	ba 00 00 00 00       	mov    $0x0,%edx
  800761:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800764:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 40 04             	lea    0x4(%eax),%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800770:	bf 0a 00 00 00       	mov    $0xa,%edi
  800775:	eb 4f                	jmp    8007c6 <vprintfmt+0x399>
	if (lflag >= 2)
  800777:	83 f9 01             	cmp    $0x1,%ecx
  80077a:	7f 23                	jg     80079f <vprintfmt+0x372>
	else if (lflag)
  80077c:	85 c9                	test   %ecx,%ecx
  80077e:	0f 84 98 00 00 00    	je     80081c <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
  80078e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800791:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 04             	lea    0x4(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
  80079d:	eb 17                	jmp    8007b6 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8b 50 04             	mov    0x4(%eax),%edx
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8d 40 08             	lea    0x8(%eax),%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 30                	push   $0x30
  8007bc:	ff d6                	call   *%esi
			goto number;
  8007be:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007c1:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8007c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007ca:	74 0b                	je     8007d7 <vprintfmt+0x3aa>
				putch('+', putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	6a 2b                	push   $0x2b
  8007d2:	ff d6                	call   *%esi
  8007d4:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007de:	50                   	push   %eax
  8007df:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e2:	57                   	push   %edi
  8007e3:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e6:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e9:	89 da                	mov    %ebx,%edx
  8007eb:	89 f0                	mov    %esi,%eax
  8007ed:	e8 22 fb ff ff       	call   800314 <printnum>
			break;
  8007f2:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8007f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f8:	83 c7 01             	add    $0x1,%edi
  8007fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ff:	83 f8 25             	cmp    $0x25,%eax
  800802:	0f 84 3c fc ff ff    	je     800444 <vprintfmt+0x17>
			if (ch == '\0')
  800808:	85 c0                	test   %eax,%eax
  80080a:	0f 84 55 01 00 00    	je     800965 <vprintfmt+0x538>
			putch(ch, putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	50                   	push   %eax
  800815:	ff d6                	call   *%esi
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	eb dc                	jmp    8007f8 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	ba 00 00 00 00       	mov    $0x0,%edx
  800826:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800829:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8d 40 04             	lea    0x4(%eax),%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	e9 7c ff ff ff       	jmp    8007b6 <vprintfmt+0x389>
			putch('0', putdat);
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	53                   	push   %ebx
  80083e:	6a 30                	push   $0x30
  800840:	ff d6                	call   *%esi
			putch('x', putdat);
  800842:	83 c4 08             	add    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	6a 78                	push   $0x78
  800848:	ff d6                	call   *%esi
			num = (unsigned long long)
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	ba 00 00 00 00       	mov    $0x0,%edx
  800854:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800857:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80085a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8d 40 04             	lea    0x4(%eax),%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800866:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  80086b:	e9 56 ff ff ff       	jmp    8007c6 <vprintfmt+0x399>
	if (lflag >= 2)
  800870:	83 f9 01             	cmp    $0x1,%ecx
  800873:	7f 27                	jg     80089c <vprintfmt+0x46f>
	else if (lflag)
  800875:	85 c9                	test   %ecx,%ecx
  800877:	74 44                	je     8008bd <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	ba 00 00 00 00       	mov    $0x0,%edx
  800883:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800886:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8d 40 04             	lea    0x4(%eax),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800892:	bf 10 00 00 00       	mov    $0x10,%edi
  800897:	e9 2a ff ff ff       	jmp    8007c6 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8b 50 04             	mov    0x4(%eax),%edx
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 08             	lea    0x8(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b3:	bf 10 00 00 00       	mov    $0x10,%edi
  8008b8:	e9 09 ff ff ff       	jmp    8007c6 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8d 40 04             	lea    0x4(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d6:	bf 10 00 00 00       	mov    $0x10,%edi
  8008db:	e9 e6 fe ff ff       	jmp    8007c6 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8d 78 04             	lea    0x4(%eax),%edi
  8008e6:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8008e8:	85 c0                	test   %eax,%eax
  8008ea:	74 2d                	je     800919 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8008ec:	0f b6 13             	movzbl (%ebx),%edx
  8008ef:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008f1:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8008f4:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8008f7:	0f 8e f8 fe ff ff    	jle    8007f5 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8008fd:	68 90 27 80 00       	push   $0x802790
  800902:	68 81 2b 80 00       	push   $0x802b81
  800907:	53                   	push   %ebx
  800908:	56                   	push   %esi
  800909:	e8 02 fb ff ff       	call   800410 <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800911:	89 7d 14             	mov    %edi,0x14(%ebp)
  800914:	e9 dc fe ff ff       	jmp    8007f5 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800919:	68 58 27 80 00       	push   $0x802758
  80091e:	68 81 2b 80 00       	push   $0x802b81
  800923:	53                   	push   %ebx
  800924:	56                   	push   %esi
  800925:	e8 e6 fa ff ff       	call   800410 <printfmt>
  80092a:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80092d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800930:	e9 c0 fe ff ff       	jmp    8007f5 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	53                   	push   %ebx
  800939:	6a 25                	push   $0x25
  80093b:	ff d6                	call   *%esi
			break;
  80093d:	83 c4 10             	add    $0x10,%esp
  800940:	e9 b0 fe ff ff       	jmp    8007f5 <vprintfmt+0x3c8>
			putch('%', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	53                   	push   %ebx
  800949:	6a 25                	push   $0x25
  80094b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	89 f8                	mov    %edi,%eax
  800952:	eb 03                	jmp    800957 <vprintfmt+0x52a>
  800954:	83 e8 01             	sub    $0x1,%eax
  800957:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80095b:	75 f7                	jne    800954 <vprintfmt+0x527>
  80095d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800960:	e9 90 fe ff ff       	jmp    8007f5 <vprintfmt+0x3c8>
}
  800965:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800968:	5b                   	pop    %ebx
  800969:	5e                   	pop    %esi
  80096a:	5f                   	pop    %edi
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 18             	sub    $0x18,%esp
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800979:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80097c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800980:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800983:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80098a:	85 c0                	test   %eax,%eax
  80098c:	74 26                	je     8009b4 <vsnprintf+0x47>
  80098e:	85 d2                	test   %edx,%edx
  800990:	7e 22                	jle    8009b4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800992:	ff 75 14             	pushl  0x14(%ebp)
  800995:	ff 75 10             	pushl  0x10(%ebp)
  800998:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80099b:	50                   	push   %eax
  80099c:	68 f3 03 80 00       	push   $0x8003f3
  8009a1:	e8 87 fa ff ff       	call   80042d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009af:	83 c4 10             	add    $0x10,%esp
}
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    
		return -E_INVAL;
  8009b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009b9:	eb f7                	jmp    8009b2 <vsnprintf+0x45>

008009bb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009c4:	50                   	push   %eax
  8009c5:	ff 75 10             	pushl  0x10(%ebp)
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	ff 75 08             	pushl  0x8(%ebp)
  8009ce:	e8 9a ff ff ff       	call   80096d <vsnprintf>
	va_end(ap);

	return rc;
}
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009db:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009e4:	74 05                	je     8009eb <strlen+0x16>
		n++;
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	eb f5                	jmp    8009e0 <strlen+0xb>
	return n;
}
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	39 c2                	cmp    %eax,%edx
  8009fd:	74 0d                	je     800a0c <strnlen+0x1f>
  8009ff:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a03:	74 05                	je     800a0a <strnlen+0x1d>
		n++;
  800a05:	83 c2 01             	add    $0x1,%edx
  800a08:	eb f1                	jmp    8009fb <strnlen+0xe>
  800a0a:	89 d0                	mov    %edx,%eax
	return n;
}
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	53                   	push   %ebx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a18:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a21:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a24:	83 c2 01             	add    $0x1,%edx
  800a27:	84 c9                	test   %cl,%cl
  800a29:	75 f2                	jne    800a1d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a2b:	5b                   	pop    %ebx
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	53                   	push   %ebx
  800a32:	83 ec 10             	sub    $0x10,%esp
  800a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a38:	53                   	push   %ebx
  800a39:	e8 97 ff ff ff       	call   8009d5 <strlen>
  800a3e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a41:	ff 75 0c             	pushl  0xc(%ebp)
  800a44:	01 d8                	add    %ebx,%eax
  800a46:	50                   	push   %eax
  800a47:	e8 c2 ff ff ff       	call   800a0e <strcpy>
	return dst;
}
  800a4c:	89 d8                	mov    %ebx,%eax
  800a4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    

00800a53 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	56                   	push   %esi
  800a57:	53                   	push   %ebx
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a5e:	89 c6                	mov    %eax,%esi
  800a60:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	39 f2                	cmp    %esi,%edx
  800a67:	74 11                	je     800a7a <strncpy+0x27>
		*dst++ = *src;
  800a69:	83 c2 01             	add    $0x1,%edx
  800a6c:	0f b6 19             	movzbl (%ecx),%ebx
  800a6f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a72:	80 fb 01             	cmp    $0x1,%bl
  800a75:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a78:	eb eb                	jmp    800a65 <strncpy+0x12>
	}
	return ret;
}
  800a7a:	5b                   	pop    %ebx
  800a7b:	5e                   	pop    %esi
  800a7c:	5d                   	pop    %ebp
  800a7d:	c3                   	ret    

00800a7e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	56                   	push   %esi
  800a82:	53                   	push   %ebx
  800a83:	8b 75 08             	mov    0x8(%ebp),%esi
  800a86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a89:	8b 55 10             	mov    0x10(%ebp),%edx
  800a8c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a8e:	85 d2                	test   %edx,%edx
  800a90:	74 21                	je     800ab3 <strlcpy+0x35>
  800a92:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a96:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a98:	39 c2                	cmp    %eax,%edx
  800a9a:	74 14                	je     800ab0 <strlcpy+0x32>
  800a9c:	0f b6 19             	movzbl (%ecx),%ebx
  800a9f:	84 db                	test   %bl,%bl
  800aa1:	74 0b                	je     800aae <strlcpy+0x30>
			*dst++ = *src++;
  800aa3:	83 c1 01             	add    $0x1,%ecx
  800aa6:	83 c2 01             	add    $0x1,%edx
  800aa9:	88 5a ff             	mov    %bl,-0x1(%edx)
  800aac:	eb ea                	jmp    800a98 <strlcpy+0x1a>
  800aae:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ab0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ab3:	29 f0                	sub    %esi,%eax
}
  800ab5:	5b                   	pop    %ebx
  800ab6:	5e                   	pop    %esi
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ac2:	0f b6 01             	movzbl (%ecx),%eax
  800ac5:	84 c0                	test   %al,%al
  800ac7:	74 0c                	je     800ad5 <strcmp+0x1c>
  800ac9:	3a 02                	cmp    (%edx),%al
  800acb:	75 08                	jne    800ad5 <strcmp+0x1c>
		p++, q++;
  800acd:	83 c1 01             	add    $0x1,%ecx
  800ad0:	83 c2 01             	add    $0x1,%edx
  800ad3:	eb ed                	jmp    800ac2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad5:	0f b6 c0             	movzbl %al,%eax
  800ad8:	0f b6 12             	movzbl (%edx),%edx
  800adb:	29 d0                	sub    %edx,%eax
}
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	53                   	push   %ebx
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae9:	89 c3                	mov    %eax,%ebx
  800aeb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aee:	eb 06                	jmp    800af6 <strncmp+0x17>
		n--, p++, q++;
  800af0:	83 c0 01             	add    $0x1,%eax
  800af3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800af6:	39 d8                	cmp    %ebx,%eax
  800af8:	74 16                	je     800b10 <strncmp+0x31>
  800afa:	0f b6 08             	movzbl (%eax),%ecx
  800afd:	84 c9                	test   %cl,%cl
  800aff:	74 04                	je     800b05 <strncmp+0x26>
  800b01:	3a 0a                	cmp    (%edx),%cl
  800b03:	74 eb                	je     800af0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b05:	0f b6 00             	movzbl (%eax),%eax
  800b08:	0f b6 12             	movzbl (%edx),%edx
  800b0b:	29 d0                	sub    %edx,%eax
}
  800b0d:	5b                   	pop    %ebx
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    
		return 0;
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
  800b15:	eb f6                	jmp    800b0d <strncmp+0x2e>

00800b17 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b21:	0f b6 10             	movzbl (%eax),%edx
  800b24:	84 d2                	test   %dl,%dl
  800b26:	74 09                	je     800b31 <strchr+0x1a>
		if (*s == c)
  800b28:	38 ca                	cmp    %cl,%dl
  800b2a:	74 0a                	je     800b36 <strchr+0x1f>
	for (; *s; s++)
  800b2c:	83 c0 01             	add    $0x1,%eax
  800b2f:	eb f0                	jmp    800b21 <strchr+0xa>
			return (char *) s;
	return 0;
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b42:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b45:	38 ca                	cmp    %cl,%dl
  800b47:	74 09                	je     800b52 <strfind+0x1a>
  800b49:	84 d2                	test   %dl,%dl
  800b4b:	74 05                	je     800b52 <strfind+0x1a>
	for (; *s; s++)
  800b4d:	83 c0 01             	add    $0x1,%eax
  800b50:	eb f0                	jmp    800b42 <strfind+0xa>
			break;
	return (char *) s;
}
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b60:	85 c9                	test   %ecx,%ecx
  800b62:	74 31                	je     800b95 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b64:	89 f8                	mov    %edi,%eax
  800b66:	09 c8                	or     %ecx,%eax
  800b68:	a8 03                	test   $0x3,%al
  800b6a:	75 23                	jne    800b8f <memset+0x3b>
		c &= 0xFF;
  800b6c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b70:	89 d3                	mov    %edx,%ebx
  800b72:	c1 e3 08             	shl    $0x8,%ebx
  800b75:	89 d0                	mov    %edx,%eax
  800b77:	c1 e0 18             	shl    $0x18,%eax
  800b7a:	89 d6                	mov    %edx,%esi
  800b7c:	c1 e6 10             	shl    $0x10,%esi
  800b7f:	09 f0                	or     %esi,%eax
  800b81:	09 c2                	or     %eax,%edx
  800b83:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b85:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b88:	89 d0                	mov    %edx,%eax
  800b8a:	fc                   	cld    
  800b8b:	f3 ab                	rep stos %eax,%es:(%edi)
  800b8d:	eb 06                	jmp    800b95 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b92:	fc                   	cld    
  800b93:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b95:	89 f8                	mov    %edi,%eax
  800b97:	5b                   	pop    %ebx
  800b98:	5e                   	pop    %esi
  800b99:	5f                   	pop    %edi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	57                   	push   %edi
  800ba0:	56                   	push   %esi
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800baa:	39 c6                	cmp    %eax,%esi
  800bac:	73 32                	jae    800be0 <memmove+0x44>
  800bae:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb1:	39 c2                	cmp    %eax,%edx
  800bb3:	76 2b                	jbe    800be0 <memmove+0x44>
		s += n;
		d += n;
  800bb5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb8:	89 fe                	mov    %edi,%esi
  800bba:	09 ce                	or     %ecx,%esi
  800bbc:	09 d6                	or     %edx,%esi
  800bbe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bc4:	75 0e                	jne    800bd4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bc6:	83 ef 04             	sub    $0x4,%edi
  800bc9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bcc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bcf:	fd                   	std    
  800bd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd2:	eb 09                	jmp    800bdd <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bd4:	83 ef 01             	sub    $0x1,%edi
  800bd7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bda:	fd                   	std    
  800bdb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bdd:	fc                   	cld    
  800bde:	eb 1a                	jmp    800bfa <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be0:	89 c2                	mov    %eax,%edx
  800be2:	09 ca                	or     %ecx,%edx
  800be4:	09 f2                	or     %esi,%edx
  800be6:	f6 c2 03             	test   $0x3,%dl
  800be9:	75 0a                	jne    800bf5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800beb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bee:	89 c7                	mov    %eax,%edi
  800bf0:	fc                   	cld    
  800bf1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf3:	eb 05                	jmp    800bfa <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bf5:	89 c7                	mov    %eax,%edi
  800bf7:	fc                   	cld    
  800bf8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bfa:	5e                   	pop    %esi
  800bfb:	5f                   	pop    %edi
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c04:	ff 75 10             	pushl  0x10(%ebp)
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	ff 75 08             	pushl  0x8(%ebp)
  800c0d:	e8 8a ff ff ff       	call   800b9c <memmove>
}
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1f:	89 c6                	mov    %eax,%esi
  800c21:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c24:	39 f0                	cmp    %esi,%eax
  800c26:	74 1c                	je     800c44 <memcmp+0x30>
		if (*s1 != *s2)
  800c28:	0f b6 08             	movzbl (%eax),%ecx
  800c2b:	0f b6 1a             	movzbl (%edx),%ebx
  800c2e:	38 d9                	cmp    %bl,%cl
  800c30:	75 08                	jne    800c3a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c32:	83 c0 01             	add    $0x1,%eax
  800c35:	83 c2 01             	add    $0x1,%edx
  800c38:	eb ea                	jmp    800c24 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c3a:	0f b6 c1             	movzbl %cl,%eax
  800c3d:	0f b6 db             	movzbl %bl,%ebx
  800c40:	29 d8                	sub    %ebx,%eax
  800c42:	eb 05                	jmp    800c49 <memcmp+0x35>
	}

	return 0;
  800c44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c49:	5b                   	pop    %ebx
  800c4a:	5e                   	pop    %esi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c56:	89 c2                	mov    %eax,%edx
  800c58:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c5b:	39 d0                	cmp    %edx,%eax
  800c5d:	73 09                	jae    800c68 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c5f:	38 08                	cmp    %cl,(%eax)
  800c61:	74 05                	je     800c68 <memfind+0x1b>
	for (; s < ends; s++)
  800c63:	83 c0 01             	add    $0x1,%eax
  800c66:	eb f3                	jmp    800c5b <memfind+0xe>
			break;
	return (void *) s;
}
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c76:	eb 03                	jmp    800c7b <strtol+0x11>
		s++;
  800c78:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c7b:	0f b6 01             	movzbl (%ecx),%eax
  800c7e:	3c 20                	cmp    $0x20,%al
  800c80:	74 f6                	je     800c78 <strtol+0xe>
  800c82:	3c 09                	cmp    $0x9,%al
  800c84:	74 f2                	je     800c78 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c86:	3c 2b                	cmp    $0x2b,%al
  800c88:	74 2a                	je     800cb4 <strtol+0x4a>
	int neg = 0;
  800c8a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c8f:	3c 2d                	cmp    $0x2d,%al
  800c91:	74 2b                	je     800cbe <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c93:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c99:	75 0f                	jne    800caa <strtol+0x40>
  800c9b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c9e:	74 28                	je     800cc8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ca0:	85 db                	test   %ebx,%ebx
  800ca2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ca7:	0f 44 d8             	cmove  %eax,%ebx
  800caa:	b8 00 00 00 00       	mov    $0x0,%eax
  800caf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cb2:	eb 50                	jmp    800d04 <strtol+0x9a>
		s++;
  800cb4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cb7:	bf 00 00 00 00       	mov    $0x0,%edi
  800cbc:	eb d5                	jmp    800c93 <strtol+0x29>
		s++, neg = 1;
  800cbe:	83 c1 01             	add    $0x1,%ecx
  800cc1:	bf 01 00 00 00       	mov    $0x1,%edi
  800cc6:	eb cb                	jmp    800c93 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ccc:	74 0e                	je     800cdc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cce:	85 db                	test   %ebx,%ebx
  800cd0:	75 d8                	jne    800caa <strtol+0x40>
		s++, base = 8;
  800cd2:	83 c1 01             	add    $0x1,%ecx
  800cd5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cda:	eb ce                	jmp    800caa <strtol+0x40>
		s += 2, base = 16;
  800cdc:	83 c1 02             	add    $0x2,%ecx
  800cdf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ce4:	eb c4                	jmp    800caa <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ce6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ce9:	89 f3                	mov    %esi,%ebx
  800ceb:	80 fb 19             	cmp    $0x19,%bl
  800cee:	77 29                	ja     800d19 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cf0:	0f be d2             	movsbl %dl,%edx
  800cf3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cf6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cf9:	7d 30                	jge    800d2b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cfb:	83 c1 01             	add    $0x1,%ecx
  800cfe:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d02:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d04:	0f b6 11             	movzbl (%ecx),%edx
  800d07:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d0a:	89 f3                	mov    %esi,%ebx
  800d0c:	80 fb 09             	cmp    $0x9,%bl
  800d0f:	77 d5                	ja     800ce6 <strtol+0x7c>
			dig = *s - '0';
  800d11:	0f be d2             	movsbl %dl,%edx
  800d14:	83 ea 30             	sub    $0x30,%edx
  800d17:	eb dd                	jmp    800cf6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d19:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d1c:	89 f3                	mov    %esi,%ebx
  800d1e:	80 fb 19             	cmp    $0x19,%bl
  800d21:	77 08                	ja     800d2b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d23:	0f be d2             	movsbl %dl,%edx
  800d26:	83 ea 37             	sub    $0x37,%edx
  800d29:	eb cb                	jmp    800cf6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 05                	je     800d36 <strtol+0xcc>
		*endptr = (char *) s;
  800d31:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d34:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d36:	89 c2                	mov    %eax,%edx
  800d38:	f7 da                	neg    %edx
  800d3a:	85 ff                	test   %edi,%edi
  800d3c:	0f 45 c2             	cmovne %edx,%eax
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	89 c3                	mov    %eax,%ebx
  800d57:	89 c7                	mov    %eax,%edi
  800d59:	89 c6                	mov    %eax,%esi
  800d5b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d68:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d72:	89 d1                	mov    %edx,%ecx
  800d74:	89 d3                	mov    %edx,%ebx
  800d76:	89 d7                	mov    %edx,%edi
  800d78:	89 d6                	mov    %edx,%esi
  800d7a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	57                   	push   %edi
  800d85:	56                   	push   %esi
  800d86:	53                   	push   %ebx
  800d87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	b8 03 00 00 00       	mov    $0x3,%eax
  800d97:	89 cb                	mov    %ecx,%ebx
  800d99:	89 cf                	mov    %ecx,%edi
  800d9b:	89 ce                	mov    %ecx,%esi
  800d9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7f 08                	jg     800dab <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dab:	83 ec 0c             	sub    $0xc,%esp
  800dae:	50                   	push   %eax
  800daf:	6a 03                	push   $0x3
  800db1:	68 a0 29 80 00       	push   $0x8029a0
  800db6:	6a 33                	push   $0x33
  800db8:	68 bd 29 80 00       	push   $0x8029bd
  800dbd:	e8 63 f4 ff ff       	call   800225 <_panic>

00800dc2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc8:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcd:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd2:	89 d1                	mov    %edx,%ecx
  800dd4:	89 d3                	mov    %edx,%ebx
  800dd6:	89 d7                	mov    %edx,%edi
  800dd8:	89 d6                	mov    %edx,%esi
  800dda:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <sys_yield>:

void
sys_yield(void)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	57                   	push   %edi
  800de5:	56                   	push   %esi
  800de6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dec:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df1:	89 d1                	mov    %edx,%ecx
  800df3:	89 d3                	mov    %edx,%ebx
  800df5:	89 d7                	mov    %edx,%edi
  800df7:	89 d6                	mov    %edx,%esi
  800df9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e09:	be 00 00 00 00       	mov    $0x0,%esi
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	b8 04 00 00 00       	mov    $0x4,%eax
  800e19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1c:	89 f7                	mov    %esi,%edi
  800e1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e20:	85 c0                	test   %eax,%eax
  800e22:	7f 08                	jg     800e2c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2c:	83 ec 0c             	sub    $0xc,%esp
  800e2f:	50                   	push   %eax
  800e30:	6a 04                	push   $0x4
  800e32:	68 a0 29 80 00       	push   $0x8029a0
  800e37:	6a 33                	push   $0x33
  800e39:	68 bd 29 80 00       	push   $0x8029bd
  800e3e:	e8 e2 f3 ff ff       	call   800225 <_panic>

00800e43 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e52:	b8 05 00 00 00       	mov    $0x5,%eax
  800e57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5d:	8b 75 18             	mov    0x18(%ebp),%esi
  800e60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7f 08                	jg     800e6e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	50                   	push   %eax
  800e72:	6a 05                	push   $0x5
  800e74:	68 a0 29 80 00       	push   $0x8029a0
  800e79:	6a 33                	push   $0x33
  800e7b:	68 bd 29 80 00       	push   $0x8029bd
  800e80:	e8 a0 f3 ff ff       	call   800225 <_panic>

00800e85 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	b8 06 00 00 00       	mov    $0x6,%eax
  800e9e:	89 df                	mov    %ebx,%edi
  800ea0:	89 de                	mov    %ebx,%esi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 06                	push   $0x6
  800eb6:	68 a0 29 80 00       	push   $0x8029a0
  800ebb:	6a 33                	push   $0x33
  800ebd:	68 bd 29 80 00       	push   $0x8029bd
  800ec2:	e8 5e f3 ff ff       	call   800225 <_panic>

00800ec7 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800edd:	89 cb                	mov    %ecx,%ebx
  800edf:	89 cf                	mov    %ecx,%edi
  800ee1:	89 ce                	mov    %ecx,%esi
  800ee3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee5:	85 c0                	test   %eax,%eax
  800ee7:	7f 08                	jg     800ef1 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef1:	83 ec 0c             	sub    $0xc,%esp
  800ef4:	50                   	push   %eax
  800ef5:	6a 0b                	push   $0xb
  800ef7:	68 a0 29 80 00       	push   $0x8029a0
  800efc:	6a 33                	push   $0x33
  800efe:	68 bd 29 80 00       	push   $0x8029bd
  800f03:	e8 1d f3 ff ff       	call   800225 <_panic>

00800f08 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f21:	89 df                	mov    %ebx,%edi
  800f23:	89 de                	mov    %ebx,%esi
  800f25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	7f 08                	jg     800f33 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	50                   	push   %eax
  800f37:	6a 08                	push   $0x8
  800f39:	68 a0 29 80 00       	push   $0x8029a0
  800f3e:	6a 33                	push   $0x33
  800f40:	68 bd 29 80 00       	push   $0x8029bd
  800f45:	e8 db f2 ff ff       	call   800225 <_panic>

00800f4a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f58:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f63:	89 df                	mov    %ebx,%edi
  800f65:	89 de                	mov    %ebx,%esi
  800f67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	7f 08                	jg     800f75 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f75:	83 ec 0c             	sub    $0xc,%esp
  800f78:	50                   	push   %eax
  800f79:	6a 09                	push   $0x9
  800f7b:	68 a0 29 80 00       	push   $0x8029a0
  800f80:	6a 33                	push   $0x33
  800f82:	68 bd 29 80 00       	push   $0x8029bd
  800f87:	e8 99 f2 ff ff       	call   800225 <_panic>

00800f8c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
  800f92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa5:	89 df                	mov    %ebx,%edi
  800fa7:	89 de                	mov    %ebx,%esi
  800fa9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fab:	85 c0                	test   %eax,%eax
  800fad:	7f 08                	jg     800fb7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb7:	83 ec 0c             	sub    $0xc,%esp
  800fba:	50                   	push   %eax
  800fbb:	6a 0a                	push   $0xa
  800fbd:	68 a0 29 80 00       	push   $0x8029a0
  800fc2:	6a 33                	push   $0x33
  800fc4:	68 bd 29 80 00       	push   $0x8029bd
  800fc9:	e8 57 f2 ff ff       	call   800225 <_panic>

00800fce <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fda:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fdf:	be 00 00 00 00       	mov    $0x0,%esi
  800fe4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fea:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	57                   	push   %edi
  800ff5:	56                   	push   %esi
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	b8 0e 00 00 00       	mov    $0xe,%eax
  801007:	89 cb                	mov    %ecx,%ebx
  801009:	89 cf                	mov    %ecx,%edi
  80100b:	89 ce                	mov    %ecx,%esi
  80100d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100f:	85 c0                	test   %eax,%eax
  801011:	7f 08                	jg     80101b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801013:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801016:	5b                   	pop    %ebx
  801017:	5e                   	pop    %esi
  801018:	5f                   	pop    %edi
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	50                   	push   %eax
  80101f:	6a 0e                	push   $0xe
  801021:	68 a0 29 80 00       	push   $0x8029a0
  801026:	6a 33                	push   $0x33
  801028:	68 bd 29 80 00       	push   $0x8029bd
  80102d:	e8 f3 f1 ff ff       	call   800225 <_panic>

00801032 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
	asm volatile("int %1\n"
  801038:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801043:	b8 0f 00 00 00       	mov    $0xf,%eax
  801048:	89 df                	mov    %ebx,%edi
  80104a:	89 de                	mov    %ebx,%esi
  80104c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	53                   	push   %ebx
	asm volatile("int %1\n"
  801059:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105e:	8b 55 08             	mov    0x8(%ebp),%edx
  801061:	b8 10 00 00 00       	mov    $0x10,%eax
  801066:	89 cb                	mov    %ecx,%ebx
  801068:	89 cf                	mov    %ecx,%edi
  80106a:	89 ce                	mov    %ecx,%esi
  80106c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	53                   	push   %ebx
  801077:	83 ec 04             	sub    $0x4,%esp
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80107d:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  80107f:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801083:	0f 84 90 00 00 00    	je     801119 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  801089:	89 d8                	mov    %ebx,%eax
  80108b:	c1 e8 16             	shr    $0x16,%eax
  80108e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801095:	a8 01                	test   $0x1,%al
  801097:	0f 84 90 00 00 00    	je     80112d <pgfault+0xba>
  80109d:	89 d8                	mov    %ebx,%eax
  80109f:	c1 e8 0c             	shr    $0xc,%eax
  8010a2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a9:	a9 01 08 00 00       	test   $0x801,%eax
  8010ae:	74 7d                	je     80112d <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8010b0:	83 ec 04             	sub    $0x4,%esp
  8010b3:	6a 07                	push   $0x7
  8010b5:	68 00 f0 7f 00       	push   $0x7ff000
  8010ba:	6a 00                	push   $0x0
  8010bc:	e8 3f fd ff ff       	call   800e00 <sys_page_alloc>
  8010c1:	83 c4 10             	add    $0x10,%esp
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	78 79                	js     801141 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  8010c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	68 00 10 00 00       	push   $0x1000
  8010d6:	53                   	push   %ebx
  8010d7:	68 00 f0 7f 00       	push   $0x7ff000
  8010dc:	e8 bb fa ff ff       	call   800b9c <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  8010e1:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010e8:	53                   	push   %ebx
  8010e9:	6a 00                	push   $0x0
  8010eb:	68 00 f0 7f 00       	push   $0x7ff000
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 4c fd ff ff       	call   800e43 <sys_page_map>
  8010f7:	83 c4 20             	add    $0x20,%esp
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	78 55                	js     801153 <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	68 00 f0 7f 00       	push   $0x7ff000
  801106:	6a 00                	push   $0x0
  801108:	e8 78 fd ff ff       	call   800e85 <sys_page_unmap>
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	78 51                	js     801165 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  801114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801117:	c9                   	leave  
  801118:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  801119:	83 ec 04             	sub    $0x4,%esp
  80111c:	68 cc 29 80 00       	push   $0x8029cc
  801121:	6a 21                	push   $0x21
  801123:	68 54 2a 80 00       	push   $0x802a54
  801128:	e8 f8 f0 ff ff       	call   800225 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 f8 29 80 00       	push   $0x8029f8
  801135:	6a 24                	push   $0x24
  801137:	68 54 2a 80 00       	push   $0x802a54
  80113c:	e8 e4 f0 ff ff       	call   800225 <_panic>
		panic("sys_page_alloc: %e\n", r);
  801141:	50                   	push   %eax
  801142:	68 5f 2a 80 00       	push   $0x802a5f
  801147:	6a 2e                	push   $0x2e
  801149:	68 54 2a 80 00       	push   $0x802a54
  80114e:	e8 d2 f0 ff ff       	call   800225 <_panic>
		panic("sys_page_map: %e\n", r);
  801153:	50                   	push   %eax
  801154:	68 73 2a 80 00       	push   $0x802a73
  801159:	6a 34                	push   $0x34
  80115b:	68 54 2a 80 00       	push   $0x802a54
  801160:	e8 c0 f0 ff ff       	call   800225 <_panic>
		panic("sys_page_unmap: %e\n", r);
  801165:	50                   	push   %eax
  801166:	68 85 2a 80 00       	push   $0x802a85
  80116b:	6a 37                	push   $0x37
  80116d:	68 54 2a 80 00       	push   $0x802a54
  801172:	e8 ae f0 ff ff       	call   800225 <_panic>

00801177 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	57                   	push   %edi
  80117b:	56                   	push   %esi
  80117c:	53                   	push   %ebx
  80117d:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801180:	68 73 10 80 00       	push   $0x801073
  801185:	e8 1a 0f 00 00       	call   8020a4 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80118a:	b8 07 00 00 00       	mov    $0x7,%eax
  80118f:	cd 30                	int    $0x30
  801191:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  801194:	83 c4 10             	add    $0x10,%esp
  801197:	85 c0                	test   %eax,%eax
  801199:	78 30                	js     8011cb <fork+0x54>
  80119b:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  80119d:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8011a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a6:	0f 85 a5 00 00 00    	jne    801251 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011ac:	e8 11 fc ff ff       	call   800dc2 <sys_getenvid>
  8011b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011b6:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8011b9:	c1 e0 04             	shl    $0x4,%eax
  8011bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011c1:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  8011c6:	e9 75 01 00 00       	jmp    801340 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  8011cb:	50                   	push   %eax
  8011cc:	68 99 2a 80 00       	push   $0x802a99
  8011d1:	68 83 00 00 00       	push   $0x83
  8011d6:	68 54 2a 80 00       	push   $0x802a54
  8011db:	e8 45 f0 ff ff       	call   800225 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8011e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e7:	83 ec 0c             	sub    $0xc,%esp
  8011ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ef:	50                   	push   %eax
  8011f0:	56                   	push   %esi
  8011f1:	57                   	push   %edi
  8011f2:	56                   	push   %esi
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 49 fc ff ff       	call   800e43 <sys_page_map>
  8011fa:	83 c4 20             	add    $0x20,%esp
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	79 3e                	jns    80123f <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801201:	50                   	push   %eax
  801202:	68 73 2a 80 00       	push   $0x802a73
  801207:	6a 50                	push   $0x50
  801209:	68 54 2a 80 00       	push   $0x802a54
  80120e:	e8 12 f0 ff ff       	call   800225 <_panic>
			panic("sys_page_map: %e\n", r);
  801213:	50                   	push   %eax
  801214:	68 73 2a 80 00       	push   $0x802a73
  801219:	6a 54                	push   $0x54
  80121b:	68 54 2a 80 00       	push   $0x802a54
  801220:	e8 00 f0 ff ff       	call   800225 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  801225:	83 ec 0c             	sub    $0xc,%esp
  801228:	6a 05                	push   $0x5
  80122a:	56                   	push   %esi
  80122b:	57                   	push   %edi
  80122c:	56                   	push   %esi
  80122d:	6a 00                	push   $0x0
  80122f:	e8 0f fc ff ff       	call   800e43 <sys_page_map>
  801234:	83 c4 20             	add    $0x20,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	0f 88 ab 00 00 00    	js     8012ea <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  80123f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801245:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80124b:	0f 84 ab 00 00 00    	je     8012fc <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  801251:	89 d8                	mov    %ebx,%eax
  801253:	c1 e8 16             	shr    $0x16,%eax
  801256:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80125d:	a8 01                	test   $0x1,%al
  80125f:	74 de                	je     80123f <fork+0xc8>
  801261:	89 d8                	mov    %ebx,%eax
  801263:	c1 e8 0c             	shr    $0xc,%eax
  801266:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80126d:	f6 c2 01             	test   $0x1,%dl
  801270:	74 cd                	je     80123f <fork+0xc8>
  801272:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801278:	74 c5                	je     80123f <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  80127a:	89 c6                	mov    %eax,%esi
  80127c:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  80127f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801286:	f6 c6 04             	test   $0x4,%dh
  801289:	0f 85 51 ff ff ff    	jne    8011e0 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  80128f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801296:	a9 02 08 00 00       	test   $0x802,%eax
  80129b:	74 88                	je     801225 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  80129d:	83 ec 0c             	sub    $0xc,%esp
  8012a0:	68 05 08 00 00       	push   $0x805
  8012a5:	56                   	push   %esi
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	6a 00                	push   $0x0
  8012aa:	e8 94 fb ff ff       	call   800e43 <sys_page_map>
  8012af:	83 c4 20             	add    $0x20,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	0f 88 59 ff ff ff    	js     801213 <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8012ba:	83 ec 0c             	sub    $0xc,%esp
  8012bd:	68 05 08 00 00       	push   $0x805
  8012c2:	56                   	push   %esi
  8012c3:	6a 00                	push   $0x0
  8012c5:	56                   	push   %esi
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 76 fb ff ff       	call   800e43 <sys_page_map>
  8012cd:	83 c4 20             	add    $0x20,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	0f 89 67 ff ff ff    	jns    80123f <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8012d8:	50                   	push   %eax
  8012d9:	68 73 2a 80 00       	push   $0x802a73
  8012de:	6a 56                	push   $0x56
  8012e0:	68 54 2a 80 00       	push   $0x802a54
  8012e5:	e8 3b ef ff ff       	call   800225 <_panic>
			panic("sys_page_map: %e\n", r);
  8012ea:	50                   	push   %eax
  8012eb:	68 73 2a 80 00       	push   $0x802a73
  8012f0:	6a 5a                	push   $0x5a
  8012f2:	68 54 2a 80 00       	push   $0x802a54
  8012f7:	e8 29 ef ff ff       	call   800225 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	6a 07                	push   $0x7
  801301:	68 00 f0 bf ee       	push   $0xeebff000
  801306:	ff 75 e4             	pushl  -0x1c(%ebp)
  801309:	e8 f2 fa ff ff       	call   800e00 <sys_page_alloc>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	78 36                	js     80134b <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	68 0f 21 80 00       	push   $0x80210f
  80131d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801320:	e8 67 fc ff ff       	call   800f8c <sys_env_set_pgfault_upcall>
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	85 c0                	test   %eax,%eax
  80132a:	78 34                	js     801360 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80132c:	83 ec 08             	sub    $0x8,%esp
  80132f:	6a 02                	push   $0x2
  801331:	ff 75 e4             	pushl  -0x1c(%ebp)
  801334:	e8 cf fb ff ff       	call   800f08 <sys_env_set_status>
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	78 35                	js     801375 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  801340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801343:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  80134b:	50                   	push   %eax
  80134c:	68 5f 2a 80 00       	push   $0x802a5f
  801351:	68 95 00 00 00       	push   $0x95
  801356:	68 54 2a 80 00       	push   $0x802a54
  80135b:	e8 c5 ee ff ff       	call   800225 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801360:	50                   	push   %eax
  801361:	68 34 2a 80 00       	push   $0x802a34
  801366:	68 98 00 00 00       	push   $0x98
  80136b:	68 54 2a 80 00       	push   $0x802a54
  801370:	e8 b0 ee ff ff       	call   800225 <_panic>
		panic("sys_env_set_status: %e\n", r);
  801375:	50                   	push   %eax
  801376:	68 a9 2a 80 00       	push   $0x802aa9
  80137b:	68 9b 00 00 00       	push   $0x9b
  801380:	68 54 2a 80 00       	push   $0x802a54
  801385:	e8 9b ee ff ff       	call   800225 <_panic>

0080138a <sfork>:

// Challenge!
int
sfork(void)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801390:	68 c1 2a 80 00       	push   $0x802ac1
  801395:	68 a4 00 00 00       	push   $0xa4
  80139a:	68 54 2a 80 00       	push   $0x802a54
  80139f:	e8 81 ee ff ff       	call   800225 <_panic>

008013a4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	05 00 00 00 30       	add    $0x30000000,%eax
  8013af:	c1 e8 0c             	shr    $0xc,%eax
}
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    

008013b4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    

008013cb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	c1 ea 16             	shr    $0x16,%edx
  8013d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013df:	f6 c2 01             	test   $0x1,%dl
  8013e2:	74 2d                	je     801411 <fd_alloc+0x46>
  8013e4:	89 c2                	mov    %eax,%edx
  8013e6:	c1 ea 0c             	shr    $0xc,%edx
  8013e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f0:	f6 c2 01             	test   $0x1,%dl
  8013f3:	74 1c                	je     801411 <fd_alloc+0x46>
  8013f5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013fa:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013ff:	75 d2                	jne    8013d3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80140a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80140f:	eb 0a                	jmp    80141b <fd_alloc+0x50>
			*fd_store = fd;
  801411:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801414:	89 01                	mov    %eax,(%ecx)
			return 0;
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801423:	83 f8 1f             	cmp    $0x1f,%eax
  801426:	77 30                	ja     801458 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801428:	c1 e0 0c             	shl    $0xc,%eax
  80142b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801430:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801436:	f6 c2 01             	test   $0x1,%dl
  801439:	74 24                	je     80145f <fd_lookup+0x42>
  80143b:	89 c2                	mov    %eax,%edx
  80143d:	c1 ea 0c             	shr    $0xc,%edx
  801440:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801447:	f6 c2 01             	test   $0x1,%dl
  80144a:	74 1a                	je     801466 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80144c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144f:	89 02                	mov    %eax,(%edx)
	return 0;
  801451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    
		return -E_INVAL;
  801458:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145d:	eb f7                	jmp    801456 <fd_lookup+0x39>
		return -E_INVAL;
  80145f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801464:	eb f0                	jmp    801456 <fd_lookup+0x39>
  801466:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146b:	eb e9                	jmp    801456 <fd_lookup+0x39>

0080146d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801476:	ba 58 2b 80 00       	mov    $0x802b58,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80147b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801480:	39 08                	cmp    %ecx,(%eax)
  801482:	74 33                	je     8014b7 <dev_lookup+0x4a>
  801484:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801487:	8b 02                	mov    (%edx),%eax
  801489:	85 c0                	test   %eax,%eax
  80148b:	75 f3                	jne    801480 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80148d:	a1 20 44 80 00       	mov    0x804420,%eax
  801492:	8b 40 48             	mov    0x48(%eax),%eax
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	51                   	push   %ecx
  801499:	50                   	push   %eax
  80149a:	68 d8 2a 80 00       	push   $0x802ad8
  80149f:	e8 5c ee ff ff       	call   800300 <cprintf>
	*dev = 0;
  8014a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    
			*dev = devtab[i];
  8014b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ba:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c1:	eb f2                	jmp    8014b5 <dev_lookup+0x48>

008014c3 <fd_close>:
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	57                   	push   %edi
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
  8014c9:	83 ec 24             	sub    $0x24,%esp
  8014cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8014cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014d5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014d6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014dc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014df:	50                   	push   %eax
  8014e0:	e8 38 ff ff ff       	call   80141d <fd_lookup>
  8014e5:	89 c3                	mov    %eax,%ebx
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 05                	js     8014f3 <fd_close+0x30>
	    || fd != fd2)
  8014ee:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014f1:	74 16                	je     801509 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014f3:	89 f8                	mov    %edi,%eax
  8014f5:	84 c0                	test   %al,%al
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	0f 44 d8             	cmove  %eax,%ebx
}
  8014ff:	89 d8                	mov    %ebx,%eax
  801501:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801504:	5b                   	pop    %ebx
  801505:	5e                   	pop    %esi
  801506:	5f                   	pop    %edi
  801507:	5d                   	pop    %ebp
  801508:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80150f:	50                   	push   %eax
  801510:	ff 36                	pushl  (%esi)
  801512:	e8 56 ff ff ff       	call   80146d <dev_lookup>
  801517:	89 c3                	mov    %eax,%ebx
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 1a                	js     80153a <fd_close+0x77>
		if (dev->dev_close)
  801520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801523:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801526:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80152b:	85 c0                	test   %eax,%eax
  80152d:	74 0b                	je     80153a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80152f:	83 ec 0c             	sub    $0xc,%esp
  801532:	56                   	push   %esi
  801533:	ff d0                	call   *%eax
  801535:	89 c3                	mov    %eax,%ebx
  801537:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80153a:	83 ec 08             	sub    $0x8,%esp
  80153d:	56                   	push   %esi
  80153e:	6a 00                	push   $0x0
  801540:	e8 40 f9 ff ff       	call   800e85 <sys_page_unmap>
	return r;
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	eb b5                	jmp    8014ff <fd_close+0x3c>

0080154a <close>:

int
close(int fdnum)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801550:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	ff 75 08             	pushl  0x8(%ebp)
  801557:	e8 c1 fe ff ff       	call   80141d <fd_lookup>
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	79 02                	jns    801565 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    
		return fd_close(fd, 1);
  801565:	83 ec 08             	sub    $0x8,%esp
  801568:	6a 01                	push   $0x1
  80156a:	ff 75 f4             	pushl  -0xc(%ebp)
  80156d:	e8 51 ff ff ff       	call   8014c3 <fd_close>
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	eb ec                	jmp    801563 <close+0x19>

00801577 <close_all>:

void
close_all(void)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	53                   	push   %ebx
  80157b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80157e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	53                   	push   %ebx
  801587:	e8 be ff ff ff       	call   80154a <close>
	for (i = 0; i < MAXFD; i++)
  80158c:	83 c3 01             	add    $0x1,%ebx
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	83 fb 20             	cmp    $0x20,%ebx
  801595:	75 ec                	jne    801583 <close_all+0xc>
}
  801597:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	57                   	push   %edi
  8015a0:	56                   	push   %esi
  8015a1:	53                   	push   %ebx
  8015a2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015a8:	50                   	push   %eax
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 6c fe ff ff       	call   80141d <fd_lookup>
  8015b1:	89 c3                	mov    %eax,%ebx
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	0f 88 81 00 00 00    	js     80163f <dup+0xa3>
		return r;
	close(newfdnum);
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	e8 81 ff ff ff       	call   80154a <close>

	newfd = INDEX2FD(newfdnum);
  8015c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015cc:	c1 e6 0c             	shl    $0xc,%esi
  8015cf:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015d5:	83 c4 04             	add    $0x4,%esp
  8015d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015db:	e8 d4 fd ff ff       	call   8013b4 <fd2data>
  8015e0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015e2:	89 34 24             	mov    %esi,(%esp)
  8015e5:	e8 ca fd ff ff       	call   8013b4 <fd2data>
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015ef:	89 d8                	mov    %ebx,%eax
  8015f1:	c1 e8 16             	shr    $0x16,%eax
  8015f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015fb:	a8 01                	test   $0x1,%al
  8015fd:	74 11                	je     801610 <dup+0x74>
  8015ff:	89 d8                	mov    %ebx,%eax
  801601:	c1 e8 0c             	shr    $0xc,%eax
  801604:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80160b:	f6 c2 01             	test   $0x1,%dl
  80160e:	75 39                	jne    801649 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801613:	89 d0                	mov    %edx,%eax
  801615:	c1 e8 0c             	shr    $0xc,%eax
  801618:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80161f:	83 ec 0c             	sub    $0xc,%esp
  801622:	25 07 0e 00 00       	and    $0xe07,%eax
  801627:	50                   	push   %eax
  801628:	56                   	push   %esi
  801629:	6a 00                	push   $0x0
  80162b:	52                   	push   %edx
  80162c:	6a 00                	push   $0x0
  80162e:	e8 10 f8 ff ff       	call   800e43 <sys_page_map>
  801633:	89 c3                	mov    %eax,%ebx
  801635:	83 c4 20             	add    $0x20,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 31                	js     80166d <dup+0xd1>
		goto err;

	return newfdnum;
  80163c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80163f:	89 d8                	mov    %ebx,%eax
  801641:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801644:	5b                   	pop    %ebx
  801645:	5e                   	pop    %esi
  801646:	5f                   	pop    %edi
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801649:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	25 07 0e 00 00       	and    $0xe07,%eax
  801658:	50                   	push   %eax
  801659:	57                   	push   %edi
  80165a:	6a 00                	push   $0x0
  80165c:	53                   	push   %ebx
  80165d:	6a 00                	push   $0x0
  80165f:	e8 df f7 ff ff       	call   800e43 <sys_page_map>
  801664:	89 c3                	mov    %eax,%ebx
  801666:	83 c4 20             	add    $0x20,%esp
  801669:	85 c0                	test   %eax,%eax
  80166b:	79 a3                	jns    801610 <dup+0x74>
	sys_page_unmap(0, newfd);
  80166d:	83 ec 08             	sub    $0x8,%esp
  801670:	56                   	push   %esi
  801671:	6a 00                	push   $0x0
  801673:	e8 0d f8 ff ff       	call   800e85 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801678:	83 c4 08             	add    $0x8,%esp
  80167b:	57                   	push   %edi
  80167c:	6a 00                	push   $0x0
  80167e:	e8 02 f8 ff ff       	call   800e85 <sys_page_unmap>
	return r;
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	eb b7                	jmp    80163f <dup+0xa3>

00801688 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	53                   	push   %ebx
  80168c:	83 ec 1c             	sub    $0x1c,%esp
  80168f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801692:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801695:	50                   	push   %eax
  801696:	53                   	push   %ebx
  801697:	e8 81 fd ff ff       	call   80141d <fd_lookup>
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	78 3f                	js     8016e2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a9:	50                   	push   %eax
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ad:	ff 30                	pushl  (%eax)
  8016af:	e8 b9 fd ff ff       	call   80146d <dev_lookup>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	78 27                	js     8016e2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016be:	8b 42 08             	mov    0x8(%edx),%eax
  8016c1:	83 e0 03             	and    $0x3,%eax
  8016c4:	83 f8 01             	cmp    $0x1,%eax
  8016c7:	74 1e                	je     8016e7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cc:	8b 40 08             	mov    0x8(%eax),%eax
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	74 35                	je     801708 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	ff 75 10             	pushl  0x10(%ebp)
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	52                   	push   %edx
  8016dd:	ff d0                	call   *%eax
  8016df:	83 c4 10             	add    $0x10,%esp
}
  8016e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016e7:	a1 20 44 80 00       	mov    0x804420,%eax
  8016ec:	8b 40 48             	mov    0x48(%eax),%eax
  8016ef:	83 ec 04             	sub    $0x4,%esp
  8016f2:	53                   	push   %ebx
  8016f3:	50                   	push   %eax
  8016f4:	68 1c 2b 80 00       	push   $0x802b1c
  8016f9:	e8 02 ec ff ff       	call   800300 <cprintf>
		return -E_INVAL;
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801706:	eb da                	jmp    8016e2 <read+0x5a>
		return -E_NOT_SUPP;
  801708:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170d:	eb d3                	jmp    8016e2 <read+0x5a>

0080170f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	57                   	push   %edi
  801713:	56                   	push   %esi
  801714:	53                   	push   %ebx
  801715:	83 ec 0c             	sub    $0xc,%esp
  801718:	8b 7d 08             	mov    0x8(%ebp),%edi
  80171b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80171e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801723:	39 f3                	cmp    %esi,%ebx
  801725:	73 23                	jae    80174a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801727:	83 ec 04             	sub    $0x4,%esp
  80172a:	89 f0                	mov    %esi,%eax
  80172c:	29 d8                	sub    %ebx,%eax
  80172e:	50                   	push   %eax
  80172f:	89 d8                	mov    %ebx,%eax
  801731:	03 45 0c             	add    0xc(%ebp),%eax
  801734:	50                   	push   %eax
  801735:	57                   	push   %edi
  801736:	e8 4d ff ff ff       	call   801688 <read>
		if (m < 0)
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 06                	js     801748 <readn+0x39>
			return m;
		if (m == 0)
  801742:	74 06                	je     80174a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801744:	01 c3                	add    %eax,%ebx
  801746:	eb db                	jmp    801723 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801748:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80174a:	89 d8                	mov    %ebx,%eax
  80174c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	53                   	push   %ebx
  801758:	83 ec 1c             	sub    $0x1c,%esp
  80175b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801761:	50                   	push   %eax
  801762:	53                   	push   %ebx
  801763:	e8 b5 fc ff ff       	call   80141d <fd_lookup>
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 3a                	js     8017a9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176f:	83 ec 08             	sub    $0x8,%esp
  801772:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801775:	50                   	push   %eax
  801776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801779:	ff 30                	pushl  (%eax)
  80177b:	e8 ed fc ff ff       	call   80146d <dev_lookup>
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	85 c0                	test   %eax,%eax
  801785:	78 22                	js     8017a9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80178e:	74 1e                	je     8017ae <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801793:	8b 52 0c             	mov    0xc(%edx),%edx
  801796:	85 d2                	test   %edx,%edx
  801798:	74 35                	je     8017cf <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	ff 75 10             	pushl  0x10(%ebp)
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	50                   	push   %eax
  8017a4:	ff d2                	call   *%edx
  8017a6:	83 c4 10             	add    $0x10,%esp
}
  8017a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ae:	a1 20 44 80 00       	mov    0x804420,%eax
  8017b3:	8b 40 48             	mov    0x48(%eax),%eax
  8017b6:	83 ec 04             	sub    $0x4,%esp
  8017b9:	53                   	push   %ebx
  8017ba:	50                   	push   %eax
  8017bb:	68 38 2b 80 00       	push   $0x802b38
  8017c0:	e8 3b eb ff ff       	call   800300 <cprintf>
		return -E_INVAL;
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cd:	eb da                	jmp    8017a9 <write+0x55>
		return -E_NOT_SUPP;
  8017cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017d4:	eb d3                	jmp    8017a9 <write+0x55>

008017d6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017df:	50                   	push   %eax
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	e8 35 fc ff ff       	call   80141d <fd_lookup>
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 0e                	js     8017fd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	53                   	push   %ebx
  801803:	83 ec 1c             	sub    $0x1c,%esp
  801806:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801809:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80180c:	50                   	push   %eax
  80180d:	53                   	push   %ebx
  80180e:	e8 0a fc ff ff       	call   80141d <fd_lookup>
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	85 c0                	test   %eax,%eax
  801818:	78 37                	js     801851 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181a:	83 ec 08             	sub    $0x8,%esp
  80181d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801820:	50                   	push   %eax
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	ff 30                	pushl  (%eax)
  801826:	e8 42 fc ff ff       	call   80146d <dev_lookup>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 1f                	js     801851 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801835:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801839:	74 1b                	je     801856 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80183b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183e:	8b 52 18             	mov    0x18(%edx),%edx
  801841:	85 d2                	test   %edx,%edx
  801843:	74 32                	je     801877 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801845:	83 ec 08             	sub    $0x8,%esp
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	50                   	push   %eax
  80184c:	ff d2                	call   *%edx
  80184e:	83 c4 10             	add    $0x10,%esp
}
  801851:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801854:	c9                   	leave  
  801855:	c3                   	ret    
			thisenv->env_id, fdnum);
  801856:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80185b:	8b 40 48             	mov    0x48(%eax),%eax
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	53                   	push   %ebx
  801862:	50                   	push   %eax
  801863:	68 f8 2a 80 00       	push   $0x802af8
  801868:	e8 93 ea ff ff       	call   800300 <cprintf>
		return -E_INVAL;
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801875:	eb da                	jmp    801851 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801877:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187c:	eb d3                	jmp    801851 <ftruncate+0x52>

0080187e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	53                   	push   %ebx
  801882:	83 ec 1c             	sub    $0x1c,%esp
  801885:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801888:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80188b:	50                   	push   %eax
  80188c:	ff 75 08             	pushl  0x8(%ebp)
  80188f:	e8 89 fb ff ff       	call   80141d <fd_lookup>
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	85 c0                	test   %eax,%eax
  801899:	78 4b                	js     8018e6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a1:	50                   	push   %eax
  8018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a5:	ff 30                	pushl  (%eax)
  8018a7:	e8 c1 fb ff ff       	call   80146d <dev_lookup>
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	78 33                	js     8018e6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018ba:	74 2f                	je     8018eb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018bc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018bf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018c6:	00 00 00 
	stat->st_isdir = 0;
  8018c9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018d0:	00 00 00 
	stat->st_dev = dev;
  8018d3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	53                   	push   %ebx
  8018dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e0:	ff 50 14             	call   *0x14(%eax)
  8018e3:	83 c4 10             	add    $0x10,%esp
}
  8018e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    
		return -E_NOT_SUPP;
  8018eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f0:	eb f4                	jmp    8018e6 <fstat+0x68>

008018f2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	56                   	push   %esi
  8018f6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	6a 00                	push   $0x0
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	e8 e7 01 00 00       	call   801aeb <open>
  801904:	89 c3                	mov    %eax,%ebx
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 1b                	js     801928 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	50                   	push   %eax
  801914:	e8 65 ff ff ff       	call   80187e <fstat>
  801919:	89 c6                	mov    %eax,%esi
	close(fd);
  80191b:	89 1c 24             	mov    %ebx,(%esp)
  80191e:	e8 27 fc ff ff       	call   80154a <close>
	return r;
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	89 f3                	mov    %esi,%ebx
}
  801928:	89 d8                	mov    %ebx,%eax
  80192a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5e                   	pop    %esi
  80192f:	5d                   	pop    %ebp
  801930:	c3                   	ret    

00801931 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	56                   	push   %esi
  801935:	53                   	push   %ebx
  801936:	89 c6                	mov    %eax,%esi
  801938:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80193a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801941:	74 27                	je     80196a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801943:	6a 07                	push   $0x7
  801945:	68 00 50 80 00       	push   $0x805000
  80194a:	56                   	push   %esi
  80194b:	ff 35 00 40 80 00    	pushl  0x804000
  801951:	e8 46 08 00 00       	call   80219c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801956:	83 c4 0c             	add    $0xc,%esp
  801959:	6a 00                	push   $0x0
  80195b:	53                   	push   %ebx
  80195c:	6a 00                	push   $0x0
  80195e:	e8 d2 07 00 00       	call   802135 <ipc_recv>
}
  801963:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801966:	5b                   	pop    %ebx
  801967:	5e                   	pop    %esi
  801968:	5d                   	pop    %ebp
  801969:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80196a:	83 ec 0c             	sub    $0xc,%esp
  80196d:	6a 01                	push   $0x1
  80196f:	e8 71 08 00 00       	call   8021e5 <ipc_find_env>
  801974:	a3 00 40 80 00       	mov    %eax,0x804000
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	eb c5                	jmp    801943 <fsipc+0x12>

0080197e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	8b 40 0c             	mov    0xc(%eax),%eax
  80198a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801997:	ba 00 00 00 00       	mov    $0x0,%edx
  80199c:	b8 02 00 00 00       	mov    $0x2,%eax
  8019a1:	e8 8b ff ff ff       	call   801931 <fsipc>
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <devfile_flush>:
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	b8 06 00 00 00       	mov    $0x6,%eax
  8019c3:	e8 69 ff ff ff       	call   801931 <fsipc>
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <devfile_stat>:
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	53                   	push   %ebx
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019da:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019df:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e4:	b8 05 00 00 00       	mov    $0x5,%eax
  8019e9:	e8 43 ff ff ff       	call   801931 <fsipc>
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 2c                	js     801a1e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	68 00 50 80 00       	push   $0x805000
  8019fa:	53                   	push   %ebx
  8019fb:	e8 0e f0 ff ff       	call   800a0e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a00:	a1 80 50 80 00       	mov    0x805080,%eax
  801a05:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a0b:	a1 84 50 80 00       	mov    0x805084,%eax
  801a10:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <devfile_write>:
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 0c             	sub    $0xc,%esp
  801a29:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a2c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2f:	8b 52 0c             	mov    0xc(%edx),%edx
  801a32:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801a38:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a3d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a42:	0f 47 c2             	cmova  %edx,%eax
  801a45:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a4a:	50                   	push   %eax
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	68 08 50 80 00       	push   $0x805008
  801a53:	e8 44 f1 ff ff       	call   800b9c <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a58:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5d:	b8 04 00 00 00       	mov    $0x4,%eax
  801a62:	e8 ca fe ff ff       	call   801931 <fsipc>
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <devfile_read>:
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	56                   	push   %esi
  801a6d:	53                   	push   %ebx
  801a6e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8b 40 0c             	mov    0xc(%eax),%eax
  801a77:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a7c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
  801a87:	b8 03 00 00 00       	mov    $0x3,%eax
  801a8c:	e8 a0 fe ff ff       	call   801931 <fsipc>
  801a91:	89 c3                	mov    %eax,%ebx
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 1f                	js     801ab6 <devfile_read+0x4d>
	assert(r <= n);
  801a97:	39 f0                	cmp    %esi,%eax
  801a99:	77 24                	ja     801abf <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a9b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aa0:	7f 33                	jg     801ad5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	50                   	push   %eax
  801aa6:	68 00 50 80 00       	push   $0x805000
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	e8 e9 f0 ff ff       	call   800b9c <memmove>
	return r;
  801ab3:	83 c4 10             	add    $0x10,%esp
}
  801ab6:	89 d8                	mov    %ebx,%eax
  801ab8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    
	assert(r <= n);
  801abf:	68 68 2b 80 00       	push   $0x802b68
  801ac4:	68 6f 2b 80 00       	push   $0x802b6f
  801ac9:	6a 7c                	push   $0x7c
  801acb:	68 84 2b 80 00       	push   $0x802b84
  801ad0:	e8 50 e7 ff ff       	call   800225 <_panic>
	assert(r <= PGSIZE);
  801ad5:	68 8f 2b 80 00       	push   $0x802b8f
  801ada:	68 6f 2b 80 00       	push   $0x802b6f
  801adf:	6a 7d                	push   $0x7d
  801ae1:	68 84 2b 80 00       	push   $0x802b84
  801ae6:	e8 3a e7 ff ff       	call   800225 <_panic>

00801aeb <open>:
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 1c             	sub    $0x1c,%esp
  801af3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801af6:	56                   	push   %esi
  801af7:	e8 d9 ee ff ff       	call   8009d5 <strlen>
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b04:	7f 6c                	jg     801b72 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0c:	50                   	push   %eax
  801b0d:	e8 b9 f8 ff ff       	call   8013cb <fd_alloc>
  801b12:	89 c3                	mov    %eax,%ebx
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 3c                	js     801b57 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b1b:	83 ec 08             	sub    $0x8,%esp
  801b1e:	56                   	push   %esi
  801b1f:	68 00 50 80 00       	push   $0x805000
  801b24:	e8 e5 ee ff ff       	call   800a0e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b34:	b8 01 00 00 00       	mov    $0x1,%eax
  801b39:	e8 f3 fd ff ff       	call   801931 <fsipc>
  801b3e:	89 c3                	mov    %eax,%ebx
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	85 c0                	test   %eax,%eax
  801b45:	78 19                	js     801b60 <open+0x75>
	return fd2num(fd);
  801b47:	83 ec 0c             	sub    $0xc,%esp
  801b4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4d:	e8 52 f8 ff ff       	call   8013a4 <fd2num>
  801b52:	89 c3                	mov    %eax,%ebx
  801b54:	83 c4 10             	add    $0x10,%esp
}
  801b57:	89 d8                	mov    %ebx,%eax
  801b59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5c:	5b                   	pop    %ebx
  801b5d:	5e                   	pop    %esi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    
		fd_close(fd, 0);
  801b60:	83 ec 08             	sub    $0x8,%esp
  801b63:	6a 00                	push   $0x0
  801b65:	ff 75 f4             	pushl  -0xc(%ebp)
  801b68:	e8 56 f9 ff ff       	call   8014c3 <fd_close>
		return r;
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	eb e5                	jmp    801b57 <open+0x6c>
		return -E_BAD_PATH;
  801b72:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b77:	eb de                	jmp    801b57 <open+0x6c>

00801b79 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b84:	b8 08 00 00 00       	mov    $0x8,%eax
  801b89:	e8 a3 fd ff ff       	call   801931 <fsipc>
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
  801b95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b98:	83 ec 0c             	sub    $0xc,%esp
  801b9b:	ff 75 08             	pushl  0x8(%ebp)
  801b9e:	e8 11 f8 ff ff       	call   8013b4 <fd2data>
  801ba3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ba5:	83 c4 08             	add    $0x8,%esp
  801ba8:	68 9b 2b 80 00       	push   $0x802b9b
  801bad:	53                   	push   %ebx
  801bae:	e8 5b ee ff ff       	call   800a0e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bb3:	8b 46 04             	mov    0x4(%esi),%eax
  801bb6:	2b 06                	sub    (%esi),%eax
  801bb8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bbe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bc5:	00 00 00 
	stat->st_dev = &devpipe;
  801bc8:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bcf:	30 80 00 
	return 0;
}
  801bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bda:	5b                   	pop    %ebx
  801bdb:	5e                   	pop    %esi
  801bdc:	5d                   	pop    %ebp
  801bdd:	c3                   	ret    

00801bde <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	53                   	push   %ebx
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801be8:	53                   	push   %ebx
  801be9:	6a 00                	push   $0x0
  801beb:	e8 95 f2 ff ff       	call   800e85 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bf0:	89 1c 24             	mov    %ebx,(%esp)
  801bf3:	e8 bc f7 ff ff       	call   8013b4 <fd2data>
  801bf8:	83 c4 08             	add    $0x8,%esp
  801bfb:	50                   	push   %eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	e8 82 f2 ff ff       	call   800e85 <sys_page_unmap>
}
  801c03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <_pipeisclosed>:
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	57                   	push   %edi
  801c0c:	56                   	push   %esi
  801c0d:	53                   	push   %ebx
  801c0e:	83 ec 1c             	sub    $0x1c,%esp
  801c11:	89 c7                	mov    %eax,%edi
  801c13:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c15:	a1 20 44 80 00       	mov    0x804420,%eax
  801c1a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c1d:	83 ec 0c             	sub    $0xc,%esp
  801c20:	57                   	push   %edi
  801c21:	e8 fe 05 00 00       	call   802224 <pageref>
  801c26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c29:	89 34 24             	mov    %esi,(%esp)
  801c2c:	e8 f3 05 00 00       	call   802224 <pageref>
		nn = thisenv->env_runs;
  801c31:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801c37:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	39 cb                	cmp    %ecx,%ebx
  801c3f:	74 1b                	je     801c5c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c41:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c44:	75 cf                	jne    801c15 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c46:	8b 42 58             	mov    0x58(%edx),%eax
  801c49:	6a 01                	push   $0x1
  801c4b:	50                   	push   %eax
  801c4c:	53                   	push   %ebx
  801c4d:	68 a2 2b 80 00       	push   $0x802ba2
  801c52:	e8 a9 e6 ff ff       	call   800300 <cprintf>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	eb b9                	jmp    801c15 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c5c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c5f:	0f 94 c0             	sete   %al
  801c62:	0f b6 c0             	movzbl %al,%eax
}
  801c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c68:	5b                   	pop    %ebx
  801c69:	5e                   	pop    %esi
  801c6a:	5f                   	pop    %edi
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <devpipe_write>:
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	57                   	push   %edi
  801c71:	56                   	push   %esi
  801c72:	53                   	push   %ebx
  801c73:	83 ec 28             	sub    $0x28,%esp
  801c76:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c79:	56                   	push   %esi
  801c7a:	e8 35 f7 ff ff       	call   8013b4 <fd2data>
  801c7f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	bf 00 00 00 00       	mov    $0x0,%edi
  801c89:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c8c:	74 4f                	je     801cdd <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c8e:	8b 43 04             	mov    0x4(%ebx),%eax
  801c91:	8b 0b                	mov    (%ebx),%ecx
  801c93:	8d 51 20             	lea    0x20(%ecx),%edx
  801c96:	39 d0                	cmp    %edx,%eax
  801c98:	72 14                	jb     801cae <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c9a:	89 da                	mov    %ebx,%edx
  801c9c:	89 f0                	mov    %esi,%eax
  801c9e:	e8 65 ff ff ff       	call   801c08 <_pipeisclosed>
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	75 3b                	jne    801ce2 <devpipe_write+0x75>
			sys_yield();
  801ca7:	e8 35 f1 ff ff       	call   800de1 <sys_yield>
  801cac:	eb e0                	jmp    801c8e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cb5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cb8:	89 c2                	mov    %eax,%edx
  801cba:	c1 fa 1f             	sar    $0x1f,%edx
  801cbd:	89 d1                	mov    %edx,%ecx
  801cbf:	c1 e9 1b             	shr    $0x1b,%ecx
  801cc2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cc5:	83 e2 1f             	and    $0x1f,%edx
  801cc8:	29 ca                	sub    %ecx,%edx
  801cca:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cce:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cd2:	83 c0 01             	add    $0x1,%eax
  801cd5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cd8:	83 c7 01             	add    $0x1,%edi
  801cdb:	eb ac                	jmp    801c89 <devpipe_write+0x1c>
	return i;
  801cdd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce0:	eb 05                	jmp    801ce7 <devpipe_write+0x7a>
				return 0;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5f                   	pop    %edi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    

00801cef <devpipe_read>:
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	57                   	push   %edi
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	83 ec 18             	sub    $0x18,%esp
  801cf8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cfb:	57                   	push   %edi
  801cfc:	e8 b3 f6 ff ff       	call   8013b4 <fd2data>
  801d01:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d03:	83 c4 10             	add    $0x10,%esp
  801d06:	be 00 00 00 00       	mov    $0x0,%esi
  801d0b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d0e:	75 14                	jne    801d24 <devpipe_read+0x35>
	return i;
  801d10:	8b 45 10             	mov    0x10(%ebp),%eax
  801d13:	eb 02                	jmp    801d17 <devpipe_read+0x28>
				return i;
  801d15:	89 f0                	mov    %esi,%eax
}
  801d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1a:	5b                   	pop    %ebx
  801d1b:	5e                   	pop    %esi
  801d1c:	5f                   	pop    %edi
  801d1d:	5d                   	pop    %ebp
  801d1e:	c3                   	ret    
			sys_yield();
  801d1f:	e8 bd f0 ff ff       	call   800de1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d24:	8b 03                	mov    (%ebx),%eax
  801d26:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d29:	75 18                	jne    801d43 <devpipe_read+0x54>
			if (i > 0)
  801d2b:	85 f6                	test   %esi,%esi
  801d2d:	75 e6                	jne    801d15 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d2f:	89 da                	mov    %ebx,%edx
  801d31:	89 f8                	mov    %edi,%eax
  801d33:	e8 d0 fe ff ff       	call   801c08 <_pipeisclosed>
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	74 e3                	je     801d1f <devpipe_read+0x30>
				return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d41:	eb d4                	jmp    801d17 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d43:	99                   	cltd   
  801d44:	c1 ea 1b             	shr    $0x1b,%edx
  801d47:	01 d0                	add    %edx,%eax
  801d49:	83 e0 1f             	and    $0x1f,%eax
  801d4c:	29 d0                	sub    %edx,%eax
  801d4e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d56:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d59:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d5c:	83 c6 01             	add    $0x1,%esi
  801d5f:	eb aa                	jmp    801d0b <devpipe_read+0x1c>

00801d61 <pipe>:
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	56                   	push   %esi
  801d65:	53                   	push   %ebx
  801d66:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6c:	50                   	push   %eax
  801d6d:	e8 59 f6 ff ff       	call   8013cb <fd_alloc>
  801d72:	89 c3                	mov    %eax,%ebx
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	85 c0                	test   %eax,%eax
  801d79:	0f 88 23 01 00 00    	js     801ea2 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	68 07 04 00 00       	push   $0x407
  801d87:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8a:	6a 00                	push   $0x0
  801d8c:	e8 6f f0 ff ff       	call   800e00 <sys_page_alloc>
  801d91:	89 c3                	mov    %eax,%ebx
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	85 c0                	test   %eax,%eax
  801d98:	0f 88 04 01 00 00    	js     801ea2 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d9e:	83 ec 0c             	sub    $0xc,%esp
  801da1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801da4:	50                   	push   %eax
  801da5:	e8 21 f6 ff ff       	call   8013cb <fd_alloc>
  801daa:	89 c3                	mov    %eax,%ebx
  801dac:	83 c4 10             	add    $0x10,%esp
  801daf:	85 c0                	test   %eax,%eax
  801db1:	0f 88 db 00 00 00    	js     801e92 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	68 07 04 00 00       	push   $0x407
  801dbf:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc2:	6a 00                	push   $0x0
  801dc4:	e8 37 f0 ff ff       	call   800e00 <sys_page_alloc>
  801dc9:	89 c3                	mov    %eax,%ebx
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	0f 88 bc 00 00 00    	js     801e92 <pipe+0x131>
	va = fd2data(fd0);
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddc:	e8 d3 f5 ff ff       	call   8013b4 <fd2data>
  801de1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de3:	83 c4 0c             	add    $0xc,%esp
  801de6:	68 07 04 00 00       	push   $0x407
  801deb:	50                   	push   %eax
  801dec:	6a 00                	push   $0x0
  801dee:	e8 0d f0 ff ff       	call   800e00 <sys_page_alloc>
  801df3:	89 c3                	mov    %eax,%ebx
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	0f 88 82 00 00 00    	js     801e82 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	ff 75 f0             	pushl  -0x10(%ebp)
  801e06:	e8 a9 f5 ff ff       	call   8013b4 <fd2data>
  801e0b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e12:	50                   	push   %eax
  801e13:	6a 00                	push   $0x0
  801e15:	56                   	push   %esi
  801e16:	6a 00                	push   $0x0
  801e18:	e8 26 f0 ff ff       	call   800e43 <sys_page_map>
  801e1d:	89 c3                	mov    %eax,%ebx
  801e1f:	83 c4 20             	add    $0x20,%esp
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 4e                	js     801e74 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e26:	a1 20 30 80 00       	mov    0x803020,%eax
  801e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e33:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e3d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e42:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	e8 50 f5 ff ff       	call   8013a4 <fd2num>
  801e54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e57:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e59:	83 c4 04             	add    $0x4,%esp
  801e5c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5f:	e8 40 f5 ff ff       	call   8013a4 <fd2num>
  801e64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e67:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e72:	eb 2e                	jmp    801ea2 <pipe+0x141>
	sys_page_unmap(0, va);
  801e74:	83 ec 08             	sub    $0x8,%esp
  801e77:	56                   	push   %esi
  801e78:	6a 00                	push   $0x0
  801e7a:	e8 06 f0 ff ff       	call   800e85 <sys_page_unmap>
  801e7f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e82:	83 ec 08             	sub    $0x8,%esp
  801e85:	ff 75 f0             	pushl  -0x10(%ebp)
  801e88:	6a 00                	push   $0x0
  801e8a:	e8 f6 ef ff ff       	call   800e85 <sys_page_unmap>
  801e8f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e92:	83 ec 08             	sub    $0x8,%esp
  801e95:	ff 75 f4             	pushl  -0xc(%ebp)
  801e98:	6a 00                	push   $0x0
  801e9a:	e8 e6 ef ff ff       	call   800e85 <sys_page_unmap>
  801e9f:	83 c4 10             	add    $0x10,%esp
}
  801ea2:	89 d8                	mov    %ebx,%eax
  801ea4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <pipeisclosed>:
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb4:	50                   	push   %eax
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	e8 60 f5 ff ff       	call   80141d <fd_lookup>
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	78 18                	js     801edc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eca:	e8 e5 f4 ff ff       	call   8013b4 <fd2data>
	return _pipeisclosed(fd, p);
  801ecf:	89 c2                	mov    %eax,%edx
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	e8 2f fd ff ff       	call   801c08 <_pipeisclosed>
  801ed9:	83 c4 10             	add    $0x10,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	56                   	push   %esi
  801ee2:	53                   	push   %ebx
  801ee3:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801ee6:	85 f6                	test   %esi,%esi
  801ee8:	74 15                	je     801eff <wait+0x21>
	e = &envs[ENVX(envid)];
  801eea:	89 f0                	mov    %esi,%eax
  801eec:	25 ff 03 00 00       	and    $0x3ff,%eax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801ef1:	8d 1c c0             	lea    (%eax,%eax,8),%ebx
  801ef4:	c1 e3 04             	shl    $0x4,%ebx
  801ef7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801efd:	eb 1b                	jmp    801f1a <wait+0x3c>
	assert(envid != 0);
  801eff:	68 ba 2b 80 00       	push   $0x802bba
  801f04:	68 6f 2b 80 00       	push   $0x802b6f
  801f09:	6a 09                	push   $0x9
  801f0b:	68 c5 2b 80 00       	push   $0x802bc5
  801f10:	e8 10 e3 ff ff       	call   800225 <_panic>
		sys_yield();
  801f15:	e8 c7 ee ff ff       	call   800de1 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f1a:	8b 43 48             	mov    0x48(%ebx),%eax
  801f1d:	39 f0                	cmp    %esi,%eax
  801f1f:	75 07                	jne    801f28 <wait+0x4a>
  801f21:	8b 43 54             	mov    0x54(%ebx),%eax
  801f24:	85 c0                	test   %eax,%eax
  801f26:	75 ed                	jne    801f15 <wait+0x37>
}
  801f28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5d                   	pop    %ebp
  801f2e:	c3                   	ret    

00801f2f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f34:	c3                   	ret    

00801f35 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f3b:	68 d0 2b 80 00       	push   $0x802bd0
  801f40:	ff 75 0c             	pushl  0xc(%ebp)
  801f43:	e8 c6 ea ff ff       	call   800a0e <strcpy>
	return 0;
}
  801f48:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <devcons_write>:
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	57                   	push   %edi
  801f53:	56                   	push   %esi
  801f54:	53                   	push   %ebx
  801f55:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f5b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f60:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f66:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f69:	73 31                	jae    801f9c <devcons_write+0x4d>
		m = n - tot;
  801f6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f6e:	29 f3                	sub    %esi,%ebx
  801f70:	83 fb 7f             	cmp    $0x7f,%ebx
  801f73:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f78:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f7b:	83 ec 04             	sub    $0x4,%esp
  801f7e:	53                   	push   %ebx
  801f7f:	89 f0                	mov    %esi,%eax
  801f81:	03 45 0c             	add    0xc(%ebp),%eax
  801f84:	50                   	push   %eax
  801f85:	57                   	push   %edi
  801f86:	e8 11 ec ff ff       	call   800b9c <memmove>
		sys_cputs(buf, m);
  801f8b:	83 c4 08             	add    $0x8,%esp
  801f8e:	53                   	push   %ebx
  801f8f:	57                   	push   %edi
  801f90:	e8 af ed ff ff       	call   800d44 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f95:	01 de                	add    %ebx,%esi
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	eb ca                	jmp    801f66 <devcons_write+0x17>
}
  801f9c:	89 f0                	mov    %esi,%eax
  801f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa1:	5b                   	pop    %ebx
  801fa2:	5e                   	pop    %esi
  801fa3:	5f                   	pop    %edi
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    

00801fa6 <devcons_read>:
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb5:	74 21                	je     801fd8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801fb7:	e8 a6 ed ff ff       	call   800d62 <sys_cgetc>
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	75 07                	jne    801fc7 <devcons_read+0x21>
		sys_yield();
  801fc0:	e8 1c ee ff ff       	call   800de1 <sys_yield>
  801fc5:	eb f0                	jmp    801fb7 <devcons_read+0x11>
	if (c < 0)
  801fc7:	78 0f                	js     801fd8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801fc9:	83 f8 04             	cmp    $0x4,%eax
  801fcc:	74 0c                	je     801fda <devcons_read+0x34>
	*(char*)vbuf = c;
  801fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd1:	88 02                	mov    %al,(%edx)
	return 1;
  801fd3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    
		return 0;
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdf:	eb f7                	jmp    801fd8 <devcons_read+0x32>

00801fe1 <cputchar>:
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fed:	6a 01                	push   $0x1
  801fef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff2:	50                   	push   %eax
  801ff3:	e8 4c ed ff ff       	call   800d44 <sys_cputs>
}
  801ff8:	83 c4 10             	add    $0x10,%esp
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <getchar>:
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802003:	6a 01                	push   $0x1
  802005:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802008:	50                   	push   %eax
  802009:	6a 00                	push   $0x0
  80200b:	e8 78 f6 ff ff       	call   801688 <read>
	if (r < 0)
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	85 c0                	test   %eax,%eax
  802015:	78 06                	js     80201d <getchar+0x20>
	if (r < 1)
  802017:	74 06                	je     80201f <getchar+0x22>
	return c;
  802019:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    
		return -E_EOF;
  80201f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802024:	eb f7                	jmp    80201d <getchar+0x20>

00802026 <iscons>:
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80202c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202f:	50                   	push   %eax
  802030:	ff 75 08             	pushl  0x8(%ebp)
  802033:	e8 e5 f3 ff ff       	call   80141d <fd_lookup>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	85 c0                	test   %eax,%eax
  80203d:	78 11                	js     802050 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802048:	39 10                	cmp    %edx,(%eax)
  80204a:	0f 94 c0             	sete   %al
  80204d:	0f b6 c0             	movzbl %al,%eax
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <opencons>:
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802058:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205b:	50                   	push   %eax
  80205c:	e8 6a f3 ff ff       	call   8013cb <fd_alloc>
  802061:	83 c4 10             	add    $0x10,%esp
  802064:	85 c0                	test   %eax,%eax
  802066:	78 3a                	js     8020a2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	68 07 04 00 00       	push   $0x407
  802070:	ff 75 f4             	pushl  -0xc(%ebp)
  802073:	6a 00                	push   $0x0
  802075:	e8 86 ed ff ff       	call   800e00 <sys_page_alloc>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	85 c0                	test   %eax,%eax
  80207f:	78 21                	js     8020a2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80208a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802096:	83 ec 0c             	sub    $0xc,%esp
  802099:	50                   	push   %eax
  80209a:	e8 05 f3 ff ff       	call   8013a4 <fd2num>
  80209f:	83 c4 10             	add    $0x10,%esp
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020aa:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020b1:	74 0a                	je     8020bd <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8020bd:	83 ec 04             	sub    $0x4,%esp
  8020c0:	6a 07                	push   $0x7
  8020c2:	68 00 f0 bf ee       	push   $0xeebff000
  8020c7:	6a 00                	push   $0x0
  8020c9:	e8 32 ed ff ff       	call   800e00 <sys_page_alloc>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 28                	js     8020fd <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8020d5:	83 ec 08             	sub    $0x8,%esp
  8020d8:	68 0f 21 80 00       	push   $0x80210f
  8020dd:	6a 00                	push   $0x0
  8020df:	e8 a8 ee ff ff       	call   800f8c <sys_env_set_pgfault_upcall>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	79 c8                	jns    8020b3 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8020eb:	50                   	push   %eax
  8020ec:	68 34 2a 80 00       	push   $0x802a34
  8020f1:	6a 23                	push   $0x23
  8020f3:	68 f4 2b 80 00       	push   $0x802bf4
  8020f8:	e8 28 e1 ff ff       	call   800225 <_panic>
			panic("set_pgfault_handler %e\n",r);
  8020fd:	50                   	push   %eax
  8020fe:	68 dc 2b 80 00       	push   $0x802bdc
  802103:	6a 21                	push   $0x21
  802105:	68 f4 2b 80 00       	push   $0x802bf4
  80210a:	e8 16 e1 ff ff       	call   800225 <_panic>

0080210f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80210f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802110:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802115:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802117:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  80211a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  80211e:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802122:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802125:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802127:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80212b:	83 c4 08             	add    $0x8,%esp
	popal
  80212e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80212f:	83 c4 04             	add    $0x4,%esp
	popfl
  802132:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802133:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802134:	c3                   	ret    

00802135 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	56                   	push   %esi
  802139:	53                   	push   %ebx
  80213a:	8b 75 08             	mov    0x8(%ebp),%esi
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  802143:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802145:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80214a:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  80214d:	83 ec 0c             	sub    $0xc,%esp
  802150:	50                   	push   %eax
  802151:	e8 9b ee ff ff       	call   800ff1 <sys_ipc_recv>
	if (from_env_store)
  802156:	83 c4 10             	add    $0x10,%esp
  802159:	85 f6                	test   %esi,%esi
  80215b:	74 14                	je     802171 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  80215d:	ba 00 00 00 00       	mov    $0x0,%edx
  802162:	85 c0                	test   %eax,%eax
  802164:	78 09                	js     80216f <ipc_recv+0x3a>
  802166:	8b 15 20 44 80 00    	mov    0x804420,%edx
  80216c:	8b 52 78             	mov    0x78(%edx),%edx
  80216f:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  802171:	85 db                	test   %ebx,%ebx
  802173:	74 14                	je     802189 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  802175:	ba 00 00 00 00       	mov    $0x0,%edx
  80217a:	85 c0                	test   %eax,%eax
  80217c:	78 09                	js     802187 <ipc_recv+0x52>
  80217e:	8b 15 20 44 80 00    	mov    0x804420,%edx
  802184:	8b 52 7c             	mov    0x7c(%edx),%edx
  802187:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  802189:	85 c0                	test   %eax,%eax
  80218b:	78 08                	js     802195 <ipc_recv+0x60>
  80218d:	a1 20 44 80 00       	mov    0x804420,%eax
  802192:	8b 40 74             	mov    0x74(%eax),%eax
}
  802195:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802198:	5b                   	pop    %ebx
  802199:	5e                   	pop    %esi
  80219a:	5d                   	pop    %ebp
  80219b:	c3                   	ret    

0080219c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 08             	sub    $0x8,%esp
  8021a2:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ac:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8021af:	ff 75 14             	pushl  0x14(%ebp)
  8021b2:	50                   	push   %eax
  8021b3:	ff 75 0c             	pushl  0xc(%ebp)
  8021b6:	ff 75 08             	pushl  0x8(%ebp)
  8021b9:	e8 10 ee ff ff       	call   800fce <sys_ipc_try_send>
  8021be:	83 c4 10             	add    $0x10,%esp
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	78 02                	js     8021c7 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  8021c7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021ca:	75 07                	jne    8021d3 <ipc_send+0x37>
		sys_yield();
  8021cc:	e8 10 ec ff ff       	call   800de1 <sys_yield>
}
  8021d1:	eb f2                	jmp    8021c5 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  8021d3:	50                   	push   %eax
  8021d4:	68 02 2c 80 00       	push   $0x802c02
  8021d9:	6a 3c                	push   $0x3c
  8021db:	68 16 2c 80 00       	push   $0x802c16
  8021e0:	e8 40 e0 ff ff       	call   800225 <_panic>

008021e5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021eb:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  8021f0:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8021f3:	c1 e0 04             	shl    $0x4,%eax
  8021f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021fb:	8b 40 50             	mov    0x50(%eax),%eax
  8021fe:	39 c8                	cmp    %ecx,%eax
  802200:	74 12                	je     802214 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802202:	83 c2 01             	add    $0x1,%edx
  802205:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80220b:	75 e3                	jne    8021f0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax
  802212:	eb 0e                	jmp    802222 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802214:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802217:	c1 e0 04             	shl    $0x4,%eax
  80221a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80221f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802222:	5d                   	pop    %ebp
  802223:	c3                   	ret    

00802224 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	c1 e8 16             	shr    $0x16,%eax
  80222f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80223b:	f6 c1 01             	test   $0x1,%cl
  80223e:	74 1d                	je     80225d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802240:	c1 ea 0c             	shr    $0xc,%edx
  802243:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80224a:	f6 c2 01             	test   $0x1,%dl
  80224d:	74 0e                	je     80225d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80224f:	c1 ea 0c             	shr    $0xc,%edx
  802252:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802259:	ef 
  80225a:	0f b7 c0             	movzwl %ax,%eax
}
  80225d:	5d                   	pop    %ebp
  80225e:	c3                   	ret    
  80225f:	90                   	nop

00802260 <__udivdi3>:
  802260:	55                   	push   %ebp
  802261:	57                   	push   %edi
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
  802264:	83 ec 1c             	sub    $0x1c,%esp
  802267:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80226b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80226f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802273:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802277:	85 d2                	test   %edx,%edx
  802279:	75 4d                	jne    8022c8 <__udivdi3+0x68>
  80227b:	39 f3                	cmp    %esi,%ebx
  80227d:	76 19                	jbe    802298 <__udivdi3+0x38>
  80227f:	31 ff                	xor    %edi,%edi
  802281:	89 e8                	mov    %ebp,%eax
  802283:	89 f2                	mov    %esi,%edx
  802285:	f7 f3                	div    %ebx
  802287:	89 fa                	mov    %edi,%edx
  802289:	83 c4 1c             	add    $0x1c,%esp
  80228c:	5b                   	pop    %ebx
  80228d:	5e                   	pop    %esi
  80228e:	5f                   	pop    %edi
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    
  802291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802298:	89 d9                	mov    %ebx,%ecx
  80229a:	85 db                	test   %ebx,%ebx
  80229c:	75 0b                	jne    8022a9 <__udivdi3+0x49>
  80229e:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a3:	31 d2                	xor    %edx,%edx
  8022a5:	f7 f3                	div    %ebx
  8022a7:	89 c1                	mov    %eax,%ecx
  8022a9:	31 d2                	xor    %edx,%edx
  8022ab:	89 f0                	mov    %esi,%eax
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 c6                	mov    %eax,%esi
  8022b1:	89 e8                	mov    %ebp,%eax
  8022b3:	89 f7                	mov    %esi,%edi
  8022b5:	f7 f1                	div    %ecx
  8022b7:	89 fa                	mov    %edi,%edx
  8022b9:	83 c4 1c             	add    $0x1c,%esp
  8022bc:	5b                   	pop    %ebx
  8022bd:	5e                   	pop    %esi
  8022be:	5f                   	pop    %edi
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    
  8022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c8:	39 f2                	cmp    %esi,%edx
  8022ca:	77 1c                	ja     8022e8 <__udivdi3+0x88>
  8022cc:	0f bd fa             	bsr    %edx,%edi
  8022cf:	83 f7 1f             	xor    $0x1f,%edi
  8022d2:	75 2c                	jne    802300 <__udivdi3+0xa0>
  8022d4:	39 f2                	cmp    %esi,%edx
  8022d6:	72 06                	jb     8022de <__udivdi3+0x7e>
  8022d8:	31 c0                	xor    %eax,%eax
  8022da:	39 eb                	cmp    %ebp,%ebx
  8022dc:	77 a9                	ja     802287 <__udivdi3+0x27>
  8022de:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e3:	eb a2                	jmp    802287 <__udivdi3+0x27>
  8022e5:	8d 76 00             	lea    0x0(%esi),%esi
  8022e8:	31 ff                	xor    %edi,%edi
  8022ea:	31 c0                	xor    %eax,%eax
  8022ec:	89 fa                	mov    %edi,%edx
  8022ee:	83 c4 1c             	add    $0x1c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	89 f9                	mov    %edi,%ecx
  802302:	b8 20 00 00 00       	mov    $0x20,%eax
  802307:	29 f8                	sub    %edi,%eax
  802309:	d3 e2                	shl    %cl,%edx
  80230b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80230f:	89 c1                	mov    %eax,%ecx
  802311:	89 da                	mov    %ebx,%edx
  802313:	d3 ea                	shr    %cl,%edx
  802315:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802319:	09 d1                	or     %edx,%ecx
  80231b:	89 f2                	mov    %esi,%edx
  80231d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802321:	89 f9                	mov    %edi,%ecx
  802323:	d3 e3                	shl    %cl,%ebx
  802325:	89 c1                	mov    %eax,%ecx
  802327:	d3 ea                	shr    %cl,%edx
  802329:	89 f9                	mov    %edi,%ecx
  80232b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80232f:	89 eb                	mov    %ebp,%ebx
  802331:	d3 e6                	shl    %cl,%esi
  802333:	89 c1                	mov    %eax,%ecx
  802335:	d3 eb                	shr    %cl,%ebx
  802337:	09 de                	or     %ebx,%esi
  802339:	89 f0                	mov    %esi,%eax
  80233b:	f7 74 24 08          	divl   0x8(%esp)
  80233f:	89 d6                	mov    %edx,%esi
  802341:	89 c3                	mov    %eax,%ebx
  802343:	f7 64 24 0c          	mull   0xc(%esp)
  802347:	39 d6                	cmp    %edx,%esi
  802349:	72 15                	jb     802360 <__udivdi3+0x100>
  80234b:	89 f9                	mov    %edi,%ecx
  80234d:	d3 e5                	shl    %cl,%ebp
  80234f:	39 c5                	cmp    %eax,%ebp
  802351:	73 04                	jae    802357 <__udivdi3+0xf7>
  802353:	39 d6                	cmp    %edx,%esi
  802355:	74 09                	je     802360 <__udivdi3+0x100>
  802357:	89 d8                	mov    %ebx,%eax
  802359:	31 ff                	xor    %edi,%edi
  80235b:	e9 27 ff ff ff       	jmp    802287 <__udivdi3+0x27>
  802360:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802363:	31 ff                	xor    %edi,%edi
  802365:	e9 1d ff ff ff       	jmp    802287 <__udivdi3+0x27>
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	66 90                	xchg   %ax,%ax
  80236e:	66 90                	xchg   %ax,%ax

00802370 <__umoddi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80237b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80237f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802387:	89 da                	mov    %ebx,%edx
  802389:	85 c0                	test   %eax,%eax
  80238b:	75 43                	jne    8023d0 <__umoddi3+0x60>
  80238d:	39 df                	cmp    %ebx,%edi
  80238f:	76 17                	jbe    8023a8 <__umoddi3+0x38>
  802391:	89 f0                	mov    %esi,%eax
  802393:	f7 f7                	div    %edi
  802395:	89 d0                	mov    %edx,%eax
  802397:	31 d2                	xor    %edx,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	89 fd                	mov    %edi,%ebp
  8023aa:	85 ff                	test   %edi,%edi
  8023ac:	75 0b                	jne    8023b9 <__umoddi3+0x49>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f7                	div    %edi
  8023b7:	89 c5                	mov    %eax,%ebp
  8023b9:	89 d8                	mov    %ebx,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	f7 f5                	div    %ebp
  8023bf:	89 f0                	mov    %esi,%eax
  8023c1:	f7 f5                	div    %ebp
  8023c3:	89 d0                	mov    %edx,%eax
  8023c5:	eb d0                	jmp    802397 <__umoddi3+0x27>
  8023c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ce:	66 90                	xchg   %ax,%ax
  8023d0:	89 f1                	mov    %esi,%ecx
  8023d2:	39 d8                	cmp    %ebx,%eax
  8023d4:	76 0a                	jbe    8023e0 <__umoddi3+0x70>
  8023d6:	89 f0                	mov    %esi,%eax
  8023d8:	83 c4 1c             	add    $0x1c,%esp
  8023db:	5b                   	pop    %ebx
  8023dc:	5e                   	pop    %esi
  8023dd:	5f                   	pop    %edi
  8023de:	5d                   	pop    %ebp
  8023df:	c3                   	ret    
  8023e0:	0f bd e8             	bsr    %eax,%ebp
  8023e3:	83 f5 1f             	xor    $0x1f,%ebp
  8023e6:	75 20                	jne    802408 <__umoddi3+0x98>
  8023e8:	39 d8                	cmp    %ebx,%eax
  8023ea:	0f 82 b0 00 00 00    	jb     8024a0 <__umoddi3+0x130>
  8023f0:	39 f7                	cmp    %esi,%edi
  8023f2:	0f 86 a8 00 00 00    	jbe    8024a0 <__umoddi3+0x130>
  8023f8:	89 c8                	mov    %ecx,%eax
  8023fa:	83 c4 1c             	add    $0x1c,%esp
  8023fd:	5b                   	pop    %ebx
  8023fe:	5e                   	pop    %esi
  8023ff:	5f                   	pop    %edi
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    
  802402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802408:	89 e9                	mov    %ebp,%ecx
  80240a:	ba 20 00 00 00       	mov    $0x20,%edx
  80240f:	29 ea                	sub    %ebp,%edx
  802411:	d3 e0                	shl    %cl,%eax
  802413:	89 44 24 08          	mov    %eax,0x8(%esp)
  802417:	89 d1                	mov    %edx,%ecx
  802419:	89 f8                	mov    %edi,%eax
  80241b:	d3 e8                	shr    %cl,%eax
  80241d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802421:	89 54 24 04          	mov    %edx,0x4(%esp)
  802425:	8b 54 24 04          	mov    0x4(%esp),%edx
  802429:	09 c1                	or     %eax,%ecx
  80242b:	89 d8                	mov    %ebx,%eax
  80242d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802431:	89 e9                	mov    %ebp,%ecx
  802433:	d3 e7                	shl    %cl,%edi
  802435:	89 d1                	mov    %edx,%ecx
  802437:	d3 e8                	shr    %cl,%eax
  802439:	89 e9                	mov    %ebp,%ecx
  80243b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80243f:	d3 e3                	shl    %cl,%ebx
  802441:	89 c7                	mov    %eax,%edi
  802443:	89 d1                	mov    %edx,%ecx
  802445:	89 f0                	mov    %esi,%eax
  802447:	d3 e8                	shr    %cl,%eax
  802449:	89 e9                	mov    %ebp,%ecx
  80244b:	89 fa                	mov    %edi,%edx
  80244d:	d3 e6                	shl    %cl,%esi
  80244f:	09 d8                	or     %ebx,%eax
  802451:	f7 74 24 08          	divl   0x8(%esp)
  802455:	89 d1                	mov    %edx,%ecx
  802457:	89 f3                	mov    %esi,%ebx
  802459:	f7 64 24 0c          	mull   0xc(%esp)
  80245d:	89 c6                	mov    %eax,%esi
  80245f:	89 d7                	mov    %edx,%edi
  802461:	39 d1                	cmp    %edx,%ecx
  802463:	72 06                	jb     80246b <__umoddi3+0xfb>
  802465:	75 10                	jne    802477 <__umoddi3+0x107>
  802467:	39 c3                	cmp    %eax,%ebx
  802469:	73 0c                	jae    802477 <__umoddi3+0x107>
  80246b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80246f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802473:	89 d7                	mov    %edx,%edi
  802475:	89 c6                	mov    %eax,%esi
  802477:	89 ca                	mov    %ecx,%edx
  802479:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80247e:	29 f3                	sub    %esi,%ebx
  802480:	19 fa                	sbb    %edi,%edx
  802482:	89 d0                	mov    %edx,%eax
  802484:	d3 e0                	shl    %cl,%eax
  802486:	89 e9                	mov    %ebp,%ecx
  802488:	d3 eb                	shr    %cl,%ebx
  80248a:	d3 ea                	shr    %cl,%edx
  80248c:	09 d8                	or     %ebx,%eax
  80248e:	83 c4 1c             	add    $0x1c,%esp
  802491:	5b                   	pop    %ebx
  802492:	5e                   	pop    %esi
  802493:	5f                   	pop    %edi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    
  802496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	89 da                	mov    %ebx,%edx
  8024a2:	29 fe                	sub    %edi,%esi
  8024a4:	19 c2                	sbb    %eax,%edx
  8024a6:	89 f1                	mov    %esi,%ecx
  8024a8:	89 c8                	mov    %ecx,%eax
  8024aa:	e9 4b ff ff ff       	jmp    8023fa <__umoddi3+0x8a>
