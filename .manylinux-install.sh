#!/usr/bin/env bash

set -e -x

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "${PYBIN}" == *"cp35"* ]] || \
       [[ "${PYBIN}" == *"cp36"* ]] || \
       [[ "${PYBIN}" == *"cp37"* ]] || \
       [[ "${PYBIN}" == *"cp38"* ]]; then
        "${PYBIN}/pip" install virtualenv
        "${PYBIN}/python" -m virtualenv .venv
        source .venv/bin/activate
        pip install -e /io/
        pip wheel /io/ -w wheelhouse/
        pip install tox
        cd /io/
        tox -e $toxenv py`echo "${PYBIN}" | cut -f 4 -d"/" | cut -f 1 -d"-" | cut -c3-`
        cd ..
        deactivate
        rm -rf .venv        
    fi
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/zope.interface*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done
