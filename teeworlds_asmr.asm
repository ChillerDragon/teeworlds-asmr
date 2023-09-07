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

section    .data
    ; constants
    SYS_READ     equ         0
    SYS_WRITE    equ         1
    SYS_OPEN     equ         2
    SYS_CLOSE    equ         3
    SYS_SOCKET   equ         41
    SYS_SENDTO   equ         44
    SYS_RECVFROM equ         45
    SYS_EXIT     equ         60
    STDOUT       equ         1
    KEY_A        equ         97
    KEY_D        equ         100
    KEY_ESC      equ         13
    AF_INET      equ         2
    SOCK_DGRAM   equ         2

    ; application constants
    HEX_TABLE   db "0123456789ABCDEF", 0

    ; networking
    SIZEOF_SOCKADDR db 128
    ADDR_LOCALHOST dw AF_INET
                db 20h, 6fh ; port 8303
                db 7fh, 0h, 0h, 01h ; 127.0.0.1
                db 0, 0, 0, 0, 0, 0, 0, 0

    ; tw protocol
    MSG_CTRL_TOKEN db 0x04, 0x00, 0x00, 0x0FF, 0xFF, 0xFF, 0xFF, 0x05, 0x51, 0x3B, 0x59, 0x46, 512 dup (0x00)
    MSG_CTRL_TOKEN_LEN equ $ - MSG_CTRL_TOKEN
    NET_MAX_PACKETSIZE equ 1400

    ; variables
    s_menu      db          "+--+ teeworlds_asmr (RETURN to quit the game) +--+",0x0a
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
    fmt_digit   db          "value of ebx is: %d", 10, 0
    s_got_file_desc db "got file descriptor: "
    l_got_file_desc equ $ - s_got_file_desc

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
section     .text

print_uint32:
    ; print_uint32 [rax]
    ;
    ; has a sub label toascii_digit
    ; and prints the given value in rax
    ; as a digit to stdout
    ; https://stackoverflow.com/a/46301894/6287070
    mov    ecx, 0xa              ; base 10
    push   rcx                   ; ASCII newline '\n' = 0xa = base
    mov    rsi, rsp
    sub    rsp, 16               ; not needed on 64-bit Linux, the red-zone is big enough.  Change the LEA below if you remove this.

;;; rsi is pointing at '\n' on the stack, with 16B of "allocated" space below that.
.toascii_digit:                ; do {
    xor    edx, edx
    div    ecx                   ; edx=remainder = low digit = 0..9.  eax/=10
                                 ;; DIV IS SLOW.  use a multiplicative inverse if performance is relevant.
    add    edx, '0'
    dec    rsi                 ; store digits in MSD-first printing order, working backwards from the end of the string
    mov    [rsi], dl

    test   eax,eax             ; } while(x);
    jnz  .toascii_digit
;;; rsi points to the first digit


    mov    eax, SYS_WRITE
    mov    edi, STDOUT
    ; pointer already in RSI    ; buf = last digit stored = most significant
    lea    edx, [rsp+16 + 1]    ; yes, it's safe to truncate pointers before subtracting to find length.
    sub    edx, esi             ; RDX = length = end-start, including the \n
    syscall                     ; write(1, string /*RSI*/,  digits + 1)

    add  rsp, 24                ; (in 32-bit: add esp,20) undo the push and the buffer reservation
    ret

print_newline:
    push    0x0a
	mov     rax, SYS_WRITE
	mov     edi, STDOUT
	mov     rsi, rsp ; use char on stack
	mov     rdx, 1 ; len
	syscall
	add     rsp, 8 ; restore stack pointer
	ret

print_dbg_fd:
    ; print_dbg_fd
    ;
    ; prints "got file descriptor: "
    ; there is now new line and no
    ; actual file descriptor being printed
    mov         rsi,        s_got_file_desc
    mov         rax,        SYS_WRITE
    mov         rdi,        STDOUT
    mov         rdx,        l_got_file_desc
    syscall
    ret

print_menu:
    mov         rsi,        s_menu
    mov         rax,        SYS_WRITE
    mov         rdi,        STDOUT
    mov         rdx,        l_menu
    syscall     ; sys_write(1, s_end, l_end)
    ret

