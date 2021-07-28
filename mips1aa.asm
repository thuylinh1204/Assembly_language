.data
a : .word 3
.text
la $s7,a
lui $s0, 0x1A8E
ori        $s0, $s0, 0x9C2B
   addi     $s1, $s0, -43
   andi     $s2, $s0, 0xFF00  
   sw        $s0, 0($s7)
   lb         $s3,2($s7)
