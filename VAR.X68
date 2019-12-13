; =============================================================================
; GAME VARS
; =============================================================================

; - General variables ---------------------------------------------------------

CURRLVL     DS.B    1
CURRSTA     DS.B    1
            DS.W    0

; - Menu strings --------------------------------------------------------------

STRSTART    DC.B    'START',0
STRCREDS    DC.B    'CREDITS',0
STRQUIT     DC.B    'QUIT',0
ASTERISK    DC.B    '*',0
CREDITS     DC.B    'Skeleton:',10,13
            DC.B    'Antoni Burguera',10,13,10,13
            DC.B    'Coding and Game Design:',10,13
            DC.B    'Andreas Manuel Korn',10,13
            DC.B    'Sergio Vega García',10,13,10,13
            DC.B    'Music:',10,13
            DC.B    'HeatleyBros',0
            
; - Player related vars -------------------------------------------------------

PLRPOSX     DS.W    1
PLRPOSY     DS.W    1
PLRSPDY     DC.W    0
PLRLVS      DS.B    1
DIR         DS.B    1
            DS.W    0
            
; - Music and Sound -----------------------------------------------------------

SONG        DS.B    1
MUSMENU     DC.B    'Music\MainMenu.wav',0
            
; -----------------------------------------------------------------------------







*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
