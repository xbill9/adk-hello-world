# Makefile for Google ADK 2.x Python Project

PYTHON := python3
PIP := pip
AGENT_DIR := src/agents/adk_hello_world
AGENT1_DIR := src/agents/Agent1
AGENTS_DIR := src/agents

.PHONY: all help install deps init run run-agent1 web webvm api deploy lint format clean test

# Default target
all: help

# Help target listing commands
help:
	@echo "=========================================================="
	@echo "  ADK 2.x Hello World Project Commands"
	@echo "=========================================================="
	@echo "  make install     Install required Python packages"
	@echo "  make init        Initialize GCP project & Gemini credentials"
	@echo "  make run         Run primary agent (adk_hello_world) in CLI"
	@echo "  make run-agent1  Run Agent1 (YAML agent) in CLI"
	@echo "  make web         Launch ADK Web UI locally (localhost:8000)"
	@echo "  make webvm       Launch ADK Web UI bound to 0.0.0.0:8000"
	@echo "  make api         Launch FastAPI server for adk_hello_world"
	@echo "  make deploy      Deploy agent to Google Cloud Run"
	@echo "  make lint        Check Python code syntax and styling"
	@echo "  make format      Format Python code using autopep8"
	@echo "  make test        Run unit test suite"
	@echo "  make clean       Clean temporary files and Python cache"
	@echo "=========================================================="

# Install dependencies
install: deps

deps:
	@echo "Installing dependencies from requirements.txt..."
	$(PIP) install -r requirements.txt

# Initialize setup and credentials
init:
	@echo "Initializing project credentials..."
	./init.sh

# Run main agent via CLI
run:
	@echo "Running adk_hello_world agent via ADK CLI..."
	adk run $(AGENT_DIR)

# Run Agent1 (YAML configuration) via CLI
run-agent1:
	@echo "Running Agent1 (YAML agent) via ADK CLI..."
	adk run $(AGENT1_DIR)

# Launch ADK Web UI on localhost
web:
	@echo "Launching ADK Web UI locally..."
	adk web $(AGENTS_DIR)

# Launch ADK Web UI bound to 0.0.0.0 for remote VM access
webvm:
	@echo "Launching ADK Web UI bound to 0.0.0.0..."
	adk web --host=0.0.0.0 $(AGENTS_DIR)

# Start FastAPI API server for the agent
api:
	@echo "Starting ADK API server..."
	adk api_server $(AGENTS_DIR)

# Deploy agent to Google Cloud Run
deploy:
	@echo "Deploying agent to Cloud Run..."
	./cloudrun.sh

# Lint Python code
lint:
	@echo "Linting Python agent files..."
	$(PYTHON) -m py_compile $(AGENT_DIR)/agent.py

# Format Python code
format:
	@echo "Formatting Python files..."
	autopep8 --in-place --recursive src/

# Run tests
test:
	@echo "Running unit tests..."
	$(PYTHON) -m unittest discover -s tests -v

# Clean temporary runtime files and cache
clean:
	@echo "Cleaning pycache and temporary files..."
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
