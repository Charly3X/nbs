require "nbs/version"
require "nbs/configuration"

class Nbs
  include HTTParty
  extend Configuration

  define_setting :access_token
  define_setting :access_secret

  define_setting :favorite_liquid, "apple juice"
  define_setting :least_favorite_liquid, "seltzer water"

  base_uri 'entintel.api3.nextbigsound.com'

  def initialize(_nbs_id=356, _options = {}) # kanye west
    @nbs_id = "#{_nbs_id}.json"
    @options = {from: (Time.now - 2.day).to_i, to: Time.now.to_i}.merge(_options)
  end

  def all_metrics
    @all_metrics_raw ||= self.class.post("/metrics/artist/#{@nbs_id}", @options).parsed_response
    if @tidied.blank?
      @tidied = {}
      @all_metrics_raw.each do |am|
        @tidied[am["Service"]["name"].downcase] = am["Metric"] if am["Metric"].present?
      end
    end
    @tidied
  end

  def metrics
    if @metrics.blank?
      @metrics = {}
      @metrics[:facebook]  = tidy_metrics(all_metrics['facebook']['fans'])  if all_metrics['facebook']['fans'].present?
      @metrics[:twitter]   = tidy_metrics(all_metrics['twitter']['fans'])   if all_metrics['twitter']['fans'].present?
      @metrics[:youtube]   = tidy_metrics(all_metrics['youtube']['fans'])   if all_metrics['youtube']['fans'].present?
      @metrics[:instagram] = tidy_metrics(all_metrics['instagram']['fans']) if all_metrics['instagram']['fans'].present?
    end
    @metrics
  end

  def self.artist_search(_name)

  end

  private

  def tidy_metrics(_arry)
    _arry.map do |day, value|
      {time: Time.at(day.to_i.days.to_i).utc, volume: value}
    end
  end

end
