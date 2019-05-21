
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 00 02 00 00       	call   800231 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
  800045:	eb 5e                	jmp    8000a5 <primeproc+0x72>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800047:	83 ec 0c             	sub    $0xc,%esp
  80004a:	85 c0                	test   %eax,%eax
  80004c:	ba 00 00 00 00       	mov    $0x0,%edx
  800051:	0f 4e d0             	cmovle %eax,%edx
  800054:	52                   	push   %edx
  800055:	50                   	push   %eax
  800056:	68 e0 24 80 00       	push   $0x8024e0
  80005b:	6a 15                	push   $0x15
  80005d:	68 0f 25 80 00       	push   $0x80250f
  800062:	e8 25 02 00 00       	call   80028c <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 25 25 80 00       	push   $0x802525
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 0f 25 80 00       	push   $0x80250f
  800074:	e8 13 02 00 00       	call   80028c <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 40 2a 80 00       	push   $0x802a40
  80007f:	6a 1d                	push   $0x1d
  800081:	68 0f 25 80 00       	push   $0x80250f
  800086:	e8 01 02 00 00       	call   80028c <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 1d 15 00 00       	call   8015b1 <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 12 15 00 00       	call   8015b1 <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 c5 16 00 00       	call   801776 <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 21 25 80 00       	push   $0x802521
  8000c4:	e8 9e 02 00 00       	call   800367 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 f7 1c 00 00       	call   801dc8 <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 fe 10 00 00       	call   8011de <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 c0 14 00 00       	call   8015b1 <close>
	wfd = pfd[1];
  8000f1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f4:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f7:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
  800101:	e8 70 16 00 00       	call   801776 <readn>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	83 f8 04             	cmp    $0x4,%eax
  80010c:	75 42                	jne    800150 <primeproc+0x11d>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  80010e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d e0             	idivl  -0x20(%ebp)
  800115:	85 d2                	test   %edx,%edx
  800117:	74 e1                	je     8000fa <primeproc+0xc7>
			if ((r=write(wfd, &i, 4)) != 4)
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	6a 04                	push   $0x4
  80011e:	56                   	push   %esi
  80011f:	57                   	push   %edi
  800120:	e8 96 16 00 00       	call   8017bb <write>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	83 f8 04             	cmp    $0x4,%eax
  80012b:	74 cd                	je     8000fa <primeproc+0xc7>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	85 c0                	test   %eax,%eax
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	0f 4e d0             	cmovle %eax,%edx
  80013a:	52                   	push   %edx
  80013b:	50                   	push   %eax
  80013c:	ff 75 e0             	pushl  -0x20(%ebp)
  80013f:	68 4a 25 80 00       	push   $0x80254a
  800144:	6a 2e                	push   $0x2e
  800146:	68 0f 25 80 00       	push   $0x80250f
  80014b:	e8 3c 01 00 00       	call   80028c <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	0f 4e d0             	cmovle %eax,%edx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	53                   	push   %ebx
  800160:	ff 75 e0             	pushl  -0x20(%ebp)
  800163:	68 2e 25 80 00       	push   $0x80252e
  800168:	6a 2b                	push   $0x2b
  80016a:	68 0f 25 80 00       	push   $0x80250f
  80016f:	e8 18 01 00 00       	call   80028c <_panic>

00800174 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	53                   	push   %ebx
  800178:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017b:	c7 05 00 30 80 00 64 	movl   $0x802564,0x803000
  800182:	25 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 3a 1c 00 00       	call   801dc8 <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 41 10 00 00       	call   8011de <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 03 14 00 00       	call   8015b1 <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 25 25 80 00       	push   $0x802525
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 0f 25 80 00       	push   $0x80250f
  8001c6:	e8 c1 00 00 00       	call   80028c <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 40 2a 80 00       	push   $0x802a40
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 0f 25 80 00       	push   $0x80250f
  8001d8:	e8 af 00 00 00       	call   80028c <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 c9 13 00 00       	call   8015b1 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001e8:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001ef:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f2:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 04                	push   $0x4
  8001fa:	53                   	push   %ebx
  8001fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8001fe:	e8 b8 15 00 00       	call   8017bb <write>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	83 f8 04             	cmp    $0x4,%eax
  800209:	75 06                	jne    800211 <umain+0x9d>
	for (i=2;; i++)
  80020b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80020f:	eb e4                	jmp    8001f5 <umain+0x81>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	85 c0                	test   %eax,%eax
  800216:	ba 00 00 00 00       	mov    $0x0,%edx
  80021b:	0f 4e d0             	cmovle %eax,%edx
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	68 6f 25 80 00       	push   $0x80256f
  800225:	6a 4a                	push   $0x4a
  800227:	68 0f 25 80 00       	push   $0x80250f
  80022c:	e8 5b 00 00 00       	call   80028c <_panic>

00800231 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800239:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80023c:	e8 e8 0b 00 00       	call   800e29 <sys_getenvid>
  800241:	25 ff 03 00 00       	and    $0x3ff,%eax
  800246:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800249:	c1 e0 04             	shl    $0x4,%eax
  80024c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800251:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800256:	85 db                	test   %ebx,%ebx
  800258:	7e 07                	jle    800261 <libmain+0x30>
		binaryname = argv[0];
  80025a:	8b 06                	mov    (%esi),%eax
  80025c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	e8 09 ff ff ff       	call   800174 <umain>

	// exit gracefully
	exit();
  80026b:	e8 0a 00 00 00       	call   80027a <exit>
}
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800280:	6a 00                	push   $0x0
  800282:	e8 61 0b 00 00       	call   800de8 <sys_env_destroy>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800291:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800294:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80029a:	e8 8a 0b 00 00       	call   800e29 <sys_getenvid>
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	56                   	push   %esi
  8002a9:	50                   	push   %eax
  8002aa:	68 94 25 80 00       	push   $0x802594
  8002af:	e8 b3 00 00 00       	call   800367 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b4:	83 c4 18             	add    $0x18,%esp
  8002b7:	53                   	push   %ebx
  8002b8:	ff 75 10             	pushl  0x10(%ebp)
  8002bb:	e8 56 00 00 00       	call   800316 <vcprintf>
	cprintf("\n");
  8002c0:	c7 04 24 23 25 80 00 	movl   $0x802523,(%esp)
  8002c7:	e8 9b 00 00 00       	call   800367 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002cf:	cc                   	int3   
  8002d0:	eb fd                	jmp    8002cf <_panic+0x43>

008002d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002dc:	8b 13                	mov    (%ebx),%edx
  8002de:	8d 42 01             	lea    0x1(%edx),%eax
  8002e1:	89 03                	mov    %eax,(%ebx)
  8002e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ef:	74 09                	je     8002fa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	68 ff 00 00 00       	push   $0xff
  800302:	8d 43 08             	lea    0x8(%ebx),%eax
  800305:	50                   	push   %eax
  800306:	e8 a0 0a 00 00       	call   800dab <sys_cputs>
		b->idx = 0;
  80030b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	eb db                	jmp    8002f1 <putch+0x1f>

00800316 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800326:	00 00 00 
	b.cnt = 0;
  800329:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800330:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033f:	50                   	push   %eax
  800340:	68 d2 02 80 00       	push   $0x8002d2
  800345:	e8 4a 01 00 00       	call   800494 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80034a:	83 c4 08             	add    $0x8,%esp
  80034d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800353:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800359:	50                   	push   %eax
  80035a:	e8 4c 0a 00 00       	call   800dab <sys_cputs>

	return b.cnt;
}
  80035f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80036d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800370:	50                   	push   %eax
  800371:	ff 75 08             	pushl  0x8(%ebp)
  800374:	e8 9d ff ff ff       	call   800316 <vcprintf>
	va_end(ap);

	return cnt;
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	57                   	push   %edi
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
  800381:	83 ec 1c             	sub    $0x1c,%esp
  800384:	89 c6                	mov    %eax,%esi
  800386:	89 d7                	mov    %edx,%edi
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800391:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800394:	8b 45 10             	mov    0x10(%ebp),%eax
  800397:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80039a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80039e:	74 2c                	je     8003cc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b0:	39 c2                	cmp    %eax,%edx
  8003b2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003b5:	73 43                	jae    8003fa <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b7:	83 eb 01             	sub    $0x1,%ebx
  8003ba:	85 db                	test   %ebx,%ebx
  8003bc:	7e 6c                	jle    80042a <printnum+0xaf>
			putch(padc, putdat);
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	57                   	push   %edi
  8003c2:	ff 75 18             	pushl  0x18(%ebp)
  8003c5:	ff d6                	call   *%esi
  8003c7:	83 c4 10             	add    $0x10,%esp
  8003ca:	eb eb                	jmp    8003b7 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	6a 20                	push   $0x20
  8003d1:	6a 00                	push   $0x0
  8003d3:	50                   	push   %eax
  8003d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003da:	89 fa                	mov    %edi,%edx
  8003dc:	89 f0                	mov    %esi,%eax
  8003de:	e8 98 ff ff ff       	call   80037b <printnum>
		while (--width > 0)
  8003e3:	83 c4 20             	add    $0x20,%esp
  8003e6:	83 eb 01             	sub    $0x1,%ebx
  8003e9:	85 db                	test   %ebx,%ebx
  8003eb:	7e 65                	jle    800452 <printnum+0xd7>
			putch(padc, putdat);
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	57                   	push   %edi
  8003f1:	6a 20                	push   $0x20
  8003f3:	ff d6                	call   *%esi
  8003f5:	83 c4 10             	add    $0x10,%esp
  8003f8:	eb ec                	jmp    8003e6 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	ff 75 18             	pushl  0x18(%ebp)
  800400:	83 eb 01             	sub    $0x1,%ebx
  800403:	53                   	push   %ebx
  800404:	50                   	push   %eax
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 dc             	pushl  -0x24(%ebp)
  80040b:	ff 75 d8             	pushl  -0x28(%ebp)
  80040e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800411:	ff 75 e0             	pushl  -0x20(%ebp)
  800414:	e8 67 1e 00 00       	call   802280 <__udivdi3>
  800419:	83 c4 18             	add    $0x18,%esp
  80041c:	52                   	push   %edx
  80041d:	50                   	push   %eax
  80041e:	89 fa                	mov    %edi,%edx
  800420:	89 f0                	mov    %esi,%eax
  800422:	e8 54 ff ff ff       	call   80037b <printnum>
  800427:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	57                   	push   %edi
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	ff 75 dc             	pushl  -0x24(%ebp)
  800434:	ff 75 d8             	pushl  -0x28(%ebp)
  800437:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043a:	ff 75 e0             	pushl  -0x20(%ebp)
  80043d:	e8 4e 1f 00 00       	call   802390 <__umoddi3>
  800442:	83 c4 14             	add    $0x14,%esp
  800445:	0f be 80 b7 25 80 00 	movsbl 0x8025b7(%eax),%eax
  80044c:	50                   	push   %eax
  80044d:	ff d6                	call   *%esi
  80044f:	83 c4 10             	add    $0x10,%esp
}
  800452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800455:	5b                   	pop    %ebx
  800456:	5e                   	pop    %esi
  800457:	5f                   	pop    %edi
  800458:	5d                   	pop    %ebp
  800459:	c3                   	ret    

0080045a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800460:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800464:	8b 10                	mov    (%eax),%edx
  800466:	3b 50 04             	cmp    0x4(%eax),%edx
  800469:	73 0a                	jae    800475 <sprintputch+0x1b>
		*b->buf++ = ch;
  80046b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80046e:	89 08                	mov    %ecx,(%eax)
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	88 02                	mov    %al,(%edx)
}
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    

