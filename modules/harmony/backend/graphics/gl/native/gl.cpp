
int _glUtilNearestPOT(int value) {
	--value;
    for (int i = 1; i < 32; i <<= 1) {
        value = value | value >> i;
    }
    return value + 1;
}

unsigned char *_glUtilConvertImageFormat(unsigned char *data, int srcFormat, int destFormat, unsigned int x, unsigned int y) {
	int i,j;
	unsigned char *good;
	if (destFormat == srcFormat) return data;

	#define COMBO(a,b)  ((a)*8+(b))
	#define CASE(a,b)   case COMBO(a,b): for(i=x-1; i >= 0; --i, src += a, dest += (b > 0 ? b : 1))
	#define COMPUTE_Y(r, g, b) (int) (((r*77) + (g*150) +  (29*b)) >> 8)

	good = (unsigned char *) malloc((destFormat > 0 ? destFormat : 1) * x * y);
	if (good == NULL) {
		free(data);
		return NULL;
	}

	for (j=0; j < (int) y; ++j) {
		unsigned char *src  = data + j * x * srcFormat;
		unsigned char *dest = good + j * x * (destFormat > 0 ? destFormat : 1);

		switch (COMBO(srcFormat, destFormat)) {
			CASE(1,0) dest[0]=255; break;
			CASE(1,2) dest[0]=src[0], dest[1]=255; break;
			CASE(1,3) dest[0]=dest[1]=dest[2]=src[0]; break;
			CASE(1,4) dest[0]=dest[1]=dest[2]=src[0], dest[3]=255; break;
			CASE(2,0) dest[0]=src[1]; break;
			CASE(2,1) dest[0]=src[0]; break;
			CASE(2,3) dest[0]=dest[1]=dest[2]=src[0]; break;
			CASE(2,4) dest[0]=dest[1]=dest[2]=src[0], dest[3]=src[1]; break;
			CASE(3,0) dest[0]=255; break;
			CASE(3,4) dest[0]=src[0],dest[1]=src[1],dest[2]=src[2],dest[3]=255; break;
			CASE(3,1) dest[0]=COMPUTE_Y(src[0],src[1],src[2]); break;
			CASE(3,2) dest[0]=COMPUTE_Y(src[0],src[1],src[2]), dest[1] = 255; break;
			CASE(4,1) dest[0]=COMPUTE_Y(src[0],src[1],src[2]); break;
			CASE(4,2) dest[0]=COMPUTE_Y(src[0],src[1],src[2]), dest[1] = src[3]; break;
			CASE(4,3) dest[0]=src[0],dest[1]=src[1],dest[2]=src[2]; break;
			CASE(4,0) dest[0]=src[3]; break;
		}
	}

	#undef COMBO
	#undef CASE
	#undef COMPUTE_Y

	free(data);
	return good;
}

unsigned char *_glUtilConvertRGBA8888ToRGBA4444(unsigned char *data, unsigned int x, unsigned int y) {
	int i,j;
	unsigned short *good;

	good = (unsigned short *) malloc(2 * x * y);
	if (good == NULL) {
		free(data);
		return NULL;
	}

	for (j=0; j < (int) y; ++j) {
		unsigned char *src  = data + j * x * 4;
		unsigned short *dest = good + j * x;

		for(i = x - 1; i >= 0; --i, src += 4, dest++) {
			dest[0] = ((src[0] * 15 / 255) << 12) | ((src[1] * 15 / 255) << 8) | ((src[2] * 15 / 255) << 4) | (src[3] * 15 / 255);
		}
	}

	free(data);
	return (unsigned char *) good;
}

unsigned char *_glUtilConvertRGBA8888ToRGBA5551(unsigned char *data, unsigned int x, unsigned int y) {
	int i,j;
	unsigned short *good;

	good = (unsigned short *) malloc(2 * x * y);
	if (good == NULL) {
		free(data);
		return NULL;
	}

	for (j=0; j < (int) y; ++j) {
		unsigned char *src  = data + j * x * 4;
		unsigned short *dest = good + j * x;

		for(i = x - 1; i >= 0; --i, src += 4, dest++) {
			dest[0] = ((src[0] * 31 / 255) << 11) | ((src[1] * 31 / 255) << 6) | ((src[2] * 31 / 255) << 1) | (src[3] / 255);
		}
	}

	free(data);
	return (unsigned char *) good;
}

