# Using official Python slim image for a smaller footprint
FROM python:3.13.0-slim

# Set username from build argument
ARG BUILD_USER=appuser
ENV USER=$BUILD_USER \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_PROJECT_ENVIRONMENT=/usr/local

# Derive APP_HOME from USER
ENV APP_HOME=/home/$USER

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash $USER


# Download the latest installer
COPY --from=ghcr.io/astral-sh/uv:0.7.2 /uv /uvx /bin/

# Set application directory and working directory
ENV APP_DIR=$APP_HOME
WORKDIR $APP_DIR

# Print debug information
RUN echo "Configuration: USER=$USER, APP_HOME=$APP_HOME, APP_DIR=$APP_DIR"

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    --mount=type=bind,source=./uv.lock,target=uv.lock \
    --mount=type=bind,source=./pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project

# Copy only necessary files
COPY pyproject.toml $APP_DIR
COPY uv.lock $APP_DIR
COPY *.py $APP_DIR/

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --frozen

ENV PYTHONPATH=$APP_DIR

RUN chown -R "$USER":"$USER" $APP_DIR
USER $USER

# Final debug output
RUN echo "Final configuration - APP_HOME: $APP_HOME, USER: $USER, APP_DIR: $APP_DIR"

EXPOSE 8000

CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]