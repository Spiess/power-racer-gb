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
	; a = frames delay between scrolls
	ld hl, SCROLL_EFFECT
	inc [hl]
	ld b, [hl]
	cp b
	jr nz, .scroll_x_end
	ld [hl], 0
	ld hl, rSCX
	inc [hl]
.scroll_x_end
	ret

initialize_effect_variables::
	ld hl, SCROLL_EFFECT
	ld [hl], 0


SECTION "Effects Variables", WRAM0
	SCROLL_EFFECT:: DS 1
