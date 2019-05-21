
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 65 03 00 00       	call   800396 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	39 da                	cmp    %ebx,%edx
  80004a:	7d 0e                	jge    80005a <sum+0x27>
		tot ^= i * s[i];
  80004c:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  800050:	0f af ca             	imul   %edx,%ecx
  800053:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800055:	83 c2 01             	add    $0x1,%edx
  800058:	eb ee                	jmp    800048 <sum+0x15>
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 40 27 80 00       	push   $0x802740
  800072:	e8 55 04 00 00       	call   8004cc <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 30 80 00       	push   $0x803000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 08 28 80 00       	push   $0x802808
  8000a5:	e8 22 04 00 00       	call   8004cc <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 50 80 00       	push   $0x805020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 44 28 80 00       	push   $0x802844
  8000cf:	e8 f8 03 00 00       	call   8004cc <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 7c 27 80 00       	push   $0x80277c
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 0f 0b 00 00       	call   800bfa <strcat>
	for (i = 0; i < argc; i++) {
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f3:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f9:	39 fb                	cmp    %edi,%ebx
  8000fb:	7d 5a                	jge    800157 <umain+0xf9>
		strcat(args, " '");
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	68 88 27 80 00       	push   $0x802788
  800105:	56                   	push   %esi
  800106:	e8 ef 0a 00 00       	call   800bfa <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 e0 0a 00 00       	call   800bfa <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 89 27 80 00       	push   $0x802789
  800122:	56                   	push   %esi
  800123:	e8 d2 0a 00 00       	call   800bfa <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 4f 27 80 00       	push   $0x80274f
  800138:	e8 8f 03 00 00       	call   8004cc <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 66 27 80 00       	push   $0x802766
  80014d:	e8 7a 03 00 00       	call   8004cc <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 8b 27 80 00       	push   $0x80278b
  800166:	e8 61 03 00 00       	call   8004cc <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  800172:	e8 55 03 00 00       	call   8004cc <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 62 12 00 00       	call   8013e5 <close>
	if ((r = opencons()) < 0)
  800183:	e8 bc 01 00 00       	call   800344 <opencons>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	85 c0                	test   %eax,%eax
  80018d:	78 14                	js     8001a3 <umain+0x145>
		panic("opencons: %e", r);
	if (r != 0)
  80018f:	74 24                	je     8001b5 <umain+0x157>
		panic("first opencons used fd %d", r);
  800191:	50                   	push   %eax
  800192:	68 ba 27 80 00       	push   $0x8027ba
  800197:	6a 39                	push   $0x39
  800199:	68 ae 27 80 00       	push   $0x8027ae
  80019e:	e8 4e 02 00 00       	call   8003f1 <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 a1 27 80 00       	push   $0x8027a1
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 ae 27 80 00       	push   $0x8027ae
  8001b0:	e8 3c 02 00 00       	call   8003f1 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 76 12 00 00       	call   801437 <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 d4 27 80 00       	push   $0x8027d4
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 ae 27 80 00       	push   $0x8027ae
  8001d5:	e8 17 02 00 00       	call   8003f1 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 f3 27 80 00       	push   $0x8027f3
  8001e3:	e8 e4 02 00 00       	call   8004cc <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 dc 27 80 00       	push   $0x8027dc
  8001f3:	e8 d4 02 00 00       	call   8004cc <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 f0 27 80 00       	push   $0x8027f0
  800202:	68 ef 27 80 00       	push   $0x8027ef
  800207:	e8 8f 1d 00 00       	call   801f9b <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 4a 21 00 00       	call   802366 <wait>
  80021c:	83 c4 10             	add    $0x10,%esp
  80021f:	eb ca                	jmp    8001eb <umain+0x18d>

00800221 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800221:	b8 00 00 00 00       	mov    $0x0,%eax
  800226:	c3                   	ret    

00800227 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80022d:	68 73 28 80 00       	push   $0x802873
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	e8 a0 09 00 00       	call   800bda <strcpy>
	return 0;
}
  80023a:	b8 00 00 00 00       	mov    $0x0,%eax
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <devcons_write>:
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80024d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800252:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800258:	3b 75 10             	cmp    0x10(%ebp),%esi
  80025b:	73 31                	jae    80028e <devcons_write+0x4d>
		m = n - tot;
  80025d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800260:	29 f3                	sub    %esi,%ebx
  800262:	83 fb 7f             	cmp    $0x7f,%ebx
  800265:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80026a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	53                   	push   %ebx
  800271:	89 f0                	mov    %esi,%eax
  800273:	03 45 0c             	add    0xc(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	57                   	push   %edi
  800278:	e8 eb 0a 00 00       	call   800d68 <memmove>
		sys_cputs(buf, m);
  80027d:	83 c4 08             	add    $0x8,%esp
  800280:	53                   	push   %ebx
  800281:	57                   	push   %edi
  800282:	e8 89 0c 00 00       	call   800f10 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800287:	01 de                	add    %ebx,%esi
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	eb ca                	jmp    800258 <devcons_write+0x17>
}
  80028e:	89 f0                	mov    %esi,%eax
  800290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800293:	5b                   	pop    %ebx
  800294:	5e                   	pop    %esi
  800295:	5f                   	pop    %edi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <devcons_read>:
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002a7:	74 21                	je     8002ca <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8002a9:	e8 80 0c 00 00       	call   800f2e <sys_cgetc>
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	75 07                	jne    8002b9 <devcons_read+0x21>
		sys_yield();
  8002b2:	e8 f6 0c 00 00       	call   800fad <sys_yield>
  8002b7:	eb f0                	jmp    8002a9 <devcons_read+0x11>
	if (c < 0)
  8002b9:	78 0f                	js     8002ca <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8002bb:	83 f8 04             	cmp    $0x4,%eax
  8002be:	74 0c                	je     8002cc <devcons_read+0x34>
	*(char*)vbuf = c;
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 02                	mov    %al,(%edx)
	return 1;
  8002c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    
		return 0;
  8002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d1:	eb f7                	jmp    8002ca <devcons_read+0x32>

008002d3 <cputchar>:
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002df:	6a 01                	push   $0x1
  8002e1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002e4:	50                   	push   %eax
  8002e5:	e8 26 0c 00 00       	call   800f10 <sys_cputs>
}
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <getchar>:
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002f5:	6a 01                	push   $0x1
  8002f7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002fa:	50                   	push   %eax
  8002fb:	6a 00                	push   $0x0
  8002fd:	e8 21 12 00 00       	call   801523 <read>
	if (r < 0)
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	85 c0                	test   %eax,%eax
  800307:	78 06                	js     80030f <getchar+0x20>
	if (r < 1)
  800309:	74 06                	je     800311 <getchar+0x22>
	return c;
  80030b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80030f:	c9                   	leave  
  800310:	c3                   	ret    
		return -E_EOF;
  800311:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800316:	eb f7                	jmp    80030f <getchar+0x20>

00800318 <iscons>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80031e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800321:	50                   	push   %eax
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	e8 8e 0f 00 00       	call   8012b8 <fd_lookup>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	78 11                	js     800342 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8b 15 70 47 80 00    	mov    0x804770,%edx
  80033a:	39 10                	cmp    %edx,(%eax)
  80033c:	0f 94 c0             	sete   %al
  80033f:	0f b6 c0             	movzbl %al,%eax
}
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <opencons>:
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80034a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	e8 13 0f 00 00       	call   801266 <fd_alloc>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	85 c0                	test   %eax,%eax
  800358:	78 3a                	js     800394 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	68 07 04 00 00       	push   $0x407
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	6a 00                	push   $0x0
  800367:	e8 60 0c 00 00       	call   800fcc <sys_page_alloc>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	85 c0                	test   %eax,%eax
  800371:	78 21                	js     800394 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	8b 15 70 47 80 00    	mov    0x804770,%edx
  80037c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80037e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800381:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 ae 0e 00 00       	call   80123f <fd2num>
  800391:	83 c4 10             	add    $0x10,%esp
}
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	56                   	push   %esi
  80039a:	53                   	push   %ebx
  80039b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80039e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003a1:	e8 e8 0b 00 00       	call   800f8e <sys_getenvid>
  8003a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003ab:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8003ae:	c1 e0 04             	shl    $0x4,%eax
  8003b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003b6:	a3 90 67 80 00       	mov    %eax,0x806790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	85 db                	test   %ebx,%ebx
  8003bd:	7e 07                	jle    8003c6 <libmain+0x30>
		binaryname = argv[0];
  8003bf:	8b 06                	mov    (%esi),%eax
  8003c1:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	56                   	push   %esi
  8003ca:	53                   	push   %ebx
  8003cb:	e8 8e fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003d0:	e8 0a 00 00 00       	call   8003df <exit>
}
  8003d5:	83 c4 10             	add    $0x10,%esp
  8003d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003db:	5b                   	pop    %ebx
  8003dc:	5e                   	pop    %esi
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8003e5:	6a 00                	push   $0x0
  8003e7:	e8 61 0b 00 00       	call   800f4d <sys_env_destroy>
}
  8003ec:	83 c4 10             	add    $0x10,%esp
  8003ef:	c9                   	leave  
  8003f0:	c3                   	ret    

008003f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
  8003f4:	56                   	push   %esi
  8003f5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003f6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f9:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  8003ff:	e8 8a 0b 00 00       	call   800f8e <sys_getenvid>
  800404:	83 ec 0c             	sub    $0xc,%esp
  800407:	ff 75 0c             	pushl  0xc(%ebp)
  80040a:	ff 75 08             	pushl  0x8(%ebp)
  80040d:	56                   	push   %esi
  80040e:	50                   	push   %eax
  80040f:	68 8c 28 80 00       	push   $0x80288c
  800414:	e8 b3 00 00 00       	call   8004cc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800419:	83 c4 18             	add    $0x18,%esp
  80041c:	53                   	push   %ebx
  80041d:	ff 75 10             	pushl  0x10(%ebp)
  800420:	e8 56 00 00 00       	call   80047b <vcprintf>
	cprintf("\n");
  800425:	c7 04 24 d8 2d 80 00 	movl   $0x802dd8,(%esp)
  80042c:	e8 9b 00 00 00       	call   8004cc <cprintf>
  800431:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800434:	cc                   	int3   
  800435:	eb fd                	jmp    800434 <_panic+0x43>

00800437 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800437:	55                   	push   %ebp
  800438:	89 e5                	mov    %esp,%ebp
  80043a:	53                   	push   %ebx
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800441:	8b 13                	mov    (%ebx),%edx
  800443:	8d 42 01             	lea    0x1(%edx),%eax
  800446:	89 03                	mov    %eax,(%ebx)
  800448:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80044b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80044f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800454:	74 09                	je     80045f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800456:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80045a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	68 ff 00 00 00       	push   $0xff
  800467:	8d 43 08             	lea    0x8(%ebx),%eax
  80046a:	50                   	push   %eax
  80046b:	e8 a0 0a 00 00       	call   800f10 <sys_cputs>
		b->idx = 0;
  800470:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	eb db                	jmp    800456 <putch+0x1f>

0080047b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
  80047e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800484:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80048b:	00 00 00 
	b.cnt = 0;
  80048e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800495:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800498:	ff 75 0c             	pushl  0xc(%ebp)
  80049b:	ff 75 08             	pushl  0x8(%ebp)
  80049e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a4:	50                   	push   %eax
  8004a5:	68 37 04 80 00       	push   $0x800437
  8004aa:	e8 4a 01 00 00       	call   8005f9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004af:	83 c4 08             	add    $0x8,%esp
  8004b2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004be:	50                   	push   %eax
  8004bf:	e8 4c 0a 00 00       	call   800f10 <sys_cputs>

	return b.cnt;
}
  8004c4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d5:	50                   	push   %eax
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	e8 9d ff ff ff       	call   80047b <vcprintf>
	va_end(ap);

	return cnt;
}
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	57                   	push   %edi
  8004e4:	56                   	push   %esi
  8004e5:	53                   	push   %ebx
  8004e6:	83 ec 1c             	sub    $0x1c,%esp
  8004e9:	89 c6                	mov    %eax,%esi
  8004eb:	89 d7                	mov    %edx,%edi
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004ff:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800503:	74 2c                	je     800531 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800505:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800508:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80050f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800512:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800515:	39 c2                	cmp    %eax,%edx
  800517:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80051a:	73 43                	jae    80055f <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051c:	83 eb 01             	sub    $0x1,%ebx
  80051f:	85 db                	test   %ebx,%ebx
  800521:	7e 6c                	jle    80058f <printnum+0xaf>
			putch(padc, putdat);
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	57                   	push   %edi
  800527:	ff 75 18             	pushl  0x18(%ebp)
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	eb eb                	jmp    80051c <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800531:	83 ec 0c             	sub    $0xc,%esp
  800534:	6a 20                	push   $0x20
  800536:	6a 00                	push   $0x0
  800538:	50                   	push   %eax
  800539:	ff 75 e4             	pushl  -0x1c(%ebp)
  80053c:	ff 75 e0             	pushl  -0x20(%ebp)
  80053f:	89 fa                	mov    %edi,%edx
  800541:	89 f0                	mov    %esi,%eax
  800543:	e8 98 ff ff ff       	call   8004e0 <printnum>
		while (--width > 0)
  800548:	83 c4 20             	add    $0x20,%esp
  80054b:	83 eb 01             	sub    $0x1,%ebx
  80054e:	85 db                	test   %ebx,%ebx
  800550:	7e 65                	jle    8005b7 <printnum+0xd7>
			putch(padc, putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	57                   	push   %edi
  800556:	6a 20                	push   $0x20
  800558:	ff d6                	call   *%esi
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	eb ec                	jmp    80054b <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	ff 75 18             	pushl  0x18(%ebp)
  800565:	83 eb 01             	sub    $0x1,%ebx
  800568:	53                   	push   %ebx
  800569:	50                   	push   %eax
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	ff 75 dc             	pushl  -0x24(%ebp)
  800570:	ff 75 d8             	pushl  -0x28(%ebp)
  800573:	ff 75 e4             	pushl  -0x1c(%ebp)
  800576:	ff 75 e0             	pushl  -0x20(%ebp)
  800579:	e8 72 1f 00 00       	call   8024f0 <__udivdi3>
  80057e:	83 c4 18             	add    $0x18,%esp
  800581:	52                   	push   %edx
  800582:	50                   	push   %eax
  800583:	89 fa                	mov    %edi,%edx
  800585:	89 f0                	mov    %esi,%eax
  800587:	e8 54 ff ff ff       	call   8004e0 <printnum>
  80058c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	57                   	push   %edi
  800593:	83 ec 04             	sub    $0x4,%esp
  800596:	ff 75 dc             	pushl  -0x24(%ebp)
  800599:	ff 75 d8             	pushl  -0x28(%ebp)
  80059c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059f:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a2:	e8 59 20 00 00       	call   802600 <__umoddi3>
  8005a7:	83 c4 14             	add    $0x14,%esp
  8005aa:	0f be 80 af 28 80 00 	movsbl 0x8028af(%eax),%eax
  8005b1:	50                   	push   %eax
  8005b2:	ff d6                	call   *%esi
  8005b4:	83 c4 10             	add    $0x10,%esp
}
  8005b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ba:	5b                   	pop    %ebx
  8005bb:	5e                   	pop    %esi
  8005bc:	5f                   	pop    %edi
  8005bd:	5d                   	pop    %ebp
  8005be:	c3                   	ret    

008005bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005c5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ce:	73 0a                	jae    8005da <sprintputch+0x1b>
		*b->buf++ = ch;
  8005d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005d3:	89 08                	mov    %ecx,(%eax)
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	88 02                	mov    %al,(%edx)
}
  8005da:	5d                   	pop    %ebp
  8005db:	c3                   	ret    

008005dc <printfmt>:
{
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005e2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005e5:	50                   	push   %eax
  8005e6:	ff 75 10             	pushl  0x10(%ebp)
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 08             	pushl  0x8(%ebp)
  8005ef:	e8 05 00 00 00       	call   8005f9 <vprintfmt>
}
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <vprintfmt>:
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	57                   	push   %edi
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 3c             	sub    $0x3c,%esp
  800602:	8b 75 08             	mov    0x8(%ebp),%esi
  800605:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800608:	8b 7d 10             	mov    0x10(%ebp),%edi
  80060b:	e9 b4 03 00 00       	jmp    8009c4 <vprintfmt+0x3cb>
		padc = ' ';
  800610:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800614:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80061b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800622:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800629:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800630:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800635:	8d 47 01             	lea    0x1(%edi),%eax
  800638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063b:	0f b6 17             	movzbl (%edi),%edx
  80063e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800641:	3c 55                	cmp    $0x55,%al
  800643:	0f 87 c8 04 00 00    	ja     800b11 <vprintfmt+0x518>
  800649:	0f b6 c0             	movzbl %al,%eax
  80064c:	ff 24 85 80 2a 80 00 	jmp    *0x802a80(,%eax,4)
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800656:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80065d:	eb d6                	jmp    800635 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80065f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800662:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800666:	eb cd                	jmp    800635 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800668:	0f b6 d2             	movzbl %dl,%edx
  80066b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80066e:	b8 00 00 00 00       	mov    $0x0,%eax
  800673:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800676:	eb 0c                	jmp    800684 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800678:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80067b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80067f:	eb b4                	jmp    800635 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800681:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800684:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800687:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80068b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80068e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800691:	83 f9 09             	cmp    $0x9,%ecx
  800694:	76 eb                	jbe    800681 <vprintfmt+0x88>
  800696:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800699:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069c:	eb 14                	jmp    8006b2 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b6:	0f 89 79 ff ff ff    	jns    800635 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8006bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006c9:	e9 67 ff ff ff       	jmp    800635 <vprintfmt+0x3c>
  8006ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	0f 49 d0             	cmovns %eax,%edx
  8006db:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006e1:	e9 4f ff ff ff       	jmp    800635 <vprintfmt+0x3c>
  8006e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006f0:	e9 40 ff ff ff       	jmp    800635 <vprintfmt+0x3c>
			lflag++;
  8006f5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006fb:	e9 35 ff ff ff       	jmp    800635 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 78 04             	lea    0x4(%eax),%edi
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	53                   	push   %ebx
  80070a:	ff 30                	pushl  (%eax)
  80070c:	ff d6                	call   *%esi
			break;
  80070e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800711:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800714:	e9 a8 02 00 00       	jmp    8009c1 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8d 78 04             	lea    0x4(%eax),%edi
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	99                   	cltd   
  800722:	31 d0                	xor    %edx,%eax
  800724:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800726:	83 f8 0f             	cmp    $0xf,%eax
  800729:	7f 23                	jg     80074e <vprintfmt+0x155>
  80072b:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  800732:	85 d2                	test   %edx,%edx
  800734:	74 18                	je     80074e <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800736:	52                   	push   %edx
  800737:	68 f1 2c 80 00       	push   $0x802cf1
  80073c:	53                   	push   %ebx
  80073d:	56                   	push   %esi
  80073e:	e8 99 fe ff ff       	call   8005dc <printfmt>
  800743:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800746:	89 7d 14             	mov    %edi,0x14(%ebp)
  800749:	e9 73 02 00 00       	jmp    8009c1 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80074e:	50                   	push   %eax
  80074f:	68 c7 28 80 00       	push   $0x8028c7
  800754:	53                   	push   %ebx
  800755:	56                   	push   %esi
  800756:	e8 81 fe ff ff       	call   8005dc <printfmt>
  80075b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80075e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800761:	e9 5b 02 00 00       	jmp    8009c1 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	83 c0 04             	add    $0x4,%eax
  80076c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800774:	85 d2                	test   %edx,%edx
  800776:	b8 c0 28 80 00       	mov    $0x8028c0,%eax
  80077b:	0f 45 c2             	cmovne %edx,%eax
  80077e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800781:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800785:	7e 06                	jle    80078d <vprintfmt+0x194>
  800787:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80078b:	75 0d                	jne    80079a <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  80078d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800790:	89 c7                	mov    %eax,%edi
  800792:	03 45 e0             	add    -0x20(%ebp),%eax
  800795:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800798:	eb 53                	jmp    8007ed <vprintfmt+0x1f4>
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a0:	50                   	push   %eax
  8007a1:	e8 13 04 00 00       	call   800bb9 <strnlen>
  8007a6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007a9:	29 c1                	sub    %eax,%ecx
  8007ab:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007b3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ba:	eb 0f                	jmp    8007cb <vprintfmt+0x1d2>
					putch(padc, putdat);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	53                   	push   %ebx
  8007c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c5:	83 ef 01             	sub    $0x1,%edi
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	85 ff                	test   %edi,%edi
  8007cd:	7f ed                	jg     8007bc <vprintfmt+0x1c3>
  8007cf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007d2:	85 d2                	test   %edx,%edx
  8007d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d9:	0f 49 c2             	cmovns %edx,%eax
  8007dc:	29 c2                	sub    %eax,%edx
  8007de:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007e1:	eb aa                	jmp    80078d <vprintfmt+0x194>
					putch(ch, putdat);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	53                   	push   %ebx
  8007e7:	52                   	push   %edx
  8007e8:	ff d6                	call   *%esi
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007f0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f2:	83 c7 01             	add    $0x1,%edi
  8007f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f9:	0f be d0             	movsbl %al,%edx
  8007fc:	85 d2                	test   %edx,%edx
  8007fe:	74 4b                	je     80084b <vprintfmt+0x252>
  800800:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800804:	78 06                	js     80080c <vprintfmt+0x213>
  800806:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80080a:	78 1e                	js     80082a <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80080c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800810:	74 d1                	je     8007e3 <vprintfmt+0x1ea>
  800812:	0f be c0             	movsbl %al,%eax
  800815:	83 e8 20             	sub    $0x20,%eax
  800818:	83 f8 5e             	cmp    $0x5e,%eax
  80081b:	76 c6                	jbe    8007e3 <vprintfmt+0x1ea>
					putch('?', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	53                   	push   %ebx
  800821:	6a 3f                	push   $0x3f
  800823:	ff d6                	call   *%esi
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	eb c3                	jmp    8007ed <vprintfmt+0x1f4>
  80082a:	89 cf                	mov    %ecx,%edi
  80082c:	eb 0e                	jmp    80083c <vprintfmt+0x243>
				putch(' ', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	53                   	push   %ebx
  800832:	6a 20                	push   $0x20
  800834:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800836:	83 ef 01             	sub    $0x1,%edi
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	85 ff                	test   %edi,%edi
  80083e:	7f ee                	jg     80082e <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800840:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	e9 76 01 00 00       	jmp    8009c1 <vprintfmt+0x3c8>
  80084b:	89 cf                	mov    %ecx,%edi
  80084d:	eb ed                	jmp    80083c <vprintfmt+0x243>
	if (lflag >= 2)
  80084f:	83 f9 01             	cmp    $0x1,%ecx
  800852:	7f 1f                	jg     800873 <vprintfmt+0x27a>
	else if (lflag)
  800854:	85 c9                	test   %ecx,%ecx
  800856:	74 6a                	je     8008c2 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800860:	89 c1                	mov    %eax,%ecx
  800862:	c1 f9 1f             	sar    $0x1f,%ecx
  800865:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 40 04             	lea    0x4(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
  800871:	eb 17                	jmp    80088a <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 50 04             	mov    0x4(%eax),%edx
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8d 40 08             	lea    0x8(%eax),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80088a:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80088d:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800892:	85 d2                	test   %edx,%edx
  800894:	0f 89 f8 00 00 00    	jns    800992 <vprintfmt+0x399>
				putch('-', putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	53                   	push   %ebx
  80089e:	6a 2d                	push   $0x2d
  8008a0:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8008a8:	f7 d8                	neg    %eax
  8008aa:	83 d2 00             	adc    $0x0,%edx
  8008ad:	f7 da                	neg    %edx
  8008af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008bd:	e9 e1 00 00 00       	jmp    8009a3 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ca:	99                   	cltd   
  8008cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8d 40 04             	lea    0x4(%eax),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	eb b1                	jmp    80088a <vprintfmt+0x291>
	if (lflag >= 2)
  8008d9:	83 f9 01             	cmp    $0x1,%ecx
  8008dc:	7f 27                	jg     800905 <vprintfmt+0x30c>
	else if (lflag)
  8008de:	85 c9                	test   %ecx,%ecx
  8008e0:	74 41                	je     800923 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8d 40 04             	lea    0x4(%eax),%eax
  8008f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008fb:	bf 0a 00 00 00       	mov    $0xa,%edi
  800900:	e9 8d 00 00 00       	jmp    800992 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8b 50 04             	mov    0x4(%eax),%edx
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800910:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8d 40 08             	lea    0x8(%eax),%eax
  800919:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80091c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800921:	eb 6f                	jmp    800992 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	ba 00 00 00 00       	mov    $0x0,%edx
  80092d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800930:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8d 40 04             	lea    0x4(%eax),%eax
  800939:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80093c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800941:	eb 4f                	jmp    800992 <vprintfmt+0x399>
	if (lflag >= 2)
  800943:	83 f9 01             	cmp    $0x1,%ecx
  800946:	7f 23                	jg     80096b <vprintfmt+0x372>
	else if (lflag)
  800948:	85 c9                	test   %ecx,%ecx
  80094a:	0f 84 98 00 00 00    	je     8009e8 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	ba 00 00 00 00       	mov    $0x0,%edx
  80095a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8d 40 04             	lea    0x4(%eax),%eax
  800966:	89 45 14             	mov    %eax,0x14(%ebp)
  800969:	eb 17                	jmp    800982 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8b 50 04             	mov    0x4(%eax),%edx
  800971:	8b 00                	mov    (%eax),%eax
  800973:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800976:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	8d 40 08             	lea    0x8(%eax),%eax
  80097f:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800982:	83 ec 08             	sub    $0x8,%esp
  800985:	53                   	push   %ebx
  800986:	6a 30                	push   $0x30
  800988:	ff d6                	call   *%esi
			goto number;
  80098a:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80098d:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800992:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800996:	74 0b                	je     8009a3 <vprintfmt+0x3aa>
				putch('+', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	53                   	push   %ebx
  80099c:	6a 2b                	push   $0x2b
  80099e:	ff d6                	call   *%esi
  8009a0:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8009ae:	57                   	push   %edi
  8009af:	ff 75 dc             	pushl  -0x24(%ebp)
  8009b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8009b5:	89 da                	mov    %ebx,%edx
  8009b7:	89 f0                	mov    %esi,%eax
  8009b9:	e8 22 fb ff ff       	call   8004e0 <printnum>
			break;
  8009be:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c4:	83 c7 01             	add    $0x1,%edi
  8009c7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009cb:	83 f8 25             	cmp    $0x25,%eax
  8009ce:	0f 84 3c fc ff ff    	je     800610 <vprintfmt+0x17>
			if (ch == '\0')
  8009d4:	85 c0                	test   %eax,%eax
  8009d6:	0f 84 55 01 00 00    	je     800b31 <vprintfmt+0x538>
			putch(ch, putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	53                   	push   %ebx
  8009e0:	50                   	push   %eax
  8009e1:	ff d6                	call   *%esi
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	eb dc                	jmp    8009c4 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	8d 40 04             	lea    0x4(%eax),%eax
  8009fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800a01:	e9 7c ff ff ff       	jmp    800982 <vprintfmt+0x389>
			putch('0', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	53                   	push   %ebx
  800a0a:	6a 30                	push   $0x30
  800a0c:	ff d6                	call   *%esi
			putch('x', putdat);
  800a0e:	83 c4 08             	add    $0x8,%esp
  800a11:	53                   	push   %ebx
  800a12:	6a 78                	push   $0x78
  800a14:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a20:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a23:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a26:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	8d 40 04             	lea    0x4(%eax),%eax
  800a2f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a32:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800a37:	e9 56 ff ff ff       	jmp    800992 <vprintfmt+0x399>
	if (lflag >= 2)
  800a3c:	83 f9 01             	cmp    $0x1,%ecx
  800a3f:	7f 27                	jg     800a68 <vprintfmt+0x46f>
	else if (lflag)
  800a41:	85 c9                	test   %ecx,%ecx
  800a43:	74 44                	je     800a89 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a52:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	8d 40 04             	lea    0x4(%eax),%eax
  800a5b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5e:	bf 10 00 00 00       	mov    $0x10,%edi
  800a63:	e9 2a ff ff ff       	jmp    800992 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	8b 50 04             	mov    0x4(%eax),%edx
  800a6e:	8b 00                	mov    (%eax),%eax
  800a70:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a73:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	8d 40 08             	lea    0x8(%eax),%eax
  800a7c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a7f:	bf 10 00 00 00       	mov    $0x10,%edi
  800a84:	e9 09 ff ff ff       	jmp    800992 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800a89:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8c:	8b 00                	mov    (%eax),%eax
  800a8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a93:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a96:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a99:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9c:	8d 40 04             	lea    0x4(%eax),%eax
  800a9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa2:	bf 10 00 00 00       	mov    $0x10,%edi
  800aa7:	e9 e6 fe ff ff       	jmp    800992 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	8d 78 04             	lea    0x4(%eax),%edi
  800ab2:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800ab4:	85 c0                	test   %eax,%eax
  800ab6:	74 2d                	je     800ae5 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800ab8:	0f b6 13             	movzbl (%ebx),%edx
  800abb:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800abd:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800ac0:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800ac3:	0f 8e f8 fe ff ff    	jle    8009c1 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800ac9:	68 1c 2a 80 00       	push   $0x802a1c
  800ace:	68 f1 2c 80 00       	push   $0x802cf1
  800ad3:	53                   	push   %ebx
  800ad4:	56                   	push   %esi
  800ad5:	e8 02 fb ff ff       	call   8005dc <printfmt>
  800ada:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800add:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ae0:	e9 dc fe ff ff       	jmp    8009c1 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800ae5:	68 e4 29 80 00       	push   $0x8029e4
  800aea:	68 f1 2c 80 00       	push   $0x802cf1
  800aef:	53                   	push   %ebx
  800af0:	56                   	push   %esi
  800af1:	e8 e6 fa ff ff       	call   8005dc <printfmt>
  800af6:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800af9:	89 7d 14             	mov    %edi,0x14(%ebp)
  800afc:	e9 c0 fe ff ff       	jmp    8009c1 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	53                   	push   %ebx
  800b05:	6a 25                	push   $0x25
  800b07:	ff d6                	call   *%esi
			break;
  800b09:	83 c4 10             	add    $0x10,%esp
  800b0c:	e9 b0 fe ff ff       	jmp    8009c1 <vprintfmt+0x3c8>
			putch('%', putdat);
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	53                   	push   %ebx
  800b15:	6a 25                	push   $0x25
  800b17:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	89 f8                	mov    %edi,%eax
  800b1e:	eb 03                	jmp    800b23 <vprintfmt+0x52a>
  800b20:	83 e8 01             	sub    $0x1,%eax
  800b23:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b27:	75 f7                	jne    800b20 <vprintfmt+0x527>
  800b29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b2c:	e9 90 fe ff ff       	jmp    8009c1 <vprintfmt+0x3c8>
}
  800b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	83 ec 18             	sub    $0x18,%esp
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b45:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b48:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b4c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b56:	85 c0                	test   %eax,%eax
  800b58:	74 26                	je     800b80 <vsnprintf+0x47>
  800b5a:	85 d2                	test   %edx,%edx
  800b5c:	7e 22                	jle    800b80 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5e:	ff 75 14             	pushl  0x14(%ebp)
  800b61:	ff 75 10             	pushl  0x10(%ebp)
  800b64:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b67:	50                   	push   %eax
  800b68:	68 bf 05 80 00       	push   $0x8005bf
  800b6d:	e8 87 fa ff ff       	call   8005f9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b75:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
}
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    
		return -E_INVAL;
  800b80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b85:	eb f7                	jmp    800b7e <vsnprintf+0x45>

00800b87 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b90:	50                   	push   %eax
  800b91:	ff 75 10             	pushl  0x10(%ebp)
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	ff 75 08             	pushl  0x8(%ebp)
  800b9a:	e8 9a ff ff ff       	call   800b39 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bb0:	74 05                	je     800bb7 <strlen+0x16>
		n++;
  800bb2:	83 c0 01             	add    $0x1,%eax
  800bb5:	eb f5                	jmp    800bac <strlen+0xb>
	return n;
}
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc7:	39 c2                	cmp    %eax,%edx
  800bc9:	74 0d                	je     800bd8 <strnlen+0x1f>
  800bcb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bcf:	74 05                	je     800bd6 <strnlen+0x1d>
		n++;
  800bd1:	83 c2 01             	add    $0x1,%edx
  800bd4:	eb f1                	jmp    800bc7 <strnlen+0xe>
  800bd6:	89 d0                	mov    %edx,%eax
	return n;
}
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	53                   	push   %ebx
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
  800be9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bf0:	83 c2 01             	add    $0x1,%edx
  800bf3:	84 c9                	test   %cl,%cl
  800bf5:	75 f2                	jne    800be9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bf7:	5b                   	pop    %ebx
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	53                   	push   %ebx
  800bfe:	83 ec 10             	sub    $0x10,%esp
  800c01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c04:	53                   	push   %ebx
  800c05:	e8 97 ff ff ff       	call   800ba1 <strlen>
  800c0a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	01 d8                	add    %ebx,%eax
  800c12:	50                   	push   %eax
  800c13:	e8 c2 ff ff ff       	call   800bda <strcpy>
	return dst;
}
  800c18:	89 d8                	mov    %ebx,%eax
  800c1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2a:	89 c6                	mov    %eax,%esi
  800c2c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c2f:	89 c2                	mov    %eax,%edx
  800c31:	39 f2                	cmp    %esi,%edx
  800c33:	74 11                	je     800c46 <strncpy+0x27>
		*dst++ = *src;
  800c35:	83 c2 01             	add    $0x1,%edx
  800c38:	0f b6 19             	movzbl (%ecx),%ebx
  800c3b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c3e:	80 fb 01             	cmp    $0x1,%bl
  800c41:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c44:	eb eb                	jmp    800c31 <strncpy+0x12>
	}
	return ret;
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	8b 75 08             	mov    0x8(%ebp),%esi
  800c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c55:	8b 55 10             	mov    0x10(%ebp),%edx
  800c58:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c5a:	85 d2                	test   %edx,%edx
  800c5c:	74 21                	je     800c7f <strlcpy+0x35>
  800c5e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c62:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c64:	39 c2                	cmp    %eax,%edx
  800c66:	74 14                	je     800c7c <strlcpy+0x32>
  800c68:	0f b6 19             	movzbl (%ecx),%ebx
  800c6b:	84 db                	test   %bl,%bl
  800c6d:	74 0b                	je     800c7a <strlcpy+0x30>
			*dst++ = *src++;
  800c6f:	83 c1 01             	add    $0x1,%ecx
  800c72:	83 c2 01             	add    $0x1,%edx
  800c75:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c78:	eb ea                	jmp    800c64 <strlcpy+0x1a>
  800c7a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c7c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c7f:	29 f0                	sub    %esi,%eax
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c8e:	0f b6 01             	movzbl (%ecx),%eax
  800c91:	84 c0                	test   %al,%al
  800c93:	74 0c                	je     800ca1 <strcmp+0x1c>
  800c95:	3a 02                	cmp    (%edx),%al
  800c97:	75 08                	jne    800ca1 <strcmp+0x1c>
		p++, q++;
  800c99:	83 c1 01             	add    $0x1,%ecx
  800c9c:	83 c2 01             	add    $0x1,%edx
  800c9f:	eb ed                	jmp    800c8e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca1:	0f b6 c0             	movzbl %al,%eax
  800ca4:	0f b6 12             	movzbl (%edx),%edx
  800ca7:	29 d0                	sub    %edx,%eax
}
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	53                   	push   %ebx
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	89 c3                	mov    %eax,%ebx
  800cb7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cba:	eb 06                	jmp    800cc2 <strncmp+0x17>
		n--, p++, q++;
  800cbc:	83 c0 01             	add    $0x1,%eax
  800cbf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cc2:	39 d8                	cmp    %ebx,%eax
  800cc4:	74 16                	je     800cdc <strncmp+0x31>
  800cc6:	0f b6 08             	movzbl (%eax),%ecx
  800cc9:	84 c9                	test   %cl,%cl
  800ccb:	74 04                	je     800cd1 <strncmp+0x26>
  800ccd:	3a 0a                	cmp    (%edx),%cl
  800ccf:	74 eb                	je     800cbc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd1:	0f b6 00             	movzbl (%eax),%eax
  800cd4:	0f b6 12             	movzbl (%edx),%edx
  800cd7:	29 d0                	sub    %edx,%eax
}
  800cd9:	5b                   	pop    %ebx
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    
		return 0;
  800cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce1:	eb f6                	jmp    800cd9 <strncmp+0x2e>

