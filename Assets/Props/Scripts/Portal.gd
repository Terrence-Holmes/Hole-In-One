extends Node3D
class_name Portal

@export_category("Portal")
@export var portal1 : bool = true
@export var otherPortal : Portal = null
@export var size : Vector2 = Vector2(1, 2)
@export var portal_area_margin : Vector3 = Vector3(0.1, 0.1, 1.0)
@export var portalShader : Shader = null

#References
@onready var viewportContainer : Node = get_node("Viewports")
@onready var cameraViewContainer : Node3D = get_node("CameraViews")
@onready var passHitbox : Area3D = get_node("PassHitbox")
@onready var passHitbox_cs : CollisionShape3D = passHitbox.get_node("CollisionShape")
var viewports : Array[SubViewport]
var cameras : Array[Camera3D]
var cameraViews : Array[CSGBox3D]
var frame : PortalFrame = null

const recursiveCount : int = 5

var camRotation : Vector3 = Vector3.ZERO

var _active : bool = false
var active : bool:
	set(value):
		_active = value
#		visible = value
	get:
		return _active

#The main camera's relative position to this portal
var relativePosition : Vector3:
	get:
		if (GameManager.mainCamera == null):
			return Vector3.ZERO
		
		return GameManager.mainCamera.global_position - global_position


var relativeMatrix : Transform3D:
	get:
		return global_transform * otherPortal.global_transform * GameManager.mainCamera.global_transform


var trackedBodies = []
var moveTeleportThreshold : float = 2

#Mesh duplicate cache
#Supposedly helps with performance and makes the transition from portal to portal slightly smoother
var meshDuplicateCache = []
const MESH_DUPLICATE_RETAIN_TIME : float = 5000


func _ready():
	
	for i in range(recursiveCount):
		#Create viewports
		#var newViewport : SubViewport = get_node("Viewports/CameraViewport" + str(i))
		var newViewport : SubViewport = SubViewport.new()
		viewportContainer.add_child(newViewport)
		newViewport.owner = viewportContainer
		newViewport.name = "CameraViewport" + str(i)
		newViewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		newViewport.handle_input_locally = false
		viewports.append(newViewport)
		
		#Create cameras
		var newCamera : Camera3D = Camera3D.new()
		newViewport.add_child(newCamera)
		newCamera.name = "Camera"
		var portalMaskPlus : int = 0 if (portal1) else recursiveCount
		for j in range((recursiveCount * 2)):
			newCamera.set_cull_mask_value(j + 2, false)
		if (i > 0):
			newCamera.set_cull_mask_value(i + portalMaskPlus + 1, true)
		cameras.append(newCamera)
		
		#Create camera views
		var newView : CSGBox3D = CSGBox3D.new()
		cameraViewContainer.add_child(newView)
		newView.name = "CameraView" + str(i)
		
		#Create material
		var material : ShaderMaterial = ShaderMaterial.new()
		material.shader = portalShader.duplicate()
		material.resource_local_to_scene = true
		material.set_shader_parameter("texture_albedo", newViewport.get_texture())
		newView.material = material
		
		portalMaskPlus = 0 if (portal1) else recursiveCount
		newView.set_layer_mask_value(1, false)
		newView.set_layer_mask_value(i + portalMaskPlus + 2, true)
		newView.size = Vector3(size.x, size.y, 0.1)
		cameraViews.append(newView)

func _process(delta):
	
	passHitbox_cs.disabled = not visible
	_check_for_teleport()
	_setup_camera()


func _check_for_teleport():
	for body in _get_pass_through_bodies():
		_teleport_to_other(body)

func _setup_camera():
	var mainCamera : Camera3D = GameManager.mainCamera#get_viewport().get_camera_3d()
	if (not mainCamera):
		return
	
	
	_set_recursive_camera_transform(mainCamera)
	#_set_nonrecursive_camera_transform(mainCamera)
	
	for viewport in viewports:
		viewport.size = get_viewport().get_visible_rect().size
		viewport.msaa_3d = get_viewport().msaa_3d
		viewport.screen_space_aa = get_viewport().screen_space_aa
		viewport.use_taa = get_viewport().use_taa
		viewport.use_debanding = get_viewport().use_debanding
		viewport.use_occlusion_culling = get_viewport().use_occlusion_culling
		viewport.mesh_lod_threshold = get_viewport().mesh_lod_threshold
	
	for camera in cameras:
		camera.fov = mainCamera.fov #Match the main camera's FOV just in case I decide to change that later
		_update_portal_camera_near_clip_plane(camera)


