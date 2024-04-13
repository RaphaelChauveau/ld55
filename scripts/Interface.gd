extends Node2D

var character_data

func clear_character():
	self.character_data = null
	$PortraitFrame/Sprite2D.texture = null
	$StatIcons/MovementLabel.text = ""
	$StatIcons/HealthLabel.text = ""
	$StatIcons/AttackLabel.text = ""

func set_character(character_data):
	self.character_data = character_data
	
	var character_texture = AtlasTexture.new()
	character_texture.atlas = load("res://assets/tilesets/tiny_characters.png")
	character_texture.region = Rect2(
		self.character_data.atlas_position[0] * 16,
		self.character_data.atlas_position[1] * 16,
		16, 16)
	$PortraitFrame/Sprite2D.texture = character_texture
	$StatIcons/MovementLabel.text = str(self.character_data.movement)
	$StatIcons/HealthLabel.text = str(self.character_data.max_health)
	$StatIcons/AttackLabel.text = str(self.character_data.damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
