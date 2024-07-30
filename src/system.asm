str_length:
    ; str_length [rax]
    ;  rax = string buffer
    ; returns into rax the size of a null terminated string
    push_registers_keep_rax

    mov rcx, 0
.str_length_byte_loop:
    mov r9b, byte [rax+rcx]
    inc rcx
    cmp r9b, 0
    jne .str_length_byte_loop

    ; don't count the null byte as part of the string
    dec rcx
    mov rax, rcx
    pop_registers_keep_rax
    ret

mem_copy:
    ; mem_copy [rax] [rdi] [rsi]
    ;   rax = destination buffer pointer
    ;   rdi = source buffer pointer
    ;   rsi = size

    ; this is slow af and going byte by byte
    ; there has to be some blazingly fast way to copy
    ; copying more data with less instructions
    push_registers

    mov rcx, 0
    xor r9, r9
.mem_copy_byte_loop:
    mov r9b, byte [rdi+rcx]
    mov byte [rax+rcx], r9b
    inc rcx
    cmp rcx, rsi
    jb .mem_copy_byte_loop

    pop_registers
    ret

