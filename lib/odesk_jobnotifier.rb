# TODO@akolomiychuk: Add yml configuration support.
# TODO@akolomiychuk: Threads? JRuby?
# TODO@akolomiychuk: Ability to store specific jobs in file, for later reading.
# TODO@akolomiychuk: Handling bad requests.
require 'odesk_jobfetch'
require 'odesk_jobnotifier/command_line_tool'
require 'odesk_jobnotifier/version'

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
        jobs = @ojf.fetch(query)
        jobs.select! do |j|
          DateTime.parse(j['publish_time']) > timestamps[index]
        end

        unless jobs.empty?
          timestamps[index] = last_job_timestamp(jobs)
          jobs.each { |j| notify(j) }
        end
      end

      sleep(@interval)
    end
  end

  private

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
      title: "#{job['title']} | #{job['client']['total_spent']}",
      open: job['url']
    }

    TerminalNotifier.notify(job['snippet'], params)
  end
end
