#!/bin/bash

# Function to create SSH key, add to SSH agent, update SSH config, and set remote origin
create_ssh_key_and_clone_repo() {
    local repo_url=$1
    local project_name=$2
    local email=$3
    local repo_dir=$(basename "$repo_url" .git)
    local key_file=~/.ssh/id_ed25519_$project_name

    # Check if SSH config already has an entry for the project
    if grep -q "Host github-$project_name" ~/.ssh/config; then
        echo "SSH config already contains an entry for project '$project_name'."
        echo "Skipping SSH key creation and SSH config update."
    else
        # Generate ed25519 SSH key
        ssh-keygen -t ed25519 -C "$email" -f "$key_file" -N ""

        # Add the SSH key to the SSH agent
        eval "$(ssh-agent -s)"
        ssh-add "$key_file"

        # Add SSH config entry with a comment for identification
        echo -e "\n# SSH key for project $project_name\nHost github-$project_name\n  HostName github.com\n  User git\n  IdentityFile $key_file\n" >> ~/.ssh/config

        echo "SSH key for project '$project_name' created and added to ~/.ssh/config"
    fi

    # Output the public key and prompt user to add it to GitHub
    echo "Public key for project '$project_name' (add this to GitHub):"
    cat "$key_file.pub"

    # Open the GitHub SSH keys settings page in the default browser
    echo "Opening GitHub SSH keys settings page in your default browser..."
    case "$OSTYPE" in
      darwin*)  open "https://github.com/settings/keys" ;; 
      linux*)   xdg-open "https://github.com/settings/keys" ;;
      cygwin*|msys*) start "https://github.com/settings/keys" ;;
      *)        echo "Please open https://github.com/settings/keys manually." ;;
    esac

    read -p "Press Enter after adding the key to GitHub..."

    # Test the SSH connection
    ssh -T git@github-$project_name
    if [ $? -ne 1 ]; then
        echo "SSH connection test failed. Please make sure the key is added to GitHub and try again."
        return 1
    fi

    # Clone the repository
    git clone "$repo_url"
    if [ $? -ne 0 ]; then
        echo "Failed to clone the repository."
        return 1
    fi

    # Set the remote origin for the cloned repository
    cd "$repo_dir"
    git remote set-url origin git@github-$project_name:$(basename $(dirname "$repo_url"))/$(basename "$repo_url" .git).git
    if [ $? -ne 0 ]; then
        echo "Failed to set remote origin automatically."
        echo "Please set the remote origin manually with the following command:"
        echo "git remote set-url origin git@github-$project_name:$(basename $(dirname "$repo_url"))/$(basename "$repo_url" .git).git"
        read -p "Press Enter after setting the remote URL manually..."

        # Verify if the remote URL is set correctly
        git remote -v
        if [ $? -ne 0 ]; then
            echo "Failed to set remote URL manually."
            cd ..
            rm -rf "$repo_dir"
            sed -i "/Host github-$project_name/,+3d" ~/.ssh/config
            echo "Removed SSH config entry and deleted the cloned repository. Reset to the initial state."
            return 1
        else
            echo "Remote URL set successfully."
        fi
    fi

    echo "Remote origin set for repository '$repo_dir'"
}

# Function to list subdirectories and prompt the user to select one
select_subdirectory() {
    echo "Available subdirectories in $WORK_DIR:"
    select dir in "$WORK_DIR"/*/; do
        if [ -n "$dir" ]; then
            echo "Selected directory: $dir"
            cd "$dir"
            if [ $? -ne 0 ]; then
                echo "Failed to change to the selected directory."
                exit 1
            fi
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
}

# Main script

# Set your designated work directory
WORK_DIR=~/work

# Ensure the WORK_DIR exists
if [ ! -d "$WORK_DIR" ]; then
    echo "The specified work directory does not exist. Please create it or set the correct path in the script."
    exit 1
fi

# Always prompt the user to select a subdirectory in the work directory
select_subdirectory

# Prompt for user input
read -p "Enter the GitHub repository URL: " repo_url
read -p "Enter the project name: " project_name
read -p "Enter your email address: " email

# Create SSH key, clone repo, update config, and set remote origin
create_ssh_key_and_clone_repo "$repo_url" "$project_name" "$email"
