.data
Mes1 : .asciiz "Input VariableName: "
Var : .space  100
Mes2 : .asciiz "variableName(name) "
False : .asciiz " = false"
True : .asciiz " = true"
Error : .asciiz "No Input\n "


.text

main: 				#chuong trinh kiem tra ten bien
	jal INPUT  		
	nop
	jaL TEST
	nop
exit:
	li $v0,10
	syscall
end_main: 

		
	INPUT: 			#nhap ten bien
		 la $a0, Mes1
		 la $a1, Var 
		 la $a2, 50
		 li  $v0, 54
 		 syscall
   		jr $ra
 
  	TEST: 				#kiem tra ten bien
  		 la $a0, Var 
  		 add $t8,$ra,$zero
  		 jal CHECK
  		 nop
  		 add $ra,$t8,$zero
  		jr $ra
  
  		CHECK:
  			xor $t0,$zero,$zero
  			li $t1,47
  			li $t2,58
  			li $t3,64
  			li $t4,91
  			li $t5,96
  			li $t6,123
  			
  			#check Var[0]: 
  			add $s0,$a0,$t0
  			lb $s1,0($s0)
  			
  			beqz $s1,ERROR		#Var= null
  			
  			slt $s2,$t1,$s1
  			slt $s3,$s1,$t2
  			and $s4,$s2,$s3
  			bnez $s4,FALSE
  			
  			#check VarName:
  			LOOP:
  				add $s0,$a0,$t0
  				lb $s1,0($s0)
  			
  				beq $s1,10,TRUE  #\n -> kiem tra het xau-> dung
  				beq $s1,45,FALSE 
  			
  				slt $s2,$t3,$s1
  				slt $s3,$s1,$t4  
  				and $s4,$s2,$s3
  			
  				slt $s2,$t5,$s1
  				slt $s3,$s1,$t6
  				and $s5,$s2,$s3
  				
  				beq $s1,95,next
  				next: li $s6,1
  			
  				or $s4,$s5,$s4
  				or $s4,$s6,$s4	
  				beqz $s4,FALSE
  			
  				addi $t0,$t0,1
  			j LOOP
 
  
			TRUE: 
 			li $v0, 59
 			la $a0, Mes2
 			la $a1, True 
 			syscall
 			jr $ra 
  
  			FALSE:
  	 		li $v0, 59
 			la $a0, Mes2
 			la $a1, False
 			syscall
 	 		j exit
  
  		ERROR:				# bao loi chuong trinh vao yeu cau nhap lai
			li $v0, 59
			la $a0, Error
			syscall 
	
			j main	