00800ce3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ced:	0f b6 10             	movzbl (%eax),%edx
  800cf0:	84 d2                	test   %dl,%dl
  800cf2:	74 09                	je     800cfd <strchr+0x1a>
		if (*s == c)
  800cf4:	38 ca                	cmp    %cl,%dl
  800cf6:	74 0a                	je     800d02 <strchr+0x1f>
	for (; *s; s++)
  800cf8:	83 c0 01             	add    $0x1,%eax
  800cfb:	eb f0                	jmp    800ced <strchr+0xa>
			return (char *) s;
	return 0;
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d0e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d11:	38 ca                	cmp    %cl,%dl
  800d13:	74 09                	je     800d1e <strfind+0x1a>
  800d15:	84 d2                	test   %dl,%dl
  800d17:	74 05                	je     800d1e <strfind+0x1a>
	for (; *s; s++)
  800d19:	83 c0 01             	add    $0x1,%eax
  800d1c:	eb f0                	jmp    800d0e <strfind+0xa>
			break;
	return (char *) s;
}
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
  800d26:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d29:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d2c:	85 c9                	test   %ecx,%ecx
  800d2e:	74 31                	je     800d61 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d30:	89 f8                	mov    %edi,%eax
  800d32:	09 c8                	or     %ecx,%eax
  800d34:	a8 03                	test   $0x3,%al
  800d36:	75 23                	jne    800d5b <memset+0x3b>
		c &= 0xFF;
  800d38:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d3c:	89 d3                	mov    %edx,%ebx
  800d3e:	c1 e3 08             	shl    $0x8,%ebx
  800d41:	89 d0                	mov    %edx,%eax
  800d43:	c1 e0 18             	shl    $0x18,%eax
  800d46:	89 d6                	mov    %edx,%esi
  800d48:	c1 e6 10             	shl    $0x10,%esi
  800d4b:	09 f0                	or     %esi,%eax
  800d4d:	09 c2                	or     %eax,%edx
  800d4f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d51:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d54:	89 d0                	mov    %edx,%eax
  800d56:	fc                   	cld    
  800d57:	f3 ab                	rep stos %eax,%es:(%edi)
  800d59:	eb 06                	jmp    800d61 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	fc                   	cld    
  800d5f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d61:	89 f8                	mov    %edi,%eax
  800d63:	5b                   	pop    %ebx
  800d64:	5e                   	pop    %esi
  800d65:	5f                   	pop    %edi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d73:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d76:	39 c6                	cmp    %eax,%esi
  800d78:	73 32                	jae    800dac <memmove+0x44>
  800d7a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d7d:	39 c2                	cmp    %eax,%edx
  800d7f:	76 2b                	jbe    800dac <memmove+0x44>
		s += n;
		d += n;
  800d81:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d84:	89 fe                	mov    %edi,%esi
  800d86:	09 ce                	or     %ecx,%esi
  800d88:	09 d6                	or     %edx,%esi
  800d8a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d90:	75 0e                	jne    800da0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d92:	83 ef 04             	sub    $0x4,%edi
  800d95:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d98:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d9b:	fd                   	std    
  800d9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d9e:	eb 09                	jmp    800da9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800da0:	83 ef 01             	sub    $0x1,%edi
  800da3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800da6:	fd                   	std    
  800da7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800da9:	fc                   	cld    
  800daa:	eb 1a                	jmp    800dc6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dac:	89 c2                	mov    %eax,%edx
  800dae:	09 ca                	or     %ecx,%edx
  800db0:	09 f2                	or     %esi,%edx
  800db2:	f6 c2 03             	test   $0x3,%dl
  800db5:	75 0a                	jne    800dc1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800db7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dba:	89 c7                	mov    %eax,%edi
  800dbc:	fc                   	cld    
  800dbd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dbf:	eb 05                	jmp    800dc6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800dc1:	89 c7                	mov    %eax,%edi
  800dc3:	fc                   	cld    
  800dc4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dd0:	ff 75 10             	pushl  0x10(%ebp)
  800dd3:	ff 75 0c             	pushl  0xc(%ebp)
  800dd6:	ff 75 08             	pushl  0x8(%ebp)
  800dd9:	e8 8a ff ff ff       	call   800d68 <memmove>
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800deb:	89 c6                	mov    %eax,%esi
  800ded:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800df0:	39 f0                	cmp    %esi,%eax
  800df2:	74 1c                	je     800e10 <memcmp+0x30>
		if (*s1 != *s2)
  800df4:	0f b6 08             	movzbl (%eax),%ecx
  800df7:	0f b6 1a             	movzbl (%edx),%ebx
  800dfa:	38 d9                	cmp    %bl,%cl
  800dfc:	75 08                	jne    800e06 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dfe:	83 c0 01             	add    $0x1,%eax
  800e01:	83 c2 01             	add    $0x1,%edx
  800e04:	eb ea                	jmp    800df0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e06:	0f b6 c1             	movzbl %cl,%eax
  800e09:	0f b6 db             	movzbl %bl,%ebx
  800e0c:	29 d8                	sub    %ebx,%eax
  800e0e:	eb 05                	jmp    800e15 <memcmp+0x35>
	}

	return 0;
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e22:	89 c2                	mov    %eax,%edx
  800e24:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e27:	39 d0                	cmp    %edx,%eax
  800e29:	73 09                	jae    800e34 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2b:	38 08                	cmp    %cl,(%eax)
  800e2d:	74 05                	je     800e34 <memfind+0x1b>
	for (; s < ends; s++)
  800e2f:	83 c0 01             	add    $0x1,%eax
  800e32:	eb f3                	jmp    800e27 <memfind+0xe>
			break;
	return (void *) s;
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e42:	eb 03                	jmp    800e47 <strtol+0x11>
		s++;
  800e44:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e47:	0f b6 01             	movzbl (%ecx),%eax
  800e4a:	3c 20                	cmp    $0x20,%al
  800e4c:	74 f6                	je     800e44 <strtol+0xe>
  800e4e:	3c 09                	cmp    $0x9,%al
  800e50:	74 f2                	je     800e44 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e52:	3c 2b                	cmp    $0x2b,%al
  800e54:	74 2a                	je     800e80 <strtol+0x4a>
	int neg = 0;
  800e56:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e5b:	3c 2d                	cmp    $0x2d,%al
  800e5d:	74 2b                	je     800e8a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e5f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e65:	75 0f                	jne    800e76 <strtol+0x40>
  800e67:	80 39 30             	cmpb   $0x30,(%ecx)
  800e6a:	74 28                	je     800e94 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e6c:	85 db                	test   %ebx,%ebx
  800e6e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e73:	0f 44 d8             	cmove  %eax,%ebx
  800e76:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e7e:	eb 50                	jmp    800ed0 <strtol+0x9a>
		s++;
  800e80:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e83:	bf 00 00 00 00       	mov    $0x0,%edi
  800e88:	eb d5                	jmp    800e5f <strtol+0x29>
		s++, neg = 1;
  800e8a:	83 c1 01             	add    $0x1,%ecx
  800e8d:	bf 01 00 00 00       	mov    $0x1,%edi
  800e92:	eb cb                	jmp    800e5f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e94:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e98:	74 0e                	je     800ea8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e9a:	85 db                	test   %ebx,%ebx
  800e9c:	75 d8                	jne    800e76 <strtol+0x40>
		s++, base = 8;
  800e9e:	83 c1 01             	add    $0x1,%ecx
  800ea1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ea6:	eb ce                	jmp    800e76 <strtol+0x40>
		s += 2, base = 16;
  800ea8:	83 c1 02             	add    $0x2,%ecx
  800eab:	bb 10 00 00 00       	mov    $0x10,%ebx
  800eb0:	eb c4                	jmp    800e76 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800eb2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800eb5:	89 f3                	mov    %esi,%ebx
  800eb7:	80 fb 19             	cmp    $0x19,%bl
  800eba:	77 29                	ja     800ee5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ebc:	0f be d2             	movsbl %dl,%edx
  800ebf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ec2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ec5:	7d 30                	jge    800ef7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ec7:	83 c1 01             	add    $0x1,%ecx
  800eca:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ece:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ed0:	0f b6 11             	movzbl (%ecx),%edx
  800ed3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ed6:	89 f3                	mov    %esi,%ebx
  800ed8:	80 fb 09             	cmp    $0x9,%bl
  800edb:	77 d5                	ja     800eb2 <strtol+0x7c>
			dig = *s - '0';
  800edd:	0f be d2             	movsbl %dl,%edx
  800ee0:	83 ea 30             	sub    $0x30,%edx
  800ee3:	eb dd                	jmp    800ec2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ee5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ee8:	89 f3                	mov    %esi,%ebx
  800eea:	80 fb 19             	cmp    $0x19,%bl
  800eed:	77 08                	ja     800ef7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800eef:	0f be d2             	movsbl %dl,%edx
  800ef2:	83 ea 37             	sub    $0x37,%edx
  800ef5:	eb cb                	jmp    800ec2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ef7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800efb:	74 05                	je     800f02 <strtol+0xcc>
		*endptr = (char *) s;
  800efd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f00:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f02:	89 c2                	mov    %eax,%edx
  800f04:	f7 da                	neg    %edx
  800f06:	85 ff                	test   %edi,%edi
  800f08:	0f 45 c2             	cmovne %edx,%eax
}
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f16:	b8 00 00 00 00       	mov    $0x0,%eax
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f21:	89 c3                	mov    %eax,%ebx
  800f23:	89 c7                	mov    %eax,%edi
  800f25:	89 c6                	mov    %eax,%esi
  800f27:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <sys_cgetc>:

int
sys_cgetc(void)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f34:	ba 00 00 00 00       	mov    $0x0,%edx
  800f39:	b8 01 00 00 00       	mov    $0x1,%eax
  800f3e:	89 d1                	mov    %edx,%ecx
  800f40:	89 d3                	mov    %edx,%ebx
  800f42:	89 d7                	mov    %edx,%edi
  800f44:	89 d6                	mov    %edx,%esi
  800f46:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	5f                   	pop    %edi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	57                   	push   %edi
  800f51:	56                   	push   %esi
  800f52:	53                   	push   %ebx
  800f53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5e:	b8 03 00 00 00       	mov    $0x3,%eax
  800f63:	89 cb                	mov    %ecx,%ebx
  800f65:	89 cf                	mov    %ecx,%edi
  800f67:	89 ce                	mov    %ecx,%esi
  800f69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	7f 08                	jg     800f77 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f77:	83 ec 0c             	sub    $0xc,%esp
  800f7a:	50                   	push   %eax
  800f7b:	6a 03                	push   $0x3
  800f7d:	68 20 2c 80 00       	push   $0x802c20
  800f82:	6a 33                	push   $0x33
  800f84:	68 3d 2c 80 00       	push   $0x802c3d
  800f89:	e8 63 f4 ff ff       	call   8003f1 <_panic>

00800f8e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f94:	ba 00 00 00 00       	mov    $0x0,%edx
  800f99:	b8 02 00 00 00       	mov    $0x2,%eax
  800f9e:	89 d1                	mov    %edx,%ecx
  800fa0:	89 d3                	mov    %edx,%ebx
  800fa2:	89 d7                	mov    %edx,%edi
  800fa4:	89 d6                	mov    %edx,%esi
  800fa6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_yield>:

void
sys_yield(void)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fbd:	89 d1                	mov    %edx,%ecx
  800fbf:	89 d3                	mov    %edx,%ebx
  800fc1:	89 d7                	mov    %edx,%edi
  800fc3:	89 d6                	mov    %edx,%esi
  800fc5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
  800fd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd5:	be 00 00 00 00       	mov    $0x0,%esi
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	b8 04 00 00 00       	mov    $0x4,%eax
  800fe5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe8:	89 f7                	mov    %esi,%edi
  800fea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7f 08                	jg     800ff8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	50                   	push   %eax
  800ffc:	6a 04                	push   $0x4
  800ffe:	68 20 2c 80 00       	push   $0x802c20
  801003:	6a 33                	push   $0x33
  801005:	68 3d 2c 80 00       	push   $0x802c3d
  80100a:	e8 e2 f3 ff ff       	call   8003f1 <_panic>

