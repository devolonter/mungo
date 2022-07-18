;
function gxtkWebGLGraphics() {
	var game = this.game = BBHtml5Game.Html5Game();
	var gl = this.gl = game.GetWebGL();
	this.canvas = game.GetCanvas();

	this.width = 0;
	this.height = 0;

	this.ix = 1;
	this.iy = 0;
	this.jx = 0;
	this.jy = 1;
	this.tx = 0;
	this.ty = 0;

	this.r = 255;
	this.g = 255;
	this.b = 255;
	this.a = 1;

	this.blend = 0;
	this.scissor = false;

	this.primitiveBatch = new gxtkWebGLPrimitiveBatch(gl, 512);
	this.spriteBatch = new gxtkWebGLSpriteBatch(gl, 512);

	this.polySpriteBatch = new gxtkWebGLPolySpriteBatch(gl, 128);
	this.polySpriteBatch.shader = this.spriteBatch.shader; //Kludge!

	this.currentBatch = null;

	this.readBuffer = null;

	this.InitRender(gl);
	document.addEventListener('bb::lostglcontext', this.HandleContextLost.bind(this));
}

gxtkWebGLGraphics.prototype.InitRender = function (gl) {
	gl.disable(gl.DEPTH_TEST);
	gl.disable(gl.CULL_FACE);

	gl.enable(gl.BLEND);
	gl.blendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA);

	gl.activeTexture(gl.TEXTURE0);
};

gxtkWebGLGraphics.prototype.HandleContextLost = function () {
	var gl = this.gl = this.game.GetWebGL();

	this.InitRender(gl);
	this.primitiveBatch.SetContext(gl);
	this.spriteBatch.SetContext(gl);
	this.polySpriteBatch.SetContext(gl);
	this.polySpriteBatch.shader = this.spriteBatch.shader; //Kludge!

	this.width = 0;
	this.height = 0;
	this.currentBatch = null;
};

gxtkWebGLGraphics.prototype.BeginRender = function () {
	var gl = this.gl;

	if (!gl) {
		return 0;
	}

	if (this.width !== this.canvas.width || this.height !== this.canvas.height) {
		var width = this.width = this.canvas.width;
		var height = this.height = this.canvas.height;

		var shader = this.primitiveBatch.shader;

		gl.useProgram(shader.program);
		gl.uniform2f(shader.uProjection, width / 2, height / 2);

		shader = this.spriteBatch.shader;

		gl.useProgram(shader.program);
		gl.uniform2f(shader.uProjection, width / 2, height / 2);

		gl.viewport(0, 0, width, height);
	}

	if (this.game.GetLoading()) {
		return 2;
	}

	return 1;
};

gxtkWebGLGraphics.prototype.EndRender = function () {
	if (this.currentBatch) {
		this.currentBatch.Flush();
	}
};

gxtkWebGLGraphics.prototype.Width = function () {
	return this.width;
};

gxtkWebGLGraphics.prototype.Height = function () {
	return this.height;
};

gxtkWebGLGraphics.prototype.LoadSurface = function (path) {
	var game = this.game;

	var ty = game.GetMetaData(path, 'type');
	if (ty.indexOf('image/') != 0) return null;

	var image = null;
	var url = game.PathToUrl(path);
	var fromCache = false;

	if (window['PRELOADER_CACHE'] && window['PRELOADER_CACHE']['IMAGES'][url]) {
		image = window['PRELOADER_CACHE']['IMAGES'][url];
		fromCache = true;
	} else {
		game.IncLoading();

		image = new Image();

		image.onload = function () {
			game.DecLoading();
		};

		image.onerror = function () {
			game.DecLoading();
		};
	}

	image.meta_width = game.GetMetaData(path, 'width') | 0;
	image.meta_height = game.GetMetaData(path, 'height') | 0;

	var surface = new gxtkSurface(image, this);
	if (!fromCache) image.src = url;

	return surface;
};

gxtkWebGLGraphics.prototype.CreateSurface = function (width, height) {
	var canvas = document.createElement('canvas');

	canvas.width = width;
	canvas.height = height;
	canvas.meta_width = width;
	canvas.meta_height = height;
	canvas.complete = true;

	var surface = new gxtkSurface(canvas, this);
	surface.gc = canvas.getContext('2d');

	return surface;
};

gxtkWebGLGraphics.prototype.SetAlpha = function (alpha) {
	this.a = alpha;
};

gxtkWebGLGraphics.prototype.SetColor = function (r, g, b) {
	this.r = r;
	this.g = g;
	this.b = b;
};

