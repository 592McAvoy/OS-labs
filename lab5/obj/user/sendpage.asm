
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 73 01 00 00       	call   8001a4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 cd 10 00 00       	call   80110b <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 84 a5 00 00 00    	je     8000ee <umain+0xbb>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800049:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80004e:	8b 40 48             	mov    0x48(%eax),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 a0 00       	push   $0xa00000
  80005b:	50                   	push   %eax
  80005c:	e8 33 0d 00 00       	call   800d94 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 20 80 00    	pushl  0x802004
  80006a:	e8 fa 08 00 00       	call   800969 <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 20 80 00    	pushl  0x802004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 0c 0b 00 00       	call   800b92 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	e8 08 13 00 00       	call   80139f <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 8e 12 00 00       	call   801338 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 60 17 80 00       	push   $0x801760
  8000ba:	e8 d5 01 00 00       	call   800294 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 20 80 00    	pushl  0x802000
  8000c8:	e8 9c 08 00 00       	call   800969 <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 20 80 00    	pushl  0x802000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 92 09 00 00       	call   800a73 <strncmp>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	0f 84 a3 00 00 00    	je     80018f <umain+0x15c>
		cprintf("parent received correct message\n");
	return;
}
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	6a 00                	push   $0x0
  8000f3:	68 00 00 b0 00       	push   $0xb00000
  8000f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 37 12 00 00       	call   801338 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 60 17 80 00       	push   $0x801760
  800111:	e8 7e 01 00 00       	call   800294 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 20 80 00    	pushl  0x802004
  80011f:	e8 45 08 00 00       	call   800969 <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 20 80 00    	pushl  0x802004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 3b 09 00 00       	call   800a73 <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 20 80 00    	pushl  0x802000
  800148:	e8 1c 08 00 00       	call   800969 <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 20 80 00    	pushl  0x802000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 2e 0a 00 00       	call   800b92 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	pushl  -0xc(%ebp)
  800170:	e8 2a 12 00 00       	call   80139f <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 74 17 80 00       	push   $0x801774
  800185:	e8 0a 01 00 00       	call   800294 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 94 17 80 00       	push   $0x801794
  800197:	e8 f8 00 00 00       	call   800294 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	e9 48 ff ff ff       	jmp    8000ec <umain+0xb9>

008001a4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001af:	e8 a2 0b 00 00       	call   800d56 <sys_getenvid>
  8001b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b9:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8001bc:	c1 e0 04             	shl    $0x4,%eax
  8001bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c4:	a3 0c 20 80 00       	mov    %eax,0x80200c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c9:	85 db                	test   %ebx,%ebx
  8001cb:	7e 07                	jle    8001d4 <libmain+0x30>
		binaryname = argv[0];
  8001cd:	8b 06                	mov    (%esi),%eax
  8001cf:	a3 08 20 80 00       	mov    %eax,0x802008

	// call user main routine
	umain(argc, argv);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	e8 55 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001de:	e8 0a 00 00 00       	call   8001ed <exit>
}
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e9:	5b                   	pop    %ebx
  8001ea:	5e                   	pop    %esi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8001f3:	6a 00                	push   $0x0
  8001f5:	e8 1b 0b 00 00       	call   800d15 <sys_env_destroy>
}
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	53                   	push   %ebx
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800209:	8b 13                	mov    (%ebx),%edx
  80020b:	8d 42 01             	lea    0x1(%edx),%eax
  80020e:	89 03                	mov    %eax,(%ebx)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	74 09                	je     800227 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800225:	c9                   	leave  
  800226:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	68 ff 00 00 00       	push   $0xff
  80022f:	8d 43 08             	lea    0x8(%ebx),%eax
  800232:	50                   	push   %eax
  800233:	e8 a0 0a 00 00       	call   800cd8 <sys_cputs>
		b->idx = 0;
  800238:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	eb db                	jmp    80021e <putch+0x1f>

00800243 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800253:	00 00 00 
	b.cnt = 0;
  800256:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800260:	ff 75 0c             	pushl  0xc(%ebp)
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	68 ff 01 80 00       	push   $0x8001ff
  800272:	e8 4a 01 00 00       	call   8003c1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800277:	83 c4 08             	add    $0x8,%esp
  80027a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800280:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800286:	50                   	push   %eax
  800287:	e8 4c 0a 00 00       	call   800cd8 <sys_cputs>

	return b.cnt;
}
  80028c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80029d:	50                   	push   %eax
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	e8 9d ff ff ff       	call   800243 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	57                   	push   %edi
  8002ac:	56                   	push   %esi
  8002ad:	53                   	push   %ebx
  8002ae:	83 ec 1c             	sub    $0x1c,%esp
  8002b1:	89 c6                	mov    %eax,%esi
  8002b3:	89 d7                	mov    %edx,%edi
  8002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002c7:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002cb:	74 2c                	je     8002f9 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002e2:	73 43                	jae    800327 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002e4:	83 eb 01             	sub    $0x1,%ebx
  8002e7:	85 db                	test   %ebx,%ebx
  8002e9:	7e 6c                	jle    800357 <printnum+0xaf>
			putch(padc, putdat);
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	57                   	push   %edi
  8002ef:	ff 75 18             	pushl  0x18(%ebp)
  8002f2:	ff d6                	call   *%esi
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	eb eb                	jmp    8002e4 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	6a 20                	push   $0x20
  8002fe:	6a 00                	push   $0x0
  800300:	50                   	push   %eax
  800301:	ff 75 e4             	pushl  -0x1c(%ebp)
  800304:	ff 75 e0             	pushl  -0x20(%ebp)
  800307:	89 fa                	mov    %edi,%edx
  800309:	89 f0                	mov    %esi,%eax
  80030b:	e8 98 ff ff ff       	call   8002a8 <printnum>
		while (--width > 0)
  800310:	83 c4 20             	add    $0x20,%esp
  800313:	83 eb 01             	sub    $0x1,%ebx
  800316:	85 db                	test   %ebx,%ebx
  800318:	7e 65                	jle    80037f <printnum+0xd7>
			putch(padc, putdat);
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	57                   	push   %edi
  80031e:	6a 20                	push   $0x20
  800320:	ff d6                	call   *%esi
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	eb ec                	jmp    800313 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	ff 75 18             	pushl  0x18(%ebp)
  80032d:	83 eb 01             	sub    $0x1,%ebx
  800330:	53                   	push   %ebx
  800331:	50                   	push   %eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	ff 75 dc             	pushl  -0x24(%ebp)
  800338:	ff 75 d8             	pushl  -0x28(%ebp)
  80033b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033e:	ff 75 e0             	pushl  -0x20(%ebp)
  800341:	e8 ba 11 00 00       	call   801500 <__udivdi3>
  800346:	83 c4 18             	add    $0x18,%esp
  800349:	52                   	push   %edx
  80034a:	50                   	push   %eax
  80034b:	89 fa                	mov    %edi,%edx
  80034d:	89 f0                	mov    %esi,%eax
  80034f:	e8 54 ff ff ff       	call   8002a8 <printnum>
  800354:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	57                   	push   %edi
  80035b:	83 ec 04             	sub    $0x4,%esp
  80035e:	ff 75 dc             	pushl  -0x24(%ebp)
  800361:	ff 75 d8             	pushl  -0x28(%ebp)
  800364:	ff 75 e4             	pushl  -0x1c(%ebp)
  800367:	ff 75 e0             	pushl  -0x20(%ebp)
  80036a:	e8 a1 12 00 00       	call   801610 <__umoddi3>
  80036f:	83 c4 14             	add    $0x14,%esp
  800372:	0f be 80 0c 18 80 00 	movsbl 0x80180c(%eax),%eax
  800379:	50                   	push   %eax
  80037a:	ff d6                	call   *%esi
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800382:	5b                   	pop    %ebx
  800383:	5e                   	pop    %esi
  800384:	5f                   	pop    %edi
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    

00800387 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800391:	8b 10                	mov    (%eax),%edx
  800393:	3b 50 04             	cmp    0x4(%eax),%edx
  800396:	73 0a                	jae    8003a2 <sprintputch+0x1b>
		*b->buf++ = ch;
  800398:	8d 4a 01             	lea    0x1(%edx),%ecx
  80039b:	89 08                	mov    %ecx,(%eax)
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	88 02                	mov    %al,(%edx)
}
  8003a2:	5d                   	pop    %ebp
  8003a3:	c3                   	ret    

008003a4 <printfmt>:
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003aa:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ad:	50                   	push   %eax
  8003ae:	ff 75 10             	pushl  0x10(%ebp)
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	e8 05 00 00 00       	call   8003c1 <vprintfmt>
}
  8003bc:	83 c4 10             	add    $0x10,%esp
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    