00800477 <printfmt>:
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80047d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800480:	50                   	push   %eax
  800481:	ff 75 10             	pushl  0x10(%ebp)
  800484:	ff 75 0c             	pushl  0xc(%ebp)
  800487:	ff 75 08             	pushl  0x8(%ebp)
  80048a:	e8 05 00 00 00       	call   800494 <vprintfmt>
}
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <vprintfmt>:
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	57                   	push   %edi
  800498:	56                   	push   %esi
  800499:	53                   	push   %ebx
  80049a:	83 ec 3c             	sub    $0x3c,%esp
  80049d:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a6:	e9 b4 03 00 00       	jmp    80085f <vprintfmt+0x3cb>
		padc = ' ';
  8004ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8004af:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8004b6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004bd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004cb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	8d 47 01             	lea    0x1(%edi),%eax
  8004d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004d6:	0f b6 17             	movzbl (%edi),%edx
  8004d9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004dc:	3c 55                	cmp    $0x55,%al
  8004de:	0f 87 c8 04 00 00    	ja     8009ac <vprintfmt+0x518>
  8004e4:	0f b6 c0             	movzbl %al,%eax
  8004e7:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  8004ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8004f1:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8004f8:	eb d6                	jmp    8004d0 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004fd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800501:	eb cd                	jmp    8004d0 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800503:	0f b6 d2             	movzbl %dl,%edx
  800506:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800509:	b8 00 00 00 00       	mov    $0x0,%eax
  80050e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800511:	eb 0c                	jmp    80051f <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800516:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80051a:	eb b4                	jmp    8004d0 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80051c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80051f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800522:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800526:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800529:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80052c:	83 f9 09             	cmp    $0x9,%ecx
  80052f:	76 eb                	jbe    80051c <vprintfmt+0x88>
  800531:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800537:	eb 14                	jmp    80054d <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	8b 00                	mov    (%eax),%eax
  80053e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 40 04             	lea    0x4(%eax),%eax
  800547:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80054d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800551:	0f 89 79 ff ff ff    	jns    8004d0 <vprintfmt+0x3c>
				width = precision, precision = -1;
  800557:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80055a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800564:	e9 67 ff ff ff       	jmp    8004d0 <vprintfmt+0x3c>
  800569:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056c:	85 c0                	test   %eax,%eax
  80056e:	ba 00 00 00 00       	mov    $0x0,%edx
  800573:	0f 49 d0             	cmovns %eax,%edx
  800576:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800579:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80057c:	e9 4f ff ff ff       	jmp    8004d0 <vprintfmt+0x3c>
  800581:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800584:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80058b:	e9 40 ff ff ff       	jmp    8004d0 <vprintfmt+0x3c>
			lflag++;
  800590:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800593:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800596:	e9 35 ff ff ff       	jmp    8004d0 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8d 78 04             	lea    0x4(%eax),%edi
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	ff 30                	pushl  (%eax)
  8005a7:	ff d6                	call   *%esi
			break;
  8005a9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005ac:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005af:	e9 a8 02 00 00       	jmp    80085c <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 78 04             	lea    0x4(%eax),%edi
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	99                   	cltd   
  8005bd:	31 d0                	xor    %edx,%eax
  8005bf:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005c1:	83 f8 0f             	cmp    $0xf,%eax
  8005c4:	7f 23                	jg     8005e9 <vprintfmt+0x155>
  8005c6:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  8005cd:	85 d2                	test   %edx,%edx
  8005cf:	74 18                	je     8005e9 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8005d1:	52                   	push   %edx
  8005d2:	68 21 2b 80 00       	push   $0x802b21
  8005d7:	53                   	push   %ebx
  8005d8:	56                   	push   %esi
  8005d9:	e8 99 fe ff ff       	call   800477 <printfmt>
  8005de:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005e4:	e9 73 02 00 00       	jmp    80085c <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8005e9:	50                   	push   %eax
  8005ea:	68 cf 25 80 00       	push   $0x8025cf
  8005ef:	53                   	push   %ebx
  8005f0:	56                   	push   %esi
  8005f1:	e8 81 fe ff ff       	call   800477 <printfmt>
  8005f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005fc:	e9 5b 02 00 00       	jmp    80085c <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	83 c0 04             	add    $0x4,%eax
  800607:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80060f:	85 d2                	test   %edx,%edx
  800611:	b8 c8 25 80 00       	mov    $0x8025c8,%eax
  800616:	0f 45 c2             	cmovne %edx,%eax
  800619:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80061c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800620:	7e 06                	jle    800628 <vprintfmt+0x194>
  800622:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800626:	75 0d                	jne    800635 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800628:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80062b:	89 c7                	mov    %eax,%edi
  80062d:	03 45 e0             	add    -0x20(%ebp),%eax
  800630:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800633:	eb 53                	jmp    800688 <vprintfmt+0x1f4>
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 d8             	pushl  -0x28(%ebp)
  80063b:	50                   	push   %eax
  80063c:	e8 13 04 00 00       	call   800a54 <strnlen>
  800641:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800644:	29 c1                	sub    %eax,%ecx
  800646:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80064e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800652:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800655:	eb 0f                	jmp    800666 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	ff 75 e0             	pushl  -0x20(%ebp)
  80065e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800660:	83 ef 01             	sub    $0x1,%edi
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	85 ff                	test   %edi,%edi
  800668:	7f ed                	jg     800657 <vprintfmt+0x1c3>
  80066a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80066d:	85 d2                	test   %edx,%edx
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
  800674:	0f 49 c2             	cmovns %edx,%eax
  800677:	29 c2                	sub    %eax,%edx
  800679:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80067c:	eb aa                	jmp    800628 <vprintfmt+0x194>
					putch(ch, putdat);
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	53                   	push   %ebx
  800682:	52                   	push   %edx
  800683:	ff d6                	call   *%esi
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80068b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068d:	83 c7 01             	add    $0x1,%edi
  800690:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800694:	0f be d0             	movsbl %al,%edx
  800697:	85 d2                	test   %edx,%edx
  800699:	74 4b                	je     8006e6 <vprintfmt+0x252>
  80069b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80069f:	78 06                	js     8006a7 <vprintfmt+0x213>
  8006a1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006a5:	78 1e                	js     8006c5 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006ab:	74 d1                	je     80067e <vprintfmt+0x1ea>
  8006ad:	0f be c0             	movsbl %al,%eax
  8006b0:	83 e8 20             	sub    $0x20,%eax
  8006b3:	83 f8 5e             	cmp    $0x5e,%eax
  8006b6:	76 c6                	jbe    80067e <vprintfmt+0x1ea>
					putch('?', putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	6a 3f                	push   $0x3f
  8006be:	ff d6                	call   *%esi
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	eb c3                	jmp    800688 <vprintfmt+0x1f4>
  8006c5:	89 cf                	mov    %ecx,%edi
  8006c7:	eb 0e                	jmp    8006d7 <vprintfmt+0x243>
				putch(' ', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 20                	push   $0x20
  8006cf:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006d1:	83 ef 01             	sub    $0x1,%edi
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	85 ff                	test   %edi,%edi
  8006d9:	7f ee                	jg     8006c9 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8006db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e1:	e9 76 01 00 00       	jmp    80085c <vprintfmt+0x3c8>
  8006e6:	89 cf                	mov    %ecx,%edi
  8006e8:	eb ed                	jmp    8006d7 <vprintfmt+0x243>
	if (lflag >= 2)
  8006ea:	83 f9 01             	cmp    $0x1,%ecx
  8006ed:	7f 1f                	jg     80070e <vprintfmt+0x27a>
	else if (lflag)
  8006ef:	85 c9                	test   %ecx,%ecx
  8006f1:	74 6a                	je     80075d <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	89 c1                	mov    %eax,%ecx
  8006fd:	c1 f9 1f             	sar    $0x1f,%ecx
  800700:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
  80070c:	eb 17                	jmp    800725 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 50 04             	mov    0x4(%eax),%edx
  800714:	8b 00                	mov    (%eax),%eax
  800716:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800719:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8d 40 08             	lea    0x8(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800725:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800728:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80072d:	85 d2                	test   %edx,%edx
  80072f:	0f 89 f8 00 00 00    	jns    80082d <vprintfmt+0x399>
				putch('-', putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	53                   	push   %ebx
  800739:	6a 2d                	push   $0x2d
  80073b:	ff d6                	call   *%esi
				num = -(long long) num;
  80073d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800740:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800743:	f7 d8                	neg    %eax
  800745:	83 d2 00             	adc    $0x0,%edx
  800748:	f7 da                	neg    %edx
  80074a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800750:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800753:	bf 0a 00 00 00       	mov    $0xa,%edi
  800758:	e9 e1 00 00 00       	jmp    80083e <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800765:	99                   	cltd   
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
  800772:	eb b1                	jmp    800725 <vprintfmt+0x291>
	if (lflag >= 2)
  800774:	83 f9 01             	cmp    $0x1,%ecx
  800777:	7f 27                	jg     8007a0 <vprintfmt+0x30c>
	else if (lflag)
  800779:	85 c9                	test   %ecx,%ecx
  80077b:	74 41                	je     8007be <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
  800787:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800796:	bf 0a 00 00 00       	mov    $0xa,%edi
  80079b:	e9 8d 00 00 00       	jmp    80082d <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8b 50 04             	mov    0x4(%eax),%edx
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8d 40 08             	lea    0x8(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007bc:	eb 6f                	jmp    80082d <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 40 04             	lea    0x4(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007dc:	eb 4f                	jmp    80082d <vprintfmt+0x399>
	if (lflag >= 2)
  8007de:	83 f9 01             	cmp    $0x1,%ecx
  8007e1:	7f 23                	jg     800806 <vprintfmt+0x372>
	else if (lflag)
  8007e3:	85 c9                	test   %ecx,%ecx
  8007e5:	0f 84 98 00 00 00    	je     800883 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 40 04             	lea    0x4(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
  800804:	eb 17                	jmp    80081d <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 50 04             	mov    0x4(%eax),%edx
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800811:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 08             	lea    0x8(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	53                   	push   %ebx
  800821:	6a 30                	push   $0x30
  800823:	ff d6                	call   *%esi
			goto number;
  800825:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800828:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  80082d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800831:	74 0b                	je     80083e <vprintfmt+0x3aa>
				putch('+', putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	53                   	push   %ebx
  800837:	6a 2b                	push   $0x2b
  800839:	ff d6                	call   *%esi
  80083b:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80083e:	83 ec 0c             	sub    $0xc,%esp
  800841:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800845:	50                   	push   %eax
  800846:	ff 75 e0             	pushl  -0x20(%ebp)
  800849:	57                   	push   %edi
  80084a:	ff 75 dc             	pushl  -0x24(%ebp)
  80084d:	ff 75 d8             	pushl  -0x28(%ebp)
  800850:	89 da                	mov    %ebx,%edx
  800852:	89 f0                	mov    %esi,%eax
  800854:	e8 22 fb ff ff       	call   80037b <printnum>
			break;
  800859:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80085c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085f:	83 c7 01             	add    $0x1,%edi
  800862:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800866:	83 f8 25             	cmp    $0x25,%eax
  800869:	0f 84 3c fc ff ff    	je     8004ab <vprintfmt+0x17>
			if (ch == '\0')
  80086f:	85 c0                	test   %eax,%eax
  800871:	0f 84 55 01 00 00    	je     8009cc <vprintfmt+0x538>
			putch(ch, putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	53                   	push   %ebx
  80087b:	50                   	push   %eax
  80087c:	ff d6                	call   *%esi
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	eb dc                	jmp    80085f <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8b 00                	mov    (%eax),%eax
  800888:	ba 00 00 00 00       	mov    $0x0,%edx
  80088d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800890:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8d 40 04             	lea    0x4(%eax),%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
  80089c:	e9 7c ff ff ff       	jmp    80081d <vprintfmt+0x389>
			putch('0', putdat);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	53                   	push   %ebx
  8008a5:	6a 30                	push   $0x30
  8008a7:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a9:	83 c4 08             	add    $0x8,%esp
  8008ac:	53                   	push   %ebx
  8008ad:	6a 78                	push   $0x78
  8008af:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008be:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008c1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8d 40 04             	lea    0x4(%eax),%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cd:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8008d2:	e9 56 ff ff ff       	jmp    80082d <vprintfmt+0x399>
	if (lflag >= 2)
  8008d7:	83 f9 01             	cmp    $0x1,%ecx
  8008da:	7f 27                	jg     800903 <vprintfmt+0x46f>
	else if (lflag)
  8008dc:	85 c9                	test   %ecx,%ecx
  8008de:	74 44                	je     800924 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	8d 40 04             	lea    0x4(%eax),%eax
  8008f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f9:	bf 10 00 00 00       	mov    $0x10,%edi
  8008fe:	e9 2a ff ff ff       	jmp    80082d <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	8b 50 04             	mov    0x4(%eax),%edx
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8d 40 08             	lea    0x8(%eax),%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091a:	bf 10 00 00 00       	mov    $0x10,%edi
  80091f:	e9 09 ff ff ff       	jmp    80082d <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	ba 00 00 00 00       	mov    $0x0,%edx
  80092e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800931:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8d 40 04             	lea    0x4(%eax),%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093d:	bf 10 00 00 00       	mov    $0x10,%edi
  800942:	e9 e6 fe ff ff       	jmp    80082d <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8d 78 04             	lea    0x4(%eax),%edi
  80094d:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  80094f:	85 c0                	test   %eax,%eax
  800951:	74 2d                	je     800980 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800953:	0f b6 13             	movzbl (%ebx),%edx
  800956:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800958:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  80095b:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80095e:	0f 8e f8 fe ff ff    	jle    80085c <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800964:	68 24 27 80 00       	push   $0x802724
  800969:	68 21 2b 80 00       	push   $0x802b21
  80096e:	53                   	push   %ebx
  80096f:	56                   	push   %esi
  800970:	e8 02 fb ff ff       	call   800477 <printfmt>
  800975:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800978:	89 7d 14             	mov    %edi,0x14(%ebp)
  80097b:	e9 dc fe ff ff       	jmp    80085c <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800980:	68 ec 26 80 00       	push   $0x8026ec
  800985:	68 21 2b 80 00       	push   $0x802b21
  80098a:	53                   	push   %ebx
  80098b:	56                   	push   %esi
  80098c:	e8 e6 fa ff ff       	call   800477 <printfmt>
  800991:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800994:	89 7d 14             	mov    %edi,0x14(%ebp)
  800997:	e9 c0 fe ff ff       	jmp    80085c <vprintfmt+0x3c8>
			putch(ch, putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	53                   	push   %ebx
  8009a0:	6a 25                	push   $0x25
  8009a2:	ff d6                	call   *%esi
			break;
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	e9 b0 fe ff ff       	jmp    80085c <vprintfmt+0x3c8>
			putch('%', putdat);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	53                   	push   %ebx
  8009b0:	6a 25                	push   $0x25
  8009b2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 f8                	mov    %edi,%eax
  8009b9:	eb 03                	jmp    8009be <vprintfmt+0x52a>
  8009bb:	83 e8 01             	sub    $0x1,%eax
  8009be:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009c2:	75 f7                	jne    8009bb <vprintfmt+0x527>
  8009c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009c7:	e9 90 fe ff ff       	jmp    80085c <vprintfmt+0x3c8>
}
  8009cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009cf:	5b                   	pop    %ebx
  8009d0:	5e                   	pop    %esi
  8009d1:	5f                   	pop    %edi
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	83 ec 18             	sub    $0x18,%esp
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009e7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f1:	85 c0                	test   %eax,%eax
  8009f3:	74 26                	je     800a1b <vsnprintf+0x47>
  8009f5:	85 d2                	test   %edx,%edx
  8009f7:	7e 22                	jle    800a1b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f9:	ff 75 14             	pushl  0x14(%ebp)
  8009fc:	ff 75 10             	pushl  0x10(%ebp)
  8009ff:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a02:	50                   	push   %eax
  800a03:	68 5a 04 80 00       	push   $0x80045a
  800a08:	e8 87 fa ff ff       	call   800494 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a10:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a16:	83 c4 10             	add    $0x10,%esp
}
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    
		return -E_INVAL;
  800a1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a20:	eb f7                	jmp    800a19 <vsnprintf+0x45>

00800a22 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a28:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 10             	pushl  0x10(%ebp)
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	ff 75 08             	pushl  0x8(%ebp)
  800a35:	e8 9a ff ff ff       	call   8009d4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
  800a47:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a4b:	74 05                	je     800a52 <strlen+0x16>
		n++;
  800a4d:	83 c0 01             	add    $0x1,%eax
  800a50:	eb f5                	jmp    800a47 <strlen+0xb>
	return n;
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	74 0d                	je     800a73 <strnlen+0x1f>
  800a66:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a6a:	74 05                	je     800a71 <strnlen+0x1d>
		n++;
  800a6c:	83 c2 01             	add    $0x1,%edx
  800a6f:	eb f1                	jmp    800a62 <strnlen+0xe>
  800a71:	89 d0                	mov    %edx,%eax
	return n;
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	53                   	push   %ebx
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a84:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a88:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a8b:	83 c2 01             	add    $0x1,%edx
  800a8e:	84 c9                	test   %cl,%cl
  800a90:	75 f2                	jne    800a84 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a92:	5b                   	pop    %ebx
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	53                   	push   %ebx
  800a99:	83 ec 10             	sub    $0x10,%esp
  800a9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a9f:	53                   	push   %ebx
  800aa0:	e8 97 ff ff ff       	call   800a3c <strlen>
  800aa5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	01 d8                	add    %ebx,%eax
  800aad:	50                   	push   %eax
  800aae:	e8 c2 ff ff ff       	call   800a75 <strcpy>
	return dst;
}
  800ab3:	89 d8                	mov    %ebx,%eax
  800ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab8:	c9                   	leave  
  800ab9:	c3                   	ret    

00800aba <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac5:	89 c6                	mov    %eax,%esi
  800ac7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aca:	89 c2                	mov    %eax,%edx
  800acc:	39 f2                	cmp    %esi,%edx
  800ace:	74 11                	je     800ae1 <strncpy+0x27>
		*dst++ = *src;
  800ad0:	83 c2 01             	add    $0x1,%edx
  800ad3:	0f b6 19             	movzbl (%ecx),%ebx
  800ad6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ad9:	80 fb 01             	cmp    $0x1,%bl
  800adc:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800adf:	eb eb                	jmp    800acc <strncpy+0x12>
	}
	return ret;
}
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	56                   	push   %esi
  800ae9:	53                   	push   %ebx
  800aea:	8b 75 08             	mov    0x8(%ebp),%esi
  800aed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af0:	8b 55 10             	mov    0x10(%ebp),%edx
  800af3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800af5:	85 d2                	test   %edx,%edx
  800af7:	74 21                	je     800b1a <strlcpy+0x35>
  800af9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800afd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800aff:	39 c2                	cmp    %eax,%edx
  800b01:	74 14                	je     800b17 <strlcpy+0x32>
  800b03:	0f b6 19             	movzbl (%ecx),%ebx
  800b06:	84 db                	test   %bl,%bl
  800b08:	74 0b                	je     800b15 <strlcpy+0x30>
			*dst++ = *src++;
  800b0a:	83 c1 01             	add    $0x1,%ecx
  800b0d:	83 c2 01             	add    $0x1,%edx
  800b10:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b13:	eb ea                	jmp    800aff <strlcpy+0x1a>
  800b15:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b17:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b1a:	29 f0                	sub    %esi,%eax
}
  800b1c:	5b                   	pop    %ebx
  800b1d:	5e                   	pop    %esi
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b29:	0f b6 01             	movzbl (%ecx),%eax
  800b2c:	84 c0                	test   %al,%al
  800b2e:	74 0c                	je     800b3c <strcmp+0x1c>
  800b30:	3a 02                	cmp    (%edx),%al
  800b32:	75 08                	jne    800b3c <strcmp+0x1c>
		p++, q++;
  800b34:	83 c1 01             	add    $0x1,%ecx
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	eb ed                	jmp    800b29 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3c:	0f b6 c0             	movzbl %al,%eax
  800b3f:	0f b6 12             	movzbl (%edx),%edx
  800b42:	29 d0                	sub    %edx,%eax
}
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	53                   	push   %ebx
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b50:	89 c3                	mov    %eax,%ebx
  800b52:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b55:	eb 06                	jmp    800b5d <strncmp+0x17>
		n--, p++, q++;
  800b57:	83 c0 01             	add    $0x1,%eax
  800b5a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b5d:	39 d8                	cmp    %ebx,%eax
  800b5f:	74 16                	je     800b77 <strncmp+0x31>
  800b61:	0f b6 08             	movzbl (%eax),%ecx
  800b64:	84 c9                	test   %cl,%cl
  800b66:	74 04                	je     800b6c <strncmp+0x26>
  800b68:	3a 0a                	cmp    (%edx),%cl
  800b6a:	74 eb                	je     800b57 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6c:	0f b6 00             	movzbl (%eax),%eax
  800b6f:	0f b6 12             	movzbl (%edx),%edx
  800b72:	29 d0                	sub    %edx,%eax
}
  800b74:	5b                   	pop    %ebx
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    
		return 0;
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7c:	eb f6                	jmp    800b74 <strncmp+0x2e>

00800b7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b88:	0f b6 10             	movzbl (%eax),%edx
  800b8b:	84 d2                	test   %dl,%dl
  800b8d:	74 09                	je     800b98 <strchr+0x1a>
		if (*s == c)
  800b8f:	38 ca                	cmp    %cl,%dl
  800b91:	74 0a                	je     800b9d <strchr+0x1f>
	for (; *s; s++)
  800b93:	83 c0 01             	add    $0x1,%eax
  800b96:	eb f0                	jmp    800b88 <strchr+0xa>
			return (char *) s;
	return 0;
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bac:	38 ca                	cmp    %cl,%dl
  800bae:	74 09                	je     800bb9 <strfind+0x1a>
  800bb0:	84 d2                	test   %dl,%dl
  800bb2:	74 05                	je     800bb9 <strfind+0x1a>
	for (; *s; s++)
  800bb4:	83 c0 01             	add    $0x1,%eax
  800bb7:	eb f0                	jmp    800ba9 <strfind+0xa>
			break;
	return (char *) s;
}
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
  800bc1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bc7:	85 c9                	test   %ecx,%ecx
  800bc9:	74 31                	je     800bfc <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bcb:	89 f8                	mov    %edi,%eax
  800bcd:	09 c8                	or     %ecx,%eax
  800bcf:	a8 03                	test   $0x3,%al
  800bd1:	75 23                	jne    800bf6 <memset+0x3b>
		c &= 0xFF;
  800bd3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bd7:	89 d3                	mov    %edx,%ebx
  800bd9:	c1 e3 08             	shl    $0x8,%ebx
  800bdc:	89 d0                	mov    %edx,%eax
  800bde:	c1 e0 18             	shl    $0x18,%eax
  800be1:	89 d6                	mov    %edx,%esi
  800be3:	c1 e6 10             	shl    $0x10,%esi
  800be6:	09 f0                	or     %esi,%eax
  800be8:	09 c2                	or     %eax,%edx
  800bea:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bec:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bef:	89 d0                	mov    %edx,%eax
  800bf1:	fc                   	cld    
  800bf2:	f3 ab                	rep stos %eax,%es:(%edi)
  800bf4:	eb 06                	jmp    800bfc <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf9:	fc                   	cld    
  800bfa:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bfc:	89 f8                	mov    %edi,%eax
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c11:	39 c6                	cmp    %eax,%esi
  800c13:	73 32                	jae    800c47 <memmove+0x44>
  800c15:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c18:	39 c2                	cmp    %eax,%edx
  800c1a:	76 2b                	jbe    800c47 <memmove+0x44>
		s += n;
		d += n;
  800c1c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1f:	89 fe                	mov    %edi,%esi
  800c21:	09 ce                	or     %ecx,%esi
  800c23:	09 d6                	or     %edx,%esi
  800c25:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c2b:	75 0e                	jne    800c3b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c2d:	83 ef 04             	sub    $0x4,%edi
  800c30:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c33:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c36:	fd                   	std    
  800c37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c39:	eb 09                	jmp    800c44 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c3b:	83 ef 01             	sub    $0x1,%edi
  800c3e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c41:	fd                   	std    
  800c42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c44:	fc                   	cld    
  800c45:	eb 1a                	jmp    800c61 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c47:	89 c2                	mov    %eax,%edx
  800c49:	09 ca                	or     %ecx,%edx
  800c4b:	09 f2                	or     %esi,%edx
  800c4d:	f6 c2 03             	test   $0x3,%dl
  800c50:	75 0a                	jne    800c5c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c52:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c55:	89 c7                	mov    %eax,%edi
  800c57:	fc                   	cld    
  800c58:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c5a:	eb 05                	jmp    800c61 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c5c:	89 c7                	mov    %eax,%edi
  800c5e:	fc                   	cld    
  800c5f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c6b:	ff 75 10             	pushl  0x10(%ebp)
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	e8 8a ff ff ff       	call   800c03 <memmove>
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	89 c6                	mov    %eax,%esi
  800c88:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c8b:	39 f0                	cmp    %esi,%eax
  800c8d:	74 1c                	je     800cab <memcmp+0x30>
		if (*s1 != *s2)
  800c8f:	0f b6 08             	movzbl (%eax),%ecx
  800c92:	0f b6 1a             	movzbl (%edx),%ebx
  800c95:	38 d9                	cmp    %bl,%cl
  800c97:	75 08                	jne    800ca1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c99:	83 c0 01             	add    $0x1,%eax
  800c9c:	83 c2 01             	add    $0x1,%edx
  800c9f:	eb ea                	jmp    800c8b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ca1:	0f b6 c1             	movzbl %cl,%eax
  800ca4:	0f b6 db             	movzbl %bl,%ebx
  800ca7:	29 d8                	sub    %ebx,%eax
  800ca9:	eb 05                	jmp    800cb0 <memcmp+0x35>
	}

	return 0;
  800cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cbd:	89 c2                	mov    %eax,%edx
  800cbf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cc2:	39 d0                	cmp    %edx,%eax
  800cc4:	73 09                	jae    800ccf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc6:	38 08                	cmp    %cl,(%eax)
  800cc8:	74 05                	je     800ccf <memfind+0x1b>
	for (; s < ends; s++)
  800cca:	83 c0 01             	add    $0x1,%eax
  800ccd:	eb f3                	jmp    800cc2 <memfind+0xe>
			break;
	return (void *) s;
}
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cda:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cdd:	eb 03                	jmp    800ce2 <strtol+0x11>
		s++;
  800cdf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ce2:	0f b6 01             	movzbl (%ecx),%eax
  800ce5:	3c 20                	cmp    $0x20,%al
  800ce7:	74 f6                	je     800cdf <strtol+0xe>
  800ce9:	3c 09                	cmp    $0x9,%al
  800ceb:	74 f2                	je     800cdf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ced:	3c 2b                	cmp    $0x2b,%al
  800cef:	74 2a                	je     800d1b <strtol+0x4a>
	int neg = 0;
  800cf1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cf6:	3c 2d                	cmp    $0x2d,%al
  800cf8:	74 2b                	je     800d25 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d00:	75 0f                	jne    800d11 <strtol+0x40>
  800d02:	80 39 30             	cmpb   $0x30,(%ecx)
  800d05:	74 28                	je     800d2f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d07:	85 db                	test   %ebx,%ebx
  800d09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d0e:	0f 44 d8             	cmove  %eax,%ebx
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d19:	eb 50                	jmp    800d6b <strtol+0x9a>
		s++;
  800d1b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d1e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d23:	eb d5                	jmp    800cfa <strtol+0x29>
		s++, neg = 1;
  800d25:	83 c1 01             	add    $0x1,%ecx
  800d28:	bf 01 00 00 00       	mov    $0x1,%edi
  800d2d:	eb cb                	jmp    800cfa <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d33:	74 0e                	je     800d43 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	75 d8                	jne    800d11 <strtol+0x40>
		s++, base = 8;
  800d39:	83 c1 01             	add    $0x1,%ecx
  800d3c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d41:	eb ce                	jmp    800d11 <strtol+0x40>
		s += 2, base = 16;
  800d43:	83 c1 02             	add    $0x2,%ecx
  800d46:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d4b:	eb c4                	jmp    800d11 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d4d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d50:	89 f3                	mov    %esi,%ebx
  800d52:	80 fb 19             	cmp    $0x19,%bl
  800d55:	77 29                	ja     800d80 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d57:	0f be d2             	movsbl %dl,%edx
  800d5a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d5d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d60:	7d 30                	jge    800d92 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d62:	83 c1 01             	add    $0x1,%ecx
  800d65:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d69:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d6b:	0f b6 11             	movzbl (%ecx),%edx
  800d6e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d71:	89 f3                	mov    %esi,%ebx
  800d73:	80 fb 09             	cmp    $0x9,%bl
  800d76:	77 d5                	ja     800d4d <strtol+0x7c>
			dig = *s - '0';
  800d78:	0f be d2             	movsbl %dl,%edx
  800d7b:	83 ea 30             	sub    $0x30,%edx
  800d7e:	eb dd                	jmp    800d5d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d80:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d83:	89 f3                	mov    %esi,%ebx
  800d85:	80 fb 19             	cmp    $0x19,%bl
  800d88:	77 08                	ja     800d92 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d8a:	0f be d2             	movsbl %dl,%edx
  800d8d:	83 ea 37             	sub    $0x37,%edx
  800d90:	eb cb                	jmp    800d5d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d96:	74 05                	je     800d9d <strtol+0xcc>
		*endptr = (char *) s;
  800d98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d9b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d9d:	89 c2                	mov    %eax,%edx
  800d9f:	f7 da                	neg    %edx
  800da1:	85 ff                	test   %edi,%edi
  800da3:	0f 45 c2             	cmovne %edx,%eax
}
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db1:	b8 00 00 00 00       	mov    $0x0,%eax
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbc:	89 c3                	mov    %eax,%ebx
  800dbe:	89 c7                	mov    %eax,%edi
  800dc0:	89 c6                	mov    %eax,%esi
  800dc2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd4:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd9:	89 d1                	mov    %edx,%ecx
  800ddb:	89 d3                	mov    %edx,%ebx
  800ddd:	89 d7                	mov    %edx,%edi
  800ddf:	89 d6                	mov    %edx,%esi
  800de1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5f                   	pop    %edi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfe:	89 cb                	mov    %ecx,%ebx
  800e00:	89 cf                	mov    %ecx,%edi
  800e02:	89 ce                	mov    %ecx,%esi
  800e04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7f 08                	jg     800e12 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e12:	83 ec 0c             	sub    $0xc,%esp
  800e15:	50                   	push   %eax
  800e16:	6a 03                	push   $0x3
  800e18:	68 40 29 80 00       	push   $0x802940
  800e1d:	6a 33                	push   $0x33
  800e1f:	68 5d 29 80 00       	push   $0x80295d
  800e24:	e8 63 f4 ff ff       	call   80028c <_panic>

