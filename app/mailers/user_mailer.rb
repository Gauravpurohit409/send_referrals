class UserMailer < ApplicationMailer

    # include Devise::Controllers::UrlHelpers
    def new_user_invite_email(new_user, inviter, invitation_token)
        @user = new_user
        @inviter  = inviter
        @url = "http://localhost:3001/acceptInvitation?invitation_token=#{invitation_token}&email=#{@user.email}"
        mail(from: @inviter.email, to: @user.email, subject: "join new platform")
    end
end