gxtkWebGLGraphics.prototype.SetBlend = function (blend) {
	if (this.blend !== blend) {
		if (this.currentBatch) {
			this.currentBatch.Flush();
		}

		var gl = this.gl;

		if (blend === 1) {
			gl.blendFunc(gl.SRC_ALPHA, gl.DST_ALPHA);
		} else {
			gl.blendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA);
		}

		this.blend = blend;
	}
};

gxtkWebGLGraphics.prototype.SetScissor = function (x, y, w, h) {
	if (this.currentBatch) {
		this.currentBatch.Flush();
	}

	var gl = this.gl;

	if (x !== 0 || y !== 0 || w !== this.width || h !== this.height) {
		if (!this.scissor) {
			gl.enable(gl.SCISSOR_TEST);
			this.scissor = true;
		}

		y = this.height - y - h;
		gl.scissor(x, y, w, h);

	} else {
		if (this.scissor) {
			gl.disable(gl.SCISSOR_TEST);
			this.scissor = false;
		}
	}
};

gxtkWebGLGraphics.prototype.SetMatrix = function (ix, iy, jx, jy, tx, ty) {
	this.ix = ix;
	this.iy = iy;
	this.jx = jx;
	this.jy = jy;
	this.tx = tx;
	this.ty = ty;
};

gxtkWebGLGraphics.prototype.Cls = function (r, g, b) {
	if (this.currentBatch) {
		//flush
		this.currentBatch.lastVertice = 0;
		this.currentBatch.lastIndex = 0;
	}

	var gl = this.gl;

	gl.clearColor(r / 255, g / 255, b / 255, 1);
	gl.clear(gl.COLOR_BUFFER_BIT);
};

gxtkWebGLGraphics.prototype.DrawPoint = function (x, y) {
	this.DrawRect(x, y, 1, 1);
};

gxtkWebGLGraphics.prototype.DrawRect = function (x, y, w, h) {
	var state = this.StartBatch(this.primitiveBatch, 4, 6);
	var v = state.vStart, vertices = state.vertices, size = state.vertSize;

	this.PushVerticesColor(vertices, size, 4, v, this.r, this.g, this.b, this.a);
	this.PushVerticesTransform(vertices, size, 4, v, this.ix, this.iy, this.jx, this.jy, this.tx, this.ty);
	this.PushVerticesPosition(vertices, size, v, x, y, x + w, y, x, y + h, x + w, y + h);

	this.PushIndices(state.indices, 6, 0, state.iStart, state.lastIndex);
};

gxtkWebGLGraphics.prototype.DrawLine = function (x1, y1, x2, y2) {
	x1+=0.5; y1+=0.5; x2+=0.5; y2+=0.5;

	var state = this.StartBatch(this.primitiveBatch, 4, 6);
	var v = state.vStart, vertices = state.vertices, size = state.vertSize;

	this.PushVerticesColor(vertices, size, 4, v, this.r, this.g, this.b, this.a);
	this.PushVerticesTransform(vertices, size, 4, v, this.ix, this.iy, this.jx, this.jy, this.tx, this.ty);
	
	var tx = -(y1 - y2);
	var ty = x1 - x2;
	
	var dist = Math.sqrt(tx*tx + ty*ty);
	tx /= dist;
	ty /= dist;
	tx *= 0.5;
	ty *= 0.5;
	
	this.PushVerticesPosition(vertices, size, v, x1 - tx, y1 - ty, x1 + tx, y1 + ty, x2 - tx, y2 - ty, x2 + tx, y2 + ty);
	this.PushIndices(state.indices, 6, 0, state.iStart, state.lastIndex);
};

gxtkWebGLGraphics.prototype.DrawOval = function (x, y, w, h) {
	var state = this.StartBatch(this.primitiveBatch, 82, 84);
	var v = state.vStart, vertices = state.vertices, size = state.vertSize, size2x = size * 2;

	this.PushVerticesColor(vertices, size, 82, v, this.r, this.g, this.b, this.a);
	this.PushVerticesTransform(vertices, size, 82, v, this.ix, this.iy, this.jx, this.jy, this.tx, this.ty);

	var seg = (Math.PI * 2) / 40;

	w /= 2;
	h /= 2;
	x += w;
	y += h;

	for (var i = 0; i < 41; i++) {
		this.PushVerticesPosition(vertices, size, v, x, y, x + Math.sin(seg * i) * w, y + Math.cos(seg * i) * h);
		v += size2x;
	}

	this.PushIndices(state.indices, 84, 1, state.iStart, state.lastIndex);
};

