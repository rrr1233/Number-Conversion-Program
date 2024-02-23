.data
prompt: .asciiz "#########Welcome to the convertor, this program will convert numbers to decimal, hex, and binary#########\n\n"

menu: .asciiz "\n(1) Enter a Binary Number\n(2) Enter a Decimal Number\n(3) Enter a Hexadecimal Number\n(4) Quit\n\n"
   
bin: .asciiz "Binary = " 
dec: .asciiz "Decimal = " 
hex: .asciiz "Hexadecimal = 0" 
 
tab:  .asciiz "\t" 
endl:  .asciiz "\n" 
   
inval_input: .asciiz "Error: Invalid input\n" 
inval_range: .asciiz "Error: Input is too large\n"  
  
choise: .asciiz "Enter your choice --> " 
prompt_bin: .asciiz "\nEnter a binary number (less than 33 digits) --> " 
prompt_hex: .asciiz "\nEnter a hexadecimal number (less than 7 digits) --> " 
prompt_dec: .asciiz "\nEnter a decimal number (less then 21474784647) " 
 
dec_num: .word 0 
num_buffer: .space 50 
 
.text 


addi $v0,$0, 4 # system call 4 to print a string 
la $a0, prompt # load address of string 
syscall 


ask_choice: 
addi $v0,$0, 4 # system call 4 to print a string 
la $a0, menu # load address of string 
syscall 
addi $v0,$0, 4 # system call 4 to print a string 
la $a0, choise # load address of string 
syscall 

addi $v0,$0, 5 # read a choice from user 
syscall 
beq $v0, 1, Binary # if choice is equal to 1 then enter binary 
beq $v0, 2, Decimal # if choice is equal to 2 then enter decimal 
beq $v0, 3, Hexa  # if choice is equal to 3 then enter hexadecimal 
beq $v0, 4, quit  # if choice is equal to 4 then quit 
 
addi $v0, $0, 4 # system call 4 to print a string 
la $a0, inval_input # load address of string 
syscall 

addi $v0,$0, 4 # system call 4 to print a string 



j ask_choice 
 
Binary: 
li $v0, 4 # system call 4 to print a string 
la $a0, prompt_bin # load address of string 
syscall 
 
li $v0, 8 # system call 8 to take input as string 
la $a0, num_buffer # address where number to store 
addi $a1, $0, 50 # len of input 
syscall 
 
la $a0, num_buffer # address of num 
jal is_valid_bin 
beq $v0, $0, bin_is_invalid # check that if return value is 0 means input is not valid 
addi $t0, $0, 32  # load 32 in t0 
bgt $v1, $t0, bin_is_out # check that if len of binary is greater than 32 it means it is invalid 
 
la $a0, num_buffer 
jal remove_ln  # by this method remove ln from the end of input 
 
li $v0, 4 # system call 4 to print a string 
la $a0, endl # load address of string 
syscall 
 
la $a0, bin # load address of string 
syscall 
 
la $a0, num_buffer # address of given number 
syscall 
 
la $a0, tab # print tab 
syscall 
 
la $a0, dec 
syscall 
 
la $a0, num_buffer #pass number 
jal bin_to_dec 
 
move $t0, $v0 
li $v0, 1  # print int 
move $a0, $t0 # print decimal number 
syscall 
 
li $v0, 4 
la $a0, tab # print tab 
syscall 
 
la $a0, hex 
syscall 
 
move $a0, $t0 # pass decimal number 
jal dec_to_hex 
 
jal print_hex_num 
 
j ask_choice 
 
bin_is_invalid: 
li $v0, 4 # system call 4 to print a string 
la $a0, inval_input # load address of string 
syscall 
j Binary 
bin_is_out: 
li $v0, 4 # system call 4 to print a string 
la $a0, inval_range # load address of string 
syscall 
j Binary 
 
 
Decimal: 
li $v0, 4 # system call 4 to print a string 
la $a0, prompt_dec # load address of string 
syscall 
 
li $v0, 8 # system call 8 to take input as string 
la $a0, num_buffer # address where number to store 
addi $a1, $0, 50 # len of input 
syscall 
 
la $a0, num_buffer 
jal remove_ln  # by this method remove ln from the end of input 
 
la $a0, num_buffer # address of num 
jal is_valid_dec 
beq $v0, $0, dec_is_invalid # check that if return value is 0 means input is not valid 
 
la $a0, num_buffer  # load number into $a0 
jal str_len   # call strlen function to find the length of that number 
la $a0, num_buffer  # load number into $a0 
la $a1, num_buffer  # load number into $a1 
add $a1, $a1, $v0  # add length of number into $a1 and store result into $a1 
jal str_to_int  # call atoi function to convert string to integer 
 
