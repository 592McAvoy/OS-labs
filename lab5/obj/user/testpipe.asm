
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a1 02 00 00       	call   8002d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 c0 	movl   $0x8025c0,0x803004
  800042:	25 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 1b 1e 00 00       	call   801e69 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 1f 12 00 00       	call   80127f <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 1e 01 00 00    	js     800188 <umain+0x155>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	0f 85 56 01 00 00    	jne    8001c6 <umain+0x193>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800070:	a1 04 40 80 00       	mov    0x804004,%eax
  800075:	8b 40 48             	mov    0x48(%eax),%eax
  800078:	83 ec 04             	sub    $0x4,%esp
  80007b:	ff 75 90             	pushl  -0x70(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 e5 25 80 00       	push   $0x8025e5
  800084:	e8 7f 03 00 00       	call   800408 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 be 15 00 00       	call   801652 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 04 40 80 00       	mov    0x804004,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 02 26 80 00       	push   $0x802602
  8000a8:	e8 5b 03 00 00       	call   800408 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 59 17 00 00       	call   801817 <readn>
  8000be:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	0f 88 cf 00 00 00    	js     80019a <umain+0x167>
			panic("read: %e", i);
		buf[i] = 0;
  8000cb:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	ff 35 00 30 80 00    	pushl  0x803000
  8000d9:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 df 0a 00 00       	call   800bc1 <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 28 26 80 00       	push   $0x802628
  8000f5:	e8 0e 03 00 00       	call   800408 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 19 02 00 00       	call   80031b <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 db 1e 00 00       	call   801fe6 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 30 80 00 7e 	movl   $0x80267e,0x803004
  800112:	26 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 49 1d 00 00       	call   801e69 <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 4d 11 00 00       	call   80127f <fork>
  800132:	89 c3                	mov    %eax,%ebx
  800134:	85 c0                	test   %eax,%eax
  800136:	0f 88 35 01 00 00    	js     800271 <umain+0x23e>
		panic("fork: %e", i);

	if (pid == 0) {
  80013c:	0f 84 41 01 00 00    	je     800283 <umain+0x250>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 8c             	pushl  -0x74(%ebp)
  800148:	e8 05 15 00 00       	call   801652 <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 fa 14 00 00       	call   801652 <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 86 1e 00 00       	call   801fe6 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 ac 26 80 00 	movl   $0x8026ac,(%esp)
  800167:	e8 9c 02 00 00       	call   800408 <cprintf>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("pipe: %e", i);
  800176:	50                   	push   %eax
  800177:	68 cc 25 80 00       	push   $0x8025cc
  80017c:	6a 0e                	push   $0xe
  80017e:	68 d5 25 80 00       	push   $0x8025d5
  800183:	e8 a5 01 00 00       	call   80032d <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 c0 2b 80 00       	push   $0x802bc0
  80018e:	6a 11                	push   $0x11
  800190:	68 d5 25 80 00       	push   $0x8025d5
  800195:	e8 93 01 00 00       	call   80032d <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 1f 26 80 00       	push   $0x80261f
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 d5 25 80 00       	push   $0x8025d5
  8001a7:	e8 81 01 00 00       	call   80032d <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 44 26 80 00       	push   $0x802644
  8001b9:	e8 4a 02 00 00       	call   800408 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 e5 25 80 00       	push   $0x8025e5
  8001da:	e8 29 02 00 00       	call   800408 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 68 14 00 00       	call   801652 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 57 26 80 00       	push   $0x802657
  8001fe:	e8 05 02 00 00       	call   800408 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 30 80 00    	pushl  0x803000
  80020c:	e8 cc 08 00 00       	call   800add <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 30 80 00    	pushl  0x803000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 39 16 00 00       	call   80185c <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 30 80 00    	pushl  0x803000
  80022e:	e8 aa 08 00 00       	call   800add <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	pushl  -0x70(%ebp)
  800240:	e8 0d 14 00 00       	call   801652 <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 74 26 80 00       	push   $0x802674
  800253:	6a 25                	push   $0x25
  800255:	68 d5 25 80 00       	push   $0x8025d5
  80025a:	e8 ce 00 00 00       	call   80032d <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 cc 25 80 00       	push   $0x8025cc
  800265:	6a 2c                	push   $0x2c
  800267:	68 d5 25 80 00       	push   $0x8025d5
  80026c:	e8 bc 00 00 00       	call   80032d <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 c0 2b 80 00       	push   $0x802bc0
  800277:	6a 2f                	push   $0x2f
  800279:	68 d5 25 80 00       	push   $0x8025d5
  80027e:	e8 aa 00 00 00       	call   80032d <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 c4 13 00 00       	call   801652 <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 8b 26 80 00       	push   $0x80268b
  800299:	e8 6a 01 00 00       	call   800408 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 8d 26 80 00       	push   $0x80268d
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 ac 15 00 00       	call   80185c <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 8f 26 80 00       	push   $0x80268f
  8002c0:	e8 43 01 00 00       	call   800408 <cprintf>
		exit();
  8002c5:	e8 51 00 00 00       	call   80031b <exit>
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	e9 70 fe ff ff       	jmp    800142 <umain+0x10f>

008002d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	56                   	push   %esi
  8002d6:	53                   	push   %ebx
  8002d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002dd:	e8 e8 0b 00 00       	call   800eca <sys_getenvid>
  8002e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e7:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8002ea:	c1 e0 04             	shl    $0x4,%eax
  8002ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f7:	85 db                	test   %ebx,%ebx
  8002f9:	7e 07                	jle    800302 <libmain+0x30>
		binaryname = argv[0];
  8002fb:	8b 06                	mov    (%esi),%eax
  8002fd:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	e8 27 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030c:	e8 0a 00 00 00       	call   80031b <exit>
}
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800317:	5b                   	pop    %ebx
  800318:	5e                   	pop    %esi
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    

0080031b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800321:	6a 00                	push   $0x0
  800323:	e8 61 0b 00 00       	call   800e89 <sys_env_destroy>
}
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800332:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800335:	8b 35 04 30 80 00    	mov    0x803004,%esi
  80033b:	e8 8a 0b 00 00       	call   800eca <sys_getenvid>
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	ff 75 0c             	pushl  0xc(%ebp)
  800346:	ff 75 08             	pushl  0x8(%ebp)
  800349:	56                   	push   %esi
  80034a:	50                   	push   %eax
  80034b:	68 10 27 80 00       	push   $0x802710
  800350:	e8 b3 00 00 00       	call   800408 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800355:	83 c4 18             	add    $0x18,%esp
  800358:	53                   	push   %ebx
  800359:	ff 75 10             	pushl  0x10(%ebp)
  80035c:	e8 56 00 00 00       	call   8003b7 <vcprintf>
	cprintf("\n");
  800361:	c7 04 24 00 26 80 00 	movl   $0x802600,(%esp)
  800368:	e8 9b 00 00 00       	call   800408 <cprintf>
  80036d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800370:	cc                   	int3   
  800371:	eb fd                	jmp    800370 <_panic+0x43>

00800373 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	53                   	push   %ebx
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80037d:	8b 13                	mov    (%ebx),%edx
  80037f:	8d 42 01             	lea    0x1(%edx),%eax
  800382:	89 03                	mov    %eax,(%ebx)
  800384:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800387:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80038b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800390:	74 09                	je     80039b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800392:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800396:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800399:	c9                   	leave  
  80039a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	68 ff 00 00 00       	push   $0xff
  8003a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a6:	50                   	push   %eax
  8003a7:	e8 a0 0a 00 00       	call   800e4c <sys_cputs>
		b->idx = 0;
  8003ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	eb db                	jmp    800392 <putch+0x1f>

008003b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c7:	00 00 00 
	b.cnt = 0;
  8003ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d4:	ff 75 0c             	pushl  0xc(%ebp)
  8003d7:	ff 75 08             	pushl  0x8(%ebp)
  8003da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e0:	50                   	push   %eax
  8003e1:	68 73 03 80 00       	push   $0x800373
  8003e6:	e8 4a 01 00 00       	call   800535 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003eb:	83 c4 08             	add    $0x8,%esp
  8003ee:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003f4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003fa:	50                   	push   %eax
  8003fb:	e8 4c 0a 00 00       	call   800e4c <sys_cputs>

	return b.cnt;
}
  800400:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80040e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800411:	50                   	push   %eax
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 9d ff ff ff       	call   8003b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	57                   	push   %edi
  800420:	56                   	push   %esi
  800421:	53                   	push   %ebx
  800422:	83 ec 1c             	sub    $0x1c,%esp
  800425:	89 c6                	mov    %eax,%esi
  800427:	89 d7                	mov    %edx,%edi
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800432:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800435:	8b 45 10             	mov    0x10(%ebp),%eax
  800438:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80043b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80043f:	74 2c                	je     80046d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800441:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800444:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80044b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800451:	39 c2                	cmp    %eax,%edx
  800453:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800456:	73 43                	jae    80049b <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800458:	83 eb 01             	sub    $0x1,%ebx
  80045b:	85 db                	test   %ebx,%ebx
  80045d:	7e 6c                	jle    8004cb <printnum+0xaf>
			putch(padc, putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	57                   	push   %edi
  800463:	ff 75 18             	pushl  0x18(%ebp)
  800466:	ff d6                	call   *%esi
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb eb                	jmp    800458 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  80046d:	83 ec 0c             	sub    $0xc,%esp
  800470:	6a 20                	push   $0x20
  800472:	6a 00                	push   $0x0
  800474:	50                   	push   %eax
  800475:	ff 75 e4             	pushl  -0x1c(%ebp)
  800478:	ff 75 e0             	pushl  -0x20(%ebp)
  80047b:	89 fa                	mov    %edi,%edx
  80047d:	89 f0                	mov    %esi,%eax
  80047f:	e8 98 ff ff ff       	call   80041c <printnum>
		while (--width > 0)
  800484:	83 c4 20             	add    $0x20,%esp
  800487:	83 eb 01             	sub    $0x1,%ebx
  80048a:	85 db                	test   %ebx,%ebx
  80048c:	7e 65                	jle    8004f3 <printnum+0xd7>
			putch(padc, putdat);
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	57                   	push   %edi
  800492:	6a 20                	push   $0x20
  800494:	ff d6                	call   *%esi
  800496:	83 c4 10             	add    $0x10,%esp
  800499:	eb ec                	jmp    800487 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 18             	pushl  0x18(%ebp)
  8004a1:	83 eb 01             	sub    $0x1,%ebx
  8004a4:	53                   	push   %ebx
  8004a5:	50                   	push   %eax
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8004ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8004af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b5:	e8 b6 1e 00 00       	call   802370 <__udivdi3>
  8004ba:	83 c4 18             	add    $0x18,%esp
  8004bd:	52                   	push   %edx
  8004be:	50                   	push   %eax
  8004bf:	89 fa                	mov    %edi,%edx
  8004c1:	89 f0                	mov    %esi,%eax
  8004c3:	e8 54 ff ff ff       	call   80041c <printnum>
  8004c8:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	57                   	push   %edi
  8004cf:	83 ec 04             	sub    $0x4,%esp
  8004d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004db:	ff 75 e0             	pushl  -0x20(%ebp)
  8004de:	e8 9d 1f 00 00       	call   802480 <__umoddi3>
  8004e3:	83 c4 14             	add    $0x14,%esp
  8004e6:	0f be 80 33 27 80 00 	movsbl 0x802733(%eax),%eax
  8004ed:	50                   	push   %eax
  8004ee:	ff d6                	call   *%esi
  8004f0:	83 c4 10             	add    $0x10,%esp
}
  8004f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f6:	5b                   	pop    %ebx
  8004f7:	5e                   	pop    %esi
  8004f8:	5f                   	pop    %edi
  8004f9:	5d                   	pop    %ebp
  8004fa:	c3                   	ret    

008004fb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800501:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800505:	8b 10                	mov    (%eax),%edx
  800507:	3b 50 04             	cmp    0x4(%eax),%edx
  80050a:	73 0a                	jae    800516 <sprintputch+0x1b>
		*b->buf++ = ch;
  80050c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80050f:	89 08                	mov    %ecx,(%eax)
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	88 02                	mov    %al,(%edx)
}
  800516:	5d                   	pop    %ebp
  800517:	c3                   	ret    

00800518 <printfmt>:
{
  800518:	55                   	push   %ebp
  800519:	89 e5                	mov    %esp,%ebp
  80051b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80051e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800521:	50                   	push   %eax
  800522:	ff 75 10             	pushl  0x10(%ebp)
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	e8 05 00 00 00       	call   800535 <vprintfmt>
}
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	c9                   	leave  
  800534:	c3                   	ret    

