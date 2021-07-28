.data 
inputControlCode: 	.space   50
lengthControlCode: 	.word    0
currentDirection: 	.word    0
path: 			.space   6000
lengthPath: 		.word    12
# KEYBOARD and DISPLAY MMIO ---------------------------------------------------------------------------------
.eqv KEY_CODE 		0xFFFF0004 			# Ma ASCII cua keyboard => Receiver Data register
.eqv KEY_READY 		0xFFFF0000			# Kiem tra khi co 1 phim duoc go(Tu dong xoa sau khi lw) => Receiver Control register
# MARSBOT RIDER	---------------------------------------------------------------------------------------------
.eqv HEADING 		0xffff8010 			# Integer: An angle between 0 and 359
							# 0 : North (up)
							# 90: East (right)
							# 180: South (down)
							# 270: West (left)
.eqv MOVING 		0xffff8050 			# Boolean: whether or not to move
.eqv LEAVETRACK 	0xffff8020 			# Boolean (0 or non-0): whether or not to leave a track
.eqv WHEREX 		0xffff8030 			# Integer: Current x-location of MarsBot
.eqv WHEREY 		0xffff8040 			# Integer: Current y-location of MarsBot
# DIGI LAB SIM -----------------------------------------------------------------------------------------------
.eqv IN_ADRESS_HEXA_KEYBOARD 	0xFFFF0012		# Xac dinh hang dang duoc nhan trong Digi Lab Sim	
.eqv OUT_ADRESS_HEXA_KEYBOARD 	0xFFFF0014		# Kiem tra phim nao duoc nhan
.eqv KEY_0 		0x11				# Ma hex cua cac phim trong Digi Lab Sim
.eqv KEY_1 		0x21
.eqv KEY_2 		0x41
.eqv KEY_3 		0x81
.eqv KEY_4 		0x12
.eqv KEY_5 		0x22
.eqv KEY_6 		0x42
.eqv KEY_7 		0x82
.eqv KEY_8 		0x14	
.eqv KEY_9 		0x24
.eqv KEY_a 		0x44
.eqv KEY_b 		0x84
.eqv KEY_c 		0x18
.eqv KEY_d 		0x28
.eqv KEY_e 		0x48
.eqv KEY_f 		0x88
# Marbot Control Code -----------------------------------------------------------------------------------------
MOVE_CODE: 	.asciiz   "1b4"
STOP_CODE: 	.asciiz   "c68"
GOLEFT_CODE: 	.asciiz   "444"
GORIGHT_CODE: 	.asciiz   "666"
TRACK_CODE: 	.asciiz   "dad"
UNTRACK_CODE: 	.asciiz   "cbc"
GOBACK_CODE: 	.asciiz   "999"
GO45_CODE:      .asciiz   "123"
WRONG_CODE:	.asciiz   "Input Code Invalid!"
#==============================================================================================================
# Main Code ---------------------------------------------------------------------------------------------------
.text
Main:
		li   $k0,  KEY_CODE					 
		li   $k1,  KEY_READY
		
		li   $t1,  IN_ADRESS_HEXA_KEYBOARD
		li   $t3,  0x80 					
		sb   $t3,  0($t1)					
Loop:									# Bat dau vong lap doc du lieu tu Digi Lab Sim
		nop							
		nop
WaitForKey:	
		lw   $t5,  0($k1)					# $t5 = [$k1] = KEY_READY
		nop
		beq  $t5,  $zero,  WaitForKey				# Neu $t5 == 0 thi lap lai (Pooling)
		nop
		beq  $t5,  $zero,  WaitForKey
		nop
ReadKey:								# Sau khi co phim duoc nhan
		lw   $t6,  0($k0)					# $t6 = [$k0] = KEY_CODE
		beq  $t6,  127,  RemoveInputCode			# Neu $t6 == DEL key (Ascii: 127) thi xoa het code nhap vao
		bne  $t6,  '\n',  Loop					# if $t6 != ENTER key thi tiep tuc lap lai (Pooling)
		nop
