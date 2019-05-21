
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 54 06 00 00       	call   800685 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 82 0e 00 00       	call   800ec9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 85 15 00 00       	call   8015de <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 2d 15 00 00       	call   801595 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 b5 14 00 00       	call   80152e <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 60 25 80 00       	mov    $0x802560,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 e9 03 00 00    	js     80048f <umain+0x411>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 f3 03 00 00    	jns    8004a1 <umain+0x423>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 95 25 80 00       	mov    $0x802595,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 f0 03 00 00    	js     8004b5 <umain+0x437>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 f5 03 00 00    	jne    8004c7 <umain+0x449>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 e8 03 00 00    	jne    8004c7 <umain+0x449>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 db 03 00 00    	jne    8004c7 <umain+0x449>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 b6 25 80 00       	push   $0x8025b6
  8000f4:	e8 c2 06 00 00       	call   8007bb <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 30 80 00    	call   *0x80301c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 c2 03 00 00    	js     8004db <umain+0x45d>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 30 80 00    	pushl  0x803000
  800122:	e8 69 0d 00 00       	call   800e90 <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 ba 03 00 00    	jne    8004ed <umain+0x46f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 d8 25 80 00       	push   $0x8025d8
  80013b:	e8 7b 06 00 00       	call   8007bb <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 b9 0e 00 00       	call   80100f <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 30 80 00    	call   *0x803010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 9d 03 00 00    	js     800512 <umain+0x494>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 30 80 00    	pushl  0x803000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 ea 0d 00 00       	call   800f74 <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 8f 03 00 00    	jne    800524 <umain+0x4a6>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 17 26 80 00       	push   $0x802617
  80019d:	e8 19 06 00 00       	call   8007bb <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 30 80 00    	call   *0x803018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 7e 03 00 00    	js     800538 <umain+0x4ba>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 39 26 80 00       	push   $0x802639
  8001c2:	e8 f4 05 00 00       	call   8007bb <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001c7:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cf:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d7:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001df:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	68 00 c0 cc cc       	push   $0xccccc000
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 4a 11 00 00       	call   801340 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	68 00 02 00 00       	push   $0x200
  8001fe:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	ff 15 10 30 80 00    	call   *0x803010
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 2f 03 00 00    	jne    80054a <umain+0x4cc>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 4d 26 80 00       	push   $0x80264d
  800223:	e8 93 05 00 00       	call   8007bb <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800228:	ba 02 01 00 00       	mov    $0x102,%edx
  80022d:	b8 63 26 80 00       	mov    $0x802663,%eax
  800232:	e8 fc fd ff ff       	call   800033 <xopen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 88 1a 03 00 00    	js     80055c <umain+0x4de>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800242:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 35 00 30 80 00    	pushl  0x803000
  800251:	e8 3a 0c 00 00       	call   800e90 <strlen>
  800256:	83 c4 0c             	add    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	ff 35 00 30 80 00    	pushl  0x803000
  800260:	68 00 c0 cc cc       	push   $0xccccc000
  800265:	ff d3                	call   *%ebx
  800267:	89 c3                	mov    %eax,%ebx
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 35 00 30 80 00    	pushl  0x803000
  800272:	e8 19 0c 00 00       	call   800e90 <strlen>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	39 d8                	cmp    %ebx,%eax
  80027c:	0f 85 ec 02 00 00    	jne    80056e <umain+0x4f0>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 95 26 80 00       	push   $0x802695
  80028a:	e8 2c 05 00 00       	call   8007bb <cprintf>

	FVA->fd_offset = 0;
  80028f:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800296:	00 00 00 
	memset(buf, 0, sizeof buf);
  800299:	83 c4 0c             	add    $0xc,%esp
  80029c:	68 00 02 00 00       	push   $0x200
  8002a1:	6a 00                	push   $0x0
  8002a3:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a9:	53                   	push   %ebx
  8002aa:	e8 60 0d 00 00       	call   80100f <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002af:	83 c4 0c             	add    $0xc,%esp
  8002b2:	68 00 02 00 00       	push   $0x200
  8002b7:	53                   	push   %ebx
  8002b8:	68 00 c0 cc cc       	push   $0xccccc000
  8002bd:	ff 15 10 30 80 00    	call   *0x803010
  8002c3:	89 c3                	mov    %eax,%ebx
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 b0 02 00 00    	js     800580 <umain+0x502>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 35 00 30 80 00    	pushl  0x803000
  8002d9:	e8 b2 0b 00 00       	call   800e90 <strlen>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	39 d8                	cmp    %ebx,%eax
  8002e3:	0f 85 a9 02 00 00    	jne    800592 <umain+0x514>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 35 00 30 80 00    	pushl  0x803000
  8002f2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 76 0c 00 00       	call   800f74 <strcmp>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	85 c0                	test   %eax,%eax
  800303:	0f 85 9b 02 00 00    	jne    8005a4 <umain+0x526>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 5c 28 80 00       	push   $0x80285c
  800311:	e8 a5 04 00 00       	call   8007bb <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 60 25 80 00       	push   $0x802560
  800320:	e8 3f 1a 00 00       	call   801d64 <open>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032b:	74 08                	je     800335 <umain+0x2b7>
  80032d:	85 c0                	test   %eax,%eax
  80032f:	0f 88 83 02 00 00    	js     8005b8 <umain+0x53a>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 89 8d 02 00 00    	jns    8005ca <umain+0x54c>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 95 25 80 00       	push   $0x802595
  800347:	e8 18 1a 00 00       	call   801d64 <open>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 88 87 02 00 00    	js     8005de <umain+0x560>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800357:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800361:	0f 85 89 02 00 00    	jne    8005f0 <umain+0x572>
  800367:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80036e:	0f 85 7c 02 00 00    	jne    8005f0 <umain+0x572>
  800374:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	0f 85 6e 02 00 00    	jne    8005f0 <umain+0x572>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 bc 25 80 00       	push   $0x8025bc
  80038a:	e8 2c 04 00 00       	call   8007bb <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	68 01 01 00 00       	push   $0x101
  800397:	68 c4 26 80 00       	push   $0x8026c4
  80039c:	e8 c3 19 00 00       	call   801d64 <open>
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	0f 88 56 02 00 00    	js     800604 <umain+0x586>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 00 02 00 00       	push   $0x200
  8003b6:	6a 00                	push   $0x0
  8003b8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 4b 0c 00 00       	call   80100f <memset>
  8003c4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003c7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003c9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 00 02 00 00       	push   $0x200
  8003d7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	57                   	push   %edi
  8003df:	e8 e9 15 00 00       	call   8019cd <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 88 27 02 00 00    	js     800616 <umain+0x598>
  8003ef:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f5:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003fb:	75 cc                	jne    8003c9 <umain+0x34b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	57                   	push   %edi
  800401:	e8 bd 13 00 00       	call   8017c3 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	6a 00                	push   $0x0
  80040b:	68 c4 26 80 00       	push   $0x8026c4
  800410:	e8 4f 19 00 00       	call   801d64 <open>
  800415:	89 c6                	mov    %eax,%esi
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	85 c0                	test   %eax,%eax
  80041c:	0f 88 0a 02 00 00    	js     80062c <umain+0x5ae>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800422:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800428:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 00 02 00 00       	push   $0x200
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	e8 4b 15 00 00       	call   801988 <readn>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 c0                	test   %eax,%eax
  800442:	0f 88 f6 01 00 00    	js     80063e <umain+0x5c0>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800448:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044d:	0f 85 01 02 00 00    	jne    800654 <umain+0x5d6>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800453:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800459:	39 d8                	cmp    %ebx,%eax
  80045b:	0f 85 0e 02 00 00    	jne    80066f <umain+0x5f1>
  800461:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800467:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80046d:	75 b9                	jne    800428 <umain+0x3aa>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	56                   	push   %esi
  800473:	e8 4b 13 00 00       	call   8017c3 <close>
	cprintf("large file is good\n");
  800478:	c7 04 24 09 27 80 00 	movl   $0x802709,(%esp)
  80047f:	e8 37 03 00 00       	call   8007bb <cprintf>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  80048f:	50                   	push   %eax
  800490:	68 6b 25 80 00       	push   $0x80256b
  800495:	6a 20                	push   $0x20
  800497:	68 85 25 80 00       	push   $0x802585
  80049c:	e8 3f 02 00 00       	call   8006e0 <_panic>
		panic("serve_open /not-found succeeded!");
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 20 27 80 00       	push   $0x802720
  8004a9:	6a 22                	push   $0x22
  8004ab:	68 85 25 80 00       	push   $0x802585
  8004b0:	e8 2b 02 00 00       	call   8006e0 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b5:	50                   	push   %eax
  8004b6:	68 9e 25 80 00       	push   $0x80259e
  8004bb:	6a 25                	push   $0x25
  8004bd:	68 85 25 80 00       	push   $0x802585
  8004c2:	e8 19 02 00 00       	call   8006e0 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	68 44 27 80 00       	push   $0x802744
  8004cf:	6a 27                	push   $0x27
  8004d1:	68 85 25 80 00       	push   $0x802585
  8004d6:	e8 05 02 00 00       	call   8006e0 <_panic>
		panic("file_stat: %e", r);
  8004db:	50                   	push   %eax
  8004dc:	68 ca 25 80 00       	push   $0x8025ca
  8004e1:	6a 2b                	push   $0x2b
  8004e3:	68 85 25 80 00       	push   $0x802585
  8004e8:	e8 f3 01 00 00       	call   8006e0 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 35 00 30 80 00    	pushl  0x803000
  8004f6:	e8 95 09 00 00       	call   800e90 <strlen>
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800501:	68 74 27 80 00       	push   $0x802774
  800506:	6a 2d                	push   $0x2d
  800508:	68 85 25 80 00       	push   $0x802585
  80050d:	e8 ce 01 00 00       	call   8006e0 <_panic>
		panic("file_read: %e", r);
  800512:	50                   	push   %eax
  800513:	68 eb 25 80 00       	push   $0x8025eb
  800518:	6a 32                	push   $0x32
  80051a:	68 85 25 80 00       	push   $0x802585
  80051f:	e8 bc 01 00 00       	call   8006e0 <_panic>
		panic("file_read returned wrong data");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 f9 25 80 00       	push   $0x8025f9
  80052c:	6a 34                	push   $0x34
  80052e:	68 85 25 80 00       	push   $0x802585
  800533:	e8 a8 01 00 00       	call   8006e0 <_panic>
		panic("file_close: %e", r);
  800538:	50                   	push   %eax
  800539:	68 2a 26 80 00       	push   $0x80262a
  80053e:	6a 38                	push   $0x38
  800540:	68 85 25 80 00       	push   $0x802585
  800545:	e8 96 01 00 00       	call   8006e0 <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054a:	50                   	push   %eax
  80054b:	68 9c 27 80 00       	push   $0x80279c
  800550:	6a 43                	push   $0x43
  800552:	68 85 25 80 00       	push   $0x802585
  800557:	e8 84 01 00 00       	call   8006e0 <_panic>
		panic("serve_open /new-file: %e", r);
  80055c:	50                   	push   %eax
  80055d:	68 6d 26 80 00       	push   $0x80266d
  800562:	6a 48                	push   $0x48
  800564:	68 85 25 80 00       	push   $0x802585
  800569:	e8 72 01 00 00       	call   8006e0 <_panic>
		panic("file_write: %e", r);
  80056e:	53                   	push   %ebx
  80056f:	68 86 26 80 00       	push   $0x802686
  800574:	6a 4b                	push   $0x4b
  800576:	68 85 25 80 00       	push   $0x802585
  80057b:	e8 60 01 00 00       	call   8006e0 <_panic>
		panic("file_read after file_write: %e", r);
  800580:	50                   	push   %eax
  800581:	68 d4 27 80 00       	push   $0x8027d4
  800586:	6a 51                	push   $0x51
  800588:	68 85 25 80 00       	push   $0x802585
  80058d:	e8 4e 01 00 00       	call   8006e0 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800592:	53                   	push   %ebx
  800593:	68 f4 27 80 00       	push   $0x8027f4
  800598:	6a 53                	push   $0x53
  80059a:	68 85 25 80 00       	push   $0x802585
  80059f:	e8 3c 01 00 00       	call   8006e0 <_panic>
		panic("file_read after file_write returned wrong data");
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	68 2c 28 80 00       	push   $0x80282c
  8005ac:	6a 55                	push   $0x55
  8005ae:	68 85 25 80 00       	push   $0x802585
  8005b3:	e8 28 01 00 00       	call   8006e0 <_panic>
		panic("open /not-found: %e", r);
  8005b8:	50                   	push   %eax
  8005b9:	68 71 25 80 00       	push   $0x802571
  8005be:	6a 5a                	push   $0x5a
  8005c0:	68 85 25 80 00       	push   $0x802585
  8005c5:	e8 16 01 00 00       	call   8006e0 <_panic>
		panic("open /not-found succeeded!");
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	68 a9 26 80 00       	push   $0x8026a9
  8005d2:	6a 5c                	push   $0x5c
  8005d4:	68 85 25 80 00       	push   $0x802585
  8005d9:	e8 02 01 00 00       	call   8006e0 <_panic>
		panic("open /newmotd: %e", r);
  8005de:	50                   	push   %eax
  8005df:	68 a4 25 80 00       	push   $0x8025a4
  8005e4:	6a 5f                	push   $0x5f
  8005e6:	68 85 25 80 00       	push   $0x802585
  8005eb:	e8 f0 00 00 00       	call   8006e0 <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 80 28 80 00       	push   $0x802880
  8005f8:	6a 62                	push   $0x62
  8005fa:	68 85 25 80 00       	push   $0x802585
  8005ff:	e8 dc 00 00 00       	call   8006e0 <_panic>
		panic("creat /big: %e", f);
  800604:	50                   	push   %eax
  800605:	68 c9 26 80 00       	push   $0x8026c9
  80060a:	6a 67                	push   $0x67
  80060c:	68 85 25 80 00       	push   $0x802585
  800611:	e8 ca 00 00 00       	call   8006e0 <_panic>
			panic("write /big@%d: %e", i, r);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	68 d8 26 80 00       	push   $0x8026d8
  800620:	6a 6c                	push   $0x6c
  800622:	68 85 25 80 00       	push   $0x802585
  800627:	e8 b4 00 00 00       	call   8006e0 <_panic>
		panic("open /big: %e", f);
  80062c:	50                   	push   %eax
  80062d:	68 ea 26 80 00       	push   $0x8026ea
  800632:	6a 71                	push   $0x71
  800634:	68 85 25 80 00       	push   $0x802585
  800639:	e8 a2 00 00 00       	call   8006e0 <_panic>
			panic("read /big@%d: %e", i, r);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	50                   	push   %eax
  800642:	53                   	push   %ebx
  800643:	68 f8 26 80 00       	push   $0x8026f8
  800648:	6a 75                	push   $0x75
  80064a:	68 85 25 80 00       	push   $0x802585
  80064f:	e8 8c 00 00 00       	call   8006e0 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	68 00 02 00 00       	push   $0x200
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	68 a8 28 80 00       	push   $0x8028a8
  800663:	6a 78                	push   $0x78
  800665:	68 85 25 80 00       	push   $0x802585
  80066a:	e8 71 00 00 00       	call   8006e0 <_panic>
			panic("read /big from %d returned bad data %d",
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	53                   	push   %ebx
  800674:	68 d4 28 80 00       	push   $0x8028d4
  800679:	6a 7b                	push   $0x7b
  80067b:	68 85 25 80 00       	push   $0x802585
  800680:	e8 5b 00 00 00       	call   8006e0 <_panic>

00800685 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	56                   	push   %esi
  800689:	53                   	push   %ebx
  80068a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80068d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800690:	e8 e8 0b 00 00       	call   80127d <sys_getenvid>
  800695:	25 ff 03 00 00       	and    $0x3ff,%eax
  80069a:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  80069d:	c1 e0 04             	shl    $0x4,%eax
  8006a0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a5:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006aa:	85 db                	test   %ebx,%ebx
  8006ac:	7e 07                	jle    8006b5 <libmain+0x30>
		binaryname = argv[0];
  8006ae:	8b 06                	mov    (%esi),%eax
  8006b0:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	56                   	push   %esi
  8006b9:	53                   	push   %ebx
  8006ba:	e8 bf f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006bf:	e8 0a 00 00 00       	call   8006ce <exit>
}
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006ca:	5b                   	pop    %ebx
  8006cb:	5e                   	pop    %esi
  8006cc:	5d                   	pop    %ebp
  8006cd:	c3                   	ret    

