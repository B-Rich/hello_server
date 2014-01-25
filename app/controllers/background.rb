HelloServer::App.controller :background do
  post :refresh, csrf_protection: false, provides: [:js] do
    CurrentMachineJob.new.async.refresh
    UserJob.new.async.refresh

    # holy shit!
    @services = HelloServerClient::Service.all.collect { |s| s }.sort { |a, b| a.name.to_s <=> b.name.to_s }
    render 'background/index'
  end
end