class ReferralsController < ApplicationController
  before_action :authenticate_user!
  
   # GET /api/referrals
    def show
      referrals = User.where(invited_by_id: current_user.id)
      render json: referrals, each_serializer: UserSerializer, status: :ok

      # render json: UserSerializer.new(referrals), status: :ok
    end

    # GET /api/referrals/send_invite
    def send_invite
      # NOTE: As of now 2 emails will be sent to new_user one to confirm user's email
      # and other invitation mail which contains password setting link
      new_user = User.find_by(email: params[:new_user_email].downcase)
      if new_user
        render json: {success: false, message: "User is already invited"}, status: :bad_request
      else
        new_user = User.create(email: params[:new_user_email], password: "DummyPassword@123")  
        if new_user.errors.present?
          render json: {success: false, message: new_user.errors.messages}, status: :bad_request 
        else
          new_user.invite!(current_user){|u| u.skip_invitation = true} # create raw invitation token
          UserMailer.new_user_invite_email(new_user, current_user, new_user.raw_invitation_token).deliver_now
          render json: {success: true, message: "Invitation Sent Successfully"}, status: :ok
        end
      end
    end
end
