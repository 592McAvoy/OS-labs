
obj/user/evilhello2.debug:     file format elf32-i386


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
  80002c:	e8 1c 01 00 00       	call   80014d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <evil>:
struct Segdesc *gdt;
struct Segdesc *entry;

// Call this function with ring0 privilege
void evil()
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
	// Kernel memory access
	*(char*)0xf010000a = 0;
  800037:	c6 05 0a 00 10 f0 00 	movb   $0x0,0xf010000a
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80003e:	bb 49 00 00 00       	mov    $0x49,%ebx
  800043:	ba f8 03 00 00       	mov    $0x3f8,%edx
  800048:	89 d8                	mov    %ebx,%eax
  80004a:	ee                   	out    %al,(%dx)
  80004b:	b9 4e 00 00 00       	mov    $0x4e,%ecx
  800050:	89 c8                	mov    %ecx,%eax
  800052:	ee                   	out    %al,(%dx)
  800053:	b8 20 00 00 00       	mov    $0x20,%eax
  800058:	ee                   	out    %al,(%dx)
  800059:	b8 52 00 00 00       	mov    $0x52,%eax
  80005e:	ee                   	out    %al,(%dx)
  80005f:	89 d8                	mov    %ebx,%eax
  800061:	ee                   	out    %al,(%dx)
  800062:	89 c8                	mov    %ecx,%eax
  800064:	ee                   	out    %al,(%dx)
  800065:	b8 47 00 00 00       	mov    $0x47,%eax
  80006a:	ee                   	out    %al,(%dx)
  80006b:	b8 30 00 00 00       	mov    $0x30,%eax
  800070:	ee                   	out    %al,(%dx)
  800071:	b8 21 00 00 00       	mov    $0x21,%eax
  800076:	ee                   	out    %al,(%dx)
  800077:	ee                   	out    %al,(%dx)
  800078:	ee                   	out    %al,(%dx)
  800079:	b8 0a 00 00 00       	mov    $0xa,%eax
  80007e:	ee                   	out    %al,(%dx)
	outb(0x3f8, '0');
	outb(0x3f8, '!');
	outb(0x3f8, '!');
	outb(0x3f8, '!');
	outb(0x3f8, '\n');
}
  80007f:	5b                   	pop    %ebx
  800080:	5d                   	pop    %ebp
  800081:	c3                   	ret    

00800082 <call_fun_ptr>:

void call_fun_ptr()
{
  800082:	55                   	push   %ebp
  800083:	89 e5                	mov    %esp,%ebp
  800085:	83 ec 08             	sub    $0x8,%esp
    evil();  
  800088:	e8 a6 ff ff ff       	call   800033 <evil>
    //6.
    *entry = old;  
  80008d:	8b 0d 20 20 80 00    	mov    0x802020,%ecx
  800093:	a1 44 30 80 00       	mov    0x803044,%eax
  800098:	8b 15 48 30 80 00    	mov    0x803048,%edx
  80009e:	89 01                	mov    %eax,(%ecx)
  8000a0:	89 51 04             	mov    %edx,0x4(%ecx)
    //7.
    asm volatile("leave");
  8000a3:	c9                   	leave  
    asm volatile("lret");   
  8000a4:	cb                   	lret   
}
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    

008000a7 <ring0_call>:
{
	__asm __volatile("sgdt %0" :  "=m" (*gdtd));
}

// Invoke a given function pointer with ring0 privilege, then return to ring3
void ring0_call(void (*fun_ptr)(void)) {
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	83 ec 20             	sub    $0x20,%esp
	__asm __volatile("sgdt %0" :  "=m" (*gdtd));
  8000ad:	0f 01 45 f2          	sgdtl  -0xe(%ebp)

    //1.
    struct Pseudodesc r_gdt; 
    sgdt(&r_gdt);
    //2.
    int t = sys_map_kernel_page((void* )r_gdt.pd_base, (void* )vaddr);
  8000b1:	68 40 20 80 00       	push   $0x802040
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	e8 b1 0e 00 00       	call   800f6f <sys_map_kernel_page>
    if (t < 0) {
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 5b                	js     800120 <ring0_call+0x79>
        return;
    }
    
    uint32_t base = (uint32_t)(PGNUM(vaddr) << PTXSHIFT);
    uint32_t index = GD_UD >> 3;
    uint32_t offset = PGOFF(r_gdt.pd_base);
  8000c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8000c8:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    uint32_t base = (uint32_t)(PGNUM(vaddr) << PTXSHIFT);
  8000ce:	b8 40 20 80 00       	mov    $0x802040,%eax
  8000d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    //3.
    gdt = (struct Segdesc*)(base+offset); 
  8000d8:	09 c1                	or     %eax,%ecx
  8000da:	89 0d 40 30 80 00    	mov    %ecx,0x803040
    entry = gdt + index; 
  8000e0:	8d 41 20             	lea    0x20(%ecx),%eax
  8000e3:	a3 20 20 80 00       	mov    %eax,0x802020
    old= *entry; 
  8000e8:	8b 41 20             	mov    0x20(%ecx),%eax
  8000eb:	8b 51 24             	mov    0x24(%ecx),%edx
  8000ee:	a3 44 30 80 00       	mov    %eax,0x803044
  8000f3:	89 15 48 30 80 00    	mov    %edx,0x803048

    SETCALLGATE(*((struct Gatedesc*)entry), GD_KT, call_fun_ptr, 3);
  8000f9:	b8 82 00 80 00       	mov    $0x800082,%eax
  8000fe:	66 89 41 20          	mov    %ax,0x20(%ecx)
  800102:	66 c7 41 22 08 00    	movw   $0x8,0x22(%ecx)
  800108:	c6 41 24 00          	movb   $0x0,0x24(%ecx)
  80010c:	c6 41 25 ec          	movb   $0xec,0x25(%ecx)
  800110:	c1 e8 10             	shr    $0x10,%eax
  800113:	66 89 41 26          	mov    %ax,0x26(%ecx)
    //4./5.
    asm volatile(
  800117:	9a 00 00 00 00 20 00 	lcall  $0x20,$0x0
        "lcall %0, $0"
        :
        :"i"(GD_UD)
        );
}
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    
        cprintf("ring0_call: sys_map_kernel_page failed, %e\n", t);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	50                   	push   %eax
  800124:	68 60 12 80 00       	push   $0x801260
  800129:	e8 0f 01 00 00       	call   80023d <cprintf>
        return;
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	eb eb                	jmp    80011e <ring0_call+0x77>

00800133 <umain>:

void
umain(int argc, char **argv)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	83 ec 14             	sub    $0x14,%esp
        // call the evil function in ring0
	ring0_call(&evil);
  800139:	68 33 00 80 00       	push   $0x800033
  80013e:	e8 64 ff ff ff       	call   8000a7 <ring0_call>

	// call the evil function in ring3
	evil();
  800143:	e8 eb fe ff ff       	call   800033 <evil>
}
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
  800152:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800155:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800158:	e8 a2 0b 00 00       	call   800cff <sys_getenvid>
  80015d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800162:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  800165:	c1 e0 04             	shl    $0x4,%eax
  800168:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80016d:	a3 4c 30 80 00       	mov    %eax,0x80304c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800172:	85 db                	test   %ebx,%ebx
  800174:	7e 07                	jle    80017d <libmain+0x30>
		binaryname = argv[0];
  800176:	8b 06                	mov    (%esi),%eax
  800178:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80017d:	83 ec 08             	sub    $0x8,%esp
  800180:	56                   	push   %esi
  800181:	53                   	push   %ebx
  800182:	e8 ac ff ff ff       	call   800133 <umain>

	// exit gracefully
	exit();
  800187:	e8 0a 00 00 00       	call   800196 <exit>
}
  80018c:	83 c4 10             	add    $0x10,%esp
  80018f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800192:	5b                   	pop    %ebx
  800193:	5e                   	pop    %esi
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    

