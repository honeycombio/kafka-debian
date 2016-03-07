#!/bin/bash

step=1

echo_step() {
    echo -en "\e[1m\e[92m"
    echo -n "#$((step++)): $1"
    echo -e "\e[0m" 
}

set -e # Exit on error

if [ ! -f `which debuild` ]; then
    echo "ERROR: debuild command not found. Please install the 'devscripts' package."
    exit 1
fi

root_path=$(cd "$(dirname "$0")"; pwd)
build_path=$root_path/BUILD
url=$1

if [ -z "$url" ]; then
    echo "Pass this the URL to the Kafka binary tarball"
    echo "$0 <URL>"
    exit 1
fi

mkdir -p $build_path
cd $build_path

tarball_name=`echo $url | perl -l -ne '/\/([^\/]+)$/ && print $1'`
tarball_dir=`echo $tarball_name | perl -l -ne '/([^\/]+?)\.tgz$/ && print $1'`
kafka_version=`echo $url | perl -l -ne '/kafka_[0-9\.]+-([0-9\.]+)\.tgz$/ && print $1'`
staging_dir="kafka-$kafka_version"
tarball_path=$build_path/$tarball_dir
staging_path=$build_path/$staging_dir

echo_step "Downloading tarball for v"$kafka_version"..."

if [ -f "$tarball_name" ]; then
    echo "It looks like we've already downloaded $tarball_name, skipping."
else
    curl -o $build_path/$tarball_name $url
fi

echo_step "Unpacking tarball..."
tar --extract --file $tarball_name

if [ ! -d "$tarball_path" ]; then
    echo "Expected tarball to extract directory: $tarball_dir, and it didn't."
    exit 1
fi

alias_path="$build_path/kafka_"$kafka_version".orig.tar.gz"
rm -f $alias_path
ln -s $build_path/$tarball_name $alias_path

echo_step "Staging debian files in directory..."
rm -rf $staging_path
mv $tarball_path $staging_path
cp -r $root_path/debian $staging_path 

echo_step "Building package..."
cd $staging_path
dch --newversion=$kafka_version-0 --distribution unstable "v$kafka_version" 
debuild --no-tgz-check -uc -us

echo ""
echo "FINISHED. look in BUILD/ directory for packages."
