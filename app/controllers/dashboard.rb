HelloServer::App.controller :dashboard do
  get :index, :provides => [:html, :rss, :atom] do
    # holy shit!
    @services = HelloServerClient::Service.all.collect { |s| s }.sort { |a, b| a.name.to_s <=> b.name.to_s }
    render 'dashboard/index'
  end
end