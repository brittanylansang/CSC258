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
wall_colour: 
    .word 0xFFFFFF
grid_colour:
    .word 0x3b3b3b
current_i_x: 
    .word 4
# The current y coordinate for the I 
current_i_y: 
    .word 0
# The colour of the I piece     
i_colour:   
    .word 0x00FFFF
o_colour:
    .word 0x00FFFF00
s_colour:
    .word 0xff0000
z_colour:
    .word 0x00ff00
l_colour:
    .word 0x00FFA500
j_colour:
    .word 0x00FF00FF
t_colour:
    .word 0x00800080
i_orientation:
    .word 0
i_length:
    .word 1
i_piece:
    .word 0
o_piece:
    .word 1
s_piece:
    .word 2
z_piece:
    .word 3
l_piece:
    .word 4
j_piece:
    .word 5
t_piece:
    .word 6
current_piece_x:
    .word 4
current_piece_y: 
    .word 0
current_orient:
    .word 0
current_piece:
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
    addi $a0, $zero, 11      # set x coordinate of line to 11
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
    
    # draw the black grid
    addi $a0, $zero, 1     # set x coordinate of line to 0
    addi $a1, $zero, 0     # set y coordinate of line to 31
    addi $a2, $zero, 10     # set length of line to 31
    addi $a3, $zero, 31     # set height of line to 1
    jal draw_grid
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

draw_grid:
sll $t2, $a1, 7         # convert vertical offset to pixels (by multiplying $a1 by 128, equivalent to logical left shifts)
sll $t6, $a3, 7         # convert height of rectangle from pixels to rows of bytes (by multiplying $a3 by 128)
add $t6, $t2, $t6       # calculate value of $t2 for the last line in the rectangle.

outer_top_grid:
sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4)
sll $t5, $a2, 2         # convert length of line from pixels to bytes (by multiplying $a2 by 4)
add $t5, $t1, $t5       # calculate value of $t1 for end of the horizontal line.

inner_top_grid:
add $t3, $t1, $t2           # store the total offset of the starting pixel (relative to $t0)
add $t3, $t0, $t3           # calculate the location of the starting pixel ($t0 + offset)

la $t7, grid_colour     # fetch wall_colour label address
lw $t4, 0($t7)          # load wall colour and store into $t4

sw $t4, 0($t3)              # paint the current unit on the first row yellow
addi $t1, $t1, 4            # move horizontal offset to the right by one pixel
beq $t1, $t5, inner_end_grid     # break out of the line-drawing loop
j inner_top_grid                # jump to the start of the inner loop
inner_end_grid:

addi $t2, $t2, 128          # move vertical offset down by one line
beq $t2, $t6, outer_end_grid     # on last line, break out of the outer loop
j outer_top_grid                # jump to the top of the outer loop
outer_end_grid:
jr $ra                    # return to calling program

# - $a0: the x coordinate of the starting point for this line.
# - $a1: the y coordinate of the starting point for this line.
# - $a2: the length of this line, measured in pixels
# - $a3: the colour of the line

draw_horizontal_line:
	sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4) 
	sll $t2, $a1, 7         # convert vertical offset to pixels (by multiplying by 128) 
    sll $t3, $a2, 2         # convert length of line from pixels to bytes (by multiplying $a2 by 4)
    add $t3, $t1, $t3       # calculate value of $t1 for end of the horizontal line.
    
    h_loop:
    add $t4, $t1, $t2       # calculate the total offset
    add $t4, $t0, $t4       # calculate location of starting pixel $t0 + offset
    
    sw $a3, 0($t4)
    addi $t1, $t1, 4            # move horizontal offset to the right by one pixel
    
    beq $t1, $t3, h_loop_end     # break out of the line-drawing loop
    j h_loop                    # jump to the start of the inner loop
    h_loop_end:
    jr $ra



# - $a0: the x coordinate of the starting point for this line.
# - $a1: the y coordinate of the starting point for this line.
# - $a2: the height of this line, measured in pixels
# - $a3: the colour of the line

draw_vertical_line:
	sll $t1, $a0, 2         # convert horizontal offset to pixels (by multiplying $a0 by 4) x
	sll $t2, $a1, 7         # convert vertical offset to pixels (by multiplying by 128) y
    sll $t3, $a2, 7         # convert height of line from pixels to bytes (by multiplying $a2 by 128) height
    add $t3, $t2, $t3       # calculate value of $t1 for end of the vertical line.
    
    v_loop:
    add $t4, $t1, $t2       # calculate the total offset
    add $t4, $t0, $t4       # calculate location of starting pixel $t0 + offset
    
    sw $a3, 0($t4)
    addi $t2, $t2, 128            # move horizontal offset to the right by one pixel
    
    beq $t2, $t3, v_loop_end     # break out of the line-drawing loop
    j v_loop                    # jump to the start of the inner loop
    v_loop_end:
    jr $ra
 