00800535 <vprintfmt>:
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	57                   	push   %edi
  800539:	56                   	push   %esi
  80053a:	53                   	push   %ebx
  80053b:	83 ec 3c             	sub    $0x3c,%esp
  80053e:	8b 75 08             	mov    0x8(%ebp),%esi
  800541:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800544:	8b 7d 10             	mov    0x10(%ebp),%edi
  800547:	e9 b4 03 00 00       	jmp    800900 <vprintfmt+0x3cb>
		padc = ' ';
  80054c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800550:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800557:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80055e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800565:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80056c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800571:	8d 47 01             	lea    0x1(%edi),%eax
  800574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800577:	0f b6 17             	movzbl (%edi),%edx
  80057a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80057d:	3c 55                	cmp    $0x55,%al
  80057f:	0f 87 c8 04 00 00    	ja     800a4d <vprintfmt+0x518>
  800585:	0f b6 c0             	movzbl %al,%eax
  800588:	ff 24 85 20 29 80 00 	jmp    *0x802920(,%eax,4)
  80058f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800592:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800599:	eb d6                	jmp    800571 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80059e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005a2:	eb cd                	jmp    800571 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8005a4:	0f b6 d2             	movzbl %dl,%edx
  8005a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8005af:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8005b2:	eb 0c                	jmp    8005c0 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8005b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005b7:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8005bb:	eb b4                	jmp    800571 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8005bd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005c3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005c7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005ca:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005cd:	83 f9 09             	cmp    $0x9,%ecx
  8005d0:	76 eb                	jbe    8005bd <vprintfmt+0x88>
  8005d2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d8:	eb 14                	jmp    8005ee <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f2:	0f 89 79 ff ff ff    	jns    800571 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800605:	e9 67 ff ff ff       	jmp    800571 <vprintfmt+0x3c>
  80060a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060d:	85 c0                	test   %eax,%eax
  80060f:	ba 00 00 00 00       	mov    $0x0,%edx
  800614:	0f 49 d0             	cmovns %eax,%edx
  800617:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80061a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80061d:	e9 4f ff ff ff       	jmp    800571 <vprintfmt+0x3c>
  800622:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800625:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80062c:	e9 40 ff ff ff       	jmp    800571 <vprintfmt+0x3c>
			lflag++;
  800631:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800634:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800637:	e9 35 ff ff ff       	jmp    800571 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8d 78 04             	lea    0x4(%eax),%edi
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	ff 30                	pushl  (%eax)
  800648:	ff d6                	call   *%esi
			break;
  80064a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80064d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800650:	e9 a8 02 00 00       	jmp    8008fd <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8d 78 04             	lea    0x4(%eax),%edi
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	99                   	cltd   
  80065e:	31 d0                	xor    %edx,%eax
  800660:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800662:	83 f8 0f             	cmp    $0xf,%eax
  800665:	7f 23                	jg     80068a <vprintfmt+0x155>
  800667:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  80066e:	85 d2                	test   %edx,%edx
  800670:	74 18                	je     80068a <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800672:	52                   	push   %edx
  800673:	68 a1 2c 80 00       	push   $0x802ca1
  800678:	53                   	push   %ebx
  800679:	56                   	push   %esi
  80067a:	e8 99 fe ff ff       	call   800518 <printfmt>
  80067f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800682:	89 7d 14             	mov    %edi,0x14(%ebp)
  800685:	e9 73 02 00 00       	jmp    8008fd <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80068a:	50                   	push   %eax
  80068b:	68 4b 27 80 00       	push   $0x80274b
  800690:	53                   	push   %ebx
  800691:	56                   	push   %esi
  800692:	e8 81 fe ff ff       	call   800518 <printfmt>
  800697:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80069a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80069d:	e9 5b 02 00 00       	jmp    8008fd <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	83 c0 04             	add    $0x4,%eax
  8006a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006b0:	85 d2                	test   %edx,%edx
  8006b2:	b8 44 27 80 00       	mov    $0x802744,%eax
  8006b7:	0f 45 c2             	cmovne %edx,%eax
  8006ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c1:	7e 06                	jle    8006c9 <vprintfmt+0x194>
  8006c3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006c7:	75 0d                	jne    8006d6 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006cc:	89 c7                	mov    %eax,%edi
  8006ce:	03 45 e0             	add    -0x20(%ebp),%eax
  8006d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d4:	eb 53                	jmp    800729 <vprintfmt+0x1f4>
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8006dc:	50                   	push   %eax
  8006dd:	e8 13 04 00 00       	call   800af5 <strnlen>
  8006e2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e5:	29 c1                	sub    %eax,%ecx
  8006e7:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006ef:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f6:	eb 0f                	jmp    800707 <vprintfmt+0x1d2>
					putch(padc, putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ff:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800701:	83 ef 01             	sub    $0x1,%edi
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	85 ff                	test   %edi,%edi
  800709:	7f ed                	jg     8006f8 <vprintfmt+0x1c3>
  80070b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80070e:	85 d2                	test   %edx,%edx
  800710:	b8 00 00 00 00       	mov    $0x0,%eax
  800715:	0f 49 c2             	cmovns %edx,%eax
  800718:	29 c2                	sub    %eax,%edx
  80071a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80071d:	eb aa                	jmp    8006c9 <vprintfmt+0x194>
					putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	53                   	push   %ebx
  800723:	52                   	push   %edx
  800724:	ff d6                	call   *%esi
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80072c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072e:	83 c7 01             	add    $0x1,%edi
  800731:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800735:	0f be d0             	movsbl %al,%edx
  800738:	85 d2                	test   %edx,%edx
  80073a:	74 4b                	je     800787 <vprintfmt+0x252>
  80073c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800740:	78 06                	js     800748 <vprintfmt+0x213>
  800742:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800746:	78 1e                	js     800766 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800748:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80074c:	74 d1                	je     80071f <vprintfmt+0x1ea>
  80074e:	0f be c0             	movsbl %al,%eax
  800751:	83 e8 20             	sub    $0x20,%eax
  800754:	83 f8 5e             	cmp    $0x5e,%eax
  800757:	76 c6                	jbe    80071f <vprintfmt+0x1ea>
					putch('?', putdat);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	53                   	push   %ebx
  80075d:	6a 3f                	push   $0x3f
  80075f:	ff d6                	call   *%esi
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	eb c3                	jmp    800729 <vprintfmt+0x1f4>
  800766:	89 cf                	mov    %ecx,%edi
  800768:	eb 0e                	jmp    800778 <vprintfmt+0x243>
				putch(' ', putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	6a 20                	push   $0x20
  800770:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800772:	83 ef 01             	sub    $0x1,%edi
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	85 ff                	test   %edi,%edi
  80077a:	7f ee                	jg     80076a <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  80077c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
  800782:	e9 76 01 00 00       	jmp    8008fd <vprintfmt+0x3c8>
  800787:	89 cf                	mov    %ecx,%edi
  800789:	eb ed                	jmp    800778 <vprintfmt+0x243>
	if (lflag >= 2)
  80078b:	83 f9 01             	cmp    $0x1,%ecx
  80078e:	7f 1f                	jg     8007af <vprintfmt+0x27a>
	else if (lflag)
  800790:	85 c9                	test   %ecx,%ecx
  800792:	74 6a                	je     8007fe <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079c:	89 c1                	mov    %eax,%ecx
  80079e:	c1 f9 1f             	sar    $0x1f,%ecx
  8007a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ad:	eb 17                	jmp    8007c6 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 50 04             	mov    0x4(%eax),%edx
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8d 40 08             	lea    0x8(%eax),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8007c9:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8007ce:	85 d2                	test   %edx,%edx
  8007d0:	0f 89 f8 00 00 00    	jns    8008ce <vprintfmt+0x399>
				putch('-', putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	53                   	push   %ebx
  8007da:	6a 2d                	push   $0x2d
  8007dc:	ff d6                	call   *%esi
				num = -(long long) num;
  8007de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
  8007eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007f4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007f9:	e9 e1 00 00 00       	jmp    8008df <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800806:	99                   	cltd   
  800807:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8d 40 04             	lea    0x4(%eax),%eax
  800810:	89 45 14             	mov    %eax,0x14(%ebp)
  800813:	eb b1                	jmp    8007c6 <vprintfmt+0x291>
	if (lflag >= 2)
  800815:	83 f9 01             	cmp    $0x1,%ecx
  800818:	7f 27                	jg     800841 <vprintfmt+0x30c>
	else if (lflag)
  80081a:	85 c9                	test   %ecx,%ecx
  80081c:	74 41                	je     80085f <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
  800828:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8d 40 04             	lea    0x4(%eax),%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800837:	bf 0a 00 00 00       	mov    $0xa,%edi
  80083c:	e9 8d 00 00 00       	jmp    8008ce <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8b 50 04             	mov    0x4(%eax),%edx
  800847:	8b 00                	mov    (%eax),%eax
  800849:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8d 40 08             	lea    0x8(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800858:	bf 0a 00 00 00       	mov    $0xa,%edi
  80085d:	eb 6f                	jmp    8008ce <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	ba 00 00 00 00       	mov    $0x0,%edx
  800869:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8d 40 04             	lea    0x4(%eax),%eax
  800875:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800878:	bf 0a 00 00 00       	mov    $0xa,%edi
  80087d:	eb 4f                	jmp    8008ce <vprintfmt+0x399>
	if (lflag >= 2)
  80087f:	83 f9 01             	cmp    $0x1,%ecx
  800882:	7f 23                	jg     8008a7 <vprintfmt+0x372>
	else if (lflag)
  800884:	85 c9                	test   %ecx,%ecx
  800886:	0f 84 98 00 00 00    	je     800924 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	ba 00 00 00 00       	mov    $0x0,%edx
  800896:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800899:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8d 40 04             	lea    0x4(%eax),%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	eb 17                	jmp    8008be <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8b 50 04             	mov    0x4(%eax),%edx
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 40 08             	lea    0x8(%eax),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	53                   	push   %ebx
  8008c2:	6a 30                	push   $0x30
  8008c4:	ff d6                	call   *%esi
			goto number;
  8008c6:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8008c9:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8008ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008d2:	74 0b                	je     8008df <vprintfmt+0x3aa>
				putch('+', putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	53                   	push   %ebx
  8008d8:	6a 2b                	push   $0x2b
  8008da:	ff d6                	call   *%esi
  8008dc:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8008df:	83 ec 0c             	sub    $0xc,%esp
  8008e2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008e6:	50                   	push   %eax
  8008e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ea:	57                   	push   %edi
  8008eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8008ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8008f1:	89 da                	mov    %ebx,%edx
  8008f3:	89 f0                	mov    %esi,%eax
  8008f5:	e8 22 fb ff ff       	call   80041c <printnum>
			break;
  8008fa:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800900:	83 c7 01             	add    $0x1,%edi
  800903:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800907:	83 f8 25             	cmp    $0x25,%eax
  80090a:	0f 84 3c fc ff ff    	je     80054c <vprintfmt+0x17>
			if (ch == '\0')
  800910:	85 c0                	test   %eax,%eax
  800912:	0f 84 55 01 00 00    	je     800a6d <vprintfmt+0x538>
			putch(ch, putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	53                   	push   %ebx
  80091c:	50                   	push   %eax
  80091d:	ff d6                	call   *%esi
  80091f:	83 c4 10             	add    $0x10,%esp
  800922:	eb dc                	jmp    800900 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	ba 00 00 00 00       	mov    $0x0,%edx
  80092e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800931:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8d 40 04             	lea    0x4(%eax),%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
  80093d:	e9 7c ff ff ff       	jmp    8008be <vprintfmt+0x389>
			putch('0', putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	53                   	push   %ebx
  800946:	6a 30                	push   $0x30
  800948:	ff d6                	call   *%esi
			putch('x', putdat);
  80094a:	83 c4 08             	add    $0x8,%esp
  80094d:	53                   	push   %ebx
  80094e:	6a 78                	push   $0x78
  800950:	ff d6                	call   *%esi
			num = (unsigned long long)
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	ba 00 00 00 00       	mov    $0x0,%edx
  80095c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800962:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	8d 40 04             	lea    0x4(%eax),%eax
  80096b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80096e:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800973:	e9 56 ff ff ff       	jmp    8008ce <vprintfmt+0x399>
	if (lflag >= 2)
  800978:	83 f9 01             	cmp    $0x1,%ecx
  80097b:	7f 27                	jg     8009a4 <vprintfmt+0x46f>
	else if (lflag)
  80097d:	85 c9                	test   %ecx,%ecx
  80097f:	74 44                	je     8009c5 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	ba 00 00 00 00       	mov    $0x0,%edx
  80098b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8d 40 04             	lea    0x4(%eax),%eax
  800997:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80099a:	bf 10 00 00 00       	mov    $0x10,%edi
  80099f:	e9 2a ff ff ff       	jmp    8008ce <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	8b 50 04             	mov    0x4(%eax),%edx
  8009aa:	8b 00                	mov    (%eax),%eax
  8009ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b5:	8d 40 08             	lea    0x8(%eax),%eax
  8009b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009bb:	bf 10 00 00 00       	mov    $0x10,%edi
  8009c0:	e9 09 ff ff ff       	jmp    8008ce <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	8d 40 04             	lea    0x4(%eax),%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009de:	bf 10 00 00 00       	mov    $0x10,%edi
  8009e3:	e9 e6 fe ff ff       	jmp    8008ce <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	8d 78 04             	lea    0x4(%eax),%edi
  8009ee:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8009f0:	85 c0                	test   %eax,%eax
  8009f2:	74 2d                	je     800a21 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8009f4:	0f b6 13             	movzbl (%ebx),%edx
  8009f7:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009f9:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8009fc:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8009ff:	0f 8e f8 fe ff ff    	jle    8008fd <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800a05:	68 a0 28 80 00       	push   $0x8028a0
  800a0a:	68 a1 2c 80 00       	push   $0x802ca1
  800a0f:	53                   	push   %ebx
  800a10:	56                   	push   %esi
  800a11:	e8 02 fb ff ff       	call   800518 <printfmt>
  800a16:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a19:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a1c:	e9 dc fe ff ff       	jmp    8008fd <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800a21:	68 68 28 80 00       	push   $0x802868
  800a26:	68 a1 2c 80 00       	push   $0x802ca1
  800a2b:	53                   	push   %ebx
  800a2c:	56                   	push   %esi
  800a2d:	e8 e6 fa ff ff       	call   800518 <printfmt>
  800a32:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a35:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a38:	e9 c0 fe ff ff       	jmp    8008fd <vprintfmt+0x3c8>
			putch(ch, putdat);
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	53                   	push   %ebx
  800a41:	6a 25                	push   $0x25
  800a43:	ff d6                	call   *%esi
			break;
  800a45:	83 c4 10             	add    $0x10,%esp
  800a48:	e9 b0 fe ff ff       	jmp    8008fd <vprintfmt+0x3c8>
			putch('%', putdat);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	53                   	push   %ebx
  800a51:	6a 25                	push   $0x25
  800a53:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	89 f8                	mov    %edi,%eax
  800a5a:	eb 03                	jmp    800a5f <vprintfmt+0x52a>
  800a5c:	83 e8 01             	sub    $0x1,%eax
  800a5f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a63:	75 f7                	jne    800a5c <vprintfmt+0x527>
  800a65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a68:	e9 90 fe ff ff       	jmp    8008fd <vprintfmt+0x3c8>
}
  800a6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a70:	5b                   	pop    %ebx
  800a71:	5e                   	pop    %esi
  800a72:	5f                   	pop    %edi
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 18             	sub    $0x18,%esp
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a84:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a88:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a92:	85 c0                	test   %eax,%eax
  800a94:	74 26                	je     800abc <vsnprintf+0x47>
  800a96:	85 d2                	test   %edx,%edx
  800a98:	7e 22                	jle    800abc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a9a:	ff 75 14             	pushl  0x14(%ebp)
  800a9d:	ff 75 10             	pushl  0x10(%ebp)
  800aa0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	68 fb 04 80 00       	push   $0x8004fb
  800aa9:	e8 87 fa ff ff       	call   800535 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab7:	83 c4 10             	add    $0x10,%esp
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    
		return -E_INVAL;
  800abc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ac1:	eb f7                	jmp    800aba <vsnprintf+0x45>

00800ac3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800acc:	50                   	push   %eax
  800acd:	ff 75 10             	pushl  0x10(%ebp)
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	ff 75 08             	pushl  0x8(%ebp)
  800ad6:	e8 9a ff ff ff       	call   800a75 <vsnprintf>
	va_end(ap);

	return rc;
}
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aec:	74 05                	je     800af3 <strlen+0x16>
		n++;
  800aee:	83 c0 01             	add    $0x1,%eax
  800af1:	eb f5                	jmp    800ae8 <strlen+0xb>
	return n;
}
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800afe:	ba 00 00 00 00       	mov    $0x0,%edx
  800b03:	39 c2                	cmp    %eax,%edx
  800b05:	74 0d                	je     800b14 <strnlen+0x1f>
  800b07:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b0b:	74 05                	je     800b12 <strnlen+0x1d>
		n++;
  800b0d:	83 c2 01             	add    $0x1,%edx
  800b10:	eb f1                	jmp    800b03 <strnlen+0xe>
  800b12:	89 d0                	mov    %edx,%eax
	return n;
}
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	53                   	push   %ebx
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b20:	ba 00 00 00 00       	mov    $0x0,%edx
  800b25:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b29:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b2c:	83 c2 01             	add    $0x1,%edx
  800b2f:	84 c9                	test   %cl,%cl
  800b31:	75 f2                	jne    800b25 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b33:	5b                   	pop    %ebx
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	53                   	push   %ebx
  800b3a:	83 ec 10             	sub    $0x10,%esp
  800b3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b40:	53                   	push   %ebx
  800b41:	e8 97 ff ff ff       	call   800add <strlen>
  800b46:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	01 d8                	add    %ebx,%eax
  800b4e:	50                   	push   %eax
  800b4f:	e8 c2 ff ff ff       	call   800b16 <strcpy>
	return dst;
}
  800b54:	89 d8                	mov    %ebx,%eax
  800b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b66:	89 c6                	mov    %eax,%esi
  800b68:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b6b:	89 c2                	mov    %eax,%edx
  800b6d:	39 f2                	cmp    %esi,%edx
  800b6f:	74 11                	je     800b82 <strncpy+0x27>
		*dst++ = *src;
  800b71:	83 c2 01             	add    $0x1,%edx
  800b74:	0f b6 19             	movzbl (%ecx),%ebx
  800b77:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b7a:	80 fb 01             	cmp    $0x1,%bl
  800b7d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b80:	eb eb                	jmp    800b6d <strncpy+0x12>
	}
	return ret;
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	56                   	push   %esi
  800b8a:	53                   	push   %ebx
  800b8b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b91:	8b 55 10             	mov    0x10(%ebp),%edx
  800b94:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b96:	85 d2                	test   %edx,%edx
  800b98:	74 21                	je     800bbb <strlcpy+0x35>
  800b9a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b9e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ba0:	39 c2                	cmp    %eax,%edx
  800ba2:	74 14                	je     800bb8 <strlcpy+0x32>
  800ba4:	0f b6 19             	movzbl (%ecx),%ebx
  800ba7:	84 db                	test   %bl,%bl
  800ba9:	74 0b                	je     800bb6 <strlcpy+0x30>
			*dst++ = *src++;
  800bab:	83 c1 01             	add    $0x1,%ecx
  800bae:	83 c2 01             	add    $0x1,%edx
  800bb1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bb4:	eb ea                	jmp    800ba0 <strlcpy+0x1a>
  800bb6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bb8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bbb:	29 f0                	sub    %esi,%eax
}
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bca:	0f b6 01             	movzbl (%ecx),%eax
  800bcd:	84 c0                	test   %al,%al
  800bcf:	74 0c                	je     800bdd <strcmp+0x1c>
  800bd1:	3a 02                	cmp    (%edx),%al
  800bd3:	75 08                	jne    800bdd <strcmp+0x1c>
		p++, q++;
  800bd5:	83 c1 01             	add    $0x1,%ecx
  800bd8:	83 c2 01             	add    $0x1,%edx
  800bdb:	eb ed                	jmp    800bca <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bdd:	0f b6 c0             	movzbl %al,%eax
  800be0:	0f b6 12             	movzbl (%edx),%edx
  800be3:	29 d0                	sub    %edx,%eax
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	53                   	push   %ebx
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf1:	89 c3                	mov    %eax,%ebx
  800bf3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bf6:	eb 06                	jmp    800bfe <strncmp+0x17>
		n--, p++, q++;
  800bf8:	83 c0 01             	add    $0x1,%eax
  800bfb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bfe:	39 d8                	cmp    %ebx,%eax
  800c00:	74 16                	je     800c18 <strncmp+0x31>
  800c02:	0f b6 08             	movzbl (%eax),%ecx
  800c05:	84 c9                	test   %cl,%cl
  800c07:	74 04                	je     800c0d <strncmp+0x26>
  800c09:	3a 0a                	cmp    (%edx),%cl
  800c0b:	74 eb                	je     800bf8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0d:	0f b6 00             	movzbl (%eax),%eax
  800c10:	0f b6 12             	movzbl (%edx),%edx
  800c13:	29 d0                	sub    %edx,%eax
}
  800c15:	5b                   	pop    %ebx
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    
		return 0;
  800c18:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1d:	eb f6                	jmp    800c15 <strncmp+0x2e>

