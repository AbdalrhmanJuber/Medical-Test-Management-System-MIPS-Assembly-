# This project handled by Abdalrhman juber(1211769) And Ismail Tarteer(1211243)
.data
error_msg: .asciiz "Error: Input must have exactly 7 digits\n"
error_id : .asciiz "There is no such ID existing!!\n"
error_test:.asciiz "There is no such test existing!!\n"
message : .asciiz "Insert on of the menu \n1. Add a new medical test\n2. Search for a test by patient ID:\n3. Search for unnormal tests \n4. Average test value \n5. Update an existing test\n6. Delete a test \n"
fin :.asciiz "C:\\Users\\a-ahm\\Desktop\\project.txt"
endofone :.asciiz "The data has been saved on the file \n" 
erorr : .asciiz "Error with opening the file !!"
erorr_Name : .asciiz "\nThe name is Invalid\n"
erorr_Date:.asciiz "\nThe Date is Invalid\n"
message_id:.asciiz "\n  Insert one of the menu \n1.Retrieve all patient tests\n2.Retrieve all up normal patient tests:\n3.Retrieve all patient tests in a given specific period \n"
integer : .asciiz "Enter the ID from 7 digits\n"
Test_name : .asciiz "Enter the test name with 3 characters\n"
Test_date : .asciiz "Enter the test date with 7 characters\n"
Test_result : .asciiz "Enter the result\n"
AVG : .asciiz " Averge: "
HGB: .asciiz "Hgb"
BGT: .asciiz "BGT"
LDL: .asciiz "LDL"
BPT: .asciiz "BPT"
DBP: .asciiz "DBP"
value1: .float 17.2
value2: .float 13.8
value3: .float 99
value4: .float 70
value5: .float 100
value6: .float 120
value7: .float 80
 ten_float:.float 10.0
 zero_float:.float 0.0
 value11: .asciiz "123456"
buffer_line : .byte 0:128
.align 2
buffer_update:.byte 0:512
buffer: .byte 0:512
TestName: .space 3
.align 2
TestDate: .space 7
.align 2
Data: .space 7
.align 2
DataFloat_1: .space 4
.align 2
DataFloat_2: .space 4
hundred:.float 100
NewLine: .asciiz "\n"
comma: .byte  ','
space: .byte  ' '
dot:.byte  '.'
colon: .byte ':'


.text
main:
	
#-------------------------------------------------------------------	
	#open a file for Reading medical tests
#-------------------------------------------------------------------	

	li $a1,0
	jal File_Open
	
	jal Read_File
	
	jal Close_File

#-----------------------------------------------------------------
	li   $v0, 4	#display The Menu
	la   $a0, message
	syscall

	li   $v0, 5	#Inserting the desired option from menu
	syscall

#-----------------switch----------------------------------------	
	#Selecting a desired number from the menu
	beq $v0, 1, Add_medical
	beq $v0, 2, Searching_ById
	beq $v0, 3, unnormal_tests
	beq $v0, 4, Average_test_value
	beq $v0, 5,Update_an_existing_test_result
	beq $v0, 6, Update_an_existing_test_result
#----------------------------------------------------------------

Add_medical:

#----------------------------------------------------------------
	#Ask the user for inputs
#-----------------------------------------------------------------
	li $v0, 4	
	la $a0, integer
	syscall
	#Integer ID read
	li   $v0, 5	
	syscall
	add $t9 , $v0 ,$zero 

	li $v0, 4	
	la $a0, Test_name
	syscall
	#Test name read
	li $v0, 8
	la $a0,TestName
	li $a1,4	
	syscall
	
	la $a1,($a0)
	li $a0,0
	jal check_test
	beqz $a0,Error_test


	li $v0, 4	
	la $a0, Test_date
	syscall
	#Test date read
	li $v0, 8
	la $a0,TestDate
	li $a1,8	
	syscall

	jal CheckForNameDate

	#reuslt read
	li   $v0, 4	
	la   $a0, Test_result
	syscall
	li   $v0, 6	#stores the value to f12
	syscall
	
	mov.s  $f12, $f0

#------------------------------------------------------------------------

#------------------Inverting integer to a string--------------------------
	move $a0, $t9
	la $a1,Data
	jal int2str
	move $t2,$v0
#-------------------------------------------------------------------	
	
#-------------------------------------------------------------------
	#-----From float to string------
#-------------------------------------------------------------------
	jal flot2str #Saves into t7 and t8
#-------------------------------------------------------------------
	#open a file for writing medical tests
#-------------------------------------------------------------------
	
	li $a1,1
	jal File_Open
	
	
#--------------Data ID -----------------------------------
	li  $a2, 7 
	la $a1,($t2)
	jal Write_File
#--------------":" -----------------------------------
	li   $a2, 1 
	la $a1,colon
	jal Write_File

#-------------- " " -----------------------------------
	li   $a2, 1  
	la $a1,space
	jal Write_File
#--------------Test Name -----------------------------------
	li   $a2, 3  
	la $a1,TestName
	jal Write_File
#--------------"," -----------------------------------
	li   $a2, 1  
	la $a1,comma
	jal Write_File
#-------------- " " -----------------------------------
	li   $a2, 1  
	la $a1,space
	jal Write_File
#--------------Date -----------------------------------
	li   $a2, 7  
	la $a1,TestDate
	jal Write_File
#--------------"," -----------------------------------
	li   $a2, 1  
	la $a1,comma
	jal Write_File
#-------------- " " -----------------------------------
	li   $a2, 1 
	la $a1,space
	jal Write_File
#--------------First float number -----------------------------------
	move $a3,$t7
	jal Compute_floatSize #Compuute the size of the first float
	la $a1,($t7)
	jal Write_File
#--------------"." -----------------------------------
	li   $a2, 1  
	la $a1,dot
	jal Write_File
#--------------second float number -----------------------------------
	move $a3,$t8
	jal Compute_floatSize #Compuute the size of the second float
	la $a1,($t8)
	jal Write_File

#--------------Buffer of saved file -----------------------------------
	
#--------------Newline'\n' -----------------------------------
	li   $a2, 1  
	la $a1,NewLine
	jal Write_File	
	
	li   $a2, 512  # hardcoded buffer length
	la $a1,buffer
	jal Write_File
		
	jal Close_File
	
	li   $v0, 4	
	la   $a0,endofone
	syscall
	j main
																																						
Update_an_existing_test_result:
	#----------------------------------------------------------------
	#Ask the user for inputs
#-----------------------------------------------------------------
	move $s7,$v0
	li $v0, 4	
	la $a0, integer
	syscall
	#Integer ID read
	li   $v0, 5	
	syscall
	add $t9 , $v0 ,$zero 

	li $v0, 4	
	la $a0, Test_name
	syscall
	#Test name read
	li $v0, 8
	la $a0,TestName
	li $a1,4	
	syscall
	
	la $a1,($a0)
	li $a0,0
	jal check_test
	beqz $a0,Error_test


	li $v0, 4	
	la $a0, Test_date
	syscall
	#Test date read
	li $v0, 8
	la $a0,TestDate
	li $a1,8	
	syscall

	jal CheckForNameDate

#------------------------------------------------------------------------

#------------------Inverting integer to a string--------------------------
	move $a0, $t9
	la $a1,Data
	jal int2str
	move $t4,$v0

	
Update:
     li $t0, 0	#For counting how many time did  id shows in the file , error non existing if not in the file
     la $t2, buffer
     la $a3, buffer
    
    find_next_line_update:
    lb $t3, 0($t2)  # Load the current character

    # If we reach the end of the buffer, exit the loop
    beq $t3, 0, end_of_file

    # If the current character is a newline, check the line for the ID
    beq $t3, '\n', check_line_id
    beq $a3,$t2, check_firstLine_patiant

    # Continue to the next character
    addi $t2, $t2, 1
    j find_next_line_update
    
    check_firstLine_patiant:
    move $t5, $t4  # Pointer to the ID string
    move $t6, $t2  # Pointer to the buffer at the current line
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, Check_TestName  # If end of ID string is reached, match found
    beq $t7, $t8, chars_match_update  # If characters match, continue
    j continue_search_update  # No match found, continue searching
    

check_line_id:
    # Compare the line in the buffer with the target ID
    addi $t2, $t2, 1
    move $t5, $t4  # Pointer to the ID string
    move $t6, $t2  # Pointer to the buffer at the current line

compare_id_update:
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, Check_TestName # If end of ID string is reached, match found
    beq $t7, $t8, chars_match_update  # If characters match, continue
    j continue_search_update # No match found, continue searching

Check_TestName:
    # Compare the line in the buffer with the target TestName
    la $t4, TestName # Pointer to the TestName
    move $t5, $t4  # Pointer to the TestName
    addi $t6, $t6, 2 #move to test name
    
compare_Test:
    lb $t7, 0($t5)  # Load current test name character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, Check_Date # If end of ID string is reached, match found
    beq $t7, $t8, chars_match_test  # If characters match, continue
    j continue_search_update  # No match found, continue searching
	
Check_Date:
# Compare the line in the buffer with the target TestName
    la $t4, TestDate # Pointer to the TestName
    move $t5, $t4  # Pointer to the TestName
    addi $t6, $t6, 2 #move to date name
    
compare_Date:
    lb $t7, 0($t5)  # Load current test name character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, matched_patiant # If end of ID string is reached, match found
    beq $t7, $t8, chars_match_date  # If characters match, continue
    j continue_search_update  # No match found, continue searching

chars_match_update:
    # Move both pointers forward
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j compare_id_update
    
chars_match_test:
    # Move both pointers forward
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j compare_Test
    
chars_match_date:
    # Move both pointers forward
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j compare_Date

matched_patiant:
     la $a0, buffer_update   # Load address of buffer_update
    la $a2, buffer  # Load address of buffer
JUMPA:
    beq $t2,$a2,Shift
    lb $t5, ($a2)         # Load byte from memory into $a1
    sb $t5, ($a0)         # Store byte from $a1 into buffer_line
    bne $t5,0,PPluss  # Branch if the byte is not 0
    j Print_updated_value
    
Shift:
	lb $t5,($a2)
	bne $t5,'\n',ADDE
	addiu $a2,$a2,1
	j JUMPA
	
ADDE:
	addiu $a2,$a2,1
	j Shift
    # Now buffer_line contains the data up to newline
    # Display the line if the ID matches (assuming buffer_line is a null-terminated string)
    addi $t0, $t0, 1	#How many time did the id shows
    li $v0, 4
    la $a0, buffer_line   # Load address of buffer_line
    syscall

    j find_next_line_update  # Jump back to the next line processing
    
 PPluss:
    addi $a2, $a2, 1      # Move to next byte in memory
    addi $a0, $a0, 1      # Move to next position in buffer_line
    j JUMPA

continue_search_update:
    # Increment $t2 until we find the end of the line
    addi $t2, $t2, 1
    j find_next_line_update  # Continue to the next character

Print_updated_value:
	beq $s7,6,delete
	
	#reuslt read
	li   $v0, 4	
	la   $a0, Test_result
	syscall
	li   $v0, 6	#stores the value to f0
	syscall
#-------------------------------------------------------------------	
	mov.s  $f12, $f0
#-------------------------------------------------------------------
	#-----From float to string------
#-------------------------------------------------------------------
	jal flot2str #Saves into t7 and t8
