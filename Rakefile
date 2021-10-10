require 'zip'

GIT_ROOT = `git rev-parse --show-toplevel`.strip
VERSION = '1.0.0'
LIBWEBP = "libwebp"

desc "default"
task :default do
  sh 'rake -T'
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
    puts '==== Clone webp'
    sh 'git clone https://github.com/webmproject/libwebp.git'

    Dir.chdir('libwebp') do
      puts '==== checkout'
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

      puts '==== NDK build'
      # NDK_BUILD_FPATH = "#{Dir.home}/android-ndk-r20/ndk-build"
      sh "ndk-build NDK_PROJECT_PATH=#{Dir.pwd} APP_BUILD_SCRIPT=#{Dir.pwd}/#{ANDROID_MK}"

      ['libwebp.so', 'libwebpdecoder.so', 'libwebpdemux.so', 'libwebpmux.so'].each do |so|
        cp_r "libs/armeabi-v7a/#{so}", lib_armeabi_v7a_dir
        cp_r "libs/arm64-v8a/#{so}", lib_arm64_v8a_dir
        cp_r "libs/x86/#{so}", lib_x86_dir
        cp_r "libs/x86_64/#{so}", lib_x86_64_dir
      end
    end
  end
end

# Usage:
#   directory_to_zip = "/tmp/input"
#   output_file = "/tmp/out.zip"
#   zf = ZipFileGenerator.new(directory_to_zip, output_file)
#   zf.write()
class ZipFileGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
  end

  # Zip the input directory.
  def write
    entries = Dir.entries(@input_dir) - %w[. ..]

    ::Zip::File.open(@output_file, create: true) do |zipfile|
      write_entries entries, '', zipfile
    end
  end

  private

  # A helper method to make the recursion work.
  def write_entries(entries, path, zipfile)
    entries.each do |e|
      zipfile_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(@input_dir, zipfile_path)

      if File.directory? disk_file_path
        recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
      else
        put_into_archive(disk_file_path, zipfile, zipfile_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
    zipfile.mkdir zipfile_path
    subdir = Dir.entries(disk_file_path) - %w[. ..]
    write_entries subdir, zipfile_path, zipfile
  end

  def put_into_archive(disk_file_path, zipfile, zipfile_path)
    zipfile.add(zipfile_path, disk_file_path)
  end
end



desc "auto"
task :auto do
  FileUtils.mkdir_p('_output') unless File.directory?('_output')
  Dir.chdir('_output') do
    File.open("auto.so", "w") do |f|
      f.puts 'hellworld'
    end
  end
  
  zf = ZipFileGenerator.new('_output', 'auto.zip')
  zf.write()
end

desc "zip library_android"
task :zip_library_android do
  zf = ZipFileGenerator.new('lib', 'android.zip')
  zf.write()
end

desc "update library_macos"
task :update_library_macos do
  build_dir = 'build/macos'
  lib_dir = "#{GIT_ROOT}/lib/macos_64"

  FileUtils.mkdir_p(build_dir) unless File.directory?(build_dir)
  FileUtils.mkdir_p(lib_dir) unless File.directory?(lib_dir)

  Dir.chdir(build_dir) do
    sh 'git clone https://github.com/webmproject/libwebp.git'
    Dir.chdir('libwebp') do
      sh "git checkout #{VERSION}"
      sh './autogen.sh'
      sh "./configure --prefix=`pwd`/.lib --enable-everything --disable-static"
      sh 'make && make install'
    end

    cp_r `realpath libwebp/.lib/lib/libwebp.dylib`.strip, lib_dir
    cp_r `realpath libwebp/.lib/lib/libwebpdecoder.dylib`.strip, lib_dir
    cp_r `realpath libwebp/.lib/lib/libwebpdemux.dylib`.strip, lib_dir
    cp_r `realpath libwebp/.lib/lib/libwebpmux.dylib`.strip, lib_dir
  end
end

desc "zip library_macos"
task :zip_library_macos do
  zf = ZipFileGenerator.new('lib', 'macos.zip')
  zf.write()
end