008006ce <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  8006d4:	6a 00                	push   $0x0
  8006d6:	e8 61 0b 00 00       	call   80123c <sys_env_destroy>
}
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	56                   	push   %esi
  8006e4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006e5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006e8:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8006ee:	e8 8a 0b 00 00       	call   80127d <sys_getenvid>
  8006f3:	83 ec 0c             	sub    $0xc,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 08             	pushl  0x8(%ebp)
  8006fc:	56                   	push   %esi
  8006fd:	50                   	push   %eax
  8006fe:	68 2c 29 80 00       	push   $0x80292c
  800703:	e8 b3 00 00 00       	call   8007bb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800708:	83 c4 18             	add    $0x18,%esp
  80070b:	53                   	push   %ebx
  80070c:	ff 75 10             	pushl  0x10(%ebp)
  80070f:	e8 56 00 00 00       	call   80076a <vcprintf>
	cprintf("\n");
  800714:	c7 04 24 e7 2d 80 00 	movl   $0x802de7,(%esp)
  80071b:	e8 9b 00 00 00       	call   8007bb <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800723:	cc                   	int3   
  800724:	eb fd                	jmp    800723 <_panic+0x43>

00800726 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	53                   	push   %ebx
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800730:	8b 13                	mov    (%ebx),%edx
  800732:	8d 42 01             	lea    0x1(%edx),%eax
  800735:	89 03                	mov    %eax,(%ebx)
  800737:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80073a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80073e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800743:	74 09                	je     80074e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800745:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800749:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	68 ff 00 00 00       	push   $0xff
  800756:	8d 43 08             	lea    0x8(%ebx),%eax
  800759:	50                   	push   %eax
  80075a:	e8 a0 0a 00 00       	call   8011ff <sys_cputs>
		b->idx = 0;
  80075f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	eb db                	jmp    800745 <putch+0x1f>

0080076a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800773:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80077a:	00 00 00 
	b.cnt = 0;
  80077d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800784:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	ff 75 08             	pushl  0x8(%ebp)
  80078d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800793:	50                   	push   %eax
  800794:	68 26 07 80 00       	push   $0x800726
  800799:	e8 4a 01 00 00       	call   8008e8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80079e:	83 c4 08             	add    $0x8,%esp
  8007a1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007a7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007ad:	50                   	push   %eax
  8007ae:	e8 4c 0a 00 00       	call   8011ff <sys_cputs>

	return b.cnt;
}
  8007b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007c4:	50                   	push   %eax
  8007c5:	ff 75 08             	pushl  0x8(%ebp)
  8007c8:	e8 9d ff ff ff       	call   80076a <vcprintf>
	va_end(ap);

	return cnt;
}
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	57                   	push   %edi
  8007d3:	56                   	push   %esi
  8007d4:	53                   	push   %ebx
  8007d5:	83 ec 1c             	sub    $0x1c,%esp
  8007d8:	89 c6                	mov    %eax,%esi
  8007da:	89 d7                	mov    %edx,%edi
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8007ee:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8007f2:	74 2c                	je     800820 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8007fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800801:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800804:	39 c2                	cmp    %eax,%edx
  800806:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800809:	73 43                	jae    80084e <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080b:	83 eb 01             	sub    $0x1,%ebx
  80080e:	85 db                	test   %ebx,%ebx
  800810:	7e 6c                	jle    80087e <printnum+0xaf>
			putch(padc, putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	57                   	push   %edi
  800816:	ff 75 18             	pushl  0x18(%ebp)
  800819:	ff d6                	call   *%esi
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	eb eb                	jmp    80080b <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  800820:	83 ec 0c             	sub    $0xc,%esp
  800823:	6a 20                	push   $0x20
  800825:	6a 00                	push   $0x0
  800827:	50                   	push   %eax
  800828:	ff 75 e4             	pushl  -0x1c(%ebp)
  80082b:	ff 75 e0             	pushl  -0x20(%ebp)
  80082e:	89 fa                	mov    %edi,%edx
  800830:	89 f0                	mov    %esi,%eax
  800832:	e8 98 ff ff ff       	call   8007cf <printnum>
		while (--width > 0)
  800837:	83 c4 20             	add    $0x20,%esp
  80083a:	83 eb 01             	sub    $0x1,%ebx
  80083d:	85 db                	test   %ebx,%ebx
  80083f:	7e 65                	jle    8008a6 <printnum+0xd7>
			putch(padc, putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	57                   	push   %edi
  800845:	6a 20                	push   $0x20
  800847:	ff d6                	call   *%esi
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	eb ec                	jmp    80083a <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084e:	83 ec 0c             	sub    $0xc,%esp
  800851:	ff 75 18             	pushl  0x18(%ebp)
  800854:	83 eb 01             	sub    $0x1,%ebx
  800857:	53                   	push   %ebx
  800858:	50                   	push   %eax
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 dc             	pushl  -0x24(%ebp)
  80085f:	ff 75 d8             	pushl  -0x28(%ebp)
  800862:	ff 75 e4             	pushl  -0x1c(%ebp)
  800865:	ff 75 e0             	pushl  -0x20(%ebp)
  800868:	e8 a3 1a 00 00       	call   802310 <__udivdi3>
  80086d:	83 c4 18             	add    $0x18,%esp
  800870:	52                   	push   %edx
  800871:	50                   	push   %eax
  800872:	89 fa                	mov    %edi,%edx
  800874:	89 f0                	mov    %esi,%eax
  800876:	e8 54 ff ff ff       	call   8007cf <printnum>
  80087b:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	57                   	push   %edi
  800882:	83 ec 04             	sub    $0x4,%esp
  800885:	ff 75 dc             	pushl  -0x24(%ebp)
  800888:	ff 75 d8             	pushl  -0x28(%ebp)
  80088b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80088e:	ff 75 e0             	pushl  -0x20(%ebp)
  800891:	e8 8a 1b 00 00       	call   802420 <__umoddi3>
  800896:	83 c4 14             	add    $0x14,%esp
  800899:	0f be 80 4f 29 80 00 	movsbl 0x80294f(%eax),%eax
  8008a0:	50                   	push   %eax
  8008a1:	ff d6                	call   *%esi
  8008a3:	83 c4 10             	add    $0x10,%esp
}
  8008a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a9:	5b                   	pop    %ebx
  8008aa:	5e                   	pop    %esi
  8008ab:	5f                   	pop    %edi
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8008b4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8008b8:	8b 10                	mov    (%eax),%edx
  8008ba:	3b 50 04             	cmp    0x4(%eax),%edx
  8008bd:	73 0a                	jae    8008c9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8008bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008c2:	89 08                	mov    %ecx,(%eax)
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	88 02                	mov    %al,(%edx)
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <printfmt>:
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008d1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008d4:	50                   	push   %eax
  8008d5:	ff 75 10             	pushl  0x10(%ebp)
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 05 00 00 00       	call   8008e8 <vprintfmt>
}
  8008e3:	83 c4 10             	add    $0x10,%esp
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <vprintfmt>:
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	57                   	push   %edi
  8008ec:	56                   	push   %esi
  8008ed:	53                   	push   %ebx
  8008ee:	83 ec 3c             	sub    $0x3c,%esp
  8008f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008f7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008fa:	e9 b4 03 00 00       	jmp    800cb3 <vprintfmt+0x3cb>
		padc = ' ';
  8008ff:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800903:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80090a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800911:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80091f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800924:	8d 47 01             	lea    0x1(%edi),%eax
  800927:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092a:	0f b6 17             	movzbl (%edi),%edx
  80092d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800930:	3c 55                	cmp    $0x55,%al
  800932:	0f 87 c8 04 00 00    	ja     800e00 <vprintfmt+0x518>
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	ff 24 85 20 2b 80 00 	jmp    *0x802b20(,%eax,4)
  800942:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  800945:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  80094c:	eb d6                	jmp    800924 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  80094e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800951:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800955:	eb cd                	jmp    800924 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  800957:	0f b6 d2             	movzbl %dl,%edx
  80095a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80095d:	b8 00 00 00 00       	mov    $0x0,%eax
  800962:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800965:	eb 0c                	jmp    800973 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  800967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80096a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80096e:	eb b4                	jmp    800924 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  800970:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800973:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800976:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80097a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80097d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800980:	83 f9 09             	cmp    $0x9,%ecx
  800983:	76 eb                	jbe    800970 <vprintfmt+0x88>
  800985:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800988:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098b:	eb 14                	jmp    8009a1 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800995:	8b 45 14             	mov    0x14(%ebp),%eax
  800998:	8d 40 04             	lea    0x4(%eax),%eax
  80099b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80099e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8009a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a5:	0f 89 79 ff ff ff    	jns    800924 <vprintfmt+0x3c>
				width = precision, precision = -1;
  8009ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009b1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8009b8:	e9 67 ff ff ff       	jmp    800924 <vprintfmt+0x3c>
  8009bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	0f 49 d0             	cmovns %eax,%edx
  8009ca:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009d0:	e9 4f ff ff ff       	jmp    800924 <vprintfmt+0x3c>
  8009d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009d8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8009df:	e9 40 ff ff ff       	jmp    800924 <vprintfmt+0x3c>
			lflag++;
  8009e4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009ea:	e9 35 ff ff ff       	jmp    800924 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  8009ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f2:	8d 78 04             	lea    0x4(%eax),%edi
  8009f5:	83 ec 08             	sub    $0x8,%esp
  8009f8:	53                   	push   %ebx
  8009f9:	ff 30                	pushl  (%eax)
  8009fb:	ff d6                	call   *%esi
			break;
  8009fd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a00:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a03:	e9 a8 02 00 00       	jmp    800cb0 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	8d 78 04             	lea    0x4(%eax),%edi
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	99                   	cltd   
  800a11:	31 d0                	xor    %edx,%eax
  800a13:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a15:	83 f8 0f             	cmp    $0xf,%eax
  800a18:	7f 23                	jg     800a3d <vprintfmt+0x155>
  800a1a:	8b 14 85 80 2c 80 00 	mov    0x802c80(,%eax,4),%edx
  800a21:	85 d2                	test   %edx,%edx
  800a23:	74 18                	je     800a3d <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800a25:	52                   	push   %edx
  800a26:	68 b5 2d 80 00       	push   $0x802db5
  800a2b:	53                   	push   %ebx
  800a2c:	56                   	push   %esi
  800a2d:	e8 99 fe ff ff       	call   8008cb <printfmt>
  800a32:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a35:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a38:	e9 73 02 00 00       	jmp    800cb0 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800a3d:	50                   	push   %eax
  800a3e:	68 67 29 80 00       	push   $0x802967
  800a43:	53                   	push   %ebx
  800a44:	56                   	push   %esi
  800a45:	e8 81 fe ff ff       	call   8008cb <printfmt>
  800a4a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a4d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a50:	e9 5b 02 00 00       	jmp    800cb0 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	83 c0 04             	add    $0x4,%eax
  800a5b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a61:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800a63:	85 d2                	test   %edx,%edx
  800a65:	b8 60 29 80 00       	mov    $0x802960,%eax
  800a6a:	0f 45 c2             	cmovne %edx,%eax
  800a6d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800a70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a74:	7e 06                	jle    800a7c <vprintfmt+0x194>
  800a76:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800a7a:	75 0d                	jne    800a89 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a7f:	89 c7                	mov    %eax,%edi
  800a81:	03 45 e0             	add    -0x20(%ebp),%eax
  800a84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a87:	eb 53                	jmp    800adc <vprintfmt+0x1f4>
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 d8             	pushl  -0x28(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	e8 13 04 00 00       	call   800ea8 <strnlen>
  800a95:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a98:	29 c1                	sub    %eax,%ecx
  800a9a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800a9d:	83 c4 10             	add    $0x10,%esp
  800aa0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800aa2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800aa6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa9:	eb 0f                	jmp    800aba <vprintfmt+0x1d2>
					putch(padc, putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	53                   	push   %ebx
  800aaf:	ff 75 e0             	pushl  -0x20(%ebp)
  800ab2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab4:	83 ef 01             	sub    $0x1,%edi
  800ab7:	83 c4 10             	add    $0x10,%esp
  800aba:	85 ff                	test   %edi,%edi
  800abc:	7f ed                	jg     800aab <vprintfmt+0x1c3>
  800abe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800ac1:	85 d2                	test   %edx,%edx
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac8:	0f 49 c2             	cmovns %edx,%eax
  800acb:	29 c2                	sub    %eax,%edx
  800acd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800ad0:	eb aa                	jmp    800a7c <vprintfmt+0x194>
					putch(ch, putdat);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	53                   	push   %ebx
  800ad6:	52                   	push   %edx
  800ad7:	ff d6                	call   *%esi
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800adf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ae1:	83 c7 01             	add    $0x1,%edi
  800ae4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ae8:	0f be d0             	movsbl %al,%edx
  800aeb:	85 d2                	test   %edx,%edx
  800aed:	74 4b                	je     800b3a <vprintfmt+0x252>
  800aef:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800af3:	78 06                	js     800afb <vprintfmt+0x213>
  800af5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800af9:	78 1e                	js     800b19 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800afb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800aff:	74 d1                	je     800ad2 <vprintfmt+0x1ea>
  800b01:	0f be c0             	movsbl %al,%eax
  800b04:	83 e8 20             	sub    $0x20,%eax
  800b07:	83 f8 5e             	cmp    $0x5e,%eax
  800b0a:	76 c6                	jbe    800ad2 <vprintfmt+0x1ea>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	53                   	push   %ebx
  800b10:	6a 3f                	push   $0x3f
  800b12:	ff d6                	call   *%esi
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	eb c3                	jmp    800adc <vprintfmt+0x1f4>
  800b19:	89 cf                	mov    %ecx,%edi
  800b1b:	eb 0e                	jmp    800b2b <vprintfmt+0x243>
				putch(' ', putdat);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	53                   	push   %ebx
  800b21:	6a 20                	push   $0x20
  800b23:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b25:	83 ef 01             	sub    $0x1,%edi
  800b28:	83 c4 10             	add    $0x10,%esp
  800b2b:	85 ff                	test   %edi,%edi
  800b2d:	7f ee                	jg     800b1d <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800b2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	e9 76 01 00 00       	jmp    800cb0 <vprintfmt+0x3c8>
  800b3a:	89 cf                	mov    %ecx,%edi
  800b3c:	eb ed                	jmp    800b2b <vprintfmt+0x243>
	if (lflag >= 2)
  800b3e:	83 f9 01             	cmp    $0x1,%ecx
  800b41:	7f 1f                	jg     800b62 <vprintfmt+0x27a>
	else if (lflag)
  800b43:	85 c9                	test   %ecx,%ecx
  800b45:	74 6a                	je     800bb1 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	8b 00                	mov    (%eax),%eax
  800b4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b4f:	89 c1                	mov    %eax,%ecx
  800b51:	c1 f9 1f             	sar    $0x1f,%ecx
  800b54:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b57:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5a:	8d 40 04             	lea    0x4(%eax),%eax
  800b5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b60:	eb 17                	jmp    800b79 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	8b 50 04             	mov    0x4(%eax),%edx
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b6d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	8d 40 08             	lea    0x8(%eax),%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b79:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800b7c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800b81:	85 d2                	test   %edx,%edx
  800b83:	0f 89 f8 00 00 00    	jns    800c81 <vprintfmt+0x399>
				putch('-', putdat);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	53                   	push   %ebx
  800b8d:	6a 2d                	push   $0x2d
  800b8f:	ff d6                	call   *%esi
				num = -(long long) num;
  800b91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b97:	f7 d8                	neg    %eax
  800b99:	83 d2 00             	adc    $0x0,%edx
  800b9c:	f7 da                	neg    %edx
  800b9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ba1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ba4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ba7:	bf 0a 00 00 00       	mov    $0xa,%edi
  800bac:	e9 e1 00 00 00       	jmp    800c92 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb9:	99                   	cltd   
  800bba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc0:	8d 40 04             	lea    0x4(%eax),%eax
  800bc3:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc6:	eb b1                	jmp    800b79 <vprintfmt+0x291>
	if (lflag >= 2)
  800bc8:	83 f9 01             	cmp    $0x1,%ecx
  800bcb:	7f 27                	jg     800bf4 <vprintfmt+0x30c>
	else if (lflag)
  800bcd:	85 c9                	test   %ecx,%ecx
  800bcf:	74 41                	je     800c12 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800bd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd4:	8b 00                	mov    (%eax),%eax
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bde:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800be1:	8b 45 14             	mov    0x14(%ebp),%eax
  800be4:	8d 40 04             	lea    0x4(%eax),%eax
  800be7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bea:	bf 0a 00 00 00       	mov    $0xa,%edi
  800bef:	e9 8d 00 00 00       	jmp    800c81 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf7:	8b 50 04             	mov    0x4(%eax),%edx
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c02:	8b 45 14             	mov    0x14(%ebp),%eax
  800c05:	8d 40 08             	lea    0x8(%eax),%eax
  800c08:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c0b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800c10:	eb 6f                	jmp    800c81 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c1f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c22:	8b 45 14             	mov    0x14(%ebp),%eax
  800c25:	8d 40 04             	lea    0x4(%eax),%eax
  800c28:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c2b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800c30:	eb 4f                	jmp    800c81 <vprintfmt+0x399>
	if (lflag >= 2)
  800c32:	83 f9 01             	cmp    $0x1,%ecx
  800c35:	7f 23                	jg     800c5a <vprintfmt+0x372>
	else if (lflag)
  800c37:	85 c9                	test   %ecx,%ecx
  800c39:	0f 84 98 00 00 00    	je     800cd7 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c42:	8b 00                	mov    (%eax),%eax
  800c44:	ba 00 00 00 00       	mov    $0x0,%edx
  800c49:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c4c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	8d 40 04             	lea    0x4(%eax),%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	eb 17                	jmp    800c71 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800c5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5d:	8b 50 04             	mov    0x4(%eax),%edx
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c65:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c68:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6b:	8d 40 08             	lea    0x8(%eax),%eax
  800c6e:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	53                   	push   %ebx
  800c75:	6a 30                	push   $0x30
  800c77:	ff d6                	call   *%esi
			goto number;
  800c79:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800c7c:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800c81:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800c85:	74 0b                	je     800c92 <vprintfmt+0x3aa>
				putch('+', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	53                   	push   %ebx
  800c8b:	6a 2b                	push   $0x2b
  800c8d:	ff d6                	call   *%esi
  800c8f:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800c92:	83 ec 0c             	sub    $0xc,%esp
  800c95:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	ff 75 e0             	pushl  -0x20(%ebp)
  800c9d:	57                   	push   %edi
  800c9e:	ff 75 dc             	pushl  -0x24(%ebp)
  800ca1:	ff 75 d8             	pushl  -0x28(%ebp)
  800ca4:	89 da                	mov    %ebx,%edx
  800ca6:	89 f0                	mov    %esi,%eax
  800ca8:	e8 22 fb ff ff       	call   8007cf <printnum>
			break;
  800cad:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800cb0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb3:	83 c7 01             	add    $0x1,%edi
  800cb6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800cba:	83 f8 25             	cmp    $0x25,%eax
  800cbd:	0f 84 3c fc ff ff    	je     8008ff <vprintfmt+0x17>
			if (ch == '\0')
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	0f 84 55 01 00 00    	je     800e20 <vprintfmt+0x538>
			putch(ch, putdat);
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	53                   	push   %ebx
  800ccf:	50                   	push   %eax
  800cd0:	ff d6                	call   *%esi
  800cd2:	83 c4 10             	add    $0x10,%esp
  800cd5:	eb dc                	jmp    800cb3 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800cd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ce4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	8d 40 04             	lea    0x4(%eax),%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	e9 7c ff ff ff       	jmp    800c71 <vprintfmt+0x389>
			putch('0', putdat);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	53                   	push   %ebx
  800cf9:	6a 30                	push   $0x30
  800cfb:	ff d6                	call   *%esi
			putch('x', putdat);
  800cfd:	83 c4 08             	add    $0x8,%esp
  800d00:	53                   	push   %ebx
  800d01:	6a 78                	push   $0x78
  800d03:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d05:	8b 45 14             	mov    0x14(%ebp),%eax
  800d08:	8b 00                	mov    (%eax),%eax
  800d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d12:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800d15:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d18:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1b:	8d 40 04             	lea    0x4(%eax),%eax
  800d1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d21:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800d26:	e9 56 ff ff ff       	jmp    800c81 <vprintfmt+0x399>
	if (lflag >= 2)
  800d2b:	83 f9 01             	cmp    $0x1,%ecx
  800d2e:	7f 27                	jg     800d57 <vprintfmt+0x46f>
	else if (lflag)
  800d30:	85 c9                	test   %ecx,%ecx
  800d32:	74 44                	je     800d78 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800d34:	8b 45 14             	mov    0x14(%ebp),%eax
  800d37:	8b 00                	mov    (%eax),%eax
  800d39:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d41:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d44:	8b 45 14             	mov    0x14(%ebp),%eax
  800d47:	8d 40 04             	lea    0x4(%eax),%eax
  800d4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d4d:	bf 10 00 00 00       	mov    $0x10,%edi
  800d52:	e9 2a ff ff ff       	jmp    800c81 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800d57:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5a:	8b 50 04             	mov    0x4(%eax),%edx
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d62:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	8d 40 08             	lea    0x8(%eax),%eax
  800d6b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d6e:	bf 10 00 00 00       	mov    $0x10,%edi
  800d73:	e9 09 ff ff ff       	jmp    800c81 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800d78:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d85:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d88:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8b:	8d 40 04             	lea    0x4(%eax),%eax
  800d8e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d91:	bf 10 00 00 00       	mov    $0x10,%edi
  800d96:	e9 e6 fe ff ff       	jmp    800c81 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800d9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9e:	8d 78 04             	lea    0x4(%eax),%edi
  800da1:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800da3:	85 c0                	test   %eax,%eax
  800da5:	74 2d                	je     800dd4 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800da7:	0f b6 13             	movzbl (%ebx),%edx
  800daa:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800dac:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800daf:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800db2:	0f 8e f8 fe ff ff    	jle    800cb0 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800db8:	68 bc 2a 80 00       	push   $0x802abc
  800dbd:	68 b5 2d 80 00       	push   $0x802db5
  800dc2:	53                   	push   %ebx
  800dc3:	56                   	push   %esi
  800dc4:	e8 02 fb ff ff       	call   8008cb <printfmt>
  800dc9:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800dcc:	89 7d 14             	mov    %edi,0x14(%ebp)
  800dcf:	e9 dc fe ff ff       	jmp    800cb0 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800dd4:	68 84 2a 80 00       	push   $0x802a84
  800dd9:	68 b5 2d 80 00       	push   $0x802db5
  800dde:	53                   	push   %ebx
  800ddf:	56                   	push   %esi
  800de0:	e8 e6 fa ff ff       	call   8008cb <printfmt>
  800de5:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800de8:	89 7d 14             	mov    %edi,0x14(%ebp)
  800deb:	e9 c0 fe ff ff       	jmp    800cb0 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	53                   	push   %ebx
  800df4:	6a 25                	push   $0x25
  800df6:	ff d6                	call   *%esi
			break;
  800df8:	83 c4 10             	add    $0x10,%esp
  800dfb:	e9 b0 fe ff ff       	jmp    800cb0 <vprintfmt+0x3c8>
			putch('%', putdat);
  800e00:	83 ec 08             	sub    $0x8,%esp
  800e03:	53                   	push   %ebx
  800e04:	6a 25                	push   $0x25
  800e06:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e08:	83 c4 10             	add    $0x10,%esp
  800e0b:	89 f8                	mov    %edi,%eax
  800e0d:	eb 03                	jmp    800e12 <vprintfmt+0x52a>
  800e0f:	83 e8 01             	sub    $0x1,%eax
  800e12:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e16:	75 f7                	jne    800e0f <vprintfmt+0x527>
  800e18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e1b:	e9 90 fe ff ff       	jmp    800cb0 <vprintfmt+0x3c8>
}
  800e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    

00800e28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 18             	sub    $0x18,%esp
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e37:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e3b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	74 26                	je     800e6f <vsnprintf+0x47>
  800e49:	85 d2                	test   %edx,%edx
  800e4b:	7e 22                	jle    800e6f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e4d:	ff 75 14             	pushl  0x14(%ebp)
  800e50:	ff 75 10             	pushl  0x10(%ebp)
  800e53:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e56:	50                   	push   %eax
  800e57:	68 ae 08 80 00       	push   $0x8008ae
  800e5c:	e8 87 fa ff ff       	call   8008e8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e64:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
}
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    
		return -E_INVAL;
  800e6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e74:	eb f7                	jmp    800e6d <vsnprintf+0x45>

00800e76 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e7c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e7f:	50                   	push   %eax
  800e80:	ff 75 10             	pushl  0x10(%ebp)
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	ff 75 08             	pushl  0x8(%ebp)
  800e89:	e8 9a ff ff ff       	call   800e28 <vsnprintf>
	va_end(ap);

	return rc;
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e96:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e9f:	74 05                	je     800ea6 <strlen+0x16>
		n++;
  800ea1:	83 c0 01             	add    $0x1,%eax
  800ea4:	eb f5                	jmp    800e9b <strlen+0xb>
	return n;
}
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    

