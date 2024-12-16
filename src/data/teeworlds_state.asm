input_direction dd 0
input_target_x dd 0
input_target_y dd 0
input_jump dd 0
input_fire dd 0
input_hook dd 0
input_player_flags dd 0
input_wanted_weapon dd 0
input_next_weapon dd 0
input_prev_weapon dd 0

ack_game_tick dd -1

local_client_id dd -1

; can be either 7 for 0.7
; or 6 for 0.6.4 with ddnet tokens
connection_version db 7

; magic for ddnet security tokens
MAGIC_TKEN db "TKEN"

TW_CLIENT_ID_OFFSET equ 0
TW_CLIENT_NAME_OFFSET equ TW_CLIENT_ID_OFFSET + 4
TW_CLIENT_CLAN_OFFSET equ TW_CLIENT_NAME_OFFSET + MAX_NAME_ARRAY_SIZE
TW_CLIENT_SIZE equ TW_CLIENT_CLAN_OFFSET + MAX_CLAN_ARRAY_SIZE