00800c1f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c29:	0f b6 10             	movzbl (%eax),%edx
  800c2c:	84 d2                	test   %dl,%dl
  800c2e:	74 09                	je     800c39 <strchr+0x1a>
		if (*s == c)
  800c30:	38 ca                	cmp    %cl,%dl
  800c32:	74 0a                	je     800c3e <strchr+0x1f>
	for (; *s; s++)
  800c34:	83 c0 01             	add    $0x1,%eax
  800c37:	eb f0                	jmp    800c29 <strchr+0xa>
			return (char *) s;
	return 0;
  800c39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c4a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c4d:	38 ca                	cmp    %cl,%dl
  800c4f:	74 09                	je     800c5a <strfind+0x1a>
  800c51:	84 d2                	test   %dl,%dl
  800c53:	74 05                	je     800c5a <strfind+0x1a>
	for (; *s; s++)
  800c55:	83 c0 01             	add    $0x1,%eax
  800c58:	eb f0                	jmp    800c4a <strfind+0xa>
			break;
	return (char *) s;
}
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c65:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c68:	85 c9                	test   %ecx,%ecx
  800c6a:	74 31                	je     800c9d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c6c:	89 f8                	mov    %edi,%eax
  800c6e:	09 c8                	or     %ecx,%eax
  800c70:	a8 03                	test   $0x3,%al
  800c72:	75 23                	jne    800c97 <memset+0x3b>
		c &= 0xFF;
  800c74:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c78:	89 d3                	mov    %edx,%ebx
  800c7a:	c1 e3 08             	shl    $0x8,%ebx
  800c7d:	89 d0                	mov    %edx,%eax
  800c7f:	c1 e0 18             	shl    $0x18,%eax
  800c82:	89 d6                	mov    %edx,%esi
  800c84:	c1 e6 10             	shl    $0x10,%esi
  800c87:	09 f0                	or     %esi,%eax
  800c89:	09 c2                	or     %eax,%edx
  800c8b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c8d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c90:	89 d0                	mov    %edx,%eax
  800c92:	fc                   	cld    
  800c93:	f3 ab                	rep stos %eax,%es:(%edi)
  800c95:	eb 06                	jmp    800c9d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	fc                   	cld    
  800c9b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c9d:	89 f8                	mov    %edi,%eax
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 75 0c             	mov    0xc(%ebp),%esi
  800caf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cb2:	39 c6                	cmp    %eax,%esi
  800cb4:	73 32                	jae    800ce8 <memmove+0x44>
  800cb6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cb9:	39 c2                	cmp    %eax,%edx
  800cbb:	76 2b                	jbe    800ce8 <memmove+0x44>
		s += n;
		d += n;
  800cbd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc0:	89 fe                	mov    %edi,%esi
  800cc2:	09 ce                	or     %ecx,%esi
  800cc4:	09 d6                	or     %edx,%esi
  800cc6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ccc:	75 0e                	jne    800cdc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cce:	83 ef 04             	sub    $0x4,%edi
  800cd1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cd4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cd7:	fd                   	std    
  800cd8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cda:	eb 09                	jmp    800ce5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cdc:	83 ef 01             	sub    $0x1,%edi
  800cdf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ce2:	fd                   	std    
  800ce3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ce5:	fc                   	cld    
  800ce6:	eb 1a                	jmp    800d02 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ce8:	89 c2                	mov    %eax,%edx
  800cea:	09 ca                	or     %ecx,%edx
  800cec:	09 f2                	or     %esi,%edx
  800cee:	f6 c2 03             	test   $0x3,%dl
  800cf1:	75 0a                	jne    800cfd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cf3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cf6:	89 c7                	mov    %eax,%edi
  800cf8:	fc                   	cld    
  800cf9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cfb:	eb 05                	jmp    800d02 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cfd:	89 c7                	mov    %eax,%edi
  800cff:	fc                   	cld    
  800d00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d0c:	ff 75 10             	pushl  0x10(%ebp)
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	ff 75 08             	pushl  0x8(%ebp)
  800d15:	e8 8a ff ff ff       	call   800ca4 <memmove>
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d27:	89 c6                	mov    %eax,%esi
  800d29:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d2c:	39 f0                	cmp    %esi,%eax
  800d2e:	74 1c                	je     800d4c <memcmp+0x30>
		if (*s1 != *s2)
  800d30:	0f b6 08             	movzbl (%eax),%ecx
  800d33:	0f b6 1a             	movzbl (%edx),%ebx
  800d36:	38 d9                	cmp    %bl,%cl
  800d38:	75 08                	jne    800d42 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d3a:	83 c0 01             	add    $0x1,%eax
  800d3d:	83 c2 01             	add    $0x1,%edx
  800d40:	eb ea                	jmp    800d2c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d42:	0f b6 c1             	movzbl %cl,%eax
  800d45:	0f b6 db             	movzbl %bl,%ebx
  800d48:	29 d8                	sub    %ebx,%eax
  800d4a:	eb 05                	jmp    800d51 <memcmp+0x35>
	}

	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d5e:	89 c2                	mov    %eax,%edx
  800d60:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d63:	39 d0                	cmp    %edx,%eax
  800d65:	73 09                	jae    800d70 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d67:	38 08                	cmp    %cl,(%eax)
  800d69:	74 05                	je     800d70 <memfind+0x1b>
	for (; s < ends; s++)
  800d6b:	83 c0 01             	add    $0x1,%eax
  800d6e:	eb f3                	jmp    800d63 <memfind+0xe>
			break;
	return (void *) s;
}
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    

00800d72 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7e:	eb 03                	jmp    800d83 <strtol+0x11>
		s++;
  800d80:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d83:	0f b6 01             	movzbl (%ecx),%eax
  800d86:	3c 20                	cmp    $0x20,%al
  800d88:	74 f6                	je     800d80 <strtol+0xe>
  800d8a:	3c 09                	cmp    $0x9,%al
  800d8c:	74 f2                	je     800d80 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d8e:	3c 2b                	cmp    $0x2b,%al
  800d90:	74 2a                	je     800dbc <strtol+0x4a>
	int neg = 0;
  800d92:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d97:	3c 2d                	cmp    $0x2d,%al
  800d99:	74 2b                	je     800dc6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800da1:	75 0f                	jne    800db2 <strtol+0x40>
  800da3:	80 39 30             	cmpb   $0x30,(%ecx)
  800da6:	74 28                	je     800dd0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800da8:	85 db                	test   %ebx,%ebx
  800daa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800daf:	0f 44 d8             	cmove  %eax,%ebx
  800db2:	b8 00 00 00 00       	mov    $0x0,%eax
  800db7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dba:	eb 50                	jmp    800e0c <strtol+0x9a>
		s++;
  800dbc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dbf:	bf 00 00 00 00       	mov    $0x0,%edi
  800dc4:	eb d5                	jmp    800d9b <strtol+0x29>
		s++, neg = 1;
  800dc6:	83 c1 01             	add    $0x1,%ecx
  800dc9:	bf 01 00 00 00       	mov    $0x1,%edi
  800dce:	eb cb                	jmp    800d9b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dd0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dd4:	74 0e                	je     800de4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dd6:	85 db                	test   %ebx,%ebx
  800dd8:	75 d8                	jne    800db2 <strtol+0x40>
		s++, base = 8;
  800dda:	83 c1 01             	add    $0x1,%ecx
  800ddd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800de2:	eb ce                	jmp    800db2 <strtol+0x40>
		s += 2, base = 16;
  800de4:	83 c1 02             	add    $0x2,%ecx
  800de7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dec:	eb c4                	jmp    800db2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dee:	8d 72 9f             	lea    -0x61(%edx),%esi
  800df1:	89 f3                	mov    %esi,%ebx
  800df3:	80 fb 19             	cmp    $0x19,%bl
  800df6:	77 29                	ja     800e21 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800df8:	0f be d2             	movsbl %dl,%edx
  800dfb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dfe:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e01:	7d 30                	jge    800e33 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e03:	83 c1 01             	add    $0x1,%ecx
  800e06:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e0a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e0c:	0f b6 11             	movzbl (%ecx),%edx
  800e0f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e12:	89 f3                	mov    %esi,%ebx
  800e14:	80 fb 09             	cmp    $0x9,%bl
  800e17:	77 d5                	ja     800dee <strtol+0x7c>
			dig = *s - '0';
  800e19:	0f be d2             	movsbl %dl,%edx
  800e1c:	83 ea 30             	sub    $0x30,%edx
  800e1f:	eb dd                	jmp    800dfe <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e21:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e24:	89 f3                	mov    %esi,%ebx
  800e26:	80 fb 19             	cmp    $0x19,%bl
  800e29:	77 08                	ja     800e33 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e2b:	0f be d2             	movsbl %dl,%edx
  800e2e:	83 ea 37             	sub    $0x37,%edx
  800e31:	eb cb                	jmp    800dfe <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e37:	74 05                	je     800e3e <strtol+0xcc>
		*endptr = (char *) s;
  800e39:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e3c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e3e:	89 c2                	mov    %eax,%edx
  800e40:	f7 da                	neg    %edx
  800e42:	85 ff                	test   %edi,%edi
  800e44:	0f 45 c2             	cmovne %edx,%eax
}
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e52:	b8 00 00 00 00       	mov    $0x0,%eax
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5d:	89 c3                	mov    %eax,%ebx
  800e5f:	89 c7                	mov    %eax,%edi
  800e61:	89 c6                	mov    %eax,%esi
  800e63:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_cgetc>:

int
sys_cgetc(void)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e70:	ba 00 00 00 00       	mov    $0x0,%edx
  800e75:	b8 01 00 00 00       	mov    $0x1,%eax
  800e7a:	89 d1                	mov    %edx,%ecx
  800e7c:	89 d3                	mov    %edx,%ebx
  800e7e:	89 d7                	mov    %edx,%edi
  800e80:	89 d6                	mov    %edx,%esi
  800e82:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    

00800e89 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
  800e8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e97:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800e9f:	89 cb                	mov    %ecx,%ebx
  800ea1:	89 cf                	mov    %ecx,%edi
  800ea3:	89 ce                	mov    %ecx,%esi
  800ea5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7f 08                	jg     800eb3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	50                   	push   %eax
  800eb7:	6a 03                	push   $0x3
  800eb9:	68 c0 2a 80 00       	push   $0x802ac0
  800ebe:	6a 33                	push   $0x33
  800ec0:	68 dd 2a 80 00       	push   $0x802add
  800ec5:	e8 63 f4 ff ff       	call   80032d <_panic>

00800eca <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed5:	b8 02 00 00 00       	mov    $0x2,%eax
  800eda:	89 d1                	mov    %edx,%ecx
  800edc:	89 d3                	mov    %edx,%ebx
  800ede:	89 d7                	mov    %edx,%edi
  800ee0:	89 d6                	mov    %edx,%esi
  800ee2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <sys_yield>:

void
sys_yield(void)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eef:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef9:	89 d1                	mov    %edx,%ecx
  800efb:	89 d3                	mov    %edx,%ebx
  800efd:	89 d7                	mov    %edx,%edi
  800eff:	89 d6                	mov    %edx,%esi
  800f01:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f11:	be 00 00 00 00       	mov    $0x0,%esi
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1c:	b8 04 00 00 00       	mov    $0x4,%eax
  800f21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f24:	89 f7                	mov    %esi,%edi
  800f26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7f 08                	jg     800f34 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	50                   	push   %eax
  800f38:	6a 04                	push   $0x4
  800f3a:	68 c0 2a 80 00       	push   $0x802ac0
  800f3f:	6a 33                	push   $0x33
  800f41:	68 dd 2a 80 00       	push   $0x802add
  800f46:	e8 e2 f3 ff ff       	call   80032d <_panic>

