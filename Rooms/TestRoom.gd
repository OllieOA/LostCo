extends Node2D


onready var debug_label = $CanvasLayer/Temp
onready var debug_label2 = $CanvasLayer/Temp2
onready var character = $CharacterLayer/Character

func _process(delta: float) -> void:
	debug_label.set_text("HORIZ_HEADING: " + str(character.horiz_heading) + " VERT_HEADING: " + str(character.vert_heading))
	debug_label2.set_text("CURR_HEADING: " + str(character.current_heading) + " NEW_HEADING: " + str(character.heading_direction))
