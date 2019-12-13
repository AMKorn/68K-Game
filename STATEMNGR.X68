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
            LEA.L   MUSMENU,A1
            MOVE.B  #71,D0
            TRAP    #15
            MOVE.B  D1,SONG
            MOVE.B  #76,D0
            MOVE.L  #1,D2
            TRAP    #15
            MOVE.B  #MAINMENU,CURRSTA
            MOVE.B  #MENUPLAY,PLRPOSY
            ;MOVE.B  #1,CURRLVL
            ;JSR     MAPINIT
            RTS
            
; -----------------------------------------------------------------------------
STATEUPD
; Updates the state of the game.
; Input     - None, reads KBDEDGE and CURRSTA
; Output    - None.
; Modifies  - CURRSTA
; -----------------------------------------------------------------------------
            MOVE.L  D1,-(A7)
            
            CLR.L   D1
            MOVE.B  CURRSTA,D1
            CMP.B   #MAINMENU,D1
            BNE     .PLAYING
            
            JSR     MENUUPD
            BRA     .END
            
.PLAYING    JSR     PLRUPD
            JSR     MAPUPD
            
.END
            MOVE.L  (A7)+,D1
            RTS
            
; -----------------------------------------------------------------------------
STATEPLOT
; Input     - None, reads CURRSTA
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVE.L  D1,-(A7)
            
            CLR.L   D1
            MOVE.B  CURRSTA,D1
            CMP.B   #MAINMENU,D1
            BNE     .PLAYING
            JSR     MENUPLOT
            BRA     .END
            
.PLAYING    JSR     MAPPLOT
            JSR     PLRPLOT
            
.END        MOVE.L  (A7)+,D1
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
