module SeeSS

  class Package
    SUBFILES_TO_INCLUDE = [ "reset", "css3", "base", "forms", "buttons", "notices", "tables", "misc", "lists" ]
    PATH_TO_SOURCE_FILES = File.expand_path(File.dirname(__FILE__)+"/../../public/stylesheets/seess")

    def initialize(directory)
      @seess_dir = (directory + '/seess')
      @bak_dir = (directory + '/seess/bak')
      @seess_file = @seess_dir + '/seess.sass'
      @seess_ie_file = @seess_dir + '/ie.sass'

      @sass_dir = (directory + '/sass')
      @custom_styles_file = @sass_dir + '/styles.sass'
      @custom_ie_file = @sass_dir + '/ie.sass'

      backup if File.directory?(@seess_dir)

      Dir.mkdir(@seess_dir) unless File.directory?(@seess_dir)
      Dir.mkdir(@sass_dir) unless File.directory?(@sass_dir)

      write_file @seess_file, seess_content

      write_file @seess_ie_file, File.read("#{PATH_TO_SOURCE_FILES}/ie.sass")

      write_file(@custom_styles_file, "@import ../seess/seess.sass\n") unless File.exist?(@custom_styles_file)

      write_file(@custom_ie_file, "@import ../seess/ie.sass\n") unless File.exist?(@custom_ie_file)

    end


    private
      def backup
        FileUtils.rm_rf(@bak_dir) if File.directory?(@bak_dir)
        Dir.mkdir(@bak_dir)
        FileUtils.mv(Dir.glob("#@seess_dir/*.sass"), @bak_dir)
      end

      def seess_content
        SUBFILES_TO_INCLUDE.inject('') do |result, sass_file|
          result += File.read("#{PATH_TO_SOURCE_FILES}/#{sass_file}.sass") + "\n"
        end
      end

      def write_file(file,content)
        File.open(file, 'w') { |f| f.write(content) }
      end

  end
end

