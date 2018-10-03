ndk-build

cp -r libs/armeabi-v7a/libgstreamer_android.so gst-build-armeabi-v7a/
cp -r $GSTREAMER_ROOT_ANDROID/armv7/lib/pkgconfig gst-build-armeabi-v7a/
cp -r libs/x86/libgstreamer_android.so gst-build-x86/
cp -r $GSTREAMER_ROOT_ANDROID/x86/lib/pkgconfig gst-build-x86/

rm -rf libs obj

mkdir out

for D in gst-build-armeabi-v7a gst-build-x86
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
