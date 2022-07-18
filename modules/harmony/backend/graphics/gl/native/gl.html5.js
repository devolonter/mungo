
function _glUtilNearestPOT(value) {
	--value;
    for (var i = 1; i < 32; i <<= 1) {
        value = value | value >> i;
    }
    return value + 1;
}

// Dodgy code to convert 'any' to i,f,iv,fv...
//
function _mkf( p ){
	if( typeof(p)=="boolean" ) return p?1.0:0.0;
	if( typeof(p)=="number" ) return p;
	return 0.0;
}

function _mki( p ){
	if( typeof(p)=="boolean" ) return p?1:0;
	if( typeof(p)=="number" ) return p|0;
	if( typeof(p)=="object" ) return p;
	return 0;
}

function _mkb( p ){
	if( typeof(p)=="boolean" ) return p;
	if( typeof(p)=="number" ) return p!=0;
	return false;
}

function _mkfv( p,params ){
	if( !params || !params.length ) return;
	if( (p instanceof Array) || (p instanceof Int32Array) || (p instanceof Float32Array) ){
		var n=Math.min( params.length,p.length );
		for( var i=0;i<n;++i ){
			params[i]=_mkf(p[i]);
		}
	}else{
		params[0]=_mkf(p);
	}
}

function _mkiv( p,params ){
	if( !params || !params.length ) return;
	if( (p instanceof Array) || (p instanceof Int32Array) || (p instanceof Float32Array) ){
		var n=Math.min( params.length,p.length );
		for( var i=0;i<n;++i ){
			params[i]=_mki(p[i]);
		}
	}else{
		params[0]=_mki(p);
	}
}

function _mkbv( p,params ){
	if( !params || !params.length ) return;
	if( (p instanceof Array) || (p instanceof Int32Array) || (p instanceof Float32Array) ){
		var n=Math.min( params.length,p.length );
		for( var i=0;i<n;++i ){
			params[i]=_mkb(p[i]);
		}
	}else{
		params[0]=_mkb(p);
	}
}

function _glBufferData( target,size,data,usage ){
	if( !data ){
		gl.bufferData( target,size,usage );
	}else if( size==data.length ){
		gl.bufferData( target,data.arrayBuffer,usage );
	}else{
		gl.bufferData( target, data.bytes.subarray(0, size),usage );
	}
}

function _glBufferData2( target,size,data,usage ){
	if( !data ){
		gl.bufferData( target,size,usage );
	}else if( size==data.length ){
		gl.bufferData( target,data,usage );
	}else{
		gl.bufferData( target, data.subarray(0, size),usage );
	}
}

function _glBufferSubData( target,offset,size,data ){
	if( size==data.length ){
		gl.bufferSubData( target,offset,data.arrayBuffer );
	}else{
		gl.bufferSubData( target,offset,data.bytes.subarray(0, size) );
	}
}

function _glBufferSubData2( target,offset,size,from,data ){
	if ( from==0 && size==data.length ) {
		gl.bufferSubData( target,offset,data.arrayBuffer );
	} else {
		gl.bufferSubData( target,offset,data.bytes.subarray(from, from + size) );
	}
}

function _glBufferSubData3( target,offset,size,data ) {
	if( size==data.length ){
		gl.bufferSubData( target,offset,data );
	} else {
		gl.bufferSubData( target,offset,data.subarray(0, size) );
	}
}

function _glBufferSubData4( target,offset,size,from,data ){
	if ( from==0 && size==data.length ) {
		gl.bufferSubData( target,offset,data );
	} else {
		gl.bufferSubData( target,offset,data.subarray(from, from + size) );
	}
}

function _glClearDepthf( depth ){
	gl.clearDepth( depth );
}

function _glDepthRange( zNear,zFar ){
	gl.depthRange( zNear,zFar );
}

function _glGetActiveAttrib( program,index,size,type,name ){
	var info=gl.getActiveAttrib( program,index );
	if( type && type.length ) type[0]=info.type;
	if( size && size.length ) size[0]=info.size;
	if( name && name.length ) name[0]=info.name;
}

function _glGetActiveUniform( program,index,size,type,name ){
	var info=gl.getActiveUniform( program,index );
	if( type && type.length ) type[0]=info.type;
	if( size && size.length ) size[0]=info.size;
	if( name && name.length ) name[0]=info.name;
}

function _glGetAttachedShaders( program, maxcount, count, shaders ){
	var t=gl.getAttachedShaders();
	if( count && count.length ) count[0]=t.length;
	if( shaders ){
		var n=t.length;
		if( maxcount<n ) n=maxcount;
		if( shaders.length<n ) n=shaders.length;
		for( var i=0;i<n;++i ) shaders[i]=t[i];
	}
}

function _glGetBooleanv( pname,params ){
	_mkbv( gl.getParameter( pname ),params );
}

function _glGetBufferParameteriv( target, pname, params ){
	_mkiv( gl.glGetBufferParameter( target,pname ),params );
}

function _glGetFloatv( pname,params ){
	_mkfv( gl.getParameter( pname ),params );
}

function _glGetFramebufferAttachmentParameteriv( target, attachment, pname, params ){
	_mkiv( gl.getFrameBufferAttachmentParameter( target,attachment,pname ),params );
}

function _glGetIntegerv( pname, params ){
	_mkiv( gl.getParameter( pname ),params );
}

function _glGetProgramiv( program, pname, params ){
	_mkiv( gl.getProgramParameter( program,pname ),params );
}

function _glGetRenderbufferParameteriv( target, pname, params ){
	_mkiv( gl.getRenderbufferParameter( target,pname ),params );
}

function _glGetShaderiv( shader, pname, params ){
	_mkiv( gl.getShaderParameter( shader,pname ),params );
}

function _glGetString( pname ){
	var p=gl.getParameter( pname );
	if( typeof(p)=="string" ) return p;
	return "";
}

function _glGetTexParameterfv( target, pname, params ){
	_mkfv( gl.getTexParameter( target,pname ),params );
}

function _glGetTexParameteriv( target, pname, params ){
	_mkiv( gl.getTexParameter( target,pname ),params );
}

function _glGetUniformfv( program, location, params ){
	_mkfv( gl.getUniform( program,location ),params );
}

function _glGetUniformiv( program, location, params ){
	_mkiv( gl.getUniform( program,location ),params );
}

function _glGetUniformLocation( program, name ){
	var l=gl.getUniformLocation( program,name );
	if( l ) return l;
	return -1;
}

function _glGetVertexAttribfv( index, pname, params ){
	_mkfv( gl.getVertexAttrib( index,pname ),params );
}

function _glGetVertexAttribiv( index, pname, params ){
	_mkiv( gl.getVertexAttrib( index,pname ),params );
}

function _glReadPixels( x,y,width,height,format,type,pixels ){
	if (pixels && !pixels.ubytes) pixels.ubytes = new Uint8Array(pixels.arrayBuffer);
	gl.readPixels( x,y,width,height,format,type,pixels.ubytes );
}

var _glReadPixelsBuffer = null;

function _glReadPixels2( x,y,width,height,format,type,pixels ){
	if (!_glReadPixelsBuffer || _glReadPixelsBuffer.byteLength < (width * height) << 2) {
		_glReadPixelsBuffer = new Uint8Array((width * height) << 2);
	}

	gl.readPixels( x,y,width,height,format,type,_glReadPixelsBuffer );

	for (var i = 0, j = 0, l = width * height, buffer = _glReadPixelsBuffer; i < l; i++, j+=4) {
		pixels[i] = (buffer[j] << 24) | (buffer[j + 1] << 16) | (buffer[j + 2] << 8) | buffer[j + 3];
	}
}

function _glReadPixels3( x,y,width,height,format,type,pixels,offset,pitch ){
	if (!_glReadPixelsBuffer || _glReadPixelsBuffer.byteLength < (width * height) << 2) {
		_glReadPixelsBuffer = new Uint8Array((width * height) << 2);
	}

	gl.readPixels( x,y,width,height,format,type,_glReadPixelsBuffer );

	for (var i = offset, j = 0, k = 0, l = offset + (pitch * height), buffer = _glReadPixelsBuffer; i < l; k++, j+=4) {
		if (k == width) k = 0, i += pitch;
		pixels[i + k] = (buffer[j] << 24) | (buffer[j + 1] << 16) | (buffer[j + 2] << 8) | buffer[j + 3];
	}
}

function _glReadPixels32( x,y,width,height,pixels ){
	if (!_glReadPixelsBuffer || _glReadPixelsBuffer.byteLength < (width * height) << 2) {
		_glReadPixelsBuffer = new Uint8Array((width * height) << 2);
	}

	gl.readPixels( x,y,width,height,gl.RGBA,gl.UNSIGNED_BYTE,_glReadPixelsBuffer );

	for (var i = 0, j = 0, l = width * height, buffer = _glReadPixelsBuffer; i < l; i++, j+=4) {
		pixels[i] = (buffer[j + 3] << 24) | (buffer[j] << 16) | (buffer[j + 1] << 8) | buffer[j + 2];
	}
}

function _glReadPixels322( x,y,width,height,pixels,offset,pitch ){
	if (!_glReadPixelsBuffer || _glReadPixelsBuffer.byteLength < (width * height) << 2) {
		_glReadPixelsBuffer = new Uint8Array((width * height) << 2);
	}

	gl.readPixels( x,y,width,height,gl.RGBA,gl.UNSIGNED_BYTE,_glReadPixelsBuffer );

	for (var i = offset, j = 0, k = 0, l = offset + (pitch * height), buffer = _glReadPixelsBuffer; i < l; k++, j+=4) {
		if (k == width) k = 0, i += pitch;
		pixels[i + k] = (buffer[j + 3] << 24) | (buffer[j] << 16) | (buffer[j + 1] << 8) | buffer[j + 2];
	}
}

function _glReadPixelsFlipped32( x,y,width,height,pixels ){
	if (!_glReadPixelsBuffer || _glReadPixelsBuffer.byteLength < (width * height) << 2) {
		_glReadPixelsBuffer = new Uint8Array((width * height) << 2);
	}

	gl.readPixels( x,y,width,height,gl.RGBA,gl.UNSIGNED_BYTE,_glReadPixelsBuffer );

	for (var i = (width * (height - 1)) - 1, j = 0, k = 0, buffer = _glReadPixelsBuffer; i >= 0; k++, j+=4) {
		if (k == width) k = 0, i -= width;
		pixels[i + k] = (buffer[j + 3] << 24) | (buffer[j] << 16) | (buffer[j + 1] << 8) | buffer[j + 2];
	}
}

function _glReadPixelsFlipped322( x,y,width,height,pixels,offset,pitch ){
	if (!_glReadPixelsBuffer || _glReadPixelsBuffer.byteLength < (width * height) << 2) {
		_glReadPixelsBuffer = new Uint8Array((width * height) << 2);
	}

	gl.readPixels( x,y,width,height,gl.RGBA,gl.UNSIGNED_BYTE,_glReadPixelsBuffer );

	for (var i = offset + (height - 1) * pitch - 1, j = 0, k = 0, buffer = _glReadPixelsBuffer; i >= offset; k++, j+=4) {
		if (k == width) k = 0, i -= pitch;
		pixels[i + k] = (buffer[j + 3] << 24) | (buffer[j] << 16) | (buffer[j + 1] << 8) | buffer[j + 2];
	}
}

function _glBindBuffer( target,buffer ){
	if( buffer ){
		gl.bindBuffer( target,buffer );
	}else{
		gl.bindBuffer( target,null );
	}
}

function _glBindFramebuffer( target,framebuffer ){
	if( framebuffer ){
		gl.bindFramebuffer( target,framebuffer );
	}else{
		gl.bindFramebuffer( target,null );
	}
}

function _glBindRenderbuffer( target,renderbuffer ){
	if( renderbuffer ){
		gl.bindRenderbuffer( target,renderbuffer );
	}else{
		gl.bindRenderbuffer( target,null );
	}
}

function _glBindTexture( target,tex ){
	if( tex ){
		gl.bindTexture( target,tex );
	}else{
		gl.bindTexture( target,null );
	}
}

function _glGenerateMipmap( target ){
	var tex=gl.getParameter( gl.TEXTURE_BINDING_2D );
	if( tex && tex._loading ){
		tex._genmipmap=true;
	}else{
		gl.generateMipmap( target );
	}
}

function _glTexImage2D( target,level,internalformat,width,height,border,format,type,pixels ){
	if (pixels && !pixels.ubytes) pixels.ubytes = new Uint8Array(pixels.arrayBuffer);
	gl.texImage2D( target,level,internalformat,width,height,border,format,type,pixels ? pixels.ubytes : null  );
}

function _glTexSubImage2D( target,level,xoffset,yoffset,width,height,format,type,pixels ){
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixels.ubytes) pixels.ubytes = new Uint8Array(pixels.arrayBuffer);
		pixels = pixels.ubytes;
	} else {
		if (!pixels.ushorts) pixels.ushorts = new Uint16Array(pixels.arrayBuffer, 0, pixels.length >> 1);
		pixels = pixels.ushorts;
	}

	gl.texSubImage2D( target,level,xoffset,yoffset,width,height,format,type, pixels );
}

function _glTexSubImage2D2( target,level,xoffset,yoffset,width,height,format,type,from,pixels ) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixels.ubytes) pixels.ubytes = new Uint8Array(pixels.arrayBuffer);
		pixels = pixels.ubytes;
	} else {
		if (!pixels.ushorts) pixels.ushorts = new Uint16Array(pixels.arrayBuffer, 0, pixels.length >> 1);
		from >>= 1;
		pixels = pixels.ushorts;
	}

	gl.texSubImage2D( target,level,xoffset,yoffset,width,height,format,type, pixels.subarray(from) );
}

function _glUniform1fv( location, count, v ){
	if( v.length==count ){
		gl.uniform1fv( location,v );
	}else{
		gl.uniform1fv( location,v.subarray(0,count) );
	}
}

function _glUniform1iv( location, count, v ){
	if( v.length==count ){
		gl.uniform1iv( location,v );
	}else{
		gl.uniform1iv( location,v.subarray(0,count) );
	}
}

function _glUniform2fv( location, count, v ){
	var n=count*2;
	if( v.length==n ){
		gl.uniform2fv( location,v );
	}else{
		gl.uniform2fv( location,v.subarray(0,n) );
	}
}

function _glUniform2iv( location, count, v ){
	var n=count*2;
	if( v.length==n ){
		gl.uniform2iv( location,v );
	}else{
		gl.uniform2iv( location,v.subarray(0,n) );
	}
}

function _glUniform3fv( location, count, v ){
	var n=count*3;
	if( v.length==n ){
		gl.uniform3fv( location,v );
	}else{
		gl.uniform3fv( location,v.subarray(0,n) );
	}
}

function _glUniform3iv( location, count, v ){
	var n=count*3;
	if( v.length==n ){
		gl.uniform3iv( location,v );
	}else{
		gl.uniform3iv( location,v.subarray(0,n) );
	}
}

function _glUniform4fv( location, count, v ){
	var n=count*4;
	if( v.length==n ){
		gl.uniform4fv( location,v );
	}else{
		gl.uniform4fv( location,v.subarray(0,n) );
	}
}

function _glUniform4iv( location, count, v ){
	var n=count*4;
	if( v.length==n ){
		gl.uniform4iv( location,v );
	}else{
		gl.uniform4iv( location,v.subarray(0,n) );
	}
}

function _glUniformMatrix2fv( location, count, transpose, value ){
	var n=count*4;
	if( value.length==n ){
		gl.uniformMatrix2fv( location,transpose,value );
	}else{
		gl.uniformMatrix2fv( location,transpose,value.subarray(0,n) );
	}
}

function _glUniformMatrix3fv( location, count, transpose, value ){
	var n=count*9;
	if( value.length==n ){
		gl.uniformMatrix3fv( location,transpose,value );
	}else{
		gl.uniformMatrix3fv( location,transpose,value.subarray(0,n) );
	}
}

function _glUniformMatrix4fv( location, count, transpose, value ){
	var n=count*16;
	if( value.length==n ){
		gl.uniformMatrix4fv( location,transpose,value );
	}else{
		gl.uniformMatrix4fv( location,transpose,value.subarray(0,n) );
	}
}

function _glUseProgram(program) {
	if (program !== 0) {
		gl.useProgram(program);
	} else {
		gl.useProgram(null);
	}
}

function _glTexUploadImage2D(path, textureId, pixmap, target, format, type, padded, listener, result) {
	var game = BBHtml5Game.Html5Game();
	var ty = game.GetMetaData( path,"type" );
	if( ty.indexOf( "image/" )!=0 ) {
		result[0] = result[1] = result[2] = result[3] = 0;
		if (listener) listener.handleEvent();
		return;
	}

	var width = result[0] = game.GetMetaData( path,"width" )|0;
	var height = result[1] = game.GetMetaData( path,"height" )|0;

	var realWidth = result[2] = width;
	var realHeight = result[3] = height;

	if (padded) {
		realWidth = result[2] = _glUtilNearestPOT(width);
		realHeight = result[3] = _glUtilNearestPOT(height);
	}

	if (pixmap) {
		//ugly hack :(
		var pixelSize = 4;

		if (type == gl.UNSIGNED_BYTE) {
			switch (format) {
				case gl.RGB:
					pixelSize = 3;
					break;
				case gl.LUMINANCE_ALPHA:
					pixelSize = 2;
					break;
				case gl.LUMINANCE:
				case gl.ALPHA:
					pixelSize = 1;
					break;
			}
		} else {
			pixelSize = 2;
		}

		pixmap._New(width*height*pixelSize);
	}

	var url = game.PathToUrl(path);
	var prevTexture = gl.getParameter(gl.TEXTURE_BINDING_2D);

	gl.bindTexture(target, textureId);
	gl.texImage2D(target, 0, format, realWidth, realHeight, 0, format, type, null);

	if (window['PRELOADER_CACHE'] && window['PRELOADER_CACHE']['IMAGES'][url]) {
		var bitmap = window['PRELOADER_CACHE']['IMAGES'][url];
		gl.texSubImage2D(target, 0, 0, 0, format, type, bitmap);

		if (pixmap) {
			_glBitmapToPixmap(bitmap, pixmap, format, type);
		}

		gl.bindTexture(target, prevTexture);
		if (listener) listener.handleEvent();
	} else {
		gl.bindTexture(target, prevTexture);

		var bitmap = new Image();
		bitmap.onload = function() {
			prevTexture = gl.getParameter(gl.TEXTURE_BINDING_2D);

			gl.bindTexture(target, textureId);
			gl.texSubImage2D(target, 0, 0, 0, format, type, bitmap);

			if (pixmap) {
				_glBitmapToPixmap(bitmap, pixmap, format, type);
			}

			gl.bindTexture(target, prevTexture);
			if (listener) listener.handleEvent();
		}

		bitmap.src = url;
	}
}

