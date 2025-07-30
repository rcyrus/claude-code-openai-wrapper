# Claude Code OpenAI API Wrapper

An OpenAI API-compatible wrapper for Claude Code, allowing you to use Claude Code with any OpenAI client library. **Now powered by the official Claude Code Python SDK** with enhanced authentication and features.

## Status

🎉 **Production Ready** - All core features working and tested:
- ✅ Chat completions endpoint with **official Claude Code Python SDK**
- ✅ Streaming and non-streaming responses  
- ✅ Full OpenAI SDK compatibility
- ✅ **OpenAI Function Calling** - Complete support for tools via OpenAI format! 🎉
- ✅ **Multi-provider authentication** (API key, Bedrock, Vertex AI, CLI auth)
- ✅ **System prompt support** via SDK options
- ✅ Model selection support with validation
- ✅ **Fast by default** - Tools disabled for OpenAI compatibility (5-10x faster)
- ✅ Optional tool usage (Read, Write, Bash, etc.) when explicitly enabled
- ✅ **Real-time cost and token tracking** from SDK
- ✅ **Session continuity** with conversation history across requests 🆕
- ✅ **Session management endpoints** for full session control 🆕
- ✅ Health, auth status, and models endpoints
- ✅ **Development mode** with auto-reload

## Features

### 🔥 **Core API Compatibility**
- OpenAI-compatible `/v1/chat/completions` endpoint
- Support for both streaming and non-streaming responses
- Compatible with OpenAI Python SDK and all OpenAI client libraries
- Automatic model validation and selection
- **OpenAI Function Calling support** 🆕 - Use Claude's tools via OpenAI's function calling format

### 🛠 **Claude Code SDK Integration**
- **Official Claude Code Python SDK** integration (v0.0.14)
- **Real-time cost tracking** - actual costs from SDK metadata
- **Accurate token counting** - input/output tokens from SDK
- **Session management** - proper session IDs and continuity
- **Enhanced error handling** with detailed authentication diagnostics

### 🔐 **Multi-Provider Authentication**
- **Automatic detection** of authentication method
- **Claude CLI auth** - works with existing `claude auth` setup
- **Direct API key** - `ANTHROPIC_API_KEY` environment variable
- **AWS Bedrock** - enterprise authentication with AWS credentials
- **Google Vertex AI** - GCP authentication support

### ⚡ **Advanced Features**
- **System prompt support** via SDK options
- **Optional tool usage** - Enable Claude Code tools (Read, Write, Bash, etc.) when needed
- **Fast default mode** - Tools disabled by default for OpenAI API compatibility
- **Development mode** with auto-reload (`uvicorn --reload`)
- **Interactive API key protection** - Optional security with auto-generated tokens
- **Comprehensive logging** and debugging capabilities

## Quick Start

Get started in under 2 minutes:

```bash
# 1. Install Claude Code CLI (if not already installed)
npm install -g @anthropic-ai/claude-code

# 2. Authenticate (choose one method)
claude auth login  # Recommended for development
# OR set: export ANTHROPIC_API_KEY=your-api-key

# 3. Clone and setup the wrapper
git clone https://github.com/RichardAtCT/claude-code-openai-wrapper
cd claude-code-openai-wrapper
poetry install

# 4. Start the server
poetry run uvicorn main:app --reload --port 8000

# 5. Test it works
poetry run python test_endpoints.py
```

🎉 **That's it!** Your OpenAI-compatible Claude Code API is running on `http://localhost:8000`

## Prerequisites

1. **Claude Code CLI**: Install Claude Code CLI
   ```bash
   # Install Claude Code (follow Anthropic's official guide)
   npm install -g @anthropic-ai/claude-code
   ```

2. **Authentication**: Choose one method:
   - **Option A**: Authenticate via CLI (Recommended for development)
     ```bash
     claude auth login
     ```
   - **Option B**: Set environment variable
     ```bash
     export ANTHROPIC_API_KEY=your-api-key
     ```
   - **Option C**: Use AWS Bedrock or Google Vertex AI (see Configuration section)

