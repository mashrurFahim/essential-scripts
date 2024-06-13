# Git Clone and SSH Setup Script

This script automates the process of setting up SSH keys, cloning GitHub repositories, and configuring remote origins. It is designed to simplify the initial setup for new projects.

## Features

- Generates and adds an SSH key for each project to your SSH agent and SSH config.
- Clones a GitHub repository using the SSH protocol.
- Sets the remote origin of the cloned repository automatically.
- Provides steps to manually set the remote origin if automatic configuration fails.

## Prerequisites

- **Operating System**: macOS, Linux, or Windows (with Cygwin or MSYS).
- **Git**: Installed on your system.
- **SSH Key**: Ensure you have an SSH key pair (`id_ed25519_$projectname` and `id_ed25519_$projectname.pub`) generated and added to your GitHub account.

## Setup

1. **Clone the Script**:
   - Clone or download the script (`git_clone_and_setup.sh`) into your preferred directory.

2. **Set the Work Directory**:
   - Open the script (`git_clone_and_setup.sh`) in a text editor.
   - Set the `WORK_DIR` variable at the beginning of the script to your desired work directory:
     ```sh
     WORK_DIR=~/work  # Replace with your preferred directory path
     ```

3. **Make the Script Executable**:
   - Open a terminal and navigate to your script directory:
     ```sh
     cd /path/to/your/script/directory
     chmod +x git_clone_and_setup.sh
     ```

4. **Create an Alias** (Optional):
   - To simplify usage, add an alias to your shell profile (e.g., `~/.bashrc`, `~/.zshrc`):
     ```sh
     alias gcsshset='/path/to/your/script/directory/git_clone_and_setup.sh'
     ```
   - Reload your shell profile or restart your terminal:
     ```sh
     source ~/.bashrc  # or ~/.zshrc
     ```

## How to Use

1. **Run the Script**:
   - Execute the script using the alias (if set) or directly:
     ```sh
     gcsshset  # If alias is set
     # or
     ./git_clone_and_setup.sh  # Direct execution
     ```

2. **Follow the Prompts**:
   - The script will prompt you for the GitHub repository URL, project name, and your email address.
   - It will generate an SSH key specific to the project, add it to your SSH agent, and update the SSH configuration.
   - You will be prompted to add the generated public key to your GitHub account. Open the provided URL in your browser and follow the instructions.

3. **Manual Remote URL Configuration**:
   - If setting the remote origin fails automatically, the script will provide you with a command to set it manually.
   - Follow the instructions and verify the remote URL is correctly set.

4. **Completion**:
   - Once setup is complete, the script will clone the GitHub repository into a directory named after the repository.

5. **Troubleshooting**:
   - If any step fails, the script will guide you on how to reset the state and start over.


## Additional Notes

- Ensure you are running the script from within your designated work directory or its subdirectories. If not, the script will prompt you to select a subdirectory.
- For any issues or feedback, please [report them on GitHub issues](https://github.com/mashrurFahim/essential-scripts/issues).
