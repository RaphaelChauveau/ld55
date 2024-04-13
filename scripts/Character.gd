@tool
extends Node2D

var level

var is_selected: bool = false

var is_allied
var is_player
var cell_position: Vector2i
var max_health
var damage

func initialize(level, is_allied, is_player):#cell_position: Vector2i):
	self.level = level
	#self.cell_position = cell_position
	
	self.is_allied = is_allied
	self.is_player = is_player
	
	if is_player:
		var character_texture = AtlasTexture.new()
		character_texture.atlas = load("res://assets/tilesets/tiny_characters.png")
		character_texture.region = Rect2(0, 0, 16, 16)
		$Sprite2D.texture = character_texture
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
