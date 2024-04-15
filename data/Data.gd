extends Node
class_name Data

const stats_by_character = {
	"player": {
		"name": "Druid",
		"max_health": 3,
		"damage": 0,
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
		"max_movement": 2,
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
	"warrior": {
		"name": "Warrior",
		"max_health": 4,
		"damage": 2,
		"max_movement": 4,
		"range": 1,
		"atlas_position": [3, 0],
		"is_player": false,
		"is_allied": false,
	},
	"knight": {
		"name": "Knight",
		"max_health": 6,
		"damage": 3,
		"max_movement": 3,
		"range": 1,
		"atlas_position": [0, 1],
		"is_player": false,
		"is_allied": false,
	},
}

var available_cards_by_level = {
	1: [
		stats_by_character["lizard"].duplicate(true),
	],
	2: [
		stats_by_character["lizard"].duplicate(true),
		stats_by_character["eagle"].duplicate(true),
	],
	3: [
		stats_by_character["lizard"].duplicate(true),
		stats_by_character["eagle"].duplicate(true),
		stats_by_character["bear"].duplicate(true),
	],
	4: [
		stats_by_character["lizard"].duplicate(true),
		stats_by_character["eagle"].duplicate(true),
		stats_by_character["bear"].duplicate(true),
	],
	5: [
		stats_by_character["lizard"].duplicate(true),
		stats_by_character["eagle"].duplicate(true),
		stats_by_character["bear"].duplicate(true),
		stats_by_character["shark"].duplicate(true),
	],
}

func merge_dicts(d1, d2):
	var ret = {}
	ret.merge(d1)
	ret.merge(d2)
	return ret

var characters_by_level = {
	1: [
		merge_dicts(stats_by_character["player"], {
			"cell": Vector2i(4, 4),
		}),
		merge_dicts(stats_by_character["farmer"], {
			"cell": Vector2i(4, 0),
		}),
	],
	2: [
		merge_dicts(stats_by_character["player"], {
			"cell": Vector2i(10, 7),
		}),
		merge_dicts(stats_by_character["farmer"], {
			"cell": Vector2i(2, 3),
		}),
		merge_dicts(stats_by_character["farmer"], {
			"cell": Vector2i(17, 3),
		}),
	],
	3: [
		merge_dicts(stats_by_character["player"], {
			"cell": Vector2i(8, 7),
		}),
		merge_dicts(stats_by_character["farmer"], {
			"cell": Vector2i(7, 1),
		}),
		merge_dicts(stats_by_character["warrior"], {
			"cell": Vector2i(2, 3),
		}),
		merge_dicts(stats_by_character["warrior"], {
			"cell": Vector2i(14, 3),
		}),
	],
	4: [
		merge_dicts(stats_by_character["player"], {
			"cell": Vector2i(8, 6),
		}),
		merge_dicts(stats_by_character["farmer"], {
			"cell": Vector2i(3, 2),
		}),
		merge_dicts(stats_by_character["warrior"], {
			"cell": Vector2i(2, 2),
		}),
		merge_dicts(stats_by_character["knight"], {
			"cell": Vector2i(13, 2),
		}),
	],
	5: [
		merge_dicts(stats_by_character["player"], {
			"cell": Vector2i(7, 6),
		}),
		merge_dicts(stats_by_character["warrior"], {
			"cell": Vector2i(10, 1),
		}),
		merge_dicts(stats_by_character["warrior"], {
			"cell": Vector2i(4, 1),
		}),
		merge_dicts(stats_by_character["knight"], {
			"cell": Vector2i(1, 4),
		}),
		merge_dicts(stats_by_character["knight"], {
			"cell": Vector2i(12, 4),
		}),
	]
}

var grid_by_level = {
	1: [
		[0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 0, 0, 0, 0, 0, 1, 1],
		[0, 0, 0, 0, 0, 0, 0, 0, 0],
	],
	2: [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	],
	3: [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	],
	4: [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	],
	5: [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	]
}

var levels = {
	1: {
		"cells": grid_by_level[1],
		"characters": characters_by_level[1],
		"available_cards": available_cards_by_level[1]
	},
	2: {
		"cells": grid_by_level[2],
		"characters": characters_by_level[2],
		"available_cards": available_cards_by_level[2]
	},
	3: {
		"cells": grid_by_level[3],
		"characters": characters_by_level[3],
		"available_cards": available_cards_by_level[3]
	},
	4: {
		"cells": grid_by_level[4],
		"characters": characters_by_level[4],
		"available_cards": available_cards_by_level[4]
	},
	5: {
		"cells": grid_by_level[5],
		"characters": characters_by_level[5],
		"available_cards": available_cards_by_level[5]
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
