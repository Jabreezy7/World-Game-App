# Mohammed Baled (mob82)

.data
# variables here

debug:			.word   1        # Set to 1 turn debug mode on and 0 to turn off

addSpace: 		.asciiz "   " 

welcomeMessage:		.asciiz "Welcome to Wordle! \n"

menuPromptMessage:	.asciiz "Select an option \n"

choice1:		.asciiz "    (1) Play \n "

choice2:		.asciiz "   (2) Quit \n "

menuDivider:		.asciiz " ================== \n "

guessPromptMessage:	.asciiz " Make your guess: "

tryAgainMessage:	.asciiz " Please type the number 1 to play or the number 2 to quit "

buffer:			.space 10

randomWord:		.asciiz " The Word is: "


matrix:			.byte	'b', 'r', 'e', 'a', 'k',
				'c', 'a', 't', 'c', 'h', 
				'f', 'r', 'e', 's', 'h', 
				'd', 'r', 'i', 'l', 'l', 
				'g', 'i', 'v', 'e', 'n'
				
userRetry:		.asciiz " Please enter a 5 letter word! "	
							

userGuess: 		.asciiz " x ", " x ", " x ", " x ", " x "  

openPar:		.byte '('
closePar:		.byte ')'

openBrack:		.byte '['
closeBrack:		.byte ']'

space:			.byte ' '


winScreen:		.asciiz " You Got the Word! "

loseScreen:		.asciiz " You lost. "
		


.text
# Functions here



# This function Prints the welcome menu to the user

# Equivalent Java Code:
# 	void printMenu()  {
# 	System.out.print(menuDivider);
# 	System.out.print(welcomeMessage);
# 	System.out.print(menuDivider);
# 	System.out.print(menuPromptMessage);
# 	System.out.print(choice1);
# 	System.out.print(choice2);  }
print_menu:
	push	ra
	
	li	v0, 4
	la	a0, menuDivider
	syscall
	
	la	a0, welcomeMessage
	syscall
	
	la	a0, menuDivider
	syscall
	
	la	a0, menuPromptMessage
	syscall
	
	la	a0, choice1
	syscall
	
	la	a0, choice2
	syscall
	
	pop	ra
	jr	ra
	
_end_print_menu:	
# end of print_menu function





# This function calculates the address of the row element (row, j) in a matrix of words and returns the value at that address
# Inputs:
#	 a0: The base address of our matrix
#	 a1: The row that our word is located
#	 a2: The index j of our row
#	 a3: The number of elements in the row which will always be 5 in our case
# Outputs:
#	 v0: The value at the address we stored

# Equivalent Java Code:
#	int returnIndexAddress(int row, int col){
#	return matrix[row][j]; }


matrix_element_address:
# C.2 goes here
	push 	ra
	push 	s0
	push 	s1
	push 	s2
	push 	s3
	move	s0, a0
	move	s1, a1
	move	s2, a2
	move	s3, a3
	
	mul	t0, s3, 1     # b value for matrix. There are 5 bytes in each row of our 2d array
	mul	t0, t0, s1    # bi value for matrix. i is the row that we wish to access
	add	s0, s0, t0    # A + bi value for matrix. This gives us the starting address of the row we want.
	
	
	mul	t0, s2, 1     # bi value for row. There is 1 byte in each element in the row
	add	v0, s0, t0    # A + bi value  for row. This gives us the address of the element in the row we want to access. (matrix[i][j])
	
	
	pop 	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra	
end_matrix_element_address:
# end of matrix_element_addres function

	

		
# This function initializes user guess array with their most recent input	
# a0 = Buffer address	

