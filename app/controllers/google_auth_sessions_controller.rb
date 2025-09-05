class GoogleAuthSessionsController < ApplicationController
  def create
    user = find_or_create_user

    reset_session
    session[:user_id] = user.id

    redirect_to "/"
  end

  private

  def auth_hash = request.env["omniauth.auth"]

  def google_uid = auth_hash["uid"]

  def find_or_create_user
    GoogleAuthenticatedUser.transaction do
      google_authenticated_user = GoogleAuthenticatedUser.find_by(uid: google_uid)
      if google_authenticated_user.present?
        google_authenticated_user.user
      else
        User.create! do |user|
          GoogleAuthenticatedUser.create!(user:, uid: google_uid)
        end
      end
    end
  end
end
