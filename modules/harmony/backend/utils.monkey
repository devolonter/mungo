Strict

Import brl.databuffer
Import "native/utils.${LANG}"

Extern

#If LANG = "java"

#If TARGET="android"

#LIBS+="${CD}/native/libs/x86/libharmony-buffer-utils.so"
#LIBS+="${CD}/native/libs/x86_64/libharmony-buffer-utils.so"
#LIBS+="${CD}/native/libs/mips/libharmony-buffer-utils.so"
#LIBS+="${CD}/native/libs/mips64/libharmony-buffer-utils.so"
#LIBS+="${CD}/native/libs/armeabi/libharmony-buffer-utils.so"
#LIBS+="${CD}/native/libs/armeabi/libharmony-buffer-utils.so"
#LIBS+="${CD}/native/libs/arm64-v8a/libharmony-buffer-utils.so"

#SRCS+="${CD}/native/jni/src/com/mungo/harmony/BufferUtils.java"

#End

Function CopyDataBufferToDataBuffer:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyDataBufferToDataBuffer"
Function CopyDataBufferToDataBuffer:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0, from:Int, count:Int) = "HarmonyUtils.CopyDataBufferToDataBuffer"
Function CopyDataBufferByteToByte:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyDataBufferToDataBuffer"
Function CopyDataBufferByteToByte:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0, from:Int, count:Int) = "HarmonyUtils.CopyDataBufferToDataBuffer"

Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyFloatsToDatabuffer"
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyFloatsToDatabuffer"
Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyFloatsToDatabuffer"
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyFloatsToDatabuffer"
Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyFloatsToDatabuffer"
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyFloatsToDatabuffer"
Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyFloatsToDatabuffer"
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyFloatsToDatabuffer"

Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyIntsToDatabuffer"
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyIntsToDatabuffer"
Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyIntsToDatabuffer"
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyIntsToDatabuffer"
Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyIntsToDatabuffer"
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyIntsToDatabuffer"
Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyIntsToDatabuffer"
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyIntsToDatabuffer"

Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyShortsToDatabuffer"
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyShortsToDatabuffer"
Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyShortsToDatabuffer"
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyShortsToDatabuffer"
Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyShortsToDatabuffer"
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyShortsToDatabuffer"
Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyShortsToDatabuffer"
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyShortsToDatabuffer"

Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyUShortsToDatabuffer"
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyUShortsToDatabuffer"
Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyUShortsToDatabuffer"
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyUShortsToDatabuffer"
Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyUShortsToDatabuffer"
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyUShortsToDatabuffer"
Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyUShortsToDatabuffer"
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyUShortsToDatabuffer"

Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyBytesToDatabuffer"
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyBytesToDatabuffer"
Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyBytesToDatabuffer"
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyBytesToDatabuffer"
Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyBytesToDatabuffer"
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyBytesToDatabuffer"
Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyBytesToDatabuffer"
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyBytesToDatabuffer"

Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyUBytesToDatabuffer"
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0) = "HarmonyUtils.CopyUBytesToDatabuffer"
Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyUBytesToDatabuffer"
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyUBytesToDatabuffer"
Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyUBytesToDatabuffer"
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "HarmonyUtils.CopyUBytesToDatabuffer"
Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyUBytesToDatabuffer"
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "HarmonyUtils.CopyUBytesToDatabuffer"

Function CopyBytesFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0) = "HarmonyUtils.CopyBytesFromDataBuffer"
Function CopyShortsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0) = "HarmonyUtils.CopyShortsFromDataBuffer"
Function CopyIntsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0) = "HarmonyUtils.CopyIntsFromDataBuffer"
Function CopyFloatsFromDataBuffer:Void(source:DataBuffer, dest:Float[], _to:Int = 0) = "HarmonyUtils.CopyFloatsFromDataBuffer"

Function CopyBytesFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyBytesFromDataBuffer"
Function CopyShortsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyShortsFromDataBuffer"
Function CopyIntsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyIntsToDatabuffer"
Function CopyFloatsFromDataBuffer:Void(source:DataBuffer, dest:Float[], _to:Int, from:Int, count:Int) = "HarmonyUtils.CopyFloatsFromDataBuffer"

