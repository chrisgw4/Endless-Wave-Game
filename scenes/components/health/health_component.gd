extends Node2D
class_name HealthComponent

signal died_event

signal hurt_event

signal health_changed(health_stat:HealthStats)

signal max_health_changed()

# checks if the character still has health remaining
var has_health_remaining:bool = true#!(current_health != 0)



## How much hp should the character have as a maximum
@export var max_health: float = 2:
	set(value):
		max_health = value
		if current_health > max_health:
			current_health = max_health
		emit_signal("max_health_changed", HealthStats.new(current_health, current_health, max_health, current_health_percent, (false)))
			

var current_health_percent:float = current_health/max_health

var has_died:bool = false

var is_damage:bool = false

var health_stat:HealthStats

## How much hp should the character have
@onready var current_health: float = max_health:
	set(new_health):
		var previous_health:float = current_health
		
		
		current_health = clampf(new_health, 0, max_health)
		
		is_damage = current_health < previous_health
		
		current_health_percent = current_health/max_health
		has_health_remaining = (current_health != 0)
		
		health_stat = HealthStats.new(previous_health, current_health, max_health, current_health_percent, (current_health > previous_health))
		
		
		emit_signal("health_changed", health_stat)
		
		# if the new health is lower than the previous health then it is damage
		if (is_damage):
			emit_signal("hurt_event")
			
		if (not has_health_remaining && !has_died):
			has_died = true
			emit_signal("died_event")
			



func damage(damage_val:float, force_hide_damage:bool = false) -> void:
	current_health -= damage_val


func chip_damage(damage_val:float,):
	set_block_signals(true) # make it so the set_health func doesnt emit hurt signal
	damage(damage_val, false)
	set_block_signals(false) # allow the set_health func to be able to emit signals again
	emit_signal("health_changed", health_stat) # emit the health changed signal because it was blocked


	if (current_health == 0):
		has_died = true
		emit_signal("died_event")


func heal(health:float) -> void:
	damage(-health, true)


func set_max_health(health:float) -> void:
	max_health = health


func initialize_health() -> void:
	current_health = max_health


func _ready() -> void:
	initialize_health()


class HealthStats:
	var Previous_Health:float
	var Current_Health:float
	var Max_Health:float
	var Current_Health_Percent:float
	var is_heal:bool
	
	func _init(p_h:float, c_h:float, m_h:float, c_h_p:float, heal:bool) -> void:
		Previous_Health = p_h
		Current_Health = c_h
		Max_Health = m_h
		Current_Health_Percent = c_h_p
		is_heal = heal
		
	