0080100f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
  801015:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801018:	8b 55 08             	mov    0x8(%ebp),%edx
  80101b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101e:	b8 05 00 00 00       	mov    $0x5,%eax
  801023:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801026:	8b 7d 14             	mov    0x14(%ebp),%edi
  801029:	8b 75 18             	mov    0x18(%ebp),%esi
  80102c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102e:	85 c0                	test   %eax,%eax
  801030:	7f 08                	jg     80103a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801032:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103a:	83 ec 0c             	sub    $0xc,%esp
  80103d:	50                   	push   %eax
  80103e:	6a 05                	push   $0x5
  801040:	68 20 2c 80 00       	push   $0x802c20
  801045:	6a 33                	push   $0x33
  801047:	68 3d 2c 80 00       	push   $0x802c3d
  80104c:	e8 a0 f3 ff ff       	call   8003f1 <_panic>

00801051 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	57                   	push   %edi
  801055:	56                   	push   %esi
  801056:	53                   	push   %ebx
  801057:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801065:	b8 06 00 00 00       	mov    $0x6,%eax
  80106a:	89 df                	mov    %ebx,%edi
  80106c:	89 de                	mov    %ebx,%esi
  80106e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801070:	85 c0                	test   %eax,%eax
  801072:	7f 08                	jg     80107c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801074:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801077:	5b                   	pop    %ebx
  801078:	5e                   	pop    %esi
  801079:	5f                   	pop    %edi
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80107c:	83 ec 0c             	sub    $0xc,%esp
  80107f:	50                   	push   %eax
  801080:	6a 06                	push   $0x6
  801082:	68 20 2c 80 00       	push   $0x802c20
  801087:	6a 33                	push   $0x33
  801089:	68 3d 2c 80 00       	push   $0x802c3d
  80108e:	e8 5e f3 ff ff       	call   8003f1 <_panic>

00801093 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	57                   	push   %edi
  801097:	56                   	push   %esi
  801098:	53                   	push   %ebx
  801099:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80109c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a4:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010a9:	89 cb                	mov    %ecx,%ebx
  8010ab:	89 cf                	mov    %ecx,%edi
  8010ad:	89 ce                	mov    %ecx,%esi
  8010af:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	7f 08                	jg     8010bd <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  8010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b8:	5b                   	pop    %ebx
  8010b9:	5e                   	pop    %esi
  8010ba:	5f                   	pop    %edi
  8010bb:	5d                   	pop    %ebp
  8010bc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bd:	83 ec 0c             	sub    $0xc,%esp
  8010c0:	50                   	push   %eax
  8010c1:	6a 0b                	push   $0xb
  8010c3:	68 20 2c 80 00       	push   $0x802c20
  8010c8:	6a 33                	push   $0x33
  8010ca:	68 3d 2c 80 00       	push   $0x802c3d
  8010cf:	e8 1d f3 ff ff       	call   8003f1 <_panic>

008010d4 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	57                   	push   %edi
  8010d8:	56                   	push   %esi
  8010d9:	53                   	push   %ebx
  8010da:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8010ed:	89 df                	mov    %ebx,%edi
  8010ef:	89 de                	mov    %ebx,%esi
  8010f1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	7f 08                	jg     8010ff <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fa:	5b                   	pop    %ebx
  8010fb:	5e                   	pop    %esi
  8010fc:	5f                   	pop    %edi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ff:	83 ec 0c             	sub    $0xc,%esp
  801102:	50                   	push   %eax
  801103:	6a 08                	push   $0x8
  801105:	68 20 2c 80 00       	push   $0x802c20
  80110a:	6a 33                	push   $0x33
  80110c:	68 3d 2c 80 00       	push   $0x802c3d
  801111:	e8 db f2 ff ff       	call   8003f1 <_panic>

00801116 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	57                   	push   %edi
  80111a:	56                   	push   %esi
  80111b:	53                   	push   %ebx
  80111c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80111f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801124:	8b 55 08             	mov    0x8(%ebp),%edx
  801127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112a:	b8 09 00 00 00       	mov    $0x9,%eax
  80112f:	89 df                	mov    %ebx,%edi
  801131:	89 de                	mov    %ebx,%esi
  801133:	cd 30                	int    $0x30
	if(check && ret > 0)
  801135:	85 c0                	test   %eax,%eax
  801137:	7f 08                	jg     801141 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801139:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	50                   	push   %eax
  801145:	6a 09                	push   $0x9
  801147:	68 20 2c 80 00       	push   $0x802c20
  80114c:	6a 33                	push   $0x33
  80114e:	68 3d 2c 80 00       	push   $0x802c3d
  801153:	e8 99 f2 ff ff       	call   8003f1 <_panic>

00801158 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
  80115e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801161:	bb 00 00 00 00       	mov    $0x0,%ebx
  801166:	8b 55 08             	mov    0x8(%ebp),%edx
  801169:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801171:	89 df                	mov    %ebx,%edi
  801173:	89 de                	mov    %ebx,%esi
  801175:	cd 30                	int    $0x30
	if(check && ret > 0)
  801177:	85 c0                	test   %eax,%eax
  801179:	7f 08                	jg     801183 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80117b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117e:	5b                   	pop    %ebx
  80117f:	5e                   	pop    %esi
  801180:	5f                   	pop    %edi
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801183:	83 ec 0c             	sub    $0xc,%esp
  801186:	50                   	push   %eax
  801187:	6a 0a                	push   $0xa
  801189:	68 20 2c 80 00       	push   $0x802c20
  80118e:	6a 33                	push   $0x33
  801190:	68 3d 2c 80 00       	push   $0x802c3d
  801195:	e8 57 f2 ff ff       	call   8003f1 <_panic>

0080119a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011ab:	be 00 00 00 00       	mov    $0x0,%esi
  8011b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011b3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011b8:	5b                   	pop    %ebx
  8011b9:	5e                   	pop    %esi
  8011ba:	5f                   	pop    %edi
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    

008011bd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	57                   	push   %edi
  8011c1:	56                   	push   %esi
  8011c2:	53                   	push   %ebx
  8011c3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ce:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011d3:	89 cb                	mov    %ecx,%ebx
  8011d5:	89 cf                	mov    %ecx,%edi
  8011d7:	89 ce                	mov    %ecx,%esi
  8011d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	7f 08                	jg     8011e7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e2:	5b                   	pop    %ebx
  8011e3:	5e                   	pop    %esi
  8011e4:	5f                   	pop    %edi
  8011e5:	5d                   	pop    %ebp
  8011e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e7:	83 ec 0c             	sub    $0xc,%esp
  8011ea:	50                   	push   %eax
  8011eb:	6a 0e                	push   $0xe
  8011ed:	68 20 2c 80 00       	push   $0x802c20
  8011f2:	6a 33                	push   $0x33
  8011f4:	68 3d 2c 80 00       	push   $0x802c3d
  8011f9:	e8 f3 f1 ff ff       	call   8003f1 <_panic>

008011fe <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	57                   	push   %edi
  801202:	56                   	push   %esi
  801203:	53                   	push   %ebx
	asm volatile("int %1\n"
  801204:	bb 00 00 00 00       	mov    $0x0,%ebx
  801209:	8b 55 08             	mov    0x8(%ebp),%edx
  80120c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120f:	b8 0f 00 00 00       	mov    $0xf,%eax
  801214:	89 df                	mov    %ebx,%edi
  801216:	89 de                	mov    %ebx,%esi
  801218:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80121a:	5b                   	pop    %ebx
  80121b:	5e                   	pop    %esi
  80121c:	5f                   	pop    %edi
  80121d:	5d                   	pop    %ebp
  80121e:	c3                   	ret    

0080121f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	57                   	push   %edi
  801223:	56                   	push   %esi
  801224:	53                   	push   %ebx
	asm volatile("int %1\n"
  801225:	b9 00 00 00 00       	mov    $0x0,%ecx
  80122a:	8b 55 08             	mov    0x8(%ebp),%edx
  80122d:	b8 10 00 00 00       	mov    $0x10,%eax
  801232:	89 cb                	mov    %ecx,%ebx
  801234:	89 cf                	mov    %ecx,%edi
  801236:	89 ce                	mov    %ecx,%esi
  801238:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80123a:	5b                   	pop    %ebx
  80123b:	5e                   	pop    %esi
  80123c:	5f                   	pop    %edi
  80123d:	5d                   	pop    %ebp
  80123e:	c3                   	ret    

0080123f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	05 00 00 00 30       	add    $0x30000000,%eax
  80124a:	c1 e8 0c             	shr    $0xc,%eax
}
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    

0080124f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80125a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80125f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    

00801266 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80126e:	89 c2                	mov    %eax,%edx
  801270:	c1 ea 16             	shr    $0x16,%edx
  801273:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80127a:	f6 c2 01             	test   $0x1,%dl
  80127d:	74 2d                	je     8012ac <fd_alloc+0x46>
  80127f:	89 c2                	mov    %eax,%edx
  801281:	c1 ea 0c             	shr    $0xc,%edx
  801284:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80128b:	f6 c2 01             	test   $0x1,%dl
  80128e:	74 1c                	je     8012ac <fd_alloc+0x46>
  801290:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801295:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80129a:	75 d2                	jne    80126e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012a5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012aa:	eb 0a                	jmp    8012b6 <fd_alloc+0x50>
			*fd_store = fd;
  8012ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012af:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    

008012b8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012be:	83 f8 1f             	cmp    $0x1f,%eax
  8012c1:	77 30                	ja     8012f3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012c3:	c1 e0 0c             	shl    $0xc,%eax
  8012c6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012cb:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012d1:	f6 c2 01             	test   $0x1,%dl
  8012d4:	74 24                	je     8012fa <fd_lookup+0x42>
  8012d6:	89 c2                	mov    %eax,%edx
  8012d8:	c1 ea 0c             	shr    $0xc,%edx
  8012db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e2:	f6 c2 01             	test   $0x1,%dl
  8012e5:	74 1a                	je     801301 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ea:	89 02                	mov    %eax,(%edx)
	return 0;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    
		return -E_INVAL;
  8012f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f8:	eb f7                	jmp    8012f1 <fd_lookup+0x39>
		return -E_INVAL;
  8012fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ff:	eb f0                	jmp    8012f1 <fd_lookup+0x39>
  801301:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801306:	eb e9                	jmp    8012f1 <fd_lookup+0x39>

00801308 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 08             	sub    $0x8,%esp
  80130e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801311:	ba c8 2c 80 00       	mov    $0x802cc8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801316:	b8 90 47 80 00       	mov    $0x804790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80131b:	39 08                	cmp    %ecx,(%eax)
  80131d:	74 33                	je     801352 <dev_lookup+0x4a>
  80131f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801322:	8b 02                	mov    (%edx),%eax
  801324:	85 c0                	test   %eax,%eax
  801326:	75 f3                	jne    80131b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801328:	a1 90 67 80 00       	mov    0x806790,%eax
  80132d:	8b 40 48             	mov    0x48(%eax),%eax
  801330:	83 ec 04             	sub    $0x4,%esp
  801333:	51                   	push   %ecx
  801334:	50                   	push   %eax
  801335:	68 4c 2c 80 00       	push   $0x802c4c
  80133a:	e8 8d f1 ff ff       	call   8004cc <cprintf>
	*dev = 0;
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801348:	83 c4 10             	add    $0x10,%esp
  80134b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    
			*dev = devtab[i];
  801352:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801355:	89 01                	mov    %eax,(%ecx)
			return 0;
  801357:	b8 00 00 00 00       	mov    $0x0,%eax
  80135c:	eb f2                	jmp    801350 <dev_lookup+0x48>

0080135e <fd_close>:
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	83 ec 24             	sub    $0x24,%esp
  801367:	8b 75 08             	mov    0x8(%ebp),%esi
  80136a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80136d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801370:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801371:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801377:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80137a:	50                   	push   %eax
  80137b:	e8 38 ff ff ff       	call   8012b8 <fd_lookup>
  801380:	89 c3                	mov    %eax,%ebx
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	78 05                	js     80138e <fd_close+0x30>
	    || fd != fd2)
  801389:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80138c:	74 16                	je     8013a4 <fd_close+0x46>
		return (must_exist ? r : 0);
  80138e:	89 f8                	mov    %edi,%eax
  801390:	84 c0                	test   %al,%al
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	0f 44 d8             	cmove  %eax,%ebx
}
  80139a:	89 d8                	mov    %ebx,%eax
  80139c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139f:	5b                   	pop    %ebx
  8013a0:	5e                   	pop    %esi
  8013a1:	5f                   	pop    %edi
  8013a2:	5d                   	pop    %ebp
  8013a3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013aa:	50                   	push   %eax
  8013ab:	ff 36                	pushl  (%esi)
  8013ad:	e8 56 ff ff ff       	call   801308 <dev_lookup>
  8013b2:	89 c3                	mov    %eax,%ebx
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 1a                	js     8013d5 <fd_close+0x77>
		if (dev->dev_close)
  8013bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013be:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	74 0b                	je     8013d5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013ca:	83 ec 0c             	sub    $0xc,%esp
  8013cd:	56                   	push   %esi
  8013ce:	ff d0                	call   *%eax
  8013d0:	89 c3                	mov    %eax,%ebx
  8013d2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013d5:	83 ec 08             	sub    $0x8,%esp
  8013d8:	56                   	push   %esi
  8013d9:	6a 00                	push   $0x0
  8013db:	e8 71 fc ff ff       	call   801051 <sys_page_unmap>
	return r;
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	eb b5                	jmp    80139a <fd_close+0x3c>

008013e5 <close>:

int
close(int fdnum)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 08             	pushl  0x8(%ebp)
  8013f2:	e8 c1 fe ff ff       	call   8012b8 <fd_lookup>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	79 02                	jns    801400 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    
		return fd_close(fd, 1);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	6a 01                	push   $0x1
  801405:	ff 75 f4             	pushl  -0xc(%ebp)
  801408:	e8 51 ff ff ff       	call   80135e <fd_close>
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	eb ec                	jmp    8013fe <close+0x19>

00801412 <close_all>:

void
close_all(void)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	53                   	push   %ebx
  801416:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801419:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	53                   	push   %ebx
  801422:	e8 be ff ff ff       	call   8013e5 <close>
	for (i = 0; i < MAXFD; i++)
  801427:	83 c3 01             	add    $0x1,%ebx
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	83 fb 20             	cmp    $0x20,%ebx
  801430:	75 ec                	jne    80141e <close_all+0xc>
}
  801432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	57                   	push   %edi
  80143b:	56                   	push   %esi
  80143c:	53                   	push   %ebx
  80143d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801440:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801443:	50                   	push   %eax
  801444:	ff 75 08             	pushl  0x8(%ebp)
  801447:	e8 6c fe ff ff       	call   8012b8 <fd_lookup>
  80144c:	89 c3                	mov    %eax,%ebx
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	0f 88 81 00 00 00    	js     8014da <dup+0xa3>
		return r;
	close(newfdnum);
  801459:	83 ec 0c             	sub    $0xc,%esp
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	e8 81 ff ff ff       	call   8013e5 <close>

	newfd = INDEX2FD(newfdnum);
  801464:	8b 75 0c             	mov    0xc(%ebp),%esi
  801467:	c1 e6 0c             	shl    $0xc,%esi
  80146a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801470:	83 c4 04             	add    $0x4,%esp
  801473:	ff 75 e4             	pushl  -0x1c(%ebp)
  801476:	e8 d4 fd ff ff       	call   80124f <fd2data>
  80147b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80147d:	89 34 24             	mov    %esi,(%esp)
  801480:	e8 ca fd ff ff       	call   80124f <fd2data>
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80148a:	89 d8                	mov    %ebx,%eax
  80148c:	c1 e8 16             	shr    $0x16,%eax
  80148f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801496:	a8 01                	test   $0x1,%al
  801498:	74 11                	je     8014ab <dup+0x74>
  80149a:	89 d8                	mov    %ebx,%eax
  80149c:	c1 e8 0c             	shr    $0xc,%eax
  80149f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014a6:	f6 c2 01             	test   $0x1,%dl
  8014a9:	75 39                	jne    8014e4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014ae:	89 d0                	mov    %edx,%eax
  8014b0:	c1 e8 0c             	shr    $0xc,%eax
  8014b3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8014c2:	50                   	push   %eax
  8014c3:	56                   	push   %esi
  8014c4:	6a 00                	push   $0x0
  8014c6:	52                   	push   %edx
  8014c7:	6a 00                	push   $0x0
  8014c9:	e8 41 fb ff ff       	call   80100f <sys_page_map>
  8014ce:	89 c3                	mov    %eax,%ebx
  8014d0:	83 c4 20             	add    $0x20,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 31                	js     801508 <dup+0xd1>
		goto err;

	return newfdnum;
  8014d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014da:	89 d8                	mov    %ebx,%eax
  8014dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	5f                   	pop    %edi
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014e4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8014f3:	50                   	push   %eax
  8014f4:	57                   	push   %edi
  8014f5:	6a 00                	push   $0x0
  8014f7:	53                   	push   %ebx
  8014f8:	6a 00                	push   $0x0
  8014fa:	e8 10 fb ff ff       	call   80100f <sys_page_map>
  8014ff:	89 c3                	mov    %eax,%ebx
  801501:	83 c4 20             	add    $0x20,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	79 a3                	jns    8014ab <dup+0x74>
	sys_page_unmap(0, newfd);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	56                   	push   %esi
  80150c:	6a 00                	push   $0x0
  80150e:	e8 3e fb ff ff       	call   801051 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801513:	83 c4 08             	add    $0x8,%esp
  801516:	57                   	push   %edi
  801517:	6a 00                	push   $0x0
  801519:	e8 33 fb ff ff       	call   801051 <sys_page_unmap>
	return r;
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	eb b7                	jmp    8014da <dup+0xa3>

