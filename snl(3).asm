jumps
IDEAL
MODEL small
STACK 100h
DATASEG
macro playerWon playerColor; used to draw winning page
local winnerBlue, winnerRed, mouth, hand1, hand2, leg1, leg2, WaitForData2;| allow labels inside a macro
push 160        ;|
push 29         ;|
push 153        ;|drawing player at
push 22         ;|the last block
push playerColor;|
call DrawPlayer ;|

delay 3;|giving them time to see that they won

mov ax, 13h ;|re entering graphic
int 16      ;|mode to clear screen

mov  dl, 0  ;Column                ;|
mov  dh, 5   ;Row                  ;|
mov bh, 0                          ;|
mov  ah, 02h  ;SetCursorPosition   ;|
int  10h                           ;|displaying the end msg
                                   ;|on screen
mov dx,offset endingMsg            ;|
mov ah,09h                         ;|
int 21h                            ;|

mov  dl, 5  ;Column                ;|
mov  dh, 8   ;Row                  ;|
mov bh, 0                          ;|
mov  ah, 02h  ;SetCursorPosition   ;|
int  10h                           ;|displaying the winner msg
                                   ;|on screen
mov dx,offset winnerMsg            ;|
mov ah,09h                         ;|
int 21h                            ;|

mov  dl, 0  ;Column                ;|
mov  dh, 16  ;Row                  ;|
mov bh, 0                          ;|
mov  ah, 02h  ;SetCursorPosition   ;|
int  10h                           ;|displaying the restart msg
                                   ;|on screen
mov dx,offset restart              ;|
mov ah,09h                         ;|
int 21h                            ;|


push 240        ;|
push 100        ;|
push 220        ;|drawing winning player 
push 80         ;|next to the ending msg
push playerColor;|
call DrawPlayer ;|


;eye1          ;|
mov cx, 227    ;|
mov dx, 82     ;|
mov al, white  ;|
mov ah, 12     ;|
int 16         ;|adding eyes to te winner player
;eye2          ;|
mov cx, 233    ;|
mov al, white  ;|
mov ah, 12     ;|
int 16         ;|

mov cx, 227    ;|
mov dx, 95     ;|
mouth:         ;|     
mov al, white  ;|
mov ah, 12     ;|adding mouth to winner player
int 16         ;|
inc cx         ;|
cmp cx, 233    ;|
jne mouth      ;|

mov cx, 219   ;|
mov dx, 85    ;|
hand1:        ;|
mov al, white ;|
mov ah, 12    ;|
int 16        ;|
dec cx        ;|
inc dx        ;|adding hands to winner player
cmp cx, 210   ;|
jne hand1     ;|
mov cx, 240   ;|
mov dx, 85    ;|
hand2:        ;|
mov al, white ;|
mov ah, 12    ;|
int 16        ;|
inc cx        ;|
inc dx        ;|
cmp cx, 250   ;|
jne hand2     ;|


mov cx, 225   ;|
mov dx, 100   ;|
leg1:         ;|
mov al, white ;|
mov ah, 12    ;|
int 16        ;|
inc dx        ;|
cmp dx, 110   ;|
jne leg1      ;|adding legs to winner player
add cx, 10    ;|
mov dx, 100   ;|
leg2:         ;|
mov al, white ;|
mov ah, 12    ;|
int 16        ;|
inc dx        ;|
cmp dx, 110   ;|
jne leg2      ;|

WaitForData2:
 mov ah, 1
    Int 16h 
    jz WaitForData2
    mov ah, 0 
    int 16h
    cmp al, 'r'; check if "r' has been pressed
    je start
    cmp al, 'R'; check if "R' has been pressed
    je start
    cmp al, 0 ; check if any key has been pressed
    jge exit 
    jmp WaitForData2