bltz $v0, dec_is_out 
 
addiu $t0, $0, 0xFFFFFFFF


bgtu  $v0, $t0, dec_is_invalid    # branch if $t2 is equal to zero means number is invalid 
sw $v0, dec_num  # store decimal number 
 
 
li $v0, 4 # system call 4 to print a string 
la $a0, endl # load address of string 
syscall 
 
la $a0, dec # load address of string 
syscall 
 
li $v0, 1  # print a int 
lw $a0, dec_num # load entered number 
syscall 
 
li $v0, 4 # system call 4 to print a string 
la $a0, tab # print tab 
syscall 
 
la $a0, hex 
syscall 
 
lw $a0, dec_num # pass decimal number 
jal dec_to_hex 
jal print_hex_num 
 
 
li $v0, 4 
la $a0, tab # print tab 
syscall 
 
la $a0, bin 
syscall 
 
lw $a0, dec_num # pass decimal number 
jal dec_to_bin 
jal print_int_num 
 
j ask_choice 
 
dec_is_invalid: 
li $v0, 4 # system call 4 to print a string 
la $a0, inval_input # load address of string 
syscall 
j Decimal 
dec_is_out: 
addi $v0, $0, 4 # system call 4 to print a string 
la $a0, inval_range # load address of string 
syscall 
j Decimal 
 
 
Hexa: 
li $v0, 4 # system call 4 to print a string 
la $a0, prompt_hex # load address of string 
syscall 
 
addi $v0, $0, 8 # system call 8 to take input as string 
la $a0, num_buffer # address where number to store 
addi $a1, $0, 50 # len of input 
syscall 
 
la $a0, num_buffer # address of num 
jal is_valid_hex 
beq $v0, $0, hex_is_invalid # check that if return value is 0 means input is not valid 
addi $t0, $0, 7  # load 7 in t0 
bgt $v1, $t0, hex_is_out # check that if len of hexa is greater than 8 it means it is invalid 
 
la $a0, num_buffer 
jal remove_ln  # by this method remove ln from the end of input 
 
la $a0, num_buffer 
jal small_cap_letter 
 
li $v0, 4 # system call 4 to print a string 
la $a0, endl # load address of string 
syscall 
 
la $a0, hex # load address of string 
syscall 
 
la $a0, num_buffer # address of given number 
syscall 
 
la $a0, tab # print tab 
syscall 
 
la $a0, dec 
syscall 
 
la $a0, num_buffer #pass number 
jal hex_to_dec 
 
move $t0, $v0 
li $v0, 36  # print int 
move $a0, $t0 # print decimal number 
syscall 
 
li $v0, 4 
la $a0, tab # print tab 
syscall 
 
la $a0, bin 
syscall 
 
move $a0, $t0 # pass decimal number 
jal dec_to_bin 
 
jal print_int_num 
 
j ask_choice 
 
hex_is_invalid: 
li $v0, 4 # system call 4 to print a string 
la $a0, inval_input # load address of string 
syscall 
j Hexa 
hex_is_out: 
li $v0, 4 # system call 4 to print a string 
la $a0, inval_range # load address of string 
syscall 
j Hexa 
 
 
quit: 
addi $v0, $0, 10 # system call 10 to terminate program 
syscall 
 
is_valid_dec: 
 li $v0, 1 
 vd_loop: 
 lb $s0, ($a0) 
 beq $s0, $0, stop_vd_loop 
 beq $s0, 10, stop_vd_loop 
 blt $s0, '0', inval_dec_inp # check byte is less than 0 
 bgt $s0, '9', inval_dec_inp # check byte is greater than 9 
 addi $a0, $a0, 1 # a0++ 
 j vd_loop 
 inval_dec_inp: 
 li $v0, 0 
 stop_vd_loop: 
 jr $ra  # return back 
 
is_valid_bin: 
 addi $v0, $0, 1 
 addi $v1, $0, 0 # counter = 0 
 vb_loop: 
 lb $s0, ($a0) 
 beq $s0, $0, stop_vb_loop 
 beq $s0, 10, stop_vb_loop 
 beq $s0, '0', next_vb_char # check byte is 0 or not 
 beq $s0, '1', next_vb_char # check byte is 1 or not 
 addi $v0, $0, 0  # return 0 if invalid 
 j stop_vb_loop 
 next_vb_char: 
 addi $v1, $v1, 1 # counter++ 
 addi $a0, $a0, 1 # a0++ 
 j vb_loop 
 stop_vb_loop: 
 jr $ra  # return back 
  
 
