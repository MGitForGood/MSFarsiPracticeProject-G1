# Azure Deployment and Configuration Steps

### 1. Run Bicep Script
- Use **VS Code** to run the Bicep script for auto-provisioning resources.

### 2. Recover Automate Account
- Due to quota limitations, recover the Automate Account and wait for validation.
  > **Note**: Ensure no active deployment exists in the same resource group for successful validation.

### 3. Close RDP Port for Germany VM
- Disable the RDP port for the Germany VM.

### 4. Create Bastion for Germany VM
- Use the automatic method to create a Bastion for the Germany VM.
  > **Note**: Set up a virtual network with:
  - **Address space**: `172.16.0.0/12`
  - **Subnet**: `172.16.0.0/26`

### 5. Restrict Canada Storage Account Access
- Use the **'Enabled from selected virtual networks and IP addresses'** option to limit the Canada storage account to a specific virtual network.

### 6. Create Private Endpoint for App Service
- Enable **'Integrate Private DNS Zones'** when creating the private endpoint.

### 7. Enable Scaling for Web App
1. Navigate to the **'Scale out'** page.
2. Select **'Rule based'** scaling and choose **'Custom autoscale'**.
3. Set **'Scale based on metric'** as the scale mode.
4. Click on **'Add a rule'** and use **CPU percentage** as the metric.

### 8. Limit Access to App Service
- In the Germany virtual network, create a **Peering** to the Canada virtual network from the **'Remote Virtual Network'** section.

### 9. Configure Canada NSG
1. Open the **Canada NSG (Network Security Group)**.
2. Navigate to **'Inbound security rules'**.
3. Use **Service Tag** with **'Virtual Network'** for both Source and Destination.
4. Add ports `8080`, `80`, and `443`.

### 10. Configure Germany NSG
1. Open the **Germany NSG (Network Security Group)**.
2. Navigate to **'Outbound security rules'**.
3. Use **Service Tag** with **'Virtual Network'** for both Source and Destination.
4. Add ports `8080`, `80`, and `443`.

### 11. Bastion Issue Resolved
- Update:
  - Germany subnet to `172.16.0.0/24`
  - VM subnet to `/28`.

### 12. NSG Destination
- Both NSGs' destination is `10.0.0.36` (the App Service).

### 13. Upload Static Pages to App Service
- Use the **App Service Management Console** to upload files to the `/wwwroot` directory.

### 14. Activate Alerts for App Service
1. Open the App Service and select **'Alerts'**.
2. Click **'Create'** and choose the desired metric under **'Signal name'**.
3. Create an action group and select notification types or automate specific actions.

### 15. Enhance Storage Account Security
- Enable **Secure Transfer Required**.
- Disable **'Allow Blob Anonymous Access'**.

### 16. Restrict Storage Account Access
- In the **Networking** section, allow access only from the Germany VM subnet.
  > **Note**: Blobs will be inaccessible even from the Azure portal but accessible from the Germany VM.

### 17. Manage SAS Tokens
- Create a **Blob Container Access Policy** to enhance SAS token management.

### 18. Automate Dependencies with Runbooks
- Use the Automate Account Runbook to install dependencies on the Germany VM (e.g., AzCopy) and automate tasks like file uploads.

### 19. Create Hybrid Worker
- Navigate to the Automate Account, select **'Hybrid Worker Groups'**, and click **'Create'**.

### 20. Run Runbooks Manually
1. Navigate to **Runbooks** in the Automate Account.
2. Enter PowerShell code and click **'Start'**.
3. Assign it to hybrid workers, e.g., installing PowerShell 7 on Windows 10.

### 21. Schedule Runbooks
1. Go to the Automate Account and select **'Schedules'**.
2. Choose **'Recurring'** and create a schedule.
3. Assign the schedule to the desired Runbook.

### 22. Backup Using Snapshots
1. Create a snapshot of the OS disk.
2. Use the snapshot to create a new disk.
3. Create a VM from the new disk.
