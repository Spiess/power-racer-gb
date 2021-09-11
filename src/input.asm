SECTION "Input", ROMX

INCLUDE "hardware.inc"

read_input::
	; Save old input
	ld hl, INPUTS
	ld a, [hl] ; Save previous input
	ld hl, INPUTS_OLD
	ld [hl], a

	; Read P15 (buttons)
	ld hl, rP1
	ld a, P1F_GET_BTN
	ld [hl], a
	ld a, [hl]
	and a, $0F ; only save lower 4 bits
	ld hl, INPUTS
	ld [hl], a

	; Read P14 (dpad)
    ld hl, rP1
    ld a, P1F_GET_DPAD
    ld [hl], a
    ld a, [hl]
	and a, $0F ; only save lower 4 bits
	swap a
    ld hl, INPUTS
	or a, [hl]
	ld [hl], a

	; Reset
	ld hl, rP1
	ld a, P1F_GET_NONE
	ld [hl], a
	ret

SECTION "Input Variables", WRAM0
INPUTS:: DS 1
INPUTS_OLD:: DS 1
