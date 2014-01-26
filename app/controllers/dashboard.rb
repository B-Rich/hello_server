HelloServer::App.controller :dashboard do
  get :index, :provides => [:html, :rss, :atom] do
    # holy shit!
    @services = HelloServerClient::Service.all.collect { |s| s }.sort { |a, b| a.name.to_s <=> b.name.to_s }
    render 'dashboard/index'
  end

  delete :clean, csrf_protection: false do
    HelloServerClient::Service.all.each do |s|
      if s.updated_at < (Time.now - 60*60)
        s.delete
      end
    end
    redirect_to '/dashboard'
  end

  delete :purge, csrf_protection: false do
    HelloServerClient::Service.all.each do |s|
      if s.updated_at < (Time.now - 10)
        s.delete
      end
    end
    redirect_to '/dashboard'
  end

end