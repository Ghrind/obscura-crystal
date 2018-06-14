require "csv"
require "./weapon"

module Obscura
  class Datafile(T)
    getter :content

    def initialize(@path : String)
      @content = Array(T).new
    end

    def as_weapons!() Obscura::Datafile(T)
      each_row do |row|
        weapon = Obscura::Weapon.new
        weapon.precision = row["precision"].to_i
        weapon.name = row["name"]
        weapon.hits_per_turn = row["hits_per_turn"].to_i
        weapon.precision_bonus = row["precision_bonus"].to_i
        weapon.damage_min = row["damage_min"].to_i
        weapon.damage_max = row["damage_max"].to_i
        weapon.modes = row["modes"].split(",")
        weapon
      end
      self
    end

    private def each_row(&block)
      file = File.open(@path)
      csv = CSV.new(file, { :headers => true })
      csv.each do |row|
        @content << yield row
      end
    ensure
      file.close if file
    end
  end
end
