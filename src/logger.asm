; vim: set tabstop=4:softtabstop=4:shiftwidth=4
; vim: set expandtab:

log_info:
    ; log_info [rax]
    ;  rax = null terminated label
    ;  rdi = null terminated string
    push_registers

    ; label
    mov r9, rax
    ; message
    mov r10, rdi

    ; offset into logger_line_buffer_2048
    mov r11, 0

    mov byte [logger_line_buffer_2048+r11], '['
    inc r11

    lea rax, [logger_line_buffer_2048+r11]
    mov rdi, r9
    mov rsi, 16 ; random max label len
    call str_copy

    ; Increment destination pointer by amount of bytes written
    add r11, rax
    mov byte [logger_line_buffer_2048+r11], ']'
    inc r11
    mov byte [logger_line_buffer_2048+r11], ' '
    inc r11

    lea rax, [logger_line_buffer_2048+r11]
    mov rdi, r10 ; message
    mov rsi, 2000 ; buffer max len minus label length
    call str_copy

    add r11, rax
    mov byte [logger_line_buffer_2048+r11], 0x0a
    inc r11
    mov byte [logger_line_buffer_2048+r11], 0x00
    inc r11

    ; log stdout
    print_c_str logger_line_buffer_2048

    ; log to file
    mov rax, logger_line_buffer_2048
    call log_to_logfile

    pop_registers
    ret

log_to_logfile:
    ; log_to_logfile [rax]
    ;  rax = full log line to log
    push_registers

    ; only log if there is a logpath set
    ; if the first byte is NULL
    ; it is either an empty c string or unset bss memory
    cmp byte [logger_logfile_path], 0x00
    je .logger_end

    ; string to write
    mov r9, rax

    mov rax, logger_logfile_path
    mov rdi, O_APPEND
    call fopen

    ; rax is set by open(2) and should be a valid (positive)
    ; file descriptor
    cmp rax, 0
    jg .fopen_ok

    printf "error: logger failed and got fd=%d", rax
    exit 1

    .fopen_ok:

    mov rdi, r9
    call write_str_to_file

    ; fd is still in rax
    call close

    .logger_end:

    pop_registers
    ret

ptr_to_str:
    ; ptr_to_str [rax] [rdi]
    ;  rax = pointer
    ;  rdi = output buffer
    ; returns into rax the size written
    push_registers

    mov rbp, rsp
    sub rsp, 18

    ; swap endianness
    ; to match objdump output
    bswap rax

    ; r11 ptr to ptr
    push rax
    mov r11, rsp
    ; r12 out buffer
    mov r12, rdi

    ; 8765 43 21 1
    ; 1111 11 11 09 87 65 43 21
    ; 0x11 22 33 44 55 66 77 88

    mov word [rbp-18], '0x'

    mov rax, [r11+0]
    call hex_to_char
    mov rax, [hex_str]
    mov ax, [hex_str]
    mov word [rbp-16], ax

    mov rax, [r11+1]
    call hex_to_char
    mov rax, [hex_str]
    mov ax, [hex_str]
    mov word [rbp-14], ax

    mov rax, [r11+2]
    call hex_to_char
    mov rax, [hex_str]
    mov ax, [hex_str]
    mov word [rbp-12], ax

    mov rax, [r11+3]
    call hex_to_char
    mov rax, [hex_str]
    mov ax, [hex_str]
    mov word [rbp-10], ax

    mov rax, [r11+4]
    call hex_to_char
    mov rax, [hex_str]
    mov ax, [hex_str]
    mov word [rbp-8], ax

    mov rax, [r11+5]
    call hex_to_char
    mov rax, [hex_str]
    mov ax, [hex_str]
    mov word [rbp-6], ax

    mov rax, [r11+6]
    call hex_to_char
    mov rax, [hex_str]
    mov ax, [hex_str]
    mov word [rbp-4], ax

    mov rax, [r11+7]
    call hex_to_char
    mov rax, [hex_str]
    mov ax, [hex_str]
    mov word [rbp-2], ax

    ; rax = destination buffer pointer
    mov rax, r12
    ; rdi = source buffer pointer
    lea rdi, [rbp-18]
    ; rsi = truncation len (max size)
    mov rsi, 18
    call str_copy

    ; free pointer to pointer from stack
    pop rax

    mov rsp, rbp

    pop_registers

    ; return fixed size of 18 characters written
    mov rax, 18
    ret

