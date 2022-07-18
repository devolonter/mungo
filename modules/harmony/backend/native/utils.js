
function CopyDataBufferByteToByte(source, dest, to) {
	dest.bytes.set(source.bytes, to);
}

function CopyDataBufferByteToByte2(source, dest, to, from, count) {
	if (from === 0 && count === source.length) {
		dest.bytes.set(source.bytes, to);
	} else {
		dest.bytes.set(source.bytes.subarray(from, from + count), to);
	}
}


function CopyDataBufferToDataBuffer(source, dest, to) {
	dest.ints.set(source.ints, to>>2);
}

function CopyDataBufferToDataBuffer2(source, dest, to, from, count) {
	if (from === 0 && count === source.length) {
		dest.ints.set(source.ints, to>>2);
	} else {
		dest.ints.set(source.ints.subarray(from>>2, from>>2 + count>>2), to>>2);
	}
}

function CopyFloatsToDatabuffer(source, dest, to) {
	dest.floats.set(source, to>>2);
}

function CopyFloatsToDatabuffer2(source, dest, to, from, count) {
	if (from === 0 && count === source.length) {
		dest.floats.set(source, to>>2);
	} else {
		dest.floats.set(source.subarray(from, from + count), to>>2);
	}
}

function CopyFloatsToDatabuffer3(source, dest, to, from, count, numComponents, dStride) {
	CopyArrayToArray(source, dest.floats, to>>2, from, count, numComponents, dStride>>2);
}

function CopyFloatsToDatabuffer4(source, dest, to, from, count, numComponents, sStride, dStride) {
	CopyArrayToArray2(source, dest.floats, to>>2, from, count, numComponents, sStride, dStride>>2);
}

function CopyIntsToDatabuffer(source, dest, to) {
	dest.ints.set(source, to>>2);
}

function CopyIntsToDatabuffer2(source, dest, to, from, count) {
	if (from === 0 && count === source.length) {
		dest.ints.set(source, to>>2);
	} else {
		dest.ints.set(source.subarray(from, from + count), to>>2);
	}
}

function CopyIntsToDatabuffer3(source, dest, to, from, count, numComponents, dStride) {
	CopyArrayToArray(source, dest.ints, to>>2, from, count, numComponents, dStride>>2);
}

function CopyIntsToDatabuffer4(source, dest, to, from, count, numComponents, sStride, dStride) {
	CopyArrayToArray2(source, dest.ints, to>>2, from, count, numComponents, sStride, dStride>>2);
}

function CopyShortsToDatabuffer(source, dest, to) {
	dest.shorts.set(source, to>>1);
}

function CopyShortsToDatabuffer2(source, dest, to, from, count) {
	if (from === 0 && count === source.length) {
		dest.shorts.set(source, to>>1);
	} else {
		dest.shorts.set(source.subarray(from, from + count), to>>1);
	}
}

function CopyShortsToDatabuffer3(source, dest, to, from, count, numComponents, dStride) {
	CopyArrayToArray(source, dest.shorts, to>>1, from, count, numComponents, dStride>>1);
}

function CopyShortsToDatabuffer4(source, dest, to, from, count, numComponents, sStride, dStride) {
	CopyArrayToArray2(source, dest.shorts, to>>1, from, count, numComponents, sStride, dStride>>1);
}

function CopyUShortsToDatabuffer(source, dest, to) {
	if (!dest.ushorts) dest.ushorts = new Uint16Array(dest.arrayBuffer, 0, dest.length>>1);
	dest.ushorts.set(source, to>>1);
}

function CopyUShortsToDatabuffer2(source, dest, to, from, count) {
	if (!dest.ushorts) dest.ushorts = new Uint16Array(dest.arrayBuffer, 0, dest.length>>1);

	if (from === 0 && count === source.length) {
		dest.ushorts.set(source, to>>1);
	} else {
		dest.ushorts.set(source.subarray(from, from + count), to>>1);
	}
}

function CopyUShortsToDatabuffer3(source, dest, to, from, count, numComponents, dStride) {
	if (!dest.ushorts) dest.ushorts = new Uint16Array(dest.arrayBuffer, 0, dest.length>>1);
	CopyArrayToArray(source, dest.ushorts, to>>1, from, count, numComponents, dStride>>1);
}

function CopyUShortsToDatabuffer4(source, dest, to, from, count, numComponents, sStride, dStride) {
	if (!dest.ushorts) dest.ushorts = new Uint16Array(dest.arrayBuffer, 0, dest.length>>1);
	CopyArrayToArray2(source, dest.ushorts, to>>1, from, count, numComponents, sStride, dStride>>1);
}

function CopyBytesToDatabuffer(source, dest, to) {
	dest.bytes.set(source, to);
}

function CopyBytesToDatabuffer2(source, dest, to, from, count) {
	if (from === 0 && count === source.length) {
		dest.bytes.set(source, to);
	} else {
		dest.bytes.set(source.subarray(from, from + count), to);
	}
}

function CopyBytesToDatabuffer3(source, dest, to, from, count, numComponents, dStride) {
	CopyArrayToArray(source, dest.bytes, to, from, count, numComponents, dStride);
}

function CopyBytesToDatabuffer4(source, dest, to, from, count, numComponents, sStride, dStride) {
	CopyArrayToArray2(source, dest.bytes, to, from, count, numComponents, sStride, dStride);
}

