class Spree::Admin::ContentsController < Spree::Admin::ResourceController

  before_action :load_resource
  before_action :parent, :only => :index

  before_action :get_pages, :only => [ :new, :edit, :create, :update ]

  belongs_to 'spree/page'

  def show
    redirect_to edit_object_url(@object)
  end

  def update_positions
    model_class.update_all_positions(params[:positions])
    respond_to do |format|
      format.html { redirect_to admin_page_contents_url(parent) }
      format.js  { render :plain => '' }
    end
  end

  protected

  def parent
    if parent_data.present?
      @parent ||= Spree::Page.find_with_path(params[:page_id])
      instance_variable_set("@#{resource.model_name}", @parent)
    end
  end

  def collection
    params[:q] ||= {}
    params[:q][:s] ||= "position asc"
    @search = parent.contents.search(params[:q])
    @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_orders_per_page])
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

  private

  def get_pages
    @pages = Spree::Page.order(:position).all
  end
end