3. **Python 3.10+**: Required for the server

4. **Poetry**: For dependency management
   ```bash
   # Install Poetry (if not already installed)
   curl -sSL https://install.python-poetry.org | python3 -
   ```

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/RichardAtCT/claude-code-openai-wrapper
   cd claude-code-openai-wrapper
   ```

2. Install dependencies with Poetry:
   ```bash
   poetry install
   ```

   This will create a virtual environment and install all dependencies.

3. Configure environment:
   ```bash
   cp .env.example .env
   # Edit .env with your preferences
   ```

## Configuration

Edit the `.env` file:

```env
# Claude CLI path (usually just "claude")
CLAUDE_CLI_PATH=claude

# Optional API key for client authentication
# If not set, server will prompt for interactive API key protection on startup
# API_KEY=your-optional-api-key

# Server port
PORT=8000

# Timeout in milliseconds
MAX_TIMEOUT=600000

# CORS origins
CORS_ORIGINS=["*"]
```

### 🔐 **API Security Configuration**

The server supports **interactive API key protection** for secure remote access:

1. **No API key set**: Server prompts "Enable API key protection? (y/N)" on startup
   - Choose **No** (default): Server runs without authentication
   - Choose **Yes**: Server generates and displays a secure API key

2. **Environment API key set**: Uses the configured `API_KEY` without prompting

```bash
# Example: Interactive protection enabled
poetry run python main.py

