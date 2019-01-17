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
      oauth2_redirect_uri: redirect_uri(account_no),
      oauth2_urls: {
        authorize_url: 'https://accounts.google.com/o/oauth2/auth',
        token_url: 'https://accounts.google.com/o/oauth2/token',
      },
    }
  end

  def self.access_token(account_no = "")
    creds = credentials(formatted_acc_no(account_no))
    AccessToken.new(creds).access_token
  end

  # To be used interactively
  def self.get_access_token(account_no = "")
    acc_no = formatted_acc_no(account_no)
    creds  = credentials(acc_no)
    Setup.new(creds, acc_no).get_access_token
  end

  private

  def self.formatted_acc_no(acc_no)
    return acc_no if acc_no.strip == ""
    "_#{acc_no}"
  end

  def self.redirect_uri(acc_no)
   get("OAUTH2_REDIRECT_URI#{acc_no}") || 'urn:ietf:wg:oauth:2.0:oob'
  end

  def self.oauth2_client_id(acc_no)
    get "OAUTH2_CLIENT_ID#{acc_no}"
  end

  def self.oauth2_client_secret(acc_no)
    get "OAUTH2_CLIENT_SECRET#{acc_no}"
  end

  def self.oauth2_scope(acc_no)
    get "OAUTH2_SCOPE#{acc_no}"
  end

  def self.oauth2_token(acc_no)
    if get "OAUTH2_ACCESS_TOKEN#{account_no}"
      {
        access_token: get("OAUTH2_ACCESS_TOKEN#{acc_no}"),
        refresh_token: ge("OAUTH2_REFRESH_TOKEN#{acc_no}"),
        expires_at: get("OAUTH2_EXPIRES_AT#{acc_no}").to_i,
      }
    end
  end

  def get(key)
    value = ENV[key]
    return value if value
    puts "#{key} not found in ENV"
  end
end

require 'google-oauth2-installed/railtie' if defined?(Rails::Railtie)