gxtkWebGLGraphics.prototype.DrawPoly = function (verts) {
	if (verts.length === 0) return;

	var verticesCount = verts.length / 2;
	var indicesCount = (verticesCount - 2) * 5;

	var state = this.StartBatch(this.primitiveBatch, verticesCount, indicesCount);
	var v = state.vStart, vertices = state.vertices, size = state.vertSize;

	this.PushVerticesColor(vertices, size, verticesCount, v, this.r, this.g, this.b, this.a);
	this.PushVerticesTransform(vertices, size, verticesCount, v, this.ix, this.iy, this.jx, this.jy, this.tx, this.ty);

	for (var j = 0; j < verticesCount; j++) {
		this.PushVerticesPosition(vertices, size, v, verts[j * 2], verts[j * 2 + 1]);
		v += size;
	}

	this.PushIndices(state.indices, indicesCount, 2, state.iStart, state.lastIndex);
};

gxtkWebGLGraphics.prototype.DrawPoly2 = function (verts, surface, srcx, srcy) {
	if (verts.length === 0) return;

	var verticesCount = verts.length / 4;
	var indicesCount = (verticesCount - 2) * 5;

	var state = this.StartBatch(this.polySpriteBatch, verticesCount, indicesCount, surface.glTexture);
	var v = state.vStart, vertices = state.vertices, size = state.vertSize;
	var w = surface.swidth, h = surface.sheight;

	this.PushVerticesColor(vertices, size, verticesCount, v, this.r, this.g, this.b, this.a);
	this.PushVerticesTransform(vertices, size, verticesCount, v, this.ix, this.iy, this.jx, this.jy, this.tx, this.ty);

	for (var j = 0; j < verticesCount; j++) {
		this.PushVerticesPosition(vertices, size, v, verts[j * 4], verts[j * 4 + 1]);
		this.PushVerticesTextureCoord(vertices, size, v, (srcx + verts[j * 4 + 2]) / w, (srcy + verts[j * 4 + 3]) / h);
		v += size;
	}

	this.PushIndices(state.indices, indicesCount, 2, state.iStart, state.lastIndex);
};

gxtkWebGLGraphics.prototype.DrawSurface = function (surface, x, y) {
	var state = this.StartBatch(this.spriteBatch, 4, 6, surface.glTexture);
	var v = state.vStart, vertices = state.vertices, size = state.vertSize;
	var w = surface.swidth, h = surface.sheight;

	this.PushVerticesColor(vertices, size, 4, v, this.r, this.g, this.b, this.a);
	this.PushVerticesTransform(vertices, size, 4, v, this.ix, this.iy, this.jx, this.jy, this.tx, this.ty);
	this.PushVerticesPosition(vertices, size, v, x, y, x + w, y, x, y + h, x + w, y + h);
	this.PushVerticesTextureCoord(vertices, size, v, 0, 0, 1, 0, 0, 1, 1, 1);
};

gxtkWebGLGraphics.prototype.DrawSurface2 = function (surface, x, y, srcx, srcy, srcw, srch) {
	var state = this.StartBatch(this.spriteBatch, 4, 6, surface.glTexture);
	var v = state.vStart, vertices = state.vertices, size = state.vertSize;
	var w = surface.swidth, h = surface.sheight;
	var u0 = srcx / w, v0 = srcy / h, u1 = (srcx + srcw) / w, v1 = (srcy + srch) / h;

	this.PushVerticesColor(vertices, size, 4, v, this.r, this.g, this.b, this.a);
	this.PushVerticesTransform(vertices, size, 4, v, this.ix, this.iy, this.jx, this.jy, this.tx, this.ty);
	this.PushVerticesPosition(vertices, size, v, x, y, x + srcw, y, x, y + srch, x + srcw, y + srch);
	this.PushVerticesTextureCoord(vertices, size, v, u0, v0, u1, v0, u0, v1, u1, v1);
};

gxtkWebGLGraphics.prototype.ReadPixels = function (pixels, x, y, width, height, offset, pitch) {
	if (this.currentBatch) {
		this.currentBatch.Flush();
	}
	
	var data = this.readBuffer;

	if (!data || data.length < width * height * 4) {
		data = this.readBuffer = new Uint8Array(width * height * 4);
	}

	var gl = this.gl;
	gl.readPixels(x, this.height - y - height, width, height, gl.RGBA, gl.UNSIGNED_BYTE, data);

	var i = 0;
	for (var py = height - 1; py >= 0; --py) {
		var j = offset + py * pitch;
		for (var px = 0; px < width; ++px) {
			pixels[j++] = (data[i + 3] << 24) | (data[i] << 16) | (data[i + 1] << 8) | data[i + 2];
			i += 4;
		}
	}
};

