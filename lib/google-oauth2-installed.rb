require 'google-oauth2-installed/version'
require 'google-oauth2-installed/setup'
require 'google-oauth2-installed/checks'
require 'google-oauth2-installed/access_token'

module GoogleOauth2Installed

  # A centralized place to access all loaded configuration and defaults.
  def self.credentials(user_account="")
    {
      method: 'OAuth2',
      oauth2_client_id: oauth2_client_id(user_account),
      oauth2_client_secret: oauth2_client_secret(user_account),
      oauth2_token: oauth2_token(user_account),
      oauth2_scope: oauth2_scope(user_account),
      oauth2_redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
      oauth2_urls: {
        authorize_url: 'https://accounts.google.com/o/oauth2/auth',
        token_url: 'https://accounts.google.com/o/oauth2/token',
      },
    }
  end

  def self.access_token(user_account="")
    user_account = "_#{user_account}" unless user_account.blank?
    creds = credentials(user_account)
    AccessToken.new(creds).access_token
  end

  # To be used interactively
  def self.get_access_token
    Setup.new(credentials).get_access_token
  end

  private

  def oauth2_client_id(user_account)
    ENV["OAUTH2_CLIENT_ID#{user_account}"]
  end

  def oauth2_client_secret(user_account)
    ENV["OAUTH2_CLIENT_SECRET#{user_account}"]
  end

  def oauth2_scope(user_account)
    ENV["OAUTH2_SCOPE#{user_account}"]
  end

  def self.oauth2_token(user_account)
    if ENV["OAUTH2_ACCESS_TOKEN#{user_account}"]
      {
        access_token: ENV["OAUTH2_ACCESS_TOKEN#{user_account}"],
        refresh_token: ENV["OAUTH2_REFRESH_TOKEN#{user_account}"],
        expires_at: ENV["OAUTH2_EXPIRES_AT#{user_account}"].to_i,
      }
    end
  end

end


require 'google-oauth2-installed/railtie' if defined?(Rails::Railtie)