unsigned char *_glUtilConvertRGB888ToRGB565(unsigned char *data, unsigned int x, unsigned int y) {
	int i,j;
	unsigned short *good;

	good = (unsigned short *) malloc(2 * x * y);
	if (good == NULL) {
		free(data);
		return NULL;
	}

	for (j=0; j < (int) y; ++j) {
		unsigned char *src  = data + j * x * 3;
		unsigned short *dest = good + j * x;

		for(i = x - 1; i >= 0; --i, src += 3, dest++) {
			dest[0] = ((src[0] * 31 / 255) << 11) | ((src[1] * 63 / 255) << 5) | (src[2] * 31 / 255);
		}
	}

	free(data);
	return (unsigned char *) good;
}

void _glBindAttribLocation( int program, int index, String name ){
	glBindAttribLocation( program,(GLuint)index,name.ToCString<char>() );
}

void _glBufferData( int target,int size,BBDataBuffer *data,int usage ){
	glBufferData( target,size,data->ReadPointer(),usage );
}

void _glBufferData( int target,int size,Array<float> data,int usage ){
	glBufferData( target,size<<2,&data[0],usage );
}

void _glBufferSubData( int target,int offset,int size,BBDataBuffer *data ){
	glBufferSubData( target,offset,size,data->ReadPointer() );
}

void _glBufferSubData( int target,int offset,int size, int from, BBDataBuffer *data ){
	glBufferSubData( target,offset,size,data->ReadPointer(from) );
}

void _glBufferSubData( int target,int offset,int size, Array<float> data ){
	glBufferSubData( target,offset,size<<2,&data[0] );
}

void _glBufferSubData( int target,int offset,int size, int from, Array<float> data ){
	glBufferSubData( target,offset,size<<2,&data[from] );
}

int _glCreateBuffer(){
	GLuint buf;
	glGenBuffers( 1,&buf );
	return buf;
}

int _glCreateFramebuffer(){
	GLuint buf;
	glGenFramebuffers( 1,&buf );
	return buf;
}

int _glCreateRenderbuffer(){
	GLuint buf;
	glGenRenderbuffers( 1,&buf );
	return buf;
}

int _glCreateTexture(){
	GLuint buf;
	glGenTextures( 1,&buf );
	return buf;
}

void _glDeleteBuffer( int buffer ){
	glDeleteBuffers( 1,(GLuint*)&buffer );
}

void _glDeleteFramebuffer( int buffer ){
	glDeleteFramebuffers( 1,(GLuint*)&buffer );
}

void _glDeleteRenderbuffer( int buffer ){
	glDeleteRenderbuffers( 1,(GLuint*)&buffer );
}

void _glDeleteTexture( int texture ){
	glDeleteTextures( 1,(GLuint*)&texture );
}

void _glDrawElements( int mode, int count, int type, int offset ){
	glDrawElements( mode,count,type,(const GLvoid*)offset );
}

void _glGetActiveAttrib( int program, int index, Array<int> size,Array<int> type,Array<String> name ){
	int len=0,ty=0,sz=0;char nm[1024];
	glGetActiveAttrib( program,index,1024,&len,&sz,(GLenum*)&ty,nm );
	nm[1023]=0;
	if( size.Length() ) size[0]=sz;
	if( type.Length() ) type[0]=ty;
	if( name.Length() ) name[0]=String( nm );
}

void _glGetActiveUniform( int program, int index, Array<int> size,Array<int> type,Array<String> name ){
	int len=0,ty=0,sz=0;char nm[1024];
	glGetActiveUniform( program,index,1024,&len,&sz,(GLenum*)&ty,nm );
	nm[1023]=0;
	if( size.Length() ) size[0]=sz;
	if( type.Length() ) type[0]=ty;
	if( name.Length() ) name[0]=String( nm );
}

void _glGetAttachedShaders( int program, int maxcount, Array<int> count, Array<int> shaders ){
	int cnt=0,sh[32];
	glGetAttachedShaders( program,32,&cnt,(GLuint*)sh );
	if( count.Length() ) count[0]=cnt;
	if( shaders.Length() ){
		int n=cnt;
		if( maxcount<n ) n=maxcount;
		if( shaders.Length()<n ) n=shaders.Length();
		for( int i=0;i<n;++i ){
			shaders[i]=sh[i];
		}
	}
}

int _glGetAttribLocation( int program, String name ){
	return glGetAttribLocation( program,name.ToCString<char>() );
}

void _glGetBooleanv( int pname, Array<bool> params ){
	if( sizeof(bool)!=1 ){
		puts( "sizeof(bool) error in gles20.glfw.cpp!" );
		return;
	}
	glGetBooleanv( pname,(GLboolean*)&params[0] );
}

void _glGetBufferParameteriv( int target, int pname, Array<int> params ){
	glGetBufferParameteriv( target,pname,&params[0] );
}

