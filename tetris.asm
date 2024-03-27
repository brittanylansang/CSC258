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
    
    # draw grid
    addi $a0, $zero, 1     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal even_grid     # call the grid-drawing function
    
    addi $a0, $zero, 3     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal even_grid     # call the grid-drawing function
    
    addi $a0, $zero, 5     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal even_grid     # call the grid-drawing function
    
    addi $a0, $zero, 7     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal even_grid     # call the grid-drawing function
    
    addi $a0, $zero, 9     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal even_grid     # call the grid-drawing function
    
    addi $a0, $zero, 2     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal odd_grid     # call the grid-drawing function
    
    addi $a0, $zero, 4     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal odd_grid     # call the grid-drawing 
    
    addi $a0, $zero, 6     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal odd_grid     # call the grid-drawing function

    addi $a0, $zero, 8     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal odd_grid     # call the grid-drawing function
    
    addi $a0, $zero, 10     # set x coordinate of line to 1
    addi $a1, $zero, 0     # set y coordinate of line to 0
    addi $a2, $zero, 1     # set length of line to 10
    addi $a3, $zero, 31    # set height of line to 31
    jal odd_grid     # call the grid-drawing function

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
# - $t7: stores the colour gray for the grid
# - $t8: stores the colour light gray for the grid

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

even_grid:
li $t5, 0 # store 0 in $t5, this will be used to check to switch colours

sll $t2, $a1, 7         # convert vertical offset to pixels (by multiplying $a1 by 128, equivalent to logical left shifts)
sll $t6, $a3, 7         # convert height of rectangle from pixels to rows of bytes (by multiplying $a3 by 128)
add $t6, $t2, $t6       # calculate value of $t2 for the last line in the rectangle.

outer_even_grid_top:
sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4)
# sll $t5, $a2, 2         # convert length of line from pixels to bytes (by multiplying $a2 by 4)
# add $t5, $t1, $t5       # calculate value of $t1 for end of the horizontal line.

inner_even_grid_top:
la $t7, dark_checkerboard     # fetch wall_colour label address
lw $t8, 0($t7)          # load into $t8 = dark grid colour
la $t7, light_checkerboard     # fetch wall_colour label address
lw $t9, 0($t7)          # load into $t9 = light grid colour

# bne $t4, $t8, switch_colour_gray # if the grid colour is light gray, we need to switch it to dark gray 
# bne $t4, $t9, switch_colour_light_gray # if the grid colour is dark gray, we need to switch it to light gray 
check_even_colour:
bne $t5, 0, light_gray_even # if t5 is not zero draw light

#draw dark first iteration
dark_gray_even:
add $t4, $t8, $zero # load dark gray colour
j draw_even # jump to where we draw the pixels

light_gray_even:
add $t4, $t9, $zero # load light gray colour
j draw_even # jump to where we draw the 

draw_even:
add $t3, $t1, $t2           # store the total offset of the starting pixel (relative to $t0)
add $t3, $t0, $t3           # calculate the locationq of the starting pixel ($t0 + offset)
sw $t4, 0($t3)              # paint the current unit on the first row the colour in $t4
addi $t2, $t2, 128          # move vertical offset down by one line
beq $t2, $t6, inner_even_grid_end     # on last line, break out of the outer loop
# j outer_grid_top                 # jump to the top of the outer loop
# outer_grid_end:
# jr $ra


next_even:
addi $t5, $t5, 1       # Increment the alternate counter
andi $t5, $t5, 1       # Keep $t3 value as 0 or 1

j outer_even_grid_top                 # jump to the top of the outer loop
inner_even_grid_end:
jr $ra

odd_grid:
# store initial grid colour in $t4
# la $t7, grid_dark_colour     # fetch grid_dark_colour label address
# lw $t4, 0($t7)          # load into $t4 = darker gray for the walls
li $t5, 0

sll $t2, $a1, 7         # convert vertical offset to pixels (by multiplying $a1 by 128, equivalent to logical left shifts)
sll $t6, $a3, 7         # convert height of rectangle from pixels to rows of bytes (by multiplying $a3 by 128)
add $t6, $t2, $t6       # calculate value of $t2 for the last line in the rectangle.
outer_odd_grid_top:
sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4)
# sll $t5, $a2, 2         # convert length of line from pixels to bytes (by multiplying $a2 by 4)
# add $t5, $t1, $t5       # calculate value of $t1 for end of the horizontal line.

inner_odd_grid_top:

la $t7, dark_checkerboard     # fetch wall_colour label address
lw $t8, 0($t7)          # load into $t8 = dark grid colour

la $t7, light_checkerboard     # fetch wall_colour label address
lw $t9, 0($t7)          # load into $t9 = light grid colour

# bne $t4, $t8, switch_colour_gray # if the grid colour is light gray, we need to switch it to dark gray 
# bne $t4, $t9, switch_colour_light_gray # if the grid colour is dark gray, we need to switch it to light gray 
check_odd_colour:
bne $t5, 0, dark_gray_odd # if t7 is not zero draw draw light

light_gray_odd:
add $t4, $t9, $zero # load light gray colour
j paint_odd # jump to where we draw the pixels

dark_gray_odd:
add $t4, $t8, $zero # load dark gray colour
j paint_odd # jump to where we draw the pixels

paint_odd:
add $t3, $t1, $t2           # store the total offset of the starting pixel (relative to $t0)
add $t3, $t0, $t3           # calculate the locationq of the starting pixel ($t0 + offset)
sw $t4, 0($t3)              # paint the current unit on the first row the colour in $t4
addi $t2, $t2, 128          # move vertical offset down by one line
beq $t2, $t6, inner_odd_grid_end     # on last line, break out of the outer loop
# j outer_grid_top                 # jump to the top of the outer loop
# outer_grid_end:
# jr $ra


next_odd:
addi $t5, $t5, 1       # Increment the alternate counter
andi $t5, $t5, 1       # Keep $t3 value as 0 or 1

j outer_odd_grid_top                 # jump to the top of the outer loop
inner_odd_grid_end:
jr $ra

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
