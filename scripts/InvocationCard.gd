extends Node2D

var level
var character
var selected = false

func un_select():
	self.selected = false
	$UnselectedCard.visible = true
	$SelectedCard.visible = false

func select():
	var interface = self.get_parent().get_parent()
	interface.unselect_cards()
	self.selected = true
	$UnselectedCard.visible = false
	$SelectedCard.visible = true

func handle_click():
	if selected:
		self.un_select()
		self.level.set_selected_character_card(null)
	else:
		self.select()
		self.level.set_selected_character_card(character)

func initialize(level, character):
	self.level = level
	self.character = character
	
	$UnselectedCard.visible = true
	$SelectedCard.visible = false
	$NameLabel.text = self.character.name
	$MovementLabel.text = str(self.character.max_movement)
	$AttackLabel.text = str(self.character.damage)
	$HealthLabel.text = str(self.character.max_health)
	var character_texture = AtlasTexture.new()
	character_texture.atlas = load("res://assets/tilesets/tiny_characters.png")
	character_texture.region = Rect2(
		self.character.atlas_position[0] * 16,
		self.character.atlas_position[1] * 16,
		16, 16)
	$Portrait.texture = character_texture
	
	$Button.pressed.connect(self.handle_click)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
