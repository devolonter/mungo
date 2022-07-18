uniform float u_mf_invert;

void mf_invert(void) {
	gl_FragColor.rgb = mix( (vec3(1)-gl_FragColor.rgb) * gl_FragColor.a, gl_FragColor.rgb, 1.0 - u_mf_invert);
}