; =============================================================================
; GAME CONSTANTS
; =============================================================================

; - General constants ---------------------------------------------------------

MAINMENU    EQU     0
PLAYING     EQU     1
PAUSED      EQU     2
WINSTATE    EQU     3
FAILSTATE   EQU     4                       ; Might not be needed depending
                                            ; on how I implement failure

; - Menu constants ------------------------------------------------------------

MENUPLAY    EQU     0
MENUMUTE    EQU     1
MENUQUIT    EQU     2

; - Game constants ------------------------------------------------------------

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
