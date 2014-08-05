; fibonacci
; kristof aldenderfer
 
%include          'functions.asm'
 
SECTION .data
;cnt         db      10       ; this should be used as what r9 is being compared to now in .nextNumber

SECTION .text
global  start
 
start:
    mov     r12, 0          ; 0th value
    mov     r13, 1          ; 1st value
    mov     r9, 2           ; this is our counter variable.
                            ; it starts at two because we need to manually define the firt two values in the sequence.
                            ; (they are stored in r12 and r13.)
.firstSpot:
    mov     rax, r12        ; print the first value
    call    iprintLF
.secondSpot:
    mov     rax, r13        ; print the second value
    call    iprintLF
.nextNumber:
    inc     r9              ; increment the counter
    add     r12, r13        ; add (n-2) to (n-1) to get (n), which is loaded into r12
    mov     rax, r12        ; copy it into rax for printing
    push    r12             ; push r12 (n) to the stack to preserve it
    push    r13             ; push r13 (n-1) to the stack to preserve it
    call    iprintLF        ; print (n)
    pop     r12             ; pop into r12 (n-1)
    pop     r13             ; pop into r13 (n)
                            ; we pop these off in reverse of the normal order because when the add fucntion happens (on line 26),
                            ; the result will overwrite r12, which once again becomes (n), and r13 moves from (n) to (n-1).
    cmp     r9, 10          ; are we done counting?
    jne     .nextNumber     ; if not, jump back and process the next number

    call    quit