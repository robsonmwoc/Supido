module Supido
  # TODO: Create a specific class on ApacheBenchmark module to handle report and
  #       some specific accessors.
  class ProfileAction
    attr_accessor :url, :concurrency, :requests, :attachment, :save_log, :auth
    attr_accessor :command, :post_data, :verbosity, :time

    def initialize(name)
      @name = name
      @save_log ||= true
      @document = nil
    end

    def log_file
      return nil unless save_log?

      FileUtils.mkdir(folder_path) unless File.exist?(folder_path)

      File.join(folder_path, "#{@name.underscore}.ab")
    end

    def post_file
      return nil unless self.post_data.present? || self.attachment.present?

      File.join(folder_path, "#{@name.underscore}.pf")
    end

    # {
    #   :requests=>5,
    #   :concurrency=>1, 
    #   :time=>0.031 seconds
    #   :document_length=>"11561 bytes", 
    #   :requests_per_second=>"180.24", 
    #   :percents=>{
    #     :p50=>"5", 
    #     :p66=>"6", 
    #     :p75=>"6", 
    #     :p80=>"7", 
    #     :p90=>"7", 
    #     :p95=>"7", 
    #     :p98=>"7", 
    #     :p99=>"7", 
    #     :p100=>"7"
    #   }
    # }

    def report!
      @document = IO.readlines log_file unless log_file.nil?

      raise "Failed to read the document" if @document.empty?

      # Needs to treat connection fails and incomplete tests.
      is_completed = @document.grep(/(\.\.done)/).any?

      if is_completed
        
        document_length     = get_data(/(Document\sLength\:)/, /\d+\s\w+/).first
        requests_per_second = get_data(/Requests\sper\ssecond\:/, /([\d+\.]+)\s\[/).last
        time_taken          = get_data(/Time\staken\sfor\stests\:/, /([\.\d]+)\sseconds/).last
        time_per_request    = get_data(/(Time\sper\srequest\:)/, /([\.\d]+)\s\[/).last
        completed_requests  = get_data(/(Complete\srequests\:)/, /(\d+)/).last
        failed_requests     = get_data(/(Failed\srequests\:)/, /(\d+)/).last
        
        if @document.grep(/(Percentage\sof\sthe\srequests)/).any?
          percents = { 
            p50:  get_data(/50\%/, /(\d+)\n/).last,
            p66:  get_data(/66\%/, /(\d+)\n/).last,
            p75:  get_data(/75\%/, /(\d+)\n/).last,
            p80:  get_data(/80\%/, /(\d+)\n/).last,
            p90:  get_data(/90\%/, /(\d+)\n/).last,
            p95:  get_data(/95\%/, /(\d+)\n/).last,
            p98:  get_data(/98\%/, /(\d+)\n/).last,
            p99:  get_data(/99\%/, /(\d+)\n/).last,
            p100: get_data(/100\%/, /(\d+)\s\(/).last
          }
        end


        # results = {
        #   requests: requests,
        #   concurrency: concurrency,
        #   document_length: document_length,
        #   requests_per_second: requests_per_second,
        #   time: time_taken,
        #   time_per_request: time_per_request,
        #   percents: percents
        # }

        labels = %W(
          COMPLETED_REQUESTS 
          FAILED_REQUESTS
          CONCURRENCY 
          DOCUMENT_LENGTH
          REQUESTS_PER_SECOND
          TIME 
          TIME_PER_REQUEST 
          P50
          P66
          P75
          P80
          P90
          P95
          P98
          P99
          P100
        )
        File.open( "#{folder_path}/#{@name.underscore}.csv", "w" ) do |f|
          f.write( labels.join(",") )
          f.write( "\n" )

          values = [
            completed_requests,
            failed_requests,
            concurrency,
            document_length,
            requests_per_second,
            time_taken,
            time_per_request,
            percents[:p50],
            percents[:p66],
            percents[:p75],
            percents[:p80],
            percents[:p90],
            percents[:p95],
            percents[:p98],
            percents[:p99],
            percents[:p100]
          ]
          f.write( values.join(",") )
        end
      else
        # Benchmarking localhost (be patient)...Total of 996 requests completed
        File.open( "#{folder_path}/#{@name.underscore}.csv", "w" ) do |f|
          f.write( "REQUESTS COMPLETED\n" )
          
          requests_completed = get_data(/(Total\sof\s\d+\srequests\scompleted)/, /(\d+)/).last
          f.write( "#{requests_completed}" )
        end
      end
    end

    private
      def save_log?
        @save_log
      end

      def get_data(grep_regex, data_regex)
        begin
          @document.grep(grep_regex).first.match(data_regex).to_a
        rescue NoMethodError => err
          puts "#{Profile.name}::#{@name}"
          puts "#{err.class}: #{err.message}"
          puts $! # Mensagem da exceção
          puts $@ # Backtrace do erro
        end
      end

      def folder_path
        @folder_path ||= File.join(Supido.config.log_path, "benchmark_#{Supido::Profile.name}")
      end
  end

end
