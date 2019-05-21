
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 60                	jmp    8000b5 <umain+0x82>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 c0 1f 80 00       	push   $0x801fc0
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 be 01 00 00       	call   800223 <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 01                	push   $0x1
  800087:	68 c3 1f 80 00       	push   $0x801fc3
  80008c:	6a 01                	push   $0x1
  80008e:	e8 fa 0a 00 00       	call   800b8d <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 9e 00 00 00       	call   80013f <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 de 0a 00 00       	call   800b8d <write>
	for (i = 1; i < argc; i++) {
  8000af:	83 c3 01             	add    $0x1,%ebx
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	39 df                	cmp    %ebx,%edi
  8000b7:	7e 07                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000b9:	83 fb 01             	cmp    $0x1,%ebx
  8000bc:	7f c4                	jg     800082 <umain+0x4f>
  8000be:	eb d6                	jmp    800096 <umain+0x63>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 d3 20 80 00       	push   $0x8020d3
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 ae 0a 00 00       	call   800b8d <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 38 04 00 00       	call   80052c <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	8d 04 c0             	lea    (%eax,%eax,8),%eax
  8000fc:	c1 e0 04             	shl    $0x4,%eax
  8000ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800104:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800109:	85 db                	test   %ebx,%ebx
  80010b:	7e 07                	jle    800114 <libmain+0x30>
		binaryname = argv[0];
  80010d:	8b 06                	mov    (%esi),%eax
  80010f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
  800119:	e8 15 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011e:	e8 0a 00 00 00       	call   80012d <exit>
}
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800129:	5b                   	pop    %ebx
  80012a:	5e                   	pop    %esi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    

0080012d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	83 ec 14             	sub    $0x14,%esp
	//close_all();
	sys_env_destroy(0);
  800133:	6a 00                	push   $0x0
  800135:	e8 b1 03 00 00       	call   8004eb <sys_env_destroy>
}
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    

0080013f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800145:	b8 00 00 00 00       	mov    $0x0,%eax
  80014a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80014e:	74 05                	je     800155 <strlen+0x16>
		n++;
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	eb f5                	jmp    80014a <strlen+0xb>
	return n;
}
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800160:	ba 00 00 00 00       	mov    $0x0,%edx
  800165:	39 c2                	cmp    %eax,%edx
  800167:	74 0d                	je     800176 <strnlen+0x1f>
  800169:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80016d:	74 05                	je     800174 <strnlen+0x1d>
		n++;
  80016f:	83 c2 01             	add    $0x1,%edx
  800172:	eb f1                	jmp    800165 <strnlen+0xe>
  800174:	89 d0                	mov    %edx,%eax
	return n;
}
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    

00800178 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	53                   	push   %ebx
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800182:	ba 00 00 00 00       	mov    $0x0,%edx
  800187:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80018b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80018e:	83 c2 01             	add    $0x1,%edx
  800191:	84 c9                	test   %cl,%cl
  800193:	75 f2                	jne    800187 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800195:	5b                   	pop    %ebx
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	53                   	push   %ebx
  80019c:	83 ec 10             	sub    $0x10,%esp
  80019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001a2:	53                   	push   %ebx
  8001a3:	e8 97 ff ff ff       	call   80013f <strlen>
  8001a8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8001ab:	ff 75 0c             	pushl  0xc(%ebp)
  8001ae:	01 d8                	add    %ebx,%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 c2 ff ff ff       	call   800178 <strcpy>
	return dst;
}
  8001b6:	89 d8                	mov    %ebx,%eax
  8001b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c8:	89 c6                	mov    %eax,%esi
  8001ca:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001cd:	89 c2                	mov    %eax,%edx
  8001cf:	39 f2                	cmp    %esi,%edx
  8001d1:	74 11                	je     8001e4 <strncpy+0x27>
		*dst++ = *src;
  8001d3:	83 c2 01             	add    $0x1,%edx
  8001d6:	0f b6 19             	movzbl (%ecx),%ebx
  8001d9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001dc:	80 fb 01             	cmp    $0x1,%bl
  8001df:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8001e2:	eb eb                	jmp    8001cf <strncpy+0x12>
	}
	return ret;
}
  8001e4:	5b                   	pop    %ebx
  8001e5:	5e                   	pop    %esi
  8001e6:	5d                   	pop    %ebp
  8001e7:	c3                   	ret    

008001e8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	56                   	push   %esi
  8001ec:	53                   	push   %ebx
  8001ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f3:	8b 55 10             	mov    0x10(%ebp),%edx
  8001f6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001f8:	85 d2                	test   %edx,%edx
  8001fa:	74 21                	je     80021d <strlcpy+0x35>
  8001fc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800200:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800202:	39 c2                	cmp    %eax,%edx
  800204:	74 14                	je     80021a <strlcpy+0x32>
  800206:	0f b6 19             	movzbl (%ecx),%ebx
  800209:	84 db                	test   %bl,%bl
  80020b:	74 0b                	je     800218 <strlcpy+0x30>
			*dst++ = *src++;
  80020d:	83 c1 01             	add    $0x1,%ecx
  800210:	83 c2 01             	add    $0x1,%edx
  800213:	88 5a ff             	mov    %bl,-0x1(%edx)
  800216:	eb ea                	jmp    800202 <strlcpy+0x1a>
  800218:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80021a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80021d:	29 f0                	sub    %esi,%eax
}
  80021f:	5b                   	pop    %ebx
  800220:	5e                   	pop    %esi
  800221:	5d                   	pop    %ebp
  800222:	c3                   	ret    

00800223 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800229:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80022c:	0f b6 01             	movzbl (%ecx),%eax
  80022f:	84 c0                	test   %al,%al
  800231:	74 0c                	je     80023f <strcmp+0x1c>
  800233:	3a 02                	cmp    (%edx),%al
  800235:	75 08                	jne    80023f <strcmp+0x1c>
		p++, q++;
  800237:	83 c1 01             	add    $0x1,%ecx
  80023a:	83 c2 01             	add    $0x1,%edx
  80023d:	eb ed                	jmp    80022c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80023f:	0f b6 c0             	movzbl %al,%eax
  800242:	0f b6 12             	movzbl (%edx),%edx
  800245:	29 d0                	sub    %edx,%eax
}
  800247:	5d                   	pop    %ebp
  800248:	c3                   	ret    

00800249 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	53                   	push   %ebx
  80024d:	8b 45 08             	mov    0x8(%ebp),%eax
  800250:	8b 55 0c             	mov    0xc(%ebp),%edx
  800253:	89 c3                	mov    %eax,%ebx
  800255:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800258:	eb 06                	jmp    800260 <strncmp+0x17>
		n--, p++, q++;
  80025a:	83 c0 01             	add    $0x1,%eax
  80025d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800260:	39 d8                	cmp    %ebx,%eax
  800262:	74 16                	je     80027a <strncmp+0x31>
  800264:	0f b6 08             	movzbl (%eax),%ecx
  800267:	84 c9                	test   %cl,%cl
  800269:	74 04                	je     80026f <strncmp+0x26>
  80026b:	3a 0a                	cmp    (%edx),%cl
  80026d:	74 eb                	je     80025a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80026f:	0f b6 00             	movzbl (%eax),%eax
  800272:	0f b6 12             	movzbl (%edx),%edx
  800275:	29 d0                	sub    %edx,%eax
}
  800277:	5b                   	pop    %ebx
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    
		return 0;
  80027a:	b8 00 00 00 00       	mov    $0x0,%eax
  80027f:	eb f6                	jmp    800277 <strncmp+0x2e>

00800281 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	8b 45 08             	mov    0x8(%ebp),%eax
  800287:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80028b:	0f b6 10             	movzbl (%eax),%edx
  80028e:	84 d2                	test   %dl,%dl
  800290:	74 09                	je     80029b <strchr+0x1a>
		if (*s == c)
  800292:	38 ca                	cmp    %cl,%dl
  800294:	74 0a                	je     8002a0 <strchr+0x1f>
	for (; *s; s++)
  800296:	83 c0 01             	add    $0x1,%eax
  800299:	eb f0                	jmp    80028b <strchr+0xa>
			return (char *) s;
	return 0;
  80029b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002a0:	5d                   	pop    %ebp
  8002a1:	c3                   	ret    

008002a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002ac:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002af:	38 ca                	cmp    %cl,%dl
  8002b1:	74 09                	je     8002bc <strfind+0x1a>
  8002b3:	84 d2                	test   %dl,%dl
  8002b5:	74 05                	je     8002bc <strfind+0x1a>
	for (; *s; s++)
  8002b7:	83 c0 01             	add    $0x1,%eax
  8002ba:	eb f0                	jmp    8002ac <strfind+0xa>
			break;
	return (char *) s;
}
  8002bc:	5d                   	pop    %ebp
  8002bd:	c3                   	ret    

008002be <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	57                   	push   %edi
  8002c2:	56                   	push   %esi
  8002c3:	53                   	push   %ebx
  8002c4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002ca:	85 c9                	test   %ecx,%ecx
  8002cc:	74 31                	je     8002ff <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002ce:	89 f8                	mov    %edi,%eax
  8002d0:	09 c8                	or     %ecx,%eax
  8002d2:	a8 03                	test   $0x3,%al
  8002d4:	75 23                	jne    8002f9 <memset+0x3b>
		c &= 0xFF;
  8002d6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002da:	89 d3                	mov    %edx,%ebx
  8002dc:	c1 e3 08             	shl    $0x8,%ebx
  8002df:	89 d0                	mov    %edx,%eax
  8002e1:	c1 e0 18             	shl    $0x18,%eax
  8002e4:	89 d6                	mov    %edx,%esi
  8002e6:	c1 e6 10             	shl    $0x10,%esi
  8002e9:	09 f0                	or     %esi,%eax
  8002eb:	09 c2                	or     %eax,%edx
  8002ed:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8002ef:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8002f2:	89 d0                	mov    %edx,%eax
  8002f4:	fc                   	cld    
  8002f5:	f3 ab                	rep stos %eax,%es:(%edi)
  8002f7:	eb 06                	jmp    8002ff <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fc:	fc                   	cld    
  8002fd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8002ff:	89 f8                	mov    %edi,%eax
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5f                   	pop    %edi
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800311:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800314:	39 c6                	cmp    %eax,%esi
  800316:	73 32                	jae    80034a <memmove+0x44>
  800318:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80031b:	39 c2                	cmp    %eax,%edx
  80031d:	76 2b                	jbe    80034a <memmove+0x44>
		s += n;
		d += n;
  80031f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800322:	89 fe                	mov    %edi,%esi
  800324:	09 ce                	or     %ecx,%esi
  800326:	09 d6                	or     %edx,%esi
  800328:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80032e:	75 0e                	jne    80033e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800330:	83 ef 04             	sub    $0x4,%edi
  800333:	8d 72 fc             	lea    -0x4(%edx),%esi
  800336:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800339:	fd                   	std    
  80033a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80033c:	eb 09                	jmp    800347 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80033e:	83 ef 01             	sub    $0x1,%edi
  800341:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800344:	fd                   	std    
  800345:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800347:	fc                   	cld    
  800348:	eb 1a                	jmp    800364 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	09 ca                	or     %ecx,%edx
  80034e:	09 f2                	or     %esi,%edx
  800350:	f6 c2 03             	test   $0x3,%dl
  800353:	75 0a                	jne    80035f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800355:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800358:	89 c7                	mov    %eax,%edi
  80035a:	fc                   	cld    
  80035b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80035d:	eb 05                	jmp    800364 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80035f:	89 c7                	mov    %eax,%edi
  800361:	fc                   	cld    
  800362:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800364:	5e                   	pop    %esi
  800365:	5f                   	pop    %edi
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    

00800368 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80036e:	ff 75 10             	pushl  0x10(%ebp)
  800371:	ff 75 0c             	pushl  0xc(%ebp)
  800374:	ff 75 08             	pushl  0x8(%ebp)
  800377:	e8 8a ff ff ff       	call   800306 <memmove>
}
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	56                   	push   %esi
  800382:	53                   	push   %ebx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	8b 55 0c             	mov    0xc(%ebp),%edx
  800389:	89 c6                	mov    %eax,%esi
  80038b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80038e:	39 f0                	cmp    %esi,%eax
  800390:	74 1c                	je     8003ae <memcmp+0x30>
		if (*s1 != *s2)
  800392:	0f b6 08             	movzbl (%eax),%ecx
  800395:	0f b6 1a             	movzbl (%edx),%ebx
  800398:	38 d9                	cmp    %bl,%cl
  80039a:	75 08                	jne    8003a4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80039c:	83 c0 01             	add    $0x1,%eax
  80039f:	83 c2 01             	add    $0x1,%edx
  8003a2:	eb ea                	jmp    80038e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8003a4:	0f b6 c1             	movzbl %cl,%eax
  8003a7:	0f b6 db             	movzbl %bl,%ebx
  8003aa:	29 d8                	sub    %ebx,%eax
  8003ac:	eb 05                	jmp    8003b3 <memcmp+0x35>
	}

	return 0;
  8003ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003b3:	5b                   	pop    %ebx
  8003b4:	5e                   	pop    %esi
  8003b5:	5d                   	pop    %ebp
  8003b6:	c3                   	ret    