# Output:
# ============================================================
# 🔐 API Endpoint Security Configuration
# ============================================================
# Would you like to protect your API endpoint with an API key?
# This adds a security layer when accessing your server remotely.
# 
# Enable API key protection? (y/N): y
# 
# 🔑 API Key Generated!
# ============================================================
# API Key: Xf8k2mN9-vLp3qR5_zA7bW1cE4dY6sT0uI
# ============================================================
# 📋 IMPORTANT: Save this key - you'll need it for API calls!
#    Example usage:
#    curl -H "Authorization: Bearer Xf8k2mN9-vLp3qR5_zA7bW1cE4dY6sT0uI" \
#         http://localhost:8000/v1/models
# ============================================================
```

**Perfect for:**
- 🏠 **Local development** - No authentication needed
- 🌐 **Remote access** - Secure with generated tokens
- 🔒 **VPN/Tailscale** - Add security layer for remote endpoints

### 🛡️ **Rate Limiting**

Built-in rate limiting protects against abuse and ensures fair usage:

- **Chat Completions** (`/v1/chat/completions`): 10 requests/minute
- **Debug Requests** (`/v1/debug/request`): 2 requests/minute
- **Auth Status** (`/v1/auth/status`): 10 requests/minute
- **Health Check** (`/health`): 30 requests/minute

Rate limits are applied per IP address using a fixed window algorithm. When exceeded, the API returns HTTP 429 with a structured error response:

```json
{
  "error": {
    "message": "Rate limit exceeded. Try again in 60 seconds.",
    "type": "rate_limit_exceeded",
    "code": "too_many_requests",
    "retry_after": 60
  }
}
```

Configure rate limiting through environment variables:

```bash
RATE_LIMIT_ENABLED=true
RATE_LIMIT_CHAT_PER_MINUTE=10
RATE_LIMIT_DEBUG_PER_MINUTE=2
RATE_LIMIT_AUTH_PER_MINUTE=10
RATE_LIMIT_HEALTH_PER_MINUTE=30
```

## Running the Server

1. Verify Claude Code is installed and working:
   ```bash
   claude --version
   claude --print --model claude-3-5-haiku-20241022 "Hello"  # Test with fastest model
   ```

2. Start the server:

   **Development mode (recommended - auto-reloads on changes):**
   ```bash
   poetry run uvicorn main:app --reload --port 8000
   ```

   **Production mode:**
   ```bash
   poetry run python main.py
   ```

   **Port Options for production mode:**
   - Default: Uses port 8000 (or PORT from .env)
   - If port is in use, automatically finds next available port
   - Specify custom port: `poetry run python main.py 9000`
   - Set in environment: `PORT=9000 poetry run python main.py`

## Docker Setup Guide for Claude Code OpenAI Wrapper

This guide provides a comprehensive overview of building, running, and configuring a Docker container for the Claude Code OpenAI Wrapper. Docker enables isolated, portable, and reproducible deployments of the wrapper, which acts as an OpenAI-compatible API server routing requests to Anthropic's Claude models via the official Claude Code Python SDK (v0.0.14+). This setup supports authentication methods like Claude subscriptions (e.g., Max plan via OAuth for fixed-cost quotas), direct API keys, AWS Bedrock, or Google Vertex AI.

By containerizing the application, you can run it locally for development, deploy it to remote servers or cloud platforms, and customize behavior through environment variables and volumes. This guide assumes you have already cloned the repository and have the `Dockerfile` in the root directory. For general repository setup (e.g., Claude Code CLI authentication), refer to the sections above.

## Prerequisites
Before building or running the container, ensure the following:
- **Docker Installed**: Docker Desktop (for macOS/Windows) or Docker Engine (for Linux). Verify with `docker --version` (version 20+ recommended). Test basic functionality with `docker run hello-world`.
- **Claude Authentication Configured**: For subscription-based access (e.g., Claude Max), ensure the Claude Code CLI is authenticated on your host machine, with tokens in `~/.claude/`. This directory will be mounted into the container. Refer to the Prerequisites section above for CLI setup if needed.
- **Hardware and Software**:
  - OS: macOS (10.15+), Linux (e.g., Ubuntu 20.04+), or Windows (10+ with WSL2 for optimal volume mounting).
  - Resources: At least 4GB RAM and 2 CPU cores (Claude requests can be compute-intensive; monitor with `docker stats`).
  - Disk: ~500MB for the image, plus space for volumes.
  - Network: Stable internet for builds (dependency downloads) and runtime (API calls to Anthropic).
- **Optional**:
  - Docker Compose: For multi-service or easier configuration management. Install via Docker Desktop or your package manager (e.g., `sudo apt install docker-compose`).
  - Tools for Remote Deployment: Access to a VPS (e.g., AWS EC2, DigitalOcean), cloud registry (e.g., Docker Hub), or platform (e.g., Heroku, Google Cloud Run) if planning remote use.

## Building the Docker Image
The `Dockerfile` in the root defines a lightweight Python 3.12-based image with all dependencies (Poetry, Node.js for CLI, FastAPI/Uvicorn, and the Claude Code SDK).

1. Navigate to the repository root (where the Dockerfile is).
2. Build the image:
   ```bash
   docker build -t claude-wrapper:latest .
   ```
   - `-t claude-wrapper:latest`: Tags the image (replace `:latest` with a version like `:v1.0` for production).
   - `.`: Builds from the current directory context.
   - Build Time: 5-15 minutes on first run (subsequent builds cache layers).
   - Size: Approximately 200-300MB.

3. Verify the Build:
   ```bash
   docker images | grep claude-wrapper
   ```
   This lists the image with its tag and size.

4. Advanced Build Options:
   - No Cache (for fresh builds): `docker build --no-cache -t claude-wrapper:latest .`.
   - Platform-Specific (e.g., ARM for Raspberry Pi): `docker build --platform linux/arm64 -t claude-wrapper:arm .`.
   - Multi-Stage for Smaller Size: If optimizing, modify the Dockerfile to use multi-stage builds (e.g., separate build and runtime stages).

If using Docker Compose (see below), build with `docker-compose build`.

## Running the Container Locally
Once built, run the container to start the API server. The default port is 8000, and the API is accessible at `http://localhost:8000/v1` (e.g., `/v1/chat/completions` for requests).

