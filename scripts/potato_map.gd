extends TileMapLayer
class_name PotatoMap

func _change_random_tile():
	var used = get_used_cells()
	if used.is_empty(): return
	
	var randcell = used[randi() % used.size()]
	if not randcell: return
	
	var src = tile_set.get_source(0) as TileSetAtlasSource
	if not src: return
	
	if src:
		var randtileix = randi() % src.get_tiles_count()
		var randatlascoords = src.get_tile_id(randtileix)
		
		set_cell(randcell, 0, randatlascoords)
