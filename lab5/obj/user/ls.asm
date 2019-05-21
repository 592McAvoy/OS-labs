
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 02 24 80 00       	push   $0x802402
  80005f:	e8 42 1b 00 00       	call   801ba6 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 68 24 80 00       	mov    $0x802468,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 0b 24 80 00       	push   $0x80240b
  80007f:	e8 22 1b 00 00       	call   801ba6 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 15 29 80 00       	push   $0x802915
  800092:	e8 0f 1b 00 00       	call   801ba6 <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 67 24 80 00       	push   $0x802467
  8000b1:	e8 f0 1a 00 00       	call   801ba6 <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 08 0a 00 00       	call   800ad1 <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 00 24 80 00       	mov    $0x802400,%eax
  8000d6:	ba 68 24 80 00       	mov    $0x802468,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 00 24 80 00       	push   $0x802400
  8000e8:	e8 b9 1a 00 00       	call   801ba6 <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 fa 18 00 00       	call   801a03 <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 00 15 00 00       	call   801627 <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 10 24 80 00       	push   $0x802410
  800166:	6a 1d                	push   $0x1d
  800168:	68 1c 24 80 00       	push   $0x80241c
  80016d:	e8 af 01 00 00       	call   800321 <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0a                	jg     800180 <lsdir+0x8e>
	if (n < 0)
  800176:	78 1a                	js     800192 <lsdir+0xa0>
}
  800178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017b:	5b                   	pop    %ebx
  80017c:	5e                   	pop    %esi
  80017d:	5f                   	pop    %edi
  80017e:	5d                   	pop    %ebp
  80017f:	c3                   	ret    
		panic("short read in directory %s", path);
  800180:	57                   	push   %edi
  800181:	68 26 24 80 00       	push   $0x802426
  800186:	6a 22                	push   $0x22
  800188:	68 1c 24 80 00       	push   $0x80241c
  80018d:	e8 8f 01 00 00       	call   800321 <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 6c 24 80 00       	push   $0x80246c
  80019c:	6a 24                	push   $0x24
  80019e:	68 1c 24 80 00       	push   $0x80241c
  8001a3:	e8 79 01 00 00       	call   800321 <_panic>

008001a8 <ls>:
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b5:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	53                   	push   %ebx
  8001bd:	e8 48 16 00 00       	call   80180a <stat>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	78 2c                	js     8001f5 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	74 09                	je     8001d9 <ls+0x31>
  8001d0:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001d7:	74 32                	je     80020b <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001d9:	53                   	push   %ebx
  8001da:	ff 75 ec             	pushl  -0x14(%ebp)
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	0f 95 c0             	setne  %al
  8001e2:	0f b6 c0             	movzbl %al,%eax
  8001e5:	50                   	push   %eax
  8001e6:	6a 00                	push   $0x0
  8001e8:	e8 46 fe ff ff       	call   800033 <ls1>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	53                   	push   %ebx
  8001fa:	68 41 24 80 00       	push   $0x802441
  8001ff:	6a 0f                	push   $0xf
  800201:	68 1c 24 80 00       	push   $0x80241c
  800206:	e8 16 01 00 00       	call   800321 <_panic>
		lsdir(path, prefix);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	ff 75 0c             	pushl  0xc(%ebp)
  800211:	53                   	push   %ebx
  800212:	e8 db fe ff ff       	call   8000f2 <lsdir>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	eb d4                	jmp    8001f0 <ls+0x48>

0080021c <usage>:

void
usage(void)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800222:	68 4d 24 80 00       	push   $0x80244d
  800227:	e8 7a 19 00 00       	call   801ba6 <printf>
	exit();
  80022c:	e8 de 00 00 00       	call   80030f <exit>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <umain>:

void
umain(int argc, char **argv)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	56                   	push   %esi
  80023a:	53                   	push   %ebx
  80023b:	83 ec 14             	sub    $0x14,%esp
  80023e:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800241:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800244:	50                   	push   %eax
  800245:	56                   	push   %esi
  800246:	8d 45 08             	lea    0x8(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 20 0f 00 00       	call   80116f <argstart>
	while ((i = argnext(&args)) >= 0)
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800255:	eb 08                	jmp    80025f <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800257:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  80025e:	01 
	while ((i = argnext(&args)) >= 0)
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	53                   	push   %ebx
  800263:	e8 37 0f 00 00       	call   80119f <argnext>
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	85 c0                	test   %eax,%eax
  80026d:	78 16                	js     800285 <umain+0x4f>
		switch (i) {
  80026f:	83 f8 64             	cmp    $0x64,%eax
  800272:	74 e3                	je     800257 <umain+0x21>
  800274:	83 f8 6c             	cmp    $0x6c,%eax
  800277:	74 de                	je     800257 <umain+0x21>
  800279:	83 f8 46             	cmp    $0x46,%eax
  80027c:	74 d9                	je     800257 <umain+0x21>
			break;
		default:
			usage();
  80027e:	e8 99 ff ff ff       	call   80021c <usage>
  800283:	eb da                	jmp    80025f <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800285:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80028e:	75 2a                	jne    8002ba <umain+0x84>
		ls("/", "");
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	68 68 24 80 00       	push   $0x802468
  800298:	68 00 24 80 00       	push   $0x802400
  80029d:	e8 06 ff ff ff       	call   8001a8 <ls>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	eb 18                	jmp    8002bf <umain+0x89>
			ls(argv[i], argv[i]);
  8002a7:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	50                   	push   %eax
  8002af:	e8 f4 fe ff ff       	call   8001a8 <ls>
		for (i = 1; i < argc; i++)
  8002b4:	83 c3 01             	add    $0x1,%ebx
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bd:	7f e8                	jg     8002a7 <umain+0x71>
	}
}
  8002bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002ce:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002d1:	e8 e8 0b 00 00       	call   800ebe <sys_getenvid>
  8002d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002db:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8002de:	c1 e0 04             	shl    $0x4,%eax
  8002e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e6:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002eb:	85 db                	test   %ebx,%ebx
  8002ed:	7e 07                	jle    8002f6 <libmain+0x30>
		binaryname = argv[0];
  8002ef:	8b 06                	mov    (%esi),%eax
  8002f1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f6:	83 ec 08             	sub    $0x8,%esp
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	e8 36 ff ff ff       	call   800236 <umain>

	// exit gracefully
	exit();
  800300:	e8 0a 00 00 00       	call   80030f <exit>
}
  800305:	83 c4 10             	add    $0x10,%esp
  800308:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80030b:	5b                   	pop    %ebx
  80030c:	5e                   	pop    %esi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800315:	6a 00                	push   $0x0
  800317:	e8 61 0b 00 00       	call   800e7d <sys_env_destroy>
}
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800326:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800329:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80032f:	e8 8a 0b 00 00       	call   800ebe <sys_getenvid>
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	ff 75 0c             	pushl  0xc(%ebp)
  80033a:	ff 75 08             	pushl  0x8(%ebp)
  80033d:	56                   	push   %esi
  80033e:	50                   	push   %eax
  80033f:	68 98 24 80 00       	push   $0x802498
  800344:	e8 b3 00 00 00       	call   8003fc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800349:	83 c4 18             	add    $0x18,%esp
  80034c:	53                   	push   %ebx
  80034d:	ff 75 10             	pushl  0x10(%ebp)
  800350:	e8 56 00 00 00       	call   8003ab <vcprintf>
	cprintf("\n");
  800355:	c7 04 24 67 24 80 00 	movl   $0x802467,(%esp)
  80035c:	e8 9b 00 00 00       	call   8003fc <cprintf>
  800361:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800364:	cc                   	int3   
  800365:	eb fd                	jmp    800364 <_panic+0x43>

00800367 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	53                   	push   %ebx
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800371:	8b 13                	mov    (%ebx),%edx
  800373:	8d 42 01             	lea    0x1(%edx),%eax
  800376:	89 03                	mov    %eax,(%ebx)
  800378:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80037f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800384:	74 09                	je     80038f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800386:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80038a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80038f:	83 ec 08             	sub    $0x8,%esp
  800392:	68 ff 00 00 00       	push   $0xff
  800397:	8d 43 08             	lea    0x8(%ebx),%eax
  80039a:	50                   	push   %eax
  80039b:	e8 a0 0a 00 00       	call   800e40 <sys_cputs>
		b->idx = 0;
  8003a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	eb db                	jmp    800386 <putch+0x1f>

008003ab <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003bb:	00 00 00 
	b.cnt = 0;
  8003be:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003c8:	ff 75 0c             	pushl  0xc(%ebp)
  8003cb:	ff 75 08             	pushl  0x8(%ebp)
  8003ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d4:	50                   	push   %eax
  8003d5:	68 67 03 80 00       	push   $0x800367
  8003da:	e8 4a 01 00 00       	call   800529 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003df:	83 c4 08             	add    $0x8,%esp
  8003e2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003e8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 4c 0a 00 00       	call   800e40 <sys_cputs>

	return b.cnt;
}
  8003f4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800402:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800405:	50                   	push   %eax
  800406:	ff 75 08             	pushl  0x8(%ebp)
  800409:	e8 9d ff ff ff       	call   8003ab <vcprintf>
	va_end(ap);

	return cnt;
}
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	57                   	push   %edi
  800414:	56                   	push   %esi
  800415:	53                   	push   %ebx
  800416:	83 ec 1c             	sub    $0x1c,%esp
  800419:	89 c6                	mov    %eax,%esi
  80041b:	89 d7                	mov    %edx,%edi
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	8b 55 0c             	mov    0xc(%ebp),%edx
  800423:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800426:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800429:	8b 45 10             	mov    0x10(%ebp),%eax
  80042c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80042f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800433:	74 2c                	je     800461 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800435:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800438:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80043f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800442:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800445:	39 c2                	cmp    %eax,%edx
  800447:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80044a:	73 43                	jae    80048f <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044c:	83 eb 01             	sub    $0x1,%ebx
  80044f:	85 db                	test   %ebx,%ebx
  800451:	7e 6c                	jle    8004bf <printnum+0xaf>
			putch(padc, putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	57                   	push   %edi
  800457:	ff 75 18             	pushl  0x18(%ebp)
  80045a:	ff d6                	call   *%esi
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	eb eb                	jmp    80044c <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800461:	83 ec 0c             	sub    $0xc,%esp
  800464:	6a 20                	push   $0x20
  800466:	6a 00                	push   $0x0
  800468:	50                   	push   %eax
  800469:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046c:	ff 75 e0             	pushl  -0x20(%ebp)
  80046f:	89 fa                	mov    %edi,%edx
  800471:	89 f0                	mov    %esi,%eax
  800473:	e8 98 ff ff ff       	call   800410 <printnum>
		while (--width > 0)
  800478:	83 c4 20             	add    $0x20,%esp
  80047b:	83 eb 01             	sub    $0x1,%ebx
  80047e:	85 db                	test   %ebx,%ebx
  800480:	7e 65                	jle    8004e7 <printnum+0xd7>
			putch(padc, putdat);
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	57                   	push   %edi
  800486:	6a 20                	push   $0x20
  800488:	ff d6                	call   *%esi
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	eb ec                	jmp    80047b <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80048f:	83 ec 0c             	sub    $0xc,%esp
  800492:	ff 75 18             	pushl  0x18(%ebp)
  800495:	83 eb 01             	sub    $0x1,%ebx
  800498:	53                   	push   %ebx
  800499:	50                   	push   %eax
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a9:	e8 02 1d 00 00       	call   8021b0 <__udivdi3>
  8004ae:	83 c4 18             	add    $0x18,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	89 fa                	mov    %edi,%edx
  8004b5:	89 f0                	mov    %esi,%eax
  8004b7:	e8 54 ff ff ff       	call   800410 <printnum>
  8004bc:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	57                   	push   %edi
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d2:	e8 e9 1d 00 00       	call   8022c0 <__umoddi3>
  8004d7:	83 c4 14             	add    $0x14,%esp
  8004da:	0f be 80 bb 24 80 00 	movsbl 0x8024bb(%eax),%eax
  8004e1:	50                   	push   %eax
  8004e2:	ff d6                	call   *%esi
  8004e4:	83 c4 10             	add    $0x10,%esp
}
  8004e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ea:	5b                   	pop    %ebx
  8004eb:	5e                   	pop    %esi
  8004ec:	5f                   	pop    %edi
  8004ed:	5d                   	pop    %ebp
  8004ee:	c3                   	ret    

008004ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f9:	8b 10                	mov    (%eax),%edx
  8004fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8004fe:	73 0a                	jae    80050a <sprintputch+0x1b>
		*b->buf++ = ch;
  800500:	8d 4a 01             	lea    0x1(%edx),%ecx
  800503:	89 08                	mov    %ecx,(%eax)
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	88 02                	mov    %al,(%edx)
}
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <printfmt>:
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800512:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800515:	50                   	push   %eax
  800516:	ff 75 10             	pushl  0x10(%ebp)
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 05 00 00 00       	call   800529 <vprintfmt>
}
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	c9                   	leave  
  800528:	c3                   	ret    

