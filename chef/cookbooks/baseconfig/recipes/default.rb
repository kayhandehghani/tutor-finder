## Make sure the Apt package lists are up to date, so we're downloading versions that exist.
#==========================================================================================
execute 'apt_update' do
  command 'apt-get update'
end
#
## Base configuration recipe in Chef.
#==========================================================================================
package "wget"
package "ntp"
cookbook_file "ntp.conf" do
  path "/etc/ntp.conf"
end
execute 'ntp_restart' do
  command 'service ntp restart'
end

#Rails setup
#==========================================================================================
package "ruby1.9.1-dev"
package "zlib1g-dev"

execute 'gems' do
    command 'gem install rails'
end

#nodejs package
#==========================================================================================
package 'nodejs'

 
#MySql package
#==========================================================================================
package 'mysql-server'

execute 'mysqlpackages' do
	command 'echo "y" | sudo apt-get install mysql-client libmysqlclient-dev'
end


#installing bundle
#==========================================================================================
execute 'bundle_inst' do
    cwd '/home/vagrant/project/TutorFinder'
    command 'bundle install'
    user 'vagrant'
end


#Precompile assests
#==========================================================================================
execute 'asset_precompile' do
    cwd '/home/vagrant/project/TutorFinder'
    command 'RAILS_ENV=production bundle exec rake assets:precompile'
end


#Configuring mysql
#==========================================================================================

execute 'mysqlconfig' do
	command 'echo "CREATE DATABASE TF_production; USE TF_production;" | sudo mysql -u root'
end

execute 'mysqlconfig2' do
	command 'echo "GRANT ALL PRIVILEGES ON TF_production.* TO \"marker\"@\"localhost\" IDENTIFIED BY \"1234\";" | sudo mysql -u root'
end

execute 'mysqlDB_migrate' do
	cwd '/home/vagrant/project/TutorFinder'
	command 'bin/rake db:migrate RAILS_ENV=production'
	user 'vagrant'
end

# Initial Data Load
execute 'mysqlDB_load' do
	cwd '/home/vagrant/project/TutorFinder'
	command 'bin/rake db:data:load RAILS_ENV=production'
	user 'vagrant'
end


#Apache package
#==========================================================================================
package 'apache2'
package 'libapache2-mod-passenger'

cookbook_file "000-default.conf" do
	path '/etc/apache2/sites-enabled/000-default.conf'
end


#Apache restart
#==========================================================================================
execute 'restart_server' do
	command 'service apache2 restart'
end

#installing imagemagik
#==========================================================================================

execute 'imagemaigk_install' do
    command 'echo "y" | sudo apt-get install imagemagick'
end


