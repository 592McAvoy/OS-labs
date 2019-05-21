
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 55 04 00 00       	call   800486 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 43 1a 00 00       	call   801a92 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 39 1a 00 00       	call   801a92 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 00 2c 80 00 	movl   $0x802c00,(%esp)
  800060:	e8 57 05 00 00       	call   8005bc <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 6b 2c 80 00 	movl   $0x802c6b,(%esp)
  80006c:	e8 4b 05 00 00       	call   8005bc <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 c1 18 00 00       	call   801944 <read>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	85 c0                	test   %eax,%eax
  800088:	7e 0f                	jle    800099 <wrong+0x66>
		sys_cputs(buf, n);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	50                   	push   %eax
  80008e:	53                   	push   %ebx
  80008f:	e8 6c 0f 00 00       	call   801000 <sys_cputs>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	eb de                	jmp    800077 <wrong+0x44>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 7a 2c 80 00       	push   $0x802c7a
  8000a1:	e8 16 05 00 00       	call   8005bc <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 48 0f 00 00       	call   801000 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 7d 18 00 00       	call   801944 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 75 2c 80 00       	push   $0x802c75
  8000d6:	e8 e1 04 00 00       	call   8005bc <cprintf>
	exit();
  8000db:	e8 ef 03 00 00       	call   8004cf <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 0b 17 00 00       	call   801806 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 ff 16 00 00       	call   801806 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 88 2c 80 00       	push   $0x802c88
  80011b:	e8 87 1c 00 00       	call   801da7 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 d1 24 00 00       	call   80260a <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 24 2c 80 00       	push   $0x802c24
  80014f:	e8 68 04 00 00       	call   8005bc <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 da 12 00 00       	call   801433 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 e7 16 00 00       	call   801858 <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 dc 16 00 00       	call   801858 <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 82 16 00 00       	call   801806 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 7a 16 00 00       	call   801806 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 c5 2c 80 00       	push   $0x802cc5
  800193:	68 92 2c 80 00       	push   $0x802c92
  800198:	68 c8 2c 80 00       	push   $0x802cc8
  80019d:	e8 1a 22 00 00       	call   8023bc <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 4d 16 00 00       	call   801806 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 41 16 00 00       	call   801806 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 ba 25 00 00       	call   802787 <wait>
		exit();
  8001cd:	e8 fd 02 00 00       	call   8004cf <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 28 16 00 00       	call   801806 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 20 16 00 00       	call   801806 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 d6 2c 80 00       	push   $0x802cd6
  8001f6:	e8 ac 1b 00 00       	call   801da7 <open>
  8001fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	85 c0                	test   %eax,%eax
  800203:	78 57                	js     80025c <umain+0x171>
  800205:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  80020a:	bf 00 00 00 00       	mov    $0x0,%edi
  80020f:	e9 9a 00 00 00       	jmp    8002ae <umain+0x1c3>
		panic("open testshell.sh: %e", rfd);
  800214:	50                   	push   %eax
  800215:	68 95 2c 80 00       	push   $0x802c95
  80021a:	6a 13                	push   $0x13
  80021c:	68 ab 2c 80 00       	push   $0x802cab
  800221:	e8 bb 02 00 00       	call   8004e1 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 bc 2c 80 00       	push   $0x802cbc
  80022c:	6a 15                	push   $0x15
  80022e:	68 ab 2c 80 00       	push   $0x802cab
  800233:	e8 a9 02 00 00       	call   8004e1 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 e0 31 80 00       	push   $0x8031e0
  80023e:	6a 1a                	push   $0x1a
  800240:	68 ab 2c 80 00       	push   $0x802cab
  800245:	e8 97 02 00 00       	call   8004e1 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 cc 2c 80 00       	push   $0x802ccc
  800250:	6a 21                	push   $0x21
  800252:	68 ab 2c 80 00       	push   $0x802cab
  800257:	e8 85 02 00 00       	call   8004e1 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 48 2c 80 00       	push   $0x802c48
  800262:	6a 2c                	push   $0x2c
  800264:	68 ab 2c 80 00       	push   $0x802cab
  800269:	e8 73 02 00 00       	call   8004e1 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 e4 2c 80 00       	push   $0x802ce4
  800274:	6a 33                	push   $0x33
  800276:	68 ab 2c 80 00       	push   $0x802cab
  80027b:	e8 61 02 00 00       	call   8004e1 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 fe 2c 80 00       	push   $0x802cfe
  800286:	6a 35                	push   $0x35
  800288:	68 ab 2c 80 00       	push   $0x802cab
  80028d:	e8 4f 02 00 00       	call   8004e1 <_panic>
			wrong(rfd, kfd, nloff);
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	57                   	push   %edi
  800296:	ff 75 d4             	pushl  -0x2c(%ebp)
  800299:	ff 75 d0             	pushl  -0x30(%ebp)
  80029c:	e8 92 fd ff ff       	call   800033 <wrong>
  8002a1:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002a4:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002a8:	0f 44 fe             	cmove  %esi,%edi
  8002ab:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002ae:	83 ec 04             	sub    $0x4,%esp
  8002b1:	6a 01                	push   $0x1
  8002b3:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002b6:	50                   	push   %eax
  8002b7:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ba:	e8 85 16 00 00       	call   801944 <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 72 16 00 00       	call   801944 <read>
		if (n1 < 0)
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	85 db                	test   %ebx,%ebx
  8002d7:	78 95                	js     80026e <umain+0x183>
		if (n2 < 0)
  8002d9:	85 c0                	test   %eax,%eax
  8002db:	78 a3                	js     800280 <umain+0x195>
		if (n1 == 0 && n2 == 0)
  8002dd:	89 da                	mov    %ebx,%edx
  8002df:	09 c2                	or     %eax,%edx
  8002e1:	74 15                	je     8002f8 <umain+0x20d>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002e3:	83 fb 01             	cmp    $0x1,%ebx
  8002e6:	75 aa                	jne    800292 <umain+0x1a7>
  8002e8:	83 f8 01             	cmp    $0x1,%eax
  8002eb:	75 a5                	jne    800292 <umain+0x1a7>
  8002ed:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f1:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002f4:	75 9c                	jne    800292 <umain+0x1a7>
  8002f6:	eb ac                	jmp    8002a4 <umain+0x1b9>
	cprintf("shell ran correctly\n");
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 18 2d 80 00       	push   $0x802d18
  800300:	e8 b7 02 00 00       	call   8005bc <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800305:	cc                   	int3   
}
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800311:	b8 00 00 00 00       	mov    $0x0,%eax
  800316:	c3                   	ret    

00800317 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80031d:	68 2d 2d 80 00       	push   $0x802d2d
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	e8 a0 09 00 00       	call   800cca <strcpy>
	return 0;
}
  80032a:	b8 00 00 00 00       	mov    $0x0,%eax
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <devcons_write>:
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80033d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800342:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800348:	3b 75 10             	cmp    0x10(%ebp),%esi
  80034b:	73 31                	jae    80037e <devcons_write+0x4d>
		m = n - tot;
  80034d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800350:	29 f3                	sub    %esi,%ebx
  800352:	83 fb 7f             	cmp    $0x7f,%ebx
  800355:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80035a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80035d:	83 ec 04             	sub    $0x4,%esp
  800360:	53                   	push   %ebx
  800361:	89 f0                	mov    %esi,%eax
  800363:	03 45 0c             	add    0xc(%ebp),%eax
  800366:	50                   	push   %eax
  800367:	57                   	push   %edi
  800368:	e8 eb 0a 00 00       	call   800e58 <memmove>
		sys_cputs(buf, m);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	53                   	push   %ebx
  800371:	57                   	push   %edi
  800372:	e8 89 0c 00 00       	call   801000 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800377:	01 de                	add    %ebx,%esi
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	eb ca                	jmp    800348 <devcons_write+0x17>
}
  80037e:	89 f0                	mov    %esi,%eax
  800380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800383:	5b                   	pop    %ebx
  800384:	5e                   	pop    %esi
  800385:	5f                   	pop    %edi
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <devcons_read>:
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800393:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800397:	74 21                	je     8003ba <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  800399:	e8 80 0c 00 00       	call   80101e <sys_cgetc>
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	75 07                	jne    8003a9 <devcons_read+0x21>
		sys_yield();
  8003a2:	e8 f6 0c 00 00       	call   80109d <sys_yield>
  8003a7:	eb f0                	jmp    800399 <devcons_read+0x11>
	if (c < 0)
  8003a9:	78 0f                	js     8003ba <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8003ab:	83 f8 04             	cmp    $0x4,%eax
  8003ae:	74 0c                	je     8003bc <devcons_read+0x34>
	*(char*)vbuf = c;
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	88 02                	mov    %al,(%edx)
	return 1;
  8003b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    
		return 0;
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	eb f7                	jmp    8003ba <devcons_read+0x32>

008003c3 <cputchar>:
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003cf:	6a 01                	push   $0x1
  8003d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003d4:	50                   	push   %eax
  8003d5:	e8 26 0c 00 00       	call   801000 <sys_cputs>
}
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	c9                   	leave  
  8003de:	c3                   	ret    

008003df <getchar>:
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003e5:	6a 01                	push   $0x1
  8003e7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003ea:	50                   	push   %eax
  8003eb:	6a 00                	push   $0x0
  8003ed:	e8 52 15 00 00       	call   801944 <read>
	if (r < 0)
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	85 c0                	test   %eax,%eax
  8003f7:	78 06                	js     8003ff <getchar+0x20>
	if (r < 1)
  8003f9:	74 06                	je     800401 <getchar+0x22>
	return c;
  8003fb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    
		return -E_EOF;
  800401:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800406:	eb f7                	jmp    8003ff <getchar+0x20>

00800408 <iscons>:
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80040e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800411:	50                   	push   %eax
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 bf 12 00 00       	call   8016d9 <fd_lookup>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	85 c0                	test   %eax,%eax
  80041f:	78 11                	js     800432 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800424:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80042a:	39 10                	cmp    %edx,(%eax)
  80042c:	0f 94 c0             	sete   %al
  80042f:	0f b6 c0             	movzbl %al,%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <opencons>:
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80043a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80043d:	50                   	push   %eax
  80043e:	e8 44 12 00 00       	call   801687 <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	85 c0                	test   %eax,%eax
  800448:	78 3a                	js     800484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 07 04 00 00       	push   $0x407
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	6a 00                	push   $0x0
  800457:	e8 60 0c 00 00       	call   8010bc <sys_page_alloc>
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	85 c0                	test   %eax,%eax
  800461:	78 21                	js     800484 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800466:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80046c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800471:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	50                   	push   %eax
  80047c:	e8 df 11 00 00       	call   801660 <fd2num>
  800481:	83 c4 10             	add    $0x10,%esp
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	56                   	push   %esi
  80048a:	53                   	push   %ebx
  80048b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80048e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800491:	e8 e8 0b 00 00       	call   80107e <sys_getenvid>
  800496:	25 ff 03 00 00       	and    $0x3ff,%eax
  80049b:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80049e:	c1 e0 04             	shl    $0x4,%eax
  8004a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a6:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ab:	85 db                	test   %ebx,%ebx
  8004ad:	7e 07                	jle    8004b6 <libmain+0x30>
		binaryname = argv[0];
  8004af:	8b 06                	mov    (%esi),%eax
  8004b1:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	56                   	push   %esi
  8004ba:	53                   	push   %ebx
  8004bb:	e8 2b fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004c0:	e8 0a 00 00 00       	call   8004cf <exit>
}
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004cb:	5b                   	pop    %ebx
  8004cc:	5e                   	pop    %esi
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    

008004cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8004d5:	6a 00                	push   $0x0
  8004d7:	e8 61 0b 00 00       	call   80103d <sys_env_destroy>
}
  8004dc:	83 c4 10             	add    $0x10,%esp
  8004df:	c9                   	leave  
  8004e0:	c3                   	ret    

008004e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	56                   	push   %esi
  8004e5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004e6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004e9:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8004ef:	e8 8a 0b 00 00       	call   80107e <sys_getenvid>
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	ff 75 0c             	pushl  0xc(%ebp)
  8004fa:	ff 75 08             	pushl  0x8(%ebp)
  8004fd:	56                   	push   %esi
  8004fe:	50                   	push   %eax
  8004ff:	68 44 2d 80 00       	push   $0x802d44
  800504:	e8 b3 00 00 00       	call   8005bc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800509:	83 c4 18             	add    $0x18,%esp
  80050c:	53                   	push   %ebx
  80050d:	ff 75 10             	pushl  0x10(%ebp)
  800510:	e8 56 00 00 00       	call   80056b <vcprintf>
	cprintf("\n");
  800515:	c7 04 24 78 2c 80 00 	movl   $0x802c78,(%esp)
  80051c:	e8 9b 00 00 00       	call   8005bc <cprintf>
  800521:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800524:	cc                   	int3   
  800525:	eb fd                	jmp    800524 <_panic+0x43>

00800527 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	53                   	push   %ebx
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800531:	8b 13                	mov    (%ebx),%edx
  800533:	8d 42 01             	lea    0x1(%edx),%eax
  800536:	89 03                	mov    %eax,(%ebx)
  800538:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80053b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80053f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800544:	74 09                	je     80054f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800546:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80054a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80054d:	c9                   	leave  
  80054e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	68 ff 00 00 00       	push   $0xff
  800557:	8d 43 08             	lea    0x8(%ebx),%eax
  80055a:	50                   	push   %eax
  80055b:	e8 a0 0a 00 00       	call   801000 <sys_cputs>
		b->idx = 0;
  800560:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	eb db                	jmp    800546 <putch+0x1f>

0080056b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
  80056e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800574:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057b:	00 00 00 
	b.cnt = 0;
  80057e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800585:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800588:	ff 75 0c             	pushl  0xc(%ebp)
  80058b:	ff 75 08             	pushl  0x8(%ebp)
  80058e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800594:	50                   	push   %eax
  800595:	68 27 05 80 00       	push   $0x800527
  80059a:	e8 4a 01 00 00       	call   8006e9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80059f:	83 c4 08             	add    $0x8,%esp
  8005a2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005a8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005ae:	50                   	push   %eax
  8005af:	e8 4c 0a 00 00       	call   801000 <sys_cputs>

	return b.cnt;
}
  8005b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005ba:	c9                   	leave  
  8005bb:	c3                   	ret    

008005bc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005c2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005c5:	50                   	push   %eax
  8005c6:	ff 75 08             	pushl  0x8(%ebp)
  8005c9:	e8 9d ff ff ff       	call   80056b <vcprintf>
	va_end(ap);

	return cnt;
}
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	57                   	push   %edi
  8005d4:	56                   	push   %esi
  8005d5:	53                   	push   %ebx
  8005d6:	83 ec 1c             	sub    $0x1c,%esp
  8005d9:	89 c6                	mov    %eax,%esi
  8005db:	89 d7                	mov    %edx,%edi
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8005ef:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8005f3:	74 2c                	je     800621 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800602:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800605:	39 c2                	cmp    %eax,%edx
  800607:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80060a:	73 43                	jae    80064f <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060c:	83 eb 01             	sub    $0x1,%ebx
  80060f:	85 db                	test   %ebx,%ebx
  800611:	7e 6c                	jle    80067f <printnum+0xaf>
			putch(padc, putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	57                   	push   %edi
  800617:	ff 75 18             	pushl  0x18(%ebp)
  80061a:	ff d6                	call   *%esi
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	eb eb                	jmp    80060c <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	6a 20                	push   $0x20
  800626:	6a 00                	push   $0x0
  800628:	50                   	push   %eax
  800629:	ff 75 e4             	pushl  -0x1c(%ebp)
  80062c:	ff 75 e0             	pushl  -0x20(%ebp)
  80062f:	89 fa                	mov    %edi,%edx
  800631:	89 f0                	mov    %esi,%eax
  800633:	e8 98 ff ff ff       	call   8005d0 <printnum>
		while (--width > 0)
  800638:	83 c4 20             	add    $0x20,%esp
  80063b:	83 eb 01             	sub    $0x1,%ebx
  80063e:	85 db                	test   %ebx,%ebx
  800640:	7e 65                	jle    8006a7 <printnum+0xd7>
			putch(padc, putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	57                   	push   %edi
  800646:	6a 20                	push   $0x20
  800648:	ff d6                	call   *%esi
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	eb ec                	jmp    80063b <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	ff 75 18             	pushl  0x18(%ebp)
  800655:	83 eb 01             	sub    $0x1,%ebx
  800658:	53                   	push   %ebx
  800659:	50                   	push   %eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 dc             	pushl  -0x24(%ebp)
  800660:	ff 75 d8             	pushl  -0x28(%ebp)
  800663:	ff 75 e4             	pushl  -0x1c(%ebp)
  800666:	ff 75 e0             	pushl  -0x20(%ebp)
  800669:	e8 32 23 00 00       	call   8029a0 <__udivdi3>
  80066e:	83 c4 18             	add    $0x18,%esp
  800671:	52                   	push   %edx
  800672:	50                   	push   %eax
  800673:	89 fa                	mov    %edi,%edx
  800675:	89 f0                	mov    %esi,%eax
  800677:	e8 54 ff ff ff       	call   8005d0 <printnum>
  80067c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80067f:	83 ec 08             	sub    $0x8,%esp
  800682:	57                   	push   %edi
  800683:	83 ec 04             	sub    $0x4,%esp
  800686:	ff 75 dc             	pushl  -0x24(%ebp)
  800689:	ff 75 d8             	pushl  -0x28(%ebp)
  80068c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80068f:	ff 75 e0             	pushl  -0x20(%ebp)
  800692:	e8 19 24 00 00       	call   802ab0 <__umoddi3>
  800697:	83 c4 14             	add    $0x14,%esp
  80069a:	0f be 80 67 2d 80 00 	movsbl 0x802d67(%eax),%eax
  8006a1:	50                   	push   %eax
  8006a2:	ff d6                	call   *%esi
  8006a4:	83 c4 10             	add    $0x10,%esp
}
  8006a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006aa:	5b                   	pop    %ebx
  8006ab:	5e                   	pop    %esi
  8006ac:	5f                   	pop    %edi
  8006ad:	5d                   	pop    %ebp
  8006ae:	c3                   	ret    

008006af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
  8006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006b5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006b9:	8b 10                	mov    (%eax),%edx
  8006bb:	3b 50 04             	cmp    0x4(%eax),%edx
  8006be:	73 0a                	jae    8006ca <sprintputch+0x1b>
		*b->buf++ = ch;
  8006c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006c3:	89 08                	mov    %ecx,(%eax)
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	88 02                	mov    %al,(%edx)
}
  8006ca:	5d                   	pop    %ebp
  8006cb:	c3                   	ret    

