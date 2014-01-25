class UserJob
  include SuckerPunch::Job

  def refresh(event = nil)
    t = Time.now
    logger.info("user_job started")
    logger.info("user_job finished, time cost #{Time.now - t}")
  end
end