00800ea8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb6:	39 c2                	cmp    %eax,%edx
  800eb8:	74 0d                	je     800ec7 <strnlen+0x1f>
  800eba:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ebe:	74 05                	je     800ec5 <strnlen+0x1d>
		n++;
  800ec0:	83 c2 01             	add    $0x1,%edx
  800ec3:	eb f1                	jmp    800eb6 <strnlen+0xe>
  800ec5:	89 d0                	mov    %edx,%eax
	return n;
}
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	53                   	push   %ebx
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800edc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800edf:	83 c2 01             	add    $0x1,%edx
  800ee2:	84 c9                	test   %cl,%cl
  800ee4:	75 f2                	jne    800ed8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ee6:	5b                   	pop    %ebx
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	53                   	push   %ebx
  800eed:	83 ec 10             	sub    $0x10,%esp
  800ef0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ef3:	53                   	push   %ebx
  800ef4:	e8 97 ff ff ff       	call   800e90 <strlen>
  800ef9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	01 d8                	add    %ebx,%eax
  800f01:	50                   	push   %eax
  800f02:	e8 c2 ff ff ff       	call   800ec9 <strcpy>
	return dst;
}
  800f07:	89 d8                	mov    %ebx,%eax
  800f09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	89 c6                	mov    %eax,%esi
  800f1b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f1e:	89 c2                	mov    %eax,%edx
  800f20:	39 f2                	cmp    %esi,%edx
  800f22:	74 11                	je     800f35 <strncpy+0x27>
		*dst++ = *src;
  800f24:	83 c2 01             	add    $0x1,%edx
  800f27:	0f b6 19             	movzbl (%ecx),%ebx
  800f2a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f2d:	80 fb 01             	cmp    $0x1,%bl
  800f30:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800f33:	eb eb                	jmp    800f20 <strncpy+0x12>
	}
	return ret;
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
  800f3e:	8b 75 08             	mov    0x8(%ebp),%esi
  800f41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f44:	8b 55 10             	mov    0x10(%ebp),%edx
  800f47:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f49:	85 d2                	test   %edx,%edx
  800f4b:	74 21                	je     800f6e <strlcpy+0x35>
  800f4d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f51:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800f53:	39 c2                	cmp    %eax,%edx
  800f55:	74 14                	je     800f6b <strlcpy+0x32>
  800f57:	0f b6 19             	movzbl (%ecx),%ebx
  800f5a:	84 db                	test   %bl,%bl
  800f5c:	74 0b                	je     800f69 <strlcpy+0x30>
			*dst++ = *src++;
  800f5e:	83 c1 01             	add    $0x1,%ecx
  800f61:	83 c2 01             	add    $0x1,%edx
  800f64:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f67:	eb ea                	jmp    800f53 <strlcpy+0x1a>
  800f69:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f6e:	29 f0                	sub    %esi,%eax
}
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f7d:	0f b6 01             	movzbl (%ecx),%eax
  800f80:	84 c0                	test   %al,%al
  800f82:	74 0c                	je     800f90 <strcmp+0x1c>
  800f84:	3a 02                	cmp    (%edx),%al
  800f86:	75 08                	jne    800f90 <strcmp+0x1c>
		p++, q++;
  800f88:	83 c1 01             	add    $0x1,%ecx
  800f8b:	83 c2 01             	add    $0x1,%edx
  800f8e:	eb ed                	jmp    800f7d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f90:	0f b6 c0             	movzbl %al,%eax
  800f93:	0f b6 12             	movzbl (%edx),%edx
  800f96:	29 d0                	sub    %edx,%eax
}
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	53                   	push   %ebx
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa4:	89 c3                	mov    %eax,%ebx
  800fa6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800fa9:	eb 06                	jmp    800fb1 <strncmp+0x17>
		n--, p++, q++;
  800fab:	83 c0 01             	add    $0x1,%eax
  800fae:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800fb1:	39 d8                	cmp    %ebx,%eax
  800fb3:	74 16                	je     800fcb <strncmp+0x31>
  800fb5:	0f b6 08             	movzbl (%eax),%ecx
  800fb8:	84 c9                	test   %cl,%cl
  800fba:	74 04                	je     800fc0 <strncmp+0x26>
  800fbc:	3a 0a                	cmp    (%edx),%cl
  800fbe:	74 eb                	je     800fab <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc0:	0f b6 00             	movzbl (%eax),%eax
  800fc3:	0f b6 12             	movzbl (%edx),%edx
  800fc6:	29 d0                	sub    %edx,%eax
}
  800fc8:	5b                   	pop    %ebx
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    
		return 0;
  800fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd0:	eb f6                	jmp    800fc8 <strncmp+0x2e>

