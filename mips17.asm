

#bubble sort
#for (i=0;i<n;i++){
# for (j=0;j<n-i;j++)
#  if (a[j]>a[j+1])
#    swap (a[j],a[j+1])
.data 
A: 	.word -5,9,3,5,7,4,-10,11
Aend: 	.word
.text
main: la $a0,A
	la $a1,Aend 
	subi $a1,$a1,4
	j buble_sort
after_sort: li $v0, 10 #exit
	syscall
buble_sort: 
	addi $t0,$a0,0
loop:	lw $v0,0($t0)
	lw $v1,4($t0)
	slt $t1,$v1,$v0
	beq $t1,$zero,skip_swap
	sw $v0,4($t0)
	sw $v1,0($t0)
skip_swap:
addi $t0,$t0,4
	beq $t0,$a1,done
	j loop
done: 	subi $a1,$a1,4
	beq $a1,$a0,end_sort
	j buble_sort	
end_sort: j after_sort


