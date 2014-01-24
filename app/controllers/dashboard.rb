HelloServer::App.controller :dashboard do
  get :index, :provides => [:html, :rss, :atom] do
    @services = HelloServerClient::Service.all
    render 'dashboard/index'
  end
end