00800fd2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800fdc:	0f b6 10             	movzbl (%eax),%edx
  800fdf:	84 d2                	test   %dl,%dl
  800fe1:	74 09                	je     800fec <strchr+0x1a>
		if (*s == c)
  800fe3:	38 ca                	cmp    %cl,%dl
  800fe5:	74 0a                	je     800ff1 <strchr+0x1f>
	for (; *s; s++)
  800fe7:	83 c0 01             	add    $0x1,%eax
  800fea:	eb f0                	jmp    800fdc <strchr+0xa>
			return (char *) s;
	return 0;
  800fec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    

00800ff3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ffd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801000:	38 ca                	cmp    %cl,%dl
  801002:	74 09                	je     80100d <strfind+0x1a>
  801004:	84 d2                	test   %dl,%dl
  801006:	74 05                	je     80100d <strfind+0x1a>
	for (; *s; s++)
  801008:	83 c0 01             	add    $0x1,%eax
  80100b:	eb f0                	jmp    800ffd <strfind+0xa>
			break;
	return (char *) s;
}
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
  801015:	8b 7d 08             	mov    0x8(%ebp),%edi
  801018:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80101b:	85 c9                	test   %ecx,%ecx
  80101d:	74 31                	je     801050 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80101f:	89 f8                	mov    %edi,%eax
  801021:	09 c8                	or     %ecx,%eax
  801023:	a8 03                	test   $0x3,%al
  801025:	75 23                	jne    80104a <memset+0x3b>
		c &= 0xFF;
  801027:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80102b:	89 d3                	mov    %edx,%ebx
  80102d:	c1 e3 08             	shl    $0x8,%ebx
  801030:	89 d0                	mov    %edx,%eax
  801032:	c1 e0 18             	shl    $0x18,%eax
  801035:	89 d6                	mov    %edx,%esi
  801037:	c1 e6 10             	shl    $0x10,%esi
  80103a:	09 f0                	or     %esi,%eax
  80103c:	09 c2                	or     %eax,%edx
  80103e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801040:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801043:	89 d0                	mov    %edx,%eax
  801045:	fc                   	cld    
  801046:	f3 ab                	rep stos %eax,%es:(%edi)
  801048:	eb 06                	jmp    801050 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	fc                   	cld    
  80104e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801050:	89 f8                	mov    %edi,%eax
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5f                   	pop    %edi
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801062:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801065:	39 c6                	cmp    %eax,%esi
  801067:	73 32                	jae    80109b <memmove+0x44>
  801069:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80106c:	39 c2                	cmp    %eax,%edx
  80106e:	76 2b                	jbe    80109b <memmove+0x44>
		s += n;
		d += n;
  801070:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801073:	89 fe                	mov    %edi,%esi
  801075:	09 ce                	or     %ecx,%esi
  801077:	09 d6                	or     %edx,%esi
  801079:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80107f:	75 0e                	jne    80108f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801081:	83 ef 04             	sub    $0x4,%edi
  801084:	8d 72 fc             	lea    -0x4(%edx),%esi
  801087:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80108a:	fd                   	std    
  80108b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80108d:	eb 09                	jmp    801098 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80108f:	83 ef 01             	sub    $0x1,%edi
  801092:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801095:	fd                   	std    
  801096:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801098:	fc                   	cld    
  801099:	eb 1a                	jmp    8010b5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	09 ca                	or     %ecx,%edx
  80109f:	09 f2                	or     %esi,%edx
  8010a1:	f6 c2 03             	test   $0x3,%dl
  8010a4:	75 0a                	jne    8010b0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8010a6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8010a9:	89 c7                	mov    %eax,%edi
  8010ab:	fc                   	cld    
  8010ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010ae:	eb 05                	jmp    8010b5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8010b0:	89 c7                	mov    %eax,%edi
  8010b2:	fc                   	cld    
  8010b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8010b5:	5e                   	pop    %esi
  8010b6:	5f                   	pop    %edi
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    

008010b9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8010bf:	ff 75 10             	pushl  0x10(%ebp)
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	e8 8a ff ff ff       	call   801057 <memmove>
}
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010da:	89 c6                	mov    %eax,%esi
  8010dc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8010df:	39 f0                	cmp    %esi,%eax
  8010e1:	74 1c                	je     8010ff <memcmp+0x30>
		if (*s1 != *s2)
  8010e3:	0f b6 08             	movzbl (%eax),%ecx
  8010e6:	0f b6 1a             	movzbl (%edx),%ebx
  8010e9:	38 d9                	cmp    %bl,%cl
  8010eb:	75 08                	jne    8010f5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8010ed:	83 c0 01             	add    $0x1,%eax
  8010f0:	83 c2 01             	add    $0x1,%edx
  8010f3:	eb ea                	jmp    8010df <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8010f5:	0f b6 c1             	movzbl %cl,%eax
  8010f8:	0f b6 db             	movzbl %bl,%ebx
  8010fb:	29 d8                	sub    %ebx,%eax
  8010fd:	eb 05                	jmp    801104 <memcmp+0x35>
	}

	return 0;
  8010ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    

00801108 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801111:	89 c2                	mov    %eax,%edx
  801113:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801116:	39 d0                	cmp    %edx,%eax
  801118:	73 09                	jae    801123 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80111a:	38 08                	cmp    %cl,(%eax)
  80111c:	74 05                	je     801123 <memfind+0x1b>
	for (; s < ends; s++)
  80111e:	83 c0 01             	add    $0x1,%eax
  801121:	eb f3                	jmp    801116 <memfind+0xe>
			break;
	return (void *) s;
}
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80112e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801131:	eb 03                	jmp    801136 <strtol+0x11>
		s++;
  801133:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801136:	0f b6 01             	movzbl (%ecx),%eax
  801139:	3c 20                	cmp    $0x20,%al
  80113b:	74 f6                	je     801133 <strtol+0xe>
  80113d:	3c 09                	cmp    $0x9,%al
  80113f:	74 f2                	je     801133 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801141:	3c 2b                	cmp    $0x2b,%al
  801143:	74 2a                	je     80116f <strtol+0x4a>
	int neg = 0;
  801145:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80114a:	3c 2d                	cmp    $0x2d,%al
  80114c:	74 2b                	je     801179 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80114e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801154:	75 0f                	jne    801165 <strtol+0x40>
  801156:	80 39 30             	cmpb   $0x30,(%ecx)
  801159:	74 28                	je     801183 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80115b:	85 db                	test   %ebx,%ebx
  80115d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801162:	0f 44 d8             	cmove  %eax,%ebx
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
  80116a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80116d:	eb 50                	jmp    8011bf <strtol+0x9a>
		s++;
  80116f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801172:	bf 00 00 00 00       	mov    $0x0,%edi
  801177:	eb d5                	jmp    80114e <strtol+0x29>
		s++, neg = 1;
  801179:	83 c1 01             	add    $0x1,%ecx
  80117c:	bf 01 00 00 00       	mov    $0x1,%edi
  801181:	eb cb                	jmp    80114e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801183:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801187:	74 0e                	je     801197 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801189:	85 db                	test   %ebx,%ebx
  80118b:	75 d8                	jne    801165 <strtol+0x40>
		s++, base = 8;
  80118d:	83 c1 01             	add    $0x1,%ecx
  801190:	bb 08 00 00 00       	mov    $0x8,%ebx
  801195:	eb ce                	jmp    801165 <strtol+0x40>
		s += 2, base = 16;
  801197:	83 c1 02             	add    $0x2,%ecx
  80119a:	bb 10 00 00 00       	mov    $0x10,%ebx
  80119f:	eb c4                	jmp    801165 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8011a1:	8d 72 9f             	lea    -0x61(%edx),%esi
  8011a4:	89 f3                	mov    %esi,%ebx
  8011a6:	80 fb 19             	cmp    $0x19,%bl
  8011a9:	77 29                	ja     8011d4 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8011ab:	0f be d2             	movsbl %dl,%edx
  8011ae:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8011b1:	3b 55 10             	cmp    0x10(%ebp),%edx
  8011b4:	7d 30                	jge    8011e6 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8011b6:	83 c1 01             	add    $0x1,%ecx
  8011b9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8011bf:	0f b6 11             	movzbl (%ecx),%edx
  8011c2:	8d 72 d0             	lea    -0x30(%edx),%esi
  8011c5:	89 f3                	mov    %esi,%ebx
  8011c7:	80 fb 09             	cmp    $0x9,%bl
  8011ca:	77 d5                	ja     8011a1 <strtol+0x7c>
			dig = *s - '0';
  8011cc:	0f be d2             	movsbl %dl,%edx
  8011cf:	83 ea 30             	sub    $0x30,%edx
  8011d2:	eb dd                	jmp    8011b1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8011d4:	8d 72 bf             	lea    -0x41(%edx),%esi
  8011d7:	89 f3                	mov    %esi,%ebx
  8011d9:	80 fb 19             	cmp    $0x19,%bl
  8011dc:	77 08                	ja     8011e6 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8011de:	0f be d2             	movsbl %dl,%edx
  8011e1:	83 ea 37             	sub    $0x37,%edx
  8011e4:	eb cb                	jmp    8011b1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8011e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ea:	74 05                	je     8011f1 <strtol+0xcc>
		*endptr = (char *) s;
  8011ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ef:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8011f1:	89 c2                	mov    %eax,%edx
  8011f3:	f7 da                	neg    %edx
  8011f5:	85 ff                	test   %edi,%edi
  8011f7:	0f 45 c2             	cmovne %edx,%eax
}
  8011fa:	5b                   	pop    %ebx
  8011fb:	5e                   	pop    %esi
  8011fc:	5f                   	pop    %edi
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    

