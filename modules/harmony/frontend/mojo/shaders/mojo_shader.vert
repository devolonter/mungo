attribute vec2 mojo_device_position;
attribute vec4 mojo_device_transform;
attribute vec2 mojo_device_translate;

#ifdef SURFACE_RENDERER
attribute vec2 mojo_device_surface_uv;
#endif

attribute vec4 mojo_device_color;

uniform vec4 mojo_device_projection;

varying vec4 mojo_color;

#ifdef SURFACE_RENDERER
varying vec2 mojo_surface_uv;
#endif

${FILTERS}

${SHADER}

void main(void) {
#ifndef EMPTY_MAIN
	vec3 v = mat3(mojo_device_transform.xy, 0.0, mojo_device_transform.zw, 0.0, mojo_device_translate, 1.0) * vec3(mojo_device_position , 1.0);
	gl_Position = vec4(v.x / mojo_device_projection.x - mojo_device_projection.z, v.y / -mojo_device_projection.y + mojo_device_projection.w, 0.0, 1.0);
#endif

	mojo_color = mojo_device_color;
#ifdef SURFACE_RENDERER
	mojo_surface_uv = mojo_device_surface_uv;
#endif

#ifdef CUSTOM_SHADER
	shader();
#endif

	${FILTERS()}
}
