# pip install google-cloud-resource-manager

from google.cloud import resourcemanager_v3
from google.api_core.exceptions import NotFound, PermissionDenied

# ==== USER INPUT & SANITIZATION ============================================================

# 1. Project ID
client = resourcemanager_v3.ProjectsClient()

while True:
    project_id = input("Enter your project's ID: ")
    
    try:
        project = client.get_project(name=f"projects/{project_id}")
        break 
    except NotFound:
        print(f"Project ID '{project_id}' not found.\nPlease enter a valid project ID\n")
    except PermissionDenied:
        print(f"No permission to access project '{project_id}'.")

# 2. Network
while True:
    network_name = input("Enter the name of the network that you would like to create your workbench in (If the network does not exist, this script will create it for your): ")


# 3. Instance Name

# 4. Instance Location

# 5. Instance Machine Type