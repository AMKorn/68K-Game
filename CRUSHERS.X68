; =============================================================================
; CRUSHERS
; Crushers are a special type of player-added platform which fall and can crush
; enemies. When they touch the ground, they become platforms.
; Is an agent, so all its parameters are as an index from (A0).
; It uses CLONE as agent ID
; CRUSHX(A0).L : The position of the crusher in format XXXX YYYY
; CRUSHX(A0).W : The X position of the crusher in pixels.
; CRUSHY(A0).W : The Y position of the crusher in pixels.
; CRUSH_YSPD(A0).W : The vertical speed
; =============================================================================

; -----------------------------------------------------------------------------
CRSHINIT
; Initializes the crusher according to the player position.
; Input     - A0.L : The crusher data block.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  PLRPOSX,D0              ; PLRPOSX.L includes both X and Y
                                            ; indexes
            MOVE.L  D0,CRUSHX(A0)
            MOVE.W  #0,CRUSH_YSPD(A0)
            MOVE.L  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
CRSHUPD
; Updates the crusher.
; Input     - A0.L : The crusher data block.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D2-D4,-(A7)
            MOVE.W  CRUSHX(A0),D2
            MOVE.W  CRUSHY(A0),D3
            MOVE.W  CRUSH_YSPD(A0),D4
            
            JSR     ENEMYCONTACT
            
            MOVE.L  A0,A1
            CLR.L   D1
            MOVE.B  CURRLVL,D1
            MULU    #4,D1
            LEA.L   LEVEL1,A0
            ADD.L   D1,A0
            MOVE.L  (A0),A0
            
            CMP.W   #MAXSPD,D4
            BEQ     .NOGRAV     
            ADD.W   #GRAVITY,D4
            
            
.NOGRAV     ADD.W   D4,D3
            JSR     VERCOLL
            CMP.W   #0,D4                   ; If the crusher fell,
            BNE     .NOPLAT
            GETCELL 2,PLRDIM/2,3,-PLRDIM/2,0
            JSR     GETGRIDVAL
            CMP.B   #0,D1                   ; Checks if its not on a protected
            BNE     .KILL                   ; cell and places platform.
            MOVE.B  #3,D1
            JSR     SETGRIDVAL
.KILL       MOVE.L  A1,A0
            JSR     AGLKILL
            
.NOPLAT     MOVE.L  A1,A0
            MOVE.W  D3,CRUSHY(A0)
            MOVE.W  D4,CRUSH_YSPD(A0)
            
            MOVEM.L (A7)+,D2-D4
            RTS
            
; -----------------------------------------------------------------------------
CRSHPLOT   
; Plots the crusher platform
; Input     - A0.L : The crusher data block.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            SETPEN  BLACK
            SETFILL L_GREEN
            MOVE.W  CRUSHX(A0),D1
            MOVE.W  CRUSHY(A0),D2
            MOVE.W  D1,D3
            ADD.W   #PLRDIM,D3
            MOVE.W  D2,D4
            SUB.W   #PLRDIM,D2
            MOVE.B  #87,D0
            TRAP    #15
            
            ; Draw the eyes
            SETFILL BLACK
            
            MOVE.B  #84,D0
            MOVE.W  CRUSHX(A0),D1
            ADD.W   #15,D1
            MOVE.W  D1,D3
            ADD.W   #11,D3
            ADDQ.W  #5,D2
            MOVE.W  D2,D4
            ADD.W   #16,D4
            TRAP    #15
                        
            SWAP    D2
            MOVE.W  D4,D2
            SWAP    D2
            MOVE.W  D2,D4
            SWAP    D2
            TRAP    #15
            
            ADD.W   #14,D1
            ADD.W   #14,D3
            TRAP    #15
            
            SWAP    D2
            MOVE.W  D4,D2
            SWAP    D2
            MOVE.W  D2,D4
            SWAP    D2
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4
            RTS

; -----------------------------------------------------------------------------
ADDCRSHR
; Initializes an agent as a crusher.
; Input     - None
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0/A1-A3,-(A7)
            MOVE.W  #CLONE,D0
            LEA.L   CRSHINIT,A1
            LEA.L   CRSHUPD,A2
            LEA.L   CRSHPLOT,A3
            JSR     AGLADD
            MOVEM.L (A7)+,D0/A1-A3
            RTS
            
; -----------------------------------------------------------------------------
ENEMYCONTACT
; Checks all alive enemies to see if it's in contact with any and kills it.
; Input     - A0.L : The crusher data block.
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0,-(A7)
            
            MOVE.W  CRUSHX(A0),D2
            MOVE.W  CRUSHY(A0),D3
            MOVE.W  #PLRDIM,D4
            MOVE.W  D4,D5
            MOVE.W  D5,D6
            MOVE.W  D6,D7
            
            MOVE.W  #ENEMY,D0
            JSR     DMMFRSTO
            CMP.L   #0,A0
            BEQ     .END
.LOOP       ADD.L   #8,A0                   ; A0 points to AGLUPD so we have to
            MOVE.W  ENMY_XOF(A0),D0         ; fix that
            MOVE.W  ENMY_YOF(A0),D1
            JSR     CHECKCOL
            CMP.B   #0,D0
            BEQ     .CHCKNXT
            JSR     AGLKILL
            BRA     .END
            
.CHCKNXT    MOVE.W  #ENEMY,D0
            JSR     DMMNEXTO
            CMP.L   #0,A0
            BNE     .LOOP      

.END        MOVEM.L (A7)+,D0-D7/A0
            RTS     
            
            
            
            
            

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