# Equivalent Java Code:
# 	void initUserGuess(String [] buffer ){
# 	for(int i = 0; i<buffer.length; i++){ 	
# 	userGuess[i] = buffer[i]; } }
#																
initialize_user_guess:
	push 	ra
	push 	s0	
	
	move	s0, a0
	la	t4, space     		# we will replace any left over parentheses or brackets with a space value
	
	lb	t1, 0(s0)
	li	t2, 1
	sb 	t1, userGuess(t2)       # setting our actual letter to equal what the user inserted
	add	t2, t2, -1
	sb 	t4, userGuess(t2)	# resetting any open parentheses or brackets that may be left over
	add	t2, t2, 2
	sb 	t4, userGuess(t2)       # resetting any closed parentheses or brackets that may be left over
	
	# We will continue the above process for the rest of the strings in our userGuess array
	
	lb	t1, 1(s0)
	li	t2, 5
	sb 	t1, userGuess(t2)
	add	t2, t2, -1
	sb 	t4, userGuess(t2)
	add	t2, t2, 2
	sb 	t4, userGuess(t2)
	
	
	lb	t1, 2(s0)
	li	t2, 9
	sb 	t1, userGuess(t2)
	add	t2, t2, -1
	sb 	t4, userGuess(t2)
	add	t2, t2, 2
	sb 	t4, userGuess(t2)
	
	
	lb	t1, 3(s0)
	li	t2, 13
	sb 	t1, userGuess(t2)
	add	t2, t2, -1
	sb 	t4, userGuess(t2)
	add	t2, t2, 2
	sb 	t4, userGuess(t2)
	
	
	lb	t1, 4(s0)
	li	t2, 17
	sb 	t1, userGuess(t2)
	add	t2, t2, -1
	sb 	t4, userGuess(t2)
	add	t2, t2, 2
	sb 	t4, userGuess(t2)
	
		
	pop	s0
	pop	ra
	jr	ra	
end_initialize_user_guess:	
# end of initialize_user_guess function	




# This function checks if users guess was a valid 5 letter word 
# a0 = userInput String

# Equivalent Java Code:
# 	void validateUserInput(string userInput){
# 	for(int i = 0; i< userInput.length; i++){ 
# 	if( !userInput.charAt(i).isLetter() ) System.out.println(userRetry); } } 
#
validate_user_input:
	push	ra
	push	s0
	push	s1
	move	s0, a0
	
	li	s1, 0   # counter variable for iterating across all the charactres in user Guess input string
	
start_of_validation:	
	li 	v0, 1
	bgt	s1, 4, end_validate_user_input   # while(s1<=4)
	
	
	mul	t0, s1, 1     #address of element = A+bi    A = base address of the array  b = size of each element in array  i= the index of the element
	add	t2, s0, t0
	
	lb	t3, (t2)      # Storing ascii value of character in user guess string to t3
	
	blt	t3, 65, boundary_failed    # checking if the character is a letter by comparing the ascii value of the character.
	bgt	t3, 122, boundary_failed
	blt	t3, 97, check_boundary
boundary_passed:
	add	s1, s1, 1
	j	start_of_validation
	
	
check_boundary:
	bgt	t3, 90, boundary_failed     
	j	boundary_passed	
	
	
boundary_failed:	# if a character was not a letter than we will end the function and prompt the user to print a valid 5 letter word again.
	li	v0, 11
	li	a0, '\n'
	syscall
	li	v0, 4
	la	a0, userRetry
	syscall
	li	v0, 11
	li	a0, '\n'
	syscall
	li	v0, 0
	j	end_validate_user_input
		
	
end_validate_user_input:
	pop	s1
	pop	s0
	pop	ra
	jr	ra
#End of validate_user_input function	


	
	
	
# This function takes the users guess and for each letter in the users guess checks whether that letter
# is in the word and if it is in the right position then add brackets around that letter otherwise add parentheses around it
# this function will also increment a variable hit counter each time that a letter is placed in the right place and returns that variable.
# If this return value equals 5 then the user guessed the word correctly.

#Arguments:
#a0: address of matrix
#a1: address of buffer
#s3 = row of the matrix to access

# Equivalent Java Code:
#	int hitCount = 0;
# 	int checkUserInput( int row ) {
#	for(int i = 0; i < buffer.length; i++){
#
#	for(int j = 0; j < matrix[row].length; j++){
#	if(buffer[i]==matrix[row][j]){
#	if(i==j){ 
#	userGuess[i] = "[" + userGuess[i] + "]";
#	hitCount++;
#	break;}
#	else userGuess[i] = "(" + userGuess[i] + ")"; } }
#	return hitCount;


check_user_input:
	push	ra
	push	s0
	push	s1
	push	s2
	push	s3
	push	s4
	push	s5
	move	s0, a0
	move	s1, a1
	
	li	s5, 0   # Hit counter variable (amount of times that we find a letter is placed in the right position)
	li	s2, 0	# Outer loop counter variable that will iterate across all the letters in the user Guess string
