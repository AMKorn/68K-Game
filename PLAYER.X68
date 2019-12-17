*===============================================================================
* PLAYER
*===============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT     - D1.L: The player position, with 2 most significant Bytes being
;             on X axis and least significant in Y axis
; OUTPUT    - None
; MODIFIES  - D1.L
; -----------------------------------------------------------------------------
            ;MOVE.L  D1,-(A7)
            MOVE.W  D1,PLRPOSY
            LSR.L   #8,D1
            LSR.L   #8,D1
            MOVE.W  D1,PLRPOSX
            ;MOVE.L  (A7)+,D1
            
            RTS
            
; -----------------------------------------------------------------------------
PLRUPD
; Updates the player location, calculates collisions and adds platforms if
; DOWN is pressed.
; Input     - None, reads KBDVAL, KBDEDGE and CURRLVL
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A0,-(A7)
            
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL0,A0
            ADD.L   D1,A0
            MOVE.L  (A0),A0                 ; A0 now has the address of the
                                            ; matrix of the level.
            
            MOVE.W  PLRPOSX,D2
            MOVE.W  PLRPOSY,D3
            MOVE.W  PLRSPDY,D4
            
            GETCELL 2,PLRDIM/2,3,-PLRDIM/2,0
            JSR     GETGRIDVAL
            CMP.B   #4,D1                   ; If player is on the goal
            BNE     .PLAT
            MOVE.B  CURRLVL,D1
            ADD.B   #1,D1                   ; We add one to the current level
            MOVE.B  D1,CURRLVL
            BRA     .END                    ; And go directly to the end
            
            ; --- Platform placement ------------------------------------------
.PLAT       
            MOVE.B  KBDVAL,D0
            MOVE.B  KBDEDGE,D1
            
            BTST.L  #KBDBITF1,D1            ; Checks if space has been pressed
            BEQ     .NOPLAT
            MOVE.W  D0,-(A7)
            MOVE.B  D1,-(A7)
            GETCELL 2,PLRDIM/2,3,-PLRDIM/2,0
            JSR     GETGRIDVAL
            CMP.B   #0,D1                   ; Checks if the player is on air
            BNE    .NOPLATREG               ; and if he is, places platform
            MOVE.B  #3,D1
            JSR     SETGRIDVAL
            SUBQ.B  #1,D0
            CLR.L   D3
            MOVE.B  D0,D3
            MULU    #GRIDHGT,D3
            ADD.W   #PLRDIM,D3
            LSR     #8,D0
            CLR.L   D2
            MOVE.B  D0,D2
            MULU    #GRIDWTH,D2
            
            GETCELL 2,PLRDIM/2,3,-PLRDIM/2,0
            JSR     GETGRIDVAL
            CMP.B   #0,D1                   ; If after the placement, the
            BEQ     .NOPLATREG              ; character is not on the air, 
            MOVE.L  (XGRIDS)*(YGRIDS)(A0),D1 ; the player is moved to the 
            JSR     PLRINIT                 ; starting point of the level.
            MOVE.W  PLRPOSX,D2
            MOVE.W  PLRPOSY,D3
            
.NOPLATREG  ; No platform placed but registers must be restored
            MOVE.B  (A7)+,D1
            MOVE.W  (A7)+,D0

.NOPLAT
            
            ; --- Horizontal movement -----------------------------------------
            
            BTST.L  #KBDBITLF,D0
            BEQ     .NOLF
            SUB.W   #PLRSPDX,D2
            MOVE.B  #LEFT,DIR
            
.NOLF       BTST.L  #KBDBITRT,D0
            BEQ     .H_COLL
            ADD.W   #PLRSPDX,D2
            MOVE.B  #RIGHT,DIR
            
            ; --- Horizontal collisions ---------------------------------------
            
.H_COLL     
            
            ; -- Left Collisions (posX) --
            
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
            BRA     .X_OOB
            
            ; -- Right Collisions (posX+plrDim) --
            
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
            
            ; -- Horizontal Out-Of-Bounds --
            
