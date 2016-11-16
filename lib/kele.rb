class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @values = "{
      'email': #{email}, 'password': #{password}
    }"
  end

  def get_auth_token
    @response = self.class.post("/sessions", @values)
    puts @response
  end

end
