require_relative "../config/environment"

class Run
    attr_accessor :user
    def initialize
        puts "Welcome to the Pokemon App!".white.on_red.bold

        puts "Please enter your username to sign-in:"
        username = gets.chomp

        if User.find_by_name(username)
            @user = User.find_by_name(username)
            puts "Welcome back, #{user.name}!"
        else
            @user = User.create(name: username)
            puts "#{user.name} account successfully created!"
        end

        is_active = true

        while is_active do

            choice = menu

            if choice.downcase == ".exit"
                is_active = false
                puts "Thank you for using Pokemon app. Goodbye, #{user.name}!".red.bold
            elsif choice.downcase == ".pokedex"
                system("clear") # "cls"
                pokedex
            elsif choice.downcase == ".explore"
                system("clear")
                explore
            elsif choice.downcase == ".bag"
                system("clear")
                bag
            else
                system("clear")
                puts "Command not found!".red.bold
            end
        end
    end

    def menu
        puts "MENU:".blue
        puts "#{".pokedex".on_blue}\t- to get pokemon info"
        puts "#{".explore".on_blue}\t- to explore and capture pokemon"
        puts "#{".bag".on_blue}\t\t- to open bag and see captured pokemon"
        puts "#{".exit".on_blue}\t\t- to terminate the Pokemon app"

        puts "Please enter the command:"
        gets.chomp
    end

    def pokedex
        is_pokedex = true

        while is_pokedex do
            puts "Which pokemon would you like to check? Enter the pokemon name or id (enter #{".back".on_red} to go back to the main menu):"

            input = gets.chomp
            
            if input.downcase != ".back"
                pokemon = PokeAPI.get_pokemon(input)
                if pokemon.empty?
                    puts "No Pokemon found".red.bold
                else
                    display_pokemon_info(pokemon)
                end
            else
                is_pokedex = false
                system("clear")
            end
        end
    end

    def explore
        is_explore = true

        while is_explore do
            pokemon_id = rand(1..1017)

            puts "A wild pokemon appeared!".red.bold

            pokemon = PokeAPI.get_pokemon(pokemon_id.to_s)
            display_pokemon_info(pokemon)

            puts "Will you catch this pokemon (yes/no)?"

            input = gets.chomp

            if input.downcase == "yes"
                user.captured_pokemons.create(pokemon_id: pokemon[:id], pokemon_name: pokemon[:name])
                puts "You have caught #{pokemon[:name].on_white}"
            else
                puts "#{pokemon[:name]} ran away!"
            end

            puts "Continue exploring (yes/no)?"

            cont = gets.chomp

            if cont.downcase != "yes"
                is_explore = false
                system("clear")
            end
        end
    end

    def bag
        puts "Here are your captured pokemons".on_blue.bold
        user.captured_pokemons.each_with_index do |pokemon, i|
            puts "#{i+1}. (#{pokemon.pokemon_id}) #{pokemon.pokemon_name}"
        end

        puts "\n\nPress enter to go back to the main menu"
        go_back = gets.chomp
        system("clear")
    end

    def display_pokemon_info(pokemon)
        puts "#{pokemon[:id]} - #{pokemon[:name]}".on_green

        puts "Types:"
        pokemon[:types].each_with_index do |type, i|
            puts "#{i + 1}. #{type["type"]["name"]}"
        end

        puts "Abilities:"
        pokemon[:abilities].each_with_index do |ability, i|
            puts "#{i + 1}. #{ability["ability"]["name"]}"
        end
    end
end

Run.new