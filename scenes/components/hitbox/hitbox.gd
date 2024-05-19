extends Area2D
class_name Hitbox


static var hit_effect:PackedScene = preload("res://scenes/hit effect/hit_effect.tscn")

@export var damage_component:DamageComponent
@export var stream:AudioStream

func _ready() -> void:
	$AudioStreamPlayer2D.stream = stream

func _on_area_entered(area:Area2D):
	if not area is Hurtbox:
		return
	if area.health_component:
		area.health_component.damage(damage_component.calculate_damage())
		if "velocity_component" in area.get_parent():
			area.get_parent().velocity_component.force_accelerate_to_velocity(global_position.direction_to(area.global_position).normalized()*damage_component.knock_back_multiplier)
		
		# Spawn in a hit_effect whenever the hitbox makes contact with a hurtbox
		var hit = hit_effect.instantiate()
		hit.global_position = area.global_position
		get_tree().current_scene.call_deferred("add_child", hit)
		$AudioStreamPlayer2D.play()
