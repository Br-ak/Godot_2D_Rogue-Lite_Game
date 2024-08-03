shader_type canvas_item;

uniform float value : hint_range(0.0, 1.0);
//uniform vec2 blur_amount = vec2(0.005, 0.005);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 color_up = texture(TEXTURE, UV + vec2(0.0, value));
	vec4 color_down = texture(TEXTURE, UV + vec2(0.0, -value));
	vec4 color_left = texture(TEXTURE, UV + vec2(-value, 0.0));
	vec4 color_right = texture(TEXTURE, UV + vec2(value, 0.0));
	
	COLOR = (color_up + color_down + color_left + color_right) / 4.0;
}
