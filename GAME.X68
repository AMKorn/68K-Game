; =============================================================================
; GAME BASE CODE
; The game managers subroutines. These subroutines are not considered
; library subroutines, as they are the core of the program. As such, they do
; not restore registers because there is no need to do so.
; =============================================================================

; -----------------------------------------------------------------------------
GAMEINIT
; Initializes the game by starting the music and initializing the state as
; MAINMENU.
; Input     - None
; Output    - None
; Modifies  - SONG, CURRSTA and whichever registry it needs.
; -----------------------------------------------------------------------------
            ; Song management
            LEA.L   MUSMENU,A1              ; Loads the directory of the song
            MOVE.B  #71,D0                  ; into A1
            TRAP    #15
            MOVE.B  D1,SONG
            MOVE.B  #76,D0                  ; Plays the song in a loop
            MOVE.L  #1,D2                  
            TRAP    #15
            
            MOVE.B  #MAINMENU,CURRSTA       ; State = Main Menu
            MOVE.B  #MENUPLAY,SELECT        ; Locates the selection on
                                            ; the Start option
            RTS
            
; -----------------------------------------------------------------------------
GAMEUPD
; Checks current the state of the game and calls the update subroutine
; according to each state.
; Input     - None, reads KBDEDGE and CURRSTA
; Output    - None.
; Modifies  - CURRSTA and whichever registry it needs.
; -----------------------------------------------------------------------------
            CLR.L   D1
            MOVE.B  CURRSTA,D1
            CMP.B   #MAINMENU,D1 
            BNE     .PLAYING
            
            ; Current State: Menu
            JSR     MENUUPD
            BRA     .END
            
            ; Current State: Playing
.PLAYING    
            ; ------- TEMPORARY CODE --------
            MOVE.B  KBDEDGE,D1
            BTST.L  #KBDBITPS,D1
            BEQ     .CONT
            MOVE.B  PLRLVS,D1
            SUBQ.B  #1,D1
            MOVE.B  D1,PLRLVS
.CONT       
            ; ------- END TEMPORARY CODE ----

            JSR     LVLCHANGE
            JSR     PLRUPD
            JSR     MAPUPD
            JSR     AGLUPD
            
.END
            RTS
            
; -----------------------------------------------------------------------------
GAMEPLOT
; Input     - None, reads CURRSTA
; Output    - None
; Modifies  - Whichever registry it needs.
; -----------------------------------------------------------------------------
            CLR.L   D1
            MOVE.B  CURRSTA,D1
            CMP.B   #MAINMENU,D1
            BNE     .PLAYING
            JSR     MENUPLOT
            BRA     .END
            
.PLAYING    JSR     MAPPLOT
            JSR     PLRPLOT
            JSR     AGLPLOT
            
.END        RTS

; =============================================================================
; GENERAL SUBROUTINES
; Subroutines which are used in two or more occasions which do not fit in any
; other file.
; =============================================================================

; -----------------------------------------------------------------------------
LVLCHANGE
; Checks if the player is on the CURRLVL's endgoal and changes level if it is.
; Input     - None
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL0,A0
            ADD.L   D1,A0
            MOVE.L  (A0),A0                 ; A0 now has the address of the
                                            ; matrix of the level.
            
            MOVE.W  PLRPOSX,D2
            MOVE.W  PLRPOSY,D3
            
            GETCELL 2,PLRDIM/2,3,-PLRDIM/2,0
            JSR     GETGRIDVAL
            CMP.B   #LVLGOAL,D1             ; If player is on the goal
            BNE     .END
            MOVE.B  CURRLVL,D1
            ADD.B   #1,D1                   ; We add one to the current level
            MOVE.B  D1,CURRLVL
            JSR     KILLALL
            JSR     MAPINIT
.END        RTS

; -----------------------------------------------------------------------------
HORCOLL
; Subroutine to calculate the horizontal collisions of an entity -agent or 
; player-, be it either with in-game walls or the side of the window.
; Input     - D2.W : The uncorrected X coordinate of the entity's position.
;           - D3.W : The uncorrected Y coordinate of the entity's position.
;           - Reads CURRLVL
; Output    - D2.W : The corrected X coordinate of the entity's position.
;           - D4.B : Set to 1 if correction was made. (Useless for player,
;                    but needed for changing direction of enemies).
; Modifies  - Nothing, except the output.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
            
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL0,A0
            ADD.L   D1,A0
            MOVE.L  (A0),A0                 ; A0 now has the address of the
                                            ; matrix of the level.

            
            ; -- Left Collisions (entityX) --
            
            GETCELL 2,0,3,0,0               ; get the cell of lower left corner
            JSR     GETGRIDVAL              ; from the character
            CMP.B   #1,D1
            BEQ     .L_COLL
            CMP.B   #3,D1
            BEQ     .L_COLL
            
            GETCELL 2,0,3,-PLRDIM,0         ; get the cell of upper left corner
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .L_COLL
            CMP.B   #3,D1
            BNE     .RGTCOLL
            
.L_COLL     LSR.L   #8,D0                   ; if one of them is on a ground cell
            ADDQ.W  #1,D0                   ; we move to the right cell 
            MULU.W  #GRIDWTH,D0
            MOVE    D0,D2
            MOVE.B  #1,D4
            BRA     .X_OOB
            
            ; -- Right Collisions (entityX+plrDim) --
            
