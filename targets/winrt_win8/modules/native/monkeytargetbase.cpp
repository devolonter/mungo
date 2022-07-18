
class BBMonkeyGameBase : public BBWinrtGame{
public:
	BBMonkeyGameBase();

	void UpdateGameEx();
	virtual void SwapBuffers() = 0;

	virtual int GetDeviceWidthX(){ return _devWidth; }
	virtual int GetDeviceHeightX(){ return _devHeight; }
	virtual int GetDeviceRotationX();

	virtual unsigned char *LoadImageData( String path,int *width,int *height,int *format );
	virtual unsigned char *LoadAudioData( String path,int *length,int *channels,int *format,int *hertz );

	virtual void ValidateUpdateTimer();

protected:
	int _devWidth,_devHeight;

private:
	double _updatePeriod,_nextUpdate;

	IWICImagingFactory *_wicFactory;
};

BBMonkeyGameBase::BBMonkeyGameBase():_updatePeriod( 0 ),_nextUpdate( 0 ),_wicFactory( 0 ){
	_devWidth=DipsToPixels( CoreWindow::GetForCurrentThread()->Bounds.Width );
	_devHeight=DipsToPixels( CoreWindow::GetForCurrentThread()->Bounds.Height );

	if( _devWidth<_devHeight ) std::swap( _devWidth,_devHeight );
}

void BBMonkeyGameBase::ValidateUpdateTimer(){
	if( _updateRate ){
		_updatePeriod=1.0/_updateRate;
		_nextUpdate=0;
	}
}

void BBMonkeyGameBase::UpdateGameEx(){
	if( _suspended ) return;

	//poll accelerometer
	static Windows::Devices::Sensors::Accelerometer ^accel;
	if( !accel ) accel=Windows::Devices::Sensors::Accelerometer::GetDefault();
	if( accel ){
		auto r=accel->GetCurrentReading();
		float x= float( r->AccelerationX );
		float y=-float( r->AccelerationY );
		float z= float( r->AccelerationZ );
		float tx=x,ty=y;
		switch( GetDeviceRotationX() ){
		case 0:
			break;
		case 1:	//Note! Different from winphone 8!
			x=-ty;
			y=tx;
			break;
		case 2:
			x=-tx;
			y=-ty;
			break;
		case 3:	//Note! Different from winphone 8!
			x=ty;
			y=-tx;
			break;
		}
		MotionEvent( BBGameEvent::MotionAccel,-1,x,y,z );
	}

	if( !_updateRate ){
		UpdateGame();
		return;
	}

	if( !_nextUpdate ) _nextUpdate=GetTime();

	for( int i=0;i<4;++i ){

		UpdateGame();
		if( !_nextUpdate ) return;

		_nextUpdate+=_updatePeriod;
		if( GetTime()<_nextUpdate ) return;
	}
	_nextUpdate=0;
}

int BBMonkeyGameBase::GetDeviceRotationX(){
	switch( DisplayProperties::CurrentOrientation ){
	case DisplayOrientations::Landscape:return 0;
	case DisplayOrientations::Portrait:return 1;
	case DisplayOrientations::LandscapeFlipped:return 2;
	case DisplayOrientations::PortraitFlipped:return 3;
	}
	return 0;
}

unsigned char *BBMonkeyGameBase::LoadImageData( String path,int *pwidth,int *pheight,int *pformat ){

	if( !_wicFactory ){
		DXASS( CoCreateInstance( CLSID_WICImagingFactory,0,CLSCTX_INPROC_SERVER,__uuidof(IWICImagingFactory),(LPVOID*)&_wicFactory ) );
	}

	path=PathToFilePath( path );

	IWICBitmapDecoder *decoder;
	if( !SUCCEEDED( _wicFactory->CreateDecoderFromFilename( path.ToCString<wchar_t>(),NULL,GENERIC_READ,WICDecodeMetadataCacheOnDemand,&decoder ) ) ){
		return 0;
	}

	unsigned char *data=0;
	UINT width,height,format=0;

	IWICBitmapFrameDecode *bitmapFrame;
	DXASS( decoder->GetFrame( 0,&bitmapFrame ) );

	WICPixelFormatGUID pixelFormat;
	DXASS( bitmapFrame->GetSize( &width,&height ) );
	DXASS( bitmapFrame->GetPixelFormat( &pixelFormat ) );

	if( pixelFormat==GUID_WICPixelFormat24bppBGR ){
		format=3;
	}else if( pixelFormat==GUID_WICPixelFormat32bppBGRA ){
		format=4;
	}

	if( format ){
		data=(unsigned char*)malloc( width*height*format );
		DXASS( bitmapFrame->CopyPixels( 0,width*format,width*height*format,data ) );
		for( unsigned char *t=data;t<data+width*height*format;t+=format ) std::swap( t[0],t[2] );
		*pwidth=width;
		*pheight=height;
		*pformat=format;
	}

	bitmapFrame->Release();
	decoder->Release();

	if( data ) gc_ext_malloced( (*pwidth)*(*pheight)*(*pformat) );

	return data;
}

