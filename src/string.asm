str_get_word_boundary_offset:
    ; str_get_word_boundary_offset [rax]
    ;  rax = pointer to null terminated string
    ; returns into rax offset as 0 based integer
    ;
    ; every non a-z character is considered a word boundary
    ;
    ; cring who uses uppercase
    ;
    ; if none is found the offset will match the string length
    push_registers_keep_rax

    mov r9, 0
    mov rcx, 0

    ._char_loop:
        cmp byte [rax+rcx], 0
        je ._end

        cmp byte [rax+rcx], 'a'
        jl ._end
        cmp byte [rax+rcx], 'z'
        jg ._end

        inc rcx
        jmp ._char_loop

    ._end:

    mov rax, rcx

    pop_registers_keep_rax
    ret

