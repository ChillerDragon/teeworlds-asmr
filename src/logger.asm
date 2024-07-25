; vim: set tabstop=4:softtabstop=4:shiftwidth=4
; vim: set expandtab:

print_newline:
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, NEWLINE
    mov rdx, 1
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

dbg_print_uint32:
    ; dbg_print_num [rax]
    ;
    ; prints given arg as uint32 turned into a string
    ; to stdout
    ; prefixed with a debug string message

    push rax
    push rdi
    push rsi
    push rdx

    mov rsi, s_dbg_digit
    mov eax, SYS_WRITE
    mov edi, STDOUT
    mov edx, l_dbg_digit
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax

    call print_uint32
    call print_newline

    ret

print_uint32:
    ; print_uint32 [rax]
    ;
    ; has a sub label toascii_digit
    ; and prints the given value in rax
    ; as a digit to stdout
    ; https://stackoverflow.com/a/46301894/6287070
    push rax
    push rsi
    push rcx
    push rdx

    mov ecx, 0xa ; base 10
    push rcx ; ASCII newline '\n' = 0xa = base
    mov rsi, rsp
    sub rsp, 16 ; not needed on 64-bit Linux, the red-zone is big enough.  Change the LEA below if you remove this.

;;; rsi is pointing at '\n' on the stack, with 16B of "allocated" space below that.
.print_uint32_toascii_digit:                ; do {
    xor edx, edx
    div ecx ; edx=remainder = low digit = 0..9.  eax/=10
                                 ;; DIV IS SLOW.  use a multiplicative inverse if performance is relevant.
    add edx, '0'
    dec rsi ; store digits in MSD-first printing order, working backwards from the end of the string
    mov [rsi], dl

    test eax,eax ; } while(x);
    jnz  .print_uint32_toascii_digit
;;; rsi points to the first digit


    mov eax, SYS_WRITE
    mov edi, STDOUT
    ; pointer already in RSI    ; buf = last digit stored = most significant
    lea edx, [rsp+16 + 1]    ; yes, it's safe to truncate pointers before subtracting to find length.
    sub edx, esi             ; RDX = length = end-start, including the \n
    syscall                     ; write(1, string /*RSI*/,  digits + 1)

    add rsp, 24                ; (in 32-bit: add esp,20) undo the push and the buffer reservation

    pop rdx
    pop rcx
    pop rsi
    pop rax
    ret