### Basic Production Run
For stable, background operation:
```bash
docker run -d -p 8000:8000 \
  -v ~/.claude:/root/.claude \
  --name claude-wrapper-container \
  claude-wrapper:latest
```
- `-d`: Detached mode (runs in background).
- `-p 8000:8000`: Maps host port 8000 to the container's 8000 (change left side for host conflicts, e.g., `-p 9000:8000`).
- `-v ~/.claude:/root/.claude`: Mounts your host's authentication directory for persistent subscription tokens (essential for Claude Max access).
- `--name claude-wrapper-container`: Names the container for easy management.

### Development Run with Hot Reload
For coding/debugging (auto-reloads on file changes):
```bash
docker run -d -p 8000:8000 \
  -v ~/.claude:/root/.claude \
  -v $(pwd):/app \
  --name claude-wrapper-container \
  claude-wrapper:latest \
  poetry run uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```
- `-v $(pwd):/app`: Mounts the current directory (repo root) into the container for live code edits.
- Command Override: Uses Uvicorn with `--reload` for development.

### Using Docker Compose for Simplified Runs
Create or use an existing `docker-compose.yml` in the root for declarative configuration:
```yaml
version: '3.8'
services:
  claude-wrapper:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ~/.claude:/root/.claude
      - .:/app  # Optional for dev
    environment:
      - PORT=8000
      - MAX_TIMEOUT=600
    command: ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]  # Dev example
    restart: unless-stopped
```
- Run: `docker-compose up -d` (builds if needed, runs detached).
- Stop: `docker-compose down`.

### Post-Run Management
- View Logs: `docker logs claude-wrapper-container` (add `-f` for real-time tailing).
- Check Status: `docker ps` (lists running containers) or `docker stats` (resource usage).
- Stop/Restart: `docker stop claude-wrapper-container` and `docker start claude-wrapper-container`.
- Remove: `docker rm claude-wrapper-container` (after stopping; use `-f` to force).
- Cleanup: `docker system prune` to remove unused images/volumes.

## Custom Configuration Options
Customize the container's behavior through environment variables, volumes, and runtime flags. Most changes don't require rebuilding—just restart the container.

### Environment Variables
Env vars override defaults and can be set at runtime with `-e` flags or in `docker-compose.yml` under `environment`. They control auth, server settings, and SDK behavior.

- **Core Server Settings**:
  - `PORT=9000`: Changes the internal listening port (default: 8000; update port mapping accordingly).
  - `MAX_TIMEOUT=600`: Sets the request timeout in seconds (default: 300; increase for complex Claude queries).

- **Authentication and Providers**:
  - `ANTHROPIC_API_KEY=sk-your-key`: Enables direct API key auth (overrides subscription; generate at console.anthropic.com).
  - `CLAUDE_CODE_USE_VERTEX=true`: Switches to Google Vertex AI (requires additional vars like `GOOGLE_APPLICATION_CREDENTIALS=/path/to/creds.json`—mount the file as a volume).
  - `CLAUDE_CODE_USE_BEDROCK=true`: Enables AWS Bedrock (set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, etc.).
  - `CLAUDE_USE_SUBSCRIPTION=true`: Forces subscription mode (default behavior; set to ensure no API fallback).

- **Security and API Protection**:
  - `API_KEYS=key1,key2`: Comma-separated list of API keys required for endpoint access (clients must send `Authorization: Bearer <key>`).

- **Custom/Advanced Vars**:
  - `MAX_THINKING_TOKENS=4096`: Custom token budget for extended thinking (if implemented in code; e.g., for `budget_tokens` in SDK calls).
  - `ANTHROPIC_CUSTOM_HEADERS='{"anthropic-beta": "extended-thinking-2024-10-01"}'`: JSON string for custom SDK headers (parse in `main.py` if needed).
  - Add more by modifying `main.py` to read `os.getenv('YOUR_VAR')` and rebuild.

Example with Env Vars:
```bash
docker run ... -e PORT=9000 -e ANTHROPIC_API_KEY=sk-your-key ...
```

For persistence across runs, use a `.env` file in the root (e.g., `PORT=8000`) and mount it: `-v $(pwd)/.env:/app/.env`. Load vars in code if required.

