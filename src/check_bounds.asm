_check_bounds:
    ; check_bounds [rax] [rdi] [rsi] [rdx]
    ;  rax = pointer to check
    ;  rdi = array
    ;  rsi = element size (in bytes)
    ;  rdx = array size (in elements)
    push_registers

    ; rcx size of array in bytes
    mov rcx, rdx
    imul rcx, rsi
    ; rbx is end of array
    mov rbx, rdi
    add rbx, rcx

._check_bounds_check_oob_left:
    cmp rax, rdi
    jl ._check_bounds_oob_left

._check_bounds_check_oob_right:
    ; todo: is this jg or jge?
    cmp rax, rbx
    jg ._check_bounds_oob_right


._check_bounds_check_element_align:
    ; needed to not get floating point exception
    mov rdx, 0

    ; r8 is amount of bytes pointing into the array
    mov r8, rax
    sub r8, rdi

    ; is the offset divisible by element size
    mov eax, r8d
    div esi

    ; remainder is edx
    cmp edx, 0
    jne ._check_bounds_align_error

    jmp ._check_bounds_end
._check_bounds_align_error:
    puts  "[error] pointer inside of array but not at the start of an element."
    printlnf "  element offset: %d", rdx
    jmp ._check_bounds_error

._check_bounds_oob_left:
    puts  "[error] array pointer out of bounds. (pointer too low)"
    jmp ._check_bounds_error

._check_bounds_oob_right:
    puts  "[error] array pointer out of bounds. (pointer too high)"
    jmp ._check_bounds_error

._check_bounds_error:
    printlnf "         pointer: %p", rax
    printlnf "     array start: %p", rdi
    printlnf "       array end: %p", rbx
    exit 1

._check_bounds_end:
    pop_registers
    ret

