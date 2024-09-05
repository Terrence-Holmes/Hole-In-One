class_name KeyValuePair

var key
var value

#Constructor
func _init(Key, Value):
	super._init()
	key = Key
	value = Value


func string() -> String:
	return "{ " + str(key) + " : " + str(value) + " }"
