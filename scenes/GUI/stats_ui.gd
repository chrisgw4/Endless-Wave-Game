extends Node2D


var mouse_in:bool = false
var dragging:bool = false

var start_pos:Vector2
var mouse_offset:Vector2

@export var debug:bool = false
var game_scene:Node2D

func connect_debug_buttons() -> void:
	pass


@export var HP_label:RichTextLabel
@export var STR_label:RichTextLabel
@export var ARM_label:RichTextLabel
@export var LCK_label:RichTextLabel
func _update_stats(stats:StatsComponent) -> void:
	
	HP_label.text = "HP: " + str(stats.health)
	STR_label.text = "STR: " + str(stats.strength)
	ARM_label.text = "ARM: " + str(stats.armor)
	LCK_label.text = "LCK: " + str(stats.luck)



func _ready() -> void:
	if not debug:
		$MoveAbleUI/TabContainer/DebugPanel.queue_free()
		

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and mouse_in:
			start_pos = $MoveAbleUI.position
			mouse_offset = get_local_mouse_position()
			dragging = true
		else:
			dragging = false
	if Input.is_action_just_pressed("open_menu"):
		$MoveAbleUI.visible = not $MoveAbleUI.visible
		dragging = false
	
	

func _on_mouse_detector_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_detector_mouse_exited() -> void:
	mouse_in = false

func _process(_delta) -> void:
	if dragging and $MoveAbleUI.visible: # If its dragging, move the window to the new mouse position
		$MoveAbleUI.position = start_pos + get_global_mouse_position() - mouse_offset
	# Check if UI is out of bounds and puts it back in the main window
	elif $MoveAbleUI.position.x+779 < 0:
		$MoveAbleUI.position.x = -770
	elif $MoveAbleUI.position.x > get_viewport_rect().size.x:
		$MoveAbleUI.position.x = get_viewport_rect().size.x - 10
	elif $MoveAbleUI.position.y > get_viewport_rect().size.y:
		$MoveAbleUI.position.y = get_viewport_rect().size.y - 10
	elif $MoveAbleUI.position.y < 0:
		$MoveAbleUI.position.y = 10
		


func _on_button_pressed():
	$MoveAbleUI.hide()
	dragging = false


