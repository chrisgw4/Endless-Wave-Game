extends RigidBody2D


@export var pick_up_component:PickupComponent
@export var animation_player:AnimationPlayer
@export var disappear_player:AnimationPlayer
@export var lifetime_timer:Timer

var ground_level:float

func _ready() -> void:
	animation_player.play("spin")
	pick_up_component.connect("player_entered", _pick_up)
	lifetime_timer.start(randf_range(lifetime_timer.wait_time, lifetime_timer.wait_time*1.5))


func _physics_process(_delta):
	if global_position.y > ground_level:
		linear_velocity = Vector2.ZERO
		gravity_scale = 0
		set_physics_process(false)
		disappear_player.play("spawn")
	elif linear_velocity == Vector2.ZERO:
		linear_velocity = Vector2.ZERO
		gravity_scale = 0
		set_physics_process(false)
		disappear_player.play("spawn")



func _pick_up(player:Player) -> void:
	if player.health_component.current_health < player.health_component.max_health:
		lifetime_timer.stop()
		player.health_component.heal(2)
		disappear_player.play("pick_up")
		$PickUp.play()
		



func _on_life_time_timeout():
	disappear_player.play("disappear")
