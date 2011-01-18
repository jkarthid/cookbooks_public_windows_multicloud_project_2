# Cookbook Name:: utilities
# Recipe:: sys_timezone_set_windows
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved

powershell "Sets Windows Timezone" do
  attachments_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'files', 'sys_timezone_set_windows'))
  parameters({'ATTACHMENTS_PATH' => attachments_path,'TIMEZONE' => @node[:utilities][:timezone]})

  
  # Create the powershell script
  powershell_script = <<'POWERSHELL_SCRIPT'
  
    # Set Error action preference
	$errorActionPreference = "stop"
	
	# Get Timezone from input variable
	
	
	
	#
	# Set the Timezone
	#

	cd "$env:ATTACHMENTS_PATH"
	Start-Process -FilePath ".\TimezoneTool.exe" -RedirectStandardError "error.txt" -RedirectStandardOutput "output.txt" -ArgumentList '"$env:TIMEZONE"'
	$output = gc ".\output.txt"
	Write-Host $output
 
POWERSHELL_SCRIPT

  source(powershell_script)
end