include_recipe "build-essential"

version = node[:geodjango][:proj4][:version]
datumgrid = node[:geodjango][:proj4][:datumgrid][:version]

remote_file "#{Chef::Config[:file_cache_path]}/proj-#{version}.tar.gz" do
	source "http://download.osgeo.org/proj/proj-#{version}.tar.gz"
	action :create_if_missing
end

remote_file "#{Chef::Config[:file_cache_path]}/proj-datumgrid-#{datumgrid}.zip" do
	source "http://download.osgeo.org/proj/proj-datumgrid-#{datumgrid}.zip"
	action :create_if_missing
end

bash "compile_proj4_source" do
	cwd Chef::Config[:file_cache_path]
	code <<-EOH
		tar xzf proj-#{version}.tar.gz
		cd proj-#{version}/nad
		unzip ../../proj-datumgrid-#{datumgrid}.zip
		cd ..
		./configure 
		make 
	EOH
	creates "#{Chef::Config[:file_cache_path]}/proj-#{version}"
end

bash "install_proj4" do
	cwd Chef::Config[:file_cache_path]
	code <<-EOH
		cd proj-#{version}
		make install
		ldconfig
	EOH
end