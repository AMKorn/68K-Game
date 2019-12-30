; =============================================================================
; MAP INFO
; This file includes all the information regarding each of the levels of the
; game. The first part of this file has the pointers of each of the matrixes.
; They are correlative, so the numeration is useless and what matters is the
; placement, except for LEVEL1 which should always be placed first.
; Each map is formed by a 16x12 matrix with the corresponding values of each
; cell it represents.
; Values:   - 0 : Air
;           - 1 : Ground cell
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
;           - 6 : Spike that hurts you.
; Each level must also be accompanied with its correspondant level information,
; which consists of the player location start marked with STARTn and a message.
; For ease of understanding, STARTn is specified as 
;           STARTn = (Xcell)*GRIDWTH,(Ycell)*GRIDHGT+PLRDIM
; This is easily utilized with the subroutine PLRINIT by MOVE.L STARTn,D1.
; Some levels also include a message that serves as a tutorial, which the 
; subroutine MAPPLOT automatically writes on the upper left corner of the map.
; These messages are usually meant to help the player understand basic 
; mechanics.
; =============================================================================

NLVLS       EQU     6                       ; Number of levels. Should only
                                            ; be modified when adding or
                                            ; deleting levels, as the game
                                            ; WILL break otherwise (Especially
                                            ; when NLVLS is higher than the real
                                            ; number of levels). This is why
                                            ; I decided to declare it here and
                                            ; not with the other constants.
LEVEL1      DC.L    MAPINFO1
LEVEL2      DC.L    MAPINFO2
LEVEL3      DC.L    MAPINFO3
LEVEL4      DC.L    MAPINFO4
LEVEL5      DC.L    MAPINFO5
LEVEL6      DC.L    MAPINFO6

; --- Level matrixes ----------------------------------------------------------

* = TEMPLATE ==================================================================
*
*MAPINFOn    ; XGRID 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F / YGRID
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 0
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 1
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 2
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 3
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 4
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 5
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 6
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 7
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 8
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 9
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; A
*            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; B
*STARTn      DC.W    X*GRIDWTH,Y*GRIDHGT+PLRDIM
*MESSAGEn    DC.B    'Write message here',0   ||    || DC.W 0
*            DS.W    0                        || OR || ; when no message
*
* =============================================================================

MAPINFO1    ; XGRID 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F / YGRID
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 0
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 1
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 2
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 3
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 4
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 5
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 6
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 7
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 8
            DC.B    0,2,0,0,0,0,0,0,0,0,0,0,0,0,4,0 ; 9
            DC.B    1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1 ; A
            DC.B    1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1 ; B
START1      DC.W    1*GRIDWTH,9*GRIDHGT+PLRDIM
MESSAGE1    DC.B    'Use the arrows to move, up to jump',0
            DS.W    0

MAPINFO2    ; XGRID 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F / YGRID
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 0
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 1
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 2
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 3
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 4
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0 ; 5
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1 ; 6
            DC.B    0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1 ; 7
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1 ; 8
            DC.B    0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1 ; 9
            DC.B    0,2,0,0,0,0,0,0,0,0,0,0,0,1,1,1 ; A
            DC.B    1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1 ; B
START2      DC.W    1*GRIDWTH,10*GRIDHGT+PLRDIM
MESSAGE2    DC.W    0                       ; No message

MAPINFO3    ; XGRID 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F / YGRID
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 0
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 1
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 2
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 3
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0 ; 4
            DC.B    0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1 ; 5
            DC.B    0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1 ; 6
            DC.B    0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1 ; 7
            DC.B    0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1 ; 8
            DC.B    0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1 ; 9
            DC.B    0,2,0,0,0,0,0,0,0,0,1,1,1,1,1,1 ; A
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ; B
START3      DC.W    1*GRIDWTH,10*GRIDHGT+PLRDIM
MESSAGE3    DC.B    'Press Space to place a platform',0
            DS.W    0

MAPINFO4    ; XGRID 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F / YGRID
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 0
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 1
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 2
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 3
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 4
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 5
            DC.B    0,0,0,0,0,0,0,0,1,0,5,0,1,0,0,0 ; 6
            DC.B    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0 ; 7
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 8
            DC.B    0,0,1,0,5,0,1,0,0,0,0,0,0,0,4,0 ; 9
            DC.B    2,0,1,1,1,1,1,6,6,6,6,6,6,1,1,1 ; A
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ; B
START4      DC.W    0*GRIDWTH,10*GRIDHGT+PLRDIM
MESSAGE4    DC.B    'Avoid the bad guys, and spikes!',0
            DS.W    0

MAPINFO5    ; XGRID 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F / YGRID
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 0
            DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 1
            DC.B    0,5,0,0,0,0,0,0,0,0,0,0,2,0,0,0 ; 2
            DC.B    1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1 ; 3
            DC.B    1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1 ; 4
            DC.B    1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1 ; 5
            DC.B    1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1 ; 6
            DC.B    1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1 ; 7
            DC.B    1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 8
            DC.B    1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0 ; 9
            DC.B    1,1,0,0,1,0,0,0,0,0,0,0,0,4,0,0 ; A
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ; B
START5      DC.W    12*GRIDWTH,2*GRIDHGT+PLRDIM
MESSAGE5    DC.B    'Press SHIFT to place a falling, enemy-crushing platform',0
            DS.W    0

MAPINFO6    ; XGRID 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F / YGRID
            DC.B    0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1 ; 0
            DC.B    0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1 ; 1
            DC.B    0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1 ; 2
            DC.B    0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1 ; 3
            DC.B    0,2,0,0,0,1,1,1,1,1,1,1,1,1,1,1 ; 4
            DC.B    1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1 ; 5
            DC.B    1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1 ; 6
            DC.B    1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0 ; 7
            DC.B    1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0 ; 8
            DC.B    1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0 ; 9
            DC.B    1,1,1,0,0,5,0,1,0,0,0,0,0,4,0,0 ; A
            DC.B    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ; B
START6      DC.W    1*GRIDWTH,4*GRIDHGT+PLRDIM
MESSAGE6    DC.B    'If you get trapped, press down to delete your platforms',0
            DS.W    0














*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
