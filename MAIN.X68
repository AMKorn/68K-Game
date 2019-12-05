; =============================================================================
; TITLE    : EXAMPLE GAME
; AUTHOR   :
; CREATION :
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; GAME CONSTANTS
            INCLUDE "PLAYER.X68"            ; PLAYER CODE
            ; TO DO: PUT YOUR GAME-RELATED INCLUDES HERE

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            JSR     PLRINIT
            ; TO DO: CALL GAME INITIALIZATION CODE HERE

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     PLRUPD
            ; TO DO: CALL GAME UPDATE CODE HERE

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            ; TO DO: CALL GAME PLOT CODE HERE
            JSR     PLRPLOT
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
