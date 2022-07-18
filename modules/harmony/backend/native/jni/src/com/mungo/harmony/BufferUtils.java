package com.mungo.harmony;
import java.nio.ByteBuffer;

public class BufferUtils {

	static{
		System.loadLibrary("harmony-buffer-utils");
    }

	native public static void CopyByteBufferToByteBuffer(ByteBuffer source, ByteBuffer dest, int to, int from, int count);
	native public static void FastCopyArrayToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count);
	native public static void FastCopyArrayToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count);
	native public static void CopyFloatsToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyFloatsToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyFloatsToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyFloatsToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyIntsToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyIntsToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyIntsToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyIntsToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyShortsToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyShortsToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyShortsToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyShortsToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyUShortsToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyUShortsToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyUShortsToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyUShortsToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyBytesToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyBytesToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyBytesToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyBytesToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyUBytesToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyUBytesToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int dStride);
	native public static void CopyUBytesToByteBuffer(int[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyUBytesToByteBuffer(float[] source, ByteBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride);
	native public static void CopyFloatsFromByteBuffer(ByteBuffer source, float[] dest, int to, int from, int count);
	native public static void CopyIntsFromByteBuffer(ByteBuffer source, int[] dest, int to, int from, int count);
	native public static void CopyShortsFromByteBuffer(ByteBuffer source, int[] dest, int to, int from, int count);
	native public static void CopyBytesFromByteBuffer(ByteBuffer source, int[] dest, int to, int from, int count);
	
}