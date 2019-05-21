
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 29 02 00 00       	call   80025a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 1d 0f 00 00       	call   800f61 <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 46 13 00 00       	call   801399 <close>
	if ((r = opencons()) < 0)
  800053:	e8 b0 01 00 00       	call   800208 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	78 14                	js     800073 <umain+0x40>
		panic("opencons: %e", r);
	if (r != 0)
  80005f:	74 24                	je     800085 <umain+0x52>
		panic("first opencons used fd %d", r);
  800061:	50                   	push   %eax
  800062:	68 dc 21 80 00       	push   $0x8021dc
  800067:	6a 11                	push   $0x11
  800069:	68 cd 21 80 00       	push   $0x8021cd
  80006e:	e8 42 02 00 00       	call   8002b5 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 c0 21 80 00       	push   $0x8021c0
  800079:	6a 0f                	push   $0xf
  80007b:	68 cd 21 80 00       	push   $0x8021cd
  800080:	e8 30 02 00 00       	call   8002b5 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 5a 13 00 00       	call   8013eb <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 f6 21 80 00       	push   $0x8021f6
  80009e:	6a 13                	push   $0x13
  8000a0:	68 cd 21 80 00       	push   $0x8021cd
  8000a5:	e8 0b 02 00 00       	call   8002b5 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 10 22 80 00       	push   $0x802210
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 0d 1a 00 00       	call   801ac6 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 fe 21 80 00       	push   $0x8021fe
  8000c4:	e8 9c 09 00 00       	call   800a65 <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 0c 22 80 00       	push   $0x80220c
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 e6 19 00 00       	call   801ac6 <fprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	eb d7                	jmp    8000bc <umain+0x89>

008000e5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8000e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ea:	c3                   	ret    

008000eb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f1:	68 28 22 80 00       	push   $0x802228
  8000f6:	ff 75 0c             	pushl  0xc(%ebp)
  8000f9:	e8 90 0a 00 00       	call   800b8e <strcpy>
	return 0;
}
  8000fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <devcons_write>:
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	57                   	push   %edi
  800109:	56                   	push   %esi
  80010a:	53                   	push   %ebx
  80010b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800111:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800116:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80011c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80011f:	73 31                	jae    800152 <devcons_write+0x4d>
		m = n - tot;
  800121:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800124:	29 f3                	sub    %esi,%ebx
  800126:	83 fb 7f             	cmp    $0x7f,%ebx
  800129:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80012e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	53                   	push   %ebx
  800135:	89 f0                	mov    %esi,%eax
  800137:	03 45 0c             	add    0xc(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	57                   	push   %edi
  80013c:	e8 db 0b 00 00       	call   800d1c <memmove>
		sys_cputs(buf, m);
  800141:	83 c4 08             	add    $0x8,%esp
  800144:	53                   	push   %ebx
  800145:	57                   	push   %edi
  800146:	e8 79 0d 00 00       	call   800ec4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80014b:	01 de                	add    %ebx,%esi
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	eb ca                	jmp    80011c <devcons_write+0x17>
}
  800152:	89 f0                	mov    %esi,%eax
  800154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800157:	5b                   	pop    %ebx
  800158:	5e                   	pop    %esi
  800159:	5f                   	pop    %edi
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    

0080015c <devcons_read>:
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016b:	74 21                	je     80018e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80016d:	e8 70 0d 00 00       	call   800ee2 <sys_cgetc>
  800172:	85 c0                	test   %eax,%eax
  800174:	75 07                	jne    80017d <devcons_read+0x21>
		sys_yield();
  800176:	e8 e6 0d 00 00       	call   800f61 <sys_yield>
  80017b:	eb f0                	jmp    80016d <devcons_read+0x11>
	if (c < 0)
  80017d:	78 0f                	js     80018e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80017f:	83 f8 04             	cmp    $0x4,%eax
  800182:	74 0c                	je     800190 <devcons_read+0x34>
	*(char*)vbuf = c;
  800184:	8b 55 0c             	mov    0xc(%ebp),%edx
  800187:	88 02                	mov    %al,(%edx)
	return 1;
  800189:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    
		return 0;
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	eb f7                	jmp    80018e <devcons_read+0x32>

00800197 <cputchar>:
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001a3:	6a 01                	push   $0x1
  8001a5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 16 0d 00 00       	call   800ec4 <sys_cputs>
}
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <getchar>:
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001b9:	6a 01                	push   $0x1
  8001bb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	6a 00                	push   $0x0
  8001c1:	e8 11 13 00 00       	call   8014d7 <read>
	if (r < 0)
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	78 06                	js     8001d3 <getchar+0x20>
	if (r < 1)
  8001cd:	74 06                	je     8001d5 <getchar+0x22>
	return c;
  8001cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001d3:	c9                   	leave  
  8001d4:	c3                   	ret    
		return -E_EOF;
  8001d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001da:	eb f7                	jmp    8001d3 <getchar+0x20>

008001dc <iscons>:
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001e5:	50                   	push   %eax
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 7e 10 00 00       	call   80126c <fd_lookup>
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	78 11                	js     800206 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8001fe:	39 10                	cmp    %edx,(%eax)
  800200:	0f 94 c0             	sete   %al
  800203:	0f b6 c0             	movzbl %al,%eax
}
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <opencons>:
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80020e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800211:	50                   	push   %eax
  800212:	e8 03 10 00 00       	call   80121a <fd_alloc>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	85 c0                	test   %eax,%eax
  80021c:	78 3a                	js     800258 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 07 04 00 00       	push   $0x407
  800226:	ff 75 f4             	pushl  -0xc(%ebp)
  800229:	6a 00                	push   $0x0
  80022b:	e8 50 0d 00 00       	call   800f80 <sys_page_alloc>
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	85 c0                	test   %eax,%eax
  800235:	78 21                	js     800258 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023a:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800240:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	e8 9e 0f 00 00       	call   8011f3 <fd2num>
  800255:	83 c4 10             	add    $0x10,%esp
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800262:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800265:	e8 d8 0c 00 00       	call   800f42 <sys_getenvid>
  80026a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026f:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80027a:	a3 04 44 80 00       	mov    %eax,0x804404

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027f:	85 db                	test   %ebx,%ebx
  800281:	7e 07                	jle    80028a <libmain+0x30>
		binaryname = argv[0];
  800283:	8b 06                	mov    (%esi),%eax
  800285:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
  80028f:	e8 9f fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800294:	e8 0a 00 00 00       	call   8002a3 <exit>
}
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8002a9:	6a 00                	push   $0x0
  8002ab:	e8 51 0c 00 00       	call   800f01 <sys_env_destroy>
}
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002ba:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002bd:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002c3:	e8 7a 0c 00 00       	call   800f42 <sys_getenvid>
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	ff 75 0c             	pushl  0xc(%ebp)
  8002ce:	ff 75 08             	pushl  0x8(%ebp)
  8002d1:	56                   	push   %esi
  8002d2:	50                   	push   %eax
  8002d3:	68 40 22 80 00       	push   $0x802240
  8002d8:	e8 b3 00 00 00       	call   800390 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002dd:	83 c4 18             	add    $0x18,%esp
  8002e0:	53                   	push   %ebx
  8002e1:	ff 75 10             	pushl  0x10(%ebp)
  8002e4:	e8 56 00 00 00       	call   80033f <vcprintf>
	cprintf("\n");
  8002e9:	c7 04 24 26 22 80 00 	movl   $0x802226,(%esp)
  8002f0:	e8 9b 00 00 00       	call   800390 <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002f8:	cc                   	int3   
  8002f9:	eb fd                	jmp    8002f8 <_panic+0x43>

008002fb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	53                   	push   %ebx
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800305:	8b 13                	mov    (%ebx),%edx
  800307:	8d 42 01             	lea    0x1(%edx),%eax
  80030a:	89 03                	mov    %eax,(%ebx)
  80030c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80030f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800313:	3d ff 00 00 00       	cmp    $0xff,%eax
  800318:	74 09                	je     800323 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80031a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800321:	c9                   	leave  
  800322:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	68 ff 00 00 00       	push   $0xff
  80032b:	8d 43 08             	lea    0x8(%ebx),%eax
  80032e:	50                   	push   %eax
  80032f:	e8 90 0b 00 00       	call   800ec4 <sys_cputs>
		b->idx = 0;
  800334:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80033a:	83 c4 10             	add    $0x10,%esp
  80033d:	eb db                	jmp    80031a <putch+0x1f>

0080033f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800348:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80034f:	00 00 00 
	b.cnt = 0;
  800352:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800359:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800368:	50                   	push   %eax
  800369:	68 fb 02 80 00       	push   $0x8002fb
  80036e:	e8 4a 01 00 00       	call   8004bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800373:	83 c4 08             	add    $0x8,%esp
  800376:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80037c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800382:	50                   	push   %eax
  800383:	e8 3c 0b 00 00       	call   800ec4 <sys_cputs>

	return b.cnt;
}
  800388:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800396:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800399:	50                   	push   %eax
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 9d ff ff ff       	call   80033f <vcprintf>
	va_end(ap);

	return cnt;
}
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	57                   	push   %edi
  8003a8:	56                   	push   %esi
  8003a9:	53                   	push   %ebx
  8003aa:	83 ec 1c             	sub    $0x1c,%esp
  8003ad:	89 c6                	mov    %eax,%esi
  8003af:	89 d7                	mov    %edx,%edi
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003c3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003c7:	74 2c                	je     8003f5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003de:	73 43                	jae    800423 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e0:	83 eb 01             	sub    $0x1,%ebx
  8003e3:	85 db                	test   %ebx,%ebx
  8003e5:	7e 6c                	jle    800453 <printnum+0xaf>
			putch(padc, putdat);
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	57                   	push   %edi
  8003eb:	ff 75 18             	pushl  0x18(%ebp)
  8003ee:	ff d6                	call   *%esi
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	eb eb                	jmp    8003e0 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	6a 20                	push   $0x20
  8003fa:	6a 00                	push   $0x0
  8003fc:	50                   	push   %eax
  8003fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800400:	ff 75 e0             	pushl  -0x20(%ebp)
  800403:	89 fa                	mov    %edi,%edx
  800405:	89 f0                	mov    %esi,%eax
  800407:	e8 98 ff ff ff       	call   8003a4 <printnum>
		while (--width > 0)
  80040c:	83 c4 20             	add    $0x20,%esp
  80040f:	83 eb 01             	sub    $0x1,%ebx
  800412:	85 db                	test   %ebx,%ebx
  800414:	7e 65                	jle    80047b <printnum+0xd7>
			putch(padc, putdat);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	57                   	push   %edi
  80041a:	6a 20                	push   $0x20
  80041c:	ff d6                	call   *%esi
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	eb ec                	jmp    80040f <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 18             	pushl  0x18(%ebp)
  800429:	83 eb 01             	sub    $0x1,%ebx
  80042c:	53                   	push   %ebx
  80042d:	50                   	push   %eax
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	ff 75 dc             	pushl  -0x24(%ebp)
  800434:	ff 75 d8             	pushl  -0x28(%ebp)
  800437:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043a:	ff 75 e0             	pushl  -0x20(%ebp)
  80043d:	e8 2e 1b 00 00       	call   801f70 <__udivdi3>
  800442:	83 c4 18             	add    $0x18,%esp
  800445:	52                   	push   %edx
  800446:	50                   	push   %eax
  800447:	89 fa                	mov    %edi,%edx
  800449:	89 f0                	mov    %esi,%eax
  80044b:	e8 54 ff ff ff       	call   8003a4 <printnum>
  800450:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	57                   	push   %edi
  800457:	83 ec 04             	sub    $0x4,%esp
  80045a:	ff 75 dc             	pushl  -0x24(%ebp)
  80045d:	ff 75 d8             	pushl  -0x28(%ebp)
  800460:	ff 75 e4             	pushl  -0x1c(%ebp)
  800463:	ff 75 e0             	pushl  -0x20(%ebp)
  800466:	e8 15 1c 00 00       	call   802080 <__umoddi3>
  80046b:	83 c4 14             	add    $0x14,%esp
  80046e:	0f be 80 63 22 80 00 	movsbl 0x802263(%eax),%eax
  800475:	50                   	push   %eax
  800476:	ff d6                	call   *%esi
  800478:	83 c4 10             	add    $0x10,%esp
}
  80047b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047e:	5b                   	pop    %ebx
  80047f:	5e                   	pop    %esi
  800480:	5f                   	pop    %edi
  800481:	5d                   	pop    %ebp
  800482:	c3                   	ret    

00800483 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800489:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80048d:	8b 10                	mov    (%eax),%edx
  80048f:	3b 50 04             	cmp    0x4(%eax),%edx
  800492:	73 0a                	jae    80049e <sprintputch+0x1b>
		*b->buf++ = ch;
  800494:	8d 4a 01             	lea    0x1(%edx),%ecx
  800497:	89 08                	mov    %ecx,(%eax)
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	88 02                	mov    %al,(%edx)
}
  80049e:	5d                   	pop    %ebp
  80049f:	c3                   	ret    

008004a0 <printfmt>:
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004a6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004a9:	50                   	push   %eax
  8004aa:	ff 75 10             	pushl  0x10(%ebp)
  8004ad:	ff 75 0c             	pushl  0xc(%ebp)
  8004b0:	ff 75 08             	pushl  0x8(%ebp)
  8004b3:	e8 05 00 00 00       	call   8004bd <vprintfmt>
}
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    

