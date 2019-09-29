#
# Copyright (C) 2013 The Android Open-Source Project
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

# Device modules
PRODUCT_PACKAGES += \
    egl.cfg \
    gralloc.anbox \
    gralloc.anbox.default \
    libGLESv1_CM_emulation \
    lib_renderControl_enc \
    libEGL_emulation \
    libGLES_android \
    libGLESv2_enc \
    libOpenglSystemCommon \
    libGLESv2_emulation \
    libGLESv1_enc \
    libEGL_swiftshader \
    libGLESv1_CM_swiftshader \
    libGLESv2_swiftshader \
    qemu-props \
    camera.anbox \
    camera.anbox.jpeg \
    audio.primary.anbox \
    audio.primary.anbox_legacy \
    android.hardware.audio@2.0-service \
    power.anbox \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl \
    hwcomposer.anbox \
    sh_vendor \
    vintf \
    toybox_vendor \
    CarrierConfig \
    audio.r_submix.default \
    local_time.default \
    SdkSetup \
    android.hardware.wifi@1.0-service
#    lights.goldfish \
#    gps.goldfish \
#    fingerprint.goldfish \
#    sensors.goldfish \
#    android.hardware.biometrics.fingerprint@2.1-service \
#    vibrator.goldfish \

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.broadcastradio@1.1-service \
    android.hardware.broadcastradio@1.0-impl \
    android.hardware.soundtrigger@2.0-impl

PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0-strongbox-service-anbox

#PRODUCT_PACKAGES += \
#    android.hardware.gnss@1.0-service \
#    android.hardware.gnss@1.0-impl

#PRODUCT_PACKAGES += \
#    android.hardware.sensors@1.0-impl \
#    android.hardware.sensors@1.0-service

PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.0-impl

PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

#PRODUCT_PACKAGES += \
#    camera.device@1.0-impl \
#    android.hardware.camera.provider@2.4-service \
#    android.hardware.camera.provider@2.4-impl \

#PRODUCT_PACKAGES += \
#    android.hardware.gatekeeper@1.0-impl \
#    android.hardware.gatekeeper@1.0-service

# need this for gles libraries to load properly
# after moving to /vendor/lib/
PRODUCT_PACKAGES += \
    vndk-sp

PRODUCT_COPY_FILES += \
    vendor/anbox/android/fstab.goldfish:root/fstab.anbox \
    vendor/anbox/android/init.goldfish.rc:root/init.anbox.rc \
    vendor/anbox/android/init.goldfish.sh:system/etc/init.anbox.sh \
    vendor/anbox/android/ueventd.goldfish.rc:root/ueventd.anbox.rc \
    frameworks/av/media/libeffects/data/audio_effects.conf:system/etc/audio_effects.conf \
    hardware/libhardware_legacy/audio/audio_policy.conf:system/etc/audio_policy.conf \
    vendor/anbox/android/camera/media_profiles.xml:system/etc/media_profiles.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    vendor/anbox/android/camera/media_codecs.xml:system/etc/media_codecs.xml \
    vendor/anbox/android/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

PRODUCT_CHARACTERISTICS := emulator

PRODUCT_FULL_TREBLE_OVERRIDE := true

# Include drawables for all densities
PRODUCT_AAPT_CONFIG := normal

PRODUCT_COPY_FILES += \
    vendor/anbox/android/anbox-init.sh:root/anbox-init.sh \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.software.autofill.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.autofill.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    vendor/anbox/android/anbox.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/anbox.xml

PRODUCT_PACKAGES += \
    anboxd \
    hwcomposer.anbox \
    AnboxAppMgr

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware=anbox \
    ro.hardware.hwcomposer=anbox \
    ro.kernel.qemu.gles=1 \
    ro.kernel.qemu=1
    ro.adb.qemud=1

# Disable any software key elements in the UI
PRODUCT_PROPERTY_OVERRIDES += \
    qemu.hw.mainkeys=1

# Let everything know we're running inside a container
PRODUCT_PROPERTY_OVERRIDES += \
    ro.anbox=1 \
    ro.boot.container=1

# We don't want telephony support for now
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=yes

# Disable boot-animation permanently
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.nobootanimation=1

# Enable Perfetto traced
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.traced.enable=1

# disable setupwizard
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.setupwizard.mode=DISABLED

DEVICE_PACKAGE_OVERLAYS += \
    vendor/anbox/android/overlay

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
# Extend heap size we use for dalvik/art runtime
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
