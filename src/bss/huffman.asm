; m_aNodes array of CNODE structs
huff_nodes resb HUFF_CNODE_SIZE * HUFFMAN_MAX_NODES

; aNodesLeftStorage[HUFFMAN_MAX_SYMBOLS];
huff_nodes_left_storage resb HUFF_CNODE_SIZE * HUFFMAN_MAX_SYMBOLS

; *apNodesLeft[HUFFMAN_MAX_SYMBOLS];
huff_nodes_left resb 4 * HUFFMAN_MAX_SYMBOLS

; m_apDecodeLut array of CNODE structs
huff_decode_lut resb HUFFMAN_LUTSIZE * 8

; pointer to start node
huff_start_node resb 8

; integer with amount of nodes
huff_num_nodes resb 4