void _glGetFloatv( int pname,Array<Float> params ){
	glGetFloatv( pname,&params[0] );
}

void _glGetFramebufferAttachmentParameteriv( int target, int attachment, int pname, Array<int> params ){
	glGetFramebufferAttachmentParameteriv( target,attachment,pname,&params[0] );
}

void _glGetIntegerv( int pname,Array<int> params ){
	glGetIntegerv( pname,&params[0] );
}

void _glGetProgramiv( int program,int pname,Array<int> params ){
	glGetProgramiv( program,pname,&params[0] );
}

String _glGetProgramInfoLog( int program ){
	int length=0,length2=0;
	glGetProgramiv( program,GL_INFO_LOG_LENGTH,&length );
	char *buf=(char*)malloc( length+1 );
	glGetProgramInfoLog( program,length,&length2,buf );
	String t=String( buf );
	free( buf );
	return t;
}

void _glGetRenderbufferParameteriv( int target,int pname,Array<int> params ){
	glGetRenderbufferParameteriv( target,pname,&params[0] );
}

void _glGetShaderiv( int shader, int pname, Array<int> params ){
	glGetShaderiv( shader,pname,&params[0] );
}

String _glGetShaderInfoLog( int shader ){
	int length=0,length2=0;
	glGetShaderiv( shader,GL_INFO_LOG_LENGTH,&length );
	char *buf=(char*)malloc( length+1 );
	glGetShaderInfoLog( shader,length,&length2,buf );
	String t=String( buf );
	free( buf );
	return t;
}

String _glGetShaderSource( int shader ){
	int length=0,length2=0;
	glGetShaderiv( shader,GL_SHADER_SOURCE_LENGTH,&length );
	char *buf=(char*)malloc( length+1 );
	glGetShaderSource( shader,length,&length2,buf );
	String t=String( buf );
	free( buf );
	return t;
}

String _glGetString( int name ){
	return String( glGetString( name ) );
}

void _glGetTexParameterfv( int target,int pname,Array<float> params ){
	glGetTexParameterfv( target,pname,&params[0] );
}

void _glGetTexParameteriv( int target,int pname,Array<int> params ){
	glGetTexParameteriv( target,pname,&params[0] );
}

void _glGetUniformfv( int program, int location, Array<float> params ){
	glGetUniformfv( program,location,&params[0] );
}

void _glGetUniformiv( int program, int location, Array<int> params ){
	glGetUniformiv( program,location,&params[0] );
}

int _glGetUniformLocation( int program, String name ){
	return glGetUniformLocation( program,name.ToCString<char>() );
}

void _glGetVertexAttribfv( int index, int pname, Array<float> params ){
	glGetVertexAttribfv( index,pname,&params[0] );
}

void _glGetVertexAttribiv( int index, int pname, Array<int> params ){
	glGetVertexAttribiv( index,pname,&params[0] );
}

void _glReadPixels( int x,int y,int width,int height,int format,int type,BBDataBuffer *pixels ){
	glReadPixels( x,y,width,height,format,type,pixels->WritePointer() );
}

void _glReadPixels( int x,int y,int width,int height,int format,int type,Array<int> pixels ) {
	glReadPixels( x,y,width,height,format,type,&pixels[0] );
}

void _glReadPixels( int x,int y,int width,int height,int format,int type,Array<int> pixels,int offset,int pitch ) {
	for (int i = 0; i < height; i++) {
		glReadPixels( x,y+i,width,1,format,type,&pixels[offset + i * pitch] );
	}
}

void _glReadPixels32( int x,int y,int width,int height,Array<int> pixels ) {
#ifdef CFG_GLFW_VERSION
	//GL_BGRA = 32993
	glReadPixels( x,y,width,1,32993,GL_UNSIGNED_BYTE,&pixels[0] );
#else
	//TODO OpenGL ES
#endif
}

void _glReadPixels32( int x,int y,int width,int height,Array<int> pixels,int offset,int pitch ) {
#ifdef CFG_GLFW_VERSION
	for (int i = 0; i < height; i++) {
		//GL_BGRA = 32993
		glReadPixels( x,y+i,width,1,32993,GL_UNSIGNED_BYTE,&pixels[offset + i * pitch] );
	}
#else
	//TODO OpenGL ES
#endif
}

void _glReadPixelsFlipped32( int x,int y,int width,int height,Array<int> pixels ){
#ifdef CFG_GLFW_VERSION
	for (int i = 0; i < height; i++) {
		//GL_BGRA = 32993
		glReadPixels( x,y+i,width,1,32993,GL_UNSIGNED_BYTE,&pixels[height - i] );
	}
#else
	//TODO OpenGL ES
#endif
}