endm playerWon
;----------------------------------------------------
macro checkBlock playerArr, playerColor; used to check if player is in the same block as a snake/ladder
local endCheck, ladder1, snake1, ladder2, snake2, drawPlayer2, drawPlayer3 ;| allow labels inside a macro
mov ah,0Dh                                            ;|
mov cx,[playerArr];(right x)                          ;|
mov dx,[playerArr + 2];(low y)                        ;|
add cx, 8  ;|how much we need to change in order      ;|checking if the player is on a ladder block
sub dx, 21 ;|to be in the same spot as the ladder     ;|
int 10H                                               ;|
cmp al, brown   
je ladder1      

mov ah,0Dh                                             ;|
mov dx, [playerArr + 2];(low y)                        ;|
add dx, 6                                              ;|
mov cx, [playerArr];(right x)                          ;|
add cx, 8; to be in position with a potential snake    ;|checking if the player is on a snake block
int 10H                                                ;|
cmp al, purple                                         ;|
je snake1                                              ;|

jmp endCheck    

ladder1:
mov ah,0Dh                                                                                               ;|
add dx, 28;|going down a block to see if it still sees a ladder. if it doesnt, that means he was on one  ;| 
int 10H                                                                                                  ;|chceking if the block was
cmp al, brown                                                                                            ;|the start of the ladder
je endCheck                                                                                              ;|

delay 3 ;|to give time to see that he was on a ladder block

push [playerArr]  ;right x       ;|
push [playerArr + 2] ;low y      ;|
push [playerArr + 4]  ;left x    ;|earasing player from his former position
push [playerArr + 6] ;upper y    ;|
push black ; color               ;|
call DrawPlayer                  ;|

mov cx,[playerArr]     ;|
mov dx,[playerArr + 2] ;|going back to the right place
add cx, 8              ;|
sub dx, 21 
ladder2:   
earasePlayer playerArr

sub [playerArr + 2], 28       ;|
sub [playerArr + 6], 28       ;|
mov ah, 0Dh                   ;|
sub dx, 35                    ;|
mov cx, [playerArr]           ;|
add cx, 8                     ;|going up the ladder 
int 10H                       ;|by going up one block                              
cmp al, brown                 ;|untill there is no ladder
je drawPlayer2                ;|on that block-

push [playerArr]  ;right x       ;|
push [playerArr + 2] ;low y      ;|
push [playerArr + 4]  ;left x    ;|printing player on
push [playerArr + 6] ;upper y    ;|top of the ladder
push playerColor ; color         ;|
call DrawPlayer                  ;|

jmp endCheck

drawPlayer2:
push [playerArr]  ;right x       ;|
push [playerArr + 2] ;low y      ;|
push [playerArr + 4]  ;left x    ;|printing player 
push [playerArr + 6] ;upper y    ;|
push playerColor ; color         ;|
call DrawPlayer                  ;|
delay 2
jmp ladder2                            
                                  


snake1:
mov ah,0Dh    ;|                                         
sub dx, 28    ;|check that the block is   
int 10H       ;|the start of the snake                
cmp al, purple;|by going up one block                                          
je endCheck   ;|and check if there is a snake

delay 3 ;|to give time to see that he was on a ladder block

push [playerArr]  ;right x       ;|
push [playerArr + 2] ;low y      ;|
push [playerArr + 4]  ;left x    ;|earasing player from his former position
push [playerArr + 6] ;upper y    ;|
push black ; color               ;|
call DrawPlayer

mov dx, [playerArr + 2];|
add dx, 6              ;|going back to snake position
mov cx, [playerArr]    ;|
add cx, 8              ;|   
snake2:
earasePlayer playerArr

add [playerArr + 2], 28 ;| 
add [playerArr + 6], 28 ;|                        
mov ah,0Dh              ;| 
add dx, 28              ;| 
mov cx, [playerArr]     ;|going down the snake   
add cx, 8               ;|by going down one block
int 10H                 ;|untill there is no snake                          
cmp al, purple          ;|on that block 
je drawPlayer3          ;|                        

push [playerArr]  ;right x       ;|
push [playerArr + 2] ;low y      ;|
push [playerArr + 4]  ;left x    ;|printing player at the 
push [playerArr + 6] ;upper y    ;|buttom of the snake
push playerColor ; color         ;|
call DrawPlayer                  ;|
 
