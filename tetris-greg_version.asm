################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Brittany Lansang, 100 825 5406
# Student 2: Gregory Gismondi, 100 891 0467
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       2
# - Unit height in pixels:      2
# - Display width in pixels:    64
# - Display height in pixels:   64
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################
# The current x coordinate for the I piece
current_i_x: 
    .word 4
# The current y coordinate for the I 
current_i_y: 
    .word 0
# The colour of the I piece     
i_colour:   
    .word 0x00FFFF
# The dark gray colour of the checkerboard gird
dark_checkerboard:
    .word 0x222831
# The light gray colour of the checkerboard gird
light_checkerboard:
    .word 0x31363F
# The colour of the walls and floor
wall_colour: 
    .word 0x3b3b3b
i_orientation:
    .word 0
i_length:
    .word 1
background:
    .space 4096
midis: 
    .word 76 52 64 71 52 72 64 74 52 64 72 52 71 64 69 45 57 69 45 72 57 76 45 57 74 45 72 57 71 44 56 71 44 72 56 74 44 56 76 44 56 72 45 57 69 45 57 69 45 57 47 59 48 60 50 62 74 50 62 77 50 81 62 50 62 79 50 77 62 76 48 60 48 60 72 48 76 60 48 60 74 48 72 60 71 44 56 44 72 56 74 44 56 76 44 56 72 45 57 69 45 57 69 45 57 45 57 76 45 57 45 57 72 45 57 45 57 74 44 56 44 56 71 44 56 44 56 72 45 57 45 57 69 45 57 45 57 68 44 56 44 56 71 44 56 44 56 76 45 57 45 57 72 45 57 45 57 74 44 56 44 56 71 44 56 44 56 72 45 57 76 45 57 81 45 57 45 57 80 44 56 44 56 44 56 44 56
midi_shift:
    .word 0
times:
    .word 0 262 248 0 247 0 249 0 251 252 0 254 0 259 0 270 248 0 247 0 249 0 249 246 0 247 0 250 0 264 248 0 247 0 249 0 249 246 0 247 250 0 264 248 0 247 249 0 249 246 0 247 0 250 264 248 0 247 249 0 249 0 246 247 250 0 264 0 248 0 247 249 249 246 0 247 0 250 264 248 0 247 0 249 0 249 246 247 0 250 0 264 248 0 247 249 0 249 246 0 247 250 0 264 248 247 250 0 264 248 247 249 0 249 246 247 250 0 264 248 247 249 0 249 246 247 250 0 264 248 247 249 0 249 246 247 250 0 264 248 247 249 0 249 246 247 250 0 264 248 247 249 0 249 246 247 250 0 264 248 247 249 0 249 246 247 250 0 264 248 0 247 249 0 249 246 247 250 0 264 248 247 249 249 246 247
time_shift:
    .word 0
cleared_lines:
    .space 16
cleared_lines_len:
    .word 0

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Tetris game.
main:
    # Initialize the game
    
##############################################################################
# MILESTONE 1
##############################################################################

    lw $t0, ADDR_DSPL  # $t0 = base address for display

    # draw left wall
    addi $a0, $zero, 0      # set x coordinate of line to 1
    addi $a1, $zero, 0      # set y coordinate of line to 1
    addi $a2, $zero, 1      # set length of line to 1
    addi $a3, $zero, 32     # set height of line to 32
    jal draw_rectangle      # call the rectangle-drawing function

    # draw right wall
    addi $a0, $zero, 11      # set x coordinate of line to 32
    addi $a1, $zero, 0      # set y coordinate of line to 0
    addi $a2, $zero, 1      # set length of line to 1
    addi $a3, $zero, 32     # set height of line to 32
    jal draw_rectangle      # call the rectangle-drawing function

    # draw floor
    addi $a0, $zero, 0     # set x coordinate of line to 0
    addi $a1, $zero, 31     # set y coordinate of line to 31
    addi $a2, $zero, 11     # set length of line to 31
    addi $a3, $zero, 1      # set height of line to 1
    jal draw_rectangle      # call the rectangle-drawing function
    
    # draw dark part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_dark_grid      # call the rectangle-drawing function
    
    # draw light part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_light_grid     # call the rectangle-drawing function
    
    jal save_background
    
    #draw I piece
    la $t7, current_i_x  # Load the piece_I_x label's address into $t7
    lw $a0, 0($t7)  # Fetch x position of the piece and store in $a1
    la $t7, current_i_y  # Load the piece_I_y label's address into $t7
    lw $a1, 0($t7)  # Fetch y position of the piece and store in $a2
    addi $a2, $zero, 1     # set length of line to 1
    addi $a3, $zero, 4    # set height of line to 4
    jal draw_tetromino     # call the tetromino-drawing function
    j game_loop
    