CheckControlCode:							# Kiem tra code nhap vao thuc hien di chuyen
		la   $s2,  lengthControlCode			
		lw   $s2,  0($s2)
		bne  $s2,  3,  PushError				# Bao loi neu do dai lenh khac 3
		
		la   $s3,  MOVE_CODE					# Kiem tra co phai lenh Move khong
		jal  IsEqualString					# Kiem tra code co phai la MOVE_CODE tra ve 1 hoac 0 
		beq  $t0,  1,  Go					# Neu dung thi thuc hien lenh
		
		la   $s3,  STOP_CODE					# Kiem tra co phai lenh Stop khong
		jal  IsEqualString
		beq  $t0,  1,  Stop
			
		la   $s3,  GOLEFT_CODE					# Kiem tra co phai lenh GoLeft khong
		jal  IsEqualString
		beq  $t0,  1,  GoLeft
		
		la   $s3,  GORIGHT_CODE					# Kiem tra co phai lenh GoRight khong
		jal  IsEqualString
		beq  $t0,  1,  GoRight
		
		la   $s3,  TRACK_CODE					# Kiem tra co phai lenh TrackPath khong
		jal  IsEqualString
		beq  $t0,  1,  Track

		la   $s3,  UNTRACK_CODE					# Kiem tra co phai lenh UntrackPath khong	
		jal  IsEqualString
		beq  $t0,  1,  Untrack
		
		la   $s3,  GOBACK_CODE					# Kiem tra co phai lenh GoBack khong
		jal  IsEqualString
		beq  $t0,  1,  GoBack
		
		la   $s3,  GO45_CODE					# Kiem tra co phai lenh GoBack khong
		jal  IsEqualString
		beq  $t0,  1,  Go45
		beq  $t0,  0,  PushError				# Bao loi neu khong phai cac lenh tren
		nop	
PrintControlCode:							# In code ra man hinh console
		li   $v0, 4
		la   $a0, inputControlCode
		syscall 
		nop	
RemoveInputCode:							# Xoa code vua nhap quay tro lai nhan lenh moi
		jal  RemoveControlCode			
		nop
		j    Loop
		nop		
PushError: 								# In code ra console, bao loi va xoa code vua nhap
		li   $v0,  4
		la   $a0,  inputControlCode
		syscall
		nop
		
		li   $v0,  55
		la   $a0,  WRONG_CODE
		syscall
		nop
		j    RemoveInputCode
		nop
#======================================================================================================================	
# Track procedure, control marsbot to track and print control code ----------------------------------------------------
Track: 		jal  TRACK
		j    PrintControlCode
# Untrack procedure, control marsbot to untrack and print control code ------------------------------------------------
Untrack: 	jal  UNTRACK
		j    PrintControlCode
# Go procedure, control marsbot to go and print control code ----------------------------------------------------------
Go: 		jal  GO
		j    PrintControlCode
# Stop procedure, control marsbot to stop and print control code ------------------------------------------------------
Stop: 		jal  STOP
		j    PrintControlCode
# GoRight procedure, control marsbot to go right and print control code ------------------------------------------------
GoRight:								
		addi $sp,  $sp,  -8
		sw   $s5,  0($sp)
		sw   $s6,  4($sp)
		
		jal  UNTRACK 						# Giu track cu 
		nop
		#jal  TRACK 						# Ve track tu vi tri moi
		nop
		
		la   $s5,  currentDirection				# Cap nhat currentDirection + 90 
		lw   $s6,  0($s5)						
		addi $s6,  $s6,  90 					
		sw   $s6,  0($s5) 						
		
		lw   $s6,  4($sp)
		lw   $s5,  0($sp)
		addi $sp,  $sp,  8
	
		jal  StorePath
		jal  ROTATE
		nop
		j    PrintControlCode	
