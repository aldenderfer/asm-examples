;------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push    rdi
    mov     rdi, rax
 
nextchar:
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar
 
finished:
    sub     rax, rdi
    pop     rdi
    ret
 
;------------------------------------------
; void sprint(String message)
; String printing function
sprint:
    push    rdx
    push    rsi
    push    rdi
    push    rax
    call    slen
 
    mov     rdx, rax
    pop     rax
 
    mov     rsi, rax
    mov     rdi, 1
    mov     rax, 0x2000004
    syscall
 
    pop     rdi
    pop     rsi
    pop     rdx
    ret
 
;------------------------------------------
; void iprint(Integer number)
; Integer printing function (itoa)
iprint:
    push    rax            ; preserve rax on the stack to be restored after function runs
    push    rsi            ; preserve rsi on the stack to be restored after function runs
    push    rdx            ; preserve rdx on the stack to be restored after function runs
    push    r9             ; preserve r9 on the stack to be restored after function runs
    mov     rsi, 0         ; counter of how many bytes we need to print in the end
 
divideLoop:
    inc     rsi            ; count each byte to print - number of characters
    mov     rdx, 0         ; empty rdx
    mov     r9, 10         ; mov 10 into r9
    idiv    r9             ; divide rax by r9
    add     rdx, 48        ; convert rdx to it's ascii representation - rdx holds the remainder after a divide instruction
    push    rdx            ; push rdx (string representation of an intger) onto the stack
    cmp     rax, 0         ; can the integer be divided anymore?
    jnz     divideLoop     ; jump if not zero to the label divideLoop
 
printLoop:
    dec     rsi            ; count down each byte that we put on the stack
    mov     rax, rsp       ; mov the stack pointer into rax for printing
    call    sprint         ; call our string print function
    pop     rax            ; remove last character from the stack to move rsp forward
    cmp     rsi, 0         ; have we printed all bytes we pushed onto the stack?
    jnz     printLoop      ; jump is not zero to the label printLoop
 
    pop     r9             ; restore r9 from the value we pushed onto the stack at the start
    pop     rdx            ; restore rdx from the value we pushed onto the stack at the start
    pop     rsi            ; restore rsi from the value we pushed onto the stack at the start
    pop     rax            ; restore rax from the value we pushed onto the stack at the start
    ret

;------------------------------------------
; void sprintLF(String message)
; String printing with line feed function
sprintLF:
    call    sprint
 
    push    rax        ; push rax onto the stack to preserve it while we use the rax register in this function
    mov     rax, 0Ah   ; move 0Ah into rax - 0Ah is the ascii character for a linefeed
    push    rax        ; push the linefeed onto the stack so we can get the address
    mov     rax, rsp   ; move the address of the current stack pointer into rax for sprint
    call    sprint     ; call our sprint function
    pop     rax        ; remove our linefeed character from the stack
    pop     rax        ; restore the original value of rax before our function was called
    ret                ; return to our program
 
;------------------------------------------
; void iprintLF(Integer number)
; Integer printing function with linefeed (itoa)
iprintLF:
    call    iprint         ; call our integer printing function
 
    push    rax            ; push rax onto the stack to preserve it while we use the rax register in this function
    mov     rax, 0Ah       ; move 0Ah into rax - 0Ah is the ascii character for a linefeed
    push    rax            ; push the linefeed onto the stack so we can get the address
    mov     rax, rsp       ; move the address of the current stack pointer into rax for sprint
    call    sprint         ; call our sprint function
    pop     rax            ; remove our linefeed character from the stack
    pop     rax            ; restore the original value of rax before our function was called
    ret

;------------------------------------------
; int atoi(Integer number)
; Ascii to integer function (atoi)
atoi:
    push    rdi            ; preserve rdi on the stack to be restored after function runs
    push    rsi            ; preserve rsi on the stack to be restored after function runs
    push    rdx            ; preserve rdx on the stack to be restored after function runs
    push    r9             ; preserve r9 on the stack to be restored after function runs
    mov     r9, rax        ; move pointer in rax into r9 (our number to convert)
    mov     rax, 0         ; initialise rax with decimal value 0
    mov     rsi, 0         ; initialise rsi with decimal value 0
 
.multiplyLoop:
    xor     rdi, rdi       ; resets both lower and uppper bytes of rdi to be 0
    mov     bl, [r9+rsi]   ; move a single byte into rdi register's lower half
    cmp     bl, 48         ; compare rdi register's lower half value against ascii value 48 (char value 0)
    jl      .finished      ; jump if less than to label finished
    cmp     bl, 57         ; compare rdi register's lower half value against ascii value 57 (char value 9)
    jg      .finished      ; jump if greater than to label finished
    cmp     bl, 10         ; compare rdi register's lower half value against ascii value 10 (linefeed character)
    je      .finished      ; jump if equal to label finished
    cmp     bl, 0          ; compare rdi register's lower half value against decimal value 0 (end of string)
    jz      .finished      ; jump if zero to label finished
 
    sub     bl, 48         ; convert rdi register's lower half to decimal representation of ascii value
    add     rax, rdi       ; add rdi to our interger value in rax
    mov     rdi, 10        ; move decimal value 10 into rdi
    mul     rdi            ; multiply rax by rdi to get place value
    inc     rsi            ; increment rsi (our counter register)
    jmp     .multiplyLoop  ; continue multiply loop
 
.finished:
    mov     rdi, 10        ; move decimal value 10 into rdi
    div     rdi            ; divide rax by value in rdi (in this case 10)
    pop     r9             ; restore r9 from the value we pushed onto the stack at the start
    pop     rdx            ; restore rdx from the value we pushed onto the stack at the start
    pop     rsi            ; restore rsi from the value we pushed onto the stack at the start
    pop     rdi            ; restore rdi from the value we pushed onto the stack at the start
    ret
 
;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov     rdi, 0
    mov     rax, 0x2000001
    syscall
    ret
 