##################### BACKGROUND FUNCTION ###################################
save_background:
# $t6 = Location of first pixel in current background
# $t7 = Location of first pixel in saved background
# $t8 = Loop Variable
# $t9 = Value of array at index $t0 

lw $t6, ADDR_DSPL
la $t7, background
add $t8, $zero, $zero

array_top:
addi $t8, $t8, 1                    # Increment t0 by 1
lw $t9, 0($t6)                      # Fetch the current value in array
sw $t9, 0($t7)                      # Store current value in array2

beq $t8, 1024, array_end            # Check if loop bound was reached

addi $t6, $t6, 4                    # Moves to next index of array
addi $t7, $t7, 4                    # Moves to next index of array2
j array_top
array_end:

jr $ra

############################################################################

#################### LOAD BACKGROUND #######################################

# $t6 = Location of first pixel in current background
# $t7 = Location of first pixel in saved background
# $t8 = Loop Variable
# $t9 = Value of array at index $t0
load_background:
lw $t6, ADDR_DSPL
la $t7, background
add $t8, $zero, $zero

load_top:

addi $t8, $t8, 1                    # Increment t0 by 1
lw $t9, 0($t7)                      # Fetch the current value in array
sw $t9, 0($t6)                      # Store current value in array2

beq $t8, 1024, array_end            # Check if loop bound was reached

addi $t6, $t6, 4                    # Moves to next index of array
addi $t7, $t7, 4                    # Moves to next index of array2
j load_top

load_end:
jr $ra

############################################################################

# The code for drawing a horizontal line and grid
# - $a0: the x coordinate of the starting point for this line.
# - $a1: the y coordinate of the starting point for this line.
# - $a2: the length of this line, measured in pixels
# - $a3: the height of this line, measured in pixels
# - $t0: the address of the first pixel (top left) in the bitmap
# - $t1: the horizontal offset of the first pixel in the line.
# - $t2: the vertical offset of the first pixel in the line.
# - #t3: the location in bitmap memory of the current pixel to draw 
# - $t4: the colour value to draw on the bitmap
# - $t5: the bitmap location for the end of the horizontal line.
# - $t6: the bitmap location for the end of the vertical line.
# - $t7: stores the colour for the function
# - $t8: Pixel shift amount

draw_light_grid:
add $t8, $zero, $zero       # Sets initial offset to 0
sll $t2, $a1, 7             # convert vertical offset to pixels (by multiplying $a1 by 128, equivalent to logical left shifts)
sll $t6, $a3, 7             # convert height of rectangle from pixels to rows of bytes (by multiplying $a3 by 128)
add $t6, $t2, $t6           # calculate value of $t2 for the last line in the rectangle.
la $t7, light_checkerboard  # fetch wall_colour label address

outer_top_lg:
sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4)
sll $t5, $a2, 2         # convert length of line from pixels to bytes (by multiplying $a2 by 4)
add $t5, $t1, $t5       # calculate value of $t1 for end of the horizontal line.

beq $t8, $zero, no_offset # Checks if the offset is equal to zero - if so breaks to no_offset label

# Offset is equal to 4
add $t1, $t8, $t1       # Adds offset to starting pixel
add $t5, $t8, $t5       # Adds offset to ending pixel
add $t8, $zero, $zero   # Resets offset to 0 - makes sure next row won't offset
j inner_top_lg          # Jumps to beginning of loop

no_offset:
addi $t8, $zero, 4      # Sets offset to 4 - makes sure next row will offset

inner_top_lg:
add $t3, $t1, $t2           # store the total offset of the starting pixel (relative to $t0)
add $t3, $t0, $t3           # calculate the location of the starting pixel ($t0 + offset)

lw $t4, 0($t7)              # load into $t4 = darker gray for the walls

sw $t4, 0($t3)              # paint the current unit on the first row yellow
addi $t1, $t1, 8            # move horizontal offset to the right by two pixels
beq $t1, $t5, inner_end_lg  # break out of the line-drawing loop
j inner_top_lg              # jump to the start of the inner loop
inner_end_lg:

addi $t2, $t2, 128          # move vertical offset down by one line
beq $t2, $t6, outer_end_lg  # on last line, break out of the outer loop
j outer_top_lg              # jump to the top of the outer loop
outer_end_lg:
jr $ra                      # return to calling program

