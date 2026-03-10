. $HOME/adk-hello-world/set_env.sh

echo Running ADK from Cloud VM
cd src/agents

echo `pwd`
echo adk web
adk web --host=0.0.0.0