start_of_for_loop:
	bgt	s2, 4, end_check_user_input	# for(s2<=4)
	
	mul	t0, s2, 1     #address of element = A+bi    A = base address of the array  b = size of each element in array  i= the index of the element
	add	t2, s1, t0
	
	lb	t3, (t2)      # Storing ascii value of letter in user guess string to t3.    
	
	
	
	li	s4, 0	   # inner loop counter variable that will access the column of the row that contains the solution string	
for_loop2_start:
	bgt	s4, 4, end_of_inner_loop  # for(s4<=4)
	
	la	a0, matrix # setting up parameters for matrix_element_address function
	move	a1, s3     # row row we want to access
	move	a2, s4     # column we want to access
	li	a3, 5	   # amount of elements in that row
	jal 	matrix_element_address   # get the address of the wanted index in our 2d array
	
	lb	t4, (v0)  # storing Ascii Value of letter in solution string to t4
	
	beq	t3, t4, check_bracket	# comparing the ascii value of the letter in user guess string and the ascii value of the letter in the solution string 
		
	
end_of_iteration:	
	add	s4, s4, 1    # incrementing column counter variable
	j	for_loop2_start  # iterating through column again
	
		
end_of_inner_loop:		
	add	s2, s2, 1    # incrment counter variable to go to the next letter in user guess string
	j	start_of_for_loop 	
	
	
check_bracket:
	beq	s4, s2, add_brackets    # if the index of our user guess string counter variable is equal to 
	j	add_parentheses         # the index of our solution string counter varialbe then add brackets otherwise add parentheses
	
	
	
add_brackets:			# add brackets
	add	s5, s5, 1
	lb	t5, openBrack
	lb	t6, closeBrack
	move	t7, s4		# we want to be adding the brackets at the index our letter is at
	mul	t7, t7, 4       # this is to access the different byte values in our string  
	
	sb	t5, userGuess(t7) # adding the open bracket	
	add	t7, t7, 2	  # we dont want to change the actual character so we add 2 bytes to skip over the character	
	sb	t6, userGuess(t7) # adding the closing bracket
	

	j	end_of_inner_loop	# move on to the next letter in the user guess string	
			
add_parentheses:
	lb	t5, openPar
	lb	t6, closePar
	move	t7, s2 			
	mul	t7, t7, 4
	
	sb	t5, userGuess(t7)     # adding open parentheses
	add	t7, t7, 2
	sb	t6, userGuess(t7)     # adding closing parentheses	
	
	j	end_of_iteration      # keep searching for other indexes where the letter may show up.
						
	
end_check_user_input:
	move	v0, s5
	pop	s5
	pop	s4
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra
# end of check user input function	
	
	
	
	
	
# This function prints the users guess.	

# Equivalent Java Code:
#	void printUserGuess(){
#	for(int i = 0; i< userGuess.length; i++){
#	System.out.print(userGuess[i]); }

print_user_guess:
	push	ra
	
	li 	t1, 0  # counter variable to iterate across all the letters in the user Guess array of strings.
print_outer_loop:
	beq	t1, 5, end_print_user_guess   # while(t1!=5)  our user guess array does not have more than 5 strings.

	li	t0, 0	# counter varialbe to iterate across the whole string at the index of our user Guess array of strings
	mul	t2, t1, 4          # contains the index of the userGuess[t1] string . We multiply by 4 to skip over the 0 character in the asciiz string       
print_byte:
	beq	t0, 3, exit_inner_loop   # while(t0!=3)  our strings can not have more than 3 characters + the  0 character in the asciiz string. 
	
	li	v0, 11			# printing the byte at the location of t2.
	lb	a0, userGuess(t2)
	syscall
	
	add	t2, t2, 1	     
	add	t0, t0, 1
	j	print_byte
	
exit_inner_loop:
	add	t1, t1, 1         # iterate across the next string in our userGuess array of strings
	j	print_outer_loop	
	
end_print_user_guess:
	pop	ra
	jr	ra	
# End of print users guess function	
	
	
	
	
	
# This function prints the solution word (the word the user is trying to guess)
# a0 = row to access

# Equivalent Java Code:
# 	void print_solution(int a0){
# 	for(int i = 0; i < matrix[a0].length; i++){
# 	Sytem.out.print(matrix[a0][i]); } }

print_solution:
	push	ra
	push	s0
	push	s1
	move 	s0, a0


	li	s1, 0	   # initializing column counter variable		
