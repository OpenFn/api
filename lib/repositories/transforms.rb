class Transforms

  class << self
    def find(id)
      DB.from(:transforms).where(id: id).first
    end

    def all
      DB.from(:transforms).all
    end

    def insert(transform)
      DB.from(:transforms).insert(submission)
    end
  end

end