draw_dark_grid:
sll $t2, $a1, 7             # convert vertical offset to pixels (by multiplying $a1 by 128, equivalent to logical left shifts)
sll $t6, $a3, 7             # convert height of rectangle from pixels to rows of bytes (by multiplying $a3 by 128)
add $t6, $t2, $t6           # calculate value of $t2 for the last line in the rectangle.
la $t7, dark_checkerboard   # fetch wall_colour label address

outer_top_dg:
sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4)
sll $t5, $a2, 2         # convert length of line from pixels to bytes (by multiplying $a2 by 4)
add $t5, $t1, $t5       # calculate value of $t1 for end of the horizontal line.

inner_top_dg:
add $t3, $t1, $t2           # store the total offset of the starting pixel (relative to $t0)
add $t3, $t0, $t3           # calculate the location of the starting pixel ($t0 + offset)

lw $t4, 0($t7)              

sw $t4, 0($t3)              # paint the current unit on the first row yellow
addi $t1, $t1, 4            # move horizontal offset to the right by one pixel
beq $t1, $t5, inner_end_dg  # break out of the line-drawing loop
j inner_top_dg              # jump to the start of the inner loop
inner_end_dg:

addi $t2, $t2, 128          # move vertical offset down by one line
beq $t2, $t6, outer_end_dg  # on last line, break out of the outer loop
j outer_top_dg              # jump to the top of the outer loop
outer_end_dg:
jr $ra                      # return to calling program

# Code taken from lecture

draw_rectangle:
sll $t2, $a1, 7         # convert vertical offset to pixels (by multiplying $a1 by 128, equivalent to logical left shifts)
sll $t6, $a3, 7         # convert height of rectangle from pixels to rows of bytes (by multiplying $a3 by 128)
add $t6, $t2, $t6       # calculate value of $t2 for the last line in the rectangle.

outer_top:
sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4)
sll $t5, $a2, 2         # convert length of line from pixels to bytes (by multiplying $a2 by 4)
add $t5, $t1, $t5       # calculate value of $t1 for end of the horizontal line.

inner_top:
add $t3, $t1, $t2           # store the total offset of the starting pixel (relative to $t0)
add $t3, $t0, $t3           # calculate the location of the starting pixel ($t0 + offset)

la $t7, wall_colour     # fetch wall_colour label address
lw $t4, 0($t7)          # load wall colour and store into $t4

sw $t4, 0($t3)              # paint the current unit on the first row yellow
addi $t1, $t1, 4            # move horizontal offset to the right by one pixel
beq $t1, $t5, inner_end     # break out of the line-drawing loop
j inner_top                 # jump to the start of the inner loop
inner_end:

addi $t2, $t2, 128          # move vertical offset down by one line
beq $t2, $t6, outer_end     # on last line, break out of the outer loop
j outer_top                 # jump to the top of the outer loop
outer_end:
jr $ra                      # return to calling program

# Similar Code to draw_rectangle
draw_tetromino:
	sll $t2, $a1, 7         # convert vertical offset to pixels (by multiplying $a1 by 128, equivalent to logical left shifts)
	sll $t6, $a3, 7         # convert height of rectangle from pixels to rows of bytes (by multiplying $a3 by 128)
	add $t6, $t2, $t6       # calculate value of $t2 for the last line in the rectangle.
	outer_tetromino_top:
	sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4)
	sll $t5, $a2, 2         # convert length of line from pixels to bytes (by multiplying $a2 by 4)
	add $t5, $t1, $t5       # calculate value of $t1 for end of the horizontal line.
	
	inner_tetromino_top:
	add $t3, $t1, $t2           # store the total offset of the starting pixel (relative to $t0)
	add $t3, $t0, $t3           # calculate the location of the starting pixel ($t0 + offset)
	
	la $t7, i_colour           # load i_colour label's address into $t7
	lw $t4, 0($t7)             # load wall colour and store into $t4t4

    sw $t4, 0($t3)                      # paint the current unit on the first row the specified colour in $t4
	addi $t1, $t1, 4                       # move horizontal offset to the right by one pixel
	beq $t1, $t5, inner_tetromino_end     # break out of the line-drawing loop
	j inner_tetromino_top                 # jump to the start of the inner loop
	inner_tetromino_end:
	
	addi $t2, $t2, 128          # move vertical offset down by one line
	beq $t2, $t6, outer_tetromino_end     # on last line, break out of the outer loop
	j outer_tetromino_top                 # jump to the top of the outer loop
	outer_tetromino_end:
	jr $ra

