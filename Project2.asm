# The main 16-inch guns on the USS Missouri (BB-63) shoot a 2700-pound projectile at
# an initial velocity of 2500 feet per second and have a maximum range of 24 miles.
# Given the information above and your knowledge from physics write a program in MARS
# MIPS that takes a user’s input for range (R) in yards and print out the Time-of-Flight
# (tf light) in seconds, Maximum Height reached (hM AX ) in feet, and the Angle Trajectory (θ0)
# in degrees.
.data
gravity : .float 9.81 # in m/s^2
velocity : .float 762 # in m/s
getRange : .asciiz "Enter a Range (in yards): "
notSlay : .asciiz "BOO NOT POSSIBLE\n"
Time : .asciiz "\nTime of Flight in seconds: "
Height : .asciiz "\nMaximum Height in feet: "
Angle : .asciiz "\nAngle of Trajectory in degrees: "
increment : .float 0.00001 # can be changed and decides the precision point
two : .float 2
maxRange : .float 42240
YtoM : .float 0.9144
min_diff : .float 4294967294
maxAngle : .float 45
sineMax : .float 40500
one8ty : .float 180 
toFeet : .float 3.28084
zero : .float 0.0

.text
	la, $a0, getRange # get input
	li $v0, 4 # print string
	syscall
	
	li $v0, 6 # Read float input
	syscall
	mov.s $f20, $f0 # move to another location

# $f4 = min_diff, $f5 = Time, $f6 = Height, $f7 = temp, $f8 = Sine(Angle), $f9 = maxAngle
# $f10 = counter, $f11 = diff 
# $f16 = theta*(180-theta), $f17 = theta, $f18 = temp4SineFunction, $f20 = Range, 
# $f21 = increment, $f22 = gravity, $f23 = velocity, $f24 = maxRange, $f25 = YtoM, 
# $f26 = 180, $f27 = 40500, $f28 = meters to feet, $f30 = angle
	lwc1 $f0, zero
	lwc1 $f2, two
	lwc1 $f4, min_diff
	lwc1 $f9, maxAngle
	lwc1 $f21, increment
	lwc1 $f22, gravity
	lwc1 $f23, velocity
	lwc1 $f24, maxRange
	lwc1 $f25, YtoM
	lwc1 $f26, one8ty
	lwc1 $f27, sineMax
	lwc1 $f28, toFeet

# 6 to read, 2 to print
# Checks if range is > 42240 or < 0
c.lt.s $f20, $f0
bc1t exit
c.lt.s $f24 $f20
bc1t exit

mul.s $f20, $f20, $f25 # Range to meters

loop:
	c.lt.s $f10, $f9
	bc1f continue
	add.s $f10, $f10, $f21
	
	mul.s $f7, $f23, $f23 # velcity squared
	mul.s $f17, $f10, $f2
	jal sine
	mul.s $f7, $f7, $f8
	div.s $f7, $f7, $f22  # divide by gravity
	
	sub.s $f11, $f7, $f20
	abs.s $f11, $f11
	
	c.lt.s $f11, $f4
	bc1f continue
	
	mov.s $f4, $f11
	mov.s $f30, $f10
	
	j loop
	
	
sine: # $f17 is theta, save result in $f8 = angle/degrees
	sub.s $f16, $f26, $f17
	mul.s $f16, $f17, $f16
	
	mul.s $f8, $f16, $f2
	mul.s $f8, $f8, $f2
	
	sub.s $f18, $f27, $f16
	div.s $f8, $f8, $f18

	jr $ra
	
continue:
	mov.s $f17, $f30
	jal sine
	# Time Calculation
	mul.s $f5, $f2, $f23
	mul.s $f5, $f5, $f8
	div.s $f5, $f5, $f22

	la, $a0, Time
	li $v0, 4
	syscall

	mov.s $f12, $f5
	li $v0, 2
	syscall

	# Height Calculation
	mul.s $f6, $f23, $f23
	mul.s $f6, $f6, $f8
	mul.s $f6, $f6, $f8
	div.s $f6, $f6, $f2
	div.s $f6, $f6, $f22
	mul.s $f6, $f6, $f28 # meters to feet

	la $a0, Height
	li $v0, 4
	syscall

	mov.s $f12, $f6
	li $v0, 2
	syscall

	# Print Angle
	la, $a0, Angle
	li $v0, 4
	syscall

	mov.s $f12, $f30
	li $v0, 2
	syscall
	
exit:
	# safe system call exit
	li $v0, 10
	syscall