008006cc <printfmt>:
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006d2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006d5:	50                   	push   %eax
  8006d6:	ff 75 10             	pushl  0x10(%ebp)
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	ff 75 08             	pushl  0x8(%ebp)
  8006df:	e8 05 00 00 00       	call   8006e9 <vprintfmt>
}
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	57                   	push   %edi
  8006ed:	56                   	push   %esi
  8006ee:	53                   	push   %ebx
  8006ef:	83 ec 3c             	sub    $0x3c,%esp
  8006f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8006f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006f8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006fb:	e9 b4 03 00 00       	jmp    800ab4 <vprintfmt+0x3cb>
		padc = ' ';
  800700:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800704:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80070b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800712:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800719:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800720:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800725:	8d 47 01             	lea    0x1(%edi),%eax
  800728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072b:	0f b6 17             	movzbl (%edi),%edx
  80072e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800731:	3c 55                	cmp    $0x55,%al
  800733:	0f 87 c8 04 00 00    	ja     800c01 <vprintfmt+0x518>
  800739:	0f b6 c0             	movzbl %al,%eax
  80073c:	ff 24 85 40 2f 80 00 	jmp    *0x802f40(,%eax,4)
  800743:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800746:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80074d:	eb d6                	jmp    800725 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80074f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800752:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800756:	eb cd                	jmp    800725 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800758:	0f b6 d2             	movzbl %dl,%edx
  80075b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
  800763:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800766:	eb 0c                	jmp    800774 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800768:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80076b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80076f:	eb b4                	jmp    800725 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800771:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800774:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800777:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80077b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80077e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800781:	83 f9 09             	cmp    $0x9,%ecx
  800784:	76 eb                	jbe    800771 <vprintfmt+0x88>
  800786:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	eb 14                	jmp    8007a2 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a6:	0f 89 79 ff ff ff    	jns    800725 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8007ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007b9:	e9 67 ff ff ff       	jmp    800725 <vprintfmt+0x3c>
  8007be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c1:	85 c0                	test   %eax,%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	0f 49 d0             	cmovns %eax,%edx
  8007cb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007d1:	e9 4f ff ff ff       	jmp    800725 <vprintfmt+0x3c>
  8007d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007d9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007e0:	e9 40 ff ff ff       	jmp    800725 <vprintfmt+0x3c>
			lflag++;
  8007e5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007eb:	e9 35 ff ff ff       	jmp    800725 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8d 78 04             	lea    0x4(%eax),%edi
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	ff 30                	pushl  (%eax)
  8007fc:	ff d6                	call   *%esi
			break;
  8007fe:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800801:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800804:	e9 a8 02 00 00       	jmp    800ab1 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8d 78 04             	lea    0x4(%eax),%edi
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	99                   	cltd   
  800812:	31 d0                	xor    %edx,%eax
  800814:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800816:	83 f8 0f             	cmp    $0xf,%eax
  800819:	7f 23                	jg     80083e <vprintfmt+0x155>
  80081b:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  800822:	85 d2                	test   %edx,%edx
  800824:	74 18                	je     80083e <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800826:	52                   	push   %edx
  800827:	68 bd 32 80 00       	push   $0x8032bd
  80082c:	53                   	push   %ebx
  80082d:	56                   	push   %esi
  80082e:	e8 99 fe ff ff       	call   8006cc <printfmt>
  800833:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800836:	89 7d 14             	mov    %edi,0x14(%ebp)
  800839:	e9 73 02 00 00       	jmp    800ab1 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80083e:	50                   	push   %eax
  80083f:	68 7f 2d 80 00       	push   $0x802d7f
  800844:	53                   	push   %ebx
  800845:	56                   	push   %esi
  800846:	e8 81 fe ff ff       	call   8006cc <printfmt>
  80084b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80084e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800851:	e9 5b 02 00 00       	jmp    800ab1 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	83 c0 04             	add    $0x4,%eax
  80085c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800864:	85 d2                	test   %edx,%edx
  800866:	b8 78 2d 80 00       	mov    $0x802d78,%eax
  80086b:	0f 45 c2             	cmovne %edx,%eax
  80086e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800871:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800875:	7e 06                	jle    80087d <vprintfmt+0x194>
  800877:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80087b:	75 0d                	jne    80088a <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80087d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800880:	89 c7                	mov    %eax,%edi
  800882:	03 45 e0             	add    -0x20(%ebp),%eax
  800885:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800888:	eb 53                	jmp    8008dd <vprintfmt+0x1f4>
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 d8             	pushl  -0x28(%ebp)
  800890:	50                   	push   %eax
  800891:	e8 13 04 00 00       	call   800ca9 <strnlen>
  800896:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800899:	29 c1                	sub    %eax,%ecx
  80089b:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8008a3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008aa:	eb 0f                	jmp    8008bb <vprintfmt+0x1d2>
					putch(padc, putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	53                   	push   %ebx
  8008b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b5:	83 ef 01             	sub    $0x1,%edi
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	85 ff                	test   %edi,%edi
  8008bd:	7f ed                	jg     8008ac <vprintfmt+0x1c3>
  8008bf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008c2:	85 d2                	test   %edx,%edx
  8008c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c9:	0f 49 c2             	cmovns %edx,%eax
  8008cc:	29 c2                	sub    %eax,%edx
  8008ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008d1:	eb aa                	jmp    80087d <vprintfmt+0x194>
					putch(ch, putdat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	53                   	push   %ebx
  8008d7:	52                   	push   %edx
  8008d8:	ff d6                	call   *%esi
  8008da:	83 c4 10             	add    $0x10,%esp
  8008dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008e0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	83 c7 01             	add    $0x1,%edi
  8008e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e9:	0f be d0             	movsbl %al,%edx
  8008ec:	85 d2                	test   %edx,%edx
  8008ee:	74 4b                	je     80093b <vprintfmt+0x252>
  8008f0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008f4:	78 06                	js     8008fc <vprintfmt+0x213>
  8008f6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008fa:	78 1e                	js     80091a <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8008fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800900:	74 d1                	je     8008d3 <vprintfmt+0x1ea>
  800902:	0f be c0             	movsbl %al,%eax
  800905:	83 e8 20             	sub    $0x20,%eax
  800908:	83 f8 5e             	cmp    $0x5e,%eax
  80090b:	76 c6                	jbe    8008d3 <vprintfmt+0x1ea>
					putch('?', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	53                   	push   %ebx
  800911:	6a 3f                	push   $0x3f
  800913:	ff d6                	call   *%esi
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	eb c3                	jmp    8008dd <vprintfmt+0x1f4>
  80091a:	89 cf                	mov    %ecx,%edi
  80091c:	eb 0e                	jmp    80092c <vprintfmt+0x243>
				putch(' ', putdat);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	53                   	push   %ebx
  800922:	6a 20                	push   $0x20
  800924:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800926:	83 ef 01             	sub    $0x1,%edi
  800929:	83 c4 10             	add    $0x10,%esp
  80092c:	85 ff                	test   %edi,%edi
  80092e:	7f ee                	jg     80091e <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800930:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
  800936:	e9 76 01 00 00       	jmp    800ab1 <vprintfmt+0x3c8>
  80093b:	89 cf                	mov    %ecx,%edi
  80093d:	eb ed                	jmp    80092c <vprintfmt+0x243>
	if (lflag >= 2)
  80093f:	83 f9 01             	cmp    $0x1,%ecx
  800942:	7f 1f                	jg     800963 <vprintfmt+0x27a>
	else if (lflag)
  800944:	85 c9                	test   %ecx,%ecx
  800946:	74 6a                	je     8009b2 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800950:	89 c1                	mov    %eax,%ecx
  800952:	c1 f9 1f             	sar    $0x1f,%ecx
  800955:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8d 40 04             	lea    0x4(%eax),%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
  800961:	eb 17                	jmp    80097a <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8b 50 04             	mov    0x4(%eax),%edx
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 40 08             	lea    0x8(%eax),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80097a:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80097d:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800982:	85 d2                	test   %edx,%edx
  800984:	0f 89 f8 00 00 00    	jns    800a82 <vprintfmt+0x399>
				putch('-', putdat);
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	53                   	push   %ebx
  80098e:	6a 2d                	push   $0x2d
  800990:	ff d6                	call   *%esi
				num = -(long long) num;
  800992:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800995:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800998:	f7 d8                	neg    %eax
  80099a:	83 d2 00             	adc    $0x0,%edx
  80099d:	f7 da                	neg    %edx
  80099f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009a8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8009ad:	e9 e1 00 00 00       	jmp    800a93 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8009b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ba:	99                   	cltd   
  8009bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	8d 40 04             	lea    0x4(%eax),%eax
  8009c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c7:	eb b1                	jmp    80097a <vprintfmt+0x291>
	if (lflag >= 2)
  8009c9:	83 f9 01             	cmp    $0x1,%ecx
  8009cc:	7f 27                	jg     8009f5 <vprintfmt+0x30c>
	else if (lflag)
  8009ce:	85 c9                	test   %ecx,%ecx
  8009d0:	74 41                	je     800a13 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e5:	8d 40 04             	lea    0x4(%eax),%eax
  8009e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009eb:	bf 0a 00 00 00       	mov    $0xa,%edi
  8009f0:	e9 8d 00 00 00       	jmp    800a82 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	8b 50 04             	mov    0x4(%eax),%edx
  8009fb:	8b 00                	mov    (%eax),%eax
  8009fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a00:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	8d 40 08             	lea    0x8(%eax),%eax
  800a09:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a0c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800a11:	eb 6f                	jmp    800a82 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	8b 00                	mov    (%eax),%eax
  800a18:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a20:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8d 40 04             	lea    0x4(%eax),%eax
  800a29:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a2c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800a31:	eb 4f                	jmp    800a82 <vprintfmt+0x399>
	if (lflag >= 2)
  800a33:	83 f9 01             	cmp    $0x1,%ecx
  800a36:	7f 23                	jg     800a5b <vprintfmt+0x372>
	else if (lflag)
  800a38:	85 c9                	test   %ecx,%ecx
  800a3a:	0f 84 98 00 00 00    	je     800ad8 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	8d 40 04             	lea    0x4(%eax),%eax
  800a56:	89 45 14             	mov    %eax,0x14(%ebp)
  800a59:	eb 17                	jmp    800a72 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5e:	8b 50 04             	mov    0x4(%eax),%edx
  800a61:	8b 00                	mov    (%eax),%eax
  800a63:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a66:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	8d 40 08             	lea    0x8(%eax),%eax
  800a6f:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	53                   	push   %ebx
  800a76:	6a 30                	push   $0x30
  800a78:	ff d6                	call   *%esi
			goto number;
  800a7a:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800a7d:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800a82:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800a86:	74 0b                	je     800a93 <vprintfmt+0x3aa>
				putch('+', putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	53                   	push   %ebx
  800a8c:	6a 2b                	push   $0x2b
  800a8e:	ff d6                	call   *%esi
  800a90:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800a93:	83 ec 0c             	sub    $0xc,%esp
  800a96:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a9a:	50                   	push   %eax
  800a9b:	ff 75 e0             	pushl  -0x20(%ebp)
  800a9e:	57                   	push   %edi
  800a9f:	ff 75 dc             	pushl  -0x24(%ebp)
  800aa2:	ff 75 d8             	pushl  -0x28(%ebp)
  800aa5:	89 da                	mov    %ebx,%edx
  800aa7:	89 f0                	mov    %esi,%eax
  800aa9:	e8 22 fb ff ff       	call   8005d0 <printnum>
			break;
  800aae:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800ab1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab4:	83 c7 01             	add    $0x1,%edi
  800ab7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800abb:	83 f8 25             	cmp    $0x25,%eax
  800abe:	0f 84 3c fc ff ff    	je     800700 <vprintfmt+0x17>
			if (ch == '\0')
  800ac4:	85 c0                	test   %eax,%eax
  800ac6:	0f 84 55 01 00 00    	je     800c21 <vprintfmt+0x538>
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	53                   	push   %ebx
  800ad0:	50                   	push   %eax
  800ad1:	ff d6                	call   *%esi
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	eb dc                	jmp    800ab4 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	8b 00                	mov    (%eax),%eax
  800add:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ae8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aeb:	8d 40 04             	lea    0x4(%eax),%eax
  800aee:	89 45 14             	mov    %eax,0x14(%ebp)
  800af1:	e9 7c ff ff ff       	jmp    800a72 <vprintfmt+0x389>
			putch('0', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	53                   	push   %ebx
  800afa:	6a 30                	push   $0x30
  800afc:	ff d6                	call   *%esi
			putch('x', putdat);
  800afe:	83 c4 08             	add    $0x8,%esp
  800b01:	53                   	push   %ebx
  800b02:	6a 78                	push   $0x78
  800b04:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b06:	8b 45 14             	mov    0x14(%ebp),%eax
  800b09:	8b 00                	mov    (%eax),%eax
  800b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b10:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b13:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b16:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	8d 40 04             	lea    0x4(%eax),%eax
  800b1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b22:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800b27:	e9 56 ff ff ff       	jmp    800a82 <vprintfmt+0x399>
	if (lflag >= 2)
  800b2c:	83 f9 01             	cmp    $0x1,%ecx
  800b2f:	7f 27                	jg     800b58 <vprintfmt+0x46f>
	else if (lflag)
  800b31:	85 c9                	test   %ecx,%ecx
  800b33:	74 44                	je     800b79 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	8b 00                	mov    (%eax),%eax
  800b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b42:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b45:	8b 45 14             	mov    0x14(%ebp),%eax
  800b48:	8d 40 04             	lea    0x4(%eax),%eax
  800b4b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b4e:	bf 10 00 00 00       	mov    $0x10,%edi
  800b53:	e9 2a ff ff ff       	jmp    800a82 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	8b 50 04             	mov    0x4(%eax),%edx
  800b5e:	8b 00                	mov    (%eax),%eax
  800b60:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b63:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b66:	8b 45 14             	mov    0x14(%ebp),%eax
  800b69:	8d 40 08             	lea    0x8(%eax),%eax
  800b6c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b6f:	bf 10 00 00 00       	mov    $0x10,%edi
  800b74:	e9 09 ff ff ff       	jmp    800a82 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b83:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b86:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b89:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8c:	8d 40 04             	lea    0x4(%eax),%eax
  800b8f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b92:	bf 10 00 00 00       	mov    $0x10,%edi
  800b97:	e9 e6 fe ff ff       	jmp    800a82 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800b9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9f:	8d 78 04             	lea    0x4(%eax),%edi
  800ba2:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	74 2d                	je     800bd5 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800ba8:	0f b6 13             	movzbl (%ebx),%edx
  800bab:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800bad:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800bb0:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800bb3:	0f 8e f8 fe ff ff    	jle    800ab1 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800bb9:	68 d4 2e 80 00       	push   $0x802ed4
  800bbe:	68 bd 32 80 00       	push   $0x8032bd
  800bc3:	53                   	push   %ebx
  800bc4:	56                   	push   %esi
  800bc5:	e8 02 fb ff ff       	call   8006cc <printfmt>
  800bca:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800bcd:	89 7d 14             	mov    %edi,0x14(%ebp)
  800bd0:	e9 dc fe ff ff       	jmp    800ab1 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800bd5:	68 9c 2e 80 00       	push   $0x802e9c
  800bda:	68 bd 32 80 00       	push   $0x8032bd
  800bdf:	53                   	push   %ebx
  800be0:	56                   	push   %esi
  800be1:	e8 e6 fa ff ff       	call   8006cc <printfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800be9:	89 7d 14             	mov    %edi,0x14(%ebp)
  800bec:	e9 c0 fe ff ff       	jmp    800ab1 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	53                   	push   %ebx
  800bf5:	6a 25                	push   $0x25
  800bf7:	ff d6                	call   *%esi
			break;
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	e9 b0 fe ff ff       	jmp    800ab1 <vprintfmt+0x3c8>
			putch('%', putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	53                   	push   %ebx
  800c05:	6a 25                	push   $0x25
  800c07:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	89 f8                	mov    %edi,%eax
  800c0e:	eb 03                	jmp    800c13 <vprintfmt+0x52a>
  800c10:	83 e8 01             	sub    $0x1,%eax
  800c13:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c17:	75 f7                	jne    800c10 <vprintfmt+0x527>
  800c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c1c:	e9 90 fe ff ff       	jmp    800ab1 <vprintfmt+0x3c8>
}
  800c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 18             	sub    $0x18,%esp
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c38:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c3c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c46:	85 c0                	test   %eax,%eax
  800c48:	74 26                	je     800c70 <vsnprintf+0x47>
  800c4a:	85 d2                	test   %edx,%edx
  800c4c:	7e 22                	jle    800c70 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c4e:	ff 75 14             	pushl  0x14(%ebp)
  800c51:	ff 75 10             	pushl  0x10(%ebp)
  800c54:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c57:	50                   	push   %eax
  800c58:	68 af 06 80 00       	push   $0x8006af
  800c5d:	e8 87 fa ff ff       	call   8006e9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c65:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    
		return -E_INVAL;
  800c70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c75:	eb f7                	jmp    800c6e <vsnprintf+0x45>

00800c77 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c80:	50                   	push   %eax
  800c81:	ff 75 10             	pushl  0x10(%ebp)
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 08             	pushl  0x8(%ebp)
  800c8a:	e8 9a ff ff ff       	call   800c29 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ca0:	74 05                	je     800ca7 <strlen+0x16>
		n++;
  800ca2:	83 c0 01             	add    $0x1,%eax
  800ca5:	eb f5                	jmp    800c9c <strlen+0xb>
	return n;
}
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb7:	39 c2                	cmp    %eax,%edx
  800cb9:	74 0d                	je     800cc8 <strnlen+0x1f>
  800cbb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800cbf:	74 05                	je     800cc6 <strnlen+0x1d>
		n++;
  800cc1:	83 c2 01             	add    $0x1,%edx
  800cc4:	eb f1                	jmp    800cb7 <strnlen+0xe>
  800cc6:	89 d0                	mov    %edx,%eax
	return n;
}
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	53                   	push   %ebx
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cdd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ce0:	83 c2 01             	add    $0x1,%edx
  800ce3:	84 c9                	test   %cl,%cl
  800ce5:	75 f2                	jne    800cd9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ce7:	5b                   	pop    %ebx
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	53                   	push   %ebx
  800cee:	83 ec 10             	sub    $0x10,%esp
  800cf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cf4:	53                   	push   %ebx
  800cf5:	e8 97 ff ff ff       	call   800c91 <strlen>
  800cfa:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	01 d8                	add    %ebx,%eax
  800d02:	50                   	push   %eax
  800d03:	e8 c2 ff ff ff       	call   800cca <strcpy>
	return dst;
}
  800d08:	89 d8                	mov    %ebx,%eax
  800d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d0d:	c9                   	leave  
  800d0e:	c3                   	ret    

00800d0f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	89 c6                	mov    %eax,%esi
  800d1c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d1f:	89 c2                	mov    %eax,%edx
  800d21:	39 f2                	cmp    %esi,%edx
  800d23:	74 11                	je     800d36 <strncpy+0x27>
		*dst++ = *src;
  800d25:	83 c2 01             	add    $0x1,%edx
  800d28:	0f b6 19             	movzbl (%ecx),%ebx
  800d2b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d2e:	80 fb 01             	cmp    $0x1,%bl
  800d31:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d34:	eb eb                	jmp    800d21 <strncpy+0x12>
	}
	return ret;
}
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	8b 75 08             	mov    0x8(%ebp),%esi
  800d42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d45:	8b 55 10             	mov    0x10(%ebp),%edx
  800d48:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d4a:	85 d2                	test   %edx,%edx
  800d4c:	74 21                	je     800d6f <strlcpy+0x35>
  800d4e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d52:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d54:	39 c2                	cmp    %eax,%edx
  800d56:	74 14                	je     800d6c <strlcpy+0x32>
  800d58:	0f b6 19             	movzbl (%ecx),%ebx
  800d5b:	84 db                	test   %bl,%bl
  800d5d:	74 0b                	je     800d6a <strlcpy+0x30>
			*dst++ = *src++;
  800d5f:	83 c1 01             	add    $0x1,%ecx
  800d62:	83 c2 01             	add    $0x1,%edx
  800d65:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d68:	eb ea                	jmp    800d54 <strlcpy+0x1a>
  800d6a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d6c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6f:	29 f0                	sub    %esi,%eax
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d7e:	0f b6 01             	movzbl (%ecx),%eax
  800d81:	84 c0                	test   %al,%al
  800d83:	74 0c                	je     800d91 <strcmp+0x1c>
  800d85:	3a 02                	cmp    (%edx),%al
  800d87:	75 08                	jne    800d91 <strcmp+0x1c>
		p++, q++;
  800d89:	83 c1 01             	add    $0x1,%ecx
  800d8c:	83 c2 01             	add    $0x1,%edx
  800d8f:	eb ed                	jmp    800d7e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d91:	0f b6 c0             	movzbl %al,%eax
  800d94:	0f b6 12             	movzbl (%edx),%edx
  800d97:	29 d0                	sub    %edx,%eax
}
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	53                   	push   %ebx
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da5:	89 c3                	mov    %eax,%ebx
  800da7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800daa:	eb 06                	jmp    800db2 <strncmp+0x17>
		n--, p++, q++;
  800dac:	83 c0 01             	add    $0x1,%eax
  800daf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800db2:	39 d8                	cmp    %ebx,%eax
  800db4:	74 16                	je     800dcc <strncmp+0x31>
  800db6:	0f b6 08             	movzbl (%eax),%ecx
  800db9:	84 c9                	test   %cl,%cl
  800dbb:	74 04                	je     800dc1 <strncmp+0x26>
  800dbd:	3a 0a                	cmp    (%edx),%cl
  800dbf:	74 eb                	je     800dac <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc1:	0f b6 00             	movzbl (%eax),%eax
  800dc4:	0f b6 12             	movzbl (%edx),%edx
  800dc7:	29 d0                	sub    %edx,%eax
}
  800dc9:	5b                   	pop    %ebx
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
		return 0;
  800dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd1:	eb f6                	jmp    800dc9 <strncmp+0x2e>

