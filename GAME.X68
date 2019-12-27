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
            JSR     SOUNDINIT
            
            MOVE.B  #MAINMENU,CURRSTA       ; State = Main Menu
            MOVE.B  #1,SELECT               ; Locates the selection on
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
.START      CLR.L   D1
            MOVE.B  CURRSTA,D1
            CMP.B   #PLAYING,D1
            BEQ     .PLAYING
            CMP.B   #PAUSED,D1
            BEQ     .PAUSED
            CMP.B   #DEAD,D1
            BEQ     .DEAD
            CMP.B   #WINSTATE,D1
            BEQ     .WIN
            
            ; Current State: Menu
.MENU       JSR     MENUUPD
            BRA     .END
            
            ; Current State: Playing
.PLAYING    MOVE.B  KBDEDGE,D1
            BTST.L  #KBDBITPS,D1            ; If PAUSE was pressed
            BEQ     .CONT
            MOVE.B  #PAUSED,NEXSTA         ; we pause the game
            BRA     .END
            
.CONT       JSR     CHKLVLCHANGE
            JSR     PLRUPD
            JSR     MAPUPD
            JSR     AGLUPD
            BRA     .END
            
.PAUSED     JSR     PAUSEUPD
            BRA     .END

.DEAD       JSR     AGLUPD                  ; Not necessary, but cool
            JSR     DEADUPD
            BRA     .END

.WIN        JSR     WINUPD

.END        JSR     CHKSTACHANGE
            RTS
            
; -----------------------------------------------------------------------------
GAMEPLOT
; Input     - None, reads CURRSTA
; Output    - None
; Modifies  - Whichever registry it needs.
; -----------------------------------------------------------------------------
            CLR.L   D1
            MOVE.B  CURRSTA,D1
            CMP.B   #PLAYING,D1
            BEQ     .PLAYING
            CMP.B   #PAUSED,D1
            BEQ     .PAUSED
            CMP.B   #DEAD,D1
            BEQ     .DEAD
            CMP.B   #WINSTATE,D1
            BEQ     .WIN

.MENU       JSR     MENUPLOT
            BRA     .END
            
.PLAYING    JSR     MAPPLOT
            JSR     PLRPLOT
            JSR     AGLPLOT
            BRA     .END

.PAUSED     JSR     MAPPLOT
            JSR     PLRPLOT
            JSR     AGLPLOT
            JSR     PAUSEPLOT
            BRA     .END
            
.DEAD       JSR     MAPPLOT
            JSR     AGLPLOT
            JSR     DEADPLOT
            BRA     .END
            
.WIN        ;JSR     MAPPLOT
            JSR     PLRPLOT
            JSR     AGLPLOT
            JSR     WINPLOT


.END        RTS

; =============================================================================
; GENERAL SUBROUTINES
; Subroutines which are used in two or more occasions which do not fit in any
; other file.
; =============================================================================

; -----------------------------------------------------------------------------
CHKSTACHANGE
; Checks if it must change the current state of the game, and chnges the music
; accordingly.
; Input     - None
; Output    - None
; Modifies  - Whichever registry it requires
; -----------------------------------------------------------------------------
            MOVE.B  CURRSTA,D0
            MOVE.B  NEXSTA,D1
            CMP.B   D0,D1
            BEQ     .END
            MOVE.B  D1,CURRSTA
            
            ; -- Song management ----------------------------------------------
            
            CMP.B   #PAUSED,D0              ; If current state = pause and we
            BNE     .CONT                   ; change to playing we don't have
            CMP.B   #PLAYING,D1             ; to reset the music so we skip it.
            BEQ     .END
            
.CONT       CMP.B   #MAINMENU,D1
            BEQ     .MENU
            CMP.B   #PLAYING,D1
            BEQ     .PLAYING
            CMP.B   #WINSTATE,D1
            BEQ     .WIN
            CMP.B   #DEAD,D1
            BEQ     .DEAD
            BRA     .END
            
.DEAD       PLAYSNG MUSFAIL
            BRA     .END

.WIN        PLAYSNG MUSWIN
            BRA     .END

.MENU       PLAYSNG MUSMENU
            BRA     .END
            
.PLAYING    PLAYSNG MUSGAME
            
.END        RTS
            
; -----------------------------------------------------------------------------
CHKLVLCHANGE
; Checks if the player is on the CURRLVL's endgoal and changes level if it is.
; Input     - None
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL1,A0
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
            CMP.B   #NLVLS,D1               ; If the level was the last
            BNE     .NEXTLVL                
            MOVE.B  #WINSTATE,NEXSTA       ; we change the state to WINSTATE
            JSR     KILLALL
            BRA     .END
            
.NEXTLVL    MOVE.B  D1,CURRLVL
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
            LEA.L   LEVEL1,A0
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
; Output    - D3.W : The corrected Y coordinate of the entity's position, or
;                    set to $FFFF if the entity fell off the map.
;           - D4.W : Cleared if the entity is on the ground (used for Y speed)
; Modifies  - None, except the output.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
            
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL1,A0
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
.NOTOOB2    CMP.W   #SCRHEIGH+PLRDIM,D3
            BLT     .END
            MOVE.W  #$FFFF,D3
            
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