00800e29 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e34:	b8 02 00 00 00       	mov    $0x2,%eax
  800e39:	89 d1                	mov    %edx,%ecx
  800e3b:	89 d3                	mov    %edx,%ebx
  800e3d:	89 d7                	mov    %edx,%edi
  800e3f:	89 d6                	mov    %edx,%esi
  800e41:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <sys_yield>:

void
sys_yield(void)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	57                   	push   %edi
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e53:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e58:	89 d1                	mov    %edx,%ecx
  800e5a:	89 d3                	mov    %edx,%ebx
  800e5c:	89 d7                	mov    %edx,%edi
  800e5e:	89 d6                	mov    %edx,%esi
  800e60:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	be 00 00 00 00       	mov    $0x0,%esi
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	b8 04 00 00 00       	mov    $0x4,%eax
  800e80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e83:	89 f7                	mov    %esi,%edi
  800e85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e87:	85 c0                	test   %eax,%eax
  800e89:	7f 08                	jg     800e93 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	50                   	push   %eax
  800e97:	6a 04                	push   $0x4
  800e99:	68 40 29 80 00       	push   $0x802940
  800e9e:	6a 33                	push   $0x33
  800ea0:	68 5d 29 80 00       	push   $0x80295d
  800ea5:	e8 e2 f3 ff ff       	call   80028c <_panic>

00800eaa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
  800eb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	b8 05 00 00 00       	mov    $0x5,%eax
  800ebe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ec7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	7f 08                	jg     800ed5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed5:	83 ec 0c             	sub    $0xc,%esp
  800ed8:	50                   	push   %eax
  800ed9:	6a 05                	push   $0x5
  800edb:	68 40 29 80 00       	push   $0x802940
  800ee0:	6a 33                	push   $0x33
  800ee2:	68 5d 29 80 00       	push   $0x80295d
  800ee7:	e8 a0 f3 ff ff       	call   80028c <_panic>

