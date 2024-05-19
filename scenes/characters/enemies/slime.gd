extends CharacterBody2D


@export var velocity_component:VelocityComponent
@export var health_component:HealthComponent
@export var path_find_component:PathfindComponent
@export var FSM:FiniteStateMachine

@export var animated_sprite:AnimatedSprite2D

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	health_component.connect("hurt_event", _enter_hurt)
	health_component.connect("died_event", FSM.set_state.bind(FSM.states.died))

func _enter_hurt() -> void:
	FSM.set_state(FSM.states.hurt)

func _exit_hurt() -> void:
	FSM.set_state(FSM.states.idle)

func _process(delta):

	velocity_component.move(self) # Move the enemy

func get_input() -> void:
	#velocity_component.move(self)
	path_find_component.follow_path()
	
	if (velocity_component.Velocity.x < 0):
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false


# Allows the enemy to move with knockback during the hurt/died animations
func hurt_movement() -> void:
	velocity_component.move(self)
	velocity_component.decelerate(.05)
