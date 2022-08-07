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
gensums:
		sh -c gensums.sh