00800dd3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ddd:	0f b6 10             	movzbl (%eax),%edx
  800de0:	84 d2                	test   %dl,%dl
  800de2:	74 09                	je     800ded <strchr+0x1a>
		if (*s == c)
  800de4:	38 ca                	cmp    %cl,%dl
  800de6:	74 0a                	je     800df2 <strchr+0x1f>
	for (; *s; s++)
  800de8:	83 c0 01             	add    $0x1,%eax
  800deb:	eb f0                	jmp    800ddd <strchr+0xa>
			return (char *) s;
	return 0;
  800ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dfe:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e01:	38 ca                	cmp    %cl,%dl
  800e03:	74 09                	je     800e0e <strfind+0x1a>
  800e05:	84 d2                	test   %dl,%dl
  800e07:	74 05                	je     800e0e <strfind+0x1a>
	for (; *s; s++)
  800e09:	83 c0 01             	add    $0x1,%eax
  800e0c:	eb f0                	jmp    800dfe <strfind+0xa>
			break;
	return (char *) s;
}
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e19:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e1c:	85 c9                	test   %ecx,%ecx
  800e1e:	74 31                	je     800e51 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e20:	89 f8                	mov    %edi,%eax
  800e22:	09 c8                	or     %ecx,%eax
  800e24:	a8 03                	test   $0x3,%al
  800e26:	75 23                	jne    800e4b <memset+0x3b>
		c &= 0xFF;
  800e28:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e2c:	89 d3                	mov    %edx,%ebx
  800e2e:	c1 e3 08             	shl    $0x8,%ebx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	c1 e0 18             	shl    $0x18,%eax
  800e36:	89 d6                	mov    %edx,%esi
  800e38:	c1 e6 10             	shl    $0x10,%esi
  800e3b:	09 f0                	or     %esi,%eax
  800e3d:	09 c2                	or     %eax,%edx
  800e3f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e41:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	fc                   	cld    
  800e47:	f3 ab                	rep stos %eax,%es:(%edi)
  800e49:	eb 06                	jmp    800e51 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	fc                   	cld    
  800e4f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e51:	89 f8                	mov    %edi,%eax
  800e53:	5b                   	pop    %ebx
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e66:	39 c6                	cmp    %eax,%esi
  800e68:	73 32                	jae    800e9c <memmove+0x44>
  800e6a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e6d:	39 c2                	cmp    %eax,%edx
  800e6f:	76 2b                	jbe    800e9c <memmove+0x44>
		s += n;
		d += n;
  800e71:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e74:	89 fe                	mov    %edi,%esi
  800e76:	09 ce                	or     %ecx,%esi
  800e78:	09 d6                	or     %edx,%esi
  800e7a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e80:	75 0e                	jne    800e90 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e82:	83 ef 04             	sub    $0x4,%edi
  800e85:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e8b:	fd                   	std    
  800e8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e8e:	eb 09                	jmp    800e99 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e90:	83 ef 01             	sub    $0x1,%edi
  800e93:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e96:	fd                   	std    
  800e97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e99:	fc                   	cld    
  800e9a:	eb 1a                	jmp    800eb6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e9c:	89 c2                	mov    %eax,%edx
  800e9e:	09 ca                	or     %ecx,%edx
  800ea0:	09 f2                	or     %esi,%edx
  800ea2:	f6 c2 03             	test   $0x3,%dl
  800ea5:	75 0a                	jne    800eb1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ea7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800eaa:	89 c7                	mov    %eax,%edi
  800eac:	fc                   	cld    
  800ead:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800eaf:	eb 05                	jmp    800eb6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800eb1:	89 c7                	mov    %eax,%edi
  800eb3:	fc                   	cld    
  800eb4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    

