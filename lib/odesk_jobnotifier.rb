# TODO@akolomiychuk: Threads? JRuby?
# TODO@akolomiychuk: Ability to store specific jobs in file, for later reading.
require 'odesk_jobfetch'
require 'terminal-notifier'
require 'odesk_jobnotifier/command_line_tool'
require 'odesk_jobnotifier/version'

trap 'SIGINT' do
  puts 'Exiting...'
  exit
end

class OdeskJobnotifier
  def initialize(params)
    @account = params[:account]
    @queries = params[:queries]
    @interval = params[:interval]
    @ojf = OdeskJobfetch.new
  end

  def run
    puts 'Authenticating...'
    @ojf.authorize(@account[:login], @account[:password])
    timestamps = last_timestamps
    puts 'Start looking for new jobs...'

    loop do
      @queries.each_with_index do |query, index|
        jobs = filter_jobs(fetch_last_jobs(query), timestamps[index])

        unless jobs.empty?
          timestamps[index] = last_job_timestamp(jobs)
          jobs.each { |j| notify(j) }
        end
      end

      sleep(@interval)
    end
  end

  private

  def fetch_last_jobs(query)
    begin
      @ojf.fetch(query)
    rescue
      puts 'Error getting last jobs. Skipping...'
      []
    end
  end

  def filter_jobs(jobs, timestamp)
    jobs.select do |j|
      DateTime.parse(j['publish_time']) > timestamp
    end
  end

  def last_timestamps
    @queries.map do |q|
      jobs = @ojf.fetch(q)
      last_job_timestamp(jobs)
    end
  end

  def last_job_timestamp(jobs)
    jobs.map { |j| DateTime.parse(j['publish_time']) }.max
  end

  def notify(job)
    params = {
      title: "$#{job['client']['total_spent']} | #{job['title']}",
      open: job['url']
    }

    TerminalNotifier.notify(job['snippet'], params)
  end
end
