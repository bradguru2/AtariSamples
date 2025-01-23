 set kernel_options pfcolors pfheights collision(playfield,player1)
 set optimization inline rand
 include div_mul.asm
 include 6lives.asm

StartOrRestart
 p = 0
 q = 0
 r = 0
 s = 0
 t = 0
 u = 0
 v = 0
 w = 0 
 x = 0
 y = 0
 COLUBK = $C5
 score = 0
 scorecolor = $9C
 COLUPF = $0F
 player0x=72
 rem player0x=72
 player0y=85
 player1x=75
 rem player1x=69
 player1y=50
 lives=160
 dim lives_compact = 1
 dim bx=x
 dim by=y
 dim mapx=u
 dim mapy=v
 dim gameover=w
 dim ballrestrainer=w
 dim userestrainer=w
 dim totalblocks1=t
 dim totalblocks2=s
 dim tempcalc=r
 dim duration0=q
 dim duration1=p

 pfheights:
 4
 8
 4
 4
 4
 4
 4
 4
 4
 4
 36
 8    
end 

 rem if rand & 1 then goto ColorSetup2
 rem *since we are using pfheights, we can only have 1 pfcolors setup

ColorSetup

 pfcolors:
 $07
 $00
 $8C
 $8C
 $57
 $57
 $46
 $46
 $2A
 $2A
 $00 
 $07
end

PlayerSetup

 player0:
 %11111111
 %11111111
 %11111111
 %11111111 
end 

 player1:
 %1111
 %1111
 %1111
 %1111
end 

PlayFieldSetup
 playfield:
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ................................
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ................................
  ................................
end

 totalblocks1=128
 totalblocks2=128
 ballrestrainer{1}=1
 userestrainer{2}=1 

MainLoop 

SetupMainLoop

    lives:
    %01111110
    %01000010
    %01000010
    %01000010
    %01000010
    %01000010
    %01000010
    %01111110 
end

    lifecolor = $2f
    COLUPF = $07
    COLUP0 = $07
    COLUP1 = $07
    missile0x=10
    missile0y=0
    missile0height=254
    missile1x=146
    missile1y=0
    missile1height=254   
    NUSIZ0=$35
    NUSIZ1=$30

InputEvents   
    if joy0left then gosub MovePlayer0Left
    if joy0right then gosub MovePlayer0Right
    if joy0fire && by=0 then gosub InitPlayerBall
    if switchreset && by=0 then gosub InitPlayerBall
    
MoveBall
    if ballrestrainer{1} then ExamineCollision
    player1x=player1x+bx
    player1y=player1y+by

ExamineCollision
    if by<>0 then gosub CheckCollision
    if userestrainer{2} then ballrestrainer{1}=!ballrestrainer{1} else ballrestrainer{1}=0

SoundEffects
    if duration0>0 then duration0=duration0-1
    AUDV0=duration0
    if duration1>0 then duration1=duration1-1
    AUDV1=duration1

Render
    drawscreen 

PostRender
    if totalblocks1<1 && totalblocks2<1 then LevelUp
    if totalblocks1<32 || totalblocks2<32 then userestrainer{2}=0
    if gameover{0} then goto GameOverPlayer
    if switchreset then goto StartOrRestart
    goto MainLoop

LevelUp
    player1x=75
    player1y=50
    bx=0
    by=0
    goto PlayFieldSetup

CheckCollision
    if collision(player0,player1) then HandlePlayerCollision
    if collision(playfield,player1) then HandlePlayfieldCollision
ExamineWallCollision
    goto HandleWallCollision

HandlePlayerCollision
    if player1y>=77 then player1y=77
    by=0-by
    tempcalc=player0x-3
    temp2=bx
    if player1x<=tempcalc then bx=-2
    if temp2<>bx then ExamineWallCollision
    tempcalc=player0x+3
    temp2=bx
    if player1x<=tempcalc then bx=-1
    if temp2<>bx then ExamineWallCollision
    tempcalc=player0x+6
    temp2=bx
    if player1x<=tempcalc then bx=1
    if temp2<>bx then ExamineWallCollision
    tempcalc=player0x+9
    temp2=bx
    if player1x<=tempcalc then bx=2
    goto ExamineWallCollision

HandlePlayfieldCollision
    mapx=(player1x-12)/4
    mapy=(player1y-4)/4
    if player1y<=8 then player1y=8
    if !pfread(mapx,mapy) then goto ExamineWallCollision
    if player1y > 8 then gosub RemoveBlock
    by=0-by
    
HandleWallCollision
    if collision(player1,missile0) then Collide
    if collision(player1,missile1) then Collide
    goto CheckBottomWall
Collide
    bx=0-bx
    if player1x<13 then player1x=13
    if player1x>130 then player1x=130
CheckBottomWall    
    rem reached bottom wall before intercepted by paddle?
    if player1y>84 then gosub LoseBall
    return   

RemoveBlock
    if !pfread(mapx,mapy) then CheckBlock2 
    if (totalblocks1 >= 1) then totalblocks1=totalblocks1-1 else totalblocks2=totalblocks2-1
    AUDV0=15
    AUDC0=8
    AUDF0=18
    duration0=15
    score=score + 1
    tempcalc=2 * (9-mapy)
    score=score + tempcalc
    pfpixel mapx mapy off
CheckBlock2   
    if !mapx then mapx=1 else mapx=mapx-1
    if !pfread(mapx,mapy) then SkipRemove2
    AUDV1=15
    AUDC1=8
    AUDF1=15
    duration1=15
    tempcalc=2 * (9-mapy)
    score=score + 1
    score=score + tempcalc
    if (totalblocks2 >= 1) then totalblocks2=totalblocks2-1 else totalblocks1=totalblocks1-1
    pfpixel mapx mapy off
SkipRemove2
    return

LoseBall
    AUDV0=15
    AUDC0=3
    AUDF0=2
    duration0=15
    player1x=75
    player1y=50
    by=0
    bx=0
    lives=lives-32
    if lives<32 then gameover{0}=!gameover{0}
    return

InitPlayerBall
    AUDV0=15
    AUDC0=8
    AUDF0=0
    duration0=15
    bx=0
    by=1
    scorecolor = $0f
    COLUBK = $00
    if gameover{0} then score=0
    if gameover{0} then gameover{0}=0
    return

MovePlayer0Left
    player0x=player0x-2
    if player0x<16 then player0x=16
    return

MovePlayer0Right
    player0x=player0x+2
    if player0x>128 then player0x=128
    return  

GameOverPlayer
    scorecolor = $9C
    COLUBK = $C5 
    lives=160
    goto PlayFieldSetup       