extern __imp_malloc :qword  ;going through CRT DLL
extern __imp_free   :qword

.code

;calculate gcd
;          ecx    edx
;eax = gcd(int a, int b)
gcd proc
l:
  test  ecx, ecx    ;zf = (ecx & ecx) == 0 ? 1 : 0
  jz    e           ;jump to end if zf == 1
  mov   eax, edx    ;move b to eax
  cdq               ;covert eax dword to edx:eax qword
  idiv  ecx         ;edx:eax /= ecx (store quotient to eax, remainder to edx)
  mov   eax, edx    ;save edx
  mov   edx, ecx    ;b = a
  mov   ecx, eax    ;a = b % a
  jmp   l           ;another iter
e:
  mov eax, edx      ;since a == 0 then return b
  ret
gcd endp


;reverse int32
;              ecx
;eax = reverse(int i)
reverse proc
  mov   eax, ecx  ;eax = i
  mov   ecx, 10   ;used for %10
  xor   r8d, r8d  ;will store the result
l:
  test  eax, eax  ;zf = (eax & eax) == 0 ? 1 : 0
  jz    e         ;jump to end if eax == 0
  cdq             ;eax:edx = (qword)eax
  idiv  ecx       ;eax:edx /= ecx (store quotient in eax, remainder in edx)
  imul  r8d, 10   ;r*=10
  add   r8d, edx  ;r+=i%10
  jmp   l
e:
  mov eax, r8d    ;move return value to eax
  ret
reverse endp


;count number of 1's int32
;                   ecx
;eax = count1_i32_a(unsigned int i)
count1_i32_a proc
  xor   eax, eax  ;set return value to 0
  mov   r8b, 32   ;number of bits to test
l:
  mov   edx, 1    ;edx = 00000001h
  and   edx, ecx  ;zf = (ecx & 1) == 0 ? 1 : 0
  setnz r9b       ;r9b = (zf == 1) ? 0 : 1
  add   al, r9b   ;add 1 or 0 to counter
  shr   ecx, 1    ;i >>= 1
  dec   r8b       ;one less to process
  test  r8b,r8b   ;zf = (r8b & r8b) == 0 ? 1 : 0 (check if already processed 32 bits)
  jnz   l         ;process next bit if zf == 0
  ret
count1_i32_a endp


;count number of 1's int32
;                   ecx
;eax = count1_i32_b(unsigned int i)
count1_i32_b proc
  xor   eax, eax      ;set return value to 0
l:
  lea   edx, [eax+1]  ;edx = count+1 (pretend 1 will be found)
  test  cl, 1         ;zf = (cl & 1) == 0 ? 1 : 0
  cmove edx, eax      ;edx = (zf == 1) ? count-1 : don't move (keep count+1)
  mov   eax, edx      ;update return value
  shr   ecx, 1        ;one less to process
  jne   l             ;process next bit if zf == 0
  ret
count1_i32_b endp


;count number of 1's int32
;                   ecx
;eax = count1_i32_c(unsigned int i)
count1_i32_c proc
  xor eax, eax      ;set return value to 0
l:
  inc eax           ;count++
  lea edx, [ecx-1]  ;edx = n-1
  and ecx, edx      ;n = n & (n-1) (check if power of 2)
  jnz l             ;another iter if zf == 0
  ret
count1_i32_c endp


;count number of 1's int32
;                   ecx
;eax = count1_i32_d(unsigned int i)
count1_i32_d proc
  popcnt eax, ecx   ;extract number of 1's into eax
  ret
count1_i32_d endp


;count number of 1's int64
;                   rcx
;eax = count1_i64_a(unsigned long long i)
count1_i64_a proc
  xor   eax, eax  ;set return value to 0
  mov   r8b, 64   ;number of bits to test
l:
  mov   edx, 1    ;edx = 00000001h
  and   edx, ecx  ;zf = (ecx & 1) == 0 ? 1 : 0
  setnz r9b       ;r9b = (zf == 1) ? 0 : 1
  add   al, r9b   ;add 1 or 0 to counter
  shr   rcx, 1    ;i >>= 1
  dec   r8b       ;one less to process
  test  r8b,r8b   ;zf = (r8b & r8b) == 0 ? 1 : 0 (check if already processed 64 bits)
  jnz   l         ;process next bit if zf == 0
  ret
count1_i64_a endp


;count number of 1's int64
;                   rcx
;eax = count1_i64_b(unsigned long long i)
count1_i64_b proc
  xor   eax, eax      ;set return value to 0
l:
  lea   edx, [eax+1]  ;edx = count+1 (pretend 1 will be found)
  test  cl, 1         ;zf = (cl & 1) == 0 ? 1 : 0
  cmove edx, eax      ;edx = (zf == 1) ? count-1 : don't move (keep count+1)
  mov   eax, edx      ;update return value
  shr   rcx, 1        ;one less to process
  jne   l             ;process next bit if zf == 0
  ret
count1_i64_b endp


;count number of 1's int64
;                   rcx
;eax = count1_i64_c(unsigned long long i)
count1_i64_c proc
  xor eax, eax      ;set return value to 0
l:
  inc eax           ;count++
  lea rdx, [rcx-1]  ;edx = n-1
  and rcx, rdx      ;n = n & (n-1) (check if power of 2)
  jnz l             ;another iter if zf != 0
  ret
count1_i64_c endp


;count number of 1's int64
;                   rcx
;eax = count1_i64_d(unsigned long long i)
count1_i64_d proc
  popcnt rax, rcx   ;extract number of 1's into rax
  ret
count1_i64_d endp


;count number of 0's int32
;                   ecx
;eax = count0_i32_a(unsigned int i)
count0_i32_a proc
  xor   eax, eax  ;set return value to 0
  mov   r8d, 32   ;number of bits to test
l:
  mov   edx, 1    ;edx = 00000001h
  and   edx, ecx  ;zf = (ecx & 1) == 0 ? 1 : 0
  setz  r9b       ;r9b = (zf == 1) ? 1 : 0
  add   al, r9b   ;add 1 or 0 to counter
  shr   ecx, 1    ;i >>= 1
  dec   r8b       ;one less to process
  test  r8b,r8b   ;zf = (r8b & r8b) == 0 ? 1 : 0 (check if already processed 32 bits)
  jnz   l         ;process next bit if zf == 0
  ret
count0_i32_a endp


;count number of 0's int32
;                   ecx
;eax = count0_i32_b(unsigned int i)
count0_i32_b proc
  xor   eax, eax        ;set return value to 0
  mov   r8b, 32         ;number of bits to test
l:
  lea     edx, [eax+1]  ;edx = count+1 (pretend 0 will be found)
  test    cl, 1         ;zf = (cl & 1) == 0 ? 1 : 0
  cmovne  edx, eax      ;edx = (zf == 0) ? count-1 : don't move (keep count+1)
  mov     eax, edx      ;update return value
  shr     ecx, 1        ;i >>= 1
  dec     r8b           ;one less to process
  test    r8b,r8b       ;zf = (r8b & r8b) == 0 ? 1 : 0 (check if already processed 32 bits)
  jnz     l             ;process next bit if zf == 0
  ret
count0_i32_b endp


;count number of 0's int32
;                   ecx
;eax = count0_i32_c(unsigned int i)
count0_i32_c proc
  not    ecx        ;negate and count number of 1's instead
  popcnt eax, ecx   ;extract number of 1's into eax
  ret
count0_i32_c endp


;count number of 0's int64
;                   rcx
;eax = count0_i64_a(unsigned long long i)
count0_i64_a proc
  xor   eax, eax  ;set return value to 0
  mov   r8b, 64   ;number of bits to test
l:
  mov   edx, 1    ;edx = 00000001h
  and   edx, ecx  ;zf = (ecx & 1) == 0 ? 1 : 0
  setz  r9b       ;r9b = (zf == 1) ? 0 : 1
  add   al, r9b   ;add 1 or 0 to counter
  shr   rcx, 1    ;i >>= 1
  dec   r8b       ;one less to process
  test  r8b,r8b   ;zf = (r8b & r8b) == 0 ? 1 : 0 (check if already processed 64 bits)
  jnz   l         ;process next bit if zf == 0
  ret
count0_i64_a endp


;count number of 0's int64
;                   rcx
;eax = count0_i64_b(unsigned long long i)
count0_i64_b proc
  xor   eax, eax        ;set return value to 0
  mov   r8b, 64         ;number of bits to test
l:
  lea     edx, [eax+1]  ;edx = count+1 (pretend 0 will be found)
  test    cl, 1         ;zf = (cl & 1) == 0 ? 1 : 0
  cmovne  edx, eax      ;edx = (zf == 0) ? count-1 : don't move (keep count+1)
  mov     eax, edx      ;update return value
  shr     rcx, 1        ;i >>= 1
  dec     r8b           ;one less to process
  test    r8b,r8b       ;zf = (r8b & r8b) == 0 ? 1 : 0 (check if already processed 64 bits)
  jnz     l             ;process next bit if zf == 0
  ret
count0_i64_b endp


;count number of 0's int64
;                   rcx
;eax = count0_i32_c(unsigned long long int)
count0_i64_c proc
  not    rcx        ;negate and count number of 1's instead
  popcnt rax, rcx   ;extract number of 1's into eax
  ret
count0_i64_c endp


;round down next power2
;           ecx
;rounddown2(unsigned int i)
rounddown2 proc
  mov eax, 80000000h  ;eax = 1000...0000b
l:
  cmp eax, ecx        ;eax < ecx ?
  jbe e               ;jump to end if eax < ecx
  shr eax, 1          ;get smaller power of 2
  jmp l               ;check again
e:
  ret
rounddown2 endp


;round up next power2
;         ecx
;roundup2(unsigned int i)
roundup2 proc
  mov eax, 1      ;eax = 0000...0001b
l:
  cmp eax, ecx    ;eax < ecx ?
  jge e           ;jump to end if eax > ecx
  shl eax, 1      ;get bigger power of 2
  jmp l           ;check again
e:
  ret
roundup2 endp


;swap 2 ints
;      rcx     rdx
;swapi(int& a, int& b)
swapi proc
  mov r8d, [rcx]  ;r8d = a
  mov r9d, [rdx]  ;r9d = b
  mov [rcx], r9d  ;a = b
  mov [rdx], r8d  ;b = a
  ret
swapi endp


;swap 2 float
;      rcx       rdx
;swapf(float& a, float& b)
swapf proc
  mov r8d, [rcx]  ;r8d = a
  mov r9d, [rdx]  ;r9d = b
  mov [rcx], r9d  ;a = b
  mov [rdx], r8d  ;b = a
  ret
swapf endp


;swap 2 double
;      rcx        rdx
;swapd(double& a, double& b)
swapd proc
  mov r8, [rcx] ;r8 = a
  mov r9, [rdx] ;r9 = b
  mov [rcx], r9 ;a = b
  mov [rdx], r8 ;b = a
  ret
swapd endp


;sum of 4 integers of different size
;                     cl      dx       r8d    r9
;rax = long long sumi(char c, short s, int i, long long ll)
sumi proc
  movsx eax, cl   ;sign-extend cl byte to eax dword [eax = (int)c]
  movsx ecx, dx   ;sign-extend dx word to ecx dword [ecx = (int)s]
  add   eax, ecx  ;eax += (int)s
  add   eax, r8d  ;eax += i
  cdqe            ;convert eax dword to rax qword [rax = (long long)eax]
  add   rax, r9   ;rax += ll
  ret
sumi endp


;mul of 4 integers of different size
;                     cl      dx       r8d    r9
;rax = long long muli(char c, short s, int i, long long ll)
muli proc
  movsx eax, cl   ;sign-extend cl byte to eax dword [eax = (int)c]
  movsx ecx, dx   ;sign-extend dx word to ecx dword [ecx = (int)s]
  imul  eax, ecx  ;eax *= (int)s
  imul  eax, r8d  ;eax *= i
  cdqe            ;convert eax dword to rax qword [rax = (long long)eax]
  imul  rax, r9   ;rax *= ll
  ret
muli endp


;get quotient and remainder from int32 division a/b
;           ecx    edx    r8      r9
;eax = divi(int a, int b, int& q, int& r)
divi proc
  xor   eax,eax   ;set return value to false
  test  edx, edx  ;zf = (edx & edx) == 0 ? 1 : 0 (check for invalid divisor)
  jz    e         ;jump to end if zf == 1
  mov   eax, ecx  ;eax = a
  mov   ecx, edx  ;ecx = b
  cdq             ;covert eax dword to edx:eax qword
  idiv  ecx       ;edx:eax /= ecx (store quotient to eax, remainder to edx)

  mov   [r8], eax ;q = quotient
  mov   [r9], edx ;r = reminder
  mov   eax, 1    ;set return vale to true