00800f4b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
  800f51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5a:	b8 05 00 00 00       	mov    $0x5,%eax
  800f5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f62:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f65:	8b 75 18             	mov    0x18(%ebp),%esi
  800f68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	7f 08                	jg     800f76 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f76:	83 ec 0c             	sub    $0xc,%esp
  800f79:	50                   	push   %eax
  800f7a:	6a 05                	push   $0x5
  800f7c:	68 c0 2a 80 00       	push   $0x802ac0
  800f81:	6a 33                	push   $0x33
  800f83:	68 dd 2a 80 00       	push   $0x802add
  800f88:	e8 a0 f3 ff ff       	call   80032d <_panic>

00800f8d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
  800f93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa1:	b8 06 00 00 00       	mov    $0x6,%eax
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	7f 08                	jg     800fb8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb8:	83 ec 0c             	sub    $0xc,%esp
  800fbb:	50                   	push   %eax
  800fbc:	6a 06                	push   $0x6
  800fbe:	68 c0 2a 80 00       	push   $0x802ac0
  800fc3:	6a 33                	push   $0x33
  800fc5:	68 dd 2a 80 00       	push   $0x802add
  800fca:	e8 5e f3 ff ff       	call   80032d <_panic>

00800fcf <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fe5:	89 cb                	mov    %ecx,%ebx
  800fe7:	89 cf                	mov    %ecx,%edi
  800fe9:	89 ce                	mov    %ecx,%esi
  800feb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	7f 08                	jg     800ff9 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff9:	83 ec 0c             	sub    $0xc,%esp
  800ffc:	50                   	push   %eax
  800ffd:	6a 0b                	push   $0xb
  800fff:	68 c0 2a 80 00       	push   $0x802ac0
  801004:	6a 33                	push   $0x33
  801006:	68 dd 2a 80 00       	push   $0x802add
  80100b:	e8 1d f3 ff ff       	call   80032d <_panic>

00801010 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	57                   	push   %edi
  801014:	56                   	push   %esi
  801015:	53                   	push   %ebx
  801016:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801024:	b8 08 00 00 00       	mov    $0x8,%eax
  801029:	89 df                	mov    %ebx,%edi
  80102b:	89 de                	mov    %ebx,%esi
  80102d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102f:	85 c0                	test   %eax,%eax
  801031:	7f 08                	jg     80103b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801033:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5f                   	pop    %edi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	50                   	push   %eax
  80103f:	6a 08                	push   $0x8
  801041:	68 c0 2a 80 00       	push   $0x802ac0
  801046:	6a 33                	push   $0x33
  801048:	68 dd 2a 80 00       	push   $0x802add
  80104d:	e8 db f2 ff ff       	call   80032d <_panic>

00801052 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	57                   	push   %edi
  801056:	56                   	push   %esi
  801057:	53                   	push   %ebx
  801058:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	b8 09 00 00 00       	mov    $0x9,%eax
  80106b:	89 df                	mov    %ebx,%edi
  80106d:	89 de                	mov    %ebx,%esi
  80106f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801071:	85 c0                	test   %eax,%eax
  801073:	7f 08                	jg     80107d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801075:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5f                   	pop    %edi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80107d:	83 ec 0c             	sub    $0xc,%esp
  801080:	50                   	push   %eax
  801081:	6a 09                	push   $0x9
  801083:	68 c0 2a 80 00       	push   $0x802ac0
  801088:	6a 33                	push   $0x33
  80108a:	68 dd 2a 80 00       	push   $0x802add
  80108f:	e8 99 f2 ff ff       	call   80032d <_panic>

00801094 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80109d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010ad:	89 df                	mov    %ebx,%edi
  8010af:	89 de                	mov    %ebx,%esi
  8010b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	7f 08                	jg     8010bf <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ba:	5b                   	pop    %ebx
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bf:	83 ec 0c             	sub    $0xc,%esp
  8010c2:	50                   	push   %eax
  8010c3:	6a 0a                	push   $0xa
  8010c5:	68 c0 2a 80 00       	push   $0x802ac0
  8010ca:	6a 33                	push   $0x33
  8010cc:	68 dd 2a 80 00       	push   $0x802add
  8010d1:	e8 57 f2 ff ff       	call   80032d <_panic>

008010d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	57                   	push   %edi
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e2:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010e7:	be 00 00 00 00       	mov    $0x0,%esi
  8010ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010f2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010f4:	5b                   	pop    %ebx
  8010f5:	5e                   	pop    %esi
  8010f6:	5f                   	pop    %edi
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	57                   	push   %edi
  8010fd:	56                   	push   %esi
  8010fe:	53                   	push   %ebx
  8010ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801102:	b9 00 00 00 00       	mov    $0x0,%ecx
  801107:	8b 55 08             	mov    0x8(%ebp),%edx
  80110a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80110f:	89 cb                	mov    %ecx,%ebx
  801111:	89 cf                	mov    %ecx,%edi
  801113:	89 ce                	mov    %ecx,%esi
  801115:	cd 30                	int    $0x30
	if(check && ret > 0)
  801117:	85 c0                	test   %eax,%eax
  801119:	7f 08                	jg     801123 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80111b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111e:	5b                   	pop    %ebx
  80111f:	5e                   	pop    %esi
  801120:	5f                   	pop    %edi
  801121:	5d                   	pop    %ebp
  801122:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801123:	83 ec 0c             	sub    $0xc,%esp
  801126:	50                   	push   %eax
  801127:	6a 0e                	push   $0xe
  801129:	68 c0 2a 80 00       	push   $0x802ac0
  80112e:	6a 33                	push   $0x33
  801130:	68 dd 2a 80 00       	push   $0x802add
  801135:	e8 f3 f1 ff ff       	call   80032d <_panic>

0080113a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801140:	bb 00 00 00 00       	mov    $0x0,%ebx
  801145:	8b 55 08             	mov    0x8(%ebp),%edx
  801148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801150:	89 df                	mov    %ebx,%edi
  801152:	89 de                	mov    %ebx,%esi
  801154:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	57                   	push   %edi
  80115f:	56                   	push   %esi
  801160:	53                   	push   %ebx
	asm volatile("int %1\n"
  801161:	b9 00 00 00 00       	mov    $0x0,%ecx
  801166:	8b 55 08             	mov    0x8(%ebp),%edx
  801169:	b8 10 00 00 00       	mov    $0x10,%eax
  80116e:	89 cb                	mov    %ecx,%ebx
  801170:	89 cf                	mov    %ecx,%edi
  801172:	89 ce                	mov    %ecx,%esi
  801174:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5f                   	pop    %edi
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	53                   	push   %ebx
  80117f:	83 ec 04             	sub    $0x4,%esp
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801185:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  801187:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80118b:	0f 84 90 00 00 00    	je     801221 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  801191:	89 d8                	mov    %ebx,%eax
  801193:	c1 e8 16             	shr    $0x16,%eax
  801196:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80119d:	a8 01                	test   $0x1,%al
  80119f:	0f 84 90 00 00 00    	je     801235 <pgfault+0xba>
  8011a5:	89 d8                	mov    %ebx,%eax
  8011a7:	c1 e8 0c             	shr    $0xc,%eax
  8011aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b1:	a9 01 08 00 00       	test   $0x801,%eax
  8011b6:	74 7d                	je     801235 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8011b8:	83 ec 04             	sub    $0x4,%esp
  8011bb:	6a 07                	push   $0x7
  8011bd:	68 00 f0 7f 00       	push   $0x7ff000
  8011c2:	6a 00                	push   $0x0
  8011c4:	e8 3f fd ff ff       	call   800f08 <sys_page_alloc>
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 79                	js     801249 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  8011d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  8011d6:	83 ec 04             	sub    $0x4,%esp
  8011d9:	68 00 10 00 00       	push   $0x1000
  8011de:	53                   	push   %ebx
  8011df:	68 00 f0 7f 00       	push   $0x7ff000
  8011e4:	e8 bb fa ff ff       	call   800ca4 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  8011e9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011f0:	53                   	push   %ebx
  8011f1:	6a 00                	push   $0x0
  8011f3:	68 00 f0 7f 00       	push   $0x7ff000
  8011f8:	6a 00                	push   $0x0
  8011fa:	e8 4c fd ff ff       	call   800f4b <sys_page_map>
  8011ff:	83 c4 20             	add    $0x20,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	78 55                	js     80125b <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	68 00 f0 7f 00       	push   $0x7ff000
  80120e:	6a 00                	push   $0x0
  801210:	e8 78 fd ff ff       	call   800f8d <sys_page_unmap>
  801215:	83 c4 10             	add    $0x10,%esp
  801218:	85 c0                	test   %eax,%eax
  80121a:	78 51                	js     80126d <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  80121c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121f:	c9                   	leave  
  801220:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  801221:	83 ec 04             	sub    $0x4,%esp
  801224:	68 ec 2a 80 00       	push   $0x802aec
  801229:	6a 21                	push   $0x21
  80122b:	68 74 2b 80 00       	push   $0x802b74
  801230:	e8 f8 f0 ff ff       	call   80032d <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  801235:	83 ec 04             	sub    $0x4,%esp
  801238:	68 18 2b 80 00       	push   $0x802b18
  80123d:	6a 24                	push   $0x24
  80123f:	68 74 2b 80 00       	push   $0x802b74
  801244:	e8 e4 f0 ff ff       	call   80032d <_panic>
		panic("sys_page_alloc: %e\n", r);
  801249:	50                   	push   %eax
  80124a:	68 7f 2b 80 00       	push   $0x802b7f
  80124f:	6a 2e                	push   $0x2e
  801251:	68 74 2b 80 00       	push   $0x802b74
  801256:	e8 d2 f0 ff ff       	call   80032d <_panic>
		panic("sys_page_map: %e\n", r);
  80125b:	50                   	push   %eax
  80125c:	68 93 2b 80 00       	push   $0x802b93
  801261:	6a 34                	push   $0x34
  801263:	68 74 2b 80 00       	push   $0x802b74
  801268:	e8 c0 f0 ff ff       	call   80032d <_panic>
		panic("sys_page_unmap: %e\n", r);
  80126d:	50                   	push   %eax
  80126e:	68 a5 2b 80 00       	push   $0x802ba5
  801273:	6a 37                	push   $0x37
  801275:	68 74 2b 80 00       	push   $0x802b74
  80127a:	e8 ae f0 ff ff       	call   80032d <_panic>

0080127f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	57                   	push   %edi
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
  801285:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801288:	68 7b 11 80 00       	push   $0x80117b
  80128d:	e8 1a 0f 00 00       	call   8021ac <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801292:	b8 07 00 00 00       	mov    $0x7,%eax
  801297:	cd 30                	int    $0x30
  801299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	78 30                	js     8012d3 <fork+0x54>
  8012a3:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8012a5:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8012aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012ae:	0f 85 a5 00 00 00    	jne    801359 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012b4:	e8 11 fc ff ff       	call   800eca <sys_getenvid>
  8012b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012be:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8012c1:	c1 e0 04             	shl    $0x4,%eax
  8012c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c9:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8012ce:	e9 75 01 00 00       	jmp    801448 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  8012d3:	50                   	push   %eax
  8012d4:	68 b9 2b 80 00       	push   $0x802bb9
  8012d9:	68 83 00 00 00       	push   $0x83
  8012de:	68 74 2b 80 00       	push   $0x802b74
  8012e3:	e8 45 f0 ff ff       	call   80032d <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8012e8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ef:	83 ec 0c             	sub    $0xc,%esp
  8012f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f7:	50                   	push   %eax
  8012f8:	56                   	push   %esi
  8012f9:	57                   	push   %edi
  8012fa:	56                   	push   %esi
  8012fb:	6a 00                	push   $0x0
  8012fd:	e8 49 fc ff ff       	call   800f4b <sys_page_map>
  801302:	83 c4 20             	add    $0x20,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	79 3e                	jns    801347 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801309:	50                   	push   %eax
  80130a:	68 93 2b 80 00       	push   $0x802b93
  80130f:	6a 50                	push   $0x50
  801311:	68 74 2b 80 00       	push   $0x802b74
  801316:	e8 12 f0 ff ff       	call   80032d <_panic>
			panic("sys_page_map: %e\n", r);
  80131b:	50                   	push   %eax
  80131c:	68 93 2b 80 00       	push   $0x802b93
  801321:	6a 54                	push   $0x54
  801323:	68 74 2b 80 00       	push   $0x802b74
  801328:	e8 00 f0 ff ff       	call   80032d <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  80132d:	83 ec 0c             	sub    $0xc,%esp
  801330:	6a 05                	push   $0x5
  801332:	56                   	push   %esi
  801333:	57                   	push   %edi
  801334:	56                   	push   %esi
  801335:	6a 00                	push   $0x0
  801337:	e8 0f fc ff ff       	call   800f4b <sys_page_map>
  80133c:	83 c4 20             	add    $0x20,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	0f 88 ab 00 00 00    	js     8013f2 <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801347:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80134d:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801353:	0f 84 ab 00 00 00    	je     801404 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  801359:	89 d8                	mov    %ebx,%eax
  80135b:	c1 e8 16             	shr    $0x16,%eax
  80135e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801365:	a8 01                	test   $0x1,%al
  801367:	74 de                	je     801347 <fork+0xc8>
  801369:	89 d8                	mov    %ebx,%eax
  80136b:	c1 e8 0c             	shr    $0xc,%eax
  80136e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801375:	f6 c2 01             	test   $0x1,%dl
  801378:	74 cd                	je     801347 <fork+0xc8>
  80137a:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801380:	74 c5                	je     801347 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  801382:	89 c6                	mov    %eax,%esi
  801384:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  801387:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80138e:	f6 c6 04             	test   $0x4,%dh
  801391:	0f 85 51 ff ff ff    	jne    8012e8 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  801397:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80139e:	a9 02 08 00 00       	test   $0x802,%eax
  8013a3:	74 88                	je     80132d <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	68 05 08 00 00       	push   $0x805
  8013ad:	56                   	push   %esi
  8013ae:	57                   	push   %edi
  8013af:	56                   	push   %esi
  8013b0:	6a 00                	push   $0x0
  8013b2:	e8 94 fb ff ff       	call   800f4b <sys_page_map>
  8013b7:	83 c4 20             	add    $0x20,%esp
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	0f 88 59 ff ff ff    	js     80131b <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	68 05 08 00 00       	push   $0x805
  8013ca:	56                   	push   %esi
  8013cb:	6a 00                	push   $0x0
  8013cd:	56                   	push   %esi
  8013ce:	6a 00                	push   $0x0
  8013d0:	e8 76 fb ff ff       	call   800f4b <sys_page_map>
  8013d5:	83 c4 20             	add    $0x20,%esp
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	0f 89 67 ff ff ff    	jns    801347 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8013e0:	50                   	push   %eax
  8013e1:	68 93 2b 80 00       	push   $0x802b93
  8013e6:	6a 56                	push   $0x56
  8013e8:	68 74 2b 80 00       	push   $0x802b74
  8013ed:	e8 3b ef ff ff       	call   80032d <_panic>
			panic("sys_page_map: %e\n", r);
  8013f2:	50                   	push   %eax
  8013f3:	68 93 2b 80 00       	push   $0x802b93
  8013f8:	6a 5a                	push   $0x5a
  8013fa:	68 74 2b 80 00       	push   $0x802b74
  8013ff:	e8 29 ef ff ff       	call   80032d <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801404:	83 ec 04             	sub    $0x4,%esp
  801407:	6a 07                	push   $0x7
  801409:	68 00 f0 bf ee       	push   $0xeebff000
  80140e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801411:	e8 f2 fa ff ff       	call   800f08 <sys_page_alloc>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 36                	js     801453 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	68 17 22 80 00       	push   $0x802217
  801425:	ff 75 e4             	pushl  -0x1c(%ebp)
  801428:	e8 67 fc ff ff       	call   801094 <sys_env_set_pgfault_upcall>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 34                	js     801468 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801434:	83 ec 08             	sub    $0x8,%esp
  801437:	6a 02                	push   $0x2
  801439:	ff 75 e4             	pushl  -0x1c(%ebp)
  80143c:	e8 cf fb ff ff       	call   801010 <sys_env_set_status>
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 35                	js     80147d <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  801448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  801453:	50                   	push   %eax
  801454:	68 7f 2b 80 00       	push   $0x802b7f
  801459:	68 95 00 00 00       	push   $0x95
  80145e:	68 74 2b 80 00       	push   $0x802b74
  801463:	e8 c5 ee ff ff       	call   80032d <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801468:	50                   	push   %eax
  801469:	68 54 2b 80 00       	push   $0x802b54
  80146e:	68 98 00 00 00       	push   $0x98
  801473:	68 74 2b 80 00       	push   $0x802b74
  801478:	e8 b0 ee ff ff       	call   80032d <_panic>
		panic("sys_env_set_status: %e\n", r);
  80147d:	50                   	push   %eax
  80147e:	68 c9 2b 80 00       	push   $0x802bc9
  801483:	68 9b 00 00 00       	push   $0x9b
  801488:	68 74 2b 80 00       	push   $0x802b74
  80148d:	e8 9b ee ff ff       	call   80032d <_panic>

00801492 <sfork>:

// Challenge!
int
sfork(void)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801498:	68 e1 2b 80 00       	push   $0x802be1
  80149d:	68 a4 00 00 00       	push   $0xa4
  8014a2:	68 74 2b 80 00       	push   $0x802b74
  8014a7:	e8 81 ee ff ff       	call   80032d <_panic>

008014ac <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	05 00 00 00 30       	add    $0x30000000,%eax
  8014b7:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    

008014bc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014cc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    

008014d3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014db:	89 c2                	mov    %eax,%edx
  8014dd:	c1 ea 16             	shr    $0x16,%edx
  8014e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014e7:	f6 c2 01             	test   $0x1,%dl
  8014ea:	74 2d                	je     801519 <fd_alloc+0x46>
  8014ec:	89 c2                	mov    %eax,%edx
  8014ee:	c1 ea 0c             	shr    $0xc,%edx
  8014f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014f8:	f6 c2 01             	test   $0x1,%dl
  8014fb:	74 1c                	je     801519 <fd_alloc+0x46>
  8014fd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801502:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801507:	75 d2                	jne    8014db <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801512:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801517:	eb 0a                	jmp    801523 <fd_alloc+0x50>
			*fd_store = fd;
  801519:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    

00801525 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80152b:	83 f8 1f             	cmp    $0x1f,%eax
  80152e:	77 30                	ja     801560 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801530:	c1 e0 0c             	shl    $0xc,%eax
  801533:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801538:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80153e:	f6 c2 01             	test   $0x1,%dl
  801541:	74 24                	je     801567 <fd_lookup+0x42>
  801543:	89 c2                	mov    %eax,%edx
  801545:	c1 ea 0c             	shr    $0xc,%edx
  801548:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80154f:	f6 c2 01             	test   $0x1,%dl
  801552:	74 1a                	je     80156e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801554:	8b 55 0c             	mov    0xc(%ebp),%edx
  801557:	89 02                	mov    %eax,(%edx)
	return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    
		return -E_INVAL;
  801560:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801565:	eb f7                	jmp    80155e <fd_lookup+0x39>
		return -E_INVAL;
  801567:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156c:	eb f0                	jmp    80155e <fd_lookup+0x39>
  80156e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801573:	eb e9                	jmp    80155e <fd_lookup+0x39>

00801575 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157e:	ba 78 2c 80 00       	mov    $0x802c78,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801583:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801588:	39 08                	cmp    %ecx,(%eax)
  80158a:	74 33                	je     8015bf <dev_lookup+0x4a>
  80158c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80158f:	8b 02                	mov    (%edx),%eax
  801591:	85 c0                	test   %eax,%eax
  801593:	75 f3                	jne    801588 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801595:	a1 04 40 80 00       	mov    0x804004,%eax
  80159a:	8b 40 48             	mov    0x48(%eax),%eax
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	51                   	push   %ecx
  8015a1:	50                   	push   %eax
  8015a2:	68 f8 2b 80 00       	push   $0x802bf8
  8015a7:	e8 5c ee ff ff       	call   800408 <cprintf>
	*dev = 0;
  8015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    
			*dev = devtab[i];
  8015bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c9:	eb f2                	jmp    8015bd <dev_lookup+0x48>

008015cb <fd_close>:
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	57                   	push   %edi
  8015cf:	56                   	push   %esi
  8015d0:	53                   	push   %ebx
  8015d1:	83 ec 24             	sub    $0x24,%esp
  8015d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8015d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015dd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015de:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015e4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e7:	50                   	push   %eax
  8015e8:	e8 38 ff ff ff       	call   801525 <fd_lookup>
  8015ed:	89 c3                	mov    %eax,%ebx
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	78 05                	js     8015fb <fd_close+0x30>
	    || fd != fd2)
  8015f6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015f9:	74 16                	je     801611 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015fb:	89 f8                	mov    %edi,%eax
  8015fd:	84 c0                	test   %al,%al
  8015ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801604:	0f 44 d8             	cmove  %eax,%ebx
}
  801607:	89 d8                	mov    %ebx,%eax
  801609:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80160c:	5b                   	pop    %ebx
  80160d:	5e                   	pop    %esi
  80160e:	5f                   	pop    %edi
  80160f:	5d                   	pop    %ebp
  801610:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801611:	83 ec 08             	sub    $0x8,%esp
  801614:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801617:	50                   	push   %eax
  801618:	ff 36                	pushl  (%esi)
  80161a:	e8 56 ff ff ff       	call   801575 <dev_lookup>
  80161f:	89 c3                	mov    %eax,%ebx
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	85 c0                	test   %eax,%eax
  801626:	78 1a                	js     801642 <fd_close+0x77>
		if (dev->dev_close)
  801628:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80162e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801633:	85 c0                	test   %eax,%eax
  801635:	74 0b                	je     801642 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	56                   	push   %esi
  80163b:	ff d0                	call   *%eax
  80163d:	89 c3                	mov    %eax,%ebx
  80163f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801642:	83 ec 08             	sub    $0x8,%esp
  801645:	56                   	push   %esi
  801646:	6a 00                	push   $0x0
  801648:	e8 40 f9 ff ff       	call   800f8d <sys_page_unmap>
	return r;
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	eb b5                	jmp    801607 <fd_close+0x3c>

