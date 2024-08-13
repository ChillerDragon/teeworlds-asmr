%include "tests/assert.asm"

_start:
    call _huff_construct_tree

    mov rax, qword [huff_start_node]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__

    exit 0