008003b7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003c0:	89 c2                	mov    %eax,%edx
  8003c2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8003c5:	39 d0                	cmp    %edx,%eax
  8003c7:	73 09                	jae    8003d2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003c9:	38 08                	cmp    %cl,(%eax)
  8003cb:	74 05                	je     8003d2 <memfind+0x1b>
	for (; s < ends; s++)
  8003cd:	83 c0 01             	add    $0x1,%eax
  8003d0:	eb f3                	jmp    8003c5 <memfind+0xe>
			break;
	return (void *) s;
}
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	57                   	push   %edi
  8003d8:	56                   	push   %esi
  8003d9:	53                   	push   %ebx
  8003da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003e0:	eb 03                	jmp    8003e5 <strtol+0x11>
		s++;
  8003e2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8003e5:	0f b6 01             	movzbl (%ecx),%eax
  8003e8:	3c 20                	cmp    $0x20,%al
  8003ea:	74 f6                	je     8003e2 <strtol+0xe>
  8003ec:	3c 09                	cmp    $0x9,%al
  8003ee:	74 f2                	je     8003e2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8003f0:	3c 2b                	cmp    $0x2b,%al
  8003f2:	74 2a                	je     80041e <strtol+0x4a>
	int neg = 0;
  8003f4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8003f9:	3c 2d                	cmp    $0x2d,%al
  8003fb:	74 2b                	je     800428 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8003fd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800403:	75 0f                	jne    800414 <strtol+0x40>
  800405:	80 39 30             	cmpb   $0x30,(%ecx)
  800408:	74 28                	je     800432 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80040a:	85 db                	test   %ebx,%ebx
  80040c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800411:	0f 44 d8             	cmove  %eax,%ebx
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80041c:	eb 50                	jmp    80046e <strtol+0x9a>
		s++;
  80041e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800421:	bf 00 00 00 00       	mov    $0x0,%edi
  800426:	eb d5                	jmp    8003fd <strtol+0x29>
		s++, neg = 1;
  800428:	83 c1 01             	add    $0x1,%ecx
  80042b:	bf 01 00 00 00       	mov    $0x1,%edi
  800430:	eb cb                	jmp    8003fd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800432:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800436:	74 0e                	je     800446 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800438:	85 db                	test   %ebx,%ebx
  80043a:	75 d8                	jne    800414 <strtol+0x40>
		s++, base = 8;
  80043c:	83 c1 01             	add    $0x1,%ecx
  80043f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800444:	eb ce                	jmp    800414 <strtol+0x40>
		s += 2, base = 16;
  800446:	83 c1 02             	add    $0x2,%ecx
  800449:	bb 10 00 00 00       	mov    $0x10,%ebx
  80044e:	eb c4                	jmp    800414 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800450:	8d 72 9f             	lea    -0x61(%edx),%esi
  800453:	89 f3                	mov    %esi,%ebx
  800455:	80 fb 19             	cmp    $0x19,%bl
  800458:	77 29                	ja     800483 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80045a:	0f be d2             	movsbl %dl,%edx
  80045d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800460:	3b 55 10             	cmp    0x10(%ebp),%edx
  800463:	7d 30                	jge    800495 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800465:	83 c1 01             	add    $0x1,%ecx
  800468:	0f af 45 10          	imul   0x10(%ebp),%eax
  80046c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80046e:	0f b6 11             	movzbl (%ecx),%edx
  800471:	8d 72 d0             	lea    -0x30(%edx),%esi
  800474:	89 f3                	mov    %esi,%ebx
  800476:	80 fb 09             	cmp    $0x9,%bl
  800479:	77 d5                	ja     800450 <strtol+0x7c>
			dig = *s - '0';
  80047b:	0f be d2             	movsbl %dl,%edx
  80047e:	83 ea 30             	sub    $0x30,%edx
  800481:	eb dd                	jmp    800460 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800483:	8d 72 bf             	lea    -0x41(%edx),%esi
  800486:	89 f3                	mov    %esi,%ebx
  800488:	80 fb 19             	cmp    $0x19,%bl
  80048b:	77 08                	ja     800495 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80048d:	0f be d2             	movsbl %dl,%edx
  800490:	83 ea 37             	sub    $0x37,%edx
  800493:	eb cb                	jmp    800460 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800495:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800499:	74 05                	je     8004a0 <strtol+0xcc>
		*endptr = (char *) s;
  80049b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80049e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004a0:	89 c2                	mov    %eax,%edx
  8004a2:	f7 da                	neg    %edx
  8004a4:	85 ff                	test   %edi,%edi
  8004a6:	0f 45 c2             	cmovne %edx,%eax
}
  8004a9:	5b                   	pop    %ebx
  8004aa:	5e                   	pop    %esi
  8004ab:	5f                   	pop    %edi
  8004ac:	5d                   	pop    %ebp
  8004ad:	c3                   	ret    

008004ae <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	57                   	push   %edi
  8004b2:	56                   	push   %esi
  8004b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bf:	89 c3                	mov    %eax,%ebx
  8004c1:	89 c7                	mov    %eax,%edi
  8004c3:	89 c6                	mov    %eax,%esi
  8004c5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004c7:	5b                   	pop    %ebx
  8004c8:	5e                   	pop    %esi
  8004c9:	5f                   	pop    %edi
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    

008004cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	57                   	push   %edi
  8004d0:	56                   	push   %esi
  8004d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8004dc:	89 d1                	mov    %edx,%ecx
  8004de:	89 d3                	mov    %edx,%ebx
  8004e0:	89 d7                	mov    %edx,%edi
  8004e2:	89 d6                	mov    %edx,%esi
  8004e4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8004e6:	5b                   	pop    %ebx
  8004e7:	5e                   	pop    %esi
  8004e8:	5f                   	pop    %edi
  8004e9:	5d                   	pop    %ebp
  8004ea:	c3                   	ret    

008004eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	57                   	push   %edi
  8004ef:	56                   	push   %esi
  8004f0:	53                   	push   %ebx
  8004f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8004f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800501:	89 cb                	mov    %ecx,%ebx
  800503:	89 cf                	mov    %ecx,%edi
  800505:	89 ce                	mov    %ecx,%esi
  800507:	cd 30                	int    $0x30
	if(check && ret > 0)
  800509:	85 c0                	test   %eax,%eax
  80050b:	7f 08                	jg     800515 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80050d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800510:	5b                   	pop    %ebx
  800511:	5e                   	pop    %esi
  800512:	5f                   	pop    %edi
  800513:	5d                   	pop    %ebp
  800514:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800515:	83 ec 0c             	sub    $0xc,%esp
  800518:	50                   	push   %eax
  800519:	6a 03                	push   $0x3
  80051b:	68 cf 1f 80 00       	push   $0x801fcf
  800520:	6a 33                	push   $0x33
  800522:	68 ec 1f 80 00       	push   $0x801fec
  800527:	e8 60 0f 00 00       	call   80148c <_panic>

0080052c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	57                   	push   %edi
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
	asm volatile("int %1\n"
  800532:	ba 00 00 00 00       	mov    $0x0,%edx
  800537:	b8 02 00 00 00       	mov    $0x2,%eax
  80053c:	89 d1                	mov    %edx,%ecx
  80053e:	89 d3                	mov    %edx,%ebx
  800540:	89 d7                	mov    %edx,%edi
  800542:	89 d6                	mov    %edx,%esi
  800544:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800546:	5b                   	pop    %ebx
  800547:	5e                   	pop    %esi
  800548:	5f                   	pop    %edi
  800549:	5d                   	pop    %ebp
  80054a:	c3                   	ret    

0080054b <sys_yield>:

void
sys_yield(void)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	57                   	push   %edi
  80054f:	56                   	push   %esi
  800550:	53                   	push   %ebx
	asm volatile("int %1\n"
  800551:	ba 00 00 00 00       	mov    $0x0,%edx
  800556:	b8 0c 00 00 00       	mov    $0xc,%eax
  80055b:	89 d1                	mov    %edx,%ecx
  80055d:	89 d3                	mov    %edx,%ebx
  80055f:	89 d7                	mov    %edx,%edi
  800561:	89 d6                	mov    %edx,%esi
  800563:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800565:	5b                   	pop    %ebx
  800566:	5e                   	pop    %esi
  800567:	5f                   	pop    %edi
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    

0080056a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	57                   	push   %edi
  80056e:	56                   	push   %esi
  80056f:	53                   	push   %ebx
  800570:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800573:	be 00 00 00 00       	mov    $0x0,%esi
  800578:	8b 55 08             	mov    0x8(%ebp),%edx
  80057b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80057e:	b8 04 00 00 00       	mov    $0x4,%eax
  800583:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800586:	89 f7                	mov    %esi,%edi
  800588:	cd 30                	int    $0x30
	if(check && ret > 0)
  80058a:	85 c0                	test   %eax,%eax
  80058c:	7f 08                	jg     800596 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80058e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800591:	5b                   	pop    %ebx
  800592:	5e                   	pop    %esi
  800593:	5f                   	pop    %edi
  800594:	5d                   	pop    %ebp
  800595:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800596:	83 ec 0c             	sub    $0xc,%esp
  800599:	50                   	push   %eax
  80059a:	6a 04                	push   $0x4
  80059c:	68 cf 1f 80 00       	push   $0x801fcf
  8005a1:	6a 33                	push   $0x33
  8005a3:	68 ec 1f 80 00       	push   $0x801fec
  8005a8:	e8 df 0e 00 00       	call   80148c <_panic>

008005ad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	57                   	push   %edi
  8005b1:	56                   	push   %esi
  8005b2:	53                   	push   %ebx
  8005b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005bc:	b8 05 00 00 00       	mov    $0x5,%eax
  8005c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005c4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8005c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8005ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005cc:	85 c0                	test   %eax,%eax
  8005ce:	7f 08                	jg     8005d8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8005d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d3:	5b                   	pop    %ebx
  8005d4:	5e                   	pop    %esi
  8005d5:	5f                   	pop    %edi
  8005d6:	5d                   	pop    %ebp
  8005d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	6a 05                	push   $0x5
  8005de:	68 cf 1f 80 00       	push   $0x801fcf
  8005e3:	6a 33                	push   $0x33
  8005e5:	68 ec 1f 80 00       	push   $0x801fec
  8005ea:	e8 9d 0e 00 00       	call   80148c <_panic>

008005ef <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	57                   	push   %edi
  8005f3:	56                   	push   %esi
  8005f4:	53                   	push   %ebx
  8005f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800600:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800603:	b8 06 00 00 00       	mov    $0x6,%eax
  800608:	89 df                	mov    %ebx,%edi
  80060a:	89 de                	mov    %ebx,%esi
  80060c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80060e:	85 c0                	test   %eax,%eax
  800610:	7f 08                	jg     80061a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800612:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800615:	5b                   	pop    %ebx
  800616:	5e                   	pop    %esi
  800617:	5f                   	pop    %edi
  800618:	5d                   	pop    %ebp
  800619:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80061a:	83 ec 0c             	sub    $0xc,%esp
  80061d:	50                   	push   %eax
  80061e:	6a 06                	push   $0x6
  800620:	68 cf 1f 80 00       	push   $0x801fcf
  800625:	6a 33                	push   $0x33
  800627:	68 ec 1f 80 00       	push   $0x801fec
  80062c:	e8 5b 0e 00 00       	call   80148c <_panic>

00800631 <sys_env_swap>:

// sys_exofork is inlined in lib.h

int	
sys_env_swap(envid_t envid)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	57                   	push   %edi
  800635:	56                   	push   %esi
  800636:	53                   	push   %ebx
  800637:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80063a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063f:	8b 55 08             	mov    0x8(%ebp),%edx
  800642:	b8 0b 00 00 00       	mov    $0xb,%eax
  800647:	89 cb                	mov    %ecx,%ebx
  800649:	89 cf                	mov    %ecx,%edi
  80064b:	89 ce                	mov    %ecx,%esi
  80064d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80064f:	85 c0                	test   %eax,%eax
  800651:	7f 08                	jg     80065b <sys_env_swap+0x2a>
	return syscall(SYS_env_swap, 1, envid, 0, 0, 0, 0);
}
  800653:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800656:	5b                   	pop    %ebx
  800657:	5e                   	pop    %esi
  800658:	5f                   	pop    %edi
  800659:	5d                   	pop    %ebp
  80065a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80065b:	83 ec 0c             	sub    $0xc,%esp
  80065e:	50                   	push   %eax
  80065f:	6a 0b                	push   $0xb
  800661:	68 cf 1f 80 00       	push   $0x801fcf
  800666:	6a 33                	push   $0x33
  800668:	68 ec 1f 80 00       	push   $0x801fec
  80066d:	e8 1a 0e 00 00       	call   80148c <_panic>

00800672 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	57                   	push   %edi
  800676:	56                   	push   %esi
  800677:	53                   	push   %ebx
  800678:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 55 08             	mov    0x8(%ebp),%edx
  800683:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800686:	b8 08 00 00 00       	mov    $0x8,%eax
  80068b:	89 df                	mov    %ebx,%edi
  80068d:	89 de                	mov    %ebx,%esi
  80068f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800691:	85 c0                	test   %eax,%eax
  800693:	7f 08                	jg     80069d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800695:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800698:	5b                   	pop    %ebx
  800699:	5e                   	pop    %esi
  80069a:	5f                   	pop    %edi
  80069b:	5d                   	pop    %ebp
  80069c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80069d:	83 ec 0c             	sub    $0xc,%esp
  8006a0:	50                   	push   %eax
  8006a1:	6a 08                	push   $0x8
  8006a3:	68 cf 1f 80 00       	push   $0x801fcf
  8006a8:	6a 33                	push   $0x33
  8006aa:	68 ec 1f 80 00       	push   $0x801fec
  8006af:	e8 d8 0d 00 00       	call   80148c <_panic>

008006b4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	57                   	push   %edi
  8006b8:	56                   	push   %esi
  8006b9:	53                   	push   %ebx
  8006ba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c8:	b8 09 00 00 00       	mov    $0x9,%eax
  8006cd:	89 df                	mov    %ebx,%edi
  8006cf:	89 de                	mov    %ebx,%esi
  8006d1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006d3:	85 c0                	test   %eax,%eax
  8006d5:	7f 08                	jg     8006df <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8006d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006da:	5b                   	pop    %ebx
  8006db:	5e                   	pop    %esi
  8006dc:	5f                   	pop    %edi
  8006dd:	5d                   	pop    %ebp
  8006de:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006df:	83 ec 0c             	sub    $0xc,%esp
  8006e2:	50                   	push   %eax
  8006e3:	6a 09                	push   $0x9
  8006e5:	68 cf 1f 80 00       	push   $0x801fcf
  8006ea:	6a 33                	push   $0x33
  8006ec:	68 ec 1f 80 00       	push   $0x801fec
  8006f1:	e8 96 0d 00 00       	call   80148c <_panic>

008006f6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	57                   	push   %edi
  8006fa:	56                   	push   %esi
  8006fb:	53                   	push   %ebx
  8006fc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800704:	8b 55 08             	mov    0x8(%ebp),%edx
  800707:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80070a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070f:	89 df                	mov    %ebx,%edi
  800711:	89 de                	mov    %ebx,%esi
  800713:	cd 30                	int    $0x30
	if(check && ret > 0)
  800715:	85 c0                	test   %eax,%eax
  800717:	7f 08                	jg     800721 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800719:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071c:	5b                   	pop    %ebx
  80071d:	5e                   	pop    %esi
  80071e:	5f                   	pop    %edi
  80071f:	5d                   	pop    %ebp
  800720:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	50                   	push   %eax
  800725:	6a 0a                	push   $0xa
  800727:	68 cf 1f 80 00       	push   $0x801fcf
  80072c:	6a 33                	push   $0x33
  80072e:	68 ec 1f 80 00       	push   $0x801fec
  800733:	e8 54 0d 00 00       	call   80148c <_panic>

00800738 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	57                   	push   %edi
  80073c:	56                   	push   %esi
  80073d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80073e:	8b 55 08             	mov    0x8(%ebp),%edx
  800741:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800744:	b8 0d 00 00 00       	mov    $0xd,%eax
  800749:	be 00 00 00 00       	mov    $0x0,%esi
  80074e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800751:	8b 7d 14             	mov    0x14(%ebp),%edi
  800754:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800756:	5b                   	pop    %ebx
  800757:	5e                   	pop    %esi
  800758:	5f                   	pop    %edi
  800759:	5d                   	pop    %ebp
  80075a:	c3                   	ret    

0080075b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	57                   	push   %edi
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800764:	b9 00 00 00 00       	mov    $0x0,%ecx
  800769:	8b 55 08             	mov    0x8(%ebp),%edx
  80076c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800771:	89 cb                	mov    %ecx,%ebx
  800773:	89 cf                	mov    %ecx,%edi
  800775:	89 ce                	mov    %ecx,%esi
  800777:	cd 30                	int    $0x30
	if(check && ret > 0)
  800779:	85 c0                	test   %eax,%eax
  80077b:	7f 08                	jg     800785 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80077d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800780:	5b                   	pop    %ebx
  800781:	5e                   	pop    %esi
  800782:	5f                   	pop    %edi
  800783:	5d                   	pop    %ebp
  800784:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800785:	83 ec 0c             	sub    $0xc,%esp
  800788:	50                   	push   %eax
  800789:	6a 0e                	push   $0xe
  80078b:	68 cf 1f 80 00       	push   $0x801fcf
  800790:	6a 33                	push   $0x33
  800792:	68 ec 1f 80 00       	push   $0x801fec
  800797:	e8 f0 0c 00 00       	call   80148c <_panic>

0080079c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	57                   	push   %edi
  8007a0:	56                   	push   %esi
  8007a1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8007a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8007aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ad:	b8 0f 00 00 00       	mov    $0xf,%eax
  8007b2:	89 df                	mov    %ebx,%edi
  8007b4:	89 de                	mov    %ebx,%esi
  8007b6:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8007b8:	5b                   	pop    %ebx
  8007b9:	5e                   	pop    %esi
  8007ba:	5f                   	pop    %edi
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	57                   	push   %edi
  8007c1:	56                   	push   %esi
  8007c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8007c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8007cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d0:	89 cb                	mov    %ecx,%ebx
  8007d2:	89 cf                	mov    %ecx,%edi
  8007d4:	89 ce                	mov    %ecx,%esi
  8007d6:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8007d8:	5b                   	pop    %ebx
  8007d9:	5e                   	pop    %esi
  8007da:	5f                   	pop    %edi
  8007db:	5d                   	pop    %ebp
  8007dc:	c3                   	ret    

008007dd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	05 00 00 00 30       	add    $0x30000000,%eax
  8007e8:	c1 e8 0c             	shr    $0xc,%eax
}
  8007eb:	5d                   	pop    %ebp
  8007ec:	c3                   	ret    

