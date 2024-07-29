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

%macro dbg_print_reg 1
    push_registers
    print s_dbg_reg_digit
    mov rax, %1
    call print_uint32
    call print_newline
    pop_registers
%endmacro

%macro is_rax_flag 1
    ; is_rax_flag [teeworlds bit flag constant]
    ;
    ; example:
    ;
    ;  mov rax, [udp_recv_buf]
    ;  is_rax_flag PACKETFLAG_CONTROL
    ;  jnz on_ctrl_message
    ;
    ; no idea if this "if statement" is correct
    push rax
    and al, %1
    cmp al, 0
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
%endmacro

%macro pop_registers 0
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

