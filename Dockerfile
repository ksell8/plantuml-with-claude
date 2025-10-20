FROM node:22-slim

# Install Java 21 and other required packages
# Install zulu repo because we want the latest java which was post bookworm freeze
RUN apt-get update && apt-get install -y extrepo \
    && extrepo enable zulu-openjdk

RUN apt-get update && apt-get install -y \
    zulu21-jdk \
    curl \
    wget \
    unzip \
    git \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Create app directory
WORKDIR /app

# Download and install PlantUML
RUN wget -O /app/plantuml.jar https://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

# Create convenience script for PlantUML
RUN echo '#!/bin/bash\njava -jar /app/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

# Create working directory for user files
WORKDIR /workspace
