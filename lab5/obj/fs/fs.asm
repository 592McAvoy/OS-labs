
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 c7 1a 00 00       	call   801af8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800075:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800085:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0b                	je     800095 <ide_probe_disk1+0x36>
	     x++)
  80008a:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  80008d:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800093:	75 f0                	jne    800085 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800095:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a6:	0f 9e c3             	setle  %bl
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	0f b6 c3             	movzbl %bl,%eax
  8000af:	50                   	push   %eax
  8000b0:	68 60 3a 80 00       	push   $0x803a60
  8000b5:	e8 74 1b 00 00       	call   801c2e <cprintf>
	return (x < 1000);
}
  8000ba:	89 d8                	mov    %ebx,%eax
  8000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    

008000c1 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ca:	83 f8 01             	cmp    $0x1,%eax
  8000cd:	77 07                	ja     8000d6 <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000cf:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 77 3a 80 00       	push   $0x803a77
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 87 3a 80 00       	push   $0x803a87
  8000e5:	e8 69 1a 00 00       	call   801b53 <_panic>

008000ea <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	0f 87 87 00 00 00    	ja     80018f <ide_read+0xa5>

	ide_wait_ready(0);
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	e8 21 ff ff ff       	call   800033 <ide_wait_ready>
  800112:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800117:	89 f0                	mov    %esi,%eax
  800119:	ee                   	out    %al,(%dx)
  80011a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80011f:	89 f8                	mov    %edi,%eax
  800121:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800122:	89 f8                	mov    %edi,%eax
  800124:	c1 e8 08             	shr    $0x8,%eax
  800127:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80012c:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80012d:	89 f8                	mov    %edi,%eax
  80012f:	c1 e8 10             	shr    $0x10,%eax
  800132:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800137:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800138:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  80013f:	c1 e0 04             	shl    $0x4,%eax
  800142:	83 e0 10             	and    $0x10,%eax
  800145:	c1 ef 18             	shr    $0x18,%edi
  800148:	83 e7 0f             	and    $0xf,%edi
  80014b:	09 f8                	or     %edi,%eax
  80014d:	83 c8 e0             	or     $0xffffffe0,%eax
  800150:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800155:	ee                   	out    %al,(%dx)
  800156:	b8 20 00 00 00       	mov    $0x20,%eax
  80015b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	c1 e6 09             	shl    $0x9,%esi
  800164:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	39 f3                	cmp    %esi,%ebx
  800168:	74 3b                	je     8001a5 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016a:	b8 01 00 00 00       	mov    $0x1,%eax
  80016f:	e8 bf fe ff ff       	call   800033 <ide_wait_ready>
  800174:	85 c0                	test   %eax,%eax
  800176:	78 32                	js     8001aa <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  800178:	89 df                	mov    %ebx,%edi
  80017a:	b9 80 00 00 00       	mov    $0x80,%ecx
  80017f:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800184:	fc                   	cld    
  800185:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800187:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80018d:	eb d7                	jmp    800166 <ide_read+0x7c>
	assert(nsecs <= 256);
  80018f:	68 90 3a 80 00       	push   $0x803a90
  800194:	68 9d 3a 80 00       	push   $0x803a9d
  800199:	6a 44                	push   $0x44
  80019b:	68 87 3a 80 00       	push   $0x803a87
  8001a0:	e8 ae 19 00 00       	call   801b53 <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	57                   	push   %edi
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c1:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c4:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ca:	0f 87 87 00 00 00    	ja     800257 <ide_write+0xa5>

	ide_wait_ready(0);
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	e8 59 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001da:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	ee                   	out    %al,(%dx)
  8001e2:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ea:	89 f0                	mov    %esi,%eax
  8001ec:	c1 e8 08             	shr    $0x8,%eax
  8001ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f4:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f5:	89 f0                	mov    %esi,%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
  8001ff:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800200:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800207:	c1 e0 04             	shl    $0x4,%eax
  80020a:	83 e0 10             	and    $0x10,%eax
  80020d:	c1 ee 18             	shr    $0x18,%esi
  800210:	83 e6 0f             	and    $0xf,%esi
  800213:	09 f0                	or     %esi,%eax
  800215:	83 c8 e0             	or     $0xffffffe0,%eax
  800218:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80021d:	ee                   	out    %al,(%dx)
  80021e:	b8 30 00 00 00       	mov    $0x30,%eax
  800223:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800228:	ee                   	out    %al,(%dx)
  800229:	c1 e7 09             	shl    $0x9,%edi
  80022c:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80022e:	39 fb                	cmp    %edi,%ebx
  800230:	74 3b                	je     80026d <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800232:	b8 01 00 00 00       	mov    $0x1,%eax
  800237:	e8 f7 fd ff ff       	call   800033 <ide_wait_ready>
  80023c:	85 c0                	test   %eax,%eax
  80023e:	78 32                	js     800272 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800240:	89 de                	mov    %ebx,%esi
  800242:	b9 80 00 00 00       	mov    $0x80,%ecx
  800247:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80024c:	fc                   	cld    
  80024d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800255:	eb d7                	jmp    80022e <ide_write+0x7c>
	assert(nsecs <= 256);
  800257:	68 90 3a 80 00       	push   $0x803a90
  80025c:	68 9d 3a 80 00       	push   $0x803a9d
  800261:	6a 5d                	push   $0x5d
  800263:	68 87 3a 80 00       	push   $0x803a87
  800268:	e8 e6 18 00 00       	call   801b53 <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800282:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800284:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80028a:	89 c6                	mov    %eax,%esi
  80028c:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80028f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800294:	0f 87 95 00 00 00    	ja     80032f <bc_pgfault+0xb5>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80029a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	74 09                	je     8002ac <bc_pgfault+0x32>
  8002a3:	39 70 04             	cmp    %esi,0x4(%eax)
  8002a6:	0f 86 9e 00 00 00    	jbe    80034a <bc_pgfault+0xd0>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  8002ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8002b2:	83 ec 04             	sub    $0x4,%esp
  8002b5:	6a 07                	push   $0x7
  8002b7:	53                   	push   %ebx
  8002b8:	6a 00                	push   $0x0
  8002ba:	e8 6f 24 00 00       	call   80272e <sys_page_alloc>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	0f 88 92 00 00 00    	js     80035c <bc_pgfault+0xe2>
		panic("in bc_pgfault, sys_page_alloc: %e", r);
	
	if((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	6a 08                	push   $0x8
  8002cf:	53                   	push   %ebx
  8002d0:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002d7:	50                   	push   %eax
  8002d8:	e8 0d fe ff ff       	call   8000ea <ide_read>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	85 c0                	test   %eax,%eax
  8002e2:	0f 88 86 00 00 00    	js     80036e <bc_pgfault+0xf4>
		panic("in bc_pgfault, ide_read: %e", r);

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	c1 e8 0c             	shr    $0xc,%eax
  8002ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8002fc:	50                   	push   %eax
  8002fd:	53                   	push   %ebx
  8002fe:	6a 00                	push   $0x0
  800300:	53                   	push   %ebx
  800301:	6a 00                	push   $0x0
  800303:	e8 69 24 00 00       	call   802771 <sys_page_map>
  800308:	83 c4 20             	add    $0x20,%esp
  80030b:	85 c0                	test   %eax,%eax
  80030d:	78 71                	js     800380 <bc_pgfault+0x106>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80030f:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  800316:	74 10                	je     800328 <bc_pgfault+0xae>
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	56                   	push   %esi
  80031c:	e8 1a 05 00 00       	call   80083b <block_is_free>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	84 c0                	test   %al,%al
  800326:	75 6a                	jne    800392 <bc_pgfault+0x118>
		panic("reading free block %08x\n", blockno);
}
  800328:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 72 04             	pushl  0x4(%edx)
  800335:	53                   	push   %ebx
  800336:	ff 72 28             	pushl  0x28(%edx)
  800339:	68 b4 3a 80 00       	push   $0x803ab4
  80033e:	6a 27                	push   $0x27
  800340:	68 b8 3b 80 00       	push   $0x803bb8
  800345:	e8 09 18 00 00       	call   801b53 <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80034a:	56                   	push   %esi
  80034b:	68 e4 3a 80 00       	push   $0x803ae4
  800350:	6a 2b                	push   $0x2b
  800352:	68 b8 3b 80 00       	push   $0x803bb8
  800357:	e8 f7 17 00 00       	call   801b53 <_panic>
		panic("in bc_pgfault, sys_page_alloc: %e", r);
  80035c:	50                   	push   %eax
  80035d:	68 08 3b 80 00       	push   $0x803b08
  800362:	6a 35                	push   $0x35
  800364:	68 b8 3b 80 00       	push   $0x803bb8
  800369:	e8 e5 17 00 00       	call   801b53 <_panic>
		panic("in bc_pgfault, ide_read: %e", r);
  80036e:	50                   	push   %eax
  80036f:	68 c0 3b 80 00       	push   $0x803bc0
  800374:	6a 38                	push   $0x38
  800376:	68 b8 3b 80 00       	push   $0x803bb8
  80037b:	e8 d3 17 00 00       	call   801b53 <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800380:	50                   	push   %eax
  800381:	68 2c 3b 80 00       	push   $0x803b2c
  800386:	6a 3d                	push   $0x3d
  800388:	68 b8 3b 80 00       	push   $0x803bb8
  80038d:	e8 c1 17 00 00       	call   801b53 <_panic>
		panic("reading free block %08x\n", blockno);
  800392:	56                   	push   %esi
  800393:	68 dc 3b 80 00       	push   $0x803bdc
  800398:	6a 43                	push   $0x43
  80039a:	68 b8 3b 80 00       	push   $0x803bb8
  80039f:	e8 af 17 00 00       	call   801b53 <_panic>

008003a4 <diskaddr>:
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003ad:	85 c0                	test   %eax,%eax
  8003af:	74 19                	je     8003ca <diskaddr+0x26>
  8003b1:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  8003b7:	85 d2                	test   %edx,%edx
  8003b9:	74 05                	je     8003c0 <diskaddr+0x1c>
  8003bb:	39 42 04             	cmp    %eax,0x4(%edx)
  8003be:	76 0a                	jbe    8003ca <diskaddr+0x26>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003c0:	05 00 00 01 00       	add    $0x10000,%eax
  8003c5:	c1 e0 0c             	shl    $0xc,%eax
}
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003ca:	50                   	push   %eax
  8003cb:	68 4c 3b 80 00       	push   $0x803b4c
  8003d0:	6a 09                	push   $0x9
  8003d2:	68 b8 3b 80 00       	push   $0x803bb8
  8003d7:	e8 77 17 00 00       	call   801b53 <_panic>

008003dc <va_is_mapped>:
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003e2:	89 d0                	mov    %edx,%eax
  8003e4:	c1 e8 16             	shr    $0x16,%eax
  8003e7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8003ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f3:	f6 c1 01             	test   $0x1,%cl
  8003f6:	74 0d                	je     800405 <va_is_mapped+0x29>
  8003f8:	c1 ea 0c             	shr    $0xc,%edx
  8003fb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800402:	83 e0 01             	and    $0x1,%eax
  800405:	83 e0 01             	and    $0x1,%eax
}
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <va_is_dirty>:
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	c1 e8 0c             	shr    $0xc,%eax
  800413:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80041a:	c1 e8 06             	shr    $0x6,%eax
  80041d:	83 e0 01             	and    $0x1,%eax
}
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	56                   	push   %esi
  800426:	53                   	push   %ebx
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80042a:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800430:	81 fe ff ff ff bf    	cmp    $0xbfffffff,%esi
  800436:	77 1e                	ja     800456 <flush_block+0x34>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800438:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80043d:	89 c3                	mov    %eax,%ebx
	if(va_is_mapped(addr) && va_is_dirty(addr)){
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 94 ff ff ff       	call   8003dc <va_is_mapped>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	84 c0                	test   %al,%al
  80044d:	75 19                	jne    800468 <flush_block+0x46>
		if((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
			panic("in flish_block, ide_write: %e", r);
		if((r = sys_page_map(0, addr, 0, addr, PTE_SYSCALL)) < 0)
			panic("in flish_block, sys_page_map: %e", r);
	}
}
  80044f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800452:	5b                   	pop    %ebx
  800453:	5e                   	pop    %esi
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  800456:	50                   	push   %eax
  800457:	68 f5 3b 80 00       	push   $0x803bf5
  80045c:	6a 53                	push   $0x53
  80045e:	68 b8 3b 80 00       	push   $0x803bb8
  800463:	e8 eb 16 00 00       	call   801b53 <_panic>
	if(va_is_mapped(addr) && va_is_dirty(addr)){
  800468:	83 ec 0c             	sub    $0xc,%esp
  80046b:	53                   	push   %ebx
  80046c:	e8 99 ff ff ff       	call   80040a <va_is_dirty>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	84 c0                	test   %al,%al
  800476:	74 d7                	je     80044f <flush_block+0x2d>
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800478:	c1 ee 0c             	shr    $0xc,%esi
		if (super && blockno >= super->s_nblocks)
  80047b:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800480:	85 c0                	test   %eax,%eax
  800482:	74 05                	je     800489 <flush_block+0x67>
  800484:	39 70 04             	cmp    %esi,0x4(%eax)
  800487:	76 42                	jbe    8004cb <flush_block+0xa9>
		if((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800489:	83 ec 04             	sub    $0x4,%esp
  80048c:	6a 08                	push   $0x8
  80048e:	53                   	push   %ebx
  80048f:	c1 e6 03             	shl    $0x3,%esi
  800492:	56                   	push   %esi
  800493:	e8 1a fd ff ff       	call   8001b2 <ide_write>
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	85 c0                	test   %eax,%eax
  80049d:	78 3e                	js     8004dd <flush_block+0xbb>
		if((r = sys_page_map(0, addr, 0, addr, PTE_SYSCALL)) < 0)
  80049f:	83 ec 0c             	sub    $0xc,%esp
  8004a2:	68 07 0e 00 00       	push   $0xe07
  8004a7:	53                   	push   %ebx
  8004a8:	6a 00                	push   $0x0
  8004aa:	53                   	push   %ebx
  8004ab:	6a 00                	push   $0x0
  8004ad:	e8 bf 22 00 00       	call   802771 <sys_page_map>
  8004b2:	83 c4 20             	add    $0x20,%esp
  8004b5:	85 c0                	test   %eax,%eax
  8004b7:	79 96                	jns    80044f <flush_block+0x2d>
			panic("in flish_block, sys_page_map: %e", r);
  8004b9:	50                   	push   %eax
  8004ba:	68 70 3b 80 00       	push   $0x803b70
  8004bf:	6a 60                	push   $0x60
  8004c1:	68 b8 3b 80 00       	push   $0x803bb8
  8004c6:	e8 88 16 00 00       	call   801b53 <_panic>
			panic("reading non-existent block %08x\n", blockno);
  8004cb:	56                   	push   %esi
  8004cc:	68 e4 3a 80 00       	push   $0x803ae4
  8004d1:	6a 5a                	push   $0x5a
  8004d3:	68 b8 3b 80 00       	push   $0x803bb8
  8004d8:	e8 76 16 00 00       	call   801b53 <_panic>
			panic("in flish_block, ide_write: %e", r);
  8004dd:	50                   	push   %eax
  8004de:	68 10 3c 80 00       	push   $0x803c10
  8004e3:	6a 5e                	push   $0x5e
  8004e5:	68 b8 3b 80 00       	push   $0x803bb8
  8004ea:	e8 64 16 00 00       	call   801b53 <_panic>

008004ef <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	53                   	push   %ebx
  8004f3:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8004f9:	68 7a 02 80 00       	push   $0x80027a
  8004fe:	e8 9e 24 00 00       	call   8029a1 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  800503:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80050a:	e8 95 fe ff ff       	call   8003a4 <diskaddr>
  80050f:	83 c4 0c             	add    $0xc,%esp
  800512:	68 08 01 00 00       	push   $0x108
  800517:	50                   	push   %eax
  800518:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80051e:	50                   	push   %eax
  80051f:	e8 a6 1f 00 00       	call   8024ca <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800524:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80052b:	e8 74 fe ff ff       	call   8003a4 <diskaddr>
  800530:	83 c4 08             	add    $0x8,%esp
  800533:	68 2e 3c 80 00       	push   $0x803c2e
  800538:	50                   	push   %eax
  800539:	e8 fe 1d 00 00       	call   80233c <strcpy>
	flush_block(diskaddr(1));
  80053e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800545:	e8 5a fe ff ff       	call   8003a4 <diskaddr>
  80054a:	89 04 24             	mov    %eax,(%esp)
  80054d:	e8 d0 fe ff ff       	call   800422 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800552:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800559:	e8 46 fe ff ff       	call   8003a4 <diskaddr>
  80055e:	89 04 24             	mov    %eax,(%esp)
  800561:	e8 76 fe ff ff       	call   8003dc <va_is_mapped>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	84 c0                	test   %al,%al
  80056b:	0f 84 d1 01 00 00    	je     800742 <bc_init+0x253>
	assert(!va_is_dirty(diskaddr(1)));
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	6a 01                	push   $0x1
  800576:	e8 29 fe ff ff       	call   8003a4 <diskaddr>
  80057b:	89 04 24             	mov    %eax,(%esp)
  80057e:	e8 87 fe ff ff       	call   80040a <va_is_dirty>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	84 c0                	test   %al,%al
  800588:	0f 85 ca 01 00 00    	jne    800758 <bc_init+0x269>
	sys_page_unmap(0, diskaddr(1));
  80058e:	83 ec 0c             	sub    $0xc,%esp
  800591:	6a 01                	push   $0x1
  800593:	e8 0c fe ff ff       	call   8003a4 <diskaddr>
  800598:	83 c4 08             	add    $0x8,%esp
  80059b:	50                   	push   %eax
  80059c:	6a 00                	push   $0x0
  80059e:	e8 10 22 00 00       	call   8027b3 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8005a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005aa:	e8 f5 fd ff ff       	call   8003a4 <diskaddr>
  8005af:	89 04 24             	mov    %eax,(%esp)
  8005b2:	e8 25 fe ff ff       	call   8003dc <va_is_mapped>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	84 c0                	test   %al,%al
  8005bc:	0f 85 ac 01 00 00    	jne    80076e <bc_init+0x27f>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005c2:	83 ec 0c             	sub    $0xc,%esp
  8005c5:	6a 01                	push   $0x1
  8005c7:	e8 d8 fd ff ff       	call   8003a4 <diskaddr>
  8005cc:	83 c4 08             	add    $0x8,%esp
  8005cf:	68 2e 3c 80 00       	push   $0x803c2e
  8005d4:	50                   	push   %eax
  8005d5:	e8 0d 1e 00 00       	call   8023e7 <strcmp>
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	85 c0                	test   %eax,%eax
  8005df:	0f 85 9f 01 00 00    	jne    800784 <bc_init+0x295>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005e5:	83 ec 0c             	sub    $0xc,%esp
  8005e8:	6a 01                	push   $0x1
  8005ea:	e8 b5 fd ff ff       	call   8003a4 <diskaddr>
  8005ef:	83 c4 0c             	add    $0xc,%esp
  8005f2:	68 08 01 00 00       	push   $0x108
  8005f7:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  8005fd:	53                   	push   %ebx
  8005fe:	50                   	push   %eax
  8005ff:	e8 c6 1e 00 00       	call   8024ca <memmove>
	flush_block(diskaddr(1));
  800604:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80060b:	e8 94 fd ff ff       	call   8003a4 <diskaddr>
  800610:	89 04 24             	mov    %eax,(%esp)
  800613:	e8 0a fe ff ff       	call   800422 <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  800618:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80061f:	e8 80 fd ff ff       	call   8003a4 <diskaddr>
  800624:	83 c4 0c             	add    $0xc,%esp
  800627:	68 08 01 00 00       	push   $0x108
  80062c:	50                   	push   %eax
  80062d:	53                   	push   %ebx
  80062e:	e8 97 1e 00 00       	call   8024ca <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800633:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80063a:	e8 65 fd ff ff       	call   8003a4 <diskaddr>
  80063f:	83 c4 08             	add    $0x8,%esp
  800642:	68 2e 3c 80 00       	push   $0x803c2e
  800647:	50                   	push   %eax
  800648:	e8 ef 1c 00 00       	call   80233c <strcpy>
	flush_block(diskaddr(1) + 20);
  80064d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800654:	e8 4b fd ff ff       	call   8003a4 <diskaddr>
  800659:	83 c0 14             	add    $0x14,%eax
  80065c:	89 04 24             	mov    %eax,(%esp)
  80065f:	e8 be fd ff ff       	call   800422 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800664:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80066b:	e8 34 fd ff ff       	call   8003a4 <diskaddr>
  800670:	89 04 24             	mov    %eax,(%esp)
  800673:	e8 64 fd ff ff       	call   8003dc <va_is_mapped>
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	84 c0                	test   %al,%al
  80067d:	0f 84 17 01 00 00    	je     80079a <bc_init+0x2ab>
	sys_page_unmap(0, diskaddr(1));
  800683:	83 ec 0c             	sub    $0xc,%esp
  800686:	6a 01                	push   $0x1
  800688:	e8 17 fd ff ff       	call   8003a4 <diskaddr>
  80068d:	83 c4 08             	add    $0x8,%esp
  800690:	50                   	push   %eax
  800691:	6a 00                	push   $0x0
  800693:	e8 1b 21 00 00       	call   8027b3 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800698:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80069f:	e8 00 fd ff ff       	call   8003a4 <diskaddr>
  8006a4:	89 04 24             	mov    %eax,(%esp)
  8006a7:	e8 30 fd ff ff       	call   8003dc <va_is_mapped>
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	84 c0                	test   %al,%al
  8006b1:	0f 85 fc 00 00 00    	jne    8007b3 <bc_init+0x2c4>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006b7:	83 ec 0c             	sub    $0xc,%esp
  8006ba:	6a 01                	push   $0x1
  8006bc:	e8 e3 fc ff ff       	call   8003a4 <diskaddr>
  8006c1:	83 c4 08             	add    $0x8,%esp
  8006c4:	68 2e 3c 80 00       	push   $0x803c2e
  8006c9:	50                   	push   %eax
  8006ca:	e8 18 1d 00 00       	call   8023e7 <strcmp>
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	85 c0                	test   %eax,%eax
  8006d4:	0f 85 f2 00 00 00    	jne    8007cc <bc_init+0x2dd>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	6a 01                	push   $0x1
  8006df:	e8 c0 fc ff ff       	call   8003a4 <diskaddr>
  8006e4:	83 c4 0c             	add    $0xc,%esp
  8006e7:	68 08 01 00 00       	push   $0x108
  8006ec:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8006f2:	52                   	push   %edx
  8006f3:	50                   	push   %eax
  8006f4:	e8 d1 1d 00 00       	call   8024ca <memmove>
	flush_block(diskaddr(1));
  8006f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800700:	e8 9f fc ff ff       	call   8003a4 <diskaddr>
  800705:	89 04 24             	mov    %eax,(%esp)
  800708:	e8 15 fd ff ff       	call   800422 <flush_block>
	cprintf("block cache is good\n");
  80070d:	c7 04 24 6a 3c 80 00 	movl   $0x803c6a,(%esp)
  800714:	e8 15 15 00 00       	call   801c2e <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800719:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800720:	e8 7f fc ff ff       	call   8003a4 <diskaddr>
  800725:	83 c4 0c             	add    $0xc,%esp
  800728:	68 08 01 00 00       	push   $0x108
  80072d:	50                   	push   %eax
  80072e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800734:	50                   	push   %eax
  800735:	e8 90 1d 00 00       	call   8024ca <memmove>
}
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800740:	c9                   	leave  
  800741:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800742:	68 50 3c 80 00       	push   $0x803c50
  800747:	68 9d 3a 80 00       	push   $0x803a9d
  80074c:	6a 71                	push   $0x71
  80074e:	68 b8 3b 80 00       	push   $0x803bb8
  800753:	e8 fb 13 00 00       	call   801b53 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800758:	68 35 3c 80 00       	push   $0x803c35
  80075d:	68 9d 3a 80 00       	push   $0x803a9d
  800762:	6a 72                	push   $0x72
  800764:	68 b8 3b 80 00       	push   $0x803bb8
  800769:	e8 e5 13 00 00       	call   801b53 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  80076e:	68 4f 3c 80 00       	push   $0x803c4f
  800773:	68 9d 3a 80 00       	push   $0x803a9d
  800778:	6a 76                	push   $0x76
  80077a:	68 b8 3b 80 00       	push   $0x803bb8
  80077f:	e8 cf 13 00 00       	call   801b53 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800784:	68 94 3b 80 00       	push   $0x803b94
  800789:	68 9d 3a 80 00       	push   $0x803a9d
  80078e:	6a 79                	push   $0x79
  800790:	68 b8 3b 80 00       	push   $0x803bb8
  800795:	e8 b9 13 00 00       	call   801b53 <_panic>
	assert(va_is_mapped(diskaddr(1)));
  80079a:	68 50 3c 80 00       	push   $0x803c50
  80079f:	68 9d 3a 80 00       	push   $0x803a9d
  8007a4:	68 8a 00 00 00       	push   $0x8a
  8007a9:	68 b8 3b 80 00       	push   $0x803bb8
  8007ae:	e8 a0 13 00 00       	call   801b53 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007b3:	68 4f 3c 80 00       	push   $0x803c4f
  8007b8:	68 9d 3a 80 00       	push   $0x803a9d
  8007bd:	68 92 00 00 00       	push   $0x92
  8007c2:	68 b8 3b 80 00       	push   $0x803bb8
  8007c7:	e8 87 13 00 00       	call   801b53 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007cc:	68 94 3b 80 00       	push   $0x803b94
  8007d1:	68 9d 3a 80 00       	push   $0x803a9d
  8007d6:	68 95 00 00 00       	push   $0x95
  8007db:	68 b8 3b 80 00       	push   $0x803bb8
  8007e0:	e8 6e 13 00 00       	call   801b53 <_panic>

008007e5 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8007eb:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8007f0:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8007f6:	75 1b                	jne    800813 <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8007f8:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007ff:	77 26                	ja     800827 <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  800801:	83 ec 0c             	sub    $0xc,%esp
  800804:	68 bd 3c 80 00       	push   $0x803cbd
  800809:	e8 20 14 00 00       	call   801c2e <cprintf>
}
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	c9                   	leave  
  800812:	c3                   	ret    
		panic("bad file system magic number");
  800813:	83 ec 04             	sub    $0x4,%esp
  800816:	68 7f 3c 80 00       	push   $0x803c7f
  80081b:	6a 0f                	push   $0xf
  80081d:	68 9c 3c 80 00       	push   $0x803c9c
  800822:	e8 2c 13 00 00       	call   801b53 <_panic>
		panic("file system is too large");
  800827:	83 ec 04             	sub    $0x4,%esp
  80082a:	68 a4 3c 80 00       	push   $0x803ca4
  80082f:	6a 12                	push   $0x12
  800831:	68 9c 3c 80 00       	push   $0x803c9c
  800836:	e8 18 13 00 00       	call   801b53 <_panic>

0080083b <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	53                   	push   %ebx
  80083f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800842:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  800848:	85 d2                	test   %edx,%edx
  80084a:	74 25                	je     800871 <block_is_free+0x36>
		return 0;
  80084c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  800851:	39 4a 04             	cmp    %ecx,0x4(%edx)
  800854:	76 18                	jbe    80086e <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800856:	89 cb                	mov    %ecx,%ebx
  800858:	c1 eb 05             	shr    $0x5,%ebx
  80085b:	b8 01 00 00 00       	mov    $0x1,%eax
  800860:	d3 e0                	shl    %cl,%eax
  800862:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  800868:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  80086b:	0f 95 c0             	setne  %al
		return 1;
	return 0;
}
  80086e:	5b                   	pop    %ebx
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    
		return 0;
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
  800876:	eb f6                	jmp    80086e <block_is_free+0x33>

00800878 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	53                   	push   %ebx
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800882:	85 c9                	test   %ecx,%ecx
  800884:	74 1a                	je     8008a0 <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  800886:	89 cb                	mov    %ecx,%ebx
  800888:	c1 eb 05             	shr    $0x5,%ebx
  80088b:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  800891:	b8 01 00 00 00       	mov    $0x1,%eax
  800896:	d3 e0                	shl    %cl,%eax
  800898:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  80089b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    
		panic("attempt to free zero block");
  8008a0:	83 ec 04             	sub    $0x4,%esp
  8008a3:	68 d1 3c 80 00       	push   $0x803cd1
  8008a8:	6a 2d                	push   $0x2d
  8008aa:	68 9c 3c 80 00       	push   $0x803c9c
  8008af:	e8 9f 12 00 00       	call   801b53 <_panic>

008008b4 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	56                   	push   %esi
  8008b8:	53                   	push   %ebx
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno = 0;
	for(; blockno < super->s_nblocks; blockno++){
  8008b9:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8008be:	8b 70 04             	mov    0x4(%eax),%esi
	uint32_t blockno = 0;
  8008c1:	bb 00 00 00 00       	mov    $0x0,%ebx
	for(; blockno < super->s_nblocks; blockno++){
  8008c6:	39 de                	cmp    %ebx,%esi
  8008c8:	74 48                	je     800912 <alloc_block+0x5e>
		if(block_is_free(blockno)){
  8008ca:	83 ec 0c             	sub    $0xc,%esp
  8008cd:	53                   	push   %ebx
  8008ce:	e8 68 ff ff ff       	call   80083b <block_is_free>
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	84 c0                	test   %al,%al
  8008d8:	75 05                	jne    8008df <alloc_block+0x2b>
	for(; blockno < super->s_nblocks; blockno++){
  8008da:	83 c3 01             	add    $0x1,%ebx
  8008dd:	eb e7                	jmp    8008c6 <alloc_block+0x12>
			bitmap[blockno/32] &= ~(1<<(blockno%32));
  8008df:	89 d8                	mov    %ebx,%eax
  8008e1:	c1 e8 05             	shr    $0x5,%eax
  8008e4:	c1 e0 02             	shl    $0x2,%eax
  8008e7:	89 c6                	mov    %eax,%esi
  8008e9:	03 35 04 a0 80 00    	add    0x80a004,%esi
  8008ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8008f4:	89 d9                	mov    %ebx,%ecx
  8008f6:	d3 e2                	shl    %cl,%edx
  8008f8:	f7 d2                	not    %edx
  8008fa:	21 16                	and    %edx,(%esi)
			flush_block(bitmap + blockno/32);
  8008fc:	83 ec 0c             	sub    $0xc,%esp
  8008ff:	03 05 04 a0 80 00    	add    0x80a004,%eax
  800905:	50                   	push   %eax
  800906:	e8 17 fb ff ff       	call   800422 <flush_block>
			return blockno;
  80090b:	89 d8                	mov    %ebx,%eax
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	eb 05                	jmp    800917 <alloc_block+0x63>
		}
	}
	return -E_NO_DISK;
  800912:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	57                   	push   %edi
  800922:	56                   	push   %esi
  800923:	53                   	push   %ebx
  800924:	83 ec 0c             	sub    $0xc,%esp
  800927:	89 c6                	mov    %eax,%esi
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 5: Your code here.
	assert(f);
  80092c:	85 f6                	test   %esi,%esi
  80092e:	74 2b                	je     80095b <file_block_walk+0x3d>
  800930:	89 d3                	mov    %edx,%ebx
  800932:	89 cf                	mov    %ecx,%edi

	if(filebno >= NDIRECT+NINDIRECT)
  800934:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  80093a:	0f 87 a0 00 00 00    	ja     8009e0 <file_block_walk+0xc2>
		return -E_INVAL;
	
	if(filebno < NDIRECT){
  800940:	83 fa 09             	cmp    $0x9,%edx
  800943:	77 2f                	ja     800974 <file_block_walk+0x56>
		*ppdiskbno = f->f_direct + filebno;
  800945:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  80094c:	89 01                	mov    %eax,(%ecx)
			memset(diskaddr(blockno), 0, BLKSIZE);
			*ppdiskbno = (uint32_t *)diskaddr(f->f_indirect) + filebno - NDIRECT;
		}
	}

	return 0;
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800953:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5f                   	pop    %edi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    
	assert(f);
  80095b:	68 56 40 80 00       	push   $0x804056
  800960:	68 9d 3a 80 00       	push   $0x803a9d
  800965:	68 91 00 00 00       	push   $0x91
  80096a:	68 9c 3c 80 00       	push   $0x803c9c
  80096f:	e8 df 11 00 00       	call   801b53 <_panic>
		if(f->f_indirect){
  800974:	8b 96 b0 00 00 00    	mov    0xb0(%esi),%edx
  80097a:	85 d2                	test   %edx,%edx
  80097c:	75 46                	jne    8009c4 <file_block_walk+0xa6>
			if(!alloc)
  80097e:	84 c0                	test   %al,%al
  800980:	74 68                	je     8009ea <file_block_walk+0xcc>
			if((blockno = alloc_block()) < 0)
  800982:	e8 2d ff ff ff       	call   8008b4 <alloc_block>
			f->f_indirect = blockno;
  800987:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
			memset(diskaddr(blockno), 0, BLKSIZE);
  80098d:	83 ec 0c             	sub    $0xc,%esp
  800990:	50                   	push   %eax
  800991:	e8 0e fa ff ff       	call   8003a4 <diskaddr>
  800996:	83 c4 0c             	add    $0xc,%esp
  800999:	68 00 10 00 00       	push   $0x1000
  80099e:	6a 00                	push   $0x0
  8009a0:	50                   	push   %eax
  8009a1:	e8 dc 1a 00 00       	call   802482 <memset>
			*ppdiskbno = (uint32_t *)diskaddr(f->f_indirect) + filebno - NDIRECT;
  8009a6:	83 c4 04             	add    $0x4,%esp
  8009a9:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  8009af:	e8 f0 f9 ff ff       	call   8003a4 <diskaddr>
  8009b4:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  8009b8:	89 07                	mov    %eax,(%edi)
  8009ba:	83 c4 10             	add    $0x10,%esp
	return 0;
  8009bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c2:	eb 8f                	jmp    800953 <file_block_walk+0x35>
			*ppdiskbno = (uint32_t *)diskaddr(f->f_indirect) + filebno - NDIRECT;
  8009c4:	83 ec 0c             	sub    $0xc,%esp
  8009c7:	52                   	push   %edx
  8009c8:	e8 d7 f9 ff ff       	call   8003a4 <diskaddr>
  8009cd:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  8009d1:	89 07                	mov    %eax,(%edi)
  8009d3:	83 c4 10             	add    $0x10,%esp
	return 0;
  8009d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009db:	e9 73 ff ff ff       	jmp    800953 <file_block_walk+0x35>
		return -E_INVAL;
  8009e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e5:	e9 69 ff ff ff       	jmp    800953 <file_block_walk+0x35>
				return -E_NOT_FOUND;
  8009ea:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009ef:	e9 5f ff ff ff       	jmp    800953 <file_block_walk+0x35>

008009f4 <check_bitmap>:
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	56                   	push   %esi
  8009f8:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009f9:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8009fe:	8b 70 04             	mov    0x4(%eax),%esi
  800a01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a06:	89 d8                	mov    %ebx,%eax
  800a08:	c1 e0 0f             	shl    $0xf,%eax
  800a0b:	39 c6                	cmp    %eax,%esi
  800a0d:	76 2e                	jbe    800a3d <check_bitmap+0x49>
		assert(!block_is_free(2+i));
  800a0f:	83 ec 0c             	sub    $0xc,%esp
  800a12:	8d 43 02             	lea    0x2(%ebx),%eax
  800a15:	50                   	push   %eax
  800a16:	e8 20 fe ff ff       	call   80083b <block_is_free>
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	84 c0                	test   %al,%al
  800a20:	75 05                	jne    800a27 <check_bitmap+0x33>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a22:	83 c3 01             	add    $0x1,%ebx
  800a25:	eb df                	jmp    800a06 <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  800a27:	68 ec 3c 80 00       	push   $0x803cec
  800a2c:	68 9d 3a 80 00       	push   $0x803a9d
  800a31:	6a 57                	push   $0x57
  800a33:	68 9c 3c 80 00       	push   $0x803c9c
  800a38:	e8 16 11 00 00       	call   801b53 <_panic>
	assert(!block_is_free(0));
  800a3d:	83 ec 0c             	sub    $0xc,%esp
  800a40:	6a 00                	push   $0x0
  800a42:	e8 f4 fd ff ff       	call   80083b <block_is_free>
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	84 c0                	test   %al,%al
  800a4c:	75 28                	jne    800a76 <check_bitmap+0x82>
	assert(!block_is_free(1));
  800a4e:	83 ec 0c             	sub    $0xc,%esp
  800a51:	6a 01                	push   $0x1
  800a53:	e8 e3 fd ff ff       	call   80083b <block_is_free>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	84 c0                	test   %al,%al
  800a5d:	75 2d                	jne    800a8c <check_bitmap+0x98>
	cprintf("bitmap is good\n");
  800a5f:	83 ec 0c             	sub    $0xc,%esp
  800a62:	68 24 3d 80 00       	push   $0x803d24
  800a67:	e8 c2 11 00 00       	call   801c2e <cprintf>
}
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    
	assert(!block_is_free(0));
  800a76:	68 00 3d 80 00       	push   $0x803d00
  800a7b:	68 9d 3a 80 00       	push   $0x803a9d
  800a80:	6a 5a                	push   $0x5a
  800a82:	68 9c 3c 80 00       	push   $0x803c9c
  800a87:	e8 c7 10 00 00       	call   801b53 <_panic>
	assert(!block_is_free(1));
  800a8c:	68 12 3d 80 00       	push   $0x803d12
  800a91:	68 9d 3a 80 00       	push   $0x803a9d
  800a96:	6a 5b                	push   $0x5b
  800a98:	68 9c 3c 80 00       	push   $0x803c9c
  800a9d:	e8 b1 10 00 00       	call   801b53 <_panic>

00800aa2 <fs_init>:
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800aa8:	e8 b2 f5 ff ff       	call   80005f <ide_probe_disk1>
  800aad:	84 c0                	test   %al,%al
  800aaf:	74 41                	je     800af2 <fs_init+0x50>
		ide_set_disk(1);
  800ab1:	83 ec 0c             	sub    $0xc,%esp
  800ab4:	6a 01                	push   $0x1
  800ab6:	e8 06 f6 ff ff       	call   8000c1 <ide_set_disk>
  800abb:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800abe:	e8 2c fa ff ff       	call   8004ef <bc_init>
	super = diskaddr(1);
  800ac3:	83 ec 0c             	sub    $0xc,%esp
  800ac6:	6a 01                	push   $0x1
  800ac8:	e8 d7 f8 ff ff       	call   8003a4 <diskaddr>
  800acd:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_super();
  800ad2:	e8 0e fd ff ff       	call   8007e5 <check_super>
	bitmap = diskaddr(2);
  800ad7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800ade:	e8 c1 f8 ff ff       	call   8003a4 <diskaddr>
  800ae3:	a3 04 a0 80 00       	mov    %eax,0x80a004
	check_bitmap();
  800ae8:	e8 07 ff ff ff       	call   8009f4 <check_bitmap>
}
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    
		ide_set_disk(0);
  800af2:	83 ec 0c             	sub    $0xc,%esp
  800af5:	6a 00                	push   $0x0
  800af7:	e8 c5 f5 ff ff       	call   8000c1 <ide_set_disk>
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	eb bd                	jmp    800abe <fs_init+0x1c>

00800b01 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 18             	sub    $0x18,%esp
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 5: Your code here.
	assert(f);
  800b0a:	85 c0                	test   %eax,%eax
  800b0c:	74 49                	je     800b57 <file_get_block+0x56>

	uint32_t *pdiskbno;
	int r;

	if((r = file_block_walk(f, filebno, &pdiskbno, 1))<0)
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	6a 01                	push   $0x1
  800b13:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b19:	e8 00 fe ff ff       	call   80091e <file_block_walk>
  800b1e:	83 c4 10             	add    $0x10,%esp
  800b21:	85 c0                	test   %eax,%eax
  800b23:	78 30                	js     800b55 <file_get_block+0x54>
		return r;

	if(!(*pdiskbno)){
  800b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b28:	83 38 00             	cmpl   $0x0,(%eax)
  800b2b:	75 0e                	jne    800b3b <file_get_block+0x3a>
		if((r = alloc_block()) < 0)
  800b2d:	e8 82 fd ff ff       	call   8008b4 <alloc_block>
  800b32:	85 c0                	test   %eax,%eax
  800b34:	78 1f                	js     800b55 <file_get_block+0x54>
			return r;
		*pdiskbno = r;
  800b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b39:	89 02                	mov    %eax,(%edx)
	}

	*blk = diskaddr(*pdiskbno);
  800b3b:	83 ec 0c             	sub    $0xc,%esp
  800b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b41:	ff 30                	pushl  (%eax)
  800b43:	e8 5c f8 ff ff       	call   8003a4 <diskaddr>
  800b48:	8b 55 10             	mov    0x10(%ebp),%edx
  800b4b:	89 02                	mov    %eax,(%edx)
	
	return 0;
  800b4d:	83 c4 10             	add    $0x10,%esp
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax

}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    
	assert(f);
  800b57:	68 56 40 80 00       	push   $0x804056
  800b5c:	68 9d 3a 80 00       	push   $0x803a9d
  800b61:	68 b9 00 00 00       	push   $0xb9
  800b66:	68 9c 3c 80 00       	push   $0x803c9c
  800b6b:	e8 e3 0f 00 00       	call   801b53 <_panic>

