shader_type spatial;

uniform sampler2D albedo : source_color;
uniform sampler2D heightmap;
uniform float heightRatio = 1.0;
uniform vec2 textureUV = vec2(1.0, 1.0);
uniform vec2 UVOffset = vec2(0.0, 0.0);


void vertex() {
	VERTEX.y += texture(heightmap, UV).r * heightRatio;
	UV = UV + UVOffset;
}

void fragment() {
	ALBEDO = texture(albedo, UV * textureUV).rgb;
}