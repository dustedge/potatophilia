extends Node2D
class_name Main
## main script

enum UPGRADES { # sorted vertically in power
	# game start
	MULTI_CLICK,
	HUMAN_PEASANT, # + 0.2 20 payoff 100s
	GOBLIN_SCRAPPER, # + 0.5  payoff 150s
	SLIME_GIRL, # + 1.0 payoff 200
	# early game
	ORK_LABOURER, # + 1.5 250
	DWARF_TUNNELER, # + +
	FOX_KIN_TRADER, # + +
	DRYAD, # +  +
	GOBLIN_URCHIN_GANG, # + +
	HARPY, # + 
	WATER_WHEEL, # +
	APPRENTICE_WIZARD, # +
	# mid game
	ELF_CULTIVATOR,
	LAMIA_OVERSEER,
	POTATO_MONASTERY,
	MUSHROOM_GIRL,
	HEDGE_WITCH,
	ORK_WARCHIEF,
	ARACHNE_PACKAGER,
	STEAM_TILLER,
	CLOCKWORK_HARVESTER,
	CENTAUR_HAULER,
	RUNIC_IRRIGATOR,
	# late game
	SPUD_GOLEM,
	VULPHELINE_SKY_SCOUT,
	KITSUNE_ENCHANTRESS,
	DEMON_CONTRACTOR,
	ELF_ELDER_GROVE,
	DWARF_ENGINEERS,
	ARCANE_GROW_CHAMBER,
	SUCCUBUS_BROKER,
	THE_THRESHING_AUTOMATON,
	DRAGON_GIRL,
	SOIL_TRANSMUTATION_CIRCLE,
	WEATHER_MAGE,
	# endgame
	FOX_KIN_MECHANT_SYNDICATE,
	GOBLIN_HORDE,
	LEVIATHAN_IRRIGATOR,
	VULPHELINE_AERIAL_FLEET,
	DEMON_LORD_PARTNERSHIP,
	MONSTER_COLLECTIVE,
	STAR_WEAVER,
	THE_ELF_WORLDROOT,
	ARCHMAGE_OF_THE_HARVEST,
	THE_GRAND_MECHANISM,
	INFINITE_REPLICATION_CIRCLE,
	THE_POTATO_ORRERY,
	POTATO_MOON,
}



## player vals
var potatoes: float = 0;
var total_potatoes : float = 0;
var click_add: int = 1;

var current_time := Time.get_unix_time_from_datetime_string("800-01-01")
var seconds_per_day := 86400
var real_seconds_per_day := 2.0

var autosave_timer := 0.0
const AUTOSAVE_INTERVAL := 30.0
var pps := 0.0

# current upgrades
var upgrades : Array[Upgrade] = []

@onready var potato_count_label : RichTextLabel = $UICanvasLayer/UI/PotatoCountLabel


var accumulator := 0.0

## FOCUS HANDLING
var unfocus_timestamp : float = 0.0
var is_focused := true

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			is_focused = false
			unfocus_timestamp = Time.get_unix_time_from_system()
			print("Window: Focused out. Pausing process.")
		
		NOTIFICATION_WM_WINDOW_FOCUS_IN:
			if unfocus_timestamp == 0.0:
				return
			var elapsed = Time.get_unix_time_from_system() - unfocus_timestamp
			elapsed = min(elapsed, 8 * 3600)  # cap at 8 hours
			var earned = pps * elapsed
			potatoes += earned
			total_potatoes += earned
			print("Window: Focused in. Earned: ", earned, " potatoes.")
			# popup maybe?
			unfocus_timestamp = 0.0
			is_focused = true


# upgrade cost formula: cost = base * (growth_rate ^ level)

func _process(delta: float) -> void:
	if potatoes != int(potato_count_label.text):
		potato_count_label.text = "[font_size=36][color=yellow]" + str(floori(potatoes));
		
	accumulator += delta

	if accumulator >= real_seconds_per_day:
		accumulator = 0.0
		current_time += seconds_per_day
	
	
	autosave_timer += delta
	if autosave_timer >= AUTOSAVE_INTERVAL:
		print("User Data: Autosave triggered.")
		save_progress()
		autosave_timer = 0.0
	
	
	tick_upgrades(delta)


func get_date_string():
	var dt = Time.get_datetime_dict_from_unix_time(current_time)
	return "%02d.%02d.%04d" % [
		dt.day,
		dt.month,
		dt.year
	]
		
	
func _on_potato_button_pressed() -> void:
	$PotatoSprite/ClickPlayer.stop()
	$PotatoSprite/ClickPlayer.play("click")
	$PotatoParticles.emitting = true
	$ParticleTimer.start()
	potatoes += click_add;
	total_potatoes += click_add;

func _ready() -> void:
	$ParticleTimer.start()
	load_progress()

func _on_particle_timer_timeout() -> void:
	$PotatoParticles.emitting = false

func buy_upgrade():
	pass


func _on_upgrade_menu_vbox_buy_upgrade(shopupgrade : Upgrade) -> void:
	for upgrade in upgrades:
		if upgrade.label == shopupgrade.label:
			if potatoes >= upgrade.get_price():
				potatoes -= upgrade.get_price()
				upgrade.buy()
				print("Upgrade: Level up ", upgrade.label, " to ", upgrade.level)
				update_owned()
				_upgrade_effect(upgrade)
				return
			else:
				update_owned()
				print("Upgrade: Level up: Not enough potatoes ")
				return
	
	if shopupgrade.base_cost <= potatoes:
		potatoes -= shopupgrade.base_cost
		var copy = shopupgrade.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
		copy.level = 1;
		upgrades.append(copy)
		display_upgrade(copy)
		print("Upgrade: Bought new upgrade: ", shopupgrade.label)
		update_owned()
		return
		
	print("Upgrade: Not enough potatoes")

func update_owned():
	var str = ""
	pps = 0.0
	for upg in upgrades:
		str += upg.label + " lv. " + str(upg.level) + "\n";
		pps += upg.pps
	
	$UICanvasLayer/UI/PPSLabel.text = "[font_size=16][color=yellow]PPS: " + str(snapped(pps, 0.01))
	$UICanvasLayer/UI/OwnedUpgradesLabel.text = str;


var cool_time_left := 0.0
var tps := 20

func tick_upgrades(delta):
	if not is_focused:
		return
		
	if cool_time_left >= 0.0:
		cool_time_left -= delta
		return
	
	for upgrade in upgrades:
		potatoes += upgrade.pps/tps;
		total_potatoes += upgrade.pps/tps;
		
	
	
	cool_time_left = 1.0/tps; ## tick every second


func display_upgrade(upgrade : Upgrade):
	for child : Node2D in %UpgradeRoot.get_children():
		if child.name == upgrade.label and !child.visible:
			child.show()
			_spawn_effect(child.global_position)

func _spawn_effect(globalpos):
	%SpawnEffect.global_position = globalpos
	%SpawnEffect.emitting = true
	pass


func _on_growth_timer_timeout() -> void:
	%PotatoMap._change_random_tile()
	$GrowthTimer.wait_time = randf_range(1, 3)

func _upgrade_effect(upg: Upgrade):
	var str = upg.label
	var eff : GPUParticles2D = %UpgradeEffect
	
	for child : Node2D in %UpgradeRoot.get_children():
		if child.name == str:
			eff.global_position = child.global_position
			eff.global_position.y -= 20
			eff.restart()
			eff.emitting = true
			return
			
	
func save_progress() -> void:
	var data = {
		"potatoes" : potatoes,
		"total_potatoes" : total_potatoes,
		"upgrades" : {},
		"current_time": current_time,
	}
	
	for upg in upgrades:
		data["upgrades"][upg.label] = upg.level
	
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	print("User Data: Saved progress.")

func load_progress() -> void:
	if not FileAccess.file_exists("user://save.json"):
		print("User Data: Save file not found.")
		return
	var file = FileAccess.open("user://save.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if not data:
		print("User Data: ERROR: File corrupted.")
		return

	potatoes = data.get("potatoes", 0.0)
	total_potatoes = data.get("total_potatoes", 0.0)
	current_time = data.get("current_time", Time.get_unix_time_from_datetime_string("800-01-01"))
	
	for label in data.get("upgrades", {}):
		var source = UpgradeManager.all_upgrades.get(label) as Upgrade
		if not source:
			print("User Data: WARN: Upgrade: ", label, " not found in source.")
			continue
		var copy = source.duplicate(true)
		copy.level = data["upgrades"][label]
		upgrades.append(copy)
		display_upgrade(copy)
	update_owned()
	

func _on_save_button_pressed() -> void:
	save_progress()


func _on_reset_button_pressed() -> void:
	var default := "RESET PROGRESS"
	var sure := "Press again to erase saved data"
	var btn : Button = $ResetButton
	
	if btn.text == default:
		btn.text = sure
		var timer := Timer.new()
		self.add_child(timer)
		timer.start(5.0)
		timer.one_shot = true
		timer.timeout.connect(func(): 
			btn.text = default
			timer.queue_free()
			)
		return
	# erase save data
	if btn.text == sure:
		reset_progress()
		btn.text = default
		
func reset_progress():
	potatoes = 0.0
	total_potatoes = 0.0
	current_time = Time.get_unix_time_from_datetime_string("800-01-01")
	upgrades.clear()
	update_owned()
	save_progress()  # overwrite with fresh data
	get_tree().reload_current_scene()
	
	
	