008003c1 <vprintfmt>:
{
  8003c1:	55                   	push   %ebp
  8003c2:	89 e5                	mov    %esp,%ebp
  8003c4:	57                   	push   %edi
  8003c5:	56                   	push   %esi
  8003c6:	53                   	push   %ebx
  8003c7:	83 ec 3c             	sub    $0x3c,%esp
  8003ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8003cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003d0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003d3:	e9 b4 03 00 00       	jmp    80078c <vprintfmt+0x3cb>
		padc = ' ';
  8003d8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8003dc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8003e3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003ea:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003f1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8d 47 01             	lea    0x1(%edi),%eax
  800400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800403:	0f b6 17             	movzbl (%edi),%edx
  800406:	8d 42 dd             	lea    -0x23(%edx),%eax
  800409:	3c 55                	cmp    $0x55,%al
  80040b:	0f 87 c8 04 00 00    	ja     8008d9 <vprintfmt+0x518>
  800411:	0f b6 c0             	movzbl %al,%eax
  800414:	ff 24 85 e0 19 80 00 	jmp    *0x8019e0(,%eax,4)
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80041e:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800425:	eb d6                	jmp    8003fd <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80042a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80042e:	eb cd                	jmp    8003fd <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800430:	0f b6 d2             	movzbl %dl,%edx
  800433:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800436:	b8 00 00 00 00       	mov    $0x0,%eax
  80043b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80043e:	eb 0c                	jmp    80044c <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800443:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800447:	eb b4                	jmp    8003fd <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800449:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80044c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80044f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800453:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800456:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800459:	83 f9 09             	cmp    $0x9,%ecx
  80045c:	76 eb                	jbe    800449 <vprintfmt+0x88>
  80045e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800461:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800464:	eb 14                	jmp    80047a <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800466:	8b 45 14             	mov    0x14(%ebp),%eax
  800469:	8b 00                	mov    (%eax),%eax
  80046b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046e:	8b 45 14             	mov    0x14(%ebp),%eax
  800471:	8d 40 04             	lea    0x4(%eax),%eax
  800474:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80047a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80047e:	0f 89 79 ff ff ff    	jns    8003fd <vprintfmt+0x3c>
				width = precision, precision = -1;
  800484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800487:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800491:	e9 67 ff ff ff       	jmp    8003fd <vprintfmt+0x3c>
  800496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a0:	0f 49 d0             	cmovns %eax,%edx
  8004a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a9:	e9 4f ff ff ff       	jmp    8003fd <vprintfmt+0x3c>
  8004ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004b1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004b8:	e9 40 ff ff ff       	jmp    8003fd <vprintfmt+0x3c>
			lflag++;
  8004bd:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004c3:	e9 35 ff ff ff       	jmp    8003fd <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	8d 78 04             	lea    0x4(%eax),%edi
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	ff 30                	pushl  (%eax)
  8004d4:	ff d6                	call   *%esi
			break;
  8004d6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004d9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004dc:	e9 a8 02 00 00       	jmp    800789 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8d 78 04             	lea    0x4(%eax),%edi
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	99                   	cltd   
  8004ea:	31 d0                	xor    %edx,%eax
  8004ec:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ee:	83 f8 0f             	cmp    $0xf,%eax
  8004f1:	7f 23                	jg     800516 <vprintfmt+0x155>
  8004f3:	8b 14 85 40 1b 80 00 	mov    0x801b40(,%eax,4),%edx
  8004fa:	85 d2                	test   %edx,%edx
  8004fc:	74 18                	je     800516 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8004fe:	52                   	push   %edx
  8004ff:	68 2d 18 80 00       	push   $0x80182d
  800504:	53                   	push   %ebx
  800505:	56                   	push   %esi
  800506:	e8 99 fe ff ff       	call   8003a4 <printfmt>
  80050b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800511:	e9 73 02 00 00       	jmp    800789 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800516:	50                   	push   %eax
  800517:	68 24 18 80 00       	push   $0x801824
  80051c:	53                   	push   %ebx
  80051d:	56                   	push   %esi
  80051e:	e8 81 fe ff ff       	call   8003a4 <printfmt>
  800523:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800529:	e9 5b 02 00 00       	jmp    800789 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	83 c0 04             	add    $0x4,%eax
  800534:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80053c:	85 d2                	test   %edx,%edx
  80053e:	b8 1d 18 80 00       	mov    $0x80181d,%eax
  800543:	0f 45 c2             	cmovne %edx,%eax
  800546:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800549:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80054d:	7e 06                	jle    800555 <vprintfmt+0x194>
  80054f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800553:	75 0d                	jne    800562 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	89 c7                	mov    %eax,%edi
  80055a:	03 45 e0             	add    -0x20(%ebp),%eax
  80055d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800560:	eb 53                	jmp    8005b5 <vprintfmt+0x1f4>
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	ff 75 d8             	pushl  -0x28(%ebp)
  800568:	50                   	push   %eax
  800569:	e8 13 04 00 00       	call   800981 <strnlen>
  80056e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800571:	29 c1                	sub    %eax,%ecx
  800573:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80057b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80057f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800582:	eb 0f                	jmp    800593 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	ff 75 e0             	pushl  -0x20(%ebp)
  80058b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80058d:	83 ef 01             	sub    $0x1,%edi
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	85 ff                	test   %edi,%edi
  800595:	7f ed                	jg     800584 <vprintfmt+0x1c3>
  800597:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80059a:	85 d2                	test   %edx,%edx
  80059c:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a1:	0f 49 c2             	cmovns %edx,%eax
  8005a4:	29 c2                	sub    %eax,%edx
  8005a6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005a9:	eb aa                	jmp    800555 <vprintfmt+0x194>
					putch(ch, putdat);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	53                   	push   %ebx
  8005af:	52                   	push   %edx
  8005b0:	ff d6                	call   *%esi
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ba:	83 c7 01             	add    $0x1,%edi
  8005bd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c1:	0f be d0             	movsbl %al,%edx
  8005c4:	85 d2                	test   %edx,%edx
  8005c6:	74 4b                	je     800613 <vprintfmt+0x252>
  8005c8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005cc:	78 06                	js     8005d4 <vprintfmt+0x213>
  8005ce:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005d2:	78 1e                	js     8005f2 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d8:	74 d1                	je     8005ab <vprintfmt+0x1ea>
  8005da:	0f be c0             	movsbl %al,%eax
  8005dd:	83 e8 20             	sub    $0x20,%eax
  8005e0:	83 f8 5e             	cmp    $0x5e,%eax
  8005e3:	76 c6                	jbe    8005ab <vprintfmt+0x1ea>
					putch('?', putdat);
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	53                   	push   %ebx
  8005e9:	6a 3f                	push   $0x3f
  8005eb:	ff d6                	call   *%esi
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	eb c3                	jmp    8005b5 <vprintfmt+0x1f4>
  8005f2:	89 cf                	mov    %ecx,%edi
  8005f4:	eb 0e                	jmp    800604 <vprintfmt+0x243>
				putch(' ', putdat);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	53                   	push   %ebx
  8005fa:	6a 20                	push   $0x20
  8005fc:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005fe:	83 ef 01             	sub    $0x1,%edi
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	85 ff                	test   %edi,%edi
  800606:	7f ee                	jg     8005f6 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800608:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
  80060e:	e9 76 01 00 00       	jmp    800789 <vprintfmt+0x3c8>
  800613:	89 cf                	mov    %ecx,%edi
  800615:	eb ed                	jmp    800604 <vprintfmt+0x243>
	if (lflag >= 2)
  800617:	83 f9 01             	cmp    $0x1,%ecx
  80061a:	7f 1f                	jg     80063b <vprintfmt+0x27a>
	else if (lflag)
  80061c:	85 c9                	test   %ecx,%ecx
  80061e:	74 6a                	je     80068a <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800628:	89 c1                	mov    %eax,%ecx
  80062a:	c1 f9 1f             	sar    $0x1f,%ecx
  80062d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8d 40 04             	lea    0x4(%eax),%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	eb 17                	jmp    800652 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8b 50 04             	mov    0x4(%eax),%edx
  800641:	8b 00                	mov    (%eax),%eax
  800643:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800646:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 08             	lea    0x8(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800652:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800655:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80065a:	85 d2                	test   %edx,%edx
  80065c:	0f 89 f8 00 00 00    	jns    80075a <vprintfmt+0x399>
				putch('-', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	6a 2d                	push   $0x2d
  800668:	ff d6                	call   *%esi
				num = -(long long) num;
  80066a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80066d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800670:	f7 d8                	neg    %eax
  800672:	83 d2 00             	adc    $0x0,%edx
  800675:	f7 da                	neg    %edx
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800680:	bf 0a 00 00 00       	mov    $0xa,%edi
  800685:	e9 e1 00 00 00       	jmp    80076b <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800692:	99                   	cltd   
  800693:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
  80069f:	eb b1                	jmp    800652 <vprintfmt+0x291>
	if (lflag >= 2)
  8006a1:	83 f9 01             	cmp    $0x1,%ecx
  8006a4:	7f 27                	jg     8006cd <vprintfmt+0x30c>
	else if (lflag)
  8006a6:	85 c9                	test   %ecx,%ecx
  8006a8:	74 41                	je     8006eb <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8d 40 04             	lea    0x4(%eax),%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006c8:	e9 8d 00 00 00       	jmp    80075a <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 50 04             	mov    0x4(%eax),%edx
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 08             	lea    0x8(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006e9:	eb 6f                	jmp    80075a <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8d 40 04             	lea    0x4(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800704:	bf 0a 00 00 00       	mov    $0xa,%edi
  800709:	eb 4f                	jmp    80075a <vprintfmt+0x399>
	if (lflag >= 2)
  80070b:	83 f9 01             	cmp    $0x1,%ecx
  80070e:	7f 23                	jg     800733 <vprintfmt+0x372>
	else if (lflag)
  800710:	85 c9                	test   %ecx,%ecx
  800712:	0f 84 98 00 00 00    	je     8007b0 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	ba 00 00 00 00       	mov    $0x0,%edx
  800722:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800725:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
  800731:	eb 17                	jmp    80074a <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8d 40 08             	lea    0x8(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 30                	push   $0x30
  800750:	ff d6                	call   *%esi
			goto number;
  800752:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800755:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  80075a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80075e:	74 0b                	je     80076b <vprintfmt+0x3aa>
				putch('+', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	53                   	push   %ebx
  800764:	6a 2b                	push   $0x2b
  800766:	ff d6                	call   *%esi
  800768:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800772:	50                   	push   %eax
  800773:	ff 75 e0             	pushl  -0x20(%ebp)
  800776:	57                   	push   %edi
  800777:	ff 75 dc             	pushl  -0x24(%ebp)
  80077a:	ff 75 d8             	pushl  -0x28(%ebp)
  80077d:	89 da                	mov    %ebx,%edx
  80077f:	89 f0                	mov    %esi,%eax
  800781:	e8 22 fb ff ff       	call   8002a8 <printnum>
			break;
  800786:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800789:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80078c:	83 c7 01             	add    $0x1,%edi
  80078f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800793:	83 f8 25             	cmp    $0x25,%eax
  800796:	0f 84 3c fc ff ff    	je     8003d8 <vprintfmt+0x17>
			if (ch == '\0')
  80079c:	85 c0                	test   %eax,%eax
  80079e:	0f 84 55 01 00 00    	je     8008f9 <vprintfmt+0x538>
			putch(ch, putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	53                   	push   %ebx
  8007a8:	50                   	push   %eax
  8007a9:	ff d6                	call   *%esi
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	eb dc                	jmp    80078c <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 40 04             	lea    0x4(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	e9 7c ff ff ff       	jmp    80074a <vprintfmt+0x389>
			putch('0', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	53                   	push   %ebx
  8007d2:	6a 30                	push   $0x30
  8007d4:	ff d6                	call   *%esi
			putch('x', putdat);
  8007d6:	83 c4 08             	add    $0x8,%esp
  8007d9:	53                   	push   %ebx
  8007da:	6a 78                	push   $0x78
  8007dc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007ee:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8d 40 04             	lea    0x4(%eax),%eax
  8007f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fa:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8007ff:	e9 56 ff ff ff       	jmp    80075a <vprintfmt+0x399>
	if (lflag >= 2)
  800804:	83 f9 01             	cmp    $0x1,%ecx
  800807:	7f 27                	jg     800830 <vprintfmt+0x46f>
	else if (lflag)
  800809:	85 c9                	test   %ecx,%ecx
  80080b:	74 44                	je     800851 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
  800817:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8d 40 04             	lea    0x4(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800826:	bf 10 00 00 00       	mov    $0x10,%edi
  80082b:	e9 2a ff ff ff       	jmp    80075a <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8b 50 04             	mov    0x4(%eax),%edx
  800836:	8b 00                	mov    (%eax),%eax
  800838:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8d 40 08             	lea    0x8(%eax),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800847:	bf 10 00 00 00       	mov    $0x10,%edi
  80084c:	e9 09 ff ff ff       	jmp    80075a <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	ba 00 00 00 00       	mov    $0x0,%edx
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8d 40 04             	lea    0x4(%eax),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80086a:	bf 10 00 00 00       	mov    $0x10,%edi
  80086f:	e9 e6 fe ff ff       	jmp    80075a <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 78 04             	lea    0x4(%eax),%edi
  80087a:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  80087c:	85 c0                	test   %eax,%eax
  80087e:	74 2d                	je     8008ad <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800880:	0f b6 13             	movzbl (%ebx),%edx
  800883:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800885:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800888:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80088b:	0f 8e f8 fe ff ff    	jle    800789 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800891:	68 7c 19 80 00       	push   $0x80197c
  800896:	68 2d 18 80 00       	push   $0x80182d
  80089b:	53                   	push   %ebx
  80089c:	56                   	push   %esi
  80089d:	e8 02 fb ff ff       	call   8003a4 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008a5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008a8:	e9 dc fe ff ff       	jmp    800789 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8008ad:	68 44 19 80 00       	push   $0x801944
  8008b2:	68 2d 18 80 00       	push   $0x80182d
  8008b7:	53                   	push   %ebx
  8008b8:	56                   	push   %esi
  8008b9:	e8 e6 fa ff ff       	call   8003a4 <printfmt>
  8008be:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008c1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008c4:	e9 c0 fe ff ff       	jmp    800789 <vprintfmt+0x3c8>
			putch(ch, putdat);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	53                   	push   %ebx
  8008cd:	6a 25                	push   $0x25
  8008cf:	ff d6                	call   *%esi
			break;
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	e9 b0 fe ff ff       	jmp    800789 <vprintfmt+0x3c8>
			putch('%', putdat);
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	53                   	push   %ebx
  8008dd:	6a 25                	push   $0x25
  8008df:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	89 f8                	mov    %edi,%eax
  8008e6:	eb 03                	jmp    8008eb <vprintfmt+0x52a>
  8008e8:	83 e8 01             	sub    $0x1,%eax
  8008eb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008ef:	75 f7                	jne    8008e8 <vprintfmt+0x527>
  8008f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f4:	e9 90 fe ff ff       	jmp    800789 <vprintfmt+0x3c8>
}
  8008f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5f                   	pop    %edi
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80090d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800910:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800914:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800917:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80091e:	85 c0                	test   %eax,%eax
  800920:	74 26                	je     800948 <vsnprintf+0x47>
  800922:	85 d2                	test   %edx,%edx
  800924:	7e 22                	jle    800948 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800926:	ff 75 14             	pushl  0x14(%ebp)
  800929:	ff 75 10             	pushl  0x10(%ebp)
  80092c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80092f:	50                   	push   %eax
  800930:	68 87 03 80 00       	push   $0x800387
  800935:	e8 87 fa ff ff       	call   8003c1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80093a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800943:	83 c4 10             	add    $0x10,%esp
}
  800946:	c9                   	leave  
  800947:	c3                   	ret    
		return -E_INVAL;
  800948:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80094d:	eb f7                	jmp    800946 <vsnprintf+0x45>

0080094f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800955:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800958:	50                   	push   %eax
  800959:	ff 75 10             	pushl  0x10(%ebp)
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 9a ff ff ff       	call   800901 <vsnprintf>
	va_end(ap);

	return rc;
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    

00800969 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80096f:	b8 00 00 00 00       	mov    $0x0,%eax
  800974:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800978:	74 05                	je     80097f <strlen+0x16>
		n++;
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	eb f5                	jmp    800974 <strlen+0xb>
	return n;
}
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098a:	ba 00 00 00 00       	mov    $0x0,%edx
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 0d                	je     8009a0 <strnlen+0x1f>
  800993:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800997:	74 05                	je     80099e <strnlen+0x1d>
		n++;
  800999:	83 c2 01             	add    $0x1,%edx
  80099c:	eb f1                	jmp    80098f <strnlen+0xe>
  80099e:	89 d0                	mov    %edx,%eax
	return n;
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009b5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009b8:	83 c2 01             	add    $0x1,%edx
  8009bb:	84 c9                	test   %cl,%cl
  8009bd:	75 f2                	jne    8009b1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009bf:	5b                   	pop    %ebx
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	83 ec 10             	sub    $0x10,%esp
  8009c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009cc:	53                   	push   %ebx
  8009cd:	e8 97 ff ff ff       	call   800969 <strlen>
  8009d2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	01 d8                	add    %ebx,%eax
  8009da:	50                   	push   %eax
  8009db:	e8 c2 ff ff ff       	call   8009a2 <strcpy>
	return dst;
}
  8009e0:	89 d8                	mov    %ebx,%eax
  8009e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	56                   	push   %esi
  8009eb:	53                   	push   %ebx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f2:	89 c6                	mov    %eax,%esi
  8009f4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f7:	89 c2                	mov    %eax,%edx
  8009f9:	39 f2                	cmp    %esi,%edx
  8009fb:	74 11                	je     800a0e <strncpy+0x27>
		*dst++ = *src;
  8009fd:	83 c2 01             	add    $0x1,%edx
  800a00:	0f b6 19             	movzbl (%ecx),%ebx
  800a03:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a06:	80 fb 01             	cmp    $0x1,%bl
  800a09:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a0c:	eb eb                	jmp    8009f9 <strncpy+0x12>
	}
	return ret;
}
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	56                   	push   %esi
  800a16:	53                   	push   %ebx
  800a17:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a1d:	8b 55 10             	mov    0x10(%ebp),%edx
  800a20:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a22:	85 d2                	test   %edx,%edx
  800a24:	74 21                	je     800a47 <strlcpy+0x35>
  800a26:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a2a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a2c:	39 c2                	cmp    %eax,%edx
  800a2e:	74 14                	je     800a44 <strlcpy+0x32>
  800a30:	0f b6 19             	movzbl (%ecx),%ebx
  800a33:	84 db                	test   %bl,%bl
  800a35:	74 0b                	je     800a42 <strlcpy+0x30>
			*dst++ = *src++;
  800a37:	83 c1 01             	add    $0x1,%ecx
  800a3a:	83 c2 01             	add    $0x1,%edx
  800a3d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a40:	eb ea                	jmp    800a2c <strlcpy+0x1a>
  800a42:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a44:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a47:	29 f0                	sub    %esi,%eax
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5e                   	pop    %esi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a53:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a56:	0f b6 01             	movzbl (%ecx),%eax
  800a59:	84 c0                	test   %al,%al
  800a5b:	74 0c                	je     800a69 <strcmp+0x1c>
  800a5d:	3a 02                	cmp    (%edx),%al
  800a5f:	75 08                	jne    800a69 <strcmp+0x1c>
		p++, q++;
  800a61:	83 c1 01             	add    $0x1,%ecx
  800a64:	83 c2 01             	add    $0x1,%edx
  800a67:	eb ed                	jmp    800a56 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a69:	0f b6 c0             	movzbl %al,%eax
  800a6c:	0f b6 12             	movzbl (%edx),%edx
  800a6f:	29 d0                	sub    %edx,%eax
}
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	53                   	push   %ebx
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7d:	89 c3                	mov    %eax,%ebx
  800a7f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a82:	eb 06                	jmp    800a8a <strncmp+0x17>
		n--, p++, q++;
  800a84:	83 c0 01             	add    $0x1,%eax
  800a87:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a8a:	39 d8                	cmp    %ebx,%eax
  800a8c:	74 16                	je     800aa4 <strncmp+0x31>
  800a8e:	0f b6 08             	movzbl (%eax),%ecx
  800a91:	84 c9                	test   %cl,%cl
  800a93:	74 04                	je     800a99 <strncmp+0x26>
  800a95:	3a 0a                	cmp    (%edx),%cl
  800a97:	74 eb                	je     800a84 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a99:	0f b6 00             	movzbl (%eax),%eax
  800a9c:	0f b6 12             	movzbl (%edx),%edx
  800a9f:	29 d0                	sub    %edx,%eax
}
  800aa1:	5b                   	pop    %ebx
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    
		return 0;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	eb f6                	jmp    800aa1 <strncmp+0x2e>

00800aab <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab5:	0f b6 10             	movzbl (%eax),%edx
  800ab8:	84 d2                	test   %dl,%dl
  800aba:	74 09                	je     800ac5 <strchr+0x1a>
		if (*s == c)
  800abc:	38 ca                	cmp    %cl,%dl
  800abe:	74 0a                	je     800aca <strchr+0x1f>
	for (; *s; s++)
  800ac0:	83 c0 01             	add    $0x1,%eax
  800ac3:	eb f0                	jmp    800ab5 <strchr+0xa>
			return (char *) s;
	return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ad9:	38 ca                	cmp    %cl,%dl
  800adb:	74 09                	je     800ae6 <strfind+0x1a>
  800add:	84 d2                	test   %dl,%dl
  800adf:	74 05                	je     800ae6 <strfind+0x1a>
	for (; *s; s++)
  800ae1:	83 c0 01             	add    $0x1,%eax
  800ae4:	eb f0                	jmp    800ad6 <strfind+0xa>
			break;
	return (char *) s;
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af4:	85 c9                	test   %ecx,%ecx
  800af6:	74 31                	je     800b29 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af8:	89 f8                	mov    %edi,%eax
  800afa:	09 c8                	or     %ecx,%eax
  800afc:	a8 03                	test   $0x3,%al
  800afe:	75 23                	jne    800b23 <memset+0x3b>
		c &= 0xFF;
  800b00:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b04:	89 d3                	mov    %edx,%ebx
  800b06:	c1 e3 08             	shl    $0x8,%ebx
  800b09:	89 d0                	mov    %edx,%eax
  800b0b:	c1 e0 18             	shl    $0x18,%eax
  800b0e:	89 d6                	mov    %edx,%esi
  800b10:	c1 e6 10             	shl    $0x10,%esi
  800b13:	09 f0                	or     %esi,%eax
  800b15:	09 c2                	or     %eax,%edx
  800b17:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b19:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b1c:	89 d0                	mov    %edx,%eax
  800b1e:	fc                   	cld    
  800b1f:	f3 ab                	rep stos %eax,%es:(%edi)
  800b21:	eb 06                	jmp    800b29 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	fc                   	cld    
  800b27:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b29:	89 f8                	mov    %edi,%eax
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5f                   	pop    %edi
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	57                   	push   %edi
  800b34:	56                   	push   %esi
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b3e:	39 c6                	cmp    %eax,%esi
  800b40:	73 32                	jae    800b74 <memmove+0x44>
  800b42:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b45:	39 c2                	cmp    %eax,%edx
  800b47:	76 2b                	jbe    800b74 <memmove+0x44>
		s += n;
		d += n;
  800b49:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4c:	89 fe                	mov    %edi,%esi
  800b4e:	09 ce                	or     %ecx,%esi
  800b50:	09 d6                	or     %edx,%esi
  800b52:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b58:	75 0e                	jne    800b68 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b5a:	83 ef 04             	sub    $0x4,%edi
  800b5d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b60:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b63:	fd                   	std    
  800b64:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b66:	eb 09                	jmp    800b71 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b68:	83 ef 01             	sub    $0x1,%edi
  800b6b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b6e:	fd                   	std    
  800b6f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b71:	fc                   	cld    
  800b72:	eb 1a                	jmp    800b8e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b74:	89 c2                	mov    %eax,%edx
  800b76:	09 ca                	or     %ecx,%edx
  800b78:	09 f2                	or     %esi,%edx
  800b7a:	f6 c2 03             	test   $0x3,%dl
  800b7d:	75 0a                	jne    800b89 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b7f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b82:	89 c7                	mov    %eax,%edi
  800b84:	fc                   	cld    
  800b85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b87:	eb 05                	jmp    800b8e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b89:	89 c7                	mov    %eax,%edi
  800b8b:	fc                   	cld    
  800b8c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b98:	ff 75 10             	pushl  0x10(%ebp)
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	ff 75 08             	pushl  0x8(%ebp)
  800ba1:	e8 8a ff ff ff       	call   800b30 <memmove>
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb3:	89 c6                	mov    %eax,%esi
  800bb5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb8:	39 f0                	cmp    %esi,%eax
  800bba:	74 1c                	je     800bd8 <memcmp+0x30>
		if (*s1 != *s2)
  800bbc:	0f b6 08             	movzbl (%eax),%ecx
  800bbf:	0f b6 1a             	movzbl (%edx),%ebx
  800bc2:	38 d9                	cmp    %bl,%cl
  800bc4:	75 08                	jne    800bce <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bc6:	83 c0 01             	add    $0x1,%eax
  800bc9:	83 c2 01             	add    $0x1,%edx
  800bcc:	eb ea                	jmp    800bb8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bce:	0f b6 c1             	movzbl %cl,%eax
  800bd1:	0f b6 db             	movzbl %bl,%ebx
  800bd4:	29 d8                	sub    %ebx,%eax
  800bd6:	eb 05                	jmp    800bdd <memcmp+0x35>
	}

	return 0;
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bea:	89 c2                	mov    %eax,%edx
  800bec:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bef:	39 d0                	cmp    %edx,%eax
  800bf1:	73 09                	jae    800bfc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bf3:	38 08                	cmp    %cl,(%eax)
  800bf5:	74 05                	je     800bfc <memfind+0x1b>
	for (; s < ends; s++)
  800bf7:	83 c0 01             	add    $0x1,%eax
  800bfa:	eb f3                	jmp    800bef <memfind+0xe>
			break;
	return (void *) s;
}
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c0a:	eb 03                	jmp    800c0f <strtol+0x11>
		s++;
  800c0c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c0f:	0f b6 01             	movzbl (%ecx),%eax
  800c12:	3c 20                	cmp    $0x20,%al
  800c14:	74 f6                	je     800c0c <strtol+0xe>
  800c16:	3c 09                	cmp    $0x9,%al
  800c18:	74 f2                	je     800c0c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c1a:	3c 2b                	cmp    $0x2b,%al
  800c1c:	74 2a                	je     800c48 <strtol+0x4a>
	int neg = 0;
  800c1e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c23:	3c 2d                	cmp    $0x2d,%al
  800c25:	74 2b                	je     800c52 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c27:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c2d:	75 0f                	jne    800c3e <strtol+0x40>
  800c2f:	80 39 30             	cmpb   $0x30,(%ecx)
  800c32:	74 28                	je     800c5c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c34:	85 db                	test   %ebx,%ebx
  800c36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c3b:	0f 44 d8             	cmove  %eax,%ebx
  800c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c43:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c46:	eb 50                	jmp    800c98 <strtol+0x9a>
		s++;
  800c48:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c4b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c50:	eb d5                	jmp    800c27 <strtol+0x29>
		s++, neg = 1;
  800c52:	83 c1 01             	add    $0x1,%ecx
  800c55:	bf 01 00 00 00       	mov    $0x1,%edi
  800c5a:	eb cb                	jmp    800c27 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c60:	74 0e                	je     800c70 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c62:	85 db                	test   %ebx,%ebx
  800c64:	75 d8                	jne    800c3e <strtol+0x40>
		s++, base = 8;
  800c66:	83 c1 01             	add    $0x1,%ecx
  800c69:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c6e:	eb ce                	jmp    800c3e <strtol+0x40>
		s += 2, base = 16;
  800c70:	83 c1 02             	add    $0x2,%ecx
  800c73:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c78:	eb c4                	jmp    800c3e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c7a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c7d:	89 f3                	mov    %esi,%ebx
  800c7f:	80 fb 19             	cmp    $0x19,%bl
  800c82:	77 29                	ja     800cad <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c84:	0f be d2             	movsbl %dl,%edx
  800c87:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c8a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c8d:	7d 30                	jge    800cbf <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c8f:	83 c1 01             	add    $0x1,%ecx
  800c92:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c96:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c98:	0f b6 11             	movzbl (%ecx),%edx
  800c9b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c9e:	89 f3                	mov    %esi,%ebx
  800ca0:	80 fb 09             	cmp    $0x9,%bl
  800ca3:	77 d5                	ja     800c7a <strtol+0x7c>
			dig = *s - '0';
  800ca5:	0f be d2             	movsbl %dl,%edx
  800ca8:	83 ea 30             	sub    $0x30,%edx
  800cab:	eb dd                	jmp    800c8a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cad:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cb0:	89 f3                	mov    %esi,%ebx
  800cb2:	80 fb 19             	cmp    $0x19,%bl
  800cb5:	77 08                	ja     800cbf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb7:	0f be d2             	movsbl %dl,%edx
  800cba:	83 ea 37             	sub    $0x37,%edx
  800cbd:	eb cb                	jmp    800c8a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc3:	74 05                	je     800cca <strtol+0xcc>
		*endptr = (char *) s;
  800cc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cca:	89 c2                	mov    %eax,%edx
  800ccc:	f7 da                	neg    %edx
  800cce:	85 ff                	test   %edi,%edi
  800cd0:	0f 45 c2             	cmovne %edx,%eax
}
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cde:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce9:	89 c3                	mov    %eax,%ebx
  800ceb:	89 c7                	mov    %eax,%edi
  800ced:	89 c6                	mov    %eax,%esi
  800cef:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800d01:	b8 01 00 00 00       	mov    $0x1,%eax
  800d06:	89 d1                	mov    %edx,%ecx
  800d08:	89 d3                	mov    %edx,%ebx
  800d0a:	89 d7                	mov    %edx,%edi
  800d0c:	89 d6                	mov    %edx,%esi
  800d0e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	b8 03 00 00 00       	mov    $0x3,%eax
  800d2b:	89 cb                	mov    %ecx,%ebx
  800d2d:	89 cf                	mov    %ecx,%edi
  800d2f:	89 ce                	mov    %ecx,%esi
  800d31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7f 08                	jg     800d3f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	50                   	push   %eax
  800d43:	6a 03                	push   $0x3
  800d45:	68 80 1b 80 00       	push   $0x801b80
  800d4a:	6a 33                	push   $0x33
  800d4c:	68 9d 1b 80 00       	push   $0x801b9d
  800d51:	e8 d1 06 00 00       	call   801427 <_panic>

