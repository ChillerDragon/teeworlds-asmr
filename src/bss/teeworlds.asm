in_packet_header_num_chunks resb 1
in_packet_header_flags resb 1
in_packet_header_token resb 4

out_packet_header_num_chunks resb 1
out_packet_header_flags resb 1
out_packet_header_token resb 4

chunk_header_flags resb 1
chunk_header_size resb 4
chunk_header_sequence resb 4

; 4 byte matching C int
; nobody ever uses a char/short to store a socket
socket resb 4

; NET_MAX_PACKETSIZE 1400
; tw codebase also calls recvfrom with it
; the udp_recv_buf overflows into the packet payload label
; this is a hack to be able to access the payload without offsetting
; from the udp_recv_buf
;
; warning the packet_payload might contain huffman compressed data
; so only read from this label when it is a control message or you checked
; the compression flag
; if the compression flag is set there will be a decompressed payload in
; the label decompressed_packet_payload
udp_recv_buf resb PACKET_HEADER_LEN
packet_payload resb NET_MAX_PACKETSIZE ; 1400

; 0.6.4 packet header offsets
udp_recv6_buf resb PACKET6_HEADER_LEN
packet6_payload resb NET_MAX_PACKETSIZE ; 1400

; only set if the packet is compressed
; otherwise look at the label packet_payload
decompressed_packet_payload resb NET_MAX_PAYLOAD ; 1391

packer_buf resb 2048
packer_size resb 4

; NET_MAX_PACKETSIZE 1400
; tw codebase also calls recvfrom with it
udp_send_buf resb 1400

; integer holding offset into payload of `udp_send_buf`
; meaning `udp_payload_index 0` is the 7th byte in `udp_send_buf`
; and `udp_payload_index 1` is the 8th byte in `udp_send_buf`
udp_payload_index resb 4

; i was too lazy to verify the size of
; the sockaddr struct
; but the tw code also uses 128 bytes :shrug:
;
; ok nvm i tested it
;
; #include <sys/socket.h>
; printf("%d\n", sizeof(sockaddr));
; => 16
;
; idk is tw using way too much space?
; whatever ram is free these days
udp_srv_addr resb 128
udp_read_len resb 4
