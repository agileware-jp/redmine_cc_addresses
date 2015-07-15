resources :issues do
  resources :cc_addresses, only: [:create, :destroy]
end
