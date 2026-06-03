extends Node2D
# Upgrade root


var names_male := []
var names_female := []


func _ready() -> void:
	var namefile = FileAccess.open("res://data/names.txt", FileAccess.READ)
	if not namefile: 
		print("File: Failed to open names.txt")
		return
	
	var data = namefile.get_as_text().split("\n", false)
	
	var targetarr = null
	for str in data:
		if str == "[MALE]":
			targetarr = names_male
		elif str == "[FEMALE]":
			targetarr = names_female
		else:
			if targetarr != null and targetarr is Array:
				targetarr.push_back(str)
				
	_regenerate_names()
	
	

func _regenerate_names():
	for child : Node2D in get_children():
		for node in child.get_children():
			if node is Label:
				if node.name == "LabelF":
					var str = names_female.pick_random()
					node.text = str
					if names_female.size() > 0: names_female.erase(str)
				
				elif node.name == "LabelM":
					var str = names_male.pick_random()
					node.text = str
					if names_male.size() > 0: names_male.erase(str)
