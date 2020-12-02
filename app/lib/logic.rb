# frozen_string_literal: true

module Logic
  def self.change_params(req, name)
    Rack::Response.new do |response|
      response.set_cookie(name, req.cookies[name.to_s].to_i + 20) if req.cookies[name.to_s].to_i < 100

      need = ($NEEDS - [name]).sample

      response.redirect('/start')
    end
  end
end
