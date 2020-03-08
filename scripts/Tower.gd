extends Area2D

var originPos = Vector2()
var available : bool = true
var dragging : bool = false
var time_check : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	originPos = get_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		set_position(get_viewport().get_mouse_position())
	if global.game_state == 1 and !time_check and !available:
		$Timer.start()
		time_check = true

func _on_Tower_input_event(viewport, event, shape_idx):
	if available:
		if event is InputEventMouseButton:
			if event.is_pressed():
				dragging = true
				set_z_index(2)
			else:
				dragging = false
				get_parent().move_tower(self)
				set_z_index(1)

func move_back():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position", get_position(), originPos, 0.25,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func attack():
	get_parent().tower_attack(self)


func _on_Timer_timeout():
	attack()
	time_check = false
