class Spree::PossiblePage
  def self.matches?(request)
    return false if request.fullpath =~ /(^\/+(admin|account|cart|checkout|content|login|pg\/|orders|products|s\/|session|signup|shipments|states|t\/|tax_categories|user)+)/
    !Spree::Page.active.find_with_path(request.fullpath).nil?
  end
end

Spree::Core::Engine.append_routes do

  namespace :admin do

    resources :pages, :constraints => { :id => /.*/ } do
      collection do
        post :update_positions
      end

      resources :contents do
        collection do
          post :update_positions
        end
      end

      resources :images, :controller => "page_images" do
        collection do
          post :update_positions
        end
      end
    end

  end

  constraints(Spree::PossiblePage) do
    get '(:page_path)', :to => 'pages#show', :page_path => /.*/, :as => :page
  end

end