# draw i piece
draw_i:
    la $t1, current_orient      # fetch address
    lw $t2, 0($t1)              # load the current x value into the argument
    beq $t2, 90, horizontal_i   # check the orientation if it's 90, then horizontal piece
    beq $t2, 270, horizontal_i  # check the orientation if it's 270, then horizontal piece
    
    # otherwise, i is default vertical piece
    addi $a2, $zero, 4      # setting the height of the line
    la $t1, i_colour
    lw $a3, 0($t1)
    jal draw_vertical_line
    finish_drawing:
    j check_key
    
    horizontal_i:
    la $t1, current_piece_x # fetch address
    lw $a0, 0($t1)          # load the current x value into the argument
    la $t1, current_piece_y # fetch address
    lw $a1, 0($t1)          # load the current y value into the argument
    addi $a2, $zero, 4      # setting the length of the line
    la $t1, i_colour
    lw $a3, 0($t1)
    jal draw_horizontal_line
    j check_key
 
    # jr $ra                      # return to calling program

# draw o piece
draw_o:
    addi $a2, $zero, 2
    la $t1, o_colour
    lw $a3, 0($t1)
    jal draw_vertical_line
    
    addi $a0, $a0, 1
    jal draw_vertical_line
    j check_key
    
    # jr $ra
    
draw_s:
    addi $a2, $zero, 2 # the length
    la $t1, s_colour    # the colour
    lw $a3, 0($t1)
    jal draw_horizontal_line
    
    # need to change x and y
    
    addi $a1, $a1, 1  # change the y
    addi $a0, $a0, -1 # change the x
    addi $a2, $zero, 2  # the length of the horizontal
    la $t1, s_colour
    lw $a3, 0($t1)
    jal draw_horizontal_line
    
    j check_key     # finish drawing check any input
    
draw_z:

    addi $a0, $a0, -1 # change the x
    addi $a2, $zero, 2  # the length of the horizontal
    la $t1, z_colour
    lw $a3, 0($t1)
    jal draw_horizontal_line
    
    addi $a0, $a0, 1 # change x
    addi $a1, $a1, 1 # change the y
    addi $a2, $zero, 2 # the length
    la $t1, z_colour    # the colour
    lw $a3, 0($t1)
    jal draw_horizontal_line
    
    j check_key     # finish drawing check any input
    
    
draw_l:
    addi $a2, $zero, 3
    la $t1, l_colour
    lw $a3, 0($t1)
    jal draw_vertical_line
    
    addi $a1, $a1, 2
    addi $a2, $zero, 2
    la $t1, l_colour
    lw $a3, 0($t1)
    jal draw_horizontal_line
    
    j check_key     # finish drawing check any input
    
draw_j:
    addi $a2, $zero, 3 # height
    la $t1, j_colour
    lw $a3, 0($t1)
    jal draw_vertical_line
    
    # need to change x so it is one ot the left
    
    addi $a1, $a1, 2  # change the y
    addi $a0, $a0, -1 # change the x
    addi $a2, $zero, 2  # the length of the horizontal
    la $t1, j_colour
    lw $a3, 0($t1)
    jal draw_horizontal_line
    
    j check_key     # finish drawing check any input
    
draw_t:
    addi $a2, $zero, 2
    la $t1, t_colour
    lw $a3, 0($t1)
    jal draw_vertical_line
    
    addi $a0, $a0, -1 # change the x
    addi $a2, $zero, 3  # the length of the horizontal
    la $t1, t_colour
    lw $a3, 0($t1)
    jal draw_horizontal_line
    
    j check_key     # finish drawing check any input


