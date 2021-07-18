# =============================================================================
#  Dockerfile for the Base Image of Go in VSCode Dec Containers
# =============================================================================
# -----------------------------------------------------------------------------
#  Default Values
# -----------------------------------------------------------------------------
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"
ARG LANG="ja_JP.UTF-8"
ARG LC_ALL="ja_JP.UTF-8"
ARG VARIANT="1"
ARG VERSION="dev"

# =============================================================================
#  Main stage
# =============================================================================
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.185.0/containers/go/.devcontainer/base.Dockerfile
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT}

ARG INSTALL_NODE
ARG NODE_VERSION
ARG LANG
ARG LC_ALL
ARG VERSION
ARG TAG_BUILD

LABEL \
    Version="${VERSION}${TAG_BUILD}" \
    Name="VSCode DevContainer - Go" \
    Url_repo="https://github.com/KEINOS/VSCode-Dev-Container-Go" \
    Maintainer="https://github.com/KEINOS"

ENV \
    DEBIAN_FRONTEND=noninteractive \
    # Locale
    LANG="$LANG" \
    LC_ALL="$LC_ALL" \
    # Enforce go module mode
    GO111MODULE='on'

RUN \
    # Update/upgrade the package manager
    apt-get update \
    && apt-get upgrade -y \
    #  install base dependencies
    && apt-get -y install --no-install-recommends \
    build-essential \
    # Install node.js for VSCode extensions' usage
    && if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi \
    \
    # Set locale
    && echo "${LC_ALL} UTF-8" >>/etc/locale.gen \
    && /usr/sbin/locale-gen "$LC_ALL" \
    && /usr/sbin/update-locale LANG="$LANG" \
    \
    # Install useful Go tools
    && go install "github.com/msoap/go-carpet@latest" \
    && go install "mvdan.cc/sh/v3/cmd/shfmt@latest" \
    && go install "github.com/tenntenn/goplayground/cmd/gp@latest" \
    && go install "github.com/princjef/gomarkdoc/cmd/gomarkdoc@latest" \
    && go install "github.com/nicksnyder/go-i18n/v2/goi18n@latest" \
    && go install "mvdan.cc/gofumpt@latest" \
    && go install "golang.org/x/tools/gopls@latest" \
    && go install "github.com/golang/mock/mockgen@latest" \
    && go install "github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest" \
    && go install "github.com/ramya-rao-a/go-outline@latest" \
    && go install "github.com/go-delve/delve/cmd/dlv@latest" \
    && go install "honnef.co/go/tools/cmd/staticcheck@latest" \
    && go install "github.com/princjef/gomarkdoc/cmd/gomarkdoc@latest" \
    \
    # Install shellcheck
    && url_download="https://github.com/koalaman/shellcheck/releases/download/latest/shellcheck-latest.linux.$(uname -m).tar.xz" \
    && timestamp="$(date +%Y%m%d%H%M%S)" \
    && path_tmp_dir=$(mktemp "/tmp/QiiTask-${timestamp}.tmp.XXXXXX") \
    && echo "TEMP PATH: ${path_tmp_dir}" \
    && wget -P "${path_tmp_dir}/" "$url_download" \
    && tar xvf "${path_tmp_dir}"/shellcheck* -C "${path_tmp_dir}/" \
    && cp "${path_tmp_dir}/shellcheck-latest/shellcheck" "${GOPATH:?Undefined}/bin/shellcheck" \
    && shellcheck --version \
    && rm -r "$path_tmp_dir" \
    \
    # Install shellspec
    && wget -O- https://git.io/shellspec | sh -s -- --prefix "${GOPATH:?Undefined}" --yes \
    \
    # Clean up
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*
