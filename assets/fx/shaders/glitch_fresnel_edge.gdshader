shader_type spatial;
render_mode unshaded, blend_mix;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Settings
uniform float shake_power : hint_range(0.0, 1.0) = 0.03;
uniform float shake_rate : hint_range(0.0, 1.0) = 0.2;
uniform float shake_speed : hint_range(0.0, 20.0) = 5.0;
uniform float shake_block_size : hint_range(1.0, 100.0) = 30.5;
uniform float shake_color_rate : hint_range(0.0, 1.0) = 0.01;
uniform float fresnel_amount : hint_range(0.0, 10.0) = 0.1;
uniform float fresnel_pow : hint_range(0.0, 10.0) = 0.1;

float random(float seed) {
	return fract(sin(seed) * 12.9898);
}

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment() {
	vec2 fixed_uv = SCREEN_UV;

	// glitch mask
	// floor the Y axis to create horizontal bands (blocks) for the glitch
	float enable_shift = float(
		random(trunc(fixed_uv.y * shake_block_size) + TIME * shake_speed) < shake_rate
	);

	// horizontal offset
	vec2 uv_offset = vec2(
		(random(trunc(fixed_uv.y * shake_block_size) + TIME) - 0.5) * shake_power * enable_shift,
		0.0
	);

	// subtle sine wave drift for atm
	uv_offset.x += sin(TIME * 2.0 + fixed_uv.y * 10.0) * 0.002;

	// chromatic Aberration
	vec3 col;
	col.r = texture(screen_texture, fixed_uv + uv_offset + vec2(shake_color_rate, 0.0)).r;
	col.g = texture(screen_texture, fixed_uv + uv_offset).g;
	col.b = texture(screen_texture, fixed_uv + uv_offset + vec2(-shake_color_rate, 0.0)).b;

	float alpha = clamp(pow(1.0 - fresnel(fresnel_amount, NORMAL, VIEW), fresnel_pow), 0.0, 1.0);

	ALBEDO = col;
	ALPHA = alpha;
}