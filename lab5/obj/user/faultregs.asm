
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 b0 05 00 00       	call   8005e1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 b1 17 80 00       	push   $0x8017b1
  800049:	68 80 17 80 00       	push   $0x801780
  80004e:	e8 c4 06 00 00       	call   800717 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 90 17 80 00       	push   $0x801790
  80005c:	68 94 17 80 00       	push   $0x801794
  800061:	e8 b1 06 00 00       	call   800717 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 a8 17 80 00       	push   $0x8017a8
  80007b:	e8 97 06 00 00       	call   800717 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 b2 17 80 00       	push   $0x8017b2
  800093:	68 94 17 80 00       	push   $0x801794
  800098:	e8 7a 06 00 00       	call   800717 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 a8 17 80 00       	push   $0x8017a8
  8000b4:	e8 5e 06 00 00       	call   800717 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 b6 17 80 00       	push   $0x8017b6
  8000cc:	68 94 17 80 00       	push   $0x801794
  8000d1:	e8 41 06 00 00       	call   800717 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 a8 17 80 00       	push   $0x8017a8
  8000ed:	e8 25 06 00 00       	call   800717 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 ba 17 80 00       	push   $0x8017ba
  800105:	68 94 17 80 00       	push   $0x801794
  80010a:	e8 08 06 00 00       	call   800717 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 a8 17 80 00       	push   $0x8017a8
  800126:	e8 ec 05 00 00       	call   800717 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 be 17 80 00       	push   $0x8017be
  80013e:	68 94 17 80 00       	push   $0x801794
  800143:	e8 cf 05 00 00       	call   800717 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 a8 17 80 00       	push   $0x8017a8
  80015f:	e8 b3 05 00 00       	call   800717 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 c2 17 80 00       	push   $0x8017c2
  800177:	68 94 17 80 00       	push   $0x801794
  80017c:	e8 96 05 00 00       	call   800717 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 a8 17 80 00       	push   $0x8017a8
  800198:	e8 7a 05 00 00       	call   800717 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 c6 17 80 00       	push   $0x8017c6
  8001b0:	68 94 17 80 00       	push   $0x801794
  8001b5:	e8 5d 05 00 00       	call   800717 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 a8 17 80 00       	push   $0x8017a8
  8001d1:	e8 41 05 00 00       	call   800717 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 ca 17 80 00       	push   $0x8017ca
  8001e9:	68 94 17 80 00       	push   $0x801794
  8001ee:	e8 24 05 00 00       	call   800717 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 a8 17 80 00       	push   $0x8017a8
  80020a:	e8 08 05 00 00       	call   800717 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 ce 17 80 00       	push   $0x8017ce
  800222:	68 94 17 80 00       	push   $0x801794
  800227:	e8 eb 04 00 00       	call   800717 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 a8 17 80 00       	push   $0x8017a8
  800243:	e8 cf 04 00 00       	call   800717 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 d5 17 80 00       	push   $0x8017d5
  800253:	68 94 17 80 00       	push   $0x801794
  800258:	e8 ba 04 00 00       	call   800717 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 a8 17 80 00       	push   $0x8017a8
  800274:	e8 9e 04 00 00       	call   800717 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 d9 17 80 00       	push   $0x8017d9
  800284:	e8 8e 04 00 00       	call   800717 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 a8 17 80 00       	push   $0x8017a8
  800294:	e8 7e 04 00 00       	call   800717 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 a4 17 80 00       	push   $0x8017a4
  8002a9:	e8 69 04 00 00       	call   800717 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 a4 17 80 00       	push   $0x8017a4
  8002c3:	e8 4f 04 00 00       	call   800717 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 a4 17 80 00       	push   $0x8017a4
  8002d8:	e8 3a 04 00 00       	call   800717 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 a4 17 80 00       	push   $0x8017a4
  8002ed:	e8 25 04 00 00       	call   800717 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 a4 17 80 00       	push   $0x8017a4
  800302:	e8 10 04 00 00       	call   800717 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 a4 17 80 00       	push   $0x8017a4
  800317:	e8 fb 03 00 00       	call   800717 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 a4 17 80 00       	push   $0x8017a4
  80032c:	e8 e6 03 00 00       	call   800717 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 a4 17 80 00       	push   $0x8017a4
  800341:	e8 d1 03 00 00       	call   800717 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 a4 17 80 00       	push   $0x8017a4
  800356:	e8 bc 03 00 00       	call   800717 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 d5 17 80 00       	push   $0x8017d5
  800366:	68 94 17 80 00       	push   $0x801794
  80036b:	e8 a7 03 00 00       	call   800717 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 a4 17 80 00       	push   $0x8017a4
  800387:	e8 8b 03 00 00       	call   800717 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 d9 17 80 00       	push   $0x8017d9
  800397:	e8 7b 03 00 00       	call   800717 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 a4 17 80 00       	push   $0x8017a4
  8003af:	e8 63 03 00 00       	call   800717 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
}
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 a4 17 80 00       	push   $0x8017a4
  8003c7:	e8 4b 03 00 00       	call   800717 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 d9 17 80 00       	push   $0x8017d9
  8003d7:	e8 3b 03 00 00       	call   800717 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 60 20 80 00    	mov    %edx,0x802060
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 64 20 80 00    	mov    %edx,0x802064
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 68 20 80 00    	mov    %edx,0x802068
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 6c 20 80 00    	mov    %edx,0x80206c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 70 20 80 00    	mov    %edx,0x802070
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 74 20 80 00    	mov    %edx,0x802074
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 78 20 80 00    	mov    %edx,0x802078
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 7c 20 80 00    	mov    %edx,0x80207c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 80 20 80 00    	mov    %edx,0x802080
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 84 20 80 00    	mov    %edx,0x802084
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 88 20 80 00       	mov    %eax,0x802088
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 ff 17 80 00       	push   $0x8017ff
  80046b:	68 0d 18 80 00       	push   $0x80180d
  800470:	b9 60 20 80 00       	mov    $0x802060,%ecx
  800475:	ba f8 17 80 00       	mov    $0x8017f8,%edx
  80047a:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 82 0d 00 00       	call   801217 <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	pushl  0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 40 18 80 00       	push   $0x801840
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 e7 17 80 00       	push   $0x8017e7
  8004b1:	e8 86 01 00 00       	call   80063c <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 14 18 80 00       	push   $0x801814
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 e7 17 80 00       	push   $0x8017e7
  8004c3:	e8 74 01 00 00       	call   80063c <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 b2 0f 00 00       	call   80148a <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 c4 20 80 00       	mov    %eax,0x8020c4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 c0 20 80 00       	mov    %eax,0x8020c0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d a0 20 80 00    	mov    %edi,0x8020a0
  8004f9:	89 35 a4 20 80 00    	mov    %esi,0x8020a4
  8004ff:	89 2d a8 20 80 00    	mov    %ebp,0x8020a8
  800505:	89 1d b0 20 80 00    	mov    %ebx,0x8020b0
  80050b:	89 15 b4 20 80 00    	mov    %edx,0x8020b4
  800511:	89 0d b8 20 80 00    	mov    %ecx,0x8020b8
  800517:	a3 bc 20 80 00       	mov    %eax,0x8020bc
  80051c:	89 25 c8 20 80 00    	mov    %esp,0x8020c8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 20 20 80 00    	mov    %edi,0x802020
  800532:	89 35 24 20 80 00    	mov    %esi,0x802024
  800538:	89 2d 28 20 80 00    	mov    %ebp,0x802028
  80053e:	89 1d 30 20 80 00    	mov    %ebx,0x802030
  800544:	89 15 34 20 80 00    	mov    %edx,0x802034
  80054a:	89 0d 38 20 80 00    	mov    %ecx,0x802038
  800550:	a3 3c 20 80 00       	mov    %eax,0x80203c
  800555:	89 25 48 20 80 00    	mov    %esp,0x802048
  80055b:	8b 3d a0 20 80 00    	mov    0x8020a0,%edi
  800561:	8b 35 a4 20 80 00    	mov    0x8020a4,%esi
  800567:	8b 2d a8 20 80 00    	mov    0x8020a8,%ebp
  80056d:	8b 1d b0 20 80 00    	mov    0x8020b0,%ebx
  800573:	8b 15 b4 20 80 00    	mov    0x8020b4,%edx
  800579:	8b 0d b8 20 80 00    	mov    0x8020b8,%ecx
  80057f:	a1 bc 20 80 00       	mov    0x8020bc,%eax
  800584:	8b 25 c8 20 80 00    	mov    0x8020c8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 44 20 80 00       	mov    %eax,0x802044
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	75 30                	jne    8005cf <umain+0x107>
		cprintf("EIP after page-fault MISMATCH\n");
	after.eip = before.eip;
  80059f:	a1 c0 20 80 00       	mov    0x8020c0,%eax
  8005a4:	a3 40 20 80 00       	mov    %eax,0x802040

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	68 27 18 80 00       	push   $0x801827
  8005b1:	68 38 18 80 00       	push   $0x801838
  8005b6:	b9 20 20 80 00       	mov    $0x802020,%ecx
  8005bb:	ba f8 17 80 00       	mov    $0x8017f8,%edx
  8005c0:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 74 18 80 00       	push   $0x801874
  8005d7:	e8 3b 01 00 00       	call   800717 <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb be                	jmp    80059f <umain+0xd7>

