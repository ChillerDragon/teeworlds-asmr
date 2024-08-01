; tw protocol

PACKET_HEADER_LEN equ 7

MSG_CTRL_CONNECT equ 1
MSG_CTRL_ACCEPT equ 2
MSG_CTRL_CLOSE equ 4
MSG_CTRL_TOKEN equ 5

MSG_SYSTEM_INFO equ 1
MSG_SYSTEM_MAP_CHANGE equ 2

MSG_GAME_SV_MOTD equ 1

PAYLOAD_CTRL_TOKEN db MSG_CTRL_TOKEN, 0xDD, 0xDD, 0xCC, 0xCC, 512 dup (0x00)
PAYLOAD_CTRL_TOKEN_LEN equ $ - PAYLOAD_CTRL_TOKEN

NET_MAX_PACKETSIZE equ 1400

PACKETFLAG_CONTROL equ 0b00_0001_00
PACKETFLAG_RESEND equ 0b00_0010_00
PACKETFLAG_COMPRESSION equ 0b00_0100_00
PACKETFLAG_CONNLESS equ 0b00_1000_00

CHUNKFLAG_VITAL equ 0b0100_0000
CHUNKFLAG_RESEND equ 0b1000_0000

CHUNK_SYSTEM equ 0b0000_0001
CHUNK_GAME equ 0b0000_0000

GAME_NETVERSION db "0.7 802f1be60a05665f", 0
password db "ChillerDragon x86", 0
CLIENT_VERSION equ 0x0705

token db 0xDD, 0xDD, 0xCC, 0xCC
peer_token db 0xFF, 0xFF, 0xFF, 0xFF

; the amount of vital chunks sent
connection_sequence db 0, 0, 0, 0

; the amount of vital chunks received
connection_ack db 0, 0, 0, 0

; the amount of vital chunks acknowledged by the peer
connection_peerack db 0, 0, 0, 0