game_loop:
##############################################################################
# MILESTONE 2
##############################################################################
    # 1a. Check if key has been pressed
    jal play_song
    
    syscall
    li $v0, 32
    li $a0, 250
    
    syscall
    lw $t1, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t2, 0($t1)                  # load first word from keyboard
    beq $t2, 1, keyboard_input      # key is pressed
    beq $t2, 0, end_game_loop       # no key pressed, loop back and wait for the next keyboard input
      
    keyboard_input:
        lw $t1, ADDR_KBRD               # load the keyboard_address into $t1
        lw $t2, 4($t1)                  # load second word from keyboard
        beq $t2, 0x71, respond_to_Q     # check if the key q was pressed
        beq $t2, 0x77, respond_to_W     # check if the key w was pressed
        beq $t2, 0x61, respond_to_A     # check if the key a was pressed
        beq $t2, 0x73, respond_to_S     # check if the key s was pressed
        beq $t2, 0x64, respond_to_D     # check if the key d was pressed
        
    # 2a. Check for collisions
    # 2b. Update locations (paddle, ball)
    # 3. Draw the screen
    # 4. Sleep
    
    #5. Go back to 1
    end_game_loop:
    b game_loop 
    
respond_to_Q:
	li $v0, 10                      # Quit gracefully
	syscall
	
# Rotates tetromino
respond_to_W: 
	la $t7, i_orientation  # load orientation address into $t7
	lw $t4, 0($t7)  # load orientation of i and store in $t4
	beq $t4, 0, i_rotate_90 # rotate 90 degrees if i in default orientation 
	beq $t4, 90, i_rotate_180 # rotate 180 degrees from default orientation if i has been rotated 90 degrees
	beq $t4, 180, i_rotate_270 # rotate 270 degrees from default orientation if i has been rotated 180 degrees 
	beq $t4, 270, i_rotate_0 # rotate to default orientation if i has been rotated 270 degrees


i_rotate_90:
	lw $t0, ADDR_DSPL # reset display address
	
    # redraw grid (same arguments passed from initialization)
    # draw dark part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_dark_grid      # call the rectangle-drawing function
    
    # # draw light part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_light_grid     # call the rectangle-drawing function
    
    jal load_background

	# draw rotated tetromino
	lw $t0, ADDR_DSPL # reset display address
	la $t7, i_rotate_90  # load address into $t7
	lw $t4, 0($t7)  # load orientation and store into $t4
	la $t7, current_i_x  # load current address for x coordinate into $t7
	lw $a0, 0($t7)  # load current orientation and store
	
	#if x is one, coordinate next to wall then do not rotate there is no room
	# beq $a0, 1, stay_current_location
	# beq $a0, 2, stay_current_location
	
	#if x is less than or equal to 2, there is no room to shift so stay current 
	ble $a0, 2, stay_current_location
	beq $a0, 10, stay_current_location

	# otherwise draw the new rotated
	addi $a0, $a0, -2   # starting x coordinate shifted 2 units left
	sw $a0, 0($t7) # update new x coordinate
	
	la $t7, current_i_y  # load current address for y coordinate into $t7
	lw $a1, 0($t7)  # load current orientation and store
	addi $a1, $a1, 2   # starting y coordinate shifted 2 units left
	sw $a1, 0($t7)     # update new x coordinate
	
	addi $a2, $zero, 4     # set length of line to 4
	addi $a3, $zero, 1    # set height of line to 1
	
	# update the tetromino's orientation value in .data 
	la $t7, i_orientation  # load address into $t7
	lw $t4, 0($t7)  
	addi $t4, $t4, 90 # rotate 90 degrees
	sw $t4, 0($t7) # Update new orientation
	
	jal draw_tetromino     # redraw rotated tetromino
	j game_loop


i_rotate_180:
	lw $t0, ADDR_DSPL # reset display address
	
    # redraw grid (same arguments passed from initialization)
    # draw dark part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_dark_grid      # call the rectangle-drawing function
    
    # # draw light part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_light_grid     # call the rectangle-drawing function
    
    jal load_background
	
	# draw rotated tetromino
	# repeat code from orientation 0
	lw $t0, ADDR_DSPL # reset display address
	la $t7, i_rotate_180  # load address into $t7
	lw $t4, 0($t7)  # load orientation and store into $t4
	la $t7, current_i_x  # load current address for x coordinate into $t7
	lw $a0, 0($t7)  # load current xcoordinate and store
	
	# la $t7, current_i_y
	# lw $a1, 0($t7)
	
	# check if room to rotate
	# bge $a1, 30, stay_current_location #COMMENT OUT FOR NOW
	
    #CHECKING IF CAN ROTATE
	la $t5, current_i_y
	lw $t5, 0($t5)
	bge $t5, 30, stay_current_location
	
	
	# changing new x and y coordinates
	addi $a0, $a0, 1   # starting x coordinate shifted 1 right 
	sw $a0, 0($t7) # update
	la $t7, current_i_y  
	lw $a1, 0($t7)  
	addi $a1, $a1, -2   #starting y coordinate shifted 2 up
	sw $a1, 0($t7) 
	
	addi $a2, $zero, 1     
	addi $a3, $zero, 4    
	
	la $t7, i_orientation  
	lw $t4, 0($t7)  
	addi $t4, $t4, 90 
	sw $t4, 0($t7) 
	
	jal draw_tetromino     
	j game_loop