00800eba <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ec0:	ff 75 10             	pushl  0x10(%ebp)
  800ec3:	ff 75 0c             	pushl  0xc(%ebp)
  800ec6:	ff 75 08             	pushl  0x8(%ebp)
  800ec9:	e8 8a ff ff ff       	call   800e58 <memmove>
}
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edb:	89 c6                	mov    %eax,%esi
  800edd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ee0:	39 f0                	cmp    %esi,%eax
  800ee2:	74 1c                	je     800f00 <memcmp+0x30>
		if (*s1 != *s2)
  800ee4:	0f b6 08             	movzbl (%eax),%ecx
  800ee7:	0f b6 1a             	movzbl (%edx),%ebx
  800eea:	38 d9                	cmp    %bl,%cl
  800eec:	75 08                	jne    800ef6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800eee:	83 c0 01             	add    $0x1,%eax
  800ef1:	83 c2 01             	add    $0x1,%edx
  800ef4:	eb ea                	jmp    800ee0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ef6:	0f b6 c1             	movzbl %cl,%eax
  800ef9:	0f b6 db             	movzbl %bl,%ebx
  800efc:	29 d8                	sub    %ebx,%eax
  800efe:	eb 05                	jmp    800f05 <memcmp+0x35>
	}

	return 0;
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f12:	89 c2                	mov    %eax,%edx
  800f14:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f17:	39 d0                	cmp    %edx,%eax
  800f19:	73 09                	jae    800f24 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f1b:	38 08                	cmp    %cl,(%eax)
  800f1d:	74 05                	je     800f24 <memfind+0x1b>
	for (; s < ends; s++)
  800f1f:	83 c0 01             	add    $0x1,%eax
  800f22:	eb f3                	jmp    800f17 <memfind+0xe>
			break;
	return (void *) s;
}
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	57                   	push   %edi
  800f2a:	56                   	push   %esi
  800f2b:	53                   	push   %ebx
  800f2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f32:	eb 03                	jmp    800f37 <strtol+0x11>
		s++;
  800f34:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f37:	0f b6 01             	movzbl (%ecx),%eax
  800f3a:	3c 20                	cmp    $0x20,%al
  800f3c:	74 f6                	je     800f34 <strtol+0xe>
  800f3e:	3c 09                	cmp    $0x9,%al
  800f40:	74 f2                	je     800f34 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f42:	3c 2b                	cmp    $0x2b,%al
  800f44:	74 2a                	je     800f70 <strtol+0x4a>
	int neg = 0;
  800f46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f4b:	3c 2d                	cmp    $0x2d,%al
  800f4d:	74 2b                	je     800f7a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f55:	75 0f                	jne    800f66 <strtol+0x40>
  800f57:	80 39 30             	cmpb   $0x30,(%ecx)
  800f5a:	74 28                	je     800f84 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f5c:	85 db                	test   %ebx,%ebx
  800f5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f63:	0f 44 d8             	cmove  %eax,%ebx
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f6e:	eb 50                	jmp    800fc0 <strtol+0x9a>
		s++;
  800f70:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f73:	bf 00 00 00 00       	mov    $0x0,%edi
  800f78:	eb d5                	jmp    800f4f <strtol+0x29>
		s++, neg = 1;
  800f7a:	83 c1 01             	add    $0x1,%ecx
  800f7d:	bf 01 00 00 00       	mov    $0x1,%edi
  800f82:	eb cb                	jmp    800f4f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f84:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f88:	74 0e                	je     800f98 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f8a:	85 db                	test   %ebx,%ebx
  800f8c:	75 d8                	jne    800f66 <strtol+0x40>
		s++, base = 8;
  800f8e:	83 c1 01             	add    $0x1,%ecx
  800f91:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f96:	eb ce                	jmp    800f66 <strtol+0x40>
		s += 2, base = 16;
  800f98:	83 c1 02             	add    $0x2,%ecx
  800f9b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fa0:	eb c4                	jmp    800f66 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800fa2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fa5:	89 f3                	mov    %esi,%ebx
  800fa7:	80 fb 19             	cmp    $0x19,%bl
  800faa:	77 29                	ja     800fd5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800fac:	0f be d2             	movsbl %dl,%edx
  800faf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800fb2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800fb5:	7d 30                	jge    800fe7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800fb7:	83 c1 01             	add    $0x1,%ecx
  800fba:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fbe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fc0:	0f b6 11             	movzbl (%ecx),%edx
  800fc3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800fc6:	89 f3                	mov    %esi,%ebx
  800fc8:	80 fb 09             	cmp    $0x9,%bl
  800fcb:	77 d5                	ja     800fa2 <strtol+0x7c>
			dig = *s - '0';
  800fcd:	0f be d2             	movsbl %dl,%edx
  800fd0:	83 ea 30             	sub    $0x30,%edx
  800fd3:	eb dd                	jmp    800fb2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800fd8:	89 f3                	mov    %esi,%ebx
  800fda:	80 fb 19             	cmp    $0x19,%bl
  800fdd:	77 08                	ja     800fe7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800fdf:	0f be d2             	movsbl %dl,%edx
  800fe2:	83 ea 37             	sub    $0x37,%edx
  800fe5:	eb cb                	jmp    800fb2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800fe7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800feb:	74 05                	je     800ff2 <strtol+0xcc>
		*endptr = (char *) s;
  800fed:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ff0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ff2:	89 c2                	mov    %eax,%edx
  800ff4:	f7 da                	neg    %edx
  800ff6:	85 ff                	test   %edi,%edi
  800ff8:	0f 45 c2             	cmovne %edx,%eax
}
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
	asm volatile("int %1\n"
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
  80100b:	8b 55 08             	mov    0x8(%ebp),%edx
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801011:	89 c3                	mov    %eax,%ebx
  801013:	89 c7                	mov    %eax,%edi
  801015:	89 c6                	mov    %eax,%esi
  801017:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <sys_cgetc>:

int
sys_cgetc(void)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	asm volatile("int %1\n"
  801024:	ba 00 00 00 00       	mov    $0x0,%edx
  801029:	b8 01 00 00 00       	mov    $0x1,%eax
  80102e:	89 d1                	mov    %edx,%ecx
  801030:	89 d3                	mov    %edx,%ebx
  801032:	89 d7                	mov    %edx,%edi
  801034:	89 d6                	mov    %edx,%esi
  801036:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
  801043:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801046:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	b8 03 00 00 00       	mov    $0x3,%eax
  801053:	89 cb                	mov    %ecx,%ebx
  801055:	89 cf                	mov    %ecx,%edi
  801057:	89 ce                	mov    %ecx,%esi
  801059:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105b:	85 c0                	test   %eax,%eax
  80105d:	7f 08                	jg     801067 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80105f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801062:	5b                   	pop    %ebx
  801063:	5e                   	pop    %esi
  801064:	5f                   	pop    %edi
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801067:	83 ec 0c             	sub    $0xc,%esp
  80106a:	50                   	push   %eax
  80106b:	6a 03                	push   $0x3
  80106d:	68 e0 30 80 00       	push   $0x8030e0
  801072:	6a 33                	push   $0x33
  801074:	68 fd 30 80 00       	push   $0x8030fd
  801079:	e8 63 f4 ff ff       	call   8004e1 <_panic>

0080107e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
	asm volatile("int %1\n"
  801084:	ba 00 00 00 00       	mov    $0x0,%edx
  801089:	b8 02 00 00 00       	mov    $0x2,%eax
  80108e:	89 d1                	mov    %edx,%ecx
  801090:	89 d3                	mov    %edx,%ebx
  801092:	89 d7                	mov    %edx,%edi
  801094:	89 d6                	mov    %edx,%esi
  801096:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_yield>:

void
sys_yield(void)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010ad:	89 d1                	mov    %edx,%ecx
  8010af:	89 d3                	mov    %edx,%ebx
  8010b1:	89 d7                	mov    %edx,%edi
  8010b3:	89 d6                	mov    %edx,%esi
  8010b5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010b7:	5b                   	pop    %ebx
  8010b8:	5e                   	pop    %esi
  8010b9:	5f                   	pop    %edi
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	57                   	push   %edi
  8010c0:	56                   	push   %esi
  8010c1:	53                   	push   %ebx
  8010c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c5:	be 00 00 00 00       	mov    $0x0,%esi
  8010ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	b8 04 00 00 00       	mov    $0x4,%eax
  8010d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010d8:	89 f7                	mov    %esi,%edi
  8010da:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	7f 08                	jg     8010e8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e3:	5b                   	pop    %ebx
  8010e4:	5e                   	pop    %esi
  8010e5:	5f                   	pop    %edi
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e8:	83 ec 0c             	sub    $0xc,%esp
  8010eb:	50                   	push   %eax
  8010ec:	6a 04                	push   $0x4
  8010ee:	68 e0 30 80 00       	push   $0x8030e0
  8010f3:	6a 33                	push   $0x33
  8010f5:	68 fd 30 80 00       	push   $0x8030fd
  8010fa:	e8 e2 f3 ff ff       	call   8004e1 <_panic>

008010ff <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	57                   	push   %edi
  801103:	56                   	push   %esi
  801104:	53                   	push   %ebx
  801105:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801108:	8b 55 08             	mov    0x8(%ebp),%edx
  80110b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110e:	b8 05 00 00 00       	mov    $0x5,%eax
  801113:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801116:	8b 7d 14             	mov    0x14(%ebp),%edi
  801119:	8b 75 18             	mov    0x18(%ebp),%esi
  80111c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80111e:	85 c0                	test   %eax,%eax
  801120:	7f 08                	jg     80112a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801122:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80112a:	83 ec 0c             	sub    $0xc,%esp
  80112d:	50                   	push   %eax
  80112e:	6a 05                	push   $0x5
  801130:	68 e0 30 80 00       	push   $0x8030e0
  801135:	6a 33                	push   $0x33
  801137:	68 fd 30 80 00       	push   $0x8030fd
  80113c:	e8 a0 f3 ff ff       	call   8004e1 <_panic>

00801141 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	57                   	push   %edi
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
  801147:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80114a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114f:	8b 55 08             	mov    0x8(%ebp),%edx
  801152:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801155:	b8 06 00 00 00       	mov    $0x6,%eax
  80115a:	89 df                	mov    %ebx,%edi
  80115c:	89 de                	mov    %ebx,%esi
  80115e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801160:	85 c0                	test   %eax,%eax
  801162:	7f 08                	jg     80116c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5f                   	pop    %edi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	50                   	push   %eax
  801170:	6a 06                	push   $0x6
  801172:	68 e0 30 80 00       	push   $0x8030e0
  801177:	6a 33                	push   $0x33
  801179:	68 fd 30 80 00       	push   $0x8030fd
  80117e:	e8 5e f3 ff ff       	call   8004e1 <_panic>

00801183 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	57                   	push   %edi
  801187:	56                   	push   %esi
  801188:	53                   	push   %ebx
  801189:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80118c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801191:	8b 55 08             	mov    0x8(%ebp),%edx
  801194:	b8 0b 00 00 00       	mov    $0xb,%eax
  801199:	89 cb                	mov    %ecx,%ebx
  80119b:	89 cf                	mov    %ecx,%edi
  80119d:	89 ce                	mov    %ecx,%esi
  80119f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	7f 08                	jg     8011ad <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  8011a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ad:	83 ec 0c             	sub    $0xc,%esp
  8011b0:	50                   	push   %eax
  8011b1:	6a 0b                	push   $0xb
  8011b3:	68 e0 30 80 00       	push   $0x8030e0
  8011b8:	6a 33                	push   $0x33
  8011ba:	68 fd 30 80 00       	push   $0x8030fd
  8011bf:	e8 1d f3 ff ff       	call   8004e1 <_panic>

008011c4 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	57                   	push   %edi
  8011c8:	56                   	push   %esi
  8011c9:	53                   	push   %ebx
  8011ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8011dd:	89 df                	mov    %ebx,%edi
  8011df:	89 de                	mov    %ebx,%esi
  8011e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	7f 08                	jg     8011ef <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ea:	5b                   	pop    %ebx
  8011eb:	5e                   	pop    %esi
  8011ec:	5f                   	pop    %edi
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	50                   	push   %eax
  8011f3:	6a 08                	push   $0x8
  8011f5:	68 e0 30 80 00       	push   $0x8030e0
  8011fa:	6a 33                	push   $0x33
  8011fc:	68 fd 30 80 00       	push   $0x8030fd
  801201:	e8 db f2 ff ff       	call   8004e1 <_panic>

00801206 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	57                   	push   %edi
  80120a:	56                   	push   %esi
  80120b:	53                   	push   %ebx
  80120c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80120f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801214:	8b 55 08             	mov    0x8(%ebp),%edx
  801217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121a:	b8 09 00 00 00       	mov    $0x9,%eax
  80121f:	89 df                	mov    %ebx,%edi
  801221:	89 de                	mov    %ebx,%esi
  801223:	cd 30                	int    $0x30
	if(check && ret > 0)
  801225:	85 c0                	test   %eax,%eax
  801227:	7f 08                	jg     801231 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122c:	5b                   	pop    %ebx
  80122d:	5e                   	pop    %esi
  80122e:	5f                   	pop    %edi
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	50                   	push   %eax
  801235:	6a 09                	push   $0x9
  801237:	68 e0 30 80 00       	push   $0x8030e0
  80123c:	6a 33                	push   $0x33
  80123e:	68 fd 30 80 00       	push   $0x8030fd
  801243:	e8 99 f2 ff ff       	call   8004e1 <_panic>

00801248 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	57                   	push   %edi
  80124c:	56                   	push   %esi
  80124d:	53                   	push   %ebx
  80124e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801251:	bb 00 00 00 00       	mov    $0x0,%ebx
  801256:	8b 55 08             	mov    0x8(%ebp),%edx
  801259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801261:	89 df                	mov    %ebx,%edi
  801263:	89 de                	mov    %ebx,%esi
  801265:	cd 30                	int    $0x30
	if(check && ret > 0)
  801267:	85 c0                	test   %eax,%eax
  801269:	7f 08                	jg     801273 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80126b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126e:	5b                   	pop    %ebx
  80126f:	5e                   	pop    %esi
  801270:	5f                   	pop    %edi
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801273:	83 ec 0c             	sub    $0xc,%esp
  801276:	50                   	push   %eax
  801277:	6a 0a                	push   $0xa
  801279:	68 e0 30 80 00       	push   $0x8030e0
  80127e:	6a 33                	push   $0x33
  801280:	68 fd 30 80 00       	push   $0x8030fd
  801285:	e8 57 f2 ff ff       	call   8004e1 <_panic>

0080128a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	57                   	push   %edi
  80128e:	56                   	push   %esi
  80128f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801290:	8b 55 08             	mov    0x8(%ebp),%edx
  801293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801296:	b8 0d 00 00 00       	mov    $0xd,%eax
  80129b:	be 00 00 00 00       	mov    $0x0,%esi
  8012a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012a3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012a6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012a8:	5b                   	pop    %ebx
  8012a9:	5e                   	pop    %esi
  8012aa:	5f                   	pop    %edi
  8012ab:	5d                   	pop    %ebp
  8012ac:	c3                   	ret    

008012ad <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	57                   	push   %edi
  8012b1:	56                   	push   %esi
  8012b2:	53                   	push   %ebx
  8012b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012be:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012c3:	89 cb                	mov    %ecx,%ebx
  8012c5:	89 cf                	mov    %ecx,%edi
  8012c7:	89 ce                	mov    %ecx,%esi
  8012c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	7f 08                	jg     8012d7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d7:	83 ec 0c             	sub    $0xc,%esp
  8012da:	50                   	push   %eax
  8012db:	6a 0e                	push   $0xe
  8012dd:	68 e0 30 80 00       	push   $0x8030e0
  8012e2:	6a 33                	push   $0x33
  8012e4:	68 fd 30 80 00       	push   $0x8030fd
  8012e9:	e8 f3 f1 ff ff       	call   8004e1 <_panic>

008012ee <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	57                   	push   %edi
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ff:	b8 0f 00 00 00       	mov    $0xf,%eax
  801304:	89 df                	mov    %ebx,%edi
  801306:	89 de                	mov    %ebx,%esi
  801308:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80130a:	5b                   	pop    %ebx
  80130b:	5e                   	pop    %esi
  80130c:	5f                   	pop    %edi
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	57                   	push   %edi
  801313:	56                   	push   %esi
  801314:	53                   	push   %ebx
	asm volatile("int %1\n"
  801315:	b9 00 00 00 00       	mov    $0x0,%ecx
  80131a:	8b 55 08             	mov    0x8(%ebp),%edx
  80131d:	b8 10 00 00 00       	mov    $0x10,%eax
  801322:	89 cb                	mov    %ecx,%ebx
  801324:	89 cf                	mov    %ecx,%edi
  801326:	89 ce                	mov    %ecx,%esi
  801328:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80132a:	5b                   	pop    %ebx
  80132b:	5e                   	pop    %esi
  80132c:	5f                   	pop    %edi
  80132d:	5d                   	pop    %ebp
  80132e:	c3                   	ret    

0080132f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	53                   	push   %ebx
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801339:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  80133b:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80133f:	0f 84 90 00 00 00    	je     8013d5 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  801345:	89 d8                	mov    %ebx,%eax
  801347:	c1 e8 16             	shr    $0x16,%eax
  80134a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801351:	a8 01                	test   $0x1,%al
  801353:	0f 84 90 00 00 00    	je     8013e9 <pgfault+0xba>
  801359:	89 d8                	mov    %ebx,%eax
  80135b:	c1 e8 0c             	shr    $0xc,%eax
  80135e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801365:	a9 01 08 00 00       	test   $0x801,%eax
  80136a:	74 7d                	je     8013e9 <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	6a 07                	push   $0x7
  801371:	68 00 f0 7f 00       	push   $0x7ff000
  801376:	6a 00                	push   $0x0
  801378:	e8 3f fd ff ff       	call   8010bc <sys_page_alloc>
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	78 79                	js     8013fd <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  801384:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  80138a:	83 ec 04             	sub    $0x4,%esp
  80138d:	68 00 10 00 00       	push   $0x1000
  801392:	53                   	push   %ebx
  801393:	68 00 f0 7f 00       	push   $0x7ff000
  801398:	e8 bb fa ff ff       	call   800e58 <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  80139d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013a4:	53                   	push   %ebx
  8013a5:	6a 00                	push   $0x0
  8013a7:	68 00 f0 7f 00       	push   $0x7ff000
  8013ac:	6a 00                	push   $0x0
  8013ae:	e8 4c fd ff ff       	call   8010ff <sys_page_map>
  8013b3:	83 c4 20             	add    $0x20,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 55                	js     80140f <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	68 00 f0 7f 00       	push   $0x7ff000
  8013c2:	6a 00                	push   $0x0
  8013c4:	e8 78 fd ff ff       	call   801141 <sys_page_unmap>
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 51                	js     801421 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  8013d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	68 0c 31 80 00       	push   $0x80310c
  8013dd:	6a 21                	push   $0x21
  8013df:	68 94 31 80 00       	push   $0x803194
  8013e4:	e8 f8 f0 ff ff       	call   8004e1 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	68 38 31 80 00       	push   $0x803138
  8013f1:	6a 24                	push   $0x24
  8013f3:	68 94 31 80 00       	push   $0x803194
  8013f8:	e8 e4 f0 ff ff       	call   8004e1 <_panic>
		panic("sys_page_alloc: %e\n", r);
  8013fd:	50                   	push   %eax
  8013fe:	68 9f 31 80 00       	push   $0x80319f
  801403:	6a 2e                	push   $0x2e
  801405:	68 94 31 80 00       	push   $0x803194
  80140a:	e8 d2 f0 ff ff       	call   8004e1 <_panic>
		panic("sys_page_map: %e\n", r);
  80140f:	50                   	push   %eax
  801410:	68 b3 31 80 00       	push   $0x8031b3
  801415:	6a 34                	push   $0x34
  801417:	68 94 31 80 00       	push   $0x803194
  80141c:	e8 c0 f0 ff ff       	call   8004e1 <_panic>
		panic("sys_page_unmap: %e\n", r);
  801421:	50                   	push   %eax
  801422:	68 c5 31 80 00       	push   $0x8031c5
  801427:	6a 37                	push   $0x37
  801429:	68 94 31 80 00       	push   $0x803194
  80142e:	e8 ae f0 ff ff       	call   8004e1 <_panic>

00801433 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	57                   	push   %edi
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
  801439:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  80143c:	68 2f 13 80 00       	push   $0x80132f
  801441:	e8 92 13 00 00       	call   8027d8 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801446:	b8 07 00 00 00       	mov    $0x7,%eax
  80144b:	cd 30                	int    $0x30
  80144d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	78 30                	js     801487 <fork+0x54>
  801457:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801459:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80145e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801462:	0f 85 a5 00 00 00    	jne    80150d <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  801468:	e8 11 fc ff ff       	call   80107e <sys_getenvid>
  80146d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801472:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  801475:	c1 e0 04             	shl    $0x4,%eax
  801478:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80147d:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801482:	e9 75 01 00 00       	jmp    8015fc <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  801487:	50                   	push   %eax
  801488:	68 d9 31 80 00       	push   $0x8031d9
  80148d:	68 83 00 00 00       	push   $0x83
  801492:	68 94 31 80 00       	push   $0x803194
  801497:	e8 45 f0 ff ff       	call   8004e1 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  80149c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014a3:	83 ec 0c             	sub    $0xc,%esp
  8014a6:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ab:	50                   	push   %eax
  8014ac:	56                   	push   %esi
  8014ad:	57                   	push   %edi
  8014ae:	56                   	push   %esi
  8014af:	6a 00                	push   $0x0
  8014b1:	e8 49 fc ff ff       	call   8010ff <sys_page_map>
  8014b6:	83 c4 20             	add    $0x20,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	79 3e                	jns    8014fb <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  8014bd:	50                   	push   %eax
  8014be:	68 b3 31 80 00       	push   $0x8031b3
  8014c3:	6a 50                	push   $0x50
  8014c5:	68 94 31 80 00       	push   $0x803194
  8014ca:	e8 12 f0 ff ff       	call   8004e1 <_panic>
			panic("sys_page_map: %e\n", r);
  8014cf:	50                   	push   %eax
  8014d0:	68 b3 31 80 00       	push   $0x8031b3
  8014d5:	6a 54                	push   $0x54
  8014d7:	68 94 31 80 00       	push   $0x803194
  8014dc:	e8 00 f0 ff ff       	call   8004e1 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8014e1:	83 ec 0c             	sub    $0xc,%esp
  8014e4:	6a 05                	push   $0x5
  8014e6:	56                   	push   %esi
  8014e7:	57                   	push   %edi
  8014e8:	56                   	push   %esi
  8014e9:	6a 00                	push   $0x0
  8014eb:	e8 0f fc ff ff       	call   8010ff <sys_page_map>
  8014f0:	83 c4 20             	add    $0x20,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 88 ab 00 00 00    	js     8015a6 <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  8014fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801501:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801507:	0f 84 ab 00 00 00    	je     8015b8 <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  80150d:	89 d8                	mov    %ebx,%eax
  80150f:	c1 e8 16             	shr    $0x16,%eax
  801512:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801519:	a8 01                	test   $0x1,%al
  80151b:	74 de                	je     8014fb <fork+0xc8>
  80151d:	89 d8                	mov    %ebx,%eax
  80151f:	c1 e8 0c             	shr    $0xc,%eax
  801522:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801529:	f6 c2 01             	test   $0x1,%dl
  80152c:	74 cd                	je     8014fb <fork+0xc8>
  80152e:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801534:	74 c5                	je     8014fb <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  801536:	89 c6                	mov    %eax,%esi
  801538:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  80153b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801542:	f6 c6 04             	test   $0x4,%dh
  801545:	0f 85 51 ff ff ff    	jne    80149c <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  80154b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801552:	a9 02 08 00 00       	test   $0x802,%eax
  801557:	74 88                	je     8014e1 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801559:	83 ec 0c             	sub    $0xc,%esp
  80155c:	68 05 08 00 00       	push   $0x805
  801561:	56                   	push   %esi
  801562:	57                   	push   %edi
  801563:	56                   	push   %esi
  801564:	6a 00                	push   $0x0
  801566:	e8 94 fb ff ff       	call   8010ff <sys_page_map>
  80156b:	83 c4 20             	add    $0x20,%esp
  80156e:	85 c0                	test   %eax,%eax
  801570:	0f 88 59 ff ff ff    	js     8014cf <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801576:	83 ec 0c             	sub    $0xc,%esp
  801579:	68 05 08 00 00       	push   $0x805
  80157e:	56                   	push   %esi
  80157f:	6a 00                	push   $0x0
  801581:	56                   	push   %esi
  801582:	6a 00                	push   $0x0
  801584:	e8 76 fb ff ff       	call   8010ff <sys_page_map>
  801589:	83 c4 20             	add    $0x20,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	0f 89 67 ff ff ff    	jns    8014fb <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801594:	50                   	push   %eax
  801595:	68 b3 31 80 00       	push   $0x8031b3
  80159a:	6a 56                	push   $0x56
  80159c:	68 94 31 80 00       	push   $0x803194
  8015a1:	e8 3b ef ff ff       	call   8004e1 <_panic>
			panic("sys_page_map: %e\n", r);
  8015a6:	50                   	push   %eax
  8015a7:	68 b3 31 80 00       	push   $0x8031b3
  8015ac:	6a 5a                	push   $0x5a
  8015ae:	68 94 31 80 00       	push   $0x803194
  8015b3:	e8 29 ef ff ff       	call   8004e1 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	6a 07                	push   $0x7
  8015bd:	68 00 f0 bf ee       	push   $0xeebff000
  8015c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015c5:	e8 f2 fa ff ff       	call   8010bc <sys_page_alloc>
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 36                	js     801607 <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8015d1:	83 ec 08             	sub    $0x8,%esp
  8015d4:	68 43 28 80 00       	push   $0x802843
  8015d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015dc:	e8 67 fc ff ff       	call   801248 <sys_env_set_pgfault_upcall>
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	78 34                	js     80161c <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	6a 02                	push   $0x2
  8015ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f0:	e8 cf fb ff ff       	call   8011c4 <sys_env_set_status>
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 35                	js     801631 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  8015fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801602:	5b                   	pop    %ebx
  801603:	5e                   	pop    %esi
  801604:	5f                   	pop    %edi
  801605:	5d                   	pop    %ebp
  801606:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  801607:	50                   	push   %eax
  801608:	68 9f 31 80 00       	push   $0x80319f
  80160d:	68 95 00 00 00       	push   $0x95
  801612:	68 94 31 80 00       	push   $0x803194
  801617:	e8 c5 ee ff ff       	call   8004e1 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  80161c:	50                   	push   %eax
  80161d:	68 74 31 80 00       	push   $0x803174
  801622:	68 98 00 00 00       	push   $0x98
  801627:	68 94 31 80 00       	push   $0x803194
  80162c:	e8 b0 ee ff ff       	call   8004e1 <_panic>
		panic("sys_env_set_status: %e\n", r);
  801631:	50                   	push   %eax
  801632:	68 e9 31 80 00       	push   $0x8031e9
  801637:	68 9b 00 00 00       	push   $0x9b
  80163c:	68 94 31 80 00       	push   $0x803194
  801641:	e8 9b ee ff ff       	call   8004e1 <_panic>

00801646 <sfork>:

// Challenge!
int
sfork(void)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80164c:	68 01 32 80 00       	push   $0x803201
  801651:	68 a4 00 00 00       	push   $0xa4
  801656:	68 94 31 80 00       	push   $0x803194
  80165b:	e8 81 ee ff ff       	call   8004e1 <_panic>

00801660 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	05 00 00 00 30       	add    $0x30000000,%eax
  80166b:	c1 e8 0c             	shr    $0xc,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80167b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801680:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80168f:	89 c2                	mov    %eax,%edx
  801691:	c1 ea 16             	shr    $0x16,%edx
  801694:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80169b:	f6 c2 01             	test   $0x1,%dl
  80169e:	74 2d                	je     8016cd <fd_alloc+0x46>
  8016a0:	89 c2                	mov    %eax,%edx
  8016a2:	c1 ea 0c             	shr    $0xc,%edx
  8016a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016ac:	f6 c2 01             	test   $0x1,%dl
  8016af:	74 1c                	je     8016cd <fd_alloc+0x46>
  8016b1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016b6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016bb:	75 d2                	jne    80168f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016c6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016cb:	eb 0a                	jmp    8016d7 <fd_alloc+0x50>
			*fd_store = fd;
  8016cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016df:	83 f8 1f             	cmp    $0x1f,%eax
  8016e2:	77 30                	ja     801714 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016e4:	c1 e0 0c             	shl    $0xc,%eax
  8016e7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016ec:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016f2:	f6 c2 01             	test   $0x1,%dl
  8016f5:	74 24                	je     80171b <fd_lookup+0x42>
  8016f7:	89 c2                	mov    %eax,%edx
  8016f9:	c1 ea 0c             	shr    $0xc,%edx
  8016fc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801703:	f6 c2 01             	test   $0x1,%dl
  801706:	74 1a                	je     801722 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801708:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170b:	89 02                	mov    %eax,(%edx)
	return 0;
  80170d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    
		return -E_INVAL;
  801714:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801719:	eb f7                	jmp    801712 <fd_lookup+0x39>
		return -E_INVAL;
  80171b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801720:	eb f0                	jmp    801712 <fd_lookup+0x39>
  801722:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801727:	eb e9                	jmp    801712 <fd_lookup+0x39>

00801729 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801732:	ba 94 32 80 00       	mov    $0x803294,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801737:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80173c:	39 08                	cmp    %ecx,(%eax)
  80173e:	74 33                	je     801773 <dev_lookup+0x4a>
  801740:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801743:	8b 02                	mov    (%edx),%eax
  801745:	85 c0                	test   %eax,%eax
  801747:	75 f3                	jne    80173c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801749:	a1 04 50 80 00       	mov    0x805004,%eax
  80174e:	8b 40 48             	mov    0x48(%eax),%eax
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	51                   	push   %ecx
  801755:	50                   	push   %eax
  801756:	68 18 32 80 00       	push   $0x803218
  80175b:	e8 5c ee ff ff       	call   8005bc <cprintf>
	*dev = 0;
  801760:	8b 45 0c             	mov    0xc(%ebp),%eax
  801763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    
			*dev = devtab[i];
  801773:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801776:	89 01                	mov    %eax,(%ecx)
			return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
  80177d:	eb f2                	jmp    801771 <dev_lookup+0x48>

0080177f <fd_close>:
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	57                   	push   %edi
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
  801785:	83 ec 24             	sub    $0x24,%esp
  801788:	8b 75 08             	mov    0x8(%ebp),%esi
  80178b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80178e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801791:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801792:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801798:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80179b:	50                   	push   %eax
  80179c:	e8 38 ff ff ff       	call   8016d9 <fd_lookup>
  8017a1:	89 c3                	mov    %eax,%ebx
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	78 05                	js     8017af <fd_close+0x30>
	    || fd != fd2)
  8017aa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017ad:	74 16                	je     8017c5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017af:	89 f8                	mov    %edi,%eax
  8017b1:	84 c0                	test   %al,%al
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b8:	0f 44 d8             	cmove  %eax,%ebx
}
  8017bb:	89 d8                	mov    %ebx,%eax
  8017bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c0:	5b                   	pop    %ebx
  8017c1:	5e                   	pop    %esi
  8017c2:	5f                   	pop    %edi
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017c5:	83 ec 08             	sub    $0x8,%esp
  8017c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017cb:	50                   	push   %eax
  8017cc:	ff 36                	pushl  (%esi)
  8017ce:	e8 56 ff ff ff       	call   801729 <dev_lookup>
  8017d3:	89 c3                	mov    %eax,%ebx
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	78 1a                	js     8017f6 <fd_close+0x77>
		if (dev->dev_close)
  8017dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017df:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017e2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	74 0b                	je     8017f6 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	56                   	push   %esi
  8017ef:	ff d0                	call   *%eax
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017f6:	83 ec 08             	sub    $0x8,%esp
  8017f9:	56                   	push   %esi
  8017fa:	6a 00                	push   $0x0
  8017fc:	e8 40 f9 ff ff       	call   801141 <sys_page_unmap>
	return r;
  801801:	83 c4 10             	add    $0x10,%esp
  801804:	eb b5                	jmp    8017bb <fd_close+0x3c>

00801806 <close>:

int
close(int fdnum)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80180c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180f:	50                   	push   %eax
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	e8 c1 fe ff ff       	call   8016d9 <fd_lookup>
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	85 c0                	test   %eax,%eax
  80181d:	79 02                	jns    801821 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    
		return fd_close(fd, 1);
  801821:	83 ec 08             	sub    $0x8,%esp
  801824:	6a 01                	push   $0x1
  801826:	ff 75 f4             	pushl  -0xc(%ebp)
  801829:	e8 51 ff ff ff       	call   80177f <fd_close>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	eb ec                	jmp    80181f <close+0x19>

00801833 <close_all>:

void
close_all(void)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	53                   	push   %ebx
  801837:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80183a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80183f:	83 ec 0c             	sub    $0xc,%esp
  801842:	53                   	push   %ebx
  801843:	e8 be ff ff ff       	call   801806 <close>
	for (i = 0; i < MAXFD; i++)
  801848:	83 c3 01             	add    $0x1,%ebx
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	83 fb 20             	cmp    $0x20,%ebx
  801851:	75 ec                	jne    80183f <close_all+0xc>
}
  801853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	57                   	push   %edi
  80185c:	56                   	push   %esi
  80185d:	53                   	push   %ebx
  80185e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801861:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801864:	50                   	push   %eax
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	e8 6c fe ff ff       	call   8016d9 <fd_lookup>
  80186d:	89 c3                	mov    %eax,%ebx
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	85 c0                	test   %eax,%eax
  801874:	0f 88 81 00 00 00    	js     8018fb <dup+0xa3>
		return r;
	close(newfdnum);
  80187a:	83 ec 0c             	sub    $0xc,%esp
  80187d:	ff 75 0c             	pushl  0xc(%ebp)
  801880:	e8 81 ff ff ff       	call   801806 <close>

	newfd = INDEX2FD(newfdnum);
  801885:	8b 75 0c             	mov    0xc(%ebp),%esi
  801888:	c1 e6 0c             	shl    $0xc,%esi
  80188b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801891:	83 c4 04             	add    $0x4,%esp
  801894:	ff 75 e4             	pushl  -0x1c(%ebp)
  801897:	e8 d4 fd ff ff       	call   801670 <fd2data>
  80189c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80189e:	89 34 24             	mov    %esi,(%esp)
  8018a1:	e8 ca fd ff ff       	call   801670 <fd2data>
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018ab:	89 d8                	mov    %ebx,%eax
  8018ad:	c1 e8 16             	shr    $0x16,%eax
  8018b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018b7:	a8 01                	test   $0x1,%al
  8018b9:	74 11                	je     8018cc <dup+0x74>
  8018bb:	89 d8                	mov    %ebx,%eax
  8018bd:	c1 e8 0c             	shr    $0xc,%eax
  8018c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018c7:	f6 c2 01             	test   $0x1,%dl
  8018ca:	75 39                	jne    801905 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018cf:	89 d0                	mov    %edx,%eax
  8018d1:	c1 e8 0c             	shr    $0xc,%eax
  8018d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018db:	83 ec 0c             	sub    $0xc,%esp
  8018de:	25 07 0e 00 00       	and    $0xe07,%eax
  8018e3:	50                   	push   %eax
  8018e4:	56                   	push   %esi
  8018e5:	6a 00                	push   $0x0
  8018e7:	52                   	push   %edx
  8018e8:	6a 00                	push   $0x0
  8018ea:	e8 10 f8 ff ff       	call   8010ff <sys_page_map>
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	83 c4 20             	add    $0x20,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 31                	js     801929 <dup+0xd1>
		goto err;

	return newfdnum;
  8018f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018fb:	89 d8                	mov    %ebx,%eax
  8018fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801900:	5b                   	pop    %ebx
  801901:	5e                   	pop    %esi
  801902:	5f                   	pop    %edi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801905:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80190c:	83 ec 0c             	sub    $0xc,%esp
  80190f:	25 07 0e 00 00       	and    $0xe07,%eax
  801914:	50                   	push   %eax
  801915:	57                   	push   %edi
  801916:	6a 00                	push   $0x0
  801918:	53                   	push   %ebx
  801919:	6a 00                	push   $0x0
  80191b:	e8 df f7 ff ff       	call   8010ff <sys_page_map>
  801920:	89 c3                	mov    %eax,%ebx
  801922:	83 c4 20             	add    $0x20,%esp
  801925:	85 c0                	test   %eax,%eax
  801927:	79 a3                	jns    8018cc <dup+0x74>
	sys_page_unmap(0, newfd);
  801929:	83 ec 08             	sub    $0x8,%esp
  80192c:	56                   	push   %esi
  80192d:	6a 00                	push   $0x0
  80192f:	e8 0d f8 ff ff       	call   801141 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801934:	83 c4 08             	add    $0x8,%esp
  801937:	57                   	push   %edi
  801938:	6a 00                	push   $0x0
  80193a:	e8 02 f8 ff ff       	call   801141 <sys_page_unmap>
	return r;
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	eb b7                	jmp    8018fb <dup+0xa3>

00801944 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	53                   	push   %ebx
  801948:	83 ec 1c             	sub    $0x1c,%esp
  80194b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80194e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801951:	50                   	push   %eax
  801952:	53                   	push   %ebx
  801953:	e8 81 fd ff ff       	call   8016d9 <fd_lookup>
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	85 c0                	test   %eax,%eax
  80195d:	78 3f                	js     80199e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195f:	83 ec 08             	sub    $0x8,%esp
  801962:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801965:	50                   	push   %eax
  801966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801969:	ff 30                	pushl  (%eax)
  80196b:	e8 b9 fd ff ff       	call   801729 <dev_lookup>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	85 c0                	test   %eax,%eax
  801975:	78 27                	js     80199e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801977:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80197a:	8b 42 08             	mov    0x8(%edx),%eax
  80197d:	83 e0 03             	and    $0x3,%eax
  801980:	83 f8 01             	cmp    $0x1,%eax
  801983:	74 1e                	je     8019a3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801988:	8b 40 08             	mov    0x8(%eax),%eax
  80198b:	85 c0                	test   %eax,%eax
  80198d:	74 35                	je     8019c4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	ff 75 10             	pushl  0x10(%ebp)
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	52                   	push   %edx
  801999:	ff d0                	call   *%eax
  80199b:	83 c4 10             	add    $0x10,%esp
}
  80199e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019a3:	a1 04 50 80 00       	mov    0x805004,%eax
  8019a8:	8b 40 48             	mov    0x48(%eax),%eax
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	53                   	push   %ebx
  8019af:	50                   	push   %eax
  8019b0:	68 59 32 80 00       	push   $0x803259
  8019b5:	e8 02 ec ff ff       	call   8005bc <cprintf>
		return -E_INVAL;
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019c2:	eb da                	jmp    80199e <read+0x5a>
		return -E_NOT_SUPP;
  8019c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c9:	eb d3                	jmp    80199e <read+0x5a>

