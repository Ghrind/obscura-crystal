require "./../combat"

module Obscura
  class CombatPositions < Hydra::Text
    TEMPLATE = [
      "73    ",
      "51AC  ",
      "62BD  ",
      "84    ",
      "      ",
      "      ",
      "      ",
      "      ",
    ]

    @combat = Obscura::Combat.new
    property :combat

    def content() Hydra::ExtendedString
      rows = TEMPLATE.dup
      1.upto(8) do |n|
        i = n - 1
        if @combat.ennemies[i]?
          ennemy = @combat.ennemies[i]
          string = "#{n}. #{ennemy.name} #{ennemy.hit_points}"
          string = "<red-fg>#{string}</red-fg>" if @combat.ennemies[i].dead
          rows[i] += string
        else
          rows.each_with_index do |row, index|
            if row[0].to_s == n.to_s || row[1].to_s == n.to_s
              rows[index] = row.sub(n.to_s, " ")
            end
          end
        end
      end
      @value = rows.join("\n")
      super
    end
  end
end
