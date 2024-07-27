; take one arg

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
%endmacro

%macro pop_registers_keep_rax 0
    pop r8
    pop r9
    pop r10
    pop r11
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
%endmacro

; take zero args

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

