package com.mungo.harmony;
import java.nio.*;

public class NHGL {

	static{
		System.loadLibrary("harmony-gl");
    }
	
	native public static void glBufferData(int target, int size, float[] data, int usage);
	native public static void glBufferSubData(int target, int offset, int size, float[] data);
	native public static void glBufferSubData(int target, int offset, int size, int from, float[] data);
	native public static void glReadPixels(int x, int y, int width, int height, int format, int type, int[] pixels);
	native public static void glReadPixels(int x, int y, int width, int height, int format, int type, int[] pixels, int offset, int pitch);
	native public static void glReadPixels32(int x, int y, int width, int height, int[] pixels);
	native public static void glReadPixels32(int x, int y, int width, int height, int[] pixels, int offset, int pitch);
	native public static void glReadPixelsFlipped(int x, int y, int width, int height, int format, int type, int[] pixels);
	native public static void glReadPixelsFlipped(int x, int y, int width, int height, int format, int type, int[] pixels, int offset, int pitch);
	native public static void glReadPixelsFlipped32(int x, int y, int width, int height, int[] pixels);
	native public static void glReadPixelsFlipped32(int x, int y, int width, int height, int[] pixels, int offset, int pitch);
	
	native public static String glGetActiveUniform(int program, int index, int[] size, int[] type);
	
}