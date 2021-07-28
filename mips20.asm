# de bai: Given a string which consists of lower alphabetic characters (a-z), count the number of different characters in it.
 
.data 
    string:     .space   500 				# do dai cua xau
    kytu:	.space 	 100				# ky tu khac nhau
    Message1:       .asciiz "Nhap xau:" 		# chuoi yeu cau nhap xau vao	
    Message2:   .asciiz "differentSymbolsNaive(s) = " 	# chuoi dua ra ket qua
    Message3:	.asciiz "\nCac ky tu khac nhau la: "	#
    ERROR:	.asciiz "Khong nhap gi!\n"		#
    Again:	.asciiz "Yeu cau nhap lai!!!"		#
    ERROR_KT:	.asciiz "Chi duoc nhap cac ky tu tu 'a'->'z' \n"
.text
 
main:	
	li $s3, 59	# ky tu ngan cach nhung ky tu khac nhau ;
	li $s4, 97	# ma ASSCI truoc 'a'
	li $s5, 122	# ma ASSCI sau 'z'
	la $s0, kytu	# lay dia chi cua chuoi kytu khai bao o tren
	li $s1, 0	# luu vi tri cua chuoi ky tu
	
	jal NHAP_XAU	# goi ham con nhap xau vao
	nop
	
	jal CHECK	# goi ham con de check xau vao
	nop
	
	jal CHUONGTRINH	# goi toi ham con de xu ky chuong trinh
	nop
end_main:		# thoat chuong trinh
	li $v0, 10
	syscall
	
NHAP_XAU:			# Nhap ki tu vao
	la $a0, Message1
    	la $a1, string
    	la $a2, 50
    	li $v0, 54
    	syscall
gan_xau:
	la $a0, string        	# a0 = Address(string[0]) 
	xor  $v0, $zero, $zero  # v0: ket qua dem duoc = 0  luu so ki tu khac nhau dem duoc. 
	add $t1, $t1, $zero	# t1 = i = 0
	
	jr $ra
CHECK:
	add $t7, $a0, $t1	# -------------------------
	lb $t8, 0($t7)		# kiem tra xem nguoi dung co nhap vao hay k? neu k bao loi va yeu cau nhap lai
	beq $t8, $zero, error	#-------------------------
	beq $t8, 10, end_check
	
	slt $s6, $t8, $s4	# if string[i] < 'a' ? 1 : 0
	slt $s7, $s5, $t8	# if string > 'z' ? 1 : 0
	
	or $t0, $s6, $s7
	
	bne $t0, $zero, error_kt
	
	addi $t1, $t1, 1
	
	j CHECK
end_check:
	jr $ra
 
CHUONGTRINH:
	xor $t1, $zero, $zero
	while:
		addi $t2, $t1, 1	# t2 = j = i + 1
		xor  $t0, $zero, $zero	# (t0 = 0) day la gia tri de xet cho viec kiem tra trung ky tu
		add $t3, $a0, $t1	# dia tri string[0]+i
		lb $t4, 0($t3)		# gia tri string[i]
	
		beq $t4, 10, end_while	# if string[i] == '\n' thi end_while
		beqz $t4, end_while	# if string[i] == '\0' thi end_while
 
	for:	
		add $t5, $a0, $t2	# dia tri string[0]+j
		lb $t6, 0($t5)		# gia tri string[j]
		beq $t6, 10, endfor	# if string[j] == '\n' thi end_for
	
		beqz $t6, endfor	# if string[j] == '\0' thi end_for
		beq $t6, $t4, if	# if string[i] == string[j] thi jump if
		addi $t2, $t2, 1	# j = j + 1
		j for			# jump lai for
	endfor:
		bne $t0, $zero, lap	# if $t0 != 0 thi se lap lai vong while va khong tang so ki tu khac nhau
	
		addi $v0, $v0,1		# tang so ki tu khac nhau
	
		add $s2, $s0, $s1	# lay dia tri cua kytu[k]
		sb $t4, 0($s2)		# luu ki tu string[i] khac nhau vao kytu[k]
		addi $s1, $s1, 1	# tang k = k + 1
		add $s2, $s0, $s1	# lay dia chi kytu[k+1]
		sb $s3, 0($s2)		# luu ky tu ';' vao kytu[k+1]
	
		addi $s1, $s1, 1
		
		addi $t1, $t1, 1  	# tang i len va quay lai vong while
		j while
	if:
		addi $t0, $t0, 1	# tang $t0 len 1
		addi $t2, $t2, 1	# tang j len va quay lai for
		j for
	lap:
		addi $t1, $t1, 1	# tang i len va quay lai
		j while
	end_while:			# dua ra so ki tu khac nhau
	
		add $s7, $zero, $v0	# luu tong so ky tu khac nhau
 
		la $a0, string		# in ra chuoi nhap vao
		li $v0, 4
		syscall 
 
		la $a0, Message2	# in ra thong bao ket qua
		li $v0, 4
		syscall 
    	
    		add $a0, $zero, $s7	# in ra ket qua
    		li $v0, 1
    		syscall 
    	    	
    		xor $v0, $zero, $zero
    	
    		la $a0, Message3	# in ra cau " cac ky tu khac nhau: "
    		li $v0, 4
    		syscall 
    	
    		li $v0, 4		# in ra cac ky tu khac nhau
    		la $a0, kytu
    		syscall 
    	
    		jr $ra
  
error:
	li $v0, 59
	la $a0, ERROR_KT
	la $a1, Again
	syscall 
	
	j main	# quay lai de nhap dung
error_kt:
	
	li $v0, 59
	la $a0, ERROR_KT
	la $a1, Again
	syscall 
	
	j main
