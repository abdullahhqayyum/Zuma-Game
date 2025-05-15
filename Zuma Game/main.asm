    include Irvine32.inc
    include macros.inc
    .data
        walls BYTE " _____________________________________________________________________________ ", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                    ---                                      |", 0
              BYTE "|                                   |   |                                     |", 0
              BYTE "|                                   |   |                                     |", 0
              BYTE "|                                   |   |                                     |", 0
              BYTE "|                                    ---                                      |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|                                                                             |", 0
              BYTE "|_____________________________________________________________________________|", 0
        player_right BYTE "   ", 0
                     BYTE " O-", 0
                     BYTE "   ", 0
        player_left BYTE "   ", 0
                    BYTE "-O ", 0
                    BYTE "   ", 0
        player_up BYTE " | ", 0
                  BYTE " O ", 0
                  BYTE "   ", 0
        player_down BYTE "   ", 0
                    BYTE " O ", 0
                    BYTE " | ", 0
        player_upright BYTE "  /", 0
                       BYTE " O ", 0
                       BYTE "   ", 0
        player_upleft BYTE "\  ", 0
                      BYTE " O ", 0
                      BYTE "   ", 0
        player_downright BYTE "   ", 0
                         BYTE " O ", 0
                         BYTE "  \", 0
        player_downleft BYTE "   ", 0
                        BYTE " O ", 0
                        BYTE "/  ", 0
        xPos db 56
        yPos db 15
        xDir db 0
        yDir db 0
        inputChar db 0
        direction db "d"
        color_red db 4
        color_green db 2
        color_yellow db 14
        current_color db 4
        emitter_color1 db 2
        emitter_color2 db 4
        fire_color db 14
        emitter_symbol db "#"
        emitter_row db 0
        emitter_col db 1
        fire_symbol db "*", 0
        fire_row db 0
        fire_col db 0
        score db 0
        lives db 3
        levelInfo db 1
        counter1 db 0
        counter2 db 0
         ball_symbol db 'O', 0
        current_ball_index db 0
          num_balls db 5
        ball_colors db 5 dup(?)
    ball_positions BYTE 25, 6
    pathCoordinates DWORD 22, 8, 23, 8, 24, 8, 25, 8, 26, 8, 27, 8, 28, 8, 29, 10, 30, 10, 31, 10, 32, 10, 33, 10, 34, 10, 35, 10
    pathLength DWORD 20
    pathSymbol BYTE "."
        ballSymbol BYTE "O"
        pathTop db 6
        pathBottom db 26
        pathLeft db 37
        pathRight db 77
        ballX db 40
        ballY db 12
        ballDirection db 0
        ballColor db 4
    pathShrinkCounter db 0
    minPathSize db 3
    pathColor db 7
    ballLoopCounter db 0
    ballOnPathStart db 0
        ballIsStationary db 0
        currentDirection db 0
    stepsInCurrentDir db 0
    maxStepsHorizontal db 0
    maxStepsVertical db 0
    fullLoopsCompleted db 0
    x db ?
    y db ?
    steps db 5
    loopCount db 5
    collisionFlag db 0
    stepsRightLeft  db 40
    stepsDown       db 20
    stepsUp         db 40
    spiralActive    db 1
    dotColor db 7
    xPosPrev db 56
yPosPrev db 15
ballSpeedLevel1 db 127
ballSpeedLevel2 db 70
ballSpeedLevel3 db 1
currentBallSpeed db 100
playerName db 20 DUP(0)
buffer db 20 DUP(0)      