#going to 270
i_rotate_270:
	lw $t0, ADDR_DSPL # reset display address
	
    # redraw grid (same arguments passed from initialization)
    # draw dark part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_dark_grid      # call the rectangle-drawing function
    
    # # draw light part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_light_grid     # call the rectangle-drawing function
    
    jal load_background
	
	# draw rotated piece
	lw $t0, ADDR_DSPL # reset display address
	la $t7, i_rotate_270  
	lw $t4, 0($t7)  
	
	la $t7, current_i_x  
	lw $a0, 0($t7)
	
	#IF i_x coordinate is 1, or coordinate is wall_x + 1, do not shift as there is no room
	beq $a0, 1, stay_current_location
	bge $a0, 9, stay_current_location # if x coordinate greater than 9 there is no more room to shift
	
	addi $a0, $a0, -1   
	sw $a0, 0($t7) 
	
	la $t7, current_i_y  
	lw $a1, 0($t7)  
	addi $a1, $a1, 1   
	sw $a1, 0($t7) 
	
	addi $a2, $zero, 4     
	addi $a3, $zero, 1    
	

	la $t7, i_orientation  
	lw $t4, 0($t7)  
	addi $t4, $t4, 90 
	sw $t4, 0($t7) 
	
	jal draw_tetromino

	j game_loop


i_rotate_0:

	lw $t0, ADDR_DSPL # reset display address
	
    # redraw grid (same arguments passed from initialization)
    # draw dark part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_dark_grid      # call the rectangle-drawing function
    
    # # draw light part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_light_grid     # call the rectangle-drawing 
    
    jal load_background
	
	#draw rotated tetromino
	lw $t0, ADDR_DSPL 
	la $t7, i_rotate_0  
	lw $t4, 0($t7)  
	
	la $t7, current_i_x  
	lw $a0, 0($t7) 
	
	la $t5, current_i_y
	lw $t5, 0($t5)
	bge $t5, 29, stay_current_location
	# la $t7, current_i_y
	# lw $a1, 0($t7)
	
	# bge $a1, 29, stay_current_location COMMENT OUT FOR NOW THIS CHECKS THE Y TO ROTATE OR NOT
		
	addi $a0, $a0, 2
	sw $a0, 0($t7) 
	
	la $t7, current_i_y  
	lw $a1, 0($t7)  
	addi $a1, $a1, -1   
	sw $a1, 0($t7) 
	
	
	addi $a2, $zero, 1     
	addi $a3, $zero, 4    
	
	la $t7, i_orientation  
	lw $t4, 0($t7)  
	add $t4, $zero, $zero 
	sw $t4, 0($t7) 
	
	jal draw_tetromino     

	j game_loop
	
respond_to_A:
    lw $t0, ADDR_DSPL # reset display address
    
    # redraw grid (same arguments passed from initialization)
    # draw dark part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_dark_grid      # call the rectangle-drawing function
    
    # # draw light part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_light_grid     # call the rectangle-drawing function
    
    jal load_background
    
    la $t7, current_i_x  
    lw $a0, 0($t7)  
    
    addi $a0, $a0, -1
    
    # check if this is equal to the coordinate for the left wall, if so go back to keyboard input
    beq, $a0, 0, stay_current_location # return to keyboard input don't do anything
    
    # PAINTING THE TETROMINO SHIFTED LEFT UNIT
    sw $a0, 0($t7) 
    
    la $t7, current_i_y  
    lw $a1, 0($t7)  

    la $t7, i_orientation 
    lw $t4, 0($t7)              
    
    beq $t4, 0, draw_i_vertical
    beq $t4, 180, draw_i_vertical
    beq $t4, 90, draw_i_horizontal
    beq $t4, 270, draw_i_horizontal     
    draw_i_vertical:
        addi $a2, $zero, 1      # set length of line to 1
        addi $a3, $zero, 4      # set height of line to 4
        jal draw_tetromino
        j game_loop
    draw_i_horizontal:
        addi $a2, $zero, 4      # set length of line to 4
        addi $a3, $zero, 1      # set height of line to 1
        jal draw_tetromino     
        j game_loop
        
