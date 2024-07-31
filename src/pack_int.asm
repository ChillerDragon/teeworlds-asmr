_pack_int:
    ; _pack_int [rax] [rdi]
    ;  rax = integer
    ;  rdi = buffer to write to
    ; returns offsetted pointer in rax
    ;
    ; you probably want to use one of those macros:
    ;
    ;   pack_int                 - pack into buffer
    ;   packet_packer_pack_int   - pack directly into packet payload
    ;
    push_registers_keep_rax

    mov byte [rdi], 0

    ; if input number is negative
    cmp eax, 0
    jl .pack_int_negative
    jmp .pack_int_skip_negative
.pack_int_negative:
    mov byte [rdi], 0x40
    not eax

.pack_int_skip_negative:

    ; pack 6 bit into dst
    mov rcx, 0
    mov ecx, eax
    and ecx, 0b0011_1111
    mov byte dl, [rdi]
    or dl, cl
    mov byte [rdi], dl

    ; discard 6 bits
    shr eax, 6

.pack_int_loop:
    cmp eax, 0
    je .pack_int_end

    ; set extended bit
    mov byte dl, [rdi]
    or dl, 0b1000_0000
    mov byte [rdi], dl

    ; increment pointer
    inc rdi

    ; pack 7 bits
    mov ecx, eax
    and ecx, 0b0111_1111
    mov byte [rdi], cl

    ; discard 7 bits
    shr eax, 7

    jmp .pack_int_loop
.pack_int_end:

    ; increment pointer
    inc rdi
    mov rax, rdi

    pop_registers_keep_rax
    ret

