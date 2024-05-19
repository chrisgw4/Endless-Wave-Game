@tool
extends Control
class_name UINumberComponent



@export_category("Accessory Sprite")

## Sprite (if any) to have next to numbers.
## E.x. Coin sprite to have before coin count.
@export var accessory_sprite_frames:SpriteFrames:
	set(new_sprite_frames):
		accessory_sprite_frames = new_sprite_frames
		
		# Tool stuff to visualize what the UI will look like in editor
		if Engine.is_editor_hint():
			_spawn_accessory_sprite()


@export var accessory_sprite_location:Vector2:
	set(new_val):
		accessory_sprite_location = new_val
		
		# Tool stuff to visualize what the UI will look like in editor
		if Engine.is_editor_hint():
			_spawn_accessory_sprite()

@export var accessory_sprite_scale:Vector2:
	set(new_val):
		accessory_sprite_scale = new_val
		
		# Tool stuff to visualize what the UI will look like in editor
		if Engine.is_editor_hint():
			_spawn_accessory_sprite()

@onready var accessory_sprite:AnimatedSprite2D = $AccessorySprite



@export_category("Number Sprites")
## The Sprite Frames of the numbers (0-9). Order them from 0 - 9 (being each respective number).
## E.x. Index 0 -> Sprite of Number 0
@export var number_sprite_frames:SpriteFrames:
	set(new_val):
		number_sprite_frames = new_val
		
		# Tool stuff to visualize what the UI will look like in editor
		if Engine.is_editor_hint() and number_holder != null:
			for i in number_holder.get_children():
				i.queue_free()
				number_holder.remove_child(i)
			_update_UI_numbers(test_value)

## The width of each number in the sprite frames
@export var number_width:int = 0:
	set(new_val):
		number_width = new_val
		
		# Tool stuff to visualize what the UI will look like in editor
		if Engine.is_editor_hint() and number_holder != null:
			for i in number_holder.get_children():
				i.queue_free()
				number_holder.remove_child(i)
			_update_UI_numbers(test_value)

## The point at which the numbers should start at.
@export var start_pos:Vector2:
	set(new_val):
		start_pos = new_val
		
		# Tool stuff to visualize what the UI will look like in editor
		if Engine.is_editor_hint() and number_holder != null:
			for i in number_holder.get_children():
				i.queue_free()
				number_holder.remove_child(i)
			_update_UI_numbers(test_value)

## The scale that the number sprites should be drawn at
@export var sprite_scale:Vector2:
	set(new_val):
		sprite_scale = new_val
		
		# Tool stuff to visualize what the UI will look like in editor
		if Engine.is_editor_hint() and number_holder != null:
			for i in number_holder.get_children():
				i.queue_free()
				number_holder.remove_child(i)
			_update_UI_numbers(test_value)

## Use built in tool to help position correctly
@export var test_value:int = 1234567890:
	set(new_val):
		#if test_value != new_val:
		test_value = new_val
		
		if Engine.is_editor_hint():
			_update_UI_numbers(test_value)
			#update_configuration_warnings()

@onready var number_holder:Node2D = $NumberHolder


func _get_configuration_warnings():
	var warnings = []
	
	if not number_sprite_frames :
		warnings.append("Please add Sprite Frames to Number Sprite Frames variable.")
	
	
	return warnings




func _ready() -> void:
	if not Engine.is_editor_hint():
		test_value = 0
	
	update_configuration_warnings()
	accessory_sprite.sprite_frames = accessory_sprite_frames
	_spawn_accessory_sprite()
	_update_UI_numbers(test_value)
	

func _spawn_accessory_sprite() -> void:
	if accessory_sprite == null:
		return
	accessory_sprite.position = accessory_sprite_location
	accessory_sprite.scale = accessory_sprite_scale
	accessory_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func _update_UI_numbers(value:float) -> void:
	
	# Stop early if the number_sprite_frames is null so as not to run into issues
	if not number_sprite_frames or number_holder == null:
		return
	
	# Make count var to know what letter value we are on (to see if we need to add anymore numbers to UI)
	var count:int = 0
	
	# Get the number of children in the number_holder (know what numbers we have to know if we need to add more)
	var child_count:int = number_holder.get_child_count()
	
	# Iterate through each letter in str(current_coins), and remove the decimal and any numbers after that
	for letter:String in str(value).substr(0, str(value).find(".")):
		
		# See if there is already a sprite at count in children
		if count < child_count:
			number_holder.get_child(count).frame = int(letter) # If there is change the frame to the correct number value
		
		# Otherwise there is no sprite, and one needs to be addded
		elif count >= child_count:
			
			# Set each position to start at (62, 45) and change X position for each number in str(coins)
			var temp_sprite:AnimatedSprite2D = AnimatedSprite2D.new()#number_sprite.duplicate()
			temp_sprite.sprite_frames = number_sprite_frames
			temp_sprite.frame = int(letter)
			
			if number_width <= 0:
				temp_sprite.position = start_pos + Vector2(number_sprite_frames.get_frame_texture(number_sprite_frames.get_animation_names()[0], 0).get_width()*sprite_scale.x, 0) * Vector2(count, 1)
			else:
				temp_sprite.position = start_pos + Vector2(number_width, 0) * Vector2(count, 1)
				
			#temp_sprite.position.x += accessory_sprite_location.x * accessory_sprite.scale.x
			temp_sprite.scale = sprite_scale
			temp_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			temp_sprite.visible = true
			number_holder.call_deferred("add_child", temp_sprite)
			
		
		count += 1 # Increment count each time
	
	# Update the child_count
	child_count = number_holder.get_child_count()
	
	# After for loop, if the child count of coin_numbers_UI is still greater than count, we need to remove the extra values
	if count < child_count:
		for i in range(0, child_count-count):
			number_holder.get_child(count+i).queue_free()
	


