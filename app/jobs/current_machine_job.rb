class CurrentMachineJob
  include SuckerPunch::Job

  NAME = "current_machine"

  HDD_IGNORED_PATH = [
    "/dev",
    "/run",
    "/run/lock",
    "/run/shm"
  ]

  def refresh(event = nil)
    t = Time.now
    s = HelloServerClient::Service.find_or_initialize_by_name(NAME)
    logger.info("#{NAME} started")

    usw = Usagewatch

    hdd_space = %x(df -H).split("\n").collect { |h| h.gsub(/\s+/, " ").split(" ") }[1..-1].collect { |h| { path: h[5], desc: h[0], free: h[3], used: h[2], capacity: h[1] } }
    hdd_space = hdd_space.select { |h| not HDD_IGNORED_PATH.include?(h[:path]) }
    hdd_space_frees = Hash[hdd_space.collect { |h| [h[:path], "#{h[:free]}/#{h[:capacity]}"] }]
    #cpu_top = usw.uw_cputop.collect { |top| "#{top[1]}% - #{top[0]}" }
    #mem_top = usw.uw_memtop.collect { |top| "#{top[1]}% - #{top[0]}" }
    cpu_top = Hash[usw.uw_cputop.collect { |top| [top[0].gsub(/.*\//, ""), top[1].to_s + "%"] }]
    mem_top = Hash[usw.uw_memtop.collect { |top| [top[0].gsub(/.*\//, ""), top[1].to_s + "%"] }]

    s.value = {
      cpu: {
        cpu_usage: usw.uw_cpuused.to_s + "%",
        load: usw.uw_load,
      },
      memory: {
        usage: usw.uw_memused.to_s + "%",
      },
      hdd: {
        diskioreads: usw.uw_diskioreads,
        diskiowrites: usw.uw_diskiowrites,
      },
      hdd_free_space: hdd_space_frees,
      network: {
        tcp_usage: usw.uw_tcpused,
        udp_usage: usw.uw_udpused,
        bandrx: usw.uw_bandrx,
        bandtx: usw.uw_bandtx
      },
      cpu_top: cpu_top,
      mem_top: mem_top,
    }
    s.save!

    logger.info("#{NAME} finished, time cost #{Time.now - t}")

    s
  end
end