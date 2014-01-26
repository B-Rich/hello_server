HelloServer::App.controller :dashboard do
  get :index, :provides => [:html] do
    # holy shit!
    @notifications = HelloServerClient::Notification.all.collect { |s| s }.sort { |a, b| a.name.to_s <=> b.name.to_s }
    render 'dashboard/index'
  end

  get :show, map: "/dashboard/:id", provides: [:html] do
    # holy shit!
    @notification = HelloServerClient::Notification.find_or_initialize_by_name(params[:id])
    @notifications = [@notification]

    render 'dashboard/show'
  end

  delete :clean, csrf_protection: false do
    HelloServerClient::Notification.all.each do |s|
      if s.updated_at < (Time.now - 60*60)
        s.delete
      end
    end
    redirect_to '/dashboard'
  end

  delete :purge, csrf_protection: false do
    HelloServerClient::Notification.all.each do |s|
      if s.updated_at < (Time.now - 10)
        s.delete
      end
    end
    redirect_to '/dashboard'
  end

end