#!/bin/sh
set -e
if [ $(whoami) != "root" ]; then
  echo "Need to be root to run this script"
  exit 1
fi

PDI_URL=http://sourceforge.mirrorservice.org/p/pe/pentaho/Data%20Integration/5.4/pdi-ce-5.4.0.1-130.zip
KETTLE_USER=pentaho
JAVA_RPM=http://deploy.transcendinsights.com/cdsng/jdk-8u66-linux-x64.rpm
JAVA_DIR=jdk1.8.0_66

echo "    PDI_URL = $PDI_URL"
echo "KETTLE_USER = $KETTLE_USER"
echo "   JAVA_RPM = $JAVA_RPM"
echo "   JAVA_DIR = $JAVA_DIR"

if [ $(ls -1 /home/ | grep -c $KETTLE_USER) = 0 ]; then
  useradd $KETTLE_USER
fi

test -d ~/.cache || mkdir ~/.cache
cd ~/.cache

wget -N -nv $JAVA_RPM
test -d /usr/java/$JAVA_DIR || sudo rpm -i --force $(basename $JAVA_RPM)

cd ~
yum install -q -y unzip

su - $KETTLE_USER << EOF
  test -d ~/.cache || mkdir ~/.cache
  cd ~/.cache
  wget -N -nv $PDI_URL

  cd ~

  test -d data-integration && rm -rf data-integration
  unzip -q ~/.cache/$(basename $PDI_URL)

EOF
