shader_type spatial;

uniform sampler2D albedo : source_color;
uniform sampler2D heightmap;
uniform float heightRatio = 1.0;
uniform vec2 UVOffset = vec2(0.0, 0.0);
uniform vec3 size = vec3(8.0, 8.0, 8.0);

const float gridSize = 8.0;

varying vec3 world_position;


void vertex() {
	VERTEX.y += texture(heightmap, UV).r * heightRatio;
	UV = UV + UVOffset;
	//world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}


void fragment() {
	ALBEDO = texture(albedo, (UV + vec2(NODE_POSITION_WORLD.x / size.x, NODE_POSITION_WORLD.z / size.z)) * vec2(size.x / gridSize, size.z / gridSize)).rgb;
}