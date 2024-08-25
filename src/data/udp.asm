sizeof_sockaddr_struct dd 16
sockaddr_server dw AF_INET ; 0x2 0x00
            db 0x20, 0x6f ; port 8303
            db 0x7f, 0x0, 0x0, 0x01 ; 127.0.0.1
            db 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 ; watafk is this?!
SOCKADDR_PORT_OFFSET equ 2
SOCKADDR_ADDR_OFFSET equ 4

s_non_blocking_read db "doing a non blocking udp read ...", 0x0a
l_s_non_blocking_read equ $ - s_non_blocking_read
s_received_bytes db "[udp] received bytes: "
l_s_received_bytes equ $ - s_received_bytes
s_udp_error db "[udp] error: "
l_s_udp_error equ $ - s_udp_error

s_got_file_desc db "[udp] got file descriptor: "
l_s_got_file_desc equ $ - s_got_file_desc
s_got_udp db "[client] got udp: "
l_s_got_udp equ $ - s_got_udp