#-------------------------------------------------------------------
	#open a file for writing medical tests
#-------------------------------------------------------------------
	
	li $a1,1
	jal File_Open

#--------------Data ID -----------------------------------
	li  $a2, 7
	la $a1,Data+1
	jal Write_File
#--------------":" -----------------------------------
	li   $a2, 1 
	la $a1,colon
	jal Write_File

#-------------- " " -----------------------------------
	li   $a2, 1  
	la $a1,space
	jal Write_File
#--------------Test Name -----------------------------------
	li   $a2, 3  
	la $a1,TestName
	jal Write_File
#--------------"," -----------------------------------
	li   $a2, 1  
	la $a1,comma
	jal Write_File
#-------------- " " -----------------------------------
	li   $a2, 1  
	la $a1,space
	jal Write_File
#--------------Date -----------------------------------
	li   $a2, 7  
	la $a1,TestDate
	jal Write_File
#--------------"," -----------------------------------
	li   $a2, 1  
	la $a1,comma
	jal Write_File
#-------------- " " -----------------------------------
	li   $a2, 1 
	la $a1,space
	jal Write_File
#--------------First float number -----------------------------------
	move $a3,$t7
	jal Compute_floatSize #Compuute the size of the first float
	la $a1,($t7)
	jal Write_File
#--------------"." -----------------------------------
	li   $a2, 1  
	la $a1,dot
	jal Write_File
#--------------second float number -----------------------------------
	move $a3,$t8
	jal Compute_floatSize #Compuute the size of the second float
	la $a1,($t8)
	jal Write_File

#--------------Buffer of saved file -----------------------------------
	
#--------------Newline'\n' -----------------------------------
	li   $a2, 1  
	la $a1,NewLine
	jal Write_File	

	li   $a2, 512  # hardcoded buffer length
	la $a1,buffer_update
	jal Write_File
		
	jal Close_File
	
	li   $v0, 4	
	la   $a0,endofone
	syscall

	j main
		
delete:
	li $a1,1
	jal File_Open
	li   $a2, 512  # hardcoded buffer length
	la $a1,buffer_update
	jal Write_File
		
	jal Close_File
	
	li   $v0, 4	
	la   $a0,endofone
	syscall

	j main
		
Searching_ById:

	
#----------------------------------------------------------------
	#Ask the user for inputs
#-----------------------------------------------------------------

	li $v0, 4	
	la $a0, integer
	syscall
	#Integer ID read
	li   $v0, 5	
	syscall
	add $t0 , $v0 ,$zero 
	
	move $a0,$t0
	la $a1,Data
	jal int2str
	move $t4,$v0

	li   $v0, 4	#display The Menu
	la   $a0, message_id
	syscall

	li   $v0, 5	#Inserting the desired option from menu
	syscall
	
	move $t2,$v0
	

#-------------------------------------------------------------------
	

#-----------------switch-----------------------------------------
	beq $t2, 1, Retrieve_all_patient_tests_ById
	beq $t2, 2, Retrieve_all_up_normal_patient_tests
	beq $t2, 3, Retrieve_all_patient_tests_in_a_given_specific_period
#-----------------------------------------------------------------
	jr $ra

#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
#-----------------$t4 contains the string ID we are looking for---------------
Retrieve_all_patient_tests_ById:
     li $t0, 0	#For counting how many time did  id shows in the file , error non existing if not in the file
     la $t2, buffer
     la $a3, buffer
    
    find_next_line:
    lb $t3, 0($t2)  # Load the current character

    # If we reach the end of the buffer, exit the loop
    beq $t3, 0, end_of_file

    # If the current character is a newline, check the line for the ID
    beq $t3, '\n', check_line
    beq $a3,$t2, check_firstLine

    # Continue to the next character
    addi $t2, $t2, 1
    j find_next_line
    
check_firstLine:
    move $t5, $t4  # Pointer to the ID string
    move $t6, $t2  # Pointer to the buffer at the current line
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, matched_id  # If end of ID string is reached, match found
    beq $t7, $t8, chars_match  # If characters match, continue
    j continue_search  # No match found, continue searching

check_line:
    # Compare the line in the buffer with the target ID
    addi $t2, $t2, 1
    move $t5, $t4  # Pointer to the ID string
    move $t6, $t2  # Pointer to the buffer at the current line

compare_id:
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, matched_id  # If end of ID string is reached, match found
    beq $t7, $t8, chars_match  # If characters match, continue
    j continue_search  # No match found, continue searching

chars_match:
    # Move both pointers forward
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j compare_id

matched_id:
    la $a0, buffer_line   # Load address of buffer_line
JUMPH:
    lb $a1, ($t2)         # Load byte from memory into $a1
    sb $a1, ($a0)         # Store byte from $a1 into buffer_line
    bne $a1,10,Plus  # Branch if the byte is not a newline
	    li $t3,'\n'
    sb $t3, ($a0)         # Store new Line
    addi $a0, $a0, 1      # Move to next position in buffer_line
    sb $zero, ($a0)       # Store null terminator at end of buffer_line
    


    # Now buffer_line contains the data up to newline
    # Display the line if the ID matches (assuming buffer_line is a null-terminated string)
    addi $t0, $t0, 1	#How many time did the id shows
    li $v0, 4
    la $a0, buffer_line   # Load address of buffer_line
    syscall

    j find_next_line  # Jump back to the next line processing
    
 Plus:
    addi $t2, $t2, 1      # Move to next byte in memory
    addi $a0, $a0, 1      # Move to next position in buffer_line
    j JUMPH

continue_search:
    # Increment $t2 until we find the end of the line
    addi $t2, $t2, 1
    j find_next_line  # Continue to the next character

end_of_file:
    # End of file reached, return to caller
    beqz $t0,error_Id
    j main
    
