
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 d9 09 00 00       	call   800a0a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800042:	85 db                	test   %ebx,%ebx
  800044:	74 39                	je     80007f <_gettoken+0x4c>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  800046:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80004d:	7f 50                	jg     80009f <_gettoken+0x6c>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  80004f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800055:	8b 45 10             	mov    0x10(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005e:	83 ec 08             	sub    $0x8,%esp
  800061:	0f be 03             	movsbl (%ebx),%eax
  800064:	50                   	push   %eax
  800065:	68 dd 34 80 00       	push   $0x8034dd
  80006a:	e8 d8 13 00 00       	call   801447 <strchr>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	74 3c                	je     8000b2 <_gettoken+0x7f>
		*s++ = 0;
  800076:	83 c3 01             	add    $0x1,%ebx
  800079:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  80007d:	eb df                	jmp    80005e <_gettoken+0x2b>
		return 0;
  80007f:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800084:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80008b:	7e 3a                	jle    8000c7 <_gettoken+0x94>
			cprintf("GETTOKEN NULL\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 c0 34 80 00       	push   $0x8034c0
  800095:	e8 a6 0a 00 00       	call   800b40 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 cf 34 80 00       	push   $0x8034cf
  8000a8:	e8 93 0a 00 00       	call   800b40 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	eb 9d                	jmp    80004f <_gettoken+0x1c>
	if (*s == 0) {
  8000b2:	0f b6 03             	movzbl (%ebx),%eax
  8000b5:	84 c0                	test   %al,%al
  8000b7:	75 2a                	jne    8000e3 <_gettoken+0xb0>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b9:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000be:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c5:	7f 0a                	jg     8000d1 <_gettoken+0x9e>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c7:	89 f0                	mov    %esi,%eax
  8000c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5f                   	pop    %edi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
			cprintf("EOL\n");
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	68 e2 34 80 00       	push   $0x8034e2
  8000d9:	e8 62 0a 00 00       	call   800b40 <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 f3 34 80 00       	push   $0x8034f3
  8000ef:	e8 53 13 00 00       	call   801447 <strchr>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	74 2c                	je     800127 <_gettoken+0xf4>
		t = *s;
  8000fb:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000fe:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800100:	c6 03 00             	movb   $0x0,(%ebx)
  800103:	83 c3 01             	add    $0x1,%ebx
  800106:	8b 45 10             	mov    0x10(%ebp),%eax
  800109:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010b:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800112:	7e b3                	jle    8000c7 <_gettoken+0x94>
			cprintf("TOK %c\n", t);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	68 e7 34 80 00       	push   $0x8034e7
  80011d:	e8 1e 0a 00 00       	call   800b40 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	eb a0                	jmp    8000c7 <_gettoken+0x94>
	*p1 = s;
  800127:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800129:	eb 03                	jmp    80012e <_gettoken+0xfb>
		s++;
  80012b:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012e:	0f b6 03             	movzbl (%ebx),%eax
  800131:	84 c0                	test   %al,%al
  800133:	74 18                	je     80014d <_gettoken+0x11a>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	0f be c0             	movsbl %al,%eax
  80013b:	50                   	push   %eax
  80013c:	68 ef 34 80 00       	push   $0x8034ef
  800141:	e8 01 13 00 00       	call   801447 <strchr>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	85 c0                	test   %eax,%eax
  80014b:	74 de                	je     80012b <_gettoken+0xf8>
	*p2 = s;
  80014d:	8b 45 10             	mov    0x10(%ebp),%eax
  800150:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800152:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800157:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80015e:	0f 8e 63 ff ff ff    	jle    8000c7 <_gettoken+0x94>
		t = **p2;
  800164:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800167:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 37                	pushl  (%edi)
  80016f:	68 fb 34 80 00       	push   $0x8034fb
  800174:	e8 c7 09 00 00       	call   800b40 <cprintf>
		**p2 = t;
  800179:	8b 45 10             	mov    0x10(%ebp),%eax
  80017c:	8b 00                	mov    (%eax),%eax
  80017e:	89 f2                	mov    %esi,%edx
  800180:	88 10                	mov    %dl,(%eax)
  800182:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800185:	be 77 00 00 00       	mov    $0x77,%esi
  80018a:	e9 38 ff ff ff       	jmp    8000c7 <_gettoken+0x94>

0080018f <gettoken>:

int
gettoken(char *s, char **p1)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800198:	85 c0                	test   %eax,%eax
  80019a:	74 22                	je     8001be <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	68 0c 50 80 00       	push   $0x80500c
  8001a4:	68 10 50 80 00       	push   $0x805010
  8001a9:	50                   	push   %eax
  8001aa:	e8 84 fe ff ff       	call   800033 <_gettoken>
  8001af:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
	c = nc;
  8001be:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c3:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001c8:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	68 0c 50 80 00       	push   $0x80500c
  8001db:	68 10 50 80 00       	push   $0x805010
  8001e0:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001e6:	e8 48 fe ff ff       	call   800033 <_gettoken>
  8001eb:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f0:	a1 04 50 80 00       	mov    0x805004,%eax
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	eb c2                	jmp    8001bc <gettoken+0x2d>

008001fa <runcmd>:
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	57                   	push   %edi
  8001fe:	56                   	push   %esi
  8001ff:	53                   	push   %ebx
  800200:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800206:	6a 00                	push   $0x0
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	e8 7f ff ff ff       	call   80018f <gettoken>
  800210:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800213:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  800216:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	56                   	push   %esi
  80021f:	6a 00                	push   $0x0
  800221:	e8 69 ff ff ff       	call   80018f <gettoken>
  800226:	89 c3                	mov    %eax,%ebx
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	83 f8 3e             	cmp    $0x3e,%eax
  80022e:	0f 84 32 01 00 00    	je     800366 <runcmd+0x16c>
  800234:	7f 49                	jg     80027f <runcmd+0x85>
  800236:	85 c0                	test   %eax,%eax
  800238:	0f 84 1c 02 00 00    	je     80045a <runcmd+0x260>
  80023e:	83 f8 3c             	cmp    $0x3c,%eax
  800241:	0f 85 ef 02 00 00    	jne    800536 <runcmd+0x33c>
			if (gettoken(0, &t) != 'w') {
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	6a 00                	push   $0x0
  80024d:	e8 3d ff ff ff       	call   80018f <gettoken>
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	83 f8 77             	cmp    $0x77,%eax
  800258:	0f 85 ba 00 00 00    	jne    800318 <runcmd+0x11e>
			if ((fd = open(t, O_RDONLY)) < 0) {
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	6a 00                	push   $0x0
  800263:	ff 75 a4             	pushl  -0x5c(%ebp)
  800266:	e8 fd 22 00 00       	call   802568 <open>
  80026b:	89 c3                	mov    %eax,%ebx
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	85 c0                	test   %eax,%eax
  800272:	0f 88 ba 00 00 00    	js     800332 <runcmd+0x138>
			if (fd != 0) {
  800278:	74 a1                	je     80021b <runcmd+0x21>
  80027a:	e9 cc 00 00 00       	jmp    80034b <runcmd+0x151>
		switch ((c = gettoken(0, &t))) {
  80027f:	83 f8 77             	cmp    $0x77,%eax
  800282:	74 69                	je     8002ed <runcmd+0xf3>
  800284:	83 f8 7c             	cmp    $0x7c,%eax
  800287:	0f 85 a9 02 00 00    	jne    800536 <runcmd+0x33c>
			if ((r = pipe(p)) < 0) {
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800296:	50                   	push   %eax
  800297:	e8 43 2c 00 00       	call   802edf <pipe>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	0f 88 41 01 00 00    	js     8003e8 <runcmd+0x1ee>
			if (debug)
  8002a7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002ae:	0f 85 4f 01 00 00    	jne    800403 <runcmd+0x209>
			if ((r = fork()) < 0) {
  8002b4:	e8 ee 17 00 00       	call   801aa7 <fork>
  8002b9:	89 c3                	mov    %eax,%ebx
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	0f 88 61 01 00 00    	js     800424 <runcmd+0x22a>
			if (r == 0) {
  8002c3:	0f 85 71 01 00 00    	jne    80043a <runcmd+0x240>
				if (p[0] != 0) {
  8002c9:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002cf:	85 c0                	test   %eax,%eax
  8002d1:	0f 85 1d 02 00 00    	jne    8004f4 <runcmd+0x2fa>
				close(p[1]);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002e0:	e8 e2 1c 00 00       	call   801fc7 <close>
				goto again;
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	e9 29 ff ff ff       	jmp    800216 <runcmd+0x1c>
			if (argc == MAXARGS) {
  8002ed:	83 ff 10             	cmp    $0x10,%edi
  8002f0:	74 0f                	je     800301 <runcmd+0x107>
			argv[argc++] = t;
  8002f2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f5:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  8002f9:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  8002fc:	e9 1a ff ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("too many arguments\n");
  800301:	83 ec 0c             	sub    $0xc,%esp
  800304:	68 05 35 80 00       	push   $0x803505
  800309:	e8 32 08 00 00       	call   800b40 <cprintf>
				exit();
  80030e:	e8 40 07 00 00       	call   800a53 <exit>
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	eb da                	jmp    8002f2 <runcmd+0xf8>
				cprintf("syntax error: < not followed by word\n");
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	68 50 36 80 00       	push   $0x803650
  800320:	e8 1b 08 00 00       	call   800b40 <cprintf>
				exit();
  800325:	e8 29 07 00 00       	call   800a53 <exit>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	e9 2c ff ff ff       	jmp    80025e <runcmd+0x64>
				cprintf("open %s for read: %e", t, fd);
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	50                   	push   %eax
  800336:	ff 75 a4             	pushl  -0x5c(%ebp)
  800339:	68 19 35 80 00       	push   $0x803519
  80033e:	e8 fd 07 00 00       	call   800b40 <cprintf>
				exit();
  800343:	e8 0b 07 00 00       	call   800a53 <exit>
  800348:	83 c4 10             	add    $0x10,%esp
				dup(fd, 0);
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	6a 00                	push   $0x0
  800350:	53                   	push   %ebx
  800351:	e8 c3 1c 00 00       	call   802019 <dup>
				close(fd);
  800356:	89 1c 24             	mov    %ebx,(%esp)
  800359:	e8 69 1c 00 00       	call   801fc7 <close>
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	e9 b5 fe ff ff       	jmp    80021b <runcmd+0x21>
			if (gettoken(0, &t) != 'w') {
  800366:	83 ec 08             	sub    $0x8,%esp
  800369:	56                   	push   %esi
  80036a:	6a 00                	push   $0x0
  80036c:	e8 1e fe ff ff       	call   80018f <gettoken>
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	83 f8 77             	cmp    $0x77,%eax
  800377:	75 24                	jne    80039d <runcmd+0x1a3>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	68 01 03 00 00       	push   $0x301
  800381:	ff 75 a4             	pushl  -0x5c(%ebp)
  800384:	e8 df 21 00 00       	call   802568 <open>
  800389:	89 c3                	mov    %eax,%ebx
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	85 c0                	test   %eax,%eax
  800390:	78 22                	js     8003b4 <runcmd+0x1ba>
			if (fd != 1) {
  800392:	83 f8 01             	cmp    $0x1,%eax
  800395:	0f 84 80 fe ff ff    	je     80021b <runcmd+0x21>
  80039b:	eb 30                	jmp    8003cd <runcmd+0x1d3>
				cprintf("syntax error: > not followed by word\n");
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	68 78 36 80 00       	push   $0x803678
  8003a5:	e8 96 07 00 00       	call   800b40 <cprintf>
				exit();
  8003aa:	e8 a4 06 00 00       	call   800a53 <exit>
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	eb c5                	jmp    800379 <runcmd+0x17f>
				cprintf("open %s for write: %e", t, fd);
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	50                   	push   %eax
  8003b8:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003bb:	68 2e 35 80 00       	push   $0x80352e
  8003c0:	e8 7b 07 00 00       	call   800b40 <cprintf>
				exit();
  8003c5:	e8 89 06 00 00       	call   800a53 <exit>
  8003ca:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	6a 01                	push   $0x1
  8003d2:	53                   	push   %ebx
  8003d3:	e8 41 1c 00 00       	call   802019 <dup>
				close(fd);
  8003d8:	89 1c 24             	mov    %ebx,(%esp)
  8003db:	e8 e7 1b 00 00       	call   801fc7 <close>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	e9 33 fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	50                   	push   %eax
  8003ec:	68 44 35 80 00       	push   $0x803544
  8003f1:	e8 4a 07 00 00       	call   800b40 <cprintf>
				exit();
  8003f6:	e8 58 06 00 00       	call   800a53 <exit>
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	e9 a4 fe ff ff       	jmp    8002a7 <runcmd+0xad>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800403:	83 ec 04             	sub    $0x4,%esp
  800406:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80040c:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800412:	68 4d 35 80 00       	push   $0x80354d
  800417:	e8 24 07 00 00       	call   800b40 <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	e9 90 fe ff ff       	jmp    8002b4 <runcmd+0xba>
				cprintf("fork: %e", r);
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	50                   	push   %eax
  800428:	68 90 3b 80 00       	push   $0x803b90
  80042d:	e8 0e 07 00 00       	call   800b40 <cprintf>
				exit();
  800432:	e8 1c 06 00 00       	call   800a53 <exit>
  800437:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  80043a:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800440:	83 f8 01             	cmp    $0x1,%eax
  800443:	0f 85 cc 00 00 00    	jne    800515 <runcmd+0x31b>
				close(p[0]);
  800449:	83 ec 0c             	sub    $0xc,%esp
  80044c:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800452:	e8 70 1b 00 00       	call   801fc7 <close>
				goto runit;
  800457:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  80045a:	85 ff                	test   %edi,%edi
  80045c:	0f 84 e6 00 00 00    	je     800548 <runcmd+0x34e>
	if (argv[0][0] != '/') {
  800462:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800465:	80 38 2f             	cmpb   $0x2f,(%eax)
  800468:	0f 85 f5 00 00 00    	jne    800563 <runcmd+0x369>
	argv[argc] = 0;
  80046e:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  800475:	00 
	if (debug) {
  800476:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80047d:	0f 85 08 01 00 00    	jne    80058b <runcmd+0x391>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800489:	50                   	push   %eax
  80048a:	ff 75 a8             	pushl  -0x58(%ebp)
  80048d:	e8 8f 22 00 00       	call   802721 <spawn>
  800492:	89 c6                	mov    %eax,%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	85 c0                	test   %eax,%eax
  800499:	0f 88 3a 01 00 00    	js     8005d9 <runcmd+0x3df>
	close_all();
  80049f:	e8 50 1b 00 00       	call   801ff4 <close_all>
		if (debug)
  8004a4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004ab:	0f 85 75 01 00 00    	jne    800626 <runcmd+0x42c>
		wait(r);
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	56                   	push   %esi
  8004b5:	e8 a2 2b 00 00       	call   80305c <wait>
		if (debug)
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004c4:	0f 85 7b 01 00 00    	jne    800645 <runcmd+0x44b>
	if (pipe_child) {
  8004ca:	85 db                	test   %ebx,%ebx
  8004cc:	74 19                	je     8004e7 <runcmd+0x2ed>
		wait(pipe_child);
  8004ce:	83 ec 0c             	sub    $0xc,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	e8 85 2b 00 00       	call   80305c <wait>
		if (debug)
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004e1:	0f 85 79 01 00 00    	jne    800660 <runcmd+0x466>
	exit();
  8004e7:	e8 67 05 00 00       	call   800a53 <exit>
}
  8004ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ef:	5b                   	pop    %ebx
  8004f0:	5e                   	pop    %esi
  8004f1:	5f                   	pop    %edi
  8004f2:	5d                   	pop    %ebp
  8004f3:	c3                   	ret    
					dup(p[0], 0);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	6a 00                	push   $0x0
  8004f9:	50                   	push   %eax
  8004fa:	e8 1a 1b 00 00       	call   802019 <dup>
					close(p[0]);
  8004ff:	83 c4 04             	add    $0x4,%esp
  800502:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800508:	e8 ba 1a 00 00       	call   801fc7 <close>
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	e9 c2 fd ff ff       	jmp    8002d7 <runcmd+0xdd>
					dup(p[1], 1);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	6a 01                	push   $0x1
  80051a:	50                   	push   %eax
  80051b:	e8 f9 1a 00 00       	call   802019 <dup>
					close(p[1]);
  800520:	83 c4 04             	add    $0x4,%esp
  800523:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800529:	e8 99 1a 00 00       	call   801fc7 <close>
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	e9 13 ff ff ff       	jmp    800449 <runcmd+0x24f>
			panic("bad return %d from gettoken", c);
  800536:	53                   	push   %ebx
  800537:	68 5a 35 80 00       	push   $0x80355a
  80053c:	6a 78                	push   $0x78
  80053e:	68 76 35 80 00       	push   $0x803576
  800543:	e8 1d 05 00 00       	call   800a65 <_panic>
		if (debug)
  800548:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80054f:	74 9b                	je     8004ec <runcmd+0x2f2>
			cprintf("EMPTY COMMAND\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 80 35 80 00       	push   $0x803580
  800559:	e8 e2 05 00 00       	call   800b40 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	eb 89                	jmp    8004ec <runcmd+0x2f2>
		argv0buf[0] = '/';
  800563:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	50                   	push   %eax
  80056e:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  800574:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 be 0d 00 00       	call   80133e <strcpy>
		argv[0] = argv0buf;
  800580:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	e9 e3 fe ff ff       	jmp    80046e <runcmd+0x274>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80058b:	a1 24 54 80 00       	mov    0x805424,%eax
  800590:	8b 40 48             	mov    0x48(%eax),%eax
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	50                   	push   %eax
  800597:	68 8f 35 80 00       	push   $0x80358f
  80059c:	e8 9f 05 00 00       	call   800b40 <cprintf>
  8005a1:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	eb 11                	jmp    8005ba <runcmd+0x3c0>
			cprintf(" %s", argv[i]);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	50                   	push   %eax
  8005ad:	68 17 36 80 00       	push   $0x803617
  8005b2:	e8 89 05 00 00       	call   800b40 <cprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005bd:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c0:	85 c0                	test   %eax,%eax
  8005c2:	75 e5                	jne    8005a9 <runcmd+0x3af>
		cprintf("\n");
  8005c4:	83 ec 0c             	sub    $0xc,%esp
  8005c7:	68 e0 34 80 00       	push   $0x8034e0
  8005cc:	e8 6f 05 00 00       	call   800b40 <cprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	e9 aa fe ff ff       	jmp    800483 <runcmd+0x289>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	50                   	push   %eax
  8005dd:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e0:	68 9d 35 80 00       	push   $0x80359d
  8005e5:	e8 56 05 00 00       	call   800b40 <cprintf>
	close_all();
  8005ea:	e8 05 1a 00 00       	call   801ff4 <close_all>
  8005ef:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005f2:	85 db                	test   %ebx,%ebx
  8005f4:	0f 84 ed fe ff ff    	je     8004e7 <runcmd+0x2ed>
		if (debug)
  8005fa:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800601:	0f 84 c7 fe ff ff    	je     8004ce <runcmd+0x2d4>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800607:	a1 24 54 80 00       	mov    0x805424,%eax
  80060c:	8b 40 48             	mov    0x48(%eax),%eax
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	53                   	push   %ebx
  800613:	50                   	push   %eax
  800614:	68 d6 35 80 00       	push   $0x8035d6
  800619:	e8 22 05 00 00       	call   800b40 <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	e9 a8 fe ff ff       	jmp    8004ce <runcmd+0x2d4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800626:	a1 24 54 80 00       	mov    0x805424,%eax
  80062b:	8b 40 48             	mov    0x48(%eax),%eax
  80062e:	56                   	push   %esi
  80062f:	ff 75 a8             	pushl  -0x58(%ebp)
  800632:	50                   	push   %eax
  800633:	68 ab 35 80 00       	push   $0x8035ab
  800638:	e8 03 05 00 00       	call   800b40 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	e9 6c fe ff ff       	jmp    8004b1 <runcmd+0x2b7>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800645:	a1 24 54 80 00       	mov    0x805424,%eax
  80064a:	8b 40 48             	mov    0x48(%eax),%eax
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	50                   	push   %eax
  800651:	68 c0 35 80 00       	push   $0x8035c0
  800656:	e8 e5 04 00 00       	call   800b40 <cprintf>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	eb 92                	jmp    8005f2 <runcmd+0x3f8>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800660:	a1 24 54 80 00       	mov    0x805424,%eax
  800665:	8b 40 48             	mov    0x48(%eax),%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	50                   	push   %eax
  80066c:	68 c0 35 80 00       	push   $0x8035c0
  800671:	e8 ca 04 00 00       	call   800b40 <cprintf>
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	e9 69 fe ff ff       	jmp    8004e7 <runcmd+0x2ed>

0080067e <usage>:


void
usage(void)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800684:	68 a0 36 80 00       	push   $0x8036a0
  800689:	e8 b2 04 00 00       	call   800b40 <cprintf>
	exit();
  80068e:	e8 c0 03 00 00       	call   800a53 <exit>
}
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	c9                   	leave  
  800697:	c3                   	ret    

00800698 <umain>:

void
umain(int argc, char **argv)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	57                   	push   %edi
  80069c:	56                   	push   %esi
  80069d:	53                   	push   %ebx
  80069e:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006a1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006a4:	50                   	push   %eax
  8006a5:	ff 75 0c             	pushl  0xc(%ebp)
  8006a8:	8d 45 08             	lea    0x8(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	e8 23 16 00 00       	call   801cd4 <argstart>
	while ((r = argnext(&args)) >= 0)
  8006b1:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006b4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006bb:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006c0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006c3:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006c8:	eb 10                	jmp    8006da <umain+0x42>
			debug++;
  8006ca:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  8006d1:	eb 07                	jmp    8006da <umain+0x42>
			interactive = 1;
  8006d3:	89 f7                	mov    %esi,%edi
  8006d5:	eb 03                	jmp    8006da <umain+0x42>
			break;
		case 'x':
			echocmds = 1;
  8006d7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	53                   	push   %ebx
  8006de:	e8 21 16 00 00       	call   801d04 <argnext>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	78 16                	js     800700 <umain+0x68>
		switch (r) {
  8006ea:	83 f8 69             	cmp    $0x69,%eax
  8006ed:	74 e4                	je     8006d3 <umain+0x3b>
  8006ef:	83 f8 78             	cmp    $0x78,%eax
  8006f2:	74 e3                	je     8006d7 <umain+0x3f>
  8006f4:	83 f8 64             	cmp    $0x64,%eax
  8006f7:	74 d1                	je     8006ca <umain+0x32>
			break;
		default:
			usage();
  8006f9:	e8 80 ff ff ff       	call   80067e <usage>
  8006fe:	eb da                	jmp    8006da <umain+0x42>
		}

	if (argc > 2)
  800700:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800704:	7f 1f                	jg     800725 <umain+0x8d>
		usage();
	if (argc == 2) {
  800706:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80070a:	74 20                	je     80072c <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  80070c:	83 ff 3f             	cmp    $0x3f,%edi
  80070f:	74 75                	je     800786 <umain+0xee>
  800711:	85 ff                	test   %edi,%edi
  800713:	bf 1b 36 80 00       	mov    $0x80361b,%edi
  800718:	b8 00 00 00 00       	mov    $0x0,%eax
  80071d:	0f 44 f8             	cmove  %eax,%edi
  800720:	e9 06 01 00 00       	jmp    80082b <umain+0x193>
		usage();
  800725:	e8 54 ff ff ff       	call   80067e <usage>
  80072a:	eb da                	jmp    800706 <umain+0x6e>
		close(0);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	6a 00                	push   $0x0
  800731:	e8 91 18 00 00       	call   801fc7 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800736:	83 c4 08             	add    $0x8,%esp
  800739:	6a 00                	push   $0x0
  80073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073e:	ff 70 04             	pushl  0x4(%eax)
  800741:	e8 22 1e 00 00       	call   802568 <open>
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	85 c0                	test   %eax,%eax
  80074b:	78 1b                	js     800768 <umain+0xd0>
		assert(r == 0);
  80074d:	74 bd                	je     80070c <umain+0x74>
  80074f:	68 ff 35 80 00       	push   $0x8035ff
  800754:	68 06 36 80 00       	push   $0x803606
  800759:	68 29 01 00 00       	push   $0x129
  80075e:	68 76 35 80 00       	push   $0x803576
  800763:	e8 fd 02 00 00       	call   800a65 <_panic>
			panic("open %s: %e", argv[1], r);
  800768:	83 ec 0c             	sub    $0xc,%esp
  80076b:	50                   	push   %eax
  80076c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076f:	ff 70 04             	pushl  0x4(%eax)
  800772:	68 f3 35 80 00       	push   $0x8035f3
  800777:	68 28 01 00 00       	push   $0x128
  80077c:	68 76 35 80 00       	push   $0x803576
  800781:	e8 df 02 00 00       	call   800a65 <_panic>
		interactive = iscons(0);
  800786:	83 ec 0c             	sub    $0xc,%esp
  800789:	6a 00                	push   $0x0
  80078b:	e8 fc 01 00 00       	call   80098c <iscons>
  800790:	89 c7                	mov    %eax,%edi
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	e9 77 ff ff ff       	jmp    800711 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  80079a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007a1:	75 0a                	jne    8007ad <umain+0x115>
				cprintf("EXITING\n");
			exit();	// end of file
  8007a3:	e8 ab 02 00 00       	call   800a53 <exit>
  8007a8:	e9 94 00 00 00       	jmp    800841 <umain+0x1a9>
				cprintf("EXITING\n");
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	68 1e 36 80 00       	push   $0x80361e
  8007b5:	e8 86 03 00 00       	call   800b40 <cprintf>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	eb e4                	jmp    8007a3 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	68 27 36 80 00       	push   $0x803627
  8007c8:	e8 73 03 00 00       	call   800b40 <cprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	eb 7c                	jmp    80084e <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	53                   	push   %ebx
  8007d6:	68 31 36 80 00       	push   $0x803631
  8007db:	e8 2b 1f 00 00       	call   80270b <printf>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	eb 78                	jmp    80085d <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e5:	83 ec 0c             	sub    $0xc,%esp
  8007e8:	68 37 36 80 00       	push   $0x803637
  8007ed:	e8 4e 03 00 00       	call   800b40 <cprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	eb 73                	jmp    80086a <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007f7:	50                   	push   %eax
  8007f8:	68 90 3b 80 00       	push   $0x803b90
  8007fd:	68 40 01 00 00       	push   $0x140
  800802:	68 76 35 80 00       	push   $0x803576
  800807:	e8 59 02 00 00       	call   800a65 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	50                   	push   %eax
  800810:	68 44 36 80 00       	push   $0x803644
  800815:	e8 26 03 00 00       	call   800b40 <cprintf>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	eb 5f                	jmp    80087e <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  80081f:	83 ec 0c             	sub    $0xc,%esp
  800822:	56                   	push   %esi
  800823:	e8 34 28 00 00       	call   80305c <wait>
  800828:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80082b:	83 ec 0c             	sub    $0xc,%esp
  80082e:	57                   	push   %edi
  80082f:	e8 e1 09 00 00       	call   801215 <readline>
  800834:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	85 c0                	test   %eax,%eax
  80083b:	0f 84 59 ff ff ff    	je     80079a <umain+0x102>
		if (debug)
  800841:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800848:	0f 85 71 ff ff ff    	jne    8007bf <umain+0x127>
		if (buf[0] == '#')
  80084e:	80 3b 23             	cmpb   $0x23,(%ebx)
  800851:	74 d8                	je     80082b <umain+0x193>
		if (echocmds)
  800853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800857:	0f 85 75 ff ff ff    	jne    8007d2 <umain+0x13a>
		if (debug)
  80085d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800864:	0f 85 7b ff ff ff    	jne    8007e5 <umain+0x14d>
		if ((r = fork()) < 0)
  80086a:	e8 38 12 00 00       	call   801aa7 <fork>
  80086f:	89 c6                	mov    %eax,%esi
  800871:	85 c0                	test   %eax,%eax
  800873:	78 82                	js     8007f7 <umain+0x15f>
		if (debug)
  800875:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80087c:	75 8e                	jne    80080c <umain+0x174>
		if (r == 0) {
  80087e:	85 f6                	test   %esi,%esi
  800880:	75 9d                	jne    80081f <umain+0x187>
			runcmd(buf);
  800882:	83 ec 0c             	sub    $0xc,%esp
  800885:	53                   	push   %ebx
  800886:	e8 6f f9 ff ff       	call   8001fa <runcmd>
			exit();
  80088b:	e8 c3 01 00 00       	call   800a53 <exit>
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	eb 96                	jmp    80082b <umain+0x193>

00800895 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800895:	b8 00 00 00 00       	mov    $0x0,%eax
  80089a:	c3                   	ret    

0080089b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008a1:	68 c1 36 80 00       	push   $0x8036c1
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	e8 90 0a 00 00       	call   80133e <strcpy>
	return 0;
}
  8008ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <devcons_write>:
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	57                   	push   %edi
  8008b9:	56                   	push   %esi
  8008ba:	53                   	push   %ebx
  8008bb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008c1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008cc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008cf:	73 31                	jae    800902 <devcons_write+0x4d>
		m = n - tot;
  8008d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008d4:	29 f3                	sub    %esi,%ebx
  8008d6:	83 fb 7f             	cmp    $0x7f,%ebx
  8008d9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008de:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008e1:	83 ec 04             	sub    $0x4,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	89 f0                	mov    %esi,%eax
  8008e7:	03 45 0c             	add    0xc(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	57                   	push   %edi
  8008ec:	e8 db 0b 00 00       	call   8014cc <memmove>
		sys_cputs(buf, m);
  8008f1:	83 c4 08             	add    $0x8,%esp
  8008f4:	53                   	push   %ebx
  8008f5:	57                   	push   %edi
  8008f6:	e8 79 0d 00 00       	call   801674 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008fb:	01 de                	add    %ebx,%esi
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	eb ca                	jmp    8008cc <devcons_write+0x17>
}
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800907:	5b                   	pop    %ebx
  800908:	5e                   	pop    %esi
  800909:	5f                   	pop    %edi
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <devcons_read>:
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800917:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80091b:	74 21                	je     80093e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80091d:	e8 70 0d 00 00       	call   801692 <sys_cgetc>
  800922:	85 c0                	test   %eax,%eax
  800924:	75 07                	jne    80092d <devcons_read+0x21>
		sys_yield();
  800926:	e8 e6 0d 00 00       	call   801711 <sys_yield>
  80092b:	eb f0                	jmp    80091d <devcons_read+0x11>
	if (c < 0)
  80092d:	78 0f                	js     80093e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80092f:	83 f8 04             	cmp    $0x4,%eax
  800932:	74 0c                	je     800940 <devcons_read+0x34>
	*(char*)vbuf = c;
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	88 02                	mov    %al,(%edx)
	return 1;
  800939:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    
		return 0;
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
  800945:	eb f7                	jmp    80093e <devcons_read+0x32>

00800947 <cputchar>:
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800953:	6a 01                	push   $0x1
  800955:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800958:	50                   	push   %eax
  800959:	e8 16 0d 00 00       	call   801674 <sys_cputs>
}
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <getchar>:
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800969:	6a 01                	push   $0x1
  80096b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80096e:	50                   	push   %eax
  80096f:	6a 00                	push   $0x0
  800971:	e8 8f 17 00 00       	call   802105 <read>
	if (r < 0)
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	85 c0                	test   %eax,%eax
  80097b:	78 06                	js     800983 <getchar+0x20>
	if (r < 1)
  80097d:	74 06                	je     800985 <getchar+0x22>
	return c;
  80097f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800983:	c9                   	leave  
  800984:	c3                   	ret    
		return -E_EOF;
  800985:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80098a:	eb f7                	jmp    800983 <getchar+0x20>

0080098c <iscons>:
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800992:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800995:	50                   	push   %eax
  800996:	ff 75 08             	pushl  0x8(%ebp)
  800999:	e8 fc 14 00 00       	call   801e9a <fd_lookup>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	85 c0                	test   %eax,%eax
  8009a3:	78 11                	js     8009b6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8009a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a8:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009ae:	39 10                	cmp    %edx,(%eax)
  8009b0:	0f 94 c0             	sete   %al
  8009b3:	0f b6 c0             	movzbl %al,%eax
}
  8009b6:	c9                   	leave  
  8009b7:	c3                   	ret    

008009b8 <opencons>:
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c1:	50                   	push   %eax
  8009c2:	e8 81 14 00 00       	call   801e48 <fd_alloc>
  8009c7:	83 c4 10             	add    $0x10,%esp
  8009ca:	85 c0                	test   %eax,%eax
  8009cc:	78 3a                	js     800a08 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009ce:	83 ec 04             	sub    $0x4,%esp
  8009d1:	68 07 04 00 00       	push   $0x407
  8009d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d9:	6a 00                	push   $0x0
  8009db:	e8 50 0d 00 00       	call   801730 <sys_page_alloc>
  8009e0:	83 c4 10             	add    $0x10,%esp
  8009e3:	85 c0                	test   %eax,%eax
  8009e5:	78 21                	js     800a08 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ea:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009f0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009fc:	83 ec 0c             	sub    $0xc,%esp
  8009ff:	50                   	push   %eax
  800a00:	e8 1c 14 00 00       	call   801e21 <fd2num>
  800a05:	83 c4 10             	add    $0x10,%esp
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a12:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a15:	e8 d8 0c 00 00       	call   8016f2 <sys_getenvid>
  800a1a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a1f:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800a22:	c1 e0 04             	shl    $0x4,%eax
  800a25:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a2a:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	7e 07                	jle    800a3a <libmain+0x30>
		binaryname = argv[0];
  800a33:	8b 06                	mov    (%esi),%eax
  800a35:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	56                   	push   %esi
  800a3e:	53                   	push   %ebx
  800a3f:	e8 54 fc ff ff       	call   800698 <umain>

	// exit gracefully
	exit();
  800a44:	e8 0a 00 00 00       	call   800a53 <exit>
}
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4f:	5b                   	pop    %ebx
  800a50:	5e                   	pop    %esi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800a59:	6a 00                	push   $0x0
  800a5b:	e8 51 0c 00 00       	call   8016b1 <sys_env_destroy>
}
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	56                   	push   %esi
  800a69:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a6a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a6d:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a73:	e8 7a 0c 00 00       	call   8016f2 <sys_getenvid>
  800a78:	83 ec 0c             	sub    $0xc,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	ff 75 08             	pushl  0x8(%ebp)
  800a81:	56                   	push   %esi
  800a82:	50                   	push   %eax
  800a83:	68 d8 36 80 00       	push   $0x8036d8
  800a88:	e8 b3 00 00 00       	call   800b40 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a8d:	83 c4 18             	add    $0x18,%esp
  800a90:	53                   	push   %ebx
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	e8 56 00 00 00       	call   800aef <vcprintf>
	cprintf("\n");
  800a99:	c7 04 24 e0 34 80 00 	movl   $0x8034e0,(%esp)
  800aa0:	e8 9b 00 00 00       	call   800b40 <cprintf>
  800aa5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aa8:	cc                   	int3   
  800aa9:	eb fd                	jmp    800aa8 <_panic+0x43>

00800aab <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	53                   	push   %ebx
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ab5:	8b 13                	mov    (%ebx),%edx
  800ab7:	8d 42 01             	lea    0x1(%edx),%eax
  800aba:	89 03                	mov    %eax,(%ebx)
  800abc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ac3:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ac8:	74 09                	je     800ad3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800aca:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	68 ff 00 00 00       	push   $0xff
  800adb:	8d 43 08             	lea    0x8(%ebx),%eax
  800ade:	50                   	push   %eax
  800adf:	e8 90 0b 00 00       	call   801674 <sys_cputs>
		b->idx = 0;
  800ae4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800aea:	83 c4 10             	add    $0x10,%esp
  800aed:	eb db                	jmp    800aca <putch+0x1f>

00800aef <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800af8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aff:	00 00 00 
	b.cnt = 0;
  800b02:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b09:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	ff 75 08             	pushl  0x8(%ebp)
  800b12:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b18:	50                   	push   %eax
  800b19:	68 ab 0a 80 00       	push   $0x800aab
  800b1e:	e8 4a 01 00 00       	call   800c6d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b23:	83 c4 08             	add    $0x8,%esp
  800b26:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b2c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 3c 0b 00 00       	call   801674 <sys_cputs>

	return b.cnt;
}
  800b38:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b46:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b49:	50                   	push   %eax
  800b4a:	ff 75 08             	pushl  0x8(%ebp)
  800b4d:	e8 9d ff ff ff       	call   800aef <vcprintf>
	va_end(ap);

	return cnt;
}
  800b52:	c9                   	leave  
  800b53:	c3                   	ret    

00800b54 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	83 ec 1c             	sub    $0x1c,%esp
  800b5d:	89 c6                	mov    %eax,%esi
  800b5f:	89 d7                	mov    %edx,%edi
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b6a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b70:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800b73:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800b77:	74 2c                	je     800ba5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800b83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b86:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800b8e:	73 43                	jae    800bd3 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b90:	83 eb 01             	sub    $0x1,%ebx
  800b93:	85 db                	test   %ebx,%ebx
  800b95:	7e 6c                	jle    800c03 <printnum+0xaf>
			putch(padc, putdat);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	57                   	push   %edi
  800b9b:	ff 75 18             	pushl  0x18(%ebp)
  800b9e:	ff d6                	call   *%esi
  800ba0:	83 c4 10             	add    $0x10,%esp
  800ba3:	eb eb                	jmp    800b90 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800ba5:	83 ec 0c             	sub    $0xc,%esp
  800ba8:	6a 20                	push   $0x20
  800baa:	6a 00                	push   $0x0
  800bac:	50                   	push   %eax
  800bad:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb0:	ff 75 e0             	pushl  -0x20(%ebp)
  800bb3:	89 fa                	mov    %edi,%edx
  800bb5:	89 f0                	mov    %esi,%eax
  800bb7:	e8 98 ff ff ff       	call   800b54 <printnum>
		while (--width > 0)
  800bbc:	83 c4 20             	add    $0x20,%esp
  800bbf:	83 eb 01             	sub    $0x1,%ebx
  800bc2:	85 db                	test   %ebx,%ebx
  800bc4:	7e 65                	jle    800c2b <printnum+0xd7>
			putch(padc, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	57                   	push   %edi
  800bca:	6a 20                	push   $0x20
  800bcc:	ff d6                	call   *%esi
  800bce:	83 c4 10             	add    $0x10,%esp
  800bd1:	eb ec                	jmp    800bbf <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	ff 75 18             	pushl  0x18(%ebp)
  800bd9:	83 eb 01             	sub    $0x1,%ebx
  800bdc:	53                   	push   %ebx
  800bdd:	50                   	push   %eax
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 dc             	pushl  -0x24(%ebp)
  800be4:	ff 75 d8             	pushl  -0x28(%ebp)
  800be7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bea:	ff 75 e0             	pushl  -0x20(%ebp)
  800bed:	e8 7e 26 00 00       	call   803270 <__udivdi3>
  800bf2:	83 c4 18             	add    $0x18,%esp
  800bf5:	52                   	push   %edx
  800bf6:	50                   	push   %eax
  800bf7:	89 fa                	mov    %edi,%edx
  800bf9:	89 f0                	mov    %esi,%eax
  800bfb:	e8 54 ff ff ff       	call   800b54 <printnum>
  800c00:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	57                   	push   %edi
  800c07:	83 ec 04             	sub    $0x4,%esp
  800c0a:	ff 75 dc             	pushl  -0x24(%ebp)
  800c0d:	ff 75 d8             	pushl  -0x28(%ebp)
  800c10:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c13:	ff 75 e0             	pushl  -0x20(%ebp)
  800c16:	e8 65 27 00 00       	call   803380 <__umoddi3>
  800c1b:	83 c4 14             	add    $0x14,%esp
  800c1e:	0f be 80 fb 36 80 00 	movsbl 0x8036fb(%eax),%eax
  800c25:	50                   	push   %eax
  800c26:	ff d6                	call   *%esi
  800c28:	83 c4 10             	add    $0x10,%esp
}
  800c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c39:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c3d:	8b 10                	mov    (%eax),%edx
  800c3f:	3b 50 04             	cmp    0x4(%eax),%edx
  800c42:	73 0a                	jae    800c4e <sprintputch+0x1b>
		*b->buf++ = ch;
  800c44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c47:	89 08                	mov    %ecx,(%eax)
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	88 02                	mov    %al,(%edx)
}
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <printfmt>:
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c56:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c59:	50                   	push   %eax
  800c5a:	ff 75 10             	pushl  0x10(%ebp)
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	ff 75 08             	pushl  0x8(%ebp)
  800c63:	e8 05 00 00 00       	call   800c6d <vprintfmt>
}
  800c68:	83 c4 10             	add    $0x10,%esp
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <vprintfmt>:
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	83 ec 3c             	sub    $0x3c,%esp
  800c76:	8b 75 08             	mov    0x8(%ebp),%esi
  800c79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c7c:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c7f:	e9 b4 03 00 00       	jmp    801038 <vprintfmt+0x3cb>
		padc = ' ';
  800c84:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800c88:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800c8f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800c96:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800c9d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ca4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800ca9:	8d 47 01             	lea    0x1(%edi),%eax
  800cac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800caf:	0f b6 17             	movzbl (%edi),%edx
  800cb2:	8d 42 dd             	lea    -0x23(%edx),%eax
  800cb5:	3c 55                	cmp    $0x55,%al
  800cb7:	0f 87 c8 04 00 00    	ja     801185 <vprintfmt+0x518>
  800cbd:	0f b6 c0             	movzbl %al,%eax
  800cc0:	ff 24 85 e0 38 80 00 	jmp    *0x8038e0(,%eax,4)
  800cc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800cca:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  800cd1:	eb d6                	jmp    800ca9 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800cd3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800cd6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800cda:	eb cd                	jmp    800ca9 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800cdc:	0f b6 d2             	movzbl %dl,%edx
  800cdf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800cea:	eb 0c                	jmp    800cf8 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800cec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800cef:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800cf3:	eb b4                	jmp    800ca9 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800cf5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800cf8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800cfb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800cff:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d02:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800d05:	83 f9 09             	cmp    $0x9,%ecx
  800d08:	76 eb                	jbe    800cf5 <vprintfmt+0x88>
  800d0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d10:	eb 14                	jmp    800d26 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  800d12:	8b 45 14             	mov    0x14(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	8d 40 04             	lea    0x4(%eax),%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d23:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d2a:	0f 89 79 ff ff ff    	jns    800ca9 <vprintfmt+0x3c>
				width = precision, precision = -1;
  800d30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d33:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d36:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d3d:	e9 67 ff ff ff       	jmp    800ca9 <vprintfmt+0x3c>
  800d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d45:	85 c0                	test   %eax,%eax
  800d47:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4c:	0f 49 d0             	cmovns %eax,%edx
  800d4f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d52:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d55:	e9 4f ff ff ff       	jmp    800ca9 <vprintfmt+0x3c>
  800d5a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d5d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800d64:	e9 40 ff ff ff       	jmp    800ca9 <vprintfmt+0x3c>
			lflag++;
  800d69:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d6c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d6f:	e9 35 ff ff ff       	jmp    800ca9 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800d74:	8b 45 14             	mov    0x14(%ebp),%eax
  800d77:	8d 78 04             	lea    0x4(%eax),%edi
  800d7a:	83 ec 08             	sub    $0x8,%esp
  800d7d:	53                   	push   %ebx
  800d7e:	ff 30                	pushl  (%eax)
  800d80:	ff d6                	call   *%esi
			break;
  800d82:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d85:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d88:	e9 a8 02 00 00       	jmp    801035 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800d8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d90:	8d 78 04             	lea    0x4(%eax),%edi
  800d93:	8b 00                	mov    (%eax),%eax
  800d95:	99                   	cltd   
  800d96:	31 d0                	xor    %edx,%eax
  800d98:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d9a:	83 f8 0f             	cmp    $0xf,%eax
  800d9d:	7f 23                	jg     800dc2 <vprintfmt+0x155>
  800d9f:	8b 14 85 40 3a 80 00 	mov    0x803a40(,%eax,4),%edx
  800da6:	85 d2                	test   %edx,%edx
  800da8:	74 18                	je     800dc2 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800daa:	52                   	push   %edx
  800dab:	68 18 36 80 00       	push   $0x803618
  800db0:	53                   	push   %ebx
  800db1:	56                   	push   %esi
  800db2:	e8 99 fe ff ff       	call   800c50 <printfmt>
  800db7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dba:	89 7d 14             	mov    %edi,0x14(%ebp)
  800dbd:	e9 73 02 00 00       	jmp    801035 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800dc2:	50                   	push   %eax
  800dc3:	68 13 37 80 00       	push   $0x803713
  800dc8:	53                   	push   %ebx
  800dc9:	56                   	push   %esi
  800dca:	e8 81 fe ff ff       	call   800c50 <printfmt>
  800dcf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dd2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800dd5:	e9 5b 02 00 00       	jmp    801035 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800dda:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddd:	83 c0 04             	add    $0x4,%eax
  800de0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800de3:	8b 45 14             	mov    0x14(%ebp),%eax
  800de6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800de8:	85 d2                	test   %edx,%edx
  800dea:	b8 0c 37 80 00       	mov    $0x80370c,%eax
  800def:	0f 45 c2             	cmovne %edx,%eax
  800df2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800df5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df9:	7e 06                	jle    800e01 <vprintfmt+0x194>
  800dfb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800dff:	75 0d                	jne    800e0e <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e04:	89 c7                	mov    %eax,%edi
  800e06:	03 45 e0             	add    -0x20(%ebp),%eax
  800e09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e0c:	eb 53                	jmp    800e61 <vprintfmt+0x1f4>
  800e0e:	83 ec 08             	sub    $0x8,%esp
  800e11:	ff 75 d8             	pushl  -0x28(%ebp)
  800e14:	50                   	push   %eax
  800e15:	e8 03 05 00 00       	call   80131d <strnlen>
  800e1a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e1d:	29 c1                	sub    %eax,%ecx
  800e1f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800e27:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x1d2>
					putch(padc, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	53                   	push   %ebx
  800e34:	ff 75 e0             	pushl  -0x20(%ebp)
  800e37:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e39:	83 ef 01             	sub    $0x1,%edi
  800e3c:	83 c4 10             	add    $0x10,%esp
  800e3f:	85 ff                	test   %edi,%edi
  800e41:	7f ed                	jg     800e30 <vprintfmt+0x1c3>
  800e43:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800e46:	85 d2                	test   %edx,%edx
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	0f 49 c2             	cmovns %edx,%eax
  800e50:	29 c2                	sub    %eax,%edx
  800e52:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800e55:	eb aa                	jmp    800e01 <vprintfmt+0x194>
					putch(ch, putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	53                   	push   %ebx
  800e5b:	52                   	push   %edx
  800e5c:	ff d6                	call   *%esi
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e64:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e66:	83 c7 01             	add    $0x1,%edi
  800e69:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e6d:	0f be d0             	movsbl %al,%edx
  800e70:	85 d2                	test   %edx,%edx
  800e72:	74 4b                	je     800ebf <vprintfmt+0x252>
  800e74:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e78:	78 06                	js     800e80 <vprintfmt+0x213>
  800e7a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e7e:	78 1e                	js     800e9e <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800e80:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e84:	74 d1                	je     800e57 <vprintfmt+0x1ea>
  800e86:	0f be c0             	movsbl %al,%eax
  800e89:	83 e8 20             	sub    $0x20,%eax
  800e8c:	83 f8 5e             	cmp    $0x5e,%eax
  800e8f:	76 c6                	jbe    800e57 <vprintfmt+0x1ea>
					putch('?', putdat);
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	53                   	push   %ebx
  800e95:	6a 3f                	push   $0x3f
  800e97:	ff d6                	call   *%esi
  800e99:	83 c4 10             	add    $0x10,%esp
  800e9c:	eb c3                	jmp    800e61 <vprintfmt+0x1f4>
  800e9e:	89 cf                	mov    %ecx,%edi
  800ea0:	eb 0e                	jmp    800eb0 <vprintfmt+0x243>
				putch(' ', putdat);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	53                   	push   %ebx
  800ea6:	6a 20                	push   $0x20
  800ea8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800eaa:	83 ef 01             	sub    $0x1,%edi
  800ead:	83 c4 10             	add    $0x10,%esp
  800eb0:	85 ff                	test   %edi,%edi
  800eb2:	7f ee                	jg     800ea2 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800eb4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800eb7:	89 45 14             	mov    %eax,0x14(%ebp)
  800eba:	e9 76 01 00 00       	jmp    801035 <vprintfmt+0x3c8>
  800ebf:	89 cf                	mov    %ecx,%edi
  800ec1:	eb ed                	jmp    800eb0 <vprintfmt+0x243>
	if (lflag >= 2)
  800ec3:	83 f9 01             	cmp    $0x1,%ecx
  800ec6:	7f 1f                	jg     800ee7 <vprintfmt+0x27a>
	else if (lflag)
  800ec8:	85 c9                	test   %ecx,%ecx
  800eca:	74 6a                	je     800f36 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	8b 00                	mov    (%eax),%eax
  800ed1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ed4:	89 c1                	mov    %eax,%ecx
  800ed6:	c1 f9 1f             	sar    $0x1f,%ecx
  800ed9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800edc:	8b 45 14             	mov    0x14(%ebp),%eax
  800edf:	8d 40 04             	lea    0x4(%eax),%eax
  800ee2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee5:	eb 17                	jmp    800efe <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800ee7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eea:	8b 50 04             	mov    0x4(%eax),%edx
  800eed:	8b 00                	mov    (%eax),%eax
  800eef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ef2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ef5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef8:	8d 40 08             	lea    0x8(%eax),%eax
  800efb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800efe:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800f01:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800f06:	85 d2                	test   %edx,%edx
  800f08:	0f 89 f8 00 00 00    	jns    801006 <vprintfmt+0x399>
				putch('-', putdat);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	53                   	push   %ebx
  800f12:	6a 2d                	push   $0x2d
  800f14:	ff d6                	call   *%esi
				num = -(long long) num;
  800f16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f19:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800f1c:	f7 d8                	neg    %eax
  800f1e:	83 d2 00             	adc    $0x0,%edx
  800f21:	f7 da                	neg    %edx
  800f23:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f26:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f29:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f2c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800f31:	e9 e1 00 00 00       	jmp    801017 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800f36:	8b 45 14             	mov    0x14(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f3e:	99                   	cltd   
  800f3f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f42:	8b 45 14             	mov    0x14(%ebp),%eax
  800f45:	8d 40 04             	lea    0x4(%eax),%eax
  800f48:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4b:	eb b1                	jmp    800efe <vprintfmt+0x291>
	if (lflag >= 2)
  800f4d:	83 f9 01             	cmp    $0x1,%ecx
  800f50:	7f 27                	jg     800f79 <vprintfmt+0x30c>
	else if (lflag)
  800f52:	85 c9                	test   %ecx,%ecx
  800f54:	74 41                	je     800f97 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800f56:	8b 45 14             	mov    0x14(%ebp),%eax
  800f59:	8b 00                	mov    (%eax),%eax
  800f5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f60:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f63:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f66:	8b 45 14             	mov    0x14(%ebp),%eax
  800f69:	8d 40 04             	lea    0x4(%eax),%eax
  800f6c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f6f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800f74:	e9 8d 00 00 00       	jmp    801006 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800f79:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7c:	8b 50 04             	mov    0x4(%eax),%edx
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f84:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	8d 40 08             	lea    0x8(%eax),%eax
  800f8d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f90:	bf 0a 00 00 00       	mov    $0xa,%edi
  800f95:	eb 6f                	jmp    801006 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800f97:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9a:	8b 00                	mov    (%eax),%eax
  800f9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fa4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800faa:	8d 40 04             	lea    0x4(%eax),%eax
  800fad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fb0:	bf 0a 00 00 00       	mov    $0xa,%edi
  800fb5:	eb 4f                	jmp    801006 <vprintfmt+0x399>
	if (lflag >= 2)
  800fb7:	83 f9 01             	cmp    $0x1,%ecx
  800fba:	7f 23                	jg     800fdf <vprintfmt+0x372>
	else if (lflag)
  800fbc:	85 c9                	test   %ecx,%ecx
  800fbe:	0f 84 98 00 00 00    	je     80105c <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc7:	8b 00                	mov    (%eax),%eax
  800fc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800fce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fd1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd7:	8d 40 04             	lea    0x4(%eax),%eax
  800fda:	89 45 14             	mov    %eax,0x14(%ebp)
  800fdd:	eb 17                	jmp    800ff6 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800fdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe2:	8b 50 04             	mov    0x4(%eax),%edx
  800fe5:	8b 00                	mov    (%eax),%eax
  800fe7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fed:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff0:	8d 40 08             	lea    0x8(%eax),%eax
  800ff3:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	53                   	push   %ebx
  800ffa:	6a 30                	push   $0x30
  800ffc:	ff d6                	call   *%esi
			goto number;
  800ffe:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801001:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  801006:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80100a:	74 0b                	je     801017 <vprintfmt+0x3aa>
				putch('+', putdat);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	53                   	push   %ebx
  801010:	6a 2b                	push   $0x2b
  801012:	ff d6                	call   *%esi
  801014:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80101e:	50                   	push   %eax
  80101f:	ff 75 e0             	pushl  -0x20(%ebp)
  801022:	57                   	push   %edi
  801023:	ff 75 dc             	pushl  -0x24(%ebp)
  801026:	ff 75 d8             	pushl  -0x28(%ebp)
  801029:	89 da                	mov    %ebx,%edx
  80102b:	89 f0                	mov    %esi,%eax
  80102d:	e8 22 fb ff ff       	call   800b54 <printnum>
			break;
  801032:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  801035:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801038:	83 c7 01             	add    $0x1,%edi
  80103b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80103f:	83 f8 25             	cmp    $0x25,%eax
  801042:	0f 84 3c fc ff ff    	je     800c84 <vprintfmt+0x17>
			if (ch == '\0')
  801048:	85 c0                	test   %eax,%eax
  80104a:	0f 84 55 01 00 00    	je     8011a5 <vprintfmt+0x538>
			putch(ch, putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	53                   	push   %ebx
  801054:	50                   	push   %eax
  801055:	ff d6                	call   *%esi
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	eb dc                	jmp    801038 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80105c:	8b 45 14             	mov    0x14(%ebp),%eax
  80105f:	8b 00                	mov    (%eax),%eax
  801061:	ba 00 00 00 00       	mov    $0x0,%edx
  801066:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801069:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80106c:	8b 45 14             	mov    0x14(%ebp),%eax
  80106f:	8d 40 04             	lea    0x4(%eax),%eax
  801072:	89 45 14             	mov    %eax,0x14(%ebp)
  801075:	e9 7c ff ff ff       	jmp    800ff6 <vprintfmt+0x389>
			putch('0', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	53                   	push   %ebx
  80107e:	6a 30                	push   $0x30
  801080:	ff d6                	call   *%esi
			putch('x', putdat);
  801082:	83 c4 08             	add    $0x8,%esp
  801085:	53                   	push   %ebx
  801086:	6a 78                	push   $0x78
  801088:	ff d6                	call   *%esi
			num = (unsigned long long)
  80108a:	8b 45 14             	mov    0x14(%ebp),%eax
  80108d:	8b 00                	mov    (%eax),%eax
  80108f:	ba 00 00 00 00       	mov    $0x0,%edx
  801094:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801097:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80109a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8d 40 04             	lea    0x4(%eax),%eax
  8010a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010a6:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8010ab:	e9 56 ff ff ff       	jmp    801006 <vprintfmt+0x399>
	if (lflag >= 2)
  8010b0:	83 f9 01             	cmp    $0x1,%ecx
  8010b3:	7f 27                	jg     8010dc <vprintfmt+0x46f>
	else if (lflag)
  8010b5:	85 c9                	test   %ecx,%ecx
  8010b7:	74 44                	je     8010fd <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8010b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bc:	8b 00                	mov    (%eax),%eax
  8010be:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010cc:	8d 40 04             	lea    0x4(%eax),%eax
  8010cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010d2:	bf 10 00 00 00       	mov    $0x10,%edi
  8010d7:	e9 2a ff ff ff       	jmp    801006 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8010dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010df:	8b 50 04             	mov    0x4(%eax),%edx
  8010e2:	8b 00                	mov    (%eax),%eax
  8010e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ed:	8d 40 08             	lea    0x8(%eax),%eax
  8010f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010f3:	bf 10 00 00 00       	mov    $0x10,%edi
  8010f8:	e9 09 ff ff ff       	jmp    801006 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8010fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801100:	8b 00                	mov    (%eax),%eax
  801102:	ba 00 00 00 00       	mov    $0x0,%edx
  801107:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80110a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80110d:	8b 45 14             	mov    0x14(%ebp),%eax
  801110:	8d 40 04             	lea    0x4(%eax),%eax
  801113:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801116:	bf 10 00 00 00       	mov    $0x10,%edi
  80111b:	e9 e6 fe ff ff       	jmp    801006 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  801120:	8b 45 14             	mov    0x14(%ebp),%eax
  801123:	8d 78 04             	lea    0x4(%eax),%edi
  801126:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  801128:	85 c0                	test   %eax,%eax
  80112a:	74 2d                	je     801159 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80112c:	0f b6 13             	movzbl (%ebx),%edx
  80112f:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  801131:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  801134:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  801137:	0f 8e f8 fe ff ff    	jle    801035 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80113d:	68 68 38 80 00       	push   $0x803868
  801142:	68 18 36 80 00       	push   $0x803618
  801147:	53                   	push   %ebx
  801148:	56                   	push   %esi
  801149:	e8 02 fb ff ff       	call   800c50 <printfmt>
  80114e:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  801151:	89 7d 14             	mov    %edi,0x14(%ebp)
  801154:	e9 dc fe ff ff       	jmp    801035 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  801159:	68 30 38 80 00       	push   $0x803830
  80115e:	68 18 36 80 00       	push   $0x803618
  801163:	53                   	push   %ebx
  801164:	56                   	push   %esi
  801165:	e8 e6 fa ff ff       	call   800c50 <printfmt>
  80116a:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80116d:	89 7d 14             	mov    %edi,0x14(%ebp)
  801170:	e9 c0 fe ff ff       	jmp    801035 <vprintfmt+0x3c8>
			putch(ch, putdat);
  801175:	83 ec 08             	sub    $0x8,%esp
  801178:	53                   	push   %ebx
  801179:	6a 25                	push   $0x25
  80117b:	ff d6                	call   *%esi
			break;
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	e9 b0 fe ff ff       	jmp    801035 <vprintfmt+0x3c8>
			putch('%', putdat);
  801185:	83 ec 08             	sub    $0x8,%esp
  801188:	53                   	push   %ebx
  801189:	6a 25                	push   $0x25
  80118b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	89 f8                	mov    %edi,%eax
  801192:	eb 03                	jmp    801197 <vprintfmt+0x52a>
  801194:	83 e8 01             	sub    $0x1,%eax
  801197:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80119b:	75 f7                	jne    801194 <vprintfmt+0x527>
  80119d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011a0:	e9 90 fe ff ff       	jmp    801035 <vprintfmt+0x3c8>
}
  8011a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    

008011ad <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 18             	sub    $0x18,%esp
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011bc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8011c0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	74 26                	je     8011f4 <vsnprintf+0x47>
  8011ce:	85 d2                	test   %edx,%edx
  8011d0:	7e 22                	jle    8011f4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011d2:	ff 75 14             	pushl  0x14(%ebp)
  8011d5:	ff 75 10             	pushl  0x10(%ebp)
  8011d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011db:	50                   	push   %eax
  8011dc:	68 33 0c 80 00       	push   $0x800c33
  8011e1:	e8 87 fa ff ff       	call   800c6d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8011e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011e9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ef:	83 c4 10             	add    $0x10,%esp
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    
		return -E_INVAL;
  8011f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f9:	eb f7                	jmp    8011f2 <vsnprintf+0x45>

008011fb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801201:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801204:	50                   	push   %eax
  801205:	ff 75 10             	pushl  0x10(%ebp)
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	ff 75 08             	pushl  0x8(%ebp)
  80120e:	e8 9a ff ff ff       	call   8011ad <vsnprintf>
	va_end(ap);

	return rc;
}
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	57                   	push   %edi
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801221:	85 c0                	test   %eax,%eax
  801223:	74 13                	je     801238 <readline+0x23>
		fprintf(1, "%s", prompt);
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	50                   	push   %eax
  801229:	68 18 36 80 00       	push   $0x803618
  80122e:	6a 01                	push   $0x1
  801230:	e8 bf 14 00 00       	call   8026f4 <fprintf>
  801235:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  801238:	83 ec 0c             	sub    $0xc,%esp
  80123b:	6a 00                	push   $0x0
  80123d:	e8 4a f7 ff ff       	call   80098c <iscons>
  801242:	89 c7                	mov    %eax,%edi
  801244:	83 c4 10             	add    $0x10,%esp
	i = 0;
  801247:	be 00 00 00 00       	mov    $0x0,%esi
  80124c:	eb 57                	jmp    8012a5 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801253:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801256:	75 08                	jne    801260 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  801258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5f                   	pop    %edi
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801260:	83 ec 08             	sub    $0x8,%esp
  801263:	53                   	push   %ebx
  801264:	68 80 3a 80 00       	push   $0x803a80
  801269:	e8 d2 f8 ff ff       	call   800b40 <cprintf>
  80126e:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801271:	b8 00 00 00 00       	mov    $0x0,%eax
  801276:	eb e0                	jmp    801258 <readline+0x43>
			if (echoing)
  801278:	85 ff                	test   %edi,%edi
  80127a:	75 05                	jne    801281 <readline+0x6c>
			i--;
  80127c:	83 ee 01             	sub    $0x1,%esi
  80127f:	eb 24                	jmp    8012a5 <readline+0x90>
				cputchar('\b');
  801281:	83 ec 0c             	sub    $0xc,%esp
  801284:	6a 08                	push   $0x8
  801286:	e8 bc f6 ff ff       	call   800947 <cputchar>
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	eb ec                	jmp    80127c <readline+0x67>
				cputchar(c);
  801290:	83 ec 0c             	sub    $0xc,%esp
  801293:	53                   	push   %ebx
  801294:	e8 ae f6 ff ff       	call   800947 <cputchar>
  801299:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80129c:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  8012a2:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8012a5:	e8 b9 f6 ff ff       	call   800963 <getchar>
  8012aa:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	78 9e                	js     80124e <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8012b0:	83 f8 08             	cmp    $0x8,%eax
  8012b3:	0f 94 c2             	sete   %dl
  8012b6:	83 f8 7f             	cmp    $0x7f,%eax
  8012b9:	0f 94 c0             	sete   %al
  8012bc:	08 c2                	or     %al,%dl
  8012be:	74 04                	je     8012c4 <readline+0xaf>
  8012c0:	85 f6                	test   %esi,%esi
  8012c2:	7f b4                	jg     801278 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012c4:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c7:	7e 0e                	jle    8012d7 <readline+0xc2>
  8012c9:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8012cf:	7f 06                	jg     8012d7 <readline+0xc2>
			if (echoing)
  8012d1:	85 ff                	test   %edi,%edi
  8012d3:	74 c7                	je     80129c <readline+0x87>
  8012d5:	eb b9                	jmp    801290 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8012d7:	83 fb 0a             	cmp    $0xa,%ebx
  8012da:	74 05                	je     8012e1 <readline+0xcc>
  8012dc:	83 fb 0d             	cmp    $0xd,%ebx
  8012df:	75 c4                	jne    8012a5 <readline+0x90>
			if (echoing)
  8012e1:	85 ff                	test   %edi,%edi
  8012e3:	75 11                	jne    8012f6 <readline+0xe1>
			buf[i] = 0;
  8012e5:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  8012ec:	b8 20 50 80 00       	mov    $0x805020,%eax
  8012f1:	e9 62 ff ff ff       	jmp    801258 <readline+0x43>
				cputchar('\n');
  8012f6:	83 ec 0c             	sub    $0xc,%esp
  8012f9:	6a 0a                	push   $0xa
  8012fb:	e8 47 f6 ff ff       	call   800947 <cputchar>
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	eb e0                	jmp    8012e5 <readline+0xd0>

00801305 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
  801310:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801314:	74 05                	je     80131b <strlen+0x16>
		n++;
  801316:	83 c0 01             	add    $0x1,%eax
  801319:	eb f5                	jmp    801310 <strlen+0xb>
	return n;
}
  80131b:	5d                   	pop    %ebp
  80131c:	c3                   	ret    

0080131d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801326:	ba 00 00 00 00       	mov    $0x0,%edx
  80132b:	39 c2                	cmp    %eax,%edx
  80132d:	74 0d                	je     80133c <strnlen+0x1f>
  80132f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801333:	74 05                	je     80133a <strnlen+0x1d>
		n++;
  801335:	83 c2 01             	add    $0x1,%edx
  801338:	eb f1                	jmp    80132b <strnlen+0xe>
  80133a:	89 d0                	mov    %edx,%eax
	return n;
}
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	53                   	push   %ebx
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801348:	ba 00 00 00 00       	mov    $0x0,%edx
  80134d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801351:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801354:	83 c2 01             	add    $0x1,%edx
  801357:	84 c9                	test   %cl,%cl
  801359:	75 f2                	jne    80134d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80135b:	5b                   	pop    %ebx
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    

0080135e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	53                   	push   %ebx
  801362:	83 ec 10             	sub    $0x10,%esp
  801365:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801368:	53                   	push   %ebx
  801369:	e8 97 ff ff ff       	call   801305 <strlen>
  80136e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	01 d8                	add    %ebx,%eax
  801376:	50                   	push   %eax
  801377:	e8 c2 ff ff ff       	call   80133e <strcpy>
	return dst;
}
  80137c:	89 d8                	mov    %ebx,%eax
  80137e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	56                   	push   %esi
  801387:	53                   	push   %ebx
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80138e:	89 c6                	mov    %eax,%esi
  801390:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801393:	89 c2                	mov    %eax,%edx
  801395:	39 f2                	cmp    %esi,%edx
  801397:	74 11                	je     8013aa <strncpy+0x27>
		*dst++ = *src;
  801399:	83 c2 01             	add    $0x1,%edx
  80139c:	0f b6 19             	movzbl (%ecx),%ebx
  80139f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8013a2:	80 fb 01             	cmp    $0x1,%bl
  8013a5:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8013a8:	eb eb                	jmp    801395 <strncpy+0x12>
	}
	return ret;
}
  8013aa:	5b                   	pop    %ebx
  8013ab:	5e                   	pop    %esi
  8013ac:	5d                   	pop    %ebp
  8013ad:	c3                   	ret    

008013ae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	56                   	push   %esi
  8013b2:	53                   	push   %ebx
  8013b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8013b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b9:	8b 55 10             	mov    0x10(%ebp),%edx
  8013bc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8013be:	85 d2                	test   %edx,%edx
  8013c0:	74 21                	je     8013e3 <strlcpy+0x35>
  8013c2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8013c6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8013c8:	39 c2                	cmp    %eax,%edx
  8013ca:	74 14                	je     8013e0 <strlcpy+0x32>
  8013cc:	0f b6 19             	movzbl (%ecx),%ebx
  8013cf:	84 db                	test   %bl,%bl
  8013d1:	74 0b                	je     8013de <strlcpy+0x30>
			*dst++ = *src++;
  8013d3:	83 c1 01             	add    $0x1,%ecx
  8013d6:	83 c2 01             	add    $0x1,%edx
  8013d9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8013dc:	eb ea                	jmp    8013c8 <strlcpy+0x1a>
  8013de:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8013e0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013e3:	29 f0                	sub    %esi,%eax
}
  8013e5:	5b                   	pop    %ebx
  8013e6:	5e                   	pop    %esi
  8013e7:	5d                   	pop    %ebp
  8013e8:	c3                   	ret    

008013e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8013f2:	0f b6 01             	movzbl (%ecx),%eax
  8013f5:	84 c0                	test   %al,%al
  8013f7:	74 0c                	je     801405 <strcmp+0x1c>
  8013f9:	3a 02                	cmp    (%edx),%al
  8013fb:	75 08                	jne    801405 <strcmp+0x1c>
		p++, q++;
  8013fd:	83 c1 01             	add    $0x1,%ecx
  801400:	83 c2 01             	add    $0x1,%edx
  801403:	eb ed                	jmp    8013f2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801405:	0f b6 c0             	movzbl %al,%eax
  801408:	0f b6 12             	movzbl (%edx),%edx
  80140b:	29 d0                	sub    %edx,%eax
}
  80140d:	5d                   	pop    %ebp
  80140e:	c3                   	ret    

0080140f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	53                   	push   %ebx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8b 55 0c             	mov    0xc(%ebp),%edx
  801419:	89 c3                	mov    %eax,%ebx
  80141b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80141e:	eb 06                	jmp    801426 <strncmp+0x17>
		n--, p++, q++;
  801420:	83 c0 01             	add    $0x1,%eax
  801423:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801426:	39 d8                	cmp    %ebx,%eax
  801428:	74 16                	je     801440 <strncmp+0x31>
  80142a:	0f b6 08             	movzbl (%eax),%ecx
  80142d:	84 c9                	test   %cl,%cl
  80142f:	74 04                	je     801435 <strncmp+0x26>
  801431:	3a 0a                	cmp    (%edx),%cl
  801433:	74 eb                	je     801420 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801435:	0f b6 00             	movzbl (%eax),%eax
  801438:	0f b6 12             	movzbl (%edx),%edx
  80143b:	29 d0                	sub    %edx,%eax
}
  80143d:	5b                   	pop    %ebx
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    
		return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
  801445:	eb f6                	jmp    80143d <strncmp+0x2e>

00801447 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801451:	0f b6 10             	movzbl (%eax),%edx
  801454:	84 d2                	test   %dl,%dl
  801456:	74 09                	je     801461 <strchr+0x1a>
		if (*s == c)
  801458:	38 ca                	cmp    %cl,%dl
  80145a:	74 0a                	je     801466 <strchr+0x1f>
	for (; *s; s++)
  80145c:	83 c0 01             	add    $0x1,%eax
  80145f:	eb f0                	jmp    801451 <strchr+0xa>
			return (char *) s;
	return 0;
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    

00801468 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801472:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801475:	38 ca                	cmp    %cl,%dl
  801477:	74 09                	je     801482 <strfind+0x1a>
  801479:	84 d2                	test   %dl,%dl
  80147b:	74 05                	je     801482 <strfind+0x1a>
	for (; *s; s++)
  80147d:	83 c0 01             	add    $0x1,%eax
  801480:	eb f0                	jmp    801472 <strfind+0xa>
			break;
	return (char *) s;
}
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80148d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801490:	85 c9                	test   %ecx,%ecx
  801492:	74 31                	je     8014c5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801494:	89 f8                	mov    %edi,%eax
  801496:	09 c8                	or     %ecx,%eax
  801498:	a8 03                	test   $0x3,%al
  80149a:	75 23                	jne    8014bf <memset+0x3b>
		c &= 0xFF;
  80149c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014a0:	89 d3                	mov    %edx,%ebx
  8014a2:	c1 e3 08             	shl    $0x8,%ebx
  8014a5:	89 d0                	mov    %edx,%eax
  8014a7:	c1 e0 18             	shl    $0x18,%eax
  8014aa:	89 d6                	mov    %edx,%esi
  8014ac:	c1 e6 10             	shl    $0x10,%esi
  8014af:	09 f0                	or     %esi,%eax
  8014b1:	09 c2                	or     %eax,%edx
  8014b3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8014b5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8014b8:	89 d0                	mov    %edx,%eax
  8014ba:	fc                   	cld    
  8014bb:	f3 ab                	rep stos %eax,%es:(%edi)
  8014bd:	eb 06                	jmp    8014c5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c2:	fc                   	cld    
  8014c3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8014c5:	89 f8                	mov    %edi,%eax
  8014c7:	5b                   	pop    %ebx
  8014c8:	5e                   	pop    %esi
  8014c9:	5f                   	pop    %edi
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	57                   	push   %edi
  8014d0:	56                   	push   %esi
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014da:	39 c6                	cmp    %eax,%esi
  8014dc:	73 32                	jae    801510 <memmove+0x44>
  8014de:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8014e1:	39 c2                	cmp    %eax,%edx
  8014e3:	76 2b                	jbe    801510 <memmove+0x44>
		s += n;
		d += n;
  8014e5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014e8:	89 fe                	mov    %edi,%esi
  8014ea:	09 ce                	or     %ecx,%esi
  8014ec:	09 d6                	or     %edx,%esi
  8014ee:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8014f4:	75 0e                	jne    801504 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014f6:	83 ef 04             	sub    $0x4,%edi
  8014f9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8014fc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8014ff:	fd                   	std    
  801500:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801502:	eb 09                	jmp    80150d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801504:	83 ef 01             	sub    $0x1,%edi
  801507:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80150a:	fd                   	std    
  80150b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80150d:	fc                   	cld    
  80150e:	eb 1a                	jmp    80152a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801510:	89 c2                	mov    %eax,%edx
  801512:	09 ca                	or     %ecx,%edx
  801514:	09 f2                	or     %esi,%edx
  801516:	f6 c2 03             	test   $0x3,%dl
  801519:	75 0a                	jne    801525 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80151b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80151e:	89 c7                	mov    %eax,%edi
  801520:	fc                   	cld    
  801521:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801523:	eb 05                	jmp    80152a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801525:	89 c7                	mov    %eax,%edi
  801527:	fc                   	cld    
  801528:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80152a:	5e                   	pop    %esi
  80152b:	5f                   	pop    %edi
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    

0080152e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801534:	ff 75 10             	pushl  0x10(%ebp)
  801537:	ff 75 0c             	pushl  0xc(%ebp)
  80153a:	ff 75 08             	pushl  0x8(%ebp)
  80153d:	e8 8a ff ff ff       	call   8014cc <memmove>
}
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	56                   	push   %esi
  801548:	53                   	push   %ebx
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154f:	89 c6                	mov    %eax,%esi
  801551:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801554:	39 f0                	cmp    %esi,%eax
  801556:	74 1c                	je     801574 <memcmp+0x30>
		if (*s1 != *s2)
  801558:	0f b6 08             	movzbl (%eax),%ecx
  80155b:	0f b6 1a             	movzbl (%edx),%ebx
  80155e:	38 d9                	cmp    %bl,%cl
  801560:	75 08                	jne    80156a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801562:	83 c0 01             	add    $0x1,%eax
  801565:	83 c2 01             	add    $0x1,%edx
  801568:	eb ea                	jmp    801554 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80156a:	0f b6 c1             	movzbl %cl,%eax
  80156d:	0f b6 db             	movzbl %bl,%ebx
  801570:	29 d8                	sub    %ebx,%eax
  801572:	eb 05                	jmp    801579 <memcmp+0x35>
	}

	return 0;
  801574:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801579:	5b                   	pop    %ebx
  80157a:	5e                   	pop    %esi
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801586:	89 c2                	mov    %eax,%edx
  801588:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80158b:	39 d0                	cmp    %edx,%eax
  80158d:	73 09                	jae    801598 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80158f:	38 08                	cmp    %cl,(%eax)
  801591:	74 05                	je     801598 <memfind+0x1b>
	for (; s < ends; s++)
  801593:	83 c0 01             	add    $0x1,%eax
  801596:	eb f3                	jmp    80158b <memfind+0xe>
			break;
	return (void *) s;
}
  801598:	5d                   	pop    %ebp
  801599:	c3                   	ret    

0080159a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	57                   	push   %edi
  80159e:	56                   	push   %esi
  80159f:	53                   	push   %ebx
  8015a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a6:	eb 03                	jmp    8015ab <strtol+0x11>
		s++;
  8015a8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8015ab:	0f b6 01             	movzbl (%ecx),%eax
  8015ae:	3c 20                	cmp    $0x20,%al
  8015b0:	74 f6                	je     8015a8 <strtol+0xe>
  8015b2:	3c 09                	cmp    $0x9,%al
  8015b4:	74 f2                	je     8015a8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8015b6:	3c 2b                	cmp    $0x2b,%al
  8015b8:	74 2a                	je     8015e4 <strtol+0x4a>
	int neg = 0;
  8015ba:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8015bf:	3c 2d                	cmp    $0x2d,%al
  8015c1:	74 2b                	je     8015ee <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015c3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8015c9:	75 0f                	jne    8015da <strtol+0x40>
  8015cb:	80 39 30             	cmpb   $0x30,(%ecx)
  8015ce:	74 28                	je     8015f8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8015d0:	85 db                	test   %ebx,%ebx
  8015d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015d7:	0f 44 d8             	cmove  %eax,%ebx
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
  8015df:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8015e2:	eb 50                	jmp    801634 <strtol+0x9a>
		s++;
  8015e4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8015e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8015ec:	eb d5                	jmp    8015c3 <strtol+0x29>
		s++, neg = 1;
  8015ee:	83 c1 01             	add    $0x1,%ecx
  8015f1:	bf 01 00 00 00       	mov    $0x1,%edi
  8015f6:	eb cb                	jmp    8015c3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015f8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8015fc:	74 0e                	je     80160c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8015fe:	85 db                	test   %ebx,%ebx
  801600:	75 d8                	jne    8015da <strtol+0x40>
		s++, base = 8;
  801602:	83 c1 01             	add    $0x1,%ecx
  801605:	bb 08 00 00 00       	mov    $0x8,%ebx
  80160a:	eb ce                	jmp    8015da <strtol+0x40>
		s += 2, base = 16;
  80160c:	83 c1 02             	add    $0x2,%ecx
  80160f:	bb 10 00 00 00       	mov    $0x10,%ebx
  801614:	eb c4                	jmp    8015da <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801616:	8d 72 9f             	lea    -0x61(%edx),%esi
  801619:	89 f3                	mov    %esi,%ebx
  80161b:	80 fb 19             	cmp    $0x19,%bl
  80161e:	77 29                	ja     801649 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801620:	0f be d2             	movsbl %dl,%edx
  801623:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801626:	3b 55 10             	cmp    0x10(%ebp),%edx
  801629:	7d 30                	jge    80165b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80162b:	83 c1 01             	add    $0x1,%ecx
  80162e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801632:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801634:	0f b6 11             	movzbl (%ecx),%edx
  801637:	8d 72 d0             	lea    -0x30(%edx),%esi
  80163a:	89 f3                	mov    %esi,%ebx
  80163c:	80 fb 09             	cmp    $0x9,%bl
  80163f:	77 d5                	ja     801616 <strtol+0x7c>
			dig = *s - '0';
  801641:	0f be d2             	movsbl %dl,%edx
  801644:	83 ea 30             	sub    $0x30,%edx
  801647:	eb dd                	jmp    801626 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801649:	8d 72 bf             	lea    -0x41(%edx),%esi
  80164c:	89 f3                	mov    %esi,%ebx
  80164e:	80 fb 19             	cmp    $0x19,%bl
  801651:	77 08                	ja     80165b <strtol+0xc1>
			dig = *s - 'A' + 10;
  801653:	0f be d2             	movsbl %dl,%edx
  801656:	83 ea 37             	sub    $0x37,%edx
  801659:	eb cb                	jmp    801626 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80165b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80165f:	74 05                	je     801666 <strtol+0xcc>
		*endptr = (char *) s;
  801661:	8b 75 0c             	mov    0xc(%ebp),%esi
  801664:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801666:	89 c2                	mov    %eax,%edx
  801668:	f7 da                	neg    %edx
  80166a:	85 ff                	test   %edi,%edi
  80166c:	0f 45 c2             	cmovne %edx,%eax
}
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5f                   	pop    %edi
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    

00801674 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	57                   	push   %edi
  801678:	56                   	push   %esi
  801679:	53                   	push   %ebx
	asm volatile("int %1\n"
  80167a:	b8 00 00 00 00       	mov    $0x0,%eax
  80167f:	8b 55 08             	mov    0x8(%ebp),%edx
  801682:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801685:	89 c3                	mov    %eax,%ebx
  801687:	89 c7                	mov    %eax,%edi
  801689:	89 c6                	mov    %eax,%esi
  80168b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80168d:	5b                   	pop    %ebx
  80168e:	5e                   	pop    %esi
  80168f:	5f                   	pop    %edi
  801690:	5d                   	pop    %ebp
  801691:	c3                   	ret    

00801692 <sys_cgetc>:

int
sys_cgetc(void)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	57                   	push   %edi
  801696:	56                   	push   %esi
  801697:	53                   	push   %ebx
	asm volatile("int %1\n"
  801698:	ba 00 00 00 00       	mov    $0x0,%edx
  80169d:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a2:	89 d1                	mov    %edx,%ecx
  8016a4:	89 d3                	mov    %edx,%ebx
  8016a6:	89 d7                	mov    %edx,%edi
  8016a8:	89 d6                	mov    %edx,%esi
  8016aa:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8016ac:	5b                   	pop    %ebx
  8016ad:	5e                   	pop    %esi
  8016ae:	5f                   	pop    %edi
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    

008016b1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	57                   	push   %edi
  8016b5:	56                   	push   %esi
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c2:	b8 03 00 00 00       	mov    $0x3,%eax
  8016c7:	89 cb                	mov    %ecx,%ebx
  8016c9:	89 cf                	mov    %ecx,%edi
  8016cb:	89 ce                	mov    %ecx,%esi
  8016cd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	7f 08                	jg     8016db <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8016d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d6:	5b                   	pop    %ebx
  8016d7:	5e                   	pop    %esi
  8016d8:	5f                   	pop    %edi
  8016d9:	5d                   	pop    %ebp
  8016da:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016db:	83 ec 0c             	sub    $0xc,%esp
  8016de:	50                   	push   %eax
  8016df:	6a 03                	push   $0x3
  8016e1:	68 90 3a 80 00       	push   $0x803a90
  8016e6:	6a 33                	push   $0x33
  8016e8:	68 ad 3a 80 00       	push   $0x803aad
  8016ed:	e8 73 f3 ff ff       	call   800a65 <_panic>

008016f2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	57                   	push   %edi
  8016f6:	56                   	push   %esi
  8016f7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fd:	b8 02 00 00 00       	mov    $0x2,%eax
  801702:	89 d1                	mov    %edx,%ecx
  801704:	89 d3                	mov    %edx,%ebx
  801706:	89 d7                	mov    %edx,%edi
  801708:	89 d6                	mov    %edx,%esi
  80170a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80170c:	5b                   	pop    %ebx
  80170d:	5e                   	pop    %esi
  80170e:	5f                   	pop    %edi
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    

00801711 <sys_yield>:

void
sys_yield(void)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	57                   	push   %edi
  801715:	56                   	push   %esi
  801716:	53                   	push   %ebx
	asm volatile("int %1\n"
  801717:	ba 00 00 00 00       	mov    $0x0,%edx
  80171c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801721:	89 d1                	mov    %edx,%ecx
  801723:	89 d3                	mov    %edx,%ebx
  801725:	89 d7                	mov    %edx,%edi
  801727:	89 d6                	mov    %edx,%esi
  801729:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80172b:	5b                   	pop    %ebx
  80172c:	5e                   	pop    %esi
  80172d:	5f                   	pop    %edi
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	57                   	push   %edi
  801734:	56                   	push   %esi
  801735:	53                   	push   %ebx
  801736:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801739:	be 00 00 00 00       	mov    $0x0,%esi
  80173e:	8b 55 08             	mov    0x8(%ebp),%edx
  801741:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801744:	b8 04 00 00 00       	mov    $0x4,%eax
  801749:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80174c:	89 f7                	mov    %esi,%edi
  80174e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801750:	85 c0                	test   %eax,%eax
  801752:	7f 08                	jg     80175c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801754:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801757:	5b                   	pop    %ebx
  801758:	5e                   	pop    %esi
  801759:	5f                   	pop    %edi
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80175c:	83 ec 0c             	sub    $0xc,%esp
  80175f:	50                   	push   %eax
  801760:	6a 04                	push   $0x4
  801762:	68 90 3a 80 00       	push   $0x803a90
  801767:	6a 33                	push   $0x33
  801769:	68 ad 3a 80 00       	push   $0x803aad
  80176e:	e8 f2 f2 ff ff       	call   800a65 <_panic>

00801773 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	57                   	push   %edi
  801777:	56                   	push   %esi
  801778:	53                   	push   %ebx
  801779:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80177c:	8b 55 08             	mov    0x8(%ebp),%edx
  80177f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801782:	b8 05 00 00 00       	mov    $0x5,%eax
  801787:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80178a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80178d:	8b 75 18             	mov    0x18(%ebp),%esi
  801790:	cd 30                	int    $0x30
	if(check && ret > 0)
  801792:	85 c0                	test   %eax,%eax
  801794:	7f 08                	jg     80179e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801796:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5f                   	pop    %edi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80179e:	83 ec 0c             	sub    $0xc,%esp
  8017a1:	50                   	push   %eax
  8017a2:	6a 05                	push   $0x5
  8017a4:	68 90 3a 80 00       	push   $0x803a90
  8017a9:	6a 33                	push   $0x33
  8017ab:	68 ad 3a 80 00       	push   $0x803aad
  8017b0:	e8 b0 f2 ff ff       	call   800a65 <_panic>

008017b5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	57                   	push   %edi
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ce:	89 df                	mov    %ebx,%edi
  8017d0:	89 de                	mov    %ebx,%esi
  8017d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	7f 08                	jg     8017e0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8017d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	50                   	push   %eax
  8017e4:	6a 06                	push   $0x6
  8017e6:	68 90 3a 80 00       	push   $0x803a90
  8017eb:	6a 33                	push   $0x33
  8017ed:	68 ad 3a 80 00       	push   $0x803aad
  8017f2:	e8 6e f2 ff ff       	call   800a65 <_panic>

008017f7 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	57                   	push   %edi
  8017fb:	56                   	push   %esi
  8017fc:	53                   	push   %ebx
  8017fd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801800:	b9 00 00 00 00       	mov    $0x0,%ecx
  801805:	8b 55 08             	mov    0x8(%ebp),%edx
  801808:	b8 0b 00 00 00       	mov    $0xb,%eax
  80180d:	89 cb                	mov    %ecx,%ebx
  80180f:	89 cf                	mov    %ecx,%edi
  801811:	89 ce                	mov    %ecx,%esi
  801813:	cd 30                	int    $0x30
	if(check && ret > 0)
  801815:	85 c0                	test   %eax,%eax
  801817:	7f 08                	jg     801821 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  801819:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181c:	5b                   	pop    %ebx
  80181d:	5e                   	pop    %esi
  80181e:	5f                   	pop    %edi
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	50                   	push   %eax
  801825:	6a 0b                	push   $0xb
  801827:	68 90 3a 80 00       	push   $0x803a90
  80182c:	6a 33                	push   $0x33
  80182e:	68 ad 3a 80 00       	push   $0x803aad
  801833:	e8 2d f2 ff ff       	call   800a65 <_panic>

00801838 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	57                   	push   %edi
  80183c:	56                   	push   %esi
  80183d:	53                   	push   %ebx
  80183e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801841:	bb 00 00 00 00       	mov    $0x0,%ebx
  801846:	8b 55 08             	mov    0x8(%ebp),%edx
  801849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80184c:	b8 08 00 00 00       	mov    $0x8,%eax
  801851:	89 df                	mov    %ebx,%edi
  801853:	89 de                	mov    %ebx,%esi
  801855:	cd 30                	int    $0x30
	if(check && ret > 0)
  801857:	85 c0                	test   %eax,%eax
  801859:	7f 08                	jg     801863 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80185b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80185e:	5b                   	pop    %ebx
  80185f:	5e                   	pop    %esi
  801860:	5f                   	pop    %edi
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	50                   	push   %eax
  801867:	6a 08                	push   $0x8
  801869:	68 90 3a 80 00       	push   $0x803a90
  80186e:	6a 33                	push   $0x33
  801870:	68 ad 3a 80 00       	push   $0x803aad
  801875:	e8 eb f1 ff ff       	call   800a65 <_panic>

0080187a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	57                   	push   %edi
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
  801880:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801883:	bb 00 00 00 00       	mov    $0x0,%ebx
  801888:	8b 55 08             	mov    0x8(%ebp),%edx
  80188b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188e:	b8 09 00 00 00       	mov    $0x9,%eax
  801893:	89 df                	mov    %ebx,%edi
  801895:	89 de                	mov    %ebx,%esi
  801897:	cd 30                	int    $0x30
	if(check && ret > 0)
  801899:	85 c0                	test   %eax,%eax
  80189b:	7f 08                	jg     8018a5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80189d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a0:	5b                   	pop    %ebx
  8018a1:	5e                   	pop    %esi
  8018a2:	5f                   	pop    %edi
  8018a3:	5d                   	pop    %ebp
  8018a4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018a5:	83 ec 0c             	sub    $0xc,%esp
  8018a8:	50                   	push   %eax
  8018a9:	6a 09                	push   $0x9
  8018ab:	68 90 3a 80 00       	push   $0x803a90
  8018b0:	6a 33                	push   $0x33
  8018b2:	68 ad 3a 80 00       	push   $0x803aad
  8018b7:	e8 a9 f1 ff ff       	call   800a65 <_panic>

008018bc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	57                   	push   %edi
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8018d5:	89 df                	mov    %ebx,%edi
  8018d7:	89 de                	mov    %ebx,%esi
  8018d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	7f 08                	jg     8018e7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8018df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5f                   	pop    %edi
  8018e5:	5d                   	pop    %ebp
  8018e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e7:	83 ec 0c             	sub    $0xc,%esp
  8018ea:	50                   	push   %eax
  8018eb:	6a 0a                	push   $0xa
  8018ed:	68 90 3a 80 00       	push   $0x803a90
  8018f2:	6a 33                	push   $0x33
  8018f4:	68 ad 3a 80 00       	push   $0x803aad
  8018f9:	e8 67 f1 ff ff       	call   800a65 <_panic>

008018fe <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	57                   	push   %edi
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
	asm volatile("int %1\n"
  801904:	8b 55 08             	mov    0x8(%ebp),%edx
  801907:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80190a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80190f:	be 00 00 00 00       	mov    $0x0,%esi
  801914:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801917:	8b 7d 14             	mov    0x14(%ebp),%edi
  80191a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80191c:	5b                   	pop    %ebx
  80191d:	5e                   	pop    %esi
  80191e:	5f                   	pop    %edi
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    

00801921 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	57                   	push   %edi
  801925:	56                   	push   %esi
  801926:	53                   	push   %ebx
  801927:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80192a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192f:	8b 55 08             	mov    0x8(%ebp),%edx
  801932:	b8 0e 00 00 00       	mov    $0xe,%eax
  801937:	89 cb                	mov    %ecx,%ebx
  801939:	89 cf                	mov    %ecx,%edi
  80193b:	89 ce                	mov    %ecx,%esi
  80193d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80193f:	85 c0                	test   %eax,%eax
  801941:	7f 08                	jg     80194b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801943:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801946:	5b                   	pop    %ebx
  801947:	5e                   	pop    %esi
  801948:	5f                   	pop    %edi
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	50                   	push   %eax
  80194f:	6a 0e                	push   $0xe
  801951:	68 90 3a 80 00       	push   $0x803a90
  801956:	6a 33                	push   $0x33
  801958:	68 ad 3a 80 00       	push   $0x803aad
  80195d:	e8 03 f1 ff ff       	call   800a65 <_panic>

00801962 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	57                   	push   %edi
  801966:	56                   	push   %esi
  801967:	53                   	push   %ebx
	asm volatile("int %1\n"
  801968:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196d:	8b 55 08             	mov    0x8(%ebp),%edx
  801970:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801973:	b8 0f 00 00 00       	mov    $0xf,%eax
  801978:	89 df                	mov    %ebx,%edi
  80197a:	89 de                	mov    %ebx,%esi
  80197c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80197e:	5b                   	pop    %ebx
  80197f:	5e                   	pop    %esi
  801980:	5f                   	pop    %edi
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    

00801983 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	57                   	push   %edi
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
	asm volatile("int %1\n"
  801989:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198e:	8b 55 08             	mov    0x8(%ebp),%edx
  801991:	b8 10 00 00 00       	mov    $0x10,%eax
  801996:	89 cb                	mov    %ecx,%ebx
  801998:	89 cf                	mov    %ecx,%edi
  80199a:	89 ce                	mov    %ecx,%esi
  80199c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5f                   	pop    %edi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	53                   	push   %ebx
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8019ad:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR))
  8019af:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8019b3:	0f 84 90 00 00 00    	je     801a49 <pgfault+0xa6>
		panic("pgfault: faulting access was not a write\n");

	if(!((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & (PTE_P|PTE_COW))))
  8019b9:	89 d8                	mov    %ebx,%eax
  8019bb:	c1 e8 16             	shr    $0x16,%eax
  8019be:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019c5:	a8 01                	test   $0x1,%al
  8019c7:	0f 84 90 00 00 00    	je     801a5d <pgfault+0xba>
  8019cd:	89 d8                	mov    %ebx,%eax
  8019cf:	c1 e8 0c             	shr    $0xc,%eax
  8019d2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019d9:	a9 01 08 00 00       	test   $0x801,%eax
  8019de:	74 7d                	je     801a5d <pgfault+0xba>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	6a 07                	push   $0x7
  8019e5:	68 00 f0 7f 00       	push   $0x7ff000
  8019ea:	6a 00                	push   $0x0
  8019ec:	e8 3f fd ff ff       	call   801730 <sys_page_alloc>
  8019f1:	83 c4 10             	add    $0x10,%esp
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 79                	js     801a71 <pgfault+0xce>
		panic("sys_page_alloc: %e\n", r);

	addr = ROUNDDOWN(addr, PGSIZE);
  8019f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr, PGSIZE);
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	68 00 10 00 00       	push   $0x1000
  801a06:	53                   	push   %ebx
  801a07:	68 00 f0 7f 00       	push   $0x7ff000
  801a0c:	e8 bb fa ff ff       	call   8014cc <memmove>

	if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  801a11:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801a18:	53                   	push   %ebx
  801a19:	6a 00                	push   $0x0
  801a1b:	68 00 f0 7f 00       	push   $0x7ff000
  801a20:	6a 00                	push   $0x0
  801a22:	e8 4c fd ff ff       	call   801773 <sys_page_map>
  801a27:	83 c4 20             	add    $0x20,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 55                	js     801a83 <pgfault+0xe0>
		panic("sys_page_map: %e\n", r);

	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	68 00 f0 7f 00       	push   $0x7ff000
  801a36:	6a 00                	push   $0x0
  801a38:	e8 78 fd ff ff       	call   8017b5 <sys_page_unmap>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 51                	js     801a95 <pgfault+0xf2>
		panic("sys_page_unmap: %e\n", r);

	//panic("pgfault not implemented");
}
  801a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    
		panic("pgfault: faulting access was not a write\n");
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 bc 3a 80 00       	push   $0x803abc
  801a51:	6a 21                	push   $0x21
  801a53:	68 44 3b 80 00       	push   $0x803b44
  801a58:	e8 08 f0 ff ff       	call   800a65 <_panic>
		panic("pgfault: faulting access was no to a copy-on-write page\n");
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	68 e8 3a 80 00       	push   $0x803ae8
  801a65:	6a 24                	push   $0x24
  801a67:	68 44 3b 80 00       	push   $0x803b44
  801a6c:	e8 f4 ef ff ff       	call   800a65 <_panic>
		panic("sys_page_alloc: %e\n", r);
  801a71:	50                   	push   %eax
  801a72:	68 4f 3b 80 00       	push   $0x803b4f
  801a77:	6a 2e                	push   $0x2e
  801a79:	68 44 3b 80 00       	push   $0x803b44
  801a7e:	e8 e2 ef ff ff       	call   800a65 <_panic>
		panic("sys_page_map: %e\n", r);
  801a83:	50                   	push   %eax
  801a84:	68 63 3b 80 00       	push   $0x803b63
  801a89:	6a 34                	push   $0x34
  801a8b:	68 44 3b 80 00       	push   $0x803b44
  801a90:	e8 d0 ef ff ff       	call   800a65 <_panic>
		panic("sys_page_unmap: %e\n", r);
  801a95:	50                   	push   %eax
  801a96:	68 75 3b 80 00       	push   $0x803b75
  801a9b:	6a 37                	push   $0x37
  801a9d:	68 44 3b 80 00       	push   $0x803b44
  801aa2:	e8 be ef ff ff       	call   800a65 <_panic>

00801aa7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	57                   	push   %edi
  801aab:	56                   	push   %esi
  801aac:	53                   	push   %ebx
  801aad:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint8_t *addr;
	int r;
	
	set_pgfault_handler(pgfault);
  801ab0:	68 a3 19 80 00       	push   $0x8019a3
  801ab5:	e8 f3 15 00 00       	call   8030ad <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801aba:	b8 07 00 00 00       	mov    $0x7,%eax
  801abf:	cd 30                	int    $0x30
  801ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 30                	js     801afb <fork+0x54>
  801acb:	89 c7                	mov    %eax,%edi
		return 0;
	}

	// We're the parent.
	// Search from UTEXT to USTACKTOP map the PTE_P | PTE_U page
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801acd:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801ad2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ad6:	0f 85 a5 00 00 00    	jne    801b81 <fork+0xda>
		thisenv = &envs[ENVX(sys_getenvid())];
  801adc:	e8 11 fc ff ff       	call   8016f2 <sys_getenvid>
  801ae1:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ae6:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  801ae9:	c1 e0 04             	shl    $0x4,%eax
  801aec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801af1:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801af6:	e9 75 01 00 00       	jmp    801c70 <fork+0x1c9>
		panic("sys_exofork: %e", envid);
  801afb:	50                   	push   %eax
  801afc:	68 89 3b 80 00       	push   $0x803b89
  801b01:	68 83 00 00 00       	push   $0x83
  801b06:	68 44 3b 80 00       	push   $0x803b44
  801b0b:	e8 55 ef ff ff       	call   800a65 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801b10:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b17:	83 ec 0c             	sub    $0xc,%esp
  801b1a:	25 07 0e 00 00       	and    $0xe07,%eax
  801b1f:	50                   	push   %eax
  801b20:	56                   	push   %esi
  801b21:	57                   	push   %edi
  801b22:	56                   	push   %esi
  801b23:	6a 00                	push   $0x0
  801b25:	e8 49 fc ff ff       	call   801773 <sys_page_map>
  801b2a:	83 c4 20             	add    $0x20,%esp
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	79 3e                	jns    801b6f <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801b31:	50                   	push   %eax
  801b32:	68 63 3b 80 00       	push   $0x803b63
  801b37:	6a 50                	push   $0x50
  801b39:	68 44 3b 80 00       	push   $0x803b44
  801b3e:	e8 22 ef ff ff       	call   800a65 <_panic>
			panic("sys_page_map: %e\n", r);
  801b43:	50                   	push   %eax
  801b44:	68 63 3b 80 00       	push   $0x803b63
  801b49:	6a 54                	push   $0x54
  801b4b:	68 44 3b 80 00       	push   $0x803b44
  801b50:	e8 10 ef ff ff       	call   800a65 <_panic>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  801b55:	83 ec 0c             	sub    $0xc,%esp
  801b58:	6a 05                	push   $0x5
  801b5a:	56                   	push   %esi
  801b5b:	57                   	push   %edi
  801b5c:	56                   	push   %esi
  801b5d:	6a 00                	push   $0x0
  801b5f:	e8 0f fc ff ff       	call   801773 <sys_page_map>
  801b64:	83 c4 20             	add    $0x20,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	0f 88 ab 00 00 00    	js     801c1a <fork+0x173>
	for (addr = (uint8_t *)0; addr < (uint8_t *)UTOP; addr += PGSIZE)
  801b6f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b75:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801b7b:	0f 84 ab 00 00 00    	je     801c2c <fork+0x185>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && addr != (uint8_t *)UXSTACKTOP - PGSIZE)
  801b81:	89 d8                	mov    %ebx,%eax
  801b83:	c1 e8 16             	shr    $0x16,%eax
  801b86:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b8d:	a8 01                	test   $0x1,%al
  801b8f:	74 de                	je     801b6f <fork+0xc8>
  801b91:	89 d8                	mov    %ebx,%eax
  801b93:	c1 e8 0c             	shr    $0xc,%eax
  801b96:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b9d:	f6 c2 01             	test   $0x1,%dl
  801ba0:	74 cd                	je     801b6f <fork+0xc8>
  801ba2:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801ba8:	74 c5                	je     801b6f <fork+0xc8>
	void * addr = (void*)(pn * PGSIZE);
  801baa:	89 c6                	mov    %eax,%esi
  801bac:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE){
  801baf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bb6:	f6 c6 04             	test   $0x4,%dh
  801bb9:	0f 85 51 ff ff ff    	jne    801b10 <fork+0x69>
	else if(uvpt[pn] & (PTE_W | PTE_COW)){
  801bbf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bc6:	a9 02 08 00 00       	test   $0x802,%eax
  801bcb:	74 88                	je     801b55 <fork+0xae>
		if((r = sys_page_map((envid_t)0, addr, envid, addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801bcd:	83 ec 0c             	sub    $0xc,%esp
  801bd0:	68 05 08 00 00       	push   $0x805
  801bd5:	56                   	push   %esi
  801bd6:	57                   	push   %edi
  801bd7:	56                   	push   %esi
  801bd8:	6a 00                	push   $0x0
  801bda:	e8 94 fb ff ff       	call   801773 <sys_page_map>
  801bdf:	83 c4 20             	add    $0x20,%esp
  801be2:	85 c0                	test   %eax,%eax
  801be4:	0f 88 59 ff ff ff    	js     801b43 <fork+0x9c>
		if((r = sys_page_map((envid_t)0, addr, 0    , addr, PTE_U | PTE_P | PTE_COW)) < 0)
  801bea:	83 ec 0c             	sub    $0xc,%esp
  801bed:	68 05 08 00 00       	push   $0x805
  801bf2:	56                   	push   %esi
  801bf3:	6a 00                	push   $0x0
  801bf5:	56                   	push   %esi
  801bf6:	6a 00                	push   $0x0
  801bf8:	e8 76 fb ff ff       	call   801773 <sys_page_map>
  801bfd:	83 c4 20             	add    $0x20,%esp
  801c00:	85 c0                	test   %eax,%eax
  801c02:	0f 89 67 ff ff ff    	jns    801b6f <fork+0xc8>
			panic("sys_page_map: %e\n", r);
  801c08:	50                   	push   %eax
  801c09:	68 63 3b 80 00       	push   $0x803b63
  801c0e:	6a 56                	push   $0x56
  801c10:	68 44 3b 80 00       	push   $0x803b44
  801c15:	e8 4b ee ff ff       	call   800a65 <_panic>
			panic("sys_page_map: %e\n", r);
  801c1a:	50                   	push   %eax
  801c1b:	68 63 3b 80 00       	push   $0x803b63
  801c20:	6a 5a                	push   $0x5a
  801c22:	68 44 3b 80 00       	push   $0x803b44
  801c27:	e8 39 ee ff ff       	call   800a65 <_panic>
			duppage(envid, PGNUM(addr));

	
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	6a 07                	push   $0x7
  801c31:	68 00 f0 bf ee       	push   $0xeebff000
  801c36:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c39:	e8 f2 fa ff ff       	call   801730 <sys_page_alloc>
  801c3e:	83 c4 10             	add    $0x10,%esp
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 36                	js     801c7b <fork+0x1d4>
		panic("sys_page_alloc: %e\n", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	68 18 31 80 00       	push   $0x803118
  801c4d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c50:	e8 67 fc ff ff       	call   8018bc <sys_env_set_pgfault_upcall>
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 34                	js     801c90 <fork+0x1e9>
		panic("sys_env_set_pgfault_upcall: %e\n", r);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801c5c:	83 ec 08             	sub    $0x8,%esp
  801c5f:	6a 02                	push   $0x2
  801c61:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c64:	e8 cf fb ff ff       	call   801838 <sys_env_set_status>
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 35                	js     801ca5 <fork+0x1fe>
		panic("sys_env_set_status: %e\n", r);

	return envid;
}
  801c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c76:	5b                   	pop    %ebx
  801c77:	5e                   	pop    %esi
  801c78:	5f                   	pop    %edi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    
		panic("sys_page_alloc: %e\n", r);
  801c7b:	50                   	push   %eax
  801c7c:	68 4f 3b 80 00       	push   $0x803b4f
  801c81:	68 95 00 00 00       	push   $0x95
  801c86:	68 44 3b 80 00       	push   $0x803b44
  801c8b:	e8 d5 ed ff ff       	call   800a65 <_panic>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801c90:	50                   	push   %eax
  801c91:	68 24 3b 80 00       	push   $0x803b24
  801c96:	68 98 00 00 00       	push   $0x98
  801c9b:	68 44 3b 80 00       	push   $0x803b44
  801ca0:	e8 c0 ed ff ff       	call   800a65 <_panic>
		panic("sys_env_set_status: %e\n", r);
  801ca5:	50                   	push   %eax
  801ca6:	68 99 3b 80 00       	push   $0x803b99
  801cab:	68 9b 00 00 00       	push   $0x9b
  801cb0:	68 44 3b 80 00       	push   $0x803b44
  801cb5:	e8 ab ed ff ff       	call   800a65 <_panic>

00801cba <sfork>:

// Challenge!
int
sfork(void)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801cc0:	68 b1 3b 80 00       	push   $0x803bb1
  801cc5:	68 a4 00 00 00       	push   $0xa4
  801cca:	68 44 3b 80 00       	push   $0x803b44
  801ccf:	e8 91 ed ff ff       	call   800a65 <_panic>

00801cd4 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  801cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cdd:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801ce0:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801ce2:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801ce5:	83 3a 01             	cmpl   $0x1,(%edx)
  801ce8:	7e 09                	jle    801cf3 <argstart+0x1f>
  801cea:	ba e1 34 80 00       	mov    $0x8034e1,%edx
  801cef:	85 c9                	test   %ecx,%ecx
  801cf1:	75 05                	jne    801cf8 <argstart+0x24>
  801cf3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf8:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801cfb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    

00801d04 <argnext>:

int
argnext(struct Argstate *args)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	53                   	push   %ebx
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801d0e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801d15:	8b 43 08             	mov    0x8(%ebx),%eax
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	74 72                	je     801d8e <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801d1c:	80 38 00             	cmpb   $0x0,(%eax)
  801d1f:	75 48                	jne    801d69 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801d21:	8b 0b                	mov    (%ebx),%ecx
  801d23:	83 39 01             	cmpl   $0x1,(%ecx)
  801d26:	74 58                	je     801d80 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801d28:	8b 53 04             	mov    0x4(%ebx),%edx
  801d2b:	8b 42 04             	mov    0x4(%edx),%eax
  801d2e:	80 38 2d             	cmpb   $0x2d,(%eax)
  801d31:	75 4d                	jne    801d80 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801d33:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801d37:	74 47                	je     801d80 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801d39:	83 c0 01             	add    $0x1,%eax
  801d3c:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	8b 01                	mov    (%ecx),%eax
  801d44:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801d4b:	50                   	push   %eax
  801d4c:	8d 42 08             	lea    0x8(%edx),%eax
  801d4f:	50                   	push   %eax
  801d50:	83 c2 04             	add    $0x4,%edx
  801d53:	52                   	push   %edx
  801d54:	e8 73 f7 ff ff       	call   8014cc <memmove>
		(*args->argc)--;
  801d59:	8b 03                	mov    (%ebx),%eax
  801d5b:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d5e:	8b 43 08             	mov    0x8(%ebx),%eax
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	80 38 2d             	cmpb   $0x2d,(%eax)
  801d67:	74 11                	je     801d7a <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801d69:	8b 53 08             	mov    0x8(%ebx),%edx
  801d6c:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801d6f:	83 c2 01             	add    $0x1,%edx
  801d72:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d7a:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801d7e:	75 e9                	jne    801d69 <argnext+0x65>
	args->curarg = 0;
  801d80:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d8c:	eb e7                	jmp    801d75 <argnext+0x71>
		return -1;
  801d8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d93:	eb e0                	jmp    801d75 <argnext+0x71>

00801d95 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	53                   	push   %ebx
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801d9f:	8b 43 08             	mov    0x8(%ebx),%eax
  801da2:	85 c0                	test   %eax,%eax
  801da4:	74 12                	je     801db8 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  801da6:	80 38 00             	cmpb   $0x0,(%eax)
  801da9:	74 12                	je     801dbd <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801dab:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801dae:	c7 43 08 e1 34 80 00 	movl   $0x8034e1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801db5:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801db8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    
	} else if (*args->argc > 1) {
  801dbd:	8b 13                	mov    (%ebx),%edx
  801dbf:	83 3a 01             	cmpl   $0x1,(%edx)
  801dc2:	7f 10                	jg     801dd4 <argnextvalue+0x3f>
		args->argvalue = 0;
  801dc4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801dcb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801dd2:	eb e1                	jmp    801db5 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801dd4:	8b 43 04             	mov    0x4(%ebx),%eax
  801dd7:	8b 48 04             	mov    0x4(%eax),%ecx
  801dda:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	8b 12                	mov    (%edx),%edx
  801de2:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801de9:	52                   	push   %edx
  801dea:	8d 50 08             	lea    0x8(%eax),%edx
  801ded:	52                   	push   %edx
  801dee:	83 c0 04             	add    $0x4,%eax
  801df1:	50                   	push   %eax
  801df2:	e8 d5 f6 ff ff       	call   8014cc <memmove>
		(*args->argc)--;
  801df7:	8b 03                	mov    (%ebx),%eax
  801df9:	83 28 01             	subl   $0x1,(%eax)
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	eb b4                	jmp    801db5 <argnextvalue+0x20>

00801e01 <argvalue>:
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 08             	sub    $0x8,%esp
  801e07:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801e0a:	8b 42 0c             	mov    0xc(%edx),%eax
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	74 02                	je     801e13 <argvalue+0x12>
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	52                   	push   %edx
  801e17:	e8 79 ff ff ff       	call   801d95 <argnextvalue>
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	eb f0                	jmp    801e11 <argvalue+0x10>

00801e21 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	05 00 00 00 30       	add    $0x30000000,%eax
  801e2c:	c1 e8 0c             	shr    $0xc,%eax
}
  801e2f:	5d                   	pop    %ebp
  801e30:	c3                   	ret    

00801e31 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801e3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e41:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    

00801e48 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e50:	89 c2                	mov    %eax,%edx
  801e52:	c1 ea 16             	shr    $0x16,%edx
  801e55:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e5c:	f6 c2 01             	test   $0x1,%dl
  801e5f:	74 2d                	je     801e8e <fd_alloc+0x46>
  801e61:	89 c2                	mov    %eax,%edx
  801e63:	c1 ea 0c             	shr    $0xc,%edx
  801e66:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e6d:	f6 c2 01             	test   $0x1,%dl
  801e70:	74 1c                	je     801e8e <fd_alloc+0x46>
  801e72:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801e77:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e7c:	75 d2                	jne    801e50 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801e87:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801e8c:	eb 0a                	jmp    801e98 <fd_alloc+0x50>
			*fd_store = fd;
  801e8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e91:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    

00801e9a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ea0:	83 f8 1f             	cmp    $0x1f,%eax
  801ea3:	77 30                	ja     801ed5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801ea5:	c1 e0 0c             	shl    $0xc,%eax
  801ea8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ead:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801eb3:	f6 c2 01             	test   $0x1,%dl
  801eb6:	74 24                	je     801edc <fd_lookup+0x42>
  801eb8:	89 c2                	mov    %eax,%edx
  801eba:	c1 ea 0c             	shr    $0xc,%edx
  801ebd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ec4:	f6 c2 01             	test   $0x1,%dl
  801ec7:	74 1a                	je     801ee3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecc:	89 02                	mov    %eax,(%edx)
	return 0;
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    
		return -E_INVAL;
  801ed5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eda:	eb f7                	jmp    801ed3 <fd_lookup+0x39>
		return -E_INVAL;
  801edc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ee1:	eb f0                	jmp    801ed3 <fd_lookup+0x39>
  801ee3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ee8:	eb e9                	jmp    801ed3 <fd_lookup+0x39>

00801eea <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 08             	sub    $0x8,%esp
  801ef0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef3:	ba 44 3c 80 00       	mov    $0x803c44,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801ef8:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801efd:	39 08                	cmp    %ecx,(%eax)
  801eff:	74 33                	je     801f34 <dev_lookup+0x4a>
  801f01:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801f04:	8b 02                	mov    (%edx),%eax
  801f06:	85 c0                	test   %eax,%eax
  801f08:	75 f3                	jne    801efd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f0a:	a1 24 54 80 00       	mov    0x805424,%eax
  801f0f:	8b 40 48             	mov    0x48(%eax),%eax
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	51                   	push   %ecx
  801f16:	50                   	push   %eax
  801f17:	68 c8 3b 80 00       	push   $0x803bc8
  801f1c:	e8 1f ec ff ff       	call   800b40 <cprintf>
	*dev = 0;
  801f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    
			*dev = devtab[i];
  801f34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f37:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	eb f2                	jmp    801f32 <dev_lookup+0x48>

00801f40 <fd_close>:
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	57                   	push   %edi
  801f44:	56                   	push   %esi
  801f45:	53                   	push   %ebx
  801f46:	83 ec 24             	sub    $0x24,%esp
  801f49:	8b 75 08             	mov    0x8(%ebp),%esi
  801f4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f4f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f52:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f53:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801f59:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f5c:	50                   	push   %eax
  801f5d:	e8 38 ff ff ff       	call   801e9a <fd_lookup>
  801f62:	89 c3                	mov    %eax,%ebx
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	85 c0                	test   %eax,%eax
  801f69:	78 05                	js     801f70 <fd_close+0x30>
	    || fd != fd2)
  801f6b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801f6e:	74 16                	je     801f86 <fd_close+0x46>
		return (must_exist ? r : 0);
  801f70:	89 f8                	mov    %edi,%eax
  801f72:	84 c0                	test   %al,%al
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
  801f79:	0f 44 d8             	cmove  %eax,%ebx
}
  801f7c:	89 d8                	mov    %ebx,%eax
  801f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5f                   	pop    %edi
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f86:	83 ec 08             	sub    $0x8,%esp
  801f89:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f8c:	50                   	push   %eax
  801f8d:	ff 36                	pushl  (%esi)
  801f8f:	e8 56 ff ff ff       	call   801eea <dev_lookup>
  801f94:	89 c3                	mov    %eax,%ebx
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 1a                	js     801fb7 <fd_close+0x77>
		if (dev->dev_close)
  801f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	74 0b                	je     801fb7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	56                   	push   %esi
  801fb0:	ff d0                	call   *%eax
  801fb2:	89 c3                	mov    %eax,%ebx
  801fb4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	56                   	push   %esi
  801fbb:	6a 00                	push   $0x0
  801fbd:	e8 f3 f7 ff ff       	call   8017b5 <sys_page_unmap>
	return r;
  801fc2:	83 c4 10             	add    $0x10,%esp
  801fc5:	eb b5                	jmp    801f7c <fd_close+0x3c>

00801fc7 <close>:

int
close(int fdnum)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd0:	50                   	push   %eax
  801fd1:	ff 75 08             	pushl  0x8(%ebp)
  801fd4:	e8 c1 fe ff ff       	call   801e9a <fd_lookup>
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	79 02                	jns    801fe2 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    
		return fd_close(fd, 1);
  801fe2:	83 ec 08             	sub    $0x8,%esp
  801fe5:	6a 01                	push   $0x1
  801fe7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fea:	e8 51 ff ff ff       	call   801f40 <fd_close>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	eb ec                	jmp    801fe0 <close+0x19>

00801ff4 <close_all>:

void
close_all(void)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	53                   	push   %ebx
  801ff8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ffb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	53                   	push   %ebx
  802004:	e8 be ff ff ff       	call   801fc7 <close>
	for (i = 0; i < MAXFD; i++)
  802009:	83 c3 01             	add    $0x1,%ebx
  80200c:	83 c4 10             	add    $0x10,%esp
  80200f:	83 fb 20             	cmp    $0x20,%ebx
  802012:	75 ec                	jne    802000 <close_all+0xc>
}
  802014:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	57                   	push   %edi
  80201d:	56                   	push   %esi
  80201e:	53                   	push   %ebx
  80201f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802022:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802025:	50                   	push   %eax
  802026:	ff 75 08             	pushl  0x8(%ebp)
  802029:	e8 6c fe ff ff       	call   801e9a <fd_lookup>
  80202e:	89 c3                	mov    %eax,%ebx
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	85 c0                	test   %eax,%eax
  802035:	0f 88 81 00 00 00    	js     8020bc <dup+0xa3>
		return r;
	close(newfdnum);
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	ff 75 0c             	pushl  0xc(%ebp)
  802041:	e8 81 ff ff ff       	call   801fc7 <close>

	newfd = INDEX2FD(newfdnum);
  802046:	8b 75 0c             	mov    0xc(%ebp),%esi
  802049:	c1 e6 0c             	shl    $0xc,%esi
  80204c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802052:	83 c4 04             	add    $0x4,%esp
  802055:	ff 75 e4             	pushl  -0x1c(%ebp)
  802058:	e8 d4 fd ff ff       	call   801e31 <fd2data>
  80205d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80205f:	89 34 24             	mov    %esi,(%esp)
  802062:	e8 ca fd ff ff       	call   801e31 <fd2data>
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80206c:	89 d8                	mov    %ebx,%eax
  80206e:	c1 e8 16             	shr    $0x16,%eax
  802071:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802078:	a8 01                	test   $0x1,%al
  80207a:	74 11                	je     80208d <dup+0x74>
  80207c:	89 d8                	mov    %ebx,%eax
  80207e:	c1 e8 0c             	shr    $0xc,%eax
  802081:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802088:	f6 c2 01             	test   $0x1,%dl
  80208b:	75 39                	jne    8020c6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80208d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802090:	89 d0                	mov    %edx,%eax
  802092:	c1 e8 0c             	shr    $0xc,%eax
  802095:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	25 07 0e 00 00       	and    $0xe07,%eax
  8020a4:	50                   	push   %eax
  8020a5:	56                   	push   %esi
  8020a6:	6a 00                	push   $0x0
  8020a8:	52                   	push   %edx
  8020a9:	6a 00                	push   $0x0
  8020ab:	e8 c3 f6 ff ff       	call   801773 <sys_page_map>
  8020b0:	89 c3                	mov    %eax,%ebx
  8020b2:	83 c4 20             	add    $0x20,%esp
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	78 31                	js     8020ea <dup+0xd1>
		goto err;

	return newfdnum;
  8020b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8020bc:	89 d8                	mov    %ebx,%eax
  8020be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5f                   	pop    %edi
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d5:	50                   	push   %eax
  8020d6:	57                   	push   %edi
  8020d7:	6a 00                	push   $0x0
  8020d9:	53                   	push   %ebx
  8020da:	6a 00                	push   $0x0
  8020dc:	e8 92 f6 ff ff       	call   801773 <sys_page_map>
  8020e1:	89 c3                	mov    %eax,%ebx
  8020e3:	83 c4 20             	add    $0x20,%esp
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	79 a3                	jns    80208d <dup+0x74>
	sys_page_unmap(0, newfd);
  8020ea:	83 ec 08             	sub    $0x8,%esp
  8020ed:	56                   	push   %esi
  8020ee:	6a 00                	push   $0x0
  8020f0:	e8 c0 f6 ff ff       	call   8017b5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8020f5:	83 c4 08             	add    $0x8,%esp
  8020f8:	57                   	push   %edi
  8020f9:	6a 00                	push   $0x0
  8020fb:	e8 b5 f6 ff ff       	call   8017b5 <sys_page_unmap>
	return r;
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	eb b7                	jmp    8020bc <dup+0xa3>

00802105 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	53                   	push   %ebx
  802109:	83 ec 1c             	sub    $0x1c,%esp
  80210c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80210f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802112:	50                   	push   %eax
  802113:	53                   	push   %ebx
  802114:	e8 81 fd ff ff       	call   801e9a <fd_lookup>
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	85 c0                	test   %eax,%eax
  80211e:	78 3f                	js     80215f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802120:	83 ec 08             	sub    $0x8,%esp
  802123:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802126:	50                   	push   %eax
  802127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212a:	ff 30                	pushl  (%eax)
  80212c:	e8 b9 fd ff ff       	call   801eea <dev_lookup>
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	85 c0                	test   %eax,%eax
  802136:	78 27                	js     80215f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802138:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80213b:	8b 42 08             	mov    0x8(%edx),%eax
  80213e:	83 e0 03             	and    $0x3,%eax
  802141:	83 f8 01             	cmp    $0x1,%eax
  802144:	74 1e                	je     802164 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 40 08             	mov    0x8(%eax),%eax
  80214c:	85 c0                	test   %eax,%eax
  80214e:	74 35                	je     802185 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	ff 75 10             	pushl  0x10(%ebp)
  802156:	ff 75 0c             	pushl  0xc(%ebp)
  802159:	52                   	push   %edx
  80215a:	ff d0                	call   *%eax
  80215c:	83 c4 10             	add    $0x10,%esp
}
  80215f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802162:	c9                   	leave  
  802163:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802164:	a1 24 54 80 00       	mov    0x805424,%eax
  802169:	8b 40 48             	mov    0x48(%eax),%eax
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	53                   	push   %ebx
  802170:	50                   	push   %eax
  802171:	68 09 3c 80 00       	push   $0x803c09
  802176:	e8 c5 e9 ff ff       	call   800b40 <cprintf>
		return -E_INVAL;
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802183:	eb da                	jmp    80215f <read+0x5a>
		return -E_NOT_SUPP;
  802185:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80218a:	eb d3                	jmp    80215f <read+0x5a>

