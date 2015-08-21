Rails.application.routes.draw do
  get    '',                 to: 'service#index'
  get    'csirt/svcdoc.xml', to: 'service#svcdoc'

  get    'csirt/:workspace/:collection',     to: 'rolie_entry#index'
  get    'csirt/:workspace/:collection/:id', to: 'rolie_entry#get'
  post   'csirt/:workspace/:collection',     to: 'rolie_entry#post'
  put    'csirt/:workspace/:collection/:id', to: 'rolie_entry#put'
  delete 'csirt/:workspace/:collection/:id', to: 'rolie_entry#delete'
  # TODO: search
end