is_valid_hex: 
 li $v0, 1 
 li $v1, 0 # counter = 0 
 vh_loop: 
 lb $s0, ($a0) 
 beq $s0, $0, stop_vh_loop 
 beq $s0, 10, stop_vh_loop 
  
 blt $s0, '0', hexisinval 
 bgt $s0, '9', valcapletter 
 addi $v1, $v1, 1 # counter++ 
 j next_vh_char 
 valcapletter: 
 blt $s0, 'A',  hexisinval 
 bgt $s0, 'F', valsmaletter 
 addi $v1, $v1, 1 # counter++ 
 j next_vh_char 
 valsmaletter: 
 blt $s0, 'a',  hexisinval 
 bgt $s0, 'f', hexisinval 
 addi $v1, $v1, 1 # counter++ 
 j next_vh_char 
 hexisinval: 
 li $v0, 0  # return 0 if invalid 
 j stop_vh_loop 
 next_vh_char: 
 addi $a0, $a0, 1 # a0++ 
 j vh_loop 
 stop_vh_loop: 
 jr $ra 
  
 
str_len: 
 addi $a1, $0, 0   # load 0 into $a1 
 while_lenloop: 
 lb $a2, 0($a0)  # load character 
 beqz $a2, retLen 
 beq $a2, 10, retLen


addi $a0, $a0, 1  # update index 
 addi $a1, $a1, 1  # increament length 
 j while_lenloop 
 retLen: 
 move $v0, $a1  # return length 
 jr $ra 
 
remove_ln: 
 r_loop: 
 lb $s0, ($a0) 
 beq $s0, $0, stop_r_loop 
 beq $s0, 10, remove_endl 
 addi $a0, $a0, 1 # a0++ 
 j r_loop  # jump to r_loop 
 remove_endl: 
 sb $0, ($a0) # store \0 at the end of string 
 stop_r_loop: 
 jr $ra 
 
small_cap_letter: 
 sc_loop: 
 lb $s0, ($a0)  # load byte 
 beq $s0, $0, stop_sc_loop # check null byte 
 beq $s0, 10, stop_sc_loop # check break point 
 blt $s0, 'a', next_sc_byte 
 bgt $s0, 'f', next_sc_byte 
 addi $s0, $s0, -32  # small to captial 
 sb $s0, ($a0) 
 next_sc_byte: 
 addi $a0, $a0, 1 # a0++ 
 j sc_loop  # jump to sc_loop 
 stop_sc_loop: 
 jr $ra 
 
print_hex_num: 
 move $s0, $v0    # move $sp into $s0 
 move $s1, $v1    # move $v1 to $s1 
 p_forhl: 
 bgt $s1, $s0, returnp_forhn  
 lw $a0, ($s1)   # load word from stack 
 li $v0, 11    # system call 11 to print a char 
 syscall 
 addi $s1, $s1, 4   # update $s1 to adding 4 
 addi $sp, $sp, 4   # adding 4 into $sp 
 j p_forhl 
 returnp_forhn: 
 jr $ra 
  
 
print_int_num: 
 move $s0, $v0    # move $sp into $s0 
 move $s1, $v1    # move $v1 to $s1 
 for_IntNumLoop: 
 bgt $s1, $s0, returnfor_IntNum  
 lw $a0, ($s1)   # load word from stack 
 li $v0, 1    # print integer 
 syscall 
 addi $s1, $s1, 4   # update $s1 to adding 4 
 addi $sp, $sp, 4   # adding 4 into $sp 
 j for_IntNumLoop 
 returnfor_IntNum: 
 jr $ra    # return 
  
 
pow: 
 beqz $a1, returnp_one  # if $a1 == 0 then return power 1 
 li $s0, 1    # load 1 into $s0 
 li $v0, 1    # load 1 into $v0 
 for_powloop: 
 bgt $s0, $a1, returnfor_pow  
 mulu $v0, $v0, $a0  # mul $v0 with $a0 
 addi $s0, $s0, 1  # add 1 into $s0 
 j for_powloop 
 returnp_one: 
 li $v0, 1   # load 1 into $v0 
 jr $ra 
 returnfor_pow: 
 jr $ra   # return back 
 
bin_to_dec: 
 li $v0, 0                  
   li $t9, 16                
 firstbyte: 
 lb $s2, ($a0)        # load the byte 
 blt $s2, 48, returnbintodec      
   addi $a0, $a0, 1            # increment a0 
   subi $s2, $s2, 48           # subtract 48 to convert to int value 
   subi $t9, $t9, 1             
 beq $s2, 0, itiszero  # if $s2 == 0 then jump to itiszero 
 beq $s2, 1, itisone   # else if $s2 == 1 then jump to itisone 
 j  returnbintodec        
 
 itiszero: 
    j firstbyte 
 
 itisone:                     # do 2^counter  
    li $t8, 1                # load 1 
    sllv $t5, $t8, $t9      
    add $v0, $v0, $t5          # add sum to previous sum  
    j firstbyte 
 
 returnbintodec: 
    srlv $v0, $v0, $t9  #s hift bits right 
    jr $ra  
 