0080218c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	57                   	push   %edi
  802190:	56                   	push   %esi
  802191:	53                   	push   %ebx
  802192:	83 ec 0c             	sub    $0xc,%esp
  802195:	8b 7d 08             	mov    0x8(%ebp),%edi
  802198:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80219b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021a0:	39 f3                	cmp    %esi,%ebx
  8021a2:	73 23                	jae    8021c7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021a4:	83 ec 04             	sub    $0x4,%esp
  8021a7:	89 f0                	mov    %esi,%eax
  8021a9:	29 d8                	sub    %ebx,%eax
  8021ab:	50                   	push   %eax
  8021ac:	89 d8                	mov    %ebx,%eax
  8021ae:	03 45 0c             	add    0xc(%ebp),%eax
  8021b1:	50                   	push   %eax
  8021b2:	57                   	push   %edi
  8021b3:	e8 4d ff ff ff       	call   802105 <read>
		if (m < 0)
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 06                	js     8021c5 <readn+0x39>
			return m;
		if (m == 0)
  8021bf:	74 06                	je     8021c7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8021c1:	01 c3                	add    %eax,%ebx
  8021c3:	eb db                	jmp    8021a0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021c5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8021c7:	89 d8                	mov    %ebx,%eax
  8021c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021cc:	5b                   	pop    %ebx
  8021cd:	5e                   	pop    %esi
  8021ce:	5f                   	pop    %edi
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    

