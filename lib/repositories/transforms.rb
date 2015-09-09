class Transforms < Sequel::Model(:transforms)

  dataset_module do

    def latest_for_mapping(mapping_id)
      where(mapping: mapping_id).order(:modified,:created_at).first
    end

  end

end
