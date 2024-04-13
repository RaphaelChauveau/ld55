extends TileMap

func load_cells(cells: Array[Array]):
	self.clear()
	
	print(cells)
	
	var height = len(cells)
	var width = len(cells[0])
	
	for l in range(height):
		for c in range(width):
			if cells[l][c]:
				self.set_cell(
					1, # layer
					Vector2i(c, l), # position
					0, # cell_source_id = atlas_id
					Vector2i(2, 5) # tile_map_cell_atlas_coords
					)
			else:
				self.set_cell(
					0, # layer
					Vector2i(c, l), # position
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