jmp endCheck

drawPlayer3:
push [playerArr]  ;right x     
push [playerArr + 2] ;low y    
push [playerArr + 4]  ;left x  
push [playerArr + 6] ;upper y  
push playerColor ; color       
call DrawPlayer 
delay 2
jmp snake2               

endCheck:
endm checkBlock
;--------------------------------------------
macro earasePlayer playerArr; used to earase players (i know, very unexpected)
push [playerArr]  ;right x
push [playerArr+2] ;low y
push [playerArr+4]  ;left x
push [playerArr+6] ;upper y
push black ; color 
call DrawPlayer
endm earasePlayer
;--------------------------------------------
macro fixPlayerboundaries playerArr, playerColor, playerString; used to get player back in the board boundaries
local fix, lastRow;| allow labels inside a macro
fix:
sub [check], 1ch      ;|
add [teleValue], 1ch  ;|add 1 block for each block that is out of boundaries
cmp [check], 170; >= 170 is out of boundaries
jge fix

sub [teleValue], 1ch ;|to include the step that goes up a row

mov dx, [check]        ;|
mov [playerArr], dx    ;|moving player to the rightest block 
sub dx, 7              ;|(making it easier to get him back to the leftest block)
mov [playerArr + 4], dx;|

cmp [playerArr + 2], 30 ;|check if player is in the last row
jng lastRow             ;|{if he's in the last row it means he won (no need to make him go up a row)}

; moving player to the leftest block
sub [playerArr], 140     ;|
sub [playerArr + 4], 140 ;|140 = 5 blocks

; going up a row
sub [playerArr + 2], 28
sub [playerArr + 6], 28

lastRow:  ;|if he's in the last row it means he won (no need to make him go up a row) 
movePlayer playerArr, playerColor, playerString
endm fixPlayerboundaries
;-----------------------------------------------
macro movePlayer playerArr, playerColor, playerString; used to move players
local playerDidNotWin, contCheck, redWon, greenWon;|to allow using labels inside a macro
earasePlayer playerArr;earasing player 

mov dx, [playerArr];([PlayerArr] = right x value of player before teleporting)  ;|
add dx, [teleValue]; adding the teleport value                                  ;|
mov [playerArr], dx                                                             ;|updating player values
sub dx, 7; player size is 7x7                                                   ;|before teleporting
mov [playerArr + 4], dx;([PlayerArr + 4] = left x of player before teleporting) ;|

mov dx, [playerArr + 2] ;|check if player
cmp dx, 30              ;|reached last row
jge playerDidNotWin        

cmp [playerArr], 140 ;|check if player 
jnge playerDidNotWin ;|reached last block           

playerWon playerColor

playerDidNotWin:
push [playerArr]  ;right x     ;|
push [playerArr+2] ;low y      ;|
push [playerArr+4]  ;left x    ;|teleporting player
push [playerArr+6] ;upper y    ;|
push playerColor ;color        ;|
call DrawPlayer                ;|

call deleteString  ;|earasing potential bugs due to string length diffrences

; announcing next players turn
mov  dl, 22  ;Column
mov  dh, 2   ;Row
mov bh,0
mov  ah, 02h  ;SetCursorPosition
int  10h

mov dx,offset playerString
mov ah,09h
int 21h

inc [playerCounter] ;|update next players turn

checkBlock playerArr, playerColor;| check if player is on a snake/ladder block

jmp WaitForData

endm movePlayer
;---------------------------
macro delay num; used to make delay ;)
local check_time
mov [timeCounter], 0
mov [saved_time], 0
check_time:
   mov ah,2ch
   int 21h ;=> ch:hours cl:minutes, dh: seconds, dl: 1/100seconds
 
 cmp dh,[saved_time]
  je check_time
   mov [saved_time],dh
   
   inc [timeCounter]
   cmp [timeCounter], num
   jne check_time
