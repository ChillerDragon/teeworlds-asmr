on_snap:
    ; on_snap [rax] [rdi]
    ;  rax = snapshot payload (only the data field)
    ;  rdi = size
    ;
    ; rax should be a full snapshot payload
    ; and never a partial snapshot
    ;
    ; will be called when we get a MSG_SNAPSINGLE, MSG_SNAPEMPTY or the last part of MSG_SNAP
    ;
    push_registers

    pop_registers
    ret

