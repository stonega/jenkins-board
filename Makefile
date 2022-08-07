INNO_VERSION=6.2.0
TEMP_DIR=/tmp/jenkins-board-tar
USR_SHARE=deb-struct/usr/share
BUNDLE_DIR=build/linux/x64/release/bundle
MIRRORLIST=${PWD}/build/mirrorlist
tar:
		mkdir -p $(TEMP_DIR)\
		&& cp -r $(BUNDLE_DIR)/* $(TEMP_DIR)\
		&& cp linux/jenkins_board.desktop $(TEMP_DIR)\
		&& cp assets/images/logo.png $(TEMP_DIR)\
		&& cp linux/me.stonegate.jenkins_board.appdata.xml $(TEMP_DIR)\
		&& tar -cJf build/jenkins-board-linux-x86_64.tar.xz -C $(TEMP_DIR) .\
		&& rm -rf $(TEMP_DIR)
appimage:
		appimage-builder --recipe linux/AppImageBuilder.yml\
		&& mv Jenkins\ Board-*-x86_64.AppImage build/jenkins-board-linux-x86_64.AppImage
innoinstall:
		powershell curl -o build\installer.exe http://files.jrsoftware.org/is/6/innosetup-${INNO_VERSION}.exe
		powershell build\installer.exe /verysilent /allusers /dir=build\iscc
inno:
		powershell build\iscc\iscc.exe windows\windows-setup-creator.iss
choco:
		powershell cp build\installer\jenkins-board-windows-x86_64-setup.exe windows\choco-struct\tools
		powershell choco pack windows\choco-struct\jenkins_board.nuspec  --outputdirectory build
gensums:
		sh -c gensums.sh