func _set_nonrecursive_camera_transform(mainCamera : Camera3D):
	#Get relative transform of the main camera to this portal
	var relativeTransform : Transform3D = global_transform.affine_inverse() * mainCamera.global_transform
	var movedToOtherPortal : Transform3D = otherPortal.global_transform * relativeTransform
	#Set camera transform
	cameras[0].global_transform = movedToOtherPortal


var cameraTransforms = []
func _set_recursive_camera_transform(mainCamera : Camera3D):
	#Get transforms of each recursion
	cameraTransforms.clear()
	var currentTransform : Transform3D = mainCamera.global_transform
	for i in range(cameras.size()):
		#Get relative transform of the main camera to this portal
		var relativeTransform : Transform3D = global_transform.affine_inverse() * currentTransform
		currentTransform = otherPortal.global_transform * relativeTransform
		cameraTransforms.append(currentTransform)
	cameraTransforms.reverse()
	
	for i in range(cameraTransforms.size()):
		cameras[i].global_transform = cameraTransforms[i]
	#
	##Set portal camera's transform
	#camera.global_transform = cameraTransforms[recursionCounter]
	##Increase recursion
	#if (recursionCounter == MAX_RECURSIONS - 1):
		#recursionCounter = 0
	#else:
		#recursionCounter += 1

func _teleport_to_other(body : PhysicsBody3D):
	#Move body to the other portal
	var transformRelative : Transform3D = global_transform.affine_inverse() * body.global_transform
	var transformAtOtherPortal : Transform3D = otherPortal.global_transform * transformRelative
	body.global_transform = transformAtOtherPortal
	
	#Rotate the camera
	if (body.get("camRotation") != null):
		var angleDifference : float = otherPortal.global_rotation.y - global_rotation.y
		body.camRotation.y = body.camRotation.y + angleDifference
	
	#Translate the body's velocity
	var euler : Vector3 = otherPortal.global_transform.basis.get_euler() - global_transform.basis.get_euler()
	if (body is RigidBody3D):
		body.linear_velocity = body.linear_velocity \
			.rotated(Vector3(1, 0, 0), euler.x) \
			.rotated(Vector3(0, 1, 0), euler.y) \
			.rotated(Vector3(0, 0, 1), euler.z)
	elif (body is CharacterBody3D):
		body.velocity = body.velocity \
			.rotated(Vector3(1, 0, 0), euler.x) \
			.rotated(Vector3(0, 1, 0), euler.y) \
			.rotated(Vector3(0, 0, 1), euler.z)
		
		if (body.get("velocity_move") != null):
			body.velocity_move = body.velocity_move \
				.rotated(Vector3(1, 0, 0), euler.x) \
				.rotated(Vector3(0, 1, 0), euler.y) \
				.rotated(Vector3(0, 0, 1), euler.z)
	
	_remove_tracked_body(body)
	var newlyTrackedBody = otherPortal._add_tracked_body(body)


func _get_pass_through_bodies() -> Array:
	var passedThrough = []
	for body in trackedBodies:
		var posNode = body.camera if (body.camera) else body.body
		var distMoved = posNode.global_position - body.position_last_frame
		#Use dot product to check body changed which side of the portal it's on
		var forward : Vector3 = global_transform.basis.z #Get this portal's forward
		var offsetFromPortal : Vector3 = posNode.global_position - global_position #Get the object's position offset from this portal
		var prevOffsetFromPortal : Vector3 = body.position_last_frame - global_position #Get the object's last position offset
		var portalSide = _nonzero_sign(offsetFromPortal.dot(forward)) #Get which side of the portal the object is on
		var prevPortalSide = _nonzero_sign(prevOffsetFromPortal.dot(forward)) #Get the previous side that the object was on
		if (portalSide != prevPortalSide):# and distMoved.length() < moveTeleportThreshold):
			passedThrough.push_back(body.body)
		#Update previous position
		body.lastPosition = posNode.global_position
	return passedThrough


func _store_mesh_duplicate(body, meshDuplicate):
	meshDuplicateCache.push_back([body, meshDuplicate, Time.get_ticks_msec()])


func _get_tracked_body(body):
	for entry in trackedBodies:
		if entry.body == body:
			return entry
	return null

func _add_tracked_body(body):
	#Check if we already have the body stored
	var trackedBody = _get_tracked_body(body)
	if (trackedBody != null):
		return trackedBody
	
	#The body is not in the trackedBodies list; add it
	var newBody = {
		"body" : body,
		"position_last_frame" : body.global_position,
		"camera" : null, #find_by_class(body, "Camera3D") if use_body_camera_as_teleport_origin else null,
		"mesh_duplicator" : null,
		"track_start_time" : Time.get_ticks_msec()
	}
	
	trackedBodies.push_back(newBody)
	
	if (body.has_method("portal_tracking_enter")):
		body.portal_tracking_enter(self)

