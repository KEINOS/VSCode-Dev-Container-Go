# =============================================================================
#  Dev Container Base Image for Go in Alpine Linux
# =============================================================================
# Default
ARG LANG='ja_JP.utf8'
ARG LC_ALL='ja_JP.utf8'
ARG LOCALE_ZONE="Japan"
ARG USER_NAME="vscode"
ARG USER_GROUP="vscode"
ARG USER_UID=1000
ARG USER_GID=1000
ARG VERSION="dev"

# -----------------------------------------------------------------------------
#  Main stage
# -----------------------------------------------------------------------------
FROM golang:alpine

# Args to receive during build
ARG LANG
ARG LANGUAGE="${LANGUAGE:-$LANG}"
ARG LC_ALL
ARG LOCALE
ARG LOCALE_ZONE
ARG TAG_BUILD
ARG USER_NAME
ARG USER_GROUP
ARG USER_UID
ARG USER_GID
ARG VERSION

ENV \
    # Locale
    LANG="$LANG" \
    LC_ALL="$LC_ALL" \
    # Enforce go module mode
    GO111MODULE='on'

COPY embedded_sh/*.sh /usr/local/bin/

LABEL \
    Version="${VERSION}${TAG_BUILD}" \
    Name="VSCode DevContainer - Go" \
    Url_repo="https://github.com/KEINOS/VSCode-Dev-Container-Go" \
    Maintainer="https://github.com/KEINOS"

RUN \
    # Upgrade installed packages
    apk upgrade --no-cache --latest && \
    # Install additional OS packages.
    apk add --no-cache --latest \
        alpine-sdk \
        build-base \
        tzdata \
        xz \
        bash \
        curl \
        # add rg: issue #12
        ripgrep \
        # add jq: issue #13
        jq \
        # add tree: issue #14
        tree \
        # add zip: issue #17
        zip \
    && \
    \
    # Set time zone
    echo 'Setting time zone' && \
    cp "/usr/share/zoneinfo/${LOCALE_ZONE}" /etc/localtime && \
    echo "$LOCALE_ZONE" >/etc/timezone && \
    \
    # Add user
    # Alpine addgroup and adduser supports long options. See: https://stackoverflow.com/a/55757473/8367711
    echo 'Adding work user' && \
    addgroup \
    --system \
    --gid "$USER_GID" \
    "$USER_GROUP" && \
    \
    adduser \
    --system \
    --home "/home/${USER_NAME}" \
    --shell /bin/bash \
    --disabled-password \
    --ingroup "$USER_GROUP" \
    --uid "$USER_UID" \
    "$USER_NAME" && \
    \
    echo "Install Go tools to help dev" && \
    # Packages that Go team suggests to install
    go install "github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest" && \
    go install "github.com/ramya-rao-a/go-outline@latest" && \
    go install "github.com/cweill/gotests/gotests@latest" && \
    go install "github.com/fatih/gomodifytags@latest" && \
    go install "github.com/josharian/impl@latest" && \
    go install "github.com/haya14busa/goplay/cmd/goplay@latest" && \
    go install "github.com/go-delve/delve/cmd/dlv@latest" && \
    go install "honnef.co/go/tools/cmd/staticcheck@latest" && \
    go install "golang.org/x/tools/gopls@latest" && \
    # Packages that KEINOS commonly uses
    go install "github.com/msoap/go-carpet@latest" && \
    go install "mvdan.cc/sh/v3/cmd/shfmt@latest" && \
    go install "github.com/tenntenn/goplayground/cmd/gp@latest" && \
    go install "github.com/princjef/gomarkdoc/cmd/gomarkdoc@latest" && \
    go install "github.com/nicksnyder/go-i18n/v2/goi18n@latest" && \
    go install "mvdan.cc/gofumpt@latest" && \
    go install "github.com/jessfraz/dockfmt@latest" && \
    \
    # Install ShellCheck - Static Analysis for Shell scripts (Issue: #2)
    echo "Install shellcheck" && \
    name_file_arch="shellcheck-latest.linux.$(uname -m).tar.xz" && \
    url_download="https://github.com/koalaman/shellcheck/releases/download/latest/${name_file_arch}" && \
    path_dir_tmp=$(mktemp -d) && \
    path_file_arch="${path_dir_tmp}/${name_file_arch}" && \
    wget -P "${path_dir_tmp}" "$url_download" && \
    tar x -v -f "$path_file_arch" -C "$path_dir_tmp" && \
    cp "${path_dir_tmp}/shellcheck-latest/shellcheck" "${GOPATH:?Undefined}/bin/shellcheck" && \
    shellcheck --version && \
    rm -rf "${path_dir_tmp:?Undefined}" && \
    \
    # Install ShellSpec - Unit test for Shell scripts (Issue: #2)
    echo "Install shellspec" && \
    wget -O- https://git.io/shellspec | sh -s -- --prefix "${GOPATH:?Undefined}" --yes && \
    \
    # Install latest golangci-lint - The fast Go linters runner (Issue: #11)
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)/bin" && \
    golangci-lint --version && \
    \
    # Set welcome message
    cat '/usr/local/bin/welcome_msg.sh' >> /home/vscode/.bashrc && \
    \
    # Change owner to vscode under /go (Fix issue: #6)
    chown -R vscode:root "$(go env GOPATH)/bin"

USER vscode

WORKDIR /workspaces