endm delay 
;---------------------------
black = 0   ;|
blue = 1    ;|
green = 2   ;|
red = 4     ;|default color values
purple = 5  ;|
brown = 6   ;|
yellow = 14 ;|
white = 15  ;|
; --------------------------
restart db 'Press any key to quit, and r to restart$';restart msg at the end of the game
endingMsg db 'Thanks for playing!$';ending msg at the end of the game
winnerMsg db 'Congrats for winning:$';another ending msg at the end of the game
saved_time db 0;for delay proc
timeCounter db 0;for delay proc
check dw 0;to check for player out of boundris
teleValue dw 0;teleport value (how many steps player needs to move)
playerCounter db 0 ;check which player turn                                             
pressEsc db 'At any time, press "Esc" to quit$';a default msg that tells you can quit
ending db 'End$';a default msg that shows last block
dice db 'roll The Dice: $'      ;|
pressSpace db 'Press space to$' ;|a default msg that tells you can roll the dice
BlueString db 'Blue player turn$';announcing blue players turn
RedString db 'Red player turn$';announcing red players turn
GreenString db 'Green player turn$';announcing green players turn
BlueArr dw 20, 169, 13, 162  ;|
RedArr dw 13, 169, 6, 162    ;|an array with the default values for the player
GreenArr dw 13, 160, 6, 153  ;|
; --------------------------
CODESEG
;---------------------------
proc displayRandNum; used to display random number at the right place
  call randNum; generating the number and displaying it
  
  mov al, dl
  
  mov [teleValue], 0; restarting value each time so they won't gather up
  call teleLength; calculate how long the player needs to be teleported
  
  mov dl, al
  
  call drawDice; draw the dice

ret
endp displayRandNum
;---------------------------
proc deleteString; used to earase last parts of certien strings that causes bugs due to the length diffrences
mov dx, 16
mov cx, 310
del:
mov al, black
mov ah, 12
int 16
dec cx
cmp cx, 260
jne del
mov cx, 310
inc dx
cmp dx, 30
jne del
ret
endp deleteString
;---------------------------
proc teleLength; used to calculate teleport length for a player
l:
; multiplying 28 (1 block length) by the dice value
add [teleValue], 1ch
dec dl; dl = dice value
cmp dl, '0'
jne l
ret
endp teleLength
;--------------------------
proc drawDice; used to draw the dice
push 300 ;right x      ;|
push 140 ;low y        ;|
push 250 ;left x       ;|the cubes 'background"
push 90 ;up y          ;|
push red               ;|
cmp dl, '1'
jne check2  
call DrawPlayer    
push 280   ;right x
push 120   ;low y
push 270   ;left x
push 110  ;up y
push white
jmp stopcheck

check2:
cmp dl, '2'
jne check3
call DrawPlayer
push 295 ;right x 
push 105  ;low y   
push 285 ;left x  
push 95 ;up y      
push white
call DrawPlayer
push 265   ;right x
push 135    ;low y
push 255   ;left x
push 125   ;up y
push white
jmp stopcheck

check3:
cmp dl, '3'
jne check4
call DrawPlayer
push 295 ;right x 
push 105  ;low y   
push 285 ;left x  
push 95 ;up y    
push white
call DrawPlayer
push 265   ;right x
push 135    ;low y
push 255   ;left x
push 125   ;up y
push white
call DrawPlayer
push 280   ;right x
push 120   ;low y
push 270   ;left x
push 110  ;up y
push white
jmp stopcheck

check4:
cmp dl, '4'
jne check5
call DrawPlayer
push 300 ;right x
push 140 ;low y
push 250 ;left x
push 90 ;up y
push 4
call DrawPlayer
push 295 ;right x 
push 105  ;low y   
push 285 ;left x  
push 95 ;up y     
push 15
call DrawPlayer
push 265   ;right x
push 135    ;low y
push 255   ;left x
push 125   ;up y
push 15
call DrawPlayer
push 265 ;right x 
push 105  ;low y   
push 255 ;left x  
push 95 ;up y     
push 15
call DrawPlayer
push 295   ;right x
push 135    ;low y
push 285   ;left x
push 125   ;up y
push 15
jmp stopcheck

