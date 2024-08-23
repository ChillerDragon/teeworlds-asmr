; total size should never change
unpacker_size resb 4

; will be incremented
unpacker_data_ptr resb 8

; should not change and can be used
; to compute the size that was already consumed
unpacker_data_start resb 8

