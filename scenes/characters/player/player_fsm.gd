extends FiniteStateMachine


func _init() -> void:
	_add_state("run")
	_add_state("idle")
	_add_state("hurt")
	_add_state("died")
	
	


func _ready() -> void:
	set_state(states.idle)



func _state_logic(_delta: float) -> void:
	parent.get_input()
	#parent.move()



func _get_transition() -> int:
	if state == states["died"]:
		return states["died"]
	
	if state == states["hurt"]:
		return states["hurt"]
	
	if parent.velocity.length() > 10:
		return states["run"]
	else:
		return states["idle"]
	
	return -1


func _enter_state(_previous_state: int, new_state: int) -> void:
	animation_player.play(states_names[new_state])



