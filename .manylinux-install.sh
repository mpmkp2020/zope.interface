#!/usr/bin/env bash

set -e -x

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "${PYBIN}" == *"cp35"* ]] && toxenv=py35 || \
       [[ "${PYBIN}" == *"cp36"* ]] && toxenv=py36 || \
       [[ "${PYBIN}" == *"cp37"* ]] && toxenv=py37 || \
       [[ "${PYBIN}" == *"cp38"* ]] && toxenv=py38; then
        "${PYBIN}/pip" install virtualenv
        "${PYBIN}/python" -m virtualenv .venv
        source .venv/bin/activate
        pip --version
        pip install -e /io/
        pip wheel /io/ -w wheelhouse/
        pip install tox
        ls /wheelhouse
        cd /io/
        #tox -e $toxenv
        cd ..
        deactivate
        ls -al
        rm -rf .venv        
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
