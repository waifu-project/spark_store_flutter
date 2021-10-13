flutter build linux

rm -rf debian/usr/bin/*

cp -rf build/linux/x64/release/bundle/* debian/usr/bin/

dpkg -b debian build/spark_store.deb