008021d1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	53                   	push   %ebx
  8021d5:	83 ec 1c             	sub    $0x1c,%esp
  8021d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021de:	50                   	push   %eax
  8021df:	53                   	push   %ebx
  8021e0:	e8 b5 fc ff ff       	call   801e9a <fd_lookup>
  8021e5:	83 c4 10             	add    $0x10,%esp
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	78 3a                	js     802226 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021ec:	83 ec 08             	sub    $0x8,%esp
  8021ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f2:	50                   	push   %eax
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	ff 30                	pushl  (%eax)
  8021f8:	e8 ed fc ff ff       	call   801eea <dev_lookup>
  8021fd:	83 c4 10             	add    $0x10,%esp
  802200:	85 c0                	test   %eax,%eax
  802202:	78 22                	js     802226 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802207:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80220b:	74 1e                	je     80222b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80220d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802210:	8b 52 0c             	mov    0xc(%edx),%edx
  802213:	85 d2                	test   %edx,%edx
  802215:	74 35                	je     80224c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802217:	83 ec 04             	sub    $0x4,%esp
  80221a:	ff 75 10             	pushl  0x10(%ebp)
  80221d:	ff 75 0c             	pushl  0xc(%ebp)
  802220:	50                   	push   %eax
  802221:	ff d2                	call   *%edx
  802223:	83 c4 10             	add    $0x10,%esp
}
  802226:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802229:	c9                   	leave  
  80222a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80222b:	a1 24 54 80 00       	mov    0x805424,%eax
  802230:	8b 40 48             	mov    0x48(%eax),%eax
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	53                   	push   %ebx
  802237:	50                   	push   %eax
  802238:	68 25 3c 80 00       	push   $0x803c25
  80223d:	e8 fe e8 ff ff       	call   800b40 <cprintf>
		return -E_INVAL;
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80224a:	eb da                	jmp    802226 <write+0x55>
		return -E_NOT_SUPP;
  80224c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802251:	eb d3                	jmp    802226 <write+0x55>

