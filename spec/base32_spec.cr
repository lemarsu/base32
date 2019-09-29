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
      Base32.encode("Hello world!", Base32::Crocford).should eq "91JPRV3F41VPYWKCCGGG"
    end

    it "with RFC_4648" do
      Base32.encode("Hello world!").should eq "JBSWY3DPEB3W64TMMQQQ===="
      Base32.encode("Hello world!", Base32::RFC_4648).should eq "JBSWY3DPEB3W64TMMQQQ===="
    end

    it "with Base32Hex" do
      Base32.encode("Hello world!", Base32::Hex).should eq "91IMOR3F41RMUSJCCGGG===="
    end

    it "with custom config" do
      custom_config = Base32::Config.new(
        "CAHDBNT2FUW58KQOJM3YXSZLE7PV6GR4",
        padding: '!',
        charmap: {
          'I' => 'L',
          '1' => 'L',
          '0' => 'O',
        }
      )

      Base32.encode("Hello world!", custom_config).should eq "UA3ZEVDOBAVZR6Y88JJJ!!!!"
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
      Base32.decode("91JPRV3F41VPYWKCCGGG", Base32::Crocford).should eq "Hello world!".to_slice
      Base32.decode("91jprv3f41vpywkccggg", Base32::Crocford).should eq "Hello world!".to_slice
      Base32.decode("9ljprv3f41vpywkccggg", Base32::Crocford).should eq "Hello world!".to_slice
      Base32.decode("8xqpys32f5jjoxvfe9p6888", Base32::Crocford).should eq "Goodbye world!".to_slice
    end

    it "with RFC_4648" do
      Base32.decode("JBSWY3DPEB3W64TMMQQQ====").should eq "Hello world!".to_slice
      Base32.decode("JBSWY3DPEB3W64TMMQQQ====", Base32::RFC_4648).should eq "Hello world!".to_slice
      Base32.decode("jbswy3dpeb3w64tmmqqq====", Base32::RFC_4648).should eq "Hello world!".to_slice
    end

    it "with Base32Hex" do
      Base32.decode("91IMOR3F41RMUSJCCGGG====", Base32::Hex).should eq "Hello world!".to_slice
      Base32.decode("91imor3f41rmusjccggg====", Base32::Hex).should eq "Hello world!".to_slice
    end

    it "with custom alphabet" do
      custom_config = Base32::Config.new(
        "CAHDBNT2FUW58KQOJM3YXSZLE7PV6GR4",
        padding: '!',
        charmap: {
          'I' => 'L',
          '1' => 'L',
          '0' => 'O',
        }
      )

      Base32.decode("UA3ZEVDOBAVZR6Y88JJJ!!!!", custom_config).should eq "Hello world!".to_slice
      Base32.decode("ua3zevdobavzr6y88jjj!!!!", custom_config).should eq "Hello world!".to_slice
      Base32.decode("ua3zevd0bavzr6y88jjj!!!!", custom_config).should eq "Hello world!".to_slice
    end

    it "should raise on wrong alphabet" do
      expect_raises Base32::Error, "Unknown char" do
        Base32.decode("189", Base32::RFC_4648)
      end
      expect_raises Base32::Error, "Unknown char" do
        Base32.decode("u", Base32::Crocford)
      end
      expect_raises Base32::Error, "Unknown char" do
        Base32.decode("wxyz", Base32::Hex)
      end
    end
  end
end
