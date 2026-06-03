extends CanvasLayer

# loading
# emit all particles once, to exclude freezing during gameplay

func _ready() -> void:
	self.show()
	await get_tree().process_frame  # wait for tree to be ready
	await _prewarm_particles(get_tree().root)
	var tim := Timer.new()
	self.add_child(tim)
	tim.one_shot = true
	tim.timeout.connect(queue_free)
	tim.start(2.0)

func _prewarm_particles(node: Node) -> void:
	if node is GPUParticles2D or node is GPUParticles3D:
		node.emitting = true
		await get_tree().process_frame
		node.restart()  # resets to unemitted state

	for child in node.get_children():
		_prewarm_particles(child)
