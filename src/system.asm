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

str_comp:
    ; str_comp [rax] [rdi]
    ;   rax = string to compare
    ;   rdi = other string to compare
    ; The strings are treated as zero-terminated strings.
    ;
    ; example:
    ;
    ;  mov rax, str_label_a
    ;  mov rdi, str_label_b
    ;  call str_comp
    ;  je strings_match
    ;
    push_registers

    ; r9b is rax string char
    ; r10b is rdi string char
    mov r9, 0
    mov r10, 0

    mov rcx, 0
.mem_copy_byte_loop:
    mov r9b, byte [rax+rcx]
    mov r10b, byte [rdi+rcx]
    inc rcx

    ; check match
    cmp r9b, r10b
    jne .str_comp_no_match

    ; check end of strings
    cmp r9b, 0
    je .str_comp_match
    cmp r10b, 0
    je .str_comp_match

    jmp .mem_copy_byte_loop

.str_comp_match:
    ; ugly hack to flip the zero flag like in is_rax_flag
    ; set EQUAL FLAG
    mov al, 0
    cmp al, 0
    jmp .str_comp_end

.str_comp_no_match:
    ; debug print non matching strings:

    ; print_label s_strings_do_not_match
    ; print_label s_string1
    ; print_c_str rax
    ; call print_single_quote
    ; call print_newline
    ; print_label s_string2
    ; print_c_str rdi
    ; call print_single_quote
    ; call print_newline

    ; ugly hack to flip the zero flag like in is_rax_flag
    ; set NOT EQUAL FLAG
    mov al, 0
    cmp al, 1

.str_comp_end:
    pop_registers
    ret

str_startswith:
    ; str_startswith [rax] [rdi]
    ;  rax = string
    ;  rdi = prefix (has to be null terminated)
    ; returns boolean into zero flag
    ; "je" jumps if the prefix is matched
    push_registers

    mov r9, 0

    ._str_startswith_loop:
    ; end of prefix is always match
    cmp byte [rdi], 0x00
    je ._str_startswith_match

    ; compare
    mov r9b, byte [rax]
    cmp byte [rdi], r9b
    jne ._str_startswith_no_match

    inc rax
    inc rdi
    jmp ._str_startswith_loop

._str_startswith_match:
    ; ugly hack to flip the zero flag like in is_rax_flag
    ; set EQUAL FLAG

    mov al, 0
    cmp al, 0

    jmp ._str_startswith_end

._str_startswith_no_match:
    ; ugly hack to flip the zero flag like in is_rax_flag
    ; set NOT EQUAL FLAG

    mov al, 0
    cmp al, 1

._str_startswith_end:
    pop_registers
    ret

str_copy:
    ; str_copy [rax] [rdi] [rsi]
    ;   rax = destination buffer pointer
    ;   rdi = source buffer pointer
    ;   rsi = truncation len (max size)
    ; returns into rax the amount of bytes copied
    push_registers_keep_rax

    mov rcx, 0
    xor r9, r9
.mem_copy_byte_loop:
    mov r9b, byte [rdi+rcx]
    mov byte [rax+rcx], r9b

    ; source end (null byte)
    cmp r9, 0
    je .mem_copy_loop_end

    inc rcx

    ; max size
    cmp rcx, rsi
    jb .mem_copy_byte_loop

.mem_copy_loop_end:

    ; ensure null termination
    mov byte [rax+rcx], 0

    ; size copied
    mov rax, rcx

    pop_registers_keep_rax
    ret

str_find_char:
    ; str_find_char [rax] [rdi]
    ;  rax = pointer to haystack nullterminated string
    ;  rdi = character to find by value
    ; returns into rax the offset if found and -1 if not found
    push_registers_keep_rax

    mov r9, 0

    mov rcx, 0

    ._str_find_char_loop:
        cmp byte [rax+rcx], 0
        je ._str_find_char_no_match

        cmp byte [rax+rcx], dil
        je ._str_find_char_match

        inc rcx
        jmp ._str_find_char_loop

    ._str_find_char_match:
    mov rax, rcx
    jmp ._str_find_char_end

    ._str_find_char_no_match:
    mov rax, -1

    ._str_find_char_end:

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

    ; copy 0 bytes if the size is zero
    cmp rsi, 0
    je .mem_copy_end

    mov rcx, 0
    xor r9, r9
.mem_copy_byte_loop:
    mov r9b, byte [rdi+rcx]
    mov byte [rax+rcx], r9b
    inc rcx
    cmp rcx, rsi
    jb .mem_copy_byte_loop

.mem_copy_end:
    pop_registers
    ret

