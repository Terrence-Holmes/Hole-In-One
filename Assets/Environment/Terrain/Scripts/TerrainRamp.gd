extends TerrainPiece

@export_category("Ramp")
@export var rampHeight : float = 1
@export var rampOffset : float = 1

@onready var meshContainer : Node3D = get_node("Meshes")
@onready var topMesh : MeshInstance3D = meshContainer.get_node("TopMesh")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
