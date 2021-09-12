SECTION "Car", ROMX

INCLUDE "hardware.inc"

DEF _TOP_SPEED EQU $F0

initialize_car::
	ld hl, CAR_ROTATION
	ld a, $10 ; Start rotation in the middle of angle thresholds
	ld [hl], a
	ld hl, CAR_SPEED
	ld a, $80
	ld [hl], a
	ld hl, CAR_SPEED_COUNTER
	ld a, 0
	ld [hl], a
	ret

update_car::
    ; Update rotation
	; Save old rotation
	ld hl, CAR_ROTATION
	ld a, [hl]
	ld hl, CAR_ROTATION_OLD
	ld [hl], a

    ; Check left down
	ld hl, INPUTS
	bit PADB_LEFT, [hl]
	jr nz, .check_left_end
    ; Rotate left
    ld hl, CAR_ROTATION
    inc [hl]
	inc [hl]
.check_left_end:

    ; Check right down
    ld hl, INPUTS
    bit PADB_RIGHT, [hl]
    jr nz, .check_right_end
    ; Rotate right
    ld hl, CAR_ROTATION
    dec [hl]
	dec [hl]
.check_right_end:

	call update_sprite

	; Check A down
	ld hl, INPUTS
	bit PADB_A, [hl]
	ld hl, CAR_SPEED
	ld a, [hl]
	jr nz, .check_a_end
	cp _TOP_SPEED
	jr z, .slow_down_end
	inc [hl]
	jr .slow_down_end
.check_a_end:
	cp 0
	jr z, .slow_down_end
	dec [hl]
.slow_down_end:

	call move_car
	ld a, [CAR_SPEED]
	call move_car

    ret

update_sprite::
	; Check if sprite needs updating
	; This is the case if the top three bits of rotation have changed
	ld hl, CAR_ROTATION_OLD
	ld a, [hl]
	and a, %11100000
	ld b, a
	ld hl, CAR_ROTATION
	ld a, [hl]
	and a, %11100000
	cp b
	jr z, .update_sprite_end
	; Sprite must change
	ld hl, _OAMRAM + 2 ; Load sprite index address
	cp %00100000
	jr z, .update_sprite_001
	cp %01000000
	jr z, .update_sprite_010
	cp %01100000
	jr z, .update_sprite_011
	cp %10000000
	jr z, .update_sprite_100
	cp %10100000
	jr z, .update_sprite_101
	cp %11000000
	jr z, .update_sprite_110
	cp %11100000
	jr z, .update_sprite_111
	; update sprite 000
	ld a, 0
	ld [hli], a
	ld a, %00000000
	ld [hl], a
	jr .update_sprite_end
.update_sprite_001:
	ld a, 1
	ld [hl], a ; No need to update flags
	jr .update_sprite_end
.update_sprite_010:
	ld a, 2
	ld [hli], a
	ld a, %00000000
	ld [hl], a
	jr .update_sprite_end
.update_sprite_011:
	ld a, 1
	ld [hli], a
	ld a, %00100000
	ld [hl], a
	jr .update_sprite_end
.update_sprite_100:
	ld a, 0
	ld [hli], a
	ld a, %00100000
	ld [hl], a
	jr .update_sprite_end
.update_sprite_101:
	ld a, 1
	ld [hli], a
	ld a, %01100000
	ld [hl], a
	jr .update_sprite_end
.update_sprite_110:
	ld a, 2
	ld [hli], a
	ld a, %01000000
	ld [hl], a
	jr .update_sprite_end
.update_sprite_111:
	ld a, 1
	ld [hli], a
	ld a, %01000000
	ld [hl], a
.update_sprite_end:
	ret

move_car::
	; Update background (move only when speed counter overflows)
	; Requires a to contain current speed
	ld hl, CAR_SPEED_COUNTER
	add [hl]
	ld [hl], a
	jr nc, .move_end
	; Move Y
	ld a, [CAR_ROTATION]
	sub $20 ; Correct for starting angle
	cp 95
	ld hl, rSCY
	jr c, .move_up
	sub 128
	cp 95
	jr nc, .move_y_end
	; Rotated downwards
	inc [hl]
	jr .move_y_end
.move_up
	; Rotated upwards
	dec [hl]
.move_y_end:

	; Move X
	ld a, [CAR_ROTATION]
	sub $60 ; Correct for starting angle
	cp 95
	ld hl, rSCX
	jr c, .move_left
	sub 128
	cp 95
	jr nc, .move_x_end
	; Rotated right
	inc [hl]
	jr .move_x_end
.move_left
	; Rotated right
	dec [hl]
.move_x_end:

.move_end:
	ret

SECTION "Car Variables", WRAM0
CAR_ROTATION:: DS 1
CAR_ROTATION_OLD:: DS 1
CAR_SPEED:: DS 1
CAR_SPEED_COUNTER:: DS 1