00800529 <vprintfmt>:
{
  800529:	55                   	push   %ebp
  80052a:	89 e5                	mov    %esp,%ebp
  80052c:	57                   	push   %edi
  80052d:	56                   	push   %esi
  80052e:	53                   	push   %ebx
  80052f:	83 ec 3c             	sub    $0x3c,%esp
  800532:	8b 75 08             	mov    0x8(%ebp),%esi
  800535:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800538:	8b 7d 10             	mov    0x10(%ebp),%edi
  80053b:	e9 b4 03 00 00       	jmp    8008f4 <vprintfmt+0x3cb>
		padc = ' ';
  800540:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800544:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80054b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800552:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800559:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800560:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8d 47 01             	lea    0x1(%edi),%eax
  800568:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056b:	0f b6 17             	movzbl (%edi),%edx
  80056e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800571:	3c 55                	cmp    $0x55,%al
  800573:	0f 87 c8 04 00 00    	ja     800a41 <vprintfmt+0x518>
  800579:	0f b6 c0             	movzbl %al,%eax
  80057c:	ff 24 85 a0 26 80 00 	jmp    *0x8026a0(,%eax,4)
  800583:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800586:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80058d:	eb d6                	jmp    800565 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80058f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800592:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800596:	eb cd                	jmp    800565 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800598:	0f b6 d2             	movzbl %dl,%edx
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8005a6:	eb 0c                	jmp    8005b4 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8005a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005ab:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8005af:	eb b4                	jmp    800565 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8005b1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005b7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005bb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005be:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005c1:	83 f9 09             	cmp    $0x9,%ecx
  8005c4:	76 eb                	jbe    8005b1 <vprintfmt+0x88>
  8005c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cc:	eb 14                	jmp    8005e2 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e6:	0f 89 79 ff ff ff    	jns    800565 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8005ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005f9:	e9 67 ff ff ff       	jmp    800565 <vprintfmt+0x3c>
  8005fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800601:	85 c0                	test   %eax,%eax
  800603:	ba 00 00 00 00       	mov    $0x0,%edx
  800608:	0f 49 d0             	cmovns %eax,%edx
  80060b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80060e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800611:	e9 4f ff ff ff       	jmp    800565 <vprintfmt+0x3c>
  800616:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800619:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800620:	e9 40 ff ff ff       	jmp    800565 <vprintfmt+0x3c>
			lflag++;
  800625:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800628:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80062b:	e9 35 ff ff ff       	jmp    800565 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8d 78 04             	lea    0x4(%eax),%edi
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	53                   	push   %ebx
  80063a:	ff 30                	pushl  (%eax)
  80063c:	ff d6                	call   *%esi
			break;
  80063e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800641:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800644:	e9 a8 02 00 00       	jmp    8008f1 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 78 04             	lea    0x4(%eax),%edi
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	99                   	cltd   
  800652:	31 d0                	xor    %edx,%eax
  800654:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800656:	83 f8 0f             	cmp    $0xf,%eax
  800659:	7f 23                	jg     80067e <vprintfmt+0x155>
  80065b:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  800662:	85 d2                	test   %edx,%edx
  800664:	74 18                	je     80067e <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800666:	52                   	push   %edx
  800667:	68 15 29 80 00       	push   $0x802915
  80066c:	53                   	push   %ebx
  80066d:	56                   	push   %esi
  80066e:	e8 99 fe ff ff       	call   80050c <printfmt>
  800673:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800676:	89 7d 14             	mov    %edi,0x14(%ebp)
  800679:	e9 73 02 00 00       	jmp    8008f1 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  80067e:	50                   	push   %eax
  80067f:	68 d3 24 80 00       	push   $0x8024d3
  800684:	53                   	push   %ebx
  800685:	56                   	push   %esi
  800686:	e8 81 fe ff ff       	call   80050c <printfmt>
  80068b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80068e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800691:	e9 5b 02 00 00       	jmp    8008f1 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	83 c0 04             	add    $0x4,%eax
  80069c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006a4:	85 d2                	test   %edx,%edx
  8006a6:	b8 cc 24 80 00       	mov    $0x8024cc,%eax
  8006ab:	0f 45 c2             	cmovne %edx,%eax
  8006ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b5:	7e 06                	jle    8006bd <vprintfmt+0x194>
  8006b7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006bb:	75 0d                	jne    8006ca <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006c0:	89 c7                	mov    %eax,%edi
  8006c2:	03 45 e0             	add    -0x20(%ebp),%eax
  8006c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c8:	eb 53                	jmp    80071d <vprintfmt+0x1f4>
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	e8 13 04 00 00       	call   800ae9 <strnlen>
  8006d6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006d9:	29 c1                	sub    %eax,%ecx
  8006db:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006e3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ea:	eb 0f                	jmp    8006fb <vprintfmt+0x1d2>
					putch(padc, putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f5:	83 ef 01             	sub    $0x1,%edi
  8006f8:	83 c4 10             	add    $0x10,%esp
  8006fb:	85 ff                	test   %edi,%edi
  8006fd:	7f ed                	jg     8006ec <vprintfmt+0x1c3>
  8006ff:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800702:	85 d2                	test   %edx,%edx
  800704:	b8 00 00 00 00       	mov    $0x0,%eax
  800709:	0f 49 c2             	cmovns %edx,%eax
  80070c:	29 c2                	sub    %eax,%edx
  80070e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800711:	eb aa                	jmp    8006bd <vprintfmt+0x194>
					putch(ch, putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	53                   	push   %ebx
  800717:	52                   	push   %edx
  800718:	ff d6                	call   *%esi
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800720:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800722:	83 c7 01             	add    $0x1,%edi
  800725:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800729:	0f be d0             	movsbl %al,%edx
  80072c:	85 d2                	test   %edx,%edx
  80072e:	74 4b                	je     80077b <vprintfmt+0x252>
  800730:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800734:	78 06                	js     80073c <vprintfmt+0x213>
  800736:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80073a:	78 1e                	js     80075a <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80073c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800740:	74 d1                	je     800713 <vprintfmt+0x1ea>
  800742:	0f be c0             	movsbl %al,%eax
  800745:	83 e8 20             	sub    $0x20,%eax
  800748:	83 f8 5e             	cmp    $0x5e,%eax
  80074b:	76 c6                	jbe    800713 <vprintfmt+0x1ea>
					putch('?', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 3f                	push   $0x3f
  800753:	ff d6                	call   *%esi
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	eb c3                	jmp    80071d <vprintfmt+0x1f4>
  80075a:	89 cf                	mov    %ecx,%edi
  80075c:	eb 0e                	jmp    80076c <vprintfmt+0x243>
				putch(' ', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 20                	push   $0x20
  800764:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800766:	83 ef 01             	sub    $0x1,%edi
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	85 ff                	test   %edi,%edi
  80076e:	7f ee                	jg     80075e <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800770:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
  800776:	e9 76 01 00 00       	jmp    8008f1 <vprintfmt+0x3c8>
  80077b:	89 cf                	mov    %ecx,%edi
  80077d:	eb ed                	jmp    80076c <vprintfmt+0x243>
	if (lflag >= 2)
  80077f:	83 f9 01             	cmp    $0x1,%ecx
  800782:	7f 1f                	jg     8007a3 <vprintfmt+0x27a>
	else if (lflag)
  800784:	85 c9                	test   %ecx,%ecx
  800786:	74 6a                	je     8007f2 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800790:	89 c1                	mov    %eax,%ecx
  800792:	c1 f9 1f             	sar    $0x1f,%ecx
  800795:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8d 40 04             	lea    0x4(%eax),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a1:	eb 17                	jmp    8007ba <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8b 50 04             	mov    0x4(%eax),%edx
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8d 40 08             	lea    0x8(%eax),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8007bd:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8007c2:	85 d2                	test   %edx,%edx
  8007c4:	0f 89 f8 00 00 00    	jns    8008c2 <vprintfmt+0x399>
				putch('-', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	6a 2d                	push   $0x2d
  8007d0:	ff d6                	call   *%esi
				num = -(long long) num;
  8007d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007d8:	f7 d8                	neg    %eax
  8007da:	83 d2 00             	adc    $0x0,%edx
  8007dd:	f7 da                	neg    %edx
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007e8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007ed:	e9 e1 00 00 00       	jmp    8008d3 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fa:	99                   	cltd   
  8007fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
  800807:	eb b1                	jmp    8007ba <vprintfmt+0x291>
	if (lflag >= 2)
  800809:	83 f9 01             	cmp    $0x1,%ecx
  80080c:	7f 27                	jg     800835 <vprintfmt+0x30c>
	else if (lflag)
  80080e:	85 c9                	test   %ecx,%ecx
  800810:	74 41                	je     800853 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	ba 00 00 00 00       	mov    $0x0,%edx
  80081c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8d 40 04             	lea    0x4(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800830:	e9 8d 00 00 00       	jmp    8008c2 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	8b 50 04             	mov    0x4(%eax),%edx
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800840:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	8d 40 08             	lea    0x8(%eax),%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800851:	eb 6f                	jmp    8008c2 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	ba 00 00 00 00       	mov    $0x0,%edx
  80085d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800860:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8d 40 04             	lea    0x4(%eax),%eax
  800869:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80086c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800871:	eb 4f                	jmp    8008c2 <vprintfmt+0x399>
	if (lflag >= 2)
  800873:	83 f9 01             	cmp    $0x1,%ecx
  800876:	7f 23                	jg     80089b <vprintfmt+0x372>
	else if (lflag)
  800878:	85 c9                	test   %ecx,%ecx
  80087a:	0f 84 98 00 00 00    	je     800918 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	ba 00 00 00 00       	mov    $0x0,%edx
  80088a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	8d 40 04             	lea    0x4(%eax),%eax
  800896:	89 45 14             	mov    %eax,0x14(%ebp)
  800899:	eb 17                	jmp    8008b2 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 50 04             	mov    0x4(%eax),%edx
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8d 40 08             	lea    0x8(%eax),%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	6a 30                	push   $0x30
  8008b8:	ff d6                	call   *%esi
			goto number;
  8008ba:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8008bd:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8008c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008c6:	74 0b                	je     8008d3 <vprintfmt+0x3aa>
				putch('+', putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	53                   	push   %ebx
  8008cc:	6a 2b                	push   $0x2b
  8008ce:	ff d6                	call   *%esi
  8008d0:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008da:	50                   	push   %eax
  8008db:	ff 75 e0             	pushl  -0x20(%ebp)
  8008de:	57                   	push   %edi
  8008df:	ff 75 dc             	pushl  -0x24(%ebp)
  8008e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8008e5:	89 da                	mov    %ebx,%edx
  8008e7:	89 f0                	mov    %esi,%eax
  8008e9:	e8 22 fb ff ff       	call   800410 <printnum>
			break;
  8008ee:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  8008f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f4:	83 c7 01             	add    $0x1,%edi
  8008f7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008fb:	83 f8 25             	cmp    $0x25,%eax
  8008fe:	0f 84 3c fc ff ff    	je     800540 <vprintfmt+0x17>
			if (ch == '\0')
  800904:	85 c0                	test   %eax,%eax
  800906:	0f 84 55 01 00 00    	je     800a61 <vprintfmt+0x538>
			putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	53                   	push   %ebx
  800910:	50                   	push   %eax
  800911:	ff d6                	call   *%esi
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	eb dc                	jmp    8008f4 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	ba 00 00 00 00       	mov    $0x0,%edx
  800922:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800925:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 40 04             	lea    0x4(%eax),%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
  800931:	e9 7c ff ff ff       	jmp    8008b2 <vprintfmt+0x389>
			putch('0', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	53                   	push   %ebx
  80093a:	6a 30                	push   $0x30
  80093c:	ff d6                	call   *%esi
			putch('x', putdat);
  80093e:	83 c4 08             	add    $0x8,%esp
  800941:	53                   	push   %ebx
  800942:	6a 78                	push   $0x78
  800944:	ff d6                	call   *%esi
			num = (unsigned long long)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	ba 00 00 00 00       	mov    $0x0,%edx
  800950:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800953:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800956:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800959:	8b 45 14             	mov    0x14(%ebp),%eax
  80095c:	8d 40 04             	lea    0x4(%eax),%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800962:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800967:	e9 56 ff ff ff       	jmp    8008c2 <vprintfmt+0x399>
	if (lflag >= 2)
  80096c:	83 f9 01             	cmp    $0x1,%ecx
  80096f:	7f 27                	jg     800998 <vprintfmt+0x46f>
	else if (lflag)
  800971:	85 c9                	test   %ecx,%ecx
  800973:	74 44                	je     8009b9 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800975:	8b 45 14             	mov    0x14(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	ba 00 00 00 00       	mov    $0x0,%edx
  80097f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800982:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	8d 40 04             	lea    0x4(%eax),%eax
  80098b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80098e:	bf 10 00 00 00       	mov    $0x10,%edi
  800993:	e9 2a ff ff ff       	jmp    8008c2 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	8b 50 04             	mov    0x4(%eax),%edx
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	8d 40 08             	lea    0x8(%eax),%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009af:	bf 10 00 00 00       	mov    $0x10,%edi
  8009b4:	e9 09 ff ff ff       	jmp    8008c2 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8009b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	8d 40 04             	lea    0x4(%eax),%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009d2:	bf 10 00 00 00       	mov    $0x10,%edi
  8009d7:	e9 e6 fe ff ff       	jmp    8008c2 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	8d 78 04             	lea    0x4(%eax),%edi
  8009e2:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  8009e4:	85 c0                	test   %eax,%eax
  8009e6:	74 2d                	je     800a15 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  8009e8:	0f b6 13             	movzbl (%ebx),%edx
  8009eb:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  8009ed:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  8009f0:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8009f3:	0f 8e f8 fe ff ff    	jle    8008f1 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  8009f9:	68 28 26 80 00       	push   $0x802628
  8009fe:	68 15 29 80 00       	push   $0x802915
  800a03:	53                   	push   %ebx
  800a04:	56                   	push   %esi
  800a05:	e8 02 fb ff ff       	call   80050c <printfmt>
  800a0a:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a0d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a10:	e9 dc fe ff ff       	jmp    8008f1 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800a15:	68 f0 25 80 00       	push   $0x8025f0
  800a1a:	68 15 29 80 00       	push   $0x802915
  800a1f:	53                   	push   %ebx
  800a20:	56                   	push   %esi
  800a21:	e8 e6 fa ff ff       	call   80050c <printfmt>
  800a26:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800a29:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a2c:	e9 c0 fe ff ff       	jmp    8008f1 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	53                   	push   %ebx
  800a35:	6a 25                	push   $0x25
  800a37:	ff d6                	call   *%esi
			break;
  800a39:	83 c4 10             	add    $0x10,%esp
  800a3c:	e9 b0 fe ff ff       	jmp    8008f1 <vprintfmt+0x3c8>
			putch('%', putdat);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	53                   	push   %ebx
  800a45:	6a 25                	push   $0x25
  800a47:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	89 f8                	mov    %edi,%eax
  800a4e:	eb 03                	jmp    800a53 <vprintfmt+0x52a>
  800a50:	83 e8 01             	sub    $0x1,%eax
  800a53:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a57:	75 f7                	jne    800a50 <vprintfmt+0x527>
  800a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5c:	e9 90 fe ff ff       	jmp    8008f1 <vprintfmt+0x3c8>
}
  800a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a64:	5b                   	pop    %ebx
  800a65:	5e                   	pop    %esi
  800a66:	5f                   	pop    %edi
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	83 ec 18             	sub    $0x18,%esp
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a78:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a7c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a86:	85 c0                	test   %eax,%eax
  800a88:	74 26                	je     800ab0 <vsnprintf+0x47>
  800a8a:	85 d2                	test   %edx,%edx
  800a8c:	7e 22                	jle    800ab0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8e:	ff 75 14             	pushl  0x14(%ebp)
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a97:	50                   	push   %eax
  800a98:	68 ef 04 80 00       	push   $0x8004ef
  800a9d:	e8 87 fa ff ff       	call   800529 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aab:	83 c4 10             	add    $0x10,%esp
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    
		return -E_INVAL;
  800ab0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab5:	eb f7                	jmp    800aae <vsnprintf+0x45>

00800ab7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800abd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ac0:	50                   	push   %eax
  800ac1:	ff 75 10             	pushl  0x10(%ebp)
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 9a ff ff ff       	call   800a69 <vsnprintf>
	va_end(ap);

	return rc;
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  800adc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ae0:	74 05                	je     800ae7 <strlen+0x16>
		n++;
  800ae2:	83 c0 01             	add    $0x1,%eax
  800ae5:	eb f5                	jmp    800adc <strlen+0xb>
	return n;
}
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800af2:	ba 00 00 00 00       	mov    $0x0,%edx
  800af7:	39 c2                	cmp    %eax,%edx
  800af9:	74 0d                	je     800b08 <strnlen+0x1f>
  800afb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800aff:	74 05                	je     800b06 <strnlen+0x1d>
		n++;
  800b01:	83 c2 01             	add    $0x1,%edx
  800b04:	eb f1                	jmp    800af7 <strnlen+0xe>
  800b06:	89 d0                	mov    %edx,%eax
	return n;
}
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	53                   	push   %ebx
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b14:	ba 00 00 00 00       	mov    $0x0,%edx
  800b19:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b1d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b20:	83 c2 01             	add    $0x1,%edx
  800b23:	84 c9                	test   %cl,%cl
  800b25:	75 f2                	jne    800b19 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b27:	5b                   	pop    %ebx
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	53                   	push   %ebx
  800b2e:	83 ec 10             	sub    $0x10,%esp
  800b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b34:	53                   	push   %ebx
  800b35:	e8 97 ff ff ff       	call   800ad1 <strlen>
  800b3a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	01 d8                	add    %ebx,%eax
  800b42:	50                   	push   %eax
  800b43:	e8 c2 ff ff ff       	call   800b0a <strcpy>
	return dst;
}
  800b48:	89 d8                	mov    %ebx,%eax
  800b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5a:	89 c6                	mov    %eax,%esi
  800b5c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b5f:	89 c2                	mov    %eax,%edx
  800b61:	39 f2                	cmp    %esi,%edx
  800b63:	74 11                	je     800b76 <strncpy+0x27>
		*dst++ = *src;
  800b65:	83 c2 01             	add    $0x1,%edx
  800b68:	0f b6 19             	movzbl (%ecx),%ebx
  800b6b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b6e:	80 fb 01             	cmp    $0x1,%bl
  800b71:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b74:	eb eb                	jmp    800b61 <strncpy+0x12>
	}
	return ret;
}
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
  800b7f:	8b 75 08             	mov    0x8(%ebp),%esi
  800b82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b85:	8b 55 10             	mov    0x10(%ebp),%edx
  800b88:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b8a:	85 d2                	test   %edx,%edx
  800b8c:	74 21                	je     800baf <strlcpy+0x35>
  800b8e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b92:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b94:	39 c2                	cmp    %eax,%edx
  800b96:	74 14                	je     800bac <strlcpy+0x32>
  800b98:	0f b6 19             	movzbl (%ecx),%ebx
  800b9b:	84 db                	test   %bl,%bl
  800b9d:	74 0b                	je     800baa <strlcpy+0x30>
			*dst++ = *src++;
  800b9f:	83 c1 01             	add    $0x1,%ecx
  800ba2:	83 c2 01             	add    $0x1,%edx
  800ba5:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ba8:	eb ea                	jmp    800b94 <strlcpy+0x1a>
  800baa:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800baf:	29 f0                	sub    %esi,%eax
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bbe:	0f b6 01             	movzbl (%ecx),%eax
  800bc1:	84 c0                	test   %al,%al
  800bc3:	74 0c                	je     800bd1 <strcmp+0x1c>
  800bc5:	3a 02                	cmp    (%edx),%al
  800bc7:	75 08                	jne    800bd1 <strcmp+0x1c>
		p++, q++;
  800bc9:	83 c1 01             	add    $0x1,%ecx
  800bcc:	83 c2 01             	add    $0x1,%edx
  800bcf:	eb ed                	jmp    800bbe <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd1:	0f b6 c0             	movzbl %al,%eax
  800bd4:	0f b6 12             	movzbl (%edx),%edx
  800bd7:	29 d0                	sub    %edx,%eax
}
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	53                   	push   %ebx
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be5:	89 c3                	mov    %eax,%ebx
  800be7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bea:	eb 06                	jmp    800bf2 <strncmp+0x17>
		n--, p++, q++;
  800bec:	83 c0 01             	add    $0x1,%eax
  800bef:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bf2:	39 d8                	cmp    %ebx,%eax
  800bf4:	74 16                	je     800c0c <strncmp+0x31>
  800bf6:	0f b6 08             	movzbl (%eax),%ecx
  800bf9:	84 c9                	test   %cl,%cl
  800bfb:	74 04                	je     800c01 <strncmp+0x26>
  800bfd:	3a 0a                	cmp    (%edx),%cl
  800bff:	74 eb                	je     800bec <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c01:	0f b6 00             	movzbl (%eax),%eax
  800c04:	0f b6 12             	movzbl (%edx),%edx
  800c07:	29 d0                	sub    %edx,%eax
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    
		return 0;
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	eb f6                	jmp    800c09 <strncmp+0x2e>

00800c13 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c1d:	0f b6 10             	movzbl (%eax),%edx
  800c20:	84 d2                	test   %dl,%dl
  800c22:	74 09                	je     800c2d <strchr+0x1a>
		if (*s == c)
  800c24:	38 ca                	cmp    %cl,%dl
  800c26:	74 0a                	je     800c32 <strchr+0x1f>
	for (; *s; s++)
  800c28:	83 c0 01             	add    $0x1,%eax
  800c2b:	eb f0                	jmp    800c1d <strchr+0xa>
			return (char *) s;
	return 0;
  800c2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c3e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c41:	38 ca                	cmp    %cl,%dl
  800c43:	74 09                	je     800c4e <strfind+0x1a>
  800c45:	84 d2                	test   %dl,%dl
  800c47:	74 05                	je     800c4e <strfind+0x1a>
	for (; *s; s++)
  800c49:	83 c0 01             	add    $0x1,%eax
  800c4c:	eb f0                	jmp    800c3e <strfind+0xa>
			break;
	return (char *) s;
}
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	57                   	push   %edi
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
  800c56:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c5c:	85 c9                	test   %ecx,%ecx
  800c5e:	74 31                	je     800c91 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c60:	89 f8                	mov    %edi,%eax
  800c62:	09 c8                	or     %ecx,%eax
  800c64:	a8 03                	test   $0x3,%al
  800c66:	75 23                	jne    800c8b <memset+0x3b>
		c &= 0xFF;
  800c68:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c6c:	89 d3                	mov    %edx,%ebx
  800c6e:	c1 e3 08             	shl    $0x8,%ebx
  800c71:	89 d0                	mov    %edx,%eax
  800c73:	c1 e0 18             	shl    $0x18,%eax
  800c76:	89 d6                	mov    %edx,%esi
  800c78:	c1 e6 10             	shl    $0x10,%esi
  800c7b:	09 f0                	or     %esi,%eax
  800c7d:	09 c2                	or     %eax,%edx
  800c7f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c81:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c84:	89 d0                	mov    %edx,%eax
  800c86:	fc                   	cld    
  800c87:	f3 ab                	rep stos %eax,%es:(%edi)
  800c89:	eb 06                	jmp    800c91 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	fc                   	cld    
  800c8f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c91:	89 f8                	mov    %edi,%eax
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ca3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca6:	39 c6                	cmp    %eax,%esi
  800ca8:	73 32                	jae    800cdc <memmove+0x44>
  800caa:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cad:	39 c2                	cmp    %eax,%edx
  800caf:	76 2b                	jbe    800cdc <memmove+0x44>
		s += n;
		d += n;
  800cb1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb4:	89 fe                	mov    %edi,%esi
  800cb6:	09 ce                	or     %ecx,%esi
  800cb8:	09 d6                	or     %edx,%esi
  800cba:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cc0:	75 0e                	jne    800cd0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cc2:	83 ef 04             	sub    $0x4,%edi
  800cc5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ccb:	fd                   	std    
  800ccc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cce:	eb 09                	jmp    800cd9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cd0:	83 ef 01             	sub    $0x1,%edi
  800cd3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cd6:	fd                   	std    
  800cd7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cd9:	fc                   	cld    
  800cda:	eb 1a                	jmp    800cf6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cdc:	89 c2                	mov    %eax,%edx
  800cde:	09 ca                	or     %ecx,%edx
  800ce0:	09 f2                	or     %esi,%edx
  800ce2:	f6 c2 03             	test   $0x3,%dl
  800ce5:	75 0a                	jne    800cf1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ce7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cea:	89 c7                	mov    %eax,%edi
  800cec:	fc                   	cld    
  800ced:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cef:	eb 05                	jmp    800cf6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cf1:	89 c7                	mov    %eax,%edi
  800cf3:	fc                   	cld    
  800cf4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d00:	ff 75 10             	pushl  0x10(%ebp)
  800d03:	ff 75 0c             	pushl  0xc(%ebp)
  800d06:	ff 75 08             	pushl  0x8(%ebp)
  800d09:	e8 8a ff ff ff       	call   800c98 <memmove>
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1b:	89 c6                	mov    %eax,%esi
  800d1d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d20:	39 f0                	cmp    %esi,%eax
  800d22:	74 1c                	je     800d40 <memcmp+0x30>
		if (*s1 != *s2)
  800d24:	0f b6 08             	movzbl (%eax),%ecx
  800d27:	0f b6 1a             	movzbl (%edx),%ebx
  800d2a:	38 d9                	cmp    %bl,%cl
  800d2c:	75 08                	jne    800d36 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d2e:	83 c0 01             	add    $0x1,%eax
  800d31:	83 c2 01             	add    $0x1,%edx
  800d34:	eb ea                	jmp    800d20 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d36:	0f b6 c1             	movzbl %cl,%eax
  800d39:	0f b6 db             	movzbl %bl,%ebx
  800d3c:	29 d8                	sub    %ebx,%eax
  800d3e:	eb 05                	jmp    800d45 <memcmp+0x35>
	}

	return 0;
  800d40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d52:	89 c2                	mov    %eax,%edx
  800d54:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d57:	39 d0                	cmp    %edx,%eax
  800d59:	73 09                	jae    800d64 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d5b:	38 08                	cmp    %cl,(%eax)
  800d5d:	74 05                	je     800d64 <memfind+0x1b>
	for (; s < ends; s++)
  800d5f:	83 c0 01             	add    $0x1,%eax
  800d62:	eb f3                	jmp    800d57 <memfind+0xe>
			break;
	return (void *) s;
}
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
  800d6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d72:	eb 03                	jmp    800d77 <strtol+0x11>
		s++;
  800d74:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d77:	0f b6 01             	movzbl (%ecx),%eax
  800d7a:	3c 20                	cmp    $0x20,%al
  800d7c:	74 f6                	je     800d74 <strtol+0xe>
  800d7e:	3c 09                	cmp    $0x9,%al
  800d80:	74 f2                	je     800d74 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d82:	3c 2b                	cmp    $0x2b,%al
  800d84:	74 2a                	je     800db0 <strtol+0x4a>
	int neg = 0;
  800d86:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d8b:	3c 2d                	cmp    $0x2d,%al
  800d8d:	74 2b                	je     800dba <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d95:	75 0f                	jne    800da6 <strtol+0x40>
  800d97:	80 39 30             	cmpb   $0x30,(%ecx)
  800d9a:	74 28                	je     800dc4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d9c:	85 db                	test   %ebx,%ebx
  800d9e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da3:	0f 44 d8             	cmove  %eax,%ebx
  800da6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dab:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dae:	eb 50                	jmp    800e00 <strtol+0x9a>
		s++;
  800db0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800db3:	bf 00 00 00 00       	mov    $0x0,%edi
  800db8:	eb d5                	jmp    800d8f <strtol+0x29>
		s++, neg = 1;
  800dba:	83 c1 01             	add    $0x1,%ecx
  800dbd:	bf 01 00 00 00       	mov    $0x1,%edi
  800dc2:	eb cb                	jmp    800d8f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dc4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dc8:	74 0e                	je     800dd8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dca:	85 db                	test   %ebx,%ebx
  800dcc:	75 d8                	jne    800da6 <strtol+0x40>
		s++, base = 8;
  800dce:	83 c1 01             	add    $0x1,%ecx
  800dd1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dd6:	eb ce                	jmp    800da6 <strtol+0x40>
		s += 2, base = 16;
  800dd8:	83 c1 02             	add    $0x2,%ecx
  800ddb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800de0:	eb c4                	jmp    800da6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800de2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800de5:	89 f3                	mov    %esi,%ebx
  800de7:	80 fb 19             	cmp    $0x19,%bl
  800dea:	77 29                	ja     800e15 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dec:	0f be d2             	movsbl %dl,%edx
  800def:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800df2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800df5:	7d 30                	jge    800e27 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800df7:	83 c1 01             	add    $0x1,%ecx
  800dfa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dfe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e00:	0f b6 11             	movzbl (%ecx),%edx
  800e03:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e06:	89 f3                	mov    %esi,%ebx
  800e08:	80 fb 09             	cmp    $0x9,%bl
  800e0b:	77 d5                	ja     800de2 <strtol+0x7c>
			dig = *s - '0';
  800e0d:	0f be d2             	movsbl %dl,%edx
  800e10:	83 ea 30             	sub    $0x30,%edx
  800e13:	eb dd                	jmp    800df2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e15:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e18:	89 f3                	mov    %esi,%ebx
  800e1a:	80 fb 19             	cmp    $0x19,%bl
  800e1d:	77 08                	ja     800e27 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e1f:	0f be d2             	movsbl %dl,%edx
  800e22:	83 ea 37             	sub    $0x37,%edx
  800e25:	eb cb                	jmp    800df2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e2b:	74 05                	je     800e32 <strtol+0xcc>
		*endptr = (char *) s;
  800e2d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e30:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e32:	89 c2                	mov    %eax,%edx
  800e34:	f7 da                	neg    %edx
  800e36:	85 ff                	test   %edi,%edi
  800e38:	0f 45 c2             	cmovne %edx,%eax
}
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e46:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	89 c3                	mov    %eax,%ebx
  800e53:	89 c7                	mov    %eax,%edi
  800e55:	89 c6                	mov    %eax,%esi
  800e57:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <sys_cgetc>:

