class ApplicationController < ActionController::Base
  include Pagy::Backend
  around_action :switch_locale

  def switch_locale(&)
    I18n.with_locale(locale_from_header, &)
  end

  private

  def locale_from_header
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
  end
end
