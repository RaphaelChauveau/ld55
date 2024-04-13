@tool
extends TileMap

func load_cells(cells):
	self.clear()
	
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
			if (l + c) % 2 == 0:
				self.set_cell(
					0, # layer
					Vector2i(c, l), # position
					1, # cell_source_id = atlas_id
					Vector2i(0, 1) # tile_map_cell_atlas_coords
				)
			else:
				self.set_cell(
					0, # layer
					Vector2i(c, l), # position
					1, # cell_source_id = atlas_id
					Vector2i(7, 1) # tile_map_cell_atlas_coords
				)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
