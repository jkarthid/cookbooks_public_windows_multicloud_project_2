# Cookbook Name:: utilities
# Recipe:: Installs Web Deployment Tool
#
# Copyright 2010, RightScale, Inc. 
#
# All rights reserved


powershell "Installs Web Deployment Tool" do
  attachments_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'files', 'install_web_deployment_tool'))
  parameters({'ATTACHMENTS_PATH' => attachments_path})

  if (@node[:install_iis_web_deployment_tool_executed])
    Chef::Log.info("*** Recipe already executed, skipping...")
  else
      # Create the powershell script
      powershell_script = <<'POWERSHELL_SCRIPT'
        # Execute only on first boot
        if ($env:RS_REBOOT -eq $true) { exit 0 } 
        
        # Set Error action preference
        $errorActionPreference = "stop"
        
        # Install Web Deployment Tool
        cd "$env:ATTACHMENTS_PATH"
        $os_arch = (gwmi win32_OperatingSystem).OSArchitecture
        if ($os_arch -eq "64-bit")
        {
            .\WebDeploy_x64_en-US.msi /quiet
        }
        else
        {    
            .\WebDeploy_x86_en-US.msi /quiet
        }
        
        
        # Verify Installation was successful
        Sleep 120 # wait for installation to complete
        $product_name = "*Web Deploy*"
        $check_installed = gwmi win32_product | where {$_.name -like $product_name}

        if ($check_installed -eq $null)
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
    @node[:install_iis_web_deployment_tool_executed] = true

  end
end