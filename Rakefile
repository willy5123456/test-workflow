require 'zip'

GIT_ROOT = `git rev-parse --show-toplevel`.strip
VERSION = '1.0.0'
LIBWEBP = "libwebp"

desc "default"
task :default do
  sh 'rake -T'
end

desc "auto"
task :auto do
  File.open("auto.so", "w") do |f|
    f.puts 'hellworld'
  end
  
  Zip::File.open("auto.zip", create: true) do |zip_file|
    zip_file.add('auto.so', 'auto.so')
  end
end

desc "update library_android"
task :update_library_android do
  # android-ndk: https://developer.android.com/ndk/downloads
  ANDROID_MK = 'Android.mk'

  build_dir = 'build/android'
  lib_armeabi_v7a_dir = "#{GIT_ROOT}/lib/android/armeabi-v7a"
  lib_x86_dir = "#{GIT_ROOT}/lib/android/x86"
  lib_x86_64_dir = "#{GIT_ROOT}/lib/android/x86_64"
  lib_arm64_v8a_dir  = "#{GIT_ROOT}/lib/android/arm64-v8a"

  FileUtils.mkdir_p(build_dir) unless File.directory?(build_dir)
  FileUtils.mkdir_p(lib_x86_dir) unless File.directory?(lib_x86_dir)
  FileUtils.mkdir_p(lib_armeabi_v7a_dir) unless File.directory?(lib_armeabi_v7a_dir)
  FileUtils.mkdir_p(lib_arm64_v8a_dir) unless File.directory?(lib_arm64_v8a_dir)
  FileUtils.mkdir_p(lib_x86_64_dir) unless File.directory?(lib_x86_64_dir)

  Dir.chdir(build_dir) do
    sh 'git clone https://github.com/webmproject/libwebp.git'

    Dir.chdir('libwebp') do
      sh "git checkout #{VERSION}"

      # to enable build shared library
      File.open(ANDROID_MK, "r") do |orig|
        # File.unlink(ANDROID_MK)
        o = orig.read()
        File.open(ANDROID_MK, "w") do |new|
          new.puts 'ENABLE_SHARED := 1'
          new.write(o)
        end
      end

      NDK_BUILD_FPATH = "#{Dir.home}/android-ndk-r20/ndk-build"
      sh "#{NDK_BUILD_FPATH} NDK_PROJECT_PATH=#{Dir.pwd} APP_BUILD_SCRIPT=#{Dir.pwd}/#{ANDROID_MK}"

      ['libwebp.so', 'libwebpdecoder.so', 'libwebpdemux.so', 'libwebpmux.so'].each do |so|
        cp_r "libs/armeabi-v7a/#{so}", lib_armeabi_v7a_dir
        cp_r "libs/arm64-v8a/#{so}", lib_arm64_v8a_dir
        cp_r "libs/x86/#{so}", lib_x86_dir
        cp_r "libs/x86_64/#{so}", lib_x86_64_dir
      end
    end
  end
end