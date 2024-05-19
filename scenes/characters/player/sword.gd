extends Node2D

## Allows for access to connected hitbox to determine damage
@export var hitbox:Hitbox


#func _update_damage_multiplier(new_damage:float) -> void:
	#if hitbox:
		#hitbox.damage_multiplier = new_damage
		#print("Damage Mult: " + str(hitbox.damage_multiplier))