error_Id:
    li $v0, 4
    la $a0, error_id   # Load address of buffer_line
    syscall
    j main

#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
Retrieve_all_up_normal_patient_tests:	
	
     li $t9,0	#For count how many time the id shows in the file error non existing if not in the file
     la $t2, buffer
     la $a3, buffer
    
   find_next_line_test:
    lb $t3, 0($t2)  # Load the current character

    # If we reach the end of the buffer, exit the loop
    beq $t3, 0, end_of_file_test

    # If the current character is a newline, check the line for the ID
    beq $t3, '\n', check_line_test
    beq $a3,$t2, check_firstLine_test

    # Continue to the next character
    addi $t2, $t2, 1
    j find_next_line_test
    
check_firstLine_test:
    move $t5, $t4  # Pointer to the ID string
    move $t6, $t2  # Pointer to the buffer at the current line
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, compare_tests_2 # If end of ID string is reached, match found
    beq $t7, $t8, Test_match  # If characters match, continue
    j continue_searchs  # No match found, continue searching

check_line_test:
    # Compare the line in the buffer with the target ID
    addi $t2, $t2, 1
    move $t5, $t4  # Pointer to the ID string
    move $t6, $t2  # Pointer to the buffer at the current line

compare_tests:
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, compare_tests_2# If end of ID string is reached, match found
    beq $t7, $t8, Test_match  # If characters match, continue
    j continue_searchs  # No match found, continue searching

Test_match:
    # Move both pointers forward
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j compare_tests

#Check for name of Test to compute its value 
compare_tests_2:
    addi $t6, $t6, 2
    move $a1,$t6
    jal check_test	# $a0 = 0 not matched ,Otherwise matched
    beq $a0, 0, continue_searchs  # No matched found !!
    bnez $a0, matched_value  # If characters match, continue
    j continue_searchs  # No match found, continue searching
    
 matched_value:
 	move $t9,$a0 #saves the number for the test , so we can use it later
       addi $t6, $t6, 14 #move to flaoting numbers
F:    lb $t8, 0($t6)  # Load current buffer character
	bne $t8,'.',add_f
	move $a0,$t6 #Address of dot for float number
	jal str2int_1 # for gettig the signe before the dot saved into $v0
	jal str2float_2 #for getting float number after dot saved into $f0
	mtc1 $v0,$f2
	cvt.s.w $f2,$f2
	add.s $f2,$f2,$f0 #For now we have the full floating nubmer
	move $a0,$t9
	jal  check_test_value   # $a3 = 1 pass 0 false
	beqz $a3 , continue_searchs  # No match found, continue searching
	j matched_test
	
	
add_f:	addi $t6, $t6, 1
	j F
 	
matched_test:
   la $a0, buffer_line   # Load address of buffer_line
JUMP:
    lb $a1, ($t2)         # Load byte from memory into $a1
    sb $a1, ($a0)         # Store byte from $a1 into buffer_line
    bne $a1,10,Pluss  # Branch if the byte is not a newline
    li $t3,'\n'
    sb $t3, ($a0)         # Store new Line
    addi $a0, $a0, 1      # Move to next position in buffer_line
    sb $zero, ($a0)       # Store null terminator at end of buffer_line
    


    # Now buffer_line contains the data up to newline
    # Display the line if the ID matches (assuming buffer_line is a null-terminated string)
    addi $t9, $t9, 1	#How many time did the id shows
    li $v0, 4
    la $a0, buffer_line   # Load address of buffer_line
    syscall

    j find_next_line_test  # Jump back to the next line processing
    
 Pluss:
    addi $t2, $t2, 1      # Move to next byte in memory
    addi $a0, $a0, 1      # Move to next position in buffer_line
    j JUMP

continue_searchs:
    # Increment $t2 until we find the end of the line
    addi $t2, $t2, 1
    j find_next_line_test  # Continue to the next character

end_of_file_test:
    # End of file reached, return to caller
    beqz $t9,Error_test
    j main
    
Error_test:
    li $v0, 4
    la $a0, error_test   # Load address of buffer_line
    syscall
    j main

Retrieve_all_patient_tests_in_a_given_specific_period:
	
	
	li $v0, 4	
	la $a0, Test_date
	syscall
     	li $v0, 8
	la $a0,TestDate
	li $a1,8	
	syscall

	jal CheckForNameDate

    la $s0,TestDate #Pointer to date

     li $t0, 0	#For counting how many time did  id shows in the file , error non existing if not in the file
     la $t2, buffer
     la $a3, buffer
    
    find_next_line_period:
    lb $t3, 0($t2)  # Load the current character

    # If we reach the end of the buffer, exit the loop
    beq $t3, 0, end_of_file_period

    # If the current character is a newline, check the line for the ID
    beq $t3, '\n', check_line_period
    beq $a3,$t2, check_firstLine_period

    # Continue to the next character
    addi $t2, $t2, 1
    j find_next_line_period
    
    
 check_line_period:
    # Compare the line in the buffer with the target ID
    addi $t2, $t2, 1
    move $t5, $t4  # Pointer to the ID string
    move $t6, $t2  # Pointer to the buffer at the current line
    
check_firstLine_period:
    move $t5, $t4  # Pointer to the ID string
    move $t6, $t2  # Pointer to the buffer at the current line
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, matched_period  # If end of ID string is reached, match found
    beq $t7, $t8, chars_match_period  # If characters match, continue
    j continue_search_period  # No match found, continue searching


compare_id_period:
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 0($t6)  # Load current buffer character
    beq $t7, 0, matched_period  # If end of ID string is reached, match found
    beq $t7, $t8, chars_match_period  # If characters match, continue
    j continue_search_period  # No match found, continue searching

chars_match_period:
    # Move both pointers forward
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j compare_id_period

matched_period:
     addi $t6, $t6, 7
     move $t1,$s0
D:  lb $t8, 0($t6)# Load current buffer character
      lb $t3, 0($t1)
      beq $t3, 0, matched_id_period # If end of ID string is reached, match found
      beq $t3, $t8, chars_period  # If characters match, continue
      j continue_search_period  # No match found, continue searching
      
chars_period:
    addi $t1, $t1, 1
    addi $t6, $t6, 1
    j D

matched_id_period:
    la $a0, buffer_line   # Load address of buffer_line
JUMPHP:
    lb $a1, ($t2)         # Load byte from memory into $a1
    sb $a1, ($a0)         # Store byte from $a1 into buffer_line
    bne $a1,10,PPlus  # Branch if the byte is not a newline
    li $t3,'\n'
    sb $t3, ($a0)         # Store new Line
    addi $a0, $a0, 1      # Move to next position in buffer_line
    sb $zero, ($a0)       # Store null terminator at end of buffer_line
    


    # Now buffer_line contains the data up to newline
    # Display the line if the ID matches (assuming buffer_line is a null-terminated string)
    addi $t0, $t0, 1	#How many time did the id shows
    li $v0, 4
    la $a0, buffer_line   # Load address of buffer_line
    syscall

    j find_next_line_period  # Jump back to the next line processing
    
 PPlus:
    addi $t2, $t2, 1      # Move to next byte in memory
    addi $a0, $a0, 1      # Move to next position in buffer_line
    j JUMPHP

continue_search_period:
    # Increment $t2 until we find the end of the line
    addi $t2, $t2, 1
    j find_next_line_period  # Continue to the next character

end_of_file_period:
    # End of file reached, return to caller
    beqz $t0,erorr_Date
    j main
#-------------------------------------------------------------------------------------
##########--$a1 for address of file test , $a0 > 1 fail and number for the test according how it was saved in the ascii data pass-----------#########
#-------------------------------------------------------------------------------------	
check_test:
	sw $ra, ($sp)         # Save return address to stack

	# Loop through each test
	li $t0, 1          # Index for tests array
loop:
	beq $t0, 6, no_match  # Exit loop if all tests checked
	
	# Load pointer to test name and compare
	bne $t0,1,N1
	la $t1 , HGB
	j TEST
N1:
	bne $t0,2,N2
	la $t1 , BGT
	j TEST
N2:
	bne $t0,3,N3
	la $t1 , LDL
	j TEST
N3:
	bne $t0,4,N4
	la $t1 , BPT
	j TEST
N4:
	la $t1, DBP
	j TEST
	
TEST: 
	jal compare_test      # Call function to compare
	
	bne $a0, $zero, pass  # If passed, set $a0 to 1 and exit
	addi $t0, $t0, 1      # Move to next test
	j loop
	
no_match:
	move $a0, $zero        # If no match, set $a0 to 0
	
	pass:
	lw $ra, ($sp)         # Restore return address
	jr $ra

# Function to compare two strings
# Inputs: $t1 = pointer to name of the test, $a1 = pointer to name of the file test
# Outputs: $a0 = number of the test mathched if match, $a0 = 0 if no match
compare_test:
	move $a3,$a1
P:
    lb $t5, ($a3)         # Load byte from name of the file test
    lb $t3, ($t1)         # Load byte from name of the test
    beqz $t3, passed      # If end of test name reached, passed
    bne $t3, $t5, failed  # If characters don't match, failed
    addi $t1, $t1, 1      # Move to next character in test name
    addi $a3, $a3, 1      # Move to next character in file test name
    j P

failed:
    li $a0, 0             # Strings do not match
    jr $ra                # Return

passed:
    move $a0, $t0             # Strings match
    jr $ra                # Return
    
    
    #----------------Checking test values must use check_test first------------------
    #----------------$a3 = 0 for  unupnormal , upnormal otherwise-----------------
    #----------------$a0 contains the name of a test----------------------------------
    #----------------#f2 contains the number of a test--------------------------------
 check_test_value:
	beq $a0,1,T1 #Hgb normal range : 13.8 (value2)- 17.2(value1)
	beq $a0,2,T2 #BGT : 70(value4) - 99(value3)
	beq $a0,3,T3 #LDL : < 100(value5)
	beq $a0,4,T4 #BPT : < 120(value6)
	beq $a0,5,T5 #DBP : < 80(value7)
	jr $ra
	
T1:    l.s $f4,value1
	 c.lt.s $f2 , $f4
	 bc1f Fall_value
	 l.s $f4,value2
	 c.lt.s $f4 , $f2
	 bc1f Fall_value
	 j true_value
	 
T2:    l.s $f4,value3
	 c.lt.s $f2 , $f4
	 bc1f Fall_value
	 l.s $f4,value4
	 c.lt.s $f4 , $f2
	 bc1f Fall_value
	 j true_value
	
T3:    l.s $f4,value5
	 c.lt.s $f2 , $f4
	 bc1f Fall_value
	 j true_value
	 
T4:    l.s $f4,value6
	 c.lt.s $f2 , $f4
	 bc1f Fall_value
	 j true_value
	 
T5:    l.s $f4,value7
	 c.lt.s $f2 , $f4
	 bc1f Fall_value
	 j true_value
	 
	 
Fall_value:
	li $a3 ,0
	jr $ra
	
true_value:
	li $a3 ,1
	jr $ra

	
unnormal_tests:	 	

	
#----------------------------------------------------------------
	#Ask the user for inputs
#-----------------------------------------------------------------

	
	li $v0, 4	
	la $a0, Test_name
	syscall
	#Test name read
	li $v0, 8
	la $a0,TestName
	li $a1,4	
	syscall
	
	la $a1,TestName
	li $a0,0
	jal check_test
	beqz $a0,Error_test
	