00800d56 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d61:	b8 02 00 00 00       	mov    $0x2,%eax
  800d66:	89 d1                	mov    %edx,%ecx
  800d68:	89 d3                	mov    %edx,%ebx
  800d6a:	89 d7                	mov    %edx,%edi
  800d6c:	89 d6                	mov    %edx,%esi
  800d6e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_yield>:

void
sys_yield(void)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d80:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d85:	89 d1                	mov    %edx,%ecx
  800d87:	89 d3                	mov    %edx,%ebx
  800d89:	89 d7                	mov    %edx,%edi
  800d8b:	89 d6                	mov    %edx,%esi
  800d8d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9d:	be 00 00 00 00       	mov    $0x0,%esi
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da8:	b8 04 00 00 00       	mov    $0x4,%eax
  800dad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db0:	89 f7                	mov    %esi,%edi
  800db2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db4:	85 c0                	test   %eax,%eax
  800db6:	7f 08                	jg     800dc0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc0:	83 ec 0c             	sub    $0xc,%esp
  800dc3:	50                   	push   %eax
  800dc4:	6a 04                	push   $0x4
  800dc6:	68 80 1b 80 00       	push   $0x801b80
  800dcb:	6a 33                	push   $0x33
  800dcd:	68 9d 1b 80 00       	push   $0x801b9d
  800dd2:	e8 50 06 00 00       	call   801427 <_panic>