# GoLeft procedure, control marsbot to go left and print control code -------------------------------------------------
GoLeft:		
		addi $sp,  $sp,  -8
		sw   $s5,  0($sp)
		sw   $s6,  4($sp)
		
		jal  UNTRACK 						# Giu track cu
		nop
		#jal  TRACK 						# Ve track tu vi tri moi
		nop
		
		la   $s5,  currentDirection
		lw   $s6,  0($s5)					# Cap nhat currentDirection - 90 
		addi $s6,  $s6,  -90
		sw   $s6,  0($s5) 				

		lw   $s6,  4($sp)
		lw   $s5,  0($sp)
		addi $sp,  $sp,  8
		
		jal  StorePath
		jal  ROTATE
		nop
		j    PrintControlCode	
#  GoBack procedure, control marsbot go back ----------------------------------------------------------------------------
GoBack:		
		addi $sp,  $sp,  -28
		sw   $s5,  0($sp)
		sw   $s6,  4($sp)
		sw   $s7,  8($sp)
		sw   $t6,  12($sp)
		sw   $t7,  16($sp)
		sw   $t8,  20($sp)
		sw   $t9,  24($sp)
	
		jal  UNTRACK
		la   $s7,  path
		la   $s5,  lengthPath
		lw   $s5,  0($s5)
		add  $s7,  $s7,  $s5
Begin:		
		addi $s5,  $s5,  -12 					# Giam lengthPath 12 byte
		addi $s7,  $s7,  -12		
		lw   $s6,  8($s7)					# $s6 = goc trong buoc di lenh cuoi cua marbot
		addi $s6,  $s6,  180					# Quay 180* => Di nguoc lai
		
		
		la   $t7,  currentDirection				# cap nhat currentDirection = $s6 cho marbot thuc hien quay
		sw   $s6,  0($t7)
		jal  ROTATE						# Quay nguoc 180
		lw   $t8,  0($s7)					# toa do x cua diem dau tien cua canh
		lw   $t9,  4($s7)					# toa do y cua diem dau tien cua canh
		jal  GO
GoPrevPoint:	
		li   $t6,  WHEREX					# Toa do x hien tai
		lw   $t6,  0($t6)
		li   $t7,  WHEREY					# toa do y hien tai
		lw   $t7,  0($t7)
		bne  $t6,  $t8,  GoPrevPoint
		bne  $t7,  $t9,  GoPrevPoint
		jal  STOP
		bne  $s5, 0, Begin
		beq  $s5, 0, Finish					# Khi da di chuyen het path thi Finish
		nop
Finish:	
		jal  STOP
		la   $t8,  currentDirection
		add  $s6,  $zero,  $zero
		sw   $s6,  0($t8)					# Cap nhat currentDirection = 0
		la   $t8,  lengthPath
		sw   $s5,  0($t8)					# Cap nhat lengthPath = 0
		
		lw   $t9,  24($sp)
		lw   $t8,  20($sp)
		lw   $t7,  16($sp)
		lw   $t6,  12($sp)
		lw   $s7,  8($sp)
		lw   $s6,  4($sp)
		lw   $s5,  0($sp)
		addi $sp,  $sp,  28
		
		j    PrintControlCode
# Go45 proceduce
Go45:		
		addi $sp,  $sp,  -8
		sw   $s5,  0($sp)
		sw   $s6,  4($sp)
		
		jal  UNTRACK 						# Giu track cu
		nop
		#jal  TRACK 						# Ve track tu vi tri moi
		nop
		
		la   $s5,  currentDirection
		lw   $s6,  0($s5)					# Cap nhat currentDirection 45
		addi $s6,  $s6,  45
		sw   $s6,  0($s5) 				

		lw   $s6,  4($sp)
		lw   $s5,  0($sp)
		addi $sp,  $sp,  8
		
		jal  StorePath
		jal  ROTATE
		nop
		j    PrintControlCode			
		
		
		
# GO procedure, to start running -------------------------------------------------------------------------------------
GO: 	
		addi $sp,  $sp,  -8					# store du lieu cua $at, $k0 vao stack
		sw   $at,  0($sp)
		sw   $k0,  4($sp)
					
		li   $at,  MOVING 					# Gan MOVING = 1
 		addi $k0,  $zero,  1 			
		sb   $k0,  0($at)	 				
				
		lw   $k0,  4($sp)					# load lai du lieu cua $at, $k0 tu stack
		lw   $at,  0($sp)
		addi $sp,  $sp,  8

		jr   $ra
		nop