00802253 <seek>:

int
seek(int fdnum, off_t offset)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802259:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225c:	50                   	push   %eax
  80225d:	ff 75 08             	pushl  0x8(%ebp)
  802260:	e8 35 fc ff ff       	call   801e9a <fd_lookup>
  802265:	83 c4 10             	add    $0x10,%esp
  802268:	85 c0                	test   %eax,%eax
  80226a:	78 0e                	js     80227a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80226c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	53                   	push   %ebx
  802280:	83 ec 1c             	sub    $0x1c,%esp
  802283:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802286:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802289:	50                   	push   %eax
  80228a:	53                   	push   %ebx
  80228b:	e8 0a fc ff ff       	call   801e9a <fd_lookup>
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	85 c0                	test   %eax,%eax
  802295:	78 37                	js     8022ce <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802297:	83 ec 08             	sub    $0x8,%esp
  80229a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80229d:	50                   	push   %eax
  80229e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a1:	ff 30                	pushl  (%eax)
  8022a3:	e8 42 fc ff ff       	call   801eea <dev_lookup>
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	78 1f                	js     8022ce <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8022b6:	74 1b                	je     8022d3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	8b 52 18             	mov    0x18(%edx),%edx
  8022be:	85 d2                	test   %edx,%edx
  8022c0:	74 32                	je     8022f4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8022c2:	83 ec 08             	sub    $0x8,%esp
  8022c5:	ff 75 0c             	pushl  0xc(%ebp)
  8022c8:	50                   	push   %eax
  8022c9:	ff d2                	call   *%edx
  8022cb:	83 c4 10             	add    $0x10,%esp
}
  8022ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8022d3:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022d8:	8b 40 48             	mov    0x48(%eax),%eax
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	53                   	push   %ebx
  8022df:	50                   	push   %eax
  8022e0:	68 e8 3b 80 00       	push   $0x803be8
  8022e5:	e8 56 e8 ff ff       	call   800b40 <cprintf>
		return -E_INVAL;
  8022ea:	83 c4 10             	add    $0x10,%esp
  8022ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022f2:	eb da                	jmp    8022ce <ftruncate+0x52>
		return -E_NOT_SUPP;
  8022f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022f9:	eb d3                	jmp    8022ce <ftruncate+0x52>

