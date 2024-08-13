%include "tests/assert.asm"

_start:
    mov rax, huff_nodes
    huff_assert_nodes_ptr rax, __LINE__, __FILE__

    lea rax, [huff_nodes + (HUFF_CNODE_SIZE*1)]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__

    lea rax, [huff_nodes + (HUFF_CNODE_SIZE*10)]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__
    exit 0