check5:
cmp dl, '5'
jne check6
call DrawPlayer
push 300 ;right x
push 140 ;low y
push 250 ;left x
push 90 ;up y
push 4
call DrawPlayer
push 295 ;right x 
push 105  ;low y   
push 285 ;left x  
push 95 ;up y     
push 15
call DrawPlayer
push 265   ;right x
push 135    ;low y
push 255   ;left x
push 125   ;up y
push 15
call DrawPlayer
push 265 ;right x 
push 105  ;low y   
push 255 ;left x  
push 95 ;up y     
push 15
call DrawPlayer
push 295   ;right x
push 135    ;low y
push 285   ;left x
push 125   ;up y
push 15
call DrawPlayer
push 280   ;right x
push 120   ;low y
push 270   ;left x
push 110  ;up y
push white
jmp stopcheck

check6:
call DrawPlayer
push 295 ;right x 
push 105  ;low y   
push 285 ;left x  
push 95 ;up y     
push 15
call DrawPlayer
push 265   ;right x
push 135    ;low y
push 255   ;left x
push 125   ;up y
push 15
call DrawPlayer
push 265 ;right x 
push 105  ;low y   
push 255 ;left x  
push 95 ;up y     
push 15
call DrawPlayer
push 295   ;right x
push 135    ;low y
push 285   ;left x
push 125   ;up y
push 15
call DrawPlayer
push 295   ;right x
push 120   ;low y
push 285   ;left x
push 110  ;up y
push 15
call DrawPlayer
push 265   ;right x
push 120   ;low y
push 255   ;left x
push 110  ;up y
push 15

stopcheck:
call DrawPlayer
ret
endp drawDice
;---------------------------
proc DrawPlayer; used to draw the players

push bp
mov bp,sp

right_x equ [bp+12]
lower_y equ [bp+10]
left_x equ [bp+8]
upper_y equ [bp+6]
color equ [bp+4]

mov cx, left_x
mov dx, upper_y
paintLoop:
mov al, color
mov ah, 12
int 16
inc cx
cmp cx,right_x
jne PaintLoop
mov cx, left_x
inc dx
cmp dx, lower_y
jne paintLoop

pop bp
ret 10 ; 5x2 = 10 (5 veriables)
endp DrawPlayer
;---------------------------
proc randNum; used to get a random number for the dice
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 6    
   div  cx       ; here dx contains the remainder of the division - from 0 to 5

   add  dl, '0'  ; to ascii from 0 to 5
   add dl, 1        ; changes the finale value to 1-6
   
ret
endp randNum
;---------------------------
proc snake; used to draw snakes
push bp
mov bp, sp

start_x equ [bp+4]
finish_x equ [bp+6]
start_y equ [bp+8]
finish_y equ [bp+10]

mov cx, start_x
mov dx, start_y

drawSnake:       ;|
mov al, purple   ;|
mov ah, 12       ;|
int 16           ;|
inc dx           ;|
cmp dx, finish_y ;|snake body
jne drawSnake    ;|
mov dx, start_y  ;|
dec cx           ;|
cmp cx, finish_x ;|
jne drawSnake    ;|


mov dx, start_y ;|
mov cx, start_x ;|
inc dx          ;|
sub cx, 2       ;|
mov al, yellow  ;|snake eyes
mov ah, 12      ;|
int 16          ;|
sub cx, 4       ;|
mov al, 14      ;|
mov ah, 12      ;|
int 16          ;|


mov cx, start_x     ;|
mov dx, start_y     ;|
add dx, 3           ;|
sub cx, 4           ;|
                    ;|snake design (the stripe on his back)
drawSnakeDesign:    ;|
mov al, yellow      ;|
mov ah, 12          ;|
int 16              ;|
inc dx              ;|
cmp dx, finish_y    ;|
jne drawSnakeDesign ;|