00800b70 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
  800b76:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800b7c:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800b82:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
  800b88:	eb 03                	jmp    800b8d <walk_path+0x1d>
		p++;
  800b8a:	83 c0 01             	add    $0x1,%eax
	while (*p == '/')
  800b8d:	80 38 2f             	cmpb   $0x2f,(%eax)
  800b90:	74 f8                	je     800b8a <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800b92:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  800b98:	83 c1 08             	add    $0x8,%ecx
  800b9b:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800ba1:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800ba8:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800bae:	85 c9                	test   %ecx,%ecx
  800bb0:	74 06                	je     800bb8 <walk_path+0x48>
		*pdir = 0;
  800bb2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800bb8:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800bbe:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800bc9:	e9 c5 01 00 00       	jmp    800d93 <walk_path+0x223>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800bce:	83 c6 01             	add    $0x1,%esi
		while (*path != '/' && *path != '\0')
  800bd1:	0f b6 16             	movzbl (%esi),%edx
  800bd4:	80 fa 2f             	cmp    $0x2f,%dl
  800bd7:	74 04                	je     800bdd <walk_path+0x6d>
  800bd9:	84 d2                	test   %dl,%dl
  800bdb:	75 f1                	jne    800bce <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	29 c3                	sub    %eax,%ebx
  800be1:	83 fb 7f             	cmp    $0x7f,%ebx
  800be4:	0f 8f 71 01 00 00    	jg     800d5b <walk_path+0x1eb>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	53                   	push   %ebx
  800bee:	50                   	push   %eax
  800bef:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800bf5:	50                   	push   %eax
  800bf6:	e8 cf 18 00 00       	call   8024ca <memmove>
		name[path - p] = '\0';
  800bfb:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800c02:	00 
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	eb 03                	jmp    800c0b <walk_path+0x9b>
		p++;
  800c08:	83 c6 01             	add    $0x1,%esi
	while (*p == '/')
  800c0b:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800c0e:	74 f8                	je     800c08 <walk_path+0x98>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800c10:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c16:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c1d:	0f 85 3f 01 00 00    	jne    800d62 <walk_path+0x1f2>
	assert((dir->f_size % BLKSIZE) == 0);
  800c23:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c29:	89 c1                	mov    %eax,%ecx
  800c2b:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
  800c31:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
  800c37:	0f 85 8e 00 00 00    	jne    800ccb <walk_path+0x15b>
	nblock = dir->f_size / BLKSIZE;
  800c3d:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c43:	85 c0                	test   %eax,%eax
  800c45:	0f 48 c2             	cmovs  %edx,%eax
  800c48:	c1 f8 0c             	sar    $0xc,%eax
  800c4b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
			if (strcmp(f[j].f_name, name) == 0) {
  800c51:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
  800c57:	89 b5 44 ff ff ff    	mov    %esi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800c5d:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c63:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c69:	74 79                	je     800ce4 <walk_path+0x174>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c6b:	83 ec 04             	sub    $0x4,%esp
  800c6e:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800c7b:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800c81:	e8 7b fe ff ff       	call   800b01 <file_get_block>
  800c86:	83 c4 10             	add    $0x10,%esp
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	0f 88 d8 00 00 00    	js     800d69 <walk_path+0x1f9>
  800c91:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800c97:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
			if (strcmp(f[j].f_name, name) == 0) {
  800c9d:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	57                   	push   %edi
  800ca7:	53                   	push   %ebx
  800ca8:	e8 3a 17 00 00       	call   8023e7 <strcmp>
  800cad:	83 c4 10             	add    $0x10,%esp
  800cb0:	85 c0                	test   %eax,%eax
  800cb2:	0f 84 c1 00 00 00    	je     800d79 <walk_path+0x209>
  800cb8:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800cbe:	39 f3                	cmp    %esi,%ebx
  800cc0:	75 db                	jne    800c9d <walk_path+0x12d>
	for (i = 0; i < nblock; i++) {
  800cc2:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800cc9:	eb 92                	jmp    800c5d <walk_path+0xed>
	assert((dir->f_size % BLKSIZE) == 0);
  800ccb:	68 34 3d 80 00       	push   $0x803d34
  800cd0:	68 9d 3a 80 00       	push   $0x803a9d
  800cd5:	68 dc 00 00 00       	push   $0xdc
  800cda:	68 9c 3c 80 00       	push   $0x803c9c
  800cdf:	e8 6f 0e 00 00       	call   801b53 <_panic>
  800ce4:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800cea:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800cef:	80 3e 00             	cmpb   $0x0,(%esi)
  800cf2:	75 5f                	jne    800d53 <walk_path+0x1e3>
				if (pdir)
  800cf4:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cfa:	85 c0                	test   %eax,%eax
  800cfc:	74 08                	je     800d06 <walk_path+0x196>
					*pdir = dir;
  800cfe:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d04:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800d06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0a:	74 15                	je     800d21 <walk_path+0x1b1>
					strcpy(lastelem, name);
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d15:	50                   	push   %eax
  800d16:	ff 75 08             	pushl  0x8(%ebp)
  800d19:	e8 1e 16 00 00       	call   80233c <strcpy>
  800d1e:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800d21:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800d2d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d32:	eb 1f                	jmp    800d53 <walk_path+0x1e3>
		}
	}

	if (pdir)
  800d34:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	74 02                	je     800d40 <walk_path+0x1d0>
		*pdir = dir;
  800d3e:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d40:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d46:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d4c:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    
			return -E_BAD_PATH;
  800d5b:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d60:	eb f1                	jmp    800d53 <walk_path+0x1e3>
			return -E_NOT_FOUND;
  800d62:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d67:	eb ea                	jmp    800d53 <walk_path+0x1e3>
  800d69:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d6f:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d72:	75 df                	jne    800d53 <walk_path+0x1e3>
  800d74:	e9 71 ff ff ff       	jmp    800cea <walk_path+0x17a>
  800d79:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
  800d7f:	89 f0                	mov    %esi,%eax
  800d81:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800d87:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800d8d:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	while (*path != '\0') {
  800d93:	80 38 00             	cmpb   $0x0,(%eax)
  800d96:	74 9c                	je     800d34 <walk_path+0x1c4>
  800d98:	89 c6                	mov    %eax,%esi
  800d9a:	e9 32 fe ff ff       	jmp    800bd1 <walk_path+0x61>

00800d9f <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800da5:	6a 00                	push   $0x0
  800da7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	e8 b9 fd ff ff       	call   800b70 <walk_path>
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 2c             	sub    $0x2c,%esp
  800dc2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800dc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc8:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800dd4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800dd9:	39 ca                	cmp    %ecx,%edx
  800ddb:	7e 7e                	jle    800e5b <file_read+0xa2>

	count = MIN(count, f->f_size - offset);
  800ddd:	29 ca                	sub    %ecx,%edx
  800ddf:	39 da                	cmp    %ebx,%edx
  800de1:	89 d8                	mov    %ebx,%eax
  800de3:	0f 46 c2             	cmovbe %edx,%eax
  800de6:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800de9:	89 cb                	mov    %ecx,%ebx
  800deb:	01 c1                	add    %eax,%ecx
  800ded:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800df0:	89 de                	mov    %ebx,%esi
  800df2:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800df5:	76 61                	jbe    800e58 <file_read+0x9f>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800df7:	83 ec 04             	sub    $0x4,%esp
  800dfa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800dfd:	50                   	push   %eax
  800dfe:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800e04:	85 db                	test   %ebx,%ebx
  800e06:	0f 49 c3             	cmovns %ebx,%eax
  800e09:	c1 f8 0c             	sar    $0xc,%eax
  800e0c:	50                   	push   %eax
  800e0d:	ff 75 08             	pushl  0x8(%ebp)
  800e10:	e8 ec fc ff ff       	call   800b01 <file_get_block>
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	78 3f                	js     800e5b <file_read+0xa2>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800e1c:	89 da                	mov    %ebx,%edx
  800e1e:	c1 fa 1f             	sar    $0x1f,%edx
  800e21:	c1 ea 14             	shr    $0x14,%edx
  800e24:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800e27:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e2c:	29 d0                	sub    %edx,%eax
  800e2e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e33:	29 c2                	sub    %eax,%edx
  800e35:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e38:	29 f1                	sub    %esi,%ecx
  800e3a:	89 ce                	mov    %ecx,%esi
  800e3c:	39 ca                	cmp    %ecx,%edx
  800e3e:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e41:	83 ec 04             	sub    $0x4,%esp
  800e44:	56                   	push   %esi
  800e45:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e48:	50                   	push   %eax
  800e49:	57                   	push   %edi
  800e4a:	e8 7b 16 00 00       	call   8024ca <memmove>
		pos += bn;
  800e4f:	01 f3                	add    %esi,%ebx
		buf += bn;
  800e51:	01 f7                	add    %esi,%edi
  800e53:	83 c4 10             	add    $0x10,%esp
  800e56:	eb 98                	jmp    800df0 <file_read+0x37>
	}

	return count;
  800e58:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 2c             	sub    $0x2c,%esp
  800e6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (f->f_size > newsize)
  800e72:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800e78:	39 f8                	cmp    %edi,%eax
  800e7a:	7f 1c                	jg     800e98 <file_set_size+0x35>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800e7c:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
	flush_block(f);
  800e82:	83 ec 0c             	sub    $0xc,%esp
  800e85:	53                   	push   %ebx
  800e86:	e8 97 f5 ff ff       	call   800422 <flush_block>
	return 0;
}
  800e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800e98:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800e9e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ea3:	0f 48 c2             	cmovs  %edx,%eax
  800ea6:	c1 f8 0c             	sar    $0xc,%eax
  800ea9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800eac:	8d 87 fe 1f 00 00    	lea    0x1ffe(%edi),%eax
  800eb2:	89 fa                	mov    %edi,%edx
  800eb4:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800eba:	0f 49 c2             	cmovns %edx,%eax
  800ebd:	c1 f8 0c             	sar    $0xc,%eax
  800ec0:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ec3:	89 c6                	mov    %eax,%esi
  800ec5:	eb 3c                	jmp    800f03 <file_set_size+0xa0>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800ec7:	83 7d d0 0a          	cmpl   $0xa,-0x30(%ebp)
  800ecb:	77 af                	ja     800e7c <file_set_size+0x19>
  800ecd:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	74 a5                	je     800e7c <file_set_size+0x19>
		free_block(f->f_indirect);
  800ed7:	83 ec 0c             	sub    $0xc,%esp
  800eda:	50                   	push   %eax
  800edb:	e8 98 f9 ff ff       	call   800878 <free_block>
		f->f_indirect = 0;
  800ee0:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
  800ee7:	00 00 00 
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	eb 8d                	jmp    800e7c <file_set_size+0x19>
			cprintf("warning: file_free_block: %e", r);
  800eef:	83 ec 08             	sub    $0x8,%esp
  800ef2:	50                   	push   %eax
  800ef3:	68 51 3d 80 00       	push   $0x803d51
  800ef8:	e8 31 0d 00 00       	call   801c2e <cprintf>
  800efd:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800f00:	83 c6 01             	add    $0x1,%esi
  800f03:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800f06:	76 bf                	jbe    800ec7 <file_set_size+0x64>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800f08:	83 ec 0c             	sub    $0xc,%esp
  800f0b:	6a 00                	push   $0x0
  800f0d:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800f10:	89 f2                	mov    %esi,%edx
  800f12:	89 d8                	mov    %ebx,%eax
  800f14:	e8 05 fa ff ff       	call   80091e <file_block_walk>
  800f19:	83 c4 10             	add    $0x10,%esp
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	78 cf                	js     800eef <file_set_size+0x8c>
	if (*ptr) {
  800f20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f23:	8b 00                	mov    (%eax),%eax
  800f25:	85 c0                	test   %eax,%eax
  800f27:	74 d7                	je     800f00 <file_set_size+0x9d>
		free_block(*ptr);
  800f29:	83 ec 0c             	sub    $0xc,%esp
  800f2c:	50                   	push   %eax
  800f2d:	e8 46 f9 ff ff       	call   800878 <free_block>
		*ptr = 0;
  800f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f3b:	83 c4 10             	add    $0x10,%esp
  800f3e:	eb c0                	jmp    800f00 <file_set_size+0x9d>

00800f40 <file_write>:
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 2c             	sub    $0x2c,%esp
  800f49:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f4c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  800f4f:	89 d8                	mov    %ebx,%eax
  800f51:	03 45 10             	add    0x10(%ebp),%eax
  800f54:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5a:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800f60:	77 68                	ja     800fca <file_write+0x8a>
	for (pos = offset; pos < offset + count; ) {
  800f62:	89 de                	mov    %ebx,%esi
  800f64:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800f67:	76 74                	jbe    800fdd <file_write+0x9d>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f69:	83 ec 04             	sub    $0x4,%esp
  800f6c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f6f:	50                   	push   %eax
  800f70:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800f76:	85 db                	test   %ebx,%ebx
  800f78:	0f 49 c3             	cmovns %ebx,%eax
  800f7b:	c1 f8 0c             	sar    $0xc,%eax
  800f7e:	50                   	push   %eax
  800f7f:	ff 75 08             	pushl  0x8(%ebp)
  800f82:	e8 7a fb ff ff       	call   800b01 <file_get_block>
  800f87:	83 c4 10             	add    $0x10,%esp
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	78 52                	js     800fe0 <file_write+0xa0>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f8e:	89 da                	mov    %ebx,%edx
  800f90:	c1 fa 1f             	sar    $0x1f,%edx
  800f93:	c1 ea 14             	shr    $0x14,%edx
  800f96:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800f99:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f9e:	29 d0                	sub    %edx,%eax
  800fa0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800fa5:	29 c1                	sub    %eax,%ecx
  800fa7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800faa:	29 f2                	sub    %esi,%edx
  800fac:	39 d1                	cmp    %edx,%ecx
  800fae:	89 d6                	mov    %edx,%esi
  800fb0:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800fb3:	83 ec 04             	sub    $0x4,%esp
  800fb6:	56                   	push   %esi
  800fb7:	57                   	push   %edi
  800fb8:	03 45 e4             	add    -0x1c(%ebp),%eax
  800fbb:	50                   	push   %eax
  800fbc:	e8 09 15 00 00       	call   8024ca <memmove>
		pos += bn;
  800fc1:	01 f3                	add    %esi,%ebx
		buf += bn;
  800fc3:	01 f7                	add    %esi,%edi
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	eb 98                	jmp    800f62 <file_write+0x22>
		if ((r = file_set_size(f, offset + count)) < 0)
  800fca:	83 ec 08             	sub    $0x8,%esp
  800fcd:	50                   	push   %eax
  800fce:	51                   	push   %ecx
  800fcf:	e8 8f fe ff ff       	call   800e63 <file_set_size>
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	79 87                	jns    800f62 <file_write+0x22>
  800fdb:	eb 03                	jmp    800fe0 <file_write+0xa0>
	return count;
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe3:	5b                   	pop    %ebx
  800fe4:	5e                   	pop    %esi
  800fe5:	5f                   	pop    %edi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
  800fed:	83 ec 10             	sub    $0x10,%esp
  800ff0:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800ff3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff8:	eb 03                	jmp    800ffd <file_flush+0x15>
  800ffa:	83 c3 01             	add    $0x1,%ebx
  800ffd:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  801003:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801009:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  80100f:	85 c9                	test   %ecx,%ecx
  801011:	0f 49 c1             	cmovns %ecx,%eax
  801014:	c1 f8 0c             	sar    $0xc,%eax
  801017:	39 d8                	cmp    %ebx,%eax
  801019:	7e 3b                	jle    801056 <file_flush+0x6e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	6a 00                	push   $0x0
  801020:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  801023:	89 da                	mov    %ebx,%edx
  801025:	89 f0                	mov    %esi,%eax
  801027:	e8 f2 f8 ff ff       	call   80091e <file_block_walk>
  80102c:	83 c4 10             	add    $0x10,%esp
  80102f:	85 c0                	test   %eax,%eax
  801031:	78 c7                	js     800ffa <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801033:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801036:	85 c0                	test   %eax,%eax
  801038:	74 c0                	je     800ffa <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	85 c0                	test   %eax,%eax
  80103e:	74 ba                	je     800ffa <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801040:	83 ec 0c             	sub    $0xc,%esp
  801043:	50                   	push   %eax
  801044:	e8 5b f3 ff ff       	call   8003a4 <diskaddr>
  801049:	89 04 24             	mov    %eax,(%esp)
  80104c:	e8 d1 f3 ff ff       	call   800422 <flush_block>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	eb a4                	jmp    800ffa <file_flush+0x12>
	}
	flush_block(f);
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	56                   	push   %esi
  80105a:	e8 c3 f3 ff ff       	call   800422 <flush_block>
	if (f->f_indirect)
  80105f:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  801065:	83 c4 10             	add    $0x10,%esp
  801068:	85 c0                	test   %eax,%eax
  80106a:	75 07                	jne    801073 <file_flush+0x8b>
		flush_block(diskaddr(f->f_indirect));
}
  80106c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80106f:	5b                   	pop    %ebx
  801070:	5e                   	pop    %esi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  801073:	83 ec 0c             	sub    $0xc,%esp
  801076:	50                   	push   %eax
  801077:	e8 28 f3 ff ff       	call   8003a4 <diskaddr>
  80107c:	89 04 24             	mov    %eax,(%esp)
  80107f:	e8 9e f3 ff ff       	call   800422 <flush_block>
  801084:	83 c4 10             	add    $0x10,%esp
}
  801087:	eb e3                	jmp    80106c <file_flush+0x84>

