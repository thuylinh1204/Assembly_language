#Laboratory Exercise 3, Home Assignment 1 
.data# Vung du lieu, chua cac khai bao bien
x: .word    1    # bien x, khoi tao gia tri
y: .word    1    # bien y, khoi tao gia tri
z: .word    1    # bien z, khoi tao gia tri

.text               # Vung lenh, chua cac lenh hop ngu
la	$a0, x      #Dua dia chi bien x vao thanh ghi a0
lw	$t1,0($a0)  # dua gia tri bien x vao thanh ghi t1
la	$a1, y      #Dua dia chi bien y vao thanh ghi a1
lw	$t2,0($a1)  # dua gia tri bien y vao thanh ghi t2
la	$a2, z      #Dua dia chi bien z vao thanh ghi a2
lw	$t3,0($a2)  # dua gia tri bien z vao thanh ghi t3

addi $s1,$zero,3       #Thanh ghi$s1= 3 =i
addi $s2,$zero,2       #Thanh ghi$s2= 2=j
start:  
slt $t0,$s2,$s1  # 2<3  j<i
bne $t0,$zero, else # branch to else if j<i   
addi $t1,$t1,1  #  then part: x=x+1  
addi $t3,$zero,1  # z=1  
j endif   # skip “else” part 
else: 
addi $t2,$t2,-1  # begin else part: y=y-1  
add $t3,$t3,$t3  # z=2*z 
endif:
