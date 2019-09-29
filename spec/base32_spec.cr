require "./spec_helper"

describe Base32 do
  describe "#encode" do
    it "with Crocford" do
      Base32.encode("\x00", Base32::Crocford).should eq "00"
      Base32.encode("\x01", Base32::Crocford).should eq "04"
      Base32.encode("\x1F", Base32::Crocford).should eq "3W"
      Base32.encode("\x20", Base32::Crocford).should eq "40"
      Base32.encode("\x32", Base32::Crocford).should eq "68"
      Base32.encode("\x60", Base32::Crocford).should eq "C0"
      Base32.encode("\xFF", Base32::Crocford).should eq "ZW"
      Base32.encode("\x00\x00", Base32::Crocford).should eq "0000"
      Base32.encode("\x00\x01", Base32::Crocford).should eq "000G"
      Base32.encode("\x01\x00", Base32::Crocford).should eq "0400"
      Base32.encode("\x01\x00", Base32::Crocford).should eq "0400"
      Base32.encode("\xDE\xAD", Base32::Crocford).should eq "VTPG"
      Base32.encode("\xFF\xFF", Base32::Crocford).should eq "ZZZG"
      Base32.encode("\xFF\xFF", Base32::Crocford).should eq "ZZZG"
    end

    it "with RFC_4648" do
      Base32.encode("Hello world!").should eq "JBSWY3DPEB3W64TMMQQQ===="
      Base32.encode("Hello world!", Base32::RFC_4648).should eq "JBSWY3DPEB3W64TMMQQQ===="
    end

    it "with Base32Hex" do
      Base32.encode("Hello world!", Base32::Hex).should eq "91IMOR3F41RMUSJCCGGG===="
    end
  end

  describe "#decode" do
    it "with Crocford" do
      Base32.decode("00", Base32::Crocford).should eq "\x00".to_slice
      Base32.decode("04", Base32::Crocford).should eq "\x01".to_slice
      Base32.decode("ZW", Base32::Crocford).should eq "\xFF".to_slice
      Base32.decode("0400", Base32::Crocford).should eq "\x01\x00".to_slice
      Base32.decode("0400", Base32::Crocford).should eq "\x01\x00".to_slice
      Base32.decode("VTPG", Base32::Crocford).should eq "\xDE\xAD".to_slice
      Base32.decode("ZZZG", Base32::Crocford).should eq "\xFF\xFF".to_slice
    end

    it "with RFC_4648" do
      Base32.decode("JBSWY3DPEB3W64TMMQQQ====").should eq "Hello world!".to_slice
      Base32.decode("JBSWY3DPEB3W64TMMQQQ====", Base32::RFC_4648).should eq "Hello world!".to_slice
    end

    it "with Base32Hex" do
      Base32.decode("91IMOR3F41RMUSJCCGGG====", Base32::Hex).should eq "Hello world!".to_slice
    end
  end
end
