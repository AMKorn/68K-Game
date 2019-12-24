; =============================================================================
; ENEMIES
; Is an agent, so all of their parameters are as an index from (A0).
; ENMY_XOF(A0).L : The position of the enemy in pixels in format XXXX YYYY
; ENMY_XOF(A0).W : The X position of the enemy in pixels.
; ENMY_YOF(A0).W : The Y position of the enemy in pixels.
; ENMY_YSPD(A0).W : The vertical speed of the enemy.
; ISFACING(A0).B : The direction the enemy is looking. (LEFT or RIGHT)
; =============================================================================

; -----------------------------------------------------------------------------
ENMYINIT
; Initializes the enemy on the given cell.
; Input     - D1.W : The starting position of the enemy in cells in format XXYY
;           - A0.L : The enemy data block.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVE.L  D2,-(A7)
            CLR.L   D2
            MOVE.B  D1,D2
            MULU    #GRIDHGT,D2
            MOVE.W  D2,ENMY_YOF(A0)
            LSR     #8,D1
            CLR.L   D2
            MOVE.B  D1,D2
            MULU    #GRIDWTH,D2
            MOVE.W  D2,ENMY_XOF(A0)
            CLR.W   ENMY_YSPD(A0)
            MOVE.B  #LEFT,ISFACING(A0)
            MOVE.L  (A7)+,D2
            RTS
            
; -----------------------------------------------------------------------------
ENMYUPD
; Updates the enemy
; Input     - A0.L : The enemy data block.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D2-D4,-(A7)
            
            CMP.B   #LEFT,ISFACING(A0)
            BEQ     .MOVELFT
            ADD.W   #PLRSPDX/2,ENMY_XOF(A0)
            BRA     .HORCOLL
            
.MOVELFT    SUB.W   #PLRSPDX/2,ENMY_XOF(A0)

.HORCOLL    MOVE.W  ENMY_XOF(A0),D2
            MOVE.W  ENMY_YOF(A0),D3
            JSR     HORCOLL
            CMP.B   #1,D4
            BNE     .VERT
            NOT.B   ISFACING(A0)
            
.VERT       MOVE.B  ENMY_YSPD(A0),D4
            ADD.W   #5*GRAVITY,D4
.NOGRAV     ADD.W   D4,D3
            JSR     VERCOLL
            
            MOVE.W  D2,ENMY_XOF(A0)
            MOVE.W  D3,ENMY_YOF(A0)
            MOVE.W  D4,ENMY_YSPD(A0)
            
.END        MOVEM.L (A7)+,D2-D4
            RTS
            
; -----------------------------------------------------------------------------         
ENMYPLOT
; Plots the enemy
; Input     - A0.L : The enemy data block.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            SETPEN  BLACK
            SETFILL RED
            MOVE.W  ENMY_XOF(A0),D1
            MOVE.W  ENMY_YOF(A0),D2
            MOVE.W  D1,D3
            ADD.W   #PLRDIM,D3
            MOVE.W  D2,D4
            SUB.W   #PLRDIM,D2
            MOVE.B  #87,D0
            TRAP    #15
            
            ; Draw the eyes
            SETFILL BLACK
            
            MOVE.B  ISFACING(A0),D0
            CMP.B   #LEFT,D0
            BEQ     .LOOK_LEFT
            
            MOVE.B  #88,D0
            MOVE.W  ENMY_XOF(A0),D1
            ADD.W   #15,D1
            MOVE.W  D1,D3
            ADD.W   #11,D3
            ADDQ.W  #5,D2
            MOVE.W  D2,D4
            ADD.W   #16,D4
            TRAP    #15
            
            ADD.W   #14,D1
            ADD.W   #14,D3
            TRAP    #15
            BRA     .END
            
.LOOK_LEFT  MOVE.B  #88,D0
            SUB.W   #15,D3
            MOVE.W  D3,D1
            SUB.W   #11,D1
            ADDQ.W  #5,D2
            MOVE.W  D2,D4
            ADD.W   #16,D4
            TRAP    #15
            
            SUB.W   #14,D1
            SUB.W   #14,D3
            TRAP    #15
            
.END        MOVEM.L (A7)+,D0-D4
            RTS

; -----------------------------------------------------------------------------
KILLALL
; Kills all enemies
; Input     - None
; Output    - None
; Modifes   - None
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
.CONT       JSR     DMMFIRST
            CMP.L   #0,A0
            BEQ     .END
.ISENMY     CMP.W   #5,-(A0)
            BEQ     .DELETE
            JSR     DMMNEXTO
            CMP.L   #0,A0
            BEQ     .END
            BRA     .ISENMY
.DELETE     JSR     DMMFREE
            BRA     .CONT

.END        MOVE.L  (A7)+,A0
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
