require 'google-oauth2-installed/version'
require 'google-oauth2-installed/setup'
require 'google-oauth2-installed/checks'
require 'google-oauth2-installed/access_token'

module GoogleOauth2Installed

  # A centralized place to access all loaded configuration and defaults.
  def self.credentials(account_no="")
    {
      method: 'OAuth2',
      oauth2_client_id: oauth2_client_id(account_no),
      oauth2_client_secret: oauth2_client_secret(account_no),
      oauth2_token: oauth2_token(account_no),
      oauth2_scope: oauth2_scope(account_no),
      oauth2_redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
      oauth2_urls: {
        authorize_url: 'https://accounts.google.com/o/oauth2/auth',
        token_url: 'https://accounts.google.com/o/oauth2/token',
      },
    }
  end

  def self.access_token(account_no="")
    account_no = "_#{account_no}" unless account_no.blank?
    creds = credentials(account_no)
    AccessToken.new(creds).access_token
  end

  # To be used interactively
  def self.get_access_token(account_no="")
    account_no = "_#{account_no}" unless account_no.blank?
    creds = credentials(account_no)
    Setup.new(credentials).get_access_token
  end

  private

  def self.oauth2_client_id(account_no)
    ENV["OAUTH2_CLIENT_ID#{account_no}"]
  end

  def self.oauth2_client_secret(account_no)
    ENV["OAUTH2_CLIENT_SECRET#{account_no}"]
  end

  def self.oauth2_scope(account_no)
    ENV["OAUTH2_SCOPE#{account_no}"]
  end

  def self.oauth2_token(account_no)
    if ENV["OAUTH2_ACCESS_TOKEN#{account_no}"]
      {
        access_token: ENV["OAUTH2_ACCESS_TOKEN#{account_no}"],
        refresh_token: ENV["OAUTH2_REFRESH_TOKEN#{account_no}"],
        expires_at: ENV["OAUTH2_EXPIRES_AT#{account_no}"].to_i,
      }
    end
  end

end


require 'google-oauth2-installed/railtie' if defined?(Rails::Railtie)
