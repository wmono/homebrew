require 'formula'

class Mkvalidator < Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.3.5.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkvalidator.html'
  md5 'e2fca0ac1d35f96691d3539fd7dbee47'

  def install
    ENV.j1 # Otherwise there are races

    # For 64-bit kernels, just use the Snow Leopard SDK.
    inreplace "corec/tools/coremake/gcc_osx_x64.build" do |s|
      s.gsub! /10\.4u?/, "10.6"
    end

    system "./configure"
    system "make -C mkvalidator"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkvalidator"
  end
end
