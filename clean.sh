#!/bin/bash

root_path=$(cd "$(dirname "$0")"; pwd)
build_path=$root_path/BUILD

echo "Cleaning $build_path..."
rm -rf $build_path
