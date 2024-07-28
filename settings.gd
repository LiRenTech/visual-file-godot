extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.size.y = get_viewport_rect().size.y
	self.position.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
