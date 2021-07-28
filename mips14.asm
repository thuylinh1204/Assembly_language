.data
mes: .asciiz "\n reverse: "
string: .space 50
reverse: .space 50
.text
	la $s0,string
	xor $s1,$0,$s0
read_char:
	li $v0,12
	syscall

	add $s1,$s0,$t0
	addi $t0,$t0,1
	beq $v0,10,end_read_char
	sb	$v0, 0($s1)
	beq	$t0, 20, end_read_char
	j	read_char
end_read_char:

get_length: 	
	la $a0, string 		# a0 = Address(string[0])
	#xor $v0, $zero, $zero  # v0 = length = 0
 	xor $t0, $zero, $zero 	# t0 = i = 0

check_char: 	
	add $t1, $a0, $t0 	# t1 = a0 + t0
 				#= Address(string[0]+i)
	lb $t2, 0($t1) 		# t2 = string[i]
 	beq $t2,$zero,end_of_str # Is null char?
 				#addi $v0, $v0, 1 # v0=v0+1->length=length+1
 	addi $t0, $t0, 1 # t0=t0+1->i = i + 1
 	j check_char
end_of_str:
end_of_get_length:
print_reverse:
	la $a0,string
	la $a1,reverse
	subi $s1,$t0,1
	xor $s0,$0,$0
loop:
	add $t1,$s1,$a0
	lb $t2,0($t1)
	add $t3,$s0,$a1
	sb $t2,0($t3)
	beq $s1,$0,exit
	addi $s0,$s0,1
	subi $s1,$s1,1
	j loop	
exit:
li $v0,4
la $a0,mes
syscall
li $v0,4
la $a0,reverse
syscall

