import com.mungo.harmony.NHGL;

class HGL {

	static boolean inited;
	
	static Method getActiveUniform;
	static IntBuffer sizeBuf;
	static IntBuffer typeBuf;

	static void initNativeGL(){	
		if( inited ) return;
		inited=true;
		
		try{
			Class[] p=new Class[]{ Integer.TYPE,Integer.TYPE,IntBuffer.class,IntBuffer.class };
			getActiveUniform=GLES20.class.getMethod( "glGetActiveUniform",p );
			sizeBuf=IntBuffer.allocate( 1 );
			typeBuf=IntBuffer.allocate( 1 );
		}catch( NoSuchMethodException ex ){
		}
	}
	
	static void glBufferData( int target,int size,BBDataBuffer data,int usage ){
		GLES20.glBufferData( target,size,data._data,usage );
	}
	
	static void glBufferSubData( int target,int offset,int size,BBDataBuffer data ){
		GLES20.glBufferSubData( target,offset,size,data._data );
	}
	
	static void glBufferSubData( int target,int offset,int size,int from,BBDataBuffer data ){
		data._data.position(from);
		GLES20.glBufferSubData( target,offset,size,data._data );
		data._data.position(0);
	}
	
	static int glCreateBuffer(){
		int[] tmp={0};
		GLES20.glGenBuffers( 1,tmp,0 );
		return tmp[0];
	}
	
	static int glCreateFramebuffer(){
		int[] tmp={0};
		GLES20.glGenFramebuffers( 1,tmp,0 );
		return tmp[0];
	}
	
	static int glCreateRenderbuffer(){
		int[] tmp={0};
		GLES20.glGenRenderbuffers( 1,tmp,0 );
		return tmp[0];
	}
	
	static int glCreateTexture(){
		int[] tmp={0};
		GLES20.glGenTextures( 1,tmp,0 );
		return tmp[0];
	}
	
	static void glDeleteBuffer( int buffer ){
		int[] tmp={buffer};
		GLES20.glDeleteBuffers( 1,tmp,0 );
	}
	
	static void glDeleteFramebuffer( int buffer ){
		int[] tmp={buffer};
		GLES20.glDeleteFramebuffers( 1,tmp,0 );
	}
	
	static void glDeleteRenderbuffer( int buffer ){
		int[] tmp={buffer};
		GLES20.glDeleteRenderbuffers( 1,tmp,0 );
	}
	
	static void glDeleteTexture( int texture ){
		int[] tmp={texture};
		GLES20.glDeleteTextures( 1,tmp,0 );
	}
	
	static void glGetActiveAttrib( int program, int index, int[] size, int[] type, String[] name ){
		int[] tmp={0,0,0};
		byte[] namebuf=new byte[1024];
		GLES20.glGetActiveAttrib( program,index,1024,tmp,0,tmp,1,tmp,2,namebuf,0 );
		if( size!=null && size.length!=0 ) size[0]=tmp[1];
		if( type!=null && type.length!=0 ) type[0]=tmp[2];
		if( name!=null && name.length!=0 ) name[0]=new String( namebuf,0,tmp[0] );
	}
	
	static void glGetActiveUniform( int program, int index, int[] size,int[] type, String[] name ){		
		if( name!=null && name.length!=0 ){
			name[0] = NHGL.glGetActiveUniform(program, index, (size!=null && size.length!=0) ? size : null, (type!=null && type.length!=0) ? type : null);
		} else {
			NHGL.glGetActiveUniform(program, index, (size!=null && size.length!=0) ? size : null, (type!=null && type.length!=0) ? type : null);
		}
	}
	
