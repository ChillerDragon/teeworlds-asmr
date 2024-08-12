%include "src/huffman/asserts.asm"
%include "src/huffman/bubble_sort.asm"
%include "src/huffman/set_bits_r.asm"
%include "src/huffman/construct_tree.asm"
%include "src/huffman/print_structs.asm"
%include "src/huffman/build_decode_lut.asm"
%include "src/huffman/init.asm"
%include "src/huffman/decompress.asm"

; public api:

; huff_decompress [rax] [rdi] [rsi] [rdx]
;  rax = input
;  rdi = input size
;  rsi = output
;  rdx = output size

