extends CharacterBody2D
class_name Player






var coin_tween:Tween

var coins:float = 0:
	set(new_val):
		coins = new_val
		
		if coins < 0:
			coins = 0
		
		if coin_tween:
			coin_tween.stop()
			coin_tween = null
		
		coin_tween = create_tween()
		coin_tween.set_ease(Tween.EASE_OUT)
		coin_tween.tween_property(self, "current_coins", coins, 0.55)
		coin_tween.play()
		


var current_coins:float = 0:
	set(new_val):
		current_coins = new_val
		#convert_coins_to_imgs()
		$UI/FlowContainer/NumberUIComponent._update_UI_numbers(current_coins)




@export var main_camera:Camera2D
@export var shop_camera:Camera2D

@export var velocity_component:VelocityComponent
@export var animated_sprite:AnimatedSprite2D
@export var FSM:FiniteStateMachine
@export var health_component:HealthComponent


# Called by animation_player in run animation, plays a random of 3 walking sounds at specific interval
func _play_random_walk_sound() -> void:
	
	# Get a random int between 0-2 (inclusive)
	var i:int = randi_range(0,2)
	
	if i == 0:
		$WalkSound1.playing = true
	elif i == 1:
		$WalkSound2.playing = true
	elif i == 2:
		$WalkSound3.playing = true


var start_arrow_track:bool = false:
	set(new_val):
		if new_val == true:
			arrow_pointer.visible = true
		start_arrow_track = new_val
		

var arrow_track_target:Vector2
@onready var arrow_pointer:Node2D = $ArrowPointer


func swap_camera() -> void:
	if main_camera.enabled:
		main_camera.enabled = false
		shop_camera.enabled = true
	else:
		main_camera.enabled = true
		shop_camera.enabled = false



signal current_health_changed(health_stats:HealthComponent.HealthStats)

var current_health:int = 0: # Allow for tweening of current_health to the true current health stored in HealthComponent
	set(new_hp):
		emit_signal("current_health_changed", HealthComponent.HealthStats.new(current_health, new_hp, health_component.max_health, health_component.current_health_percent, new_hp>current_health))
		current_health = new_hp
		


var health_tween:Tween

func _change_current_health(health_stats) -> void:
	
	if health_tween: # If there is already a tween
		health_tween.stop() # Stop it
	
	health_tween = create_tween() # Create a new tween
	health_tween.tween_property(self, "current_health", health_stats.Current_Health, 0.35)
	health_tween.play()
	
	

## Create variable for the player's stats
@export var stats:StatsComponent

## Keeps track and updates player's stats on a visible panel for player to see
@export var stats_ui:Node2D

# Initializes the stats and sets them to base values and connects signal to function
func initialize_stats() -> void:
	stats.connect("stats_changed", stats_ui._update_stats)
	#stats.connect("strength_changed", $Node2D/Sword._update_damage_multiplier)
	#stats.connect("health_changed", _update_healthcomponent)
	stats.health = health_component.max_health
	stats.strength = 1
	stats.luck = 1
	stats.armor = 0
	stats.stamina = 1


func _update_healthcomponent(health:float) -> void:
	health_component.max_health = health


func _ready() -> void:
	current_health = health_component.max_health
	health_component.connect("hurt_event", _enter_hurt)
	health_component.connect("died_event", FSM.set_state.bind(FSM.states.died))
	#health_component.connect("health_changed", _update_health)
	health_component.connect("health_changed", _change_current_health)
	connect("current_health_changed", _update_health)
	health_component.connect("max_health_changed", _update_health)
	#health_component.connect("max_health_changed", _update_stats)
	
	set_up_health()
	initialize_stats()
	


func _enter_hurt() -> void:
	FSM.set_state(FSM.states.hurt)
	Engine.time_scale = 0.75
	var tween2 = create_tween()
	tween2.tween_property(Engine, "time_scale", 1, 1)
	tween2.play()


## Keeps the heart animated sprite (heart and no heart) to be able to show player how much health they have
@onready var heart_sprite:PackedScene = preload("res://scenes/GUI/heartUI.tscn")
@export var heart_container:HFlowContainer

