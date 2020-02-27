class Transformer < Formula
    desc "DataOps Platform for Modern Data Movement"
    homepage "https://streamsets.com"
    url "https://archives.streamsets.com/transformer/3.12.0/tarball/streamsets-transformer-all-3.12.0.tgz"
    sha256 ""

    bottle :unneeded
  
    depends_on :java => "1.8"

    def install
        prefix.install Dir["*"]

        inreplace "#{libexec}/transformer-env.sh" do |s|
            s.gsub! "#export TRANSFORMER_LOG=/var/log/transformer", "export TRANSFORMER_LOG=#{var}/log/transformer"
            s.gsub! "#export TRANSFORMER_DATA=/var/lib/transformer", "export TRANSFORMER_DATA=#{var}/lib/transformer"
            s.gsub! "#export TRANSFORMER_RESOURCES=/var/lib/transformer-resources", "export TRANSFORMER_RESOURCES=#{var}/lib/transformer-resources"
            s.gsub! "#export TRANSFORMER_CONF=/etc/transformer", "export TRANSFORMER_CONF=#{etc}/transformer"
            s << %Q{
            export TRANSFORMER_DIST=#{opt_prefix}
            }
        end

        mkpath "#{var}/lib/transformer-resources"

        (etc/"transformer").install Dir["#{prefix}/etc/*"]

        ohai "For ease of use source #{opt_prefix}/libexec/transformer-env.sh in your .bashrc"
    end

    plist_options :manual => "streamsets-transformer"
  
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
            <string>transformer</string>
          </array>
        </dict>
      </plist>
      EOS
    end

    test do
        system bin/"streamsets", "stagelibs", "-list"
    end

end