	static void glGetAttachedShaders( int program, int maxcount, int[] count, int[] shaders ){
		int[] cnt={0};
		int[] shdrs=new int[maxcount];
		GLES20.glGetAttachedShaders( program,maxcount,cnt,0,shdrs,0 );
		if( count!=null && count.length!=0 ) count[0]=cnt[0];
		if( shaders!=null && shaders.length!=0 ){
			int n=cnt[0];
			if( maxcount<n ) n=maxcount;
			if( shaders.length<n ) n=shaders.length;
			for( int i=0;i<n;++i ){
				shaders[i]=shdrs[i];
			}
		}
	}
	
	static void glGetBooleanv( int pname, boolean[] params ){
		GLES20.glGetBooleanv( pname,params,0 );
	}
	
	static void glGetBufferParameteriv( int target, int pname, int[] params ){
		GLES20.glGetBufferParameteriv( target,pname,params,0 );
	}
	
	static void glGetFloatv( int pname,float[] params ){
		GLES20.glGetFloatv( pname,params,0 );
	}
	
	static void glGetFramebufferAttachmentParameteriv( int target, int attachment, int pname, int[] params ){
		GLES20.glGetFramebufferAttachmentParameteriv( target,attachment,pname,params,0 );
	}
	
	static void glGetIntegerv( int pname,int[] params ){
		GLES20.glGetIntegerv( pname,params,0 );
	}
	
	static void glGetProgramiv( int program,int pname,int[] params ){
		GLES20.glGetProgramiv( program,pname,params,0 );
	}
	
	static void glGetRenderbufferParameteriv( int target,int pname,int[] params ){
		GLES20.glGetRenderbufferParameteriv( target,pname,params,0 );
	}
	
	static void glGetShaderiv( int shader, int pname, int[] params ){
		GLES20.glGetShaderiv( shader,pname,params,0 );
	}
	
	static String glGetShaderSource( int shader ){
		int[] len={0};
		byte[] buf=new byte[1024];
		GLES20.glGetShaderSource( shader,1024,len,0,buf,0 );
		return new String( buf,0,len[0] );
	}
	
	static void glGetTexParameterfv( int target,int pname,float[] params ){
		GLES20.glGetTexParameterfv( target,pname,params,0 );
	}
	
	static void glGetTexParameteriv( int target,int pname,int[] params ){
		GLES20.glGetTexParameteriv( target,pname,params,0 );
	}
	
	static void glGetUniformfv( int program, int location, float[] params ){
		GLES20.glGetUniformfv( program,location,params,0 );
	}
	
	static void glGetUniformiv( int program, int location, int[] params ){
		GLES20.glGetUniformiv( program,location,params,0 );
	}
	
	static void glGetVertexAttribfv( int index, int pname, float[] params ){
		GLES20.glGetVertexAttribfv( index,pname,params,0 );
	}
	
	static void glGetVertexAttribiv( int index, int pname, int[] params ){
		GLES20.glGetVertexAttribiv( index,pname,params,0 );
	}
	
	static void glReadPixels( int x,int y,int width,int height,int format,int type,BBDataBuffer pixels ){
		GLES20.glReadPixels( x,y,width,height,format,type,pixels._data );
	}

	static void glTexImage2D( int target,int level,int internalformat,int width,int height,int border,int format,int type,BBDataBuffer pixels ){
		GLES20.glTexImage2D( target,level,internalformat,width,height,border,format,type,pixels != null ? pixels._data : null );
	}

	static void glTexSubImage2D( int target,int level,int xoffset,int yoffset,int width,int height,int format,int type,BBDataBuffer pixels ){
		GLES20.glTexSubImage2D( target,level,xoffset,yoffset,width,height,format,type,pixels._data );
	}
	
	static void glUniform1fv( int location, int count, float[] v ){
		GLES20.glUniform1fv( location,count,v,0 );
	}
	
	static void glUniform1iv( int location, int count, int[] v ){
		GLES20.glUniform1iv( location,count,v,0 );
	}
	
	static void glUniform2fv( int location, int count, float[] v ){
		GLES20.glUniform2fv( location,count,v,0 );
	}
	
