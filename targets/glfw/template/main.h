
//Lang/OS...
#include <ctime>
#include <cmath>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <typeinfo>
#include <signal.h>

#if _WIN32
#include <windows.h>
#include <direct.h>
#include <sys/stat.h>
#undef LoadString

#elif __APPLE__
#include <ApplicationServices/ApplicationServices.h>
#include <mach-o/dyld.h>
#include <sys/stat.h>
#include <dirent.h>
#include <copyfile.h>
#include <pthread.h>

#elif __linux
#define GL_GLEXT_PROTOTYPES
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>
#include <pthread.h>
#endif

// Graphics/Audio stuff

//OpenGL...
#include <GL/glfw.h>

//OpenAL...
#define AL_ALEXT_PROTOTYPES
#include <al.h>
#include <alc.h>
#include <alext.h>
#include <efx.h>
#include <efx-presets.h>

//STB_image lib...
#include <stb_image.h>

//stb_vorbis lib
#define STB_VORBIS_HEADER_ONLY
#include <stb_vorbis.c>

#define _QUOTE(X) #X
#define _STRINGIZE( X ) _QUOTE(X)


