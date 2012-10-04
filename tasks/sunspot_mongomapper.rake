# auto load rails tasks
require 'sunspot/rails/tasks'

# hack to remove 'sunspot:reindex' task and add our own
# see http://blog.jayfields.com/2008/02/rake-task-overwriting.html
class Rake::Task
  def abandon
    @full_comment = nil
    clear_actions
    clear_prerequisites
  end
end

Rake::Task["sunspot:reindex"].abandon
Rake::Task["sunspot:solr:start"].abandon



# override the tasks that depends on active record
namespace :sunspot do

  # override the task that starts on 8982
  namespace :solr do
    desc 'Start the Solr instance'
    task :start => :environment do
      case RUBY_PLATFORM
      when /w(in)?32$/, /java$/
        abort("This command is not supported on #{RUBY_PLATFORM}. " +
              "Use rake sunspot:solr:run to run Solr in the foreground.")
      end

      if defined?(Sunspot::Rails::Server)
        Sunspot::Rails::Server.new(:port => 8983).start
      else
        Sunspot::Solr::Server.new.start
      end

      puts "Successfully started Solr ..."
    end
  end
  desc "Reindex all solr models that are located in your application's models directory. (Batch size ignored)"
  # This task depends on the standard Rails file naming \
  # conventions, in that the file name matches the defined class name. \
  # By default the indexing system works in batches of 50 records, you can \
  # set your own value for this by using the batch_size argument. You can \
  # also optionally define a list of models to separated by a forward slash '/'
  # 
  # $ rake sunspot:reindex                # reindex all models
  # $ rake sunspot:reindex[1000]          # reindex in batches of 1000
  # $ rake sunspot:reindex[false]         # reindex without batching
  # $ rake sunspot:reindex[,Post]         # reindex only the Post model
  # $ rake sunspot:reindex[1000,Post]     # reindex only the Post model in
  #                                       # batchs of 1000
  # $ rake sunspot:reindex[,Post+Author]  # reindex Post and Author model
  task :reindex, [:batch_size, :models] => [:environment] do |t, args|
    t.clear_actions
    t.clear_prerequisites
    unless args[:models]
      all_files = Dir.glob(Rails.root.join('app', 'models', '*.rb'))
      all_models = all_files.map { |path| File.basename(path, '.rb').camelize.constantize }
      sunspot_models = all_models.select { |m| m.respond_to?(:searchable?) and m.searchable? }
    else
      sunspot_models = args[:models].split('+').map{|m| m.constantize}
    end
    sunspot_models.each do |model|
      puts "Re-indexing #{model.name}"
      model.solr_reindex
    end
  end
end

