name              "geodjango"
license           "MIT"
description       "Installs GeoDjango requirements for Postgres"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
recipe            "geodjango", "Includes geodjango::server"
recipe            "geodjango::server", "Includes geodjango::postgis_server"
recipe            "geodjango::client", "Includes geodjango::postgis_client"
recipe            "geodjango::postgis_server", "Installs PostGIS on a PostgreSQL server"
recipe            "geodjango::postgis_client", "Installs PostGIS on a client"
recipe            "geodjango::geos", "Installs GEOS"
recipe            "geodjango::proj4", "Installs PROJ.4"

%w{ ubuntu debian }.each do |os|
  supports os
end