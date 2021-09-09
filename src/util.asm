SECTION "Util", ROMX

INCLUDE "hardware.inc"

DEF A_BUTTON_POS EQU $9910
DEF B_BUTTON_POS EQU $994D
DEF LEFT_POS EQU $9922
DEF RIGHT_POS EQU $9924
DEF UP_POS EQU $9903
DEF DOWN_POS EQU $9943

init_button_ui::
	ld hl, A_BUTTON_POS
	ld [hl], $01
	ld hl, B_BUTTON_POS
	ld [hl], $03
	ld hl, LEFT_POS
	ld [hl], $09
	ld hl, RIGHT_POS
	ld [hl], $0B
	ld hl, UP_POS
	ld [hl], $05
	ld hl, DOWN_POS
	ld [hl], $07
	ret

check_a_btn::
	; Check A button down
	ld hl, IO_P15
    bit PADB_A, [hl]
    jr nz, .check_a_btn_down_end
	ld hl, IO_P15_OLD
    bit PADB_A, [hl]
    jr z, .check_a_btn_down_end
    ld hl, A_BUTTON_POS
	ld [hl], $02
.check_a_btn_down_end:
	; Check A button up
	ld hl, IO_P15
    bit PADB_A, [hl]
    jr z, .check_a_btn_up_end
	ld hl, IO_P15_OLD
    bit PADB_A, [hl]
    jr nz, .check_a_btn_up_end
    ld hl, A_BUTTON_POS
	ld [hl], $01
.check_a_btn_up_end:
	ret

check_b_btn::
	; Check B button down
	ld hl, IO_P15
    bit PADB_B, [hl]
    jr nz, .check_b_btn_down_end
	ld hl, IO_P15_OLD
    bit PADB_B, [hl]
    jr z, .check_b_btn_down_end
    ld hl, B_BUTTON_POS
	ld [hl], $04
.check_b_btn_down_end:
	; Check B button up
	ld hl, IO_P15
    bit PADB_B, [hl]
    jr z, .check_b_btn_up_end
	ld hl, IO_P15_OLD
    bit PADB_B, [hl]
    jr nz, .check_b_btn_up_end
    ld hl, B_BUTTON_POS
	ld [hl], $03
.check_b_btn_up_end:
	ret

check_dpad::
	; Check down down
	ld hl, IO_P14
	bit PADB_START, [hl]
	jr nz, .check_down_down_end
	ld hl, IO_P14_OLD
	bit PADB_START, [hl]
	jr z, .check_down_down_end
	ld hl, DOWN_POS
	ld [hl], $08
.check_down_down_end:
	; Check down up
	ld hl, IO_P14
	bit PADB_START, [hl]
	jr z, .check_down_up_end
	ld hl, IO_P14_OLD
	bit PADB_START, [hl]
	jr nz, .check_down_up_end
	ld hl, DOWN_POS
	ld [hl], $07
.check_down_up_end:

	; Check up down
	ld hl, IO_P14
	bit PADB_SELECT, [hl]
	jr nz, .check_up_down_end
	ld hl, IO_P14_OLD
	bit PADB_SELECT, [hl]
	jr z, .check_up_down_end
	ld hl, UP_POS
	ld [hl], $06
.check_up_down_end:
	; Check up up
	ld hl, IO_P14
	bit PADB_SELECT, [hl]
	jr z, .check_up_up_end
	ld hl, IO_P14_OLD
	bit PADB_SELECT, [hl]
	jr nz, .check_up_up_end
	ld hl, UP_POS
	ld [hl], $05
.check_up_up_end:

	; Check left down
	ld hl, IO_P14
	bit PADB_B, [hl]
	jr nz, .check_left_down_end
	ld hl, IO_P14_OLD
	bit PADB_B, [hl]
	jr z, .check_left_down_end
	ld hl, LEFT_POS
	ld [hl], $0A
.check_left_down_end:
	; Check left up
	ld hl, IO_P14
	bit PADB_B, [hl]
	jr z, .check_left_up_end
	ld hl, IO_P14_OLD
	bit PADB_B, [hl]
	jr nz, .check_left_up_end
	ld hl, LEFT_POS
	ld [hl], $09
.check_left_up_end:

	; Check right down
	ld hl, IO_P14
	bit PADB_A, [hl]
	jr nz, .check_right_down_end
	ld hl, IO_P14_OLD
	bit PADB_A, [hl]
	jr z, .check_right_down_end
	ld hl, RIGHT_POS
	ld [hl], $0C
.check_right_down_end:
	; Check right up
	ld hl, IO_P14
	bit PADB_A, [hl]
	jr z, .check_right_up_end
	ld hl, IO_P14_OLD
	bit PADB_A, [hl]
	jr nz, .check_right_up_end
	ld hl, RIGHT_POS
	ld [hl], $0B
.check_right_up_end:
	ret

; check_dpad::
; 	ld hl, IO_P14
; 	; Check down
; 	bit PADB_START, [hl] ; FIXME: Using PADB_START instead of DOWN, because bit is wrong
; 	jr nz, .check_dpad_up
; 	ld hl, rSCY
; 	inc [hl]
; 	ld hl, IO_P14
; .check_dpad_up:
; 	bit PADB_SELECT, [hl] ; FIXME
;     jr nz, .check_dpad_left
;     ld hl, rSCY
;     dec [hl]
;     ld hl, IO_P14
; .check_dpad_left:
; 	bit PADB_B, [hl] ; FIXME
;     jr nz, .check_dpad_right
;     ld hl, rSCX
;     dec [hl]
;     ld hl, IO_P14
; .check_dpad_right:
; 	bit PADB_A, [hl] ; FIXME
;     jr nz, .check_dpad_end
;     ld hl, rSCX
;     inc [hl]
; .check_dpad_end:
; 	ret
