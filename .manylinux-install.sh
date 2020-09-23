#!/usr/bin/env bash

set -e -x

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "${PYBIN}" == *"cp27"* ]] || \
       [[ "${PYBIN}" == *"cp35"* ]] || \
       [[ "${PYBIN}" == *"cp36"* ]] || \
       [[ "${PYBIN}" == *"cp37"* ]] || \
       [[ "${PYBIN}" == *"cp38"* ]]; then
        "${PYBIN}/pip" install -e /io/
        "${PYBIN}/pip" wheel /io/ -w wheelhouse/
        rm -rf /io/build /io/*.egg-info
        #if [[ arch == "arm64" ]]; then
        echo "inside aarch64"
        REGEX="cp3([0-9])*"
        echo "REGEX"
        echo $REGEX
        PY_LIMITED="py3${REGEX[1]}"
        echo $PY_LIMITED
        "${PYBIN}/pip" install tox
        "${PYBIN}/pip" install zope.interface --no-index -f wheelhouse/
        tox -e $PY_LIMITED
        #fi   
    fi
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/zope.interface*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done
