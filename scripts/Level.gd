@tool
extends Node2D

@export_file var map_data: String

func load_json(file_path: String):
	#var file = "res://file.json"
	var json_as_text = FileAccess.get_file_as_string(file_path)
	return JSON.parse_string(json_as_text)

var game
var cells
var selected_character
var characters = []

var turn = 0
var turn_character

var player_action = 0 # 0 Mvt 1, 2, 3 => Spells ?
var action_tiles = []

# TODO only update variables in function and do a sync for the
# visual elements

func set_selected_character(character_data):
	if character_data:
		selected_character = character_data
		$SelectionCursor.visible = true
		$SelectionCursor.position = character_data.instance.position + Vector2(0, -8)
		$CanvasLayer/Interface.set_character(character_data)
	else:
		$SelectionCursor.visible = false
		$CanvasLayer/Interface.clear_character()
		selected_character = null

func create_2d_array(width, height, default_value):
	var grid = []
	for l in range(height):
		grid.append([])
		for c in range(width):
			grid[l].append(default_value)
	return grid

func populate_grid_with_weights(grid, x, y, v):
	if x < 0 or y < 0 or x >= len(grid[0]) or y >= len(grid):
		return
	if grid[y][x] <= v:
		return
	if cells[y][x] == 1:
		return
	if v != 0: # do not collide on yourself
		for c in characters: # collide with characters
			if c.cell.x == x and c.cell.y == y:
				return
	grid[y][x] = v
	populate_grid_with_weights(grid, x, y + 1, v + 1)
	populate_grid_with_weights(grid, x + 1, y, v + 1)
	populate_grid_with_weights(grid, x, y - 1, v + 1)
	populate_grid_with_weights(grid, x - 1, y, v + 1)
	

func get_character_mvt_area(character_data, mi, ma):
	var grid = self.create_2d_array(len(cells[0]), len(cells), INF)
	populate_grid_with_weights(grid, character_data.cell.x, character_data.cell.y, 0)
	for row in grid:
		print(row)
	var tiles = []
	for l in range(len(grid)):
		for c in range(len(grid[0])):
			if grid[l][c] <= ma and grid[l][c] >= mi:
				tiles.append(Vector2i(c, l))
	return tiles
	
	

func set_player_action(action):
	# 0 Mvt 1, 2, 3 => Spells ?
	player_action = action
	if turn_character.is_player:
		if action == 0: # MVT
			var tiles = self.get_character_mvt_area(turn_character, 1, 3)
			print(tiles)
			action_tiles = tiles
			$HudTiles.set_movement_tiles(tiles)

func on_tile_clicked(tile_position: Vector2i):
	print("Tile clicked", tile_position) # prints lag a little bit :thinking face:
		
	if turn_character.is_player and turn_character == selected_character:
		print("char turn & selected")
		if tile_position in action_tiles:
			# TODO
			print("action executed")
			if player_action == 0:
				print("action 0")
				turn_character.cell = tile_position 
				turn_character.instance.position = tile_position * 16 + Vector2i(8, 16)
				set_selected_character(turn_character)
				set_player_action(0)
				return
	
	set_selected_character(null)
	for c in characters:
		if c.cell == tile_position:
			set_selected_character(c)
		else:
			c.instance.is_selected = false


func init_character_turn():
	if self.turn_character.is_player:
		$CanvasLayer/DebugLabel.text = "Player turn"
		set_selected_character(self.turn_character)
		set_player_action(0)
	else:
		$CanvasLayer/DebugLabel.text = "Character " + str(self.turn_character.id) + " turn"

func init_level():
	var level_data = load_json(map_data)
	cells = level_data.cells
	
	# INIT MAP
	$CollisionTileMap.load_cells(level_data.cells)
	
	# INIT camera
	$Camera2D.position = Vector2(len(level_data.cells[0]), len(level_data.cells)) * 16 / 2
	
	# INIT controls
	var height = len(level_data.cells)
	var width = len(level_data.cells[0])
	for l in range(height):
		for c in range(width):
			var button = Button.new()
			button.position = Vector2(c * 16, l * 16)
			button.size = Vector2(16 , 16)
			button.flat = true
			button.focus_mode = Control.FOCUS_NONE
			var on_button_clicked = func ():
				self.on_tile_clicked(Vector2i(c, l))
			button.pressed.connect(on_button_clicked)
			# TODO mouse_entered ?
			$"Grid Inputs".add_child(button)
	
	
	
	# INIT CHARACTERS
	var character_scene = load("scenes/Character.tscn")
	for c in level_data.characters:
		c.cell = Vector2i(c.cell[0], c.cell[1])
		characters.append(c)
		var character_instance = character_scene.instantiate()
		c.instance = character_instance
		character_instance.initialize(
			self,
			c,
			# c.max_health,
			# c.damage,
		)
		character_instance.position = c.cell * 16 + Vector2i(8, 16)
		$CharacterContainer.add_child(character_instance)
		pass
	
	# INIT TURNS LOGIC
	self.turn = 0
	self.turn_character = characters[0]
	init_character_turn()

func initialize(game):
	self.game = game
	init_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		pass
		# init_level()