e:
  ret
divi endp


;get quotient and remainder from int64 division a/b
;           rcx          rdx          r8            r9
;bool divll(long long a, long long b, long long& q, long long& r)
divll proc
  xor   eax, eax  ;set return value to false
  test  rdx, rdx  ;zf = (rdx & rdx) == 0 ? 1 : 0 (check for invalid divisor)
  jz    e         ;jump to end if zf == 1
  mov   rax, rcx  ;rax = a
  mov   rcx, rdx  ;rcx = b
  cqo             ;covert rax qword to rdx:rax oword
  idiv  rcx       ;rdx:rax /= rcx (store quotient to rax, remainder to rdx)

  mov   [r8], rax ;q = quotient
  mov   [r9], rdx ;r = reminder
  mov   eax, 1    ;set return value to true
e:
  ret
divll endp


;minimum of 2 int32
;           ecx    edx
;eax = mini(int a, int b)
mini proc
  mov   eax, edx  ;suppose b is the min
  cmp   ecx, edx  ;compare a and b (if a < b then set zf = 0 and cf = 1)
  cmovl eax, ecx  ;conditional-move-less (move ecx to eax if zf == 0 and cf == 1)
  ret
mini endp


;minimum of 2 float
;            xmm0     xmm1
;xmm0 = minf(float a, float b)
minf proc
  minss xmm0, xmm1  ;xmm0 = min(a,b)
  ret
minf endp


;minimum of 2 double
;            xmm0      xmm1
;xmm0 = mind(double a, double b)
mind proc
  minsd xmm0, xmm1  ;xmm0 = min(a,b)
  ret
mind endp


;maximum of 2 int32
;           ecx    edx
;eax = maxi(int a, int b)
maxi proc
  mov   eax, edx  ;suppose b is the max
  cmp   ecx, edx  ;compare a and b (if a > b then set zf = 0 and cf = 0)
  cmovg eax, ecx  ;conditional-move-greater (move ecx to eax if zf == 0 and cf == 0)
  ret
maxi endp


;maximum of 2 float
;            xmm0     xmm1
;xmm0 = maxf(float a, float b)
maxf proc
  maxss xmm0, xmm1  ;xmm0 = max(a,b)
  ret
maxf endp


;maximum of 2 double
;            xmm0      xmm1
;xmm0 = maxd(double a, double b)
maxd proc
  maxsd xmm0, xmm1  ;xmm0 = max(a,b)
  ret
maxd endp


;set rounding mode to "truncate"
roundt proc
  stmxcsr dword ptr[rsp+8]      ;store controlstatus reg to stack
  mov     eax, [rsp+8]          ;read controlstatus reg into eax
  or      ax, 0110000000000000b ;set truncate mode bits (13th-14th = 11b)
  mov     [rsp+8], eax          ;save new value to stack
  ldmxcsr [rsp+8]               ;load new controlstatus value
  ret
roundt endp


;set rounding mode to "nearest"
roundn proc
  stmxcsr dword ptr[rsp+8]      ;store controlstatus reg to stack
  mov     eax, [rsp+8]          ;read controlstatus reg into eax
  and     ax, 1001111111111111b ;set rounding mode bits (13th-14th = 00b)
  mov     [rsp+8], eax          ;save new value to stack
  ldmxcsr [rsp+8]               ;load new controlstatus value
  ret
roundn endp


;convert int32 to float
;            ecx
;xmm0 = itof(int i)
itof proc
  cvtsi2ss xmm0, ecx  ;xmm0 = (float)ecx
  ret
itof endp


;convert float to int32
;           xmm0
;eax = ftoi(float f)
ftoi proc
  cvtss2si eax, xmm0  ;eax = (int)xmm0
  ret
ftoi endp


;convert int32 to double
;            ecx
;xmm0 = itod(int i)
itod proc
  cvtsi2sd xmm0, ecx  ;xmm0 = (double)ecx
  ret
itod endp


;convert double to int32
;           xmm0
;eax = dtoi(double d)
dtoi proc
  cvtsd2si eax, xmm0  ;eax = (int)xmm0
  ret
dtoi endp


;absolute int32 value
;           ecx
;eax = absi(int i)
absi proc
  mov eax, ecx  ;eax = i (save i)
  sar ecx, 31   ;ecx = i >> 31 (shift sign-bit to least significant bit)
  add eax, ecx  ;i += sign-bit
  xor eax, ecx  ;invert
  ret
absi endp


;absolute float value
;              xmm0
;xmm0 = absf_a(float f)
absf_a proc
  movd  eax, xmm0       ;move encoded 32-bit float value to eax
  and   eax, 7fffffffh  ;clear sign bit
  movd  xmm0, eax       ;move back to xmm0
  ret
absf_a endp


;absolute float value
;              xmm0
;xmm0 = absf_b(float f)
absf_b proc
  pcmpeqd xmm1, xmm1    ;xmm1 = ffffffffh (compare-equal xmm1-xmm1)
  psrld   xmm1, 1       ;xmm1 = 7fffffffh (shift 1 bit dword creating bit mask)
  andps   xmm0, xmm1    ;clear sign bit xmm0 &= 7fffffffh
absf_b endp


;absolute double value
;              xmm0
;xmm0 = absd_a(double d)
absd_a proc
  movq  rax, xmm0 ;move encoded double 64-bit value to rax
  mov   rcx, 1    ;rcx = 0000000000000001h
  sal   rcx, 63   ;rcx = 1000000000000000h
  not   rcx       ;rcx = 7fffffffffffffffh (mask for sign bit)
  and   rax, rcx  ;clear sign bit
  movq  xmm0, rax ;move back to xmm0
  ret
absd_a endp


;absolute double value
;              xmm0
;xmm0 = absd_b(double d)
absd_b proc
  pcmpeqd xmm1, xmm1  ;xmm1 = ffffffffffffffffh (compare-equal xmm1-xmm1)
  psrlq   xmm1, 1     ;xmm1 = 7fffffffffffffffh (shift 1 bit qword creating bit mask)
  andpd   xmm0, xmm1  ;clear sign bit xmm0 &= 7fffffffffffffffh
  ret
absd_b endp


;string length char
;                        rcx
;rax = long long strlenA(const char* str)
strlenA proc
  xor   eax, eax  ;rax = 0 (initial string length)
  test  rcx, rcx  ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e         ;jump to end if zf == 1 (nullptr case)
  mov   rdi, rcx  ;mov ptr to rdi
  mov   rcx, -1   ;rcx != 0 to start scasb

  repne scasb     ;repeat-not-equal scan-string-byte
  ;loop:
  ;if(byte pointed by rdi != '\0')
  ;   rdi++ (next char)
  ;   rcx-- (count--)
  ;else
  ;   zf = 1
  ;   break

  ;rcx now contain the negative count starting from -1. If string length is 5
  ;rcx-- is executed 5 times reaching -6. We need to invert and subtract 1:
  ;5 = not(-6)-1 = 6-1
  not   rcx       ;invert rcx
  dec   rcx       ;length = rcx-1
  mov   rax, rcx  ;eax = length
e:
  ret
strlenA endp


;string length wchar_t
;                        rcx
;rax = long long strlenW(const wchar_t* str)
strlenW proc
  xor   eax, eax  ;rax = 0 (initial string length)
  test  rcx, rcx  ;zf = (rcx & rcx) == 0 ? 1 : 0 (check for nullptr)
  jz e            ;jump to end if zf == 1 (nullptr case)
  mov   rdi, rcx  ;mov ptr to rdi
  mov   rcx, -1   ;rcx != 0 to start scasw

  repne scasw     ;repeat-not-equal scan-string-word
  ;loop:
  ;if(word pointed by rdi != L'\0')
  ;   rdi++ (next wchar_t)
  ;   rcx-- (count--)
  ;else
  ;   zf = 1
  ;   break

  ;rcx now contain the negative count starting from -1. If string length is 5
  ;rcx-- is executed 5 times reaching -6. We need to invert and subtract 1:
  ;5 = not(-6)-1 = 6-1
  not   rcx       ;invert rcx
  dec   rcx       ;length = rcx-1
  mov   rax, rcx  ;rax = length
e:
  ret
strlenW endp


;count occurrences of char in a string
;                        rcx              dl
;rax = long long strcntA(const char* str, char c)
strcntA proc frame
  push rsi
  .pushreg rsi
  .endprolog

  xor   rax, rax  ;set return value to 0
  test  rcx, rcx  ;zf = (rcx & rcx) == 0 ? 1 : 0 (check for nullptr)
  jz    e2        ;jump to end if zf == 1 (nullptr case)
  mov   rsi, rcx  ;rsi = string ptr
  xor   ecx, ecx  ;count = 0
  xor   r8d, r8d  ;use for occurrence (1 = found, 0 = not found)
l:
  lodsb           ;load next char into al and increment rsi (point to next char)
  or    al, al    ;check for null char
  jz    e1        ;jump to end if al == 0

  cmp   al, dl    ;compare current char with c
  sete  r8b       ;r8b = (al == dl) ? 1 : 0
  add   rcx, r8   ;add 1 (or 0) to count
  jmp   l         ;next char
e1:
  mov   rax, rcx  ;move count to return reg
e2:
  pop   rsi
  ret
strcntA endp


;count occurrences of wchar_t in a string
;                        rcx                 dx
;rax = long long strcntW(const wchar_t* str, wchar_t c)
strcntW proc frame
  push rsi
  .pushreg rsi
  .endprolog

  xor   rax, rax  ;set return value to 0
  test  rcx, rcx  ;zf = (rcx & rcx) == 0 ? 1 : 0 (check for nullptr)
  jz    e2        ;jump to end if zf == 1 (nullptr case)
  mov   rsi, rcx  ;rsi = string ptr
  xor   ecx, ecx  ;count = 0
  xor   r8d, r8d  ;use for occurrence (1 = found, 0 = not found)
l:
  lodsw           ;load next wchar_t into ax and increment rsi (point to next wchar_t)
  or    ax, ax    ;check for null wchar_t
  jz    e1        ;jump to end if ax == 0

  cmp   ax, dx    ;compare current wchar_t with c
  sete  r8b       ;r8b = (ax == dx) ? 1 : 0
  add   rcx, r8   ;add 1 (or 0) to counter
  jmp   l         ;next wchar_t
e1:
  mov   rax, rcx  ;move count to return reg
e2:
  pop   rsi
  ret
strcntW endp


;calculate length of RSI char string
;r10 = lenA(rsi)
LENA_RSI_R10 macro
  xor   r10, r10  ;len = 0
@@:
  lodsb           ;load next byte into al
  test  al, al    ;zf = (al & al) == 0 ? 1 : 0 (check for nullptr)
  jz    len_e1    ;jump to end if zf == 1 (nullptr case)
  inc   r10       ;count++
  jmp   @b        ;next char
len_e1:
endm

;calculate length of RSI char string
;r11 = lenA(rsi)
LENA_RSI_R11 macro
  xor   r11, r11  ;len = 0
@@:
  lodsb           ;load next byte into al
  test  al, al    ;zf = (al & al) == 0 ? 1 : 0 (check for nullptr)
  jz    len_e2    ;jump to end if zf == 1 (nullptr case)
  inc   r11       ;count++
  jmp   @b        ;next char
len_e2:
endm

;calculate length of RSI wchar_t string
;r10 = lenW(rsi)
LENW_RSI_R10 macro
  xor   r10, r10  ;len = 0
@@:
  lodsw           ;load next word into ax
  test  ax, ax    ;zf = (ax & ax) == 0 ? 1 : 0 (check for nullptr)
  jz    len_e3    ;jump to end if zf == 1 (nullptr case)
  inc   r10       ;count++
  jmp   @b        ;next wchar_t
len_e3:
endm

;calculate length of RSI wchar_t string
;r11 = lenW(rsi)
LENW_RSI_R11 macro
xor   r11d, r11d  ;len = 0
@@:
  lodsw           ;load next word into ax
  or    ax, ax    ;zf = (ax & ax) == 0 ? 1 : 0 (check for nullptr)
  jz    len_e4    ;jump to end if zf == 1 (nullptr case)
  inc   r11       ;count++
  jmp   @b        ;next wchar_t
len_e4:
endm


;check if 2 char strings are equal
;              rcx             rdx
;eax = strcmpA(const char* s1, const char* s2)
strcmpA proc frame
  push rsi
  .pushreg rsi
  push rdi
  .pushreg rdi
  .endprolog

  xor   eax, eax  ;set return value to 0 (assume not equal)
  cmp   rcx, rdx  ;zf = (s1 == s2) ? 1 : 0
  sete  al        ;al = (zf ==  1) ? 1 : 0
  je    e         ;jump to end if zf == 1 (pointers are equal)

  test  rcx, rcx  ;zf = (rcx & rcx) == 0 ? 1 : 0 (check for nullptr)
  jz    e         ;jump to end if zf == 1 (nullptr case)
  test  rdx, rdx  ;zf = (rdx & rdx) == 0 ? 1 : 0 (check for nullptr)
  jz    e         ;jump to end if zf == 1 (nullptr case)

  mov   rsi, rcx  ;rsi = s1
  LENA_RSI_R10    ;r10 = len(s1)
  mov   rsi, rdx  ;rsi = s2
  LENA_RSI_R11    ;r11 = len(s2)
  cmp   r10, r11  ;compare len(s1) with len(s2)
  jne   e         ;jump to end if len(s1) != len(s2)

  mov   rsi, rcx  ;rsi = s1
  mov   rdi, rdx  ;rdi = s2
  mov   rcx, r10  ;rcx = len (len1 equals len2 at this point)

  repe cmpsb
  ;while(byte pointed by rsi == byte pointed by rdi)
  ; rcx-- decrement counter
  ; rsi++ point to next s1 char
  ; rdi++ point to next s2 char
  setz  al        ;al = (zf != 0) 1 : 0
e:
  pop   rdi
  pop   rsi
  ret
strcmpA endp


;check if 2 wchar_t strings are equal
;              rcx                rdx
;eax = strcmpW(const wchar_t* s1, const wchar_t* s2)
strcmpW proc frame
  push rsi
  .pushreg rsi
  push rdi
  .pushreg rdi
  .endprolog

  xor   eax, eax  ;set return value to 0 (assume not equal)
  cmp   rcx, rdx  ;zf = (s1 == s2) ? 1 : 0
  sete  al        ;al = (zf ==  1) ? 1 : 0
  je    e         ;jump to end if zf == 1 (pointers are equal)

  test  rcx, rcx  ;zf = (rcx & rcx) == 0 ? 1 : 0 (check for nullptr)
  jz    e         ;jump to end if zf == 1 (nullptr case)
  test  rdx, rdx  ;zf = (rdx & rdx) == 0 ? 1 : 0 (check for nullptr)
  jz    e         ;jump to end if zf == 1 (nullptr case)

  mov   rsi, rcx  ;rsi = s1
  LENW_RSI_R10    ;r10 = len(s1)
  mov   rsi, rdx  ;rsi = s2
  LENW_RSI_R11    ;r11 = len(s2)
  cmp   r10, r11  ;compare len(s1) with len(s2)
  jne   e         ;jump to end if len(s1) != len(s2)

  mov   rsi, rcx  ;rsi = s1
  mov   rdi, rdx  ;rdi = s2
  mov   rcx, r10  ;rcx = len (len1 equals len2 at this point)

  repe cmpsw
  ;while(word pointed by rsi == word pointed by rdi)
  ; rcx-- decrement counter
  ; rsi++ point to next s1 char
  ; rdi++ point to next s2 char
  setz  al        ;al = (zf != 0) 1 : 0
e:
  pop   rdi
  pop   rsi
  ret
strcmpW endp


;concatenate char strings
;s = strcat(s1,s2)
;        rcx      rdx             r8
;strcatA(char* s, const char* s1, const char* s2)
strcatA proc frame
  push rsi
  .pushreg rsi
  push rdi
  .pushreg rdi
  .endprolog

  test  rcx, rcx    ;zf = (rcx == 0) ? 1 : 0
  jz    e           ;jump to end if zf == 1 (dest nullptr case)
  mov   rdi, rcx    ;edi = s  (destination)
s1:
  test  rdx, rdx    ;zf = (rdx & rdx) == 0 ? 1 : 0 (check for nullptr)
  je    s2          ;jump to process s2 zf == 1 (nullptr case)
  mov   rsi, rdx    ;rsi = s1
  LENA_RSI_R10      ;r10 = len(s1)
  mov   rsi, rdx    ;rsi = s1 (source)
  mov   ecx, r10d   ;ecx = len(s1)
  rep   movsb       ;copy s1
  ;while(ecx > 0)
  ; *edi++ = *esi++
  ; ecx--
s2:
  test  r8, r8      ;zf = (r8 & r8) == 0 ? 1 : 0 (check for nullptr)
  je    e           ;jump to end if zf == 1 (nullptr case)

  mov   rsi, r8     ;rsi = s2
  LENA_RSI_R11      ;r11 = len(s2)
  mov   rsi, r8     ;rsi = s2 (source)
  mov   ecx, r11d   ;ecx = len(s2)
  rep   movsb       ;copy s2
  ;while(ecx > 0)
  ; *edi++ = *esi++
  ; ecx--
e:
  ;write \0 at the end
  mov byte ptr [rdi], 0
  pop rdi
  pop rsi
  ret
strcatA endp


;concatenate wchar_t strings
;s = strcat(s1,s2)
;        rcx         rdx                r8
;strcatW(wchar_t* s, const wchar_t* s1, const wchar_t* s2)
strcatW proc frame
  push rsi
  .pushreg rsi
  push rdi
  .pushreg rdi
  .endprolog

  test  rcx, rcx    ;zf = (rcx == 0) ? 1 : 0
  jz    e           ;jump to end if zf == 1 (dest nullptr case)
  mov   rdi, rcx    ;edi = s  (destination)
s1:
  test  rdx, rdx    ;zf = (rdx & rdx) == 0 ? 1 : 0 (check for nullptr)
  je    s2          ;jump to process s2 zf == 1 (nullptr case)
  mov   rsi, rdx    ;rsi = s1
  LENW_RSI_R10      ;r10 = len(s1)
  mov   rsi, rdx    ;rsi = s1 (source)
  mov   ecx, r10d   ;ecx = len(s1)
  rep   movsw       ;copy s1
  ;while(ecx > 0)
  ; *edi++ = *esi++
  ; ecx--
s2:
  test  r8, r8      ;zf = (r8 & r8) == 0 ? 1 : 0 (check for nullptr)
  je    e           ;jump to end if zf == 1 (nullptr case)

  mov   rsi, r8     ;rsi = s2
  LENW_RSI_R11      ;r11 = len(s2)
  mov   rsi, r8     ;rsi = s2 (source)
  mov   ecx, r11d   ;ecx = len(s2)
  rep   movsw       ;copy s2
  ;while(ecx > 0)
  ; *edi++ = *esi++
  ; ecx--
e:
  ;write \0 at the end
  mov word ptr [rdi], 0
  pop rdi
  pop rsi
  ret
strcatW endp


;copy char string s2 to s1
;        rcx       rdx
;strcpyA(char* s1, const char* s2)
strcpyA proc frame
  push rsi
  .pushreg rsi
  push rdi
  .pushreg rdi
  .endprolog

  test  rcx, rcx  ;zf = (rcx == 0) ? 1 : 0
  jz    e         ;jump to end if zf == 1 (dest nullptr case)
  test  rdx, rdx  ;zf = (rdx == 0) ? 1 : 0
  jz    e         ;jump to end if zf == 1 (src nullptr case)

  mov   rsi, rdx  ;rsi = s2
  LENA_RSI_R10    ;r10 = len(s2)
  mov   rdi, rcx  ;rdi = dest pointer
  mov   rsi, rdx  ;rsi = src pointer
  mov   rcx, r10  ;rcx = count
  rep movsb
  ;while(rcx > 0)
  ; *rdi++ = *rsi++
  ; rcx--

  ;write '\0' at the end
  mov byte ptr[rdi], 0
e:
  pop rdi
  pop rsi
  ret
strcpyA endp


;copy wchar_t string s2 to s1
;        rcx          rdx
;strcpyW(wchar_t* s1, const wchar_t* s2)
strcpyW proc frame
  push rsi
  .pushreg rsi
  push rdi
  .pushreg rdi
  .endprolog

  or    rcx, rcx  ;zf = (rcx == 0) ? 1 : 0
  jz    e         ;jump to end if zf == 1 (dest ptr nullptr case)
  or    rdx, rdx  ;zf = (rdx == 0) ? 1 : 0
  jz    e         ;jump to end if zf == 1 (src ptr nullptr case)

  mov   rsi, rdx  ;rsi = s2
  LENW_RSI_R10    ;r10 = len(s2)
  mov   rdi, rcx  ;rdi = dest pointer
  mov   rsi, rdx  ;rsi = src pointer
  mov   rcx, r10  ;rcx = count
  rep movsw
  ;while(rcx > 0)
  ; *rdi++ = *rsi++
  ; rcx--

  ;write L'\0' at the end
  mov word ptr[rdi], 0
e:
  pop rdi
  pop rsi
  ret
strcpyW endp


;reverse char string
;       rcx
;strevA(char* str)
strevA proc frame
  push rsi
  .pushreg rsi
  .endprolog

  test  rcx, rcx        ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e               ;jump to end if zf == 1 (nullptr case)
  mov   rsi, rcx        ;rsi = str
  LENA_RSI_R10          ;r10 = len(rsi)
  cmp   r10, 1          ;if len <= 1 nothing to reverse
  jle   e
  add r10, rcx          ;r10 = &str[len]
  dec r10               ;r10 = &str[len-1] //off-by-one
l:
  mov al, byte ptr[rcx] ;al = str[a]
  mov dl, byte ptr[r10] ;dl = str[b]
  mov byte ptr[rcx], dl ;str[a] = dl
  mov byte ptr[r10], al ;str[b] = al

  inc rcx               ;next char
  dec r10               ;prev char
  cmp rcx, r10          ;check if indices didn't cross yet
  jl  l                 ;loop again if a < b
e:
  pop   rsi
  ret
strevA endp


;reverse wchar_t string
;       rcx
;strevW(wchar_t* str)
strevW proc frame
  push rsi
  .pushreg rsi
  .endprolog

  test  rcx, rcx        ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e               ;jump to end if zf == 1 (nullptr case)
  mov   rsi, rcx        ;rsi = str
  LENW_RSI_R10          ;r10 = len(rsi)
  cmp   r10, 1          ;if len <= 1 nothing to reverse
  jle   e
  shl r10, 1            ;r10 *= 2 because sizeof(wchar_t) == 2
  add r10, rcx          ;r10 = &str[len]
  sub r10, 2            ;r10 = &str[len-1] (off-by-one)
l:
  mov ax, word ptr[rcx] ;ax = str[a]
  mov dx, word ptr[r10] ;dx = str[b]
  mov word ptr[rcx], dx ;str[a] = dx
  mov word ptr[r10], ax ;str[b] = ax

  add rcx, 2            ;next wchar_t
  sub r10, 2            ;prev wchar_t
  cmp rcx, r10          ;check if indices didn't cross yet
  jl  l                 ;loop again if a < b
e:
  pop   rsi
  ret
strevW endp


;minimum of int32 array
;            rcx       edx
;eax = minvi(int* arr, int n)
minvi proc
  test  rcx, rcx          ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e                 ;jump to end if zf == 1 (nullptr case)
  cmp   edx, 1            ;check if n < 1
  jl    e                 ;jump to end if n < 1
  mov   eax, [rcx]        ;move first integer to eax assuming that's the min
  xor   r8,r8             ;index to address arr[i*4]
l:
  dec   edx               ;count--
  test  edx, edx          ;zf = (edx & edx) == 0 ? 1 : 0
  jz    e                 ;jump to end if zf == 1 (all integers processed)
  inc   r8                ;r8 = next int index
  mov   r10d, [rcx+r8*4]  ;r10d = next integer
  cmp   r10d, eax         ;compare a and b (if a < b then set zf = 0 and zf = 1)
  cmovl eax, r10d         ;conditional-move-less (move r10d to eax if zf == 0 and zf == 1)
  jmp   l                 ;next int
e:
  ret
minvi endp


;minimum of float array
;             rcx         edx
;xmm0 = minvf(float* arr, int n)
minvf proc
  test  rcx, rcx                  ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e                         ;jump to end if zf == 1 (nullptr case)
  cmp   edx, 1                    ;check if n < 1
  jl    e                         ;jump to end if n < 1
  movss xmm0, real4 ptr[rcx]      ;move first float to xmm0 assuming that's the min
  xor   r8,r8                     ;index to address arr[i*4]
l:
  dec   edx                       ;count--
  test  edx, edx                  ;zf = (rdx & rdx) == 0 ? 1 : 0
  jz    e                         ;jump to end if zf == 1 (all floats processed)
  inc   r8                        ;r8 = next float index
  movss xmm1, real4 ptr[rcx+r8*4] ;xmm1 = next float
  minss xmm0, xmm1                ;xmm0 = min(xmm0, xmm1)
  jmp   l                         ;next float