.code
   MainMenu PROC
    call Clrscr
    mov dl, 30
    mov dh, 5
    call Gotoxy
    mov eax, Yellow + (Black * 16)
    call SetTextColor
    mWrite <" ZUMBA - MAIN MENU">
   
    ; Input player name
    mov dl, 30
    mov dh, 7
    call Gotoxy
    mWrite <"Enter your name: ">
    mov edx, OFFSET buffer       ; Input buffer
    mov ecx, 20                 ; Max length
    call ReadString              ; Read player name
    mov edi, OFFSET playerName   ; Copy to playerName
    mov esi, OFFSET buffer
    mov ecx, 20
    cld
    rep movsb                    ; Copy string to playerName

    ; Display the menu options
    mov eax, White + (Black * 16)
    call SetTextColor

    mov dl, 30
    mov dh, 7
    call Gotoxy
    mov dl, 30
    mov dh, 8
    call Gotoxy
    mWrite <"1. Instructions">
    mov dl, 30
    mov dh, 9
    call Gotoxy
    mWrite <"2. Select Level">
    mov dl, 30
    mov dh, 10
    call Gotoxy
    mWrite <"3. Exit Game">
    mov dl, 30
    mov dh, 12
    call Gotoxy
    mWrite <"Select an option (1-3): ">
    call ReadInt
    mov ecx, eax
    cmp ecx, 1
    je ShowInstructions
    cmp ecx, 2
    je SelectLevel
    cmp ecx, 3
    je ExitGame
    mov dl, 30
    mov dh, 14
    call Gotoxy
    mov eax, Red + (Black * 16)
    call SetTextColor
    mWrite <"Invalid option. Exiting program.">
    call Delay
    exit
StartGame:
    call Clrscr
    mov dl, 30
    mov dh, 5
    call Gotoxy
    mWrite <"Starting the game...">
    call Delay
    ret
ShowInstructions:
    call InstructionsScreen
    ret
SelectLevel:
    call LevelSelect
    ret
ExitGame:
    call Clrscr
    mov dl, 30
    mov dh, 5
    call Gotoxy
    mWrite <"Exiting the game. Goodbye!">
    call Delay
    exit
MainMenu ENDP
LevelSelect PROC
    call Clrscr
    mov dl, 30
    mov dh, 5
    call Gotoxy
    mov eax, Yellow + (Black * 16)
    call SetTextColor
    mWrite <"ZUMBA - SELECT LEVEL">
    mov eax, White + (Black * 16)
    call SetTextColor
    mov dl, 30
    mov dh, 7
    call Gotoxy
    mWrite <"1. Easy">
    mov dl, 30
    mov dh, 8
    call Gotoxy
    mWrite <"2. Medium">
    mov dl, 30
    mov dh, 9
    call Gotoxy
    mWrite <"3. Hard">
    mov dl, 30
    mov dh, 11
    call Gotoxy
    mWrite <"Select a level (1-3): ">
    call ReadInt
    mov ecx, eax
    cmp ecx, 1
    je SetEasyLevel
    cmp ecx, 2
    je SetMediumLevel
    cmp ecx, 3
    je SetHardLevel
    mov dl, 30
    mov dh, 13
    call Gotoxy
    mov eax, Red + (Black * 16)
    call SetTextColor
    mWrite <"Invalid option. Defaulting to Easy level.">
    call Delay
    jmp SetEasyLevel
SetEasyLevel:
    mov currentBallSpeed, 200
    mov levelInfo, 1
    ret
SetMediumLevel:
    mov currentBallSpeed, 100
    mov levelInfo, 2
    ret
SetHardLevel:
    mov currentBallSpeed, 50
    mov levelInfo, 3
    ret
LevelSelect ENDP

InstructionsScreen PROC
    ; Clear the screen for instructions
    call Clrscr

    ; Display title
    mov dl, 30
    mov dh, 5
    call Gotoxy
    mov eax, Yellow + (Black * 16)
    call SetTextColor
    mWrite <"ZUMBA - INSTRUCTIONS">

    ; Display instructions
    mov eax, White + (Black * 16)
    call SetTextColor

    mov dl, 10
    mov dh, 7
    call Gotoxy
    mWrite <"Controls:">
    mov dl, 10
    mov dh, 8
    call Gotoxy
    mWrite <"Use QWEADZXC keys to rotate and SPACE to shoot.">

    mov dl, 10
    mov dh, 10
    call Gotoxy
    mWrite <"Objective:">
    mov dl, 10
    mov dh, 11
    call Gotoxy
    mWrite <"Match colored balls to create chain reactions and score points.">

    mov dl, 10
    mov dh, 13
    call Gotoxy
    mWrite <"Press 'G' to start the game or 'M' to return to Main Menu.">

    ; Wait for user input
WaitForKeyPress:
    call ReadKey
    mov inputChar, al

    cmp inputChar, 'G'          ; Check if 'G' is pressed
    je StartGameFromInstructions

    cmp inputChar, 'M'          ; Check if 'M' is pressed
    je ReturnToMainMenu

    ; If an invalid key is pressed, wait again
    call Delay
    jmp WaitForKeyPress