function CopyUBytesToDatabuffer(source, dest, to) {
	if (!dest.ubytes) dest.ubytes = new Uint8Array(dest.arrayBuffer);
	dest.ubytes.set(source, to);
}

function CopyUBytesToDatabuffer2(source, dest, to, from, count) {
	if (!dest.ubytes) dest.ubytes = new Uint8Array(dest.arrayBuffer);

	if (from === 0 && count === source.length) {
		dest.ubytes.set(source, to);
	} else {
		dest.ubytes.set(source.subarray(from, from + count), to);
	}
}

function CopyUBytesToDatabuffer3(source, dest, to, from, count, numComponents, dStride) {
	if (!dest.ubytes) dest.ubytes = new Uint8Array(dest.arrayBuffer);
	CopyArrayToArray(source, dest.ubytes, to, from, count, numComponents, dStride);
}

function CopyUBytesToDatabuffer4(source, dest, to, from, count, numComponents, sStride, dStride) {
	if (!dest.ubytes) dest.ubytes = new Uint8Array(dest.arrayBuffer);
	CopyArrayToArray2(source, dest.ubytes, to, from, count, numComponents, sStride, dStride);
}

function CopyBytesFromDataBuffer(source, dest, to) {
	if (source.bytes.length <= dest.length - to) {
		dest.set(source.bytes, to);
	} else {
		dest.set(source.bytes.subarray(0, dest.length - to), to);
	}
}

function CopyShortsFromDataBuffer(source, dest, to) {
	if (source.shorts.length <= dest.length - to) {
		dest.set(source.shorts, to);
	} else {
		
		dest.set(source.shorts.subarray(0, dest.length - to), to);
	}
}

function CopyIntsFromDataBuffer(source, dest, to) {
	if (source.ints.length <= dest.length - to) {
		dest.set(source.ints, to);
	} else {
		dest.set(source.ints.subarray(0, dest.length - to), to);
	}
}

function CopyFloatsFromDataBuffer(source, dest, to) {
	if (source.floats.length <= dest.length - to) {
		dest.set(source.floats, to);
	} else {
		dest.set(source.floats.subarray(0, dest.length - to), to);
	}
}

function CopyBytesFromDataBuffer2(source, dest, to, from, count) {
	if (dest.length - to < count) count = dest.length - to;
	
	if (from === 0 && count === source.bytes.length) {
		dest.set(source.bytes, to);
	} else {
		dest.set(source.bytes.subarray(from, from + count), to);
	}
}

function CopyShortsFromDataBuffer2(source, dest, to, from, count) {
	if (dest.length - to < count) count = dest.length - to;
	
	if (from === 0 && count === source.shorts.length) {
		dest.set(source.shorts, to);
	} else {
		from >>= 1;
		dest.set(source.shorts.subarray(from, from + count), to);
	}
}

function CopyIntsFromDataBuffer2(source, dest, to, from, count) {
	if (dest.length - to < count) count = dest.length - to;
	
	if (from === 0 && count === source.ints.length) {
		dest.set(source.ints, to);
	} else {
		from >>= 2;
		dest.set(source.ints.subarray(from, from + count), to);
	}
}

function CopyFloatsFromDataBuffer2(source, dest, to, from, count) {
	if (dest.length - to < count) count = dest.length - to;
	
	if (from === 0 && count === source.floats.length) {
		dest.set(source.floats, to);
	} else {
		from >>= 2;
		dest.set(source.floats.subarray(from, from + count), to);
	}
}

function CopyArrayToArray(source, dest, to, from, count, numComponents, dStride) {
	count += from;

	switch (numComponents) {
		case 4:
			while(from < count) {
				dest[to] = source[from++];
				dest[to+1] = source[from++];
				dest[to+2] = source[from++];
				dest[to+3] = source[from++];
				to += dStride;
			}

			break;

		case 3:
			while(from < count) {
				dest[to] = source[from++];
				dest[to+1] = source[from++];
				dest[to+2] = source[from++];
				to += dStride;
			}
			break;

		case 2:
			while(from < count) {
				dest[to] = source[from++];
				dest[to+1] = source[from++];
				to += dStride;
			}
			break;

		case 1:
			while(from < count) {
				dest[to] = source[from++];
				to += dStride;
			}
			break;

		default:
			while(from < count) {
				for (var i = 0; i < numComponents; i++) {
					dest[to+i] = source[from+i];
				}

				from += numComponents;
				to += dStride;
			}
	}
}

function CopyArrayToArray2(source, dest, to, from, count, numComponents, sStride, dStride) {
	count += from;

	switch (numComponents) {
		case 4:
			while(from < count) {
				dest[to] = source[from];
				dest[to+1] = source[from+1];
				dest[to+2] = source[from+2];
				dest[to+3] = source[from+3];
				to += dStride;
				from += sStride;
			}

			break;

		case 3:
			while(from < count) {
				dest[to] = source[from];
				dest[to+1] = source[from+1];
				dest[to+2] = source[from+2];
				to += dStride;
				from += sStride;
			}
			break;

		case 2:
			while(from < count) {
				dest[to] = source[from];
				dest[to+1] = source[from+1];
				to += dStride;
				from += sStride;
			}
			break;

		case 1:
			while(from < count) {
				dest[to] = source[from];
				to += dStride;
				from += sStride;
			}
			break;

		default:
			while(from < count) {
				for (var i = 0; i < numComponents; i++) {
					dest[to+i] = source[from+i];
				}

				from += numComponents + sStride;
				to += dStride;
			}
	}
}
