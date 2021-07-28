.text
li $s0, 0x12345678
andi $t0, $s0, 0xff000000   
andi $t1, $s0, 0xffffff00      	
ori $t2, $s0, 0xf0                 	
andi $t3, $s0,0x00000000   	
srl $t5,$s0,24          	
andi $t6, $s0,0x00ffff00      	
add $t4,$t4,$t5       	
add $t4,$t4,$t6
