class DownloadsController < Spree::BaseController
  before_filter :require_user
  before_filter :find_product

  def index
    @s3_download_set = S3DownloadSet.new(:user => current_user, :product => @product, :url_generation => 'bulk')
    respond_to do |format|
      if @s3_download_set.valid?
        format.html
      else
        flash[:notice] = "I'm sorry, there was a problem with that request.  If this problem was unexpected, please email support@envycasts.com"
        redirect_to user_path(current_user) and return
      end
    end
  end

  def show
    @s3_download_set = S3DownloadSet.new(:user => current_user, :product => @product, :id => params[:id])
    @download = @s3_download_set.s3_objects.first
    if @s3_download_set.valid?
      redirect_to @s3_download_set.s3_objects.first.temporary_url and return
    else
      render :status => 401
    end
  end


  private
    def find_product
      @product = Product.find_by_param(params[:product_id])
    end
end