#
# Copyright (c) 2011 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

unless (!@node[:import_local_dump][:path].to_s.empty?)
  Chef::Log.info("*** Dump path not specified, skipping dump import...")
else
  if (@node[:db_sqlserver_import_local_dump_executed])
    Chef::Log.info("*** Recipe 'db_sqlserver::import_local_dump' already executed, skipping...")
  else

    #Chef::Log.info("*** Unpacking database dump.")
    powershell "Copy "+@node[:import_local_dump][:path]+" to c:/tmp/mssql-renamed.sql" do
      parameters({'DUMP_PATH' => @node[:import_local_dump][:path]})
      # Create the powershell script
      powershell_script = <<'POWERSHELL_SCRIPT'
          New-Item  c:\tmp -type directory -ErrorAction SilentlyContinue
          $Error.Clear()
          $release_path = Get-ChildItem -force "c:\Inetpub\releases" | Where-Object { ($_.Attributes -match "Directory") } | Sort-Object -descending | Select-Object FullName | Select-Object -first 1
          $dump_path = Join-Path $release_path.FullName ${env:DUMP_PATH}
          if (test-path $dump_path)
          {
            Write-output("*** MSSQL dump full path found ["+$dump_path+"], copying dump to c:/tmp/mssql-renamed.sql")
            copy-item $dump_path c:/tmp/mssql-renamed.sql
          }
          else
          {
            Write-Error("Error: The MSSQL dump file "+${env:DUMP_PATH}+" was not found in the latest release directory ("+$release_path.FullPath+")")
            exit 137
          }
POWERSHELL_SCRIPT
      source(powershell_script)
    end
    
    # load the initial demo database from deployed SQL script.
    # no schema provided for this import call
    db_sqlserver_database "noschemayet" do
      server_name @node[:db_sqlserver][:server_name]
      script_path "c:/tmp/mssql-renamed.sql"
      action :run_script
    end

    @node[:db_sqlserver_import_dump_from_s3_executed] = true
  end
end