00800eec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	57                   	push   %edi
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
  800ef2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f00:	b8 06 00 00 00       	mov    $0x6,%eax
  800f05:	89 df                	mov    %ebx,%edi
  800f07:	89 de                	mov    %ebx,%esi
  800f09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	7f 08                	jg     800f17 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	50                   	push   %eax
  800f1b:	6a 06                	push   $0x6
  800f1d:	68 40 29 80 00       	push   $0x802940
  800f22:	6a 33                	push   $0x33
  800f24:	68 5d 29 80 00       	push   $0x80295d
  800f29:	e8 5e f3 ff ff       	call   80028c <_panic>

00800f2e <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f44:	89 cb                	mov    %ecx,%ebx
  800f46:	89 cf                	mov    %ecx,%edi
  800f48:	89 ce                	mov    %ecx,%esi
  800f4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7f 08                	jg     800f58 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	50                   	push   %eax
  800f5c:	6a 0b                	push   $0xb
  800f5e:	68 40 29 80 00       	push   $0x802940
  800f63:	6a 33                	push   $0x33
  800f65:	68 5d 29 80 00       	push   $0x80295d
  800f6a:	e8 1d f3 ff ff       	call   80028c <_panic>

00800f6f <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	b8 08 00 00 00       	mov    $0x8,%eax
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	89 de                	mov    %ebx,%esi
  800f8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	7f 08                	jg     800f9a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	50                   	push   %eax
  800f9e:	6a 08                	push   $0x8
  800fa0:	68 40 29 80 00       	push   $0x802940
  800fa5:	6a 33                	push   $0x33
  800fa7:	68 5d 29 80 00       	push   $0x80295d
  800fac:	e8 db f2 ff ff       	call   80028c <_panic>

00800fb1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	57                   	push   %edi
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc5:	b8 09 00 00 00       	mov    $0x9,%eax
  800fca:	89 df                	mov    %ebx,%edi
  800fcc:	89 de                	mov    %ebx,%esi
  800fce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	7f 08                	jg     800fdc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdc:	83 ec 0c             	sub    $0xc,%esp
  800fdf:	50                   	push   %eax
  800fe0:	6a 09                	push   $0x9
  800fe2:	68 40 29 80 00       	push   $0x802940
  800fe7:	6a 33                	push   $0x33
  800fe9:	68 5d 29 80 00       	push   $0x80295d
  800fee:	e8 99 f2 ff ff       	call   80028c <_panic>

00800ff3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	57                   	push   %edi
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
  800ff9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801007:	b8 0a 00 00 00       	mov    $0xa,%eax
  80100c:	89 df                	mov    %ebx,%edi
  80100e:	89 de                	mov    %ebx,%esi
  801010:	cd 30                	int    $0x30
	if(check && ret > 0)
  801012:	85 c0                	test   %eax,%eax
  801014:	7f 08                	jg     80101e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801016:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101e:	83 ec 0c             	sub    $0xc,%esp
  801021:	50                   	push   %eax
  801022:	6a 0a                	push   $0xa
  801024:	68 40 29 80 00       	push   $0x802940
  801029:	6a 33                	push   $0x33
  80102b:	68 5d 29 80 00       	push   $0x80295d
  801030:	e8 57 f2 ff ff       	call   80028c <_panic>

00801035 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	57                   	push   %edi
  801039:	56                   	push   %esi
  80103a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801041:	b8 0d 00 00 00       	mov    $0xd,%eax
  801046:	be 00 00 00 00       	mov    $0x0,%esi
  80104b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80104e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801051:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801053:	5b                   	pop    %ebx
  801054:	5e                   	pop    %esi
  801055:	5f                   	pop    %edi
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	57                   	push   %edi
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
  80105e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801061:	b9 00 00 00 00       	mov    $0x0,%ecx
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	b8 0e 00 00 00       	mov    $0xe,%eax
  80106e:	89 cb                	mov    %ecx,%ebx
  801070:	89 cf                	mov    %ecx,%edi
  801072:	89 ce                	mov    %ecx,%esi
  801074:	cd 30                	int    $0x30
	if(check && ret > 0)
  801076:	85 c0                	test   %eax,%eax
  801078:	7f 08                	jg     801082 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80107a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	50                   	push   %eax
  801086:	6a 0e                	push   $0xe
  801088:	68 40 29 80 00       	push   $0x802940
  80108d:	6a 33                	push   $0x33
  80108f:	68 5d 29 80 00       	push   $0x80295d
  801094:	e8 f3 f1 ff ff       	call   80028c <_panic>

00801099 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	57                   	push   %edi
  80109d:	56                   	push   %esi
  80109e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010aa:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010af:	89 df                	mov    %ebx,%edi
  8010b1:	89 de                	mov    %ebx,%esi
  8010b3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010b5:	5b                   	pop    %ebx
  8010b6:	5e                   	pop    %esi
  8010b7:	5f                   	pop    %edi
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    

008010ba <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c8:	b8 10 00 00 00       	mov    $0x10,%eax
  8010cd:	89 cb                	mov    %ecx,%ebx
  8010cf:	89 cf                	mov    %ecx,%edi
  8010d1:	89 ce                	mov    %ecx,%esi
  8010d3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010d5:	5b                   	pop    %ebx
  8010d6:	5e                   	pop    %esi
  8010d7:	5f                   	pop    %edi
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	53                   	push   %ebx
  8010de:	83 ec 04             	sub    $0x4,%esp
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010e4:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  8010e6:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010ea:	0f 84 90 00 00 00    	je     801180 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  8010f0:	89 d8                	mov    %ebx,%eax
  8010f2:	c1 e8 16             	shr    $0x16,%eax
  8010f5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010fc:	a8 01                	test   $0x1,%al
  8010fe:	0f 84 90 00 00 00    	je     801194 <pgfault+0xba>
  801104:	89 d8                	mov    %ebx,%eax
  801106:	c1 e8 0c             	shr    $0xc,%eax
  801109:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801110:	a9 01 08 00 00       	test   $0x801,%eax
  801115:	74 7d                	je     801194 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	6a 07                	push   $0x7
  80111c:	68 00 f0 7f 00       	push   $0x7ff000
  801121:	6a 00                	push   $0x0
  801123:	e8 3f fd ff ff       	call   800e67 <sys_page_alloc>
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	85 c0                	test   %eax,%eax
  80112d:	78 79                	js     8011a8 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  80112f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  801135:	83 ec 04             	sub    $0x4,%esp
  801138:	68 00 10 00 00       	push   $0x1000
  80113d:	53                   	push   %ebx
  80113e:	68 00 f0 7f 00       	push   $0x7ff000
  801143:	e8 bb fa ff ff       	call   800c03 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  801148:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80114f:	53                   	push   %ebx
  801150:	6a 00                	push   $0x0
  801152:	68 00 f0 7f 00       	push   $0x7ff000
  801157:	6a 00                	push   $0x0
  801159:	e8 4c fd ff ff       	call   800eaa <sys_page_map>
  80115e:	83 c4 20             	add    $0x20,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	78 55                	js     8011ba <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801165:	83 ec 08             	sub    $0x8,%esp
  801168:	68 00 f0 7f 00       	push   $0x7ff000
  80116d:	6a 00                	push   $0x0
  80116f:	e8 78 fd ff ff       	call   800eec <sys_page_unmap>
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	85 c0                	test   %eax,%eax
  801179:	78 51                	js     8011cc <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  80117b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  801180:	83 ec 04             	sub    $0x4,%esp
  801183:	68 6c 29 80 00       	push   $0x80296c
  801188:	6a 21                	push   $0x21
  80118a:	68 f4 29 80 00       	push   $0x8029f4
  80118f:	e8 f8 f0 ff ff       	call   80028c <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	68 98 29 80 00       	push   $0x802998
  80119c:	6a 24                	push   $0x24
  80119e:	68 f4 29 80 00       	push   $0x8029f4
  8011a3:	e8 e4 f0 ff ff       	call   80028c <_panic>
		panic("sys_page_alloc: %e\n", r);
  8011a8:	50                   	push   %eax
  8011a9:	68 ff 29 80 00       	push   $0x8029ff
  8011ae:	6a 2e                	push   $0x2e
  8011b0:	68 f4 29 80 00       	push   $0x8029f4
  8011b5:	e8 d2 f0 ff ff       	call   80028c <_panic>
		panic("sys_page_map: %e\n", r);
  8011ba:	50                   	push   %eax
  8011bb:	68 13 2a 80 00       	push   $0x802a13
  8011c0:	6a 34                	push   $0x34
  8011c2:	68 f4 29 80 00       	push   $0x8029f4
  8011c7:	e8 c0 f0 ff ff       	call   80028c <_panic>
		panic("sys_page_unmap: %e\n", r);
  8011cc:	50                   	push   %eax
  8011cd:	68 25 2a 80 00       	push   $0x802a25
  8011d2:	6a 37                	push   $0x37
  8011d4:	68 f4 29 80 00       	push   $0x8029f4
  8011d9:	e8 ae f0 ff ff       	call   80028c <_panic>

008011de <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	57                   	push   %edi
  8011e2:	56                   	push   %esi
  8011e3:	53                   	push   %ebx
  8011e4:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  8011e7:	68 da 10 80 00       	push   $0x8010da
  8011ec:	e8 c9 0e 00 00       	call   8020ba <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011f1:	b8 07 00 00 00       	mov    $0x7,%eax
  8011f6:	cd 30                	int    $0x30
  8011f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	78 30                	js     801232 <fork+0x54>
  801202:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801204:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801209:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80120d:	0f 85 a5 00 00 00    	jne    8012b8 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  801213:	e8 11 fc ff ff       	call   800e29 <sys_getenvid>
  801218:	25 ff 03 00 00       	and    $0x3ff,%eax
  80121d:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  801220:	c1 e0 04             	shl    $0x4,%eax
  801223:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801228:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80122d:	e9 75 01 00 00       	jmp    8013a7 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  801232:	50                   	push   %eax
  801233:	68 39 2a 80 00       	push   $0x802a39
  801238:	68 83 00 00 00       	push   $0x83
  80123d:	68 f4 29 80 00       	push   $0x8029f4
  801242:	e8 45 f0 ff ff       	call   80028c <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801247:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	25 07 0e 00 00       	and    $0xe07,%eax
  801256:	50                   	push   %eax
  801257:	56                   	push   %esi
  801258:	57                   	push   %edi
  801259:	56                   	push   %esi
  80125a:	6a 00                	push   $0x0
  80125c:	e8 49 fc ff ff       	call   800eaa <sys_page_map>
  801261:	83 c4 20             	add    $0x20,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	79 3e                	jns    8012a6 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801268:	50                   	push   %eax
  801269:	68 13 2a 80 00       	push   $0x802a13
  80126e:	6a 50                	push   $0x50
  801270:	68 f4 29 80 00       	push   $0x8029f4
  801275:	e8 12 f0 ff ff       	call   80028c <_panic>
			panic("sys_page_map: %e\n", r);
  80127a:	50                   	push   %eax
  80127b:	68 13 2a 80 00       	push   $0x802a13
  801280:	6a 54                	push   $0x54
  801282:	68 f4 29 80 00       	push   $0x8029f4
  801287:	e8 00 f0 ff ff       	call   80028c <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	6a 05                	push   $0x5
  801291:	56                   	push   %esi
  801292:	57                   	push   %edi
  801293:	56                   	push   %esi
  801294:	6a 00                	push   $0x0
  801296:	e8 0f fc ff ff       	call   800eaa <sys_page_map>
  80129b:	83 c4 20             	add    $0x20,%esp
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	0f 88 ab 00 00 00    	js     801351 <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8012a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012ac:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8012b2:	0f 84 ab 00 00 00    	je     801363 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  8012b8:	89 d8                	mov    %ebx,%eax
  8012ba:	c1 e8 16             	shr    $0x16,%eax
  8012bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c4:	a8 01                	test   $0x1,%al
  8012c6:	74 de                	je     8012a6 <fork+0xc8>
  8012c8:	89 d8                	mov    %ebx,%eax
  8012ca:	c1 e8 0c             	shr    $0xc,%eax
  8012cd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012d4:	f6 c2 01             	test   $0x1,%dl
  8012d7:	74 cd                	je     8012a6 <fork+0xc8>
  8012d9:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8012df:	74 c5                	je     8012a6 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  8012e1:	89 c6                	mov    %eax,%esi
  8012e3:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  8012e6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ed:	f6 c6 04             	test   $0x4,%dh
  8012f0:	0f 85 51 ff ff ff    	jne    801247 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  8012f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012fd:	a9 02 08 00 00       	test   $0x802,%eax
  801302:	74 88                	je     80128c <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	68 05 08 00 00       	push   $0x805
  80130c:	56                   	push   %esi
  80130d:	57                   	push   %edi
  80130e:	56                   	push   %esi
  80130f:	6a 00                	push   $0x0
  801311:	e8 94 fb ff ff       	call   800eaa <sys_page_map>
  801316:	83 c4 20             	add    $0x20,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	0f 88 59 ff ff ff    	js     80127a <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801321:	83 ec 0c             	sub    $0xc,%esp
  801324:	68 05 08 00 00       	push   $0x805
  801329:	56                   	push   %esi
  80132a:	6a 00                	push   $0x0
  80132c:	56                   	push   %esi
  80132d:	6a 00                	push   $0x0
  80132f:	e8 76 fb ff ff       	call   800eaa <sys_page_map>
  801334:	83 c4 20             	add    $0x20,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	0f 89 67 ff ff ff    	jns    8012a6 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  80133f:	50                   	push   %eax
  801340:	68 13 2a 80 00       	push   $0x802a13
  801345:	6a 56                	push   $0x56
  801347:	68 f4 29 80 00       	push   $0x8029f4
  80134c:	e8 3b ef ff ff       	call   80028c <_panic>
			panic("sys_page_map: %e\n", r);
  801351:	50                   	push   %eax
  801352:	68 13 2a 80 00       	push   $0x802a13
  801357:	6a 5a                	push   $0x5a
  801359:	68 f4 29 80 00       	push   $0x8029f4
  80135e:	e8 29 ef ff ff       	call   80028c <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	6a 07                	push   $0x7
  801368:	68 00 f0 bf ee       	push   $0xeebff000
  80136d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801370:	e8 f2 fa ff ff       	call   800e67 <sys_page_alloc>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 36                	js     8013b2 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80137c:	83 ec 08             	sub    $0x8,%esp
  80137f:	68 25 21 80 00       	push   $0x802125
  801384:	ff 75 e4             	pushl  -0x1c(%ebp)
  801387:	e8 67 fc ff ff       	call   800ff3 <sys_env_set_pgfault_upcall>
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	85 c0                	test   %eax,%eax
  801391:	78 34                	js     8013c7 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801393:	83 ec 08             	sub    $0x8,%esp
  801396:	6a 02                	push   $0x2
  801398:	ff 75 e4             	pushl  -0x1c(%ebp)
  80139b:	e8 cf fb ff ff       	call   800f6f <sys_env_set_status>
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 35                	js     8013dc <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  8013a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  8013b2:	50                   	push   %eax
  8013b3:	68 ff 29 80 00       	push   $0x8029ff
  8013b8:	68 95 00 00 00       	push   $0x95
  8013bd:	68 f4 29 80 00       	push   $0x8029f4
  8013c2:	e8 c5 ee ff ff       	call   80028c <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  8013c7:	50                   	push   %eax
  8013c8:	68 d4 29 80 00       	push   $0x8029d4
  8013cd:	68 98 00 00 00       	push   $0x98
  8013d2:	68 f4 29 80 00       	push   $0x8029f4
  8013d7:	e8 b0 ee ff ff       	call   80028c <_panic>
		panic("sys_env_set_status: %e\n", r);
  8013dc:	50                   	push   %eax
  8013dd:	68 49 2a 80 00       	push   $0x802a49
  8013e2:	68 9b 00 00 00       	push   $0x9b
  8013e7:	68 f4 29 80 00       	push   $0x8029f4
  8013ec:	e8 9b ee ff ff       	call   80028c <_panic>

