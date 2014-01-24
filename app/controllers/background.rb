HelloServer::App.controller :background do
  post :refresh, csrf_protection: false, provides: [:js] do
    CurrentMachine.refresh

    # holy shit!
    @services = HelloServerClient::Service.all.collect { |s| s }.sort { |a, b| a.name.to_s <=> b.name.to_s }
    render 'background/index'
  end
end