008004bd <vprintfmt>:
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	57                   	push   %edi
  8004c1:	56                   	push   %esi
  8004c2:	53                   	push   %ebx
  8004c3:	83 ec 3c             	sub    $0x3c,%esp
  8004c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004cf:	e9 b4 03 00 00       	jmp    800888 <vprintfmt+0x3cb>
		padc = ' ';
  8004d4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8004d8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8004df:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004e6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004ed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f9:	8d 47 01             	lea    0x1(%edi),%eax
  8004fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ff:	0f b6 17             	movzbl (%edi),%edx
  800502:	8d 42 dd             	lea    -0x23(%edx),%eax
  800505:	3c 55                	cmp    $0x55,%al
  800507:	0f 87 c8 04 00 00    	ja     8009d5 <vprintfmt+0x518>
  80050d:	0f b6 c0             	movzbl %al,%eax
  800510:	ff 24 85 40 24 80 00 	jmp    *0x802440(,%eax,4)
  800517:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  80051a:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800521:	eb d6                	jmp    8004f9 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800523:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800526:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80052a:	eb cd                	jmp    8004f9 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80052c:	0f b6 d2             	movzbl %dl,%edx
  80052f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800532:	b8 00 00 00 00       	mov    $0x0,%eax
  800537:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80053a:	eb 0c                	jmp    800548 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  80053c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80053f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800543:	eb b4                	jmp    8004f9 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800545:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800548:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80054b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80054f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800552:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800555:	83 f9 09             	cmp    $0x9,%ecx
  800558:	76 eb                	jbe    800545 <vprintfmt+0x88>
  80055a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80055d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800560:	eb 14                	jmp    800576 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8d 40 04             	lea    0x4(%eax),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800573:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800576:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057a:	0f 89 79 ff ff ff    	jns    8004f9 <vprintfmt+0x3c>
				width = precision, precision = -1;
  800580:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800583:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800586:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80058d:	e9 67 ff ff ff       	jmp    8004f9 <vprintfmt+0x3c>
  800592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	ba 00 00 00 00       	mov    $0x0,%edx
  80059c:	0f 49 d0             	cmovns %eax,%edx
  80059f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005a5:	e9 4f ff ff ff       	jmp    8004f9 <vprintfmt+0x3c>
  8005aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ad:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005b4:	e9 40 ff ff ff       	jmp    8004f9 <vprintfmt+0x3c>
			lflag++;
  8005b9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005bf:	e9 35 ff ff ff       	jmp    8004f9 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 78 04             	lea    0x4(%eax),%edi
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	53                   	push   %ebx
  8005ce:	ff 30                	pushl  (%eax)
  8005d0:	ff d6                	call   *%esi
			break;
  8005d2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005d5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d8:	e9 a8 02 00 00       	jmp    800885 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 78 04             	lea    0x4(%eax),%edi
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	99                   	cltd   
  8005e6:	31 d0                	xor    %edx,%eax
  8005e8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ea:	83 f8 0f             	cmp    $0xf,%eax
  8005ed:	7f 23                	jg     800612 <vprintfmt+0x155>
  8005ef:	8b 14 85 a0 25 80 00 	mov    0x8025a0(,%eax,4),%edx
  8005f6:	85 d2                	test   %edx,%edx
  8005f8:	74 18                	je     800612 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8005fa:	52                   	push   %edx
  8005fb:	68 c5 26 80 00       	push   $0x8026c5
  800600:	53                   	push   %ebx
  800601:	56                   	push   %esi
  800602:	e8 99 fe ff ff       	call   8004a0 <printfmt>
  800607:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80060a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80060d:	e9 73 02 00 00       	jmp    800885 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800612:	50                   	push   %eax
  800613:	68 7b 22 80 00       	push   $0x80227b
  800618:	53                   	push   %ebx
  800619:	56                   	push   %esi
  80061a:	e8 81 fe ff ff       	call   8004a0 <printfmt>
  80061f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800622:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800625:	e9 5b 02 00 00       	jmp    800885 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	83 c0 04             	add    $0x4,%eax
  800630:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800638:	85 d2                	test   %edx,%edx
  80063a:	b8 74 22 80 00       	mov    $0x802274,%eax
  80063f:	0f 45 c2             	cmovne %edx,%eax
  800642:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800645:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800649:	7e 06                	jle    800651 <vprintfmt+0x194>
  80064b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80064f:	75 0d                	jne    80065e <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800651:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800654:	89 c7                	mov    %eax,%edi
  800656:	03 45 e0             	add    -0x20(%ebp),%eax
  800659:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065c:	eb 53                	jmp    8006b1 <vprintfmt+0x1f4>
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 d8             	pushl  -0x28(%ebp)
  800664:	50                   	push   %eax
  800665:	e8 03 05 00 00       	call   800b6d <strnlen>
  80066a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80066d:	29 c1                	sub    %eax,%ecx
  80066f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800672:	83 c4 10             	add    $0x10,%esp
  800675:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800677:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80067e:	eb 0f                	jmp    80068f <vprintfmt+0x1d2>
					putch(padc, putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	ff 75 e0             	pushl  -0x20(%ebp)
  800687:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	83 ef 01             	sub    $0x1,%edi
  80068c:	83 c4 10             	add    $0x10,%esp
  80068f:	85 ff                	test   %edi,%edi
  800691:	7f ed                	jg     800680 <vprintfmt+0x1c3>
  800693:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800696:	85 d2                	test   %edx,%edx
  800698:	b8 00 00 00 00       	mov    $0x0,%eax
  80069d:	0f 49 c2             	cmovns %edx,%eax
  8006a0:	29 c2                	sub    %eax,%edx
  8006a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006a5:	eb aa                	jmp    800651 <vprintfmt+0x194>
					putch(ch, putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	52                   	push   %edx
  8006ac:	ff d6                	call   *%esi
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b6:	83 c7 01             	add    $0x1,%edi
  8006b9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bd:	0f be d0             	movsbl %al,%edx
  8006c0:	85 d2                	test   %edx,%edx
  8006c2:	74 4b                	je     80070f <vprintfmt+0x252>
  8006c4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c8:	78 06                	js     8006d0 <vprintfmt+0x213>
  8006ca:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006ce:	78 1e                	js     8006ee <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8006d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006d4:	74 d1                	je     8006a7 <vprintfmt+0x1ea>
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 e8 20             	sub    $0x20,%eax
  8006dc:	83 f8 5e             	cmp    $0x5e,%eax
  8006df:	76 c6                	jbe    8006a7 <vprintfmt+0x1ea>
					putch('?', putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	6a 3f                	push   $0x3f
  8006e7:	ff d6                	call   *%esi
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb c3                	jmp    8006b1 <vprintfmt+0x1f4>
  8006ee:	89 cf                	mov    %ecx,%edi
  8006f0:	eb 0e                	jmp    800700 <vprintfmt+0x243>
				putch(' ', putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 20                	push   $0x20
  8006f8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006fa:	83 ef 01             	sub    $0x1,%edi
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	85 ff                	test   %edi,%edi
  800702:	7f ee                	jg     8006f2 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800704:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
  80070a:	e9 76 01 00 00       	jmp    800885 <vprintfmt+0x3c8>
  80070f:	89 cf                	mov    %ecx,%edi
  800711:	eb ed                	jmp    800700 <vprintfmt+0x243>
	if (lflag >= 2)
  800713:	83 f9 01             	cmp    $0x1,%ecx
  800716:	7f 1f                	jg     800737 <vprintfmt+0x27a>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	74 6a                	je     800786 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	89 c1                	mov    %eax,%ecx
  800726:	c1 f9 1f             	sar    $0x1f,%ecx
  800729:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
  800735:	eb 17                	jmp    80074e <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 50 04             	mov    0x4(%eax),%edx
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 40 08             	lea    0x8(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80074e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800751:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800756:	85 d2                	test   %edx,%edx
  800758:	0f 89 f8 00 00 00    	jns    800856 <vprintfmt+0x399>
				putch('-', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 2d                	push   $0x2d
  800764:	ff d6                	call   *%esi
				num = -(long long) num;
  800766:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800769:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80076c:	f7 d8                	neg    %eax
  80076e:	83 d2 00             	adc    $0x0,%edx
  800771:	f7 da                	neg    %edx
  800773:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800776:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800779:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80077c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800781:	e9 e1 00 00 00       	jmp    800867 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078e:	99                   	cltd   
  80078f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8d 40 04             	lea    0x4(%eax),%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
  80079b:	eb b1                	jmp    80074e <vprintfmt+0x291>
	if (lflag >= 2)
  80079d:	83 f9 01             	cmp    $0x1,%ecx
  8007a0:	7f 27                	jg     8007c9 <vprintfmt+0x30c>
	else if (lflag)
  8007a2:	85 c9                	test   %ecx,%ecx
  8007a4:	74 41                	je     8007e7 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 40 04             	lea    0x4(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007bf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007c4:	e9 8d 00 00 00       	jmp    800856 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 50 04             	mov    0x4(%eax),%edx
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 40 08             	lea    0x8(%eax),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007e5:	eb 6f                	jmp    800856 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8d 40 04             	lea    0x4(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800800:	bf 0a 00 00 00       	mov    $0xa,%edi
  800805:	eb 4f                	jmp    800856 <vprintfmt+0x399>
	if (lflag >= 2)
  800807:	83 f9 01             	cmp    $0x1,%ecx
  80080a:	7f 23                	jg     80082f <vprintfmt+0x372>
	else if (lflag)
  80080c:	85 c9                	test   %ecx,%ecx
  80080e:	0f 84 98 00 00 00    	je     8008ac <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800821:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8d 40 04             	lea    0x4(%eax),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
  80082d:	eb 17                	jmp    800846 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 50 04             	mov    0x4(%eax),%edx
  800835:	8b 00                	mov    (%eax),%eax
  800837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 40 08             	lea    0x8(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	53                   	push   %ebx
  80084a:	6a 30                	push   $0x30
  80084c:	ff d6                	call   *%esi
			goto number;
  80084e:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800851:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800856:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80085a:	74 0b                	je     800867 <vprintfmt+0x3aa>
				putch('+', putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	6a 2b                	push   $0x2b
  800862:	ff d6                	call   *%esi
  800864:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800867:	83 ec 0c             	sub    $0xc,%esp
  80086a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80086e:	50                   	push   %eax
  80086f:	ff 75 e0             	pushl  -0x20(%ebp)
  800872:	57                   	push   %edi
  800873:	ff 75 dc             	pushl  -0x24(%ebp)
  800876:	ff 75 d8             	pushl  -0x28(%ebp)
  800879:	89 da                	mov    %ebx,%edx
  80087b:	89 f0                	mov    %esi,%eax
  80087d:	e8 22 fb ff ff       	call   8003a4 <printnum>
			break;
  800882:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800885:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800888:	83 c7 01             	add    $0x1,%edi
  80088b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80088f:	83 f8 25             	cmp    $0x25,%eax
  800892:	0f 84 3c fc ff ff    	je     8004d4 <vprintfmt+0x17>
			if (ch == '\0')
  800898:	85 c0                	test   %eax,%eax
  80089a:	0f 84 55 01 00 00    	je     8009f5 <vprintfmt+0x538>
			putch(ch, putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	53                   	push   %ebx
  8008a4:	50                   	push   %eax
  8008a5:	ff d6                	call   *%esi
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	eb dc                	jmp    800888 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8008ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	8d 40 04             	lea    0x4(%eax),%eax
  8008c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c5:	e9 7c ff ff ff       	jmp    800846 <vprintfmt+0x389>
			putch('0', putdat);
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	53                   	push   %ebx
  8008ce:	6a 30                	push   $0x30
  8008d0:	ff d6                	call   *%esi
			putch('x', putdat);
  8008d2:	83 c4 08             	add    $0x8,%esp
  8008d5:	53                   	push   %ebx
  8008d6:	6a 78                	push   $0x78
  8008d8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008ea:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8d 40 04             	lea    0x4(%eax),%eax
  8008f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f6:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8008fb:	e9 56 ff ff ff       	jmp    800856 <vprintfmt+0x399>
	if (lflag >= 2)
  800900:	83 f9 01             	cmp    $0x1,%ecx
  800903:	7f 27                	jg     80092c <vprintfmt+0x46f>
	else if (lflag)
  800905:	85 c9                	test   %ecx,%ecx
  800907:	74 44                	je     80094d <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	ba 00 00 00 00       	mov    $0x0,%edx
  800913:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800916:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8d 40 04             	lea    0x4(%eax),%eax
  80091f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800922:	bf 10 00 00 00       	mov    $0x10,%edi
  800927:	e9 2a ff ff ff       	jmp    800856 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 50 04             	mov    0x4(%eax),%edx
  800932:	8b 00                	mov    (%eax),%eax
  800934:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800937:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8d 40 08             	lea    0x8(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800943:	bf 10 00 00 00       	mov    $0x10,%edi
  800948:	e9 09 ff ff ff       	jmp    800856 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	ba 00 00 00 00       	mov    $0x0,%edx
  800957:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	8d 40 04             	lea    0x4(%eax),%eax
  800963:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800966:	bf 10 00 00 00       	mov    $0x10,%edi
  80096b:	e9 e6 fe ff ff       	jmp    800856 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800970:	8b 45 14             	mov    0x14(%ebp),%eax
  800973:	8d 78 04             	lea    0x4(%eax),%edi
  800976:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800978:	85 c0                	test   %eax,%eax
  80097a:	74 2d                	je     8009a9 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80097c:	0f b6 13             	movzbl (%ebx),%edx
  80097f:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800981:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800984:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800987:	0f 8e f8 fe ff ff    	jle    800885 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80098d:	68 d0 23 80 00       	push   $0x8023d0
  800992:	68 c5 26 80 00       	push   $0x8026c5
  800997:	53                   	push   %ebx
  800998:	56                   	push   %esi
  800999:	e8 02 fb ff ff       	call   8004a0 <printfmt>
  80099e:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009a1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009a4:	e9 dc fe ff ff       	jmp    800885 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  8009a9:	68 98 23 80 00       	push   $0x802398
  8009ae:	68 c5 26 80 00       	push   $0x8026c5
  8009b3:	53                   	push   %ebx
  8009b4:	56                   	push   %esi
  8009b5:	e8 e6 fa ff ff       	call   8004a0 <printfmt>
  8009ba:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009bd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009c0:	e9 c0 fe ff ff       	jmp    800885 <vprintfmt+0x3c8>
			putch(ch, putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	53                   	push   %ebx
  8009c9:	6a 25                	push   $0x25
  8009cb:	ff d6                	call   *%esi
			break;
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	e9 b0 fe ff ff       	jmp    800885 <vprintfmt+0x3c8>
			putch('%', putdat);
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	53                   	push   %ebx
  8009d9:	6a 25                	push   $0x25
  8009db:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	89 f8                	mov    %edi,%eax
  8009e2:	eb 03                	jmp    8009e7 <vprintfmt+0x52a>
  8009e4:	83 e8 01             	sub    $0x1,%eax
  8009e7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009eb:	75 f7                	jne    8009e4 <vprintfmt+0x527>
  8009ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f0:	e9 90 fe ff ff       	jmp    800885 <vprintfmt+0x3c8>
}
  8009f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5f                   	pop    %edi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 18             	sub    $0x18,%esp
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a0c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a10:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a1a:	85 c0                	test   %eax,%eax
  800a1c:	74 26                	je     800a44 <vsnprintf+0x47>
  800a1e:	85 d2                	test   %edx,%edx
  800a20:	7e 22                	jle    800a44 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a22:	ff 75 14             	pushl  0x14(%ebp)
  800a25:	ff 75 10             	pushl  0x10(%ebp)
  800a28:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a2b:	50                   	push   %eax
  800a2c:	68 83 04 80 00       	push   $0x800483
  800a31:	e8 87 fa ff ff       	call   8004bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a39:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a3f:	83 c4 10             	add    $0x10,%esp
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    
		return -E_INVAL;
  800a44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a49:	eb f7                	jmp    800a42 <vsnprintf+0x45>

00800a4b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a51:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a54:	50                   	push   %eax
  800a55:	ff 75 10             	pushl  0x10(%ebp)
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	ff 75 08             	pushl  0x8(%ebp)
  800a5e:	e8 9a ff ff ff       	call   8009fd <vsnprintf>
	va_end(ap);

	return rc;
}
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	57                   	push   %edi
  800a69:	56                   	push   %esi
  800a6a:	53                   	push   %ebx
  800a6b:	83 ec 0c             	sub    $0xc,%esp
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a71:	85 c0                	test   %eax,%eax
  800a73:	74 13                	je     800a88 <readline+0x23>
		fprintf(1, "%s", prompt);
  800a75:	83 ec 04             	sub    $0x4,%esp
  800a78:	50                   	push   %eax
  800a79:	68 c5 26 80 00       	push   $0x8026c5
  800a7e:	6a 01                	push   $0x1
  800a80:	e8 41 10 00 00       	call   801ac6 <fprintf>
  800a85:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800a88:	83 ec 0c             	sub    $0xc,%esp
  800a8b:	6a 00                	push   $0x0
  800a8d:	e8 4a f7 ff ff       	call   8001dc <iscons>
  800a92:	89 c7                	mov    %eax,%edi
  800a94:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800a97:	be 00 00 00 00       	mov    $0x0,%esi
  800a9c:	eb 57                	jmp    800af5 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800a9e:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800aa3:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800aa6:	75 08                	jne    800ab0 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5f                   	pop    %edi
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	53                   	push   %ebx
  800ab4:	68 e0 25 80 00       	push   $0x8025e0
  800ab9:	e8 d2 f8 ff ff       	call   800390 <cprintf>
  800abe:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac6:	eb e0                	jmp    800aa8 <readline+0x43>
			if (echoing)
  800ac8:	85 ff                	test   %edi,%edi
  800aca:	75 05                	jne    800ad1 <readline+0x6c>
			i--;
  800acc:	83 ee 01             	sub    $0x1,%esi
  800acf:	eb 24                	jmp    800af5 <readline+0x90>
				cputchar('\b');
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	6a 08                	push   $0x8
  800ad6:	e8 bc f6 ff ff       	call   800197 <cputchar>
  800adb:	83 c4 10             	add    $0x10,%esp
  800ade:	eb ec                	jmp    800acc <readline+0x67>
				cputchar(c);
  800ae0:	83 ec 0c             	sub    $0xc,%esp
  800ae3:	53                   	push   %ebx
  800ae4:	e8 ae f6 ff ff       	call   800197 <cputchar>
  800ae9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800aec:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800af2:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800af5:	e8 b9 f6 ff ff       	call   8001b3 <getchar>
  800afa:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800afc:	85 c0                	test   %eax,%eax
  800afe:	78 9e                	js     800a9e <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800b00:	83 f8 08             	cmp    $0x8,%eax
  800b03:	0f 94 c2             	sete   %dl
  800b06:	83 f8 7f             	cmp    $0x7f,%eax
  800b09:	0f 94 c0             	sete   %al
  800b0c:	08 c2                	or     %al,%dl
  800b0e:	74 04                	je     800b14 <readline+0xaf>
  800b10:	85 f6                	test   %esi,%esi
  800b12:	7f b4                	jg     800ac8 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b14:	83 fb 1f             	cmp    $0x1f,%ebx
  800b17:	7e 0e                	jle    800b27 <readline+0xc2>
  800b19:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800b1f:	7f 06                	jg     800b27 <readline+0xc2>
			if (echoing)
  800b21:	85 ff                	test   %edi,%edi
  800b23:	74 c7                	je     800aec <readline+0x87>
  800b25:	eb b9                	jmp    800ae0 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800b27:	83 fb 0a             	cmp    $0xa,%ebx
  800b2a:	74 05                	je     800b31 <readline+0xcc>
  800b2c:	83 fb 0d             	cmp    $0xd,%ebx
  800b2f:	75 c4                	jne    800af5 <readline+0x90>
			if (echoing)
  800b31:	85 ff                	test   %edi,%edi
  800b33:	75 11                	jne    800b46 <readline+0xe1>
			buf[i] = 0;
  800b35:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800b3c:	b8 00 40 80 00       	mov    $0x804000,%eax
  800b41:	e9 62 ff ff ff       	jmp    800aa8 <readline+0x43>
				cputchar('\n');
  800b46:	83 ec 0c             	sub    $0xc,%esp
  800b49:	6a 0a                	push   $0xa
  800b4b:	e8 47 f6 ff ff       	call   800197 <cputchar>
  800b50:	83 c4 10             	add    $0x10,%esp
  800b53:	eb e0                	jmp    800b35 <readline+0xd0>

00800b55 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b60:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b64:	74 05                	je     800b6b <strlen+0x16>
		n++;
  800b66:	83 c0 01             	add    $0x1,%eax
  800b69:	eb f5                	jmp    800b60 <strlen+0xb>
	return n;
}
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	39 c2                	cmp    %eax,%edx
  800b7d:	74 0d                	je     800b8c <strnlen+0x1f>
  800b7f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b83:	74 05                	je     800b8a <strnlen+0x1d>
		n++;
  800b85:	83 c2 01             	add    $0x1,%edx
  800b88:	eb f1                	jmp    800b7b <strnlen+0xe>
  800b8a:	89 d0                	mov    %edx,%eax
	return n;
}
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	53                   	push   %ebx
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b98:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ba1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ba4:	83 c2 01             	add    $0x1,%edx
  800ba7:	84 c9                	test   %cl,%cl
  800ba9:	75 f2                	jne    800b9d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bab:	5b                   	pop    %ebx
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 10             	sub    $0x10,%esp
  800bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bb8:	53                   	push   %ebx
  800bb9:	e8 97 ff ff ff       	call   800b55 <strlen>
  800bbe:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	01 d8                	add    %ebx,%eax
  800bc6:	50                   	push   %eax
  800bc7:	e8 c2 ff ff ff       	call   800b8e <strcpy>
	return dst;
}
  800bcc:	89 d8                	mov    %ebx,%eax
  800bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	56                   	push   %esi
  800bd7:	53                   	push   %ebx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bde:	89 c6                	mov    %eax,%esi
  800be0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be3:	89 c2                	mov    %eax,%edx
  800be5:	39 f2                	cmp    %esi,%edx
  800be7:	74 11                	je     800bfa <strncpy+0x27>
		*dst++ = *src;
  800be9:	83 c2 01             	add    $0x1,%edx
  800bec:	0f b6 19             	movzbl (%ecx),%ebx
  800bef:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bf2:	80 fb 01             	cmp    $0x1,%bl
  800bf5:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bf8:	eb eb                	jmp    800be5 <strncpy+0x12>
	}
	return ret;
}
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	56                   	push   %esi
  800c02:	53                   	push   %ebx
  800c03:	8b 75 08             	mov    0x8(%ebp),%esi
  800c06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c09:	8b 55 10             	mov    0x10(%ebp),%edx
  800c0c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c0e:	85 d2                	test   %edx,%edx
  800c10:	74 21                	je     800c33 <strlcpy+0x35>
  800c12:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c16:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c18:	39 c2                	cmp    %eax,%edx
  800c1a:	74 14                	je     800c30 <strlcpy+0x32>
  800c1c:	0f b6 19             	movzbl (%ecx),%ebx
  800c1f:	84 db                	test   %bl,%bl
  800c21:	74 0b                	je     800c2e <strlcpy+0x30>
			*dst++ = *src++;
  800c23:	83 c1 01             	add    $0x1,%ecx
  800c26:	83 c2 01             	add    $0x1,%edx
  800c29:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c2c:	eb ea                	jmp    800c18 <strlcpy+0x1a>
  800c2e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c30:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c33:	29 f0                	sub    %esi,%eax
}
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c42:	0f b6 01             	movzbl (%ecx),%eax
  800c45:	84 c0                	test   %al,%al
  800c47:	74 0c                	je     800c55 <strcmp+0x1c>
  800c49:	3a 02                	cmp    (%edx),%al
  800c4b:	75 08                	jne    800c55 <strcmp+0x1c>
		p++, q++;
  800c4d:	83 c1 01             	add    $0x1,%ecx
  800c50:	83 c2 01             	add    $0x1,%edx
  800c53:	eb ed                	jmp    800c42 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c55:	0f b6 c0             	movzbl %al,%eax
  800c58:	0f b6 12             	movzbl (%edx),%edx
  800c5b:	29 d0                	sub    %edx,%eax
}
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c69:	89 c3                	mov    %eax,%ebx
  800c6b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c6e:	eb 06                	jmp    800c76 <strncmp+0x17>
		n--, p++, q++;
  800c70:	83 c0 01             	add    $0x1,%eax
  800c73:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c76:	39 d8                	cmp    %ebx,%eax
  800c78:	74 16                	je     800c90 <strncmp+0x31>
  800c7a:	0f b6 08             	movzbl (%eax),%ecx
  800c7d:	84 c9                	test   %cl,%cl
  800c7f:	74 04                	je     800c85 <strncmp+0x26>
  800c81:	3a 0a                	cmp    (%edx),%cl
  800c83:	74 eb                	je     800c70 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c85:	0f b6 00             	movzbl (%eax),%eax
  800c88:	0f b6 12             	movzbl (%edx),%edx
  800c8b:	29 d0                	sub    %edx,%eax
}
  800c8d:	5b                   	pop    %ebx
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    
		return 0;
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
  800c95:	eb f6                	jmp    800c8d <strncmp+0x2e>

00800c97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca1:	0f b6 10             	movzbl (%eax),%edx
  800ca4:	84 d2                	test   %dl,%dl
  800ca6:	74 09                	je     800cb1 <strchr+0x1a>
		if (*s == c)
  800ca8:	38 ca                	cmp    %cl,%dl
  800caa:	74 0a                	je     800cb6 <strchr+0x1f>
	for (; *s; s++)
  800cac:	83 c0 01             	add    $0x1,%eax
  800caf:	eb f0                	jmp    800ca1 <strchr+0xa>
			return (char *) s;
	return 0;
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cc5:	38 ca                	cmp    %cl,%dl
  800cc7:	74 09                	je     800cd2 <strfind+0x1a>
  800cc9:	84 d2                	test   %dl,%dl
  800ccb:	74 05                	je     800cd2 <strfind+0x1a>
	for (; *s; s++)
  800ccd:	83 c0 01             	add    $0x1,%eax
  800cd0:	eb f0                	jmp    800cc2 <strfind+0xa>
			break;
	return (char *) s;
}
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce0:	85 c9                	test   %ecx,%ecx
  800ce2:	74 31                	je     800d15 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce4:	89 f8                	mov    %edi,%eax
  800ce6:	09 c8                	or     %ecx,%eax
  800ce8:	a8 03                	test   $0x3,%al
  800cea:	75 23                	jne    800d0f <memset+0x3b>
		c &= 0xFF;
  800cec:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf0:	89 d3                	mov    %edx,%ebx
  800cf2:	c1 e3 08             	shl    $0x8,%ebx
  800cf5:	89 d0                	mov    %edx,%eax
  800cf7:	c1 e0 18             	shl    $0x18,%eax
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	c1 e6 10             	shl    $0x10,%esi
  800cff:	09 f0                	or     %esi,%eax
  800d01:	09 c2                	or     %eax,%edx
  800d03:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d05:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	fc                   	cld    
  800d0b:	f3 ab                	rep stos %eax,%es:(%edi)
  800d0d:	eb 06                	jmp    800d15 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	fc                   	cld    
  800d13:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d15:	89 f8                	mov    %edi,%eax
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2a:	39 c6                	cmp    %eax,%esi
  800d2c:	73 32                	jae    800d60 <memmove+0x44>
  800d2e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d31:	39 c2                	cmp    %eax,%edx
  800d33:	76 2b                	jbe    800d60 <memmove+0x44>
		s += n;
		d += n;
  800d35:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d38:	89 fe                	mov    %edi,%esi
  800d3a:	09 ce                	or     %ecx,%esi
  800d3c:	09 d6                	or     %edx,%esi
  800d3e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d44:	75 0e                	jne    800d54 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d46:	83 ef 04             	sub    $0x4,%edi
  800d49:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d4c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d4f:	fd                   	std    
  800d50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d52:	eb 09                	jmp    800d5d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d54:	83 ef 01             	sub    $0x1,%edi
  800d57:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d5a:	fd                   	std    
  800d5b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d5d:	fc                   	cld    
  800d5e:	eb 1a                	jmp    800d7a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d60:	89 c2                	mov    %eax,%edx
  800d62:	09 ca                	or     %ecx,%edx
  800d64:	09 f2                	or     %esi,%edx
  800d66:	f6 c2 03             	test   $0x3,%dl
  800d69:	75 0a                	jne    800d75 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d6b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d6e:	89 c7                	mov    %eax,%edi
  800d70:	fc                   	cld    
  800d71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d73:	eb 05                	jmp    800d7a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d75:	89 c7                	mov    %eax,%edi
  800d77:	fc                   	cld    
  800d78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d84:	ff 75 10             	pushl  0x10(%ebp)
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 8a ff ff ff       	call   800d1c <memmove>
}
  800d92:	c9                   	leave  
  800d93:	c3                   	ret    

00800d94 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	89 c6                	mov    %eax,%esi
  800da1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800da4:	39 f0                	cmp    %esi,%eax
  800da6:	74 1c                	je     800dc4 <memcmp+0x30>
		if (*s1 != *s2)
  800da8:	0f b6 08             	movzbl (%eax),%ecx
  800dab:	0f b6 1a             	movzbl (%edx),%ebx
  800dae:	38 d9                	cmp    %bl,%cl
  800db0:	75 08                	jne    800dba <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800db2:	83 c0 01             	add    $0x1,%eax
  800db5:	83 c2 01             	add    $0x1,%edx
  800db8:	eb ea                	jmp    800da4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dba:	0f b6 c1             	movzbl %cl,%eax
  800dbd:	0f b6 db             	movzbl %bl,%ebx
  800dc0:	29 d8                	sub    %ebx,%eax
  800dc2:	eb 05                	jmp    800dc9 <memcmp+0x35>
	}

	return 0;
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dd6:	89 c2                	mov    %eax,%edx
  800dd8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ddb:	39 d0                	cmp    %edx,%eax
  800ddd:	73 09                	jae    800de8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ddf:	38 08                	cmp    %cl,(%eax)
  800de1:	74 05                	je     800de8 <memfind+0x1b>
	for (; s < ends; s++)
  800de3:	83 c0 01             	add    $0x1,%eax
  800de6:	eb f3                	jmp    800ddb <memfind+0xe>
			break;
	return (void *) s;
}
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df6:	eb 03                	jmp    800dfb <strtol+0x11>
		s++;
  800df8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800dfb:	0f b6 01             	movzbl (%ecx),%eax
  800dfe:	3c 20                	cmp    $0x20,%al
  800e00:	74 f6                	je     800df8 <strtol+0xe>
  800e02:	3c 09                	cmp    $0x9,%al
  800e04:	74 f2                	je     800df8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e06:	3c 2b                	cmp    $0x2b,%al
  800e08:	74 2a                	je     800e34 <strtol+0x4a>
	int neg = 0;
  800e0a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e0f:	3c 2d                	cmp    $0x2d,%al
  800e11:	74 2b                	je     800e3e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e13:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e19:	75 0f                	jne    800e2a <strtol+0x40>
  800e1b:	80 39 30             	cmpb   $0x30,(%ecx)
  800e1e:	74 28                	je     800e48 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e20:	85 db                	test   %ebx,%ebx
  800e22:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e27:	0f 44 d8             	cmove  %eax,%ebx
  800e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e32:	eb 50                	jmp    800e84 <strtol+0x9a>
		s++;
  800e34:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e37:	bf 00 00 00 00       	mov    $0x0,%edi
  800e3c:	eb d5                	jmp    800e13 <strtol+0x29>
		s++, neg = 1;
  800e3e:	83 c1 01             	add    $0x1,%ecx
  800e41:	bf 01 00 00 00       	mov    $0x1,%edi
  800e46:	eb cb                	jmp    800e13 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e48:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e4c:	74 0e                	je     800e5c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e4e:	85 db                	test   %ebx,%ebx
  800e50:	75 d8                	jne    800e2a <strtol+0x40>
		s++, base = 8;
  800e52:	83 c1 01             	add    $0x1,%ecx
  800e55:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e5a:	eb ce                	jmp    800e2a <strtol+0x40>
		s += 2, base = 16;
  800e5c:	83 c1 02             	add    $0x2,%ecx
  800e5f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e64:	eb c4                	jmp    800e2a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e66:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e69:	89 f3                	mov    %esi,%ebx
  800e6b:	80 fb 19             	cmp    $0x19,%bl
  800e6e:	77 29                	ja     800e99 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e70:	0f be d2             	movsbl %dl,%edx
  800e73:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e76:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e79:	7d 30                	jge    800eab <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e7b:	83 c1 01             	add    $0x1,%ecx
  800e7e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e82:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e84:	0f b6 11             	movzbl (%ecx),%edx
  800e87:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e8a:	89 f3                	mov    %esi,%ebx
  800e8c:	80 fb 09             	cmp    $0x9,%bl
  800e8f:	77 d5                	ja     800e66 <strtol+0x7c>
			dig = *s - '0';
  800e91:	0f be d2             	movsbl %dl,%edx
  800e94:	83 ea 30             	sub    $0x30,%edx
  800e97:	eb dd                	jmp    800e76 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e99:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e9c:	89 f3                	mov    %esi,%ebx
  800e9e:	80 fb 19             	cmp    $0x19,%bl
  800ea1:	77 08                	ja     800eab <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ea3:	0f be d2             	movsbl %dl,%edx
  800ea6:	83 ea 37             	sub    $0x37,%edx
  800ea9:	eb cb                	jmp    800e76 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eaf:	74 05                	je     800eb6 <strtol+0xcc>
		*endptr = (char *) s;
  800eb1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eb4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800eb6:	89 c2                	mov    %eax,%edx
  800eb8:	f7 da                	neg    %edx
  800eba:	85 ff                	test   %edi,%edi
  800ebc:	0f 45 c2             	cmovne %edx,%eax
}
  800ebf:	5b                   	pop    %ebx
  800ec0:	5e                   	pop    %esi
  800ec1:	5f                   	pop    %edi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	57                   	push   %edi
  800ec8:	56                   	push   %esi
  800ec9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed5:	89 c3                	mov    %eax,%ebx
  800ed7:	89 c7                	mov    %eax,%edi
  800ed9:	89 c6                	mov    %eax,%esi
  800edb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800edd:	5b                   	pop    %ebx
  800ede:	5e                   	pop    %esi
  800edf:	5f                   	pop    %edi
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    

