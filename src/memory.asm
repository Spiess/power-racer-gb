SECTION "Memory", ROMX

INCLUDE "hardware.inc"

memcpy::
    ; Copy de bytes from bc to hl
    ; de = block size
    ; bc = source address
    ; hl = destination address
    ld a, [bc]
    ld [hli], a
    inc bc
    dec de

.memcpy_check_limit:
    ld a, e
    cp $00
    jr nz, memcpy
    ld a, d
    cp $00
    jr nz, memcpy
    ret