#-------------------------------------------------------------------

	
     li $t9,0	#For count how many time the id shows in the file error non existing if not in the file
     la $t2, buffer
     la $a3, buffer
     la $t4,TestName
    
   find_next_line_untest:
    lb $t3, 0($t2)  # Load the current character

    # If we reach the end of the buffer, exit the loop
    beq $t3, 0, end_of_file_test

    # If the current character is a newline, check the line for the ID
    beq $t3, '\n', check_line_untest
    beq $a3,$t2, check_firstLine_untest

    # Continue to the next character
    addi $t2, $t2, 1
    j find_next_line_untest
    
check_firstLine_untest:
    move $t5, $t4  # Pointer to the test string
    move $t6, $t2  # Pointer to the buffer at the current line
    lb $t7, 0($t5)  # Load current ID character
    lb $t8, 9($t6)  # Load current buffer character
    beq $t7, 0, compare_untests_2 # If end of ID string is reached, match found
    beq $t7, $t8, unTest_match  # If characters match, continue
    j uncontinue_searchs  # No match found, continue searching

check_line_untest:
    # Compare the line in the buffer with the target test name
    addi $t2, $t2, 1
    move $t5, $t4  # Pointer to the test name 
    move $t6, $t2  # Pointer to the buffer at the current line

compare_UNtests:
    lb $t7, 0($t5)  # Load current test name
    lb $t8, 9($t6)  # Load current buffer character
    beq $t7, 0, compare_untests_2# If end of test name is reached, match found
    beq $t7, $t8, unTest_match  # If characters match, continue
    j uncontinue_searchs  # No match found, continue searching

unTest_match:
    # Move both pointers forward
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j compare_UNtests

#Check for name of Test to compute its value 
compare_untests_2:
    la $a1,6($t6)
    jal check_test	# $a0 = 0 not matched ,Otherwise matched
    beq $a0, 0, uncontinue_searchs  # No matched found !!
    bnez $a0, matched_value_untest  # If characters match, continue
    j uncontinue_searchs  # No match found, continue searching
    
 matched_value_untest:
 	move $t9,$a0 #saves the number for the test , so we can use it later
       addi $t6, $t6, 20 #move to flaoting numbers
U:    lb $t8, 0($t6)  # Load current buffer character
	bne $t8,'.',add_u
	move $a0,$t6 #Address of dot for float number
	jal str2int_1 # for gettig the signe before the dot saved into $v0
	jal str2float_2 #for getting float number after dot saved into $f0
	mtc1 $v0,$f2
	cvt.s.w $f2,$f2
	add.s $f2,$f2,$f0 #For now we have the full floating nubmer
	move $a0,$t9
	jal  check_test_value   # $a3 = 1 pass 0 false
	bnez $a3 , uncontinue_searchs  # No match found, continue searching
	j matched_untest
	
	
add_u:	addi $t6, $t6, 1
	j U
 	
matched_untest:
   la $a0, buffer_line   # Load address of buffer_line
JUMPUN:
    lb $a1, ($t2)         # Load byte from memory into $a1
    sb $a1, ($a0)         # Store byte from $a1 into buffer_line
    bne $a1,10,Plussun  # Branch if the byte is not a newline
    li $t3,'\n'
    sb $t3, ($a0)         # Store new Line
    addi $a0, $a0, 1      # Move to next position in buffer_line
    sb $zero, ($a0)       # Store null terminator at end of buffer_line
    


    # Now buffer_line contains the data up to newline
    # Display the line if the ID matches (assuming buffer_line is a null-terminated string)
    addi $t9, $t9, 1	#How many time did the id shows
    li $v0, 4
    la $a0, buffer_line   # Load address of buffer_line
    syscall

    j find_next_line_untest  # Jump back to the next line processing
    
 Plussun:
    addi $t2, $t2, 1      # Move to next byte in memory
    addi $a0, $a0, 1      # Move to next position in buffer_line
    j JUMPUN

uncontinue_searchs:
    # Increment $t2 until we find the end of the line
    addi $t2, $t2, 1
    j find_next_line_untest  # Continue to the next character

			
Average_test_value:	 	
	li $s1,1	#Number of reached test
Next_test:
	beq $s1,6,main
	bne $s1,1,K1
	la $t4,HGB
	j Second_loop
K1: 
	bne $s1,2,K2
	la $t4,BGT
	j Second_loop
K2:
	bne $s1,3,K3
	la $t4,LDL
	j Second_loop
K3:
	bne $s1,4,K4
	la $t4,BPT
	j Second_loop
K4:
	la $t4,DBP
	j Second_loop



Second_loop:
     li $t9,0	#The number for such test has been showed
     la $t2, buffer
     la $a3, buffer
     lwc1 $f14,zero_float
    
   find_next_line_avg:
    lb $t3, 0($t2)  # Load the current character

    # If we reach the end of the buffer, exit the loop
    beq $t3, 0, end_of_file_test_avg

    # If the current character is a newline, check the line for the ID
    beq $t3, '\n', check_line_avg
    beq $a3,$t2, check_firstLine_avg

    # Continue to the next character
    addi $t2, $t2, 1
    j find_next_line_avg
    
check_firstLine_avg:
    move $t5, $t4  # Pointer to the test string
    move $t6, $t2  # Pointer to the buffer at the current line
    lb $t7, 0($t5)  # Load current test character
    lb $t8, 9($t6)  # Load current buffer character
    beq $t7, 0, compare_avg_2 # If end of test string is reached, match found
    beq $t7, $t8, AvgTest_match  # If characters match, continue
    j AVGcontinue_searchs  # No match found, continue searching