gxtkWebGLGraphics.prototype.WritePixels2 = function (surface, pixels, x, y, width, height, offset, pitch) {
	var imgData = surface.gc.createImageData(width, height);

	var p = imgData.data, i = 0, j = offset, px, py, argb;

	for (py = 0; py < height; ++py) {
		for (px = 0; px < width; ++px) {
			argb = pixels[j++];
			p[i] = (argb >> 16) & 0xff;
			p[i + 1] = (argb >> 8) & 0xff;
			p[i + 2] = argb & 0xff;
			p[i + 3] = (argb >> 24) & 0xff;
			i += 4;
		}

		j += pitch - width;
	}

	surface.gc.putImageData(imgData, x, y);
	surface.UpdateGLTexture();
};

gxtkWebGLGraphics.prototype.StartBatch = function (batch, vCount, iCount, glTexture) {
	var b = this.currentBatch;

	if (b !== batch) {
		if (b) {
			b.End();
		}

		batch.Begin();
		b = this.currentBatch = batch;
	}

	return b.Add(vCount, iCount, glTexture);
};

gxtkWebGLGraphics.prototype.PushIndices = function (indices, count, type, start, initValue) {
	if (type === 0) {
		for (var i = 0; i < count; i += 6) {
			indices[start++] = initValue;
			indices[start++] = initValue;
			indices[start++] = initValue + 1;
			indices[start++] = initValue + 2;
			indices[start++] = initValue + 3;
			indices[start] = initValue + 3;

			initValue = indices[start++] + 1;
		}

	} else if (type === 1) {
		indices[start++] = initValue;

		for (var i = 1; i < count - 1; i++) {
			indices[start++] = initValue++;
		}

		indices[start] = initValue - 1;

	} else if (type === 2) {
		for (var i = 0, j = initValue; i < count; i += 5) {
			indices[start++] = j;
			indices[start++] = j;
			indices[start++] = initValue + 1;
			indices[start++] = initValue + 2;
			indices[start++] = initValue + 2;

			initValue++;
		}
	}
};

gxtkWebGLGraphics.prototype.PushVerticesColor = function (vertices, size, count, offset, r, g, b, a) {
	size -= 6;

	for (var i = 0; i < count; i++) {
		offset += 2;
		vertices[offset++] = r;
		vertices[offset++] = g;
		vertices[offset++] = b;
		vertices[offset++] = a;
		offset += size;
	}
};

gxtkWebGLGraphics.prototype.PushVerticesTransform = function (vertices, size, count, offset, ix, iy, jx, jy, tx, ty) {
	size -= 12;

	for (var i = 0; i < count; i++) {
		offset += 6;
		vertices[offset++] = ix;
		vertices[offset++] = iy;
		vertices[offset++] = jx;
		vertices[offset++] = jy;
		vertices[offset++] = tx;
		vertices[offset++] = ty;
		offset += size;
	}
};

gxtkWebGLGraphics.prototype.PushVerticesPosition = function () {
	var vertices = arguments[0], size = arguments[1] - 2, offset = arguments[2];

	for (var i = 3, l = arguments.length; i < l; i += 2) {
		vertices[offset++] = arguments[i];
		vertices[offset++] = arguments[i + 1];
		offset += size;
	}
};

gxtkWebGLGraphics.prototype.PushVerticesTextureCoord = function () {
	var vertices = arguments[0], size = arguments[1] - 2, offset = arguments[2];

	for (var i = 3, l = arguments.length; i < l; i += 2) {
		offset += size;
		vertices[offset++] = arguments[i];
		vertices[offset++] = arguments[i + 1];
	}
};

gxtkWebGLGraphics.GetFragmentShaderSource = function (primitive) {
	var src = [
		'precision lowp float;',
		'varying vec4 vColor;'
	];

	if (!primitive) {
		src.push(
			'varying vec2 vTextureCoord;',
			'uniform sampler2D uSampler;'
		);
	}

	src.push('void main(void) {');

	if (!primitive) {
		src.push('gl_FragColor = texture2D(uSampler, vTextureCoord) * vColor;');
	} else {
		src.push('gl_FragColor = vColor;');
	}

	src.push('}');

	return src;
};

