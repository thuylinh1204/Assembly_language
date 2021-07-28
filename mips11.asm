#“The sum of (s0) and (s1) is (result)” 
.data
message1 : .asciiz "The sum of "
message2 : .asciiz " and " 
message3 : .asciiz " is "
.text
 li $s0, 10
 li $s1, 20
 
 #printf message1:
  li $v0,4
  la $a0, message1
  syscall
   #printf $s0:
  li $v0,1
  add $a0, $s0,$zero
  syscall
   #printf message2:
  li $v0,4
  la $a0, message2
  syscall
   #printf $s1:
  li $v0,1
  add $a0, $s1,$zero
  syscall
   #printf message3:
  li $v0,4
  la $a0, message3
  syscall
   #printf result:
  li $v0,1
  add $a0, $s0,$s1
  syscall