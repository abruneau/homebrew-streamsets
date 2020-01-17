class DatacollectorCore < Formula
    desc "DataOps Platform for Modern Data Movement"
    homepage "https://streamsets.com"
    url "https://archives.streamsets.com/datacollector/3.13.0/tarball/streamsets-datacollector-core-3.13.0.tgz"
    sha256 "f1ad5897be68996610ae934a01e6061c29981bac3360644292923ee26d94cf33"
  
    bottle :unneeded
  
    depends_on :java => "1.8"
    depends_on "md5sha1sum"
  
    def install
      prefix.install Dir["*"]
  
      inreplace "#{libexec}/sdc-env.sh" do |s|
        s.gsub! "#export SDC_LOG=/var/log/sdc", "export SDC_LOG=#{var}/log/sdc"
        s.gsub! "#export SDC_DATA=/var/lib/sdc", "export SDC_DATA=#{var}/lib/sdc"
        s.gsub! "#export SDC_RESOURCES=/var/lib/sdc-resources", "export SDC_RESOURCES=#{var}/lib/sdc-resources"
        s.gsub! "#export SDC_CONF=/etc/sdc", "export SDC_CONF=#{etc}/sdc"
        s << %Q{
          export SDC_DIST=#{opt_prefix}
          export USER_LIBRARIES_DIR=#{var}/lib/sdc-user-libs
        }
      end

      mkpath "#{var}/lib/sdc-user-libs"
      mkpath "#{var}/lib/sdc-resources"
  
      (etc/"sdc").install Dir["#{prefix}/etc/*"]

      ohai "For ease of use source #{opt_prefix}/libexec/sdc-env.sh in your .bashrc"
    end
  
    plist_options :manual => "streamsets"
  
    def plist; <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/streamsets</string>
            <string>dc</string>
          </array>
          <!-- Set `ulimit -n 32768`. The default macOS limit is 256, that's
               not enough for Streamsets (displays 'too many files open' errors).
               It seems like you have no reason to lower this limit
               (and unlikely will want to raise it). -->
          <key>SoftResourceLimits</key>
          <dict>
            <key>NumberOfFiles</key>
            <integer>32768</integer>
          </dict>
        </dict>
      </plist>
      EOS
    end
  
    test do
      system bin/"streamsets", "stagelibs", "-list"
    end
  end
