require 'httparty'
class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @options = {
        body: {
          email: email,
          password: password
        }
    }

  end

  def get_auth_token
    @response = self.class.post("/sessions", @options)
    puts @response
  end

end
