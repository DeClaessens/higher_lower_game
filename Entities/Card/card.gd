extends Node2D

enum statusEnum {
	DRAGGING,
	CLICKED,
	IDLE,
	RELEASED
}

var id: String
var status = statusEnum.IDLE
var mousePosition = Vector2()
var tsize

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	tsize = sprite.get_texture().get_size()
	
	# Set the initial global position of the sprite to be the center of the
	# viewport. Note GDScript supports vector math.
	global_position = get_viewport_rect().size / 2
	
func _process(_delta):
	if status == statusEnum.DRAGGING:
		global_position = mousePosition + sprite.offset

# Yet another Godot hook. It is called every time an input event @ev is
# received. The input events we care about are clicks (InputEventMouseButton)
# and movement (InputEventMouseButton). We do something special for each event,
# in order control the state of the game. No matter what, every time this
# hook is called, we update the mouse position to match the position at which
# the input event was generated.
func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		# If the sprite is not being dragged, and if the mouse button was
		# clicked (as opposed to released, or "unclicked"), do things.
		if status != statusEnum.DRAGGING and ev.pressed:
			# Define a event position variable (scoped to this if block)
			var evpos = ev.global_position
			
			# Define a global sprite position variable (scoped to this if
			# block)
			var gpos = global_position
			
			# The Sprite can be centered or not, and this can change during
			# the game. That's why we check for it in the loop. We are creating
			# a rect with the sprites dimensions and position in order to
			# check if the sprite was clicked or not, so it's important to
			# know whether or not the sprite is centered!
			var rect = Rect2()
			if sprite.is_centered():
				# If the sprite is centered, be sure to switch the x and y
				# coordinates of the position by half the width and half the
				# height of the sprite, respectively.
				rect = Rect2(gpos.x - tsize.x / 2, gpos.y - tsize.y / 2, tsize.x, tsize.y)
			else:
				# If the sprite is not centered, no need to shift the
				# coordinates. We can just use the sprite's global position
				# by itself.
				rect = Rect2(gpos.x, gpos.y, tsize.x, tsize.y)
				
			# This is where we actually check if the sprite was clicked or not,
			# by checking if the clicked point is in the Sprite's rectangle.
			if rect.has_point(evpos):
				# If the sprite's rectangle was clicked, update the sprite
				# status to "clicked", and update the offset. The offset is
				# the vector pointing from @evpos to @gpos.
				status = statusEnum.CLICKED
				sprite.offset = gpos - evpos
		
		# If the sprite is being dragged and the mouse button is being released,
		# set the sprite status to "released" to stop dragging and drop the
		# sprite.
		elif status == statusEnum.DRAGGING and not ev.pressed:
			status = statusEnum.RELEASED
	
	# If the card status is "clicked" and the mouse is being moved, set the
	# sprite status to "dragging", so the appropriate loop can run when a mouse
	# button click or release event is next received.
	if status == statusEnum.CLICKED and ev is InputEventMouseMotion:
		status = statusEnum.DRAGGING

	# Not matter what, every time an input event is received, update the mouse
	# position with the event's global position. This may need to be moved
	# into the other "if" statements when we start handling other input events
	# here.
	if ev is InputEventMouse:
		mousePosition = ev.global_position



func initialize(_name: String, _imageUrl: String):
	id = UUID.v4()
	name = _name
	

func getId() -> String:
	return id

func getName() -> String:
	return name
	
