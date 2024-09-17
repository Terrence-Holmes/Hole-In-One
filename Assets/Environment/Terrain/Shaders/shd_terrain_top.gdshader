shader_type spatial;

uniform sampler2D albedo : source_color;
uniform vec2 UVOffset = vec2(0.0, 0.0);
uniform vec3 size = vec3(8.0, 8.0, 8.0);

const float gridSize = 8.0;


void vertex() {
	UV = UV + UVOffset;
}


void fragment() {
	ALBEDO = texture(albedo, (UV + vec2(NODE_POSITION_WORLD.x / size.x, NODE_POSITION_WORLD.z / size.z)) * vec2(size.x / gridSize, size.z / gridSize)).rgb;
}