00800dd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	b8 05 00 00 00       	mov    $0x5,%eax
  800deb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df1:	8b 75 18             	mov    0x18(%ebp),%esi
  800df4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	7f 08                	jg     800e02 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	50                   	push   %eax
  800e06:	6a 05                	push   $0x5
  800e08:	68 80 1b 80 00       	push   $0x801b80
  800e0d:	6a 33                	push   $0x33
  800e0f:	68 9d 1b 80 00       	push   $0x801b9d
  800e14:	e8 0e 06 00 00       	call   801427 <_panic>

00800e19 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e27:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e32:	89 df                	mov    %ebx,%edi
  800e34:	89 de                	mov    %ebx,%esi
  800e36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 06                	push   $0x6
  800e4a:	68 80 1b 80 00       	push   $0x801b80
  800e4f:	6a 33                	push   $0x33
  800e51:	68 9d 1b 80 00       	push   $0x801b9d
  800e56:	e8 cc 05 00 00       	call   801427 <_panic>

00800e5b <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e71:	89 cb                	mov    %ecx,%ebx
  800e73:	89 cf                	mov    %ecx,%edi
  800e75:	89 ce                	mov    %ecx,%esi
  800e77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	7f 08                	jg     800e85 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e85:	83 ec 0c             	sub    $0xc,%esp
  800e88:	50                   	push   %eax
  800e89:	6a 0b                	push   $0xb
  800e8b:	68 80 1b 80 00       	push   $0x801b80
  800e90:	6a 33                	push   $0x33
  800e92:	68 9d 1b 80 00       	push   $0x801b9d
  800e97:	e8 8b 05 00 00       	call   801427 <_panic>

