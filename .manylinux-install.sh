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
        echo "***************************** PYBIN **************************************************"
        echo "${PYBIN}"
        "${PYBIN}/pip" install virtualenv
        "${PYBIN}/python" -m virtualenv .venv
        source .venv/bin/activate
        "${PYBIN}/pip" install tox
        "${PYBIN}/pip" install zope.interface --no-index -f wheelhouse/
        tox
        #fi   
    fi
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/zope.interface*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done