00801523 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	53                   	push   %ebx
  801527:	83 ec 1c             	sub    $0x1c,%esp
  80152a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801530:	50                   	push   %eax
  801531:	53                   	push   %ebx
  801532:	e8 81 fd ff ff       	call   8012b8 <fd_lookup>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	78 3f                	js     80157d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801548:	ff 30                	pushl  (%eax)
  80154a:	e8 b9 fd ff ff       	call   801308 <dev_lookup>
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	78 27                	js     80157d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801556:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801559:	8b 42 08             	mov    0x8(%edx),%eax
  80155c:	83 e0 03             	and    $0x3,%eax
  80155f:	83 f8 01             	cmp    $0x1,%eax
  801562:	74 1e                	je     801582 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801567:	8b 40 08             	mov    0x8(%eax),%eax
  80156a:	85 c0                	test   %eax,%eax
  80156c:	74 35                	je     8015a3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	ff 75 10             	pushl  0x10(%ebp)
  801574:	ff 75 0c             	pushl  0xc(%ebp)
  801577:	52                   	push   %edx
  801578:	ff d0                	call   *%eax
  80157a:	83 c4 10             	add    $0x10,%esp
}
  80157d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801580:	c9                   	leave  
  801581:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801582:	a1 90 67 80 00       	mov    0x806790,%eax
  801587:	8b 40 48             	mov    0x48(%eax),%eax
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	53                   	push   %ebx
  80158e:	50                   	push   %eax
  80158f:	68 8d 2c 80 00       	push   $0x802c8d
  801594:	e8 33 ef ff ff       	call   8004cc <cprintf>
		return -E_INVAL;
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a1:	eb da                	jmp    80157d <read+0x5a>
		return -E_NOT_SUPP;
  8015a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a8:	eb d3                	jmp    80157d <read+0x5a>

008015aa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	57                   	push   %edi
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015be:	39 f3                	cmp    %esi,%ebx
  8015c0:	73 23                	jae    8015e5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	89 f0                	mov    %esi,%eax
  8015c7:	29 d8                	sub    %ebx,%eax
  8015c9:	50                   	push   %eax
  8015ca:	89 d8                	mov    %ebx,%eax
  8015cc:	03 45 0c             	add    0xc(%ebp),%eax
  8015cf:	50                   	push   %eax
  8015d0:	57                   	push   %edi
  8015d1:	e8 4d ff ff ff       	call   801523 <read>
		if (m < 0)
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 06                	js     8015e3 <readn+0x39>
			return m;
		if (m == 0)
  8015dd:	74 06                	je     8015e5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015df:	01 c3                	add    %eax,%ebx
  8015e1:	eb db                	jmp    8015be <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015e3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015e5:	89 d8                	mov    %ebx,%eax
  8015e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ea:	5b                   	pop    %ebx
  8015eb:	5e                   	pop    %esi
  8015ec:	5f                   	pop    %edi
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    

008015ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	53                   	push   %ebx
  8015f3:	83 ec 1c             	sub    $0x1c,%esp
  8015f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015fc:	50                   	push   %eax
  8015fd:	53                   	push   %ebx
  8015fe:	e8 b5 fc ff ff       	call   8012b8 <fd_lookup>
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	78 3a                	js     801644 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801614:	ff 30                	pushl  (%eax)
  801616:	e8 ed fc ff ff       	call   801308 <dev_lookup>
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 22                	js     801644 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801625:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801629:	74 1e                	je     801649 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80162b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162e:	8b 52 0c             	mov    0xc(%edx),%edx
  801631:	85 d2                	test   %edx,%edx
  801633:	74 35                	je     80166a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	ff 75 10             	pushl  0x10(%ebp)
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	50                   	push   %eax
  80163f:	ff d2                	call   *%edx
  801641:	83 c4 10             	add    $0x10,%esp
}
  801644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801647:	c9                   	leave  
  801648:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801649:	a1 90 67 80 00       	mov    0x806790,%eax
  80164e:	8b 40 48             	mov    0x48(%eax),%eax
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	53                   	push   %ebx
  801655:	50                   	push   %eax
  801656:	68 a9 2c 80 00       	push   $0x802ca9
  80165b:	e8 6c ee ff ff       	call   8004cc <cprintf>
		return -E_INVAL;
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801668:	eb da                	jmp    801644 <write+0x55>
		return -E_NOT_SUPP;
  80166a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166f:	eb d3                	jmp    801644 <write+0x55>

00801671 <seek>:

int
seek(int fdnum, off_t offset)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801677:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167a:	50                   	push   %eax
  80167b:	ff 75 08             	pushl  0x8(%ebp)
  80167e:	e8 35 fc ff ff       	call   8012b8 <fd_lookup>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 0e                	js     801698 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80168a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801693:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	53                   	push   %ebx
  80169e:	83 ec 1c             	sub    $0x1c,%esp
  8016a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a7:	50                   	push   %eax
  8016a8:	53                   	push   %ebx
  8016a9:	e8 0a fc ff ff       	call   8012b8 <fd_lookup>
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 37                	js     8016ec <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bb:	50                   	push   %eax
  8016bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bf:	ff 30                	pushl  (%eax)
  8016c1:	e8 42 fc ff ff       	call   801308 <dev_lookup>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 1f                	js     8016ec <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016d4:	74 1b                	je     8016f1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d9:	8b 52 18             	mov    0x18(%edx),%edx
  8016dc:	85 d2                	test   %edx,%edx
  8016de:	74 32                	je     801712 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	ff 75 0c             	pushl  0xc(%ebp)
  8016e6:	50                   	push   %eax
  8016e7:	ff d2                	call   *%edx
  8016e9:	83 c4 10             	add    $0x10,%esp
}
  8016ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016f1:	a1 90 67 80 00       	mov    0x806790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016f6:	8b 40 48             	mov    0x48(%eax),%eax
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	53                   	push   %ebx
  8016fd:	50                   	push   %eax
  8016fe:	68 6c 2c 80 00       	push   $0x802c6c
  801703:	e8 c4 ed ff ff       	call   8004cc <cprintf>
		return -E_INVAL;
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801710:	eb da                	jmp    8016ec <ftruncate+0x52>
		return -E_NOT_SUPP;
  801712:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801717:	eb d3                	jmp    8016ec <ftruncate+0x52>

00801719 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	53                   	push   %ebx
  80171d:	83 ec 1c             	sub    $0x1c,%esp
  801720:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801723:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801726:	50                   	push   %eax
  801727:	ff 75 08             	pushl  0x8(%ebp)
  80172a:	e8 89 fb ff ff       	call   8012b8 <fd_lookup>
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	85 c0                	test   %eax,%eax
  801734:	78 4b                	js     801781 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801736:	83 ec 08             	sub    $0x8,%esp
  801739:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173c:	50                   	push   %eax
  80173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801740:	ff 30                	pushl  (%eax)
  801742:	e8 c1 fb ff ff       	call   801308 <dev_lookup>
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	85 c0                	test   %eax,%eax
  80174c:	78 33                	js     801781 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80174e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801751:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801755:	74 2f                	je     801786 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801757:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80175a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801761:	00 00 00 
	stat->st_isdir = 0;
  801764:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80176b:	00 00 00 
	stat->st_dev = dev;
  80176e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	53                   	push   %ebx
  801778:	ff 75 f0             	pushl  -0x10(%ebp)
  80177b:	ff 50 14             	call   *0x14(%eax)
  80177e:	83 c4 10             	add    $0x10,%esp
}
  801781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801784:	c9                   	leave  
  801785:	c3                   	ret    
		return -E_NOT_SUPP;
  801786:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178b:	eb f4                	jmp    801781 <fstat+0x68>

0080178d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	56                   	push   %esi
  801791:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	6a 00                	push   $0x0
  801797:	ff 75 08             	pushl  0x8(%ebp)
  80179a:	e8 e7 01 00 00       	call   801986 <open>
  80179f:	89 c3                	mov    %eax,%ebx
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	78 1b                	js     8017c3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017a8:	83 ec 08             	sub    $0x8,%esp
  8017ab:	ff 75 0c             	pushl  0xc(%ebp)
  8017ae:	50                   	push   %eax
  8017af:	e8 65 ff ff ff       	call   801719 <fstat>
  8017b4:	89 c6                	mov    %eax,%esi
	close(fd);
  8017b6:	89 1c 24             	mov    %ebx,(%esp)
  8017b9:	e8 27 fc ff ff       	call   8013e5 <close>
	return r;
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	89 f3                	mov    %esi,%ebx
}
  8017c3:	89 d8                	mov    %ebx,%eax
  8017c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c8:	5b                   	pop    %ebx
  8017c9:	5e                   	pop    %esi
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    

008017cc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	56                   	push   %esi
  8017d0:	53                   	push   %ebx
  8017d1:	89 c6                	mov    %eax,%esi
  8017d3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017d5:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8017dc:	74 27                	je     801805 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017de:	6a 07                	push   $0x7
  8017e0:	68 00 70 80 00       	push   $0x807000
  8017e5:	56                   	push   %esi
  8017e6:	ff 35 00 50 80 00    	pushl  0x805000
  8017ec:	e8 2d 0c 00 00       	call   80241e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017f1:	83 c4 0c             	add    $0xc,%esp
  8017f4:	6a 00                	push   $0x0
  8017f6:	53                   	push   %ebx
  8017f7:	6a 00                	push   $0x0
  8017f9:	e8 b9 0b 00 00       	call   8023b7 <ipc_recv>
}
  8017fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	6a 01                	push   $0x1
  80180a:	e8 58 0c 00 00       	call   802467 <ipc_find_env>
  80180f:	a3 00 50 80 00       	mov    %eax,0x805000
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	eb c5                	jmp    8017de <fsipc+0x12>

00801819 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8b 40 0c             	mov    0xc(%eax),%eax
  801825:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	b8 02 00 00 00       	mov    $0x2,%eax
  80183c:	e8 8b ff ff ff       	call   8017cc <fsipc>
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <devfile_flush>:
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8b 40 0c             	mov    0xc(%eax),%eax
  80184f:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801854:	ba 00 00 00 00       	mov    $0x0,%edx
  801859:	b8 06 00 00 00       	mov    $0x6,%eax
  80185e:	e8 69 ff ff ff       	call   8017cc <fsipc>
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <devfile_stat>:
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	53                   	push   %ebx
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	8b 40 0c             	mov    0xc(%eax),%eax
  801875:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80187a:	ba 00 00 00 00       	mov    $0x0,%edx
  80187f:	b8 05 00 00 00       	mov    $0x5,%eax
  801884:	e8 43 ff ff ff       	call   8017cc <fsipc>
  801889:	85 c0                	test   %eax,%eax
  80188b:	78 2c                	js     8018b9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80188d:	83 ec 08             	sub    $0x8,%esp
  801890:	68 00 70 80 00       	push   $0x807000
  801895:	53                   	push   %ebx
  801896:	e8 3f f3 ff ff       	call   800bda <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80189b:	a1 80 70 80 00       	mov    0x807080,%eax
  8018a0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018a6:	a1 84 70 80 00       	mov    0x807084,%eax
  8018ab:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <devfile_write>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 0c             	sub    $0xc,%esp
  8018c4:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ca:	8b 52 0c             	mov    0xc(%edx),%edx
  8018cd:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8018d3:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018d8:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8018dd:	0f 47 c2             	cmova  %edx,%eax
  8018e0:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8018e5:	50                   	push   %eax
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	68 08 70 80 00       	push   $0x807008
  8018ee:	e8 75 f4 ff ff       	call   800d68 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8018fd:	e8 ca fe ff ff       	call   8017cc <fsipc>
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <devfile_read>:
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	56                   	push   %esi
  801908:	53                   	push   %ebx
  801909:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8b 40 0c             	mov    0xc(%eax),%eax
  801912:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801917:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
  801922:	b8 03 00 00 00       	mov    $0x3,%eax
  801927:	e8 a0 fe ff ff       	call   8017cc <fsipc>
  80192c:	89 c3                	mov    %eax,%ebx
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 1f                	js     801951 <devfile_read+0x4d>
	assert(r <= n);
  801932:	39 f0                	cmp    %esi,%eax
  801934:	77 24                	ja     80195a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801936:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80193b:	7f 33                	jg     801970 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	50                   	push   %eax
  801941:	68 00 70 80 00       	push   $0x807000
  801946:	ff 75 0c             	pushl  0xc(%ebp)
  801949:	e8 1a f4 ff ff       	call   800d68 <memmove>
	return r;
  80194e:	83 c4 10             	add    $0x10,%esp
}
  801951:	89 d8                	mov    %ebx,%eax
  801953:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5d                   	pop    %ebp
  801959:	c3                   	ret    
	assert(r <= n);
  80195a:	68 d8 2c 80 00       	push   $0x802cd8
  80195f:	68 df 2c 80 00       	push   $0x802cdf
  801964:	6a 7c                	push   $0x7c
  801966:	68 f4 2c 80 00       	push   $0x802cf4
  80196b:	e8 81 ea ff ff       	call   8003f1 <_panic>
	assert(r <= PGSIZE);
  801970:	68 ff 2c 80 00       	push   $0x802cff
  801975:	68 df 2c 80 00       	push   $0x802cdf
  80197a:	6a 7d                	push   $0x7d
  80197c:	68 f4 2c 80 00       	push   $0x802cf4
  801981:	e8 6b ea ff ff       	call   8003f1 <_panic>

00801986 <open>:
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
  80198b:	83 ec 1c             	sub    $0x1c,%esp
  80198e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801991:	56                   	push   %esi
  801992:	e8 0a f2 ff ff       	call   800ba1 <strlen>
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80199f:	7f 6c                	jg     801a0d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a7:	50                   	push   %eax
  8019a8:	e8 b9 f8 ff ff       	call   801266 <fd_alloc>
  8019ad:	89 c3                	mov    %eax,%ebx
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 3c                	js     8019f2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019b6:	83 ec 08             	sub    $0x8,%esp
  8019b9:	56                   	push   %esi
  8019ba:	68 00 70 80 00       	push   $0x807000
  8019bf:	e8 16 f2 ff ff       	call   800bda <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c7:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d4:	e8 f3 fd ff ff       	call   8017cc <fsipc>
  8019d9:	89 c3                	mov    %eax,%ebx
  8019db:	83 c4 10             	add    $0x10,%esp
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 19                	js     8019fb <open+0x75>
	return fd2num(fd);
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e8:	e8 52 f8 ff ff       	call   80123f <fd2num>
  8019ed:	89 c3                	mov    %eax,%ebx
  8019ef:	83 c4 10             	add    $0x10,%esp
}
  8019f2:	89 d8                	mov    %ebx,%eax
  8019f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    
		fd_close(fd, 0);
  8019fb:	83 ec 08             	sub    $0x8,%esp
  8019fe:	6a 00                	push   $0x0
  801a00:	ff 75 f4             	pushl  -0xc(%ebp)
  801a03:	e8 56 f9 ff ff       	call   80135e <fd_close>
		return r;
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	eb e5                	jmp    8019f2 <open+0x6c>
		return -E_BAD_PATH;
  801a0d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a12:	eb de                	jmp    8019f2 <open+0x6c>

