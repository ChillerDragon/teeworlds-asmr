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
    %include "src/data/posix.asm"
    %include "src/data/syscalls.asm"
    %include "src/data/teeworlds.asm"
    %include "src/data/teeworlds_settings.asm"
    %include "src/data/teeworlds_state.asm"
    %include "src/data/teeworlds_strings.asm"
    %include "src/data/terminal.asm"
    %include "src/data/logger.asm"
    %include "src/data/hex.asm"
    %include "src/data/udp.asm"
    %include "src/data/huffman.asm"

    KEY_A       equ 0x61
    KEY_D       equ 0x64
    KEY_Q       equ 0x71
    KEY_ESC     equ 0x5B
    KEY_RETURN  equ 0x0D ; '\r' (carriage ret)

    ; strings
    s_menu db "+--+ teeworlds_asmr ('q' to quit the game) +--+",0x0a
    l_s_menu equ $ - s_menu
    s_end db "quitting the game...",0x0a
    l_s_end equ $ - s_end
    s_you_pressed_a db "you pressed a",0x0a
    l_s_you_pressed_a equ $ - s_you_pressed_a
    s_you_pressed_d db "you pressed d",0x0a
    l_s_you_pressed_d equ $ - s_you_pressed_d
    s_len db "[client]     len: "
    l_s_len equ $ - s_len

section .bss
    %include "src/bss/hex.asm"
    %include "src/bss/teeworlds.asm"
    %include "src/bss/buffers.asm"
    %include "src/bss/huffman.asm"
    %include "src/bss/unpacker.asm"
section .text

%include "src/macros.asm"
%include "src/syscalls.asm"
%include "src/printf.asm"
%include "src/logger.asm"
%include "src/hex.asm"
%include "src/check_bounds.asm"
%include "src/terminal.asm"
%include "src/udp.asm"
%include "src/packer.asm"
%include "src/packet.asm"
%include "src/chunk_unpacker.asm"
%include "src/chunk_packer.asm"
%include "src/send_control.asm"
%include "src/send_system.asm"
%include "src/send_game.asm"
%include "src/receive_control.asm"
%include "src/system.asm"
%include "src/string.asm"
%include "src/packet_header.asm"
%include "src/packet_packer.asm"
%include "src/pack_int.asm"
%include "src/unpacker.asm"
%include "src/huffman/huffman.asm"
%include "src/on_packet.asm"
%include "src/on_system.asm"
%include "src/on_game.asm"
%include "src/on_snap.asm"
%include "src/console/console.asm"
%include "src/client.asm"

print_udp:
    print_label s_got_udp
    ; hexdump
    mov rax, udp_recv_buf
    mov rdi, [udp_read_len]
    call print_hexdump
    call print_newline
    ; [client]     len: %d
    print_label s_len
    mov rax, [udp_read_len]
    call println_uint32

    ret

on_udp_packet:
    ; call print_udp
    call on_packet
    ret

pump_network:
    ; print_label s_non_blocking_read
    call recv_udp
    mov rax, [udp_read_len]
    test rax, rax
    ; if recvfrom returned negative
    ; we do not process the udp payload
    js .pump_network_no_data
    call on_udp_packet
.pump_network_no_data:
    ret

key_a:
    ; print_label s_you_pressed_a
    mov dword [input_direction], -1
    jmp keypress_end

key_d:
    ; print_label s_you_pressed_d
    mov dword [input_direction], 1
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

    test rax, rax
    ; if read returned negative
    ; we do not process the read value as key press
    js keypress_end

    cmp byte[terminal_input_char], KEY_A
    je key_a
    cmp byte[terminal_input_char], KEY_D
    je key_d
    cmp byte[terminal_input_char], KEY_Q
    je end
    cmp byte[terminal_input_char], KEY_ESC
    je end
keypress_end:
    ret

gametick:
    ; gametick
    ;
    ; main gameloop
    nanosleep 100
    call pump_network
    call keypresses
    jmp gametick

non_blocking_keypresses:
    mov rax, SYS_FCNTL
    mov rdi, STDIN       ; fd: stdin
    mov rsi, F_SETFL     ; cmd: F_SETFL
    mov rdx, O_NONBLOCK  ; arg: the flag
    syscall
    ret

print_stack_str_sample:
    push rbp
    mov rbp, rsp
    sub rsp, 20
    mov dword [rbp-20], 'aaaa'
    mov dword [rbp-16], 'bbbb'
    mov byte [rbp-12], 0
    lea rax, [rbp-20]
    print_c_str rax
    mov rsp, rbp
    pop rbp

_start:
    ; welcome message
    print_label s_menu
    call print_newline

    ; setup state
    call non_blocking_keypresses
    call open_socket

    ; parse command line arguments
    mov rcx, [rsp]
    cmp rcx, 1
    je .no_args
    cmp rcx, 2
    je .one_arg
    jg .too_many_args

    .no_args:
    print_label s_no_cli_args
    ; connect to server with default address 127.0.0.1:8303
    call connect
    jmp .run_game

    .one_arg:
    mov rax, [rsp+16]
    call exec_line
    jmp .run_game

    .too_many_args:
    print_label s_usage
    exit 1

    .run_game:
    call gametick

end:
    call send_ctrl_close
    call sane_console
    print_label s_end
    exit 0

