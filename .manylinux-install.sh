#!/usr/bin/env bash

set -e -x

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "${PYBIN}" == *"cp35"* ]] || \
       [[ "${PYBIN}" == *"cp36"* ]] || \
       [[ "${PYBIN}" == *"cp37"* ]] || \
       [[ "${PYBIN}" == *"cp38"* ]]; then
        "${PYBIN}/pip" install -e /io/
        "${PYBIN}/python" -m pip install tox /io/
        "${PYBIN}/pip" wheel /io/ -w wheelhouse/
        cd /io/
        "${PYBIN}/python" -m pip install tox
        #"${PYBIN}/python" -m virtualenv .venv
        #source .venv/bin/activate
        tox
        #rm -rf /io/build /io/*.egg-info
        #if [[ arch == "arm64" ]]; then
        echo "***************************** PYBIN **************************************************"
        #echo "${PYBIN}"
        #"${PYBIN}/pip" install virtualenv
        #"${PYBIN}/python" -m virtualenv .venv
        #source .venv/bin/activate
        #"${PYBIN}/pip" install tox
        #pwd
        #ls $HOME
        #"${PYBIN}/pip" install zope.interface --no-index -f wheelhouse/
        #cd $HOME/zope.interface
        #"${PYBIN}/pip" install zope.interface --no-index -f wheelhouse/
        #bash tox
        #fi   
    fi
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/zope.interface*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done
