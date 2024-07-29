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
