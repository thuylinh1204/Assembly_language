 .text
 addi $s1, $zero, 5 
  addi $s2, $zero, 6
 abs $s0,$s1 # |$s1|
 
sra $1,$s1,0x0000001f
xor $s0,$at,$s1
subu $s0,$s0,$at

move  $s0,$s1  #$s0 <= $s1 

addu $s0,$s1,$zero 

not   $s0,$s0
 
nor $s0,$s0,$zero

#ble $s1,$s2,L
#addi $t8, $zero, 1
#L:
#addi $t9, $zero, 1



slt $t0,$s1,$s2
bne $t0,$zero,L
addi $t8, $zero, 1
L:
addi $t9, $zero, 1
