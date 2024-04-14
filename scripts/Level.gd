@tool
extends Node2D

@export_file var map_data: String

func load_json(file_path: String):
	#var file = "res://file.json"
	var json_as_text = FileAccess.get_file_as_string(file_path)
	return JSON.parse_string(json_as_text)

var game
var cells

var selected_character # dict or null
var characters = []

var turn = 0
var turn_character_index = 0
var turn_character

# var turn_character_moving_to = null

var player_action = 0 # 0 Mvt 1, 2, 3 => Spells ?
var action_tiles = []
var action_distances = []

func synchronize_visuals():
	# CURSOR
	if selected_character:
		$SelectionCursor.visible = true
		$SelectionCursor.position = selected_character.instance.position + Vector2(0, -8)
	else:
		$SelectionCursor.visible = false
	
	# INTERFACE
	if selected_character:
		$CanvasLayer/Interface.set_character(selected_character)
	else:
		$CanvasLayer/Interface.clear_character()
	if turn_character.is_player:
		$CanvasLayer/Interface/EndTurnButton.visible = true
	else:
		$CanvasLayer/Interface/EndTurnButton.visible = false

	# HUD TILES
	$HudTiles.clear()
	if (turn_character == selected_character 
		and turn_character != null 
		and turn_character.is_player):
		if player_action == 0:
			$HudTiles.set_movement_tiles(action_tiles)
	
	# DEBUG LABEL
	if turn_character and turn_character.is_player:
		$CanvasLayer/DebugLabel.text = "Player turn"
	else:
		$CanvasLayer/DebugLabel.text = "Character " + str(self.turn_character.id) + " turn"
	
		

func set_selected_character(character_data):
	if character_data:
		selected_character = character_data
	else:
		selected_character = null
	self.synchronize_visuals()

func create_2d_array(width, height, default_value):
	var grid = []
	for l in range(height):
		grid.append([])
		for c in range(width):
			grid[l].append(default_value)
	return grid

func populate_grid_with_weights(grid, x, y, v, handle_player_colisions):
	if x < 0 or y < 0 or x >= len(grid[0]) or y >= len(grid):
		return
	if grid[y][x] <= v:
		return
	if cells[y][x] == 1:
		return
	if handle_player_colisions and v != 0: # do not collide on yourself
		for c in characters: # collide with characters
			if c.cell.x == x and c.cell.y == y:
				return
	grid[y][x] = v
	populate_grid_with_weights(grid, x, y + 1, v + 1, handle_player_colisions)
	populate_grid_with_weights(grid, x + 1, y, v + 1, handle_player_colisions)
	populate_grid_with_weights(grid, x, y - 1, v + 1, handle_player_colisions)
	populate_grid_with_weights(grid, x - 1, y, v + 1, handle_player_colisions)
	

func get_character_mvt_area(character_data, mi, ma):
	"""Returns a pair tile_positions / distances"""
	var grid = self.create_2d_array(len(cells[0]), len(cells), INF)
	populate_grid_with_weights(grid, character_data.cell.x, character_data.cell.y, 0, true)
	for row in grid:
		print(row)
	var tiles = []
	var distances = []
	for l in range(len(grid)):
		for c in range(len(grid[0])):
			if grid[l][c] <= ma and grid[l][c] >= mi:
				tiles.append(Vector2i(c, l))
				distances.append(grid[l][c])
	return [tiles, distances]
	
	

func set_player_action(action):
	# 0 Mvt 1, 2, 3 => Spells ?
	player_action = action
	if turn_character.is_player:
		if action == 0: # MVT
			var area_data = self.get_character_mvt_area(turn_character, 1, turn_character.movement)
			action_tiles = area_data[0]
			action_distances = area_data[1]
			self.synchronize_visuals()

func move_character(character, tile, distance): #action_tile_index: int):
	# var tile = action_tiles[action_tile_index]
	# var distance = action_distances[action_tile_index]
	character.cell = tile 
	character.instance.position = tile * 16 + Vector2i(8, 16)
	character.movement -= distance
	
	if character.is_player:
		set_selected_character(turn_character)
		set_player_action(0)
	else:
		synchronize_visuals()
	

func on_tile_clicked(tile_position: Vector2i):
	print("Tile clicked", tile_position) # prints lag a little bit :thinking face:
	# Might be a player action
	if turn_character.is_player and turn_character == selected_character:
		for i in range(len(action_tiles)):
			var action_tile = action_tiles[i]
			if tile_position == action_tile:
				if player_action == 0:
					var tile = self.action_tiles[i]
					var distance = self.action_distances[i]
					move_character(turn_character, tile, distance)
				return
	
	set_selected_character(null)
	for c in characters:
		if c.cell == tile_position:
			set_selected_character(c)
		else:
			c.instance.is_selected = false

func handle_end_turn():
	var old_character = turn_character
	turn_character_index = turn_character_index + 1
	if turn_character_index >= len(characters): # Next turn !
		turn += 1
		turn_character_index = 0
	turn_character = characters[turn_character_index]
	
	# end character turn
	update_turn_character_temporary_data(old_character)
	
	# start character turn
	init_character_turn()

func get_ia_actions(character):
	var enemies = []
	for other_character in characters:
		if other_character.is_allied != character.is_allied:
			enemies.append(other_character)
	
	# where can I go to have enemies in range ?
	var range_grid = self.create_2d_array(len(cells[0]), len(cells), INF)
	for enemy in enemies:
		populate_grid_with_weights(range_grid, enemy.cell.x, enemy.cell.y, 0, false)
	#for enemy in enemies:
	#	range_grid[enemy.cell.y][enemy.cell.x] = INF
	print("range_grid")
	for row in range_grid:
		print(row)
	
	# where can I go ?
	var movement_grid = self.create_2d_array(len(cells[0]), len(cells), INF)
	populate_grid_with_weights(movement_grid, character.cell.x, character.cell.y, 0, true)
	# range_grid[character.cell.y][character.cell.x] = 0
	print("movement_grid")
	for row in movement_grid:
		print(row)
	
	# find best spot, with least effort
	var best_tile = null
	var best_range = INF # minimize 1st
	var best_distance = INF # minimize 2nd
	for l in range(len(movement_grid)):
		for c in range(len(movement_grid[0])):
			if movement_grid[l][c] <= character.movement:
				
				if range_grid[l][c] < best_range:
					best_range = range_grid[l][c]
					best_distance = movement_grid[l][c]
					best_tile = Vector2i(c, l)
				
				if (range_grid[l][c] == best_range
					and movement_grid[l][c] < best_distance):
					best_distance = movement_grid[l][c]
					best_tile = Vector2i(c, l)
	
	move_character(character, best_tile, best_distance)

func init_character_turn():
	if self.turn_character.is_player:
		self.update_turn_character_temporary_data(self.turn_character)
		set_selected_character(self.turn_character)
		set_player_action(0)
	else:
		self.get_ia_actions(self.turn_character)
		self.synchronize_visuals()
		self.handle_end_turn()

func update_turn_character_temporary_data(character_data):
	# TODO shoud be done at end of turn
	character_data.movement = character_data.max_movement

func populate_character_temporary_data(character_data):
	character_data.movement = character_data.max_movement
	character_data.health = character_data.max_health

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
		self.populate_character_temporary_data(c)
		character_instance.initialize(
			self,
			c,
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
	$CanvasLayer/Interface.initialize(self)
	init_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		pass
		# init_level()

