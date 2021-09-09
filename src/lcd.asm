SECTION "LCD", ROMX

INCLUDE "hardware.inc"

wait_vblank::
	ld a, [rLY]
	cp 144
	jr nz, wait_vblank
	ret

wait_fade::
	ld b, 60

.wait_loop:
	call wait_vblank
	dec b
	jr nz, .wait_loop
	ret