check_line_avg:
    # Compare the line in the buffer with the target test name
    addi $t2, $t2, 1
    move $t5, $t4  # Pointer to the test name 
    move $t6, $t2  # Pointer to the buffer at the current line

compare_Avgtests:
    lb $t7, 0($t5)  # Load current test name
    lb $t8, 9($t6)  # Load current buffer character
    beq $t7, 0, compare_avg_2 # If end of test name is reached, match found
    beq $t7, $t8, AvgTest_match  # If characters match, continue
    j AVGcontinue_searchs  # No match found, continue searching

AvgTest_match:
    # Move both pointers forward
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j compare_Avgtests

#Check for name of Test to compute its value 
compare_avg_2 :
    la $a1,6($t6)
    jal check_test	# $a0 = 0 not matched ,Otherwise matched
    beq $a0, 0, AVGcontinue_searchs  # No matched found !!
    bnez $a0, matched_value_Avgtest  # If characters match, continue
    j AVGcontinue_searchs  # No match found, continue searching
    
 matched_value_Avgtest:
       addi $t6, $t6, 20 #move to flaoting numbers
AV:    lb $t8, 0($t6)  # Load current buffer character
	bne $t8,'.',add_AV
	move $a0,$t6 #Address of dot for float number
	jal str2int_1 # for gettig the signe before the dot saved into $v0
	jal str2float_2 #for getting float number after dot saved into $f0
	mtc1 $v0,$f2
	cvt.s.w $f2,$f2
	add.s $f2,$f2,$f0 #For now we have the full floating nubmer inside $f2
	j matched_Avgtest
		
add_AV:	addi $t6, $t6, 1
	j AV
 	
matched_Avgtest:
    add.s $f14,$f14,$f2   #Avg value inside $f14 before the division
    addi $t9, $t9, 1	#How many time did the id shows
    j find_next_line_avg  # Jump back to the next line processing
    
AVGcontinue_searchs:
    # Increment $t2 until we find the end of the line
    addi $t2, $t2, 1
    j find_next_line_avg  # Continue to the next character

end_of_file_test_avg:
	#computing Avg test value
	mtc1 $t9,$f12
	cvt.s.w $f12,$f12
	div.s $f12,$f14,$f12  #avg / number of tests

	li   $v0, 4	
	la   $a0,($t4)
	syscall

	li   $v0, 4	
	la  $a0,AVG
	syscall

	li   $v0, 2	
	syscall

	li   $v0, 4	
	la  $a0,NewLine
	syscall


	addiu $s1,$s1,1
	j Next_test
																																																																																																																																																																																																																																																																																																																							
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																								
#----------------------------------------------------------------
	#Check data validation
#----------------------------------------------------------------
	
CheckForNameTest:
	li $t0,0
	li $t3,90
	la $t1,TestName
loope:	lb $t2,0($t1)
	sub $t2,$t3,$t2   #Sub the char from 'A' should be 0 =< A =< 25
	bgez $t2,W1
	j Invalid
W1:	ble $t2,90,W2
	j Invalid
W2:	addiu $t0, $t0, 1
	addiu $t1, $t1, 1
	beq $t0,3,W3
	bnez $t1, loope
	j W3
Invalid:
	li   $v0, 4	
	la   $a0,erorr_Name
	syscall	
	j End
W3:	jr $ra

CheckForNameDate:
	li $t0,0
	la $t1,TestDate
lloop:	lb $t2,0($t1)
        #Sould be integer
	bge $t2,48,E1
	j Iinvalid
E1:	ble $t2,57,E2
	j Iinvalid
	
E2:	addiu $t0, $t0, 1
	addiu $t1, $t1, 1
	beq $t0,6,E5
	beq $t0,7,E3
	bnez $t1, lloop
	
E5:	beq $t2,48,lloop
	beq $t2,49,lloop
	j E4
	  

Iinvalid:
	bne $t0,4,E4
	beq $t2,45,E2
E4:
	li   $v0, 4	
	la   $a0,erorr_Date
	syscall	
	j End
E3:	jr $ra
	


#-----------------------------------------------------------------
	
	#Handleing the error with erorr massege
Erorr:
	li   $v0, 4
	la   $a0, erorr
	syscall
	j End
	
	
File_Open:
	#$a1 should select its value before request this function!!						
	#open a fbuffer: .space 1024or writing
	li   $v0, 13       # system call for open file
	la   $a0, fin      # board file name
	li   $a2, 0
	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor 

	ble  $s6,$zero,Erorr  # Check if the file is not exit	
	jr $ra
	
Close_File:
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall 
	jr $ra
	
Write_File:
	li   $v0, 15       # system call for write to a file
	move $a0, $s6      # file descriptor  
	syscall            # write to a file	
	jr $ra
	
Read_File:
	li   $v0, 14      # system call for write to a file
	move $a0, $s6      # file descriptor  
	la   $a1,buffer
	li  $a2,512
	syscall            # write to a file	
	jr $ra
#----------------------------------------------------------
# int2str: Converts an unsigned integer into a string
# Input: $a0 = value, $a1 = buffer address (8 bytes)
# Output: $v0 = address of converted string in buffer
#----------------------------------------------------------
int2str:
    # Check if input integer has less than 7 or more than 7 digits
    li $t2, 1000000   # Load 1000000 to check for less than 7 digits
    blt $a0, $t2, error  # Branch to error if input has less than 7 digits
    li $t2, 10000000  # Load 10000000 to check for more than 7 digits
    bge $a0, $t2, error  # Branch to error if input has more than 7 digits

    li $t0, 10         # $t0 = divisor = 10
    addiu $v0, $a1, 8  # start at end of buffer 
    sb $zero, 0($v0)   # store a NULL character
