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
    
    if !File.exists?(@node[:import_local_dump][:path].to_s)
      Chef::Log.info(@node[:import_local_dump][:path]+" dump missing. Aborting")
      exit(130)
    else
      # load the initial demo database from deployed SQL script.
      # no schema provided for this import call
      db_sqlserver_database "noschemayet" do
        server_name @node[:db_sqlserver][:server_name]
        script_path "c:/tmp/"+sql_dump
        action :run_script
      end

      @node[:db_sqlserver_import_dump_from_s3_executed] = true
    end
  end
end