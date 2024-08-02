; vim: set tabstop=4:softtabstop=4:shiftwidth=4
; vim: set expandtab:

print_any_int:
    ; print_any_int [rax] [rdi]
    ;  rax = int pointer
    ;  rdi = size in bytes
    ;
    ; example:
    ;   mov rbp, rsp
    ;   sub rsp, 20
    ;   mov byte [rbp-20], 22
    ;   lea rax, [rbp-20]
    ;   mov rdi, 1
    ;   call print_any_int
    ;   mov rsp, rbp
    ;
    ;   mov rbp, rsp
    ;   sub rsp, 20
    ;   mov word [rbp-20], 666
    ;   lea rax, [rbp-20]
    ;   mov rdi, 2
    ;   call print_any_int
    ;   mov rsp, rbp
    ;
    push_registers

    ; int pointer
    mov r9, rax

    mov rax, 0

    cmp rdi, 1
    je .print_any_int_size_1

    cmp rdi, 2
    je .print_any_int_size_2

    cmp rdi, 4
    je .print_any_int_size_4

    jmp .print_any_int_size_error

.print_any_int_size_1:
    mov byte al, [r9]
    call print_int32
    jmp .print_any_int_end
.print_any_int_size_2:
    mov word ax, [r9]
    call print_int32
    jmp .print_any_int_end
.print_any_int_size_4:
    mov dword eax, [r9]
    call print_int32
    jmp .print_any_int_end

.print_any_int_size_error:
    print s_supported_ints
    mov rax, rdi
    call println_int32
    exit 1

.print_any_int_end:

    pop_registers
    ret

%macro print_int_array 3
    ; print_int_array [array buffer] [element size] [array size]
    push_registers
    mov rbp, rsp

    ; allocate 1 64 bit register and for the pointer
    ; and 2 32 bit register for the integers
    sub rsp, 16

    ; buffer
    mov [rbp-16], %1

    ; this matches so the pointer move worked fine
    ; mov rax, [rbp-14]
    ; dbg_hexdump_reg rax

    ; element size
    mov dword [rbp-8], %2

    ; array size
    mov dword [rbp-4], %3

    call print_open_bracket

    mov ecx, 0
    %%loop_elements:
        inc ecx

        ; 64 bit pointer to integer
        mov rax, [rbp-16]
        ; 32 bit element size
        mov rdi, 0
        mov dword edi, [rbp-8] ; printed and verified to be 1
        call print_any_int

        call print_comma

        cmp ecx, [rbp-4]
        jl %%loop_elements

    call print_close_bracket

    mov rsp, rbp
    pop_registers
%endmacro

print_newline:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_newline
    mov rdx, 1
    syscall

    pop_registers
    ret

print_comma:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_comma
    mov rdx, 1
    syscall

    pop_registers
    ret

print_open_bracket:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_open_bracket
    mov rdx, 1
    syscall

    pop_registers
    ret

print_close_bracket:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_close_bracket
    mov rdx, 1
    syscall

    pop_registers
    ret

print_minus:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_minus
    mov rdx, 1
    syscall

    pop_registers
    ret

print_single_quote:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_single_quote
    mov rdx, 1
    syscall

    pop_registers
    ret

print_double_quote:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_double_quote
    mov rdx, 1
    syscall

    pop_registers
    ret

print_space:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_space
    mov rdx, 1
    syscall

    pop_registers
    ret

dbg_println_uint32:
    ; dbg_print_num [rax]
    ;
    ; prints given arg as uint32 turned into a string
    ; to stdout
    ; prefixed with a debug string message
    push_registers

    print s_dbg_rax_digit

    ; pop of rax to pass it on to println_uint32
    pop_registers

    call println_uint32
    call print_newline

    ret

; newline version

println_int32:
    ; print_int32 [rax]
    cmp rax, 0
    jge .println_int32_positive
.println_int32_negative:
    call print_minus
    neg rax
.println_int32_positive:
    call println_uint32
    ret

println_uint32:
    ; println_uint32 [rax]
    ;
    ; has a sub label toascii_digit
    ; and prints the given value in rax
    ; as a digit to stdout
    ; https://stackoverflow.com/a/46301894/6287070
    push_registers

    mov ecx, 0xa ; base 10
    push rcx ; ASCII newline '\n' = 0xa = base
    mov rsi, rsp
    sub rsp, 16 ; not needed on 64-bit Linux, the red-zone is big enough.  Change the LEA below if you remove this.

;;; rsi is pointing at '\n' on the stack, with 16B of "allocated" space below that.
.println_uint32_toascii_digit:                ; do {
    xor edx, edx
    div ecx ; edx=remainder = low digit = 0..9.  eax/=10
                                 ;; DIV IS SLOW.  use a multiplicative inverse if performance is relevant.
    add edx, '0'
    dec rsi ; store digits in MSD-first printing order, working backwards from the end of the string
    mov [rsi], dl

    test eax,eax ; } while(x);
    jnz  .println_uint32_toascii_digit
;;; rsi points to the first digit


    mov eax, SYS_WRITE
    mov edi, STDOUT
    ; pointer already in RSI    ; buf = last digit stored = most significant
    lea edx, [rsp+16 + 1]    ; yes, it's safe to truncate pointers before subtracting to find length.
    sub edx, esi             ; RDX = length = end-start, including the \n
    syscall                     ; write(1, string /*RSI*/,  digits + 1)

    add rsp, 24                ; (in 32-bit: add esp,20) undo the push and the buffer reservation

    pop_registers
    ret

; no newline version

print_int32:
    ; print_int32 [rax]
    cmp rax, 0
    jge .print_int32_positive
.print_int32_negative:
    call print_minus
    neg rax
.print_int32_positive:
    call print_uint32
    ret

print_uint32:
    ; println_uint32 [rax]
    ;
    ; has a sub label toascii_digit
    ; and prints the given value in rax
    ; as a digit to stdout
    ; https://stackoverflow.com/a/46301894/6287070
    push_registers

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
    lea edx, [rsp+16]    ; yes, it's safe to truncate pointers before subtracting to find length.
    sub edx, esi             ; RDX = length = end-start, including the \n
    syscall                     ; write(1, string /*RSI*/,  digits + 1)

    add rsp, 24                ; (in 32-bit: add esp,20) undo the push and the buffer reservation

    pop_registers
    ret

