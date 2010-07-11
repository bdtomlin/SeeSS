require 'optparse'
require 'ostruct'

module SeeSS
  class CLI
    attr_accessor :options

    def initialize(argv, output)
      argv << '--help' if argv.empty?
      @arguments = argv
      @output = output
    end

    def run
      parse
      Package.new(@options.directory)
    end

    def parse
      @options = OpenStruct.new

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: seess path/to/file"
        opts.on("-h", "--help") do
          @output.puts "#{opts.banner}"
          exit
        end
      end

      leftover = opts.parse!(@arguments)

      unless leftover.empty?
        if File.directory?(leftover.last)
          @options.directory = leftover.last
          @options = options
        else
          @output.puts("invalid path: #{leftover.last}\n\n#{opts.banner}")
          exit
        end
      end
    end

  end
end