008005e1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	56                   	push   %esi
  8005e5:	53                   	push   %ebx
  8005e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005ec:	e8 e8 0b 00 00       	call   8011d9 <sys_getenvid>
  8005f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f6:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8005f9:	c1 e0 04             	shl    $0x4,%eax
  8005fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800601:	a3 cc 20 80 00       	mov    %eax,0x8020cc

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800606:	85 db                	test   %ebx,%ebx
  800608:	7e 07                	jle    800611 <libmain+0x30>
		binaryname = argv[0];
  80060a:	8b 06                	mov    (%esi),%eax
  80060c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	56                   	push   %esi
  800615:	53                   	push   %ebx
  800616:	e8 ad fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  80061b:	e8 0a 00 00 00       	call   80062a <exit>
}
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800626:	5b                   	pop    %ebx
  800627:	5e                   	pop    %esi
  800628:	5d                   	pop    %ebp
  800629:	c3                   	ret    

0080062a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800630:	6a 00                	push   $0x0
  800632:	e8 61 0b 00 00       	call   801198 <sys_env_destroy>
}
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	c9                   	leave  
  80063b:	c3                   	ret    

0080063c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80063c:	55                   	push   %ebp
  80063d:	89 e5                	mov    %esp,%ebp
  80063f:	56                   	push   %esi
  800640:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800641:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800644:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80064a:	e8 8a 0b 00 00       	call   8011d9 <sys_getenvid>
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	ff 75 08             	pushl  0x8(%ebp)
  800658:	56                   	push   %esi
  800659:	50                   	push   %eax
  80065a:	68 a0 18 80 00       	push   $0x8018a0
  80065f:	e8 b3 00 00 00       	call   800717 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800664:	83 c4 18             	add    $0x18,%esp
  800667:	53                   	push   %ebx
  800668:	ff 75 10             	pushl  0x10(%ebp)
  80066b:	e8 56 00 00 00       	call   8006c6 <vcprintf>
	cprintf("\n");
  800670:	c7 04 24 b0 17 80 00 	movl   $0x8017b0,(%esp)
  800677:	e8 9b 00 00 00       	call   800717 <cprintf>
  80067c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80067f:	cc                   	int3   
  800680:	eb fd                	jmp    80067f <_panic+0x43>

00800682 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	53                   	push   %ebx
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80068c:	8b 13                	mov    (%ebx),%edx
  80068e:	8d 42 01             	lea    0x1(%edx),%eax
  800691:	89 03                	mov    %eax,(%ebx)
  800693:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800696:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80069a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069f:	74 09                	je     8006aa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	68 ff 00 00 00       	push   $0xff
  8006b2:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b5:	50                   	push   %eax
  8006b6:	e8 a0 0a 00 00       	call   80115b <sys_cputs>
		b->idx = 0;
  8006bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	eb db                	jmp    8006a1 <putch+0x1f>

008006c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d6:	00 00 00 
	b.cnt = 0;
  8006d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ef:	50                   	push   %eax
  8006f0:	68 82 06 80 00       	push   $0x800682
  8006f5:	e8 4a 01 00 00       	call   800844 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006fa:	83 c4 08             	add    $0x8,%esp
  8006fd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800703:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800709:	50                   	push   %eax
  80070a:	e8 4c 0a 00 00       	call   80115b <sys_cputs>

	return b.cnt;
}
  80070f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80071d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800720:	50                   	push   %eax
  800721:	ff 75 08             	pushl  0x8(%ebp)
  800724:	e8 9d ff ff ff       	call   8006c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	57                   	push   %edi
  80072f:	56                   	push   %esi
  800730:	53                   	push   %ebx
  800731:	83 ec 1c             	sub    $0x1c,%esp
  800734:	89 c6                	mov    %eax,%esi
  800736:	89 d7                	mov    %edx,%edi
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800741:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800744:	8b 45 10             	mov    0x10(%ebp),%eax
  800747:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80074a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80074e:	74 2c                	je     80077c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80075a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80075d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800760:	39 c2                	cmp    %eax,%edx
  800762:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800765:	73 43                	jae    8007aa <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800767:	83 eb 01             	sub    $0x1,%ebx
  80076a:	85 db                	test   %ebx,%ebx
  80076c:	7e 6c                	jle    8007da <printnum+0xaf>
			putch(padc, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	57                   	push   %edi
  800772:	ff 75 18             	pushl  0x18(%ebp)
  800775:	ff d6                	call   *%esi
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	eb eb                	jmp    800767 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	6a 20                	push   $0x20
  800781:	6a 00                	push   $0x0
  800783:	50                   	push   %eax
  800784:	ff 75 e4             	pushl  -0x1c(%ebp)
  800787:	ff 75 e0             	pushl  -0x20(%ebp)
  80078a:	89 fa                	mov    %edi,%edx
  80078c:	89 f0                	mov    %esi,%eax
  80078e:	e8 98 ff ff ff       	call   80072b <printnum>
		while (--width > 0)
  800793:	83 c4 20             	add    $0x20,%esp
  800796:	83 eb 01             	sub    $0x1,%ebx
  800799:	85 db                	test   %ebx,%ebx
  80079b:	7e 65                	jle    800802 <printnum+0xd7>
			putch(padc, putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	57                   	push   %edi
  8007a1:	6a 20                	push   $0x20
  8007a3:	ff d6                	call   *%esi
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	eb ec                	jmp    800796 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007aa:	83 ec 0c             	sub    $0xc,%esp
  8007ad:	ff 75 18             	pushl  0x18(%ebp)
  8007b0:	83 eb 01             	sub    $0x1,%ebx
  8007b3:	53                   	push   %ebx
  8007b4:	50                   	push   %eax
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8007bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8007be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c4:	e8 57 0d 00 00       	call   801520 <__udivdi3>
  8007c9:	83 c4 18             	add    $0x18,%esp
  8007cc:	52                   	push   %edx
  8007cd:	50                   	push   %eax
  8007ce:	89 fa                	mov    %edi,%edx
  8007d0:	89 f0                	mov    %esi,%eax
  8007d2:	e8 54 ff ff ff       	call   80072b <printnum>
  8007d7:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	57                   	push   %edi
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e4:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ed:	e8 3e 0e 00 00       	call   801630 <__umoddi3>
  8007f2:	83 c4 14             	add    $0x14,%esp
  8007f5:	0f be 80 c3 18 80 00 	movsbl 0x8018c3(%eax),%eax
  8007fc:	50                   	push   %eax
  8007fd:	ff d6                	call   *%esi
  8007ff:	83 c4 10             	add    $0x10,%esp
}
  800802:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800805:	5b                   	pop    %ebx
  800806:	5e                   	pop    %esi
  800807:	5f                   	pop    %edi
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800810:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800814:	8b 10                	mov    (%eax),%edx
  800816:	3b 50 04             	cmp    0x4(%eax),%edx
  800819:	73 0a                	jae    800825 <sprintputch+0x1b>
		*b->buf++ = ch;
  80081b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80081e:	89 08                	mov    %ecx,(%eax)
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	88 02                	mov    %al,(%edx)
}
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <printfmt>:
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80082d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800830:	50                   	push   %eax
  800831:	ff 75 10             	pushl  0x10(%ebp)
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	ff 75 08             	pushl  0x8(%ebp)
  80083a:	e8 05 00 00 00       	call   800844 <vprintfmt>
}
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	c9                   	leave  
  800843:	c3                   	ret    

