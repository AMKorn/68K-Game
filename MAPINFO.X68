; =============================================================================
; MAP INFO
; This file includes all the information regarding each of the levels of the
; game. The first part of this file has the pointers of each of the matrixes.
; Each map is formed by a 16x12 matrix with the corresponding values of each
; cell it represents.
; Values:   - 1 : Ground cell
;           - 2 : Portal location. Note that this is where the player should
;                 start, but the player location is stored in another variable.
;                 This is because this cell is protected and should not be
;                 changed to a player-addable platform, so the '2' is only here
;                 for that purpose.
;           - 3 : Player addable platform. No level should have one of these
;                 when initialized, insted this value is only used during the
;                 update.
;           - 4 : End of level.
; Each level must also be accompanied with its correspondent level information,
; which for now consists of only the player location start (marked with STARTN)
; For ease of understanding, it is specified as 
;           STARTN = (Xcell)*GRIDWTH,(Ycell)*GRIDHGT+PLRDIM
; This is easily utilized with the subroutine PLRINIT by MOVE.L STARTN,D1
; =============================================================================

LEVEL0      DC.L    0                       ; Just so I don't have to start
                                            ; counting the levels on 0. 
LEVEL1      DC.L    MAPINFO1
LEVEL2      DC.L    MAPINFO2

; --- Level matrixes ----------------------------------------------------------

MAPINFO1    DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
            DC.B    1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,1,1,1,0,0,2,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
            DS.W    0                          ; Better safe than sorry
START1      DC.W    7*GRIDWTH,8*GRIDHGT+PLRDIM 

MAPINFO2    DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
            DS.W    0                          
START2      DC.W    7*GRIDWTH,8*GRIDHGT+PLRDIM 

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
