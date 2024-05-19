extends CharacterBody2D

@export var animated_sprite:AnimatedSprite2D
@export var path_find_component:PathfindComponent
@export var velocity_component:VelocityComponent
@export var health_component:HealthComponent
@export var ray_cast:RayCast2D
@onready var player = get_tree().current_scene.get_node_or_null("./Player")

@export var FSM:FiniteStateMachine

var swoop_charging_up:bool = false
var recharge_time:bool = false

var ray_cast_position_target:Vector2
var ray_cast_target_direction:Vector2

func _ready() -> void:
	health_component.connect("hurt_event", _enter_hurt)
	health_component.connect("died_event", FSM.set_state.bind(FSM.states.died))
	

# Called from animation player in hurt animation
func _play_random_damage_sound() -> void:
	var i:int = randi_range(1,3)
	
	match i:
		1:
			$Damage1.playing = true
		2:
			$Damage2.playing = true
		3:
			$Damage3.playing = true


# Enters the hurt state and stop all timers with charge attack
func _enter_hurt() -> void:
	ray_cast.enabled = false
	$SwoopCharge.stop()
	$RechargeTimer.stop()
	$RaycastRecharge.stop()
	FSM.set_state(FSM.states.hurt)

# Exits the hurt state and resets all the charge attack variables
func _exit_hurt() -> void:
	ray_cast.enabled = true
	recharge_time = false
	swoop_charging_up = false
	velocity_component.Velocity = Vector2.ZERO
	velocity_component.speed_multiplier = 1
	FSM.set_state(FSM.states.fly)
	


func _process(delta):
	#if not ray_cast.is_colliding():
		velocity_component.move(self) # Move the enemy
		

func get_input() -> void:
	# Use raycast to see if target is in distance for swoop attack
	if not recharge_time:
		ray_cast.target_position = (global_position.direction_to(player.global_position)).normalized() * 70
		
	
	# If the raycast collides with its target
	if ray_cast.is_colliding():
		ray_cast_collided()
		ray_cast_position_target = player.global_position
		ray_cast_target_direction = global_position.direction_to(player.global_position)
	else:
		#velocity_component.move(self) # Move the enemy
		if recharge_time == false: # If the enemy isnt recharging allow it to move with pathfinding
			path_find_component.follow_path()
		else:
			# decelerate so the enemy slows down after the initial speed of the dash
			velocity_component.decelerate(.025)
			
		if velocity_component.Velocity.x < 0: # handle the flips with where the enemy is moving
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
			

# Allows the enemy to move with knockback during the hurt/died animations
func hurt_movement() -> void:
	velocity_component.move(self)
	velocity_component.decelerate(.05)

# When the raycast collides it calls this to start the dash process
func ray_cast_collided() -> void:
	swoop_charging_up = true # boolean to make sure the enemy doesnt keep following path
	velocity_component.Velocity *= 0.3 # Slows down the enemy
	path_find_component.timer.stop() # Stops the timer for the pathfinding
	path_find_component.set_target_position(global_position) # Sets path finding to be current position, to stop move bug
	FSM.set_state(FSM.states.swoop_charge_up) # Sets the state to the charge up state
	$SwoopCharge.start() # Start the charge process

func end_ray_cast_collided() -> void:
	swoop_charging_up = false
	path_find_component.timer.start()
	FSM.set_state(FSM.states.fly)

# When the charge timer is done
func _on_swoop_charge_timeout():
	end_ray_cast_collided() # Ends the ray cast collision
	path_find_component.timer.start() # starts pathfinding again
	FSM.set_state(FSM.states.fly) # Sets the state back to fly
	ray_cast.enabled = false # disables the raycast to prevent charging up again
	velocity_component.force_accelerate_to_velocity((ray_cast_target_direction).normalized() * 7) # forces the velocity to be higher (the dash is faster than normal flight)
	velocity_component.speed_multiplier = 1.75 # bumps up the max speed
	recharge_time = true # Turns on the recharge time (time to be able to dash again)
	$RechargeTimer.start() # Starts the recharge timer
	

# When the recharging is done
func _on_recharge_timer_timeout():
	recharge_time = false # sets recharge time to false
	var tween = create_tween() # creates a tween to put speed_multiplier back to normal
	tween.tween_property(velocity_component, "speed_multiplier", 1.0, 0.25)
	tween.play()
	#velocity_component.speed_multiplier = 1
	$RaycastRecharge.start() # start the raycasts recharge

# When the raycast is back online, itll allow the enemy to dash again
func _on_raycast_recharge_timeout():
	ray_cast.enabled = true