int
sys_cgetc(void)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e64:	ba 00 00 00 00       	mov    $0x0,%edx
  800e69:	b8 01 00 00 00       	mov    $0x1,%eax
  800e6e:	89 d1                	mov    %edx,%ecx
  800e70:	89 d3                	mov    %edx,%ebx
  800e72:	89 d7                	mov    %edx,%edi
  800e74:	89 d6                	mov    %edx,%esi
  800e76:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
  800e83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e86:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800e93:	89 cb                	mov    %ecx,%ebx
  800e95:	89 cf                	mov    %ecx,%edi
  800e97:	89 ce                	mov    %ecx,%esi
  800e99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	7f 08                	jg     800ea7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5f                   	pop    %edi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea7:	83 ec 0c             	sub    $0xc,%esp
  800eaa:	50                   	push   %eax
  800eab:	6a 03                	push   $0x3
  800ead:	68 40 28 80 00       	push   $0x802840
  800eb2:	6a 33                	push   $0x33
  800eb4:	68 5d 28 80 00       	push   $0x80285d
  800eb9:	e8 63 f4 ff ff       	call   800321 <_panic>

00800ebe <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec9:	b8 02 00 00 00       	mov    $0x2,%eax
  800ece:	89 d1                	mov    %edx,%ecx
  800ed0:	89 d3                	mov    %edx,%ebx
  800ed2:	89 d7                	mov    %edx,%edi
  800ed4:	89 d6                	mov    %edx,%esi
  800ed6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ed8:	5b                   	pop    %ebx
  800ed9:	5e                   	pop    %esi
  800eda:	5f                   	pop    %edi
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <sys_yield>:

void
sys_yield(void)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eed:	89 d1                	mov    %edx,%ecx
  800eef:	89 d3                	mov    %edx,%ebx
  800ef1:	89 d7                	mov    %edx,%edi
  800ef3:	89 d6                	mov    %edx,%esi
  800ef5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
  800f02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f05:	be 00 00 00 00       	mov    $0x0,%esi
  800f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f10:	b8 04 00 00 00       	mov    $0x4,%eax
  800f15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f18:	89 f7                	mov    %esi,%edi
  800f1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	7f 08                	jg     800f28 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f28:	83 ec 0c             	sub    $0xc,%esp
  800f2b:	50                   	push   %eax
  800f2c:	6a 04                	push   $0x4
  800f2e:	68 40 28 80 00       	push   $0x802840
  800f33:	6a 33                	push   $0x33
  800f35:	68 5d 28 80 00       	push   $0x80285d
  800f3a:	e8 e2 f3 ff ff       	call   800321 <_panic>

00800f3f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	b8 05 00 00 00       	mov    $0x5,%eax
  800f53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f56:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f59:	8b 75 18             	mov    0x18(%ebp),%esi
  800f5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	7f 08                	jg     800f6a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6a:	83 ec 0c             	sub    $0xc,%esp
  800f6d:	50                   	push   %eax
  800f6e:	6a 05                	push   $0x5
  800f70:	68 40 28 80 00       	push   $0x802840
  800f75:	6a 33                	push   $0x33
  800f77:	68 5d 28 80 00       	push   $0x80285d
  800f7c:	e8 a0 f3 ff ff       	call   800321 <_panic>

00800f81 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
  800f87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	b8 06 00 00 00       	mov    $0x6,%eax
  800f9a:	89 df                	mov    %ebx,%edi
  800f9c:	89 de                	mov    %ebx,%esi
  800f9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	7f 08                	jg     800fac <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800fb0:	6a 06                	push   $0x6
  800fb2:	68 40 28 80 00       	push   $0x802840
  800fb7:	6a 33                	push   $0x33
  800fb9:	68 5d 28 80 00       	push   $0x80285d
  800fbe:	e8 5e f3 ff ff       	call   800321 <_panic>

00800fc3 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fd9:	89 cb                	mov    %ecx,%ebx
  800fdb:	89 cf                	mov    %ecx,%edi
  800fdd:	89 ce                	mov    %ecx,%esi
  800fdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	7f 08                	jg     800fed <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe8:	5b                   	pop    %ebx
  800fe9:	5e                   	pop    %esi
  800fea:	5f                   	pop    %edi
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	50                   	push   %eax
  800ff1:	6a 0b                	push   $0xb
  800ff3:	68 40 28 80 00       	push   $0x802840
  800ff8:	6a 33                	push   $0x33
  800ffa:	68 5d 28 80 00       	push   $0x80285d
  800fff:	e8 1d f3 ff ff       	call   800321 <_panic>

00801004 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	57                   	push   %edi
  801008:	56                   	push   %esi
  801009:	53                   	push   %ebx
  80100a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801012:	8b 55 08             	mov    0x8(%ebp),%edx
  801015:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801018:	b8 08 00 00 00       	mov    $0x8,%eax
  80101d:	89 df                	mov    %ebx,%edi
  80101f:	89 de                	mov    %ebx,%esi
  801021:	cd 30                	int    $0x30
	if(check && ret > 0)
  801023:	85 c0                	test   %eax,%eax
  801025:	7f 08                	jg     80102f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801027:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102f:	83 ec 0c             	sub    $0xc,%esp
  801032:	50                   	push   %eax
  801033:	6a 08                	push   $0x8
  801035:	68 40 28 80 00       	push   $0x802840
  80103a:	6a 33                	push   $0x33
  80103c:	68 5d 28 80 00       	push   $0x80285d
  801041:	e8 db f2 ff ff       	call   800321 <_panic>

00801046 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	57                   	push   %edi
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
  80104c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	b8 09 00 00 00       	mov    $0x9,%eax
  80105f:	89 df                	mov    %ebx,%edi
  801061:	89 de                	mov    %ebx,%esi
  801063:	cd 30                	int    $0x30
	if(check && ret > 0)
  801065:	85 c0                	test   %eax,%eax
  801067:	7f 08                	jg     801071 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  801075:	6a 09                	push   $0x9
  801077:	68 40 28 80 00       	push   $0x802840
  80107c:	6a 33                	push   $0x33
  80107e:	68 5d 28 80 00       	push   $0x80285d
  801083:	e8 99 f2 ff ff       	call   800321 <_panic>

00801088 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  80109c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a1:	89 df                	mov    %ebx,%edi
  8010a3:	89 de                	mov    %ebx,%esi
  8010a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	7f 08                	jg     8010b3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  8010b7:	6a 0a                	push   $0xa
  8010b9:	68 40 28 80 00       	push   $0x802840
  8010be:	6a 33                	push   $0x33
  8010c0:	68 5d 28 80 00       	push   $0x80285d
  8010c5:	e8 57 f2 ff ff       	call   800321 <_panic>

008010ca <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010db:	be 00 00 00 00       	mov    $0x0,%esi
  8010e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010e8:	5b                   	pop    %ebx
  8010e9:	5e                   	pop    %esi
  8010ea:	5f                   	pop    %edi
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	57                   	push   %edi
  8010f1:	56                   	push   %esi
  8010f2:	53                   	push   %ebx
  8010f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	b8 0e 00 00 00       	mov    $0xe,%eax
  801103:	89 cb                	mov    %ecx,%ebx
  801105:	89 cf                	mov    %ecx,%edi
  801107:	89 ce                	mov    %ecx,%esi
  801109:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110b:	85 c0                	test   %eax,%eax
  80110d:	7f 08                	jg     801117 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80110f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801117:	83 ec 0c             	sub    $0xc,%esp
  80111a:	50                   	push   %eax
  80111b:	6a 0e                	push   $0xe
  80111d:	68 40 28 80 00       	push   $0x802840
  801122:	6a 33                	push   $0x33
  801124:	68 5d 28 80 00       	push   $0x80285d
  801129:	e8 f3 f1 ff ff       	call   800321 <_panic>

0080112e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	57                   	push   %edi
  801132:	56                   	push   %esi
  801133:	53                   	push   %ebx
	asm volatile("int %1\n"
  801134:	bb 00 00 00 00       	mov    $0x0,%ebx
  801139:	8b 55 08             	mov    0x8(%ebp),%edx
  80113c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113f:	b8 0f 00 00 00       	mov    $0xf,%eax
  801144:	89 df                	mov    %ebx,%edi
  801146:	89 de                	mov    %ebx,%esi
  801148:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80114a:	5b                   	pop    %ebx
  80114b:	5e                   	pop    %esi
  80114c:	5f                   	pop    %edi
  80114d:	5d                   	pop    %ebp
  80114e:	c3                   	ret    

0080114f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	57                   	push   %edi
  801153:	56                   	push   %esi
  801154:	53                   	push   %ebx
	asm volatile("int %1\n"
  801155:	b9 00 00 00 00       	mov    $0x0,%ecx
  80115a:	8b 55 08             	mov    0x8(%ebp),%edx
  80115d:	b8 10 00 00 00       	mov    $0x10,%eax
  801162:	89 cb                	mov    %ecx,%ebx
  801164:	89 cf                	mov    %ecx,%edi
  801166:	89 ce                	mov    %ecx,%esi
  801168:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80116a:	5b                   	pop    %ebx
  80116b:	5e                   	pop    %esi
  80116c:	5f                   	pop    %edi
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	8b 55 08             	mov    0x8(%ebp),%edx
  801175:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80117b:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  80117d:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801180:	83 3a 01             	cmpl   $0x1,(%edx)
  801183:	7e 09                	jle    80118e <argstart+0x1f>
  801185:	ba 68 24 80 00       	mov    $0x802468,%edx
  80118a:	85 c9                	test   %ecx,%ecx
  80118c:	75 05                	jne    801193 <argstart+0x24>
  80118e:	ba 00 00 00 00       	mov    $0x0,%edx
  801193:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801196:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <argnext>:

int
argnext(struct Argstate *args)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	53                   	push   %ebx
  8011a3:	83 ec 04             	sub    $0x4,%esp
  8011a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8011a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8011b0:	8b 43 08             	mov    0x8(%ebx),%eax
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	74 72                	je     801229 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  8011b7:	80 38 00             	cmpb   $0x0,(%eax)
  8011ba:	75 48                	jne    801204 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8011bc:	8b 0b                	mov    (%ebx),%ecx
  8011be:	83 39 01             	cmpl   $0x1,(%ecx)
  8011c1:	74 58                	je     80121b <argnext+0x7c>
		    || args->argv[1][0] != '-'
  8011c3:	8b 53 04             	mov    0x4(%ebx),%edx
  8011c6:	8b 42 04             	mov    0x4(%edx),%eax
  8011c9:	80 38 2d             	cmpb   $0x2d,(%eax)
  8011cc:	75 4d                	jne    80121b <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  8011ce:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8011d2:	74 47                	je     80121b <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8011d4:	83 c0 01             	add    $0x1,%eax
  8011d7:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011da:	83 ec 04             	sub    $0x4,%esp
  8011dd:	8b 01                	mov    (%ecx),%eax
  8011df:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8011e6:	50                   	push   %eax
  8011e7:	8d 42 08             	lea    0x8(%edx),%eax
  8011ea:	50                   	push   %eax
  8011eb:	83 c2 04             	add    $0x4,%edx
  8011ee:	52                   	push   %edx
  8011ef:	e8 a4 fa ff ff       	call   800c98 <memmove>
		(*args->argc)--;
  8011f4:	8b 03                	mov    (%ebx),%eax
  8011f6:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8011f9:	8b 43 08             	mov    0x8(%ebx),%eax
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	80 38 2d             	cmpb   $0x2d,(%eax)
  801202:	74 11                	je     801215 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801204:	8b 53 08             	mov    0x8(%ebx),%edx
  801207:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80120a:	83 c2 01             	add    $0x1,%edx
  80120d:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801210:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801213:	c9                   	leave  
  801214:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801215:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801219:	75 e9                	jne    801204 <argnext+0x65>
	args->curarg = 0;
  80121b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801227:	eb e7                	jmp    801210 <argnext+0x71>
		return -1;
  801229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80122e:	eb e0                	jmp    801210 <argnext+0x71>

00801230 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	53                   	push   %ebx
  801234:	83 ec 04             	sub    $0x4,%esp
  801237:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80123a:	8b 43 08             	mov    0x8(%ebx),%eax
  80123d:	85 c0                	test   %eax,%eax
  80123f:	74 12                	je     801253 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  801241:	80 38 00             	cmpb   $0x0,(%eax)
  801244:	74 12                	je     801258 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801246:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801249:	c7 43 08 68 24 80 00 	movl   $0x802468,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801250:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801256:	c9                   	leave  
  801257:	c3                   	ret    
	} else if (*args->argc > 1) {
  801258:	8b 13                	mov    (%ebx),%edx
  80125a:	83 3a 01             	cmpl   $0x1,(%edx)
  80125d:	7f 10                	jg     80126f <argnextvalue+0x3f>
		args->argvalue = 0;
  80125f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801266:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80126d:	eb e1                	jmp    801250 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  80126f:	8b 43 04             	mov    0x4(%ebx),%eax
  801272:	8b 48 04             	mov    0x4(%eax),%ecx
  801275:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801278:	83 ec 04             	sub    $0x4,%esp
  80127b:	8b 12                	mov    (%edx),%edx
  80127d:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801284:	52                   	push   %edx
  801285:	8d 50 08             	lea    0x8(%eax),%edx
  801288:	52                   	push   %edx
  801289:	83 c0 04             	add    $0x4,%eax
  80128c:	50                   	push   %eax
  80128d:	e8 06 fa ff ff       	call   800c98 <memmove>
		(*args->argc)--;
  801292:	8b 03                	mov    (%ebx),%eax
  801294:	83 28 01             	subl   $0x1,(%eax)
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	eb b4                	jmp    801250 <argnextvalue+0x20>

0080129c <argvalue>:
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8012a5:	8b 42 0c             	mov    0xc(%edx),%eax
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	74 02                	je     8012ae <argvalue+0x12>
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	52                   	push   %edx
  8012b2:	e8 79 ff ff ff       	call   801230 <argnextvalue>
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	eb f0                	jmp    8012ac <argvalue+0x10>

008012bc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	05 00 00 00 30       	add    $0x30000000,%eax
  8012c7:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012dc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012eb:	89 c2                	mov    %eax,%edx
  8012ed:	c1 ea 16             	shr    $0x16,%edx
  8012f0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012f7:	f6 c2 01             	test   $0x1,%dl
  8012fa:	74 2d                	je     801329 <fd_alloc+0x46>
  8012fc:	89 c2                	mov    %eax,%edx
  8012fe:	c1 ea 0c             	shr    $0xc,%edx
  801301:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801308:	f6 c2 01             	test   $0x1,%dl
  80130b:	74 1c                	je     801329 <fd_alloc+0x46>
  80130d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801312:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801317:	75 d2                	jne    8012eb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801322:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801327:	eb 0a                	jmp    801333 <fd_alloc+0x50>
			*fd_store = fd;
  801329:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80132e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80133b:	83 f8 1f             	cmp    $0x1f,%eax
  80133e:	77 30                	ja     801370 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801340:	c1 e0 0c             	shl    $0xc,%eax
  801343:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801348:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80134e:	f6 c2 01             	test   $0x1,%dl
  801351:	74 24                	je     801377 <fd_lookup+0x42>
  801353:	89 c2                	mov    %eax,%edx
  801355:	c1 ea 0c             	shr    $0xc,%edx
  801358:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80135f:	f6 c2 01             	test   $0x1,%dl
  801362:	74 1a                	je     80137e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801364:	8b 55 0c             	mov    0xc(%ebp),%edx
  801367:	89 02                	mov    %eax,(%edx)
	return 0;
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    
		return -E_INVAL;
  801370:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801375:	eb f7                	jmp    80136e <fd_lookup+0x39>
		return -E_INVAL;
  801377:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80137c:	eb f0                	jmp    80136e <fd_lookup+0x39>
  80137e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801383:	eb e9                	jmp    80136e <fd_lookup+0x39>

00801385 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 08             	sub    $0x8,%esp
  80138b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138e:	ba ec 28 80 00       	mov    $0x8028ec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801393:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801398:	39 08                	cmp    %ecx,(%eax)
  80139a:	74 33                	je     8013cf <dev_lookup+0x4a>
  80139c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80139f:	8b 02                	mov    (%edx),%eax
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	75 f3                	jne    801398 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013a5:	a1 20 44 80 00       	mov    0x804420,%eax
  8013aa:	8b 40 48             	mov    0x48(%eax),%eax
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	51                   	push   %ecx
  8013b1:	50                   	push   %eax
  8013b2:	68 6c 28 80 00       	push   $0x80286c
  8013b7:	e8 40 f0 ff ff       	call   8003fc <cprintf>
	*dev = 0;
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    
			*dev = devtab[i];
  8013cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d9:	eb f2                	jmp    8013cd <dev_lookup+0x48>

008013db <fd_close>:
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	57                   	push   %edi
  8013df:	56                   	push   %esi
  8013e0:	53                   	push   %ebx
  8013e1:	83 ec 24             	sub    $0x24,%esp
  8013e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8013e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013ed:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ee:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013f4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013f7:	50                   	push   %eax
  8013f8:	e8 38 ff ff ff       	call   801335 <fd_lookup>
  8013fd:	89 c3                	mov    %eax,%ebx
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 05                	js     80140b <fd_close+0x30>
	    || fd != fd2)
  801406:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801409:	74 16                	je     801421 <fd_close+0x46>
		return (must_exist ? r : 0);
  80140b:	89 f8                	mov    %edi,%eax
  80140d:	84 c0                	test   %al,%al
  80140f:	b8 00 00 00 00       	mov    $0x0,%eax
  801414:	0f 44 d8             	cmove  %eax,%ebx
}
  801417:	89 d8                	mov    %ebx,%eax
  801419:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141c:	5b                   	pop    %ebx
  80141d:	5e                   	pop    %esi
  80141e:	5f                   	pop    %edi
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801427:	50                   	push   %eax
  801428:	ff 36                	pushl  (%esi)
  80142a:	e8 56 ff ff ff       	call   801385 <dev_lookup>
  80142f:	89 c3                	mov    %eax,%ebx
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	85 c0                	test   %eax,%eax
  801436:	78 1a                	js     801452 <fd_close+0x77>
		if (dev->dev_close)
  801438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80143e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801443:	85 c0                	test   %eax,%eax
  801445:	74 0b                	je     801452 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	56                   	push   %esi
  80144b:	ff d0                	call   *%eax
  80144d:	89 c3                	mov    %eax,%ebx
  80144f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	56                   	push   %esi
  801456:	6a 00                	push   $0x0
  801458:	e8 24 fb ff ff       	call   800f81 <sys_page_unmap>
	return r;
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	eb b5                	jmp    801417 <fd_close+0x3c>

