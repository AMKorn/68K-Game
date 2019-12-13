; =============================================================================
; STATE MANAGER
; =============================================================================

; -----------------------------------------------------------------------------
STATEINIT
; Initializes the game by setting the state as MAIN MENU
; Input     - None
; Output    - None
; Modifies  - CURRSTA
; -----------------------------------------------------------------------------
            MOVE.B  #PLAYING,CURRSTA
            MOVE.B  #1,CURRLVL
            JSR     MAPINIT
            RTS
            
; -----------------------------------------------------------------------------
STATEUPD
; Updates the state of the game.
; Input     - None, reads KBDEDGE
; Output    - None.
; Modifies  - CURRSTA
; -----------------------------------------------------------------------------
            MOVE.B  D1,-(A7)
            
            MOVE.B  CURRSTA,D1
            CMP.B   #MAINMENU,D1
            BNE     .PLAYING
            
.PLAYING    JSR     PLRUPD
            JSR     MAPUPD
            
            MOVE.B  (A7)+,D1
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
