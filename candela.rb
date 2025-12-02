#!/usr/bin/env ruby

require 'json'

class Calendar
    attr_accessor :sealed_films
    attr_accessor :opened_films

    def initialize()
        @sealed_films = []
        @opened_films = []

        @sealed_file_path = "sealed.json"
        @opened_file_path = "opened.json"

        if not File.exist?(@sealed_file_path)
            sealed_file = File.new(@sealed_file_path, "w")
            @sealed_films = ingest_films
            write_films
        end
    end
        
    def ingest_films
        file_of_films = File.new("films.txt")
        file_of_films.readlines.map { |line| line.strip }
    end
    
    def open_a_film()
        sealed_films_json = File.read(@sealed_file_path)
        opened_films_json = File.read(@opened_file_path)

        @sealed_films = JSON.parse(sealed_films_json)
        @opened_films = JSON.parse(opened_films_json)

        sealed_films_left = @sealed_films.length
        random_film_index = rand(0..(sealed_films_left - 1))
        random_sealed_film = @sealed_films[random_film_index]

        @opened_films.push(random_sealed_film)
        @sealed_films.delete_at(random_film_index)

        write_films_lists

        unveil_film(random_sealed_film)
    end

    # Writes the sealed and opened films lists to disk
    def write_films_lists
        sealed_file = File.new(@sealed_file_path, "w")
        opened_file = File.new(@opened_file_path, "w")

        sealed_films_json = JSON.pretty_generate(@sealed_films)
        opened_films_json = JSON.pretty_generate(@opened_films)

        sealed_file.write(sealed_films_json)
        opened_file.write(opened_films_json)

        sealed_file.flush
        opened_file.flush
    end

    # Unveils the newly opened film to the user
    def unveil_film(film)
        print_and_sleep("\nIt's day #{(@opened_films.length)} of your Advent calendar!",      1.0)
        print_and_sleep(" Only #{(25 - @opened_films.length)} days left until Christmas!",    1.0)
        print_and_sleep("\n\nYou peel open the next space on your Advent calendar and find ", 1.0)
        print_and_sleep(".", 0.5)
        print_and_sleep(".", 0.5)
        print_and_sleep(".", 2.0)
        print_and_sleep(" #{film}!", 1.0)
        print_and_sleep(" Merry Christmas!", 2.0)
        print_and_sleep("\n\n(Press Enter to exit) ", 0.0)
        gets
    end

    # Prints a message before sleeping for a duration
    def print_and_sleep(message, delay)
        print message
        sleep(delay)
    end
end