00800ee2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee8:	ba 00 00 00 00       	mov    $0x0,%edx
  800eed:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef2:	89 d1                	mov    %edx,%ecx
  800ef4:	89 d3                	mov    %edx,%ebx
  800ef6:	89 d7                	mov    %edx,%edi
  800ef8:	89 d6                	mov    %edx,%esi
  800efa:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    

00800f01 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
  800f07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	b8 03 00 00 00       	mov    $0x3,%eax
  800f17:	89 cb                	mov    %ecx,%ebx
  800f19:	89 cf                	mov    %ecx,%edi
  800f1b:	89 ce                	mov    %ecx,%esi
  800f1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	7f 08                	jg     800f2b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	83 ec 0c             	sub    $0xc,%esp
  800f2e:	50                   	push   %eax
  800f2f:	6a 03                	push   $0x3
  800f31:	68 f0 25 80 00       	push   $0x8025f0
  800f36:	6a 33                	push   $0x33
  800f38:	68 0d 26 80 00       	push   $0x80260d
  800f3d:	e8 73 f3 ff ff       	call   8002b5 <_panic>

00800f42 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	57                   	push   %edi
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f48:	ba 00 00 00 00       	mov    $0x0,%edx
  800f4d:	b8 02 00 00 00       	mov    $0x2,%eax
  800f52:	89 d1                	mov    %edx,%ecx
  800f54:	89 d3                	mov    %edx,%ebx
  800f56:	89 d7                	mov    %edx,%edi
  800f58:	89 d6                	mov    %edx,%esi
  800f5a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <sys_yield>:

void
sys_yield(void)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	57                   	push   %edi
  800f65:	56                   	push   %esi
  800f66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f67:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f71:	89 d1                	mov    %edx,%ecx
  800f73:	89 d3                	mov    %edx,%ebx
  800f75:	89 d7                	mov    %edx,%edi
  800f77:	89 d6                	mov    %edx,%esi
  800f79:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	57                   	push   %edi
  800f84:	56                   	push   %esi
  800f85:	53                   	push   %ebx
  800f86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f89:	be 00 00 00 00       	mov    $0x0,%esi
  800f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f94:	b8 04 00 00 00       	mov    $0x4,%eax
  800f99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9c:	89 f7                	mov    %esi,%edi
  800f9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	7f 08                	jg     800fac <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fac:	83 ec 0c             	sub    $0xc,%esp
  800faf:	50                   	push   %eax
  800fb0:	6a 04                	push   $0x4
  800fb2:	68 f0 25 80 00       	push   $0x8025f0
  800fb7:	6a 33                	push   $0x33
  800fb9:	68 0d 26 80 00       	push   $0x80260d
  800fbe:	e8 f2 f2 ff ff       	call   8002b5 <_panic>

00800fc3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd2:	b8 05 00 00 00       	mov    $0x5,%eax
  800fd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fda:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fdd:	8b 75 18             	mov    0x18(%ebp),%esi
  800fe0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	7f 08                	jg     800fee <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe9:	5b                   	pop    %ebx
  800fea:	5e                   	pop    %esi
  800feb:	5f                   	pop    %edi
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fee:	83 ec 0c             	sub    $0xc,%esp
  800ff1:	50                   	push   %eax
  800ff2:	6a 05                	push   $0x5
  800ff4:	68 f0 25 80 00       	push   $0x8025f0
  800ff9:	6a 33                	push   $0x33
  800ffb:	68 0d 26 80 00       	push   $0x80260d
  801000:	e8 b0 f2 ff ff       	call   8002b5 <_panic>

00801005 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	57                   	push   %edi
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
  80100b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801013:	8b 55 08             	mov    0x8(%ebp),%edx
  801016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801019:	b8 06 00 00 00       	mov    $0x6,%eax
  80101e:	89 df                	mov    %ebx,%edi
  801020:	89 de                	mov    %ebx,%esi
  801022:	cd 30                	int    $0x30
	if(check && ret > 0)
  801024:	85 c0                	test   %eax,%eax
  801026:	7f 08                	jg     801030 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801030:	83 ec 0c             	sub    $0xc,%esp
  801033:	50                   	push   %eax
  801034:	6a 06                	push   $0x6
  801036:	68 f0 25 80 00       	push   $0x8025f0
  80103b:	6a 33                	push   $0x33
  80103d:	68 0d 26 80 00       	push   $0x80260d
  801042:	e8 6e f2 ff ff       	call   8002b5 <_panic>

00801047 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	57                   	push   %edi
  80104b:	56                   	push   %esi
  80104c:	53                   	push   %ebx
  80104d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801050:	b9 00 00 00 00       	mov    $0x0,%ecx
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	b8 0b 00 00 00       	mov    $0xb,%eax
  80105d:	89 cb                	mov    %ecx,%ebx
  80105f:	89 cf                	mov    %ecx,%edi
  801061:	89 ce                	mov    %ecx,%esi
  801063:	cd 30                	int    $0x30
	if(check && ret > 0)
  801065:	85 c0                	test   %eax,%eax
  801067:	7f 08                	jg     801071 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  801069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	50                   	push   %eax
  801075:	6a 0b                	push   $0xb
  801077:	68 f0 25 80 00       	push   $0x8025f0
  80107c:	6a 33                	push   $0x33
  80107e:	68 0d 26 80 00       	push   $0x80260d
  801083:	e8 2d f2 ff ff       	call   8002b5 <_panic>

00801088 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	57                   	push   %edi
  80108c:	56                   	push   %esi
  80108d:	53                   	push   %ebx
  80108e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801091:	bb 00 00 00 00       	mov    $0x0,%ebx
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109c:	b8 08 00 00 00       	mov    $0x8,%eax
  8010a1:	89 df                	mov    %ebx,%edi
  8010a3:	89 de                	mov    %ebx,%esi
  8010a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	7f 08                	jg     8010b3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	50                   	push   %eax
  8010b7:	6a 08                	push   $0x8
  8010b9:	68 f0 25 80 00       	push   $0x8025f0
  8010be:	6a 33                	push   $0x33
  8010c0:	68 0d 26 80 00       	push   $0x80260d
  8010c5:	e8 eb f1 ff ff       	call   8002b5 <_panic>

008010ca <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
  8010d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010de:	b8 09 00 00 00       	mov    $0x9,%eax
  8010e3:	89 df                	mov    %ebx,%edi
  8010e5:	89 de                	mov    %ebx,%esi
  8010e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	7f 08                	jg     8010f5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f5:	83 ec 0c             	sub    $0xc,%esp
  8010f8:	50                   	push   %eax
  8010f9:	6a 09                	push   $0x9
  8010fb:	68 f0 25 80 00       	push   $0x8025f0
  801100:	6a 33                	push   $0x33
  801102:	68 0d 26 80 00       	push   $0x80260d
  801107:	e8 a9 f1 ff ff       	call   8002b5 <_panic>

0080110c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	57                   	push   %edi
  801110:	56                   	push   %esi
  801111:	53                   	push   %ebx
  801112:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801115:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111a:	8b 55 08             	mov    0x8(%ebp),%edx
  80111d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801120:	b8 0a 00 00 00       	mov    $0xa,%eax
  801125:	89 df                	mov    %ebx,%edi
  801127:	89 de                	mov    %ebx,%esi
  801129:	cd 30                	int    $0x30
	if(check && ret > 0)
  80112b:	85 c0                	test   %eax,%eax
  80112d:	7f 08                	jg     801137 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80112f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	50                   	push   %eax
  80113b:	6a 0a                	push   $0xa
  80113d:	68 f0 25 80 00       	push   $0x8025f0
  801142:	6a 33                	push   $0x33
  801144:	68 0d 26 80 00       	push   $0x80260d
  801149:	e8 67 f1 ff ff       	call   8002b5 <_panic>

0080114e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	57                   	push   %edi
  801152:	56                   	push   %esi
  801153:	53                   	push   %ebx
	asm volatile("int %1\n"
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80115f:	be 00 00 00 00       	mov    $0x0,%esi
  801164:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801167:	8b 7d 14             	mov    0x14(%ebp),%edi
  80116a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80116c:	5b                   	pop    %ebx
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    

00801171 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	57                   	push   %edi
  801175:	56                   	push   %esi
  801176:	53                   	push   %ebx
  801177:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80117a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80117f:	8b 55 08             	mov    0x8(%ebp),%edx
  801182:	b8 0e 00 00 00       	mov    $0xe,%eax
  801187:	89 cb                	mov    %ecx,%ebx
  801189:	89 cf                	mov    %ecx,%edi
  80118b:	89 ce                	mov    %ecx,%esi
  80118d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80118f:	85 c0                	test   %eax,%eax
  801191:	7f 08                	jg     80119b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801193:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801196:	5b                   	pop    %ebx
  801197:	5e                   	pop    %esi
  801198:	5f                   	pop    %edi
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	50                   	push   %eax
  80119f:	6a 0e                	push   $0xe
  8011a1:	68 f0 25 80 00       	push   $0x8025f0
  8011a6:	6a 33                	push   $0x33
  8011a8:	68 0d 26 80 00       	push   $0x80260d
  8011ad:	e8 03 f1 ff ff       	call   8002b5 <_panic>

008011b2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	57                   	push   %edi
  8011b6:	56                   	push   %esi
  8011b7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c3:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011c8:	89 df                	mov    %ebx,%edi
  8011ca:	89 de                	mov    %ebx,%esi
  8011cc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011ce:	5b                   	pop    %ebx
  8011cf:	5e                   	pop    %esi
  8011d0:	5f                   	pop    %edi
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	57                   	push   %edi
  8011d7:	56                   	push   %esi
  8011d8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011de:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e1:	b8 10 00 00 00       	mov    $0x10,%eax
  8011e6:	89 cb                	mov    %ecx,%ebx
  8011e8:	89 cf                	mov    %ecx,%edi
  8011ea:	89 ce                	mov    %ecx,%esi
  8011ec:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5f                   	pop    %edi
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	05 00 00 00 30       	add    $0x30000000,%eax
  8011fe:	c1 e8 0c             	shr    $0xc,%eax
}
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    