00800196 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  80019c:	6a 00                	push   $0x0
  80019e:	e8 1b 0b 00 00       	call   800cbe <sys_env_destroy>
}
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b2:	8b 13                	mov    (%ebx),%edx
  8001b4:	8d 42 01             	lea    0x1(%edx),%eax
  8001b7:	89 03                	mov    %eax,(%ebx)
  8001b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c5:	74 09                	je     8001d0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 ff 00 00 00       	push   $0xff
  8001d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001db:	50                   	push   %eax
  8001dc:	e8 a0 0a 00 00       	call   800c81 <sys_cputs>
		b->idx = 0;
  8001e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	eb db                	jmp    8001c7 <putch+0x1f>

008001ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fc:	00 00 00 
	b.cnt = 0;
  8001ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800206:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800209:	ff 75 0c             	pushl  0xc(%ebp)
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	68 a8 01 80 00       	push   $0x8001a8
  80021b:	e8 4a 01 00 00       	call   80036a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800220:	83 c4 08             	add    $0x8,%esp
  800223:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800229:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022f:	50                   	push   %eax
  800230:	e8 4c 0a 00 00       	call   800c81 <sys_cputs>

	return b.cnt;
}
  800235:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

0080023d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800243:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800246:	50                   	push   %eax
  800247:	ff 75 08             	pushl  0x8(%ebp)
  80024a:	e8 9d ff ff ff       	call   8001ec <vcprintf>
	va_end(ap);

	return cnt;
}
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	57                   	push   %edi
  800255:	56                   	push   %esi
  800256:	53                   	push   %ebx
  800257:	83 ec 1c             	sub    $0x1c,%esp
  80025a:	89 c6                	mov    %eax,%esi
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	8b 55 0c             	mov    0xc(%ebp),%edx
  800264:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800267:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80026a:	8b 45 10             	mov    0x10(%ebp),%eax
  80026d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800270:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800274:	74 2c                	je     8002a2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800276:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800279:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800280:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800283:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800286:	39 c2                	cmp    %eax,%edx
  800288:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80028b:	73 43                	jae    8002d0 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80028d:	83 eb 01             	sub    $0x1,%ebx
  800290:	85 db                	test   %ebx,%ebx
  800292:	7e 6c                	jle    800300 <printnum+0xaf>
			putch(padc, putdat);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	57                   	push   %edi
  800298:	ff 75 18             	pushl  0x18(%ebp)
  80029b:	ff d6                	call   *%esi
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	eb eb                	jmp    80028d <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	6a 20                	push   $0x20
  8002a7:	6a 00                	push   $0x0
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b0:	89 fa                	mov    %edi,%edx
  8002b2:	89 f0                	mov    %esi,%eax
  8002b4:	e8 98 ff ff ff       	call   800251 <printnum>
		while (--width > 0)
  8002b9:	83 c4 20             	add    $0x20,%esp
  8002bc:	83 eb 01             	sub    $0x1,%ebx
  8002bf:	85 db                	test   %ebx,%ebx
  8002c1:	7e 65                	jle    800328 <printnum+0xd7>
			putch(padc, putdat);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	57                   	push   %edi
  8002c7:	6a 20                	push   $0x20
  8002c9:	ff d6                	call   *%esi
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	eb ec                	jmp    8002bc <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 75 18             	pushl  0x18(%ebp)
  8002d6:	83 eb 01             	sub    $0x1,%ebx
  8002d9:	53                   	push   %ebx
  8002da:	50                   	push   %eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ea:	e8 11 0d 00 00       	call   801000 <__udivdi3>
  8002ef:	83 c4 18             	add    $0x18,%esp
  8002f2:	52                   	push   %edx
  8002f3:	50                   	push   %eax
  8002f4:	89 fa                	mov    %edi,%edx
  8002f6:	89 f0                	mov    %esi,%eax
  8002f8:	e8 54 ff ff ff       	call   800251 <printnum>
  8002fd:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	57                   	push   %edi
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 dc             	pushl  -0x24(%ebp)
  80030a:	ff 75 d8             	pushl  -0x28(%ebp)
  80030d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800310:	ff 75 e0             	pushl  -0x20(%ebp)
  800313:	e8 f8 0d 00 00       	call   801110 <__umoddi3>
  800318:	83 c4 14             	add    $0x14,%esp
  80031b:	0f be 80 96 12 80 00 	movsbl 0x801296(%eax),%eax
  800322:	50                   	push   %eax
  800323:	ff d6                	call   *%esi
  800325:	83 c4 10             	add    $0x10,%esp
}
  800328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    

