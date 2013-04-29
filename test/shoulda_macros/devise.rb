module Devise
  module Shoulda

    def signed_in_admin_context(&blk)
      context "A signed in as Admin" do
        setup do
          sign_in(:admin, FactoryGirl.create(:admin))
        end
        merge_block(&blk)
      end
    end

    def signed_in_user_context(&blk)
      context "A signed in as User" do
        setup do
          @__user = FactoryGirl.create(:user)
          sign_in(:user, @__user)
        end
        merge_block(&blk)
      end
    end

    def should_deny_access(options = {})
      if options[:flash]
        should set_the_flash.to options[:flash]
      else
        should_not set_the_flash
      end

      should redirect_to("sign in page") { new_admin_session_path }
    end

    def should_user_deny_access(options = {})
      if options[:flash]
        should set_the_flash.to options[:flash]
      else
        should_not set_the_flash
      end

      should redirect_to("sign in page") { new_user_session_path }
    end
    
  end
end
