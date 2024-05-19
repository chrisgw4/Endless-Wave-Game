extends Area2D
class_name PickupComponent


@export var collision_shape:CollisionShape2D

signal player_entered(player)

func _on_body_entered(body):
	emit_signal("player_entered", body)
	
