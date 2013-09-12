require 'sidekiq'

class Reindex
  include Sidekiq::Worker
  
  sidekiq_options({
    unique: true,
    manual: true,
    expiration: 60 # Lock lasts for 60 seconds, or until the indexing is performed.
  })
        
  def self.lock *args
    "locks:unique:#{args[0]}:#{args[1]}"
  end
  
  def self.unlock! id, klazz
    lock = self.lock(id,klazz)
    Sidekiq.redis{|conn| conn.del(lock)}
  end
  
  def perform id, klazz
    self.class.unlock!(id,klazz)
    klazz.constantize.find(id).index
  end
end