00801652 <close>:

int
close(int fdnum)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801658:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165b:	50                   	push   %eax
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	e8 c1 fe ff ff       	call   801525 <fd_lookup>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	85 c0                	test   %eax,%eax
  801669:	79 02                	jns    80166d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    
		return fd_close(fd, 1);
  80166d:	83 ec 08             	sub    $0x8,%esp
  801670:	6a 01                	push   $0x1
  801672:	ff 75 f4             	pushl  -0xc(%ebp)
  801675:	e8 51 ff ff ff       	call   8015cb <fd_close>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	eb ec                	jmp    80166b <close+0x19>

0080167f <close_all>:

void
close_all(void)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	53                   	push   %ebx
  801683:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801686:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80168b:	83 ec 0c             	sub    $0xc,%esp
  80168e:	53                   	push   %ebx
  80168f:	e8 be ff ff ff       	call   801652 <close>
	for (i = 0; i < MAXFD; i++)
  801694:	83 c3 01             	add    $0x1,%ebx
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	83 fb 20             	cmp    $0x20,%ebx
  80169d:	75 ec                	jne    80168b <close_all+0xc>
}
  80169f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	57                   	push   %edi
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
  8016aa:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016b0:	50                   	push   %eax
  8016b1:	ff 75 08             	pushl  0x8(%ebp)
  8016b4:	e8 6c fe ff ff       	call   801525 <fd_lookup>
  8016b9:	89 c3                	mov    %eax,%ebx
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	0f 88 81 00 00 00    	js     801747 <dup+0xa3>
		return r;
	close(newfdnum);
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	e8 81 ff ff ff       	call   801652 <close>

	newfd = INDEX2FD(newfdnum);
  8016d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016d4:	c1 e6 0c             	shl    $0xc,%esi
  8016d7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016dd:	83 c4 04             	add    $0x4,%esp
  8016e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016e3:	e8 d4 fd ff ff       	call   8014bc <fd2data>
  8016e8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016ea:	89 34 24             	mov    %esi,(%esp)
  8016ed:	e8 ca fd ff ff       	call   8014bc <fd2data>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016f7:	89 d8                	mov    %ebx,%eax
  8016f9:	c1 e8 16             	shr    $0x16,%eax
  8016fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801703:	a8 01                	test   $0x1,%al
  801705:	74 11                	je     801718 <dup+0x74>
  801707:	89 d8                	mov    %ebx,%eax
  801709:	c1 e8 0c             	shr    $0xc,%eax
  80170c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801713:	f6 c2 01             	test   $0x1,%dl
  801716:	75 39                	jne    801751 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801718:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80171b:	89 d0                	mov    %edx,%eax
  80171d:	c1 e8 0c             	shr    $0xc,%eax
  801720:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801727:	83 ec 0c             	sub    $0xc,%esp
  80172a:	25 07 0e 00 00       	and    $0xe07,%eax
  80172f:	50                   	push   %eax
  801730:	56                   	push   %esi
  801731:	6a 00                	push   $0x0
  801733:	52                   	push   %edx
  801734:	6a 00                	push   $0x0
  801736:	e8 10 f8 ff ff       	call   800f4b <sys_page_map>
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	83 c4 20             	add    $0x20,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 31                	js     801775 <dup+0xd1>
		goto err;

	return newfdnum;
  801744:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801747:	89 d8                	mov    %ebx,%eax
  801749:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	5f                   	pop    %edi
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801751:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	25 07 0e 00 00       	and    $0xe07,%eax
  801760:	50                   	push   %eax
  801761:	57                   	push   %edi
  801762:	6a 00                	push   $0x0
  801764:	53                   	push   %ebx
  801765:	6a 00                	push   $0x0
  801767:	e8 df f7 ff ff       	call   800f4b <sys_page_map>
  80176c:	89 c3                	mov    %eax,%ebx
  80176e:	83 c4 20             	add    $0x20,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	79 a3                	jns    801718 <dup+0x74>
	sys_page_unmap(0, newfd);
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	56                   	push   %esi
  801779:	6a 00                	push   $0x0
  80177b:	e8 0d f8 ff ff       	call   800f8d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801780:	83 c4 08             	add    $0x8,%esp
  801783:	57                   	push   %edi
  801784:	6a 00                	push   $0x0
  801786:	e8 02 f8 ff ff       	call   800f8d <sys_page_unmap>
	return r;
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	eb b7                	jmp    801747 <dup+0xa3>

00801790 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	53                   	push   %ebx
  801794:	83 ec 1c             	sub    $0x1c,%esp
  801797:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179d:	50                   	push   %eax
  80179e:	53                   	push   %ebx
  80179f:	e8 81 fd ff ff       	call   801525 <fd_lookup>
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 3f                	js     8017ea <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b1:	50                   	push   %eax
  8017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b5:	ff 30                	pushl  (%eax)
  8017b7:	e8 b9 fd ff ff       	call   801575 <dev_lookup>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	78 27                	js     8017ea <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c6:	8b 42 08             	mov    0x8(%edx),%eax
  8017c9:	83 e0 03             	and    $0x3,%eax
  8017cc:	83 f8 01             	cmp    $0x1,%eax
  8017cf:	74 1e                	je     8017ef <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d4:	8b 40 08             	mov    0x8(%eax),%eax
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	74 35                	je     801810 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	ff 75 10             	pushl  0x10(%ebp)
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	52                   	push   %edx
  8017e5:	ff d0                	call   *%eax
  8017e7:	83 c4 10             	add    $0x10,%esp
}
  8017ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ef:	a1 04 40 80 00       	mov    0x804004,%eax
  8017f4:	8b 40 48             	mov    0x48(%eax),%eax
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	53                   	push   %ebx
  8017fb:	50                   	push   %eax
  8017fc:	68 3c 2c 80 00       	push   $0x802c3c
  801801:	e8 02 ec ff ff       	call   800408 <cprintf>
		return -E_INVAL;
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180e:	eb da                	jmp    8017ea <read+0x5a>
		return -E_NOT_SUPP;
  801810:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801815:	eb d3                	jmp    8017ea <read+0x5a>

00801817 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	57                   	push   %edi
  80181b:	56                   	push   %esi
  80181c:	53                   	push   %ebx
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	8b 7d 08             	mov    0x8(%ebp),%edi
  801823:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801826:	bb 00 00 00 00       	mov    $0x0,%ebx
  80182b:	39 f3                	cmp    %esi,%ebx
  80182d:	73 23                	jae    801852 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	89 f0                	mov    %esi,%eax
  801834:	29 d8                	sub    %ebx,%eax
  801836:	50                   	push   %eax
  801837:	89 d8                	mov    %ebx,%eax
  801839:	03 45 0c             	add    0xc(%ebp),%eax
  80183c:	50                   	push   %eax
  80183d:	57                   	push   %edi
  80183e:	e8 4d ff ff ff       	call   801790 <read>
		if (m < 0)
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	85 c0                	test   %eax,%eax
  801848:	78 06                	js     801850 <readn+0x39>
			return m;
		if (m == 0)
  80184a:	74 06                	je     801852 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80184c:	01 c3                	add    %eax,%ebx
  80184e:	eb db                	jmp    80182b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801850:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801852:	89 d8                	mov    %ebx,%eax
  801854:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5f                   	pop    %edi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	53                   	push   %ebx
  801860:	83 ec 1c             	sub    $0x1c,%esp
  801863:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801866:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801869:	50                   	push   %eax
  80186a:	53                   	push   %ebx
  80186b:	e8 b5 fc ff ff       	call   801525 <fd_lookup>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	85 c0                	test   %eax,%eax
  801875:	78 3a                	js     8018b1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801877:	83 ec 08             	sub    $0x8,%esp
  80187a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187d:	50                   	push   %eax
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801881:	ff 30                	pushl  (%eax)
  801883:	e8 ed fc ff ff       	call   801575 <dev_lookup>
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	85 c0                	test   %eax,%eax
  80188d:	78 22                	js     8018b1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801892:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801896:	74 1e                	je     8018b6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189b:	8b 52 0c             	mov    0xc(%edx),%edx
  80189e:	85 d2                	test   %edx,%edx
  8018a0:	74 35                	je     8018d7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	ff 75 10             	pushl  0x10(%ebp)
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	50                   	push   %eax
  8018ac:	ff d2                	call   *%edx
  8018ae:	83 c4 10             	add    $0x10,%esp
}
  8018b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b6:	a1 04 40 80 00       	mov    0x804004,%eax
  8018bb:	8b 40 48             	mov    0x48(%eax),%eax
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	53                   	push   %ebx
  8018c2:	50                   	push   %eax
  8018c3:	68 58 2c 80 00       	push   $0x802c58
  8018c8:	e8 3b eb ff ff       	call   800408 <cprintf>
		return -E_INVAL;
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d5:	eb da                	jmp    8018b1 <write+0x55>
		return -E_NOT_SUPP;
  8018d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018dc:	eb d3                	jmp    8018b1 <write+0x55>