e:
  ret
minvf endp


;reverse array of int32
;      rcx       edx
;revvi(int* arr, int n)
revvi proc
  test  rcx, rcx          ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e                 ;jump to end if zf == 1 (nullptr case)
  cmp   edx, 1            ;check if n <= 1
  jle   e                 ;jump to end if so
  xor   rax, rax          ;arr[a=0  ]
  dec   rdx               ;arr[b=n-1]
l:
  mov   r8d, [rcx+rax*4]  ;r8d    = arr[a]
  mov   r10d,[rcx+rdx*4]  ;r10d   = arr[b]
  mov   [rcx+rax*4], r10d ;arr[a] = r10d
  mov   [rcx+rdx*4], r8d  ;arr[b] = r8d

  inc   rax               ;a++
  dec   rdx               ;b--
  cmp   rax, rdx          ;check if indices didn't cross yet
  jl    l                 ;loop again if a < b
e:
  ret
revvi endp


;reverse array of float
;      rcx         edx
;revvf(float* arr, int n)
revvf proc
  test rcx, rcx         ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz   e                ;jump to end if zf == 1 (nullptr case)
  cmp edx, 1            ;check if n <= 1
  jle  e                ;jump to end if so
  xor rax, rax          ;arr[a=0]
  dec rdx               ;arr[b=n-1]
l:
  mov r8d, [rcx+rax*4]  ;r8d    = arr[a]
  mov r10d,[rcx+rdx*4]  ;r10d   = arr[b]
  mov [rcx+rax*4], r10d ;arr[a] = r10d
  mov [rcx+rdx*4], r8d  ;arr[b] = r8d

  inc rax               ;a++
  dec rdx               ;b--
  cmp rax, rdx          ;check if indices didn't cross yet
  jl  l                 ;loop again if a < b
e:
  ret
revvf endp


;sort array of int32
;      rcx       edx
;sorti(int* arr, int n)
sorti proc
  test rcx, rcx       ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz   e              ;jump to end if zf == 1 (nullptr case)
  cmp edx, 1          ;check if n <= 1
  jle  e              ;jump to end if so

  ;for(i = 0; i < N; i++)
  ; for(j = i+1; j < N; j++)
  ;   if(arr[i] < arr[j])
  ;     swap
  xor r8d, r8d        ;i = 0

l1:
  cmp r8d, edx        ;i <= N ?
  jge e               ;jump to end if outer loop done
  mov eax, [rcx+r8*4] ;eax = arr[i]
  mov r9d, r8d        ;r8d = i
  inc r9d             ;r9d = i+1
l2:
  cmp r9d, edx        ;j <= N? inner loop done
  jl  il              ;if not do another inner loop iter
  mov [rcx+r8*4], eax ;save min to arr[i]
  inc r8d             ;i++
  jmp l1              ;another outer loop iter
il:
  cmp eax, [rcx+r9*4] ;compare arr[i] with arr[j]
  jg s                ;if greater jump to swap
  inc r9d             ;j++
  jmp l2              ;next inner loop iter
s:
  mov r10d,[rcx+r9*4] ;r10d = arr[j]
  mov [rcx+r9*4], eax ;arr[j] = eax
  mov eax, r10d       ;eax = r10d
  inc r9d             ;j++
  jmp l2              ;another inner iter
e:
  ret
sorti endp


;call function for every element in the array
;      rcx       rdx    r8
;visit(int* arr, int n, void(*fptr)(int& x))
visit proc
  sub rsp, 20h

  test  rcx, rcx      ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e             ;jump to end if zf == 1 (nullptr case)
  test r8, r8         ;zf = (r8 & r8) == 0 ? 1 : 0
  jz    e             ;jump to end if zf == 1 (nullptr case)
  cmp   rdx, 0        ;check if n >= 0
  jle   e
l:
  dec   edx           ;count--
  cmp   edx, 0        ;check if al items processed
  jl    e

  mov   [rsp+ 8], rcx ;save rcx
  mov   [rsp+16], edx ;save rdx
  mov   [rsp+24], r8  ;save r8
  call  r8            ;invoke fptr
  mov   rcx, [rsp+ 8] ;restore rcx
  mov   edx, [rsp+16] ;restore rdx
  mov   r8,  [rsp+24] ;restore r8
  add   rcx, 4        ;point to next integer
  jmp   l             ;again
e:
  add rsp, 20h
  ret
visit endp


; struct ll_node
; {
;   int x;
;   ll_node* next;
; }

;insert a new node in the list
;          rcx             edx
;ll_insert(ll_node*& head, int value)
ll_insert proc
  mov [rsp+ 8], rcx         ;save head
  mov [rsp+16], edx         ;save value

  mov   rcx, 16             ;sizeof(ll_node) = 16
  sub   rsp, 28h            ;stack space for malloc
  call  [__imp_malloc]      ;rax = malloc(16)
  add   rsp, 28h            ;free stack space for malloc
  mov   edx, [rsp+16]       ;edx = value
  mov   dword ptr[rax], edx ;new_node->value = edx
  mov   qword ptr[rax+8], 0 ;new_node->next = nullptr

  mov   rcx, [rsp+8]        ;rcx = &head
  mov   rdx, [rcx]          ;rdx = head
  test  rdx, rdx            ;zf = (rdx & rdx) == 0 ? 1 : 0
  jnz   notnull             ;head node !nullptr

  mov   [rcx], rax          ;head node nullptr: just set root = new_node
  ret

  ;while(iter != nullptr)
  ; iter = iter->next
notnull:
  mov   rcx, [rdx+8]        ;fetch iter->next
  test  rcx, rcx            ;zf = (rcx & rcx) == 0 ? 1 : 0 (check for nullptr)
  je    e                   ;jump to end if zf == 1 (iter->next is null e.g. iter is the tail)
  mov   rdx, rcx            ;iter = iter->next
  jmp   notnull             ;another iter
e:
  mov  [rdx+8], rax         ;assign new_node to tail (iter->next = rax)
  ret
ll_insert endp


;delete all nodes in the list
;        rcx
;ll_free(ListNode*& head)
ll_free proc
  mov   [rsp+ 8], rcx     ;save head
  mov   [rsp+16], rbx     ;save rbx (non-volatile)

  mov   rdx, rcx          ;rdx = &head
  mov   rcx, [rdx]        ;rcx = head
@@:
  test  rcx, rcx          ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    @f                ;jump to next label if zf == 1 (nullptr case)
  mov   rbx, [rcx+8]      ;rbx = iter->next
  sub   rsp, 28h
  call [__imp_free]       ;free(iter)
  add   rsp, 28h
  mov   rcx, rbx          ;rcx = iter->next
  jmp   @b                ;next
@@:
  mov   rcx, [rsp+8]      ;rcx = &head
  mov   qword ptr[rcx], 0 ;set n = 0 (to avoid n!=nullptr in case of double-delete)
  mov   rbx, [rsp+16]     ;restore rbx (non-volatile)
  ret
ll_free endp


;calculate list length
;                rcx
;eax = ll_length(ListNode* head)
ll_length proc
  xor   rax, rax      ;set return value to 0
@@:
  test  rcx, rcx      ;zf = (rcx & rcx) == 0 ? 1 : 0
  je    e             ;jump to end if zf == 1 (nullptr case)
  inc   rax           ;count++
  mov   rdx, rcx      ;edx = iter
  mov   rcx, [rdx+8]  ;rcx = iter->next
  jmp   @b            ;next
e:
  ret
ll_length endp


;find a node in the list (return ptr to node)
;              rcx             edx
;rax = ll_find(ListNode* head, int value)
ll_find proc
  mov   rax, rcx            ;set current node as return address
@@:
  test  rax, rax            ;zf = (rax & rax) == 0 ? 1 : 0
  je    e                   ;jump to end if zf == 1 (nullptr)
  mov   ecx, dword ptr[rax] ;read current->value
  cmp   ecx, edx            ;compare with value
  je    e                   ;jump to end if found (rax = current address already)
  mov   rcx, rax            ;rcx = current
  mov   rax, [rcx+8]        ;rax = fetch current->next
  jmp   @b                  ;process next node
e:
  ret
ll_find endp


;reverse a linked list
;           rcx
;ll_reverse(ListNode*& head)
ll_reverse proc
  xor   r8, r8      ;r8 used for previous node
  xor   r9, r9      ;r9 used for next node
  mov   rdx, [rcx]  ;rdx = current
@@:
  test  rdx, rdx    ;zf = (rdx & rdx) == 0 ? 1 : 0
  jz    e           ;jump to end if zf == 1 (nullptr)

  mov r9, [rdx+8]   ;next = current->next
  mov [rdx+8], r8   ;current->next = prev
  mov r8, rdx       ;previous = current
  mov rdx, r9       ;current = next
  jmp @b            ;again
e:
  mov [rcx], r8     ;head = previous (update head)
  ret
ll_reverse endp


;remove a node from linked list
;          rcx              rdx
;ll_remove(ListNode*& head, Node* n)
ll_remove proc
  mov   r8, [rcx]
  test  r8, r8        ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e             ;jump to end if zf == 1 (empty list)
  test  rdx, rdx      ;zf = (rdx & rdx) == 0 ? 1 : 0
  jz    e             ;jump to end if zf == 1 (n = nullptr)
  cmp   r8, rdx       ;compare (root == n)
  jne   neq           ;jump to neq if root != n

  ;if reaching this point then head == n
  mov   r9, [r8+8]    ;fetch head->next
  mov   [rcx], r9     ;overwrite head = head->next

  mov   rcx, rdx      ;rcx = head address
  sub   rsp, 28h      ;make space for free
  call  [__imp_free]  ;free(n)
  add   rsp, 28h      ;clean space for free
  ret                 ;done

neq:                  ;head != n (loop till find the node)
  mov   rcx, r8       ;rcx = head
@@:
  mov   rax, rcx      ;rax = iter
  mov   rcx, [rax+8]  ;rcx = iter->next
  test  rcx, rcx      ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e             ;end of the list nothing found (e.g. in case of double deletion)
  cmp   rcx, rdx      ;iter->next == n
  jne   @b            ;next node if not equal

  ;at this point iter->next == n
  mov   r8, [rcx+8]   ;r8 = iter->next->next
  mov   [rax+8], r8   ;r9 = iter->next = iter->next->next

  mov   rcx, rdx      ;rcx = iter->next to be deleted
  sub   rsp, 28h      ;make space for free
  call  [__imp_free]  ;free(iter->next)
  add   rsp, 28h      ;clean space for free
e:
  ret
ll_remove endp


; struct bt_node
; {
;   int value;
;   bt_node* left;
;   bt_node* right;
; }

;insert a node into binary tree
;          rcx             edx
;bt_insert(bt_node*& root, int value)
bt_insert proc
  mov   [rsp+ 8], rcx         ;save root
  mov   [rsp+16], edx         ;save value

  mov   rcx, 24               ;sizeof(bt_node) == 28
  sub   rsp, 28h              ;make space for malloc
  call  [__imp_malloc]        ;eax = malloc()
  add   rsp, 28h              ;clean space for malloc

  mov   rcx, [rsp+8]          ;restore &root
  test  rax, rax              ;zf = (rax & rax) == 0 ? 1 : 0
  jz    e                     ;malloc failed

  mov   edx, [rsp+16]         ;restore value
  mov   [rax], edx            ;set value for new node
  mov   qword ptr[rax+8], 0   ;set left for new node
  mov   qword ptr[rax+16], 0  ;set right for new node
l:
  mov   r8, [rcx]             ;fetch root
  test  r8, r8                ;zf = (rax & rax) == 0 ? 1 : 0
  jz    e                     ;found null node
  mov   r9d, [r8]             ;read node->value
  cmp   edx, r9d              ;compare against value
  jg    r                     ;greater must go right
  mov   rcx, r8               ;node address to rcx
  add   rcx, 8                ;node = node->left
  jmp l                       ;again
r:
  mov   rcx, r8               ;node address to rcx
  add   rcx, 16               ;node = node->right
  jmp l
e:
  ;found null node so make it new node
  mov qword ptr[rcx], rax
  ret
bt_insert endp


;find a node in a binary tree (return ptr to node)
;              rcx            edx
;rax = bt_find(bt_node* root, int value)
bt_find proc
  xor   rax, rax    ;set return value to 0
l:
  test  rcx, rcx    ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e           ;root is null

  mov   eax, [rcx]  ;read node->value
  cmp   edx, eax    ;compare against value
  je    e           ;found
  jg    r           ;greater should be on the righty

  mov r8, [rcx+8]   ;read node->left
  mov rcx, r8       ;ecx = node->left
  jmp l             ;again
