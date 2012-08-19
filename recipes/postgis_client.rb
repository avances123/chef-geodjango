include_recipe "build-essential"
include_recipe "postgresql::client"
include_recipe "geodjango::geos"
include_recipe "geodjango::proj4"

# Packages we require
package "postgresql-server-dev-#{node[:postgresql][:version]}"
package "libxml2-dev"

version = node[:geodjango][:postgis][:version]

remote_file "#{Chef::Config[:file_cache_path]}/postgis-#{version}.tar.gz" do
  source "http://postgis.refractions.net/download/postgis-#{version}.tar.gz"
  action :create_if_missing
end

bash "compile_postgis_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xzf postgis-#{version}.tar.gz
    cd postgis-#{version}
    ./configure
    make
  EOH
  creates "#{Chef::Config[:file_cache_path]}/postgis-#{version}"
end

bash "install_postgis" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    cd postgis-#{version}
    make install
    ldconfig
  EOH
end