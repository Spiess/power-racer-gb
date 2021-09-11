SECTION "LCD", ROMX

INCLUDE "hardware.inc"

wait_vblank::
	ld a, [rLY]
	cp 144
	jr nz, wait_vblank
	ret

wait_fade::
	ld b, 60

wait_new_vblank::
	ld a, [rLY]
	cp 0
	jr nz, wait_new_vblank
	call wait_vblank
	ret
