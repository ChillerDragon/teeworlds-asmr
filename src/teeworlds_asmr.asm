; teeworlds_asmr by ChillerDragon
; vim: set tabstop=4:softtabstop=4:shiftwidth=4
; vim: set expandtab:
; x86_64 assembly linux ( nasm )

; 64bit register
; 00000000 00000000 00000000 0000000 00000000 00000000 00000000 00000000
;                                                               \______/
;                                                                   |
;                                                                   al
;                                                      \_______________/
;                                                               |
;                                                               ax
;                                    \_________________________________/
;                                                    |
;                                                   eax
; \____________________________________________________________________/
;                               |
;                              rax

; +-----------------------------------+
; | 8-bit  | 16-bit | 32-bit | 64-bit |
; +--------+--------+--------+--------+
; | al     | ax     | eax    | rax    |
; | bl     | bx     | ebx    | rbx    |
; | cl     | cx     | ecx    | rcx    |
; | dl     | dx     | edx    | rdx    |
; | sil    | si     | esi    | rsi    |
; | dil    | di     | edi    | rdi    |
; | bpl    | bi     | ebp    | rbp    |
; | spl    | sp     | esp    | rsp    |
; | r8b    | r8w    | r8d    | r8     |
; | r9b    | r9w    | r9d    | r9     |
; | r10b   | r10w   | r10d   | r10    |
; | r11b   | r11w   | r11d   | r11    |
; | r12b   | r12w   | r12d   | r12    |
; | r13b   | r13w   | r13d   | r13    |
; | r14b   | r14w   | r14d   | r14    |
; | r15b   | r15w   | r15d   | r15    |
; +--------+--------+--------+--------+

; System call inputs
; +-----+----------+
; | Arg | Register |
; +-----+----------+
; | ID  | rax      |
; | 1   | rdi      |
; | 2   | rsi      |
; | 3   | rdx      |
; | 4   | r10      |
; | 5   | r8       |
; | 6   | r9       |
; +-----+----------+

; rax - register a extended
; rbx - register b extended
; rcx - register c extended
; rdx - register d extended
; rbp - register base pointer (start of stack)
; rsp - register stack pointer (current location in stack, growing downwards)
; rsi - register source index (source for data copies)
; rdi - register destination index (destination for data copies)

; calling convention for this code base is matching the one
; of linux sys calls
; so function arguments have to be filled in those registers
; in the following order:
;
; rax, rdi, rsi, rdx, r10, r8, r9
;
; and rax is used for the return value

; System call list
; /usr/include/asm/unistd_64.h
; /usr/include/x86_64-linux-gnu/asm/unistd_64.h
; https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

; byte   db - 1 byte
; word   dw - 2 byte
; dword  dd - 4 byte
; qword  dq - 8 byte

global _start:

section .data
    ; constants
    %include "src/data/syscalls.asm"
    %include "src/data/teeworlds.asm"
    %include "src/data/terminal.asm"

    STDOUT       equ         1
    KEY_A        equ         97
    KEY_D        equ         100
    KEY_ESC      equ         27
    KEY_RETURN   equ         13
    AF_INET      equ         0x2
    SOCK_DGRAM   equ         0x2

    ; application constants
    HEX_TABLE   db "0123456789ABCDEF", 0
    char_newline     db 0x0a
    char_space       db 0x20

    ; networking
    max_sockaddr_read_size dd 128
    sockaddr_localhost_8303 dw AF_INET ; 0x2 0x00
                db 0x20, 0x6f ; port 8303
                db 0x7f, 0x0, 0x0, 0x01 ; 127.0.0.1
                db 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 ; watafk is this?!

    ; strings
    s_menu db "+--+ teeworlds_asmr (ESCAPE to quit the game) +--+",0x0a
    l_s_menu equ $ - s_menu
    s_end db "quitting the game...",0x0a
    l_s_end equ $ - s_end
    s_you_pressed_a db "you pressed a",0x0a
    l_s_you_pressed_a equ $ - s_you_pressed_a
    s_you_pressed_d db "you pressed d",0x0a
    l_s_you_pressed_d equ $ - s_you_pressed_d
    s_dbg_rax_digit db "[debug] value of rax is: ", 0
    l_s_dbg_rax_digit equ $ - s_dbg_rax_digit
    s_dbg_reg_digit db "[debug] value of register is: ", 0
    l_s_dbg_reg_digit equ $ - s_dbg_reg_digit
    s_got_file_desc db "got file descriptor: "
    l_s_got_file_desc equ $ - s_got_file_desc
    s_got_udp db "[client] got udp: "
    l_s_got_udp equ $ - s_got_udp
    s_len db "[client]     len: "
    l_s_len equ $ - s_len
    s_blocking_read db "doing a blocking udp read ...", 0x0a
    l_s_blocking_read equ $ - s_blocking_read
    s_received_bytes db "[udp] received bytes: "
    l_s_received_bytes equ $ - s_received_bytes
    s_packer_size db "[packer] amount of bytes packed: "
    l_s_packer_size equ $ - s_packer_size

    ; teeworlds strings
    s_got_peer_token db "[client] got peer token: "
    l_s_got_peer_token equ $ - s_got_peer_token
    s_got_ctrl_msg db "[client] got ctrl msg: "
    l_s_got_ctrl_msg equ $ - s_got_ctrl_msg