.RGTCOLL    GETCELL 2,PLRDIM,3,0,0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .R_COLL
            CMP.B   #3,D1
            BEQ     .R_COLL
            
            GETCELL 2,PLRDIM,3,-PLRDIM,0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .R_COLL
            CMP.B   #3,D1
            BNE     .X_OOB
            
.R_COLL     LSR.L   #8,D0                   ; if one of them is on a ground cell
            SUBQ.W  #1,D0                   ; we move to the left cell
            MULU    #GRIDWTH,D0
            MOVE    D0,D2
            MOVE.B  #1,D4
            
            ; -- Horizontal Out-Of-Bounds --
            
.X_OOB      CMP.W   #0,D2                   ; Checks if OOB (Out-of-Bounds)
            BGT     .NOTOOB1                ; on the X-axis
            MOVE.W  #0,D2
            MOVE.B  #1,D4
            BRA     .END
.NOTOOB1    CMP.W   #(SCRWIDTH-PLRDIM),D2
            BLT     .END
            MOVE.W  #(SCRWIDTH-PLRDIM),D2
            MOVE.B  #1,D4
            
.END        MOVEM.L (A7)+,D0-D1/A0
            RTS
            
; -----------------------------------------------------------------------------
VERCOLL
; Subroutine to calculate the vertical collisions of an entity -agent or 
; player-, be it either with in-game walls or the side of the window.
; Input     - D2.W : The uncorrected X coordinate of the entity's position.
;           - D3.W : The uncorrected Y coordinate of the entity's position.
;           - D4.W : The entity's vertical speed.
;           - Reads CURRLVL
; Output    - D3.W : The corrected Y coordinate of the entity's position.
;           - D4.W : Cleared if the entity is on the ground (used for Y speed)
; Modifies  - None, except the output.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
            
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL0,A0
            ADD.L   D1,A0
            MOVE.L  (A0),A0                 ; A0 now has the address of the
                                            ; matrix of the level.

            
            * I know this is awful, but just in case it stays like this in the
            * final version, I tried replicating the same as what I did with the
            * horizontal collisions and it went terribly wrong. I'll try to fix
            * it if I can but it is not a priority.
            
            ; -- Lower Left Corner (posX,posY) --
            
            GETCELL 2,0,3,0,0
            JSR     GETGRIDVAL
            CMP.B   #1,D1                   ; If lower left cell is ground
            BEQ     .CONTLL
            CMP.B   #3,D1
            BNE     .LRCORNER
.CONTLL     CLR.W   D3
            MOVE.B  D0,D3
            SUBQ.B  #1,D3
            MULU.W  #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            CLR.W   D4
            BRA     .ULCORNER
            
            ; -- Lower Rigth Corner (posX+plrDim,posY) --
            
.LRCORNER   GETCELL 2,PLRDIM,3,0,0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .CONTLR
            CMP.B   #3,D1
            BNE     .ULCORNER
.CONTLR     CLR.W   D3
            MOVE.B  D0,D3
            SUBQ.W  #1,D3
            MULU.W  #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            CLR.W   D4

            ; -- Upper Left Corner (posX,posY-plrDim) --
            
.ULCORNER   GETCELL 2,0,3,-PLRDIM,0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .CONTUL
            CMP.B   #3,D1
            BNE     .URCORNER
.CONTUL     CLR.W   D3
            MOVE.B  D0,D3
            ADDQ.W  #1,D3
            MULU    #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            CLR.W   D4
            BRA     .Y_OOB
            
            ; -- Upper Right Corner (posX+plrDim,posY-plrDim) --
            
.URCORNER   GETCELL 2,PLRDIM,3,-PLRDIM,0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .CONTUR
            CMP.B   #3,D1
            BNE     .Y_OOB
.CONTUR     CLR.W   D3
            MOVE.B  D0,D3
            ADDQ.W  #1,D3
            MULU    #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            CLR.W   D4

            ; -- Vertical Out-Of-Bounds --
            
.Y_OOB      CMP.W   #PLRDIM,D3              ; Checks if OOB on Y-axis
            BGT     .NOTOOB2
            MOVE.W  #PLRDIM,D3
            BRA     .END
.NOTOOB2    CMP.W   #SCRHEIGH,D3
            BLT     .END
            MOVE.W  #SCRHEIGH,D3

.END        MOVEM.L (A7)+,D0-D1/A0
            RTS

; -----------------------------------------------------------------------------
CHECKCOL
; Checks the collisions between two elements. Code extracted from
; https://github.com/aburguera/YAP/blob/master/UTIL.X68 - line 54
; Input     - D0.W : X coordinate of first element
;           - D1.W : Y coordinate of first element
;           - D2.W : X coordinate of second element
;           - D3.W : Y coordinate of second element
;           - D4.W : Width of first element
;           - D5.W : Width of second element
;           - D6.W : Height of first element
;           - D7.W : Width of second element
; Output    - D0.B : Set to FF if there is collision, otherwise cleared
; Modifies  - None but the output
; -----------------------------------------------------------------------------
            MOVEM.W D4-D7,-(A7)
            ADD.W   D0,D4
            CMP.W   D2,D4
            BLE     .NOCOL
            ADD.W   D2,D5
            CMP.W   D0,D5
            BLE     .NOCOL
            ADD.W   D1,D6
            CMP.W   D3,D6
            BLE     .NOCOL
            ADD.W   D3,D7
            CMP.W   D1,D7
            BLE     .NOCOL
            MOVE.B  #$FF,D0
            BRA     .END
.NOCOL      CLR.B   D0
.END        MOVEM.W (A7)+,D4-D7
            RTS
            
            
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
