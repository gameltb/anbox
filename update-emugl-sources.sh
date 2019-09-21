#/usr/bin/sh

EMUGEN=$PWD/build/external/android/android-emugl/emugen_ext/emugen

ENCODER_TOP_DIR=$PWD/android/opengl/system

DECODER_TOP_DIR=$PWD/external//android/android-emugl/host/libs

# GLESv1 encoder
GLESv1_INPUT_DIR=$DECODER_TOP_DIR/GLESv1_dec
GLESv2_INPUT_DIR=$DECODER_TOP_DIR/GLESv2_dec
RENDERCONTROL_INPUT_DIR=$DECODER_TOP_DIR/renderControl_dec

# The encoder has prefix GL while decoder has GLES
cp -f $DECODER_TOP_DIR/GLESv1_dec/gles1.attrib $DECODER_TOP_DIR/GLESv1_dec/gl.attrib
cp -f $DECODER_TOP_DIR/GLESv1_dec/gles1.in $DECODER_TOP_DIR/GLESv1_dec/gl.in
cp -f $DECODER_TOP_DIR/GLESv1_dec/gles1.types $DECODER_TOP_DIR/GLESv1_dec/gl.types

cp -f $DECODER_TOP_DIR/GLESv2_dec/gles2.attrib $DECODER_TOP_DIR/GLESv2_dec/gl2.attrib
cp -f $DECODER_TOP_DIR/GLESv2_dec/gles2.in $DECODER_TOP_DIR/GLESv2_dec/gl2.in
cp -f $DECODER_TOP_DIR/GLESv2_dec/gles2.types $DECODER_TOP_DIR/GLESv2_dec/gl2.types

$EMUGEN -i $DECODER_TOP_DIR/GLESv1_dec -E $ENCODER_TOP_DIR/GLESv1_enc gl
$EMUGEN -i $DECODER_TOP_DIR/GLESv2_dec -E $ENCODER_TOP_DIR/GLESv2_enc gl2
$EMUGEN -i $DECODER_TOP_DIR/renderControl_dec -E $ENCODER_TOP_DIR/renderControl_enc renderControl

rm $DECODER_TOP_DIR/GLESv1_dec/gl.attrib
rm $DECODER_TOP_DIR/GLESv1_dec/gl.in
rm $DECODER_TOP_DIR/GLESv1_dec/gl.types

rm $DECODER_TOP_DIR/GLESv2_dec/gl2.attrib
rm $DECODER_TOP_DIR/GLESv2_dec/gl2.in
rm $DECODER_TOP_DIR/GLESv2_dec/gl2.types