008007ed <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8007f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007fd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80080c:	89 c2                	mov    %eax,%edx
  80080e:	c1 ea 16             	shr    $0x16,%edx
  800811:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800818:	f6 c2 01             	test   $0x1,%dl
  80081b:	74 2d                	je     80084a <fd_alloc+0x46>
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	c1 ea 0c             	shr    $0xc,%edx
  800822:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800829:	f6 c2 01             	test   $0x1,%dl
  80082c:	74 1c                	je     80084a <fd_alloc+0x46>
  80082e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800833:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800838:	75 d2                	jne    80080c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800843:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800848:	eb 0a                	jmp    800854 <fd_alloc+0x50>
			*fd_store = fd;
  80084a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80084f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80085c:	83 f8 1f             	cmp    $0x1f,%eax
  80085f:	77 30                	ja     800891 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800861:	c1 e0 0c             	shl    $0xc,%eax
  800864:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800869:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80086f:	f6 c2 01             	test   $0x1,%dl
  800872:	74 24                	je     800898 <fd_lookup+0x42>
  800874:	89 c2                	mov    %eax,%edx
  800876:	c1 ea 0c             	shr    $0xc,%edx
  800879:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800880:	f6 c2 01             	test   $0x1,%dl
  800883:	74 1a                	je     80089f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800885:	8b 55 0c             	mov    0xc(%ebp),%edx
  800888:	89 02                	mov    %eax,(%edx)
	return 0;
  80088a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    
		return -E_INVAL;
  800891:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800896:	eb f7                	jmp    80088f <fd_lookup+0x39>
		return -E_INVAL;
  800898:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80089d:	eb f0                	jmp    80088f <fd_lookup+0x39>
  80089f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a4:	eb e9                	jmp    80088f <fd_lookup+0x39>

008008a6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008af:	ba 78 20 80 00       	mov    $0x802078,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8008b4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8008b9:	39 08                	cmp    %ecx,(%eax)
  8008bb:	74 33                	je     8008f0 <dev_lookup+0x4a>
  8008bd:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8008c0:	8b 02                	mov    (%edx),%eax
  8008c2:	85 c0                	test   %eax,%eax
  8008c4:	75 f3                	jne    8008b9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8008cb:	8b 40 48             	mov    0x48(%eax),%eax
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	51                   	push   %ecx
  8008d2:	50                   	push   %eax
  8008d3:	68 fc 1f 80 00       	push   $0x801ffc
  8008d8:	e8 8a 0c 00 00       	call   801567 <cprintf>
	*dev = 0;
  8008dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    
			*dev = devtab[i];
  8008f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8008f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fa:	eb f2                	jmp    8008ee <dev_lookup+0x48>

008008fc <fd_close>:
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	57                   	push   %edi
  800900:	56                   	push   %esi
  800901:	53                   	push   %ebx
  800902:	83 ec 24             	sub    $0x24,%esp
  800905:	8b 75 08             	mov    0x8(%ebp),%esi
  800908:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80090b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80090e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80090f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800915:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800918:	50                   	push   %eax
  800919:	e8 38 ff ff ff       	call   800856 <fd_lookup>
  80091e:	89 c3                	mov    %eax,%ebx
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	85 c0                	test   %eax,%eax
  800925:	78 05                	js     80092c <fd_close+0x30>
	    || fd != fd2)
  800927:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80092a:	74 16                	je     800942 <fd_close+0x46>
		return (must_exist ? r : 0);
  80092c:	89 f8                	mov    %edi,%eax
  80092e:	84 c0                	test   %al,%al
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
  800935:	0f 44 d8             	cmove  %eax,%ebx
}
  800938:	89 d8                	mov    %ebx,%eax
  80093a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80093d:	5b                   	pop    %ebx
  80093e:	5e                   	pop    %esi
  80093f:	5f                   	pop    %edi
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800948:	50                   	push   %eax
  800949:	ff 36                	pushl  (%esi)
  80094b:	e8 56 ff ff ff       	call   8008a6 <dev_lookup>
  800950:	89 c3                	mov    %eax,%ebx
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	85 c0                	test   %eax,%eax
  800957:	78 1a                	js     800973 <fd_close+0x77>
		if (dev->dev_close)
  800959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80095c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80095f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800964:	85 c0                	test   %eax,%eax
  800966:	74 0b                	je     800973 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800968:	83 ec 0c             	sub    $0xc,%esp
  80096b:	56                   	push   %esi
  80096c:	ff d0                	call   *%eax
  80096e:	89 c3                	mov    %eax,%ebx
  800970:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	56                   	push   %esi
  800977:	6a 00                	push   $0x0
  800979:	e8 71 fc ff ff       	call   8005ef <sys_page_unmap>
	return r;
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	eb b5                	jmp    800938 <fd_close+0x3c>

00800983 <close>:

int
close(int fdnum)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800989:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80098c:	50                   	push   %eax
  80098d:	ff 75 08             	pushl  0x8(%ebp)
  800990:	e8 c1 fe ff ff       	call   800856 <fd_lookup>
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	85 c0                	test   %eax,%eax
  80099a:	79 02                	jns    80099e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    
		return fd_close(fd, 1);
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	6a 01                	push   $0x1
  8009a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a6:	e8 51 ff ff ff       	call   8008fc <fd_close>
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	eb ec                	jmp    80099c <close+0x19>

008009b0 <close_all>:

void
close_all(void)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	53                   	push   %ebx
  8009b4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8009b7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8009bc:	83 ec 0c             	sub    $0xc,%esp
  8009bf:	53                   	push   %ebx
  8009c0:	e8 be ff ff ff       	call   800983 <close>
	for (i = 0; i < MAXFD; i++)
  8009c5:	83 c3 01             	add    $0x1,%ebx
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	83 fb 20             	cmp    $0x20,%ebx
  8009ce:	75 ec                	jne    8009bc <close_all+0xc>
}
  8009d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	57                   	push   %edi
  8009d9:	56                   	push   %esi
  8009da:	53                   	push   %ebx
  8009db:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8009e1:	50                   	push   %eax
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	e8 6c fe ff ff       	call   800856 <fd_lookup>
  8009ea:	89 c3                	mov    %eax,%ebx
  8009ec:	83 c4 10             	add    $0x10,%esp
  8009ef:	85 c0                	test   %eax,%eax
  8009f1:	0f 88 81 00 00 00    	js     800a78 <dup+0xa3>
		return r;
	close(newfdnum);
  8009f7:	83 ec 0c             	sub    $0xc,%esp
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	e8 81 ff ff ff       	call   800983 <close>

	newfd = INDEX2FD(newfdnum);
  800a02:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a05:	c1 e6 0c             	shl    $0xc,%esi
  800a08:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800a0e:	83 c4 04             	add    $0x4,%esp
  800a11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a14:	e8 d4 fd ff ff       	call   8007ed <fd2data>
  800a19:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800a1b:	89 34 24             	mov    %esi,(%esp)
  800a1e:	e8 ca fd ff ff       	call   8007ed <fd2data>
  800a23:	83 c4 10             	add    $0x10,%esp
  800a26:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a28:	89 d8                	mov    %ebx,%eax
  800a2a:	c1 e8 16             	shr    $0x16,%eax
  800a2d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800a34:	a8 01                	test   $0x1,%al
  800a36:	74 11                	je     800a49 <dup+0x74>
  800a38:	89 d8                	mov    %ebx,%eax
  800a3a:	c1 e8 0c             	shr    $0xc,%eax
  800a3d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800a44:	f6 c2 01             	test   $0x1,%dl
  800a47:	75 39                	jne    800a82 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a4c:	89 d0                	mov    %edx,%eax
  800a4e:	c1 e8 0c             	shr    $0xc,%eax
  800a51:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a58:	83 ec 0c             	sub    $0xc,%esp
  800a5b:	25 07 0e 00 00       	and    $0xe07,%eax
  800a60:	50                   	push   %eax
  800a61:	56                   	push   %esi
  800a62:	6a 00                	push   $0x0
  800a64:	52                   	push   %edx
  800a65:	6a 00                	push   $0x0
  800a67:	e8 41 fb ff ff       	call   8005ad <sys_page_map>
  800a6c:	89 c3                	mov    %eax,%ebx
  800a6e:	83 c4 20             	add    $0x20,%esp
  800a71:	85 c0                	test   %eax,%eax
  800a73:	78 31                	js     800aa6 <dup+0xd1>
		goto err;

	return newfdnum;
  800a75:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a78:	89 d8                	mov    %ebx,%eax
  800a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a7d:	5b                   	pop    %ebx
  800a7e:	5e                   	pop    %esi
  800a7f:	5f                   	pop    %edi
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a82:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a89:	83 ec 0c             	sub    $0xc,%esp
  800a8c:	25 07 0e 00 00       	and    $0xe07,%eax
  800a91:	50                   	push   %eax
  800a92:	57                   	push   %edi
  800a93:	6a 00                	push   $0x0
  800a95:	53                   	push   %ebx
  800a96:	6a 00                	push   $0x0
  800a98:	e8 10 fb ff ff       	call   8005ad <sys_page_map>
  800a9d:	89 c3                	mov    %eax,%ebx
  800a9f:	83 c4 20             	add    $0x20,%esp
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	79 a3                	jns    800a49 <dup+0x74>
	sys_page_unmap(0, newfd);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	56                   	push   %esi
  800aaa:	6a 00                	push   $0x0
  800aac:	e8 3e fb ff ff       	call   8005ef <sys_page_unmap>
	sys_page_unmap(0, nva);
  800ab1:	83 c4 08             	add    $0x8,%esp
  800ab4:	57                   	push   %edi
  800ab5:	6a 00                	push   $0x0
  800ab7:	e8 33 fb ff ff       	call   8005ef <sys_page_unmap>
	return r;
  800abc:	83 c4 10             	add    $0x10,%esp
  800abf:	eb b7                	jmp    800a78 <dup+0xa3>

00800ac1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	53                   	push   %ebx
  800ac5:	83 ec 1c             	sub    $0x1c,%esp
  800ac8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800acb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	53                   	push   %ebx
  800ad0:	e8 81 fd ff ff       	call   800856 <fd_lookup>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	85 c0                	test   %eax,%eax
  800ada:	78 3f                	js     800b1b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ae2:	50                   	push   %eax
  800ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae6:	ff 30                	pushl  (%eax)
  800ae8:	e8 b9 fd ff ff       	call   8008a6 <dev_lookup>
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	85 c0                	test   %eax,%eax
  800af2:	78 27                	js     800b1b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800af4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800af7:	8b 42 08             	mov    0x8(%edx),%eax
  800afa:	83 e0 03             	and    $0x3,%eax
  800afd:	83 f8 01             	cmp    $0x1,%eax
  800b00:	74 1e                	je     800b20 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b05:	8b 40 08             	mov    0x8(%eax),%eax
  800b08:	85 c0                	test   %eax,%eax
  800b0a:	74 35                	je     800b41 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800b0c:	83 ec 04             	sub    $0x4,%esp
  800b0f:	ff 75 10             	pushl  0x10(%ebp)
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	52                   	push   %edx
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b20:	a1 04 40 80 00       	mov    0x804004,%eax
  800b25:	8b 40 48             	mov    0x48(%eax),%eax
  800b28:	83 ec 04             	sub    $0x4,%esp
  800b2b:	53                   	push   %ebx
  800b2c:	50                   	push   %eax
  800b2d:	68 3d 20 80 00       	push   $0x80203d
  800b32:	e8 30 0a 00 00       	call   801567 <cprintf>
		return -E_INVAL;
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b3f:	eb da                	jmp    800b1b <read+0x5a>
		return -E_NOT_SUPP;
  800b41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b46:	eb d3                	jmp    800b1b <read+0x5a>