# Sets up the health sprites in the top left UI, and adds the right amount of hearts at max hp
func set_up_health() -> void:
	for i in heart_container.get_children():
		i.queue_free()
	
	for i in range(health_component.max_health):
		#var control:Control = Control.new() # create a new control node
		var heart:Control = heart_sprite.instantiate() # duplicate the heart sprite
		
		#control.add_child(heart) # add heart sprite as a child to control
		heart_container.add_child(heart) # Add the control to the heart_container to show it
		
		heart.visible = true # Make the heart visible in the UI
		#heart.get_child(0).frame = 0 # Set the frame to the heart that is full
		heart.set_fixed() # Sets the heart to the fixed state
		


# Function updates the health, using the health stats to help
func _update_health(health_stats) -> void:
	
	var array = heart_container.get_children()
	
	# If max health has increased
	if health_component.max_health > heart_container.get_child_count():
		
		# Iterate through the amount more health that needs to be added
		for i in range(health_component.max_health-heart_container.get_child_count()):
			#var control:Control = Control.new() # create a new control node
			var heart:Control = heart_sprite.instantiate() # duplicate the heart sprite
			
			#control.add_child(heart) # add heart sprite as a child to control
			heart_container.add_child(heart) # Add the control to the heart_container to show it
			
			heart.visible = true
			#heart.get_child(0).frame = 1 # Make the heart be empty, because new health was just added (subject to change)
			heart.set_broken() # Sets the heart to the broken state
			
	# If max health has decreased
	elif health_component.max_health < heart_container.get_child_count():
		# Iterate backwards and remove the extra hearts
		for i in range(1, heart_container.get_child_count()-health_component.max_health+1):
			array[heart_container.get_child_count()-i].queue_free()
	
	
	# If player healed
	if health_stats.is_heal:
		# Go back how much was healed and set the frame of heart to full heart
		for i in range(abs(health_stats.Current_Health - health_stats.Previous_Health), 0, -1):
			#array[health_stats.Previous_Health+i-1].get_child(0).frame = 0 # Go from left to right starting at previous Health-1
			array[health_stats.Current_Health-i].fix_heart()
	# If player took damage
	elif heart_container.get_child_count() > health_stats.Current_Health:
		# Go backward from current health + i (Previous_Health) and turn off the hearts
		for i in range(abs(health_stats.Current_Health - health_stats.Previous_Health), 0, -1):
			array[health_stats.Current_Health+i-1].break_heart()#get_child(0).frame = 1 # Go from right to left starting at previous_health


# Allow for smooth movement moving based on framerate and delta rather than set time in physics process
func _process(delta):
	velocity_component.move(self)


# Called by the FSM, follows the physics process
func get_input() -> void:
	#if start_arrow_track and global_position.distance_to(arrow_track_target) > 60:
		#arrow_pointer.rotation = lerp_angle(arrow_pointer.rotation, arrow_pointer.global_position.angle_to_point(arrow_track_target), 0.15)
		#arrow_pointer.visible = true
	#else:
		#arrow_pointer.visible = false
		
	
	# Get the new movement velocity
	var vel:Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	#velocity_component.accelerate_to_velocity(vel*speed)
	#velocity_component.decelerate(0.5)
	velocity_component.accelerate_in_direction(vel.normalized()*10) # Accelerate in the direction of the input velocity and multiply by 10 to make speed
	
	#velocity_component.move(self)
	
	# Determine if the player's sprite needs to flip horizontally
	if get_local_mouse_position().x < 0:
		animated_sprite.flip_h = true
		$Node2D.scale.y = -1
	else:
		animated_sprite.flip_h = false
		$Node2D.scale.y = 1
	
	# Make sword look at where the mouse is
	$Node2D.look_at(get_global_mouse_position())
	
	# If the attack input is sent, play the swords swing animation
	#if Input.is_action_just_pressed("attack"):
		#$SwordPlayer.play("swing")

func _unhandled_input(event):
	if Input.is_action_just_pressed("attack"):
		$SwordPlayer.play("swing")

# Exit the hurt state
func exit_hurt() -> void:
	FSM.set_state(FSM.states.run)
