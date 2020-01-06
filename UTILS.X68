; =============================================================================
; UTILS
; =============================================================================

; -----------------------------------------------------------------------------
GETCELL     MACRO
; Macro that calculates the cell number of a given pixel in the grid.
; Input     - \1.W : D register with the X position of the pixel
;           - #\2 : the offset of the x position
;           - \3.W : D register with the Y position of the pixel
;           - #\4 : the offset of the y position
; Output:   - \5.W : The X and Y index of the cell in format XXYY
; Modifies  - Nothing, except the output
; -----------------------------------------------------------------------------
            MOVEM.L \1/\3,-(A7)
            ADD.W   #\2,\1
            DIVU    #GRIDWTH,\1
            AND.L   #$FFFF,\1
            MOVE.B  \1,\5
            LSL.W   #8,\5
            ADD.W   #\4,\3
            DIVU    #GRIDHGT,\3
            AND.L   #$FFFF,\3
            MOVE.B  \3,\5
            MOVEM.L (A7)+,\1/\3
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
            BNE     .MUTED\1
            MOVE.B  #\1,D1
            MOVE.B  #75,D0
            TRAP    #15
.MUTED\1    MOVEM.L (A7)+,D0-D1
            ENDM

; -----------------------------------------------------------------------------
PLAYSNG     MACRO
; If game is not muted, stops the previous song and plays a specified song 
; on loop using DirectX player.
; Input     - \1 : The null terminated path address of the song.
; Output    - None
; Modifies  - Whatever registry it requires
; -----------------------------------------------------------------------------
            CMP.B   #0,MUTED
            BNE     .MUTED\1
            
            MOVE.B  #77,D0
            MOVE.B  #MUSIC,D1
            MOVE.L  #3,D2
            TRAP    #15
            
            MOVE.B  #74,D0
            LEA.L   \1,A1
            TRAP    #15
            
            MOVE.B  #77,D0
            MOVE.L  #1,D2
            TRAP    #15
            
.MUTED\1
            ENDM
            
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
