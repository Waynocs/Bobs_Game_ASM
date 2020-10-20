            TITLE   DISPLAY - programme prototype
            .286
            

SSEG        SEGMENT STACK
            DB      32      DUP("STACK---")
SSEG        ENDS


DSEG        SEGMENT
PLAY     DB      "Play :"
L_PLAY   EQU     $-PLAY
EXIT        DB      "Exit (press E)"
L_EXIT      EQU     $-EXIT
NIV1        DB      "Level 1 (press P)"
L_NIV1      EQU     $-NIV1
NIV2        DB      "Level 2 (press space)"
L_NIV2      EQU     $-NIV2
MIAOU        DB      "HELP (press H)"
L_MIAOU      EQU     $-MIAOU
HELP    DB    "Binome: SERANO Waian - FROLIGER Robin"
L_HELP    EQU    $-HELP
RETOUR  DB "Return (press A)"
L_RETOUR EQU $-RETOUR
TOUCHE DB "Touch: use the arrow keys"
L_TOUCHE EQU $-TOUCHE
REGLE DB "Rule: don't touch the walls"
L_REGLE EQU $-REGLE
DSEG        ENDS



CSEG        SEGMENT 'CODE'
ASSUME      CS:CSEG, DS:DSEG, ES:CSEG
  %include    function.asm
%include Niveau.asm



MAIN        PROC    FAR
            PUSH    DS
            PUSH    0

           
            affichermenu:

            
            
            mov  AX, 0A000h
            mov  ES, AX     ; Beginning of VGA memory in segment 0xA000
            mov  AX, 13h    ; Mode VGA de l'affichage
            int  10h

            

            
            MOV     AX, DSEG
            MOV     DS, AX
            mov     BH, 0      ; page actuelle
            mov     DL, 1     ; collonne actuelle
            mov     DH, 1      ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, MIAOU
            MOV     CX, L_MIAOU
            MOV     AH, 40H
            INT     21H


            MOV     AX, DSEG
            MOV     DS, AX
            mov     BH, 0      ; page actuelle
            mov     DL, 15     ; collonne actuelle
            mov     DH, 5      ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, PLAY
            MOV     CX, L_PLAY
            MOV     AH, 40H
            INT     21H

            ;---------------
            MOV     AX, DSEG
            MOV     DS, AX
            mov     BH, 0      ; page actuelle
            mov     DL, 10     ; collonne actuelle
            mov     DH, 9      ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, NIV1
            MOV     CX, L_NIV1
            MOV     AH, 40H
            INT     21H
            ;---------------
            MOV     AX, DSEG
            MOV     DS, AX
            mov     BH, 0      ; page actuelle
            mov     DL, 8     ; collonne actuelle
            mov     DH, 13      ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, NIV2
            MOV     CX, L_NIV2
            MOV     AH, 40H
            INT     21H
            ;---------------
            
            


            mov     BH, 0      ; page actuelle
            mov     DL, 11     ; collonne actuelle
            mov     DH, 18     ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, EXIT
            MOV     CX, L_EXIT
            MOV     AH, 40H
            INT     21H

            
       
;soulignement Play : ----------------------------------------------------------------------
            
            mov  AL, 13
            mov  CX, 120      ; position x du point
            mov  DX, 52     ; position y du point
            mov  AH, 0Ch    ; On veut afficher un pixel
            mov  BH, 1      ; page no - critical while animating
            L1: INT 10h
            INC CX
            CMP CX, 150
            JL L1          
;------------------------------------------------------------------------------

;Soulignage Exit : -----------------------------------------------------------------------------

            mov  AL, 13
            mov  CX, 90      ; position x du point
            mov  DX, 158     ; position y du point
            mov  AH, 0Ch    ; On veut afficher un pixel
            mov  BH, 1      ; page no - critical while animating
            L2: INT 10h           
            INC CX
            CMP CX, 120
            JL L2
           
;-----------------------------------------------------------


            loopaskkey:               
                
                mov ah, 00h
                int 16h

                cmp ah, 25 ;P
                je Niveau1start
                cmp ah, 57 ;space
                je Niveau2start
                cmp ah, 35 ;H
                je helpsomeone
                

                cmp ah, 18 ;E
                je leavehey
            jmp loopaskkey

            leavehey: 
              MOV AH, 4CH
               MOV AL, 00 ;your return code.
              INT 21H

            
            helpsomeone:
            mov  AX, 0A000h
            mov  ES, AX     ; Beginning of VGA memory in segment 0xA000
            mov  AX, 13h    ; Mode VGA de l'affichage
            int  10h

            MOV     AX, DSEG
            MOV     DS, AX
            mov     BH, 0      ; page actuelle
            mov     DL, 1     ; collonne actuelle
            mov     DH, 2      ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, HELP
            MOV     CX, L_HELP
            MOV     AH, 40H
            INT     21H

            MOV     AX, DSEG
            MOV     DS, AX
            mov     BH, 0      ; page actuelle
            mov     DL, 20     ; collonne actuelle
            mov     DH, 20      ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, RETOUR
            MOV     CX, L_RETOUR
            MOV     AH, 40H
            INT     21H

            MOV     AX, DSEG
            MOV     DS, AX
            mov     BH, 0      ; page actuelle
            mov     DL, 1     ; collonne actuelle
            mov     DH, 8      ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, TOUCHE
            MOV     CX, L_TOUCHE
            MOV     AH, 40H
            INT     21H

            MOV     AX, DSEG
            MOV     DS, AX
            mov     BH, 0      ; page actuelle
            mov     DL, 1     ; collonne actuelle
            mov     DH, 13      ; ligne actuelle
            mov     AH, 02     ; on change la position du curseur
            int     10h        ; et on affiche
            MOV     BX, 0001H
            LEA     DX, REGLE
            MOV     CX, L_REGLE
            MOV     AH, 40H
            INT     21H

;souligner binome----
            mov  AL, 13
            mov  CX, 8      ; position x du point
            mov  DX, 28     ; position y du point
            mov  AH, 0Ch    ; On veut afficher un pixel
            mov  BH, 1      ; page no - critical while animating
            L3: INT 10h           
            INC CX
            CMP CX, 55
            JL L3
;souligner return----
            mov  AL, 13
            mov  CX, 160      ; position x du point
            mov  DX, 172     ; position y du point
            mov  AH, 0Ch    ; On veut afficher un pixel
            mov  BH, 1      ; page no - critical while animating
            L4: INT 10h           
            INC CX
            CMP CX, 205
            JL L4



            loopaskkey2:               
                
                mov ah, 00h
                int 16h

                
                cmp ah, 30 ;A
                je affichermenu
            jmp loopaskkey2
            


            
            
             

            MAIN ENDP
CSEG        ENDS
            END     MAIN