00800e9c <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
  800ea2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb0:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb5:	89 df                	mov    %ebx,%edi
  800eb7:	89 de                	mov    %ebx,%esi
  800eb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	7f 08                	jg     800ec7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec7:	83 ec 0c             	sub    $0xc,%esp
  800eca:	50                   	push   %eax
  800ecb:	6a 08                	push   $0x8
  800ecd:	68 80 1b 80 00       	push   $0x801b80
  800ed2:	6a 33                	push   $0x33
  800ed4:	68 9d 1b 80 00       	push   $0x801b9d
  800ed9:	e8 49 05 00 00       	call   801427 <_panic>

00800ede <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eec:	8b 55 08             	mov    0x8(%ebp),%edx
  800eef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef2:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef7:	89 df                	mov    %ebx,%edi
  800ef9:	89 de                	mov    %ebx,%esi
  800efb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efd:	85 c0                	test   %eax,%eax
  800eff:	7f 08                	jg     800f09 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	50                   	push   %eax
  800f0d:	6a 09                	push   $0x9
  800f0f:	68 80 1b 80 00       	push   $0x801b80
  800f14:	6a 33                	push   $0x33
  800f16:	68 9d 1b 80 00       	push   $0x801b9d
  800f1b:	e8 07 05 00 00       	call   801427 <_panic>

00800f20 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
  800f26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f34:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f39:	89 df                	mov    %ebx,%edi
  800f3b:	89 de                	mov    %ebx,%esi
  800f3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	7f 08                	jg     800f4b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5f                   	pop    %edi
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4b:	83 ec 0c             	sub    $0xc,%esp
  800f4e:	50                   	push   %eax
  800f4f:	6a 0a                	push   $0xa
  800f51:	68 80 1b 80 00       	push   $0x801b80
  800f56:	6a 33                	push   $0x33
  800f58:	68 9d 1b 80 00       	push   $0x801b9d
  800f5d:	e8 c5 04 00 00       	call   801427 <_panic>

00800f62 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f68:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f73:	be 00 00 00 00       	mov    $0x0,%esi
  800f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9b:	89 cb                	mov    %ecx,%ebx
  800f9d:	89 cf                	mov    %ecx,%edi
  800f9f:	89 ce                	mov    %ecx,%esi
  800fa1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa3:	85 c0                	test   %eax,%eax
  800fa5:	7f 08                	jg     800faf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800faa:	5b                   	pop    %ebx
  800fab:	5e                   	pop    %esi
  800fac:	5f                   	pop    %edi
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800faf:	83 ec 0c             	sub    $0xc,%esp
  800fb2:	50                   	push   %eax
  800fb3:	6a 0e                	push   $0xe
  800fb5:	68 80 1b 80 00       	push   $0x801b80
  800fba:	6a 33                	push   $0x33
  800fbc:	68 9d 1b 80 00       	push   $0x801b9d
  800fc1:	e8 61 04 00 00       	call   801427 <_panic>

