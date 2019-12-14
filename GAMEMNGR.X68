; =============================================================================
; GAME MANAGER
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
.PLAYING    JSR     PLRUPD
            JSR     MAPUPD
            
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
            
.END        RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
