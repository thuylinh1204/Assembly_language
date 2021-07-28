li $s0,2 #x
li $t0,5 #n
li $s1,0 #i=0
loop:
	mul $s0,$s0,2 #x = x*2
	addi $s1,$s1,1 #i = i+1
	bne $s1,$t0,loop #l?p ti?p n?u i khác n
