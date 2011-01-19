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
    # Execute only on first boot
    if ($env:RS_REBOOT -eq $true) { exit 0 } 
	
    # Set Error action preference
	$errorActionPreference = "stop"
	

	# Set the Timezone using input variable
	switch ($env:TIMEZONE) 
	{
		"US/Central" {$tzset="Central Standard Time"}
		"GMT" {$tzset="GMT Standard Time"}
		"UTC" {$tzset="UTC"}
		"Europe/Helsinki" {$tzset="FLE Standard Time"}
		"Europe/Moscow" {$tzset="Russian Standard Time"}
		"US/Mountain" {$tzset="Mountain Standard Time"}
		"US/Pacific" {$tzset="Pacific Standard Time"}
		"US/Eastern" {$tzset="Eastern Standard Time"}
		"Europe/London" {$tzset="GMT Standard Time"}
		"Europe/Paris" {$tzset="Romance Standard Time"}
		default { $tzset = "UTC" } 
	}
	
	cd "$env:ATTACHMENTS_PATH"
	Start-Process -FilePath ".\TimezoneTool.exe" -RedirectStandardError "error.txt" -ArgumentList """$tzset"""
POWERSHELL_SCRIPT

  source(powershell_script)
end