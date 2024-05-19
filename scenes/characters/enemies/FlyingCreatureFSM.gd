extends FiniteStateMachine


func _init() -> void:
	_add_state("fly")
	_add_state("swoop_charge_up")
	_add_state("hurt")
	_add_state("died")
	
	


func _ready() -> void:
	set_state(states.fly)



func _state_logic(_delta: float) -> void:
	if state not in [states["swoop_charge_up"], states["hurt"], states['died']]:
		parent.get_input()
	if state == states["hurt"] or state == states["died"]:
		parent.hurt_movement()



func _get_transition() -> int:
	if state == states["died"]:
		return states["died"]
	
	if state == states["hurt"]:
		return states["hurt"]
	
	if parent.swoop_charging_up == false:
		return states["fly"]
	else:
		return states["swoop_charge_up"]



func _enter_state(_previous_state: int, new_state: int) -> void:
	animation_player.play(states_names[new_state])



