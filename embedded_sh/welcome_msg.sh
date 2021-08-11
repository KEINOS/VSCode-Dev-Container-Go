# -----------------------------------------------------------------------------
#  Welcome message
# -----------------------------------------------------------------------------
. /etc/os-release
. /usr/local/bin/aliases.sh

cat <<HEREDOC
===============================================================================
 Golang Dev Container
===============================================================================
- whoami: $(whoami)
- pwd   : $(pwd)
- OS    : ${PRETTY_NAME}
- Go    : $(go version | grep -o -E "([0-9]+\.){1}[0-9]+(\.[0-9]+)?" | head -n1)
- golangci-lint: $(golangci-lint --version | grep -o -E "([0-9]+\.){1}[0-9]+(\.[0-9]+)?" | head -n1)
- Useful commands
  - shfmt ........... Lint and formatter for shell script
  - shellcheck ...... Static analysis for shell script
  - shellspec ....... Unit test for shell script
  - golangci-lint ... Overall lint and static analysis for Go script
  - go-carpet ....... Runs and displays the missing coverage area
  - gomarkdoc ....... Generates markdown documentation from Go code
  - alias ........... Shows the list of aliases
- Useful aliases
  - build-app ........ Builds a static binary and ZIP archives under the bin directory in the repo
  - list-go-pkg ...... List go installed packages
  - run-shfmt ........ Runs shfmt with POSIX mode
  - run-coverage ..... Runs go tests with coverage and shows the coverage report
  - run-shellcheck ... Runs shellcheck with POSIX mode
  - welcome .......... Show this message
HEREDOC
