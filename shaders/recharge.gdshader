shader_type canvas_item;

uniform int charge = 5;
uniform bool ability = false;

void fragment() {
    vec4 tex_colour = texture(TEXTURE, UV);

	if (tex_colour.b == 1.0 && charge < 5 ||
		tex_colour.r < 0.5 && tex_colour.g == 1.0 && charge < 4 ||
		tex_colour.g == 1.0 && charge < 3 ||
		tex_colour.g > 0.0 && charge < 2 ||
		tex_colour.r != 0.0 && charge == 0
	) {
		tex_colour = vec4(0, 0, 0, 0);
	}

	tex_colour.a = ability ? 1.0 : 0.5;

	COLOR = tex_colour;
}