00801a14 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1f:	b8 08 00 00 00       	mov    $0x8,%eax
  801a24:	e8 a3 fd ff ff       	call   8017cc <fsipc>
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	57                   	push   %edi
  801a2f:	56                   	push   %esi
  801a30:	53                   	push   %ebx
  801a31:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801a37:	6a 00                	push   $0x0
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	e8 45 ff ff ff       	call   801986 <open>
  801a41:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	0f 88 ff 04 00 00    	js     801f51 <spawn+0x526>
  801a52:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	68 00 02 00 00       	push   $0x200
  801a5c:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	51                   	push   %ecx
  801a64:	e8 41 fb ff ff       	call   8015aa <readn>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a71:	75 60                	jne    801ad3 <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  801a73:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a7a:	45 4c 46 
  801a7d:	75 54                	jne    801ad3 <spawn+0xa8>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a7f:	b8 07 00 00 00       	mov    $0x7,%eax
  801a84:	cd 30                	int    $0x30
  801a86:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a8c:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a92:	85 c0                	test   %eax,%eax
  801a94:	0f 88 ab 04 00 00    	js     801f45 <spawn+0x51a>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a9a:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a9f:	8d 34 c0             	lea    (%eax,%eax,8),%esi
  801aa2:	c1 e6 04             	shl    $0x4,%esi
  801aa5:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801aab:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801ab1:	b9 11 00 00 00       	mov    $0x11,%ecx
  801ab6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801ab8:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801abe:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ac4:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801ac9:	be 00 00 00 00       	mov    $0x0,%esi
  801ace:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ad1:	eb 4b                	jmp    801b1e <spawn+0xf3>
		close(fd);
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801adc:	e8 04 f9 ff ff       	call   8013e5 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801ae1:	83 c4 0c             	add    $0xc,%esp
  801ae4:	68 7f 45 4c 46       	push   $0x464c457f
  801ae9:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801aef:	68 0b 2d 80 00       	push   $0x802d0b
  801af4:	e8 d3 e9 ff ff       	call   8004cc <cprintf>
		return -E_NOT_EXEC;
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801b03:	ff ff ff 
  801b06:	e9 46 04 00 00       	jmp    801f51 <spawn+0x526>
		string_size += strlen(argv[argc]) + 1;
  801b0b:	83 ec 0c             	sub    $0xc,%esp
  801b0e:	50                   	push   %eax
  801b0f:	e8 8d f0 ff ff       	call   800ba1 <strlen>
  801b14:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801b18:	83 c3 01             	add    $0x1,%ebx
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801b25:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	75 df                	jne    801b0b <spawn+0xe0>
  801b2c:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801b32:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801b38:	bf 00 10 40 00       	mov    $0x401000,%edi
  801b3d:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801b3f:	89 fa                	mov    %edi,%edx
  801b41:	83 e2 fc             	and    $0xfffffffc,%edx
  801b44:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801b4b:	29 c2                	sub    %eax,%edx
  801b4d:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801b53:	8d 42 f8             	lea    -0x8(%edx),%eax
  801b56:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801b5b:	0f 86 13 04 00 00    	jbe    801f74 <spawn+0x549>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	6a 07                	push   $0x7
  801b66:	68 00 00 40 00       	push   $0x400000
  801b6b:	6a 00                	push   $0x0
  801b6d:	e8 5a f4 ff ff       	call   800fcc <sys_page_alloc>
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	85 c0                	test   %eax,%eax
  801b77:	0f 88 fc 03 00 00    	js     801f79 <spawn+0x54e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b7d:	be 00 00 00 00       	mov    $0x0,%esi
  801b82:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b8b:	eb 30                	jmp    801bbd <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b8d:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b93:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b99:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b9c:	83 ec 08             	sub    $0x8,%esp
  801b9f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801ba2:	57                   	push   %edi
  801ba3:	e8 32 f0 ff ff       	call   800bda <strcpy>
		string_store += strlen(argv[i]) + 1;
  801ba8:	83 c4 04             	add    $0x4,%esp
  801bab:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801bae:	e8 ee ef ff ff       	call   800ba1 <strlen>
  801bb3:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801bb7:	83 c6 01             	add    $0x1,%esi
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801bc3:	7f c8                	jg     801b8d <spawn+0x162>
	}
	argv_store[argc] = 0;
  801bc5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801bcb:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801bd1:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801bd8:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801bde:	0f 85 86 00 00 00    	jne    801c6a <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801be4:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801bea:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801bf0:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801bf3:	89 d0                	mov    %edx,%eax
  801bf5:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801bfb:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801bfe:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801c03:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	6a 07                	push   $0x7
  801c0e:	68 00 d0 bf ee       	push   $0xeebfd000
  801c13:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c19:	68 00 00 40 00       	push   $0x400000
  801c1e:	6a 00                	push   $0x0
  801c20:	e8 ea f3 ff ff       	call   80100f <sys_page_map>
  801c25:	89 c3                	mov    %eax,%ebx
  801c27:	83 c4 20             	add    $0x20,%esp
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	0f 88 4f 03 00 00    	js     801f81 <spawn+0x556>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c32:	83 ec 08             	sub    $0x8,%esp
  801c35:	68 00 00 40 00       	push   $0x400000
  801c3a:	6a 00                	push   $0x0
  801c3c:	e8 10 f4 ff ff       	call   801051 <sys_page_unmap>
  801c41:	89 c3                	mov    %eax,%ebx
  801c43:	83 c4 10             	add    $0x10,%esp
  801c46:	85 c0                	test   %eax,%eax
  801c48:	0f 88 33 03 00 00    	js     801f81 <spawn+0x556>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801c4e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c54:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c5b:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801c62:	00 00 00 
  801c65:	e9 4f 01 00 00       	jmp    801db9 <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c6a:	68 98 2d 80 00       	push   $0x802d98
  801c6f:	68 df 2c 80 00       	push   $0x802cdf
  801c74:	68 f2 00 00 00       	push   $0xf2
  801c79:	68 25 2d 80 00       	push   $0x802d25
  801c7e:	e8 6e e7 ff ff       	call   8003f1 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	6a 07                	push   $0x7
  801c88:	68 00 00 40 00       	push   $0x400000
  801c8d:	6a 00                	push   $0x0
  801c8f:	e8 38 f3 ff ff       	call   800fcc <sys_page_alloc>
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	0f 88 c0 02 00 00    	js     801f5f <spawn+0x534>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801ca8:	01 f0                	add    %esi,%eax
  801caa:	50                   	push   %eax
  801cab:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801cb1:	e8 bb f9 ff ff       	call   801671 <seek>
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	0f 88 a5 02 00 00    	js     801f66 <spawn+0x53b>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801cc1:	83 ec 04             	sub    $0x4,%esp
  801cc4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cca:	29 f0                	sub    %esi,%eax
  801ccc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cd1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801cd6:	0f 47 c1             	cmova  %ecx,%eax
  801cd9:	50                   	push   %eax
  801cda:	68 00 00 40 00       	push   $0x400000
  801cdf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ce5:	e8 c0 f8 ff ff       	call   8015aa <readn>
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	85 c0                	test   %eax,%eax
  801cef:	0f 88 78 02 00 00    	js     801f6d <spawn+0x542>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801cf5:	83 ec 0c             	sub    $0xc,%esp
  801cf8:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cfe:	53                   	push   %ebx
  801cff:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d05:	68 00 00 40 00       	push   $0x400000
  801d0a:	6a 00                	push   $0x0
  801d0c:	e8 fe f2 ff ff       	call   80100f <sys_page_map>
  801d11:	83 c4 20             	add    $0x20,%esp
  801d14:	85 c0                	test   %eax,%eax
  801d16:	78 7c                	js     801d94 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801d18:	83 ec 08             	sub    $0x8,%esp
  801d1b:	68 00 00 40 00       	push   $0x400000
  801d20:	6a 00                	push   $0x0
  801d22:	e8 2a f3 ff ff       	call   801051 <sys_page_unmap>
  801d27:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801d2a:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801d30:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d36:	89 fe                	mov    %edi,%esi
  801d38:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801d3e:	76 69                	jbe    801da9 <spawn+0x37e>
		if (i >= filesz) {
  801d40:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801d46:	0f 87 37 ff ff ff    	ja     801c83 <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801d4c:	83 ec 04             	sub    $0x4,%esp
  801d4f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d55:	53                   	push   %ebx
  801d56:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d5c:	e8 6b f2 ff ff       	call   800fcc <sys_page_alloc>
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	85 c0                	test   %eax,%eax
  801d66:	79 c2                	jns    801d2a <spawn+0x2ff>
  801d68:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801d6a:	83 ec 0c             	sub    $0xc,%esp
  801d6d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d73:	e8 d5 f1 ff ff       	call   800f4d <sys_env_destroy>
	close(fd);
  801d78:	83 c4 04             	add    $0x4,%esp
  801d7b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d81:	e8 5f f6 ff ff       	call   8013e5 <close>
	return r;
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801d8f:	e9 bd 01 00 00       	jmp    801f51 <spawn+0x526>
				panic("spawn: sys_page_map data: %e", r);
  801d94:	50                   	push   %eax
  801d95:	68 31 2d 80 00       	push   $0x802d31
  801d9a:	68 25 01 00 00       	push   $0x125
  801d9f:	68 25 2d 80 00       	push   $0x802d25
  801da4:	e8 48 e6 ff ff       	call   8003f1 <_panic>
  801da9:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801daf:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801db6:	83 c6 20             	add    $0x20,%esi
  801db9:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801dc0:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801dc6:	7e 6d                	jle    801e35 <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  801dc8:	83 3e 01             	cmpl   $0x1,(%esi)
  801dcb:	75 e2                	jne    801daf <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801dcd:	8b 46 18             	mov    0x18(%esi),%eax
  801dd0:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801dd3:	83 f8 01             	cmp    $0x1,%eax
  801dd6:	19 c0                	sbb    %eax,%eax
  801dd8:	83 e0 fe             	and    $0xfffffffe,%eax
  801ddb:	83 c0 07             	add    $0x7,%eax
  801dde:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801de4:	8b 4e 04             	mov    0x4(%esi),%ecx
  801de7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801ded:	8b 56 10             	mov    0x10(%esi),%edx
  801df0:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801df6:	8b 7e 14             	mov    0x14(%esi),%edi
  801df9:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801dff:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801e02:	89 d8                	mov    %ebx,%eax
  801e04:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e09:	74 1a                	je     801e25 <spawn+0x3fa>
		va -= i;
  801e0b:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801e0d:	01 c7                	add    %eax,%edi
  801e0f:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801e15:	01 c2                	add    %eax,%edx
  801e17:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801e1d:	29 c1                	sub    %eax,%ecx
  801e1f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801e25:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2a:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801e30:	e9 01 ff ff ff       	jmp    801d36 <spawn+0x30b>
	close(fd);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e3e:	e8 a2 f5 ff ff       	call   8013e5 <close>
  801e43:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	uint8_t *addr;
	int r;

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  801e46:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801e4b:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801e51:	eb 0e                	jmp    801e61 <spawn+0x436>
  801e53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e59:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e5f:	74 6f                	je     801ed0 <spawn+0x4a5>
		if ((uvpd[PDX(addr)] & PTE_P) 
  801e61:	89 d8                	mov    %ebx,%eax
  801e63:	c1 e8 16             	shr    $0x16,%eax
  801e66:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e6d:	a8 01                	test   $0x1,%al
  801e6f:	74 e2                	je     801e53 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_P) 
  801e71:	89 d8                	mov    %ebx,%eax
  801e73:	c1 e8 0c             	shr    $0xc,%eax
  801e76:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e7d:	f6 c2 01             	test   $0x1,%dl
  801e80:	74 d1                	je     801e53 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_U) 
  801e82:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e89:	f6 c2 04             	test   $0x4,%dl
  801e8c:	74 c5                	je     801e53 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801e8e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e95:	f6 c6 04             	test   $0x4,%dh
  801e98:	74 b9                	je     801e53 <spawn+0x428>
			if((r = sys_page_map(0, (void*)addr, child, (void*)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801e9a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ea1:	83 ec 0c             	sub    $0xc,%esp
  801ea4:	25 07 0e 00 00       	and    $0xe07,%eax
  801ea9:	50                   	push   %eax
  801eaa:	53                   	push   %ebx
  801eab:	56                   	push   %esi
  801eac:	53                   	push   %ebx
  801ead:	6a 00                	push   $0x0
  801eaf:	e8 5b f1 ff ff       	call   80100f <sys_page_map>
  801eb4:	83 c4 20             	add    $0x20,%esp
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	79 98                	jns    801e53 <spawn+0x428>
				panic("copy_shared_pages: %e\n", r);
  801ebb:	50                   	push   %eax
  801ebc:	68 4e 2d 80 00       	push   $0x802d4e
  801ec1:	68 3a 01 00 00       	push   $0x13a
  801ec6:	68 25 2d 80 00       	push   $0x802d25
  801ecb:	e8 21 e5 ff ff       	call   8003f1 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801ed0:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801ed7:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801eda:	83 ec 08             	sub    $0x8,%esp
  801edd:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ee3:	50                   	push   %eax
  801ee4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801eea:	e8 27 f2 ff ff       	call   801116 <sys_env_set_trapframe>
  801eef:	83 c4 10             	add    $0x10,%esp
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	78 25                	js     801f1b <spawn+0x4f0>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801ef6:	83 ec 08             	sub    $0x8,%esp
  801ef9:	6a 02                	push   $0x2
  801efb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f01:	e8 ce f1 ff ff       	call   8010d4 <sys_env_set_status>
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	78 23                	js     801f30 <spawn+0x505>
	return child;
  801f0d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f13:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f19:	eb 36                	jmp    801f51 <spawn+0x526>
		panic("sys_env_set_trapframe: %e", r);
  801f1b:	50                   	push   %eax
  801f1c:	68 65 2d 80 00       	push   $0x802d65
  801f21:	68 86 00 00 00       	push   $0x86
  801f26:	68 25 2d 80 00       	push   $0x802d25
  801f2b:	e8 c1 e4 ff ff       	call   8003f1 <_panic>
		panic("sys_env_set_status: %e", r);
  801f30:	50                   	push   %eax
  801f31:	68 7f 2d 80 00       	push   $0x802d7f
  801f36:	68 89 00 00 00       	push   $0x89
  801f3b:	68 25 2d 80 00       	push   $0x802d25
  801f40:	e8 ac e4 ff ff       	call   8003f1 <_panic>
		return r;
  801f45:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f4b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801f51:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5a:	5b                   	pop    %ebx
  801f5b:	5e                   	pop    %esi
  801f5c:	5f                   	pop    %edi
  801f5d:	5d                   	pop    %ebp
  801f5e:	c3                   	ret    
  801f5f:	89 c7                	mov    %eax,%edi
  801f61:	e9 04 fe ff ff       	jmp    801d6a <spawn+0x33f>
  801f66:	89 c7                	mov    %eax,%edi
  801f68:	e9 fd fd ff ff       	jmp    801d6a <spawn+0x33f>
  801f6d:	89 c7                	mov    %eax,%edi
  801f6f:	e9 f6 fd ff ff       	jmp    801d6a <spawn+0x33f>
		return -E_NO_MEM;
  801f74:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  801f79:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f7f:	eb d0                	jmp    801f51 <spawn+0x526>
	sys_page_unmap(0, UTEMP);
  801f81:	83 ec 08             	sub    $0x8,%esp
  801f84:	68 00 00 40 00       	push   $0x400000
  801f89:	6a 00                	push   $0x0
  801f8b:	e8 c1 f0 ff ff       	call   801051 <sys_page_unmap>
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801f99:	eb b6                	jmp    801f51 <spawn+0x526>

00801f9b <spawnl>:
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	57                   	push   %edi
  801f9f:	56                   	push   %esi
  801fa0:	53                   	push   %ebx
  801fa1:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801fa4:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801fac:	8d 4a 04             	lea    0x4(%edx),%ecx
  801faf:	83 3a 00             	cmpl   $0x0,(%edx)
  801fb2:	74 07                	je     801fbb <spawnl+0x20>
		argc++;
  801fb4:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801fb7:	89 ca                	mov    %ecx,%edx
  801fb9:	eb f1                	jmp    801fac <spawnl+0x11>
	const char *argv[argc+2];
  801fbb:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801fc2:	83 e2 f0             	and    $0xfffffff0,%edx
  801fc5:	29 d4                	sub    %edx,%esp
  801fc7:	8d 54 24 03          	lea    0x3(%esp),%edx
  801fcb:	c1 ea 02             	shr    $0x2,%edx
  801fce:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801fd5:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801fd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fda:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801fe1:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801fe8:	00 
	va_start(vl, arg0);
  801fe9:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801fec:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff3:	eb 0b                	jmp    802000 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801ff5:	83 c0 01             	add    $0x1,%eax
  801ff8:	8b 39                	mov    (%ecx),%edi
  801ffa:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801ffd:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802000:	39 d0                	cmp    %edx,%eax
  802002:	75 f1                	jne    801ff5 <spawnl+0x5a>
	return spawn(prog, argv);
  802004:	83 ec 08             	sub    $0x8,%esp
  802007:	56                   	push   %esi
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	e8 1b fa ff ff       	call   801a2b <spawn>
}
  802010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5f                   	pop    %edi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    

00802018 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	56                   	push   %esi
  80201c:	53                   	push   %ebx
  80201d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802020:	83 ec 0c             	sub    $0xc,%esp
  802023:	ff 75 08             	pushl  0x8(%ebp)
  802026:	e8 24 f2 ff ff       	call   80124f <fd2data>
  80202b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80202d:	83 c4 08             	add    $0x8,%esp
  802030:	68 c0 2d 80 00       	push   $0x802dc0
  802035:	53                   	push   %ebx
  802036:	e8 9f eb ff ff       	call   800bda <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80203b:	8b 46 04             	mov    0x4(%esi),%eax
  80203e:	2b 06                	sub    (%esi),%eax
  802040:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802046:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80204d:	00 00 00 
	stat->st_dev = &devpipe;
  802050:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  802057:	47 80 00 
	return 0;
}
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
  80205f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802062:	5b                   	pop    %ebx
  802063:	5e                   	pop    %esi
  802064:	5d                   	pop    %ebp
  802065:	c3                   	ret    

00802066 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	53                   	push   %ebx
  80206a:	83 ec 0c             	sub    $0xc,%esp
  80206d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802070:	53                   	push   %ebx
  802071:	6a 00                	push   $0x0
  802073:	e8 d9 ef ff ff       	call   801051 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802078:	89 1c 24             	mov    %ebx,(%esp)
  80207b:	e8 cf f1 ff ff       	call   80124f <fd2data>
  802080:	83 c4 08             	add    $0x8,%esp
  802083:	50                   	push   %eax
  802084:	6a 00                	push   $0x0
  802086:	e8 c6 ef ff ff       	call   801051 <sys_page_unmap>
}
  80208b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <_pipeisclosed>:
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	57                   	push   %edi
  802094:	56                   	push   %esi
  802095:	53                   	push   %ebx
  802096:	83 ec 1c             	sub    $0x1c,%esp
  802099:	89 c7                	mov    %eax,%edi
  80209b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80209d:	a1 90 67 80 00       	mov    0x806790,%eax
  8020a2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	57                   	push   %edi
  8020a9:	e8 f8 03 00 00       	call   8024a6 <pageref>
  8020ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020b1:	89 34 24             	mov    %esi,(%esp)
  8020b4:	e8 ed 03 00 00       	call   8024a6 <pageref>
		nn = thisenv->env_runs;
  8020b9:	8b 15 90 67 80 00    	mov    0x806790,%edx
  8020bf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	39 cb                	cmp    %ecx,%ebx
  8020c7:	74 1b                	je     8020e4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020c9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020cc:	75 cf                	jne    80209d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020ce:	8b 42 58             	mov    0x58(%edx),%eax
  8020d1:	6a 01                	push   $0x1
  8020d3:	50                   	push   %eax
  8020d4:	53                   	push   %ebx
  8020d5:	68 c7 2d 80 00       	push   $0x802dc7
  8020da:	e8 ed e3 ff ff       	call   8004cc <cprintf>
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	eb b9                	jmp    80209d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020e4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020e7:	0f 94 c0             	sete   %al
  8020ea:	0f b6 c0             	movzbl %al,%eax
}
  8020ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    