00801462 <close>:

int
close(int fdnum)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801468:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146b:	50                   	push   %eax
  80146c:	ff 75 08             	pushl  0x8(%ebp)
  80146f:	e8 c1 fe ff ff       	call   801335 <fd_lookup>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	79 02                	jns    80147d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    
		return fd_close(fd, 1);
  80147d:	83 ec 08             	sub    $0x8,%esp
  801480:	6a 01                	push   $0x1
  801482:	ff 75 f4             	pushl  -0xc(%ebp)
  801485:	e8 51 ff ff ff       	call   8013db <fd_close>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	eb ec                	jmp    80147b <close+0x19>

0080148f <close_all>:

void
close_all(void)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	53                   	push   %ebx
  801493:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801496:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80149b:	83 ec 0c             	sub    $0xc,%esp
  80149e:	53                   	push   %ebx
  80149f:	e8 be ff ff ff       	call   801462 <close>
	for (i = 0; i < MAXFD; i++)
  8014a4:	83 c3 01             	add    $0x1,%ebx
  8014a7:	83 c4 10             	add    $0x10,%esp
  8014aa:	83 fb 20             	cmp    $0x20,%ebx
  8014ad:	75 ec                	jne    80149b <close_all+0xc>
}
  8014af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	57                   	push   %edi
  8014b8:	56                   	push   %esi
  8014b9:	53                   	push   %ebx
  8014ba:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014c0:	50                   	push   %eax
  8014c1:	ff 75 08             	pushl  0x8(%ebp)
  8014c4:	e8 6c fe ff ff       	call   801335 <fd_lookup>
  8014c9:	89 c3                	mov    %eax,%ebx
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	0f 88 81 00 00 00    	js     801557 <dup+0xa3>
		return r;
	close(newfdnum);
  8014d6:	83 ec 0c             	sub    $0xc,%esp
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	e8 81 ff ff ff       	call   801462 <close>

	newfd = INDEX2FD(newfdnum);
  8014e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014e4:	c1 e6 0c             	shl    $0xc,%esi
  8014e7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014ed:	83 c4 04             	add    $0x4,%esp
  8014f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014f3:	e8 d4 fd ff ff       	call   8012cc <fd2data>
  8014f8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014fa:	89 34 24             	mov    %esi,(%esp)
  8014fd:	e8 ca fd ff ff       	call   8012cc <fd2data>
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801507:	89 d8                	mov    %ebx,%eax
  801509:	c1 e8 16             	shr    $0x16,%eax
  80150c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801513:	a8 01                	test   $0x1,%al
  801515:	74 11                	je     801528 <dup+0x74>
  801517:	89 d8                	mov    %ebx,%eax
  801519:	c1 e8 0c             	shr    $0xc,%eax
  80151c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801523:	f6 c2 01             	test   $0x1,%dl
  801526:	75 39                	jne    801561 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801528:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	c1 e8 0c             	shr    $0xc,%eax
  801530:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801537:	83 ec 0c             	sub    $0xc,%esp
  80153a:	25 07 0e 00 00       	and    $0xe07,%eax
  80153f:	50                   	push   %eax
  801540:	56                   	push   %esi
  801541:	6a 00                	push   $0x0
  801543:	52                   	push   %edx
  801544:	6a 00                	push   $0x0
  801546:	e8 f4 f9 ff ff       	call   800f3f <sys_page_map>
  80154b:	89 c3                	mov    %eax,%ebx
  80154d:	83 c4 20             	add    $0x20,%esp
  801550:	85 c0                	test   %eax,%eax
  801552:	78 31                	js     801585 <dup+0xd1>
		goto err;

	return newfdnum;
  801554:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801557:	89 d8                	mov    %ebx,%eax
  801559:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5f                   	pop    %edi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801561:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801568:	83 ec 0c             	sub    $0xc,%esp
  80156b:	25 07 0e 00 00       	and    $0xe07,%eax
  801570:	50                   	push   %eax
  801571:	57                   	push   %edi
  801572:	6a 00                	push   $0x0
  801574:	53                   	push   %ebx
  801575:	6a 00                	push   $0x0
  801577:	e8 c3 f9 ff ff       	call   800f3f <sys_page_map>
  80157c:	89 c3                	mov    %eax,%ebx
  80157e:	83 c4 20             	add    $0x20,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	79 a3                	jns    801528 <dup+0x74>
	sys_page_unmap(0, newfd);
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	56                   	push   %esi
  801589:	6a 00                	push   $0x0
  80158b:	e8 f1 f9 ff ff       	call   800f81 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801590:	83 c4 08             	add    $0x8,%esp
  801593:	57                   	push   %edi
  801594:	6a 00                	push   $0x0
  801596:	e8 e6 f9 ff ff       	call   800f81 <sys_page_unmap>
	return r;
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	eb b7                	jmp    801557 <dup+0xa3>

008015a0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	53                   	push   %ebx
  8015a4:	83 ec 1c             	sub    $0x1c,%esp
  8015a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ad:	50                   	push   %eax
  8015ae:	53                   	push   %ebx
  8015af:	e8 81 fd ff ff       	call   801335 <fd_lookup>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 3f                	js     8015fa <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c1:	50                   	push   %eax
  8015c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c5:	ff 30                	pushl  (%eax)
  8015c7:	e8 b9 fd ff ff       	call   801385 <dev_lookup>
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 27                	js     8015fa <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d6:	8b 42 08             	mov    0x8(%edx),%eax
  8015d9:	83 e0 03             	and    $0x3,%eax
  8015dc:	83 f8 01             	cmp    $0x1,%eax
  8015df:	74 1e                	je     8015ff <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e4:	8b 40 08             	mov    0x8(%eax),%eax
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	74 35                	je     801620 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	ff 75 10             	pushl  0x10(%ebp)
  8015f1:	ff 75 0c             	pushl  0xc(%ebp)
  8015f4:	52                   	push   %edx
  8015f5:	ff d0                	call   *%eax
  8015f7:	83 c4 10             	add    $0x10,%esp
}
  8015fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ff:	a1 20 44 80 00       	mov    0x804420,%eax
  801604:	8b 40 48             	mov    0x48(%eax),%eax
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	53                   	push   %ebx
  80160b:	50                   	push   %eax
  80160c:	68 b0 28 80 00       	push   $0x8028b0
  801611:	e8 e6 ed ff ff       	call   8003fc <cprintf>
		return -E_INVAL;
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161e:	eb da                	jmp    8015fa <read+0x5a>
		return -E_NOT_SUPP;
  801620:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801625:	eb d3                	jmp    8015fa <read+0x5a>

00801627 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	57                   	push   %edi
  80162b:	56                   	push   %esi
  80162c:	53                   	push   %ebx
  80162d:	83 ec 0c             	sub    $0xc,%esp
  801630:	8b 7d 08             	mov    0x8(%ebp),%edi
  801633:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801636:	bb 00 00 00 00       	mov    $0x0,%ebx
  80163b:	39 f3                	cmp    %esi,%ebx
  80163d:	73 23                	jae    801662 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	89 f0                	mov    %esi,%eax
  801644:	29 d8                	sub    %ebx,%eax
  801646:	50                   	push   %eax
  801647:	89 d8                	mov    %ebx,%eax
  801649:	03 45 0c             	add    0xc(%ebp),%eax
  80164c:	50                   	push   %eax
  80164d:	57                   	push   %edi
  80164e:	e8 4d ff ff ff       	call   8015a0 <read>
		if (m < 0)
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	85 c0                	test   %eax,%eax
  801658:	78 06                	js     801660 <readn+0x39>
			return m;
		if (m == 0)
  80165a:	74 06                	je     801662 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80165c:	01 c3                	add    %eax,%ebx
  80165e:	eb db                	jmp    80163b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801660:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801662:	89 d8                	mov    %ebx,%eax
  801664:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801667:	5b                   	pop    %ebx
  801668:	5e                   	pop    %esi
  801669:	5f                   	pop    %edi
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	53                   	push   %ebx
  801670:	83 ec 1c             	sub    $0x1c,%esp
  801673:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801676:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801679:	50                   	push   %eax
  80167a:	53                   	push   %ebx
  80167b:	e8 b5 fc ff ff       	call   801335 <fd_lookup>
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	85 c0                	test   %eax,%eax
  801685:	78 3a                	js     8016c1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168d:	50                   	push   %eax
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	ff 30                	pushl  (%eax)
  801693:	e8 ed fc ff ff       	call   801385 <dev_lookup>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	85 c0                	test   %eax,%eax
  80169d:	78 22                	js     8016c1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016a6:	74 1e                	je     8016c6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8016ae:	85 d2                	test   %edx,%edx
  8016b0:	74 35                	je     8016e7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016b2:	83 ec 04             	sub    $0x4,%esp
  8016b5:	ff 75 10             	pushl  0x10(%ebp)
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	50                   	push   %eax
  8016bc:	ff d2                	call   *%edx
  8016be:	83 c4 10             	add    $0x10,%esp
}
  8016c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c6:	a1 20 44 80 00       	mov    0x804420,%eax
  8016cb:	8b 40 48             	mov    0x48(%eax),%eax
  8016ce:	83 ec 04             	sub    $0x4,%esp
  8016d1:	53                   	push   %ebx
  8016d2:	50                   	push   %eax
  8016d3:	68 cc 28 80 00       	push   $0x8028cc
  8016d8:	e8 1f ed ff ff       	call   8003fc <cprintf>
		return -E_INVAL;
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e5:	eb da                	jmp    8016c1 <write+0x55>
		return -E_NOT_SUPP;
  8016e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ec:	eb d3                	jmp    8016c1 <write+0x55>

008016ee <seek>:

int
seek(int fdnum, off_t offset)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f7:	50                   	push   %eax
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 35 fc ff ff       	call   801335 <fd_lookup>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	85 c0                	test   %eax,%eax
  801705:	78 0e                	js     801715 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801707:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	53                   	push   %ebx
  80171b:	83 ec 1c             	sub    $0x1c,%esp
  80171e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801721:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801724:	50                   	push   %eax
  801725:	53                   	push   %ebx
  801726:	e8 0a fc ff ff       	call   801335 <fd_lookup>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 37                	js     801769 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801738:	50                   	push   %eax
  801739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173c:	ff 30                	pushl  (%eax)
  80173e:	e8 42 fc ff ff       	call   801385 <dev_lookup>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	85 c0                	test   %eax,%eax
  801748:	78 1f                	js     801769 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80174a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801751:	74 1b                	je     80176e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801756:	8b 52 18             	mov    0x18(%edx),%edx
  801759:	85 d2                	test   %edx,%edx
  80175b:	74 32                	je     80178f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	ff 75 0c             	pushl  0xc(%ebp)
  801763:	50                   	push   %eax
  801764:	ff d2                	call   *%edx
  801766:	83 c4 10             	add    $0x10,%esp
}
  801769:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80176e:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801773:	8b 40 48             	mov    0x48(%eax),%eax
  801776:	83 ec 04             	sub    $0x4,%esp
  801779:	53                   	push   %ebx
  80177a:	50                   	push   %eax
  80177b:	68 8c 28 80 00       	push   $0x80288c
  801780:	e8 77 ec ff ff       	call   8003fc <cprintf>
		return -E_INVAL;
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178d:	eb da                	jmp    801769 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80178f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801794:	eb d3                	jmp    801769 <ftruncate+0x52>

