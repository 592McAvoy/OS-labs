# Lab3-answers

516030910101 罗宇辰

------

### Question 1

What is the purpose of having an individual handler function for each exception/interrupt?

因为有的exception/interrupt需要push error code，有的不用。所以不能使用同一个handler

### Question 2

Did you have to do anything to make the `user/softint` program behave correctly? The grade script expects it to produce a general protection fault (trap 13), but `softint`'s code says `int $14`. *Why* should this produce interrupt vector 13? What happens if the kernel actually allows `softint`'s `int $14`instruction to invoke the kernel's page fault handler (which is interrupt vector 14)?

由于在`trap_init`中：

```c
	SETGATE(idt[T_PGFLT  ],0,GD_KT,ENTRY_PGFLT  ,0); // dpl=0
```

所以user-mode是不能直接触发`trap 14`的，会因为权限检查失败而触发`trap 13`(general protection fault)，要想在user-mode触发`trap 14`，就要把`trap 14`的`dpl`(Descriptor Privilege Level)设置为3：

```c
	SETGATE(idt[T_PGFLT  ],0,GD_KT,ENTRY_PGFLT  ,3); // dpl=3
```

但是这样做就可能导致user频繁触发page fault，影响系统的性能，造成资源的浪费

### Question 3

The break point test case will either generate a break point exception or a general protection fault depending on how you initialized the break point entry in the IDT (i.e., your call to `SETGATE` from `trap_init`). Why? How do you need to set it up in order to get the breakpoint exception to work as specified above and what incorrect setup would cause it to trigger a general protection fault?

如果

```c
	SETGATE(idt[T_BRKPT  ],0,GD_KT,ENTRY_BRKPT  ,0);	// dpl=0
```

那么就会先触发`general protection fault`，因为`break point exception`的`dpl`是0(kernel-mode)

所以，要将`break point exception`的`dpl`设置为3(user-mode)

```c
	SETGATE(idt[T_BRKPT  ],0,GD_KT,ENTRY_BRKPT  ,3);	// dpl=3
```

### Question 4

What do you think is the point of these mechanisms, particularly in light of what the `user/softint` test program does?

关键在于exception/interrupt的触发权限，只有在正确的privilege level下才能正确处理中断