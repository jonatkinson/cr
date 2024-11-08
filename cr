#!/bin/bash

# cr - create a new GitHub repository
# Usage: cr <repo-name> or cr <org-name> <repo-name>

CONFIG_FILE="$HOME/.config/cr/config"
ORG_FILE="$HOME/.config/cr/organisation"
DEFAULT_ORG="jonatkinson"

# Check if config file exists and read GitHub API key
if [[ ! -f $CONFIG_FILE ]]; then
  echo "Error: Config file not found at $CONFIG_FILE"
  exit 1
fi

GITHUB_TOKEN=$(<"$CONFIG_FILE")

# Check if organization file exists and read organization name
if [[ -f $ORG_FILE ]]; then
  DEFAULT_ORG=$(<"$ORG_FILE")
fi

# Function to create a new repository
create_repo() {
  local org="$1"
  local repo="$2"
  local url="https://api.github.com/orgs/$org/repos"

  # Use /user/repos endpoint if creating in the personal account
  if [[ "$org" == "$DEFAULT_ORG" ]]; then
    url="https://api.github.com/user/repos"
  fi

  response=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "$url" \
    -d "{\"name\":\"$repo\",\"private\":true}")

  if [[ "$response" -eq 201 ]]; then
    echo "Repository '$repo' created successfully in organization '$org'."
    echo "To add it as a remote, use:"
    echo "git remote add origin git@github.com:$org/$repo.git"
  elif [[ "$response" -eq 422 ]]; then
    echo "Error: Repository '$repo' already exists in organization '$org'."
  elif [[ "$response" -eq 404 ]]; then
    echo "Error: Organization '$org' not found or insufficient permissions."
  else
    echo "Error: Failed to create repository. HTTP status code: $response"
  fi
}

# Main script logic
if [[ $# -eq 1 ]]; then
  create_repo "$DEFAULT_ORG" "$1"
elif [[ $# -eq 2 ]]; then
  create_repo "$1" "$2"
else
  echo "Usage: cr <repo-name> or cr <org-name> <repo-name>"
  exit 1
fi