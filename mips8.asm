li $t0,0
addu $s3,$s1,$s2
xor $t1,$s3,$s1
bltz $t1, Overflow
j Exit
Overflow:
li $t0,1
Exit:
