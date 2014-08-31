# TODO@akolomiychuk: Ability to store specific jobs in file, for later reading.
require 'odesk_jobfetch'
require 'terminal-notifier'
require 'odesk_jobnotifier/command_line_tool'
require 'odesk_jobnotifier/version'

trap 'SIGINT' do
  puts 'Exiting...'
  exit
end

# Fetches, filters and notifies about last jobs.
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
      jobs, timestamps = last_jobs(@queries, timestamps)
      jobs.each { |j| notify(j) }
      sleep(@interval)
    end
  end

  private

  def last_jobs(queries, timestamps)
    total_jobs = []
    threads = job_threads(queries)
    threads.each_with_index do |t, index|
      t.join
      jobs = filter_jobs(t[:jobs], timestamps[index])
      total_jobs += jobs
      timestamps[index] = last_job_timestamp(jobs) unless jobs.empty?
    end
    # Filter the same jobs that can be fetched by different queries.
    [total_jobs.uniq { |j| j['id'] }, timestamps]
  end

  def job_threads(queries)
    queries.each_with_object([]) do |query, memo|
      memo << Thread.new { Thread.current[:jobs] = fetch_last_jobs(query) }
    end
  end

  def fetch_last_jobs(query)
    @ojf.fetch(query)
    rescue
      puts 'Error getting last jobs. Skipping...'
      []
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
