; =============================================================================
; MAPS MANAGER
; This file includes the subroutines which are needed to initialize, update
; and plot the maps. Each level's information is stored in MAPINFO.X68.
; =============================================================================

; -----------------------------------------------------------------------------
MAPINIT
; Initializes the map, and places the player in it.
; Input     - None, reads CURRLVL
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A0,-(A7)
            
            ; Moves the current level's matrix pointer to A0
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL0,A0
            MOVE.L  (A0,D1.W),A0
            
            CLR.L   D1
            CLR.L   D0
            MOVE.W  #0,D2                   ; D2.B is YY
.YLOOP
            MOVE.W  #0,D3                   ; D3.B is XX
.XLOOP      
            ; For the moment this for-loop is completely useless (apart from
            ; moving A0 to the STARTN location) but it will have its uses when
            ; more things (such as enemies) are introduced.
            CMP.B   #5,(A0)
            BNE     .NEXT
            MOVE.B  D3,D1                   ; D1.W is 00XX
            LSL     #8,D1
            MOVE.B  D2,D1                   ; D1.W is XXYY
            MOVE.B  #5,D0
            LEA.L   ENMYINIT,A1
            LEA.L   ENMYUPD,A2
            LEA.L   ENMYPLOT,A3
            JSR     AGLADD                  ; Adds an enemy to the agent list.

.NEXT       
            ADDQ.L  #1,A0
            ADDQ.B  #1,D3
            CMP.B   #XGRIDS,D3
            BNE     .XLOOP
            
            ADDQ.B  #1,D2
            CMP.B   #YGRIDS,D2
            BNE     .YLOOP
            
            MOVE.L  (A0),D1
            JSR     PLRINIT
            
            MOVEM.L (A7)+,D0-D3/A0
            RTS

; -----------------------------------------------------------------------------
MAPUPD
; Updates the map.
; Input     - None, reads CURRLVL and KBDEDGE
; Output    - None
; Modifies  - The information in the level matrix.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A0,-(A7)
            
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL0,A0
            ADD.L   D1,A0
            MOVE.L  (A0),A0
            
            CLR.L   D1
            
            MOVE.B  KBDEDGE,D0
            
.CONT       BTST.L  #KBDBITDN,D0
            BEQ     .END
            
            MOVE.W  #0,D2
.YLOOP
            MOVE.W  #0,D3
.XLOOP      
            CMP.B   #3,(A0)
            BNE     .NEXT
            MOVE.B  #0,(A0)

.NEXT       
            ADDQ.L  #1,A0
            ADDQ.B  #1,D3
            CMP.B   #XGRIDS,D3
            BNE     .XLOOP
            
            ADDQ.B  #1,D2
            CMP.B   #YGRIDS,D2
            BNE     .YLOOP

            MOVE.L  (A0),D1
            JSR     PLRINIT
            
.END        MOVEM.L (A7)+,D0-D3/A0
            RTS

; -----------------------------------------------------------------------------     
MAPPLOT
; Plots a map given its matrix of information.
; Input     - None, reads CURRLVL
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D6/A0,-(A7)
            
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL0,A0
            ADD.L   D1,A0
            MOVE.L  (A0),A0
            
            ; - Paint the whole screen white first ----------------------------
            
            SETFILL WHITE
            MOVE.B  #87,D0
            MOVE.W  #0,D1
            MOVE.W  #0,D2
            MOVE.W  #SCRWIDTH,D3
            MOVE.W  #SCRHEIGH,D4
            TRAP    #15
            
            ; - Paint the platforms -------------------------------------------
            
            MOVE.W  #0,D5                   ; D5 = Y index of grid
.YLOOP
            MOVE.W  #0,D6                   ; D6 = X index of grid
.XLOOP            
            CMP.B   #1,(A0)                 ; There is ground
            
            BNE     .NEXT1
            SETFILL BLACK
            SETPEN  BLACK
            
            ; Paint the black squares
            MOVE.W  D6,D1
            MULS.W  #GRIDWTH,D1
            MOVE.W  D1,D3
            ADD.W   #GRIDWTH,D3
            
            MOVE.W  D5,D2
            MULS.W  #GRIDHGT,D2
            MOVE.W  D2,D4
            ADD.W   #GRIDHGT,D4
            MOVE.B  #87,D0
            TRAP    #15
            
