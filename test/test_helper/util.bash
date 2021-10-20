
diff_so_fancy="$BATS_TEST_DIRNAME/../diff-so-fancy"

load_fixture() {
  local name="$1"
  cat "$BATS_TEST_DIRNAME/fixtures/${name}.diff"
}

set_env() {
  export LC_CTYPE="en_US.UTF-8"
}


# applying colors so ANSI color values will match
# FIXME: not everyone will have these set, so we need to test for that.
git_test_config_defaults=(
  color.diff.meta='227'
  color.diff.frag='magenta bold'
  color.diff.commit='227 bold'
  color.diff.old='red bold'
  color.diff.new='green bold'
  color.diff.whitespace='red reverse'
  color.diff-highlight.oldnormal='red bold'
  color.diff-highlight.oldhighlight='red bold 52'
  color.diff-highlight.newnormal='green bold'
  color.diff-highlight.newhighlight='green bold 22'
)

[ -n "${GIT_CONFIG_COUNT:-}" ] || export GIT_CONFIG_COUNT=0
for kv in "${git_test_config_defaults[@]}"; do
  IFS='=' read -r key value <<< "${kv}"
  eval "$(printf 'export GIT_CONFIG_KEY_%d=%q' "${GIT_CONFIG_COUNT}" "${key}")"
  eval "$(printf 'export GIT_CONFIG_VALUE_%d=%q' "${GIT_CONFIG_COUNT}" "${value}")"
  (( GIT_CONFIG_COUNT += 1 ))
done