00800fc6 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	57                   	push   %edi
  800fca:	56                   	push   %esi
  800fcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd7:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fdc:	89 df                	mov    %ebx,%edi
  800fde:	89 de                	mov    %ebx,%esi
  800fe0:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fed:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	b8 10 00 00 00       	mov    $0x10,%eax
  800ffa:	89 cb                	mov    %ecx,%ebx
  800ffc:	89 cf                	mov    %ecx,%edi
  800ffe:	89 ce                	mov    %ecx,%esi
  801000:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	53                   	push   %ebx
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801011:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  801013:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801017:	0f 84 90 00 00 00    	je     8010ad <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  80101d:	89 d8                	mov    %ebx,%eax
  80101f:	c1 e8 16             	shr    $0x16,%eax
  801022:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801029:	a8 01                	test   $0x1,%al
  80102b:	0f 84 90 00 00 00    	je     8010c1 <pgfault+0xba>
  801031:	89 d8                	mov    %ebx,%eax
  801033:	c1 e8 0c             	shr    $0xc,%eax
  801036:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80103d:	a9 01 08 00 00       	test   $0x801,%eax
  801042:	74 7d                	je     8010c1 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801044:	83 ec 04             	sub    $0x4,%esp
  801047:	6a 07                	push   $0x7
  801049:	68 00 f0 7f 00       	push   $0x7ff000
  80104e:	6a 00                	push   $0x0
  801050:	e8 3f fd ff ff       	call   800d94 <sys_page_alloc>
  801055:	83 c4 10             	add    $0x10,%esp
  801058:	85 c0                	test   %eax,%eax
  80105a:	78 79                	js     8010d5 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  80105c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  801062:	83 ec 04             	sub    $0x4,%esp
  801065:	68 00 10 00 00       	push   $0x1000
  80106a:	53                   	push   %ebx
  80106b:	68 00 f0 7f 00       	push   $0x7ff000
  801070:	e8 bb fa ff ff       	call   800b30 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  801075:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80107c:	53                   	push   %ebx
  80107d:	6a 00                	push   $0x0
  80107f:	68 00 f0 7f 00       	push   $0x7ff000
  801084:	6a 00                	push   $0x0
  801086:	e8 4c fd ff ff       	call   800dd7 <sys_page_map>
  80108b:	83 c4 20             	add    $0x20,%esp
  80108e:	85 c0                	test   %eax,%eax
  801090:	78 55                	js     8010e7 <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801092:	83 ec 08             	sub    $0x8,%esp
  801095:	68 00 f0 7f 00       	push   $0x7ff000
  80109a:	6a 00                	push   $0x0
  80109c:	e8 78 fd ff ff       	call   800e19 <sys_page_unmap>
  8010a1:	83 c4 10             	add    $0x10,%esp
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	78 51                	js     8010f9 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  8010a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  8010ad:	83 ec 04             	sub    $0x4,%esp
  8010b0:	68 ac 1b 80 00       	push   $0x801bac
  8010b5:	6a 21                	push   $0x21
  8010b7:	68 34 1c 80 00       	push   $0x801c34
  8010bc:	e8 66 03 00 00       	call   801427 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 d8 1b 80 00       	push   $0x801bd8
  8010c9:	6a 24                	push   $0x24
  8010cb:	68 34 1c 80 00       	push   $0x801c34
  8010d0:	e8 52 03 00 00       	call   801427 <_panic>
		panic("sys_page_alloc: %e\n", r);
  8010d5:	50                   	push   %eax
  8010d6:	68 3f 1c 80 00       	push   $0x801c3f
  8010db:	6a 2e                	push   $0x2e
  8010dd:	68 34 1c 80 00       	push   $0x801c34
  8010e2:	e8 40 03 00 00       	call   801427 <_panic>
		panic("sys_page_map: %e\n", r);
  8010e7:	50                   	push   %eax
  8010e8:	68 53 1c 80 00       	push   $0x801c53
  8010ed:	6a 34                	push   $0x34
  8010ef:	68 34 1c 80 00       	push   $0x801c34
  8010f4:	e8 2e 03 00 00       	call   801427 <_panic>
		panic("sys_page_unmap: %e\n", r);
  8010f9:	50                   	push   %eax
  8010fa:	68 65 1c 80 00       	push   $0x801c65
  8010ff:	6a 37                	push   $0x37
  801101:	68 34 1c 80 00       	push   $0x801c34
  801106:	e8 1c 03 00 00       	call   801427 <_panic>

0080110b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801114:	68 07 10 80 00       	push   $0x801007
  801119:	e8 4f 03 00 00       	call   80146d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80111e:	b8 07 00 00 00       	mov    $0x7,%eax
  801123:	cd 30                	int    $0x30
  801125:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	85 c0                	test   %eax,%eax
  80112d:	78 30                	js     80115f <fork+0x54>
  80112f:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801131:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801136:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80113a:	0f 85 a5 00 00 00    	jne    8011e5 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  801140:	e8 11 fc ff ff       	call   800d56 <sys_getenvid>
  801145:	25 ff 03 00 00       	and    $0x3ff,%eax
  80114a:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80114d:	c1 e0 04             	shl    $0x4,%eax
  801150:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801155:	a3 0c 20 80 00       	mov    %eax,0x80200c
		return 0;
  80115a:	e9 75 01 00 00       	jmp    8012d4 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  80115f:	50                   	push   %eax
  801160:	68 79 1c 80 00       	push   $0x801c79
  801165:	68 83 00 00 00       	push   $0x83
  80116a:	68 34 1c 80 00       	push   $0x801c34
  80116f:	e8 b3 02 00 00       	call   801427 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801174:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	25 07 0e 00 00       	and    $0xe07,%eax
  801183:	50                   	push   %eax
  801184:	56                   	push   %esi
  801185:	57                   	push   %edi
  801186:	56                   	push   %esi
  801187:	6a 00                	push   $0x0
  801189:	e8 49 fc ff ff       	call   800dd7 <sys_page_map>
  80118e:	83 c4 20             	add    $0x20,%esp
  801191:	85 c0                	test   %eax,%eax
  801193:	79 3e                	jns    8011d3 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801195:	50                   	push   %eax
  801196:	68 53 1c 80 00       	push   $0x801c53
  80119b:	6a 50                	push   $0x50
  80119d:	68 34 1c 80 00       	push   $0x801c34
  8011a2:	e8 80 02 00 00       	call   801427 <_panic>
			panic("sys_page_map: %e\n", r);
  8011a7:	50                   	push   %eax
  8011a8:	68 53 1c 80 00       	push   $0x801c53
  8011ad:	6a 54                	push   $0x54
  8011af:	68 34 1c 80 00       	push   $0x801c34
  8011b4:	e8 6e 02 00 00       	call   801427 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8011b9:	83 ec 0c             	sub    $0xc,%esp
  8011bc:	6a 05                	push   $0x5
  8011be:	56                   	push   %esi
  8011bf:	57                   	push   %edi
  8011c0:	56                   	push   %esi
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 0f fc ff ff       	call   800dd7 <sys_page_map>
  8011c8:	83 c4 20             	add    $0x20,%esp
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	0f 88 ab 00 00 00    	js     80127e <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8011d3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011d9:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8011df:	0f 84 ab 00 00 00    	je     801290 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  8011e5:	89 d8                	mov    %ebx,%eax
  8011e7:	c1 e8 16             	shr    $0x16,%eax
  8011ea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f1:	a8 01                	test   $0x1,%al
  8011f3:	74 de                	je     8011d3 <fork+0xc8>
  8011f5:	89 d8                	mov    %ebx,%eax
  8011f7:	c1 e8 0c             	shr    $0xc,%eax
  8011fa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801201:	f6 c2 01             	test   $0x1,%dl
  801204:	74 cd                	je     8011d3 <fork+0xc8>
  801206:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  80120c:	74 c5                	je     8011d3 <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  80120e:	89 c6                	mov    %eax,%esi
  801210:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  801213:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80121a:	f6 c6 04             	test   $0x4,%dh
  80121d:	0f 85 51 ff ff ff    	jne    801174 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  801223:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80122a:	a9 02 08 00 00       	test   $0x802,%eax
  80122f:	74 88                	je     8011b9 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	68 05 08 00 00       	push   $0x805
  801239:	56                   	push   %esi
  80123a:	57                   	push   %edi
  80123b:	56                   	push   %esi
  80123c:	6a 00                	push   $0x0
  80123e:	e8 94 fb ff ff       	call   800dd7 <sys_page_map>
  801243:	83 c4 20             	add    $0x20,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	0f 88 59 ff ff ff    	js     8011a7 <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	68 05 08 00 00       	push   $0x805
  801256:	56                   	push   %esi
  801257:	6a 00                	push   $0x0
  801259:	56                   	push   %esi
  80125a:	6a 00                	push   $0x0
  80125c:	e8 76 fb ff ff       	call   800dd7 <sys_page_map>
  801261:	83 c4 20             	add    $0x20,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	0f 89 67 ff ff ff    	jns    8011d3 <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  80126c:	50                   	push   %eax
  80126d:	68 53 1c 80 00       	push   $0x801c53
  801272:	6a 56                	push   $0x56
  801274:	68 34 1c 80 00       	push   $0x801c34
  801279:	e8 a9 01 00 00       	call   801427 <_panic>
			panic("sys_page_map: %e\n", r);
  80127e:	50                   	push   %eax
  80127f:	68 53 1c 80 00       	push   $0x801c53
  801284:	6a 5a                	push   $0x5a
  801286:	68 34 1c 80 00       	push   $0x801c34
  80128b:	e8 97 01 00 00       	call   801427 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	6a 07                	push   $0x7
  801295:	68 00 f0 bf ee       	push   $0xeebff000
  80129a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129d:	e8 f2 fa ff ff       	call   800d94 <sys_page_alloc>
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	78 36                	js     8012df <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8012a9:	83 ec 08             	sub    $0x8,%esp
  8012ac:	68 d8 14 80 00       	push   $0x8014d8
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	e8 67 fc ff ff       	call   800f20 <sys_env_set_pgfault_upcall>
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	78 34                	js     8012f4 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	6a 02                	push   $0x2
  8012c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012c8:	e8 cf fb ff ff       	call   800e9c <sys_env_set_status>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	78 35                	js     801309 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  8012d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012da:	5b                   	pop    %ebx
  8012db:	5e                   	pop    %esi
  8012dc:	5f                   	pop    %edi
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  8012df:	50                   	push   %eax
  8012e0:	68 3f 1c 80 00       	push   $0x801c3f
  8012e5:	68 95 00 00 00       	push   $0x95
  8012ea:	68 34 1c 80 00       	push   $0x801c34
  8012ef:	e8 33 01 00 00       	call   801427 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  8012f4:	50                   	push   %eax
  8012f5:	68 14 1c 80 00       	push   $0x801c14
  8012fa:	68 98 00 00 00       	push   $0x98
  8012ff:	68 34 1c 80 00       	push   $0x801c34
  801304:	e8 1e 01 00 00       	call   801427 <_panic>
		panic("sys_env_set_status: %e\n", r);
  801309:	50                   	push   %eax
  80130a:	68 89 1c 80 00       	push   $0x801c89
  80130f:	68 9b 00 00 00       	push   $0x9b
  801314:	68 34 1c 80 00       	push   $0x801c34
  801319:	e8 09 01 00 00       	call   801427 <_panic>

