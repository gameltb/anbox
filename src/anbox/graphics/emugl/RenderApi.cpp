/*
* Copyright (C) 2011-2015 The Android Open Source Project
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#include "anbox/graphics/emugl/RenderApi.h"
#include "anbox/graphics/emugl/DispatchTables.h"

#include "external/android/android-emugl/host/include/OpenGLESDispatch/EGLDispatch.h"
#include "external/android/android-emugl/host/include/OpenGLESDispatch/GLESv1Dispatch.h"
#include "external/android/android-emugl/host/include/OpenGLESDispatch/GLESv2Dispatch.h"

#include "external/android/android-emugl/shared/emugl/common/crash_reporter.h"

#include <string.h>

GLESv2Dispatch s_gles2;
GLESv1Dispatch s_gles1;

namespace {
constexpr const char *default_egl_lib{"libEGL.so.1"};
constexpr const char *default_glesv2_lib{"libGLESv2.so.2"};
}

namespace anbox {
namespace graphics {
namespace emugl {
std::vector<GLLibrary> default_gl_libraries() {
  return std::vector<GLLibrary>{
    {GLLibrary::Type::EGL, default_egl_lib},
    {GLLibrary::Type::GLESv2, default_glesv2_lib},
  };
}

bool initialize(const std::vector<GLLibrary> &libs) {

  for (const auto &lib : libs) {
    const auto path = lib.path.c_str();
    switch (lib.type) {
    case GLLibrary::Type::EGL:
      if (!init_egl_dispatch(path))
        return false;
      break;
    case GLLibrary::Type::GLESv1:
      if (!gles1_dispatch_init(path, &s_gles1))
        return false;
      break;
    case GLLibrary::Type::GLESv2:
      if (!gles2_dispatch_init(path, &s_gles2))
        return false;
      break;
    default:
      break;
    }
  }

  return true;
}
}  // namespace emugl
}  // namespace graphics
}  // namespace anbox
