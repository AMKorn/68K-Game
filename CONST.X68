; =============================================================================
; GAME CONSTANTS
; =============================================================================

; - General constants ---------------------------------------------------------

MAINMENU    EQU     0                       
PLAYING     EQU     1
PAUSED      EQU     2
WINSTATE    EQU     3
DEAD        EQU     4

LEFT        EQU     $00
RIGHT       EQU     $FF

; - Menu constants ------------------------------------------------------------

MENUOPTIONS EQU     3                       ; Number of options
            ; The three options in the main menu
MENUPLAY    EQU     0
MENUMUTE    EQU     1
MENUQUIT    EQU     2

; - Pause constants -----------------------------------------------------------

PSEOPTIONS  EQU     4

PSEPLAY     EQU     0
PSERESET    EQU     1
PSEMUTE     EQU     2
PSEQUIT     EQU     3

; - Death constants -----------------------------------------------------------

DEADOPTS    EQU     2

DEADTRY     EQU     0
DEADQUIT    EQU     1

; - Game constants ------------------------------------------------------------

GRAVITY     EQU     5                       ; Gravity pushes down if >0 & added
IMPULSE     EQU     -6*GRAVITY              ; The force of the player's jump
STRTLIVES   EQU     3                       ; Number of starting lives

; - Maps related constants ----------------------------------------------------

XGRIDS      EQU     16                      ; Number of grids
YGRIDS      EQU     12
GRIDWTH     EQU     SCRWIDTH/XGRIDS         ; Dimension of each grid
GRIDHGT     EQU     SCRHEIGH/YGRIDS

            ; Cell value codes
AIR         EQU     0
GROUND      EQU     1
ENTRANCE    EQU     2
CLONE       EQU     3
LVLGOAL     EQU     4
ENEMY       EQU     5
SPIKE       EQU     6

; - Player related constants --------------------------------------------------

PLRDIM      EQU     GRIDWTH-1               ; Due to the collisions
                                            ; implementation, changing this
                                            ; value independently of the grids
                                            ; dimensions will cause weird
                                            ; behaviour.
PLRSPDX     EQU     10                      ; Unit is pixels/frame
MAXSPD      EQU     GRIDHGT                 ; If the Y speed were higher than
                                            ; the height, it would be possible
                                            ; to fall below a block.
INVTIME     EQU     100                     ; INVTIME/100 seconds invincibility


; - Enemy constants and indexing ----------------------------------------------

            ; Due to enemies being agents, these constants are for ease of use
            ; with displacement register addressing.
ENMY_XOF    EQU     0
ENMY_YOF    EQU     2
ENMY_YSPD   EQU     4
ISFACING    EQU     6

; - Crusher constants and indexing --------------------------------------------

            ; Same as enemies, these constants are for ease of use.
CRUSHX      EQU     0
CRUSHY      EQU     2
CRUSH_YSPD  EQU     4

; --- COLORS ------------------------------------------------------------------

; Colors are of format $00BBGGRR
BLACK       EQU     $00000000
WHITE       EQU     $00FFFFFF
L_GREEN     EQU     $0088FF88
PINK        EQU     $00FF85F5
GREEN       EQU     $0000FF00
AQUA        EQU     $00FFFF00
RED         EQU     $000000FF
L_RED       EQU     $007777FF
GRAY        EQU     $00B5B5B5

; - Sound constants -----------------------------------------------------------

            ; The reference numbers for the sounds
MUSIC       EQU     0
PLATFX      EQU     1
JMPFX       EQU     2
HURTFX      EQU     3
HRTFX       EQU     HURTFX                  ; Read the memory to know why we
                                            ; had to do this.

; -----------------------------------------------------------------------------


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