func _remove_tracked_body(body):
	for i in len(trackedBodies):
		if trackedBodies[i].body == body:
			
			if (trackedBodies[i].mesh_duplicator):
				remove_child(trackedBodies[i].mesh_duplicator)
				_store_mesh_duplicate(trackedBodies[i].body, trackedBodies[i].mesh_duplicator)
#			if (trackedBodies[i].camera):
#				trackedBodies[i].camera.near = trackedBodies[i].prevCameraNear
			trackedBodies.remove_at(i)
			
			if (body.has_method("portal_tracking_leave")):
				body.leave_portal_tracking(self)
			return

func _update_portal_camera_near_clip_plane(camera):
	if not camera.has_method("set_override_projection"):
		print("Needs https://github.com/V-Sekai/godot/tree/override_projection_4.2 branch")
		return # Needs https://github.com/V-Sekai/godot/tree/override_projection_4.2 branch
	
	const NEAR_CLIP_OFFSET = 0.05
	const NEAR_CLIP_LIMIT = 0.1
	
	# Calculate the near clip plane in camera space
	var clip_plane = otherPortal.global_transform
	var clip_plane_forward: Vector3 = -clip_plane.basis.z
	var portal_side = _nonzero_sign(clip_plane_forward.dot(otherPortal.global_transform.origin - camera.global_transform.origin))
 
	var cam_space_pos = camera.get_camera_transform().affine_inverse() * clip_plane.origin
	var cam_space_normal = (camera.get_camera_transform().affine_inverse().basis * clip_plane_forward) * portal_side
	var cam_space_dst = - cam_space_pos.dot(cam_space_normal) + NEAR_CLIP_OFFSET;
	
	# Oblique plane when very close to portal causes glitching/visual artifacts, so only enable if a small distance away
	if abs(cam_space_dst) > NEAR_CLIP_LIMIT:
		var proj : Projection = camera.get_camera_projection()
		var near_clip_plane = Plane(cam_space_normal, cam_space_dst)
		proj = set_projection_oblique_near_plane(proj, near_clip_plane)
		camera.set_override_projection(proj)
	else:
		# Set back to unmodified frustum if camera is very close to portal
		camera.set_override_projection(Projection(Vector4.ZERO, Vector4.ZERO, Vector4.ZERO, Vector4.ZERO))
	

# Copied from https://github.com/V-Sekai/avatar_vr_demo/blob/master/addons/V-Sekai.xr-mirror/mirror.gd
func set_projection_oblique_near_plane(matrix: Projection, clip_plane: Plane):
	# Based on the paper
	# Lengyel, Eric. “Oblique View Frustum Depth Projection and Clipping”.
	# Journal of Game Development, Vol. 1, No. 2 (2005), Charles River Media, pp. 5–16.

	# Calculate the clip-space corner point opposite the clipping plane
	# as (sgn(clipPlane.x), sgn(clipPlane.y), 1, 1) and
	# transform it into camera space by multiplying it
	# by the inverse of the projection matrix
	var q = Vector4(
		(sign(clip_plane.x) + matrix.z.x) / matrix.x.x,
		(sign(clip_plane.y) + matrix.z.y) / matrix.y.y,
		-1.0,
		(1.0 + matrix.z.z) / matrix.w.z)

	var clip_plane4 = Vector4(clip_plane.x, clip_plane.y, clip_plane.z, clip_plane.d)

	# Calculate the scaled plane vector
	var c: Vector4 = clip_plane4 * (2.0 / clip_plane4.dot(q))

	# Replace the third row of the projection matrix
	matrix.x.z = c.x - matrix.x.w
	matrix.y.z = c.y - matrix.y.w
	matrix.z.z = c.z - matrix.z.w
	matrix.w.z = c.w - matrix.w.w
	return matrix


func set_size(newSize : Vector2):
	size = newSize
	
	passHitbox_cs.shape.size = Vector3(
		size.x + portal_area_margin.x * 2,
		size.y + portal_area_margin.y * 2,
		portal_area_margin.z * 2)
	
	
	
	for i in range(cameraViewContainer.get_child_count()):
		cameraViewContainer.get_child(i).size = Vector3(size.x, size.y, cameraViewContainer.get_child(i).size.z)


#SIGNALS


func _body_entered(body):
	#Disable static bodies and CSGShape3Ds
	if (not body.is_class("StaticBody3D") and not body.is_class("CSGShape3D")):
		#if (_check_shapecast_collision(body)):
		_add_tracked_body(body)

func _body_exited(body):
	_remove_tracked_body(body)



#RETURNS

# Edge case but possible. Adding this to prevent teleporting twice if body lands exactly on portal plane
func _nonzero_sign(value):
	var s = sign(value)
	if s == 0:
		s = 1
	return s
