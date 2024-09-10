extends Node
class_name Math


#Returns -1 if number is negative, 1 if positive
static func PosOrNeg(num) -> int:
	return (1) if (num >= 0) else (-1)



#Returns the given angle (in degrees) clamped between 0 and 360
static func ClampAngleDegrees(degree : float) -> float:
	if (degree >= 360):
		degree -= 360
	elif (degree < 0):
		degree += 360
	
	return degree

#Returns the given angle (in radians) clamped between 0 and 360
static func ClampAngleRadians(degree : float) -> float:
	if (degree >= TAU):
		degree -= TAU
	elif (degree < 0):
		degree += TAU
	
	return degree


#Returns true if the given position is within a certain area
#pos = The position to check
#area = The area to check in; x & y = position, z & w = width/height
static func IsInArea(pos : Vector2, area : Rect2) -> bool:
	return (pos.x > area.position.x and pos.x < area.position.x + area.size.x
	and pos.y > area.position.y and pos.y < area.position.y + area.size.y)


#Returns a random result from the given array
static func RandomChoice(arr : Array):
	return (arr[randi() % arr.size()])


#VECTORS AND MATRICES

static func GetForward(transform : Transform3D) -> Vector3:
	return -transform.basis.z
static func GetBackward(transform : Transform3D) -> Vector3:
	return transform.basis.z
static func GetLeft(transform : Transform3D) -> Vector3:
	return -transform.basis.x
static func GetRight(transform : Transform3D) -> Vector3:
	return transform.basis.x
static func GetDown(transform : Transform3D) -> Vector3:
	return -transform.basis.y
static func GetUp(transform : Transform3D) -> Vector3:
	return transform.basis.y



#TIME

#Returns true if the given number of seconds have passed since the given start time
static func Timeout(secs : float, startTime : int) -> bool:
	return (float(Time.get_ticks_msec() - startTime) / 1000) >= secs

#Returns the remaining time based on the seconds and start time
static func TimeLeft(secs : float, startTime : int) -> float:
	return (secs - (float(Time.get_ticks_msec() - startTime) / 1000))




#BINARY

# Takes in a decimal value and returns the binary value
static func Decimal2Binary(decimalValue):
	var binaryString : String = "" 
	var count : int = 31 # Check up to 32 bits 
	var temp
	
	while(count >= 0):
		temp = decimalValue >> count 
		if(temp & 1):
			binaryString = binaryString + "1"
		else:
			binaryString = binaryString + "0"
		count -= 1
	
	return int(binaryString)

# Takes in a binary value (int) and returns the decimal value (int)
static func Binary2Decimal(binaryValue):
	var decimalValue = 0
	var count : int = 0
	var temp
	
	while(binaryValue != 0):
		temp = binaryValue % 10
		binaryValue /= 10
		decimalValue += temp * pow(2, count)
		count += 1
	
	return decimalValue
