extends Node
class_name Data

const stats_by_character = {
	"player": {
		"name": "Druid",
		"max_health": 1,
		"damage": 1,
		"max_movement": 3,
		"range": 1,
		"atlas_position": [5, 7],
		"is_player": true,
		"is_allied": true,
	},
	# INVO
	"lizard": {
		"name": "Lizard",
		"max_health": 2,
		"damage": 1,
		"max_movement": 3,
		"range": 1,
		"atlas_position": [6, 20],
		"is_player": false,
		"is_allied": true,
	},
	"bear": {
		"name": "Bear",
		"max_health": 5,
		"damage": 3,
		"max_movement": 3,
		"range": 1,
		"atlas_position": [3, 22],
		"is_player": false,
		"is_allied": true,
	},
	"eagle": {
		"name": "Eagle",
		"max_health": 3,
		"damage": 2,
		"max_movement": 5,
		"range": 1,
		"atlas_position": [4, 19],
		"is_player": false,
		"is_allied": true,
	},
	"shark": {
		"name": "Shark",
		"max_health": 1,
		"damage": 10,
		"max_movement": 0,
		"range": 1,
		"atlas_position": [2, 23],
		"is_player": false,
		"is_allied": true,
	},
	# ENNEMIES
	"farmer": {
		"name": "Farmer",
		"max_health": 2,
		"damage": 1,
		"max_movement": 3,
		"range": 1,
		"atlas_position": [1, 0],
		"is_player": false,
		"is_allied": false,
	},
}

func merge_dicts(d1, d2):
	var ret = {}
	ret.merge(d1)
	ret.merge(d2)
	return ret

var characters_by_level = {
	1: [
		merge_dicts(stats_by_character["player"], {
			"cell": Vector2i(0, 0),
		}),
		merge_dicts(stats_by_character["farmer"], {
			"cell": Vector2i(1, 1),
		}),
		#merge_dicts(stats_by_character["lizard"], {
			#"cell": Vector2i(1, 0),
		#}),
		#merge_dicts(stats_by_character["bear"], {
			#"cell": Vector2i(2, 0),
		#}),
		#merge_dicts(stats_by_character["eagle"], {
			#"cell": Vector2i(3, 0),
		#}),
		#merge_dicts(stats_by_character["shark"], {
			#"cell": Vector2i(4, 0),
		#}),
	]
}

var grid_by_level = {
	1: [
		[0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 1, 1],
		[0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0],
	]
}

var levels = {
	1: {
		"cells": grid_by_level[1],
		"characters": characters_by_level[1]
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