008018de <seek>:

int
seek(int fdnum, off_t offset)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e7:	50                   	push   %eax
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	e8 35 fc ff ff       	call   801525 <fd_lookup>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 0e                	js     801905 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	53                   	push   %ebx
  80190b:	83 ec 1c             	sub    $0x1c,%esp
  80190e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801911:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801914:	50                   	push   %eax
  801915:	53                   	push   %ebx
  801916:	e8 0a fc ff ff       	call   801525 <fd_lookup>
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 37                	js     801959 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801922:	83 ec 08             	sub    $0x8,%esp
  801925:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801928:	50                   	push   %eax
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	ff 30                	pushl  (%eax)
  80192e:	e8 42 fc ff ff       	call   801575 <dev_lookup>
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	85 c0                	test   %eax,%eax
  801938:	78 1f                	js     801959 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801941:	74 1b                	je     80195e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801943:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801946:	8b 52 18             	mov    0x18(%edx),%edx
  801949:	85 d2                	test   %edx,%edx
  80194b:	74 32                	je     80197f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80194d:	83 ec 08             	sub    $0x8,%esp
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	50                   	push   %eax
  801954:	ff d2                	call   *%edx
  801956:	83 c4 10             	add    $0x10,%esp
}
  801959:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80195e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801963:	8b 40 48             	mov    0x48(%eax),%eax
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	53                   	push   %ebx
  80196a:	50                   	push   %eax
  80196b:	68 18 2c 80 00       	push   $0x802c18
  801970:	e8 93 ea ff ff       	call   800408 <cprintf>
		return -E_INVAL;
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80197d:	eb da                	jmp    801959 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80197f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801984:	eb d3                	jmp    801959 <ftruncate+0x52>

00801986 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	53                   	push   %ebx
  80198a:	83 ec 1c             	sub    $0x1c,%esp
  80198d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801990:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801993:	50                   	push   %eax
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	e8 89 fb ff ff       	call   801525 <fd_lookup>
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	78 4b                	js     8019ee <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ad:	ff 30                	pushl  (%eax)
  8019af:	e8 c1 fb ff ff       	call   801575 <dev_lookup>
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 33                	js     8019ee <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019be:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019c2:	74 2f                	je     8019f3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019c4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019c7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019ce:	00 00 00 
	stat->st_isdir = 0;
  8019d1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019d8:	00 00 00 
	stat->st_dev = dev;
  8019db:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	53                   	push   %ebx
  8019e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e8:	ff 50 14             	call   *0x14(%eax)
  8019eb:	83 c4 10             	add    $0x10,%esp
}
  8019ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    
		return -E_NOT_SUPP;
  8019f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f8:	eb f4                	jmp    8019ee <fstat+0x68>

008019fa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	56                   	push   %esi
  8019fe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	6a 00                	push   $0x0
  801a04:	ff 75 08             	pushl  0x8(%ebp)
  801a07:	e8 e7 01 00 00       	call   801bf3 <open>
  801a0c:	89 c3                	mov    %eax,%ebx
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	85 c0                	test   %eax,%eax
  801a13:	78 1b                	js     801a30 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a15:	83 ec 08             	sub    $0x8,%esp
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	50                   	push   %eax
  801a1c:	e8 65 ff ff ff       	call   801986 <fstat>
  801a21:	89 c6                	mov    %eax,%esi
	close(fd);
  801a23:	89 1c 24             	mov    %ebx,(%esp)
  801a26:	e8 27 fc ff ff       	call   801652 <close>
	return r;
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	89 f3                	mov    %esi,%ebx
}
  801a30:	89 d8                	mov    %ebx,%eax
  801a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a35:	5b                   	pop    %ebx
  801a36:	5e                   	pop    %esi
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    

00801a39 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	56                   	push   %esi
  801a3d:	53                   	push   %ebx
  801a3e:	89 c6                	mov    %eax,%esi
  801a40:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a42:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a49:	74 27                	je     801a72 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a4b:	6a 07                	push   $0x7
  801a4d:	68 00 50 80 00       	push   $0x805000
  801a52:	56                   	push   %esi
  801a53:	ff 35 00 40 80 00    	pushl  0x804000
  801a59:	e8 46 08 00 00       	call   8022a4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a5e:	83 c4 0c             	add    $0xc,%esp
  801a61:	6a 00                	push   $0x0
  801a63:	53                   	push   %ebx
  801a64:	6a 00                	push   $0x0
  801a66:	e8 d2 07 00 00       	call   80223d <ipc_recv>
}
  801a6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5e                   	pop    %esi
  801a70:	5d                   	pop    %ebp
  801a71:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a72:	83 ec 0c             	sub    $0xc,%esp
  801a75:	6a 01                	push   $0x1
  801a77:	e8 71 08 00 00       	call   8022ed <ipc_find_env>
  801a7c:	a3 00 40 80 00       	mov    %eax,0x804000
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	eb c5                	jmp    801a4b <fsipc+0x12>

00801a86 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a92:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa9:	e8 8b ff ff ff       	call   801a39 <fsipc>
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <devfile_flush>:
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  801abc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac6:	b8 06 00 00 00       	mov    $0x6,%eax
  801acb:	e8 69 ff ff ff       	call   801a39 <fsipc>
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <devfile_stat>:
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	53                   	push   %ebx
  801ad6:	83 ec 04             	sub    $0x4,%esp
  801ad9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aec:	b8 05 00 00 00       	mov    $0x5,%eax
  801af1:	e8 43 ff ff ff       	call   801a39 <fsipc>
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 2c                	js     801b26 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	68 00 50 80 00       	push   $0x805000
  801b02:	53                   	push   %ebx
  801b03:	e8 0e f0 ff ff       	call   800b16 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b08:	a1 80 50 80 00       	mov    0x805080,%eax
  801b0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b13:	a1 84 50 80 00       	mov    0x805084,%eax
  801b18:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <devfile_write>:
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 0c             	sub    $0xc,%esp
  801b31:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b34:	8b 55 08             	mov    0x8(%ebp),%edx
  801b37:	8b 52 0c             	mov    0xc(%edx),%edx
  801b3a:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801b40:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b45:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b4a:	0f 47 c2             	cmova  %edx,%eax
  801b4d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801b52:	50                   	push   %eax
  801b53:	ff 75 0c             	pushl  0xc(%ebp)
  801b56:	68 08 50 80 00       	push   $0x805008
  801b5b:	e8 44 f1 ff ff       	call   800ca4 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
  801b65:	b8 04 00 00 00       	mov    $0x4,%eax
  801b6a:	e8 ca fe ff ff       	call   801a39 <fsipc>
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <devfile_read>:
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
  801b76:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b84:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b94:	e8 a0 fe ff ff       	call   801a39 <fsipc>
  801b99:	89 c3                	mov    %eax,%ebx
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	78 1f                	js     801bbe <devfile_read+0x4d>
	assert(r <= n);
  801b9f:	39 f0                	cmp    %esi,%eax
  801ba1:	77 24                	ja     801bc7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ba3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ba8:	7f 33                	jg     801bdd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	50                   	push   %eax
  801bae:	68 00 50 80 00       	push   $0x805000
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 e9 f0 ff ff       	call   800ca4 <memmove>
	return r;
  801bbb:	83 c4 10             	add    $0x10,%esp
}
  801bbe:	89 d8                	mov    %ebx,%eax
  801bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    
	assert(r <= n);
  801bc7:	68 88 2c 80 00       	push   $0x802c88
  801bcc:	68 8f 2c 80 00       	push   $0x802c8f
  801bd1:	6a 7c                	push   $0x7c
  801bd3:	68 a4 2c 80 00       	push   $0x802ca4
  801bd8:	e8 50 e7 ff ff       	call   80032d <_panic>
	assert(r <= PGSIZE);
  801bdd:	68 af 2c 80 00       	push   $0x802caf
  801be2:	68 8f 2c 80 00       	push   $0x802c8f
  801be7:	6a 7d                	push   $0x7d
  801be9:	68 a4 2c 80 00       	push   $0x802ca4
  801bee:	e8 3a e7 ff ff       	call   80032d <_panic>

00801bf3 <open>:
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 1c             	sub    $0x1c,%esp
  801bfb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bfe:	56                   	push   %esi
  801bff:	e8 d9 ee ff ff       	call   800add <strlen>
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c0c:	7f 6c                	jg     801c7a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c14:	50                   	push   %eax
  801c15:	e8 b9 f8 ff ff       	call   8014d3 <fd_alloc>
  801c1a:	89 c3                	mov    %eax,%ebx
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 3c                	js     801c5f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	56                   	push   %esi
  801c27:	68 00 50 80 00       	push   $0x805000
  801c2c:	e8 e5 ee ff ff       	call   800b16 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c34:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c41:	e8 f3 fd ff ff       	call   801a39 <fsipc>
  801c46:	89 c3                	mov    %eax,%ebx
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 19                	js     801c68 <open+0x75>
	return fd2num(fd);
  801c4f:	83 ec 0c             	sub    $0xc,%esp
  801c52:	ff 75 f4             	pushl  -0xc(%ebp)
  801c55:	e8 52 f8 ff ff       	call   8014ac <fd2num>
  801c5a:	89 c3                	mov    %eax,%ebx
  801c5c:	83 c4 10             	add    $0x10,%esp
}
  801c5f:	89 d8                	mov    %ebx,%eax
  801c61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    
		fd_close(fd, 0);
  801c68:	83 ec 08             	sub    $0x8,%esp
  801c6b:	6a 00                	push   $0x0
  801c6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c70:	e8 56 f9 ff ff       	call   8015cb <fd_close>
		return r;
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	eb e5                	jmp    801c5f <open+0x6c>
		return -E_BAD_PATH;
  801c7a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c7f:	eb de                	jmp    801c5f <open+0x6c>

00801c81 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c87:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8c:	b8 08 00 00 00       	mov    $0x8,%eax
  801c91:	e8 a3 fd ff ff       	call   801a39 <fsipc>
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	ff 75 08             	pushl  0x8(%ebp)
  801ca6:	e8 11 f8 ff ff       	call   8014bc <fd2data>
  801cab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cad:	83 c4 08             	add    $0x8,%esp
  801cb0:	68 bb 2c 80 00       	push   $0x802cbb
  801cb5:	53                   	push   %ebx
  801cb6:	e8 5b ee ff ff       	call   800b16 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cbb:	8b 46 04             	mov    0x4(%esi),%eax
  801cbe:	2b 06                	sub    (%esi),%eax
  801cc0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cc6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ccd:	00 00 00 
	stat->st_dev = &devpipe;
  801cd0:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801cd7:	30 80 00 
	return 0;
}
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce2:	5b                   	pop    %ebx
  801ce3:	5e                   	pop    %esi
  801ce4:	5d                   	pop    %ebp
  801ce5:	c3                   	ret    

00801ce6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	53                   	push   %ebx
  801cea:	83 ec 0c             	sub    $0xc,%esp
  801ced:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cf0:	53                   	push   %ebx
  801cf1:	6a 00                	push   $0x0
  801cf3:	e8 95 f2 ff ff       	call   800f8d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cf8:	89 1c 24             	mov    %ebx,(%esp)
  801cfb:	e8 bc f7 ff ff       	call   8014bc <fd2data>
  801d00:	83 c4 08             	add    $0x8,%esp
  801d03:	50                   	push   %eax
  801d04:	6a 00                	push   $0x0
  801d06:	e8 82 f2 ff ff       	call   800f8d <sys_page_unmap>
}
  801d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <_pipeisclosed>:
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	57                   	push   %edi
  801d14:	56                   	push   %esi
  801d15:	53                   	push   %ebx
  801d16:	83 ec 1c             	sub    $0x1c,%esp
  801d19:	89 c7                	mov    %eax,%edi
  801d1b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d1d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d22:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d25:	83 ec 0c             	sub    $0xc,%esp
  801d28:	57                   	push   %edi
  801d29:	e8 fe 05 00 00       	call   80232c <pageref>
  801d2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d31:	89 34 24             	mov    %esi,(%esp)
  801d34:	e8 f3 05 00 00       	call   80232c <pageref>
		nn = thisenv->env_runs;
  801d39:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d3f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	39 cb                	cmp    %ecx,%ebx
  801d47:	74 1b                	je     801d64 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d49:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d4c:	75 cf                	jne    801d1d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d4e:	8b 42 58             	mov    0x58(%edx),%eax
  801d51:	6a 01                	push   $0x1
  801d53:	50                   	push   %eax
  801d54:	53                   	push   %ebx
  801d55:	68 c2 2c 80 00       	push   $0x802cc2
  801d5a:	e8 a9 e6 ff ff       	call   800408 <cprintf>
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	eb b9                	jmp    801d1d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d64:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d67:	0f 94 c0             	sete   %al
  801d6a:	0f b6 c0             	movzbl %al,%eax
}
  801d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5f                   	pop    %edi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    

00801d75 <devpipe_write>:
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	57                   	push   %edi
  801d79:	56                   	push   %esi
  801d7a:	53                   	push   %ebx
  801d7b:	83 ec 28             	sub    $0x28,%esp
  801d7e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d81:	56                   	push   %esi
  801d82:	e8 35 f7 ff ff       	call   8014bc <fd2data>
  801d87:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d91:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d94:	74 4f                	je     801de5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d96:	8b 43 04             	mov    0x4(%ebx),%eax
  801d99:	8b 0b                	mov    (%ebx),%ecx
  801d9b:	8d 51 20             	lea    0x20(%ecx),%edx
  801d9e:	39 d0                	cmp    %edx,%eax
  801da0:	72 14                	jb     801db6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801da2:	89 da                	mov    %ebx,%edx
  801da4:	89 f0                	mov    %esi,%eax
  801da6:	e8 65 ff ff ff       	call   801d10 <_pipeisclosed>
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 3b                	jne    801dea <devpipe_write+0x75>
			sys_yield();
  801daf:	e8 35 f1 ff ff       	call   800ee9 <sys_yield>
  801db4:	eb e0                	jmp    801d96 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dbd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dc0:	89 c2                	mov    %eax,%edx
  801dc2:	c1 fa 1f             	sar    $0x1f,%edx
  801dc5:	89 d1                	mov    %edx,%ecx
  801dc7:	c1 e9 1b             	shr    $0x1b,%ecx
  801dca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dcd:	83 e2 1f             	and    $0x1f,%edx
  801dd0:	29 ca                	sub    %ecx,%edx
  801dd2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dd6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dda:	83 c0 01             	add    $0x1,%eax
  801ddd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801de0:	83 c7 01             	add    $0x1,%edi
  801de3:	eb ac                	jmp    801d91 <devpipe_write+0x1c>
	return i;
  801de5:	8b 45 10             	mov    0x10(%ebp),%eax
  801de8:	eb 05                	jmp    801def <devpipe_write+0x7a>
				return 0;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df2:	5b                   	pop    %ebx
  801df3:	5e                   	pop    %esi
  801df4:	5f                   	pop    %edi
  801df5:	5d                   	pop    %ebp
  801df6:	c3                   	ret    

