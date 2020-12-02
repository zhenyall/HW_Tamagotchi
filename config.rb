# frozen_string_literal: true

require './app/pet'

use Rack::Reloder, 0
use Rack::Static, urls: ['/public']

run Pet
