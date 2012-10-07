module Supido
  class Profile

    # Profile Container 
    #   - profile_name folder
    #   |-- benchmark_profile_date
    #   |  |-- action_log.ab
    #   |  |-- action_post_file.pf
    #
    class << self
      attr_writer :name #, :container

      def name
        @realname ||= @name.underscore.concat("_#{Time.now.to_i.to_s}")
      end

      def reset_name
        @realname = nil
      end
      # TODO: build a better report manager encapsulating the logs inside a 
      #       profile folder to keep all the logs.
      # def container=(container)
      #   @container = container.nil? ? "/tmp/#{self.name}" : container
        
      #   raise @container.inspect
      #   raise folder_path.inspect 
      #   FileUtils.mkdir(folder_path) unless File.exist?(folder_path)
      # end
    end

    def initialize(profile_name, container=nil)
      @actions = []
      @benchmark_tool = Supido.config.benchmark_tool.new
      @commands = []
      Profile.name = profile_name

      # Profile.container= container
    end

    # profile = Supido::Profile.new
    # profile.queue_actions("ProfileName") do |action|
    #   action.url = "target_url"
    #   action.concurrency = 5
    #   action.requests = 100
    #   action.attachment = File.open("/path/to/file", "r")
    #   action.content_type = "multipart/form-data;bondary"
    # end
    def queue_action(name, &block)
      raise "No block given" unless block_given?
      
      action = ProfileAction.new(name)
      yield action

      action.command = @benchmark_tool.build(action)
      push_command action.command
      
      @actions << action

    end

    def run!

      threads = []
      @commands.each do |command|
        threads << Thread.new { `#{command}` }
      end

      threads.each { |aThread|  aThread.join }

      puts "Threads finished."
      puts "Stating analizing"

      # Call the Report Analizer
      @actions.each do |action|
        action.report!
      end

    end

    private
      def push_command(command)
        @commands << command
      end
  end

end