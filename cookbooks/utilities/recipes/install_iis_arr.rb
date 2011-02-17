# Cookbook Name:: utilities
# Recipe:: Installs IIS Application Request Routing
#
# Copyright 2010, RightScale, Inc. 
#
# All rights reserved


powershell "Installs IIS Application Request Routing Vresion 2.1.0856" do
  attachments_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'files', 'install_iis_arr'))
  parameters({'ATTACHMENTS_PATH' => attachments_path})

  if (@node[:install_iis_arr_executed])
    Chef::Log.info("*** Recipe already executed, skipping...")
  else
      # Create the powershell script
      powershell_script = <<'POWERSHELL_SCRIPT'
 
        # Windows version must be 2008 or greater
        $osVersion = (gwmi Win32_OperatingSystem).Version
        
        if ($osVersion -lt 6)
        {
            Write-Error "Error: IIS Appication Request Routing requires Windows Server 2008 or above"
            Exit 1
        }
        else
        {
            Write-Output "Beginning IIS Application Request Routing Install..."
        }
        
        # Set Error action preference
        $errorActionPreference = "stop"
        
        # Install IIS Application Request Routing
        cd "$env:ATTACHMENTS_PATH"
        $os_arch = (gwmi win32_OperatingSystem).OSArchitecture
        if ($os_arch -eq "64-bit")
        {
            $installerExecutable = ".\ARRv2_setup_amd64_en-us.exe"
        }
        else
        {    
            $installerExecutable = ".\ARRv2_setup_amd64_en-us.exe"
        }
        
        "Executing installer $installerExecutable /Q"
        Invoke-Expression "$installerExecutable /Q"
        
        # Verify Installation was successful
        Sleep 120 # wait for installation to complete
        $product_name = "Application Request Routing Version 2"
        $check_installed = gwmi win32_product | where {$_.name -like "*$product_name*"}

        if ($check_installed -eq $null)
        {
            Write-Output "Error: Installation Failed!"
            Exit 1
        }
        else
        {
            Write-Output "Installation was successful for: $product_name"
            Write-Output $check_installed.Name
            Write-Output $check_installed.Version
        }

POWERSHELL_SCRIPT
    source(powershell_script)
    @node[:install_iis_arr_executed] = true

  end
end