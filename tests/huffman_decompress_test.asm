%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_huff_decompress_A:
    ; matching huffman-py test case

    ; def test_huffman_A():
    ;     huffman = Huffman()
    ;     compressed = bytes([188, 21, 55, 0])
    ;     decompressed = huffman.decompress(compressed)
    ;     expected = b'A'
    ;     assert decompressed == expected

    ; huff_decompress [rax] [rdi] [rsi] [rdx]
    ;  rax = input
    ;  rdi = input size
    ;  rsi = output
    ;  rdx = output size

    mov byte [generic_buffer_128 + 0], 188
    mov byte [generic_buffer_128 + 1], 21
    mov byte [generic_buffer_128 + 2], 55
    mov byte [generic_buffer_128 + 3], 0

    ;  rax = input
    mov rax, generic_buffer_128
    ;  rdi = input size
    mov rdi, 4
    ;  rsi = output
    mov rsi, generic_buffer_512
    ;  rdx = output size
    mov rdx, 512
    call huff_decompress

    mov rax, 0
    mov al, byte [generic_buffer_512]
    assert_al_eq 'A', __LINE__

_test_huff_decompress_AABB:
    ; matching huffman-py test case

    ; def test_huffman_AABB():
    ;     huffman = Huffman()
    ;     compressed = bytes([0xbc, 0x79, 0x6b, 0xa5, 0x95, 0xe2, 0x06])
    ;     decompressed = huffman.decompress(compressed)
    ;     expected = b'AABB'
    ;     assert decompressed == expected

    ; huff_decompress [rax] [rdi] [rsi] [rdx]
    ;  rax = input
    ;  rdi = input size
    ;  rsi = output
    ;  rdx = output size

    mov byte [generic_buffer_128 + 0], 0xbc
    mov byte [generic_buffer_128 + 1], 0x79
    mov byte [generic_buffer_128 + 2], 0x6b
    mov byte [generic_buffer_128 + 3], 0xa5
    mov byte [generic_buffer_128 + 4], 0x95
    mov byte [generic_buffer_128 + 5], 0xe2
    mov byte [generic_buffer_128 + 6], 0x06

    ;  rax = input
    mov rax, generic_buffer_128
    ;  rdi = input size
    mov rdi, 7
    ;  rsi = output
    mov rsi, generic_buffer_512
    ;  rdx = output size
    mov rdx, 512
    call huff_decompress

    mov rax, 0
    mov eax, dword [generic_buffer_512]
    assert_eax_eq 'AABB', __LINE__

    exit 0

