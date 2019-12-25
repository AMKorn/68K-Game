; =============================================================================
; TITLE    : EXAMPLE GAME
; AUTHOR   : Korn, Andreas Manuel & Vega García, Sergio
; CREATION : 
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------
            
            INCLUDE "UTILS.X68"             ; UTILITIES
            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; GAME CONSTANTS            
            INCLUDE "GAME.X68"              ; THE GAME BASE CODE
            INCLUDE "PLAYER.X68"            ; PLAYER CODE
            INCLUDE "MAPS.X68"              ; MAPS SUBROUTINES
            INCLUDE "MENU.X68"              ; MENU CODE
            INCLUDE "AGENTLST.X68"          ; AGENT LIST CODE
            INCLUDE "ENEMY.X68"             ; ENEMY CODE
            INCLUDE "PAUSESCR.X68"          ; PAUSE CODE

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            JSR     GAMEINIT

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     GAMEUPD

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            JSR     GAMEPLOT
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"            ; SYSTEM VARIABLES
            INCLUDE "VAR.X68"               ; GAME VARIABLES
            INCLUDE "MAPINFO.X68"           ; MAP MATRIXES
            END    START
            


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
