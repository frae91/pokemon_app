require 'net/http'
require 'open-uri'
require 'json'

class PokeAPI
    BASE_URL = "https://pokeapi.co/api/v2/pokemon/"

    def self.get_pokemon(id_or_name)
        uri = URI.parse(BASE_URL + id_or_name)
        response = Net::HTTP.get_response(uri)

        if response.kind_of? Net::HTTPSuccess
            json = JSON.parse(response.body)
            pokemon = {
                :id => json["id"],
                :name => json["name"],
                :types => json["types"],
                :abilities => json["abilities"]
            }
        else
            {}
        end
    end
end