section .bss
    ; 4 byte matching C int
    ; nobody ever uses a char/short to store a socket
    socket resb 4

    ; this is too long
    ; for now we only store 2 character in here
    hex_str resb 512

    ; NET_MAX_PACKETSIZE 1400
    ; tw codebase also calls recvfrom with it
    udp_recv_buf resb 1400

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
section .text

%include "src/macros.asm"

%include "src/logger.asm"
%include "src/hex.asm"
%include "src/terminal.asm"
%include "src/udp.asm"
%include "src/packer.asm"

set_packet_header:
    push_registers

    ; flags and size
    mov byte [udp_send_buf], 0x04
    mov byte [udp_send_buf + 1], 0x00
    mov byte [udp_send_buf + 2], 0x00

    ; peer token
    mov al, byte [peer_token]
    mov [udp_send_buf + 3], al
    mov al, byte [peer_token + 1]
    mov [udp_send_buf + 4], al
    mov al, byte [peer_token + 2]
    mov [udp_send_buf + 5], al
    mov al, byte [peer_token + 3]
    mov [udp_send_buf + 6], al

    pop_registers
    ret

mem_copy:
    ; mem_copy [rax] [rdi] [rsi]
    ;   rax = destination buffer pointer
    ;   rdi = source buffer pointer
    ;   rsi = size

    ; this is slow af and going byte by byte
    ; there has to be some blazingly fast way to copy
    ; copying more data with less instructions
    push_registers

    mov rcx, 0
    xor r9, r9
.mem_copy_byte_loop:
    mov r9b, byte [rdi+rcx]
    mov byte [rax+rcx], r9b
    inc rcx
    cmp rcx, rsi
    jb .mem_copy_byte_loop

    pop_registers
    ret

send_packet:
    ; send_packet
    ;  the size will be the PACKET_HEADER_LEN + udp_payload_index
    ;
    ;  if you want to pass in a payload use
    ;  send_packet_with_payload
    ;  otherwise you have to make sure to fill
    ;  `udp_send_buf` starting at offset `PACKET_HEADER_LEN`
    ;  before calling send_packet
    ;
    ;  example:
    ;
    ; lea rax, [udp_send_buf + PACKET_HEADER_LEN]
    ; mov byte [rax], 0xFF
    ; lea rax, [udp_send_buf + PACKET_HEADER_LEN + 1]
    ; mov byte [rax], 0xFF
    ; call send_packet
    ;
    ;  or use one of the helpers:
    ;
    ; packer_reset
    ; pack_byte 0xFF
    ; pack_byte 0xFF
    ; call send_packet
    ;
    push rax
    push rdi

    call set_packet_header

    ; buf
    mov rax, udp_send_buf

    ; size
    xor rdi, rdi
    ; TODO: not sure about the whole 4 byte buffer vs 8 byte register thing
    mov edi, [udp_payload_index]
    add rdi, PACKET_HEADER_LEN

    call send_udp

    pop rdi
    pop rax
    ret

