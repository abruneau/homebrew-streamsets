class DatacollectorEdge < Formula
    desc "DataOps Platform for Modern Data Movement"
    homepage "https://streamsets.com"
    url "https://archives.streamsets.com/datacollector/3.11.0/tarball/SDCe/streamsets-datacollector-edge-3.11.0-darwin-amd64.tgz"
    sha256 "1ebb8867140337ff836c143344aefddcbf842cd7af3224837f65c2e32178cdd2"
  
    bottle :unneeded
  
    def install
      prefix.install Dir["*"]

      inreplace "#{prefix}/etc/edge.conf" do |s|
        s.gsub! /\#?log-dir .*$/, "log-dir = \"#{opt_prefix}/log/\""
      end

    end
  
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
            <string>#{opt_bin}/edge</string>
          </array>
        </dict>
      </plist>
      EOS
    end
    
    test do
      system bin/"edge", "-disableControlHub"
    end
  end