function _glBitmapToPixmap(bitmap, pixmap, format, type) {
	var canvas = document.createElement('canvas');
	canvas.width = bitmap.width;
	canvas.height = bitmap.height;

	var context = canvas.getContext('2d');
	context.drawImage(bitmap, 0, 0);
	var data = context.getImageData(0, 0, bitmap.width, bitmap.height).data;
	var pixmapData = null;

	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);
		pixmapData = pixmap.ubytes;

		if (format == gl.RGBA) {
			for (var i = 0, n = data.length; i < n; i += 4) {
				pixmapData[i] = data[i];
				pixmapData[i+1] = data[i+1];
				pixmapData[i+2] = data[i+2];
				pixmapData[i+3] = data[i+3];
			}
		} else if (format == gl.RGB) {
			for (var i = 0, j = 0, n = data.length; i < n; i += 4, j += 3) {
				pixmapData[j] = data[i];
				pixmapData[j+1] = data[i+1];
				pixmapData[j+2] = data[i+2];
			}
		} else if (format == gl.ALPHA) {
			for (var i = 0, j = 0, n = data.length; i < n; i += 4, j++) {
				pixmapData[j] = data[i+3];
			}
		} else if (format == gl.LUMINANCE_ALPHA) {
			for (var i = 0, j = 0, n = data.length; i < n; i += 4, j += 2) {
				pixmapData[j] = (((data[i] * 77) + (data[i+1] * 150) +  (29 * data[i])) >> 8);
				pixmapData[j+1] = data[i+3];
			}
		} else if (format == gl.LUMINANCE) {
			for (var i = 0, j = 0, n = data.length; i < n; i += 4, j++) {
				pixmapData[j] = (((data[i] * 77) + (data[i+1] * 150) +  (29 * data[i])) >> 8);
			}
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		pixmapData = pixmap.ushorts;

		if (type == gl.UNSIGNED_SHORT_4_4_4_4) {
			for (var i = 0, j = 0, n = data.length; i < n; i += 4, j++) {
				pixmapData[j] = ((data[i] * 15 / 255) << 12) | ((data[i+1] * 15 / 255) << 8) | ((data[i+2] * 15 / 255) << 4) | (data[i+3] * 15 / 255);
			}
		} else if (type == gl.UNSIGNED_SHORT_5_5_5_1) {
			for (var i = 0, j = 0, n = data.length; i < n; i += 4, j++) {
				pixmapData[j] = ((data[i] * 31 / 255) << 11) | ((data[i+1] * 31 / 255) << 6) | ((data[i+2] * 31 / 255) << 1) | (data[i+3] / 255);
			}
		} else if (type == gl.UNSIGNED_SHORT_5_6_5) {
			for (var i = 0, j = 0, n = data.length; i < n; i += 4, j++) {
				pixmapData[j] = ((data[i] * 31 / 255) << 11) | ((data[i+1] * 63 / 255) << 5) | (data[i+2] * 31 / 255);
			}
		}
	}
}

function _glPixmapSetPixel(color, pixmap, offset, format, type) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);

		if (format == gl.RGBA) {
			pixmap.ubytes[offset] = color >> 24;
			pixmap.ubytes[offset + 1] = color >> 16;
			pixmap.ubytes[offset + 2] = color >> 8;
			pixmap.ubytes[offset + 3] = color;

		} else if (format == gl.RGB) {
			pixmap.ubytes[offset] = color >> 16;
			pixmap.ubytes[offset + 1] = color >> 8;
			pixmap.ubytes[offset + 2] = color;

		} else if (format == gl.LUMINANCE_ALPHA) {
			pixmap.ubytes[offset] = color >> 8;
			pixmap.ubytes[offset + 1] = color;

		} else if (format == gl.ALPHA || format == gl.LUMINANCE) {
			pixmap.ubytes[offset] = color;
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		pixmap.ushorts[offset>>1] = color;
	}
}

function _glPixmapSetPixel32(color, pixmap, offset, format, type) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);

		if (format == gl.RGBA) {
			pixmap.ubytes[offset + 0] = color >> 16;
			pixmap.ubytes[offset + 1] = color >> 8;
			pixmap.ubytes[offset + 2] = color >> 0;
			pixmap.ubytes[offset + 3] = color >> 24;

		} else if (format == gl.RGB) {
			pixmap.ubytes[offset] = color >> 16;
			pixmap.ubytes[offset + 1] = color >> 8;
			pixmap.ubytes[offset + 2] = color;

		} else if (format == gl.ALPHA) {
			pixmap.ubytes[offset] = color >> 24;

		} else if (format == gl.LUMINANCE_ALPHA) {
			pixmap.ubytes[offset] = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
			pixmap.ubytes[offset + 1] = color >> 24;

		} else if (format == gl.LUMINANCE) {
			pixmap.ubytes[offset] = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		offset >>= 1;

		if (type == gl.UNSIGNED_SHORT_4_4_4_4) {
			pixmap.ushorts[offset] = (((color >> 16) & 15) << 12) | (((color >> 8) & 15) << 8) | ((color & 15) << 4) | ((color >> 24) & 15);
		} else if (type == gl.UNSIGNED_SHORT_5_5_5_1) {
			pixmap.ushorts[offset] = (((color >> 16) & 31) << 11) | (((color >> 8) & 31) << 6) | ((color & 31) << 1) | ((color >> 24) & 1);
		} else if (type == gl.UNSIGNED_SHORT_5_6_5) {
			pixmap.ushorts[offset] = (((color >> 16) & 31) << 11) | (((color >> 8) & 63) << 5) | (color & 31);
		}
	}
}