00801089 <file_create>:
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	57                   	push   %edi
  80108d:	56                   	push   %esi
  80108e:	53                   	push   %ebx
  80108f:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801095:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80109b:	50                   	push   %eax
  80109c:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  8010a2:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	e8 c0 fa ff ff       	call   800b70 <walk_path>
  8010b0:	83 c4 10             	add    $0x10,%esp
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	0f 84 0b 01 00 00    	je     8011c6 <file_create+0x13d>
	if (r != -E_NOT_FOUND || dir == 0)
  8010bb:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8010be:	0f 85 ca 00 00 00    	jne    80118e <file_create+0x105>
  8010c4:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  8010ca:	85 f6                	test   %esi,%esi
  8010cc:	0f 84 bc 00 00 00    	je     80118e <file_create+0x105>
	assert((dir->f_size % BLKSIZE) == 0);
  8010d2:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  8010d8:	89 c3                	mov    %eax,%ebx
  8010da:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  8010e0:	75 57                	jne    801139 <file_create+0xb0>
	nblock = dir->f_size / BLKSIZE;
  8010e2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	0f 48 c2             	cmovs  %edx,%eax
  8010ed:	c1 f8 0c             	sar    $0xc,%eax
  8010f0:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010f6:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  8010fc:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  801102:	0f 84 8e 00 00 00    	je     801196 <file_create+0x10d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801108:	83 ec 04             	sub    $0x4,%esp
  80110b:	57                   	push   %edi
  80110c:	53                   	push   %ebx
  80110d:	56                   	push   %esi
  80110e:	e8 ee f9 ff ff       	call   800b01 <file_get_block>
  801113:	83 c4 10             	add    $0x10,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	78 74                	js     80118e <file_create+0x105>
  80111a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801120:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  801126:	80 38 00             	cmpb   $0x0,(%eax)
  801129:	74 27                	je     801152 <file_create+0xc9>
  80112b:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  801130:	39 d0                	cmp    %edx,%eax
  801132:	75 f2                	jne    801126 <file_create+0x9d>
	for (i = 0; i < nblock; i++) {
  801134:	83 c3 01             	add    $0x1,%ebx
  801137:	eb c3                	jmp    8010fc <file_create+0x73>
	assert((dir->f_size % BLKSIZE) == 0);
  801139:	68 34 3d 80 00       	push   $0x803d34
  80113e:	68 9d 3a 80 00       	push   $0x803a9d
  801143:	68 f5 00 00 00       	push   $0xf5
  801148:	68 9c 3c 80 00       	push   $0x803c9c
  80114d:	e8 01 0a 00 00       	call   801b53 <_panic>
				*file = &f[j];
  801152:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801158:	83 ec 08             	sub    $0x8,%esp
  80115b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801161:	50                   	push   %eax
  801162:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801168:	e8 cf 11 00 00       	call   80233c <strcpy>
	*pf = f;
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801176:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801178:	83 c4 04             	add    $0x4,%esp
  80117b:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  801181:	e8 62 fe ff ff       	call   800fe8 <file_flush>
	return 0;
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801191:	5b                   	pop    %ebx
  801192:	5e                   	pop    %esi
  801193:	5f                   	pop    %edi
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    
	dir->f_size += BLKSIZE;
  801196:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  80119d:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8011a0:	83 ec 04             	sub    $0x4,%esp
  8011a3:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  8011a9:	50                   	push   %eax
  8011aa:	53                   	push   %ebx
  8011ab:	56                   	push   %esi
  8011ac:	e8 50 f9 ff ff       	call   800b01 <file_get_block>
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	78 d6                	js     80118e <file_create+0x105>
	*file = &f[0];
  8011b8:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011be:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8011c4:	eb 92                	jmp    801158 <file_create+0xcf>
		return -E_FILE_EXISTS;
  8011c6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8011cb:	eb c1                	jmp    80118e <file_create+0x105>

008011cd <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	53                   	push   %ebx
  8011d1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8011d4:	bb 01 00 00 00       	mov    $0x1,%ebx
  8011d9:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8011de:	39 58 04             	cmp    %ebx,0x4(%eax)
  8011e1:	76 19                	jbe    8011fc <fs_sync+0x2f>
		flush_block(diskaddr(i));
  8011e3:	83 ec 0c             	sub    $0xc,%esp
  8011e6:	53                   	push   %ebx
  8011e7:	e8 b8 f1 ff ff       	call   8003a4 <diskaddr>
  8011ec:	89 04 24             	mov    %eax,(%esp)
  8011ef:	e8 2e f2 ff ff       	call   800422 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  8011f4:	83 c3 01             	add    $0x1,%ebx
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	eb dd                	jmp    8011d9 <fs_sync+0xc>
}
  8011fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801207:	e8 c1 ff ff ff       	call   8011cd <fs_sync>
	return 0;
}
  80120c:	b8 00 00 00 00       	mov    $0x0,%eax
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <serve_init>:
{
  801213:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  801218:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80121d:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801222:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801224:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801227:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80122d:	83 c0 01             	add    $0x1,%eax
  801230:	83 c2 10             	add    $0x10,%edx
  801233:	3d 00 04 00 00       	cmp    $0x400,%eax
  801238:	75 e8                	jne    801222 <serve_init+0xf>
}
  80123a:	c3                   	ret    

0080123b <openfile_alloc>:
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	57                   	push   %edi
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
  801241:	83 ec 0c             	sub    $0xc,%esp
  801244:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  801247:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124c:	89 de                	mov    %ebx,%esi
  80124e:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  80125a:	e8 21 1b 00 00       	call   802d80 <pageref>
  80125f:	83 c4 10             	add    $0x10,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	74 17                	je     80127d <openfile_alloc+0x42>
  801266:	83 f8 01             	cmp    $0x1,%eax
  801269:	74 30                	je     80129b <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  80126b:	83 c3 01             	add    $0x1,%ebx
  80126e:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801274:	75 d6                	jne    80124c <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  801276:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80127b:	eb 4f                	jmp    8012cc <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  80127d:	83 ec 04             	sub    $0x4,%esp
  801280:	6a 07                	push   $0x7
  801282:	89 d8                	mov    %ebx,%eax
  801284:	c1 e0 04             	shl    $0x4,%eax
  801287:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  80128d:	6a 00                	push   $0x0
  80128f:	e8 9a 14 00 00       	call   80272e <sys_page_alloc>
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	78 31                	js     8012cc <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  80129b:	c1 e3 04             	shl    $0x4,%ebx
  80129e:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  8012a5:	04 00 00 
			*o = &opentab[i];
  8012a8:	81 c6 60 50 80 00    	add    $0x805060,%esi
  8012ae:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	68 00 10 00 00       	push   $0x1000
  8012b8:	6a 00                	push   $0x0
  8012ba:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  8012c0:	e8 bd 11 00 00       	call   802482 <memset>
			return (*o)->o_fileid;
  8012c5:	8b 07                	mov    (%edi),%eax
  8012c7:	8b 00                	mov    (%eax),%eax
  8012c9:	83 c4 10             	add    $0x10,%esp
}
  8012cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cf:	5b                   	pop    %ebx
  8012d0:	5e                   	pop    %esi
  8012d1:	5f                   	pop    %edi
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    

008012d4 <openfile_lookup>:
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	57                   	push   %edi
  8012d8:	56                   	push   %esi
  8012d9:	53                   	push   %ebx
  8012da:	83 ec 18             	sub    $0x18,%esp
  8012dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  8012e0:	89 fb                	mov    %edi,%ebx
  8012e2:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8012e8:	89 de                	mov    %ebx,%esi
  8012ea:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012ed:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  8012f3:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012f9:	e8 82 1a 00 00       	call   802d80 <pageref>
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	83 f8 01             	cmp    $0x1,%eax
  801304:	7e 1d                	jle    801323 <openfile_lookup+0x4f>
  801306:	c1 e3 04             	shl    $0x4,%ebx
  801309:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  80130f:	75 19                	jne    80132a <openfile_lookup+0x56>
	*po = o;
  801311:	8b 45 10             	mov    0x10(%ebp),%eax
  801314:	89 30                	mov    %esi,(%eax)
	return 0;
  801316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131e:	5b                   	pop    %ebx
  80131f:	5e                   	pop    %esi
  801320:	5f                   	pop    %edi
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    
		return -E_INVAL;
  801323:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801328:	eb f1                	jmp    80131b <openfile_lookup+0x47>
  80132a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132f:	eb ea                	jmp    80131b <openfile_lookup+0x47>

00801331 <serve_set_size>:
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	53                   	push   %ebx
  801335:	83 ec 18             	sub    $0x18,%esp
  801338:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80133b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133e:	50                   	push   %eax
  80133f:	ff 33                	pushl  (%ebx)
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	e8 8b ff ff ff       	call   8012d4 <openfile_lookup>
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 14                	js     801364 <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801350:	83 ec 08             	sub    $0x8,%esp
  801353:	ff 73 04             	pushl  0x4(%ebx)
  801356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801359:	ff 70 04             	pushl  0x4(%eax)
  80135c:	e8 02 fb ff ff       	call   800e63 <file_set_size>
  801361:	83 c4 10             	add    $0x10,%esp
}
  801364:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801367:	c9                   	leave  
  801368:	c3                   	ret    

00801369 <serve_read>:
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	53                   	push   %ebx
  80136d:	83 ec 18             	sub    $0x18,%esp
  801370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801373:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801376:	50                   	push   %eax
  801377:	ff 33                	pushl  (%ebx)
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	e8 53 ff ff ff       	call   8012d4 <openfile_lookup>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	78 25                	js     8013ad <serve_read+0x44>
	if((r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  801388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138b:	8b 50 0c             	mov    0xc(%eax),%edx
  80138e:	ff 72 04             	pushl  0x4(%edx)
  801391:	ff 73 04             	pushl  0x4(%ebx)
  801394:	53                   	push   %ebx
  801395:	ff 70 04             	pushl  0x4(%eax)
  801398:	e8 1c fa ff ff       	call   800db9 <file_read>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	78 09                	js     8013ad <serve_read+0x44>
	o->o_fd->fd_offset += r;
  8013a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a7:	8b 52 0c             	mov    0xc(%edx),%edx
  8013aa:	01 42 04             	add    %eax,0x4(%edx)
}
  8013ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <serve_write>:
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	53                   	push   %ebx
  8013b6:	83 ec 18             	sub    $0x18,%esp
  8013b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	ff 33                	pushl  (%ebx)
  8013c2:	ff 75 08             	pushl  0x8(%ebp)
  8013c5:	e8 0a ff ff ff       	call   8012d4 <openfile_lookup>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 28                	js     8013f9 <serve_write+0x47>
	if((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  8013d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8013d7:	ff 72 04             	pushl  0x4(%edx)
  8013da:	ff 73 04             	pushl  0x4(%ebx)
  8013dd:	83 c3 08             	add    $0x8,%ebx
  8013e0:	53                   	push   %ebx
  8013e1:	ff 70 04             	pushl  0x4(%eax)
  8013e4:	e8 57 fb ff ff       	call   800f40 <file_write>
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 09                	js     8013f9 <serve_write+0x47>
	o->o_fd->fd_offset += r;
  8013f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f3:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f6:	01 42 04             	add    %eax,0x4(%edx)
}
  8013f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <serve_stat>:
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	53                   	push   %ebx
  801402:	83 ec 18             	sub    $0x18,%esp
  801405:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801408:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140b:	50                   	push   %eax
  80140c:	ff 33                	pushl  (%ebx)
  80140e:	ff 75 08             	pushl  0x8(%ebp)
  801411:	e8 be fe ff ff       	call   8012d4 <openfile_lookup>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 3f                	js     80145c <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801423:	ff 70 04             	pushl  0x4(%eax)
  801426:	53                   	push   %ebx
  801427:	e8 10 0f 00 00       	call   80233c <strcpy>
	ret->ret_size = o->o_file->f_size;
  80142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142f:	8b 50 04             	mov    0x4(%eax),%edx
  801432:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  801438:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80143e:	8b 40 04             	mov    0x4(%eax),%eax
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80144b:	0f 94 c0             	sete   %al
  80144e:	0f b6 c0             	movzbl %al,%eax
  801451:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <serve_flush>:
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801467:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146a:	50                   	push   %eax
  80146b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146e:	ff 30                	pushl  (%eax)
  801470:	ff 75 08             	pushl  0x8(%ebp)
  801473:	e8 5c fe ff ff       	call   8012d4 <openfile_lookup>
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 16                	js     801495 <serve_flush+0x34>
	file_flush(o->o_file);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801485:	ff 70 04             	pushl  0x4(%eax)
  801488:	e8 5b fb ff ff       	call   800fe8 <file_flush>
	return 0;
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <serve_open>:
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	53                   	push   %ebx
  80149b:	81 ec 18 04 00 00    	sub    $0x418,%esp
  8014a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  8014a4:	68 00 04 00 00       	push   $0x400
  8014a9:	53                   	push   %ebx
  8014aa:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014b0:	50                   	push   %eax
  8014b1:	e8 14 10 00 00       	call   8024ca <memmove>
	path[MAXPATHLEN-1] = 0;
  8014b6:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  8014ba:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8014c0:	89 04 24             	mov    %eax,(%esp)
  8014c3:	e8 73 fd ff ff       	call   80123b <openfile_alloc>
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	0f 88 f0 00 00 00    	js     8015c3 <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  8014d3:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8014da:	74 33                	je     80150f <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  8014dc:	83 ec 08             	sub    $0x8,%esp
  8014df:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014ec:	50                   	push   %eax
  8014ed:	e8 97 fb ff ff       	call   801089 <file_create>
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	79 37                	jns    801530 <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8014f9:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801500:	0f 85 bd 00 00 00    	jne    8015c3 <serve_open+0x12c>
  801506:	83 f8 f3             	cmp    $0xfffffff3,%eax
  801509:	0f 85 b4 00 00 00    	jne    8015c3 <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801518:	50                   	push   %eax
  801519:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80151f:	50                   	push   %eax
  801520:	e8 7a f8 ff ff       	call   800d9f <file_open>
  801525:	83 c4 10             	add    $0x10,%esp
  801528:	85 c0                	test   %eax,%eax
  80152a:	0f 88 93 00 00 00    	js     8015c3 <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  801530:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  801537:	74 17                	je     801550 <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  801539:	83 ec 08             	sub    $0x8,%esp
  80153c:	6a 00                	push   $0x0
  80153e:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  801544:	e8 1a f9 ff ff       	call   800e63 <file_set_size>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 73                	js     8015c3 <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801559:	50                   	push   %eax
  80155a:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801560:	50                   	push   %eax
  801561:	e8 39 f8 ff ff       	call   800d9f <file_open>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	85 c0                	test   %eax,%eax
  80156b:	78 56                	js     8015c3 <serve_open+0x12c>
	o->o_file = f;
  80156d:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801573:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801579:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  80157c:	8b 50 0c             	mov    0xc(%eax),%edx
  80157f:	8b 08                	mov    (%eax),%ecx
  801581:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801584:	8b 48 0c             	mov    0xc(%eax),%ecx
  801587:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80158d:	83 e2 03             	and    $0x3,%edx
  801590:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801593:	8b 40 0c             	mov    0xc(%eax),%eax
  801596:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80159c:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  80159e:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015a4:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  8015aa:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  8015ad:	8b 50 0c             	mov    0xc(%eax),%edx
  8015b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b3:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8015b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b8:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	56                   	push   %esi
  8015cc:	53                   	push   %ebx
  8015cd:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8015d0:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8015d3:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8015d6:	e9 82 00 00 00       	jmp    80165d <serve+0x95>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  8015db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8015e2:	83 f8 01             	cmp    $0x1,%eax
  8015e5:	74 23                	je     80160a <serve+0x42>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  8015e7:	83 f8 08             	cmp    $0x8,%eax
  8015ea:	77 36                	ja     801622 <serve+0x5a>
  8015ec:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8015f3:	85 d2                	test   %edx,%edx
  8015f5:	74 2b                	je     801622 <serve+0x5a>
			r = handlers[req](whom, fsreq);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 35 44 50 80 00    	pushl  0x805044
  801600:	ff 75 f4             	pushl  -0xc(%ebp)
  801603:	ff d2                	call   *%edx
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	eb 31                	jmp    80163b <serve+0x73>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  80160a:	53                   	push   %ebx
  80160b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	ff 35 44 50 80 00    	pushl  0x805044
  801615:	ff 75 f4             	pushl  -0xc(%ebp)
  801618:	e8 7a fe ff ff       	call   801497 <serve_open>
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	eb 19                	jmp    80163b <serve+0x73>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  801622:	83 ec 04             	sub    $0x4,%esp
  801625:	ff 75 f4             	pushl  -0xc(%ebp)
  801628:	50                   	push   %eax
  801629:	68 a0 3d 80 00       	push   $0x803da0
  80162e:	e8 fb 05 00 00       	call   801c2e <cprintf>
  801633:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801636:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80163b:	ff 75 f0             	pushl  -0x10(%ebp)
  80163e:	ff 75 ec             	pushl  -0x14(%ebp)
  801641:	50                   	push   %eax
  801642:	ff 75 f4             	pushl  -0xc(%ebp)
  801645:	e8 4f 14 00 00       	call   802a99 <ipc_send>
		sys_page_unmap(0, fsreq);
  80164a:	83 c4 08             	add    $0x8,%esp
  80164d:	ff 35 44 50 80 00    	pushl  0x805044
  801653:	6a 00                	push   $0x0
  801655:	e8 59 11 00 00       	call   8027b3 <sys_page_unmap>
  80165a:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  80165d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	53                   	push   %ebx
  801668:	ff 35 44 50 80 00    	pushl  0x805044
  80166e:	56                   	push   %esi
  80166f:	e8 be 13 00 00       	call   802a32 <ipc_recv>
		if (!(perm & PTE_P)) {
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  80167b:	0f 85 5a ff ff ff    	jne    8015db <serve+0x13>
			cprintf("Invalid request from %08x: no argument page\n",
  801681:	83 ec 08             	sub    $0x8,%esp
  801684:	ff 75 f4             	pushl  -0xc(%ebp)
  801687:	68 70 3d 80 00       	push   $0x803d70
  80168c:	e8 9d 05 00 00       	call   801c2e <cprintf>
			continue; // just leave it hanging...
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	eb c7                	jmp    80165d <serve+0x95>

00801696 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80169c:	c7 05 60 90 80 00 c3 	movl   $0x803dc3,0x809060
  8016a3:	3d 80 00 
	cprintf("FS is running\n");
  8016a6:	68 c6 3d 80 00       	push   $0x803dc6
  8016ab:	e8 7e 05 00 00       	call   801c2e <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8016b0:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8016b5:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8016ba:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8016bc:	c7 04 24 d5 3d 80 00 	movl   $0x803dd5,(%esp)
  8016c3:	e8 66 05 00 00       	call   801c2e <cprintf>

	serve_init();
  8016c8:	e8 46 fb ff ff       	call   801213 <serve_init>
	fs_init();
  8016cd:	e8 d0 f3 ff ff       	call   800aa2 <fs_init>
        fs_test();
  8016d2:	e8 05 00 00 00       	call   8016dc <fs_test>
	serve();
  8016d7:	e8 ec fe ff ff       	call   8015c8 <serve>

008016dc <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	53                   	push   %ebx
  8016e0:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8016e3:	6a 07                	push   $0x7
  8016e5:	68 00 10 00 00       	push   $0x1000
  8016ea:	6a 00                	push   $0x0
  8016ec:	e8 3d 10 00 00       	call   80272e <sys_page_alloc>
  8016f1:	83 c4 10             	add    $0x10,%esp
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	0f 88 68 02 00 00    	js     801964 <fs_test+0x288>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	68 00 10 00 00       	push   $0x1000
  801704:	ff 35 04 a0 80 00    	pushl  0x80a004
  80170a:	68 00 10 00 00       	push   $0x1000
  80170f:	e8 b6 0d 00 00       	call   8024ca <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801714:	e8 9b f1 ff ff       	call   8008b4 <alloc_block>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	85 c0                	test   %eax,%eax
  80171e:	0f 88 52 02 00 00    	js     801976 <fs_test+0x29a>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801724:	8d 50 1f             	lea    0x1f(%eax),%edx
  801727:	0f 49 d0             	cmovns %eax,%edx
  80172a:	c1 fa 05             	sar    $0x5,%edx
  80172d:	89 c3                	mov    %eax,%ebx
  80172f:	c1 fb 1f             	sar    $0x1f,%ebx
  801732:	c1 eb 1b             	shr    $0x1b,%ebx
  801735:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  801738:	83 e1 1f             	and    $0x1f,%ecx
  80173b:	29 d9                	sub    %ebx,%ecx
  80173d:	b8 01 00 00 00       	mov    $0x1,%eax
  801742:	d3 e0                	shl    %cl,%eax
  801744:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  80174b:	0f 84 37 02 00 00    	je     801988 <fs_test+0x2ac>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801751:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  801757:	85 04 91             	test   %eax,(%ecx,%edx,4)
  80175a:	0f 85 3e 02 00 00    	jne    80199e <fs_test+0x2c2>
	cprintf("alloc_block is good\n");
  801760:	83 ec 0c             	sub    $0xc,%esp
  801763:	68 2c 3e 80 00       	push   $0x803e2c
  801768:	e8 c1 04 00 00       	call   801c2e <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  80176d:	83 c4 08             	add    $0x8,%esp
  801770:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801773:	50                   	push   %eax
  801774:	68 41 3e 80 00       	push   $0x803e41
  801779:	e8 21 f6 ff ff       	call   800d9f <file_open>
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801784:	74 08                	je     80178e <fs_test+0xb2>
  801786:	85 c0                	test   %eax,%eax
  801788:	0f 88 26 02 00 00    	js     8019b4 <fs_test+0x2d8>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  80178e:	85 c0                	test   %eax,%eax
  801790:	0f 84 30 02 00 00    	je     8019c6 <fs_test+0x2ea>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801796:	83 ec 08             	sub    $0x8,%esp
  801799:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179c:	50                   	push   %eax
  80179d:	68 65 3e 80 00       	push   $0x803e65
  8017a2:	e8 f8 f5 ff ff       	call   800d9f <file_open>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	0f 88 28 02 00 00    	js     8019da <fs_test+0x2fe>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	68 85 3e 80 00       	push   $0x803e85
  8017ba:	e8 6f 04 00 00       	call   801c2e <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8017bf:	83 c4 0c             	add    $0xc,%esp
  8017c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c5:	50                   	push   %eax
  8017c6:	6a 00                	push   $0x0
  8017c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017cb:	e8 31 f3 ff ff       	call   800b01 <file_get_block>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	0f 88 11 02 00 00    	js     8019ec <fs_test+0x310>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	68 cc 3f 80 00       	push   $0x803fcc
  8017e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e6:	e8 fc 0b 00 00       	call   8023e7 <strcmp>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	0f 85 08 02 00 00    	jne    8019fe <fs_test+0x322>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	68 ab 3e 80 00       	push   $0x803eab
  8017fe:	e8 2b 04 00 00       	call   801c2e <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801806:	0f b6 10             	movzbl (%eax),%edx
  801809:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80180b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180e:	c1 e8 0c             	shr    $0xc,%eax
  801811:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	a8 40                	test   $0x40,%al
  80181d:	0f 84 ef 01 00 00    	je     801a12 <fs_test+0x336>
	file_flush(f);
  801823:	83 ec 0c             	sub    $0xc,%esp
  801826:	ff 75 f4             	pushl  -0xc(%ebp)
  801829:	e8 ba f7 ff ff       	call   800fe8 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80182e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801831:	c1 e8 0c             	shr    $0xc,%eax
  801834:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	a8 40                	test   $0x40,%al
  801840:	0f 85 e2 01 00 00    	jne    801a28 <fs_test+0x34c>
	cprintf("file_flush is good\n");
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	68 df 3e 80 00       	push   $0x803edf
  80184e:	e8 db 03 00 00       	call   801c2e <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801853:	83 c4 08             	add    $0x8,%esp
  801856:	6a 00                	push   $0x0
  801858:	ff 75 f4             	pushl  -0xc(%ebp)
  80185b:	e8 03 f6 ff ff       	call   800e63 <file_set_size>
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	85 c0                	test   %eax,%eax
  801865:	0f 88 d3 01 00 00    	js     801a3e <fs_test+0x362>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  80186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186e:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801875:	0f 85 d5 01 00 00    	jne    801a50 <fs_test+0x374>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80187b:	c1 e8 0c             	shr    $0xc,%eax
  80187e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801885:	a8 40                	test   $0x40,%al
  801887:	0f 85 d9 01 00 00    	jne    801a66 <fs_test+0x38a>
	cprintf("file_truncate is good\n");
  80188d:	83 ec 0c             	sub    $0xc,%esp
  801890:	68 33 3f 80 00       	push   $0x803f33
  801895:	e8 94 03 00 00       	call   801c2e <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  80189a:	c7 04 24 cc 3f 80 00 	movl   $0x803fcc,(%esp)
  8018a1:	e8 5d 0a 00 00       	call   802303 <strlen>
  8018a6:	83 c4 08             	add    $0x8,%esp
  8018a9:	50                   	push   %eax
  8018aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ad:	e8 b1 f5 ff ff       	call   800e63 <file_set_size>
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	0f 88 bf 01 00 00    	js     801a7c <fs_test+0x3a0>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c0:	89 c2                	mov    %eax,%edx
  8018c2:	c1 ea 0c             	shr    $0xc,%edx
  8018c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018cc:	f6 c2 40             	test   $0x40,%dl
  8018cf:	0f 85 b9 01 00 00    	jne    801a8e <fs_test+0x3b2>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018d5:	83 ec 04             	sub    $0x4,%esp
  8018d8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8018db:	52                   	push   %edx
  8018dc:	6a 00                	push   $0x0
  8018de:	50                   	push   %eax
  8018df:	e8 1d f2 ff ff       	call   800b01 <file_get_block>
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	0f 88 b5 01 00 00    	js     801aa4 <fs_test+0x3c8>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  8018ef:	83 ec 08             	sub    $0x8,%esp
  8018f2:	68 cc 3f 80 00       	push   $0x803fcc
  8018f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8018fa:	e8 3d 0a 00 00       	call   80233c <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801902:	c1 e8 0c             	shr    $0xc,%eax
  801905:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	a8 40                	test   $0x40,%al
  801911:	0f 84 9f 01 00 00    	je     801ab6 <fs_test+0x3da>
	file_flush(f);
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	ff 75 f4             	pushl  -0xc(%ebp)
  80191d:	e8 c6 f6 ff ff       	call   800fe8 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801925:	c1 e8 0c             	shr    $0xc,%eax
  801928:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	a8 40                	test   $0x40,%al
  801934:	0f 85 92 01 00 00    	jne    801acc <fs_test+0x3f0>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193d:	c1 e8 0c             	shr    $0xc,%eax
  801940:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801947:	a8 40                	test   $0x40,%al
  801949:	0f 85 93 01 00 00    	jne    801ae2 <fs_test+0x406>
	cprintf("file rewrite is good\n");
  80194f:	83 ec 0c             	sub    $0xc,%esp
  801952:	68 73 3f 80 00       	push   $0x803f73
  801957:	e8 d2 02 00 00       	call   801c2e <cprintf>
}
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801962:	c9                   	leave  
  801963:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801964:	50                   	push   %eax
  801965:	68 e4 3d 80 00       	push   $0x803de4
  80196a:	6a 12                	push   $0x12
  80196c:	68 f7 3d 80 00       	push   $0x803df7
  801971:	e8 dd 01 00 00       	call   801b53 <_panic>
		panic("alloc_block: %e", r);
  801976:	50                   	push   %eax
  801977:	68 01 3e 80 00       	push   $0x803e01
  80197c:	6a 17                	push   $0x17
  80197e:	68 f7 3d 80 00       	push   $0x803df7
  801983:	e8 cb 01 00 00       	call   801b53 <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801988:	68 11 3e 80 00       	push   $0x803e11
  80198d:	68 9d 3a 80 00       	push   $0x803a9d
  801992:	6a 19                	push   $0x19
  801994:	68 f7 3d 80 00       	push   $0x803df7
  801999:	e8 b5 01 00 00       	call   801b53 <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  80199e:	68 8c 3f 80 00       	push   $0x803f8c
  8019a3:	68 9d 3a 80 00       	push   $0x803a9d
  8019a8:	6a 1b                	push   $0x1b
  8019aa:	68 f7 3d 80 00       	push   $0x803df7
  8019af:	e8 9f 01 00 00       	call   801b53 <_panic>
		panic("file_open /not-found: %e", r);
  8019b4:	50                   	push   %eax
  8019b5:	68 4c 3e 80 00       	push   $0x803e4c
  8019ba:	6a 1f                	push   $0x1f
  8019bc:	68 f7 3d 80 00       	push   $0x803df7
  8019c1:	e8 8d 01 00 00       	call   801b53 <_panic>
		panic("file_open /not-found succeeded!");
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	68 ac 3f 80 00       	push   $0x803fac
  8019ce:	6a 21                	push   $0x21
  8019d0:	68 f7 3d 80 00       	push   $0x803df7
  8019d5:	e8 79 01 00 00       	call   801b53 <_panic>
		panic("file_open /newmotd: %e", r);
  8019da:	50                   	push   %eax
  8019db:	68 6e 3e 80 00       	push   $0x803e6e
  8019e0:	6a 23                	push   $0x23
  8019e2:	68 f7 3d 80 00       	push   $0x803df7
  8019e7:	e8 67 01 00 00       	call   801b53 <_panic>
		panic("file_get_block: %e", r);
  8019ec:	50                   	push   %eax
  8019ed:	68 98 3e 80 00       	push   $0x803e98
  8019f2:	6a 27                	push   $0x27
  8019f4:	68 f7 3d 80 00       	push   $0x803df7
  8019f9:	e8 55 01 00 00       	call   801b53 <_panic>
		panic("file_get_block returned wrong data");
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	68 f4 3f 80 00       	push   $0x803ff4
  801a06:	6a 29                	push   $0x29
  801a08:	68 f7 3d 80 00       	push   $0x803df7
  801a0d:	e8 41 01 00 00       	call   801b53 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a12:	68 c4 3e 80 00       	push   $0x803ec4
  801a17:	68 9d 3a 80 00       	push   $0x803a9d
  801a1c:	6a 2d                	push   $0x2d
  801a1e:	68 f7 3d 80 00       	push   $0x803df7
  801a23:	e8 2b 01 00 00       	call   801b53 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a28:	68 c3 3e 80 00       	push   $0x803ec3
  801a2d:	68 9d 3a 80 00       	push   $0x803a9d
  801a32:	6a 2f                	push   $0x2f
  801a34:	68 f7 3d 80 00       	push   $0x803df7
  801a39:	e8 15 01 00 00       	call   801b53 <_panic>
		panic("file_set_size: %e", r);
  801a3e:	50                   	push   %eax
  801a3f:	68 f3 3e 80 00       	push   $0x803ef3
  801a44:	6a 33                	push   $0x33
  801a46:	68 f7 3d 80 00       	push   $0x803df7
  801a4b:	e8 03 01 00 00       	call   801b53 <_panic>
	assert(f->f_direct[0] == 0);
  801a50:	68 05 3f 80 00       	push   $0x803f05
  801a55:	68 9d 3a 80 00       	push   $0x803a9d
  801a5a:	6a 34                	push   $0x34
  801a5c:	68 f7 3d 80 00       	push   $0x803df7
  801a61:	e8 ed 00 00 00       	call   801b53 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a66:	68 19 3f 80 00       	push   $0x803f19
  801a6b:	68 9d 3a 80 00       	push   $0x803a9d
  801a70:	6a 35                	push   $0x35
  801a72:	68 f7 3d 80 00       	push   $0x803df7
  801a77:	e8 d7 00 00 00       	call   801b53 <_panic>
		panic("file_set_size 2: %e", r);
  801a7c:	50                   	push   %eax
  801a7d:	68 4a 3f 80 00       	push   $0x803f4a
  801a82:	6a 39                	push   $0x39
  801a84:	68 f7 3d 80 00       	push   $0x803df7
  801a89:	e8 c5 00 00 00       	call   801b53 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a8e:	68 19 3f 80 00       	push   $0x803f19
  801a93:	68 9d 3a 80 00       	push   $0x803a9d
  801a98:	6a 3a                	push   $0x3a
  801a9a:	68 f7 3d 80 00       	push   $0x803df7
  801a9f:	e8 af 00 00 00       	call   801b53 <_panic>
		panic("file_get_block 2: %e", r);
  801aa4:	50                   	push   %eax
  801aa5:	68 5e 3f 80 00       	push   $0x803f5e
  801aaa:	6a 3c                	push   $0x3c
  801aac:	68 f7 3d 80 00       	push   $0x803df7
  801ab1:	e8 9d 00 00 00       	call   801b53 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801ab6:	68 c4 3e 80 00       	push   $0x803ec4
  801abb:	68 9d 3a 80 00       	push   $0x803a9d
  801ac0:	6a 3e                	push   $0x3e
  801ac2:	68 f7 3d 80 00       	push   $0x803df7
  801ac7:	e8 87 00 00 00       	call   801b53 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801acc:	68 c3 3e 80 00       	push   $0x803ec3
  801ad1:	68 9d 3a 80 00       	push   $0x803a9d
  801ad6:	6a 40                	push   $0x40
  801ad8:	68 f7 3d 80 00       	push   $0x803df7
  801add:	e8 71 00 00 00       	call   801b53 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801ae2:	68 19 3f 80 00       	push   $0x803f19
  801ae7:	68 9d 3a 80 00       	push   $0x803a9d
  801aec:	6a 41                	push   $0x41
  801aee:	68 f7 3d 80 00       	push   $0x803df7
  801af3:	e8 5b 00 00 00       	call   801b53 <_panic>

00801af8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	56                   	push   %esi
  801afc:	53                   	push   %ebx
  801afd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b00:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801b03:	e8 e8 0b 00 00       	call   8026f0 <sys_getenvid>
  801b08:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b0d:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  801b10:	c1 e0 04             	shl    $0x4,%eax
  801b13:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b18:	a3 0c a0 80 00       	mov    %eax,0x80a00c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801b1d:	85 db                	test   %ebx,%ebx
  801b1f:	7e 07                	jle    801b28 <libmain+0x30>
		binaryname = argv[0];
  801b21:	8b 06                	mov    (%esi),%eax
  801b23:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	56                   	push   %esi
  801b2c:	53                   	push   %ebx
  801b2d:	e8 64 fb ff ff       	call   801696 <umain>

	// exit gracefully
	exit();
  801b32:	e8 0a 00 00 00       	call   801b41 <exit>
}
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    

00801b41 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  801b47:	6a 00                	push   $0x0
  801b49:	e8 61 0b 00 00       	call   8026af <sys_env_destroy>
}
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b58:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b5b:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801b61:	e8 8a 0b 00 00       	call   8026f0 <sys_getenvid>
  801b66:	83 ec 0c             	sub    $0xc,%esp
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	ff 75 08             	pushl  0x8(%ebp)
  801b6f:	56                   	push   %esi
  801b70:	50                   	push   %eax
  801b71:	68 24 40 80 00       	push   $0x804024
  801b76:	e8 b3 00 00 00       	call   801c2e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b7b:	83 c4 18             	add    $0x18,%esp
  801b7e:	53                   	push   %ebx
  801b7f:	ff 75 10             	pushl  0x10(%ebp)
  801b82:	e8 56 00 00 00       	call   801bdd <vcprintf>
	cprintf("\n");
  801b87:	c7 04 24 33 3c 80 00 	movl   $0x803c33,(%esp)
  801b8e:	e8 9b 00 00 00       	call   801c2e <cprintf>
  801b93:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b96:	cc                   	int3   
  801b97:	eb fd                	jmp    801b96 <_panic+0x43>

00801b99 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	53                   	push   %ebx
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801ba3:	8b 13                	mov    (%ebx),%edx
  801ba5:	8d 42 01             	lea    0x1(%edx),%eax
  801ba8:	89 03                	mov    %eax,(%ebx)
  801baa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bad:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801bb1:	3d ff 00 00 00       	cmp    $0xff,%eax
  801bb6:	74 09                	je     801bc1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801bb8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801bbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801bc1:	83 ec 08             	sub    $0x8,%esp
  801bc4:	68 ff 00 00 00       	push   $0xff
  801bc9:	8d 43 08             	lea    0x8(%ebx),%eax
  801bcc:	50                   	push   %eax
  801bcd:	e8 a0 0a 00 00       	call   802672 <sys_cputs>
		b->idx = 0;
  801bd2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	eb db                	jmp    801bb8 <putch+0x1f>

00801bdd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801be6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bed:	00 00 00 
	b.cnt = 0;
  801bf0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801bf7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	ff 75 08             	pushl  0x8(%ebp)
  801c00:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c06:	50                   	push   %eax
  801c07:	68 99 1b 80 00       	push   $0x801b99
  801c0c:	e8 4a 01 00 00       	call   801d5b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801c11:	83 c4 08             	add    $0x8,%esp
  801c14:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801c1a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801c20:	50                   	push   %eax
  801c21:	e8 4c 0a 00 00       	call   802672 <sys_cputs>

	return b.cnt;
}
  801c26:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c34:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801c37:	50                   	push   %eax
  801c38:	ff 75 08             	pushl  0x8(%ebp)
  801c3b:	e8 9d ff ff ff       	call   801bdd <vcprintf>
	va_end(ap);

	return cnt;
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	57                   	push   %edi
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
  801c48:	83 ec 1c             	sub    $0x1c,%esp
  801c4b:	89 c6                	mov    %eax,%esi
  801c4d:	89 d7                	mov    %edx,%edi
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c58:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  801c61:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  801c65:	74 2c                	je     801c93 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c74:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801c77:	39 c2                	cmp    %eax,%edx
  801c79:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  801c7c:	73 43                	jae    801cc1 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801c7e:	83 eb 01             	sub    $0x1,%ebx
  801c81:	85 db                	test   %ebx,%ebx
  801c83:	7e 6c                	jle    801cf1 <printnum+0xaf>
			putch(padc, putdat);
  801c85:	83 ec 08             	sub    $0x8,%esp
  801c88:	57                   	push   %edi
  801c89:	ff 75 18             	pushl  0x18(%ebp)
  801c8c:	ff d6                	call   *%esi
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	eb eb                	jmp    801c7e <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  801c93:	83 ec 0c             	sub    $0xc,%esp
  801c96:	6a 20                	push   $0x20
  801c98:	6a 00                	push   $0x0
  801c9a:	50                   	push   %eax
  801c9b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c9e:	ff 75 e0             	pushl  -0x20(%ebp)
  801ca1:	89 fa                	mov    %edi,%edx
  801ca3:	89 f0                	mov    %esi,%eax
  801ca5:	e8 98 ff ff ff       	call   801c42 <printnum>
		while (--width > 0)
  801caa:	83 c4 20             	add    $0x20,%esp
  801cad:	83 eb 01             	sub    $0x1,%ebx
  801cb0:	85 db                	test   %ebx,%ebx
  801cb2:	7e 65                	jle    801d19 <printnum+0xd7>
			putch(padc, putdat);
  801cb4:	83 ec 08             	sub    $0x8,%esp
  801cb7:	57                   	push   %edi
  801cb8:	6a 20                	push   $0x20
  801cba:	ff d6                	call   *%esi
  801cbc:	83 c4 10             	add    $0x10,%esp
  801cbf:	eb ec                	jmp    801cad <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	ff 75 18             	pushl  0x18(%ebp)
  801cc7:	83 eb 01             	sub    $0x1,%ebx
  801cca:	53                   	push   %ebx
  801ccb:	50                   	push   %eax
  801ccc:	83 ec 08             	sub    $0x8,%esp
  801ccf:	ff 75 dc             	pushl  -0x24(%ebp)
  801cd2:	ff 75 d8             	pushl  -0x28(%ebp)
  801cd5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cd8:	ff 75 e0             	pushl  -0x20(%ebp)
  801cdb:	e8 30 1b 00 00       	call   803810 <__udivdi3>
  801ce0:	83 c4 18             	add    $0x18,%esp
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	89 fa                	mov    %edi,%edx
  801ce7:	89 f0                	mov    %esi,%eax
  801ce9:	e8 54 ff ff ff       	call   801c42 <printnum>
  801cee:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cf1:	83 ec 08             	sub    $0x8,%esp
  801cf4:	57                   	push   %edi
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	ff 75 dc             	pushl  -0x24(%ebp)
  801cfb:	ff 75 d8             	pushl  -0x28(%ebp)
  801cfe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d01:	ff 75 e0             	pushl  -0x20(%ebp)
  801d04:	e8 17 1c 00 00       	call   803920 <__umoddi3>
  801d09:	83 c4 14             	add    $0x14,%esp
  801d0c:	0f be 80 47 40 80 00 	movsbl 0x804047(%eax),%eax
  801d13:	50                   	push   %eax
  801d14:	ff d6                	call   *%esi
  801d16:	83 c4 10             	add    $0x10,%esp
}
  801d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5f                   	pop    %edi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801d27:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801d2b:	8b 10                	mov    (%eax),%edx
  801d2d:	3b 50 04             	cmp    0x4(%eax),%edx
  801d30:	73 0a                	jae    801d3c <sprintputch+0x1b>
		*b->buf++ = ch;
  801d32:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d35:	89 08                	mov    %ecx,(%eax)
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	88 02                	mov    %al,(%edx)
}
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    