game_loop:
##############################################################################
# MILESTONE 2
##############################################################################
    # When the block has collided from the bottom generate a new block
    finish_bottom_collision:
    # reset current piece:
    la $t1, current_piece   # fetch address
    lw $t2, 0($t1)          # load the value
    addi $t2, $t2, 0        # make the piece 0 in .data
    sw $t2, 0($t1)          # update the current piece
    
    # reset current orientation:
    # la $t1, current_orient
    # lw $t2, 0($t1)
    # add $t2, $2, $zero
    # sw $t2, 0($t1)
    
    li $v0, 42
    li $a0, 0
    li $a1, 7 # 7
    syscall
    
    beq $a0, 0, i_piece
    beq $a0, 1, o_piece
    beq $a0, 2, s_piece
    beq $a0, 3, z_piece
    beq $a0, 4, l_piece   # make this 4 later
    beq $a0, 5, j_piece
    beq $a0, 6, t_piece
    
    i_piece:
    # doesn't need to update current piece due to the reset in 310
    la $t1, current_piece_x # fetch address
    lw $a0, 0($t1)          # load the current x value into the argument
    la $t1, current_piece_y # fetch address
    lw $a1, 0($t1)          # load the current y value into the argument
    jal draw_i
    
    o_piece:
    # updating current piece
    la $t1, current_piece   # fetch address
    lw $t2, 0($t1)          # load the value
    addi $t2, $t2, 1        # make the piece 1 in .data #CHANGE 1 LATER
    sw $t2, 0($t1)          # update the current piece
    
    la $t1, current_piece_x # fetch address
    lw $a0, 0($t1)          # load the current x value into the argument
    la $t1, current_piece_y # fetch address
    lw $a1, 0($t1)          # load the current y value into the 
    
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    
    jal draw_o
    
    lw $ra, 0($sp)          # pop $ra

    s_piece:
    # updating current piece
    la $t1, current_piece   # fetch address
    lw $t2, 0($t1)          # load the value
    addi $t2, $t2, 2        # make the piece 2 in .data
    sw $t2, 0($t1)          # update the current 
    
    la $t1, current_piece_x # fetch address
    lw $a0, 0($t1)          # load the current x value into the argument
    la $t1, current_piece_y # fetch address
    lw $a1, 0($t1)          # load the current y value into the 

    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    
    jal draw_s
    
    lw $ra, 0($sp)          # pop $ra
    
    z_piece:
    # updating current piece
    la $t1, current_piece   # fetch address
    lw $t2, 0($t1)          # load the value
    addi $t2, $t2, 3        # make the piece 2 in .data
    sw $t2, 0($t1)          # update the current 
    
    la $t1, current_piece_x # fetch address
    lw $a0, 0($t1)          # load the current x value into the argument
    la $t1, current_piece_y # fetch address
    lw $a1, 0($t1)          # load the current y value into the 

    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    
    jal draw_z
    
    lw $ra, 0($sp)          # pop $ra

    
    l_piece:
    la $t1, current_piece
    lw $t2, 0($t1)          # load the value
    addi $t2, $t2, 4        # make the piece 1 in .data MAKE 4 LATER
    sw $t2, 0($t1)          # update the current piece
    
    la $t1, current_piece_x # fetch address
    lw $a0, 0($t1)          # load the current x value into the argument
    la $t1, current_piece_y # fetch address
    lw $a1, 0($t1)          # load the current y value into the 
    
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    
    jal draw_l              # draw grid then return here
    
    lw $ra, 0($sp)          # pop $ra
    
    j_piece:
    la $t1, current_piece
    lw $t2, 0($t1)          # load the value
    addi $t2, $t2, 5        # make the piece 1 in .data MAKE 6 LATER
    sw $t2, 0($t1)          # update the current piece
    
    la $t1, current_piece_x # fetch address
    lw $a0, 0($t1)          # load the current x value into the argument
    la $t1, current_piece_y # fetch address
    lw $a1, 0($t1)          # load the current y value into the 
    
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    
    jal draw_j              # draw grid then return here
    
    lw $ra, 0($sp)          # pop $ra

    t_piece:
    la $t1, current_piece
    lw $t2, 0($t1)          # load the value
    addi $t2, $t2, 6        # make the piece 1 in .data MAKE 6 LATER
    sw $t2, 0($t1)          # update the current piece
    
    la $t1, current_piece_x # fetch address
    lw $a0, 0($t1)          # load the current x value into the argument
    la $t1, current_piece_y # fetch address
    lw $a1, 0($t1)          # load the current y value into the 
    
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    
    jal draw_t              # draw grid then return here
    
    lw $ra, 0($sp)          # pop $ra
    
    
    # # update the tetromino's orientation value in .data 
	# la $t7, i_orientation  # load address into $t7
	# lw $t4, 0($t7)  
	# addi $t4, $t4, 90 # rotate 90 degrees
	# sw $t4, 0($t7) # Update new orientation
    

    # 1a. Check if key has been pressed
    check_key:
    lw $t1, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t2, 0($t1)                  # load first word from keyboard
    beq $t2, 1, keyboard_input      # key is pressed
    beq $t2, 0, end_game_loop       # no key pressed, loop back and wait for the next keyboard input
      
    keyboard_input:
        lw $t1, ADDR_KBRD               # load the keyboard_address into $t1
        lw $t2, 4($t1)                  # load second word from keyboard
        # beq $t2, 0x71, respond_to_Q     # check if the key q was pressed
        # beq $t2, 0x77, respond_to_W     # check if the key w was pressed
        # beq $t2, 0x61, respond_to_A     # check if the key a was pressed
        beq $t2, 0x73, respond_to_S     # check if the key s was pressed
        # beq $t2, 0x64, respond_to_D     # check if the key d was pressed
        
        addi $t5, $t5, 1
        
    # 2a. Check for collisions
    # 2b. Update locations (paddle, ball)
    # 3. Draw the screen
    # 4. Sleep
    
    #5. Go back to 1
    end_game_loop: 
    b check_key 
    
    respond_to_S: # NEED TO BE FIXED I THINK IT HAS TO DO WITH THE OFFSET
    lw $t0, ADDR_DSPL # reset display address
    # redraw grid (same arguments passed from initialization)
    
    addi $a0, $zero, 1     # set x coordinate of line to 0
    addi $a1, $zero, 0     # set y coordinate of line to 31
    addi $a2, $zero, 10     # set length of line to 31
    addi $a3, $zero, 31     # set height of line to 1
    
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    
    jal draw_grid           # draw grid, then after it will return back here
    
    lw $ra, 0($sp)          # pop $ra
    
    la $t7, current_i_x     # fetch address label
    lw $a0, 0($t7)          # fetch value of x coordinate
    la $t7, current_i_y     # fetch the address label
    lw $a1, 0($t7)          # fetch the value of y coordinate
    
    la $t8, i_orientation   # fetch address label
    lw $t9, 0($t8)          # fetch value of the orientation
    
    la $t8, current_piece   # fetch address label
    lw $t8, 0($t8)          # fetch value to see which piece it is
    
    beq  $t8, 0, check_i
    beq $t8, 1, check_o
    beq $t8, 2, check_s
    beq $t8, 3, check_z
    beq $t8, 4 check_l
    beq $t8, 5, check_j
    beq $t8, 6, check_t

    check_i:    
    # increment by one pixel down
    # $t9 stores the current orientation
    addi $a1, $a1, 1        
    beq $t9, 0, vertical_i          # cond1: branch if the current orientation is vertical
    # bne $t9, 180, horizontal_i      # cond2: branch if the current orientation is horizontal 
    
    # pass in bottom most x, y
    # x stays the same
    # change 
    # y stays the same
    vertical_i:
    addi $a3, $zero, 4
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra

     
    # finish checking and is fine
    j shift_down
    
    
    
    check_o:
    addi $a1, $a1, 1  # CORRECT
    
    # - $a0 - x coordinate # you enter (x, y) of bottom most pixel current x
    # - $a1 - y coordinate  # you enter                             current y
    # - $a3 - height        # you enter
    # check_pixel_down
    
    # checks pixel directly under
    addi $a3, $zero, 2
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, 1  # this checks the pixel to the right now
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    
    j shift_down
    
    check_s:
    addi $a1, $a1, 1  # CORRECT
    # - $a0 - x coordinate # you enter (x, y) of bottom most pixel current x
    # - $a1 - y coordinate  # you enter                             current y
    # - $a3 - height        # you enter
    # check_pixel_down
    
    # checks pixel directly under
    addi $a3, $zero, 2 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, -1  # this checks the pixel to the left now
    addi $a3, $zero, 2 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, 2  # this checks the pixel to the right now
    addi $a3, $zero, 1  # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    # if all good shift down
    j shift_down
    
    check_z:
    addi $a1, $a1, 1  # CORRECT
    # - $a0 - x coordinate # you enter (x, y) of bottom most pixel current x
    # - $a1 - y coordinate  # you enter                             current y
    # - $a3 - height        # you enter
    # check_pixel_down
    
    # checks pixel directly under
    addi $a3, $zero, 2 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, -1  # this checks the pixel to the left now
    addi $a3, $zero, 1 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, 2  # this checks the pixel to the right now #CHANGE TO 2 AS A0 GOT RESET
    addi $a3, $zero, 1  # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    # if all good shift down
    j shift_down
    
    
    
    
    check_l:
    addi $a1, $a1, 1        
    beq $t9, 0, vertical_l          # cond1: branch if the current orientation is vertical
    # bne $t9, 180, horizontal_l      # cond2: branch if the current orientation is horizontal 
    
    vertical_l:
    # checks pixel directly under x
    addi $a3, $zero, 3 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, 1  # this checks the pixel to the right now
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    
    j shift_down

    # horizontal_l: # HAVENT DONE
    # sll $t2, $a1, 7         # multiply by 128 to get the offset
    # add $t3, $t2, $t0       # add the top left corner plus the offset to get the address of the new shifted pixel
    # sll $t2, $a0, 2         # multiply by 4 to get the offset
    # add $t3, $t3, $t2       # the total offset
    # lw $t4, 0($t3)          # get the colour of the pixel at that location
    
    # la $t5, grid_colour     # fetch the address label
    # lw $t6, 0($t5)          # fetch the value, the black colour of the pixel
    
    # bne $t6, $t4, stay_current_location # if the pixel is not black, stay at current location
    # # otherwise shift down
    # j shift_down
    
    check_j:
    addi $a1, $a1, 1        
    beq $t9, 0, vertical_j          # cond1: branch if the current orientation is vertical
    # bne $t9, 180, horizontal_l      # cond2: branch if the current orientation is horizontal 
    
    vertical_j:
    # checks pixel directly under x
    addi $a3, $zero, 3 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, -1  # this checks the pixel to the right now
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    
    j shift_down
    
    check_t:
    addi $a1, $a1, 1 
    
    # checks pixel directly under x
    addi $a3, $zero, 2 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, -1  # this checks the pixel to the left now
    addi $a3, $zero, 1 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $ra
    
    addi $a0, $a0, 2  # this checks the pixel to the left now
    addi $a3, $zero, 1 # height
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    jal check_pixel_down
    
    lw $ra, 0($sp)          # pop $
    
    J shift_down
    
    # horizontal_j: # CHANGE
    # sll $t2, $a1, 7         # multiply by 128 to get the offset
    # add $t3, $t2, $t0       # add the top left corner plus the offset to get the address of the new shifted pixel
    # sll $t2, $a0, 2         # multiply by 4 to get the offset
    # add $t3, $t3, $t2       # the total offset
    # lw $t4, 0($t3)          # get the colour of the pixel at that location
    
    # la $t5, grid_colour     # fetch the address label
    # lw $t6, 0($t5)          # fetch the value, the black colour of the pixel
    
    # bne $t6, $t4, stay_current_location # if the pixel is not black, stay at current location
    # # otherwise shift down
    # j shift_down
    
    shift_down:
    sw $a1, 0($t7) # store new y coordinate in memory 
    la $t3, current_piece_x
    lw $a0, 0($t3)
    la $t8, current_piece
    lw $t8, 0($t8)
    beq  $t8, 0, draw_i
    beq $t8, 1, draw_o
    beq $t8, 2, draw_s
    beq $t8, 3, draw_z
    beq $t8, 4, draw_l
    beq $t8, 5, draw_j
    beq $t8, 6, draw_t
    j keyboard_input
    
    stay_current_location:
    la $t8, current_piece
    lw $t8, 0($t8)

    
    addi $sp, $sp, -4       # make room in stack
    sw $ra, 0($sp)          # push $ra
    
    beq  $t8, 0, draw_i
    beq $t8, 1, draw_o
    beq, $t8, 2, draw_s
    beq, $t8, 3, draw_z
    beq $t8, 4, draw_l   # make this 4 later
    beq $t8, 5, draw_j
    beq $t8, 6, draw_t
    
    lw $ra, 0($sp)          # pop $ra
    j game_loop
    
# - $a0 - x coordinate 
# - $a1 - y coordinate  
# - $a3 - height
# Checks whether the colour under the given given pixel coordinate is black or not for collisions
 check_pixel_down:
    add $t2, $a1, $a3        # for the height of the tetromino, add the current y to the height
    sll $t3, $t2, 7         # multiply by 128 to get the offset of the y coordinate
    add $t4, $t3, $t0       # add the top left corner plus the offset to get the address of the new y shifted
    sll $t3, $a0, 2         # multiply by 4 to get the offset of the x coordinate
    add $t4, $t4, $t3       # the total offset
    lw $t5, 0($t4)          # get the colour of the pixel at that location
    la $t6, grid_colour     # fetch the address label
    lw $t8, 0($t6)          # fetch the value, the black colour of the pixel
            
    bne $t8, $t5, stay_current_location # if the pixel is not black, stay at current location
    
    jr $ra
    
 