shader_type canvas_item;

uniform sampler2D view2tex_tex;

uniform vec2      brush_pos       = vec2(0.5, 0.5);
uniform vec2      brush_ppos      = vec2(0.5, 0.5);
uniform vec2      brush_size      = vec2(0.25, 0.25);
uniform float     brush_strength  = 0.5;
uniform float     pattern_scale   = 10.0;
uniform float     pattern_angle   = 0.0;
uniform float     pattern_alpha   = 0.0;
uniform float     pressure        = 1.0;

uniform vec3      mesh_aabb_position = vec3(-0.5);
uniform vec3      mesh_aabb_size = vec3(1.0);
uniform sampler2D mesh_inv_uv_tex;

// BEGIN_PATTERN
float brush_function(vec2 uv) {
	return clamp(max(0.0, 1.0-length(2.0*(uv-vec2(0.5)))) / 0.5, 0.0, 1.0);
}

vec4 pattern_function(vec2 uv) {
	return vec4(fract(10.0*uv.x+length(uv-vec2(0.5))*10.0), 0.0, 0.0, 1.0);
}
// END_PATTERN

vec4 pattern_color(vec2 uv) {
	mat2 texture_rotation = mat2(vec2(cos(pattern_angle), sin(pattern_angle)), vec2(-sin(pattern_angle), cos(pattern_angle)));
	return pattern_function(fract(uv));
}

void fragment() {
	vec2 b = brush_pos/brush_size;
	vec2 bv = (brush_ppos-brush_pos)/brush_size;
	vec2 p = UV/brush_size;
	float x = clamp(dot(p-b, bv)/dot(bv, bv), 0.0, 1.0);
	vec2 local_uv = p-(b+x*bv);
	float a = max(brush_function(0.5*local_uv+vec2(0.5)), pattern_alpha);
	vec4 uv = texture(view2tex_tex, UV);
	COLOR = pattern_color(uv.xy) * vec4(vec3(1.0), a*(0.5+0.5*uv.a));
}
