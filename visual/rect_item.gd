class_name RectItem

var rect: Rect2
var name: String

func _init(rect: Rect2, name: String = "unknown"):
	self.rect = rect
	self.name = name

func intersects(other: RectItem) -> bool:
	return self.rect.intersects(other.rect)
