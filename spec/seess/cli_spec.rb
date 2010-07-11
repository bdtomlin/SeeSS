require 'spec_helper'

include SeeSS

describe CLI do
  let(:output) { double('output').as_null_object }

  describe "options without a valid path" do
    it "should only accept 2 arguments or an array" do
      lambda { CLI.new([], output) }.should_not raise_error
      lambda { CLI.new() }.should raise_error
    end

    it "should show the help message if passed -h --help or nothing" do
      output.should_receive(:puts).exactly(3).times.with('Usage: seess path/to/file')
      lambda { CLI.new(['-h'], output).parse }.should raise_error SystemExit
      lambda { CLI.new(['--help'], output).parse }.should raise_error SystemExit
      lambda { CLI.new([], output).parse }.should raise_error SystemExit
    end

    it "should show an error if given an invalid directory" do
      output.should_receive(:puts).with("invalid path: /invalid/path/here\n\nUsage: seess path/to/file")
      lambda { CLI.new(['/invalid/path/here'], output).parse }.should raise_error SystemExit

    end
  end

  describe "with a valid directory" do
    before(:each) do
      @dir = File.dirname(__FILE__)+'/tmp'
      Dir.mkdir(@dir)
    end
    after(:each) do
      Dir.rmdir(@dir)
    end
    it "should have an options hash if given a valid directory" do
      cli = CLI.new([@dir], output)
      cli.parse
      cli.options.directory.should == @dir
    end
  end

end
