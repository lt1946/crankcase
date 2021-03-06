# step descriptions for PostgreSQL cartridge behavior.

require 'postgres'
require 'fileutils'


Then /^the postgresql configuration file will( not)? exist$/ do |negate|
  pgsql_cart = @gear.carts['postgresql-8.4']

  pgsql_user_root = "#{$home_root}/#{@gear.uuid}/#{pgsql_cart.name}"
  pgsql_config_file = "#{pgsql_user_root}/data/postgresql.conf"

  begin
    cnffile = File.new pgsql_config_file
  rescue Errno::ENOENT
    cnffile = nil
  end

  unless negate
    cnffile.should be_a(File)
  else
    cnffile.should be_nil
  end
end


Then /^the postgresql database will( not)? +exist$/ do |negate|
  pgsql_cart = @gear.carts['postgresql-8.4']

  pgsql_user_root = "#{$home_root}/#{@gear.uuid}/#{pgsql_cart.name}"
  pgsql_data_dir = "#{pgsql_user_root}/data"

  begin
    datadir = Dir.new pgsql_data_dir
  rescue Errno::ENOENT
    datadir = nil
  end

  unless negate
    datadir.should include "base"
    datadir.should include "global"
    datadir.should include "pg_clog"
    datadir.should include "pg_log"
    datadir.should include "pg_xlog"
  else
    datadir.should be_nil
  end
end


Then /^the postgresql admin user will have access$/ do
  pgsql_cart = @gear.carts['postgresql-8.4']

  begin
    # FIXME: For now use psql -- we should try programatically later.
    dbconn = PGconn.connect(pgsql_cart.db.ip, 5432, '', '', 'postgres',
                            pgsql_cart.db.username, pgsql_cart.db.password)
  rescue PGError
    dbconn = nil
 end

 dbconn.should be_a(PGconn)
 dbconn.close if dbconn
end