008013f1 <sfork>:

// Challenge!
int
sfork(void)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8013f7:	68 61 2a 80 00       	push   $0x802a61
  8013fc:	68 a4 00 00 00       	push   $0xa4
  801401:	68 f4 29 80 00       	push   $0x8029f4
  801406:	e8 81 ee ff ff       	call   80028c <_panic>

0080140b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	05 00 00 00 30       	add    $0x30000000,%eax
  801416:	c1 e8 0c             	shr    $0xc,%eax
}
  801419:	5d                   	pop    %ebp
  80141a:	c3                   	ret    

0080141b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801426:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80142b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    

00801432 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80143a:	89 c2                	mov    %eax,%edx
  80143c:	c1 ea 16             	shr    $0x16,%edx
  80143f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801446:	f6 c2 01             	test   $0x1,%dl
  801449:	74 2d                	je     801478 <fd_alloc+0x46>
  80144b:	89 c2                	mov    %eax,%edx
  80144d:	c1 ea 0c             	shr    $0xc,%edx
  801450:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801457:	f6 c2 01             	test   $0x1,%dl
  80145a:	74 1c                	je     801478 <fd_alloc+0x46>
  80145c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801461:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801466:	75 d2                	jne    80143a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801471:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801476:	eb 0a                	jmp    801482 <fd_alloc+0x50>
			*fd_store = fd;
  801478:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80147b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80148a:	83 f8 1f             	cmp    $0x1f,%eax
  80148d:	77 30                	ja     8014bf <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80148f:	c1 e0 0c             	shl    $0xc,%eax
  801492:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801497:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80149d:	f6 c2 01             	test   $0x1,%dl
  8014a0:	74 24                	je     8014c6 <fd_lookup+0x42>
  8014a2:	89 c2                	mov    %eax,%edx
  8014a4:	c1 ea 0c             	shr    $0xc,%edx
  8014a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ae:	f6 c2 01             	test   $0x1,%dl
  8014b1:	74 1a                	je     8014cd <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b6:	89 02                	mov    %eax,(%edx)
	return 0;
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014bd:	5d                   	pop    %ebp
  8014be:	c3                   	ret    
		return -E_INVAL;
  8014bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c4:	eb f7                	jmp    8014bd <fd_lookup+0x39>
		return -E_INVAL;
  8014c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014cb:	eb f0                	jmp    8014bd <fd_lookup+0x39>
  8014cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d2:	eb e9                	jmp    8014bd <fd_lookup+0x39>

008014d4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014dd:	ba f8 2a 80 00       	mov    $0x802af8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014e2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014e7:	39 08                	cmp    %ecx,(%eax)
  8014e9:	74 33                	je     80151e <dev_lookup+0x4a>
  8014eb:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014ee:	8b 02                	mov    (%edx),%eax
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	75 f3                	jne    8014e7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014f4:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f9:	8b 40 48             	mov    0x48(%eax),%eax
  8014fc:	83 ec 04             	sub    $0x4,%esp
  8014ff:	51                   	push   %ecx
  801500:	50                   	push   %eax
  801501:	68 78 2a 80 00       	push   $0x802a78
  801506:	e8 5c ee ff ff       	call   800367 <cprintf>
	*dev = 0;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    
			*dev = devtab[i];
  80151e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801521:	89 01                	mov    %eax,(%ecx)
			return 0;
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	eb f2                	jmp    80151c <dev_lookup+0x48>

0080152a <fd_close>:
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	57                   	push   %edi
  80152e:	56                   	push   %esi
  80152f:	53                   	push   %ebx
  801530:	83 ec 24             	sub    $0x24,%esp
  801533:	8b 75 08             	mov    0x8(%ebp),%esi
  801536:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801539:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80153c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80153d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801543:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801546:	50                   	push   %eax
  801547:	e8 38 ff ff ff       	call   801484 <fd_lookup>
  80154c:	89 c3                	mov    %eax,%ebx
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 05                	js     80155a <fd_close+0x30>
	    || fd != fd2)
  801555:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801558:	74 16                	je     801570 <fd_close+0x46>
		return (must_exist ? r : 0);
  80155a:	89 f8                	mov    %edi,%eax
  80155c:	84 c0                	test   %al,%al
  80155e:	b8 00 00 00 00       	mov    $0x0,%eax
  801563:	0f 44 d8             	cmove  %eax,%ebx
}
  801566:	89 d8                	mov    %ebx,%eax
  801568:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156b:	5b                   	pop    %ebx
  80156c:	5e                   	pop    %esi
  80156d:	5f                   	pop    %edi
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801570:	83 ec 08             	sub    $0x8,%esp
  801573:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	ff 36                	pushl  (%esi)
  801579:	e8 56 ff ff ff       	call   8014d4 <dev_lookup>
  80157e:	89 c3                	mov    %eax,%ebx
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	78 1a                	js     8015a1 <fd_close+0x77>
		if (dev->dev_close)
  801587:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80158d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801592:	85 c0                	test   %eax,%eax
  801594:	74 0b                	je     8015a1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801596:	83 ec 0c             	sub    $0xc,%esp
  801599:	56                   	push   %esi
  80159a:	ff d0                	call   *%eax
  80159c:	89 c3                	mov    %eax,%ebx
  80159e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	56                   	push   %esi
  8015a5:	6a 00                	push   $0x0
  8015a7:	e8 40 f9 ff ff       	call   800eec <sys_page_unmap>
	return r;
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	eb b5                	jmp    801566 <fd_close+0x3c>

008015b1 <close>:

int
close(int fdnum)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 c1 fe ff ff       	call   801484 <fd_lookup>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	79 02                	jns    8015cc <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    
		return fd_close(fd, 1);
  8015cc:	83 ec 08             	sub    $0x8,%esp
  8015cf:	6a 01                	push   $0x1
  8015d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d4:	e8 51 ff ff ff       	call   80152a <fd_close>
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	eb ec                	jmp    8015ca <close+0x19>

008015de <close_all>:

void
close_all(void)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	53                   	push   %ebx
  8015e2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015ea:	83 ec 0c             	sub    $0xc,%esp
  8015ed:	53                   	push   %ebx
  8015ee:	e8 be ff ff ff       	call   8015b1 <close>
	for (i = 0; i < MAXFD; i++)
  8015f3:	83 c3 01             	add    $0x1,%ebx
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	83 fb 20             	cmp    $0x20,%ebx
  8015fc:	75 ec                	jne    8015ea <close_all+0xc>
}
  8015fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80160c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80160f:	50                   	push   %eax
  801610:	ff 75 08             	pushl  0x8(%ebp)
  801613:	e8 6c fe ff ff       	call   801484 <fd_lookup>
  801618:	89 c3                	mov    %eax,%ebx
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	85 c0                	test   %eax,%eax
  80161f:	0f 88 81 00 00 00    	js     8016a6 <dup+0xa3>
		return r;
	close(newfdnum);
  801625:	83 ec 0c             	sub    $0xc,%esp
  801628:	ff 75 0c             	pushl  0xc(%ebp)
  80162b:	e8 81 ff ff ff       	call   8015b1 <close>

	newfd = INDEX2FD(newfdnum);
  801630:	8b 75 0c             	mov    0xc(%ebp),%esi
  801633:	c1 e6 0c             	shl    $0xc,%esi
  801636:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80163c:	83 c4 04             	add    $0x4,%esp
  80163f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801642:	e8 d4 fd ff ff       	call   80141b <fd2data>
  801647:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801649:	89 34 24             	mov    %esi,(%esp)
  80164c:	e8 ca fd ff ff       	call   80141b <fd2data>
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801656:	89 d8                	mov    %ebx,%eax
  801658:	c1 e8 16             	shr    $0x16,%eax
  80165b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801662:	a8 01                	test   $0x1,%al
  801664:	74 11                	je     801677 <dup+0x74>
  801666:	89 d8                	mov    %ebx,%eax
  801668:	c1 e8 0c             	shr    $0xc,%eax
  80166b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801672:	f6 c2 01             	test   $0x1,%dl
  801675:	75 39                	jne    8016b0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801677:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80167a:	89 d0                	mov    %edx,%eax
  80167c:	c1 e8 0c             	shr    $0xc,%eax
  80167f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	25 07 0e 00 00       	and    $0xe07,%eax
  80168e:	50                   	push   %eax
  80168f:	56                   	push   %esi
  801690:	6a 00                	push   $0x0
  801692:	52                   	push   %edx
  801693:	6a 00                	push   $0x0
  801695:	e8 10 f8 ff ff       	call   800eaa <sys_page_map>
  80169a:	89 c3                	mov    %eax,%ebx
  80169c:	83 c4 20             	add    $0x20,%esp
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	78 31                	js     8016d4 <dup+0xd1>
		goto err;

	return newfdnum;
  8016a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016a6:	89 d8                	mov    %ebx,%eax
  8016a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ab:	5b                   	pop    %ebx
  8016ac:	5e                   	pop    %esi
  8016ad:	5f                   	pop    %edi
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016b7:	83 ec 0c             	sub    $0xc,%esp
  8016ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8016bf:	50                   	push   %eax
  8016c0:	57                   	push   %edi
  8016c1:	6a 00                	push   $0x0
  8016c3:	53                   	push   %ebx
  8016c4:	6a 00                	push   $0x0
  8016c6:	e8 df f7 ff ff       	call   800eaa <sys_page_map>
  8016cb:	89 c3                	mov    %eax,%ebx
  8016cd:	83 c4 20             	add    $0x20,%esp
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	79 a3                	jns    801677 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016d4:	83 ec 08             	sub    $0x8,%esp
  8016d7:	56                   	push   %esi
  8016d8:	6a 00                	push   $0x0
  8016da:	e8 0d f8 ff ff       	call   800eec <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016df:	83 c4 08             	add    $0x8,%esp
  8016e2:	57                   	push   %edi
  8016e3:	6a 00                	push   $0x0
  8016e5:	e8 02 f8 ff ff       	call   800eec <sys_page_unmap>
	return r;
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	eb b7                	jmp    8016a6 <dup+0xa3>

008016ef <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	53                   	push   %ebx
  8016f3:	83 ec 1c             	sub    $0x1c,%esp
  8016f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016fc:	50                   	push   %eax
  8016fd:	53                   	push   %ebx
  8016fe:	e8 81 fd ff ff       	call   801484 <fd_lookup>
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	85 c0                	test   %eax,%eax
  801708:	78 3f                	js     801749 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80170a:	83 ec 08             	sub    $0x8,%esp
  80170d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801710:	50                   	push   %eax
  801711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801714:	ff 30                	pushl  (%eax)
  801716:	e8 b9 fd ff ff       	call   8014d4 <dev_lookup>
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	85 c0                	test   %eax,%eax
  801720:	78 27                	js     801749 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801722:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801725:	8b 42 08             	mov    0x8(%edx),%eax
  801728:	83 e0 03             	and    $0x3,%eax
  80172b:	83 f8 01             	cmp    $0x1,%eax
  80172e:	74 1e                	je     80174e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801733:	8b 40 08             	mov    0x8(%eax),%eax
  801736:	85 c0                	test   %eax,%eax
  801738:	74 35                	je     80176f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	ff 75 10             	pushl  0x10(%ebp)
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	52                   	push   %edx
  801744:	ff d0                	call   *%eax
  801746:	83 c4 10             	add    $0x10,%esp
}
  801749:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80174e:	a1 04 40 80 00       	mov    0x804004,%eax
  801753:	8b 40 48             	mov    0x48(%eax),%eax
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	53                   	push   %ebx
  80175a:	50                   	push   %eax
  80175b:	68 bc 2a 80 00       	push   $0x802abc
  801760:	e8 02 ec ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176d:	eb da                	jmp    801749 <read+0x5a>
		return -E_NOT_SUPP;
  80176f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801774:	eb d3                	jmp    801749 <read+0x5a>

00801776 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	57                   	push   %edi
  80177a:	56                   	push   %esi
  80177b:	53                   	push   %ebx
  80177c:	83 ec 0c             	sub    $0xc,%esp
  80177f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801782:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801785:	bb 00 00 00 00       	mov    $0x0,%ebx
  80178a:	39 f3                	cmp    %esi,%ebx
  80178c:	73 23                	jae    8017b1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	89 f0                	mov    %esi,%eax
  801793:	29 d8                	sub    %ebx,%eax
  801795:	50                   	push   %eax
  801796:	89 d8                	mov    %ebx,%eax
  801798:	03 45 0c             	add    0xc(%ebp),%eax
  80179b:	50                   	push   %eax
  80179c:	57                   	push   %edi
  80179d:	e8 4d ff ff ff       	call   8016ef <read>
		if (m < 0)
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 06                	js     8017af <readn+0x39>
			return m;
		if (m == 0)
  8017a9:	74 06                	je     8017b1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8017ab:	01 c3                	add    %eax,%ebx
  8017ad:	eb db                	jmp    80178a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017af:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017b1:	89 d8                	mov    %ebx,%eax
  8017b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b6:	5b                   	pop    %ebx
  8017b7:	5e                   	pop    %esi
  8017b8:	5f                   	pop    %edi
  8017b9:	5d                   	pop    %ebp
  8017ba:	c3                   	ret    

008017bb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	53                   	push   %ebx
  8017bf:	83 ec 1c             	sub    $0x1c,%esp
  8017c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c8:	50                   	push   %eax
  8017c9:	53                   	push   %ebx
  8017ca:	e8 b5 fc ff ff       	call   801484 <fd_lookup>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 3a                	js     801810 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017dc:	50                   	push   %eax
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e0:	ff 30                	pushl  (%eax)
  8017e2:	e8 ed fc ff ff       	call   8014d4 <dev_lookup>
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 22                	js     801810 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017f5:	74 1e                	je     801815 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fa:	8b 52 0c             	mov    0xc(%edx),%edx
  8017fd:	85 d2                	test   %edx,%edx
  8017ff:	74 35                	je     801836 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	ff 75 10             	pushl  0x10(%ebp)
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	50                   	push   %eax
  80180b:	ff d2                	call   *%edx
  80180d:	83 c4 10             	add    $0x10,%esp
}
  801810:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801813:	c9                   	leave  
  801814:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801815:	a1 04 40 80 00       	mov    0x804004,%eax
  80181a:	8b 40 48             	mov    0x48(%eax),%eax
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	53                   	push   %ebx
  801821:	50                   	push   %eax
  801822:	68 d8 2a 80 00       	push   $0x802ad8
  801827:	e8 3b eb ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801834:	eb da                	jmp    801810 <write+0x55>
		return -E_NOT_SUPP;
  801836:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80183b:	eb d3                	jmp    801810 <write+0x55>

