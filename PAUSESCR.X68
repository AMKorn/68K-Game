; =============================================================================
; PAUSE SCREEN
; =============================================================================

; -----------------------------------------------------------------------------
PAUSEUPD
; The pause menu, just like the menu, uses SELECT as a selector.
; Since it also has a menu of options, the code is similar to MENUUPD.
; Input     - None, reads KBDEDGE and SELECT
; Output    - None
; Modifies  - SELECT
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.B  KBDEDGE,D0
            MOVE.W  SELECT,D1
            BTST.L  #KBDBITF1,D0
            BNE     .ACTIVATE
            BTST.L  #KBDBITDN,D0
            BEQ     .UP
            ADD.B   #1,D1
            BRA     .CHANGE
.UP         
            BTST.L  #KBDBITUP,D0
            BEQ     .END
            ADD.B   #PSEOPTIONS-1,D1
.CHANGE     
            DIVS    #PSEOPTIONS,D1
            CLR.W   D1
            SWAP    D1
            MOVE.W  D1,SELECT
            BRA     .END
            
.ACTIVATE   CMP.W   #PSEPLAY,D1
            BNE     .RESET
            MOVE.B  #PLAYING,CURRSTA
            BRA     .END
            
.RESET      CMP.W   #PSERESET,D1
            BNE     .MUTE
            JSR     KILLALL
            JSR     MAPINIT
            MOVE.B  #PLAYING,CURRSTA
            BRA     .END
.MUTE       CMP.W   #PSEMUTE,D1
            BNE     .QUIT
            JSR     MUTEUNMUTE
            BRA     .END
.QUIT       JSR     KILLALL
            MOVE.W  #0,SELECT
            MOVE.B  #MAINMENU,CURRSTA
            
.END        MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
PAUSEPLOT
; Plots the pause menu
; Input     - None, reads SELECT
; Output    - None
; Modifes   - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            SETFILL WHITE
            SETPEN  BLACK
            MOVE.W  #SCRWIDTH/4,D1
            MOVE.W  D1,D3
            ADD.W   #SCRWIDTH/2,D3
            MOVE.W  #SCRHEIGH/4,D2
            MOVE.W  D2,D4
            ADD.W   #SCRHEIGH/2,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVE.L  #BLACK,D1
            CLR.L   D2
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.W  #SCRWIDTH/4,D1
            MOVE.W  #SCRHEIGH/4,D2
            ADD.W   #80,D1
            ADD.W   #80,D2
            LEA.L   STRCONT,A1
            MOVE.B  #95,D0
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   STRRESET,A1
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   STRMUTE,A1
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   STRMAIN,A1
            TRAP    #15
            
            SUB.W   #20,D1
            MOVE.W  #SCRHEIGH/4+80,D2
            MOVE.W  SELECT,D3
            MULU.W  #20,D3
            ADD.W   D3,D2
            LEA.L   ASTERISK,A1
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4
            RTS
            
            
            
            

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
