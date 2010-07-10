module SeeSS

  class Package
    SUBFILES_TO_INCLUDE = [ "reset", "css3", "base", "forms", "buttons", "notices", "tables", "misc", "lists" ]
    PATH_TO_SOURCE_FILES = File.expand_path(File.dirname(__FILE__)+"/../../public/stylesheets/seess")

    def initialize(directory)
      @seess_dir = (directory + '/seess')
      @sass_dir = (directory + '/sass')

      if File.directory?(@seess_dir)
        if File.directory?(@seess_dir + '/bak')
          FileUtils.rm_rf(@seess_dir + '/bak')
        end
        Dir.mkdir(@seess_dir + '/bak')
        FileUtils.mv(Dir.glob("#@seess_dir/*.sass"), "#@seess_dir/bak")
      end

      [@seess_dir, @sass_dir].each { |ivar| Dir.mkdir(ivar) unless File.exist?(ivar) }

      write_seess_file
      write_ie_file

      write_styles_custom_file
      write_ie_custom_file
    end


    private

      def write_seess_file
        seess_content = ''
        SUBFILES_TO_INCLUDE.each do |sass_file|
          seess_content += File.read("#{PATH_TO_SOURCE_FILES}/#{sass_file}.sass") + "\n"
        end
        File.open("#{@seess_dir}/seess.sass", 'w') do |f|
          f.write(seess_content)
        end
      end

      def write_ie_file
        File.open("#{@seess_dir}/ie.sass", 'w') do |f|
          f.write(File.read("#{PATH_TO_SOURCE_FILES}/ie.sass"))
        end
      end

      def write_styles_custom_file
        unless File.exist?(@sass_dir + "/styles.sass")
          File.open(@sass_dir + "/styles.sass", 'w') do |f|
            f.write %{@import ../seess/seess.sass\n}
          end
        end
      end

      def write_ie_custom_file
        unless File.exist?(@sass_dir + "/ie.sass")
          File.open(@sass_dir + "/ie.sass", 'w') do |f|
            f.write %{@import ../seess/ie.sass\n}
          end
        end
      end

  end
end

