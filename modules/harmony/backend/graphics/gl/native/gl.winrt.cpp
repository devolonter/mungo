
void _glDrawElements( int mode, int count, int type, BBDataBuffer *indices, int offset ){
	glDrawElements( mode,count,type,indices->ReadPointer(offset) );
}
