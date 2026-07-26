SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/set_env.sh"

echo setting API Server Mode
cd "$SCRIPT_DIR/src/agents" || exit 1

echo `pwd`
echo adk api_server .
adk api_server .
