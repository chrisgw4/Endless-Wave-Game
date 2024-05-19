extends HFlowContainer



@onready var game_scene:Node2D = get_tree().current_scene

var ready_to_spawn_enemy:bool = false
var instanced_scene = null

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and ready_to_spawn_enemy:
			instanced_scene.global_position = game_scene.get_global_mouse_position()
			
			game_scene.add_child(instanced_scene)
			ready_to_spawn_enemy = false
			instanced_scene = null
			


func _on_bat_spawn_pressed():
	var bat = load("res://scenes/characters/enemies/flying_creature.tscn").instantiate()
	instanced_scene = bat
	ready_to_spawn_enemy = true
	#bat.global_position = game_scene.get_node("Player").global_position + Vector2(40, 0)
	


func _on_slime_spawn_pressed():
	var slime = load("res://scenes/characters/enemies/slime.tscn").instantiate()
	instanced_scene = slime
	ready_to_spawn_enemy = true
	#slime.global_position = game_scene.get_node("Player").global_position + Vector2(40, 0)



func _on_coin_spawn_pressed():
	var coin = load("res://scenes/pickup items/coin/coin.tscn").instantiate()
	instanced_scene = coin
	ready_to_spawn_enemy = true


func _on_heart_spawn_pressed():
	var heart = load("res://scenes/pickup items/heart/heart.tscn").instantiate()
	instanced_scene = heart
	ready_to_spawn_enemy = true

@onready var player:Player = get_tree().current_scene.get_node("Player")

func _on_heal_pressed():
	player.health_component.heal(1)


func _on_damage_pressed():
	player.health_component.damage(1)


func _on_strength_increase_pressed():
	player.stats.strength += 1


func _on_health_increase_pressed():
	player.stats.health += 1


func _on_set_coins_0_pressed():
	player.coins = 0