void _glReadPixelsFlipped32( int x,int y,int width,int height,Array<int> pixels,int offset,int pitch ){
#ifdef CFG_GLFW_VERSION
	for (int i = 0; i < height; i++) {
		//GL_BGRA = 32993
		glReadPixels( x,y+i,width,1,32993,GL_UNSIGNED_BYTE,&pixels[offset + (height - i) * pitch] );
	}
#else
	//TODO OpenGL ES
#endif
}

void _glShaderSource( int shader, String source ){
	String::CString<char> cstr=source.ToCString<char>();
	const char *buf[1];
	buf[0]=cstr;
	glShaderSource( shader,1,(const GLchar**)buf,0 );
}

void _glTexImage2D( int target,int level,int internalformat,int width,int height,int border,int format,int type,BBDataBuffer *pixels ){
	glTexImage2D( target,level,internalformat,width,height,border,format,type,pixels ? pixels->ReadPointer() : NULL );
}

void _glTexSubImage2D( int target,int level,int xoffset,int yoffset,int width,int height,int format,int type,BBDataBuffer *pixels ){
	glTexSubImage2D( target,level,xoffset,yoffset,width,height,format,type,pixels->ReadPointer() );
}

void _glTexSubImage2D( int target,int level,int xoffset,int yoffset,int width,int height,int format,int type,int from,BBDataBuffer *pixels ){
	glTexSubImage2D( target,level,xoffset,yoffset,width,height,format,type,pixels->ReadPointer(from) );
}

void _glUniform1fv( int location, int count, Array<float> v ){
	glUniform1fv( location,count,&v[0] );
}

void _glUniform1iv( int location, int count, Array<int> v ){
	glUniform1iv( location,count,&v[0] );
}

void _glUniform2fv( int location, int count, Array<float> v ){
	glUniform2fv( location,count,&v[0] );
}

void _glUniform2iv( int location, int count, Array<int> v ){
	glUniform2iv( location,count,&v[0] );
}

void _glUniform3fv( int location, int count, Array<float> v ){
	glUniform3fv( location,count,&v[0] );
}

void _glUniform3iv( int location, int count, Array<int> v ){
	glUniform3iv( location,count,&v[0] );
}

void _glUniform4fv( int location, int count, Array<float> v ){
	glUniform4fv( location,count,&v[0] );
}

void _glUniform4iv( int location, int count, Array<int> v ){
	glUniform4iv( location,count,&v[0] );
}

void _glUniformMatrix2fv( int location, int count, bool transpose, Array<float> value ){
	glUniformMatrix2fv( location,count,transpose,&value[0] );
}

void _glUniformMatrix3fv( int location, int count, bool transpose, Array<float> value ){
	glUniformMatrix3fv( location,count,transpose,&value[0] );
}

void _glUniformMatrix4fv( int location, int count, bool transpose, Array<float> value ){
	glUniformMatrix4fv( location,count,transpose,&value[0] );
}

void _glVertexAttrib1fv( int indx, Array<float> values ){
	glVertexAttrib1fv( indx,&values[0] );
}

void _glVertexAttrib2fv( int indx, Array<float> values ){
	glVertexAttrib2fv( indx,&values[0] );
}

void _glVertexAttrib3fv( int indx, Array<float> values ){
	glVertexAttrib3fv( indx,&values[0] );
}

void _glVertexAttrib4fv( int indx, Array<float> values ){
	glVertexAttrib4fv( indx,&values[0] );
}

void _glVertexAttribPointer( int indx, int size, int type, bool normalized, int stride, BBDataBuffer *ptr ){
	glVertexAttribPointer( indx,size,type,normalized,stride,ptr->ReadPointer() );
}

void _glVertexAttribPointer( int indx, int size, int type, bool normalized, int stride, int offset ){
	glVertexAttribPointer( indx,size,type,normalized,stride,(const GLvoid*)offset );
}

