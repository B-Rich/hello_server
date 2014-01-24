HelloServer::App.controller :dashboard do
  get :index, :provides => [:html, :rss, :atom] do
    @notices = []
    render 'dashboard/index'
  end
end