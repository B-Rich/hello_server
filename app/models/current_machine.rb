class CurrentMachine
  NAME = "current_machine"

  def self.refresh
    s = HelloServerClient::Service.find_or_initialize_by_name(NAME)
    usw = Usagewatch
    s.value = {
      cpu: {
        cpu_usage: usw.uw_cpuused,
        load: usw.uw_load,
      },
      memory: {
        usage: usw.uw_memused.to_s + "%",
      },
      hdd: {
        disk_usage: usw.uw_diskused,
        diskioreads: usw.uw_diskioreads,
        diskiowrites: usw.uw_diskiowrites,
      },
      network: {
        tcp_usage: usw.uw_tcpused,
        udp_usage: usw.uw_udpused,
        bandrx: usw.uw_bandrx,
        bandtx: usw.uw_bandtx
      },
      cpu_top: usw.uw_cputop.collect{|top| "#{top[1]}% - #{top[0]}"},
      mem_top: usw.uw_memtop.collect{|top| "#{top[1]}% - #{top[0]}"},
    }
    s.save!
    s
  end
end