00801796 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	53                   	push   %ebx
  80179a:	83 ec 1c             	sub    $0x1c,%esp
  80179d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a3:	50                   	push   %eax
  8017a4:	ff 75 08             	pushl  0x8(%ebp)
  8017a7:	e8 89 fb ff ff       	call   801335 <fd_lookup>
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 4b                	js     8017fe <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b3:	83 ec 08             	sub    $0x8,%esp
  8017b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b9:	50                   	push   %eax
  8017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bd:	ff 30                	pushl  (%eax)
  8017bf:	e8 c1 fb ff ff       	call   801385 <dev_lookup>
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 33                	js     8017fe <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ce:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017d2:	74 2f                	je     801803 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017d4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017d7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017de:	00 00 00 
	stat->st_isdir = 0;
  8017e1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017e8:	00 00 00 
	stat->st_dev = dev;
  8017eb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017f1:	83 ec 08             	sub    $0x8,%esp
  8017f4:	53                   	push   %ebx
  8017f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f8:	ff 50 14             	call   *0x14(%eax)
  8017fb:	83 c4 10             	add    $0x10,%esp
}
  8017fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801801:	c9                   	leave  
  801802:	c3                   	ret    
		return -E_NOT_SUPP;
  801803:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801808:	eb f4                	jmp    8017fe <fstat+0x68>

0080180a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	56                   	push   %esi
  80180e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	6a 00                	push   $0x0
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	e8 e7 01 00 00       	call   801a03 <open>
  80181c:	89 c3                	mov    %eax,%ebx
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	85 c0                	test   %eax,%eax
  801823:	78 1b                	js     801840 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801825:	83 ec 08             	sub    $0x8,%esp
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	50                   	push   %eax
  80182c:	e8 65 ff ff ff       	call   801796 <fstat>
  801831:	89 c6                	mov    %eax,%esi
	close(fd);
  801833:	89 1c 24             	mov    %ebx,(%esp)
  801836:	e8 27 fc ff ff       	call   801462 <close>
	return r;
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	89 f3                	mov    %esi,%ebx
}
  801840:	89 d8                	mov    %ebx,%eax
  801842:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801845:	5b                   	pop    %ebx
  801846:	5e                   	pop    %esi
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    

00801849 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	56                   	push   %esi
  80184d:	53                   	push   %ebx
  80184e:	89 c6                	mov    %eax,%esi
  801850:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801852:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801859:	74 27                	je     801882 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80185b:	6a 07                	push   $0x7
  80185d:	68 00 50 80 00       	push   $0x805000
  801862:	56                   	push   %esi
  801863:	ff 35 00 40 80 00    	pushl  0x804000
  801869:	e8 78 08 00 00       	call   8020e6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80186e:	83 c4 0c             	add    $0xc,%esp
  801871:	6a 00                	push   $0x0
  801873:	53                   	push   %ebx
  801874:	6a 00                	push   $0x0
  801876:	e8 04 08 00 00       	call   80207f <ipc_recv>
}
  80187b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5e                   	pop    %esi
  801880:	5d                   	pop    %ebp
  801881:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801882:	83 ec 0c             	sub    $0xc,%esp
  801885:	6a 01                	push   $0x1
  801887:	e8 a3 08 00 00       	call   80212f <ipc_find_env>
  80188c:	a3 00 40 80 00       	mov    %eax,0x804000
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	eb c5                	jmp    80185b <fsipc+0x12>

00801896 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018aa:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018af:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b4:	b8 02 00 00 00       	mov    $0x2,%eax
  8018b9:	e8 8b ff ff ff       	call   801849 <fsipc>
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <devfile_flush>:
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018cc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8018db:	e8 69 ff ff ff       	call   801849 <fsipc>
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <devfile_stat>:
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	53                   	push   %ebx
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fc:	b8 05 00 00 00       	mov    $0x5,%eax
  801901:	e8 43 ff ff ff       	call   801849 <fsipc>
  801906:	85 c0                	test   %eax,%eax
  801908:	78 2c                	js     801936 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80190a:	83 ec 08             	sub    $0x8,%esp
  80190d:	68 00 50 80 00       	push   $0x805000
  801912:	53                   	push   %ebx
  801913:	e8 f2 f1 ff ff       	call   800b0a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801918:	a1 80 50 80 00       	mov    0x805080,%eax
  80191d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801923:	a1 84 50 80 00       	mov    0x805084,%eax
  801928:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <devfile_write>:
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 0c             	sub    $0xc,%esp
  801941:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801944:	8b 55 08             	mov    0x8(%ebp),%edx
  801947:	8b 52 0c             	mov    0xc(%edx),%edx
  80194a:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801950:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801955:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80195a:	0f 47 c2             	cmova  %edx,%eax
  80195d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801962:	50                   	push   %eax
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	68 08 50 80 00       	push   $0x805008
  80196b:	e8 28 f3 ff ff       	call   800c98 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801970:	ba 00 00 00 00       	mov    $0x0,%edx
  801975:	b8 04 00 00 00       	mov    $0x4,%eax
  80197a:	e8 ca fe ff ff       	call   801849 <fsipc>
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <devfile_read>:
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
  801986:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	8b 40 0c             	mov    0xc(%eax),%eax
  80198f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801994:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80199a:	ba 00 00 00 00       	mov    $0x0,%edx
  80199f:	b8 03 00 00 00       	mov    $0x3,%eax
  8019a4:	e8 a0 fe ff ff       	call   801849 <fsipc>
  8019a9:	89 c3                	mov    %eax,%ebx
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 1f                	js     8019ce <devfile_read+0x4d>
	assert(r <= n);
  8019af:	39 f0                	cmp    %esi,%eax
  8019b1:	77 24                	ja     8019d7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019b3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019b8:	7f 33                	jg     8019ed <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	50                   	push   %eax
  8019be:	68 00 50 80 00       	push   $0x805000
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	e8 cd f2 ff ff       	call   800c98 <memmove>
	return r;
  8019cb:	83 c4 10             	add    $0x10,%esp
}
  8019ce:	89 d8                	mov    %ebx,%eax
  8019d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d3:	5b                   	pop    %ebx
  8019d4:	5e                   	pop    %esi
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    
	assert(r <= n);
  8019d7:	68 fc 28 80 00       	push   $0x8028fc
  8019dc:	68 03 29 80 00       	push   $0x802903
  8019e1:	6a 7c                	push   $0x7c
  8019e3:	68 18 29 80 00       	push   $0x802918
  8019e8:	e8 34 e9 ff ff       	call   800321 <_panic>
	assert(r <= PGSIZE);
  8019ed:	68 23 29 80 00       	push   $0x802923
  8019f2:	68 03 29 80 00       	push   $0x802903
  8019f7:	6a 7d                	push   $0x7d
  8019f9:	68 18 29 80 00       	push   $0x802918
  8019fe:	e8 1e e9 ff ff       	call   800321 <_panic>

00801a03 <open>:
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	83 ec 1c             	sub    $0x1c,%esp
  801a0b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a0e:	56                   	push   %esi
  801a0f:	e8 bd f0 ff ff       	call   800ad1 <strlen>
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a1c:	7f 6c                	jg     801a8a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	e8 b9 f8 ff ff       	call   8012e3 <fd_alloc>
  801a2a:	89 c3                	mov    %eax,%ebx
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 3c                	js     801a6f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	56                   	push   %esi
  801a37:	68 00 50 80 00       	push   $0x805000
  801a3c:	e8 c9 f0 ff ff       	call   800b0a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a51:	e8 f3 fd ff ff       	call   801849 <fsipc>
  801a56:	89 c3                	mov    %eax,%ebx
  801a58:	83 c4 10             	add    $0x10,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 19                	js     801a78 <open+0x75>
	return fd2num(fd);
  801a5f:	83 ec 0c             	sub    $0xc,%esp
  801a62:	ff 75 f4             	pushl  -0xc(%ebp)
  801a65:	e8 52 f8 ff ff       	call   8012bc <fd2num>
  801a6a:	89 c3                	mov    %eax,%ebx
  801a6c:	83 c4 10             	add    $0x10,%esp
}
  801a6f:	89 d8                	mov    %ebx,%eax
  801a71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    
		fd_close(fd, 0);
  801a78:	83 ec 08             	sub    $0x8,%esp
  801a7b:	6a 00                	push   $0x0
  801a7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a80:	e8 56 f9 ff ff       	call   8013db <fd_close>
		return r;
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	eb e5                	jmp    801a6f <open+0x6c>
		return -E_BAD_PATH;
  801a8a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a8f:	eb de                	jmp    801a6f <open+0x6c>

00801a91 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a97:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9c:	b8 08 00 00 00       	mov    $0x8,%eax
  801aa1:	e8 a3 fd ff ff       	call   801849 <fsipc>
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801aa8:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801aac:	7f 01                	jg     801aaf <writebuf+0x7>
  801aae:	c3                   	ret    
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	53                   	push   %ebx
  801ab3:	83 ec 08             	sub    $0x8,%esp
  801ab6:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801ab8:	ff 70 04             	pushl  0x4(%eax)
  801abb:	8d 40 10             	lea    0x10(%eax),%eax
  801abe:	50                   	push   %eax
  801abf:	ff 33                	pushl  (%ebx)
  801ac1:	e8 a6 fb ff ff       	call   80166c <write>
		if (result > 0)
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	7e 03                	jle    801ad0 <writebuf+0x28>
			b->result += result;
  801acd:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801ad0:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ad3:	74 0d                	je     801ae2 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  801adc:	0f 4f c2             	cmovg  %edx,%eax
  801adf:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <putch>:

static void
putch(int ch, void *thunk)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	53                   	push   %ebx
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801af1:	8b 53 04             	mov    0x4(%ebx),%edx
  801af4:	8d 42 01             	lea    0x1(%edx),%eax
  801af7:	89 43 04             	mov    %eax,0x4(%ebx)
  801afa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801afd:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801b01:	3d 00 01 00 00       	cmp    $0x100,%eax
  801b06:	74 06                	je     801b0e <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801b08:	83 c4 04             	add    $0x4,%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5d                   	pop    %ebp
  801b0d:	c3                   	ret    
		writebuf(b);
  801b0e:	89 d8                	mov    %ebx,%eax
  801b10:	e8 93 ff ff ff       	call   801aa8 <writebuf>
		b->idx = 0;
  801b15:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801b1c:	eb ea                	jmp    801b08 <putch+0x21>

00801b1e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b30:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b37:	00 00 00 
	b.result = 0;
  801b3a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b41:	00 00 00 
	b.error = 1;
  801b44:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b4b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b4e:	ff 75 10             	pushl  0x10(%ebp)
  801b51:	ff 75 0c             	pushl  0xc(%ebp)
  801b54:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b5a:	50                   	push   %eax
  801b5b:	68 e7 1a 80 00       	push   $0x801ae7
  801b60:	e8 c4 e9 ff ff       	call   800529 <vprintfmt>
	if (b.idx > 0)
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b6f:	7f 11                	jg     801b82 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801b71:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b77:	85 c0                	test   %eax,%eax
  801b79:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    
		writebuf(&b);
  801b82:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b88:	e8 1b ff ff ff       	call   801aa8 <writebuf>
  801b8d:	eb e2                	jmp    801b71 <vfprintf+0x53>

00801b8f <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b95:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b98:	50                   	push   %eax
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	ff 75 08             	pushl  0x8(%ebp)
  801b9f:	e8 7a ff ff ff       	call   801b1e <vfprintf>
	va_end(ap);

	return cnt;
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <printf>:

int
printf(const char *fmt, ...)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801baf:	50                   	push   %eax
  801bb0:	ff 75 08             	pushl  0x8(%ebp)
  801bb3:	6a 01                	push   $0x1
  801bb5:	e8 64 ff ff ff       	call   801b1e <vfprintf>
	va_end(ap);

	return cnt;
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	56                   	push   %esi
  801bc0:	53                   	push   %ebx
  801bc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	e8 fd f6 ff ff       	call   8012cc <fd2data>
  801bcf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bd1:	83 c4 08             	add    $0x8,%esp
  801bd4:	68 2f 29 80 00       	push   $0x80292f
  801bd9:	53                   	push   %ebx
  801bda:	e8 2b ef ff ff       	call   800b0a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bdf:	8b 46 04             	mov    0x4(%esi),%eax
  801be2:	2b 06                	sub    (%esi),%eax
  801be4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bea:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bf1:	00 00 00 
	stat->st_dev = &devpipe;
  801bf4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bfb:	30 80 00 
	return 0;
}
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5e                   	pop    %esi
  801c08:	5d                   	pop    %ebp
  801c09:	c3                   	ret    

00801c0a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	53                   	push   %ebx
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c14:	53                   	push   %ebx
  801c15:	6a 00                	push   $0x0
  801c17:	e8 65 f3 ff ff       	call   800f81 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c1c:	89 1c 24             	mov    %ebx,(%esp)
  801c1f:	e8 a8 f6 ff ff       	call   8012cc <fd2data>
  801c24:	83 c4 08             	add    $0x8,%esp
  801c27:	50                   	push   %eax
  801c28:	6a 00                	push   $0x0
  801c2a:	e8 52 f3 ff ff       	call   800f81 <sys_page_unmap>
}
  801c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <_pipeisclosed>:
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	57                   	push   %edi
  801c38:	56                   	push   %esi
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 1c             	sub    $0x1c,%esp
  801c3d:	89 c7                	mov    %eax,%edi
  801c3f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c41:	a1 20 44 80 00       	mov    0x804420,%eax
  801c46:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c49:	83 ec 0c             	sub    $0xc,%esp
  801c4c:	57                   	push   %edi
  801c4d:	e8 1c 05 00 00       	call   80216e <pageref>
  801c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c55:	89 34 24             	mov    %esi,(%esp)
  801c58:	e8 11 05 00 00       	call   80216e <pageref>
		nn = thisenv->env_runs;
  801c5d:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801c63:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	39 cb                	cmp    %ecx,%ebx
  801c6b:	74 1b                	je     801c88 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c6d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c70:	75 cf                	jne    801c41 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c72:	8b 42 58             	mov    0x58(%edx),%eax
  801c75:	6a 01                	push   $0x1
  801c77:	50                   	push   %eax
  801c78:	53                   	push   %ebx
  801c79:	68 36 29 80 00       	push   $0x802936
  801c7e:	e8 79 e7 ff ff       	call   8003fc <cprintf>
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	eb b9                	jmp    801c41 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c88:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c8b:	0f 94 c0             	sete   %al
  801c8e:	0f b6 c0             	movzbl %al,%eax
}
  801c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	5f                   	pop    %edi
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    

