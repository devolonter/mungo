#ifdef SURFACE_RENDERER
uniform mat3 u_mf_sprite_mask_matrix;

varying vec2 v_mf_sprite_mask;
#endif

void mf_sprite_mask(void) {
#ifdef SURFACE_RENDERER
	v_mf_sprite_mask = (u_mf_sprite_mask_matrix * vec3(mojo_surface_uv, 1.0)).xy;
#endif
}