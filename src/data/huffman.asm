HUFFMAN_EOF_SYMBOL equ 256
HUFFMAN_MAX_SYMBOLS equ HUFFMAN_EOF_SYMBOL + 1
HUFFMAN_MAX_NODES equ HUFFMAN_MAX_SYMBOLS * 2 - 1

HUFFMAN_LUTBIS equ 10
HUFFMAN_LUTSIZE equ 1024
HUFFMAN_LUTMASK equ HUFFMAN_LUTSIZE - 1

; struct CNode
; {
; 	unsigned m_Bits;
; 	unsigned m_NumBits;
;
; 	unsigned short m_aLeafs[2];
;
; 	unsigned char m_Symbol;
;
; 	// 2 byte bloated C padding
; }

HUFF_CNODE_BITS_OFFSET equ 0
HUFF_CNODE_NUM_BITS_OFFSET equ 4
HUFF_CNODE_LEAF_0_OFFSET equ 8
HUFF_CNODE_LEAF_1_OFFSET equ 10
HUFF_CNODE_SYMBOL_OFFSET equ 12 ; 1 byte
; 2 byte padding
HUFF_CNODE_SIZE equ 16

; struct CHuffmanConstructNode
; {
; 	unsigned short m_NodeId;
; 	int m_Frequency;
;
; 	// 2 byte bloated C padding
; }

HUFF_CCONSTRUCTION_NODE_NODE_ID_OFFSET equ 0
HUFF_CCONSTRUCTION_NODE_FREQUENCY_OFFSET equ 2 ; 4 byte
; 2 byte padding
HUFF_CCONSTRUCTION_NODE_SIZE equ 8

HUFF_FREQ_TABLE dd 1073741824,4545,2657,431,1950,919,444,482,2244,617,838,542,715,1814,304,240,754,212,647,186, \
	283,131,146,166,543,164,167,136,179,859,363,113,157,154,204,108,137,180,202,176, \
	872,404,168,134,151,111,113,109,120,126,129,100,41,20,16,22,18,18,17,19, \
	16,37,13,21,362,166,99,78,95,88,81,70,83,284,91,187,77,68,52,68, \
	59,66,61,638,71,157,50,46,69,43,11,24,13,19,10,12,12,20,14,9, \
	20,20,10,10,15,15,12,12,7,19,15,14,13,18,35,19,17,14,8,5, \
	15,17,9,15,14,18,8,10,2173,134,157,68,188,60,170,60,194,62,175,71, \
	148,67,167,78,211,67,156,69,1674,90,174,53,147,89,181,51,174,63,163,80, \
	167,94,128,122,223,153,218,77,200,110,190,73,174,69,145,66,277,143,141,60, \
	136,53,180,57,142,57,158,61,166,112,152,92,26,22,21,28,20,26,30,21, \
	32,27,20,17,23,21,30,22,22,21,27,25,17,27,23,18,39,26,15,21, \
	12,18,18,27,20,18,15,19,11,17,33,12,18,15,19,18,16,26,17,18, \
	9,10,25,22,22,17,20,16,6,16,15,20,14,18,24,335,1517
HUFF_FREQ_TABLE_SIZE equ ($ - HUFF_FREQ_TABLE) / 4
; print_int32_array HUFF_FREQ_TABLE, HUFF_FREQ_TABLE_SIZE

s_huff_nodes_i_num_bits db "[huff] nodes[i].num_bits="
l_s_huff_nodes_i_num_bits equ $ - s_huff_nodes_i_num_bits

s_huff_num_nodes_left db "[huff] num_nodes_left="
l_s_huff_num_nodes_left equ $ - s_huff_num_nodes_left

s_huff_set_bits db "[huff] setbits_r(pNode="
l_s_huff_set_bits equ $ - s_huff_set_bits


s_huff_bits_eq db "bits="
l_s_huff_bits_eq equ $ - s_huff_bits_eq

s_huff_depth_eq db "depth="
l_s_huff_depth_eq equ $ - s_huff_depth_eq

s_huff_node_colon db "  node: "
l_s_huff_node_colon equ $ - s_huff_node_colon

