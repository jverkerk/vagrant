#oraclejava_install:
#  cmd.run:
#    - name: rpm -Uvh /srv/salt/files/jdk-7u67-linux-x64.rpm

jdk-1.7.0.67:
  pkg.installed:
    - sources:
      - jdk: salt://files/jdk-1.7.0.67.rpm

/etc/profile.d/motd.sh:
  file.managed:
   - source: salt://files/motd.sh
   - user: root
   - group: root
   - mode: 644

/etc/profile.d/cmdprompt.sh:
  file.managed:
    - source: salt://files/cmdprompt.sh
    - user: root
    - group: root
    - mode: 644