008022fb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	53                   	push   %ebx
  8022ff:	83 ec 1c             	sub    $0x1c,%esp
  802302:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802305:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802308:	50                   	push   %eax
  802309:	ff 75 08             	pushl  0x8(%ebp)
  80230c:	e8 89 fb ff ff       	call   801e9a <fd_lookup>
  802311:	83 c4 10             	add    $0x10,%esp
  802314:	85 c0                	test   %eax,%eax
  802316:	78 4b                	js     802363 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802318:	83 ec 08             	sub    $0x8,%esp
  80231b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80231e:	50                   	push   %eax
  80231f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802322:	ff 30                	pushl  (%eax)
  802324:	e8 c1 fb ff ff       	call   801eea <dev_lookup>
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	85 c0                	test   %eax,%eax
  80232e:	78 33                	js     802363 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802337:	74 2f                	je     802368 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802339:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80233c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802343:	00 00 00 
	stat->st_isdir = 0;
  802346:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80234d:	00 00 00 
	stat->st_dev = dev;
  802350:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802356:	83 ec 08             	sub    $0x8,%esp
  802359:	53                   	push   %ebx
  80235a:	ff 75 f0             	pushl  -0x10(%ebp)
  80235d:	ff 50 14             	call   *0x14(%eax)
  802360:	83 c4 10             	add    $0x10,%esp
}
  802363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802366:	c9                   	leave  
  802367:	c3                   	ret    
		return -E_NOT_SUPP;
  802368:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80236d:	eb f4                	jmp    802363 <fstat+0x68>