gxtkWebGLGraphics.GetVertexShaderSource = function (primitive) {
	var src = [
		'attribute vec2 aVertexPosition;',
		'attribute vec4 aVertexColor;',
		'attribute vec4 aVertexTransform;',
		'attribute vec2 aVertexTranslate;'
	];

	if (!primitive) {
		src.push('attribute vec2 aTextureCoord;');
	}

	src.push(
		'uniform vec2 uProjection;'
	);

	src.push('varying vec4 vColor;');

	if (!primitive) {
		src.push('varying vec2 vTextureCoord;');
	}

	src.push(
		'void main(void) {',
		'vec3 v = mat3(aVertexTransform.xy, 0, aVertexTransform.zw, 0, aVertexTranslate, 1) * vec3(aVertexPosition , 1.0);',
		'gl_Position = vec4(v.x / uProjection.x - 1.0, v.y / -uProjection.y + 1.0, 0.0, 1.0);',
		'vColor = vec4((aVertexColor.rgb / 255.0) * aVertexColor.a, aVertexColor.a);'
	);

	if (!primitive) {
		src.push('vTextureCoord = aTextureCoord;');
	}

	src.push('}');

	return src;
};

//because it will overridden
var _gxtkSurface = gxtkSurface;

function gxtkWebGLSurface(image, graphics) {
	_gxtkSurface.call(this, image, graphics);

	this.swidth = image.meta_width;
	this.sheight = image.meta_height;

	this.gl = null;
	this.glTexture = null;

	if (image.complete && image.width !== 0 && image.height !== 0) {
		this.CreateGLTexture();
	} else {
		var onload = image.onload;
		var that = this;

		image.onload = function() {
			that.CreateGLTexture();
			if (onload) onload();
		}
	}

	document.addEventListener('bb::lostglcontext', this.CreateGLTexture.bind(this));
}

gxtkWebGLSurface.prototype = extend_class(_gxtkSurface);

gxtkWebGLSurface.prototype.Discard = function () {
	this.gl.deleteTexture(this.glTexture);
	this.image = null;
};

gxtkWebGLSurface.prototype.CreateGLTexture = function () {
	this.gl = this.graphics.gl;
	this.swidth = this.image.width;
	this.sheight = this.image.height;

	this.glTexture = this.gl.createTexture();
	this.UpdateGLTexture();
};

gxtkWebGLSurface.prototype.UpdateGLTexture = function () {
	var linear = (typeof CFG_MOJO_IMAGE_FILTERING_ENABLED === "undefined" || CFG_MOJO_IMAGE_FILTERING_ENABLED == "1");
	var gl = this.gl;

	gl.bindTexture(gl.TEXTURE_2D, this.glTexture);
	gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);

	gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, this.image);

	gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, linear ? gl.LINEAR : gl.NEAREST);
	gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, linear ? gl.LINEAR : gl.NEAREST);

	gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
	gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

	gl.bindTexture(gl.TEXTURE_2D, null);
};

function gxtkWebGLPrimitiveShader(fragment, vertex) {
	this.fragment = fragment;
	this.vertex = vertex;
	this.program = null;

	this.aVertexPosition = null;
	this.aVertexColor = null;

	this.aVertexTransform = null;
	this.aVertexTranslate = null;

	this.uProjection = null;
}

gxtkWebGLPrimitiveShader.prototype.Compile = function (gl) {
	var program = gl.createProgram();

	gl.attachShader(program, this._CompileShader(gl, this.fragment, gl.FRAGMENT_SHADER));
	gl.attachShader(program, this._CompileShader(gl, this.vertex, gl.VERTEX_SHADER));

	gl.linkProgram(program);

	if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
		error('Can\'t link shader program');
	}

	this.aVertexPosition = gl.getAttribLocation(program, 'aVertexPosition');
	this.aVertexColor = gl.getAttribLocation(program, 'aVertexColor');
	this.aVertexTransform = gl.getAttribLocation(program, 'aVertexTransform');
	this.aVertexTranslate = gl.getAttribLocation(program, 'aVertexTranslate');

	this.uProjection = gl.getUniformLocation(program, 'uProjection');

	this.program = program;
};

gxtkWebGLPrimitiveShader.prototype._CompileShader = function (gl, src, type) {
	var shader = gl.createShader(type);

	gl.shaderSource(shader, src.join('\n'));
	gl.compileShader(shader);

	if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
		console.log("invalid shader : " + gl.getShaderInfoLog(shader));
		error('Can\'t compile shader program');
	}

	return shader;
};

