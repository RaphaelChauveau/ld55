extends TileMap


func set_movement_tiles(tiles):
	self.clear()
	for tile in tiles:
		self.set_cell(
			0, # layer
			tile, # position
			0, # cell_source_id = atlas_id
			Vector2i(2, 5) # tile_map_cell_atlas_coords
		)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