00801203 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80120e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801213:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801218:	5d                   	pop    %ebp
  801219:	c3                   	ret    

0080121a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801222:	89 c2                	mov    %eax,%edx
  801224:	c1 ea 16             	shr    $0x16,%edx
  801227:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80122e:	f6 c2 01             	test   $0x1,%dl
  801231:	74 2d                	je     801260 <fd_alloc+0x46>
  801233:	89 c2                	mov    %eax,%edx
  801235:	c1 ea 0c             	shr    $0xc,%edx
  801238:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80123f:	f6 c2 01             	test   $0x1,%dl
  801242:	74 1c                	je     801260 <fd_alloc+0x46>
  801244:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801249:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80124e:	75 d2                	jne    801222 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801259:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80125e:	eb 0a                	jmp    80126a <fd_alloc+0x50>
			*fd_store = fd;
  801260:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801263:	89 01                	mov    %eax,(%ecx)
			return 0;
  801265:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801272:	83 f8 1f             	cmp    $0x1f,%eax
  801275:	77 30                	ja     8012a7 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801277:	c1 e0 0c             	shl    $0xc,%eax
  80127a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80127f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801285:	f6 c2 01             	test   $0x1,%dl
  801288:	74 24                	je     8012ae <fd_lookup+0x42>
  80128a:	89 c2                	mov    %eax,%edx
  80128c:	c1 ea 0c             	shr    $0xc,%edx
  80128f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801296:	f6 c2 01             	test   $0x1,%dl
  801299:	74 1a                	je     8012b5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80129b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129e:	89 02                	mov    %eax,(%edx)
	return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a5:	5d                   	pop    %ebp
  8012a6:	c3                   	ret    
		return -E_INVAL;
  8012a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ac:	eb f7                	jmp    8012a5 <fd_lookup+0x39>
		return -E_INVAL;
  8012ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b3:	eb f0                	jmp    8012a5 <fd_lookup+0x39>
  8012b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ba:	eb e9                	jmp    8012a5 <fd_lookup+0x39>

008012bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c5:	ba 9c 26 80 00       	mov    $0x80269c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012ca:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012cf:	39 08                	cmp    %ecx,(%eax)
  8012d1:	74 33                	je     801306 <dev_lookup+0x4a>
  8012d3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012d6:	8b 02                	mov    (%edx),%eax
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	75 f3                	jne    8012cf <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012dc:	a1 04 44 80 00       	mov    0x804404,%eax
  8012e1:	8b 40 48             	mov    0x48(%eax),%eax
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	51                   	push   %ecx
  8012e8:	50                   	push   %eax
  8012e9:	68 1c 26 80 00       	push   $0x80261c
  8012ee:	e8 9d f0 ff ff       	call   800390 <cprintf>
	*dev = 0;
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    
			*dev = devtab[i];
  801306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801309:	89 01                	mov    %eax,(%ecx)
			return 0;
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
  801310:	eb f2                	jmp    801304 <dev_lookup+0x48>

00801312 <fd_close>:
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
  801318:	83 ec 24             	sub    $0x24,%esp
  80131b:	8b 75 08             	mov    0x8(%ebp),%esi
  80131e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801321:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801324:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801325:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80132b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80132e:	50                   	push   %eax
  80132f:	e8 38 ff ff ff       	call   80126c <fd_lookup>
  801334:	89 c3                	mov    %eax,%ebx
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 05                	js     801342 <fd_close+0x30>
	    || fd != fd2)
  80133d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801340:	74 16                	je     801358 <fd_close+0x46>
		return (must_exist ? r : 0);
  801342:	89 f8                	mov    %edi,%eax
  801344:	84 c0                	test   %al,%al
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
  80134b:	0f 44 d8             	cmove  %eax,%ebx
}
  80134e:	89 d8                	mov    %ebx,%eax
  801350:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801353:	5b                   	pop    %ebx
  801354:	5e                   	pop    %esi
  801355:	5f                   	pop    %edi
  801356:	5d                   	pop    %ebp
  801357:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80135e:	50                   	push   %eax
  80135f:	ff 36                	pushl  (%esi)
  801361:	e8 56 ff ff ff       	call   8012bc <dev_lookup>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 1a                	js     801389 <fd_close+0x77>
		if (dev->dev_close)
  80136f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801372:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801375:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80137a:	85 c0                	test   %eax,%eax
  80137c:	74 0b                	je     801389 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	56                   	push   %esi
  801382:	ff d0                	call   *%eax
  801384:	89 c3                	mov    %eax,%ebx
  801386:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	56                   	push   %esi
  80138d:	6a 00                	push   $0x0
  80138f:	e8 71 fc ff ff       	call   801005 <sys_page_unmap>
	return r;
  801394:	83 c4 10             	add    $0x10,%esp
  801397:	eb b5                	jmp    80134e <fd_close+0x3c>

00801399 <close>:

int
close(int fdnum)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80139f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a2:	50                   	push   %eax
  8013a3:	ff 75 08             	pushl  0x8(%ebp)
  8013a6:	e8 c1 fe ff ff       	call   80126c <fd_lookup>
  8013ab:	83 c4 10             	add    $0x10,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	79 02                	jns    8013b4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    
		return fd_close(fd, 1);
  8013b4:	83 ec 08             	sub    $0x8,%esp
  8013b7:	6a 01                	push   $0x1
  8013b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8013bc:	e8 51 ff ff ff       	call   801312 <fd_close>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	eb ec                	jmp    8013b2 <close+0x19>

008013c6 <close_all>:

void
close_all(void)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	53                   	push   %ebx
  8013ca:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013d2:	83 ec 0c             	sub    $0xc,%esp
  8013d5:	53                   	push   %ebx
  8013d6:	e8 be ff ff ff       	call   801399 <close>
	for (i = 0; i < MAXFD; i++)
  8013db:	83 c3 01             	add    $0x1,%ebx
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	83 fb 20             	cmp    $0x20,%ebx
  8013e4:	75 ec                	jne    8013d2 <close_all+0xc>
}
  8013e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	57                   	push   %edi
  8013ef:	56                   	push   %esi
  8013f0:	53                   	push   %ebx
  8013f1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	ff 75 08             	pushl  0x8(%ebp)
  8013fb:	e8 6c fe ff ff       	call   80126c <fd_lookup>
  801400:	89 c3                	mov    %eax,%ebx
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 c0                	test   %eax,%eax
  801407:	0f 88 81 00 00 00    	js     80148e <dup+0xa3>
		return r;
	close(newfdnum);
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	ff 75 0c             	pushl  0xc(%ebp)
  801413:	e8 81 ff ff ff       	call   801399 <close>

	newfd = INDEX2FD(newfdnum);
  801418:	8b 75 0c             	mov    0xc(%ebp),%esi
  80141b:	c1 e6 0c             	shl    $0xc,%esi
  80141e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801424:	83 c4 04             	add    $0x4,%esp
  801427:	ff 75 e4             	pushl  -0x1c(%ebp)
  80142a:	e8 d4 fd ff ff       	call   801203 <fd2data>
  80142f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801431:	89 34 24             	mov    %esi,(%esp)
  801434:	e8 ca fd ff ff       	call   801203 <fd2data>
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80143e:	89 d8                	mov    %ebx,%eax
  801440:	c1 e8 16             	shr    $0x16,%eax
  801443:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80144a:	a8 01                	test   $0x1,%al
  80144c:	74 11                	je     80145f <dup+0x74>
  80144e:	89 d8                	mov    %ebx,%eax
  801450:	c1 e8 0c             	shr    $0xc,%eax
  801453:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80145a:	f6 c2 01             	test   $0x1,%dl
  80145d:	75 39                	jne    801498 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80145f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801462:	89 d0                	mov    %edx,%eax
  801464:	c1 e8 0c             	shr    $0xc,%eax
  801467:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80146e:	83 ec 0c             	sub    $0xc,%esp
  801471:	25 07 0e 00 00       	and    $0xe07,%eax
  801476:	50                   	push   %eax
  801477:	56                   	push   %esi
  801478:	6a 00                	push   $0x0
  80147a:	52                   	push   %edx
  80147b:	6a 00                	push   $0x0
  80147d:	e8 41 fb ff ff       	call   800fc3 <sys_page_map>
  801482:	89 c3                	mov    %eax,%ebx
  801484:	83 c4 20             	add    $0x20,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 31                	js     8014bc <dup+0xd1>
		goto err;

	return newfdnum;
  80148b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80148e:	89 d8                	mov    %ebx,%eax
  801490:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801493:	5b                   	pop    %ebx
  801494:	5e                   	pop    %esi
  801495:	5f                   	pop    %edi
  801496:	5d                   	pop    %ebp
  801497:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801498:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80149f:	83 ec 0c             	sub    $0xc,%esp
  8014a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a7:	50                   	push   %eax
  8014a8:	57                   	push   %edi
  8014a9:	6a 00                	push   $0x0
  8014ab:	53                   	push   %ebx
  8014ac:	6a 00                	push   $0x0
  8014ae:	e8 10 fb ff ff       	call   800fc3 <sys_page_map>
  8014b3:	89 c3                	mov    %eax,%ebx
  8014b5:	83 c4 20             	add    $0x20,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	79 a3                	jns    80145f <dup+0x74>
	sys_page_unmap(0, newfd);
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	56                   	push   %esi
  8014c0:	6a 00                	push   $0x0
  8014c2:	e8 3e fb ff ff       	call   801005 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014c7:	83 c4 08             	add    $0x8,%esp
  8014ca:	57                   	push   %edi
  8014cb:	6a 00                	push   $0x0
  8014cd:	e8 33 fb ff ff       	call   801005 <sys_page_unmap>
	return r;
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	eb b7                	jmp    80148e <dup+0xa3>

008014d7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	53                   	push   %ebx
  8014db:	83 ec 1c             	sub    $0x1c,%esp
  8014de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e4:	50                   	push   %eax
  8014e5:	53                   	push   %ebx
  8014e6:	e8 81 fd ff ff       	call   80126c <fd_lookup>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 3f                	js     801531 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f8:	50                   	push   %eax
  8014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fc:	ff 30                	pushl  (%eax)
  8014fe:	e8 b9 fd ff ff       	call   8012bc <dev_lookup>
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	78 27                	js     801531 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80150a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150d:	8b 42 08             	mov    0x8(%edx),%eax
  801510:	83 e0 03             	and    $0x3,%eax
  801513:	83 f8 01             	cmp    $0x1,%eax
  801516:	74 1e                	je     801536 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151b:	8b 40 08             	mov    0x8(%eax),%eax
  80151e:	85 c0                	test   %eax,%eax
  801520:	74 35                	je     801557 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	ff 75 10             	pushl  0x10(%ebp)
  801528:	ff 75 0c             	pushl  0xc(%ebp)
  80152b:	52                   	push   %edx
  80152c:	ff d0                	call   *%eax
  80152e:	83 c4 10             	add    $0x10,%esp
}
  801531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801534:	c9                   	leave  
  801535:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801536:	a1 04 44 80 00       	mov    0x804404,%eax
  80153b:	8b 40 48             	mov    0x48(%eax),%eax
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	53                   	push   %ebx
  801542:	50                   	push   %eax
  801543:	68 60 26 80 00       	push   $0x802660
  801548:	e8 43 ee ff ff       	call   800390 <cprintf>
		return -E_INVAL;
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801555:	eb da                	jmp    801531 <read+0x5a>
		return -E_NOT_SUPP;
  801557:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155c:	eb d3                	jmp    801531 <read+0x5a>

0080155e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	57                   	push   %edi
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	83 ec 0c             	sub    $0xc,%esp
  801567:	8b 7d 08             	mov    0x8(%ebp),%edi
  80156a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80156d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801572:	39 f3                	cmp    %esi,%ebx
  801574:	73 23                	jae    801599 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	89 f0                	mov    %esi,%eax
  80157b:	29 d8                	sub    %ebx,%eax
  80157d:	50                   	push   %eax
  80157e:	89 d8                	mov    %ebx,%eax
  801580:	03 45 0c             	add    0xc(%ebp),%eax
  801583:	50                   	push   %eax
  801584:	57                   	push   %edi
  801585:	e8 4d ff ff ff       	call   8014d7 <read>
		if (m < 0)
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 06                	js     801597 <readn+0x39>
			return m;
		if (m == 0)
  801591:	74 06                	je     801599 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801593:	01 c3                	add    %eax,%ebx
  801595:	eb db                	jmp    801572 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801597:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801599:	89 d8                	mov    %ebx,%eax
  80159b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159e:	5b                   	pop    %ebx
  80159f:	5e                   	pop    %esi
  8015a0:	5f                   	pop    %edi
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    

008015a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	53                   	push   %ebx
  8015a7:	83 ec 1c             	sub    $0x1c,%esp
  8015aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	53                   	push   %ebx
  8015b2:	e8 b5 fc ff ff       	call   80126c <fd_lookup>
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 3a                	js     8015f8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c4:	50                   	push   %eax
  8015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c8:	ff 30                	pushl  (%eax)
  8015ca:	e8 ed fc ff ff       	call   8012bc <dev_lookup>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	78 22                	js     8015f8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015dd:	74 1e                	je     8015fd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8015e5:	85 d2                	test   %edx,%edx
  8015e7:	74 35                	je     80161e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	ff 75 10             	pushl  0x10(%ebp)
  8015ef:	ff 75 0c             	pushl  0xc(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff d2                	call   *%edx
  8015f5:	83 c4 10             	add    $0x10,%esp
}
  8015f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015fd:	a1 04 44 80 00       	mov    0x804404,%eax
  801602:	8b 40 48             	mov    0x48(%eax),%eax
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	53                   	push   %ebx
  801609:	50                   	push   %eax
  80160a:	68 7c 26 80 00       	push   $0x80267c
  80160f:	e8 7c ed ff ff       	call   800390 <cprintf>
		return -E_INVAL;
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161c:	eb da                	jmp    8015f8 <write+0x55>
		return -E_NOT_SUPP;
  80161e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801623:	eb d3                	jmp    8015f8 <write+0x55>