stay_current_location:
la $t7, current_i_x
lw $a0, 0($t7)
la $t7, current_i_y
lw $a1, 0($t7)
la $t7, i_orientation
lw $t4, 0($t7)

beq $t4, 0, draw_i_vertical
beq $t4, 180, draw_i_vertical
beq $t4, 90, draw_i_horizontal
beq $t4, 270, draw_i_horizontal 

    draw_i_vertical:
        addi $a2, $zero, 1      # set length of line to 1
        addi $a3, $zero, 4      # set height of line to 4
        jal draw_tetromino
        j game_loop
    draw_i_horizontal:
        addi $a2, $zero, 4      # set length of line to 4
        addi $a3, $zero, 1      # set height of line to 1
        jal draw_tetromino     
        j game_loop

piece_drop:
    la $t7, current_i_x
    lw $a0, 0($t7)
    la $t7, current_i_y
    lw $a1, 0($t7)
    la $t7, i_orientation
    lw $t4, 0($t7)
    
    beq $t4, 0, draw_i_vertical_s
    beq $t4, 180, draw_i_vertical_s
    beq $t4, 90, draw_i_horizontal_s
    beq $t4, 270, draw_i_horizontal_s 

    draw_i_vertical_s:
        addi $a2, $zero, 1      # set length of line to 1
        addi $a3, $zero, 4      # set height of line to 4
        jal draw_tetromino
        j add_to_back
    draw_i_horizontal_s:
        addi $a2, $zero, 4      # set length of line to 4
        addi $a3, $zero, 1      # set height of line to 1
        jal draw_tetromino     
        j add_to_back
    
    add_to_back:
    jal save_background
    jal load_background
    
    la $t7, current_i_x
    addi $a0, $zero, 4
    sw $a0, 0($t7)
    
    la $t7, current_i_y
    add $a1, $zero, $zero
    sw $a1, 0($t7)
    
    la $t7, i_orientation
    add $t4, $zero, $zero
    sw $t4, 0($t7)    
    
    addi $a2, $zero, 1      # set length of line to 1
    addi $a3, $zero, 4      # set height of line to 4
    
    jal draw_tetromino
    
    j lines_checker

lines_checker:
    lw $t0, ADDR_DSPL
    addi $t3, $zero, 30 # starting y cord
    add $t1, $zero, $zero # Full rows
    la $t2, cleared_lines
    
    lines_checker_top:
    add $a0, $t3, $zero
    jal line_check
    
    beq $v0, 0, lines_checker_end # EMPTY LINE
    beq $v0, 2, semi_clear
    
    sw $t3, 0($t2)          # push the $ra register onto the stack.
    addi $t2, $t2, 4
    addi $t1, $t1, 1
    
    semi_clear:
    subi $t3, $t3, 1
    j lines_checker_top
    
    lines_checker_end:
    
    sw $t1, cleared_lines_len
    addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
    sw $t3, 0($sp)          # push the $t1 register onto the stack.
    
    beq $t1, 0, game_loop
    j pre_blinking

line_check:
    add $t9, $zero, $zero
    sll $t9, $a0, 7 # Multiply y by 128
    addi $t9, $t9, 4 # Skips first pixel (Wall)
    
    add $t8, $zero, $zero # Iteration
    add $t7, $zero, $zero # Num of empty
    lw $t6, ADDR_DSPL
    add $t6, $t6, $t9
    
    line_check_top:
    lw $t5 0($t6)
    bne $t5, 0x0, next_pixel
    addi $t7, $t7, 1
    
    next_pixel:
    addi $t8, $t8, 1
    beq $t8, 10, line_check_bottom
    
    addi $t6, $t6, 4
    
    j line_check_top
    
    line_check_bottom:
    
    beq $t7, 10, all_clear
    beq $t7, 0, full_line
    
    # Not fully empty but not full line
    addi $v0, $zero, 2
    jr $ra
    
    all_clear:
    addi $v0, $zero, 0
    jr $ra
    
    full_line:
    addi $v0, $zero, 1
    jr $ra

pre_blinking:
add $t9, $zero, $zero

blinking:
lw $t1, cleared_lines_len
la $t2, cleared_lines

addi $a0, $zero, 1     # set x coordinate of line to 0
addi $a2, $zero, 10     # set length of line to 31
addi $a3, $zero, 1      # set height of line to 1

blinking_top:
beq $t1, 0, blinking_bot

lw $t3, 0($t2)

