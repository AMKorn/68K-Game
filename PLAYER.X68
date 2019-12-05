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
            MOVEM.L D0,-(A7)
            MOVE.B  KBDVAL,D0
            BTST.B  #KBDBITLF,KBDVAL
            BEQ     .NOLEFT
            SUB.W   #PLRSPDX,PLRPOSX
.NOLEFT     BTST.B  #KBDBITUP,KBDVAL
            BEQ     .NOUP
            SUB.W   #PLRSPDY,PLRPOSY
.NOUP       BTST.B  #KBDBITRT,KBDVAL
            BEQ     .NORT
            ADD.W   #PLRSPDX,PLRPOSX
.NORT       BTST.B  #KBDBITDN,KBDVAL
            BEQ     .NODN
            ADD.W   #PLRSPDY,PLRPOSY
.NODN
            MOVEM.L (A7)+,D0
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
