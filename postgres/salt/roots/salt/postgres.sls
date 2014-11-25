# Installation of Postgres libs, client and server

#install LIBS RPM
install-postresql/postgresql93-libs-9.3.4-1PGDG.rhel6.x86_64.rpm:
  pkg.installed:
    - name: postgresql93-libs
    - sources:
      - postgresql93-libs: salt://files/postgresql93-libs-9.3.4-1PGDG.rhel6.x86_64.rpm

#Install client RPM
install-postresql/postgresql93-9.3.4-1PGDG.rhel6.x86_64.rpm:
  pkg.installed:
    - name: postgresql93
    - sources:
      - postgresql93: salt://files/postgresql93-9.3.4-1PGDG.rhel6.x86_64.rpm

#Install server RPM
install-postresql/postgresql93-server-9.3.4-1PGDG.rhel6.x86_64.rpm:
  pkg.installed:
    - name: postgresql93-server
    - sources:
      - postgresql93-server: salt://files/postgresql93-server-9.3.4-1PGDG.rhel6.x86_64.rpm

#push postgres script file in place
/tmp/.postgres:
  file.managed:
    - source: salt://files/.postgres
    - user: postgres
    - group: postgres
    - mode: 500

#Initialize postgres db unless the data folder exists
initdb:
  cmd.run:
    - name: 'service postgresql-9.3 initdb'
    - unless: test -f /var/lib/pgsql/9.3/data/PG_VERSION

# enable and start postgres service, watch for changes in config files and require installation of the server package
postgresql-9.3:
  service:
    - running
    - enable: True
  require:
    - pkg: install-postresql/postgresql93-server-9.3.4-1PGDG.rhel6.x86_64.rpm
    - cmd: initdb

#set postgres password
setpgpass:
  cmd.run:
    - name: 'sudo -u postgres psql -f /tmp/.postgres'
  require:
    - service: postgresql-9.3

#accept tcp/ip connections from all
/var/lib/pgsql/9.3/data/pg_hba.conf:
  file.managed:
    - source: salt://files/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 600
  require:
    - cmd: setpgpass

#bind listener to all addresses
/var/lib/pgsql/9.3/data/postgresql.conf:
  file.replace:
    - path: /var/lib/pgsql/9.3/data/postgresql.conf
    - pattern: "#listen_addresses = 'localhost'"
    - repl: "listen_addresses = '*'"
  require:
    - cmd: initdb
