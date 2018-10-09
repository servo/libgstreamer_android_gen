# libgstreamer_android_gen
This tool generates a `libgstreamer_android.so` library with all
[GStreamer](https://gstreamer.freedesktop.org/) dependencies for
[Servo Media](https://github.com/ferjm/media) and some Java code
required to initialize Gstreamer on Android.

It makes use of
[GStreamer ndk-build Makefiles](https://cgit.freedesktop.org/gstreamer/cerbero/tree/data/ndk-build)
that in summary do:
* override the path of the pkg-config files
* collect all gstreamer plugins that were selected and their dependencies
* generate a C source file that does the gstreamer/android initialization
* link all this together into a single `libgstreamer_android.so`, which is
necessary for non-latest Android as the number of shared libraries a process
can load was seriously limited (64 or so? you can easily have that many gstreamer plugins)
* provide a `GStreamer.java` that loads all this

## Build
Install the Android [NDK](https://developer.android.com/ndk/guides/index.html#install).
The recommended NDK version is [r16b](https://developer.android.com/ndk/downloads/older_releases.html).

Download [GStreamer prebuilt binaries](https://gstreamer.freedesktop.org/data/pkg/android/)
for Android. The current version known to work with [gstreamer-rs](https://github.com/sdroege/gstreamer-rs)
is [1.14.3](https://gstreamer.freedesktop.org/data/pkg/android/1.14.3/)

The ndk-build Makefiles need to know where you installed the GStreamer binaries.
You must define an environment variable called `GSTREAMER_ROOT_ANDROID` and point it to the
folder where you extracted the GStreamer binaries. This environment variable must be available
at build time, so maybe you want to make it available system-wide by adding it to your `~/.profile` file.

If you need to add extra GStreamer plugins, list them
[here](https://github.com/ferjm/libgstreamer_android_gen/blob/master/jni/Android.mk#L29).

Finally run:

```bash
./build.sh
```

This should generate an `out` folder containing a zip file per architecture including the
`libgstreamer_android.so` and a `src.zip` file with the generated `GStreamer.java` among others.

## Deploy
The GStreamer binaries per each platform are deployed to Servo's AWS S3 space.

In order to deploy new binaries you need the [s3cmd](https://s3tools.org/s3cmd) tool and authorized access to Servo's S3.

The generated binaries are named with this nomenclature: `gstreamer-<target>-<version>-<date>-<time>.zip` and are meant to be uploaded to `http://servo-deps.s3.amazonaws.com/gstreamer`.

An example command to upload new binaries to http://servo-deps.s3.amazonaws.com/gstreamer/gstreamer-armeabi-v7a-1.14.3-20181004-142930.zip:
```
./s3cmd put ~/dev/gstreamer/libgstreamer_android_gen/out/gstreamer-armeabi-v7a-1.14.3-20181004-142930.zip s3://servo-deps/gstreamer/gstreamer-armeabi-v7a-1.14.3-20181004-142930.zip -P
```