00800b48 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	57                   	push   %edi
  800b4c:	56                   	push   %esi
  800b4d:	53                   	push   %ebx
  800b4e:	83 ec 0c             	sub    $0xc,%esp
  800b51:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b54:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b5c:	39 f3                	cmp    %esi,%ebx
  800b5e:	73 23                	jae    800b83 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b60:	83 ec 04             	sub    $0x4,%esp
  800b63:	89 f0                	mov    %esi,%eax
  800b65:	29 d8                	sub    %ebx,%eax
  800b67:	50                   	push   %eax
  800b68:	89 d8                	mov    %ebx,%eax
  800b6a:	03 45 0c             	add    0xc(%ebp),%eax
  800b6d:	50                   	push   %eax
  800b6e:	57                   	push   %edi
  800b6f:	e8 4d ff ff ff       	call   800ac1 <read>
		if (m < 0)
  800b74:	83 c4 10             	add    $0x10,%esp
  800b77:	85 c0                	test   %eax,%eax
  800b79:	78 06                	js     800b81 <readn+0x39>
			return m;
		if (m == 0)
  800b7b:	74 06                	je     800b83 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  800b7d:	01 c3                	add    %eax,%ebx
  800b7f:	eb db                	jmp    800b5c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b81:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b83:	89 d8                	mov    %ebx,%eax
  800b85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	53                   	push   %ebx
  800b91:	83 ec 1c             	sub    $0x1c,%esp
  800b94:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b97:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b9a:	50                   	push   %eax
  800b9b:	53                   	push   %ebx
  800b9c:	e8 b5 fc ff ff       	call   800856 <fd_lookup>
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	78 3a                	js     800be2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ba8:	83 ec 08             	sub    $0x8,%esp
  800bab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb2:	ff 30                	pushl  (%eax)
  800bb4:	e8 ed fc ff ff       	call   8008a6 <dev_lookup>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	85 c0                	test   %eax,%eax
  800bbe:	78 22                	js     800be2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800bc7:	74 1e                	je     800be7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcc:	8b 52 0c             	mov    0xc(%edx),%edx
  800bcf:	85 d2                	test   %edx,%edx
  800bd1:	74 35                	je     800c08 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	ff 75 10             	pushl  0x10(%ebp)
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff d2                	call   *%edx
  800bdf:	83 c4 10             	add    $0x10,%esp
}
  800be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800be7:	a1 04 40 80 00       	mov    0x804004,%eax
  800bec:	8b 40 48             	mov    0x48(%eax),%eax
  800bef:	83 ec 04             	sub    $0x4,%esp
  800bf2:	53                   	push   %ebx
  800bf3:	50                   	push   %eax
  800bf4:	68 59 20 80 00       	push   $0x802059
  800bf9:	e8 69 09 00 00       	call   801567 <cprintf>
		return -E_INVAL;
  800bfe:	83 c4 10             	add    $0x10,%esp
  800c01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c06:	eb da                	jmp    800be2 <write+0x55>
		return -E_NOT_SUPP;
  800c08:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c0d:	eb d3                	jmp    800be2 <write+0x55>

00800c0f <seek>:

int
seek(int fdnum, off_t offset)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c18:	50                   	push   %eax
  800c19:	ff 75 08             	pushl  0x8(%ebp)
  800c1c:	e8 35 fc ff ff       	call   800856 <fd_lookup>
  800c21:	83 c4 10             	add    $0x10,%esp
  800c24:	85 c0                	test   %eax,%eax
  800c26:	78 0e                	js     800c36 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    

00800c38 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	53                   	push   %ebx
  800c3c:	83 ec 1c             	sub    $0x1c,%esp
  800c3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c45:	50                   	push   %eax
  800c46:	53                   	push   %ebx
  800c47:	e8 0a fc ff ff       	call   800856 <fd_lookup>
  800c4c:	83 c4 10             	add    $0x10,%esp
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	78 37                	js     800c8a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c59:	50                   	push   %eax
  800c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5d:	ff 30                	pushl  (%eax)
  800c5f:	e8 42 fc ff ff       	call   8008a6 <dev_lookup>
  800c64:	83 c4 10             	add    $0x10,%esp
  800c67:	85 c0                	test   %eax,%eax
  800c69:	78 1f                	js     800c8a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c72:	74 1b                	je     800c8f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c77:	8b 52 18             	mov    0x18(%edx),%edx
  800c7a:	85 d2                	test   %edx,%edx
  800c7c:	74 32                	je     800cb0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	50                   	push   %eax
  800c85:	ff d2                	call   *%edx
  800c87:	83 c4 10             	add    $0x10,%esp
}
  800c8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c8f:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c94:	8b 40 48             	mov    0x48(%eax),%eax
  800c97:	83 ec 04             	sub    $0x4,%esp
  800c9a:	53                   	push   %ebx
  800c9b:	50                   	push   %eax
  800c9c:	68 1c 20 80 00       	push   $0x80201c
  800ca1:	e8 c1 08 00 00       	call   801567 <cprintf>
		return -E_INVAL;
  800ca6:	83 c4 10             	add    $0x10,%esp
  800ca9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cae:	eb da                	jmp    800c8a <ftruncate+0x52>
		return -E_NOT_SUPP;
  800cb0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cb5:	eb d3                	jmp    800c8a <ftruncate+0x52>

00800cb7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 1c             	sub    $0x1c,%esp
  800cbe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cc1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800cc4:	50                   	push   %eax
  800cc5:	ff 75 08             	pushl  0x8(%ebp)
  800cc8:	e8 89 fb ff ff       	call   800856 <fd_lookup>
  800ccd:	83 c4 10             	add    $0x10,%esp
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	78 4b                	js     800d1f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cda:	50                   	push   %eax
  800cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cde:	ff 30                	pushl  (%eax)
  800ce0:	e8 c1 fb ff ff       	call   8008a6 <dev_lookup>
  800ce5:	83 c4 10             	add    $0x10,%esp
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	78 33                	js     800d1f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cef:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800cf3:	74 2f                	je     800d24 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800cf5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800cf8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800cff:	00 00 00 
	stat->st_isdir = 0;
  800d02:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800d09:	00 00 00 
	stat->st_dev = dev;
  800d0c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	53                   	push   %ebx
  800d16:	ff 75 f0             	pushl  -0x10(%ebp)
  800d19:	ff 50 14             	call   *0x14(%eax)
  800d1c:	83 c4 10             	add    $0x10,%esp
}
  800d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    
		return -E_NOT_SUPP;
  800d24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d29:	eb f4                	jmp    800d1f <fstat+0x68>

00800d2b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800d30:	83 ec 08             	sub    $0x8,%esp
  800d33:	6a 00                	push   $0x0
  800d35:	ff 75 08             	pushl  0x8(%ebp)
  800d38:	e8 e7 01 00 00       	call   800f24 <open>
  800d3d:	89 c3                	mov    %eax,%ebx
  800d3f:	83 c4 10             	add    $0x10,%esp
  800d42:	85 c0                	test   %eax,%eax
  800d44:	78 1b                	js     800d61 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	50                   	push   %eax
  800d4d:	e8 65 ff ff ff       	call   800cb7 <fstat>
  800d52:	89 c6                	mov    %eax,%esi
	close(fd);
  800d54:	89 1c 24             	mov    %ebx,(%esp)
  800d57:	e8 27 fc ff ff       	call   800983 <close>
	return r;
  800d5c:	83 c4 10             	add    $0x10,%esp
  800d5f:	89 f3                	mov    %esi,%ebx
}
  800d61:	89 d8                	mov    %ebx,%eax
  800d63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	89 c6                	mov    %eax,%esi
  800d71:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800d73:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800d7a:	74 27                	je     800da3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d7c:	6a 07                	push   $0x7
  800d7e:	68 00 50 80 00       	push   $0x805000
  800d83:	56                   	push   %esi
  800d84:	ff 35 00 40 80 00    	pushl  0x804000
  800d8a:	e8 14 0f 00 00       	call   801ca3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d8f:	83 c4 0c             	add    $0xc,%esp
  800d92:	6a 00                	push   $0x0
  800d94:	53                   	push   %ebx
  800d95:	6a 00                	push   $0x0
  800d97:	e8 a0 0e 00 00       	call   801c3c <ipc_recv>
}
  800d9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	6a 01                	push   $0x1
  800da8:	e8 3f 0f 00 00       	call   801cec <ipc_find_env>
  800dad:	a3 00 40 80 00       	mov    %eax,0x804000
  800db2:	83 c4 10             	add    $0x10,%esp
  800db5:	eb c5                	jmp    800d7c <fsipc+0x12>

00800db7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  800dc3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	b8 02 00 00 00       	mov    $0x2,%eax
  800dda:	e8 8b ff ff ff       	call   800d6a <fsipc>
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <devfile_flush>:
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 40 0c             	mov    0xc(%eax),%eax
  800ded:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800df2:	ba 00 00 00 00       	mov    $0x0,%edx
  800df7:	b8 06 00 00 00       	mov    $0x6,%eax
  800dfc:	e8 69 ff ff ff       	call   800d6a <fsipc>
}
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <devfile_stat>:
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	53                   	push   %ebx
  800e07:	83 ec 04             	sub    $0x4,%esp
  800e0a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8b 40 0c             	mov    0xc(%eax),%eax
  800e13:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800e18:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1d:	b8 05 00 00 00       	mov    $0x5,%eax
  800e22:	e8 43 ff ff ff       	call   800d6a <fsipc>
  800e27:	85 c0                	test   %eax,%eax
  800e29:	78 2c                	js     800e57 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e2b:	83 ec 08             	sub    $0x8,%esp
  800e2e:	68 00 50 80 00       	push   $0x805000
  800e33:	53                   	push   %ebx
  800e34:	e8 3f f3 ff ff       	call   800178 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800e39:	a1 80 50 80 00       	mov    0x805080,%eax
  800e3e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e44:	a1 84 50 80 00       	mov    0x805084,%eax
  800e49:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800e4f:	83 c4 10             	add    $0x10,%esp
  800e52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <devfile_write>:
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	8b 52 0c             	mov    0xc(%edx),%edx
  800e6b:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  800e71:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800e76:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800e7b:	0f 47 c2             	cmova  %edx,%eax
  800e7e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800e83:	50                   	push   %eax
  800e84:	ff 75 0c             	pushl  0xc(%ebp)
  800e87:	68 08 50 80 00       	push   $0x805008
  800e8c:	e8 75 f4 ff ff       	call   800306 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800e91:	ba 00 00 00 00       	mov    $0x0,%edx
  800e96:	b8 04 00 00 00       	mov    $0x4,%eax
  800e9b:	e8 ca fe ff ff       	call   800d6a <fsipc>
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <devfile_read>:
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8b 40 0c             	mov    0xc(%eax),%eax
  800eb0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800eb5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ec5:	e8 a0 fe ff ff       	call   800d6a <fsipc>
  800eca:	89 c3                	mov    %eax,%ebx
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	78 1f                	js     800eef <devfile_read+0x4d>
	assert(r <= n);
  800ed0:	39 f0                	cmp    %esi,%eax
  800ed2:	77 24                	ja     800ef8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ed4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ed9:	7f 33                	jg     800f0e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800edb:	83 ec 04             	sub    $0x4,%esp
  800ede:	50                   	push   %eax
  800edf:	68 00 50 80 00       	push   $0x805000
  800ee4:	ff 75 0c             	pushl  0xc(%ebp)
  800ee7:	e8 1a f4 ff ff       	call   800306 <memmove>
	return r;
  800eec:	83 c4 10             	add    $0x10,%esp
}
  800eef:	89 d8                	mov    %ebx,%eax
  800ef1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    
	assert(r <= n);
  800ef8:	68 88 20 80 00       	push   $0x802088
  800efd:	68 8f 20 80 00       	push   $0x80208f
  800f02:	6a 7c                	push   $0x7c
  800f04:	68 a4 20 80 00       	push   $0x8020a4
  800f09:	e8 7e 05 00 00       	call   80148c <_panic>
	assert(r <= PGSIZE);
  800f0e:	68 af 20 80 00       	push   $0x8020af
  800f13:	68 8f 20 80 00       	push   $0x80208f
  800f18:	6a 7d                	push   $0x7d
  800f1a:	68 a4 20 80 00       	push   $0x8020a4
  800f1f:	e8 68 05 00 00       	call   80148c <_panic>

00800f24 <open>:
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	83 ec 1c             	sub    $0x1c,%esp
  800f2c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800f2f:	56                   	push   %esi
  800f30:	e8 0a f2 ff ff       	call   80013f <strlen>
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f3d:	7f 6c                	jg     800fab <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f45:	50                   	push   %eax
  800f46:	e8 b9 f8 ff ff       	call   800804 <fd_alloc>
  800f4b:	89 c3                	mov    %eax,%ebx
  800f4d:	83 c4 10             	add    $0x10,%esp
  800f50:	85 c0                	test   %eax,%eax
  800f52:	78 3c                	js     800f90 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	56                   	push   %esi
  800f58:	68 00 50 80 00       	push   $0x805000
  800f5d:	e8 16 f2 ff ff       	call   800178 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6d:	b8 01 00 00 00       	mov    $0x1,%eax
  800f72:	e8 f3 fd ff ff       	call   800d6a <fsipc>
  800f77:	89 c3                	mov    %eax,%ebx
  800f79:	83 c4 10             	add    $0x10,%esp
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	78 19                	js     800f99 <open+0x75>
	return fd2num(fd);
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	ff 75 f4             	pushl  -0xc(%ebp)
  800f86:	e8 52 f8 ff ff       	call   8007dd <fd2num>
  800f8b:	89 c3                	mov    %eax,%ebx
  800f8d:	83 c4 10             	add    $0x10,%esp
}
  800f90:	89 d8                	mov    %ebx,%eax
  800f92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    
		fd_close(fd, 0);
  800f99:	83 ec 08             	sub    $0x8,%esp
  800f9c:	6a 00                	push   $0x0
  800f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa1:	e8 56 f9 ff ff       	call   8008fc <fd_close>
		return r;
  800fa6:	83 c4 10             	add    $0x10,%esp
  800fa9:	eb e5                	jmp    800f90 <open+0x6c>
		return -E_BAD_PATH;
  800fab:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800fb0:	eb de                	jmp    800f90 <open+0x6c>

00800fb2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbd:	b8 08 00 00 00       	mov    $0x8,%eax
  800fc2:	e8 a3 fd ff ff       	call   800d6a <fsipc>
}
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    

00800fc9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
  800fce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	ff 75 08             	pushl  0x8(%ebp)
  800fd7:	e8 11 f8 ff ff       	call   8007ed <fd2data>
  800fdc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fde:	83 c4 08             	add    $0x8,%esp
  800fe1:	68 bb 20 80 00       	push   $0x8020bb
  800fe6:	53                   	push   %ebx
  800fe7:	e8 8c f1 ff ff       	call   800178 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fec:	8b 46 04             	mov    0x4(%esi),%eax
  800fef:	2b 06                	sub    (%esi),%eax
  800ff1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800ff7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800ffe:	00 00 00 
	stat->st_dev = &devpipe;
  801001:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801008:	30 80 00 
	return 0;
}
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
  801010:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    