00801625 <seek>:

int
seek(int fdnum, off_t offset)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80162b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162e:	50                   	push   %eax
  80162f:	ff 75 08             	pushl  0x8(%ebp)
  801632:	e8 35 fc ff ff       	call   80126c <fd_lookup>
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 0e                	js     80164c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801644:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	53                   	push   %ebx
  801652:	83 ec 1c             	sub    $0x1c,%esp
  801655:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801658:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80165b:	50                   	push   %eax
  80165c:	53                   	push   %ebx
  80165d:	e8 0a fc ff ff       	call   80126c <fd_lookup>
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	85 c0                	test   %eax,%eax
  801667:	78 37                	js     8016a0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801669:	83 ec 08             	sub    $0x8,%esp
  80166c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166f:	50                   	push   %eax
  801670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801673:	ff 30                	pushl  (%eax)
  801675:	e8 42 fc ff ff       	call   8012bc <dev_lookup>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 1f                	js     8016a0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801684:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801688:	74 1b                	je     8016a5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80168a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168d:	8b 52 18             	mov    0x18(%edx),%edx
  801690:	85 d2                	test   %edx,%edx
  801692:	74 32                	je     8016c6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	50                   	push   %eax
  80169b:	ff d2                	call   *%edx
  80169d:	83 c4 10             	add    $0x10,%esp
}
  8016a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016a5:	a1 04 44 80 00       	mov    0x804404,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016aa:	8b 40 48             	mov    0x48(%eax),%eax
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	53                   	push   %ebx
  8016b1:	50                   	push   %eax
  8016b2:	68 3c 26 80 00       	push   $0x80263c
  8016b7:	e8 d4 ec ff ff       	call   800390 <cprintf>
		return -E_INVAL;
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c4:	eb da                	jmp    8016a0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016cb:	eb d3                	jmp    8016a0 <ftruncate+0x52>

008016cd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 1c             	sub    $0x1c,%esp
  8016d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016da:	50                   	push   %eax
  8016db:	ff 75 08             	pushl  0x8(%ebp)
  8016de:	e8 89 fb ff ff       	call   80126c <fd_lookup>
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 4b                	js     801735 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f0:	50                   	push   %eax
  8016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f4:	ff 30                	pushl  (%eax)
  8016f6:	e8 c1 fb ff ff       	call   8012bc <dev_lookup>
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 33                	js     801735 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801709:	74 2f                	je     80173a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80170b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80170e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801715:	00 00 00 
	stat->st_isdir = 0;
  801718:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80171f:	00 00 00 
	stat->st_dev = dev;
  801722:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	53                   	push   %ebx
  80172c:	ff 75 f0             	pushl  -0x10(%ebp)
  80172f:	ff 50 14             	call   *0x14(%eax)
  801732:	83 c4 10             	add    $0x10,%esp
}
  801735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801738:	c9                   	leave  
  801739:	c3                   	ret    
		return -E_NOT_SUPP;
  80173a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80173f:	eb f4                	jmp    801735 <fstat+0x68>

00801741 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	56                   	push   %esi
  801745:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801746:	83 ec 08             	sub    $0x8,%esp
  801749:	6a 00                	push   $0x0
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	e8 e7 01 00 00       	call   80193a <open>
  801753:	89 c3                	mov    %eax,%ebx
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 1b                	js     801777 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80175c:	83 ec 08             	sub    $0x8,%esp
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	50                   	push   %eax
  801763:	e8 65 ff ff ff       	call   8016cd <fstat>
  801768:	89 c6                	mov    %eax,%esi
	close(fd);
  80176a:	89 1c 24             	mov    %ebx,(%esp)
  80176d:	e8 27 fc ff ff       	call   801399 <close>
	return r;
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	89 f3                	mov    %esi,%ebx
}
  801777:	89 d8                	mov    %ebx,%eax
  801779:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    

00801780 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
  801785:	89 c6                	mov    %eax,%esi
  801787:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801789:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801790:	74 27                	je     8017b9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801792:	6a 07                	push   $0x7
  801794:	68 00 50 80 00       	push   $0x805000
  801799:	56                   	push   %esi
  80179a:	ff 35 00 44 80 00    	pushl  0x804400
  8017a0:	e8 03 07 00 00       	call   801ea8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017a5:	83 c4 0c             	add    $0xc,%esp
  8017a8:	6a 00                	push   $0x0
  8017aa:	53                   	push   %ebx
  8017ab:	6a 00                	push   $0x0
  8017ad:	e8 8f 06 00 00       	call   801e41 <ipc_recv>
}
  8017b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b5:	5b                   	pop    %ebx
  8017b6:	5e                   	pop    %esi
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017b9:	83 ec 0c             	sub    $0xc,%esp
  8017bc:	6a 01                	push   $0x1
  8017be:	e8 2e 07 00 00       	call   801ef1 <ipc_find_env>
  8017c3:	a3 00 44 80 00       	mov    %eax,0x804400
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	eb c5                	jmp    801792 <fsipc+0x12>

008017cd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017eb:	b8 02 00 00 00       	mov    $0x2,%eax
  8017f0:	e8 8b ff ff ff       	call   801780 <fsipc>
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <devfile_flush>:
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 40 0c             	mov    0xc(%eax),%eax
  801803:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801808:	ba 00 00 00 00       	mov    $0x0,%edx
  80180d:	b8 06 00 00 00       	mov    $0x6,%eax
  801812:	e8 69 ff ff ff       	call   801780 <fsipc>
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <devfile_stat>:
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	53                   	push   %ebx
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8b 40 0c             	mov    0xc(%eax),%eax
  801829:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80182e:	ba 00 00 00 00       	mov    $0x0,%edx
  801833:	b8 05 00 00 00       	mov    $0x5,%eax
  801838:	e8 43 ff ff ff       	call   801780 <fsipc>
  80183d:	85 c0                	test   %eax,%eax
  80183f:	78 2c                	js     80186d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801841:	83 ec 08             	sub    $0x8,%esp
  801844:	68 00 50 80 00       	push   $0x805000
  801849:	53                   	push   %ebx
  80184a:	e8 3f f3 ff ff       	call   800b8e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80184f:	a1 80 50 80 00       	mov    0x805080,%eax
  801854:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80185a:	a1 84 50 80 00       	mov    0x805084,%eax
  80185f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <devfile_write>:
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80187b:	8b 55 08             	mov    0x8(%ebp),%edx
  80187e:	8b 52 0c             	mov    0xc(%edx),%edx
  801881:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801887:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80188c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801891:	0f 47 c2             	cmova  %edx,%eax
  801894:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801899:	50                   	push   %eax
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	68 08 50 80 00       	push   $0x805008
  8018a2:	e8 75 f4 ff ff       	call   800d1c <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	b8 04 00 00 00       	mov    $0x4,%eax
  8018b1:	e8 ca fe ff ff       	call   801780 <fsipc>
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <devfile_read>:
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
  8018bd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018cb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d6:	b8 03 00 00 00       	mov    $0x3,%eax
  8018db:	e8 a0 fe ff ff       	call   801780 <fsipc>
  8018e0:	89 c3                	mov    %eax,%ebx
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 1f                	js     801905 <devfile_read+0x4d>
	assert(r <= n);
  8018e6:	39 f0                	cmp    %esi,%eax
  8018e8:	77 24                	ja     80190e <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018ea:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ef:	7f 33                	jg     801924 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	50                   	push   %eax
  8018f5:	68 00 50 80 00       	push   $0x805000
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	e8 1a f4 ff ff       	call   800d1c <memmove>
	return r;
  801902:	83 c4 10             	add    $0x10,%esp
}
  801905:	89 d8                	mov    %ebx,%eax
  801907:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190a:	5b                   	pop    %ebx
  80190b:	5e                   	pop    %esi
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    
	assert(r <= n);
  80190e:	68 ac 26 80 00       	push   $0x8026ac
  801913:	68 b3 26 80 00       	push   $0x8026b3
  801918:	6a 7c                	push   $0x7c
  80191a:	68 c8 26 80 00       	push   $0x8026c8
  80191f:	e8 91 e9 ff ff       	call   8002b5 <_panic>
	assert(r <= PGSIZE);
  801924:	68 d3 26 80 00       	push   $0x8026d3
  801929:	68 b3 26 80 00       	push   $0x8026b3
  80192e:	6a 7d                	push   $0x7d
  801930:	68 c8 26 80 00       	push   $0x8026c8
  801935:	e8 7b e9 ff ff       	call   8002b5 <_panic>

0080193a <open>:
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	56                   	push   %esi
  80193e:	53                   	push   %ebx
  80193f:	83 ec 1c             	sub    $0x1c,%esp
  801942:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801945:	56                   	push   %esi
  801946:	e8 0a f2 ff ff       	call   800b55 <strlen>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801953:	7f 6c                	jg     8019c1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801955:	83 ec 0c             	sub    $0xc,%esp
  801958:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195b:	50                   	push   %eax
  80195c:	e8 b9 f8 ff ff       	call   80121a <fd_alloc>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	78 3c                	js     8019a6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	56                   	push   %esi
  80196e:	68 00 50 80 00       	push   $0x805000
  801973:	e8 16 f2 ff ff       	call   800b8e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801983:	b8 01 00 00 00       	mov    $0x1,%eax
  801988:	e8 f3 fd ff ff       	call   801780 <fsipc>
  80198d:	89 c3                	mov    %eax,%ebx
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	78 19                	js     8019af <open+0x75>
	return fd2num(fd);
  801996:	83 ec 0c             	sub    $0xc,%esp
  801999:	ff 75 f4             	pushl  -0xc(%ebp)
  80199c:	e8 52 f8 ff ff       	call   8011f3 <fd2num>
  8019a1:	89 c3                	mov    %eax,%ebx
  8019a3:	83 c4 10             	add    $0x10,%esp
}
  8019a6:	89 d8                	mov    %ebx,%eax
  8019a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    
		fd_close(fd, 0);
  8019af:	83 ec 08             	sub    $0x8,%esp
  8019b2:	6a 00                	push   $0x0
  8019b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b7:	e8 56 f9 ff ff       	call   801312 <fd_close>
		return r;
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	eb e5                	jmp    8019a6 <open+0x6c>
		return -E_BAD_PATH;
  8019c1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019c6:	eb de                	jmp    8019a6 <open+0x6c>

008019c8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d8:	e8 a3 fd ff ff       	call   801780 <fsipc>
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8019df:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019e3:	7f 01                	jg     8019e6 <writebuf+0x7>
  8019e5:	c3                   	ret    
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	53                   	push   %ebx
  8019ea:	83 ec 08             	sub    $0x8,%esp
  8019ed:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019ef:	ff 70 04             	pushl  0x4(%eax)
  8019f2:	8d 40 10             	lea    0x10(%eax),%eax
  8019f5:	50                   	push   %eax
  8019f6:	ff 33                	pushl  (%ebx)
  8019f8:	e8 a6 fb ff ff       	call   8015a3 <write>
		if (result > 0)
  8019fd:	83 c4 10             	add    $0x10,%esp
  801a00:	85 c0                	test   %eax,%eax
  801a02:	7e 03                	jle    801a07 <writebuf+0x28>
			b->result += result;
  801a04:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a07:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a0a:	74 0d                	je     801a19 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a13:	0f 4f c2             	cmovg  %edx,%eax
  801a16:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <putch>:

static void
putch(int ch, void *thunk)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	53                   	push   %ebx
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a28:	8b 53 04             	mov    0x4(%ebx),%edx
  801a2b:	8d 42 01             	lea    0x1(%edx),%eax
  801a2e:	89 43 04             	mov    %eax,0x4(%ebx)
  801a31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a34:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a38:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a3d:	74 06                	je     801a45 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a3f:	83 c4 04             	add    $0x4,%esp
  801a42:	5b                   	pop    %ebx
  801a43:	5d                   	pop    %ebp
  801a44:	c3                   	ret    
		writebuf(b);
  801a45:	89 d8                	mov    %ebx,%eax
  801a47:	e8 93 ff ff ff       	call   8019df <writebuf>
		b->idx = 0;
  801a4c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a53:	eb ea                	jmp    801a3f <putch+0x21>

00801a55 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a67:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a6e:	00 00 00 
	b.result = 0;
  801a71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a78:	00 00 00 
	b.error = 1;
  801a7b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a82:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a85:	ff 75 10             	pushl  0x10(%ebp)
  801a88:	ff 75 0c             	pushl  0xc(%ebp)
  801a8b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a91:	50                   	push   %eax
  801a92:	68 1e 1a 80 00       	push   $0x801a1e
  801a97:	e8 21 ea ff ff       	call   8004bd <vprintfmt>
	if (b.idx > 0)
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801aa6:	7f 11                	jg     801ab9 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801aa8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    
		writebuf(&b);
  801ab9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801abf:	e8 1b ff ff ff       	call   8019df <writebuf>
  801ac4:	eb e2                	jmp    801aa8 <vfprintf+0x53>

00801ac6 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801acc:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801acf:	50                   	push   %eax
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	ff 75 08             	pushl  0x8(%ebp)
  801ad6:	e8 7a ff ff ff       	call   801a55 <vfprintf>
	va_end(ap);

	return cnt;
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <printf>:

int
printf(const char *fmt, ...)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ae3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801ae6:	50                   	push   %eax
  801ae7:	ff 75 08             	pushl  0x8(%ebp)
  801aea:	6a 01                	push   $0x1
  801aec:	e8 64 ff ff ff       	call   801a55 <vfprintf>
	va_end(ap);

	return cnt;
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801afb:	83 ec 0c             	sub    $0xc,%esp
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	e8 fd f6 ff ff       	call   801203 <fd2data>
  801b06:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b08:	83 c4 08             	add    $0x8,%esp
  801b0b:	68 df 26 80 00       	push   $0x8026df
  801b10:	53                   	push   %ebx
  801b11:	e8 78 f0 ff ff       	call   800b8e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b16:	8b 46 04             	mov    0x4(%esi),%eax
  801b19:	2b 06                	sub    (%esi),%eax
  801b1b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b21:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b28:	00 00 00 
	stat->st_dev = &devpipe;
  801b2b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b32:	30 80 00 
	return 0;
}
  801b35:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    