print_0x:
    push rax
    push rbp
    mov rbp, rsp
    sub rsp, 3
    mov word [rbp-3], '0x'
    mov byte [rbp-1], 0
    lea rax, [rbp-3]
    print_c_str rax
    mov rsp, rbp
    pop rbp
    pop rax
    ret

print_ptr:
    ; print_ptr [rax]
    ;  rax = holds a 64 bit pointer
    push rax
    push rdi

    ; swap endianness
    ; to match objdump output
    bswap rax

    call print_0x
    ; put rax on the stack
    ; so we can get a pointer to it
    ; for hexdump
    push rax
    mov rax, rsp
    mov rdi, 8
    call print_hexdump_no_spaces
    pop rax

    pop rdi
    pop rax
    ret

print_any_int:
    ; print_any_int [rax] [rdi]
    ;  rax = int pointer
    ;  rdi = size in bytes
    ;
    ; 8 bit integers will be printed as pointers
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

    cmp rdi, 8
    je .print_any_int_size_8

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
.print_any_int_size_8:
    mov rax, [r9]
    call print_ptr
    jmp .print_any_int_end

.print_any_int_size_error:
    print_label s_supported_ints
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
    mov qword [rbp-16], %1

    ; this matches so the pointer move worked fine
    ; mov rax, [rbp-14]
    ; dbg_hexdump_reg rax

    ; element size
    mov dword [rbp-8], %2

    ; array size
    mov dword [rbp-4], %3

    call print_open_bracket

    ; counter
    mov rcx, 0

    ; 64 bit pointer to integer
    mov rax, [rbp-16]

    %%loop_elements:
        inc ecx

        ; 32 bit element size
        mov rdi, 0
        mov dword edi, [rbp-8] ; printed and verified to be 1
        call print_any_int

        ; increment pointer by size
        add rax, rdi

        cmp ecx, [rbp-4]
        je %%loop_elements_skip_comma
        call print_comma
        call print_space
        %%loop_elements_skip_comma:

        cmp ecx, [rbp-4]
        jl %%loop_elements

    call print_close_bracket

    mov rsp, rbp
    pop_registers
%endmacro

%macro print_int32_array 2
    ; print_int32_array [array buffer] [array size]
    print_int_array %1, 4, %2
%endmacro

%macro print_struct_array 4
    ; print_struct_array [array buffer] [element_print_callback] [element size] [array size]
    push_registers
    mov rbp, rsp

    ; allocate 2 64 bit register and for the pointers
    ; and 2 32 bit register for the integers
    sub rsp, 24

    ; array buffer
    mov qword [rbp-24], %1

    ; print callback
    mov qword [rbp-16], %2

    ; element size
    mov dword [rbp-8], %3

    ; array size
    mov dword [rbp-4], %4

    call print_open_bracket

    ; counter
    mov rcx, 0

    ; 64 bit pointer to struct
    mov rax, [rbp-24]

    %%loop_elements:
        inc ecx

        ; 32 bit element size
        mov rdi, 0
        mov dword edi, [rbp-8]
        call [rbp-16]

        ; increment pointer by size
        add rax, rdi

        cmp ecx, [rbp-4]
        je %%loop_elements_skip_comma
        call print_comma
        call print_space
        %%loop_elements_skip_comma:

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

print_colon:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_colon
    mov rdx, 1
    syscall

    pop_registers
    ret

print_open_curly:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_open_curly
    mov rdx, 1
    syscall

    pop_registers
    ret

print_close_curly:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_close_curly
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

print_close_paren:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_close_paren
    mov rdx, 1
    syscall

    pop_registers
    ret

print_open_paren:
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, char_open_paren
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

