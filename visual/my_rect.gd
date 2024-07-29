class_name MyRect

var position: Vector2
var size: Vector2
var name: String

func _init(position: Vector2, size: Vector2, name: String = "unknown"):
	self.position = position
	self.size = size
	self.name = name

func intersects(other: MyRect) -> bool:
	return self.to_rect2().intersects(other.to_rect2())

func to_rect2() -> Rect2:
	return Rect2(position, size)
