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

; calling convetion for this code base is matching the one
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

global _start:

section .data
    ; constants
    %include "src/data/syscalls.asm"
    %include "src/data/teeworlds.asm"

    STDOUT       equ         1
    KEY_A        equ         97
    KEY_D        equ         100
    KEY_ESC      equ         27
    KEY_RETURN   equ         13
    AF_INET      equ         0x2
    SOCK_DGRAM   equ         0x2

    ; application constants
    HEX_TABLE   db "0123456789ABCDEF", 0
    NEWLINE db 0x0a

    ; networking
    SIZEOF_SOCKADDR db 128 ; borderline non sense
    ADDR_LOCALHOST dw AF_INET ; 0x2 0x00
                db 0x20, 0x6f ; port 8303
                db 0x7f, 0x0, 0x0, 0x01 ; 127.0.0.1
                db 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 ; watafk is this?!

    ; variables
    s_menu      db          "+--+ teeworlds_asmr (ESCAPE to quit the game) +--+",0x0a
    l_menu      equ         $ - s_menu
    s_end       db          "quitting the game...",0x0a
    l_end       equ         $ - s_end
    s_a         db          "you pressed a",0x0a
    l_a         equ         $ - s_a
    s_d         db          "you pressed d",0x0a
    l_d         equ         $ - s_d
    orig        times       10000       db      0
    new         times       10000       db      0
    char        db          0,0,0,0,0
    s_dbg_digit db          "[debug] value of rax is: ", 0
    l_dbg_digit equ $ - s_dbg_digit
    s_got_file_desc db "got file descriptor: "
    l_got_file_desc equ $ - s_got_file_desc
    s_got_udp db "got udp: "
    l_got_udp equ $ - s_got_udp
    s_len db "len="
    l_len equ $ - s_len
    s_blocking_read db "doing a blocking udp read ...", 0x0a
    l_blocking_read equ $ - s_blocking_read

section .bss
    ; we only need 1 byte for the socket file descriptor
    ; the value should be 3 at all times anyways
    ; as long as we do not connect 1024 dummies we should be fine
    socket resb 1

    ; this is too long
    ; for now we only store 2 character in here
    hex_str resb 512

    ; NET_MAX_PACKETSIZE 1400
    ; tw codebase also calls recvfrom with it
    udp_recv_buf resb 1400

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

%include "src/logger.asm"
%include "src/hex.asm"
%include "src/terminal.asm"
%include "src/udp.asm"
%include "src/printers.asm"

print_udp:
    ; got udp:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, s_got_udp
    mov rdx, l_got_udp
    syscall
    ; hexdump
    mov rcx, 0
    mov rdi, [udp_read_len]
.print_udp_loop_bytes:
    mov rax, [udp_recv_buf+rcx*1]
    call print_hex_byte
    inc rcx
    cmp rcx, 10
    jb .print_udp_loop_bytes
    call print_newline
    ; len=%d
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, s_len
    mov rdx, l_len
    syscall
    mov rax, [udp_read_len]
    call print_uint32
    call print_newline
    ret

on_udp_packet:
    call print_udp
    ret

key_a:
    mov rsi, s_a
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rdx, l_a
    syscall
    call send_udp
    call print_blocking_read
    call recv_udp
    mov rax, [udp_read_len]
    test rax, rax
    ; if recvfrom returned negativ
    ; we do not process the udp payload
    js keypress_end
    call on_udp_packet
    jmp keypress_end

key_d:
    mov rsi, s_d
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rdx, l_d
    syscall
    jmp keypress_end

keypresses:
    call insane_console
    ; read char
    mov rax, SYS_READ ; __NR_read
    mov rdi, 0 ; fd: stdin
    mov rsi, char ; buf: the temporary buffer, char
    mov rdx, 1 ; count: the length of the buffer, 1
    syscall
    call sane_console
    cmp byte[char], KEY_A
    jz key_a
    cmp byte[char], KEY_D
    jz key_d
    cmp byte[char], KEY_ESC
    jz end
keypress_end:
    ret

gametick:
    ; gametick
    ;
    ; main gameloop using recursion
    call keypresses
    call gametick
    ret

_start:
    call print_menu
    call open_socket
    call gametick

end:
    call sane_console
    ; print exit message
    mov rsi, s_end
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rdx, l_end
    syscall ; sys_write(1, s_end, l_end)
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall ; sys_exit(0)
