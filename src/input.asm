SECTION "Input", ROMX

INCLUDE "hardware.inc"

read_input::
	; Read P15 (buttons)
	ld hl, rP1
	ld a, P1F_GET_BTN
	ld [hl], a
	ld a, [hl]
	ld hl, IO_P15
	ld b, [hl] ; Save previous input
	ld [hl], a
	ld hl, IO_P15_OLD
	ld [hl], b

	; Read P14 (dpad)
    ld hl, rP1
    ld a, P1F_GET_DPAD
    ld [hl], a
    ld a, [hl]
    ld hl, IO_P14
    ld b, [hl] ; Save previous input
    ld [hl], a
    ld hl, IO_P14_OLD
    ld [hl], b

	; Reset
	ld hl, rP1
	ld a, $FF ; FIXME: Possibly replace with P1F_GET_NONE
	ld [hl], a
	ret

SECTION "Input Variables", WRAM0
IO_P14:: DS 1
IO_P15:: DS 1
IO_P14_OLD:: DS 1
IO_P15_OLD:: DS 1
