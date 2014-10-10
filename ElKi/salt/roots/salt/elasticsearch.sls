#elasticsearch_install:
#  cmd.run:
#    - name: rpm -Uvh /srv/salt/files/elasticsearch-1.4.0.Beta1.noarch.rpm

elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: salt://files/elasticsearch-1.4.0.Beta1.noarch.rpm
  service.running:
    - enable: True
