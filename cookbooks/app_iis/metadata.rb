maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "IIS recipes"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.5"

depends 'aws'

recipe "app_iis::default", "Calls app_iis::update_code_svn"
recipe "app_iis::update_code_svn", "Retrieves code from SVN then sets up website."
recipe "app_iis::update_code_s3", "Retrieves code from s3 then sets up website."
recipe "app_iis::start_default_website", "Starts the website named 'Default Web Site' if it is not already running"
recipe "app_iis::msdeploy_iis_deploy", "Uses an IIS Web Deploy archive to deploy code to an IIS 7 web server."
recipe "app_iis::msdeploy_iis_archive", "Creates an IIS Web Deploy package of the local web server."
recipe "app_iis::msdeploy_sql_archive", "Creates an IIS Web Deploy package from a SQL Server."

attribute "svn/repo_path",
  :display_name => "SVN Repo Path",
  :description => "The URL of your SVN repository where your application code will be checked out from.  Ex: http://mysvn.net/app/",
  :recipes => ["app_iis::update_code_svn"],
  :required => "required"

attribute "svn/username",
  :display_name => "SVN Username",
  :description => "The SVN username that is used to checkout the application code from SVN repository",
  :recipes => ["app_iis::update_code_svn"],
  :required => "optional",
  :default => ""

attribute "svn/password",
  :display_name => "SVN Password",
  :description => "The SVN password that is used to checkout the application code from SVN repository.",
  :recipes => ["app_iis::update_code_svn"],
  :required => "optional",
  :default => ""

attribute "svn/force_checkout",
  :display_name => "SVN Force Checkout",
  :description => "A value of 'false' will attempt an svn update where 'true' will do a full checkout",
  :recipes => ["app_iis::update_code_svn"],
  :choice => ['true', 'false'],
  :required => "required"
  
  
attribute "aws/access_key_id",
  :display_name => "Access Key Id",
  :description => "This is an Amazon credential. Log in to your AWS account at aws.amazon.com to retrieve you access identifiers. Ex: 1JHQQ4KVEVM02KVEVM02",
  :recipes => ["app_iis::update_code_s3"],
  :required => "required"
  
attribute "aws/secret_access_key",
  :display_name => "Secret Access Key",
  :description => "This is an Amazon credential. Log in to your AWS account at aws.amazon.com to retrieve your access identifiers. Ex: XVdxPgOM4auGcMlPz61IZGotpr9LzzI07tT8s2Ws",
  :recipes => ["app_iis::update_code_s3"],
  :required => "required"
  
attribute "s3/application_code_package",
  :display_name => "Application Package",
  :description => "The name of the application package that can be retrieved from the S3 bucket. Ex: productioncode.zip",
  :recipes => ["app_iis::update_code_s3"],
  :required => "required"

attribute "s3/application_code_bucket",
  :display_name => "Application Bucket",
  :description => "The S3 bucket, where the application can be retrieved. Ex: production-code-bucket",
  :recipes => ["app_iis::update_code_s3"],
  :required => "required"

attribute "app_iis/iis_package",
  :display_name => "IIS Web Deploy Package",
  :description => "Full path to the IIS Web Deploy Package containing an IIS web server dump. For E.g. C:\\myfiles\\myapp.zip",
  :recipes => ["app_iis::msdeploy_iis_deploy","app_iis::msdeploy_iis_archive"],
  :required => "required"
  
attribute "app_iis/sql_package",
  :display_name => "IIS Web Deploy SQL Package",
  :description => "Full path to the IIS Web Deploy SQL Package file. For E.g. C:\\myfiles\\mydata.zip",
  :recipes => ["app_iis::msdeploy_sql_archive"],
  :required => "required"
  
attribute "app_iis/sql_instance_name",
  :display_name => "SQL Instance name",
  :description => "SQL instance that will be used to deploy to/from using msdeploy. For E.g. .\SQLExpress or .",
  :recipes => ["app_iis::msdeploy_sql_archive"],
  :required => "required"
  
attribute "app_iis/database_name",
  :display_name => "Database Name",
  :description => "Name of the database on an SQL that will be the source/target of an msdeploy. For E.g. app_test",
  :recipes => ["app_iis::msdeploy_sql_archive"],
  :required => "required"
 
