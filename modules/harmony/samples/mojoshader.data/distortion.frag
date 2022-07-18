#ifdef SURFACE_RENDERER
uniform float uTime;
#endif

void shader(void) {
#ifdef SURFACE_RENDERER
	vec2 p = mojo_surface_uv;	
	p.x = p.x + sin(p.y*40.+uTime*5.)*0.02;
	gl_FragColor = texture2D(mojo_device_surface, p) * mojo_color;
#else
	gl_FragColor = mojo_color;
#endif
}