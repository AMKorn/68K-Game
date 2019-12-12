; =============================================================================
; MAPS
; Every map is divided in a 16x12 grid with each cell's information
; =============================================================================

MAPINFO1    DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
START1      DC.B    1*GRIDWTH,1*GRIDHGT     ; X,Y coordinates of player start
            DS.W    0                       ; Better safe than sorry
       
; -----------------------------------------------------------------------------
MAPINIT
; Initializes the map, and places the player in it.
; Input     - A0: The pointer to the matrix with the level info
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A0,-(A7)
            
            CLR.L   D1
            CLR.L   D0
            MOVE.W  #0,D2
.YLOOP
            MOVE.W  #0,D3
.XLOOP      
*            CMP.B   #2,(A0)
*            BNE     .NEXT
*            MOVE.B  D3,D1
*            MULU    #GRIDWTH,D1
*            LSL.L   #8,D1
*            LSL.L   #8,D1
*            MOVE.B  D2,D0
*            MULU.W  #GRIDHGT,D0
*            ADD.B   #PLRDIM,D0
*            MOVE.W  D0,D1
*            JSR     PLRINIT

.NEXT       
            ADDQ.L  #1,A0
            ADDQ.B  #1,D3
            CMP.B   #XGRIDS,D3
            BNE     .XLOOP
            
            ADDQ.B  #1,D2
            CMP.B   #YGRIDS,D2
            BNE     .YLOOP
            
            MOVE.W  (A0),D1
            JSR     PLRINIT
            
            MOVEM.L (A7)+,D0-D3/A0
            RTS            

; -----------------------------------------------------------------------------
MAPUPD
; Updates the map.
; Input     - A0: The pointer to the matrix with the level info.
;           - Reads KBDEDGE
; Output    - None
; Modifies  - The information in the level matrix.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A0,-(A7)
            
            MOVE.B  KBDEDGE,D0
            BTST.L  #KBDBITDN,D0
            BEQ     .CONT
            ADD.L   #XGRIDS*YGRIDS,A0
            MOVE.W  (A0),D1
            JSR     PLRINIT
            BRA     .END
            
.CONT       BTST.L  #KBDBITF1,D0
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

            MOVE.W  (A0),D1
            JSR     PLRINIT
            
.END        MOVEM.L (A7)+,D0-D3/A0
            RTS

; -----------------------------------------------------------------------------     
MAPPLOT
; Plots a map given its matrix of information.
; Input     - A0: The pointer to the matrix with the level info
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D6/A0,-(A7)
            
            ; - Paint the whole screen white first ----------------------------
            
            MOVE.B  #81,D0
            MOVE.L  #WHITE,D1
            TRAP    #15

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
            MOVE.B  #81,D0
            MOVE.L  #BLACK,D1
            TRAP    #15
            MOVE.B  #80,D0
            TRAP    #15
            
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
            
            MOVE.B  #81,D0
            MOVE.L  #CLONE,D1
            TRAP    #15
           
            ; Paint the red squares
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
            
.NEXT2
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
; Modifies  - The value of the cell specified in D0.W
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
