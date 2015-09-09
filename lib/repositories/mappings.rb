class Mappings


  class << self
    def find(id)
      DB.from(:mappings).where(id: id).first
    end

    def all
      DB.from(:mappings).all
    end

    def insert(mapping)
      DB.from(:mappings).insert(mapping)
    end
  end

end