008011ff <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
	asm volatile("int %1\n"
  801205:	b8 00 00 00 00       	mov    $0x0,%eax
  80120a:	8b 55 08             	mov    0x8(%ebp),%edx
  80120d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801210:	89 c3                	mov    %eax,%ebx
  801212:	89 c7                	mov    %eax,%edi
  801214:	89 c6                	mov    %eax,%esi
  801216:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801218:	5b                   	pop    %ebx
  801219:	5e                   	pop    %esi
  80121a:	5f                   	pop    %edi
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <sys_cgetc>:

int
sys_cgetc(void)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
	asm volatile("int %1\n"
  801223:	ba 00 00 00 00       	mov    $0x0,%edx
  801228:	b8 01 00 00 00       	mov    $0x1,%eax
  80122d:	89 d1                	mov    %edx,%ecx
  80122f:	89 d3                	mov    %edx,%ebx
  801231:	89 d7                	mov    %edx,%edi
  801233:	89 d6                	mov    %edx,%esi
  801235:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5f                   	pop    %edi
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    

0080123c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801245:	b9 00 00 00 00       	mov    $0x0,%ecx
  80124a:	8b 55 08             	mov    0x8(%ebp),%edx
  80124d:	b8 03 00 00 00       	mov    $0x3,%eax
  801252:	89 cb                	mov    %ecx,%ebx
  801254:	89 cf                	mov    %ecx,%edi
  801256:	89 ce                	mov    %ecx,%esi
  801258:	cd 30                	int    $0x30
	if(check && ret > 0)
  80125a:	85 c0                	test   %eax,%eax
  80125c:	7f 08                	jg     801266 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80125e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801261:	5b                   	pop    %ebx
  801262:	5e                   	pop    %esi
  801263:	5f                   	pop    %edi
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	50                   	push   %eax
  80126a:	6a 03                	push   $0x3
  80126c:	68 c0 2c 80 00       	push   $0x802cc0
  801271:	6a 33                	push   $0x33
  801273:	68 dd 2c 80 00       	push   $0x802cdd
  801278:	e8 63 f4 ff ff       	call   8006e0 <_panic>

0080127d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	57                   	push   %edi
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
	asm volatile("int %1\n"
  801283:	ba 00 00 00 00       	mov    $0x0,%edx
  801288:	b8 02 00 00 00       	mov    $0x2,%eax
  80128d:	89 d1                	mov    %edx,%ecx
  80128f:	89 d3                	mov    %edx,%ebx
  801291:	89 d7                	mov    %edx,%edi
  801293:	89 d6                	mov    %edx,%esi
  801295:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5f                   	pop    %edi
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <sys_yield>:

void
sys_yield(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012ac:	89 d1                	mov    %edx,%ecx
  8012ae:	89 d3                	mov    %edx,%ebx
  8012b0:	89 d7                	mov    %edx,%edi
  8012b2:	89 d6                	mov    %edx,%esi
  8012b4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	57                   	push   %edi
  8012bf:	56                   	push   %esi
  8012c0:	53                   	push   %ebx
  8012c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c4:	be 00 00 00 00       	mov    $0x0,%esi
  8012c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cf:	b8 04 00 00 00       	mov    $0x4,%eax
  8012d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012d7:	89 f7                	mov    %esi,%edi
  8012d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	7f 08                	jg     8012e7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e2:	5b                   	pop    %ebx
  8012e3:	5e                   	pop    %esi
  8012e4:	5f                   	pop    %edi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	50                   	push   %eax
  8012eb:	6a 04                	push   $0x4
  8012ed:	68 c0 2c 80 00       	push   $0x802cc0
  8012f2:	6a 33                	push   $0x33
  8012f4:	68 dd 2c 80 00       	push   $0x802cdd
  8012f9:	e8 e2 f3 ff ff       	call   8006e0 <_panic>

008012fe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	57                   	push   %edi
  801302:	56                   	push   %esi
  801303:	53                   	push   %ebx
  801304:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801307:	8b 55 08             	mov    0x8(%ebp),%edx
  80130a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130d:	b8 05 00 00 00       	mov    $0x5,%eax
  801312:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801315:	8b 7d 14             	mov    0x14(%ebp),%edi
  801318:	8b 75 18             	mov    0x18(%ebp),%esi
  80131b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80131d:	85 c0                	test   %eax,%eax
  80131f:	7f 08                	jg     801329 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801321:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801324:	5b                   	pop    %ebx
  801325:	5e                   	pop    %esi
  801326:	5f                   	pop    %edi
  801327:	5d                   	pop    %ebp
  801328:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	50                   	push   %eax
  80132d:	6a 05                	push   $0x5
  80132f:	68 c0 2c 80 00       	push   $0x802cc0
  801334:	6a 33                	push   $0x33
  801336:	68 dd 2c 80 00       	push   $0x802cdd
  80133b:	e8 a0 f3 ff ff       	call   8006e0 <_panic>

00801340 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	57                   	push   %edi
  801344:	56                   	push   %esi
  801345:	53                   	push   %ebx
  801346:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801349:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134e:	8b 55 08             	mov    0x8(%ebp),%edx
  801351:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801354:	b8 06 00 00 00       	mov    $0x6,%eax
  801359:	89 df                	mov    %ebx,%edi
  80135b:	89 de                	mov    %ebx,%esi
  80135d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80135f:	85 c0                	test   %eax,%eax
  801361:	7f 08                	jg     80136b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801363:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801366:	5b                   	pop    %ebx
  801367:	5e                   	pop    %esi
  801368:	5f                   	pop    %edi
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80136b:	83 ec 0c             	sub    $0xc,%esp
  80136e:	50                   	push   %eax
  80136f:	6a 06                	push   $0x6
  801371:	68 c0 2c 80 00       	push   $0x802cc0
  801376:	6a 33                	push   $0x33
  801378:	68 dd 2c 80 00       	push   $0x802cdd
  80137d:	e8 5e f3 ff ff       	call   8006e0 <_panic>

00801382 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	57                   	push   %edi
  801386:	56                   	push   %esi
  801387:	53                   	push   %ebx
  801388:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80138b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801390:	8b 55 08             	mov    0x8(%ebp),%edx
  801393:	b8 0b 00 00 00       	mov    $0xb,%eax
  801398:	89 cb                	mov    %ecx,%ebx
  80139a:	89 cf                	mov    %ecx,%edi
  80139c:	89 ce                	mov    %ecx,%esi
  80139e:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	7f 08                	jg     8013ac <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  8013a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a7:	5b                   	pop    %ebx
  8013a8:	5e                   	pop    %esi
  8013a9:	5f                   	pop    %edi
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ac:	83 ec 0c             	sub    $0xc,%esp
  8013af:	50                   	push   %eax
  8013b0:	6a 0b                	push   $0xb
  8013b2:	68 c0 2c 80 00       	push   $0x802cc0
  8013b7:	6a 33                	push   $0x33
  8013b9:	68 dd 2c 80 00       	push   $0x802cdd
  8013be:	e8 1d f3 ff ff       	call   8006e0 <_panic>

008013c3 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	57                   	push   %edi
  8013c7:	56                   	push   %esi
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8013dc:	89 df                	mov    %ebx,%edi
  8013de:	89 de                	mov    %ebx,%esi
  8013e0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	7f 08                	jg     8013ee <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8013e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5f                   	pop    %edi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ee:	83 ec 0c             	sub    $0xc,%esp
  8013f1:	50                   	push   %eax
  8013f2:	6a 08                	push   $0x8
  8013f4:	68 c0 2c 80 00       	push   $0x802cc0
  8013f9:	6a 33                	push   $0x33
  8013fb:	68 dd 2c 80 00       	push   $0x802cdd
  801400:	e8 db f2 ff ff       	call   8006e0 <_panic>

00801405 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	57                   	push   %edi
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
  80140b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80140e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801413:	8b 55 08             	mov    0x8(%ebp),%edx
  801416:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801419:	b8 09 00 00 00       	mov    $0x9,%eax
  80141e:	89 df                	mov    %ebx,%edi
  801420:	89 de                	mov    %ebx,%esi
  801422:	cd 30                	int    $0x30
	if(check && ret > 0)
  801424:	85 c0                	test   %eax,%eax
  801426:	7f 08                	jg     801430 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142b:	5b                   	pop    %ebx
  80142c:	5e                   	pop    %esi
  80142d:	5f                   	pop    %edi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	50                   	push   %eax
  801434:	6a 09                	push   $0x9
  801436:	68 c0 2c 80 00       	push   $0x802cc0
  80143b:	6a 33                	push   $0x33
  80143d:	68 dd 2c 80 00       	push   $0x802cdd
  801442:	e8 99 f2 ff ff       	call   8006e0 <_panic>

00801447 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	57                   	push   %edi
  80144b:	56                   	push   %esi
  80144c:	53                   	push   %ebx
  80144d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801450:	bb 00 00 00 00       	mov    $0x0,%ebx
  801455:	8b 55 08             	mov    0x8(%ebp),%edx
  801458:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801460:	89 df                	mov    %ebx,%edi
  801462:	89 de                	mov    %ebx,%esi
  801464:	cd 30                	int    $0x30
	if(check && ret > 0)
  801466:	85 c0                	test   %eax,%eax
  801468:	7f 08                	jg     801472 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80146a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146d:	5b                   	pop    %ebx
  80146e:	5e                   	pop    %esi
  80146f:	5f                   	pop    %edi
  801470:	5d                   	pop    %ebp
  801471:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801472:	83 ec 0c             	sub    $0xc,%esp
  801475:	50                   	push   %eax
  801476:	6a 0a                	push   $0xa
  801478:	68 c0 2c 80 00       	push   $0x802cc0
  80147d:	6a 33                	push   $0x33
  80147f:	68 dd 2c 80 00       	push   $0x802cdd
  801484:	e8 57 f2 ff ff       	call   8006e0 <_panic>

00801489 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	57                   	push   %edi
  80148d:	56                   	push   %esi
  80148e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80148f:	8b 55 08             	mov    0x8(%ebp),%edx
  801492:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801495:	b8 0d 00 00 00       	mov    $0xd,%eax
  80149a:	be 00 00 00 00       	mov    $0x0,%esi
  80149f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014a2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014a5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8014a7:	5b                   	pop    %ebx
  8014a8:	5e                   	pop    %esi
  8014a9:	5f                   	pop    %edi
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    

008014ac <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	57                   	push   %edi
  8014b0:	56                   	push   %esi
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bd:	b8 0e 00 00 00       	mov    $0xe,%eax
  8014c2:	89 cb                	mov    %ecx,%ebx
  8014c4:	89 cf                	mov    %ecx,%edi
  8014c6:	89 ce                	mov    %ecx,%esi
  8014c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	7f 08                	jg     8014d6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5f                   	pop    %edi
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014d6:	83 ec 0c             	sub    $0xc,%esp
  8014d9:	50                   	push   %eax
  8014da:	6a 0e                	push   $0xe
  8014dc:	68 c0 2c 80 00       	push   $0x802cc0
  8014e1:	6a 33                	push   $0x33
  8014e3:	68 dd 2c 80 00       	push   $0x802cdd
  8014e8:	e8 f3 f1 ff ff       	call   8006e0 <_panic>

008014ed <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	57                   	push   %edi
  8014f1:	56                   	push   %esi
  8014f2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fe:	b8 0f 00 00 00       	mov    $0xf,%eax
  801503:	89 df                	mov    %ebx,%edi
  801505:	89 de                	mov    %ebx,%esi
  801507:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801509:	5b                   	pop    %ebx
  80150a:	5e                   	pop    %esi
  80150b:	5f                   	pop    %edi
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	57                   	push   %edi
  801512:	56                   	push   %esi
  801513:	53                   	push   %ebx
	asm volatile("int %1\n"
  801514:	b9 00 00 00 00       	mov    $0x0,%ecx
  801519:	8b 55 08             	mov    0x8(%ebp),%edx
  80151c:	b8 10 00 00 00       	mov    $0x10,%eax
  801521:	89 cb                	mov    %ecx,%ebx
  801523:	89 cf                	mov    %ecx,%edi
  801525:	89 ce                	mov    %ecx,%esi
  801527:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801529:	5b                   	pop    %ebx
  80152a:	5e                   	pop    %esi
  80152b:	5f                   	pop    %edi
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    

0080152e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	56                   	push   %esi
  801532:	53                   	push   %ebx
  801533:	8b 75 08             	mov    0x8(%ebp),%esi
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  80153c:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  80153e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801543:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	50                   	push   %eax
  80154a:	e8 5d ff ff ff       	call   8014ac <sys_ipc_recv>
	if (from_env_store)
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	85 f6                	test   %esi,%esi
  801554:	74 14                	je     80156a <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  801556:	ba 00 00 00 00       	mov    $0x0,%edx
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 09                	js     801568 <ipc_recv+0x3a>
  80155f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801565:	8b 52 78             	mov    0x78(%edx),%edx
  801568:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  80156a:	85 db                	test   %ebx,%ebx
  80156c:	74 14                	je     801582 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  80156e:	ba 00 00 00 00       	mov    $0x0,%edx
  801573:	85 c0                	test   %eax,%eax
  801575:	78 09                	js     801580 <ipc_recv+0x52>
  801577:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80157d:	8b 52 7c             	mov    0x7c(%edx),%edx
  801580:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  801582:	85 c0                	test   %eax,%eax
  801584:	78 08                	js     80158e <ipc_recv+0x60>
  801586:	a1 04 40 80 00       	mov    0x804004,%eax
  80158b:	8b 40 74             	mov    0x74(%eax),%eax
}
  80158e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801591:	5b                   	pop    %ebx
  801592:	5e                   	pop    %esi
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    

00801595 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 08             	sub    $0x8,%esp
  80159b:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015a5:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  8015a8:	ff 75 14             	pushl  0x14(%ebp)
  8015ab:	50                   	push   %eax
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	e8 d2 fe ff ff       	call   801489 <sys_ipc_try_send>
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 02                	js     8015c0 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  8015c0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015c3:	75 07                	jne    8015cc <ipc_send+0x37>
		sys_yield();
  8015c5:	e8 d2 fc ff ff       	call   80129c <sys_yield>
}
  8015ca:	eb f2                	jmp    8015be <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  8015cc:	50                   	push   %eax
  8015cd:	68 eb 2c 80 00       	push   $0x802ceb
  8015d2:	6a 3c                	push   $0x3c
  8015d4:	68 ff 2c 80 00       	push   $0x802cff
  8015d9:	e8 02 f1 ff ff       	call   8006e0 <_panic>

008015de <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015e4:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  8015e9:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  8015ec:	c1 e0 04             	shl    $0x4,%eax
  8015ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015f4:	8b 40 50             	mov    0x50(%eax),%eax
  8015f7:	39 c8                	cmp    %ecx,%eax
  8015f9:	74 12                	je     80160d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8015fb:	83 c2 01             	add    $0x1,%edx
  8015fe:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  801604:	75 e3                	jne    8015e9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	eb 0e                	jmp    80161b <ipc_find_env+0x3d>
			return envs[i].env_id;
  80160d:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801610:	c1 e0 04             	shl    $0x4,%eax
  801613:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801618:	8b 40 48             	mov    0x48(%eax),%eax
}
  80161b:	5d                   	pop    %ebp
  80161c:	c3                   	ret    

0080161d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	05 00 00 00 30       	add    $0x30000000,%eax
  801628:	c1 e8 0c             	shr    $0xc,%eax
}
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801638:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80163d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801642:	5d                   	pop    %ebp
  801643:	c3                   	ret    

00801644 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80164c:	89 c2                	mov    %eax,%edx
  80164e:	c1 ea 16             	shr    $0x16,%edx
  801651:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801658:	f6 c2 01             	test   $0x1,%dl
  80165b:	74 2d                	je     80168a <fd_alloc+0x46>
  80165d:	89 c2                	mov    %eax,%edx
  80165f:	c1 ea 0c             	shr    $0xc,%edx
  801662:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801669:	f6 c2 01             	test   $0x1,%dl
  80166c:	74 1c                	je     80168a <fd_alloc+0x46>
  80166e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801673:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801678:	75 d2                	jne    80164c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801683:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801688:	eb 0a                	jmp    801694 <fd_alloc+0x50>
			*fd_store = fd;
  80168a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    

00801696 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80169c:	83 f8 1f             	cmp    $0x1f,%eax
  80169f:	77 30                	ja     8016d1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016a1:	c1 e0 0c             	shl    $0xc,%eax
  8016a4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016a9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016af:	f6 c2 01             	test   $0x1,%dl
  8016b2:	74 24                	je     8016d8 <fd_lookup+0x42>
  8016b4:	89 c2                	mov    %eax,%edx
  8016b6:	c1 ea 0c             	shr    $0xc,%edx
  8016b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016c0:	f6 c2 01             	test   $0x1,%dl
  8016c3:	74 1a                	je     8016df <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c8:	89 02                	mov    %eax,(%edx)
	return 0;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    
		return -E_INVAL;
  8016d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d6:	eb f7                	jmp    8016cf <fd_lookup+0x39>
		return -E_INVAL;
  8016d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016dd:	eb f0                	jmp    8016cf <fd_lookup+0x39>
  8016df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e4:	eb e9                	jmp    8016cf <fd_lookup+0x39>

008016e6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ef:	ba 8c 2d 80 00       	mov    $0x802d8c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8016f4:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016f9:	39 08                	cmp    %ecx,(%eax)
  8016fb:	74 33                	je     801730 <dev_lookup+0x4a>
  8016fd:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801700:	8b 02                	mov    (%edx),%eax
  801702:	85 c0                	test   %eax,%eax
  801704:	75 f3                	jne    8016f9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801706:	a1 04 40 80 00       	mov    0x804004,%eax
  80170b:	8b 40 48             	mov    0x48(%eax),%eax
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	51                   	push   %ecx
  801712:	50                   	push   %eax
  801713:	68 0c 2d 80 00       	push   $0x802d0c
  801718:	e8 9e f0 ff ff       	call   8007bb <cprintf>
	*dev = 0;
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    
			*dev = devtab[i];
  801730:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801733:	89 01                	mov    %eax,(%ecx)
			return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
  80173a:	eb f2                	jmp    80172e <dev_lookup+0x48>

0080173c <fd_close>:
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	57                   	push   %edi
  801740:	56                   	push   %esi
  801741:	53                   	push   %ebx
  801742:	83 ec 24             	sub    $0x24,%esp
  801745:	8b 75 08             	mov    0x8(%ebp),%esi
  801748:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80174b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80174e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80174f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801755:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801758:	50                   	push   %eax
  801759:	e8 38 ff ff ff       	call   801696 <fd_lookup>
  80175e:	89 c3                	mov    %eax,%ebx
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	85 c0                	test   %eax,%eax
  801765:	78 05                	js     80176c <fd_close+0x30>
	    || fd != fd2)
  801767:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80176a:	74 16                	je     801782 <fd_close+0x46>
		return (must_exist ? r : 0);
  80176c:	89 f8                	mov    %edi,%eax
  80176e:	84 c0                	test   %al,%al
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
  801775:	0f 44 d8             	cmove  %eax,%ebx
}
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5f                   	pop    %edi
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801782:	83 ec 08             	sub    $0x8,%esp
  801785:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801788:	50                   	push   %eax
  801789:	ff 36                	pushl  (%esi)
  80178b:	e8 56 ff ff ff       	call   8016e6 <dev_lookup>
  801790:	89 c3                	mov    %eax,%ebx
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	85 c0                	test   %eax,%eax
  801797:	78 1a                	js     8017b3 <fd_close+0x77>
		if (dev->dev_close)
  801799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80179f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	74 0b                	je     8017b3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	56                   	push   %esi
  8017ac:	ff d0                	call   *%eax
  8017ae:	89 c3                	mov    %eax,%ebx
  8017b0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017b3:	83 ec 08             	sub    $0x8,%esp
  8017b6:	56                   	push   %esi
  8017b7:	6a 00                	push   $0x0
  8017b9:	e8 82 fb ff ff       	call   801340 <sys_page_unmap>
	return r;
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	eb b5                	jmp    801778 <fd_close+0x3c>

008017c3 <close>:

int
close(int fdnum)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cc:	50                   	push   %eax
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 c1 fe ff ff       	call   801696 <fd_lookup>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	79 02                	jns    8017de <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    
		return fd_close(fd, 1);
  8017de:	83 ec 08             	sub    $0x8,%esp
  8017e1:	6a 01                	push   $0x1
  8017e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e6:	e8 51 ff ff ff       	call   80173c <fd_close>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	eb ec                	jmp    8017dc <close+0x19>

008017f0 <close_all>:

