%include "tests/assert.asm"

_start:
    init_test __FILE__

    call test_console

    end_test __LINE__

