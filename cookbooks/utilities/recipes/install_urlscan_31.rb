# Cookbook Name:: utilities
# Recipe:: Installs IIS Powershell Snap In
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved


powershell "Installs URLScan 3.1" do
  attachments_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'files', 'install_urlscan_31'))
  parameters({'ATTACHMENTS_PATH' => attachments_path})

  
  # Create the powershell script
  powershell_script = <<'POWERSHELL_SCRIPT'
    # Execute only on first boot
    if ($env:RS_REBOOT -eq $true) { exit 0 } 
	
    # Set Error action preference
	$errorActionPreference = "stop"
	
	# Install URLScan
	cd "$env:ATTACHMENTS_PATH"
	$os_arch = (gwmi win32_OperatingSystem).OSArchitecture
	if ($os_arch -eq "64-bit")
	{
		.\urlscan_v31_x64.msi /quiet
	}
	else
	{
		.\urlscan_v31_x86.msi /quiet
	}

    # Verify Installation was successfull
    
    $product_name = "Microsoft UrlScan Filter v3.1"
    $check_installed = gwmi win32_product | where {$_.name -like $product_name}

    if ($check_installed -eq $null )
    {
        Write-Output "Error: Installation Failed!"
        Exit 1
    }
    else
    {
        Write-Output "Installation was successful for: $product_name"
    }
POWERSHELL_SCRIPT

  source(powershell_script)
end