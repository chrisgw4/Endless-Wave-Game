extends Node2D

@export var interaction_component:InteractionComponent
var in_range:bool
var opened:bool

func _ready() -> void:
	interaction_component.connect("player_entered", _show_interact)
	interaction_component.connect("player_exited", _hide_interact)
	
	$AnimationPlayer.play("shine")
	$Timer.start(randf_range(2.5, 8))


func _on_timer_timeout():
	$Timer.start(randf_range(2.5, 8))
	$AnimationPlayer.play("shine")


func _show_interact(_player:Player) -> void:
	if not opened:
		$AnimationPlayer2.play("show_interact")
	in_range = true

func _hide_interact(_player:Player) -> void:
	if not opened:
		$AnimationPlayer2.play("RESET")
	in_range = false
	

func _input(event):
	#if event is InputEventAction:
		if Input.is_action_just_pressed("interact") and in_range and not opened:
			$AnimationPlayer.play("open")
			$AnimationPlayer2.stop()
			opened = true
			$InteractionComponent/CollisionShape2D.disabled = true
			
			$Timer.stop()