00801d3e <printfmt>:
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801d44:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801d47:	50                   	push   %eax
  801d48:	ff 75 10             	pushl  0x10(%ebp)
  801d4b:	ff 75 0c             	pushl  0xc(%ebp)
  801d4e:	ff 75 08             	pushl  0x8(%ebp)
  801d51:	e8 05 00 00 00       	call   801d5b <vprintfmt>
}
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <vprintfmt>:
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	57                   	push   %edi
  801d5f:	56                   	push   %esi
  801d60:	53                   	push   %ebx
  801d61:	83 ec 3c             	sub    $0x3c,%esp
  801d64:	8b 75 08             	mov    0x8(%ebp),%esi
  801d67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d6a:	8b 7d 10             	mov    0x10(%ebp),%edi
  801d6d:	e9 b4 03 00 00       	jmp    802126 <vprintfmt+0x3cb>
		padc = ' ';
  801d72:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  801d76:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  801d7d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801d84:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801d8b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d92:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801d97:	8d 47 01             	lea    0x1(%edi),%eax
  801d9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d9d:	0f b6 17             	movzbl (%edi),%edx
  801da0:	8d 42 dd             	lea    -0x23(%edx),%eax
  801da3:	3c 55                	cmp    $0x55,%al
  801da5:	0f 87 c8 04 00 00    	ja     802273 <vprintfmt+0x518>
  801dab:	0f b6 c0             	movzbl %al,%eax
  801dae:	ff 24 85 20 42 80 00 	jmp    *0x804220(,%eax,4)
  801db5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  801db8:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  801dbf:	eb d6                	jmp    801d97 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  801dc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801dc4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801dc8:	eb cd                	jmp    801d97 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  801dca:	0f b6 d2             	movzbl %dl,%edx
  801dcd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  801dd8:	eb 0c                	jmp    801de6 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  801dda:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801ddd:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  801de1:	eb b4                	jmp    801d97 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  801de3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801de6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801de9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801ded:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801df0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801df3:	83 f9 09             	cmp    $0x9,%ecx
  801df6:	76 eb                	jbe    801de3 <vprintfmt+0x88>
  801df8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801dfb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801dfe:	eb 14                	jmp    801e14 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  801e00:	8b 45 14             	mov    0x14(%ebp),%eax
  801e03:	8b 00                	mov    (%eax),%eax
  801e05:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e08:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0b:	8d 40 04             	lea    0x4(%eax),%eax
  801e0e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801e11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801e14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e18:	0f 89 79 ff ff ff    	jns    801d97 <vprintfmt+0x3c>
				width = precision, precision = -1;
  801e1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e24:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801e2b:	e9 67 ff ff ff       	jmp    801d97 <vprintfmt+0x3c>
  801e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3a:	0f 49 d0             	cmovns %eax,%edx
  801e3d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801e40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801e43:	e9 4f ff ff ff       	jmp    801d97 <vprintfmt+0x3c>
  801e48:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801e4b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801e52:	e9 40 ff ff ff       	jmp    801d97 <vprintfmt+0x3c>
			lflag++;
  801e57:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801e5a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801e5d:	e9 35 ff ff ff       	jmp    801d97 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  801e62:	8b 45 14             	mov    0x14(%ebp),%eax
  801e65:	8d 78 04             	lea    0x4(%eax),%edi
  801e68:	83 ec 08             	sub    $0x8,%esp
  801e6b:	53                   	push   %ebx
  801e6c:	ff 30                	pushl  (%eax)
  801e6e:	ff d6                	call   *%esi
			break;
  801e70:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801e73:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801e76:	e9 a8 02 00 00       	jmp    802123 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  801e7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e7e:	8d 78 04             	lea    0x4(%eax),%edi
  801e81:	8b 00                	mov    (%eax),%eax
  801e83:	99                   	cltd   
  801e84:	31 d0                	xor    %edx,%eax
  801e86:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801e88:	83 f8 0f             	cmp    $0xf,%eax
  801e8b:	7f 23                	jg     801eb0 <vprintfmt+0x155>
  801e8d:	8b 14 85 80 43 80 00 	mov    0x804380(,%eax,4),%edx
  801e94:	85 d2                	test   %edx,%edx
  801e96:	74 18                	je     801eb0 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  801e98:	52                   	push   %edx
  801e99:	68 af 3a 80 00       	push   $0x803aaf
  801e9e:	53                   	push   %ebx
  801e9f:	56                   	push   %esi
  801ea0:	e8 99 fe ff ff       	call   801d3e <printfmt>
  801ea5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801ea8:	89 7d 14             	mov    %edi,0x14(%ebp)
  801eab:	e9 73 02 00 00       	jmp    802123 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  801eb0:	50                   	push   %eax
  801eb1:	68 5f 40 80 00       	push   $0x80405f
  801eb6:	53                   	push   %ebx
  801eb7:	56                   	push   %esi
  801eb8:	e8 81 fe ff ff       	call   801d3e <printfmt>
  801ebd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801ec0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801ec3:	e9 5b 02 00 00       	jmp    802123 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  801ec8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecb:	83 c0 04             	add    $0x4,%eax
  801ece:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801ed1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801ed6:	85 d2                	test   %edx,%edx
  801ed8:	b8 58 40 80 00       	mov    $0x804058,%eax
  801edd:	0f 45 c2             	cmovne %edx,%eax
  801ee0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801ee3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ee7:	7e 06                	jle    801eef <vprintfmt+0x194>
  801ee9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801eed:	75 0d                	jne    801efc <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  801eef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ef2:	89 c7                	mov    %eax,%edi
  801ef4:	03 45 e0             	add    -0x20(%ebp),%eax
  801ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801efa:	eb 53                	jmp    801f4f <vprintfmt+0x1f4>
  801efc:	83 ec 08             	sub    $0x8,%esp
  801eff:	ff 75 d8             	pushl  -0x28(%ebp)
  801f02:	50                   	push   %eax
  801f03:	e8 13 04 00 00       	call   80231b <strnlen>
  801f08:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801f0b:	29 c1                	sub    %eax,%ecx
  801f0d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  801f15:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801f19:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801f1c:	eb 0f                	jmp    801f2d <vprintfmt+0x1d2>
					putch(padc, putdat);
  801f1e:	83 ec 08             	sub    $0x8,%esp
  801f21:	53                   	push   %ebx
  801f22:	ff 75 e0             	pushl  -0x20(%ebp)
  801f25:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801f27:	83 ef 01             	sub    $0x1,%edi
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	85 ff                	test   %edi,%edi
  801f2f:	7f ed                	jg     801f1e <vprintfmt+0x1c3>
  801f31:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801f34:	85 d2                	test   %edx,%edx
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3b:	0f 49 c2             	cmovns %edx,%eax
  801f3e:	29 c2                	sub    %eax,%edx
  801f40:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801f43:	eb aa                	jmp    801eef <vprintfmt+0x194>
					putch(ch, putdat);
  801f45:	83 ec 08             	sub    $0x8,%esp
  801f48:	53                   	push   %ebx
  801f49:	52                   	push   %edx
  801f4a:	ff d6                	call   *%esi
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801f52:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f54:	83 c7 01             	add    $0x1,%edi
  801f57:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801f5b:	0f be d0             	movsbl %al,%edx
  801f5e:	85 d2                	test   %edx,%edx
  801f60:	74 4b                	je     801fad <vprintfmt+0x252>
  801f62:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f66:	78 06                	js     801f6e <vprintfmt+0x213>
  801f68:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801f6c:	78 1e                	js     801f8c <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  801f6e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801f72:	74 d1                	je     801f45 <vprintfmt+0x1ea>
  801f74:	0f be c0             	movsbl %al,%eax
  801f77:	83 e8 20             	sub    $0x20,%eax
  801f7a:	83 f8 5e             	cmp    $0x5e,%eax
  801f7d:	76 c6                	jbe    801f45 <vprintfmt+0x1ea>
					putch('?', putdat);
  801f7f:	83 ec 08             	sub    $0x8,%esp
  801f82:	53                   	push   %ebx
  801f83:	6a 3f                	push   $0x3f
  801f85:	ff d6                	call   *%esi
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	eb c3                	jmp    801f4f <vprintfmt+0x1f4>
  801f8c:	89 cf                	mov    %ecx,%edi
  801f8e:	eb 0e                	jmp    801f9e <vprintfmt+0x243>
				putch(' ', putdat);
  801f90:	83 ec 08             	sub    $0x8,%esp
  801f93:	53                   	push   %ebx
  801f94:	6a 20                	push   $0x20
  801f96:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801f98:	83 ef 01             	sub    $0x1,%edi
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	85 ff                	test   %edi,%edi
  801fa0:	7f ee                	jg     801f90 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  801fa2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fa5:	89 45 14             	mov    %eax,0x14(%ebp)
  801fa8:	e9 76 01 00 00       	jmp    802123 <vprintfmt+0x3c8>
  801fad:	89 cf                	mov    %ecx,%edi
  801faf:	eb ed                	jmp    801f9e <vprintfmt+0x243>
	if (lflag >= 2)
  801fb1:	83 f9 01             	cmp    $0x1,%ecx
  801fb4:	7f 1f                	jg     801fd5 <vprintfmt+0x27a>
	else if (lflag)
  801fb6:	85 c9                	test   %ecx,%ecx
  801fb8:	74 6a                	je     802024 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801fba:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fc2:	89 c1                	mov    %eax,%ecx
  801fc4:	c1 f9 1f             	sar    $0x1f,%ecx
  801fc7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801fca:	8b 45 14             	mov    0x14(%ebp),%eax
  801fcd:	8d 40 04             	lea    0x4(%eax),%eax
  801fd0:	89 45 14             	mov    %eax,0x14(%ebp)
  801fd3:	eb 17                	jmp    801fec <vprintfmt+0x291>
		return va_arg(*ap, long long);
  801fd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd8:	8b 50 04             	mov    0x4(%eax),%edx
  801fdb:	8b 00                	mov    (%eax),%eax
  801fdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fe0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801fe3:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe6:	8d 40 08             	lea    0x8(%eax),%eax
  801fe9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801fec:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  801fef:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  801ff4:	85 d2                	test   %edx,%edx
  801ff6:	0f 89 f8 00 00 00    	jns    8020f4 <vprintfmt+0x399>
				putch('-', putdat);
  801ffc:	83 ec 08             	sub    $0x8,%esp
  801fff:	53                   	push   %ebx
  802000:	6a 2d                	push   $0x2d
  802002:	ff d6                	call   *%esi
				num = -(long long) num;
  802004:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802007:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80200a:	f7 d8                	neg    %eax
  80200c:	83 d2 00             	adc    $0x0,%edx
  80200f:	f7 da                	neg    %edx
  802011:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802014:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802017:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80201a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80201f:	e9 e1 00 00 00       	jmp    802105 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  802024:	8b 45 14             	mov    0x14(%ebp),%eax
  802027:	8b 00                	mov    (%eax),%eax
  802029:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80202c:	99                   	cltd   
  80202d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802030:	8b 45 14             	mov    0x14(%ebp),%eax
  802033:	8d 40 04             	lea    0x4(%eax),%eax
  802036:	89 45 14             	mov    %eax,0x14(%ebp)
  802039:	eb b1                	jmp    801fec <vprintfmt+0x291>
	if (lflag >= 2)
  80203b:	83 f9 01             	cmp    $0x1,%ecx
  80203e:	7f 27                	jg     802067 <vprintfmt+0x30c>
	else if (lflag)
  802040:	85 c9                	test   %ecx,%ecx
  802042:	74 41                	je     802085 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  802044:	8b 45 14             	mov    0x14(%ebp),%eax
  802047:	8b 00                	mov    (%eax),%eax
  802049:	ba 00 00 00 00       	mov    $0x0,%edx
  80204e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802051:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802054:	8b 45 14             	mov    0x14(%ebp),%eax
  802057:	8d 40 04             	lea    0x4(%eax),%eax
  80205a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80205d:	bf 0a 00 00 00       	mov    $0xa,%edi
  802062:	e9 8d 00 00 00       	jmp    8020f4 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  802067:	8b 45 14             	mov    0x14(%ebp),%eax
  80206a:	8b 50 04             	mov    0x4(%eax),%edx
  80206d:	8b 00                	mov    (%eax),%eax
  80206f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802072:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802075:	8b 45 14             	mov    0x14(%ebp),%eax
  802078:	8d 40 08             	lea    0x8(%eax),%eax
  80207b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80207e:	bf 0a 00 00 00       	mov    $0xa,%edi
  802083:	eb 6f                	jmp    8020f4 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  802085:	8b 45 14             	mov    0x14(%ebp),%eax
  802088:	8b 00                	mov    (%eax),%eax
  80208a:	ba 00 00 00 00       	mov    $0x0,%edx
  80208f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802092:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802095:	8b 45 14             	mov    0x14(%ebp),%eax
  802098:	8d 40 04             	lea    0x4(%eax),%eax
  80209b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80209e:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020a3:	eb 4f                	jmp    8020f4 <vprintfmt+0x399>
	if (lflag >= 2)
  8020a5:	83 f9 01             	cmp    $0x1,%ecx
  8020a8:	7f 23                	jg     8020cd <vprintfmt+0x372>
	else if (lflag)
  8020aa:	85 c9                	test   %ecx,%ecx
  8020ac:	0f 84 98 00 00 00    	je     80214a <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8020b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b5:	8b 00                	mov    (%eax),%eax
  8020b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8020bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8020c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c5:	8d 40 04             	lea    0x4(%eax),%eax
  8020c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8020cb:	eb 17                	jmp    8020e4 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8020cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d0:	8b 50 04             	mov    0x4(%eax),%edx
  8020d3:	8b 00                	mov    (%eax),%eax
  8020d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8020d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8020db:	8b 45 14             	mov    0x14(%ebp),%eax
  8020de:	8d 40 08             	lea    0x8(%eax),%eax
  8020e1:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8020e4:	83 ec 08             	sub    $0x8,%esp
  8020e7:	53                   	push   %ebx
  8020e8:	6a 30                	push   $0x30
  8020ea:	ff d6                	call   *%esi
			goto number;
  8020ec:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8020ef:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  8020f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8020f8:	74 0b                	je     802105 <vprintfmt+0x3aa>
				putch('+', putdat);
  8020fa:	83 ec 08             	sub    $0x8,%esp
  8020fd:	53                   	push   %ebx
  8020fe:	6a 2b                	push   $0x2b
  802100:	ff d6                	call   *%esi
  802102:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80210c:	50                   	push   %eax
  80210d:	ff 75 e0             	pushl  -0x20(%ebp)
  802110:	57                   	push   %edi
  802111:	ff 75 dc             	pushl  -0x24(%ebp)
  802114:	ff 75 d8             	pushl  -0x28(%ebp)
  802117:	89 da                	mov    %ebx,%edx
  802119:	89 f0                	mov    %esi,%eax
  80211b:	e8 22 fb ff ff       	call   801c42 <printnum>
			break;
  802120:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  802123:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802126:	83 c7 01             	add    $0x1,%edi
  802129:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80212d:	83 f8 25             	cmp    $0x25,%eax
  802130:	0f 84 3c fc ff ff    	je     801d72 <vprintfmt+0x17>
			if (ch == '\0')
  802136:	85 c0                	test   %eax,%eax
  802138:	0f 84 55 01 00 00    	je     802293 <vprintfmt+0x538>
			putch(ch, putdat);
  80213e:	83 ec 08             	sub    $0x8,%esp
  802141:	53                   	push   %ebx
  802142:	50                   	push   %eax
  802143:	ff d6                	call   *%esi
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	eb dc                	jmp    802126 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80214a:	8b 45 14             	mov    0x14(%ebp),%eax
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	ba 00 00 00 00       	mov    $0x0,%edx
  802154:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802157:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80215a:	8b 45 14             	mov    0x14(%ebp),%eax
  80215d:	8d 40 04             	lea    0x4(%eax),%eax
  802160:	89 45 14             	mov    %eax,0x14(%ebp)
  802163:	e9 7c ff ff ff       	jmp    8020e4 <vprintfmt+0x389>
			putch('0', putdat);
  802168:	83 ec 08             	sub    $0x8,%esp
  80216b:	53                   	push   %ebx
  80216c:	6a 30                	push   $0x30
  80216e:	ff d6                	call   *%esi
			putch('x', putdat);
  802170:	83 c4 08             	add    $0x8,%esp
  802173:	53                   	push   %ebx
  802174:	6a 78                	push   $0x78
  802176:	ff d6                	call   *%esi
			num = (unsigned long long)
  802178:	8b 45 14             	mov    0x14(%ebp),%eax
  80217b:	8b 00                	mov    (%eax),%eax
  80217d:	ba 00 00 00 00       	mov    $0x0,%edx
  802182:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802185:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  802188:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80218b:	8b 45 14             	mov    0x14(%ebp),%eax
  80218e:	8d 40 04             	lea    0x4(%eax),%eax
  802191:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802194:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  802199:	e9 56 ff ff ff       	jmp    8020f4 <vprintfmt+0x399>
	if (lflag >= 2)
  80219e:	83 f9 01             	cmp    $0x1,%ecx
  8021a1:	7f 27                	jg     8021ca <vprintfmt+0x46f>
	else if (lflag)
  8021a3:	85 c9                	test   %ecx,%ecx
  8021a5:	74 44                	je     8021eb <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8021a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021aa:	8b 00                	mov    (%eax),%eax
  8021ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8021b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ba:	8d 40 04             	lea    0x4(%eax),%eax
  8021bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021c0:	bf 10 00 00 00       	mov    $0x10,%edi
  8021c5:	e9 2a ff ff ff       	jmp    8020f4 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8021ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8021cd:	8b 50 04             	mov    0x4(%eax),%edx
  8021d0:	8b 00                	mov    (%eax),%eax
  8021d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8021d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021db:	8d 40 08             	lea    0x8(%eax),%eax
  8021de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021e1:	bf 10 00 00 00       	mov    $0x10,%edi
  8021e6:	e9 09 ff ff ff       	jmp    8020f4 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8021eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8021fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fe:	8d 40 04             	lea    0x4(%eax),%eax
  802201:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802204:	bf 10 00 00 00       	mov    $0x10,%edi
  802209:	e9 e6 fe ff ff       	jmp    8020f4 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80220e:	8b 45 14             	mov    0x14(%ebp),%eax
  802211:	8d 78 04             	lea    0x4(%eax),%edi
  802214:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  802216:	85 c0                	test   %eax,%eax
  802218:	74 2d                	je     802247 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  80221a:	0f b6 13             	movzbl (%ebx),%edx
  80221d:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80221f:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  802222:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  802225:	0f 8e f8 fe ff ff    	jle    802123 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80222b:	68 b4 41 80 00       	push   $0x8041b4
  802230:	68 af 3a 80 00       	push   $0x803aaf
  802235:	53                   	push   %ebx
  802236:	56                   	push   %esi
  802237:	e8 02 fb ff ff       	call   801d3e <printfmt>
  80223c:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80223f:	89 7d 14             	mov    %edi,0x14(%ebp)
  802242:	e9 dc fe ff ff       	jmp    802123 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  802247:	68 7c 41 80 00       	push   $0x80417c
  80224c:	68 af 3a 80 00       	push   $0x803aaf
  802251:	53                   	push   %ebx
  802252:	56                   	push   %esi
  802253:	e8 e6 fa ff ff       	call   801d3e <printfmt>
  802258:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80225b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80225e:	e9 c0 fe ff ff       	jmp    802123 <vprintfmt+0x3c8>
			putch(ch, putdat);
  802263:	83 ec 08             	sub    $0x8,%esp
  802266:	53                   	push   %ebx
  802267:	6a 25                	push   $0x25
  802269:	ff d6                	call   *%esi
			break;
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	e9 b0 fe ff ff       	jmp    802123 <vprintfmt+0x3c8>
			putch('%', putdat);
  802273:	83 ec 08             	sub    $0x8,%esp
  802276:	53                   	push   %ebx
  802277:	6a 25                	push   $0x25
  802279:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	89 f8                	mov    %edi,%eax
  802280:	eb 03                	jmp    802285 <vprintfmt+0x52a>
  802282:	83 e8 01             	sub    $0x1,%eax
  802285:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802289:	75 f7                	jne    802282 <vprintfmt+0x527>
  80228b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80228e:	e9 90 fe ff ff       	jmp    802123 <vprintfmt+0x3c8>
}
  802293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802296:	5b                   	pop    %ebx
  802297:	5e                   	pop    %esi
  802298:	5f                   	pop    %edi
  802299:	5d                   	pop    %ebp
  80229a:	c3                   	ret    