00801c99 <devpipe_write>:
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	57                   	push   %edi
  801c9d:	56                   	push   %esi
  801c9e:	53                   	push   %ebx
  801c9f:	83 ec 28             	sub    $0x28,%esp
  801ca2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ca5:	56                   	push   %esi
  801ca6:	e8 21 f6 ff ff       	call   8012cc <fd2data>
  801cab:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cb8:	74 4f                	je     801d09 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cba:	8b 43 04             	mov    0x4(%ebx),%eax
  801cbd:	8b 0b                	mov    (%ebx),%ecx
  801cbf:	8d 51 20             	lea    0x20(%ecx),%edx
  801cc2:	39 d0                	cmp    %edx,%eax
  801cc4:	72 14                	jb     801cda <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801cc6:	89 da                	mov    %ebx,%edx
  801cc8:	89 f0                	mov    %esi,%eax
  801cca:	e8 65 ff ff ff       	call   801c34 <_pipeisclosed>
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	75 3b                	jne    801d0e <devpipe_write+0x75>
			sys_yield();
  801cd3:	e8 05 f2 ff ff       	call   800edd <sys_yield>
  801cd8:	eb e0                	jmp    801cba <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cdd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ce1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ce4:	89 c2                	mov    %eax,%edx
  801ce6:	c1 fa 1f             	sar    $0x1f,%edx
  801ce9:	89 d1                	mov    %edx,%ecx
  801ceb:	c1 e9 1b             	shr    $0x1b,%ecx
  801cee:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cf1:	83 e2 1f             	and    $0x1f,%edx
  801cf4:	29 ca                	sub    %ecx,%edx
  801cf6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cfa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cfe:	83 c0 01             	add    $0x1,%eax
  801d01:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d04:	83 c7 01             	add    $0x1,%edi
  801d07:	eb ac                	jmp    801cb5 <devpipe_write+0x1c>
	return i;
  801d09:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0c:	eb 05                	jmp    801d13 <devpipe_write+0x7a>
				return 0;
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5f                   	pop    %edi
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    

00801d1b <devpipe_read>:
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	57                   	push   %edi
  801d1f:	56                   	push   %esi
  801d20:	53                   	push   %ebx
  801d21:	83 ec 18             	sub    $0x18,%esp
  801d24:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d27:	57                   	push   %edi
  801d28:	e8 9f f5 ff ff       	call   8012cc <fd2data>
  801d2d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	be 00 00 00 00       	mov    $0x0,%esi
  801d37:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d3a:	75 14                	jne    801d50 <devpipe_read+0x35>
	return i;
  801d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3f:	eb 02                	jmp    801d43 <devpipe_read+0x28>
				return i;
  801d41:	89 f0                	mov    %esi,%eax
}
  801d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d46:	5b                   	pop    %ebx
  801d47:	5e                   	pop    %esi
  801d48:	5f                   	pop    %edi
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    
			sys_yield();
  801d4b:	e8 8d f1 ff ff       	call   800edd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d50:	8b 03                	mov    (%ebx),%eax
  801d52:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d55:	75 18                	jne    801d6f <devpipe_read+0x54>
			if (i > 0)
  801d57:	85 f6                	test   %esi,%esi
  801d59:	75 e6                	jne    801d41 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d5b:	89 da                	mov    %ebx,%edx
  801d5d:	89 f8                	mov    %edi,%eax
  801d5f:	e8 d0 fe ff ff       	call   801c34 <_pipeisclosed>
  801d64:	85 c0                	test   %eax,%eax
  801d66:	74 e3                	je     801d4b <devpipe_read+0x30>
				return 0;
  801d68:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6d:	eb d4                	jmp    801d43 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d6f:	99                   	cltd   
  801d70:	c1 ea 1b             	shr    $0x1b,%edx
  801d73:	01 d0                	add    %edx,%eax
  801d75:	83 e0 1f             	and    $0x1f,%eax
  801d78:	29 d0                	sub    %edx,%eax
  801d7a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d82:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d85:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d88:	83 c6 01             	add    $0x1,%esi
  801d8b:	eb aa                	jmp    801d37 <devpipe_read+0x1c>

00801d8d <pipe>:
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	56                   	push   %esi
  801d91:	53                   	push   %ebx
  801d92:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d98:	50                   	push   %eax
  801d99:	e8 45 f5 ff ff       	call   8012e3 <fd_alloc>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	0f 88 23 01 00 00    	js     801ece <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dab:	83 ec 04             	sub    $0x4,%esp
  801dae:	68 07 04 00 00       	push   $0x407
  801db3:	ff 75 f4             	pushl  -0xc(%ebp)
  801db6:	6a 00                	push   $0x0
  801db8:	e8 3f f1 ff ff       	call   800efc <sys_page_alloc>
  801dbd:	89 c3                	mov    %eax,%ebx
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	0f 88 04 01 00 00    	js     801ece <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801dca:	83 ec 0c             	sub    $0xc,%esp
  801dcd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dd0:	50                   	push   %eax
  801dd1:	e8 0d f5 ff ff       	call   8012e3 <fd_alloc>
  801dd6:	89 c3                	mov    %eax,%ebx
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	0f 88 db 00 00 00    	js     801ebe <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	68 07 04 00 00       	push   $0x407
  801deb:	ff 75 f0             	pushl  -0x10(%ebp)
  801dee:	6a 00                	push   $0x0
  801df0:	e8 07 f1 ff ff       	call   800efc <sys_page_alloc>
  801df5:	89 c3                	mov    %eax,%ebx
  801df7:	83 c4 10             	add    $0x10,%esp
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	0f 88 bc 00 00 00    	js     801ebe <pipe+0x131>
	va = fd2data(fd0);
  801e02:	83 ec 0c             	sub    $0xc,%esp
  801e05:	ff 75 f4             	pushl  -0xc(%ebp)
  801e08:	e8 bf f4 ff ff       	call   8012cc <fd2data>
  801e0d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e0f:	83 c4 0c             	add    $0xc,%esp
  801e12:	68 07 04 00 00       	push   $0x407
  801e17:	50                   	push   %eax
  801e18:	6a 00                	push   $0x0
  801e1a:	e8 dd f0 ff ff       	call   800efc <sys_page_alloc>
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	85 c0                	test   %eax,%eax
  801e26:	0f 88 82 00 00 00    	js     801eae <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e32:	e8 95 f4 ff ff       	call   8012cc <fd2data>
  801e37:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e3e:	50                   	push   %eax
  801e3f:	6a 00                	push   $0x0
  801e41:	56                   	push   %esi
  801e42:	6a 00                	push   $0x0
  801e44:	e8 f6 f0 ff ff       	call   800f3f <sys_page_map>
  801e49:	89 c3                	mov    %eax,%ebx
  801e4b:	83 c4 20             	add    $0x20,%esp
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	78 4e                	js     801ea0 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e52:	a1 20 30 80 00       	mov    0x803020,%eax
  801e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e69:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7b:	e8 3c f4 ff ff       	call   8012bc <fd2num>
  801e80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e83:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e85:	83 c4 04             	add    $0x4,%esp
  801e88:	ff 75 f0             	pushl  -0x10(%ebp)
  801e8b:	e8 2c f4 ff ff       	call   8012bc <fd2num>
  801e90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e93:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e9e:	eb 2e                	jmp    801ece <pipe+0x141>
	sys_page_unmap(0, va);
  801ea0:	83 ec 08             	sub    $0x8,%esp
  801ea3:	56                   	push   %esi
  801ea4:	6a 00                	push   $0x0
  801ea6:	e8 d6 f0 ff ff       	call   800f81 <sys_page_unmap>
  801eab:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801eae:	83 ec 08             	sub    $0x8,%esp
  801eb1:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb4:	6a 00                	push   $0x0
  801eb6:	e8 c6 f0 ff ff       	call   800f81 <sys_page_unmap>
  801ebb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ebe:	83 ec 08             	sub    $0x8,%esp
  801ec1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec4:	6a 00                	push   $0x0
  801ec6:	e8 b6 f0 ff ff       	call   800f81 <sys_page_unmap>
  801ecb:	83 c4 10             	add    $0x10,%esp
}
  801ece:	89 d8                	mov    %ebx,%eax
  801ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5d                   	pop    %ebp
  801ed6:	c3                   	ret    

00801ed7 <pipeisclosed>:
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801edd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee0:	50                   	push   %eax
  801ee1:	ff 75 08             	pushl  0x8(%ebp)
  801ee4:	e8 4c f4 ff ff       	call   801335 <fd_lookup>
  801ee9:	83 c4 10             	add    $0x10,%esp
  801eec:	85 c0                	test   %eax,%eax
  801eee:	78 18                	js     801f08 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ef0:	83 ec 0c             	sub    $0xc,%esp
  801ef3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef6:	e8 d1 f3 ff ff       	call   8012cc <fd2data>
	return _pipeisclosed(fd, p);
  801efb:	89 c2                	mov    %eax,%edx
  801efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f00:	e8 2f fd ff ff       	call   801c34 <_pipeisclosed>
  801f05:	83 c4 10             	add    $0x10,%esp
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0f:	c3                   	ret    

00801f10 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f16:	68 4e 29 80 00       	push   $0x80294e
  801f1b:	ff 75 0c             	pushl  0xc(%ebp)
  801f1e:	e8 e7 eb ff ff       	call   800b0a <strcpy>
	return 0;
}
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <devcons_write>:
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	57                   	push   %edi
  801f2e:	56                   	push   %esi
  801f2f:	53                   	push   %ebx
  801f30:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f36:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f3b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f41:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f44:	73 31                	jae    801f77 <devcons_write+0x4d>
		m = n - tot;
  801f46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f49:	29 f3                	sub    %esi,%ebx
  801f4b:	83 fb 7f             	cmp    $0x7f,%ebx
  801f4e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f53:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	53                   	push   %ebx
  801f5a:	89 f0                	mov    %esi,%eax
  801f5c:	03 45 0c             	add    0xc(%ebp),%eax
  801f5f:	50                   	push   %eax
  801f60:	57                   	push   %edi
  801f61:	e8 32 ed ff ff       	call   800c98 <memmove>
		sys_cputs(buf, m);
  801f66:	83 c4 08             	add    $0x8,%esp
  801f69:	53                   	push   %ebx
  801f6a:	57                   	push   %edi
  801f6b:	e8 d0 ee ff ff       	call   800e40 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f70:	01 de                	add    %ebx,%esi
  801f72:	83 c4 10             	add    $0x10,%esp
  801f75:	eb ca                	jmp    801f41 <devcons_write+0x17>
}
  801f77:	89 f0                	mov    %esi,%eax
  801f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5f                   	pop    %edi
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    

00801f81 <devcons_read>:
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 08             	sub    $0x8,%esp
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f90:	74 21                	je     801fb3 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801f92:	e8 c7 ee ff ff       	call   800e5e <sys_cgetc>
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 07                	jne    801fa2 <devcons_read+0x21>
		sys_yield();
  801f9b:	e8 3d ef ff ff       	call   800edd <sys_yield>
  801fa0:	eb f0                	jmp    801f92 <devcons_read+0x11>
	if (c < 0)
  801fa2:	78 0f                	js     801fb3 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801fa4:	83 f8 04             	cmp    $0x4,%eax
  801fa7:	74 0c                	je     801fb5 <devcons_read+0x34>
	*(char*)vbuf = c;
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	88 02                	mov    %al,(%edx)
	return 1;
  801fae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    
		return 0;
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	eb f7                	jmp    801fb3 <devcons_read+0x32>

00801fbc <cputchar>:
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fc8:	6a 01                	push   $0x1
  801fca:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fcd:	50                   	push   %eax
  801fce:	e8 6d ee ff ff       	call   800e40 <sys_cputs>
}
  801fd3:	83 c4 10             	add    $0x10,%esp
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <getchar>:
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fde:	6a 01                	push   $0x1
  801fe0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fe3:	50                   	push   %eax
  801fe4:	6a 00                	push   $0x0
  801fe6:	e8 b5 f5 ff ff       	call   8015a0 <read>
	if (r < 0)
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	78 06                	js     801ff8 <getchar+0x20>
	if (r < 1)
  801ff2:	74 06                	je     801ffa <getchar+0x22>
	return c;
  801ff4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    
		return -E_EOF;
  801ffa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fff:	eb f7                	jmp    801ff8 <getchar+0x20>

00802001 <iscons>:
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802007:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200a:	50                   	push   %eax
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	e8 22 f3 ff ff       	call   801335 <fd_lookup>
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	85 c0                	test   %eax,%eax
  802018:	78 11                	js     80202b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802023:	39 10                	cmp    %edx,(%eax)
  802025:	0f 94 c0             	sete   %al
  802028:	0f b6 c0             	movzbl %al,%eax
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <opencons>:
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802033:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802036:	50                   	push   %eax
  802037:	e8 a7 f2 ff ff       	call   8012e3 <fd_alloc>
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	85 c0                	test   %eax,%eax
  802041:	78 3a                	js     80207d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 07 04 00 00       	push   $0x407
  80204b:	ff 75 f4             	pushl  -0xc(%ebp)
  80204e:	6a 00                	push   $0x0
  802050:	e8 a7 ee ff ff       	call   800efc <sys_page_alloc>
  802055:	83 c4 10             	add    $0x10,%esp
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 21                	js     80207d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802065:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	50                   	push   %eax
  802075:	e8 42 f2 ff ff       	call   8012bc <fd2num>
  80207a:	83 c4 10             	add    $0x10,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	8b 75 08             	mov    0x8(%ebp),%esi
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  80208d:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  80208f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802094:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	50                   	push   %eax
  80209b:	e8 4d f0 ff ff       	call   8010ed <sys_ipc_recv>
	if (from_env_store)
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	85 f6                	test   %esi,%esi
  8020a5:	74 14                	je     8020bb <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  8020a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	78 09                	js     8020b9 <ipc_recv+0x3a>
  8020b0:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8020b6:	8b 52 78             	mov    0x78(%edx),%edx
  8020b9:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  8020bb:	85 db                	test   %ebx,%ebx
  8020bd:	74 14                	je     8020d3 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  8020bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	78 09                	js     8020d1 <ipc_recv+0x52>
  8020c8:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8020ce:	8b 52 7c             	mov    0x7c(%edx),%edx
  8020d1:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 08                	js     8020df <ipc_recv+0x60>
  8020d7:	a1 20 44 80 00       	mov    0x804420,%eax
  8020dc:	8b 40 74             	mov    0x74(%eax),%eax
}
  8020df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e2:	5b                   	pop    %ebx
  8020e3:	5e                   	pop    %esi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    