### Volumes for Data Persistence and Customization
Volumes mount host directories/files into the container, enabling persistence and config overrides.

- **Authentication Volume (Required for Subscriptions)**: `-v ~/.claude:/root/.claude` – Shares tokens and `settings.json` (edit on host for defaults like `"max_tokens": 8192`; restart container to apply).
- **Code Volume (Dev Only)**: `-v $(pwd):/app` – Allows live edits without rebuilds.
- **Custom Config Volumes**: 
  - Mount a custom config: `-v /path/to/custom.json:/app/config/custom.json` (load in code).
  - Logs: `-v /path/to/logs:/app/logs` for external log access.
- **Credential Files**: For Vertex/Bedrock, `-v /path/to/creds.json:/app/creds.json` and set env var to point to it.

Volumes survive container restarts but are deleted on `docker rm -v`. Use named volumes for better management (e.g., `docker volume create claude-auth` and `-v claude-auth:/root/.claude`).

### Runtime Flags and Overrides
- Resource Limits: `--cpus=2 --memory=2g` to cap CPU/RAM (prevent overconsumption).
- Network: `--network host` for host networking (useful for local integrations).
- Restart Policy: `--restart unless-stopped` for auto-recovery on crashes.
- User: `--user $(id -u):$(id -g)` to run as your host user (avoid root permissions).

Per-request configs (e.g., `max_tokens`, `model`) are handled in API payloads, not container flags.

## Using the Container Remotely
For remote access (e.g., from other machines or production deployment), extend the local setup.

### Exposing Locally for Remote Access
- Bind to All Interfaces: Already done with `--host 0.0.0.0`.
- Firewall: Open port 8000 on your host (e.g., `ufw allow 8000` on Ubuntu).
- Tunneling: Use ngrok for temporary exposure: Install ngrok, run `ngrok http 8000`, and use the public URL.
- Security: Always add `API_KEYS` and use HTTPS (via reverse proxy).

### Deploying to a Remote Server or VPS
1. Push Image to Registry: 
   ```bash
   docker tag claude-wrapper:latest yourusername/claude-wrapper:latest
   docker push yourusername/claude-wrapper:latest
   ```
   (Create a Docker Hub account if needed.)

2. On Remote Server (e.g., AWS EC2, DigitalOcean Droplet):
   - Install Docker.
   - Pull Image: `docker pull yourusername/claude-wrapper:latest`.
   - Run: Use the production command above, but copy `~/.claude/` to the server first (e.g., via scp) or re-auth CLI remotely.
   - Persistent Storage: Use server volumes (e.g., `-v /server/path/to/claude:/root/.claude`).
   - Background: Use systemd or screen for daemonization.

3. Cloud Platforms:
   - **Heroku**: Use `heroku container:push web` after installing Heroku CLI; set env vars in dashboard.
   - **Google Cloud Run**: `gcloud run deploy --image yourusername/claude-wrapper --port 8000 --allow-unauthenticated`.
   - **AWS ECS**: Create a task definition with the image, set env vars, and deploy as a service.
   - Scaling: Platforms like Kubernetes can auto-scale based on load.

