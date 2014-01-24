HelloServer::App.controller :dashboard do
  get :index, :provides => [:html, :rss, :atom] do
    CurrentMachine.refresh

    @services = Service.all
    render 'dashboard/index'
  end
end