shader_type spatial;

uniform sampler2D albedo : source_color;
uniform sampler2D heightmap;
uniform float heightRatio = 1.0;
uniform vec2 textureUV = vec2(1.0, 1.0);
uniform vec2 UVOffset = vec2(0.0, 0.0);

varying vec3 world_position;
uniform vec3 worldPosition;


void vertex() {
	VERTEX.y += texture(heightmap, UV).r * heightRatio;
	//UV = UV + UVOffset;
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

const float gridSize = 3.5;

void fragment() {
	ALBEDO = texture(albedo, (UV + vec2(NODE_POSITION_WORLD.x / 16.0, NODE_POSITION_WORLD.z / 8.0)) * vec2(16.0 / 8.0, 8.0 / 8.0)).rgb;
}