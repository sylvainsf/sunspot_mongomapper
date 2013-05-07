class Reindex
  @queue = :z_reindex

  def self.perform id, klazz
    klazz.constantize.find(id).index
  end

end
