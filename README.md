# cr - Create GitHub Repositories from the Command Line

The `cr` script is a simple tool to create new private GitHub repositories in your GitHub account or organization directly from the command line. It uses the GitHub API and `curl`.

## Installation

Clone the repository:

    $ git clone https://github.com/jonatkinson/cr && cd cr

Copy the `cr` script to `/usr/local/bin`, or `~/bin/` or somewhere on your `PATH` to make it globally accessible, and then executable. This operation might require sudo.

    $ sudo cp ./cr /usr/local/bin
    $ sudo chmod +x /usr/local/bin/cr

Generate a GitHub personal access token (PAT) with `repo` and `admin:org` permissions. Save the token in ~/.config/cr/config:

    $ mkdir -p ~/.config/cr
    $ echo "YOUR_GITHUB_TOKEN" > ~/.config/cr/config

Set your default organisation:

    $ echo "your-default-org" > ~/.config/cr/organisation

## Usage

    $ cr <repo-name>
    $ cr <org-name> <repo-name>

## Example Usage

    $ cr myorg myrepo
    Repository 'myrepo' created successfully in organization 'myorg'.