008020f5 <devpipe_write>:
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	57                   	push   %edi
  8020f9:	56                   	push   %esi
  8020fa:	53                   	push   %ebx
  8020fb:	83 ec 28             	sub    $0x28,%esp
  8020fe:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802101:	56                   	push   %esi
  802102:	e8 48 f1 ff ff       	call   80124f <fd2data>
  802107:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	bf 00 00 00 00       	mov    $0x0,%edi
  802111:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802114:	74 4f                	je     802165 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802116:	8b 43 04             	mov    0x4(%ebx),%eax
  802119:	8b 0b                	mov    (%ebx),%ecx
  80211b:	8d 51 20             	lea    0x20(%ecx),%edx
  80211e:	39 d0                	cmp    %edx,%eax
  802120:	72 14                	jb     802136 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802122:	89 da                	mov    %ebx,%edx
  802124:	89 f0                	mov    %esi,%eax
  802126:	e8 65 ff ff ff       	call   802090 <_pipeisclosed>
  80212b:	85 c0                	test   %eax,%eax
  80212d:	75 3b                	jne    80216a <devpipe_write+0x75>
			sys_yield();
  80212f:	e8 79 ee ff ff       	call   800fad <sys_yield>
  802134:	eb e0                	jmp    802116 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802139:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80213d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802140:	89 c2                	mov    %eax,%edx
  802142:	c1 fa 1f             	sar    $0x1f,%edx
  802145:	89 d1                	mov    %edx,%ecx
  802147:	c1 e9 1b             	shr    $0x1b,%ecx
  80214a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80214d:	83 e2 1f             	and    $0x1f,%edx
  802150:	29 ca                	sub    %ecx,%edx
  802152:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802156:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80215a:	83 c0 01             	add    $0x1,%eax
  80215d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802160:	83 c7 01             	add    $0x1,%edi
  802163:	eb ac                	jmp    802111 <devpipe_write+0x1c>
	return i;
  802165:	8b 45 10             	mov    0x10(%ebp),%eax
  802168:	eb 05                	jmp    80216f <devpipe_write+0x7a>
				return 0;
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802172:	5b                   	pop    %ebx
  802173:	5e                   	pop    %esi
  802174:	5f                   	pop    %edi
  802175:	5d                   	pop    %ebp
  802176:	c3                   	ret    

00802177 <devpipe_read>:
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	57                   	push   %edi
  80217b:	56                   	push   %esi
  80217c:	53                   	push   %ebx
  80217d:	83 ec 18             	sub    $0x18,%esp
  802180:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802183:	57                   	push   %edi
  802184:	e8 c6 f0 ff ff       	call   80124f <fd2data>
  802189:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80218b:	83 c4 10             	add    $0x10,%esp
  80218e:	be 00 00 00 00       	mov    $0x0,%esi
  802193:	3b 75 10             	cmp    0x10(%ebp),%esi
  802196:	75 14                	jne    8021ac <devpipe_read+0x35>
	return i;
  802198:	8b 45 10             	mov    0x10(%ebp),%eax
  80219b:	eb 02                	jmp    80219f <devpipe_read+0x28>
				return i;
  80219d:	89 f0                	mov    %esi,%eax
}
  80219f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a2:	5b                   	pop    %ebx
  8021a3:	5e                   	pop    %esi
  8021a4:	5f                   	pop    %edi
  8021a5:	5d                   	pop    %ebp
  8021a6:	c3                   	ret    
			sys_yield();
  8021a7:	e8 01 ee ff ff       	call   800fad <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8021ac:	8b 03                	mov    (%ebx),%eax
  8021ae:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021b1:	75 18                	jne    8021cb <devpipe_read+0x54>
			if (i > 0)
  8021b3:	85 f6                	test   %esi,%esi
  8021b5:	75 e6                	jne    80219d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8021b7:	89 da                	mov    %ebx,%edx
  8021b9:	89 f8                	mov    %edi,%eax
  8021bb:	e8 d0 fe ff ff       	call   802090 <_pipeisclosed>
  8021c0:	85 c0                	test   %eax,%eax
  8021c2:	74 e3                	je     8021a7 <devpipe_read+0x30>
				return 0;
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c9:	eb d4                	jmp    80219f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021cb:	99                   	cltd   
  8021cc:	c1 ea 1b             	shr    $0x1b,%edx
  8021cf:	01 d0                	add    %edx,%eax
  8021d1:	83 e0 1f             	and    $0x1f,%eax
  8021d4:	29 d0                	sub    %edx,%eax
  8021d6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021de:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021e1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021e4:	83 c6 01             	add    $0x1,%esi
  8021e7:	eb aa                	jmp    802193 <devpipe_read+0x1c>

008021e9 <pipe>:
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	56                   	push   %esi
  8021ed:	53                   	push   %ebx
  8021ee:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f4:	50                   	push   %eax
  8021f5:	e8 6c f0 ff ff       	call   801266 <fd_alloc>
  8021fa:	89 c3                	mov    %eax,%ebx
  8021fc:	83 c4 10             	add    $0x10,%esp
  8021ff:	85 c0                	test   %eax,%eax
  802201:	0f 88 23 01 00 00    	js     80232a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 07 04 00 00       	push   $0x407
  80220f:	ff 75 f4             	pushl  -0xc(%ebp)
  802212:	6a 00                	push   $0x0
  802214:	e8 b3 ed ff ff       	call   800fcc <sys_page_alloc>
  802219:	89 c3                	mov    %eax,%ebx
  80221b:	83 c4 10             	add    $0x10,%esp
  80221e:	85 c0                	test   %eax,%eax
  802220:	0f 88 04 01 00 00    	js     80232a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802226:	83 ec 0c             	sub    $0xc,%esp
  802229:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80222c:	50                   	push   %eax
  80222d:	e8 34 f0 ff ff       	call   801266 <fd_alloc>
  802232:	89 c3                	mov    %eax,%ebx
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	85 c0                	test   %eax,%eax
  802239:	0f 88 db 00 00 00    	js     80231a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80223f:	83 ec 04             	sub    $0x4,%esp
  802242:	68 07 04 00 00       	push   $0x407
  802247:	ff 75 f0             	pushl  -0x10(%ebp)
  80224a:	6a 00                	push   $0x0
  80224c:	e8 7b ed ff ff       	call   800fcc <sys_page_alloc>
  802251:	89 c3                	mov    %eax,%ebx
  802253:	83 c4 10             	add    $0x10,%esp
  802256:	85 c0                	test   %eax,%eax
  802258:	0f 88 bc 00 00 00    	js     80231a <pipe+0x131>
	va = fd2data(fd0);
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	ff 75 f4             	pushl  -0xc(%ebp)
  802264:	e8 e6 ef ff ff       	call   80124f <fd2data>
  802269:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226b:	83 c4 0c             	add    $0xc,%esp
  80226e:	68 07 04 00 00       	push   $0x407
  802273:	50                   	push   %eax
  802274:	6a 00                	push   $0x0
  802276:	e8 51 ed ff ff       	call   800fcc <sys_page_alloc>
  80227b:	89 c3                	mov    %eax,%ebx
  80227d:	83 c4 10             	add    $0x10,%esp
  802280:	85 c0                	test   %eax,%eax
  802282:	0f 88 82 00 00 00    	js     80230a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802288:	83 ec 0c             	sub    $0xc,%esp
  80228b:	ff 75 f0             	pushl  -0x10(%ebp)
  80228e:	e8 bc ef ff ff       	call   80124f <fd2data>
  802293:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80229a:	50                   	push   %eax
  80229b:	6a 00                	push   $0x0
  80229d:	56                   	push   %esi
  80229e:	6a 00                	push   $0x0
  8022a0:	e8 6a ed ff ff       	call   80100f <sys_page_map>
  8022a5:	89 c3                	mov    %eax,%ebx
  8022a7:	83 c4 20             	add    $0x20,%esp
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	78 4e                	js     8022fc <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8022ae:	a1 ac 47 80 00       	mov    0x8047ac,%eax
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ca:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022d1:	83 ec 0c             	sub    $0xc,%esp
  8022d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d7:	e8 63 ef ff ff       	call   80123f <fd2num>
  8022dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022df:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022e1:	83 c4 04             	add    $0x4,%esp
  8022e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8022e7:	e8 53 ef ff ff       	call   80123f <fd2num>
  8022ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ef:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022fa:	eb 2e                	jmp    80232a <pipe+0x141>
	sys_page_unmap(0, va);
  8022fc:	83 ec 08             	sub    $0x8,%esp
  8022ff:	56                   	push   %esi
  802300:	6a 00                	push   $0x0
  802302:	e8 4a ed ff ff       	call   801051 <sys_page_unmap>
  802307:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80230a:	83 ec 08             	sub    $0x8,%esp
  80230d:	ff 75 f0             	pushl  -0x10(%ebp)
  802310:	6a 00                	push   $0x0
  802312:	e8 3a ed ff ff       	call   801051 <sys_page_unmap>
  802317:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80231a:	83 ec 08             	sub    $0x8,%esp
  80231d:	ff 75 f4             	pushl  -0xc(%ebp)
  802320:	6a 00                	push   $0x0
  802322:	e8 2a ed ff ff       	call   801051 <sys_page_unmap>
  802327:	83 c4 10             	add    $0x10,%esp
}
  80232a:	89 d8                	mov    %ebx,%eax
  80232c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232f:	5b                   	pop    %ebx
  802330:	5e                   	pop    %esi
  802331:	5d                   	pop    %ebp
  802332:	c3                   	ret    

00802333 <pipeisclosed>:
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802339:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80233c:	50                   	push   %eax
  80233d:	ff 75 08             	pushl  0x8(%ebp)
  802340:	e8 73 ef ff ff       	call   8012b8 <fd_lookup>
  802345:	83 c4 10             	add    $0x10,%esp
  802348:	85 c0                	test   %eax,%eax
  80234a:	78 18                	js     802364 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80234c:	83 ec 0c             	sub    $0xc,%esp
  80234f:	ff 75 f4             	pushl  -0xc(%ebp)
  802352:	e8 f8 ee ff ff       	call   80124f <fd2data>
	return _pipeisclosed(fd, p);
  802357:	89 c2                	mov    %eax,%edx
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	e8 2f fd ff ff       	call   802090 <_pipeisclosed>
  802361:	83 c4 10             	add    $0x10,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	56                   	push   %esi
  80236a:	53                   	push   %ebx
  80236b:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80236e:	85 f6                	test   %esi,%esi
  802370:	74 15                	je     802387 <wait+0x21>
	e = &envs[ENVX(envid)];
  802372:	89 f0                	mov    %esi,%eax
  802374:	25 ff 03 00 00       	and    $0x3ff,%eax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802379:	8d 1c c0             	lea    (%eax,%eax,8),%ebx
  80237c:	c1 e3 04             	shl    $0x4,%ebx
  80237f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802385:	eb 1b                	jmp    8023a2 <wait+0x3c>
	assert(envid != 0);
  802387:	68 df 2d 80 00       	push   $0x802ddf
  80238c:	68 df 2c 80 00       	push   $0x802cdf
  802391:	6a 09                	push   $0x9
  802393:	68 ea 2d 80 00       	push   $0x802dea
  802398:	e8 54 e0 ff ff       	call   8003f1 <_panic>
		sys_yield();
  80239d:	e8 0b ec ff ff       	call   800fad <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8023a2:	8b 43 48             	mov    0x48(%ebx),%eax
  8023a5:	39 f0                	cmp    %esi,%eax
  8023a7:	75 07                	jne    8023b0 <wait+0x4a>
  8023a9:	8b 43 54             	mov    0x54(%ebx),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	75 ed                	jne    80239d <wait+0x37>
}
  8023b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023b3:	5b                   	pop    %ebx
  8023b4:	5e                   	pop    %esi
  8023b5:	5d                   	pop    %ebp
  8023b6:	c3                   	ret    

