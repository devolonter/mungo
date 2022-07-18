#include "com_mungo_harmony_BufferUtils.h"

#ifdef  __ANDROID__
#include <cstdlib>
#include <cstddef>
#else
#include <string.h>
#endif

#ifndef size_t
#define size_t std::size_t
#endif

#include "../../utils.cpp"

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyByteBufferToByteBuffer
  (JNIEnv *env, jclass cls, jobject obj_src, jobject obj_dst, jint to, jint from, jint count) {  
	unsigned char* src = (unsigned char*)(obj_src ? env->GetDirectBufferAddress(obj_src) : 0);
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	memcpy(dst + to, src + from, count);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_FastCopyArrayToByteBuffer___3FLjava_nio_ByteBuffer_2III
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	memcpy(dst + to, src + from, count<<2);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_FastCopyArrayToByteBuffer___3ILjava_nio_ByteBuffer_2III
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	memcpy(dst + to, src + from, count<<2);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyFloatsToByteBuffer___3FLjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, float>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyFloatsToByteBuffer___3ILjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, float>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyFloatsToByteBuffer___3FLjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, float>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyFloatsToByteBuffer___3ILjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, float>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyIntsToByteBuffer___3ILjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, int>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyIntsToByteBuffer___3FLjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, int>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyIntsToByteBuffer___3ILjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, int>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyIntsToByteBuffer___3FLjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, int>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyShortsToByteBuffer___3ILjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride){
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, short>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyShortsToByteBuffer___3FLjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride){
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, short>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyShortsToByteBuffer___3ILjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, short>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyShortsToByteBuffer___3FLjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, short>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyUShortsToByteBuffer___3ILjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride){
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, unsigned short>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyUShortsToByteBuffer___3FLjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride){
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, unsigned short>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyUShortsToByteBuffer___3ILjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, unsigned short>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyUShortsToByteBuffer___3FLjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, unsigned short>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyBytesToByteBuffer___3ILjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride){
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, signed char>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyBytesToByteBuffer___3FLjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride){
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, signed char>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyBytesToByteBuffer___3ILjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, signed char>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyBytesToByteBuffer___3FLjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, signed char>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyUBytesToByteBuffer___3ILjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride){
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, unsigned char>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyUBytesToByteBuffer___3FLjava_nio_ByteBuffer_2IIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint dStride){
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, unsigned char>(src, dst, to, from, count, numComponents, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyUBytesToByteBuffer___3ILjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jintArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	int* src = (int*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<int, unsigned char>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyUBytesToByteBuffer___3FLjava_nio_ByteBuffer_2IIIIII
  (JNIEnv *env, jclass cls, jfloatArray obj_src, jobject obj_dst, jint to, jint from, jint count, jint numComponents, jint sStride, jint dStride) {
	unsigned char* dst = (unsigned char*)(obj_dst ? env->GetDirectBufferAddress(obj_dst) : 0);
	float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);	
	CopyArrayToDataBuffer<float, unsigned char>(src, dst, to, from, count, numComponents, sStride, dStride);
	env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyFloatsFromByteBuffer
  (JNIEnv *env, jclass cls, jobject obj_src, jfloatArray obj_dst, jint to, jint from, jint count) {
	float* dst = (float*)env->GetPrimitiveArrayCritical(obj_dst, 0);
	unsigned char* src = (unsigned char*)(obj_src ? env->GetDirectBufferAddress(obj_src) : 0);
	memcpy(dst + to, src + from, count<<2);
	env->ReleasePrimitiveArrayCritical(obj_dst, dst, 0);	
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyIntsFromByteBuffer
  (JNIEnv *env, jclass cls, jobject obj_src, jfloatArray obj_dst, jint to, jint from, jint count) {
	int* dst = (int*)env->GetPrimitiveArrayCritical(obj_dst, 0);
	unsigned char* src = (unsigned char*)(obj_src ? env->GetDirectBufferAddress(obj_src) : 0);
	CopyDataBufferToArray<int, int>(src, dst, to, from, count);
	env->ReleasePrimitiveArrayCritical(obj_dst, dst, 0);	
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyShortsFromByteBuffer
  (JNIEnv *env, jclass cls, jobject obj_src, jfloatArray obj_dst, jint to, jint from, jint count) {
	int* dst = (int*)env->GetPrimitiveArrayCritical(obj_dst, 0);
	unsigned char* src = (unsigned char*)(obj_src ? env->GetDirectBufferAddress(obj_src) : 0);
	CopyDataBufferToArray<short, int>(src, dst, to, from, count);
	env->ReleasePrimitiveArrayCritical(obj_dst, dst, 0);	
}

JNIEXPORT void JNICALL Java_com_mungo_harmony_BufferUtils_CopyBytesFromByteBuffer
  (JNIEnv *env, jclass cls, jobject obj_src, jfloatArray obj_dst, jint to, jint from, jint count) {
	int* dst = (int*)env->GetPrimitiveArrayCritical(obj_dst, 0);
	unsigned char* src = (unsigned char*)(obj_src ? env->GetDirectBufferAddress(obj_src) : 0);
	CopyDataBufferToArray<signed char, int>(src, dst, to, from, count);
	env->ReleasePrimitiveArrayCritical(obj_dst, dst, 0);	
}