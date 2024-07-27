; print [string]
; string has a have a matching l_string length defintion
%macro print 1
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1
    %idefine str_len l_%1
    mov rdx, str_len
    %undef str_len
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax
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
%endmacro

%macro pop_registers 0
    pop r8
    pop r9
    pop r10
    pop r11
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