008020e6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 08             	sub    $0x8,%esp
  8020ec:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020f6:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8020f9:	ff 75 14             	pushl  0x14(%ebp)
  8020fc:	50                   	push   %eax
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	ff 75 08             	pushl  0x8(%ebp)
  802103:	e8 c2 ef ff ff       	call   8010ca <sys_ipc_try_send>
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 02                	js     802111 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  802111:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802114:	75 07                	jne    80211d <ipc_send+0x37>
		sys_yield();
  802116:	e8 c2 ed ff ff       	call   800edd <sys_yield>
}
  80211b:	eb f2                	jmp    80210f <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  80211d:	50                   	push   %eax
  80211e:	68 5a 29 80 00       	push   $0x80295a
  802123:	6a 3c                	push   $0x3c
  802125:	68 6e 29 80 00       	push   $0x80296e
  80212a:	e8 f2 e1 ff ff       	call   800321 <_panic>

0080212f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802135:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  80213a:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  80213d:	c1 e0 04             	shl    $0x4,%eax
  802140:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802145:	8b 40 50             	mov    0x50(%eax),%eax
  802148:	39 c8                	cmp    %ecx,%eax
  80214a:	74 12                	je     80215e <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80214c:	83 c2 01             	add    $0x1,%edx
  80214f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  802155:	75 e3                	jne    80213a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
  80215c:	eb 0e                	jmp    80216c <ipc_find_env+0x3d>
			return envs[i].env_id;
  80215e:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802161:	c1 e0 04             	shl    $0x4,%eax
  802164:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802169:	8b 40 48             	mov    0x48(%eax),%eax
}
  80216c:	5d                   	pop    %ebp
  80216d:	c3                   	ret    

0080216e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802174:	89 d0                	mov    %edx,%eax
  802176:	c1 e8 16             	shr    $0x16,%eax
  802179:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802185:	f6 c1 01             	test   $0x1,%cl
  802188:	74 1d                	je     8021a7 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80218a:	c1 ea 0c             	shr    $0xc,%edx
  80218d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802194:	f6 c2 01             	test   $0x1,%dl
  802197:	74 0e                	je     8021a7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802199:	c1 ea 0c             	shr    $0xc,%edx
  80219c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021a3:	ef 
  8021a4:	0f b7 c0             	movzwl %ax,%eax
}
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    
  8021a9:	66 90                	xchg   %ax,%ax
  8021ab:	66 90                	xchg   %ax,%ax
  8021ad:	66 90                	xchg   %ax,%ax
  8021af:	90                   	nop

008021b0 <__udivdi3>:
  8021b0:	55                   	push   %ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 1c             	sub    $0x1c,%esp
  8021b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021c7:	85 d2                	test   %edx,%edx
  8021c9:	75 4d                	jne    802218 <__udivdi3+0x68>
  8021cb:	39 f3                	cmp    %esi,%ebx
  8021cd:	76 19                	jbe    8021e8 <__udivdi3+0x38>
  8021cf:	31 ff                	xor    %edi,%edi
  8021d1:	89 e8                	mov    %ebp,%eax
  8021d3:	89 f2                	mov    %esi,%edx
  8021d5:	f7 f3                	div    %ebx
  8021d7:	89 fa                	mov    %edi,%edx
  8021d9:	83 c4 1c             	add    $0x1c,%esp
  8021dc:	5b                   	pop    %ebx
  8021dd:	5e                   	pop    %esi
  8021de:	5f                   	pop    %edi
  8021df:	5d                   	pop    %ebp
  8021e0:	c3                   	ret    
  8021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e8:	89 d9                	mov    %ebx,%ecx
  8021ea:	85 db                	test   %ebx,%ebx
  8021ec:	75 0b                	jne    8021f9 <__udivdi3+0x49>
  8021ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f3:	31 d2                	xor    %edx,%edx
  8021f5:	f7 f3                	div    %ebx
  8021f7:	89 c1                	mov    %eax,%ecx
  8021f9:	31 d2                	xor    %edx,%edx
  8021fb:	89 f0                	mov    %esi,%eax
  8021fd:	f7 f1                	div    %ecx
  8021ff:	89 c6                	mov    %eax,%esi
  802201:	89 e8                	mov    %ebp,%eax
  802203:	89 f7                	mov    %esi,%edi
  802205:	f7 f1                	div    %ecx
  802207:	89 fa                	mov    %edi,%edx
  802209:	83 c4 1c             	add    $0x1c,%esp
  80220c:	5b                   	pop    %ebx
  80220d:	5e                   	pop    %esi
  80220e:	5f                   	pop    %edi
  80220f:	5d                   	pop    %ebp
  802210:	c3                   	ret    
  802211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802218:	39 f2                	cmp    %esi,%edx
  80221a:	77 1c                	ja     802238 <__udivdi3+0x88>
  80221c:	0f bd fa             	bsr    %edx,%edi
  80221f:	83 f7 1f             	xor    $0x1f,%edi
  802222:	75 2c                	jne    802250 <__udivdi3+0xa0>
  802224:	39 f2                	cmp    %esi,%edx
  802226:	72 06                	jb     80222e <__udivdi3+0x7e>
  802228:	31 c0                	xor    %eax,%eax
  80222a:	39 eb                	cmp    %ebp,%ebx
  80222c:	77 a9                	ja     8021d7 <__udivdi3+0x27>
  80222e:	b8 01 00 00 00       	mov    $0x1,%eax
  802233:	eb a2                	jmp    8021d7 <__udivdi3+0x27>
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	31 ff                	xor    %edi,%edi
  80223a:	31 c0                	xor    %eax,%eax
  80223c:	89 fa                	mov    %edi,%edx
  80223e:	83 c4 1c             	add    $0x1c,%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5f                   	pop    %edi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    
  802246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80224d:	8d 76 00             	lea    0x0(%esi),%esi
  802250:	89 f9                	mov    %edi,%ecx
  802252:	b8 20 00 00 00       	mov    $0x20,%eax
  802257:	29 f8                	sub    %edi,%eax
  802259:	d3 e2                	shl    %cl,%edx
  80225b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80225f:	89 c1                	mov    %eax,%ecx
  802261:	89 da                	mov    %ebx,%edx
  802263:	d3 ea                	shr    %cl,%edx
  802265:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802269:	09 d1                	or     %edx,%ecx
  80226b:	89 f2                	mov    %esi,%edx
  80226d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802271:	89 f9                	mov    %edi,%ecx
  802273:	d3 e3                	shl    %cl,%ebx
  802275:	89 c1                	mov    %eax,%ecx
  802277:	d3 ea                	shr    %cl,%edx
  802279:	89 f9                	mov    %edi,%ecx
  80227b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80227f:	89 eb                	mov    %ebp,%ebx
  802281:	d3 e6                	shl    %cl,%esi
  802283:	89 c1                	mov    %eax,%ecx
  802285:	d3 eb                	shr    %cl,%ebx
  802287:	09 de                	or     %ebx,%esi
  802289:	89 f0                	mov    %esi,%eax
  80228b:	f7 74 24 08          	divl   0x8(%esp)
  80228f:	89 d6                	mov    %edx,%esi
  802291:	89 c3                	mov    %eax,%ebx
  802293:	f7 64 24 0c          	mull   0xc(%esp)
  802297:	39 d6                	cmp    %edx,%esi
  802299:	72 15                	jb     8022b0 <__udivdi3+0x100>
  80229b:	89 f9                	mov    %edi,%ecx
  80229d:	d3 e5                	shl    %cl,%ebp
  80229f:	39 c5                	cmp    %eax,%ebp
  8022a1:	73 04                	jae    8022a7 <__udivdi3+0xf7>
  8022a3:	39 d6                	cmp    %edx,%esi
  8022a5:	74 09                	je     8022b0 <__udivdi3+0x100>
  8022a7:	89 d8                	mov    %ebx,%eax
  8022a9:	31 ff                	xor    %edi,%edi
  8022ab:	e9 27 ff ff ff       	jmp    8021d7 <__udivdi3+0x27>
  8022b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022b3:	31 ff                	xor    %edi,%edi
  8022b5:	e9 1d ff ff ff       	jmp    8021d7 <__udivdi3+0x27>
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__umoddi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 1c             	sub    $0x1c,%esp
  8022c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022d7:	89 da                	mov    %ebx,%edx
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	75 43                	jne    802320 <__umoddi3+0x60>
  8022dd:	39 df                	cmp    %ebx,%edi
  8022df:	76 17                	jbe    8022f8 <__umoddi3+0x38>
  8022e1:	89 f0                	mov    %esi,%eax
  8022e3:	f7 f7                	div    %edi
  8022e5:	89 d0                	mov    %edx,%eax
  8022e7:	31 d2                	xor    %edx,%edx
  8022e9:	83 c4 1c             	add    $0x1c,%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    
  8022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	89 fd                	mov    %edi,%ebp
  8022fa:	85 ff                	test   %edi,%edi
  8022fc:	75 0b                	jne    802309 <__umoddi3+0x49>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f7                	div    %edi
  802307:	89 c5                	mov    %eax,%ebp
  802309:	89 d8                	mov    %ebx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f5                	div    %ebp
  80230f:	89 f0                	mov    %esi,%eax
  802311:	f7 f5                	div    %ebp
  802313:	89 d0                	mov    %edx,%eax
  802315:	eb d0                	jmp    8022e7 <__umoddi3+0x27>
  802317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231e:	66 90                	xchg   %ax,%ax
  802320:	89 f1                	mov    %esi,%ecx
  802322:	39 d8                	cmp    %ebx,%eax
  802324:	76 0a                	jbe    802330 <__umoddi3+0x70>
  802326:	89 f0                	mov    %esi,%eax
  802328:	83 c4 1c             	add    $0x1c,%esp
  80232b:	5b                   	pop    %ebx
  80232c:	5e                   	pop    %esi
  80232d:	5f                   	pop    %edi
  80232e:	5d                   	pop    %ebp
  80232f:	c3                   	ret    
  802330:	0f bd e8             	bsr    %eax,%ebp
  802333:	83 f5 1f             	xor    $0x1f,%ebp
  802336:	75 20                	jne    802358 <__umoddi3+0x98>
  802338:	39 d8                	cmp    %ebx,%eax
  80233a:	0f 82 b0 00 00 00    	jb     8023f0 <__umoddi3+0x130>
  802340:	39 f7                	cmp    %esi,%edi
  802342:	0f 86 a8 00 00 00    	jbe    8023f0 <__umoddi3+0x130>
  802348:	89 c8                	mov    %ecx,%eax
  80234a:	83 c4 1c             	add    $0x1c,%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5f                   	pop    %edi
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    
  802352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802358:	89 e9                	mov    %ebp,%ecx
  80235a:	ba 20 00 00 00       	mov    $0x20,%edx
  80235f:	29 ea                	sub    %ebp,%edx
  802361:	d3 e0                	shl    %cl,%eax
  802363:	89 44 24 08          	mov    %eax,0x8(%esp)
  802367:	89 d1                	mov    %edx,%ecx
  802369:	89 f8                	mov    %edi,%eax
  80236b:	d3 e8                	shr    %cl,%eax
  80236d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802371:	89 54 24 04          	mov    %edx,0x4(%esp)
  802375:	8b 54 24 04          	mov    0x4(%esp),%edx
  802379:	09 c1                	or     %eax,%ecx
  80237b:	89 d8                	mov    %ebx,%eax
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 e9                	mov    %ebp,%ecx
  802383:	d3 e7                	shl    %cl,%edi
  802385:	89 d1                	mov    %edx,%ecx
  802387:	d3 e8                	shr    %cl,%eax
  802389:	89 e9                	mov    %ebp,%ecx
  80238b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80238f:	d3 e3                	shl    %cl,%ebx
  802391:	89 c7                	mov    %eax,%edi
  802393:	89 d1                	mov    %edx,%ecx
  802395:	89 f0                	mov    %esi,%eax
  802397:	d3 e8                	shr    %cl,%eax
  802399:	89 e9                	mov    %ebp,%ecx
  80239b:	89 fa                	mov    %edi,%edx
  80239d:	d3 e6                	shl    %cl,%esi
  80239f:	09 d8                	or     %ebx,%eax
  8023a1:	f7 74 24 08          	divl   0x8(%esp)
  8023a5:	89 d1                	mov    %edx,%ecx
  8023a7:	89 f3                	mov    %esi,%ebx
  8023a9:	f7 64 24 0c          	mull   0xc(%esp)
  8023ad:	89 c6                	mov    %eax,%esi
  8023af:	89 d7                	mov    %edx,%edi
  8023b1:	39 d1                	cmp    %edx,%ecx
  8023b3:	72 06                	jb     8023bb <__umoddi3+0xfb>
  8023b5:	75 10                	jne    8023c7 <__umoddi3+0x107>
  8023b7:	39 c3                	cmp    %eax,%ebx
  8023b9:	73 0c                	jae    8023c7 <__umoddi3+0x107>
  8023bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023c3:	89 d7                	mov    %edx,%edi
  8023c5:	89 c6                	mov    %eax,%esi
  8023c7:	89 ca                	mov    %ecx,%edx
  8023c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ce:	29 f3                	sub    %esi,%ebx
  8023d0:	19 fa                	sbb    %edi,%edx
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	d3 e0                	shl    %cl,%eax
  8023d6:	89 e9                	mov    %ebp,%ecx
  8023d8:	d3 eb                	shr    %cl,%ebx
  8023da:	d3 ea                	shr    %cl,%edx
  8023dc:	09 d8                	or     %ebx,%eax
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 da                	mov    %ebx,%edx
  8023f2:	29 fe                	sub    %edi,%esi
  8023f4:	19 c2                	sbb    %eax,%edx
  8023f6:	89 f1                	mov    %esi,%ecx
  8023f8:	89 c8                	mov    %ecx,%eax
  8023fa:	e9 4b ff ff ff       	jmp    80234a <__umoddi3+0x8a>
