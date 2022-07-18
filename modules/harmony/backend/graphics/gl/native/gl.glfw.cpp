
void _glTexUploadImage2D(String path, int textureId, BBDataBuffer *pixmap, int target, int format, int type, bool padded, Object *listener, Array<int> result){
	int width,height,depth;
	unsigned char *data = BBGlfwGame::GlfwGame()->LoadImageData(path, &width, &height, &depth);
	_glTexUploadImage2D(data, width, height, depth, textureId, pixmap, target, format, type, padded, result);
}

#if !defined(CFG_GLFW_USE_ANGLE_GLES20) || CFG_GLFW_USE_ANGLE_GLES20 == 0

void _glClearDepthf( float depth ){
	glClearDepth( depth );
}

void _glDepthRangef( float zNear,float zFar ){
	glDepthRange( zNear,zFar );
}

#endif