void
close_all(void)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	53                   	push   %ebx
  801800:	e8 be ff ff ff       	call   8017c3 <close>
	for (i = 0; i < MAXFD; i++)
  801805:	83 c3 01             	add    $0x1,%ebx
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	83 fb 20             	cmp    $0x20,%ebx
  80180e:	75 ec                	jne    8017fc <close_all+0xc>
}
  801810:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	57                   	push   %edi
  801819:	56                   	push   %esi
  80181a:	53                   	push   %ebx
  80181b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80181e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801821:	50                   	push   %eax
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	e8 6c fe ff ff       	call   801696 <fd_lookup>
  80182a:	89 c3                	mov    %eax,%ebx
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	0f 88 81 00 00 00    	js     8018b8 <dup+0xa3>
		return r;
	close(newfdnum);
  801837:	83 ec 0c             	sub    $0xc,%esp
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	e8 81 ff ff ff       	call   8017c3 <close>

	newfd = INDEX2FD(newfdnum);
  801842:	8b 75 0c             	mov    0xc(%ebp),%esi
  801845:	c1 e6 0c             	shl    $0xc,%esi
  801848:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80184e:	83 c4 04             	add    $0x4,%esp
  801851:	ff 75 e4             	pushl  -0x1c(%ebp)
  801854:	e8 d4 fd ff ff       	call   80162d <fd2data>
  801859:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80185b:	89 34 24             	mov    %esi,(%esp)
  80185e:	e8 ca fd ff ff       	call   80162d <fd2data>
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801868:	89 d8                	mov    %ebx,%eax
  80186a:	c1 e8 16             	shr    $0x16,%eax
  80186d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801874:	a8 01                	test   $0x1,%al
  801876:	74 11                	je     801889 <dup+0x74>
  801878:	89 d8                	mov    %ebx,%eax
  80187a:	c1 e8 0c             	shr    $0xc,%eax
  80187d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801884:	f6 c2 01             	test   $0x1,%dl
  801887:	75 39                	jne    8018c2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801889:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80188c:	89 d0                	mov    %edx,%eax
  80188e:	c1 e8 0c             	shr    $0xc,%eax
  801891:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801898:	83 ec 0c             	sub    $0xc,%esp
  80189b:	25 07 0e 00 00       	and    $0xe07,%eax
  8018a0:	50                   	push   %eax
  8018a1:	56                   	push   %esi
  8018a2:	6a 00                	push   $0x0
  8018a4:	52                   	push   %edx
  8018a5:	6a 00                	push   $0x0
  8018a7:	e8 52 fa ff ff       	call   8012fe <sys_page_map>
  8018ac:	89 c3                	mov    %eax,%ebx
  8018ae:	83 c4 20             	add    $0x20,%esp
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	78 31                	js     8018e6 <dup+0xd1>
		goto err;

	return newfdnum;
  8018b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018b8:	89 d8                	mov    %ebx,%eax
  8018ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bd:	5b                   	pop    %ebx
  8018be:	5e                   	pop    %esi
  8018bf:	5f                   	pop    %edi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8018d1:	50                   	push   %eax
  8018d2:	57                   	push   %edi
  8018d3:	6a 00                	push   $0x0
  8018d5:	53                   	push   %ebx
  8018d6:	6a 00                	push   $0x0
  8018d8:	e8 21 fa ff ff       	call   8012fe <sys_page_map>
  8018dd:	89 c3                	mov    %eax,%ebx
  8018df:	83 c4 20             	add    $0x20,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	79 a3                	jns    801889 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018e6:	83 ec 08             	sub    $0x8,%esp
  8018e9:	56                   	push   %esi
  8018ea:	6a 00                	push   $0x0
  8018ec:	e8 4f fa ff ff       	call   801340 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018f1:	83 c4 08             	add    $0x8,%esp
  8018f4:	57                   	push   %edi
  8018f5:	6a 00                	push   $0x0
  8018f7:	e8 44 fa ff ff       	call   801340 <sys_page_unmap>
	return r;
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	eb b7                	jmp    8018b8 <dup+0xa3>

00801901 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	53                   	push   %ebx
  801905:	83 ec 1c             	sub    $0x1c,%esp
  801908:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80190e:	50                   	push   %eax
  80190f:	53                   	push   %ebx
  801910:	e8 81 fd ff ff       	call   801696 <fd_lookup>
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 3f                	js     80195b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191c:	83 ec 08             	sub    $0x8,%esp
  80191f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801922:	50                   	push   %eax
  801923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801926:	ff 30                	pushl  (%eax)
  801928:	e8 b9 fd ff ff       	call   8016e6 <dev_lookup>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 27                	js     80195b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801934:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801937:	8b 42 08             	mov    0x8(%edx),%eax
  80193a:	83 e0 03             	and    $0x3,%eax
  80193d:	83 f8 01             	cmp    $0x1,%eax
  801940:	74 1e                	je     801960 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	8b 40 08             	mov    0x8(%eax),%eax
  801948:	85 c0                	test   %eax,%eax
  80194a:	74 35                	je     801981 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80194c:	83 ec 04             	sub    $0x4,%esp
  80194f:	ff 75 10             	pushl  0x10(%ebp)
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	52                   	push   %edx
  801956:	ff d0                	call   *%eax
  801958:	83 c4 10             	add    $0x10,%esp
}
  80195b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801960:	a1 04 40 80 00       	mov    0x804004,%eax
  801965:	8b 40 48             	mov    0x48(%eax),%eax
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	53                   	push   %ebx
  80196c:	50                   	push   %eax
  80196d:	68 50 2d 80 00       	push   $0x802d50
  801972:	e8 44 ee ff ff       	call   8007bb <cprintf>
		return -E_INVAL;
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80197f:	eb da                	jmp    80195b <read+0x5a>
		return -E_NOT_SUPP;
  801981:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801986:	eb d3                	jmp    80195b <read+0x5a>

00801988 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	57                   	push   %edi
  80198c:	56                   	push   %esi
  80198d:	53                   	push   %ebx
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	8b 7d 08             	mov    0x8(%ebp),%edi
  801994:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801997:	bb 00 00 00 00       	mov    $0x0,%ebx
  80199c:	39 f3                	cmp    %esi,%ebx
  80199e:	73 23                	jae    8019c3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	89 f0                	mov    %esi,%eax
  8019a5:	29 d8                	sub    %ebx,%eax
  8019a7:	50                   	push   %eax
  8019a8:	89 d8                	mov    %ebx,%eax
  8019aa:	03 45 0c             	add    0xc(%ebp),%eax
  8019ad:	50                   	push   %eax
  8019ae:	57                   	push   %edi
  8019af:	e8 4d ff ff ff       	call   801901 <read>
		if (m < 0)
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 06                	js     8019c1 <readn+0x39>
			return m;
		if (m == 0)
  8019bb:	74 06                	je     8019c3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019bd:	01 c3                	add    %eax,%ebx
  8019bf:	eb db                	jmp    80199c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019c1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019c3:	89 d8                	mov    %ebx,%eax
  8019c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c8:	5b                   	pop    %ebx
  8019c9:	5e                   	pop    %esi
  8019ca:	5f                   	pop    %edi
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    

008019cd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	53                   	push   %ebx
  8019d1:	83 ec 1c             	sub    $0x1c,%esp
  8019d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019da:	50                   	push   %eax
  8019db:	53                   	push   %ebx
  8019dc:	e8 b5 fc ff ff       	call   801696 <fd_lookup>
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 3a                	js     801a22 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e8:	83 ec 08             	sub    $0x8,%esp
  8019eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ee:	50                   	push   %eax
  8019ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f2:	ff 30                	pushl  (%eax)
  8019f4:	e8 ed fc ff ff       	call   8016e6 <dev_lookup>
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 22                	js     801a22 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a03:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a07:	74 1e                	je     801a27 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0c:	8b 52 0c             	mov    0xc(%edx),%edx
  801a0f:	85 d2                	test   %edx,%edx
  801a11:	74 35                	je     801a48 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a13:	83 ec 04             	sub    $0x4,%esp
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	50                   	push   %eax
  801a1d:	ff d2                	call   *%edx
  801a1f:	83 c4 10             	add    $0x10,%esp
}
  801a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a27:	a1 04 40 80 00       	mov    0x804004,%eax
  801a2c:	8b 40 48             	mov    0x48(%eax),%eax
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	53                   	push   %ebx
  801a33:	50                   	push   %eax
  801a34:	68 6c 2d 80 00       	push   $0x802d6c
  801a39:	e8 7d ed ff ff       	call   8007bb <cprintf>
		return -E_INVAL;
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a46:	eb da                	jmp    801a22 <write+0x55>
		return -E_NOT_SUPP;
  801a48:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a4d:	eb d3                	jmp    801a22 <write+0x55>

00801a4f <seek>:

int
seek(int fdnum, off_t offset)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a58:	50                   	push   %eax
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	e8 35 fc ff ff       	call   801696 <fd_lookup>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 0e                	js     801a76 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	53                   	push   %ebx
  801a7c:	83 ec 1c             	sub    $0x1c,%esp
  801a7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a82:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	53                   	push   %ebx
  801a87:	e8 0a fc ff ff       	call   801696 <fd_lookup>
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	78 37                	js     801aca <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a93:	83 ec 08             	sub    $0x8,%esp
  801a96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a99:	50                   	push   %eax
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	ff 30                	pushl  (%eax)
  801a9f:	e8 42 fc ff ff       	call   8016e6 <dev_lookup>
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 1f                	js     801aca <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aae:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ab2:	74 1b                	je     801acf <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab7:	8b 52 18             	mov    0x18(%edx),%edx
  801aba:	85 d2                	test   %edx,%edx
  801abc:	74 32                	je     801af0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	50                   	push   %eax
  801ac5:	ff d2                	call   *%edx
  801ac7:	83 c4 10             	add    $0x10,%esp
}
  801aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    
			thisenv->env_id, fdnum);
  801acf:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ad4:	8b 40 48             	mov    0x48(%eax),%eax
  801ad7:	83 ec 04             	sub    $0x4,%esp
  801ada:	53                   	push   %ebx
  801adb:	50                   	push   %eax
  801adc:	68 2c 2d 80 00       	push   $0x802d2c
  801ae1:	e8 d5 ec ff ff       	call   8007bb <cprintf>
		return -E_INVAL;
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aee:	eb da                	jmp    801aca <ftruncate+0x52>
		return -E_NOT_SUPP;
  801af0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af5:	eb d3                	jmp    801aca <ftruncate+0x52>

00801af7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	53                   	push   %ebx
  801afb:	83 ec 1c             	sub    $0x1c,%esp
  801afe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b04:	50                   	push   %eax
  801b05:	ff 75 08             	pushl  0x8(%ebp)
  801b08:	e8 89 fb ff ff       	call   801696 <fd_lookup>
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 4b                	js     801b5f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b14:	83 ec 08             	sub    $0x8,%esp
  801b17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1a:	50                   	push   %eax
  801b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1e:	ff 30                	pushl  (%eax)
  801b20:	e8 c1 fb ff ff       	call   8016e6 <dev_lookup>
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 33                	js     801b5f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b33:	74 2f                	je     801b64 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b35:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b38:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b3f:	00 00 00 
	stat->st_isdir = 0;
  801b42:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b49:	00 00 00 
	stat->st_dev = dev;
  801b4c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b52:	83 ec 08             	sub    $0x8,%esp
  801b55:	53                   	push   %ebx
  801b56:	ff 75 f0             	pushl  -0x10(%ebp)
  801b59:	ff 50 14             	call   *0x14(%eax)
  801b5c:	83 c4 10             	add    $0x10,%esp
}
  801b5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    
		return -E_NOT_SUPP;
  801b64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b69:	eb f4                	jmp    801b5f <fstat+0x68>

00801b6b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b70:	83 ec 08             	sub    $0x8,%esp
  801b73:	6a 00                	push   $0x0
  801b75:	ff 75 08             	pushl  0x8(%ebp)
  801b78:	e8 e7 01 00 00       	call   801d64 <open>
  801b7d:	89 c3                	mov    %eax,%ebx
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 1b                	js     801ba1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	ff 75 0c             	pushl  0xc(%ebp)
  801b8c:	50                   	push   %eax
  801b8d:	e8 65 ff ff ff       	call   801af7 <fstat>
  801b92:	89 c6                	mov    %eax,%esi
	close(fd);
  801b94:	89 1c 24             	mov    %ebx,(%esp)
  801b97:	e8 27 fc ff ff       	call   8017c3 <close>
	return r;
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	89 f3                	mov    %esi,%ebx
}
  801ba1:	89 d8                	mov    %ebx,%eax
  801ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5e                   	pop    %esi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    

00801baa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	56                   	push   %esi
  801bae:	53                   	push   %ebx
  801baf:	89 c6                	mov    %eax,%esi
  801bb1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bb3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801bba:	74 27                	je     801be3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bbc:	6a 07                	push   $0x7
  801bbe:	68 00 50 80 00       	push   $0x805000
  801bc3:	56                   	push   %esi
  801bc4:	ff 35 00 40 80 00    	pushl  0x804000
  801bca:	e8 c6 f9 ff ff       	call   801595 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bcf:	83 c4 0c             	add    $0xc,%esp
  801bd2:	6a 00                	push   $0x0
  801bd4:	53                   	push   %ebx
  801bd5:	6a 00                	push   $0x0
  801bd7:	e8 52 f9 ff ff       	call   80152e <ipc_recv>
}
  801bdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	6a 01                	push   $0x1
  801be8:	e8 f1 f9 ff ff       	call   8015de <ipc_find_env>
  801bed:	a3 00 40 80 00       	mov    %eax,0x804000
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	eb c5                	jmp    801bbc <fsipc+0x12>

00801bf7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	8b 40 0c             	mov    0xc(%eax),%eax
  801c03:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c10:	ba 00 00 00 00       	mov    $0x0,%edx
  801c15:	b8 02 00 00 00       	mov    $0x2,%eax
  801c1a:	e8 8b ff ff ff       	call   801baa <fsipc>
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <devfile_flush>:
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c32:	ba 00 00 00 00       	mov    $0x0,%edx
  801c37:	b8 06 00 00 00       	mov    $0x6,%eax
  801c3c:	e8 69 ff ff ff       	call   801baa <fsipc>
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <devfile_stat>:
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	53                   	push   %ebx
  801c47:	83 ec 04             	sub    $0x4,%esp
  801c4a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	8b 40 0c             	mov    0xc(%eax),%eax
  801c53:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c58:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5d:	b8 05 00 00 00       	mov    $0x5,%eax
  801c62:	e8 43 ff ff ff       	call   801baa <fsipc>
  801c67:	85 c0                	test   %eax,%eax
  801c69:	78 2c                	js     801c97 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	68 00 50 80 00       	push   $0x805000
  801c73:	53                   	push   %ebx
  801c74:	e8 50 f2 ff ff       	call   800ec9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c79:	a1 80 50 80 00       	mov    0x805080,%eax
  801c7e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c84:	a1 84 50 80 00       	mov    0x805084,%eax
  801c89:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <devfile_write>:
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 0c             	sub    $0xc,%esp
  801ca2:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca8:	8b 52 0c             	mov    0xc(%edx),%edx
  801cab:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801cb1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801cb6:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801cbb:	0f 47 c2             	cmova  %edx,%eax
  801cbe:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801cc3:	50                   	push   %eax
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	68 08 50 80 00       	push   $0x805008
  801ccc:	e8 86 f3 ff ff       	call   801057 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd6:	b8 04 00 00 00       	mov    $0x4,%eax
  801cdb:	e8 ca fe ff ff       	call   801baa <fsipc>
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <devfile_read>:
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	56                   	push   %esi
  801ce6:	53                   	push   %ebx
  801ce7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801cf5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801d00:	b8 03 00 00 00       	mov    $0x3,%eax
  801d05:	e8 a0 fe ff ff       	call   801baa <fsipc>
  801d0a:	89 c3                	mov    %eax,%ebx
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	78 1f                	js     801d2f <devfile_read+0x4d>
	assert(r <= n);
  801d10:	39 f0                	cmp    %esi,%eax
  801d12:	77 24                	ja     801d38 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d14:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d19:	7f 33                	jg     801d4e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	50                   	push   %eax
  801d1f:	68 00 50 80 00       	push   $0x805000
  801d24:	ff 75 0c             	pushl  0xc(%ebp)
  801d27:	e8 2b f3 ff ff       	call   801057 <memmove>
	return r;
  801d2c:	83 c4 10             	add    $0x10,%esp
}
  801d2f:	89 d8                	mov    %ebx,%eax
  801d31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
	assert(r <= n);
  801d38:	68 9c 2d 80 00       	push   $0x802d9c
  801d3d:	68 a3 2d 80 00       	push   $0x802da3
  801d42:	6a 7c                	push   $0x7c
  801d44:	68 b8 2d 80 00       	push   $0x802db8
  801d49:	e8 92 e9 ff ff       	call   8006e0 <_panic>
	assert(r <= PGSIZE);
  801d4e:	68 c3 2d 80 00       	push   $0x802dc3
  801d53:	68 a3 2d 80 00       	push   $0x802da3
  801d58:	6a 7d                	push   $0x7d
  801d5a:	68 b8 2d 80 00       	push   $0x802db8
  801d5f:	e8 7c e9 ff ff       	call   8006e0 <_panic>

