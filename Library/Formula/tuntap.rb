require 'formula'

class Tuntap <Formula
  url 'http://downloads.sourceforge.net/project/tuntaposx/tuntap/20090913/tuntap_20090913_src.tar.gz'
  homepage 'http://tuntaposx.sourceforge.net/'
  sha1 '1a9fb5e077c6d21b7715c8cb26f2ebdcbd681202'

  def install
    system "make"
    system "mkdir", "-p", "#{prefix}/Library/Extensions"
    system "cp", "-R", "tap.kext", "#{prefix}/Library/Extensions"
    system "cp", "-R", "tun.kext", "#{prefix}/Library/Extensions"
    (prefix + 'net.sf.tuntaposx.tun.plist').write startup_tun_plist
    (prefix + 'net.sf.tuntaposx.tap.plist').write startup_tap_plist
  end

  def caveats; <<-EOS.undent

    TunTap is a pair of kernel extensions (kexts) that must be installed as
    root.  To complete installation, you will need to do the following:

    1) Change the ownership on the kexts:
        sudo chown -R root:wheel #{prefix}/Library/Extensions/tun.kext
        sudo chown -R root:wheel #{prefix}/Library/Extensions/tap.kext

    2) Install the launchd items to load the kexts on startup:
        sudo cp #{prefix}/net.sf.tuntaposx.tun.plist /Library/LaunchDaemons/
        sudo cp #{prefix}/net.sf.tuntaposx.tap.plist /Library/LaunchDaemons/

    3) Load the kexts:  (This will be done automatically at next reboot)
        sudo kextload #{prefix}/Library/Extensions/tun.kext
        sudo kextload #{prefix}/Library/Extensions/tap.kext

    EOS
  end

  def startup_tun_plist
    return <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd";>
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>net.sf.tuntaposx.tun</string>
          <key>ProgramArguments</key>
          <array>
              <string>/sbin/kextload</string>
              <string>#{prefix}/Library/Extensions/tun.kext</string>
          </array>
          <key>KeepAlive</key>
          <false/>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
          <key>UserName</key>
          <string>root</string>
      </dict>
      </plist>
    EOS
  end

  def startup_tap_plist
    return <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd";>
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>net.sf.tuntaposx.tap</string>
          <key>ProgramArguments</key>
          <array>
              <string>/sbin/kextload</string>
              <string>#{prefix}/Library/Extensions/tap.kext</string>
          </array>
          <key>KeepAlive</key>
          <false/>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
          <key>UserName</key>
          <string>root</string>
      </dict>
      </plist>
    EOS
  end

end