0080183d <seek>:

int
seek(int fdnum, off_t offset)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801843:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801846:	50                   	push   %eax
  801847:	ff 75 08             	pushl  0x8(%ebp)
  80184a:	e8 35 fc ff ff       	call   801484 <fd_lookup>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	85 c0                	test   %eax,%eax
  801854:	78 0e                	js     801864 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	53                   	push   %ebx
  80186a:	83 ec 1c             	sub    $0x1c,%esp
  80186d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801870:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801873:	50                   	push   %eax
  801874:	53                   	push   %ebx
  801875:	e8 0a fc ff ff       	call   801484 <fd_lookup>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 37                	js     8018b8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801881:	83 ec 08             	sub    $0x8,%esp
  801884:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801887:	50                   	push   %eax
  801888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188b:	ff 30                	pushl  (%eax)
  80188d:	e8 42 fc ff ff       	call   8014d4 <dev_lookup>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	85 c0                	test   %eax,%eax
  801897:	78 1f                	js     8018b8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a0:	74 1b                	je     8018bd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a5:	8b 52 18             	mov    0x18(%edx),%edx
  8018a8:	85 d2                	test   %edx,%edx
  8018aa:	74 32                	je     8018de <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018ac:	83 ec 08             	sub    $0x8,%esp
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	50                   	push   %eax
  8018b3:	ff d2                	call   *%edx
  8018b5:	83 c4 10             	add    $0x10,%esp
}
  8018b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018bd:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018c2:	8b 40 48             	mov    0x48(%eax),%eax
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	53                   	push   %ebx
  8018c9:	50                   	push   %eax
  8018ca:	68 98 2a 80 00       	push   $0x802a98
  8018cf:	e8 93 ea ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018dc:	eb da                	jmp    8018b8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e3:	eb d3                	jmp    8018b8 <ftruncate+0x52>

008018e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	53                   	push   %ebx
  8018e9:	83 ec 1c             	sub    $0x1c,%esp
  8018ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f2:	50                   	push   %eax
  8018f3:	ff 75 08             	pushl  0x8(%ebp)
  8018f6:	e8 89 fb ff ff       	call   801484 <fd_lookup>
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	85 c0                	test   %eax,%eax
  801900:	78 4b                	js     80194d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801902:	83 ec 08             	sub    $0x8,%esp
  801905:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801908:	50                   	push   %eax
  801909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190c:	ff 30                	pushl  (%eax)
  80190e:	e8 c1 fb ff ff       	call   8014d4 <dev_lookup>
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	85 c0                	test   %eax,%eax
  801918:	78 33                	js     80194d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80191a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801921:	74 2f                	je     801952 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801923:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801926:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80192d:	00 00 00 
	stat->st_isdir = 0;
  801930:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801937:	00 00 00 
	stat->st_dev = dev;
  80193a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	53                   	push   %ebx
  801944:	ff 75 f0             	pushl  -0x10(%ebp)
  801947:	ff 50 14             	call   *0x14(%eax)
  80194a:	83 c4 10             	add    $0x10,%esp
}
  80194d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801950:	c9                   	leave  
  801951:	c3                   	ret    
		return -E_NOT_SUPP;
  801952:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801957:	eb f4                	jmp    80194d <fstat+0x68>

00801959 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	56                   	push   %esi
  80195d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80195e:	83 ec 08             	sub    $0x8,%esp
  801961:	6a 00                	push   $0x0
  801963:	ff 75 08             	pushl  0x8(%ebp)
  801966:	e8 e7 01 00 00       	call   801b52 <open>
  80196b:	89 c3                	mov    %eax,%ebx
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	78 1b                	js     80198f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	50                   	push   %eax
  80197b:	e8 65 ff ff ff       	call   8018e5 <fstat>
  801980:	89 c6                	mov    %eax,%esi
	close(fd);
  801982:	89 1c 24             	mov    %ebx,(%esp)
  801985:	e8 27 fc ff ff       	call   8015b1 <close>
	return r;
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	89 f3                	mov    %esi,%ebx
}
  80198f:	89 d8                	mov    %ebx,%eax
  801991:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    

00801998 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	56                   	push   %esi
  80199c:	53                   	push   %ebx
  80199d:	89 c6                	mov    %eax,%esi
  80199f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019a1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019a8:	74 27                	je     8019d1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019aa:	6a 07                	push   $0x7
  8019ac:	68 00 50 80 00       	push   $0x805000
  8019b1:	56                   	push   %esi
  8019b2:	ff 35 00 40 80 00    	pushl  0x804000
  8019b8:	e8 f5 07 00 00       	call   8021b2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019bd:	83 c4 0c             	add    $0xc,%esp
  8019c0:	6a 00                	push   $0x0
  8019c2:	53                   	push   %ebx
  8019c3:	6a 00                	push   $0x0
  8019c5:	e8 81 07 00 00       	call   80214b <ipc_recv>
}
  8019ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019cd:	5b                   	pop    %ebx
  8019ce:	5e                   	pop    %esi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019d1:	83 ec 0c             	sub    $0xc,%esp
  8019d4:	6a 01                	push   $0x1
  8019d6:	e8 20 08 00 00       	call   8021fb <ipc_find_env>
  8019db:	a3 00 40 80 00       	mov    %eax,0x804000
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	eb c5                	jmp    8019aa <fsipc+0x12>

008019e5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801a03:	b8 02 00 00 00       	mov    $0x2,%eax
  801a08:	e8 8b ff ff ff       	call   801998 <fsipc>
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <devfile_flush>:
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a20:	ba 00 00 00 00       	mov    $0x0,%edx
  801a25:	b8 06 00 00 00       	mov    $0x6,%eax
  801a2a:	e8 69 ff ff ff       	call   801998 <fsipc>
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <devfile_stat>:
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	53                   	push   %ebx
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a41:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a46:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4b:	b8 05 00 00 00       	mov    $0x5,%eax
  801a50:	e8 43 ff ff ff       	call   801998 <fsipc>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 2c                	js     801a85 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a59:	83 ec 08             	sub    $0x8,%esp
  801a5c:	68 00 50 80 00       	push   $0x805000
  801a61:	53                   	push   %ebx
  801a62:	e8 0e f0 ff ff       	call   800a75 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a67:	a1 80 50 80 00       	mov    0x805080,%eax
  801a6c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a72:	a1 84 50 80 00       	mov    0x805084,%eax
  801a77:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <devfile_write>:
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 0c             	sub    $0xc,%esp
  801a90:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a93:	8b 55 08             	mov    0x8(%ebp),%edx
  801a96:	8b 52 0c             	mov    0xc(%edx),%edx
  801a99:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801a9f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801aa4:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801aa9:	0f 47 c2             	cmova  %edx,%eax
  801aac:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801ab1:	50                   	push   %eax
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	68 08 50 80 00       	push   $0x805008
  801aba:	e8 44 f1 ff ff       	call   800c03 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801abf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ac9:	e8 ca fe ff ff       	call   801998 <fsipc>
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <devfile_read>:
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	56                   	push   %esi
  801ad4:	53                   	push   %ebx
  801ad5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ade:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ae3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  801aee:	b8 03 00 00 00       	mov    $0x3,%eax
  801af3:	e8 a0 fe ff ff       	call   801998 <fsipc>
  801af8:	89 c3                	mov    %eax,%ebx
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 1f                	js     801b1d <devfile_read+0x4d>
	assert(r <= n);
  801afe:	39 f0                	cmp    %esi,%eax
  801b00:	77 24                	ja     801b26 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b02:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b07:	7f 33                	jg     801b3c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b09:	83 ec 04             	sub    $0x4,%esp
  801b0c:	50                   	push   %eax
  801b0d:	68 00 50 80 00       	push   $0x805000
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 e9 f0 ff ff       	call   800c03 <memmove>
	return r;
  801b1a:	83 c4 10             	add    $0x10,%esp
}
  801b1d:	89 d8                	mov    %ebx,%eax
  801b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b22:	5b                   	pop    %ebx
  801b23:	5e                   	pop    %esi
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    
	assert(r <= n);
  801b26:	68 08 2b 80 00       	push   $0x802b08
  801b2b:	68 0f 2b 80 00       	push   $0x802b0f
  801b30:	6a 7c                	push   $0x7c
  801b32:	68 24 2b 80 00       	push   $0x802b24
  801b37:	e8 50 e7 ff ff       	call   80028c <_panic>
	assert(r <= PGSIZE);
  801b3c:	68 2f 2b 80 00       	push   $0x802b2f
  801b41:	68 0f 2b 80 00       	push   $0x802b0f
  801b46:	6a 7d                	push   $0x7d
  801b48:	68 24 2b 80 00       	push   $0x802b24
  801b4d:	e8 3a e7 ff ff       	call   80028c <_panic>

00801b52 <open>:
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	56                   	push   %esi
  801b56:	53                   	push   %ebx
  801b57:	83 ec 1c             	sub    $0x1c,%esp
  801b5a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b5d:	56                   	push   %esi
  801b5e:	e8 d9 ee ff ff       	call   800a3c <strlen>
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b6b:	7f 6c                	jg     801bd9 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b6d:	83 ec 0c             	sub    $0xc,%esp
  801b70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b73:	50                   	push   %eax
  801b74:	e8 b9 f8 ff ff       	call   801432 <fd_alloc>
  801b79:	89 c3                	mov    %eax,%ebx
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 3c                	js     801bbe <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	56                   	push   %esi
  801b86:	68 00 50 80 00       	push   $0x805000
  801b8b:	e8 e5 ee ff ff       	call   800a75 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b93:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba0:	e8 f3 fd ff ff       	call   801998 <fsipc>
  801ba5:	89 c3                	mov    %eax,%ebx
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 19                	js     801bc7 <open+0x75>
	return fd2num(fd);
  801bae:	83 ec 0c             	sub    $0xc,%esp
  801bb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb4:	e8 52 f8 ff ff       	call   80140b <fd2num>
  801bb9:	89 c3                	mov    %eax,%ebx
  801bbb:	83 c4 10             	add    $0x10,%esp
}
  801bbe:	89 d8                	mov    %ebx,%eax
  801bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    
		fd_close(fd, 0);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 f4             	pushl  -0xc(%ebp)
  801bcf:	e8 56 f9 ff ff       	call   80152a <fd_close>
		return r;
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	eb e5                	jmp    801bbe <open+0x6c>
		return -E_BAD_PATH;
  801bd9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bde:	eb de                	jmp    801bbe <open+0x6c>

00801be0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801be6:	ba 00 00 00 00       	mov    $0x0,%edx
  801beb:	b8 08 00 00 00       	mov    $0x8,%eax
  801bf0:	e8 a3 fd ff ff       	call   801998 <fsipc>
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	56                   	push   %esi
  801bfb:	53                   	push   %ebx
  801bfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bff:	83 ec 0c             	sub    $0xc,%esp
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 11 f8 ff ff       	call   80141b <fd2data>
  801c0a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c0c:	83 c4 08             	add    $0x8,%esp
  801c0f:	68 3b 2b 80 00       	push   $0x802b3b
  801c14:	53                   	push   %ebx
  801c15:	e8 5b ee ff ff       	call   800a75 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c1a:	8b 46 04             	mov    0x4(%esi),%eax
  801c1d:	2b 06                	sub    (%esi),%eax
  801c1f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c25:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c2c:	00 00 00 
	stat->st_dev = &devpipe;
  801c2f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c36:	30 80 00 
	return 0;
}
  801c39:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c41:	5b                   	pop    %ebx
  801c42:	5e                   	pop    %esi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	53                   	push   %ebx
  801c49:	83 ec 0c             	sub    $0xc,%esp
  801c4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c4f:	53                   	push   %ebx
  801c50:	6a 00                	push   $0x0
  801c52:	e8 95 f2 ff ff       	call   800eec <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c57:	89 1c 24             	mov    %ebx,(%esp)
  801c5a:	e8 bc f7 ff ff       	call   80141b <fd2data>
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	50                   	push   %eax
  801c63:	6a 00                	push   $0x0
  801c65:	e8 82 f2 ff ff       	call   800eec <sys_page_unmap>
}
  801c6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <_pipeisclosed>:
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	57                   	push   %edi
  801c73:	56                   	push   %esi
  801c74:	53                   	push   %ebx
  801c75:	83 ec 1c             	sub    $0x1c,%esp
  801c78:	89 c7                	mov    %eax,%edi
  801c7a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c7c:	a1 04 40 80 00       	mov    0x804004,%eax
  801c81:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	57                   	push   %edi
  801c88:	e8 ad 05 00 00       	call   80223a <pageref>
  801c8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c90:	89 34 24             	mov    %esi,(%esp)
  801c93:	e8 a2 05 00 00       	call   80223a <pageref>
		nn = thisenv->env_runs;
  801c98:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c9e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	39 cb                	cmp    %ecx,%ebx
  801ca6:	74 1b                	je     801cc3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ca8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cab:	75 cf                	jne    801c7c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cad:	8b 42 58             	mov    0x58(%edx),%eax
  801cb0:	6a 01                	push   $0x1
  801cb2:	50                   	push   %eax
  801cb3:	53                   	push   %ebx
  801cb4:	68 42 2b 80 00       	push   $0x802b42
  801cb9:	e8 a9 e6 ff ff       	call   800367 <cprintf>
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	eb b9                	jmp    801c7c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cc3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cc6:	0f 94 c0             	sete   %al
  801cc9:	0f b6 c0             	movzbl %al,%eax
}
  801ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5f                   	pop    %edi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    

