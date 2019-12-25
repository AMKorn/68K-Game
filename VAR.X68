; =============================================================================
; GAME VARS
; =============================================================================

; - General variables ---------------------------------------------------------

CURRLVL     DS.B    1
CURRSTA     DS.B    1
            DS.W    0

; - Menu & pause vars ---------------------------------------------------------

SELECT      DC.W    1                       ; It is a word because when using
                                            ; .B it has issues when calculating
                                            ; the module.
STRSTART    DC.B    'START',0
STRCONT     DC.B    'CONTINUE',0
STRRESET    DC.B    'RESET LEVEL',0
STRMUTE     DC.B    'MUTE',0
STRQUIT     DC.B    'QUIT GAME',0
STRMAIN     DC.B    'MAIN MENU',0
STRRETRY    DC.B    'RETRY',0
STRDEAD     DC.B    'TOO BAD, YOU DIED',0
ASTERISK    DC.B    '*',0
CREDITS     DC.B    'Program Skeleton & Agent List:',10,13
            DC.B    'Antoni Burguera',10,13,10,13
            DC.B    'Coding and Game Design:',10,13
            DC.B    'Andreas Manuel Korn',10,13
            DC.B    'Sergio Vega García',10,13,10,13
            DC.B    'Music:',10,13
            DC.B    'HeatleyBros',0
            DS.W    0
            
; - Player related vars -------------------------------------------------------

PLRPOSX     DS.W    1
PLRPOSY     DS.W    1
PLRSPDY     DC.W    0
INVFRAMES   DS.L    1                       ; The start of the invincibility
                                            ; frames
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
