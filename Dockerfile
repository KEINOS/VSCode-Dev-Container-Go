# =============================================================================
#  Dev Container Base Image for Go in Alpine Linux
# =============================================================================
# Default
ARG GOPATH="/go"
ARG LANG='ja_JP.utf8'
ARG LC_ALL='ja_JP.utf8'
ARG LOCALE_ZONE="Japan"
ARG USER_NAME="vscode"
ARG USER_GROUP="vscode"
ARG USER_UID=1000
ARG USER_GID=1000
ARG VERSION="dev"

# -----------------------------------------------------------------------------
#  Build stage
# -----------------------------------------------------------------------------
FROM golang:alpine AS build

ARG GOPATH

ENV \
    GO111MODULE="on" \
    GOPATH="${GOPATH:-/go}" \
    GOBIN="${GOPATH}/bin"

RUN \
    # Upgrade installed packages
    apk upgrade --no-cache --latest

WORKDIR /root

RUN \
    # Install additional OS packages.
    apk add --no-cache --latest \
        alpine-sdk \
        build-base \
        xz

RUN \
    # Install ShellCheck - Static Analysis for Shell scripts (Issue: #2)
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
    # Install latest golangci-lint - The fast Go linters runner (Issue: #11)
    wget -O- https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "${GOPATH:?Undefined}/bin"

RUN \
    # Packages that Go team suggests to install
    go install "github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest" && \
    go install "github.com/ramya-rao-a/go-outline@latest" && \
    go install "github.com/cweill/gotests/gotests@latest" && \
    go install "github.com/fatih/gomodifytags@latest" && \
    go install "github.com/josharian/impl@latest" && \
    go install "github.com/haya14busa/goplay/cmd/goplay@latest" && \
    go install "github.com/go-delve/delve/cmd/dlv@master" && \
    go install "honnef.co/go/tools/cmd/staticcheck@latest" && \
    go install "golang.org/x/tools/gopls@latest" && \
    # Packages that KEINOS commonly use
    go install "github.com/msoap/go-carpet@latest" && \
    go install "mvdan.cc/sh/v3/cmd/shfmt@v3.2.1" && \
    go install "github.com/tenntenn/goplayground/cmd/gp@latest" && \
    go install "github.com/princjef/gomarkdoc/cmd/gomarkdoc@latest" && \
    go install "github.com/nicksnyder/go-i18n/v2/goi18n@latest" && \
    go install "mvdan.cc/gofumpt@latest" && \
    go install "github.com/jessfraz/dockfmt@latest" && \
    go install "golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment@latest" && \
    go install "golang.org/x/lint/golint@latest" && \
    go install "github.com/goreleaser/goreleaser@latest"

RUN \
    # Install ShellSpec temporary.
    wget -O- https://git.io/shellspec | sh -s -- --prefix "${GOPATH:?Undefined}" --yes && \
    shellspec --version && \
    # Clone altshfmt
    cd /tmp && \
    git clone https://github.com/shellspec/altshfmt.git && \
    cd altshfmt && \
    # Unit test altshfmt
    shellspec && \
    # Install altshfmt
    cp /tmp/altshfmt/altshfmt /go/bin/altshfmt && \
    # Remove shellspec. This will be re-installed in the main stage due to the dependency.
    rm -f /go/bin/shellspec

# -----------------------------------------------------------------------------
#  Main stage
# -----------------------------------------------------------------------------
FROM golang:alpine

# Args to receive during build
ARG GOPATH
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
    GO111MODULE="on" \
    GOPATH="${GOPATH:-/go}" \
    GOBIN="${GOPATH}/bin"

COPY embedded_sh/*.sh /usr/local/bin/
COPY --from=build /go/bin /go/bin/

LABEL \
    Version="${VERSION}${TAG_BUILD}" \
    Name="VSCode DevContainer - Go" \
    Url_repo="https://github.com/KEINOS/VSCode-Dev-Container-Go" \
    Maintainer="https://github.com/KEINOS"

RUN \
    # Upgrade installed packages with no cache
    apk upgrade --no-cache --latest && \
    \
    # Install additional OS packages
    # Note:
    #   We DO NOT ALLOW to install `sudo` here for two reasons:
    #   1. `docker scan --severity=high` often reports vulnerability alerts for
    #       new version of suto.
    #   2. "go get" or "go install" is all we need. Otherwise place them in your
    #      Dockerfile.
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
    # Set time zone (to Tokyo by default)
    echo 'Setting time zone' && \
    cp "/usr/share/zoneinfo/${LOCALE_ZONE}" /etc/localtime && \
    echo "$LOCALE_ZONE" >/etc/timezone && \
    \
    # Add user for VSCode
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
    # Fix name for the initial branch
    git config --global init.defaultBranch main && \
    \
    # Install ShellSpec - Unit test for Shell scripts (Issue: #2)
    wget -O- https://git.io/shellspec | sh -s -- --prefix "${GOPATH:?Undefined}" --yes && \
    shellspec --version && \
    # Fix Dockle alert: DKL-LI-0003 Only put necessary files (Issue #19)
    # - Remove suspicious directory and unnecessary files
    rm -rf /go/lib/shellspec/.git && \
    rm -ff /go/lib/shellspec/.dockerhub/Dockerfile && \
    rm -rf /go/lib/shellspec/contrib/helpers/Dockerfile && \
    \
    # Set welcome message
    cat '/usr/local/bin/welcome_msg.sh' >> /home/vscode/.bashrc && \
    \
    # Change owner to vscode under /go (Fix issue: #6)
    chown -R vscode:root "$(go env GOPATH)/bin" && \
    \
    # Fix CIS-DI-0008: Confirm safety of setuid/setgid files (Issue #19)
    chmod u-s /usr/bin/abuild-sudo && \
    chmod u-g /usr/bin/abuild-sudo && \
    \
    # Fix DKL-LI-0003: Only put necessary files (Related issue #38)
    rm -rf /usr/local/go/src/crypto/elliptic/internal/fiat/Dockerfile && \
    \
    # Fix Issue #63: add dlv-dap
    ln -s /go/bin/dlv /go/bin/dlv-dap && \
    \
    # Smoke tests for installed Go packages as a command
    altshfmt -h && \
    dlv version && \
    dlv-dap version && \
    dockfmt version && \
    fieldalignment -h && \
    go-carpet --version && \
    go-outline -help && \
    gofumpt --version && \
    goi18n extract --help && \
    golangci-lint --version && \
    golint --help && \
    gomarkdoc --version && \
    gomodifytags -help && \
    gopkgs -h && \
    goplay -h 2>&1 | grep SYNOPSIS && \
    gopls version && \
    goreleaser -v && \
    gotests -h && \
    gp help && \
    impl -h && \
    shellcheck --version && \
    shellspec --version && \
    shfmt --version && \
    staticcheck --version

USER vscode

WORKDIR /workspaces

# Fix Dockle alert: CIS-DI-0006 Add HEALTHCHECK instruction to the container image (Issue #19)
HEALTHCHECK --start-period=5m --interval=10m --timeout=10s \
  CMD go version || exit 1
