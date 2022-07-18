#ifdef GL_ES
precision lowp float;
#endif

varying vec2 vTextureCoord;

uniform sampler2D uSampler;
uniform float uTime;

void main(void) {
	vec2 p = vTextureCoord;	
	p.x = p.x + sin(p.y*40.+uTime*5.)*0.02;
	gl_FragColor = texture2D(uSampler, p);
}