r:
  mov r8, [rcx+16]  ;read node->right
  mov rcx, r8       ;ecx = node->right
  jmp l             ;again
e:
  mov rax, rcx      ;assign return address
  ret
bt_find endp


;delete a binary tree
;        rcx
;bt_free(bt_node*& root)
bt_free proc
  sub   rsp, 20h
  mov   [rsp+8], rcx      ;save &root
  mov   rcx, [rcx]        ;fetch root
  test  rcx, rcx          ;zf = (rcx & rcx) == 0 ? 1 : 0
  jz    e                 ;null node

  add   rcx, 8            ;rcx = node->left
  call  bt_free           ;call function on node->left

  mov   rcx, [rsp+8]      ;restore &node
  mov   rcx, [rcx]        ;fetch node
  add   rcx, 16           ;rcx = node->right
  call  bt_free           ;call function on node->right

  mov   rcx, [rsp+8]      ;restore &node
  mov   rcx, [rcx]        ;fetch node
  sub   rsp, 28h          ;make space for free()
  call  [__imp_free]      ;free memory
  add   rsp, 28h          ;clean space for free()
  mov   rcx, [rsp+8]      ;restore &node
  mov   qword ptr[rcx], 0 ;make node nullptr
e:
  add rsp, 20h
  ret
bt_free endp


;calculate vec3f length
;                rcx  rcx+4 rcx+8
;                 x     y     z
;xmm0 = vec3f_len(const vec3f& v)
vec3f_len proc
  movss   xmm0, real4 ptr[rcx]    ;xmm0 = x
  movss   xmm1, real4 ptr[rcx+4]  ;xmm1 = y
  movss   xmm2, real4 ptr[rcx+8]  ;xmm2 = z
  mulss   xmm0, xmm0              ;xmm0 = xmm0*xmm0 = x*x
  mulss   xmm1, xmm1              ;xmm1 = xmm1*xmm1 = y*y
  mulss   xmm2, xmm2              ;xmm2 = xmm2*xmm2 = z*z
  addss   xmm0, xmm1              ;xmm0 = xmm0+xmm1 = x*x + y*y
  addss   xmm0, xmm2              ;xmm0 = xmm0+xmm2 = x*x + y*y + z*z
  sqrtss  xmm0, xmm0              ;xmm0 = sqrtf(x*x + y*y + z*z)
  ret
vec3f_len endp


;calculate vec3f length avx
;                 rcx  rcx+4 rcx+8
;                  x     y     z
;xmm0 = vec3f_lenx(const vec3f& v)
vec3f_lenx proc
  vmovss    xmm0, real4 ptr[rcx]    ;xmm0 = x
  vmovss    xmm1, real4 ptr[rcx+4]  ;xmm1 = y
  vmovss    xmm2, real4 ptr[rcx+8]  ;xmm2 = z
  vmulss    xmm0, xmm0, xmm0        ;xmm0 = xmm0*xmm0 = x*x
  vmulss    xmm1, xmm1, xmm1        ;xmm1 = xmm1*xmm1 = y*y
  vmulss    xmm2, xmm2, xmm2        ;xmm2 = xmm2*xmm2 = z*z
  vaddss    xmm0, xmm1, xmm0        ;xmm0 = xmm0+xmm1 = x*x + y*y
  vaddss    xmm0, xmm2, xmm0        ;xmm0 = xmm0+xmm2 = x*x + y*y + z*z
  vsqrtss   xmm0, xmm0, xmm0        ;xmm0 = sqrtf(x*x + y*y + z*z)
  vzeroupper
  ret
vec3f_lenx endp


;calculate vec3d length
;                rcx  rcx+8 rcx+16
;                 x     y     z
;xmm0 = vec3d_len(const vec3f& v)
vec3d_len proc
  movsd   xmm0, real8 ptr[rcx]    ;xmm0 = x
  movsd   xmm1, real8 ptr[rcx+8]  ;xmm1 = y
  movsd   xmm2, real8 ptr[rcx+16] ;xmm2 = z
  mulsd   xmm0, xmm0              ;xmm0 = xmm0*xmm0 = x*x
  mulsd   xmm1, xmm1              ;xmm1 = xmm1*xmm1 = y*y
  mulsd   xmm2, xmm2              ;xmm2 = xmm2*xmm2 = z*z
  addsd   xmm0, xmm1              ;xmm0 = xmm0+xmm1 = x*x + y*y
  addsd   xmm0, xmm2              ;xmm0 = xmm0+xmm2 = x*x + y*y + z*z
  sqrtsd  xmm0, xmm0              ;xmm0 = sqrtf(x*x + y*y + z*z)
  ret
vec3d_len endp


;calculate vec3d length avx
;                 rcx  rcx+8 rcx+16
;                  x     y     z
;xmm0 = vec3d_lenx(const vec3f& v)
vec3d_lenx proc
  vmovsd    xmm0, real8 ptr[rcx]    ;xmm0 = x
  vmovsd    xmm1, real8 ptr[rcx+8]  ;xmm1 = y
  vmovsd    xmm2, real8 ptr[rcx+16] ;xmm2 = z
  vmulsd    xmm0, xmm0, xmm0        ;xmm0 = xmm0*xmm0 = x*x
  vmulsd    xmm1, xmm1, xmm1        ;xmm1 = xmm1*xmm1 = y*y
  vmulsd    xmm2, xmm2, xmm2        ;xmm2 = xmm2*xmm2 = z*z
  vaddsd    xmm0, xmm1, xmm0        ;xmm0 = xmm0+xmm1 = x*x + y*y
  vaddsd    xmm0, xmm2, xmm0        ;xmm0 = xmm0+xmm2 = x*x + y*y + z*z
  vsqrtsd   xmm0, xmm0, xmm0        ;xmm0 = sqrtf(x*x + y*y + z*z)
  vzeroupper
  ret
vec3d_lenx endp


;compute distance vec3f
;                 rcx  rcx+4  rcx+8  rdx  rdx+4  rdx+8
;                  x     y     z      x     y     z
;xmm0 = vec3f_dist(const vec3f& a,   const vec3f& b)
vec3f_dist proc
  movss   xmm0, real4 ptr[rcx]    ;xmm0 = a.x
  movss   xmm1, real4 ptr[rcx+4]  ;xmm1 = a.y
  movss   xmm2, real4 ptr[rcx+8]  ;xmm2 = a.z
  subss   xmm0, real4 ptr[rdx]    ;xmm0 = a.x - b.x
  subss   xmm1, real4 ptr[rdx+4]  ;xmm0 = a.y - b.y
  subss   xmm2, real4 ptr[rdx+8]  ;xmm0 = a.z - b.z
  mulss   xmm0, xmm0              ;xmm0 = dx*dx
  mulss   xmm1, xmm1              ;xmm1 = dy*dy
  mulss   xmm2, xmm2              ;xmm2 = dz*dz
  addss   xmm0, xmm1              ;xmm0 = dx*dx + dy*dy
  addss   xmm0, xmm2              ;xmm0 = dx*dx + dy*dy + dz*dz
  sqrtss  xmm0, xmm0              ;xmm0 = sqrt(dx*dx + dy*dy + dz*dz)
  ret
vec3f_dist endp


;compute distance vec3f avx
;                  rcx  rcx+4  rcx+8  rdx  rdx+4  rdx+8
;                   x     y     z      x     y     z
;xmm0 = vec3f_distx(const vec3f& a,   const vec3f& b)
vec3f_distx proc
  vmovss    xmm0, real4 ptr[rcx]          ;xmm0 = a.x
  vmovss    xmm1, real4 ptr[rcx+4]        ;xmm1 = a.y
  vmovss    xmm2, real4 ptr[rcx+8]        ;xmm2 = a.z
  vsubss    xmm0, xmm0, real4 ptr[rdx]    ;xmm0 = a.x - b.x
  vsubss    xmm1, xmm1, real4 ptr[rdx+4]  ;xmm0 = a.y - b.y
  vsubss    xmm2, xmm2, real4 ptr[rdx+8]  ;xmm0 = a.z - b.z
  vmulss    xmm0, xmm0, xmm0              ;xmm0 = dx*dx
  vmulss    xmm1, xmm1, xmm1              ;xmm1 = dy*dy
  vmulss    xmm2, xmm2, xmm2              ;xmm2 = dz*dz
  vaddss    xmm0, xmm0, xmm1              ;xmm0 = dx*dx + dy*dy
  vaddss    xmm0, xmm0, xmm2              ;xmm0 = dx*dx + dy*dy + dz*dz
  vsqrtss   xmm0, xmm0, xmm0              ;xmm0 = sqrt(dx*dx + dy*dy + dz*dz)
  vzeroupper
  ret
vec3f_distx endp


;compute distance vec3d
;                 rcx  rcx+8  rcx+16 rdx  rdx+8  rdx+16
;                  x     y     z      x     y     z
;xmm0 = vec3d_dist(const vec3d& a,   const vec3d& b)
vec3d_dist proc
  movsd   xmm0, real8 ptr[rcx]    ;xmm0 = a.x
  movsd   xmm1, real8 ptr[rcx+8]  ;xmm1 = a.y
  movsd   xmm2, real8 ptr[rcx+16] ;xmm2 = a.z
  subsd   xmm0, real8 ptr[rdx]    ;xmm0 = a.x - b.x
  subsd   xmm1, real8 ptr[rdx+8]  ;xmm0 = a.y - b.y
  subsd   xmm2, real8 ptr[rdx+16] ;xmm0 = a.z - b.z
  mulsd   xmm0, xmm0              ;xmm0 = dx*dx
  mulsd   xmm1, xmm1              ;xmm1 = dy*dy
  mulsd   xmm2, xmm2              ;xmm2 = dz*dz
  addsd   xmm0, xmm1              ;xmm0 = dx*dx + dy*dy
  addsd   xmm0, xmm2              ;xmm0 = dx*dx + dy*dy + dz*dz
  sqrtsd  xmm0, xmm0              ;xmm0 = sqrt(dx*dx + dy*dy + dz*dz)
  ret
vec3d_dist endp


;compute distance vec3d avx
;                  rcx  rcx+8  rcx+16 rdx  rdx+8  rdx+16
;                   x     y     z      x     y     z
;xmm0 = vec3d_distx(const vec3d& a,   const vec3d& b)
vec3d_distx proc
  vmovsd    xmm0, real8 ptr[rcx]          ;xmm0 = a.x
  vmovsd    xmm1, real8 ptr[rcx+8]        ;xmm1 = a.y
  vmovsd    xmm2, real8 ptr[rcx+16]       ;xmm2 = a.z
  vsubsd    xmm0, xmm0, real8 ptr[rdx]    ;xmm0 = a.x - b.x
  vsubsd    xmm1, xmm1, real8 ptr[rdx+8]  ;xmm0 = a.y - b.y
  vsubsd    xmm2, xmm2, real8 ptr[rdx+16] ;xmm0 = a.z - b.z
  vmulsd    xmm0, xmm0, xmm0              ;xmm0 = dx*dx
  vmulsd    xmm1, xmm1, xmm1              ;xmm1 = dy*dy
  vmulsd    xmm2, xmm2, xmm2              ;xmm2 = dz*dz
  vaddsd    xmm0, xmm0, xmm1              ;xmm0 = dx*dx + dy*dy
  vaddsd    xmm0, xmm0, xmm2              ;xmm0 = dx*dx + dy*dy + dz*dz
  vsqrtsd   xmm0, xmm0, xmm0              ;xmm0 = sqrt(dx*dx + dy*dy + dz*dz)
  vzeroupper
  ret
vec3d_distx endp


;dot product vec3f
;                 rcx             rdx
;xmm0 = vec3f_dot(const vec3f& a, const vec3f& b)
vec3f_dot proc
  movss   xmm0, real4 ptr[rcx]    ;xmm0 = a.x
  mulss   xmm0, real4 ptr[rdx]    ;xmm0 = a.x*b.x
  movss   xmm1, real4 ptr[rcx+4]  ;xmm1 = a.y
  mulss   xmm1, real4 ptr[rdx+4]  ;xmm1 = a.y*b.y
  movss   xmm2, real4 ptr[rcx+8]  ;xmm2 = a.z
  mulss   xmm2, real4 ptr[rdx+8]  ;xmm2 = a.z*b.z
  addss   xmm0, xmm1              ;xmm0 = a.x*b.x + a.y*b.y
  addss   xmm0, xmm2              ;xmm0 = a.x*b.x + a.y*b.y + a.z*b.z
  ret
vec3f_dot endp


