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
            
; -----------------------------------------------------------------------------
SETPEN      MACRO
; Sets the pen to the specified color.
; Input     - #\1 : The color to set the pen to.
; Output    - None
; Modifies  - D0.B and D1.L
; -----------------------------------------------------------------------------
            MOVE.B  #80,D0
            MOVE.L  #\1,D1
            TRAP    #15
            ENDM
            
; -----------------------------------------------------------------------------
SETFILL     MACRO
; Sets the fill to the specified color.
; Input     - #\1 : The color to set the fill to.
; Output    - None
; Modifies  - D0.B and D1.L
; -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            MOVE.L  #\1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
SUBLIFE     MACRO
; Substracts one from the player lives
; Input     - None
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVE.B  D0,-(A7)
            MOVE.B  PLRLVS,D0
            SUBQ.B  #1,D0
            MOVE.B  D0,PLRLVS
            MOVE.B  (A7)+,D0
            ENDM

; -----------------------------------------------------------------------------
PLAYSND     MACRO
; If game is not muted, plays a specified sound once using DirectX player.
; Input     - #\1 : The reference number of the sound to play.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            CMP.B   #0,MUTED
            BNE     .MUTED
            MOVE.B  #\1,D1
            MOVE.B  #75,D0
            TRAP    #15
.MUTED      MOVEM.L (A7)+,D0-D1
            ENDM



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