insane_console:
    ; fetch the current terminal settings
    mov         rax,        16          ; __NR_ioctl
    mov         rdi,        0           ; fd: stdin
    mov         rsi,        21505       ; cmd: TCGETS
    mov         rdx,        orig        ; arg: the buffer, orig
    syscall
    ; agian, but this time for the 'new' buffer
    mov         rax,        16
    mov         rdi,        0
    mov         rsi,        21505
    mov         rdx,        new
    syscall
    ; change settings
    ; ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON)
    and         dword       [new+0],    -1516
    ; ~OPOST
    and         dword       [new+4],    -2
    ; ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN)
    and         dword       [new+12],   -32844
    ; ~(CSIZE | PARENB)
    and         dword       [new+8],    -305
    ; set settings (with ioctl again)
    mov         rax,        16          ; __NR_ioctl
    mov         rdi,        0           ; fd: stdin
    mov         rsi,        21506       ; cmd: TCSETS
    mov         rdx,        new         ; arg: the buffer, new
    syscall
    ret

sane_console:
    ; reset settings (with ioctl again)
    mov         rax,        16          ; __NR_ioctl
    mov         rdi,        0           ; fd: stdin
    mov         rsi,        21506       ; cmd: TCSETS
    mov         rdx,        orig        ; arg: the buffer, orig
    syscall
    ret

recv_udp:
    ; recv_udp
    ;
    ; listens for udp packet on the
    ; `socket` and fills the `udp_recv_buf`
    mov rax, SYS_RECVFROM
    mov rdi, [socket]
    mov rsi, udp_recv_buf
    mov rdx, NET_MAX_PACKETSIZE
    xor r10, r10
    lea r8, [udp_srv_addr]
    lea r9, [SIZEOF_SOCKADDR]
    syscall

send_udp:
    ; send_udp
    ;
    ; sends a udp packet to the `socket`
    ; make sure to fist call open_socket
    mov         rax,        SYS_SENDTO
    mov         rdi,        [socket]
    mov         rsi,        MSG_CTRL_TOKEN
    mov         rdx,        MSG_CTRL_TOKEN_LEN
    xor         r10,        r10 ; flags
    mov         r8,         ADDR_LOCALHOST
    mov         r9,         16 ; sockaddr size
    syscall
    ret

key_a:
    mov         rsi,        s_a
    mov         rax,        SYS_WRITE
    mov         rdi,        1
    mov         rdx,        l_a
    syscall
    call send_udp
    call recv_udp
    jz          keypress_end

key_d:
    mov         rsi,        s_d
    mov         rax,        SYS_WRITE
    mov         rdi,        1
    mov         rdx,        l_d
    syscall
    jz          keypress_end

keypresses:
    call        insane_console
    ; read char
    mov         rax,        SYS_READ    ; __NR_read
    mov         rdi,        0           ; fd: stdin
    mov         rsi,        char        ; buf: the temporary buffer, char
    mov         rdx,        1           ; count: the length of the buffer, 1
    syscall
    call        sane_console
    cmp         byte[char], KEY_A
    jz          key_a
    cmp         byte[char], KEY_D
    jz          key_d
    cmp         byte[char], KEY_ESC
    jz          end
keypress_end:
    ret

open_socket:
    ; open_socket
    ;
    ; opens a udp socket and stores it in
    ; the variable `socket`
    mov         rax,        SYS_SOCKET
    mov         rsi,        AF_INET
    mov         rdi,        SOCK_DGRAM
    mov         rdx,        0 ; flags
    syscall
    mov         rdi,        rax ; socket file descriptor

    mov [socket], rax
    call print_dbg_fd
    mov rax, [socket]
    call print_uint32
    ret

hex_to_char:
    ; hex_to_char [rax]
    ;
    ; moves byte in `rax` as hex string into
    ; the `hex_str` variable
    ; https://stackoverflow.com/a/18879886/6287070
    push rbx
    mov rbx, HEX_TABLE

    mov ah, al
    shr al, 4
    and ah, 0x0f
    xlat
    xchg ah, al
    xlat

    mov rbx, hex_str
    xchg ah, al
    mov [rbx], rax

    pop rbx
    ret

print_hex_byte:
    ; print_hex [rax]
    ;
    ; prints given arg as hex string
    ; to stdout
    call hex_to_char

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, hex_str
    mov rdx,  2
    syscall
    ret

gametick:
    ; gametick
    ;
    ; main gameloop using recursion
    call        keypresses
    mov rax, 0xAF
    call        print_hex_byte
    call        gametick
    ret

_start:
    call        print_menu
    call        open_socket
    call        gametick

end:
    call        sane_console
    ; print exit message
    mov         rsi,        s_end
    mov         rax,        SYS_WRITE
    mov         rdi,        1
    mov         rdx,        l_end
    syscall     ; sys_write(1, s_end, l_end)
    mov         rax,        SYS_EXIT
    mov         rdi,        0
    syscall     ; sys_exit(0)
