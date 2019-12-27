; =============================================================================
; GAME VARS
; =============================================================================

; - General variables ---------------------------------------------------------

CURRLVL     DS.B    1                       ; This variable is always one less
                                            ; than the REAL current level.
NEXSTA      DC.B    0                       ; These are different variables
CURRSTA     DS.B    1                       ; to simplify changing the music.
MUTED       DC.B    0                       ; 0 = unmuted, FF = muted
            DS.W    0

; - Menu & pause vars ---------------------------------------------------------

SELECT      DC.W    1                       ; It is a word because when using
                                            ; .B it has issues when calculating
                                            ; the module.
CREDITPOS   DC.W    SCRHEIGH
STRSTART    DC.B    'START',0
STRCONT     DC.B    'CONTINUE',0
STRRESET    DC.B    'RESET LEVEL',0
STRMUTE     DC.B    'MUTE',0
STRQUIT     DC.B    'QUIT GAME',0
STRMAIN     DC.B    'MAIN MENU',0
STRRETRY    DC.B    'RETRY',0
STRDEAD     DC.B    'YOU DIED, BUT DO NOT LOSE HOPE',0
STRRSTR     DC.B    'Press SPACE to go back to the main menu',0
ASTERISK    DC.B    '*',0
CREDITS0    DC.B    'Program Skeleton & Agent List:',0
CREDITS1    DC.B    ' Antoni Burguera',0
CREDITS2    DC.B    'Coding and Game Design:',0
CREDITS3    DC.B    ' Andreas Manuel Korn',0
CREDITS4    DC.B    ' Sergio Vega García',0
CREDITS5    DC.B    'Music:',0
CREDITS6    DC.B    ' HeatleyBros',0
            DS.W    0
            
; - Player related vars -------------------------------------------------------

PLRPOSX     DS.W    1
PLRPOSY     DS.W    1
PLRSPDY     DC.W    0
INVFRAMES   DC.L    0                       ; The start of the invincibility
                                            ; frames
PLRLVS      DS.B    1
DIR         DS.B    1
            DS.W    0
            
; - Music and Sound -----------------------------------------------------------

MUSMENU     DC.B    'SoundFX\MainMenu.wav',0
MUSGAME     DC.B    'SoundFX\LevelMusic.wav',0
MUSWIN      DC.B    'SoundFX\WinMusic.wav',0
MUSFAIL     DC.B    'SoundFX\DontLoseHope.wav',0
PLATFXDIR   DC.B    'SoundFX\Impact.wav',0
JMPFXDIR    DC.B    'SoundFX\Jump.wav',0
HURTFXDIR   DC.B    'SoundFX\Hurt.wav',0
            
; -----------------------------------------------------------------------------


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
