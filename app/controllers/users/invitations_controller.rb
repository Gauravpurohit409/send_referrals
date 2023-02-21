class Users::InvitationsController < Devise::InvitationsController
    
    # GET /api/users/invitation/accept?invitation_token=
    def edit
        user = User.find_by_invitation_token(params[:invitation_token], true)
        byebug
        if user
            redirect_to "http://localhost:3000/api/users?invitation_token=#{params[:invitation_token]}&email=#{user.email}"
        else
            redirect_to "http://localhost::3000/signup"
        end
    end

    # PATCH  /api/users/invitation
    def update
        user = nil
        ActiveRecord::Base.transaction{ user = User.accept_invitation!(user_params)}

        # NOTE: Facing "Wrong number of arguments given" issue while rendering json 
        # so rendered in plain text
        if user.errors.empty?
            user.save!
            render plain: "Password Updated successfully", status: :accepted
        else
            render plain: "Invalid token", status: :unprocessable_entity
        end
    end

    protected

    def user_params
        params.require(:user).permit(:password, :password_confirmation, :invitation_token)
    end
end