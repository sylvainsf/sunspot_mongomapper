class Reindex
  include Sidekiq::Worker
  
  def perform id, klazz
    klazz.constantize.find(id).index
  end

end
