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

; https://stackoverflow.com/a/49548057
str_to_int_unsigned:
    ; str_to_int [rax]
    ;  rax = string terminated by a non-digit
    ; returns integer into rax
    ; code by Peter Cordes
    push rdi
    push rcx
    mov rdi, rax
    movzx   eax, byte [rdi]    ; start with the first digit
    sub     eax, '0'           ; convert from ASCII to number
    cmp     al, 9              ; check that it's a decimal digit [0..9]
    jbe     .loop_entry        ; too low -> wraps to high value, fails unsigned compare check

    ; else: bad first digit: return 0
    xor     eax,eax
    ret

    ; rotate the loop so we can put the JCC at the bottom where it belongs
    ; but still check the digit before messing up our total
    .next_digit:                  ; do {
    lea     eax, [rax*4 + rax]    ; total *= 5
    lea     eax, [rax*2 + rcx]    ; total = (total*5)*2 + digit
    ; imul eax, 10  / add eax, ecx
    .loop_entry:
    inc     rdi
    movzx   ecx, byte [rdi]
    sub     ecx, '0'
    cmp     ecx, 9
    jbe     .next_digit ; } while( digit <= 9 )
    pop rcx
    pop rdi
    ret

