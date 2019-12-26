; =============================================================================
; END STATES
; =============================================================================

; -----------------------------------------------------------------------------
WINUPD
; Screen with an option to go back to the main menu.
; Input     - None
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVE.B  D0,-(A7)
            MOVE.B  KBDEDGE,D0
            BTST.L  #KBDBITF1,D0
            BEQ     .END
            MOVE.W  #0,SELECT
            MOVE.B  #MAINMENU,NEXSTA
.END        MOVE.B  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
WINPLOT
; Prints the credits of the game on the screen.
; Input     - None
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            
            SETFILL BLACK
            MOVE.L  #WHITE,D1
            CLR.L   D2
            MOVE.W  #21,D0
            TRAP    #15
            
            MOVE.W  #95,D0
            MOVE.W  #100,D1
            MOVE.W  #100,D2
            LEA.L   CREDITS0,A1
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   CREDITS1,A1
            TRAP    #15
            
            ADD.W   #40,D2
            LEA.L   CREDITS2,A1
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   CREDITS3,A1
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   CREDITS4,A1
            TRAP    #15
            
            ADD.W   #40,D2
            LEA.L   CREDITS5,A1
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   CREDITS6,A1
            TRAP    #15
            
            ADD.W   #40,D2
            LEA.L   STRRSTR,A1
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D2/A1
            RTS

; -----------------------------------------------------------------------------
DEADUPD
; Small menu with two options: retry level or quit game
; Input     - None
; Output    - None
; Modifies  - None
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
            ADD.B   #DEADOPTS-1,D1
.CHANGE
            DIVS    #DEADOPTS,D1
            CLR.W   D1
            SWAP    D1
            MOVE.W  D1,SELECT
            BRA     .END
            
.ACTIVATE   CMP.W   #DEADTRY,D1
            BNE     .QUIT
            JSR     KILLALL                 ; Kills all enemies
            JSR     MAPINIT                 ; Restarts the level
            MOVE.B  #STRTLIVES,PLRLVS
            MOVE.B  #PLAYING,NEXSTA
            BRA     .END
            
.QUIT       CMP.W   #DEADQUIT,D1            
            MOVE.B  #STRTLIVES,PLRLVS
            JSR     KILLALL
            MOVE.W  #0,SELECT
            MOVE.B  #MAINMENU,NEXSTA
            
.END        MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
DEADPLOT
; Plots the dead window
; Input     - None
; Output    - None
; Modifies  - None
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
            ADD.W   #40,D1
            ADD.W   #80,D2
            LEA.L   STRDEAD,A1
            MOVE.B  #95,D0
            TRAP    #15
            
            ADD.W   #40,D1
            ADD.W   #40,D2
            LEA.L   STRRESET,A1
            TRAP    #15
            
            ADD.W   #20,D2
            LEA.L   STRMAIN,A1
            TRAP    #15
            
            SUB.W   #20,D1
            MOVE.W  #SCRHEIGH/4+80+40,D2
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