008019cb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	57                   	push   %edi
  8019cf:	56                   	push   %esi
  8019d0:	53                   	push   %ebx
  8019d1:	83 ec 0c             	sub    $0xc,%esp
  8019d4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019d7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019df:	39 f3                	cmp    %esi,%ebx
  8019e1:	73 23                	jae    801a06 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	89 f0                	mov    %esi,%eax
  8019e8:	29 d8                	sub    %ebx,%eax
  8019ea:	50                   	push   %eax
  8019eb:	89 d8                	mov    %ebx,%eax
  8019ed:	03 45 0c             	add    0xc(%ebp),%eax
  8019f0:	50                   	push   %eax
  8019f1:	57                   	push   %edi
  8019f2:	e8 4d ff ff ff       	call   801944 <read>
		if (m < 0)
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 06                	js     801a04 <readn+0x39>
			return m;
		if (m == 0)
  8019fe:	74 06                	je     801a06 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a00:	01 c3                	add    %eax,%ebx
  801a02:	eb db                	jmp    8019df <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a04:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a06:	89 d8                	mov    %ebx,%eax
  801a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    

00801a10 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	53                   	push   %ebx
  801a14:	83 ec 1c             	sub    $0x1c,%esp
  801a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a1d:	50                   	push   %eax
  801a1e:	53                   	push   %ebx
  801a1f:	e8 b5 fc ff ff       	call   8016d9 <fd_lookup>
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	85 c0                	test   %eax,%eax
  801a29:	78 3a                	js     801a65 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a2b:	83 ec 08             	sub    $0x8,%esp
  801a2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a31:	50                   	push   %eax
  801a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a35:	ff 30                	pushl  (%eax)
  801a37:	e8 ed fc ff ff       	call   801729 <dev_lookup>
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	78 22                	js     801a65 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a46:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a4a:	74 1e                	je     801a6a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4f:	8b 52 0c             	mov    0xc(%edx),%edx
  801a52:	85 d2                	test   %edx,%edx
  801a54:	74 35                	je     801a8b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	ff 75 10             	pushl  0x10(%ebp)
  801a5c:	ff 75 0c             	pushl  0xc(%ebp)
  801a5f:	50                   	push   %eax
  801a60:	ff d2                	call   *%edx
  801a62:	83 c4 10             	add    $0x10,%esp
}
  801a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a6a:	a1 04 50 80 00       	mov    0x805004,%eax
  801a6f:	8b 40 48             	mov    0x48(%eax),%eax
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	53                   	push   %ebx
  801a76:	50                   	push   %eax
  801a77:	68 75 32 80 00       	push   $0x803275
  801a7c:	e8 3b eb ff ff       	call   8005bc <cprintf>
		return -E_INVAL;
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a89:	eb da                	jmp    801a65 <write+0x55>
		return -E_NOT_SUPP;
  801a8b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a90:	eb d3                	jmp    801a65 <write+0x55>

00801a92 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9b:	50                   	push   %eax
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	e8 35 fc ff ff       	call   8016d9 <fd_lookup>
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 0e                	js     801ab9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	53                   	push   %ebx
  801abf:	83 ec 1c             	sub    $0x1c,%esp
  801ac2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ac5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ac8:	50                   	push   %eax
  801ac9:	53                   	push   %ebx
  801aca:	e8 0a fc ff ff       	call   8016d9 <fd_lookup>
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 37                	js     801b0d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ad6:	83 ec 08             	sub    $0x8,%esp
  801ad9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adc:	50                   	push   %eax
  801add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae0:	ff 30                	pushl  (%eax)
  801ae2:	e8 42 fc ff ff       	call   801729 <dev_lookup>
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 1f                	js     801b0d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801af5:	74 1b                	je     801b12 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801afa:	8b 52 18             	mov    0x18(%edx),%edx
  801afd:	85 d2                	test   %edx,%edx
  801aff:	74 32                	je     801b33 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	50                   	push   %eax
  801b08:	ff d2                	call   *%edx
  801b0a:	83 c4 10             	add    $0x10,%esp
}
  801b0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b12:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b17:	8b 40 48             	mov    0x48(%eax),%eax
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	53                   	push   %ebx
  801b1e:	50                   	push   %eax
  801b1f:	68 38 32 80 00       	push   $0x803238
  801b24:	e8 93 ea ff ff       	call   8005bc <cprintf>
		return -E_INVAL;
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b31:	eb da                	jmp    801b0d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b33:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b38:	eb d3                	jmp    801b0d <ftruncate+0x52>

00801b3a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 1c             	sub    $0x1c,%esp
  801b41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b47:	50                   	push   %eax
  801b48:	ff 75 08             	pushl  0x8(%ebp)
  801b4b:	e8 89 fb ff ff       	call   8016d9 <fd_lookup>
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 4b                	js     801ba2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b57:	83 ec 08             	sub    $0x8,%esp
  801b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b61:	ff 30                	pushl  (%eax)
  801b63:	e8 c1 fb ff ff       	call   801729 <dev_lookup>
  801b68:	83 c4 10             	add    $0x10,%esp
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 33                	js     801ba2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b72:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b76:	74 2f                	je     801ba7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b78:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b7b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b82:	00 00 00 
	stat->st_isdir = 0;
  801b85:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b8c:	00 00 00 
	stat->st_dev = dev;
  801b8f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	53                   	push   %ebx
  801b99:	ff 75 f0             	pushl  -0x10(%ebp)
  801b9c:	ff 50 14             	call   *0x14(%eax)
  801b9f:	83 c4 10             	add    $0x10,%esp
}
  801ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    
		return -E_NOT_SUPP;
  801ba7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bac:	eb f4                	jmp    801ba2 <fstat+0x68>

00801bae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	56                   	push   %esi
  801bb2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bb3:	83 ec 08             	sub    $0x8,%esp
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 08             	pushl  0x8(%ebp)
  801bbb:	e8 e7 01 00 00       	call   801da7 <open>
  801bc0:	89 c3                	mov    %eax,%ebx
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	78 1b                	js     801be4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bc9:	83 ec 08             	sub    $0x8,%esp
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	50                   	push   %eax
  801bd0:	e8 65 ff ff ff       	call   801b3a <fstat>
  801bd5:	89 c6                	mov    %eax,%esi
	close(fd);
  801bd7:	89 1c 24             	mov    %ebx,(%esp)
  801bda:	e8 27 fc ff ff       	call   801806 <close>
	return r;
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	89 f3                	mov    %esi,%ebx
}
  801be4:	89 d8                	mov    %ebx,%eax
  801be6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    

00801bed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	56                   	push   %esi
  801bf1:	53                   	push   %ebx
  801bf2:	89 c6                	mov    %eax,%esi
  801bf4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bf6:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bfd:	74 27                	je     801c26 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bff:	6a 07                	push   $0x7
  801c01:	68 00 60 80 00       	push   $0x806000
  801c06:	56                   	push   %esi
  801c07:	ff 35 00 50 80 00    	pushl  0x805000
  801c0d:	e8 be 0c 00 00       	call   8028d0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c12:	83 c4 0c             	add    $0xc,%esp
  801c15:	6a 00                	push   $0x0
  801c17:	53                   	push   %ebx
  801c18:	6a 00                	push   $0x0
  801c1a:	e8 4a 0c 00 00       	call   802869 <ipc_recv>
}
  801c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c22:	5b                   	pop    %ebx
  801c23:	5e                   	pop    %esi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c26:	83 ec 0c             	sub    $0xc,%esp
  801c29:	6a 01                	push   $0x1
  801c2b:	e8 e9 0c 00 00       	call   802919 <ipc_find_env>
  801c30:	a3 00 50 80 00       	mov    %eax,0x805000
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	eb c5                	jmp    801bff <fsipc+0x12>

