pack_int:
    ; pack_int [rax] [rdi]
    ;  rax = integer
    ;  rdi = buffer to write to
    ; returns the number of bytes written to rax
    push_registers

    mov byte [rdi], al

    pop_registers
    ret
