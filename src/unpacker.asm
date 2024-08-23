; bss section:
;
; ; total size should never change
; unpacker_size resb 4
; 
; ; will be incremented
; unpacker_data_ptr resb 8
; 
; ; should not change and can be used
; ; to compute the size that was already consumed
; unpacker_data_start resb 8


%macro unpacker_reset 2
    push rbp

    mov rbp, rsp
    sub rsp, 16
    mov qword [rbp-16], %1
    mov qword [rbp-8], %2

    mov rax, qword [rbp-16]
    mov rdi, qword [rbp-8]
    call _unpacker_reset

    pop rbp
%endmacro

_unpacker_reset:
    ; _unpacker_reset [rax] [rdi]
    ;  rax = input buffer
    ;  rdi = input size
    mov qword [unpacker_data_ptr], rax
    mov qword [unpacker_data_start], rax
    mov dword [unpacker_size], edi
    ret

%define S_SIGN 4

get_int:
    ; get_int
    ; returns into rax the unpacked integer by value
    push_registers_keep_rax

    mov rbp, rsp
    sub rsp, S_SIGN
    mov dword [rbp-S_SIGN], 0

    ; const int Sign = (*pSrc >> 6) & 1;
    mov r9, [unpacker_data_ptr]
    movzx r8, byte [r9]
    shr r8, 6
    and r8, 1
    mov dword [rbp-S_SIGN], r8d

    ; rax is the output
    mov rax, 0

    ; *pInOut = *pSrc & 0x3F;
    mov r9, [unpacker_data_ptr]
    mov r8, 0
    mov r8b, byte [r9]
    and r8b, 0x3f
    mov rax, r8

    ._get_int_do_block:

    ; if(!(*pSrc & 0x80))
    ;   break;
    mov r9, [unpacker_data_ptr]
    movzx r8, byte [r9]
    and r8, 0x80
    cmp r8, 0
    je ._get_int_end

    ; pSrc++
    mov r9, [unpacker_data_ptr]
    inc r9
    mov [unpacker_data_ptr], r9

    movzx r8, byte [r9]
    and r8, 0x7f
    shl r8, 6

    ; if(!(*pSrc & 0x80))
    ;   break;
    mov r9, [unpacker_data_ptr]
    movzx r8, byte [r9]
    and r8, 0x80
    cmp r8, 0
    je ._get_int_end

    ; pSrc++
    mov r9, [unpacker_data_ptr]
    inc r9
    mov [unpacker_data_ptr], r9

    movzx r8, byte [r9]
    and r8, 0x7f
    shl r8, (6 + 7)

    ; if(!(*pSrc & 0x80))
    ;   break;
    mov r9, [unpacker_data_ptr]
    movzx r8, byte [r9]
    and r8, 0x80
    cmp r8, 0
    je ._get_int_end

    ; pSrc++
    mov r9, [unpacker_data_ptr]
    inc r9
    mov [unpacker_data_ptr], r9

    movzx r8, byte [r9]
    and r8, 0x7f
    shl r8, (6 + 7 + 7)

    ; if(!(*pSrc & 0x80))
    ;   break;
    mov r9, [unpacker_data_ptr]
    movzx r8, byte [r9]
    and r8, 0x80
    cmp r8, 0
    je ._get_int_end

    ; pSrc++
    mov r9, [unpacker_data_ptr]
    inc r9
    mov [unpacker_data_ptr], r9

    movzx r8, byte [r9]
    and r8, 0x7f
    shl r8, (6 + 7 + 7 + 7)

    ._get_int_end:

    ; pSrc++
    mov r9, [unpacker_data_ptr]
    inc r9
    mov [unpacker_data_ptr], r9

    ; *pInOut ^= -Sign; // if(sign) *i = ~(*i)
    mov r9, 0
    mov r9d, dword [rbp-S_SIGN]
    neg r9d
    xor eax, r9d

    mov rsp, rbp

    pop_registers_keep_rax
    ret

%undef S_SIGN

get_string:
    ; get_string
    ; returns into rax a pointer to the string
    ret

get_raw:
    ; get_raw [rax]
    ;  rax = size
    ; returns into rax a pointer to the raw data
    ret