0080236f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802374:	83 ec 08             	sub    $0x8,%esp
  802377:	6a 00                	push   $0x0
  802379:	ff 75 08             	pushl  0x8(%ebp)
  80237c:	e8 e7 01 00 00       	call   802568 <open>
  802381:	89 c3                	mov    %eax,%ebx
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	85 c0                	test   %eax,%eax
  802388:	78 1b                	js     8023a5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80238a:	83 ec 08             	sub    $0x8,%esp
  80238d:	ff 75 0c             	pushl  0xc(%ebp)
  802390:	50                   	push   %eax
  802391:	e8 65 ff ff ff       	call   8022fb <fstat>
  802396:	89 c6                	mov    %eax,%esi
	close(fd);
  802398:	89 1c 24             	mov    %ebx,(%esp)
  80239b:	e8 27 fc ff ff       	call   801fc7 <close>
	return r;
  8023a0:	83 c4 10             	add    $0x10,%esp
  8023a3:	89 f3                	mov    %esi,%ebx
}
  8023a5:	89 d8                	mov    %ebx,%eax
  8023a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023aa:	5b                   	pop    %ebx
  8023ab:	5e                   	pop    %esi
  8023ac:	5d                   	pop    %ebp
  8023ad:	c3                   	ret    

008023ae <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	56                   	push   %esi
  8023b2:	53                   	push   %ebx
  8023b3:	89 c6                	mov    %eax,%esi
  8023b5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8023b7:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  8023be:	74 27                	je     8023e7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8023c0:	6a 07                	push   $0x7
  8023c2:	68 00 60 80 00       	push   $0x806000
  8023c7:	56                   	push   %esi
  8023c8:	ff 35 20 54 80 00    	pushl  0x805420
  8023ce:	e8 d2 0d 00 00       	call   8031a5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8023d3:	83 c4 0c             	add    $0xc,%esp
  8023d6:	6a 00                	push   $0x0
  8023d8:	53                   	push   %ebx
  8023d9:	6a 00                	push   $0x0
  8023db:	e8 5e 0d 00 00       	call   80313e <ipc_recv>
}
  8023e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023e3:	5b                   	pop    %ebx
  8023e4:	5e                   	pop    %esi
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023e7:	83 ec 0c             	sub    $0xc,%esp
  8023ea:	6a 01                	push   $0x1
  8023ec:	e8 fd 0d 00 00       	call   8031ee <ipc_find_env>
  8023f1:	a3 20 54 80 00       	mov    %eax,0x805420
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	eb c5                	jmp    8023c0 <fsipc+0x12>

008023fb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8b 40 0c             	mov    0xc(%eax),%eax
  802407:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80240c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240f:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802414:	ba 00 00 00 00       	mov    $0x0,%edx
  802419:	b8 02 00 00 00       	mov    $0x2,%eax
  80241e:	e8 8b ff ff ff       	call   8023ae <fsipc>
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <devfile_flush>:
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8b 40 0c             	mov    0xc(%eax),%eax
  802431:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802436:	ba 00 00 00 00       	mov    $0x0,%edx
  80243b:	b8 06 00 00 00       	mov    $0x6,%eax
  802440:	e8 69 ff ff ff       	call   8023ae <fsipc>
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <devfile_stat>:
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	53                   	push   %ebx
  80244b:	83 ec 04             	sub    $0x4,%esp
  80244e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802451:	8b 45 08             	mov    0x8(%ebp),%eax
  802454:	8b 40 0c             	mov    0xc(%eax),%eax
  802457:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80245c:	ba 00 00 00 00       	mov    $0x0,%edx
  802461:	b8 05 00 00 00       	mov    $0x5,%eax
  802466:	e8 43 ff ff ff       	call   8023ae <fsipc>
  80246b:	85 c0                	test   %eax,%eax
  80246d:	78 2c                	js     80249b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80246f:	83 ec 08             	sub    $0x8,%esp
  802472:	68 00 60 80 00       	push   $0x806000
  802477:	53                   	push   %ebx
  802478:	e8 c1 ee ff ff       	call   80133e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80247d:	a1 80 60 80 00       	mov    0x806080,%eax
  802482:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802488:	a1 84 60 80 00       	mov    0x806084,%eax
  80248d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802493:	83 c4 10             	add    $0x10,%esp
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <devfile_write>:
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	83 ec 0c             	sub    $0xc,%esp
  8024a6:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8024a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8024af:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8024b5:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8024ba:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8024bf:	0f 47 c2             	cmova  %edx,%eax
  8024c2:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8024c7:	50                   	push   %eax
  8024c8:	ff 75 0c             	pushl  0xc(%ebp)
  8024cb:	68 08 60 80 00       	push   $0x806008
  8024d0:	e8 f7 ef ff ff       	call   8014cc <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8024d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8024da:	b8 04 00 00 00       	mov    $0x4,%eax
  8024df:	e8 ca fe ff ff       	call   8023ae <fsipc>
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <devfile_read>:
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	56                   	push   %esi
  8024ea:	53                   	push   %ebx
  8024eb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8024f9:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8024ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802504:	b8 03 00 00 00       	mov    $0x3,%eax
  802509:	e8 a0 fe ff ff       	call   8023ae <fsipc>
  80250e:	89 c3                	mov    %eax,%ebx
  802510:	85 c0                	test   %eax,%eax
  802512:	78 1f                	js     802533 <devfile_read+0x4d>
	assert(r <= n);
  802514:	39 f0                	cmp    %esi,%eax
  802516:	77 24                	ja     80253c <devfile_read+0x56>
	assert(r <= PGSIZE);
  802518:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80251d:	7f 33                	jg     802552 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80251f:	83 ec 04             	sub    $0x4,%esp
  802522:	50                   	push   %eax
  802523:	68 00 60 80 00       	push   $0x806000
  802528:	ff 75 0c             	pushl  0xc(%ebp)
  80252b:	e8 9c ef ff ff       	call   8014cc <memmove>
	return r;
  802530:	83 c4 10             	add    $0x10,%esp
}
  802533:	89 d8                	mov    %ebx,%eax
  802535:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802538:	5b                   	pop    %ebx
  802539:	5e                   	pop    %esi
  80253a:	5d                   	pop    %ebp
  80253b:	c3                   	ret    
	assert(r <= n);
  80253c:	68 54 3c 80 00       	push   $0x803c54
  802541:	68 06 36 80 00       	push   $0x803606
  802546:	6a 7c                	push   $0x7c
  802548:	68 5b 3c 80 00       	push   $0x803c5b
  80254d:	e8 13 e5 ff ff       	call   800a65 <_panic>
	assert(r <= PGSIZE);
  802552:	68 66 3c 80 00       	push   $0x803c66
  802557:	68 06 36 80 00       	push   $0x803606
  80255c:	6a 7d                	push   $0x7d
  80255e:	68 5b 3c 80 00       	push   $0x803c5b
  802563:	e8 fd e4 ff ff       	call   800a65 <_panic>

00802568 <open>:
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	56                   	push   %esi
  80256c:	53                   	push   %ebx
  80256d:	83 ec 1c             	sub    $0x1c,%esp
  802570:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802573:	56                   	push   %esi
  802574:	e8 8c ed ff ff       	call   801305 <strlen>
  802579:	83 c4 10             	add    $0x10,%esp
  80257c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802581:	7f 6c                	jg     8025ef <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802583:	83 ec 0c             	sub    $0xc,%esp
  802586:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802589:	50                   	push   %eax
  80258a:	e8 b9 f8 ff ff       	call   801e48 <fd_alloc>
  80258f:	89 c3                	mov    %eax,%ebx
  802591:	83 c4 10             	add    $0x10,%esp
  802594:	85 c0                	test   %eax,%eax
  802596:	78 3c                	js     8025d4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802598:	83 ec 08             	sub    $0x8,%esp
  80259b:	56                   	push   %esi
  80259c:	68 00 60 80 00       	push   $0x806000
  8025a1:	e8 98 ed ff ff       	call   80133e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8025a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a9:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b6:	e8 f3 fd ff ff       	call   8023ae <fsipc>
  8025bb:	89 c3                	mov    %eax,%ebx
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	78 19                	js     8025dd <open+0x75>
	return fd2num(fd);
  8025c4:	83 ec 0c             	sub    $0xc,%esp
  8025c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ca:	e8 52 f8 ff ff       	call   801e21 <fd2num>
  8025cf:	89 c3                	mov    %eax,%ebx
  8025d1:	83 c4 10             	add    $0x10,%esp
}
  8025d4:	89 d8                	mov    %ebx,%eax
  8025d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d9:	5b                   	pop    %ebx
  8025da:	5e                   	pop    %esi
  8025db:	5d                   	pop    %ebp
  8025dc:	c3                   	ret    
		fd_close(fd, 0);
  8025dd:	83 ec 08             	sub    $0x8,%esp
  8025e0:	6a 00                	push   $0x0
  8025e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e5:	e8 56 f9 ff ff       	call   801f40 <fd_close>
		return r;
  8025ea:	83 c4 10             	add    $0x10,%esp
  8025ed:	eb e5                	jmp    8025d4 <open+0x6c>
		return -E_BAD_PATH;
  8025ef:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8025f4:	eb de                	jmp    8025d4 <open+0x6c>

008025f6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8025fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802601:	b8 08 00 00 00       	mov    $0x8,%eax
  802606:	e8 a3 fd ff ff       	call   8023ae <fsipc>
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80260d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802611:	7f 01                	jg     802614 <writebuf+0x7>
  802613:	c3                   	ret    
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	53                   	push   %ebx
  802618:	83 ec 08             	sub    $0x8,%esp
  80261b:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80261d:	ff 70 04             	pushl  0x4(%eax)
  802620:	8d 40 10             	lea    0x10(%eax),%eax
  802623:	50                   	push   %eax
  802624:	ff 33                	pushl  (%ebx)
  802626:	e8 a6 fb ff ff       	call   8021d1 <write>
		if (result > 0)
  80262b:	83 c4 10             	add    $0x10,%esp
  80262e:	85 c0                	test   %eax,%eax
  802630:	7e 03                	jle    802635 <writebuf+0x28>
			b->result += result;
  802632:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802635:	39 43 04             	cmp    %eax,0x4(%ebx)
  802638:	74 0d                	je     802647 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80263a:	85 c0                	test   %eax,%eax
  80263c:	ba 00 00 00 00       	mov    $0x0,%edx
  802641:	0f 4f c2             	cmovg  %edx,%eax
  802644:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802647:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <putch>:

static void
putch(int ch, void *thunk)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	53                   	push   %ebx
  802650:	83 ec 04             	sub    $0x4,%esp
  802653:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  802656:	8b 53 04             	mov    0x4(%ebx),%edx
  802659:	8d 42 01             	lea    0x1(%edx),%eax
  80265c:	89 43 04             	mov    %eax,0x4(%ebx)
  80265f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802662:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  802666:	3d 00 01 00 00       	cmp    $0x100,%eax
  80266b:	74 06                	je     802673 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80266d:	83 c4 04             	add    $0x4,%esp
  802670:	5b                   	pop    %ebx
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    
		writebuf(b);
  802673:	89 d8                	mov    %ebx,%eax
  802675:	e8 93 ff ff ff       	call   80260d <writebuf>
		b->idx = 0;
  80267a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802681:	eb ea                	jmp    80266d <putch+0x21>

00802683 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
  802686:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802695:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80269c:	00 00 00 
	b.result = 0;
  80269f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8026a6:	00 00 00 
	b.error = 1;
  8026a9:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8026b0:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8026b3:	ff 75 10             	pushl  0x10(%ebp)
  8026b6:	ff 75 0c             	pushl  0xc(%ebp)
  8026b9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8026bf:	50                   	push   %eax
  8026c0:	68 4c 26 80 00       	push   $0x80264c
  8026c5:	e8 a3 e5 ff ff       	call   800c6d <vprintfmt>
	if (b.idx > 0)
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8026d4:	7f 11                	jg     8026e7 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8026d6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8026e5:	c9                   	leave  
  8026e6:	c3                   	ret    
		writebuf(&b);
  8026e7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8026ed:	e8 1b ff ff ff       	call   80260d <writebuf>
  8026f2:	eb e2                	jmp    8026d6 <vfprintf+0x53>

008026f4 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8026fa:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8026fd:	50                   	push   %eax
  8026fe:	ff 75 0c             	pushl  0xc(%ebp)
  802701:	ff 75 08             	pushl  0x8(%ebp)
  802704:	e8 7a ff ff ff       	call   802683 <vfprintf>
	va_end(ap);

	return cnt;
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <printf>:

