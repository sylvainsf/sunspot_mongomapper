require 'sidekiq'

class Reindex
  include Sidekiq::Worker
  
  sidekiq_options({
    queue: :reindex,
  })

  def perform id, klazz
    instance = klazz.constantize.find(id)
    index_synchronous(instance) unless instance.nil?
  end
  
  def index_synchronous resource
    resource.index
    Sunspot.commit_if_dirty unless Rails.env.production?
  end
end
