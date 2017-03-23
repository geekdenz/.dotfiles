#!/bin/sh
pushd vim/bundle
ls -1 | while read f
do
	pushd $f
	git pull
	popd
done
popd
