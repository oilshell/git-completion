#!/usr/bin/env bash
#
# Patch upstream git-completion.bash
#
# Usage:
#   ./run.sh <function name>

set -o nounset
set -o pipefail
set -o errexit
shopt -s strict:all 2>/dev/null || true  # dogfood for OSH

version() {
  # My Debian 12 uses 2.39.2
  git --version
}

download() {
  mkdir -p _tmp
  wget --no-clobber --directory _tmp \
    https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.39.2.tar.xz
}

copy-upstream() {
  local version=${1:-2.39.2}

  mkdir -v -p $version
  cp -v _tmp/git-$version/contrib/completion/git-completion.bash $version/
}

show-diff() {
  local version=${1:-2.39.2}

  diff -u $version/git-completion.{bash,osh}
}


do-patch() {
  local dir=${1:-2.39.2}

  # Original
  # https://github.com/oilshell/oil/commit/565e04b8dc37df930ab106f1a21805d5f25f5a83.patch
  # Did NOT apply cleanly, manually edited the code
  pushd $dir
  patch -p 1 -o git-completion.osh \
    git-completion.bash ../osh-git.patch
  popd
}

"$@"