StartGameFromInstructions:
    ; Call the Start Game logic
    call Clrscr
    mWrite <"Starting the game...">
    call Delay
    ret

ReturnToMainMenu:
    ; Return to Main Menu
    call Clrscr
    call MainMenu
    ret

InstructionsScreen ENDP

SwitchBall PROC

    mov al, current_ball_index
    inc al
    cmp al, 3
    jl update_ball
    mov al, 0
update_ball:
    mov current_ball_index, al


    cmp al, 0
    je set_red
    cmp al, 1
    je set_green
    cmp al, 2
    je set_blue
set_red:
    mov current_color, 4
    jmp redraw_player
set_green:
    mov current_color, 2
    jmp redraw_player
set_blue:
    mov current_color, 1
redraw_player:
    call RedrawPlayer
    ret
SwitchBall ENDP


 DisplayBall PROC
        mov dl, ballX
        mov dh, ballY
        call Gotoxy
        movzx eax, ballColor
        call SetTextColor
        mov edx, OFFSET ball_symbol
        call WriteString
        ret
    DisplayBall ENDP
CheckBoundaries PROC
    mov al, ballX
    cmp al, pathLeft
    jl AdjustLeft
    cmp al, pathRight
    jg AdjustRight
CheckY:
    mov al, ballY
    cmp al, pathTop
    jl AdjustTop
    cmp al, pathBottom
    jg AdjustBottom
    ret
AdjustLeft:
    mov al, pathLeft
    mov ballX, al
    jmp CheckY
AdjustRight:
    mov al, pathRight
    mov ballX, al
    jmp CheckY
AdjustTop:
    mov al, pathTop
    mov ballY, al
    ret
AdjustBottom:
    mov al, pathBottom
    mov ballY, al
    ret
CheckBoundaries ENDP
CheckCollision PROC
    mov al, ballX
    cmp al, xPos
    jne NoCollisionX
    mov al, ballY
    cmp al, yPos
    jne NoCollisionY
    mov collisionFlag, 1
    mov spiralActive, 0
    ret
NoCollisionX:
    mov collisionFlag, 0
    ret
NoCollisionY:
    mov collisionFlag, 0
    ret
CheckCollision ENDP
    ShootBall PROC
        mov al, current_ball_index
        movzx eax, al
        mov dl, ball_colors[eax]
        movzx eax, dl
        call SetTextColor
        mov dl, xPos
        mov dh, yPos
        call FireBall
        ret
    ShootBall ENDP

InputLoop PROC

    call ReadKey
    mov inputChar, al


    cmp inputChar, VK_TAB
    je SwitchBall


    cmp inputChar, VK_SPACE
    je ShootBall


    ret



    ret
InputLoop ENDP
RedrawPlayer PROC

    push dx
    mov dl, xPosPrev
    mov dh, yPosPrev
    call Gotoxy
    mWrite " "


    mov al, xPos
    mov xPosPrev, al
    mov al, yPos
    mov yPosPrev, al


    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    movzx eax, current_color
    call SetTextColor
    mWrite "O"

    pop dx
    ret
RedrawPlayer ENDP

    RandomizeBallColors PROC
    mov ecx, 0
        mov cl, num_balls
        mov edi, offset ball_colors
    randomize_loop:
        mov eax, 3
        call RandomRange
        cmp eax, 0
        je assign_red
        cmp eax, 1
        je assign_green
        cmp eax, 2
        je assign_blue
    assign_red:
        mov byte ptr [edi], 4
        jmp next_ball
    assign_green:
        mov byte ptr [edi], 2
        jmp next_ball
    assign_blue:
        mov byte ptr [edi], 1
    next_ball:
        inc edi
        loop randomize_loop
        ret
    RandomizeBallColors ENDP
    DrawBalls PROC
        movzx ecx, num_balls
        mov esi, offset ball_positions
        mov edi, offset ball_colors
    draw_loop:
        mov dl, byte ptr [esi]
        inc esi
        mov dh, byte ptr [esi]
        inc esi
        cmp dl, 2
        jl adjust_x
        cmp dl, 77
        jg adjust_x
        cmp dh, 3
        jl adjust_y
        cmp dh, 23
        jg adjust_y
        jmp draw_ball
    adjust_x:
        mov dl, 5
    adjust_y:
        mov dh, 5
    draw_ball:
        movzx eax, byte ptr [edi]
        call SetTextColor
        call Gotoxy
        mWrite <"O">
        inc edi
        loop draw_loop
        ret
    DrawBalls ENDP
    DrawPaths PROC
        movzx eax, pathColor
        call SetTextColor
        mov dh, pathTop
        mov dl, pathLeft
    DrawTopBoundary:
        call Gotoxy
        mWrite "."
        inc dl
        cmp dl, pathRight
        jle DrawTopBoundary
        mov dh, pathBottom
        mov dl, pathLeft
    DrawBottomBoundary:
        call Gotoxy
        mWrite "."
        inc dl
        cmp dl, pathRight
        jle DrawBottomBoundary
        mov dl, pathLeft
        mov dh, pathTop
    DrawLeftBoundary:
        call Gotoxy
        mWrite "."
        inc dh
        cmp dh, pathBottom
        jle DrawLeftBoundary
        mov dl, pathRight
        mov dh, pathTop
    DrawRightBoundary:
        call Gotoxy
        mWrite "."
        inc dh
        cmp dh, pathBottom
        jle DrawRightBoundary
        mov eax, White
        call SetTextColor
        ret
    DrawPaths ENDP
