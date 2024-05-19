extends Node2D



@export var timer:Timer
@export var UI:CanvasLayer
@export var next_wave_button:TextureButton


# Keeps track of the total enemies still alive in the current wave
var total_enemies:int = 0:
	set(new_val):
		total_enemies = new_val
		if new_val == 0: # When all enemies are killed
			#spawn_chest()
			UI.visible = true # Set the Next Wave button to be visible
			next_wave_button.disabled = false # Enable the next wave button
			$Door.open() # Open the door that leads to the shop
			$UI/BattleMusic.playing = false # Stop playing the battle music
			$UI/Music.playing = true # Start playing the normal music
			

var enemies:Array[PackedScene] = [preload("res://scenes/characters/enemies/flying_creature.tscn"), preload("res://scenes/characters/enemies/slime.tscn")]
var chest:PackedScene = preload("res://scenes/objects/chest.tscn")

@export var tilemap:TileMap


func _ready() -> void:
	UI.visible = true
	randomize()
	#make_enemies()
	next_wave_button.connect("pressed", _send_next_wave)


# Spawns in the next wave, when the next wave button is clicked
func _send_next_wave() -> void:
	if total_enemies == 0: # Makes sure all enemies are dead first
		make_enemies() # Then instances each enemy and adds to game scene
		UI.visible = false # Hide the UI to not allow you to send in more waves at once
		next_wave_button.disabled = true # Disable the next wave button to prevent sending in another wave while one is active
		$UI/AudioStreamPlayer.play() # Play the Button Click sound
		$Door.close() # Close the door to shop
		$UI/BattleMusic.playing = true # Start the battle music
		$UI/Music.playing = false # Stop the normal music



# Function to instance enemies and add them to game scene
func make_enemies() -> void:
	for i in range(20): # Iterate through the number of enemies to be spawned
		var enemy = enemies.pick_random().instantiate() # Gets a random enemy and instances it from the enemy array
		enemy.health_component.connect("died_event", _decrement_enemies) # When enemy dies, it will decrement the enemy counter here
		total_enemies += 1 # Increment the total_enemies for each enemy added
		
		# Get a random position within the range of the battle arena
		enemy.global_position = Vector2(randf_range($Node2D.global_position.x, $Node2D2.global_position.x), randf_range($Node2D.global_position.y, $Node2D2.global_position.y))
		
		# If the enemy is too close to the player, keep retrying to get a position
		while enemy.global_position.distance_to(%Player.global_position) < 70:
			enemy.global_position = Vector2(randf_range($Node2D.global_position.x, $Node2D2.global_position.x), randf_range($Node2D.global_position.y, $Node2D2.global_position.y))
		
		# Adds the child in the next frame
		call_deferred("add_child", enemy)
		await get_tree().create_timer(0.25).timeout # Waits 0.25 seconds between each enemy to alleviate stress in one frame of adding all enemies
		



func spawn_chest() -> void:
	var temp_chest = chest.instantiate()
	temp_chest.global_position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	while temp_chest.global_position.distance_to($Player.global_position) < 70:
		temp_chest.global_position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	%Player.arrow_track_target = temp_chest.global_position
	%Player.start_arrow_track = true
	call_deferred("add_child", temp_chest)


# Called whenever an enemy that is spawned, dies
func _decrement_enemies() -> void:
	total_enemies -= 1



# Moves player to shop
func _on_player_detector_to_shop_body_entered(body:Player):
	body.global_position = $Door2.global_position + Vector2(0, 80)
	UI.visible = false
	body.swap_camera()

# Moves player to Main room
func _on_player_detector_to_main_body_entered(body):
	body.global_position = $Door.global_position + Vector2(0, 80)
	UI.visible = true
	body.swap_camera()


func _on_battle_music_finished():
	$UI/BattleMusic.playing = true


func _on_music_finished():
	$UI/Music.playing = true


func _on_button_pressed():
	%Player.coins -= 10


func _on_button_2_pressed():
	%Player.health_component.damage(3)


func _on_button_3_pressed():
	%Player.health_component.heal(3)