function gxtkWebGLSpriteShader(fragment, vertex) {
	gxtkWebGLPrimitiveShader.call(this, fragment, vertex);

	this.aTextureCoord = null;
	this.uSampler = null;
}

gxtkWebGLSpriteShader.prototype = extend_class(gxtkWebGLPrimitiveShader);

gxtkWebGLSpriteShader.prototype.Compile = function (gl) {
	gxtkWebGLPrimitiveShader.prototype.Compile.call(this, gl);

	this.aTextureCoord = gl.getAttribLocation(this.program, 'aTextureCoord');
	this.uSampler = gl.getUniformLocation(this.program, 'uSampler');
};

function gxtkWebGLBatchState(vertices, indices, vertSize) {
	this.vStart = 0;
	this.iStart = 0;
	this.lastIndex = 0;
	this.vertSize = vertSize;
	this.vertices = vertices;
	this.indices = indices;
}

gxtkWebGLBatchState.prototype.SetTo = function (vert, index, lastIndex) {
	this.vStart = vert;
	this.iStart = index;
	this.lastIndex = lastIndex;
};

function gxtkWebGLBatch(vertSize, maxSize) {
	this.vertSize = vertSize;
	this.maxSize = maxSize;
	this.size = this.maxSize;

	if (!this.numVerts) {
		this.numVerts = this.size * 4 * this.vertSize;
	}

	if (!this.numIndices) {
		this.numIndices = this.maxSize * 6;
	}

	this.vertices = new Float32Array(this.numVerts);
	this.indices = new Uint16Array(this.numIndices);

	this.vertexBuffer = null;
	this.indexBuffer = null;

	this.gl = null;
	this.shader = null;

	this.lastIndex = 0;
	this.lastVertice = 0;
	this.state = new gxtkWebGLBatchState(this.vertices, this.indices, vertSize);
}

gxtkWebGLBatch.prototype.SetContext = function (gl) {
	this.gl = gl;

	if (this.shader) {
		this.shader.Compile(gl);
	}

	this.vertexBuffer = gl.createBuffer();
	this.indexBuffer = gl.createBuffer();
};

gxtkWebGLBatch.prototype.Add = function (vCount, iCount, glTexture) {
	var index = this.lastIndex, vertice = this.lastVertice, size = this.vertSize * vCount;

	if (vertice + size > this.numVerts || index + iCount > this.numIndices) {
		this.Flush();
		index = 0;
		vertice = 0;
	}

	this.state.SetTo(vertice, index, vertice / this.vertSize);
	this.lastVertice = vertice + size;
	this.lastIndex = index + iCount;

	return this.state;
};

gxtkWebGLBatch.prototype.Begin = function () {
	var gl = this.gl, shader = this.shader;

	gl.useProgram(shader.program);

	gl.enableVertexAttribArray(shader.aVertexPosition);
	gl.enableVertexAttribArray(shader.aVertexColor);
	gl.enableVertexAttribArray(shader.aVertexTransform);
	gl.enableVertexAttribArray(shader.aVertexTranslate);

	gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.indexBuffer);

	gl.vertexAttribPointer(shader.aVertexPosition, 2, gl.FLOAT, false, 4 * this.vertSize, 0);
	gl.vertexAttribPointer(shader.aVertexColor, 4, gl.FLOAT, false, 4 * this.vertSize, 2 * 4);
	gl.vertexAttribPointer(shader.aVertexTransform, 4, gl.FLOAT, false, 4 * this.vertSize, 6 * 4);
	gl.vertexAttribPointer(shader.aVertexTranslate, 2, gl.FLOAT, false, 4 * this.vertSize, 10 * 4);
};

gxtkWebGLBatch.prototype.End = function () {
	this.Flush();

	var gl = this.gl, shader = this.shader;

	gl.disableVertexAttribArray(shader.aVertexPosition);
	gl.disableVertexAttribArray(shader.aVertexColor);
	gl.disableVertexAttribArray(shader.aVertexTransform);
	gl.disableVertexAttribArray(shader.aVertexTranslate);
};

gxtkWebGLBatch.prototype.Flush = function () {
	this.lastIndex = 0;
	this.lastVertice = 0;
};

function gxtkWebGLPrimitiveBatch(gl, maxSize) {
	gxtkWebGLBatch.call(this, 12, maxSize);
	this.SetContext(gl);
}

gxtkWebGLPrimitiveBatch.prototype = extend_class(gxtkWebGLBatch);

