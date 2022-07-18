
BBDataBuffer *LoadImageData( BBDataBuffer *buf,String path,Array<int> info ){

	int width=0,height=0,format=0;
	unsigned char *src=BBIosGame::IosGame()->LoadImageData( path,&width,&height,&format );
	if( !src ) return 0;

	if( !buf->_New( width*height*4 ) ) return 0;
	unsigned char *dst=(unsigned char*)buf->WritePointer();

	int y=0,pitch=width*format;

	switch( format ){
	case 3:
		for( y=0;y<height;++y ){
			for( int x=0;x<width;++x ){
				*dst++=*src++;
				*dst++=*src++;
				*dst++=*src++;
				*dst++=255;
			}
			src+=pitch;
		}
		break;
	case 4:
		for( y=0;y<height;++y ){
			memcpy( dst,src,width*4 );
			dst+=width*4;
			src+=pitch;
		}
		break;
	}

	free( src );

	if( info.Length()>0 ) info[0]=width;
	if( info.Length()>1 ) info[1]=height;

	return buf;
}

void _glEndRender() {
	MonkeyAppDelegate *appDelegate=(MonkeyAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate->view presentRenderbuffer];
}
