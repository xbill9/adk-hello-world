#!/bin/bash

# This script sets various Google Cloud related environment variables.
# It must be SOURCED to make the variables available in your current shell.
# Example: source ./set_gcp_env.sh

# --- Configuration ---
PROJECT_FILE="~/project_id.txt"
GEMINI_KEY="~/gemini.key"
GOOGLE_CLOUD_LOCATION="us-central1"
# ---------------------

echo "--- Setting Google Cloud Environment Variables ---"

# --- Authentication Check ---
echo "Checking gcloud authentication status..."
# Run a command that requires authentication (like listing accounts or printing a token)
# Redirect stdout and stderr to /dev/null so we don't see output unless there's a real error
if gcloud auth print-access-token > /dev/null 2>&1; then
  echo "gcloud is authenticated."
else
  echo "Error: gcloud is not authenticated."
  echo "Please log in by running: gcloud auth login"
  # Use 'return 1' instead of 'exit 1' because the script is meant to be sourced.
  # 'exit 1' would close your current terminal session.
  return 1
fi
# --- --- --- --- --- ---


# 1. Check if project file exists
PROJECT_FILE_PATH=$(eval echo $PROJECT_FILE) # Expand potential ~
if [ ! -f "$PROJECT_FILE_PATH" ]; then
  echo "Error: Project file not found at $PROJECT_FILE_PATH"
  echo "Please create $PROJECT_FILE_PATH containing your Google Cloud project ID."
  return 1 # Return 1 as we are sourcing
fi

# --- Gemini Key vs Vertex AI Configuration ---
read -p "Are you using a Gemini API Key? (y/N): " USE_GEMINI_KEY
USE_GEMINI_KEY=${USE_GEMINI_KEY:-n}

USE_VERTEX_AI="TRUE"

if [[ "$USE_GEMINI_KEY" =~ ^[Yy]$ ]]; then
  echo "Configuring for Gemini API Key..."
  GEMINI_FILE_PATH=$(eval echo $GEMINI_KEY) # Expand potential ~
  if [ ! -f "$GEMINI_FILE_PATH" ]; then
    echo "Error: Gemini Key file not found at $GEMINI_FILE_PATH"
    echo "Please create $GEMINI_FILE_PATH containing your Gemini Key."
    return 1 # Return 1 as we are sourcing
  fi
  export GEMINI_API_KEY=$(cat "$GEMINI_FILE_PATH")
  USE_VERTEX_AI="FALSE"
else
  echo "Configuring for Vertex AI..."
fi


# 2. Set the default gcloud project configuration
PROJECT_ID_FROM_FILE=$(cat "$PROJECT_FILE_PATH")

# 3. Export PROJECT_ID (Get from config to confirm it was set correctly)
export PROJECT_ID=$(gcloud config get project)
echo "Exported PROJECT_ID=$PROJECT_ID"

# Using --format to extract just the projectNumber value
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
echo "Exported PROJECT_NUMBER=$PROJECT_NUMBER"

# Export SERVICE_ACCOUNT_NAME (Default Compute Service Account)
export SERVICE_ACCOUNT_NAME=$(gcloud compute project-info describe --format="value(defaultServiceAccount)")
echo "Exported SERVICE_ACCOUNT_NAME=$SERVICE_ACCOUNT_NAME"

# Export GOOGLE_CLOUD_PROJECT (Often used by client libraries)
# This is usually the same as PROJECT_ID
export GOOGLE_CLOUD_PROJECT="$PROJECT_ID"
echo "Exported GOOGLE_CLOUD_PROJECT=$GOOGLE_CLOUD_PROJECT"

# Export GOOGLE_GENAI_USE_VERTEXAI
export GOOGLE_GENAI_USE_VERTEXAI="$USE_VERTEX_AI"
echo "Exported GOOGLE_GENAI_USE_VERTEXAI=$GOOGLE_GENAI_USE_VERTEXAI"

#  Export GOOGLE_CLOUD_LOCATION
export GOOGLE_CLOUD_LOCATION="$GOOGLE_CLOUD_LOCATION"
echo "Exported GOOGLE_CLOUD_LOCATION=$GOOGLE_CLOUD_LOCATION"

#  Export REPO_NAME
export REPO_NAME="$REPO_NAME"
echo "Exported REPO_NAME=$REPO_NAME"

#  Export REGION
export REGION="$GOOGLE_CLOUD_LOCATION"
echo "Exported REGION=$GOOGLE_CLOUD_LOCATION"

# Set a name for your Cloud Run service (optional)
export SERVICE_NAME="hello-world-agent-service"

# Set an application name (optional)
export APP_NAME="hello-world-agent-app"

export AGENT_PATH="$HOME/adk-hello-world/src/agents/adk_hello_world"

echo "Exported AGENT_PATH=$AGENT_PATH"

echo "--- Environment setup complete ---"

