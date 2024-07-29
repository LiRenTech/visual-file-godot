extends Node

# 定义一个矩形排列算法的工具类
class_name RectangleSorter

func _init():
	pass

func sort_rectangle_just_vertical(rectangles: Array[MyRect], margin: float) -> Array[MyRect]:
	var current_y := margin
	for rectangle in rectangles:
		rectangle.position.y = current_y
		rectangle.position.x = margin
		current_y += rectangle.size.y + margin
	return rectangles

func sort_rectangle_greedy(rectangles: Array[MyRect], margin: float) -> Array[MyRect]:
	if rectangles.size() == 0:
		return []

	rectangles[0].position = Vector2(0, 0)
	var ret: Array[MyRect] = [rectangles[0]]
	var width := rectangles[0].size.x
	var height := rectangles[0].size.y

	for i in range(1, rectangles.size()):
		var min_space_score := -1
		var min_shape_score := -1
		var min_rect: MyRect = MyRect.new(Vector2(0, 0), Vector2(0, 0))
		for j in range(ret.size()):
			var r: MyRect = append_right(ret[j], rectangles[i], ret, margin)
			var space_score: float = r.position.x + r.size.x - width + r.position.y + r.size.y - height
			var shape_score: float = abs(max(r.position.x + r.size.x, width) - max(r.position.y + r.size.y, height))
			if min_space_score == -1 or space_score < min_space_score or (space_score == min_space_score and shape_score < min_shape_score):
				min_space_score = space_score
				min_shape_score = shape_score
				min_rect = r
			
			r = append_bottom(ret[j], rectangles[i], ret, margin)
			space_score = r.position.x + r.size.x - width + r.position.y + r.size.y - height
			shape_score = abs(max(r.position.x + r.size.x, width) - max(r.position.y + r.size.y, height))
			if min_space_score == -1 or space_score < min_space_score or (space_score == min_space_score and shape_score < min_shape_score):
				min_space_score = space_score
				min_shape_score = shape_score
				min_rect = r

		width = max(width, min_rect.position.x + min_rect.size.x)
		height = max(height, min_rect.position.y + min_rect.size.y)
		ret.append(min_rect)

	return ret

func sort_rectangle_right_bottom(rectangles: Array[MyRect], margin: float) -> Array[MyRect]:
	rectangles[0].position = Vector2(0, 0)
	var ret: Array[MyRect] = [rectangles[0]]
	var width := rectangles[0].size.x
	var height := rectangles[0].size.y
	var index := 0

	for i in range(1, rectangles.size()):
		if width < height:
			append_right(ret[index], rectangles[i], ret, margin)
			var w := rectangles[i].position.x + rectangles[i].size.x
			if w > width:
				width = w
				index = i
		else:
			append_bottom(ret[index], rectangles[i], ret, margin)
			var h := rectangles[i].position.y + rectangles[i].size.y
			if h > height:
				height = h
				index = i
		ret.append(rectangles[i])

	return ret

func append_right(origin: MyRect, rect: MyRect, rects: Array, margin: float) -> MyRect:
	var ret := MyRect.new(rect.position, rect.size)
	ret.position.x = origin.position.x + origin.size.x + margin
	ret.position.y = origin.position.y

	var collision := true
	while collision:
		collision = false
		for r in rects:
			if ret.intersects(r):
				ret.position.y = r.position.y + r.size.y + margin
				collision = true
				break

	return ret

func append_bottom(origin: MyRect, rect: MyRect, rects: Array, margin: float) -> MyRect:
	var ret := MyRect.new(rect.position, rect.size)
	ret.position.y = origin.position.y + origin.size.y + margin
	ret.position.x = origin.position.x

	var collision := true
	while collision:
		collision = false
		for r in rects:
			if ret.intersects(r):
				ret.position.x = r.position.x + r.size.x + margin
				collision = true
				break

	return ret
