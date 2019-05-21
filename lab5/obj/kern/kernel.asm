
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0
	# Turn on page size extension.

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 30 12 f0       	mov    $0xf0123000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 5e 00 00 00       	call   f010009c <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100048:	83 3d 80 6e 35 f0 00 	cmpl   $0x0,0xf0356e80
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 d4 0d 00 00       	call   f0100e2f <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 80 6e 35 f0    	mov    %esi,0xf0356e80
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 1a 6b 00 00       	call   f0106b8a <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 e0 71 10 f0       	push   $0xf01071e0
f010007c:	e8 3d 3e 00 00       	call   f0103ebe <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 0d 3e 00 00       	call   f0103e98 <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 a6 87 10 f0 	movl   $0xf01087a6,(%esp)
f0100092:	e8 27 3e 00 00       	call   f0103ebe <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 7e 05 00 00       	call   f0100626 <cons_init>
	mem_init();
f01000a8:	e8 09 18 00 00       	call   f01018b6 <mem_init>
	env_init();
f01000ad:	e8 87 36 00 00       	call   f0103739 <env_init>
	trap_init();
f01000b2:	e8 e9 3e 00 00       	call   f0103fa0 <trap_init>
	mp_init();
f01000b7:	e8 d7 67 00 00       	call   f0106893 <mp_init>
	lapic_init();
f01000bc:	e8 df 6a 00 00       	call   f0106ba0 <lapic_init>
	pic_init();
f01000c1:	e8 0f 3d 00 00       	call   f0103dd5 <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000c6:	83 ec 0c             	sub    $0xc,%esp
f01000c9:	68 c0 53 12 f0       	push   $0xf01253c0
f01000ce:	e8 27 6d 00 00       	call   f0106dfa <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000d3:	83 c4 10             	add    $0x10,%esp
f01000d6:	83 3d 88 6e 35 f0 07 	cmpl   $0x7,0xf0356e88
f01000dd:	76 27                	jbe    f0100106 <i386_init+0x6a>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000df:	83 ec 04             	sub    $0x4,%esp
f01000e2:	b8 f6 67 10 f0       	mov    $0xf01067f6,%eax
f01000e7:	2d 7c 67 10 f0       	sub    $0xf010677c,%eax
f01000ec:	50                   	push   %eax
f01000ed:	68 7c 67 10 f0       	push   $0xf010677c
f01000f2:	68 00 70 00 f0       	push   $0xf0007000
f01000f7:	e8 d5 64 00 00       	call   f01065d1 <memmove>
f01000fc:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f01000ff:	bb 20 70 35 f0       	mov    $0xf0357020,%ebx
f0100104:	eb 19                	jmp    f010011f <i386_init+0x83>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100106:	68 00 70 00 00       	push   $0x7000
f010010b:	68 04 72 10 f0       	push   $0xf0107204
f0100110:	6a 5a                	push   $0x5a
f0100112:	68 4c 72 10 f0       	push   $0xf010724c
f0100117:	e8 24 ff ff ff       	call   f0100040 <_panic>
f010011c:	83 c3 74             	add    $0x74,%ebx
f010011f:	6b 05 c4 73 35 f0 74 	imul   $0x74,0xf03573c4,%eax
f0100126:	05 20 70 35 f0       	add    $0xf0357020,%eax
f010012b:	39 c3                	cmp    %eax,%ebx
f010012d:	73 4d                	jae    f010017c <i386_init+0xe0>
		if (c == cpus + cpunum())  // We've started already.
f010012f:	e8 56 6a 00 00       	call   f0106b8a <cpunum>
f0100134:	6b c0 74             	imul   $0x74,%eax,%eax
f0100137:	05 20 70 35 f0       	add    $0xf0357020,%eax
f010013c:	39 c3                	cmp    %eax,%ebx
f010013e:	74 dc                	je     f010011c <i386_init+0x80>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100140:	89 d8                	mov    %ebx,%eax
f0100142:	2d 20 70 35 f0       	sub    $0xf0357020,%eax
f0100147:	c1 f8 02             	sar    $0x2,%eax
f010014a:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100150:	c1 e0 0f             	shl    $0xf,%eax
f0100153:	8d 80 00 00 36 f0    	lea    -0xfca0000(%eax),%eax
f0100159:	a3 84 6e 35 f0       	mov    %eax,0xf0356e84
		lapic_startap(c->cpu_id, PADDR(code));
f010015e:	83 ec 08             	sub    $0x8,%esp
f0100161:	68 00 70 00 00       	push   $0x7000
f0100166:	0f b6 03             	movzbl (%ebx),%eax
f0100169:	50                   	push   %eax
f010016a:	e8 83 6b 00 00       	call   f0106cf2 <lapic_startap>
f010016f:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f0100172:	8b 43 04             	mov    0x4(%ebx),%eax
f0100175:	83 f8 01             	cmp    $0x1,%eax
f0100178:	75 f8                	jne    f0100172 <i386_init+0xd6>
f010017a:	eb a0                	jmp    f010011c <i386_init+0x80>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f010017c:	83 ec 08             	sub    $0x8,%esp
f010017f:	6a 01                	push   $0x1
f0100181:	68 98 f1 2b f0       	push   $0xf02bf198
f0100186:	e8 61 37 00 00       	call   f01038ec <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f010018b:	83 c4 08             	add    $0x8,%esp
f010018e:	6a 00                	push   $0x0
f0100190:	68 24 55 32 f0       	push   $0xf0325524
f0100195:	e8 52 37 00 00       	call   f01038ec <env_create>
	kbd_intr();
f010019a:	e8 32 04 00 00       	call   f01005d1 <kbd_intr>
	sched_yield();
f010019f:	e8 f3 4b 00 00       	call   f0104d97 <sched_yield>

f01001a4 <mp_main>:
{
f01001a4:	55                   	push   %ebp
f01001a5:	89 e5                	mov    %esp,%ebp
f01001a7:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001aa:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001af:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001b4:	76 52                	jbe    f0100208 <mp_main+0x64>
	return (physaddr_t)kva - KERNBASE;
f01001b6:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001bb:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001be:	e8 c7 69 00 00       	call   f0106b8a <cpunum>
f01001c3:	83 ec 08             	sub    $0x8,%esp
f01001c6:	50                   	push   %eax
f01001c7:	68 58 72 10 f0       	push   $0xf0107258
f01001cc:	e8 ed 3c 00 00       	call   f0103ebe <cprintf>
	lapic_init();
f01001d1:	e8 ca 69 00 00       	call   f0106ba0 <lapic_init>
	env_init_percpu();
f01001d6:	e8 32 35 00 00       	call   f010370d <env_init_percpu>
	trap_init_percpu();
f01001db:	e8 f2 3c 00 00       	call   f0103ed2 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01001e0:	e8 a5 69 00 00       	call   f0106b8a <cpunum>
f01001e5:	6b d0 74             	imul   $0x74,%eax,%edx
f01001e8:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01001eb:	b8 01 00 00 00       	mov    $0x1,%eax
f01001f0:	f0 87 82 20 70 35 f0 	lock xchg %eax,-0xfca8fe0(%edx)
f01001f7:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f01001fe:	e8 f7 6b 00 00       	call   f0106dfa <spin_lock>
	sched_yield();
f0100203:	e8 8f 4b 00 00       	call   f0104d97 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100208:	50                   	push   %eax
f0100209:	68 28 72 10 f0       	push   $0xf0107228
f010020e:	6a 71                	push   $0x71
f0100210:	68 4c 72 10 f0       	push   $0xf010724c
f0100215:	e8 26 fe ff ff       	call   f0100040 <_panic>

f010021a <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010021a:	55                   	push   %ebp
f010021b:	89 e5                	mov    %esp,%ebp
f010021d:	53                   	push   %ebx
f010021e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100221:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100224:	ff 75 0c             	pushl  0xc(%ebp)
f0100227:	ff 75 08             	pushl  0x8(%ebp)
f010022a:	68 6e 72 10 f0       	push   $0xf010726e
f010022f:	e8 8a 3c 00 00       	call   f0103ebe <cprintf>
	vcprintf(fmt, ap);
f0100234:	83 c4 08             	add    $0x8,%esp
f0100237:	53                   	push   %ebx
f0100238:	ff 75 10             	pushl  0x10(%ebp)
f010023b:	e8 58 3c 00 00       	call   f0103e98 <vcprintf>
	cprintf("\n");
f0100240:	c7 04 24 a6 87 10 f0 	movl   $0xf01087a6,(%esp)
f0100247:	e8 72 3c 00 00       	call   f0103ebe <cprintf>
	va_end(ap);
}
f010024c:	83 c4 10             	add    $0x10,%esp
f010024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100252:	c9                   	leave  
f0100253:	c3                   	ret    

f0100254 <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100254:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100259:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010025a:	a8 01                	test   $0x1,%al
f010025c:	74 0a                	je     f0100268 <serial_proc_data+0x14>
f010025e:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100263:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100264:	0f b6 c0             	movzbl %al,%eax
f0100267:	c3                   	ret    
		return -1;
f0100268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f010026d:	c3                   	ret    

f010026e <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010026e:	55                   	push   %ebp
f010026f:	89 e5                	mov    %esp,%ebp
f0100271:	53                   	push   %ebx
f0100272:	83 ec 04             	sub    $0x4,%esp
f0100275:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100277:	ff d3                	call   *%ebx
f0100279:	83 f8 ff             	cmp    $0xffffffff,%eax
f010027c:	74 29                	je     f01002a7 <cons_intr+0x39>
		if (c == 0)
f010027e:	85 c0                	test   %eax,%eax
f0100280:	74 f5                	je     f0100277 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f0100282:	8b 0d 24 62 35 f0    	mov    0xf0356224,%ecx
f0100288:	8d 51 01             	lea    0x1(%ecx),%edx
f010028b:	88 81 20 60 35 f0    	mov    %al,-0xfca9fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f0100291:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f0100297:	b8 00 00 00 00       	mov    $0x0,%eax
f010029c:	0f 44 d0             	cmove  %eax,%edx
f010029f:	89 15 24 62 35 f0    	mov    %edx,0xf0356224
f01002a5:	eb d0                	jmp    f0100277 <cons_intr+0x9>
	}
}
f01002a7:	83 c4 04             	add    $0x4,%esp
f01002aa:	5b                   	pop    %ebx
f01002ab:	5d                   	pop    %ebp
f01002ac:	c3                   	ret    

f01002ad <kbd_proc_data>:
{
f01002ad:	55                   	push   %ebp
f01002ae:	89 e5                	mov    %esp,%ebp
f01002b0:	53                   	push   %ebx
f01002b1:	83 ec 04             	sub    $0x4,%esp
f01002b4:	ba 64 00 00 00       	mov    $0x64,%edx
f01002b9:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002ba:	a8 01                	test   $0x1,%al
f01002bc:	0f 84 f2 00 00 00    	je     f01003b4 <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f01002c2:	a8 20                	test   $0x20,%al
f01002c4:	0f 85 f1 00 00 00    	jne    f01003bb <kbd_proc_data+0x10e>
f01002ca:	ba 60 00 00 00       	mov    $0x60,%edx
f01002cf:	ec                   	in     (%dx),%al
f01002d0:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002d2:	3c e0                	cmp    $0xe0,%al
f01002d4:	74 61                	je     f0100337 <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f01002d6:	84 c0                	test   %al,%al
f01002d8:	78 70                	js     f010034a <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f01002da:	8b 0d 00 60 35 f0    	mov    0xf0356000,%ecx
f01002e0:	f6 c1 40             	test   $0x40,%cl
f01002e3:	74 0e                	je     f01002f3 <kbd_proc_data+0x46>
		data |= 0x80;
f01002e5:	83 c8 80             	or     $0xffffff80,%eax
f01002e8:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01002ea:	83 e1 bf             	and    $0xffffffbf,%ecx
f01002ed:	89 0d 00 60 35 f0    	mov    %ecx,0xf0356000
	shift |= shiftcode[data];
f01002f3:	0f b6 d2             	movzbl %dl,%edx
f01002f6:	0f b6 82 e0 73 10 f0 	movzbl -0xfef8c20(%edx),%eax
f01002fd:	0b 05 00 60 35 f0    	or     0xf0356000,%eax
	shift ^= togglecode[data];
f0100303:	0f b6 8a e0 72 10 f0 	movzbl -0xfef8d20(%edx),%ecx
f010030a:	31 c8                	xor    %ecx,%eax
f010030c:	a3 00 60 35 f0       	mov    %eax,0xf0356000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100311:	89 c1                	mov    %eax,%ecx
f0100313:	83 e1 03             	and    $0x3,%ecx
f0100316:	8b 0c 8d c0 72 10 f0 	mov    -0xfef8d40(,%ecx,4),%ecx
f010031d:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100321:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100324:	a8 08                	test   $0x8,%al
f0100326:	74 61                	je     f0100389 <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f0100328:	89 da                	mov    %ebx,%edx
f010032a:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f010032d:	83 f9 19             	cmp    $0x19,%ecx
f0100330:	77 4b                	ja     f010037d <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f0100332:	83 eb 20             	sub    $0x20,%ebx
f0100335:	eb 0c                	jmp    f0100343 <kbd_proc_data+0x96>
		shift |= E0ESC;
f0100337:	83 0d 00 60 35 f0 40 	orl    $0x40,0xf0356000
		return 0;
f010033e:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100343:	89 d8                	mov    %ebx,%eax
f0100345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100348:	c9                   	leave  
f0100349:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010034a:	8b 0d 00 60 35 f0    	mov    0xf0356000,%ecx
f0100350:	89 cb                	mov    %ecx,%ebx
f0100352:	83 e3 40             	and    $0x40,%ebx
f0100355:	83 e0 7f             	and    $0x7f,%eax
f0100358:	85 db                	test   %ebx,%ebx
f010035a:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010035d:	0f b6 d2             	movzbl %dl,%edx
f0100360:	0f b6 82 e0 73 10 f0 	movzbl -0xfef8c20(%edx),%eax
f0100367:	83 c8 40             	or     $0x40,%eax
f010036a:	0f b6 c0             	movzbl %al,%eax
f010036d:	f7 d0                	not    %eax
f010036f:	21 c8                	and    %ecx,%eax
f0100371:	a3 00 60 35 f0       	mov    %eax,0xf0356000
		return 0;
f0100376:	bb 00 00 00 00       	mov    $0x0,%ebx
f010037b:	eb c6                	jmp    f0100343 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f010037d:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100380:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100383:	83 fa 1a             	cmp    $0x1a,%edx
f0100386:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100389:	f7 d0                	not    %eax
f010038b:	a8 06                	test   $0x6,%al
f010038d:	75 b4                	jne    f0100343 <kbd_proc_data+0x96>
f010038f:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100395:	75 ac                	jne    f0100343 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f0100397:	83 ec 0c             	sub    $0xc,%esp
f010039a:	68 88 72 10 f0       	push   $0xf0107288
f010039f:	e8 1a 3b 00 00       	call   f0103ebe <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003a4:	b8 03 00 00 00       	mov    $0x3,%eax
f01003a9:	ba 92 00 00 00       	mov    $0x92,%edx
f01003ae:	ee                   	out    %al,(%dx)
f01003af:	83 c4 10             	add    $0x10,%esp
f01003b2:	eb 8f                	jmp    f0100343 <kbd_proc_data+0x96>
		return -1;
f01003b4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003b9:	eb 88                	jmp    f0100343 <kbd_proc_data+0x96>
		return -1;
f01003bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003c0:	eb 81                	jmp    f0100343 <kbd_proc_data+0x96>

f01003c2 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003c2:	55                   	push   %ebp
f01003c3:	89 e5                	mov    %esp,%ebp
f01003c5:	57                   	push   %edi
f01003c6:	56                   	push   %esi
f01003c7:	53                   	push   %ebx
f01003c8:	83 ec 1c             	sub    $0x1c,%esp
f01003cb:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f01003cd:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003d2:	bf fd 03 00 00       	mov    $0x3fd,%edi
f01003d7:	bb 84 00 00 00       	mov    $0x84,%ebx
f01003dc:	89 fa                	mov    %edi,%edx
f01003de:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01003df:	a8 20                	test   $0x20,%al
f01003e1:	75 13                	jne    f01003f6 <cons_putc+0x34>
f01003e3:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01003e9:	7f 0b                	jg     f01003f6 <cons_putc+0x34>
f01003eb:	89 da                	mov    %ebx,%edx
f01003ed:	ec                   	in     (%dx),%al
f01003ee:	ec                   	in     (%dx),%al
f01003ef:	ec                   	in     (%dx),%al
f01003f0:	ec                   	in     (%dx),%al
	     i++)
f01003f1:	83 c6 01             	add    $0x1,%esi
f01003f4:	eb e6                	jmp    f01003dc <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f01003f6:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01003fe:	89 c8                	mov    %ecx,%eax
f0100400:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100401:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100406:	bf 79 03 00 00       	mov    $0x379,%edi
f010040b:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100410:	89 fa                	mov    %edi,%edx
f0100412:	ec                   	in     (%dx),%al
f0100413:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100419:	7f 0f                	jg     f010042a <cons_putc+0x68>
f010041b:	84 c0                	test   %al,%al
f010041d:	78 0b                	js     f010042a <cons_putc+0x68>
f010041f:	89 da                	mov    %ebx,%edx
f0100421:	ec                   	in     (%dx),%al
f0100422:	ec                   	in     (%dx),%al
f0100423:	ec                   	in     (%dx),%al
f0100424:	ec                   	in     (%dx),%al
f0100425:	83 c6 01             	add    $0x1,%esi
f0100428:	eb e6                	jmp    f0100410 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010042a:	ba 78 03 00 00       	mov    $0x378,%edx
f010042f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100433:	ee                   	out    %al,(%dx)
f0100434:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100439:	b8 0d 00 00 00       	mov    $0xd,%eax
f010043e:	ee                   	out    %al,(%dx)
f010043f:	b8 08 00 00 00       	mov    $0x8,%eax
f0100444:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f0100445:	89 ca                	mov    %ecx,%edx
f0100447:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f010044d:	89 c8                	mov    %ecx,%eax
f010044f:	80 cc 07             	or     $0x7,%ah
f0100452:	85 d2                	test   %edx,%edx
f0100454:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f0100457:	0f b6 c1             	movzbl %cl,%eax
f010045a:	83 f8 09             	cmp    $0x9,%eax
f010045d:	0f 84 b0 00 00 00    	je     f0100513 <cons_putc+0x151>
f0100463:	7e 73                	jle    f01004d8 <cons_putc+0x116>
f0100465:	83 f8 0a             	cmp    $0xa,%eax
f0100468:	0f 84 98 00 00 00    	je     f0100506 <cons_putc+0x144>
f010046e:	83 f8 0d             	cmp    $0xd,%eax
f0100471:	0f 85 d3 00 00 00    	jne    f010054a <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f0100477:	0f b7 05 28 62 35 f0 	movzwl 0xf0356228,%eax
f010047e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100484:	c1 e8 16             	shr    $0x16,%eax
f0100487:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010048a:	c1 e0 04             	shl    $0x4,%eax
f010048d:	66 a3 28 62 35 f0    	mov    %ax,0xf0356228
	if (crt_pos >= CRT_SIZE) {
f0100493:	66 81 3d 28 62 35 f0 	cmpw   $0x7cf,0xf0356228
f010049a:	cf 07 
f010049c:	0f 87 cb 00 00 00    	ja     f010056d <cons_putc+0x1ab>
	outb(addr_6845, 14);
f01004a2:	8b 0d 30 62 35 f0    	mov    0xf0356230,%ecx
f01004a8:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004ad:	89 ca                	mov    %ecx,%edx
f01004af:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004b0:	0f b7 1d 28 62 35 f0 	movzwl 0xf0356228,%ebx
f01004b7:	8d 71 01             	lea    0x1(%ecx),%esi
f01004ba:	89 d8                	mov    %ebx,%eax
f01004bc:	66 c1 e8 08          	shr    $0x8,%ax
f01004c0:	89 f2                	mov    %esi,%edx
f01004c2:	ee                   	out    %al,(%dx)
f01004c3:	b8 0f 00 00 00       	mov    $0xf,%eax
f01004c8:	89 ca                	mov    %ecx,%edx
f01004ca:	ee                   	out    %al,(%dx)
f01004cb:	89 d8                	mov    %ebx,%eax
f01004cd:	89 f2                	mov    %esi,%edx
f01004cf:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01004d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01004d3:	5b                   	pop    %ebx
f01004d4:	5e                   	pop    %esi
f01004d5:	5f                   	pop    %edi
f01004d6:	5d                   	pop    %ebp
f01004d7:	c3                   	ret    
	switch (c & 0xff) {
f01004d8:	83 f8 08             	cmp    $0x8,%eax
f01004db:	75 6d                	jne    f010054a <cons_putc+0x188>
		if (crt_pos > 0) {
f01004dd:	0f b7 05 28 62 35 f0 	movzwl 0xf0356228,%eax
f01004e4:	66 85 c0             	test   %ax,%ax
f01004e7:	74 b9                	je     f01004a2 <cons_putc+0xe0>
			crt_pos--;
f01004e9:	83 e8 01             	sub    $0x1,%eax
f01004ec:	66 a3 28 62 35 f0    	mov    %ax,0xf0356228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01004f2:	0f b7 c0             	movzwl %ax,%eax
f01004f5:	b1 00                	mov    $0x0,%cl
f01004f7:	83 c9 20             	or     $0x20,%ecx
f01004fa:	8b 15 2c 62 35 f0    	mov    0xf035622c,%edx
f0100500:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f0100504:	eb 8d                	jmp    f0100493 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f0100506:	66 83 05 28 62 35 f0 	addw   $0x50,0xf0356228
f010050d:	50 
f010050e:	e9 64 ff ff ff       	jmp    f0100477 <cons_putc+0xb5>
		cons_putc(' ');
f0100513:	b8 20 00 00 00       	mov    $0x20,%eax
f0100518:	e8 a5 fe ff ff       	call   f01003c2 <cons_putc>
		cons_putc(' ');
f010051d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100522:	e8 9b fe ff ff       	call   f01003c2 <cons_putc>
		cons_putc(' ');
f0100527:	b8 20 00 00 00       	mov    $0x20,%eax
f010052c:	e8 91 fe ff ff       	call   f01003c2 <cons_putc>
		cons_putc(' ');
f0100531:	b8 20 00 00 00       	mov    $0x20,%eax
f0100536:	e8 87 fe ff ff       	call   f01003c2 <cons_putc>
		cons_putc(' ');
f010053b:	b8 20 00 00 00       	mov    $0x20,%eax
f0100540:	e8 7d fe ff ff       	call   f01003c2 <cons_putc>
f0100545:	e9 49 ff ff ff       	jmp    f0100493 <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f010054a:	0f b7 05 28 62 35 f0 	movzwl 0xf0356228,%eax
f0100551:	8d 50 01             	lea    0x1(%eax),%edx
f0100554:	66 89 15 28 62 35 f0 	mov    %dx,0xf0356228
f010055b:	0f b7 c0             	movzwl %ax,%eax
f010055e:	8b 15 2c 62 35 f0    	mov    0xf035622c,%edx
f0100564:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f0100568:	e9 26 ff ff ff       	jmp    f0100493 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010056d:	a1 2c 62 35 f0       	mov    0xf035622c,%eax
f0100572:	83 ec 04             	sub    $0x4,%esp
f0100575:	68 00 0f 00 00       	push   $0xf00
f010057a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100580:	52                   	push   %edx
f0100581:	50                   	push   %eax
f0100582:	e8 4a 60 00 00       	call   f01065d1 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f0100587:	8b 15 2c 62 35 f0    	mov    0xf035622c,%edx
f010058d:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100593:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0100599:	83 c4 10             	add    $0x10,%esp
f010059c:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005a1:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005a4:	39 d0                	cmp    %edx,%eax
f01005a6:	75 f4                	jne    f010059c <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f01005a8:	66 83 2d 28 62 35 f0 	subw   $0x50,0xf0356228
f01005af:	50 
f01005b0:	e9 ed fe ff ff       	jmp    f01004a2 <cons_putc+0xe0>

f01005b5 <serial_intr>:
	if (serial_exists)
f01005b5:	80 3d 34 62 35 f0 00 	cmpb   $0x0,0xf0356234
f01005bc:	75 01                	jne    f01005bf <serial_intr+0xa>
f01005be:	c3                   	ret    
{
f01005bf:	55                   	push   %ebp
f01005c0:	89 e5                	mov    %esp,%ebp
f01005c2:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005c5:	b8 54 02 10 f0       	mov    $0xf0100254,%eax
f01005ca:	e8 9f fc ff ff       	call   f010026e <cons_intr>
}
f01005cf:	c9                   	leave  
f01005d0:	c3                   	ret    

f01005d1 <kbd_intr>:
{
f01005d1:	55                   	push   %ebp
f01005d2:	89 e5                	mov    %esp,%ebp
f01005d4:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01005d7:	b8 ad 02 10 f0       	mov    $0xf01002ad,%eax
f01005dc:	e8 8d fc ff ff       	call   f010026e <cons_intr>
}
f01005e1:	c9                   	leave  
f01005e2:	c3                   	ret    

f01005e3 <cons_getc>:
{
f01005e3:	55                   	push   %ebp
f01005e4:	89 e5                	mov    %esp,%ebp
f01005e6:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01005e9:	e8 c7 ff ff ff       	call   f01005b5 <serial_intr>
	kbd_intr();
f01005ee:	e8 de ff ff ff       	call   f01005d1 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01005f3:	8b 15 20 62 35 f0    	mov    0xf0356220,%edx
	return 0;
f01005f9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f01005fe:	3b 15 24 62 35 f0    	cmp    0xf0356224,%edx
f0100604:	74 1e                	je     f0100624 <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f0100606:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100609:	0f b6 82 20 60 35 f0 	movzbl -0xfca9fe0(%edx),%eax
			cons.rpos = 0;
f0100610:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100616:	ba 00 00 00 00       	mov    $0x0,%edx
f010061b:	0f 44 ca             	cmove  %edx,%ecx
f010061e:	89 0d 20 62 35 f0    	mov    %ecx,0xf0356220
}
f0100624:	c9                   	leave  
f0100625:	c3                   	ret    

f0100626 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100626:	55                   	push   %ebp
f0100627:	89 e5                	mov    %esp,%ebp
f0100629:	57                   	push   %edi
f010062a:	56                   	push   %esi
f010062b:	53                   	push   %ebx
f010062c:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f010062f:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f0100636:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f010063d:	5a a5 
	if (*cp != 0xA55A) {
f010063f:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100646:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010064a:	0f 84 de 00 00 00    	je     f010072e <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100650:	c7 05 30 62 35 f0 b4 	movl   $0x3b4,0xf0356230
f0100657:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010065a:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f010065f:	8b 3d 30 62 35 f0    	mov    0xf0356230,%edi
f0100665:	b8 0e 00 00 00       	mov    $0xe,%eax
f010066a:	89 fa                	mov    %edi,%edx
f010066c:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010066d:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100670:	89 ca                	mov    %ecx,%edx
f0100672:	ec                   	in     (%dx),%al
f0100673:	0f b6 c0             	movzbl %al,%eax
f0100676:	c1 e0 08             	shl    $0x8,%eax
f0100679:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010067b:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100680:	89 fa                	mov    %edi,%edx
f0100682:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100683:	89 ca                	mov    %ecx,%edx
f0100685:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f0100686:	89 35 2c 62 35 f0    	mov    %esi,0xf035622c
	pos |= inb(addr_6845 + 1);
f010068c:	0f b6 c0             	movzbl %al,%eax
f010068f:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f0100691:	66 a3 28 62 35 f0    	mov    %ax,0xf0356228
	kbd_intr();
f0100697:	e8 35 ff ff ff       	call   f01005d1 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f010069c:	83 ec 0c             	sub    $0xc,%esp
f010069f:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f01006a6:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006ab:	50                   	push   %eax
f01006ac:	e8 a6 36 00 00       	call   f0103d57 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006b1:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006b6:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006bb:	89 d8                	mov    %ebx,%eax
f01006bd:	89 ca                	mov    %ecx,%edx
f01006bf:	ee                   	out    %al,(%dx)
f01006c0:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006c5:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01006ca:	89 fa                	mov    %edi,%edx
f01006cc:	ee                   	out    %al,(%dx)
f01006cd:	b8 0c 00 00 00       	mov    $0xc,%eax
f01006d2:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006d7:	ee                   	out    %al,(%dx)
f01006d8:	be f9 03 00 00       	mov    $0x3f9,%esi
f01006dd:	89 d8                	mov    %ebx,%eax
f01006df:	89 f2                	mov    %esi,%edx
f01006e1:	ee                   	out    %al,(%dx)
f01006e2:	b8 03 00 00 00       	mov    $0x3,%eax
f01006e7:	89 fa                	mov    %edi,%edx
f01006e9:	ee                   	out    %al,(%dx)
f01006ea:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01006ef:	89 d8                	mov    %ebx,%eax
f01006f1:	ee                   	out    %al,(%dx)
f01006f2:	b8 01 00 00 00       	mov    $0x1,%eax
f01006f7:	89 f2                	mov    %esi,%edx
f01006f9:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006fa:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01006ff:	ec                   	in     (%dx),%al
f0100700:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100702:	83 c4 10             	add    $0x10,%esp
f0100705:	3c ff                	cmp    $0xff,%al
f0100707:	0f 95 05 34 62 35 f0 	setne  0xf0356234
f010070e:	89 ca                	mov    %ecx,%edx
f0100710:	ec                   	in     (%dx),%al
f0100711:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100716:	ec                   	in     (%dx),%al
	if (serial_exists)
f0100717:	80 fb ff             	cmp    $0xff,%bl
f010071a:	75 2d                	jne    f0100749 <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f010071c:	83 ec 0c             	sub    $0xc,%esp
f010071f:	68 94 72 10 f0       	push   $0xf0107294
f0100724:	e8 95 37 00 00       	call   f0103ebe <cprintf>
f0100729:	83 c4 10             	add    $0x10,%esp
}
f010072c:	eb 3c                	jmp    f010076a <cons_init+0x144>
		*cp = was;
f010072e:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100735:	c7 05 30 62 35 f0 d4 	movl   $0x3d4,0xf0356230
f010073c:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f010073f:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100744:	e9 16 ff ff ff       	jmp    f010065f <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100749:	83 ec 0c             	sub    $0xc,%esp
f010074c:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f0100753:	25 ef ff 00 00       	and    $0xffef,%eax
f0100758:	50                   	push   %eax
f0100759:	e8 f9 35 00 00       	call   f0103d57 <irq_setmask_8259A>
	if (!serial_exists)
f010075e:	83 c4 10             	add    $0x10,%esp
f0100761:	80 3d 34 62 35 f0 00 	cmpb   $0x0,0xf0356234
f0100768:	74 b2                	je     f010071c <cons_init+0xf6>
}
f010076a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010076d:	5b                   	pop    %ebx
f010076e:	5e                   	pop    %esi
f010076f:	5f                   	pop    %edi
f0100770:	5d                   	pop    %ebp
f0100771:	c3                   	ret    

f0100772 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100772:	55                   	push   %ebp
f0100773:	89 e5                	mov    %esp,%ebp
f0100775:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100778:	8b 45 08             	mov    0x8(%ebp),%eax
f010077b:	e8 42 fc ff ff       	call   f01003c2 <cons_putc>
}
f0100780:	c9                   	leave  
f0100781:	c3                   	ret    

f0100782 <getchar>:

int
getchar(void)
{
f0100782:	55                   	push   %ebp
f0100783:	89 e5                	mov    %esp,%ebp
f0100785:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100788:	e8 56 fe ff ff       	call   f01005e3 <cons_getc>
f010078d:	85 c0                	test   %eax,%eax
f010078f:	74 f7                	je     f0100788 <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100791:	c9                   	leave  
f0100792:	c3                   	ret    

f0100793 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f0100793:	b8 01 00 00 00       	mov    $0x1,%eax
f0100798:	c3                   	ret    

f0100799 <mon_help>:
	return 0;
}

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100799:	55                   	push   %ebp
f010079a:	89 e5                	mov    %esp,%ebp
f010079c:	56                   	push   %esi
f010079d:	53                   	push   %ebx
f010079e:	bb 60 7a 10 f0       	mov    $0xf0107a60,%ebx
f01007a3:	be a8 7a 10 f0       	mov    $0xf0107aa8,%esi
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007a8:	83 ec 04             	sub    $0x4,%esp
f01007ab:	ff 73 04             	pushl  0x4(%ebx)
f01007ae:	ff 33                	pushl  (%ebx)
f01007b0:	68 e0 74 10 f0       	push   $0xf01074e0
f01007b5:	e8 04 37 00 00       	call   f0103ebe <cprintf>
f01007ba:	83 c3 0c             	add    $0xc,%ebx
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f01007bd:	83 c4 10             	add    $0x10,%esp
f01007c0:	39 f3                	cmp    %esi,%ebx
f01007c2:	75 e4                	jne    f01007a8 <mon_help+0xf>
	return 0;
}
f01007c4:	b8 00 00 00 00       	mov    $0x0,%eax
f01007c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01007cc:	5b                   	pop    %ebx
f01007cd:	5e                   	pop    %esi
f01007ce:	5d                   	pop    %ebp
f01007cf:	c3                   	ret    

f01007d0 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01007d0:	55                   	push   %ebp
f01007d1:	89 e5                	mov    %esp,%ebp
f01007d3:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01007d6:	68 e9 74 10 f0       	push   $0xf01074e9
f01007db:	e8 de 36 00 00       	call   f0103ebe <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01007e0:	83 c4 08             	add    $0x8,%esp
f01007e3:	68 0c 00 10 00       	push   $0x10000c
f01007e8:	68 40 77 10 f0       	push   $0xf0107740
f01007ed:	e8 cc 36 00 00       	call   f0103ebe <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007f2:	83 c4 0c             	add    $0xc,%esp
f01007f5:	68 0c 00 10 00       	push   $0x10000c
f01007fa:	68 0c 00 10 f0       	push   $0xf010000c
f01007ff:	68 68 77 10 f0       	push   $0xf0107768
f0100804:	e8 b5 36 00 00       	call   f0103ebe <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100809:	83 c4 0c             	add    $0xc,%esp
f010080c:	68 cf 71 10 00       	push   $0x1071cf
f0100811:	68 cf 71 10 f0       	push   $0xf01071cf
f0100816:	68 8c 77 10 f0       	push   $0xf010778c
f010081b:	e8 9e 36 00 00       	call   f0103ebe <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100820:	83 c4 0c             	add    $0xc,%esp
f0100823:	68 00 60 35 00       	push   $0x356000
f0100828:	68 00 60 35 f0       	push   $0xf0356000
f010082d:	68 b0 77 10 f0       	push   $0xf01077b0
f0100832:	e8 87 36 00 00       	call   f0103ebe <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100837:	83 c4 0c             	add    $0xc,%esp
f010083a:	68 08 80 39 00       	push   $0x398008
f010083f:	68 08 80 39 f0       	push   $0xf0398008
f0100844:	68 d4 77 10 f0       	push   $0xf01077d4
f0100849:	e8 70 36 00 00       	call   f0103ebe <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f010084e:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100851:	b8 08 80 39 f0       	mov    $0xf0398008,%eax
f0100856:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f010085b:	c1 f8 0a             	sar    $0xa,%eax
f010085e:	50                   	push   %eax
f010085f:	68 f8 77 10 f0       	push   $0xf01077f8
f0100864:	e8 55 36 00 00       	call   f0103ebe <cprintf>
	return 0;
}
f0100869:	b8 00 00 00 00       	mov    $0x0,%eax
f010086e:	c9                   	leave  
f010086f:	c3                   	ret    

f0100870 <mon_showmappings>:
mon_showmappings(int argc, char **argv, struct Trapframe *tf){
f0100870:	55                   	push   %ebp
f0100871:	89 e5                	mov    %esp,%ebp
f0100873:	57                   	push   %edi
f0100874:	56                   	push   %esi
f0100875:	53                   	push   %ebx
f0100876:	83 ec 0c             	sub    $0xc,%esp
f0100879:	8b 45 08             	mov    0x8(%ebp),%eax
f010087c:	8b 75 0c             	mov    0xc(%ebp),%esi
	if(argc != 3){
f010087f:	83 f8 03             	cmp    $0x3,%eax
f0100882:	74 1e                	je     f01008a2 <mon_showmappings+0x32>
		cprintf("usage: showmappings [from_addr] [to_addr]\n",argc);
f0100884:	83 ec 08             	sub    $0x8,%esp
f0100887:	50                   	push   %eax
f0100888:	68 24 78 10 f0       	push   $0xf0107824
f010088d:	e8 2c 36 00 00       	call   f0103ebe <cprintf>
		return 0;
f0100892:	83 c4 10             	add    $0x10,%esp
}
f0100895:	b8 00 00 00 00       	mov    $0x0,%eax
f010089a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010089d:	5b                   	pop    %ebx
f010089e:	5e                   	pop    %esi
f010089f:	5f                   	pop    %edi
f01008a0:	5d                   	pop    %ebp
f01008a1:	c3                   	ret    
	physaddr_t from = ROUNDDOWN(strtol(argv[1],NULL, 16),PGSIZE);
f01008a2:	83 ec 04             	sub    $0x4,%esp
f01008a5:	6a 10                	push   $0x10
f01008a7:	6a 00                	push   $0x0
f01008a9:	ff 76 04             	pushl  0x4(%esi)
f01008ac:	e8 ee 5d 00 00       	call   f010669f <strtol>
f01008b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01008b6:	89 c3                	mov    %eax,%ebx
	physaddr_t to = ROUNDUP(strtol(argv[2],NULL, 16),PGSIZE);
f01008b8:	83 c4 0c             	add    $0xc,%esp
f01008bb:	6a 10                	push   $0x10
f01008bd:	6a 00                	push   $0x0
f01008bf:	ff 76 08             	pushl  0x8(%esi)
f01008c2:	e8 d8 5d 00 00       	call   f010669f <strtol>
f01008c7:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
f01008cd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	cprintf("|%10s|%10s|%8s|%8s|%8s|\n","PADDR","VADDR","PTE_P","PTE_W","PTE_U");
f01008d3:	83 c4 08             	add    $0x8,%esp
f01008d6:	68 f4 86 10 f0       	push   $0xf01086f4
f01008db:	68 db 87 10 f0       	push   $0xf01087db
f01008e0:	68 ca 87 10 f0       	push   $0xf01087ca
f01008e5:	68 02 75 10 f0       	push   $0xf0107502
f01008ea:	68 4b 85 10 f0       	push   $0xf010854b
f01008ef:	68 08 75 10 f0       	push   $0xf0107508
f01008f4:	e8 c5 35 00 00       	call   f0103ebe <cprintf>
	for(physaddr_t i=from;i<=to;i+=PGSIZE){
f01008f9:	83 c4 20             	add    $0x20,%esp
f01008fc:	eb 2b                	jmp    f0100929 <mon_showmappings+0xb9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01008fe:	53                   	push   %ebx
f01008ff:	68 04 72 10 f0       	push   $0xf0107204
f0100904:	6a 31                	push   $0x31
f0100906:	68 21 75 10 f0       	push   $0xf0107521
f010090b:	e8 30 f7 ff ff       	call   f0100040 <_panic>
			cprintf("%8x|%8x|%8x|\n", 0, 0, 0);
f0100910:	6a 00                	push   $0x0
f0100912:	6a 00                	push   $0x0
f0100914:	6a 00                	push   $0x0
f0100916:	68 40 75 10 f0       	push   $0xf0107540
f010091b:	e8 9e 35 00 00       	call   f0103ebe <cprintf>
f0100920:	83 c4 10             	add    $0x10,%esp
	for(physaddr_t i=from;i<=to;i+=PGSIZE){
f0100923:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100929:	39 de                	cmp    %ebx,%esi
f010092b:	0f 82 64 ff ff ff    	jb     f0100895 <mon_showmappings+0x25>
	if (PGNUM(pa) >= npages)
f0100931:	89 d8                	mov    %ebx,%eax
f0100933:	c1 e8 0c             	shr    $0xc,%eax
f0100936:	3b 05 88 6e 35 f0    	cmp    0xf0356e88,%eax
f010093c:	73 c0                	jae    f01008fe <mon_showmappings+0x8e>
f010093e:	8d bb 00 00 00 f0    	lea    -0x10000000(%ebx),%edi
		cprintf("|0x%08x|0x%08x|", i, va);
f0100944:	83 ec 04             	sub    $0x4,%esp
f0100947:	57                   	push   %edi
f0100948:	53                   	push   %ebx
f0100949:	68 30 75 10 f0       	push   $0xf0107530
f010094e:	e8 6b 35 00 00       	call   f0103ebe <cprintf>
		pte_t* pte = pgdir_walk(kern_pgdir, va, 0);
f0100953:	83 c4 0c             	add    $0xc,%esp
f0100956:	6a 00                	push   $0x0
f0100958:	57                   	push   %edi
f0100959:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f010095f:	e8 81 0b 00 00       	call   f01014e5 <pgdir_walk>
		if(pte){
f0100964:	83 c4 10             	add    $0x10,%esp
f0100967:	85 c0                	test   %eax,%eax
f0100969:	74 a5                	je     f0100910 <mon_showmappings+0xa0>
			cprintf("%8x|%8x|%8x|\n", (*pte & PTE_P)>0, (*pte & PTE_W)>0,(*pte & PTE_U)>0);
f010096b:	8b 00                	mov    (%eax),%eax
f010096d:	89 c2                	mov    %eax,%edx
f010096f:	c1 ea 02             	shr    $0x2,%edx
f0100972:	83 e2 01             	and    $0x1,%edx
f0100975:	52                   	push   %edx
f0100976:	89 c2                	mov    %eax,%edx
f0100978:	d1 ea                	shr    %edx
f010097a:	83 e2 01             	and    $0x1,%edx
f010097d:	52                   	push   %edx
f010097e:	83 e0 01             	and    $0x1,%eax
f0100981:	50                   	push   %eax
f0100982:	68 40 75 10 f0       	push   $0xf0107540
f0100987:	e8 32 35 00 00       	call   f0103ebe <cprintf>
f010098c:	83 c4 10             	add    $0x10,%esp
f010098f:	eb 92                	jmp    f0100923 <mon_showmappings+0xb3>

f0100991 <mon_changeperm>:
mon_changeperm(int argc, char **argv, struct Trapframe *tf){
f0100991:	55                   	push   %ebp
f0100992:	89 e5                	mov    %esp,%ebp
f0100994:	57                   	push   %edi
f0100995:	56                   	push   %esi
f0100996:	53                   	push   %ebx
f0100997:	83 ec 1c             	sub    $0x1c,%esp
f010099a:	8b 45 08             	mov    0x8(%ebp),%eax
f010099d:	8b 75 0c             	mov    0xc(%ebp),%esi
	if(argc != 4){
f01009a0:	83 f8 04             	cmp    $0x4,%eax
f01009a3:	74 1e                	je     f01009c3 <mon_changeperm+0x32>
		cprintf("usage: changeperm [addr] [clr/set] [ur/uw/kw]\n",argc);
f01009a5:	83 ec 08             	sub    $0x8,%esp
f01009a8:	50                   	push   %eax
f01009a9:	68 50 78 10 f0       	push   $0xf0107850
f01009ae:	e8 0b 35 00 00       	call   f0103ebe <cprintf>
		return 0;
f01009b3:	83 c4 10             	add    $0x10,%esp
}
f01009b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01009bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01009be:	5b                   	pop    %ebx
f01009bf:	5e                   	pop    %esi
f01009c0:	5f                   	pop    %edi
f01009c1:	5d                   	pop    %ebp
f01009c2:	c3                   	ret    
	physaddr_t addr = strtol(argv[1],NULL, 16);
f01009c3:	83 ec 04             	sub    $0x4,%esp
f01009c6:	6a 10                	push   $0x10
f01009c8:	6a 00                	push   $0x0
f01009ca:	ff 76 04             	pushl  0x4(%esi)
f01009cd:	e8 cd 5c 00 00       	call   f010669f <strtol>
f01009d2:	89 c3                	mov    %eax,%ebx
	char* type = argv[2];
f01009d4:	8b 7e 08             	mov    0x8(%esi),%edi
	char* perm = argv[3];
f01009d7:	8b 46 0c             	mov    0xc(%esi),%eax
f01009da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01009dd:	89 d8                	mov    %ebx,%eax
f01009df:	c1 e8 0c             	shr    $0xc,%eax
f01009e2:	83 c4 10             	add    $0x10,%esp
f01009e5:	3b 05 88 6e 35 f0    	cmp    0xf0356e88,%eax
f01009eb:	73 64                	jae    f0100a51 <mon_changeperm+0xc0>
	pte_t* pte = pgdir_walk(kern_pgdir, va, 0);
f01009ed:	83 ec 04             	sub    $0x4,%esp
f01009f0:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01009f2:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
f01009f8:	50                   	push   %eax
f01009f9:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01009ff:	e8 e1 0a 00 00       	call   f01014e5 <pgdir_walk>
f0100a04:	89 c6                	mov    %eax,%esi
	if(!pte){
f0100a06:	83 c4 10             	add    $0x10,%esp
f0100a09:	85 c0                	test   %eax,%eax
f0100a0b:	74 56                	je     f0100a63 <mon_changeperm+0xd2>
	if(!strcmp(type,"clr")){		
f0100a0d:	83 ec 08             	sub    $0x8,%esp
f0100a10:	68 60 75 10 f0       	push   $0xf0107560
f0100a15:	57                   	push   %edi
f0100a16:	e8 d3 5a 00 00       	call   f01064ee <strcmp>
f0100a1b:	83 c4 10             	add    $0x10,%esp
f0100a1e:	85 c0                	test   %eax,%eax
f0100a20:	74 57                	je     f0100a79 <mon_changeperm+0xe8>
	else if(!strcmp(type,"set")){		
f0100a22:	83 ec 08             	sub    $0x8,%esp
f0100a25:	68 84 75 10 f0       	push   $0xf0107584
f0100a2a:	57                   	push   %edi
f0100a2b:	e8 be 5a 00 00       	call   f01064ee <strcmp>
f0100a30:	83 c4 10             	add    $0x10,%esp
f0100a33:	85 c0                	test   %eax,%eax
f0100a35:	0f 84 ab 00 00 00    	je     f0100ae6 <mon_changeperm+0x155>
		cprintf("invalid action:%4s\n",type);
f0100a3b:	83 ec 08             	sub    $0x8,%esp
f0100a3e:	57                   	push   %edi
f0100a3f:	68 88 75 10 f0       	push   $0xf0107588
f0100a44:	e8 75 34 00 00       	call   f0103ebe <cprintf>
	return 0;
f0100a49:	83 c4 10             	add    $0x10,%esp
f0100a4c:	e9 65 ff ff ff       	jmp    f01009b6 <mon_changeperm+0x25>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100a51:	53                   	push   %ebx
f0100a52:	68 04 72 10 f0       	push   $0xf0107204
f0100a57:	6a 49                	push   $0x49
f0100a59:	68 21 75 10 f0       	push   $0xf0107521
f0100a5e:	e8 dd f5 ff ff       	call   f0100040 <_panic>
		cprintf("invalid addr:%8x\n",addr);
f0100a63:	83 ec 08             	sub    $0x8,%esp
f0100a66:	53                   	push   %ebx
f0100a67:	68 4e 75 10 f0       	push   $0xf010754e
f0100a6c:	e8 4d 34 00 00       	call   f0103ebe <cprintf>
		return 0;
f0100a71:	83 c4 10             	add    $0x10,%esp
f0100a74:	e9 3d ff ff ff       	jmp    f01009b6 <mon_changeperm+0x25>
		if(!strcmp(perm, "ur") || !strcmp(perm, "uw")){
f0100a79:	83 ec 08             	sub    $0x8,%esp
f0100a7c:	68 64 75 10 f0       	push   $0xf0107564
f0100a81:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100a84:	e8 65 5a 00 00       	call   f01064ee <strcmp>
f0100a89:	83 c4 10             	add    $0x10,%esp
f0100a8c:	85 c0                	test   %eax,%eax
f0100a8e:	75 08                	jne    f0100a98 <mon_changeperm+0x107>
			*pte = (*pte) & ~PTE_U;
f0100a90:	83 26 fb             	andl   $0xfffffffb,(%esi)
f0100a93:	e9 1e ff ff ff       	jmp    f01009b6 <mon_changeperm+0x25>
		if(!strcmp(perm, "ur") || !strcmp(perm, "uw")){
f0100a98:	83 ec 08             	sub    $0x8,%esp
f0100a9b:	68 67 75 10 f0       	push   $0xf0107567
f0100aa0:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100aa3:	e8 46 5a 00 00       	call   f01064ee <strcmp>
f0100aa8:	83 c4 10             	add    $0x10,%esp
f0100aab:	85 c0                	test   %eax,%eax
f0100aad:	74 e1                	je     f0100a90 <mon_changeperm+0xff>
		else if(!strcmp(perm, "kw")){
f0100aaf:	83 ec 08             	sub    $0x8,%esp
f0100ab2:	68 6a 75 10 f0       	push   $0xf010756a
f0100ab7:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100aba:	e8 2f 5a 00 00       	call   f01064ee <strcmp>
f0100abf:	83 c4 10             	add    $0x10,%esp
f0100ac2:	85 c0                	test   %eax,%eax
f0100ac4:	75 08                	jne    f0100ace <mon_changeperm+0x13d>
			*pte = (*pte) & ~PTE_W;
f0100ac6:	83 26 fd             	andl   $0xfffffffd,(%esi)
f0100ac9:	e9 e8 fe ff ff       	jmp    f01009b6 <mon_changeperm+0x25>
			cprintf("invalid permisson:%4s\n",perm);
f0100ace:	83 ec 08             	sub    $0x8,%esp
f0100ad1:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100ad4:	68 6d 75 10 f0       	push   $0xf010756d
f0100ad9:	e8 e0 33 00 00       	call   f0103ebe <cprintf>
f0100ade:	83 c4 10             	add    $0x10,%esp
f0100ae1:	e9 d0 fe ff ff       	jmp    f01009b6 <mon_changeperm+0x25>
		if(!strcmp(perm, "ur")){
f0100ae6:	83 ec 08             	sub    $0x8,%esp
f0100ae9:	68 64 75 10 f0       	push   $0xf0107564
f0100aee:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100af1:	e8 f8 59 00 00       	call   f01064ee <strcmp>
f0100af6:	83 c4 10             	add    $0x10,%esp
f0100af9:	85 c0                	test   %eax,%eax
f0100afb:	75 08                	jne    f0100b05 <mon_changeperm+0x174>
			*pte = (*pte) | PTE_U;
f0100afd:	83 0e 04             	orl    $0x4,(%esi)
f0100b00:	e9 b1 fe ff ff       	jmp    f01009b6 <mon_changeperm+0x25>
		else if(!strcmp(perm, "uw")){
f0100b05:	83 ec 08             	sub    $0x8,%esp
f0100b08:	68 67 75 10 f0       	push   $0xf0107567
f0100b0d:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100b10:	e8 d9 59 00 00       	call   f01064ee <strcmp>
f0100b15:	83 c4 10             	add    $0x10,%esp
f0100b18:	85 c0                	test   %eax,%eax
f0100b1a:	75 08                	jne    f0100b24 <mon_changeperm+0x193>
			*pte = (*pte) | PTE_U | PTE_W;
f0100b1c:	83 0e 06             	orl    $0x6,(%esi)
f0100b1f:	e9 92 fe ff ff       	jmp    f01009b6 <mon_changeperm+0x25>
		else if(!strcmp(perm, "kw")){
f0100b24:	83 ec 08             	sub    $0x8,%esp
f0100b27:	68 6a 75 10 f0       	push   $0xf010756a
f0100b2c:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100b2f:	e8 ba 59 00 00       	call   f01064ee <strcmp>
f0100b34:	83 c4 10             	add    $0x10,%esp
f0100b37:	85 c0                	test   %eax,%eax
f0100b39:	75 08                	jne    f0100b43 <mon_changeperm+0x1b2>
			*pte = (*pte) | PTE_W;
f0100b3b:	83 0e 02             	orl    $0x2,(%esi)
f0100b3e:	e9 73 fe ff ff       	jmp    f01009b6 <mon_changeperm+0x25>
			cprintf("invalid permisson:%4s\n",perm);
f0100b43:	83 ec 08             	sub    $0x8,%esp
f0100b46:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100b49:	68 6d 75 10 f0       	push   $0xf010756d
f0100b4e:	e8 6b 33 00 00       	call   f0103ebe <cprintf>
f0100b53:	83 c4 10             	add    $0x10,%esp
f0100b56:	e9 5b fe ff ff       	jmp    f01009b6 <mon_changeperm+0x25>

f0100b5b <mon_dump>:
mon_dump(int argc, char **argv, struct Trapframe *tf){
f0100b5b:	55                   	push   %ebp
f0100b5c:	89 e5                	mov    %esp,%ebp
f0100b5e:	57                   	push   %edi
f0100b5f:	56                   	push   %esi
f0100b60:	53                   	push   %ebx
f0100b61:	83 ec 0c             	sub    $0xc,%esp
f0100b64:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if(argc != 4){
f0100b6a:	83 f8 04             	cmp    $0x4,%eax
f0100b6d:	74 1e                	je     f0100b8d <mon_dump+0x32>
		cprintf("usage: dump [v/p] [addr] [range]\n",argc);
f0100b6f:	83 ec 08             	sub    $0x8,%esp
f0100b72:	50                   	push   %eax
f0100b73:	68 80 78 10 f0       	push   $0xf0107880
f0100b78:	e8 41 33 00 00       	call   f0103ebe <cprintf>
		return 0;
f0100b7d:	83 c4 10             	add    $0x10,%esp
}
f0100b80:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b85:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b88:	5b                   	pop    %ebx
f0100b89:	5e                   	pop    %esi
f0100b8a:	5f                   	pop    %edi
f0100b8b:	5d                   	pop    %ebp
f0100b8c:	c3                   	ret    
	char* type = argv[1];
f0100b8d:	8b 7b 04             	mov    0x4(%ebx),%edi
	uint32_t range = strtol(argv[3], NULL, 10);
f0100b90:	83 ec 04             	sub    $0x4,%esp
f0100b93:	6a 0a                	push   $0xa
f0100b95:	6a 00                	push   $0x0
f0100b97:	ff 73 0c             	pushl  0xc(%ebx)
f0100b9a:	e8 00 5b 00 00       	call   f010669f <strtol>
f0100b9f:	89 c6                	mov    %eax,%esi
	if(!strcmp(type, "p")){//physical addr
f0100ba1:	83 c4 08             	add    $0x8,%esp
f0100ba4:	68 e0 76 10 f0       	push   $0xf01076e0
f0100ba9:	57                   	push   %edi
f0100baa:	e8 3f 59 00 00       	call   f01064ee <strcmp>
f0100baf:	83 c4 10             	add    $0x10,%esp
f0100bb2:	85 c0                	test   %eax,%eax
f0100bb4:	75 63                	jne    f0100c19 <mon_dump+0xbe>
		va = (uintptr_t)KADDR(strtol(argv[2],NULL,16));
f0100bb6:	83 ec 04             	sub    $0x4,%esp
f0100bb9:	6a 10                	push   $0x10
f0100bbb:	6a 00                	push   $0x0
f0100bbd:	ff 73 08             	pushl  0x8(%ebx)
f0100bc0:	e8 da 5a 00 00       	call   f010669f <strtol>
	if (PGNUM(pa) >= npages)
f0100bc5:	89 c2                	mov    %eax,%edx
f0100bc7:	c1 ea 0c             	shr    $0xc,%edx
f0100bca:	83 c4 10             	add    $0x10,%esp
f0100bcd:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f0100bd3:	73 2f                	jae    f0100c04 <mon_dump+0xa9>
	return (void *)(pa + KERNBASE);
f0100bd5:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	va = ROUNDDOWN(va, sizeof(uint32_t));
f0100bdb:	83 e3 fc             	and    $0xfffffffc,%ebx
	uintptr_t va_to = ROUNDUP(va+range,sizeof(uint32_t));
f0100bde:	8d 74 33 03          	lea    0x3(%ebx,%esi,1),%esi
f0100be2:	83 e6 fc             	and    $0xfffffffc,%esi
	cprintf("%10s |%12s\n","VADDR","CONTENT");
f0100be5:	83 ec 04             	sub    $0x4,%esp
f0100be8:	68 b6 75 10 f0       	push   $0xf01075b6
f0100bed:	68 02 75 10 f0       	push   $0xf0107502
f0100bf2:	68 be 75 10 f0       	push   $0xf01075be
f0100bf7:	e8 c2 32 00 00       	call   f0103ebe <cprintf>
	for(;va<va_to;va+=sizeof(uint32_t)){
f0100bfc:	83 c4 10             	add    $0x10,%esp
f0100bff:	e9 83 00 00 00       	jmp    f0100c87 <mon_dump+0x12c>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100c04:	50                   	push   %eax
f0100c05:	68 04 72 10 f0       	push   $0xf0107204
f0100c0a:	68 80 00 00 00       	push   $0x80
f0100c0f:	68 21 75 10 f0       	push   $0xf0107521
f0100c14:	e8 27 f4 ff ff       	call   f0100040 <_panic>
	else if(!strcmp(type, "v")){//virtual addr
f0100c19:	83 ec 08             	sub    $0x8,%esp
f0100c1c:	68 31 8a 10 f0       	push   $0xf0108a31
f0100c21:	57                   	push   %edi
f0100c22:	e8 c7 58 00 00       	call   f01064ee <strcmp>
f0100c27:	83 c4 10             	add    $0x10,%esp
f0100c2a:	85 c0                	test   %eax,%eax
f0100c2c:	75 16                	jne    f0100c44 <mon_dump+0xe9>
		va = strtol(argv[2],NULL,16);
f0100c2e:	83 ec 04             	sub    $0x4,%esp
f0100c31:	6a 10                	push   $0x10
f0100c33:	6a 00                	push   $0x0
f0100c35:	ff 73 08             	pushl  0x8(%ebx)
f0100c38:	e8 62 5a 00 00       	call   f010669f <strtol>
f0100c3d:	89 c3                	mov    %eax,%ebx
f0100c3f:	83 c4 10             	add    $0x10,%esp
f0100c42:	eb 97                	jmp    f0100bdb <mon_dump+0x80>
		cprintf("invalid address type:%4s\n",type);
f0100c44:	83 ec 08             	sub    $0x8,%esp
f0100c47:	57                   	push   %edi
f0100c48:	68 9c 75 10 f0       	push   $0xf010759c
f0100c4d:	e8 6c 32 00 00       	call   f0103ebe <cprintf>
		return 0;
f0100c52:	83 c4 10             	add    $0x10,%esp
f0100c55:	e9 26 ff ff ff       	jmp    f0100b80 <mon_dump+0x25>
		uint32_t cont = *(uint32_t*)va;
f0100c5a:	8b 03                	mov    (%ebx),%eax
		cprintf("0x%8x | %02x %02x %02x %02x\n",va,(cont>>0)&0xFF,(cont>>8)&0xFF,(cont>>16)&0xFF,(cont>>24)&0xFF);
f0100c5c:	83 ec 08             	sub    $0x8,%esp
f0100c5f:	89 c2                	mov    %eax,%edx
f0100c61:	c1 ea 18             	shr    $0x18,%edx
f0100c64:	52                   	push   %edx
f0100c65:	89 c2                	mov    %eax,%edx
f0100c67:	c1 ea 10             	shr    $0x10,%edx
f0100c6a:	0f b6 d2             	movzbl %dl,%edx
f0100c6d:	52                   	push   %edx
f0100c6e:	0f b6 d4             	movzbl %ah,%edx
f0100c71:	52                   	push   %edx
f0100c72:	0f b6 c0             	movzbl %al,%eax
f0100c75:	50                   	push   %eax
f0100c76:	53                   	push   %ebx
f0100c77:	68 e2 75 10 f0       	push   $0xf01075e2
f0100c7c:	e8 3d 32 00 00       	call   f0103ebe <cprintf>
	for(;va<va_to;va+=sizeof(uint32_t)){
f0100c81:	83 c3 04             	add    $0x4,%ebx
f0100c84:	83 c4 20             	add    $0x20,%esp
f0100c87:	39 f3                	cmp    %esi,%ebx
f0100c89:	0f 83 f1 fe ff ff    	jae    f0100b80 <mon_dump+0x25>
		pte_t* pte = pgdir_walk(kern_pgdir,(void*)va,0);
f0100c8f:	83 ec 04             	sub    $0x4,%esp
f0100c92:	6a 00                	push   $0x0
f0100c94:	53                   	push   %ebx
f0100c95:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0100c9b:	e8 45 08 00 00       	call   f01014e5 <pgdir_walk>
		if(!pte || !(*pte & PTE_P)){
f0100ca0:	83 c4 10             	add    $0x10,%esp
f0100ca3:	85 c0                	test   %eax,%eax
f0100ca5:	74 05                	je     f0100cac <mon_dump+0x151>
f0100ca7:	f6 00 01             	testb  $0x1,(%eax)
f0100caa:	75 ae                	jne    f0100c5a <mon_dump+0xff>
			cprintf("invalid address: 0x%8x\n",va);
f0100cac:	83 ec 08             	sub    $0x8,%esp
f0100caf:	53                   	push   %ebx
f0100cb0:	68 ca 75 10 f0       	push   $0xf01075ca
f0100cb5:	e8 04 32 00 00       	call   f0103ebe <cprintf>
			break;
f0100cba:	83 c4 10             	add    $0x10,%esp
f0100cbd:	e9 be fe ff ff       	jmp    f0100b80 <mon_dump+0x25>

f0100cc2 <do_overflow>:
    return pretaddr;
}

void
do_overflow(void)
{
f0100cc2:	55                   	push   %ebp
f0100cc3:	89 e5                	mov    %esp,%ebp
f0100cc5:	83 ec 14             	sub    $0x14,%esp
    cprintf("Overflow success\n");
f0100cc8:	68 ff 75 10 f0       	push   $0xf01075ff
f0100ccd:	e8 ec 31 00 00       	call   f0103ebe <cprintf>
}
f0100cd2:	83 c4 10             	add    $0x10,%esp
f0100cd5:	c9                   	leave  
f0100cd6:	c3                   	ret    

f0100cd7 <start_overflow>:

void
start_overflow(void)
{
f0100cd7:	55                   	push   %ebp
f0100cd8:	89 e5                	mov    %esp,%ebp
f0100cda:	53                   	push   %ebx
f0100cdb:	83 ec 0c             	sub    $0xc,%esp
    __asm __volatile("leal 4(%%ebp), %0" : "=r" (pretaddr)); 
f0100cde:	8d 5d 04             	lea    0x4(%ebp),%ebx

	// Your code here.
    
	pret_addr = (char*)read_pretaddr();
	//ret to do_overflow
	cprintf("old rip: %lx\n", *(uint32_t*)pret_addr);
f0100ce1:	ff 33                	pushl  (%ebx)
f0100ce3:	68 11 76 10 f0       	push   $0xf0107611
f0100ce8:	e8 d1 31 00 00       	call   f0103ebe <cprintf>
	cprintf("%45d%n\n",nstr, pret_addr);//0x2d
f0100ced:	83 c4 0c             	add    $0xc,%esp
f0100cf0:	53                   	push   %ebx
f0100cf1:	6a 00                	push   $0x0
f0100cf3:	68 1f 76 10 f0       	push   $0xf010761f
f0100cf8:	e8 c1 31 00 00       	call   f0103ebe <cprintf>
	cprintf("%9d%n\n",nstr, pret_addr+1);//0x09
f0100cfd:	83 c4 0c             	add    $0xc,%esp
f0100d00:	8d 43 01             	lea    0x1(%ebx),%eax
f0100d03:	50                   	push   %eax
f0100d04:	6a 00                	push   $0x0
f0100d06:	68 27 76 10 f0       	push   $0xf0107627
f0100d0b:	e8 ae 31 00 00       	call   f0103ebe <cprintf>
	cprintf("new rip: %lx\n", *(uint32_t*)pret_addr);
f0100d10:	83 c4 08             	add    $0x8,%esp
f0100d13:	ff 33                	pushl  (%ebx)
f0100d15:	68 2e 76 10 f0       	push   $0xf010762e
f0100d1a:	e8 9f 31 00 00       	call   f0103ebe <cprintf>

	//ret to mon_bacKtrace from do_overflow
	//cprintf("old rip up: %lx\n", *((uint32_t*)pret_addr+1));
	cprintf("%36d%n\n",nstr, pret_addr+4);//0x24
f0100d1f:	83 c4 0c             	add    $0xc,%esp
f0100d22:	8d 43 04             	lea    0x4(%ebx),%eax
f0100d25:	50                   	push   %eax
f0100d26:	6a 00                	push   $0x0
f0100d28:	68 3c 76 10 f0       	push   $0xf010763c
f0100d2d:	e8 8c 31 00 00       	call   f0103ebe <cprintf>
	cprintf("%10d%n\n", nstr, pret_addr+5);//0x0a
f0100d32:	83 c4 0c             	add    $0xc,%esp
f0100d35:	8d 43 05             	lea    0x5(%ebx),%eax
f0100d38:	50                   	push   %eax
f0100d39:	6a 00                	push   $0x0
f0100d3b:	68 44 76 10 f0       	push   $0xf0107644
f0100d40:	e8 79 31 00 00       	call   f0103ebe <cprintf>
	cprintf("%16d%n\n",nstr, pret_addr+6);//0x10
f0100d45:	83 c4 0c             	add    $0xc,%esp
f0100d48:	8d 43 06             	lea    0x6(%ebx),%eax
f0100d4b:	50                   	push   %eax
f0100d4c:	6a 00                	push   $0x0
f0100d4e:	68 4c 76 10 f0       	push   $0xf010764c
f0100d53:	e8 66 31 00 00       	call   f0103ebe <cprintf>
	cprintf("%240d%n\n",nstr, pret_addr+7);//0xf0
f0100d58:	83 c4 0c             	add    $0xc,%esp
f0100d5b:	83 c3 07             	add    $0x7,%ebx
f0100d5e:	53                   	push   %ebx
f0100d5f:	6a 00                	push   $0x0
f0100d61:	68 54 76 10 f0       	push   $0xf0107654
f0100d66:	e8 53 31 00 00       	call   f0103ebe <cprintf>
	//cprintf("new rip up: %lx\n", *((uint32_t*)pret_addr+1));
	
}
f0100d6b:	83 c4 10             	add    $0x10,%esp
f0100d6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100d71:	c9                   	leave  
f0100d72:	c3                   	ret    

f0100d73 <overflow_me>:

void
overflow_me(void)
{
f0100d73:	55                   	push   %ebp
f0100d74:	89 e5                	mov    %esp,%ebp
f0100d76:	83 ec 08             	sub    $0x8,%esp
    start_overflow();
f0100d79:	e8 59 ff ff ff       	call   f0100cd7 <start_overflow>
	cprintf("");
f0100d7e:	83 ec 0c             	sub    $0xc,%esp
f0100d81:	68 a7 87 10 f0       	push   $0xf01087a7
f0100d86:	e8 33 31 00 00       	call   f0103ebe <cprintf>
}
f0100d8b:	83 c4 10             	add    $0x10,%esp
f0100d8e:	c9                   	leave  
f0100d8f:	c3                   	ret    

f0100d90 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100d90:	55                   	push   %ebp
f0100d91:	89 e5                	mov    %esp,%ebp
f0100d93:	57                   	push   %edi
f0100d94:	56                   	push   %esi
f0100d95:	53                   	push   %ebx
f0100d96:	83 ec 38             	sub    $0x38,%esp
	// Your code here.
	cprintf("Stack backtrace:\n");
f0100d99:	68 5d 76 10 f0       	push   $0xf010765d
f0100d9e:	e8 1b 31 00 00       	call   f0103ebe <cprintf>
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100da3:	89 eb                	mov    %ebp,%ebx
	uint32_t ebp = read_ebp();
	while(ebp!=0){
f0100da5:	83 c4 10             	add    $0x10,%esp
		uint32_t eip = *(int*)(ebp+4);
		cprintf("  eip %08x  ebp %08x  args %08x %08x %08x %08x %08x\n",
				eip, ebp,
				*(int*)(ebp+8),*(int*)(ebp+12),*(int*)(ebp+16),*(int*)(ebp+20),*(int*)(ebp+24));
		struct Eipdebuginfo info;
		if(debuginfo_eip(eip,&info)>=0){
f0100da8:	8d 7d d0             	lea    -0x30(%ebp),%edi
	while(ebp!=0){
f0100dab:	eb 02                	jmp    f0100daf <mon_backtrace+0x1f>
			cprintf("         %s:%d %.*s+%d\n",
			info.eip_file, info.eip_line,
			info.eip_fn_namelen, info.eip_fn_name, eip-info.eip_fn_addr);
		}
		ebp = *(int*)ebp;
f0100dad:	8b 1b                	mov    (%ebx),%ebx
	while(ebp!=0){
f0100daf:	85 db                	test   %ebx,%ebx
f0100db1:	74 51                	je     f0100e04 <mon_backtrace+0x74>
		uint32_t eip = *(int*)(ebp+4);
f0100db3:	8b 73 04             	mov    0x4(%ebx),%esi
		cprintf("  eip %08x  ebp %08x  args %08x %08x %08x %08x %08x\n",
f0100db6:	ff 73 18             	pushl  0x18(%ebx)
f0100db9:	ff 73 14             	pushl  0x14(%ebx)
f0100dbc:	ff 73 10             	pushl  0x10(%ebx)
f0100dbf:	ff 73 0c             	pushl  0xc(%ebx)
f0100dc2:	ff 73 08             	pushl  0x8(%ebx)
f0100dc5:	53                   	push   %ebx
f0100dc6:	56                   	push   %esi
f0100dc7:	68 a4 78 10 f0       	push   $0xf01078a4
f0100dcc:	e8 ed 30 00 00       	call   f0103ebe <cprintf>
		if(debuginfo_eip(eip,&info)>=0){
f0100dd1:	83 c4 18             	add    $0x18,%esp
f0100dd4:	57                   	push   %edi
f0100dd5:	56                   	push   %esi
f0100dd6:	e8 8f 4b 00 00       	call   f010596a <debuginfo_eip>
f0100ddb:	83 c4 10             	add    $0x10,%esp
f0100dde:	85 c0                	test   %eax,%eax
f0100de0:	78 cb                	js     f0100dad <mon_backtrace+0x1d>
			cprintf("         %s:%d %.*s+%d\n",
f0100de2:	83 ec 08             	sub    $0x8,%esp
f0100de5:	2b 75 e0             	sub    -0x20(%ebp),%esi
f0100de8:	56                   	push   %esi
f0100de9:	ff 75 d8             	pushl  -0x28(%ebp)
f0100dec:	ff 75 dc             	pushl  -0x24(%ebp)
f0100def:	ff 75 d4             	pushl  -0x2c(%ebp)
f0100df2:	ff 75 d0             	pushl  -0x30(%ebp)
f0100df5:	68 6f 76 10 f0       	push   $0xf010766f
f0100dfa:	e8 bf 30 00 00       	call   f0103ebe <cprintf>
f0100dff:	83 c4 20             	add    $0x20,%esp
f0100e02:	eb a9                	jmp    f0100dad <mon_backtrace+0x1d>
	}

	overflow_me();
f0100e04:	e8 6a ff ff ff       	call   f0100d73 <overflow_me>
    	cprintf("Backtrace success\n");
f0100e09:	83 ec 0c             	sub    $0xc,%esp
f0100e0c:	68 87 76 10 f0       	push   $0xf0107687
f0100e11:	e8 a8 30 00 00       	call   f0103ebe <cprintf>
		cprintf("debug\n");
f0100e16:	c7 04 24 9a 76 10 f0 	movl   $0xf010769a,(%esp)
f0100e1d:	e8 9c 30 00 00       	call   f0103ebe <cprintf>
	return 0;
}
f0100e22:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e2a:	5b                   	pop    %ebx
f0100e2b:	5e                   	pop    %esi
f0100e2c:	5f                   	pop    %edi
f0100e2d:	5d                   	pop    %ebp
f0100e2e:	c3                   	ret    

f0100e2f <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100e2f:	55                   	push   %ebp
f0100e30:	89 e5                	mov    %esp,%ebp
f0100e32:	57                   	push   %edi
f0100e33:	56                   	push   %esi
f0100e34:	53                   	push   %ebx
f0100e35:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100e38:	68 dc 78 10 f0       	push   $0xf01078dc
f0100e3d:	e8 7c 30 00 00       	call   f0103ebe <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100e42:	c7 04 24 00 79 10 f0 	movl   $0xf0107900,(%esp)
f0100e49:	e8 70 30 00 00       	call   f0103ebe <cprintf>

	if (tf != NULL)
f0100e4e:	83 c4 10             	add    $0x10,%esp
f0100e51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100e55:	0f 84 d9 00 00 00    	je     f0100f34 <monitor+0x105>
		print_trapframe(tf);
f0100e5b:	83 ec 0c             	sub    $0xc,%esp
f0100e5e:	ff 75 08             	pushl  0x8(%ebp)
f0100e61:	e8 e1 37 00 00       	call   f0104647 <print_trapframe>
f0100e66:	83 c4 10             	add    $0x10,%esp
f0100e69:	e9 c6 00 00 00       	jmp    f0100f34 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100e6e:	83 ec 08             	sub    $0x8,%esp
f0100e71:	0f be c0             	movsbl %al,%eax
f0100e74:	50                   	push   %eax
f0100e75:	68 a5 76 10 f0       	push   $0xf01076a5
f0100e7a:	e8 cd 56 00 00       	call   f010654c <strchr>
f0100e7f:	83 c4 10             	add    $0x10,%esp
f0100e82:	85 c0                	test   %eax,%eax
f0100e84:	74 63                	je     f0100ee9 <monitor+0xba>
			*buf++ = 0;
f0100e86:	c6 03 00             	movb   $0x0,(%ebx)
f0100e89:	89 f7                	mov    %esi,%edi
f0100e8b:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100e8e:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100e90:	0f b6 03             	movzbl (%ebx),%eax
f0100e93:	84 c0                	test   %al,%al
f0100e95:	75 d7                	jne    f0100e6e <monitor+0x3f>
	argv[argc] = 0;
f0100e97:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100e9e:	00 
	if (argc == 0)
f0100e9f:	85 f6                	test   %esi,%esi
f0100ea1:	0f 84 8d 00 00 00    	je     f0100f34 <monitor+0x105>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100eac:	83 ec 08             	sub    $0x8,%esp
f0100eaf:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100eb2:	ff 34 85 60 7a 10 f0 	pushl  -0xfef85a0(,%eax,4)
f0100eb9:	ff 75 a8             	pushl  -0x58(%ebp)
f0100ebc:	e8 2d 56 00 00       	call   f01064ee <strcmp>
f0100ec1:	83 c4 10             	add    $0x10,%esp
f0100ec4:	85 c0                	test   %eax,%eax
f0100ec6:	0f 84 8f 00 00 00    	je     f0100f5b <monitor+0x12c>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100ecc:	83 c3 01             	add    $0x1,%ebx
f0100ecf:	83 fb 06             	cmp    $0x6,%ebx
f0100ed2:	75 d8                	jne    f0100eac <monitor+0x7d>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100ed4:	83 ec 08             	sub    $0x8,%esp
f0100ed7:	ff 75 a8             	pushl  -0x58(%ebp)
f0100eda:	68 c7 76 10 f0       	push   $0xf01076c7
f0100edf:	e8 da 2f 00 00       	call   f0103ebe <cprintf>
f0100ee4:	83 c4 10             	add    $0x10,%esp
f0100ee7:	eb 4b                	jmp    f0100f34 <monitor+0x105>
		if (*buf == 0)
f0100ee9:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100eec:	74 a9                	je     f0100e97 <monitor+0x68>
		if (argc == MAXARGS-1) {
f0100eee:	83 fe 0f             	cmp    $0xf,%esi
f0100ef1:	74 2f                	je     f0100f22 <monitor+0xf3>
		argv[argc++] = buf;
f0100ef3:	8d 7e 01             	lea    0x1(%esi),%edi
f0100ef6:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100efa:	0f b6 03             	movzbl (%ebx),%eax
f0100efd:	84 c0                	test   %al,%al
f0100eff:	74 8d                	je     f0100e8e <monitor+0x5f>
f0100f01:	83 ec 08             	sub    $0x8,%esp
f0100f04:	0f be c0             	movsbl %al,%eax
f0100f07:	50                   	push   %eax
f0100f08:	68 a5 76 10 f0       	push   $0xf01076a5
f0100f0d:	e8 3a 56 00 00       	call   f010654c <strchr>
f0100f12:	83 c4 10             	add    $0x10,%esp
f0100f15:	85 c0                	test   %eax,%eax
f0100f17:	0f 85 71 ff ff ff    	jne    f0100e8e <monitor+0x5f>
			buf++;
f0100f1d:	83 c3 01             	add    $0x1,%ebx
f0100f20:	eb d8                	jmp    f0100efa <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100f22:	83 ec 08             	sub    $0x8,%esp
f0100f25:	6a 10                	push   $0x10
f0100f27:	68 aa 76 10 f0       	push   $0xf01076aa
f0100f2c:	e8 8d 2f 00 00       	call   f0103ebe <cprintf>
f0100f31:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100f34:	83 ec 0c             	sub    $0xc,%esp
f0100f37:	68 a1 76 10 f0       	push   $0xf01076a1
f0100f3c:	e8 db 53 00 00       	call   f010631c <readline>
f0100f41:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100f43:	83 c4 10             	add    $0x10,%esp
f0100f46:	85 c0                	test   %eax,%eax
f0100f48:	74 ea                	je     f0100f34 <monitor+0x105>
	argv[argc] = 0;
f0100f4a:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100f51:	be 00 00 00 00       	mov    $0x0,%esi
f0100f56:	e9 35 ff ff ff       	jmp    f0100e90 <monitor+0x61>
			return commands[i].func(argc, argv, tf);
f0100f5b:	83 ec 04             	sub    $0x4,%esp
f0100f5e:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100f61:	ff 75 08             	pushl  0x8(%ebp)
f0100f64:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100f67:	52                   	push   %edx
f0100f68:	56                   	push   %esi
f0100f69:	ff 14 85 68 7a 10 f0 	call   *-0xfef8598(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100f70:	83 c4 10             	add    $0x10,%esp
f0100f73:	85 c0                	test   %eax,%eax
f0100f75:	79 bd                	jns    f0100f34 <monitor+0x105>
				break;
	}
}
f0100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f7a:	5b                   	pop    %ebx
f0100f7b:	5e                   	pop    %esi
f0100f7c:	5f                   	pop    %edi
f0100f7d:	5d                   	pop    %ebp
f0100f7e:	c3                   	ret    

f0100f7f <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100f7f:	83 3d 38 62 35 f0 00 	cmpl   $0x0,0xf0356238
f0100f86:	74 1c                	je     f0100fa4 <boot_alloc+0x25>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100f88:	8b 0d 38 62 35 f0    	mov    0xf0356238,%ecx
	nextfree = ROUNDUP(result+n,PGSIZE);
f0100f8e:	8d 94 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edx
f0100f95:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100f9b:	89 15 38 62 35 f0    	mov    %edx,0xf0356238

	return result;
}
f0100fa1:	89 c8                	mov    %ecx,%eax
f0100fa3:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100fa4:	ba 07 90 39 f0       	mov    $0xf0399007,%edx
f0100fa9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100faf:	89 15 38 62 35 f0    	mov    %edx,0xf0356238
f0100fb5:	eb d1                	jmp    f0100f88 <boot_alloc+0x9>

f0100fb7 <nvram_read>:
{
f0100fb7:	55                   	push   %ebp
f0100fb8:	89 e5                	mov    %esp,%ebp
f0100fba:	56                   	push   %esi
f0100fbb:	53                   	push   %ebx
f0100fbc:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100fbe:	83 ec 0c             	sub    $0xc,%esp
f0100fc1:	50                   	push   %eax
f0100fc2:	e8 62 2d 00 00       	call   f0103d29 <mc146818_read>
f0100fc7:	89 c3                	mov    %eax,%ebx
f0100fc9:	83 c6 01             	add    $0x1,%esi
f0100fcc:	89 34 24             	mov    %esi,(%esp)
f0100fcf:	e8 55 2d 00 00       	call   f0103d29 <mc146818_read>
f0100fd4:	c1 e0 08             	shl    $0x8,%eax
f0100fd7:	09 d8                	or     %ebx,%eax
}
f0100fd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100fdc:	5b                   	pop    %ebx
f0100fdd:	5e                   	pop    %esi
f0100fde:	5d                   	pop    %ebp
f0100fdf:	c3                   	ret    

f0100fe0 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100fe0:	89 d1                	mov    %edx,%ecx
f0100fe2:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P)){
f0100fe5:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100fe8:	a8 01                	test   $0x1,%al
f0100fea:	74 52                	je     f010103e <check_va2pa+0x5e>
		return ~0;
	}
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100fec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100ff1:	89 c1                	mov    %eax,%ecx
f0100ff3:	c1 e9 0c             	shr    $0xc,%ecx
f0100ff6:	3b 0d 88 6e 35 f0    	cmp    0xf0356e88,%ecx
f0100ffc:	73 25                	jae    f0101023 <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P)){
f0100ffe:	c1 ea 0c             	shr    $0xc,%edx
f0101001:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0101007:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f010100e:	89 c2                	mov    %eax,%edx
f0101010:	83 e2 01             	and    $0x1,%edx
		return ~0;
	}
	return PTE_ADDR(p[PTX(va)]);
f0101013:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101018:	85 d2                	test   %edx,%edx
f010101a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010101f:	0f 44 c2             	cmove  %edx,%eax
f0101022:	c3                   	ret    
{
f0101023:	55                   	push   %ebp
f0101024:	89 e5                	mov    %esp,%ebp
f0101026:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101029:	50                   	push   %eax
f010102a:	68 04 72 10 f0       	push   $0xf0107204
f010102f:	68 da 03 00 00       	push   $0x3da
f0101034:	68 a1 84 10 f0       	push   $0xf01084a1
f0101039:	e8 02 f0 ff ff       	call   f0100040 <_panic>
		return ~0;
f010103e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0101043:	c3                   	ret    

f0101044 <check_page_free_list>:
{
f0101044:	55                   	push   %ebp
f0101045:	89 e5                	mov    %esp,%ebp
f0101047:	57                   	push   %edi
f0101048:	56                   	push   %esi
f0101049:	53                   	push   %ebx
f010104a:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010104d:	84 c0                	test   %al,%al
f010104f:	0f 85 77 02 00 00    	jne    f01012cc <check_page_free_list+0x288>
	if (!page_free_list)
f0101055:	83 3d 40 62 35 f0 00 	cmpl   $0x0,0xf0356240
f010105c:	74 0a                	je     f0101068 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010105e:	be 00 04 00 00       	mov    $0x400,%esi
f0101063:	e9 bf 02 00 00       	jmp    f0101327 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0101068:	83 ec 04             	sub    $0x4,%esp
f010106b:	68 a8 7a 10 f0       	push   $0xf0107aa8
f0101070:	68 05 03 00 00       	push   $0x305
f0101075:	68 a1 84 10 f0       	push   $0xf01084a1
f010107a:	e8 c1 ef ff ff       	call   f0100040 <_panic>
f010107f:	50                   	push   %eax
f0101080:	68 04 72 10 f0       	push   $0xf0107204
f0101085:	6a 58                	push   $0x58
f0101087:	68 ad 84 10 f0       	push   $0xf01084ad
f010108c:	e8 af ef ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101091:	8b 1b                	mov    (%ebx),%ebx
f0101093:	85 db                	test   %ebx,%ebx
f0101095:	74 41                	je     f01010d8 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101097:	89 d8                	mov    %ebx,%eax
f0101099:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f010109f:	c1 f8 03             	sar    $0x3,%eax
f01010a2:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f01010a5:	89 c2                	mov    %eax,%edx
f01010a7:	c1 ea 16             	shr    $0x16,%edx
f01010aa:	39 f2                	cmp    %esi,%edx
f01010ac:	73 e3                	jae    f0101091 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f01010ae:	89 c2                	mov    %eax,%edx
f01010b0:	c1 ea 0c             	shr    $0xc,%edx
f01010b3:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f01010b9:	73 c4                	jae    f010107f <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f01010bb:	83 ec 04             	sub    $0x4,%esp
f01010be:	68 80 00 00 00       	push   $0x80
f01010c3:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f01010c8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01010cd:	50                   	push   %eax
f01010ce:	e8 b6 54 00 00       	call   f0106589 <memset>
f01010d3:	83 c4 10             	add    $0x10,%esp
f01010d6:	eb b9                	jmp    f0101091 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f01010d8:	b8 00 00 00 00       	mov    $0x0,%eax
f01010dd:	e8 9d fe ff ff       	call   f0100f7f <boot_alloc>
f01010e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01010e5:	8b 15 40 62 35 f0    	mov    0xf0356240,%edx
		assert(pp >= pages);
f01010eb:	8b 0d 90 6e 35 f0    	mov    0xf0356e90,%ecx
		assert(pp < pages + npages);
f01010f1:	a1 88 6e 35 f0       	mov    0xf0356e88,%eax
f01010f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01010f9:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f01010fc:	bf 00 00 00 00       	mov    $0x0,%edi
f0101101:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101104:	e9 f9 00 00 00       	jmp    f0101202 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0101109:	68 bb 84 10 f0       	push   $0xf01084bb
f010110e:	68 c7 84 10 f0       	push   $0xf01084c7
f0101113:	68 1f 03 00 00       	push   $0x31f
f0101118:	68 a1 84 10 f0       	push   $0xf01084a1
f010111d:	e8 1e ef ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0101122:	68 dc 84 10 f0       	push   $0xf01084dc
f0101127:	68 c7 84 10 f0       	push   $0xf01084c7
f010112c:	68 20 03 00 00       	push   $0x320
f0101131:	68 a1 84 10 f0       	push   $0xf01084a1
f0101136:	e8 05 ef ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f010113b:	68 cc 7a 10 f0       	push   $0xf0107acc
f0101140:	68 c7 84 10 f0       	push   $0xf01084c7
f0101145:	68 21 03 00 00       	push   $0x321
f010114a:	68 a1 84 10 f0       	push   $0xf01084a1
f010114f:	e8 ec ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0101154:	68 f0 84 10 f0       	push   $0xf01084f0
f0101159:	68 c7 84 10 f0       	push   $0xf01084c7
f010115e:	68 24 03 00 00       	push   $0x324
f0101163:	68 a1 84 10 f0       	push   $0xf01084a1
f0101168:	e8 d3 ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f010116d:	68 01 85 10 f0       	push   $0xf0108501
f0101172:	68 c7 84 10 f0       	push   $0xf01084c7
f0101177:	68 25 03 00 00       	push   $0x325
f010117c:	68 a1 84 10 f0       	push   $0xf01084a1
f0101181:	e8 ba ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101186:	68 00 7b 10 f0       	push   $0xf0107b00
f010118b:	68 c7 84 10 f0       	push   $0xf01084c7
f0101190:	68 26 03 00 00       	push   $0x326
f0101195:	68 a1 84 10 f0       	push   $0xf01084a1
f010119a:	e8 a1 ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f010119f:	68 1a 85 10 f0       	push   $0xf010851a
f01011a4:	68 c7 84 10 f0       	push   $0xf01084c7
f01011a9:	68 27 03 00 00       	push   $0x327
f01011ae:	68 a1 84 10 f0       	push   $0xf01084a1
f01011b3:	e8 88 ee ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f01011b8:	89 c3                	mov    %eax,%ebx
f01011ba:	c1 eb 0c             	shr    $0xc,%ebx
f01011bd:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f01011c0:	76 0f                	jbe    f01011d1 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f01011c2:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01011c7:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01011ca:	77 17                	ja     f01011e3 <check_page_free_list+0x19f>
			++nfree_extmem;
f01011cc:	83 c7 01             	add    $0x1,%edi
f01011cf:	eb 2f                	jmp    f0101200 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01011d1:	50                   	push   %eax
f01011d2:	68 04 72 10 f0       	push   $0xf0107204
f01011d7:	6a 58                	push   $0x58
f01011d9:	68 ad 84 10 f0       	push   $0xf01084ad
f01011de:	e8 5d ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01011e3:	68 24 7b 10 f0       	push   $0xf0107b24
f01011e8:	68 c7 84 10 f0       	push   $0xf01084c7
f01011ed:	68 28 03 00 00       	push   $0x328
f01011f2:	68 a1 84 10 f0       	push   $0xf01084a1
f01011f7:	e8 44 ee ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f01011fc:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101200:	8b 12                	mov    (%edx),%edx
f0101202:	85 d2                	test   %edx,%edx
f0101204:	74 74                	je     f010127a <check_page_free_list+0x236>
		assert(pp >= pages);
f0101206:	39 d1                	cmp    %edx,%ecx
f0101208:	0f 87 fb fe ff ff    	ja     f0101109 <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f010120e:	39 d6                	cmp    %edx,%esi
f0101210:	0f 86 0c ff ff ff    	jbe    f0101122 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101216:	89 d0                	mov    %edx,%eax
f0101218:	29 c8                	sub    %ecx,%eax
f010121a:	a8 07                	test   $0x7,%al
f010121c:	0f 85 19 ff ff ff    	jne    f010113b <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0101222:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0101225:	c1 e0 0c             	shl    $0xc,%eax
f0101228:	0f 84 26 ff ff ff    	je     f0101154 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f010122e:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101233:	0f 84 34 ff ff ff    	je     f010116d <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101239:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f010123e:	0f 84 42 ff ff ff    	je     f0101186 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101244:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0101249:	0f 84 50 ff ff ff    	je     f010119f <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f010124f:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101254:	0f 87 5e ff ff ff    	ja     f01011b8 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f010125a:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010125f:	75 9b                	jne    f01011fc <check_page_free_list+0x1b8>
f0101261:	68 34 85 10 f0       	push   $0xf0108534
f0101266:	68 c7 84 10 f0       	push   $0xf01084c7
f010126b:	68 2a 03 00 00       	push   $0x32a
f0101270:	68 a1 84 10 f0       	push   $0xf01084a1
f0101275:	e8 c6 ed ff ff       	call   f0100040 <_panic>
f010127a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f010127d:	85 db                	test   %ebx,%ebx
f010127f:	7e 19                	jle    f010129a <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0101281:	85 ff                	test   %edi,%edi
f0101283:	7e 2e                	jle    f01012b3 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0101285:	83 ec 0c             	sub    $0xc,%esp
f0101288:	68 6c 7b 10 f0       	push   $0xf0107b6c
f010128d:	e8 2c 2c 00 00       	call   f0103ebe <cprintf>
}
f0101292:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101295:	5b                   	pop    %ebx
f0101296:	5e                   	pop    %esi
f0101297:	5f                   	pop    %edi
f0101298:	5d                   	pop    %ebp
f0101299:	c3                   	ret    
	assert(nfree_basemem > 0);
f010129a:	68 51 85 10 f0       	push   $0xf0108551
f010129f:	68 c7 84 10 f0       	push   $0xf01084c7
f01012a4:	68 32 03 00 00       	push   $0x332
f01012a9:	68 a1 84 10 f0       	push   $0xf01084a1
f01012ae:	e8 8d ed ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f01012b3:	68 63 85 10 f0       	push   $0xf0108563
f01012b8:	68 c7 84 10 f0       	push   $0xf01084c7
f01012bd:	68 33 03 00 00       	push   $0x333
f01012c2:	68 a1 84 10 f0       	push   $0xf01084a1
f01012c7:	e8 74 ed ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f01012cc:	a1 40 62 35 f0       	mov    0xf0356240,%eax
f01012d1:	85 c0                	test   %eax,%eax
f01012d3:	0f 84 8f fd ff ff    	je     f0101068 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f01012d9:	8d 55 d8             	lea    -0x28(%ebp),%edx
f01012dc:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01012df:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01012e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01012e5:	89 c2                	mov    %eax,%edx
f01012e7:	2b 15 90 6e 35 f0    	sub    0xf0356e90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f01012ed:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f01012f3:	0f 95 c2             	setne  %dl
f01012f6:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f01012f9:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f01012fd:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f01012ff:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101303:	8b 00                	mov    (%eax),%eax
f0101305:	85 c0                	test   %eax,%eax
f0101307:	75 dc                	jne    f01012e5 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f0101309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010130c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101312:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101315:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101318:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f010131a:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010131d:	a3 40 62 35 f0       	mov    %eax,0xf0356240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101322:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101327:	8b 1d 40 62 35 f0    	mov    0xf0356240,%ebx
f010132d:	e9 61 fd ff ff       	jmp    f0101093 <check_page_free_list+0x4f>

f0101332 <page_init>:
{
f0101332:	55                   	push   %ebp
f0101333:	89 e5                	mov    %esp,%ebp
f0101335:	57                   	push   %edi
f0101336:	56                   	push   %esi
f0101337:	53                   	push   %ebx
f0101338:	83 ec 0c             	sub    $0xc,%esp
	page_free_list = NULL;
f010133b:	c7 05 40 62 35 f0 00 	movl   $0x0,0xf0356240
f0101342:	00 00 00 
	size_t next = PADDR(boot_alloc(0)) / PGSIZE;
f0101345:	b8 00 00 00 00       	mov    $0x0,%eax
f010134a:	e8 30 fc ff ff       	call   f0100f7f <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f010134f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101354:	76 20                	jbe    f0101376 <page_init+0x44>
	return (physaddr_t)kva - KERNBASE;
f0101356:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
f010135c:	c1 ee 0c             	shr    $0xc,%esi
		if((i<npages_basemem && i != MPENTRY_PADDR / PGSIZE) || i>=next){
f010135f:	8b 3d 44 62 35 f0    	mov    0xf0356244,%edi
	for (i = 1; i < npages; i++) {
f0101365:	b8 00 00 00 00       	mov    $0x0,%eax
f010136a:	bb 00 00 00 00       	mov    $0x0,%ebx
f010136f:	ba 01 00 00 00       	mov    $0x1,%edx
f0101374:	eb 3c                	jmp    f01013b2 <page_init+0x80>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101376:	50                   	push   %eax
f0101377:	68 28 72 10 f0       	push   $0xf0107228
f010137c:	68 4e 01 00 00       	push   $0x14e
f0101381:	68 a1 84 10 f0       	push   $0xf01084a1
f0101386:	e8 b5 ec ff ff       	call   f0100040 <_panic>
f010138b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
			pages[i].pp_ref = 0;
f0101392:	89 c1                	mov    %eax,%ecx
f0101394:	03 0d 90 6e 35 f0    	add    0xf0356e90,%ecx
f010139a:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
			pages[i].pp_link = page_free_list;
f01013a0:	89 19                	mov    %ebx,(%ecx)
			page_free_list = &pages[i];
f01013a2:	03 05 90 6e 35 f0    	add    0xf0356e90,%eax
f01013a8:	89 c3                	mov    %eax,%ebx
f01013aa:	b8 01 00 00 00       	mov    $0x1,%eax
	for (i = 1; i < npages; i++) {
f01013af:	83 c2 01             	add    $0x1,%edx
f01013b2:	39 15 88 6e 35 f0    	cmp    %edx,0xf0356e88
f01013b8:	76 0f                	jbe    f01013c9 <page_init+0x97>
		if((i<npages_basemem && i != MPENTRY_PADDR / PGSIZE) || i>=next){
f01013ba:	83 fa 07             	cmp    $0x7,%edx
f01013bd:	74 04                	je     f01013c3 <page_init+0x91>
f01013bf:	39 d7                	cmp    %edx,%edi
f01013c1:	77 c8                	ja     f010138b <page_init+0x59>
f01013c3:	39 f2                	cmp    %esi,%edx
f01013c5:	72 e8                	jb     f01013af <page_init+0x7d>
f01013c7:	eb c2                	jmp    f010138b <page_init+0x59>
f01013c9:	84 c0                	test   %al,%al
f01013cb:	74 06                	je     f01013d3 <page_init+0xa1>
f01013cd:	89 1d 40 62 35 f0    	mov    %ebx,0xf0356240
}
f01013d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01013d6:	5b                   	pop    %ebx
f01013d7:	5e                   	pop    %esi
f01013d8:	5f                   	pop    %edi
f01013d9:	5d                   	pop    %ebp
f01013da:	c3                   	ret    

f01013db <page_alloc>:
{
f01013db:	55                   	push   %ebp
f01013dc:	89 e5                	mov    %esp,%ebp
f01013de:	53                   	push   %ebx
f01013df:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list)
f01013e2:	8b 1d 40 62 35 f0    	mov    0xf0356240,%ebx
f01013e8:	85 db                	test   %ebx,%ebx
f01013ea:	74 13                	je     f01013ff <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f01013ec:	8b 03                	mov    (%ebx),%eax
f01013ee:	a3 40 62 35 f0       	mov    %eax,0xf0356240
	ret->pp_link = NULL;
f01013f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO)
f01013f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01013fd:	75 07                	jne    f0101406 <page_alloc+0x2b>
}
f01013ff:	89 d8                	mov    %ebx,%eax
f0101401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101404:	c9                   	leave  
f0101405:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0101406:	89 d8                	mov    %ebx,%eax
f0101408:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f010140e:	c1 f8 03             	sar    $0x3,%eax
f0101411:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101414:	89 c2                	mov    %eax,%edx
f0101416:	c1 ea 0c             	shr    $0xc,%edx
f0101419:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f010141f:	73 1a                	jae    f010143b <page_alloc+0x60>
		memset(page2kva(ret),0,PGSIZE);
f0101421:	83 ec 04             	sub    $0x4,%esp
f0101424:	68 00 10 00 00       	push   $0x1000
f0101429:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f010142b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101430:	50                   	push   %eax
f0101431:	e8 53 51 00 00       	call   f0106589 <memset>
f0101436:	83 c4 10             	add    $0x10,%esp
f0101439:	eb c4                	jmp    f01013ff <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010143b:	50                   	push   %eax
f010143c:	68 04 72 10 f0       	push   $0xf0107204
f0101441:	6a 58                	push   $0x58
f0101443:	68 ad 84 10 f0       	push   $0xf01084ad
f0101448:	e8 f3 eb ff ff       	call   f0100040 <_panic>

f010144d <page_free>:
{
f010144d:	55                   	push   %ebp
f010144e:	89 e5                	mov    %esp,%ebp
f0101450:	83 ec 08             	sub    $0x8,%esp
f0101453:	8b 45 08             	mov    0x8(%ebp),%eax
	assert(pp);
f0101456:	85 c0                	test   %eax,%eax
f0101458:	74 1b                	je     f0101475 <page_free+0x28>
	if(pp->pp_ref)
f010145a:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010145f:	75 2d                	jne    f010148e <page_free+0x41>
	if(pp->pp_link)
f0101461:	83 38 00             	cmpl   $0x0,(%eax)
f0101464:	75 3f                	jne    f01014a5 <page_free+0x58>
	pp->pp_link = page_free_list;
f0101466:	8b 15 40 62 35 f0    	mov    0xf0356240,%edx
f010146c:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f010146e:	a3 40 62 35 f0       	mov    %eax,0xf0356240
}
f0101473:	c9                   	leave  
f0101474:	c3                   	ret    
	assert(pp);
f0101475:	68 99 86 10 f0       	push   $0xf0108699
f010147a:	68 c7 84 10 f0       	push   $0xf01084c7
f010147f:	68 81 01 00 00       	push   $0x181
f0101484:	68 a1 84 10 f0       	push   $0xf01084a1
f0101489:	e8 b2 eb ff ff       	call   f0100040 <_panic>
		panic("page_free: ref count is not zero\n");
f010148e:	83 ec 04             	sub    $0x4,%esp
f0101491:	68 90 7b 10 f0       	push   $0xf0107b90
f0101496:	68 83 01 00 00       	push   $0x183
f010149b:	68 a1 84 10 f0       	push   $0xf01084a1
f01014a0:	e8 9b eb ff ff       	call   f0100040 <_panic>
		panic("page_free: pp_link is not NULL\n");
f01014a5:	83 ec 04             	sub    $0x4,%esp
f01014a8:	68 b4 7b 10 f0       	push   $0xf0107bb4
f01014ad:	68 85 01 00 00       	push   $0x185
f01014b2:	68 a1 84 10 f0       	push   $0xf01084a1
f01014b7:	e8 84 eb ff ff       	call   f0100040 <_panic>

f01014bc <page_decref>:
{
f01014bc:	55                   	push   %ebp
f01014bd:	89 e5                	mov    %esp,%ebp
f01014bf:	83 ec 08             	sub    $0x8,%esp
f01014c2:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01014c5:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01014c9:	83 e8 01             	sub    $0x1,%eax
f01014cc:	66 89 42 04          	mov    %ax,0x4(%edx)
f01014d0:	66 85 c0             	test   %ax,%ax
f01014d3:	74 02                	je     f01014d7 <page_decref+0x1b>
}
f01014d5:	c9                   	leave  
f01014d6:	c3                   	ret    
		page_free(pp);
f01014d7:	83 ec 0c             	sub    $0xc,%esp
f01014da:	52                   	push   %edx
f01014db:	e8 6d ff ff ff       	call   f010144d <page_free>
f01014e0:	83 c4 10             	add    $0x10,%esp
}
f01014e3:	eb f0                	jmp    f01014d5 <page_decref+0x19>

f01014e5 <pgdir_walk>:
{
f01014e5:	55                   	push   %ebp
f01014e6:	89 e5                	mov    %esp,%ebp
f01014e8:	56                   	push   %esi
f01014e9:	53                   	push   %ebx
f01014ea:	8b 55 08             	mov    0x8(%ebp),%edx
f01014ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	assert(pgdir);
f01014f0:	85 d2                	test   %edx,%edx
f01014f2:	74 3d                	je     f0101531 <pgdir_walk+0x4c>
	uint32_t pt_idx = PTX(va);
f01014f4:	89 c3                	mov    %eax,%ebx
f01014f6:	c1 eb 0c             	shr    $0xc,%ebx
f01014f9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	uint32_t pd_idx = PDX(va);
f01014ff:	c1 e8 16             	shr    $0x16,%eax
	pde_t pde = pgdir[pd_idx];
f0101502:	8d 34 82             	lea    (%edx,%eax,4),%esi
f0101505:	8b 06                	mov    (%esi),%eax
	if(pde & PTE_P){
f0101507:	a8 01                	test   $0x1,%al
f0101509:	74 54                	je     f010155f <pgdir_walk+0x7a>
		if(pde & PTE_PS){
f010150b:	a8 80                	test   $0x80,%al
f010150d:	75 19                	jne    f0101528 <pgdir_walk+0x43>
		physaddr_t pte_addr = PTE_ADDR(pde);
f010150f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101514:	89 c2                	mov    %eax,%edx
f0101516:	c1 ea 0c             	shr    $0xc,%edx
f0101519:	39 15 88 6e 35 f0    	cmp    %edx,0xf0356e88
f010151f:	76 29                	jbe    f010154a <pgdir_walk+0x65>
		return pgtbl+pt_idx;
f0101521:	8d b4 98 00 00 00 f0 	lea    -0x10000000(%eax,%ebx,4),%esi
}
f0101528:	89 f0                	mov    %esi,%eax
f010152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010152d:	5b                   	pop    %ebx
f010152e:	5e                   	pop    %esi
f010152f:	5d                   	pop    %ebp
f0101530:	c3                   	ret    
	assert(pgdir);
f0101531:	68 74 85 10 f0       	push   $0xf0108574
f0101536:	68 c7 84 10 f0       	push   $0xf01084c7
f010153b:	68 b0 01 00 00       	push   $0x1b0
f0101540:	68 a1 84 10 f0       	push   $0xf01084a1
f0101545:	e8 f6 ea ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010154a:	50                   	push   %eax
f010154b:	68 04 72 10 f0       	push   $0xf0107204
f0101550:	68 bb 01 00 00       	push   $0x1bb
f0101555:	68 a1 84 10 f0       	push   $0xf01084a1
f010155a:	e8 e1 ea ff ff       	call   f0100040 <_panic>
	if(!create)
f010155f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101563:	74 54                	je     f01015b9 <pgdir_walk+0xd4>
	struct PageInfo* pt_info = page_alloc(ALLOC_ZERO);
f0101565:	83 ec 0c             	sub    $0xc,%esp
f0101568:	6a 01                	push   $0x1
f010156a:	e8 6c fe ff ff       	call   f01013db <page_alloc>
	if(!pt_info)
f010156f:	83 c4 10             	add    $0x10,%esp
f0101572:	85 c0                	test   %eax,%eax
f0101574:	74 4d                	je     f01015c3 <pgdir_walk+0xde>
	pt_info->pp_ref += 1;
f0101576:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010157b:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f0101581:	c1 f8 03             	sar    $0x3,%eax
f0101584:	c1 e0 0c             	shl    $0xc,%eax
	pgdir[pd_idx] = pde_addr | PTE_P | PTE_W | PTE_U;
f0101587:	89 c2                	mov    %eax,%edx
f0101589:	83 ca 07             	or     $0x7,%edx
f010158c:	89 16                	mov    %edx,(%esi)
	if (PGNUM(pa) >= npages)
f010158e:	89 c2                	mov    %eax,%edx
f0101590:	c1 ea 0c             	shr    $0xc,%edx
f0101593:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f0101599:	73 09                	jae    f01015a4 <pgdir_walk+0xbf>
	return pgtbl+pt_idx;
f010159b:	8d b4 98 00 00 00 f0 	lea    -0x10000000(%eax,%ebx,4),%esi
f01015a2:	eb 84                	jmp    f0101528 <pgdir_walk+0x43>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01015a4:	50                   	push   %eax
f01015a5:	68 04 72 10 f0       	push   $0xf0107204
f01015aa:	68 c8 01 00 00       	push   $0x1c8
f01015af:	68 a1 84 10 f0       	push   $0xf01084a1
f01015b4:	e8 87 ea ff ff       	call   f0100040 <_panic>
		return NULL;
f01015b9:	be 00 00 00 00       	mov    $0x0,%esi
f01015be:	e9 65 ff ff ff       	jmp    f0101528 <pgdir_walk+0x43>
		return NULL;
f01015c3:	89 c6                	mov    %eax,%esi
f01015c5:	e9 5e ff ff ff       	jmp    f0101528 <pgdir_walk+0x43>

f01015ca <boot_map_region>:
{
f01015ca:	55                   	push   %ebp
f01015cb:	89 e5                	mov    %esp,%ebp
f01015cd:	57                   	push   %edi
f01015ce:	56                   	push   %esi
f01015cf:	53                   	push   %ebx
f01015d0:	83 ec 1c             	sub    $0x1c,%esp
	assert(pgdir);
f01015d3:	85 c0                	test   %eax,%eax
f01015d5:	74 65                	je     f010163c <boot_map_region+0x72>
f01015d7:	89 c7                	mov    %eax,%edi
	va = ROUNDDOWN(va, PGSIZE);
f01015d9:	89 d6                	mov    %edx,%esi
f01015db:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	pa = ROUNDDOWN(pa, PGSIZE);
f01015e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01015e4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01015ea:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	uint32_t num = (ROUNDUP(size+va, PGSIZE) - va) / PGSIZE;
f01015ed:	8d 84 0e ff 0f 00 00 	lea    0xfff(%esi,%ecx,1),%eax
f01015f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01015f9:	29 f0                	sub    %esi,%eax
f01015fb:	01 d8                	add    %ebx,%eax
f01015fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		*pte = addr | PGOFF(perm | PTE_P);
f0101600:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101603:	83 c8 01             	or     $0x1,%eax
f0101606:	25 ff 0f 00 00       	and    $0xfff,%eax
f010160b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	for(int i=0;i<num;i++){
f010160e:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101611:	74 5b                	je     f010166e <boot_map_region+0xa4>
		pte_t *pte = pgdir_walk(pgdir, (void*)va+i*PGSIZE, 1);
f0101613:	83 ec 04             	sub    $0x4,%esp
f0101616:	6a 01                	push   $0x1
f0101618:	89 f0                	mov    %esi,%eax
f010161a:	2b 45 e0             	sub    -0x20(%ebp),%eax
f010161d:	01 d8                	add    %ebx,%eax
f010161f:	50                   	push   %eax
f0101620:	57                   	push   %edi
f0101621:	e8 bf fe ff ff       	call   f01014e5 <pgdir_walk>
		assert(pte);
f0101626:	83 c4 10             	add    $0x10,%esp
f0101629:	85 c0                	test   %eax,%eax
f010162b:	74 28                	je     f0101655 <boot_map_region+0x8b>
		*pte = addr | PGOFF(perm | PTE_P);
f010162d:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101630:	09 da                	or     %ebx,%edx
f0101632:	89 10                	mov    %edx,(%eax)
f0101634:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010163a:	eb d2                	jmp    f010160e <boot_map_region+0x44>
	assert(pgdir);
f010163c:	68 74 85 10 f0       	push   $0xf0108574
f0101641:	68 c7 84 10 f0       	push   $0xf01084c7
f0101646:	68 dc 01 00 00       	push   $0x1dc
f010164b:	68 a1 84 10 f0       	push   $0xf01084a1
f0101650:	e8 eb e9 ff ff       	call   f0100040 <_panic>
		assert(pte);
f0101655:	68 7a 85 10 f0       	push   $0xf010857a
f010165a:	68 c7 84 10 f0       	push   $0xf01084c7
f010165f:	68 e4 01 00 00       	push   $0x1e4
f0101664:	68 a1 84 10 f0       	push   $0xf01084a1
f0101669:	e8 d2 e9 ff ff       	call   f0100040 <_panic>
}
f010166e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101671:	5b                   	pop    %ebx
f0101672:	5e                   	pop    %esi
f0101673:	5f                   	pop    %edi
f0101674:	5d                   	pop    %ebp
f0101675:	c3                   	ret    

f0101676 <page_lookup>:
{
f0101676:	55                   	push   %ebp
f0101677:	89 e5                	mov    %esp,%ebp
f0101679:	53                   	push   %ebx
f010167a:	83 ec 04             	sub    $0x4,%esp
f010167d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101680:	8b 5d 10             	mov    0x10(%ebp),%ebx
	assert(pgdir);
f0101683:	85 c0                	test   %eax,%eax
f0101685:	74 3b                	je     f01016c2 <page_lookup+0x4c>
	pte_t* pte = pgdir_walk(pgdir, va, 0);
f0101687:	83 ec 04             	sub    $0x4,%esp
f010168a:	6a 00                	push   $0x0
f010168c:	ff 75 0c             	pushl  0xc(%ebp)
f010168f:	50                   	push   %eax
f0101690:	e8 50 fe ff ff       	call   f01014e5 <pgdir_walk>
	if(!pte || !(*pte & PTE_P))
f0101695:	83 c4 10             	add    $0x10,%esp
f0101698:	85 c0                	test   %eax,%eax
f010169a:	74 21                	je     f01016bd <page_lookup+0x47>
f010169c:	f6 00 01             	testb  $0x1,(%eax)
f010169f:	74 4e                	je     f01016ef <page_lookup+0x79>
	if(pte_store)
f01016a1:	85 db                	test   %ebx,%ebx
f01016a3:	74 02                	je     f01016a7 <page_lookup+0x31>
		*pte_store = pte;
f01016a5:	89 03                	mov    %eax,(%ebx)
	physaddr_t addr = PTE_ADDR(*pte) | PGOFF(va);
f01016a7:	8b 00                	mov    (%eax),%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01016a9:	c1 e8 0c             	shr    $0xc,%eax
f01016ac:	3b 05 88 6e 35 f0    	cmp    0xf0356e88,%eax
f01016b2:	73 27                	jae    f01016db <page_lookup+0x65>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f01016b4:	8b 15 90 6e 35 f0    	mov    0xf0356e90,%edx
f01016ba:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f01016bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01016c0:	c9                   	leave  
f01016c1:	c3                   	ret    
	assert(pgdir);
f01016c2:	68 74 85 10 f0       	push   $0xf0108574
f01016c7:	68 c7 84 10 f0       	push   $0xf01084c7
f01016cc:	68 49 02 00 00       	push   $0x249
f01016d1:	68 a1 84 10 f0       	push   $0xf01084a1
f01016d6:	e8 65 e9 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f01016db:	83 ec 04             	sub    $0x4,%esp
f01016de:	68 d4 7b 10 f0       	push   $0xf0107bd4
f01016e3:	6a 51                	push   $0x51
f01016e5:	68 ad 84 10 f0       	push   $0xf01084ad
f01016ea:	e8 51 e9 ff ff       	call   f0100040 <_panic>
		return NULL;
f01016ef:	b8 00 00 00 00       	mov    $0x0,%eax
f01016f4:	eb c7                	jmp    f01016bd <page_lookup+0x47>

f01016f6 <tlb_invalidate>:
{
f01016f6:	55                   	push   %ebp
f01016f7:	89 e5                	mov    %esp,%ebp
f01016f9:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f01016fc:	e8 89 54 00 00       	call   f0106b8a <cpunum>
f0101701:	6b c0 74             	imul   $0x74,%eax,%eax
f0101704:	83 b8 28 70 35 f0 00 	cmpl   $0x0,-0xfca8fd8(%eax)
f010170b:	74 16                	je     f0101723 <tlb_invalidate+0x2d>
f010170d:	e8 78 54 00 00       	call   f0106b8a <cpunum>
f0101712:	6b c0 74             	imul   $0x74,%eax,%eax
f0101715:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010171b:	8b 55 08             	mov    0x8(%ebp),%edx
f010171e:	39 50 64             	cmp    %edx,0x64(%eax)
f0101721:	75 06                	jne    f0101729 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101723:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101726:	0f 01 38             	invlpg (%eax)
}
f0101729:	c9                   	leave  
f010172a:	c3                   	ret    

f010172b <page_remove>:
{
f010172b:	55                   	push   %ebp
f010172c:	89 e5                	mov    %esp,%ebp
f010172e:	56                   	push   %esi
f010172f:	53                   	push   %ebx
f0101730:	83 ec 10             	sub    $0x10,%esp
f0101733:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101736:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (!pgdir)
f0101739:	85 db                	test   %ebx,%ebx
f010173b:	74 38                	je     f0101775 <page_remove+0x4a>
	struct PageInfo *page = page_lookup(pgdir, va, &pte);
f010173d:	83 ec 04             	sub    $0x4,%esp
f0101740:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101743:	50                   	push   %eax
f0101744:	56                   	push   %esi
f0101745:	53                   	push   %ebx
f0101746:	e8 2b ff ff ff       	call   f0101676 <page_lookup>
	if (!page)
f010174b:	83 c4 10             	add    $0x10,%esp
f010174e:	85 c0                	test   %eax,%eax
f0101750:	74 1c                	je     f010176e <page_remove+0x43>
	page_decref(page);
f0101752:	83 ec 0c             	sub    $0xc,%esp
f0101755:	50                   	push   %eax
f0101756:	e8 61 fd ff ff       	call   f01014bc <page_decref>
	*pte &= ~PTE_P;
f010175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010175e:	83 20 fe             	andl   $0xfffffffe,(%eax)
	tlb_invalidate(pgdir, va);
f0101761:	83 c4 08             	add    $0x8,%esp
f0101764:	56                   	push   %esi
f0101765:	53                   	push   %ebx
f0101766:	e8 8b ff ff ff       	call   f01016f6 <tlb_invalidate>
f010176b:	83 c4 10             	add    $0x10,%esp
}
f010176e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101771:	5b                   	pop    %ebx
f0101772:	5e                   	pop    %esi
f0101773:	5d                   	pop    %ebp
f0101774:	c3                   	ret    
		panic("page_remove: null pointer 'pgdir'\n");
f0101775:	83 ec 04             	sub    $0x4,%esp
f0101778:	68 f4 7b 10 f0       	push   $0xf0107bf4
f010177d:	68 68 02 00 00       	push   $0x268
f0101782:	68 a1 84 10 f0       	push   $0xf01084a1
f0101787:	e8 b4 e8 ff ff       	call   f0100040 <_panic>

f010178c <page_insert>:
{
f010178c:	55                   	push   %ebp
f010178d:	89 e5                	mov    %esp,%ebp
f010178f:	57                   	push   %edi
f0101790:	56                   	push   %esi
f0101791:	53                   	push   %ebx
f0101792:	83 ec 1c             	sub    $0x1c,%esp
f0101795:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (!pgdir)
f0101798:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f010179c:	74 5a                	je     f01017f8 <page_insert+0x6c>
	if (!pp)
f010179e:	85 db                	test   %ebx,%ebx
f01017a0:	74 6d                	je     f010180f <page_insert+0x83>
	va = ROUNDDOWN(va, PGSIZE);
f01017a2:	8b 75 10             	mov    0x10(%ebp),%esi
f01017a5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	perm = PGOFF(perm);
f01017ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01017ae:	25 ff 0f 00 00       	and    $0xfff,%eax
f01017b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	pte_t *pte = pgdir_walk(pgdir, va, 1);
f01017b6:	83 ec 04             	sub    $0x4,%esp
f01017b9:	6a 01                	push   $0x1
f01017bb:	56                   	push   %esi
f01017bc:	ff 75 08             	pushl  0x8(%ebp)
f01017bf:	e8 21 fd ff ff       	call   f01014e5 <pgdir_walk>
f01017c4:	89 c7                	mov    %eax,%edi
	if (!pte)
f01017c6:	83 c4 10             	add    $0x10,%esp
f01017c9:	85 c0                	test   %eax,%eax
f01017cb:	74 6a                	je     f0101837 <page_insert+0xab>
	pp->pp_ref++;
f01017cd:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	if (*pte & PTE_P)
f01017d2:	f6 00 01             	testb  $0x1,(%eax)
f01017d5:	75 4f                	jne    f0101826 <page_insert+0x9a>
	return (pp - pages) << PGSHIFT;
f01017d7:	2b 1d 90 6e 35 f0    	sub    0xf0356e90,%ebx
f01017dd:	c1 fb 03             	sar    $0x3,%ebx
f01017e0:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = page2pa(pp) | perm | PTE_P;
f01017e3:	0b 5d e4             	or     -0x1c(%ebp),%ebx
f01017e6:	83 cb 01             	or     $0x1,%ebx
f01017e9:	89 1f                	mov    %ebx,(%edi)
	return 0;
f01017eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01017f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01017f3:	5b                   	pop    %ebx
f01017f4:	5e                   	pop    %esi
f01017f5:	5f                   	pop    %edi
f01017f6:	5d                   	pop    %ebp
f01017f7:	c3                   	ret    
		panic("page_insert: null pointer 'pgdir'\n");
f01017f8:	83 ec 04             	sub    $0x4,%esp
f01017fb:	68 18 7c 10 f0       	push   $0xf0107c18
f0101800:	68 24 02 00 00       	push   $0x224
f0101805:	68 a1 84 10 f0       	push   $0xf01084a1
f010180a:	e8 31 e8 ff ff       	call   f0100040 <_panic>
		panic("page_insert: null pointer 'pp'\n");
f010180f:	83 ec 04             	sub    $0x4,%esp
f0101812:	68 3c 7c 10 f0       	push   $0xf0107c3c
f0101817:	68 26 02 00 00       	push   $0x226
f010181c:	68 a1 84 10 f0       	push   $0xf01084a1
f0101821:	e8 1a e8 ff ff       	call   f0100040 <_panic>
		page_remove(pgdir, va);
f0101826:	83 ec 08             	sub    $0x8,%esp
f0101829:	56                   	push   %esi
f010182a:	ff 75 08             	pushl  0x8(%ebp)
f010182d:	e8 f9 fe ff ff       	call   f010172b <page_remove>
f0101832:	83 c4 10             	add    $0x10,%esp
f0101835:	eb a0                	jmp    f01017d7 <page_insert+0x4b>
		return -E_NO_MEM;
f0101837:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010183c:	eb b2                	jmp    f01017f0 <page_insert+0x64>

f010183e <mmio_map_region>:
{
f010183e:	55                   	push   %ebp
f010183f:	89 e5                	mov    %esp,%ebp
f0101841:	57                   	push   %edi
f0101842:	56                   	push   %esi
f0101843:	53                   	push   %ebx
f0101844:	83 ec 0c             	sub    $0xc,%esp
	pa = ROUNDDOWN(pa, PGSIZE);
f0101847:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010184a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	size = ROUNDUP(pa+size, PGSIZE) - pa;
f0101850:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101853:	8d bc 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%edi
f010185a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
f0101860:	89 fe                	mov    %edi,%esi
f0101862:	29 de                	sub    %ebx,%esi
	if(base + size >= MMIOLIM){
f0101864:	8b 15 00 53 12 f0    	mov    0xf0125300,%edx
f010186a:	8d 04 32             	lea    (%edx,%esi,1),%eax
f010186d:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101872:	77 2b                	ja     f010189f <mmio_map_region+0x61>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f0101874:	83 ec 08             	sub    $0x8,%esp
f0101877:	6a 1a                	push   $0x1a
f0101879:	53                   	push   %ebx
f010187a:	89 f1                	mov    %esi,%ecx
f010187c:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f0101881:	e8 44 fd ff ff       	call   f01015ca <boot_map_region>
	base += size;
f0101886:	89 f0                	mov    %esi,%eax
f0101888:	03 05 00 53 12 f0    	add    0xf0125300,%eax
f010188e:	a3 00 53 12 f0       	mov    %eax,0xf0125300
	return (void*)(base - size);
f0101893:	29 fb                	sub    %edi,%ebx
f0101895:	01 d8                	add    %ebx,%eax
}
f0101897:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010189a:	5b                   	pop    %ebx
f010189b:	5e                   	pop    %esi
f010189c:	5f                   	pop    %edi
f010189d:	5d                   	pop    %ebp
f010189e:	c3                   	ret    
		panic("mmio_map_region: overflow!");
f010189f:	83 ec 04             	sub    $0x4,%esp
f01018a2:	68 7e 85 10 f0       	push   $0xf010857e
f01018a7:	68 a4 02 00 00       	push   $0x2a4
f01018ac:	68 a1 84 10 f0       	push   $0xf01084a1
f01018b1:	e8 8a e7 ff ff       	call   f0100040 <_panic>

f01018b6 <mem_init>:
{
f01018b6:	55                   	push   %ebp
f01018b7:	89 e5                	mov    %esp,%ebp
f01018b9:	57                   	push   %edi
f01018ba:	56                   	push   %esi
f01018bb:	53                   	push   %ebx
f01018bc:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01018bf:	b8 15 00 00 00       	mov    $0x15,%eax
f01018c4:	e8 ee f6 ff ff       	call   f0100fb7 <nvram_read>
f01018c9:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f01018cb:	b8 17 00 00 00       	mov    $0x17,%eax
f01018d0:	e8 e2 f6 ff ff       	call   f0100fb7 <nvram_read>
f01018d5:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01018d7:	b8 34 00 00 00       	mov    $0x34,%eax
f01018dc:	e8 d6 f6 ff ff       	call   f0100fb7 <nvram_read>
	if (ext16mem)
f01018e1:	c1 e0 06             	shl    $0x6,%eax
f01018e4:	0f 84 ea 00 00 00    	je     f01019d4 <mem_init+0x11e>
		totalmem = 16 * 1024 + ext16mem;
f01018ea:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f01018ef:	89 c2                	mov    %eax,%edx
f01018f1:	c1 ea 02             	shr    $0x2,%edx
f01018f4:	89 15 88 6e 35 f0    	mov    %edx,0xf0356e88
	npages_basemem = basemem / (PGSIZE / 1024);
f01018fa:	89 da                	mov    %ebx,%edx
f01018fc:	c1 ea 02             	shr    $0x2,%edx
f01018ff:	89 15 44 62 35 f0    	mov    %edx,0xf0356244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101905:	89 c2                	mov    %eax,%edx
f0101907:	29 da                	sub    %ebx,%edx
f0101909:	52                   	push   %edx
f010190a:	53                   	push   %ebx
f010190b:	50                   	push   %eax
f010190c:	68 5c 7c 10 f0       	push   $0xf0107c5c
f0101911:	e8 a8 25 00 00       	call   f0103ebe <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101916:	b8 00 10 00 00       	mov    $0x1000,%eax
f010191b:	e8 5f f6 ff ff       	call   f0100f7f <boot_alloc>
f0101920:	a3 8c 6e 35 f0       	mov    %eax,0xf0356e8c
	memset(kern_pgdir, 0, PGSIZE);
f0101925:	83 c4 0c             	add    $0xc,%esp
f0101928:	68 00 10 00 00       	push   $0x1000
f010192d:	6a 00                	push   $0x0
f010192f:	50                   	push   %eax
f0101930:	e8 54 4c 00 00       	call   f0106589 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101935:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f010193a:	83 c4 10             	add    $0x10,%esp
f010193d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101942:	0f 86 9c 00 00 00    	jbe    f01019e4 <mem_init+0x12e>
	return (physaddr_t)kva - KERNBASE;
f0101948:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010194e:	83 ca 05             	or     $0x5,%edx
f0101951:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * PISIZE);
f0101957:	a1 88 6e 35 f0       	mov    0xf0356e88,%eax
f010195c:	c1 e0 03             	shl    $0x3,%eax
f010195f:	e8 1b f6 ff ff       	call   f0100f7f <boot_alloc>
f0101964:	a3 90 6e 35 f0       	mov    %eax,0xf0356e90
	memset(pages, 0, npages * PISIZE);
f0101969:	83 ec 04             	sub    $0x4,%esp
f010196c:	8b 0d 88 6e 35 f0    	mov    0xf0356e88,%ecx
f0101972:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f0101979:	52                   	push   %edx
f010197a:	6a 00                	push   $0x0
f010197c:	50                   	push   %eax
f010197d:	e8 07 4c 00 00       	call   f0106589 <memset>
	envs = (struct Env*)boot_alloc(ENVSIZE);
f0101982:	b8 00 40 02 00       	mov    $0x24000,%eax
f0101987:	e8 f3 f5 ff ff       	call   f0100f7f <boot_alloc>
f010198c:	a3 48 62 35 f0       	mov    %eax,0xf0356248
	memset(envs, 0, ENVSIZE);
f0101991:	83 c4 0c             	add    $0xc,%esp
f0101994:	68 00 40 02 00       	push   $0x24000
f0101999:	6a 00                	push   $0x0
f010199b:	50                   	push   %eax
f010199c:	e8 e8 4b 00 00       	call   f0106589 <memset>
	page_init();
f01019a1:	e8 8c f9 ff ff       	call   f0101332 <page_init>
	check_page_free_list(1);
f01019a6:	b8 01 00 00 00       	mov    $0x1,%eax
f01019ab:	e8 94 f6 ff ff       	call   f0101044 <check_page_free_list>
	if (!pages)
f01019b0:	83 c4 10             	add    $0x10,%esp
f01019b3:	83 3d 90 6e 35 f0 00 	cmpl   $0x0,0xf0356e90
f01019ba:	74 3d                	je     f01019f9 <mem_init+0x143>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01019bc:	a1 40 62 35 f0       	mov    0xf0356240,%eax
f01019c1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f01019c8:	85 c0                	test   %eax,%eax
f01019ca:	74 44                	je     f0101a10 <mem_init+0x15a>
		++nfree;
f01019cc:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01019d0:	8b 00                	mov    (%eax),%eax
f01019d2:	eb f4                	jmp    f01019c8 <mem_init+0x112>
		totalmem = 1 * 1024 + extmem;
f01019d4:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01019da:	85 f6                	test   %esi,%esi
f01019dc:	0f 44 c3             	cmove  %ebx,%eax
f01019df:	e9 0b ff ff ff       	jmp    f01018ef <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01019e4:	50                   	push   %eax
f01019e5:	68 28 72 10 f0       	push   $0xf0107228
f01019ea:	68 99 00 00 00       	push   $0x99
f01019ef:	68 a1 84 10 f0       	push   $0xf01084a1
f01019f4:	e8 47 e6 ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f01019f9:	83 ec 04             	sub    $0x4,%esp
f01019fc:	68 99 85 10 f0       	push   $0xf0108599
f0101a01:	68 46 03 00 00       	push   $0x346
f0101a06:	68 a1 84 10 f0       	push   $0xf01084a1
f0101a0b:	e8 30 e6 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101a10:	83 ec 0c             	sub    $0xc,%esp
f0101a13:	6a 00                	push   $0x0
f0101a15:	e8 c1 f9 ff ff       	call   f01013db <page_alloc>
f0101a1a:	89 c3                	mov    %eax,%ebx
f0101a1c:	83 c4 10             	add    $0x10,%esp
f0101a1f:	85 c0                	test   %eax,%eax
f0101a21:	0f 84 00 02 00 00    	je     f0101c27 <mem_init+0x371>
	assert((pp1 = page_alloc(0)));
f0101a27:	83 ec 0c             	sub    $0xc,%esp
f0101a2a:	6a 00                	push   $0x0
f0101a2c:	e8 aa f9 ff ff       	call   f01013db <page_alloc>
f0101a31:	89 c6                	mov    %eax,%esi
f0101a33:	83 c4 10             	add    $0x10,%esp
f0101a36:	85 c0                	test   %eax,%eax
f0101a38:	0f 84 02 02 00 00    	je     f0101c40 <mem_init+0x38a>
	assert((pp2 = page_alloc(0)));
f0101a3e:	83 ec 0c             	sub    $0xc,%esp
f0101a41:	6a 00                	push   $0x0
f0101a43:	e8 93 f9 ff ff       	call   f01013db <page_alloc>
f0101a48:	89 c7                	mov    %eax,%edi
f0101a4a:	83 c4 10             	add    $0x10,%esp
f0101a4d:	85 c0                	test   %eax,%eax
f0101a4f:	0f 84 04 02 00 00    	je     f0101c59 <mem_init+0x3a3>
	assert(pp1 && pp1 != pp0);
f0101a55:	39 f3                	cmp    %esi,%ebx
f0101a57:	0f 84 15 02 00 00    	je     f0101c72 <mem_init+0x3bc>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a5d:	39 c6                	cmp    %eax,%esi
f0101a5f:	0f 84 26 02 00 00    	je     f0101c8b <mem_init+0x3d5>
f0101a65:	39 c3                	cmp    %eax,%ebx
f0101a67:	0f 84 1e 02 00 00    	je     f0101c8b <mem_init+0x3d5>
	return (pp - pages) << PGSHIFT;
f0101a6d:	8b 0d 90 6e 35 f0    	mov    0xf0356e90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101a73:	8b 15 88 6e 35 f0    	mov    0xf0356e88,%edx
f0101a79:	c1 e2 0c             	shl    $0xc,%edx
f0101a7c:	89 d8                	mov    %ebx,%eax
f0101a7e:	29 c8                	sub    %ecx,%eax
f0101a80:	c1 f8 03             	sar    $0x3,%eax
f0101a83:	c1 e0 0c             	shl    $0xc,%eax
f0101a86:	39 d0                	cmp    %edx,%eax
f0101a88:	0f 83 16 02 00 00    	jae    f0101ca4 <mem_init+0x3ee>
f0101a8e:	89 f0                	mov    %esi,%eax
f0101a90:	29 c8                	sub    %ecx,%eax
f0101a92:	c1 f8 03             	sar    $0x3,%eax
f0101a95:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101a98:	39 c2                	cmp    %eax,%edx
f0101a9a:	0f 86 1d 02 00 00    	jbe    f0101cbd <mem_init+0x407>
f0101aa0:	89 f8                	mov    %edi,%eax
f0101aa2:	29 c8                	sub    %ecx,%eax
f0101aa4:	c1 f8 03             	sar    $0x3,%eax
f0101aa7:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101aaa:	39 c2                	cmp    %eax,%edx
f0101aac:	0f 86 24 02 00 00    	jbe    f0101cd6 <mem_init+0x420>
	fl = page_free_list;
f0101ab2:	a1 40 62 35 f0       	mov    0xf0356240,%eax
f0101ab7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101aba:	c7 05 40 62 35 f0 00 	movl   $0x0,0xf0356240
f0101ac1:	00 00 00 
	assert(!page_alloc(0));
f0101ac4:	83 ec 0c             	sub    $0xc,%esp
f0101ac7:	6a 00                	push   $0x0
f0101ac9:	e8 0d f9 ff ff       	call   f01013db <page_alloc>
f0101ace:	83 c4 10             	add    $0x10,%esp
f0101ad1:	85 c0                	test   %eax,%eax
f0101ad3:	0f 85 16 02 00 00    	jne    f0101cef <mem_init+0x439>
	page_free(pp0);
f0101ad9:	83 ec 0c             	sub    $0xc,%esp
f0101adc:	53                   	push   %ebx
f0101add:	e8 6b f9 ff ff       	call   f010144d <page_free>
	page_free(pp1);
f0101ae2:	89 34 24             	mov    %esi,(%esp)
f0101ae5:	e8 63 f9 ff ff       	call   f010144d <page_free>
	page_free(pp2);
f0101aea:	89 3c 24             	mov    %edi,(%esp)
f0101aed:	e8 5b f9 ff ff       	call   f010144d <page_free>
	assert((pp0 = page_alloc(0)));
f0101af2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101af9:	e8 dd f8 ff ff       	call   f01013db <page_alloc>
f0101afe:	89 c3                	mov    %eax,%ebx
f0101b00:	83 c4 10             	add    $0x10,%esp
f0101b03:	85 c0                	test   %eax,%eax
f0101b05:	0f 84 fd 01 00 00    	je     f0101d08 <mem_init+0x452>
	assert((pp1 = page_alloc(0)));
f0101b0b:	83 ec 0c             	sub    $0xc,%esp
f0101b0e:	6a 00                	push   $0x0
f0101b10:	e8 c6 f8 ff ff       	call   f01013db <page_alloc>
f0101b15:	89 c6                	mov    %eax,%esi
f0101b17:	83 c4 10             	add    $0x10,%esp
f0101b1a:	85 c0                	test   %eax,%eax
f0101b1c:	0f 84 ff 01 00 00    	je     f0101d21 <mem_init+0x46b>
	assert((pp2 = page_alloc(0)));
f0101b22:	83 ec 0c             	sub    $0xc,%esp
f0101b25:	6a 00                	push   $0x0
f0101b27:	e8 af f8 ff ff       	call   f01013db <page_alloc>
f0101b2c:	89 c7                	mov    %eax,%edi
f0101b2e:	83 c4 10             	add    $0x10,%esp
f0101b31:	85 c0                	test   %eax,%eax
f0101b33:	0f 84 01 02 00 00    	je     f0101d3a <mem_init+0x484>
	assert(pp1 && pp1 != pp0);
f0101b39:	39 f3                	cmp    %esi,%ebx
f0101b3b:	0f 84 12 02 00 00    	je     f0101d53 <mem_init+0x49d>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b41:	39 c3                	cmp    %eax,%ebx
f0101b43:	0f 84 23 02 00 00    	je     f0101d6c <mem_init+0x4b6>
f0101b49:	39 c6                	cmp    %eax,%esi
f0101b4b:	0f 84 1b 02 00 00    	je     f0101d6c <mem_init+0x4b6>
	assert(!page_alloc(0));
f0101b51:	83 ec 0c             	sub    $0xc,%esp
f0101b54:	6a 00                	push   $0x0
f0101b56:	e8 80 f8 ff ff       	call   f01013db <page_alloc>
f0101b5b:	83 c4 10             	add    $0x10,%esp
f0101b5e:	85 c0                	test   %eax,%eax
f0101b60:	0f 85 1f 02 00 00    	jne    f0101d85 <mem_init+0x4cf>
f0101b66:	89 d8                	mov    %ebx,%eax
f0101b68:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f0101b6e:	c1 f8 03             	sar    $0x3,%eax
f0101b71:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101b74:	89 c2                	mov    %eax,%edx
f0101b76:	c1 ea 0c             	shr    $0xc,%edx
f0101b79:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f0101b7f:	0f 83 19 02 00 00    	jae    f0101d9e <mem_init+0x4e8>
	memset(page2kva(pp0), 1, PGSIZE);
f0101b85:	83 ec 04             	sub    $0x4,%esp
f0101b88:	68 00 10 00 00       	push   $0x1000
f0101b8d:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101b8f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101b94:	50                   	push   %eax
f0101b95:	e8 ef 49 00 00       	call   f0106589 <memset>
	page_free(pp0);
f0101b9a:	89 1c 24             	mov    %ebx,(%esp)
f0101b9d:	e8 ab f8 ff ff       	call   f010144d <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101ba2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101ba9:	e8 2d f8 ff ff       	call   f01013db <page_alloc>
f0101bae:	83 c4 10             	add    $0x10,%esp
f0101bb1:	85 c0                	test   %eax,%eax
f0101bb3:	0f 84 f7 01 00 00    	je     f0101db0 <mem_init+0x4fa>
	assert(pp && pp0 == pp);
f0101bb9:	39 c3                	cmp    %eax,%ebx
f0101bbb:	0f 85 08 02 00 00    	jne    f0101dc9 <mem_init+0x513>
	return (pp - pages) << PGSHIFT;
f0101bc1:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f0101bc7:	c1 f8 03             	sar    $0x3,%eax
f0101bca:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101bcd:	89 c2                	mov    %eax,%edx
f0101bcf:	c1 ea 0c             	shr    $0xc,%edx
f0101bd2:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f0101bd8:	0f 83 04 02 00 00    	jae    f0101de2 <mem_init+0x52c>
	return (void *)(pa + KERNBASE);
f0101bde:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0101be4:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f0101be9:	80 3a 00             	cmpb   $0x0,(%edx)
f0101bec:	0f 85 02 02 00 00    	jne    f0101df4 <mem_init+0x53e>
f0101bf2:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0101bf5:	39 c2                	cmp    %eax,%edx
f0101bf7:	75 f0                	jne    f0101be9 <mem_init+0x333>
	page_free_list = fl;
f0101bf9:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101bfc:	a3 40 62 35 f0       	mov    %eax,0xf0356240
	page_free(pp0);
f0101c01:	83 ec 0c             	sub    $0xc,%esp
f0101c04:	53                   	push   %ebx
f0101c05:	e8 43 f8 ff ff       	call   f010144d <page_free>
	page_free(pp1);
f0101c0a:	89 34 24             	mov    %esi,(%esp)
f0101c0d:	e8 3b f8 ff ff       	call   f010144d <page_free>
	page_free(pp2);
f0101c12:	89 3c 24             	mov    %edi,(%esp)
f0101c15:	e8 33 f8 ff ff       	call   f010144d <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101c1a:	a1 40 62 35 f0       	mov    0xf0356240,%eax
f0101c1f:	83 c4 10             	add    $0x10,%esp
f0101c22:	e9 ec 01 00 00       	jmp    f0101e13 <mem_init+0x55d>
	assert((pp0 = page_alloc(0)));
f0101c27:	68 b4 85 10 f0       	push   $0xf01085b4
f0101c2c:	68 c7 84 10 f0       	push   $0xf01084c7
f0101c31:	68 4e 03 00 00       	push   $0x34e
f0101c36:	68 a1 84 10 f0       	push   $0xf01084a1
f0101c3b:	e8 00 e4 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101c40:	68 ca 85 10 f0       	push   $0xf01085ca
f0101c45:	68 c7 84 10 f0       	push   $0xf01084c7
f0101c4a:	68 4f 03 00 00       	push   $0x34f
f0101c4f:	68 a1 84 10 f0       	push   $0xf01084a1
f0101c54:	e8 e7 e3 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101c59:	68 e0 85 10 f0       	push   $0xf01085e0
f0101c5e:	68 c7 84 10 f0       	push   $0xf01084c7
f0101c63:	68 50 03 00 00       	push   $0x350
f0101c68:	68 a1 84 10 f0       	push   $0xf01084a1
f0101c6d:	e8 ce e3 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101c72:	68 f6 85 10 f0       	push   $0xf01085f6
f0101c77:	68 c7 84 10 f0       	push   $0xf01084c7
f0101c7c:	68 53 03 00 00       	push   $0x353
f0101c81:	68 a1 84 10 f0       	push   $0xf01084a1
f0101c86:	e8 b5 e3 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c8b:	68 98 7c 10 f0       	push   $0xf0107c98
f0101c90:	68 c7 84 10 f0       	push   $0xf01084c7
f0101c95:	68 54 03 00 00       	push   $0x354
f0101c9a:	68 a1 84 10 f0       	push   $0xf01084a1
f0101c9f:	e8 9c e3 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101ca4:	68 08 86 10 f0       	push   $0xf0108608
f0101ca9:	68 c7 84 10 f0       	push   $0xf01084c7
f0101cae:	68 55 03 00 00       	push   $0x355
f0101cb3:	68 a1 84 10 f0       	push   $0xf01084a1
f0101cb8:	e8 83 e3 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101cbd:	68 25 86 10 f0       	push   $0xf0108625
f0101cc2:	68 c7 84 10 f0       	push   $0xf01084c7
f0101cc7:	68 56 03 00 00       	push   $0x356
f0101ccc:	68 a1 84 10 f0       	push   $0xf01084a1
f0101cd1:	e8 6a e3 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101cd6:	68 42 86 10 f0       	push   $0xf0108642
f0101cdb:	68 c7 84 10 f0       	push   $0xf01084c7
f0101ce0:	68 57 03 00 00       	push   $0x357
f0101ce5:	68 a1 84 10 f0       	push   $0xf01084a1
f0101cea:	e8 51 e3 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101cef:	68 5f 86 10 f0       	push   $0xf010865f
f0101cf4:	68 c7 84 10 f0       	push   $0xf01084c7
f0101cf9:	68 5e 03 00 00       	push   $0x35e
f0101cfe:	68 a1 84 10 f0       	push   $0xf01084a1
f0101d03:	e8 38 e3 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101d08:	68 b4 85 10 f0       	push   $0xf01085b4
f0101d0d:	68 c7 84 10 f0       	push   $0xf01084c7
f0101d12:	68 65 03 00 00       	push   $0x365
f0101d17:	68 a1 84 10 f0       	push   $0xf01084a1
f0101d1c:	e8 1f e3 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101d21:	68 ca 85 10 f0       	push   $0xf01085ca
f0101d26:	68 c7 84 10 f0       	push   $0xf01084c7
f0101d2b:	68 66 03 00 00       	push   $0x366
f0101d30:	68 a1 84 10 f0       	push   $0xf01084a1
f0101d35:	e8 06 e3 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101d3a:	68 e0 85 10 f0       	push   $0xf01085e0
f0101d3f:	68 c7 84 10 f0       	push   $0xf01084c7
f0101d44:	68 67 03 00 00       	push   $0x367
f0101d49:	68 a1 84 10 f0       	push   $0xf01084a1
f0101d4e:	e8 ed e2 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101d53:	68 f6 85 10 f0       	push   $0xf01085f6
f0101d58:	68 c7 84 10 f0       	push   $0xf01084c7
f0101d5d:	68 69 03 00 00       	push   $0x369
f0101d62:	68 a1 84 10 f0       	push   $0xf01084a1
f0101d67:	e8 d4 e2 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d6c:	68 98 7c 10 f0       	push   $0xf0107c98
f0101d71:	68 c7 84 10 f0       	push   $0xf01084c7
f0101d76:	68 6a 03 00 00       	push   $0x36a
f0101d7b:	68 a1 84 10 f0       	push   $0xf01084a1
f0101d80:	e8 bb e2 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101d85:	68 5f 86 10 f0       	push   $0xf010865f
f0101d8a:	68 c7 84 10 f0       	push   $0xf01084c7
f0101d8f:	68 6b 03 00 00       	push   $0x36b
f0101d94:	68 a1 84 10 f0       	push   $0xf01084a1
f0101d99:	e8 a2 e2 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101d9e:	50                   	push   %eax
f0101d9f:	68 04 72 10 f0       	push   $0xf0107204
f0101da4:	6a 58                	push   $0x58
f0101da6:	68 ad 84 10 f0       	push   $0xf01084ad
f0101dab:	e8 90 e2 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101db0:	68 6e 86 10 f0       	push   $0xf010866e
f0101db5:	68 c7 84 10 f0       	push   $0xf01084c7
f0101dba:	68 70 03 00 00       	push   $0x370
f0101dbf:	68 a1 84 10 f0       	push   $0xf01084a1
f0101dc4:	e8 77 e2 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101dc9:	68 8c 86 10 f0       	push   $0xf010868c
f0101dce:	68 c7 84 10 f0       	push   $0xf01084c7
f0101dd3:	68 71 03 00 00       	push   $0x371
f0101dd8:	68 a1 84 10 f0       	push   $0xf01084a1
f0101ddd:	e8 5e e2 ff ff       	call   f0100040 <_panic>
f0101de2:	50                   	push   %eax
f0101de3:	68 04 72 10 f0       	push   $0xf0107204
f0101de8:	6a 58                	push   $0x58
f0101dea:	68 ad 84 10 f0       	push   $0xf01084ad
f0101def:	e8 4c e2 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f0101df4:	68 9c 86 10 f0       	push   $0xf010869c
f0101df9:	68 c7 84 10 f0       	push   $0xf01084c7
f0101dfe:	68 74 03 00 00       	push   $0x374
f0101e03:	68 a1 84 10 f0       	push   $0xf01084a1
f0101e08:	e8 33 e2 ff ff       	call   f0100040 <_panic>
		--nfree;
f0101e0d:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101e11:	8b 00                	mov    (%eax),%eax
f0101e13:	85 c0                	test   %eax,%eax
f0101e15:	75 f6                	jne    f0101e0d <mem_init+0x557>
	assert(nfree == 0);
f0101e17:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101e1b:	0f 85 65 09 00 00    	jne    f0102786 <mem_init+0xed0>
	cprintf("check_page_alloc() succeeded!\n");
f0101e21:	83 ec 0c             	sub    $0xc,%esp
f0101e24:	68 b8 7c 10 f0       	push   $0xf0107cb8
f0101e29:	e8 90 20 00 00       	call   f0103ebe <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101e2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e35:	e8 a1 f5 ff ff       	call   f01013db <page_alloc>
f0101e3a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101e3d:	83 c4 10             	add    $0x10,%esp
f0101e40:	85 c0                	test   %eax,%eax
f0101e42:	0f 84 57 09 00 00    	je     f010279f <mem_init+0xee9>
	assert((pp1 = page_alloc(0)));
f0101e48:	83 ec 0c             	sub    $0xc,%esp
f0101e4b:	6a 00                	push   $0x0
f0101e4d:	e8 89 f5 ff ff       	call   f01013db <page_alloc>
f0101e52:	89 c7                	mov    %eax,%edi
f0101e54:	83 c4 10             	add    $0x10,%esp
f0101e57:	85 c0                	test   %eax,%eax
f0101e59:	0f 84 59 09 00 00    	je     f01027b8 <mem_init+0xf02>
	assert((pp2 = page_alloc(0)));
f0101e5f:	83 ec 0c             	sub    $0xc,%esp
f0101e62:	6a 00                	push   $0x0
f0101e64:	e8 72 f5 ff ff       	call   f01013db <page_alloc>
f0101e69:	89 c3                	mov    %eax,%ebx
f0101e6b:	83 c4 10             	add    $0x10,%esp
f0101e6e:	85 c0                	test   %eax,%eax
f0101e70:	0f 84 5b 09 00 00    	je     f01027d1 <mem_init+0xf1b>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101e76:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101e79:	0f 84 6b 09 00 00    	je     f01027ea <mem_init+0xf34>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101e7f:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101e82:	0f 84 7b 09 00 00    	je     f0102803 <mem_init+0xf4d>
f0101e88:	39 c7                	cmp    %eax,%edi
f0101e8a:	0f 84 73 09 00 00    	je     f0102803 <mem_init+0xf4d>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101e90:	a1 40 62 35 f0       	mov    0xf0356240,%eax
f0101e95:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101e98:	c7 05 40 62 35 f0 00 	movl   $0x0,0xf0356240
f0101e9f:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101ea2:	83 ec 0c             	sub    $0xc,%esp
f0101ea5:	6a 00                	push   $0x0
f0101ea7:	e8 2f f5 ff ff       	call   f01013db <page_alloc>
f0101eac:	83 c4 10             	add    $0x10,%esp
f0101eaf:	85 c0                	test   %eax,%eax
f0101eb1:	0f 85 65 09 00 00    	jne    f010281c <mem_init+0xf66>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101eb7:	83 ec 04             	sub    $0x4,%esp
f0101eba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101ebd:	50                   	push   %eax
f0101ebe:	6a 00                	push   $0x0
f0101ec0:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0101ec6:	e8 ab f7 ff ff       	call   f0101676 <page_lookup>
f0101ecb:	83 c4 10             	add    $0x10,%esp
f0101ece:	85 c0                	test   %eax,%eax
f0101ed0:	0f 85 5f 09 00 00    	jne    f0102835 <mem_init+0xf7f>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101ed6:	6a 02                	push   $0x2
f0101ed8:	6a 00                	push   $0x0
f0101eda:	57                   	push   %edi
f0101edb:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0101ee1:	e8 a6 f8 ff ff       	call   f010178c <page_insert>
f0101ee6:	83 c4 10             	add    $0x10,%esp
f0101ee9:	85 c0                	test   %eax,%eax
f0101eeb:	0f 89 5d 09 00 00    	jns    f010284e <mem_init+0xf98>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101ef1:	83 ec 0c             	sub    $0xc,%esp
f0101ef4:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101ef7:	e8 51 f5 ff ff       	call   f010144d <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101efc:	6a 02                	push   $0x2
f0101efe:	6a 00                	push   $0x0
f0101f00:	57                   	push   %edi
f0101f01:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0101f07:	e8 80 f8 ff ff       	call   f010178c <page_insert>
f0101f0c:	83 c4 20             	add    $0x20,%esp
f0101f0f:	85 c0                	test   %eax,%eax
f0101f11:	0f 85 50 09 00 00    	jne    f0102867 <mem_init+0xfb1>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101f17:	8b 35 8c 6e 35 f0    	mov    0xf0356e8c,%esi
	return (pp - pages) << PGSHIFT;
f0101f1d:	8b 0d 90 6e 35 f0    	mov    0xf0356e90,%ecx
f0101f23:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101f26:	8b 16                	mov    (%esi),%edx
f0101f28:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101f2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f31:	29 c8                	sub    %ecx,%eax
f0101f33:	c1 f8 03             	sar    $0x3,%eax
f0101f36:	c1 e0 0c             	shl    $0xc,%eax
f0101f39:	39 c2                	cmp    %eax,%edx
f0101f3b:	0f 85 3f 09 00 00    	jne    f0102880 <mem_init+0xfca>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101f41:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f46:	89 f0                	mov    %esi,%eax
f0101f48:	e8 93 f0 ff ff       	call   f0100fe0 <check_va2pa>
f0101f4d:	89 fa                	mov    %edi,%edx
f0101f4f:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101f52:	c1 fa 03             	sar    $0x3,%edx
f0101f55:	c1 e2 0c             	shl    $0xc,%edx
f0101f58:	39 d0                	cmp    %edx,%eax
f0101f5a:	0f 85 39 09 00 00    	jne    f0102899 <mem_init+0xfe3>
	assert(pp1->pp_ref == 1);
f0101f60:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101f65:	0f 85 47 09 00 00    	jne    f01028b2 <mem_init+0xffc>
	assert(pp0->pp_ref == 1);
f0101f6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f6e:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f73:	0f 85 52 09 00 00    	jne    f01028cb <mem_init+0x1015>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101f79:	6a 02                	push   $0x2
f0101f7b:	68 00 10 00 00       	push   $0x1000
f0101f80:	53                   	push   %ebx
f0101f81:	56                   	push   %esi
f0101f82:	e8 05 f8 ff ff       	call   f010178c <page_insert>
f0101f87:	83 c4 10             	add    $0x10,%esp
f0101f8a:	85 c0                	test   %eax,%eax
f0101f8c:	0f 85 52 09 00 00    	jne    f01028e4 <mem_init+0x102e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f92:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f97:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f0101f9c:	e8 3f f0 ff ff       	call   f0100fe0 <check_va2pa>
f0101fa1:	89 da                	mov    %ebx,%edx
f0101fa3:	2b 15 90 6e 35 f0    	sub    0xf0356e90,%edx
f0101fa9:	c1 fa 03             	sar    $0x3,%edx
f0101fac:	c1 e2 0c             	shl    $0xc,%edx
f0101faf:	39 d0                	cmp    %edx,%eax
f0101fb1:	0f 85 46 09 00 00    	jne    f01028fd <mem_init+0x1047>
	assert(pp2->pp_ref == 1);
f0101fb7:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101fbc:	0f 85 54 09 00 00    	jne    f0102916 <mem_init+0x1060>

	// should be no free memory
	assert(!page_alloc(0));
f0101fc2:	83 ec 0c             	sub    $0xc,%esp
f0101fc5:	6a 00                	push   $0x0
f0101fc7:	e8 0f f4 ff ff       	call   f01013db <page_alloc>
f0101fcc:	83 c4 10             	add    $0x10,%esp
f0101fcf:	85 c0                	test   %eax,%eax
f0101fd1:	0f 85 58 09 00 00    	jne    f010292f <mem_init+0x1079>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101fd7:	6a 02                	push   $0x2
f0101fd9:	68 00 10 00 00       	push   $0x1000
f0101fde:	53                   	push   %ebx
f0101fdf:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0101fe5:	e8 a2 f7 ff ff       	call   f010178c <page_insert>
f0101fea:	83 c4 10             	add    $0x10,%esp
f0101fed:	85 c0                	test   %eax,%eax
f0101fef:	0f 85 53 09 00 00    	jne    f0102948 <mem_init+0x1092>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ff5:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ffa:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f0101fff:	e8 dc ef ff ff       	call   f0100fe0 <check_va2pa>
f0102004:	89 da                	mov    %ebx,%edx
f0102006:	2b 15 90 6e 35 f0    	sub    0xf0356e90,%edx
f010200c:	c1 fa 03             	sar    $0x3,%edx
f010200f:	c1 e2 0c             	shl    $0xc,%edx
f0102012:	39 d0                	cmp    %edx,%eax
f0102014:	0f 85 47 09 00 00    	jne    f0102961 <mem_init+0x10ab>
	assert(pp2->pp_ref == 1);
f010201a:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010201f:	0f 85 55 09 00 00    	jne    f010297a <mem_init+0x10c4>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0102025:	83 ec 0c             	sub    $0xc,%esp
f0102028:	6a 00                	push   $0x0
f010202a:	e8 ac f3 ff ff       	call   f01013db <page_alloc>
f010202f:	83 c4 10             	add    $0x10,%esp
f0102032:	85 c0                	test   %eax,%eax
f0102034:	0f 85 59 09 00 00    	jne    f0102993 <mem_init+0x10dd>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f010203a:	8b 15 8c 6e 35 f0    	mov    0xf0356e8c,%edx
f0102040:	8b 02                	mov    (%edx),%eax
f0102042:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0102047:	89 c1                	mov    %eax,%ecx
f0102049:	c1 e9 0c             	shr    $0xc,%ecx
f010204c:	3b 0d 88 6e 35 f0    	cmp    0xf0356e88,%ecx
f0102052:	0f 83 54 09 00 00    	jae    f01029ac <mem_init+0x10f6>
	return (void *)(pa + KERNBASE);
f0102058:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010205d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102060:	83 ec 04             	sub    $0x4,%esp
f0102063:	6a 00                	push   $0x0
f0102065:	68 00 10 00 00       	push   $0x1000
f010206a:	52                   	push   %edx
f010206b:	e8 75 f4 ff ff       	call   f01014e5 <pgdir_walk>
f0102070:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0102073:	8d 51 04             	lea    0x4(%ecx),%edx
f0102076:	83 c4 10             	add    $0x10,%esp
f0102079:	39 d0                	cmp    %edx,%eax
f010207b:	0f 85 40 09 00 00    	jne    f01029c1 <mem_init+0x110b>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102081:	6a 06                	push   $0x6
f0102083:	68 00 10 00 00       	push   $0x1000
f0102088:	53                   	push   %ebx
f0102089:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f010208f:	e8 f8 f6 ff ff       	call   f010178c <page_insert>
f0102094:	83 c4 10             	add    $0x10,%esp
f0102097:	85 c0                	test   %eax,%eax
f0102099:	0f 85 3b 09 00 00    	jne    f01029da <mem_init+0x1124>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010209f:	8b 35 8c 6e 35 f0    	mov    0xf0356e8c,%esi
f01020a5:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020aa:	89 f0                	mov    %esi,%eax
f01020ac:	e8 2f ef ff ff       	call   f0100fe0 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f01020b1:	89 da                	mov    %ebx,%edx
f01020b3:	2b 15 90 6e 35 f0    	sub    0xf0356e90,%edx
f01020b9:	c1 fa 03             	sar    $0x3,%edx
f01020bc:	c1 e2 0c             	shl    $0xc,%edx
f01020bf:	39 d0                	cmp    %edx,%eax
f01020c1:	0f 85 2c 09 00 00    	jne    f01029f3 <mem_init+0x113d>
	assert(pp2->pp_ref == 1);
f01020c7:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01020cc:	0f 85 3a 09 00 00    	jne    f0102a0c <mem_init+0x1156>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01020d2:	83 ec 04             	sub    $0x4,%esp
f01020d5:	6a 00                	push   $0x0
f01020d7:	68 00 10 00 00       	push   $0x1000
f01020dc:	56                   	push   %esi
f01020dd:	e8 03 f4 ff ff       	call   f01014e5 <pgdir_walk>
f01020e2:	83 c4 10             	add    $0x10,%esp
f01020e5:	f6 00 04             	testb  $0x4,(%eax)
f01020e8:	0f 84 37 09 00 00    	je     f0102a25 <mem_init+0x116f>
	assert(kern_pgdir[0] & PTE_U);
f01020ee:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f01020f3:	f6 00 04             	testb  $0x4,(%eax)
f01020f6:	0f 84 42 09 00 00    	je     f0102a3e <mem_init+0x1188>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01020fc:	6a 02                	push   $0x2
f01020fe:	68 00 10 00 00       	push   $0x1000
f0102103:	53                   	push   %ebx
f0102104:	50                   	push   %eax
f0102105:	e8 82 f6 ff ff       	call   f010178c <page_insert>
f010210a:	83 c4 10             	add    $0x10,%esp
f010210d:	85 c0                	test   %eax,%eax
f010210f:	0f 85 42 09 00 00    	jne    f0102a57 <mem_init+0x11a1>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102115:	83 ec 04             	sub    $0x4,%esp
f0102118:	6a 00                	push   $0x0
f010211a:	68 00 10 00 00       	push   $0x1000
f010211f:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0102125:	e8 bb f3 ff ff       	call   f01014e5 <pgdir_walk>
f010212a:	83 c4 10             	add    $0x10,%esp
f010212d:	f6 00 02             	testb  $0x2,(%eax)
f0102130:	0f 84 3a 09 00 00    	je     f0102a70 <mem_init+0x11ba>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102136:	83 ec 04             	sub    $0x4,%esp
f0102139:	6a 00                	push   $0x0
f010213b:	68 00 10 00 00       	push   $0x1000
f0102140:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0102146:	e8 9a f3 ff ff       	call   f01014e5 <pgdir_walk>
f010214b:	83 c4 10             	add    $0x10,%esp
f010214e:	f6 00 04             	testb  $0x4,(%eax)
f0102151:	0f 85 32 09 00 00    	jne    f0102a89 <mem_init+0x11d3>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102157:	6a 02                	push   $0x2
f0102159:	68 00 00 40 00       	push   $0x400000
f010215e:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102161:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0102167:	e8 20 f6 ff ff       	call   f010178c <page_insert>
f010216c:	83 c4 10             	add    $0x10,%esp
f010216f:	85 c0                	test   %eax,%eax
f0102171:	0f 89 2b 09 00 00    	jns    f0102aa2 <mem_init+0x11ec>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102177:	6a 02                	push   $0x2
f0102179:	68 00 10 00 00       	push   $0x1000
f010217e:	57                   	push   %edi
f010217f:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0102185:	e8 02 f6 ff ff       	call   f010178c <page_insert>
f010218a:	83 c4 10             	add    $0x10,%esp
f010218d:	85 c0                	test   %eax,%eax
f010218f:	0f 85 26 09 00 00    	jne    f0102abb <mem_init+0x1205>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102195:	83 ec 04             	sub    $0x4,%esp
f0102198:	6a 00                	push   $0x0
f010219a:	68 00 10 00 00       	push   $0x1000
f010219f:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01021a5:	e8 3b f3 ff ff       	call   f01014e5 <pgdir_walk>
f01021aa:	83 c4 10             	add    $0x10,%esp
f01021ad:	f6 00 04             	testb  $0x4,(%eax)
f01021b0:	0f 85 1e 09 00 00    	jne    f0102ad4 <mem_init+0x121e>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01021b6:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f01021bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01021be:	ba 00 00 00 00       	mov    $0x0,%edx
f01021c3:	e8 18 ee ff ff       	call   f0100fe0 <check_va2pa>
f01021c8:	89 fe                	mov    %edi,%esi
f01021ca:	2b 35 90 6e 35 f0    	sub    0xf0356e90,%esi
f01021d0:	c1 fe 03             	sar    $0x3,%esi
f01021d3:	c1 e6 0c             	shl    $0xc,%esi
f01021d6:	39 f0                	cmp    %esi,%eax
f01021d8:	0f 85 0f 09 00 00    	jne    f0102aed <mem_init+0x1237>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01021de:	ba 00 10 00 00       	mov    $0x1000,%edx
f01021e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01021e6:	e8 f5 ed ff ff       	call   f0100fe0 <check_va2pa>
f01021eb:	39 c6                	cmp    %eax,%esi
f01021ed:	0f 85 13 09 00 00    	jne    f0102b06 <mem_init+0x1250>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01021f3:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f01021f8:	0f 85 21 09 00 00    	jne    f0102b1f <mem_init+0x1269>
	assert(pp2->pp_ref == 0);
f01021fe:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102203:	0f 85 2f 09 00 00    	jne    f0102b38 <mem_init+0x1282>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0102209:	83 ec 0c             	sub    $0xc,%esp
f010220c:	6a 00                	push   $0x0
f010220e:	e8 c8 f1 ff ff       	call   f01013db <page_alloc>
f0102213:	83 c4 10             	add    $0x10,%esp
f0102216:	85 c0                	test   %eax,%eax
f0102218:	0f 84 33 09 00 00    	je     f0102b51 <mem_init+0x129b>
f010221e:	39 c3                	cmp    %eax,%ebx
f0102220:	0f 85 2b 09 00 00    	jne    f0102b51 <mem_init+0x129b>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0102226:	83 ec 08             	sub    $0x8,%esp
f0102229:	6a 00                	push   $0x0
f010222b:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f0102231:	e8 f5 f4 ff ff       	call   f010172b <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102236:	8b 35 8c 6e 35 f0    	mov    0xf0356e8c,%esi
f010223c:	ba 00 00 00 00       	mov    $0x0,%edx
f0102241:	89 f0                	mov    %esi,%eax
f0102243:	e8 98 ed ff ff       	call   f0100fe0 <check_va2pa>
f0102248:	83 c4 10             	add    $0x10,%esp
f010224b:	83 f8 ff             	cmp    $0xffffffff,%eax
f010224e:	0f 85 16 09 00 00    	jne    f0102b6a <mem_init+0x12b4>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102254:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102259:	89 f0                	mov    %esi,%eax
f010225b:	e8 80 ed ff ff       	call   f0100fe0 <check_va2pa>
f0102260:	89 fa                	mov    %edi,%edx
f0102262:	2b 15 90 6e 35 f0    	sub    0xf0356e90,%edx
f0102268:	c1 fa 03             	sar    $0x3,%edx
f010226b:	c1 e2 0c             	shl    $0xc,%edx
f010226e:	39 d0                	cmp    %edx,%eax
f0102270:	0f 85 0d 09 00 00    	jne    f0102b83 <mem_init+0x12cd>
	assert(pp1->pp_ref == 1);
f0102276:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010227b:	0f 85 1b 09 00 00    	jne    f0102b9c <mem_init+0x12e6>
	assert(pp2->pp_ref == 0);
f0102281:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102286:	0f 85 29 09 00 00    	jne    f0102bb5 <mem_init+0x12ff>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010228c:	6a 00                	push   $0x0
f010228e:	68 00 10 00 00       	push   $0x1000
f0102293:	57                   	push   %edi
f0102294:	56                   	push   %esi
f0102295:	e8 f2 f4 ff ff       	call   f010178c <page_insert>
f010229a:	83 c4 10             	add    $0x10,%esp
f010229d:	85 c0                	test   %eax,%eax
f010229f:	0f 85 29 09 00 00    	jne    f0102bce <mem_init+0x1318>
	assert(pp1->pp_ref);
f01022a5:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01022aa:	0f 84 37 09 00 00    	je     f0102be7 <mem_init+0x1331>
	assert(pp1->pp_link == NULL);
f01022b0:	83 3f 00             	cmpl   $0x0,(%edi)
f01022b3:	0f 85 47 09 00 00    	jne    f0102c00 <mem_init+0x134a>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f01022b9:	83 ec 08             	sub    $0x8,%esp
f01022bc:	68 00 10 00 00       	push   $0x1000
f01022c1:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01022c7:	e8 5f f4 ff ff       	call   f010172b <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01022cc:	8b 35 8c 6e 35 f0    	mov    0xf0356e8c,%esi
f01022d2:	ba 00 00 00 00       	mov    $0x0,%edx
f01022d7:	89 f0                	mov    %esi,%eax
f01022d9:	e8 02 ed ff ff       	call   f0100fe0 <check_va2pa>
f01022de:	83 c4 10             	add    $0x10,%esp
f01022e1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01022e4:	0f 85 2f 09 00 00    	jne    f0102c19 <mem_init+0x1363>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01022ea:	ba 00 10 00 00       	mov    $0x1000,%edx
f01022ef:	89 f0                	mov    %esi,%eax
f01022f1:	e8 ea ec ff ff       	call   f0100fe0 <check_va2pa>
f01022f6:	83 f8 ff             	cmp    $0xffffffff,%eax
f01022f9:	0f 85 33 09 00 00    	jne    f0102c32 <mem_init+0x137c>
	assert(pp1->pp_ref == 0);
f01022ff:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102304:	0f 85 41 09 00 00    	jne    f0102c4b <mem_init+0x1395>
	assert(pp2->pp_ref == 0);
f010230a:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010230f:	0f 85 4f 09 00 00    	jne    f0102c64 <mem_init+0x13ae>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0102315:	83 ec 0c             	sub    $0xc,%esp
f0102318:	6a 00                	push   $0x0
f010231a:	e8 bc f0 ff ff       	call   f01013db <page_alloc>
f010231f:	83 c4 10             	add    $0x10,%esp
f0102322:	39 c7                	cmp    %eax,%edi
f0102324:	0f 85 53 09 00 00    	jne    f0102c7d <mem_init+0x13c7>
f010232a:	85 c0                	test   %eax,%eax
f010232c:	0f 84 4b 09 00 00    	je     f0102c7d <mem_init+0x13c7>

	// should be no free memory
	assert(!page_alloc(0));
f0102332:	83 ec 0c             	sub    $0xc,%esp
f0102335:	6a 00                	push   $0x0
f0102337:	e8 9f f0 ff ff       	call   f01013db <page_alloc>
f010233c:	83 c4 10             	add    $0x10,%esp
f010233f:	85 c0                	test   %eax,%eax
f0102341:	0f 85 4f 09 00 00    	jne    f0102c96 <mem_init+0x13e0>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102347:	8b 0d 8c 6e 35 f0    	mov    0xf0356e8c,%ecx
f010234d:	8b 11                	mov    (%ecx),%edx
f010234f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102358:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f010235e:	c1 f8 03             	sar    $0x3,%eax
f0102361:	c1 e0 0c             	shl    $0xc,%eax
f0102364:	39 c2                	cmp    %eax,%edx
f0102366:	0f 85 43 09 00 00    	jne    f0102caf <mem_init+0x13f9>
	kern_pgdir[0] = 0;
f010236c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102372:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102375:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010237a:	0f 85 48 09 00 00    	jne    f0102cc8 <mem_init+0x1412>
	pp0->pp_ref = 0;
f0102380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102383:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102389:	83 ec 0c             	sub    $0xc,%esp
f010238c:	50                   	push   %eax
f010238d:	e8 bb f0 ff ff       	call   f010144d <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102392:	83 c4 0c             	add    $0xc,%esp
f0102395:	6a 01                	push   $0x1
f0102397:	68 00 10 40 00       	push   $0x401000
f010239c:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01023a2:	e8 3e f1 ff ff       	call   f01014e5 <pgdir_walk>
f01023a7:	89 c1                	mov    %eax,%ecx
f01023a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01023ac:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f01023b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01023b4:	8b 40 04             	mov    0x4(%eax),%eax
f01023b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01023bc:	8b 35 88 6e 35 f0    	mov    0xf0356e88,%esi
f01023c2:	89 c2                	mov    %eax,%edx
f01023c4:	c1 ea 0c             	shr    $0xc,%edx
f01023c7:	83 c4 10             	add    $0x10,%esp
f01023ca:	39 f2                	cmp    %esi,%edx
f01023cc:	0f 83 0f 09 00 00    	jae    f0102ce1 <mem_init+0x142b>
	assert(ptep == ptep1 + PTX(va));
f01023d2:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f01023d7:	39 c1                	cmp    %eax,%ecx
f01023d9:	0f 85 17 09 00 00    	jne    f0102cf6 <mem_init+0x1440>
	kern_pgdir[PDX(va)] = 0;
f01023df:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01023e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f01023e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01023ec:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01023f2:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f01023f8:	c1 f8 03             	sar    $0x3,%eax
f01023fb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01023fe:	89 c2                	mov    %eax,%edx
f0102400:	c1 ea 0c             	shr    $0xc,%edx
f0102403:	39 d6                	cmp    %edx,%esi
f0102405:	0f 86 04 09 00 00    	jbe    f0102d0f <mem_init+0x1459>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f010240b:	83 ec 04             	sub    $0x4,%esp
f010240e:	68 00 10 00 00       	push   $0x1000
f0102413:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0102418:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010241d:	50                   	push   %eax
f010241e:	e8 66 41 00 00       	call   f0106589 <memset>
	page_free(pp0);
f0102423:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0102426:	89 34 24             	mov    %esi,(%esp)
f0102429:	e8 1f f0 ff ff       	call   f010144d <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f010242e:	83 c4 0c             	add    $0xc,%esp
f0102431:	6a 01                	push   $0x1
f0102433:	6a 00                	push   $0x0
f0102435:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f010243b:	e8 a5 f0 ff ff       	call   f01014e5 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0102440:	89 f0                	mov    %esi,%eax
f0102442:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f0102448:	c1 f8 03             	sar    $0x3,%eax
f010244b:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010244e:	89 c2                	mov    %eax,%edx
f0102450:	c1 ea 0c             	shr    $0xc,%edx
f0102453:	83 c4 10             	add    $0x10,%esp
f0102456:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f010245c:	0f 83 bf 08 00 00    	jae    f0102d21 <mem_init+0x146b>
	return (void *)(pa + KERNBASE);
f0102462:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f0102468:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010246b:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102470:	f6 02 01             	testb  $0x1,(%edx)
f0102473:	0f 85 ba 08 00 00    	jne    f0102d33 <mem_init+0x147d>
f0102479:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f010247c:	39 c2                	cmp    %eax,%edx
f010247e:	75 f0                	jne    f0102470 <mem_init+0xbba>
	kern_pgdir[0] = 0;
f0102480:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f0102485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010248b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010248e:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102494:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102497:	89 0d 40 62 35 f0    	mov    %ecx,0xf0356240

	// free the pages we took
	page_free(pp0);
f010249d:	83 ec 0c             	sub    $0xc,%esp
f01024a0:	50                   	push   %eax
f01024a1:	e8 a7 ef ff ff       	call   f010144d <page_free>
	page_free(pp1);
f01024a6:	89 3c 24             	mov    %edi,(%esp)
f01024a9:	e8 9f ef ff ff       	call   f010144d <page_free>
	page_free(pp2);
f01024ae:	89 1c 24             	mov    %ebx,(%esp)
f01024b1:	e8 97 ef ff ff       	call   f010144d <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f01024b6:	83 c4 08             	add    $0x8,%esp
f01024b9:	68 01 10 00 00       	push   $0x1001
f01024be:	6a 00                	push   $0x0
f01024c0:	e8 79 f3 ff ff       	call   f010183e <mmio_map_region>
f01024c5:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f01024c7:	83 c4 08             	add    $0x8,%esp
f01024ca:	68 00 10 00 00       	push   $0x1000
f01024cf:	6a 00                	push   $0x0
f01024d1:	e8 68 f3 ff ff       	call   f010183e <mmio_map_region>
f01024d6:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01024d8:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f01024de:	83 c4 10             	add    $0x10,%esp
f01024e1:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f01024e7:	0f 86 5f 08 00 00    	jbe    f0102d4c <mem_init+0x1496>
f01024ed:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f01024f2:	0f 87 54 08 00 00    	ja     f0102d4c <mem_init+0x1496>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f01024f8:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f01024fe:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102504:	0f 87 5b 08 00 00    	ja     f0102d65 <mem_init+0x14af>
f010250a:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102510:	0f 86 4f 08 00 00    	jbe    f0102d65 <mem_init+0x14af>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102516:	89 da                	mov    %ebx,%edx
f0102518:	09 f2                	or     %esi,%edx
f010251a:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102520:	0f 85 58 08 00 00    	jne    f0102d7e <mem_init+0x14c8>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0102526:	39 c6                	cmp    %eax,%esi
f0102528:	0f 82 69 08 00 00    	jb     f0102d97 <mem_init+0x14e1>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f010252e:	8b 3d 8c 6e 35 f0    	mov    0xf0356e8c,%edi
f0102534:	89 da                	mov    %ebx,%edx
f0102536:	89 f8                	mov    %edi,%eax
f0102538:	e8 a3 ea ff ff       	call   f0100fe0 <check_va2pa>
f010253d:	85 c0                	test   %eax,%eax
f010253f:	0f 85 6b 08 00 00    	jne    f0102db0 <mem_init+0x14fa>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102545:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f010254b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010254e:	89 c2                	mov    %eax,%edx
f0102550:	89 f8                	mov    %edi,%eax
f0102552:	e8 89 ea ff ff       	call   f0100fe0 <check_va2pa>
f0102557:	3d 00 10 00 00       	cmp    $0x1000,%eax
f010255c:	0f 85 67 08 00 00    	jne    f0102dc9 <mem_init+0x1513>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102562:	89 f2                	mov    %esi,%edx
f0102564:	89 f8                	mov    %edi,%eax
f0102566:	e8 75 ea ff ff       	call   f0100fe0 <check_va2pa>
f010256b:	85 c0                	test   %eax,%eax
f010256d:	0f 85 6f 08 00 00    	jne    f0102de2 <mem_init+0x152c>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102573:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102579:	89 f8                	mov    %edi,%eax
f010257b:	e8 60 ea ff ff       	call   f0100fe0 <check_va2pa>
f0102580:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102583:	0f 85 72 08 00 00    	jne    f0102dfb <mem_init+0x1545>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102589:	83 ec 04             	sub    $0x4,%esp
f010258c:	6a 00                	push   $0x0
f010258e:	53                   	push   %ebx
f010258f:	57                   	push   %edi
f0102590:	e8 50 ef ff ff       	call   f01014e5 <pgdir_walk>
f0102595:	83 c4 10             	add    $0x10,%esp
f0102598:	f6 00 1a             	testb  $0x1a,(%eax)
f010259b:	0f 84 73 08 00 00    	je     f0102e14 <mem_init+0x155e>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01025a1:	83 ec 04             	sub    $0x4,%esp
f01025a4:	6a 00                	push   $0x0
f01025a6:	53                   	push   %ebx
f01025a7:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01025ad:	e8 33 ef ff ff       	call   f01014e5 <pgdir_walk>
f01025b2:	8b 00                	mov    (%eax),%eax
f01025b4:	83 c4 10             	add    $0x10,%esp
f01025b7:	83 e0 04             	and    $0x4,%eax
f01025ba:	89 c7                	mov    %eax,%edi
f01025bc:	0f 85 6b 08 00 00    	jne    f0102e2d <mem_init+0x1577>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f01025c2:	83 ec 04             	sub    $0x4,%esp
f01025c5:	6a 00                	push   $0x0
f01025c7:	53                   	push   %ebx
f01025c8:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01025ce:	e8 12 ef ff ff       	call   f01014e5 <pgdir_walk>
f01025d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f01025d9:	83 c4 0c             	add    $0xc,%esp
f01025dc:	6a 00                	push   $0x0
f01025de:	ff 75 d4             	pushl  -0x2c(%ebp)
f01025e1:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01025e7:	e8 f9 ee ff ff       	call   f01014e5 <pgdir_walk>
f01025ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f01025f2:	83 c4 0c             	add    $0xc,%esp
f01025f5:	6a 00                	push   $0x0
f01025f7:	56                   	push   %esi
f01025f8:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01025fe:	e8 e2 ee ff ff       	call   f01014e5 <pgdir_walk>
f0102603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102609:	c7 04 24 8f 87 10 f0 	movl   $0xf010878f,(%esp)
f0102610:	e8 a9 18 00 00       	call   f0103ebe <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f0102615:	a1 90 6e 35 f0       	mov    0xf0356e90,%eax
	if ((uint32_t)kva < KERNBASE)
f010261a:	83 c4 10             	add    $0x10,%esp
f010261d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102622:	0f 86 1e 08 00 00    	jbe    f0102e46 <mem_init+0x1590>
f0102628:	83 ec 08             	sub    $0x8,%esp
f010262b:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010262d:	05 00 00 00 10       	add    $0x10000000,%eax
f0102632:	50                   	push   %eax
f0102633:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102638:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f010263d:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f0102642:	e8 83 ef ff ff       	call   f01015ca <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f0102647:	a1 48 62 35 f0       	mov    0xf0356248,%eax
	if ((uint32_t)kva < KERNBASE)
f010264c:	83 c4 10             	add    $0x10,%esp
f010264f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102654:	0f 86 01 08 00 00    	jbe    f0102e5b <mem_init+0x15a5>
f010265a:	83 ec 08             	sub    $0x8,%esp
f010265d:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010265f:	05 00 00 00 10       	add    $0x10000000,%eax
f0102664:	50                   	push   %eax
f0102665:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010266a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f010266f:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f0102674:	e8 51 ef ff ff       	call   f01015ca <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102679:	83 c4 10             	add    $0x10,%esp
f010267c:	b8 00 b0 11 f0       	mov    $0xf011b000,%eax
f0102681:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102686:	0f 86 e4 07 00 00    	jbe    f0102e70 <mem_init+0x15ba>
	boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f010268c:	83 ec 08             	sub    $0x8,%esp
f010268f:	6a 02                	push   $0x2
f0102691:	68 00 b0 11 00       	push   $0x11b000
f0102696:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010269b:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01026a0:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f01026a5:	e8 20 ef ff ff       	call   f01015ca <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (size_t)(0 - KERNBASE), 0, PTE_W);
f01026aa:	83 c4 08             	add    $0x8,%esp
f01026ad:	6a 02                	push   $0x2
f01026af:	6a 00                	push   $0x0
f01026b1:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f01026b6:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01026bb:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f01026c0:	e8 05 ef ff ff       	call   f01015ca <boot_map_region>
f01026c5:	c7 45 d0 00 80 35 f0 	movl   $0xf0358000,-0x30(%ebp)
f01026cc:	83 c4 10             	add    $0x10,%esp
f01026cf:	bb 00 80 35 f0       	mov    $0xf0358000,%ebx
f01026d4:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01026d9:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01026df:	0f 86 a0 07 00 00    	jbe    f0102e85 <mem_init+0x15cf>
		boot_map_region(kern_pgdir, kstacktop_i-KSTKSIZE, KSTKSIZE,
f01026e5:	83 ec 08             	sub    $0x8,%esp
f01026e8:	6a 02                	push   $0x2
f01026ea:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01026f0:	50                   	push   %eax
f01026f1:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01026f6:	89 f2                	mov    %esi,%edx
f01026f8:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f01026fd:	e8 c8 ee ff ff       	call   f01015ca <boot_map_region>
f0102702:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0102708:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for (i=0;i<NCPU;i++){
f010270e:	83 c4 10             	add    $0x10,%esp
f0102711:	81 fb 00 80 39 f0    	cmp    $0xf0398000,%ebx
f0102717:	75 c0                	jne    f01026d9 <mem_init+0xe23>
	pgdir = kern_pgdir;
f0102719:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f010271e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102721:	a1 88 6e 35 f0       	mov    0xf0356e88,%eax
f0102726:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102729:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102730:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102735:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102738:	8b 35 90 6e 35 f0    	mov    0xf0356e90,%esi
f010273e:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102741:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0102747:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f010274a:	89 fb                	mov    %edi,%ebx
f010274c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f010274f:	0f 86 73 07 00 00    	jbe    f0102ec8 <mem_init+0x1612>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102755:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f010275b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010275e:	e8 7d e8 ff ff       	call   f0100fe0 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102763:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f010276a:	0f 86 2a 07 00 00    	jbe    f0102e9a <mem_init+0x15e4>
f0102770:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102773:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102776:	39 d0                	cmp    %edx,%eax
f0102778:	0f 85 31 07 00 00    	jne    f0102eaf <mem_init+0x15f9>
	for (i = 0; i < n; i += PGSIZE)
f010277e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102784:	eb c6                	jmp    f010274c <mem_init+0xe96>
	assert(nfree == 0);
f0102786:	68 a6 86 10 f0       	push   $0xf01086a6
f010278b:	68 c7 84 10 f0       	push   $0xf01084c7
f0102790:	68 81 03 00 00       	push   $0x381
f0102795:	68 a1 84 10 f0       	push   $0xf01084a1
f010279a:	e8 a1 d8 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010279f:	68 b4 85 10 f0       	push   $0xf01085b4
f01027a4:	68 c7 84 10 f0       	push   $0xf01084c7
f01027a9:	68 f8 03 00 00       	push   $0x3f8
f01027ae:	68 a1 84 10 f0       	push   $0xf01084a1
f01027b3:	e8 88 d8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01027b8:	68 ca 85 10 f0       	push   $0xf01085ca
f01027bd:	68 c7 84 10 f0       	push   $0xf01084c7
f01027c2:	68 f9 03 00 00       	push   $0x3f9
f01027c7:	68 a1 84 10 f0       	push   $0xf01084a1
f01027cc:	e8 6f d8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01027d1:	68 e0 85 10 f0       	push   $0xf01085e0
f01027d6:	68 c7 84 10 f0       	push   $0xf01084c7
f01027db:	68 fa 03 00 00       	push   $0x3fa
f01027e0:	68 a1 84 10 f0       	push   $0xf01084a1
f01027e5:	e8 56 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01027ea:	68 f6 85 10 f0       	push   $0xf01085f6
f01027ef:	68 c7 84 10 f0       	push   $0xf01084c7
f01027f4:	68 fd 03 00 00       	push   $0x3fd
f01027f9:	68 a1 84 10 f0       	push   $0xf01084a1
f01027fe:	e8 3d d8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102803:	68 98 7c 10 f0       	push   $0xf0107c98
f0102808:	68 c7 84 10 f0       	push   $0xf01084c7
f010280d:	68 fe 03 00 00       	push   $0x3fe
f0102812:	68 a1 84 10 f0       	push   $0xf01084a1
f0102817:	e8 24 d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010281c:	68 5f 86 10 f0       	push   $0xf010865f
f0102821:	68 c7 84 10 f0       	push   $0xf01084c7
f0102826:	68 05 04 00 00       	push   $0x405
f010282b:	68 a1 84 10 f0       	push   $0xf01084a1
f0102830:	e8 0b d8 ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102835:	68 d8 7c 10 f0       	push   $0xf0107cd8
f010283a:	68 c7 84 10 f0       	push   $0xf01084c7
f010283f:	68 08 04 00 00       	push   $0x408
f0102844:	68 a1 84 10 f0       	push   $0xf01084a1
f0102849:	e8 f2 d7 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010284e:	68 10 7d 10 f0       	push   $0xf0107d10
f0102853:	68 c7 84 10 f0       	push   $0xf01084c7
f0102858:	68 0b 04 00 00       	push   $0x40b
f010285d:	68 a1 84 10 f0       	push   $0xf01084a1
f0102862:	e8 d9 d7 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102867:	68 40 7d 10 f0       	push   $0xf0107d40
f010286c:	68 c7 84 10 f0       	push   $0xf01084c7
f0102871:	68 0f 04 00 00       	push   $0x40f
f0102876:	68 a1 84 10 f0       	push   $0xf01084a1
f010287b:	e8 c0 d7 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102880:	68 70 7d 10 f0       	push   $0xf0107d70
f0102885:	68 c7 84 10 f0       	push   $0xf01084c7
f010288a:	68 10 04 00 00       	push   $0x410
f010288f:	68 a1 84 10 f0       	push   $0xf01084a1
f0102894:	e8 a7 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102899:	68 98 7d 10 f0       	push   $0xf0107d98
f010289e:	68 c7 84 10 f0       	push   $0xf01084c7
f01028a3:	68 11 04 00 00       	push   $0x411
f01028a8:	68 a1 84 10 f0       	push   $0xf01084a1
f01028ad:	e8 8e d7 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01028b2:	68 b1 86 10 f0       	push   $0xf01086b1
f01028b7:	68 c7 84 10 f0       	push   $0xf01084c7
f01028bc:	68 12 04 00 00       	push   $0x412
f01028c1:	68 a1 84 10 f0       	push   $0xf01084a1
f01028c6:	e8 75 d7 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01028cb:	68 c2 86 10 f0       	push   $0xf01086c2
f01028d0:	68 c7 84 10 f0       	push   $0xf01084c7
f01028d5:	68 13 04 00 00       	push   $0x413
f01028da:	68 a1 84 10 f0       	push   $0xf01084a1
f01028df:	e8 5c d7 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01028e4:	68 c8 7d 10 f0       	push   $0xf0107dc8
f01028e9:	68 c7 84 10 f0       	push   $0xf01084c7
f01028ee:	68 16 04 00 00       	push   $0x416
f01028f3:	68 a1 84 10 f0       	push   $0xf01084a1
f01028f8:	e8 43 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01028fd:	68 04 7e 10 f0       	push   $0xf0107e04
f0102902:	68 c7 84 10 f0       	push   $0xf01084c7
f0102907:	68 17 04 00 00       	push   $0x417
f010290c:	68 a1 84 10 f0       	push   $0xf01084a1
f0102911:	e8 2a d7 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102916:	68 d3 86 10 f0       	push   $0xf01086d3
f010291b:	68 c7 84 10 f0       	push   $0xf01084c7
f0102920:	68 18 04 00 00       	push   $0x418
f0102925:	68 a1 84 10 f0       	push   $0xf01084a1
f010292a:	e8 11 d7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010292f:	68 5f 86 10 f0       	push   $0xf010865f
f0102934:	68 c7 84 10 f0       	push   $0xf01084c7
f0102939:	68 1b 04 00 00       	push   $0x41b
f010293e:	68 a1 84 10 f0       	push   $0xf01084a1
f0102943:	e8 f8 d6 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102948:	68 c8 7d 10 f0       	push   $0xf0107dc8
f010294d:	68 c7 84 10 f0       	push   $0xf01084c7
f0102952:	68 1e 04 00 00       	push   $0x41e
f0102957:	68 a1 84 10 f0       	push   $0xf01084a1
f010295c:	e8 df d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102961:	68 04 7e 10 f0       	push   $0xf0107e04
f0102966:	68 c7 84 10 f0       	push   $0xf01084c7
f010296b:	68 1f 04 00 00       	push   $0x41f
f0102970:	68 a1 84 10 f0       	push   $0xf01084a1
f0102975:	e8 c6 d6 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010297a:	68 d3 86 10 f0       	push   $0xf01086d3
f010297f:	68 c7 84 10 f0       	push   $0xf01084c7
f0102984:	68 20 04 00 00       	push   $0x420
f0102989:	68 a1 84 10 f0       	push   $0xf01084a1
f010298e:	e8 ad d6 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102993:	68 5f 86 10 f0       	push   $0xf010865f
f0102998:	68 c7 84 10 f0       	push   $0xf01084c7
f010299d:	68 24 04 00 00       	push   $0x424
f01029a2:	68 a1 84 10 f0       	push   $0xf01084a1
f01029a7:	e8 94 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01029ac:	50                   	push   %eax
f01029ad:	68 04 72 10 f0       	push   $0xf0107204
f01029b2:	68 27 04 00 00       	push   $0x427
f01029b7:	68 a1 84 10 f0       	push   $0xf01084a1
f01029bc:	e8 7f d6 ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01029c1:	68 34 7e 10 f0       	push   $0xf0107e34
f01029c6:	68 c7 84 10 f0       	push   $0xf01084c7
f01029cb:	68 28 04 00 00       	push   $0x428
f01029d0:	68 a1 84 10 f0       	push   $0xf01084a1
f01029d5:	e8 66 d6 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01029da:	68 74 7e 10 f0       	push   $0xf0107e74
f01029df:	68 c7 84 10 f0       	push   $0xf01084c7
f01029e4:	68 2b 04 00 00       	push   $0x42b
f01029e9:	68 a1 84 10 f0       	push   $0xf01084a1
f01029ee:	e8 4d d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01029f3:	68 04 7e 10 f0       	push   $0xf0107e04
f01029f8:	68 c7 84 10 f0       	push   $0xf01084c7
f01029fd:	68 2c 04 00 00       	push   $0x42c
f0102a02:	68 a1 84 10 f0       	push   $0xf01084a1
f0102a07:	e8 34 d6 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102a0c:	68 d3 86 10 f0       	push   $0xf01086d3
f0102a11:	68 c7 84 10 f0       	push   $0xf01084c7
f0102a16:	68 2d 04 00 00       	push   $0x42d
f0102a1b:	68 a1 84 10 f0       	push   $0xf01084a1
f0102a20:	e8 1b d6 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102a25:	68 b4 7e 10 f0       	push   $0xf0107eb4
f0102a2a:	68 c7 84 10 f0       	push   $0xf01084c7
f0102a2f:	68 2e 04 00 00       	push   $0x42e
f0102a34:	68 a1 84 10 f0       	push   $0xf01084a1
f0102a39:	e8 02 d6 ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102a3e:	68 e4 86 10 f0       	push   $0xf01086e4
f0102a43:	68 c7 84 10 f0       	push   $0xf01084c7
f0102a48:	68 2f 04 00 00       	push   $0x42f
f0102a4d:	68 a1 84 10 f0       	push   $0xf01084a1
f0102a52:	e8 e9 d5 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102a57:	68 c8 7d 10 f0       	push   $0xf0107dc8
f0102a5c:	68 c7 84 10 f0       	push   $0xf01084c7
f0102a61:	68 32 04 00 00       	push   $0x432
f0102a66:	68 a1 84 10 f0       	push   $0xf01084a1
f0102a6b:	e8 d0 d5 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102a70:	68 e8 7e 10 f0       	push   $0xf0107ee8
f0102a75:	68 c7 84 10 f0       	push   $0xf01084c7
f0102a7a:	68 33 04 00 00       	push   $0x433
f0102a7f:	68 a1 84 10 f0       	push   $0xf01084a1
f0102a84:	e8 b7 d5 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102a89:	68 1c 7f 10 f0       	push   $0xf0107f1c
f0102a8e:	68 c7 84 10 f0       	push   $0xf01084c7
f0102a93:	68 34 04 00 00       	push   $0x434
f0102a98:	68 a1 84 10 f0       	push   $0xf01084a1
f0102a9d:	e8 9e d5 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102aa2:	68 54 7f 10 f0       	push   $0xf0107f54
f0102aa7:	68 c7 84 10 f0       	push   $0xf01084c7
f0102aac:	68 37 04 00 00       	push   $0x437
f0102ab1:	68 a1 84 10 f0       	push   $0xf01084a1
f0102ab6:	e8 85 d5 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102abb:	68 8c 7f 10 f0       	push   $0xf0107f8c
f0102ac0:	68 c7 84 10 f0       	push   $0xf01084c7
f0102ac5:	68 3a 04 00 00       	push   $0x43a
f0102aca:	68 a1 84 10 f0       	push   $0xf01084a1
f0102acf:	e8 6c d5 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102ad4:	68 1c 7f 10 f0       	push   $0xf0107f1c
f0102ad9:	68 c7 84 10 f0       	push   $0xf01084c7
f0102ade:	68 3b 04 00 00       	push   $0x43b
f0102ae3:	68 a1 84 10 f0       	push   $0xf01084a1
f0102ae8:	e8 53 d5 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102aed:	68 c8 7f 10 f0       	push   $0xf0107fc8
f0102af2:	68 c7 84 10 f0       	push   $0xf01084c7
f0102af7:	68 3e 04 00 00       	push   $0x43e
f0102afc:	68 a1 84 10 f0       	push   $0xf01084a1
f0102b01:	e8 3a d5 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102b06:	68 f4 7f 10 f0       	push   $0xf0107ff4
f0102b0b:	68 c7 84 10 f0       	push   $0xf01084c7
f0102b10:	68 3f 04 00 00       	push   $0x43f
f0102b15:	68 a1 84 10 f0       	push   $0xf01084a1
f0102b1a:	e8 21 d5 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f0102b1f:	68 fa 86 10 f0       	push   $0xf01086fa
f0102b24:	68 c7 84 10 f0       	push   $0xf01084c7
f0102b29:	68 41 04 00 00       	push   $0x441
f0102b2e:	68 a1 84 10 f0       	push   $0xf01084a1
f0102b33:	e8 08 d5 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102b38:	68 0b 87 10 f0       	push   $0xf010870b
f0102b3d:	68 c7 84 10 f0       	push   $0xf01084c7
f0102b42:	68 42 04 00 00       	push   $0x442
f0102b47:	68 a1 84 10 f0       	push   $0xf01084a1
f0102b4c:	e8 ef d4 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102b51:	68 24 80 10 f0       	push   $0xf0108024
f0102b56:	68 c7 84 10 f0       	push   $0xf01084c7
f0102b5b:	68 45 04 00 00       	push   $0x445
f0102b60:	68 a1 84 10 f0       	push   $0xf01084a1
f0102b65:	e8 d6 d4 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102b6a:	68 48 80 10 f0       	push   $0xf0108048
f0102b6f:	68 c7 84 10 f0       	push   $0xf01084c7
f0102b74:	68 49 04 00 00       	push   $0x449
f0102b79:	68 a1 84 10 f0       	push   $0xf01084a1
f0102b7e:	e8 bd d4 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102b83:	68 f4 7f 10 f0       	push   $0xf0107ff4
f0102b88:	68 c7 84 10 f0       	push   $0xf01084c7
f0102b8d:	68 4a 04 00 00       	push   $0x44a
f0102b92:	68 a1 84 10 f0       	push   $0xf01084a1
f0102b97:	e8 a4 d4 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102b9c:	68 b1 86 10 f0       	push   $0xf01086b1
f0102ba1:	68 c7 84 10 f0       	push   $0xf01084c7
f0102ba6:	68 4b 04 00 00       	push   $0x44b
f0102bab:	68 a1 84 10 f0       	push   $0xf01084a1
f0102bb0:	e8 8b d4 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102bb5:	68 0b 87 10 f0       	push   $0xf010870b
f0102bba:	68 c7 84 10 f0       	push   $0xf01084c7
f0102bbf:	68 4c 04 00 00       	push   $0x44c
f0102bc4:	68 a1 84 10 f0       	push   $0xf01084a1
f0102bc9:	e8 72 d4 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102bce:	68 6c 80 10 f0       	push   $0xf010806c
f0102bd3:	68 c7 84 10 f0       	push   $0xf01084c7
f0102bd8:	68 4f 04 00 00       	push   $0x44f
f0102bdd:	68 a1 84 10 f0       	push   $0xf01084a1
f0102be2:	e8 59 d4 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f0102be7:	68 1c 87 10 f0       	push   $0xf010871c
f0102bec:	68 c7 84 10 f0       	push   $0xf01084c7
f0102bf1:	68 50 04 00 00       	push   $0x450
f0102bf6:	68 a1 84 10 f0       	push   $0xf01084a1
f0102bfb:	e8 40 d4 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102c00:	68 28 87 10 f0       	push   $0xf0108728
f0102c05:	68 c7 84 10 f0       	push   $0xf01084c7
f0102c0a:	68 51 04 00 00       	push   $0x451
f0102c0f:	68 a1 84 10 f0       	push   $0xf01084a1
f0102c14:	e8 27 d4 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102c19:	68 48 80 10 f0       	push   $0xf0108048
f0102c1e:	68 c7 84 10 f0       	push   $0xf01084c7
f0102c23:	68 55 04 00 00       	push   $0x455
f0102c28:	68 a1 84 10 f0       	push   $0xf01084a1
f0102c2d:	e8 0e d4 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102c32:	68 a4 80 10 f0       	push   $0xf01080a4
f0102c37:	68 c7 84 10 f0       	push   $0xf01084c7
f0102c3c:	68 56 04 00 00       	push   $0x456
f0102c41:	68 a1 84 10 f0       	push   $0xf01084a1
f0102c46:	e8 f5 d3 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102c4b:	68 3d 87 10 f0       	push   $0xf010873d
f0102c50:	68 c7 84 10 f0       	push   $0xf01084c7
f0102c55:	68 57 04 00 00       	push   $0x457
f0102c5a:	68 a1 84 10 f0       	push   $0xf01084a1
f0102c5f:	e8 dc d3 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102c64:	68 0b 87 10 f0       	push   $0xf010870b
f0102c69:	68 c7 84 10 f0       	push   $0xf01084c7
f0102c6e:	68 58 04 00 00       	push   $0x458
f0102c73:	68 a1 84 10 f0       	push   $0xf01084a1
f0102c78:	e8 c3 d3 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102c7d:	68 cc 80 10 f0       	push   $0xf01080cc
f0102c82:	68 c7 84 10 f0       	push   $0xf01084c7
f0102c87:	68 5b 04 00 00       	push   $0x45b
f0102c8c:	68 a1 84 10 f0       	push   $0xf01084a1
f0102c91:	e8 aa d3 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102c96:	68 5f 86 10 f0       	push   $0xf010865f
f0102c9b:	68 c7 84 10 f0       	push   $0xf01084c7
f0102ca0:	68 5e 04 00 00       	push   $0x45e
f0102ca5:	68 a1 84 10 f0       	push   $0xf01084a1
f0102caa:	e8 91 d3 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102caf:	68 70 7d 10 f0       	push   $0xf0107d70
f0102cb4:	68 c7 84 10 f0       	push   $0xf01084c7
f0102cb9:	68 61 04 00 00       	push   $0x461
f0102cbe:	68 a1 84 10 f0       	push   $0xf01084a1
f0102cc3:	e8 78 d3 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102cc8:	68 c2 86 10 f0       	push   $0xf01086c2
f0102ccd:	68 c7 84 10 f0       	push   $0xf01084c7
f0102cd2:	68 63 04 00 00       	push   $0x463
f0102cd7:	68 a1 84 10 f0       	push   $0xf01084a1
f0102cdc:	e8 5f d3 ff ff       	call   f0100040 <_panic>
f0102ce1:	50                   	push   %eax
f0102ce2:	68 04 72 10 f0       	push   $0xf0107204
f0102ce7:	68 6a 04 00 00       	push   $0x46a
f0102cec:	68 a1 84 10 f0       	push   $0xf01084a1
f0102cf1:	e8 4a d3 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102cf6:	68 4e 87 10 f0       	push   $0xf010874e
f0102cfb:	68 c7 84 10 f0       	push   $0xf01084c7
f0102d00:	68 6b 04 00 00       	push   $0x46b
f0102d05:	68 a1 84 10 f0       	push   $0xf01084a1
f0102d0a:	e8 31 d3 ff ff       	call   f0100040 <_panic>
f0102d0f:	50                   	push   %eax
f0102d10:	68 04 72 10 f0       	push   $0xf0107204
f0102d15:	6a 58                	push   $0x58
f0102d17:	68 ad 84 10 f0       	push   $0xf01084ad
f0102d1c:	e8 1f d3 ff ff       	call   f0100040 <_panic>
f0102d21:	50                   	push   %eax
f0102d22:	68 04 72 10 f0       	push   $0xf0107204
f0102d27:	6a 58                	push   $0x58
f0102d29:	68 ad 84 10 f0       	push   $0xf01084ad
f0102d2e:	e8 0d d3 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102d33:	68 66 87 10 f0       	push   $0xf0108766
f0102d38:	68 c7 84 10 f0       	push   $0xf01084c7
f0102d3d:	68 75 04 00 00       	push   $0x475
f0102d42:	68 a1 84 10 f0       	push   $0xf01084a1
f0102d47:	e8 f4 d2 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102d4c:	68 f0 80 10 f0       	push   $0xf01080f0
f0102d51:	68 c7 84 10 f0       	push   $0xf01084c7
f0102d56:	68 85 04 00 00       	push   $0x485
f0102d5b:	68 a1 84 10 f0       	push   $0xf01084a1
f0102d60:	e8 db d2 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102d65:	68 18 81 10 f0       	push   $0xf0108118
f0102d6a:	68 c7 84 10 f0       	push   $0xf01084c7
f0102d6f:	68 86 04 00 00       	push   $0x486
f0102d74:	68 a1 84 10 f0       	push   $0xf01084a1
f0102d79:	e8 c2 d2 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102d7e:	68 40 81 10 f0       	push   $0xf0108140
f0102d83:	68 c7 84 10 f0       	push   $0xf01084c7
f0102d88:	68 88 04 00 00       	push   $0x488
f0102d8d:	68 a1 84 10 f0       	push   $0xf01084a1
f0102d92:	e8 a9 d2 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102d97:	68 7d 87 10 f0       	push   $0xf010877d
f0102d9c:	68 c7 84 10 f0       	push   $0xf01084c7
f0102da1:	68 8a 04 00 00       	push   $0x48a
f0102da6:	68 a1 84 10 f0       	push   $0xf01084a1
f0102dab:	e8 90 d2 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102db0:	68 68 81 10 f0       	push   $0xf0108168
f0102db5:	68 c7 84 10 f0       	push   $0xf01084c7
f0102dba:	68 8c 04 00 00       	push   $0x48c
f0102dbf:	68 a1 84 10 f0       	push   $0xf01084a1
f0102dc4:	e8 77 d2 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102dc9:	68 8c 81 10 f0       	push   $0xf010818c
f0102dce:	68 c7 84 10 f0       	push   $0xf01084c7
f0102dd3:	68 8d 04 00 00       	push   $0x48d
f0102dd8:	68 a1 84 10 f0       	push   $0xf01084a1
f0102ddd:	e8 5e d2 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102de2:	68 bc 81 10 f0       	push   $0xf01081bc
f0102de7:	68 c7 84 10 f0       	push   $0xf01084c7
f0102dec:	68 8e 04 00 00       	push   $0x48e
f0102df1:	68 a1 84 10 f0       	push   $0xf01084a1
f0102df6:	e8 45 d2 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102dfb:	68 e0 81 10 f0       	push   $0xf01081e0
f0102e00:	68 c7 84 10 f0       	push   $0xf01084c7
f0102e05:	68 8f 04 00 00       	push   $0x48f
f0102e0a:	68 a1 84 10 f0       	push   $0xf01084a1
f0102e0f:	e8 2c d2 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102e14:	68 0c 82 10 f0       	push   $0xf010820c
f0102e19:	68 c7 84 10 f0       	push   $0xf01084c7
f0102e1e:	68 91 04 00 00       	push   $0x491
f0102e23:	68 a1 84 10 f0       	push   $0xf01084a1
f0102e28:	e8 13 d2 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102e2d:	68 50 82 10 f0       	push   $0xf0108250
f0102e32:	68 c7 84 10 f0       	push   $0xf01084c7
f0102e37:	68 92 04 00 00       	push   $0x492
f0102e3c:	68 a1 84 10 f0       	push   $0xf01084a1
f0102e41:	e8 fa d1 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e46:	50                   	push   %eax
f0102e47:	68 28 72 10 f0       	push   $0xf0107228
f0102e4c:	68 c4 00 00 00       	push   $0xc4
f0102e51:	68 a1 84 10 f0       	push   $0xf01084a1
f0102e56:	e8 e5 d1 ff ff       	call   f0100040 <_panic>
f0102e5b:	50                   	push   %eax
f0102e5c:	68 28 72 10 f0       	push   $0xf0107228
f0102e61:	68 cd 00 00 00       	push   $0xcd
f0102e66:	68 a1 84 10 f0       	push   $0xf01084a1
f0102e6b:	e8 d0 d1 ff ff       	call   f0100040 <_panic>
f0102e70:	50                   	push   %eax
f0102e71:	68 28 72 10 f0       	push   $0xf0107228
f0102e76:	68 da 00 00 00       	push   $0xda
f0102e7b:	68 a1 84 10 f0       	push   $0xf01084a1
f0102e80:	e8 bb d1 ff ff       	call   f0100040 <_panic>
f0102e85:	53                   	push   %ebx
f0102e86:	68 28 72 10 f0       	push   $0xf0107228
f0102e8b:	68 22 01 00 00       	push   $0x122
f0102e90:	68 a1 84 10 f0       	push   $0xf01084a1
f0102e95:	e8 a6 d1 ff ff       	call   f0100040 <_panic>
f0102e9a:	56                   	push   %esi
f0102e9b:	68 28 72 10 f0       	push   $0xf0107228
f0102ea0:	68 99 03 00 00       	push   $0x399
f0102ea5:	68 a1 84 10 f0       	push   $0xf01084a1
f0102eaa:	e8 91 d1 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102eaf:	68 84 82 10 f0       	push   $0xf0108284
f0102eb4:	68 c7 84 10 f0       	push   $0xf01084c7
f0102eb9:	68 99 03 00 00       	push   $0x399
f0102ebe:	68 a1 84 10 f0       	push   $0xf01084a1
f0102ec3:	e8 78 d1 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102ec8:	a1 48 62 35 f0       	mov    0xf0356248,%eax
f0102ecd:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102ed0:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102ed3:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102ed8:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102ede:	89 da                	mov    %ebx,%edx
f0102ee0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ee3:	e8 f8 e0 ff ff       	call   f0100fe0 <check_va2pa>
f0102ee8:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102eef:	76 45                	jbe    f0102f36 <mem_init+0x1680>
f0102ef1:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102ef4:	39 d0                	cmp    %edx,%eax
f0102ef6:	75 55                	jne    f0102f4d <mem_init+0x1697>
f0102ef8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102efe:	81 fb 00 40 c2 ee    	cmp    $0xeec24000,%ebx
f0102f04:	75 d8                	jne    f0102ede <mem_init+0x1628>
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102f06:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102f09:	8b 81 00 0f 00 00    	mov    0xf00(%ecx),%eax
f0102f0f:	89 c2                	mov    %eax,%edx
f0102f11:	81 e2 81 00 00 00    	and    $0x81,%edx
f0102f17:	81 fa 81 00 00 00    	cmp    $0x81,%edx
f0102f1d:	0f 85 75 01 00 00    	jne    f0103098 <mem_init+0x17e2>
	if (check_va2pa_large(pgdir, KERNBASE) == 0) {
f0102f23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102f28:	0f 85 6a 01 00 00    	jne    f0103098 <mem_init+0x17e2>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102f2e:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f31:	c1 e6 0c             	shl    $0xc,%esi
f0102f34:	eb 3f                	jmp    f0102f75 <mem_init+0x16bf>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f36:	ff 75 c8             	pushl  -0x38(%ebp)
f0102f39:	68 28 72 10 f0       	push   $0xf0107228
f0102f3e:	68 9e 03 00 00       	push   $0x39e
f0102f43:	68 a1 84 10 f0       	push   $0xf01084a1
f0102f48:	e8 f3 d0 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102f4d:	68 b8 82 10 f0       	push   $0xf01082b8
f0102f52:	68 c7 84 10 f0       	push   $0xf01084c7
f0102f57:	68 9e 03 00 00       	push   $0x39e
f0102f5c:	68 a1 84 10 f0       	push   $0xf01084a1
f0102f61:	e8 da d0 ff ff       	call   f0100040 <_panic>
	return PTE_ADDR(*pgdir);
f0102f66:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102f6c:	39 d0                	cmp    %edx,%eax
f0102f6e:	75 25                	jne    f0102f95 <mem_init+0x16df>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102f70:	05 00 00 40 00       	add    $0x400000,%eax
f0102f75:	39 f0                	cmp    %esi,%eax
f0102f77:	73 35                	jae    f0102fae <mem_init+0x16f8>
	pgdir = &pgdir[PDX(va)];
f0102f79:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0102f7f:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102f82:	8b 14 91             	mov    (%ecx,%edx,4),%edx
f0102f85:	89 d3                	mov    %edx,%ebx
f0102f87:	81 e3 81 00 00 00    	and    $0x81,%ebx
f0102f8d:	81 fb 81 00 00 00    	cmp    $0x81,%ebx
f0102f93:	74 d1                	je     f0102f66 <mem_init+0x16b0>
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102f95:	68 ec 82 10 f0       	push   $0xf01082ec
f0102f9a:	68 c7 84 10 f0       	push   $0xf01084c7
f0102f9f:	68 a3 03 00 00       	push   $0x3a3
f0102fa4:	68 a1 84 10 f0       	push   $0xf01084a1
f0102fa9:	e8 92 d0 ff ff       	call   f0100040 <_panic>
		cprintf("large page installed!\n");
f0102fae:	83 ec 0c             	sub    $0xc,%esp
f0102fb1:	68 a8 87 10 f0       	push   $0xf01087a8
f0102fb6:	e8 03 0f 00 00       	call   f0103ebe <cprintf>
f0102fbb:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102fbe:	b8 00 80 35 f0       	mov    $0xf0358000,%eax
f0102fc3:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102fc8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0102fcb:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102fcd:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102fd0:	89 f3                	mov    %esi,%ebx
f0102fd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102fd5:	05 00 80 00 20       	add    $0x20008000,%eax
f0102fda:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102fdd:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102fe3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102fe6:	89 da                	mov    %ebx,%edx
f0102fe8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102feb:	e8 f0 df ff ff       	call   f0100fe0 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102ff0:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102ff6:	0f 86 a6 00 00 00    	jbe    f01030a2 <mem_init+0x17ec>
f0102ffc:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102fff:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0103002:	39 d0                	cmp    %edx,%eax
f0103004:	0f 85 af 00 00 00    	jne    f01030b9 <mem_init+0x1803>
f010300a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0103010:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f0103013:	75 d1                	jne    f0102fe6 <mem_init+0x1730>
f0103015:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f010301b:	89 da                	mov    %ebx,%edx
f010301d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103020:	e8 bb df ff ff       	call   f0100fe0 <check_va2pa>
f0103025:	83 f8 ff             	cmp    $0xffffffff,%eax
f0103028:	0f 85 a4 00 00 00    	jne    f01030d2 <mem_init+0x181c>
f010302e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0103034:	39 f3                	cmp    %esi,%ebx
f0103036:	75 e3                	jne    f010301b <mem_init+0x1765>
f0103038:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f010303e:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0103045:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f010304b:	81 ff 00 80 39 f0    	cmp    $0xf0398000,%edi
f0103051:	0f 85 76 ff ff ff    	jne    f0102fcd <mem_init+0x1717>
f0103057:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f010305a:	e9 c7 00 00 00       	jmp    f0103126 <mem_init+0x1870>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010305f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103065:	39 f3                	cmp    %esi,%ebx
f0103067:	0f 83 51 ff ff ff    	jae    f0102fbe <mem_init+0x1708>
            assert(check_va2pa(pgdir, KERNBASE + i) == i);
f010306d:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0103073:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103076:	e8 65 df ff ff       	call   f0100fe0 <check_va2pa>
f010307b:	39 c3                	cmp    %eax,%ebx
f010307d:	74 e0                	je     f010305f <mem_init+0x17a9>
f010307f:	68 18 83 10 f0       	push   $0xf0108318
f0103084:	68 c7 84 10 f0       	push   $0xf01084c7
f0103089:	68 a8 03 00 00       	push   $0x3a8
f010308e:	68 a1 84 10 f0       	push   $0xf01084a1
f0103093:	e8 a8 cf ff ff       	call   f0100040 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103098:	8b 75 c0             	mov    -0x40(%ebp),%esi
f010309b:	c1 e6 0c             	shl    $0xc,%esi
f010309e:	89 fb                	mov    %edi,%ebx
f01030a0:	eb c3                	jmp    f0103065 <mem_init+0x17af>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01030a2:	ff 75 c0             	pushl  -0x40(%ebp)
f01030a5:	68 28 72 10 f0       	push   $0xf0107228
f01030aa:	68 b1 03 00 00       	push   $0x3b1
f01030af:	68 a1 84 10 f0       	push   $0xf01084a1
f01030b4:	e8 87 cf ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f01030b9:	68 40 83 10 f0       	push   $0xf0108340
f01030be:	68 c7 84 10 f0       	push   $0xf01084c7
f01030c3:	68 b1 03 00 00       	push   $0x3b1
f01030c8:	68 a1 84 10 f0       	push   $0xf01084a1
f01030cd:	e8 6e cf ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f01030d2:	68 88 83 10 f0       	push   $0xf0108388
f01030d7:	68 c7 84 10 f0       	push   $0xf01084c7
f01030dc:	68 b3 03 00 00       	push   $0x3b3
f01030e1:	68 a1 84 10 f0       	push   $0xf01084a1
f01030e6:	e8 55 cf ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f01030eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01030ee:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f01030f2:	75 4e                	jne    f0103142 <mem_init+0x188c>
f01030f4:	68 bf 87 10 f0       	push   $0xf01087bf
f01030f9:	68 c7 84 10 f0       	push   $0xf01084c7
f01030fe:	68 be 03 00 00       	push   $0x3be
f0103103:	68 a1 84 10 f0       	push   $0xf01084a1
f0103108:	e8 33 cf ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f010310d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103110:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0103113:	a8 01                	test   $0x1,%al
f0103115:	74 30                	je     f0103147 <mem_init+0x1891>
				assert(pgdir[i] & PTE_W);
f0103117:	a8 02                	test   $0x2,%al
f0103119:	74 45                	je     f0103160 <mem_init+0x18aa>
	for (i = 0; i < NPDENTRIES; i++) {
f010311b:	83 c7 01             	add    $0x1,%edi
f010311e:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0103124:	74 6c                	je     f0103192 <mem_init+0x18dc>
		switch (i) {
f0103126:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f010312c:	83 f8 04             	cmp    $0x4,%eax
f010312f:	76 ba                	jbe    f01030eb <mem_init+0x1835>
			if (i >= PDX(KERNBASE)) {
f0103131:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0103137:	77 d4                	ja     f010310d <mem_init+0x1857>
				assert(pgdir[i] == 0);
f0103139:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010313c:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0103140:	75 37                	jne    f0103179 <mem_init+0x18c3>
	for (i = 0; i < NPDENTRIES; i++) {
f0103142:	83 c7 01             	add    $0x1,%edi
f0103145:	eb df                	jmp    f0103126 <mem_init+0x1870>
				assert(pgdir[i] & PTE_P);
f0103147:	68 bf 87 10 f0       	push   $0xf01087bf
f010314c:	68 c7 84 10 f0       	push   $0xf01084c7
f0103151:	68 c2 03 00 00       	push   $0x3c2
f0103156:	68 a1 84 10 f0       	push   $0xf01084a1
f010315b:	e8 e0 ce ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0103160:	68 d0 87 10 f0       	push   $0xf01087d0
f0103165:	68 c7 84 10 f0       	push   $0xf01084c7
f010316a:	68 c3 03 00 00       	push   $0x3c3
f010316f:	68 a1 84 10 f0       	push   $0xf01084a1
f0103174:	e8 c7 ce ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0103179:	68 e1 87 10 f0       	push   $0xf01087e1
f010317e:	68 c7 84 10 f0       	push   $0xf01084c7
f0103183:	68 c5 03 00 00       	push   $0x3c5
f0103188:	68 a1 84 10 f0       	push   $0xf01084a1
f010318d:	e8 ae ce ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0103192:	83 ec 0c             	sub    $0xc,%esp
f0103195:	68 ac 83 10 f0       	push   $0xf01083ac
f010319a:	e8 1f 0d 00 00       	call   f0103ebe <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f010319f:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f01031a2:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f01031a5:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f01031a8:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01031ad:	83 c4 10             	add    $0x10,%esp
f01031b0:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01031b5:	0f 86 fb 01 00 00    	jbe    f01033b6 <mem_init+0x1b00>
	return (physaddr_t)kva - KERNBASE;
f01031bb:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01031c0:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f01031c3:	b8 00 00 00 00       	mov    $0x0,%eax
f01031c8:	e8 77 de ff ff       	call   f0101044 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f01031cd:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f01031d0:	83 e0 f3             	and    $0xfffffff3,%eax
f01031d3:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f01031d8:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01031db:	83 ec 0c             	sub    $0xc,%esp
f01031de:	6a 00                	push   $0x0
f01031e0:	e8 f6 e1 ff ff       	call   f01013db <page_alloc>
f01031e5:	89 c6                	mov    %eax,%esi
f01031e7:	83 c4 10             	add    $0x10,%esp
f01031ea:	85 c0                	test   %eax,%eax
f01031ec:	0f 84 d9 01 00 00    	je     f01033cb <mem_init+0x1b15>
	assert((pp1 = page_alloc(0)));
f01031f2:	83 ec 0c             	sub    $0xc,%esp
f01031f5:	6a 00                	push   $0x0
f01031f7:	e8 df e1 ff ff       	call   f01013db <page_alloc>
f01031fc:	89 c7                	mov    %eax,%edi
f01031fe:	83 c4 10             	add    $0x10,%esp
f0103201:	85 c0                	test   %eax,%eax
f0103203:	0f 84 db 01 00 00    	je     f01033e4 <mem_init+0x1b2e>
	assert((pp2 = page_alloc(0)));
f0103209:	83 ec 0c             	sub    $0xc,%esp
f010320c:	6a 00                	push   $0x0
f010320e:	e8 c8 e1 ff ff       	call   f01013db <page_alloc>
f0103213:	89 c3                	mov    %eax,%ebx
f0103215:	83 c4 10             	add    $0x10,%esp
f0103218:	85 c0                	test   %eax,%eax
f010321a:	0f 84 dd 01 00 00    	je     f01033fd <mem_init+0x1b47>
	page_free(pp0);
f0103220:	83 ec 0c             	sub    $0xc,%esp
f0103223:	56                   	push   %esi
f0103224:	e8 24 e2 ff ff       	call   f010144d <page_free>
	return (pp - pages) << PGSHIFT;
f0103229:	89 f8                	mov    %edi,%eax
f010322b:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f0103231:	c1 f8 03             	sar    $0x3,%eax
f0103234:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103237:	89 c2                	mov    %eax,%edx
f0103239:	c1 ea 0c             	shr    $0xc,%edx
f010323c:	83 c4 10             	add    $0x10,%esp
f010323f:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f0103245:	0f 83 cb 01 00 00    	jae    f0103416 <mem_init+0x1b60>
	memset(page2kva(pp1), 1, PGSIZE);
f010324b:	83 ec 04             	sub    $0x4,%esp
f010324e:	68 00 10 00 00       	push   $0x1000
f0103253:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0103255:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010325a:	50                   	push   %eax
f010325b:	e8 29 33 00 00       	call   f0106589 <memset>
	return (pp - pages) << PGSHIFT;
f0103260:	89 d8                	mov    %ebx,%eax
f0103262:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f0103268:	c1 f8 03             	sar    $0x3,%eax
f010326b:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010326e:	89 c2                	mov    %eax,%edx
f0103270:	c1 ea 0c             	shr    $0xc,%edx
f0103273:	83 c4 10             	add    $0x10,%esp
f0103276:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f010327c:	0f 83 a6 01 00 00    	jae    f0103428 <mem_init+0x1b72>
	memset(page2kva(pp2), 2, PGSIZE);
f0103282:	83 ec 04             	sub    $0x4,%esp
f0103285:	68 00 10 00 00       	push   $0x1000
f010328a:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f010328c:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103291:	50                   	push   %eax
f0103292:	e8 f2 32 00 00       	call   f0106589 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0103297:	6a 02                	push   $0x2
f0103299:	68 00 10 00 00       	push   $0x1000
f010329e:	57                   	push   %edi
f010329f:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01032a5:	e8 e2 e4 ff ff       	call   f010178c <page_insert>
	assert(pp1->pp_ref == 1);
f01032aa:	83 c4 20             	add    $0x20,%esp
f01032ad:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f01032b2:	0f 85 82 01 00 00    	jne    f010343a <mem_init+0x1b84>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01032b8:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f01032bf:	01 01 01 
f01032c2:	0f 85 8b 01 00 00    	jne    f0103453 <mem_init+0x1b9d>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f01032c8:	6a 02                	push   $0x2
f01032ca:	68 00 10 00 00       	push   $0x1000
f01032cf:	53                   	push   %ebx
f01032d0:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f01032d6:	e8 b1 e4 ff ff       	call   f010178c <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01032db:	83 c4 10             	add    $0x10,%esp
f01032de:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f01032e5:	02 02 02 
f01032e8:	0f 85 7e 01 00 00    	jne    f010346c <mem_init+0x1bb6>
	assert(pp2->pp_ref == 1);
f01032ee:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01032f3:	0f 85 8c 01 00 00    	jne    f0103485 <mem_init+0x1bcf>
	assert(pp1->pp_ref == 0);
f01032f9:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01032fe:	0f 85 9a 01 00 00    	jne    f010349e <mem_init+0x1be8>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103304:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f010330b:	03 03 03 
	return (pp - pages) << PGSHIFT;
f010330e:	89 d8                	mov    %ebx,%eax
f0103310:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f0103316:	c1 f8 03             	sar    $0x3,%eax
f0103319:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010331c:	89 c2                	mov    %eax,%edx
f010331e:	c1 ea 0c             	shr    $0xc,%edx
f0103321:	3b 15 88 6e 35 f0    	cmp    0xf0356e88,%edx
f0103327:	0f 83 8a 01 00 00    	jae    f01034b7 <mem_init+0x1c01>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010332d:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0103334:	03 03 03 
f0103337:	0f 85 8c 01 00 00    	jne    f01034c9 <mem_init+0x1c13>
	page_remove(kern_pgdir, (void*) PGSIZE);
f010333d:	83 ec 08             	sub    $0x8,%esp
f0103340:	68 00 10 00 00       	push   $0x1000
f0103345:	ff 35 8c 6e 35 f0    	pushl  0xf0356e8c
f010334b:	e8 db e3 ff ff       	call   f010172b <page_remove>
	assert(pp2->pp_ref == 0);
f0103350:	83 c4 10             	add    $0x10,%esp
f0103353:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103358:	0f 85 84 01 00 00    	jne    f01034e2 <mem_init+0x1c2c>

	
	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010335e:	8b 0d 8c 6e 35 f0    	mov    0xf0356e8c,%ecx
f0103364:	8b 11                	mov    (%ecx),%edx
f0103366:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f010336c:	89 f0                	mov    %esi,%eax
f010336e:	2b 05 90 6e 35 f0    	sub    0xf0356e90,%eax
f0103374:	c1 f8 03             	sar    $0x3,%eax
f0103377:	c1 e0 0c             	shl    $0xc,%eax
f010337a:	39 c2                	cmp    %eax,%edx
f010337c:	0f 85 79 01 00 00    	jne    f01034fb <mem_init+0x1c45>
	kern_pgdir[0] = 0;
f0103382:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0103388:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010338d:	0f 85 81 01 00 00    	jne    f0103514 <mem_init+0x1c5e>
	pp0->pp_ref = 0;
f0103393:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0103399:	83 ec 0c             	sub    $0xc,%esp
f010339c:	56                   	push   %esi
f010339d:	e8 ab e0 ff ff       	call   f010144d <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f01033a2:	c7 04 24 40 84 10 f0 	movl   $0xf0108440,(%esp)
f01033a9:	e8 10 0b 00 00       	call   f0103ebe <cprintf>
}
f01033ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01033b1:	5b                   	pop    %ebx
f01033b2:	5e                   	pop    %esi
f01033b3:	5f                   	pop    %edi
f01033b4:	5d                   	pop    %ebp
f01033b5:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033b6:	50                   	push   %eax
f01033b7:	68 28 72 10 f0       	push   $0xf0107228
f01033bc:	68 fa 00 00 00       	push   $0xfa
f01033c1:	68 a1 84 10 f0       	push   $0xf01084a1
f01033c6:	e8 75 cc ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01033cb:	68 b4 85 10 f0       	push   $0xf01085b4
f01033d0:	68 c7 84 10 f0       	push   $0xf01084c7
f01033d5:	68 a7 04 00 00       	push   $0x4a7
f01033da:	68 a1 84 10 f0       	push   $0xf01084a1
f01033df:	e8 5c cc ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01033e4:	68 ca 85 10 f0       	push   $0xf01085ca
f01033e9:	68 c7 84 10 f0       	push   $0xf01084c7
f01033ee:	68 a8 04 00 00       	push   $0x4a8
f01033f3:	68 a1 84 10 f0       	push   $0xf01084a1
f01033f8:	e8 43 cc ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01033fd:	68 e0 85 10 f0       	push   $0xf01085e0
f0103402:	68 c7 84 10 f0       	push   $0xf01084c7
f0103407:	68 a9 04 00 00       	push   $0x4a9
f010340c:	68 a1 84 10 f0       	push   $0xf01084a1
f0103411:	e8 2a cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103416:	50                   	push   %eax
f0103417:	68 04 72 10 f0       	push   $0xf0107204
f010341c:	6a 58                	push   $0x58
f010341e:	68 ad 84 10 f0       	push   $0xf01084ad
f0103423:	e8 18 cc ff ff       	call   f0100040 <_panic>
f0103428:	50                   	push   %eax
f0103429:	68 04 72 10 f0       	push   $0xf0107204
f010342e:	6a 58                	push   $0x58
f0103430:	68 ad 84 10 f0       	push   $0xf01084ad
f0103435:	e8 06 cc ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f010343a:	68 b1 86 10 f0       	push   $0xf01086b1
f010343f:	68 c7 84 10 f0       	push   $0xf01084c7
f0103444:	68 ae 04 00 00       	push   $0x4ae
f0103449:	68 a1 84 10 f0       	push   $0xf01084a1
f010344e:	e8 ed cb ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103453:	68 cc 83 10 f0       	push   $0xf01083cc
f0103458:	68 c7 84 10 f0       	push   $0xf01084c7
f010345d:	68 af 04 00 00       	push   $0x4af
f0103462:	68 a1 84 10 f0       	push   $0xf01084a1
f0103467:	e8 d4 cb ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f010346c:	68 f0 83 10 f0       	push   $0xf01083f0
f0103471:	68 c7 84 10 f0       	push   $0xf01084c7
f0103476:	68 b1 04 00 00       	push   $0x4b1
f010347b:	68 a1 84 10 f0       	push   $0xf01084a1
f0103480:	e8 bb cb ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0103485:	68 d3 86 10 f0       	push   $0xf01086d3
f010348a:	68 c7 84 10 f0       	push   $0xf01084c7
f010348f:	68 b2 04 00 00       	push   $0x4b2
f0103494:	68 a1 84 10 f0       	push   $0xf01084a1
f0103499:	e8 a2 cb ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f010349e:	68 3d 87 10 f0       	push   $0xf010873d
f01034a3:	68 c7 84 10 f0       	push   $0xf01084c7
f01034a8:	68 b3 04 00 00       	push   $0x4b3
f01034ad:	68 a1 84 10 f0       	push   $0xf01084a1
f01034b2:	e8 89 cb ff ff       	call   f0100040 <_panic>
f01034b7:	50                   	push   %eax
f01034b8:	68 04 72 10 f0       	push   $0xf0107204
f01034bd:	6a 58                	push   $0x58
f01034bf:	68 ad 84 10 f0       	push   $0xf01084ad
f01034c4:	e8 77 cb ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01034c9:	68 14 84 10 f0       	push   $0xf0108414
f01034ce:	68 c7 84 10 f0       	push   $0xf01084c7
f01034d3:	68 b5 04 00 00       	push   $0x4b5
f01034d8:	68 a1 84 10 f0       	push   $0xf01084a1
f01034dd:	e8 5e cb ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01034e2:	68 0b 87 10 f0       	push   $0xf010870b
f01034e7:	68 c7 84 10 f0       	push   $0xf01084c7
f01034ec:	68 b7 04 00 00       	push   $0x4b7
f01034f1:	68 a1 84 10 f0       	push   $0xf01084a1
f01034f6:	e8 45 cb ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01034fb:	68 70 7d 10 f0       	push   $0xf0107d70
f0103500:	68 c7 84 10 f0       	push   $0xf01084c7
f0103505:	68 bb 04 00 00       	push   $0x4bb
f010350a:	68 a1 84 10 f0       	push   $0xf01084a1
f010350f:	e8 2c cb ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0103514:	68 c2 86 10 f0       	push   $0xf01086c2
f0103519:	68 c7 84 10 f0       	push   $0xf01084c7
f010351e:	68 bd 04 00 00       	push   $0x4bd
f0103523:	68 a1 84 10 f0       	push   $0xf01084a1
f0103528:	e8 13 cb ff ff       	call   f0100040 <_panic>

f010352d <user_mem_check>:
{
f010352d:	55                   	push   %ebp
f010352e:	89 e5                	mov    %esp,%ebp
f0103530:	57                   	push   %edi
f0103531:	56                   	push   %esi
f0103532:	53                   	push   %ebx
f0103533:	83 ec 0c             	sub    $0xc,%esp
f0103536:	8b 75 0c             	mov    0xc(%ebp),%esi
	uintptr_t va_ptr = (uintptr_t)va;	//(void*)ROUNDDOWN((uintptr_t)va, PGSIZE);
f0103539:	89 f3                	mov    %esi,%ebx
	uintptr_t end  = (uintptr_t) va + len;
f010353b:	03 75 10             	add    0x10(%ebp),%esi
	perm |= PTE_P;
f010353e:	8b 7d 14             	mov    0x14(%ebp),%edi
f0103541:	83 cf 01             	or     $0x1,%edi
	for (;va_ptr < end; va_ptr = ROUNDDOWN(va_ptr+PGSIZE, PGSIZE)) {
f0103544:	eb 19                	jmp    f010355f <user_mem_check+0x32>
			user_mem_check_addr = va_ptr;
f0103546:	89 1d 3c 62 35 f0    	mov    %ebx,0xf035623c
			return -E_FAULT;
f010354c:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103551:	eb 3f                	jmp    f0103592 <user_mem_check+0x65>
	for (;va_ptr < end; va_ptr = ROUNDDOWN(va_ptr+PGSIZE, PGSIZE)) {
f0103553:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103559:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f010355f:	39 f3                	cmp    %esi,%ebx
f0103561:	73 37                	jae    f010359a <user_mem_check+0x6d>
		if (va_ptr >= ULIM) {
f0103563:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0103569:	77 db                	ja     f0103546 <user_mem_check+0x19>
		pte_t * pte = pgdir_walk (env->env_pgdir, (void*)va_ptr, 0);
f010356b:	83 ec 04             	sub    $0x4,%esp
f010356e:	6a 00                	push   $0x0
f0103570:	53                   	push   %ebx
f0103571:	8b 45 08             	mov    0x8(%ebp),%eax
f0103574:	ff 70 64             	pushl  0x64(%eax)
f0103577:	e8 69 df ff ff       	call   f01014e5 <pgdir_walk>
		if ( !pte || !(*pte & perm)) {
f010357c:	83 c4 10             	add    $0x10,%esp
f010357f:	85 c0                	test   %eax,%eax
f0103581:	74 04                	je     f0103587 <user_mem_check+0x5a>
f0103583:	85 38                	test   %edi,(%eax)
f0103585:	75 cc                	jne    f0103553 <user_mem_check+0x26>
			user_mem_check_addr = (uintptr_t) va_ptr;
f0103587:	89 1d 3c 62 35 f0    	mov    %ebx,0xf035623c
			return -E_FAULT;
f010358d:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0103592:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103595:	5b                   	pop    %ebx
f0103596:	5e                   	pop    %esi
f0103597:	5f                   	pop    %edi
f0103598:	5d                   	pop    %ebp
f0103599:	c3                   	ret    
	return 0;
f010359a:	b8 00 00 00 00       	mov    $0x0,%eax
f010359f:	eb f1                	jmp    f0103592 <user_mem_check+0x65>

f01035a1 <user_mem_assert>:
{
f01035a1:	55                   	push   %ebp
f01035a2:	89 e5                	mov    %esp,%ebp
f01035a4:	53                   	push   %ebx
f01035a5:	83 ec 04             	sub    $0x4,%esp
f01035a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f01035ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01035ae:	83 c8 04             	or     $0x4,%eax
f01035b1:	50                   	push   %eax
f01035b2:	ff 75 10             	pushl  0x10(%ebp)
f01035b5:	ff 75 0c             	pushl  0xc(%ebp)
f01035b8:	53                   	push   %ebx
f01035b9:	e8 6f ff ff ff       	call   f010352d <user_mem_check>
f01035be:	83 c4 10             	add    $0x10,%esp
f01035c1:	85 c0                	test   %eax,%eax
f01035c3:	78 05                	js     f01035ca <user_mem_assert+0x29>
}
f01035c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01035c8:	c9                   	leave  
f01035c9:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f01035ca:	83 ec 04             	sub    $0x4,%esp
f01035cd:	ff 35 3c 62 35 f0    	pushl  0xf035623c
f01035d3:	ff 73 48             	pushl  0x48(%ebx)
f01035d6:	68 6c 84 10 f0       	push   $0xf010846c
f01035db:	e8 de 08 00 00       	call   f0103ebe <cprintf>
		env_destroy(env);	// may not return
f01035e0:	89 1c 24             	mov    %ebx,(%esp)
f01035e3:	e8 f5 05 00 00       	call   f0103bdd <env_destroy>
f01035e8:	83 c4 10             	add    $0x10,%esp
}
f01035eb:	eb d8                	jmp    f01035c5 <user_mem_assert+0x24>

f01035ed <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f01035ed:	55                   	push   %ebp
f01035ee:	89 e5                	mov    %esp,%ebp
f01035f0:	57                   	push   %edi
f01035f1:	56                   	push   %esi
f01035f2:	53                   	push   %ebx
f01035f3:	83 ec 1c             	sub    $0x1c,%esp
f01035f6:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	va = ROUNDDOWN(va, PGSIZE);	
f01035f8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01035fe:	89 d3                	mov    %edx,%ebx
	int n = (ROUNDUP(va+len, PGSIZE) - va) / PGSIZE;
f0103600:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f0103607:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010360c:	29 d0                	sub    %edx,%eax
f010360e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0103614:	0f 48 c2             	cmovs  %edx,%eax
f0103617:	c1 f8 0c             	sar    $0xc,%eax
f010361a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for(int i=0;i<n;i++){
f010361d:	be 00 00 00 00       	mov    $0x0,%esi
f0103622:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f0103625:	7d 42                	jge    f0103669 <region_alloc+0x7c>
		struct PageInfo* pp = page_alloc(ALLOC_ZERO);
f0103627:	83 ec 0c             	sub    $0xc,%esp
f010362a:	6a 01                	push   $0x1
f010362c:	e8 aa dd ff ff       	call   f01013db <page_alloc>
		if(!pp)
f0103631:	83 c4 10             	add    $0x10,%esp
f0103634:	85 c0                	test   %eax,%eax
f0103636:	74 1a                	je     f0103652 <region_alloc+0x65>
			panic("region_alloc: pp is NULL!");
		page_insert(e->env_pgdir, pp, va, PTE_U|PTE_W);
f0103638:	6a 06                	push   $0x6
f010363a:	53                   	push   %ebx
f010363b:	50                   	push   %eax
f010363c:	ff 77 64             	pushl  0x64(%edi)
f010363f:	e8 48 e1 ff ff       	call   f010178c <page_insert>
		va += PGSIZE;
f0103644:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for(int i=0;i<n;i++){
f010364a:	83 c6 01             	add    $0x1,%esi
f010364d:	83 c4 10             	add    $0x10,%esp
f0103650:	eb d0                	jmp    f0103622 <region_alloc+0x35>
			panic("region_alloc: pp is NULL!");
f0103652:	83 ec 04             	sub    $0x4,%esp
f0103655:	68 ef 87 10 f0       	push   $0xf01087ef
f010365a:	68 2e 01 00 00       	push   $0x12e
f010365f:	68 09 88 10 f0       	push   $0xf0108809
f0103664:	e8 d7 c9 ff ff       	call   f0100040 <_panic>
	}
}
f0103669:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010366c:	5b                   	pop    %ebx
f010366d:	5e                   	pop    %esi
f010366e:	5f                   	pop    %edi
f010366f:	5d                   	pop    %ebp
f0103670:	c3                   	ret    

f0103671 <envid2env>:
{
f0103671:	55                   	push   %ebp
f0103672:	89 e5                	mov    %esp,%ebp
f0103674:	56                   	push   %esi
f0103675:	53                   	push   %ebx
f0103676:	8b 75 08             	mov    0x8(%ebp),%esi
f0103679:	8b 55 10             	mov    0x10(%ebp),%edx
	if (envid == 0) {
f010367c:	85 f6                	test   %esi,%esi
f010367e:	74 30                	je     f01036b0 <envid2env+0x3f>
	e = &envs[ENVX(envid)];
f0103680:	89 f0                	mov    %esi,%eax
f0103682:	25 ff 03 00 00       	and    $0x3ff,%eax
f0103687:	8d 1c c0             	lea    (%eax,%eax,8),%ebx
f010368a:	c1 e3 04             	shl    $0x4,%ebx
f010368d:	03 1d 48 62 35 f0    	add    0xf0356248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103693:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103697:	74 2e                	je     f01036c7 <envid2env+0x56>
f0103699:	39 73 48             	cmp    %esi,0x48(%ebx)
f010369c:	75 29                	jne    f01036c7 <envid2env+0x56>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010369e:	84 d2                	test   %dl,%dl
f01036a0:	75 35                	jne    f01036d7 <envid2env+0x66>
	*env_store = e;
f01036a2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036a5:	89 18                	mov    %ebx,(%eax)
	return 0;
f01036a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01036ac:	5b                   	pop    %ebx
f01036ad:	5e                   	pop    %esi
f01036ae:	5d                   	pop    %ebp
f01036af:	c3                   	ret    
		*env_store = curenv;
f01036b0:	e8 d5 34 00 00       	call   f0106b8a <cpunum>
f01036b5:	6b c0 74             	imul   $0x74,%eax,%eax
f01036b8:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01036be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01036c1:	89 01                	mov    %eax,(%ecx)
		return 0;
f01036c3:	89 f0                	mov    %esi,%eax
f01036c5:	eb e5                	jmp    f01036ac <envid2env+0x3b>
		*env_store = 0;
f01036c7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01036d0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01036d5:	eb d5                	jmp    f01036ac <envid2env+0x3b>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01036d7:	e8 ae 34 00 00       	call   f0106b8a <cpunum>
f01036dc:	6b c0 74             	imul   $0x74,%eax,%eax
f01036df:	39 98 28 70 35 f0    	cmp    %ebx,-0xfca8fd8(%eax)
f01036e5:	74 bb                	je     f01036a2 <envid2env+0x31>
f01036e7:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01036ea:	e8 9b 34 00 00       	call   f0106b8a <cpunum>
f01036ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01036f2:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01036f8:	3b 70 48             	cmp    0x48(%eax),%esi
f01036fb:	74 a5                	je     f01036a2 <envid2env+0x31>
		*env_store = 0;
f01036fd:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103706:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010370b:	eb 9f                	jmp    f01036ac <envid2env+0x3b>

f010370d <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f010370d:	b8 20 53 12 f0       	mov    $0xf0125320,%eax
f0103712:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103715:	b8 23 00 00 00       	mov    $0x23,%eax
f010371a:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f010371c:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f010371e:	b8 10 00 00 00       	mov    $0x10,%eax
f0103723:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103725:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103727:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103729:	ea 30 37 10 f0 08 00 	ljmp   $0x8,$0xf0103730
	asm volatile("lldt %0" : : "r" (sel));
f0103730:	b8 00 00 00 00       	mov    $0x0,%eax
f0103735:	0f 00 d0             	lldt   %ax
}
f0103738:	c3                   	ret    

f0103739 <env_init>:
{
f0103739:	55                   	push   %ebp
f010373a:	89 e5                	mov    %esp,%ebp
f010373c:	56                   	push   %esi
f010373d:	53                   	push   %ebx
		envs[i].env_id = 0;
f010373e:	8b 35 48 62 35 f0    	mov    0xf0356248,%esi
f0103744:	8d 86 70 3f 02 00    	lea    0x23f70(%esi),%eax
f010374a:	89 f3                	mov    %esi,%ebx
f010374c:	ba 00 00 00 00       	mov    $0x0,%edx
f0103751:	eb 02                	jmp    f0103755 <env_init+0x1c>
f0103753:	89 c8                	mov    %ecx,%eax
f0103755:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_status = ENV_FREE;
f010375c:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
		envs[i].env_link = env_free_list;
f0103763:	89 50 44             	mov    %edx,0x44(%eax)
f0103766:	8d 88 70 ff ff ff    	lea    -0x90(%eax),%ecx
		env_free_list = &envs[i];			
f010376c:	89 c2                	mov    %eax,%edx
	for (int i=NENV-1; i>=0; i--){
f010376e:	39 d8                	cmp    %ebx,%eax
f0103770:	75 e1                	jne    f0103753 <env_init+0x1a>
f0103772:	89 35 4c 62 35 f0    	mov    %esi,0xf035624c
	env_init_percpu();
f0103778:	e8 90 ff ff ff       	call   f010370d <env_init_percpu>
}
f010377d:	5b                   	pop    %ebx
f010377e:	5e                   	pop    %esi
f010377f:	5d                   	pop    %ebp
f0103780:	c3                   	ret    

f0103781 <env_alloc>:
{
f0103781:	55                   	push   %ebp
f0103782:	89 e5                	mov    %esp,%ebp
f0103784:	53                   	push   %ebx
f0103785:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103788:	8b 1d 4c 62 35 f0    	mov    0xf035624c,%ebx
f010378e:	85 db                	test   %ebx,%ebx
f0103790:	0f 84 48 01 00 00    	je     f01038de <env_alloc+0x15d>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103796:	83 ec 0c             	sub    $0xc,%esp
f0103799:	6a 01                	push   $0x1
f010379b:	e8 3b dc ff ff       	call   f01013db <page_alloc>
f01037a0:	83 c4 10             	add    $0x10,%esp
f01037a3:	85 c0                	test   %eax,%eax
f01037a5:	0f 84 3a 01 00 00    	je     f01038e5 <env_alloc+0x164>
	return (pp - pages) << PGSHIFT;
f01037ab:	89 c2                	mov    %eax,%edx
f01037ad:	2b 15 90 6e 35 f0    	sub    0xf0356e90,%edx
f01037b3:	c1 fa 03             	sar    $0x3,%edx
f01037b6:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01037b9:	89 d1                	mov    %edx,%ecx
f01037bb:	c1 e9 0c             	shr    $0xc,%ecx
f01037be:	3b 0d 88 6e 35 f0    	cmp    0xf0356e88,%ecx
f01037c4:	0f 83 ed 00 00 00    	jae    f01038b7 <env_alloc+0x136>
	return (void *)(pa + KERNBASE);
f01037ca:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01037d0:	89 53 64             	mov    %edx,0x64(%ebx)
	p->pp_ref += 1;
f01037d3:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	memcpy(&e->env_pgdir[begin],&kern_pgdir[begin], size);
f01037d8:	83 ec 04             	sub    $0x4,%esp
f01037db:	68 14 01 00 00       	push   $0x114
f01037e0:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
f01037e5:	05 ec 0e 00 00       	add    $0xeec,%eax
f01037ea:	50                   	push   %eax
f01037eb:	8b 43 64             	mov    0x64(%ebx),%eax
f01037ee:	05 ec 0e 00 00       	add    $0xeec,%eax
f01037f3:	50                   	push   %eax
f01037f4:	e8 3a 2e 00 00       	call   f0106633 <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01037f9:	8b 43 64             	mov    0x64(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01037fc:	83 c4 10             	add    $0x10,%esp
f01037ff:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103804:	0f 86 bf 00 00 00    	jbe    f01038c9 <env_alloc+0x148>
	return (physaddr_t)kva - KERNBASE;
f010380a:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103810:	83 ca 05             	or     $0x5,%edx
f0103813:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103819:	8b 43 48             	mov    0x48(%ebx),%eax
f010381c:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103821:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103826:	ba 00 10 00 00       	mov    $0x1000,%edx
f010382b:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f010382e:	89 da                	mov    %ebx,%edx
f0103830:	2b 15 48 62 35 f0    	sub    0xf0356248,%edx
f0103836:	c1 fa 04             	sar    $0x4,%edx
f0103839:	69 d2 39 8e e3 38    	imul   $0x38e38e39,%edx,%edx
f010383f:	09 d0                	or     %edx,%eax
f0103841:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f0103844:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103847:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f010384a:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103851:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103858:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f010385f:	83 ec 04             	sub    $0x4,%esp
f0103862:	6a 44                	push   $0x44
f0103864:	6a 00                	push   $0x0
f0103866:	53                   	push   %ebx
f0103867:	e8 1d 2d 00 00       	call   f0106589 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f010386c:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103872:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103878:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f010387e:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103885:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f010388b:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103892:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
	e->env_ipc_recving = 0;
f0103899:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
	env_free_list = e->env_link;
f010389d:	8b 43 44             	mov    0x44(%ebx),%eax
f01038a0:	a3 4c 62 35 f0       	mov    %eax,0xf035624c
	*newenv_store = e;
f01038a5:	8b 45 08             	mov    0x8(%ebp),%eax
f01038a8:	89 18                	mov    %ebx,(%eax)
	return 0;
f01038aa:	83 c4 10             	add    $0x10,%esp
f01038ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01038b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01038b5:	c9                   	leave  
f01038b6:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01038b7:	52                   	push   %edx
f01038b8:	68 04 72 10 f0       	push   $0xf0107204
f01038bd:	6a 58                	push   $0x58
f01038bf:	68 ad 84 10 f0       	push   $0xf01084ad
f01038c4:	e8 77 c7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038c9:	50                   	push   %eax
f01038ca:	68 28 72 10 f0       	push   $0xf0107228
f01038cf:	68 ca 00 00 00       	push   $0xca
f01038d4:	68 09 88 10 f0       	push   $0xf0108809
f01038d9:	e8 62 c7 ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f01038de:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01038e3:	eb cd                	jmp    f01038b2 <env_alloc+0x131>
		return -E_NO_MEM;
f01038e5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01038ea:	eb c6                	jmp    f01038b2 <env_alloc+0x131>

f01038ec <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f01038ec:	55                   	push   %ebp
f01038ed:	89 e5                	mov    %esp,%ebp
f01038ef:	57                   	push   %edi
f01038f0:	56                   	push   %esi
f01038f1:	53                   	push   %ebx
f01038f2:	83 ec 34             	sub    $0x34,%esp
f01038f5:	8b 75 08             	mov    0x8(%ebp),%esi
f01038f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.

	struct Env *e;

	// Allocates a new env
	int r = env_alloc(&e, 0);
f01038fb:	6a 00                	push   $0x0
f01038fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103900:	50                   	push   %eax
f0103901:	e8 7b fe ff ff       	call   f0103781 <env_alloc>
	if(r != 0)
f0103906:	83 c4 10             	add    $0x10,%esp
f0103909:	85 c0                	test   %eax,%eax
f010390b:	75 3d                	jne    f010394a <env_create+0x5e>
		panic("env_create: %e", r);

	// sets its env_type
	e->env_type = type;
f010390d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103910:	89 5f 50             	mov    %ebx,0x50(%edi)

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if (type == ENV_TYPE_FS){
f0103913:	83 fb 01             	cmp    $0x1,%ebx
f0103916:	74 47                	je     f010395f <env_create+0x73>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
	}

	// loads the named elf binary into it
	lcr3(PADDR(e->env_pgdir));
f0103918:	8b 47 64             	mov    0x64(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f010391b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103920:	76 46                	jbe    f0103968 <env_create+0x7c>
	return (physaddr_t)kva - KERNBASE;
f0103922:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103927:	0f 22 d8             	mov    %eax,%cr3
	if (ELFHDR->e_magic != ELF_MAGIC)
f010392a:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
f0103930:	75 4b                	jne    f010397d <env_create+0x91>
	ph = (struct Proghdr *) (binary + ELFHDR->e_phoff);
f0103932:	89 f3                	mov    %esi,%ebx
f0103934:	03 5e 1c             	add    0x1c(%esi),%ebx
	eph = ph + ELFHDR->e_phnum;
f0103937:	0f b7 46 2c          	movzwl 0x2c(%esi),%eax
f010393b:	c1 e0 05             	shl    $0x5,%eax
f010393e:	01 d8                	add    %ebx,%eax
f0103940:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0103943:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0103946:	89 f7                	mov    %esi,%edi
f0103948:	eb 4d                	jmp    f0103997 <env_create+0xab>
		panic("env_create: %e", r);
f010394a:	50                   	push   %eax
f010394b:	68 14 88 10 f0       	push   $0xf0108814
f0103950:	68 9c 01 00 00       	push   $0x19c
f0103955:	68 09 88 10 f0       	push   $0xf0108809
f010395a:	e8 e1 c6 ff ff       	call   f0100040 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f010395f:	81 4f 38 00 30 00 00 	orl    $0x3000,0x38(%edi)
f0103966:	eb b0                	jmp    f0103918 <env_create+0x2c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103968:	50                   	push   %eax
f0103969:	68 28 72 10 f0       	push   $0xf0107228
f010396e:	68 a8 01 00 00       	push   $0x1a8
f0103973:	68 09 88 10 f0       	push   $0xf0108809
f0103978:	e8 c3 c6 ff ff       	call   f0100040 <_panic>
		panic("load icode:\tinvalid binary file!");
f010397d:	83 ec 04             	sub    $0x4,%esp
f0103980:	68 30 88 10 f0       	push   $0xf0108830
f0103985:	68 6f 01 00 00       	push   $0x16f
f010398a:	68 09 88 10 f0       	push   $0xf0108809
f010398f:	e8 ac c6 ff ff       	call   f0100040 <_panic>
	for (; ph < eph; ph++){
f0103994:	83 c3 20             	add    $0x20,%ebx
f0103997:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f010399a:	76 3f                	jbe    f01039db <env_create+0xef>
		if(ph->p_type != ELF_PROG_LOAD)
f010399c:	83 3b 01             	cmpl   $0x1,(%ebx)
f010399f:	75 f3                	jne    f0103994 <env_create+0xa8>
		void* va = (void*)(ph->p_va);
f01039a1:	8b 73 08             	mov    0x8(%ebx),%esi
		void* pa = (void*)(binary+ph->p_offset);
f01039a4:	89 f8                	mov    %edi,%eax
f01039a6:	03 43 04             	add    0x4(%ebx),%eax
f01039a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		region_alloc(e, va, ph->p_memsz);
f01039ac:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01039af:	89 f2                	mov    %esi,%edx
f01039b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01039b4:	e8 34 fc ff ff       	call   f01035ed <region_alloc>
		memset(va, 0, ph->p_memsz);
f01039b9:	83 ec 04             	sub    $0x4,%esp
f01039bc:	ff 73 14             	pushl  0x14(%ebx)
f01039bf:	6a 00                	push   $0x0
f01039c1:	56                   	push   %esi
f01039c2:	e8 c2 2b 00 00       	call   f0106589 <memset>
		memmove(va, pa, ph->p_filesz);	
f01039c7:	83 c4 0c             	add    $0xc,%esp
f01039ca:	ff 73 10             	pushl  0x10(%ebx)
f01039cd:	ff 75 d0             	pushl  -0x30(%ebp)
f01039d0:	56                   	push   %esi
f01039d1:	e8 fb 2b 00 00       	call   f01065d1 <memmove>
f01039d6:	83 c4 10             	add    $0x10,%esp
f01039d9:	eb b9                	jmp    f0103994 <env_create+0xa8>
f01039db:	89 fe                	mov    %edi,%esi
f01039dd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	e->env_tf.tf_eip = ELFHDR->e_entry;	
f01039e0:	8b 46 18             	mov    0x18(%esi),%eax
f01039e3:	89 47 30             	mov    %eax,0x30(%edi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f01039e6:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01039eb:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01039f0:	89 f8                	mov    %edi,%eax
f01039f2:	e8 f6 fb ff ff       	call   f01035ed <region_alloc>
	e->env_brk = (uintptr_t)ROUNDDOWN(USTACKTOP-PGSIZE, PGSIZE);
f01039f7:	c7 47 5c 00 d0 bf ee 	movl   $0xeebfd000,0x5c(%edi)
	load_icode(e, binary);
	lcr3(PADDR(kern_pgdir));	
f01039fe:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103a03:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103a08:	76 10                	jbe    f0103a1a <env_create+0x12e>
	return (physaddr_t)kva - KERNBASE;
f0103a0a:	05 00 00 00 10       	add    $0x10000000,%eax
f0103a0f:	0f 22 d8             	mov    %eax,%cr3
}
f0103a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103a15:	5b                   	pop    %ebx
f0103a16:	5e                   	pop    %esi
f0103a17:	5f                   	pop    %edi
f0103a18:	5d                   	pop    %ebp
f0103a19:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103a1a:	50                   	push   %eax
f0103a1b:	68 28 72 10 f0       	push   $0xf0107228
f0103a20:	68 aa 01 00 00       	push   $0x1aa
f0103a25:	68 09 88 10 f0       	push   $0xf0108809
f0103a2a:	e8 11 c6 ff ff       	call   f0100040 <_panic>

f0103a2f <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103a2f:	55                   	push   %ebp
f0103a30:	89 e5                	mov    %esp,%ebp
f0103a32:	57                   	push   %edi
f0103a33:	56                   	push   %esi
f0103a34:	53                   	push   %ebx
f0103a35:	83 ec 1c             	sub    $0x1c,%esp
f0103a38:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103a3b:	e8 4a 31 00 00       	call   f0106b8a <cpunum>
f0103a40:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103a4a:	39 b8 28 70 35 f0    	cmp    %edi,-0xfca8fd8(%eax)
f0103a50:	0f 85 b3 00 00 00    	jne    f0103b09 <env_free+0xda>
		lcr3(PADDR(kern_pgdir));
f0103a56:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103a5b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103a60:	76 14                	jbe    f0103a76 <env_free+0x47>
	return (physaddr_t)kva - KERNBASE;
f0103a62:	05 00 00 00 10       	add    $0x10000000,%eax
f0103a67:	0f 22 d8             	mov    %eax,%cr3
f0103a6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103a71:	e9 93 00 00 00       	jmp    f0103b09 <env_free+0xda>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103a76:	50                   	push   %eax
f0103a77:	68 28 72 10 f0       	push   $0xf0107228
f0103a7c:	68 bb 01 00 00       	push   $0x1bb
f0103a81:	68 09 88 10 f0       	push   $0xf0108809
f0103a86:	e8 b5 c5 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103a8b:	56                   	push   %esi
f0103a8c:	68 04 72 10 f0       	push   $0xf0107204
f0103a91:	68 ca 01 00 00       	push   $0x1ca
f0103a96:	68 09 88 10 f0       	push   $0xf0108809
f0103a9b:	e8 a0 c5 ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103aa0:	83 ec 08             	sub    $0x8,%esp
f0103aa3:	89 d8                	mov    %ebx,%eax
f0103aa5:	c1 e0 0c             	shl    $0xc,%eax
f0103aa8:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103aab:	50                   	push   %eax
f0103aac:	ff 77 64             	pushl  0x64(%edi)
f0103aaf:	e8 77 dc ff ff       	call   f010172b <page_remove>
f0103ab4:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103ab7:	83 c3 01             	add    $0x1,%ebx
f0103aba:	83 c6 04             	add    $0x4,%esi
f0103abd:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103ac3:	74 07                	je     f0103acc <env_free+0x9d>
			if (pt[pteno] & PTE_P)
f0103ac5:	f6 06 01             	testb  $0x1,(%esi)
f0103ac8:	74 ed                	je     f0103ab7 <env_free+0x88>
f0103aca:	eb d4                	jmp    f0103aa0 <env_free+0x71>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103acc:	8b 47 64             	mov    0x64(%edi),%eax
f0103acf:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103ad2:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103ad9:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103adc:	3b 05 88 6e 35 f0    	cmp    0xf0356e88,%eax
f0103ae2:	73 69                	jae    f0103b4d <env_free+0x11e>
		page_decref(pa2page(pa));
f0103ae4:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103ae7:	a1 90 6e 35 f0       	mov    0xf0356e90,%eax
f0103aec:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103aef:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103af2:	50                   	push   %eax
f0103af3:	e8 c4 d9 ff ff       	call   f01014bc <page_decref>
f0103af8:	83 c4 10             	add    $0x10,%esp
f0103afb:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103b02:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103b07:	74 58                	je     f0103b61 <env_free+0x132>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103b09:	8b 47 64             	mov    0x64(%edi),%eax
f0103b0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103b0f:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103b12:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103b18:	74 e1                	je     f0103afb <env_free+0xcc>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103b1a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103b20:	89 f0                	mov    %esi,%eax
f0103b22:	c1 e8 0c             	shr    $0xc,%eax
f0103b25:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103b28:	39 05 88 6e 35 f0    	cmp    %eax,0xf0356e88
f0103b2e:	0f 86 57 ff ff ff    	jbe    f0103a8b <env_free+0x5c>
	return (void *)(pa + KERNBASE);
f0103b34:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103b3d:	c1 e0 14             	shl    $0x14,%eax
f0103b40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103b43:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103b48:	e9 78 ff ff ff       	jmp    f0103ac5 <env_free+0x96>
		panic("pa2page called with invalid pa");
f0103b4d:	83 ec 04             	sub    $0x4,%esp
f0103b50:	68 d4 7b 10 f0       	push   $0xf0107bd4
f0103b55:	6a 51                	push   $0x51
f0103b57:	68 ad 84 10 f0       	push   $0xf01084ad
f0103b5c:	e8 df c4 ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103b61:	8b 47 64             	mov    0x64(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103b64:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103b69:	76 49                	jbe    f0103bb4 <env_free+0x185>
	e->env_pgdir = 0;
f0103b6b:	c7 47 64 00 00 00 00 	movl   $0x0,0x64(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103b72:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103b77:	c1 e8 0c             	shr    $0xc,%eax
f0103b7a:	3b 05 88 6e 35 f0    	cmp    0xf0356e88,%eax
f0103b80:	73 47                	jae    f0103bc9 <env_free+0x19a>
	page_decref(pa2page(pa));
f0103b82:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103b85:	8b 15 90 6e 35 f0    	mov    0xf0356e90,%edx
f0103b8b:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103b8e:	50                   	push   %eax
f0103b8f:	e8 28 d9 ff ff       	call   f01014bc <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103b94:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103b9b:	a1 4c 62 35 f0       	mov    0xf035624c,%eax
f0103ba0:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103ba3:	89 3d 4c 62 35 f0    	mov    %edi,0xf035624c
}
f0103ba9:	83 c4 10             	add    $0x10,%esp
f0103bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103baf:	5b                   	pop    %ebx
f0103bb0:	5e                   	pop    %esi
f0103bb1:	5f                   	pop    %edi
f0103bb2:	5d                   	pop    %ebp
f0103bb3:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103bb4:	50                   	push   %eax
f0103bb5:	68 28 72 10 f0       	push   $0xf0107228
f0103bba:	68 d8 01 00 00       	push   $0x1d8
f0103bbf:	68 09 88 10 f0       	push   $0xf0108809
f0103bc4:	e8 77 c4 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103bc9:	83 ec 04             	sub    $0x4,%esp
f0103bcc:	68 d4 7b 10 f0       	push   $0xf0107bd4
f0103bd1:	6a 51                	push   $0x51
f0103bd3:	68 ad 84 10 f0       	push   $0xf01084ad
f0103bd8:	e8 63 c4 ff ff       	call   f0100040 <_panic>

f0103bdd <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103bdd:	55                   	push   %ebp
f0103bde:	89 e5                	mov    %esp,%ebp
f0103be0:	53                   	push   %ebx
f0103be1:	83 ec 04             	sub    $0x4,%esp
f0103be4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103be7:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103beb:	74 21                	je     f0103c0e <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103bed:	83 ec 0c             	sub    $0xc,%esp
f0103bf0:	53                   	push   %ebx
f0103bf1:	e8 39 fe ff ff       	call   f0103a2f <env_free>

	if (curenv == e) {
f0103bf6:	e8 8f 2f 00 00       	call   f0106b8a <cpunum>
f0103bfb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bfe:	83 c4 10             	add    $0x10,%esp
f0103c01:	39 98 28 70 35 f0    	cmp    %ebx,-0xfca8fd8(%eax)
f0103c07:	74 1e                	je     f0103c27 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f0103c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103c0c:	c9                   	leave  
f0103c0d:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103c0e:	e8 77 2f 00 00       	call   f0106b8a <cpunum>
f0103c13:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c16:	39 98 28 70 35 f0    	cmp    %ebx,-0xfca8fd8(%eax)
f0103c1c:	74 cf                	je     f0103bed <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103c1e:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103c25:	eb e2                	jmp    f0103c09 <env_destroy+0x2c>
		curenv = NULL;
f0103c27:	e8 5e 2f 00 00       	call   f0106b8a <cpunum>
f0103c2c:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c2f:	c7 80 28 70 35 f0 00 	movl   $0x0,-0xfca8fd8(%eax)
f0103c36:	00 00 00 
		sched_yield();
f0103c39:	e8 59 11 00 00       	call   f0104d97 <sched_yield>

f0103c3e <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103c3e:	55                   	push   %ebp
f0103c3f:	89 e5                	mov    %esp,%ebp
f0103c41:	53                   	push   %ebx
f0103c42:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103c45:	e8 40 2f 00 00       	call   f0106b8a <cpunum>
f0103c4a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c4d:	8b 98 28 70 35 f0    	mov    -0xfca8fd8(%eax),%ebx
f0103c53:	e8 32 2f 00 00       	call   f0106b8a <cpunum>
f0103c58:	89 43 60             	mov    %eax,0x60(%ebx)

	asm volatile(
f0103c5b:	8b 65 08             	mov    0x8(%ebp),%esp
f0103c5e:	61                   	popa   
f0103c5f:	07                   	pop    %es
f0103c60:	1f                   	pop    %ds
f0103c61:	83 c4 08             	add    $0x8,%esp
f0103c64:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103c65:	83 ec 04             	sub    $0x4,%esp
f0103c68:	68 23 88 10 f0       	push   $0xf0108823
f0103c6d:	68 0f 02 00 00       	push   $0x20f
f0103c72:	68 09 88 10 f0       	push   $0xf0108809
f0103c77:	e8 c4 c3 ff ff       	call   f0100040 <_panic>

f0103c7c <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103c7c:	55                   	push   %ebp
f0103c7d:	89 e5                	mov    %esp,%ebp
f0103c7f:	53                   	push   %ebx
f0103c80:	83 ec 04             	sub    $0x4,%esp
f0103c83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	
	// Step 1:
	if(e != curenv) {
f0103c86:	e8 ff 2e 00 00       	call   f0106b8a <cpunum>
f0103c8b:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c8e:	39 98 28 70 35 f0    	cmp    %ebx,-0xfca8fd8(%eax)
f0103c94:	74 50                	je     f0103ce6 <env_run+0x6a>
		if(curenv && curenv->env_status == ENV_RUNNING)
f0103c96:	e8 ef 2e 00 00       	call   f0106b8a <cpunum>
f0103c9b:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c9e:	83 b8 28 70 35 f0 00 	cmpl   $0x0,-0xfca8fd8(%eax)
f0103ca5:	74 14                	je     f0103cbb <env_run+0x3f>
f0103ca7:	e8 de 2e 00 00       	call   f0106b8a <cpunum>
f0103cac:	6b c0 74             	imul   $0x74,%eax,%eax
f0103caf:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0103cb5:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103cb9:	74 42                	je     f0103cfd <env_run+0x81>
			curenv->env_status = ENV_RUNNABLE;
		
		curenv = e;	
f0103cbb:	e8 ca 2e 00 00       	call   f0106b8a <cpunum>
f0103cc0:	6b c0 74             	imul   $0x74,%eax,%eax
f0103cc3:	89 98 28 70 35 f0    	mov    %ebx,-0xfca8fd8(%eax)
		e->env_status = ENV_RUNNING;
f0103cc9:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
		e->env_runs += 1;
f0103cd0:	83 43 58 01          	addl   $0x1,0x58(%ebx)
		lcr3(PADDR(e->env_pgdir));
f0103cd4:	8b 43 64             	mov    0x64(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103cd7:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103cdc:	76 36                	jbe    f0103d14 <env_run+0x98>
	return (physaddr_t)kva - KERNBASE;
f0103cde:	05 00 00 00 10       	add    $0x10000000,%eax
f0103ce3:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103ce6:	83 ec 0c             	sub    $0xc,%esp
f0103ce9:	68 c0 53 12 f0       	push   $0xf01253c0
f0103cee:	e8 a3 31 00 00       	call   f0106e96 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103cf3:	f3 90                	pause  
	}
	
	// Step 2:
	//cprintf("env_run:\tid=%d\teip=[0x%08x]\n",ENVX(e->env_id), e->env_tf.tf_eip);
	unlock_kernel();
	env_pop_tf(&(e->env_tf));
f0103cf5:	89 1c 24             	mov    %ebx,(%esp)
f0103cf8:	e8 41 ff ff ff       	call   f0103c3e <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f0103cfd:	e8 88 2e 00 00       	call   f0106b8a <cpunum>
f0103d02:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d05:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0103d0b:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103d12:	eb a7                	jmp    f0103cbb <env_run+0x3f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103d14:	50                   	push   %eax
f0103d15:	68 28 72 10 f0       	push   $0xf0107228
f0103d1a:	68 36 02 00 00       	push   $0x236
f0103d1f:	68 09 88 10 f0       	push   $0xf0108809
f0103d24:	e8 17 c3 ff ff       	call   f0100040 <_panic>

f0103d29 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103d29:	55                   	push   %ebp
f0103d2a:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103d2c:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d2f:	ba 70 00 00 00       	mov    $0x70,%edx
f0103d34:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103d35:	ba 71 00 00 00       	mov    $0x71,%edx
f0103d3a:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103d3b:	0f b6 c0             	movzbl %al,%eax
}
f0103d3e:	5d                   	pop    %ebp
f0103d3f:	c3                   	ret    

f0103d40 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103d40:	55                   	push   %ebp
f0103d41:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103d43:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d46:	ba 70 00 00 00       	mov    $0x70,%edx
f0103d4b:	ee                   	out    %al,(%dx)
f0103d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103d4f:	ba 71 00 00 00       	mov    $0x71,%edx
f0103d54:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103d55:	5d                   	pop    %ebp
f0103d56:	c3                   	ret    

f0103d57 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103d57:	55                   	push   %ebp
f0103d58:	89 e5                	mov    %esp,%ebp
f0103d5a:	56                   	push   %esi
f0103d5b:	53                   	push   %ebx
f0103d5c:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103d5f:	66 a3 a8 53 12 f0    	mov    %ax,0xf01253a8
	if (!didinit)
f0103d65:	80 3d 50 62 35 f0 00 	cmpb   $0x0,0xf0356250
f0103d6c:	75 07                	jne    f0103d75 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103d6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103d71:	5b                   	pop    %ebx
f0103d72:	5e                   	pop    %esi
f0103d73:	5d                   	pop    %ebp
f0103d74:	c3                   	ret    
f0103d75:	89 c6                	mov    %eax,%esi
f0103d77:	ba 21 00 00 00       	mov    $0x21,%edx
f0103d7c:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103d7d:	66 c1 e8 08          	shr    $0x8,%ax
f0103d81:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103d86:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103d87:	83 ec 0c             	sub    $0xc,%esp
f0103d8a:	68 51 88 10 f0       	push   $0xf0108851
f0103d8f:	e8 2a 01 00 00       	call   f0103ebe <cprintf>
f0103d94:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103d97:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103d9c:	0f b7 f6             	movzwl %si,%esi
f0103d9f:	f7 d6                	not    %esi
f0103da1:	eb 19                	jmp    f0103dbc <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f0103da3:	83 ec 08             	sub    $0x8,%esp
f0103da6:	53                   	push   %ebx
f0103da7:	68 6f 8d 10 f0       	push   $0xf0108d6f
f0103dac:	e8 0d 01 00 00       	call   f0103ebe <cprintf>
f0103db1:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103db4:	83 c3 01             	add    $0x1,%ebx
f0103db7:	83 fb 10             	cmp    $0x10,%ebx
f0103dba:	74 07                	je     f0103dc3 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103dbc:	0f a3 de             	bt     %ebx,%esi
f0103dbf:	73 f3                	jae    f0103db4 <irq_setmask_8259A+0x5d>
f0103dc1:	eb e0                	jmp    f0103da3 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103dc3:	83 ec 0c             	sub    $0xc,%esp
f0103dc6:	68 a6 87 10 f0       	push   $0xf01087a6
f0103dcb:	e8 ee 00 00 00       	call   f0103ebe <cprintf>
f0103dd0:	83 c4 10             	add    $0x10,%esp
f0103dd3:	eb 99                	jmp    f0103d6e <irq_setmask_8259A+0x17>

f0103dd5 <pic_init>:
{
f0103dd5:	55                   	push   %ebp
f0103dd6:	89 e5                	mov    %esp,%ebp
f0103dd8:	57                   	push   %edi
f0103dd9:	56                   	push   %esi
f0103dda:	53                   	push   %ebx
f0103ddb:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103dde:	c6 05 50 62 35 f0 01 	movb   $0x1,0xf0356250
f0103de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103dea:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103def:	89 da                	mov    %ebx,%edx
f0103df1:	ee                   	out    %al,(%dx)
f0103df2:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103df7:	89 ca                	mov    %ecx,%edx
f0103df9:	ee                   	out    %al,(%dx)
f0103dfa:	bf 11 00 00 00       	mov    $0x11,%edi
f0103dff:	be 20 00 00 00       	mov    $0x20,%esi
f0103e04:	89 f8                	mov    %edi,%eax
f0103e06:	89 f2                	mov    %esi,%edx
f0103e08:	ee                   	out    %al,(%dx)
f0103e09:	b8 20 00 00 00       	mov    $0x20,%eax
f0103e0e:	89 da                	mov    %ebx,%edx
f0103e10:	ee                   	out    %al,(%dx)
f0103e11:	b8 04 00 00 00       	mov    $0x4,%eax
f0103e16:	ee                   	out    %al,(%dx)
f0103e17:	b8 03 00 00 00       	mov    $0x3,%eax
f0103e1c:	ee                   	out    %al,(%dx)
f0103e1d:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103e22:	89 f8                	mov    %edi,%eax
f0103e24:	89 da                	mov    %ebx,%edx
f0103e26:	ee                   	out    %al,(%dx)
f0103e27:	b8 28 00 00 00       	mov    $0x28,%eax
f0103e2c:	89 ca                	mov    %ecx,%edx
f0103e2e:	ee                   	out    %al,(%dx)
f0103e2f:	b8 02 00 00 00       	mov    $0x2,%eax
f0103e34:	ee                   	out    %al,(%dx)
f0103e35:	b8 01 00 00 00       	mov    $0x1,%eax
f0103e3a:	ee                   	out    %al,(%dx)
f0103e3b:	bf 68 00 00 00       	mov    $0x68,%edi
f0103e40:	89 f8                	mov    %edi,%eax
f0103e42:	89 f2                	mov    %esi,%edx
f0103e44:	ee                   	out    %al,(%dx)
f0103e45:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103e4a:	89 c8                	mov    %ecx,%eax
f0103e4c:	ee                   	out    %al,(%dx)
f0103e4d:	89 f8                	mov    %edi,%eax
f0103e4f:	89 da                	mov    %ebx,%edx
f0103e51:	ee                   	out    %al,(%dx)
f0103e52:	89 c8                	mov    %ecx,%eax
f0103e54:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103e55:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f0103e5c:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103e60:	75 08                	jne    f0103e6a <pic_init+0x95>
}
f0103e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103e65:	5b                   	pop    %ebx
f0103e66:	5e                   	pop    %esi
f0103e67:	5f                   	pop    %edi
f0103e68:	5d                   	pop    %ebp
f0103e69:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0103e6a:	83 ec 0c             	sub    $0xc,%esp
f0103e6d:	0f b7 c0             	movzwl %ax,%eax
f0103e70:	50                   	push   %eax
f0103e71:	e8 e1 fe ff ff       	call   f0103d57 <irq_setmask_8259A>
f0103e76:	83 c4 10             	add    $0x10,%esp
}
f0103e79:	eb e7                	jmp    f0103e62 <pic_init+0x8d>

f0103e7b <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103e7b:	55                   	push   %ebp
f0103e7c:	89 e5                	mov    %esp,%ebp
f0103e7e:	53                   	push   %ebx
f0103e7f:	83 ec 10             	sub    $0x10,%esp
f0103e82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0103e85:	ff 75 08             	pushl  0x8(%ebp)
f0103e88:	e8 e5 c8 ff ff       	call   f0100772 <cputchar>
	(*cnt)++;
f0103e8d:	83 03 01             	addl   $0x1,(%ebx)
}
f0103e90:	83 c4 10             	add    $0x10,%esp
f0103e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103e96:	c9                   	leave  
f0103e97:	c3                   	ret    

f0103e98 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103e98:	55                   	push   %ebp
f0103e99:	89 e5                	mov    %esp,%ebp
f0103e9b:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103e9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103ea5:	ff 75 0c             	pushl  0xc(%ebp)
f0103ea8:	ff 75 08             	pushl  0x8(%ebp)
f0103eab:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103eae:	50                   	push   %eax
f0103eaf:	68 7b 3e 10 f0       	push   $0xf0103e7b
f0103eb4:	e8 bb 1e 00 00       	call   f0105d74 <vprintfmt>
	return cnt;
}
f0103eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103ebc:	c9                   	leave  
f0103ebd:	c3                   	ret    

f0103ebe <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103ebe:	55                   	push   %ebp
f0103ebf:	89 e5                	mov    %esp,%ebp
f0103ec1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103ec4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103ec7:	50                   	push   %eax
f0103ec8:	ff 75 08             	pushl  0x8(%ebp)
f0103ecb:	e8 c8 ff ff ff       	call   f0103e98 <vcprintf>
	va_end(ap);

	return cnt;
}
f0103ed0:	c9                   	leave  
f0103ed1:	c3                   	ret    

f0103ed2 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103ed2:	55                   	push   %ebp
f0103ed3:	89 e5                	mov    %esp,%ebp
f0103ed5:	57                   	push   %edi
f0103ed6:	56                   	push   %esi
f0103ed7:	53                   	push   %ebx
f0103ed8:	83 ec 1c             	sub    $0x1c,%esp
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	int id = cpunum();
f0103edb:	e8 aa 2c 00 00       	call   f0106b8a <cpunum>
f0103ee0:	89 c6                	mov    %eax,%esi
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	// ts.ts_esp0 = KSTACKTOP;
	// ts.ts_ss0 = GD_KD;
	// ts.ts_iomb = sizeof(struct Taskstate);
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - id*(KSTKSIZE+KSTKGAP);
f0103ee2:	e8 a3 2c 00 00       	call   f0106b8a <cpunum>
f0103ee7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103eea:	89 f1                	mov    %esi,%ecx
f0103eec:	c1 e1 10             	shl    $0x10,%ecx
f0103eef:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103ef4:	29 ca                	sub    %ecx,%edx
f0103ef6:	89 90 30 70 35 f0    	mov    %edx,-0xfca8fd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103efc:	e8 89 2c 00 00       	call   f0106b8a <cpunum>
f0103f01:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f04:	66 c7 80 34 70 35 f0 	movw   $0x10,-0xfca8fcc(%eax)
f0103f0b:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0103f0d:	e8 78 2c 00 00       	call   f0106b8a <cpunum>
f0103f12:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f15:	66 c7 80 92 70 35 f0 	movw   $0x68,-0xfca8f6e(%eax)
f0103f1c:	68 00 
	// wrmsr(0x174, GD_KT, 0);           /* SYSENTER_CS_MSR */
	// wrmsr(0x175, KSTACKTOP, 0);       /* SYSENTER_ESP_MSR */
	// wrmsr(0x176, sysenter_handler, 0);/* SYSENTER_EIP_MSR */

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3)+id] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103f1e:	8d 5e 05             	lea    0x5(%esi),%ebx
f0103f21:	e8 64 2c 00 00       	call   f0106b8a <cpunum>
f0103f26:	89 c7                	mov    %eax,%edi
f0103f28:	e8 5d 2c 00 00       	call   f0106b8a <cpunum>
f0103f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103f30:	e8 55 2c 00 00       	call   f0106b8a <cpunum>
f0103f35:	66 c7 04 dd 40 53 12 	movw   $0x67,-0xfedacc0(,%ebx,8)
f0103f3c:	f0 67 00 
f0103f3f:	6b ff 74             	imul   $0x74,%edi,%edi
f0103f42:	81 c7 2c 70 35 f0    	add    $0xf035702c,%edi
f0103f48:	66 89 3c dd 42 53 12 	mov    %di,-0xfedacbe(,%ebx,8)
f0103f4f:	f0 
f0103f50:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103f54:	81 c2 2c 70 35 f0    	add    $0xf035702c,%edx
f0103f5a:	c1 ea 10             	shr    $0x10,%edx
f0103f5d:	88 14 dd 44 53 12 f0 	mov    %dl,-0xfedacbc(,%ebx,8)
f0103f64:	c6 04 dd 46 53 12 f0 	movb   $0x40,-0xfedacba(,%ebx,8)
f0103f6b:	40 
f0103f6c:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f6f:	05 2c 70 35 f0       	add    $0xf035702c,%eax
f0103f74:	c1 e8 18             	shr    $0x18,%eax
f0103f77:	88 04 dd 47 53 12 f0 	mov    %al,-0xfedacb9(,%ebx,8)
					sizeof(struct Taskstate)-1, 0);
	gdt[(GD_TSS0 >> 3)+id].sd_s = 0;
f0103f7e:	c6 04 dd 45 53 12 f0 	movb   $0x89,-0xfedacbb(,%ebx,8)
f0103f85:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0+(id<<3));
f0103f86:	8d 34 f5 28 00 00 00 	lea    0x28(,%esi,8),%esi
	asm volatile("ltr %0" : : "r" (sel));
f0103f8d:	0f 00 de             	ltr    %si
	asm volatile("lidt (%0)" : : "r" (p));
f0103f90:	b8 ac 53 12 f0       	mov    $0xf01253ac,%eax
f0103f95:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f0103f98:	83 c4 1c             	add    $0x1c,%esp
f0103f9b:	5b                   	pop    %ebx
f0103f9c:	5e                   	pop    %esi
f0103f9d:	5f                   	pop    %edi
f0103f9e:	5d                   	pop    %ebp
f0103f9f:	c3                   	ret    

f0103fa0 <trap_init>:
{
f0103fa0:	55                   	push   %ebp
f0103fa1:	89 e5                	mov    %esp,%ebp
f0103fa3:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE ],0,GD_KT,ENTRY_DIVIDE ,0);
f0103fa6:	b8 b4 4b 10 f0       	mov    $0xf0104bb4,%eax
f0103fab:	66 a3 60 62 35 f0    	mov    %ax,0xf0356260
f0103fb1:	66 c7 05 62 62 35 f0 	movw   $0x8,0xf0356262
f0103fb8:	08 00 
f0103fba:	c6 05 64 62 35 f0 00 	movb   $0x0,0xf0356264
f0103fc1:	c6 05 65 62 35 f0 8e 	movb   $0x8e,0xf0356265
f0103fc8:	c1 e8 10             	shr    $0x10,%eax
f0103fcb:	66 a3 66 62 35 f0    	mov    %ax,0xf0356266
	SETGATE(idt[T_DEBUG  ],0,GD_KT,ENTRY_DEBUG  ,0);
f0103fd1:	b8 be 4b 10 f0       	mov    $0xf0104bbe,%eax
f0103fd6:	66 a3 68 62 35 f0    	mov    %ax,0xf0356268
f0103fdc:	66 c7 05 6a 62 35 f0 	movw   $0x8,0xf035626a
f0103fe3:	08 00 
f0103fe5:	c6 05 6c 62 35 f0 00 	movb   $0x0,0xf035626c
f0103fec:	c6 05 6d 62 35 f0 8e 	movb   $0x8e,0xf035626d
f0103ff3:	c1 e8 10             	shr    $0x10,%eax
f0103ff6:	66 a3 6e 62 35 f0    	mov    %ax,0xf035626e
	SETGATE(idt[T_NMI    ],0,GD_KT,ENTRY_NMI    ,0);
f0103ffc:	b8 c8 4b 10 f0       	mov    $0xf0104bc8,%eax
f0104001:	66 a3 70 62 35 f0    	mov    %ax,0xf0356270
f0104007:	66 c7 05 72 62 35 f0 	movw   $0x8,0xf0356272
f010400e:	08 00 
f0104010:	c6 05 74 62 35 f0 00 	movb   $0x0,0xf0356274
f0104017:	c6 05 75 62 35 f0 8e 	movb   $0x8e,0xf0356275
f010401e:	c1 e8 10             	shr    $0x10,%eax
f0104021:	66 a3 76 62 35 f0    	mov    %ax,0xf0356276
	SETGATE(idt[T_BRKPT  ],0,GD_KT,ENTRY_BRKPT  ,3);
f0104027:	b8 d2 4b 10 f0       	mov    $0xf0104bd2,%eax
f010402c:	66 a3 78 62 35 f0    	mov    %ax,0xf0356278
f0104032:	66 c7 05 7a 62 35 f0 	movw   $0x8,0xf035627a
f0104039:	08 00 
f010403b:	c6 05 7c 62 35 f0 00 	movb   $0x0,0xf035627c
f0104042:	c6 05 7d 62 35 f0 ee 	movb   $0xee,0xf035627d
f0104049:	c1 e8 10             	shr    $0x10,%eax
f010404c:	66 a3 7e 62 35 f0    	mov    %ax,0xf035627e
	SETGATE(idt[T_OFLOW  ],0,GD_KT,ENTRY_OFLOW  ,3);
f0104052:	b8 dc 4b 10 f0       	mov    $0xf0104bdc,%eax
f0104057:	66 a3 80 62 35 f0    	mov    %ax,0xf0356280
f010405d:	66 c7 05 82 62 35 f0 	movw   $0x8,0xf0356282
f0104064:	08 00 
f0104066:	c6 05 84 62 35 f0 00 	movb   $0x0,0xf0356284
f010406d:	c6 05 85 62 35 f0 ee 	movb   $0xee,0xf0356285
f0104074:	c1 e8 10             	shr    $0x10,%eax
f0104077:	66 a3 86 62 35 f0    	mov    %ax,0xf0356286
	SETGATE(idt[T_BOUND  ],0,GD_KT,ENTRY_BOUND  ,3);
f010407d:	b8 e6 4b 10 f0       	mov    $0xf0104be6,%eax
f0104082:	66 a3 88 62 35 f0    	mov    %ax,0xf0356288
f0104088:	66 c7 05 8a 62 35 f0 	movw   $0x8,0xf035628a
f010408f:	08 00 
f0104091:	c6 05 8c 62 35 f0 00 	movb   $0x0,0xf035628c
f0104098:	c6 05 8d 62 35 f0 ee 	movb   $0xee,0xf035628d
f010409f:	c1 e8 10             	shr    $0x10,%eax
f01040a2:	66 a3 8e 62 35 f0    	mov    %ax,0xf035628e
	SETGATE(idt[T_ILLOP  ],0,GD_KT,ENTRY_ILLOP  ,0);
f01040a8:	b8 f0 4b 10 f0       	mov    $0xf0104bf0,%eax
f01040ad:	66 a3 90 62 35 f0    	mov    %ax,0xf0356290
f01040b3:	66 c7 05 92 62 35 f0 	movw   $0x8,0xf0356292
f01040ba:	08 00 
f01040bc:	c6 05 94 62 35 f0 00 	movb   $0x0,0xf0356294
f01040c3:	c6 05 95 62 35 f0 8e 	movb   $0x8e,0xf0356295
f01040ca:	c1 e8 10             	shr    $0x10,%eax
f01040cd:	66 a3 96 62 35 f0    	mov    %ax,0xf0356296
	SETGATE(idt[T_DEVICE ],0,GD_KT,ENTRY_DEVICE ,0);
f01040d3:	b8 fa 4b 10 f0       	mov    $0xf0104bfa,%eax
f01040d8:	66 a3 98 62 35 f0    	mov    %ax,0xf0356298
f01040de:	66 c7 05 9a 62 35 f0 	movw   $0x8,0xf035629a
f01040e5:	08 00 
f01040e7:	c6 05 9c 62 35 f0 00 	movb   $0x0,0xf035629c
f01040ee:	c6 05 9d 62 35 f0 8e 	movb   $0x8e,0xf035629d
f01040f5:	c1 e8 10             	shr    $0x10,%eax
f01040f8:	66 a3 9e 62 35 f0    	mov    %ax,0xf035629e
	SETGATE(idt[T_DBLFLT ],0,GD_KT,ENTRY_DBLFLT ,0);
f01040fe:	b8 04 4c 10 f0       	mov    $0xf0104c04,%eax
f0104103:	66 a3 a0 62 35 f0    	mov    %ax,0xf03562a0
f0104109:	66 c7 05 a2 62 35 f0 	movw   $0x8,0xf03562a2
f0104110:	08 00 
f0104112:	c6 05 a4 62 35 f0 00 	movb   $0x0,0xf03562a4
f0104119:	c6 05 a5 62 35 f0 8e 	movb   $0x8e,0xf03562a5
f0104120:	c1 e8 10             	shr    $0x10,%eax
f0104123:	66 a3 a6 62 35 f0    	mov    %ax,0xf03562a6
	SETGATE(idt[T_TSS    ],0,GD_KT,ENTRY_TSS    ,0);
f0104129:	b8 0c 4c 10 f0       	mov    $0xf0104c0c,%eax
f010412e:	66 a3 b0 62 35 f0    	mov    %ax,0xf03562b0
f0104134:	66 c7 05 b2 62 35 f0 	movw   $0x8,0xf03562b2
f010413b:	08 00 
f010413d:	c6 05 b4 62 35 f0 00 	movb   $0x0,0xf03562b4
f0104144:	c6 05 b5 62 35 f0 8e 	movb   $0x8e,0xf03562b5
f010414b:	c1 e8 10             	shr    $0x10,%eax
f010414e:	66 a3 b6 62 35 f0    	mov    %ax,0xf03562b6
	SETGATE(idt[T_SEGNP  ],0,GD_KT,ENTRY_SEGNP  ,0);
f0104154:	b8 14 4c 10 f0       	mov    $0xf0104c14,%eax
f0104159:	66 a3 b8 62 35 f0    	mov    %ax,0xf03562b8
f010415f:	66 c7 05 ba 62 35 f0 	movw   $0x8,0xf03562ba
f0104166:	08 00 
f0104168:	c6 05 bc 62 35 f0 00 	movb   $0x0,0xf03562bc
f010416f:	c6 05 bd 62 35 f0 8e 	movb   $0x8e,0xf03562bd
f0104176:	c1 e8 10             	shr    $0x10,%eax
f0104179:	66 a3 be 62 35 f0    	mov    %ax,0xf03562be
	SETGATE(idt[T_STACK  ],0,GD_KT,ENTRY_STACK  ,0);
f010417f:	b8 1c 4c 10 f0       	mov    $0xf0104c1c,%eax
f0104184:	66 a3 c0 62 35 f0    	mov    %ax,0xf03562c0
f010418a:	66 c7 05 c2 62 35 f0 	movw   $0x8,0xf03562c2
f0104191:	08 00 
f0104193:	c6 05 c4 62 35 f0 00 	movb   $0x0,0xf03562c4
f010419a:	c6 05 c5 62 35 f0 8e 	movb   $0x8e,0xf03562c5
f01041a1:	c1 e8 10             	shr    $0x10,%eax
f01041a4:	66 a3 c6 62 35 f0    	mov    %ax,0xf03562c6
	SETGATE(idt[T_GPFLT  ],0,GD_KT,ENTRY_GPFLT  ,0);
f01041aa:	b8 24 4c 10 f0       	mov    $0xf0104c24,%eax
f01041af:	66 a3 c8 62 35 f0    	mov    %ax,0xf03562c8
f01041b5:	66 c7 05 ca 62 35 f0 	movw   $0x8,0xf03562ca
f01041bc:	08 00 
f01041be:	c6 05 cc 62 35 f0 00 	movb   $0x0,0xf03562cc
f01041c5:	c6 05 cd 62 35 f0 8e 	movb   $0x8e,0xf03562cd
f01041cc:	c1 e8 10             	shr    $0x10,%eax
f01041cf:	66 a3 ce 62 35 f0    	mov    %ax,0xf03562ce
	SETGATE(idt[T_PGFLT  ],0,GD_KT,ENTRY_PGFLT  ,0);
f01041d5:	b8 2c 4c 10 f0       	mov    $0xf0104c2c,%eax
f01041da:	66 a3 d0 62 35 f0    	mov    %ax,0xf03562d0
f01041e0:	66 c7 05 d2 62 35 f0 	movw   $0x8,0xf03562d2
f01041e7:	08 00 
f01041e9:	c6 05 d4 62 35 f0 00 	movb   $0x0,0xf03562d4
f01041f0:	c6 05 d5 62 35 f0 8e 	movb   $0x8e,0xf03562d5
f01041f7:	c1 e8 10             	shr    $0x10,%eax
f01041fa:	66 a3 d6 62 35 f0    	mov    %ax,0xf03562d6
	SETGATE(idt[T_FPERR  ],0,GD_KT,ENTRY_FPERR  ,0);
f0104200:	b8 34 4c 10 f0       	mov    $0xf0104c34,%eax
f0104205:	66 a3 e0 62 35 f0    	mov    %ax,0xf03562e0
f010420b:	66 c7 05 e2 62 35 f0 	movw   $0x8,0xf03562e2
f0104212:	08 00 
f0104214:	c6 05 e4 62 35 f0 00 	movb   $0x0,0xf03562e4
f010421b:	c6 05 e5 62 35 f0 8e 	movb   $0x8e,0xf03562e5
f0104222:	c1 e8 10             	shr    $0x10,%eax
f0104225:	66 a3 e6 62 35 f0    	mov    %ax,0xf03562e6
	SETGATE(idt[T_ALIGN  ],0,GD_KT,ENTRY_ALIGN  ,0);
f010422b:	b8 3a 4c 10 f0       	mov    $0xf0104c3a,%eax
f0104230:	66 a3 e8 62 35 f0    	mov    %ax,0xf03562e8
f0104236:	66 c7 05 ea 62 35 f0 	movw   $0x8,0xf03562ea
f010423d:	08 00 
f010423f:	c6 05 ec 62 35 f0 00 	movb   $0x0,0xf03562ec
f0104246:	c6 05 ed 62 35 f0 8e 	movb   $0x8e,0xf03562ed
f010424d:	c1 e8 10             	shr    $0x10,%eax
f0104250:	66 a3 ee 62 35 f0    	mov    %ax,0xf03562ee
	SETGATE(idt[T_MCHK   ],0,GD_KT,ENTRY_MCHK   ,0);
f0104256:	b8 40 4c 10 f0       	mov    $0xf0104c40,%eax
f010425b:	66 a3 f0 62 35 f0    	mov    %ax,0xf03562f0
f0104261:	66 c7 05 f2 62 35 f0 	movw   $0x8,0xf03562f2
f0104268:	08 00 
f010426a:	c6 05 f4 62 35 f0 00 	movb   $0x0,0xf03562f4
f0104271:	c6 05 f5 62 35 f0 8e 	movb   $0x8e,0xf03562f5
f0104278:	c1 e8 10             	shr    $0x10,%eax
f010427b:	66 a3 f6 62 35 f0    	mov    %ax,0xf03562f6
	SETGATE(idt[T_SIMDERR],0,GD_KT,ENTRY_SIMDERR,0);
f0104281:	b8 46 4c 10 f0       	mov    $0xf0104c46,%eax
f0104286:	66 a3 f8 62 35 f0    	mov    %ax,0xf03562f8
f010428c:	66 c7 05 fa 62 35 f0 	movw   $0x8,0xf03562fa
f0104293:	08 00 
f0104295:	c6 05 fc 62 35 f0 00 	movb   $0x0,0xf03562fc
f010429c:	c6 05 fd 62 35 f0 8e 	movb   $0x8e,0xf03562fd
f01042a3:	c1 e8 10             	shr    $0x10,%eax
f01042a6:	66 a3 fe 62 35 f0    	mov    %ax,0xf03562fe
	SETGATE(idt[T_SYSCALL],0,GD_KT,ENTRY_SYSCALL,3);
f01042ac:	b8 4c 4c 10 f0       	mov    $0xf0104c4c,%eax
f01042b1:	66 a3 e0 63 35 f0    	mov    %ax,0xf03563e0
f01042b7:	66 c7 05 e2 63 35 f0 	movw   $0x8,0xf03563e2
f01042be:	08 00 
f01042c0:	c6 05 e4 63 35 f0 00 	movb   $0x0,0xf03563e4
f01042c7:	c6 05 e5 63 35 f0 ee 	movb   $0xee,0xf03563e5
f01042ce:	c1 e8 10             	shr    $0x10,%eax
f01042d1:	66 a3 e6 63 35 f0    	mov    %ax,0xf03563e6
	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER   ], 0, GD_KT, ENTRY_IRQ_TIMER   , 0);
f01042d7:	b8 52 4c 10 f0       	mov    $0xf0104c52,%eax
f01042dc:	66 a3 60 63 35 f0    	mov    %ax,0xf0356360
f01042e2:	66 c7 05 62 63 35 f0 	movw   $0x8,0xf0356362
f01042e9:	08 00 
f01042eb:	c6 05 64 63 35 f0 00 	movb   $0x0,0xf0356364
f01042f2:	c6 05 65 63 35 f0 8e 	movb   $0x8e,0xf0356365
f01042f9:	c1 e8 10             	shr    $0x10,%eax
f01042fc:	66 a3 66 63 35 f0    	mov    %ax,0xf0356366
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD     ], 0, GD_KT, ENTRY_IRQ_KBD     , 0);
f0104302:	b8 58 4c 10 f0       	mov    $0xf0104c58,%eax
f0104307:	66 a3 68 63 35 f0    	mov    %ax,0xf0356368
f010430d:	66 c7 05 6a 63 35 f0 	movw   $0x8,0xf035636a
f0104314:	08 00 
f0104316:	c6 05 6c 63 35 f0 00 	movb   $0x0,0xf035636c
f010431d:	c6 05 6d 63 35 f0 8e 	movb   $0x8e,0xf035636d
f0104324:	c1 e8 10             	shr    $0x10,%eax
f0104327:	66 a3 6e 63 35 f0    	mov    %ax,0xf035636e
	SETGATE(idt[IRQ_OFFSET+    2       ], 0, GD_KT, ENTRY_IRQ_2       , 0);
f010432d:	b8 5e 4c 10 f0       	mov    $0xf0104c5e,%eax
f0104332:	66 a3 70 63 35 f0    	mov    %ax,0xf0356370
f0104338:	66 c7 05 72 63 35 f0 	movw   $0x8,0xf0356372
f010433f:	08 00 
f0104341:	c6 05 74 63 35 f0 00 	movb   $0x0,0xf0356374
f0104348:	c6 05 75 63 35 f0 8e 	movb   $0x8e,0xf0356375
f010434f:	c1 e8 10             	shr    $0x10,%eax
f0104352:	66 a3 76 63 35 f0    	mov    %ax,0xf0356376
	SETGATE(idt[IRQ_OFFSET+    3       ], 0, GD_KT, ENTRY_IRQ_3       , 0);
f0104358:	b8 64 4c 10 f0       	mov    $0xf0104c64,%eax
f010435d:	66 a3 78 63 35 f0    	mov    %ax,0xf0356378
f0104363:	66 c7 05 7a 63 35 f0 	movw   $0x8,0xf035637a
f010436a:	08 00 
f010436c:	c6 05 7c 63 35 f0 00 	movb   $0x0,0xf035637c
f0104373:	c6 05 7d 63 35 f0 8e 	movb   $0x8e,0xf035637d
f010437a:	c1 e8 10             	shr    $0x10,%eax
f010437d:	66 a3 7e 63 35 f0    	mov    %ax,0xf035637e
	SETGATE(idt[IRQ_OFFSET+IRQ_SERIAL  ], 0, GD_KT, ENTRY_IRQ_SERIAL  , 0);
f0104383:	b8 6a 4c 10 f0       	mov    $0xf0104c6a,%eax
f0104388:	66 a3 80 63 35 f0    	mov    %ax,0xf0356380
f010438e:	66 c7 05 82 63 35 f0 	movw   $0x8,0xf0356382
f0104395:	08 00 
f0104397:	c6 05 84 63 35 f0 00 	movb   $0x0,0xf0356384
f010439e:	c6 05 85 63 35 f0 8e 	movb   $0x8e,0xf0356385
f01043a5:	c1 e8 10             	shr    $0x10,%eax
f01043a8:	66 a3 86 63 35 f0    	mov    %ax,0xf0356386
	SETGATE(idt[IRQ_OFFSET+    5       ], 0, GD_KT, ENTRY_IRQ_5       , 0);
f01043ae:	b8 70 4c 10 f0       	mov    $0xf0104c70,%eax
f01043b3:	66 a3 88 63 35 f0    	mov    %ax,0xf0356388
f01043b9:	66 c7 05 8a 63 35 f0 	movw   $0x8,0xf035638a
f01043c0:	08 00 
f01043c2:	c6 05 8c 63 35 f0 00 	movb   $0x0,0xf035638c
f01043c9:	c6 05 8d 63 35 f0 8e 	movb   $0x8e,0xf035638d
f01043d0:	c1 e8 10             	shr    $0x10,%eax
f01043d3:	66 a3 8e 63 35 f0    	mov    %ax,0xf035638e
	SETGATE(idt[IRQ_OFFSET+    6       ], 0, GD_KT, ENTRY_IRQ_6       , 0);
f01043d9:	b8 76 4c 10 f0       	mov    $0xf0104c76,%eax
f01043de:	66 a3 90 63 35 f0    	mov    %ax,0xf0356390
f01043e4:	66 c7 05 92 63 35 f0 	movw   $0x8,0xf0356392
f01043eb:	08 00 
f01043ed:	c6 05 94 63 35 f0 00 	movb   $0x0,0xf0356394
f01043f4:	c6 05 95 63 35 f0 8e 	movb   $0x8e,0xf0356395
f01043fb:	c1 e8 10             	shr    $0x10,%eax
f01043fe:	66 a3 96 63 35 f0    	mov    %ax,0xf0356396
	SETGATE(idt[IRQ_OFFSET+IRQ_SPURIOUS], 0, GD_KT, ENTRY_IRQ_SPURIOUS, 0);
f0104404:	b8 7c 4c 10 f0       	mov    $0xf0104c7c,%eax
f0104409:	66 a3 98 63 35 f0    	mov    %ax,0xf0356398
f010440f:	66 c7 05 9a 63 35 f0 	movw   $0x8,0xf035639a
f0104416:	08 00 
f0104418:	c6 05 9c 63 35 f0 00 	movb   $0x0,0xf035639c
f010441f:	c6 05 9d 63 35 f0 8e 	movb   $0x8e,0xf035639d
f0104426:	c1 e8 10             	shr    $0x10,%eax
f0104429:	66 a3 9e 63 35 f0    	mov    %ax,0xf035639e
	SETGATE(idt[IRQ_OFFSET+    8       ], 0, GD_KT, ENTRY_IRQ_8       , 0);
f010442f:	b8 82 4c 10 f0       	mov    $0xf0104c82,%eax
f0104434:	66 a3 a0 63 35 f0    	mov    %ax,0xf03563a0
f010443a:	66 c7 05 a2 63 35 f0 	movw   $0x8,0xf03563a2
f0104441:	08 00 
f0104443:	c6 05 a4 63 35 f0 00 	movb   $0x0,0xf03563a4
f010444a:	c6 05 a5 63 35 f0 8e 	movb   $0x8e,0xf03563a5
f0104451:	c1 e8 10             	shr    $0x10,%eax
f0104454:	66 a3 a6 63 35 f0    	mov    %ax,0xf03563a6
	SETGATE(idt[IRQ_OFFSET+    9       ], 0, GD_KT, ENTRY_IRQ_9       , 0);
f010445a:	b8 88 4c 10 f0       	mov    $0xf0104c88,%eax
f010445f:	66 a3 a8 63 35 f0    	mov    %ax,0xf03563a8
f0104465:	66 c7 05 aa 63 35 f0 	movw   $0x8,0xf03563aa
f010446c:	08 00 
f010446e:	c6 05 ac 63 35 f0 00 	movb   $0x0,0xf03563ac
f0104475:	c6 05 ad 63 35 f0 8e 	movb   $0x8e,0xf03563ad
f010447c:	c1 e8 10             	shr    $0x10,%eax
f010447f:	66 a3 ae 63 35 f0    	mov    %ax,0xf03563ae
	SETGATE(idt[IRQ_OFFSET+    10      ], 0, GD_KT, ENTRY_IRQ_10      , 0);
f0104485:	b8 8e 4c 10 f0       	mov    $0xf0104c8e,%eax
f010448a:	66 a3 b0 63 35 f0    	mov    %ax,0xf03563b0
f0104490:	66 c7 05 b2 63 35 f0 	movw   $0x8,0xf03563b2
f0104497:	08 00 
f0104499:	c6 05 b4 63 35 f0 00 	movb   $0x0,0xf03563b4
f01044a0:	c6 05 b5 63 35 f0 8e 	movb   $0x8e,0xf03563b5
f01044a7:	c1 e8 10             	shr    $0x10,%eax
f01044aa:	66 a3 b6 63 35 f0    	mov    %ax,0xf03563b6
	SETGATE(idt[IRQ_OFFSET+    11      ], 0, GD_KT, ENTRY_IRQ_11      , 0);
f01044b0:	b8 94 4c 10 f0       	mov    $0xf0104c94,%eax
f01044b5:	66 a3 b8 63 35 f0    	mov    %ax,0xf03563b8
f01044bb:	66 c7 05 ba 63 35 f0 	movw   $0x8,0xf03563ba
f01044c2:	08 00 
f01044c4:	c6 05 bc 63 35 f0 00 	movb   $0x0,0xf03563bc
f01044cb:	c6 05 bd 63 35 f0 8e 	movb   $0x8e,0xf03563bd
f01044d2:	c1 e8 10             	shr    $0x10,%eax
f01044d5:	66 a3 be 63 35 f0    	mov    %ax,0xf03563be
	SETGATE(idt[IRQ_OFFSET+    12      ], 0, GD_KT, ENTRY_IRQ_12      , 0);
f01044db:	b8 9a 4c 10 f0       	mov    $0xf0104c9a,%eax
f01044e0:	66 a3 c0 63 35 f0    	mov    %ax,0xf03563c0
f01044e6:	66 c7 05 c2 63 35 f0 	movw   $0x8,0xf03563c2
f01044ed:	08 00 
f01044ef:	c6 05 c4 63 35 f0 00 	movb   $0x0,0xf03563c4
f01044f6:	c6 05 c5 63 35 f0 8e 	movb   $0x8e,0xf03563c5
f01044fd:	c1 e8 10             	shr    $0x10,%eax
f0104500:	66 a3 c6 63 35 f0    	mov    %ax,0xf03563c6
	SETGATE(idt[IRQ_OFFSET+    13      ], 0, GD_KT, ENTRY_IRQ_13      , 0);
f0104506:	b8 a0 4c 10 f0       	mov    $0xf0104ca0,%eax
f010450b:	66 a3 c8 63 35 f0    	mov    %ax,0xf03563c8
f0104511:	66 c7 05 ca 63 35 f0 	movw   $0x8,0xf03563ca
f0104518:	08 00 
f010451a:	c6 05 cc 63 35 f0 00 	movb   $0x0,0xf03563cc
f0104521:	c6 05 cd 63 35 f0 8e 	movb   $0x8e,0xf03563cd
f0104528:	c1 e8 10             	shr    $0x10,%eax
f010452b:	66 a3 ce 63 35 f0    	mov    %ax,0xf03563ce
	SETGATE(idt[IRQ_OFFSET+IRQ_IDE     ], 0, GD_KT, ENTRY_IRQ_IDE     , 0);
f0104531:	b8 a6 4c 10 f0       	mov    $0xf0104ca6,%eax
f0104536:	66 a3 d0 63 35 f0    	mov    %ax,0xf03563d0
f010453c:	66 c7 05 d2 63 35 f0 	movw   $0x8,0xf03563d2
f0104543:	08 00 
f0104545:	c6 05 d4 63 35 f0 00 	movb   $0x0,0xf03563d4
f010454c:	c6 05 d5 63 35 f0 8e 	movb   $0x8e,0xf03563d5
f0104553:	c1 e8 10             	shr    $0x10,%eax
f0104556:	66 a3 d6 63 35 f0    	mov    %ax,0xf03563d6
	SETGATE(idt[IRQ_OFFSET+    15      ], 0, GD_KT, ENTRY_IRQ_15      , 0);
f010455c:	b8 ac 4c 10 f0       	mov    $0xf0104cac,%eax
f0104561:	66 a3 d8 63 35 f0    	mov    %ax,0xf03563d8
f0104567:	66 c7 05 da 63 35 f0 	movw   $0x8,0xf03563da
f010456e:	08 00 
f0104570:	c6 05 dc 63 35 f0 00 	movb   $0x0,0xf03563dc
f0104577:	c6 05 dd 63 35 f0 8e 	movb   $0x8e,0xf03563dd
f010457e:	c1 e8 10             	shr    $0x10,%eax
f0104581:	66 a3 de 63 35 f0    	mov    %ax,0xf03563de
	SETGATE(idt[IRQ_OFFSET+IRQ_ERROR   ], 0, GD_KT, ENTRY_IRQ_ERROR   , 0);
f0104587:	b8 b2 4c 10 f0       	mov    $0xf0104cb2,%eax
f010458c:	66 a3 f8 63 35 f0    	mov    %ax,0xf03563f8
f0104592:	66 c7 05 fa 63 35 f0 	movw   $0x8,0xf03563fa
f0104599:	08 00 
f010459b:	c6 05 fc 63 35 f0 00 	movb   $0x0,0xf03563fc
f01045a2:	c6 05 fd 63 35 f0 8e 	movb   $0x8e,0xf03563fd
f01045a9:	c1 e8 10             	shr    $0x10,%eax
f01045ac:	66 a3 fe 63 35 f0    	mov    %ax,0xf03563fe
	trap_init_percpu();
f01045b2:	e8 1b f9 ff ff       	call   f0103ed2 <trap_init_percpu>
}
f01045b7:	c9                   	leave  
f01045b8:	c3                   	ret    

f01045b9 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f01045b9:	55                   	push   %ebp
f01045ba:	89 e5                	mov    %esp,%ebp
f01045bc:	53                   	push   %ebx
f01045bd:	83 ec 0c             	sub    $0xc,%esp
f01045c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f01045c3:	ff 33                	pushl  (%ebx)
f01045c5:	68 65 88 10 f0       	push   $0xf0108865
f01045ca:	e8 ef f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01045cf:	83 c4 08             	add    $0x8,%esp
f01045d2:	ff 73 04             	pushl  0x4(%ebx)
f01045d5:	68 74 88 10 f0       	push   $0xf0108874
f01045da:	e8 df f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01045df:	83 c4 08             	add    $0x8,%esp
f01045e2:	ff 73 08             	pushl  0x8(%ebx)
f01045e5:	68 83 88 10 f0       	push   $0xf0108883
f01045ea:	e8 cf f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01045ef:	83 c4 08             	add    $0x8,%esp
f01045f2:	ff 73 0c             	pushl  0xc(%ebx)
f01045f5:	68 92 88 10 f0       	push   $0xf0108892
f01045fa:	e8 bf f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01045ff:	83 c4 08             	add    $0x8,%esp
f0104602:	ff 73 10             	pushl  0x10(%ebx)
f0104605:	68 a1 88 10 f0       	push   $0xf01088a1
f010460a:	e8 af f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f010460f:	83 c4 08             	add    $0x8,%esp
f0104612:	ff 73 14             	pushl  0x14(%ebx)
f0104615:	68 b0 88 10 f0       	push   $0xf01088b0
f010461a:	e8 9f f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f010461f:	83 c4 08             	add    $0x8,%esp
f0104622:	ff 73 18             	pushl  0x18(%ebx)
f0104625:	68 bf 88 10 f0       	push   $0xf01088bf
f010462a:	e8 8f f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010462f:	83 c4 08             	add    $0x8,%esp
f0104632:	ff 73 1c             	pushl  0x1c(%ebx)
f0104635:	68 ce 88 10 f0       	push   $0xf01088ce
f010463a:	e8 7f f8 ff ff       	call   f0103ebe <cprintf>
}
f010463f:	83 c4 10             	add    $0x10,%esp
f0104642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104645:	c9                   	leave  
f0104646:	c3                   	ret    

f0104647 <print_trapframe>:
{
f0104647:	55                   	push   %ebp
f0104648:	89 e5                	mov    %esp,%ebp
f010464a:	56                   	push   %esi
f010464b:	53                   	push   %ebx
f010464c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f010464f:	e8 36 25 00 00       	call   f0106b8a <cpunum>
f0104654:	83 ec 04             	sub    $0x4,%esp
f0104657:	50                   	push   %eax
f0104658:	53                   	push   %ebx
f0104659:	68 32 89 10 f0       	push   $0xf0108932
f010465e:	e8 5b f8 ff ff       	call   f0103ebe <cprintf>
	print_regs(&tf->tf_regs);
f0104663:	89 1c 24             	mov    %ebx,(%esp)
f0104666:	e8 4e ff ff ff       	call   f01045b9 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f010466b:	83 c4 08             	add    $0x8,%esp
f010466e:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104672:	50                   	push   %eax
f0104673:	68 50 89 10 f0       	push   $0xf0108950
f0104678:	e8 41 f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f010467d:	83 c4 08             	add    $0x8,%esp
f0104680:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104684:	50                   	push   %eax
f0104685:	68 63 89 10 f0       	push   $0xf0108963
f010468a:	e8 2f f8 ff ff       	call   f0103ebe <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010468f:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104692:	83 c4 10             	add    $0x10,%esp
f0104695:	83 f8 13             	cmp    $0x13,%eax
f0104698:	0f 86 e1 00 00 00    	jbe    f010477f <print_trapframe+0x138>
		return "System call";
f010469e:	ba dd 88 10 f0       	mov    $0xf01088dd,%edx
	if (trapno == T_SYSCALL)
f01046a3:	83 f8 30             	cmp    $0x30,%eax
f01046a6:	74 13                	je     f01046bb <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01046a8:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f01046ab:	83 fa 0f             	cmp    $0xf,%edx
f01046ae:	ba e9 88 10 f0       	mov    $0xf01088e9,%edx
f01046b3:	b9 f8 88 10 f0       	mov    $0xf01088f8,%ecx
f01046b8:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01046bb:	83 ec 04             	sub    $0x4,%esp
f01046be:	52                   	push   %edx
f01046bf:	50                   	push   %eax
f01046c0:	68 76 89 10 f0       	push   $0xf0108976
f01046c5:	e8 f4 f7 ff ff       	call   f0103ebe <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01046ca:	83 c4 10             	add    $0x10,%esp
f01046cd:	39 1d 60 6a 35 f0    	cmp    %ebx,0xf0356a60
f01046d3:	0f 84 b2 00 00 00    	je     f010478b <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f01046d9:	83 ec 08             	sub    $0x8,%esp
f01046dc:	ff 73 2c             	pushl  0x2c(%ebx)
f01046df:	68 97 89 10 f0       	push   $0xf0108997
f01046e4:	e8 d5 f7 ff ff       	call   f0103ebe <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f01046e9:	83 c4 10             	add    $0x10,%esp
f01046ec:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01046f0:	0f 85 b8 00 00 00    	jne    f01047ae <print_trapframe+0x167>
			tf->tf_err & 1 ? "protection" : "not-present");
f01046f6:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f01046f9:	89 c2                	mov    %eax,%edx
f01046fb:	83 e2 01             	and    $0x1,%edx
f01046fe:	b9 0b 89 10 f0       	mov    $0xf010890b,%ecx
f0104703:	ba 16 89 10 f0       	mov    $0xf0108916,%edx
f0104708:	0f 44 ca             	cmove  %edx,%ecx
f010470b:	89 c2                	mov    %eax,%edx
f010470d:	83 e2 02             	and    $0x2,%edx
f0104710:	be 22 89 10 f0       	mov    $0xf0108922,%esi
f0104715:	ba 28 89 10 f0       	mov    $0xf0108928,%edx
f010471a:	0f 45 d6             	cmovne %esi,%edx
f010471d:	83 e0 04             	and    $0x4,%eax
f0104720:	b8 2d 89 10 f0       	mov    $0xf010892d,%eax
f0104725:	be 62 8a 10 f0       	mov    $0xf0108a62,%esi
f010472a:	0f 44 c6             	cmove  %esi,%eax
f010472d:	51                   	push   %ecx
f010472e:	52                   	push   %edx
f010472f:	50                   	push   %eax
f0104730:	68 a5 89 10 f0       	push   $0xf01089a5
f0104735:	e8 84 f7 ff ff       	call   f0103ebe <cprintf>
f010473a:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f010473d:	83 ec 08             	sub    $0x8,%esp
f0104740:	ff 73 30             	pushl  0x30(%ebx)
f0104743:	68 b4 89 10 f0       	push   $0xf01089b4
f0104748:	e8 71 f7 ff ff       	call   f0103ebe <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f010474d:	83 c4 08             	add    $0x8,%esp
f0104750:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104754:	50                   	push   %eax
f0104755:	68 c3 89 10 f0       	push   $0xf01089c3
f010475a:	e8 5f f7 ff ff       	call   f0103ebe <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f010475f:	83 c4 08             	add    $0x8,%esp
f0104762:	ff 73 38             	pushl  0x38(%ebx)
f0104765:	68 d6 89 10 f0       	push   $0xf01089d6
f010476a:	e8 4f f7 ff ff       	call   f0103ebe <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f010476f:	83 c4 10             	add    $0x10,%esp
f0104772:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104776:	75 4b                	jne    f01047c3 <print_trapframe+0x17c>
}
f0104778:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010477b:	5b                   	pop    %ebx
f010477c:	5e                   	pop    %esi
f010477d:	5d                   	pop    %ebp
f010477e:	c3                   	ret    
		return excnames[trapno];
f010477f:	8b 14 85 40 8c 10 f0 	mov    -0xfef73c0(,%eax,4),%edx
f0104786:	e9 30 ff ff ff       	jmp    f01046bb <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010478b:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f010478f:	0f 85 44 ff ff ff    	jne    f01046d9 <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104795:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104798:	83 ec 08             	sub    $0x8,%esp
f010479b:	50                   	push   %eax
f010479c:	68 88 89 10 f0       	push   $0xf0108988
f01047a1:	e8 18 f7 ff ff       	call   f0103ebe <cprintf>
f01047a6:	83 c4 10             	add    $0x10,%esp
f01047a9:	e9 2b ff ff ff       	jmp    f01046d9 <print_trapframe+0x92>
		cprintf("\n");
f01047ae:	83 ec 0c             	sub    $0xc,%esp
f01047b1:	68 a6 87 10 f0       	push   $0xf01087a6
f01047b6:	e8 03 f7 ff ff       	call   f0103ebe <cprintf>
f01047bb:	83 c4 10             	add    $0x10,%esp
f01047be:	e9 7a ff ff ff       	jmp    f010473d <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f01047c3:	83 ec 08             	sub    $0x8,%esp
f01047c6:	ff 73 3c             	pushl  0x3c(%ebx)
f01047c9:	68 e5 89 10 f0       	push   $0xf01089e5
f01047ce:	e8 eb f6 ff ff       	call   f0103ebe <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01047d3:	83 c4 08             	add    $0x8,%esp
f01047d6:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f01047da:	50                   	push   %eax
f01047db:	68 f4 89 10 f0       	push   $0xf01089f4
f01047e0:	e8 d9 f6 ff ff       	call   f0103ebe <cprintf>
f01047e5:	83 c4 10             	add    $0x10,%esp
}
f01047e8:	eb 8e                	jmp    f0104778 <print_trapframe+0x131>

f01047ea <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f01047ea:	55                   	push   %ebp
f01047eb:	89 e5                	mov    %esp,%ebp
f01047ed:	57                   	push   %edi
f01047ee:	56                   	push   %esi
f01047ef:	53                   	push   %ebx
f01047f0:	83 ec 0c             	sub    $0xc,%esp
f01047f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01047f6:	0f 20 d6             	mov    %cr2,%esi
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if (!(tf->tf_cs & 3)){
f01047f9:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01047fd:	74 61                	je     f0104860 <page_fault_handler+0x76>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.

	if (curenv->env_pgfault_upcall) {
f01047ff:	e8 86 23 00 00       	call   f0106b8a <cpunum>
f0104804:	6b c0 74             	imul   $0x74,%eax,%eax
f0104807:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010480d:	83 78 68 00          	cmpl   $0x0,0x68(%eax)
f0104811:	0f 85 80 00 00 00    	jne    f0104897 <page_fault_handler+0xad>
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104817:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f010481a:	e8 6b 23 00 00       	call   f0106b8a <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010481f:	57                   	push   %edi
f0104820:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f0104821:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104824:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010482a:	ff 70 48             	pushl  0x48(%eax)
f010482d:	68 04 8c 10 f0       	push   $0xf0108c04
f0104832:	e8 87 f6 ff ff       	call   f0103ebe <cprintf>
	print_trapframe(tf);
f0104837:	89 1c 24             	mov    %ebx,(%esp)
f010483a:	e8 08 fe ff ff       	call   f0104647 <print_trapframe>
	env_destroy(curenv);
f010483f:	e8 46 23 00 00       	call   f0106b8a <cpunum>
f0104844:	83 c4 04             	add    $0x4,%esp
f0104847:	6b c0 74             	imul   $0x74,%eax,%eax
f010484a:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0104850:	e8 88 f3 ff ff       	call   f0103bdd <env_destroy>
}
f0104855:	83 c4 10             	add    $0x10,%esp
f0104858:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010485b:	5b                   	pop    %ebx
f010485c:	5e                   	pop    %esi
f010485d:	5f                   	pop    %edi
f010485e:	5d                   	pop    %ebp
f010485f:	c3                   	ret    
		cprintf("[%08x] kernel fault va %08x ip %08x\n",
f0104860:	8b 5b 30             	mov    0x30(%ebx),%ebx
		curenv->env_id, fault_va, tf->tf_eip);
f0104863:	e8 22 23 00 00       	call   f0106b8a <cpunum>
		cprintf("[%08x] kernel fault va %08x ip %08x\n",
f0104868:	53                   	push   %ebx
f0104869:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f010486a:	6b c0 74             	imul   $0x74,%eax,%eax
		cprintf("[%08x] kernel fault va %08x ip %08x\n",
f010486d:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104873:	ff 70 48             	pushl  0x48(%eax)
f0104876:	68 ac 8b 10 f0       	push   $0xf0108bac
f010487b:	e8 3e f6 ff ff       	call   f0103ebe <cprintf>
		panic("page_fault_handler:\tkernel-mode page faults!");
f0104880:	83 c4 0c             	add    $0xc,%esp
f0104883:	68 d4 8b 10 f0       	push   $0xf0108bd4
f0104888:	68 94 01 00 00       	push   $0x194
f010488d:	68 07 8a 10 f0       	push   $0xf0108a07
f0104892:	e8 a9 b7 ff ff       	call   f0100040 <_panic>
		if (UXSTACKTOP - PGSIZE <= tf->tf_esp && UXSTACKTOP > tf->tf_esp)
f0104897:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010489a:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
f01048a0:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if (UXSTACKTOP - PGSIZE <= tf->tf_esp && UXSTACKTOP > tf->tf_esp)
f01048a5:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f01048ab:	77 05                	ja     f01048b2 <page_fault_handler+0xc8>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f01048ad:	83 e8 38             	sub    $0x38,%eax
f01048b0:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f01048b2:	e8 d3 22 00 00       	call   f0106b8a <cpunum>
f01048b7:	6a 02                	push   $0x2
f01048b9:	6a 34                	push   $0x34
f01048bb:	57                   	push   %edi
f01048bc:	6b c0 74             	imul   $0x74,%eax,%eax
f01048bf:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f01048c5:	e8 d7 ec ff ff       	call   f01035a1 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f01048ca:	89 fa                	mov    %edi,%edx
f01048cc:	89 37                	mov    %esi,(%edi)
		utf->utf_err      = tf->tf_err;
f01048ce:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01048d1:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs     = tf->tf_regs;
f01048d4:	8d 7f 08             	lea    0x8(%edi),%edi
f01048d7:	b9 08 00 00 00       	mov    $0x8,%ecx
f01048dc:	89 de                	mov    %ebx,%esi
f01048de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip      = tf->tf_eip;
f01048e0:	8b 43 30             	mov    0x30(%ebx),%eax
f01048e3:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags   = tf->tf_eflags;
f01048e6:	8b 43 38             	mov    0x38(%ebx),%eax
f01048e9:	89 d7                	mov    %edx,%edi
f01048eb:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp      = tf->tf_esp;
f01048ee:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01048f1:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f01048f4:	e8 91 22 00 00       	call   f0106b8a <cpunum>
f01048f9:	6b c0 74             	imul   $0x74,%eax,%eax
f01048fc:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104902:	8b 58 68             	mov    0x68(%eax),%ebx
f0104905:	e8 80 22 00 00       	call   f0106b8a <cpunum>
f010490a:	6b c0 74             	imul   $0x74,%eax,%eax
f010490d:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104913:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f0104916:	e8 6f 22 00 00       	call   f0106b8a <cpunum>
f010491b:	6b c0 74             	imul   $0x74,%eax,%eax
f010491e:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104924:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104927:	e8 5e 22 00 00       	call   f0106b8a <cpunum>
f010492c:	83 c4 04             	add    $0x4,%esp
f010492f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104932:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0104938:	e8 3f f3 ff ff       	call   f0103c7c <env_run>

f010493d <trap>:
{
f010493d:	55                   	push   %ebp
f010493e:	89 e5                	mov    %esp,%ebp
f0104940:	57                   	push   %edi
f0104941:	56                   	push   %esi
f0104942:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104945:	fc                   	cld    
	if (panicstr)
f0104946:	83 3d 80 6e 35 f0 00 	cmpl   $0x0,0xf0356e80
f010494d:	74 01                	je     f0104950 <trap+0x13>
		asm volatile("hlt");
f010494f:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104950:	e8 35 22 00 00       	call   f0106b8a <cpunum>
f0104955:	6b d0 74             	imul   $0x74,%eax,%edx
f0104958:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010495b:	b8 01 00 00 00       	mov    $0x1,%eax
f0104960:	f0 87 82 20 70 35 f0 	lock xchg %eax,-0xfca8fe0(%edx)
f0104967:	83 f8 02             	cmp    $0x2,%eax
f010496a:	0f 84 c2 00 00 00    	je     f0104a32 <trap+0xf5>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104970:	9c                   	pushf  
f0104971:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104972:	f6 c4 02             	test   $0x2,%ah
f0104975:	0f 85 cc 00 00 00    	jne    f0104a47 <trap+0x10a>
	if ((tf->tf_cs & 3) == 3) {
f010497b:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010497f:	83 e0 03             	and    $0x3,%eax
f0104982:	66 83 f8 03          	cmp    $0x3,%ax
f0104986:	0f 84 d4 00 00 00    	je     f0104a60 <trap+0x123>
	last_tf = tf;
f010498c:	89 35 60 6a 35 f0    	mov    %esi,0xf0356a60
	if(tf->tf_trapno == T_PGFLT){
f0104992:	8b 46 28             	mov    0x28(%esi),%eax
f0104995:	83 f8 0e             	cmp    $0xe,%eax
f0104998:	0f 84 67 01 00 00    	je     f0104b05 <trap+0x1c8>
	else if(tf->tf_trapno == T_BRKPT){
f010499e:	83 f8 03             	cmp    $0x3,%eax
f01049a1:	0f 84 6f 01 00 00    	je     f0104b16 <trap+0x1d9>
	else if(tf->tf_trapno == T_SYSCALL){
f01049a7:	83 f8 30             	cmp    $0x30,%eax
f01049aa:	0f 84 77 01 00 00    	je     f0104b27 <trap+0x1ea>
	else if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f01049b0:	83 f8 20             	cmp    $0x20,%eax
f01049b3:	0f 84 92 01 00 00    	je     f0104b4b <trap+0x20e>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01049b9:	83 f8 27             	cmp    $0x27,%eax
f01049bc:	0f 84 93 01 00 00    	je     f0104b55 <trap+0x218>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
f01049c2:	83 f8 21             	cmp    $0x21,%eax
f01049c5:	0f 84 a7 01 00 00    	je     f0104b72 <trap+0x235>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
f01049cb:	83 f8 24             	cmp    $0x24,%eax
f01049ce:	0f 84 a8 01 00 00    	je     f0104b7c <trap+0x23f>
	print_trapframe(tf);
f01049d4:	83 ec 0c             	sub    $0xc,%esp
f01049d7:	56                   	push   %esi
f01049d8:	e8 6a fc ff ff       	call   f0104647 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f01049dd:	83 c4 10             	add    $0x10,%esp
f01049e0:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01049e5:	0f 84 9b 01 00 00    	je     f0104b86 <trap+0x249>
		env_destroy(curenv);
f01049eb:	e8 9a 21 00 00       	call   f0106b8a <cpunum>
f01049f0:	83 ec 0c             	sub    $0xc,%esp
f01049f3:	6b c0 74             	imul   $0x74,%eax,%eax
f01049f6:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f01049fc:	e8 dc f1 ff ff       	call   f0103bdd <env_destroy>
f0104a01:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104a04:	e8 81 21 00 00       	call   f0106b8a <cpunum>
f0104a09:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a0c:	83 b8 28 70 35 f0 00 	cmpl   $0x0,-0xfca8fd8(%eax)
f0104a13:	74 18                	je     f0104a2d <trap+0xf0>
f0104a15:	e8 70 21 00 00       	call   f0106b8a <cpunum>
f0104a1a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a1d:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104a23:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104a27:	0f 84 70 01 00 00    	je     f0104b9d <trap+0x260>
		sched_yield();
f0104a2d:	e8 65 03 00 00       	call   f0104d97 <sched_yield>
	spin_lock(&kernel_lock);
f0104a32:	83 ec 0c             	sub    $0xc,%esp
f0104a35:	68 c0 53 12 f0       	push   $0xf01253c0
f0104a3a:	e8 bb 23 00 00       	call   f0106dfa <spin_lock>
f0104a3f:	83 c4 10             	add    $0x10,%esp
f0104a42:	e9 29 ff ff ff       	jmp    f0104970 <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f0104a47:	68 13 8a 10 f0       	push   $0xf0108a13
f0104a4c:	68 c7 84 10 f0       	push   $0xf01084c7
f0104a51:	68 5b 01 00 00       	push   $0x15b
f0104a56:	68 07 8a 10 f0       	push   $0xf0108a07
f0104a5b:	e8 e0 b5 ff ff       	call   f0100040 <_panic>
		assert(curenv);
f0104a60:	e8 25 21 00 00       	call   f0106b8a <cpunum>
f0104a65:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a68:	83 b8 28 70 35 f0 00 	cmpl   $0x0,-0xfca8fd8(%eax)
f0104a6f:	74 4e                	je     f0104abf <trap+0x182>
f0104a71:	83 ec 0c             	sub    $0xc,%esp
f0104a74:	68 c0 53 12 f0       	push   $0xf01253c0
f0104a79:	e8 7c 23 00 00       	call   f0106dfa <spin_lock>
		if (curenv->env_status == ENV_DYING) {
f0104a7e:	e8 07 21 00 00       	call   f0106b8a <cpunum>
f0104a83:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a86:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104a8c:	83 c4 10             	add    $0x10,%esp
f0104a8f:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104a93:	74 43                	je     f0104ad8 <trap+0x19b>
		curenv->env_tf = *tf;
f0104a95:	e8 f0 20 00 00       	call   f0106b8a <cpunum>
f0104a9a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a9d:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104aa3:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104aa8:	89 c7                	mov    %eax,%edi
f0104aaa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104aac:	e8 d9 20 00 00       	call   f0106b8a <cpunum>
f0104ab1:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ab4:	8b b0 28 70 35 f0    	mov    -0xfca8fd8(%eax),%esi
f0104aba:	e9 cd fe ff ff       	jmp    f010498c <trap+0x4f>
		assert(curenv);
f0104abf:	68 2c 8a 10 f0       	push   $0xf0108a2c
f0104ac4:	68 c7 84 10 f0       	push   $0xf01084c7
f0104ac9:	68 62 01 00 00       	push   $0x162
f0104ace:	68 07 8a 10 f0       	push   $0xf0108a07
f0104ad3:	e8 68 b5 ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f0104ad8:	e8 ad 20 00 00       	call   f0106b8a <cpunum>
f0104add:	83 ec 0c             	sub    $0xc,%esp
f0104ae0:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ae3:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0104ae9:	e8 41 ef ff ff       	call   f0103a2f <env_free>
			curenv = NULL;
f0104aee:	e8 97 20 00 00       	call   f0106b8a <cpunum>
f0104af3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104af6:	c7 80 28 70 35 f0 00 	movl   $0x0,-0xfca8fd8(%eax)
f0104afd:	00 00 00 
			sched_yield();
f0104b00:	e8 92 02 00 00       	call   f0104d97 <sched_yield>
		page_fault_handler(tf);
f0104b05:	83 ec 0c             	sub    $0xc,%esp
f0104b08:	56                   	push   %esi
f0104b09:	e8 dc fc ff ff       	call   f01047ea <page_fault_handler>
f0104b0e:	83 c4 10             	add    $0x10,%esp
f0104b11:	e9 ee fe ff ff       	jmp    f0104a04 <trap+0xc7>
		monitor(tf);
f0104b16:	83 ec 0c             	sub    $0xc,%esp
f0104b19:	56                   	push   %esi
f0104b1a:	e8 10 c3 ff ff       	call   f0100e2f <monitor>
f0104b1f:	83 c4 10             	add    $0x10,%esp
f0104b22:	e9 dd fe ff ff       	jmp    f0104a04 <trap+0xc7>
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax,\
f0104b27:	83 ec 08             	sub    $0x8,%esp
f0104b2a:	ff 76 04             	pushl  0x4(%esi)
f0104b2d:	ff 36                	pushl  (%esi)
f0104b2f:	ff 76 10             	pushl  0x10(%esi)
f0104b32:	ff 76 18             	pushl  0x18(%esi)
f0104b35:	ff 76 14             	pushl  0x14(%esi)
f0104b38:	ff 76 1c             	pushl  0x1c(%esi)
f0104b3b:	e8 18 03 00 00       	call   f0104e58 <syscall>
f0104b40:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104b43:	83 c4 20             	add    $0x20,%esp
f0104b46:	e9 b9 fe ff ff       	jmp    f0104a04 <trap+0xc7>
		lapic_eoi();
f0104b4b:	e8 81 21 00 00       	call   f0106cd1 <lapic_eoi>
		sched_yield();
f0104b50:	e8 42 02 00 00       	call   f0104d97 <sched_yield>
		cprintf("Spurious interrupt on irq 7\n");
f0104b55:	83 ec 0c             	sub    $0xc,%esp
f0104b58:	68 33 8a 10 f0       	push   $0xf0108a33
f0104b5d:	e8 5c f3 ff ff       	call   f0103ebe <cprintf>
		print_trapframe(tf);
f0104b62:	89 34 24             	mov    %esi,(%esp)
f0104b65:	e8 dd fa ff ff       	call   f0104647 <print_trapframe>
f0104b6a:	83 c4 10             	add    $0x10,%esp
f0104b6d:	e9 92 fe ff ff       	jmp    f0104a04 <trap+0xc7>
		kbd_intr();
f0104b72:	e8 5a ba ff ff       	call   f01005d1 <kbd_intr>
f0104b77:	e9 88 fe ff ff       	jmp    f0104a04 <trap+0xc7>
		serial_intr();
f0104b7c:	e8 34 ba ff ff       	call   f01005b5 <serial_intr>
f0104b81:	e9 7e fe ff ff       	jmp    f0104a04 <trap+0xc7>
		panic("unhandled trap in kernel");
f0104b86:	83 ec 04             	sub    $0x4,%esp
f0104b89:	68 50 8a 10 f0       	push   $0xf0108a50
f0104b8e:	68 41 01 00 00       	push   $0x141
f0104b93:	68 07 8a 10 f0       	push   $0xf0108a07
f0104b98:	e8 a3 b4 ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f0104b9d:	e8 e8 1f 00 00       	call   f0106b8a <cpunum>
f0104ba2:	83 ec 0c             	sub    $0xc,%esp
f0104ba5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ba8:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0104bae:	e8 c9 f0 ff ff       	call   f0103c7c <env_run>
f0104bb3:	90                   	nop

f0104bb4 <ENTRY_DIVIDE>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC( ENTRY_DIVIDE  , T_DIVIDE )  /*  0 divide error*/
f0104bb4:	6a 00                	push   $0x0
f0104bb6:	6a 00                	push   $0x0
f0104bb8:	e9 fb 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104bbd:	90                   	nop

f0104bbe <ENTRY_DEBUG>:
TRAPHANDLER_NOEC( ENTRY_DEBUG   , T_DEBUG  )  /*  1 debug exception*/
f0104bbe:	6a 00                	push   $0x0
f0104bc0:	6a 01                	push   $0x1
f0104bc2:	e9 f1 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104bc7:	90                   	nop

f0104bc8 <ENTRY_NMI>:
TRAPHANDLER_NOEC( ENTRY_NMI     , T_NMI    )  /*  2 non-maskable interrupt*/
f0104bc8:	6a 00                	push   $0x0
f0104bca:	6a 02                	push   $0x2
f0104bcc:	e9 e7 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104bd1:	90                   	nop

f0104bd2 <ENTRY_BRKPT>:
TRAPHANDLER_NOEC( ENTRY_BRKPT   , T_BRKPT  )  /*  3 breakpoint*/
f0104bd2:	6a 00                	push   $0x0
f0104bd4:	6a 03                	push   $0x3
f0104bd6:	e9 dd 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104bdb:	90                   	nop

f0104bdc <ENTRY_OFLOW>:
TRAPHANDLER_NOEC( ENTRY_OFLOW   , T_OFLOW  )  /*  4 overflow*/
f0104bdc:	6a 00                	push   $0x0
f0104bde:	6a 04                	push   $0x4
f0104be0:	e9 d3 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104be5:	90                   	nop

f0104be6 <ENTRY_BOUND>:
TRAPHANDLER_NOEC( ENTRY_BOUND   , T_BOUND  )  /*  5 bounds check*/
f0104be6:	6a 00                	push   $0x0
f0104be8:	6a 05                	push   $0x5
f0104bea:	e9 c9 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104bef:	90                   	nop

f0104bf0 <ENTRY_ILLOP>:
TRAPHANDLER_NOEC( ENTRY_ILLOP   , T_ILLOP  )  /*  6 illegal opcode*/
f0104bf0:	6a 00                	push   $0x0
f0104bf2:	6a 06                	push   $0x6
f0104bf4:	e9 bf 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104bf9:	90                   	nop

f0104bfa <ENTRY_DEVICE>:
TRAPHANDLER_NOEC( ENTRY_DEVICE  , T_DEVICE )  /*  7 device not available*/
f0104bfa:	6a 00                	push   $0x0
f0104bfc:	6a 07                	push   $0x7
f0104bfe:	e9 b5 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104c03:	90                   	nop

f0104c04 <ENTRY_DBLFLT>:
TRAPHANDLER     ( ENTRY_DBLFLT  , T_DBLFLT )  /*  8 double fault*/
f0104c04:	6a 08                	push   $0x8
f0104c06:	e9 ad 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104c0b:	90                   	nop

f0104c0c <ENTRY_TSS>:
/*TRAPHANDLER_NOEC( ENTRY_COPROC  , T_COPROC )*/  /*  9 reserved (not generated by recent processors)*/
TRAPHANDLER     ( ENTRY_TSS     , T_TSS    )  /* 10 invalid task switch segment*/
f0104c0c:	6a 0a                	push   $0xa
f0104c0e:	e9 a5 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104c13:	90                   	nop

f0104c14 <ENTRY_SEGNP>:
TRAPHANDLER     ( ENTRY_SEGNP   , T_SEGNP  )  /* 11 segment not present*/
f0104c14:	6a 0b                	push   $0xb
f0104c16:	e9 9d 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104c1b:	90                   	nop

f0104c1c <ENTRY_STACK>:
TRAPHANDLER     ( ENTRY_STACK   , T_STACK  )  /* 12 stack exception*/
f0104c1c:	6a 0c                	push   $0xc
f0104c1e:	e9 95 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104c23:	90                   	nop

f0104c24 <ENTRY_GPFLT>:
TRAPHANDLER     ( ENTRY_GPFLT   , T_GPFLT  )  /* 13 general protection fault*/
f0104c24:	6a 0d                	push   $0xd
f0104c26:	e9 8d 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104c2b:	90                   	nop

f0104c2c <ENTRY_PGFLT>:
TRAPHANDLER     ( ENTRY_PGFLT   , T_PGFLT  )  /* 14 page fault*/
f0104c2c:	6a 0e                	push   $0xe
f0104c2e:	e9 85 00 00 00       	jmp    f0104cb8 <_alltraps>
f0104c33:	90                   	nop

f0104c34 <ENTRY_FPERR>:
/*TRAPHANDLER_NOEC( ENTRY_RES     , T_RES    )*/  /* 15 reserved*/
TRAPHANDLER_NOEC( ENTRY_FPERR   , T_FPERR  )  /* 16 floating point error*/
f0104c34:	6a 00                	push   $0x0
f0104c36:	6a 10                	push   $0x10
f0104c38:	eb 7e                	jmp    f0104cb8 <_alltraps>

f0104c3a <ENTRY_ALIGN>:
TRAPHANDLER_NOEC( ENTRY_ALIGN   , T_ALIGN  )  /* 17 aligment check*/
f0104c3a:	6a 00                	push   $0x0
f0104c3c:	6a 11                	push   $0x11
f0104c3e:	eb 78                	jmp    f0104cb8 <_alltraps>

f0104c40 <ENTRY_MCHK>:
TRAPHANDLER_NOEC( ENTRY_MCHK    , T_MCHK   )  /* 18 machine check*/
f0104c40:	6a 00                	push   $0x0
f0104c42:	6a 12                	push   $0x12
f0104c44:	eb 72                	jmp    f0104cb8 <_alltraps>

f0104c46 <ENTRY_SIMDERR>:
TRAPHANDLER_NOEC( ENTRY_SIMDERR , T_SIMDERR)  /* 19 SIMD floating point error*/
f0104c46:	6a 00                	push   $0x0
f0104c48:	6a 13                	push   $0x13
f0104c4a:	eb 6c                	jmp    f0104cb8 <_alltraps>

f0104c4c <ENTRY_SYSCALL>:

TRAPHANDLER_NOEC( ENTRY_SYSCALL , T_SYSCALL)  /* 48 system call*/
f0104c4c:	6a 00                	push   $0x0
f0104c4e:	6a 30                	push   $0x30
f0104c50:	eb 66                	jmp    f0104cb8 <_alltraps>

f0104c52 <ENTRY_IRQ_TIMER>:

TRAPHANDLER_NOEC( ENTRY_IRQ_TIMER   , IRQ_OFFSET+IRQ_TIMER   )  /*  0*/
f0104c52:	6a 00                	push   $0x0
f0104c54:	6a 20                	push   $0x20
f0104c56:	eb 60                	jmp    f0104cb8 <_alltraps>

f0104c58 <ENTRY_IRQ_KBD>:
TRAPHANDLER_NOEC( ENTRY_IRQ_KBD     , IRQ_OFFSET+IRQ_KBD     )  /*  1*/
f0104c58:	6a 00                	push   $0x0
f0104c5a:	6a 21                	push   $0x21
f0104c5c:	eb 5a                	jmp    f0104cb8 <_alltraps>

f0104c5e <ENTRY_IRQ_2>:
TRAPHANDLER_NOEC( ENTRY_IRQ_2       , IRQ_OFFSET+    2       )  /*  2*/
f0104c5e:	6a 00                	push   $0x0
f0104c60:	6a 22                	push   $0x22
f0104c62:	eb 54                	jmp    f0104cb8 <_alltraps>

f0104c64 <ENTRY_IRQ_3>:
TRAPHANDLER_NOEC( ENTRY_IRQ_3       , IRQ_OFFSET+    3       )  /*  3*/
f0104c64:	6a 00                	push   $0x0
f0104c66:	6a 23                	push   $0x23
f0104c68:	eb 4e                	jmp    f0104cb8 <_alltraps>

f0104c6a <ENTRY_IRQ_SERIAL>:
TRAPHANDLER_NOEC( ENTRY_IRQ_SERIAL  , IRQ_OFFSET+IRQ_SERIAL  )  /*  4*/
f0104c6a:	6a 00                	push   $0x0
f0104c6c:	6a 24                	push   $0x24
f0104c6e:	eb 48                	jmp    f0104cb8 <_alltraps>

f0104c70 <ENTRY_IRQ_5>:
TRAPHANDLER_NOEC( ENTRY_IRQ_5       , IRQ_OFFSET+    5       )  /*  5*/
f0104c70:	6a 00                	push   $0x0
f0104c72:	6a 25                	push   $0x25
f0104c74:	eb 42                	jmp    f0104cb8 <_alltraps>

f0104c76 <ENTRY_IRQ_6>:
TRAPHANDLER_NOEC( ENTRY_IRQ_6       , IRQ_OFFSET+    6       )  /*  6*/
f0104c76:	6a 00                	push   $0x0
f0104c78:	6a 26                	push   $0x26
f0104c7a:	eb 3c                	jmp    f0104cb8 <_alltraps>

f0104c7c <ENTRY_IRQ_SPURIOUS>:
TRAPHANDLER_NOEC( ENTRY_IRQ_SPURIOUS, IRQ_OFFSET+IRQ_SPURIOUS)  /*  7*/
f0104c7c:	6a 00                	push   $0x0
f0104c7e:	6a 27                	push   $0x27
f0104c80:	eb 36                	jmp    f0104cb8 <_alltraps>

f0104c82 <ENTRY_IRQ_8>:
TRAPHANDLER_NOEC( ENTRY_IRQ_8       , IRQ_OFFSET+    8       )  /*  8*/
f0104c82:	6a 00                	push   $0x0
f0104c84:	6a 28                	push   $0x28
f0104c86:	eb 30                	jmp    f0104cb8 <_alltraps>

f0104c88 <ENTRY_IRQ_9>:
TRAPHANDLER_NOEC( ENTRY_IRQ_9       , IRQ_OFFSET+    9       )  /*  9*/
f0104c88:	6a 00                	push   $0x0
f0104c8a:	6a 29                	push   $0x29
f0104c8c:	eb 2a                	jmp    f0104cb8 <_alltraps>

f0104c8e <ENTRY_IRQ_10>:
TRAPHANDLER_NOEC( ENTRY_IRQ_10      , IRQ_OFFSET+    10      )  /* 10*/
f0104c8e:	6a 00                	push   $0x0
f0104c90:	6a 2a                	push   $0x2a
f0104c92:	eb 24                	jmp    f0104cb8 <_alltraps>

f0104c94 <ENTRY_IRQ_11>:
TRAPHANDLER_NOEC( ENTRY_IRQ_11      , IRQ_OFFSET+    11      )  /* 11*/
f0104c94:	6a 00                	push   $0x0
f0104c96:	6a 2b                	push   $0x2b
f0104c98:	eb 1e                	jmp    f0104cb8 <_alltraps>

f0104c9a <ENTRY_IRQ_12>:
TRAPHANDLER_NOEC( ENTRY_IRQ_12      , IRQ_OFFSET+    12      )  /* 12*/
f0104c9a:	6a 00                	push   $0x0
f0104c9c:	6a 2c                	push   $0x2c
f0104c9e:	eb 18                	jmp    f0104cb8 <_alltraps>

f0104ca0 <ENTRY_IRQ_13>:
TRAPHANDLER_NOEC( ENTRY_IRQ_13      , IRQ_OFFSET+    13      )  /* 13*/
f0104ca0:	6a 00                	push   $0x0
f0104ca2:	6a 2d                	push   $0x2d
f0104ca4:	eb 12                	jmp    f0104cb8 <_alltraps>

f0104ca6 <ENTRY_IRQ_IDE>:
TRAPHANDLER_NOEC( ENTRY_IRQ_IDE     , IRQ_OFFSET+IRQ_IDE     )  /* 14*/
f0104ca6:	6a 00                	push   $0x0
f0104ca8:	6a 2e                	push   $0x2e
f0104caa:	eb 0c                	jmp    f0104cb8 <_alltraps>

f0104cac <ENTRY_IRQ_15>:
TRAPHANDLER_NOEC( ENTRY_IRQ_15      , IRQ_OFFSET+    15      )  /* 15*/
f0104cac:	6a 00                	push   $0x0
f0104cae:	6a 2f                	push   $0x2f
f0104cb0:	eb 06                	jmp    f0104cb8 <_alltraps>

f0104cb2 <ENTRY_IRQ_ERROR>:
TRAPHANDLER_NOEC( ENTRY_IRQ_ERROR   , IRQ_OFFSET+IRQ_ERROR   )  /* 19*/
f0104cb2:	6a 00                	push   $0x0
f0104cb4:	6a 33                	push   $0x33
f0104cb6:	eb 00                	jmp    f0104cb8 <_alltraps>

f0104cb8 <_alltraps>:
.globl _alltraps
.type _alltraps, @function					
.align 2			
_alltraps:
	# Build trap frame
	pushl %ds	# tf_ds
f0104cb8:	1e                   	push   %ds
	pushl %es	# tf_es
f0104cb9:	06                   	push   %es
	pushal
f0104cba:	60                   	pusha  

	# Set up data segments
	movl $GD_KD, %eax
f0104cbb:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds
f0104cc0:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f0104cc2:	8e c0                	mov    %eax,%es

	# Call trap(tf), where tf=%esp
	pushl %esp
f0104cc4:	54                   	push   %esp
	call trap
f0104cc5:	e8 73 fc ff ff       	call   f010493d <trap>

f0104cca <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104cca:	55                   	push   %ebp
f0104ccb:	89 e5                	mov    %esp,%ebp
f0104ccd:	83 ec 08             	sub    $0x8,%esp
f0104cd0:	a1 48 62 35 f0       	mov    0xf0356248,%eax
f0104cd5:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104cd8:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0104cdd:	8b 02                	mov    (%edx),%eax
f0104cdf:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104ce2:	83 f8 02             	cmp    $0x2,%eax
f0104ce5:	76 30                	jbe    f0104d17 <sched_halt+0x4d>
	for (i = 0; i < NENV; i++) {
f0104ce7:	83 c1 01             	add    $0x1,%ecx
f0104cea:	81 c2 90 00 00 00    	add    $0x90,%edx
f0104cf0:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104cf6:	75 e5                	jne    f0104cdd <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104cf8:	83 ec 0c             	sub    $0xc,%esp
f0104cfb:	68 90 8c 10 f0       	push   $0xf0108c90
f0104d00:	e8 b9 f1 ff ff       	call   f0103ebe <cprintf>
f0104d05:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104d08:	83 ec 0c             	sub    $0xc,%esp
f0104d0b:	6a 00                	push   $0x0
f0104d0d:	e8 1d c1 ff ff       	call   f0100e2f <monitor>
f0104d12:	83 c4 10             	add    $0x10,%esp
f0104d15:	eb f1                	jmp    f0104d08 <sched_halt+0x3e>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104d17:	e8 6e 1e 00 00       	call   f0106b8a <cpunum>
f0104d1c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d1f:	c7 80 28 70 35 f0 00 	movl   $0x0,-0xfca8fd8(%eax)
f0104d26:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104d29:	a1 8c 6e 35 f0       	mov    0xf0356e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0104d2e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104d33:	76 50                	jbe    f0104d85 <sched_halt+0xbb>
	return (physaddr_t)kva - KERNBASE;
f0104d35:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104d3a:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104d3d:	e8 48 1e 00 00       	call   f0106b8a <cpunum>
f0104d42:	6b d0 74             	imul   $0x74,%eax,%edx
f0104d45:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104d48:	b8 02 00 00 00       	mov    $0x2,%eax
f0104d4d:	f0 87 82 20 70 35 f0 	lock xchg %eax,-0xfca8fe0(%edx)
	spin_unlock(&kernel_lock);
f0104d54:	83 ec 0c             	sub    $0xc,%esp
f0104d57:	68 c0 53 12 f0       	push   $0xf01253c0
f0104d5c:	e8 35 21 00 00       	call   f0106e96 <spin_unlock>
	asm volatile("pause");
f0104d61:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104d63:	e8 22 1e 00 00       	call   f0106b8a <cpunum>
f0104d68:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104d6b:	8b 80 30 70 35 f0    	mov    -0xfca8fd0(%eax),%eax
f0104d71:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104d76:	89 c4                	mov    %eax,%esp
f0104d78:	6a 00                	push   $0x0
f0104d7a:	6a 00                	push   $0x0
f0104d7c:	fb                   	sti    
f0104d7d:	f4                   	hlt    
f0104d7e:	eb fd                	jmp    f0104d7d <sched_halt+0xb3>
}
f0104d80:	83 c4 10             	add    $0x10,%esp
f0104d83:	c9                   	leave  
f0104d84:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104d85:	50                   	push   %eax
f0104d86:	68 28 72 10 f0       	push   $0xf0107228
f0104d8b:	6a 51                	push   $0x51
f0104d8d:	68 b9 8c 10 f0       	push   $0xf0108cb9
f0104d92:	e8 a9 b2 ff ff       	call   f0100040 <_panic>

f0104d97 <sched_yield>:
{
f0104d97:	55                   	push   %ebp
f0104d98:	89 e5                	mov    %esp,%ebp
f0104d9a:	53                   	push   %ebx
f0104d9b:	83 ec 04             	sub    $0x4,%esp
	if (curenv)
f0104d9e:	e8 e7 1d 00 00       	call   f0106b8a <cpunum>
f0104da3:	6b d0 74             	imul   $0x74,%eax,%edx
		id = -1;
f0104da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if (curenv)
f0104dab:	83 ba 28 70 35 f0 00 	cmpl   $0x0,-0xfca8fd8(%edx)
f0104db2:	74 16                	je     f0104dca <sched_yield+0x33>
		id = ENVX(curenv->env_id);
f0104db4:	e8 d1 1d 00 00       	call   f0106b8a <cpunum>
f0104db9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dbc:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104dc2:	8b 40 48             	mov    0x48(%eax),%eax
f0104dc5:	25 ff 03 00 00       	and    $0x3ff,%eax
		if (envs[id].env_status == ENV_RUNNABLE){
f0104dca:	8b 1d 48 62 35 f0    	mov    0xf0356248,%ebx
f0104dd0:	b9 00 04 00 00       	mov    $0x400,%ecx
		id = ENVX(id+1);
f0104dd5:	83 c0 01             	add    $0x1,%eax
f0104dd8:	25 ff 03 00 00       	and    $0x3ff,%eax
		if (envs[id].env_status == ENV_RUNNABLE){
f0104ddd:	8d 14 c0             	lea    (%eax,%eax,8),%edx
f0104de0:	c1 e2 04             	shl    $0x4,%edx
f0104de3:	01 da                	add    %ebx,%edx
f0104de5:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f0104de9:	74 3a                	je     f0104e25 <sched_yield+0x8e>
	for(int i=0;i<NENV;i++){
f0104deb:	83 e9 01             	sub    $0x1,%ecx
f0104dee:	75 e5                	jne    f0104dd5 <sched_yield+0x3e>
	if(curenv && curenv->env_cpunum==cpunum() && curenv->env_status==ENV_RUNNING){
f0104df0:	e8 95 1d 00 00       	call   f0106b8a <cpunum>
f0104df5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104df8:	83 b8 28 70 35 f0 00 	cmpl   $0x0,-0xfca8fd8(%eax)
f0104dff:	74 1a                	je     f0104e1b <sched_yield+0x84>
f0104e01:	e8 84 1d 00 00       	call   f0106b8a <cpunum>
f0104e06:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e09:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104e0f:	8b 58 60             	mov    0x60(%eax),%ebx
f0104e12:	e8 73 1d 00 00       	call   f0106b8a <cpunum>
f0104e17:	39 c3                	cmp    %eax,%ebx
f0104e19:	74 13                	je     f0104e2e <sched_yield+0x97>
	sched_halt();
f0104e1b:	e8 aa fe ff ff       	call   f0104cca <sched_halt>
}
f0104e20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104e23:	c9                   	leave  
f0104e24:	c3                   	ret    
			env_run(&envs[id]);
f0104e25:	83 ec 0c             	sub    $0xc,%esp
f0104e28:	52                   	push   %edx
f0104e29:	e8 4e ee ff ff       	call   f0103c7c <env_run>
	if(curenv && curenv->env_cpunum==cpunum() && curenv->env_status==ENV_RUNNING){
f0104e2e:	e8 57 1d 00 00       	call   f0106b8a <cpunum>
f0104e33:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e36:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104e3c:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104e40:	75 d9                	jne    f0104e1b <sched_yield+0x84>
		env_run(curenv);
f0104e42:	e8 43 1d 00 00       	call   f0106b8a <cpunum>
f0104e47:	83 ec 0c             	sub    $0xc,%esp
f0104e4a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e4d:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0104e53:	e8 24 ee ff ff       	call   f0103c7c <env_run>

f0104e58 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104e58:	55                   	push   %ebp
f0104e59:	89 e5                	mov    %esp,%ebp
f0104e5b:	57                   	push   %edi
f0104e5c:	56                   	push   %esi
f0104e5d:	53                   	push   %ebx
f0104e5e:	83 ec 2c             	sub    $0x2c,%esp
f0104e61:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	switch (syscallno) {	
f0104e64:	83 f8 10             	cmp    $0x10,%eax
f0104e67:	0f 87 ef 09 00 00    	ja     f010585c <syscall+0xa04>
f0104e6d:	ff 24 85 04 8d 10 f0 	jmp    *-0xfef72fc(,%eax,4)
	user_mem_assert(curenv, (void*)s, len, PTE_U);
f0104e74:	e8 11 1d 00 00       	call   f0106b8a <cpunum>
f0104e79:	6a 04                	push   $0x4
f0104e7b:	ff 75 10             	pushl  0x10(%ebp)
f0104e7e:	ff 75 0c             	pushl  0xc(%ebp)
f0104e81:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e84:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0104e8a:	e8 12 e7 ff ff       	call   f01035a1 <user_mem_assert>
	cprintf("%.*s", len, s);
f0104e8f:	83 c4 0c             	add    $0xc,%esp
f0104e92:	ff 75 0c             	pushl  0xc(%ebp)
f0104e95:	ff 75 10             	pushl  0x10(%ebp)
f0104e98:	68 c6 8c 10 f0       	push   $0xf0108cc6
f0104e9d:	e8 1c f0 ff ff       	call   f0103ebe <cprintf>
f0104ea2:	83 c4 10             	add    $0x10,%esp
		case SYS_cputs:{
			sys_cputs((char*)a1, (size_t)a2);
			return 0;
f0104ea5:	b8 00 00 00 00       	mov    $0x0,%eax
		default:
			return -E_INVAL;
	}

	panic("syscall not implemented");	
}
f0104eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104ead:	5b                   	pop    %ebx
f0104eae:	5e                   	pop    %esi
f0104eaf:	5f                   	pop    %edi
f0104eb0:	5d                   	pop    %ebp
f0104eb1:	c3                   	ret    
	return cons_getc();
f0104eb2:	e8 2c b7 ff ff       	call   f01005e3 <cons_getc>
			return sys_cgetc();
f0104eb7:	eb f1                	jmp    f0104eaa <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104eb9:	83 ec 04             	sub    $0x4,%esp
f0104ebc:	6a 01                	push   $0x1
f0104ebe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104ec1:	50                   	push   %eax
f0104ec2:	ff 75 0c             	pushl  0xc(%ebp)
f0104ec5:	e8 a7 e7 ff ff       	call   f0103671 <envid2env>
f0104eca:	83 c4 10             	add    $0x10,%esp
f0104ecd:	85 c0                	test   %eax,%eax
f0104ecf:	78 d9                	js     f0104eaa <syscall+0x52>
	env_destroy(e);
f0104ed1:	83 ec 0c             	sub    $0xc,%esp
f0104ed4:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104ed7:	e8 01 ed ff ff       	call   f0103bdd <env_destroy>
f0104edc:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104edf:	b8 00 00 00 00       	mov    $0x0,%eax
			return sys_env_destroy((envid_t)a1);
f0104ee4:	eb c4                	jmp    f0104eaa <syscall+0x52>
	return curenv->env_id;
f0104ee6:	e8 9f 1c 00 00       	call   f0106b8a <cpunum>
f0104eeb:	6b c0 74             	imul   $0x74,%eax,%eax
f0104eee:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104ef4:	8b 40 48             	mov    0x48(%eax),%eax
			return sys_getenvid();
f0104ef7:	eb b1                	jmp    f0104eaa <syscall+0x52>
	if ((uint32_t)kva < KERNBASE)
f0104ef9:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f0104f00:	76 48                	jbe    f0104f4a <syscall+0xf2>
	return (physaddr_t)kva - KERNBASE;
f0104f02:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104f05:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0104f0a:	c1 e8 0c             	shr    $0xc,%eax
f0104f0d:	3b 05 88 6e 35 f0    	cmp    0xf0356e88,%eax
f0104f13:	73 4c                	jae    f0104f61 <syscall+0x109>
	return &pages[PGNUM(pa)];
f0104f15:	8b 15 90 6e 35 f0    	mov    0xf0356e90,%edx
f0104f1b:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f0104f1e:	85 db                	test   %ebx,%ebx
f0104f20:	0f 84 40 09 00 00    	je     f0105866 <syscall+0xa0e>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f0104f26:	e8 5f 1c 00 00       	call   f0106b8a <cpunum>
f0104f2b:	6a 06                	push   $0x6
f0104f2d:	ff 75 10             	pushl  0x10(%ebp)
f0104f30:	53                   	push   %ebx
f0104f31:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f34:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104f3a:	ff 70 64             	pushl  0x64(%eax)
f0104f3d:	e8 4a c8 ff ff       	call   f010178c <page_insert>
f0104f42:	83 c4 10             	add    $0x10,%esp
f0104f45:	e9 60 ff ff ff       	jmp    f0104eaa <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104f4a:	ff 75 0c             	pushl  0xc(%ebp)
f0104f4d:	68 28 72 10 f0       	push   $0xf0107228
f0104f52:	68 08 02 00 00       	push   $0x208
f0104f57:	68 cb 8c 10 f0       	push   $0xf0108ccb
f0104f5c:	e8 df b0 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0104f61:	83 ec 04             	sub    $0x4,%esp
f0104f64:	68 d4 7b 10 f0       	push   $0xf0107bd4
f0104f69:	6a 51                	push   $0x51
f0104f6b:	68 ad 84 10 f0       	push   $0xf01084ad
f0104f70:	e8 cb b0 ff ff       	call   f0100040 <_panic>
	region_alloc(curenv, (void*)curenv->env_brk-inc, inc);
f0104f75:	e8 10 1c 00 00       	call   f0106b8a <cpunum>
f0104f7a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f7d:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0104f83:	8b 58 5c             	mov    0x5c(%eax),%ebx
f0104f86:	2b 5d 0c             	sub    0xc(%ebp),%ebx
f0104f89:	e8 fc 1b 00 00       	call   f0106b8a <cpunum>
f0104f8e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f91:	8b b8 28 70 35 f0    	mov    -0xfca8fd8(%eax),%edi
	va = ROUNDDOWN(va, PGSIZE);	
f0104f97:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int n = (ROUNDUP(va+len, PGSIZE) - va) / PGSIZE;
f0104f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104fa0:	8d 84 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%eax
f0104fa7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0104fac:	29 d8                	sub    %ebx,%eax
f0104fae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0104fb4:	0f 48 c2             	cmovs  %edx,%eax
f0104fb7:	c1 f8 0c             	sar    $0xc,%eax
f0104fba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for(int i=0;i<n;i++){
f0104fbd:	be 00 00 00 00       	mov    $0x0,%esi
f0104fc2:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f0104fc5:	7e 42                	jle    f0105009 <syscall+0x1b1>
		struct PageInfo* pp = page_alloc(ALLOC_ZERO);
f0104fc7:	83 ec 0c             	sub    $0xc,%esp
f0104fca:	6a 01                	push   $0x1
f0104fcc:	e8 0a c4 ff ff       	call   f01013db <page_alloc>
		if(!pp)
f0104fd1:	83 c4 10             	add    $0x10,%esp
f0104fd4:	85 c0                	test   %eax,%eax
f0104fd6:	74 1a                	je     f0104ff2 <syscall+0x19a>
		page_insert(e->env_pgdir, pp, va, PTE_U|PTE_W);
f0104fd8:	6a 06                	push   $0x6
f0104fda:	53                   	push   %ebx
f0104fdb:	50                   	push   %eax
f0104fdc:	ff 77 64             	pushl  0x64(%edi)
f0104fdf:	e8 a8 c7 ff ff       	call   f010178c <page_insert>
		va += PGSIZE;
f0104fe4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for(int i=0;i<n;i++){
f0104fea:	83 c6 01             	add    $0x1,%esi
f0104fed:	83 c4 10             	add    $0x10,%esp
f0104ff0:	eb d0                	jmp    f0104fc2 <syscall+0x16a>
			panic("region_alloc: pp is NULL!");
f0104ff2:	83 ec 04             	sub    $0x4,%esp
f0104ff5:	68 ef 87 10 f0       	push   $0xf01087ef
f0104ffa:	68 17 02 00 00       	push   $0x217
f0104fff:	68 cb 8c 10 f0       	push   $0xf0108ccb
f0105004:	e8 37 b0 ff ff       	call   f0100040 <_panic>
	curenv->env_brk = (uintptr_t)ROUNDDOWN(curenv->env_brk-inc, PGSIZE);
f0105009:	e8 7c 1b 00 00       	call   f0106b8a <cpunum>
f010500e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105011:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105017:	8b 58 5c             	mov    0x5c(%eax),%ebx
f010501a:	2b 5d 0c             	sub    0xc(%ebp),%ebx
f010501d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0105023:	e8 62 1b 00 00       	call   f0106b8a <cpunum>
f0105028:	6b c0 74             	imul   $0x74,%eax,%eax
f010502b:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105031:	89 58 5c             	mov    %ebx,0x5c(%eax)
    return curenv->env_brk;
f0105034:	e8 51 1b 00 00       	call   f0106b8a <cpunum>
f0105039:	6b c0 74             	imul   $0x74,%eax,%eax
f010503c:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105042:	8b 40 5c             	mov    0x5c(%eax),%eax
			return sys_sbrk((uint32_t)a1);
f0105045:	e9 60 fe ff ff       	jmp    f0104eaa <syscall+0x52>
	sched_yield();
f010504a:	e8 48 fd ff ff       	call   f0104d97 <sched_yield>
	int r = env_alloc(&e, curenv->env_id);
f010504f:	e8 36 1b 00 00       	call   f0106b8a <cpunum>
f0105054:	83 ec 08             	sub    $0x8,%esp
f0105057:	6b c0 74             	imul   $0x74,%eax,%eax
f010505a:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105060:	ff 70 48             	pushl  0x48(%eax)
f0105063:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105066:	50                   	push   %eax
f0105067:	e8 15 e7 ff ff       	call   f0103781 <env_alloc>
	if(r < 0)return r;
f010506c:	83 c4 10             	add    $0x10,%esp
f010506f:	85 c0                	test   %eax,%eax
f0105071:	0f 88 33 fe ff ff    	js     f0104eaa <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f0105077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010507a:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_brk = curenv->env_brk;
f0105081:	e8 04 1b 00 00       	call   f0106b8a <cpunum>
f0105086:	6b c0 74             	imul   $0x74,%eax,%eax
f0105089:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010508f:	8b 50 5c             	mov    0x5c(%eax),%edx
f0105092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105095:	89 50 5c             	mov    %edx,0x5c(%eax)
	e->env_tf = curenv->env_tf;
f0105098:	e8 ed 1a 00 00       	call   f0106b8a <cpunum>
f010509d:	6b c0 74             	imul   $0x74,%eax,%eax
f01050a0:	8b b0 28 70 35 f0    	mov    -0xfca8fd8(%eax),%esi
f01050a6:	b9 11 00 00 00       	mov    $0x11,%ecx
f01050ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01050ae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01050b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01050b3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01050ba:	8b 40 48             	mov    0x48(%eax),%eax
			return sys_exofork();
f01050bd:	e9 e8 fd ff ff       	jmp    f0104eaa <syscall+0x52>
	int r = envid2env(envid, &e, 1);
f01050c2:	83 ec 04             	sub    $0x4,%esp
f01050c5:	6a 01                	push   $0x1
f01050c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01050ca:	50                   	push   %eax
f01050cb:	ff 75 0c             	pushl  0xc(%ebp)
f01050ce:	e8 9e e5 ff ff       	call   f0103671 <envid2env>
	if(r < 0)
f01050d3:	83 c4 10             	add    $0x10,%esp
f01050d6:	85 c0                	test   %eax,%eax
f01050d8:	78 20                	js     f01050fa <syscall+0x2a2>
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
f01050da:	8b 45 10             	mov    0x10(%ebp),%eax
f01050dd:	83 e8 02             	sub    $0x2,%eax
f01050e0:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01050e5:	75 1d                	jne    f0105104 <syscall+0x2ac>
	e->env_status = status;
f01050e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01050ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01050ed:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f01050f0:	b8 00 00 00 00       	mov    $0x0,%eax
f01050f5:	e9 b0 fd ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_BAD_ENV;
f01050fa:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01050ff:	e9 a6 fd ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_INVAL;
f0105104:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			return sys_env_set_status((envid_t)a1, (int)a2);
f0105109:	e9 9c fd ff ff       	jmp    f0104eaa <syscall+0x52>
	int r = envid2env(envid, &e, 1);
f010510e:	83 ec 04             	sub    $0x4,%esp
f0105111:	6a 01                	push   $0x1
f0105113:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105116:	50                   	push   %eax
f0105117:	ff 75 0c             	pushl  0xc(%ebp)
f010511a:	e8 52 e5 ff ff       	call   f0103671 <envid2env>
	if(r < 0)
f010511f:	83 c4 10             	add    $0x10,%esp
f0105122:	85 c0                	test   %eax,%eax
f0105124:	78 13                	js     f0105139 <syscall+0x2e1>
	e->env_pgfault_upcall = func;
f0105126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105129:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010512c:	89 48 68             	mov    %ecx,0x68(%eax)
	return 0;
f010512f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105134:	e9 71 fd ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_BAD_ENV;
f0105139:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
			return sys_env_set_pgfault_upcall((envid_t)a1, (void*)a2);
f010513e:	e9 67 fd ff ff       	jmp    f0104eaa <syscall+0x52>
	if(envid2env(envid, &e, 1) < 0)
f0105143:	83 ec 04             	sub    $0x4,%esp
f0105146:	6a 01                	push   $0x1
f0105148:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010514b:	50                   	push   %eax
f010514c:	ff 75 0c             	pushl  0xc(%ebp)
f010514f:	e8 1d e5 ff ff       	call   f0103671 <envid2env>
f0105154:	83 c4 10             	add    $0x10,%esp
f0105157:	85 c0                	test   %eax,%eax
f0105159:	78 6b                	js     f01051c6 <syscall+0x36e>
	if((uintptr_t)va >= UTOP || PGOFF(va))
f010515b:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105162:	77 6c                	ja     f01051d0 <syscall+0x378>
f0105164:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f010516b:	75 6d                	jne    f01051da <syscall+0x382>
	if(!(perm & PTE_U) || !(perm & PTE_P) || (perm & ~PTE_SYSCALL))
f010516d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105170:	25 fd f1 ff ff       	and    $0xfffff1fd,%eax
f0105175:	83 f8 05             	cmp    $0x5,%eax
f0105178:	75 6a                	jne    f01051e4 <syscall+0x38c>
	struct PageInfo* pp = page_alloc(ALLOC_ZERO);
f010517a:	83 ec 0c             	sub    $0xc,%esp
f010517d:	6a 01                	push   $0x1
f010517f:	e8 57 c2 ff ff       	call   f01013db <page_alloc>
f0105184:	89 c3                	mov    %eax,%ebx
	if(!pp)
f0105186:	83 c4 10             	add    $0x10,%esp
f0105189:	85 c0                	test   %eax,%eax
f010518b:	74 61                	je     f01051ee <syscall+0x396>
	if(page_insert(e->env_pgdir, pp, va, perm) < 0){
f010518d:	ff 75 14             	pushl  0x14(%ebp)
f0105190:	ff 75 10             	pushl  0x10(%ebp)
f0105193:	50                   	push   %eax
f0105194:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105197:	ff 70 64             	pushl  0x64(%eax)
f010519a:	e8 ed c5 ff ff       	call   f010178c <page_insert>
f010519f:	83 c4 10             	add    $0x10,%esp
f01051a2:	85 c0                	test   %eax,%eax
f01051a4:	78 0a                	js     f01051b0 <syscall+0x358>
	return 0;
f01051a6:	b8 00 00 00 00       	mov    $0x0,%eax
			return sys_page_alloc((envid_t)a1, (void*)a2, (int)a3);
f01051ab:	e9 fa fc ff ff       	jmp    f0104eaa <syscall+0x52>
		page_free(pp);
f01051b0:	83 ec 0c             	sub    $0xc,%esp
f01051b3:	53                   	push   %ebx
f01051b4:	e8 94 c2 ff ff       	call   f010144d <page_free>
f01051b9:	83 c4 10             	add    $0x10,%esp
		return -E_NO_MEM;
f01051bc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01051c1:	e9 e4 fc ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_BAD_ENV;
f01051c6:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01051cb:	e9 da fc ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_INVAL;
f01051d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01051d5:	e9 d0 fc ff ff       	jmp    f0104eaa <syscall+0x52>
f01051da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01051df:	e9 c6 fc ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_INVAL;
f01051e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01051e9:	e9 bc fc ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_NO_MEM;
f01051ee:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01051f3:	e9 b2 fc ff ff       	jmp    f0104eaa <syscall+0x52>
	if(envid2env(srcenvid, &src_e, 1) < 0 || envid2env(dstenvid, &dst_e, 1) < 0)
f01051f8:	83 ec 04             	sub    $0x4,%esp
f01051fb:	6a 01                	push   $0x1
f01051fd:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105200:	50                   	push   %eax
f0105201:	ff 75 0c             	pushl  0xc(%ebp)
f0105204:	e8 68 e4 ff ff       	call   f0103671 <envid2env>
f0105209:	83 c4 10             	add    $0x10,%esp
f010520c:	85 c0                	test   %eax,%eax
f010520e:	0f 88 fd 00 00 00    	js     f0105311 <syscall+0x4b9>
f0105214:	83 ec 04             	sub    $0x4,%esp
f0105217:	6a 01                	push   $0x1
f0105219:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010521c:	50                   	push   %eax
f010521d:	ff 75 14             	pushl  0x14(%ebp)
f0105220:	e8 4c e4 ff ff       	call   f0103671 <envid2env>
f0105225:	83 c4 10             	add    $0x10,%esp
f0105228:	85 c0                	test   %eax,%eax
f010522a:	0f 88 eb 00 00 00    	js     f010531b <syscall+0x4c3>
	if((uintptr_t)srcva >= UTOP || PGOFF(srcva) ||
f0105230:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105237:	77 6d                	ja     f01052a6 <syscall+0x44e>
f0105239:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0105240:	77 64                	ja     f01052a6 <syscall+0x44e>
		(uintptr_t)dstva >= UTOP || PGOFF(dstva)){
f0105242:	8b 45 10             	mov    0x10(%ebp),%eax
f0105245:	0b 45 18             	or     0x18(%ebp),%eax
f0105248:	a9 ff 0f 00 00       	test   $0xfff,%eax
f010524d:	75 57                	jne    f01052a6 <syscall+0x44e>
	if(!(perm & PTE_U) || !(perm & PTE_P) || (perm & ~PTE_SYSCALL)){
f010524f:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105252:	25 fd f1 ff ff       	and    $0xfffff1fd,%eax
f0105257:	83 f8 05             	cmp    $0x5,%eax
f010525a:	75 64                	jne    f01052c0 <syscall+0x468>
	struct PageInfo* src_pp = page_lookup(src_e->env_pgdir, srcva, &pte);
f010525c:	83 ec 04             	sub    $0x4,%esp
f010525f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105262:	50                   	push   %eax
f0105263:	ff 75 10             	pushl  0x10(%ebp)
f0105266:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105269:	ff 70 64             	pushl  0x64(%eax)
f010526c:	e8 05 c4 ff ff       	call   f0101676 <page_lookup>
	if(!src_pp){
f0105271:	83 c4 10             	add    $0x10,%esp
f0105274:	85 c0                	test   %eax,%eax
f0105276:	74 65                	je     f01052dd <syscall+0x485>
	if((perm & PTE_W) && !(*pte & PTE_W)){
f0105278:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f010527c:	74 08                	je     f0105286 <syscall+0x42e>
f010527e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105281:	f6 02 02             	testb  $0x2,(%edx)
f0105284:	74 71                	je     f01052f7 <syscall+0x49f>
	if(page_insert(dst_e->env_pgdir, src_pp, dstva, perm) < 0)
f0105286:	ff 75 1c             	pushl  0x1c(%ebp)
f0105289:	ff 75 18             	pushl  0x18(%ebp)
f010528c:	50                   	push   %eax
f010528d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105290:	ff 70 64             	pushl  0x64(%eax)
f0105293:	e8 f4 c4 ff ff       	call   f010178c <page_insert>
f0105298:	83 c4 10             	add    $0x10,%esp
		return -E_NO_MEM;
f010529b:	c1 f8 1f             	sar    $0x1f,%eax
f010529e:	83 e0 fc             	and    $0xfffffffc,%eax
f01052a1:	e9 04 fc ff ff       	jmp    f0104eaa <syscall+0x52>
		cprintf("1\n");
f01052a6:	83 ec 0c             	sub    $0xc,%esp
f01052a9:	68 da 8c 10 f0       	push   $0xf0108cda
f01052ae:	e8 0b ec ff ff       	call   f0103ebe <cprintf>
f01052b3:	83 c4 10             	add    $0x10,%esp
		return -E_INVAL;
f01052b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01052bb:	e9 ea fb ff ff       	jmp    f0104eaa <syscall+0x52>
		cprintf("2 perm:%d\n", perm);
f01052c0:	83 ec 08             	sub    $0x8,%esp
f01052c3:	ff 75 1c             	pushl  0x1c(%ebp)
f01052c6:	68 dd 8c 10 f0       	push   $0xf0108cdd
f01052cb:	e8 ee eb ff ff       	call   f0103ebe <cprintf>
f01052d0:	83 c4 10             	add    $0x10,%esp
		return -E_INVAL;
f01052d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01052d8:	e9 cd fb ff ff       	jmp    f0104eaa <syscall+0x52>
		cprintf("3\n");
f01052dd:	83 ec 0c             	sub    $0xc,%esp
f01052e0:	68 e8 8c 10 f0       	push   $0xf0108ce8
f01052e5:	e8 d4 eb ff ff       	call   f0103ebe <cprintf>
f01052ea:	83 c4 10             	add    $0x10,%esp
		return -E_INVAL;
f01052ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01052f2:	e9 b3 fb ff ff       	jmp    f0104eaa <syscall+0x52>
		cprintf("4\n");
f01052f7:	83 ec 0c             	sub    $0xc,%esp
f01052fa:	68 eb 8c 10 f0       	push   $0xf0108ceb
f01052ff:	e8 ba eb ff ff       	call   f0103ebe <cprintf>
f0105304:	83 c4 10             	add    $0x10,%esp
		return -E_INVAL;
f0105307:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010530c:	e9 99 fb ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_BAD_ENV;
f0105311:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105316:	e9 8f fb ff ff       	jmp    f0104eaa <syscall+0x52>
f010531b:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105320:	e9 85 fb ff ff       	jmp    f0104eaa <syscall+0x52>
	if ((r = envid2env(envid, &env, 1)) < 0)
f0105325:	83 ec 04             	sub    $0x4,%esp
f0105328:	6a 01                	push   $0x1
f010532a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010532d:	50                   	push   %eax
f010532e:	ff 75 0c             	pushl  0xc(%ebp)
f0105331:	e8 3b e3 ff ff       	call   f0103671 <envid2env>
f0105336:	83 c4 10             	add    $0x10,%esp
f0105339:	85 c0                	test   %eax,%eax
f010533b:	0f 88 69 fb ff ff    	js     f0104eaa <syscall+0x52>
	if ((uintptr_t)va >= UTOP || (uintptr_t)va % PGSIZE)
f0105341:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105348:	77 4c                	ja     f0105396 <syscall+0x53e>
f010534a:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105351:	75 4d                	jne    f01053a0 <syscall+0x548>
	if (!(page = page_lookup(env->env_pgdir, va, NULL)))
f0105353:	83 ec 04             	sub    $0x4,%esp
f0105356:	6a 00                	push   $0x0
f0105358:	ff 75 10             	pushl  0x10(%ebp)
f010535b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010535e:	ff 70 64             	pushl  0x64(%eax)
f0105361:	e8 10 c3 ff ff       	call   f0101676 <page_lookup>
f0105366:	89 c2                	mov    %eax,%edx
f0105368:	83 c4 10             	add    $0x10,%esp
		return 0;
f010536b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(page = page_lookup(env->env_pgdir, va, NULL)))
f0105370:	85 d2                	test   %edx,%edx
f0105372:	0f 84 32 fb ff ff    	je     f0104eaa <syscall+0x52>
	page_remove(env->env_pgdir, va);
f0105378:	83 ec 08             	sub    $0x8,%esp
f010537b:	ff 75 10             	pushl  0x10(%ebp)
f010537e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105381:	ff 70 64             	pushl  0x64(%eax)
f0105384:	e8 a2 c3 ff ff       	call   f010172b <page_remove>
f0105389:	83 c4 10             	add    $0x10,%esp
	return 0;
f010538c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105391:	e9 14 fb ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_INVAL;
f0105396:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010539b:	e9 0a fb ff ff       	jmp    f0104eaa <syscall+0x52>
f01053a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01053a5:	e9 00 fb ff ff       	jmp    f0104eaa <syscall+0x52>
	if(envid2env(envid, &e, 0)  < 0)
f01053aa:	83 ec 04             	sub    $0x4,%esp
f01053ad:	6a 00                	push   $0x0
f01053af:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01053b2:	50                   	push   %eax
f01053b3:	ff 75 0c             	pushl  0xc(%ebp)
f01053b6:	e8 b6 e2 ff ff       	call   f0103671 <envid2env>
f01053bb:	83 c4 10             	add    $0x10,%esp
f01053be:	85 c0                	test   %eax,%eax
f01053c0:	0f 88 d9 01 00 00    	js     f010559f <syscall+0x747>
	if (e->env_ipc_recving){
f01053c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01053c9:	80 78 6c 00          	cmpb   $0x0,0x6c(%eax)
f01053cd:	0f 84 e1 00 00 00    	je     f01054b4 <syscall+0x65c>
		if(srcva < (void*)UTOP ){
f01053d3:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01053da:	0f 87 88 00 00 00    	ja     f0105468 <syscall+0x610>
				return -E_INVAL;
f01053e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			if(PGOFF(srcva)){
f01053e5:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f01053ec:	0f 85 b8 fa ff ff    	jne    f0104eaa <syscall+0x52>
			if(!(perm & PTE_U) || !(perm & PTE_P) || (perm & ~PTE_SYSCALL))
f01053f2:	8b 55 18             	mov    0x18(%ebp),%edx
f01053f5:	81 e2 fd f1 ff ff    	and    $0xfffff1fd,%edx
f01053fb:	83 fa 05             	cmp    $0x5,%edx
f01053fe:	0f 85 a6 fa ff ff    	jne    f0104eaa <syscall+0x52>
			struct PageInfo *pp = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105404:	e8 81 17 00 00       	call   f0106b8a <cpunum>
f0105409:	83 ec 04             	sub    $0x4,%esp
f010540c:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010540f:	52                   	push   %edx
f0105410:	ff 75 14             	pushl  0x14(%ebp)
f0105413:	6b c0 74             	imul   $0x74,%eax,%eax
f0105416:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010541c:	ff 70 64             	pushl  0x64(%eax)
f010541f:	e8 52 c2 ff ff       	call   f0101676 <page_lookup>
f0105424:	89 c2                	mov    %eax,%edx
			if(!pp)
f0105426:	83 c4 10             	add    $0x10,%esp
f0105429:	85 c0                	test   %eax,%eax
f010542b:	74 7d                	je     f01054aa <syscall+0x652>
			if ((perm & PTE_W) && !(*pte & PTE_W))
f010542d:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105431:	74 11                	je     f0105444 <syscall+0x5ec>
				return -E_INVAL;
f0105433:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			if ((perm & PTE_W) && !(*pte & PTE_W))
f0105438:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010543b:	f6 01 02             	testb  $0x2,(%ecx)
f010543e:	0f 84 66 fa ff ff    	je     f0104eaa <syscall+0x52>
			if(page_insert(e->env_pgdir, pp, e->env_ipc_dstva, perm) < 0)
f0105444:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105447:	ff 75 18             	pushl  0x18(%ebp)
f010544a:	ff 70 70             	pushl  0x70(%eax)
f010544d:	52                   	push   %edx
f010544e:	ff 70 64             	pushl  0x64(%eax)
f0105451:	e8 36 c3 ff ff       	call   f010178c <page_insert>
f0105456:	89 c2                	mov    %eax,%edx
f0105458:	83 c4 10             	add    $0x10,%esp
				return -E_NO_MEM;
f010545b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
			if(page_insert(e->env_pgdir, pp, e->env_ipc_dstva, perm) < 0)
f0105460:	85 d2                	test   %edx,%edx
f0105462:	0f 88 42 fa ff ff    	js     f0104eaa <syscall+0x52>
		e->env_ipc_recving = 0;	
f0105468:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010546b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
		e->env_ipc_from = curenv->env_id;
f010546f:	e8 16 17 00 00       	call   f0106b8a <cpunum>
f0105474:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105477:	6b c0 74             	imul   $0x74,%eax,%eax
f010547a:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105480:	8b 40 48             	mov    0x48(%eax),%eax
f0105483:	89 42 78             	mov    %eax,0x78(%edx)
		e->env_ipc_value = value;
f0105486:	8b 45 10             	mov    0x10(%ebp),%eax
f0105489:	89 42 74             	mov    %eax,0x74(%edx)
		e->env_ipc_perm = perm;
f010548c:	8b 45 18             	mov    0x18(%ebp),%eax
f010548f:	89 42 7c             	mov    %eax,0x7c(%edx)
		e->env_status = ENV_RUNNABLE;
f0105492:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
		e->env_tf.tf_regs.reg_eax = 0;
f0105499:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
		return 0;
f01054a0:	b8 00 00 00 00       	mov    $0x0,%eax
f01054a5:	e9 00 fa ff ff       	jmp    f0104eaa <syscall+0x52>
				return -E_INVAL;
f01054aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01054af:	e9 f6 f9 ff ff       	jmp    f0104eaa <syscall+0x52>
		curenv->env_pending_page = NULL;
f01054b4:	e8 d1 16 00 00       	call   f0106b8a <cpunum>
f01054b9:	6b c0 74             	imul   $0x74,%eax,%eax
f01054bc:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01054c2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
f01054c9:	00 00 00 
		if(srcva < (void*)UTOP ){
f01054cc:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01054d3:	77 6b                	ja     f0105540 <syscall+0x6e8>
			if(PGOFF(srcva)){
f01054d5:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f01054dc:	75 44                	jne    f0105522 <syscall+0x6ca>
			if(!(perm & PTE_U) || !(perm & PTE_P) || (perm & ~PTE_SYSCALL))
f01054de:	8b 45 18             	mov    0x18(%ebp),%eax
f01054e1:	25 fd f1 ff ff       	and    $0xfffff1fd,%eax
f01054e6:	83 f8 05             	cmp    $0x5,%eax
f01054e9:	75 37                	jne    f0105522 <syscall+0x6ca>
			struct PageInfo *pp = page_lookup(curenv->env_pgdir, srcva, &pte);
f01054eb:	e8 9a 16 00 00       	call   f0106b8a <cpunum>
f01054f0:	83 ec 04             	sub    $0x4,%esp
f01054f3:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01054f6:	52                   	push   %edx
f01054f7:	ff 75 14             	pushl  0x14(%ebp)
f01054fa:	6b c0 74             	imul   $0x74,%eax,%eax
f01054fd:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105503:	ff 70 64             	pushl  0x64(%eax)
f0105506:	e8 6b c1 ff ff       	call   f0101676 <page_lookup>
f010550b:	89 c3                	mov    %eax,%ebx
			if(!pp)
f010550d:	83 c4 10             	add    $0x10,%esp
f0105510:	85 c0                	test   %eax,%eax
f0105512:	74 0e                	je     f0105522 <syscall+0x6ca>
			if ((perm & PTE_W) && !(*pte & PTE_W))
f0105514:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105518:	74 12                	je     f010552c <syscall+0x6d4>
f010551a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010551d:	f6 00 02             	testb  $0x2,(%eax)
f0105520:	75 0a                	jne    f010552c <syscall+0x6d4>
				return -E_INVAL;
f0105522:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105527:	e9 7e f9 ff ff       	jmp    f0104eaa <syscall+0x52>
			curenv->env_pending_page = pp;
f010552c:	e8 59 16 00 00       	call   f0106b8a <cpunum>
f0105531:	6b c0 74             	imul   $0x74,%eax,%eax
f0105534:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010553a:	89 98 80 00 00 00    	mov    %ebx,0x80(%eax)
		curenv->env_ipc_pending_perm = perm;
f0105540:	e8 45 16 00 00       	call   f0106b8a <cpunum>
f0105545:	6b c0 74             	imul   $0x74,%eax,%eax
f0105548:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010554e:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105551:	89 88 8c 00 00 00    	mov    %ecx,0x8c(%eax)
		curenv->env_ipc_pending_to = envid;
f0105557:	e8 2e 16 00 00       	call   f0106b8a <cpunum>
f010555c:	6b c0 74             	imul   $0x74,%eax,%eax
f010555f:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105565:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105568:	89 88 88 00 00 00    	mov    %ecx,0x88(%eax)
		curenv->env_ipc_pending_value = value;
f010556e:	e8 17 16 00 00       	call   f0106b8a <cpunum>
f0105573:	6b c0 74             	imul   $0x74,%eax,%eax
f0105576:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010557c:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010557f:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
		curenv->env_status = ENV_NOT_RUNNABLE;
f0105585:	e8 00 16 00 00       	call   f0106b8a <cpunum>
f010558a:	6b c0 74             	imul   $0x74,%eax,%eax
f010558d:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105593:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
		sched_yield();
f010559a:	e8 f8 f7 ff ff       	call   f0104d97 <sched_yield>
		return -E_BAD_ENV;
f010559f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
			return sys_ipc_try_send((envid_t)a1, (uint32_t)a2, (void *)a3, (unsigned)a4);
f01055a4:	e9 01 f9 ff ff       	jmp    f0104eaa <syscall+0x52>
	if(dstva < (void*)UTOP){
f01055a9:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f01055b0:	77 1d                	ja     f01055cf <syscall+0x777>
		if(PGOFF(dstva)){
f01055b2:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f01055b9:	75 1b                	jne    f01055d6 <syscall+0x77e>
		curenv->env_ipc_dstva = dstva;
f01055bb:	e8 ca 15 00 00       	call   f0106b8a <cpunum>
f01055c0:	6b c0 74             	imul   $0x74,%eax,%eax
f01055c3:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01055c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01055cc:	89 48 70             	mov    %ecx,0x70(%eax)
		return -E_BAD_ENV;
f01055cf:	bb 00 00 00 00       	mov    $0x0,%ebx
f01055d4:	eb 2c                	jmp    f0105602 <syscall+0x7aa>
			cprintf("sys_ipc_recv: bug\n");
f01055d6:	83 ec 0c             	sub    $0xc,%esp
f01055d9:	68 ee 8c 10 f0       	push   $0xf0108cee
f01055de:	e8 db e8 ff ff       	call   f0103ebe <cprintf>
f01055e3:	83 c4 10             	add    $0x10,%esp
			return -E_INVAL;
f01055e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01055eb:	e9 ba f8 ff ff       	jmp    f0104eaa <syscall+0x52>
f01055f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
	for (int i = 0; i < NENV; i++) {
f01055f6:	81 fb 00 40 02 00    	cmp    $0x24000,%ebx
f01055fc:	0f 84 dc 00 00 00    	je     f01056de <syscall+0x886>
		struct Env* env = &envs[i];		
f0105602:	89 de                	mov    %ebx,%esi
f0105604:	03 35 48 62 35 f0    	add    0xf0356248,%esi
		if (env->env_status == ENV_NOT_RUNNABLE && env->env_ipc_pending_to == curenv->env_id) { 
f010560a:	83 7e 54 04          	cmpl   $0x4,0x54(%esi)
f010560e:	75 e0                	jne    f01055f0 <syscall+0x798>
f0105610:	8b be 88 00 00 00    	mov    0x88(%esi),%edi
f0105616:	e8 6f 15 00 00       	call   f0106b8a <cpunum>
f010561b:	6b c0 74             	imul   $0x74,%eax,%eax
f010561e:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105624:	3b 78 48             	cmp    0x48(%eax),%edi
f0105627:	75 c7                	jne    f01055f0 <syscall+0x798>
			if (env->env_pending_page && dstva < (void*)UTOP) {
f0105629:	8b 9e 80 00 00 00    	mov    0x80(%esi),%ebx
f010562f:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105636:	77 30                	ja     f0105668 <syscall+0x810>
f0105638:	85 db                	test   %ebx,%ebx
f010563a:	74 2c                	je     f0105668 <syscall+0x810>
				if (page_insert(curenv->env_pgdir, env->env_pending_page, dstva, env->env_ipc_pending_perm) < 0)
f010563c:	8b be 8c 00 00 00    	mov    0x8c(%esi),%edi
f0105642:	e8 43 15 00 00       	call   f0106b8a <cpunum>
f0105647:	57                   	push   %edi
f0105648:	ff 75 0c             	pushl  0xc(%ebp)
f010564b:	53                   	push   %ebx
f010564c:	6b c0 74             	imul   $0x74,%eax,%eax
f010564f:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105655:	ff 70 64             	pushl  0x64(%eax)
f0105658:	e8 2f c1 ff ff       	call   f010178c <page_insert>
f010565d:	83 c4 10             	add    $0x10,%esp
f0105660:	85 c0                	test   %eax,%eax
f0105662:	0f 88 08 02 00 00    	js     f0105870 <syscall+0xa18>
			curenv->env_ipc_recving = 0;	
f0105668:	e8 1d 15 00 00       	call   f0106b8a <cpunum>
f010566d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105670:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105676:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
			curenv->env_ipc_from = env->env_id;
f010567a:	e8 0b 15 00 00       	call   f0106b8a <cpunum>
f010567f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105682:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105688:	8b 56 48             	mov    0x48(%esi),%edx
f010568b:	89 50 78             	mov    %edx,0x78(%eax)
			curenv->env_ipc_value = env->env_ipc_pending_value;
f010568e:	e8 f7 14 00 00       	call   f0106b8a <cpunum>
f0105693:	6b c0 74             	imul   $0x74,%eax,%eax
f0105696:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010569c:	8b 96 84 00 00 00    	mov    0x84(%esi),%edx
f01056a2:	89 50 74             	mov    %edx,0x74(%eax)
			curenv->env_ipc_perm = env->env_ipc_pending_perm;
f01056a5:	e8 e0 14 00 00       	call   f0106b8a <cpunum>
f01056aa:	6b c0 74             	imul   $0x74,%eax,%eax
f01056ad:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01056b3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
f01056b9:	89 50 7c             	mov    %edx,0x7c(%eax)
			env->env_ipc_pending_to = -1;
f01056bc:	c7 86 88 00 00 00 ff 	movl   $0xffffffff,0x88(%esi)
f01056c3:	ff ff ff 
			env->env_status = ENV_RUNNABLE;
f01056c6:	c7 46 54 02 00 00 00 	movl   $0x2,0x54(%esi)
			env->env_tf.tf_regs.reg_eax = 0; 
f01056cd:	c7 46 1c 00 00 00 00 	movl   $0x0,0x1c(%esi)
			return 0;
f01056d4:	b8 00 00 00 00       	mov    $0x0,%eax
f01056d9:	e9 cc f7 ff ff       	jmp    f0104eaa <syscall+0x52>
	curenv->env_ipc_recving = 1;	
f01056de:	e8 a7 14 00 00       	call   f0106b8a <cpunum>
f01056e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01056e6:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01056ec:	c6 40 6c 01          	movb   $0x1,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f01056f0:	e8 95 14 00 00       	call   f0106b8a <cpunum>
f01056f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01056f8:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01056fe:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105705:	e8 8d f6 ff ff       	call   f0104d97 <sched_yield>
			return sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);
f010570a:	8b 75 10             	mov    0x10(%ebp),%esi
	user_mem_assert(curenv, tf, sizeof(struct Trapframe), 0);
f010570d:	e8 78 14 00 00       	call   f0106b8a <cpunum>
f0105712:	6a 00                	push   $0x0
f0105714:	6a 44                	push   $0x44
f0105716:	ff 75 10             	pushl  0x10(%ebp)
f0105719:	6b c0 74             	imul   $0x74,%eax,%eax
f010571c:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0105722:	e8 7a de ff ff       	call   f01035a1 <user_mem_assert>
	int r = envid2env(envid, &e, 1);
f0105727:	83 c4 0c             	add    $0xc,%esp
f010572a:	6a 01                	push   $0x1
f010572c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010572f:	50                   	push   %eax
f0105730:	ff 75 0c             	pushl  0xc(%ebp)
f0105733:	e8 39 df ff ff       	call   f0103671 <envid2env>
	if(r < 0)
f0105738:	83 c4 10             	add    $0x10,%esp
f010573b:	85 c0                	test   %eax,%eax
f010573d:	78 3b                	js     f010577a <syscall+0x922>
	e->env_tf = *tf;
f010573f:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105744:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105747:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_ds = GD_UD | 3;
f0105749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010574c:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
	e->env_tf.tf_es = GD_UD | 3;
f0105752:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
	e->env_tf.tf_ss = GD_UD | 3;
f0105758:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
	e->env_tf.tf_cs = GD_UT | 3;
f010575e:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
	e->env_tf.tf_eflags &= ~FL_IOPL_MASK;
f0105764:	8b 50 38             	mov    0x38(%eax),%edx
f0105767:	80 e6 cf             	and    $0xcf,%dh
f010576a:	80 ce 02             	or     $0x2,%dh
f010576d:	89 50 38             	mov    %edx,0x38(%eax)
	return 0;
f0105770:	b8 00 00 00 00       	mov    $0x0,%eax
f0105775:	e9 30 f7 ff ff       	jmp    f0104eaa <syscall+0x52>
		return -E_BAD_ENV;
f010577a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
			return sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);
f010577f:	e9 26 f7 ff ff       	jmp    f0104eaa <syscall+0x52>
	int r = envid2env(envid, &e, 1);
f0105784:	83 ec 04             	sub    $0x4,%esp
f0105787:	6a 01                	push   $0x1
f0105789:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010578c:	50                   	push   %eax
f010578d:	ff 75 0c             	pushl  0xc(%ebp)
f0105790:	e8 dc de ff ff       	call   f0103671 <envid2env>
	if(r < 0)
f0105795:	83 c4 10             	add    $0x10,%esp
f0105798:	85 c0                	test   %eax,%eax
f010579a:	0f 88 b2 00 00 00    	js     f0105852 <syscall+0x9fa>
	curenv->env_tf = e->env_tf;
f01057a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01057a3:	e8 e2 13 00 00       	call   f0106b8a <cpunum>
f01057a8:	6b c0 74             	imul   $0x74,%eax,%eax
f01057ab:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01057b1:	b9 11 00 00 00       	mov    $0x11,%ecx
f01057b6:	89 c7                	mov    %eax,%edi
f01057b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	curenv->env_pgfault_upcall = e->env_pgfault_upcall;
f01057ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01057bd:	e8 c8 13 00 00       	call   f0106b8a <cpunum>
f01057c2:	6b c0 74             	imul   $0x74,%eax,%eax
f01057c5:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01057cb:	8b 53 68             	mov    0x68(%ebx),%edx
f01057ce:	89 50 68             	mov    %edx,0x68(%eax)
	curenv->env_brk = e->env_brk;
f01057d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01057d4:	e8 b1 13 00 00       	call   f0106b8a <cpunum>
f01057d9:	6b c0 74             	imul   $0x74,%eax,%eax
f01057dc:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01057e2:	8b 53 5c             	mov    0x5c(%ebx),%edx
f01057e5:	89 50 5c             	mov    %edx,0x5c(%eax)
	pde_t *tmp = curenv->env_pgdir;
f01057e8:	e8 9d 13 00 00       	call   f0106b8a <cpunum>
f01057ed:	6b c0 74             	imul   $0x74,%eax,%eax
f01057f0:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f01057f6:	8b 58 64             	mov    0x64(%eax),%ebx
	curenv->env_pgdir = e->env_pgdir;
f01057f9:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01057fc:	e8 89 13 00 00       	call   f0106b8a <cpunum>
f0105801:	6b c0 74             	imul   $0x74,%eax,%eax
f0105804:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f010580a:	8b 56 64             	mov    0x64(%esi),%edx
f010580d:	89 50 64             	mov    %edx,0x64(%eax)
	e->env_pgdir = tmp;
f0105810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105813:	89 58 64             	mov    %ebx,0x64(%eax)
	lcr3(PADDR(curenv->env_pgdir));
f0105816:	e8 6f 13 00 00       	call   f0106b8a <cpunum>
f010581b:	6b c0 74             	imul   $0x74,%eax,%eax
f010581e:	8b 80 28 70 35 f0    	mov    -0xfca8fd8(%eax),%eax
f0105824:	8b 40 64             	mov    0x64(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0105827:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010582c:	76 12                	jbe    f0105840 <syscall+0x9e8>
	return (physaddr_t)kva - KERNBASE;
f010582e:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0105833:	0f 22 d8             	mov    %eax,%cr3
	return 0;
f0105836:	b8 00 00 00 00       	mov    $0x0,%eax
f010583b:	e9 6a f6 ff ff       	jmp    f0104eaa <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0105840:	50                   	push   %eax
f0105841:	68 28 72 10 f0       	push   $0xf0107228
f0105846:	6a 76                	push   $0x76
f0105848:	68 cb 8c 10 f0       	push   $0xf0108ccb
f010584d:	e8 ee a7 ff ff       	call   f0100040 <_panic>
		return -E_BAD_ENV;
f0105852:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
			return sys_env_swap((envid_t)a1);
f0105857:	e9 4e f6 ff ff       	jmp    f0104eaa <syscall+0x52>
			return -E_INVAL;
f010585c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105861:	e9 44 f6 ff ff       	jmp    f0104eaa <syscall+0x52>
        return E_INVAL;
f0105866:	b8 03 00 00 00       	mov    $0x3,%eax
f010586b:	e9 3a f6 ff ff       	jmp    f0104eaa <syscall+0x52>
					return -E_NO_MEM;
f0105870:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105875:	e9 30 f6 ff ff       	jmp    f0104eaa <syscall+0x52>

f010587a <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010587a:	55                   	push   %ebp
f010587b:	89 e5                	mov    %esp,%ebp
f010587d:	57                   	push   %edi
f010587e:	56                   	push   %esi
f010587f:	53                   	push   %ebx
f0105880:	83 ec 14             	sub    $0x14,%esp
f0105883:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105886:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105889:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f010588c:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f010588f:	8b 1a                	mov    (%edx),%ebx
f0105891:	8b 01                	mov    (%ecx),%eax
f0105893:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105896:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f010589d:	eb 23                	jmp    f01058c2 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f010589f:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f01058a2:	eb 1e                	jmp    f01058c2 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01058a4:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01058a7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01058aa:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01058ae:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01058b1:	73 41                	jae    f01058f4 <stab_binsearch+0x7a>
			*region_left = m;
f01058b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01058b6:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01058b8:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01058bb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01058c2:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01058c5:	7f 5a                	jg     f0105921 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f01058c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01058ca:	01 d8                	add    %ebx,%eax
f01058cc:	89 c7                	mov    %eax,%edi
f01058ce:	c1 ef 1f             	shr    $0x1f,%edi
f01058d1:	01 c7                	add    %eax,%edi
f01058d3:	d1 ff                	sar    %edi
f01058d5:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f01058d8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01058db:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01058df:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f01058e1:	39 c3                	cmp    %eax,%ebx
f01058e3:	7f ba                	jg     f010589f <stab_binsearch+0x25>
f01058e5:	0f b6 0a             	movzbl (%edx),%ecx
f01058e8:	83 ea 0c             	sub    $0xc,%edx
f01058eb:	39 f1                	cmp    %esi,%ecx
f01058ed:	74 b5                	je     f01058a4 <stab_binsearch+0x2a>
			m--;
f01058ef:	83 e8 01             	sub    $0x1,%eax
f01058f2:	eb ed                	jmp    f01058e1 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f01058f4:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01058f7:	76 14                	jbe    f010590d <stab_binsearch+0x93>
			*region_right = m - 1;
f01058f9:	83 e8 01             	sub    $0x1,%eax
f01058fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01058ff:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105902:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0105904:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010590b:	eb b5                	jmp    f01058c2 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f010590d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105910:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0105912:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105916:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0105918:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010591f:	eb a1                	jmp    f01058c2 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0105921:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105925:	75 15                	jne    f010593c <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0105927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010592a:	8b 00                	mov    (%eax),%eax
f010592c:	83 e8 01             	sub    $0x1,%eax
f010592f:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105932:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105934:	83 c4 14             	add    $0x14,%esp
f0105937:	5b                   	pop    %ebx
f0105938:	5e                   	pop    %esi
f0105939:	5f                   	pop    %edi
f010593a:	5d                   	pop    %ebp
f010593b:	c3                   	ret    
		for (l = *region_right;
f010593c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010593f:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105941:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105944:	8b 0f                	mov    (%edi),%ecx
f0105946:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105949:	8b 7d ec             	mov    -0x14(%ebp),%edi
f010594c:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105950:	eb 03                	jmp    f0105955 <stab_binsearch+0xdb>
		     l--)
f0105952:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105955:	39 c1                	cmp    %eax,%ecx
f0105957:	7d 0a                	jge    f0105963 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0105959:	0f b6 1a             	movzbl (%edx),%ebx
f010595c:	83 ea 0c             	sub    $0xc,%edx
f010595f:	39 f3                	cmp    %esi,%ebx
f0105961:	75 ef                	jne    f0105952 <stab_binsearch+0xd8>
		*region_left = l;
f0105963:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105966:	89 06                	mov    %eax,(%esi)
}
f0105968:	eb ca                	jmp    f0105934 <stab_binsearch+0xba>

f010596a <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010596a:	55                   	push   %ebp
f010596b:	89 e5                	mov    %esp,%ebp
f010596d:	57                   	push   %edi
f010596e:	56                   	push   %esi
f010596f:	53                   	push   %ebx
f0105970:	83 ec 4c             	sub    $0x4c,%esp
f0105973:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105976:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105979:	c7 03 48 8d 10 f0    	movl   $0xf0108d48,(%ebx)
	info->eip_line = 0;
f010597f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105986:	c7 43 08 48 8d 10 f0 	movl   $0xf0108d48,0x8(%ebx)
	info->eip_fn_namelen = 9;
f010598d:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105994:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105997:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f010599e:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f01059a4:	0f 86 23 01 00 00    	jbe    f0105acd <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f01059aa:	c7 45 b8 68 ad 11 f0 	movl   $0xf011ad68,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f01059b1:	c7 45 b4 fd 72 11 f0 	movl   $0xf01172fd,-0x4c(%ebp)
		stab_end = __STAB_END__;
f01059b8:	be fc 72 11 f0       	mov    $0xf01172fc,%esi
		stabs = __STAB_BEGIN__;
f01059bd:	c7 45 bc 70 93 10 f0 	movl   $0xf0109370,-0x44(%ebp)
			return -1;
		
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01059c4:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f01059c7:	39 4d b4             	cmp    %ecx,-0x4c(%ebp)
f01059ca:	0f 83 62 02 00 00    	jae    f0105c32 <debuginfo_eip+0x2c8>
f01059d0:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f01059d4:	0f 85 5f 02 00 00    	jne    f0105c39 <debuginfo_eip+0x2cf>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01059da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01059e1:	2b 75 bc             	sub    -0x44(%ebp),%esi
f01059e4:	c1 fe 02             	sar    $0x2,%esi
f01059e7:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f01059ed:	83 e8 01             	sub    $0x1,%eax
f01059f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01059f3:	83 ec 08             	sub    $0x8,%esp
f01059f6:	57                   	push   %edi
f01059f7:	6a 64                	push   $0x64
f01059f9:	8d 55 e0             	lea    -0x20(%ebp),%edx
f01059fc:	89 d1                	mov    %edx,%ecx
f01059fe:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105a01:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105a04:	89 f0                	mov    %esi,%eax
f0105a06:	e8 6f fe ff ff       	call   f010587a <stab_binsearch>
	if (lfile == 0)
f0105a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a0e:	83 c4 10             	add    $0x10,%esp
f0105a11:	85 c0                	test   %eax,%eax
f0105a13:	0f 84 27 02 00 00    	je     f0105c40 <debuginfo_eip+0x2d6>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105a19:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105a22:	83 ec 08             	sub    $0x8,%esp
f0105a25:	57                   	push   %edi
f0105a26:	6a 24                	push   $0x24
f0105a28:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105a2b:	89 d1                	mov    %edx,%ecx
f0105a2d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105a30:	89 f0                	mov    %esi,%eax
f0105a32:	e8 43 fe ff ff       	call   f010587a <stab_binsearch>

	if (lfun <= rfun) {
f0105a37:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105a3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105a3d:	83 c4 10             	add    $0x10,%esp
f0105a40:	39 d0                	cmp    %edx,%eax
f0105a42:	0f 8f 32 01 00 00    	jg     f0105b7a <debuginfo_eip+0x210>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105a48:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0105a4b:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0105a4e:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f0105a51:	8b 36                	mov    (%esi),%esi
f0105a53:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0105a56:	2b 4d b4             	sub    -0x4c(%ebp),%ecx
f0105a59:	39 ce                	cmp    %ecx,%esi
f0105a5b:	73 06                	jae    f0105a63 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105a5d:	03 75 b4             	add    -0x4c(%ebp),%esi
f0105a60:	89 73 08             	mov    %esi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105a63:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0105a66:	8b 4e 08             	mov    0x8(%esi),%ecx
f0105a69:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105a6c:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105a6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105a71:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105a74:	83 ec 08             	sub    $0x8,%esp
f0105a77:	6a 3a                	push   $0x3a
f0105a79:	ff 73 08             	pushl  0x8(%ebx)
f0105a7c:	e8 ec 0a 00 00       	call   f010656d <strfind>
f0105a81:	2b 43 08             	sub    0x8(%ebx),%eax
f0105a84:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105a87:	83 c4 08             	add    $0x8,%esp
f0105a8a:	57                   	push   %edi
f0105a8b:	6a 44                	push   $0x44
f0105a8d:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105a90:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105a93:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105a96:	89 f0                	mov    %esi,%eax
f0105a98:	e8 dd fd ff ff       	call   f010587a <stab_binsearch>

	if(lline <= rline){
f0105a9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105aa0:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105aa3:	83 c4 10             	add    $0x10,%esp
f0105aa6:	39 c2                	cmp    %eax,%edx
f0105aa8:	0f 8f 99 01 00 00    	jg     f0105c47 <debuginfo_eip+0x2dd>
		info->eip_line = stabs[rline].n_value;
f0105aae:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105ab1:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f0105ab5:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105ab8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105abb:	89 d0                	mov    %edx,%eax
f0105abd:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105ac0:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105ac4:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0105ac8:	e9 cb 00 00 00       	jmp    f0105b98 <debuginfo_eip+0x22e>
		if(user_mem_check(curenv, (void*)usd, sizeof(struct UserStabData), PTE_U<0))
f0105acd:	e8 b8 10 00 00       	call   f0106b8a <cpunum>
f0105ad2:	6a 00                	push   $0x0
f0105ad4:	6a 10                	push   $0x10
f0105ad6:	68 00 00 20 00       	push   $0x200000
f0105adb:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ade:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0105ae4:	e8 44 da ff ff       	call   f010352d <user_mem_check>
f0105ae9:	83 c4 10             	add    $0x10,%esp
f0105aec:	85 c0                	test   %eax,%eax
f0105aee:	0f 85 30 01 00 00    	jne    f0105c24 <debuginfo_eip+0x2ba>
		stabs = usd->stabs;
f0105af4:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0105afa:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0105afd:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0105b03:	a1 08 00 20 00       	mov    0x200008,%eax
f0105b08:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105b0b:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105b11:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, (void*)stabs, stab_end-stabs, PTE_U)<0)
f0105b14:	e8 71 10 00 00       	call   f0106b8a <cpunum>
f0105b19:	6a 04                	push   $0x4
f0105b1b:	89 f2                	mov    %esi,%edx
f0105b1d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105b20:	29 ca                	sub    %ecx,%edx
f0105b22:	c1 fa 02             	sar    $0x2,%edx
f0105b25:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0105b2b:	52                   	push   %edx
f0105b2c:	51                   	push   %ecx
f0105b2d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b30:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0105b36:	e8 f2 d9 ff ff       	call   f010352d <user_mem_check>
f0105b3b:	83 c4 10             	add    $0x10,%esp
f0105b3e:	85 c0                	test   %eax,%eax
f0105b40:	0f 88 e5 00 00 00    	js     f0105c2b <debuginfo_eip+0x2c1>
		if(user_mem_check(curenv, (void*)stabstr, stabstr_end-stabstr, PTE_U)<0)
f0105b46:	e8 3f 10 00 00       	call   f0106b8a <cpunum>
f0105b4b:	6a 04                	push   $0x4
f0105b4d:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105b50:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105b53:	29 ca                	sub    %ecx,%edx
f0105b55:	52                   	push   %edx
f0105b56:	51                   	push   %ecx
f0105b57:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b5a:	ff b0 28 70 35 f0    	pushl  -0xfca8fd8(%eax)
f0105b60:	e8 c8 d9 ff ff       	call   f010352d <user_mem_check>
f0105b65:	83 c4 10             	add    $0x10,%esp
f0105b68:	85 c0                	test   %eax,%eax
f0105b6a:	0f 89 54 fe ff ff    	jns    f01059c4 <debuginfo_eip+0x5a>
			return -1;
f0105b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b75:	e9 d9 00 00 00       	jmp    f0105c53 <debuginfo_eip+0x2e9>
		info->eip_fn_addr = addr;
f0105b7a:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105b83:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b86:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105b89:	e9 e6 fe ff ff       	jmp    f0105a74 <debuginfo_eip+0x10a>
f0105b8e:	83 e8 01             	sub    $0x1,%eax
f0105b91:	83 ea 0c             	sub    $0xc,%edx
f0105b94:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105b98:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105b9b:	39 c7                	cmp    %eax,%edi
f0105b9d:	7f 45                	jg     f0105be4 <debuginfo_eip+0x27a>
	       && stabs[lline].n_type != N_SOL
f0105b9f:	0f b6 0a             	movzbl (%edx),%ecx
f0105ba2:	80 f9 84             	cmp    $0x84,%cl
f0105ba5:	74 19                	je     f0105bc0 <debuginfo_eip+0x256>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105ba7:	80 f9 64             	cmp    $0x64,%cl
f0105baa:	75 e2                	jne    f0105b8e <debuginfo_eip+0x224>
f0105bac:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105bb0:	74 dc                	je     f0105b8e <debuginfo_eip+0x224>
f0105bb2:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105bb6:	74 11                	je     f0105bc9 <debuginfo_eip+0x25f>
f0105bb8:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105bbb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105bbe:	eb 09                	jmp    f0105bc9 <debuginfo_eip+0x25f>
f0105bc0:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105bc4:	74 03                	je     f0105bc9 <debuginfo_eip+0x25f>
f0105bc6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105bc9:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105bcc:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105bcf:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105bd2:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105bd5:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105bd8:	29 f8                	sub    %edi,%eax
f0105bda:	39 c2                	cmp    %eax,%edx
f0105bdc:	73 06                	jae    f0105be4 <debuginfo_eip+0x27a>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105bde:	89 f8                	mov    %edi,%eax
f0105be0:	01 d0                	add    %edx,%eax
f0105be2:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105be4:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105be7:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105bea:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105bef:	39 f2                	cmp    %esi,%edx
f0105bf1:	7d 60                	jge    f0105c53 <debuginfo_eip+0x2e9>
		for (lline = lfun + 1;
f0105bf3:	83 c2 01             	add    $0x1,%edx
f0105bf6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105bf9:	89 d0                	mov    %edx,%eax
f0105bfb:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105bfe:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105c01:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105c05:	eb 04                	jmp    f0105c0b <debuginfo_eip+0x2a1>
			info->eip_fn_narg++;
f0105c07:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105c0b:	39 c6                	cmp    %eax,%esi
f0105c0d:	7e 3f                	jle    f0105c4e <debuginfo_eip+0x2e4>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105c0f:	0f b6 0a             	movzbl (%edx),%ecx
f0105c12:	83 c0 01             	add    $0x1,%eax
f0105c15:	83 c2 0c             	add    $0xc,%edx
f0105c18:	80 f9 a0             	cmp    $0xa0,%cl
f0105c1b:	74 ea                	je     f0105c07 <debuginfo_eip+0x29d>
	return 0;
f0105c1d:	b8 00 00 00 00       	mov    $0x0,%eax
f0105c22:	eb 2f                	jmp    f0105c53 <debuginfo_eip+0x2e9>
			return -1;
f0105c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c29:	eb 28                	jmp    f0105c53 <debuginfo_eip+0x2e9>
			return -1;
f0105c2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c30:	eb 21                	jmp    f0105c53 <debuginfo_eip+0x2e9>
		return -1;
f0105c32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c37:	eb 1a                	jmp    f0105c53 <debuginfo_eip+0x2e9>
f0105c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c3e:	eb 13                	jmp    f0105c53 <debuginfo_eip+0x2e9>
		return -1;
f0105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c45:	eb 0c                	jmp    f0105c53 <debuginfo_eip+0x2e9>
		return -1;
f0105c47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c4c:	eb 05                	jmp    f0105c53 <debuginfo_eip+0x2e9>
	return 0;
f0105c4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105c56:	5b                   	pop    %ebx
f0105c57:	5e                   	pop    %esi
f0105c58:	5f                   	pop    %edi
f0105c59:	5d                   	pop    %ebp
f0105c5a:	c3                   	ret    

f0105c5b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105c5b:	55                   	push   %ebp
f0105c5c:	89 e5                	mov    %esp,%ebp
f0105c5e:	57                   	push   %edi
f0105c5f:	56                   	push   %esi
f0105c60:	53                   	push   %ebx
f0105c61:	83 ec 1c             	sub    $0x1c,%esp
f0105c64:	89 c6                	mov    %eax,%esi
f0105c66:	89 d7                	mov    %edx,%edi
f0105c68:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105c71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105c74:	8b 45 10             	mov    0x10(%ebp),%eax
f0105c77:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105c7a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105c7e:	74 2c                	je     f0105cac <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105c80:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105c83:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105c8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105c8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105c90:	39 c2                	cmp    %eax,%edx
f0105c92:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105c95:	73 43                	jae    f0105cda <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105c97:	83 eb 01             	sub    $0x1,%ebx
f0105c9a:	85 db                	test   %ebx,%ebx
f0105c9c:	7e 6c                	jle    f0105d0a <printnum+0xaf>
			putch(padc, putdat);
f0105c9e:	83 ec 08             	sub    $0x8,%esp
f0105ca1:	57                   	push   %edi
f0105ca2:	ff 75 18             	pushl  0x18(%ebp)
f0105ca5:	ff d6                	call   *%esi
f0105ca7:	83 c4 10             	add    $0x10,%esp
f0105caa:	eb eb                	jmp    f0105c97 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
f0105cac:	83 ec 0c             	sub    $0xc,%esp
f0105caf:	6a 20                	push   $0x20
f0105cb1:	6a 00                	push   $0x0
f0105cb3:	50                   	push   %eax
f0105cb4:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105cb7:	ff 75 e0             	pushl  -0x20(%ebp)
f0105cba:	89 fa                	mov    %edi,%edx
f0105cbc:	89 f0                	mov    %esi,%eax
f0105cbe:	e8 98 ff ff ff       	call   f0105c5b <printnum>
		while (--width > 0)
f0105cc3:	83 c4 20             	add    $0x20,%esp
f0105cc6:	83 eb 01             	sub    $0x1,%ebx
f0105cc9:	85 db                	test   %ebx,%ebx
f0105ccb:	7e 65                	jle    f0105d32 <printnum+0xd7>
			putch(padc, putdat);
f0105ccd:	83 ec 08             	sub    $0x8,%esp
f0105cd0:	57                   	push   %edi
f0105cd1:	6a 20                	push   $0x20
f0105cd3:	ff d6                	call   *%esi
f0105cd5:	83 c4 10             	add    $0x10,%esp
f0105cd8:	eb ec                	jmp    f0105cc6 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105cda:	83 ec 0c             	sub    $0xc,%esp
f0105cdd:	ff 75 18             	pushl  0x18(%ebp)
f0105ce0:	83 eb 01             	sub    $0x1,%ebx
f0105ce3:	53                   	push   %ebx
f0105ce4:	50                   	push   %eax
f0105ce5:	83 ec 08             	sub    $0x8,%esp
f0105ce8:	ff 75 dc             	pushl  -0x24(%ebp)
f0105ceb:	ff 75 d8             	pushl  -0x28(%ebp)
f0105cee:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105cf1:	ff 75 e0             	pushl  -0x20(%ebp)
f0105cf4:	e8 87 12 00 00       	call   f0106f80 <__udivdi3>
f0105cf9:	83 c4 18             	add    $0x18,%esp
f0105cfc:	52                   	push   %edx
f0105cfd:	50                   	push   %eax
f0105cfe:	89 fa                	mov    %edi,%edx
f0105d00:	89 f0                	mov    %esi,%eax
f0105d02:	e8 54 ff ff ff       	call   f0105c5b <printnum>
f0105d07:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105d0a:	83 ec 08             	sub    $0x8,%esp
f0105d0d:	57                   	push   %edi
f0105d0e:	83 ec 04             	sub    $0x4,%esp
f0105d11:	ff 75 dc             	pushl  -0x24(%ebp)
f0105d14:	ff 75 d8             	pushl  -0x28(%ebp)
f0105d17:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105d1a:	ff 75 e0             	pushl  -0x20(%ebp)
f0105d1d:	e8 6e 13 00 00       	call   f0107090 <__umoddi3>
f0105d22:	83 c4 14             	add    $0x14,%esp
f0105d25:	0f be 80 52 8d 10 f0 	movsbl -0xfef72ae(%eax),%eax
f0105d2c:	50                   	push   %eax
f0105d2d:	ff d6                	call   *%esi
f0105d2f:	83 c4 10             	add    $0x10,%esp
}
f0105d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105d35:	5b                   	pop    %ebx
f0105d36:	5e                   	pop    %esi
f0105d37:	5f                   	pop    %edi
f0105d38:	5d                   	pop    %ebp
f0105d39:	c3                   	ret    

f0105d3a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105d3a:	55                   	push   %ebp
f0105d3b:	89 e5                	mov    %esp,%ebp
f0105d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105d40:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105d44:	8b 10                	mov    (%eax),%edx
f0105d46:	3b 50 04             	cmp    0x4(%eax),%edx
f0105d49:	73 0a                	jae    f0105d55 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105d4b:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105d4e:	89 08                	mov    %ecx,(%eax)
f0105d50:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d53:	88 02                	mov    %al,(%edx)
}
f0105d55:	5d                   	pop    %ebp
f0105d56:	c3                   	ret    

f0105d57 <printfmt>:
{
f0105d57:	55                   	push   %ebp
f0105d58:	89 e5                	mov    %esp,%ebp
f0105d5a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105d5d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105d60:	50                   	push   %eax
f0105d61:	ff 75 10             	pushl  0x10(%ebp)
f0105d64:	ff 75 0c             	pushl  0xc(%ebp)
f0105d67:	ff 75 08             	pushl  0x8(%ebp)
f0105d6a:	e8 05 00 00 00       	call   f0105d74 <vprintfmt>
}
f0105d6f:	83 c4 10             	add    $0x10,%esp
f0105d72:	c9                   	leave  
f0105d73:	c3                   	ret    

f0105d74 <vprintfmt>:
{
f0105d74:	55                   	push   %ebp
f0105d75:	89 e5                	mov    %esp,%ebp
f0105d77:	57                   	push   %edi
f0105d78:	56                   	push   %esi
f0105d79:	53                   	push   %ebx
f0105d7a:	83 ec 3c             	sub    $0x3c,%esp
f0105d7d:	8b 75 08             	mov    0x8(%ebp),%esi
f0105d80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105d83:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105d86:	e9 b4 03 00 00       	jmp    f010613f <vprintfmt+0x3cb>
		padc = ' ';
f0105d8b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
f0105d8f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
f0105d96:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f0105d9d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105da4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105dab:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105db0:	8d 47 01             	lea    0x1(%edi),%eax
f0105db3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105db6:	0f b6 17             	movzbl (%edi),%edx
f0105db9:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105dbc:	3c 55                	cmp    $0x55,%al
f0105dbe:	0f 87 c8 04 00 00    	ja     f010628c <vprintfmt+0x518>
f0105dc4:	0f b6 c0             	movzbl %al,%eax
f0105dc7:	ff 24 85 40 8f 10 f0 	jmp    *-0xfef70c0(,%eax,4)
f0105dce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
f0105dd1:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
f0105dd8:	eb d6                	jmp    f0105db0 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
f0105dda:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105ddd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f0105de1:	eb cd                	jmp    f0105db0 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
f0105de3:	0f b6 d2             	movzbl %dl,%edx
f0105de6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105de9:	b8 00 00 00 00       	mov    $0x0,%eax
f0105dee:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0105df1:	eb 0c                	jmp    f0105dff <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
f0105df3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105df6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
f0105dfa:	eb b4                	jmp    f0105db0 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
f0105dfc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105dff:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105e02:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0105e06:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105e09:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0105e0c:	83 f9 09             	cmp    $0x9,%ecx
f0105e0f:	76 eb                	jbe    f0105dfc <vprintfmt+0x88>
f0105e11:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105e14:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e17:	eb 14                	jmp    f0105e2d <vprintfmt+0xb9>
			precision = va_arg(ap, int);
f0105e19:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e1c:	8b 00                	mov    (%eax),%eax
f0105e1e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e21:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e24:	8d 40 04             	lea    0x4(%eax),%eax
f0105e27:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e2a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105e2d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105e31:	0f 89 79 ff ff ff    	jns    f0105db0 <vprintfmt+0x3c>
				width = precision, precision = -1;
f0105e37:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105e3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105e3d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105e44:	e9 67 ff ff ff       	jmp    f0105db0 <vprintfmt+0x3c>
f0105e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e4c:	85 c0                	test   %eax,%eax
f0105e4e:	ba 00 00 00 00       	mov    $0x0,%edx
f0105e53:	0f 49 d0             	cmovns %eax,%edx
f0105e56:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e59:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105e5c:	e9 4f ff ff ff       	jmp    f0105db0 <vprintfmt+0x3c>
f0105e61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105e64:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0105e6b:	e9 40 ff ff ff       	jmp    f0105db0 <vprintfmt+0x3c>
			lflag++;
f0105e70:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105e73:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105e76:	e9 35 ff ff ff       	jmp    f0105db0 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
f0105e7b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e7e:	8d 78 04             	lea    0x4(%eax),%edi
f0105e81:	83 ec 08             	sub    $0x8,%esp
f0105e84:	53                   	push   %ebx
f0105e85:	ff 30                	pushl  (%eax)
f0105e87:	ff d6                	call   *%esi
			break;
f0105e89:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105e8c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105e8f:	e9 a8 02 00 00       	jmp    f010613c <vprintfmt+0x3c8>
			err = va_arg(ap, int);
f0105e94:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e97:	8d 78 04             	lea    0x4(%eax),%edi
f0105e9a:	8b 00                	mov    (%eax),%eax
f0105e9c:	99                   	cltd   
f0105e9d:	31 d0                	xor    %edx,%eax
f0105e9f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105ea1:	83 f8 0f             	cmp    $0xf,%eax
f0105ea4:	7f 23                	jg     f0105ec9 <vprintfmt+0x155>
f0105ea6:	8b 14 85 a0 90 10 f0 	mov    -0xfef6f60(,%eax,4),%edx
f0105ead:	85 d2                	test   %edx,%edx
f0105eaf:	74 18                	je     f0105ec9 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
f0105eb1:	52                   	push   %edx
f0105eb2:	68 d9 84 10 f0       	push   $0xf01084d9
f0105eb7:	53                   	push   %ebx
f0105eb8:	56                   	push   %esi
f0105eb9:	e8 99 fe ff ff       	call   f0105d57 <printfmt>
f0105ebe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105ec1:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105ec4:	e9 73 02 00 00       	jmp    f010613c <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
f0105ec9:	50                   	push   %eax
f0105eca:	68 6a 8d 10 f0       	push   $0xf0108d6a
f0105ecf:	53                   	push   %ebx
f0105ed0:	56                   	push   %esi
f0105ed1:	e8 81 fe ff ff       	call   f0105d57 <printfmt>
f0105ed6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105ed9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105edc:	e9 5b 02 00 00       	jmp    f010613c <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
f0105ee1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ee4:	83 c0 04             	add    $0x4,%eax
f0105ee7:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0105eea:	8b 45 14             	mov    0x14(%ebp),%eax
f0105eed:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0105eef:	85 d2                	test   %edx,%edx
f0105ef1:	b8 63 8d 10 f0       	mov    $0xf0108d63,%eax
f0105ef6:	0f 45 c2             	cmovne %edx,%eax
f0105ef9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f0105efc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105f00:	7e 06                	jle    f0105f08 <vprintfmt+0x194>
f0105f02:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f0105f06:	75 0d                	jne    f0105f15 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105f08:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0105f0b:	89 c7                	mov    %eax,%edi
f0105f0d:	03 45 e0             	add    -0x20(%ebp),%eax
f0105f10:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105f13:	eb 53                	jmp    f0105f68 <vprintfmt+0x1f4>
f0105f15:	83 ec 08             	sub    $0x8,%esp
f0105f18:	ff 75 d8             	pushl  -0x28(%ebp)
f0105f1b:	50                   	push   %eax
f0105f1c:	e8 01 05 00 00       	call   f0106422 <strnlen>
f0105f21:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105f24:	29 c1                	sub    %eax,%ecx
f0105f26:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0105f29:	83 c4 10             	add    $0x10,%esp
f0105f2c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0105f2e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0105f32:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105f35:	eb 0f                	jmp    f0105f46 <vprintfmt+0x1d2>
					putch(padc, putdat);
f0105f37:	83 ec 08             	sub    $0x8,%esp
f0105f3a:	53                   	push   %ebx
f0105f3b:	ff 75 e0             	pushl  -0x20(%ebp)
f0105f3e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105f40:	83 ef 01             	sub    $0x1,%edi
f0105f43:	83 c4 10             	add    $0x10,%esp
f0105f46:	85 ff                	test   %edi,%edi
f0105f48:	7f ed                	jg     f0105f37 <vprintfmt+0x1c3>
f0105f4a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0105f4d:	85 d2                	test   %edx,%edx
f0105f4f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f54:	0f 49 c2             	cmovns %edx,%eax
f0105f57:	29 c2                	sub    %eax,%edx
f0105f59:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0105f5c:	eb aa                	jmp    f0105f08 <vprintfmt+0x194>
					putch(ch, putdat);
f0105f5e:	83 ec 08             	sub    $0x8,%esp
f0105f61:	53                   	push   %ebx
f0105f62:	52                   	push   %edx
f0105f63:	ff d6                	call   *%esi
f0105f65:	83 c4 10             	add    $0x10,%esp
f0105f68:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105f6b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105f6d:	83 c7 01             	add    $0x1,%edi
f0105f70:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105f74:	0f be d0             	movsbl %al,%edx
f0105f77:	85 d2                	test   %edx,%edx
f0105f79:	74 4b                	je     f0105fc6 <vprintfmt+0x252>
f0105f7b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105f7f:	78 06                	js     f0105f87 <vprintfmt+0x213>
f0105f81:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105f85:	78 1e                	js     f0105fa5 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
f0105f87:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105f8b:	74 d1                	je     f0105f5e <vprintfmt+0x1ea>
f0105f8d:	0f be c0             	movsbl %al,%eax
f0105f90:	83 e8 20             	sub    $0x20,%eax
f0105f93:	83 f8 5e             	cmp    $0x5e,%eax
f0105f96:	76 c6                	jbe    f0105f5e <vprintfmt+0x1ea>
					putch('?', putdat);
f0105f98:	83 ec 08             	sub    $0x8,%esp
f0105f9b:	53                   	push   %ebx
f0105f9c:	6a 3f                	push   $0x3f
f0105f9e:	ff d6                	call   *%esi
f0105fa0:	83 c4 10             	add    $0x10,%esp
f0105fa3:	eb c3                	jmp    f0105f68 <vprintfmt+0x1f4>
f0105fa5:	89 cf                	mov    %ecx,%edi
f0105fa7:	eb 0e                	jmp    f0105fb7 <vprintfmt+0x243>
				putch(' ', putdat);
f0105fa9:	83 ec 08             	sub    $0x8,%esp
f0105fac:	53                   	push   %ebx
f0105fad:	6a 20                	push   $0x20
f0105faf:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105fb1:	83 ef 01             	sub    $0x1,%edi
f0105fb4:	83 c4 10             	add    $0x10,%esp
f0105fb7:	85 ff                	test   %edi,%edi
f0105fb9:	7f ee                	jg     f0105fa9 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
f0105fbb:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105fbe:	89 45 14             	mov    %eax,0x14(%ebp)
f0105fc1:	e9 76 01 00 00       	jmp    f010613c <vprintfmt+0x3c8>
f0105fc6:	89 cf                	mov    %ecx,%edi
f0105fc8:	eb ed                	jmp    f0105fb7 <vprintfmt+0x243>
	if (lflag >= 2)
f0105fca:	83 f9 01             	cmp    $0x1,%ecx
f0105fcd:	7f 1f                	jg     f0105fee <vprintfmt+0x27a>
	else if (lflag)
f0105fcf:	85 c9                	test   %ecx,%ecx
f0105fd1:	74 6a                	je     f010603d <vprintfmt+0x2c9>
		return va_arg(*ap, long);
f0105fd3:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fd6:	8b 00                	mov    (%eax),%eax
f0105fd8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105fdb:	89 c1                	mov    %eax,%ecx
f0105fdd:	c1 f9 1f             	sar    $0x1f,%ecx
f0105fe0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105fe3:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fe6:	8d 40 04             	lea    0x4(%eax),%eax
f0105fe9:	89 45 14             	mov    %eax,0x14(%ebp)
f0105fec:	eb 17                	jmp    f0106005 <vprintfmt+0x291>
		return va_arg(*ap, long long);
f0105fee:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ff1:	8b 50 04             	mov    0x4(%eax),%edx
f0105ff4:	8b 00                	mov    (%eax),%eax
f0105ff6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105ff9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105ffc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fff:	8d 40 08             	lea    0x8(%eax),%eax
f0106002:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0106005:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
f0106008:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
f010600d:	85 d2                	test   %edx,%edx
f010600f:	0f 89 f8 00 00 00    	jns    f010610d <vprintfmt+0x399>
				putch('-', putdat);
f0106015:	83 ec 08             	sub    $0x8,%esp
f0106018:	53                   	push   %ebx
f0106019:	6a 2d                	push   $0x2d
f010601b:	ff d6                	call   *%esi
				num = -(long long) num;
f010601d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106020:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0106023:	f7 d8                	neg    %eax
f0106025:	83 d2 00             	adc    $0x0,%edx
f0106028:	f7 da                	neg    %edx
f010602a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010602d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106030:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0106033:	bf 0a 00 00 00       	mov    $0xa,%edi
f0106038:	e9 e1 00 00 00       	jmp    f010611e <vprintfmt+0x3aa>
		return va_arg(*ap, int);
f010603d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106040:	8b 00                	mov    (%eax),%eax
f0106042:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106045:	99                   	cltd   
f0106046:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106049:	8b 45 14             	mov    0x14(%ebp),%eax
f010604c:	8d 40 04             	lea    0x4(%eax),%eax
f010604f:	89 45 14             	mov    %eax,0x14(%ebp)
f0106052:	eb b1                	jmp    f0106005 <vprintfmt+0x291>
	if (lflag >= 2)
f0106054:	83 f9 01             	cmp    $0x1,%ecx
f0106057:	7f 27                	jg     f0106080 <vprintfmt+0x30c>
	else if (lflag)
f0106059:	85 c9                	test   %ecx,%ecx
f010605b:	74 41                	je     f010609e <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
f010605d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106060:	8b 00                	mov    (%eax),%eax
f0106062:	ba 00 00 00 00       	mov    $0x0,%edx
f0106067:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010606a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010606d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106070:	8d 40 04             	lea    0x4(%eax),%eax
f0106073:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106076:	bf 0a 00 00 00       	mov    $0xa,%edi
f010607b:	e9 8d 00 00 00       	jmp    f010610d <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
f0106080:	8b 45 14             	mov    0x14(%ebp),%eax
f0106083:	8b 50 04             	mov    0x4(%eax),%edx
f0106086:	8b 00                	mov    (%eax),%eax
f0106088:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010608b:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010608e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106091:	8d 40 08             	lea    0x8(%eax),%eax
f0106094:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106097:	bf 0a 00 00 00       	mov    $0xa,%edi
f010609c:	eb 6f                	jmp    f010610d <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
f010609e:	8b 45 14             	mov    0x14(%ebp),%eax
f01060a1:	8b 00                	mov    (%eax),%eax
f01060a3:	ba 00 00 00 00       	mov    $0x0,%edx
f01060a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060ae:	8b 45 14             	mov    0x14(%ebp),%eax
f01060b1:	8d 40 04             	lea    0x4(%eax),%eax
f01060b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01060b7:	bf 0a 00 00 00       	mov    $0xa,%edi
f01060bc:	eb 4f                	jmp    f010610d <vprintfmt+0x399>
	if (lflag >= 2)
f01060be:	83 f9 01             	cmp    $0x1,%ecx
f01060c1:	7f 23                	jg     f01060e6 <vprintfmt+0x372>
	else if (lflag)
f01060c3:	85 c9                	test   %ecx,%ecx
f01060c5:	0f 84 98 00 00 00    	je     f0106163 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
f01060cb:	8b 45 14             	mov    0x14(%ebp),%eax
f01060ce:	8b 00                	mov    (%eax),%eax
f01060d0:	ba 00 00 00 00       	mov    $0x0,%edx
f01060d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060db:	8b 45 14             	mov    0x14(%ebp),%eax
f01060de:	8d 40 04             	lea    0x4(%eax),%eax
f01060e1:	89 45 14             	mov    %eax,0x14(%ebp)
f01060e4:	eb 17                	jmp    f01060fd <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
f01060e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01060e9:	8b 50 04             	mov    0x4(%eax),%edx
f01060ec:	8b 00                	mov    (%eax),%eax
f01060ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060f4:	8b 45 14             	mov    0x14(%ebp),%eax
f01060f7:	8d 40 08             	lea    0x8(%eax),%eax
f01060fa:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
f01060fd:	83 ec 08             	sub    $0x8,%esp
f0106100:	53                   	push   %ebx
f0106101:	6a 30                	push   $0x30
f0106103:	ff d6                	call   *%esi
			goto number;
f0106105:	83 c4 10             	add    $0x10,%esp
			base = 8;
f0106108:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
f010610d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
f0106111:	74 0b                	je     f010611e <vprintfmt+0x3aa>
				putch('+', putdat);
f0106113:	83 ec 08             	sub    $0x8,%esp
f0106116:	53                   	push   %ebx
f0106117:	6a 2b                	push   $0x2b
f0106119:	ff d6                	call   *%esi
f010611b:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
f010611e:	83 ec 0c             	sub    $0xc,%esp
f0106121:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0106125:	50                   	push   %eax
f0106126:	ff 75 e0             	pushl  -0x20(%ebp)
f0106129:	57                   	push   %edi
f010612a:	ff 75 dc             	pushl  -0x24(%ebp)
f010612d:	ff 75 d8             	pushl  -0x28(%ebp)
f0106130:	89 da                	mov    %ebx,%edx
f0106132:	89 f0                	mov    %esi,%eax
f0106134:	e8 22 fb ff ff       	call   f0105c5b <printnum>
			break;
f0106139:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
f010613c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010613f:	83 c7 01             	add    $0x1,%edi
f0106142:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0106146:	83 f8 25             	cmp    $0x25,%eax
f0106149:	0f 84 3c fc ff ff    	je     f0105d8b <vprintfmt+0x17>
			if (ch == '\0')
f010614f:	85 c0                	test   %eax,%eax
f0106151:	0f 84 55 01 00 00    	je     f01062ac <vprintfmt+0x538>
			putch(ch, putdat);
f0106157:	83 ec 08             	sub    $0x8,%esp
f010615a:	53                   	push   %ebx
f010615b:	50                   	push   %eax
f010615c:	ff d6                	call   *%esi
f010615e:	83 c4 10             	add    $0x10,%esp
f0106161:	eb dc                	jmp    f010613f <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
f0106163:	8b 45 14             	mov    0x14(%ebp),%eax
f0106166:	8b 00                	mov    (%eax),%eax
f0106168:	ba 00 00 00 00       	mov    $0x0,%edx
f010616d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106170:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106173:	8b 45 14             	mov    0x14(%ebp),%eax
f0106176:	8d 40 04             	lea    0x4(%eax),%eax
f0106179:	89 45 14             	mov    %eax,0x14(%ebp)
f010617c:	e9 7c ff ff ff       	jmp    f01060fd <vprintfmt+0x389>
			putch('0', putdat);
f0106181:	83 ec 08             	sub    $0x8,%esp
f0106184:	53                   	push   %ebx
f0106185:	6a 30                	push   $0x30
f0106187:	ff d6                	call   *%esi
			putch('x', putdat);
f0106189:	83 c4 08             	add    $0x8,%esp
f010618c:	53                   	push   %ebx
f010618d:	6a 78                	push   $0x78
f010618f:	ff d6                	call   *%esi
			num = (unsigned long long)
f0106191:	8b 45 14             	mov    0x14(%ebp),%eax
f0106194:	8b 00                	mov    (%eax),%eax
f0106196:	ba 00 00 00 00       	mov    $0x0,%edx
f010619b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010619e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f01061a1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01061a4:	8b 45 14             	mov    0x14(%ebp),%eax
f01061a7:	8d 40 04             	lea    0x4(%eax),%eax
f01061aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01061ad:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
f01061b2:	e9 56 ff ff ff       	jmp    f010610d <vprintfmt+0x399>
	if (lflag >= 2)
f01061b7:	83 f9 01             	cmp    $0x1,%ecx
f01061ba:	7f 27                	jg     f01061e3 <vprintfmt+0x46f>
	else if (lflag)
f01061bc:	85 c9                	test   %ecx,%ecx
f01061be:	74 44                	je     f0106204 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
f01061c0:	8b 45 14             	mov    0x14(%ebp),%eax
f01061c3:	8b 00                	mov    (%eax),%eax
f01061c5:	ba 00 00 00 00       	mov    $0x0,%edx
f01061ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01061cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01061d0:	8b 45 14             	mov    0x14(%ebp),%eax
f01061d3:	8d 40 04             	lea    0x4(%eax),%eax
f01061d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01061d9:	bf 10 00 00 00       	mov    $0x10,%edi
f01061de:	e9 2a ff ff ff       	jmp    f010610d <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
f01061e3:	8b 45 14             	mov    0x14(%ebp),%eax
f01061e6:	8b 50 04             	mov    0x4(%eax),%edx
f01061e9:	8b 00                	mov    (%eax),%eax
f01061eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01061ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01061f1:	8b 45 14             	mov    0x14(%ebp),%eax
f01061f4:	8d 40 08             	lea    0x8(%eax),%eax
f01061f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01061fa:	bf 10 00 00 00       	mov    $0x10,%edi
f01061ff:	e9 09 ff ff ff       	jmp    f010610d <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
f0106204:	8b 45 14             	mov    0x14(%ebp),%eax
f0106207:	8b 00                	mov    (%eax),%eax
f0106209:	ba 00 00 00 00       	mov    $0x0,%edx
f010620e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106211:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106214:	8b 45 14             	mov    0x14(%ebp),%eax
f0106217:	8d 40 04             	lea    0x4(%eax),%eax
f010621a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010621d:	bf 10 00 00 00       	mov    $0x10,%edi
f0106222:	e9 e6 fe ff ff       	jmp    f010610d <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
f0106227:	8b 45 14             	mov    0x14(%ebp),%eax
f010622a:	8d 78 04             	lea    0x4(%eax),%edi
f010622d:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
f010622f:	85 c0                	test   %eax,%eax
f0106231:	74 2d                	je     f0106260 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
f0106233:	0f b6 13             	movzbl (%ebx),%edx
f0106236:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
f0106238:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
f010623b:	83 3b 7f             	cmpl   $0x7f,(%ebx)
f010623e:	0f 8e f8 fe ff ff    	jle    f010613c <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
f0106244:	68 c0 8e 10 f0       	push   $0xf0108ec0
f0106249:	68 d9 84 10 f0       	push   $0xf01084d9
f010624e:	53                   	push   %ebx
f010624f:	56                   	push   %esi
f0106250:	e8 02 fb ff ff       	call   f0105d57 <printfmt>
f0106255:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
f0106258:	89 7d 14             	mov    %edi,0x14(%ebp)
f010625b:	e9 dc fe ff ff       	jmp    f010613c <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
f0106260:	68 88 8e 10 f0       	push   $0xf0108e88
f0106265:	68 d9 84 10 f0       	push   $0xf01084d9
f010626a:	53                   	push   %ebx
f010626b:	56                   	push   %esi
f010626c:	e8 e6 fa ff ff       	call   f0105d57 <printfmt>
f0106271:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
f0106274:	89 7d 14             	mov    %edi,0x14(%ebp)
f0106277:	e9 c0 fe ff ff       	jmp    f010613c <vprintfmt+0x3c8>
			putch(ch, putdat);
f010627c:	83 ec 08             	sub    $0x8,%esp
f010627f:	53                   	push   %ebx
f0106280:	6a 25                	push   $0x25
f0106282:	ff d6                	call   *%esi
			break;
f0106284:	83 c4 10             	add    $0x10,%esp
f0106287:	e9 b0 fe ff ff       	jmp    f010613c <vprintfmt+0x3c8>
			putch('%', putdat);
f010628c:	83 ec 08             	sub    $0x8,%esp
f010628f:	53                   	push   %ebx
f0106290:	6a 25                	push   $0x25
f0106292:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0106294:	83 c4 10             	add    $0x10,%esp
f0106297:	89 f8                	mov    %edi,%eax
f0106299:	eb 03                	jmp    f010629e <vprintfmt+0x52a>
f010629b:	83 e8 01             	sub    $0x1,%eax
f010629e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01062a2:	75 f7                	jne    f010629b <vprintfmt+0x527>
f01062a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01062a7:	e9 90 fe ff ff       	jmp    f010613c <vprintfmt+0x3c8>
}
f01062ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01062af:	5b                   	pop    %ebx
f01062b0:	5e                   	pop    %esi
f01062b1:	5f                   	pop    %edi
f01062b2:	5d                   	pop    %ebp
f01062b3:	c3                   	ret    

f01062b4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01062b4:	55                   	push   %ebp
f01062b5:	89 e5                	mov    %esp,%ebp
f01062b7:	83 ec 18             	sub    $0x18,%esp
f01062ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01062bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01062c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01062c3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01062c7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01062ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01062d1:	85 c0                	test   %eax,%eax
f01062d3:	74 26                	je     f01062fb <vsnprintf+0x47>
f01062d5:	85 d2                	test   %edx,%edx
f01062d7:	7e 22                	jle    f01062fb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01062d9:	ff 75 14             	pushl  0x14(%ebp)
f01062dc:	ff 75 10             	pushl  0x10(%ebp)
f01062df:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01062e2:	50                   	push   %eax
f01062e3:	68 3a 5d 10 f0       	push   $0xf0105d3a
f01062e8:	e8 87 fa ff ff       	call   f0105d74 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01062ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01062f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01062f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01062f6:	83 c4 10             	add    $0x10,%esp
}
f01062f9:	c9                   	leave  
f01062fa:	c3                   	ret    
		return -E_INVAL;
f01062fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0106300:	eb f7                	jmp    f01062f9 <vsnprintf+0x45>

f0106302 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0106302:	55                   	push   %ebp
f0106303:	89 e5                	mov    %esp,%ebp
f0106305:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106308:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010630b:	50                   	push   %eax
f010630c:	ff 75 10             	pushl  0x10(%ebp)
f010630f:	ff 75 0c             	pushl  0xc(%ebp)
f0106312:	ff 75 08             	pushl  0x8(%ebp)
f0106315:	e8 9a ff ff ff       	call   f01062b4 <vsnprintf>
	va_end(ap);

	return rc;
}
f010631a:	c9                   	leave  
f010631b:	c3                   	ret    

f010631c <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010631c:	55                   	push   %ebp
f010631d:	89 e5                	mov    %esp,%ebp
f010631f:	57                   	push   %edi
f0106320:	56                   	push   %esi
f0106321:	53                   	push   %ebx
f0106322:	83 ec 0c             	sub    $0xc,%esp
f0106325:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106328:	85 c0                	test   %eax,%eax
f010632a:	74 11                	je     f010633d <readline+0x21>
		cprintf("%s", prompt);
f010632c:	83 ec 08             	sub    $0x8,%esp
f010632f:	50                   	push   %eax
f0106330:	68 d9 84 10 f0       	push   $0xf01084d9
f0106335:	e8 84 db ff ff       	call   f0103ebe <cprintf>
f010633a:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010633d:	83 ec 0c             	sub    $0xc,%esp
f0106340:	6a 00                	push   $0x0
f0106342:	e8 4c a4 ff ff       	call   f0100793 <iscons>
f0106347:	89 c7                	mov    %eax,%edi
f0106349:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010634c:	be 00 00 00 00       	mov    $0x0,%esi
f0106351:	eb 57                	jmp    f01063aa <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0106353:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0106358:	83 fb f8             	cmp    $0xfffffff8,%ebx
f010635b:	75 08                	jne    f0106365 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010635d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106360:	5b                   	pop    %ebx
f0106361:	5e                   	pop    %esi
f0106362:	5f                   	pop    %edi
f0106363:	5d                   	pop    %ebp
f0106364:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0106365:	83 ec 08             	sub    $0x8,%esp
f0106368:	53                   	push   %ebx
f0106369:	68 e0 90 10 f0       	push   $0xf01090e0
f010636e:	e8 4b db ff ff       	call   f0103ebe <cprintf>
f0106373:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0106376:	b8 00 00 00 00       	mov    $0x0,%eax
f010637b:	eb e0                	jmp    f010635d <readline+0x41>
			if (echoing)
f010637d:	85 ff                	test   %edi,%edi
f010637f:	75 05                	jne    f0106386 <readline+0x6a>
			i--;
f0106381:	83 ee 01             	sub    $0x1,%esi
f0106384:	eb 24                	jmp    f01063aa <readline+0x8e>
				cputchar('\b');
f0106386:	83 ec 0c             	sub    $0xc,%esp
f0106389:	6a 08                	push   $0x8
f010638b:	e8 e2 a3 ff ff       	call   f0100772 <cputchar>
f0106390:	83 c4 10             	add    $0x10,%esp
f0106393:	eb ec                	jmp    f0106381 <readline+0x65>
				cputchar(c);
f0106395:	83 ec 0c             	sub    $0xc,%esp
f0106398:	53                   	push   %ebx
f0106399:	e8 d4 a3 ff ff       	call   f0100772 <cputchar>
f010639e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01063a1:	88 9e 80 6a 35 f0    	mov    %bl,-0xfca9580(%esi)
f01063a7:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01063aa:	e8 d3 a3 ff ff       	call   f0100782 <getchar>
f01063af:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01063b1:	85 c0                	test   %eax,%eax
f01063b3:	78 9e                	js     f0106353 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01063b5:	83 f8 08             	cmp    $0x8,%eax
f01063b8:	0f 94 c2             	sete   %dl
f01063bb:	83 f8 7f             	cmp    $0x7f,%eax
f01063be:	0f 94 c0             	sete   %al
f01063c1:	08 c2                	or     %al,%dl
f01063c3:	74 04                	je     f01063c9 <readline+0xad>
f01063c5:	85 f6                	test   %esi,%esi
f01063c7:	7f b4                	jg     f010637d <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01063c9:	83 fb 1f             	cmp    $0x1f,%ebx
f01063cc:	7e 0e                	jle    f01063dc <readline+0xc0>
f01063ce:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01063d4:	7f 06                	jg     f01063dc <readline+0xc0>
			if (echoing)
f01063d6:	85 ff                	test   %edi,%edi
f01063d8:	74 c7                	je     f01063a1 <readline+0x85>
f01063da:	eb b9                	jmp    f0106395 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f01063dc:	83 fb 0a             	cmp    $0xa,%ebx
f01063df:	74 05                	je     f01063e6 <readline+0xca>
f01063e1:	83 fb 0d             	cmp    $0xd,%ebx
f01063e4:	75 c4                	jne    f01063aa <readline+0x8e>
			if (echoing)
f01063e6:	85 ff                	test   %edi,%edi
f01063e8:	75 11                	jne    f01063fb <readline+0xdf>
			buf[i] = 0;
f01063ea:	c6 86 80 6a 35 f0 00 	movb   $0x0,-0xfca9580(%esi)
			return buf;
f01063f1:	b8 80 6a 35 f0       	mov    $0xf0356a80,%eax
f01063f6:	e9 62 ff ff ff       	jmp    f010635d <readline+0x41>
				cputchar('\n');
f01063fb:	83 ec 0c             	sub    $0xc,%esp
f01063fe:	6a 0a                	push   $0xa
f0106400:	e8 6d a3 ff ff       	call   f0100772 <cputchar>
f0106405:	83 c4 10             	add    $0x10,%esp
f0106408:	eb e0                	jmp    f01063ea <readline+0xce>

f010640a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f010640a:	55                   	push   %ebp
f010640b:	89 e5                	mov    %esp,%ebp
f010640d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0106410:	b8 00 00 00 00       	mov    $0x0,%eax
f0106415:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106419:	74 05                	je     f0106420 <strlen+0x16>
		n++;
f010641b:	83 c0 01             	add    $0x1,%eax
f010641e:	eb f5                	jmp    f0106415 <strlen+0xb>
	return n;
}
f0106420:	5d                   	pop    %ebp
f0106421:	c3                   	ret    

f0106422 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106422:	55                   	push   %ebp
f0106423:	89 e5                	mov    %esp,%ebp
f0106425:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106428:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010642b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106430:	39 c2                	cmp    %eax,%edx
f0106432:	74 0d                	je     f0106441 <strnlen+0x1f>
f0106434:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106438:	74 05                	je     f010643f <strnlen+0x1d>
		n++;
f010643a:	83 c2 01             	add    $0x1,%edx
f010643d:	eb f1                	jmp    f0106430 <strnlen+0xe>
f010643f:	89 d0                	mov    %edx,%eax
	return n;
}
f0106441:	5d                   	pop    %ebp
f0106442:	c3                   	ret    

f0106443 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106443:	55                   	push   %ebp
f0106444:	89 e5                	mov    %esp,%ebp
f0106446:	53                   	push   %ebx
f0106447:	8b 45 08             	mov    0x8(%ebp),%eax
f010644a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010644d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106452:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106456:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0106459:	83 c2 01             	add    $0x1,%edx
f010645c:	84 c9                	test   %cl,%cl
f010645e:	75 f2                	jne    f0106452 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0106460:	5b                   	pop    %ebx
f0106461:	5d                   	pop    %ebp
f0106462:	c3                   	ret    

f0106463 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0106463:	55                   	push   %ebp
f0106464:	89 e5                	mov    %esp,%ebp
f0106466:	53                   	push   %ebx
f0106467:	83 ec 10             	sub    $0x10,%esp
f010646a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f010646d:	53                   	push   %ebx
f010646e:	e8 97 ff ff ff       	call   f010640a <strlen>
f0106473:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0106476:	ff 75 0c             	pushl  0xc(%ebp)
f0106479:	01 d8                	add    %ebx,%eax
f010647b:	50                   	push   %eax
f010647c:	e8 c2 ff ff ff       	call   f0106443 <strcpy>
	return dst;
}
f0106481:	89 d8                	mov    %ebx,%eax
f0106483:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106486:	c9                   	leave  
f0106487:	c3                   	ret    

f0106488 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106488:	55                   	push   %ebp
f0106489:	89 e5                	mov    %esp,%ebp
f010648b:	56                   	push   %esi
f010648c:	53                   	push   %ebx
f010648d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106490:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106493:	89 c6                	mov    %eax,%esi
f0106495:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0106498:	89 c2                	mov    %eax,%edx
f010649a:	39 f2                	cmp    %esi,%edx
f010649c:	74 11                	je     f01064af <strncpy+0x27>
		*dst++ = *src;
f010649e:	83 c2 01             	add    $0x1,%edx
f01064a1:	0f b6 19             	movzbl (%ecx),%ebx
f01064a4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01064a7:	80 fb 01             	cmp    $0x1,%bl
f01064aa:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01064ad:	eb eb                	jmp    f010649a <strncpy+0x12>
	}
	return ret;
}
f01064af:	5b                   	pop    %ebx
f01064b0:	5e                   	pop    %esi
f01064b1:	5d                   	pop    %ebp
f01064b2:	c3                   	ret    

f01064b3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01064b3:	55                   	push   %ebp
f01064b4:	89 e5                	mov    %esp,%ebp
f01064b6:	56                   	push   %esi
f01064b7:	53                   	push   %ebx
f01064b8:	8b 75 08             	mov    0x8(%ebp),%esi
f01064bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01064be:	8b 55 10             	mov    0x10(%ebp),%edx
f01064c1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01064c3:	85 d2                	test   %edx,%edx
f01064c5:	74 21                	je     f01064e8 <strlcpy+0x35>
f01064c7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01064cb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01064cd:	39 c2                	cmp    %eax,%edx
f01064cf:	74 14                	je     f01064e5 <strlcpy+0x32>
f01064d1:	0f b6 19             	movzbl (%ecx),%ebx
f01064d4:	84 db                	test   %bl,%bl
f01064d6:	74 0b                	je     f01064e3 <strlcpy+0x30>
			*dst++ = *src++;
f01064d8:	83 c1 01             	add    $0x1,%ecx
f01064db:	83 c2 01             	add    $0x1,%edx
f01064de:	88 5a ff             	mov    %bl,-0x1(%edx)
f01064e1:	eb ea                	jmp    f01064cd <strlcpy+0x1a>
f01064e3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01064e5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01064e8:	29 f0                	sub    %esi,%eax
}
f01064ea:	5b                   	pop    %ebx
f01064eb:	5e                   	pop    %esi
f01064ec:	5d                   	pop    %ebp
f01064ed:	c3                   	ret    

f01064ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01064ee:	55                   	push   %ebp
f01064ef:	89 e5                	mov    %esp,%ebp
f01064f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01064f4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01064f7:	0f b6 01             	movzbl (%ecx),%eax
f01064fa:	84 c0                	test   %al,%al
f01064fc:	74 0c                	je     f010650a <strcmp+0x1c>
f01064fe:	3a 02                	cmp    (%edx),%al
f0106500:	75 08                	jne    f010650a <strcmp+0x1c>
		p++, q++;
f0106502:	83 c1 01             	add    $0x1,%ecx
f0106505:	83 c2 01             	add    $0x1,%edx
f0106508:	eb ed                	jmp    f01064f7 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010650a:	0f b6 c0             	movzbl %al,%eax
f010650d:	0f b6 12             	movzbl (%edx),%edx
f0106510:	29 d0                	sub    %edx,%eax
}
f0106512:	5d                   	pop    %ebp
f0106513:	c3                   	ret    

f0106514 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106514:	55                   	push   %ebp
f0106515:	89 e5                	mov    %esp,%ebp
f0106517:	53                   	push   %ebx
f0106518:	8b 45 08             	mov    0x8(%ebp),%eax
f010651b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010651e:	89 c3                	mov    %eax,%ebx
f0106520:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0106523:	eb 06                	jmp    f010652b <strncmp+0x17>
		n--, p++, q++;
f0106525:	83 c0 01             	add    $0x1,%eax
f0106528:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f010652b:	39 d8                	cmp    %ebx,%eax
f010652d:	74 16                	je     f0106545 <strncmp+0x31>
f010652f:	0f b6 08             	movzbl (%eax),%ecx
f0106532:	84 c9                	test   %cl,%cl
f0106534:	74 04                	je     f010653a <strncmp+0x26>
f0106536:	3a 0a                	cmp    (%edx),%cl
f0106538:	74 eb                	je     f0106525 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f010653a:	0f b6 00             	movzbl (%eax),%eax
f010653d:	0f b6 12             	movzbl (%edx),%edx
f0106540:	29 d0                	sub    %edx,%eax
}
f0106542:	5b                   	pop    %ebx
f0106543:	5d                   	pop    %ebp
f0106544:	c3                   	ret    
		return 0;
f0106545:	b8 00 00 00 00       	mov    $0x0,%eax
f010654a:	eb f6                	jmp    f0106542 <strncmp+0x2e>

f010654c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010654c:	55                   	push   %ebp
f010654d:	89 e5                	mov    %esp,%ebp
f010654f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106552:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106556:	0f b6 10             	movzbl (%eax),%edx
f0106559:	84 d2                	test   %dl,%dl
f010655b:	74 09                	je     f0106566 <strchr+0x1a>
		if (*s == c)
f010655d:	38 ca                	cmp    %cl,%dl
f010655f:	74 0a                	je     f010656b <strchr+0x1f>
	for (; *s; s++)
f0106561:	83 c0 01             	add    $0x1,%eax
f0106564:	eb f0                	jmp    f0106556 <strchr+0xa>
			return (char *) s;
	return 0;
f0106566:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010656b:	5d                   	pop    %ebp
f010656c:	c3                   	ret    

f010656d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010656d:	55                   	push   %ebp
f010656e:	89 e5                	mov    %esp,%ebp
f0106570:	8b 45 08             	mov    0x8(%ebp),%eax
f0106573:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106577:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f010657a:	38 ca                	cmp    %cl,%dl
f010657c:	74 09                	je     f0106587 <strfind+0x1a>
f010657e:	84 d2                	test   %dl,%dl
f0106580:	74 05                	je     f0106587 <strfind+0x1a>
	for (; *s; s++)
f0106582:	83 c0 01             	add    $0x1,%eax
f0106585:	eb f0                	jmp    f0106577 <strfind+0xa>
			break;
	return (char *) s;
}
f0106587:	5d                   	pop    %ebp
f0106588:	c3                   	ret    

f0106589 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0106589:	55                   	push   %ebp
f010658a:	89 e5                	mov    %esp,%ebp
f010658c:	57                   	push   %edi
f010658d:	56                   	push   %esi
f010658e:	53                   	push   %ebx
f010658f:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106592:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0106595:	85 c9                	test   %ecx,%ecx
f0106597:	74 31                	je     f01065ca <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0106599:	89 f8                	mov    %edi,%eax
f010659b:	09 c8                	or     %ecx,%eax
f010659d:	a8 03                	test   $0x3,%al
f010659f:	75 23                	jne    f01065c4 <memset+0x3b>
		c &= 0xFF;
f01065a1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01065a5:	89 d3                	mov    %edx,%ebx
f01065a7:	c1 e3 08             	shl    $0x8,%ebx
f01065aa:	89 d0                	mov    %edx,%eax
f01065ac:	c1 e0 18             	shl    $0x18,%eax
f01065af:	89 d6                	mov    %edx,%esi
f01065b1:	c1 e6 10             	shl    $0x10,%esi
f01065b4:	09 f0                	or     %esi,%eax
f01065b6:	09 c2                	or     %eax,%edx
f01065b8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01065ba:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01065bd:	89 d0                	mov    %edx,%eax
f01065bf:	fc                   	cld    
f01065c0:	f3 ab                	rep stos %eax,%es:(%edi)
f01065c2:	eb 06                	jmp    f01065ca <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01065c4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01065c7:	fc                   	cld    
f01065c8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01065ca:	89 f8                	mov    %edi,%eax
f01065cc:	5b                   	pop    %ebx
f01065cd:	5e                   	pop    %esi
f01065ce:	5f                   	pop    %edi
f01065cf:	5d                   	pop    %ebp
f01065d0:	c3                   	ret    

f01065d1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01065d1:	55                   	push   %ebp
f01065d2:	89 e5                	mov    %esp,%ebp
f01065d4:	57                   	push   %edi
f01065d5:	56                   	push   %esi
f01065d6:	8b 45 08             	mov    0x8(%ebp),%eax
f01065d9:	8b 75 0c             	mov    0xc(%ebp),%esi
f01065dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01065df:	39 c6                	cmp    %eax,%esi
f01065e1:	73 32                	jae    f0106615 <memmove+0x44>
f01065e3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01065e6:	39 c2                	cmp    %eax,%edx
f01065e8:	76 2b                	jbe    f0106615 <memmove+0x44>
		s += n;
		d += n;
f01065ea:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01065ed:	89 fe                	mov    %edi,%esi
f01065ef:	09 ce                	or     %ecx,%esi
f01065f1:	09 d6                	or     %edx,%esi
f01065f3:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01065f9:	75 0e                	jne    f0106609 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f01065fb:	83 ef 04             	sub    $0x4,%edi
f01065fe:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106601:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0106604:	fd                   	std    
f0106605:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106607:	eb 09                	jmp    f0106612 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106609:	83 ef 01             	sub    $0x1,%edi
f010660c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010660f:	fd                   	std    
f0106610:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106612:	fc                   	cld    
f0106613:	eb 1a                	jmp    f010662f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106615:	89 c2                	mov    %eax,%edx
f0106617:	09 ca                	or     %ecx,%edx
f0106619:	09 f2                	or     %esi,%edx
f010661b:	f6 c2 03             	test   $0x3,%dl
f010661e:	75 0a                	jne    f010662a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0106620:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0106623:	89 c7                	mov    %eax,%edi
f0106625:	fc                   	cld    
f0106626:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106628:	eb 05                	jmp    f010662f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f010662a:	89 c7                	mov    %eax,%edi
f010662c:	fc                   	cld    
f010662d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010662f:	5e                   	pop    %esi
f0106630:	5f                   	pop    %edi
f0106631:	5d                   	pop    %ebp
f0106632:	c3                   	ret    

f0106633 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0106633:	55                   	push   %ebp
f0106634:	89 e5                	mov    %esp,%ebp
f0106636:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106639:	ff 75 10             	pushl  0x10(%ebp)
f010663c:	ff 75 0c             	pushl  0xc(%ebp)
f010663f:	ff 75 08             	pushl  0x8(%ebp)
f0106642:	e8 8a ff ff ff       	call   f01065d1 <memmove>
}
f0106647:	c9                   	leave  
f0106648:	c3                   	ret    

f0106649 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106649:	55                   	push   %ebp
f010664a:	89 e5                	mov    %esp,%ebp
f010664c:	56                   	push   %esi
f010664d:	53                   	push   %ebx
f010664e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106651:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106654:	89 c6                	mov    %eax,%esi
f0106656:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106659:	39 f0                	cmp    %esi,%eax
f010665b:	74 1c                	je     f0106679 <memcmp+0x30>
		if (*s1 != *s2)
f010665d:	0f b6 08             	movzbl (%eax),%ecx
f0106660:	0f b6 1a             	movzbl (%edx),%ebx
f0106663:	38 d9                	cmp    %bl,%cl
f0106665:	75 08                	jne    f010666f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0106667:	83 c0 01             	add    $0x1,%eax
f010666a:	83 c2 01             	add    $0x1,%edx
f010666d:	eb ea                	jmp    f0106659 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f010666f:	0f b6 c1             	movzbl %cl,%eax
f0106672:	0f b6 db             	movzbl %bl,%ebx
f0106675:	29 d8                	sub    %ebx,%eax
f0106677:	eb 05                	jmp    f010667e <memcmp+0x35>
	}

	return 0;
f0106679:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010667e:	5b                   	pop    %ebx
f010667f:	5e                   	pop    %esi
f0106680:	5d                   	pop    %ebp
f0106681:	c3                   	ret    

f0106682 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0106682:	55                   	push   %ebp
f0106683:	89 e5                	mov    %esp,%ebp
f0106685:	8b 45 08             	mov    0x8(%ebp),%eax
f0106688:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f010668b:	89 c2                	mov    %eax,%edx
f010668d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0106690:	39 d0                	cmp    %edx,%eax
f0106692:	73 09                	jae    f010669d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0106694:	38 08                	cmp    %cl,(%eax)
f0106696:	74 05                	je     f010669d <memfind+0x1b>
	for (; s < ends; s++)
f0106698:	83 c0 01             	add    $0x1,%eax
f010669b:	eb f3                	jmp    f0106690 <memfind+0xe>
			break;
	return (void *) s;
}
f010669d:	5d                   	pop    %ebp
f010669e:	c3                   	ret    

f010669f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f010669f:	55                   	push   %ebp
f01066a0:	89 e5                	mov    %esp,%ebp
f01066a2:	57                   	push   %edi
f01066a3:	56                   	push   %esi
f01066a4:	53                   	push   %ebx
f01066a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01066a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01066ab:	eb 03                	jmp    f01066b0 <strtol+0x11>
		s++;
f01066ad:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01066b0:	0f b6 01             	movzbl (%ecx),%eax
f01066b3:	3c 20                	cmp    $0x20,%al
f01066b5:	74 f6                	je     f01066ad <strtol+0xe>
f01066b7:	3c 09                	cmp    $0x9,%al
f01066b9:	74 f2                	je     f01066ad <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01066bb:	3c 2b                	cmp    $0x2b,%al
f01066bd:	74 2a                	je     f01066e9 <strtol+0x4a>
	int neg = 0;
f01066bf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01066c4:	3c 2d                	cmp    $0x2d,%al
f01066c6:	74 2b                	je     f01066f3 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01066c8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01066ce:	75 0f                	jne    f01066df <strtol+0x40>
f01066d0:	80 39 30             	cmpb   $0x30,(%ecx)
f01066d3:	74 28                	je     f01066fd <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01066d5:	85 db                	test   %ebx,%ebx
f01066d7:	b8 0a 00 00 00       	mov    $0xa,%eax
f01066dc:	0f 44 d8             	cmove  %eax,%ebx
f01066df:	b8 00 00 00 00       	mov    $0x0,%eax
f01066e4:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01066e7:	eb 50                	jmp    f0106739 <strtol+0x9a>
		s++;
f01066e9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01066ec:	bf 00 00 00 00       	mov    $0x0,%edi
f01066f1:	eb d5                	jmp    f01066c8 <strtol+0x29>
		s++, neg = 1;
f01066f3:	83 c1 01             	add    $0x1,%ecx
f01066f6:	bf 01 00 00 00       	mov    $0x1,%edi
f01066fb:	eb cb                	jmp    f01066c8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01066fd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0106701:	74 0e                	je     f0106711 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0106703:	85 db                	test   %ebx,%ebx
f0106705:	75 d8                	jne    f01066df <strtol+0x40>
		s++, base = 8;
f0106707:	83 c1 01             	add    $0x1,%ecx
f010670a:	bb 08 00 00 00       	mov    $0x8,%ebx
f010670f:	eb ce                	jmp    f01066df <strtol+0x40>
		s += 2, base = 16;
f0106711:	83 c1 02             	add    $0x2,%ecx
f0106714:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106719:	eb c4                	jmp    f01066df <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f010671b:	8d 72 9f             	lea    -0x61(%edx),%esi
f010671e:	89 f3                	mov    %esi,%ebx
f0106720:	80 fb 19             	cmp    $0x19,%bl
f0106723:	77 29                	ja     f010674e <strtol+0xaf>
			dig = *s - 'a' + 10;
f0106725:	0f be d2             	movsbl %dl,%edx
f0106728:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f010672b:	3b 55 10             	cmp    0x10(%ebp),%edx
f010672e:	7d 30                	jge    f0106760 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0106730:	83 c1 01             	add    $0x1,%ecx
f0106733:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106737:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106739:	0f b6 11             	movzbl (%ecx),%edx
f010673c:	8d 72 d0             	lea    -0x30(%edx),%esi
f010673f:	89 f3                	mov    %esi,%ebx
f0106741:	80 fb 09             	cmp    $0x9,%bl
f0106744:	77 d5                	ja     f010671b <strtol+0x7c>
			dig = *s - '0';
f0106746:	0f be d2             	movsbl %dl,%edx
f0106749:	83 ea 30             	sub    $0x30,%edx
f010674c:	eb dd                	jmp    f010672b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f010674e:	8d 72 bf             	lea    -0x41(%edx),%esi
f0106751:	89 f3                	mov    %esi,%ebx
f0106753:	80 fb 19             	cmp    $0x19,%bl
f0106756:	77 08                	ja     f0106760 <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106758:	0f be d2             	movsbl %dl,%edx
f010675b:	83 ea 37             	sub    $0x37,%edx
f010675e:	eb cb                	jmp    f010672b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f0106760:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106764:	74 05                	je     f010676b <strtol+0xcc>
		*endptr = (char *) s;
f0106766:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106769:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f010676b:	89 c2                	mov    %eax,%edx
f010676d:	f7 da                	neg    %edx
f010676f:	85 ff                	test   %edi,%edi
f0106771:	0f 45 c2             	cmovne %edx,%eax
}
f0106774:	5b                   	pop    %ebx
f0106775:	5e                   	pop    %esi
f0106776:	5f                   	pop    %edi
f0106777:	5d                   	pop    %ebp
f0106778:	c3                   	ret    
f0106779:	66 90                	xchg   %ax,%ax
f010677b:	90                   	nop

f010677c <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f010677c:	fa                   	cli    

	xorw    %ax, %ax
f010677d:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f010677f:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106781:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106783:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106785:	0f 01 16             	lgdtl  (%esi)
f0106788:	74 70                	je     f01067fa <mpsearch1+0x3>
	movl    %cr0, %eax
f010678a:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f010678d:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106791:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106794:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f010679a:	08 00                	or     %al,(%eax)

f010679c <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f010679c:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01067a0:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01067a2:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01067a4:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01067a6:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01067aa:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01067ac:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01067ae:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl    %eax, %cr3
f01067b3:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01067b6:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01067b9:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01067be:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01067c1:	8b 25 84 6e 35 f0    	mov    0xf0356e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01067c7:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f01067cc:	b8 a4 01 10 f0       	mov    $0xf01001a4,%eax
	call    *%eax
f01067d1:	ff d0                	call   *%eax

f01067d3 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f01067d3:	eb fe                	jmp    f01067d3 <spin>
f01067d5:	8d 76 00             	lea    0x0(%esi),%esi

f01067d8 <gdt>:
	...
f01067e0:	ff                   	(bad)  
f01067e1:	ff 00                	incl   (%eax)
f01067e3:	00 00                	add    %al,(%eax)
f01067e5:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f01067ec:	00                   	.byte 0x0
f01067ed:	92                   	xchg   %eax,%edx
f01067ee:	cf                   	iret   
	...

f01067f0 <gdtdesc>:
f01067f0:	17                   	pop    %ss
f01067f1:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f01067f6 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f01067f6:	90                   	nop

f01067f7 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f01067f7:	55                   	push   %ebp
f01067f8:	89 e5                	mov    %esp,%ebp
f01067fa:	57                   	push   %edi
f01067fb:	56                   	push   %esi
f01067fc:	53                   	push   %ebx
f01067fd:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106800:	8b 0d 88 6e 35 f0    	mov    0xf0356e88,%ecx
f0106806:	89 c3                	mov    %eax,%ebx
f0106808:	c1 eb 0c             	shr    $0xc,%ebx
f010680b:	39 cb                	cmp    %ecx,%ebx
f010680d:	73 1a                	jae    f0106829 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f010680f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106815:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106818:	89 f8                	mov    %edi,%eax
f010681a:	c1 e8 0c             	shr    $0xc,%eax
f010681d:	39 c8                	cmp    %ecx,%eax
f010681f:	73 1a                	jae    f010683b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106821:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106827:	eb 27                	jmp    f0106850 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106829:	50                   	push   %eax
f010682a:	68 04 72 10 f0       	push   $0xf0107204
f010682f:	6a 57                	push   $0x57
f0106831:	68 7d 92 10 f0       	push   $0xf010927d
f0106836:	e8 05 98 ff ff       	call   f0100040 <_panic>
f010683b:	57                   	push   %edi
f010683c:	68 04 72 10 f0       	push   $0xf0107204
f0106841:	6a 57                	push   $0x57
f0106843:	68 7d 92 10 f0       	push   $0xf010927d
f0106848:	e8 f3 97 ff ff       	call   f0100040 <_panic>
f010684d:	83 c3 10             	add    $0x10,%ebx
f0106850:	39 fb                	cmp    %edi,%ebx
f0106852:	73 30                	jae    f0106884 <mpsearch1+0x8d>
f0106854:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106856:	83 ec 04             	sub    $0x4,%esp
f0106859:	6a 04                	push   $0x4
f010685b:	68 8d 92 10 f0       	push   $0xf010928d
f0106860:	53                   	push   %ebx
f0106861:	e8 e3 fd ff ff       	call   f0106649 <memcmp>
f0106866:	83 c4 10             	add    $0x10,%esp
f0106869:	85 c0                	test   %eax,%eax
f010686b:	75 e0                	jne    f010684d <mpsearch1+0x56>
f010686d:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f010686f:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0106872:	0f b6 0a             	movzbl (%edx),%ecx
f0106875:	01 c8                	add    %ecx,%eax
f0106877:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f010687a:	39 f2                	cmp    %esi,%edx
f010687c:	75 f4                	jne    f0106872 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010687e:	84 c0                	test   %al,%al
f0106880:	75 cb                	jne    f010684d <mpsearch1+0x56>
f0106882:	eb 05                	jmp    f0106889 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0106884:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0106889:	89 d8                	mov    %ebx,%eax
f010688b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010688e:	5b                   	pop    %ebx
f010688f:	5e                   	pop    %esi
f0106890:	5f                   	pop    %edi
f0106891:	5d                   	pop    %ebp
f0106892:	c3                   	ret    

f0106893 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106893:	55                   	push   %ebp
f0106894:	89 e5                	mov    %esp,%ebp
f0106896:	57                   	push   %edi
f0106897:	56                   	push   %esi
f0106898:	53                   	push   %ebx
f0106899:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f010689c:	c7 05 c0 73 35 f0 20 	movl   $0xf0357020,0xf03573c0
f01068a3:	70 35 f0 
	if (PGNUM(pa) >= npages)
f01068a6:	83 3d 88 6e 35 f0 00 	cmpl   $0x0,0xf0356e88
f01068ad:	0f 84 a3 00 00 00    	je     f0106956 <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01068b3:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01068ba:	85 c0                	test   %eax,%eax
f01068bc:	0f 84 aa 00 00 00    	je     f010696c <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f01068c2:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01068c5:	ba 00 04 00 00       	mov    $0x400,%edx
f01068ca:	e8 28 ff ff ff       	call   f01067f7 <mpsearch1>
f01068cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01068d2:	85 c0                	test   %eax,%eax
f01068d4:	75 1a                	jne    f01068f0 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f01068d6:	ba 00 00 01 00       	mov    $0x10000,%edx
f01068db:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f01068e0:	e8 12 ff ff ff       	call   f01067f7 <mpsearch1>
f01068e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f01068e8:	85 c0                	test   %eax,%eax
f01068ea:	0f 84 31 02 00 00    	je     f0106b21 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f01068f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01068f3:	8b 58 04             	mov    0x4(%eax),%ebx
f01068f6:	85 db                	test   %ebx,%ebx
f01068f8:	0f 84 97 00 00 00    	je     f0106995 <mp_init+0x102>
f01068fe:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106902:	0f 85 8d 00 00 00    	jne    f0106995 <mp_init+0x102>
f0106908:	89 d8                	mov    %ebx,%eax
f010690a:	c1 e8 0c             	shr    $0xc,%eax
f010690d:	3b 05 88 6e 35 f0    	cmp    0xf0356e88,%eax
f0106913:	0f 83 91 00 00 00    	jae    f01069aa <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106919:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f010691f:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106921:	83 ec 04             	sub    $0x4,%esp
f0106924:	6a 04                	push   $0x4
f0106926:	68 92 92 10 f0       	push   $0xf0109292
f010692b:	53                   	push   %ebx
f010692c:	e8 18 fd ff ff       	call   f0106649 <memcmp>
f0106931:	83 c4 10             	add    $0x10,%esp
f0106934:	85 c0                	test   %eax,%eax
f0106936:	0f 85 83 00 00 00    	jne    f01069bf <mp_init+0x12c>
f010693c:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106940:	01 df                	add    %ebx,%edi
	sum = 0;
f0106942:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106944:	39 fb                	cmp    %edi,%ebx
f0106946:	0f 84 88 00 00 00    	je     f01069d4 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f010694c:	0f b6 0b             	movzbl (%ebx),%ecx
f010694f:	01 ca                	add    %ecx,%edx
f0106951:	83 c3 01             	add    $0x1,%ebx
f0106954:	eb ee                	jmp    f0106944 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106956:	68 00 04 00 00       	push   $0x400
f010695b:	68 04 72 10 f0       	push   $0xf0107204
f0106960:	6a 6f                	push   $0x6f
f0106962:	68 7d 92 10 f0       	push   $0xf010927d
f0106967:	e8 d4 96 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f010696c:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0106973:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0106976:	2d 00 04 00 00       	sub    $0x400,%eax
f010697b:	ba 00 04 00 00       	mov    $0x400,%edx
f0106980:	e8 72 fe ff ff       	call   f01067f7 <mpsearch1>
f0106985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106988:	85 c0                	test   %eax,%eax
f010698a:	0f 85 60 ff ff ff    	jne    f01068f0 <mp_init+0x5d>
f0106990:	e9 41 ff ff ff       	jmp    f01068d6 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f0106995:	83 ec 0c             	sub    $0xc,%esp
f0106998:	68 f0 90 10 f0       	push   $0xf01090f0
f010699d:	e8 1c d5 ff ff       	call   f0103ebe <cprintf>
f01069a2:	83 c4 10             	add    $0x10,%esp
f01069a5:	e9 77 01 00 00       	jmp    f0106b21 <mp_init+0x28e>
f01069aa:	53                   	push   %ebx
f01069ab:	68 04 72 10 f0       	push   $0xf0107204
f01069b0:	68 90 00 00 00       	push   $0x90
f01069b5:	68 7d 92 10 f0       	push   $0xf010927d
f01069ba:	e8 81 96 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01069bf:	83 ec 0c             	sub    $0xc,%esp
f01069c2:	68 20 91 10 f0       	push   $0xf0109120
f01069c7:	e8 f2 d4 ff ff       	call   f0103ebe <cprintf>
f01069cc:	83 c4 10             	add    $0x10,%esp
f01069cf:	e9 4d 01 00 00       	jmp    f0106b21 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f01069d4:	84 d2                	test   %dl,%dl
f01069d6:	75 16                	jne    f01069ee <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f01069d8:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f01069dc:	80 fa 01             	cmp    $0x1,%dl
f01069df:	74 05                	je     f01069e6 <mp_init+0x153>
f01069e1:	80 fa 04             	cmp    $0x4,%dl
f01069e4:	75 1d                	jne    f0106a03 <mp_init+0x170>
f01069e6:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f01069ea:	01 d9                	add    %ebx,%ecx
f01069ec:	eb 36                	jmp    f0106a24 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f01069ee:	83 ec 0c             	sub    $0xc,%esp
f01069f1:	68 54 91 10 f0       	push   $0xf0109154
f01069f6:	e8 c3 d4 ff ff       	call   f0103ebe <cprintf>
f01069fb:	83 c4 10             	add    $0x10,%esp
f01069fe:	e9 1e 01 00 00       	jmp    f0106b21 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106a03:	83 ec 08             	sub    $0x8,%esp
f0106a06:	0f b6 d2             	movzbl %dl,%edx
f0106a09:	52                   	push   %edx
f0106a0a:	68 78 91 10 f0       	push   $0xf0109178
f0106a0f:	e8 aa d4 ff ff       	call   f0103ebe <cprintf>
f0106a14:	83 c4 10             	add    $0x10,%esp
f0106a17:	e9 05 01 00 00       	jmp    f0106b21 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0106a1c:	0f b6 13             	movzbl (%ebx),%edx
f0106a1f:	01 d0                	add    %edx,%eax
f0106a21:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106a24:	39 d9                	cmp    %ebx,%ecx
f0106a26:	75 f4                	jne    f0106a1c <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106a28:	02 46 2a             	add    0x2a(%esi),%al
f0106a2b:	75 1c                	jne    f0106a49 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106a2d:	c7 05 00 70 35 f0 01 	movl   $0x1,0xf0357000
f0106a34:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106a37:	8b 46 24             	mov    0x24(%esi),%eax
f0106a3a:	a3 00 80 39 f0       	mov    %eax,0xf0398000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106a3f:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106a42:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106a47:	eb 4d                	jmp    f0106a96 <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106a49:	83 ec 0c             	sub    $0xc,%esp
f0106a4c:	68 98 91 10 f0       	push   $0xf0109198
f0106a51:	e8 68 d4 ff ff       	call   f0103ebe <cprintf>
f0106a56:	83 c4 10             	add    $0x10,%esp
f0106a59:	e9 c3 00 00 00       	jmp    f0106b21 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106a5e:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106a62:	74 11                	je     f0106a75 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106a64:	6b 05 c4 73 35 f0 74 	imul   $0x74,0xf03573c4,%eax
f0106a6b:	05 20 70 35 f0       	add    $0xf0357020,%eax
f0106a70:	a3 c0 73 35 f0       	mov    %eax,0xf03573c0
			if (ncpu < NCPU) {
f0106a75:	a1 c4 73 35 f0       	mov    0xf03573c4,%eax
f0106a7a:	83 f8 07             	cmp    $0x7,%eax
f0106a7d:	7f 2f                	jg     f0106aae <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f0106a7f:	6b d0 74             	imul   $0x74,%eax,%edx
f0106a82:	88 82 20 70 35 f0    	mov    %al,-0xfca8fe0(%edx)
				ncpu++;
f0106a88:	83 c0 01             	add    $0x1,%eax
f0106a8b:	a3 c4 73 35 f0       	mov    %eax,0xf03573c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106a90:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106a93:	83 c3 01             	add    $0x1,%ebx
f0106a96:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0106a9a:	39 d8                	cmp    %ebx,%eax
f0106a9c:	76 4b                	jbe    f0106ae9 <mp_init+0x256>
		switch (*p) {
f0106a9e:	0f b6 07             	movzbl (%edi),%eax
f0106aa1:	84 c0                	test   %al,%al
f0106aa3:	74 b9                	je     f0106a5e <mp_init+0x1cb>
f0106aa5:	3c 04                	cmp    $0x4,%al
f0106aa7:	77 1c                	ja     f0106ac5 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106aa9:	83 c7 08             	add    $0x8,%edi
			continue;
f0106aac:	eb e5                	jmp    f0106a93 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106aae:	83 ec 08             	sub    $0x8,%esp
f0106ab1:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106ab5:	50                   	push   %eax
f0106ab6:	68 c8 91 10 f0       	push   $0xf01091c8
f0106abb:	e8 fe d3 ff ff       	call   f0103ebe <cprintf>
f0106ac0:	83 c4 10             	add    $0x10,%esp
f0106ac3:	eb cb                	jmp    f0106a90 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106ac5:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106ac8:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0106acb:	50                   	push   %eax
f0106acc:	68 f0 91 10 f0       	push   $0xf01091f0
f0106ad1:	e8 e8 d3 ff ff       	call   f0103ebe <cprintf>
			ismp = 0;
f0106ad6:	c7 05 00 70 35 f0 00 	movl   $0x0,0xf0357000
f0106add:	00 00 00 
			i = conf->entry;
f0106ae0:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106ae4:	83 c4 10             	add    $0x10,%esp
f0106ae7:	eb aa                	jmp    f0106a93 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106ae9:	a1 c0 73 35 f0       	mov    0xf03573c0,%eax
f0106aee:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106af5:	83 3d 00 70 35 f0 00 	cmpl   $0x0,0xf0357000
f0106afc:	74 2b                	je     f0106b29 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106afe:	83 ec 04             	sub    $0x4,%esp
f0106b01:	ff 35 c4 73 35 f0    	pushl  0xf03573c4
f0106b07:	0f b6 00             	movzbl (%eax),%eax
f0106b0a:	50                   	push   %eax
f0106b0b:	68 97 92 10 f0       	push   $0xf0109297
f0106b10:	e8 a9 d3 ff ff       	call   f0103ebe <cprintf>

	if (mp->imcrp) {
f0106b15:	83 c4 10             	add    $0x10,%esp
f0106b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106b1b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106b1f:	75 2e                	jne    f0106b4f <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106b24:	5b                   	pop    %ebx
f0106b25:	5e                   	pop    %esi
f0106b26:	5f                   	pop    %edi
f0106b27:	5d                   	pop    %ebp
f0106b28:	c3                   	ret    
		ncpu = 1;
f0106b29:	c7 05 c4 73 35 f0 01 	movl   $0x1,0xf03573c4
f0106b30:	00 00 00 
		lapicaddr = 0;
f0106b33:	c7 05 00 80 39 f0 00 	movl   $0x0,0xf0398000
f0106b3a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106b3d:	83 ec 0c             	sub    $0xc,%esp
f0106b40:	68 10 92 10 f0       	push   $0xf0109210
f0106b45:	e8 74 d3 ff ff       	call   f0103ebe <cprintf>
		return;
f0106b4a:	83 c4 10             	add    $0x10,%esp
f0106b4d:	eb d2                	jmp    f0106b21 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106b4f:	83 ec 0c             	sub    $0xc,%esp
f0106b52:	68 3c 92 10 f0       	push   $0xf010923c
f0106b57:	e8 62 d3 ff ff       	call   f0103ebe <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106b5c:	b8 70 00 00 00       	mov    $0x70,%eax
f0106b61:	ba 22 00 00 00       	mov    $0x22,%edx
f0106b66:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106b67:	ba 23 00 00 00       	mov    $0x23,%edx
f0106b6c:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106b6d:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106b70:	ee                   	out    %al,(%dx)
f0106b71:	83 c4 10             	add    $0x10,%esp
f0106b74:	eb ab                	jmp    f0106b21 <mp_init+0x28e>

f0106b76 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106b76:	8b 0d 04 80 39 f0    	mov    0xf0398004,%ecx
f0106b7c:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106b7f:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106b81:	a1 04 80 39 f0       	mov    0xf0398004,%eax
f0106b86:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106b89:	c3                   	ret    

f0106b8a <cpunum>:
}

int
cpunum(void)
{
	if (lapic)
f0106b8a:	8b 15 04 80 39 f0    	mov    0xf0398004,%edx
		return lapic[ID] >> 24;
	return 0;
f0106b90:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0106b95:	85 d2                	test   %edx,%edx
f0106b97:	74 06                	je     f0106b9f <cpunum+0x15>
		return lapic[ID] >> 24;
f0106b99:	8b 42 20             	mov    0x20(%edx),%eax
f0106b9c:	c1 e8 18             	shr    $0x18,%eax
}
f0106b9f:	c3                   	ret    

f0106ba0 <lapic_init>:
	if (!lapicaddr)
f0106ba0:	a1 00 80 39 f0       	mov    0xf0398000,%eax
f0106ba5:	85 c0                	test   %eax,%eax
f0106ba7:	75 01                	jne    f0106baa <lapic_init+0xa>
f0106ba9:	c3                   	ret    
{
f0106baa:	55                   	push   %ebp
f0106bab:	89 e5                	mov    %esp,%ebp
f0106bad:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106bb0:	68 00 10 00 00       	push   $0x1000
f0106bb5:	50                   	push   %eax
f0106bb6:	e8 83 ac ff ff       	call   f010183e <mmio_map_region>
f0106bbb:	a3 04 80 39 f0       	mov    %eax,0xf0398004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106bc0:	ba 27 01 00 00       	mov    $0x127,%edx
f0106bc5:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106bca:	e8 a7 ff ff ff       	call   f0106b76 <lapicw>
	lapicw(TDCR, X1);
f0106bcf:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106bd4:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106bd9:	e8 98 ff ff ff       	call   f0106b76 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106bde:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106be3:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106be8:	e8 89 ff ff ff       	call   f0106b76 <lapicw>
	lapicw(TICR, 10000000); 
f0106bed:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106bf2:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106bf7:	e8 7a ff ff ff       	call   f0106b76 <lapicw>
	if (thiscpu != bootcpu)
f0106bfc:	e8 89 ff ff ff       	call   f0106b8a <cpunum>
f0106c01:	6b c0 74             	imul   $0x74,%eax,%eax
f0106c04:	05 20 70 35 f0       	add    $0xf0357020,%eax
f0106c09:	83 c4 10             	add    $0x10,%esp
f0106c0c:	39 05 c0 73 35 f0    	cmp    %eax,0xf03573c0
f0106c12:	74 0f                	je     f0106c23 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0106c14:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c19:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106c1e:	e8 53 ff ff ff       	call   f0106b76 <lapicw>
	lapicw(LINT1, MASKED);
f0106c23:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c28:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106c2d:	e8 44 ff ff ff       	call   f0106b76 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106c32:	a1 04 80 39 f0       	mov    0xf0398004,%eax
f0106c37:	8b 40 30             	mov    0x30(%eax),%eax
f0106c3a:	c1 e8 10             	shr    $0x10,%eax
f0106c3d:	a8 fc                	test   $0xfc,%al
f0106c3f:	75 7c                	jne    f0106cbd <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106c41:	ba 33 00 00 00       	mov    $0x33,%edx
f0106c46:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106c4b:	e8 26 ff ff ff       	call   f0106b76 <lapicw>
	lapicw(ESR, 0);
f0106c50:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c55:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106c5a:	e8 17 ff ff ff       	call   f0106b76 <lapicw>
	lapicw(ESR, 0);
f0106c5f:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c64:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106c69:	e8 08 ff ff ff       	call   f0106b76 <lapicw>
	lapicw(EOI, 0);
f0106c6e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c73:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106c78:	e8 f9 fe ff ff       	call   f0106b76 <lapicw>
	lapicw(ICRHI, 0);
f0106c7d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c82:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106c87:	e8 ea fe ff ff       	call   f0106b76 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106c8c:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106c91:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106c96:	e8 db fe ff ff       	call   f0106b76 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106c9b:	8b 15 04 80 39 f0    	mov    0xf0398004,%edx
f0106ca1:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106ca7:	f6 c4 10             	test   $0x10,%ah
f0106caa:	75 f5                	jne    f0106ca1 <lapic_init+0x101>
	lapicw(TPR, 0);
f0106cac:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cb1:	b8 20 00 00 00       	mov    $0x20,%eax
f0106cb6:	e8 bb fe ff ff       	call   f0106b76 <lapicw>
}
f0106cbb:	c9                   	leave  
f0106cbc:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106cbd:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106cc2:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106cc7:	e8 aa fe ff ff       	call   f0106b76 <lapicw>
f0106ccc:	e9 70 ff ff ff       	jmp    f0106c41 <lapic_init+0xa1>

f0106cd1 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106cd1:	83 3d 04 80 39 f0 00 	cmpl   $0x0,0xf0398004
f0106cd8:	74 17                	je     f0106cf1 <lapic_eoi+0x20>
{
f0106cda:	55                   	push   %ebp
f0106cdb:	89 e5                	mov    %esp,%ebp
f0106cdd:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0106ce0:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ce5:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106cea:	e8 87 fe ff ff       	call   f0106b76 <lapicw>
}
f0106cef:	c9                   	leave  
f0106cf0:	c3                   	ret    
f0106cf1:	c3                   	ret    

f0106cf2 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106cf2:	55                   	push   %ebp
f0106cf3:	89 e5                	mov    %esp,%ebp
f0106cf5:	56                   	push   %esi
f0106cf6:	53                   	push   %ebx
f0106cf7:	8b 75 08             	mov    0x8(%ebp),%esi
f0106cfa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106cfd:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106d02:	ba 70 00 00 00       	mov    $0x70,%edx
f0106d07:	ee                   	out    %al,(%dx)
f0106d08:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106d0d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106d12:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106d13:	83 3d 88 6e 35 f0 00 	cmpl   $0x0,0xf0356e88
f0106d1a:	74 7e                	je     f0106d9a <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106d1c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106d23:	00 00 
	wrv[1] = addr >> 4;
f0106d25:	89 d8                	mov    %ebx,%eax
f0106d27:	c1 e8 04             	shr    $0x4,%eax
f0106d2a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106d30:	c1 e6 18             	shl    $0x18,%esi
f0106d33:	89 f2                	mov    %esi,%edx
f0106d35:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106d3a:	e8 37 fe ff ff       	call   f0106b76 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106d3f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106d44:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d49:	e8 28 fe ff ff       	call   f0106b76 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106d4e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106d53:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d58:	e8 19 fe ff ff       	call   f0106b76 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106d5d:	c1 eb 0c             	shr    $0xc,%ebx
f0106d60:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106d63:	89 f2                	mov    %esi,%edx
f0106d65:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106d6a:	e8 07 fe ff ff       	call   f0106b76 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106d6f:	89 da                	mov    %ebx,%edx
f0106d71:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d76:	e8 fb fd ff ff       	call   f0106b76 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106d7b:	89 f2                	mov    %esi,%edx
f0106d7d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106d82:	e8 ef fd ff ff       	call   f0106b76 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106d87:	89 da                	mov    %ebx,%edx
f0106d89:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d8e:	e8 e3 fd ff ff       	call   f0106b76 <lapicw>
		microdelay(200);
	}
}
f0106d93:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106d96:	5b                   	pop    %ebx
f0106d97:	5e                   	pop    %esi
f0106d98:	5d                   	pop    %ebp
f0106d99:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106d9a:	68 67 04 00 00       	push   $0x467
f0106d9f:	68 04 72 10 f0       	push   $0xf0107204
f0106da4:	68 98 00 00 00       	push   $0x98
f0106da9:	68 b4 92 10 f0       	push   $0xf01092b4
f0106dae:	e8 8d 92 ff ff       	call   f0100040 <_panic>

f0106db3 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106db3:	55                   	push   %ebp
f0106db4:	89 e5                	mov    %esp,%ebp
f0106db6:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106db9:	8b 55 08             	mov    0x8(%ebp),%edx
f0106dbc:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106dc2:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106dc7:	e8 aa fd ff ff       	call   f0106b76 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106dcc:	8b 15 04 80 39 f0    	mov    0xf0398004,%edx
f0106dd2:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106dd8:	f6 c4 10             	test   $0x10,%ah
f0106ddb:	75 f5                	jne    f0106dd2 <lapic_ipi+0x1f>
		;
}
f0106ddd:	c9                   	leave  
f0106dde:	c3                   	ret    

f0106ddf <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106ddf:	55                   	push   %ebp
f0106de0:	89 e5                	mov    %esp,%ebp
f0106de2:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106de5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106deb:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106dee:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106df1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106df8:	5d                   	pop    %ebp
f0106df9:	c3                   	ret    

f0106dfa <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106dfa:	55                   	push   %ebp
f0106dfb:	89 e5                	mov    %esp,%ebp
f0106dfd:	56                   	push   %esi
f0106dfe:	53                   	push   %ebx
f0106dff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0106e02:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106e05:	75 12                	jne    f0106e19 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0106e07:	ba 01 00 00 00       	mov    $0x1,%edx
f0106e0c:	89 d0                	mov    %edx,%eax
f0106e0e:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106e11:	85 c0                	test   %eax,%eax
f0106e13:	74 36                	je     f0106e4b <spin_lock+0x51>
		asm volatile ("pause");
f0106e15:	f3 90                	pause  
f0106e17:	eb f3                	jmp    f0106e0c <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f0106e19:	8b 73 08             	mov    0x8(%ebx),%esi
f0106e1c:	e8 69 fd ff ff       	call   f0106b8a <cpunum>
f0106e21:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e24:	05 20 70 35 f0       	add    $0xf0357020,%eax
	if (holding(lk))
f0106e29:	39 c6                	cmp    %eax,%esi
f0106e2b:	75 da                	jne    f0106e07 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106e2d:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106e30:	e8 55 fd ff ff       	call   f0106b8a <cpunum>
f0106e35:	83 ec 0c             	sub    $0xc,%esp
f0106e38:	53                   	push   %ebx
f0106e39:	50                   	push   %eax
f0106e3a:	68 c4 92 10 f0       	push   $0xf01092c4
f0106e3f:	6a 41                	push   $0x41
f0106e41:	68 28 93 10 f0       	push   $0xf0109328
f0106e46:	e8 f5 91 ff ff       	call   f0100040 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106e4b:	e8 3a fd ff ff       	call   f0106b8a <cpunum>
f0106e50:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e53:	05 20 70 35 f0       	add    $0xf0357020,%eax
f0106e58:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0106e5b:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106e5d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106e62:	83 f8 09             	cmp    $0x9,%eax
f0106e65:	7f 16                	jg     f0106e7d <spin_lock+0x83>
f0106e67:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106e6d:	76 0e                	jbe    f0106e7d <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0106e6f:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106e72:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106e76:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106e78:	83 c0 01             	add    $0x1,%eax
f0106e7b:	eb e5                	jmp    f0106e62 <spin_lock+0x68>
	for (; i < 10; i++)
f0106e7d:	83 f8 09             	cmp    $0x9,%eax
f0106e80:	7f 0d                	jg     f0106e8f <spin_lock+0x95>
		pcs[i] = 0;
f0106e82:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106e89:	00 
	for (; i < 10; i++)
f0106e8a:	83 c0 01             	add    $0x1,%eax
f0106e8d:	eb ee                	jmp    f0106e7d <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0106e8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106e92:	5b                   	pop    %ebx
f0106e93:	5e                   	pop    %esi
f0106e94:	5d                   	pop    %ebp
f0106e95:	c3                   	ret    

f0106e96 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106e96:	55                   	push   %ebp
f0106e97:	89 e5                	mov    %esp,%ebp
f0106e99:	57                   	push   %edi
f0106e9a:	56                   	push   %esi
f0106e9b:	53                   	push   %ebx
f0106e9c:	83 ec 4c             	sub    $0x4c,%esp
f0106e9f:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106ea2:	83 3e 00             	cmpl   $0x0,(%esi)
f0106ea5:	75 35                	jne    f0106edc <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106ea7:	83 ec 04             	sub    $0x4,%esp
f0106eaa:	6a 28                	push   $0x28
f0106eac:	8d 46 0c             	lea    0xc(%esi),%eax
f0106eaf:	50                   	push   %eax
f0106eb0:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106eb3:	53                   	push   %ebx
f0106eb4:	e8 18 f7 ff ff       	call   f01065d1 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106eb9:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106ebc:	0f b6 38             	movzbl (%eax),%edi
f0106ebf:	8b 76 04             	mov    0x4(%esi),%esi
f0106ec2:	e8 c3 fc ff ff       	call   f0106b8a <cpunum>
f0106ec7:	57                   	push   %edi
f0106ec8:	56                   	push   %esi
f0106ec9:	50                   	push   %eax
f0106eca:	68 f0 92 10 f0       	push   $0xf01092f0
f0106ecf:	e8 ea cf ff ff       	call   f0103ebe <cprintf>
f0106ed4:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106ed7:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106eda:	eb 4e                	jmp    f0106f2a <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0106edc:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106edf:	e8 a6 fc ff ff       	call   f0106b8a <cpunum>
f0106ee4:	6b c0 74             	imul   $0x74,%eax,%eax
f0106ee7:	05 20 70 35 f0       	add    $0xf0357020,%eax
	if (!holding(lk)) {
f0106eec:	39 c3                	cmp    %eax,%ebx
f0106eee:	75 b7                	jne    f0106ea7 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0106ef0:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106ef7:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106efe:	b8 00 00 00 00       	mov    $0x0,%eax
f0106f03:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106f09:	5b                   	pop    %ebx
f0106f0a:	5e                   	pop    %esi
f0106f0b:	5f                   	pop    %edi
f0106f0c:	5d                   	pop    %ebp
f0106f0d:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106f0e:	83 ec 08             	sub    $0x8,%esp
f0106f11:	ff 36                	pushl  (%esi)
f0106f13:	68 4f 93 10 f0       	push   $0xf010934f
f0106f18:	e8 a1 cf ff ff       	call   f0103ebe <cprintf>
f0106f1d:	83 c4 10             	add    $0x10,%esp
f0106f20:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106f23:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106f26:	39 c3                	cmp    %eax,%ebx
f0106f28:	74 40                	je     f0106f6a <spin_unlock+0xd4>
f0106f2a:	89 de                	mov    %ebx,%esi
f0106f2c:	8b 03                	mov    (%ebx),%eax
f0106f2e:	85 c0                	test   %eax,%eax
f0106f30:	74 38                	je     f0106f6a <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106f32:	83 ec 08             	sub    $0x8,%esp
f0106f35:	57                   	push   %edi
f0106f36:	50                   	push   %eax
f0106f37:	e8 2e ea ff ff       	call   f010596a <debuginfo_eip>
f0106f3c:	83 c4 10             	add    $0x10,%esp
f0106f3f:	85 c0                	test   %eax,%eax
f0106f41:	78 cb                	js     f0106f0e <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0106f43:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106f45:	83 ec 04             	sub    $0x4,%esp
f0106f48:	89 c2                	mov    %eax,%edx
f0106f4a:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106f4d:	52                   	push   %edx
f0106f4e:	ff 75 b0             	pushl  -0x50(%ebp)
f0106f51:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106f54:	ff 75 ac             	pushl  -0x54(%ebp)
f0106f57:	ff 75 a8             	pushl  -0x58(%ebp)
f0106f5a:	50                   	push   %eax
f0106f5b:	68 38 93 10 f0       	push   $0xf0109338
f0106f60:	e8 59 cf ff ff       	call   f0103ebe <cprintf>
f0106f65:	83 c4 20             	add    $0x20,%esp
f0106f68:	eb b6                	jmp    f0106f20 <spin_unlock+0x8a>
		panic("spin_unlock");
f0106f6a:	83 ec 04             	sub    $0x4,%esp
f0106f6d:	68 57 93 10 f0       	push   $0xf0109357
f0106f72:	6a 67                	push   $0x67
f0106f74:	68 28 93 10 f0       	push   $0xf0109328
f0106f79:	e8 c2 90 ff ff       	call   f0100040 <_panic>
f0106f7e:	66 90                	xchg   %ax,%ax

f0106f80 <__udivdi3>:
f0106f80:	55                   	push   %ebp
f0106f81:	57                   	push   %edi
f0106f82:	56                   	push   %esi
f0106f83:	53                   	push   %ebx
f0106f84:	83 ec 1c             	sub    $0x1c,%esp
f0106f87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0106f8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0106f8f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106f93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0106f97:	85 d2                	test   %edx,%edx
f0106f99:	75 4d                	jne    f0106fe8 <__udivdi3+0x68>
f0106f9b:	39 f3                	cmp    %esi,%ebx
f0106f9d:	76 19                	jbe    f0106fb8 <__udivdi3+0x38>
f0106f9f:	31 ff                	xor    %edi,%edi
f0106fa1:	89 e8                	mov    %ebp,%eax
f0106fa3:	89 f2                	mov    %esi,%edx
f0106fa5:	f7 f3                	div    %ebx
f0106fa7:	89 fa                	mov    %edi,%edx
f0106fa9:	83 c4 1c             	add    $0x1c,%esp
f0106fac:	5b                   	pop    %ebx
f0106fad:	5e                   	pop    %esi
f0106fae:	5f                   	pop    %edi
f0106faf:	5d                   	pop    %ebp
f0106fb0:	c3                   	ret    
f0106fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106fb8:	89 d9                	mov    %ebx,%ecx
f0106fba:	85 db                	test   %ebx,%ebx
f0106fbc:	75 0b                	jne    f0106fc9 <__udivdi3+0x49>
f0106fbe:	b8 01 00 00 00       	mov    $0x1,%eax
f0106fc3:	31 d2                	xor    %edx,%edx
f0106fc5:	f7 f3                	div    %ebx
f0106fc7:	89 c1                	mov    %eax,%ecx
f0106fc9:	31 d2                	xor    %edx,%edx
f0106fcb:	89 f0                	mov    %esi,%eax
f0106fcd:	f7 f1                	div    %ecx
f0106fcf:	89 c6                	mov    %eax,%esi
f0106fd1:	89 e8                	mov    %ebp,%eax
f0106fd3:	89 f7                	mov    %esi,%edi
f0106fd5:	f7 f1                	div    %ecx
f0106fd7:	89 fa                	mov    %edi,%edx
f0106fd9:	83 c4 1c             	add    $0x1c,%esp
f0106fdc:	5b                   	pop    %ebx
f0106fdd:	5e                   	pop    %esi
f0106fde:	5f                   	pop    %edi
f0106fdf:	5d                   	pop    %ebp
f0106fe0:	c3                   	ret    
f0106fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106fe8:	39 f2                	cmp    %esi,%edx
f0106fea:	77 1c                	ja     f0107008 <__udivdi3+0x88>
f0106fec:	0f bd fa             	bsr    %edx,%edi
f0106fef:	83 f7 1f             	xor    $0x1f,%edi
f0106ff2:	75 2c                	jne    f0107020 <__udivdi3+0xa0>
f0106ff4:	39 f2                	cmp    %esi,%edx
f0106ff6:	72 06                	jb     f0106ffe <__udivdi3+0x7e>
f0106ff8:	31 c0                	xor    %eax,%eax
f0106ffa:	39 eb                	cmp    %ebp,%ebx
f0106ffc:	77 a9                	ja     f0106fa7 <__udivdi3+0x27>
f0106ffe:	b8 01 00 00 00       	mov    $0x1,%eax
f0107003:	eb a2                	jmp    f0106fa7 <__udivdi3+0x27>
f0107005:	8d 76 00             	lea    0x0(%esi),%esi
f0107008:	31 ff                	xor    %edi,%edi
f010700a:	31 c0                	xor    %eax,%eax
f010700c:	89 fa                	mov    %edi,%edx
f010700e:	83 c4 1c             	add    $0x1c,%esp
f0107011:	5b                   	pop    %ebx
f0107012:	5e                   	pop    %esi
f0107013:	5f                   	pop    %edi
f0107014:	5d                   	pop    %ebp
f0107015:	c3                   	ret    
f0107016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010701d:	8d 76 00             	lea    0x0(%esi),%esi
f0107020:	89 f9                	mov    %edi,%ecx
f0107022:	b8 20 00 00 00       	mov    $0x20,%eax
f0107027:	29 f8                	sub    %edi,%eax
f0107029:	d3 e2                	shl    %cl,%edx
f010702b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010702f:	89 c1                	mov    %eax,%ecx
f0107031:	89 da                	mov    %ebx,%edx
f0107033:	d3 ea                	shr    %cl,%edx
f0107035:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107039:	09 d1                	or     %edx,%ecx
f010703b:	89 f2                	mov    %esi,%edx
f010703d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107041:	89 f9                	mov    %edi,%ecx
f0107043:	d3 e3                	shl    %cl,%ebx
f0107045:	89 c1                	mov    %eax,%ecx
f0107047:	d3 ea                	shr    %cl,%edx
f0107049:	89 f9                	mov    %edi,%ecx
f010704b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010704f:	89 eb                	mov    %ebp,%ebx
f0107051:	d3 e6                	shl    %cl,%esi
f0107053:	89 c1                	mov    %eax,%ecx
f0107055:	d3 eb                	shr    %cl,%ebx
f0107057:	09 de                	or     %ebx,%esi
f0107059:	89 f0                	mov    %esi,%eax
f010705b:	f7 74 24 08          	divl   0x8(%esp)
f010705f:	89 d6                	mov    %edx,%esi
f0107061:	89 c3                	mov    %eax,%ebx
f0107063:	f7 64 24 0c          	mull   0xc(%esp)
f0107067:	39 d6                	cmp    %edx,%esi
f0107069:	72 15                	jb     f0107080 <__udivdi3+0x100>
f010706b:	89 f9                	mov    %edi,%ecx
f010706d:	d3 e5                	shl    %cl,%ebp
f010706f:	39 c5                	cmp    %eax,%ebp
f0107071:	73 04                	jae    f0107077 <__udivdi3+0xf7>
f0107073:	39 d6                	cmp    %edx,%esi
f0107075:	74 09                	je     f0107080 <__udivdi3+0x100>
f0107077:	89 d8                	mov    %ebx,%eax
f0107079:	31 ff                	xor    %edi,%edi
f010707b:	e9 27 ff ff ff       	jmp    f0106fa7 <__udivdi3+0x27>
f0107080:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107083:	31 ff                	xor    %edi,%edi
f0107085:	e9 1d ff ff ff       	jmp    f0106fa7 <__udivdi3+0x27>
f010708a:	66 90                	xchg   %ax,%ax
f010708c:	66 90                	xchg   %ax,%ax
f010708e:	66 90                	xchg   %ax,%ax

f0107090 <__umoddi3>:
f0107090:	55                   	push   %ebp
f0107091:	57                   	push   %edi
f0107092:	56                   	push   %esi
f0107093:	53                   	push   %ebx
f0107094:	83 ec 1c             	sub    $0x1c,%esp
f0107097:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f010709b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f010709f:	8b 74 24 30          	mov    0x30(%esp),%esi
f01070a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01070a7:	89 da                	mov    %ebx,%edx
f01070a9:	85 c0                	test   %eax,%eax
f01070ab:	75 43                	jne    f01070f0 <__umoddi3+0x60>
f01070ad:	39 df                	cmp    %ebx,%edi
f01070af:	76 17                	jbe    f01070c8 <__umoddi3+0x38>
f01070b1:	89 f0                	mov    %esi,%eax
f01070b3:	f7 f7                	div    %edi
f01070b5:	89 d0                	mov    %edx,%eax
f01070b7:	31 d2                	xor    %edx,%edx
f01070b9:	83 c4 1c             	add    $0x1c,%esp
f01070bc:	5b                   	pop    %ebx
f01070bd:	5e                   	pop    %esi
f01070be:	5f                   	pop    %edi
f01070bf:	5d                   	pop    %ebp
f01070c0:	c3                   	ret    
f01070c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01070c8:	89 fd                	mov    %edi,%ebp
f01070ca:	85 ff                	test   %edi,%edi
f01070cc:	75 0b                	jne    f01070d9 <__umoddi3+0x49>
f01070ce:	b8 01 00 00 00       	mov    $0x1,%eax
f01070d3:	31 d2                	xor    %edx,%edx
f01070d5:	f7 f7                	div    %edi
f01070d7:	89 c5                	mov    %eax,%ebp
f01070d9:	89 d8                	mov    %ebx,%eax
f01070db:	31 d2                	xor    %edx,%edx
f01070dd:	f7 f5                	div    %ebp
f01070df:	89 f0                	mov    %esi,%eax
f01070e1:	f7 f5                	div    %ebp
f01070e3:	89 d0                	mov    %edx,%eax
f01070e5:	eb d0                	jmp    f01070b7 <__umoddi3+0x27>
f01070e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01070ee:	66 90                	xchg   %ax,%ax
f01070f0:	89 f1                	mov    %esi,%ecx
f01070f2:	39 d8                	cmp    %ebx,%eax
f01070f4:	76 0a                	jbe    f0107100 <__umoddi3+0x70>
f01070f6:	89 f0                	mov    %esi,%eax
f01070f8:	83 c4 1c             	add    $0x1c,%esp
f01070fb:	5b                   	pop    %ebx
f01070fc:	5e                   	pop    %esi
f01070fd:	5f                   	pop    %edi
f01070fe:	5d                   	pop    %ebp
f01070ff:	c3                   	ret    
f0107100:	0f bd e8             	bsr    %eax,%ebp
f0107103:	83 f5 1f             	xor    $0x1f,%ebp
f0107106:	75 20                	jne    f0107128 <__umoddi3+0x98>
f0107108:	39 d8                	cmp    %ebx,%eax
f010710a:	0f 82 b0 00 00 00    	jb     f01071c0 <__umoddi3+0x130>
f0107110:	39 f7                	cmp    %esi,%edi
f0107112:	0f 86 a8 00 00 00    	jbe    f01071c0 <__umoddi3+0x130>
f0107118:	89 c8                	mov    %ecx,%eax
f010711a:	83 c4 1c             	add    $0x1c,%esp
f010711d:	5b                   	pop    %ebx
f010711e:	5e                   	pop    %esi
f010711f:	5f                   	pop    %edi
f0107120:	5d                   	pop    %ebp
f0107121:	c3                   	ret    
f0107122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107128:	89 e9                	mov    %ebp,%ecx
f010712a:	ba 20 00 00 00       	mov    $0x20,%edx
f010712f:	29 ea                	sub    %ebp,%edx
f0107131:	d3 e0                	shl    %cl,%eax
f0107133:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107137:	89 d1                	mov    %edx,%ecx
f0107139:	89 f8                	mov    %edi,%eax
f010713b:	d3 e8                	shr    %cl,%eax
f010713d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107141:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107145:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107149:	09 c1                	or     %eax,%ecx
f010714b:	89 d8                	mov    %ebx,%eax
f010714d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107151:	89 e9                	mov    %ebp,%ecx
f0107153:	d3 e7                	shl    %cl,%edi
f0107155:	89 d1                	mov    %edx,%ecx
f0107157:	d3 e8                	shr    %cl,%eax
f0107159:	89 e9                	mov    %ebp,%ecx
f010715b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010715f:	d3 e3                	shl    %cl,%ebx
f0107161:	89 c7                	mov    %eax,%edi
f0107163:	89 d1                	mov    %edx,%ecx
f0107165:	89 f0                	mov    %esi,%eax
f0107167:	d3 e8                	shr    %cl,%eax
f0107169:	89 e9                	mov    %ebp,%ecx
f010716b:	89 fa                	mov    %edi,%edx
f010716d:	d3 e6                	shl    %cl,%esi
f010716f:	09 d8                	or     %ebx,%eax
f0107171:	f7 74 24 08          	divl   0x8(%esp)
f0107175:	89 d1                	mov    %edx,%ecx
f0107177:	89 f3                	mov    %esi,%ebx
f0107179:	f7 64 24 0c          	mull   0xc(%esp)
f010717d:	89 c6                	mov    %eax,%esi
f010717f:	89 d7                	mov    %edx,%edi
f0107181:	39 d1                	cmp    %edx,%ecx
f0107183:	72 06                	jb     f010718b <__umoddi3+0xfb>
f0107185:	75 10                	jne    f0107197 <__umoddi3+0x107>
f0107187:	39 c3                	cmp    %eax,%ebx
f0107189:	73 0c                	jae    f0107197 <__umoddi3+0x107>
f010718b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f010718f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0107193:	89 d7                	mov    %edx,%edi
f0107195:	89 c6                	mov    %eax,%esi
f0107197:	89 ca                	mov    %ecx,%edx
f0107199:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010719e:	29 f3                	sub    %esi,%ebx
f01071a0:	19 fa                	sbb    %edi,%edx
f01071a2:	89 d0                	mov    %edx,%eax
f01071a4:	d3 e0                	shl    %cl,%eax
f01071a6:	89 e9                	mov    %ebp,%ecx
f01071a8:	d3 eb                	shr    %cl,%ebx
f01071aa:	d3 ea                	shr    %cl,%edx
f01071ac:	09 d8                	or     %ebx,%eax
f01071ae:	83 c4 1c             	add    $0x1c,%esp
f01071b1:	5b                   	pop    %ebx
f01071b2:	5e                   	pop    %esi
f01071b3:	5f                   	pop    %edi
f01071b4:	5d                   	pop    %ebp
f01071b5:	c3                   	ret    
f01071b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01071bd:	8d 76 00             	lea    0x0(%esi),%esi
f01071c0:	89 da                	mov    %ebx,%edx
f01071c2:	29 fe                	sub    %edi,%esi
f01071c4:	19 c2                	sbb    %eax,%edx
f01071c6:	89 f1                	mov    %esi,%ecx
f01071c8:	89 c8                	mov    %ecx,%eax
f01071ca:	e9 4b ff ff ff       	jmp    f010711a <__umoddi3+0x8a>
