*===============================================================================
* PLAYER
*===============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT     - D1.L: The player position, with 2 most significant Bytes being
;             on X axis and least significant on Y axis
; OUTPUT    - None
; MODIFIES  - None
; -----------------------------------------------------------------------------
            MOVE.W  D1,PLRPOSY
            SWAP    D1
            MOVE.W  D1,PLRPOSX
            SWAP    D1                      ; Just to reset it.
            
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
            LEA.L   LEVEL1,A0
            ADD.L   D1,A0
            MOVE.L  (A0),A0                 ; A0 now has the address of the
                                            ; matrix of the level.
            
            MOVE.B  PLRLVS,D1
            CMP.B   #0,D1
            BNE     .NOTDEAD
            MOVE.B  #DEAD,CURRSTA
            BRA     .END
            
.NOTDEAD    MOVE.W  PLRPOSX,D2
            MOVE.W  PLRPOSY,D3

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
            SUBLIFE
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
                        
.H_COLL     JSR     HORCOLL                 ; Horizontal collisions

            ; --- Vertical movement -------------------------------------------

            MOVE.W  PLRSPDY,D4
            
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

            JSR     VERCOLL                 ; Vertical Collisions
            CMP.W   #$FFFF,D3
            BNE     .END
            MOVE.B  #DEAD,CURRSTA
            
.END        MOVE.W  D2,PLRPOSX
            MOVE.W  D3,PLRPOSY
            MOVE.W  D4,PLRSPDY
            MOVEM.L (A7)+,D0-D4/A0
            RTS

; -----------------------------------------------------------------------------
PLRPLOT
; Plots the player
; -----------------------------------------------------------------------------
            MOVEM.L D0-D5,-(A7)
            SETPEN  BLACK                   ; Set pen color black
            
            MOVE.L  #8,D0
            TRAP    #15                     ; D1.L has current time
            MOVE.L  INVFRAMES,D0
            SUB.L   D0,D1
            CMP.L   #INVTIME,D1
            BHI     .NOINV
            SETFILL L_GREEN
            BRA     .CONT
            
.NOINV      SETFILL GREEN                   ; Set color green
.CONT       MOVE.W  #87,D0
            MOVE.W  PLRPOSX,D1              ; Left X is the player posX
            MOVE.W  PLRPOSY,D2
            SUB.W   #PLRDIM,D2              ; Upper Y is posY-dimensions
            MOVE.W  PLRPOSX,D3
            ADD.W   #PLRDIM,D3              ; Right X
            MOVE.W  PLRPOSY,D4              ; Lower Y
            TRAP    #15
            
            ; Draw the eyes
            SETFILL BLACK
            
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
            BRA     .LIVES
            
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
            
            ; -- Draw the lives --
            
.LIVES      SETFILL GREEN

            MOVE.W  #10,D1                  ; Starting points
            MOVE.W  #10,D2
            MOVE.W  #20,D3
            MOVE.W  #20,D4
            MOVE.W  #88,D0
            
            CLR     D5
            MOVE.B  PLRLVS,D5            
            BEQ     .END
            SUBQ.W  #1,D5
            
.LOOP       TRAP    #15
            ADD.W   #15,D1
            ADD.W   #15,D3
            DBRA    D5,.LOOP
            
.END
            MOVEM.L (A7)+,D0-D5
            RTS

; -----------------------------------------------------------------------------
DIE
; Reinitializes the player, resets the level, kills and replaces all enemies
; and resets the player lives to STRTLIVES
; Input     - A0.L: The current level matrix pointer.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVE.B  #DEAD,PLRLVS
            RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
