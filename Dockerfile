# --- Runtime stage
FROM alpine:latest as runtime
WORKDIR /root

# Set environment variable to specify which environment to build for
ARG ENV=dev
ENV ENV=${ENV}

# Create SSH directory
RUN mkdir -p /root/.ssh

# Install CompileDaemon for hot reloading
RUN go install -mod=mod github.com/githubnemo/CompileDaemon@latest

