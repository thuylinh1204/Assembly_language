#Laboratory 3, Home Assigment 2 
.data
A: .word  1,9,5,4,3
sum: .word 0
.text               # Vung lenh, chua cac lenh hop ngu

addi $s1,$zero,0       #Thanh ghi$s1= 0 =i
addi $s5,$zero,1	#Thanh ghi $s5 =j=1
addi $s4,$zero,1       #Thanh ghi$s4= 1=step
addi $s3,$zero,5       #Thanh ghi$s3= 5=n
la $s2,A
la $a0, sum
lw $s5,0($a0)
loop:
	add  $s1,$s1,$s4  #i=i+step  
	add  $t1,$s1,$s1  #t1=2*s1  
	add $t1,$t1,$t1  #t1=4*s1   
	add $t1,$t1,$s2  #t1 store the address of A[i]  
	lw $t0,0($t1)  #load value of A[i] in $t0  
	
	start:

		add  $s5,$s5,$s4  #j=j+step
		add  $t2,$s5,$s5  #t2=2*s5  
		add $t2,$t2,$t2  #t2=4*s5   
		add $t2,$t2,$s2  #t2 store the address of A[j]  
		lw $t3,0($t2)  #load value of A[j] in $t3  
		
	slt $t4,$t0,$t3 #A[i]<A[j]	
	bne $s4,$zero,loop #if A[i]<A[j], goto loop 
	
	endif: