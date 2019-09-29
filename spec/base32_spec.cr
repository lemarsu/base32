require "./spec_helper"

describe Base32 do
  describe "#encode" do
    it "a Slice of size 1" do
      # false.should eq(true)
      Base32.encode("\x00").should eq "00"
      Base32.encode("\x01").should eq "04"
      Base32.encode("\x1F").should eq "3W"
      Base32.encode("\x20").should eq "40"
      Base32.encode("\x32").should eq "68"
      Base32.encode("\x60").should eq "C0"
      Base32.encode("\xFF").should eq "ZW"
    end

    it "a Slice of size 2" do
      Base32.encode("\x00\x00").should eq "0000"
      Base32.encode("\x00\x01").should eq "000G"
      Base32.encode("\x01\x00").should eq "0400"
      Base32.encode("\x01\x00").should eq "0400"
      Base32.encode("\xDE\xAD").should eq "VTPG"
      Base32.encode("\xFF\xFF").should eq "ZZZG"
    end
  end

  describe "#decode" do
    it "a string" do
      Base32.decode("00").should eq "\x00".to_slice
      Base32.decode("04").should eq "\x01".to_slice
      Base32.decode("ZW").should eq "\xFF".to_slice
      Base32.decode("0400").should eq "\x01\x00".to_slice
      Base32.decode("0400").should eq "\x01\x00".to_slice
      Base32.decode("VTPG").should eq "\xDE\xAD".to_slice
      Base32.decode("ZZZG").should eq "\xFF\xFF".to_slice
    end
  end
end