00801c3a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	8b 40 0c             	mov    0xc(%eax),%eax
  801c46:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4e:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c53:	ba 00 00 00 00       	mov    $0x0,%edx
  801c58:	b8 02 00 00 00       	mov    $0x2,%eax
  801c5d:	e8 8b ff ff ff       	call   801bed <fsipc>
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <devfile_flush>:
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c70:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c75:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7a:	b8 06 00 00 00       	mov    $0x6,%eax
  801c7f:	e8 69 ff ff ff       	call   801bed <fsipc>
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <devfile_stat>:
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	53                   	push   %ebx
  801c8a:	83 ec 04             	sub    $0x4,%esp
  801c8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	8b 40 0c             	mov    0xc(%eax),%eax
  801c96:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca0:	b8 05 00 00 00       	mov    $0x5,%eax
  801ca5:	e8 43 ff ff ff       	call   801bed <fsipc>
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 2c                	js     801cda <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cae:	83 ec 08             	sub    $0x8,%esp
  801cb1:	68 00 60 80 00       	push   $0x806000
  801cb6:	53                   	push   %ebx
  801cb7:	e8 0e f0 ff ff       	call   800cca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cbc:	a1 80 60 80 00       	mov    0x806080,%eax
  801cc1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cc7:	a1 84 60 80 00       	mov    0x806084,%eax
  801ccc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cd2:	83 c4 10             	add    $0x10,%esp
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <devfile_write>:
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 0c             	sub    $0xc,%esp
  801ce5:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  801ceb:	8b 52 0c             	mov    0xc(%edx),%edx
  801cee:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801cf4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801cf9:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801cfe:	0f 47 c2             	cmova  %edx,%eax
  801d01:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801d06:	50                   	push   %eax
  801d07:	ff 75 0c             	pushl  0xc(%ebp)
  801d0a:	68 08 60 80 00       	push   $0x806008
  801d0f:	e8 44 f1 ff ff       	call   800e58 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801d14:	ba 00 00 00 00       	mov    $0x0,%edx
  801d19:	b8 04 00 00 00       	mov    $0x4,%eax
  801d1e:	e8 ca fe ff ff       	call   801bed <fsipc>
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <devfile_read>:
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	56                   	push   %esi
  801d29:	53                   	push   %ebx
  801d2a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	8b 40 0c             	mov    0xc(%eax),%eax
  801d33:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d38:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d43:	b8 03 00 00 00       	mov    $0x3,%eax
  801d48:	e8 a0 fe ff ff       	call   801bed <fsipc>
  801d4d:	89 c3                	mov    %eax,%ebx
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	78 1f                	js     801d72 <devfile_read+0x4d>
	assert(r <= n);
  801d53:	39 f0                	cmp    %esi,%eax
  801d55:	77 24                	ja     801d7b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d57:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d5c:	7f 33                	jg     801d91 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d5e:	83 ec 04             	sub    $0x4,%esp
  801d61:	50                   	push   %eax
  801d62:	68 00 60 80 00       	push   $0x806000
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	e8 e9 f0 ff ff       	call   800e58 <memmove>
	return r;
  801d6f:	83 c4 10             	add    $0x10,%esp
}
  801d72:	89 d8                	mov    %ebx,%eax
  801d74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d77:	5b                   	pop    %ebx
  801d78:	5e                   	pop    %esi
  801d79:	5d                   	pop    %ebp
  801d7a:	c3                   	ret    
	assert(r <= n);
  801d7b:	68 a4 32 80 00       	push   $0x8032a4
  801d80:	68 ab 32 80 00       	push   $0x8032ab
  801d85:	6a 7c                	push   $0x7c
  801d87:	68 c0 32 80 00       	push   $0x8032c0
  801d8c:	e8 50 e7 ff ff       	call   8004e1 <_panic>
	assert(r <= PGSIZE);
  801d91:	68 cb 32 80 00       	push   $0x8032cb
  801d96:	68 ab 32 80 00       	push   $0x8032ab
  801d9b:	6a 7d                	push   $0x7d
  801d9d:	68 c0 32 80 00       	push   $0x8032c0
  801da2:	e8 3a e7 ff ff       	call   8004e1 <_panic>

00801da7 <open>:
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	56                   	push   %esi
  801dab:	53                   	push   %ebx
  801dac:	83 ec 1c             	sub    $0x1c,%esp
  801daf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801db2:	56                   	push   %esi
  801db3:	e8 d9 ee ff ff       	call   800c91 <strlen>
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dc0:	7f 6c                	jg     801e2e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801dc2:	83 ec 0c             	sub    $0xc,%esp
  801dc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc8:	50                   	push   %eax
  801dc9:	e8 b9 f8 ff ff       	call   801687 <fd_alloc>
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	78 3c                	js     801e13 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dd7:	83 ec 08             	sub    $0x8,%esp
  801dda:	56                   	push   %esi
  801ddb:	68 00 60 80 00       	push   $0x806000
  801de0:	e8 e5 ee ff ff       	call   800cca <strcpy>
	fsipcbuf.open.req_omode = mode;
  801de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de8:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ded:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
  801df5:	e8 f3 fd ff ff       	call   801bed <fsipc>
  801dfa:	89 c3                	mov    %eax,%ebx
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 19                	js     801e1c <open+0x75>
	return fd2num(fd);
  801e03:	83 ec 0c             	sub    $0xc,%esp
  801e06:	ff 75 f4             	pushl  -0xc(%ebp)
  801e09:	e8 52 f8 ff ff       	call   801660 <fd2num>
  801e0e:	89 c3                	mov    %eax,%ebx
  801e10:	83 c4 10             	add    $0x10,%esp
}
  801e13:	89 d8                	mov    %ebx,%eax
  801e15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e18:	5b                   	pop    %ebx
  801e19:	5e                   	pop    %esi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
		fd_close(fd, 0);
  801e1c:	83 ec 08             	sub    $0x8,%esp
  801e1f:	6a 00                	push   $0x0
  801e21:	ff 75 f4             	pushl  -0xc(%ebp)
  801e24:	e8 56 f9 ff ff       	call   80177f <fd_close>
		return r;
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	eb e5                	jmp    801e13 <open+0x6c>
		return -E_BAD_PATH;
  801e2e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e33:	eb de                	jmp    801e13 <open+0x6c>

00801e35 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e40:	b8 08 00 00 00       	mov    $0x8,%eax
  801e45:	e8 a3 fd ff ff       	call   801bed <fsipc>
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	57                   	push   %edi
  801e50:	56                   	push   %esi
  801e51:	53                   	push   %ebx
  801e52:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801e58:	6a 00                	push   $0x0
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	e8 45 ff ff ff       	call   801da7 <open>
  801e62:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	0f 88 ff 04 00 00    	js     802372 <spawn+0x526>
  801e73:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	68 00 02 00 00       	push   $0x200
  801e7d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801e83:	50                   	push   %eax
  801e84:	51                   	push   %ecx
  801e85:	e8 41 fb ff ff       	call   8019cb <readn>
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e92:	75 60                	jne    801ef4 <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  801e94:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801e9b:	45 4c 46 
  801e9e:	75 54                	jne    801ef4 <spawn+0xa8>
  801ea0:	b8 07 00 00 00       	mov    $0x7,%eax
  801ea5:	cd 30                	int    $0x30
  801ea7:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801ead:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	0f 88 ab 04 00 00    	js     802366 <spawn+0x51a>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801ebb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ec0:	8d 34 c0             	lea    (%eax,%eax,8),%esi
  801ec3:	c1 e6 04             	shl    $0x4,%esi
  801ec6:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801ecc:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801ed2:	b9 11 00 00 00       	mov    $0x11,%ecx
  801ed7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801ed9:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801edf:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801eea:	be 00 00 00 00       	mov    $0x0,%esi
  801eef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ef2:	eb 4b                	jmp    801f3f <spawn+0xf3>
		close(fd);
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801efd:	e8 04 f9 ff ff       	call   801806 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f02:	83 c4 0c             	add    $0xc,%esp
  801f05:	68 7f 45 4c 46       	push   $0x464c457f
  801f0a:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801f10:	68 d7 32 80 00       	push   $0x8032d7
  801f15:	e8 a2 e6 ff ff       	call   8005bc <cprintf>
		return -E_NOT_EXEC;
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801f24:	ff ff ff 
  801f27:	e9 46 04 00 00       	jmp    802372 <spawn+0x526>
		string_size += strlen(argv[argc]) + 1;
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	50                   	push   %eax
  801f30:	e8 5c ed ff ff       	call   800c91 <strlen>
  801f35:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801f39:	83 c3 01             	add    $0x1,%ebx
  801f3c:	83 c4 10             	add    $0x10,%esp
  801f3f:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801f46:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	75 df                	jne    801f2c <spawn+0xe0>
  801f4d:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801f53:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801f59:	bf 00 10 40 00       	mov    $0x401000,%edi
  801f5e:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801f60:	89 fa                	mov    %edi,%edx
  801f62:	83 e2 fc             	and    $0xfffffffc,%edx
  801f65:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801f6c:	29 c2                	sub    %eax,%edx
  801f6e:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801f74:	8d 42 f8             	lea    -0x8(%edx),%eax
  801f77:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801f7c:	0f 86 13 04 00 00    	jbe    802395 <spawn+0x549>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	6a 07                	push   $0x7
  801f87:	68 00 00 40 00       	push   $0x400000
  801f8c:	6a 00                	push   $0x0
  801f8e:	e8 29 f1 ff ff       	call   8010bc <sys_page_alloc>
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	85 c0                	test   %eax,%eax
  801f98:	0f 88 fc 03 00 00    	js     80239a <spawn+0x54e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801f9e:	be 00 00 00 00       	mov    $0x0,%esi
  801fa3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801fa9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801fac:	eb 30                	jmp    801fde <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  801fae:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801fb4:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801fba:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801fbd:	83 ec 08             	sub    $0x8,%esp
  801fc0:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801fc3:	57                   	push   %edi
  801fc4:	e8 01 ed ff ff       	call   800cca <strcpy>
		string_store += strlen(argv[i]) + 1;
  801fc9:	83 c4 04             	add    $0x4,%esp
  801fcc:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801fcf:	e8 bd ec ff ff       	call   800c91 <strlen>
  801fd4:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801fd8:	83 c6 01             	add    $0x1,%esi
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801fe4:	7f c8                	jg     801fae <spawn+0x162>
	}
	argv_store[argc] = 0;
  801fe6:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801fec:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ff2:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ff9:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801fff:	0f 85 86 00 00 00    	jne    80208b <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802005:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  80200b:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802011:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802014:	89 d0                	mov    %edx,%eax
  802016:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80201c:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80201f:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802024:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	6a 07                	push   $0x7
  80202f:	68 00 d0 bf ee       	push   $0xeebfd000
  802034:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80203a:	68 00 00 40 00       	push   $0x400000
  80203f:	6a 00                	push   $0x0
  802041:	e8 b9 f0 ff ff       	call   8010ff <sys_page_map>
  802046:	89 c3                	mov    %eax,%ebx
  802048:	83 c4 20             	add    $0x20,%esp
  80204b:	85 c0                	test   %eax,%eax
  80204d:	0f 88 4f 03 00 00    	js     8023a2 <spawn+0x556>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802053:	83 ec 08             	sub    $0x8,%esp
  802056:	68 00 00 40 00       	push   $0x400000
  80205b:	6a 00                	push   $0x0
  80205d:	e8 df f0 ff ff       	call   801141 <sys_page_unmap>
  802062:	89 c3                	mov    %eax,%ebx
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	85 c0                	test   %eax,%eax
  802069:	0f 88 33 03 00 00    	js     8023a2 <spawn+0x556>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80206f:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802075:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80207c:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802083:	00 00 00 
  802086:	e9 4f 01 00 00       	jmp    8021da <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80208b:	68 64 33 80 00       	push   $0x803364
  802090:	68 ab 32 80 00       	push   $0x8032ab
  802095:	68 f2 00 00 00       	push   $0xf2
  80209a:	68 f1 32 80 00       	push   $0x8032f1
  80209f:	e8 3d e4 ff ff       	call   8004e1 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020a4:	83 ec 04             	sub    $0x4,%esp
  8020a7:	6a 07                	push   $0x7
  8020a9:	68 00 00 40 00       	push   $0x400000
  8020ae:	6a 00                	push   $0x0
  8020b0:	e8 07 f0 ff ff       	call   8010bc <sys_page_alloc>
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	0f 88 c0 02 00 00    	js     802380 <spawn+0x534>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8020c0:	83 ec 08             	sub    $0x8,%esp
  8020c3:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8020c9:	01 f0                	add    %esi,%eax
  8020cb:	50                   	push   %eax
  8020cc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8020d2:	e8 bb f9 ff ff       	call   801a92 <seek>
  8020d7:	83 c4 10             	add    $0x10,%esp
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	0f 88 a5 02 00 00    	js     802387 <spawn+0x53b>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8020eb:	29 f0                	sub    %esi,%eax
  8020ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020f7:	0f 47 c1             	cmova  %ecx,%eax
  8020fa:	50                   	push   %eax
  8020fb:	68 00 00 40 00       	push   $0x400000
  802100:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802106:	e8 c0 f8 ff ff       	call   8019cb <readn>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	85 c0                	test   %eax,%eax
  802110:	0f 88 78 02 00 00    	js     80238e <spawn+0x542>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802116:	83 ec 0c             	sub    $0xc,%esp
  802119:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80211f:	53                   	push   %ebx
  802120:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802126:	68 00 00 40 00       	push   $0x400000
  80212b:	6a 00                	push   $0x0
  80212d:	e8 cd ef ff ff       	call   8010ff <sys_page_map>
  802132:	83 c4 20             	add    $0x20,%esp
  802135:	85 c0                	test   %eax,%eax
  802137:	78 7c                	js     8021b5 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802139:	83 ec 08             	sub    $0x8,%esp
  80213c:	68 00 00 40 00       	push   $0x400000
  802141:	6a 00                	push   $0x0
  802143:	e8 f9 ef ff ff       	call   801141 <sys_page_unmap>
  802148:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80214b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802151:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802157:	89 fe                	mov    %edi,%esi
  802159:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  80215f:	76 69                	jbe    8021ca <spawn+0x37e>
		if (i >= filesz) {
  802161:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802167:	0f 87 37 ff ff ff    	ja     8020a4 <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802176:	53                   	push   %ebx
  802177:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80217d:	e8 3a ef ff ff       	call   8010bc <sys_page_alloc>
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	85 c0                	test   %eax,%eax
  802187:	79 c2                	jns    80214b <spawn+0x2ff>
  802189:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802194:	e8 a4 ee ff ff       	call   80103d <sys_env_destroy>
	close(fd);
  802199:	83 c4 04             	add    $0x4,%esp
  80219c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021a2:	e8 5f f6 ff ff       	call   801806 <close>
	return r;
  8021a7:	83 c4 10             	add    $0x10,%esp
  8021aa:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8021b0:	e9 bd 01 00 00       	jmp    802372 <spawn+0x526>
				panic("spawn: sys_page_map data: %e", r);
  8021b5:	50                   	push   %eax
  8021b6:	68 fd 32 80 00       	push   $0x8032fd
  8021bb:	68 25 01 00 00       	push   $0x125
  8021c0:	68 f1 32 80 00       	push   $0x8032f1
  8021c5:	e8 17 e3 ff ff       	call   8004e1 <_panic>
  8021ca:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8021d0:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8021d7:	83 c6 20             	add    $0x20,%esi
  8021da:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8021e1:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8021e7:	7e 6d                	jle    802256 <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  8021e9:	83 3e 01             	cmpl   $0x1,(%esi)
  8021ec:	75 e2                	jne    8021d0 <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8021ee:	8b 46 18             	mov    0x18(%esi),%eax
  8021f1:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8021f4:	83 f8 01             	cmp    $0x1,%eax
  8021f7:	19 c0                	sbb    %eax,%eax
  8021f9:	83 e0 fe             	and    $0xfffffffe,%eax
  8021fc:	83 c0 07             	add    $0x7,%eax
  8021ff:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802205:	8b 4e 04             	mov    0x4(%esi),%ecx
  802208:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80220e:	8b 56 10             	mov    0x10(%esi),%edx
  802211:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802217:	8b 7e 14             	mov    0x14(%esi),%edi
  80221a:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802220:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802223:	89 d8                	mov    %ebx,%eax
  802225:	25 ff 0f 00 00       	and    $0xfff,%eax
  80222a:	74 1a                	je     802246 <spawn+0x3fa>
		va -= i;
  80222c:	29 c3                	sub    %eax,%ebx
		memsz += i;
  80222e:	01 c7                	add    %eax,%edi
  802230:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802236:	01 c2                	add    %eax,%edx
  802238:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  80223e:	29 c1                	sub    %eax,%ecx
  802240:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802246:	bf 00 00 00 00       	mov    $0x0,%edi
  80224b:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802251:	e9 01 ff ff ff       	jmp    802157 <spawn+0x30b>
	close(fd);
  802256:	83 ec 0c             	sub    $0xc,%esp
  802259:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80225f:	e8 a2 f5 ff ff       	call   801806 <close>
  802264:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	uint8_t *addr;
	int r;

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  802267:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80226c:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802272:	eb 0e                	jmp    802282 <spawn+0x436>
  802274:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80227a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802280:	74 6f                	je     8022f1 <spawn+0x4a5>
		if ((uvpd[PDX(addr)] & PTE_P) 
  802282:	89 d8                	mov    %ebx,%eax
  802284:	c1 e8 16             	shr    $0x16,%eax
  802287:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80228e:	a8 01                	test   $0x1,%al
  802290:	74 e2                	je     802274 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_P) 
  802292:	89 d8                	mov    %ebx,%eax
  802294:	c1 e8 0c             	shr    $0xc,%eax
  802297:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80229e:	f6 c2 01             	test   $0x1,%dl
  8022a1:	74 d1                	je     802274 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_U) 
  8022a3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8022aa:	f6 c2 04             	test   $0x4,%dl
  8022ad:	74 c5                	je     802274 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_SHARE)){
  8022af:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8022b6:	f6 c6 04             	test   $0x4,%dh
  8022b9:	74 b9                	je     802274 <spawn+0x428>
			if((r = sys_page_map(0, (void*)addr, child, (void*)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8022bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8022c2:	83 ec 0c             	sub    $0xc,%esp
  8022c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8022ca:	50                   	push   %eax
  8022cb:	53                   	push   %ebx
  8022cc:	56                   	push   %esi
  8022cd:	53                   	push   %ebx
  8022ce:	6a 00                	push   $0x0
  8022d0:	e8 2a ee ff ff       	call   8010ff <sys_page_map>
  8022d5:	83 c4 20             	add    $0x20,%esp
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	79 98                	jns    802274 <spawn+0x428>
				panic("copy_shared_pages: %e\n", r);
  8022dc:	50                   	push   %eax
  8022dd:	68 1a 33 80 00       	push   $0x80331a
  8022e2:	68 3a 01 00 00       	push   $0x13a
  8022e7:	68 f1 32 80 00       	push   $0x8032f1
  8022ec:	e8 f0 e1 ff ff       	call   8004e1 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8022f1:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8022f8:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8022fb:	83 ec 08             	sub    $0x8,%esp
  8022fe:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802304:	50                   	push   %eax
  802305:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80230b:	e8 f6 ee ff ff       	call   801206 <sys_env_set_trapframe>
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	85 c0                	test   %eax,%eax
  802315:	78 25                	js     80233c <spawn+0x4f0>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802317:	83 ec 08             	sub    $0x8,%esp
  80231a:	6a 02                	push   $0x2
  80231c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802322:	e8 9d ee ff ff       	call   8011c4 <sys_env_set_status>
  802327:	83 c4 10             	add    $0x10,%esp
  80232a:	85 c0                	test   %eax,%eax
  80232c:	78 23                	js     802351 <spawn+0x505>
	return child;
  80232e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802334:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80233a:	eb 36                	jmp    802372 <spawn+0x526>
		panic("sys_env_set_trapframe: %e", r);
  80233c:	50                   	push   %eax
  80233d:	68 31 33 80 00       	push   $0x803331
  802342:	68 86 00 00 00       	push   $0x86
  802347:	68 f1 32 80 00       	push   $0x8032f1
  80234c:	e8 90 e1 ff ff       	call   8004e1 <_panic>
		panic("sys_env_set_status: %e", r);
  802351:	50                   	push   %eax
  802352:	68 4b 33 80 00       	push   $0x80334b
  802357:	68 89 00 00 00       	push   $0x89
  80235c:	68 f1 32 80 00       	push   $0x8032f1
  802361:	e8 7b e1 ff ff       	call   8004e1 <_panic>
		return r;
  802366:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80236c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802372:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80237b:	5b                   	pop    %ebx
  80237c:	5e                   	pop    %esi
  80237d:	5f                   	pop    %edi
  80237e:	5d                   	pop    %ebp
  80237f:	c3                   	ret    
  802380:	89 c7                	mov    %eax,%edi
  802382:	e9 04 fe ff ff       	jmp    80218b <spawn+0x33f>
  802387:	89 c7                	mov    %eax,%edi
  802389:	e9 fd fd ff ff       	jmp    80218b <spawn+0x33f>
  80238e:	89 c7                	mov    %eax,%edi
  802390:	e9 f6 fd ff ff       	jmp    80218b <spawn+0x33f>
		return -E_NO_MEM;
  802395:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  80239a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8023a0:	eb d0                	jmp    802372 <spawn+0x526>
	sys_page_unmap(0, UTEMP);
  8023a2:	83 ec 08             	sub    $0x8,%esp
  8023a5:	68 00 00 40 00       	push   $0x400000
  8023aa:	6a 00                	push   $0x0
  8023ac:	e8 90 ed ff ff       	call   801141 <sys_page_unmap>
  8023b1:	83 c4 10             	add    $0x10,%esp
  8023b4:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8023ba:	eb b6                	jmp    802372 <spawn+0x526>

008023bc <spawnl>:
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	57                   	push   %edi
  8023c0:	56                   	push   %esi
  8023c1:	53                   	push   %ebx
  8023c2:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8023c5:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8023c8:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8023cd:	8d 4a 04             	lea    0x4(%edx),%ecx
  8023d0:	83 3a 00             	cmpl   $0x0,(%edx)
  8023d3:	74 07                	je     8023dc <spawnl+0x20>
		argc++;
  8023d5:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8023d8:	89 ca                	mov    %ecx,%edx
  8023da:	eb f1                	jmp    8023cd <spawnl+0x11>
	const char *argv[argc+2];
  8023dc:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8023e3:	83 e2 f0             	and    $0xfffffff0,%edx
  8023e6:	29 d4                	sub    %edx,%esp
  8023e8:	8d 54 24 03          	lea    0x3(%esp),%edx
  8023ec:	c1 ea 02             	shr    $0x2,%edx
  8023ef:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8023f6:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8023f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023fb:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802402:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802409:	00 
	va_start(vl, arg0);
  80240a:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80240d:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	eb 0b                	jmp    802421 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802416:	83 c0 01             	add    $0x1,%eax
  802419:	8b 39                	mov    (%ecx),%edi
  80241b:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80241e:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802421:	39 d0                	cmp    %edx,%eax
  802423:	75 f1                	jne    802416 <spawnl+0x5a>
	return spawn(prog, argv);
  802425:	83 ec 08             	sub    $0x8,%esp
  802428:	56                   	push   %esi
  802429:	ff 75 08             	pushl  0x8(%ebp)
  80242c:	e8 1b fa ff ff       	call   801e4c <spawn>
}
  802431:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802434:	5b                   	pop    %ebx
  802435:	5e                   	pop    %esi
  802436:	5f                   	pop    %edi
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	56                   	push   %esi
  80243d:	53                   	push   %ebx
  80243e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	ff 75 08             	pushl  0x8(%ebp)
  802447:	e8 24 f2 ff ff       	call   801670 <fd2data>
  80244c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80244e:	83 c4 08             	add    $0x8,%esp
  802451:	68 8c 33 80 00       	push   $0x80338c
  802456:	53                   	push   %ebx
  802457:	e8 6e e8 ff ff       	call   800cca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80245c:	8b 46 04             	mov    0x4(%esi),%eax
  80245f:	2b 06                	sub    (%esi),%eax
  802461:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802467:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80246e:	00 00 00 
	stat->st_dev = &devpipe;
  802471:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802478:	40 80 00 
	return 0;
}
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
  802480:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802483:	5b                   	pop    %ebx
  802484:	5e                   	pop    %esi
  802485:	5d                   	pop    %ebp
  802486:	c3                   	ret    

00802487 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
  80248a:	53                   	push   %ebx
  80248b:	83 ec 0c             	sub    $0xc,%esp
  80248e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802491:	53                   	push   %ebx
  802492:	6a 00                	push   $0x0
  802494:	e8 a8 ec ff ff       	call   801141 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802499:	89 1c 24             	mov    %ebx,(%esp)
  80249c:	e8 cf f1 ff ff       	call   801670 <fd2data>
  8024a1:	83 c4 08             	add    $0x8,%esp
  8024a4:	50                   	push   %eax
  8024a5:	6a 00                	push   $0x0
  8024a7:	e8 95 ec ff ff       	call   801141 <sys_page_unmap>
}
  8024ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <_pipeisclosed>:
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	57                   	push   %edi
  8024b5:	56                   	push   %esi
  8024b6:	53                   	push   %ebx
  8024b7:	83 ec 1c             	sub    $0x1c,%esp
  8024ba:	89 c7                	mov    %eax,%edi
  8024bc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024be:	a1 04 50 80 00       	mov    0x805004,%eax
  8024c3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024c6:	83 ec 0c             	sub    $0xc,%esp
  8024c9:	57                   	push   %edi
  8024ca:	e8 89 04 00 00       	call   802958 <pageref>
  8024cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024d2:	89 34 24             	mov    %esi,(%esp)
  8024d5:	e8 7e 04 00 00       	call   802958 <pageref>
		nn = thisenv->env_runs;
  8024da:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8024e0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024e3:	83 c4 10             	add    $0x10,%esp
  8024e6:	39 cb                	cmp    %ecx,%ebx
  8024e8:	74 1b                	je     802505 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024ea:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024ed:	75 cf                	jne    8024be <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024ef:	8b 42 58             	mov    0x58(%edx),%eax
  8024f2:	6a 01                	push   $0x1
  8024f4:	50                   	push   %eax
  8024f5:	53                   	push   %ebx
  8024f6:	68 93 33 80 00       	push   $0x803393
  8024fb:	e8 bc e0 ff ff       	call   8005bc <cprintf>
  802500:	83 c4 10             	add    $0x10,%esp
  802503:	eb b9                	jmp    8024be <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802505:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802508:	0f 94 c0             	sete   %al
  80250b:	0f b6 c0             	movzbl %al,%eax
}
  80250e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802511:	5b                   	pop    %ebx
  802512:	5e                   	pop    %esi
  802513:	5f                   	pop    %edi
  802514:	5d                   	pop    %ebp
  802515:	c3                   	ret    

