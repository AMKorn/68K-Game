; =============================================================================
; GAME CONSTANTS
; =============================================================================

; - General constants ---------------------------------------------------------

MAINMENU    EQU     0                       
PLAYING     EQU     1
PAUSED      EQU     2
WINSTATE    EQU     3
DEAD        EQU     4                       ; Might not be needed depending
                                            ; on how I implement failure
RESET       EQU     -1

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

GRAVITY     EQU     5                       ; Gravity pushes down when >0
IMPULSE     EQU     -6*GRAVITY
STRTLIVES   EQU     3                       ; Number of starting lives

; - Maps related constants ----------------------------------------------------

XGRIDS      EQU     16
YGRIDS      EQU     12
GRIDWTH     EQU     SCRWIDTH/XGRIDS
GRIDHGT     EQU     SCRHEIGH/YGRIDS

AIR         EQU     0
GROUND      EQU     1
ENTRANCE    EQU     2
CLONE       EQU     3
LVLGOAL     EQU     4
ENEMY       EQU     5

; - Player related constants --------------------------------------------------

PLRDIM      EQU     GRIDWTH-1               ; Due to the collisions
                                            ; implementation, changing this
                                            ; value independently of the grids
                                            ; dimensions will cause weird
                                            ; behaviour.
PLRSPDX     EQU     10
MAXSPD      EQU     GRIDHGT
INVTIME     EQU     100                     ; 1 second of invincibility
LEFT        EQU     $00
RIGHT       EQU     $FF

; - Enemy constants and indexing ---------------------------------------------

            ; Due to enemies being agents, these constants are for ease of use
            ; with displacement register addressing.
ENMY_XOF    EQU     0
ENMY_YOF    EQU     2
ENMY_YSPD   EQU     4
ISFACING    EQU     6

; -----------------------------------------------------------------------------


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
