#!/bin/bash
# =============================================================================
#  Dev Container Functionality Tests
# =============================================================================
#  This script will build the container and builds the sample app (./tests)
#  inside.

# -----------------------------------------------------------------------------
#  Constants
# -----------------------------------------------------------------------------

NAME_IMAGE_DOCKER="test:local"
NAME_SCRIPT_SELF="${0}"
PATH_DIR_CURRENT="$(cd . && pwd)"
TRUE=0
FALSE=1
FAILURE=1
SUCCESS=0

# -----------------------------------------------------------------------------
#  Functions
# -----------------------------------------------------------------------------

cdOrExit() {
    cd "${1}" || {
        echo >&2 'NG. Failed to change test directory'
        exit "${FAILURE}"
    }
}

isInsideDocker() {
    if [ -f /.dockerenv ]; then
        return "${TRUE}"
    fi

    return "${FALSE}"
}

isInstalled() {
    which "$1" 2>/dev/null 1>/dev/null || {
        return "${FALSE}"
    }

    return "${TRUE}"
}

# -----------------------------------------------------------------------------
#  Main for local run. (Run only if not inside Docker container)
# -----------------------------------------------------------------------------
if (! isInsideDocker) && (! isInstalled docker); then
    echo >&2 "ERROR: Docker is not installed."
    exit "${FAILURE}"
fi

if (! isInsideDocker) && (isInstalled docker); then
    printf "%s" '- Building Docker image for test ... '
    result=$(docker build --tag "$NAME_IMAGE_DOCKER" . 2>&1 3>&1) || {
        echo 'NG'
        echo >&2 "${result}"
        exit "${FAILURE}"
    }
    echo "OK (Image tag: ${NAME_IMAGE_DOCKER})"

    printf "%s" '- Building app binary in the container ... '
    result=$(docker run --rm -it -w "/app" -v "$PATH_DIR_CURRENT":/app "$NAME_IMAGE_DOCKER" "$NAME_SCRIPT_SELF" 2>&1) || {
        echo 'NG'
        echo >&2 "[OUTPUT LOG]:"
        echo >&2 "${result}"
        exit "${FAILURE}"
    }
    echo 'OK'

    echo "Container result:"
    echo "$result"
    exit "${SUCCESS}"
fi

# -----------------------------------------------------------------------------
#  Main for container run. (Actual app build test)
# -----------------------------------------------------------------------------
echo "- whoami: $(whoami)"
printf "%s" '- Building app for ARM5 (Issue #33) ... '
cdOrExit /app/tests
result=$(/usr/local/bin/build-app.sh linux arm 5 2>&1 3>&1) || {
    echo 'NG'
    echo >&2 "${result}"
    exit "${FAILURE}"
}
echo "OK (Image tag: ${NAME_IMAGE_DOCKER})"