%macro print_i 0
    print_label s_print_i
    push rax
    mov rax, rcx
    call println_int32
    pop rax
%endmacro

dbg_println_uint32:
    ; dbg_print_num [rax]
    ;
    ; prints given arg as uint32 turned into a string
    ; to stdout
    ; prefixed with a debug string message
    push_registers

    print_label s_dbg_rax_digit

    ; pop of rax to pass it on to println_uint32
    pop_registers

    call println_uint32
    call print_newline

    ret

int32_to_str:
    ; int32_to_str [rax] [rdi]
    ;  rax = signed integer
    ;  rdi = output buffer
    ; returns into rax the size written
    push rdi
    push r9

    ; size counter
    mov r9, 0

    cmp rax, 0
    jge .int32_to_str_positive
.int32_to_str_negative:
    mov byte [rdi], '-'
    inc rdi
    neg rax
    inc r9
.int32_to_str_positive:
    call uint32_to_str
    add rax, r9

    pop r9
    pop rdi
    ret

uint32_to_str_seek_rdi:
    ; uint32_to_str [rax] [rdi]
    ;  rax = unsigned integer
    ;  rdi = output buffer
    ; seeks rdi by the amount of bytes written
    push rax
    call uint32_to_str
    add rdi, rax
    pop rax
    ret

uint32_to_str:
    ; uint32_to_str [rax] [rdi]
    ;  rax = unsigned integer
    ;  rdi = output buffer
    ; returns into rax the size written
    ;
    ; https://stackoverflow.com/a/46301894/6287070
    push_registers_keep_rax

    ; r12 = output buffer
    mov r12, rdi

    mov rcx, 0xa ; base 10
    push rcx ; ASCII newline '\n' = 0xa = base
    mov rsi, rsp
    sub rsp, 16 ; not needed on 64-bit Linux, the red-zone is big enough.  Change the LEA below if you remove this.

;;; rsi is pointing at '\n' on the stack, with 16B of "allocated" space below that.
.uint32_to_str_toascii_digit:                ; do {
    xor rdx, rdx
    div rcx ; edx=remainder = low digit = 0..9.  eax/=10
                                 ;; DIV IS SLOW.  use a multiplicative inverse if performance is relevant.
    add rdx, '0'
    dec rsi ; store digits in MSD-first printing order, working backwards from the end of the string
    mov [rsi], dl

    test rax,rax ; } while(x);
    jnz  .uint32_to_str_toascii_digit
;;; rsi points to the first digit

    ; rax = destination buffer pointer
    mov rax, r12
    ; rdi = source buffer pointer
    mov rdi, rsi
    ; rsi = truncation len (max size)
    lea r9, [rsp+16+1]
    sub r9, rsi
    mov rsi, r9
    dec rsi
    call str_copy

    add rsp, 24                ; (in 32-bit: add esp,20) undo the push and the buffer reservation

    mov rax, rsi
    pop_registers_keep_rax
    ret

println_int32:
    ; print_int32 [rax]
    call print_int32
    call print_newline
    ret

println_uint32:
    ; println_uint32 [rax]
    ;
    ; has a sub label toascii_digit
    ; and prints the given value in rax
    ; as a digit to stdout
    call print_uint32
    call print_newline
    ret

print_uint32:
    ; print_uint32 [rax]
    ;
    ; prints the given value in rax
    ; as a digit to stdout
    push_registers
    mov rbp, rsp

    ; allocate 16 byte string
    sub rsp, 16
    lea rdi, [rbp-16]

    call uint32_to_str

    lea rax, [rbp-16]
    print_c_str rax

    mov rsp, rbp
    pop_registers
    ret

print_int32:
    ; print_int32 [rax]
    ;
    ; prints the given value in rax
    ; as a digit to stdout
    push_registers
    mov rbp, rsp

    ; allocate 16 byte string
    sub rsp, 16
    lea rdi, [rbp-16]

    call int32_to_str

    lea rax, [rbp-16]
    print_c_str rax

    mov rsp, rbp
    pop_registers
    ret