gxtkWebGLPrimitiveBatch.prototype.SetContext = function (gl) {
	this.shader = new gxtkWebGLPrimitiveShader(
		gxtkWebGLGraphics.GetFragmentShaderSource(true),
		gxtkWebGLGraphics.GetVertexShaderSource(true)
	);

	gxtkWebGLBatch.prototype.SetContext.call(this, gl);

	gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, this.vertices, gl.DYNAMIC_DRAW);

	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
	gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, this.indices, gl.DYNAMIC_DRAW);
};

gxtkWebGLPrimitiveBatch.prototype.Flush = function () {
	if (this.lastIndex === 0) {
		return;
	}

	var gl = this.gl;

	if (this.lastVertice > this.numVerts * 0.5) {
		gl.bufferSubData(gl.ARRAY_BUFFER, 0, this.vertices);
		gl.bufferSubData(gl.ELEMENT_ARRAY_BUFFER, 0, this.indices);
	} else {
		gl.bufferSubData(gl.ARRAY_BUFFER, 0, this.vertices.subarray(0, this.lastVertice));
		gl.bufferSubData(gl.ELEMENT_ARRAY_BUFFER, 0, this.indices.subarray(0, this.lastIndex));
	}

	gl.drawElements(gl.TRIANGLE_STRIP, this.lastIndex, gl.UNSIGNED_SHORT, 0);

	gxtkWebGLBatch.prototype.Flush.call(this);
};

function gxtkWebGLTextureBatch() {
	this.glTexture = null;
	this.index = 0;
}

gxtkWebGLTextureBatch.prototype.setTo = function (glTexture, index) {
	this.glTexture = glTexture;
	this.index = index;
	return this;
};

function gxtkWebGLSpriteBatch(gl, maxSize) {
	gxtkWebGLBatch.call(this, 14, maxSize);

	this.glTextureStack = new gxtkWebGLUtils.Stack();
	this.glTexturePool = new gxtkWebGLUtils.Pool(gxtkWebGLTextureBatch);

	this.glTexture = null;

	this.drawMode = gl.TRIANGLES;
	this.SetContext(gl);
}

gxtkWebGLSpriteBatch.prototype = extend_class(gxtkWebGLBatch);
gxtkWebGLSpriteBatch.lastGLTexture = null;

gxtkWebGLSpriteBatch.prototype.SetContext = function (gl) {
	this.shader = new gxtkWebGLSpriteShader(
		gxtkWebGLGraphics.GetFragmentShaderSource(false),
		gxtkWebGLGraphics.GetVertexShaderSource(false)
	);

	var numIndices = this.numIndices, indices = this.indices;
	for (var i = 0, j = 0; i < numIndices; i += 6, j += 4) {
		//FIXME not sure that these values are correct!
		indices[i + 0] = j + 0;
		indices[i + 1] = j + 1;
		indices[i + 2] = j + 2;
		indices[i + 3] = j + 1;
		indices[i + 4] = j + 2;
		indices[i + 5] = j + 3;
	}

	gxtkWebGLBatch.prototype.SetContext.call(this, gl);

	gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, this.vertices, gl.DYNAMIC_DRAW);

	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
	gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, this.indices, gl.STATIC_DRAW);
};

gxtkWebGLSpriteBatch.prototype.Add = function (vCount, iCount, glTexture) {
	var state = gxtkWebGLBatch.prototype.Add.call(this, vCount, iCount, glTexture);

	if (this.glTexture !== glTexture) {
		this.glTextureStack.push(this.glTexturePool.allocate().setTo(glTexture, state.iStart));
		this.glTexture = glTexture;
	}

	return state;
};

gxtkWebGLSpriteBatch.prototype.Begin = function () {
	gxtkWebGLBatch.prototype.Begin.call(this);

	var gl = this.gl, shader = this.shader;

	gl.enableVertexAttribArray(shader.aTextureCoord);
	gl.vertexAttribPointer(shader.aTextureCoord, 2, gl.FLOAT, false, 4 * this.vertSize, 12 * 4);
};

gxtkWebGLSpriteBatch.prototype.End = function () {
	gxtkWebGLBatch.prototype.End.call(this);

	this.gl.disableVertexAttribArray(this.shader.aTextureCoord);
};

