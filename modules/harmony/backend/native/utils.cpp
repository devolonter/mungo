
template<typename S, typename D>
void CopyArrayToDataBuffer(const S *source, unsigned char *stream, int to, int from, int count, int numComponents, int dStride) {
	count += from;
	const size_t s = sizeof(D);

	switch(numComponents){
		case 4:
		while(from < count) {
			*(D*)(stream+to) = (D)source[from++];
			*(D*)(stream+to+s) = (D)source[from++];
			*(D*)(stream+to+s*2) = (D)source[from++];
			*(D*)(stream+to+s*3) = (D)source[from++];
			to += dStride;
		}

		break;

		case 3:
		while(from < count) {
			*(D*)(stream+to) = (D)source[from++];
			*(D*)(stream+to+s) = (D)source[from++];
			*(D*)(stream+to+s*2) = (D)source[from++];
			to += dStride;
		}

		break;

		case 2:
		while(from < count) {			
			*(D*)(stream+to) = (D)source[from++];
			*(D*)(stream+to+s) = (D)source[from++];
			to += dStride;
		}

		break;

		case 1:
		while(from < count) {
			*(D*)(stream+to) = (D)source[from++];
			to += dStride;
		}

		break;

		default:
		while(from < count) {
			for (int i = 0; i < numComponents; i++) {
				*(D*)(stream+to+s*i) = (D)source[from+i];
			}

			from += numComponents;
			to += dStride;
		}
	}
}

template<typename S, typename D>
void CopyArrayToDataBuffer(const S *source, unsigned char *stream, int to, int from, int count, int numComponents, int sStride, int dStride) {
	count += from;
	const size_t s = sizeof(D);

	switch(numComponents){
		case 4:
		while(from < count) {
			*(D*)(stream+to) = (D)source[from];
			*(D*)(stream+to+s) = (D)source[from+1];
			*(D*)(stream+to+s*2) = (D)source[from+2];
			*(D*)(stream+to+s*3) = (D)source[from+3];
			to += dStride;
			from += sStride;
		}

		break;

		case 3:
		while(from < count) {
			*(D*)(stream+to) = (D)source[from];
			*(D*)(stream+to+s) = (D)source[from+1];
			*(D*)(stream+to+s*2) = (D)source[from+2];
			to += dStride;
			from += sStride;
		}

		break;

		case 2:
		while(from < count) {
			*(D*)(stream+to) = (D)source[from];
			*(D*)(stream+to+s) = (D)source[from+1];
			to += dStride;
			from += sStride;
		}

		break;

		case 1:
		while(from < count) {
			*(D*)(stream+to) = (D)source[from];
			to += dStride;
			from += sStride;
		}

		break;

		default:
		while(from < count) {
			for (int i = 0; i < numComponents; i++) {
				*(D*)(stream+to+s*i) = (D)source[from+i];
			}

			from += numComponents + sStride;
			to += dStride;
		}
	}
}

template<typename S, typename D>
void CopyDataBufferToArray(const unsigned char *stream, D *dest, int to, int from, int count) {
	const size_t s = sizeof(S);
	
	for(int i = to, l = to + count; i < l; i++) {
		dest[i] = *(S*)(from+stream+i*s);
		
	}
}

#ifdef CFG_BRL_DATABUFFER_IMPLEMENTED

void CopyDataBufferToDataBuffer(BBDataBuffer *source, BBDataBuffer *dest, int to) {
	memcpy(dest->WritePointer(to), source->ReadPointer(), source->Length());
}

void CopyDataBufferToDataBuffer(BBDataBuffer *source, BBDataBuffer *dest, int to,
	int from, int count) {
	memcpy(dest->WritePointer(to), source->ReadPointer(from), count);
}

void CopyFloatsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to){
	memcpy(dest->WritePointer(to), &source[0], source.Length()<<2);
}

void CopyFloatsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<int, float>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(float));
}

void CopyFloatsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count){
	memcpy(dest->WritePointer(to), &source[from], count<<2);
}

void CopyFloatsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<int, float>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(float));
}

void CopyFloatsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<float, float>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyFloatsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<int, float>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyFloatsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<float, float>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyFloatsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<int, float>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyIntsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<float, int>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(int));
}

void CopyIntsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to){
	memcpy(dest->WritePointer(to), &source[0], source.Length()<<2);
}

void CopyIntsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<float, int>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(int));
}

void CopyIntsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count){
	memcpy(dest->WritePointer(to), &source[from], count<<2);
}

void CopyIntsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<float, int>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyIntsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<int, int>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyIntsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<float, int>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyIntsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<int, int>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyShortsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<float, short>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(short));
}

void CopyShortsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<int, short>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(short));
}

void CopyShortsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<float, short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(short));
}

void CopyShortsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<int, short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(short));
}

void CopyShortsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<float, short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyShortsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<int, short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyShortsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<float, short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyShortsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<int, short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyUShortsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<float, unsigned short>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(unsigned short));
}

void CopyUShortsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<int, unsigned short>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(unsigned short));
}

void CopyUShortsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<float, unsigned short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(unsigned short));
}

void CopyUShortsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<int, unsigned short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(unsigned short));
}

void CopyUShortsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<float, unsigned short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyUShortsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<int, unsigned short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyUShortsToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<float, unsigned short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyUShortsToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<int, unsigned short>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyBytesToDatabuffer(Array<float> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<float, signed char>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(signed char));
}

void CopyBytesToDatabuffer(Array<int> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<int, signed char>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(signed char));
}

void CopyBytesToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<float, signed char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(signed char));
}

void CopyBytesToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<int, signed char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(signed char));
}

void CopyBytesToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<float, signed char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyBytesToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<int, signed char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyBytesToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<float, signed char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyBytesToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<int, signed char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyUBytesToDatabuffer(Array<float> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<float, unsigned char>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(unsigned char));
}

void CopyUBytesToDatabuffer(Array<int> source, BBDataBuffer *dest, int to){
	CopyArrayToDataBuffer<int, unsigned char>(&source[0], (unsigned char*)dest->WritePointer(), to, 0, source.Length(), 1, sizeof(unsigned char));
}

void CopyUBytesToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<float, unsigned char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(unsigned char));
}

void CopyUBytesToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count){
	CopyArrayToDataBuffer<int, unsigned char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, 1, sizeof(unsigned char));
}

void CopyUBytesToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<float, unsigned char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyUBytesToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int dStride){
	CopyArrayToDataBuffer<int, unsigned char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, dStride);
}

void CopyUBytesToDatabuffer(Array<float> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<float, unsigned char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyUBytesToDatabuffer(Array<int> source, BBDataBuffer *dest, int to, int from, int count, int numComponents, int sStride, int dStride){
	CopyArrayToDataBuffer<int, unsigned char>(&source[0], (unsigned char*)dest->WritePointer(), to, from, count, numComponents, sStride, dStride);
}

void CopyBytesFromDataBuffer(BBDataBuffer *source, Array<int> dest, int to) {
	CopyDataBufferToArray<signed char, int>((unsigned char*)source->ReadPointer(), &dest[0], to, 0, dest.Length() - to);
}

void CopyShortsFromDataBuffer(BBDataBuffer *source, Array<int> dest, int to) {
	CopyDataBufferToArray<short, int>((unsigned char*)source->ReadPointer(), &dest[0], to, 0, dest.Length() - to);
}

void CopyIntsFromDataBuffer(BBDataBuffer *source, Array<int> dest, int to) {
	CopyDataBufferToArray<int, int>((unsigned char*)source->ReadPointer(), &dest[0], to, 0, dest.Length() - to);
}

void CopyFloatsFromDataBuffer(BBDataBuffer *source, Array<float> dest, int to) {
	memcpy(&dest[to], source->ReadPointer(), (dest.Length() - to)<<2);
}

void CopyBytesFromDataBuffer(BBDataBuffer *source, Array<int> dest, int to, int from, int count) {
	CopyDataBufferToArray<signed char, int>((unsigned char*)source->ReadPointer(), &dest[0], to, from, (dest.Length() - to) < count ? dest.Length() - to : count);
}

void CopyShortsFromDataBuffer(BBDataBuffer *source, Array<int> dest, int to, int from, int count) {
	CopyDataBufferToArray<short, int>((unsigned char*)source->ReadPointer(), &dest[0], to, from, (dest.Length() - to) < count ? dest.Length() - to : count);
}

void CopyIntsFromDataBuffer(BBDataBuffer *source, Array<int> dest, int to, int from, int count) {
	CopyDataBufferToArray<int, int>((unsigned char*)source->ReadPointer(), &dest[0], to, from, (dest.Length() - to) < count ? dest.Length() - to : count);
}

void CopyFloatsFromDataBuffer(BBDataBuffer *source, Array<float> dest, int to, int from, int count) {
	memcpy(&dest[to], source->ReadPointer(from), ((dest.Length() - to) < count ? dest.Length() - to : count)<<2);
}

#endif