008023b7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	56                   	push   %esi
  8023bb:	53                   	push   %ebx
  8023bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8023bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  8023c5:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8023c7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023cc:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  8023cf:	83 ec 0c             	sub    $0xc,%esp
  8023d2:	50                   	push   %eax
  8023d3:	e8 e5 ed ff ff       	call   8011bd <sys_ipc_recv>
	if (from_env_store)
  8023d8:	83 c4 10             	add    $0x10,%esp
  8023db:	85 f6                	test   %esi,%esi
  8023dd:	74 14                	je     8023f3 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  8023df:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	78 09                	js     8023f1 <ipc_recv+0x3a>
  8023e8:	8b 15 90 67 80 00    	mov    0x806790,%edx
  8023ee:	8b 52 78             	mov    0x78(%edx),%edx
  8023f1:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  8023f3:	85 db                	test   %ebx,%ebx
  8023f5:	74 14                	je     80240b <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  8023f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8023fc:	85 c0                	test   %eax,%eax
  8023fe:	78 09                	js     802409 <ipc_recv+0x52>
  802400:	8b 15 90 67 80 00    	mov    0x806790,%edx
  802406:	8b 52 7c             	mov    0x7c(%edx),%edx
  802409:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  80240b:	85 c0                	test   %eax,%eax
  80240d:	78 08                	js     802417 <ipc_recv+0x60>
  80240f:	a1 90 67 80 00       	mov    0x806790,%eax
  802414:	8b 40 74             	mov    0x74(%eax),%eax
}
  802417:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241a:	5b                   	pop    %ebx
  80241b:	5e                   	pop    %esi
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    

0080241e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 08             	sub    $0x8,%esp
  802424:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  802427:	85 c0                	test   %eax,%eax
  802429:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80242e:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802431:	ff 75 14             	pushl  0x14(%ebp)
  802434:	50                   	push   %eax
  802435:	ff 75 0c             	pushl  0xc(%ebp)
  802438:	ff 75 08             	pushl  0x8(%ebp)
  80243b:	e8 5a ed ff ff       	call   80119a <sys_ipc_try_send>
  802440:	83 c4 10             	add    $0x10,%esp
  802443:	85 c0                	test   %eax,%eax
  802445:	78 02                	js     802449 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  802449:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80244c:	75 07                	jne    802455 <ipc_send+0x37>
		sys_yield();
  80244e:	e8 5a eb ff ff       	call   800fad <sys_yield>
}
  802453:	eb f2                	jmp    802447 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  802455:	50                   	push   %eax
  802456:	68 f5 2d 80 00       	push   $0x802df5
  80245b:	6a 3c                	push   $0x3c
  80245d:	68 09 2e 80 00       	push   $0x802e09
  802462:	e8 8a df ff ff       	call   8003f1 <_panic>

00802467 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80246d:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  802472:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802475:	c1 e0 04             	shl    $0x4,%eax
  802478:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80247d:	8b 40 50             	mov    0x50(%eax),%eax
  802480:	39 c8                	cmp    %ecx,%eax
  802482:	74 12                	je     802496 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802484:	83 c2 01             	add    $0x1,%edx
  802487:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80248d:	75 e3                	jne    802472 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
  802494:	eb 0e                	jmp    8024a4 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802496:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802499:	c1 e0 04             	shl    $0x4,%eax
  80249c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024a1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    

008024a6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024ac:	89 d0                	mov    %edx,%eax
  8024ae:	c1 e8 16             	shr    $0x16,%eax
  8024b1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024bd:	f6 c1 01             	test   $0x1,%cl
  8024c0:	74 1d                	je     8024df <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024c2:	c1 ea 0c             	shr    $0xc,%edx
  8024c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024cc:	f6 c2 01             	test   $0x1,%dl
  8024cf:	74 0e                	je     8024df <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024d1:	c1 ea 0c             	shr    $0xc,%edx
  8024d4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024db:	ef 
  8024dc:	0f b7 c0             	movzwl %ax,%eax
}
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
  8024e1:	66 90                	xchg   %ax,%ax
  8024e3:	66 90                	xchg   %ax,%ax
  8024e5:	66 90                	xchg   %ax,%ax
  8024e7:	66 90                	xchg   %ax,%ax
  8024e9:	66 90                	xchg   %ax,%ax
  8024eb:	66 90                	xchg   %ax,%ax
  8024ed:	66 90                	xchg   %ax,%ax
  8024ef:	90                   	nop

008024f0 <__udivdi3>:
  8024f0:	55                   	push   %ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	53                   	push   %ebx
  8024f4:	83 ec 1c             	sub    $0x1c,%esp
  8024f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802503:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802507:	85 d2                	test   %edx,%edx
  802509:	75 4d                	jne    802558 <__udivdi3+0x68>
  80250b:	39 f3                	cmp    %esi,%ebx
  80250d:	76 19                	jbe    802528 <__udivdi3+0x38>
  80250f:	31 ff                	xor    %edi,%edi
  802511:	89 e8                	mov    %ebp,%eax
  802513:	89 f2                	mov    %esi,%edx
  802515:	f7 f3                	div    %ebx
  802517:	89 fa                	mov    %edi,%edx
  802519:	83 c4 1c             	add    $0x1c,%esp
  80251c:	5b                   	pop    %ebx
  80251d:	5e                   	pop    %esi
  80251e:	5f                   	pop    %edi
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    
  802521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802528:	89 d9                	mov    %ebx,%ecx
  80252a:	85 db                	test   %ebx,%ebx
  80252c:	75 0b                	jne    802539 <__udivdi3+0x49>
  80252e:	b8 01 00 00 00       	mov    $0x1,%eax
  802533:	31 d2                	xor    %edx,%edx
  802535:	f7 f3                	div    %ebx
  802537:	89 c1                	mov    %eax,%ecx
  802539:	31 d2                	xor    %edx,%edx
  80253b:	89 f0                	mov    %esi,%eax
  80253d:	f7 f1                	div    %ecx
  80253f:	89 c6                	mov    %eax,%esi
  802541:	89 e8                	mov    %ebp,%eax
  802543:	89 f7                	mov    %esi,%edi
  802545:	f7 f1                	div    %ecx
  802547:	89 fa                	mov    %edi,%edx
  802549:	83 c4 1c             	add    $0x1c,%esp
  80254c:	5b                   	pop    %ebx
  80254d:	5e                   	pop    %esi
  80254e:	5f                   	pop    %edi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    
  802551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802558:	39 f2                	cmp    %esi,%edx
  80255a:	77 1c                	ja     802578 <__udivdi3+0x88>
  80255c:	0f bd fa             	bsr    %edx,%edi
  80255f:	83 f7 1f             	xor    $0x1f,%edi
  802562:	75 2c                	jne    802590 <__udivdi3+0xa0>
  802564:	39 f2                	cmp    %esi,%edx
  802566:	72 06                	jb     80256e <__udivdi3+0x7e>
  802568:	31 c0                	xor    %eax,%eax
  80256a:	39 eb                	cmp    %ebp,%ebx
  80256c:	77 a9                	ja     802517 <__udivdi3+0x27>
  80256e:	b8 01 00 00 00       	mov    $0x1,%eax
  802573:	eb a2                	jmp    802517 <__udivdi3+0x27>
  802575:	8d 76 00             	lea    0x0(%esi),%esi
  802578:	31 ff                	xor    %edi,%edi
  80257a:	31 c0                	xor    %eax,%eax
  80257c:	89 fa                	mov    %edi,%edx
  80257e:	83 c4 1c             	add    $0x1c,%esp
  802581:	5b                   	pop    %ebx
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	89 f9                	mov    %edi,%ecx
  802592:	b8 20 00 00 00       	mov    $0x20,%eax
  802597:	29 f8                	sub    %edi,%eax
  802599:	d3 e2                	shl    %cl,%edx
  80259b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80259f:	89 c1                	mov    %eax,%ecx
  8025a1:	89 da                	mov    %ebx,%edx
  8025a3:	d3 ea                	shr    %cl,%edx
  8025a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025a9:	09 d1                	or     %edx,%ecx
  8025ab:	89 f2                	mov    %esi,%edx
  8025ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025b1:	89 f9                	mov    %edi,%ecx
  8025b3:	d3 e3                	shl    %cl,%ebx
  8025b5:	89 c1                	mov    %eax,%ecx
  8025b7:	d3 ea                	shr    %cl,%edx
  8025b9:	89 f9                	mov    %edi,%ecx
  8025bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025bf:	89 eb                	mov    %ebp,%ebx
  8025c1:	d3 e6                	shl    %cl,%esi
  8025c3:	89 c1                	mov    %eax,%ecx
  8025c5:	d3 eb                	shr    %cl,%ebx
  8025c7:	09 de                	or     %ebx,%esi
  8025c9:	89 f0                	mov    %esi,%eax
  8025cb:	f7 74 24 08          	divl   0x8(%esp)
  8025cf:	89 d6                	mov    %edx,%esi
  8025d1:	89 c3                	mov    %eax,%ebx
  8025d3:	f7 64 24 0c          	mull   0xc(%esp)
  8025d7:	39 d6                	cmp    %edx,%esi
  8025d9:	72 15                	jb     8025f0 <__udivdi3+0x100>
  8025db:	89 f9                	mov    %edi,%ecx
  8025dd:	d3 e5                	shl    %cl,%ebp
  8025df:	39 c5                	cmp    %eax,%ebp
  8025e1:	73 04                	jae    8025e7 <__udivdi3+0xf7>
  8025e3:	39 d6                	cmp    %edx,%esi
  8025e5:	74 09                	je     8025f0 <__udivdi3+0x100>
  8025e7:	89 d8                	mov    %ebx,%eax
  8025e9:	31 ff                	xor    %edi,%edi
  8025eb:	e9 27 ff ff ff       	jmp    802517 <__udivdi3+0x27>
  8025f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025f3:	31 ff                	xor    %edi,%edi
  8025f5:	e9 1d ff ff ff       	jmp    802517 <__udivdi3+0x27>
  8025fa:	66 90                	xchg   %ax,%ax
  8025fc:	66 90                	xchg   %ax,%ax
  8025fe:	66 90                	xchg   %ax,%ax

00802600 <__umoddi3>:
  802600:	55                   	push   %ebp
  802601:	57                   	push   %edi
  802602:	56                   	push   %esi
  802603:	53                   	push   %ebx
  802604:	83 ec 1c             	sub    $0x1c,%esp
  802607:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80260b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80260f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802613:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802617:	89 da                	mov    %ebx,%edx
  802619:	85 c0                	test   %eax,%eax
  80261b:	75 43                	jne    802660 <__umoddi3+0x60>
  80261d:	39 df                	cmp    %ebx,%edi
  80261f:	76 17                	jbe    802638 <__umoddi3+0x38>
  802621:	89 f0                	mov    %esi,%eax
  802623:	f7 f7                	div    %edi
  802625:	89 d0                	mov    %edx,%eax
  802627:	31 d2                	xor    %edx,%edx
  802629:	83 c4 1c             	add    $0x1c,%esp
  80262c:	5b                   	pop    %ebx
  80262d:	5e                   	pop    %esi
  80262e:	5f                   	pop    %edi
  80262f:	5d                   	pop    %ebp
  802630:	c3                   	ret    
  802631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802638:	89 fd                	mov    %edi,%ebp
  80263a:	85 ff                	test   %edi,%edi
  80263c:	75 0b                	jne    802649 <__umoddi3+0x49>
  80263e:	b8 01 00 00 00       	mov    $0x1,%eax
  802643:	31 d2                	xor    %edx,%edx
  802645:	f7 f7                	div    %edi
  802647:	89 c5                	mov    %eax,%ebp
  802649:	89 d8                	mov    %ebx,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	f7 f5                	div    %ebp
  80264f:	89 f0                	mov    %esi,%eax
  802651:	f7 f5                	div    %ebp
  802653:	89 d0                	mov    %edx,%eax
  802655:	eb d0                	jmp    802627 <__umoddi3+0x27>
  802657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80265e:	66 90                	xchg   %ax,%ax
  802660:	89 f1                	mov    %esi,%ecx
  802662:	39 d8                	cmp    %ebx,%eax
  802664:	76 0a                	jbe    802670 <__umoddi3+0x70>
  802666:	89 f0                	mov    %esi,%eax
  802668:	83 c4 1c             	add    $0x1c,%esp
  80266b:	5b                   	pop    %ebx
  80266c:	5e                   	pop    %esi
  80266d:	5f                   	pop    %edi
  80266e:	5d                   	pop    %ebp
  80266f:	c3                   	ret    
  802670:	0f bd e8             	bsr    %eax,%ebp
  802673:	83 f5 1f             	xor    $0x1f,%ebp
  802676:	75 20                	jne    802698 <__umoddi3+0x98>
  802678:	39 d8                	cmp    %ebx,%eax
  80267a:	0f 82 b0 00 00 00    	jb     802730 <__umoddi3+0x130>
  802680:	39 f7                	cmp    %esi,%edi
  802682:	0f 86 a8 00 00 00    	jbe    802730 <__umoddi3+0x130>
  802688:	89 c8                	mov    %ecx,%eax
  80268a:	83 c4 1c             	add    $0x1c,%esp
  80268d:	5b                   	pop    %ebx
  80268e:	5e                   	pop    %esi
  80268f:	5f                   	pop    %edi
  802690:	5d                   	pop    %ebp
  802691:	c3                   	ret    
  802692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802698:	89 e9                	mov    %ebp,%ecx
  80269a:	ba 20 00 00 00       	mov    $0x20,%edx
  80269f:	29 ea                	sub    %ebp,%edx
  8026a1:	d3 e0                	shl    %cl,%eax
  8026a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026a7:	89 d1                	mov    %edx,%ecx
  8026a9:	89 f8                	mov    %edi,%eax
  8026ab:	d3 e8                	shr    %cl,%eax
  8026ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026b9:	09 c1                	or     %eax,%ecx
  8026bb:	89 d8                	mov    %ebx,%eax
  8026bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026c1:	89 e9                	mov    %ebp,%ecx
  8026c3:	d3 e7                	shl    %cl,%edi
  8026c5:	89 d1                	mov    %edx,%ecx
  8026c7:	d3 e8                	shr    %cl,%eax
  8026c9:	89 e9                	mov    %ebp,%ecx
  8026cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026cf:	d3 e3                	shl    %cl,%ebx
  8026d1:	89 c7                	mov    %eax,%edi
  8026d3:	89 d1                	mov    %edx,%ecx
  8026d5:	89 f0                	mov    %esi,%eax
  8026d7:	d3 e8                	shr    %cl,%eax
  8026d9:	89 e9                	mov    %ebp,%ecx
  8026db:	89 fa                	mov    %edi,%edx
  8026dd:	d3 e6                	shl    %cl,%esi
  8026df:	09 d8                	or     %ebx,%eax
  8026e1:	f7 74 24 08          	divl   0x8(%esp)
  8026e5:	89 d1                	mov    %edx,%ecx
  8026e7:	89 f3                	mov    %esi,%ebx
  8026e9:	f7 64 24 0c          	mull   0xc(%esp)
  8026ed:	89 c6                	mov    %eax,%esi
  8026ef:	89 d7                	mov    %edx,%edi
  8026f1:	39 d1                	cmp    %edx,%ecx
  8026f3:	72 06                	jb     8026fb <__umoddi3+0xfb>
  8026f5:	75 10                	jne    802707 <__umoddi3+0x107>
  8026f7:	39 c3                	cmp    %eax,%ebx
  8026f9:	73 0c                	jae    802707 <__umoddi3+0x107>
  8026fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802703:	89 d7                	mov    %edx,%edi
  802705:	89 c6                	mov    %eax,%esi
  802707:	89 ca                	mov    %ecx,%edx
  802709:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80270e:	29 f3                	sub    %esi,%ebx
  802710:	19 fa                	sbb    %edi,%edx
  802712:	89 d0                	mov    %edx,%eax
  802714:	d3 e0                	shl    %cl,%eax
  802716:	89 e9                	mov    %ebp,%ecx
  802718:	d3 eb                	shr    %cl,%ebx
  80271a:	d3 ea                	shr    %cl,%edx
  80271c:	09 d8                	or     %ebx,%eax
  80271e:	83 c4 1c             	add    $0x1c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    
  802726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80272d:	8d 76 00             	lea    0x0(%esi),%esi
  802730:	89 da                	mov    %ebx,%edx
  802732:	29 fe                	sub    %edi,%esi
  802734:	19 c2                	sbb    %eax,%edx
  802736:	89 f1                	mov    %esi,%ecx
  802738:	89 c8                	mov    %ecx,%eax
  80273a:	e9 4b ff ff ff       	jmp    80268a <__umoddi3+0x8a>
