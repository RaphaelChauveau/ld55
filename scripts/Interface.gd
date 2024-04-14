extends Node2D

var level
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
	$StatIcons/HealthLabel.text = str(self.character_data.health)
	$StatIcons/AttackLabel.text = str(self.character_data.damage)

func on_end_turn_clicked():
	self.level.handle_end_turn()

func unselect_cards():
	for card in $CharacterCardsContainer.get_children():
		card.un_select()

func drop_selected_card():
	for card in $CharacterCardsContainer.get_children():
		if card.selected:
			$CharacterCardsContainer.remove_child(card)
			card.queue_free()
			break

func initialize(level):
	self.level = level
	$EndTurnButton/Button.pressed.connect(on_end_turn_clicked)
	
	var card_scene = load("scenes/InvocationCard.tscn")
	for i in range(len(level.cards)):
		var character = level.cards[i]
		var card_instance = card_scene.instantiate()
		card_instance.initialize(level, character)
		card_instance.position = Vector2(20 + i * 40, 28)
		$CharacterCardsContainer.add_child(card_instance)
		pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var card_instances = $CharacterCardsContainer.get_children()
	for i in range(len(card_instances)):
		var card_instance = card_instances[i]
		var lerp_weight = delta * 5
		card_instance.position = card_instance.position.lerp(Vector2(20 + i * 40, 28), lerp_weight)
