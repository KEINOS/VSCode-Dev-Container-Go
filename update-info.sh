#!/bin/bash
# =============================================================================
#  イメージに含まれているパッケージなどの情報をファイルに出力します。
#  このスクリプトはローカルで実行してください。
# =============================================================================

NAME_TAG_IMG='ghcr.io/keinos/vscode-dev-container-go:latest'
NAME_FILE_INFO='image_info.txt'
PATH_FILE_INFO="./${NAME_FILE_INFO}"
PATH_FILE_SCRIPT='./update-info.sh'

# -----------------------------------------------------------------------------
#  Latest イメージを Pull して、コンテナ内でこのファイルを実行し、結果をファイル
#  に保存します。
# -----------------------------------------------------------------------------

if [ ! -r "/.dockerenv" ]; then
    set -eu

    docker pull "${NAME_TAG_IMG}"

    result=$(docker run --rm -v "$(pwd):/root/mnt" --user root --workdir "/root/mnt" "${NAME_TAG_IMG}" "${PATH_FILE_SCRIPT}" 2>&1) || {
        echo >&2 "${result}"
        echo >&2 "Error during running image"

        exit 1
    }
    echo "${result}" >"${PATH_FILE_INFO}"

    git add .
    git status | grep 'modified:' && {
        git commit -m "Update image info" || {
            echo >&2 "Error during commit"

            exit 1
        }
        git push origin main || {
            echo >&2 "Error during push"

            exit 1
        }
    }

    exit 0
fi

# -----------------------------------------------------------------------------
#  コンテナ内でこのスクリプトが実行された場合に実行されるコードです。
# -----------------------------------------------------------------------------
result=$(shfmt -d "${PATH_FILE_SCRIPT}") || {
    echo >&2 "Error during running shfmt"
    echo >&2 "${result}"

    exit 1
}

result=$(shellcheck --shell=sh "${PATH_FILE_SCRIPT}") || {
    echo >&2 "Error during running shellcheck"
    echo >&2 "${result}"

    exit 1
}

echo '==============================================================================='
echo ' OS Info'
echo '==============================================================================='
cat /etc/os-release

echo '==============================================================================='
echo ' Program Lang Info'
echo '==============================================================================='
go version

echo '==============================================================================='
echo ' Installed Go packages'
echo '==============================================================================='
ls -1A "/go/bin"

echo '==============================================================================='
echo ' Installed apt packages'
echo '==============================================================================='
result="$(apk info 2>&1)"
echo "${result}" | grep -v WARNING | sort