4. HTTPS and Security for Remote:
   - Use a Reverse Proxy: Add Nginx/Apache in another container (e.g., via Compose) with SSL (Let's Encrypt).
   - Example Nginx Config (mount as volume): Redirect HTTP to HTTPS, proxy to 8000.
   - Monitoring: Integrate CloudWatch/Prometheus for logs/metrics.

Remote usage respects your Claude quotas (shared across instances). For high availability, use load balancers.

## Testing the Container
Validate setup post-run:
1. Health Check: `curl http://localhost:8000/health` (expect `{"status": "healthy"}`).
2. Models List: `curl http://localhost:8000/v1/models`.
3. Completion Request: 
   ```bash
   curl http://localhost:8000/v1/chat/completions \
     -H "Content-Type: application/json" \
     -d '{"model": "claude-3-5-sonnet-20240620", "messages": [{"role": "user", "content": "Hello"}]}'
   ```
4. Tool/Subscription Test: Send multiple requests; check logs for auth mode.
5. Remote Test: From another machine, curl the server's IP/port.

Use `test_endpoints.py` from the repo (mount code and run inside container: `docker exec claude-wrapper-container poetry run python test_endpoints.py`).

## Troubleshooting
- **Build Fails**: Check Dockerfile syntax; clear cache (`--no-cache`); ensure internet.
- **Run Errors**:
  - Auth: Verify `~/.claude` mount; re-auth CLI.
  - Port in Use: Change mapping or kill processes (`lsof -i:8000`).
  - Dep Issues: Rebuild; check Poetry lock file.
- **Remote Access Problems**: Firewall rules, DNS, or use `--network host`.
- **Performance**: Increase resources (`--cpus`); switch models.
- **Logs/Debug**: `docker logs -f claude-wrapper-container`; enter shell `docker exec -it claude-wrapper-container /bin/bash`.
- **Cleanup**: `docker system prune -a` for full reset.

Report issues on GitHub with logs/image tag/OS details.

## Usage Examples

### Using curl

```bash
# Basic chat completion (no auth)
curl -X POST http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [
      {"role": "user", "content": "What is 2 + 2?"}
    ]
  }'

# With API key protection (when enabled)
curl -X POST http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your-generated-api-key" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [
      {"role": "user", "content": "Write a Python hello world script"}
    ],
    "stream": true
  }'
```

### Using OpenAI Python SDK

```python
from openai import OpenAI

# Configure client (automatically detects auth requirements)
client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="your-api-key-if-required"  # Only needed if protection enabled
)

# Alternative: Let examples auto-detect authentication
# The wrapper's example files automatically check server auth status

# Basic chat completion
response = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "What files are in the current directory?"}
    ]
)

print(response.choices[0].message.content)
# Output: Fast response without tool usage (default behavior)

# Enable tools when you need them (e.g., to read files)
response = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022",
    messages=[
        {"role": "user", "content": "What files are in the current directory?"}
    ],
    extra_body={"enable_tools": True}  # Enable tools for file access
)
print(response.choices[0].message.content)
# Output: Claude will actually read your directory and list the files!

# Use OpenAI Function Calling format
tools = [{
    "type": "function",
    "function": {
        "name": "list_directory",
        "description": "List contents of a directory",
        "parameters": {
            "type": "object",
            "properties": {
                "path": {"type": "string", "description": "Directory path"}
            }
        }
    }
}]

response = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022",
    messages=[{"role": "user", "content": "List files in the current directory"}],
    tools=tools,
    tool_choice="auto"
)

# Check if Claude wants to use tools
if response.choices[0].message.tool_calls:
    print("Claude wants to call:", response.choices[0].message.tool_calls[0].function.name)

# Check real costs and tokens
print(f"Cost: ${response.usage.total_tokens * 0.000003:.6f}")  # Real cost tracking
print(f"Tokens: {response.usage.total_tokens} ({response.usage.prompt_tokens} + {response.usage.completion_tokens})")

# Streaming
stream = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022",
    messages=[
        {"role": "user", "content": "Explain quantum computing"}
    ],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

## Supported Models

- `claude-sonnet-4-20250514` (Recommended)
- `claude-opus-4-20250514`
- `claude-3-7-sonnet-20250219`
- `claude-3-5-sonnet-20241022`
- `claude-3-5-haiku-20241022`

The model parameter is passed to Claude Code via the `--model` flag.

## Function Calling / Tools 🆕

The wrapper now supports OpenAI's function calling format, allowing you to use Claude's powerful tools (file operations, web search, command execution) through the standard OpenAI API.

### Three Ways to Use Tools

1. **OpenAI Function Calling Format** (Recommended for compatibility):
```python
tools = [{
    "type": "function",
    "function": {
        "name": "read_file",
        "description": "Read the contents of a file",
        "parameters": {
            "type": "object",
            "properties": {
                "path": {"type": "string", "description": "File path"}
            },
            "required": ["path"]
        }
    }
}]

response = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022",
    messages=[{"role": "user", "content": "Read the README.md file"}],
    tools=tools,
    tool_choice="auto"  # or "none", or specific function
)
```

2. **Enable All Claude Tools** (Simple but Claude-specific):
```python
response = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022",
    messages=[{"role": "user", "content": "What's in this directory?"}],
    extra_body={"enable_tools": True}
)
```

3. **Legacy Function Format** (For older OpenAI clients):
```python
functions = [{
    "name": "get_weather",
    "description": "Get weather for a location",
    "parameters": {
        "type": "object",
        "properties": {
            "location": {"type": "string"}
        }
    }
}]

response = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022",
    messages=[{"role": "user", "content": "What's the weather?"}],
    functions=functions,
    function_call="auto"
)
```

### Available Tools

- **read_file** - Read file contents
- **write_file** - Write content to files
- **edit_file** - Edit files by replacing text
- **run_command** - Execute bash commands
- **list_directory** - List directory contents
- **search_files** - Search for files by pattern
- **search_in_files** - Search within file contents
- **web_search** - Search the web
- **fetch_url** - Fetch content from URLs

### Tool Response Handling

When Claude uses a tool, you'll receive a response with `tool_calls`:

```python
message = response.choices[0].message
if message.tool_calls:
    for tool_call in message.tool_calls:
        print(f"Tool: {tool_call.function.name}")
        print(f"Arguments: {tool_call.function.arguments}")
        
        # Execute the tool and continue the conversation
        tool_result = execute_tool(tool_call)  # Your implementation
        
        messages.append(message)  # Add assistant message with tool calls
        messages.append({
            "role": "tool",
            "tool_call_id": tool_call.id,
            "content": json.dumps(tool_result)
        })
        
        # Get final response
        final_response = client.chat.completions.create(
            model="claude-3-5-sonnet-20241022",
            messages=messages
        )
```

### Examples

See `examples/tools_example.py` for complete examples of using tools with the OpenAI SDK.

## Session Continuity 🆕

The wrapper now supports **session continuity**, allowing you to maintain conversation context across multiple requests. This is a powerful feature that goes beyond the standard OpenAI API.

### How It Works

- **Stateless Mode** (default): Each request is independent, just like the standard OpenAI API
- **Session Mode**: Include a `session_id` to maintain conversation history across requests

### Using Sessions with OpenAI SDK

```python
import openai

client = openai.OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="not-needed"
)

# Start a conversation with session continuity
response1 = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022",
    messages=[
        {"role": "user", "content": "Hello! My name is Alice and I'm learning Python."}
    ],
    extra_body={"session_id": "my-learning-session"}
)

# Continue the conversation - Claude remembers the context
response2 = client.chat.completions.create(
    model="claude-3-5-sonnet-20241022", 
    messages=[
        {"role": "user", "content": "What's my name and what am I learning?"}
    ],
    extra_body={"session_id": "my-learning-session"}  # Same session ID
)
# Claude will remember: "Your name is Alice and you're learning Python."
```

### Using Sessions with curl

```bash
# First message (add -H "Authorization: Bearer your-key" if auth enabled)
curl -X POST http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [{"role": "user", "content": "My favorite color is blue."}],
    "session_id": "my-session"
  }'

# Follow-up message - context is maintained
curl -X POST http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022", 
    "messages": [{"role": "user", "content": "What's my favorite color?"}],
    "session_id": "my-session"
  }'
```

### Session Management

The wrapper provides endpoints to manage active sessions:

- `GET /v1/sessions` - List all active sessions
- `GET /v1/sessions/{session_id}` - Get session details
- `DELETE /v1/sessions/{session_id}` - Delete a session
- `GET /v1/sessions/stats` - Get session statistics

```bash
# List active sessions
curl http://localhost:8000/v1/sessions

# Get session details
curl http://localhost:8000/v1/sessions/my-session