dec_to_bin: 
 addi $sp, $sp, -4   # make space on stack 
 move $v0, $sp    
 li $a1, 2     
 for_dectobin: 
 blez $a0, returnfor_dectobin # if $a0 == 0 then jump to label 
 div $a0, $a1   
 mfhi $s0   # load remainder into $s0 
 sw $s0, ($sp)  # store remaider on stack 
 addi $sp, $sp, -4   
 div $a0, $a0, $a1  # divide number / 2 
 j for_dectobin   
returnfor_dectobin: 
 addi $v1, $sp, 4     
 jr $ra    # return 
  
  
dec_to_hex: 
 addi $sp, $sp, -4   # allocate space on stack 
 move $v0, $sp 
 li $a1, 16    # load 16 into $a1 
 for_dectohex: 
 beqz $a0, returnfor_dectohex 
 div $a0, $a1 
 mfhi $s0 
 blt $s0, 10, conintochar # if $s0 < 10 then jump to conIntoChar 
 addi $s0, $s0, 55   
 strhex: 
 sw $s0, ($sp) 
 addi $sp, $sp, -4 
 div $a0, $a0, $a1 # number / 16 
 j for_dectohex 
returnfor_dectohex: 
 addi $v1, $sp, 4    
 jr $ra 
 conintochar: 
 addi $s0, $s0, 48   
 j strhex 
 
 
hex_to_dec: 
 addi $sp, $sp, -4    
 sw $ra, ($sp)    
 move $s2, $a0   # move number into $s2 
 li $s5, 0    # decimalNum = 0 
 li $s4, 0    # mod = 0 
 li $s6, 0    # len 
 li $s3, 10 
 jal str_len    # call strlen 
 move $s6, $v0   # len 
 lb $s7, ($s2)    
 while_htd: 
 beq $s7, '\0' returnwhile_htd   
 subi $s6, $s6, 1    # len-- 
 blt $s7, '0', checkcaplet    
 bgt $s7, '9', checkcaplet    
 sub $s4, $s7, 48    # mod = num[i] - 48 
 calhex: 
 li $a0, 16     
 move $a1, $s6   
 jal pow     
 mulu $s4, $s4, $v0   # (mod * pow(16, len))


add $s5, $s5, $s4   # decimalNum =  decimalNum + (mod * pow(16, len)) 
 htd_nextchar: 
 addi $s2, $s2, 1  # i++ 
 lb $s7, ($s2)  # load byte 
 j while_htd 
 checkcaplet: 
 blt $s7, 'A', checksmalet   
 bgt $s7, 'F', checksmalet   
 sub $s4, $s7, 55    # mod = num[i] - 55 
 j calhex 
 checksmalet: 
 blt $s7, 'a', htd_nextchar   
 bgt $s7, 'f', htd_nextchar    
 sub $s4, $s7, 87    # mod = num[i] - 87 
 j calhex 
 returnwhile_htd: 
 lw $ra, ($sp)    # load $ra from stack 
 addi $sp, $sp, 4    # deallocate space from stack 
 move $v0, $s5    # move $s5 into $v0 
 jr $ra 
  
 
str_to_int:              
 addi  $a1, $a1, -1      
 addi  $a0, $a0, -1      
 add  $v0, $zero, $zero    # initialize sum to 0 
 li  $t0, 10         
 li  $t3, 1 
 lb  $t1, 0($a1)       # load char  
 blt  $t1, 48, go_to_error    
 bgt  $t1, 57, go_to_error    
 addi  $t1, $t1, -48     
 add  $v0, $v0, $t1     
 addi  $a1, $a1, -1     # a1-- 
 to_string_loop:              
 mul  $t3, $t3, $t0     # multiply power by 10 
 beq  $a1, $a0, ret_val    
 lb  $t1, ($a1)          
 blt  $t1, 48, go_to_error     
 bgt  $t1, 57, go_to_error     
 addi  $t1, $t1, -48      
 mul  $t1, $t1, $t3     # t1*10^(counter) 
 add  $v0, $v0, $t1     # sumtotal += t1 
 addi  $a1, $a1, -1      # a1-- 
 j  to_string_loop              
  
go_to_error:             
add  $v0, $zero, $zero 
ret_val: 
jr $ra