00801df7 <devpipe_read>:
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	57                   	push   %edi
  801dfb:	56                   	push   %esi
  801dfc:	53                   	push   %ebx
  801dfd:	83 ec 18             	sub    $0x18,%esp
  801e00:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e03:	57                   	push   %edi
  801e04:	e8 b3 f6 ff ff       	call   8014bc <fd2data>
  801e09:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	be 00 00 00 00       	mov    $0x0,%esi
  801e13:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e16:	75 14                	jne    801e2c <devpipe_read+0x35>
	return i;
  801e18:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1b:	eb 02                	jmp    801e1f <devpipe_read+0x28>
				return i;
  801e1d:	89 f0                	mov    %esi,%eax
}
  801e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e22:	5b                   	pop    %ebx
  801e23:	5e                   	pop    %esi
  801e24:	5f                   	pop    %edi
  801e25:	5d                   	pop    %ebp
  801e26:	c3                   	ret    
			sys_yield();
  801e27:	e8 bd f0 ff ff       	call   800ee9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e2c:	8b 03                	mov    (%ebx),%eax
  801e2e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e31:	75 18                	jne    801e4b <devpipe_read+0x54>
			if (i > 0)
  801e33:	85 f6                	test   %esi,%esi
  801e35:	75 e6                	jne    801e1d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e37:	89 da                	mov    %ebx,%edx
  801e39:	89 f8                	mov    %edi,%eax
  801e3b:	e8 d0 fe ff ff       	call   801d10 <_pipeisclosed>
  801e40:	85 c0                	test   %eax,%eax
  801e42:	74 e3                	je     801e27 <devpipe_read+0x30>
				return 0;
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	eb d4                	jmp    801e1f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e4b:	99                   	cltd   
  801e4c:	c1 ea 1b             	shr    $0x1b,%edx
  801e4f:	01 d0                	add    %edx,%eax
  801e51:	83 e0 1f             	and    $0x1f,%eax
  801e54:	29 d0                	sub    %edx,%eax
  801e56:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e5e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e61:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e64:	83 c6 01             	add    $0x1,%esi
  801e67:	eb aa                	jmp    801e13 <devpipe_read+0x1c>

00801e69 <pipe>:
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	56                   	push   %esi
  801e6d:	53                   	push   %ebx
  801e6e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e74:	50                   	push   %eax
  801e75:	e8 59 f6 ff ff       	call   8014d3 <fd_alloc>
  801e7a:	89 c3                	mov    %eax,%ebx
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	0f 88 23 01 00 00    	js     801faa <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	68 07 04 00 00       	push   $0x407
  801e8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e92:	6a 00                	push   $0x0
  801e94:	e8 6f f0 ff ff       	call   800f08 <sys_page_alloc>
  801e99:	89 c3                	mov    %eax,%ebx
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	0f 88 04 01 00 00    	js     801faa <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eac:	50                   	push   %eax
  801ead:	e8 21 f6 ff ff       	call   8014d3 <fd_alloc>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	0f 88 db 00 00 00    	js     801f9a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	68 07 04 00 00       	push   $0x407
  801ec7:	ff 75 f0             	pushl  -0x10(%ebp)
  801eca:	6a 00                	push   $0x0
  801ecc:	e8 37 f0 ff ff       	call   800f08 <sys_page_alloc>
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	0f 88 bc 00 00 00    	js     801f9a <pipe+0x131>
	va = fd2data(fd0);
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee4:	e8 d3 f5 ff ff       	call   8014bc <fd2data>
  801ee9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eeb:	83 c4 0c             	add    $0xc,%esp
  801eee:	68 07 04 00 00       	push   $0x407
  801ef3:	50                   	push   %eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	e8 0d f0 ff ff       	call   800f08 <sys_page_alloc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	0f 88 82 00 00 00    	js     801f8a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0e:	e8 a9 f5 ff ff       	call   8014bc <fd2data>
  801f13:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f1a:	50                   	push   %eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	56                   	push   %esi
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 26 f0 ff ff       	call   800f4b <sys_page_map>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	83 c4 20             	add    $0x20,%esp
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 4e                	js     801f7c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f2e:	a1 24 30 80 00       	mov    0x803024,%eax
  801f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f36:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f45:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	ff 75 f4             	pushl  -0xc(%ebp)
  801f57:	e8 50 f5 ff ff       	call   8014ac <fd2num>
  801f5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f61:	83 c4 04             	add    $0x4,%esp
  801f64:	ff 75 f0             	pushl  -0x10(%ebp)
  801f67:	e8 40 f5 ff ff       	call   8014ac <fd2num>
  801f6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f72:	83 c4 10             	add    $0x10,%esp
  801f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f7a:	eb 2e                	jmp    801faa <pipe+0x141>
	sys_page_unmap(0, va);
  801f7c:	83 ec 08             	sub    $0x8,%esp
  801f7f:	56                   	push   %esi
  801f80:	6a 00                	push   $0x0
  801f82:	e8 06 f0 ff ff       	call   800f8d <sys_page_unmap>
  801f87:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f8a:	83 ec 08             	sub    $0x8,%esp
  801f8d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f90:	6a 00                	push   $0x0
  801f92:	e8 f6 ef ff ff       	call   800f8d <sys_page_unmap>
  801f97:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f9a:	83 ec 08             	sub    $0x8,%esp
  801f9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa0:	6a 00                	push   $0x0
  801fa2:	e8 e6 ef ff ff       	call   800f8d <sys_page_unmap>
  801fa7:	83 c4 10             	add    $0x10,%esp
}
  801faa:	89 d8                	mov    %ebx,%eax
  801fac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801faf:	5b                   	pop    %ebx
  801fb0:	5e                   	pop    %esi
  801fb1:	5d                   	pop    %ebp
  801fb2:	c3                   	ret    

00801fb3 <pipeisclosed>:
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fbc:	50                   	push   %eax
  801fbd:	ff 75 08             	pushl  0x8(%ebp)
  801fc0:	e8 60 f5 ff ff       	call   801525 <fd_lookup>
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 18                	js     801fe4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd2:	e8 e5 f4 ff ff       	call   8014bc <fd2data>
	return _pipeisclosed(fd, p);
  801fd7:	89 c2                	mov    %eax,%edx
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	e8 2f fd ff ff       	call   801d10 <_pipeisclosed>
  801fe1:	83 c4 10             	add    $0x10,%esp
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	56                   	push   %esi
  801fea:	53                   	push   %ebx
  801feb:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801fee:	85 f6                	test   %esi,%esi
  801ff0:	74 15                	je     802007 <wait+0x21>
	e = &envs[ENVX(envid)];
  801ff2:	89 f0                	mov    %esi,%eax
  801ff4:	25 ff 03 00 00       	and    $0x3ff,%eax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801ff9:	8d 1c c0             	lea    (%eax,%eax,8),%ebx
  801ffc:	c1 e3 04             	shl    $0x4,%ebx
  801fff:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802005:	eb 1b                	jmp    802022 <wait+0x3c>
	assert(envid != 0);
  802007:	68 da 2c 80 00       	push   $0x802cda
  80200c:	68 8f 2c 80 00       	push   $0x802c8f
  802011:	6a 09                	push   $0x9
  802013:	68 e5 2c 80 00       	push   $0x802ce5
  802018:	e8 10 e3 ff ff       	call   80032d <_panic>
		sys_yield();
  80201d:	e8 c7 ee ff ff       	call   800ee9 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802022:	8b 43 48             	mov    0x48(%ebx),%eax
  802025:	39 f0                	cmp    %esi,%eax
  802027:	75 07                	jne    802030 <wait+0x4a>
  802029:	8b 43 54             	mov    0x54(%ebx),%eax
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 ed                	jne    80201d <wait+0x37>
}
  802030:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802033:	5b                   	pop    %ebx
  802034:	5e                   	pop    %esi
  802035:	5d                   	pop    %ebp
  802036:	c3                   	ret    

00802037 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
  80203c:	c3                   	ret    

0080203d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802043:	68 f0 2c 80 00       	push   $0x802cf0
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	e8 c6 ea ff ff       	call   800b16 <strcpy>
	return 0;
}
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <devcons_write>:
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	57                   	push   %edi
  80205b:	56                   	push   %esi
  80205c:	53                   	push   %ebx
  80205d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802063:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802068:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80206e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802071:	73 31                	jae    8020a4 <devcons_write+0x4d>
		m = n - tot;
  802073:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802076:	29 f3                	sub    %esi,%ebx
  802078:	83 fb 7f             	cmp    $0x7f,%ebx
  80207b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802080:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	53                   	push   %ebx
  802087:	89 f0                	mov    %esi,%eax
  802089:	03 45 0c             	add    0xc(%ebp),%eax
  80208c:	50                   	push   %eax
  80208d:	57                   	push   %edi
  80208e:	e8 11 ec ff ff       	call   800ca4 <memmove>
		sys_cputs(buf, m);
  802093:	83 c4 08             	add    $0x8,%esp
  802096:	53                   	push   %ebx
  802097:	57                   	push   %edi
  802098:	e8 af ed ff ff       	call   800e4c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80209d:	01 de                	add    %ebx,%esi
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	eb ca                	jmp    80206e <devcons_write+0x17>
}
  8020a4:	89 f0                	mov    %esi,%eax
  8020a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a9:	5b                   	pop    %ebx
  8020aa:	5e                   	pop    %esi
  8020ab:	5f                   	pop    %edi
  8020ac:	5d                   	pop    %ebp
  8020ad:	c3                   	ret    

008020ae <devcons_read>:
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 08             	sub    $0x8,%esp
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020bd:	74 21                	je     8020e0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020bf:	e8 a6 ed ff ff       	call   800e6a <sys_cgetc>
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	75 07                	jne    8020cf <devcons_read+0x21>
		sys_yield();
  8020c8:	e8 1c ee ff ff       	call   800ee9 <sys_yield>
  8020cd:	eb f0                	jmp    8020bf <devcons_read+0x11>
	if (c < 0)
  8020cf:	78 0f                	js     8020e0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020d1:	83 f8 04             	cmp    $0x4,%eax
  8020d4:	74 0c                	je     8020e2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d9:	88 02                	mov    %al,(%edx)
	return 1;
  8020db:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    
		return 0;
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e7:	eb f7                	jmp    8020e0 <devcons_read+0x32>

008020e9 <cputchar>:
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020f5:	6a 01                	push   $0x1
  8020f7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020fa:	50                   	push   %eax
  8020fb:	e8 4c ed ff ff       	call   800e4c <sys_cputs>
}
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <getchar>:
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80210b:	6a 01                	push   $0x1
  80210d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802110:	50                   	push   %eax
  802111:	6a 00                	push   $0x0
  802113:	e8 78 f6 ff ff       	call   801790 <read>
	if (r < 0)
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	85 c0                	test   %eax,%eax
  80211d:	78 06                	js     802125 <getchar+0x20>
	if (r < 1)
  80211f:	74 06                	je     802127 <getchar+0x22>
	return c;
  802121:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    
		return -E_EOF;
  802127:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80212c:	eb f7                	jmp    802125 <getchar+0x20>

0080212e <iscons>:
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802134:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802137:	50                   	push   %eax
  802138:	ff 75 08             	pushl  0x8(%ebp)
  80213b:	e8 e5 f3 ff ff       	call   801525 <fd_lookup>
  802140:	83 c4 10             	add    $0x10,%esp
  802143:	85 c0                	test   %eax,%eax
  802145:	78 11                	js     802158 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214a:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802150:	39 10                	cmp    %edx,(%eax)
  802152:	0f 94 c0             	sete   %al
  802155:	0f b6 c0             	movzbl %al,%eax
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <opencons>:
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802160:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802163:	50                   	push   %eax
  802164:	e8 6a f3 ff ff       	call   8014d3 <fd_alloc>
  802169:	83 c4 10             	add    $0x10,%esp
  80216c:	85 c0                	test   %eax,%eax
  80216e:	78 3a                	js     8021aa <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802170:	83 ec 04             	sub    $0x4,%esp
  802173:	68 07 04 00 00       	push   $0x407
  802178:	ff 75 f4             	pushl  -0xc(%ebp)
  80217b:	6a 00                	push   $0x0
  80217d:	e8 86 ed ff ff       	call   800f08 <sys_page_alloc>
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	85 c0                	test   %eax,%eax
  802187:	78 21                	js     8021aa <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802192:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80219e:	83 ec 0c             	sub    $0xc,%esp
  8021a1:	50                   	push   %eax
  8021a2:	e8 05 f3 ff ff       	call   8014ac <fd2num>
  8021a7:	83 c4 10             	add    $0x10,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8021b2:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8021b9:	74 0a                	je     8021c5 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	6a 07                	push   $0x7
  8021ca:	68 00 f0 bf ee       	push   $0xeebff000
  8021cf:	6a 00                	push   $0x0
  8021d1:	e8 32 ed ff ff       	call   800f08 <sys_page_alloc>
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	78 28                	js     802205 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	68 17 22 80 00       	push   $0x802217
  8021e5:	6a 00                	push   $0x0
  8021e7:	e8 a8 ee ff ff       	call   801094 <sys_env_set_pgfault_upcall>
  8021ec:	83 c4 10             	add    $0x10,%esp
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	79 c8                	jns    8021bb <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8021f3:	50                   	push   %eax
  8021f4:	68 54 2b 80 00       	push   $0x802b54
  8021f9:	6a 23                	push   $0x23
  8021fb:	68 14 2d 80 00       	push   $0x802d14
  802200:	e8 28 e1 ff ff       	call   80032d <_panic>
			panic("set_pgfault_handler %e\n",r);
  802205:	50                   	push   %eax
  802206:	68 fc 2c 80 00       	push   $0x802cfc
  80220b:	6a 21                	push   $0x21
  80220d:	68 14 2d 80 00       	push   $0x802d14
  802212:	e8 16 e1 ff ff       	call   80032d <_panic>

00802217 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802217:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802218:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80221d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80221f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  802222:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  802226:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80222a:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80222d:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80222f:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802233:	83 c4 08             	add    $0x8,%esp
	popal
  802236:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802237:	83 c4 04             	add    $0x4,%esp
	popfl
  80223a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80223b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80223c:	c3                   	ret    