00801b41 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	53                   	push   %ebx
  801b45:	83 ec 0c             	sub    $0xc,%esp
  801b48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b4b:	53                   	push   %ebx
  801b4c:	6a 00                	push   $0x0
  801b4e:	e8 b2 f4 ff ff       	call   801005 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b53:	89 1c 24             	mov    %ebx,(%esp)
  801b56:	e8 a8 f6 ff ff       	call   801203 <fd2data>
  801b5b:	83 c4 08             	add    $0x8,%esp
  801b5e:	50                   	push   %eax
  801b5f:	6a 00                	push   $0x0
  801b61:	e8 9f f4 ff ff       	call   801005 <sys_page_unmap>
}
  801b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <_pipeisclosed>:
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	57                   	push   %edi
  801b6f:	56                   	push   %esi
  801b70:	53                   	push   %ebx
  801b71:	83 ec 1c             	sub    $0x1c,%esp
  801b74:	89 c7                	mov    %eax,%edi
  801b76:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b78:	a1 04 44 80 00       	mov    0x804404,%eax
  801b7d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	57                   	push   %edi
  801b84:	e8 a7 03 00 00       	call   801f30 <pageref>
  801b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b8c:	89 34 24             	mov    %esi,(%esp)
  801b8f:	e8 9c 03 00 00       	call   801f30 <pageref>
		nn = thisenv->env_runs;
  801b94:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801b9a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	39 cb                	cmp    %ecx,%ebx
  801ba2:	74 1b                	je     801bbf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ba4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba7:	75 cf                	jne    801b78 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ba9:	8b 42 58             	mov    0x58(%edx),%eax
  801bac:	6a 01                	push   $0x1
  801bae:	50                   	push   %eax
  801baf:	53                   	push   %ebx
  801bb0:	68 e6 26 80 00       	push   $0x8026e6
  801bb5:	e8 d6 e7 ff ff       	call   800390 <cprintf>
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	eb b9                	jmp    801b78 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bbf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc2:	0f 94 c0             	sete   %al
  801bc5:	0f b6 c0             	movzbl %al,%eax
}
  801bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bcb:	5b                   	pop    %ebx
  801bcc:	5e                   	pop    %esi
  801bcd:	5f                   	pop    %edi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    

00801bd0 <devpipe_write>:
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	57                   	push   %edi
  801bd4:	56                   	push   %esi
  801bd5:	53                   	push   %ebx
  801bd6:	83 ec 28             	sub    $0x28,%esp
  801bd9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bdc:	56                   	push   %esi
  801bdd:	e8 21 f6 ff ff       	call   801203 <fd2data>
  801be2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801be4:	83 c4 10             	add    $0x10,%esp
  801be7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bec:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bef:	74 4f                	je     801c40 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bf1:	8b 43 04             	mov    0x4(%ebx),%eax
  801bf4:	8b 0b                	mov    (%ebx),%ecx
  801bf6:	8d 51 20             	lea    0x20(%ecx),%edx
  801bf9:	39 d0                	cmp    %edx,%eax
  801bfb:	72 14                	jb     801c11 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bfd:	89 da                	mov    %ebx,%edx
  801bff:	89 f0                	mov    %esi,%eax
  801c01:	e8 65 ff ff ff       	call   801b6b <_pipeisclosed>
  801c06:	85 c0                	test   %eax,%eax
  801c08:	75 3b                	jne    801c45 <devpipe_write+0x75>
			sys_yield();
  801c0a:	e8 52 f3 ff ff       	call   800f61 <sys_yield>
  801c0f:	eb e0                	jmp    801bf1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c14:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c18:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c1b:	89 c2                	mov    %eax,%edx
  801c1d:	c1 fa 1f             	sar    $0x1f,%edx
  801c20:	89 d1                	mov    %edx,%ecx
  801c22:	c1 e9 1b             	shr    $0x1b,%ecx
  801c25:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c28:	83 e2 1f             	and    $0x1f,%edx
  801c2b:	29 ca                	sub    %ecx,%edx
  801c2d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c31:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c35:	83 c0 01             	add    $0x1,%eax
  801c38:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c3b:	83 c7 01             	add    $0x1,%edi
  801c3e:	eb ac                	jmp    801bec <devpipe_write+0x1c>
	return i;
  801c40:	8b 45 10             	mov    0x10(%ebp),%eax
  801c43:	eb 05                	jmp    801c4a <devpipe_write+0x7a>
				return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5e                   	pop    %esi
  801c4f:	5f                   	pop    %edi
  801c50:	5d                   	pop    %ebp
  801c51:	c3                   	ret    

00801c52 <devpipe_read>:
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 18             	sub    $0x18,%esp
  801c5b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c5e:	57                   	push   %edi
  801c5f:	e8 9f f5 ff ff       	call   801203 <fd2data>
  801c64:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	be 00 00 00 00       	mov    $0x0,%esi
  801c6e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c71:	75 14                	jne    801c87 <devpipe_read+0x35>
	return i;
  801c73:	8b 45 10             	mov    0x10(%ebp),%eax
  801c76:	eb 02                	jmp    801c7a <devpipe_read+0x28>
				return i;
  801c78:	89 f0                	mov    %esi,%eax
}
  801c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5e                   	pop    %esi
  801c7f:	5f                   	pop    %edi
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    
			sys_yield();
  801c82:	e8 da f2 ff ff       	call   800f61 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c87:	8b 03                	mov    (%ebx),%eax
  801c89:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c8c:	75 18                	jne    801ca6 <devpipe_read+0x54>
			if (i > 0)
  801c8e:	85 f6                	test   %esi,%esi
  801c90:	75 e6                	jne    801c78 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801c92:	89 da                	mov    %ebx,%edx
  801c94:	89 f8                	mov    %edi,%eax
  801c96:	e8 d0 fe ff ff       	call   801b6b <_pipeisclosed>
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	74 e3                	je     801c82 <devpipe_read+0x30>
				return 0;
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca4:	eb d4                	jmp    801c7a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ca6:	99                   	cltd   
  801ca7:	c1 ea 1b             	shr    $0x1b,%edx
  801caa:	01 d0                	add    %edx,%eax
  801cac:	83 e0 1f             	and    $0x1f,%eax
  801caf:	29 d0                	sub    %edx,%eax
  801cb1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cbc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cbf:	83 c6 01             	add    $0x1,%esi
  801cc2:	eb aa                	jmp    801c6e <devpipe_read+0x1c>

00801cc4 <pipe>:
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	56                   	push   %esi
  801cc8:	53                   	push   %ebx
  801cc9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ccf:	50                   	push   %eax
  801cd0:	e8 45 f5 ff ff       	call   80121a <fd_alloc>
  801cd5:	89 c3                	mov    %eax,%ebx
  801cd7:	83 c4 10             	add    $0x10,%esp
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	0f 88 23 01 00 00    	js     801e05 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce2:	83 ec 04             	sub    $0x4,%esp
  801ce5:	68 07 04 00 00       	push   $0x407
  801cea:	ff 75 f4             	pushl  -0xc(%ebp)
  801ced:	6a 00                	push   $0x0
  801cef:	e8 8c f2 ff ff       	call   800f80 <sys_page_alloc>
  801cf4:	89 c3                	mov    %eax,%ebx
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	0f 88 04 01 00 00    	js     801e05 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d01:	83 ec 0c             	sub    $0xc,%esp
  801d04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d07:	50                   	push   %eax
  801d08:	e8 0d f5 ff ff       	call   80121a <fd_alloc>
  801d0d:	89 c3                	mov    %eax,%ebx
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	85 c0                	test   %eax,%eax
  801d14:	0f 88 db 00 00 00    	js     801df5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d1a:	83 ec 04             	sub    $0x4,%esp
  801d1d:	68 07 04 00 00       	push   $0x407
  801d22:	ff 75 f0             	pushl  -0x10(%ebp)
  801d25:	6a 00                	push   $0x0
  801d27:	e8 54 f2 ff ff       	call   800f80 <sys_page_alloc>
  801d2c:	89 c3                	mov    %eax,%ebx
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	85 c0                	test   %eax,%eax
  801d33:	0f 88 bc 00 00 00    	js     801df5 <pipe+0x131>
	va = fd2data(fd0);
  801d39:	83 ec 0c             	sub    $0xc,%esp
  801d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3f:	e8 bf f4 ff ff       	call   801203 <fd2data>
  801d44:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d46:	83 c4 0c             	add    $0xc,%esp
  801d49:	68 07 04 00 00       	push   $0x407
  801d4e:	50                   	push   %eax
  801d4f:	6a 00                	push   $0x0
  801d51:	e8 2a f2 ff ff       	call   800f80 <sys_page_alloc>
  801d56:	89 c3                	mov    %eax,%ebx
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	85 c0                	test   %eax,%eax
  801d5d:	0f 88 82 00 00 00    	js     801de5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d63:	83 ec 0c             	sub    $0xc,%esp
  801d66:	ff 75 f0             	pushl  -0x10(%ebp)
  801d69:	e8 95 f4 ff ff       	call   801203 <fd2data>
  801d6e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d75:	50                   	push   %eax
  801d76:	6a 00                	push   $0x0
  801d78:	56                   	push   %esi
  801d79:	6a 00                	push   $0x0
  801d7b:	e8 43 f2 ff ff       	call   800fc3 <sys_page_map>
  801d80:	89 c3                	mov    %eax,%ebx
  801d82:	83 c4 20             	add    $0x20,%esp
  801d85:	85 c0                	test   %eax,%eax
  801d87:	78 4e                	js     801dd7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d89:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801d8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d91:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d96:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801da0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dac:	83 ec 0c             	sub    $0xc,%esp
  801daf:	ff 75 f4             	pushl  -0xc(%ebp)
  801db2:	e8 3c f4 ff ff       	call   8011f3 <fd2num>
  801db7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dba:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dbc:	83 c4 04             	add    $0x4,%esp
  801dbf:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc2:	e8 2c f4 ff ff       	call   8011f3 <fd2num>
  801dc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dca:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dd5:	eb 2e                	jmp    801e05 <pipe+0x141>
	sys_page_unmap(0, va);
  801dd7:	83 ec 08             	sub    $0x8,%esp
  801dda:	56                   	push   %esi
  801ddb:	6a 00                	push   $0x0
  801ddd:	e8 23 f2 ff ff       	call   801005 <sys_page_unmap>
  801de2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801de5:	83 ec 08             	sub    $0x8,%esp
  801de8:	ff 75 f0             	pushl  -0x10(%ebp)
  801deb:	6a 00                	push   $0x0
  801ded:	e8 13 f2 ff ff       	call   801005 <sys_page_unmap>
  801df2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801df5:	83 ec 08             	sub    $0x8,%esp
  801df8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfb:	6a 00                	push   $0x0
  801dfd:	e8 03 f2 ff ff       	call   801005 <sys_page_unmap>
  801e02:	83 c4 10             	add    $0x10,%esp
}
  801e05:	89 d8                	mov    %ebx,%eax
  801e07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0a:	5b                   	pop    %ebx
  801e0b:	5e                   	pop    %esi
  801e0c:	5d                   	pop    %ebp
  801e0d:	c3                   	ret    

00801e0e <pipeisclosed>:
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e17:	50                   	push   %eax
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	e8 4c f4 ff ff       	call   80126c <fd_lookup>
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	85 c0                	test   %eax,%eax
  801e25:	78 18                	js     801e3f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e27:	83 ec 0c             	sub    $0xc,%esp
  801e2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2d:	e8 d1 f3 ff ff       	call   801203 <fd2data>
	return _pipeisclosed(fd, p);
  801e32:	89 c2                	mov    %eax,%edx
  801e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e37:	e8 2f fd ff ff       	call   801b6b <_pipeisclosed>
  801e3c:	83 c4 10             	add    $0x10,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	56                   	push   %esi
  801e45:	53                   	push   %ebx
  801e46:	8b 75 08             	mov    0x8(%ebp),%esi
  801e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  801e4f:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801e51:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e56:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  801e59:	83 ec 0c             	sub    $0xc,%esp
  801e5c:	50                   	push   %eax
  801e5d:	e8 0f f3 ff ff       	call   801171 <sys_ipc_recv>
	if (from_env_store)
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	85 f6                	test   %esi,%esi
  801e67:	74 14                	je     801e7d <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  801e69:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 09                	js     801e7b <ipc_recv+0x3a>
  801e72:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801e78:	8b 52 78             	mov    0x78(%edx),%edx
  801e7b:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  801e7d:	85 db                	test   %ebx,%ebx
  801e7f:	74 14                	je     801e95 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  801e81:	ba 00 00 00 00       	mov    $0x0,%edx
  801e86:	85 c0                	test   %eax,%eax
  801e88:	78 09                	js     801e93 <ipc_recv+0x52>
  801e8a:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801e90:	8b 52 7c             	mov    0x7c(%edx),%edx
  801e93:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 08                	js     801ea1 <ipc_recv+0x60>
  801e99:	a1 04 44 80 00       	mov    0x804404,%eax
  801e9e:	8b 40 74             	mov    0x74(%eax),%eax
}
  801ea1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea4:	5b                   	pop    %ebx
  801ea5:	5e                   	pop    %esi
  801ea6:	5d                   	pop    %ebp
  801ea7:	c3                   	ret    

00801ea8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 08             	sub    $0x8,%esp
  801eae:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801eb8:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801ebb:	ff 75 14             	pushl  0x14(%ebp)
  801ebe:	50                   	push   %eax
  801ebf:	ff 75 0c             	pushl  0xc(%ebp)
  801ec2:	ff 75 08             	pushl  0x8(%ebp)
  801ec5:	e8 84 f2 ff ff       	call   80114e <sys_ipc_try_send>
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 02                	js     801ed3 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  801ed3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ed6:	75 07                	jne    801edf <ipc_send+0x37>
		sys_yield();
  801ed8:	e8 84 f0 ff ff       	call   800f61 <sys_yield>
}
  801edd:	eb f2                	jmp    801ed1 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  801edf:	50                   	push   %eax
  801ee0:	68 fe 26 80 00       	push   $0x8026fe
  801ee5:	6a 3c                	push   $0x3c
  801ee7:	68 12 27 80 00       	push   $0x802712
  801eec:	e8 c4 e3 ff ff       	call   8002b5 <_panic>