GameLoop PROC
GameLoopStart:
    call MovePlayer
    mov al, spiralActive
    cmp al, 1
    je HandleBallMovement
SkipBallMovement:
    call PrintPlayer
    call DisplayBall
    mov eax, 50
    call Delay
    jmp GameLoopStart
HandleBallMovement:
    call MoveSpiralStep
    jmp SkipBallMovement
    ret
GameLoop ENDP
MoveSpiralStep PROC
    mov al, spiralActive
    cmp al, 1
    jne SpiralEnd
    mov al, stepsRightLeft
    call MoveRightWithPlayerUpdates
    cmp spiralActive, 1
    jne SpiralEnd
    mov al, stepsDown
    call MoveDownWithPlayerUpdates
    cmp spiralActive, 1
    jne SpiralEnd
    mov al, stepsRightLeft
    dec al
    call MoveLeftWithPlayerUpdates
    cmp spiralActive, 1
    jne SpiralEnd
    mov al, stepsDown
    dec al
    call MoveUpWithPlayerUpdates
    cmp spiralActive, 1
    jne SpiralEnd
    mov al, stepsRightLeft
    cmp al, 2
    jb SpiralEnd
    sub al, 2
    mov stepsRightLeft, al
    mov al, stepsDown
    cmp al, 2
    jb SpiralEnd
    sub al, 2
    mov stepsDown, al
    call HandlePlayerInputAndCollision
SpiralEnd:
    ret
MoveSpiralStep ENDP
HandlePlayerInputAndCollision PROC
    call MovePlayer
    call CheckCollision
    cmp collisionFlag, 1
    je CollisionDetected
    mov eax, 50
    call Delay
    ret
CollisionDetected:
    mov spiralActive, 0
    ret
HandlePlayerInputAndCollision ENDP

MovePlayer PROC
    mov eax, 0
    call ReadKey
    mov inputChar, al
    cmp inputChar, VK_TAB
    je SwitchBall
    mov inputChar, al
    cmp inputChar, 'w'
    je ChangeDirection
    cmp inputChar, 'a'
    je ChangeDirection
    cmp inputChar, 's'
    je ChangeDirection
    cmp inputChar, 'd'
    je ChangeDirection
    cmp inputChar, 'q'
    je ChangeDirection
    cmp inputChar, 'e'
    je ChangeDirection
    cmp inputChar, 'z'
    je ChangeDirection
    cmp inputChar, 'c'
    je ChangeDirection

    cmp inputChar, ' '
    je HandleShoot

    cmp inputChar, 'P'
    je PauseGame
    ret
ChangeDirection:
    mov al, inputChar
    mov direction, al
    call PrintPlayer
    ret
HandleShoot:
    call ShootBall
    ret
MovePlayer ENDP

PauseGame PROC

    mov dl, 40
    mov dh, 12
    call Gotoxy
    mov eax, Yellow + (Black * 16)
    call SetTextColor
    mWrite <"GAME PAUSED - PRESS 'P' TO RESUME">