void _glTexUploadImage2D(unsigned char *data, int width, int height, int depth, int textureId, BBDataBuffer *pixmap, int target, int format, int type, bool padded, Array<int> result){
	int realWidth, realHeight;
	if(!data || depth<1 || depth>4) return;

	realWidth = result[2] = width;
	realHeight = result[3] = height;

	if (padded) {
		realWidth = result[2] = _glUtilNearestPOT(width);
		realHeight = result[3] = _glUtilNearestPOT(height);
	}

	result[0] = width;
	result[1] = height;

	if ((format == GL_RGBA) && depth != 4) {
		data = _glUtilConvertImageFormat(data, depth, 4, width, height);
	} else if (format == GL_RGB && depth != 3) {
		data = _glUtilConvertImageFormat(data, depth, 3, width, height);
	} else if (format == GL_LUMINANCE_ALPHA && depth != 2) {
		data = _glUtilConvertImageFormat(data, depth, 2, width, height);
	} else if (format == GL_LUMINANCE && depth != 1) {
		data = _glUtilConvertImageFormat(data, depth, 1, width, height);
	} else if (format == GL_ALPHA) {
		data = _glUtilConvertImageFormat(data, depth, 0, width, height);
	}

	if (!data) return;

	if (type == GL_UNSIGNED_SHORT_4_4_4_4) {
		data = _glUtilConvertRGBA8888ToRGBA4444(data, width, height);
	} else if (type == GL_UNSIGNED_SHORT_5_5_5_1) {
		data = _glUtilConvertRGBA8888ToRGBA5551(data, width, height);
	} else if (type == GL_UNSIGNED_SHORT_5_6_5) {
		data = _glUtilConvertRGB888ToRGB565(data, width, height);
	}

	if (!data) return;	
	
	if (pixmap) {
		int pixelSize = 4;
	
		if (type == GL_UNSIGNED_BYTE) {
			switch (format) {
				case GL_RGB:
					pixelSize = 3;
					break;
				case GL_LUMINANCE_ALPHA:
					pixelSize = 2;
					break;
				case GL_LUMINANCE:
				case GL_ALPHA:
					pixelSize = 1;
					break;
			}
		} else {
			pixelSize = 2;
		}
		
		pixmap->_New(width*height*pixelSize);
		memcpy(pixmap->WritePointer(), data, pixmap->Length());
	}

	glBindTexture(target, textureId);
	glTexImage2D(target, 0, format, realWidth, realHeight, 0, format, type, NULL);
	glTexSubImage2D(target, 0, 0, 0, width, height, format, type, data);
	glBindTexture(target, 0);

	free(data);
}

void _glPixmapSetPixel(int color, BBDataBuffer *pixmap, int offset, int format, int type) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer(offset);

		if (format == GL_RGBA) {
			stream[0] = color >> 24;
			stream[1] = color >> 16;
			stream[2] = color >> 8;
			stream[3] = color;

		} else if (format == GL_RGB) {
			stream[0] = color >> 16;
			stream[1] = color >> 8;
			stream[2] = color;

		} else if (format == GL_LUMINANCE_ALPHA) {
			stream[0] = color >> 8;
			stream[1] = color;

		} else if (format == GL_ALPHA || format == GL_LUMINANCE) {
			stream[0] = color;
		}
	} else {
		*(unsigned short*)(pixmap->WritePointer(offset>>1)) = color;
	}
}

void _glPixmapSetPixel32(int color, BBDataBuffer *pixmap, int offset, int format, int type) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer(offset);

		if (format == GL_RGBA) {
			stream[0] = color >> 16;
			stream[1] = color >> 8;
			stream[2] = color >> 0;
			stream[3] = color >> 24;

		} else if (format == GL_RGB) {
			stream[0] = color >> 16;
			stream[1] = color >> 8;
			stream[2] = color;

		} else if (format == GL_ALPHA) {
			stream[0] = color >> 24;

		} else if (format == GL_LUMINANCE_ALPHA) {
			stream[0] = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
			stream[1] = color >> 24;

		} else if (format == GL_LUMINANCE) {
			stream[0] = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer(offset>>1);

		if (type == GL_UNSIGNED_SHORT_4_4_4_4) {
			stream[0] = (((color >> 16) & 15) << 12) | (((color >> 8) & 15) << 8) | ((color & 15) << 4) | ((color >> 24) & 15);
		} else if (type == GL_UNSIGNED_SHORT_5_5_5_1) {
			stream[0] = (((color >> 16) & 31) << 11) | (((color >> 8) & 31) << 6) | ((color & 31) << 1) | ((color >> 24) & 1);
		} else if (type == GL_UNSIGNED_SHORT_5_6_5) {
			stream[0] = (((color >> 16) & 31) << 11) | (((color >> 8) & 63) << 5) | (color & 31);
		}
	}
}