0080131e <sfork>:

// Challenge!
int
sfork(void)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801324:	68 a1 1c 80 00       	push   $0x801ca1
  801329:	68 a4 00 00 00       	push   $0xa4
  80132e:	68 34 1c 80 00       	push   $0x801c34
  801333:	e8 ef 00 00 00       	call   801427 <_panic>

00801338 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	8b 75 08             	mov    0x8(%ebp),%esi
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  801346:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801348:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80134d:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  801350:	83 ec 0c             	sub    $0xc,%esp
  801353:	50                   	push   %eax
  801354:	e8 2c fc ff ff       	call   800f85 <sys_ipc_recv>
	if (from_env_store)
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 f6                	test   %esi,%esi
  80135e:	74 14                	je     801374 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  801360:	ba 00 00 00 00       	mov    $0x0,%edx
  801365:	85 c0                	test   %eax,%eax
  801367:	78 09                	js     801372 <ipc_recv+0x3a>
  801369:	8b 15 0c 20 80 00    	mov    0x80200c,%edx
  80136f:	8b 52 78             	mov    0x78(%edx),%edx
  801372:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  801374:	85 db                	test   %ebx,%ebx
  801376:	74 14                	je     80138c <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  801378:	ba 00 00 00 00       	mov    $0x0,%edx
  80137d:	85 c0                	test   %eax,%eax
  80137f:	78 09                	js     80138a <ipc_recv+0x52>
  801381:	8b 15 0c 20 80 00    	mov    0x80200c,%edx
  801387:	8b 52 7c             	mov    0x7c(%edx),%edx
  80138a:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  80138c:	85 c0                	test   %eax,%eax
  80138e:	78 08                	js     801398 <ipc_recv+0x60>
  801390:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801395:	8b 40 74             	mov    0x74(%eax),%eax
}
  801398:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80139b:	5b                   	pop    %ebx
  80139c:	5e                   	pop    %esi
  80139d:	5d                   	pop    %ebp
  80139e:	c3                   	ret    

0080139f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 08             	sub    $0x8,%esp
  8013a5:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8013af:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8013b2:	ff 75 14             	pushl  0x14(%ebp)
  8013b5:	50                   	push   %eax
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 a1 fb ff ff       	call   800f62 <sys_ipc_try_send>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 02                	js     8013ca <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  8013ca:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8013cd:	75 07                	jne    8013d6 <ipc_send+0x37>
		sys_yield();
  8013cf:	e8 a1 f9 ff ff       	call   800d75 <sys_yield>
}
  8013d4:	eb f2                	jmp    8013c8 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  8013d6:	50                   	push   %eax
  8013d7:	68 b7 1c 80 00       	push   $0x801cb7
  8013dc:	6a 3c                	push   $0x3c
  8013de:	68 cb 1c 80 00       	push   $0x801ccb
  8013e3:	e8 3f 00 00 00       	call   801427 <_panic>

008013e8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8013ee:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  8013f3:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8013f6:	c1 e0 04             	shl    $0x4,%eax
  8013f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013fe:	8b 40 50             	mov    0x50(%eax),%eax
  801401:	39 c8                	cmp    %ecx,%eax
  801403:	74 12                	je     801417 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801405:	83 c2 01             	add    $0x1,%edx
  801408:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80140e:	75 e3                	jne    8013f3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	eb 0e                	jmp    801425 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801417:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80141a:	c1 e0 04             	shl    $0x4,%eax
  80141d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801422:	8b 40 48             	mov    0x48(%eax),%eax
}
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	56                   	push   %esi
  80142b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80142c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80142f:	8b 35 08 20 80 00    	mov    0x802008,%esi
  801435:	e8 1c f9 ff ff       	call   800d56 <sys_getenvid>
  80143a:	83 ec 0c             	sub    $0xc,%esp
  80143d:	ff 75 0c             	pushl  0xc(%ebp)
  801440:	ff 75 08             	pushl  0x8(%ebp)
  801443:	56                   	push   %esi
  801444:	50                   	push   %eax
  801445:	68 d8 1c 80 00       	push   $0x801cd8
  80144a:	e8 45 ee ff ff       	call   800294 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80144f:	83 c4 18             	add    $0x18,%esp
  801452:	53                   	push   %ebx
  801453:	ff 75 10             	pushl  0x10(%ebp)
  801456:	e8 e8 ed ff ff       	call   800243 <vcprintf>
	cprintf("\n");
  80145b:	c7 04 24 51 1c 80 00 	movl   $0x801c51,(%esp)
  801462:	e8 2d ee ff ff       	call   800294 <cprintf>
  801467:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80146a:	cc                   	int3   
  80146b:	eb fd                	jmp    80146a <_panic+0x43>

0080146d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801473:	83 3d 10 20 80 00 00 	cmpl   $0x0,0x802010
  80147a:	74 0a                	je     801486 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	a3 10 20 80 00       	mov    %eax,0x802010
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	6a 07                	push   $0x7
  80148b:	68 00 f0 bf ee       	push   $0xeebff000
  801490:	6a 00                	push   $0x0
  801492:	e8 fd f8 ff ff       	call   800d94 <sys_page_alloc>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 28                	js     8014c6 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	68 d8 14 80 00       	push   $0x8014d8
  8014a6:	6a 00                	push   $0x0
  8014a8:	e8 73 fa ff ff       	call   800f20 <sys_env_set_pgfault_upcall>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	79 c8                	jns    80147c <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8014b4:	50                   	push   %eax
  8014b5:	68 14 1c 80 00       	push   $0x801c14
  8014ba:	6a 23                	push   $0x23
  8014bc:	68 14 1d 80 00       	push   $0x801d14
  8014c1:	e8 61 ff ff ff       	call   801427 <_panic>
			panic("set_pgfault_handler %e\n",r);
  8014c6:	50                   	push   %eax
  8014c7:	68 fc 1c 80 00       	push   $0x801cfc
  8014cc:	6a 21                	push   $0x21
  8014ce:	68 14 1d 80 00       	push   $0x801d14
  8014d3:	e8 4f ff ff ff       	call   801427 <_panic>

008014d8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014d8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014d9:	a1 10 20 80 00       	mov    0x802010,%eax
	call *%eax
  8014de:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014e0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  8014e3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  8014e7:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8014eb:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8014ee:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8014f0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8014f4:	83 c4 08             	add    $0x8,%esp
	popal
  8014f7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8014f8:	83 c4 04             	add    $0x4,%esp
	popfl
  8014fb:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8014fc:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8014fd:	c3                   	ret    
  8014fe:	66 90                	xchg   %ax,%ax