00802516 <devpipe_write>:
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
  802519:	57                   	push   %edi
  80251a:	56                   	push   %esi
  80251b:	53                   	push   %ebx
  80251c:	83 ec 28             	sub    $0x28,%esp
  80251f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802522:	56                   	push   %esi
  802523:	e8 48 f1 ff ff       	call   801670 <fd2data>
  802528:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80252a:	83 c4 10             	add    $0x10,%esp
  80252d:	bf 00 00 00 00       	mov    $0x0,%edi
  802532:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802535:	74 4f                	je     802586 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802537:	8b 43 04             	mov    0x4(%ebx),%eax
  80253a:	8b 0b                	mov    (%ebx),%ecx
  80253c:	8d 51 20             	lea    0x20(%ecx),%edx
  80253f:	39 d0                	cmp    %edx,%eax
  802541:	72 14                	jb     802557 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802543:	89 da                	mov    %ebx,%edx
  802545:	89 f0                	mov    %esi,%eax
  802547:	e8 65 ff ff ff       	call   8024b1 <_pipeisclosed>
  80254c:	85 c0                	test   %eax,%eax
  80254e:	75 3b                	jne    80258b <devpipe_write+0x75>
			sys_yield();
  802550:	e8 48 eb ff ff       	call   80109d <sys_yield>
  802555:	eb e0                	jmp    802537 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802557:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80255a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80255e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802561:	89 c2                	mov    %eax,%edx
  802563:	c1 fa 1f             	sar    $0x1f,%edx
  802566:	89 d1                	mov    %edx,%ecx
  802568:	c1 e9 1b             	shr    $0x1b,%ecx
  80256b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80256e:	83 e2 1f             	and    $0x1f,%edx
  802571:	29 ca                	sub    %ecx,%edx
  802573:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802577:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80257b:	83 c0 01             	add    $0x1,%eax
  80257e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802581:	83 c7 01             	add    $0x1,%edi
  802584:	eb ac                	jmp    802532 <devpipe_write+0x1c>
	return i;
  802586:	8b 45 10             	mov    0x10(%ebp),%eax
  802589:	eb 05                	jmp    802590 <devpipe_write+0x7a>
				return 0;
  80258b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802593:	5b                   	pop    %ebx
  802594:	5e                   	pop    %esi
  802595:	5f                   	pop    %edi
  802596:	5d                   	pop    %ebp
  802597:	c3                   	ret    

00802598 <devpipe_read>:
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
  80259b:	57                   	push   %edi
  80259c:	56                   	push   %esi
  80259d:	53                   	push   %ebx
  80259e:	83 ec 18             	sub    $0x18,%esp
  8025a1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025a4:	57                   	push   %edi
  8025a5:	e8 c6 f0 ff ff       	call   801670 <fd2data>
  8025aa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025ac:	83 c4 10             	add    $0x10,%esp
  8025af:	be 00 00 00 00       	mov    $0x0,%esi
  8025b4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025b7:	75 14                	jne    8025cd <devpipe_read+0x35>
	return i;
  8025b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8025bc:	eb 02                	jmp    8025c0 <devpipe_read+0x28>
				return i;
  8025be:	89 f0                	mov    %esi,%eax
}
  8025c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c3:	5b                   	pop    %ebx
  8025c4:	5e                   	pop    %esi
  8025c5:	5f                   	pop    %edi
  8025c6:	5d                   	pop    %ebp
  8025c7:	c3                   	ret    
			sys_yield();
  8025c8:	e8 d0 ea ff ff       	call   80109d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025cd:	8b 03                	mov    (%ebx),%eax
  8025cf:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025d2:	75 18                	jne    8025ec <devpipe_read+0x54>
			if (i > 0)
  8025d4:	85 f6                	test   %esi,%esi
  8025d6:	75 e6                	jne    8025be <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025d8:	89 da                	mov    %ebx,%edx
  8025da:	89 f8                	mov    %edi,%eax
  8025dc:	e8 d0 fe ff ff       	call   8024b1 <_pipeisclosed>
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	74 e3                	je     8025c8 <devpipe_read+0x30>
				return 0;
  8025e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ea:	eb d4                	jmp    8025c0 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025ec:	99                   	cltd   
  8025ed:	c1 ea 1b             	shr    $0x1b,%edx
  8025f0:	01 d0                	add    %edx,%eax
  8025f2:	83 e0 1f             	and    $0x1f,%eax
  8025f5:	29 d0                	sub    %edx,%eax
  8025f7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025ff:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802602:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802605:	83 c6 01             	add    $0x1,%esi
  802608:	eb aa                	jmp    8025b4 <devpipe_read+0x1c>

0080260a <pipe>:
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	56                   	push   %esi
  80260e:	53                   	push   %ebx
  80260f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802612:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802615:	50                   	push   %eax
  802616:	e8 6c f0 ff ff       	call   801687 <fd_alloc>
  80261b:	89 c3                	mov    %eax,%ebx
  80261d:	83 c4 10             	add    $0x10,%esp
  802620:	85 c0                	test   %eax,%eax
  802622:	0f 88 23 01 00 00    	js     80274b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802628:	83 ec 04             	sub    $0x4,%esp
  80262b:	68 07 04 00 00       	push   $0x407
  802630:	ff 75 f4             	pushl  -0xc(%ebp)
  802633:	6a 00                	push   $0x0
  802635:	e8 82 ea ff ff       	call   8010bc <sys_page_alloc>
  80263a:	89 c3                	mov    %eax,%ebx
  80263c:	83 c4 10             	add    $0x10,%esp
  80263f:	85 c0                	test   %eax,%eax
  802641:	0f 88 04 01 00 00    	js     80274b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802647:	83 ec 0c             	sub    $0xc,%esp
  80264a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80264d:	50                   	push   %eax
  80264e:	e8 34 f0 ff ff       	call   801687 <fd_alloc>
  802653:	89 c3                	mov    %eax,%ebx
  802655:	83 c4 10             	add    $0x10,%esp
  802658:	85 c0                	test   %eax,%eax
  80265a:	0f 88 db 00 00 00    	js     80273b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802660:	83 ec 04             	sub    $0x4,%esp
  802663:	68 07 04 00 00       	push   $0x407
  802668:	ff 75 f0             	pushl  -0x10(%ebp)
  80266b:	6a 00                	push   $0x0
  80266d:	e8 4a ea ff ff       	call   8010bc <sys_page_alloc>
  802672:	89 c3                	mov    %eax,%ebx
  802674:	83 c4 10             	add    $0x10,%esp
  802677:	85 c0                	test   %eax,%eax
  802679:	0f 88 bc 00 00 00    	js     80273b <pipe+0x131>
	va = fd2data(fd0);
  80267f:	83 ec 0c             	sub    $0xc,%esp
  802682:	ff 75 f4             	pushl  -0xc(%ebp)
  802685:	e8 e6 ef ff ff       	call   801670 <fd2data>
  80268a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268c:	83 c4 0c             	add    $0xc,%esp
  80268f:	68 07 04 00 00       	push   $0x407
  802694:	50                   	push   %eax
  802695:	6a 00                	push   $0x0
  802697:	e8 20 ea ff ff       	call   8010bc <sys_page_alloc>
  80269c:	89 c3                	mov    %eax,%ebx
  80269e:	83 c4 10             	add    $0x10,%esp
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	0f 88 82 00 00 00    	js     80272b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026a9:	83 ec 0c             	sub    $0xc,%esp
  8026ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8026af:	e8 bc ef ff ff       	call   801670 <fd2data>
  8026b4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026bb:	50                   	push   %eax
  8026bc:	6a 00                	push   $0x0
  8026be:	56                   	push   %esi
  8026bf:	6a 00                	push   $0x0
  8026c1:	e8 39 ea ff ff       	call   8010ff <sys_page_map>
  8026c6:	89 c3                	mov    %eax,%ebx
  8026c8:	83 c4 20             	add    $0x20,%esp
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	78 4e                	js     80271d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026cf:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8026d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026f2:	83 ec 0c             	sub    $0xc,%esp
  8026f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8026f8:	e8 63 ef ff ff       	call   801660 <fd2num>
  8026fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802700:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802702:	83 c4 04             	add    $0x4,%esp
  802705:	ff 75 f0             	pushl  -0x10(%ebp)
  802708:	e8 53 ef ff ff       	call   801660 <fd2num>
  80270d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802710:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802713:	83 c4 10             	add    $0x10,%esp
  802716:	bb 00 00 00 00       	mov    $0x0,%ebx
  80271b:	eb 2e                	jmp    80274b <pipe+0x141>
	sys_page_unmap(0, va);
  80271d:	83 ec 08             	sub    $0x8,%esp
  802720:	56                   	push   %esi
  802721:	6a 00                	push   $0x0
  802723:	e8 19 ea ff ff       	call   801141 <sys_page_unmap>
  802728:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80272b:	83 ec 08             	sub    $0x8,%esp
  80272e:	ff 75 f0             	pushl  -0x10(%ebp)
  802731:	6a 00                	push   $0x0
  802733:	e8 09 ea ff ff       	call   801141 <sys_page_unmap>
  802738:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80273b:	83 ec 08             	sub    $0x8,%esp
  80273e:	ff 75 f4             	pushl  -0xc(%ebp)
  802741:	6a 00                	push   $0x0
  802743:	e8 f9 e9 ff ff       	call   801141 <sys_page_unmap>
  802748:	83 c4 10             	add    $0x10,%esp
}
  80274b:	89 d8                	mov    %ebx,%eax
  80274d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    

00802754 <pipeisclosed>:
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80275a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80275d:	50                   	push   %eax
  80275e:	ff 75 08             	pushl  0x8(%ebp)
  802761:	e8 73 ef ff ff       	call   8016d9 <fd_lookup>
  802766:	83 c4 10             	add    $0x10,%esp
  802769:	85 c0                	test   %eax,%eax
  80276b:	78 18                	js     802785 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80276d:	83 ec 0c             	sub    $0xc,%esp
  802770:	ff 75 f4             	pushl  -0xc(%ebp)
  802773:	e8 f8 ee ff ff       	call   801670 <fd2data>
	return _pipeisclosed(fd, p);
  802778:	89 c2                	mov    %eax,%edx
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	e8 2f fd ff ff       	call   8024b1 <_pipeisclosed>
  802782:	83 c4 10             	add    $0x10,%esp
}
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	56                   	push   %esi
  80278b:	53                   	push   %ebx
  80278c:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80278f:	85 f6                	test   %esi,%esi
  802791:	74 15                	je     8027a8 <wait+0x21>
	e = &envs[ENVX(envid)];
  802793:	89 f0                	mov    %esi,%eax
  802795:	25 ff 03 00 00       	and    $0x3ff,%eax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80279a:	8d 1c c0             	lea    (%eax,%eax,8),%ebx
  80279d:	c1 e3 04             	shl    $0x4,%ebx
  8027a0:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8027a6:	eb 1b                	jmp    8027c3 <wait+0x3c>
	assert(envid != 0);
  8027a8:	68 ab 33 80 00       	push   $0x8033ab
  8027ad:	68 ab 32 80 00       	push   $0x8032ab
  8027b2:	6a 09                	push   $0x9
  8027b4:	68 b6 33 80 00       	push   $0x8033b6
  8027b9:	e8 23 dd ff ff       	call   8004e1 <_panic>
		sys_yield();
  8027be:	e8 da e8 ff ff       	call   80109d <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027c3:	8b 43 48             	mov    0x48(%ebx),%eax
  8027c6:	39 f0                	cmp    %esi,%eax
  8027c8:	75 07                	jne    8027d1 <wait+0x4a>
  8027ca:	8b 43 54             	mov    0x54(%ebx),%eax
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	75 ed                	jne    8027be <wait+0x37>
}
  8027d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027d4:	5b                   	pop    %ebx
  8027d5:	5e                   	pop    %esi
  8027d6:	5d                   	pop    %ebp
  8027d7:	c3                   	ret    

