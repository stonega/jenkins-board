INNO_VERSION=6.2.0
TEMP_DIR=/tmp/jenkins-board-tar
USR_SHARE=deb-struct/usr/share
BUNDLE_DIR=build/linux/x64/release/bundle
MIRRORLIST=${PWD}/build/mirrorlist
deb: 
		mkdir -p ${USR_SHARE}/jenkins_board\
		&& mkdir -p $(USR_SHARE)/applications $(USR_SHARE)/icons/jenkins_board $(USR_SHARE)/jenkins_board $(USR_SHARE)/appdata\
		&& cp -r $(BUNDLE_DIR)/* $(USR_SHARE)/jenkins_board\
		&& cp linux/jenkins_board.desktop $(USR_SHARE)/applications/\
		&& cp linux/me.stonegate.jenkins_board.appdata.xml $(USR_SHARE)/appdata/jenkins_board.appdata.xml\
		&& cp assets/images/logo.png $(USR_SHARE)/icons/jenkins_board\
		&& cp -r linux/DEBIAN deb-struct/\
		&& sed -i 's|me.stonegate.jenkins_board|jenkins_board|' $(USR_SHARE)/appdata/jenkins_board.appdata.xml\
		&& dpkg-deb -b deb-struct build/jenkins-board-linux-x86_64.deb

tar:
		mkdir -p $(TEMP_DIR)\
		&& cp -r $(BUNDLE_DIR)/* $(TEMP_DIR)\
		&& cp linux/jenkins_board.desktop $(TEMP_DIR)\
		&& cp assets/images/logo.png $(TEMP_DIR)\
		&& cp linux/me.stonegate.jenkins_board.appdata.xml $(TEMP_DIR)\
		&& tar -cJf build/jenkins-board-linux-x86_64.tar.xz -C $(TEMP_DIR) .\
		&& rm -rf $(TEMP_DIR)

appimage:
				 appimage-builder --recipe AppImageBuilder.yml\
				 && mv 'Jenkins Board-*-x86_64.AppImage' build/jenkins-board-linux-x86_64.AppImage

aursrcinfo:
					 docker run -e EXPORT_SRC=1 -v ${PWD}/aur-struct:/pkg -v ${MIRRORLIST}:/etc/pacman.d/mirrorlist:ro whynothugo/makepkg

# publishaur: 
# 					 echo '[Warning!]: you need SSH paired with AUR'\
# 					 && rm -rf build/spotube\
# 					 && git clone ssh://aur@aur.archlinux.org/spotube-bin.git build/spotube\
# 					 && cp aur-struct/PKGBUILD aur-struct/.SRCINFO build/spotube\
# 					 && cd build/spotube\
# 					 && git add .\
# 					 && git commit -m "${MSG}"\
# 					 && git push

innoinstall:
						powershell curl -o build\installer.exe http://files.jrsoftware.org/is/6/innosetup-${INNO_VERSION}.exe
		 				powershell build\installer.exe /verysilent /allusers /dir=build\iscc

inno:
		 powershell build\iscc\iscc.exe scripts\windows-setup-creator.iss

choco:
			powershell cp build\installer\jenkins-board-windows-x86_64-setup.exe choco-struct\tools
			powershell choco pack .\choco-struct\jenkins-board.nuspec  --outputdirectory build

gensums:
				sh -c scripts/gensums.sh