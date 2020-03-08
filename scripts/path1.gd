extends Path2D

export (PackedScene) var Enemy



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for enemy in global.enemies:
		enemy.set_offset(enemy.get_offset() + 150 * delta + 150 * 1)
		enemy.next_position = enemy.position
		enemy.set_offset(enemy.get_offset() - 150 * 1)
		if enemy.position.x > 1200:
			global.enemies.erase(enemy)
			enemy.queue_free()
			

func init():
	var enemy = Enemy.instance()
	add_child(enemy)
	global.enemies.append(enemy)