#ElseIf LANG <> "js"

Function CopyDataBufferToDataBuffer:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0)
Function CopyDataBufferToDataBuffer:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0, from:Int, count:Int)
Function CopyDataBufferByteToByte:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0) = "CopyDataBufferToDataBuffer"
Function CopyDataBufferByteToByte:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0, from:Int, count:Int) = "CopyDataBufferToDataBuffer"

Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)
Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)

Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)
Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)

Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)
Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)

Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)
Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)

Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)
Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)

Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)
Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int)
Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int)
Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int)

Function CopyBytesFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0)
Function CopyShortsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0)
Function CopyIntsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0)
Function CopyFloatsFromDataBuffer:Void(source:DataBuffer, dest:Float[], _to:Int = 0)

Function CopyBytesFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int)
Function CopyShortsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int)
Function CopyIntsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int)
Function CopyFloatsFromDataBuffer:Void(source:DataBuffer, dest:Float[], _to:Int, from:Int, count:Int)

#Else

Function CopyDataBufferByteToByte:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0)
Function CopyDataBufferByteToByte:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0, from:Int, count:Int) = "CopyDataBufferByteToByte2"

Function CopyDataBufferToDataBuffer:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0)
Function CopyDataBufferToDataBuffer:Void(source:DataBuffer, dest:DataBuffer, _to:Int = 0, from:Int, count:Int) = "CopyDataBufferToDataBuffer2"

Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)

Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyFloatsToDatabuffer2"
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyFloatsToDatabuffer2"

Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyFloatsToDatabuffer3"
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyFloatsToDatabuffer3"

Function CopyFloatsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyFloatsToDatabuffer4"
Function CopyFloatsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyFloatsToDatabuffer4"

Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)

Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyIntsToDatabuffer2"
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyIntsToDatabuffer2"

Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyIntsToDatabuffer3"
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyIntsToDatabuffer3"

Function CopyIntsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyIntsToDatabuffer4"
Function CopyIntsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyIntsToDatabuffer4"

Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)

Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyShortsToDatabuffer2"
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyShortsToDatabuffer2"

Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyShortsToDatabuffer3"
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyShortsToDatabuffer3"

Function CopyShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyShortsToDatabuffer4"
Function CopyShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyShortsToDatabuffer4"

Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)

Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyUShortsToDatabuffer2"
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyUShortsToDatabuffer2"

Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyUShortsToDatabuffer3"
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyUShortsToDatabuffer3"

Function CopyUShortsToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyUShortsToDatabuffer4"
Function CopyUShortsToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyUShortsToDatabuffer4"

Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)

Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyBytesToDatabuffer2"
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyBytesToDatabuffer2"

Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyBytesToDatabuffer3"
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyBytesToDatabuffer3"

Function CopyBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyBytesToDatabuffer4"
Function CopyBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyBytesToDatabuffer4"

Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int = 0)
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int = 0)

Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyUBytesToDatabuffer2"
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int) = "CopyUBytesToDatabuffer2"

Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyUBytesToDatabuffer3"
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, dStride:Int) = "CopyUBytesToDatabuffer3"

Function CopyUBytesToDatabuffer:Void(source:Float[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyUBytesToDatabuffer4"
Function CopyUBytesToDatabuffer:Void(source:Int[], dest:DataBuffer, _to:Int, from:Int, count:Int, numComponents:Int, sStride:Int, dStride:Int) = "CopyUBytesToDatabuffer4"

Function CopyBytesFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0)
Function CopyShortsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0)
Function CopyIntsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int = 0)
Function CopyFloatsFromDataBuffer:Void(source:DataBuffer, dest:Float[], _to:Int = 0)

Function CopyBytesFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int) = "CopyBytesFromDataBuffer2"
Function CopyShortsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int) = "CopyShortsFromDataBuffer2"
Function CopyIntsFromDataBuffer:Void(source:DataBuffer, dest:Int[], _to:Int, from:Int, count:Int) = "CopyIntsFromDataBuffer2"
Function CopyFloatsFromDataBuffer:Void(source:DataBuffer, dest:Float[], _to:Int, from:Int, count:Int) = "CopyFloatsFromDataBuffer2"

#End
