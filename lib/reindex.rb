require 'sidekiq'

class Reindex
  include Sidekiq::Worker
  
  sidekiq_options({
    queue: :reindex,
  })

  def perform id, klazz
    klazz.constantize.find(id).index
  end
end