00800330 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800336:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033a:	8b 10                	mov    (%eax),%edx
  80033c:	3b 50 04             	cmp    0x4(%eax),%edx
  80033f:	73 0a                	jae    80034b <sprintputch+0x1b>
		*b->buf++ = ch;
  800341:	8d 4a 01             	lea    0x1(%edx),%ecx
  800344:	89 08                	mov    %ecx,(%eax)
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	88 02                	mov    %al,(%edx)
}
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <printfmt>:
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800353:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800356:	50                   	push   %eax
  800357:	ff 75 10             	pushl  0x10(%ebp)
  80035a:	ff 75 0c             	pushl  0xc(%ebp)
  80035d:	ff 75 08             	pushl  0x8(%ebp)
  800360:	e8 05 00 00 00       	call   80036a <vprintfmt>
}
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <vprintfmt>:
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	57                   	push   %edi
  80036e:	56                   	push   %esi
  80036f:	53                   	push   %ebx
  800370:	83 ec 3c             	sub    $0x3c,%esp
  800373:	8b 75 08             	mov    0x8(%ebp),%esi
  800376:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800379:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037c:	e9 b4 03 00 00       	jmp    800735 <vprintfmt+0x3cb>
		padc = ' ';
  800381:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  800385:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  80038c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800393:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80039a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	8d 47 01             	lea    0x1(%edi),%eax
  8003a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ac:	0f b6 17             	movzbl (%edi),%edx
  8003af:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b2:	3c 55                	cmp    $0x55,%al
  8003b4:	0f 87 c8 04 00 00    	ja     800882 <vprintfmt+0x518>
  8003ba:	0f b6 c0             	movzbl %al,%eax
  8003bd:	ff 24 85 80 14 80 00 	jmp    *0x801480(,%eax,4)
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8003c7:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8003ce:	eb d6                	jmp    8003a6 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003d3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003d7:	eb cd                	jmp    8003a6 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	0f b6 d2             	movzbl %dl,%edx
  8003dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003df:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8003e7:	eb 0c                	jmp    8003f5 <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003ec:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003f0:	eb b4                	jmp    8003a6 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8003f2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003fc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ff:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800402:	83 f9 09             	cmp    $0x9,%ecx
  800405:	76 eb                	jbe    8003f2 <vprintfmt+0x88>
  800407:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80040a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040d:	eb 14                	jmp    800423 <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  80040f:	8b 45 14             	mov    0x14(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	8d 40 04             	lea    0x4(%eax),%eax
  80041d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800423:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800427:	0f 89 79 ff ff ff    	jns    8003a6 <vprintfmt+0x3c>
				width = precision, precision = -1;
  80042d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800433:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80043a:	e9 67 ff ff ff       	jmp    8003a6 <vprintfmt+0x3c>
  80043f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800442:	85 c0                	test   %eax,%eax
  800444:	ba 00 00 00 00       	mov    $0x0,%edx
  800449:	0f 49 d0             	cmovns %eax,%edx
  80044c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800452:	e9 4f ff ff ff       	jmp    8003a6 <vprintfmt+0x3c>
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800461:	e9 40 ff ff ff       	jmp    8003a6 <vprintfmt+0x3c>
			lflag++;
  800466:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80046c:	e9 35 ff ff ff       	jmp    8003a6 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  800471:	8b 45 14             	mov    0x14(%ebp),%eax
  800474:	8d 78 04             	lea    0x4(%eax),%edi
  800477:	83 ec 08             	sub    $0x8,%esp
  80047a:	53                   	push   %ebx
  80047b:	ff 30                	pushl  (%eax)
  80047d:	ff d6                	call   *%esi
			break;
  80047f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800482:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800485:	e9 a8 02 00 00       	jmp    800732 <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  80048a:	8b 45 14             	mov    0x14(%ebp),%eax
  80048d:	8d 78 04             	lea    0x4(%eax),%edi
  800490:	8b 00                	mov    (%eax),%eax
  800492:	99                   	cltd   
  800493:	31 d0                	xor    %edx,%eax
  800495:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800497:	83 f8 0f             	cmp    $0xf,%eax
  80049a:	7f 23                	jg     8004bf <vprintfmt+0x155>
  80049c:	8b 14 85 e0 15 80 00 	mov    0x8015e0(,%eax,4),%edx
  8004a3:	85 d2                	test   %edx,%edx
  8004a5:	74 18                	je     8004bf <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8004a7:	52                   	push   %edx
  8004a8:	68 b7 12 80 00       	push   $0x8012b7
  8004ad:	53                   	push   %ebx
  8004ae:	56                   	push   %esi
  8004af:	e8 99 fe ff ff       	call   80034d <printfmt>
  8004b4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ba:	e9 73 02 00 00       	jmp    800732 <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8004bf:	50                   	push   %eax
  8004c0:	68 ae 12 80 00       	push   $0x8012ae
  8004c5:	53                   	push   %ebx
  8004c6:	56                   	push   %esi
  8004c7:	e8 81 fe ff ff       	call   80034d <printfmt>
  8004cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004cf:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004d2:	e9 5b 02 00 00       	jmp    800732 <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	83 c0 04             	add    $0x4,%eax
  8004dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004e5:	85 d2                	test   %edx,%edx
  8004e7:	b8 a7 12 80 00       	mov    $0x8012a7,%eax
  8004ec:	0f 45 c2             	cmovne %edx,%eax
  8004ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f6:	7e 06                	jle    8004fe <vprintfmt+0x194>
  8004f8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004fc:	75 0d                	jne    80050b <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800501:	89 c7                	mov    %eax,%edi
  800503:	03 45 e0             	add    -0x20(%ebp),%eax
  800506:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800509:	eb 53                	jmp    80055e <vprintfmt+0x1f4>
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	ff 75 d8             	pushl  -0x28(%ebp)
  800511:	50                   	push   %eax
  800512:	e8 13 04 00 00       	call   80092a <strnlen>
  800517:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051a:	29 c1                	sub    %eax,%ecx
  80051c:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800524:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800528:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80052b:	eb 0f                	jmp    80053c <vprintfmt+0x1d2>
					putch(padc, putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	ff 75 e0             	pushl  -0x20(%ebp)
  800534:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800536:	83 ef 01             	sub    $0x1,%edi
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	85 ff                	test   %edi,%edi
  80053e:	7f ed                	jg     80052d <vprintfmt+0x1c3>
  800540:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800543:	85 d2                	test   %edx,%edx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	0f 49 c2             	cmovns %edx,%eax
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800552:	eb aa                	jmp    8004fe <vprintfmt+0x194>
					putch(ch, putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	52                   	push   %edx
  800559:	ff d6                	call   *%esi
  80055b:	83 c4 10             	add    $0x10,%esp
  80055e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800561:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800563:	83 c7 01             	add    $0x1,%edi
  800566:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80056a:	0f be d0             	movsbl %al,%edx
  80056d:	85 d2                	test   %edx,%edx
  80056f:	74 4b                	je     8005bc <vprintfmt+0x252>
  800571:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800575:	78 06                	js     80057d <vprintfmt+0x213>
  800577:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80057b:	78 1e                	js     80059b <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  80057d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800581:	74 d1                	je     800554 <vprintfmt+0x1ea>
  800583:	0f be c0             	movsbl %al,%eax
  800586:	83 e8 20             	sub    $0x20,%eax
  800589:	83 f8 5e             	cmp    $0x5e,%eax
  80058c:	76 c6                	jbe    800554 <vprintfmt+0x1ea>
					putch('?', putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	53                   	push   %ebx
  800592:	6a 3f                	push   $0x3f
  800594:	ff d6                	call   *%esi
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	eb c3                	jmp    80055e <vprintfmt+0x1f4>
  80059b:	89 cf                	mov    %ecx,%edi
  80059d:	eb 0e                	jmp    8005ad <vprintfmt+0x243>
				putch(' ', putdat);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	53                   	push   %ebx
  8005a3:	6a 20                	push   $0x20
  8005a5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005a7:	83 ef 01             	sub    $0x1,%edi
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	85 ff                	test   %edi,%edi
  8005af:	7f ee                	jg     80059f <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b7:	e9 76 01 00 00       	jmp    800732 <vprintfmt+0x3c8>
  8005bc:	89 cf                	mov    %ecx,%edi
  8005be:	eb ed                	jmp    8005ad <vprintfmt+0x243>
	if (lflag >= 2)
  8005c0:	83 f9 01             	cmp    $0x1,%ecx
  8005c3:	7f 1f                	jg     8005e4 <vprintfmt+0x27a>
	else if (lflag)
  8005c5:	85 c9                	test   %ecx,%ecx
  8005c7:	74 6a                	je     800633 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	89 c1                	mov    %eax,%ecx
  8005d3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 40 04             	lea    0x4(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e2:	eb 17                	jmp    8005fb <vprintfmt+0x291>
		return va_arg(*ap, long long);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 50 04             	mov    0x4(%eax),%edx
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 40 08             	lea    0x8(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005fe:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800603:	85 d2                	test   %edx,%edx
  800605:	0f 89 f8 00 00 00    	jns    800703 <vprintfmt+0x399>
				putch('-', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	6a 2d                	push   $0x2d
  800611:	ff d6                	call   *%esi
				num = -(long long) num;
  800613:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800616:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800619:	f7 d8                	neg    %eax
  80061b:	83 d2 00             	adc    $0x0,%edx
  80061e:	f7 da                	neg    %edx
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800626:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800629:	bf 0a 00 00 00       	mov    $0xa,%edi
  80062e:	e9 e1 00 00 00       	jmp    800714 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063b:	99                   	cltd   
  80063c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
  800648:	eb b1                	jmp    8005fb <vprintfmt+0x291>
	if (lflag >= 2)
  80064a:	83 f9 01             	cmp    $0x1,%ecx
  80064d:	7f 27                	jg     800676 <vprintfmt+0x30c>
	else if (lflag)
  80064f:	85 c9                	test   %ecx,%ecx
  800651:	74 41                	je     800694 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	ba 00 00 00 00       	mov    $0x0,%edx
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800671:	e9 8d 00 00 00       	jmp    800703 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 50 04             	mov    0x4(%eax),%edx
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 08             	lea    0x8(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800692:	eb 6f                	jmp    800703 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
  80069e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ad:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006b2:	eb 4f                	jmp    800703 <vprintfmt+0x399>
	if (lflag >= 2)
  8006b4:	83 f9 01             	cmp    $0x1,%ecx
  8006b7:	7f 23                	jg     8006dc <vprintfmt+0x372>
	else if (lflag)
  8006b9:	85 c9                	test   %ecx,%ecx
  8006bb:	0f 84 98 00 00 00    	je     800759 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006da:	eb 17                	jmp    8006f3 <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 50 04             	mov    0x4(%eax),%edx
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 40 08             	lea    0x8(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	6a 30                	push   $0x30
  8006f9:	ff d6                	call   *%esi
			goto number;
  8006fb:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006fe:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800703:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800707:	74 0b                	je     800714 <vprintfmt+0x3aa>
				putch('+', putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	6a 2b                	push   $0x2b
  80070f:	ff d6                	call   *%esi
  800711:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80071b:	50                   	push   %eax
  80071c:	ff 75 e0             	pushl  -0x20(%ebp)
  80071f:	57                   	push   %edi
  800720:	ff 75 dc             	pushl  -0x24(%ebp)
  800723:	ff 75 d8             	pushl  -0x28(%ebp)
  800726:	89 da                	mov    %ebx,%edx
  800728:	89 f0                	mov    %esi,%eax
  80072a:	e8 22 fb ff ff       	call   800251 <printnum>
			break;
  80072f:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800732:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800735:	83 c7 01             	add    $0x1,%edi
  800738:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80073c:	83 f8 25             	cmp    $0x25,%eax
  80073f:	0f 84 3c fc ff ff    	je     800381 <vprintfmt+0x17>
			if (ch == '\0')
  800745:	85 c0                	test   %eax,%eax
  800747:	0f 84 55 01 00 00    	je     8008a2 <vprintfmt+0x538>
			putch(ch, putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	50                   	push   %eax
  800752:	ff d6                	call   *%esi
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	eb dc                	jmp    800735 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
  800772:	e9 7c ff ff ff       	jmp    8006f3 <vprintfmt+0x389>
			putch('0', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	53                   	push   %ebx
  80077b:	6a 30                	push   $0x30
  80077d:	ff d6                	call   *%esi
			putch('x', putdat);
  80077f:	83 c4 08             	add    $0x8,%esp
  800782:	53                   	push   %ebx
  800783:	6a 78                	push   $0x78
  800785:	ff d6                	call   *%esi
			num = (unsigned long long)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	ba 00 00 00 00       	mov    $0x0,%edx
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800797:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8d 40 04             	lea    0x4(%eax),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a3:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  8007a8:	e9 56 ff ff ff       	jmp    800703 <vprintfmt+0x399>
	if (lflag >= 2)
  8007ad:	83 f9 01             	cmp    $0x1,%ecx
  8007b0:	7f 27                	jg     8007d9 <vprintfmt+0x46f>
	else if (lflag)
  8007b2:	85 c9                	test   %ecx,%ecx
  8007b4:	74 44                	je     8007fa <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8d 40 04             	lea    0x4(%eax),%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cf:	bf 10 00 00 00       	mov    $0x10,%edi
  8007d4:	e9 2a ff ff ff       	jmp    800703 <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8b 50 04             	mov    0x4(%eax),%edx
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 40 08             	lea    0x8(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f0:	bf 10 00 00 00       	mov    $0x10,%edi
  8007f5:	e9 09 ff ff ff       	jmp    800703 <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800807:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8d 40 04             	lea    0x4(%eax),%eax
  800810:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800813:	bf 10 00 00 00       	mov    $0x10,%edi
  800818:	e9 e6 fe ff ff       	jmp    800703 <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8d 78 04             	lea    0x4(%eax),%edi
  800823:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800825:	85 c0                	test   %eax,%eax
  800827:	74 2d                	je     800856 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800829:	0f b6 13             	movzbl (%ebx),%edx
  80082c:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  80082e:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800831:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800834:	0f 8e f8 fe ff ff    	jle    800732 <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  80083a:	68 04 14 80 00       	push   $0x801404
  80083f:	68 b7 12 80 00       	push   $0x8012b7
  800844:	53                   	push   %ebx
  800845:	56                   	push   %esi
  800846:	e8 02 fb ff ff       	call   80034d <printfmt>
  80084b:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80084e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800851:	e9 dc fe ff ff       	jmp    800732 <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800856:	68 cc 13 80 00       	push   $0x8013cc
  80085b:	68 b7 12 80 00       	push   $0x8012b7
  800860:	53                   	push   %ebx
  800861:	56                   	push   %esi
  800862:	e8 e6 fa ff ff       	call   80034d <printfmt>
  800867:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  80086a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80086d:	e9 c0 fe ff ff       	jmp    800732 <vprintfmt+0x3c8>
			putch(ch, putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	6a 25                	push   $0x25
  800878:	ff d6                	call   *%esi
			break;
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	e9 b0 fe ff ff       	jmp    800732 <vprintfmt+0x3c8>
			putch('%', putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	6a 25                	push   $0x25
  800888:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	89 f8                	mov    %edi,%eax
  80088f:	eb 03                	jmp    800894 <vprintfmt+0x52a>
  800891:	83 e8 01             	sub    $0x1,%eax
  800894:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800898:	75 f7                	jne    800891 <vprintfmt+0x527>
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	e9 90 fe ff ff       	jmp    800732 <vprintfmt+0x3c8>
}
  8008a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5f                   	pop    %edi
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 18             	sub    $0x18,%esp
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008bd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c7:	85 c0                	test   %eax,%eax
  8008c9:	74 26                	je     8008f1 <vsnprintf+0x47>
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	7e 22                	jle    8008f1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cf:	ff 75 14             	pushl  0x14(%ebp)
  8008d2:	ff 75 10             	pushl  0x10(%ebp)
  8008d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d8:	50                   	push   %eax
  8008d9:	68 30 03 80 00       	push   $0x800330
  8008de:	e8 87 fa ff ff       	call   80036a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ec:	83 c4 10             	add    $0x10,%esp
}
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    
		return -E_INVAL;
  8008f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f6:	eb f7                	jmp    8008ef <vsnprintf+0x45>

008008f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fe:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800901:	50                   	push   %eax
  800902:	ff 75 10             	pushl  0x10(%ebp)
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	ff 75 08             	pushl  0x8(%ebp)
  80090b:	e8 9a ff ff ff       	call   8008aa <vsnprintf>
	va_end(ap);

	return rc;
}
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800918:	b8 00 00 00 00       	mov    $0x0,%eax
  80091d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800921:	74 05                	je     800928 <strlen+0x16>
		n++;
  800923:	83 c0 01             	add    $0x1,%eax
  800926:	eb f5                	jmp    80091d <strlen+0xb>
	return n;
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800933:	ba 00 00 00 00       	mov    $0x0,%edx
  800938:	39 c2                	cmp    %eax,%edx
  80093a:	74 0d                	je     800949 <strnlen+0x1f>
  80093c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800940:	74 05                	je     800947 <strnlen+0x1d>
		n++;
  800942:	83 c2 01             	add    $0x1,%edx
  800945:	eb f1                	jmp    800938 <strnlen+0xe>
  800947:	89 d0                	mov    %edx,%eax
	return n;
}
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	53                   	push   %ebx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800955:	ba 00 00 00 00       	mov    $0x0,%edx
  80095a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800961:	83 c2 01             	add    $0x1,%edx
  800964:	84 c9                	test   %cl,%cl
  800966:	75 f2                	jne    80095a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800968:	5b                   	pop    %ebx
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	83 ec 10             	sub    $0x10,%esp
  800972:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800975:	53                   	push   %ebx
  800976:	e8 97 ff ff ff       	call   800912 <strlen>
  80097b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	01 d8                	add    %ebx,%eax
  800983:	50                   	push   %eax
  800984:	e8 c2 ff ff ff       	call   80094b <strcpy>
	return dst;
}
  800989:	89 d8                	mov    %ebx,%eax
  80098b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099b:	89 c6                	mov    %eax,%esi
  80099d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a0:	89 c2                	mov    %eax,%edx
  8009a2:	39 f2                	cmp    %esi,%edx
  8009a4:	74 11                	je     8009b7 <strncpy+0x27>
		*dst++ = *src;
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	0f b6 19             	movzbl (%ecx),%ebx
  8009ac:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009af:	80 fb 01             	cmp    $0x1,%bl
  8009b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b5:	eb eb                	jmp    8009a2 <strncpy+0x12>
	}
	return ret;
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	56                   	push   %esi
  8009bf:	53                   	push   %ebx
  8009c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	74 21                	je     8009f0 <strlcpy+0x35>
  8009cf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d5:	39 c2                	cmp    %eax,%edx
  8009d7:	74 14                	je     8009ed <strlcpy+0x32>
  8009d9:	0f b6 19             	movzbl (%ecx),%ebx
  8009dc:	84 db                	test   %bl,%bl
  8009de:	74 0b                	je     8009eb <strlcpy+0x30>
			*dst++ = *src++;
  8009e0:	83 c1 01             	add    $0x1,%ecx
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e9:	eb ea                	jmp    8009d5 <strlcpy+0x1a>
  8009eb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f0:	29 f0                	sub    %esi,%eax
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ff:	0f b6 01             	movzbl (%ecx),%eax
  800a02:	84 c0                	test   %al,%al
  800a04:	74 0c                	je     800a12 <strcmp+0x1c>
  800a06:	3a 02                	cmp    (%edx),%al
  800a08:	75 08                	jne    800a12 <strcmp+0x1c>
		p++, q++;
  800a0a:	83 c1 01             	add    $0x1,%ecx
  800a0d:	83 c2 01             	add    $0x1,%edx
  800a10:	eb ed                	jmp    8009ff <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a12:	0f b6 c0             	movzbl %al,%eax
  800a15:	0f b6 12             	movzbl (%edx),%edx
  800a18:	29 d0                	sub    %edx,%eax
}
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	53                   	push   %ebx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a26:	89 c3                	mov    %eax,%ebx
  800a28:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a2b:	eb 06                	jmp    800a33 <strncmp+0x17>
		n--, p++, q++;
  800a2d:	83 c0 01             	add    $0x1,%eax
  800a30:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a33:	39 d8                	cmp    %ebx,%eax
  800a35:	74 16                	je     800a4d <strncmp+0x31>
  800a37:	0f b6 08             	movzbl (%eax),%ecx
  800a3a:	84 c9                	test   %cl,%cl
  800a3c:	74 04                	je     800a42 <strncmp+0x26>
  800a3e:	3a 0a                	cmp    (%edx),%cl
  800a40:	74 eb                	je     800a2d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a42:	0f b6 00             	movzbl (%eax),%eax
  800a45:	0f b6 12             	movzbl (%edx),%edx
  800a48:	29 d0                	sub    %edx,%eax
}
  800a4a:	5b                   	pop    %ebx
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    
		return 0;
  800a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a52:	eb f6                	jmp    800a4a <strncmp+0x2e>

00800a54 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5e:	0f b6 10             	movzbl (%eax),%edx
  800a61:	84 d2                	test   %dl,%dl
  800a63:	74 09                	je     800a6e <strchr+0x1a>
		if (*s == c)
  800a65:	38 ca                	cmp    %cl,%dl
  800a67:	74 0a                	je     800a73 <strchr+0x1f>
	for (; *s; s++)
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	eb f0                	jmp    800a5e <strchr+0xa>
			return (char *) s;
	return 0;
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	74 09                	je     800a8f <strfind+0x1a>
  800a86:	84 d2                	test   %dl,%dl
  800a88:	74 05                	je     800a8f <strfind+0x1a>
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	eb f0                	jmp    800a7f <strfind+0xa>
			break;
	return (char *) s;
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	57                   	push   %edi
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9d:	85 c9                	test   %ecx,%ecx
  800a9f:	74 31                	je     800ad2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa1:	89 f8                	mov    %edi,%eax
  800aa3:	09 c8                	or     %ecx,%eax
  800aa5:	a8 03                	test   $0x3,%al
  800aa7:	75 23                	jne    800acc <memset+0x3b>
		c &= 0xFF;
  800aa9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aad:	89 d3                	mov    %edx,%ebx
  800aaf:	c1 e3 08             	shl    $0x8,%ebx
  800ab2:	89 d0                	mov    %edx,%eax
  800ab4:	c1 e0 18             	shl    $0x18,%eax
  800ab7:	89 d6                	mov    %edx,%esi
  800ab9:	c1 e6 10             	shl    $0x10,%esi
  800abc:	09 f0                	or     %esi,%eax
  800abe:	09 c2                	or     %eax,%edx
  800ac0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac5:	89 d0                	mov    %edx,%eax
  800ac7:	fc                   	cld    
  800ac8:	f3 ab                	rep stos %eax,%es:(%edi)
  800aca:	eb 06                	jmp    800ad2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acf:	fc                   	cld    
  800ad0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad2:	89 f8                	mov    %edi,%eax
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	57                   	push   %edi
  800add:	56                   	push   %esi
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae7:	39 c6                	cmp    %eax,%esi
  800ae9:	73 32                	jae    800b1d <memmove+0x44>
  800aeb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aee:	39 c2                	cmp    %eax,%edx
  800af0:	76 2b                	jbe    800b1d <memmove+0x44>
		s += n;
		d += n;
  800af2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af5:	89 fe                	mov    %edi,%esi
  800af7:	09 ce                	or     %ecx,%esi
  800af9:	09 d6                	or     %edx,%esi
  800afb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b01:	75 0e                	jne    800b11 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b03:	83 ef 04             	sub    $0x4,%edi
  800b06:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b0c:	fd                   	std    
  800b0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0f:	eb 09                	jmp    800b1a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b11:	83 ef 01             	sub    $0x1,%edi
  800b14:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b17:	fd                   	std    
  800b18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1a:	fc                   	cld    
  800b1b:	eb 1a                	jmp    800b37 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1d:	89 c2                	mov    %eax,%edx
  800b1f:	09 ca                	or     %ecx,%edx
  800b21:	09 f2                	or     %esi,%edx
  800b23:	f6 c2 03             	test   $0x3,%dl
  800b26:	75 0a                	jne    800b32 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b2b:	89 c7                	mov    %eax,%edi
  800b2d:	fc                   	cld    
  800b2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b30:	eb 05                	jmp    800b37 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b32:	89 c7                	mov    %eax,%edi
  800b34:	fc                   	cld    
  800b35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b37:	5e                   	pop    %esi
  800b38:	5f                   	pop    %edi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b41:	ff 75 10             	pushl  0x10(%ebp)
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	ff 75 08             	pushl  0x8(%ebp)
  800b4a:	e8 8a ff ff ff       	call   800ad9 <memmove>
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 c6                	mov    %eax,%esi
  800b5e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b61:	39 f0                	cmp    %esi,%eax
  800b63:	74 1c                	je     800b81 <memcmp+0x30>
		if (*s1 != *s2)
  800b65:	0f b6 08             	movzbl (%eax),%ecx
  800b68:	0f b6 1a             	movzbl (%edx),%ebx
  800b6b:	38 d9                	cmp    %bl,%cl
  800b6d:	75 08                	jne    800b77 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b6f:	83 c0 01             	add    $0x1,%eax
  800b72:	83 c2 01             	add    $0x1,%edx
  800b75:	eb ea                	jmp    800b61 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b77:	0f b6 c1             	movzbl %cl,%eax
  800b7a:	0f b6 db             	movzbl %bl,%ebx
  800b7d:	29 d8                	sub    %ebx,%eax
  800b7f:	eb 05                	jmp    800b86 <memcmp+0x35>
	}

	return 0;
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b93:	89 c2                	mov    %eax,%edx
  800b95:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b98:	39 d0                	cmp    %edx,%eax
  800b9a:	73 09                	jae    800ba5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b9c:	38 08                	cmp    %cl,(%eax)
  800b9e:	74 05                	je     800ba5 <memfind+0x1b>
	for (; s < ends; s++)
  800ba0:	83 c0 01             	add    $0x1,%eax
  800ba3:	eb f3                	jmp    800b98 <memfind+0xe>
			break;
	return (void *) s;
}
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb3:	eb 03                	jmp    800bb8 <strtol+0x11>
		s++;
  800bb5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bb8:	0f b6 01             	movzbl (%ecx),%eax
  800bbb:	3c 20                	cmp    $0x20,%al
  800bbd:	74 f6                	je     800bb5 <strtol+0xe>
  800bbf:	3c 09                	cmp    $0x9,%al
  800bc1:	74 f2                	je     800bb5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc3:	3c 2b                	cmp    $0x2b,%al
  800bc5:	74 2a                	je     800bf1 <strtol+0x4a>
	int neg = 0;
  800bc7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bcc:	3c 2d                	cmp    $0x2d,%al
  800bce:	74 2b                	je     800bfb <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd6:	75 0f                	jne    800be7 <strtol+0x40>
  800bd8:	80 39 30             	cmpb   $0x30,(%ecx)
  800bdb:	74 28                	je     800c05 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdd:	85 db                	test   %ebx,%ebx
  800bdf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be4:	0f 44 d8             	cmove  %eax,%ebx
  800be7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bec:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bef:	eb 50                	jmp    800c41 <strtol+0x9a>
		s++;
  800bf1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf9:	eb d5                	jmp    800bd0 <strtol+0x29>
		s++, neg = 1;
  800bfb:	83 c1 01             	add    $0x1,%ecx
  800bfe:	bf 01 00 00 00       	mov    $0x1,%edi
  800c03:	eb cb                	jmp    800bd0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c05:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c09:	74 0e                	je     800c19 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c0b:	85 db                	test   %ebx,%ebx
  800c0d:	75 d8                	jne    800be7 <strtol+0x40>
		s++, base = 8;
  800c0f:	83 c1 01             	add    $0x1,%ecx
  800c12:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c17:	eb ce                	jmp    800be7 <strtol+0x40>
		s += 2, base = 16;
  800c19:	83 c1 02             	add    $0x2,%ecx
  800c1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c21:	eb c4                	jmp    800be7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c23:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c26:	89 f3                	mov    %esi,%ebx
  800c28:	80 fb 19             	cmp    $0x19,%bl
  800c2b:	77 29                	ja     800c56 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c2d:	0f be d2             	movsbl %dl,%edx
  800c30:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c33:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c36:	7d 30                	jge    800c68 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c38:	83 c1 01             	add    $0x1,%ecx
  800c3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c3f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c41:	0f b6 11             	movzbl (%ecx),%edx
  800c44:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c47:	89 f3                	mov    %esi,%ebx
  800c49:	80 fb 09             	cmp    $0x9,%bl
  800c4c:	77 d5                	ja     800c23 <strtol+0x7c>
			dig = *s - '0';
  800c4e:	0f be d2             	movsbl %dl,%edx
  800c51:	83 ea 30             	sub    $0x30,%edx
  800c54:	eb dd                	jmp    800c33 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c56:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c59:	89 f3                	mov    %esi,%ebx
  800c5b:	80 fb 19             	cmp    $0x19,%bl
  800c5e:	77 08                	ja     800c68 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c60:	0f be d2             	movsbl %dl,%edx
  800c63:	83 ea 37             	sub    $0x37,%edx
  800c66:	eb cb                	jmp    800c33 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6c:	74 05                	je     800c73 <strtol+0xcc>
		*endptr = (char *) s;
  800c6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c71:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c73:	89 c2                	mov    %eax,%edx
  800c75:	f7 da                	neg    %edx
  800c77:	85 ff                	test   %edi,%edi
  800c79:	0f 45 c2             	cmovne %edx,%eax
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	89 c3                	mov    %eax,%ebx
  800c94:	89 c7                	mov    %eax,%edi
  800c96:	89 c6                	mov    %eax,%esi
  800c98:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	57                   	push   %edi
  800ca3:	56                   	push   %esi
  800ca4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca5:	ba 00 00 00 00       	mov    $0x0,%edx
  800caa:	b8 01 00 00 00       	mov    $0x1,%eax
  800caf:	89 d1                	mov    %edx,%ecx
  800cb1:	89 d3                	mov    %edx,%ebx
  800cb3:	89 d7                	mov    %edx,%edi
  800cb5:	89 d6                	mov    %edx,%esi
  800cb7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd4:	89 cb                	mov    %ecx,%ebx
  800cd6:	89 cf                	mov    %ecx,%edi
  800cd8:	89 ce                	mov    %ecx,%esi
  800cda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	7f 08                	jg     800ce8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	50                   	push   %eax
  800cec:	6a 03                	push   $0x3
  800cee:	68 20 16 80 00       	push   $0x801620
  800cf3:	6a 33                	push   $0x33
  800cf5:	68 3d 16 80 00       	push   $0x80163d
  800cfa:	e8 b1 02 00 00       	call   800fb0 <_panic>

00800cff <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d05:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0f:	89 d1                	mov    %edx,%ecx
  800d11:	89 d3                	mov    %edx,%ebx
  800d13:	89 d7                	mov    %edx,%edi
  800d15:	89 d6                	mov    %edx,%esi
  800d17:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <sys_yield>:

void
sys_yield(void)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d24:	ba 00 00 00 00       	mov    $0x0,%edx
  800d29:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d2e:	89 d1                	mov    %edx,%ecx
  800d30:	89 d3                	mov    %edx,%ebx
  800d32:	89 d7                	mov    %edx,%edi
  800d34:	89 d6                	mov    %edx,%esi
  800d36:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d46:	be 00 00 00 00       	mov    $0x0,%esi
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d51:	b8 04 00 00 00       	mov    $0x4,%eax
  800d56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d59:	89 f7                	mov    %esi,%edi
  800d5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	7f 08                	jg     800d69 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d69:	83 ec 0c             	sub    $0xc,%esp
  800d6c:	50                   	push   %eax
  800d6d:	6a 04                	push   $0x4
  800d6f:	68 20 16 80 00       	push   $0x801620
  800d74:	6a 33                	push   $0x33
  800d76:	68 3d 16 80 00       	push   $0x80163d
  800d7b:	e8 30 02 00 00       	call   800fb0 <_panic>

00800d80 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7f 08                	jg     800dab <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dab:	83 ec 0c             	sub    $0xc,%esp
  800dae:	50                   	push   %eax
  800daf:	6a 05                	push   $0x5
  800db1:	68 20 16 80 00       	push   $0x801620
  800db6:	6a 33                	push   $0x33
  800db8:	68 3d 16 80 00       	push   $0x80163d
  800dbd:	e8 ee 01 00 00       	call   800fb0 <_panic>

00800dc2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	b8 06 00 00 00       	mov    $0x6,%eax
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	89 de                	mov    %ebx,%esi
  800ddf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	7f 08                	jg     800ded <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	50                   	push   %eax
  800df1:	6a 06                	push   $0x6
  800df3:	68 20 16 80 00       	push   $0x801620
  800df8:	6a 33                	push   $0x33
  800dfa:	68 3d 16 80 00       	push   $0x80163d
  800dff:	e8 ac 01 00 00       	call   800fb0 <_panic>

00800e04 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e1a:	89 cb                	mov    %ecx,%ebx
  800e1c:	89 cf                	mov    %ecx,%edi
  800e1e:	89 ce                	mov    %ecx,%esi
  800e20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e22:	85 c0                	test   %eax,%eax
  800e24:	7f 08                	jg     800e2e <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	6a 0b                	push   $0xb
  800e34:	68 20 16 80 00       	push   $0x801620
  800e39:	6a 33                	push   $0x33
  800e3b:	68 3d 16 80 00       	push   $0x80163d
  800e40:	e8 6b 01 00 00       	call   800fb0 <_panic>

00800e45 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	b8 08 00 00 00       	mov    $0x8,%eax
  800e5e:	89 df                	mov    %ebx,%edi
  800e60:	89 de                	mov    %ebx,%esi
  800e62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7f 08                	jg     800e70 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	50                   	push   %eax
  800e74:	6a 08                	push   $0x8
  800e76:	68 20 16 80 00       	push   $0x801620
  800e7b:	6a 33                	push   $0x33
  800e7d:	68 3d 16 80 00       	push   $0x80163d
  800e82:	e8 29 01 00 00       	call   800fb0 <_panic>

00800e87 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea0:	89 df                	mov    %ebx,%edi
  800ea2:	89 de                	mov    %ebx,%esi
  800ea4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	7f 08                	jg     800eb2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	50                   	push   %eax
  800eb6:	6a 09                	push   $0x9
  800eb8:	68 20 16 80 00       	push   $0x801620
  800ebd:	6a 33                	push   $0x33
  800ebf:	68 3d 16 80 00       	push   $0x80163d
  800ec4:	e8 e7 00 00 00       	call   800fb0 <_panic>

00800ec9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee2:	89 df                	mov    %ebx,%edi
  800ee4:	89 de                	mov    %ebx,%esi
  800ee6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	7f 08                	jg     800ef4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef4:	83 ec 0c             	sub    $0xc,%esp
  800ef7:	50                   	push   %eax
  800ef8:	6a 0a                	push   $0xa
  800efa:	68 20 16 80 00       	push   $0x801620
  800eff:	6a 33                	push   $0x33
  800f01:	68 3d 16 80 00       	push   $0x80163d
  800f06:	e8 a5 00 00 00       	call   800fb0 <_panic>

00800f0b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f17:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1c:	be 00 00 00 00       	mov    $0x0,%esi
  800f21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f24:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f27:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f44:	89 cb                	mov    %ecx,%ebx
  800f46:	89 cf                	mov    %ecx,%edi
  800f48:	89 ce                	mov    %ecx,%esi
  800f4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7f 08                	jg     800f58 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	50                   	push   %eax
  800f5c:	6a 0e                	push   $0xe
  800f5e:	68 20 16 80 00       	push   $0x801620
  800f63:	6a 33                	push   $0x33
  800f65:	68 3d 16 80 00       	push   $0x80163d
  800f6a:	e8 41 00 00 00       	call   800fb0 <_panic>

00800f6f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f85:	89 df                	mov    %ebx,%edi
  800f87:	89 de                	mov    %ebx,%esi
  800f89:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f8b:	5b                   	pop    %ebx
  800f8c:	5e                   	pop    %esi
  800f8d:	5f                   	pop    %edi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	57                   	push   %edi
  800f94:	56                   	push   %esi
  800f95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	b8 10 00 00 00       	mov    $0x10,%eax
  800fa3:	89 cb                	mov    %ecx,%ebx
  800fa5:	89 cf                	mov    %ecx,%edi
  800fa7:	89 ce                	mov    %ecx,%esi
  800fa9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fb5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fb8:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800fbe:	e8 3c fd ff ff       	call   800cff <sys_getenvid>
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	56                   	push   %esi
  800fcd:	50                   	push   %eax
  800fce:	68 4c 16 80 00       	push   $0x80164c
  800fd3:	e8 65 f2 ff ff       	call   80023d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800fd8:	83 c4 18             	add    $0x18,%esp
  800fdb:	53                   	push   %ebx
  800fdc:	ff 75 10             	pushl  0x10(%ebp)
  800fdf:	e8 08 f2 ff ff       	call   8001ec <vcprintf>
	cprintf("\n");
  800fe4:	c7 04 24 70 16 80 00 	movl   $0x801670,(%esp)
  800feb:	e8 4d f2 ff ff       	call   80023d <cprintf>
  800ff0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ff3:	cc                   	int3   
  800ff4:	eb fd                	jmp    800ff3 <_panic+0x43>
  800ff6:	66 90                	xchg   %ax,%ax
  800ff8:	66 90                	xchg   %ax,%ax
  800ffa:	66 90                	xchg   %ax,%ax
  800ffc:	66 90                	xchg   %ax,%ax
  800ffe:	66 90                	xchg   %ax,%ax

00801000 <__udivdi3>:
  801000:	55                   	push   %ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 1c             	sub    $0x1c,%esp
  801007:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80100b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80100f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801013:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801017:	85 d2                	test   %edx,%edx
  801019:	75 4d                	jne    801068 <__udivdi3+0x68>
  80101b:	39 f3                	cmp    %esi,%ebx
  80101d:	76 19                	jbe    801038 <__udivdi3+0x38>
  80101f:	31 ff                	xor    %edi,%edi
  801021:	89 e8                	mov    %ebp,%eax
  801023:	89 f2                	mov    %esi,%edx
  801025:	f7 f3                	div    %ebx
  801027:	89 fa                	mov    %edi,%edx
  801029:	83 c4 1c             	add    $0x1c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801038:	89 d9                	mov    %ebx,%ecx
  80103a:	85 db                	test   %ebx,%ebx
  80103c:	75 0b                	jne    801049 <__udivdi3+0x49>
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
  801043:	31 d2                	xor    %edx,%edx
  801045:	f7 f3                	div    %ebx
  801047:	89 c1                	mov    %eax,%ecx
  801049:	31 d2                	xor    %edx,%edx
  80104b:	89 f0                	mov    %esi,%eax
  80104d:	f7 f1                	div    %ecx
  80104f:	89 c6                	mov    %eax,%esi
  801051:	89 e8                	mov    %ebp,%eax
  801053:	89 f7                	mov    %esi,%edi
  801055:	f7 f1                	div    %ecx
  801057:	89 fa                	mov    %edi,%edx
  801059:	83 c4 1c             	add    $0x1c,%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
  801061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801068:	39 f2                	cmp    %esi,%edx
  80106a:	77 1c                	ja     801088 <__udivdi3+0x88>
  80106c:	0f bd fa             	bsr    %edx,%edi
  80106f:	83 f7 1f             	xor    $0x1f,%edi
  801072:	75 2c                	jne    8010a0 <__udivdi3+0xa0>
  801074:	39 f2                	cmp    %esi,%edx
  801076:	72 06                	jb     80107e <__udivdi3+0x7e>
  801078:	31 c0                	xor    %eax,%eax
  80107a:	39 eb                	cmp    %ebp,%ebx
  80107c:	77 a9                	ja     801027 <__udivdi3+0x27>
  80107e:	b8 01 00 00 00       	mov    $0x1,%eax
  801083:	eb a2                	jmp    801027 <__udivdi3+0x27>
  801085:	8d 76 00             	lea    0x0(%esi),%esi
  801088:	31 ff                	xor    %edi,%edi
  80108a:	31 c0                	xor    %eax,%eax
  80108c:	89 fa                	mov    %edi,%edx
  80108e:	83 c4 1c             	add    $0x1c,%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
  801096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80109d:	8d 76 00             	lea    0x0(%esi),%esi
  8010a0:	89 f9                	mov    %edi,%ecx
  8010a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8010a7:	29 f8                	sub    %edi,%eax
  8010a9:	d3 e2                	shl    %cl,%edx
  8010ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010af:	89 c1                	mov    %eax,%ecx
  8010b1:	89 da                	mov    %ebx,%edx
  8010b3:	d3 ea                	shr    %cl,%edx
  8010b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010b9:	09 d1                	or     %edx,%ecx
  8010bb:	89 f2                	mov    %esi,%edx
  8010bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010c1:	89 f9                	mov    %edi,%ecx
  8010c3:	d3 e3                	shl    %cl,%ebx
  8010c5:	89 c1                	mov    %eax,%ecx
  8010c7:	d3 ea                	shr    %cl,%edx
  8010c9:	89 f9                	mov    %edi,%ecx
  8010cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010cf:	89 eb                	mov    %ebp,%ebx
  8010d1:	d3 e6                	shl    %cl,%esi
  8010d3:	89 c1                	mov    %eax,%ecx
  8010d5:	d3 eb                	shr    %cl,%ebx
  8010d7:	09 de                	or     %ebx,%esi
  8010d9:	89 f0                	mov    %esi,%eax
  8010db:	f7 74 24 08          	divl   0x8(%esp)
  8010df:	89 d6                	mov    %edx,%esi
  8010e1:	89 c3                	mov    %eax,%ebx
  8010e3:	f7 64 24 0c          	mull   0xc(%esp)
  8010e7:	39 d6                	cmp    %edx,%esi
  8010e9:	72 15                	jb     801100 <__udivdi3+0x100>
  8010eb:	89 f9                	mov    %edi,%ecx
  8010ed:	d3 e5                	shl    %cl,%ebp
  8010ef:	39 c5                	cmp    %eax,%ebp
  8010f1:	73 04                	jae    8010f7 <__udivdi3+0xf7>
  8010f3:	39 d6                	cmp    %edx,%esi
  8010f5:	74 09                	je     801100 <__udivdi3+0x100>
  8010f7:	89 d8                	mov    %ebx,%eax
  8010f9:	31 ff                	xor    %edi,%edi
  8010fb:	e9 27 ff ff ff       	jmp    801027 <__udivdi3+0x27>
  801100:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801103:	31 ff                	xor    %edi,%edi
  801105:	e9 1d ff ff ff       	jmp    801027 <__udivdi3+0x27>
  80110a:	66 90                	xchg   %ax,%ax
  80110c:	66 90                	xchg   %ax,%ax
  80110e:	66 90                	xchg   %ax,%ax

00801110 <__umoddi3>:
  801110:	55                   	push   %ebp
  801111:	57                   	push   %edi
  801112:	56                   	push   %esi
  801113:	53                   	push   %ebx
  801114:	83 ec 1c             	sub    $0x1c,%esp
  801117:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80111b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80111f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801127:	89 da                	mov    %ebx,%edx
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 43                	jne    801170 <__umoddi3+0x60>
  80112d:	39 df                	cmp    %ebx,%edi
  80112f:	76 17                	jbe    801148 <__umoddi3+0x38>
  801131:	89 f0                	mov    %esi,%eax
  801133:	f7 f7                	div    %edi
  801135:	89 d0                	mov    %edx,%eax
  801137:	31 d2                	xor    %edx,%edx
  801139:	83 c4 1c             	add    $0x1c,%esp
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    
  801141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801148:	89 fd                	mov    %edi,%ebp
  80114a:	85 ff                	test   %edi,%edi
  80114c:	75 0b                	jne    801159 <__umoddi3+0x49>
  80114e:	b8 01 00 00 00       	mov    $0x1,%eax
  801153:	31 d2                	xor    %edx,%edx
  801155:	f7 f7                	div    %edi
  801157:	89 c5                	mov    %eax,%ebp
  801159:	89 d8                	mov    %ebx,%eax
  80115b:	31 d2                	xor    %edx,%edx
  80115d:	f7 f5                	div    %ebp
  80115f:	89 f0                	mov    %esi,%eax
  801161:	f7 f5                	div    %ebp
  801163:	89 d0                	mov    %edx,%eax
  801165:	eb d0                	jmp    801137 <__umoddi3+0x27>
  801167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80116e:	66 90                	xchg   %ax,%ax
  801170:	89 f1                	mov    %esi,%ecx
  801172:	39 d8                	cmp    %ebx,%eax
  801174:	76 0a                	jbe    801180 <__umoddi3+0x70>
  801176:	89 f0                	mov    %esi,%eax
  801178:	83 c4 1c             	add    $0x1c,%esp
  80117b:	5b                   	pop    %ebx
  80117c:	5e                   	pop    %esi
  80117d:	5f                   	pop    %edi
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    
  801180:	0f bd e8             	bsr    %eax,%ebp
  801183:	83 f5 1f             	xor    $0x1f,%ebp
  801186:	75 20                	jne    8011a8 <__umoddi3+0x98>
  801188:	39 d8                	cmp    %ebx,%eax
  80118a:	0f 82 b0 00 00 00    	jb     801240 <__umoddi3+0x130>
  801190:	39 f7                	cmp    %esi,%edi
  801192:	0f 86 a8 00 00 00    	jbe    801240 <__umoddi3+0x130>
  801198:	89 c8                	mov    %ecx,%eax
  80119a:	83 c4 1c             	add    $0x1c,%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5e                   	pop    %esi
  80119f:	5f                   	pop    %edi
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    
  8011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011a8:	89 e9                	mov    %ebp,%ecx
  8011aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8011af:	29 ea                	sub    %ebp,%edx
  8011b1:	d3 e0                	shl    %cl,%eax
  8011b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011b7:	89 d1                	mov    %edx,%ecx
  8011b9:	89 f8                	mov    %edi,%eax
  8011bb:	d3 e8                	shr    %cl,%eax
  8011bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8011c9:	09 c1                	or     %eax,%ecx
  8011cb:	89 d8                	mov    %ebx,%eax
  8011cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011d1:	89 e9                	mov    %ebp,%ecx
  8011d3:	d3 e7                	shl    %cl,%edi
  8011d5:	89 d1                	mov    %edx,%ecx
  8011d7:	d3 e8                	shr    %cl,%eax
  8011d9:	89 e9                	mov    %ebp,%ecx
  8011db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011df:	d3 e3                	shl    %cl,%ebx
  8011e1:	89 c7                	mov    %eax,%edi
  8011e3:	89 d1                	mov    %edx,%ecx
  8011e5:	89 f0                	mov    %esi,%eax
  8011e7:	d3 e8                	shr    %cl,%eax
  8011e9:	89 e9                	mov    %ebp,%ecx
  8011eb:	89 fa                	mov    %edi,%edx
  8011ed:	d3 e6                	shl    %cl,%esi
  8011ef:	09 d8                	or     %ebx,%eax
  8011f1:	f7 74 24 08          	divl   0x8(%esp)
  8011f5:	89 d1                	mov    %edx,%ecx
  8011f7:	89 f3                	mov    %esi,%ebx
  8011f9:	f7 64 24 0c          	mull   0xc(%esp)
  8011fd:	89 c6                	mov    %eax,%esi
  8011ff:	89 d7                	mov    %edx,%edi
  801201:	39 d1                	cmp    %edx,%ecx
  801203:	72 06                	jb     80120b <__umoddi3+0xfb>
  801205:	75 10                	jne    801217 <__umoddi3+0x107>
  801207:	39 c3                	cmp    %eax,%ebx
  801209:	73 0c                	jae    801217 <__umoddi3+0x107>
  80120b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80120f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801213:	89 d7                	mov    %edx,%edi
  801215:	89 c6                	mov    %eax,%esi
  801217:	89 ca                	mov    %ecx,%edx
  801219:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80121e:	29 f3                	sub    %esi,%ebx
  801220:	19 fa                	sbb    %edi,%edx
  801222:	89 d0                	mov    %edx,%eax
  801224:	d3 e0                	shl    %cl,%eax
  801226:	89 e9                	mov    %ebp,%ecx
  801228:	d3 eb                	shr    %cl,%ebx
  80122a:	d3 ea                	shr    %cl,%edx
  80122c:	09 d8                	or     %ebx,%eax
  80122e:	83 c4 1c             	add    $0x1c,%esp
  801231:	5b                   	pop    %ebx
  801232:	5e                   	pop    %esi
  801233:	5f                   	pop    %edi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    
  801236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80123d:	8d 76 00             	lea    0x0(%esi),%esi
  801240:	89 da                	mov    %ebx,%edx
  801242:	29 fe                	sub    %edi,%esi
  801244:	19 c2                	sbb    %eax,%edx
  801246:	89 f1                	mov    %esi,%ecx
  801248:	89 c8                	mov    %ecx,%eax
  80124a:	e9 4b ff ff ff       	jmp    80119a <__umoddi3+0x8a>
