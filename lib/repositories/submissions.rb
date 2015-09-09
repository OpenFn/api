class Submissions

  class << self
    def find(id)
      DB.from(:submissions).where(id: id).first
    end

    def all
      DB.from(:submissions).all
    end

    def insert(submission)
      DB.from(:submissions).insert(submission)
    end
  end

end
