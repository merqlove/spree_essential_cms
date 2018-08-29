class Spree::Admin::PagesController < Spree::Admin::ResourceController
  before_action :load_data, only: [:new]

  def nested_pages
    @pages ||= collection
    render :index
  end

  def show
    redirect_to edit_object_url(@object)
  end

  def location_after_save
    case params[:action]
      when "create"
        edit_admin_page_content_path(@page, @page.contents.first)
      else
        admin_page_path(@page)
    end
  end

  def update_positions
    params[:positions].each do |id, index|
      Spree::Page.update_all(['position=?', index], ['id=?', id])
    end
    respond_to do |format|
      format.html { redirect_to admin_pages_path }
      format.js  { render :plain => '' }
    end
  end

  private
    def find_resource
      @page ||= ::Spree::Page.find_with_path(params[:id])
    end

    def load_data
      @parent ||= Spree::Page.find_with_path(params[:page_id])
      @page.parent_id = @parent.id
    end

    def collection
      params[:q] ||= {}
      params[:q][:s] ||= "page asc"
      @search = @object ? @object.children : Spree::Page.try(:roots)
      @search = @search.search(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_orders_per_page])
    end

    def permitted_resource_params
      return ActionController::Parameters.new unless params[resource.object_name].present?
      params.require(resource.object_name).permit(:title,
                                                  :nav_title,
                                                  :path,
                                                  :parent_id,
                                                  :meta_title,
                                                  :meta_description,
                                                  :meta_keywords,
                                                  :position,
                                                  :accessible,
                                                  :visible)
    end
end