0080229b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 18             	sub    $0x18,%esp
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8022a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8022aa:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8022ae:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8022b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	74 26                	je     8022e2 <vsnprintf+0x47>
  8022bc:	85 d2                	test   %edx,%edx
  8022be:	7e 22                	jle    8022e2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8022c0:	ff 75 14             	pushl  0x14(%ebp)
  8022c3:	ff 75 10             	pushl  0x10(%ebp)
  8022c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022c9:	50                   	push   %eax
  8022ca:	68 21 1d 80 00       	push   $0x801d21
  8022cf:	e8 87 fa ff ff       	call   801d5b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8022d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	83 c4 10             	add    $0x10,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    
		return -E_INVAL;
  8022e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022e7:	eb f7                	jmp    8022e0 <vsnprintf+0x45>

008022e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8022ef:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8022f2:	50                   	push   %eax
  8022f3:	ff 75 10             	pushl  0x10(%ebp)
  8022f6:	ff 75 0c             	pushl  0xc(%ebp)
  8022f9:	ff 75 08             	pushl  0x8(%ebp)
  8022fc:	e8 9a ff ff ff       	call   80229b <vsnprintf>
	va_end(ap);

	return rc;
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802309:	b8 00 00 00 00       	mov    $0x0,%eax
  80230e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802312:	74 05                	je     802319 <strlen+0x16>
		n++;
  802314:	83 c0 01             	add    $0x1,%eax
  802317:	eb f5                	jmp    80230e <strlen+0xb>
	return n;
}
  802319:	5d                   	pop    %ebp
  80231a:	c3                   	ret    

0080231b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802321:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802324:	ba 00 00 00 00       	mov    $0x0,%edx
  802329:	39 c2                	cmp    %eax,%edx
  80232b:	74 0d                	je     80233a <strnlen+0x1f>
  80232d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  802331:	74 05                	je     802338 <strnlen+0x1d>
		n++;
  802333:	83 c2 01             	add    $0x1,%edx
  802336:	eb f1                	jmp    802329 <strnlen+0xe>
  802338:	89 d0                	mov    %edx,%eax
	return n;
}
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    

0080233c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	53                   	push   %ebx
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802346:	ba 00 00 00 00       	mov    $0x0,%edx
  80234b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80234f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  802352:	83 c2 01             	add    $0x1,%edx
  802355:	84 c9                	test   %cl,%cl
  802357:	75 f2                	jne    80234b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  802359:	5b                   	pop    %ebx
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    

0080235c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	53                   	push   %ebx
  802360:	83 ec 10             	sub    $0x10,%esp
  802363:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802366:	53                   	push   %ebx
  802367:	e8 97 ff ff ff       	call   802303 <strlen>
  80236c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80236f:	ff 75 0c             	pushl  0xc(%ebp)
  802372:	01 d8                	add    %ebx,%eax
  802374:	50                   	push   %eax
  802375:	e8 c2 ff ff ff       	call   80233c <strcpy>
	return dst;
}
  80237a:	89 d8                	mov    %ebx,%eax
  80237c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	56                   	push   %esi
  802385:	53                   	push   %ebx
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80238c:	89 c6                	mov    %eax,%esi
  80238e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802391:	89 c2                	mov    %eax,%edx
  802393:	39 f2                	cmp    %esi,%edx
  802395:	74 11                	je     8023a8 <strncpy+0x27>
		*dst++ = *src;
  802397:	83 c2 01             	add    $0x1,%edx
  80239a:	0f b6 19             	movzbl (%ecx),%ebx
  80239d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8023a0:	80 fb 01             	cmp    $0x1,%bl
  8023a3:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8023a6:	eb eb                	jmp    802393 <strncpy+0x12>
	}
	return ret;
}
  8023a8:	5b                   	pop    %ebx
  8023a9:	5e                   	pop    %esi
  8023aa:	5d                   	pop    %ebp
  8023ab:	c3                   	ret    

008023ac <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	56                   	push   %esi
  8023b0:	53                   	push   %ebx
  8023b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8023b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023b7:	8b 55 10             	mov    0x10(%ebp),%edx
  8023ba:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8023bc:	85 d2                	test   %edx,%edx
  8023be:	74 21                	je     8023e1 <strlcpy+0x35>
  8023c0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8023c4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8023c6:	39 c2                	cmp    %eax,%edx
  8023c8:	74 14                	je     8023de <strlcpy+0x32>
  8023ca:	0f b6 19             	movzbl (%ecx),%ebx
  8023cd:	84 db                	test   %bl,%bl
  8023cf:	74 0b                	je     8023dc <strlcpy+0x30>
			*dst++ = *src++;
  8023d1:	83 c1 01             	add    $0x1,%ecx
  8023d4:	83 c2 01             	add    $0x1,%edx
  8023d7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8023da:	eb ea                	jmp    8023c6 <strlcpy+0x1a>
  8023dc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8023de:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8023e1:	29 f0                	sub    %esi,%eax
}
  8023e3:	5b                   	pop    %ebx
  8023e4:	5e                   	pop    %esi
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    

008023e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8023f0:	0f b6 01             	movzbl (%ecx),%eax
  8023f3:	84 c0                	test   %al,%al
  8023f5:	74 0c                	je     802403 <strcmp+0x1c>
  8023f7:	3a 02                	cmp    (%edx),%al
  8023f9:	75 08                	jne    802403 <strcmp+0x1c>
		p++, q++;
  8023fb:	83 c1 01             	add    $0x1,%ecx
  8023fe:	83 c2 01             	add    $0x1,%edx
  802401:	eb ed                	jmp    8023f0 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802403:	0f b6 c0             	movzbl %al,%eax
  802406:	0f b6 12             	movzbl (%edx),%edx
  802409:	29 d0                	sub    %edx,%eax
}
  80240b:	5d                   	pop    %ebp
  80240c:	c3                   	ret    

0080240d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	53                   	push   %ebx
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	8b 55 0c             	mov    0xc(%ebp),%edx
  802417:	89 c3                	mov    %eax,%ebx
  802419:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80241c:	eb 06                	jmp    802424 <strncmp+0x17>
		n--, p++, q++;
  80241e:	83 c0 01             	add    $0x1,%eax
  802421:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  802424:	39 d8                	cmp    %ebx,%eax
  802426:	74 16                	je     80243e <strncmp+0x31>
  802428:	0f b6 08             	movzbl (%eax),%ecx
  80242b:	84 c9                	test   %cl,%cl
  80242d:	74 04                	je     802433 <strncmp+0x26>
  80242f:	3a 0a                	cmp    (%edx),%cl
  802431:	74 eb                	je     80241e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802433:	0f b6 00             	movzbl (%eax),%eax
  802436:	0f b6 12             	movzbl (%edx),%edx
  802439:	29 d0                	sub    %edx,%eax
}
  80243b:	5b                   	pop    %ebx
  80243c:	5d                   	pop    %ebp
  80243d:	c3                   	ret    
		return 0;
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	eb f6                	jmp    80243b <strncmp+0x2e>

00802445 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80244f:	0f b6 10             	movzbl (%eax),%edx
  802452:	84 d2                	test   %dl,%dl
  802454:	74 09                	je     80245f <strchr+0x1a>
		if (*s == c)
  802456:	38 ca                	cmp    %cl,%dl
  802458:	74 0a                	je     802464 <strchr+0x1f>
	for (; *s; s++)
  80245a:	83 c0 01             	add    $0x1,%eax
  80245d:	eb f0                	jmp    80244f <strchr+0xa>
			return (char *) s;
	return 0;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802470:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  802473:	38 ca                	cmp    %cl,%dl
  802475:	74 09                	je     802480 <strfind+0x1a>
  802477:	84 d2                	test   %dl,%dl
  802479:	74 05                	je     802480 <strfind+0x1a>
	for (; *s; s++)
  80247b:	83 c0 01             	add    $0x1,%eax
  80247e:	eb f0                	jmp    802470 <strfind+0xa>
			break;
	return (char *) s;
}
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    

00802482 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	57                   	push   %edi
  802486:	56                   	push   %esi
  802487:	53                   	push   %ebx
  802488:	8b 7d 08             	mov    0x8(%ebp),%edi
  80248b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80248e:	85 c9                	test   %ecx,%ecx
  802490:	74 31                	je     8024c3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802492:	89 f8                	mov    %edi,%eax
  802494:	09 c8                	or     %ecx,%eax
  802496:	a8 03                	test   $0x3,%al
  802498:	75 23                	jne    8024bd <memset+0x3b>
		c &= 0xFF;
  80249a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80249e:	89 d3                	mov    %edx,%ebx
  8024a0:	c1 e3 08             	shl    $0x8,%ebx
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	c1 e0 18             	shl    $0x18,%eax
  8024a8:	89 d6                	mov    %edx,%esi
  8024aa:	c1 e6 10             	shl    $0x10,%esi
  8024ad:	09 f0                	or     %esi,%eax
  8024af:	09 c2                	or     %eax,%edx
  8024b1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8024b3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8024b6:	89 d0                	mov    %edx,%eax
  8024b8:	fc                   	cld    
  8024b9:	f3 ab                	rep stos %eax,%es:(%edi)
  8024bb:	eb 06                	jmp    8024c3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8024bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c0:	fc                   	cld    
  8024c1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8024c3:	89 f8                	mov    %edi,%eax
  8024c5:	5b                   	pop    %ebx
  8024c6:	5e                   	pop    %esi
  8024c7:	5f                   	pop    %edi
  8024c8:	5d                   	pop    %ebp
  8024c9:	c3                   	ret    

008024ca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	57                   	push   %edi
  8024ce:	56                   	push   %esi
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8024d8:	39 c6                	cmp    %eax,%esi
  8024da:	73 32                	jae    80250e <memmove+0x44>
  8024dc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8024df:	39 c2                	cmp    %eax,%edx
  8024e1:	76 2b                	jbe    80250e <memmove+0x44>
		s += n;
		d += n;
  8024e3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024e6:	89 fe                	mov    %edi,%esi
  8024e8:	09 ce                	or     %ecx,%esi
  8024ea:	09 d6                	or     %edx,%esi
  8024ec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8024f2:	75 0e                	jne    802502 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8024f4:	83 ef 04             	sub    $0x4,%edi
  8024f7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8024fa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8024fd:	fd                   	std    
  8024fe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802500:	eb 09                	jmp    80250b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802502:	83 ef 01             	sub    $0x1,%edi
  802505:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  802508:	fd                   	std    
  802509:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80250b:	fc                   	cld    
  80250c:	eb 1a                	jmp    802528 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80250e:	89 c2                	mov    %eax,%edx
  802510:	09 ca                	or     %ecx,%edx
  802512:	09 f2                	or     %esi,%edx
  802514:	f6 c2 03             	test   $0x3,%dl
  802517:	75 0a                	jne    802523 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802519:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80251c:	89 c7                	mov    %eax,%edi
  80251e:	fc                   	cld    
  80251f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802521:	eb 05                	jmp    802528 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  802523:	89 c7                	mov    %eax,%edi
  802525:	fc                   	cld    
  802526:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802528:	5e                   	pop    %esi
  802529:	5f                   	pop    %edi
  80252a:	5d                   	pop    %ebp
  80252b:	c3                   	ret    

0080252c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802532:	ff 75 10             	pushl  0x10(%ebp)
  802535:	ff 75 0c             	pushl  0xc(%ebp)
  802538:	ff 75 08             	pushl  0x8(%ebp)
  80253b:	e8 8a ff ff ff       	call   8024ca <memmove>
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	56                   	push   %esi
  802546:	53                   	push   %ebx
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254d:	89 c6                	mov    %eax,%esi
  80254f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802552:	39 f0                	cmp    %esi,%eax
  802554:	74 1c                	je     802572 <memcmp+0x30>
		if (*s1 != *s2)
  802556:	0f b6 08             	movzbl (%eax),%ecx
  802559:	0f b6 1a             	movzbl (%edx),%ebx
  80255c:	38 d9                	cmp    %bl,%cl
  80255e:	75 08                	jne    802568 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  802560:	83 c0 01             	add    $0x1,%eax
  802563:	83 c2 01             	add    $0x1,%edx
  802566:	eb ea                	jmp    802552 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  802568:	0f b6 c1             	movzbl %cl,%eax
  80256b:	0f b6 db             	movzbl %bl,%ebx
  80256e:	29 d8                	sub    %ebx,%eax
  802570:	eb 05                	jmp    802577 <memcmp+0x35>
	}

	return 0;
  802572:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5d                   	pop    %ebp
  80257a:	c3                   	ret    

0080257b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  802584:	89 c2                	mov    %eax,%edx
  802586:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802589:	39 d0                	cmp    %edx,%eax
  80258b:	73 09                	jae    802596 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80258d:	38 08                	cmp    %cl,(%eax)
  80258f:	74 05                	je     802596 <memfind+0x1b>
	for (; s < ends; s++)
  802591:	83 c0 01             	add    $0x1,%eax
  802594:	eb f3                	jmp    802589 <memfind+0xe>
			break;
	return (void *) s;
}
  802596:	5d                   	pop    %ebp
  802597:	c3                   	ret    

00802598 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
  80259b:	57                   	push   %edi
  80259c:	56                   	push   %esi
  80259d:	53                   	push   %ebx
  80259e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025a4:	eb 03                	jmp    8025a9 <strtol+0x11>
		s++;
  8025a6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8025a9:	0f b6 01             	movzbl (%ecx),%eax
  8025ac:	3c 20                	cmp    $0x20,%al
  8025ae:	74 f6                	je     8025a6 <strtol+0xe>
  8025b0:	3c 09                	cmp    $0x9,%al
  8025b2:	74 f2                	je     8025a6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8025b4:	3c 2b                	cmp    $0x2b,%al
  8025b6:	74 2a                	je     8025e2 <strtol+0x4a>
	int neg = 0;
  8025b8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8025bd:	3c 2d                	cmp    $0x2d,%al
  8025bf:	74 2b                	je     8025ec <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025c1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8025c7:	75 0f                	jne    8025d8 <strtol+0x40>
  8025c9:	80 39 30             	cmpb   $0x30,(%ecx)
  8025cc:	74 28                	je     8025f6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8025ce:	85 db                	test   %ebx,%ebx
  8025d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8025d5:	0f 44 d8             	cmove  %eax,%ebx
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8025e0:	eb 50                	jmp    802632 <strtol+0x9a>
		s++;
  8025e2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8025e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ea:	eb d5                	jmp    8025c1 <strtol+0x29>
		s++, neg = 1;
  8025ec:	83 c1 01             	add    $0x1,%ecx
  8025ef:	bf 01 00 00 00       	mov    $0x1,%edi
  8025f4:	eb cb                	jmp    8025c1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025f6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8025fa:	74 0e                	je     80260a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8025fc:	85 db                	test   %ebx,%ebx
  8025fe:	75 d8                	jne    8025d8 <strtol+0x40>
		s++, base = 8;
  802600:	83 c1 01             	add    $0x1,%ecx
  802603:	bb 08 00 00 00       	mov    $0x8,%ebx
  802608:	eb ce                	jmp    8025d8 <strtol+0x40>
		s += 2, base = 16;
  80260a:	83 c1 02             	add    $0x2,%ecx
  80260d:	bb 10 00 00 00       	mov    $0x10,%ebx
  802612:	eb c4                	jmp    8025d8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  802614:	8d 72 9f             	lea    -0x61(%edx),%esi
  802617:	89 f3                	mov    %esi,%ebx
  802619:	80 fb 19             	cmp    $0x19,%bl
  80261c:	77 29                	ja     802647 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80261e:	0f be d2             	movsbl %dl,%edx
  802621:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802624:	3b 55 10             	cmp    0x10(%ebp),%edx
  802627:	7d 30                	jge    802659 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  802629:	83 c1 01             	add    $0x1,%ecx
  80262c:	0f af 45 10          	imul   0x10(%ebp),%eax
  802630:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802632:	0f b6 11             	movzbl (%ecx),%edx
  802635:	8d 72 d0             	lea    -0x30(%edx),%esi
  802638:	89 f3                	mov    %esi,%ebx
  80263a:	80 fb 09             	cmp    $0x9,%bl
  80263d:	77 d5                	ja     802614 <strtol+0x7c>
			dig = *s - '0';
  80263f:	0f be d2             	movsbl %dl,%edx
  802642:	83 ea 30             	sub    $0x30,%edx
  802645:	eb dd                	jmp    802624 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  802647:	8d 72 bf             	lea    -0x41(%edx),%esi
  80264a:	89 f3                	mov    %esi,%ebx
  80264c:	80 fb 19             	cmp    $0x19,%bl
  80264f:	77 08                	ja     802659 <strtol+0xc1>
			dig = *s - 'A' + 10;
  802651:	0f be d2             	movsbl %dl,%edx
  802654:	83 ea 37             	sub    $0x37,%edx
  802657:	eb cb                	jmp    802624 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  802659:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80265d:	74 05                	je     802664 <strtol+0xcc>
		*endptr = (char *) s;
  80265f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802662:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802664:	89 c2                	mov    %eax,%edx
  802666:	f7 da                	neg    %edx
  802668:	85 ff                	test   %edi,%edi
  80266a:	0f 45 c2             	cmovne %edx,%eax
}
  80266d:	5b                   	pop    %ebx
  80266e:	5e                   	pop    %esi
  80266f:	5f                   	pop    %edi
  802670:	5d                   	pop    %ebp
  802671:	c3                   	ret    

