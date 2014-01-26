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
    s = HelloServerClient::Notification.find_or_initialize_by_name(NAME)
    logger.info("#{NAME} started")

    usw = Usagewatch
    usw.batch_refresh

    hdd_space = %x(df -H).split("\n").collect { |h| h.gsub(/\s+/, " ").split(" ") }[1..-1].collect { |h| { path: h[5], desc: h[0], free: h[3], used: h[2], capacity: h[1] } }
    hdd_space = hdd_space.select { |h| not HDD_IGNORED_PATH.include?(h[:path]) }

    summaries = Array.new
    details = Array.new

    a = ["cpu", "usage", { value: usw.uw_cpuused(false).to_s + "%", klass: 'red' }]
    details << a

    a = ["cpu", "load", { value: usw.uw_load, klass: 'red strong' }]
    details << a
    summaries << a

    aa = usw.uw_cputop.collect { |top| ["cpu_top", "", { value: top[0].gsub(/.*\//, "") + " - " + top[1].to_s + "%", klass: 'red' }] }
    details += aa
    summaries << aa.first if aa.size > 0

    a = ["memory", "usage", { value: usw.uw_memused.to_s + "%", klass: 'blue' }]
    details << a
    summaries << a

    aa = usw.uw_memtop.collect { |top| ["mem_top", "", { value: top[0].gsub(/.*\//, "") + " - " + top[1].to_s + "%", klass: 'blue' }] }
    details += aa
    summaries << aa.first if aa.size > 0

    a = ["hdd", "diskioreads", { value: usw.uw_diskioreads(false), klass: 'green' }]
    details << a
    summaries << a

    a = ["hdd", "diskiowrites", { value: usw.uw_diskiowrites(false), klass: 'green' }]
    details << a
    summaries << a

    aa = hdd_space.collect { |h| ["hdd_space", h[:path], { value: "#{h[:free]} / #{h[:capacity]}", klass: 'green' }] }.uniq
    details += aa
    summaries += aa

    a = ["network", "tcp_usage", { value: usw.uw_tcpused, klass: 'teal' }]
    details << a

    a = ["network", "udp_usage", { value: usw.uw_udpused, klass: 'teal' }]
    details << a

    a = ["network", "bandrx", { value: usw.uw_bandrx(false), klass: 'teal' }]
    details << a
    summaries << a

    a = ["network", "bandtx", { value: usw.uw_bandtx(false), klass: 'teal' }]
    details << a
    summaries << a

    s.summaries = summaries
    s.details = details

    s.save!

    logger.info("#{NAME} finished, time cost #{Time.now - t}")

    s
  end
end