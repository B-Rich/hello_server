module UserJobs
end

class UserJob
  include SuckerPunch::Job

  KLASSES = UserJobs.constants.select { |c| Class === UserJobs.const_get(c) }

  def refresh(event = nil)
    KLASSES.each do |klass|
      # meta magic
      object = UserJobs.const_get(klass).new

      t = Time.now
      logger.info("#{klass} started")
      object.refresh
      logger.info("#{klass} finished, time cost #{Time.now - t}")
    end
  end
end