00801cd4 <devpipe_write>:
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	57                   	push   %edi
  801cd8:	56                   	push   %esi
  801cd9:	53                   	push   %ebx
  801cda:	83 ec 28             	sub    $0x28,%esp
  801cdd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ce0:	56                   	push   %esi
  801ce1:	e8 35 f7 ff ff       	call   80141b <fd2data>
  801ce6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cf3:	74 4f                	je     801d44 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cf5:	8b 43 04             	mov    0x4(%ebx),%eax
  801cf8:	8b 0b                	mov    (%ebx),%ecx
  801cfa:	8d 51 20             	lea    0x20(%ecx),%edx
  801cfd:	39 d0                	cmp    %edx,%eax
  801cff:	72 14                	jb     801d15 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d01:	89 da                	mov    %ebx,%edx
  801d03:	89 f0                	mov    %esi,%eax
  801d05:	e8 65 ff ff ff       	call   801c6f <_pipeisclosed>
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	75 3b                	jne    801d49 <devpipe_write+0x75>
			sys_yield();
  801d0e:	e8 35 f1 ff ff       	call   800e48 <sys_yield>
  801d13:	eb e0                	jmp    801cf5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d18:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d1c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d1f:	89 c2                	mov    %eax,%edx
  801d21:	c1 fa 1f             	sar    $0x1f,%edx
  801d24:	89 d1                	mov    %edx,%ecx
  801d26:	c1 e9 1b             	shr    $0x1b,%ecx
  801d29:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d2c:	83 e2 1f             	and    $0x1f,%edx
  801d2f:	29 ca                	sub    %ecx,%edx
  801d31:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d35:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d39:	83 c0 01             	add    $0x1,%eax
  801d3c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d3f:	83 c7 01             	add    $0x1,%edi
  801d42:	eb ac                	jmp    801cf0 <devpipe_write+0x1c>
	return i;
  801d44:	8b 45 10             	mov    0x10(%ebp),%eax
  801d47:	eb 05                	jmp    801d4e <devpipe_write+0x7a>
				return 0;
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d51:	5b                   	pop    %ebx
  801d52:	5e                   	pop    %esi
  801d53:	5f                   	pop    %edi
  801d54:	5d                   	pop    %ebp
  801d55:	c3                   	ret    

00801d56 <devpipe_read>:
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	57                   	push   %edi
  801d5a:	56                   	push   %esi
  801d5b:	53                   	push   %ebx
  801d5c:	83 ec 18             	sub    $0x18,%esp
  801d5f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d62:	57                   	push   %edi
  801d63:	e8 b3 f6 ff ff       	call   80141b <fd2data>
  801d68:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	be 00 00 00 00       	mov    $0x0,%esi
  801d72:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d75:	75 14                	jne    801d8b <devpipe_read+0x35>
	return i;
  801d77:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7a:	eb 02                	jmp    801d7e <devpipe_read+0x28>
				return i;
  801d7c:	89 f0                	mov    %esi,%eax
}
  801d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d81:	5b                   	pop    %ebx
  801d82:	5e                   	pop    %esi
  801d83:	5f                   	pop    %edi
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    
			sys_yield();
  801d86:	e8 bd f0 ff ff       	call   800e48 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d8b:	8b 03                	mov    (%ebx),%eax
  801d8d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d90:	75 18                	jne    801daa <devpipe_read+0x54>
			if (i > 0)
  801d92:	85 f6                	test   %esi,%esi
  801d94:	75 e6                	jne    801d7c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d96:	89 da                	mov    %ebx,%edx
  801d98:	89 f8                	mov    %edi,%eax
  801d9a:	e8 d0 fe ff ff       	call   801c6f <_pipeisclosed>
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	74 e3                	je     801d86 <devpipe_read+0x30>
				return 0;
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	eb d4                	jmp    801d7e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801daa:	99                   	cltd   
  801dab:	c1 ea 1b             	shr    $0x1b,%edx
  801dae:	01 d0                	add    %edx,%eax
  801db0:	83 e0 1f             	and    $0x1f,%eax
  801db3:	29 d0                	sub    %edx,%eax
  801db5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dbd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dc0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dc3:	83 c6 01             	add    $0x1,%esi
  801dc6:	eb aa                	jmp    801d72 <devpipe_read+0x1c>

00801dc8 <pipe>:
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	56                   	push   %esi
  801dcc:	53                   	push   %ebx
  801dcd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd3:	50                   	push   %eax
  801dd4:	e8 59 f6 ff ff       	call   801432 <fd_alloc>
  801dd9:	89 c3                	mov    %eax,%ebx
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	85 c0                	test   %eax,%eax
  801de0:	0f 88 23 01 00 00    	js     801f09 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de6:	83 ec 04             	sub    $0x4,%esp
  801de9:	68 07 04 00 00       	push   $0x407
  801dee:	ff 75 f4             	pushl  -0xc(%ebp)
  801df1:	6a 00                	push   $0x0
  801df3:	e8 6f f0 ff ff       	call   800e67 <sys_page_alloc>
  801df8:	89 c3                	mov    %eax,%ebx
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	0f 88 04 01 00 00    	js     801f09 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e0b:	50                   	push   %eax
  801e0c:	e8 21 f6 ff ff       	call   801432 <fd_alloc>
  801e11:	89 c3                	mov    %eax,%ebx
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	85 c0                	test   %eax,%eax
  801e18:	0f 88 db 00 00 00    	js     801ef9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	68 07 04 00 00       	push   $0x407
  801e26:	ff 75 f0             	pushl  -0x10(%ebp)
  801e29:	6a 00                	push   $0x0
  801e2b:	e8 37 f0 ff ff       	call   800e67 <sys_page_alloc>
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	0f 88 bc 00 00 00    	js     801ef9 <pipe+0x131>
	va = fd2data(fd0);
  801e3d:	83 ec 0c             	sub    $0xc,%esp
  801e40:	ff 75 f4             	pushl  -0xc(%ebp)
  801e43:	e8 d3 f5 ff ff       	call   80141b <fd2data>
  801e48:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4a:	83 c4 0c             	add    $0xc,%esp
  801e4d:	68 07 04 00 00       	push   $0x407
  801e52:	50                   	push   %eax
  801e53:	6a 00                	push   $0x0
  801e55:	e8 0d f0 ff ff       	call   800e67 <sys_page_alloc>
  801e5a:	89 c3                	mov    %eax,%ebx
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	0f 88 82 00 00 00    	js     801ee9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e6d:	e8 a9 f5 ff ff       	call   80141b <fd2data>
  801e72:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e79:	50                   	push   %eax
  801e7a:	6a 00                	push   $0x0
  801e7c:	56                   	push   %esi
  801e7d:	6a 00                	push   $0x0
  801e7f:	e8 26 f0 ff ff       	call   800eaa <sys_page_map>
  801e84:	89 c3                	mov    %eax,%ebx
  801e86:	83 c4 20             	add    $0x20,%esp
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	78 4e                	js     801edb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e8d:	a1 20 30 80 00       	mov    0x803020,%eax
  801e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e95:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ea1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ea4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb6:	e8 50 f5 ff ff       	call   80140b <fd2num>
  801ebb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ebe:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ec0:	83 c4 04             	add    $0x4,%esp
  801ec3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec6:	e8 40 f5 ff ff       	call   80140b <fd2num>
  801ecb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ece:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ed9:	eb 2e                	jmp    801f09 <pipe+0x141>
	sys_page_unmap(0, va);
  801edb:	83 ec 08             	sub    $0x8,%esp
  801ede:	56                   	push   %esi
  801edf:	6a 00                	push   $0x0
  801ee1:	e8 06 f0 ff ff       	call   800eec <sys_page_unmap>
  801ee6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ee9:	83 ec 08             	sub    $0x8,%esp
  801eec:	ff 75 f0             	pushl  -0x10(%ebp)
  801eef:	6a 00                	push   $0x0
  801ef1:	e8 f6 ef ff ff       	call   800eec <sys_page_unmap>
  801ef6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ef9:	83 ec 08             	sub    $0x8,%esp
  801efc:	ff 75 f4             	pushl  -0xc(%ebp)
  801eff:	6a 00                	push   $0x0
  801f01:	e8 e6 ef ff ff       	call   800eec <sys_page_unmap>
  801f06:	83 c4 10             	add    $0x10,%esp
}
  801f09:	89 d8                	mov    %ebx,%eax
  801f0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0e:	5b                   	pop    %ebx
  801f0f:	5e                   	pop    %esi
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    

00801f12 <pipeisclosed>:
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1b:	50                   	push   %eax
  801f1c:	ff 75 08             	pushl  0x8(%ebp)
  801f1f:	e8 60 f5 ff ff       	call   801484 <fd_lookup>
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	85 c0                	test   %eax,%eax
  801f29:	78 18                	js     801f43 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f31:	e8 e5 f4 ff ff       	call   80141b <fd2data>
	return _pipeisclosed(fd, p);
  801f36:	89 c2                	mov    %eax,%edx
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3b:	e8 2f fd ff ff       	call   801c6f <_pipeisclosed>
  801f40:	83 c4 10             	add    $0x10,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4a:	c3                   	ret    

00801f4b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f51:	68 55 2b 80 00       	push   $0x802b55
  801f56:	ff 75 0c             	pushl  0xc(%ebp)
  801f59:	e8 17 eb ff ff       	call   800a75 <strcpy>
	return 0;
}
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <devcons_write>:
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	57                   	push   %edi
  801f69:	56                   	push   %esi
  801f6a:	53                   	push   %ebx
  801f6b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f71:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f76:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f7c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f7f:	73 31                	jae    801fb2 <devcons_write+0x4d>
		m = n - tot;
  801f81:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f84:	29 f3                	sub    %esi,%ebx
  801f86:	83 fb 7f             	cmp    $0x7f,%ebx
  801f89:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f8e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	53                   	push   %ebx
  801f95:	89 f0                	mov    %esi,%eax
  801f97:	03 45 0c             	add    0xc(%ebp),%eax
  801f9a:	50                   	push   %eax
  801f9b:	57                   	push   %edi
  801f9c:	e8 62 ec ff ff       	call   800c03 <memmove>
		sys_cputs(buf, m);
  801fa1:	83 c4 08             	add    $0x8,%esp
  801fa4:	53                   	push   %ebx
  801fa5:	57                   	push   %edi
  801fa6:	e8 00 ee ff ff       	call   800dab <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fab:	01 de                	add    %ebx,%esi
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	eb ca                	jmp    801f7c <devcons_write+0x17>
}
  801fb2:	89 f0                	mov    %esi,%eax
  801fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fb7:	5b                   	pop    %ebx
  801fb8:	5e                   	pop    %esi
  801fb9:	5f                   	pop    %edi
  801fba:	5d                   	pop    %ebp
  801fbb:	c3                   	ret    

00801fbc <devcons_read>:
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 08             	sub    $0x8,%esp
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fcb:	74 21                	je     801fee <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801fcd:	e8 f7 ed ff ff       	call   800dc9 <sys_cgetc>
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	75 07                	jne    801fdd <devcons_read+0x21>
		sys_yield();
  801fd6:	e8 6d ee ff ff       	call   800e48 <sys_yield>
  801fdb:	eb f0                	jmp    801fcd <devcons_read+0x11>
	if (c < 0)
  801fdd:	78 0f                	js     801fee <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801fdf:	83 f8 04             	cmp    $0x4,%eax
  801fe2:	74 0c                	je     801ff0 <devcons_read+0x34>
	*(char*)vbuf = c;
  801fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe7:	88 02                	mov    %al,(%edx)
	return 1;
  801fe9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    
		return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	eb f7                	jmp    801fee <devcons_read+0x32>

00801ff7 <cputchar>:
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802003:	6a 01                	push   $0x1
  802005:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802008:	50                   	push   %eax
  802009:	e8 9d ed ff ff       	call   800dab <sys_cputs>
}
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <getchar>:
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802019:	6a 01                	push   $0x1
  80201b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80201e:	50                   	push   %eax
  80201f:	6a 00                	push   $0x0
  802021:	e8 c9 f6 ff ff       	call   8016ef <read>
	if (r < 0)
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	85 c0                	test   %eax,%eax
  80202b:	78 06                	js     802033 <getchar+0x20>
	if (r < 1)
  80202d:	74 06                	je     802035 <getchar+0x22>
	return c;
  80202f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    
		return -E_EOF;
  802035:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80203a:	eb f7                	jmp    802033 <getchar+0x20>

0080203c <iscons>:
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802042:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802045:	50                   	push   %eax
  802046:	ff 75 08             	pushl  0x8(%ebp)
  802049:	e8 36 f4 ff ff       	call   801484 <fd_lookup>
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	85 c0                	test   %eax,%eax
  802053:	78 11                	js     802066 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802058:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80205e:	39 10                	cmp    %edx,(%eax)
  802060:	0f 94 c0             	sete   %al
  802063:	0f b6 c0             	movzbl %al,%eax
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <opencons>:
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80206e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802071:	50                   	push   %eax
  802072:	e8 bb f3 ff ff       	call   801432 <fd_alloc>
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 3a                	js     8020b8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	68 07 04 00 00       	push   $0x407
  802086:	ff 75 f4             	pushl  -0xc(%ebp)
  802089:	6a 00                	push   $0x0
  80208b:	e8 d7 ed ff ff       	call   800e67 <sys_page_alloc>
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	78 21                	js     8020b8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020a0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	50                   	push   %eax
  8020b0:	e8 56 f3 ff ff       	call   80140b <fd2num>
  8020b5:	83 c4 10             	add    $0x10,%esp
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020c0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020c7:	74 0a                	je     8020d3 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8020d3:	83 ec 04             	sub    $0x4,%esp
  8020d6:	6a 07                	push   $0x7
  8020d8:	68 00 f0 bf ee       	push   $0xeebff000
  8020dd:	6a 00                	push   $0x0
  8020df:	e8 83 ed ff ff       	call   800e67 <sys_page_alloc>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 28                	js     802113 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8020eb:	83 ec 08             	sub    $0x8,%esp
  8020ee:	68 25 21 80 00       	push   $0x802125
  8020f3:	6a 00                	push   $0x0
  8020f5:	e8 f9 ee ff ff       	call   800ff3 <sys_env_set_pgfault_upcall>
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	79 c8                	jns    8020c9 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  802101:	50                   	push   %eax
  802102:	68 d4 29 80 00       	push   $0x8029d4
  802107:	6a 23                	push   $0x23
  802109:	68 79 2b 80 00       	push   $0x802b79
  80210e:	e8 79 e1 ff ff       	call   80028c <_panic>
			panic("set_pgfault_handler %e\n",r);
  802113:	50                   	push   %eax
  802114:	68 61 2b 80 00       	push   $0x802b61
  802119:	6a 21                	push   $0x21
  80211b:	68 79 2b 80 00       	push   $0x802b79
  802120:	e8 67 e1 ff ff       	call   80028c <_panic>

00802125 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802125:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802126:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80212b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80212d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  802130:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  802134:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802138:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80213b:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80213d:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802141:	83 c4 08             	add    $0x8,%esp
	popal
  802144:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802145:	83 c4 04             	add    $0x4,%esp
	popfl
  802148:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802149:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80214a:	c3                   	ret    

