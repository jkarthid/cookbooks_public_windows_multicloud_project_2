# Cookbook Name:: utilities
# Recipe:: Installs Web Deployment Tool
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved


powershell "Installs Web Deployment Tool" do
  attachments_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'files', 'install_web_deployment_tool'))
  parameters({'ATTACHMENTS_PATH' => attachments_path})

  
  # Create the powershell script
  powershell_script = <<'POWERSHELL_SCRIPT'
    # Execute only on first boot
    if ($env:RS_REBOOT -eq $true) { exit 0 } 
	
    # Set Error action preference
	$errorActionPreference = "stop"
	
	# Install Web Deployment Tool
	cd "$env:ATTACHMENTS_PATH"
	.\WebDeploy_x86_en-US.msi /quiet
POWERSHELL_SCRIPT

  source(powershell_script)
end