add $a1, $t3, $zero     # set y coordinate of line to 31

addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
sw $t1, 0($sp)          # push the $t1 register onto the stack.
addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
sw $t2, 0($sp)          # push the $t1 register onto the stack.
addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
sw $t3, 0($sp)          # push the $t1 register onto the stack.
addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
sw $t9, 0($sp)          # push the $t1 register onto the stack.

jal draw_rectangle      # call the rectangle-drawing function

lw $t9, 0($sp)          # pop the $t1 register value from the stack.
addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.
lw $t3, 0($sp)          # pop the $t1 register value from the stack.
addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.
lw $t2, 0($sp)          # pop the $t1 register value from the stack.
addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.
lw $t1, 0($sp)          # pop the $t1 register value from the stack.
addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.

addi $t3, $t3, 4
subi $t1, $t1, 1
j blinking_top

blinking_bot:

li $v0, 32
li $a0, 100
syscall

addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
sw $t9, 0($sp)          # push the $t1 register onto the stack.

jal load_background

lw $t9, 0($sp)          # pop the $t1 register value from the stack.
addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.

beq $t9, 3, line_remover

addi $t9, $t9, 1

li $v0, 32
li $a0, 100
syscall

j blinking

line_remover:
    lw $t9, 0($sp)          # FIRST EMPTY LINE
    addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.
    
    addi $t0, $zero, 30     # CURRENT LINE
    add $t1, $zero, $zero   # NUMBER OF LINES TO SHIFT DOWN
    la $t2, cleared_lines
    lw $t3, cleared_lines_len
    
    sll $t3, $t3, 2
    add $t2, $t2, $t3
    
    addi $a0, $zero, 1     # set x coordinate of line to 0
    addi $a2, $zero, 10     # set length of line to 31
    addi $a3, $zero, 1      # set height of line to 1
    
    line_remover_top:
    beq $t9, $t0, line_remover_bottom
    
    lw $t3 0($t2)
    beq $t3, $t0, line_remover_bottom
    
    remove_full_row:
    add $a1, $zero, $t0
    
    addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
    sw $t0, 0($sp)          # push the $t1 register onto the stack.
    addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
    sw $t1, 0($sp)          # push the $t1 register onto the stack.
    addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
    sw $t2, 0($sp)          # push the $t1 register onto the stack.
    addi $sp, $sp, -4       # move the stack pointer to an empty location in memory
    sw $t9, 0($sp)          # push the $t1 register onto the stack.
    
    lw $t0, ADDR_DSPL
    jal draw_rectangle      # call the rectangle-drawing function
    
    lw $t9, 0($sp)          # pop the $t1 register value from the stack.
    addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.
    lw $t2, 0($sp)          # pop the $t1 register value from the stack.
    addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.
    lw $t1, 0($sp)          # pop the $t1 register value from the stack.
    addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.
    lw $t0, 0($sp)          # pop the $t1 register value from the stack.
    addi $sp, $sp, 4        # move the stack pointer to the current top of the stack.
    
    subi, $t2, $t2, 4
    
    j end_line_remove
    
    shift_row:
    
    j end_line_remove
    
    end_line_remove:
    subi, $t9, $t9, 1
    
    j line_remover_top
    
    line_remover_bottom:
    
    jal save_background
    j game_loop

#draw I piece
    # la $t7, current_i_x  # Load the piece_I_x label's address into $t7
    # lw $a0, 0($t7)  # Fetch x position of the piece and store in $a1
    # la $t7, current_i_y  # Load the piece_I_y label's address into $t7
    # lw $a1, 0($t7)  # Fetch y position of the piece and store in $a2
    # addi $a2, $zero, 1     # set length of line to 1
    # addi $a3, $zero, 4    # set height of line to 4
    # jal draw_tetromino     # call the tetromino-drawing function
    # j game_loop
    

respond_to_S:
    lw $t0, ADDR_DSPL # reset display address
    # redraw grid (same arguments passed from initialization)
    
    # draw dark part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 1
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_dark_grid      # call the rectangle-drawing function
    
    # # draw light part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_light_grid     # call the rectangle-drawing function
    
    jal load_background
    
    la $t7, current_i_x  # load the current x coordinate address into $t7
    lw $a0, 0($t7)  # load x position and store in $a0
    la $t7, current_i_y  # load the current y coordinate address into $t7
    lw $a1, 0($t7)  # load y position and store in $a0
    
    # S key, tetromino moves 1 unit down 
    addi $a1, $a1, 1   # shift y coordinate down by 1
    
    # CHECK ORIENTATION
    la $t5, i_orientation
    lw $t5, 0($t5)
    
    # if any tetromino is horizontal go to the horizontal check to see whether it collided with a wall
    beq $t5, 0, vertical_check
    beq $t5, 180, vertical_check
    
    # if not vertical, then horizontal check if y check to see if the x coordinate would collide with right wall
    beq, $a1, 31, piece_drop
    
