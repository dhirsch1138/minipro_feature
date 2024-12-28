sudo apt update
sudo apt upgrade -yq
sudo apt install libusb-dev libusb-1.0-0-dev fakeroot debhelper dpkg-dev libb64-dev udev git pkg-config usbutils -yq
mkdir .tempbuild
cd .tempbuild
git clone https://gitlab.com/DavidGriffith/minipro.git
cd minipro
#dpkg-buildpackge performs the make and spits out the deb in parent directory
fakeroot dpkg-buildpackage -b -us -uc
cd ..
#copy deb file to parent
find -H -name "*.deb" -not -name "*dbgsym*" | xargs -I debfile cp debfile ../../minipro.deb
cd ..
# tidy up
rm -fr .tempbuild
#Get the version from the package (which ultimately comes from the deb control in the repo)
dpkg-deb -I ../minipro.deb | grep Version > version.txt
#strip the version down to #.#.#
sed -i 's/\sVersion:\s//g' version.txt
#Update the feature description's version
cat version.txt | xargs -I versionnum sed -i 's/Version:\s*[[:digit:]]*[[:punct:]]*[[:digit:]]*[[:punct:]]*[[:digit:]]/Version: versionnum/g' ../devcontainer-feature.json
#tidy up
rm version.txt
exit