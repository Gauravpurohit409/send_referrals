# frozen_string_literal: true

class ConfirmationsController < DeviseTokenAuth::ApplicationController
  respond_to :json

  def show
    @resource = resource_class.confirm_by_token(resource_params[:confirmation_token])
    if @resource.errors.empty?
      render json: { message: 'Your account has been confirmed successfully.' }, status: :ok
    else
      render json: { errors: @resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    byebug
    return render_create_error_missing_email if resource_params[:email].blank?

    @email = get_case_insensitive_field_from_resource_params(:email)

    @resource = resource_class.dta_find_by(uid: @email, provider: provider)

    return render_not_found_error unless @resource

    @resource.send_confirmation_instructions({
      redirect_url: redirect_url,
      client_config: resource_params[:config_name]
    })

    return render_create_success
  end

  protected

  def render_create_error_missing_email
    render_error(401, I18n.t('devise_token_auth.confirmations.missing_email'))
  end

  def render_create_success
    render json: {
              success: true,
              message: success_message('confirmations', @email)
            }
  end

  def render_not_found_error
    if Devise.paranoid
      render_create_success
    else
      render_error(404, I18n.t('devise_token_auth.confirmations.user_not_found', email: @email))
    end
  end

  private

  def resource_params
    params.permit(:email, :confirmation_token, :config_name)
  end

  # give redirect value from params priority or fall back to default value if provided
  def redirect_url
    params.fetch(
      :redirect_url,
      DeviseTokenAuth.default_confirm_success_url
    )
  end

end