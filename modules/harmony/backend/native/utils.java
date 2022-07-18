import com.mungo.harmony.BufferUtils;

class HarmonyUtils {
	
	static void CopyDataBufferToDataBuffer(BBDataBuffer source, BBDataBuffer dest, int to) {
		BufferUtils.CopyByteBufferToByteBuffer(source.GetByteBuffer(), dest.GetByteBuffer(), to, 0, source.Length());
	}
	
	static void CopyDataBufferToDataBuffer(BBDataBuffer source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyByteBufferToByteBuffer(source.GetByteBuffer(), dest.GetByteBuffer(), to, from, count);
	}
	
	static void CopyFloatsToDatabuffer(float[] source, BBDataBuffer dest, int to) {
		BufferUtils.FastCopyArrayToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length);
	}
	
	static void CopyFloatsToDatabuffer(float[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.FastCopyArrayToByteBuffer(source, dest.GetByteBuffer(), to, from, count);
	}
	
	static void CopyFloatsToDatabuffer(int[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyFloatsToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 4);
	}
	
	static void CopyFloatsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyFloatsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 4);
	}
	
	static void CopyFloatsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int dStride) {
		BufferUtils.CopyFloatsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, dStride);
	}
	
	static void CopyFloatsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride) {
		BufferUtils.CopyFloatsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, sStride, dStride);
	}
	
	static void CopyIntsToDatabuffer(int[] source, BBDataBuffer dest, int to) {
		BufferUtils.FastCopyArrayToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length);
	}
	
	static void CopyIntsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.FastCopyArrayToByteBuffer(source, dest.GetByteBuffer(), to, from, count);
	}
	
	static void CopyIntsToDatabuffer(float[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyIntsToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 4);
	}
	
	static void CopyIntsToDatabuffer(float[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyIntsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 4);
	}
	
	static void CopyIntsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int dStride) {
		BufferUtils.CopyIntsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, dStride);
	}
	
	static void CopyIntsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride) {
		BufferUtils.CopyIntsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, sStride, dStride);
	}
	
	static void CopyShortsToDatabuffer(int[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyShortsToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 2);
	}
	
	static void CopyShortsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyShortsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 2);
	}
	
	static void CopyShortsToDatabuffer(float[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyShortsToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 2);
	}
	
	static void CopyShortsToDatabuffer(float[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyShortsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 2);
	}
	
	static void CopyShortsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int dStride) {
		BufferUtils.CopyShortsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, dStride);
	}
	
	static void CopyShortsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride) {
		BufferUtils.CopyShortsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, sStride, dStride);
	}
	
	static void CopyUShortsToDatabuffer(int[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyUShortsToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 2);
	}
	
	static void CopyUShortsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyUShortsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 2);
	}
	
	static void CopyUShortsToDatabuffer(float[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyUShortsToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 2);
	}
	
	static void CopyUShortsToDatabuffer(float[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyUShortsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 2);
	}
	
	static void CopyUShortsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int dStride) {
		BufferUtils.CopyUShortsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, dStride);
	}
	
	static void CopyUShortsToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride) {
		BufferUtils.CopyUShortsToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, sStride, dStride);
	}
	
	static void CopyBytesToDatabuffer(int[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyBytesToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 1);
	}
	
	static void CopyBytesToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyBytesToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 1);
	}
	
	static void CopyBytesToDatabuffer(float[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyBytesToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 1);
	}
	
	static void CopyBytesToDatabuffer(float[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyBytesToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 1);
	}
	
	static void CopyBytesToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int dStride) {
		BufferUtils.CopyBytesToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, dStride);
	}
	
	static void CopyBytesToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride) {
		BufferUtils.CopyBytesToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, sStride, dStride);
	}
	
	static void CopyUBytesToDatabuffer(int[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyUBytesToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 1);
	}
	
	static void CopyUBytesToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyUBytesToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 1);
	}
	
	static void CopyUBytesToDatabuffer(float[] source, BBDataBuffer dest, int to) {
		BufferUtils.CopyUBytesToByteBuffer(source, dest.GetByteBuffer(), to, 0, source.length, 1, 1);
	}
	
	static void CopyUBytesToDatabuffer(float[] source, BBDataBuffer dest, int to, int from, int count) {
		BufferUtils.CopyUBytesToByteBuffer(source, dest.GetByteBuffer(), to, from, count, 1, 1);
	}
	
	static void CopyUBytesToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int dStride) {
		BufferUtils.CopyUBytesToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, dStride);
	}
	
	static void CopyUBytesToDatabuffer(int[] source, BBDataBuffer dest, int to, int from, int count, int numComponents, int sStride, int dStride) {
		BufferUtils.CopyUBytesToByteBuffer(source, dest.GetByteBuffer(), to, from, count, numComponents, sStride, dStride);
	}
	
	static void CopyFloatsFromDatabuffer(BBDataBuffer source, float[] dest, int to) {
		BufferUtils.CopyFloatsFromByteBuffer(source.GetByteBuffer(), dest, to, 0, dest.length - to);
	}
	
	static void CopyIntsFromDatabuffer(BBDataBuffer source, int[] dest, int to) {
		BufferUtils.CopyIntsFromByteBuffer(source.GetByteBuffer(), dest, to, 0, dest.length - to);
	}
	
	static void CopyShortsFromDataBuffer(BBDataBuffer source, int[] dest, int to) {
		BufferUtils.CopyShortsFromByteBuffer(source.GetByteBuffer(), dest, to, 0, dest.length - to);
	}
	
	static void CopyBytesFromDataBuffer(BBDataBuffer source, int[] dest, int to) {
		BufferUtils.CopyBytesFromByteBuffer(source.GetByteBuffer(), dest, to, 0, dest.length - to);
	}
	
	static void CopyFloatsFromDatabuffer(BBDataBuffer source, float[] dest, int to, int from, int count) {
		BufferUtils.CopyFloatsFromByteBuffer(source.GetByteBuffer(), dest, to, from, (dest.length - to) < count ? dest.length - to : count);
	}
	
	static void CopyIntsFromDatabuffer(BBDataBuffer source, int[] dest, int to, int from, int count) {
		BufferUtils.CopyIntsFromByteBuffer(source.GetByteBuffer(), dest, to, from, (dest.length - to) < count ? dest.length - to : count);
	}
	
	static void CopyShortsFromDataBuffer(BBDataBuffer source, int[] dest, int to, int from, int count) {
		BufferUtils.CopyShortsFromByteBuffer(source.GetByteBuffer(), dest, to, from, (dest.length - to) < count ? dest.length - to : count);
	}
	
	static void CopyBytesFromDataBuffer(BBDataBuffer source, int[] dest, int to, int from, int count) {
		BufferUtils.CopyBytesFromByteBuffer(source.GetByteBuffer(), dest, to, from, (dest.length - to) < count ? dest.length - to : count);
	}
	
	//internal
	static IntBuffer newIntBuffer (int numInts) {
		ByteBuffer buffer = ByteBuffer.allocateDirect(numInts * 4);
		buffer.order(ByteOrder.nativeOrder());
		return buffer.asIntBuffer();
	}
	
}