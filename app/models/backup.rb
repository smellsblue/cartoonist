class Backup
  class << self
    def all
      result = Cartoonist::Backup.all.map do |key, value|
        [key, value.call]
      end

      Hash[result]
    end
  end
end
