class User < ActiveRecord::Base
    has_many :captured_pokemons
end