; =============================================================================
; MAP INFO
; This file includes all the information regarding each of the levels of the
; game. The first part of this file has the pointers of each of the matrixes.
; They are correlative, so the numeration is useless and what matters is the
; placement.
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
;           - 5 : Enemy
; Each level must also be accompanied with its correspondant level information,
; which for now consists of only the player location start (marked with STARTn)
; For ease of understanding, it is specified as 
;           STARTn = (Xcell)*GRIDWTH,(Ycell)*GRIDHGT+PLRDIM
; This is easily utilized with the subroutine PLRINIT by MOVE.L STARTn,D1
; =============================================================================

NLVLS       EQU     2                       ; Number of levels. Should only
                                            ; be modified when adding or
                                            ; deleting levels, as the game
                                            ; WILL break otherwise. This is why
                                            ; I decided to declare it here and
                                            ; not with the other constants.

LEVEL0      DC.L    0                       ; Just so I don't have to start
                                            ; counting the levels on 0. 
LEVEL1      DC.L    MAPINFO1
LEVEL2      DC.L    MAPINFO2

; --- Level matrixes ----------------------------------------------------------

            ; XGRID 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F / YGRID
MAPINFO1    DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ; 0
            DC.B    1,4,0,0,0,0,0,0,0,0,0,5,0,0,0,1 ; 1
            DC.B    1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1 ; 2
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 ; 3
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 ; 4
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 ; 5
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 ; 6
            DC.B    1,0,5,0,0,0,0,0,0,0,0,0,0,0,0,1 ; 7
            DC.B    1,1,1,1,1,0,0,2,0,0,0,0,0,0,0,1 ; 8
            DC.B    1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1 ; 9
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,5,0,0,1 ; A
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ; B
            DS.W    0                          ; Better safe than sorry
START1      DC.W    7*GRIDWTH,8*GRIDHGT+PLRDIM 

MAPINFO2    DC.B    1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
            DC.B    1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,1
            DC.B    1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1
            DC.B    1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
            DC.B    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
            DS.W    0                          
START2      DC.W    1*GRIDWTH,1*GRIDHGT+PLRDIM 






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
