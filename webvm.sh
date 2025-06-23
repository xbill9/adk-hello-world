. $HOME/adk-hello-world/set_env.sh

echo Running ADK from GCE VM
cd src/agents

echo `pwd`
echo adk web
adk web --host=0.0.0.0
