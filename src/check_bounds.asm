_check_bounds_print_line_trace:
    printf "\n\n[error] in "
    print_c_str r8
    printlnf ":%d", r10
    ret

_check_bounds:
    ; check_bounds [rax] [rdi] [rsi] [rdx] [r10] [r8]
    ;  rax = pointer to check
    ;  rdi = array
    ;  rsi = element size (in bytes)
    ;  rdx = array size (in elements)
    ;  r10 = line number
    ;  r8 = todo file
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

    push r8

    ; r8 is amount of bytes pointing into the array
    mov r8, rax
    sub r8, rdi

    ; is the offset divisible by element size
    mov eax, r8d
    div esi

    pop r8

    ; remainder is edx
    cmp edx, 0
    jne ._check_bounds_align_error

    jmp ._check_bounds_end
._check_bounds_align_error:
    call _check_bounds_print_line_trace
    puts  "        pointer inside of array but not at the start of an element."
    printlnf "  element offset: %d", rdx
    jmp ._check_bounds_error

._check_bounds_oob_left:
    call _check_bounds_print_line_trace
    puts  "        array pointer out of bounds. (pointer too low)"
    jmp ._check_bounds_error

._check_bounds_oob_right:
    call _check_bounds_print_line_trace
    puts  "        array pointer out of bounds. (pointer too high)"
    jmp ._check_bounds_error

._check_bounds_error:
    printlnf "         pointer: %p", rax
    printlnf "     array start: %p", rdi
    printlnf "       array end: %p\n", rbx
    exit 1

._check_bounds_end:
    pop_registers
    ret