function _glPixmapSetPixels(pixels, srcOffset, pixmap, dstOffset, pitch, width, height, format, type) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);

		if (format == gl.RGBA) {
			pitch -= width << 2;
			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];

					pixmap.ubytes[dstOffset] = color >> 24;
					pixmap.ubytes[dstOffset + 1] = color >> 16;
					pixmap.ubytes[dstOffset + 2] = color >> 8;
					pixmap.ubytes[dstOffset + 3] = color;

					dstOffset += 4;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == gl.RGB) {
			pitch -= width * 3;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];

					pixmap.ubytes[dstOffset] = color >> 16;
					pixmap.ubytes[dstOffset + 1] = color >> 8;
					pixmap.ubytes[dstOffset + 2] = color;

					dstOffset += 3;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == gl.LUMINANCE_ALPHA) {
			pitch -= width << 1;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];

					pixmap.ubytes[dstOffset] = color >> 8;
					pixmap.ubytes[dstOffset + 1] = color;

					dstOffset += 2;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == gl.ALPHA || format == gl.LUMINANCE) {
			pitch -= width;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixmap.ubytes[dstOffset] = pixels[srcOffset];
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		dstOffset >>= 1;
		pitch = (pitch >> 1) - width;

		for (var py = 0; py < height; ++py) {
			for (var px = 0; px < width; ++px) {
				pixmap.ushorts[dstOffset] = pixels[srcOffset];
				dstOffset++;
				srcOffset++;
			}

			dstOffset += pitch;
		}
	}
}

function _glPixmapSetPixels32(pixels, srcOffset, pixmap, dstOffset, pitch, width, height, format, type) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);

		if (format == gl.RGBA) {
			pitch -= width << 2;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];

					pixmap.ubytes[dstOffset] = color >> 16;
					pixmap.ubytes[dstOffset + 1] = color >> 8;
					pixmap.ubytes[dstOffset + 2] = color;
					pixmap.ubytes[dstOffset + 3] = color >> 24;

					dstOffset += 4;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == gl.RGB) {
			pitch -= width * 3;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];

					pixmap.ubytes[dstOffset] = color >> 16;
					pixmap.ubytes[dstOffset + 1] = color >> 8;
					pixmap.ubytes[dstOffset + 2] = color;

					dstOffset += 3;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == gl.ALPHA) {
			pitch -= width;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixmap.ubytes[dstOffset] = pixels[srcOffset] >> 24;
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}

		} else if (format == gl.LUMINANCE_ALPHA) {
			pitch -= width << 1;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];

					pixmap.ubytes[dstOffset] = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
					pixmap.ubytes[dstOffset + 1] = color >> 24;

					dstOffset += 2;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == gl.LUMINANCE) {
			pitch -= width;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];
					pixmap.ubytes[dstOffset] = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		dstOffset >>= 1;
		pitch = (pitch >> 1) - width;

		if (type == gl.UNSIGNED_SHORT_4_4_4_4) {
			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];
					pixmap.ushorts[dstOffset] = (((color >> 16) & 15) << 12) | (((color >> 8) & 15) << 8) | ((color & 15) << 4) | ((color >> 24) & 15);
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (type == gl.UNSIGNED_SHORT_5_5_5_1) {
			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];
					pixmap.ushorts[dstOffset] = (((color >> 16) & 31) << 11) | (((color >> 8) & 31) << 6) | ((color & 31) << 1) | ((color >> 24) & 1);
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}

		} else if (type == gl.UNSIGNED_SHORT_5_6_5) {
			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixels[srcOffset];
					pixmap.ushorts[dstOffset] = (((color >> 16) & 31) << 11) | (((color >> 8) & 63) << 5) | (color & 31);
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		}
	}
}

function _glPixmapGetPixel(pixmap, offset, format, type) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);

		if (format == gl.RGBA) {
			return (pixmap.ubytes[offset] << 24) | (pixmap.ubytes[offset + 1] << 16) | (pixmap.ubytes[offset + 2] << 8) | pixmap.ubytes[offset + 3];

		} else if (format == gl.RGB) {
			return (pixmap.ubytes[offset] << 16) | (pixmap.ubytes[offset + 1] << 8) | pixmap.ubytes[offset + 2];

		} else if (format == gl.LUMINANCE_ALPHA) {
			return (pixmap.ubytes[offset] << 8) | pixmap.ubytes[offset + 1];

		} else if (format == gl.ALPHA || format == gl.LUMINANCE) {
			return pixmap.ubytes[offset];
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		return pixmap.ushorts[offset>>1];
	}
}

