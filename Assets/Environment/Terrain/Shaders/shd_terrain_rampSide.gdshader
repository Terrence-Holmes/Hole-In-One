shader_type spatial;

uniform sampler2D albedo : source_color;
uniform bool zSide = true;
uniform bool positiveSide = true;
uniform bool UVFlip = false;
uniform vec2 UVOffset = vec2(0.0, 0.0);
uniform vec3 size = vec3(8.0, 8.0, 8.0);
uniform float rampHeight = 0.0;
uniform float rampOffset = 0.0;
uniform float print = 0.0;

const float gridSize = 8.0;


void vertex() {
	//Set vertex and UV positions
	/*
	switch (VERTEX_ID)
	{
		case 0:
			UV = vec2(VERTEX.z, VERTEX.y);
			break;
		case 1:
			UV = vec2(-4.0 * rampOffset, rampHeight);
			break;
		case 2:
			UV = vec2(VERTEX.z, VERTEX.y);
			break;
	}
	*/
	
	//vec2 uv = (zSide) ? vec2(VERTEX.x, VERTEX.y) : vec2(VERTEX.z, VERTEX.y);
	//UV = uv + UVOffset;
	NORMAL = (positiveSide) ? vec3(1.0, 0.0, 0.0) : vec3(-1.0, 0.0, 0.0);
}


void fragment() {
	//Get the UV flip
	float posAxis = (zSide) ? NODE_POSITION_WORLD.z : NODE_POSITION_WORLD.x;
	float xPos = (positiveSide) ? posAxis - 4.0 : posAxis + 4.0;
	float flip = (mod(abs(xPos), 8.0) > 4.0) ? 1.0 : -1.0;
	if (xPos < 0.0)
	{ flip *= -1.0; }
	//Calculate flips when position is divisible by 4
	if ( (xPos >= 0.0 && mod(xPos, 8.0) == 0.0)
	|| (xPos < 0.0 && mod(abs(xPos), 8.0) == 4.0) )
	{ flip *= -1.0; }
	//Flip again if divisble by 4 and on the negative axis
	if (!positiveSide && mod(xPos, 4.0) == 0.0)
	{ flip *= -1.0; }
	//Flip if on the x axis
	if (!zSide)
	{ flip *= -1.0; }
	
	
	//Sets the default y scale with the flip
	vec2 yScale = vec2(1.0, 0.5 * flip);
	//Scrolls UV against node position
	float posOrNeg = (positiveSide) ? -1.0 : 1.0;
	vec2 uvPlus = (!zSide) ? vec2((NODE_POSITION_WORLD.z * posOrNeg) / size.z, 0) : vec2((-NODE_POSITION_WORLD.x * posOrNeg) / size.x, 0);
	//Increases the y scale if ramp height is more than 4
	float yScaleMult = (rampHeight <= 4.0) ? 1.0 : 4.0 / rampHeight;
	//Set albedo
	ALBEDO = texture(albedo, ((UV / vec2(gridSize, 4.0)) * vec2(1.0, yScaleMult) + uvPlus) * yScale).rgb;
}