void _glPixmapSetPixels(Array<int> pixels, int srcOffset, BBDataBuffer *pixmap, int dstOffset, int pitch, int width, int height, int format, int type) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer();

		if (format == GL_RGBA) {
			pitch -= width << 2;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];

					stream[dstOffset] = color >> 24;
					stream[dstOffset + 1] = color >> 16;
					stream[dstOffset + 2] = color >> 8;
					stream[dstOffset + 3] = color;

					dstOffset += 4;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == GL_RGB) {
			pitch -= width * 3;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];

					stream[dstOffset] = color >> 16;
					stream[dstOffset + 1] = color >> 8;
					stream[dstOffset + 2] = color;

					dstOffset += 3;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == GL_LUMINANCE_ALPHA) {
			pitch -= width << 1;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];

					stream[dstOffset] = color >> 8;
					stream[dstOffset + 1] = color;

					dstOffset += 2;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == GL_ALPHA || format == GL_LUMINANCE) {
			pitch -= width;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					stream[dstOffset] = pixels[srcOffset];
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer();
		dstOffset >>= 1;
		pitch = (pitch >> 1) - width;

		for (int py = 0; py < height; ++py) {
			for (int px = 0; px < width; ++px) {
				stream[dstOffset] = pixels[srcOffset];
				dstOffset++;
				srcOffset++;
			}

			dstOffset += pitch;
		}
	}
}

void _glPixmapSetPixels32(Array<int> pixels, int srcOffset, BBDataBuffer *pixmap, int dstOffset, int pitch, int width, int height, int format, int type) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer();

		if (format == GL_RGBA) {
			pitch -= width << 2;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];

					stream[dstOffset] = color >> 16;
					stream[dstOffset + 1] = color >> 8;
					stream[dstOffset + 2] = color;
					stream[dstOffset + 3] = color >> 24;

					dstOffset += 4;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == GL_RGB) {
			pitch -= width * 3;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];

					stream[dstOffset] = color >> 16;
					stream[dstOffset + 1] = color >> 8;
					stream[dstOffset + 2] = color;

					dstOffset += 3;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == GL_ALPHA) {
			pitch -= width;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					stream[dstOffset] = pixels[srcOffset] >> 24;
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}

		} else if (format == GL_LUMINANCE_ALPHA) {
			pitch -= width << 1;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];

					stream[dstOffset] = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
					stream[dstOffset + 1] = color >> 24;

					dstOffset += 2;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (format == GL_LUMINANCE) {
			pitch -= width;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];
					stream[dstOffset] = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer();
		dstOffset >>= 1;
		pitch = (pitch >> 1) - width;

		if (type == GL_UNSIGNED_SHORT_4_4_4_4) {
			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];
					stream[dstOffset] = (((color >> 16) & 15) << 12) | (((color >> 8) & 15) << 8) | ((color & 15) << 4) | ((color >> 24) & 15);
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		} else if (type == GL_UNSIGNED_SHORT_5_5_5_1) {
			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];
					stream[dstOffset] = (((color >> 16) & 31) << 11) | (((color >> 8) & 31) << 6) | ((color & 31) << 1) | ((color >> 24) & 1);
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}

		} else if (type == GL_UNSIGNED_SHORT_5_6_5) {
			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					int color = pixels[srcOffset];
					stream[dstOffset] = (((color >> 16) & 31) << 11) | (((color >> 8) & 63) << 5) | (color & 31);
					dstOffset++;
					srcOffset++;
				}

				dstOffset += pitch;
			}
		}
	}
}

int _glPixmapGetPixel(BBDataBuffer *pixmap, int offset, int format, int type) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer(offset);

		if (format == GL_RGBA) {
			return (stream[0] << 24) | (stream[1] << 16) | (stream[2] << 8) | stream[3];

		} else if (format == GL_RGB) {
			return (stream[0] << 16) | (stream[1] << 8) | stream[2];

		} else if (format == GL_LUMINANCE_ALPHA) {
			return (stream[0] << 8) | stream[1];

		} else if (format == GL_ALPHA || format == GL_LUMINANCE) {
			return stream[0];
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer(offset>>1);
		return stream[0];
	}
	
	return 0;
}

