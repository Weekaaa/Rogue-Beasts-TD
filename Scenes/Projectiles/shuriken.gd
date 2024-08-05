extends Area2D

var speed = 250
var direction = Vector2.UP
var damage: int 
var has_not_hit: bool = true

func _ready():
	damage = 5

func _process(delta):
	position += speed * direction * delta

func _on_body_entered(body):
	var target = body.get_parent()
	if "got_hit" in target and has_not_hit:
		has_not_hit = false
		target.got_hit(damage)
		$Hit.play()
		$Sprite2D.hide()
		speed = 0
		await $Hit.finished
		queue_free()
	#for polishing: hide and set velocity to zero, play audio and await audio finished