# Delete a session
curl -X DELETE http://localhost:8000/v1/sessions/my-session
```

### Session Features

- **Automatic Expiration**: Sessions expire after 1 hour of inactivity
- **Streaming Support**: Session continuity works with both streaming and non-streaming requests
- **Memory Persistence**: Full conversation history is maintained within the session
- **Efficient Storage**: Only active sessions are kept in memory

### Examples

See `examples/session_continuity.py` for comprehensive Python examples and `examples/session_curl_example.sh` for curl examples.

## API Endpoints

### Core Endpoints
- `POST /v1/chat/completions` - OpenAI-compatible chat completions (supports `session_id` and `tools`)
- `GET /v1/models` - List available models
- `GET /v1/tools` - List available tools/functions 🆕
- `GET /v1/auth/status` - Check authentication status and configuration
- `GET /health` - Health check endpoint

### Session Management Endpoints 🆕
- `GET /v1/sessions` - List all active sessions
- `GET /v1/sessions/{session_id}` - Get detailed session information
- `DELETE /v1/sessions/{session_id}` - Delete a specific session
- `GET /v1/sessions/stats` - Get session manager statistics

## Limitations & Roadmap

### 🚫 **Current Limitations**
- **Images in messages** are converted to text placeholders
- **OpenAI parameters** not yet mapped: `temperature`, `top_p`, `max_tokens`, `logit_bias`, `presence_penalty`, `frequency_penalty`
- **Multiple responses** (`n > 1`) not supported

### 🛣 **Planned Enhancements** 
- [ ] **Tool configuration** - allowed/disallowed tools endpoints  
- [ ] **OpenAI parameter mapping** - temperature, top_p, max_tokens support
- [ ] **Enhanced streaming** - better chunk handling
- [ ] **MCP integration** - Model Context Protocol server support

### ✅ **Recent Improvements**
- **✅ Function Calling**: Full OpenAI function calling support with all Claude tools! 🎉
- **✅ SDK Integration**: Official Python SDK replaces subprocess calls
- **✅ Real Metadata**: Accurate costs and token counts from SDK
- **✅ Multi-auth**: Support for CLI, API key, Bedrock, and Vertex AI authentication  
- **✅ Session IDs**: Proper session tracking and management
- **✅ System Prompts**: Full support via SDK options
- **✅ Session Continuity**: Conversation history across requests with session management

## Troubleshooting

1. **Claude CLI not found**:
   ```bash
   # Check Claude is in PATH
   which claude
   # Update CLAUDE_CLI_PATH in .env if needed
   ```

2. **Authentication errors**:
   ```bash
   # Test authentication with fastest model
   claude --print --model claude-3-5-haiku-20241022 "Hello"
   # If this fails, re-authenticate if needed
   ```

3. **Timeout errors**:
   - Increase `MAX_TIMEOUT` in `.env`
   - Note: Claude Code can take time for complex requests

## Testing

### 🧪 **Quick Test Suite**
Test all endpoints with a simple script:
```bash
# Make sure server is running first
poetry run python test_endpoints.py
```

### 📝 **Basic Test Suite**
Run the comprehensive test suite:
```bash
# Make sure server is running first  
poetry run python test_basic.py

# With API key protection enabled, set TEST_API_KEY:
TEST_API_KEY=your-generated-key poetry run python test_basic.py
```

The test suite automatically detects whether API key protection is enabled and provides helpful guidance for providing the necessary authentication.

### 🔍 **Authentication Test**
Check authentication status:
```bash
curl http://localhost:8000/v1/auth/status | python -m json.tool
```

### ⚙️ **Development Tools**
```bash
# Install development dependencies
poetry install --with dev

# Format code
poetry run black .

# Run full tests (when implemented)
poetry run pytest tests/
```

### ✅ **Expected Results**
All tests should show:
- **4/4 endpoint tests passing**
- **4/4 basic tests passing** 
- **Authentication method detected** (claude_cli, anthropic, bedrock, or vertex)
- **Real cost tracking** (e.g., $0.001-0.005 per test call)
- **Accurate token counts** from SDK metadata

## License

MIT License

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