int _glPixmapGetPixel32(BBDataBuffer *pixmap, int offset, int format, int type) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer(offset);

		if (format == GL_RGBA) {
			return (stream[3] << 24) | (stream[0] << 16) | (stream[1] << 8) | stream[2];

		} else if (format == GL_RGB) {
			return 0xFF000000 | (stream[0] << 16) | (stream[1] << 8) | stream[2];

		} else if (format == GL_ALPHA) {
			return (stream[0] << 24) | 0x000000;

		} else if (format == GL_LUMINANCE_ALPHA) {
			unsigned char color = stream[0];
			return (stream[1] << 24) | (color << 16) | (color << 8) | color;

		} else if (format == GL_LUMINANCE) {
			unsigned char color = stream[0];
			return 0xFF000000 | (color << 16) | (color << 8) | color;
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer(offset>>1);

		if (type == GL_UNSIGNED_SHORT_4_4_4_4) {
			unsigned short color = stream[0];
			return (((color & 0xF) << 4) << 24) | (((color & 0xF000) >> 8) << 16) | (((color & 0xF00) >> 4) << 8) | (color & 0xF0);

		} else if (type == GL_UNSIGNED_SHORT_5_5_5_1) {
			unsigned short  color = stream[0];
			return ((((color & 0x1) << 1) * 255) << 24) | ((((color & 0x7C00) >> 10) << 3) << 16) | ((((color & 0x3E0) >> 5) << 3) << 8) | ((color & 0x1F) << 3);

		} else if (type == GL_UNSIGNED_SHORT_5_6_5) {
			unsigned short  color = stream[0];
			return 0xFF000000 | ((((color & 0xF800) >> 11) << 3) << 16) | ((((color & 0x7E0) >> 5) << 2) << 8) | ((color & 0x1F) << 3);
		}
	}
	
	return 0;
}

void _glPixmapGetPixels(BBDataBuffer *pixmap, int srcOffset, int pitch, int width, int height, int format, int type, Array<int> pixels, int dstOffset) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer();

		if (format == GL_RGBA) {
			pitch -= width << 2;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					pixels[dstOffset] = (stream[srcOffset] << 24) | (stream[srcOffset + 1] << 16) | (stream[srcOffset + 2] << 8) | stream[srcOffset + 3];
					srcOffset += 4;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == GL_RGB) {
			pitch -= width * 3;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					pixels[dstOffset] = (stream[srcOffset] << 16) | (stream[srcOffset + 1] << 8) | stream[srcOffset + 2];
					srcOffset += 3;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == GL_LUMINANCE_ALPHA) {
			pitch -= width << 1;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					pixels[dstOffset] = (stream[srcOffset] << 8) | stream[srcOffset + 1];
					srcOffset += 2;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == GL_ALPHA || format == GL_LUMINANCE) {
			pitch -= width;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					pixels[dstOffset] = stream[srcOffset];
					srcOffset++;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer();
		srcOffset >>= 1;
		pitch = (pitch >> 1) - width;

		for (int py = 0; py < height; ++py) {
			for (int px = 0; px < width; ++px) {
				pixels[dstOffset] = stream[srcOffset];
				dstOffset++;
				srcOffset++;
			}

			dstOffset += pitch;
		}
	}
}

void _glPixmapGetPixels32(BBDataBuffer *pixmap, int srcOffset, int pitch, int width, int height, int format, int type, Array<int> pixels, int dstOffset) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer();

		if (format == GL_RGBA) {
			pitch -= width << 2;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					pixels[dstOffset] = (stream[srcOffset + 3] << 24) | (stream[srcOffset] << 16) | (stream[srcOffset + 1] << 8) | stream[srcOffset + 2];
					srcOffset += 4;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == GL_RGB) {
			pitch -= width * 3;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					pixels[dstOffset] =  0xFF000000 | (stream[srcOffset] << 16) | (stream[srcOffset + 1] << 8) | stream[srcOffset + 2];
					srcOffset += 3;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == GL_ALPHA) {
			pitch -= width;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					pixels[dstOffset] = (stream[srcOffset] << 24) | 0x000000;
					srcOffset++;
					dstOffset++;
				}

				srcOffset += pitch;
			}

		} else if (format == GL_LUMINANCE_ALPHA) {
			pitch -= width << 1;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					unsigned char color = stream[srcOffset];
					pixels[dstOffset] = (stream[srcOffset + 1] << 24) | (color << 16) | (color << 8) | color;
					srcOffset += 2;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		} else if (format == GL_LUMINANCE) {
			pitch -= width;

			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					unsigned char color = stream[srcOffset];
					pixels[dstOffset] = 0xFF000000 | (color << 16) | (color << 8) | color;
					srcOffset++;
					dstOffset++;
				}

				srcOffset += pitch;
			}
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer();
		srcOffset >>= 1;
		pitch = (pitch >> 1) - width;

		if (type == GL_UNSIGNED_SHORT_4_4_4_4) {
			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					unsigned short color = stream[srcOffset];
					pixels[dstOffset] = (((color & 0xF) << 4) << 24) | (((color & 0xF000) >> 8) << 16) | (((color & 0xF00) >> 4) << 8) | (color & 0xF0);
					dstOffset++;
					srcOffset++;
				}

				srcOffset += pitch;
			}

		} else if (type == GL_UNSIGNED_SHORT_5_5_5_1) {
			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					unsigned short color = stream[srcOffset];
					//TODO something wrong
					pixels[dstOffset] = ((((color & 0x1) << 1) * 255) << 24) | ((((color & 0x7C00) >> 10) << 3) << 16) | ((((color & 0x3E0) >> 5) << 3) << 8) | ((color & 0x1F) << 3);
					dstOffset++;
					srcOffset++;
				}

				srcOffset += pitch;
			}

		} else if (type == GL_UNSIGNED_SHORT_5_6_5) {
			for (int py = 0; py < height; ++py) {
				for (int px = 0; px < width; ++px) {
					unsigned short color = stream[srcOffset];
					pixels[dstOffset] = 0xFF000000 | ((((color & 0xF800) >> 11) << 3) << 16) | ((((color & 0x7E0) >> 5) << 2) << 8) | ((color & 0x1F) << 3);
					dstOffset++;
					srcOffset++;
				}

				srcOffset += pitch;
			}
		}
	}
}

