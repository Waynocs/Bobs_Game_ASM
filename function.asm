CLEAR_SCREEN:
                

                mov ax, 0600h
                mov bh, 00h
                mov cx, 0
                mov dx, 184fh
                int 10h

RET

dessin_pagaie:
            mov CX, pagaiex  
            mov DX, pagaiey 

            dessin_pagaie_HORIZONTAL:
            mov AH, 0Ch   ;set the configuration to writing a pixel 
            mov AL, 15   ;choose a white as color
            mov BH, 00h   ;set the page number
            int 10h       ;execute the configuration

            inc CX        ; CX = CX + 1
            mov AX, CX    
            SUB AX, pagaiex
            CMP AX, largeur_pagaie
            JNG dessin_pagaie_HORIZONTAL

            mov CX, pagaiex   
            inc DX        ;we advance one line

            mov AX, DX    
            SUB AX, pagaiey
            CMP AX, hauteur_pagaie
            JNG dessin_pagaie_HORIZONTAL
RET

dessin_bob:  
            mov CX, Bobx  ;set the initial  column (X)  
            mov DX, Boby  ;set the initial  line (Y)

            dessin_bob_HORIZONTAL:
    ;Draw pixel-------------------------------------------------------------------------------
            mov AH, 0Ch   ;set the configuration to writing a pixel 
            mov AL, 13   ;choose a pink as color
            mov BH, 00h   ;set the page number
            int 10h       ;execute the configuration
    ;-----------------------------------------------

    ;Increment the column by 1------------------------------------------------
            inc CX        ; CX = CX + 1
            mov AX, CX    ; CX - Bobx > BALL_SIZE (Y -> We go to the next line,N -> go to the next column)
            SUB AX, Bobx
            CMP AX, Bob_size
            JNG dessin_bob_HORIZONTAL

            mov CX, Bobx  ;the CX register goes back to the initial column 
            inc DX        ;we advance one line

            mov AX, DX    ; DX - Boby > BALL_SIZE (Y -> We exit this procedure,N -> go to the next line)
            SUB AX, Boby
            CMP AX, Bob_size
            JNG dessin_bob_HORIZONTAL
RET
  
bouger_bob:
                mov AX, vitesse_bobx    
                ADD Bobx, AX                ;move bob horizontally

                
                mov AX, pagaiey
                cmp AX, Boby
                jl next_move_bob
                add AX, hauteur_pagaie
                cmp AX, Boby
                jg next_move_bob
                mov BX, Bobx
                add BX, Bob_size
                cmp pagaiex, BX
                jl next_move_bob
                
               
            next_move_bob:
                mov AX, rebond_map
                CMP Bobx, AX               ;Bobx < 0 + rebond_map (Y -> collided)
                JL vitesse_inverse_bobx

                mov AX, largeur_map
                sub AX, Bob_size
                sub AX, rebond_map
                CMP Bobx, AX                ;Bobx > largeur_map - Bob_Size - rebond_map (Y -> collided)
                JG vitesse_inverse_bobx
                

                mov AX, vitesse_boby     
                ADD Boby, AX                ;move bob vertically

                mov AX, rebond_map
                CMP Boby, AX               ;Boby < 0 + rebond_map (Y -> collided)
                JL vitesse_inverse_boby
                
               

                mov AX, hauteur_map
                sub AX, Bob_size
                sub AX, rebond_map
                CMP Boby, AX
                JG vitesse_inverse_boby          ;Boby > hauteur_map - Bob_SIZE - rebond_map (Y -> collided)
                


                
            
                
                
;---------------------------
                
                

                

                ; ajout d'un label ici pour revenir a la fin de la procedure
        endbouger_bob:
RET

      

      
        
 
vitesse_inverse_boby: 
    NEG vitesse_boby    
   
    ;jump pour retourner a la fin de de la procedure au dessus
    ;(pour eviter toutes erreurs possible en continuant les verifications au dessus)
jmp endbouger_bob

vitesse_inverse_bobx:
    NEG vitesse_bobx
    ADD d1, 1
  
    
    ;jump pour retourner a la fin de de la procedure au dessus
    ;(pour eviter toutes erreurs possible en continuant les verifications au dessus)
jmp endbouger_bob

        ;miss count--------------------------
    PRINT:           
      
    ;initilize count 
    mov cx,0 
    mov dx,0 
    label1: 
        ; if ax is zero 
        cmp ax,0 
        je print1       
          
        ;initilize bx to 10 
        mov bx,10         
          
        ; extract the last digit 
        div bx                   
          
        ;push it in the stack 
        push dx               
          
        ;increment the count 
        inc cx               
          
        ;set dx to 0  
        xor dx,dx 
        jmp label1 
    print1: 
        ;check if count  
        ;is greater than zero 
        cmp cx,0 
        je exitprint
          
        ;pop the top of stack 
        pop dx 
          
        ;add 48 so that it  
        ;represents the ASCII 
        ;value of digits 
        add dx,48 
          
        ;interuppt to print a 
        ;character 
        mov ah,02h 
        int 21h 
          
        ;decrease the count 
        dec cx 
        jmp print1 
exitprint: 
ret 
