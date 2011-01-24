# Cookbook Name:: utilities
# Recipe:: Installs IIS Powershell Snap In
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved


powershell "Installs Web Deployment Tool" do
  attachments_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'files', 'install_iis_powershell_snapin'))
  parameters({'ATTACHMENTS_PATH' => attachments_path})

  
  # Create the powershell script
  powershell_script = <<'POWERSHELL_SCRIPT'
  
    #Tell the script to "stop" or "continue" when a command fails
    $ErrorActionPreference = "stop"
    
    # Execute only on first boot
    if ($env:RS_REBOOT -eq $true) { exit 0 } 
	
    # Set Error action preference
	$errorActionPreference = "stop"
	
	# Install IIS Powershell Snap In
	cd "$env:ATTACHMENTS_PATH"
	$os_arch = (gwmi win32_OperatingSystem).OSArchitecture
	if ($os_arch -eq "64-bit")
	{
		.\iis7psprov_x64.msi /quiet
	}
	else
	{
		.\iis7psprov_x86.msi /quiet
	}

    # Verify Installation was successful
    $product_name = "Microsoft Windows PowerShell snap-in for IIS 7.0"
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