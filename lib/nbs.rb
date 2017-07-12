require "nbs/version"
require "nbs/configuration"
require "httparty"
require 'active_support/all'

class Nbs
  include HTTParty
  extend Configuration
  attr_accessor :all_metrics_raw

  SERVICES = %w(facebook youtube twitter instagram)
  # define_setting :access_key
  # define_setting :least_favorite_liquid, "seltzer water"

  def initialize(_nbs_id=1076707, _options = {}) # run the jewels
    @nbs_id = "#{_nbs_id}.json"
    @options = {start: (Time.now - 7.day).to_i, end: Time.now.to_i, metric: 'fans'}.merge(_options)
  end

  def metrics
    @all_metrics_raw ||= self.class.post("/metrics/artist/#{@nbs_id}", @options).parsed_response
    if @metrics.blank?
      @metrics = {}
      @all_metrics_raw.each do |am|
        service  = am["Service"]["name"].downcase
        _metrics = am["Metric"]['fans']
        if _metrics.present? && SERVICES.any? { |s| s == service }
          @metrics[service.to_sym] ||= []
          @metrics[service.to_sym] << { url: am['Profile']['url'], data: self.class.tidy_metrics(_metrics)}
        end
      end
    end
    @metrics
  end

  def artist_profiles
    if @artist_profiles.blank?
      @artist_profiles = []
      response = self.class.get("/profiles/artist/#{@nbs_id}", @options).parsed_response
      response.each do |id, data|
        next unless SERVICES.any? { |s| s == data['name'].downcase }
        @artist_profiles << {nbs_profle_id: id, url: data['url']}
      end
    end
    @artist_profiles
  end

  def self.artist_search(_names)
    artist_search = []
    [_names].flatten.each do |name|
      result = get("/artists/search.json", { query: {q: "#{name}"}})
      if result.code == 200
        result.parsed_response.each do |id, values|
          artist_search << {nbs_id: id, name: values["name"], music_brainz_id: values["music_brainz_id"]}
        end
      end
    end
    artist_search.uniq
  end

  def self.metric(_nbs_profile_id=16209803, _options={}) #run the jewels instagram profile
    options = {query: {start: (Time.now - 3.day).to_i, end: Time.now.to_i, metric: 'fans'}.merge(_options)}
    response = post("/metrics/profile/#{_nbs_profile_id}.json", options)
    if response.code == 200
      tidy_metrics(response.parsed_response['fans'])
    else
      []
    end
  end

  def self.setup(_key)
    base_uri "#{_key}.api3.nextbigsound.com"
  end

  def self.tidy_metrics(_arry)
    _arry.map do |day, value|
      {time: Time.at(day.to_i.days.to_i).utc, volume: value}
    end
  end

end