	static void glUniform2iv( int location, int count, int[] v ){
		GLES20.glUniform2iv( location,count,v,0 );
	}
	
	static void glUniform3fv( int location, int count, float[] v ){
		GLES20.glUniform3fv( location,count,v,0 );
	}
	
	static void glUniform3iv( int location, int count, int[] v ){
		GLES20.glUniform3iv( location,count,v,0 );
	}
	
	static void glUniform4fv( int location, int count, float[] v ){
		GLES20.glUniform4fv( location,count,v,0 );
	}
	
	static void glUniform4iv( int location, int count, int[] v ){
		GLES20.glUniform4iv( location,count,v,0 );
	}
	
	static void glUniformMatrix2fv( int location, int count, boolean transpose, float[] value ){
		GLES20.glUniformMatrix2fv( location,count,transpose,value,0 );
	}
	
	static void glUniformMatrix3fv( int location, int count, boolean transpose, float[] value ){
		GLES20.glUniformMatrix3fv( location,count,transpose,value,0 );
	}
	
	static void glUniformMatrix4fv( int location, int count, boolean transpose, float[] value ){
		GLES20.glUniformMatrix4fv( location,count,transpose,value,0 );
	}
	
	static void glVertexAttrib1fv( int indx, float[] values ){
		GLES20.glVertexAttrib1fv( indx,values,0 );
	}
	
	static void glVertexAttrib2fv( int indx, float[] values ){
		GLES20.glVertexAttrib2fv( indx,values,0 );
	}
	
	static void glVertexAttrib3fv( int indx, float[] values ){
		GLES20.glVertexAttrib3fv( indx,values,0 );
	}
	
	static void glVertexAttrib4fv( int indx, float[] values ){
		GLES20.glVertexAttrib4fv( indx,values,0 );
	}
	
	static void glTexUploadImage2D(String path, int textureId, BBDataBuffer pixmap, int target, int format, int type, boolean padded, Object listener, int[] result){
		Bitmap bitmap=null;
		
		try{
			bitmap=BBAndroidGame.AndroidGame().LoadBitmap( path );
		}catch( OutOfMemoryError e ){
			throw new Error( "Out of memory error loading bitmap" );
		}
		
		if( bitmap==null ) return;
		
		result[0]=result[2]=bitmap.getWidth();
		result[1]=result[3]=bitmap.getHeight();
		
		GLES20.glBindTexture(target, textureId);
		GLUtils.texImage2D(target, 0, bitmap, 0);
		GLES20.glBindTexture(target, 0);
	}
	
	static void glPixmapSetPixel(int color, BBDataBuffer pixmap, int offset, int format, int type){
	}
	
	static void glPixmapSetPixel32(int color, BBDataBuffer pixmap, int offset, int format, int type){
	}
	
	static void glPixmapSetPixels(int[] pixels, int srcOffset, BBDataBuffer pixmap, int dstOffset, int pitch, int width, int height, int format, int type){
	}
	
	static void glPixmapSetPixels32(int[] pixels, int srcOffset, BBDataBuffer pixmap, int dstOffset, int pitch, int width, int height, int format, int type){
	}
	
	static int glPixmapGetPixel(BBDataBuffer pixmap, int offset, int format, int type){
		return 0;
	}
	
	static int glPixmapGetPixel32(BBDataBuffer pixmap, int offset, int format, int type){
		return 0;
	}
	
	static void glPixmapGetPixels(BBDataBuffer pixmap, int srcOffset, int pitch, int width, int height, int format, int type, int[] pixels, int dstOffset){
	}
	
	static void glPixmapGetPixels32(BBDataBuffer pixmap, int srcOffset, int pitch, int width, int height, int format, int type, int[] pixels, int dstOffset){
	}
	
	static void glPixmapClearPixels(BBDataBuffer pixmap, int color, int format, int type){
	}
	
	static void glPixmapClearPixels32(BBDataBuffer pixmap, int color, int format, int type){
	}
	
}
