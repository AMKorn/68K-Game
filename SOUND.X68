; =============================================================================
; SOUND
; =============================================================================

; -----------------------------------------------------------------------------
SOUNDINIT
; Initializes all sounds needed during the game using DirectX player.
; Input     - None
; Output    - None
; Modifies  - None
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)

            ; Song management
            LEA.L   MUSMENU,A1              ; Loads the directory of the song
            MOVE.B  #74,D0                  ; into A1
            MOVE.B  #MUSIC,D1
            TRAP    #15
            
            LEA.L   CRSHFXDIR,A1
            MOVE.B  #74,D0
            MOVE.B  #CRSHFX,D1
            TRAP    #15
            
            LEA.L   JMPFXDIR,A1
            MOVE.B  #74,D0
            MOVE.B  #JMPFX,D1
            TRAP    #15
            
            LEA.L   HURTFXDIR,A1
            MOVE.B  #74,D0
            MOVE.B  #HURTFX,D1
            TRAP    #15
            
            MOVE.B  #77,D0                  ; Plays the song in a loop
            MOVE.B  #MUSIC,D1
            MOVE.L  #1,D2
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D2/A1
            RTS
            



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