pop bp
ret 8 ; 4x2 = 10 (4 veriables)
endp snake
;---------------------------
proc ladder; used to draw ladders
push bp
mov bp, sp

xStart equ [bp+4]
yStart equ [bp+6]
yStop equ [bp+8]
xStop equ [bp+10]
yStopD3 equ [bp+12]

mov cx, xStart
mov dx, yStart

draw1:         ;| 
mov al, brown  ;|
mov ah, 12     ;|
int 16         ;|right rod
dec dx         ;|
cmp dx, yStop  ;|
jne draw1      ;|

sub cx, 7       ;| 
mov dx, yStart  ;|
draw2:          ;|
mov al, brown   ;|
mov ah, 12      ;|left rod
int 16          ;|
dec dx          ;|
cmp dx, yStop   ;|
jne draw2       ;|


mov cx, xStart  ;|
mov dx, yStart  ;|
sub dx, 2       ;|
draw3:          ;|
mov al, brown   ;|
mov ah, 12      ;|
int 16          ;|
dec cx          ;|those stuff you climb on in between the rods
cmp cx, xStop   ;|
jne draw3       ;|
mov cx, xStart  ;|
sub dx, 10      ;|
cmp dx, yStopD3 ;|
jne draw3       ;|

pop bp
ret 10; 5x2 = 10 (5 veriables)
endp ladder 
;---------------------------
proc DrawBoard; used to draw the board
push bp
mov bp, sp

fix equ [bp+10] ; fix = sizeStop - 28 (one block) {we need fix because otherwise it draws too much}
sizeStart equ [bp+8] ;| 
sizeStop equ [bp+6]  ;|board is a square so no need for 2 veriables x & 2 veriables y 
color equ [bp+4]

mov cx, sizeStart
mov dx, sizeStart

yloop:            ;|
mov al, color     ;|
mov ah, 12        ;|
int 16            ;|
inc dx            ;|
cmp dx, fix       ;|draws all of the y stripes
jne yloop         ;|
mov dx, sizeStart ;|
add cx, 28        ;|
cmp cx, sizeStop  ;|
jne yloop         ;|

mov cx, sizeStart  ;|
mov dx, sizeStart  ;|
xloop:             ;|
mov al, color      ;|
mov ah, 12         ;|
int 16             ;|
inc cx             ;|draws all of the x stripes
cmp cx, fix        ;|
jne xloop          ;|
mov cx, sizeStart  ;|
add dx, 28         ;|
cmp dx, sizeStop   ;|
jne xloop          ;|

push 106 ;yStopD3              ;|
push 161 ;xStop                ;|
push 108 ;yStop                ;|
push 148 ;yStart               ;|
push 168 ;xStart               ;|
call ladder                    ;|
                               ;|
push 78 ;yStopD3               ;|
push 21 ;xStop                 ;|
push 80 ;yStop                 ;|
push 120 ;yStart               ;|
push 28 ;xStart                ;|
call ladder                    ;|
                               ;|
push 78 ;yStopD3  ;|           ;|
push 77 ;xStop    ;|           ;|
push 80 ;yStop    ;|           ;|adding snakes and ladders
push 120 ;yStart  ;|           ;|
push 84 ;xStart   ;|           ;|
call ladder       ;|Same       ;|
push 48 ;yStopD3  ;|(Long)     ;|
push 77 ;xStop    ;|Ladder     ;|
push 50 ;yStop    ;|           ;|
push 90 ;yStart   ;|           ;|
push 84 ;xStart   ;|           ;|
call ladder       ;|           ;|
                               ;|
push 148 ;finish_y             ;|
push 22 ;start_y               ;|
push 131 ;finish_x             ;|
push 140 ;start_x              ;|
call snake                     ;|
                               ;|
push 148 ;finish_y             ;|
push 108 ;start_y              ;|
push 47 ;finish_x              ;|
push 56 ;start_x               ;|
call snake                     ;|
                               ;|
