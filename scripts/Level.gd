@tool
extends Node2D

@export_file var map_data: String

func load_json(file_path: String):
	#var file = "res://file.json"
	var json_as_text = FileAccess.get_file_as_string(file_path)
	return JSON.parse_string(json_as_text)

var game
var selected_character
var characters = []

func on_tile_clicked(tile_position: Vector2i):
	selected_character = null
	for c in characters:
		if c.cell == tile_position:
			selected_character = c
			c.instance.is_selected = true
		else:
			c.instance.is_selected = false
	print("Tile clicked", tile_position) # prints lag a little bit :thinking face:

func init_level():
	var level_data = load_json(map_data)
	
	# INIT MAP
	$CollisionTileMap.load_cells(level_data.cells)
	
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
			# TODO mouse_entered
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
			c.is_allied,
			c.is_player,
			# c.max_health,
			# c.damage,
		)
		character_instance.position = c.cell * 16 + Vector2i(8, 16)
		$CharacterContainer.add_child(character_instance)
		pass

func print_click():
	print("click :)")

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
	pass
