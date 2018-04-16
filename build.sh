ndk-build

rm -rf libs obj

cp -r $GSTREAMER_ROOT_ANDROID/arm/lib/pkgconfig gst-build-armeabi/
cp -r $GSTREAMER_ROOT_ANDROID/arm64/lib/pkgconfig gst-build-arm64-v8a/
cp -r $GSTREAMER_ROOT_ANDROID/armv7/lib/pkgconfig gst-build-armeabi-v7a/
cp -r $GSTREAMER_ROOT_ANDROID/x86/lib/pkgconfig gst-build-x86/
cp -r $GSTREAMER_ROOT_ANDROID/x86_64/lib/pkgconfig gst-build-x86_64/

mkdir out

for D in gst-build-armeabi gst-build-arm64-v8a gst-build-armeabi-v7a gst-build-x86 gst-build-x86_64
do
  echo 'Processing '$D
  cd $D
  sed -i -e 's?libdir=.*?libdir='`pwd`'?g' pkgconfig/*
  sed -i -e 's?.* -L${.*?Libs: -L${libdir} -lgstreamer_android?g' pkgconfig/*
  sed -i -e 's?Libs:.*?Libs: -L${libdir} -lgstreamer_android?g' pkgconfig/*
  sed -i -e 's?Libs.private.*?Libs.private: -lgstreamer_android?g' pkgconfig/*
  rm -rf pkgconfig/*-e*
  cd ..
  zip -v out/$D.zip $D/* -r
  rm -rf $D
done

zip -v out/src.zip src -r
rm -rf src