00801017 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	53                   	push   %ebx
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801021:	53                   	push   %ebx
  801022:	6a 00                	push   $0x0
  801024:	e8 c6 f5 ff ff       	call   8005ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801029:	89 1c 24             	mov    %ebx,(%esp)
  80102c:	e8 bc f7 ff ff       	call   8007ed <fd2data>
  801031:	83 c4 08             	add    $0x8,%esp
  801034:	50                   	push   %eax
  801035:	6a 00                	push   $0x0
  801037:	e8 b3 f5 ff ff       	call   8005ef <sys_page_unmap>
}
  80103c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <_pipeisclosed>:
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
  801047:	83 ec 1c             	sub    $0x1c,%esp
  80104a:	89 c7                	mov    %eax,%edi
  80104c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80104e:	a1 04 40 80 00       	mov    0x804004,%eax
  801053:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	57                   	push   %edi
  80105a:	e8 cc 0c 00 00       	call   801d2b <pageref>
  80105f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801062:	89 34 24             	mov    %esi,(%esp)
  801065:	e8 c1 0c 00 00       	call   801d2b <pageref>
		nn = thisenv->env_runs;
  80106a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801070:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	39 cb                	cmp    %ecx,%ebx
  801078:	74 1b                	je     801095 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80107a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80107d:	75 cf                	jne    80104e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80107f:	8b 42 58             	mov    0x58(%edx),%eax
  801082:	6a 01                	push   $0x1
  801084:	50                   	push   %eax
  801085:	53                   	push   %ebx
  801086:	68 c2 20 80 00       	push   $0x8020c2
  80108b:	e8 d7 04 00 00       	call   801567 <cprintf>
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	eb b9                	jmp    80104e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801095:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801098:	0f 94 c0             	sete   %al
  80109b:	0f b6 c0             	movzbl %al,%eax
}
  80109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <devpipe_write>:
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 28             	sub    $0x28,%esp
  8010af:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010b2:	56                   	push   %esi
  8010b3:	e8 35 f7 ff ff       	call   8007ed <fd2data>
  8010b8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010c5:	74 4f                	je     801116 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010c7:	8b 43 04             	mov    0x4(%ebx),%eax
  8010ca:	8b 0b                	mov    (%ebx),%ecx
  8010cc:	8d 51 20             	lea    0x20(%ecx),%edx
  8010cf:	39 d0                	cmp    %edx,%eax
  8010d1:	72 14                	jb     8010e7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010d3:	89 da                	mov    %ebx,%edx
  8010d5:	89 f0                	mov    %esi,%eax
  8010d7:	e8 65 ff ff ff       	call   801041 <_pipeisclosed>
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 3b                	jne    80111b <devpipe_write+0x75>
			sys_yield();
  8010e0:	e8 66 f4 ff ff       	call   80054b <sys_yield>
  8010e5:	eb e0                	jmp    8010c7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010ee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	c1 fa 1f             	sar    $0x1f,%edx
  8010f6:	89 d1                	mov    %edx,%ecx
  8010f8:	c1 e9 1b             	shr    $0x1b,%ecx
  8010fb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010fe:	83 e2 1f             	and    $0x1f,%edx
  801101:	29 ca                	sub    %ecx,%edx
  801103:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801107:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80110b:	83 c0 01             	add    $0x1,%eax
  80110e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801111:	83 c7 01             	add    $0x1,%edi
  801114:	eb ac                	jmp    8010c2 <devpipe_write+0x1c>
	return i;
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	eb 05                	jmp    801120 <devpipe_write+0x7a>
				return 0;
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <devpipe_read>:
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
  80112e:	83 ec 18             	sub    $0x18,%esp
  801131:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801134:	57                   	push   %edi
  801135:	e8 b3 f6 ff ff       	call   8007ed <fd2data>
  80113a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	be 00 00 00 00       	mov    $0x0,%esi
  801144:	3b 75 10             	cmp    0x10(%ebp),%esi
  801147:	75 14                	jne    80115d <devpipe_read+0x35>
	return i;
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	eb 02                	jmp    801150 <devpipe_read+0x28>
				return i;
  80114e:	89 f0                	mov    %esi,%eax
}
  801150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801153:	5b                   	pop    %ebx
  801154:	5e                   	pop    %esi
  801155:	5f                   	pop    %edi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    
			sys_yield();
  801158:	e8 ee f3 ff ff       	call   80054b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80115d:	8b 03                	mov    (%ebx),%eax
  80115f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801162:	75 18                	jne    80117c <devpipe_read+0x54>
			if (i > 0)
  801164:	85 f6                	test   %esi,%esi
  801166:	75 e6                	jne    80114e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801168:	89 da                	mov    %ebx,%edx
  80116a:	89 f8                	mov    %edi,%eax
  80116c:	e8 d0 fe ff ff       	call   801041 <_pipeisclosed>
  801171:	85 c0                	test   %eax,%eax
  801173:	74 e3                	je     801158 <devpipe_read+0x30>
				return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb d4                	jmp    801150 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80117c:	99                   	cltd   
  80117d:	c1 ea 1b             	shr    $0x1b,%edx
  801180:	01 d0                	add    %edx,%eax
  801182:	83 e0 1f             	and    $0x1f,%eax
  801185:	29 d0                	sub    %edx,%eax
  801187:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80118c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801192:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801195:	83 c6 01             	add    $0x1,%esi
  801198:	eb aa                	jmp    801144 <devpipe_read+0x1c>

0080119a <pipe>:
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	56                   	push   %esi
  80119e:	53                   	push   %ebx
  80119f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8011a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a5:	50                   	push   %eax
  8011a6:	e8 59 f6 ff ff       	call   800804 <fd_alloc>
  8011ab:	89 c3                	mov    %eax,%ebx
  8011ad:	83 c4 10             	add    $0x10,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	0f 88 23 01 00 00    	js     8012db <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011b8:	83 ec 04             	sub    $0x4,%esp
  8011bb:	68 07 04 00 00       	push   $0x407
  8011c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c3:	6a 00                	push   $0x0
  8011c5:	e8 a0 f3 ff ff       	call   80056a <sys_page_alloc>
  8011ca:	89 c3                	mov    %eax,%ebx
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	0f 88 04 01 00 00    	js     8012db <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011dd:	50                   	push   %eax
  8011de:	e8 21 f6 ff ff       	call   800804 <fd_alloc>
  8011e3:	89 c3                	mov    %eax,%ebx
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	0f 88 db 00 00 00    	js     8012cb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	68 07 04 00 00       	push   $0x407
  8011f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8011fb:	6a 00                	push   $0x0
  8011fd:	e8 68 f3 ff ff       	call   80056a <sys_page_alloc>
  801202:	89 c3                	mov    %eax,%ebx
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	85 c0                	test   %eax,%eax
  801209:	0f 88 bc 00 00 00    	js     8012cb <pipe+0x131>
	va = fd2data(fd0);
  80120f:	83 ec 0c             	sub    $0xc,%esp
  801212:	ff 75 f4             	pushl  -0xc(%ebp)
  801215:	e8 d3 f5 ff ff       	call   8007ed <fd2data>
  80121a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80121c:	83 c4 0c             	add    $0xc,%esp
  80121f:	68 07 04 00 00       	push   $0x407
  801224:	50                   	push   %eax
  801225:	6a 00                	push   $0x0
  801227:	e8 3e f3 ff ff       	call   80056a <sys_page_alloc>
  80122c:	89 c3                	mov    %eax,%ebx
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	0f 88 82 00 00 00    	js     8012bb <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	ff 75 f0             	pushl  -0x10(%ebp)
  80123f:	e8 a9 f5 ff ff       	call   8007ed <fd2data>
  801244:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80124b:	50                   	push   %eax
  80124c:	6a 00                	push   $0x0
  80124e:	56                   	push   %esi
  80124f:	6a 00                	push   $0x0
  801251:	e8 57 f3 ff ff       	call   8005ad <sys_page_map>
  801256:	89 c3                	mov    %eax,%ebx
  801258:	83 c4 20             	add    $0x20,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 4e                	js     8012ad <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80125f:	a1 20 30 80 00       	mov    0x803020,%eax
  801264:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801267:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801269:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801273:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801276:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801282:	83 ec 0c             	sub    $0xc,%esp
  801285:	ff 75 f4             	pushl  -0xc(%ebp)
  801288:	e8 50 f5 ff ff       	call   8007dd <fd2num>
  80128d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801290:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801292:	83 c4 04             	add    $0x4,%esp
  801295:	ff 75 f0             	pushl  -0x10(%ebp)
  801298:	e8 40 f5 ff ff       	call   8007dd <fd2num>
  80129d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ab:	eb 2e                	jmp    8012db <pipe+0x141>
	sys_page_unmap(0, va);
  8012ad:	83 ec 08             	sub    $0x8,%esp
  8012b0:	56                   	push   %esi
  8012b1:	6a 00                	push   $0x0
  8012b3:	e8 37 f3 ff ff       	call   8005ef <sys_page_unmap>
  8012b8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	ff 75 f0             	pushl  -0x10(%ebp)
  8012c1:	6a 00                	push   $0x0
  8012c3:	e8 27 f3 ff ff       	call   8005ef <sys_page_unmap>
  8012c8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d1:	6a 00                	push   $0x0
  8012d3:	e8 17 f3 ff ff       	call   8005ef <sys_page_unmap>
  8012d8:	83 c4 10             	add    $0x10,%esp
}
  8012db:	89 d8                	mov    %ebx,%eax
  8012dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    

008012e4 <pipeisclosed>:
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ed:	50                   	push   %eax
  8012ee:	ff 75 08             	pushl  0x8(%ebp)
  8012f1:	e8 60 f5 ff ff       	call   800856 <fd_lookup>
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	78 18                	js     801315 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012fd:	83 ec 0c             	sub    $0xc,%esp
  801300:	ff 75 f4             	pushl  -0xc(%ebp)
  801303:	e8 e5 f4 ff ff       	call   8007ed <fd2data>
	return _pipeisclosed(fd, p);
  801308:	89 c2                	mov    %eax,%edx
  80130a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130d:	e8 2f fd ff ff       	call   801041 <_pipeisclosed>
  801312:	83 c4 10             	add    $0x10,%esp
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
  80131c:	c3                   	ret    

0080131d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801323:	68 da 20 80 00       	push   $0x8020da
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	e8 48 ee ff ff       	call   800178 <strcpy>
	return 0;
}
  801330:	b8 00 00 00 00       	mov    $0x0,%eax
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <devcons_write>:
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801343:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801348:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80134e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801351:	73 31                	jae    801384 <devcons_write+0x4d>
		m = n - tot;
  801353:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801356:	29 f3                	sub    %esi,%ebx
  801358:	83 fb 7f             	cmp    $0x7f,%ebx
  80135b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801360:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	53                   	push   %ebx
  801367:	89 f0                	mov    %esi,%eax
  801369:	03 45 0c             	add    0xc(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	57                   	push   %edi
  80136e:	e8 93 ef ff ff       	call   800306 <memmove>
		sys_cputs(buf, m);
  801373:	83 c4 08             	add    $0x8,%esp
  801376:	53                   	push   %ebx
  801377:	57                   	push   %edi
  801378:	e8 31 f1 ff ff       	call   8004ae <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80137d:	01 de                	add    %ebx,%esi
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	eb ca                	jmp    80134e <devcons_write+0x17>
}
  801384:	89 f0                	mov    %esi,%eax
  801386:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801389:	5b                   	pop    %ebx
  80138a:	5e                   	pop    %esi
  80138b:	5f                   	pop    %edi
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    

0080138e <devcons_read>:
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139d:	74 21                	je     8013c0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80139f:	e8 28 f1 ff ff       	call   8004cc <sys_cgetc>
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	75 07                	jne    8013af <devcons_read+0x21>
		sys_yield();
  8013a8:	e8 9e f1 ff ff       	call   80054b <sys_yield>
  8013ad:	eb f0                	jmp    80139f <devcons_read+0x11>
	if (c < 0)
  8013af:	78 0f                	js     8013c0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8013b1:	83 f8 04             	cmp    $0x4,%eax
  8013b4:	74 0c                	je     8013c2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b9:	88 02                	mov    %al,(%edx)
	return 1;
  8013bb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    
		return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	eb f7                	jmp    8013c0 <devcons_read+0x32>

008013c9 <cputchar>:
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013d5:	6a 01                	push   $0x1
  8013d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013da:	50                   	push   %eax
  8013db:	e8 ce f0 ff ff       	call   8004ae <sys_cputs>
}
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <getchar>:
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013eb:	6a 01                	push   $0x1
  8013ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013f0:	50                   	push   %eax
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 c9 f6 ff ff       	call   800ac1 <read>
	if (r < 0)
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 06                	js     801405 <getchar+0x20>
	if (r < 1)
  8013ff:	74 06                	je     801407 <getchar+0x22>
	return c;
  801401:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    
		return -E_EOF;
  801407:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80140c:	eb f7                	jmp    801405 <getchar+0x20>

0080140e <iscons>:
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801414:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801417:	50                   	push   %eax
  801418:	ff 75 08             	pushl  0x8(%ebp)
  80141b:	e8 36 f4 ff ff       	call   800856 <fd_lookup>
  801420:	83 c4 10             	add    $0x10,%esp
  801423:	85 c0                	test   %eax,%eax
  801425:	78 11                	js     801438 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801430:	39 10                	cmp    %edx,(%eax)
  801432:	0f 94 c0             	sete   %al
  801435:	0f b6 c0             	movzbl %al,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <opencons>:
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801440:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801443:	50                   	push   %eax
  801444:	e8 bb f3 ff ff       	call   800804 <fd_alloc>
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 3a                	js     80148a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801450:	83 ec 04             	sub    $0x4,%esp
  801453:	68 07 04 00 00       	push   $0x407
  801458:	ff 75 f4             	pushl  -0xc(%ebp)
  80145b:	6a 00                	push   $0x0
  80145d:	e8 08 f1 ff ff       	call   80056a <sys_page_alloc>
  801462:	83 c4 10             	add    $0x10,%esp
  801465:	85 c0                	test   %eax,%eax
  801467:	78 21                	js     80148a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801472:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801477:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80147e:	83 ec 0c             	sub    $0xc,%esp
  801481:	50                   	push   %eax
  801482:	e8 56 f3 ff ff       	call   8007dd <fd2num>
  801487:	83 c4 10             	add    $0x10,%esp
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	56                   	push   %esi
  801490:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801491:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801494:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80149a:	e8 8d f0 ff ff       	call   80052c <sys_getenvid>
  80149f:	83 ec 0c             	sub    $0xc,%esp
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	56                   	push   %esi
  8014a9:	50                   	push   %eax
  8014aa:	68 e8 20 80 00       	push   $0x8020e8
  8014af:	e8 b3 00 00 00       	call   801567 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014b4:	83 c4 18             	add    $0x18,%esp
  8014b7:	53                   	push   %ebx
  8014b8:	ff 75 10             	pushl  0x10(%ebp)
  8014bb:	e8 56 00 00 00       	call   801516 <vcprintf>
	cprintf("\n");
  8014c0:	c7 04 24 d3 20 80 00 	movl   $0x8020d3,(%esp)
  8014c7:	e8 9b 00 00 00       	call   801567 <cprintf>
  8014cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014cf:	cc                   	int3   
  8014d0:	eb fd                	jmp    8014cf <_panic+0x43>

008014d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	53                   	push   %ebx
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014dc:	8b 13                	mov    (%ebx),%edx
  8014de:	8d 42 01             	lea    0x1(%edx),%eax
  8014e1:	89 03                	mov    %eax,(%ebx)
  8014e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014ef:	74 09                	je     8014fa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	68 ff 00 00 00       	push   $0xff
  801502:	8d 43 08             	lea    0x8(%ebx),%eax
  801505:	50                   	push   %eax
  801506:	e8 a3 ef ff ff       	call   8004ae <sys_cputs>
		b->idx = 0;
  80150b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	eb db                	jmp    8014f1 <putch+0x1f>

