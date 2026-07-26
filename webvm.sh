SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/set_env.sh"

echo Running ADK from Cloud VM
cd "$SCRIPT_DIR/src/agents" || exit 1

echo `pwd`
echo adk web
adk web --host=0.0.0.0