00802672 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
  802675:	57                   	push   %edi
  802676:	56                   	push   %esi
  802677:	53                   	push   %ebx
	asm volatile("int %1\n"
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
  80267d:	8b 55 08             	mov    0x8(%ebp),%edx
  802680:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802683:	89 c3                	mov    %eax,%ebx
  802685:	89 c7                	mov    %eax,%edi
  802687:	89 c6                	mov    %eax,%esi
  802689:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80268b:	5b                   	pop    %ebx
  80268c:	5e                   	pop    %esi
  80268d:	5f                   	pop    %edi
  80268e:	5d                   	pop    %ebp
  80268f:	c3                   	ret    

00802690 <sys_cgetc>:

int
sys_cgetc(void)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	57                   	push   %edi
  802694:	56                   	push   %esi
  802695:	53                   	push   %ebx
	asm volatile("int %1\n"
  802696:	ba 00 00 00 00       	mov    $0x0,%edx
  80269b:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a0:	89 d1                	mov    %edx,%ecx
  8026a2:	89 d3                	mov    %edx,%ebx
  8026a4:	89 d7                	mov    %edx,%edi
  8026a6:	89 d6                	mov    %edx,%esi
  8026a8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8026aa:	5b                   	pop    %ebx
  8026ab:	5e                   	pop    %esi
  8026ac:	5f                   	pop    %edi
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    

008026af <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
  8026b2:	57                   	push   %edi
  8026b3:	56                   	push   %esi
  8026b4:	53                   	push   %ebx
  8026b5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c0:	b8 03 00 00 00       	mov    $0x3,%eax
  8026c5:	89 cb                	mov    %ecx,%ebx
  8026c7:	89 cf                	mov    %ecx,%edi
  8026c9:	89 ce                	mov    %ecx,%esi
  8026cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	7f 08                	jg     8026d9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8026d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026d4:	5b                   	pop    %ebx
  8026d5:	5e                   	pop    %esi
  8026d6:	5f                   	pop    %edi
  8026d7:	5d                   	pop    %ebp
  8026d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026d9:	83 ec 0c             	sub    $0xc,%esp
  8026dc:	50                   	push   %eax
  8026dd:	6a 03                	push   $0x3
  8026df:	68 c0 43 80 00       	push   $0x8043c0
  8026e4:	6a 33                	push   $0x33
  8026e6:	68 dd 43 80 00       	push   $0x8043dd
  8026eb:	e8 63 f4 ff ff       	call   801b53 <_panic>

008026f0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
  8026f3:	57                   	push   %edi
  8026f4:	56                   	push   %esi
  8026f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8026f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fb:	b8 02 00 00 00       	mov    $0x2,%eax
  802700:	89 d1                	mov    %edx,%ecx
  802702:	89 d3                	mov    %edx,%ebx
  802704:	89 d7                	mov    %edx,%edi
  802706:	89 d6                	mov    %edx,%esi
  802708:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80270a:	5b                   	pop    %ebx
  80270b:	5e                   	pop    %esi
  80270c:	5f                   	pop    %edi
  80270d:	5d                   	pop    %ebp
  80270e:	c3                   	ret    

0080270f <sys_yield>:

void
sys_yield(void)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	57                   	push   %edi
  802713:	56                   	push   %esi
  802714:	53                   	push   %ebx
	asm volatile("int %1\n"
  802715:	ba 00 00 00 00       	mov    $0x0,%edx
  80271a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80271f:	89 d1                	mov    %edx,%ecx
  802721:	89 d3                	mov    %edx,%ebx
  802723:	89 d7                	mov    %edx,%edi
  802725:	89 d6                	mov    %edx,%esi
  802727:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802729:	5b                   	pop    %ebx
  80272a:	5e                   	pop    %esi
  80272b:	5f                   	pop    %edi
  80272c:	5d                   	pop    %ebp
  80272d:	c3                   	ret    

0080272e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	57                   	push   %edi
  802732:	56                   	push   %esi
  802733:	53                   	push   %ebx
  802734:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802737:	be 00 00 00 00       	mov    $0x0,%esi
  80273c:	8b 55 08             	mov    0x8(%ebp),%edx
  80273f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802742:	b8 04 00 00 00       	mov    $0x4,%eax
  802747:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80274a:	89 f7                	mov    %esi,%edi
  80274c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80274e:	85 c0                	test   %eax,%eax
  802750:	7f 08                	jg     80275a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802752:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802755:	5b                   	pop    %ebx
  802756:	5e                   	pop    %esi
  802757:	5f                   	pop    %edi
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80275a:	83 ec 0c             	sub    $0xc,%esp
  80275d:	50                   	push   %eax
  80275e:	6a 04                	push   $0x4
  802760:	68 c0 43 80 00       	push   $0x8043c0
  802765:	6a 33                	push   $0x33
  802767:	68 dd 43 80 00       	push   $0x8043dd
  80276c:	e8 e2 f3 ff ff       	call   801b53 <_panic>

00802771 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
  802774:	57                   	push   %edi
  802775:	56                   	push   %esi
  802776:	53                   	push   %ebx
  802777:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80277a:	8b 55 08             	mov    0x8(%ebp),%edx
  80277d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802780:	b8 05 00 00 00       	mov    $0x5,%eax
  802785:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802788:	8b 7d 14             	mov    0x14(%ebp),%edi
  80278b:	8b 75 18             	mov    0x18(%ebp),%esi
  80278e:	cd 30                	int    $0x30
	if(check && ret > 0)
  802790:	85 c0                	test   %eax,%eax
  802792:	7f 08                	jg     80279c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802794:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802797:	5b                   	pop    %ebx
  802798:	5e                   	pop    %esi
  802799:	5f                   	pop    %edi
  80279a:	5d                   	pop    %ebp
  80279b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80279c:	83 ec 0c             	sub    $0xc,%esp
  80279f:	50                   	push   %eax
  8027a0:	6a 05                	push   $0x5
  8027a2:	68 c0 43 80 00       	push   $0x8043c0
  8027a7:	6a 33                	push   $0x33
  8027a9:	68 dd 43 80 00       	push   $0x8043dd
  8027ae:	e8 a0 f3 ff ff       	call   801b53 <_panic>

008027b3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	57                   	push   %edi
  8027b7:	56                   	push   %esi
  8027b8:	53                   	push   %ebx
  8027b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c7:	b8 06 00 00 00       	mov    $0x6,%eax
  8027cc:	89 df                	mov    %ebx,%edi
  8027ce:	89 de                	mov    %ebx,%esi
  8027d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	7f 08                	jg     8027de <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8027d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027d9:	5b                   	pop    %ebx
  8027da:	5e                   	pop    %esi
  8027db:	5f                   	pop    %edi
  8027dc:	5d                   	pop    %ebp
  8027dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027de:	83 ec 0c             	sub    $0xc,%esp
  8027e1:	50                   	push   %eax
  8027e2:	6a 06                	push   $0x6
  8027e4:	68 c0 43 80 00       	push   $0x8043c0
  8027e9:	6a 33                	push   $0x33
  8027eb:	68 dd 43 80 00       	push   $0x8043dd
  8027f0:	e8 5e f3 ff ff       	call   801b53 <_panic>

008027f5 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	57                   	push   %edi
  8027f9:	56                   	push   %esi
  8027fa:	53                   	push   %ebx
  8027fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  802803:	8b 55 08             	mov    0x8(%ebp),%edx
  802806:	b8 0b 00 00 00       	mov    $0xb,%eax
  80280b:	89 cb                	mov    %ecx,%ebx
  80280d:	89 cf                	mov    %ecx,%edi
  80280f:	89 ce                	mov    %ecx,%esi
  802811:	cd 30                	int    $0x30
	if(check && ret > 0)
  802813:	85 c0                	test   %eax,%eax
  802815:	7f 08                	jg     80281f <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  802817:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80281a:	5b                   	pop    %ebx
  80281b:	5e                   	pop    %esi
  80281c:	5f                   	pop    %edi
  80281d:	5d                   	pop    %ebp
  80281e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	50                   	push   %eax
  802823:	6a 0b                	push   $0xb
  802825:	68 c0 43 80 00       	push   $0x8043c0
  80282a:	6a 33                	push   $0x33
  80282c:	68 dd 43 80 00       	push   $0x8043dd
  802831:	e8 1d f3 ff ff       	call   801b53 <_panic>

00802836 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	57                   	push   %edi
  80283a:	56                   	push   %esi
  80283b:	53                   	push   %ebx
  80283c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80283f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802844:	8b 55 08             	mov    0x8(%ebp),%edx
  802847:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80284a:	b8 08 00 00 00       	mov    $0x8,%eax
  80284f:	89 df                	mov    %ebx,%edi
  802851:	89 de                	mov    %ebx,%esi
  802853:	cd 30                	int    $0x30
	if(check && ret > 0)
  802855:	85 c0                	test   %eax,%eax
  802857:	7f 08                	jg     802861 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802859:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80285c:	5b                   	pop    %ebx
  80285d:	5e                   	pop    %esi
  80285e:	5f                   	pop    %edi
  80285f:	5d                   	pop    %ebp
  802860:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802861:	83 ec 0c             	sub    $0xc,%esp
  802864:	50                   	push   %eax
  802865:	6a 08                	push   $0x8
  802867:	68 c0 43 80 00       	push   $0x8043c0
  80286c:	6a 33                	push   $0x33
  80286e:	68 dd 43 80 00       	push   $0x8043dd
  802873:	e8 db f2 ff ff       	call   801b53 <_panic>

00802878 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	57                   	push   %edi
  80287c:	56                   	push   %esi
  80287d:	53                   	push   %ebx
  80287e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802881:	bb 00 00 00 00       	mov    $0x0,%ebx
  802886:	8b 55 08             	mov    0x8(%ebp),%edx
  802889:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80288c:	b8 09 00 00 00       	mov    $0x9,%eax
  802891:	89 df                	mov    %ebx,%edi
  802893:	89 de                	mov    %ebx,%esi
  802895:	cd 30                	int    $0x30
	if(check && ret > 0)
  802897:	85 c0                	test   %eax,%eax
  802899:	7f 08                	jg     8028a3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80289b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80289e:	5b                   	pop    %ebx
  80289f:	5e                   	pop    %esi
  8028a0:	5f                   	pop    %edi
  8028a1:	5d                   	pop    %ebp
  8028a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8028a3:	83 ec 0c             	sub    $0xc,%esp
  8028a6:	50                   	push   %eax
  8028a7:	6a 09                	push   $0x9
  8028a9:	68 c0 43 80 00       	push   $0x8043c0
  8028ae:	6a 33                	push   $0x33
  8028b0:	68 dd 43 80 00       	push   $0x8043dd
  8028b5:	e8 99 f2 ff ff       	call   801b53 <_panic>

008028ba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8028ba:	55                   	push   %ebp
  8028bb:	89 e5                	mov    %esp,%ebp
  8028bd:	57                   	push   %edi
  8028be:	56                   	push   %esi
  8028bf:	53                   	push   %ebx
  8028c0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8028c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8028d3:	89 df                	mov    %ebx,%edi
  8028d5:	89 de                	mov    %ebx,%esi
  8028d7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	7f 08                	jg     8028e5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8028dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028e0:	5b                   	pop    %ebx
  8028e1:	5e                   	pop    %esi
  8028e2:	5f                   	pop    %edi
  8028e3:	5d                   	pop    %ebp
  8028e4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8028e5:	83 ec 0c             	sub    $0xc,%esp
  8028e8:	50                   	push   %eax
  8028e9:	6a 0a                	push   $0xa
  8028eb:	68 c0 43 80 00       	push   $0x8043c0
  8028f0:	6a 33                	push   $0x33
  8028f2:	68 dd 43 80 00       	push   $0x8043dd
  8028f7:	e8 57 f2 ff ff       	call   801b53 <_panic>

008028fc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	57                   	push   %edi
  802900:	56                   	push   %esi
  802901:	53                   	push   %ebx
	asm volatile("int %1\n"
  802902:	8b 55 08             	mov    0x8(%ebp),%edx
  802905:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802908:	b8 0d 00 00 00       	mov    $0xd,%eax
  80290d:	be 00 00 00 00       	mov    $0x0,%esi
  802912:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802915:	8b 7d 14             	mov    0x14(%ebp),%edi
  802918:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80291a:	5b                   	pop    %ebx
  80291b:	5e                   	pop    %esi
  80291c:	5f                   	pop    %edi
  80291d:	5d                   	pop    %ebp
  80291e:	c3                   	ret    

0080291f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
  802922:	57                   	push   %edi
  802923:	56                   	push   %esi
  802924:	53                   	push   %ebx
  802925:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802928:	b9 00 00 00 00       	mov    $0x0,%ecx
  80292d:	8b 55 08             	mov    0x8(%ebp),%edx
  802930:	b8 0e 00 00 00       	mov    $0xe,%eax
  802935:	89 cb                	mov    %ecx,%ebx
  802937:	89 cf                	mov    %ecx,%edi
  802939:	89 ce                	mov    %ecx,%esi
  80293b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80293d:	85 c0                	test   %eax,%eax
  80293f:	7f 08                	jg     802949 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802941:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802944:	5b                   	pop    %ebx
  802945:	5e                   	pop    %esi
  802946:	5f                   	pop    %edi
  802947:	5d                   	pop    %ebp
  802948:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802949:	83 ec 0c             	sub    $0xc,%esp
  80294c:	50                   	push   %eax
  80294d:	6a 0e                	push   $0xe
  80294f:	68 c0 43 80 00       	push   $0x8043c0
  802954:	6a 33                	push   $0x33
  802956:	68 dd 43 80 00       	push   $0x8043dd
  80295b:	e8 f3 f1 ff ff       	call   801b53 <_panic>

00802960 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	57                   	push   %edi
  802964:	56                   	push   %esi
  802965:	53                   	push   %ebx
	asm volatile("int %1\n"
  802966:	bb 00 00 00 00       	mov    $0x0,%ebx
  80296b:	8b 55 08             	mov    0x8(%ebp),%edx
  80296e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802971:	b8 0f 00 00 00       	mov    $0xf,%eax
  802976:	89 df                	mov    %ebx,%edi
  802978:	89 de                	mov    %ebx,%esi
  80297a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    

00802981 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
  802984:	57                   	push   %edi
  802985:	56                   	push   %esi
  802986:	53                   	push   %ebx
	asm volatile("int %1\n"
  802987:	b9 00 00 00 00       	mov    $0x0,%ecx
  80298c:	8b 55 08             	mov    0x8(%ebp),%edx
  80298f:	b8 10 00 00 00       	mov    $0x10,%eax
  802994:	89 cb                	mov    %ecx,%ebx
  802996:	89 cf                	mov    %ecx,%edi
  802998:	89 ce                	mov    %ecx,%esi
  80299a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80299c:	5b                   	pop    %ebx
  80299d:	5e                   	pop    %esi
  80299e:	5f                   	pop    %edi
  80299f:	5d                   	pop    %ebp
  8029a0:	c3                   	ret    

008029a1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029a1:	55                   	push   %ebp
  8029a2:	89 e5                	mov    %esp,%ebp
  8029a4:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029a7:	83 3d 10 a0 80 00 00 	cmpl   $0x0,0x80a010
  8029ae:	74 0a                	je     8029ba <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	a3 10 a0 80 00       	mov    %eax,0x80a010
}
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8029ba:	83 ec 04             	sub    $0x4,%esp
  8029bd:	6a 07                	push   $0x7
  8029bf:	68 00 f0 bf ee       	push   $0xeebff000
  8029c4:	6a 00                	push   $0x0
  8029c6:	e8 63 fd ff ff       	call   80272e <sys_page_alloc>
  8029cb:	83 c4 10             	add    $0x10,%esp
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	78 28                	js     8029fa <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8029d2:	83 ec 08             	sub    $0x8,%esp
  8029d5:	68 0c 2a 80 00       	push   $0x802a0c
  8029da:	6a 00                	push   $0x0
  8029dc:	e8 d9 fe ff ff       	call   8028ba <sys_env_set_pgfault_upcall>
  8029e1:	83 c4 10             	add    $0x10,%esp
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	79 c8                	jns    8029b0 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8029e8:	50                   	push   %eax
  8029e9:	68 14 44 80 00       	push   $0x804414
  8029ee:	6a 23                	push   $0x23
  8029f0:	68 03 44 80 00       	push   $0x804403
  8029f5:	e8 59 f1 ff ff       	call   801b53 <_panic>
			panic("set_pgfault_handler %e\n",r);
  8029fa:	50                   	push   %eax
  8029fb:	68 eb 43 80 00       	push   $0x8043eb
  802a00:	6a 21                	push   $0x21
  802a02:	68 03 44 80 00       	push   $0x804403
  802a07:	e8 47 f1 ff ff       	call   801b53 <_panic>

00802a0c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a0c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a0d:	a1 10 a0 80 00       	mov    0x80a010,%eax
	call *%eax
  802a12:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a14:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  802a17:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  802a1b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802a1f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a22:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a24:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802a28:	83 c4 08             	add    $0x8,%esp
	popal
  802a2b:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a2c:	83 c4 04             	add    $0x4,%esp
	popfl
  802a2f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a30:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a31:	c3                   	ret    

00802a32 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a32:	55                   	push   %ebp
  802a33:	89 e5                	mov    %esp,%ebp
  802a35:	56                   	push   %esi
  802a36:	53                   	push   %ebx
  802a37:	8b 75 08             	mov    0x8(%ebp),%esi
  802a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  802a40:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802a42:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a47:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  802a4a:	83 ec 0c             	sub    $0xc,%esp
  802a4d:	50                   	push   %eax
  802a4e:	e8 cc fe ff ff       	call   80291f <sys_ipc_recv>
	if (from_env_store)
  802a53:	83 c4 10             	add    $0x10,%esp
  802a56:	85 f6                	test   %esi,%esi
  802a58:	74 14                	je     802a6e <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  802a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	78 09                	js     802a6c <ipc_recv+0x3a>
  802a63:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  802a69:	8b 52 78             	mov    0x78(%edx),%edx
  802a6c:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  802a6e:	85 db                	test   %ebx,%ebx
  802a70:	74 14                	je     802a86 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  802a72:	ba 00 00 00 00       	mov    $0x0,%edx
  802a77:	85 c0                	test   %eax,%eax
  802a79:	78 09                	js     802a84 <ipc_recv+0x52>
  802a7b:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  802a81:	8b 52 7c             	mov    0x7c(%edx),%edx
  802a84:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  802a86:	85 c0                	test   %eax,%eax
  802a88:	78 08                	js     802a92 <ipc_recv+0x60>
  802a8a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802a8f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802a92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a95:	5b                   	pop    %ebx
  802a96:	5e                   	pop    %esi
  802a97:	5d                   	pop    %ebp
  802a98:	c3                   	ret    

00802a99 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a99:	55                   	push   %ebp
  802a9a:	89 e5                	mov    %esp,%ebp
  802a9c:	83 ec 08             	sub    $0x8,%esp
  802a9f:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802aa9:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  802aac:	ff 75 14             	pushl  0x14(%ebp)
  802aaf:	50                   	push   %eax
  802ab0:	ff 75 0c             	pushl  0xc(%ebp)
  802ab3:	ff 75 08             	pushl  0x8(%ebp)
  802ab6:	e8 41 fe ff ff       	call   8028fc <sys_ipc_try_send>
  802abb:	83 c4 10             	add    $0x10,%esp
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	78 02                	js     802ac4 <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  802ac2:	c9                   	leave  
  802ac3:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  802ac4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ac7:	75 07                	jne    802ad0 <ipc_send+0x37>
		sys_yield();
  802ac9:	e8 41 fc ff ff       	call   80270f <sys_yield>
}
  802ace:	eb f2                	jmp    802ac2 <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  802ad0:	50                   	push   %eax
  802ad1:	68 34 44 80 00       	push   $0x804434
  802ad6:	6a 3c                	push   $0x3c
  802ad8:	68 48 44 80 00       	push   $0x804448
  802add:	e8 71 f0 ff ff       	call   801b53 <_panic>

00802ae2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
  802ae5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ae8:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  802aed:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802af0:	c1 e0 04             	shl    $0x4,%eax
  802af3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802af8:	8b 40 50             	mov    0x50(%eax),%eax
  802afb:	39 c8                	cmp    %ecx,%eax
  802afd:	74 12                	je     802b11 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802aff:	83 c2 01             	add    $0x1,%edx
  802b02:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  802b08:	75 e3                	jne    802aed <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0f:	eb 0e                	jmp    802b1f <ipc_find_env+0x3d>
			return envs[i].env_id;
  802b11:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  802b14:	c1 e0 04             	shl    $0x4,%eax
  802b17:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b1c:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b1f:	5d                   	pop    %ebp
  802b20:	c3                   	ret    

00802b21 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b21:	55                   	push   %ebp
  802b22:	89 e5                	mov    %esp,%ebp
  802b24:	56                   	push   %esi
  802b25:	53                   	push   %ebx
  802b26:	89 c6                	mov    %eax,%esi
  802b28:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802b2a:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  802b31:	74 27                	je     802b5a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b33:	6a 07                	push   $0x7
  802b35:	68 00 b0 80 00       	push   $0x80b000
  802b3a:	56                   	push   %esi
  802b3b:	ff 35 00 a0 80 00    	pushl  0x80a000
  802b41:	e8 53 ff ff ff       	call   802a99 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802b46:	83 c4 0c             	add    $0xc,%esp
  802b49:	6a 00                	push   $0x0
  802b4b:	53                   	push   %ebx
  802b4c:	6a 00                	push   $0x0
  802b4e:	e8 df fe ff ff       	call   802a32 <ipc_recv>
}
  802b53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b56:	5b                   	pop    %ebx
  802b57:	5e                   	pop    %esi
  802b58:	5d                   	pop    %ebp
  802b59:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b5a:	83 ec 0c             	sub    $0xc,%esp
  802b5d:	6a 01                	push   $0x1
  802b5f:	e8 7e ff ff ff       	call   802ae2 <ipc_find_env>
  802b64:	a3 00 a0 80 00       	mov    %eax,0x80a000
  802b69:	83 c4 10             	add    $0x10,%esp
  802b6c:	eb c5                	jmp    802b33 <fsipc+0x12>

00802b6e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
  802b71:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7a:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b82:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b87:	ba 00 00 00 00       	mov    $0x0,%edx
  802b8c:	b8 02 00 00 00       	mov    $0x2,%eax
  802b91:	e8 8b ff ff ff       	call   802b21 <fsipc>
}
  802b96:	c9                   	leave  
  802b97:	c3                   	ret    

00802b98 <devfile_flush>:
{
  802b98:	55                   	push   %ebp
  802b99:	89 e5                	mov    %esp,%ebp
  802b9b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  802bae:	b8 06 00 00 00       	mov    $0x6,%eax
  802bb3:	e8 69 ff ff ff       	call   802b21 <fsipc>
}
  802bb8:	c9                   	leave  
  802bb9:	c3                   	ret    

00802bba <devfile_stat>:
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
  802bbd:	53                   	push   %ebx
  802bbe:	83 ec 04             	sub    $0x4,%esp
  802bc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bca:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd4:	b8 05 00 00 00       	mov    $0x5,%eax
  802bd9:	e8 43 ff ff ff       	call   802b21 <fsipc>
  802bde:	85 c0                	test   %eax,%eax
  802be0:	78 2c                	js     802c0e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802be2:	83 ec 08             	sub    $0x8,%esp
  802be5:	68 00 b0 80 00       	push   $0x80b000
  802bea:	53                   	push   %ebx
  802beb:	e8 4c f7 ff ff       	call   80233c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802bf0:	a1 80 b0 80 00       	mov    0x80b080,%eax
  802bf5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bfb:	a1 84 b0 80 00       	mov    0x80b084,%eax
  802c00:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802c06:	83 c4 10             	add    $0x10,%esp
  802c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c11:	c9                   	leave  
  802c12:	c3                   	ret    

00802c13 <devfile_write>:
{
  802c13:	55                   	push   %ebp
  802c14:	89 e5                	mov    %esp,%ebp
  802c16:	83 ec 0c             	sub    $0xc,%esp
  802c19:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1f:	8b 52 0c             	mov    0xc(%edx),%edx
  802c22:	89 15 00 b0 80 00    	mov    %edx,0x80b000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802c28:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  802c2d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  802c32:	0f 47 c2             	cmova  %edx,%eax
  802c35:	a3 04 b0 80 00       	mov    %eax,0x80b004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802c3a:	50                   	push   %eax
  802c3b:	ff 75 0c             	pushl  0xc(%ebp)
  802c3e:	68 08 b0 80 00       	push   $0x80b008
  802c43:	e8 82 f8 ff ff       	call   8024ca <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  802c48:	ba 00 00 00 00       	mov    $0x0,%edx
  802c4d:	b8 04 00 00 00       	mov    $0x4,%eax
  802c52:	e8 ca fe ff ff       	call   802b21 <fsipc>
}
  802c57:	c9                   	leave  
  802c58:	c3                   	ret    

00802c59 <devfile_read>:
{
  802c59:	55                   	push   %ebp
  802c5a:	89 e5                	mov    %esp,%ebp
  802c5c:	56                   	push   %esi
  802c5d:	53                   	push   %ebx
  802c5e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	8b 40 0c             	mov    0xc(%eax),%eax
  802c67:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  802c6c:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802c72:	ba 00 00 00 00       	mov    $0x0,%edx
  802c77:	b8 03 00 00 00       	mov    $0x3,%eax
  802c7c:	e8 a0 fe ff ff       	call   802b21 <fsipc>
  802c81:	89 c3                	mov    %eax,%ebx
  802c83:	85 c0                	test   %eax,%eax
  802c85:	78 1f                	js     802ca6 <devfile_read+0x4d>
	assert(r <= n);
  802c87:	39 f0                	cmp    %esi,%eax
  802c89:	77 24                	ja     802caf <devfile_read+0x56>
	assert(r <= PGSIZE);
  802c8b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802c90:	7f 33                	jg     802cc5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802c92:	83 ec 04             	sub    $0x4,%esp
  802c95:	50                   	push   %eax
  802c96:	68 00 b0 80 00       	push   $0x80b000
  802c9b:	ff 75 0c             	pushl  0xc(%ebp)
  802c9e:	e8 27 f8 ff ff       	call   8024ca <memmove>
	return r;
  802ca3:	83 c4 10             	add    $0x10,%esp
}
  802ca6:	89 d8                	mov    %ebx,%eax
  802ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cab:	5b                   	pop    %ebx
  802cac:	5e                   	pop    %esi
  802cad:	5d                   	pop    %ebp
  802cae:	c3                   	ret    
	assert(r <= n);
  802caf:	68 52 44 80 00       	push   $0x804452
  802cb4:	68 9d 3a 80 00       	push   $0x803a9d
  802cb9:	6a 7c                	push   $0x7c
  802cbb:	68 59 44 80 00       	push   $0x804459
  802cc0:	e8 8e ee ff ff       	call   801b53 <_panic>
	assert(r <= PGSIZE);
  802cc5:	68 64 44 80 00       	push   $0x804464
  802cca:	68 9d 3a 80 00       	push   $0x803a9d
  802ccf:	6a 7d                	push   $0x7d
  802cd1:	68 59 44 80 00       	push   $0x804459
  802cd6:	e8 78 ee ff ff       	call   801b53 <_panic>

00802cdb <open>:
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
  802cde:	56                   	push   %esi
  802cdf:	53                   	push   %ebx
  802ce0:	83 ec 1c             	sub    $0x1c,%esp
  802ce3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802ce6:	56                   	push   %esi
  802ce7:	e8 17 f6 ff ff       	call   802303 <strlen>
  802cec:	83 c4 10             	add    $0x10,%esp
  802cef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cf4:	7f 6c                	jg     802d62 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802cf6:	83 ec 0c             	sub    $0xc,%esp
  802cf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cfc:	50                   	push   %eax
  802cfd:	e8 e0 00 00 00       	call   802de2 <fd_alloc>
  802d02:	89 c3                	mov    %eax,%ebx
  802d04:	83 c4 10             	add    $0x10,%esp
  802d07:	85 c0                	test   %eax,%eax
  802d09:	78 3c                	js     802d47 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802d0b:	83 ec 08             	sub    $0x8,%esp
  802d0e:	56                   	push   %esi
  802d0f:	68 00 b0 80 00       	push   $0x80b000
  802d14:	e8 23 f6 ff ff       	call   80233c <strcpy>
	fsipcbuf.open.req_omode = mode;
  802d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1c:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d24:	b8 01 00 00 00       	mov    $0x1,%eax
  802d29:	e8 f3 fd ff ff       	call   802b21 <fsipc>
  802d2e:	89 c3                	mov    %eax,%ebx
  802d30:	83 c4 10             	add    $0x10,%esp
  802d33:	85 c0                	test   %eax,%eax
  802d35:	78 19                	js     802d50 <open+0x75>
	return fd2num(fd);
  802d37:	83 ec 0c             	sub    $0xc,%esp
  802d3a:	ff 75 f4             	pushl  -0xc(%ebp)
  802d3d:	e8 79 00 00 00       	call   802dbb <fd2num>
  802d42:	89 c3                	mov    %eax,%ebx
  802d44:	83 c4 10             	add    $0x10,%esp
}
  802d47:	89 d8                	mov    %ebx,%eax
  802d49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d4c:	5b                   	pop    %ebx
  802d4d:	5e                   	pop    %esi
  802d4e:	5d                   	pop    %ebp
  802d4f:	c3                   	ret    
		fd_close(fd, 0);
  802d50:	83 ec 08             	sub    $0x8,%esp
  802d53:	6a 00                	push   $0x0
  802d55:	ff 75 f4             	pushl  -0xc(%ebp)
  802d58:	e8 7d 01 00 00       	call   802eda <fd_close>
		return r;
  802d5d:	83 c4 10             	add    $0x10,%esp
  802d60:	eb e5                	jmp    802d47 <open+0x6c>
		return -E_BAD_PATH;
  802d62:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802d67:	eb de                	jmp    802d47 <open+0x6c>

00802d69 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802d69:	55                   	push   %ebp
  802d6a:	89 e5                	mov    %esp,%ebp
  802d6c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d74:	b8 08 00 00 00       	mov    $0x8,%eax
  802d79:	e8 a3 fd ff ff       	call   802b21 <fsipc>
}
  802d7e:	c9                   	leave  
  802d7f:	c3                   	ret    

00802d80 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d80:	55                   	push   %ebp
  802d81:	89 e5                	mov    %esp,%ebp
  802d83:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d86:	89 d0                	mov    %edx,%eax
  802d88:	c1 e8 16             	shr    $0x16,%eax
  802d8b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d92:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802d97:	f6 c1 01             	test   $0x1,%cl
  802d9a:	74 1d                	je     802db9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802d9c:	c1 ea 0c             	shr    $0xc,%edx
  802d9f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802da6:	f6 c2 01             	test   $0x1,%dl
  802da9:	74 0e                	je     802db9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802dab:	c1 ea 0c             	shr    $0xc,%edx
  802dae:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802db5:	ef 
  802db6:	0f b7 c0             	movzwl %ax,%eax
}
  802db9:	5d                   	pop    %ebp
  802dba:	c3                   	ret    

00802dbb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802dbb:	55                   	push   %ebp
  802dbc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	05 00 00 00 30       	add    $0x30000000,%eax
  802dc6:	c1 e8 0c             	shr    $0xc,%eax
}
  802dc9:	5d                   	pop    %ebp
  802dca:	c3                   	ret    

00802dcb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802dcb:	55                   	push   %ebp
  802dcc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802dd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ddb:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802de0:	5d                   	pop    %ebp
  802de1:	c3                   	ret    

00802de2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802de2:	55                   	push   %ebp
  802de3:	89 e5                	mov    %esp,%ebp
  802de5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802dea:	89 c2                	mov    %eax,%edx
  802dec:	c1 ea 16             	shr    $0x16,%edx
  802def:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802df6:	f6 c2 01             	test   $0x1,%dl
  802df9:	74 2d                	je     802e28 <fd_alloc+0x46>
  802dfb:	89 c2                	mov    %eax,%edx
  802dfd:	c1 ea 0c             	shr    $0xc,%edx
  802e00:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e07:	f6 c2 01             	test   $0x1,%dl
  802e0a:	74 1c                	je     802e28 <fd_alloc+0x46>
  802e0c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802e11:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802e16:	75 d2                	jne    802dea <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802e21:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802e26:	eb 0a                	jmp    802e32 <fd_alloc+0x50>
			*fd_store = fd;
  802e28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e2b:	89 01                	mov    %eax,(%ecx)
			return 0;
  802e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e32:	5d                   	pop    %ebp
  802e33:	c3                   	ret    

