
namespace :googleoauth2installed do
  desc "Get an access token suitable for ongoing application use"
  task :get_access_token, [:account_no] => [:environment] do |task, args|
    # rake googleoauth2installed:get_access_token[2]
    require 'google-oauth2-installed'
    GoogleOauth2Installed.get_access_token(args[:account_no])
  end
end
