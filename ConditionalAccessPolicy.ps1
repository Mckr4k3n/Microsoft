# Check if the AzureAD module is installed
if (-not (Get-Module -ListAvailable -Name AzureAD)) {
    # Install the AzureAD module if not already installed
    Install-Module -Name AzureAD -Scope CurrentUser -Force -AllowClobber
}

# Import the module
Import-Module AzureAD

# Connect to Azure AD using device authentication
Connect-AzureAD -UseDeviceAuthentication

# Get all conditional access policies
$conditionalAccessPolicies = Get-AzureADMSConditionalAccessPolicy

# Create an array to store the detailed policy information
$policyDetails = @()

# Loop through each policy and extract detailed information
foreach ($policy in $conditionalAccessPolicies) {
    $policyDetails += [PSCustomObject]@{
        PolicyName           = $policy.DisplayName
        State                = $policy.State
        IncludeUsers         = ($policy.Conditions.Users.IncludeUsers -join ", ")
        ExcludeUsers         = ($policy.Conditions.Users.ExcludeUsers -join ", ")
        IncludeGroups        = ($policy.Conditions.Users.IncludeGroups -join ", ")
        ExcludeGroups        = ($policy.Conditions.Users.ExcludeGroups -join ", ")
        IncludeRoles         = ($policy.Conditions.Users.IncludeRoles -join ", ")
        ExcludeRoles         = ($policy.Conditions.Users.ExcludeRoles -join ", ")
        IncludeApplications  = ($policy.Conditions.Applications.IncludeApplications -join ", ")
        ExcludeApplications  = ($policy.Conditions.Applications.ExcludeApplications -join ", ")
        IncludeLocations     = ($policy.Conditions.Locations.IncludeLocations -join ", ")
        ExcludeLocations     = ($policy.Conditions.Locations.ExcludeLocations -join ", ")
        IncludePlatforms     = ($policy.Conditions.DevicePlatforms.IncludePlatforms -join ", ")
        ExcludePlatforms     = ($policy.Conditions.DevicePlatforms.ExcludePlatforms -join ", ")
        ClientApps           = ($policy.Conditions.ClientAppTypes -join ", ")
        InsiderRisk          = $policy.Conditions.InsignificantRisk
        SignInRisk           = ($policy.Conditions.SignInRiskLevels -join ", ")
        UserRisk             = ($policy.Conditions.UserRiskLevels -join ", ")
        FilterForDevices     = $policy.Conditions.FilterForDevices.FilterRule
        GrantControls        = ($policy.GrantControls.BuiltInControls -join ", ")
        CustomGrantControls  = ($policy.GrantControls.CustomAuthenticationFactors -join ", ")
        SessionControls      = ($policy.SessionControls -join ", ")
    }
}

# Define the path
$path = "C:InsertPathHere\ConditionalAccessPolicies.csv"

# Create the directory if it doesn't exist
$directory = [System.IO.Path]::GetDirectoryName($path)
if (-not (Test-Path -Path $directory)) {
    New-Item -ItemType Directory -Path $directory
}

# Export the detailed policy information to a CSV file
$policyDetails | Export-Csv -Path $path -NoTypeInformation

# Display a message indicating the export is complete
Write-Output "Conditional access policies have been exported to $path"