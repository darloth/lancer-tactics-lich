//shockwave.gdshader
shader_type spatial;
render_mode unshaded, blend_mix;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float distortion_intensity : hint_range(0.0, 1.0) = 0.1;
uniform float noise_influence : hint_range(0.0, 1.0) = 1.0;

uniform float shake_power : hint_range(0.0, 1.0) = 0.03;
uniform float shake_rate : hint_range(0.0, 1.0) = 0.2;
uniform float shake_speed : hint_range(0.0, 20.0) = 5.0;
uniform float shake_block_size : hint_range(1.0, 100.0) = 30.5;
uniform float shake_color_rate : hint_range(0.0, 1.0) = 0.01;

uniform bool fresnel_edge = false;
uniform float fresnel_amount : hint_range(0.0, 10.0) = 0.1;
uniform float fresnel_pow : hint_range(0.0, 10.0) = 0.1;

float randomvec2(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

float randomf(float seed) {
	return fract(sin(seed) * 12.9898);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 center_uv = uv - vec2(0.5);

	float dist = length(center_uv);
	vec2 distortion_dir = normalize(center_uv);

	float noise = 1.0 + (randomvec2(uv + (TIME * 0.00001)) * 2.0 - 1.0) * noise_influence;

	// Apply a constant distortion based on distance from center
	vec2 noise_offset = distortion_dir * distortion_intensity * dist * noise;

	vec4 distorted_color = texture(screen_texture, uv + noise_offset);
	
	float enable_shift = float(
		randomf(trunc(uv.y * shake_block_size) + TIME * shake_speed) < shake_rate
	);
	
	// horizontal offset
	vec2 uv_offset = vec2(
		(randomf(trunc(uv.y * shake_block_size) + TIME) - 0.5) * shake_power * enable_shift,
		0.0
	);

	// subtle sine wave drift for atm
	uv_offset.x += sin(TIME * 2.0 + uv.y * 10.0) * 0.002;

	// chromatic Aberration
	distorted_color.r = texture(screen_texture, uv + noise_offset + uv_offset + vec2(shake_color_rate, 0.0)).r;
	distorted_color.g = texture(screen_texture, uv + noise_offset + uv_offset).g;
	distorted_color.b = texture(screen_texture, uv + noise_offset + uv_offset + vec2(-shake_color_rate, 0.0)).b;
	
	float fresnel_alpha = clamp(pow(1.0 - fresnel(fresnel_amount, NORMAL, VIEW), fresnel_pow), 0.0, 1.0);
	if(fresnel_edge)
		distorted_color.a *= fresnel_alpha;
	
	ALBEDO = distorted_color.rgb;
	ALPHA = distorted_color.a;
}
