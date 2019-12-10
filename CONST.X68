; =============================================================================
; GAME CONSTANTS
; =============================================================================

; - General constants ---------------------------------------------------------

GRAVITY     EQU     10                      ; Gravity pushes down when >0
IMPULSE     EQU     -5*GRAVITY
BLACK       EQU     $00000000
WHITE       EQU     $00FFFFFF

; - Player related constants --------------------------------------------------

PLRDIM      EQU     40
PLRCLR      EQU     $0000FF00               ; Totally green
PLRSPDX     EQU     20

; - Maps related constants ----------------------------------------------------

XGRIDS      EQU     16
YGRIDS      EQU     12
GRIDWTH     EQU     SCRWIDTH/XGRIDS
GRIDHGT     EQU     SCRHEIGH/YGRIDS

; -----------------------------------------------------------------------------

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
