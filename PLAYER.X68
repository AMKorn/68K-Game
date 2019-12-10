*===============================================================================
* PLAYER - Is an agent
*===============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT     - D1.L: The player position, with 2 most significant Bytes being
;             on X axis and least significant in Y axis
; OUTPUT    - None
; MODIFIES  - D1.L
; -----------------------------------------------------------------------------
            ;MOVE.L  D1,-(A7)
            MOVE.W  D1,PLRPOSY
            LSR.L   #8,D1
            LSR.L   #8,D1
            MOVE.W  D1,PLRPOSX
            ;MOVE.L  (A7)+,D1
            
            RTS
            
; -----------------------------------------------------------------------------
PLRUPD
; Updates the player location
; INPUT     - None, reads KBDVAL and KBDEDGE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            MOVE.B  KBDVAL,D0
            MOVE.B  KBDEDGE,D1
            MOVE.W  PLRPOSX,D2
            MOVE.W  PLRPOSY,D3
            MOVE.W  PLRSPDY,D4
            
            ; ---- Horizontal movement ----------------------------------------
            BTST.L  #KBDBITLF,D0
            BEQ     .NOLF
            SUB.W   #PLRSPDX,D2
            
.NOLF       BTST.L  #KBDBITRT,D0
            BEQ     .X_OOB
            ADD.W   #PLRSPDX,D2
            
            ; --- Horizontal collisions - To be moved down --------------------

.X_OOB      CMP.W   #0,D2                   ; Checks if OOB (Out-of-Bounds)
            BGT     .NOTOOB1                ; on the X-axis
            MOVE.W  #0,D2
            BRA     .VERT
.NOTOOB1    CMP.W   #(SCRWIDTH-PLRDIM),D2
            BLT     .VERT
            MOVE.W  #(SCRWIDTH-PLRDIM),D2

            ; --- Vertical movement -------------------------------------------

.VERT       BTST.L  #KBDBITUP,D1            ; Checks if UP was pressed on EDGE
            BEQ     .NOEDGE
            MOVE.W  #IMPULSE,D4
            
.NOEDGE     ;BTST.L  #KBDBITUP,D0           ; Uncomment this section
            ;BNE     .NOJUMP                ; to have gradual jump
            CMP.W   #MAXSPD,D4
            BEQ     .NOGRAV
            ADD.W   #GRAVITY,D4
            
.NOGRAV     ADD.W   D4,D3                   ; Fall (PLRPOSY+PLRSPDY)

            ; --- Collisions --------------------------------------------------
            
            LEA.L   MAPINFO1,A0
            
            ; -- Lower Left Corner (posX,posY) --
            
            MOVE.W  D2,D0                   ; posX -> D0
            DIVS    #GRIDWTH,D0             ; D0 now has X grid of the player
            AND.L   #$FFFF,D0               ; We don't care about the residue
            LSL.W   #8,D0                   ; D0.W now has XX00
            CLR.L   D1
            MOVE.W  D3,D1                   ; posY -> D1
            DIVS    #GRIDHGT,D1             ; D1 now has Y grid of the player
            AND.L   #$FFFF,D1
            MOVE.B  D1,D0                   ; D0 now has XXYY of player
            JSR     GETGRIDVAL
            CMP.B   #1,D1                   ; If lower left cell is ground
            BNE     .LRCORNER
            CLR.W   D3
            MOVE.B  D0,D3
            SUBQ.B  #1,D3
            MULU.W  #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            CLR.W   D4
            
            ; -- Lower Rigth Corner (posX+plrDim,posY) --
            
.LRCORNER   MOVE.W  D2,D0
            ADD.W   #PLRDIM,D0              ; posX+plrDim -> D0
            DIVS    #GRIDWTH,D0
            AND.L   #$FFFF,D0
            LSL.W   #8,D0
            CLR.L   D1
            MOVE.W  D3,D1                   ; posY -> D1
            DIVS    #GRIDHGT,D1
            MOVE.B  D1,D0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BNE     .ULCORNER
            CLR.W   D3
            MOVE.B  D0,D3
            SUBQ.W  #1,D3
            MULU.W  #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            CLR.W   D4
            
            ; -- Upper Left Corner (posX,posY-plrDim) --
            
.ULCORNER   MOVE.W  D2,D0                   ; posX -> D0
            DIVS    #GRIDWTH,D0
            AND.L   #$FFFF,D0
            LSL.L   #8,D0
            CLR.L   D1
            MOVE.W  D3,D1
            SUB.W   #PLRDIM,D1              ; posY-plrDim -> D1
            DIVS    #GRIDHGT,D1
            MOVE.B  D1,D0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BNE     .URCORNER
            CLR.W   D3
            MOVE.B  D0,D3
            ADDQ.W  #1,D3
            MULU    #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            CLR.W   D4
            
            ; -- Upper Right Corner (posX+plrDim,posY-plrDim) --
            
.URCORNER   MOVE.W  D2,D0                   
            ADD.W   #PLRDIM,D0              ; posX+plrDim -> D0
            DIVS    #GRIDWTH,D0
            AND.L   #$FFFF,D0
            LSL.L   #8,D0
            CLR.L   D1
            MOVE.W  D3,D1
            SUB.W   #PLRDIM,D1              ; posY-plrDim -> D1
            DIVS    #GRIDHGT,D1
            MOVE.B  D1,D0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BNE     .Y_OOB
            CLR.W   D3
            MOVE.B  D0,D3
            ADDQ.W  #1,D3
            MULU    #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            CLR.W   D4

            
.Y_OOB      CMP.W   #PLRDIM,D3              ; Checks if OOB on Y-axis
            BGT     .NOTOOB2
            MOVE.W  #PLRDIM,D3
            BRA     .END
.NOTOOB2    CMP.W   #SCRHEIGH,D3
            BLT     .END
            MOVE.W  #SCRHEIGH,D3
            
.END        MOVE.W  D2,PLRPOSX
            MOVE.W  D3,PLRPOSY
            MOVE.W  D4,PLRSPDY
            MOVEM.L (A7)+,D0-D4
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
