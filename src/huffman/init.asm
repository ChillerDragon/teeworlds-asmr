huff_init:
    push_registers

    ; only init once
    mov rax, 0
    mov al, byte [huff_is_initalized]
    cmp al, 1
    je .huff_init_end

    ; construct the tree
    call _huff_construct_tree

    ; build decode lut
    call _huff_build_decode_lut

    ; only init once
    mov byte [huff_is_initalized], 1
.huff_init_end:
    pop_registers
    ret

