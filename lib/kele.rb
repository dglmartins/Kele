require 'httparty'
class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    options = {
        body: {
          email: email,
          password: password
        }
    }
    auth_response = self.class.post("/sessions", options)

    @auth_response_body = JSON.parse(auth_response.body)

    @auth_token = @auth_response_body["auth_token"]
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token})
    @me_response_body = JSON.parse(response.body)
    @my_id = @me_response_body["id"]

    @my_mentor_id = @me_response_body["current_enrollment"]["mentor_id"]
  end

  def get_mentor_availability
    self.get_me
    response = self.class.get("/mentors/#{@my_mentor_id}/student_availability", headers: { "authorization" => @auth_token})

    @availability_response_body = JSON.parse(response.body)
    puts @availability_response_body
  end


end