int
printf(const char *fmt, ...)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802711:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802714:	50                   	push   %eax
  802715:	ff 75 08             	pushl  0x8(%ebp)
  802718:	6a 01                	push   $0x1
  80271a:	e8 64 ff ff ff       	call   802683 <vfprintf>
	va_end(ap);

	return cnt;
}
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
  802724:	57                   	push   %edi
  802725:	56                   	push   %esi
  802726:	53                   	push   %ebx
  802727:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80272d:	6a 00                	push   $0x0
  80272f:	ff 75 08             	pushl  0x8(%ebp)
  802732:	e8 31 fe ff ff       	call   802568 <open>
  802737:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80273d:	83 c4 10             	add    $0x10,%esp
  802740:	85 c0                	test   %eax,%eax
  802742:	0f 88 ff 04 00 00    	js     802c47 <spawn+0x526>
  802748:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80274a:	83 ec 04             	sub    $0x4,%esp
  80274d:	68 00 02 00 00       	push   $0x200
  802752:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802758:	50                   	push   %eax
  802759:	51                   	push   %ecx
  80275a:	e8 2d fa ff ff       	call   80218c <readn>
  80275f:	83 c4 10             	add    $0x10,%esp
  802762:	3d 00 02 00 00       	cmp    $0x200,%eax
  802767:	75 60                	jne    8027c9 <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  802769:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802770:	45 4c 46 
  802773:	75 54                	jne    8027c9 <spawn+0xa8>
  802775:	b8 07 00 00 00       	mov    $0x7,%eax
  80277a:	cd 30                	int    $0x30
  80277c:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802782:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802788:	85 c0                	test   %eax,%eax
  80278a:	0f 88 ab 04 00 00    	js     802c3b <spawn+0x51a>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802790:	25 ff 03 00 00       	and    $0x3ff,%eax
  802795:	8d 34 c0             	lea    (%eax,%eax,8),%esi
  802798:	c1 e6 04             	shl    $0x4,%esi
  80279b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8027a1:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8027a7:	b9 11 00 00 00       	mov    $0x11,%ecx
  8027ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8027ae:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8027b4:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8027ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8027bf:	be 00 00 00 00       	mov    $0x0,%esi
  8027c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8027c7:	eb 4b                	jmp    802814 <spawn+0xf3>
		close(fd);
  8027c9:	83 ec 0c             	sub    $0xc,%esp
  8027cc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8027d2:	e8 f0 f7 ff ff       	call   801fc7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8027d7:	83 c4 0c             	add    $0xc,%esp
  8027da:	68 7f 45 4c 46       	push   $0x464c457f
  8027df:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8027e5:	68 72 3c 80 00       	push   $0x803c72
  8027ea:	e8 51 e3 ff ff       	call   800b40 <cprintf>
		return -E_NOT_EXEC;
  8027ef:	83 c4 10             	add    $0x10,%esp
  8027f2:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8027f9:	ff ff ff 
  8027fc:	e9 46 04 00 00       	jmp    802c47 <spawn+0x526>
		string_size += strlen(argv[argc]) + 1;
  802801:	83 ec 0c             	sub    $0xc,%esp
  802804:	50                   	push   %eax
  802805:	e8 fb ea ff ff       	call   801305 <strlen>
  80280a:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80280e:	83 c3 01             	add    $0x1,%ebx
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80281b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80281e:	85 c0                	test   %eax,%eax
  802820:	75 df                	jne    802801 <spawn+0xe0>
  802822:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802828:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80282e:	bf 00 10 40 00       	mov    $0x401000,%edi
  802833:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802835:	89 fa                	mov    %edi,%edx
  802837:	83 e2 fc             	and    $0xfffffffc,%edx
  80283a:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802841:	29 c2                	sub    %eax,%edx
  802843:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802849:	8d 42 f8             	lea    -0x8(%edx),%eax
  80284c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802851:	0f 86 13 04 00 00    	jbe    802c6a <spawn+0x549>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	6a 07                	push   $0x7
  80285c:	68 00 00 40 00       	push   $0x400000
  802861:	6a 00                	push   $0x0
  802863:	e8 c8 ee ff ff       	call   801730 <sys_page_alloc>
  802868:	83 c4 10             	add    $0x10,%esp
  80286b:	85 c0                	test   %eax,%eax
  80286d:	0f 88 fc 03 00 00    	js     802c6f <spawn+0x54e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802873:	be 00 00 00 00       	mov    $0x0,%esi
  802878:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80287e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802881:	eb 30                	jmp    8028b3 <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  802883:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802889:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80288f:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802892:	83 ec 08             	sub    $0x8,%esp
  802895:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802898:	57                   	push   %edi
  802899:	e8 a0 ea ff ff       	call   80133e <strcpy>
		string_store += strlen(argv[i]) + 1;
  80289e:	83 c4 04             	add    $0x4,%esp
  8028a1:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8028a4:	e8 5c ea ff ff       	call   801305 <strlen>
  8028a9:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8028ad:	83 c6 01             	add    $0x1,%esi
  8028b0:	83 c4 10             	add    $0x10,%esp
  8028b3:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8028b9:	7f c8                	jg     802883 <spawn+0x162>
	}
	argv_store[argc] = 0;
  8028bb:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028c1:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8028c7:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8028ce:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8028d4:	0f 85 86 00 00 00    	jne    802960 <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8028da:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8028e0:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  8028e6:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8028e9:	89 d0                	mov    %edx,%eax
  8028eb:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8028f1:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8028f4:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8028f9:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8028ff:	83 ec 0c             	sub    $0xc,%esp
  802902:	6a 07                	push   $0x7
  802904:	68 00 d0 bf ee       	push   $0xeebfd000
  802909:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80290f:	68 00 00 40 00       	push   $0x400000
  802914:	6a 00                	push   $0x0
  802916:	e8 58 ee ff ff       	call   801773 <sys_page_map>
  80291b:	89 c3                	mov    %eax,%ebx
  80291d:	83 c4 20             	add    $0x20,%esp
  802920:	85 c0                	test   %eax,%eax
  802922:	0f 88 4f 03 00 00    	js     802c77 <spawn+0x556>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802928:	83 ec 08             	sub    $0x8,%esp
  80292b:	68 00 00 40 00       	push   $0x400000
  802930:	6a 00                	push   $0x0
  802932:	e8 7e ee ff ff       	call   8017b5 <sys_page_unmap>
  802937:	89 c3                	mov    %eax,%ebx
  802939:	83 c4 10             	add    $0x10,%esp
  80293c:	85 c0                	test   %eax,%eax
  80293e:	0f 88 33 03 00 00    	js     802c77 <spawn+0x556>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802944:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80294a:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802951:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802958:	00 00 00 
  80295b:	e9 4f 01 00 00       	jmp    802aaf <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802960:	68 00 3d 80 00       	push   $0x803d00
  802965:	68 06 36 80 00       	push   $0x803606
  80296a:	68 f2 00 00 00       	push   $0xf2
  80296f:	68 8c 3c 80 00       	push   $0x803c8c
  802974:	e8 ec e0 ff ff       	call   800a65 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	6a 07                	push   $0x7
  80297e:	68 00 00 40 00       	push   $0x400000
  802983:	6a 00                	push   $0x0
  802985:	e8 a6 ed ff ff       	call   801730 <sys_page_alloc>
  80298a:	83 c4 10             	add    $0x10,%esp
  80298d:	85 c0                	test   %eax,%eax
  80298f:	0f 88 c0 02 00 00    	js     802c55 <spawn+0x534>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802995:	83 ec 08             	sub    $0x8,%esp
  802998:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80299e:	01 f0                	add    %esi,%eax
  8029a0:	50                   	push   %eax
  8029a1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8029a7:	e8 a7 f8 ff ff       	call   802253 <seek>
  8029ac:	83 c4 10             	add    $0x10,%esp
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	0f 88 a5 02 00 00    	js     802c5c <spawn+0x53b>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8029b7:	83 ec 04             	sub    $0x4,%esp
  8029ba:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8029c0:	29 f0                	sub    %esi,%eax
  8029c2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8029c7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8029cc:	0f 47 c1             	cmova  %ecx,%eax
  8029cf:	50                   	push   %eax
  8029d0:	68 00 00 40 00       	push   $0x400000
  8029d5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8029db:	e8 ac f7 ff ff       	call   80218c <readn>
  8029e0:	83 c4 10             	add    $0x10,%esp
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	0f 88 78 02 00 00    	js     802c63 <spawn+0x542>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8029eb:	83 ec 0c             	sub    $0xc,%esp
  8029ee:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8029f4:	53                   	push   %ebx
  8029f5:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8029fb:	68 00 00 40 00       	push   $0x400000
  802a00:	6a 00                	push   $0x0
  802a02:	e8 6c ed ff ff       	call   801773 <sys_page_map>
  802a07:	83 c4 20             	add    $0x20,%esp
  802a0a:	85 c0                	test   %eax,%eax
  802a0c:	78 7c                	js     802a8a <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802a0e:	83 ec 08             	sub    $0x8,%esp
  802a11:	68 00 00 40 00       	push   $0x400000
  802a16:	6a 00                	push   $0x0
  802a18:	e8 98 ed ff ff       	call   8017b5 <sys_page_unmap>
  802a1d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802a20:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802a26:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802a2c:	89 fe                	mov    %edi,%esi
  802a2e:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802a34:	76 69                	jbe    802a9f <spawn+0x37e>
		if (i >= filesz) {
  802a36:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802a3c:	0f 87 37 ff ff ff    	ja     802979 <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802a42:	83 ec 04             	sub    $0x4,%esp
  802a45:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802a4b:	53                   	push   %ebx
  802a4c:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802a52:	e8 d9 ec ff ff       	call   801730 <sys_page_alloc>
  802a57:	83 c4 10             	add    $0x10,%esp
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	79 c2                	jns    802a20 <spawn+0x2ff>
  802a5e:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802a60:	83 ec 0c             	sub    $0xc,%esp
  802a63:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802a69:	e8 43 ec ff ff       	call   8016b1 <sys_env_destroy>
	close(fd);
  802a6e:	83 c4 04             	add    $0x4,%esp
  802a71:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802a77:	e8 4b f5 ff ff       	call   801fc7 <close>
	return r;
  802a7c:	83 c4 10             	add    $0x10,%esp
  802a7f:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802a85:	e9 bd 01 00 00       	jmp    802c47 <spawn+0x526>
				panic("spawn: sys_page_map data: %e", r);
  802a8a:	50                   	push   %eax
  802a8b:	68 98 3c 80 00       	push   $0x803c98
  802a90:	68 25 01 00 00       	push   $0x125
  802a95:	68 8c 3c 80 00       	push   $0x803c8c
  802a9a:	e8 c6 df ff ff       	call   800a65 <_panic>
  802a9f:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802aa5:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802aac:	83 c6 20             	add    $0x20,%esi
  802aaf:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802ab6:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802abc:	7e 6d                	jle    802b2b <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  802abe:	83 3e 01             	cmpl   $0x1,(%esi)
  802ac1:	75 e2                	jne    802aa5 <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802ac3:	8b 46 18             	mov    0x18(%esi),%eax
  802ac6:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802ac9:	83 f8 01             	cmp    $0x1,%eax
  802acc:	19 c0                	sbb    %eax,%eax
  802ace:	83 e0 fe             	and    $0xfffffffe,%eax
  802ad1:	83 c0 07             	add    $0x7,%eax
  802ad4:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802ada:	8b 4e 04             	mov    0x4(%esi),%ecx
  802add:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802ae3:	8b 56 10             	mov    0x10(%esi),%edx
  802ae6:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802aec:	8b 7e 14             	mov    0x14(%esi),%edi
  802aef:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802af5:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802af8:	89 d8                	mov    %ebx,%eax
  802afa:	25 ff 0f 00 00       	and    $0xfff,%eax
  802aff:	74 1a                	je     802b1b <spawn+0x3fa>
		va -= i;
  802b01:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802b03:	01 c7                	add    %eax,%edi
  802b05:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802b0b:	01 c2                	add    %eax,%edx
  802b0d:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802b13:	29 c1                	sub    %eax,%ecx
  802b15:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802b1b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b20:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802b26:	e9 01 ff ff ff       	jmp    802a2c <spawn+0x30b>
	close(fd);
  802b2b:	83 ec 0c             	sub    $0xc,%esp
  802b2e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b34:	e8 8e f4 ff ff       	call   801fc7 <close>
  802b39:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	uint8_t *addr;
	int r;

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  802b3c:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802b41:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802b47:	eb 0e                	jmp    802b57 <spawn+0x436>
  802b49:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802b4f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802b55:	74 6f                	je     802bc6 <spawn+0x4a5>
		if ((uvpd[PDX(addr)] & PTE_P) 
  802b57:	89 d8                	mov    %ebx,%eax
  802b59:	c1 e8 16             	shr    $0x16,%eax
  802b5c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802b63:	a8 01                	test   $0x1,%al
  802b65:	74 e2                	je     802b49 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_P) 
  802b67:	89 d8                	mov    %ebx,%eax
  802b69:	c1 e8 0c             	shr    $0xc,%eax
  802b6c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b73:	f6 c2 01             	test   $0x1,%dl
  802b76:	74 d1                	je     802b49 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_U) 
  802b78:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b7f:	f6 c2 04             	test   $0x4,%dl
  802b82:	74 c5                	je     802b49 <spawn+0x428>
		&& (uvpt[PGNUM(addr)] & PTE_SHARE)){
  802b84:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b8b:	f6 c6 04             	test   $0x4,%dh
  802b8e:	74 b9                	je     802b49 <spawn+0x428>
			if((r = sys_page_map(0, (void*)addr, child, (void*)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  802b90:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802b97:	83 ec 0c             	sub    $0xc,%esp
  802b9a:	25 07 0e 00 00       	and    $0xe07,%eax
  802b9f:	50                   	push   %eax
  802ba0:	53                   	push   %ebx
  802ba1:	56                   	push   %esi
  802ba2:	53                   	push   %ebx
  802ba3:	6a 00                	push   $0x0
  802ba5:	e8 c9 eb ff ff       	call   801773 <sys_page_map>
  802baa:	83 c4 20             	add    $0x20,%esp
  802bad:	85 c0                	test   %eax,%eax
  802baf:	79 98                	jns    802b49 <spawn+0x428>
				panic("copy_shared_pages: %e\n", r);
  802bb1:	50                   	push   %eax
  802bb2:	68 b5 3c 80 00       	push   $0x803cb5
  802bb7:	68 3a 01 00 00       	push   $0x13a
  802bbc:	68 8c 3c 80 00       	push   $0x803c8c
  802bc1:	e8 9f de ff ff       	call   800a65 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802bc6:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802bcd:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802bd0:	83 ec 08             	sub    $0x8,%esp
  802bd3:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802bd9:	50                   	push   %eax
  802bda:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802be0:	e8 95 ec ff ff       	call   80187a <sys_env_set_trapframe>
  802be5:	83 c4 10             	add    $0x10,%esp
  802be8:	85 c0                	test   %eax,%eax
  802bea:	78 25                	js     802c11 <spawn+0x4f0>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802bec:	83 ec 08             	sub    $0x8,%esp
  802bef:	6a 02                	push   $0x2
  802bf1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802bf7:	e8 3c ec ff ff       	call   801838 <sys_env_set_status>
  802bfc:	83 c4 10             	add    $0x10,%esp
  802bff:	85 c0                	test   %eax,%eax
  802c01:	78 23                	js     802c26 <spawn+0x505>
	return child;
  802c03:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802c09:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c0f:	eb 36                	jmp    802c47 <spawn+0x526>
		panic("sys_env_set_trapframe: %e", r);
  802c11:	50                   	push   %eax
  802c12:	68 cc 3c 80 00       	push   $0x803ccc
  802c17:	68 86 00 00 00       	push   $0x86
  802c1c:	68 8c 3c 80 00       	push   $0x803c8c
  802c21:	e8 3f de ff ff       	call   800a65 <_panic>
		panic("sys_env_set_status: %e", r);
  802c26:	50                   	push   %eax
  802c27:	68 e6 3c 80 00       	push   $0x803ce6
  802c2c:	68 89 00 00 00       	push   $0x89
  802c31:	68 8c 3c 80 00       	push   $0x803c8c
  802c36:	e8 2a de ff ff       	call   800a65 <_panic>
		return r;
  802c3b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802c41:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802c47:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c50:	5b                   	pop    %ebx
  802c51:	5e                   	pop    %esi
  802c52:	5f                   	pop    %edi
  802c53:	5d                   	pop    %ebp
  802c54:	c3                   	ret    
  802c55:	89 c7                	mov    %eax,%edi
  802c57:	e9 04 fe ff ff       	jmp    802a60 <spawn+0x33f>
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	e9 fd fd ff ff       	jmp    802a60 <spawn+0x33f>
  802c63:	89 c7                	mov    %eax,%edi
  802c65:	e9 f6 fd ff ff       	jmp    802a60 <spawn+0x33f>
		return -E_NO_MEM;
  802c6a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE){
  802c6f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c75:	eb d0                	jmp    802c47 <spawn+0x526>
	sys_page_unmap(0, UTEMP);
  802c77:	83 ec 08             	sub    $0x8,%esp
  802c7a:	68 00 00 40 00       	push   $0x400000
  802c7f:	6a 00                	push   $0x0
  802c81:	e8 2f eb ff ff       	call   8017b5 <sys_page_unmap>
  802c86:	83 c4 10             	add    $0x10,%esp
  802c89:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802c8f:	eb b6                	jmp    802c47 <spawn+0x526>

00802c91 <spawnl>:
{
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
  802c94:	57                   	push   %edi
  802c95:	56                   	push   %esi
  802c96:	53                   	push   %ebx
  802c97:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802c9a:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802c9d:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802ca2:	8d 4a 04             	lea    0x4(%edx),%ecx
  802ca5:	83 3a 00             	cmpl   $0x0,(%edx)
  802ca8:	74 07                	je     802cb1 <spawnl+0x20>
		argc++;
  802caa:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802cad:	89 ca                	mov    %ecx,%edx
  802caf:	eb f1                	jmp    802ca2 <spawnl+0x11>
	const char *argv[argc+2];
  802cb1:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802cb8:	83 e2 f0             	and    $0xfffffff0,%edx
  802cbb:	29 d4                	sub    %edx,%esp
  802cbd:	8d 54 24 03          	lea    0x3(%esp),%edx
  802cc1:	c1 ea 02             	shr    $0x2,%edx
  802cc4:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802ccb:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cd0:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802cd7:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802cde:	00 
	va_start(vl, arg0);
  802cdf:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802ce2:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce9:	eb 0b                	jmp    802cf6 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802ceb:	83 c0 01             	add    $0x1,%eax
  802cee:	8b 39                	mov    (%ecx),%edi
  802cf0:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802cf3:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802cf6:	39 d0                	cmp    %edx,%eax
  802cf8:	75 f1                	jne    802ceb <spawnl+0x5a>
	return spawn(prog, argv);
  802cfa:	83 ec 08             	sub    $0x8,%esp
  802cfd:	56                   	push   %esi
  802cfe:	ff 75 08             	pushl  0x8(%ebp)
  802d01:	e8 1b fa ff ff       	call   802721 <spawn>
}
  802d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d09:	5b                   	pop    %ebx
  802d0a:	5e                   	pop    %esi
  802d0b:	5f                   	pop    %edi
  802d0c:	5d                   	pop    %ebp
  802d0d:	c3                   	ret    

00802d0e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802d0e:	55                   	push   %ebp
  802d0f:	89 e5                	mov    %esp,%ebp
  802d11:	56                   	push   %esi
  802d12:	53                   	push   %ebx
  802d13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802d16:	83 ec 0c             	sub    $0xc,%esp
  802d19:	ff 75 08             	pushl  0x8(%ebp)
  802d1c:	e8 10 f1 ff ff       	call   801e31 <fd2data>
  802d21:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802d23:	83 c4 08             	add    $0x8,%esp
  802d26:	68 28 3d 80 00       	push   $0x803d28
  802d2b:	53                   	push   %ebx
  802d2c:	e8 0d e6 ff ff       	call   80133e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802d31:	8b 46 04             	mov    0x4(%esi),%eax
  802d34:	2b 06                	sub    (%esi),%eax
  802d36:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802d3c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802d43:	00 00 00 
	stat->st_dev = &devpipe;
  802d46:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802d4d:	40 80 00 
	return 0;
}
  802d50:	b8 00 00 00 00       	mov    $0x0,%eax
  802d55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d58:	5b                   	pop    %ebx
  802d59:	5e                   	pop    %esi
  802d5a:	5d                   	pop    %ebp
  802d5b:	c3                   	ret    

00802d5c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802d5c:	55                   	push   %ebp
  802d5d:	89 e5                	mov    %esp,%ebp
  802d5f:	53                   	push   %ebx
  802d60:	83 ec 0c             	sub    $0xc,%esp
  802d63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802d66:	53                   	push   %ebx
  802d67:	6a 00                	push   $0x0
  802d69:	e8 47 ea ff ff       	call   8017b5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802d6e:	89 1c 24             	mov    %ebx,(%esp)
  802d71:	e8 bb f0 ff ff       	call   801e31 <fd2data>
  802d76:	83 c4 08             	add    $0x8,%esp
  802d79:	50                   	push   %eax
  802d7a:	6a 00                	push   $0x0
  802d7c:	e8 34 ea ff ff       	call   8017b5 <sys_page_unmap>
}
  802d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d84:	c9                   	leave  
  802d85:	c3                   	ret    

00802d86 <_pipeisclosed>:
{
  802d86:	55                   	push   %ebp
  802d87:	89 e5                	mov    %esp,%ebp
  802d89:	57                   	push   %edi
  802d8a:	56                   	push   %esi
  802d8b:	53                   	push   %ebx
  802d8c:	83 ec 1c             	sub    $0x1c,%esp
  802d8f:	89 c7                	mov    %eax,%edi
  802d91:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802d93:	a1 24 54 80 00       	mov    0x805424,%eax
  802d98:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802d9b:	83 ec 0c             	sub    $0xc,%esp
  802d9e:	57                   	push   %edi
  802d9f:	e8 89 04 00 00       	call   80322d <pageref>
  802da4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802da7:	89 34 24             	mov    %esi,(%esp)
  802daa:	e8 7e 04 00 00       	call   80322d <pageref>
		nn = thisenv->env_runs;
  802daf:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802db5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802db8:	83 c4 10             	add    $0x10,%esp
  802dbb:	39 cb                	cmp    %ecx,%ebx
  802dbd:	74 1b                	je     802dda <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802dbf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802dc2:	75 cf                	jne    802d93 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802dc4:	8b 42 58             	mov    0x58(%edx),%eax
  802dc7:	6a 01                	push   $0x1
  802dc9:	50                   	push   %eax
  802dca:	53                   	push   %ebx
  802dcb:	68 2f 3d 80 00       	push   $0x803d2f
  802dd0:	e8 6b dd ff ff       	call   800b40 <cprintf>
  802dd5:	83 c4 10             	add    $0x10,%esp
  802dd8:	eb b9                	jmp    802d93 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802dda:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802ddd:	0f 94 c0             	sete   %al
  802de0:	0f b6 c0             	movzbl %al,%eax
}
  802de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802de6:	5b                   	pop    %ebx
  802de7:	5e                   	pop    %esi
  802de8:	5f                   	pop    %edi
  802de9:	5d                   	pop    %ebp
  802dea:	c3                   	ret    

00802deb <devpipe_write>:
{
  802deb:	55                   	push   %ebp
  802dec:	89 e5                	mov    %esp,%ebp
  802dee:	57                   	push   %edi
  802def:	56                   	push   %esi
  802df0:	53                   	push   %ebx
  802df1:	83 ec 28             	sub    $0x28,%esp
  802df4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802df7:	56                   	push   %esi
  802df8:	e8 34 f0 ff ff       	call   801e31 <fd2data>
  802dfd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802dff:	83 c4 10             	add    $0x10,%esp
  802e02:	bf 00 00 00 00       	mov    $0x0,%edi
  802e07:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802e0a:	74 4f                	je     802e5b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e0c:	8b 43 04             	mov    0x4(%ebx),%eax
  802e0f:	8b 0b                	mov    (%ebx),%ecx
  802e11:	8d 51 20             	lea    0x20(%ecx),%edx
  802e14:	39 d0                	cmp    %edx,%eax
  802e16:	72 14                	jb     802e2c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802e18:	89 da                	mov    %ebx,%edx
  802e1a:	89 f0                	mov    %esi,%eax
  802e1c:	e8 65 ff ff ff       	call   802d86 <_pipeisclosed>
  802e21:	85 c0                	test   %eax,%eax
  802e23:	75 3b                	jne    802e60 <devpipe_write+0x75>
			sys_yield();
  802e25:	e8 e7 e8 ff ff       	call   801711 <sys_yield>
  802e2a:	eb e0                	jmp    802e0c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e2f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802e33:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802e36:	89 c2                	mov    %eax,%edx
  802e38:	c1 fa 1f             	sar    $0x1f,%edx
  802e3b:	89 d1                	mov    %edx,%ecx
  802e3d:	c1 e9 1b             	shr    $0x1b,%ecx
  802e40:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802e43:	83 e2 1f             	and    $0x1f,%edx
  802e46:	29 ca                	sub    %ecx,%edx
  802e48:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802e4c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802e50:	83 c0 01             	add    $0x1,%eax
  802e53:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802e56:	83 c7 01             	add    $0x1,%edi
  802e59:	eb ac                	jmp    802e07 <devpipe_write+0x1c>
	return i;
  802e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  802e5e:	eb 05                	jmp    802e65 <devpipe_write+0x7a>
				return 0;
  802e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e68:	5b                   	pop    %ebx
  802e69:	5e                   	pop    %esi
  802e6a:	5f                   	pop    %edi
  802e6b:	5d                   	pop    %ebp
  802e6c:	c3                   	ret    

00802e6d <devpipe_read>:
{
  802e6d:	55                   	push   %ebp
  802e6e:	89 e5                	mov    %esp,%ebp
  802e70:	57                   	push   %edi
  802e71:	56                   	push   %esi
  802e72:	53                   	push   %ebx
  802e73:	83 ec 18             	sub    $0x18,%esp
  802e76:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802e79:	57                   	push   %edi
  802e7a:	e8 b2 ef ff ff       	call   801e31 <fd2data>
  802e7f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802e81:	83 c4 10             	add    $0x10,%esp
  802e84:	be 00 00 00 00       	mov    $0x0,%esi
  802e89:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e8c:	75 14                	jne    802ea2 <devpipe_read+0x35>
	return i;
  802e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  802e91:	eb 02                	jmp    802e95 <devpipe_read+0x28>
				return i;
  802e93:	89 f0                	mov    %esi,%eax
}
  802e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e98:	5b                   	pop    %ebx
  802e99:	5e                   	pop    %esi
  802e9a:	5f                   	pop    %edi
  802e9b:	5d                   	pop    %ebp
  802e9c:	c3                   	ret    
			sys_yield();
  802e9d:	e8 6f e8 ff ff       	call   801711 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802ea2:	8b 03                	mov    (%ebx),%eax
  802ea4:	3b 43 04             	cmp    0x4(%ebx),%eax
  802ea7:	75 18                	jne    802ec1 <devpipe_read+0x54>
			if (i > 0)
  802ea9:	85 f6                	test   %esi,%esi
  802eab:	75 e6                	jne    802e93 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802ead:	89 da                	mov    %ebx,%edx
  802eaf:	89 f8                	mov    %edi,%eax
  802eb1:	e8 d0 fe ff ff       	call   802d86 <_pipeisclosed>
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	74 e3                	je     802e9d <devpipe_read+0x30>
				return 0;
  802eba:	b8 00 00 00 00       	mov    $0x0,%eax
  802ebf:	eb d4                	jmp    802e95 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ec1:	99                   	cltd   
  802ec2:	c1 ea 1b             	shr    $0x1b,%edx
  802ec5:	01 d0                	add    %edx,%eax
  802ec7:	83 e0 1f             	and    $0x1f,%eax
  802eca:	29 d0                	sub    %edx,%eax
  802ecc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ed4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802ed7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802eda:	83 c6 01             	add    $0x1,%esi
  802edd:	eb aa                	jmp    802e89 <devpipe_read+0x1c>

00802edf <pipe>:
{
  802edf:	55                   	push   %ebp
  802ee0:	89 e5                	mov    %esp,%ebp
  802ee2:	56                   	push   %esi
  802ee3:	53                   	push   %ebx
  802ee4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802ee7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eea:	50                   	push   %eax
  802eeb:	e8 58 ef ff ff       	call   801e48 <fd_alloc>
  802ef0:	89 c3                	mov    %eax,%ebx
  802ef2:	83 c4 10             	add    $0x10,%esp
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	0f 88 23 01 00 00    	js     803020 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802efd:	83 ec 04             	sub    $0x4,%esp
  802f00:	68 07 04 00 00       	push   $0x407
  802f05:	ff 75 f4             	pushl  -0xc(%ebp)
  802f08:	6a 00                	push   $0x0
  802f0a:	e8 21 e8 ff ff       	call   801730 <sys_page_alloc>
  802f0f:	89 c3                	mov    %eax,%ebx
  802f11:	83 c4 10             	add    $0x10,%esp
  802f14:	85 c0                	test   %eax,%eax
  802f16:	0f 88 04 01 00 00    	js     803020 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802f1c:	83 ec 0c             	sub    $0xc,%esp
  802f1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f22:	50                   	push   %eax
  802f23:	e8 20 ef ff ff       	call   801e48 <fd_alloc>
  802f28:	89 c3                	mov    %eax,%ebx
  802f2a:	83 c4 10             	add    $0x10,%esp
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	0f 88 db 00 00 00    	js     803010 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 07 04 00 00       	push   $0x407
  802f3d:	ff 75 f0             	pushl  -0x10(%ebp)
  802f40:	6a 00                	push   $0x0
  802f42:	e8 e9 e7 ff ff       	call   801730 <sys_page_alloc>
  802f47:	89 c3                	mov    %eax,%ebx
  802f49:	83 c4 10             	add    $0x10,%esp
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	0f 88 bc 00 00 00    	js     803010 <pipe+0x131>
	va = fd2data(fd0);
  802f54:	83 ec 0c             	sub    $0xc,%esp
  802f57:	ff 75 f4             	pushl  -0xc(%ebp)
  802f5a:	e8 d2 ee ff ff       	call   801e31 <fd2data>
  802f5f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f61:	83 c4 0c             	add    $0xc,%esp
  802f64:	68 07 04 00 00       	push   $0x407
  802f69:	50                   	push   %eax
  802f6a:	6a 00                	push   $0x0
  802f6c:	e8 bf e7 ff ff       	call   801730 <sys_page_alloc>
  802f71:	89 c3                	mov    %eax,%ebx
  802f73:	83 c4 10             	add    $0x10,%esp
  802f76:	85 c0                	test   %eax,%eax
  802f78:	0f 88 82 00 00 00    	js     803000 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f7e:	83 ec 0c             	sub    $0xc,%esp
  802f81:	ff 75 f0             	pushl  -0x10(%ebp)
  802f84:	e8 a8 ee ff ff       	call   801e31 <fd2data>
  802f89:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802f90:	50                   	push   %eax
  802f91:	6a 00                	push   $0x0
  802f93:	56                   	push   %esi
  802f94:	6a 00                	push   $0x0
  802f96:	e8 d8 e7 ff ff       	call   801773 <sys_page_map>
  802f9b:	89 c3                	mov    %eax,%ebx
  802f9d:	83 c4 20             	add    $0x20,%esp
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	78 4e                	js     802ff2 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802fa4:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fac:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802fb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fbb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802fc7:	83 ec 0c             	sub    $0xc,%esp
  802fca:	ff 75 f4             	pushl  -0xc(%ebp)
  802fcd:	e8 4f ee ff ff       	call   801e21 <fd2num>
  802fd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fd5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802fd7:	83 c4 04             	add    $0x4,%esp
  802fda:	ff 75 f0             	pushl  -0x10(%ebp)
  802fdd:	e8 3f ee ff ff       	call   801e21 <fd2num>
  802fe2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fe5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802fe8:	83 c4 10             	add    $0x10,%esp
  802feb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ff0:	eb 2e                	jmp    803020 <pipe+0x141>
	sys_page_unmap(0, va);
  802ff2:	83 ec 08             	sub    $0x8,%esp
  802ff5:	56                   	push   %esi
  802ff6:	6a 00                	push   $0x0
  802ff8:	e8 b8 e7 ff ff       	call   8017b5 <sys_page_unmap>
  802ffd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803000:	83 ec 08             	sub    $0x8,%esp
  803003:	ff 75 f0             	pushl  -0x10(%ebp)
  803006:	6a 00                	push   $0x0
  803008:	e8 a8 e7 ff ff       	call   8017b5 <sys_page_unmap>
  80300d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803010:	83 ec 08             	sub    $0x8,%esp
  803013:	ff 75 f4             	pushl  -0xc(%ebp)
  803016:	6a 00                	push   $0x0
  803018:	e8 98 e7 ff ff       	call   8017b5 <sys_page_unmap>
  80301d:	83 c4 10             	add    $0x10,%esp
}
  803020:	89 d8                	mov    %ebx,%eax
  803022:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803025:	5b                   	pop    %ebx
  803026:	5e                   	pop    %esi
  803027:	5d                   	pop    %ebp
  803028:	c3                   	ret    

00803029 <pipeisclosed>:
{
  803029:	55                   	push   %ebp
  80302a:	89 e5                	mov    %esp,%ebp
  80302c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80302f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803032:	50                   	push   %eax
  803033:	ff 75 08             	pushl  0x8(%ebp)
  803036:	e8 5f ee ff ff       	call   801e9a <fd_lookup>
  80303b:	83 c4 10             	add    $0x10,%esp
  80303e:	85 c0                	test   %eax,%eax
  803040:	78 18                	js     80305a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803042:	83 ec 0c             	sub    $0xc,%esp
  803045:	ff 75 f4             	pushl  -0xc(%ebp)
  803048:	e8 e4 ed ff ff       	call   801e31 <fd2data>
	return _pipeisclosed(fd, p);
  80304d:	89 c2                	mov    %eax,%edx
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	e8 2f fd ff ff       	call   802d86 <_pipeisclosed>
  803057:	83 c4 10             	add    $0x10,%esp
}
  80305a:	c9                   	leave  
  80305b:	c3                   	ret    

0080305c <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80305c:	55                   	push   %ebp
  80305d:	89 e5                	mov    %esp,%ebp
  80305f:	56                   	push   %esi
  803060:	53                   	push   %ebx
  803061:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803064:	85 f6                	test   %esi,%esi
  803066:	74 15                	je     80307d <wait+0x21>
	e = &envs[ENVX(envid)];
  803068:	89 f0                	mov    %esi,%eax
  80306a:	25 ff 03 00 00       	and    $0x3ff,%eax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80306f:	8d 1c c0             	lea    (%eax,%eax,8),%ebx
  803072:	c1 e3 04             	shl    $0x4,%ebx
  803075:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80307b:	eb 1b                	jmp    803098 <wait+0x3c>
	assert(envid != 0);
  80307d:	68 47 3d 80 00       	push   $0x803d47
  803082:	68 06 36 80 00       	push   $0x803606
  803087:	6a 09                	push   $0x9
  803089:	68 52 3d 80 00       	push   $0x803d52
  80308e:	e8 d2 d9 ff ff       	call   800a65 <_panic>
		sys_yield();
  803093:	e8 79 e6 ff ff       	call   801711 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803098:	8b 43 48             	mov    0x48(%ebx),%eax
  80309b:	39 f0                	cmp    %esi,%eax
  80309d:	75 07                	jne    8030a6 <wait+0x4a>
  80309f:	8b 43 54             	mov    0x54(%ebx),%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	75 ed                	jne    803093 <wait+0x37>
}
  8030a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030a9:	5b                   	pop    %ebx
  8030aa:	5e                   	pop    %esi
  8030ab:	5d                   	pop    %ebp
  8030ac:	c3                   	ret    

008030ad <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8030ad:	55                   	push   %ebp
  8030ae:	89 e5                	mov    %esp,%ebp
  8030b0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8030b3:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8030ba:	74 0a                	je     8030c6 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8030c4:	c9                   	leave  
  8030c5:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	6a 07                	push   $0x7
  8030cb:	68 00 f0 bf ee       	push   $0xeebff000
  8030d0:	6a 00                	push   $0x0
  8030d2:	e8 59 e6 ff ff       	call   801730 <sys_page_alloc>
  8030d7:	83 c4 10             	add    $0x10,%esp
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	78 28                	js     803106 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8030de:	83 ec 08             	sub    $0x8,%esp
  8030e1:	68 18 31 80 00       	push   $0x803118
  8030e6:	6a 00                	push   $0x0
  8030e8:	e8 cf e7 ff ff       	call   8018bc <sys_env_set_pgfault_upcall>
  8030ed:	83 c4 10             	add    $0x10,%esp
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	79 c8                	jns    8030bc <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8030f4:	50                   	push   %eax
  8030f5:	68 24 3b 80 00       	push   $0x803b24
  8030fa:	6a 23                	push   $0x23
  8030fc:	68 75 3d 80 00       	push   $0x803d75
  803101:	e8 5f d9 ff ff       	call   800a65 <_panic>
			panic("set_pgfault_handler %e\n",r);
  803106:	50                   	push   %eax
  803107:	68 5d 3d 80 00       	push   $0x803d5d
  80310c:	6a 21                	push   $0x21
  80310e:	68 75 3d 80 00       	push   $0x803d75
  803113:	e8 4d d9 ff ff       	call   800a65 <_panic>

00803118 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803118:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803119:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80311e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803120:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  803123:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  803127:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80312b:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80312e:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803130:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  803134:	83 c4 08             	add    $0x8,%esp
	popal
  803137:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803138:	83 c4 04             	add    $0x4,%esp
	popfl
  80313b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80313c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80313d:	c3                   	ret    

0080313e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80313e:	55                   	push   %ebp
  80313f:	89 e5                	mov    %esp,%ebp
  803141:	56                   	push   %esi
  803142:	53                   	push   %ebx
  803143:	8b 75 08             	mov    0x8(%ebp),%esi
  803146:	8b 45 0c             	mov    0xc(%ebp),%eax
  803149:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  80314c:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  80314e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803153:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  803156:	83 ec 0c             	sub    $0xc,%esp
  803159:	50                   	push   %eax
  80315a:	e8 c2 e7 ff ff       	call   801921 <sys_ipc_recv>
	if (from_env_store)
  80315f:	83 c4 10             	add    $0x10,%esp
  803162:	85 f6                	test   %esi,%esi
  803164:	74 14                	je     80317a <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  803166:	ba 00 00 00 00       	mov    $0x0,%edx
  80316b:	85 c0                	test   %eax,%eax
  80316d:	78 09                	js     803178 <ipc_recv+0x3a>
  80316f:	8b 15 24 54 80 00    	mov    0x805424,%edx
  803175:	8b 52 78             	mov    0x78(%edx),%edx
  803178:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  80317a:	85 db                	test   %ebx,%ebx
  80317c:	74 14                	je     803192 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  80317e:	ba 00 00 00 00       	mov    $0x0,%edx
  803183:	85 c0                	test   %eax,%eax
  803185:	78 09                	js     803190 <ipc_recv+0x52>
  803187:	8b 15 24 54 80 00    	mov    0x805424,%edx
  80318d:	8b 52 7c             	mov    0x7c(%edx),%edx
  803190:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  803192:	85 c0                	test   %eax,%eax
  803194:	78 08                	js     80319e <ipc_recv+0x60>
  803196:	a1 24 54 80 00       	mov    0x805424,%eax
  80319b:	8b 40 74             	mov    0x74(%eax),%eax
}
  80319e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031a1:	5b                   	pop    %ebx
  8031a2:	5e                   	pop    %esi
  8031a3:	5d                   	pop    %ebp
  8031a4:	c3                   	ret    

008031a5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8031a5:	55                   	push   %ebp
  8031a6:	89 e5                	mov    %esp,%ebp
  8031a8:	83 ec 08             	sub    $0x8,%esp
  8031ab:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8031b5:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8031b8:	ff 75 14             	pushl  0x14(%ebp)
  8031bb:	50                   	push   %eax
  8031bc:	ff 75 0c             	pushl  0xc(%ebp)
  8031bf:	ff 75 08             	pushl  0x8(%ebp)
  8031c2:	e8 37 e7 ff ff       	call   8018fe <sys_ipc_try_send>
  8031c7:	83 c4 10             	add    $0x10,%esp
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	78 02                	js     8031d0 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  8031ce:	c9                   	leave  
  8031cf:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  8031d0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8031d3:	75 07                	jne    8031dc <ipc_send+0x37>
		sys_yield();
  8031d5:	e8 37 e5 ff ff       	call   801711 <sys_yield>
}
  8031da:	eb f2                	jmp    8031ce <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  8031dc:	50                   	push   %eax
  8031dd:	68 83 3d 80 00       	push   $0x803d83
  8031e2:	6a 3c                	push   $0x3c
  8031e4:	68 97 3d 80 00       	push   $0x803d97
  8031e9:	e8 77 d8 ff ff       	call   800a65 <_panic>

