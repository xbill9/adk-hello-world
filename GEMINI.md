# GEMINI.md - Project Guide & Agent Context

This document serves as the authoritative guide for **Gemini AI models** and **Antigravity AI assistants** interacting with and developing in the **ADK Hello World** repository.

---

## 1. Project Overview

This repository is a starter kit for building, testing, running, and deploying AI agents built with **Google Agent Development Kit (ADK 2.x)** (`google-adk>=2.0.0`) powered by Gemini models (such as `gemini-2.5-flash`).

### Core Features & Architecture
- **Framework**: Google ADK 2.x Python SDK (`google.adk`).
- **Agents**:
  - `adk_hello_world`: Python-defined agent in `src/agents/adk_hello_world/agent.py`.
  - `Agent1`: Declarative YAML-defined agent in `src/agents/Agent1/root_agent.yaml`.
- **Supported Workflows**: Interactive CLI, ADK Web UI, FastAPI server, and Google Cloud Run deployment.

---

## 2. Environment & Credentials Setup

Before running agent execution commands, the project requires GCP credentials and configuration:

1. **Initialize Project Credentials**:
   ```bash
   ./init.sh
   ```
   *Prompts for GCP Project ID and Gemini API Key, saving them to `~/project_id.txt` and `~/gemini.key`.*

2. **Source Environment Variables**:
   ```bash
   source ./set_env.sh
   ```
   *Exports `PROJECT_ID`, `GOOGLE_CLOUD_PROJECT`, `GEMINI_API_KEY`, `GOOGLE_GENAI_USE_VERTEXAI`, `REGION`, and `AGENT_PATH`.*

---

## 3. Directory & File Map

```text
/home/xbill/adk-hello-world/
├── Makefile                                                    # Central build & task runner
├── README.md                                                   # User-facing project guide
├── GEMINI.md                                                   # Agent context & developer rules
├── requirements.txt                                            # Python dependencies
├── init.sh                                                     # Setup script for GCP credentials & Gemini API keys
├── set_env.sh                                                  # Sourced shell script for environment variables
├── cli.sh / run.sh                                             # Runner scripts for adk_hello_world CLI
├── Agent1_cli.sh                                               # Runner script for Agent1 YAML CLI
├── web.sh / webvm.sh                                           # Scripts for launching ADK Web UI
├── api_server.sh                                               # Script for starting FastAPI server
├── cloudrun.sh                                                 # Script for deploying agent to Cloud Run
└── src/
    └── agents/
        ├── adk_hello_world/
        │   ├── agent.py                                        # Python Agent definition & tool functions
        │   └── requirements.txt
        └── Agent1/
            └── root_agent.yaml                                 # YAML Agent specification
```

---

## 4. Useful Commands (`Makefile` Reference)

| Task | Make Target | Command |
|---|---|---|
| **Install Dependencies** | `make install` | `pip install -r requirements.txt` |
| **Setup Credentials** | `make init` | `./init.sh` |
| **Run Hello Agent (CLI)** | `make run` | `adk run src/agents/adk_hello_world` |
| **Run Agent1 (CLI)** | `make run-agent1` | `adk run src/agents/Agent1` |
| **Launch Local Web UI** | `make web` | `adk web` |
| **Launch Remote Web UI** | `make webvm` | `adk web --host=0.0.0.0` |
| **Start FastAPI Server** | `make api` | `adk api_server src/agents/adk_hello_world` |
| **Deploy to Cloud Run** | `make deploy` | `adk deploy cloud_run` |
| **Syntax Check / Lint** | `make lint` | `python3 -m py_compile src/agents/adk_hello_world/agent.py` |
| **Format Code** | `make format` | `autopep8 --in-place --recursive src/` |
| **Clean Build Artifacts** | `make clean` | Removes `__pycache__`, `.adk`, and temporary files |

---

## 5. ADK 2.x Python Coding Guidelines

When implementing or modifying Python agents in `src/agents/`:

### Agent Instantiation
Always instantiate the agent as `root_agent` so ADK CLI entry points can automatically locate and load the agent:
```python
from google.adk.agents import Agent

root_agent = Agent(
    name="weather_time_agent",
    model="gemini-2.5-flash",
    description="Agent to answer questions about the time and weather in a city.",
    instruction="You are a helpful agent who can answer user questions about the time and weather in a city.",
    tools=[get_weather, get_current_time],
)
```

### Tool Function Conventions
- Tools must include clean docstrings describing their parameters and return types.
- Keep tools as plain Python functions. If a tool needs execution context,
  annotate a required parameter with `ToolContext` from `google.adk.tools`;
  ADK injects it automatically.
- Return structured dictionaries (e.g. `{"status": "success", "report": ...}`).

### Code Verification Rules
After mutating Python agent files:
1. Run `make lint` (or `python3 -m py_compile src/agents/adk_hello_world/agent.py`) to verify there are no syntax errors.
2. Ensure imports match ADK 2.x specifications (`google.adk`, `google.adk.agents`).
