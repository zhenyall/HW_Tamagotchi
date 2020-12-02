# frozen_string_literal: true

require 'erb'
require './app/lib/logic'

class Pet
  include Logic

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @req = Rack::Request.new(env)
    @animal = animal
    @name = name
    @health = 100 # he is healthy
    @mood = 100 # he is happy
    @stomachisfull = 100 # he is full
    @stomachisempty = 20 # pet hungry
    @drowsiness = false # slept well
    @sleep = 100 # want to sleep
    @dirty = 0
    @clear = 100
    @walk = 0
    @needs = 10
    @NEEDS = %w[health mood stomachisfull sleep clear]

  end

  def responce
    case @req.path
    when '/'
      Rack::Responce.new(render('mods.html.erb'))

    when '/initialize'
      Rack::Responce.new do |responce|
        responce.set_cookie('health', @health)
        responce.set_cookie('mood', @mood)
        responce.set_cookie('stomachisfull', @stomachisfull)
        responce.set_cookie('sleep', @sleep)
        responce.set_cookie('clear', @clear)
        responce.set_cookie('name', @req.params['name'])
        responce.set_cookie('/start')
      end
    when '/exit'
      Rack::Responce.new('Game Over', 404)
      Rack::Responce.new(render('end.html.erb'))

    when '/start'
      if get('health') <= 0 || get('mood') <= 0 || get('stomachisfull') <= 0 || get('sleep') <= 0 || get('clear') <= 0
        Rack::Responce.new('Game Over', 404)
        Rack::Responce.new(render('ended.html.erb'))
      else
        Rack::Responce.new(render('ended.html.erb'))
      end

    when '/change'
      return Logic.change_params(@req, 'health') if @req.params['health']
      return Logic.change_params(@req, 'mood') if @req.params['mood']
      return Logic.change_params(@req, 'stomachisfull') if @req.params['stomachisfull']
      return Logic.change_params(@req, 'sleep') if @req.params['sleep']
      return Logic.change_params(@req, 'clear') if @req.params['clear']
    else
      Rack::Responce.new('Not Found', 404)
    end
  end

  def name
    name = @req.cookies['name'].delete(' ')
    name.empty? ? 'Pet' : @req.cookies['name']
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def get(attr)
    @req.cookies[attr.to_s].to_i
  end
end