00801500 <__udivdi3>:
  801500:	55                   	push   %ebp
  801501:	57                   	push   %edi
  801502:	56                   	push   %esi
  801503:	53                   	push   %ebx
  801504:	83 ec 1c             	sub    $0x1c,%esp
  801507:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80150b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80150f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801513:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801517:	85 d2                	test   %edx,%edx
  801519:	75 4d                	jne    801568 <__udivdi3+0x68>
  80151b:	39 f3                	cmp    %esi,%ebx
  80151d:	76 19                	jbe    801538 <__udivdi3+0x38>
  80151f:	31 ff                	xor    %edi,%edi
  801521:	89 e8                	mov    %ebp,%eax
  801523:	89 f2                	mov    %esi,%edx
  801525:	f7 f3                	div    %ebx
  801527:	89 fa                	mov    %edi,%edx
  801529:	83 c4 1c             	add    $0x1c,%esp
  80152c:	5b                   	pop    %ebx
  80152d:	5e                   	pop    %esi
  80152e:	5f                   	pop    %edi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    
  801531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801538:	89 d9                	mov    %ebx,%ecx
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	75 0b                	jne    801549 <__udivdi3+0x49>
  80153e:	b8 01 00 00 00       	mov    $0x1,%eax
  801543:	31 d2                	xor    %edx,%edx
  801545:	f7 f3                	div    %ebx
  801547:	89 c1                	mov    %eax,%ecx
  801549:	31 d2                	xor    %edx,%edx
  80154b:	89 f0                	mov    %esi,%eax
  80154d:	f7 f1                	div    %ecx
  80154f:	89 c6                	mov    %eax,%esi
  801551:	89 e8                	mov    %ebp,%eax
  801553:	89 f7                	mov    %esi,%edi
  801555:	f7 f1                	div    %ecx
  801557:	89 fa                	mov    %edi,%edx
  801559:	83 c4 1c             	add    $0x1c,%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5f                   	pop    %edi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
  801561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801568:	39 f2                	cmp    %esi,%edx
  80156a:	77 1c                	ja     801588 <__udivdi3+0x88>
  80156c:	0f bd fa             	bsr    %edx,%edi
  80156f:	83 f7 1f             	xor    $0x1f,%edi
  801572:	75 2c                	jne    8015a0 <__udivdi3+0xa0>
  801574:	39 f2                	cmp    %esi,%edx
  801576:	72 06                	jb     80157e <__udivdi3+0x7e>
  801578:	31 c0                	xor    %eax,%eax
  80157a:	39 eb                	cmp    %ebp,%ebx
  80157c:	77 a9                	ja     801527 <__udivdi3+0x27>
  80157e:	b8 01 00 00 00       	mov    $0x1,%eax
  801583:	eb a2                	jmp    801527 <__udivdi3+0x27>
  801585:	8d 76 00             	lea    0x0(%esi),%esi
  801588:	31 ff                	xor    %edi,%edi
  80158a:	31 c0                	xor    %eax,%eax
  80158c:	89 fa                	mov    %edi,%edx
  80158e:	83 c4 1c             	add    $0x1c,%esp
  801591:	5b                   	pop    %ebx
  801592:	5e                   	pop    %esi
  801593:	5f                   	pop    %edi
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    
  801596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80159d:	8d 76 00             	lea    0x0(%esi),%esi
  8015a0:	89 f9                	mov    %edi,%ecx
  8015a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8015a7:	29 f8                	sub    %edi,%eax
  8015a9:	d3 e2                	shl    %cl,%edx
  8015ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015af:	89 c1                	mov    %eax,%ecx
  8015b1:	89 da                	mov    %ebx,%edx
  8015b3:	d3 ea                	shr    %cl,%edx
  8015b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015b9:	09 d1                	or     %edx,%ecx
  8015bb:	89 f2                	mov    %esi,%edx
  8015bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015c1:	89 f9                	mov    %edi,%ecx
  8015c3:	d3 e3                	shl    %cl,%ebx
  8015c5:	89 c1                	mov    %eax,%ecx
  8015c7:	d3 ea                	shr    %cl,%edx
  8015c9:	89 f9                	mov    %edi,%ecx
  8015cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015cf:	89 eb                	mov    %ebp,%ebx
  8015d1:	d3 e6                	shl    %cl,%esi
  8015d3:	89 c1                	mov    %eax,%ecx
  8015d5:	d3 eb                	shr    %cl,%ebx
  8015d7:	09 de                	or     %ebx,%esi
  8015d9:	89 f0                	mov    %esi,%eax
  8015db:	f7 74 24 08          	divl   0x8(%esp)
  8015df:	89 d6                	mov    %edx,%esi
  8015e1:	89 c3                	mov    %eax,%ebx
  8015e3:	f7 64 24 0c          	mull   0xc(%esp)
  8015e7:	39 d6                	cmp    %edx,%esi
  8015e9:	72 15                	jb     801600 <__udivdi3+0x100>
  8015eb:	89 f9                	mov    %edi,%ecx
  8015ed:	d3 e5                	shl    %cl,%ebp
  8015ef:	39 c5                	cmp    %eax,%ebp
  8015f1:	73 04                	jae    8015f7 <__udivdi3+0xf7>
  8015f3:	39 d6                	cmp    %edx,%esi
  8015f5:	74 09                	je     801600 <__udivdi3+0x100>
  8015f7:	89 d8                	mov    %ebx,%eax
  8015f9:	31 ff                	xor    %edi,%edi
  8015fb:	e9 27 ff ff ff       	jmp    801527 <__udivdi3+0x27>
  801600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801603:	31 ff                	xor    %edi,%edi
  801605:	e9 1d ff ff ff       	jmp    801527 <__udivdi3+0x27>
  80160a:	66 90                	xchg   %ax,%ax
  80160c:	66 90                	xchg   %ax,%ax
  80160e:	66 90                	xchg   %ax,%ax

00801610 <__umoddi3>:
  801610:	55                   	push   %ebp
  801611:	57                   	push   %edi
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
  801614:	83 ec 1c             	sub    $0x1c,%esp
  801617:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80161b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80161f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801627:	89 da                	mov    %ebx,%edx
  801629:	85 c0                	test   %eax,%eax
  80162b:	75 43                	jne    801670 <__umoddi3+0x60>
  80162d:	39 df                	cmp    %ebx,%edi
  80162f:	76 17                	jbe    801648 <__umoddi3+0x38>
  801631:	89 f0                	mov    %esi,%eax
  801633:	f7 f7                	div    %edi
  801635:	89 d0                	mov    %edx,%eax
  801637:	31 d2                	xor    %edx,%edx
  801639:	83 c4 1c             	add    $0x1c,%esp
  80163c:	5b                   	pop    %ebx
  80163d:	5e                   	pop    %esi
  80163e:	5f                   	pop    %edi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    
  801641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801648:	89 fd                	mov    %edi,%ebp
  80164a:	85 ff                	test   %edi,%edi
  80164c:	75 0b                	jne    801659 <__umoddi3+0x49>
  80164e:	b8 01 00 00 00       	mov    $0x1,%eax
  801653:	31 d2                	xor    %edx,%edx
  801655:	f7 f7                	div    %edi
  801657:	89 c5                	mov    %eax,%ebp
  801659:	89 d8                	mov    %ebx,%eax
  80165b:	31 d2                	xor    %edx,%edx
  80165d:	f7 f5                	div    %ebp
  80165f:	89 f0                	mov    %esi,%eax
  801661:	f7 f5                	div    %ebp
  801663:	89 d0                	mov    %edx,%eax
  801665:	eb d0                	jmp    801637 <__umoddi3+0x27>
  801667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80166e:	66 90                	xchg   %ax,%ax
  801670:	89 f1                	mov    %esi,%ecx
  801672:	39 d8                	cmp    %ebx,%eax
  801674:	76 0a                	jbe    801680 <__umoddi3+0x70>
  801676:	89 f0                	mov    %esi,%eax
  801678:	83 c4 1c             	add    $0x1c,%esp
  80167b:	5b                   	pop    %ebx
  80167c:	5e                   	pop    %esi
  80167d:	5f                   	pop    %edi
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    
  801680:	0f bd e8             	bsr    %eax,%ebp
  801683:	83 f5 1f             	xor    $0x1f,%ebp
  801686:	75 20                	jne    8016a8 <__umoddi3+0x98>
  801688:	39 d8                	cmp    %ebx,%eax
  80168a:	0f 82 b0 00 00 00    	jb     801740 <__umoddi3+0x130>
  801690:	39 f7                	cmp    %esi,%edi
  801692:	0f 86 a8 00 00 00    	jbe    801740 <__umoddi3+0x130>
  801698:	89 c8                	mov    %ecx,%eax
  80169a:	83 c4 1c             	add    $0x1c,%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5e                   	pop    %esi
  80169f:	5f                   	pop    %edi
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    
  8016a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8016a8:	89 e9                	mov    %ebp,%ecx
  8016aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8016af:	29 ea                	sub    %ebp,%edx
  8016b1:	d3 e0                	shl    %cl,%eax
  8016b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016b7:	89 d1                	mov    %edx,%ecx
  8016b9:	89 f8                	mov    %edi,%eax
  8016bb:	d3 e8                	shr    %cl,%eax
  8016bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016c9:	09 c1                	or     %eax,%ecx
  8016cb:	89 d8                	mov    %ebx,%eax
  8016cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016d1:	89 e9                	mov    %ebp,%ecx
  8016d3:	d3 e7                	shl    %cl,%edi
  8016d5:	89 d1                	mov    %edx,%ecx
  8016d7:	d3 e8                	shr    %cl,%eax
  8016d9:	89 e9                	mov    %ebp,%ecx
  8016db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016df:	d3 e3                	shl    %cl,%ebx
  8016e1:	89 c7                	mov    %eax,%edi
  8016e3:	89 d1                	mov    %edx,%ecx
  8016e5:	89 f0                	mov    %esi,%eax
  8016e7:	d3 e8                	shr    %cl,%eax
  8016e9:	89 e9                	mov    %ebp,%ecx
  8016eb:	89 fa                	mov    %edi,%edx
  8016ed:	d3 e6                	shl    %cl,%esi
  8016ef:	09 d8                	or     %ebx,%eax
  8016f1:	f7 74 24 08          	divl   0x8(%esp)
  8016f5:	89 d1                	mov    %edx,%ecx
  8016f7:	89 f3                	mov    %esi,%ebx
  8016f9:	f7 64 24 0c          	mull   0xc(%esp)
  8016fd:	89 c6                	mov    %eax,%esi
  8016ff:	89 d7                	mov    %edx,%edi
  801701:	39 d1                	cmp    %edx,%ecx
  801703:	72 06                	jb     80170b <__umoddi3+0xfb>
  801705:	75 10                	jne    801717 <__umoddi3+0x107>
  801707:	39 c3                	cmp    %eax,%ebx
  801709:	73 0c                	jae    801717 <__umoddi3+0x107>
  80170b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80170f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801713:	89 d7                	mov    %edx,%edi
  801715:	89 c6                	mov    %eax,%esi
  801717:	89 ca                	mov    %ecx,%edx
  801719:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80171e:	29 f3                	sub    %esi,%ebx
  801720:	19 fa                	sbb    %edi,%edx
  801722:	89 d0                	mov    %edx,%eax
  801724:	d3 e0                	shl    %cl,%eax
  801726:	89 e9                	mov    %ebp,%ecx
  801728:	d3 eb                	shr    %cl,%ebx
  80172a:	d3 ea                	shr    %cl,%edx
  80172c:	09 d8                	or     %ebx,%eax
  80172e:	83 c4 1c             	add    $0x1c,%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5f                   	pop    %edi
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    
  801736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80173d:	8d 76 00             	lea    0x0(%esi),%esi
  801740:	89 da                	mov    %ebx,%edx
  801742:	29 fe                	sub    %edi,%esi
  801744:	19 c2                	sbb    %eax,%edx
  801746:	89 f1                	mov    %esi,%ecx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	e9 4b ff ff ff       	jmp    80169a <__umoddi3+0x8a>
