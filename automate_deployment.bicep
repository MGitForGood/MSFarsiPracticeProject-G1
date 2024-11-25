@description('Location for resources in Canada')
param locationCanada string = 'Canada Central'

@description('Location for resources in Germany')
param locationGermany string = 'germanywestcentral'

@description('Name of the Storage Account in Canada')
param storageAccountName string = 'stracctestca'

@description('Name of the Blob Container in the Storage Account')
param blobContainerName string = 'blob67'

@description('Name of the Log Analytics Workspace in Canada')
param logAnalyticsName string = 'logWS-analytics67-test-canada-001'

@description('Name of the VNet in Canada')
param vnetCanadaName string = 'vnet-vnet67-test-canada-001'

@description('Name of the VNet in Germany')
param vnetGermanyName string = 'vnet-vnet67-test-germany-001'

@description('Name of the Virtual Machine in Germany')
param vmGermanyName string = 'vm-vm67-test-germany-001'

@description('Name of the Automation Account in Germany')
param automationAccountName string = 'autoAcc-automate67-test-germany-001'

// کانادا: ایجاد Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: locationCanada
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
  }
}

// کانادا: ایجاد Blob Container
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${storageAccount.name}/default/${blobContainerName}'
  properties: {}
}

// کانادا: ایجاد Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsName
  location: locationCanada
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// کانادا: ایجاد VNet
resource vnetCanada 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetCanadaName
  location: locationCanada
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/26'
      ]
    }
  }
}

// آلمان: ایجاد VNet
resource vnetGermany 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetGermanyName
  location: locationGermany
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/26'
      ]
    }
subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '172.16.0.0/27'
        }
      }
    ]
  }
}

// آلمان: ایجاد VM
resource vmGermany 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmGermanyName
  location: locationGermany
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1ms'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-10'
        sku: '20h2-ent'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'amir-vmpc'
      adminUsername: 'amir'
      adminPassword: 'P@ssw0rd1234!' // در محیط واقعی از Key Vault استفاده کنید
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

// آلمان: ایجاد Network Interface برای VM
resource networkInterface 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: '${vmGermanyName}-nic'
  location: locationGermany
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnetGermany.properties.subnets[0].id
        }
        privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// آلمان: ایجاد Automation Account
resource automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: automationAccountName
  location: locationGermany
  properties: {
		sku: {	name: 'Free' // یا Basic
		}
  }
}
@description('Name of the App Service Plan')
param appServicePlanName string = 'appSvcPln-appPlan-test-canada-001'

@description('Name of the App Service')
param appServiceName string = 'appSvc-appSvc67-test-canada-001'

@description('Location for resources')
param location string = 'canadacentral'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'P1v2' // Adjust based on your requirement
    tier: 'PremiumV2'
    capacity: 1
  }
}
resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlan.id // This links the App Service to the App Service Plan
  }
  kind: 'app'
  dependsOn: [
    appServicePlan
  ]
}

@description('Name of the NSG in Canada Central')
param canadaNsgName string = 'nsg-nsg-test-canada-001'

@description('Name of the NSG in Germany West Central')
param germanyNsgName string = 'nsg-nsg-test-germany-001'

@description('Location for Canada Central NSG')
param canadaLocation string = 'canadacentral'

@description('Location for Germany West Central NSG')
param germanyLocation string = 'germanywestcentral'

resource canadaNsg 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: canadaNsgName
  location: canadaLocation
  properties: {}
}

resource germanyNsg 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: germanyNsgName
  location: germanyLocation
  properties: {}
}
/*
//@description('Name of the first VNet')
//param vnet1Name string = 'vnet-vnet67-test-canada-001'

//@description('Name of the second VNet')
//param vnet2Name string = 'vnet-vnet67-test-germany-001'

@description('Resource Group of the first VNet')
param vnet1ResourceGroup string = 'sch-Amir-Farahanchi-rg'

@description('Resource Group of the second VNet')
param vnet2ResourceGroup string = 'sch-Amir-Farahanchi-rg'

//@description('Location of the first VNet')
//param vnet1Location string = 'canadacentral'

//@description('Location of the second VNet')
//param vnet2Location string = 'germanywestcentral'

resource vnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  //name: 'vnetCa-to-vnetGer'
  name: '${vnetCanadaName}-peer${vnetGermanyName}/virtualNetworkPeerings'
  location: vnetCanada.location
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(vnet2ResourceGroup, 'Microsoft.Network/virtualNetworks', vnetGermany.name)
    }
  }
}

resource vnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  //name: 'vnetGer-to-vnetCa'
  name: '${vnetGermanyName}-peer${vnetCanadaName}/virtualNetworkPeerings'
  location: vnetGermany.location
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(vnet1ResourceGroup, 'Microsoft.Network/virtualNetworks', vnetCanada.name)
    }
  }
}
*/
