
class BBMonkeyGame : public BBMonkeyGameBase{
public:
	BBMonkeyGame(SwapChainBackgroundPanel^ panel);
	void CreateEGLResources();
	void SwapBuffers();

private:
	Windows::UI::Xaml::Controls::SwapChainBackgroundPanel^ _panel;
	EGLDisplay _eglDisplay;
	EGLContext _eglContext;
	EGLSurface _eglSurface;

	bool _ready;

	Microsoft::WRL::ComPtr<IWinrtEglWindow> _eglWindow;
};

BBMonkeyGame::BBMonkeyGame(SwapChainBackgroundPanel^ panel):BBMonkeyGameBase(){
	_eglDisplay = nullptr;
	_eglSurface = nullptr;
	_eglContext = nullptr;
	_eglWindow = nullptr;
	_ready = false;

	_panel = panel;
	CreateEGLResources();
}

void BBMonkeyGame::CreateEGLResources(){
	EGLint configAttribList[] = {
		EGL_RED_SIZE,       8,
		EGL_GREEN_SIZE,     8,
		EGL_BLUE_SIZE,      8,
		EGL_ALPHA_SIZE,     8,
		EGL_DEPTH_SIZE,     8,
		EGL_STENCIL_SIZE,   8,
		EGL_SAMPLE_BUFFERS, 0,
		EGL_NONE
	};
	EGLint surfaceAttribList[] = {
		EGL_NONE, EGL_NONE
	};

	EGLint numConfigs;
	EGLint majorVersion;
	EGLint minorVersion;
	EGLDisplay display;
	EGLContext context;
	EGLSurface surface;
	EGLConfig config;
	EGLint contextAttribs[] = { EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE, EGL_NONE };

    ANGLE_D3D_FEATURE_LEVEL featureLevel = ANGLE_D3D_FEATURE_LEVEL::ANGLE_D3D_FEATURE_LEVEL_9_3;

 	CreateWinrtEglWindow(WINRT_EGL_IUNKNOWN(_panel), featureLevel, _eglWindow.GetAddressOf());
	display = eglGetDisplay(_eglWindow);

	if(display == EGL_NO_DISPLAY){
		return;
	}

	if(!eglInitialize(display, &majorVersion, &minorVersion)){
		return;
	}

	if ( !eglGetConfigs(display, NULL, 0, &numConfigs) ){
		return;
	}

	if(!eglChooseConfig(display, configAttribList, &config, 1, &numConfigs)){
		return;
	}

    surface = eglCreateWindowSurface(display, config, _eglWindow, surfaceAttribList);
    if(surface == EGL_NO_SURFACE){
        return;
    }

	context = eglCreateContext(display, config, EGL_NO_CONTEXT, contextAttribs);
	if(context == EGL_NO_CONTEXT){
		return;
	}

	if (!eglMakeCurrent(display, surface, surface, context)){
		return;
	}

	_eglDisplay = display;
	_eglSurface = surface;
	_eglContext = context;
}

void BBMonkeyGame::SwapBuffers(){
	eglSwapBuffers(_eglDisplay, _eglSurface);
}
