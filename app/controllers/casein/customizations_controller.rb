# Scaffolding generated by Casein v5.0.1.0

module Casein
  class CustomizationsController < Casein::CaseinController
  
    ## optional filters for defining usage according to Casein::AdminUser access_levels
    # before_filter :needs_admin, :except => [:action1, :action2]
    # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]

    def index
      @casein_page_title = 'Customizations'
  		@customizations = Customization.order(created_at: :desc).limit(1)
    end
  
    def show
      @casein_page_title = 'View customization'
      @customization = Customization.find params[:id]
    end
  
    def new
      @casein_page_title = 'Add a new customization'
    	@customization = Customization.new
    end

    def create
      @customization = Customization.new customization_params
    
      if @customization.save
        flash[:notice] = 'Customization created'
        redirect_to casein_customizations_path
      else
        flash.now[:warning] = 'There were problems when trying to create a new customization'
        render :action => :new
      end
    end
  
    def update
      @casein_page_title = 'Update customization'
      
      @customization = Customization.find params[:id]
    
      if @customization.update_attributes customization_params
        flash[:notice] = 'Customization has been updated'
        redirect_to casein_customizations_path
      else
        flash.now[:warning] = 'There were problems when trying to update this customization'
        render :action => :show
      end
    end
 
    def destroy
      @customization = Customization.find params[:id]

      @customization.destroy
      flash[:notice] = 'Customization has been deleted'
      redirect_to casein_customizations_path
    end
  
    private
      
      def customization_params
        params.require(:customization).permit(:color, :font)
      end

  end
end