;dot product vec3f avx
;                  rcx             rdx
;xmm0 = vec3f_dotx(const vec3f& a, const vec3f& b)
vec3f_dotx proc
  vmovss  xmm0, real4 ptr[rcx]          ;xmm0 = a.x
  vmulss  xmm0, xmm0, real4 ptr[rdx]    ;xmm0 = a.x*b.x
  vmovss  xmm1, real4 ptr[rcx+4]        ;xmm1 = a.y
  vmulss  xmm1, xmm1, real4 ptr[rdx+4]  ;xmm1 = a.y*b.y
  vmovss  xmm2, real4 ptr[rcx+8]        ;xmm2 = a.z
  vmulss  xmm2, xmm2, real4 ptr[rdx+8]  ;xmm2 = a.z*b.z
  vaddss  xmm0, xmm0, xmm1              ;xmm0 = a.x*b.x + a.y*b.y
  vaddss  xmm0, xmm0, xmm2              ;xmm0 = a.x*b.x + a.y*b.y + a.z*b.z
  vzeroupper
  ret
vec3f_dotx endp


;dot product vec3d
;                 rcx             rdx
;xmm0 = vec3d_dot(const vec3d& a, const vec3d& b)
vec3d_dot proc
  movsd   xmm0, real8 ptr[rcx]    ;xmm0 = a.x
  mulsd   xmm0, real8 ptr[rdx]    ;xmm0 = a.x*b.x
  movsd   xmm1, real8 ptr[rcx+8]  ;xmm1 = a.y
  mulsd   xmm1, real8 ptr[rdx+8]  ;xmm1 = a.y*b.y
  movsd   xmm2, real8 ptr[rcx+16] ;xmm2 = a.z
  mulsd   xmm2, real8 ptr[rdx+16] ;xmm2 = a.z*b.z
  addsd   xmm0, xmm1              ;xmm0 = a.x*b.x + a.y*b.y
  addsd   xmm0, xmm2              ;xmm0 = a.x*b.x + a.y*b.y + a.z*b.z
  ret
vec3d_dot endp


;dot product vec3d avx
;                 rcx             rdx
;xmm0 = vec3d_dotx(const vec3d& a, const vec3d& b)
vec3d_dotx proc
  vmovsd  xmm0, real8 ptr[rcx]          ;xmm0 = a.x
  vmulsd  xmm0, xmm0, real8 ptr[rdx]    ;xmm0 = a.x*b.x
  vmovsd  xmm1, real8 ptr[rcx+8]        ;xmm1 = a.y
  vmulsd  xmm1, xmm1, real8 ptr[rdx+8]  ;xmm1 = a.y*b.y
  vmovsd  xmm2, real8 ptr[rcx+16]       ;xmm2 = a.z
  vmulsd  xmm2, xmm2, real8 ptr[rdx+16] ;xmm2 = a.z*b.z
  vaddsd  xmm0, xmm0, xmm1              ;xmm0 = a.x*b.x + a.y*b.y
  vaddsd  xmm0, xmm0, xmm2              ;xmm0 = a.x*b.x + a.y*b.y + a.z*b.z
  vzeroupper
  ret
vec3d_dotx endp


;sum vec3f
;                rcx             rdx             r8
;rax = vec3f_sum(return_storage, const vec3f& a, const vec3f& b)
vec3f_sum proc
  movss   xmm0, real4 ptr[rdx]    ;xmm0 = a.x
  addss   xmm0, real4 ptr[r8 ]    ;xmm0 = a.x+b.x
  movss   xmm1, real4 ptr[rdx+4]  ;xmm1 = a.y
  addss   xmm1, real4 ptr[r8 +4]  ;xmm1 = a.y+b.y
  movss   xmm2, real4 ptr[rdx+8]  ;xmm2 = a.z
  addss   xmm2, real4 ptr[r8 +8]  ;xmm2 = a.z+b.z
  movss   real4 ptr[rcx  ], xmm0  ;return_storage.x = xmm0
  movss   real4 ptr[rcx+4], xmm1  ;return_storage.y = xmm1
  movss   real4 ptr[rcx+8], xmm2  ;return_storage.z = xmm2
  mov rax, rcx                    ;return address of temp storage to rax
  ret
vec3f_sum endp


;sum vec3f avx
;                 rcx             rdx             r8
;rax = vec3f_sumx(return_storage, const vec3f& a, const vec3f& b)
vec3f_sumx proc
  vmovss    xmm0, real4 ptr[rdx]          ;xmm0 = a.x
  vaddss    xmm0, xmm0, real4 ptr[r8 ]    ;xmm0 = a.x+b.x
  vmovss    xmm1, real4 ptr[rdx+4]        ;xmm1 = a.y
  vaddss    xmm1, xmm1, real4 ptr[r8 +4]  ;xmm1 = a.y+b.y
  vmovss    xmm2, real4 ptr[rdx+8]        ;xmm2 = a.z
  vaddss    xmm2, xmm2, real4 ptr[r8 +8]  ;xmm2 = a.z+b.z
  vmovss    real4 ptr[rcx  ], xmm0        ;return_storage.x = xmm0
  vmovss    real4 ptr[rcx+4], xmm1        ;return_storage.y = xmm1
  vmovss    real4 ptr[rcx+8], xmm2        ;return_storage.z = xmm2
  vzeroupper
  mov rax, rcx                            ;return address of temp storage to rax
  ret
vec3f_sumx endp


;sum vec3d
;                rcx             rdx             r8
;rax = vec3d_sum(return_storage, const vec3d& a, const vec3d& b)
vec3d_sum proc
  movsd   xmm0, real8 ptr[rdx]    ;xmm0 = a.x
  addsd   xmm0, real8 ptr[r8 ]    ;xmm0 = a.x+b.x
  movsd   xmm1, real8 ptr[rdx+8]  ;xmm1 = a.y
  addsd   xmm1, real8 ptr[r8 +8]  ;xmm1 = a.y+b.y
  movsd   xmm2, real8 ptr[rdx+16] ;xmm2 = a.z
  addsd   xmm2, real8 ptr[r8 +16] ;xmm2 = a.z+b.z
  movsd   real8 ptr[rcx  ], xmm0  ;return_storage.x = xmm0
  movsd   real8 ptr[rcx+8], xmm1  ;return_storage.y = xmm1
  movsd   real8 ptr[rcx+16], xmm2 ;return_storage.z = xmm2
  mov rax, rcx                    ;return address of temp storage to rax
  ret
vec3d_sum endp


;sum vec3d avx
;                 rcx             rdx             r8
;rax = vec3d_sumx(return_storage, const vec3d& a, const vec3d& b)
vec3d_sumx proc
  vmovsd    xmm0, real8 ptr[rdx]          ;xmm0 = a.x
  vaddsd    xmm0, xmm0, real8 ptr[r8 ]    ;xmm0 = a.x+b.x
  vmovsd    xmm1, real8 ptr[rdx+8]        ;xmm1 = a.y
  vaddsd    xmm1, xmm1, real8 ptr[r8 +8]  ;xmm1 = a.y+b.y
  vmovsd    xmm2, real8 ptr[rdx+16]       ;xmm2 = a.z
  vaddsd    xmm2, xmm2, real8 ptr[r8 +16] ;xmm2 = a.z+b.z
  vmovsd    real8 ptr[rcx  ], xmm0        ;return_storage.x = xmm0
  vmovsd    real8 ptr[rcx+8], xmm1        ;return_storage.y = xmm1
  vmovsd    real8 ptr[rcx+16], xmm2       ;return_storage.z = xmm2
  vzeroupper
  mov rax, rcx                            ;return address of temp storage to rax
  ret
vec3d_sumx endp


;sub vec3f
;                rcx             rdx             r8
;rax = vec3f_sub(return_storage, const vec3f& a, const vec3f& b)
vec3f_sub proc
  movss   xmm0, real4 ptr[rdx]    ;xmm0 = a.x
  subss   xmm0, real4 ptr[r8 ]    ;xmm0 = a.x-b.x
  movss   xmm1, real4 ptr[rdx+4]  ;xmm1 = a.y
  subss   xmm1, real4 ptr[r8 +4]  ;xmm1 = a.y-b.y
  movss   xmm2, real4 ptr[rdx+8]  ;xmm2 = a.z
  subss   xmm2, real4 ptr[r8 +8]  ;xmm2 = a.z-b.z
  movss   real4 ptr[rcx  ], xmm0  ;return_storage.x = xmm0
  movss   real4 ptr[rcx+4], xmm1  ;return_storage.y = xmm1
  movss   real4 ptr[rcx+8], xmm2  ;return_storage.z = xmm2
  mov rax, rcx
  ret
vec3f_sub endp


;sub vec3f avx
;                 rcx             rdx             r8
;rax = vec3f_subx(return_storage, const vec3f& a, const vec3f& b)
vec3f_subx proc
  vmovss    xmm0, real4 ptr[rdx]          ;xmm0 = a.x
  vsubss    xmm0, xmm0, real4 ptr[r8 ]    ;xmm0 = a.x-b.x
  vmovss    xmm1, real4 ptr[rdx+4]        ;xmm1 = a.y
  vsubss    xmm1, xmm1, real4 ptr[r8 +4]  ;xmm1 = a.y-b.y
  vmovss    xmm2, real4 ptr[rdx+8]        ;xmm2 = a.z
  vsubss    xmm2, xmm2, real4 ptr[r8 +8]  ;xmm2 = a.z-b.z
  vmovss    real4 ptr[rcx  ], xmm0        ;return_storage.x = xmm0
  vmovss    real4 ptr[rcx+4], xmm1        ;return_storage.y = xmm1
  vmovss    real4 ptr[rcx+8], xmm2        ;return_storage.z = xmm2
  vzeroupper
  mov rax, rcx
  ret
vec3f_subx endp


;sub vec3d
;                rcx             rdx             r8
;rax = vec3d_sub(return_storage, const vec3f& a, const vec3f& b)
vec3d_sub proc
  movsd   xmm0, real8 ptr[rdx]    ;xmm0 = a.x
  subsd   xmm0, real8 ptr[r8 ]    ;xmm0 = a.x-b.x
  movsd   xmm1, real8 ptr[rdx+8]  ;xmm1 = a.y
  subsd   xmm1, real8 ptr[r8 +8]  ;xmm1 = a.y-b.y
  movsd   xmm2, real8 ptr[rdx+16] ;xmm2 = a.z
  subsd   xmm2, real8 ptr[r8 +16] ;xmm2 = a.z-b.z
  movsd   real8 ptr[rcx], xmm0    ;return_storage.x = xmm0
  movsd   real8 ptr[rcx+8], xmm1  ;return_storage.y = xmm1
  movsd   real8 ptr[rcx+16], xmm2 ;return_storage.z = xmm2
  mov rax, rcx
  ret
vec3d_sub endp


;sub vec3d avx
;                 rcx             rdx             r8
;rax = vec3d_subx(return_storage, const vec3f& a, const vec3f& b)
vec3d_subx proc
  vmovsd    xmm0, real8 ptr[rdx]          ;xmm0 = a.x
  vsubsd    xmm0, xmm0, real8 ptr[r8 ]    ;xmm0 = a.x-b.x
  vmovsd    xmm1, real8 ptr[rdx+8]        ;xmm1 = a.y
  vsubsd    xmm1, xmm1, real8 ptr[r8+8]   ;xmm1 = a.y-b.y
  vmovsd    xmm2, real8 ptr[rdx+16]       ;xmm2 = a.z
  vsubsd    xmm2, xmm2, real8 ptr[r8+16]  ;xmm2 = a.z-b.z
  vmovsd    real8 ptr[rcx], xmm0          ;return_storage.x = xmm0
  vmovsd    real8 ptr[rcx+8], xmm1        ;return_storage.y = xmm1
  vmovsd    real8 ptr[rcx+16], xmm2       ;return_storage.z = xmm2
  vzeroupper
  mov rax, rcx
  ret
vec3d_subx endp