WaitForUnpause:

    call ReadKey
    mov inputChar, al
    cmp inputChar, 'P'
    jne WaitForUnpause


    mov dl, 40
    mov dh, 12
    call Gotoxy
    mWrite <"                                     ">
    ret
PauseGame ENDP



MoveRightWithPlayerUpdates PROC
    movzx ecx, al
MoveRightLoop:
    call MovePlayer
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, dotColor
    call SetTextColor
    mWrite "."
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, 07h
    mWrite " "
    inc byte ptr [ballX]
    call CheckBoundaries
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, ballColor
    call SetTextColor
    mWrite "O"
    call CheckCollision
    cmp collisionFlag, 1
    je CollisionDetected
    mov eax, 100
    call Delay
    dec ecx
    cmp ecx, 0
    jnz MoveRightLoop
    ret
CollisionDetected:
    mov spiralActive, 0
    ret
MoveRightWithPlayerUpdates ENDP
MoveDownWithPlayerUpdates PROC
    movzx ecx, al
MoveDownLoop:
    call MovePlayer
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, dotColor
    call SetTextColor
    mWrite "."
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, 07h
    mWrite " "
    inc byte ptr [ballY]
    call CheckBoundaries
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, ballColor
    call SetTextColor
    mWrite "O"
    call CheckCollision
    cmp collisionFlag, 1
    je CollisionDetected
    mov eax, 100
    call Delay
    dec ecx
    cmp ecx, 0
    jnz MoveDownLoop
    ret
CollisionDetected:
    mov spiralActive, 0
    ret
MoveDownWithPlayerUpdates ENDP
MoveLeftWithPlayerUpdates PROC
    movzx ecx, al
MoveLeftLoop:
    call MovePlayer
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, dotColor
    call SetTextColor
    mWrite "."
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, 07h
    mWrite " "
    dec byte ptr [ballX]
    call CheckBoundaries
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, ballColor
    call SetTextColor
    mWrite "O"
    call CheckCollision
    cmp collisionFlag, 1
    je CollisionDetected
    mov eax, 100
    call Delay
    dec ecx
    cmp ecx, 0
    jnz MoveLeftLoop
    ret
CollisionDetected:
    mov spiralActive, 0
    ret
MoveLeftWithPlayerUpdates ENDP
MoveUpWithPlayerUpdates PROC
    movzx ecx, al
MoveUpLoop:
    call MovePlayer
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, dotColor
    call SetTextColor
    mWrite "."
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, 07h
    mWrite " "
    dec byte ptr [ballY]
    call CheckBoundaries
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, ballColor
    call SetTextColor
    mWrite "O"
    call CheckCollision
    cmp collisionFlag, 1
    je CollisionDetected
    mov eax, 100
    call Delay
    dec ecx
    cmp ecx, 0
    jnz MoveUpLoop
    ret
CollisionDetected:
    mov spiralActive, 0
    ret
