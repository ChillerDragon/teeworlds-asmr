send_start_info:
    push_registers

    packer_reset
    pack_str cfg_player_name
    pack_str cfg_player_clan
    pack_int cfg_player_country

    pack_str cfg_player_skin_body
    pack_str cfg_player_skin_marking
    pack_str cfg_player_skin_decoration
    pack_str cfg_player_skin_hands
    pack_str cfg_player_skin_feet
    pack_str cfg_player_skin_eyes

    pack_int [cfg_player_use_custom_color_body]
    pack_int [cfg_player_use_custom_color_marking]
    pack_int [cfg_player_use_custom_color_decoration]
    pack_int [cfg_player_use_custom_color_hands]
    pack_int [cfg_player_use_custom_color_feet]
    pack_int [cfg_player_use_custom_color_eyes]

    pack_int [cfg_player_color_body]
    pack_int [cfg_player_color_marking]
    pack_int [cfg_player_color_decoration]
    pack_int [cfg_player_color_hands]
    pack_int [cfg_player_color_feet]
    pack_int [cfg_player_color_eyes]

    send_msg MSG_GAME_CL_STARTINFO, CHUNKFLAG_VITAL, CHUNK_GAME
    call send_packet

    pop_registers
    ret