;cross product vec3f
;                  rcx             rdx             r8
;rax = vec3f_cross(return_storage, const vec3f& a, const vec3f& b)
vec3f_cross proc
  movss   xmm0, real4 ptr[rdx+4]  ;xmm0 = a.y
  mulss   xmm0, real4 ptr[r8+8]   ;xmm0 = a.y*b.z
  movss   xmm1, real4 ptr[rdx+8]  ;xmm1 = a.z
  mulss   xmm1, real4 ptr[r8+4]   ;xmm1 = a.z*b.y
  subss   xmm0, xmm1              ;xmm0 = a.y*b.z - a.z*b.y
  movss   real4 ptr[rcx], xmm0    ;save return_storage.x

  movss   xmm0, real4 ptr[rdx]    ;xmm0 = a.x
  mulss   xmm0, real4 ptr[r8+8]   ;xmm0 = a.x*b.z
  movss   xmm1, real4 ptr[rdx+8]  ;xmm1 = a.z
  mulss   xmm1, real4 ptr[r8]     ;xmm1 = a.z*b.x
  subss   xmm0, xmm1              ;xmm0 = a.x*b.z - a.z*b.x
  movss   real4 ptr[rcx+4], xmm0  ;save return_storage.y

  movss   xmm0, real4 ptr[rdx]    ;xmm0 = a.x
  mulss   xmm0, real4 ptr[r8+4]   ;xmm0 = a.x*b.y
  movss   xmm1, real4 ptr[rdx+4]  ;xmm1 = a.y
  mulss   xmm1, real4 ptr[r8]     ;xmm1 = a.y*b.x
  subss   xmm0, xmm1              ;xmm0 = a.x*b.y - a.y*b.x
  movss   real4 ptr[rcx+8], xmm0  ;save return_storage.z

  mov rax, rcx
  ret
vec3f_cross endp


;cross product vec3f avx
;                  rcx             rdx             r8
;rax = vec3f_cross(return_storage, const vec3f& a, const vec3f& b)
vec3f_crossx proc
  vmovss    xmm0, real4 ptr[rdx+4]        ;xmm0 = a.y
  vmulss    xmm0, xmm0, real4 ptr[r8+8]   ;xmm0 = a.y*b.z
  vmovss    xmm1, real4 ptr[rdx+8]        ;xmm1 = a.z
  vmulss    xmm1, xmm1, real4 ptr[r8+4]   ;xmm1 = a.z*b.y
  vsubss    xmm0, xmm0, xmm1              ;xmm0 = a.y*b.z - a.z*b.y
  vmovss    real4 ptr[rcx], xmm0          ;save return_storage.x

  vmovss    xmm0, real4 ptr[rdx]          ;xmm0 = a.x
  vmulss    xmm0, xmm0, real4 ptr[r8+8]   ;xmm0 = a.x*b.z
  vmovss    xmm1, real4 ptr[rdx+8]        ;xmm1 = a.z
  vmulss    xmm1, xmm1, real4 ptr[r8]     ;xmm1 = a.z*b.x
  vsubss    xmm0, xmm0, xmm1              ;xmm0 = a.x*b.z - a.z*b.x
  vmovss    real4 ptr[rcx+4], xmm0        ;save return_storage.y

  vmovss    xmm0, real4 ptr[rdx]          ;xmm0 = a.x
  vmulss    xmm0, xmm0, real4 ptr[r8+4]   ;xmm0 = a.x*b.y
  vmovss    xmm1, real4 ptr[rdx+4]        ;xmm1 = a.y
  vmulss    xmm1, xmm1, real4 ptr[r8]     ;xmm1 = a.y*b.x
  vsubss    xmm0, xmm0, xmm1              ;xmm0 = a.x*b.y - a.y*b.x
  vmovss    real4 ptr[rcx+8], xmm0        ;save return_storage.z
  vzeroupper
  mov rax, rcx
  ret
vec3f_crossx endp


;cross product vec3d
;                  rcx             rdx             R8
;rax = vec3d_cross(return_storage, const vec3d& a, const vec3d& b)
vec3d_cross proc
  movsd   xmm0, real8 ptr[rdx+8]    ;xmm0 = a.y
  mulsd   xmm0, real8 ptr[r8+16]    ;xmm0 = a.y*b.z
  movsd   xmm1, real8 ptr[rdx+16]   ;xmm1 = a.z
  mulsd   xmm1, real8 ptr[r8+8]     ;xmm1 = a.z*b.y
  subsd   xmm0, xmm1                ;xmm0 = a.y*b.z - a.z*b.y
  movsd   real8 ptr[rcx], xmm0      ;save return_storage.x

  movsd   xmm0, real8 ptr[rdx]      ;xmm0 = a.x
  mulsd   xmm0, real8 ptr[r8+16]    ;xmm0 = a.x*b.z
  movsd   xmm1, real8 ptr[rdx+16]   ;xmm1 = a.z
  mulsd   xmm1, real8 ptr[r8]       ;xmm1 = a.z*b.x
  subsd   xmm0, xmm1                ;xmm0 = a.x*b.z - a.z*b.x
  movsd   real8 ptr[rcx+8], xmm0    ;save return_storage.y

  movsd   xmm0, real8 ptr[rdx]      ;xmm0 = a.x
  mulsd   xmm0, real8 ptr[r8+8]     ;xmm0 = a.x*b.y
  movsd   xmm1, real8 ptr[rdx+8]    ;xmm1 = a.y
  mulsd   xmm1, real8 ptr[r8]       ;xmm1 = a.y*b.x
  subsd   xmm0, xmm1                ;xmm0 = a.x*b.y - a.y*b.x
  movsd   real8 ptr[rcx+16], xmm0   ;save return_storage.z
  mov rax, rcx
  ret
vec3d_cross endp


;cross product vec3d avx
;                  rcx             rdx             R8
;rax = vec3d_crossx(return_storage, const vec3d& a, const vec3d& b)
vec3d_crossx proc
  vmovsd    xmm0, real8 ptr[rdx+8]          ;xmm0 = a.y
  vmulsd    xmm0, xmm0, real8 ptr[r8+16]    ;xmm0 = a.y*b.z
  vmovsd    xmm1, real8 ptr[rdx+16]         ;xmm1 = a.z
  vmulsd    xmm1, xmm1, real8 ptr[r8+8]     ;xmm1 = a.z*b.y
  vsubsd    xmm0, xmm0, xmm1                ;xmm0 = a.y*b.z - a.z*b.y
  vmovsd    real8 ptr[rcx], xmm0            ;save return_storage.x

  vmovsd    xmm0, real8 ptr[rdx]            ;xmm0 = a.x
  vmulsd    xmm0, xmm0, real8 ptr[r8+16]    ;xmm0 = a.x*b.z
  vmovsd    xmm1, real8 ptr[rdx+16]         ;xmm1 = a.z
  vmulsd    xmm1, xmm1, real8 ptr[r8]       ;xmm1 = a.z*b.x
  vsubsd    xmm0, xmm0, xmm1                ;xmm0 = a.x*b.z - a.z*b.x
  vmovsd    real8 ptr[rcx+8], xmm0          ;save return_storage.y

  vmovsd    xmm0, real8 ptr[rdx]            ;xmm0 = a.x
  vmulsd    xmm0, xmm0, real8 ptr[r8+8]     ;xmm0 = a.x*b.y
  vmovsd    xmm1, real8 ptr[rdx+8]          ;xmm1 = a.y
  vmulsd    xmm1, xmm1, real8 ptr[r8]       ;xmm1 = a.y*b.x
  vsubsd    xmm0, xmm0, xmm1                ;xmm0 = a.x*b.y - a.y*b.x
  vmovsd    real8 ptr[rcx+16], xmm0         ;save return_storage.z
  vzeroupper
  mov rax, rcx
  ret
vec3d_crossx endp


SAVE_XMM47 macro
  movaps [rsp   ], xmm4
    .savexmm128 xmm4, 0
  movaps [rsp], xmm5
    .savexmm128 xmm5, 16
  movaps [rsp], xmm6
    .savexmm128 xmm6, 48
  movaps [rsp], xmm7
    .savexmm128 xmm6, 64
endm

RESTORE_XMM47 macro
  movaps  xmm4, [rsp]
  movaps  xmm5, [rsp+16]
  movaps  xmm6, [rsp+32]
  movaps  xmm7, [rsp+48]
endm

;transpose 4x4 matrix from xmm0-xmm3 into xmm4-xmm7
TRANSPOSE_XMM47_XMM03 macro
  ;xmm0 =  1  2  3  4
  ;xmm1 =  5  6  7  8
  ;xmm2 =  9 10 11 12
  ;xmm3 = 13 14 15 16
  movaps    xmm4, xmm0  ;xmm4 =  1  2  3  4
  unpcklps  xmm4, xmm1  ;xmm4 =  1  5  2  6
  unpckhps  xmm0, xmm1  ;xmm0 =  3  7  4  8
  movaps    xmm5, xmm2  ;xmm5 =  9 10 11 12
  unpcklps  xmm5, xmm3  ;xmm5 =  9 13 10 14
  unpckhps  xmm2, xmm3  ;xmm2 = 11 15 12 16
  movaps    xmm1, xmm4  ;xmm1 =  1  5  2  6
  movlhps   xmm4, xmm5  ;xmm4 =  1  5  9 13
  movhlps   xmm5, xmm1  ;xmm5 =  2  6 10 14
  movaps    xmm6, xmm0  ;xmm6 =  3  7  4  8
  movlhps   xmm6, xmm2  ;xmm6 =  3  7 11 15
  movaps    xmm7, xmm2  ;xmm7 = 11 15 12 16
  movhlps   xmm7, xmm0  ;xmm7 =  4  8 12 16
endm

;transpose 4x4 matrix from xmm0-xmm3 into xmm4-xmm7 avx
TRANSPOSE_XMM47_XMM03_X macro
  ;xmm0 =  1  2  3  4
  ;xmm1 =  5  6  7  8
  ;xmm2 =  9 10 11 12
  ;xmm3 = 13 14 15 16
  vunpcklps xmm6, xmm0, xmm1  ;xmm6 =  1  5  2  6
  vunpckhps xmm0, xmm0, xmm1  ;xmm0 =  3  7  4  8
  vunpcklps xmm7, xmm2, xmm3  ;xmm7 =  9 13 10 14
  vunpckhps xmm1, xmm2, xmm3  ;xmm1 = 11 15 12 16
  vmovlhps  xmm4, xmm6, xmm7  ;xmm4 =  1  5  9 13
  vmovhlps  xmm5, xmm7, xmm6  ;xmm5 =  2  6 10 14
  vmovlhps  xmm6, xmm0, xmm1  ;xmm6 =  3  7 11 15
  vmovhlps  xmm7, xmm1, xmm0  ;xmm7 =  4  8 12 16
endm


;transpose 4x4 matrix xmm0-xmm4 using xmm4-xmm7
;          rcx
;transpose(float m[16])
transpose proc frame
  sub rsp, 72
  .allocstack 72
  SAVE_XMM47
  .endprolog

  movaps  xmm0, [rcx   ]  ;xmm0 =  1  2  3  4
  movaps  xmm1, [rcx+16]  ;xmm1 =  5  6  7  8
  movaps  xmm2, [rcx+32]  ;xmm2 =  9 10 11 12
  movaps  xmm3, [rcx+48]  ;xmm3 = 13 14 15 16

  TRANSPOSE_XMM47_XMM03

  movaps [rcx   ], xmm4   ;save 1st row
  movaps [rcx+16], xmm5   ;save 2nd row
  movaps [rcx+32], xmm6   ;save 3rd row
  movaps [rcx+48], xmm7   ;save 4th row

  RESTORE_XMM47
  add rsp, 72
  ret
transpose endp


;transpose 4x4 matrix xmm0-xmm4 using xmm4-xmm7 avx
;           rcx
;transposex(float m[16])
transposex proc frame
  sub rsp, 72
  .allocstack 72
  SAVE_XMM47
  .endprolog

  vmovaps xmm0, [rcx   ]  ;xmm0 =  1  2  3  4
  vmovaps xmm1, [rcx+16]  ;xmm1 =  5  6  7  8
  vmovaps xmm2, [rcx+32]  ;xmm2 =  9 10 11 12
  vmovaps xmm3, [rcx+48]  ;xmm3 = 13 14 15 16

  TRANSPOSE_XMM47_XMM03_X

  vmovaps [rcx   ], xmm4  ;save 1st row
  vmovaps [rcx+16], xmm5  ;save 2nd row
  vmovaps [rcx+32], xmm6  ;save 3rd row
  vmovaps [rcx+48], xmm7  ;save 4th row

  RESTORE_XMM47
  add rsp, 72
  vzeroupper
  ret
transposex endp