L2: 
    divu $a0, $t0      # LO = value/10, HI = value%10
    mflo $a0           # $a0 = value/10
    mfhi $t1           # $t1 = value%10
    addiu $t1, $t1, 48 # convert digit into ASCII
    addiu $v0, $v0, -1 # point to previous byte
    sb $t1, 0($v0)     # store character in memory
    bnez $a0, L2       # loop if value is not 0
    jr $ra             # return to caller

error:
    # Handle error (print error message or exit)
    li $v0, 4          # syscall code for print string
    la $a0, error_msg  # load address of error message
    syscall            # print error message
    li $v0, 10         # syscall code for exit
    syscall            # exit program
	
#-----------------------------------------------------------
# str2int: Convert a string of digits into unsigned integer
# Input: $a0 = address of null terminated string
# Output: $v0 = unsigned integer value
#-----------------------------------------------------------
str2int_1:
	li $v0, 0 # Initialize: $v0 = sum = 0
	li $t0, 10 # Initialize: $t0 = 10
	addiu $a0, $a0, -1 # $a0 = address of next char
	lb $t1, 0($a0)
	bne $t1,' ',str2int_1
	addiu $a0, $a0, 1
S1: 	lb $t1, 0($a0) # load $t1 = str[i]
	blt $t1, '0', done # exit loop if ($t1 < '0')
	bgt $t1, '9', done # exit loop if ($t1 > '9')
	addiu $t1, $t1, -48 # Convert character to digit
	mul $v0, $v0, $t0 # $v0 = sum * 10
	addu $v0, $v0, $t1 # $v0 = sum * 10 + digit
	addiu $a0, $a0, 1 # $a0 = address of next char
	j S1 # loop back
#-----------------------------------------------------------
# str2int: Convert a string of digits into unsigned integer
# Input: $a0 = address of null terminated string
# Output: $f0 =  float value
#-----------------------------------------------------------
str2float_2:
	lwc1 $f0,  zero_float # Initialize: $f0 = sum = 0
	lwc1 $f1, ten_float # Initialize: $f1 = 10
	lwc1 $f3, ten_float # Initialize: $f1 = 10
	addiu $a0, $a0, 1 # $a0 = address of next char
	 lb $t1, 0($a0)
S2:	 lb $t1, 0($a0) # load $t1 = str[i]
	blt $t1, '0', done # exit loop if ($t1 < '0')
	bgt $t1, '9', done # exit loop if ($t1 > '9')
	addiu $t1, $t1, -48 # Convert character to digit
	mtc1 $t1,$f2
	cvt.s.w $f2,$f2
	div.s $f2, $f2, $f1 # $f0 = sum / 10
	mul.s $f1, $f1, $f3 # $f1 = 10*digit number
	add.s $f0, $f0, $f2 # $f0 = sum / 10 + digit
	addiu $a0, $a0, 1 # $a0 = address of next char
	j S2 # loop back
done:
 	 jr $ra # return to caller
	
int2str1:
	li $t0, 10 # $t0 = divisor = 10
	addiu $v0, $a1, 4 # start at end of buffer
	sb $zero, 0($v0) # store a NULL character
L1: 	divu $a0, $t0 # LO = value/10, HI = value%10
	mflo $a0 # $a0 = value/10
	mfhi $t1 # $t1 = value%10
	addiu $t1, $t1, 48 # convert digit into ASCII
	addiu $v0, $v0, -1 # point to previous byte
	sb $t1, 0($v0) # store character in memory
	bnez $a0, L1 # loop if value is not 0
	
	jr $ra # return to caller
#---------------------------------------------------------------------------	
#	t0 stores the integer values and the t1 stores the points value
#	So if we had 111.5 $t0 = 111 And $t5 = 50, We will t1/100 at the end
#---------------------------------------------------------------------------
flot2str: 
	lwc1 $f4,hundred 	#load 100 to $f4
	mov.s $f0,$f12 	#Value of folat
	cvt.w.s $f2,$f0	#Converts from single-precision float to integer
	mfc1 $t0,$f2	#Store the value of integer inside float register to $t0	
	mtc1 $t0,$f2	#Back to float(We did this to remove the points number)
	cvt.s.w $f2,$f2	#And we can able to get them by sub float - nonfloat
	sub.s $f5,$f0,$f2 #f.s-f = 0.s
	mul.s $f5,$f5,$f4 #We need the points to add then in the file so we mul them tp 100
	cvt.w.s $f3,$f5	#Converts them to integer
	mfc1 $t5,$f3	#Move the values for points to a temporary reg
	
	
	
	
	
#------------------------------------------------------------------------
   #	Convert values inside t0 & t5 into strings to save them in a file
 #------------------------------------------------------------------------
 Converts_Float:	
	sw $ra, 0($sp)
	move $a0,$t0
	la $a1,DataFloat_1
	jal int2str1
	
	move $t7,$v0
	
	move $a0,$t5
	la $a1,DataFloat_2
	jal int2str1

	move $t8,$v0

	
	lw $ra, 0($sp)
	jr $ra
	
	j End
#---------------$a3 value for float , $a2 reuslt (size of the value (digits))---------------
Compute_floatSize:
	li $t9,48
	li $a2,0 #counter
	la $t1,($a3)
Back:
	beq $t1 ,0 ,return_back #for null charv
	lb  $t0 , ($t1) 
	beq $t0 ,0 ,return_back #for null charv
	beq $t0 ,' ' ,LO
	blt $t0,48,return_back #if t0 < 48 ->0
	bgt $t0,57,return_back #if t0 > 57 ->9	
Add:
	addiu $a2,$a2,1
	addiu $t1,$t1,1
	j Back
return_back : jr $ra
LO:	sb $t9,($t1)
	j Add


End:
	li       $v0, 10        # system service 10 is exit
        syscall                 # we are outta here.

