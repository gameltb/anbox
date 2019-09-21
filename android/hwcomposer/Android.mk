#
# Copyright 2015 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_VENDOR_MODULE := true
emulator_hwcomposer_shared_libraries := \
    liblog \
    libutils \
    libcutils \
    libEGL \
    libutils \
    libhardware \
    libsync \
    libui \
    lib_renderControl_enc \
    libOpenglSystemCommon

emulator_hwcomposer_src_files := \
    hwcomposer.cpp

emulator_hwcomposer_cflags += \
    -DLOG_TAG=\"hwcomposer\"

emulator_hwcomposer_c_includes += \
    system/core/libsync \
    system/core/libsync/include \
    $(LOCAL_PATH)/../opengl/host/include/libOpenglRender \
    $(LOCAL_PATH)/../opengl/shared/OpenglCodecCommon \
    $(LOCAL_PATH)/../opengl/system/renderControl_enc \
    $(LOCAL_PATH)/../opengl/system/OpenglSystemCommon

emulator_hwcomposer_relative_path := hw

# GOLDFISH BUILD
LOCAL_SHARED_LIBRARIES := $(emulator_hwcomposer_shared_libraries)
LOCAL_SRC_FILES := $(emulator_hwcomposer_src_files)
LOCAL_CFLAGS := $(emulator_hwcomposer_cflags)
LOCAL_C_INCLUDES := $(emulator_hwcomposer_c_includes)
LOCAL_MODULE_RELATIVE_PATH := $(emulator_hwcomposer_relative_path)

LOCAL_MODULE := hwcomposer.anbox
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

# RANCHU BUILD
include $(CLEAR_VARS)

LOCAL_VENDOR_MODULE := true
LOCAL_SHARED_LIBRARIES := $(emulator_hwcomposer_shared_libraries)
LOCAL_SRC_FILES := $(emulator_hwcomposer_src_files)
LOCAL_CFLAGS := $(emulator_hwcomposer_cflags)
LOCAL_C_INCLUDES := $(emulator_hwcomposer_c_includes)
LOCAL_MODULE_RELATIVE_PATH := $(emulator_hwcomposer_relative_path)

LOCAL_MODULE := hwcomposer.ranchu
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)
