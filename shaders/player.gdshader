shader_type canvas_item;

uniform bool shooting = false;

void fragment() {
    vec4 tex_colour = texture(TEXTURE, UV);

	if (tex_colour.r != 1.0 && shooting) {
		tex_colour = vec4(145.0/255.0, 0, 217.0/255.0, tex_colour.a);
	}

	COLOR = tex_colour;
}