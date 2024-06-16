import os
import re
from dotenv import dotenv_values

# Load environment variables from images.env
env_vars = dotenv_values('environment.env')

# Read the docker-template.yaml file
with open('docker-template.yaml', 'r') as yaml_file:
    yaml_content = yaml_file.read()

# Substitute environment variables in the docker-template content
for key, value in env_vars.items():
    placeholder = f"${{{key}}}"
    yaml_content = yaml_content.replace(placeholder, value)

# Find and increment the version number in the yaml content
version_pattern = re.compile(r'^# Version (\d+\.\d+)', re.MULTILINE)
match = version_pattern.search(yaml_content)
if match:
    current_version = match.group(1)
    major, minor = map(int, current_version.split('.'))
    new_version = f"{major}.{minor + 1}"
    yaml_content = version_pattern.sub(f"# Version {new_version}", yaml_content)
else:
    print("Version not found in the file. No version increment performed.")

# Save the updated content to a new file
with open('docker-compose.yaml', 'w') as combined_yaml_file:
    combined_yaml_file.write(yaml_content)

print("Combined Docker Compose file created as 'docker-compose.yaml'")
