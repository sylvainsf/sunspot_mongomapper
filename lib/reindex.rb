require 'sidekiq'

class Reindex
  include Sidekiq::Worker
  
  sidekiq_options({
    queue: :reindex,
  })

  def perform id, klazz
    index_synchronous klazz.constantize.find(id)
  end
  
  def index_synchronous resource
    resource.index
    Sunspot.commit_if_dirty
  end
end