00801516 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80151f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801526:	00 00 00 
	b.cnt = 0;
  801529:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801530:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	68 d2 14 80 00       	push   $0x8014d2
  801545:	e8 4a 01 00 00       	call   801694 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80154a:	83 c4 08             	add    $0x8,%esp
  80154d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801553:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801559:	50                   	push   %eax
  80155a:	e8 4f ef ff ff       	call   8004ae <sys_cputs>

	return b.cnt;
}
  80155f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80156d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801570:	50                   	push   %eax
  801571:	ff 75 08             	pushl  0x8(%ebp)
  801574:	e8 9d ff ff ff       	call   801516 <vcprintf>
	va_end(ap);

	return cnt;
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	57                   	push   %edi
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
  801581:	83 ec 1c             	sub    $0x1c,%esp
  801584:	89 c6                	mov    %eax,%esi
  801586:	89 d7                	mov    %edx,%edi
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801591:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801594:	8b 45 10             	mov    0x10(%ebp),%eax
  801597:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80159a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80159e:	74 2c                	je     8015cc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8015aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8015b0:	39 c2                	cmp    %eax,%edx
  8015b2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8015b5:	73 43                	jae    8015fa <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015b7:	83 eb 01             	sub    $0x1,%ebx
  8015ba:	85 db                	test   %ebx,%ebx
  8015bc:	7e 6c                	jle    80162a <printnum+0xaf>
			putch(padc, putdat);
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	57                   	push   %edi
  8015c2:	ff 75 18             	pushl  0x18(%ebp)
  8015c5:	ff d6                	call   *%esi
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	eb eb                	jmp    8015b7 <printnum+0x3c>
		printnum(putch,putdat,num,base,0,padc);
  8015cc:	83 ec 0c             	sub    $0xc,%esp
  8015cf:	6a 20                	push   $0x20
  8015d1:	6a 00                	push   $0x0
  8015d3:	50                   	push   %eax
  8015d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8015da:	89 fa                	mov    %edi,%edx
  8015dc:	89 f0                	mov    %esi,%eax
  8015de:	e8 98 ff ff ff       	call   80157b <printnum>
		while (--width > 0)
  8015e3:	83 c4 20             	add    $0x20,%esp
  8015e6:	83 eb 01             	sub    $0x1,%ebx
  8015e9:	85 db                	test   %ebx,%ebx
  8015eb:	7e 65                	jle    801652 <printnum+0xd7>
			putch(padc, putdat);
  8015ed:	83 ec 08             	sub    $0x8,%esp
  8015f0:	57                   	push   %edi
  8015f1:	6a 20                	push   $0x20
  8015f3:	ff d6                	call   *%esi
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	eb ec                	jmp    8015e6 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	ff 75 18             	pushl  0x18(%ebp)
  801600:	83 eb 01             	sub    $0x1,%ebx
  801603:	53                   	push   %ebx
  801604:	50                   	push   %eax
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	ff 75 dc             	pushl  -0x24(%ebp)
  80160b:	ff 75 d8             	pushl  -0x28(%ebp)
  80160e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801611:	ff 75 e0             	pushl  -0x20(%ebp)
  801614:	e8 57 07 00 00       	call   801d70 <__udivdi3>
  801619:	83 c4 18             	add    $0x18,%esp
  80161c:	52                   	push   %edx
  80161d:	50                   	push   %eax
  80161e:	89 fa                	mov    %edi,%edx
  801620:	89 f0                	mov    %esi,%eax
  801622:	e8 54 ff ff ff       	call   80157b <printnum>
  801627:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80162a:	83 ec 08             	sub    $0x8,%esp
  80162d:	57                   	push   %edi
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	ff 75 dc             	pushl  -0x24(%ebp)
  801634:	ff 75 d8             	pushl  -0x28(%ebp)
  801637:	ff 75 e4             	pushl  -0x1c(%ebp)
  80163a:	ff 75 e0             	pushl  -0x20(%ebp)
  80163d:	e8 3e 08 00 00       	call   801e80 <__umoddi3>
  801642:	83 c4 14             	add    $0x14,%esp
  801645:	0f be 80 0b 21 80 00 	movsbl 0x80210b(%eax),%eax
  80164c:	50                   	push   %eax
  80164d:	ff d6                	call   *%esi
  80164f:	83 c4 10             	add    $0x10,%esp
}
  801652:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801655:	5b                   	pop    %ebx
  801656:	5e                   	pop    %esi
  801657:	5f                   	pop    %edi
  801658:	5d                   	pop    %ebp
  801659:	c3                   	ret    

