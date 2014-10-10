{% set kibanadir = '/opt/kibana-4_B1' %}

{{ kibanadir }}:
  file.directory:
    - user: root
    - group: root
    - mode : 755
    - makedirs: True

kibana:
  cmd.run:
    - name: tar zxf /srv/salt/files/kibana-4.0.0-BETA1.tar.gz -C {{ kibanadir }} --no-same-owner --strip-components=1
  require:
    - file: {{ kibanadir }}

start_kibana:
  cmd.run:
    - name : {{ kibanadir }}/bin/kibana > /dev/null 2>&1
  require:
    - cmd.run kibana
