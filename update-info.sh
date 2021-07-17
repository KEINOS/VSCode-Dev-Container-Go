#!/bin/bash
# =============================================================================
#  イメージに含まれているパッケージなどの情報をファイルに出力します。
# =============================================================================

set -eu

NAME_TAG_IMG='test:local'
NAME_FILE_INFO='image_info.txt'
PATH_FILE_INFO="./${NAME_FILE_INFO}"

docker build -t "$NAME_TAG_IMG" . || {
    echo >&2 "Error during building image"
    exit 1
}

result=$(docker run --rm -v "$(pwd):/root" --user root --workdir /root "$NAME_TAG_IMG" ./print_info_image.sh 2>&1) || {
    echo >&2 "Error during running image"
    exit 1
}
echo "$result" > "$PATH_FILE_INFO"
