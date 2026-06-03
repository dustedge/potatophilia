extends Node

var all_upgrades : Dictionary = {} # string upgradelabel : upgrade
const STATIC_LIST_SC = preload("res://scenes/staticupgrades.tscn")
var STATIC_LIST : StaticUpgrades

func _ready() -> void:
	#load upgrades
	#load_upgrades(); # does not work in a web app
	STATIC_LIST = STATIC_LIST_SC.instantiate()
	load_upgrades_web();
	pass

func load_upgrades_web():
	for upgrade in STATIC_LIST.upgrades:
		all_upgrades[upgrade.label] = upgrade
		print("UpgradeManager: Loaded ", upgrade.label)


func load_upgrades():
	var path = "res://upgrades/" 
	
	var dir = DirAccess.open(path)
	for filename in dir.get_files():
		if filename.ends_with(".tres"):
			var p = load(path + filename) as Upgrade
			if p:
				all_upgrades[p.label] = p
				print("UpgradeManager: Loaded ", filename, " as ", p.label)
