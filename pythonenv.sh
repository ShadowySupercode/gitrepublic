#! /bin/bash

WORKSPACE=$(dirname $(readlink -f ${0}))

# if there is no python vir
if [[ -z $(ls -A "${WORKSPACE}/.venv/") ]]; then
    echo "No virtual environment has been detected. Creating a venv now!"
    python3 -m venv "${WORKSPACE}/.venv/"
fi
