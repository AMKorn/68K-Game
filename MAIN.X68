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
            INCLUDE "PLAYER.X68"            ; PLAYER CODE
            INCLUDE "MAPS.X68"              ; MAPS SUBROUTINES
            INCLUDE "GAMEMNGR.X68"
            INCLUDE "MENU.X68"
            INCLUDE "AGENTLST.X68"
            INCLUDE "ENEMY.X68"

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

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            INCLUDE "MAPINFO.X68"
            END    START













*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