# STOP procedure, to stop running -------------------------------------------------------------------------------------
STOP: 					
		addi $sp,  $sp,  -4					# store du lieu cua $at vao stack
		sw   $at,  0($sp)
					
		li   $at,  MOVING			 		# Gan MOVING = 0
		sb   $zero,  0($at) 		
					
		lw   $at,  0($sp)					# load lai du lieu cua $at tu stack
		addi $sp,  $sp,  4
	
		jr   $ra
		nop
# TRACK procedure, to start drawing line ------------------------------------------------------------------------------
TRACK: 					
		addi $sp,  $sp,  -8					# store du lieu cua $at, $k0 vao stack
		sw   $at,  0($sp)
		sw   $k0,  4($sp)
					
		li   $at,  LEAVETRACK		 			# Gan LEAVETRACK = 1
		addi $k0,  $zero,  1 			
 		sb   $k0,  0($at)			
 					
		lw   $k0,  4($sp)					# load lai du lieu cua $at, $k0 tu stack
		lw   $at,  0($sp)
		addi $sp,  $sp,  8
	
 		jr   $ra
		nop
# UNTRACK procedure, to stop drawing line ------------------------------------------------------------------------------
UNTRACK:				
		addi $sp,  $sp,  -4					# store du lieu cua $at vao stack
		sw   $at,  0($sp)
						
		li   $at,  LEAVETRACK 					# Gan LEAVETRACK = 0
 		sb   $zero,  0($at) 				

		lw   $at,  0($sp)					# load lai du lieu cua $at tu stack
		addi $sp,  $sp,  4
	
 		jr   $ra
		nop
# ROTATE procedure, to control robot to rotate -------------------------------------------------------------------------
ROTATE: 	
		addi $sp,  $sp,  -12					# store du lieu cua $t1, $t2, $t3 vao stack
		sw   $t1,  0($sp)
		sw   $t2,  4($sp)
		sw   $t3,  8($sp)
					
		li   $t1,  HEADING		 			# Gan HEADING = currentDirection
		la   $t2,  currentDirection
		lw   $t3,  0($t2)				
 		sw   $t3,  0($t1) 				
 					
 		lw   $t3,  8($sp)					# load lai du lieu cua $t1, $t2, $t3 tu stack
		lw   $t2,  4($sp)
		lw   $t1,  0($sp)
		addi $sp,  $sp,  12
	
 		jr   $ra
		nop
#========================================================================================================================	
# Check String is Control Code ------------------------------------------------------------------------------------------
IsEqualString:
		addi $sp,  $sp,  -16					# Store $t1, $s1, $t2, $t3 vao stack
		sw   $s1,  0($sp)
		sw   $t1,  4($sp)
		sw   $t2,  8($sp)
		sw   $t3,  12($sp)	
	
		addi $t1,  $zero,  0					# $t1 = i = 0
		add  $t0,  $zero,  $zero
		la   $s1,  inputControlCode				# $s1 = inputControlCode
LoopCheckEqual: 							# So sanh tung ki tu trong inputControlCode voi ma code trong $s3
		add  $t2,  $s1,  $t1				
		lb   $t2,  0($t2)					
		add  $t3,  $s3,  $t1				
		lb   $t3,  0($t3)					
		addi $t1,  $t1,  1	
		bne  $t2,  $t3,  IsNotEqual			
		bne  $t1,   3,  LoopCheckEqual			
		nop
IsEqual:
		lw   $t3,  12($sp)		
		lw   $t2,  8($sp)
		lw   $t1,  4($sp)
		lw   $s1,  0($sp)
		addi $sp,  $sp,  16
	
		add  $t0,  $zero,  1					# Cap nhat $t0 = 1 
		jr   $ra
		nop 
IsNotEqual:
		lw   $t3,  12($sp)
		lw   $t2,  8($sp)
		lw   $t1,  4($sp)
		lw   $s1,  0($sp)
		addi $sp,  $sp,  16

		add  $t0,  $zero,  $zero				# Cap nhat $t0 = 0
		jr $ra
		nop
