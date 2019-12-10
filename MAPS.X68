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
            DS.W    0                       ; Just in case
       
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
            BNE     .NEXT
            MOVE.B  #81,D0
            MOVE.L  #BLACK,D1
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

.NEXT
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
            

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