function _glPixmapGetPixel32(pixmap, offset, format, type) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);

		if (format == gl.RGBA) {
			return (pixmap.ubytes[offset + 3] << 24) | (pixmap.ubytes[offset] << 16) | (pixmap.ubytes[offset + 1] << 8) | pixmap.ubytes[offset + 2];

		} else if (format == gl.RGB) {
			return 0xFF000000 | (pixmap.ubytes[offset] << 16) | (pixmap.ubytes[offset + 1] << 8) | pixmap.ubytes[offset + 2];

		} else if (format == gl.ALPHA) {
			return (pixmap.ubytes[offset] << 24) | 0x000000;

		} else if (format == gl.LUMINANCE_ALPHA) {
			var color = pixmap.ubytes[offset];
			return (pixmap.ubytes[offset + 1] << 24) | (color << 16) | (color << 8) | color;

		} else if (format == gl.LUMINANCE) {
			var color = pixmap.ubytes[offset];
			return 0xFF000000 | (color << 16) | (color << 8) | color;
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		offset >>= 1;

		if (type == gl.UNSIGNED_SHORT_4_4_4_4) {
			var color = pixmap.ushorts[offset];
			return (((color & 0xF) << 4) << 24) | (((color & 0xF000) >> 8) << 16) | (((color & 0xF00) >> 4) << 8) | (color & 0xF0);

		} else if (type == gl.UNSIGNED_SHORT_5_5_5_1) {
			var color = pixmap.ushorts[offset];
			return ((((color & 0x1) << 1) * 255) << 24) | ((((color & 0x7C00) >> 10) << 3) << 16) | ((((color & 0x3E0) >> 5) << 3) << 8) | ((color & 0x1F) << 3);

		} else if (type == gl.UNSIGNED_SHORT_5_6_5) {
			var color = pixmap.ushorts[offset];
			return 0xFF000000 | ((((color & 0xF800) >> 11) << 3) << 16) | ((((color & 0x7E0) >> 5) << 2) << 8) | ((color & 0x1F) << 3);
		}
	}
}

function _glPixmapGetPixels(pixmap, srcOffset, pitch, width, height, format, type, pixels, dstOffset) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);

		if (format == gl.RGBA) {
			pitch -= width << 2;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixels[dstOffset] = (pixmap.ubytes[srcOffset] << 24) | (pixmap.ubytes[srcOffset + 1] << 16) | (pixmap.ubytes[srcOffset + 2] << 8) | pixmap.ubytes[srcOffset + 3];
					srcOffset += 4;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == gl.RGB) {
			pitch -= width * 3;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixels[dstOffset] = (pixmap.ubytes[srcOffset] << 16) | (pixmap.ubytes[srcOffset + 1] << 8) | pixmap.ubytes[srcOffset + 2];
					srcOffset += 3;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == gl.LUMINANCE_ALPHA) {
			pitch -= width << 1;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixels[dstOffset] = (pixmap.ubytes[srcOffset] << 8) | pixmap.ubytes[srcOffset + 1];
					srcOffset += 2;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == gl.ALPHA || format == gl.LUMINANCE) {
			pitch -= width;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixels[dstOffset] = pixmap.ubytes[srcOffset];
					srcOffset++;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		srcOffset >>= 1;
		pitch = (pitch >> 1) - width;

		for (var py = 0; py < height; ++py) {
			for (var px = 0; px < width; ++px) {
				pixels[dstOffset] = pixmap.ushorts[srcOffset];
				dstOffset++;
				srcOffset++;
			}

			dstOffset += pitch;
		}
	}
}

function _glPixmapGetPixels32(pixmap, srcOffset, pitch, width, height, format, type, pixels, dstOffset) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);

		if (format == gl.RGBA) {
			pitch -= width << 2;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixels[dstOffset] = (pixmap.ubytes[srcOffset + 3] << 24) | (pixmap.ubytes[srcOffset] << 16) | (pixmap.ubytes[srcOffset + 1] << 8) | pixmap.ubytes[srcOffset + 2];
					srcOffset += 4;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == gl.RGB) {
			pitch -= width * 3;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixels[dstOffset] =  0xFF000000 | (pixmap.ubytes[srcOffset] << 16) | (pixmap.ubytes[srcOffset + 1] << 8) | pixmap.ubytes[srcOffset + 2];
					srcOffset += 3;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == gl.ALPHA) {
			pitch -= width;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					pixels[dstOffset] = (pixmap.ubytes[srcOffset] << 24) | 0x000000;
					srcOffset++;
					dstOffset++;
				}

				srcOffset += pitch;
			}

		} else if (format == gl.LUMINANCE_ALPHA) {
			pitch -= width << 1;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixmap.ubytes[srcOffset];
					pixels[dstOffset] = (pixmap.ubytes[srcOffset + 1] << 24) | (color << 16) | (color << 8) | color;
					srcOffset += 2;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == gl.LUMINANCE) {
			pitch -= width;

			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixmap.ubytes[srcOffset];
					pixels[dstOffset] = 0xFF000000 | (color << 16) | (color << 8) | color;
					srcOffset++;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		srcOffset >>= 1;
		pitch = (pitch >> 1) - width;

		if (type == gl.UNSIGNED_SHORT_4_4_4_4) {
			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixmap.ushorts[srcOffset];
					pixels[dstOffset] = (((color & 0xF) << 4) << 24) | (((color & 0xF000) >> 8) << 16) | (((color & 0xF00) >> 4) << 8) | (color & 0xF0);
					dstOffset++;
					srcOffset++;
				}

				srcOffset += pitch;
			}

		} else if (type == gl.UNSIGNED_SHORT_5_5_5_1) {
			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixmap.ushorts[srcOffset];
					pixels[dstOffset] = ((((color & 0x1) << 1) * 255) << 24) | ((((color & 0x7C00) >> 10) << 3) << 16) | ((((color & 0x3E0) >> 5) << 3) << 8) | ((color & 0x1F) << 3);
					dstOffset++;
					srcOffset++;
				}

				srcOffset += pitch;
			}

		} else if (type == gl.UNSIGNED_SHORT_5_6_5) {
			for (var py = 0; py < height; ++py) {
				for (var px = 0; px < width; ++px) {
					var color = pixmap.ushorts[srcOffset];
					pixels[dstOffset] = 0xFF000000 | ((((color & 0xF800) >> 11) << 3) << 16) | ((((color & 0x7E0) >> 5) << 2) << 8) | ((color & 0x1F) << 3);
					dstOffset++;
					srcOffset++;
				}

				srcOffset += pitch;
			}
		}
	}
}