push 66 ;finish_y              ;|
push 22 ;start_y               ;|
push 47 ;finish_x              ;|
push 56 ;start_x               ;|
call snake                     ;|
 

mov  dl, 18  ;Column                ;|
mov  dh, 0   ;Row                   ;|
mov bh,0                            ;|
mov  ah, 02h  ;SetCursorPosition    ;|
int  10h                            ;|
;                                   ;|
mov dx,offset ending                ;|
mov ah,09h                          ;|
int 21h                             ;|
;                                   ;|
mov  dl, 1  ;Column                 ;|
mov  dh, 24   ;Row                  ;|
mov bh,0                            ;|
mov  ah, 02h  ;SetCursorPosition    ;|
int  10h                            ;|
;                                   ;|
mov dx,offset pressEsc              ;|
mov ah,09h                          ;|
int 21h                             ;|
;                                   ;|
;                                   ;|
mov  dl, 22  ;Column                ;|
mov  dh, 5   ;Row                   ;|printing the deafult strings
mov bh,0                            ;|
mov  ah, 02h  ;SetCursorPosition    ;|
int  10h                            ;|
;                                   ;|
mov dx,offset dice                  ;|
mov ah,09h                          ;|
int 21h                             ;|
;                                   ;|
mov  dl, 22  ;Column                ;|
mov  dh, 4   ;Row                   ;|
mov bh,0                            ;|
mov  ah, 02h  ;SetCursorPosition    ;|
int  10h                            ;|
;                                   ;|
mov dx,offset pressSpace            ;|
mov ah,09h                          ;|
int 21h                             ;|
;                                   ;|
mov  dl, 22  ;Column                ;|
mov  dh, 2   ;Row                   ;|
mov bh,0                            ;|
mov  ah, 02h  ;SetCursorPosition    ;|
int  10h                            ;|
;                                   ;|
mov dx,offset BlueString            ;|
mov ah,09h                          ;|
int 21h                             ;|


pop bp
ret 8; 4x2 = 8 (4 veriables)

endp DrawBoard
;---------------------------
start:
    mov ax, @data
    mov ds, ax
; --------------------------
mov [playerCounter], 0; when/if restarting game, we need blue player to start

mov [BlueArr], 20       ;|
mov [BlueArr + 2], 169  ;|
mov [BlueArr + 4], 13   ;|
mov [BlueArr + 6], 162  ;|
                        ;|
mov [RedArr], 13        ;|
mov [RedArr + 2], 169   ;|
mov [RedArr + 4], 6     ;|when/if restarting game, players to start at the right position
mov [RedArr + 6], 162   ;|
                        ;|
mov [GreenArr], 13      ;|
mov [GreenArr + 2], 160 ;|
mov [GreenArr + 4], 6   ;|
mov [GreenArr + 6], 153 ;|

; graphic mode
mov ax, 13h
int 16

;board
push 170 ;fix
push 2 ;sizeStart
push 198 ;sizeStop
push 8 ;color
call DrawBoard

;Player Blue
push [BlueArr]  ;right x
push [BlueArr + 2] ;low y
push [BlueArr + 4]  ;left x
push [BlueArr + 6] ;upper y
push blue ; color 
call DrawPlayer

;Player Green
push [GreenArr]  ;right x
push [GreenArr + 2] ;low y
push [GreenArr + 4]  ;left x
push [GreenArr + 6] ;upper y
push green ; color 
call DrawPlayer

;Player Red
push [RedArr]  ;right x
push [RedArr + 2] ;low y
push [RedArr + 4]  ;left x
push [RedArr + 6] ;upper y
push red ; color 
call DrawPlayer

WaitForData:
    mov ah, 1
    Int 16h 
    jz WaitForData
    mov ah, 0 
    int 16h
    cmp ah, 39h; check if space bar has been pressed
    je SpacePressed
    cmp ah, 1h ; check esc key has been pressed
    je exit 
    jmp WaitForData

