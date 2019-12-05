*===============================================================================
* PLAYER - Is an agent
*===============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT     - None
; OUTPUT    - None
; MODIFIES  - None
; -----------------------------------------------------------------------------
            MOVE.W  #50,PLRPOSX                ; Just to test
            MOVE.W  #50,PLRPOSY
            RTS
            
; -----------------------------------------------------------------------------
PLRUPD
; Updates the player location
; INPUT     - None, reads KBDVAL
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2,-(A7)
            MOVE.B  KBDVAL,D0
            MOVE.W  PLRPOSX,D1
            MOVE.W  PLRPOSY,D2
            BTST.L  #KBDBITLF,D0
            BEQ     .CONT1
            CMP.W   #(0+PLRSPDX),D1
            BGT     .MOVELF
            MOVE.W  #0,D1
            BRA     .CONT1
.MOVELF     SUB.W   #PLRSPDX,D1
            
.CONT1      BTST.L  #KBDBITUP,D0
            BEQ     .CONT2
            CMP.W   #(PLRDIM+PLRSPDX),D2
            BGT     .MOVEUP
            MOVE.W  #(PLRDIM),D2
            BRA     .CONT2
.MOVEUP     SUB.W   #PLRSPDY,D2
            
.CONT2      BTST.L  #KBDBITRT,D0
            BEQ     .CONT3
            CMP.W   #(SCRWIDTH-PLRDIM),D1
            BEQ     .CONT3
            ADD.W   #PLRSPDX,D1
            
.CONT3      BTST.L  #KBDBITDN,D0
            BEQ     .END
            CMP.W   #(SCRHEIGH-PLRDIM),D2
            BEQ     .END
            ADD.W   #PLRSPDY,D2
.END
            MOVE.W  D1,PLRPOSX
            MOVE.W  D2,PLRPOSY
            MOVEM.L (A7)+,D0-D2
            RTS

; -----------------------------------------------------------------------------
PLRPLOT
; Plots the player
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            MOVE.L  #PLRCLR,D1
            MOVE.B  #80,D0
            MOVE.B  #81,D0                  ; Set pen and fill color the same
            TRAP    #15
            MOVE.B  #87,D0
            MOVE.W  PLRPOSX,D1              ; Left X is the player posX
            MOVE.W  PLRPOSY,D2
            SUB.W   #PLRDIM,D2              ; Upper Y is posY-dimensions
            MOVE.W  PLRPOSX,D3
            ADD.W   #PLRDIM,D3              ; Right X
            MOVE.W  PLRPOSY,D4              ; Lower Y
            TRAP    #15
            MOVEM.L (A7)+,D0-D4
            RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
