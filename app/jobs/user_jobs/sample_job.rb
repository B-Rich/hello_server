class SampleJob
  include SuckerPunch::Job

  NAME = "test"

  def refresh(event = nil)
    s = HelloServerClient::Service.find_or_initialize_by_name(NAME)
    s.value = {
      test: "ok"
    }
    s.save!
    s
  end
end