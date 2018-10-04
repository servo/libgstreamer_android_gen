if [[ -z "${TARGET}" ]]; then
  TARGET="armv7"
fi

NDK_APPLICATION_MK="jni/${TARGET}.mk"
echo "Building for target ${TARGET} with ${NDK_APPLICATION_MK}"

ndk-build NDK_APPLICATION_MK=$NDK_APPLICATION_MK

if [ $TARGET = "armv7" ]; then
  LIB="armeabi-v7a"
else
  LIB="x86"
fi;

GST_LIB="gst-build-${LIB}"

cp -r libs/${LIB}/libgstreamer_android.so ${GST_LIB}
cp -r $GSTREAMER_ROOT_ANDROID/${TARGET}/lib/pkgconfig ${GST_LIB}

rm -rf libs obj out

mkdir out

echo 'Processing '$GST_LIB
cd $GST_LIB
sed -i -e 's?libdir=.*?libdir='`pwd`'?g' pkgconfig/*
sed -i -e 's?.* -L${.*?Libs: -L${libdir} -lgstreamer_android?g' pkgconfig/*
sed -i -e 's?Libs:.*?Libs: -L${libdir} -lgstreamer_android?g' pkgconfig/*
sed -i -e 's?Libs.private.*?Libs.private: -lgstreamer_android?g' pkgconfig/*
rm -rf pkgconfig/*-e*
cd ..
zip -v out/$GST_LIB.zip $GST_LIB/* -r
rm -rf $GST_LIB

zip -v out/src.zip src -r
rm -rf src