shift_properly_d:
    sw $a1, 0($t7) # store new y coordinate in memory
    
    la $t7, i_orientation # load the current orientation address into $t7
    lw $t4, 0($t7)              # load orientation and store in $t4
    
    beq $t4, 0, draw_i_vertical
    beq $t4, 180, draw_i_vertical
    beq $t4, 90, draw_i_horizontal
    beq $t4, 270, draw_i_horizontal
    draw_i_vertical:
        addi $a2, $zero, 1     # set length of line to 1
        addi $a3, $zero, 4    # set height of line to 4
        jal draw_tetromino
        j game_loop  
    draw_i_horizontal:
        addi $a2, $zero, 4     # set length of line to 4
        addi $a3, $zero, 1    # set height of line to 1
        jal draw_tetromino     
        j game_loop
        
respond_to_D:
    
    lw $t0, ADDR_DSPL # reset display address
    # redraw grid
    # draw dark part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_dark_grid      # call the rectangle-drawing function
    
    # # draw light part of grid
    # addi $a0, $zero, 1      # set x coordinate of line to 0
    # addi $a1, $zero, 0      # set y coordinate of line to 31
    # addi $a2, $zero, 10     # set length of line to 31
    # addi $a3, $zero, 31     # set height of line to 1
    # jal draw_light_grid     # call the rectangle-drawing tetromino
    
    jal load_background
    
    # draw rotated tetromino
    la $t7, current_i_x  
    lw $a0, 0($t7)  
    addi $a0, $a0, 1 
    
    la $t1, current_i_y
    lw $t2, 0($t1)
    
    # CHECK ORIENTATION
    la $t5, i_orientation
    lw $t5, 0($t5)
    
    # if any tetromino is horizontal go to the horizontal check to see whether it collided with a wall
    beq $t5, 90, horizontal_check
    beq $t5, 270, horizontal_check
    
    # if not horizontal check to see if the x coordinate would collide with right wall
    beq, $a0, 11, stay_current_location



    # check the orientation, if 0 and 270 then jumpt to stay_current location if 32 - height
    # otherwise 32 -1 
    # beq, $a0, 1, stay_current_location
    shift_properly:
    sw $a0, 0($t7) 
    la $t7, current_i_y  # updating the new location
    lw $a1, 0($t7)  
    la $t7, i_orientation 
    lw $t4, 0($t7)              
    
    beq $t4, 0, draw_i_vertical
    beq $t4, 180, draw_i_vertical
    beq $t4, 90, draw_i_horizontal
    beq $t4, 270, draw_i_horizontal
    draw_i_vertical:
        addi $a2, $zero, 1     # set length of line to 1
        addi $a3, $zero, 4    # set height of line to 4
        jal draw_tetromino
        j game_loop
    draw_i_horizontal:
        addi $a2, $zero, 4     # set length of line to 4
        addi $a3, $zero, 1    # set height of line to 1
        jal draw_tetromino     
        j game_loop
        
horizontal_check:
add $t5, $a0, $zero # make $t5 the x coordinate
addi $t5, $t5, 4 # add length of the block
beq, $t5, 12, stay_current_location
j shift_properly

vertical_check:
add $t5, $a1, $zero # make $t5 the x coordinate
addi $t5, $t5, 4 # add length of the block
beq, $t5, 32, stay_current_location
j shift_properly_d

play_song:
    # Loaidng Addresses and Values
    la $t9, midis
    lw $t7, midi_shift
    la $t6, midi_shift
    la $t5, times
    
    # Adds offset to midi address
    add $t9, $t9, $t7
    
    # Loads midi at current index
    lw $t8, 0($t9)
    
    li $v0, 31    # async play note syscall
    add $a0, $zero, $t8    # midi pitch
    li $a1, 500  # duration
    li $a2, 0     # instrument
    li $a3, 100   # volume
    
    # Incriments shift to four more (next midi)
    addi $t7, $t7, 4
    
    # Reached end of song - resets back to 0
    bne $t7, 748, skip_reset_song
    add $t7, $zero, $zero
    
    skip_reset_song:
    sw $t7, 0($t6)
    
    add $t5, $t5, $t7
    lw $t4, 0($t5)
    
    bne $t4, 0, skip_bonus_note
    j play_song
    
    skip_bonus_note:
jr $ra