.X_OOB      CMP.W   #0,D2                   ; Checks if OOB (Out-of-Bounds)
            BGT     .NOTOOB1                ; on the X-axis
            MOVE.W  #0,D2
            BRA     .VERT
.NOTOOB1    CMP.W   #(SCRWIDTH-PLRDIM),D2
            BLT     .VERT
            MOVE.W  #(SCRWIDTH-PLRDIM),D2

            ; --- Vertical movement -------------------------------------------

.VERT       MOVE.B  KBDVAL,D0
            MOVE.B  KBDEDGE,D1

            BTST.L  #KBDBITUP,D1            ; Checks if UP was pressed on EDGE
            BEQ     .NOEDGE

            ; -- Is there a block up? --

            GETCELL 2,0,3,-PLRDIM,0
            SUBQ.W  #1,D0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .NOEDGE
            CMP.B   #3,D1
            BEQ     .NOEDGE
            
            GETCELL 2,PLRDIM,3,-PLRDIM,0
            SUBQ.W  #1,D0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .NOEDGE
            CMP.B   #3,D1
            BEQ     .NOEDGE
            
            ; -- Is the player on ground? --
            
            GETCELL 2,0,3,0,0
            ADDQ.W  #1,D0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .JUMP
            CMP.B   #3,D1
            BEQ     .JUMP
            
            GETCELL 2,PLRDIM,3,0,0
            ADDQ.W  #1,D0
            JSR     GETGRIDVAL
            CMP.B   #1,D1
            BEQ     .JUMP
            CMP.B   #3,D1
            BNE     .NOEDGE
.JUMP       MOVE.W  #IMPULSE,D4
            BRA     .NOGRAV
            
.NOEDGE     ;BTST.L  #KBDBITUP,D0           **   Uncomment this section   **
            ;BNE     .NOGRAV                ** to have buggy gradual jump **
            CMP.W   #MAXSPD,D4
            BEQ     .NOGRAV
            ADD.W   #GRAVITY,D4
            
.NOGRAV     ADD.W   D4,D3                   ; Fall (PLRPOSY+PLRSPDY)

            ; --- Collisions --------------------------------------------------
            
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
            
.END        MOVE.W  D2,PLRPOSX
            MOVE.W  D3,PLRPOSY
            MOVE.W  D4,PLRSPDY
            MOVEM.L (A7)+,D0-D4/A0
            RTS

; -----------------------------------------------------------------------------
PLRPLOT
; Plots the player
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            MOVE.L  #BLACK,D1
            MOVE.B  #80,D0
            TRAP    #15                     ; Set pen color black
            MOVE.L  #GREEN,D1
            MOVE.B  #81,D0                  ; Set color green
            TRAP    #15
            MOVE.B  #87,D0
            MOVE.W  PLRPOSX,D1              ; Left X is the player posX
            MOVE.W  PLRPOSY,D2
            SUB.W   #PLRDIM,D2              ; Upper Y is posY-dimensions
            MOVE.W  PLRPOSX,D3
            ADD.W   #PLRDIM,D3              ; Right X
            MOVE.W  PLRPOSY,D4              ; Lower Y
            TRAP    #15
            
            ; Draw the eyes
            MOVE.L  #BLACK,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.B  DIR,D0
            CMP.B   #LEFT,D0
            BEQ     .LOOK_LEFT
            
            MOVE.B  #88,D0
            MOVE.W  PLRPOSX,D1
            ADD.W   #15,D1
            MOVE.W  D1,D3
            ADD.W   #11,D3
            ADDQ.W  #5,D2
            MOVE.W  D2,D4
            ADD.W   #16,D4
            TRAP    #15
            
            ADD.W   #14,D1
            ADD.W   #14,D3
            TRAP    #15
            BRA     .END
            
.LOOK_LEFT  MOVE.B  #88,D0
            SUB.W   #15,D3
            MOVE.W  D3,D1
            SUB.W   #11,D1
            ADDQ.W  #5,D2
            MOVE.W  D2,D4
            ADD.W   #16,D4
            TRAP    #15
            
            SUB.W   #14,D1
            SUB.W   #14,D3
            TRAP    #15
.END
            MOVEM.L (A7)+,D0-D4
            RTS





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
