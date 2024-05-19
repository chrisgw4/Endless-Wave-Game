extends CanvasLayer


var game_scene:PackedScene = preload("res://scenes/game.tscn")

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(game_scene)


