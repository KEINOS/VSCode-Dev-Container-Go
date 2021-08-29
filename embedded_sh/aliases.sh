# -----------------------------------------------------------------------------
#  Aliases for Useful Shell Script
# -----------------------------------------------------------------------------

alias welcome='/usr/local/bin/welcome_msg.sh'
alias run-shfmt='shfmt -d -i=4 -ln=posix'
alias run-coverage='go-carpet -256colors -include-vendor'
alias run-shellcheck='shfmt -f . | xargs -n 1 shellcheck -a --shell=sh -x'
alias list-go-pkg='ls -1A "/go/bin"'
alias build-app='/usr/local/bin/build-app.sh'
