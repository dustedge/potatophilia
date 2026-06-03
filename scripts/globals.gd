extends Node


var backlog : Array[String] = []
var log_length : int = 10000

func add_log_entry(string : String):
	backlog.append(Time.get_time_string_from_system() + ": " + string)
	if backlog.size() > 10000:
		backlog.pop_front()
	print(backlog.back())