# Remove Control Code ----------------------------------------------------------------------------------
RemoveControlCode:
		addi $sp,  $sp,  -20
		sw   $t1,  0($sp)
		sw   $t2,  4($sp)
		sw   $t3,  8($sp)
		sw   $s1,  12($sp)
		sw   $s2,  16($sp)
	
		la   $s2,  lengthControlCode
		lw   $t3,  0($s2)					
		la   $s1,  inputControlCode
		addi $t1,  $zero,  0				
		addi $t2,  $zero,  0					# $t2 = '\0'
LoopToRemoveCode: 							# Cap nhat cac inputControlCode[i] = '\0' 
		sb   $t2,  0($s1)						
		addi $t1,  $t1,  1					
		add  $s1,  $s1,  1					
		bne  $t1,  $t3,  LoopToRemoveCode
		nop
		
		add  $t3,  $zero,  $zero			
		sw   $t3,  0($s2)					# Cap nhat lengthControlCode = 0
		
		lw   $s2,  16($sp)
		lw   $s1,  12($sp)
		lw   $t3,  8($sp)
		lw   $t2,  4($sp)
		lw   $t1,  0($sp)
		addi $sp,  $sp,  20
	
		jr   $ra
		nop 
# StorePath ---------------------------------------------------------------------------------------------
StorePath:
		addi $sp,  $sp,  -32
		sw   $t1,  0($sp)
		sw   $t2,  4($sp)
		sw   $t3,  8($sp)
		sw   $t4,  12($sp)
		sw   $s1,  16($sp)
		sw   $s2,  20($sp)
		sw   $s3,  24($sp)
		sw   $s4,  28($sp)
	
		li   $t1,  WHEREX					# Lay (x, y, direction) hien tai cua marbot
		lw   $s1,  0($t1)					
		li   $t2,  WHEREY	
		lw   $s2,  0($t2)					
		la   $s4,  currentDirection
		lw   $s4,  0($s4)					
		la   $t3,  lengthPath
		lw   $s3,  0($t3)					
		la   $t4,  path
		add  $t4,  $t4,  $s3					# Dua con tro den cuoi cung cua path
					
		sw   $s1,  0($t4)					# Luu (x, y, direction) vao path
		sw   $s2,  4($t4)					
		sw   $s4,  8($t4)					
		addi $s3,  $s3,  12					# Tang do dai len them 12 byte = 3 bien * 4 byte				
		sw   $s3,  0($t3)
		
		lw   $s4,  28($sp)
		lw   $s3,  24($sp)
		lw   $s2,  20($sp)
		lw   $s1,  16($sp)
		lw   $t4,  12($sp)
		lw   $t3,  8($sp)
		lw   $t2,  4($sp)
		lw   $t1,  0($sp)
		addi $sp,  $sp,  32
						
		jr   $ra
		nop
#======================================================================================================
# Interrupt: Ngat chuong trinh main de thuc hien cac lenh o vung nho 0x80000180 sau do quay tro lai main
# Xay ra khi co cac thiet bi ngoai duoc kich hoat nhu Digi Lab Sim
.ktext 0x80000180	
BackUp: 
		addi $sp,  $sp,  -44
		sw   $ra,  0($sp)
		sw   $t1,  4($sp)
		sw   $t2,  8($sp)
		sw   $t3,  12($sp)
		sw   $t4,  16($sp)
		sw   $a0,  20($sp)
		sw   $at,  24($sp)
		sw   $s0,  28($sp)
		sw   $s1,  32($sp)
		sw   $s2,  36($sp)
		sw   $s3,  40($sp)	
# Get Char Code From Digi Lab Sim ----------------------------------------------------------------
GetCode:
		li   $t1,  IN_ADRESS_HEXA_KEYBOARD
		li   $t2,  OUT_ADRESS_HEXA_KEYBOARD
ScanRow1:
		li   $t3,  0x81
		sb   $t3,  0($t1)
		lbu  $a0,  0($t2)
		bnez $a0,  GetCharCode
		nop