SpacePressed:              
cmp [playerCounter], 1  ;|
je RedTurn              ;|
                        ;|checking whos turn is it by a counter 
cmp [playerCounter], 2  ;|(counter deafults to 0 so blues turn is first)
je GreenTurn            ;|


; if its not reds turn nor greens turn, it has to be blues
BlueTurn:
mov [playerCounter], 0   ;|update counter so the next player is red (counter increases later)

call displayRandNum ;|create and display random number
; check player boundaries:
mov dx, [BlueArr]      ;| 
add dx, [teleValue]    ;|checking where the player would go before teleporting him, 
mov [check], dx        ;|by adding his position with teleport length into "check' 
cmp [check], 170  ;|
jnge contBlue     ;|>= 170 is out of the board boundaries

; go here if he is out of boundaries
delay 3 ;| to make it seem normal  

push 300        ;|
push 140        ;|
push 250        ;|earase the dice print
push 90         ;|
push black      ;| 
call DrawPlayer ;|


earasePlayer BlueArr; earasing player from current position
; fix player boundaries
mov [teleValue], 0    ;|restarting teleValue because we are about to use it to calculate the amount of steps needed after going up a row
          
fixPlayerboundaries BlueArr, blue, RedString  ;|used to fixing player values that are out of boundaries

contBlue:  ;|if player is not out of boudris, he is instantly going here

delay 3 ;| to make it seem normal 

push 300        ;|
push 140        ;|
push 250        ;|earase the dice print
push 90         ;|
push black      ;| 
call DrawPlayer ;|

movePlayer BlueArr, blue, RedString  ;|teleporting him




RedTurn:
; check player boundaries:
call displayRandNum ;|create and display random number
mov dx, [RedArr]      ;| 
add dx, [teleValue]    ;|checking where the player would go before teleporting him by adding his position with teleport length into "check' 
mov [check], dx        ;|
cmp [check], 170  ;|
jnge contRed      ;|>= 170 is out of the board boundaries

; go here if he is out of boundaries
delay 3 ;| to make it seem normal  

push 300        ;|
push 140        ;|
push 250        ;|earase the dice print
push 90         ;|
push black      ;| 
call DrawPlayer ;|


earasePlayer RedArr
; fix player boundaries
mov [teleValue], 0    ;|restarting teleValue because we are about to use it to calculate the amount of steps needed after going up a row
              
fixPlayerboundaries RedArr, red, GreenString  ;|used to fixing player values that are out of boundaries

contRed:  ;|if player is not out of boudris, he is instantly going here

delay 3 ;| to make it seem normal 

push 300        ;|
push 140        ;|
push 250        ;|earase the dice print
push 90         ;|
push black      ;| 
call DrawPlayer ;|


movePlayer RedArr, red, GreenString  ;|teleporting him




GreenTurn:
; check player boundaries:
call displayRandNum ;|create and display random number
mov dx, [GreenArr]      ;| 
add dx, [teleValue]    ;|checking where the player would go before teleporting him by adding his position with teleport length into "check' 
mov [check], dx        ;|
cmp [check], 170  ;|
jnge contGreen     ;|>= 170 is out of the board boundaries

; go here if he is out of boundaries
delay 3 ;| to make it seem normal  

push 300        ;|
push 140        ;|
push 250        ;|earase the dice print
push 90         ;|
push black      ;| 
call DrawPlayer ;|


earasePlayer GreenArr
mov [teleValue], 0    ;|restarting teleValue because we are about to use it to calculate the amount of steps needed after going up a row
          
fixPlayerboundaries GreenArr, green, BlueString  ;|used to fixing player values that are out of boundaries

contGreen:  ;|if player is not out of boudris, he is instantly going here

delay 3 ;| to make it seem normal 

push 300        ;|
push 140        ;|
push 250        ;|earase the dice print
push 90         ;|
push black      ;| 
call DrawPlayer ;|


movePlayer GreenArr, green, BlueString  ;|teleporting him
; --------------------------
exit:
    mov ax, 4c00h
    int 21h
    END start