unsigned char *BBMonkeyGameBase::LoadAudioData( String path,int *length,int *channels,int *format,int *hertz ){

	String url=PathToFilePath( path );

	DXASS( MFStartup( MF_VERSION ) );

	IMFAttributes *attrs;
	DXASS( MFCreateAttributes( &attrs,1 ) );
	DXASS( attrs->SetUINT32( MF_LOW_LATENCY,TRUE ) );

	IMFSourceReader *reader;
	if( FAILED( MFCreateSourceReaderFromURL( url.ToCString<wchar_t>(),attrs,&reader ) ) ){
		attrs->Release();
		return 0;
	}

	attrs->Release();

	IMFMediaType *mediaType;
	DXASS( MFCreateMediaType( &mediaType ) );
	DXASS( mediaType->SetGUID( MF_MT_MAJOR_TYPE,MFMediaType_Audio ) );
	DXASS( mediaType->SetGUID( MF_MT_SUBTYPE,MFAudioFormat_PCM ) );

	DXASS( reader->SetCurrentMediaType( MF_SOURCE_READER_FIRST_AUDIO_STREAM,0,mediaType ) );

	mediaType->Release();

	IMFMediaType *outputMediaType;
	DXASS( reader->GetCurrentMediaType( MF_SOURCE_READER_FIRST_AUDIO_STREAM,&outputMediaType ) );

	WAVEFORMATEX *wformat;
	uint32 formatByteCount=0;
	DXASS( MFCreateWaveFormatExFromMFMediaType( outputMediaType,&wformat,&formatByteCount ) );

	*channels=wformat->nChannels;
	*format=wformat->wBitsPerSample/8;
	*hertz=wformat->nSamplesPerSec;

	CoTaskMemFree( wformat );

	outputMediaType->Release();
/*
	PROPVARIANT var;
	DXASS( reader->GetPresentationAttribute( MF_SOURCE_READER_MEDIASOURCE,MF_PD_DURATION,&var ) );
	LONGLONG duration=var.uhVal.QuadPart;
	float64 durationInSeconds=(duration / (float64)(10000 * 1000));
	m_maxStreamLengthInBytes=(uint32)( durationInSeconds * m_waveFormat.nAvgBytesPerSec );
*/
	std::vector<unsigned char*> bufs;
	std::vector<uint32> lens;
	uint32 len=0;

	for( ;; ){
		uint32 flags=0;
		IMFSample *sample;
		DXASS( reader->ReadSample( MF_SOURCE_READER_FIRST_AUDIO_STREAM,0,0,reinterpret_cast<DWORD*>(&flags),0,&sample ) );

		if( flags & MF_SOURCE_READERF_ENDOFSTREAM ){
			break;
		}
		if( sample==0 ){
			abort();
		}

		IMFMediaBuffer *mediaBuffer;
		DXASS( sample->ConvertToContiguousBuffer( &mediaBuffer ) );

		uint8 *audioData=0;
		uint32 sampleBufferLength=0;
		DXASS( mediaBuffer->Lock( &audioData,0,reinterpret_cast<DWORD*>( &sampleBufferLength ) ) );

		unsigned char *buf=(unsigned char*)malloc( sampleBufferLength );
		memcpy( buf,audioData,sampleBufferLength );

		bufs.push_back( buf );
		lens.push_back( sampleBufferLength );
		len+=sampleBufferLength;

		DXASS( mediaBuffer->Unlock() );
		mediaBuffer->Release();

		sample->Release();
	}

	reader->Release();

	*length=len/(*channels * *format);

	unsigned char *data=(unsigned char*)malloc( len );
	unsigned char *p=data;

	for( int i=0;i<bufs.size();++i ){
		memcpy( p,bufs[i],lens[i] );
		free( bufs[i] );
		p+=lens[i];
	}

	if( data ) gc_ext_malloced( (*length)*(*channels)*(*format) );

	return data;
}