ScanRow2:
		li   $t3,  0x82
		sb   $t3,  0($t1)
		lbu  $a0,  0($t2)
		bnez $a0,  GetCharCode
		nop
ScanRow3:
		li   $t3,  0x84
		sb   $t3,  0($t1)
		lbu  $a0,  0($t2)
		bnez $a0,  GetCharCode
		nop
ScanRow4:
		li   $t3,  0x88
		sb   $t3,  0($t1)
		lbu  $a0,  0($t2)
		bnez $a0,  GetCharCode
		nop
GetCharCode:
		beq  $a0,  KEY_0,  case0
		beq  $a0,  KEY_1,  case1
		beq  $a0,  KEY_2,  case2
		beq  $a0,  KEY_3,  case3
		beq  $a0,  KEY_4,  case4
		beq  $a0,  KEY_5,  case5
		beq  $a0,  KEY_6,  case6
		beq  $a0,  KEY_7,  case7
		beq  $a0,  KEY_8,  case8
		beq  $a0,  KEY_9,  case9
		beq  $a0,  KEY_a,  casea
		beq  $a0,  KEY_b,  caseb
		beq  $a0,  KEY_c,  casec
		beq  $a0,  KEY_d,  cased
		beq  $a0,  KEY_e,  casee
		beq  $a0,  KEY_f,  casef
	
case0:		li   $s0,  '0'				
		j    StoreCode
case1:		li   $s0,  '1'
		j    StoreCode
case2:		li   $s0,  '2'
		j    StoreCode
case3:		li   $s0,  '3'
		j    StoreCode
case4:		li   $s0,  '4'
		j    StoreCode
case5:		li   $s0,  '5'
		j    StoreCode
case6:		li   $s0,  '6'
		j    StoreCode
case7:		li   $s0,  '7'
		j    StoreCode
case8:		li   $s0,  '8'
		j    StoreCode
case9:		li   $s0,  '9'
		j    StoreCode
casea:		li   $s0,  'a'
		j    StoreCode
caseb:		li   $s0,  'b'
		j    StoreCode
casec:		li   $s0,  'c'
		j    StoreCode
cased:		li   $s0,  'd'
		j    StoreCode
casee:		li   $s0,  'e'
		j    StoreCode
casef:		li   $s0,  'f'
		j    StoreCode
StoreCode:								# Luu ki tu vua duoc chon tu Digi Lab Sim vao inputControlCode 
		la   $s1,  inputControlCode
		la   $s2,  lengthControlCode
		lw   $s3,  0($s2)					# $s3 la do dai cua inputControlCode
	
		add  $s1,  $s1,  $s3					# inputControlCode[i] = $s0
		sb   $s0,  0($s1)					
		
		addi $s1,  $s1,  1					# Them '\n' vao cuoi inputControlCode
		addi $s0,  $zero,  '\n'				
		sb   $s0,  0($s1)					
		
		addi $s3,  $s3,  1					# Cap nhat lengthControlCode += 1
		sw   $s3,  0($s2)					
#--------------------------------------------------------------------------------------------------
# Evaluate the return address of main routine
# epc <= epc + 4
#--------------------------------------------------------------------------------------------------
next_pc:
		mfc0 $at,  $14 						# $at <= Coproc0.$14 = Coproc0.epc
		addi $at,  $at,  4 					# $at = $at + 4 (next instruction)
		mtc0 $at,  $14 						# Coproc0.$14 = Coproc0.epc <= $at
# RESTORE the REG FILE from STACK ----------------------------------------------------------------
Restore:
		lw   $s3,  40($sp)
		lw   $s2,  36($sp)
		lw   $s1,  32($sp)
		lw   $s0,  28($sp)
		lw   $at,  24($sp)
		lw   $a0,  20($sp)
		lw   $t4,  16($sp)
		lw   $t3,  12($sp)
		lw   $t2,  8($sp)
		lw   $t1,  4($sp)
		lw   $ra,  0($sp)
		addi $sp,  $sp,  44
return: 	eret 							# Return from exception
#=======================================================================================================
