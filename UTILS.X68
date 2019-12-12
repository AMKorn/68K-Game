; =============================================================================
; UTILS
; =============================================================================

; -----------------------------------------------------------------------------
GETCELL     MACRO
; Macro that calculates the cell number of a given pixel in the grid.
; Input     - D\1 : the X position of the pixel
;           - #\2 : the offset of the x position
;           - D\3 : the Y position of the pixel
;           - #\4 : the offset of the y position
; Output:   - D\5.W : The X and Y index of the cell in format XXYY
; Modifies  - Nothing, except the output
; -----------------------------------------------------------------------------
            MOVEM.L D\1/D\3,-(A7)
            ADD.W   #\2,D\1
            DIVU    #GRIDWTH,D\1
            AND.L   #$FFFF,D\1
            MOVE.B  D\1,D\5
            LSL.W   #8,D\5
            ADD.W   #\4,D\3
            DIVU    #GRIDHGT,D\3
            AND.L   #$FFFF,D\3
            MOVE.B  D\3,D\5
            MOVEM.L (A7)+,D\1/D\3
            ENDM

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