00801ef1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ef7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  801efc:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801eff:	c1 e0 04             	shl    $0x4,%eax
  801f02:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f07:	8b 40 50             	mov    0x50(%eax),%eax
  801f0a:	39 c8                	cmp    %ecx,%eax
  801f0c:	74 12                	je     801f20 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801f0e:	83 c2 01             	add    $0x1,%edx
  801f11:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  801f17:	75 e3                	jne    801efc <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	eb 0e                	jmp    801f2e <ipc_find_env+0x3d>
			return envs[i].env_id;
  801f20:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801f23:	c1 e0 04             	shl    $0x4,%eax
  801f26:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f2b:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f2e:	5d                   	pop    %ebp
  801f2f:	c3                   	ret    

00801f30 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f36:	89 d0                	mov    %edx,%eax
  801f38:	c1 e8 16             	shr    $0x16,%eax
  801f3b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801f47:	f6 c1 01             	test   $0x1,%cl
  801f4a:	74 1d                	je     801f69 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801f4c:	c1 ea 0c             	shr    $0xc,%edx
  801f4f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f56:	f6 c2 01             	test   $0x1,%dl
  801f59:	74 0e                	je     801f69 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f5b:	c1 ea 0c             	shr    $0xc,%edx
  801f5e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f65:	ef 
  801f66:	0f b7 c0             	movzwl %ax,%eax
}
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    
  801f6b:	66 90                	xchg   %ax,%ax
  801f6d:	66 90                	xchg   %ax,%ax
  801f6f:	90                   	nop

00801f70 <__udivdi3>:
  801f70:	55                   	push   %ebp
  801f71:	57                   	push   %edi
  801f72:	56                   	push   %esi
  801f73:	53                   	push   %ebx
  801f74:	83 ec 1c             	sub    $0x1c,%esp
  801f77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f87:	85 d2                	test   %edx,%edx
  801f89:	75 4d                	jne    801fd8 <__udivdi3+0x68>
  801f8b:	39 f3                	cmp    %esi,%ebx
  801f8d:	76 19                	jbe    801fa8 <__udivdi3+0x38>
  801f8f:	31 ff                	xor    %edi,%edi
  801f91:	89 e8                	mov    %ebp,%eax
  801f93:	89 f2                	mov    %esi,%edx
  801f95:	f7 f3                	div    %ebx
  801f97:	89 fa                	mov    %edi,%edx
  801f99:	83 c4 1c             	add    $0x1c,%esp
  801f9c:	5b                   	pop    %ebx
  801f9d:	5e                   	pop    %esi
  801f9e:	5f                   	pop    %edi
  801f9f:	5d                   	pop    %ebp
  801fa0:	c3                   	ret    
  801fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fa8:	89 d9                	mov    %ebx,%ecx
  801faa:	85 db                	test   %ebx,%ebx
  801fac:	75 0b                	jne    801fb9 <__udivdi3+0x49>
  801fae:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb3:	31 d2                	xor    %edx,%edx
  801fb5:	f7 f3                	div    %ebx
  801fb7:	89 c1                	mov    %eax,%ecx
  801fb9:	31 d2                	xor    %edx,%edx
  801fbb:	89 f0                	mov    %esi,%eax
  801fbd:	f7 f1                	div    %ecx
  801fbf:	89 c6                	mov    %eax,%esi
  801fc1:	89 e8                	mov    %ebp,%eax
  801fc3:	89 f7                	mov    %esi,%edi
  801fc5:	f7 f1                	div    %ecx
  801fc7:	89 fa                	mov    %edi,%edx
  801fc9:	83 c4 1c             	add    $0x1c,%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5e                   	pop    %esi
  801fce:	5f                   	pop    %edi
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    
  801fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fd8:	39 f2                	cmp    %esi,%edx
  801fda:	77 1c                	ja     801ff8 <__udivdi3+0x88>
  801fdc:	0f bd fa             	bsr    %edx,%edi
  801fdf:	83 f7 1f             	xor    $0x1f,%edi
  801fe2:	75 2c                	jne    802010 <__udivdi3+0xa0>
  801fe4:	39 f2                	cmp    %esi,%edx
  801fe6:	72 06                	jb     801fee <__udivdi3+0x7e>
  801fe8:	31 c0                	xor    %eax,%eax
  801fea:	39 eb                	cmp    %ebp,%ebx
  801fec:	77 a9                	ja     801f97 <__udivdi3+0x27>
  801fee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff3:	eb a2                	jmp    801f97 <__udivdi3+0x27>
  801ff5:	8d 76 00             	lea    0x0(%esi),%esi
  801ff8:	31 ff                	xor    %edi,%edi
  801ffa:	31 c0                	xor    %eax,%eax
  801ffc:	89 fa                	mov    %edi,%edx
  801ffe:	83 c4 1c             	add    $0x1c,%esp
  802001:	5b                   	pop    %ebx
  802002:	5e                   	pop    %esi
  802003:	5f                   	pop    %edi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
  802006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80200d:	8d 76 00             	lea    0x0(%esi),%esi
  802010:	89 f9                	mov    %edi,%ecx
  802012:	b8 20 00 00 00       	mov    $0x20,%eax
  802017:	29 f8                	sub    %edi,%eax
  802019:	d3 e2                	shl    %cl,%edx
  80201b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80201f:	89 c1                	mov    %eax,%ecx
  802021:	89 da                	mov    %ebx,%edx
  802023:	d3 ea                	shr    %cl,%edx
  802025:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802029:	09 d1                	or     %edx,%ecx
  80202b:	89 f2                	mov    %esi,%edx
  80202d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802031:	89 f9                	mov    %edi,%ecx
  802033:	d3 e3                	shl    %cl,%ebx
  802035:	89 c1                	mov    %eax,%ecx
  802037:	d3 ea                	shr    %cl,%edx
  802039:	89 f9                	mov    %edi,%ecx
  80203b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80203f:	89 eb                	mov    %ebp,%ebx
  802041:	d3 e6                	shl    %cl,%esi
  802043:	89 c1                	mov    %eax,%ecx
  802045:	d3 eb                	shr    %cl,%ebx
  802047:	09 de                	or     %ebx,%esi
  802049:	89 f0                	mov    %esi,%eax
  80204b:	f7 74 24 08          	divl   0x8(%esp)
  80204f:	89 d6                	mov    %edx,%esi
  802051:	89 c3                	mov    %eax,%ebx
  802053:	f7 64 24 0c          	mull   0xc(%esp)
  802057:	39 d6                	cmp    %edx,%esi
  802059:	72 15                	jb     802070 <__udivdi3+0x100>
  80205b:	89 f9                	mov    %edi,%ecx
  80205d:	d3 e5                	shl    %cl,%ebp
  80205f:	39 c5                	cmp    %eax,%ebp
  802061:	73 04                	jae    802067 <__udivdi3+0xf7>
  802063:	39 d6                	cmp    %edx,%esi
  802065:	74 09                	je     802070 <__udivdi3+0x100>
  802067:	89 d8                	mov    %ebx,%eax
  802069:	31 ff                	xor    %edi,%edi
  80206b:	e9 27 ff ff ff       	jmp    801f97 <__udivdi3+0x27>
  802070:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802073:	31 ff                	xor    %edi,%edi
  802075:	e9 1d ff ff ff       	jmp    801f97 <__udivdi3+0x27>
  80207a:	66 90                	xchg   %ax,%ax
  80207c:	66 90                	xchg   %ax,%ax
  80207e:	66 90                	xchg   %ax,%ax

00802080 <__umoddi3>:
  802080:	55                   	push   %ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 1c             	sub    $0x1c,%esp
  802087:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80208b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80208f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802097:	89 da                	mov    %ebx,%edx
  802099:	85 c0                	test   %eax,%eax
  80209b:	75 43                	jne    8020e0 <__umoddi3+0x60>
  80209d:	39 df                	cmp    %ebx,%edi
  80209f:	76 17                	jbe    8020b8 <__umoddi3+0x38>
  8020a1:	89 f0                	mov    %esi,%eax
  8020a3:	f7 f7                	div    %edi
  8020a5:	89 d0                	mov    %edx,%eax
  8020a7:	31 d2                	xor    %edx,%edx
  8020a9:	83 c4 1c             	add    $0x1c,%esp
  8020ac:	5b                   	pop    %ebx
  8020ad:	5e                   	pop    %esi
  8020ae:	5f                   	pop    %edi
  8020af:	5d                   	pop    %ebp
  8020b0:	c3                   	ret    
  8020b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020b8:	89 fd                	mov    %edi,%ebp
  8020ba:	85 ff                	test   %edi,%edi
  8020bc:	75 0b                	jne    8020c9 <__umoddi3+0x49>
  8020be:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c3:	31 d2                	xor    %edx,%edx
  8020c5:	f7 f7                	div    %edi
  8020c7:	89 c5                	mov    %eax,%ebp
  8020c9:	89 d8                	mov    %ebx,%eax
  8020cb:	31 d2                	xor    %edx,%edx
  8020cd:	f7 f5                	div    %ebp
  8020cf:	89 f0                	mov    %esi,%eax
  8020d1:	f7 f5                	div    %ebp
  8020d3:	89 d0                	mov    %edx,%eax
  8020d5:	eb d0                	jmp    8020a7 <__umoddi3+0x27>
  8020d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020de:	66 90                	xchg   %ax,%ax
  8020e0:	89 f1                	mov    %esi,%ecx
  8020e2:	39 d8                	cmp    %ebx,%eax
  8020e4:	76 0a                	jbe    8020f0 <__umoddi3+0x70>
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	83 c4 1c             	add    $0x1c,%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5f                   	pop    %edi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    
  8020f0:	0f bd e8             	bsr    %eax,%ebp
  8020f3:	83 f5 1f             	xor    $0x1f,%ebp
  8020f6:	75 20                	jne    802118 <__umoddi3+0x98>
  8020f8:	39 d8                	cmp    %ebx,%eax
  8020fa:	0f 82 b0 00 00 00    	jb     8021b0 <__umoddi3+0x130>
  802100:	39 f7                	cmp    %esi,%edi
  802102:	0f 86 a8 00 00 00    	jbe    8021b0 <__umoddi3+0x130>
  802108:	89 c8                	mov    %ecx,%eax
  80210a:	83 c4 1c             	add    $0x1c,%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5f                   	pop    %edi
  802110:	5d                   	pop    %ebp
  802111:	c3                   	ret    
  802112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802118:	89 e9                	mov    %ebp,%ecx
  80211a:	ba 20 00 00 00       	mov    $0x20,%edx
  80211f:	29 ea                	sub    %ebp,%edx
  802121:	d3 e0                	shl    %cl,%eax
  802123:	89 44 24 08          	mov    %eax,0x8(%esp)
  802127:	89 d1                	mov    %edx,%ecx
  802129:	89 f8                	mov    %edi,%eax
  80212b:	d3 e8                	shr    %cl,%eax
  80212d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802131:	89 54 24 04          	mov    %edx,0x4(%esp)
  802135:	8b 54 24 04          	mov    0x4(%esp),%edx
  802139:	09 c1                	or     %eax,%ecx
  80213b:	89 d8                	mov    %ebx,%eax
  80213d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802141:	89 e9                	mov    %ebp,%ecx
  802143:	d3 e7                	shl    %cl,%edi
  802145:	89 d1                	mov    %edx,%ecx
  802147:	d3 e8                	shr    %cl,%eax
  802149:	89 e9                	mov    %ebp,%ecx
  80214b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80214f:	d3 e3                	shl    %cl,%ebx
  802151:	89 c7                	mov    %eax,%edi
  802153:	89 d1                	mov    %edx,%ecx
  802155:	89 f0                	mov    %esi,%eax
  802157:	d3 e8                	shr    %cl,%eax
  802159:	89 e9                	mov    %ebp,%ecx
  80215b:	89 fa                	mov    %edi,%edx
  80215d:	d3 e6                	shl    %cl,%esi
  80215f:	09 d8                	or     %ebx,%eax
  802161:	f7 74 24 08          	divl   0x8(%esp)
  802165:	89 d1                	mov    %edx,%ecx
  802167:	89 f3                	mov    %esi,%ebx
  802169:	f7 64 24 0c          	mull   0xc(%esp)
  80216d:	89 c6                	mov    %eax,%esi
  80216f:	89 d7                	mov    %edx,%edi
  802171:	39 d1                	cmp    %edx,%ecx
  802173:	72 06                	jb     80217b <__umoddi3+0xfb>
  802175:	75 10                	jne    802187 <__umoddi3+0x107>
  802177:	39 c3                	cmp    %eax,%ebx
  802179:	73 0c                	jae    802187 <__umoddi3+0x107>
  80217b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80217f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802183:	89 d7                	mov    %edx,%edi
  802185:	89 c6                	mov    %eax,%esi
  802187:	89 ca                	mov    %ecx,%edx
  802189:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80218e:	29 f3                	sub    %esi,%ebx
  802190:	19 fa                	sbb    %edi,%edx
  802192:	89 d0                	mov    %edx,%eax
  802194:	d3 e0                	shl    %cl,%eax
  802196:	89 e9                	mov    %ebp,%ecx
  802198:	d3 eb                	shr    %cl,%ebx
  80219a:	d3 ea                	shr    %cl,%edx
  80219c:	09 d8                	or     %ebx,%eax
  80219e:	83 c4 1c             	add    $0x1c,%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5f                   	pop    %edi
  8021a4:	5d                   	pop    %ebp
  8021a5:	c3                   	ret    
  8021a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021ad:	8d 76 00             	lea    0x0(%esi),%esi
  8021b0:	89 da                	mov    %ebx,%edx
  8021b2:	29 fe                	sub    %edi,%esi
  8021b4:	19 c2                	sbb    %eax,%edx
  8021b6:	89 f1                	mov    %esi,%ecx
  8021b8:	89 c8                	mov    %ecx,%eax
  8021ba:	e9 4b ff ff ff       	jmp    80210a <__umoddi3+0x8a>
