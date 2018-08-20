class Spree::Admin::ContentsController < Spree::Admin::ResourceController

  before_action :load_resource
  before_action :parent, :only => :index

  before_action :get_pages, :only => [ :new, :edit, :create, :update ]

  belongs_to 'spree/page'

  def update_positions
    @page = parent
    params[:positions].each do |id, index|
      @page.contents.update_all(['position=?', index], ['id=?', id])
    end
    respond_to do |format|
      format.html { redirect_to admin_page_contents_url(@page) }
      format.js  { render :text => 'Ok' }
    end
  end

  private

  def get_pages
    @pages = Spree::Page.order(:position).all
  end

  def parent
    @page ||= Spree::Page.find_by_path(params[:page_id])
  end

  def collection
    params[:q] ||= {}
    params[:q][:s] ||= "page asc"
    @search = parent.contents.search(params[:q])
    @collection = @search.page(params[:page]).per(Spree::Config[:admin_orders_per_page])
  end

  def permitted_resource_params
    return ActionController::Parameters.new unless params[resource.object_name].present?
    params.require(resource.object_name).permit(:delete_attachment,
                                                :page,
                                                :title,
                                                :body,
                                                :link,
                                                :link_text,
                                                :context,
                                                :hide_title,
                                                :position,
                                                :attachment)
  end

  def model_class
    Spree::Content
  end
end
