# ADK Hello World (ADK 2.x Edition)

An updated Google Agent Development Kit (ADK 2.x) starter application for building, running, and deploying AI agents across local, web, and cloud environments.

---

## What this starter includes

This repository uses **Google ADK 2.x** (`google-adk>=2.0.0`). It contains a
Python agent, a YAML agent, local CLI and web launchers, an API server launcher,
and a Cloud Run deployment script.

The Python agent can return the current time for a small set of city aliases or
for an explicit IANA timezone such as `Europe/London`. It intentionally does not
return weather observations until a live weather provider is configured.

---

## Project Structure

```text
.
├── Makefile                                                    # Convenient make commands for execution & maintenance
├── README.md                                                   # Project documentation
├── GEMINI.md                                                   # Developer & agent guidelines for Gemini AI tooling
├── requirements.txt                                            # Python dependencies
├── init.sh                                                     # Credentials initialization script
├── set_env.sh                                                  # Environment variables script
├── cli.sh / run.sh                                             # Interactive CLI runner scripts
├── Agent1_cli.sh                                               # CLI script for YAML Agent1
├── web.sh / webvm.sh                                           # Web UI launcher scripts
├── api_server.sh                                               # FastAPI server launch script
├── cloudrun.sh                                                 # Google Cloud Run deployment script
└── src/
    └── agents/
        ├── adk_hello_world/                                    # Main Python-defined ADK agent
        │   ├── agent.py                                        # Agent definition & custom tools
        │   └── requirements.txt
        └── Agent1/                                             # Declarative YAML root agent
            └── root_agent.yaml
```

---

## Quickstart

### 1. Requirements
- **Python**: `3.10+`
- **Google Cloud SDK** (`gcloud`) installed and authenticated

### 2. Installation & Credentials
```bash
# Install dependencies
make install

# Initialize project credentials (GCP Project ID & Gemini API Key)
make init

# Source environment variables into your shell session
source ./set_env.sh
```

---

## Command Reference (Makefile & Scripts)

You can manage the project using `make` commands or direct shell scripts:

| Command Target | Direct Script / ADK 2.x CLI Command | Description |
|---|---|---|
| `make run` | `./run.sh` / `adk run src/agents/adk_hello_world` | Interactive CLI for `adk_hello_world` agent |
| `make run-agent1` | `./Agent1_cli.sh` / `adk run src/agents/Agent1` | Interactive CLI for YAML-configured Agent1 |
| `make web` | `adk web src/agents` | Launch local ADK Web UI at `http://localhost:8000` |
| `make webvm` | `adk web --host=0.0.0.0 src/agents` | Launch Web UI bound to `0.0.0.0` for remote access |
| `make api` | `adk api_server src/agents` | Start the ADK API server |
| `make deploy` | `./cloudrun.sh` | Deploy the Python agent to Google Cloud Run |
| `make lint` | `python3 -m py_compile src/agents/adk_hello_world/agent.py` | Check Python code syntax |
| `make test` | `python3 -m unittest discover -s tests -v` | Run tool unit tests |
| `make format` | `autopep8 --in-place --recursive src/` | Format Python code |
| `make clean` | — | Remove `__pycache__`, `.pytest_cache`, and temporary files |

---

## Agent Architectures

### Python Agent (`src/agents/adk_hello_world/agent.py`)
Uses `google.adk.agents.Agent` with the `gemini-2.5-flash` model and plain
Python function tools.

### YAML Agent (`src/agents/Agent1/root_agent.yaml`)
Declarative agent configuration defining agent class (`LlmAgent`), instruction prompts, and tools (`google_search`).

---

## Documentation References

- [ADK documentation](https://adk.dev/)
- [ADK Python GitHub Repository](https://github.com/google/adk-python)
