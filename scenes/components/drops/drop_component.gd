extends Node2D
class_name DropComponent

@export var stream:AudioStream
@export var dropable_items:Array[DropData]

func _ready() -> void:
	$AudioStreamPlayer2D.stream = stream

## Function is called in enemy's death animation in animationPlayer
func _calculate_drops() -> void:
	for drop_data:DropData in dropable_items:
		# Get a value from 0 - 1 to see if item should drop
		var rand_val = randf_range(0,1)
		
		# Check if the drop_chance passes
		if rand_val <= drop_data.drop_chance:
			# Instantiate the item to be dropped
			var temp = drop_data.item.instantiate()
			temp.global_position = global_position
			temp.ground_level = global_position.y
			temp.linear_velocity = Vector2(randf_range(-30, 30), randf_range(-300, -250))
			get_tree().current_scene.call_deferred("add_child", temp)
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(0.1).timeout