008031ee <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8031ee:	55                   	push   %ebp
  8031ef:	89 e5                	mov    %esp,%ebp
  8031f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8031f4:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  8031f9:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8031fc:	c1 e0 04             	shl    $0x4,%eax
  8031ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803204:	8b 40 50             	mov    0x50(%eax),%eax
  803207:	39 c8                	cmp    %ecx,%eax
  803209:	74 12                	je     80321d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80320b:	83 c2 01             	add    $0x1,%edx
  80320e:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  803214:	75 e3                	jne    8031f9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  803216:	b8 00 00 00 00       	mov    $0x0,%eax
  80321b:	eb 0e                	jmp    80322b <ipc_find_env+0x3d>
			return envs[i].env_id;
  80321d:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  803220:	c1 e0 04             	shl    $0x4,%eax
  803223:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803228:	8b 40 48             	mov    0x48(%eax),%eax
}
  80322b:	5d                   	pop    %ebp
  80322c:	c3                   	ret    

0080322d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80322d:	55                   	push   %ebp
  80322e:	89 e5                	mov    %esp,%ebp
  803230:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803233:	89 d0                	mov    %edx,%eax
  803235:	c1 e8 16             	shr    $0x16,%eax
  803238:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80323f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803244:	f6 c1 01             	test   $0x1,%cl
  803247:	74 1d                	je     803266 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803249:	c1 ea 0c             	shr    $0xc,%edx
  80324c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803253:	f6 c2 01             	test   $0x1,%dl
  803256:	74 0e                	je     803266 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803258:	c1 ea 0c             	shr    $0xc,%edx
  80325b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803262:	ef 
  803263:	0f b7 c0             	movzwl %ax,%eax
}
  803266:	5d                   	pop    %ebp
  803267:	c3                   	ret    
  803268:	66 90                	xchg   %ax,%ax
  80326a:	66 90                	xchg   %ax,%ax
  80326c:	66 90                	xchg   %ax,%ax
  80326e:	66 90                	xchg   %ax,%ax

00803270 <__udivdi3>:
  803270:	55                   	push   %ebp
  803271:	57                   	push   %edi
  803272:	56                   	push   %esi
  803273:	53                   	push   %ebx
  803274:	83 ec 1c             	sub    $0x1c,%esp
  803277:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80327b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80327f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803283:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803287:	85 d2                	test   %edx,%edx
  803289:	75 4d                	jne    8032d8 <__udivdi3+0x68>
  80328b:	39 f3                	cmp    %esi,%ebx
  80328d:	76 19                	jbe    8032a8 <__udivdi3+0x38>
  80328f:	31 ff                	xor    %edi,%edi
  803291:	89 e8                	mov    %ebp,%eax
  803293:	89 f2                	mov    %esi,%edx
  803295:	f7 f3                	div    %ebx
  803297:	89 fa                	mov    %edi,%edx
  803299:	83 c4 1c             	add    $0x1c,%esp
  80329c:	5b                   	pop    %ebx
  80329d:	5e                   	pop    %esi
  80329e:	5f                   	pop    %edi
  80329f:	5d                   	pop    %ebp
  8032a0:	c3                   	ret    
  8032a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032a8:	89 d9                	mov    %ebx,%ecx
  8032aa:	85 db                	test   %ebx,%ebx
  8032ac:	75 0b                	jne    8032b9 <__udivdi3+0x49>
  8032ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b3:	31 d2                	xor    %edx,%edx
  8032b5:	f7 f3                	div    %ebx
  8032b7:	89 c1                	mov    %eax,%ecx
  8032b9:	31 d2                	xor    %edx,%edx
  8032bb:	89 f0                	mov    %esi,%eax
  8032bd:	f7 f1                	div    %ecx
  8032bf:	89 c6                	mov    %eax,%esi
  8032c1:	89 e8                	mov    %ebp,%eax
  8032c3:	89 f7                	mov    %esi,%edi
  8032c5:	f7 f1                	div    %ecx
  8032c7:	89 fa                	mov    %edi,%edx
  8032c9:	83 c4 1c             	add    $0x1c,%esp
  8032cc:	5b                   	pop    %ebx
  8032cd:	5e                   	pop    %esi
  8032ce:	5f                   	pop    %edi
  8032cf:	5d                   	pop    %ebp
  8032d0:	c3                   	ret    
  8032d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032d8:	39 f2                	cmp    %esi,%edx
  8032da:	77 1c                	ja     8032f8 <__udivdi3+0x88>
  8032dc:	0f bd fa             	bsr    %edx,%edi
  8032df:	83 f7 1f             	xor    $0x1f,%edi
  8032e2:	75 2c                	jne    803310 <__udivdi3+0xa0>
  8032e4:	39 f2                	cmp    %esi,%edx
  8032e6:	72 06                	jb     8032ee <__udivdi3+0x7e>
  8032e8:	31 c0                	xor    %eax,%eax
  8032ea:	39 eb                	cmp    %ebp,%ebx
  8032ec:	77 a9                	ja     803297 <__udivdi3+0x27>
  8032ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8032f3:	eb a2                	jmp    803297 <__udivdi3+0x27>
  8032f5:	8d 76 00             	lea    0x0(%esi),%esi
  8032f8:	31 ff                	xor    %edi,%edi
  8032fa:	31 c0                	xor    %eax,%eax
  8032fc:	89 fa                	mov    %edi,%edx
  8032fe:	83 c4 1c             	add    $0x1c,%esp
  803301:	5b                   	pop    %ebx
  803302:	5e                   	pop    %esi
  803303:	5f                   	pop    %edi
  803304:	5d                   	pop    %ebp
  803305:	c3                   	ret    
  803306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80330d:	8d 76 00             	lea    0x0(%esi),%esi
  803310:	89 f9                	mov    %edi,%ecx
  803312:	b8 20 00 00 00       	mov    $0x20,%eax
  803317:	29 f8                	sub    %edi,%eax
  803319:	d3 e2                	shl    %cl,%edx
  80331b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80331f:	89 c1                	mov    %eax,%ecx
  803321:	89 da                	mov    %ebx,%edx
  803323:	d3 ea                	shr    %cl,%edx
  803325:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803329:	09 d1                	or     %edx,%ecx
  80332b:	89 f2                	mov    %esi,%edx
  80332d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803331:	89 f9                	mov    %edi,%ecx
  803333:	d3 e3                	shl    %cl,%ebx
  803335:	89 c1                	mov    %eax,%ecx
  803337:	d3 ea                	shr    %cl,%edx
  803339:	89 f9                	mov    %edi,%ecx
  80333b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80333f:	89 eb                	mov    %ebp,%ebx
  803341:	d3 e6                	shl    %cl,%esi
  803343:	89 c1                	mov    %eax,%ecx
  803345:	d3 eb                	shr    %cl,%ebx
  803347:	09 de                	or     %ebx,%esi
  803349:	89 f0                	mov    %esi,%eax
  80334b:	f7 74 24 08          	divl   0x8(%esp)
  80334f:	89 d6                	mov    %edx,%esi
  803351:	89 c3                	mov    %eax,%ebx
  803353:	f7 64 24 0c          	mull   0xc(%esp)
  803357:	39 d6                	cmp    %edx,%esi
  803359:	72 15                	jb     803370 <__udivdi3+0x100>
  80335b:	89 f9                	mov    %edi,%ecx
  80335d:	d3 e5                	shl    %cl,%ebp
  80335f:	39 c5                	cmp    %eax,%ebp
  803361:	73 04                	jae    803367 <__udivdi3+0xf7>
  803363:	39 d6                	cmp    %edx,%esi
  803365:	74 09                	je     803370 <__udivdi3+0x100>
  803367:	89 d8                	mov    %ebx,%eax
  803369:	31 ff                	xor    %edi,%edi
  80336b:	e9 27 ff ff ff       	jmp    803297 <__udivdi3+0x27>
  803370:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803373:	31 ff                	xor    %edi,%edi
  803375:	e9 1d ff ff ff       	jmp    803297 <__udivdi3+0x27>
  80337a:	66 90                	xchg   %ax,%ax
  80337c:	66 90                	xchg   %ax,%ax
  80337e:	66 90                	xchg   %ax,%ax

00803380 <__umoddi3>:
  803380:	55                   	push   %ebp
  803381:	57                   	push   %edi
  803382:	56                   	push   %esi
  803383:	53                   	push   %ebx
  803384:	83 ec 1c             	sub    $0x1c,%esp
  803387:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80338b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80338f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803393:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803397:	89 da                	mov    %ebx,%edx
  803399:	85 c0                	test   %eax,%eax
  80339b:	75 43                	jne    8033e0 <__umoddi3+0x60>
  80339d:	39 df                	cmp    %ebx,%edi
  80339f:	76 17                	jbe    8033b8 <__umoddi3+0x38>
  8033a1:	89 f0                	mov    %esi,%eax
  8033a3:	f7 f7                	div    %edi
  8033a5:	89 d0                	mov    %edx,%eax
  8033a7:	31 d2                	xor    %edx,%edx
  8033a9:	83 c4 1c             	add    $0x1c,%esp
  8033ac:	5b                   	pop    %ebx
  8033ad:	5e                   	pop    %esi
  8033ae:	5f                   	pop    %edi
  8033af:	5d                   	pop    %ebp
  8033b0:	c3                   	ret    
  8033b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033b8:	89 fd                	mov    %edi,%ebp
  8033ba:	85 ff                	test   %edi,%edi
  8033bc:	75 0b                	jne    8033c9 <__umoddi3+0x49>
  8033be:	b8 01 00 00 00       	mov    $0x1,%eax
  8033c3:	31 d2                	xor    %edx,%edx
  8033c5:	f7 f7                	div    %edi
  8033c7:	89 c5                	mov    %eax,%ebp
  8033c9:	89 d8                	mov    %ebx,%eax
  8033cb:	31 d2                	xor    %edx,%edx
  8033cd:	f7 f5                	div    %ebp
  8033cf:	89 f0                	mov    %esi,%eax
  8033d1:	f7 f5                	div    %ebp
  8033d3:	89 d0                	mov    %edx,%eax
  8033d5:	eb d0                	jmp    8033a7 <__umoddi3+0x27>
  8033d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033de:	66 90                	xchg   %ax,%ax
  8033e0:	89 f1                	mov    %esi,%ecx
  8033e2:	39 d8                	cmp    %ebx,%eax
  8033e4:	76 0a                	jbe    8033f0 <__umoddi3+0x70>
  8033e6:	89 f0                	mov    %esi,%eax
  8033e8:	83 c4 1c             	add    $0x1c,%esp
  8033eb:	5b                   	pop    %ebx
  8033ec:	5e                   	pop    %esi
  8033ed:	5f                   	pop    %edi
  8033ee:	5d                   	pop    %ebp
  8033ef:	c3                   	ret    
  8033f0:	0f bd e8             	bsr    %eax,%ebp
  8033f3:	83 f5 1f             	xor    $0x1f,%ebp
  8033f6:	75 20                	jne    803418 <__umoddi3+0x98>
  8033f8:	39 d8                	cmp    %ebx,%eax
  8033fa:	0f 82 b0 00 00 00    	jb     8034b0 <__umoddi3+0x130>
  803400:	39 f7                	cmp    %esi,%edi
  803402:	0f 86 a8 00 00 00    	jbe    8034b0 <__umoddi3+0x130>
  803408:	89 c8                	mov    %ecx,%eax
  80340a:	83 c4 1c             	add    $0x1c,%esp
  80340d:	5b                   	pop    %ebx
  80340e:	5e                   	pop    %esi
  80340f:	5f                   	pop    %edi
  803410:	5d                   	pop    %ebp
  803411:	c3                   	ret    
  803412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803418:	89 e9                	mov    %ebp,%ecx
  80341a:	ba 20 00 00 00       	mov    $0x20,%edx
  80341f:	29 ea                	sub    %ebp,%edx
  803421:	d3 e0                	shl    %cl,%eax
  803423:	89 44 24 08          	mov    %eax,0x8(%esp)
  803427:	89 d1                	mov    %edx,%ecx
  803429:	89 f8                	mov    %edi,%eax
  80342b:	d3 e8                	shr    %cl,%eax
  80342d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803431:	89 54 24 04          	mov    %edx,0x4(%esp)
  803435:	8b 54 24 04          	mov    0x4(%esp),%edx
  803439:	09 c1                	or     %eax,%ecx
  80343b:	89 d8                	mov    %ebx,%eax
  80343d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803441:	89 e9                	mov    %ebp,%ecx
  803443:	d3 e7                	shl    %cl,%edi
  803445:	89 d1                	mov    %edx,%ecx
  803447:	d3 e8                	shr    %cl,%eax
  803449:	89 e9                	mov    %ebp,%ecx
  80344b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80344f:	d3 e3                	shl    %cl,%ebx
  803451:	89 c7                	mov    %eax,%edi
  803453:	89 d1                	mov    %edx,%ecx
  803455:	89 f0                	mov    %esi,%eax
  803457:	d3 e8                	shr    %cl,%eax
  803459:	89 e9                	mov    %ebp,%ecx
  80345b:	89 fa                	mov    %edi,%edx
  80345d:	d3 e6                	shl    %cl,%esi
  80345f:	09 d8                	or     %ebx,%eax
  803461:	f7 74 24 08          	divl   0x8(%esp)
  803465:	89 d1                	mov    %edx,%ecx
  803467:	89 f3                	mov    %esi,%ebx
  803469:	f7 64 24 0c          	mull   0xc(%esp)
  80346d:	89 c6                	mov    %eax,%esi
  80346f:	89 d7                	mov    %edx,%edi
  803471:	39 d1                	cmp    %edx,%ecx
  803473:	72 06                	jb     80347b <__umoddi3+0xfb>
  803475:	75 10                	jne    803487 <__umoddi3+0x107>
  803477:	39 c3                	cmp    %eax,%ebx
  803479:	73 0c                	jae    803487 <__umoddi3+0x107>
  80347b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80347f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803483:	89 d7                	mov    %edx,%edi
  803485:	89 c6                	mov    %eax,%esi
  803487:	89 ca                	mov    %ecx,%edx
  803489:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80348e:	29 f3                	sub    %esi,%ebx
  803490:	19 fa                	sbb    %edi,%edx
  803492:	89 d0                	mov    %edx,%eax
  803494:	d3 e0                	shl    %cl,%eax
  803496:	89 e9                	mov    %ebp,%ecx
  803498:	d3 eb                	shr    %cl,%ebx
  80349a:	d3 ea                	shr    %cl,%edx
  80349c:	09 d8                	or     %ebx,%eax
  80349e:	83 c4 1c             	add    $0x1c,%esp
  8034a1:	5b                   	pop    %ebx
  8034a2:	5e                   	pop    %esi
  8034a3:	5f                   	pop    %edi
  8034a4:	5d                   	pop    %ebp
  8034a5:	c3                   	ret    
  8034a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8034ad:	8d 76 00             	lea    0x0(%esi),%esi
  8034b0:	89 da                	mov    %ebx,%edx
  8034b2:	29 fe                	sub    %edi,%esi
  8034b4:	19 c2                	sbb    %eax,%edx
  8034b6:	89 f1                	mov    %esi,%ecx
  8034b8:	89 c8                	mov    %ecx,%eax
  8034ba:	e9 4b ff ff ff       	jmp    80340a <__umoddi3+0x8a>