00802e34 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802e34:	55                   	push   %ebp
  802e35:	89 e5                	mov    %esp,%ebp
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802e3a:	83 f8 1f             	cmp    $0x1f,%eax
  802e3d:	77 30                	ja     802e6f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802e3f:	c1 e0 0c             	shl    $0xc,%eax
  802e42:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802e47:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802e4d:	f6 c2 01             	test   $0x1,%dl
  802e50:	74 24                	je     802e76 <fd_lookup+0x42>
  802e52:	89 c2                	mov    %eax,%edx
  802e54:	c1 ea 0c             	shr    $0xc,%edx
  802e57:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e5e:	f6 c2 01             	test   $0x1,%dl
  802e61:	74 1a                	je     802e7d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e66:	89 02                	mov    %eax,(%edx)
	return 0;
  802e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e6d:	5d                   	pop    %ebp
  802e6e:	c3                   	ret    
		return -E_INVAL;
  802e6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e74:	eb f7                	jmp    802e6d <fd_lookup+0x39>
		return -E_INVAL;
  802e76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e7b:	eb f0                	jmp    802e6d <fd_lookup+0x39>
  802e7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e82:	eb e9                	jmp    802e6d <fd_lookup+0x39>

00802e84 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 08             	sub    $0x8,%esp
  802e8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e8d:	ba f0 44 80 00       	mov    $0x8044f0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802e92:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802e97:	39 08                	cmp    %ecx,(%eax)
  802e99:	74 33                	je     802ece <dev_lookup+0x4a>
  802e9b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  802e9e:	8b 02                	mov    (%edx),%eax
  802ea0:	85 c0                	test   %eax,%eax
  802ea2:	75 f3                	jne    802e97 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ea4:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802ea9:	8b 40 48             	mov    0x48(%eax),%eax
  802eac:	83 ec 04             	sub    $0x4,%esp
  802eaf:	51                   	push   %ecx
  802eb0:	50                   	push   %eax
  802eb1:	68 70 44 80 00       	push   $0x804470
  802eb6:	e8 73 ed ff ff       	call   801c2e <cprintf>
	*dev = 0;
  802ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802ec4:	83 c4 10             	add    $0x10,%esp
  802ec7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ecc:	c9                   	leave  
  802ecd:	c3                   	ret    
			*dev = devtab[i];
  802ece:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ed1:	89 01                	mov    %eax,(%ecx)
			return 0;
  802ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed8:	eb f2                	jmp    802ecc <dev_lookup+0x48>

00802eda <fd_close>:
{
  802eda:	55                   	push   %ebp
  802edb:	89 e5                	mov    %esp,%ebp
  802edd:	57                   	push   %edi
  802ede:	56                   	push   %esi
  802edf:	53                   	push   %ebx
  802ee0:	83 ec 24             	sub    $0x24,%esp
  802ee3:	8b 75 08             	mov    0x8(%ebp),%esi
  802ee6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ee9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802eec:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802eed:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802ef3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ef6:	50                   	push   %eax
  802ef7:	e8 38 ff ff ff       	call   802e34 <fd_lookup>
  802efc:	89 c3                	mov    %eax,%ebx
  802efe:	83 c4 10             	add    $0x10,%esp
  802f01:	85 c0                	test   %eax,%eax
  802f03:	78 05                	js     802f0a <fd_close+0x30>
	    || fd != fd2)
  802f05:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802f08:	74 16                	je     802f20 <fd_close+0x46>
		return (must_exist ? r : 0);
  802f0a:	89 f8                	mov    %edi,%eax
  802f0c:	84 c0                	test   %al,%al
  802f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f13:	0f 44 d8             	cmove  %eax,%ebx
}
  802f16:	89 d8                	mov    %ebx,%eax
  802f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f1b:	5b                   	pop    %ebx
  802f1c:	5e                   	pop    %esi
  802f1d:	5f                   	pop    %edi
  802f1e:	5d                   	pop    %ebp
  802f1f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802f20:	83 ec 08             	sub    $0x8,%esp
  802f23:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802f26:	50                   	push   %eax
  802f27:	ff 36                	pushl  (%esi)
  802f29:	e8 56 ff ff ff       	call   802e84 <dev_lookup>
  802f2e:	89 c3                	mov    %eax,%ebx
  802f30:	83 c4 10             	add    $0x10,%esp
  802f33:	85 c0                	test   %eax,%eax
  802f35:	78 1a                	js     802f51 <fd_close+0x77>
		if (dev->dev_close)
  802f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802f42:	85 c0                	test   %eax,%eax
  802f44:	74 0b                	je     802f51 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802f46:	83 ec 0c             	sub    $0xc,%esp
  802f49:	56                   	push   %esi
  802f4a:	ff d0                	call   *%eax
  802f4c:	89 c3                	mov    %eax,%ebx
  802f4e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802f51:	83 ec 08             	sub    $0x8,%esp
  802f54:	56                   	push   %esi
  802f55:	6a 00                	push   $0x0
  802f57:	e8 57 f8 ff ff       	call   8027b3 <sys_page_unmap>
	return r;
  802f5c:	83 c4 10             	add    $0x10,%esp
  802f5f:	eb b5                	jmp    802f16 <fd_close+0x3c>

00802f61 <close>:

int
close(int fdnum)
{
  802f61:	55                   	push   %ebp
  802f62:	89 e5                	mov    %esp,%ebp
  802f64:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f6a:	50                   	push   %eax
  802f6b:	ff 75 08             	pushl  0x8(%ebp)
  802f6e:	e8 c1 fe ff ff       	call   802e34 <fd_lookup>
  802f73:	83 c4 10             	add    $0x10,%esp
  802f76:	85 c0                	test   %eax,%eax
  802f78:	79 02                	jns    802f7c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802f7a:	c9                   	leave  
  802f7b:	c3                   	ret    
		return fd_close(fd, 1);
  802f7c:	83 ec 08             	sub    $0x8,%esp
  802f7f:	6a 01                	push   $0x1
  802f81:	ff 75 f4             	pushl  -0xc(%ebp)
  802f84:	e8 51 ff ff ff       	call   802eda <fd_close>
  802f89:	83 c4 10             	add    $0x10,%esp
  802f8c:	eb ec                	jmp    802f7a <close+0x19>

00802f8e <close_all>:

void
close_all(void)
{
  802f8e:	55                   	push   %ebp
  802f8f:	89 e5                	mov    %esp,%ebp
  802f91:	53                   	push   %ebx
  802f92:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802f95:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802f9a:	83 ec 0c             	sub    $0xc,%esp
  802f9d:	53                   	push   %ebx
  802f9e:	e8 be ff ff ff       	call   802f61 <close>
	for (i = 0; i < MAXFD; i++)
  802fa3:	83 c3 01             	add    $0x1,%ebx
  802fa6:	83 c4 10             	add    $0x10,%esp
  802fa9:	83 fb 20             	cmp    $0x20,%ebx
  802fac:	75 ec                	jne    802f9a <close_all+0xc>
}
  802fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fb1:	c9                   	leave  
  802fb2:	c3                   	ret    

00802fb3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802fb3:	55                   	push   %ebp
  802fb4:	89 e5                	mov    %esp,%ebp
  802fb6:	57                   	push   %edi
  802fb7:	56                   	push   %esi
  802fb8:	53                   	push   %ebx
  802fb9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802fbc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802fbf:	50                   	push   %eax
  802fc0:	ff 75 08             	pushl  0x8(%ebp)
  802fc3:	e8 6c fe ff ff       	call   802e34 <fd_lookup>
  802fc8:	89 c3                	mov    %eax,%ebx
  802fca:	83 c4 10             	add    $0x10,%esp
  802fcd:	85 c0                	test   %eax,%eax
  802fcf:	0f 88 81 00 00 00    	js     803056 <dup+0xa3>
		return r;
	close(newfdnum);
  802fd5:	83 ec 0c             	sub    $0xc,%esp
  802fd8:	ff 75 0c             	pushl  0xc(%ebp)
  802fdb:	e8 81 ff ff ff       	call   802f61 <close>

	newfd = INDEX2FD(newfdnum);
  802fe0:	8b 75 0c             	mov    0xc(%ebp),%esi
  802fe3:	c1 e6 0c             	shl    $0xc,%esi
  802fe6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802fec:	83 c4 04             	add    $0x4,%esp
  802fef:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ff2:	e8 d4 fd ff ff       	call   802dcb <fd2data>
  802ff7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802ff9:	89 34 24             	mov    %esi,(%esp)
  802ffc:	e8 ca fd ff ff       	call   802dcb <fd2data>
  803001:	83 c4 10             	add    $0x10,%esp
  803004:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803006:	89 d8                	mov    %ebx,%eax
  803008:	c1 e8 16             	shr    $0x16,%eax
  80300b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  803012:	a8 01                	test   $0x1,%al
  803014:	74 11                	je     803027 <dup+0x74>
  803016:	89 d8                	mov    %ebx,%eax
  803018:	c1 e8 0c             	shr    $0xc,%eax
  80301b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  803022:	f6 c2 01             	test   $0x1,%dl
  803025:	75 39                	jne    803060 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803027:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80302a:	89 d0                	mov    %edx,%eax
  80302c:	c1 e8 0c             	shr    $0xc,%eax
  80302f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803036:	83 ec 0c             	sub    $0xc,%esp
  803039:	25 07 0e 00 00       	and    $0xe07,%eax
  80303e:	50                   	push   %eax
  80303f:	56                   	push   %esi
  803040:	6a 00                	push   $0x0
  803042:	52                   	push   %edx
  803043:	6a 00                	push   $0x0
  803045:	e8 27 f7 ff ff       	call   802771 <sys_page_map>
  80304a:	89 c3                	mov    %eax,%ebx
  80304c:	83 c4 20             	add    $0x20,%esp
  80304f:	85 c0                	test   %eax,%eax
  803051:	78 31                	js     803084 <dup+0xd1>
		goto err;

	return newfdnum;
  803053:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  803056:	89 d8                	mov    %ebx,%eax
  803058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80305b:	5b                   	pop    %ebx
  80305c:	5e                   	pop    %esi
  80305d:	5f                   	pop    %edi
  80305e:	5d                   	pop    %ebp
  80305f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803060:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803067:	83 ec 0c             	sub    $0xc,%esp
  80306a:	25 07 0e 00 00       	and    $0xe07,%eax
  80306f:	50                   	push   %eax
  803070:	57                   	push   %edi
  803071:	6a 00                	push   $0x0
  803073:	53                   	push   %ebx
  803074:	6a 00                	push   $0x0
  803076:	e8 f6 f6 ff ff       	call   802771 <sys_page_map>
  80307b:	89 c3                	mov    %eax,%ebx
  80307d:	83 c4 20             	add    $0x20,%esp
  803080:	85 c0                	test   %eax,%eax
  803082:	79 a3                	jns    803027 <dup+0x74>
	sys_page_unmap(0, newfd);
  803084:	83 ec 08             	sub    $0x8,%esp
  803087:	56                   	push   %esi
  803088:	6a 00                	push   $0x0
  80308a:	e8 24 f7 ff ff       	call   8027b3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80308f:	83 c4 08             	add    $0x8,%esp
  803092:	57                   	push   %edi
  803093:	6a 00                	push   $0x0
  803095:	e8 19 f7 ff ff       	call   8027b3 <sys_page_unmap>
	return r;
  80309a:	83 c4 10             	add    $0x10,%esp
  80309d:	eb b7                	jmp    803056 <dup+0xa3>

0080309f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80309f:	55                   	push   %ebp
  8030a0:	89 e5                	mov    %esp,%ebp
  8030a2:	53                   	push   %ebx
  8030a3:	83 ec 1c             	sub    $0x1c,%esp
  8030a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8030ac:	50                   	push   %eax
  8030ad:	53                   	push   %ebx
  8030ae:	e8 81 fd ff ff       	call   802e34 <fd_lookup>
  8030b3:	83 c4 10             	add    $0x10,%esp
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	78 3f                	js     8030f9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030ba:	83 ec 08             	sub    $0x8,%esp
  8030bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030c0:	50                   	push   %eax
  8030c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c4:	ff 30                	pushl  (%eax)
  8030c6:	e8 b9 fd ff ff       	call   802e84 <dev_lookup>
  8030cb:	83 c4 10             	add    $0x10,%esp
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	78 27                	js     8030f9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8030d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d5:	8b 42 08             	mov    0x8(%edx),%eax
  8030d8:	83 e0 03             	and    $0x3,%eax
  8030db:	83 f8 01             	cmp    $0x1,%eax
  8030de:	74 1e                	je     8030fe <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e3:	8b 40 08             	mov    0x8(%eax),%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	74 35                	je     80311f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	ff 75 10             	pushl  0x10(%ebp)
  8030f0:	ff 75 0c             	pushl  0xc(%ebp)
  8030f3:	52                   	push   %edx
  8030f4:	ff d0                	call   *%eax
  8030f6:	83 c4 10             	add    $0x10,%esp
}
  8030f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030fc:	c9                   	leave  
  8030fd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8030fe:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  803103:	8b 40 48             	mov    0x48(%eax),%eax
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	53                   	push   %ebx
  80310a:	50                   	push   %eax
  80310b:	68 b4 44 80 00       	push   $0x8044b4
  803110:	e8 19 eb ff ff       	call   801c2e <cprintf>
		return -E_INVAL;
  803115:	83 c4 10             	add    $0x10,%esp
  803118:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80311d:	eb da                	jmp    8030f9 <read+0x5a>
		return -E_NOT_SUPP;
  80311f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803124:	eb d3                	jmp    8030f9 <read+0x5a>

00803126 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803126:	55                   	push   %ebp
  803127:	89 e5                	mov    %esp,%ebp
  803129:	57                   	push   %edi
  80312a:	56                   	push   %esi
  80312b:	53                   	push   %ebx
  80312c:	83 ec 0c             	sub    $0xc,%esp
  80312f:	8b 7d 08             	mov    0x8(%ebp),%edi
  803132:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803135:	bb 00 00 00 00       	mov    $0x0,%ebx
  80313a:	39 f3                	cmp    %esi,%ebx
  80313c:	73 23                	jae    803161 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	89 f0                	mov    %esi,%eax
  803143:	29 d8                	sub    %ebx,%eax
  803145:	50                   	push   %eax
  803146:	89 d8                	mov    %ebx,%eax
  803148:	03 45 0c             	add    0xc(%ebp),%eax
  80314b:	50                   	push   %eax
  80314c:	57                   	push   %edi
  80314d:	e8 4d ff ff ff       	call   80309f <read>
		if (m < 0)
  803152:	83 c4 10             	add    $0x10,%esp
  803155:	85 c0                	test   %eax,%eax
  803157:	78 06                	js     80315f <readn+0x39>
			return m;
		if (m == 0)
  803159:	74 06                	je     803161 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80315b:	01 c3                	add    %eax,%ebx
  80315d:	eb db                	jmp    80313a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80315f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  803161:	89 d8                	mov    %ebx,%eax
  803163:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803166:	5b                   	pop    %ebx
  803167:	5e                   	pop    %esi
  803168:	5f                   	pop    %edi
  803169:	5d                   	pop    %ebp
  80316a:	c3                   	ret    

0080316b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80316b:	55                   	push   %ebp
  80316c:	89 e5                	mov    %esp,%ebp
  80316e:	53                   	push   %ebx
  80316f:	83 ec 1c             	sub    $0x1c,%esp
  803172:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803175:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803178:	50                   	push   %eax
  803179:	53                   	push   %ebx
  80317a:	e8 b5 fc ff ff       	call   802e34 <fd_lookup>
  80317f:	83 c4 10             	add    $0x10,%esp
  803182:	85 c0                	test   %eax,%eax
  803184:	78 3a                	js     8031c0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803186:	83 ec 08             	sub    $0x8,%esp
  803189:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80318c:	50                   	push   %eax
  80318d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803190:	ff 30                	pushl  (%eax)
  803192:	e8 ed fc ff ff       	call   802e84 <dev_lookup>
  803197:	83 c4 10             	add    $0x10,%esp
  80319a:	85 c0                	test   %eax,%eax
  80319c:	78 22                	js     8031c0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80319e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8031a5:	74 1e                	je     8031c5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8031a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031aa:	8b 52 0c             	mov    0xc(%edx),%edx
  8031ad:	85 d2                	test   %edx,%edx
  8031af:	74 35                	je     8031e6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	ff 75 10             	pushl  0x10(%ebp)
  8031b7:	ff 75 0c             	pushl  0xc(%ebp)
  8031ba:	50                   	push   %eax
  8031bb:	ff d2                	call   *%edx
  8031bd:	83 c4 10             	add    $0x10,%esp
}
  8031c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031c3:	c9                   	leave  
  8031c4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8031c5:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8031ca:	8b 40 48             	mov    0x48(%eax),%eax
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	53                   	push   %ebx
  8031d1:	50                   	push   %eax
  8031d2:	68 d0 44 80 00       	push   $0x8044d0
  8031d7:	e8 52 ea ff ff       	call   801c2e <cprintf>
		return -E_INVAL;
  8031dc:	83 c4 10             	add    $0x10,%esp
  8031df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031e4:	eb da                	jmp    8031c0 <write+0x55>
		return -E_NOT_SUPP;
  8031e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8031eb:	eb d3                	jmp    8031c0 <write+0x55>

008031ed <seek>:

int
seek(int fdnum, off_t offset)
{
  8031ed:	55                   	push   %ebp
  8031ee:	89 e5                	mov    %esp,%ebp
  8031f0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031f6:	50                   	push   %eax
  8031f7:	ff 75 08             	pushl  0x8(%ebp)
  8031fa:	e8 35 fc ff ff       	call   802e34 <fd_lookup>
  8031ff:	83 c4 10             	add    $0x10,%esp
  803202:	85 c0                	test   %eax,%eax
  803204:	78 0e                	js     803214 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  803206:	8b 55 0c             	mov    0xc(%ebp),%edx
  803209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80320f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803214:	c9                   	leave  
  803215:	c3                   	ret    

00803216 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
  803219:	53                   	push   %ebx
  80321a:	83 ec 1c             	sub    $0x1c,%esp
  80321d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803220:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803223:	50                   	push   %eax
  803224:	53                   	push   %ebx
  803225:	e8 0a fc ff ff       	call   802e34 <fd_lookup>
  80322a:	83 c4 10             	add    $0x10,%esp
  80322d:	85 c0                	test   %eax,%eax
  80322f:	78 37                	js     803268 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803231:	83 ec 08             	sub    $0x8,%esp
  803234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803237:	50                   	push   %eax
  803238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323b:	ff 30                	pushl  (%eax)
  80323d:	e8 42 fc ff ff       	call   802e84 <dev_lookup>
  803242:	83 c4 10             	add    $0x10,%esp
  803245:	85 c0                	test   %eax,%eax
  803247:	78 1f                	js     803268 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  803250:	74 1b                	je     80326d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  803252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803255:	8b 52 18             	mov    0x18(%edx),%edx
  803258:	85 d2                	test   %edx,%edx
  80325a:	74 32                	je     80328e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80325c:	83 ec 08             	sub    $0x8,%esp
  80325f:	ff 75 0c             	pushl  0xc(%ebp)
  803262:	50                   	push   %eax
  803263:	ff d2                	call   *%edx
  803265:	83 c4 10             	add    $0x10,%esp
}
  803268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80326b:	c9                   	leave  
  80326c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80326d:	a1 0c a0 80 00       	mov    0x80a00c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803272:	8b 40 48             	mov    0x48(%eax),%eax
  803275:	83 ec 04             	sub    $0x4,%esp
  803278:	53                   	push   %ebx
  803279:	50                   	push   %eax
  80327a:	68 90 44 80 00       	push   $0x804490
  80327f:	e8 aa e9 ff ff       	call   801c2e <cprintf>
		return -E_INVAL;
  803284:	83 c4 10             	add    $0x10,%esp
  803287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80328c:	eb da                	jmp    803268 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80328e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803293:	eb d3                	jmp    803268 <ftruncate+0x52>

00803295 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803295:	55                   	push   %ebp
  803296:	89 e5                	mov    %esp,%ebp
  803298:	53                   	push   %ebx
  803299:	83 ec 1c             	sub    $0x1c,%esp
  80329c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80329f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8032a2:	50                   	push   %eax
  8032a3:	ff 75 08             	pushl  0x8(%ebp)
  8032a6:	e8 89 fb ff ff       	call   802e34 <fd_lookup>
  8032ab:	83 c4 10             	add    $0x10,%esp
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	78 4b                	js     8032fd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032b2:	83 ec 08             	sub    $0x8,%esp
  8032b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032b8:	50                   	push   %eax
  8032b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bc:	ff 30                	pushl  (%eax)
  8032be:	e8 c1 fb ff ff       	call   802e84 <dev_lookup>
  8032c3:	83 c4 10             	add    $0x10,%esp
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	78 33                	js     8032fd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8032d1:	74 2f                	je     803302 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8032d3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8032d6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8032dd:	00 00 00 
	stat->st_isdir = 0;
  8032e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8032e7:	00 00 00 
	stat->st_dev = dev;
  8032ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8032f0:	83 ec 08             	sub    $0x8,%esp
  8032f3:	53                   	push   %ebx
  8032f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f7:	ff 50 14             	call   *0x14(%eax)
  8032fa:	83 c4 10             	add    $0x10,%esp
}
  8032fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803300:	c9                   	leave  
  803301:	c3                   	ret    
		return -E_NOT_SUPP;
  803302:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803307:	eb f4                	jmp    8032fd <fstat+0x68>

00803309 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803309:	55                   	push   %ebp
  80330a:	89 e5                	mov    %esp,%ebp
  80330c:	56                   	push   %esi
  80330d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80330e:	83 ec 08             	sub    $0x8,%esp
  803311:	6a 00                	push   $0x0
  803313:	ff 75 08             	pushl  0x8(%ebp)
  803316:	e8 c0 f9 ff ff       	call   802cdb <open>
  80331b:	89 c3                	mov    %eax,%ebx
  80331d:	83 c4 10             	add    $0x10,%esp
  803320:	85 c0                	test   %eax,%eax
  803322:	78 1b                	js     80333f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  803324:	83 ec 08             	sub    $0x8,%esp
  803327:	ff 75 0c             	pushl  0xc(%ebp)
  80332a:	50                   	push   %eax
  80332b:	e8 65 ff ff ff       	call   803295 <fstat>
  803330:	89 c6                	mov    %eax,%esi
	close(fd);
  803332:	89 1c 24             	mov    %ebx,(%esp)
  803335:	e8 27 fc ff ff       	call   802f61 <close>
	return r;
  80333a:	83 c4 10             	add    $0x10,%esp
  80333d:	89 f3                	mov    %esi,%ebx
}
  80333f:	89 d8                	mov    %ebx,%eax
  803341:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803344:	5b                   	pop    %ebx
  803345:	5e                   	pop    %esi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    

00803348 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803348:	55                   	push   %ebp
  803349:	89 e5                	mov    %esp,%ebp
  80334b:	56                   	push   %esi
  80334c:	53                   	push   %ebx
  80334d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803350:	83 ec 0c             	sub    $0xc,%esp
  803353:	ff 75 08             	pushl  0x8(%ebp)
  803356:	e8 70 fa ff ff       	call   802dcb <fd2data>
  80335b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80335d:	83 c4 08             	add    $0x8,%esp
  803360:	68 00 45 80 00       	push   $0x804500
  803365:	53                   	push   %ebx
  803366:	e8 d1 ef ff ff       	call   80233c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80336b:	8b 46 04             	mov    0x4(%esi),%eax
  80336e:	2b 06                	sub    (%esi),%eax
  803370:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803376:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80337d:	00 00 00 
	stat->st_dev = &devpipe;
  803380:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  803387:	90 80 00 
	return 0;
}
  80338a:	b8 00 00 00 00       	mov    $0x0,%eax
  80338f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803392:	5b                   	pop    %ebx
  803393:	5e                   	pop    %esi
  803394:	5d                   	pop    %ebp
  803395:	c3                   	ret    

00803396 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
  803399:	53                   	push   %ebx
  80339a:	83 ec 0c             	sub    $0xc,%esp
  80339d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8033a0:	53                   	push   %ebx
  8033a1:	6a 00                	push   $0x0
  8033a3:	e8 0b f4 ff ff       	call   8027b3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8033a8:	89 1c 24             	mov    %ebx,(%esp)
  8033ab:	e8 1b fa ff ff       	call   802dcb <fd2data>
  8033b0:	83 c4 08             	add    $0x8,%esp
  8033b3:	50                   	push   %eax
  8033b4:	6a 00                	push   $0x0
  8033b6:	e8 f8 f3 ff ff       	call   8027b3 <sys_page_unmap>
}
  8033bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033be:	c9                   	leave  
  8033bf:	c3                   	ret    

008033c0 <_pipeisclosed>:
{
  8033c0:	55                   	push   %ebp
  8033c1:	89 e5                	mov    %esp,%ebp
  8033c3:	57                   	push   %edi
  8033c4:	56                   	push   %esi
  8033c5:	53                   	push   %ebx
  8033c6:	83 ec 1c             	sub    $0x1c,%esp
  8033c9:	89 c7                	mov    %eax,%edi
  8033cb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8033cd:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8033d2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8033d5:	83 ec 0c             	sub    $0xc,%esp
  8033d8:	57                   	push   %edi
  8033d9:	e8 a2 f9 ff ff       	call   802d80 <pageref>
  8033de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8033e1:	89 34 24             	mov    %esi,(%esp)
  8033e4:	e8 97 f9 ff ff       	call   802d80 <pageref>
		nn = thisenv->env_runs;
  8033e9:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8033ef:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8033f2:	83 c4 10             	add    $0x10,%esp
  8033f5:	39 cb                	cmp    %ecx,%ebx
  8033f7:	74 1b                	je     803414 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8033f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8033fc:	75 cf                	jne    8033cd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8033fe:	8b 42 58             	mov    0x58(%edx),%eax
  803401:	6a 01                	push   $0x1
  803403:	50                   	push   %eax
  803404:	53                   	push   %ebx
  803405:	68 07 45 80 00       	push   $0x804507
  80340a:	e8 1f e8 ff ff       	call   801c2e <cprintf>
  80340f:	83 c4 10             	add    $0x10,%esp
  803412:	eb b9                	jmp    8033cd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803414:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803417:	0f 94 c0             	sete   %al
  80341a:	0f b6 c0             	movzbl %al,%eax
}
  80341d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803420:	5b                   	pop    %ebx
  803421:	5e                   	pop    %esi
  803422:	5f                   	pop    %edi
  803423:	5d                   	pop    %ebp
  803424:	c3                   	ret    