00801d64 <open>:
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	56                   	push   %esi
  801d68:	53                   	push   %ebx
  801d69:	83 ec 1c             	sub    $0x1c,%esp
  801d6c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d6f:	56                   	push   %esi
  801d70:	e8 1b f1 ff ff       	call   800e90 <strlen>
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d7d:	7f 6c                	jg     801deb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d7f:	83 ec 0c             	sub    $0xc,%esp
  801d82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d85:	50                   	push   %eax
  801d86:	e8 b9 f8 ff ff       	call   801644 <fd_alloc>
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	85 c0                	test   %eax,%eax
  801d92:	78 3c                	js     801dd0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	56                   	push   %esi
  801d98:	68 00 50 80 00       	push   $0x805000
  801d9d:	e8 27 f1 ff ff       	call   800ec9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dad:	b8 01 00 00 00       	mov    $0x1,%eax
  801db2:	e8 f3 fd ff ff       	call   801baa <fsipc>
  801db7:	89 c3                	mov    %eax,%ebx
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 19                	js     801dd9 <open+0x75>
	return fd2num(fd);
  801dc0:	83 ec 0c             	sub    $0xc,%esp
  801dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc6:	e8 52 f8 ff ff       	call   80161d <fd2num>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
}
  801dd0:	89 d8                	mov    %ebx,%eax
  801dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    
		fd_close(fd, 0);
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	6a 00                	push   $0x0
  801dde:	ff 75 f4             	pushl  -0xc(%ebp)
  801de1:	e8 56 f9 ff ff       	call   80173c <fd_close>
		return r;
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	eb e5                	jmp    801dd0 <open+0x6c>
		return -E_BAD_PATH;
  801deb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801df0:	eb de                	jmp    801dd0 <open+0x6c>

00801df2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801df8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfd:	b8 08 00 00 00       	mov    $0x8,%eax
  801e02:	e8 a3 fd ff ff       	call   801baa <fsipc>
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	56                   	push   %esi
  801e0d:	53                   	push   %ebx
  801e0e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	e8 11 f8 ff ff       	call   80162d <fd2data>
  801e1c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e1e:	83 c4 08             	add    $0x8,%esp
  801e21:	68 cf 2d 80 00       	push   $0x802dcf
  801e26:	53                   	push   %ebx
  801e27:	e8 9d f0 ff ff       	call   800ec9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e2c:	8b 46 04             	mov    0x4(%esi),%eax
  801e2f:	2b 06                	sub    (%esi),%eax
  801e31:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e37:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e3e:	00 00 00 
	stat->st_dev = &devpipe;
  801e41:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801e48:	30 80 00 
	return 0;
}
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5d                   	pop    %ebp
  801e56:	c3                   	ret    

00801e57 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	53                   	push   %ebx
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e61:	53                   	push   %ebx
  801e62:	6a 00                	push   $0x0
  801e64:	e8 d7 f4 ff ff       	call   801340 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e69:	89 1c 24             	mov    %ebx,(%esp)
  801e6c:	e8 bc f7 ff ff       	call   80162d <fd2data>
  801e71:	83 c4 08             	add    $0x8,%esp
  801e74:	50                   	push   %eax
  801e75:	6a 00                	push   $0x0
  801e77:	e8 c4 f4 ff ff       	call   801340 <sys_page_unmap>
}
  801e7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <_pipeisclosed>:
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	57                   	push   %edi
  801e85:	56                   	push   %esi
  801e86:	53                   	push   %ebx
  801e87:	83 ec 1c             	sub    $0x1c,%esp
  801e8a:	89 c7                	mov    %eax,%edi
  801e8c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e8e:	a1 04 40 80 00       	mov    0x804004,%eax
  801e93:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	57                   	push   %edi
  801e9a:	e8 2d 04 00 00       	call   8022cc <pageref>
  801e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ea2:	89 34 24             	mov    %esi,(%esp)
  801ea5:	e8 22 04 00 00       	call   8022cc <pageref>
		nn = thisenv->env_runs;
  801eaa:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801eb0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	39 cb                	cmp    %ecx,%ebx
  801eb8:	74 1b                	je     801ed5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801eba:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ebd:	75 cf                	jne    801e8e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ebf:	8b 42 58             	mov    0x58(%edx),%eax
  801ec2:	6a 01                	push   $0x1
  801ec4:	50                   	push   %eax
  801ec5:	53                   	push   %ebx
  801ec6:	68 d6 2d 80 00       	push   $0x802dd6
  801ecb:	e8 eb e8 ff ff       	call   8007bb <cprintf>
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	eb b9                	jmp    801e8e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ed5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ed8:	0f 94 c0             	sete   %al
  801edb:	0f b6 c0             	movzbl %al,%eax
}
  801ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5f                   	pop    %edi
  801ee4:	5d                   	pop    %ebp
  801ee5:	c3                   	ret    

00801ee6 <devpipe_write>:
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	57                   	push   %edi
  801eea:	56                   	push   %esi
  801eeb:	53                   	push   %ebx
  801eec:	83 ec 28             	sub    $0x28,%esp
  801eef:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ef2:	56                   	push   %esi
  801ef3:	e8 35 f7 ff ff       	call   80162d <fd2data>
  801ef8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	bf 00 00 00 00       	mov    $0x0,%edi
  801f02:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f05:	74 4f                	je     801f56 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f07:	8b 43 04             	mov    0x4(%ebx),%eax
  801f0a:	8b 0b                	mov    (%ebx),%ecx
  801f0c:	8d 51 20             	lea    0x20(%ecx),%edx
  801f0f:	39 d0                	cmp    %edx,%eax
  801f11:	72 14                	jb     801f27 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f13:	89 da                	mov    %ebx,%edx
  801f15:	89 f0                	mov    %esi,%eax
  801f17:	e8 65 ff ff ff       	call   801e81 <_pipeisclosed>
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	75 3b                	jne    801f5b <devpipe_write+0x75>
			sys_yield();
  801f20:	e8 77 f3 ff ff       	call   80129c <sys_yield>
  801f25:	eb e0                	jmp    801f07 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f2a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f2e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f31:	89 c2                	mov    %eax,%edx
  801f33:	c1 fa 1f             	sar    $0x1f,%edx
  801f36:	89 d1                	mov    %edx,%ecx
  801f38:	c1 e9 1b             	shr    $0x1b,%ecx
  801f3b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f3e:	83 e2 1f             	and    $0x1f,%edx
  801f41:	29 ca                	sub    %ecx,%edx
  801f43:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f47:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f4b:	83 c0 01             	add    $0x1,%eax
  801f4e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f51:	83 c7 01             	add    $0x1,%edi
  801f54:	eb ac                	jmp    801f02 <devpipe_write+0x1c>
	return i;
  801f56:	8b 45 10             	mov    0x10(%ebp),%eax
  801f59:	eb 05                	jmp    801f60 <devpipe_write+0x7a>
				return 0;
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f63:	5b                   	pop    %ebx
  801f64:	5e                   	pop    %esi
  801f65:	5f                   	pop    %edi
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    

00801f68 <devpipe_read>:
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	57                   	push   %edi
  801f6c:	56                   	push   %esi
  801f6d:	53                   	push   %ebx
  801f6e:	83 ec 18             	sub    $0x18,%esp
  801f71:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f74:	57                   	push   %edi
  801f75:	e8 b3 f6 ff ff       	call   80162d <fd2data>
  801f7a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f7c:	83 c4 10             	add    $0x10,%esp
  801f7f:	be 00 00 00 00       	mov    $0x0,%esi
  801f84:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f87:	75 14                	jne    801f9d <devpipe_read+0x35>
	return i;
  801f89:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8c:	eb 02                	jmp    801f90 <devpipe_read+0x28>
				return i;
  801f8e:	89 f0                	mov    %esi,%eax
}
  801f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f93:	5b                   	pop    %ebx
  801f94:	5e                   	pop    %esi
  801f95:	5f                   	pop    %edi
  801f96:	5d                   	pop    %ebp
  801f97:	c3                   	ret    
			sys_yield();
  801f98:	e8 ff f2 ff ff       	call   80129c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f9d:	8b 03                	mov    (%ebx),%eax
  801f9f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fa2:	75 18                	jne    801fbc <devpipe_read+0x54>
			if (i > 0)
  801fa4:	85 f6                	test   %esi,%esi
  801fa6:	75 e6                	jne    801f8e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801fa8:	89 da                	mov    %ebx,%edx
  801faa:	89 f8                	mov    %edi,%eax
  801fac:	e8 d0 fe ff ff       	call   801e81 <_pipeisclosed>
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 e3                	je     801f98 <devpipe_read+0x30>
				return 0;
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	eb d4                	jmp    801f90 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fbc:	99                   	cltd   
  801fbd:	c1 ea 1b             	shr    $0x1b,%edx
  801fc0:	01 d0                	add    %edx,%eax
  801fc2:	83 e0 1f             	and    $0x1f,%eax
  801fc5:	29 d0                	sub    %edx,%eax
  801fc7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fcf:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fd2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fd5:	83 c6 01             	add    $0x1,%esi
  801fd8:	eb aa                	jmp    801f84 <devpipe_read+0x1c>

00801fda <pipe>:
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	56                   	push   %esi
  801fde:	53                   	push   %ebx
  801fdf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fe2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe5:	50                   	push   %eax
  801fe6:	e8 59 f6 ff ff       	call   801644 <fd_alloc>
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	0f 88 23 01 00 00    	js     80211b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 07 04 00 00       	push   $0x407
  802000:	ff 75 f4             	pushl  -0xc(%ebp)
  802003:	6a 00                	push   $0x0
  802005:	e8 b1 f2 ff ff       	call   8012bb <sys_page_alloc>
  80200a:	89 c3                	mov    %eax,%ebx
  80200c:	83 c4 10             	add    $0x10,%esp
  80200f:	85 c0                	test   %eax,%eax
  802011:	0f 88 04 01 00 00    	js     80211b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80201d:	50                   	push   %eax
  80201e:	e8 21 f6 ff ff       	call   801644 <fd_alloc>
  802023:	89 c3                	mov    %eax,%ebx
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	85 c0                	test   %eax,%eax
  80202a:	0f 88 db 00 00 00    	js     80210b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802030:	83 ec 04             	sub    $0x4,%esp
  802033:	68 07 04 00 00       	push   $0x407
  802038:	ff 75 f0             	pushl  -0x10(%ebp)
  80203b:	6a 00                	push   $0x0
  80203d:	e8 79 f2 ff ff       	call   8012bb <sys_page_alloc>
  802042:	89 c3                	mov    %eax,%ebx
  802044:	83 c4 10             	add    $0x10,%esp
  802047:	85 c0                	test   %eax,%eax
  802049:	0f 88 bc 00 00 00    	js     80210b <pipe+0x131>
	va = fd2data(fd0);
  80204f:	83 ec 0c             	sub    $0xc,%esp
  802052:	ff 75 f4             	pushl  -0xc(%ebp)
  802055:	e8 d3 f5 ff ff       	call   80162d <fd2data>
  80205a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80205c:	83 c4 0c             	add    $0xc,%esp
  80205f:	68 07 04 00 00       	push   $0x407
  802064:	50                   	push   %eax
  802065:	6a 00                	push   $0x0
  802067:	e8 4f f2 ff ff       	call   8012bb <sys_page_alloc>
  80206c:	89 c3                	mov    %eax,%ebx
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	85 c0                	test   %eax,%eax
  802073:	0f 88 82 00 00 00    	js     8020fb <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802079:	83 ec 0c             	sub    $0xc,%esp
  80207c:	ff 75 f0             	pushl  -0x10(%ebp)
  80207f:	e8 a9 f5 ff ff       	call   80162d <fd2data>
  802084:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80208b:	50                   	push   %eax
  80208c:	6a 00                	push   $0x0
  80208e:	56                   	push   %esi
  80208f:	6a 00                	push   $0x0
  802091:	e8 68 f2 ff ff       	call   8012fe <sys_page_map>
  802096:	89 c3                	mov    %eax,%ebx
  802098:	83 c4 20             	add    $0x20,%esp
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 4e                	js     8020ed <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80209f:	a1 24 30 80 00       	mov    0x803024,%eax
  8020a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ac:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020b6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c8:	e8 50 f5 ff ff       	call   80161d <fd2num>
  8020cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020d0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020d2:	83 c4 04             	add    $0x4,%esp
  8020d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8020d8:	e8 40 f5 ff ff       	call   80161d <fd2num>
  8020dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020e0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020eb:	eb 2e                	jmp    80211b <pipe+0x141>
	sys_page_unmap(0, va);
  8020ed:	83 ec 08             	sub    $0x8,%esp
  8020f0:	56                   	push   %esi
  8020f1:	6a 00                	push   $0x0
  8020f3:	e8 48 f2 ff ff       	call   801340 <sys_page_unmap>
  8020f8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020fb:	83 ec 08             	sub    $0x8,%esp
  8020fe:	ff 75 f0             	pushl  -0x10(%ebp)
  802101:	6a 00                	push   $0x0
  802103:	e8 38 f2 ff ff       	call   801340 <sys_page_unmap>
  802108:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80210b:	83 ec 08             	sub    $0x8,%esp
  80210e:	ff 75 f4             	pushl  -0xc(%ebp)
  802111:	6a 00                	push   $0x0
  802113:	e8 28 f2 ff ff       	call   801340 <sys_page_unmap>
  802118:	83 c4 10             	add    $0x10,%esp
}
  80211b:	89 d8                	mov    %ebx,%eax
  80211d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802120:	5b                   	pop    %ebx
  802121:	5e                   	pop    %esi
  802122:	5d                   	pop    %ebp
  802123:	c3                   	ret    

00802124 <pipeisclosed>:
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80212a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212d:	50                   	push   %eax
  80212e:	ff 75 08             	pushl  0x8(%ebp)
  802131:	e8 60 f5 ff ff       	call   801696 <fd_lookup>
  802136:	83 c4 10             	add    $0x10,%esp
  802139:	85 c0                	test   %eax,%eax
  80213b:	78 18                	js     802155 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	ff 75 f4             	pushl  -0xc(%ebp)
  802143:	e8 e5 f4 ff ff       	call   80162d <fd2data>
	return _pipeisclosed(fd, p);
  802148:	89 c2                	mov    %eax,%edx
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	e8 2f fd ff ff       	call   801e81 <_pipeisclosed>
  802152:	83 c4 10             	add    $0x10,%esp
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
  80215c:	c3                   	ret    

