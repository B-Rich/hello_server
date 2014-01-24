HelloServer::App.controller :background do
  post :refresh, csrf_protection: false, provides: [:js] do
    CurrentMachine.refresh

    @services = Service.all
    render 'background/index'
  end
end