00800844 <vprintfmt>:
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	57                   	push   %edi
  800848:	56                   	push   %esi
  800849:	53                   	push   %ebx
  80084a:	83 ec 3c             	sub    $0x3c,%esp
  80084d:	8b 75 08             	mov    0x8(%ebp),%esi
  800850:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800853:	8b 7d 10             	mov    0x10(%ebp),%edi
  800856:	e9 b4 03 00 00       	jmp    800c0f <vprintfmt+0x3cb>
		padc = ' ';
  80085b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  80085f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  800866:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80086d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800874:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80087b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800880:	8d 47 01             	lea    0x1(%edi),%eax
  800883:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800886:	0f b6 17             	movzbl (%edi),%edx
  800889:	8d 42 dd             	lea    -0x23(%edx),%eax
  80088c:	3c 55                	cmp    $0x55,%al
  80088e:	0f 87 c8 04 00 00    	ja     800d5c <vprintfmt+0x518>
  800894:	0f b6 c0             	movzbl %al,%eax
  800897:	ff 24 85 a0 1a 80 00 	jmp    *0x801aa0(,%eax,4)
  80089e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8008a1:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8008a8:	eb d6                	jmp    800880 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8008aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8008ad:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8008b1:	eb cd                	jmp    800880 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8008b3:	0f b6 d2             	movzbl %dl,%edx
  8008b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8008b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008be:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8008c1:	eb 0c                	jmp    8008cf <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  8008c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8008c6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8008ca:	eb b4                	jmp    800880 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  8008cc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8008cf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008d2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8008d6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8008d9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8008dc:	83 f9 09             	cmp    $0x9,%ecx
  8008df:	76 eb                	jbe    8008cc <vprintfmt+0x88>
  8008e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e7:	eb 14                	jmp    8008fd <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	8d 40 04             	lea    0x4(%eax),%eax
  8008f7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800901:	0f 89 79 ff ff ff    	jns    800880 <vprintfmt+0x3c>
				width = precision, precision = -1;
  800907:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80090a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80090d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800914:	e9 67 ff ff ff       	jmp    800880 <vprintfmt+0x3c>
  800919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091c:	85 c0                	test   %eax,%eax
  80091e:	ba 00 00 00 00       	mov    $0x0,%edx
  800923:	0f 49 d0             	cmovns %eax,%edx
  800926:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800929:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80092c:	e9 4f ff ff ff       	jmp    800880 <vprintfmt+0x3c>
  800931:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800934:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80093b:	e9 40 ff ff ff       	jmp    800880 <vprintfmt+0x3c>
			lflag++;
  800940:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800943:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800946:	e9 35 ff ff ff       	jmp    800880 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	8d 78 04             	lea    0x4(%eax),%edi
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	53                   	push   %ebx
  800955:	ff 30                	pushl  (%eax)
  800957:	ff d6                	call   *%esi
			break;
  800959:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80095c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80095f:	e9 a8 02 00 00       	jmp    800c0c <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	8d 78 04             	lea    0x4(%eax),%edi
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	99                   	cltd   
  80096d:	31 d0                	xor    %edx,%eax
  80096f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800971:	83 f8 0f             	cmp    $0xf,%eax
  800974:	7f 23                	jg     800999 <vprintfmt+0x155>
  800976:	8b 14 85 00 1c 80 00 	mov    0x801c00(,%eax,4),%edx
  80097d:	85 d2                	test   %edx,%edx
  80097f:	74 18                	je     800999 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  800981:	52                   	push   %edx
  800982:	68 e4 18 80 00       	push   $0x8018e4
  800987:	53                   	push   %ebx
  800988:	56                   	push   %esi
  800989:	e8 99 fe ff ff       	call   800827 <printfmt>
  80098e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800991:	89 7d 14             	mov    %edi,0x14(%ebp)
  800994:	e9 73 02 00 00       	jmp    800c0c <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  800999:	50                   	push   %eax
  80099a:	68 db 18 80 00       	push   $0x8018db
  80099f:	53                   	push   %ebx
  8009a0:	56                   	push   %esi
  8009a1:	e8 81 fe ff ff       	call   800827 <printfmt>
  8009a6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009a9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8009ac:	e9 5b 02 00 00       	jmp    800c0c <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  8009b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b4:	83 c0 04             	add    $0x4,%eax
  8009b7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	b8 d4 18 80 00       	mov    $0x8018d4,%eax
  8009c6:	0f 45 c2             	cmovne %edx,%eax
  8009c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8009cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d0:	7e 06                	jle    8009d8 <vprintfmt+0x194>
  8009d2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8009d6:	75 0d                	jne    8009e5 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009db:	89 c7                	mov    %eax,%edi
  8009dd:	03 45 e0             	add    -0x20(%ebp),%eax
  8009e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009e3:	eb 53                	jmp    800a38 <vprintfmt+0x1f4>
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8009eb:	50                   	push   %eax
  8009ec:	e8 13 04 00 00       	call   800e04 <strnlen>
  8009f1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009f4:	29 c1                	sub    %eax,%ecx
  8009f6:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8009fe:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a05:	eb 0f                	jmp    800a16 <vprintfmt+0x1d2>
					putch(padc, putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	53                   	push   %ebx
  800a0b:	ff 75 e0             	pushl  -0x20(%ebp)
  800a0e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a10:	83 ef 01             	sub    $0x1,%edi
  800a13:	83 c4 10             	add    $0x10,%esp
  800a16:	85 ff                	test   %edi,%edi
  800a18:	7f ed                	jg     800a07 <vprintfmt+0x1c3>
  800a1a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a1d:	85 d2                	test   %edx,%edx
  800a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a24:	0f 49 c2             	cmovns %edx,%eax
  800a27:	29 c2                	sub    %eax,%edx
  800a29:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800a2c:	eb aa                	jmp    8009d8 <vprintfmt+0x194>
					putch(ch, putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	53                   	push   %ebx
  800a32:	52                   	push   %edx
  800a33:	ff d6                	call   *%esi
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a3b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3d:	83 c7 01             	add    $0x1,%edi
  800a40:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a44:	0f be d0             	movsbl %al,%edx
  800a47:	85 d2                	test   %edx,%edx
  800a49:	74 4b                	je     800a96 <vprintfmt+0x252>
  800a4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a4f:	78 06                	js     800a57 <vprintfmt+0x213>
  800a51:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a55:	78 1e                	js     800a75 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  800a57:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a5b:	74 d1                	je     800a2e <vprintfmt+0x1ea>
  800a5d:	0f be c0             	movsbl %al,%eax
  800a60:	83 e8 20             	sub    $0x20,%eax
  800a63:	83 f8 5e             	cmp    $0x5e,%eax
  800a66:	76 c6                	jbe    800a2e <vprintfmt+0x1ea>
					putch('?', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	53                   	push   %ebx
  800a6c:	6a 3f                	push   $0x3f
  800a6e:	ff d6                	call   *%esi
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	eb c3                	jmp    800a38 <vprintfmt+0x1f4>
  800a75:	89 cf                	mov    %ecx,%edi
  800a77:	eb 0e                	jmp    800a87 <vprintfmt+0x243>
				putch(' ', putdat);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	53                   	push   %ebx
  800a7d:	6a 20                	push   $0x20
  800a7f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a81:	83 ef 01             	sub    $0x1,%edi
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	85 ff                	test   %edi,%edi
  800a89:	7f ee                	jg     800a79 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  800a8b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a91:	e9 76 01 00 00       	jmp    800c0c <vprintfmt+0x3c8>
  800a96:	89 cf                	mov    %ecx,%edi
  800a98:	eb ed                	jmp    800a87 <vprintfmt+0x243>
	if (lflag >= 2)
  800a9a:	83 f9 01             	cmp    $0x1,%ecx
  800a9d:	7f 1f                	jg     800abe <vprintfmt+0x27a>
	else if (lflag)
  800a9f:	85 c9                	test   %ecx,%ecx
  800aa1:	74 6a                	je     800b0d <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aab:	89 c1                	mov    %eax,%ecx
  800aad:	c1 f9 1f             	sar    $0x1f,%ecx
  800ab0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	8d 40 04             	lea    0x4(%eax),%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	eb 17                	jmp    800ad5 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	8b 50 04             	mov    0x4(%eax),%edx
  800ac4:	8b 00                	mov    (%eax),%eax
  800ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	8d 40 08             	lea    0x8(%eax),%eax
  800ad2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800ad5:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800ad8:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800add:	85 d2                	test   %edx,%edx
  800adf:	0f 89 f8 00 00 00    	jns    800bdd <vprintfmt+0x399>
				putch('-', putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	53                   	push   %ebx
  800ae9:	6a 2d                	push   $0x2d
  800aeb:	ff d6                	call   *%esi
				num = -(long long) num;
  800aed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800af3:	f7 d8                	neg    %eax
  800af5:	83 d2 00             	adc    $0x0,%edx
  800af8:	f7 da                	neg    %edx
  800afa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800afd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b00:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b03:	bf 0a 00 00 00       	mov    $0xa,%edi
  800b08:	e9 e1 00 00 00       	jmp    800bee <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b15:	99                   	cltd   
  800b16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	8d 40 04             	lea    0x4(%eax),%eax
  800b1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b22:	eb b1                	jmp    800ad5 <vprintfmt+0x291>
	if (lflag >= 2)
  800b24:	83 f9 01             	cmp    $0x1,%ecx
  800b27:	7f 27                	jg     800b50 <vprintfmt+0x30c>
	else if (lflag)
  800b29:	85 c9                	test   %ecx,%ecx
  800b2b:	74 41                	je     800b6e <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  800b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	ba 00 00 00 00       	mov    $0x0,%edx
  800b37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b3a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	8d 40 04             	lea    0x4(%eax),%eax
  800b43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b46:	bf 0a 00 00 00       	mov    $0xa,%edi
  800b4b:	e9 8d 00 00 00       	jmp    800bdd <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800b50:	8b 45 14             	mov    0x14(%ebp),%eax
  800b53:	8b 50 04             	mov    0x4(%eax),%edx
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	8d 40 08             	lea    0x8(%eax),%eax
  800b64:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b67:	bf 0a 00 00 00       	mov    $0xa,%edi
  800b6c:	eb 6f                	jmp    800bdd <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	ba 00 00 00 00       	mov    $0x0,%edx
  800b78:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b81:	8d 40 04             	lea    0x4(%eax),%eax
  800b84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b87:	bf 0a 00 00 00       	mov    $0xa,%edi
  800b8c:	eb 4f                	jmp    800bdd <vprintfmt+0x399>
	if (lflag >= 2)
  800b8e:	83 f9 01             	cmp    $0x1,%ecx
  800b91:	7f 23                	jg     800bb6 <vprintfmt+0x372>
	else if (lflag)
  800b93:	85 c9                	test   %ecx,%ecx
  800b95:	0f 84 98 00 00 00    	je     800c33 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  800b9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ba8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	8d 40 04             	lea    0x4(%eax),%eax
  800bb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	8b 50 04             	mov    0x4(%eax),%edx
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bc1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc7:	8d 40 08             	lea    0x8(%eax),%eax
  800bca:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	53                   	push   %ebx
  800bd1:	6a 30                	push   $0x30
  800bd3:	ff d6                	call   *%esi
			goto number;
  800bd5:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800bd8:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  800bdd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800be1:	74 0b                	je     800bee <vprintfmt+0x3aa>
				putch('+', putdat);
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	53                   	push   %ebx
  800be7:	6a 2b                	push   $0x2b
  800be9:	ff d6                	call   *%esi
  800beb:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800bee:	83 ec 0c             	sub    $0xc,%esp
  800bf1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800bf5:	50                   	push   %eax
  800bf6:	ff 75 e0             	pushl  -0x20(%ebp)
  800bf9:	57                   	push   %edi
  800bfa:	ff 75 dc             	pushl  -0x24(%ebp)
  800bfd:	ff 75 d8             	pushl  -0x28(%ebp)
  800c00:	89 da                	mov    %ebx,%edx
  800c02:	89 f0                	mov    %esi,%eax
  800c04:	e8 22 fb ff ff       	call   80072b <printnum>
			break;
  800c09:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800c0c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c0f:	83 c7 01             	add    $0x1,%edi
  800c12:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c16:	83 f8 25             	cmp    $0x25,%eax
  800c19:	0f 84 3c fc ff ff    	je     80085b <vprintfmt+0x17>
			if (ch == '\0')
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	0f 84 55 01 00 00    	je     800d7c <vprintfmt+0x538>
			putch(ch, putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	53                   	push   %ebx
  800c2b:	50                   	push   %eax
  800c2c:	ff d6                	call   *%esi
  800c2e:	83 c4 10             	add    $0x10,%esp
  800c31:	eb dc                	jmp    800c0f <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800c33:	8b 45 14             	mov    0x14(%ebp),%eax
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c40:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c43:	8b 45 14             	mov    0x14(%ebp),%eax
  800c46:	8d 40 04             	lea    0x4(%eax),%eax
  800c49:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4c:	e9 7c ff ff ff       	jmp    800bcd <vprintfmt+0x389>
			putch('0', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	53                   	push   %ebx
  800c55:	6a 30                	push   $0x30
  800c57:	ff d6                	call   *%esi
			putch('x', putdat);
  800c59:	83 c4 08             	add    $0x8,%esp
  800c5c:	53                   	push   %ebx
  800c5d:	6a 78                	push   $0x78
  800c5f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	8b 00                	mov    (%eax),%eax
  800c66:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c6e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800c71:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	8d 40 04             	lea    0x4(%eax),%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c7d:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  800c82:	e9 56 ff ff ff       	jmp    800bdd <vprintfmt+0x399>
	if (lflag >= 2)
  800c87:	83 f9 01             	cmp    $0x1,%ecx
  800c8a:	7f 27                	jg     800cb3 <vprintfmt+0x46f>
	else if (lflag)
  800c8c:	85 c9                	test   %ecx,%ecx
  800c8e:	74 44                	je     800cd4 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c9d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	8d 40 04             	lea    0x4(%eax),%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ca9:	bf 10 00 00 00       	mov    $0x10,%edi
  800cae:	e9 2a ff ff ff       	jmp    800bdd <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	8b 50 04             	mov    0x4(%eax),%edx
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cbe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc4:	8d 40 08             	lea    0x8(%eax),%eax
  800cc7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cca:	bf 10 00 00 00       	mov    $0x10,%edi
  800ccf:	e9 09 ff ff ff       	jmp    800bdd <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	8b 00                	mov    (%eax),%eax
  800cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cde:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ce1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce7:	8d 40 04             	lea    0x4(%eax),%eax
  800cea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ced:	bf 10 00 00 00       	mov    $0x10,%edi
  800cf2:	e9 e6 fe ff ff       	jmp    800bdd <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  800cf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfa:	8d 78 04             	lea    0x4(%eax),%edi
  800cfd:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  800cff:	85 c0                	test   %eax,%eax
  800d01:	74 2d                	je     800d30 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  800d03:	0f b6 13             	movzbl (%ebx),%edx
  800d06:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  800d08:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  800d0b:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800d0e:	0f 8e f8 fe ff ff    	jle    800c0c <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  800d14:	68 34 1a 80 00       	push   $0x801a34
  800d19:	68 e4 18 80 00       	push   $0x8018e4
  800d1e:	53                   	push   %ebx
  800d1f:	56                   	push   %esi
  800d20:	e8 02 fb ff ff       	call   800827 <printfmt>
  800d25:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800d28:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d2b:	e9 dc fe ff ff       	jmp    800c0c <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  800d30:	68 fc 19 80 00       	push   $0x8019fc
  800d35:	68 e4 18 80 00       	push   $0x8018e4
  800d3a:	53                   	push   %ebx
  800d3b:	56                   	push   %esi
  800d3c:	e8 e6 fa ff ff       	call   800827 <printfmt>
  800d41:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  800d44:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d47:	e9 c0 fe ff ff       	jmp    800c0c <vprintfmt+0x3c8>
			putch(ch, putdat);
  800d4c:	83 ec 08             	sub    $0x8,%esp
  800d4f:	53                   	push   %ebx
  800d50:	6a 25                	push   $0x25
  800d52:	ff d6                	call   *%esi
			break;
  800d54:	83 c4 10             	add    $0x10,%esp
  800d57:	e9 b0 fe ff ff       	jmp    800c0c <vprintfmt+0x3c8>
			putch('%', putdat);
  800d5c:	83 ec 08             	sub    $0x8,%esp
  800d5f:	53                   	push   %ebx
  800d60:	6a 25                	push   $0x25
  800d62:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d64:	83 c4 10             	add    $0x10,%esp
  800d67:	89 f8                	mov    %edi,%eax
  800d69:	eb 03                	jmp    800d6e <vprintfmt+0x52a>
  800d6b:	83 e8 01             	sub    $0x1,%eax
  800d6e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d72:	75 f7                	jne    800d6b <vprintfmt+0x527>
  800d74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d77:	e9 90 fe ff ff       	jmp    800c0c <vprintfmt+0x3c8>
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 18             	sub    $0x18,%esp
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d93:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d97:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	74 26                	je     800dcb <vsnprintf+0x47>
  800da5:	85 d2                	test   %edx,%edx
  800da7:	7e 22                	jle    800dcb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da9:	ff 75 14             	pushl  0x14(%ebp)
  800dac:	ff 75 10             	pushl  0x10(%ebp)
  800daf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800db2:	50                   	push   %eax
  800db3:	68 0a 08 80 00       	push   $0x80080a
  800db8:	e8 87 fa ff ff       	call   800844 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    
		return -E_INVAL;
  800dcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dd0:	eb f7                	jmp    800dc9 <vsnprintf+0x45>

00800dd2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dd8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ddb:	50                   	push   %eax
  800ddc:	ff 75 10             	pushl  0x10(%ebp)
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	ff 75 08             	pushl  0x8(%ebp)
  800de5:	e8 9a ff ff ff       	call   800d84 <vsnprintf>
	va_end(ap);

	return rc;
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800df2:	b8 00 00 00 00       	mov    $0x0,%eax
  800df7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800dfb:	74 05                	je     800e02 <strlen+0x16>
		n++;
  800dfd:	83 c0 01             	add    $0x1,%eax
  800e00:	eb f5                	jmp    800df7 <strlen+0xb>
	return n;
}
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e12:	39 c2                	cmp    %eax,%edx
  800e14:	74 0d                	je     800e23 <strnlen+0x1f>
  800e16:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800e1a:	74 05                	je     800e21 <strnlen+0x1d>
		n++;
  800e1c:	83 c2 01             	add    $0x1,%edx
  800e1f:	eb f1                	jmp    800e12 <strnlen+0xe>
  800e21:	89 d0                	mov    %edx,%eax
	return n;
}
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    

00800e25 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	53                   	push   %ebx
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800e2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e34:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800e38:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800e3b:	83 c2 01             	add    $0x1,%edx
  800e3e:	84 c9                	test   %cl,%cl
  800e40:	75 f2                	jne    800e34 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800e42:	5b                   	pop    %ebx
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	53                   	push   %ebx
  800e49:	83 ec 10             	sub    $0x10,%esp
  800e4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e4f:	53                   	push   %ebx
  800e50:	e8 97 ff ff ff       	call   800dec <strlen>
  800e55:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	01 d8                	add    %ebx,%eax
  800e5d:	50                   	push   %eax
  800e5e:	e8 c2 ff ff ff       	call   800e25 <strcpy>
	return dst;
}
  800e63:	89 d8                	mov    %ebx,%eax
  800e65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	89 c6                	mov    %eax,%esi
  800e77:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7a:	89 c2                	mov    %eax,%edx
  800e7c:	39 f2                	cmp    %esi,%edx
  800e7e:	74 11                	je     800e91 <strncpy+0x27>
		*dst++ = *src;
  800e80:	83 c2 01             	add    $0x1,%edx
  800e83:	0f b6 19             	movzbl (%ecx),%ebx
  800e86:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e89:	80 fb 01             	cmp    $0x1,%bl
  800e8c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e8f:	eb eb                	jmp    800e7c <strncpy+0x12>
	}
	return ret;
}
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	56                   	push   %esi
  800e99:	53                   	push   %ebx
  800e9a:	8b 75 08             	mov    0x8(%ebp),%esi
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	8b 55 10             	mov    0x10(%ebp),%edx
  800ea3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ea5:	85 d2                	test   %edx,%edx
  800ea7:	74 21                	je     800eca <strlcpy+0x35>
  800ea9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ead:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800eaf:	39 c2                	cmp    %eax,%edx
  800eb1:	74 14                	je     800ec7 <strlcpy+0x32>
  800eb3:	0f b6 19             	movzbl (%ecx),%ebx
  800eb6:	84 db                	test   %bl,%bl
  800eb8:	74 0b                	je     800ec5 <strlcpy+0x30>
			*dst++ = *src++;
  800eba:	83 c1 01             	add    $0x1,%ecx
  800ebd:	83 c2 01             	add    $0x1,%edx
  800ec0:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ec3:	eb ea                	jmp    800eaf <strlcpy+0x1a>
  800ec5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ec7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eca:	29 f0                	sub    %esi,%eax
}
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ed9:	0f b6 01             	movzbl (%ecx),%eax
  800edc:	84 c0                	test   %al,%al
  800ede:	74 0c                	je     800eec <strcmp+0x1c>
  800ee0:	3a 02                	cmp    (%edx),%al
  800ee2:	75 08                	jne    800eec <strcmp+0x1c>
		p++, q++;
  800ee4:	83 c1 01             	add    $0x1,%ecx
  800ee7:	83 c2 01             	add    $0x1,%edx
  800eea:	eb ed                	jmp    800ed9 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eec:	0f b6 c0             	movzbl %al,%eax
  800eef:	0f b6 12             	movzbl (%edx),%edx
  800ef2:	29 d0                	sub    %edx,%eax
}
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	53                   	push   %ebx
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f00:	89 c3                	mov    %eax,%ebx
  800f02:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f05:	eb 06                	jmp    800f0d <strncmp+0x17>
		n--, p++, q++;
  800f07:	83 c0 01             	add    $0x1,%eax
  800f0a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800f0d:	39 d8                	cmp    %ebx,%eax
  800f0f:	74 16                	je     800f27 <strncmp+0x31>
  800f11:	0f b6 08             	movzbl (%eax),%ecx
  800f14:	84 c9                	test   %cl,%cl
  800f16:	74 04                	je     800f1c <strncmp+0x26>
  800f18:	3a 0a                	cmp    (%edx),%cl
  800f1a:	74 eb                	je     800f07 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1c:	0f b6 00             	movzbl (%eax),%eax
  800f1f:	0f b6 12             	movzbl (%edx),%edx
  800f22:	29 d0                	sub    %edx,%eax
}
  800f24:	5b                   	pop    %ebx
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    
		return 0;
  800f27:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2c:	eb f6                	jmp    800f24 <strncmp+0x2e>

