ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'articles', :action => 'index'
  
  map.resource  :session
  map.resources :users
  map.resources :articles,  :has_many => :comments
  map.resources :companies, :has_many => :memberships
  map.resources :events,    :has_many => :presences
  
  map.dated_articles 'articles/:year/:month', :controller=>"articles", :requirements => { :year => /\d+/, :month => /\d+/ }
  map.signup         'signup',        :controller => 'users', :action => 'new'
  map.settings       'settings',      :controller => 'users', :action => 'edit'
  map.activate       'activate/:key', :controller => 'users', :action => 'activate'
  map.login          'login',         :controller => 'sessions', :action => 'new'
  map.logout         'logout',        :controller => 'sessions', :action => 'destroy'
  
  map.connect 'static/:action/:id', :controller => "static"

end