send_packet_with_payload:
    ; send_packet_with_payload [rax] [rdi]
    ;  rax = pointer to payload buffer
    ;  rdi = payload buffer size
    call set_packet_header

    ; push rdi
    ; mov rdi, 6
    ; call print_hexdump
    ; pop rdi

    push rax
    push rdi
    push rsi

    mov rsi, rdi ; copy size
    mov rdi, rax ; copy source
    lea rax, [udp_send_buf + PACKET_HEADER_LEN] ; copy destination
    call mem_copy

    pop rsi
    pop rdi
    pop rax

    mov rax, udp_send_buf
    add rdi, PACKET_HEADER_LEN
    call send_udp
    ret

send_ctrl_msg_connect:
    push rax

    packer_reset
    pack_byte MSG_CTRL_CONNECT
    pack_raw token, 4

    ; hack to send a bunch of bytes to pass the
    ; anti reflection attack check
    ; those bytes are not set here so their last used values will be sent
    ; this should for the first connection be all zeros
    ; which is exactly what we want
    ;
    ; for later connections it might leak contents of packets we sent before that
    ; the server does not need null bytes it just cares about the size
    ; but we as a client might leak information sent to one server to another
    ;
    ; imagine the following scenario
    ; we send a rcon auth on server a filling the udp_send_buf with our rcon password
    ; and then we connect to another server
    ; where we send 512 bytes of the udp_send_buf which still holds the rcon password
    mov dword [udp_payload_index], 512

    packer_print_size

    call send_packet

    pop rax
    ret

on_ctrl_msg_token:
    mov rax, [udp_recv_buf + 8]
    mov [peer_token], rax

    print s_got_peer_token
    mov rax, peer_token
    mov rdi, 4
    call print_hexdump
    call print_newline

    call send_ctrl_msg_connect

    ret

on_ctrl_message:
    push rax

    call on_ctrl_msg_token

    print s_got_ctrl_msg

    xor rax, rax
    mov al, [udp_recv_buf + PACKET_HEADER_LEN]
    call print_uint32

    pop rax
    ret

on_packet:
    call on_ctrl_message
    ret

print_udp:
    print s_got_udp
    ; hexdump
    mov rax, udp_recv_buf
    mov rdi, [udp_read_len]
    call print_hexdump
    call print_newline
    ; [client]     len: %d
    print s_len
    mov rax, [udp_read_len]
    call print_uint32
    call print_newline

    call on_packet
    ret

on_udp_packet:
    call print_udp
    ret

connect:
    mov dword [peer_token], 0xFFFFFFFF

    mov rax, PAYLOAD_CTRL_TOKEN
    mov rdi, PAYLOAD_CTRL_TOKEN_LEN
    call send_packet_with_payload

    ret

pump_network:
    print s_blocking_read
    call recv_udp
    mov rax, [udp_read_len]
    test rax, rax
    ; if recvfrom returned negative
    ; we do not process the udp payload
    js .pump_network_no_data
    call on_udp_packet
.pump_network_no_data
    ret

key_a:
    print s_you_pressed_a
    call connect
    call pump_network
    jmp keypress_end

key_d:
    print s_you_pressed_d
    jmp keypress_end

keypresses:
    call insane_console
    ; read char
    mov rax, SYS_READ ; __NR_read
    mov rdi, 0 ; fd: stdin
    mov rsi, terminal_input_char; buf: the temporary buffer, char
    mov rdx, 1 ; count: the length of the buffer, 1
    syscall
    call sane_console
    cmp byte[terminal_input_char], KEY_A
    jz key_a
    cmp byte[terminal_input_char], KEY_D
    jz key_d
    cmp byte[terminal_input_char], KEY_ESC
    jz end
keypress_end:
    ret

gametick:
    ; gametick
    ;
    ; main gameloop using recursion
    call keypresses
    jmp gametick

_start:
    print s_menu
    call open_socket
    call gametick

end:
    call sane_console
    print s_end
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall ; sys_exit(0)
