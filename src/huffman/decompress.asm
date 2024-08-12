huff_decompress:
    ; huff_decompress [rax] [rdi] [rsi] [rdx]
    ;  rax = input
    ;  rdi = input size
    ;  rsi = output
    ;  rdx = output size
    push_registers

    ; init can be called multiple times
    ; and it only does stuff once
    call huff_init

    pop_registers
    ret

