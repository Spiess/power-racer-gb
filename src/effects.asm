SECTION "Effects", ROMX

INCLUDE "hardware.inc"

fade_effect::
	call wait_fade
        ld a, %11111001
        ld [rBGP], a
        call wait_fade
        ld a, %11111110
        ld [rBGP], a
        call wait_fade
        ld a, %11111111
        ld [rBGP], a
        call wait_fade
        ld a, %11111110
        ld [rBGP], a
        call wait_fade
        ld a, %11111001
        ld [rBGP], a
        call wait_fade
        ld a, %11100100
        ld [rBGP], a
	ret

scroll_x::
	; Scrolls the background horizontally
	ld hl, rSCX
	inc [hl]
	ret
