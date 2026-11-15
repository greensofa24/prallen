shader_type canvas_item;

void fragment() {
    vec4 tex_colour = texture(TEXTURE, UV);

	if (tex_colour.g != 1.0) {
		tex_colour.r = 0.0;
	}

	COLOR = tex_colour;
}