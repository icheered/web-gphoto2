#!/bin/sh

# Copyright 2021 Google LLC
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

if [ -z "$CI" ]
then
	DOCKER_INTERACTIVE_OPTS="-it"
else
	DOCKER_INTERACTIVE_OPTS=""
fi

docker build -t web-gphoto2 - < Dockerfile
docker run --rm $DOCKER_INTERACTIVE_OPTS \
	-v $PWD:/src \
	-u $(id -u):$(id -g) \
	web-gphoto2 \
	$@

# Force web worker to be a module
sed -i 's/new URL("libapi.worker.js",import.meta.url)/new URL("libapi.worker.js",import.meta.url, {type: "module"})/g' build/libapi.mjs