function _glPixmapClearPixels(pixmap, color, format, type) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);
		var l = pixmap.length - 1;

		if (format == gl.RGBA) {
			var r = color >> 24;
			var g = color >> 16;
			var b = color >> 8;
			var a = color;

			while(l > 2) {
				pixmap.ubytes[l] = a;
				pixmap.ubytes[l - 1] = b;
				pixmap.ubytes[l - 2] = g;
				pixmap.ubytes[l - 3] = r;
				l -= 4;
			}
		} else if (format == gl.RGB) {
			var r = color >> 16;
			var g = color >> 8;
			var b = color;

			while(l > 1) {
				pixmap.ubytes[l] = b;
				pixmap.ubytes[l - 1] = g;
				pixmap.ubytes[l - 2] = r;
				l -= 3;
			}

		} else if (format == gl.LUMINANCE_ALPHA) {
			var c = color >> 8;
			var a = color;

			while(l > 0) {
				pixmap.ubytes[l] = a;
				pixmap.ubytes[l - 1] = c;
				l -= 2;
			}

		} else if (format == gl.ALPHA || format == gl.LUMINANCE) {
			while(l) {
				pixmap.ubytes[l] = color;
				l--;
			}
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		var l = pixmap.ushorts.length;

		while (l--) {
			pixmap.ushorts[l] = color;
		}
	}
}

function _glPixmapClearPixels32(pixmap, color, format, type) {
	if (type == gl.UNSIGNED_BYTE) {
		if (!pixmap.ubytes) pixmap.ubytes = new Uint8Array(pixmap.arrayBuffer);
		var l = pixmap.length - 1;

		if (format == gl.RGBA) {
			var r = color >> 16;
			var g = color >> 8;
			var b = color >> 0;
			var a = color >> 24;

			while(l > 2) {
				pixmap.ubytes[l] = r;
				pixmap.ubytes[l - 1] = g;
				pixmap.ubytes[l - 2] = b;
				pixmap.ubytes[l - 3] = a;
				l -= 4;
			}
		} else if (format == gl.RGB) {
			var r = color >> 16;
			var g = color >> 8;
			var b = color >> 0;

			while(l > 1) {
				pixmap.ubytes[l] = b;
				pixmap.ubytes[l - 1] = g;
				pixmap.ubytes[l - 2] = r;
				l -= 3;
			}
		} else if (format == gl.ALPHA) {
			var a = color >> 24;

			while(l) {
				pixmap.ubytes[l] = a;
				l--;
			}
		} else if (format == gl.LUMINANCE_ALPHA) {
			var c = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
			var a = color >> 24;

			while(l > 0) {
				pixmap.ubytes[l] = a;
				pixmap.ubytes[l - 1] = c;
				l -= 2;
			}

		} else if (format == gl.LUMINANCE) {
			var c = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);

			while(l) {
				pixmap.ubytes[l] = c;
				l--;
			}
		}
	} else {
		if (!pixmap.ushorts) pixmap.ushorts = new Uint16Array(pixmap.arrayBuffer, 0, pixmap.length>>1);
		var l = pixmap.ushorts.length;

		if (type == gl.UNSIGNED_SHORT_4_4_4_4) {
			color = (((color >> 16) & 15) << 12) | (((color >> 8) & 15) << 8) | ((color & 15) << 4) | ((color >> 24) & 15);
		} else if (type == gl.UNSIGNED_SHORT_5_5_5_1) {
			color = (((color >> 16) & 31) << 11) | (((color >> 8) & 31) << 6) | ((color & 31) << 1) | ((color >> 24) & 1);
		} else if (type == gl.UNSIGNED_SHORT_5_6_5) {
			color = (((color >> 16) & 31) << 11) | (((color >> 8) & 63) << 5) | (color & 31);
		}

		while (l--) {
			pixmap.ushorts[l] = color;
		}
	}
}