0080165a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801660:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801664:	8b 10                	mov    (%eax),%edx
  801666:	3b 50 04             	cmp    0x4(%eax),%edx
  801669:	73 0a                	jae    801675 <sprintputch+0x1b>
		*b->buf++ = ch;
  80166b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80166e:	89 08                	mov    %ecx,(%eax)
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	88 02                	mov    %al,(%edx)
}
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <printfmt>:
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80167d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801680:	50                   	push   %eax
  801681:	ff 75 10             	pushl  0x10(%ebp)
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	ff 75 08             	pushl  0x8(%ebp)
  80168a:	e8 05 00 00 00       	call   801694 <vprintfmt>
}
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <vprintfmt>:
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	57                   	push   %edi
  801698:	56                   	push   %esi
  801699:	53                   	push   %ebx
  80169a:	83 ec 3c             	sub    $0x3c,%esp
  80169d:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016a6:	e9 b4 03 00 00       	jmp    801a5f <vprintfmt+0x3cb>
		padc = ' ';
  8016ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		posi = 0;// '+' flag
  8016af:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		altflag = 0;
  8016b6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8016bd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016cb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016d0:	8d 47 01             	lea    0x1(%edi),%eax
  8016d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016d6:	0f b6 17             	movzbl (%edi),%edx
  8016d9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016dc:	3c 55                	cmp    $0x55,%al
  8016de:	0f 87 c8 04 00 00    	ja     801bac <vprintfmt+0x518>
  8016e4:	0f b6 c0             	movzbl %al,%eax
  8016e7:	ff 24 85 e0 22 80 00 	jmp    *0x8022e0(,%eax,4)
  8016ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posi = 1;
  8016f1:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  8016f8:	eb d6                	jmp    8016d0 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  8016fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016fd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801701:	eb cd                	jmp    8016d0 <vprintfmt+0x3c>
		switch (ch = *(unsigned char *) fmt++) {
  801703:	0f b6 d2             	movzbl %dl,%edx
  801706:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
  80170e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  801711:	eb 0c                	jmp    80171f <vprintfmt+0x8b>
		switch (ch = *(unsigned char *) fmt++) {
  801713:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801716:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80171a:	eb b4                	jmp    8016d0 <vprintfmt+0x3c>
			for (precision = 0; ; ++fmt) {
  80171c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80171f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801722:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801726:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801729:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80172c:	83 f9 09             	cmp    $0x9,%ecx
  80172f:	76 eb                	jbe    80171c <vprintfmt+0x88>
  801731:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801737:	eb 14                	jmp    80174d <vprintfmt+0xb9>
			precision = va_arg(ap, int);
  801739:	8b 45 14             	mov    0x14(%ebp),%eax
  80173c:	8b 00                	mov    (%eax),%eax
  80173e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801741:	8b 45 14             	mov    0x14(%ebp),%eax
  801744:	8d 40 04             	lea    0x4(%eax),%eax
  801747:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80174a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80174d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801751:	0f 89 79 ff ff ff    	jns    8016d0 <vprintfmt+0x3c>
				width = precision, precision = -1;
  801757:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80175a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80175d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801764:	e9 67 ff ff ff       	jmp    8016d0 <vprintfmt+0x3c>
  801769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80176c:	85 c0                	test   %eax,%eax
  80176e:	ba 00 00 00 00       	mov    $0x0,%edx
  801773:	0f 49 d0             	cmovns %eax,%edx
  801776:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801779:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80177c:	e9 4f ff ff ff       	jmp    8016d0 <vprintfmt+0x3c>
  801781:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801784:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80178b:	e9 40 ff ff ff       	jmp    8016d0 <vprintfmt+0x3c>
			lflag++;
  801790:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801793:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801796:	e9 35 ff ff ff       	jmp    8016d0 <vprintfmt+0x3c>
			putch(va_arg(ap, int), putdat);
  80179b:	8b 45 14             	mov    0x14(%ebp),%eax
  80179e:	8d 78 04             	lea    0x4(%eax),%edi
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	53                   	push   %ebx
  8017a5:	ff 30                	pushl  (%eax)
  8017a7:	ff d6                	call   *%esi
			break;
  8017a9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017ac:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017af:	e9 a8 02 00 00       	jmp    801a5c <vprintfmt+0x3c8>
			err = va_arg(ap, int);
  8017b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b7:	8d 78 04             	lea    0x4(%eax),%edi
  8017ba:	8b 00                	mov    (%eax),%eax
  8017bc:	99                   	cltd   
  8017bd:	31 d0                	xor    %edx,%eax
  8017bf:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017c1:	83 f8 0f             	cmp    $0xf,%eax
  8017c4:	7f 23                	jg     8017e9 <vprintfmt+0x155>
  8017c6:	8b 14 85 40 24 80 00 	mov    0x802440(,%eax,4),%edx
  8017cd:	85 d2                	test   %edx,%edx
  8017cf:	74 18                	je     8017e9 <vprintfmt+0x155>
				printfmt(putch, putdat, "%s", p);
  8017d1:	52                   	push   %edx
  8017d2:	68 a1 20 80 00       	push   $0x8020a1
  8017d7:	53                   	push   %ebx
  8017d8:	56                   	push   %esi
  8017d9:	e8 99 fe ff ff       	call   801677 <printfmt>
  8017de:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017e1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017e4:	e9 73 02 00 00       	jmp    801a5c <vprintfmt+0x3c8>
				printfmt(putch, putdat, "error %d", err);
  8017e9:	50                   	push   %eax
  8017ea:	68 23 21 80 00       	push   $0x802123
  8017ef:	53                   	push   %ebx
  8017f0:	56                   	push   %esi
  8017f1:	e8 81 fe ff ff       	call   801677 <printfmt>
  8017f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017f9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017fc:	e9 5b 02 00 00       	jmp    801a5c <vprintfmt+0x3c8>
			if ((p = va_arg(ap, char *)) == NULL)
  801801:	8b 45 14             	mov    0x14(%ebp),%eax
  801804:	83 c0 04             	add    $0x4,%eax
  801807:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80180a:	8b 45 14             	mov    0x14(%ebp),%eax
  80180d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80180f:	85 d2                	test   %edx,%edx
  801811:	b8 1c 21 80 00       	mov    $0x80211c,%eax
  801816:	0f 45 c2             	cmovne %edx,%eax
  801819:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80181c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801820:	7e 06                	jle    801828 <vprintfmt+0x194>
  801822:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801826:	75 0d                	jne    801835 <vprintfmt+0x1a1>
				for (width -= strnlen(p, precision); width > 0; width--)
  801828:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80182b:	89 c7                	mov    %eax,%edi
  80182d:	03 45 e0             	add    -0x20(%ebp),%eax
  801830:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801833:	eb 53                	jmp    801888 <vprintfmt+0x1f4>
  801835:	83 ec 08             	sub    $0x8,%esp
  801838:	ff 75 d8             	pushl  -0x28(%ebp)
  80183b:	50                   	push   %eax
  80183c:	e8 16 e9 ff ff       	call   800157 <strnlen>
  801841:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801844:	29 c1                	sub    %eax,%ecx
  801846:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80184e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801852:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801855:	eb 0f                	jmp    801866 <vprintfmt+0x1d2>
					putch(padc, putdat);
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	53                   	push   %ebx
  80185b:	ff 75 e0             	pushl  -0x20(%ebp)
  80185e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801860:	83 ef 01             	sub    $0x1,%edi
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	85 ff                	test   %edi,%edi
  801868:	7f ed                	jg     801857 <vprintfmt+0x1c3>
  80186a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80186d:	85 d2                	test   %edx,%edx
  80186f:	b8 00 00 00 00       	mov    $0x0,%eax
  801874:	0f 49 c2             	cmovns %edx,%eax
  801877:	29 c2                	sub    %eax,%edx
  801879:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80187c:	eb aa                	jmp    801828 <vprintfmt+0x194>
					putch(ch, putdat);
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	53                   	push   %ebx
  801882:	52                   	push   %edx
  801883:	ff d6                	call   *%esi
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80188b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80188d:	83 c7 01             	add    $0x1,%edi
  801890:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801894:	0f be d0             	movsbl %al,%edx
  801897:	85 d2                	test   %edx,%edx
  801899:	74 4b                	je     8018e6 <vprintfmt+0x252>
  80189b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80189f:	78 06                	js     8018a7 <vprintfmt+0x213>
  8018a1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8018a5:	78 1e                	js     8018c5 <vprintfmt+0x231>
				if (altflag && (ch < ' ' || ch > '~'))
  8018a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018ab:	74 d1                	je     80187e <vprintfmt+0x1ea>
  8018ad:	0f be c0             	movsbl %al,%eax
  8018b0:	83 e8 20             	sub    $0x20,%eax
  8018b3:	83 f8 5e             	cmp    $0x5e,%eax
  8018b6:	76 c6                	jbe    80187e <vprintfmt+0x1ea>
					putch('?', putdat);
  8018b8:	83 ec 08             	sub    $0x8,%esp
  8018bb:	53                   	push   %ebx
  8018bc:	6a 3f                	push   $0x3f
  8018be:	ff d6                	call   *%esi
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	eb c3                	jmp    801888 <vprintfmt+0x1f4>
  8018c5:	89 cf                	mov    %ecx,%edi
  8018c7:	eb 0e                	jmp    8018d7 <vprintfmt+0x243>
				putch(' ', putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	53                   	push   %ebx
  8018cd:	6a 20                	push   $0x20
  8018cf:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018d1:	83 ef 01             	sub    $0x1,%edi
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	85 ff                	test   %edi,%edi
  8018d9:	7f ee                	jg     8018c9 <vprintfmt+0x235>
			if ((p = va_arg(ap, char *)) == NULL)
  8018db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018de:	89 45 14             	mov    %eax,0x14(%ebp)
  8018e1:	e9 76 01 00 00       	jmp    801a5c <vprintfmt+0x3c8>
  8018e6:	89 cf                	mov    %ecx,%edi
  8018e8:	eb ed                	jmp    8018d7 <vprintfmt+0x243>
	if (lflag >= 2)
  8018ea:	83 f9 01             	cmp    $0x1,%ecx
  8018ed:	7f 1f                	jg     80190e <vprintfmt+0x27a>
	else if (lflag)
  8018ef:	85 c9                	test   %ecx,%ecx
  8018f1:	74 6a                	je     80195d <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	8b 00                	mov    (%eax),%eax
  8018f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018fb:	89 c1                	mov    %eax,%ecx
  8018fd:	c1 f9 1f             	sar    $0x1f,%ecx
  801900:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801903:	8b 45 14             	mov    0x14(%ebp),%eax
  801906:	8d 40 04             	lea    0x4(%eax),%eax
  801909:	89 45 14             	mov    %eax,0x14(%ebp)
  80190c:	eb 17                	jmp    801925 <vprintfmt+0x291>
		return va_arg(*ap, long long);
  80190e:	8b 45 14             	mov    0x14(%ebp),%eax
  801911:	8b 50 04             	mov    0x4(%eax),%edx
  801914:	8b 00                	mov    (%eax),%eax
  801916:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801919:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80191c:	8b 45 14             	mov    0x14(%ebp),%eax
  80191f:	8d 40 08             	lea    0x8(%eax),%eax
  801922:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801925:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  801928:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80192d:	85 d2                	test   %edx,%edx
  80192f:	0f 89 f8 00 00 00    	jns    801a2d <vprintfmt+0x399>
				putch('-', putdat);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	53                   	push   %ebx
  801939:	6a 2d                	push   $0x2d
  80193b:	ff d6                	call   *%esi
				num = -(long long) num;
  80193d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801940:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801943:	f7 d8                	neg    %eax
  801945:	83 d2 00             	adc    $0x0,%edx
  801948:	f7 da                	neg    %edx
  80194a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80194d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801950:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801953:	bf 0a 00 00 00       	mov    $0xa,%edi
  801958:	e9 e1 00 00 00       	jmp    801a3e <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80195d:	8b 45 14             	mov    0x14(%ebp),%eax
  801960:	8b 00                	mov    (%eax),%eax
  801962:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801965:	99                   	cltd   
  801966:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801969:	8b 45 14             	mov    0x14(%ebp),%eax
  80196c:	8d 40 04             	lea    0x4(%eax),%eax
  80196f:	89 45 14             	mov    %eax,0x14(%ebp)
  801972:	eb b1                	jmp    801925 <vprintfmt+0x291>
	if (lflag >= 2)
  801974:	83 f9 01             	cmp    $0x1,%ecx
  801977:	7f 27                	jg     8019a0 <vprintfmt+0x30c>
	else if (lflag)
  801979:	85 c9                	test   %ecx,%ecx
  80197b:	74 41                	je     8019be <vprintfmt+0x32a>
		return va_arg(*ap, unsigned long);
  80197d:	8b 45 14             	mov    0x14(%ebp),%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
  801987:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80198a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	8d 40 04             	lea    0x4(%eax),%eax
  801993:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801996:	bf 0a 00 00 00       	mov    $0xa,%edi
  80199b:	e9 8d 00 00 00       	jmp    801a2d <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  8019a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a3:	8b 50 04             	mov    0x4(%eax),%edx
  8019a6:	8b 00                	mov    (%eax),%eax
  8019a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b1:	8d 40 08             	lea    0x8(%eax),%eax
  8019b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019b7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019bc:	eb 6f                	jmp    801a2d <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  8019be:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c1:	8b 00                	mov    (%eax),%eax
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	8d 40 04             	lea    0x4(%eax),%eax
  8019d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019d7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019dc:	eb 4f                	jmp    801a2d <vprintfmt+0x399>
	if (lflag >= 2)
  8019de:	83 f9 01             	cmp    $0x1,%ecx
  8019e1:	7f 23                	jg     801a06 <vprintfmt+0x372>
	else if (lflag)
  8019e3:	85 c9                	test   %ecx,%ecx
  8019e5:	0f 84 98 00 00 00    	je     801a83 <vprintfmt+0x3ef>
		return va_arg(*ap, unsigned long);
  8019eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ee:	8b 00                	mov    (%eax),%eax
  8019f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019fe:	8d 40 04             	lea    0x4(%eax),%eax
  801a01:	89 45 14             	mov    %eax,0x14(%ebp)
  801a04:	eb 17                	jmp    801a1d <vprintfmt+0x389>
		return va_arg(*ap, unsigned long long);
  801a06:	8b 45 14             	mov    0x14(%ebp),%eax
  801a09:	8b 50 04             	mov    0x4(%eax),%edx
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a14:	8b 45 14             	mov    0x14(%ebp),%eax
  801a17:	8d 40 08             	lea    0x8(%eax),%eax
  801a1a:	89 45 14             	mov    %eax,0x14(%ebp)
			putch('0', putdat);
  801a1d:	83 ec 08             	sub    $0x8,%esp
  801a20:	53                   	push   %ebx
  801a21:	6a 30                	push   $0x30
  801a23:	ff d6                	call   *%esi
			goto number;
  801a25:	83 c4 10             	add    $0x10,%esp
			base = 8;
  801a28:	bf 08 00 00 00       	mov    $0x8,%edi
			if(posi)
  801a2d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  801a31:	74 0b                	je     801a3e <vprintfmt+0x3aa>
				putch('+', putdat);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	53                   	push   %ebx
  801a37:	6a 2b                	push   $0x2b
  801a39:	ff d6                	call   *%esi
  801a3b:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801a45:	50                   	push   %eax
  801a46:	ff 75 e0             	pushl  -0x20(%ebp)
  801a49:	57                   	push   %edi
  801a4a:	ff 75 dc             	pushl  -0x24(%ebp)
  801a4d:	ff 75 d8             	pushl  -0x28(%ebp)
  801a50:	89 da                	mov    %ebx,%edx
  801a52:	89 f0                	mov    %esi,%eax
  801a54:	e8 22 fb ff ff       	call   80157b <printnum>
			break;
  801a59:	83 c4 20             	add    $0x20,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  801a5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a5f:	83 c7 01             	add    $0x1,%edi
  801a62:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a66:	83 f8 25             	cmp    $0x25,%eax
  801a69:	0f 84 3c fc ff ff    	je     8016ab <vprintfmt+0x17>
			if (ch == '\0')
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	0f 84 55 01 00 00    	je     801bcc <vprintfmt+0x538>
			putch(ch, putdat);
  801a77:	83 ec 08             	sub    $0x8,%esp
  801a7a:	53                   	push   %ebx
  801a7b:	50                   	push   %eax
  801a7c:	ff d6                	call   *%esi
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	eb dc                	jmp    801a5f <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  801a83:	8b 45 14             	mov    0x14(%ebp),%eax
  801a86:	8b 00                	mov    (%eax),%eax
  801a88:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a93:	8b 45 14             	mov    0x14(%ebp),%eax
  801a96:	8d 40 04             	lea    0x4(%eax),%eax
  801a99:	89 45 14             	mov    %eax,0x14(%ebp)
  801a9c:	e9 7c ff ff ff       	jmp    801a1d <vprintfmt+0x389>
			putch('0', putdat);
  801aa1:	83 ec 08             	sub    $0x8,%esp
  801aa4:	53                   	push   %ebx
  801aa5:	6a 30                	push   $0x30
  801aa7:	ff d6                	call   *%esi
			putch('x', putdat);
  801aa9:	83 c4 08             	add    $0x8,%esp
  801aac:	53                   	push   %ebx
  801aad:	6a 78                	push   $0x78
  801aaf:	ff d6                	call   *%esi
			num = (unsigned long long)
  801ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab4:	8b 00                	mov    (%eax),%eax
  801ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  801abb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801abe:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801ac1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac7:	8d 40 04             	lea    0x4(%eax),%eax
  801aca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801acd:	bf 10 00 00 00       	mov    $0x10,%edi
			goto number;
  801ad2:	e9 56 ff ff ff       	jmp    801a2d <vprintfmt+0x399>
	if (lflag >= 2)
  801ad7:	83 f9 01             	cmp    $0x1,%ecx
  801ada:	7f 27                	jg     801b03 <vprintfmt+0x46f>
	else if (lflag)
  801adc:	85 c9                	test   %ecx,%ecx
  801ade:	74 44                	je     801b24 <vprintfmt+0x490>
		return va_arg(*ap, unsigned long);
  801ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae3:	8b 00                	mov    (%eax),%eax
  801ae5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801af0:	8b 45 14             	mov    0x14(%ebp),%eax
  801af3:	8d 40 04             	lea    0x4(%eax),%eax
  801af6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801af9:	bf 10 00 00 00       	mov    $0x10,%edi
  801afe:	e9 2a ff ff ff       	jmp    801a2d <vprintfmt+0x399>
		return va_arg(*ap, unsigned long long);
  801b03:	8b 45 14             	mov    0x14(%ebp),%eax
  801b06:	8b 50 04             	mov    0x4(%eax),%edx
  801b09:	8b 00                	mov    (%eax),%eax
  801b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b11:	8b 45 14             	mov    0x14(%ebp),%eax
  801b14:	8d 40 08             	lea    0x8(%eax),%eax
  801b17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b1a:	bf 10 00 00 00       	mov    $0x10,%edi
  801b1f:	e9 09 ff ff ff       	jmp    801a2d <vprintfmt+0x399>
		return va_arg(*ap, unsigned int);
  801b24:	8b 45 14             	mov    0x14(%ebp),%eax
  801b27:	8b 00                	mov    (%eax),%eax
  801b29:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b31:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b34:	8b 45 14             	mov    0x14(%ebp),%eax
  801b37:	8d 40 04             	lea    0x4(%eax),%eax
  801b3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b3d:	bf 10 00 00 00       	mov    $0x10,%edi
  801b42:	e9 e6 fe ff ff       	jmp    801a2d <vprintfmt+0x399>
				  signed* ptr = (signed*) va_arg(ap, void *);
  801b47:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4a:	8d 78 04             	lea    0x4(%eax),%edi
  801b4d:	8b 00                	mov    (%eax),%eax
				  if(!ptr){
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	74 2d                	je     801b80 <vprintfmt+0x4ec>
					  *(signed char*)ptr = *(signed char*)putdat;
  801b53:	0f b6 13             	movzbl (%ebx),%edx
  801b56:	88 10                	mov    %dl,(%eax)
				  signed* ptr = (signed*) va_arg(ap, void *);
  801b58:	89 7d 14             	mov    %edi,0x14(%ebp)
					  if(*(int*)putdat > 0x7F)
  801b5b:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  801b5e:	0f 8e f8 fe ff ff    	jle    801a5c <vprintfmt+0x3c8>
					  	printfmt(putch, putdat, "%s", overflow_error);					  
  801b64:	68 78 22 80 00       	push   $0x802278
  801b69:	68 a1 20 80 00       	push   $0x8020a1
  801b6e:	53                   	push   %ebx
  801b6f:	56                   	push   %esi
  801b70:	e8 02 fb ff ff       	call   801677 <printfmt>
  801b75:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  801b78:	89 7d 14             	mov    %edi,0x14(%ebp)
  801b7b:	e9 dc fe ff ff       	jmp    801a5c <vprintfmt+0x3c8>
					  printfmt(putch, putdat, "%s", null_error);
  801b80:	68 40 22 80 00       	push   $0x802240
  801b85:	68 a1 20 80 00       	push   $0x8020a1
  801b8a:	53                   	push   %ebx
  801b8b:	56                   	push   %esi
  801b8c:	e8 e6 fa ff ff       	call   801677 <printfmt>
  801b91:	83 c4 10             	add    $0x10,%esp
				  signed* ptr = (signed*) va_arg(ap, void *);
  801b94:	89 7d 14             	mov    %edi,0x14(%ebp)
  801b97:	e9 c0 fe ff ff       	jmp    801a5c <vprintfmt+0x3c8>
			putch(ch, putdat);
  801b9c:	83 ec 08             	sub    $0x8,%esp
  801b9f:	53                   	push   %ebx
  801ba0:	6a 25                	push   $0x25
  801ba2:	ff d6                	call   *%esi
			break;
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	e9 b0 fe ff ff       	jmp    801a5c <vprintfmt+0x3c8>
			putch('%', putdat);
  801bac:	83 ec 08             	sub    $0x8,%esp
  801baf:	53                   	push   %ebx
  801bb0:	6a 25                	push   $0x25
  801bb2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	89 f8                	mov    %edi,%eax
  801bb9:	eb 03                	jmp    801bbe <vprintfmt+0x52a>
  801bbb:	83 e8 01             	sub    $0x1,%eax
  801bbe:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801bc2:	75 f7                	jne    801bbb <vprintfmt+0x527>
  801bc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bc7:	e9 90 fe ff ff       	jmp    801a5c <vprintfmt+0x3c8>
}
  801bcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5f                   	pop    %edi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    

00801bd4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 18             	sub    $0x18,%esp
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801be0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801be3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801be7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 26                	je     801c1b <vsnprintf+0x47>
  801bf5:	85 d2                	test   %edx,%edx
  801bf7:	7e 22                	jle    801c1b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801bf9:	ff 75 14             	pushl  0x14(%ebp)
  801bfc:	ff 75 10             	pushl  0x10(%ebp)
  801bff:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c02:	50                   	push   %eax
  801c03:	68 5a 16 80 00       	push   $0x80165a
  801c08:	e8 87 fa ff ff       	call   801694 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c10:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c16:	83 c4 10             	add    $0x10,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    
		return -E_INVAL;
  801c1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c20:	eb f7                	jmp    801c19 <vsnprintf+0x45>

00801c22 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c28:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c2b:	50                   	push   %eax
  801c2c:	ff 75 10             	pushl  0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	e8 9a ff ff ff       	call   801bd4 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	56                   	push   %esi
  801c40:	53                   	push   %ebx
  801c41:	8b 75 08             	mov    0x8(%ebp),%esi
  801c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
  801c4a:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801c4c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801c51:	0f 44 c2             	cmove  %edx,%eax
	int32_t r = sys_ipc_recv(pg);
  801c54:	83 ec 0c             	sub    $0xc,%esp
  801c57:	50                   	push   %eax
  801c58:	e8 fe ea ff ff       	call   80075b <sys_ipc_recv>
	if (from_env_store)
  801c5d:	83 c4 10             	add    $0x10,%esp
  801c60:	85 f6                	test   %esi,%esi
  801c62:	74 14                	je     801c78 <ipc_recv+0x3c>
		*from_env_store = (r < 0) ? 0 : thisenv->env_ipc_from;
  801c64:	ba 00 00 00 00       	mov    $0x0,%edx
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	78 09                	js     801c76 <ipc_recv+0x3a>
  801c6d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c73:	8b 52 78             	mov    0x78(%edx),%edx
  801c76:	89 16                	mov    %edx,(%esi)

	if (perm_store)
  801c78:	85 db                	test   %ebx,%ebx
  801c7a:	74 14                	je     801c90 <ipc_recv+0x54>
		*perm_store = (r < 0) ? 0 : thisenv->env_ipc_perm;
  801c7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c81:	85 c0                	test   %eax,%eax
  801c83:	78 09                	js     801c8e <ipc_recv+0x52>
  801c85:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c8b:	8b 52 7c             	mov    0x7c(%edx),%edx
  801c8e:	89 13                	mov    %edx,(%ebx)

	return r < 0 ? r : thisenv->env_ipc_value;
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 08                	js     801c9c <ipc_recv+0x60>
  801c94:	a1 04 40 80 00       	mov    0x804004,%eax
  801c99:	8b 40 74             	mov    0x74(%eax),%eax
}
  801c9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    

00801ca3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
  801ca9:	8b 45 10             	mov    0x10(%ebp),%eax
	// LAB 4: Your code here.
	if (!pg)
		pg = (void*)UTOP;
  801cac:	85 c0                	test   %eax,%eax
  801cae:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801cb3:	0f 44 c2             	cmove  %edx,%eax
	// while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
	// 	if(r != -E_IPC_NOT_RECV)
	// 		panic("sys_ipc_try_send %e", r);
	// 	sys_yield();
	// }
	if((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801cb6:	ff 75 14             	pushl  0x14(%ebp)
  801cb9:	50                   	push   %eax
  801cba:	ff 75 0c             	pushl  0xc(%ebp)
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	e8 73 ea ff ff       	call   800738 <sys_ipc_try_send>
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	78 02                	js     801cce <ipc_send+0x2b>
		if(r != -E_IPC_NOT_RECV)
			panic("sys_ipc_try_send %e", r);
		sys_yield();
	}
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    
		if(r != -E_IPC_NOT_RECV)
  801cce:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801cd1:	75 07                	jne    801cda <ipc_send+0x37>
		sys_yield();
  801cd3:	e8 73 e8 ff ff       	call   80054b <sys_yield>
}
  801cd8:	eb f2                	jmp    801ccc <ipc_send+0x29>
			panic("sys_ipc_try_send %e", r);
  801cda:	50                   	push   %eax
  801cdb:	68 80 24 80 00       	push   $0x802480
  801ce0:	6a 3c                	push   $0x3c
  801ce2:	68 94 24 80 00       	push   $0x802494
  801ce7:	e8 a0 f7 ff ff       	call   80148c <_panic>

00801cec <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cf2:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_type == type)
  801cf7:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801cfa:	c1 e0 04             	shl    $0x4,%eax
  801cfd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d02:	8b 40 50             	mov    0x50(%eax),%eax
  801d05:	39 c8                	cmp    %ecx,%eax
  801d07:	74 12                	je     801d1b <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801d09:	83 c2 01             	add    $0x1,%edx
  801d0c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  801d12:	75 e3                	jne    801cf7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
  801d19:	eb 0e                	jmp    801d29 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801d1b:	8d 04 d2             	lea    (%edx,%edx,8),%eax
  801d1e:	c1 e0 04             	shl    $0x4,%eax
  801d21:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d26:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    

00801d2b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d31:	89 d0                	mov    %edx,%eax
  801d33:	c1 e8 16             	shr    $0x16,%eax
  801d36:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801d42:	f6 c1 01             	test   $0x1,%cl
  801d45:	74 1d                	je     801d64 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801d47:	c1 ea 0c             	shr    $0xc,%edx
  801d4a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801d51:	f6 c2 01             	test   $0x1,%dl
  801d54:	74 0e                	je     801d64 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d56:	c1 ea 0c             	shr    $0xc,%edx
  801d59:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801d60:	ef 
  801d61:	0f b7 c0             	movzwl %ax,%eax
}
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    
  801d66:	66 90                	xchg   %ax,%ax
  801d68:	66 90                	xchg   %ax,%ax
  801d6a:	66 90                	xchg   %ax,%ax
  801d6c:	66 90                	xchg   %ax,%ax
  801d6e:	66 90                	xchg   %ax,%ax

00801d70 <__udivdi3>:
  801d70:	55                   	push   %ebp
  801d71:	57                   	push   %edi
  801d72:	56                   	push   %esi
  801d73:	53                   	push   %ebx
  801d74:	83 ec 1c             	sub    $0x1c,%esp
  801d77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d87:	85 d2                	test   %edx,%edx
  801d89:	75 4d                	jne    801dd8 <__udivdi3+0x68>
  801d8b:	39 f3                	cmp    %esi,%ebx
  801d8d:	76 19                	jbe    801da8 <__udivdi3+0x38>
  801d8f:	31 ff                	xor    %edi,%edi
  801d91:	89 e8                	mov    %ebp,%eax
  801d93:	89 f2                	mov    %esi,%edx
  801d95:	f7 f3                	div    %ebx
  801d97:	89 fa                	mov    %edi,%edx
  801d99:	83 c4 1c             	add    $0x1c,%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5f                   	pop    %edi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    
  801da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801da8:	89 d9                	mov    %ebx,%ecx
  801daa:	85 db                	test   %ebx,%ebx
  801dac:	75 0b                	jne    801db9 <__udivdi3+0x49>
  801dae:	b8 01 00 00 00       	mov    $0x1,%eax
  801db3:	31 d2                	xor    %edx,%edx
  801db5:	f7 f3                	div    %ebx
  801db7:	89 c1                	mov    %eax,%ecx
  801db9:	31 d2                	xor    %edx,%edx
  801dbb:	89 f0                	mov    %esi,%eax
  801dbd:	f7 f1                	div    %ecx
  801dbf:	89 c6                	mov    %eax,%esi
  801dc1:	89 e8                	mov    %ebp,%eax
  801dc3:	89 f7                	mov    %esi,%edi
  801dc5:	f7 f1                	div    %ecx
  801dc7:	89 fa                	mov    %edi,%edx
  801dc9:	83 c4 1c             	add    $0x1c,%esp
  801dcc:	5b                   	pop    %ebx
  801dcd:	5e                   	pop    %esi
  801dce:	5f                   	pop    %edi
  801dcf:	5d                   	pop    %ebp
  801dd0:	c3                   	ret    
  801dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dd8:	39 f2                	cmp    %esi,%edx
  801dda:	77 1c                	ja     801df8 <__udivdi3+0x88>
  801ddc:	0f bd fa             	bsr    %edx,%edi
  801ddf:	83 f7 1f             	xor    $0x1f,%edi
  801de2:	75 2c                	jne    801e10 <__udivdi3+0xa0>
  801de4:	39 f2                	cmp    %esi,%edx
  801de6:	72 06                	jb     801dee <__udivdi3+0x7e>
  801de8:	31 c0                	xor    %eax,%eax
  801dea:	39 eb                	cmp    %ebp,%ebx
  801dec:	77 a9                	ja     801d97 <__udivdi3+0x27>
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	eb a2                	jmp    801d97 <__udivdi3+0x27>
  801df5:	8d 76 00             	lea    0x0(%esi),%esi
  801df8:	31 ff                	xor    %edi,%edi
  801dfa:	31 c0                	xor    %eax,%eax
  801dfc:	89 fa                	mov    %edi,%edx
  801dfe:	83 c4 1c             	add    $0x1c,%esp
  801e01:	5b                   	pop    %ebx
  801e02:	5e                   	pop    %esi
  801e03:	5f                   	pop    %edi
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    
  801e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e0d:	8d 76 00             	lea    0x0(%esi),%esi
  801e10:	89 f9                	mov    %edi,%ecx
  801e12:	b8 20 00 00 00       	mov    $0x20,%eax
  801e17:	29 f8                	sub    %edi,%eax
  801e19:	d3 e2                	shl    %cl,%edx
  801e1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e1f:	89 c1                	mov    %eax,%ecx
  801e21:	89 da                	mov    %ebx,%edx
  801e23:	d3 ea                	shr    %cl,%edx
  801e25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e29:	09 d1                	or     %edx,%ecx
  801e2b:	89 f2                	mov    %esi,%edx
  801e2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e31:	89 f9                	mov    %edi,%ecx
  801e33:	d3 e3                	shl    %cl,%ebx
  801e35:	89 c1                	mov    %eax,%ecx
  801e37:	d3 ea                	shr    %cl,%edx
  801e39:	89 f9                	mov    %edi,%ecx
  801e3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e3f:	89 eb                	mov    %ebp,%ebx
  801e41:	d3 e6                	shl    %cl,%esi
  801e43:	89 c1                	mov    %eax,%ecx
  801e45:	d3 eb                	shr    %cl,%ebx
  801e47:	09 de                	or     %ebx,%esi
  801e49:	89 f0                	mov    %esi,%eax
  801e4b:	f7 74 24 08          	divl   0x8(%esp)
  801e4f:	89 d6                	mov    %edx,%esi
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	f7 64 24 0c          	mull   0xc(%esp)
  801e57:	39 d6                	cmp    %edx,%esi
  801e59:	72 15                	jb     801e70 <__udivdi3+0x100>
  801e5b:	89 f9                	mov    %edi,%ecx
  801e5d:	d3 e5                	shl    %cl,%ebp
  801e5f:	39 c5                	cmp    %eax,%ebp
  801e61:	73 04                	jae    801e67 <__udivdi3+0xf7>
  801e63:	39 d6                	cmp    %edx,%esi
  801e65:	74 09                	je     801e70 <__udivdi3+0x100>
  801e67:	89 d8                	mov    %ebx,%eax
  801e69:	31 ff                	xor    %edi,%edi
  801e6b:	e9 27 ff ff ff       	jmp    801d97 <__udivdi3+0x27>
  801e70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e73:	31 ff                	xor    %edi,%edi
  801e75:	e9 1d ff ff ff       	jmp    801d97 <__udivdi3+0x27>
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	66 90                	xchg   %ax,%ax
  801e7e:	66 90                	xchg   %ax,%ax

00801e80 <__umoddi3>:
  801e80:	55                   	push   %ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	83 ec 1c             	sub    $0x1c,%esp
  801e87:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e97:	89 da                	mov    %ebx,%edx
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	75 43                	jne    801ee0 <__umoddi3+0x60>
  801e9d:	39 df                	cmp    %ebx,%edi
  801e9f:	76 17                	jbe    801eb8 <__umoddi3+0x38>
  801ea1:	89 f0                	mov    %esi,%eax
  801ea3:	f7 f7                	div    %edi
  801ea5:	89 d0                	mov    %edx,%eax
  801ea7:	31 d2                	xor    %edx,%edx
  801ea9:	83 c4 1c             	add    $0x1c,%esp
  801eac:	5b                   	pop    %ebx
  801ead:	5e                   	pop    %esi
  801eae:	5f                   	pop    %edi
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    
  801eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801eb8:	89 fd                	mov    %edi,%ebp
  801eba:	85 ff                	test   %edi,%edi
  801ebc:	75 0b                	jne    801ec9 <__umoddi3+0x49>
  801ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec3:	31 d2                	xor    %edx,%edx
  801ec5:	f7 f7                	div    %edi
  801ec7:	89 c5                	mov    %eax,%ebp
  801ec9:	89 d8                	mov    %ebx,%eax
  801ecb:	31 d2                	xor    %edx,%edx
  801ecd:	f7 f5                	div    %ebp
  801ecf:	89 f0                	mov    %esi,%eax
  801ed1:	f7 f5                	div    %ebp
  801ed3:	89 d0                	mov    %edx,%eax
  801ed5:	eb d0                	jmp    801ea7 <__umoddi3+0x27>
  801ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ede:	66 90                	xchg   %ax,%ax
  801ee0:	89 f1                	mov    %esi,%ecx
  801ee2:	39 d8                	cmp    %ebx,%eax
  801ee4:	76 0a                	jbe    801ef0 <__umoddi3+0x70>
  801ee6:	89 f0                	mov    %esi,%eax
  801ee8:	83 c4 1c             	add    $0x1c,%esp
  801eeb:	5b                   	pop    %ebx
  801eec:	5e                   	pop    %esi
  801eed:	5f                   	pop    %edi
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    
  801ef0:	0f bd e8             	bsr    %eax,%ebp
  801ef3:	83 f5 1f             	xor    $0x1f,%ebp
  801ef6:	75 20                	jne    801f18 <__umoddi3+0x98>
  801ef8:	39 d8                	cmp    %ebx,%eax
  801efa:	0f 82 b0 00 00 00    	jb     801fb0 <__umoddi3+0x130>
  801f00:	39 f7                	cmp    %esi,%edi
  801f02:	0f 86 a8 00 00 00    	jbe    801fb0 <__umoddi3+0x130>
  801f08:	89 c8                	mov    %ecx,%eax
  801f0a:	83 c4 1c             	add    $0x1c,%esp
  801f0d:	5b                   	pop    %ebx
  801f0e:	5e                   	pop    %esi
  801f0f:	5f                   	pop    %edi
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    
  801f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f18:	89 e9                	mov    %ebp,%ecx
  801f1a:	ba 20 00 00 00       	mov    $0x20,%edx
  801f1f:	29 ea                	sub    %ebp,%edx
  801f21:	d3 e0                	shl    %cl,%eax
  801f23:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f27:	89 d1                	mov    %edx,%ecx
  801f29:	89 f8                	mov    %edi,%eax
  801f2b:	d3 e8                	shr    %cl,%eax
  801f2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f31:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f35:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f39:	09 c1                	or     %eax,%ecx
  801f3b:	89 d8                	mov    %ebx,%eax
  801f3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f41:	89 e9                	mov    %ebp,%ecx
  801f43:	d3 e7                	shl    %cl,%edi
  801f45:	89 d1                	mov    %edx,%ecx
  801f47:	d3 e8                	shr    %cl,%eax
  801f49:	89 e9                	mov    %ebp,%ecx
  801f4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f4f:	d3 e3                	shl    %cl,%ebx
  801f51:	89 c7                	mov    %eax,%edi
  801f53:	89 d1                	mov    %edx,%ecx
  801f55:	89 f0                	mov    %esi,%eax
  801f57:	d3 e8                	shr    %cl,%eax
  801f59:	89 e9                	mov    %ebp,%ecx
  801f5b:	89 fa                	mov    %edi,%edx
  801f5d:	d3 e6                	shl    %cl,%esi
  801f5f:	09 d8                	or     %ebx,%eax
  801f61:	f7 74 24 08          	divl   0x8(%esp)
  801f65:	89 d1                	mov    %edx,%ecx
  801f67:	89 f3                	mov    %esi,%ebx
  801f69:	f7 64 24 0c          	mull   0xc(%esp)
  801f6d:	89 c6                	mov    %eax,%esi
  801f6f:	89 d7                	mov    %edx,%edi
  801f71:	39 d1                	cmp    %edx,%ecx
  801f73:	72 06                	jb     801f7b <__umoddi3+0xfb>
  801f75:	75 10                	jne    801f87 <__umoddi3+0x107>
  801f77:	39 c3                	cmp    %eax,%ebx
  801f79:	73 0c                	jae    801f87 <__umoddi3+0x107>
  801f7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f83:	89 d7                	mov    %edx,%edi
  801f85:	89 c6                	mov    %eax,%esi
  801f87:	89 ca                	mov    %ecx,%edx
  801f89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f8e:	29 f3                	sub    %esi,%ebx
  801f90:	19 fa                	sbb    %edi,%edx
  801f92:	89 d0                	mov    %edx,%eax
  801f94:	d3 e0                	shl    %cl,%eax
  801f96:	89 e9                	mov    %ebp,%ecx
  801f98:	d3 eb                	shr    %cl,%ebx
  801f9a:	d3 ea                	shr    %cl,%edx
  801f9c:	09 d8                	or     %ebx,%eax
  801f9e:	83 c4 1c             	add    $0x1c,%esp
  801fa1:	5b                   	pop    %ebx
  801fa2:	5e                   	pop    %esi
  801fa3:	5f                   	pop    %edi
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    
  801fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fad:	8d 76 00             	lea    0x0(%esi),%esi
  801fb0:	89 da                	mov    %ebx,%edx
  801fb2:	29 fe                	sub    %edi,%esi
  801fb4:	19 c2                	sbb    %eax,%edx
  801fb6:	89 f1                	mov    %esi,%ecx
  801fb8:	89 c8                	mov    %ecx,%eax
  801fba:	e9 4b ff ff ff       	jmp    801f0a <__umoddi3+0x8a>