00803425 <devpipe_write>:
{
  803425:	55                   	push   %ebp
  803426:	89 e5                	mov    %esp,%ebp
  803428:	57                   	push   %edi
  803429:	56                   	push   %esi
  80342a:	53                   	push   %ebx
  80342b:	83 ec 28             	sub    $0x28,%esp
  80342e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803431:	56                   	push   %esi
  803432:	e8 94 f9 ff ff       	call   802dcb <fd2data>
  803437:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803439:	83 c4 10             	add    $0x10,%esp
  80343c:	bf 00 00 00 00       	mov    $0x0,%edi
  803441:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803444:	74 4f                	je     803495 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803446:	8b 43 04             	mov    0x4(%ebx),%eax
  803449:	8b 0b                	mov    (%ebx),%ecx
  80344b:	8d 51 20             	lea    0x20(%ecx),%edx
  80344e:	39 d0                	cmp    %edx,%eax
  803450:	72 14                	jb     803466 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803452:	89 da                	mov    %ebx,%edx
  803454:	89 f0                	mov    %esi,%eax
  803456:	e8 65 ff ff ff       	call   8033c0 <_pipeisclosed>
  80345b:	85 c0                	test   %eax,%eax
  80345d:	75 3b                	jne    80349a <devpipe_write+0x75>
			sys_yield();
  80345f:	e8 ab f2 ff ff       	call   80270f <sys_yield>
  803464:	eb e0                	jmp    803446 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803466:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803469:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80346d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803470:	89 c2                	mov    %eax,%edx
  803472:	c1 fa 1f             	sar    $0x1f,%edx
  803475:	89 d1                	mov    %edx,%ecx
  803477:	c1 e9 1b             	shr    $0x1b,%ecx
  80347a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80347d:	83 e2 1f             	and    $0x1f,%edx
  803480:	29 ca                	sub    %ecx,%edx
  803482:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803486:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80348a:	83 c0 01             	add    $0x1,%eax
  80348d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803490:	83 c7 01             	add    $0x1,%edi
  803493:	eb ac                	jmp    803441 <devpipe_write+0x1c>
	return i;
  803495:	8b 45 10             	mov    0x10(%ebp),%eax
  803498:	eb 05                	jmp    80349f <devpipe_write+0x7a>
				return 0;
  80349a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80349f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8034a2:	5b                   	pop    %ebx
  8034a3:	5e                   	pop    %esi
  8034a4:	5f                   	pop    %edi
  8034a5:	5d                   	pop    %ebp
  8034a6:	c3                   	ret    

008034a7 <devpipe_read>:
{
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
  8034aa:	57                   	push   %edi
  8034ab:	56                   	push   %esi
  8034ac:	53                   	push   %ebx
  8034ad:	83 ec 18             	sub    $0x18,%esp
  8034b0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8034b3:	57                   	push   %edi
  8034b4:	e8 12 f9 ff ff       	call   802dcb <fd2data>
  8034b9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8034bb:	83 c4 10             	add    $0x10,%esp
  8034be:	be 00 00 00 00       	mov    $0x0,%esi
  8034c3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8034c6:	75 14                	jne    8034dc <devpipe_read+0x35>
	return i;
  8034c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8034cb:	eb 02                	jmp    8034cf <devpipe_read+0x28>
				return i;
  8034cd:	89 f0                	mov    %esi,%eax
}
  8034cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8034d2:	5b                   	pop    %ebx
  8034d3:	5e                   	pop    %esi
  8034d4:	5f                   	pop    %edi
  8034d5:	5d                   	pop    %ebp
  8034d6:	c3                   	ret    
			sys_yield();
  8034d7:	e8 33 f2 ff ff       	call   80270f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8034dc:	8b 03                	mov    (%ebx),%eax
  8034de:	3b 43 04             	cmp    0x4(%ebx),%eax
  8034e1:	75 18                	jne    8034fb <devpipe_read+0x54>
			if (i > 0)
  8034e3:	85 f6                	test   %esi,%esi
  8034e5:	75 e6                	jne    8034cd <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8034e7:	89 da                	mov    %ebx,%edx
  8034e9:	89 f8                	mov    %edi,%eax
  8034eb:	e8 d0 fe ff ff       	call   8033c0 <_pipeisclosed>
  8034f0:	85 c0                	test   %eax,%eax
  8034f2:	74 e3                	je     8034d7 <devpipe_read+0x30>
				return 0;
  8034f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f9:	eb d4                	jmp    8034cf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8034fb:	99                   	cltd   
  8034fc:	c1 ea 1b             	shr    $0x1b,%edx
  8034ff:	01 d0                	add    %edx,%eax
  803501:	83 e0 1f             	and    $0x1f,%eax
  803504:	29 d0                	sub    %edx,%eax
  803506:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80350b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80350e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803511:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803514:	83 c6 01             	add    $0x1,%esi
  803517:	eb aa                	jmp    8034c3 <devpipe_read+0x1c>

00803519 <pipe>:
{
  803519:	55                   	push   %ebp
  80351a:	89 e5                	mov    %esp,%ebp
  80351c:	56                   	push   %esi
  80351d:	53                   	push   %ebx
  80351e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803521:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803524:	50                   	push   %eax
  803525:	e8 b8 f8 ff ff       	call   802de2 <fd_alloc>
  80352a:	89 c3                	mov    %eax,%ebx
  80352c:	83 c4 10             	add    $0x10,%esp
  80352f:	85 c0                	test   %eax,%eax
  803531:	0f 88 23 01 00 00    	js     80365a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803537:	83 ec 04             	sub    $0x4,%esp
  80353a:	68 07 04 00 00       	push   $0x407
  80353f:	ff 75 f4             	pushl  -0xc(%ebp)
  803542:	6a 00                	push   $0x0
  803544:	e8 e5 f1 ff ff       	call   80272e <sys_page_alloc>
  803549:	89 c3                	mov    %eax,%ebx
  80354b:	83 c4 10             	add    $0x10,%esp
  80354e:	85 c0                	test   %eax,%eax
  803550:	0f 88 04 01 00 00    	js     80365a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  803556:	83 ec 0c             	sub    $0xc,%esp
  803559:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80355c:	50                   	push   %eax
  80355d:	e8 80 f8 ff ff       	call   802de2 <fd_alloc>
  803562:	89 c3                	mov    %eax,%ebx
  803564:	83 c4 10             	add    $0x10,%esp
  803567:	85 c0                	test   %eax,%eax
  803569:	0f 88 db 00 00 00    	js     80364a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80356f:	83 ec 04             	sub    $0x4,%esp
  803572:	68 07 04 00 00       	push   $0x407
  803577:	ff 75 f0             	pushl  -0x10(%ebp)
  80357a:	6a 00                	push   $0x0
  80357c:	e8 ad f1 ff ff       	call   80272e <sys_page_alloc>
  803581:	89 c3                	mov    %eax,%ebx
  803583:	83 c4 10             	add    $0x10,%esp
  803586:	85 c0                	test   %eax,%eax
  803588:	0f 88 bc 00 00 00    	js     80364a <pipe+0x131>
	va = fd2data(fd0);
  80358e:	83 ec 0c             	sub    $0xc,%esp
  803591:	ff 75 f4             	pushl  -0xc(%ebp)
  803594:	e8 32 f8 ff ff       	call   802dcb <fd2data>
  803599:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80359b:	83 c4 0c             	add    $0xc,%esp
  80359e:	68 07 04 00 00       	push   $0x407
  8035a3:	50                   	push   %eax
  8035a4:	6a 00                	push   $0x0
  8035a6:	e8 83 f1 ff ff       	call   80272e <sys_page_alloc>
  8035ab:	89 c3                	mov    %eax,%ebx
  8035ad:	83 c4 10             	add    $0x10,%esp
  8035b0:	85 c0                	test   %eax,%eax
  8035b2:	0f 88 82 00 00 00    	js     80363a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035b8:	83 ec 0c             	sub    $0xc,%esp
  8035bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8035be:	e8 08 f8 ff ff       	call   802dcb <fd2data>
  8035c3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8035ca:	50                   	push   %eax
  8035cb:	6a 00                	push   $0x0
  8035cd:	56                   	push   %esi
  8035ce:	6a 00                	push   $0x0
  8035d0:	e8 9c f1 ff ff       	call   802771 <sys_page_map>
  8035d5:	89 c3                	mov    %eax,%ebx
  8035d7:	83 c4 20             	add    $0x20,%esp
  8035da:	85 c0                	test   %eax,%eax
  8035dc:	78 4e                	js     80362c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8035de:	a1 80 90 80 00       	mov    0x809080,%eax
  8035e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8035e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035eb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8035f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8035f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803601:	83 ec 0c             	sub    $0xc,%esp
  803604:	ff 75 f4             	pushl  -0xc(%ebp)
  803607:	e8 af f7 ff ff       	call   802dbb <fd2num>
  80360c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80360f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803611:	83 c4 04             	add    $0x4,%esp
  803614:	ff 75 f0             	pushl  -0x10(%ebp)
  803617:	e8 9f f7 ff ff       	call   802dbb <fd2num>
  80361c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80361f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803622:	83 c4 10             	add    $0x10,%esp
  803625:	bb 00 00 00 00       	mov    $0x0,%ebx
  80362a:	eb 2e                	jmp    80365a <pipe+0x141>
	sys_page_unmap(0, va);
  80362c:	83 ec 08             	sub    $0x8,%esp
  80362f:	56                   	push   %esi
  803630:	6a 00                	push   $0x0
  803632:	e8 7c f1 ff ff       	call   8027b3 <sys_page_unmap>
  803637:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80363a:	83 ec 08             	sub    $0x8,%esp
  80363d:	ff 75 f0             	pushl  -0x10(%ebp)
  803640:	6a 00                	push   $0x0
  803642:	e8 6c f1 ff ff       	call   8027b3 <sys_page_unmap>
  803647:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80364a:	83 ec 08             	sub    $0x8,%esp
  80364d:	ff 75 f4             	pushl  -0xc(%ebp)
  803650:	6a 00                	push   $0x0
  803652:	e8 5c f1 ff ff       	call   8027b3 <sys_page_unmap>
  803657:	83 c4 10             	add    $0x10,%esp
}
  80365a:	89 d8                	mov    %ebx,%eax
  80365c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80365f:	5b                   	pop    %ebx
  803660:	5e                   	pop    %esi
  803661:	5d                   	pop    %ebp
  803662:	c3                   	ret    

00803663 <pipeisclosed>:
{
  803663:	55                   	push   %ebp
  803664:	89 e5                	mov    %esp,%ebp
  803666:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803669:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80366c:	50                   	push   %eax
  80366d:	ff 75 08             	pushl  0x8(%ebp)
  803670:	e8 bf f7 ff ff       	call   802e34 <fd_lookup>
  803675:	83 c4 10             	add    $0x10,%esp
  803678:	85 c0                	test   %eax,%eax
  80367a:	78 18                	js     803694 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80367c:	83 ec 0c             	sub    $0xc,%esp
  80367f:	ff 75 f4             	pushl  -0xc(%ebp)
  803682:	e8 44 f7 ff ff       	call   802dcb <fd2data>
	return _pipeisclosed(fd, p);
  803687:	89 c2                	mov    %eax,%edx
  803689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368c:	e8 2f fd ff ff       	call   8033c0 <_pipeisclosed>
  803691:	83 c4 10             	add    $0x10,%esp
}
  803694:	c9                   	leave  
  803695:	c3                   	ret    

00803696 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  803696:	b8 00 00 00 00       	mov    $0x0,%eax
  80369b:	c3                   	ret    

0080369c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80369c:	55                   	push   %ebp
  80369d:	89 e5                	mov    %esp,%ebp
  80369f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8036a2:	68 1f 45 80 00       	push   $0x80451f
  8036a7:	ff 75 0c             	pushl  0xc(%ebp)
  8036aa:	e8 8d ec ff ff       	call   80233c <strcpy>
	return 0;
}
  8036af:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b4:	c9                   	leave  
  8036b5:	c3                   	ret    

008036b6 <devcons_write>:
{
  8036b6:	55                   	push   %ebp
  8036b7:	89 e5                	mov    %esp,%ebp
  8036b9:	57                   	push   %edi
  8036ba:	56                   	push   %esi
  8036bb:	53                   	push   %ebx
  8036bc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8036c2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8036c7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8036cd:	3b 75 10             	cmp    0x10(%ebp),%esi
  8036d0:	73 31                	jae    803703 <devcons_write+0x4d>
		m = n - tot;
  8036d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8036d5:	29 f3                	sub    %esi,%ebx
  8036d7:	83 fb 7f             	cmp    $0x7f,%ebx
  8036da:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8036df:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8036e2:	83 ec 04             	sub    $0x4,%esp
  8036e5:	53                   	push   %ebx
  8036e6:	89 f0                	mov    %esi,%eax
  8036e8:	03 45 0c             	add    0xc(%ebp),%eax
  8036eb:	50                   	push   %eax
  8036ec:	57                   	push   %edi
  8036ed:	e8 d8 ed ff ff       	call   8024ca <memmove>
		sys_cputs(buf, m);
  8036f2:	83 c4 08             	add    $0x8,%esp
  8036f5:	53                   	push   %ebx
  8036f6:	57                   	push   %edi
  8036f7:	e8 76 ef ff ff       	call   802672 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8036fc:	01 de                	add    %ebx,%esi
  8036fe:	83 c4 10             	add    $0x10,%esp
  803701:	eb ca                	jmp    8036cd <devcons_write+0x17>
}
  803703:	89 f0                	mov    %esi,%eax
  803705:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803708:	5b                   	pop    %ebx
  803709:	5e                   	pop    %esi
  80370a:	5f                   	pop    %edi
  80370b:	5d                   	pop    %ebp
  80370c:	c3                   	ret    

0080370d <devcons_read>:
{
  80370d:	55                   	push   %ebp
  80370e:	89 e5                	mov    %esp,%ebp
  803710:	83 ec 08             	sub    $0x8,%esp
  803713:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803718:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80371c:	74 21                	je     80373f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80371e:	e8 6d ef ff ff       	call   802690 <sys_cgetc>
  803723:	85 c0                	test   %eax,%eax
  803725:	75 07                	jne    80372e <devcons_read+0x21>
		sys_yield();
  803727:	e8 e3 ef ff ff       	call   80270f <sys_yield>
  80372c:	eb f0                	jmp    80371e <devcons_read+0x11>
	if (c < 0)
  80372e:	78 0f                	js     80373f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  803730:	83 f8 04             	cmp    $0x4,%eax
  803733:	74 0c                	je     803741 <devcons_read+0x34>
	*(char*)vbuf = c;
  803735:	8b 55 0c             	mov    0xc(%ebp),%edx
  803738:	88 02                	mov    %al,(%edx)
	return 1;
  80373a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80373f:	c9                   	leave  
  803740:	c3                   	ret    
		return 0;
  803741:	b8 00 00 00 00       	mov    $0x0,%eax
  803746:	eb f7                	jmp    80373f <devcons_read+0x32>

00803748 <cputchar>:
{
  803748:	55                   	push   %ebp
  803749:	89 e5                	mov    %esp,%ebp
  80374b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803754:	6a 01                	push   $0x1
  803756:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803759:	50                   	push   %eax
  80375a:	e8 13 ef ff ff       	call   802672 <sys_cputs>
}
  80375f:	83 c4 10             	add    $0x10,%esp
  803762:	c9                   	leave  
  803763:	c3                   	ret    

00803764 <getchar>:
{
  803764:	55                   	push   %ebp
  803765:	89 e5                	mov    %esp,%ebp
  803767:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80376a:	6a 01                	push   $0x1
  80376c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80376f:	50                   	push   %eax
  803770:	6a 00                	push   $0x0
  803772:	e8 28 f9 ff ff       	call   80309f <read>
	if (r < 0)
  803777:	83 c4 10             	add    $0x10,%esp
  80377a:	85 c0                	test   %eax,%eax
  80377c:	78 06                	js     803784 <getchar+0x20>
	if (r < 1)
  80377e:	74 06                	je     803786 <getchar+0x22>
	return c;
  803780:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803784:	c9                   	leave  
  803785:	c3                   	ret    
		return -E_EOF;
  803786:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80378b:	eb f7                	jmp    803784 <getchar+0x20>

0080378d <iscons>:
{
  80378d:	55                   	push   %ebp
  80378e:	89 e5                	mov    %esp,%ebp
  803790:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803793:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803796:	50                   	push   %eax
  803797:	ff 75 08             	pushl  0x8(%ebp)
  80379a:	e8 95 f6 ff ff       	call   802e34 <fd_lookup>
  80379f:	83 c4 10             	add    $0x10,%esp
  8037a2:	85 c0                	test   %eax,%eax
  8037a4:	78 11                	js     8037b7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8037a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a9:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  8037af:	39 10                	cmp    %edx,(%eax)
  8037b1:	0f 94 c0             	sete   %al
  8037b4:	0f b6 c0             	movzbl %al,%eax
}
  8037b7:	c9                   	leave  
  8037b8:	c3                   	ret    

008037b9 <opencons>:
{
  8037b9:	55                   	push   %ebp
  8037ba:	89 e5                	mov    %esp,%ebp
  8037bc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8037bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037c2:	50                   	push   %eax
  8037c3:	e8 1a f6 ff ff       	call   802de2 <fd_alloc>
  8037c8:	83 c4 10             	add    $0x10,%esp
  8037cb:	85 c0                	test   %eax,%eax
  8037cd:	78 3a                	js     803809 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8037cf:	83 ec 04             	sub    $0x4,%esp
  8037d2:	68 07 04 00 00       	push   $0x407
  8037d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8037da:	6a 00                	push   $0x0
  8037dc:	e8 4d ef ff ff       	call   80272e <sys_page_alloc>
  8037e1:	83 c4 10             	add    $0x10,%esp
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	78 21                	js     803809 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8037e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037eb:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  8037f1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8037fd:	83 ec 0c             	sub    $0xc,%esp
  803800:	50                   	push   %eax
  803801:	e8 b5 f5 ff ff       	call   802dbb <fd2num>
  803806:	83 c4 10             	add    $0x10,%esp
}
  803809:	c9                   	leave  
  80380a:	c3                   	ret    
  80380b:	66 90                	xchg   %ax,%ax
  80380d:	66 90                	xchg   %ax,%ax
  80380f:	90                   	nop

00803810 <__udivdi3>:
  803810:	55                   	push   %ebp
  803811:	57                   	push   %edi
  803812:	56                   	push   %esi
  803813:	53                   	push   %ebx
  803814:	83 ec 1c             	sub    $0x1c,%esp
  803817:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80381b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80381f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803823:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803827:	85 d2                	test   %edx,%edx
  803829:	75 4d                	jne    803878 <__udivdi3+0x68>
  80382b:	39 f3                	cmp    %esi,%ebx
  80382d:	76 19                	jbe    803848 <__udivdi3+0x38>
  80382f:	31 ff                	xor    %edi,%edi
  803831:	89 e8                	mov    %ebp,%eax
  803833:	89 f2                	mov    %esi,%edx
  803835:	f7 f3                	div    %ebx
  803837:	89 fa                	mov    %edi,%edx
  803839:	83 c4 1c             	add    $0x1c,%esp
  80383c:	5b                   	pop    %ebx
  80383d:	5e                   	pop    %esi
  80383e:	5f                   	pop    %edi
  80383f:	5d                   	pop    %ebp
  803840:	c3                   	ret    
  803841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803848:	89 d9                	mov    %ebx,%ecx
  80384a:	85 db                	test   %ebx,%ebx
  80384c:	75 0b                	jne    803859 <__udivdi3+0x49>
  80384e:	b8 01 00 00 00       	mov    $0x1,%eax
  803853:	31 d2                	xor    %edx,%edx
  803855:	f7 f3                	div    %ebx
  803857:	89 c1                	mov    %eax,%ecx
  803859:	31 d2                	xor    %edx,%edx
  80385b:	89 f0                	mov    %esi,%eax
  80385d:	f7 f1                	div    %ecx
  80385f:	89 c6                	mov    %eax,%esi
  803861:	89 e8                	mov    %ebp,%eax
  803863:	89 f7                	mov    %esi,%edi
  803865:	f7 f1                	div    %ecx
  803867:	89 fa                	mov    %edi,%edx
  803869:	83 c4 1c             	add    $0x1c,%esp
  80386c:	5b                   	pop    %ebx
  80386d:	5e                   	pop    %esi
  80386e:	5f                   	pop    %edi
  80386f:	5d                   	pop    %ebp
  803870:	c3                   	ret    
  803871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803878:	39 f2                	cmp    %esi,%edx
  80387a:	77 1c                	ja     803898 <__udivdi3+0x88>
  80387c:	0f bd fa             	bsr    %edx,%edi
  80387f:	83 f7 1f             	xor    $0x1f,%edi
  803882:	75 2c                	jne    8038b0 <__udivdi3+0xa0>
  803884:	39 f2                	cmp    %esi,%edx
  803886:	72 06                	jb     80388e <__udivdi3+0x7e>
  803888:	31 c0                	xor    %eax,%eax
  80388a:	39 eb                	cmp    %ebp,%ebx
  80388c:	77 a9                	ja     803837 <__udivdi3+0x27>
  80388e:	b8 01 00 00 00       	mov    $0x1,%eax
  803893:	eb a2                	jmp    803837 <__udivdi3+0x27>
  803895:	8d 76 00             	lea    0x0(%esi),%esi
  803898:	31 ff                	xor    %edi,%edi
  80389a:	31 c0                	xor    %eax,%eax
  80389c:	89 fa                	mov    %edi,%edx
  80389e:	83 c4 1c             	add    $0x1c,%esp
  8038a1:	5b                   	pop    %ebx
  8038a2:	5e                   	pop    %esi
  8038a3:	5f                   	pop    %edi
  8038a4:	5d                   	pop    %ebp
  8038a5:	c3                   	ret    
  8038a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8038ad:	8d 76 00             	lea    0x0(%esi),%esi
  8038b0:	89 f9                	mov    %edi,%ecx
  8038b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8038b7:	29 f8                	sub    %edi,%eax
  8038b9:	d3 e2                	shl    %cl,%edx
  8038bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8038bf:	89 c1                	mov    %eax,%ecx
  8038c1:	89 da                	mov    %ebx,%edx
  8038c3:	d3 ea                	shr    %cl,%edx
  8038c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8038c9:	09 d1                	or     %edx,%ecx
  8038cb:	89 f2                	mov    %esi,%edx
  8038cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038d1:	89 f9                	mov    %edi,%ecx
  8038d3:	d3 e3                	shl    %cl,%ebx
  8038d5:	89 c1                	mov    %eax,%ecx
  8038d7:	d3 ea                	shr    %cl,%edx
  8038d9:	89 f9                	mov    %edi,%ecx
  8038db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8038df:	89 eb                	mov    %ebp,%ebx
  8038e1:	d3 e6                	shl    %cl,%esi
  8038e3:	89 c1                	mov    %eax,%ecx
  8038e5:	d3 eb                	shr    %cl,%ebx
  8038e7:	09 de                	or     %ebx,%esi
  8038e9:	89 f0                	mov    %esi,%eax
  8038eb:	f7 74 24 08          	divl   0x8(%esp)
  8038ef:	89 d6                	mov    %edx,%esi
  8038f1:	89 c3                	mov    %eax,%ebx
  8038f3:	f7 64 24 0c          	mull   0xc(%esp)
  8038f7:	39 d6                	cmp    %edx,%esi
  8038f9:	72 15                	jb     803910 <__udivdi3+0x100>
  8038fb:	89 f9                	mov    %edi,%ecx
  8038fd:	d3 e5                	shl    %cl,%ebp
  8038ff:	39 c5                	cmp    %eax,%ebp
  803901:	73 04                	jae    803907 <__udivdi3+0xf7>
  803903:	39 d6                	cmp    %edx,%esi
  803905:	74 09                	je     803910 <__udivdi3+0x100>
  803907:	89 d8                	mov    %ebx,%eax
  803909:	31 ff                	xor    %edi,%edi
  80390b:	e9 27 ff ff ff       	jmp    803837 <__udivdi3+0x27>
  803910:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803913:	31 ff                	xor    %edi,%edi
  803915:	e9 1d ff ff ff       	jmp    803837 <__udivdi3+0x27>
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	66 90                	xchg   %ax,%ax
  80391e:	66 90                	xchg   %ax,%ax

00803920 <__umoddi3>:
  803920:	55                   	push   %ebp
  803921:	57                   	push   %edi
  803922:	56                   	push   %esi
  803923:	53                   	push   %ebx
  803924:	83 ec 1c             	sub    $0x1c,%esp
  803927:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80392b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80392f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803933:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803937:	89 da                	mov    %ebx,%edx
  803939:	85 c0                	test   %eax,%eax
  80393b:	75 43                	jne    803980 <__umoddi3+0x60>
  80393d:	39 df                	cmp    %ebx,%edi
  80393f:	76 17                	jbe    803958 <__umoddi3+0x38>
  803941:	89 f0                	mov    %esi,%eax
  803943:	f7 f7                	div    %edi
  803945:	89 d0                	mov    %edx,%eax
  803947:	31 d2                	xor    %edx,%edx
  803949:	83 c4 1c             	add    $0x1c,%esp
  80394c:	5b                   	pop    %ebx
  80394d:	5e                   	pop    %esi
  80394e:	5f                   	pop    %edi
  80394f:	5d                   	pop    %ebp
  803950:	c3                   	ret    
  803951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803958:	89 fd                	mov    %edi,%ebp
  80395a:	85 ff                	test   %edi,%edi
  80395c:	75 0b                	jne    803969 <__umoddi3+0x49>
  80395e:	b8 01 00 00 00       	mov    $0x1,%eax
  803963:	31 d2                	xor    %edx,%edx
  803965:	f7 f7                	div    %edi
  803967:	89 c5                	mov    %eax,%ebp
  803969:	89 d8                	mov    %ebx,%eax
  80396b:	31 d2                	xor    %edx,%edx
  80396d:	f7 f5                	div    %ebp
  80396f:	89 f0                	mov    %esi,%eax
  803971:	f7 f5                	div    %ebp
  803973:	89 d0                	mov    %edx,%eax
  803975:	eb d0                	jmp    803947 <__umoddi3+0x27>
  803977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80397e:	66 90                	xchg   %ax,%ax
  803980:	89 f1                	mov    %esi,%ecx
  803982:	39 d8                	cmp    %ebx,%eax
  803984:	76 0a                	jbe    803990 <__umoddi3+0x70>
  803986:	89 f0                	mov    %esi,%eax
  803988:	83 c4 1c             	add    $0x1c,%esp
  80398b:	5b                   	pop    %ebx
  80398c:	5e                   	pop    %esi
  80398d:	5f                   	pop    %edi
  80398e:	5d                   	pop    %ebp
  80398f:	c3                   	ret    
  803990:	0f bd e8             	bsr    %eax,%ebp
  803993:	83 f5 1f             	xor    $0x1f,%ebp
  803996:	75 20                	jne    8039b8 <__umoddi3+0x98>
  803998:	39 d8                	cmp    %ebx,%eax
  80399a:	0f 82 b0 00 00 00    	jb     803a50 <__umoddi3+0x130>
  8039a0:	39 f7                	cmp    %esi,%edi
  8039a2:	0f 86 a8 00 00 00    	jbe    803a50 <__umoddi3+0x130>
  8039a8:	89 c8                	mov    %ecx,%eax
  8039aa:	83 c4 1c             	add    $0x1c,%esp
  8039ad:	5b                   	pop    %ebx
  8039ae:	5e                   	pop    %esi
  8039af:	5f                   	pop    %edi
  8039b0:	5d                   	pop    %ebp
  8039b1:	c3                   	ret    
  8039b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8039b8:	89 e9                	mov    %ebp,%ecx
  8039ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8039bf:	29 ea                	sub    %ebp,%edx
  8039c1:	d3 e0                	shl    %cl,%eax
  8039c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8039c7:	89 d1                	mov    %edx,%ecx
  8039c9:	89 f8                	mov    %edi,%eax
  8039cb:	d3 e8                	shr    %cl,%eax
  8039cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8039d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039d9:	09 c1                	or     %eax,%ecx
  8039db:	89 d8                	mov    %ebx,%eax
  8039dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039e1:	89 e9                	mov    %ebp,%ecx
  8039e3:	d3 e7                	shl    %cl,%edi
  8039e5:	89 d1                	mov    %edx,%ecx
  8039e7:	d3 e8                	shr    %cl,%eax
  8039e9:	89 e9                	mov    %ebp,%ecx
  8039eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039ef:	d3 e3                	shl    %cl,%ebx
  8039f1:	89 c7                	mov    %eax,%edi
  8039f3:	89 d1                	mov    %edx,%ecx
  8039f5:	89 f0                	mov    %esi,%eax
  8039f7:	d3 e8                	shr    %cl,%eax
  8039f9:	89 e9                	mov    %ebp,%ecx
  8039fb:	89 fa                	mov    %edi,%edx
  8039fd:	d3 e6                	shl    %cl,%esi
  8039ff:	09 d8                	or     %ebx,%eax
  803a01:	f7 74 24 08          	divl   0x8(%esp)
  803a05:	89 d1                	mov    %edx,%ecx
  803a07:	89 f3                	mov    %esi,%ebx
  803a09:	f7 64 24 0c          	mull   0xc(%esp)
  803a0d:	89 c6                	mov    %eax,%esi
  803a0f:	89 d7                	mov    %edx,%edi
  803a11:	39 d1                	cmp    %edx,%ecx
  803a13:	72 06                	jb     803a1b <__umoddi3+0xfb>
  803a15:	75 10                	jne    803a27 <__umoddi3+0x107>
  803a17:	39 c3                	cmp    %eax,%ebx
  803a19:	73 0c                	jae    803a27 <__umoddi3+0x107>
  803a1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803a1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803a23:	89 d7                	mov    %edx,%edi
  803a25:	89 c6                	mov    %eax,%esi
  803a27:	89 ca                	mov    %ecx,%edx
  803a29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803a2e:	29 f3                	sub    %esi,%ebx
  803a30:	19 fa                	sbb    %edi,%edx
  803a32:	89 d0                	mov    %edx,%eax
  803a34:	d3 e0                	shl    %cl,%eax
  803a36:	89 e9                	mov    %ebp,%ecx
  803a38:	d3 eb                	shr    %cl,%ebx
  803a3a:	d3 ea                	shr    %cl,%edx
  803a3c:	09 d8                	or     %ebx,%eax
  803a3e:	83 c4 1c             	add    $0x1c,%esp
  803a41:	5b                   	pop    %ebx
  803a42:	5e                   	pop    %esi
  803a43:	5f                   	pop    %edi
  803a44:	5d                   	pop    %ebp
  803a45:	c3                   	ret    
  803a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803a4d:	8d 76 00             	lea    0x0(%esi),%esi
  803a50:	89 da                	mov    %ebx,%edx
  803a52:	29 fe                	sub    %edi,%esi
  803a54:	19 c2                	sbb    %eax,%edx
  803a56:	89 f1                	mov    %esi,%ecx
  803a58:	89 c8                	mov    %ecx,%eax
  803a5a:	e9 4b ff ff ff       	jmp    8039aa <__umoddi3+0x8a>
