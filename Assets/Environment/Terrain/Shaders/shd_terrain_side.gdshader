shader_type spatial;

uniform sampler2D albedo : source_color;
uniform bool zSide = true;
uniform bool UVFlip = false;
uniform vec2 UVOffset = vec2(0.0, 0.0);
uniform vec3 size = vec3(8.0, 8.0, 8.0);

const float gridSize = 8.0;


void vertex() {
	UV = UV + UVOffset;
}


void fragment() {
	float flip = (UVFlip) ? -1.0 : 1.0;
	vec2 uvMult = (zSide) ? vec2(size.x / gridSize, 0.5 * flip) : vec2(size.z / gridSize, 0.5 * flip);
	vec2 uvPlus = (zSide) ? vec2(NODE_POSITION_WORLD.x / size.x, 0) : vec2(NODE_POSITION_WORLD.z / size.z, 0);
	ALBEDO = texture(albedo, (UV + uvPlus) * uvMult).rgb;
}