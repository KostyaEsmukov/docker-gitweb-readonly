#!/bin/bash

set -o errexit
set -o xtrace

main() {
    cleanup
    export GITWEB_BASE_PATH="$1"
    create_repo
    init_docker_container

    sleep 3

    assert_http_200
    assert_can_clone
    assert_cannot_push
}

create_repo() {
    mkdir myrepo
    cd myrepo
    git init
    echo hi > file.txt
    git add .
    git commit -m "initial"
    cd ..
}

init_docker_container() {
    docker-compose up -d --build
}

assert_http_200() {
    echo "assert_http_200..."
    curl --fail --silent --show-error --output /dev/null \
        http://localhost:8080"${GITWEB_BASE_PATH}"/ || exit 1
    echo "OK!"
}

assert_can_clone() {
    echo "assert_can_clone..."
    git clone http://localhost:8080"${GITWEB_BASE_PATH}"/myrepo.git myrepo.clone
    [[ -f "myrepo.clone/file.txt" ]] || exit 1
    echo "OK!"
}

assert_cannot_push() {
    echo "assert_cannot_push..."
    cd myrepo.clone
    echo world >> file
    git add .
    git commit -m "new"
    git push && exit 1 || true
    echo "OK!"
}

cleanup() {
    docker-compose down
    rm -Rf myrepo*
}

if [ ! -r "docker-compose.yml" ]; then
    echo "Must be run from the `test` dir"
    exit 1
fi
trap cleanup EXIT
main
main "/my/prefix"