00800f2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f38:	0f b6 10             	movzbl (%eax),%edx
  800f3b:	84 d2                	test   %dl,%dl
  800f3d:	74 09                	je     800f48 <strchr+0x1a>
		if (*s == c)
  800f3f:	38 ca                	cmp    %cl,%dl
  800f41:	74 0a                	je     800f4d <strchr+0x1f>
	for (; *s; s++)
  800f43:	83 c0 01             	add    $0x1,%eax
  800f46:	eb f0                	jmp    800f38 <strchr+0xa>
			return (char *) s;
	return 0;
  800f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f59:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f5c:	38 ca                	cmp    %cl,%dl
  800f5e:	74 09                	je     800f69 <strfind+0x1a>
  800f60:	84 d2                	test   %dl,%dl
  800f62:	74 05                	je     800f69 <strfind+0x1a>
	for (; *s; s++)
  800f64:	83 c0 01             	add    $0x1,%eax
  800f67:	eb f0                	jmp    800f59 <strfind+0xa>
			break;
	return (char *) s;
}
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f74:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f77:	85 c9                	test   %ecx,%ecx
  800f79:	74 31                	je     800fac <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f7b:	89 f8                	mov    %edi,%eax
  800f7d:	09 c8                	or     %ecx,%eax
  800f7f:	a8 03                	test   $0x3,%al
  800f81:	75 23                	jne    800fa6 <memset+0x3b>
		c &= 0xFF;
  800f83:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f87:	89 d3                	mov    %edx,%ebx
  800f89:	c1 e3 08             	shl    $0x8,%ebx
  800f8c:	89 d0                	mov    %edx,%eax
  800f8e:	c1 e0 18             	shl    $0x18,%eax
  800f91:	89 d6                	mov    %edx,%esi
  800f93:	c1 e6 10             	shl    $0x10,%esi
  800f96:	09 f0                	or     %esi,%eax
  800f98:	09 c2                	or     %eax,%edx
  800f9a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f9c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f9f:	89 d0                	mov    %edx,%eax
  800fa1:	fc                   	cld    
  800fa2:	f3 ab                	rep stos %eax,%es:(%edi)
  800fa4:	eb 06                	jmp    800fac <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	fc                   	cld    
  800faa:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800fac:	89 f8                	mov    %edi,%eax
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	57                   	push   %edi
  800fb7:	56                   	push   %esi
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc1:	39 c6                	cmp    %eax,%esi
  800fc3:	73 32                	jae    800ff7 <memmove+0x44>
  800fc5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800fc8:	39 c2                	cmp    %eax,%edx
  800fca:	76 2b                	jbe    800ff7 <memmove+0x44>
		s += n;
		d += n;
  800fcc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fcf:	89 fe                	mov    %edi,%esi
  800fd1:	09 ce                	or     %ecx,%esi
  800fd3:	09 d6                	or     %edx,%esi
  800fd5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800fdb:	75 0e                	jne    800feb <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800fdd:	83 ef 04             	sub    $0x4,%edi
  800fe0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fe3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800fe6:	fd                   	std    
  800fe7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fe9:	eb 09                	jmp    800ff4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800feb:	83 ef 01             	sub    $0x1,%edi
  800fee:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ff1:	fd                   	std    
  800ff2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ff4:	fc                   	cld    
  800ff5:	eb 1a                	jmp    801011 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ff7:	89 c2                	mov    %eax,%edx
  800ff9:	09 ca                	or     %ecx,%edx
  800ffb:	09 f2                	or     %esi,%edx
  800ffd:	f6 c2 03             	test   $0x3,%dl
  801000:	75 0a                	jne    80100c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801002:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801005:	89 c7                	mov    %eax,%edi
  801007:	fc                   	cld    
  801008:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80100a:	eb 05                	jmp    801011 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80100c:	89 c7                	mov    %eax,%edi
  80100e:	fc                   	cld    
  80100f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80101b:	ff 75 10             	pushl  0x10(%ebp)
  80101e:	ff 75 0c             	pushl  0xc(%ebp)
  801021:	ff 75 08             	pushl  0x8(%ebp)
  801024:	e8 8a ff ff ff       	call   800fb3 <memmove>
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	89 c6                	mov    %eax,%esi
  801038:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80103b:	39 f0                	cmp    %esi,%eax
  80103d:	74 1c                	je     80105b <memcmp+0x30>
		if (*s1 != *s2)
  80103f:	0f b6 08             	movzbl (%eax),%ecx
  801042:	0f b6 1a             	movzbl (%edx),%ebx
  801045:	38 d9                	cmp    %bl,%cl
  801047:	75 08                	jne    801051 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801049:	83 c0 01             	add    $0x1,%eax
  80104c:	83 c2 01             	add    $0x1,%edx
  80104f:	eb ea                	jmp    80103b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801051:	0f b6 c1             	movzbl %cl,%eax
  801054:	0f b6 db             	movzbl %bl,%ebx
  801057:	29 d8                	sub    %ebx,%eax
  801059:	eb 05                	jmp    801060 <memcmp+0x35>
	}

	return 0;
  80105b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801060:	5b                   	pop    %ebx
  801061:	5e                   	pop    %esi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    

