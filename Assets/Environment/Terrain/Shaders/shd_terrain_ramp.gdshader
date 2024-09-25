shader_type spatial;

uniform sampler2D albedo : source_color;
uniform float rampHeight = 0.0;
uniform float rampOffset = 0.0;
uniform vec2 UVScale = vec2(1.0, 1.0);
uniform vec2 UVOffset = vec2(0.0, 0.0);
uniform vec3 size = vec3(8.0, 8.0, 8.0);
uniform bool forward = true;

const float gridSize = 8.0;

void vertex() {
	float rampUVOffset = (forward) ? 0.5 : -0.5;
	UV = UV + UVOffset + vec2(0, rampUVOffset);
}

void fragment() {
	ALBEDO = texture(albedo, (UV + vec2(-NODE_POSITION_WORLD.x / size.x, NODE_POSITION_WORLD.z / size.z)) * vec2(size.x / gridSize, size.z / gridSize)).rgb;
}