for_loop_start:
	bge	s1, 5, exit_print_solution  # for(s1<5)
	
	la	a0, matrix # setting up parameters for matrix_element_address function
	move	a1, s0
	move	a2, s1
	li	a3, 5
	jal 	matrix_element_address   # get the address of the wanted index in our 2d array
	
	lb	a0, (v0)     # get that addresses value and print it
	li	v0, 11
	syscall	
	
	
	add	s1, s1, 1    # incrementing column counter variable
	j	for_loop_start  # iterating through column again
																																																	
exit_print_solution:
	pop	s1
	pop	s0
	pop	ra
	jr 	ra	
# End of print solution function	
						
								

# End of functions



.globl main
main:
# Main program here

_generate_word:

	li	v0, 42  # Generating a random integer that will signify what row in our matrix that we will access
	li	a1, 5
	syscall
	
	move	s3, v0    # random word row number contained in s3
	
	
	
	lw	t0, debug
	bne	t0, 1, _start_main   # if debug mode is on then we will print the solution word to the user
	li	v0, 4
	la	a0, randomWord
	syscall
	move	a0, s3
	jal	print_solution	     # printing the solutino word to the user
	li	v0, 11
	li	a0, '\n'
	syscall
_start_main:	
	

	li	s0, 0        # counter variable for amount of attempts user has made
_enter_wordle_loop:
	
	jal	print_menu    # print the menu to the user
	
	
# allows user to input an option from the menu	
_user_choice:	
	li	v0, 5		# allow user to type integer
	syscall
	move	t0, v0
	
	beq	t0, 2, _end_wordle_loop     # if user typed 2 then end program 
	bne	t0, 1, _try_again  	    # if user did not type 1 then allow them to type a valid option	

_user_guess:
	li	v0, 11
	li	a0, '\n'
	syscall
	bge	s0, 5, _user_lost	# if user has made 5 attempts then they lose	
	li	v0, 4	
	la	a0, guessPromptMessage  # Asking the player to make a guess
	syscall
	
	
	
	li	v0, 8                # Allowing the player to enter a 5 letter word
	li	a1, 6
	la	a0, buffer
	syscall
	
	jal	validate_user_input  # checking to see if user inputed a 5 letter word
	beq	v0, 0, _user_guess   # if user inputed an invalid string then let them try again
	
	
	
	li	v0, 11               # This block is for formating
	li	a0, '\n'
	syscall
	li	v0, 4
	la	a0, addSpace
	syscall
	

	
	la	a0, buffer           
	jal	initialize_user_guess   # updates users guess array with their most recent entered guess
	
	
	
	la	a0, matrix
	la	a1, buffer
	jal	check_user_input        # Comparing users guess with solution word and updating usersGuess string accordingly
	move	s7, v0 
	
	jal	print_user_guess        # Printing users guess 
	bne	s7, 5, _another_try     # If our hit counter (s7) !=5 user did not guess the word correctly so allow them to try again
	li	v0, 11	   
	li	a0, '\n'
	syscall
	li	v0, 4    		# Print win screen message
	la	a0, winScreen
	syscall
	li	v0, 11      
	li	a0, '\n'
	syscall
	li	v0, 11      
	li	a0, '\n'
	syscall
	j	_generate_word		# allow the user to play again
	
	
	
# CASE: User did not guess the word correctly
# STEP: allow the user to make another guess	
_another_try:	
	li	v0, 11       # print a new line
	li	a0, '\n'
	syscall
	add	s0, s0, 1
	j	_user_guess
	
	
	
# CASE: User enters 2 to quit	
# STEP: Terminate program
_end_wordle_loop:
	li	v0, 10       
	syscall	
	
	
# CASE: User runs out of attempts
# STEP: Print lose screen to user and restart game	
_user_lost:
	li	v0, 4       
	la	a0, loseScreen
	syscall
	li	v0, 11       
	li	a0, '\n'
	syscall
	li	v0, 11      
	li	a0, '\n'
	syscall
	j	_generate_word	
	
	
# CASE: User does not enter 1 to play or 2 
# STEP: Print try again message and allow the user to type another input	
_try_again:
	li	v0, 11       
	li	a0, '\n'      
	syscall

	li	v0, 4
	la	a0, tryAgainMessage   
	syscall
	j	_user_choice          
	