MoveUpWithPlayerUpdates ENDP
    CheckCenter PROC
        movzx eax, ballX
        movzx ebx, xPos
        cmp eax, ebx
        jne not_center
        movzx eax, ballY
        movzx ebx, yPos
        cmp eax, ebx
        je is_center
    not_center:
        mov al, 0
        ret
    is_center:
        mov al, 1
        ret
    CheckCenter ENDP
    DrawBall PROC
        mov dl, ballX
        mov dh, ballY
        call Gotoxy
        movzx eax, ballColor
        call SetTextColor
        mWrite <"O">
        ret
    DrawBall ENDP
    FireBall PROC
        mov dl, xPos
        mov dh, yPos
        mov fire_col, dl
       mov fire_row, dh
        mov al, direction
        cmp al, "w"
        je fire_up
        cmp al, "x"
        je fire_down
        cmp al, "a"
        je fire_left
        cmp al, "d"
        je fire_right
        cmp al, "q"
        je fire_upleft
        cmp al, "e"
        je fire_upright
        cmp al, "z"
        je fire_downleft
        cmp al, "c"
        je fire_downright
        jmp end_fire
    fire_up:
        mov fire_row, 14
        mov fire_col, 57
        mov xDir, 0
        mov yDir, -1
        jmp fire_loop
    fire_down:
        mov fire_row, 18
        mov fire_col, 57
        mov xDir, 0
        mov yDir, 1
        jmp fire_loop
    fire_left:
        mov fire_col, 55
        mov fire_row, 16
        mov xDir, -1
        mov yDir, 0
        jmp fire_loop
    fire_right:
        mov fire_col, 59
        mov fire_row, 16
        mov xDir, 1
        mov yDir, 0
        jmp fire_loop
    fire_upleft:
        mov fire_row, 14
        mov fire_col, 55
        mov xDir, -1
        mov yDir, -1
        jmp fire_loop
    fire_upright:
        mov fire_row, 14
        mov fire_col, 59
        mov xDir, 1
        mov yDir, -1
        jmp fire_loop
    fire_downleft:
        mov fire_row, 18
        mov fire_col, 55
        mov xDir, -1
        mov yDir, 1
        jmp fire_loop
    fire_downright:
        mov fire_row, 18
        mov fire_col, 59
        mov xDir, 1
        mov yDir, 1
        jmp fire_loop
    fire_loop:
        mov dl, fire_col
        mov dh, fire_row
        call GoToXY
        L1:
            cmp dl, 20
            jle end_fire
            cmp dl, 96
            jge end_fire
            cmp dh, 5
            jle end_fire
            cmp dh, 27
            jge end_fire
            movzx eax, fire_color
            call SetTextColor
            add dl, xDir
            add dh, yDir
            call Gotoxy
            mWrite "*"
            mov eax, 50
            call Delay
            call GoToXY
            mWrite " "
            jmp L1
        end_fire:
            mov dx, 0
            call GoToXY
        ret
    FireBall ENDP
    DrawWall PROC
	    call clrscr
        mov dl,19
	    mov dh,2
	    call Gotoxy
	    mWrite <"Score: ">
	    mov eax, Blue + (black * 16)
	    call SetTextColor
	    mov al, score
	    call WriteDec
        mov eax, White + (black * 16)
	    call SetTextColor
	    mov dl,90
	    mov dh,2
	    call Gotoxy
	    mWrite <"Lives: ">
	    mov eax, Red + (black * 16)
	    call SetTextColor
	    mov al, lives
	    call WriteDec
	    mov eax, white + (black * 16)
	    call SetTextColor
	    mov dl,55
	    mov dh,2
	    call Gotoxy
	    mWrite "LEVEL "
	    mov al, levelInfo
	    call WriteDec
	    mov eax, gray + (black*16)
	    call SetTextColor
	    mov dl, 19
	    mov dh, 4
	    call Gotoxy
	    mov esi, offset walls
	    mov counter1, 50
	    mov counter2, 80
	    movzx ecx, counter1
	    printcolumn:
		    mov counter1, cl
		    movzx ecx, counter2
		    printrow:
			    mov eax, [esi]
			    call WriteChar
			    inc esi
		    loop printrow
            dec counter1
		    movzx ecx, counter1
		    mov dl, 19
		    inc dh
		    call Gotoxy
	    loop printcolumn
	    ret
    DrawWall ENDP
    PrintPlayer PROC
        mov al, current_ball_index
        cmp al, 0
        je set_red
        cmp al, 1
        je set_green
        cmp al, 2
        je set_blue
    set_red:
        mov eax, Red + (Black * 16)
        call SetTextColor
        jmp draw_player
    set_green:
        mov eax, Green + (Black * 16)
        call SetTextColor
        jmp draw_player
    set_blue:
        mov eax, Blue + (Black * 16)
        call SetTextColor
    draw_player:
        mov al, direction
        cmp al, "w"
        je print_up
        cmp al, "x"
        je print_down
        cmp al, "a"
        je print_left
        cmp al, "d"
        je print_right
        cmp al, "q"
        je print_upleft
        cmp al, "e"
        je print_upright
        cmp al, "z"
        je print_downleft
        cmp al, "c"
        je print_downright
        ret
    print_up:
        mov esi, offset player_up
        jmp render
    print_down:
        mov esi, offset player_down
        jmp render
    print_left:
        mov esi, offset player_left
        jmp render
    print_right:
        mov esi, offset player_right
        jmp render
    print_upleft:
        mov esi, offset player_upleft
        jmp render
    print_upright:
        mov esi, offset player_upright
        jmp render
    print_downleft:
        mov esi, offset player_downleft
        jmp render
    print_downright:
        mov esi, offset player_downright
        jmp render
    render:
        mov dl, xPos
        mov dh, yPos
        call Gotoxy
        mov counter1, 3
        mov counter2, 4
        movzx ecx, counter1
    draw_rows:
        mov counter1, cl
        movzx ecx, counter2
    draw_chars:
        mov al, [esi]
        call WriteChar
        inc esi
        loop draw_chars
        movzx ecx, counter1
        mov dl, xPos
        inc dh
        call Gotoxy
        loop draw_rows
        ret
    PrintPlayer ENDP
    InitialiseScreen PROC
        call DrawWall
        call DrawPaths
        mov al, pathLeft
        mov ballX, al
        mov al, pathTop
        mov ballY, al
        call DisplayBall
        call PrintPlayer
        ret
    InitialiseScreen ENDP
    ShrinkPath PROC
        inc pathTop
        inc pathLeft
        dec pathRight
        dec pathBottom
        mov al, pathRight
        sub al, pathLeft
        cmp al, minPathSize
        jle EndGame
        call DrawPaths
        call DisplayBall
        call PrintPlayer
        ret
    EndGame:
        call Clrscr
        mov dl, 30
        mov dh, 15
        call Gotoxy
        mWrite <"Game Over! Path is fully shrunk.">
        call Delay
        exit
        ret
    ShrinkPath ENDP
    MoveBallPattern PROC
        mov al, x
        cmp al, 0
        jle terminate
        mov al, y
        cmp al, 0
        jle terminate
        mov al, x
        call MoveRightTimes
        call CheckCenter
        cmp al, 1
        je terminate
        mov bl, y
        call MoveDownTimes
        call CheckCenter
        cmp al, 1
        je terminate
        mov al, x
        call MoveLeftTimes
        call CheckCenter
        cmp al, 1
        je terminate
        mov bl, y
        call MoveUpTimes
        call CheckCenter
        cmp al, 1
        je terminate
        mov al, x
        dec al
        mov x, al
        mov bl, y
        dec bl
        mov y, bl
        call MoveBallPattern
    terminate:
        ret
    MoveBallPattern ENDP
