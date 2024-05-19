extends Node
class_name StatsComponent


signal stats_changed(stats:StatsComponent)
signal health_changed(new_health:float)
signal strength_changed(new_strength:float)
signal stamina_changed(new_stamina:float)
signal armor_changed(new_armor:float)
signal luck_changed(new_luck:float)


@export_category("Required Components")


## Required. Will allow StatComponent to set max health of HealthComponent whenever the HP stat changes.
@export var health_component:HealthComponent
## Required. Will allow StatComponent to set change damage multiplier of DamageComponent whenever the Str stat changes.
@export var damage_component:DamageComponent

#@export_subgroup("Optional")
@export_category("Optional Components")
@export var stat_ui:Node2D



## Set in editor, or set in code.
@export_category("Stat Values")

## The amount of Health that the character has
## Affects how much damage the character can sustain
@export var health:float:
	set(new_val):
		health = new_val
		emit_signal("stats_changed", self)
		emit_signal("health_changed", health)
		health_component.max_health = health # Update the health_components max health to match the stat's health

## The amount of Stamina that the character has
@export var stamina:float:
	set(new_val):
		stamina = new_val
		emit_signal("stats_changed", self)
		emit_signal("stamina_changed", stamina)

## The amount of Strength that the character has
## Affects how much damage a character does
@export var strength:float:
	set(new_val):
		strength = new_val
		emit_signal("stats_changed", self)
		emit_signal("strength_changed", strength)
		damage_component.damage_multiplier = strength # Update the damage_components damage_multiplier to match the stat's strength

## The amount of Armor that the character has
## Affects how much damage is nullified from an attack
@export var armor:float:
	set(new_val):
		armor = new_val
		emit_signal("stats_changed", self)
		emit_signal("armor_changed", armor)

## The amount of Luck that the character has.
## Affects the likelihood of drops dropping from enemy characters
@export var luck:float:
	set(new_val):
		luck = new_val
		emit_signal("stats_changed", self)
		emit_signal("luck_changed", luck)

