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
	if (((VERTEX_ID == 0 || VERTEX_ID == 1) && forward)
	|| ((VERTEX_ID == 2 || VERTEX_ID == 3) && !forward))
	{
		VERTEX.y += rampHeight;
		float offsetMult = (forward) ? 1.0 : -1.0;
		float offsetAdd = (forward) ? -8.0 : 0.0;
		VERTEX.z += offsetAdd + (((rampOffset * 4.0)  - 4.0) * -1.0);// * offsetMult;
	}
	
	float rampUVOffset = (forward) ? 0.5 : -0.5;
	UV = UV + UVOffset + vec2(0, rampUVOffset);
}

void fragment() {
	float rampUVMult = (forward) ? -1.0 : 1.0;
	float rampUVScale = ((rampOffset * rampUVMult) + 1.0) * 0.5;
	rampUVScale = clamp(rampUVScale, 0.1, 1.9);
	ALBEDO = texture(albedo, (UV + vec2(NODE_POSITION_WORLD.x / size.x, (NODE_POSITION_WORLD.z / size.z) / rampUVScale)) * vec2(size.x / gridSize, (size.z / gridSize) * rampUVScale) + vec2(0, 0.5)).rgb;
}