.NEXT1      CMP.B   #3,(A0)
            BNE     .NEXT2
            
            SETFILL L_GREEN
           
            ; Paint the green squares
            MOVE.W  D6,D1
            MULS.W  #GRIDWTH,D1
            MOVE.W  D1,D3
            ADD.W   #GRIDWTH,D3
            
            MOVE.W  D5,D2
            MULS.W  #GRIDHGT,D2
            MOVE.W  D2,D4
            ADD.W   #GRIDHGT,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ; Draw the eyes
            SETFILL BLACK
            
            MOVE.B  #84,D0
            MOVE.W  D6,D1
            MULS.W  #GRIDWTH,D1
            ADD.W   #15,D1
            MOVE.W  D1,D3
            ADD.W   #11,D3
            ADDQ.W  #5,D2
            MOVE.W  D2,D4
            ADD.W   #16,D4
            TRAP    #15
                        
            SWAP    D2
            MOVE.W  D4,D2
            SWAP    D2
            MOVE.W  D2,D4
            SWAP    D2
            TRAP    #15
            
            ADD.W   #14,D1
            ADD.W   #14,D3
            TRAP    #15
            
            SWAP    D2
            MOVE.W  D4,D2
            SWAP    D2
            MOVE.W  D2,D4
            SWAP    D2
            TRAP    #15

.NEXT2            
            CMP.B   #2,(A0)
            BNE     .NEXT3
                        
            SETFILL PINK
            
            ; Paint the portal
            
            MOVE.W  D6,D1
            MULS.W  #GRIDWTH,D1
            MOVE.W  D1,D3
            ADD.W   #GRIDWTH,D3
            
            MOVE.W  D5,D2
            MULS.W  #GRIDHGT,D2
            MOVE.W  D2,D4
            ADD.W   #GRIDHGT,D4
            MOVE.B  #88,D0
            TRAP    #15
            
            ADD.W   #5,D1
            SUB.W   #5,D3
            ADD.W   #5,D2
            SUB.W   #5,D4
            TRAP    #15

            
.NEXT3      CMP.B   #4,(A0)
            BNE     .NEXT4
            
            SETFILL AQUA
            
            MOVE.W  D6,D1
            MULS.W  #GRIDWTH,D1
            MOVE.W  D1,D3
            ADD.W   #GRIDWTH,D3
            
            MOVE.W  D5,D2
            MULS.W  #GRIDHGT,D2
            MOVE.W  D2,D4
            ADD.W   #GRIDHGT,D4
            MOVE.B  #88,D0
            TRAP    #15
            
            ADD.W   #5,D1
            SUB.W   #5,D3
            ADD.W   #5,D2
            SUB.W   #5,D4
            TRAP    #15
            
.NEXT4            
            ADDQ.L  #1,A0
            ADDQ.B  #1,D6
            CMP.B   #XGRIDS,D6
            BNE     .XLOOP
            
            ADDQ.B  #1,D5
            CMP.B   #YGRIDS,D5
            BNE     .YLOOP
            MOVEM.L (A7)+,D0-D6/A0
            RTS
            
; -----------------------------------------------------------------------------
GETGRIDVAL
; Function to get which is the value of the specified cell.
; Input     - D0.W : The X and Y index of the cell in format XXYY
;           - A0.L : The pointer to the matrix with the level info
; Output    - D1.B : The value of the selected cell.
; Modifies  - Nothing, except the output
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D1
            MOVE.B  D0,D1
            LSL     #4,D1
            ADDA.L  D1,A0
            
            LSR     #8,D0
            ADDA.L  D0,A0
            
            MOVE.B  (A0),D1
            MOVEM.L (A7)+,D0/A0
            RTS
           
; -----------------------------------------------------------------------------
SETGRIDVAL
; Function to set the value of a specified cell in the level.
; Input     - D0.W : The X and Y value of the cell in format XXYY
;           - D1.B : The value of the cell
;           - A0.L : The pointer to the matrix with the level info
; Output    - None
; Modifies  - The value of the cell specified in D0.W, but no registers
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A0,-(A7)
            
            CLR.L   D2
            MOVE.B  D0,D2
            LSL     #4,D2
            ADDA.L  D2,A0
            
            LSR     #8,D0
            ADDA.L  D0,A0
            
            MOVE.B  D1,(A0)
            MOVEM.L (A7)+,D0-D2/A0
            RTS











*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
