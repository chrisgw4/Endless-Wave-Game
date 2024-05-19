extends Node
class_name DamageComponent

## The amount of damage that will be dealt
@export var damage:float = 1

## The multiplier that the damage will be multiplied by when dealt
@export var damage_multiplier:float = 1.0

@export var knock_back_multiplier:float = 5


func calculate_damage() -> float:
	return damage*damage_multiplier
