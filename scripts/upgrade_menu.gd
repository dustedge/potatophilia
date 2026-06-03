extends VBoxContainer
class_name UpgradeMenu

@onready var il : ItemList = $AvailableItemList
@export var main : Main;

signal buy_upgrade

func _on_available_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	buy_upgrade.emit(il.get_item_metadata(index))
	il.deselect_all()
	update_il()

func _ready() -> void:
	update_il();
	var timer := Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = false
	self.add_child(timer)
	timer.start()
	timer.timeout.connect(update_il)
	
func update_il():
	if not main: return
	
	il.clear()
	
	# collect
	var visible : Array = []
	for key in UpgradeManager.all_upgrades.keys():
		var pps := 0.0
		var upgrade = UpgradeManager.all_upgrades[key] as Upgrade
		if upgrade.unlock_threshold > main.total_potatoes:
			continue
		
		var price = upgrade.base_cost
		for upg in main.upgrades:
			if upg.label == upgrade.label:
				price = upg.get_price()
				pps = upg.base_pps
				break
		
		visible.append({ "upgrade": upgrade, "price": price, "pps" : pps})
	
	# sort
	visible.sort_custom(func(a, b): return a.pps < b.pps)
	
	# populate
	for entry in visible:
		var upgrade = entry.upgrade as Upgrade
		var price = entry.price
		il.add_item(upgrade.label + " : " + str(price) + " (PPS : " + str(snapped(upgrade.pps, 0.01)) + ")")
		var desc = upgrade.description.replace(". ", ". \n")
		desc[0] = desc[0].to_upper()
		il.set_item_tooltip(il.item_count - 1, desc)
		il.set_item_metadata(il.item_count - 1, upgrade)


func _on_shop_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$animply.stop()
		$animply.play("show")
	else:
		$animply.stop()
		$animply.play("hide")


func _on_mouse_exited() -> void:
	return
	# fucked up shit does not work
	if $animply.current_animation == "":
		$animply.stop()
		$animply.play("hide")
		shop_visible = false

var shop_visible := false
func _toggle_shop() -> void:
	if shop_visible:
		$animply.stop()
		$animply.play("hide")
		shop_visible = false
	else:
		$animply.stop()
		$animply.play("show")
		shop_visible = true
		
	pass


func _on_shop_button_pressed() -> void:
	_toggle_shop()
