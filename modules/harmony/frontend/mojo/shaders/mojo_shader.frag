#ifdef GL_ES
precision lowp float;
#endif

#ifdef SURFACE_RENDERER
uniform sampler2D mojo_device_surface;
#endif

varying vec4 mojo_color;

#ifdef SURFACE_RENDERER
varying vec2 mojo_surface_uv;
#endif

${FILTERS}

${SHADER}

void main(void) {
#ifndef EMPTY_MAIN
#ifdef SURFACE_RENDERER
	gl_FragColor = texture2D(mojo_device_surface, mojo_surface_uv) * mojo_color;
#else
	gl_FragColor = mojo_color;
#endif
#endif

#ifdef CUSTOM_SHADER
	shader();
#endif

	${FILTERS()}
}
