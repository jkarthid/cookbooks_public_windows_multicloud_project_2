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
		.\urlscan_v31_x86.msi /quiet
	}
	else
	{
		.\urlscan_v31_x64.msi /quiet
	}

POWERSHELL_SCRIPT

  source(powershell_script)
end