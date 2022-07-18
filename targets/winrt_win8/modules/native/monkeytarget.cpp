
class BBMonkeyGame : public BBMonkeyGameBase{
public:
	BBMonkeyGame();

	IDXGISwapChain1 *GetSwapChain(){ return _swapChain.Get(); }
	void SwapBuffers();

	virtual ID3D11Device1 *GetD3dDevice(){ return _device.Get(); }
	virtual ID3D11DeviceContext1 *GetD3dContext(){ return _context.Get(); }
	virtual ID3D11RenderTargetView *GetRenderTargetView(){ return _view.Get(); }

private:
	void CreateD3dResources();

	D3D_FEATURE_LEVEL _featureLevel;

	ComPtr<IDXGISwapChain1> _swapChain;
	ComPtr<ID3D11Device1> _device;
	ComPtr<ID3D11DeviceContext1> _context;
	ComPtr<ID3D11RenderTargetView> _view;
};

BBMonkeyGame::BBMonkeyGame(){
	CreateD3dResources();
}

void BBMonkeyGame::CreateD3dResources(){
	int width=_devWidth;
	int height=_devHeight;

	UINT creationFlags=D3D11_CREATE_DEVICE_BGRA_SUPPORT;

#ifdef _DEBUG
//	Not on 8.1, thank you very much!
//	creationFlags|=D3D11_CREATE_DEVICE_DEBUG;
#endif

	D3D_FEATURE_LEVEL featureLevels[]={
		D3D_FEATURE_LEVEL_11_1,
		D3D_FEATURE_LEVEL_11_0,
		D3D_FEATURE_LEVEL_10_1,
		D3D_FEATURE_LEVEL_10_0,
		D3D_FEATURE_LEVEL_9_3,
		D3D_FEATURE_LEVEL_9_2,
		D3D_FEATURE_LEVEL_9_1
	};

	ComPtr<ID3D11Device> device;
	ComPtr<ID3D11DeviceContext> context;

	DXASS( D3D11CreateDevice(
		0,
		D3D_DRIVER_TYPE_HARDWARE,
		0,
		creationFlags,
		featureLevels,
		ARRAYSIZE(featureLevels),
		D3D11_SDK_VERSION,
		&device,
		&_featureLevel,
		&context ) );

	DXASS( device.As( &_device ) );
	DXASS( context.As( &_context ) );

	//create swap chain
	if( _swapChain ){

		DXASS( _swapChain->ResizeBuffers( 2,width,height,DXGI_FORMAT_B8G8R8A8_UNORM,0 ) );

	}else{

		DXGI_SWAP_CHAIN_DESC1 swapChainDesc;
		ZEROMEM( swapChainDesc );
		swapChainDesc.Width=width;
		swapChainDesc.Height=height;
		swapChainDesc.Format=DXGI_FORMAT_B8G8R8A8_UNORM;
		swapChainDesc.Stereo=false;
		swapChainDesc.SampleDesc.Count=1;
		swapChainDesc.SampleDesc.Quality=0;
		swapChainDesc.BufferUsage=DXGI_USAGE_RENDER_TARGET_OUTPUT;
		swapChainDesc.BufferCount=2;
		swapChainDesc.Scaling=DXGI_SCALING_STRETCH;
		swapChainDesc.SwapEffect=DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL;
		swapChainDesc.Flags=0;

		ComPtr<IDXGIDevice1> dxgiDevice;
		_device.As( &dxgiDevice );

		ComPtr<IDXGIAdapter> dxgiAdapter;
		DXASS( dxgiDevice->GetAdapter( &dxgiAdapter ) );

		ComPtr<IDXGIFactory2> dxgiFactory;
		DXASS( dxgiAdapter->GetParent( __uuidof( IDXGIFactory2 ),(void**)&dxgiFactory ) );

		DXASS( dxgiFactory->CreateSwapChainForComposition( _device.Get(),&swapChainDesc,0,&_swapChain ) );
		DXASS( dxgiDevice->SetMaximumFrameLatency( 1 ) );
	}

	// Create a render target view of the swap chain back buffer.
	//
	ComPtr<ID3D11Texture2D> backBuffer;
	DXASS( _swapChain->GetBuffer( 0,__uuidof( ID3D11Texture2D ),(void**)&backBuffer ) );
	DXASS( _device->CreateRenderTargetView( backBuffer.Get(),0,&_view ) );
}

void BBMonkeyGame::SwapBuffers(){
	DXASS( _swapChain->Present( 1,0 ) );
}
