%include "tests/assert.asm"

_start:
_test_call_huff_construct_tree:
    call _huff_construct_tree

_test_call_huff_construct_tree_assert_start_node:
    mov rax, qword [huff_start_node]
    huff_assert_nodes_ptr rax, __LINE__, __FILE__

_test_call_huff_construct_tree_assert_nodes:
    lea rsi, [huff_nodes + (HUFF_CNODE_SIZE * 511)]
    ; mov rax, rsi
    ; call huff_print_struct_cnode

    mov eax, [rsi + HUFF_CNODE_BITS_OFFSET]
    assert_eax_eq 0
    mov eax, [rsi + HUFF_CNODE_NUM_BITS_OFFSET]
    ; assert_eax_eq 0
    movzx rax, word [rsi + HUFF_CNODE_LEAF_0_OFFSET]
    assert_eax_eq 509
    movzx rax, word [rsi + HUFF_CNODE_LEAF_1_OFFSET]
    assert_eax_eq 510
    movzx rax, byte [rsi + HUFF_CNODE_SYMBOL_OFFSET]
    assert_eax_eq 0

    exit 0

