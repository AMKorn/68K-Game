; =============================================================================
; MAIN MENU
; =============================================================================

*; -----------------------------------------------------------------------------
*MENUINIT
*; Input     - None
*; Output    - None
*; Modifies  - PLRPOSY
*; -----------------------------------------------------------------------------
*            MOVE.B  #PLAY,PLRPOSY
*            RTS

; -----------------------------------------------------------------------------
MENUUPD
; The main menu utilizes PLRPOSY as a selector for the different options.
; Input     - None, reads KBDEDGE and SELECT
; Output    - None
; Modifies  - PLRPOSY
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
            ADD.B   #2,D1
.CHANGE
            DIVS    #3,D1
            CLR.W   D1
            SWAP    D1
            MOVE.W  D1,SELECT
            BRA     .END
            
.ACTIVATE   CMP.W   #MENUPLAY,D1
            BNE     .MUTE
            MOVE.B  #1,CURRLVL
            MOVE.B  #PLAYING,CURRSTA
            JSR     MAPINIT
            BRA     .END
.MUTE       CMP.W   #MENUMUTE,D1
            BNE     .QUIT
            JSR     MUTEUNMUTE
.QUIT       CMP.B   #MENUQUIT,D1
            BNE     .END
            MOVE.B  #76,D0
            MOVE.B  SONG,D1
            MOVE.L  #2,D2
            TRAP    #15
            SIMHALT
            
.END        MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
MENUPLOT
; Plots the main menu.
; Input     - None, reads PLRPOSY
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A1,-(A7)
            MOVE.W  #250,D1
            MOVE.W  #250,D2
            LEA.L   STRSTART,A1
            MOVE.B  #95,D0
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   STRMUTE,A1
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   STRQUIT,A1
            TRAP    #15
            
            SUB.W   #20,D1
            MOVE.W  #250,D2
            MOVE.W  SELECT,D3
            MULU.W  #20,D3
            ADD.W   D3,D2
            LEA.L   ASTERISK,A1
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D3/A1
            RTS
          
; ----------------------------------------------------------------------------- 
MUTEUNMUTE
; Toggles the sound state to muted or unmuted depending on the previous state.
; Input     - None
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2,-(A7)
            
            CMP.B   #0,.MUTED
            BNE     .UNMUTE
            MOVE.B  #76,D0
            MOVE.B  SONG,D1
            MOVE.L  #2,D2
            TRAP    #15
            NOT.B   .MUTED
            BRA     .END
            
.UNMUTE     ;LEA.L   MUSMENU,A1
            ;MOVE.B  #71,D0
            ;TRAP    #15
            ;MOVE.B  D1,SONG
            MOVE.B  SONG,D1
            MOVE.B  #76,D0
            MOVE.L  #1,D2
            TRAP    #15
            NOT     .MUTED
.END            
            MOVEM.L (A7)+,D0-D2
            RTS
            
.MUTED      DC.B    0
            DS.W    0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
