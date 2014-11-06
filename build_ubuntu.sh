VERSION=2.3.5

gpg --import private_key.asc

mkdir -p /vagrant/build
cd /vagrant/build

wget http://swupdate.openvpn.org/community/releases/openvpn-$VERSION.tar.gz

tar xfz openvpn-$VERSION.tar.gz
rm -f openvpn-$VERSION.tar.gz
tar cfz openvpn_$VERSION.orig.tar.gz openvpn-$VERSION

cp -r ../debian ./openvpn-$VERSION
cd openvpn-$VERSION

debuild -S
sed -i -e 's/0ubuntu1/0ubuntu1~precise/g' debian/changelog
sed -i -e 's/trusty;/precise;/g' debian/changelog
debuild -S
sed -i -e 's/0ubuntu1~precise/0ubuntu1~utopic/g' debian/changelog
sed -i -e 's/precise;/utopic;/g' debian/changelog
debuild -S

cd ..

echo '\n\nRUN COMMANDS BELOW TO UPLOAD:'
echo 'sudo dput ppa:pritunl/ppa ./build/openvpn_'$VERSION'-0ubuntu1_source.changes'
echo 'sudo dput ppa:pritunl/ppa ./build/openvpn_'$VERSION'-0ubuntu1~precise_source.changes'
echo 'sudo dput ppa:pritunl/ppa ./build/openvpn_'$VERSION'-0ubuntu1~utopic_source.changes'
echo 'sudo dput ppa:pritunl/pritunl-testing ./build/openvpn_'$VERSION'-0ubuntu1_source.changes'
echo 'sudo dput ppa:pritunl/pritunl-testing ./build/openvpn_'$VERSION'-0ubuntu1~precise_source.changes'
echo 'sudo dput ppa:pritunl/pritunl-testing ./build/openvpn_'$VERSION'-0ubuntu1~utopic_source.changes'
