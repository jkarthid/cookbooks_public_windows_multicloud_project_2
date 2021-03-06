# Cookbook Name:: app_iis
# Recipe:: msdeploy_from_archive
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved

# start the default website
powershell "Restores an IIS Web Deploy SQL package to an SQL server" do
  parameters({'SQL_PACKAGE' => @node[:app_iis][:sql_package], 'DATABASE_NAME' => @node[:app_iis][:database_name],'SQL_INSTANCE_NAME' => @node[:app_iis][:sql_instance_name]})
  # Create the powershell script
  powershell_script = <<'POWERSHELL_SCRIPT'
    #tell the script to "stop" or "continue" when a command fails
    $ErrorActionPreference = "stop"
    
    # Add IIS Web Deploy to path
    $msdeployPath="C:\Program Files\IIS\Microsoft Web Deploy"
    $env:path="$env:path;$msdeployPath"

    # Create MS SQL connection string
    $SQLConnectionString = "Data Source=$env:SQL_INSTANCE_NAME;Integrated Security=SSPI;Initial Catalog=$env:DATABASE_NAME"

    # Find archive folder
    $SQL_PACKAGE_FOLDER = split-path $env:SQL_PACKAGE
    cd $SQL_PACKAGE_FOLDER
    
    # Setup MS deploy arguments
    $msdeployArguments = "-verb:sync -source:package=$env:SQL_PACKAGE -dest:dbFullSql=`"$SQLConnectionString`""

    # Run web deploy
    Start-Process `
            -FilePath "$msdeployPath\msdeploy.exe" `
            -ArgumentList $msdeployArguments `
            -WorkingDirectory "$SQL_PACKAGE_FOLDER" `
            -RedirectStandardError stderr.txt `
            -RedirectStandardOutput stdout.txt `
            -Wait

    # Display output
    "STDOUT : " + (gc stdout.txt)
    "STDERR : " + (gc stderr.txt)

    gci *.*

    # Clean up files
    if (Test-Path(".\stdout.txt")) { rm .\stdout.txt}
    if (Test-Path(".\stderr.txt")) { rm .\stderr.txt}
    
POWERSHELL_SCRIPT

  source(powershell_script)
end
