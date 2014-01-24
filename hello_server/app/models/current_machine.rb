class CurrentMachine
  NAME = "current_machine"

  def self.refresh
    s = Service.find_or_initialize_by_name(NAME)
    usw = Usagewatch
    s.value = {
      cpu: {
        usage: usw.uw_cpuused
      },
      hdd: {
        disk_usage: usw.uw_diskused,
      }
    }
    s.save!
    s
  end
end