gxtkWebGLSpriteBatch.prototype.Flush = function () {
	if (this.lastIndex === 0) {
		return;
	}

	var gl = this.gl;

	if (this.lastVertice > this.numVerts * 0.5) {
		gl.bufferSubData(gl.ARRAY_BUFFER, 0, this.vertices);
	} else {
		gl.bufferSubData(gl.ARRAY_BUFFER, 0, this.vertices.subarray(0, this.lastVertice));
	}

	var mode = this.drawMode;

	if (this.glTextureStack.length > 1) {
		var stack = this.glTextureStack, children = stack.children, child = children[0], offset = 0, count = 0;

		if (gxtkWebGLSpriteBatch.lastGLTexture !== child.glTexture) {
			gl.bindTexture(gl.TEXTURE_2D, child.glTexture);
		}

		for (var i = 0, l = stack.length; i < l; i++) {
			child = children[i];

			if (i + 1 >= l) {
				count = this.lastIndex - child.index;
			} else {
				count = children[i + 1].index - child.index;
			}

			if (i > 0) {
				gl.bindTexture(gl.TEXTURE_2D, child.glTexture);
			}

			gl.drawElements(mode, count, gl.UNSIGNED_SHORT, offset * 2);

			offset += count;
		}

		gxtkWebGLSpriteBatch.lastGLTexture = child.glTexture;
	} else {
		if (gxtkWebGLSpriteBatch.lastGLTexture !== this.glTexture) {
			gl.bindTexture(gl.TEXTURE_2D, this.glTexture);
			gxtkWebGLSpriteBatch.lastGLTexture = this.glTexture;
		}

		gl.drawElements(mode, this.lastIndex, gl.UNSIGNED_SHORT, 0);
	}

	this.glTextureStack.clear();
	this.glTexturePool.free();
	this.glTexture = null;

	gxtkWebGLBatch.prototype.Flush.call(this);
};

function gxtkWebGLPolySpriteBatch(gl, maxSize) {
	this.numVerts = maxSize * 3 * 14;
	this.numIndices = ((maxSize * 3) - 2) * 5;

	gxtkWebGLSpriteBatch.call(this, gl, maxSize);
	this.drawMode = gl.TRIANGLE_STRIP;
}

gxtkWebGLPolySpriteBatch.prototype = extend_class(gxtkWebGLSpriteBatch);

gxtkWebGLPolySpriteBatch.prototype.SetContext = function (gl) {
	gxtkWebGLBatch.prototype.SetContext.call(this, gl);

	gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, this.vertices, gl.DYNAMIC_DRAW);

	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
	gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, this.indices, gl.DYNAMIC_DRAW);
};

gxtkWebGLPolySpriteBatch.prototype.Flush = function () {
	if (this.lastIndex === 0) {
		return;
	}

	var gl = this.gl;

	if (this.lastVertice > this.numVerts * 0.5) {
		gl.bufferSubData(gl.ELEMENT_ARRAY_BUFFER, 0, this.indices);
	} else {
		gl.bufferSubData(gl.ELEMENT_ARRAY_BUFFER, 0, this.indices.subarray(0, this.lastIndex));
	}

	gxtkWebGLSpriteBatch.prototype.Flush.call(this);
};

//utils
var gxtkWebGLUtils = {
	Pool: {},
	Stack: {}
};

gxtkWebGLUtils.Pool = function (clas, initialCapacity) {
	if (typeof initialCapacity === 'undefined') {
		initialCapacity = 10;
	}

	this.pool = [];
	this.template = clas;
	this.length = 0;

	for (var i = 0; i < initialCapacity; i++) {
		this.pool[this.length++] = new this.template();
	}
};

gxtkWebGLUtils.Pool.prototype.allocate = function () {
	var pool = this.pool;

	if (this.length === 0) {
		var result = new this.template();
		pool[pool.length] = result;
		return result;
	}

	return pool[--this.length];
};

gxtkWebGLUtils.Pool.prototype.free = function () {
	this.length = this.pool.length;
};

gxtkWebGLUtils.Stack = function () {
	this.children = [];
	this.length = 0;
};

gxtkWebGLUtils.Stack.prototype.push = function (element) {
	this.children[this.length++] = element;
};

gxtkWebGLUtils.Stack.prototype.pop = function () {
	if (this.length === 0) return null;
	return this.children[--this.length];
};

gxtkWebGLUtils.Stack.prototype.clear = function () {
	this.length = 0;
};

if (window.WebGLRenderingContext) {
	var c = document.createElement('canvas');

	if (!!(c.getContext('webgl') || c.getContext('experimental-webgl'))) {
		gxtkGraphics = gxtkWebGLGraphics;
		gxtkSurface = gxtkWebGLSurface;
	}
}
