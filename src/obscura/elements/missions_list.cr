module Obscura
  class MissionsList < Hydra::List
    @missions = Array(Obscura::Mission).new
    property :missions

    def content() Hydra::ExtendedString
      @items = @missions.map do |mission|
        string = "#{mission.name} (#{mission.reputation_bonus})"
        string = "<green-fg>#{string}</green-fg>" if mission.completed
        Hydra::ExtendedString.new(string)
      end
      super
    end
  end
end