void _glPixmapClearPixels(BBDataBuffer *pixmap, int color, int format, int type) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer();
		int l = pixmap->Length() - 1;

		if (format == GL_RGBA) {
			unsigned char r = color >> 24;
			unsigned char g = color >> 16;
			unsigned char b = color >> 8;
			unsigned char a = color;

			while(l > 2) {
				stream[l] = a;
				stream[l - 1] = b;
				stream[l - 2] = g;
				stream[l - 3] = r;
				l -= 4;
			}
		} else if (format == GL_RGB) {
			unsigned char r = color >> 16;
			unsigned char g = color >> 8;
			unsigned char b = color;

			while(l > 1) {
				stream[l] = b;
				stream[l - 1] = g;
				stream[l - 2] = r;
				l -= 3;
			}

		} else if (format == GL_LUMINANCE_ALPHA) {
			unsigned char c = color >> 8;
			unsigned char a = color;

			while(l > 0) {
				stream[l] = a;
				stream[l - 1] = c;
				l -= 2;
			}

		} else if (format == GL_ALPHA || format == GL_LUMINANCE) {
			while(l) {
				stream[l] = color;
				l--;
			}
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer();
		int l = pixmap->Length() >> 1;

		while (l--) {
			stream[l] = color;
		}
	}
}

void _glPixmapClearPixels32(BBDataBuffer *pixmap, int color, int format, int type) {
	if (type == GL_UNSIGNED_BYTE) {
		unsigned char *stream = (unsigned char*)pixmap->WritePointer();
		int l = pixmap->Length() - 1;

		if (format == GL_RGBA) {
			unsigned char r = color >> 16;
			unsigned char g = color >> 8;
			unsigned char b = color >> 0;
			unsigned char a = color >> 24;

			while(l > 2) {
				stream[l] = a;
				stream[l - 1] = b;
				stream[l - 2] = g;
				stream[l - 3] = r;
				l -= 4;
			}
		} else if (format == GL_RGB) {
			unsigned char r = color >> 16;
			unsigned char g = color >> 8;
			unsigned char b = color;

			while(l > 1) {
				stream[l] = b;
				stream[l - 1] = g;
				stream[l - 2] = r;
				l -= 3;
			}
		} else if (format == GL_ALPHA) {
			unsigned char a = color >> 24;

			while(l) {
				stream[l] = a;
				l--;
			}
		} else if (format == GL_LUMINANCE_ALPHA) {
			unsigned char c = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);
			unsigned char a = color >> 24;

			while(l > 0) {
				stream[l] = a;
				stream[l - 1] = c;
				l -= 2;
			}

		} else if (format == GL_LUMINANCE) {
			unsigned char c = (((((color >> 16) & 0xFF) * 77) + (((color >> 8) & 0xFF) * 150) +  (29 * (color & 0xFF))) >> 8);

			while(l) {
				stream[l] = c;
				l--;
			}
		}
	} else {
		unsigned short *stream = (unsigned short*)pixmap->WritePointer();
		int l = pixmap->Length() >> 1;

		if (type == GL_UNSIGNED_SHORT_4_4_4_4) {
			color = (((color >> 16) & 15) << 12) | (((color >> 8) & 15) << 8) | ((color & 15) << 4) | ((color >> 24) & 15);
		} else if (type == GL_UNSIGNED_SHORT_5_5_5_1) {
			color = (((color >> 16) & 31) << 11) | (((color >> 8) & 31) << 6) | ((color & 31) << 1) | ((color >> 24) & 1);
		} else if (type == GL_UNSIGNED_SHORT_5_6_5) {
			color = (((color >> 16) & 31) << 11) | (((color >> 8) & 63) << 5) | (color & 31);
		}

		while (l--) {
			stream[l] = color;
		}
	}
}
