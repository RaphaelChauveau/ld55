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
var in_transition = false
var turn_follow_path
var attack_since

var player_action = 0 # 0 Mvt 1, 2, 3 => Spells ?
var action_tiles = []
var action_distances = []

func synchronize_visuals():
	
	if in_transition:
		pass
	else:
		pass
		
	# CURSOR
	if selected_character and not in_transition:
		$SelectionCursor.visible = true
		$SelectionCursor.position = selected_character.instance.position + Vector2(0, -8)
	else:
		$SelectionCursor.visible = false
	
	# INTERFACE
	if selected_character:
		$CanvasLayer/Interface.set_character(selected_character)
	else:
		$CanvasLayer/Interface.clear_character()
	if turn_character.is_player and not in_transition:
		$CanvasLayer/Interface/EndTurnButton.visible = true
	else:
		$CanvasLayer/Interface/EndTurnButton.visible = false

	# HUD TILES
	$HudTiles.clear()
	if (turn_character == selected_character 
		and turn_character != null 
		and turn_character.is_player
		and not in_transition):
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

func hurt_character(character, damage):
	character.health -= damage
	if character.health <= 0:
		character.health = 0
		# TODO KILL
	# TODO show damage amount
	pass

func attack(character, tile: Vector2i):
	print("attack")
	self.in_transition = true
	self.attack_since = 0.01
	for other_character in self.characters:
		#if character == other_character:
		#	continue
		if other_character.cell == tile:
			self.hurt_character(other_character, character.damage)
	
	# Show Attack animation
	var attack_instance = load("scenes/AttackAnimation.tscn").instantiate()
	attack_instance.position = tile * 16 + Vector2i(8, 8)
	$EffectsContainer.add_child(attack_instance)
	# TODO cleanup
	
	self.synchronize_visuals()

func end_attack():
	print("end attack")
	self.attack_since = null
	self.in_transition = false
	self.handle_end_turn()
	self.synchronize_visuals()

func move_character(character, tile, path): #action_tile_index: int):
	var distance = len(path) - 1
	in_transition = true
	character.cell = tile
	turn_follow_path = path
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
					var movement_grid = self.get_character_movement_grid(turn_character)
					var path = get_movement_path(movement_grid, turn_character.cell, action_tile)
					move_character(turn_character, action_tile, path)
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

func get_character_movement_grid(character):
	var movement_grid = self.create_2d_array(len(self.cells[0]), len(self.cells), INF)
	populate_grid_with_weights(movement_grid, character.cell.x, character.cell.y, 0, true)
	return movement_grid

func get_movement_path(movement_grid, from: Vector2i, to: Vector2i):
	var grid_width = len(movement_grid[0])
	var grid_height = len(movement_grid)
	var path = [to]
	while path[-1] != from:
		var current_cell = path[-1]
		var current_dist = movement_grid[current_cell.y][current_cell.x]
		for offset in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
			var target_cell = current_cell + offset
			if (target_cell.x < 0 or target_cell.y < 0 
				or target_cell.x >= grid_width or target_cell.y >= grid_height):
				continue

			if movement_grid[target_cell.y][target_cell.x] == current_dist - 1:
				path.append(target_cell)
				break
	path.reverse()
	return path

func get_ia_actions(character):
	var enemies = []
	for other_character in characters:
		if other_character.is_allied != character.is_allied:
			enemies.append(other_character)
	
	# where can I go to have enemies in range ?
	var range_grid = self.create_2d_array(len(cells[0]), len(cells), INF)
	for enemy in enemies:
		populate_grid_with_weights(range_grid, enemy.cell.x, enemy.cell.y, 0, false)
	
	# where can I go ?
	var movement_grid = get_character_movement_grid(character)
	
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

	var path = get_movement_path(movement_grid, character.cell, best_tile)	
	move_character(self.turn_character, best_tile, path)

func get_ia_attack(character):
	# TODO
	# chose target (enemy), better be player ?
	# maybe attack
	if true: # lol
		attack(character, Vector2i(0, 0))

func end_character_movement():
	self.in_transition = false
	self.turn_follow_path = null
	
	self.synchronize_visuals()

	if not turn_character.is_player:
		# TODO IA stuff
		self.get_ia_attack(turn_character)

func init_character_turn():
	if self.turn_character.is_player:
		self.update_turn_character_temporary_data(self.turn_character)
		set_selected_character(self.turn_character)
		set_player_action(0)
	else:
		self.get_ia_actions(self.turn_character)
		self.synchronize_visuals()
		# self.handle_end_turn()

func update_turn_character_temporary_data(character_data):
	# TODO shoud be done at end of turn ?
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
	if self.in_transition:
		if self.turn_follow_path:
			var next_cell = self.turn_follow_path[0]
			var next_position = Vector2(next_cell) * 16 + Vector2(8, 16)
			
			var turn_distance = delta * 50
			var to_next_position = next_position - self.turn_character.instance.position
			if self.turn_character.instance.position.distance_to(next_position) < turn_distance:
				self.turn_character.instance.position = next_position
				self.turn_follow_path.remove_at(0)
				if self.turn_follow_path.is_empty():
					self.end_character_movement()
			else:
				var to_target_normalized = self.turn_character.instance.position.direction_to(next_position).normalized()				
				self.turn_character.instance.position += to_target_normalized * turn_distance
		
		elif self.attack_since:
			print("since", self.attack_since)
			self.attack_since += delta
			if self.attack_since > 1:
				self.end_attack()
			pass
			
