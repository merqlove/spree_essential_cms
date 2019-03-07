class Spree::Admin::PageImagesController < Spree::Admin::ResourceController

  create.before :set_viewable
  update.before :set_viewable
  destroy.before :destroy_before

  belongs_to 'spree/page'

  def update_positions
    model_class.update_all_positions(params[:positions])
    respond_to do |format|
      format.js  { render :plain => '' }
    end
  end
  
  private
  
  def location_after_save
    admin_page_images_url(parent)
  end

  def parent
    if parent_data.present?
      @parent ||= Spree::Page.find_with_path(params[:page_id])
      instance_variable_set("@#{resource.model_name}", @parent)
    end
  end

  def set_viewable
    @page_image.viewable = parent
  end

  def destroy_before
    @viewable = @page_image.viewable
  end

  def collection_url
    admin_page_images_url(parent)
  end

  def permitted_resource_params
    return ActionController::Parameters.new unless params[resource.object_name].present?
    params.require(resource.object_name).permit(:delete_attachment, :attachment, :alt)
  end
end