;perform matrix sum c = a+b
;          rcx          rdx          r8
;mat4f_sum(float c[16], float a[16], float b[16])
mat4f_sum proc
  movaps  xmm0, [rdx]     ;xmm0  = a00 a01 a02 a03
  addps   xmm0, [r8 ]     ;xmm0 += b00 b01 b02 b03

  movaps  xmm1, [rdx+16]  ;xmm1  = a10 a11 a12 a13
  addps   xmm1, [r8 +16]  ;xmm1 += b10 b11 b12 b13

  movaps  xmm2, [rdx+32]  ;xmm2  = a20 a21 a22 a23
  addps   xmm2, [r8 +32]  ;xmm2 += b20 b21 b22 b23

  movaps  xmm3, [rdx+48]  ;xmm3  = a30 a31 a32 a33
  addps   xmm3, [r8 +48]  ;xmm3 += b30 b31 b32 b33

  movaps [rcx   ], xmm0   ;save 1st row
  movaps [rcx+16], xmm1   ;save 2nd row
  movaps [rcx+32], xmm2   ;save 3rd row
  movaps [rcx+48], xmm3   ;save 4th row
  ret
mat4f_sum endp


;perform matrix sub c = a-b
;          rcx          rdx          r8
;mat4f_sub(float c[16], float a[16], float b[16])
mat4f_sub proc
  movaps  xmm0, [rdx]     ;xmm0  = a00 a01 a02 a03
  subps   xmm0, [r8 ]     ;xmm0 -= b00 b01 b02 b03

  movaps  xmm1, [rdx+16]  ;xmm1  = a10 a11 a12 a13
  subps   xmm1, [r8 +16]  ;xmm1 -= b10 b11 b12 b13

  movaps  xmm2, [rdx+32]  ;xmm2  = a20 a21 a22 a23
  subps   xmm2, [r8 +32]  ;xmm2 -= b20 b21 b22 b23

  movaps  xmm3, [rdx+48]  ;xmm3  = a30 a31 a32 a33
  subps   xmm3, [r8 +48]  ;xmm3 -= b30 b31 b32 b33

  movaps [rcx   ], xmm0   ;save 1st row
  movaps [rcx+16], xmm1   ;save 2nd row
  movaps [rcx+32], xmm2   ;save 3rd row
  movaps [rcx+48], xmm3   ;save 4th row
  ret
mat4f_sub endp


;perform matrix scale m*=scale
;            rcx          xmm1
;mat4f_scale(float m[16], float scale)
mat4f_scale proc
  movss     xmm2, xmm1      ;xmm2 = scale   x     x     x
  unpcklps  xmm2, xmm2      ;xmm2 = scale scale   x     x
  unpcklps  xmm2, xmm2      ;xmm2 = scale scale scale scale

  movaps    xmm0, [rcx]     ;xmm0  = 1st row
  mulps     xmm0, xmm2      ;xmm0 *= scale
  movaps    [rcx],xmm0      ;save 1st row

  movaps    xmm1, [rcx+16]  ;xmm1  = 2nd row
  mulps     xmm1, xmm2      ;xmm1 *= scale
  movaps    [rcx+16],xmm1   ;save 2nd row

  movaps    xmm0, [rcx+32]  ;xmm0  = 3rd row
  mulps     xmm0, xmm2      ;xmm0 *= scale
  movaps    [rcx+32], xmm0  ;save 3rd row

  movaps    xmm1, [rcx+48]  ;xmm1  = 4th row
  mulps     xmm1, xmm2      ;xmm1 *= scale
  movaps    [rcx+48],xmm1   ;save 4th row
  ret
mat4f_scale endp


;perform matrix multiplication c = a*b
;          rcx          rdx          r8
;mat4f_mul(float c[16], float a[16], float b[16])
mat4f_mul proc frame
  sub rsp, 72
  .allocstack 72
  SAVE_XMM47
  .endprolog

  movaps  xmm0, [r8   ]             ;fetch 1st b row
  movaps  xmm1, [r8+16]             ;fetch 2nd b row
  movaps  xmm2, [r8+32]             ;fecth 3rd b row
  movaps  xmm3, [r8+48]             ;fetch 4th b row
  TRANSPOSE_XMM47_XMM03             ;transpose b to xmm4-xmm7

  xor r9, r9                        ;array index (i*16 = [0,16,32,48])
  mov r10d, 4                       ;number of rows
l:
  movaps    xmm0, [rdx+r9]          ;load next a row

  movaps    xmm1, xmm0
  dpps      xmm1, xmm4, 11110001b   ;1111 = multiply all items, 0001 = store to xmm1[0]
  insertps  xmm2, xmm1, 00000000b   ;0000 = get xmm1[0], 0000 = store to xmm2[0] -> xmm2 = r*c1  x  x  x

  movaps    xmm1, xmm0
  dpps      xmm1, xmm5, 11110001b   ;1111 = multiply all items, 0001 = store to xmm1[0]
  insertps  xmm2, xmm1, 00010000b   ;0000 = get xmm1[0], 0001 = store to xmm2[1] -> xmm2 = r*c1 r*c2  x  x

  movaps    xmm1, xmm0
  dpps      xmm1, xmm6, 11110001b   ;1111 = multiply all items, 0001 = store to xmm1[0]
  insertps  xmm2, xmm1, 00100000b   ;0000 = get xmm1[0], 0010 = store to xmm2[2] -> xmm2 = r*c1 r*c2 r*c3  x

  movaps    xmm1, xmm0
  dpps      xmm1, xmm7, 11110001b   ;1111 = multiply all items, 0001 = store to xmm1[0]
  insertps  xmm2, xmm1, 00110000b   ;0000 = get xmm1[0], 0011 = store to xmm2[3] -> xmm2 = r*c1 r*c2 r*c3 r*c4

  movaps [rcx+r9], xmm2             ;save row
  add     r9, 16                    ;point to next row
  dec     r10d                      ;one row less
  jnz     l                         ;next row of r10d != 0
  RESTORE_XMM47                     ;restore xmm4-xmm7 regs
  add rsp, 72
  ret
mat4f_mul endp


;perform matrix multiplication c = a*b avx
;             rcx          rdx          r8
;mat4f_mulx_b(float c[16], float a[16], float b[16])
mat4f_mulx proc frame
  sub rsp, 72
  .allocstack 72
  SAVE_XMM47
  .endprolog

  vmovaps  xmm0, [r8   ]                  ;xmm0 = b00 b01 b02 b03
  vmovaps  xmm1, [r8+16]                  ;xmm1 = b10 b11 b12 b13
  vmovaps  xmm2, [r8+32]                  ;xmm2 = b20 b21 b22 b23
  vmovaps  xmm3, [r8+48]                  ;xmm3 = b30 b31 b32 b33
  xor      r9, r9                         ;r9 = offset to first element in the current row
l:
  vbroadcastss xmm4, real4 ptr[rdx+r9]    ;xmm4 = a00 a00 a00 a00
  vbroadcastss xmm5, real4 ptr[rdx+r9+4]  ;xmm5 = a01 a01 a01 a01
  vbroadcastss xmm6, real4 ptr[rdx+r9+8]  ;xmm6 = a02 a02 a02 a02
  vbroadcastss xmm7, real4 ptr[rdx+r9+12] ;xmm7 = a03 a03 a03 a03

  vmulps  xmm4, xmm0, xmm4                ;xmm4 = a00*b00  a00*b01  a00*b02  a03*b03
  vmulps  xmm5, xmm1, xmm5                ;xmm5 = a01*b10  a01*b11  a01*b12  a01*b13
  vmulps  xmm6, xmm2, xmm6                ;xmm6 = a02*b20  a02*b21  a02*b22  a02*b23
  vmulps  xmm7, xmm3, xmm7                ;xmm7 = a03*b30  a03*b31  a03*b32  a03*b33

  vaddps xmm4, xmm4, xmm5                 ;xmm4 = a00*b00+a01*b10 ...
  vaddps xmm6, xmm6, xmm7                 ;xmm6 = a00*b00+a01*b10+a02*b20 ...
  vaddps xmm4, xmm4, xmm6                 ;xmm4 = a00*b00+a+1*b10+a02*b20+a03+*b30 ...

  vmovaps [rcx+r9], xmm4                  ;save row
  add r9, 16                              ;offset to next row
  cmp r9, 64                              ;check if last row was processed
  jl  l                                   ;another row
  RESTORE_XMM47                           ;restore xmm4-xmm7 regs
  add rsp, 72
  vzeroupper
  ret
mat4f_mulx endp


;perform vector-matrix multiplication
;               rcx          rdx             r8
;vec4fmat4f_mul(vec4f& dest, const vec4f& v, float m[16])
vec4fmat4f_mul proc frame
  sub rsp, 72
  .allocstack 72
  SAVE_XMM47
  .endprolog

  movaps  xmm0, [r8   ]             ;fetch 1st b row
  movaps  xmm1, [r8+16]             ;fetch 2nd b row
  movaps  xmm2, [r8+32]             ;fecth 3rd b row
  movaps  xmm3, [r8+48]             ;fetch 4th b row
  TRANSPOSE_XMM47_XMM03             ;transpose b to xmm4-xmm7

  movaps    xmm0, [rdx]             ;load vector

  movaps    xmm1, xmm0
  dpps      xmm1, xmm4, 11110001b   ;1111 = multiply all items, 0001 = store to xmm1[0]
  insertps  xmm2, xmm1, 00000000b   ;0000 = get xmm1[0], 0000 = store to xmm2[0] -> xmm2 = r*c1  x  x  x

  movaps    xmm1, xmm0
  dpps      xmm1, xmm5, 11110001b   ;1111 = multiply all items, 0001 = store to xmm1[0]
  insertps  xmm2, xmm1, 00010000b   ;0000 = get xmm1[0], 0001 = store to xmm2[1] -> xmm2 = r*c1 r*c2  x  x

  movaps    xmm1, xmm0
  dpps      xmm1, xmm6, 11110001b   ;1111 = multiply all items, 0001 = store to xmm1[0]
  insertps  xmm2, xmm1, 00100000b   ;0000 = get xmm1[0], 0010 = store to xmm2[2] -> xmm2 = r*c1 r*c2 r*c3  x

  movaps    xmm1, xmm0
  dpps      xmm1, xmm7, 11110001b   ;1111 = multiply all items, 0001 = store to xmm1[0]
  insertps  xmm2, xmm1, 00110000b   ;0000 = get xmm1[0], 0011 = store to xmm2[3] -> xmm2 = r*c1 r*c2 r*c3 r*c4

  movaps [rcx], xmm2                ;save row
  RESTORE_XMM47                     ;restore xmm4-xmm7 regs
  add rsp, 72
  vzeroupper
  ret
vec4fmat4f_mul endp


;perform vector-matrix multiplication avx
;                rcx          rdx             r8
;vec4fmat4f_mulx(vec4f& dest, const vec4f& v, float m[16])
vec4fmat4f_mulx proc frame
  sub rsp, 72
  .allocstack 72
  SAVE_XMM47
  .endprolog

  vmovaps  xmm0, [r8   ]            ;fetch 1st b row
  vmovaps  xmm1, [r8+16]            ;fetch 2nd b row
  vmovaps  xmm2, [r8+32]            ;fecth 3rd b row
  vmovaps  xmm3, [r8+48]            ;fetch 4th b row
  TRANSPOSE_XMM47_XMM03_X           ;transpose b to xmm4-xmm7

  vmovaps    xmm0, [rdx]            ;load vector

  vmovaps    xmm1, xmm0
  vdpps      xmm1, xmm1, xmm4, 11110001b  ;1111 = multiply all items, 0001 = store to xmm1[0]
  vinsertps  xmm2, xmm2, xmm1, 00000000b  ;0000 = get xmm1[0], 0000 = store to xmm2[0] -> xmm2 = r*c1  x  x  x

  vmovaps    xmm1, xmm0
  vdpps      xmm1, xmm1, xmm5, 11110001b  ;1111 = multiply all items, 0001 = store to xmm1[0]
  vinsertps  xmm2, xmm2, xmm1, 00010000b  ;0000 = get xmm1[0], 0001 = store to xmm2[1] -> xmm2 = r*c1 r*c2  x  x

  vmovaps    xmm1, xmm0
  vdpps      xmm1, xmm1, xmm6, 11110001b  ;1111 = multiply all items, 0001 = store to xmm1[0]
  vinsertps  xmm2, xmm2, xmm1, 00100000b  ;0000 = get xmm1[0], 0010 = store to xmm2[2] -> xmm2 = r*c1 r*c2 r*c3  x

  vmovaps    xmm1, xmm0
  vdpps      xmm1, xmm1, xmm7, 11110001b  ;1111 = multiply all items, 0001 = store to xmm1[0]
  vinsertps  xmm2, xmm2, xmm1, 00110000b  ;0000 = get xmm1[0], 0011 = store to xmm2[3] -> xmm2 = r*c1 r*c2 r*c3 r*c4

  vmovaps [rcx], xmm2               ;save row
  RESTORE_XMM47                     ;restore xmm4-xmm7 regs
  add rsp, 72
  vzeroupper
  ret
vec4fmat4f_mulx endp

end