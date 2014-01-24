HelloServer::App.controller :dashboard do
  get :index, :provides => [:html, :rss, :atom] do
    @services = Service.all
    render 'dashboard/index'
  end
end