00801064 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80106d:	89 c2                	mov    %eax,%edx
  80106f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801072:	39 d0                	cmp    %edx,%eax
  801074:	73 09                	jae    80107f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801076:	38 08                	cmp    %cl,(%eax)
  801078:	74 05                	je     80107f <memfind+0x1b>
	for (; s < ends; s++)
  80107a:	83 c0 01             	add    $0x1,%eax
  80107d:	eb f3                	jmp    801072 <memfind+0xe>
			break;
	return (void *) s;
}
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	57                   	push   %edi
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
  801087:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108d:	eb 03                	jmp    801092 <strtol+0x11>
		s++;
  80108f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801092:	0f b6 01             	movzbl (%ecx),%eax
  801095:	3c 20                	cmp    $0x20,%al
  801097:	74 f6                	je     80108f <strtol+0xe>
  801099:	3c 09                	cmp    $0x9,%al
  80109b:	74 f2                	je     80108f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80109d:	3c 2b                	cmp    $0x2b,%al
  80109f:	74 2a                	je     8010cb <strtol+0x4a>
	int neg = 0;
  8010a1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8010a6:	3c 2d                	cmp    $0x2d,%al
  8010a8:	74 2b                	je     8010d5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010aa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8010b0:	75 0f                	jne    8010c1 <strtol+0x40>
  8010b2:	80 39 30             	cmpb   $0x30,(%ecx)
  8010b5:	74 28                	je     8010df <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010b7:	85 db                	test   %ebx,%ebx
  8010b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010be:	0f 44 d8             	cmove  %eax,%ebx
  8010c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8010c9:	eb 50                	jmp    80111b <strtol+0x9a>
		s++;
  8010cb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8010ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8010d3:	eb d5                	jmp    8010aa <strtol+0x29>
		s++, neg = 1;
  8010d5:	83 c1 01             	add    $0x1,%ecx
  8010d8:	bf 01 00 00 00       	mov    $0x1,%edi
  8010dd:	eb cb                	jmp    8010aa <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010df:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8010e3:	74 0e                	je     8010f3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8010e5:	85 db                	test   %ebx,%ebx
  8010e7:	75 d8                	jne    8010c1 <strtol+0x40>
		s++, base = 8;
  8010e9:	83 c1 01             	add    $0x1,%ecx
  8010ec:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010f1:	eb ce                	jmp    8010c1 <strtol+0x40>
		s += 2, base = 16;
  8010f3:	83 c1 02             	add    $0x2,%ecx
  8010f6:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010fb:	eb c4                	jmp    8010c1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8010fd:	8d 72 9f             	lea    -0x61(%edx),%esi
  801100:	89 f3                	mov    %esi,%ebx
  801102:	80 fb 19             	cmp    $0x19,%bl
  801105:	77 29                	ja     801130 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801107:	0f be d2             	movsbl %dl,%edx
  80110a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80110d:	3b 55 10             	cmp    0x10(%ebp),%edx
  801110:	7d 30                	jge    801142 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801112:	83 c1 01             	add    $0x1,%ecx
  801115:	0f af 45 10          	imul   0x10(%ebp),%eax
  801119:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80111b:	0f b6 11             	movzbl (%ecx),%edx
  80111e:	8d 72 d0             	lea    -0x30(%edx),%esi
  801121:	89 f3                	mov    %esi,%ebx
  801123:	80 fb 09             	cmp    $0x9,%bl
  801126:	77 d5                	ja     8010fd <strtol+0x7c>
			dig = *s - '0';
  801128:	0f be d2             	movsbl %dl,%edx
  80112b:	83 ea 30             	sub    $0x30,%edx
  80112e:	eb dd                	jmp    80110d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801130:	8d 72 bf             	lea    -0x41(%edx),%esi
  801133:	89 f3                	mov    %esi,%ebx
  801135:	80 fb 19             	cmp    $0x19,%bl
  801138:	77 08                	ja     801142 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80113a:	0f be d2             	movsbl %dl,%edx
  80113d:	83 ea 37             	sub    $0x37,%edx
  801140:	eb cb                	jmp    80110d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801142:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801146:	74 05                	je     80114d <strtol+0xcc>
		*endptr = (char *) s;
  801148:	8b 75 0c             	mov    0xc(%ebp),%esi
  80114b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80114d:	89 c2                	mov    %eax,%edx
  80114f:	f7 da                	neg    %edx
  801151:	85 ff                	test   %edi,%edi
  801153:	0f 45 c2             	cmovne %edx,%eax
}
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	57                   	push   %edi
  80115f:	56                   	push   %esi
  801160:	53                   	push   %ebx
	asm volatile("int %1\n"
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
  801166:	8b 55 08             	mov    0x8(%ebp),%edx
  801169:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116c:	89 c3                	mov    %eax,%ebx
  80116e:	89 c7                	mov    %eax,%edi
  801170:	89 c6                	mov    %eax,%esi
  801172:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801174:	5b                   	pop    %ebx
  801175:	5e                   	pop    %esi
  801176:	5f                   	pop    %edi
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <sys_cgetc>:

int
sys_cgetc(void)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	57                   	push   %edi
  80117d:	56                   	push   %esi
  80117e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80117f:	ba 00 00 00 00       	mov    $0x0,%edx
  801184:	b8 01 00 00 00       	mov    $0x1,%eax
  801189:	89 d1                	mov    %edx,%ecx
  80118b:	89 d3                	mov    %edx,%ebx
  80118d:	89 d7                	mov    %edx,%edi
  80118f:	89 d6                	mov    %edx,%esi
  801191:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801193:	5b                   	pop    %ebx
  801194:	5e                   	pop    %esi
  801195:	5f                   	pop    %edi
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	57                   	push   %edi
  80119c:	56                   	push   %esi
  80119d:	53                   	push   %ebx
  80119e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8011ae:	89 cb                	mov    %ecx,%ebx
  8011b0:	89 cf                	mov    %ecx,%edi
  8011b2:	89 ce                	mov    %ecx,%esi
  8011b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	7f 08                	jg     8011c2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011bd:	5b                   	pop    %ebx
  8011be:	5e                   	pop    %esi
  8011bf:	5f                   	pop    %edi
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c2:	83 ec 0c             	sub    $0xc,%esp
  8011c5:	50                   	push   %eax
  8011c6:	6a 03                	push   $0x3
  8011c8:	68 40 1c 80 00       	push   $0x801c40
  8011cd:	6a 33                	push   $0x33
  8011cf:	68 5d 1c 80 00       	push   $0x801c5d
  8011d4:	e8 63 f4 ff ff       	call   80063c <_panic>

008011d9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	57                   	push   %edi
  8011dd:	56                   	push   %esi
  8011de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011df:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e4:	b8 02 00 00 00       	mov    $0x2,%eax
  8011e9:	89 d1                	mov    %edx,%ecx
  8011eb:	89 d3                	mov    %edx,%ebx
  8011ed:	89 d7                	mov    %edx,%edi
  8011ef:	89 d6                	mov    %edx,%esi
  8011f1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011f3:	5b                   	pop    %ebx
  8011f4:	5e                   	pop    %esi
  8011f5:	5f                   	pop    %edi
  8011f6:	5d                   	pop    %ebp
  8011f7:	c3                   	ret    

008011f8 <sys_yield>:

void
sys_yield(void)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	57                   	push   %edi
  8011fc:	56                   	push   %esi
  8011fd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801203:	b8 0c 00 00 00       	mov    $0xc,%eax
  801208:	89 d1                	mov    %edx,%ecx
  80120a:	89 d3                	mov    %edx,%ebx
  80120c:	89 d7                	mov    %edx,%edi
  80120e:	89 d6                	mov    %edx,%esi
  801210:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801212:	5b                   	pop    %ebx
  801213:	5e                   	pop    %esi
  801214:	5f                   	pop    %edi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	57                   	push   %edi
  80121b:	56                   	push   %esi
  80121c:	53                   	push   %ebx
  80121d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801220:	be 00 00 00 00       	mov    $0x0,%esi
  801225:	8b 55 08             	mov    0x8(%ebp),%edx
  801228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122b:	b8 04 00 00 00       	mov    $0x4,%eax
  801230:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801233:	89 f7                	mov    %esi,%edi
  801235:	cd 30                	int    $0x30
	if(check && ret > 0)
  801237:	85 c0                	test   %eax,%eax
  801239:	7f 08                	jg     801243 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80123b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	50                   	push   %eax
  801247:	6a 04                	push   $0x4
  801249:	68 40 1c 80 00       	push   $0x801c40
  80124e:	6a 33                	push   $0x33
  801250:	68 5d 1c 80 00       	push   $0x801c5d
  801255:	e8 e2 f3 ff ff       	call   80063c <_panic>

0080125a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	57                   	push   %edi
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
  801260:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801263:	8b 55 08             	mov    0x8(%ebp),%edx
  801266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801269:	b8 05 00 00 00       	mov    $0x5,%eax
  80126e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801271:	8b 7d 14             	mov    0x14(%ebp),%edi
  801274:	8b 75 18             	mov    0x18(%ebp),%esi
  801277:	cd 30                	int    $0x30
	if(check && ret > 0)
  801279:	85 c0                	test   %eax,%eax
  80127b:	7f 08                	jg     801285 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80127d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801280:	5b                   	pop    %ebx
  801281:	5e                   	pop    %esi
  801282:	5f                   	pop    %edi
  801283:	5d                   	pop    %ebp
  801284:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	50                   	push   %eax
  801289:	6a 05                	push   $0x5
  80128b:	68 40 1c 80 00       	push   $0x801c40
  801290:	6a 33                	push   $0x33
  801292:	68 5d 1c 80 00       	push   $0x801c5d
  801297:	e8 a0 f3 ff ff       	call   80063c <_panic>

0080129c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b0:	b8 06 00 00 00       	mov    $0x6,%eax
  8012b5:	89 df                	mov    %ebx,%edi
  8012b7:	89 de                	mov    %ebx,%esi
  8012b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	7f 08                	jg     8012c7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c7:	83 ec 0c             	sub    $0xc,%esp
  8012ca:	50                   	push   %eax
  8012cb:	6a 06                	push   $0x6
  8012cd:	68 40 1c 80 00       	push   $0x801c40
  8012d2:	6a 33                	push   $0x33
  8012d4:	68 5d 1c 80 00       	push   $0x801c5d
  8012d9:	e8 5e f3 ff ff       	call   80063c <_panic>

008012de <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	57                   	push   %edi
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
  8012e4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ef:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012f4:	89 cb                	mov    %ecx,%ebx
  8012f6:	89 cf                	mov    %ecx,%edi
  8012f8:	89 ce                	mov    %ecx,%esi
  8012fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	7f 08                	jg     801308 <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  801300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801303:	5b                   	pop    %ebx
  801304:	5e                   	pop    %esi
  801305:	5f                   	pop    %edi
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	50                   	push   %eax
  80130c:	6a 0b                	push   $0xb
  80130e:	68 40 1c 80 00       	push   $0x801c40
  801313:	6a 33                	push   $0x33
  801315:	68 5d 1c 80 00       	push   $0x801c5d
  80131a:	e8 1d f3 ff ff       	call   80063c <_panic>

0080131f <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	57                   	push   %edi
  801323:	56                   	push   %esi
  801324:	53                   	push   %ebx
  801325:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801328:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132d:	8b 55 08             	mov    0x8(%ebp),%edx
  801330:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801333:	b8 08 00 00 00       	mov    $0x8,%eax
  801338:	89 df                	mov    %ebx,%edi
  80133a:	89 de                	mov    %ebx,%esi
  80133c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80133e:	85 c0                	test   %eax,%eax
  801340:	7f 08                	jg     80134a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5f                   	pop    %edi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80134a:	83 ec 0c             	sub    $0xc,%esp
  80134d:	50                   	push   %eax
  80134e:	6a 08                	push   $0x8
  801350:	68 40 1c 80 00       	push   $0x801c40
  801355:	6a 33                	push   $0x33
  801357:	68 5d 1c 80 00       	push   $0x801c5d
  80135c:	e8 db f2 ff ff       	call   80063c <_panic>

00801361 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	57                   	push   %edi
  801365:	56                   	push   %esi
  801366:	53                   	push   %ebx
  801367:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80136a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80136f:	8b 55 08             	mov    0x8(%ebp),%edx
  801372:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801375:	b8 09 00 00 00       	mov    $0x9,%eax
  80137a:	89 df                	mov    %ebx,%edi
  80137c:	89 de                	mov    %ebx,%esi
  80137e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801380:	85 c0                	test   %eax,%eax
  801382:	7f 08                	jg     80138c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801384:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5f                   	pop    %edi
  80138a:	5d                   	pop    %ebp
  80138b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	50                   	push   %eax
  801390:	6a 09                	push   $0x9
  801392:	68 40 1c 80 00       	push   $0x801c40
  801397:	6a 33                	push   $0x33
  801399:	68 5d 1c 80 00       	push   $0x801c5d
  80139e:	e8 99 f2 ff ff       	call   80063c <_panic>

008013a3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	57                   	push   %edi
  8013a7:	56                   	push   %esi
  8013a8:	53                   	push   %ebx
  8013a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013bc:	89 df                	mov    %ebx,%edi
  8013be:	89 de                	mov    %ebx,%esi
  8013c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	7f 08                	jg     8013ce <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c9:	5b                   	pop    %ebx
  8013ca:	5e                   	pop    %esi
  8013cb:	5f                   	pop    %edi
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ce:	83 ec 0c             	sub    $0xc,%esp
  8013d1:	50                   	push   %eax
  8013d2:	6a 0a                	push   $0xa
  8013d4:	68 40 1c 80 00       	push   $0x801c40
  8013d9:	6a 33                	push   $0x33
  8013db:	68 5d 1c 80 00       	push   $0x801c5d
  8013e0:	e8 57 f2 ff ff       	call   80063c <_panic>

008013e5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	57                   	push   %edi
  8013e9:	56                   	push   %esi
  8013ea:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f1:	b8 0d 00 00 00       	mov    $0xd,%eax
  8013f6:	be 00 00 00 00       	mov    $0x0,%esi
  8013fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013fe:	8b 7d 14             	mov    0x14(%ebp),%edi
  801401:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801403:	5b                   	pop    %ebx
  801404:	5e                   	pop    %esi
  801405:	5f                   	pop    %edi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	57                   	push   %edi
  80140c:	56                   	push   %esi
  80140d:	53                   	push   %ebx
  80140e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801411:	b9 00 00 00 00       	mov    $0x0,%ecx
  801416:	8b 55 08             	mov    0x8(%ebp),%edx
  801419:	b8 0e 00 00 00       	mov    $0xe,%eax
  80141e:	89 cb                	mov    %ecx,%ebx
  801420:	89 cf                	mov    %ecx,%edi
  801422:	89 ce                	mov    %ecx,%esi
  801424:	cd 30                	int    $0x30
	if(check && ret > 0)
  801426:	85 c0                	test   %eax,%eax
  801428:	7f 08                	jg     801432 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142d:	5b                   	pop    %ebx
  80142e:	5e                   	pop    %esi
  80142f:	5f                   	pop    %edi
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801432:	83 ec 0c             	sub    $0xc,%esp
  801435:	50                   	push   %eax
  801436:	6a 0e                	push   $0xe
  801438:	68 40 1c 80 00       	push   $0x801c40
  80143d:	6a 33                	push   $0x33
  80143f:	68 5d 1c 80 00       	push   $0x801c5d
  801444:	e8 f3 f1 ff ff       	call   80063c <_panic>

00801449 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	57                   	push   %edi
  80144d:	56                   	push   %esi
  80144e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80144f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801454:	8b 55 08             	mov    0x8(%ebp),%edx
  801457:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80145f:	89 df                	mov    %ebx,%edi
  801461:	89 de                	mov    %ebx,%esi
  801463:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801465:	5b                   	pop    %ebx
  801466:	5e                   	pop    %esi
  801467:	5f                   	pop    %edi
  801468:	5d                   	pop    %ebp
  801469:	c3                   	ret    

0080146a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	57                   	push   %edi
  80146e:	56                   	push   %esi
  80146f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801470:	b9 00 00 00 00       	mov    $0x0,%ecx
  801475:	8b 55 08             	mov    0x8(%ebp),%edx
  801478:	b8 10 00 00 00       	mov    $0x10,%eax
  80147d:	89 cb                	mov    %ecx,%ebx
  80147f:	89 cf                	mov    %ecx,%edi
  801481:	89 ce                	mov    %ecx,%esi
  801483:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801485:	5b                   	pop    %ebx
  801486:	5e                   	pop    %esi
  801487:	5f                   	pop    %edi
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    

0080148a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801490:	83 3d d0 20 80 00 00 	cmpl   $0x0,0x8020d0
  801497:	74 0a                	je     8014a3 <set_pgfault_handler+0x19>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
			panic("sys_env_set_pgfault_upcall: %e\n", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	a3 d0 20 80 00       	mov    %eax,0x8020d0
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    
		if((r = sys_page_alloc((envid_t) 0, (void*)(UXSTACKTOP-PGSIZE), PTE_U | PTE_P | PTE_W)) < 0 )
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	6a 07                	push   $0x7
  8014a8:	68 00 f0 bf ee       	push   $0xeebff000
  8014ad:	6a 00                	push   $0x0
  8014af:	e8 63 fd ff ff       	call   801217 <sys_page_alloc>
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 28                	js     8014e3 <set_pgfault_handler+0x59>
		if((r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall)) < 0)
  8014bb:	83 ec 08             	sub    $0x8,%esp
  8014be:	68 f5 14 80 00       	push   $0x8014f5
  8014c3:	6a 00                	push   $0x0
  8014c5:	e8 d9 fe ff ff       	call   8013a3 <sys_env_set_pgfault_upcall>
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	79 c8                	jns    801499 <set_pgfault_handler+0xf>
			panic("sys_env_set_pgfault_upcall: %e\n", r);
  8014d1:	50                   	push   %eax
  8014d2:	68 94 1c 80 00       	push   $0x801c94
  8014d7:	6a 23                	push   $0x23
  8014d9:	68 83 1c 80 00       	push   $0x801c83
  8014de:	e8 59 f1 ff ff       	call   80063c <_panic>
			panic("set_pgfault_handler %e\n",r);
  8014e3:	50                   	push   %eax
  8014e4:	68 6b 1c 80 00       	push   $0x801c6b
  8014e9:	6a 21                	push   $0x21
  8014eb:	68 83 1c 80 00       	push   $0x801c83
  8014f0:	e8 47 f1 ff ff       	call   80063c <_panic>

008014f5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014f5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014f6:	a1 d0 20 80 00       	mov    0x8020d0,%eax
	call *%eax
  8014fb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014fd:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx
  801500:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax
  801504:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  801508:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80150b:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80150d:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801511:	83 c4 08             	add    $0x8,%esp
	popal
  801514:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801515:	83 c4 04             	add    $0x4,%esp
	popfl
  801518:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801519:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80151a:	c3                   	ret    
  80151b:	66 90                	xchg   %ax,%ax
  80151d:	66 90                	xchg   %ax,%ax
  80151f:	90                   	nop

00801520 <__udivdi3>:
  801520:	55                   	push   %ebp
  801521:	57                   	push   %edi
  801522:	56                   	push   %esi
  801523:	53                   	push   %ebx
  801524:	83 ec 1c             	sub    $0x1c,%esp
  801527:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80152b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80152f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801533:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801537:	85 d2                	test   %edx,%edx
  801539:	75 4d                	jne    801588 <__udivdi3+0x68>
  80153b:	39 f3                	cmp    %esi,%ebx
  80153d:	76 19                	jbe    801558 <__udivdi3+0x38>
  80153f:	31 ff                	xor    %edi,%edi
  801541:	89 e8                	mov    %ebp,%eax
  801543:	89 f2                	mov    %esi,%edx
  801545:	f7 f3                	div    %ebx
  801547:	89 fa                	mov    %edi,%edx
  801549:	83 c4 1c             	add    $0x1c,%esp
  80154c:	5b                   	pop    %ebx
  80154d:	5e                   	pop    %esi
  80154e:	5f                   	pop    %edi
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    
  801551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801558:	89 d9                	mov    %ebx,%ecx
  80155a:	85 db                	test   %ebx,%ebx
  80155c:	75 0b                	jne    801569 <__udivdi3+0x49>
  80155e:	b8 01 00 00 00       	mov    $0x1,%eax
  801563:	31 d2                	xor    %edx,%edx
  801565:	f7 f3                	div    %ebx
  801567:	89 c1                	mov    %eax,%ecx
  801569:	31 d2                	xor    %edx,%edx
  80156b:	89 f0                	mov    %esi,%eax
  80156d:	f7 f1                	div    %ecx
  80156f:	89 c6                	mov    %eax,%esi
  801571:	89 e8                	mov    %ebp,%eax
  801573:	89 f7                	mov    %esi,%edi
  801575:	f7 f1                	div    %ecx
  801577:	89 fa                	mov    %edi,%edx
  801579:	83 c4 1c             	add    $0x1c,%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5f                   	pop    %edi
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    
  801581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801588:	39 f2                	cmp    %esi,%edx
  80158a:	77 1c                	ja     8015a8 <__udivdi3+0x88>
  80158c:	0f bd fa             	bsr    %edx,%edi
  80158f:	83 f7 1f             	xor    $0x1f,%edi
  801592:	75 2c                	jne    8015c0 <__udivdi3+0xa0>
  801594:	39 f2                	cmp    %esi,%edx
  801596:	72 06                	jb     80159e <__udivdi3+0x7e>
  801598:	31 c0                	xor    %eax,%eax
  80159a:	39 eb                	cmp    %ebp,%ebx
  80159c:	77 a9                	ja     801547 <__udivdi3+0x27>
  80159e:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a3:	eb a2                	jmp    801547 <__udivdi3+0x27>
  8015a5:	8d 76 00             	lea    0x0(%esi),%esi
  8015a8:	31 ff                	xor    %edi,%edi
  8015aa:	31 c0                	xor    %eax,%eax
  8015ac:	89 fa                	mov    %edi,%edx
  8015ae:	83 c4 1c             	add    $0x1c,%esp
  8015b1:	5b                   	pop    %ebx
  8015b2:	5e                   	pop    %esi
  8015b3:	5f                   	pop    %edi
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    
  8015b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015bd:	8d 76 00             	lea    0x0(%esi),%esi
  8015c0:	89 f9                	mov    %edi,%ecx
  8015c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8015c7:	29 f8                	sub    %edi,%eax
  8015c9:	d3 e2                	shl    %cl,%edx
  8015cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015cf:	89 c1                	mov    %eax,%ecx
  8015d1:	89 da                	mov    %ebx,%edx
  8015d3:	d3 ea                	shr    %cl,%edx
  8015d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015d9:	09 d1                	or     %edx,%ecx
  8015db:	89 f2                	mov    %esi,%edx
  8015dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015e1:	89 f9                	mov    %edi,%ecx
  8015e3:	d3 e3                	shl    %cl,%ebx
  8015e5:	89 c1                	mov    %eax,%ecx
  8015e7:	d3 ea                	shr    %cl,%edx
  8015e9:	89 f9                	mov    %edi,%ecx
  8015eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015ef:	89 eb                	mov    %ebp,%ebx
  8015f1:	d3 e6                	shl    %cl,%esi
  8015f3:	89 c1                	mov    %eax,%ecx
  8015f5:	d3 eb                	shr    %cl,%ebx
  8015f7:	09 de                	or     %ebx,%esi
  8015f9:	89 f0                	mov    %esi,%eax
  8015fb:	f7 74 24 08          	divl   0x8(%esp)
  8015ff:	89 d6                	mov    %edx,%esi
  801601:	89 c3                	mov    %eax,%ebx
  801603:	f7 64 24 0c          	mull   0xc(%esp)
  801607:	39 d6                	cmp    %edx,%esi
  801609:	72 15                	jb     801620 <__udivdi3+0x100>
  80160b:	89 f9                	mov    %edi,%ecx
  80160d:	d3 e5                	shl    %cl,%ebp
  80160f:	39 c5                	cmp    %eax,%ebp
  801611:	73 04                	jae    801617 <__udivdi3+0xf7>
  801613:	39 d6                	cmp    %edx,%esi
  801615:	74 09                	je     801620 <__udivdi3+0x100>
  801617:	89 d8                	mov    %ebx,%eax
  801619:	31 ff                	xor    %edi,%edi
  80161b:	e9 27 ff ff ff       	jmp    801547 <__udivdi3+0x27>
  801620:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801623:	31 ff                	xor    %edi,%edi
  801625:	e9 1d ff ff ff       	jmp    801547 <__udivdi3+0x27>
  80162a:	66 90                	xchg   %ax,%ax
  80162c:	66 90                	xchg   %ax,%ax
  80162e:	66 90                	xchg   %ax,%ax

00801630 <__umoddi3>:
  801630:	55                   	push   %ebp
  801631:	57                   	push   %edi
  801632:	56                   	push   %esi
  801633:	53                   	push   %ebx
  801634:	83 ec 1c             	sub    $0x1c,%esp
  801637:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80163b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80163f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801647:	89 da                	mov    %ebx,%edx
  801649:	85 c0                	test   %eax,%eax
  80164b:	75 43                	jne    801690 <__umoddi3+0x60>
  80164d:	39 df                	cmp    %ebx,%edi
  80164f:	76 17                	jbe    801668 <__umoddi3+0x38>
  801651:	89 f0                	mov    %esi,%eax
  801653:	f7 f7                	div    %edi
  801655:	89 d0                	mov    %edx,%eax
  801657:	31 d2                	xor    %edx,%edx
  801659:	83 c4 1c             	add    $0x1c,%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5f                   	pop    %edi
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    
  801661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801668:	89 fd                	mov    %edi,%ebp
  80166a:	85 ff                	test   %edi,%edi
  80166c:	75 0b                	jne    801679 <__umoddi3+0x49>
  80166e:	b8 01 00 00 00       	mov    $0x1,%eax
  801673:	31 d2                	xor    %edx,%edx
  801675:	f7 f7                	div    %edi
  801677:	89 c5                	mov    %eax,%ebp
  801679:	89 d8                	mov    %ebx,%eax
  80167b:	31 d2                	xor    %edx,%edx
  80167d:	f7 f5                	div    %ebp
  80167f:	89 f0                	mov    %esi,%eax
  801681:	f7 f5                	div    %ebp
  801683:	89 d0                	mov    %edx,%eax
  801685:	eb d0                	jmp    801657 <__umoddi3+0x27>
  801687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80168e:	66 90                	xchg   %ax,%ax
  801690:	89 f1                	mov    %esi,%ecx
  801692:	39 d8                	cmp    %ebx,%eax
  801694:	76 0a                	jbe    8016a0 <__umoddi3+0x70>
  801696:	89 f0                	mov    %esi,%eax
  801698:	83 c4 1c             	add    $0x1c,%esp
  80169b:	5b                   	pop    %ebx
  80169c:	5e                   	pop    %esi
  80169d:	5f                   	pop    %edi
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    
  8016a0:	0f bd e8             	bsr    %eax,%ebp
  8016a3:	83 f5 1f             	xor    $0x1f,%ebp
  8016a6:	75 20                	jne    8016c8 <__umoddi3+0x98>
  8016a8:	39 d8                	cmp    %ebx,%eax
  8016aa:	0f 82 b0 00 00 00    	jb     801760 <__umoddi3+0x130>
  8016b0:	39 f7                	cmp    %esi,%edi
  8016b2:	0f 86 a8 00 00 00    	jbe    801760 <__umoddi3+0x130>
  8016b8:	89 c8                	mov    %ecx,%eax
  8016ba:	83 c4 1c             	add    $0x1c,%esp
  8016bd:	5b                   	pop    %ebx
  8016be:	5e                   	pop    %esi
  8016bf:	5f                   	pop    %edi
  8016c0:	5d                   	pop    %ebp
  8016c1:	c3                   	ret    
  8016c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8016c8:	89 e9                	mov    %ebp,%ecx
  8016ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8016cf:	29 ea                	sub    %ebp,%edx
  8016d1:	d3 e0                	shl    %cl,%eax
  8016d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016d7:	89 d1                	mov    %edx,%ecx
  8016d9:	89 f8                	mov    %edi,%eax
  8016db:	d3 e8                	shr    %cl,%eax
  8016dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016e9:	09 c1                	or     %eax,%ecx
  8016eb:	89 d8                	mov    %ebx,%eax
  8016ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016f1:	89 e9                	mov    %ebp,%ecx
  8016f3:	d3 e7                	shl    %cl,%edi
  8016f5:	89 d1                	mov    %edx,%ecx
  8016f7:	d3 e8                	shr    %cl,%eax
  8016f9:	89 e9                	mov    %ebp,%ecx
  8016fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016ff:	d3 e3                	shl    %cl,%ebx
  801701:	89 c7                	mov    %eax,%edi
  801703:	89 d1                	mov    %edx,%ecx
  801705:	89 f0                	mov    %esi,%eax
  801707:	d3 e8                	shr    %cl,%eax
  801709:	89 e9                	mov    %ebp,%ecx
  80170b:	89 fa                	mov    %edi,%edx
  80170d:	d3 e6                	shl    %cl,%esi
  80170f:	09 d8                	or     %ebx,%eax
  801711:	f7 74 24 08          	divl   0x8(%esp)
  801715:	89 d1                	mov    %edx,%ecx
  801717:	89 f3                	mov    %esi,%ebx
  801719:	f7 64 24 0c          	mull   0xc(%esp)
  80171d:	89 c6                	mov    %eax,%esi
  80171f:	89 d7                	mov    %edx,%edi
  801721:	39 d1                	cmp    %edx,%ecx
  801723:	72 06                	jb     80172b <__umoddi3+0xfb>
  801725:	75 10                	jne    801737 <__umoddi3+0x107>
  801727:	39 c3                	cmp    %eax,%ebx
  801729:	73 0c                	jae    801737 <__umoddi3+0x107>
  80172b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80172f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801733:	89 d7                	mov    %edx,%edi
  801735:	89 c6                	mov    %eax,%esi
  801737:	89 ca                	mov    %ecx,%edx
  801739:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80173e:	29 f3                	sub    %esi,%ebx
  801740:	19 fa                	sbb    %edi,%edx
  801742:	89 d0                	mov    %edx,%eax
  801744:	d3 e0                	shl    %cl,%eax
  801746:	89 e9                	mov    %ebp,%ecx
  801748:	d3 eb                	shr    %cl,%ebx
  80174a:	d3 ea                	shr    %cl,%edx
  80174c:	09 d8                	or     %ebx,%eax
  80174e:	83 c4 1c             	add    $0x1c,%esp
  801751:	5b                   	pop    %ebx
  801752:	5e                   	pop    %esi
  801753:	5f                   	pop    %edi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    
  801756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80175d:	8d 76 00             	lea    0x0(%esi),%esi
  801760:	89 da                	mov    %ebx,%edx
  801762:	29 fe                	sub    %edi,%esi
  801764:	19 c2                	sbb    %eax,%edx
  801766:	89 f1                	mov    %esi,%ecx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	e9 4b ff ff ff       	jmp    8016ba <__umoddi3+0x8a>
