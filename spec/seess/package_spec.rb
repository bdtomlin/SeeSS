require 'spec_helper'

include SeeSS

TMP_DIR              = File.dirname(__FILE__) + "/../test_tmp"

SEESS_DIR            = TMP_DIR + '/seess'
SEESS_FILE           = SEESS_DIR + '/seess.sass'
SEESS_IE_FILE        = SEESS_DIR + '/ie.sass'

SASS_DIR             = TMP_DIR + '/sass'
CUSTOM_STYLES_FILE   = SASS_DIR + '/styles.sass'
CUSTOM_IE_FILE       = SASS_DIR + '/ie.sass'

SRC_SEESS_DIR        = File.dirname(__FILE__) + "/../../public/stylesheets/seess"

describe Package do
  before(:each) do
    FileUtils.mkdir(TMP_DIR)
    Package.new(TMP_DIR)
  end
  after(:each) do
    FileUtils.rm_rf(TMP_DIR)
  end

  describe "creating directories" do

    it "should accept an empty directory and create a seess and sass directory in it" do
      File.directory?(SEESS_DIR).should == true
      File.directory?(SASS_DIR).should == true
    end

    it "should have an exception if given an invalid directory" do
      lambda {Package.new(TMP_DIR + 'nonexistant')}.should raise_error(Errno::ENOENT)
    end

    it "should use current directories if they already exist" do
      seess_dir = File.new(SEESS_DIR)
      sass_dir = File.new(SASS_DIR)
      Package.new(TMP_DIR)
      File.identical?(File.new(SEESS_DIR), seess_dir).should == true
      File.identical?(File.new(SASS_DIR), sass_dir).should == true
    end

  end

  describe "generating the seess sass files" do

    it "should generate a file that matches the concatenated source files" do
      seess_content = ''
      [ "settings", "reset", "css3", "base", "forms", "buttons", "notices", "tables", "lists" ].each do |file|
        seess_content += File.read("#{SRC_SEESS_DIR}/#{file}.sass") + "\n"
      end
      File.read(SEESS_FILE).should == seess_content
    end

    it "should generate an ie seess file that matches the source file" do
      ie_content = File.read("#{SRC_SEESS_DIR}/ie.sass")
      File.read(SEESS_IE_FILE).should == ie_content
    end
  end

  describe "generating the customizeable sass files" do

    describe "if the files don't exist" do

      it "should create styles.sass with correct content" do
        File.read(CUSTOM_STYLES_FILE).should == "@import ../seess/seess.sass\n"
      end

      it "should create ie.sass with correct content" do
        File.read(CUSTOM_IE_FILE).should == "@import ../seess/ie.sass\n"
      end

    end

    describe "if the files already exist" do

      it "should not overwrite the the sass/styles.sass file" do
        File.open(CUSTOM_STYLES_FILE,'w') { |f| f.write("change content")}
        styles1 = File.read(CUSTOM_STYLES_FILE)

        Package.new(TMP_DIR)

        styles2 = File.read(CUSTOM_STYLES_FILE)
        styles1.should == styles2
      end
      it "should not overwrite the the sass/ie.sass file" do
        File.open(CUSTOM_IE_FILE,'w') { |f| f.write("change content")}
        ie1 = File.read(CUSTOM_IE_FILE)

        Package.new(TMP_DIR)

        ie2 = File.read(CUSTOM_IE_FILE)
        ie1.should == ie2
      end
    end

  end

  describe "backing up seess files if they already exist" do

    it "should create a backup directory if the seess files already exist" do
      Package.new(TMP_DIR)
      File.directory?(TMP_DIR + "/seess/bak").should == true
    end

    it "should overwrite bak dir with a new bak if it already exists" do
      Package.new(TMP_DIR)
      bak1 = File.new(TMP_DIR + "/seess/bak",'r')
      Package.new(TMP_DIR)
      bak2 = File.new(TMP_DIR + "/seess/bak",'r')
      File.identical?(bak1,bak2).should == false
    end

    it "should move every sass file in the seess directory to the bak directory" do
      Package.new(TMP_DIR)
      File.exist?(TMP_DIR + "/seess/bak/seess.sass").should == true
      File.exist?(TMP_DIR + "/seess/bak/ie.sass").should == true
    end

  end

end

