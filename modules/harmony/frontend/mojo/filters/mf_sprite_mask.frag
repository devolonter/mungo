#ifdef SURFACE_RENDERER
uniform float u_mf_sprite_mask_alpha;
uniform sampler2D u_mf_sprite_mask_sampler;

varying vec2 v_mf_sprite_mask;
#endif

void mf_sprite_mask(void) {
#ifdef SURFACE_RENDERER
	vec2 text = abs(v_mf_sprite_mask - 0.5);
    text = step(0.5, text);
    float clip = 1.0 - max(text.y, text.x);
	
	vec4 mask = texture2D(u_mf_sprite_mask_sampler, v_mf_sprite_mask);
	gl_FragColor *= (mask.r * mask.a * u_mf_sprite_mask_alpha * clip);
#endif
}