//
// Copyright (c) 2002-2012 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// system.h: Includes Windows system headers and undefines macros that conflict.

#ifndef COMMON_SYSTEM_H
#define COMMON_SYSTEM_H

#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif

#include <windows.h>

#include "common/winrtplatform.h"


#if defined(ANGLE_PLATFORM_WINRT)
#include <wrl\client.h>
typedef Microsoft::WRL::ComPtr<IUnknown> AngleNativeWindowHDC;
#else
typedef HDC AngleNativeWindowHDC;
#endif //#if defined(WINAPI_FAMILY)


#if defined(min)
#undef min
#endif

#if defined(max)
#undef max
#endif

#endif   // COMMON_SYSTEM_H
