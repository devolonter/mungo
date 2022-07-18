#include "com_mungo_harmony_NHGL.h"
#include <GLES2/gl2.h>

#ifdef  __ANDROID__
#include <cstdlib>
#include <cstddef>
#else
#include <string.h>
#endif

#ifndef size_t
#define size_t std::size_t
#endif

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glBufferData
  (JNIEnv *env, jclass cls, jint target, jint size, jfloatArray obj_data, jint usage){
	float* data = (float*)env->GetPrimitiveArrayCritical(obj_data, 0);
	glBufferData(target, size<<2, data, usage);
	env->ReleasePrimitiveArrayCritical(obj_data, data, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glBufferSubData__III_3F
  (JNIEnv *env, jclass cls, jint target, jint offset, jint size, jfloatArray obj_data){
	float* data = (float*)env->GetPrimitiveArrayCritical(obj_data, 0);
	glBufferSubData(target, offset, size<<2, data);
	env->ReleasePrimitiveArrayCritical(obj_data, data, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glBufferSubData__IIII_3F
  (JNIEnv *env, jclass cls, jint target, jint offset, jint size, jint from, jfloatArray obj_data){
	float* data = (float*)env->GetPrimitiveArrayCritical(obj_data, 0);
	glBufferSubData(target, offset, size<<2, data + from);
	env->ReleasePrimitiveArrayCritical(obj_data, data, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glReadPixels__IIIIII_3I
  (JNIEnv *, jclass, jint, jint, jint, jint, jint, jint, jintArray){}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glReadPixels__IIIIII_3III
  (JNIEnv *, jclass, jint, jint, jint, jint, jint, jint, jintArray, jint, jint){}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glReadPixels32__IIII_3I
  (JNIEnv *, jclass, jint, jint, jint, jint, jintArray){}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glReadPixels32__IIII_3III
  (JNIEnv *, jclass, jint, jint, jint, jint, jintArray, jint, jint){}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glReadPixelsFlipped__IIIIII_3I
  (JNIEnv *, jclass, jint, jint, jint, jint, jint, jint, jintArray){}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glReadPixelsFlipped__IIIIII_3III
  (JNIEnv *, jclass, jint, jint, jint, jint, jint, jint, jintArray, jint, jint){}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glReadPixelsFlipped32__IIII_3I
  (JNIEnv *, jclass, jint, jint, jint, jint, jintArray){}

JNIEXPORT void JNICALL Java_com_mungo_harmony_NHGL_glReadPixelsFlipped32__IIII_3III
  (JNIEnv *, jclass, jint, jint, jint, jint, jintArray, jint, jint){}
  
JNIEXPORT jstring JNICALL Java_com_mungo_harmony_NHGL_glGetActiveUniform
  (JNIEnv *env, jclass cls, jint program, jint index, jintArray obj_size, jintArray obj_type){
	char cname[2048];
	void* size = obj_size ? env->GetPrimitiveArrayCritical(obj_size, 0) : 0;
	void* type = obj_type ? env->GetPrimitiveArrayCritical(obj_type, 0) : 0;
	glGetActiveUniform(program, index, 2048, NULL, (GLint*)size, (GLenum*)type, cname);
	env->ReleasePrimitiveArrayCritical(obj_size, size, 0);
	env->ReleasePrimitiveArrayCritical(obj_type, type, 0);

	return env->NewStringUTF(cname);
}