map.downloads '/downloads/:product_id', :controller => 'downloads', :action => 'index'
map.download_individual '/downloads/:product_id/:id', :controller => 'downloads', :action => 'show'

map.namespace :admin do |admin|
  admin.resources :products, :has_many => [:s3_products]
end