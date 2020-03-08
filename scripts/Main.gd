extends Node2D

export (PackedScene) var Tower
export (PackedScene) var EndPos
export (PackedScene) var Bullet

var end_pos = []

# Called when the node enters the scene tree for the first time.
func _ready():
	global.enemies = []
	initTower()
	var end_pos_1 = $Position/EndPos1.position
	var end_pos_2 = $Position/EndPos2.position
	var end_pos_3 = $Position/EndPos3.position
	var end_pos_4 = $Position/EndPos4.position
	var end_pos_5 = $Position/EndPos5.position
	
	end_pos.append(end_pos_1)
	end_pos.append(end_pos_2)
	end_pos.append(end_pos_3)
	end_pos.append(end_pos_4)
	end_pos.append(end_pos_5)
	
	for pos in end_pos:
		var endpos = EndPos.instance()
		endpos.position = pos
		add_child(endpos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initTower():
	createTower(1)
	createTower(2)
	createTower(3)
	createTower(4)
	createTower(5)

func createTower(n):
	var tower
	match n:
		1:
			tower = Tower.instance()
			tower.position = $Position/StartPos1.position
		2:
			tower = Tower.instance()
			tower.position = $Position/StartPos2.position
		3:
			tower = Tower.instance()
			tower.position = $Position/StartPos3.position
		4:
			tower = Tower.instance()
			tower.position = $Position/StartPos4.position
		5:
			tower = Tower.instance()
			tower.position = $Position/StartPos5.position
	add_child(tower)

func move_tower(tower):
	var check = false
	for pos in end_pos:
		if tower.position.x > pos.x - 50 and tower.position.x < pos.x + 50 and tower.position.y > pos.y - 50 and tower.position.y < pos.y + 50:
			tower.position = pos
			tower.available = false
			check = true
			end_pos.erase(pos)
	if !check:
		tower.move_back()


func _on_Timer_timeout():
	randomize()
	var a = randi() % 2
	if a == 0:
		$path1.init()
	else:
		$path2.init()

func tower_attack(tower):
	if global.enemies:
		var bullet = Bullet.instance()
		bullet.position = tower.position
		add_child(bullet)
		var tween = get_node("Tween")
		tween.interpolate_property(bullet, "position", bullet.position, global.enemies[0].next_position, 0.6,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_callback(self, 0.6, "Call", bullet)
		tween.start()
		global.enemies[0].health -= 1

func _on_Play_pressed():
	$GUI/Play.visible = false
	$Timer.start()
	global.game_state = 1

func Call(bullet):
	bullet.queue_free()
	for enemy in global.enemies:
		if enemy.health <= 0:
			global.enemies.erase(enemy)
			enemy.queue_free()
