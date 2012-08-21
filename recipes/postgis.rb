include_recipe "postgresql::server"

POSTGRES_VERSION = node[:postgresql][:version]
POSTGIS_VERSION = node[:geodjango][:postgis][:version]

package "postgresql-#{POSTGRES_VERSION}-postgis"
package "postgresql-server-dev-#{POSTGRES_VERSION}"

bash "create_postgis_template" do
  user "postgres"
  code <<-EOH
    # Modified from https://docs.djangoproject.com/en/dev/_downloads/create_template_postgis-debian.sh

    POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-#{POSTGIS_VERSION}

    createdb -E UTF8 template_postgis && \
      ( createlang -d template_postgis -l | grep plpgsql || createlang -d template_postgis plpgsql ) && \
      psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';" && \
      psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql && \
      psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql && \
      psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;" && \
      psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;" && \
      psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
  EOH
  not_if 'psql -c "\l" | grep "template_postgis"', :user => "postgres"
end
