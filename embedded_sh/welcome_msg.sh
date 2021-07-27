# -----------------------------------------------------------------------------
#  Welcome message
# -----------------------------------------------------------------------------
. /etc/os-release
. /etc/profile.d/aliases.sh

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
  - welcome ......... This message
  - list-go-pkg ..... List go installed packages
  - alias ........... Shows the list of shorthand commands of the above commands
HEREDOC