0080214b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	8b 75 08             	mov    0x8(%ebp),%esi
  802153:	8b 45 0c             	mov    0xc(%ebp),%eax
  802156:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  802159:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  80215b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802160:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  802163:	83 ec 0c             	sub    $0xc,%esp
  802166:	50                   	push   %eax
  802167:	e8 ec ee ff ff       	call   801058 <sys_ipc_recv>
	if (from_env_store)
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 f6                	test   %esi,%esi
  802171:	74 14                	je     802187 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  802173:	ba 00 00 00 00       	mov    $0x0,%edx
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 09                	js     802185 <ipc_recv+0x3a>
  80217c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802182:	8b 52 78             	mov    0x78(%edx),%edx
  802185:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  802187:	85 db                	test   %ebx,%ebx
  802189:	74 14                	je     80219f <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  80218b:	ba 00 00 00 00       	mov    $0x0,%edx
  802190:	85 c0                	test   %eax,%eax
  802192:	78 09                	js     80219d <ipc_recv+0x52>
  802194:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80219a:	8b 52 7c             	mov    0x7c(%edx),%edx
  80219d:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	78 08                	js     8021ab <ipc_recv+0x60>
  8021a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8021a8:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ae:	5b                   	pop    %ebx
  8021af:	5e                   	pop    %esi
  8021b0:	5d                   	pop    %ebp
  8021b1:	c3                   	ret    

008021b2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	83 ec 08             	sub    $0x8,%esp
  8021b8:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021c2:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8021c5:	ff 75 14             	pushl  0x14(%ebp)
  8021c8:	50                   	push   %eax
  8021c9:	ff 75 0c             	pushl  0xc(%ebp)
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	e8 61 ee ff ff       	call   801035 <sys_ipc_try_send>
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	78 02                	js     8021dd <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  8021dd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021e0:	75 07                	jne    8021e9 <ipc_send+0x37>
		sys_yield();
  8021e2:	e8 61 ec ff ff       	call   800e48 <sys_yield>
}
  8021e7:	eb f2                	jmp    8021db <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  8021e9:	50                   	push   %eax
  8021ea:	68 87 2b 80 00       	push   $0x802b87
  8021ef:	6a 3c                	push   $0x3c
  8021f1:	68 9b 2b 80 00       	push   $0x802b9b
  8021f6:	e8 91 e0 ff ff       	call   80028c <_panic>

008021fb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802201:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  802206:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802209:	c1 e0 04             	shl    $0x4,%eax
  80220c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802211:	8b 40 50             	mov    0x50(%eax),%eax
  802214:	39 c8                	cmp    %ecx,%eax
  802216:	74 12                	je     80222a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802218:	83 c2 01             	add    $0x1,%edx
  80221b:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  802221:	75 e3                	jne    802206 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	eb 0e                	jmp    802238 <ipc_find_env+0x3d>
			return envs[i].env_id;
  80222a:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80222d:	c1 e0 04             	shl    $0x4,%eax
  802230:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802235:	8b 40 48             	mov    0x48(%eax),%eax
}
  802238:	5d                   	pop    %ebp
  802239:	c3                   	ret    

0080223a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802240:	89 d0                	mov    %edx,%eax
  802242:	c1 e8 16             	shr    $0x16,%eax
  802245:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802251:	f6 c1 01             	test   $0x1,%cl
  802254:	74 1d                	je     802273 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802256:	c1 ea 0c             	shr    $0xc,%edx
  802259:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802260:	f6 c2 01             	test   $0x1,%dl
  802263:	74 0e                	je     802273 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802265:	c1 ea 0c             	shr    $0xc,%edx
  802268:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80226f:	ef 
  802270:	0f b7 c0             	movzwl %ax,%eax
}
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    
  802275:	66 90                	xchg   %ax,%ax
  802277:	66 90                	xchg   %ax,%ax
  802279:	66 90                	xchg   %ax,%ax
  80227b:	66 90                	xchg   %ax,%ax
  80227d:	66 90                	xchg   %ax,%ax
  80227f:	90                   	nop

00802280 <__udivdi3>:
  802280:	55                   	push   %ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 1c             	sub    $0x1c,%esp
  802287:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80228b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80228f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802293:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802297:	85 d2                	test   %edx,%edx
  802299:	75 4d                	jne    8022e8 <__udivdi3+0x68>
  80229b:	39 f3                	cmp    %esi,%ebx
  80229d:	76 19                	jbe    8022b8 <__udivdi3+0x38>
  80229f:	31 ff                	xor    %edi,%edi
  8022a1:	89 e8                	mov    %ebp,%eax
  8022a3:	89 f2                	mov    %esi,%edx
  8022a5:	f7 f3                	div    %ebx
  8022a7:	89 fa                	mov    %edi,%edx
  8022a9:	83 c4 1c             	add    $0x1c,%esp
  8022ac:	5b                   	pop    %ebx
  8022ad:	5e                   	pop    %esi
  8022ae:	5f                   	pop    %edi
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    
  8022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	89 d9                	mov    %ebx,%ecx
  8022ba:	85 db                	test   %ebx,%ebx
  8022bc:	75 0b                	jne    8022c9 <__udivdi3+0x49>
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	31 d2                	xor    %edx,%edx
  8022c5:	f7 f3                	div    %ebx
  8022c7:	89 c1                	mov    %eax,%ecx
  8022c9:	31 d2                	xor    %edx,%edx
  8022cb:	89 f0                	mov    %esi,%eax
  8022cd:	f7 f1                	div    %ecx
  8022cf:	89 c6                	mov    %eax,%esi
  8022d1:	89 e8                	mov    %ebp,%eax
  8022d3:	89 f7                	mov    %esi,%edi
  8022d5:	f7 f1                	div    %ecx
  8022d7:	89 fa                	mov    %edi,%edx
  8022d9:	83 c4 1c             	add    $0x1c,%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5f                   	pop    %edi
  8022df:	5d                   	pop    %ebp
  8022e0:	c3                   	ret    
  8022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	39 f2                	cmp    %esi,%edx
  8022ea:	77 1c                	ja     802308 <__udivdi3+0x88>
  8022ec:	0f bd fa             	bsr    %edx,%edi
  8022ef:	83 f7 1f             	xor    $0x1f,%edi
  8022f2:	75 2c                	jne    802320 <__udivdi3+0xa0>
  8022f4:	39 f2                	cmp    %esi,%edx
  8022f6:	72 06                	jb     8022fe <__udivdi3+0x7e>
  8022f8:	31 c0                	xor    %eax,%eax
  8022fa:	39 eb                	cmp    %ebp,%ebx
  8022fc:	77 a9                	ja     8022a7 <__udivdi3+0x27>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	eb a2                	jmp    8022a7 <__udivdi3+0x27>
  802305:	8d 76 00             	lea    0x0(%esi),%esi
  802308:	31 ff                	xor    %edi,%edi
  80230a:	31 c0                	xor    %eax,%eax
  80230c:	89 fa                	mov    %edi,%edx
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	89 f9                	mov    %edi,%ecx
  802322:	b8 20 00 00 00       	mov    $0x20,%eax
  802327:	29 f8                	sub    %edi,%eax
  802329:	d3 e2                	shl    %cl,%edx
  80232b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80232f:	89 c1                	mov    %eax,%ecx
  802331:	89 da                	mov    %ebx,%edx
  802333:	d3 ea                	shr    %cl,%edx
  802335:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802339:	09 d1                	or     %edx,%ecx
  80233b:	89 f2                	mov    %esi,%edx
  80233d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802341:	89 f9                	mov    %edi,%ecx
  802343:	d3 e3                	shl    %cl,%ebx
  802345:	89 c1                	mov    %eax,%ecx
  802347:	d3 ea                	shr    %cl,%edx
  802349:	89 f9                	mov    %edi,%ecx
  80234b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80234f:	89 eb                	mov    %ebp,%ebx
  802351:	d3 e6                	shl    %cl,%esi
  802353:	89 c1                	mov    %eax,%ecx
  802355:	d3 eb                	shr    %cl,%ebx
  802357:	09 de                	or     %ebx,%esi
  802359:	89 f0                	mov    %esi,%eax
  80235b:	f7 74 24 08          	divl   0x8(%esp)
  80235f:	89 d6                	mov    %edx,%esi
  802361:	89 c3                	mov    %eax,%ebx
  802363:	f7 64 24 0c          	mull   0xc(%esp)
  802367:	39 d6                	cmp    %edx,%esi
  802369:	72 15                	jb     802380 <__udivdi3+0x100>
  80236b:	89 f9                	mov    %edi,%ecx
  80236d:	d3 e5                	shl    %cl,%ebp
  80236f:	39 c5                	cmp    %eax,%ebp
  802371:	73 04                	jae    802377 <__udivdi3+0xf7>
  802373:	39 d6                	cmp    %edx,%esi
  802375:	74 09                	je     802380 <__udivdi3+0x100>
  802377:	89 d8                	mov    %ebx,%eax
  802379:	31 ff                	xor    %edi,%edi
  80237b:	e9 27 ff ff ff       	jmp    8022a7 <__udivdi3+0x27>
  802380:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802383:	31 ff                	xor    %edi,%edi
  802385:	e9 1d ff ff ff       	jmp    8022a7 <__udivdi3+0x27>
  80238a:	66 90                	xchg   %ax,%ax
  80238c:	66 90                	xchg   %ax,%ax
  80238e:	66 90                	xchg   %ax,%ax

00802390 <__umoddi3>:
  802390:	55                   	push   %ebp
  802391:	57                   	push   %edi
  802392:	56                   	push   %esi
  802393:	53                   	push   %ebx
  802394:	83 ec 1c             	sub    $0x1c,%esp
  802397:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80239b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80239f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023a7:	89 da                	mov    %ebx,%edx
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	75 43                	jne    8023f0 <__umoddi3+0x60>
  8023ad:	39 df                	cmp    %ebx,%edi
  8023af:	76 17                	jbe    8023c8 <__umoddi3+0x38>
  8023b1:	89 f0                	mov    %esi,%eax
  8023b3:	f7 f7                	div    %edi
  8023b5:	89 d0                	mov    %edx,%eax
  8023b7:	31 d2                	xor    %edx,%edx
  8023b9:	83 c4 1c             	add    $0x1c,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5f                   	pop    %edi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	89 fd                	mov    %edi,%ebp
  8023ca:	85 ff                	test   %edi,%edi
  8023cc:	75 0b                	jne    8023d9 <__umoddi3+0x49>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	31 d2                	xor    %edx,%edx
  8023d5:	f7 f7                	div    %edi
  8023d7:	89 c5                	mov    %eax,%ebp
  8023d9:	89 d8                	mov    %ebx,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	f7 f5                	div    %ebp
  8023df:	89 f0                	mov    %esi,%eax
  8023e1:	f7 f5                	div    %ebp
  8023e3:	89 d0                	mov    %edx,%eax
  8023e5:	eb d0                	jmp    8023b7 <__umoddi3+0x27>
  8023e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ee:	66 90                	xchg   %ax,%ax
  8023f0:	89 f1                	mov    %esi,%ecx
  8023f2:	39 d8                	cmp    %ebx,%eax
  8023f4:	76 0a                	jbe    802400 <__umoddi3+0x70>
  8023f6:	89 f0                	mov    %esi,%eax
  8023f8:	83 c4 1c             	add    $0x1c,%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5e                   	pop    %esi
  8023fd:	5f                   	pop    %edi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    
  802400:	0f bd e8             	bsr    %eax,%ebp
  802403:	83 f5 1f             	xor    $0x1f,%ebp
  802406:	75 20                	jne    802428 <__umoddi3+0x98>
  802408:	39 d8                	cmp    %ebx,%eax
  80240a:	0f 82 b0 00 00 00    	jb     8024c0 <__umoddi3+0x130>
  802410:	39 f7                	cmp    %esi,%edi
  802412:	0f 86 a8 00 00 00    	jbe    8024c0 <__umoddi3+0x130>
  802418:	89 c8                	mov    %ecx,%eax
  80241a:	83 c4 1c             	add    $0x1c,%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5f                   	pop    %edi
  802420:	5d                   	pop    %ebp
  802421:	c3                   	ret    
  802422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802428:	89 e9                	mov    %ebp,%ecx
  80242a:	ba 20 00 00 00       	mov    $0x20,%edx
  80242f:	29 ea                	sub    %ebp,%edx
  802431:	d3 e0                	shl    %cl,%eax
  802433:	89 44 24 08          	mov    %eax,0x8(%esp)
  802437:	89 d1                	mov    %edx,%ecx
  802439:	89 f8                	mov    %edi,%eax
  80243b:	d3 e8                	shr    %cl,%eax
  80243d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802441:	89 54 24 04          	mov    %edx,0x4(%esp)
  802445:	8b 54 24 04          	mov    0x4(%esp),%edx
  802449:	09 c1                	or     %eax,%ecx
  80244b:	89 d8                	mov    %ebx,%eax
  80244d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802451:	89 e9                	mov    %ebp,%ecx
  802453:	d3 e7                	shl    %cl,%edi
  802455:	89 d1                	mov    %edx,%ecx
  802457:	d3 e8                	shr    %cl,%eax
  802459:	89 e9                	mov    %ebp,%ecx
  80245b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80245f:	d3 e3                	shl    %cl,%ebx
  802461:	89 c7                	mov    %eax,%edi
  802463:	89 d1                	mov    %edx,%ecx
  802465:	89 f0                	mov    %esi,%eax
  802467:	d3 e8                	shr    %cl,%eax
  802469:	89 e9                	mov    %ebp,%ecx
  80246b:	89 fa                	mov    %edi,%edx
  80246d:	d3 e6                	shl    %cl,%esi
  80246f:	09 d8                	or     %ebx,%eax
  802471:	f7 74 24 08          	divl   0x8(%esp)
  802475:	89 d1                	mov    %edx,%ecx
  802477:	89 f3                	mov    %esi,%ebx
  802479:	f7 64 24 0c          	mull   0xc(%esp)
  80247d:	89 c6                	mov    %eax,%esi
  80247f:	89 d7                	mov    %edx,%edi
  802481:	39 d1                	cmp    %edx,%ecx
  802483:	72 06                	jb     80248b <__umoddi3+0xfb>
  802485:	75 10                	jne    802497 <__umoddi3+0x107>
  802487:	39 c3                	cmp    %eax,%ebx
  802489:	73 0c                	jae    802497 <__umoddi3+0x107>
  80248b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80248f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802493:	89 d7                	mov    %edx,%edi
  802495:	89 c6                	mov    %eax,%esi
  802497:	89 ca                	mov    %ecx,%edx
  802499:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80249e:	29 f3                	sub    %esi,%ebx
  8024a0:	19 fa                	sbb    %edi,%edx
  8024a2:	89 d0                	mov    %edx,%eax
  8024a4:	d3 e0                	shl    %cl,%eax
  8024a6:	89 e9                	mov    %ebp,%ecx
  8024a8:	d3 eb                	shr    %cl,%ebx
  8024aa:	d3 ea                	shr    %cl,%edx
  8024ac:	09 d8                	or     %ebx,%eax
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024bd:	8d 76 00             	lea    0x0(%esi),%esi
  8024c0:	89 da                	mov    %ebx,%edx
  8024c2:	29 fe                	sub    %edi,%esi
  8024c4:	19 c2                	sbb    %eax,%edx
  8024c6:	89 f1                	mov    %esi,%ecx
  8024c8:	89 c8                	mov    %ecx,%eax
  8024ca:	e9 4b ff ff ff       	jmp    80241a <__umoddi3+0x8a>
