
unsigned char *_alLoadAudioData(String path, int *length, int *channels, int *format, int *hertz) {
	return BBGlfwGame::GlfwGame()->LoadAudioData(path, length, channels, format, hertz);
}
