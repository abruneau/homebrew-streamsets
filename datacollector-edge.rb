class DatacollectorEdge < Formula
    desc "DataOps Platform for Modern Data Movement"
    homepage "https://streamsets.com"
    url "https://archives.streamsets.com/datacollector/3.10.1/tarball/SDCe/streamsets-datacollector-edge-3.10.1-darwin-amd64.tgz"
    sha256 "addfcdb7453a1c4d3167a2fa7514a70a20e92ea6ecbe90d059311ee22290196c"
  
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
