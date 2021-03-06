Rails.application.routes.draw do
  namespace :api, defaults: {format: "json"} do
    resources :bills, except: [:create, :new, :edit]
    resources :legislators, except: [:create, :new, :edit, :show] do
      get "bills"
    end
    get 'legislators/download' => "legislators#get_votes_for_legislators_in_csv"
    get 'legislators/download_pdf' => "legislators#get_votes_for_legislators_in_pdf"
    get 'legislators/zip_code' => "legislators#get_legislators_by_zip_code"
    get 'legislators/votes' => "legislators#get_votes_for_bills"
    get 'legislators/votes/all' => "legislators#get_votes_for_bills_and_legislators"
  end

  root :to => 'report_card#index'
  namespace :example do
    get 'legislators/:last_name' => "legislators#show"
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
