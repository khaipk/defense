extends Area2D

export (PackedScene) var Piece

var dragMouse = false
var deltaPos : Vector2
var s_width : float = 0
var s_height : float = 0
var shape_list =[
	# 1 dot
	[[1]],
	# 2 dots
	[[1,1]],
	[[1],[1]],
	[[1,0],[0,1]],
	# 3 dots
	[[1],[1],[1]],
	[[1,1,1]],
	[[1,0],[1,1]],
	[[1,1],[0,1]],
	# 4 dots
	[[1],[1],[1],[1]],
	[[1,1],[1,1]],
	[[1,1,1],[0,1,0]],
	[[1,1,0],[0,1,1]],
	
	[[1,1,1],[1,1,1],[1,1,1]],
	[[1,1,0],[0,1,0],[0,1,1]],
]
var originPos : Vector2
var available : bool = true
var number : int
var shape_list_pos : int
var matrix_shape = []

func _ready():
	originPos = get_position()
	init()

func init():
	randomize()
	shape_list_pos = randi() % shape_list.size()

func _process(delta):
	if dragMouse:
		set_position(get_viewport().get_mouse_position() + deltaPos)
		get_parent().show_high_light(self)

func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if available == true:
		if event is InputEventMouseButton and !get_tree().is_input_handled():
			if event.is_pressed():
				dragMouse = true
				deltaPos = get_position() - get_viewport().get_mouse_position()
				set_scale(Vector2(0.7,0.7))
				get_tree().set_input_as_handled()
				set_z_index(5)
				get_parent().show_high_light(self)
				for i in range(2, get_children().size()):
					get_children()[i].position = get_children()[i].position / 0.8
					
			else:
				dragMouse = false
				set_z_index(0)
				get_parent().check_move_shape(self)
				for i in range(2, get_children().size()):
					get_children()[i].position = get_children()[i].position * 0.8

func move_to_origin():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position", get_position(), originPos, 0.25,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "scale", get_scale(), Vector2(0.5,0.5), 0.25,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func draw_shape():
	matrix_shape  = shape_list[shape_list_pos]
	var pieceTest = Piece.instance()
	var bound = RectangleShape2D.new()
	var real_width = pieceTest.get_node("Sprite").texture.get_width()*pieceTest.get_node("Sprite").get_scale().x
	var real_height = pieceTest.get_node("Sprite").texture.get_height()*pieceTest.get_node("Sprite").get_scale().y
	bound.extents.y = 3*real_width
	bound.extents.x = 3*real_height
	s_width = matrix_shape.size()*real_width /2
	s_height = matrix_shape[0].size()*real_height /2
	#$bound.shape = bound
	var draw_offset = Vector2(-matrix_shape[0].size()*real_width/2 + real_width/2, -matrix_shape.size()*real_height/2 + real_height/2)
	for i in matrix_shape.size():
		for j in matrix_shape[i].size():
			if matrix_shape[i][j] == 1:
				var piece = Piece.instance()
				piece.position = Vector2(draw_offset.x + j*real_width, draw_offset.y + i*real_height)
				add_child(piece)

func remake_shape(shape_pos):
	shape_list_pos = shape_pos
	matrix_shape  = shape_list[shape_list_pos]
	var pieceTest = Piece.instance()
	var bound = RectangleShape2D.new()
	var real_width = pieceTest.get_node("Sprite").texture.get_width()*pieceTest.get_node("Sprite").get_scale().x
	var real_height = pieceTest.get_node("Sprite").texture.get_height()*pieceTest.get_node("Sprite").get_scale().y
	bound.extents.y = 3*real_width
	bound.extents.x = 3*real_height
	s_width = matrix_shape.size()*real_width /2
	s_height = matrix_shape[0].size()*real_height /2
	$bound.shape = bound
	var draw_offset = Vector2(-matrix_shape[0].size()*real_width/2 + real_width/2, -matrix_shape.size()*real_height/2 + real_height/2)
	for i in matrix_shape.size():
		for j in matrix_shape[i].size():
			if matrix_shape[i][j] == 1:
				var piece = Piece.instance()
				piece.position = Vector2(draw_offset.x + j*real_width, draw_offset.y + i*real_height)
				add_child(piece)

func recolor(x):
	for i in range(2, get_children().size()):
		if x == 1:
			get_children()[i].modulate = Color(1,1,1,0.2)
		elif x == 2:
			get_children()[i].modulate = Color(1,1,1,1)
