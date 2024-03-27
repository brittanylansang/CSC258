################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Brittany Lansang, 100 825 5406
# Student 2: Greg, Student Number (if applicable)
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
    addi $a0, $zero, 1      # set x coordinate of line to 0
    addi $a1, $zero, 0      # set y coordinate of line to 31
    addi $a2, $zero, 10     # set length of line to 31
    addi $a3, $zero, 31     # set height of line to 1
    jal draw_dark_grid      # call the rectangle-drawing function
    
    # draw light part of grid
    addi $a0, $zero, 1      # set x coordinate of line to 0
    addi $a1, $zero, 0      # set y coordinate of line to 31
    addi $a2, $zero, 10     # set length of line to 31
    addi $a3, $zero, 31     # set height of line to 1
    jal draw_light_grid     # call the rectangle-drawing function

    #draw I piece
    la $t7, current_i_x  # Load the piece_I_x label's address into $t7
    lw $a0, 0($t7)  # Fetch x position of the piece and store in $a1
    la $t7, current_i_y  # Load the piece_I_y label's address into $t7
    lw $a1, 0($t7)  # Fetch y position of the piece and store in $a2
    addi $a2, $zero, 1     # set length of line to 1
    addi $a3, $zero, 4    # set height of line to 4
    jal draw_tetromino     # call the tetromino-drawing function
    j game_loop
    


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

lw $t4, 0($t7)              # load into $t4 = darker gray for the walls

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
lw $t4, 0($t7)          # load into $t4 = darker gray for the walls

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
	
	la $t7, i_colour  # Load the piece_I_colour label's address into $t7
	lw $t4, 0($t7)  # Fetch colour of the piece and store in $t4

    sw $t4, 0($t3)              # paint the current unit on the first row the specified colour in $t4
	addi $t1, $t1, 4            # move horizontal offset to the right by one pixel
	beq $t1, $t5, inner_tetromino_end     # break out of the line-drawing loop
	j inner_tetromino_top                 # jump to the start of the inner loop
	inner_tetromino_end:
	
	addi $t2, $t2, 128          # move vertical offset down by one line
	beq $t2, $t6, outer_tetromino_end     # on last line, break out of the outer loop
	j outer_tetromino_top                 # jump to the top of the outer loop
	outer_tetromino_end:
	jr $ra

game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    b game_loop
