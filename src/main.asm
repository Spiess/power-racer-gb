INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a

	; Do not turn the LCD off outside of VBlank
	call wait_vblank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; Copy the tile data
	ld de, BGTilesEnd - Tiles
	ld hl, _VRAM9000
	ld bc, Tiles
	call memcpy

	; Copy the tile data
	ld de, TilesEnd - BGTilesEnd
	ld hl, _VRAM8000
	ld bc, BGTilesEnd
	call memcpy

	; Clear background
	ld bc, $0400
	ld hl, _SCRN0
CopyTilemap:
	ld a, $01
	ld [hli], a
	dec bc
	ld a, c
	cp $00
	jr nz, CopyTilemap
	ld a, b
	cp $00
	jr nz, CopyTilemap

	; Copy window
	ld hl, _SCRN1
	ld a, $17
	ld [hli], a
	ld a, $18
	ld [hli], a
	ld a, $19
	ld [hli], a
	ld a, $1A
	ld [hli], a
	ld a, $1B
	ld [hli], a
	ld a, $1C
	ld [hli], a
	ld a, $1D
	ld [hli], a
	ld a, $1E
	ld [hli], a
	ld a, $1F
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $21
	ld [hli], a
	ld a, $22
	ld [hli], a
	ld a, $23
	ld [hli], a
	ld a, $24
	ld [hl], a
	ld hl, _SCRN1 + 32
	ld a, $25
	ld [hli], a
	ld a, $26
	ld [hli], a
	ld a, $27
	ld [hli], a
	ld a, $28
	ld [hli], a
	ld a, $29
	ld [hli], a
	ld a, $2A
	ld [hli], a
	ld a, $2B
	ld [hli], a
	ld a, $2C
	ld [hli], a
	ld a, $2D
	ld [hli], a
	ld a, $2E
	ld [hli], a
	ld a, $2F
	ld [hli], a
	ld a, $30
	ld [hli], a
	ld a, $31
	ld [hli], a
	ld a, $32
	ld [hl], a

	ld hl, rWX
	ld [hl], 55

	ld hl, rWY
	ld [hl], 128

	; Initialize objects
	ld hl, _OAMRAM
	ld a, 84
	ld [hli], a ; y position
	ld [hli], a ; x position
	ld a, 0 ; Tile index
	ld [hli], a
	ld a, %00000000 ; Attributes / flags
	ld [hl], a

	call initialize_car

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_WINON | LCDCF_WIN9C00 | LCDCF_OBJON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	; ld a, %00011011
	ld [rBGP], a
	; Init object palette 0
	ld [rOBP0], a

Done:
	call wait_vblank
	call read_input
	call update_car
	call scroll_x
	jp Done


SECTION "Tile data", ROM0

Tiles:
	INCBIN "tiles/tiles.2bpp"
	INCBIN "tiles/logo.2bpp"
BGTilesEnd:
	INCBIN "tiles/sprites.2bpp"
TilesEnd:
