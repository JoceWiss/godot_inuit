extends Human

func _ready():
	#au début la cible est là ou se trouve le joueur
	super()
	cible = position
	print("mes pv =", pv_max)

	
	
func _input(event):
	#déplacements
	if event is  InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed : 
			cible = get_global_mouse_position()
			if event.double_click:
				vitesse_actuelle = vitesse_course

			else : 
				vitesse_actuelle = vitesse_marche
	#zoom dézoom à la molette
	var nouveau_zoom = camera.zoom
	if event.is_action_pressed("zoom_avant"):
		nouveau_zoom -=Vector2(0.01 , 0.01)
	if event.is_action_pressed("zoom_arriere"):
		nouveau_zoom +=Vector2(0.01 , 0.01)
	nouveau_zoom = nouveau_zoom.clamp(Vector2(0.1,0.1), Vector2(0.5,0.5))
	camera.zoom = nouveau_zoom
				
		
func _physics_process(delta: float) -> void:
	super(delta)
	
	#logique de déplacement
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if objet_a_ramasser == null :
			cible = get_global_mouse_position()
	if nav_agent.target_position != cible:
		nav_agent.target_position = cible
	
	#Pathfinding
	var distance_a_la_cible = global_position.distance_to(cible)
	if  distance_a_la_cible <= distance_interaction:
		velocity = Vector2.ZERO
		animation_player.play("idle")
		if objet_a_ramasser != null:
			finaliser_ramassage(objet_a_ramasser)
			objet_a_ramasser = null
	else:	
		if not nav_agent.is_navigation_finished():

			var prochaine_position = nav_agent.get_next_path_position()
			var direction = position.direction_to(prochaine_position)
			velocity = velocity.lerp(direction * vitesse_actuelle, 0.5)
			if global_position.distance_to(prochaine_position)>10 : 
				look_at(prochaine_position)
		else : 
			velocity = Vector2.ZERO
			animation_player.play("idle")
		
	
	move_and_slide()
	
		
#déplacement pour ramassage d'objet	
func aller_ramasser(objet):
	objet_a_ramasser= objet
	cible = objet.global_position 
func finaliser_ramassage(objet):
	if objet_a_ramasser != null	:
		var distance = global_position.distance_to(objet_a_ramasser.global_position)
		if distance <= distance_interaction:
			print("objet ramassé !")
			objet_a_ramasser.queue_free()
			objet_a_ramasser = null

		
