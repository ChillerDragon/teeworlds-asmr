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

    jmp ._check_bounds_end
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

