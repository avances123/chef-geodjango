include_recipe "postgresql::server"
include_recipe "geodjango::postgis_client"

package "libpq-dev" # for pg_config

version = node[:geodjango][:postgis][:version]

bash "create_postgis_template" do
  user "postgres"
  code <<-EOH
    POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-#{version.split('.').slice(0,2).join('.')}

    # Creating the template spatial database.
    createdb template_postgis
    createlang -d template_postgis plpgsql

    # Allows non-superusers the ability to create from this template
    psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"
    # Loading the PostGIS SQL routines
    psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql
    psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql
    
    # Enabling users to alter spatial tables.
    psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
    psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
    psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
  EOH
end