0080215d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802163:	68 ee 2d 80 00       	push   $0x802dee
  802168:	ff 75 0c             	pushl  0xc(%ebp)
  80216b:	e8 59 ed ff ff       	call   800ec9 <strcpy>
	return 0;
}
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <devcons_write>:
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	57                   	push   %edi
  80217b:	56                   	push   %esi
  80217c:	53                   	push   %ebx
  80217d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802183:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802188:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80218e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802191:	73 31                	jae    8021c4 <devcons_write+0x4d>
		m = n - tot;
  802193:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802196:	29 f3                	sub    %esi,%ebx
  802198:	83 fb 7f             	cmp    $0x7f,%ebx
  80219b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021a0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	53                   	push   %ebx
  8021a7:	89 f0                	mov    %esi,%eax
  8021a9:	03 45 0c             	add    0xc(%ebp),%eax
  8021ac:	50                   	push   %eax
  8021ad:	57                   	push   %edi
  8021ae:	e8 a4 ee ff ff       	call   801057 <memmove>
		sys_cputs(buf, m);
  8021b3:	83 c4 08             	add    $0x8,%esp
  8021b6:	53                   	push   %ebx
  8021b7:	57                   	push   %edi
  8021b8:	e8 42 f0 ff ff       	call   8011ff <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021bd:	01 de                	add    %ebx,%esi
  8021bf:	83 c4 10             	add    $0x10,%esp
  8021c2:	eb ca                	jmp    80218e <devcons_write+0x17>
}
  8021c4:	89 f0                	mov    %esi,%eax
  8021c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021c9:	5b                   	pop    %ebx
  8021ca:	5e                   	pop    %esi
  8021cb:	5f                   	pop    %edi
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    

008021ce <devcons_read>:
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 08             	sub    $0x8,%esp
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021dd:	74 21                	je     802200 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021df:	e8 39 f0 ff ff       	call   80121d <sys_cgetc>
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	75 07                	jne    8021ef <devcons_read+0x21>
		sys_yield();
  8021e8:	e8 af f0 ff ff       	call   80129c <sys_yield>
  8021ed:	eb f0                	jmp    8021df <devcons_read+0x11>
	if (c < 0)
  8021ef:	78 0f                	js     802200 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021f1:	83 f8 04             	cmp    $0x4,%eax
  8021f4:	74 0c                	je     802202 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f9:	88 02                	mov    %al,(%edx)
	return 1;
  8021fb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    
		return 0;
  802202:	b8 00 00 00 00       	mov    $0x0,%eax
  802207:	eb f7                	jmp    802200 <devcons_read+0x32>

00802209 <cputchar>:
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802215:	6a 01                	push   $0x1
  802217:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80221a:	50                   	push   %eax
  80221b:	e8 df ef ff ff       	call   8011ff <sys_cputs>
}
  802220:	83 c4 10             	add    $0x10,%esp
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <getchar>:
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80222b:	6a 01                	push   $0x1
  80222d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802230:	50                   	push   %eax
  802231:	6a 00                	push   $0x0
  802233:	e8 c9 f6 ff ff       	call   801901 <read>
	if (r < 0)
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	85 c0                	test   %eax,%eax
  80223d:	78 06                	js     802245 <getchar+0x20>
	if (r < 1)
  80223f:	74 06                	je     802247 <getchar+0x22>
	return c;
  802241:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    
		return -E_EOF;
  802247:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80224c:	eb f7                	jmp    802245 <getchar+0x20>

0080224e <iscons>:
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802257:	50                   	push   %eax
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	e8 36 f4 ff ff       	call   801696 <fd_lookup>
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	85 c0                	test   %eax,%eax
  802265:	78 11                	js     802278 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802270:	39 10                	cmp    %edx,(%eax)
  802272:	0f 94 c0             	sete   %al
  802275:	0f b6 c0             	movzbl %al,%eax
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <opencons>:
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802280:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802283:	50                   	push   %eax
  802284:	e8 bb f3 ff ff       	call   801644 <fd_alloc>
  802289:	83 c4 10             	add    $0x10,%esp
  80228c:	85 c0                	test   %eax,%eax
  80228e:	78 3a                	js     8022ca <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 07 04 00 00       	push   $0x407
  802298:	ff 75 f4             	pushl  -0xc(%ebp)
  80229b:	6a 00                	push   $0x0
  80229d:	e8 19 f0 ff ff       	call   8012bb <sys_page_alloc>
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	78 21                	js     8022ca <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8022b2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022be:	83 ec 0c             	sub    $0xc,%esp
  8022c1:	50                   	push   %eax
  8022c2:	e8 56 f3 ff ff       	call   80161d <fd2num>
  8022c7:	83 c4 10             	add    $0x10,%esp
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022d2:	89 d0                	mov    %edx,%eax
  8022d4:	c1 e8 16             	shr    $0x16,%eax
  8022d7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022de:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022e3:	f6 c1 01             	test   $0x1,%cl
  8022e6:	74 1d                	je     802305 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022e8:	c1 ea 0c             	shr    $0xc,%edx
  8022eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022f2:	f6 c2 01             	test   $0x1,%dl
  8022f5:	74 0e                	je     802305 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022f7:	c1 ea 0c             	shr    $0xc,%edx
  8022fa:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802301:	ef 
  802302:	0f b7 c0             	movzwl %ax,%eax
}
  802305:	5d                   	pop    %ebp
  802306:	c3                   	ret    
  802307:	66 90                	xchg   %ax,%ax
  802309:	66 90                	xchg   %ax,%ax
  80230b:	66 90                	xchg   %ax,%ax
  80230d:	66 90                	xchg   %ax,%ax
  80230f:	90                   	nop

00802310 <__udivdi3>:
  802310:	55                   	push   %ebp
  802311:	57                   	push   %edi
  802312:	56                   	push   %esi
  802313:	53                   	push   %ebx
  802314:	83 ec 1c             	sub    $0x1c,%esp
  802317:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80231b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80231f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802323:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802327:	85 d2                	test   %edx,%edx
  802329:	75 4d                	jne    802378 <__udivdi3+0x68>
  80232b:	39 f3                	cmp    %esi,%ebx
  80232d:	76 19                	jbe    802348 <__udivdi3+0x38>
  80232f:	31 ff                	xor    %edi,%edi
  802331:	89 e8                	mov    %ebp,%eax
  802333:	89 f2                	mov    %esi,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 fa                	mov    %edi,%edx
  802339:	83 c4 1c             	add    $0x1c,%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5f                   	pop    %edi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 d9                	mov    %ebx,%ecx
  80234a:	85 db                	test   %ebx,%ebx
  80234c:	75 0b                	jne    802359 <__udivdi3+0x49>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	31 d2                	xor    %edx,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 c1                	mov    %eax,%ecx
  802359:	31 d2                	xor    %edx,%edx
  80235b:	89 f0                	mov    %esi,%eax
  80235d:	f7 f1                	div    %ecx
  80235f:	89 c6                	mov    %eax,%esi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f7                	mov    %esi,%edi
  802365:	f7 f1                	div    %ecx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	39 f2                	cmp    %esi,%edx
  80237a:	77 1c                	ja     802398 <__udivdi3+0x88>
  80237c:	0f bd fa             	bsr    %edx,%edi
  80237f:	83 f7 1f             	xor    $0x1f,%edi
  802382:	75 2c                	jne    8023b0 <__udivdi3+0xa0>
  802384:	39 f2                	cmp    %esi,%edx
  802386:	72 06                	jb     80238e <__udivdi3+0x7e>
  802388:	31 c0                	xor    %eax,%eax
  80238a:	39 eb                	cmp    %ebp,%ebx
  80238c:	77 a9                	ja     802337 <__udivdi3+0x27>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	eb a2                	jmp    802337 <__udivdi3+0x27>
  802395:	8d 76 00             	lea    0x0(%esi),%esi
  802398:	31 ff                	xor    %edi,%edi
  80239a:	31 c0                	xor    %eax,%eax
  80239c:	89 fa                	mov    %edi,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 f9                	mov    %edi,%ecx
  8023b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023b7:	29 f8                	sub    %edi,%eax
  8023b9:	d3 e2                	shl    %cl,%edx
  8023bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023bf:	89 c1                	mov    %eax,%ecx
  8023c1:	89 da                	mov    %ebx,%edx
  8023c3:	d3 ea                	shr    %cl,%edx
  8023c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023c9:	09 d1                	or     %edx,%ecx
  8023cb:	89 f2                	mov    %esi,%edx
  8023cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023d1:	89 f9                	mov    %edi,%ecx
  8023d3:	d3 e3                	shl    %cl,%ebx
  8023d5:	89 c1                	mov    %eax,%ecx
  8023d7:	d3 ea                	shr    %cl,%edx
  8023d9:	89 f9                	mov    %edi,%ecx
  8023db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023df:	89 eb                	mov    %ebp,%ebx
  8023e1:	d3 e6                	shl    %cl,%esi
  8023e3:	89 c1                	mov    %eax,%ecx
  8023e5:	d3 eb                	shr    %cl,%ebx
  8023e7:	09 de                	or     %ebx,%esi
  8023e9:	89 f0                	mov    %esi,%eax
  8023eb:	f7 74 24 08          	divl   0x8(%esp)
  8023ef:	89 d6                	mov    %edx,%esi
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	f7 64 24 0c          	mull   0xc(%esp)
  8023f7:	39 d6                	cmp    %edx,%esi
  8023f9:	72 15                	jb     802410 <__udivdi3+0x100>
  8023fb:	89 f9                	mov    %edi,%ecx
  8023fd:	d3 e5                	shl    %cl,%ebp
  8023ff:	39 c5                	cmp    %eax,%ebp
  802401:	73 04                	jae    802407 <__udivdi3+0xf7>
  802403:	39 d6                	cmp    %edx,%esi
  802405:	74 09                	je     802410 <__udivdi3+0x100>
  802407:	89 d8                	mov    %ebx,%eax
  802409:	31 ff                	xor    %edi,%edi
  80240b:	e9 27 ff ff ff       	jmp    802337 <__udivdi3+0x27>
  802410:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802413:	31 ff                	xor    %edi,%edi
  802415:	e9 1d ff ff ff       	jmp    802337 <__udivdi3+0x27>
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	66 90                	xchg   %ax,%ax
  80241e:	66 90                	xchg   %ax,%ax

00802420 <__umoddi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 1c             	sub    $0x1c,%esp
  802427:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80242b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80242f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802437:	89 da                	mov    %ebx,%edx
  802439:	85 c0                	test   %eax,%eax
  80243b:	75 43                	jne    802480 <__umoddi3+0x60>
  80243d:	39 df                	cmp    %ebx,%edi
  80243f:	76 17                	jbe    802458 <__umoddi3+0x38>
  802441:	89 f0                	mov    %esi,%eax
  802443:	f7 f7                	div    %edi
  802445:	89 d0                	mov    %edx,%eax
  802447:	31 d2                	xor    %edx,%edx
  802449:	83 c4 1c             	add    $0x1c,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 fd                	mov    %edi,%ebp
  80245a:	85 ff                	test   %edi,%edi
  80245c:	75 0b                	jne    802469 <__umoddi3+0x49>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f7                	div    %edi
  802467:	89 c5                	mov    %eax,%ebp
  802469:	89 d8                	mov    %ebx,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f5                	div    %ebp
  80246f:	89 f0                	mov    %esi,%eax
  802471:	f7 f5                	div    %ebp
  802473:	89 d0                	mov    %edx,%eax
  802475:	eb d0                	jmp    802447 <__umoddi3+0x27>
  802477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247e:	66 90                	xchg   %ax,%ax
  802480:	89 f1                	mov    %esi,%ecx
  802482:	39 d8                	cmp    %ebx,%eax
  802484:	76 0a                	jbe    802490 <__umoddi3+0x70>
  802486:	89 f0                	mov    %esi,%eax
  802488:	83 c4 1c             	add    $0x1c,%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5f                   	pop    %edi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    
  802490:	0f bd e8             	bsr    %eax,%ebp
  802493:	83 f5 1f             	xor    $0x1f,%ebp
  802496:	75 20                	jne    8024b8 <__umoddi3+0x98>
  802498:	39 d8                	cmp    %ebx,%eax
  80249a:	0f 82 b0 00 00 00    	jb     802550 <__umoddi3+0x130>
  8024a0:	39 f7                	cmp    %esi,%edi
  8024a2:	0f 86 a8 00 00 00    	jbe    802550 <__umoddi3+0x130>
  8024a8:	89 c8                	mov    %ecx,%eax
  8024aa:	83 c4 1c             	add    $0x1c,%esp
  8024ad:	5b                   	pop    %ebx
  8024ae:	5e                   	pop    %esi
  8024af:	5f                   	pop    %edi
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    
  8024b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8024bf:	29 ea                	sub    %ebp,%edx
  8024c1:	d3 e0                	shl    %cl,%eax
  8024c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c7:	89 d1                	mov    %edx,%ecx
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	d3 e8                	shr    %cl,%eax
  8024cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024d9:	09 c1                	or     %eax,%ecx
  8024db:	89 d8                	mov    %ebx,%eax
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e7                	shl    %cl,%edi
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ef:	d3 e3                	shl    %cl,%ebx
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	89 d1                	mov    %edx,%ecx
  8024f5:	89 f0                	mov    %esi,%eax
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 fa                	mov    %edi,%edx
  8024fd:	d3 e6                	shl    %cl,%esi
  8024ff:	09 d8                	or     %ebx,%eax
  802501:	f7 74 24 08          	divl   0x8(%esp)
  802505:	89 d1                	mov    %edx,%ecx
  802507:	89 f3                	mov    %esi,%ebx
  802509:	f7 64 24 0c          	mull   0xc(%esp)
  80250d:	89 c6                	mov    %eax,%esi
  80250f:	89 d7                	mov    %edx,%edi
  802511:	39 d1                	cmp    %edx,%ecx
  802513:	72 06                	jb     80251b <__umoddi3+0xfb>
  802515:	75 10                	jne    802527 <__umoddi3+0x107>
  802517:	39 c3                	cmp    %eax,%ebx
  802519:	73 0c                	jae    802527 <__umoddi3+0x107>
  80251b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80251f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802523:	89 d7                	mov    %edx,%edi
  802525:	89 c6                	mov    %eax,%esi
  802527:	89 ca                	mov    %ecx,%edx
  802529:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80252e:	29 f3                	sub    %esi,%ebx
  802530:	19 fa                	sbb    %edi,%edx
  802532:	89 d0                	mov    %edx,%eax
  802534:	d3 e0                	shl    %cl,%eax
  802536:	89 e9                	mov    %ebp,%ecx
  802538:	d3 eb                	shr    %cl,%ebx
  80253a:	d3 ea                	shr    %cl,%edx
  80253c:	09 d8                	or     %ebx,%eax
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	89 da                	mov    %ebx,%edx
  802552:	29 fe                	sub    %edi,%esi
  802554:	19 c2                	sbb    %eax,%edx
  802556:	89 f1                	mov    %esi,%ecx
  802558:	89 c8                	mov    %ecx,%eax
  80255a:	e9 4b ff ff ff       	jmp    8024aa <__umoddi3+0x8a>
