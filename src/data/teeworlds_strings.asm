s_got_peer_token db "[client] got peer token: "
l_s_got_peer_token equ $ - s_got_peer_token
s_got_accept db "[client] got accept", 0x0a
l_s_got_accept equ $ - s_got_accept
s_got_ctrl_msg db "[client] got ctrl msg: "
l_s_got_ctrl_msg equ $ - s_got_ctrl_msg
s_unknown_ctrl_msg db "[client] unknown ctrl msg: "
l_s_unknown_ctrl_msg equ $ - s_unknown_ctrl_msg
s_got_packet_with_chunks db "[client] got packet with chunks: "
l_s_got_packet_with_chunks equ $ - s_got_packet_with_chunks
s_unhandled_packet db "[client] UNHANDLED PACKET!!"
l_s_unhandled_packet equ $ - s_unhandled_packet
s_unsupported_chunk_size db "[error] chunk sizes higher than 63 are not supported yet. got size: "
l_s_unsupported_chunk_size equ $ - s_unsupported_chunk_size
s_unsupported_seq_size db "[error] chunk sequence numbers higher than 255 are not supported yet. got sequence number: "
l_s_unsupported_seq_size equ $ - s_unsupported_seq_size
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