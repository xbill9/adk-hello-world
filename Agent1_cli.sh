SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/set_env.sh"

cd "$SCRIPT_DIR/src/agents/Agent1" || exit 1

echo `pwd`
echo adk run .
adk run .
