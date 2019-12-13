; =============================================================================
; GAME CONSTANTS
; =============================================================================

; - General constants ---------------------------------------------------------

GRAVITY     EQU     5                       ; Gravity pushes down when >0
IMPULSE     EQU     -6*GRAVITY

; - Maps related constants ----------------------------------------------------

XGRIDS      EQU     16
YGRIDS      EQU     12
GRIDWTH     EQU     SCRWIDTH/XGRIDS
GRIDHGT     EQU     SCRHEIGH/YGRIDS

; - Player related constants --------------------------------------------------

PLRDIM      EQU     39
PLRSPDX     EQU     10
MAXSPD      EQU     GRIDHGT
LEFT        EQU     $00
RIGHT       EQU     $FF

; -----------------------------------------------------------------------------










*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
