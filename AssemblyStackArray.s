#Assembly Stack Usage for Arrays
#Capers Lever
#Created: 2/08/2015
#Last Modified: 2/08/2015
#CSCI ??? Applied Systems
#Grade: 75
#Comments: MIPS Assembly, user defined size of array.
#Developed in Mipster, open new Mipster file, copy and paste to run.

	.data	# Data declaration section
Size:	.asciiz "Enter size: "
User:	.asciiz	"Enter init: "
	.text

main:				#Start of code section
	li	$v0, 4
	la	$a0, Size
	syscall			#print enter size
	li 	$v0, 5
	syscall		
	move 	$a0, $v0	#user size in $a0
	mul	$s7, $a0, 4	#byte size of array
	jal	arrayFun
	move	$a0, $v0	#$t1 has answer from $v0
	li	$v0, 1
	syscall
	li	$v0, 10		
	syscall			# END OF PROGARM
	
arrayFun:
	subu	$sp, $sp, $s7	#getting size*4 of size
	move	$t0, $sp	#array adress at $t0
	subu	$sp, $sp, 4	#getting more stack space
	sw	$ra, 4($sp)	#storing return value
	move	$a1, $a0	#arguments flip for next call
	move	$a0, $t1	#moving address of array to first argument register
	jal	init
	move	$fp, $t1
	jal	sum
	li	$t1, 10		#loading 10 so sum * this
	mul	$v0, $v0, $t1	#mult answer into return register $v0
	lw	$ra, 4($sp)	#loading return address from stack
	add	$sp, $a1, $zero	#giving back stack space for array
	addi	$sp, 4		#giving back stack space for ra store
	jr	$ra		#returning to main
init:
	subu	$sp, $sp, 12	#stack space
	sw	$ra, 8($sp)	#return address
	sw	$a0, 4($sp)	#argument 0(array)
	sw	$a1, 0($sp)	#argument 1(size)
	li	$v0, 4
	la	$a0, User
	syscall			#print
	li	$v0, 5
	syscall			#getting user init
	move	$t9, $v0	#$t9 has user
	li	$t8, 0		#using as i in loop
	move	$fp, $t0	#frame pointer = array
	jal	Loop
	lw	$ra, 8($sp)	#getting ra to arrayFun
	lw	$a0, 4($sp)	
	lw	$a1, 0($sp)	#getting the right arg
	addi	$sp, 12		#giving back space in stack
	jr	$ra		#returning to arrayFun
Loop:
	add	$t6, $t8, $t9	
	#put $t6 into *$fp
	addi	$fp, $fp, 4	#frame pointer to next array position
	addi	$t8, $t8, 1	#i++
	bne	$t8, $t9, Loop
	jr	$ra
sum:
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	li	$t9, 0		#i
	jal	Loop2
	lw	$ra, 0($sp)
	jr	$ra
	
Loop2:
	add	$v0, $v0, $fp	
	addi	$fp, $fp, 4	#temp array pointer
	addi	$t9, $t9, 1	#i++
	bne	$t9, $a1, Loop2
	jr	$ra
