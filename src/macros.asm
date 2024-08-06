%macro str_to_stack 1
    ; str_to_stack [fixed str]
    ; returns into rax a pointer to the stack
    ; containing the string
    ; it will also add a null byte in the end
    ;
    ; you have to free the stack value manually. Before that you can not use `push` or `pop`
    ; because the stack is shifted.
    ; to free it run:
    ;
    ;  mov rsp, rbp
    ;
    %strlen _fmt_len %1
    mov rbp, rsp
    sub rsp, _fmt_len
    sub rsp, 1 ; nullbyte

    %assign letter_index 0
    %rep _fmt_len

    %assign letter_index letter_index+1

    %substr letter %1, letter_index, 1
    mov byte [rbp-((_fmt_len+2)-letter_index)], letter
    %endrep

    mov byte [rbp-1], 0

    lea rax, [rbp-(_fmt_len+1)]
%endmacro

%macro stack_printer 1
    ; stack_printer [fixed str]
    ;
    ; moves a string onto the stack
    ; and then prints it
    ;
    ; example:
    ;
    ;  stack_printer "hello world"
    ;
    push rbp
    str_to_stack %1
    print_c_str rax
    mov rsp, rbp
    pop rbp
%endmacro

%macro printdf 2
    ; printdf [format str] [int]
    push_registers

    ; rax = is null terminated format str
    str_to_stack %1

    %define MAX_PRINTF_LEN 10

    sub rsp, MAX_PRINTF_LEN
    ; r10 is index in final output string
    mov r10, 0
    ; r11 is pointer to start of output string
    lea r11, [rbp-MAX_PRINTF_LEN]

    mov rcx, 0
.printf_fmt_char_loop:
    mov r9b, byte [rax+rcx]
    inc rcx

    ; copy one letter from the format string
    ; to the output buffer
    mov byte [r11+r10], r9b
    inc r10

    cmp r9b, 0
    jne .printf_fmt_char_loop

    ; print output buffer
    printn r11, r10

    ; frees stack string
    ; and copy buffer
    mov rsp, rbp
    pop_registers
%endmacro

; print_label [string]
; string has a have a matching l_string length definition
%macro print_label 1
    push_registers

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1
    %idefine str_len l_%1
    mov rdx, str_len
    %undef str_len
    syscall

    pop_registers
%endmacro

; puts [string constant]
; see also: print (no newline)
; example:
;
;  puts "hello world"
;
%macro puts 1
    print %1
    call print_newline
%endmacro


; print [string constant]
; see also: puts (with newline)
;
; example:
;
;  puts "hello world"
;
%macro print 1
    section .data
%%string:
    db %1,0
    section .text
    print_c_str %%string
%endmacro

; printn [string] [length]
; print length amount of characters in given buffer
%macro printn 2
    push_registers

    mov r9, %1
    mov r10, %2

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, r9
    mov rdx, r10
    syscall

    pop_registers
%endmacro

; print_c_str [string]
; print null terminated string
%macro print_c_str 1
    push rax
    push r9

    mov r9, %1

    mov rax, r9
    call str_length
    printn r9, rax

    pop r9
    pop rax
%endmacro

%macro dbg_hexdump_reg 1
    ; dbg_hexdump_reg [register]
    push_registers

    print_label s_dbg_hexdump_register
    push %1

    mov rax, rsp
    mov rdi, 8
    call print_hexdump
    call print_newline

    pop %1

    pop_registers
%endmacro

%macro dbg_print_reg 1
    push_registers
    print_label s_dbg_reg_digit
    mov rax, %1
    call println_uint32
    pop_registers
%endmacro

%macro is_rax_flag 1
    ; is_rax_flag [teeworlds bit flag constant]
    ;
    ; example:
    ;
    ;  mov rax, [udp_recv_buf]
    ;  is_rax_flag PACKETFLAG_CONTROL
    ;  je on_ctrl_message
    ;
    push rax
    and al, %1
    cmp al, 0

    ; ugly hack to flip the zero flag
    ; we have to compare to zero after the end
    ; to verify if the flag is set
    ; but if it matches to zero it means it is not set
    ; so to have a nicer api from the outside
    ; we flip the zero flag in the end
    ; which could be done with pushf and shaf but i decided to
    ; hardcode another cmp for simplicity
    ;
    ; now callee of the macro can use `je` as a check if the flag is set
    ; instead of `jne` meaning the flag is set

    jne %%match

    %%no_match:
    mov al, 0
    cmp al, 1
    jmp %%is_rax_flag_end

    %%match:
    mov al, 0
    cmp al, 0

    %%is_rax_flag_end:
    pop rax
%endmacro

%macro is_rcx_flag 1
    push rax

    mov rax, rcx
    is_rax_flag %1

    pop rax
%endmacro

%macro set_rax_flag 1
    ; set_rax_flag [teeworlds bit flag constant]
    ;
    ; sets a bit flag
    ;
    ; example:
    ;
    ;  mov rax, 0
    ;  set_rax_flag CHUNKFLAG_VITAL
    ;
    push rcx

    mov cl, %1
    or al, cl

    pop rcx
%endmacro

%macro push_registers 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push rbp
%endmacro

%macro pop_registers 0
    pop rbp
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

; useful when you want to use rax as return value
%macro push_registers_keep_rax 0
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push rbp
%endmacro

; useful when you want to use rax as return value
%macro pop_registers_keep_rax 0
    pop rbp
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
%endmacro

%macro shift_left 2
    ; shift_left [register] [amount]
    ;
    ; I saw with objdump that `shl edx, cl` is possible.
    ; But nasm refuses to compile it
    ;
    ; So this macro polyfills it
    ; shift left n bits
    mov rbp, rsp
    sub rsp, 8

    push rcx
    push r12

    ; register
    mov [rbp-8], %1

    ; amount
    mov r12, %2

    mov rcx, 0
    %%shift_left_loop:
        inc rcx
        cmp rcx, r12
        jge %%shift_left_loop_end

        shl qword [rbp-8], 1

        jmp %%shift_left_loop
    %%shift_left_loop_end:

    pop r12
    pop rcx

    mov %1, [rbp-8]

    mov rsp, rbp
%endmacro