0080223d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	56                   	push   %esi
  802241:	53                   	push   %ebx
  802242:	8b 75 08             	mov    0x8(%ebp),%esi
  802245:	8b 45 0c             	mov    0xc(%ebp),%eax
  802248:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  80224b:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  80224d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802252:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	50                   	push   %eax
  802259:	e8 9b ee ff ff       	call   8010f9 <sys_ipc_recv>
	if (from_env_store)
  80225e:	83 c4 10             	add    $0x10,%esp
  802261:	85 f6                	test   %esi,%esi
  802263:	74 14                	je     802279 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  802265:	ba 00 00 00 00       	mov    $0x0,%edx
  80226a:	85 c0                	test   %eax,%eax
  80226c:	78 09                	js     802277 <ipc_recv+0x3a>
  80226e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802274:	8b 52 78             	mov    0x78(%edx),%edx
  802277:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  802279:	85 db                	test   %ebx,%ebx
  80227b:	74 14                	je     802291 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  80227d:	ba 00 00 00 00       	mov    $0x0,%edx
  802282:	85 c0                	test   %eax,%eax
  802284:	78 09                	js     80228f <ipc_recv+0x52>
  802286:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80228c:	8b 52 7c             	mov    0x7c(%edx),%edx
  80228f:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  802291:	85 c0                	test   %eax,%eax
  802293:	78 08                	js     80229d <ipc_recv+0x60>
  802295:	a1 04 40 80 00       	mov    0x804004,%eax
  80229a:	8b 40 74             	mov    0x74(%eax),%eax
}
  80229d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a0:	5b                   	pop    %ebx
  8022a1:	5e                   	pop    %esi
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    

008022a4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	83 ec 08             	sub    $0x8,%esp
  8022aa:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022b4:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8022b7:	ff 75 14             	pushl  0x14(%ebp)
  8022ba:	50                   	push   %eax
  8022bb:	ff 75 0c             	pushl  0xc(%ebp)
  8022be:	ff 75 08             	pushl  0x8(%ebp)
  8022c1:	e8 10 ee ff ff       	call   8010d6 <sys_ipc_try_send>
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	78 02                	js     8022cf <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  8022cf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022d2:	75 07                	jne    8022db <ipc_send+0x37>
		sys_yield();
  8022d4:	e8 10 ec ff ff       	call   800ee9 <sys_yield>
}
  8022d9:	eb f2                	jmp    8022cd <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  8022db:	50                   	push   %eax
  8022dc:	68 22 2d 80 00       	push   $0x802d22
  8022e1:	6a 3c                	push   $0x3c
  8022e3:	68 36 2d 80 00       	push   $0x802d36
  8022e8:	e8 40 e0 ff ff       	call   80032d <_panic>

008022ed <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022f3:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  8022f8:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8022fb:	c1 e0 04             	shl    $0x4,%eax
  8022fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802303:	8b 40 50             	mov    0x50(%eax),%eax
  802306:	39 c8                	cmp    %ecx,%eax
  802308:	74 12                	je     80231c <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80230a:	83 c2 01             	add    $0x1,%edx
  80230d:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  802313:	75 e3                	jne    8022f8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
  80231a:	eb 0e                	jmp    80232a <ipc_find_env+0x3d>
			return envs[i].env_id;
  80231c:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80231f:	c1 e0 04             	shl    $0x4,%eax
  802322:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802327:	8b 40 48             	mov    0x48(%eax),%eax
}
  80232a:	5d                   	pop    %ebp
  80232b:	c3                   	ret    

0080232c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802332:	89 d0                	mov    %edx,%eax
  802334:	c1 e8 16             	shr    $0x16,%eax
  802337:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802343:	f6 c1 01             	test   $0x1,%cl
  802346:	74 1d                	je     802365 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802348:	c1 ea 0c             	shr    $0xc,%edx
  80234b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802352:	f6 c2 01             	test   $0x1,%dl
  802355:	74 0e                	je     802365 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802357:	c1 ea 0c             	shr    $0xc,%edx
  80235a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802361:	ef 
  802362:	0f b7 c0             	movzwl %ax,%eax
}
  802365:	5d                   	pop    %ebp
  802366:	c3                   	ret    
  802367:	66 90                	xchg   %ax,%ax
  802369:	66 90                	xchg   %ax,%ax
  80236b:	66 90                	xchg   %ax,%ax
  80236d:	66 90                	xchg   %ax,%ax
  80236f:	90                   	nop

00802370 <__udivdi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80237b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80237f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802383:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802387:	85 d2                	test   %edx,%edx
  802389:	75 4d                	jne    8023d8 <__udivdi3+0x68>
  80238b:	39 f3                	cmp    %esi,%ebx
  80238d:	76 19                	jbe    8023a8 <__udivdi3+0x38>
  80238f:	31 ff                	xor    %edi,%edi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f2                	mov    %esi,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	89 d9                	mov    %ebx,%ecx
  8023aa:	85 db                	test   %ebx,%ebx
  8023ac:	75 0b                	jne    8023b9 <__udivdi3+0x49>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f3                	div    %ebx
  8023b7:	89 c1                	mov    %eax,%ecx
  8023b9:	31 d2                	xor    %edx,%edx
  8023bb:	89 f0                	mov    %esi,%eax
  8023bd:	f7 f1                	div    %ecx
  8023bf:	89 c6                	mov    %eax,%esi
  8023c1:	89 e8                	mov    %ebp,%eax
  8023c3:	89 f7                	mov    %esi,%edi
  8023c5:	f7 f1                	div    %ecx
  8023c7:	89 fa                	mov    %edi,%edx
  8023c9:	83 c4 1c             	add    $0x1c,%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	39 f2                	cmp    %esi,%edx
  8023da:	77 1c                	ja     8023f8 <__udivdi3+0x88>
  8023dc:	0f bd fa             	bsr    %edx,%edi
  8023df:	83 f7 1f             	xor    $0x1f,%edi
  8023e2:	75 2c                	jne    802410 <__udivdi3+0xa0>
  8023e4:	39 f2                	cmp    %esi,%edx
  8023e6:	72 06                	jb     8023ee <__udivdi3+0x7e>
  8023e8:	31 c0                	xor    %eax,%eax
  8023ea:	39 eb                	cmp    %ebp,%ebx
  8023ec:	77 a9                	ja     802397 <__udivdi3+0x27>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	eb a2                	jmp    802397 <__udivdi3+0x27>
  8023f5:	8d 76 00             	lea    0x0(%esi),%esi
  8023f8:	31 ff                	xor    %edi,%edi
  8023fa:	31 c0                	xor    %eax,%eax
  8023fc:	89 fa                	mov    %edi,%edx
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	89 f9                	mov    %edi,%ecx
  802412:	b8 20 00 00 00       	mov    $0x20,%eax
  802417:	29 f8                	sub    %edi,%eax
  802419:	d3 e2                	shl    %cl,%edx
  80241b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80241f:	89 c1                	mov    %eax,%ecx
  802421:	89 da                	mov    %ebx,%edx
  802423:	d3 ea                	shr    %cl,%edx
  802425:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802429:	09 d1                	or     %edx,%ecx
  80242b:	89 f2                	mov    %esi,%edx
  80242d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802431:	89 f9                	mov    %edi,%ecx
  802433:	d3 e3                	shl    %cl,%ebx
  802435:	89 c1                	mov    %eax,%ecx
  802437:	d3 ea                	shr    %cl,%edx
  802439:	89 f9                	mov    %edi,%ecx
  80243b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80243f:	89 eb                	mov    %ebp,%ebx
  802441:	d3 e6                	shl    %cl,%esi
  802443:	89 c1                	mov    %eax,%ecx
  802445:	d3 eb                	shr    %cl,%ebx
  802447:	09 de                	or     %ebx,%esi
  802449:	89 f0                	mov    %esi,%eax
  80244b:	f7 74 24 08          	divl   0x8(%esp)
  80244f:	89 d6                	mov    %edx,%esi
  802451:	89 c3                	mov    %eax,%ebx
  802453:	f7 64 24 0c          	mull   0xc(%esp)
  802457:	39 d6                	cmp    %edx,%esi
  802459:	72 15                	jb     802470 <__udivdi3+0x100>
  80245b:	89 f9                	mov    %edi,%ecx
  80245d:	d3 e5                	shl    %cl,%ebp
  80245f:	39 c5                	cmp    %eax,%ebp
  802461:	73 04                	jae    802467 <__udivdi3+0xf7>
  802463:	39 d6                	cmp    %edx,%esi
  802465:	74 09                	je     802470 <__udivdi3+0x100>
  802467:	89 d8                	mov    %ebx,%eax
  802469:	31 ff                	xor    %edi,%edi
  80246b:	e9 27 ff ff ff       	jmp    802397 <__udivdi3+0x27>
  802470:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802473:	31 ff                	xor    %edi,%edi
  802475:	e9 1d ff ff ff       	jmp    802397 <__udivdi3+0x27>
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	66 90                	xchg   %ax,%ax
  80247e:	66 90                	xchg   %ax,%ax

00802480 <__umoddi3>:
  802480:	55                   	push   %ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	83 ec 1c             	sub    $0x1c,%esp
  802487:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80248b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80248f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802497:	89 da                	mov    %ebx,%edx
  802499:	85 c0                	test   %eax,%eax
  80249b:	75 43                	jne    8024e0 <__umoddi3+0x60>
  80249d:	39 df                	cmp    %ebx,%edi
  80249f:	76 17                	jbe    8024b8 <__umoddi3+0x38>
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	f7 f7                	div    %edi
  8024a5:	89 d0                	mov    %edx,%eax
  8024a7:	31 d2                	xor    %edx,%edx
  8024a9:	83 c4 1c             	add    $0x1c,%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 fd                	mov    %edi,%ebp
  8024ba:	85 ff                	test   %edi,%edi
  8024bc:	75 0b                	jne    8024c9 <__umoddi3+0x49>
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	31 d2                	xor    %edx,%edx
  8024c5:	f7 f7                	div    %edi
  8024c7:	89 c5                	mov    %eax,%ebp
  8024c9:	89 d8                	mov    %ebx,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	f7 f5                	div    %ebp
  8024cf:	89 f0                	mov    %esi,%eax
  8024d1:	f7 f5                	div    %ebp
  8024d3:	89 d0                	mov    %edx,%eax
  8024d5:	eb d0                	jmp    8024a7 <__umoddi3+0x27>
  8024d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024de:	66 90                	xchg   %ax,%ax
  8024e0:	89 f1                	mov    %esi,%ecx
  8024e2:	39 d8                	cmp    %ebx,%eax
  8024e4:	76 0a                	jbe    8024f0 <__umoddi3+0x70>
  8024e6:	89 f0                	mov    %esi,%eax
  8024e8:	83 c4 1c             	add    $0x1c,%esp
  8024eb:	5b                   	pop    %ebx
  8024ec:	5e                   	pop    %esi
  8024ed:	5f                   	pop    %edi
  8024ee:	5d                   	pop    %ebp
  8024ef:	c3                   	ret    
  8024f0:	0f bd e8             	bsr    %eax,%ebp
  8024f3:	83 f5 1f             	xor    $0x1f,%ebp
  8024f6:	75 20                	jne    802518 <__umoddi3+0x98>
  8024f8:	39 d8                	cmp    %ebx,%eax
  8024fa:	0f 82 b0 00 00 00    	jb     8025b0 <__umoddi3+0x130>
  802500:	39 f7                	cmp    %esi,%edi
  802502:	0f 86 a8 00 00 00    	jbe    8025b0 <__umoddi3+0x130>
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	83 c4 1c             	add    $0x1c,%esp
  80250d:	5b                   	pop    %ebx
  80250e:	5e                   	pop    %esi
  80250f:	5f                   	pop    %edi
  802510:	5d                   	pop    %ebp
  802511:	c3                   	ret    
  802512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	ba 20 00 00 00       	mov    $0x20,%edx
  80251f:	29 ea                	sub    %ebp,%edx
  802521:	d3 e0                	shl    %cl,%eax
  802523:	89 44 24 08          	mov    %eax,0x8(%esp)
  802527:	89 d1                	mov    %edx,%ecx
  802529:	89 f8                	mov    %edi,%eax
  80252b:	d3 e8                	shr    %cl,%eax
  80252d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802531:	89 54 24 04          	mov    %edx,0x4(%esp)
  802535:	8b 54 24 04          	mov    0x4(%esp),%edx
  802539:	09 c1                	or     %eax,%ecx
  80253b:	89 d8                	mov    %ebx,%eax
  80253d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802541:	89 e9                	mov    %ebp,%ecx
  802543:	d3 e7                	shl    %cl,%edi
  802545:	89 d1                	mov    %edx,%ecx
  802547:	d3 e8                	shr    %cl,%eax
  802549:	89 e9                	mov    %ebp,%ecx
  80254b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80254f:	d3 e3                	shl    %cl,%ebx
  802551:	89 c7                	mov    %eax,%edi
  802553:	89 d1                	mov    %edx,%ecx
  802555:	89 f0                	mov    %esi,%eax
  802557:	d3 e8                	shr    %cl,%eax
  802559:	89 e9                	mov    %ebp,%ecx
  80255b:	89 fa                	mov    %edi,%edx
  80255d:	d3 e6                	shl    %cl,%esi
  80255f:	09 d8                	or     %ebx,%eax
  802561:	f7 74 24 08          	divl   0x8(%esp)
  802565:	89 d1                	mov    %edx,%ecx
  802567:	89 f3                	mov    %esi,%ebx
  802569:	f7 64 24 0c          	mull   0xc(%esp)
  80256d:	89 c6                	mov    %eax,%esi
  80256f:	89 d7                	mov    %edx,%edi
  802571:	39 d1                	cmp    %edx,%ecx
  802573:	72 06                	jb     80257b <__umoddi3+0xfb>
  802575:	75 10                	jne    802587 <__umoddi3+0x107>
  802577:	39 c3                	cmp    %eax,%ebx
  802579:	73 0c                	jae    802587 <__umoddi3+0x107>
  80257b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80257f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802583:	89 d7                	mov    %edx,%edi
  802585:	89 c6                	mov    %eax,%esi
  802587:	89 ca                	mov    %ecx,%edx
  802589:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258e:	29 f3                	sub    %esi,%ebx
  802590:	19 fa                	sbb    %edi,%edx
  802592:	89 d0                	mov    %edx,%eax
  802594:	d3 e0                	shl    %cl,%eax
  802596:	89 e9                	mov    %ebp,%ecx
  802598:	d3 eb                	shr    %cl,%ebx
  80259a:	d3 ea                	shr    %cl,%edx
  80259c:	09 d8                	or     %ebx,%eax
  80259e:	83 c4 1c             	add    $0x1c,%esp
  8025a1:	5b                   	pop    %ebx
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ad:	8d 76 00             	lea    0x0(%esi),%esi
  8025b0:	89 da                	mov    %ebx,%edx
  8025b2:	29 fe                	sub    %edi,%esi
  8025b4:	19 c2                	sbb    %eax,%edx
  8025b6:	89 f1                	mov    %esi,%ecx
  8025b8:	89 c8                	mov    %ecx,%eax
  8025ba:	e9 4b ff ff ff       	jmp    80250a <__umoddi3+0x8a>