008027d8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027de:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8027e5:	74 0a                	je     8027f1 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ea:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8027f1:	83 ec 04             	sub    $0x4,%esp
  8027f4:	6a 07                	push   $0x7
  8027f6:	68 00 f0 bf ee       	push   $0xeebff000
  8027fb:	6a 00                	push   $0x0
  8027fd:	e8 ba e8 ff ff       	call   8010bc <sys_page_alloc>
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	85 c0                	test   %eax,%eax
  802807:	78 28                	js     802831 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  802809:	83 ec 08             	sub    $0x8,%esp
  80280c:	68 43 28 80 00       	push   $0x802843
  802811:	6a 00                	push   $0x0
  802813:	e8 30 ea ff ff       	call   801248 <sys_env_set_pgfault_upcall>
  802818:	83 c4 10             	add    $0x10,%esp
  80281b:	85 c0                	test   %eax,%eax
  80281d:	79 c8                	jns    8027e7 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  80281f:	50                   	push   %eax
  802820:	68 74 31 80 00       	push   $0x803174
  802825:	6a 23                	push   $0x23
  802827:	68 d9 33 80 00       	push   $0x8033d9
  80282c:	e8 b0 dc ff ff       	call   8004e1 <_panic>
			panic("set_pgfault_handler %e\n",r);
  802831:	50                   	push   %eax
  802832:	68 c1 33 80 00       	push   $0x8033c1
  802837:	6a 21                	push   $0x21
  802839:	68 d9 33 80 00       	push   $0x8033d9
  80283e:	e8 9e dc ff ff       	call   8004e1 <_panic>

00802843 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802843:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802844:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802849:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80284b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  80284e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  802852:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802856:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802859:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80285b:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80285f:	83 c4 08             	add    $0x8,%esp
	popal
  802862:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802863:	83 c4 04             	add    $0x4,%esp
	popfl
  802866:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802867:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802868:	c3                   	ret    

00802869 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
  80286c:	56                   	push   %esi
  80286d:	53                   	push   %ebx
  80286e:	8b 75 08             	mov    0x8(%ebp),%esi
  802871:	8b 45 0c             	mov    0xc(%ebp),%eax
  802874:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  802877:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802879:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80287e:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  802881:	83 ec 0c             	sub    $0xc,%esp
  802884:	50                   	push   %eax
  802885:	e8 23 ea ff ff       	call   8012ad <sys_ipc_recv>
	if (from_env_store)
  80288a:	83 c4 10             	add    $0x10,%esp
  80288d:	85 f6                	test   %esi,%esi
  80288f:	74 14                	je     8028a5 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  802891:	ba 00 00 00 00       	mov    $0x0,%edx
  802896:	85 c0                	test   %eax,%eax
  802898:	78 09                	js     8028a3 <ipc_recv+0x3a>
  80289a:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8028a0:	8b 52 78             	mov    0x78(%edx),%edx
  8028a3:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  8028a5:	85 db                	test   %ebx,%ebx
  8028a7:	74 14                	je     8028bd <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  8028a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	78 09                	js     8028bb <ipc_recv+0x52>
  8028b2:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8028b8:	8b 52 7c             	mov    0x7c(%edx),%edx
  8028bb:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	78 08                	js     8028c9 <ipc_recv+0x60>
  8028c1:	a1 04 50 80 00       	mov    0x805004,%eax
  8028c6:	8b 40 74             	mov    0x74(%eax),%eax
}
  8028c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028cc:	5b                   	pop    %ebx
  8028cd:	5e                   	pop    %esi
  8028ce:	5d                   	pop    %ebp
  8028cf:	c3                   	ret    

008028d0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
  8028d3:	83 ec 08             	sub    $0x8,%esp
  8028d6:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028e0:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8028e3:	ff 75 14             	pushl  0x14(%ebp)
  8028e6:	50                   	push   %eax
  8028e7:	ff 75 0c             	pushl  0xc(%ebp)
  8028ea:	ff 75 08             	pushl  0x8(%ebp)
  8028ed:	e8 98 e9 ff ff       	call   80128a <sys_ipc_try_send>
  8028f2:	83 c4 10             	add    $0x10,%esp
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	78 02                	js     8028fb <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  8028fb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028fe:	75 07                	jne    802907 <ipc_send+0x37>
		sys_yield();
  802900:	e8 98 e7 ff ff       	call   80109d <sys_yield>
}
  802905:	eb f2                	jmp    8028f9 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  802907:	50                   	push   %eax
  802908:	68 e7 33 80 00       	push   $0x8033e7
  80290d:	6a 3c                	push   $0x3c
  80290f:	68 fb 33 80 00       	push   $0x8033fb
  802914:	e8 c8 db ff ff       	call   8004e1 <_panic>

00802919 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802919:	55                   	push   %ebp
  80291a:	89 e5                	mov    %esp,%ebp
  80291c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80291f:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  802924:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802927:	c1 e0 04             	shl    $0x4,%eax
  80292a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80292f:	8b 40 50             	mov    0x50(%eax),%eax
  802932:	39 c8                	cmp    %ecx,%eax
  802934:	74 12                	je     802948 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802936:	83 c2 01             	add    $0x1,%edx
  802939:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80293f:	75 e3                	jne    802924 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	eb 0e                	jmp    802956 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802948:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80294b:	c1 e0 04             	shl    $0x4,%eax
  80294e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802953:	8b 40 48             	mov    0x48(%eax),%eax
}
  802956:	5d                   	pop    %ebp
  802957:	c3                   	ret    

00802958 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802958:	55                   	push   %ebp
  802959:	89 e5                	mov    %esp,%ebp
  80295b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80295e:	89 d0                	mov    %edx,%eax
  802960:	c1 e8 16             	shr    $0x16,%eax
  802963:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80296a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80296f:	f6 c1 01             	test   $0x1,%cl
  802972:	74 1d                	je     802991 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802974:	c1 ea 0c             	shr    $0xc,%edx
  802977:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80297e:	f6 c2 01             	test   $0x1,%dl
  802981:	74 0e                	je     802991 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802983:	c1 ea 0c             	shr    $0xc,%edx
  802986:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80298d:	ef 
  80298e:	0f b7 c0             	movzwl %ax,%eax
}
  802991:	5d                   	pop    %ebp
  802992:	c3                   	ret    
  802993:	66 90                	xchg   %ax,%ax
  802995:	66 90                	xchg   %ax,%ax
  802997:	66 90                	xchg   %ax,%ax
  802999:	66 90                	xchg   %ax,%ax
  80299b:	66 90                	xchg   %ax,%ax
  80299d:	66 90                	xchg   %ax,%ax
  80299f:	90                   	nop

008029a0 <__udivdi3>:
  8029a0:	55                   	push   %ebp
  8029a1:	57                   	push   %edi
  8029a2:	56                   	push   %esi
  8029a3:	53                   	push   %ebx
  8029a4:	83 ec 1c             	sub    $0x1c,%esp
  8029a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029b7:	85 d2                	test   %edx,%edx
  8029b9:	75 4d                	jne    802a08 <__udivdi3+0x68>
  8029bb:	39 f3                	cmp    %esi,%ebx
  8029bd:	76 19                	jbe    8029d8 <__udivdi3+0x38>
  8029bf:	31 ff                	xor    %edi,%edi
  8029c1:	89 e8                	mov    %ebp,%eax
  8029c3:	89 f2                	mov    %esi,%edx
  8029c5:	f7 f3                	div    %ebx
  8029c7:	89 fa                	mov    %edi,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	89 d9                	mov    %ebx,%ecx
  8029da:	85 db                	test   %ebx,%ebx
  8029dc:	75 0b                	jne    8029e9 <__udivdi3+0x49>
  8029de:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e3:	31 d2                	xor    %edx,%edx
  8029e5:	f7 f3                	div    %ebx
  8029e7:	89 c1                	mov    %eax,%ecx
  8029e9:	31 d2                	xor    %edx,%edx
  8029eb:	89 f0                	mov    %esi,%eax
  8029ed:	f7 f1                	div    %ecx
  8029ef:	89 c6                	mov    %eax,%esi
  8029f1:	89 e8                	mov    %ebp,%eax
  8029f3:	89 f7                	mov    %esi,%edi
  8029f5:	f7 f1                	div    %ecx
  8029f7:	89 fa                	mov    %edi,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	39 f2                	cmp    %esi,%edx
  802a0a:	77 1c                	ja     802a28 <__udivdi3+0x88>
  802a0c:	0f bd fa             	bsr    %edx,%edi
  802a0f:	83 f7 1f             	xor    $0x1f,%edi
  802a12:	75 2c                	jne    802a40 <__udivdi3+0xa0>
  802a14:	39 f2                	cmp    %esi,%edx
  802a16:	72 06                	jb     802a1e <__udivdi3+0x7e>
  802a18:	31 c0                	xor    %eax,%eax
  802a1a:	39 eb                	cmp    %ebp,%ebx
  802a1c:	77 a9                	ja     8029c7 <__udivdi3+0x27>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	eb a2                	jmp    8029c7 <__udivdi3+0x27>
  802a25:	8d 76 00             	lea    0x0(%esi),%esi
  802a28:	31 ff                	xor    %edi,%edi
  802a2a:	31 c0                	xor    %eax,%eax
  802a2c:	89 fa                	mov    %edi,%edx
  802a2e:	83 c4 1c             	add    $0x1c,%esp
  802a31:	5b                   	pop    %ebx
  802a32:	5e                   	pop    %esi
  802a33:	5f                   	pop    %edi
  802a34:	5d                   	pop    %ebp
  802a35:	c3                   	ret    
  802a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a3d:	8d 76 00             	lea    0x0(%esi),%esi
  802a40:	89 f9                	mov    %edi,%ecx
  802a42:	b8 20 00 00 00       	mov    $0x20,%eax
  802a47:	29 f8                	sub    %edi,%eax
  802a49:	d3 e2                	shl    %cl,%edx
  802a4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a4f:	89 c1                	mov    %eax,%ecx
  802a51:	89 da                	mov    %ebx,%edx
  802a53:	d3 ea                	shr    %cl,%edx
  802a55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a59:	09 d1                	or     %edx,%ecx
  802a5b:	89 f2                	mov    %esi,%edx
  802a5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a61:	89 f9                	mov    %edi,%ecx
  802a63:	d3 e3                	shl    %cl,%ebx
  802a65:	89 c1                	mov    %eax,%ecx
  802a67:	d3 ea                	shr    %cl,%edx
  802a69:	89 f9                	mov    %edi,%ecx
  802a6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a6f:	89 eb                	mov    %ebp,%ebx
  802a71:	d3 e6                	shl    %cl,%esi
  802a73:	89 c1                	mov    %eax,%ecx
  802a75:	d3 eb                	shr    %cl,%ebx
  802a77:	09 de                	or     %ebx,%esi
  802a79:	89 f0                	mov    %esi,%eax
  802a7b:	f7 74 24 08          	divl   0x8(%esp)
  802a7f:	89 d6                	mov    %edx,%esi
  802a81:	89 c3                	mov    %eax,%ebx
  802a83:	f7 64 24 0c          	mull   0xc(%esp)
  802a87:	39 d6                	cmp    %edx,%esi
  802a89:	72 15                	jb     802aa0 <__udivdi3+0x100>
  802a8b:	89 f9                	mov    %edi,%ecx
  802a8d:	d3 e5                	shl    %cl,%ebp
  802a8f:	39 c5                	cmp    %eax,%ebp
  802a91:	73 04                	jae    802a97 <__udivdi3+0xf7>
  802a93:	39 d6                	cmp    %edx,%esi
  802a95:	74 09                	je     802aa0 <__udivdi3+0x100>
  802a97:	89 d8                	mov    %ebx,%eax
  802a99:	31 ff                	xor    %edi,%edi
  802a9b:	e9 27 ff ff ff       	jmp    8029c7 <__udivdi3+0x27>
  802aa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802aa3:	31 ff                	xor    %edi,%edi
  802aa5:	e9 1d ff ff ff       	jmp    8029c7 <__udivdi3+0x27>
  802aaa:	66 90                	xchg   %ax,%ax
  802aac:	66 90                	xchg   %ax,%ax
  802aae:	66 90                	xchg   %ax,%ax

00802ab0 <__umoddi3>:
  802ab0:	55                   	push   %ebp
  802ab1:	57                   	push   %edi
  802ab2:	56                   	push   %esi
  802ab3:	53                   	push   %ebx
  802ab4:	83 ec 1c             	sub    $0x1c,%esp
  802ab7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802abb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802abf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ac3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ac7:	89 da                	mov    %ebx,%edx
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	75 43                	jne    802b10 <__umoddi3+0x60>
  802acd:	39 df                	cmp    %ebx,%edi
  802acf:	76 17                	jbe    802ae8 <__umoddi3+0x38>
  802ad1:	89 f0                	mov    %esi,%eax
  802ad3:	f7 f7                	div    %edi
  802ad5:	89 d0                	mov    %edx,%eax
  802ad7:	31 d2                	xor    %edx,%edx
  802ad9:	83 c4 1c             	add    $0x1c,%esp
  802adc:	5b                   	pop    %ebx
  802add:	5e                   	pop    %esi
  802ade:	5f                   	pop    %edi
  802adf:	5d                   	pop    %ebp
  802ae0:	c3                   	ret    
  802ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ae8:	89 fd                	mov    %edi,%ebp
  802aea:	85 ff                	test   %edi,%edi
  802aec:	75 0b                	jne    802af9 <__umoddi3+0x49>
  802aee:	b8 01 00 00 00       	mov    $0x1,%eax
  802af3:	31 d2                	xor    %edx,%edx
  802af5:	f7 f7                	div    %edi
  802af7:	89 c5                	mov    %eax,%ebp
  802af9:	89 d8                	mov    %ebx,%eax
  802afb:	31 d2                	xor    %edx,%edx
  802afd:	f7 f5                	div    %ebp
  802aff:	89 f0                	mov    %esi,%eax
  802b01:	f7 f5                	div    %ebp
  802b03:	89 d0                	mov    %edx,%eax
  802b05:	eb d0                	jmp    802ad7 <__umoddi3+0x27>
  802b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0e:	66 90                	xchg   %ax,%ax
  802b10:	89 f1                	mov    %esi,%ecx
  802b12:	39 d8                	cmp    %ebx,%eax
  802b14:	76 0a                	jbe    802b20 <__umoddi3+0x70>
  802b16:	89 f0                	mov    %esi,%eax
  802b18:	83 c4 1c             	add    $0x1c,%esp
  802b1b:	5b                   	pop    %ebx
  802b1c:	5e                   	pop    %esi
  802b1d:	5f                   	pop    %edi
  802b1e:	5d                   	pop    %ebp
  802b1f:	c3                   	ret    
  802b20:	0f bd e8             	bsr    %eax,%ebp
  802b23:	83 f5 1f             	xor    $0x1f,%ebp
  802b26:	75 20                	jne    802b48 <__umoddi3+0x98>
  802b28:	39 d8                	cmp    %ebx,%eax
  802b2a:	0f 82 b0 00 00 00    	jb     802be0 <__umoddi3+0x130>
  802b30:	39 f7                	cmp    %esi,%edi
  802b32:	0f 86 a8 00 00 00    	jbe    802be0 <__umoddi3+0x130>
  802b38:	89 c8                	mov    %ecx,%eax
  802b3a:	83 c4 1c             	add    $0x1c,%esp
  802b3d:	5b                   	pop    %ebx
  802b3e:	5e                   	pop    %esi
  802b3f:	5f                   	pop    %edi
  802b40:	5d                   	pop    %ebp
  802b41:	c3                   	ret    
  802b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b48:	89 e9                	mov    %ebp,%ecx
  802b4a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b4f:	29 ea                	sub    %ebp,%edx
  802b51:	d3 e0                	shl    %cl,%eax
  802b53:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b57:	89 d1                	mov    %edx,%ecx
  802b59:	89 f8                	mov    %edi,%eax
  802b5b:	d3 e8                	shr    %cl,%eax
  802b5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b61:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b65:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b69:	09 c1                	or     %eax,%ecx
  802b6b:	89 d8                	mov    %ebx,%eax
  802b6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b71:	89 e9                	mov    %ebp,%ecx
  802b73:	d3 e7                	shl    %cl,%edi
  802b75:	89 d1                	mov    %edx,%ecx
  802b77:	d3 e8                	shr    %cl,%eax
  802b79:	89 e9                	mov    %ebp,%ecx
  802b7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b7f:	d3 e3                	shl    %cl,%ebx
  802b81:	89 c7                	mov    %eax,%edi
  802b83:	89 d1                	mov    %edx,%ecx
  802b85:	89 f0                	mov    %esi,%eax
  802b87:	d3 e8                	shr    %cl,%eax
  802b89:	89 e9                	mov    %ebp,%ecx
  802b8b:	89 fa                	mov    %edi,%edx
  802b8d:	d3 e6                	shl    %cl,%esi
  802b8f:	09 d8                	or     %ebx,%eax
  802b91:	f7 74 24 08          	divl   0x8(%esp)
  802b95:	89 d1                	mov    %edx,%ecx
  802b97:	89 f3                	mov    %esi,%ebx
  802b99:	f7 64 24 0c          	mull   0xc(%esp)
  802b9d:	89 c6                	mov    %eax,%esi
  802b9f:	89 d7                	mov    %edx,%edi
  802ba1:	39 d1                	cmp    %edx,%ecx
  802ba3:	72 06                	jb     802bab <__umoddi3+0xfb>
  802ba5:	75 10                	jne    802bb7 <__umoddi3+0x107>
  802ba7:	39 c3                	cmp    %eax,%ebx
  802ba9:	73 0c                	jae    802bb7 <__umoddi3+0x107>
  802bab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802baf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bb3:	89 d7                	mov    %edx,%edi
  802bb5:	89 c6                	mov    %eax,%esi
  802bb7:	89 ca                	mov    %ecx,%edx
  802bb9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bbe:	29 f3                	sub    %esi,%ebx
  802bc0:	19 fa                	sbb    %edi,%edx
  802bc2:	89 d0                	mov    %edx,%eax
  802bc4:	d3 e0                	shl    %cl,%eax
  802bc6:	89 e9                	mov    %ebp,%ecx
  802bc8:	d3 eb                	shr    %cl,%ebx
  802bca:	d3 ea                	shr    %cl,%edx
  802bcc:	09 d8                	or     %ebx,%eax
  802bce:	83 c4 1c             	add    $0x1c,%esp
  802bd1:	5b                   	pop    %ebx
  802bd2:	5e                   	pop    %esi
  802bd3:	5f                   	pop    %edi
  802bd4:	5d                   	pop    %ebp
  802bd5:	c3                   	ret    
  802bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bdd:	8d 76 00             	lea    0x0(%esi),%esi
  802be0:	89 da                	mov    %ebx,%edx
  802be2:	29 fe                	sub    %edi,%esi
  802be4:	19 c2                	sbb    %eax,%edx
  802be6:	89 f1                	mov    %esi,%ecx
  802be8:	89 c8                	mov    %ecx,%eax
  802bea:	e9 4b ff ff ff       	jmp    802b3a <__umoddi3+0x8a>
