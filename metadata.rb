name              "geodjango"
license           "MIT"
description       "Installs GeoDjango requirements for Postgres"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
recipe            "geodjango", "Includes geodjango::postgis"
recipe            "geodjango::postgis", "Installs PostGIS"
recipe            "geodjango::geos", "Installs GEOS"
recipe            "geodjango::proj4", "Installs PROJ.4"

%w{ ubuntu debian }.each do |os|
  supports os
end