attribute vec2 aVertexPosition;
attribute vec2 aTextureCoord;

varying vec2 vTextureCoord;

uniform vec2 uProjection;

void main(void) {
	gl_Position = vec4(aVertexPosition.x / uProjection.x - 1.0, aVertexPosition.y / -uProjection.y + 1.0, 0.0, 1.0);
	vTextureCoord = aTextureCoord;
}