class_name Delegate

var methods : Array[Callable] = []



#ACTIONS

#Appends the given callable to the delegate
func append(callable : Callable):
	if (not methods.has(callable)):
		methods.append(callable)

#Removes the FIRST instance of the given callable in the delegate
func remove(callable : Callable):
	for i in range(methods.size()):
		if (methods[i].get_object_id() == callable.get_object_id() and
			methods[i].get_method() == callable.get_method()):
			methods.remove_at(i)
			return

#Calls all methods in the delegate
func invoke(argument = null):
	for i in range(methods.size()):
		if (argument == null):
			methods[i].call()
		else:
			methods[i].call(argument)



#RETURNS

#Returns true if this delegate contains the given method
func contains(callable : Callable) -> bool:
	return methods.has(callable)
