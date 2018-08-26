#! /bin/sh

SCRIPT_DIR=$(cd $(dirname $(readlink $0 || echo $0));pwd)
ruby -Ilib export.rb
