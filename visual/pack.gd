extends Node

# 定义一个矩形排列算法的工具类
class_name RectangleSorter

func _init():
	pass

func sort_rectangle_just_vertical(rectangles: Array[RectItem], margin: float) -> Array[RectItem]:
	var current_y := margin
	for rectangle in rectangles:
		rectangle.rect.position.y = current_y
		rectangle.rect.position.x = margin
		current_y += rectangle.rect.size.y + margin
	return rectangles

func sort_rectangle_greedy(rectangles: Array[RectItem], margin: float) -> Array[RectItem]:
	if rectangles.size() == 0:
		return []

	rectangles[0].rect.position = Vector2(0, 0)
	var ret: Array[RectItem] = [rectangles[0]]
	var width := rectangles[0].rect.size.x
	var height := rectangles[0].rect.size.y

	for i in range(1, rectangles.size()):
		var min_space_score := -1
		var min_shape_score := -1
		var min_rect: RectItem = RectItem.new(Rect2(0, 0, 0, 0))
		for j in range(ret.size()):
			var r: RectItem = append_right(ret[j], rectangles[i], ret, margin)
			var space_score: float = r.rect.position.x + r.rect.size.x - width + r.rect.position.y + r.rect.size.y - height
			var shape_score: float = abs(max(r.rect.position.x + r.rect.size.x, width) - max(r.rect.position.y + r.rect.size.y, height))
			if min_space_score == -1 or space_score < min_space_score or (space_score == min_space_score and shape_score < min_shape_score):
				min_space_score = space_score
				min_shape_score = shape_score
				min_rect = r
			
			r = append_bottom(ret[j], rectangles[i], ret, margin)
			space_score = r.rect.position.x + r.rect.size.x - width + r.rect.position.y + r.rect.size.y - height
			shape_score = abs(max(r.rect.position.x + r.rect.size.x, width) - max(r.rect.position.y + r.rect.size.y, height))
			if min_space_score == -1 or space_score < min_space_score or (space_score == min_space_score and shape_score < min_shape_score):
				min_space_score = space_score
				min_shape_score = shape_score
				min_rect = r

		width = max(width, min_rect.rect.position.x + min_rect.rect.size.x)
		height = max(height, min_rect.rect.position.y + min_rect.rect.size.y)
		ret.append(min_rect)

	return ret

func sort_rectangle_right_bottom(rectangles: Array[RectItem], margin: float) -> Array[RectItem]:
	rectangles[0].position = Vector2(0, 0)
	var ret: Array[RectItem] = [rectangles[0]]
	var width := rectangles[0].rect.size.x
	var height := rectangles[0].rect.size.y
	var index := 0

	for i in range(1, rectangles.size()):
		if width < height:
			append_right(ret[index], rectangles[i], ret, margin)
			var w := rectangles[i].rect.position.x + rectangles[i].rect.size.x
			if w > width:
				width = w
				index = i
		else:
			append_bottom(ret[index], rectangles[i], ret, margin)
			var h := rectangles[i].rect.position.y + rectangles[i].rect.size.y
			if h > height:
				height = h
				index = i
		ret.append(rectangles[i])

	return ret

func append_right(origin: RectItem, rect: RectItem, rects: Array, margin: float) -> RectItem:
	var ret := RectItem.new(Rect2(rect.rect.position, rect.rect.size))
	ret.rect.position.x = origin.rect.position.x + origin.rect.size.x + margin
	ret.rect.position.y = origin.rect.position.y

	var collision := true
	while collision:
		collision = false
		for r in rects:
			if ret.intersects(r):
				ret.rect.position.y = r.rect.position.y + r.rect.size.y + margin
				collision = true
				break

	return ret

func append_bottom(origin: RectItem, rect: RectItem, rects: Array, margin: float) -> RectItem:
	var ret := RectItem.new(Rect2(rect.rect.position, rect.rect.size))
	ret.rect.position.y = origin.rect.position.y + origin.rect.size.y + margin
	ret.rect.position.x = origin.rect.position.x

	var collision := true
	while collision:
		collision = false
		for r in rects:
			if ret.intersects(r):
				ret.rect.position.x = r.rect.position.x + r.rect.size.x + margin
				collision = true
				break

	return ret
