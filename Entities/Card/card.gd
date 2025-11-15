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


func initialize(_name: String, _imageUrl: String):
	id = UUID.v4()
	name = _name
	
func getId() -> String:
	return id

func getName() -> String:
	return name
	
