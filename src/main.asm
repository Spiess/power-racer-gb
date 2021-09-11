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

	ld hl, _SCRN0 + $0100
CopyRoad:
	ld a, $02
	ld [hli], a
	ld a, $60
	cp l
	jr nz, CopyRoad

	; Copy window
	ld hl, _SCRN1
	ld a, _N_TILES
CopyWindow0:
	ld [hli], a
	inc a
	cp _N_TILES + _LOGO_WIDTH
	jr nz, CopyWindow0
	ld hl, _SCRN1 + $20
CopyWindow1:
	ld [hli], a
	inc a
	cp _N_TILES + _LOGO_WIDTH + _LOGO_WIDTH
	jr nz, CopyWindow1

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

	; Scroll screen half a tile up
	ld hl, rSCY
	ld [hl], $04

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_WINON | LCDCF_WIN9C00 | LCDCF_OBJON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	; ld a, %00011011
	ld [rBGP], a
	; Init object palette 0
	ld [rOBP0], a

MainMenu:
	call wait_new_vblank
	call read_input
	; call update_car
	call scroll_x
	jp MainMenu


SECTION "Tile data", ROM0

Tiles:
	INCBIN "tiles/tiles.2bpp"
Logo:
	INCBIN "tiles/logo.2bpp"
BGTilesEnd:
	INCBIN "tiles/sprites.2bpp"
TilesEnd:

DEF _N_TILES EQU 13
DEF _LOGO_WIDTH EQU 14
