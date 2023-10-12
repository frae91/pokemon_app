require 'active_record'
require 'colorize'

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "./config/pokemon.db"
)

require_relative "../lib/user"
require_relative "../lib/captured_pokemon"
require_relative "../lib/poke_api"