MoveRightTimes PROC
    movzx ecx, al
MoveRightLoop:
    call MovePlayer
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, dotColor
    call SetTextColor
    mWrite "."
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, 07h
    mWrite " "
    inc byte ptr [ballX]
    call CheckBoundaries
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, ballColor
    call SetTextColor
    mWrite "O"
    movzx eax, currentBallSpeed
    imul eax, 5
    call Delay
    dec ecx
    jnz MoveRightLoop
    ret
MoveRightTimes ENDP
MoveLeftTimes PROC
    movzx ecx, al
MoveLeftLoop:
    call MovePlayer
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, dotColor
    call SetTextColor
    mWrite "."
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, 07h
    mWrite " "
    dec byte ptr [ballX]
    call CheckBoundaries
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, ballColor
    call SetTextColor
    mWrite "O"
    movzx eax, currentBallSpeed
    imul eax, 5
    call Delay
    dec ecx
    jnz MoveLeftLoop
    ret
MoveLeftTimes ENDP
MoveUpTimes PROC
    movzx ecx, al
MoveUpLoop:
    call MovePlayer
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, dotColor
    call SetTextColor
    mWrite "."
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, 07h
    mWrite " "
    dec byte ptr [ballY]
    call CheckBoundaries
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, ballColor
    call SetTextColor
    mWrite "O"
    movzx eax, currentBallSpeed
    imul eax, 5
    call Delay
    dec ecx
    jnz MoveUpLoop
    ret
MoveUpTimes ENDP
MoveDownTimes PROC
    movzx ecx, al
MoveDownLoop:
    call MovePlayer
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, dotColor
    call SetTextColor
    mWrite "."
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, 07h
    mWrite " "
    inc byte ptr [ballY]
    call CheckBoundaries
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov ah, ballColor
    call SetTextColor
    mWrite "O"
    movzx eax, currentBallSpeed
    imul eax, 5
    call Delay
    dec ecx
    jnz MoveDownLoop
    ret
MoveDownTimes ENDP



main PROC

    call MainMenu
    call InitialiseScreen
    call RandomizeBallColors
    call DisplayBall
    call PrintPlayer
    mov stepsRightLeft, 40
    mov stepsDown, 20
    mov stepsUp, 40
    mov spiralActive, 1
    call GameLoop
    invoke ExitProcess, 0
    ret
main ENDP
END main
END main



