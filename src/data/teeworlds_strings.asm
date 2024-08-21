s_packer_size db "[packer] amount of bytes packed: "
l_s_packer_size equ $ - s_packer_size

s_got_peer_token db "[client] got peer token: "
l_s_got_peer_token equ $ - s_got_peer_token
s_got_accept db "[client] got accept", 0x0a
l_s_got_accept equ $ - s_got_accept
s_got_ctrl_msg db "[client] got ctrl msg: "
l_s_got_ctrl_msg equ $ - s_got_ctrl_msg
s_unknown_ctrl_msg db "[client] unknown ctrl msg: "
l_s_unknown_ctrl_msg equ $ - s_unknown_ctrl_msg
s_unknown_game_msg db "[client] unknown game msg: "
l_s_unknown_game_msg equ $ - s_unknown_game_msg
s_unknown_system_msg db "[client] unknown system msg: "
l_s_unknown_system_msg equ $ - s_unknown_system_msg
s_got_packet_with_chunks db "[client] got packet with chunks: "
l_s_got_packet_with_chunks equ $ - s_got_packet_with_chunks
s_unhandled_packet db "[client] UNHANDLED PACKET!!"
l_s_unhandled_packet equ $ - s_unhandled_packet
s_got_chunk_header db "[client] got chunk header:", 0x0a
l_s_got_chunk_header  equ $ - s_got_chunk_header
s_size db "[client]  size: "
l_s_size  equ $ - s_size
s_sequence db "[client]  sequence: "
l_s_sequence  equ $ - s_sequence
s_vital_yes db "[client]  vital: YES", 0x0a
l_s_vital_yes  equ $ - s_vital_yes
s_vital_no db "[client]  vital: NO", 0x0a
l_s_vital_no  equ $ - s_vital_no
s_resend_yes db "[client]  resend: YES", 0x0a
l_s_resend_yes  equ $ - s_resend_yes
s_resend_no db "[client]  resend: NO", 0x0a
l_s_resend_no  equ $ - s_resend_no
s_got_disconnect db "[client] got disconnect from server.", 0x0a
l_s_got_disconnect  equ $ - s_got_disconnect
s_got_disconnect_with_reason db "[client] got disconnect from server. reason: "
l_s_got_disconnect_with_reason  equ $ - s_got_disconnect_with_reason
s_got_game_msg_with_id db "[client] got game message with id: "
l_s_got_game_msg_with_id equ $ - s_got_game_msg_with_id
s_got_system_msg_with_id db "[client] got system message with id: "
l_s_got_system_msg_with_id equ $ - s_got_system_msg_with_id
s_got_end_of_packet_with_chunks_left db "[client] got end of packet with chunks left: "
l_s_got_end_of_packet_with_chunks_left equ $ - s_got_end_of_packet_with_chunks_left
s_parser_bytes_red db "[client] parser bytes red: "
l_s_parser_bytes_red equ $ - s_parser_bytes_red
s_map_change db "[client] got map change. new map: "
l_s_map_change equ $ - s_map_change
s_motd db "[motd] "
l_s_motd equ $ - s_motd


s_sending_packet_with_size db "[client] sending packet with size: "
l_s_sending_packet_with_size equ $ - s_sending_packet_with_size

s_current_outgoing_packet_bytes db "[client] current outgoing packet bytes: "
l_s_current_outgoing_packet_bytes equ $ - s_current_outgoing_packet_bytes

s_got_compressed_packet db "[client] got huffman compressed packed. that is not supported yet. panic!", 0x0a
l_s_got_compressed_packet equ $ - s_got_compressed_packet

