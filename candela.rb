#!/usr/bin/env ruby

def ingest_films
    file_of_films = File.new("films.txt")
    file_of_films.readlines
end

puts ingest_films
