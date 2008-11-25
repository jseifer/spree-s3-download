class DownloadsController < Spree::BaseController
  before_filter :login_required
  before_filter :find_product

  def index
    @s3_download_set = S3DownloadSet.new(:user => current_user, :product => @product, :download_type => 'bulk')
    respond_to do |format|
      if @s3_download_set.valid?
        format.html
      else
        flash[:notice] = "I'm sorry, there was a problem with that request.  If this problem was unexpected, please email support@envycasts.com"
        redirect_to account_path and return
      end
    end
  end
  
  def show
    @s3_download_set = S3DownloadSet.new(:user => current_user, :product => @product, :id => params[:id])
    @download = @s3_download_set.s3_objects.first
    if @s3_download_set.valid?
      if session[:download_preference] == 'alternate'
        send_file "#{File.expand_path(RAILS_ROOT)}/downloads/#{@download.filename}", :x_sendfile => true
      else
        redirect_to @s3_download_set.s3_objects.first.temporary_url and return
      end
    else
      render :status => 401
    end
  end
  
  private
    def find_product
      @product = Product.find_by_param(params[:product_id])
    end
end