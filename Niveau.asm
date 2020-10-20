DSEG        SEGMENT
    MESSAGE     DB      "Welcome to Bob's game" 
    L_MESSAGE   EQU     $-MESSAGE
    FAIL DB "Miss:"
    L_FAIL EQU $-FAIL
    

    Bobx DW 0A0h ;middle x(160)
    Boby DW 64h ;middle y(100)


    Bob_size DW 04h   ; size of Bob


    vitesse_bobx DW 03h ;vitesse x (horizontal)
    vitesse_boby DW 02h ;vitesse y (vertical)


    largeur_map DW 13fh   ;the width of the window  (320 pixels dont le 0)               
    hauteur_map DW 0C7h  ;the height of the window  (200 pixels dont le 0)               
    rebond_map DW 6     ;variable used to check collisions early
     

    pagaiex DW 130h ;coo x en 304
    pagaiey DW 8Ah ;coo y en 138

    largeur_pagaie DW 05h ;largeur de 5
    hauteur_pagaie DW 2Ah ;hauteur de 42

    d1 dw 0 ;Compteur mis à 0 en début de partie
    

DSEG        ENDS

            Niveau1start: 
            mov vitesse_bobx, 03h 
            mov vitesse_boby, 02h 
            mov hauteur_pagaie, 2ah 
            jmp startjeu

            Niveau2start:
            mov vitesse_bobx, 04h 
            mov vitesse_boby, 02h 
            mov hauteur_pagaie, 1Ch 
            

            startjeu:
            ; on met le mode graphique
            mov	ah, 00h 
            mov	al, 13h	
            int	10h	
            
            mov d1, 0
            mov Bobx, 0A0h ;middle x(160)
            mov Boby, 64h ;middle y(100)
            mov pagaiex, 130h ;coo x en 304
            mov pagaiey, 8Ah ;coo y en 138



            CHECK_TIME:
                  mov  cx, 0h
                  mov  dx, 06fffh
                  mov  ah, 86h
                  int  15h


                CALL CLEAR_SCREEN
                

              ;Afficher Titre-----------------------------------------------------------------
                  mov     BH, 0      ; page actuelle
                  mov     DL, 8     ; colonne actuelle
                  mov     DH, 1      ; ligne actuelle
                  mov     AH, 02     ; on change la position du curseur
                  int     10h        ; et on affiche
                  
                  MOV     BX, 0001H
                  LEA     DX, MESSAGE
                  MOV     CX, L_MESSAGE
                  MOV     AH, 40H
                  INT     21H


                  mov     BH, 0      ; page actuelle
                  mov     DL, 1     ; colonne actuelle
                  mov     DH, 23      ; ligne actuelle
                  mov     AH, 02     ; on change la position du curseur
                  int     10h        ; et on affiche
                  
                  MOV     BX, 0001H
                  LEA     DX, FAIL
                  MOV     CX, L_FAIL
                  MOV     AH, 40H
                  INT     21H




                      mov     BH, 0      ; page actuelle
                      mov     DL, 7     ; colonne actuelle
                      mov     DH, 23      ; ligne actuelle
                      mov     AH, 02     ; on change la position du curseur 
                      int     10h        ; et on affiche                 
                     ;load the value stored 
                      ; in variable d1 
                     mov ax,d1             
                     ;print the value  
                     CALL PRINT 


              ;------------------------------------------------------------------------




                CALL bouger_bob
                CALL dessin_bob
                CALL dessin_pagaie

                CMP d1, 3
                je gameover

                

                mov ah, 01h		               ; verif s'il y a eu une touche
                int 16h
                jz CHECK_TIME			           ; si pas touche CHECK_TIME


               
                MOV AH, 0H
                INT 16H
                CMP Ah, 80                   ; fleche du bas
                JE down
                CMP Ah, 72                   ; fleche du haut
                JE up
                CMP Ah, 77                   ; fleche de droite
                JE right
                CMP Ah, 75                   ; fleche de gauche
                JE left


              JMP CHECK_TIME                   ;after everything checks time again

            down:

                
                mov AX, pagaiey
                add AX, hauteur_pagaie
                cmp AX, hauteur_map
                jge CHECK_TIME
                
              
              add pagaiey, 8
            JMP CHECK_TIME 

            up: 
               
                mov AX, pagaiey
                cmp AX, 0
                jle CHECK_TIME
                

              add pagaiey, -8
            JMP CHECK_TIME

            right: 
               
                mov AX, pagaiex
                add AX, largeur_pagaie
                cmp AX, largeur_map
                jge CHECK_TIME
               

              add pagaiex, 8
            JMP CHECK_TIME

            left: 
               
                mov AX, pagaiex
                cmp AX, 0
                jle CHECK_TIME
               

              add pagaiex, -8
            JMP CHECK_TIME

            gameover:
              jmp affichermenu

           
   
   