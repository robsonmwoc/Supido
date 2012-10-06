module Supido
  class ApacheBenchmark < AbstractBenchmarkBase
    attr_reader :command

    def initialize
      @command = "ab -q"
    end

    # ab -A username:password   Basic www authentication
    # ab -q                     Suppress percentage flag messages.
    # ab -c number              Concurrency level
    # ab -n number              Number of requests
    # ab -C cookie-name=value   Add a cookie PHPSESSID=rk53j7gsrmaiuc3gvo86ipltr1
    # ab -p POST-file           File containing data to POST. Remember to also set -T.
    # ab -T content-type        Content type header -T "multipart/form-data; boundary=1234567890"
    # ab 
    def build(action)
      command_params = []

      # Workaround to generate log folder
      action.log_file

      post_file = generate_post_file(action) if action.post_data.present? || action.attachment.present?
      command_params << post_file unless post_file.nil?

      command_params << "-A #{action.auth[:user]}:#{action.auth[:password]}" unless action.auth.nil?
      command_params << "-c #{action.concurrency}"
      command_params << "-v #{action.verbosity}" unless action.verbosity.nil?
      command_params << "-n #{action.requests}" unless action.requests.nil?
      command_params << "-t #{action.time}" unless action.time.nil?
      command_params << "#{action.url}"
      command_params << "> #{action.log_file}" unless action.log_file.nil?
      puts "#{@command} #{command_params.join(" ")}"
      "#{@command} #{command_params.join(" ")}"
    end

    def generate_post_file(action)
      command_params = ""
      boundary = "SUPIDO#{Time.now.to_i.to_s}"
      
      post_file = action.post_file || "/tmp/post_file"

      File.open(post_file, "w") do |f|
        if action.attachment.present?
          contents = []
          
          # Start of HTTP header file
          contents << "--#{boundary}\r\n"

          # Streaming the form data
          action.post_data.each { |key, value| 
            contents << "Content-Disposition: form-data; name=\"#{key}\";\r\n"
            contents << "Content-Type: text/plain\r\n"
            contents << "\r\n"
            contents << "#{value}"
            contents << "\r\n--#{boundary}\r\n"
          } unless action.post_data.nil?

          # raise contents.inspect
          # Streaming the file content  
          contents << "\r\n--#{boundary}\r\n" if action.post_data.nil?
          contents << "Content-Disposition: form-data; name=\"filename\"; filename=\"#{action.attachment[:filename]}\"\r\n"
          contents << "Content-Type: #{action.attachment[:content_type]}\r\n"
          contents << "\r\n"
          contents << encode_file(action.attachment[:filepath])

          # End of HTTP Header file
          contents << "\r\n--#{boundary}--\r\n"

          f.write( contents.join )

          command_params = "-p #{post_file} -T 'multipart/form-data; boundary=#{boundary}'"

        elsif action.post_data.present?
          contents = action.post_data.map { |key, value| "#{key}=#{URI.escape(value)}" }

          f.write( contents.join( "&" ) )
          command_params = "-p #{post_file} -T 'application/x-www-form-urlencoded'"
        end
      end

      command_params

    end

    def encode_file(file_path)
      # return Base64.encode64(File.read(file_path)) if File.exists?(file_path)
      return File.read(file_path) if File.exists?(file_path)
    end
  end
end