extends GutTest

var card
var draggable: DraggableComponent
func before_each():
	card = Area2D.new()
	card.global_position = Vector2(100, 100)
	
	var collisionShape = CollisionShape2D.new()
	collisionShape.shape = RectangleShape2D.new()
	collisionShape.shape.size = Vector2(50,50)
	card.add_child(collisionShape)
	draggable = preload("res://Components/DraggableComponent/draggableComponent.tscn").instantiate()
	card.add_child(draggable)
	
	get_tree().get_root().add_child(card)
	
func test_dragging():
	# Initial click at (110, 110)
	var click_event = InputEventMouseButton.new()
	click_event.button_index = MOUSE_BUTTON_LEFT
	click_event.pressed = true
	click_event.global_position = Vector2(110, 110)
	
	draggable._on_area_input_event(get_viewport(), click_event, 0)
	
	# The offset should be computed correctly
	var expected_offset = card.global_position - click_event.global_position
	assert_eq(draggable.offset, expected_offset, "Offset is correct")
	
	# Simulate dragging to (200, 200)
	draggable.dragging = true
	# Override the process call manually
	var fake_mouse_pos = Vector2(200, 200)
	card.global_position = fake_mouse_pos + draggable.offset
	
	# Check that the new global_position is correct
	var expected_position = fake_mouse_pos + draggable.offset
	assert_eq(card.global_position, expected_position, "Card moved correctly during drag")
	
	# Simulate release
	var release_event = InputEventMouseButton.new()
	release_event.button_index = MOUSE_BUTTON_LEFT
	release_event.pressed = false
	release_event.global_position = Vector2(200, 200)
	
	draggable._on_area_input_event(get_viewport(), release_event, 0)
	assert_eq(draggable.dragging, false, "Dragging stopped after release")
	
