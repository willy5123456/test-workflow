git clone https://github.com/jedisct1/libsodium.git && cd libsodium
git checkout tags/1.0.18

CD ..

libsodium\builds\msvc\build\buildbase.bat libsodium\builds\msvc\vs2019\libsodium.sln 16
