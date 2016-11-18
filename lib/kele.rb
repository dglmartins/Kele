require 'httparty'
require 'roadmap'
class Kele
  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @email = email
    options = {
        body: {
          email: @email,
          password: password
        }
    }
    auth_response = self.class.post("/sessions", options)

    @auth_response_body = JSON.parse(auth_response.body)

    pretty = JSON.pretty_generate @auth_response_body
    puts pretty

    @auth_token = @auth_response_body["auth_token"]
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
    @me_response_body = JSON.parse(response.body)
    @my_id = @me_response_body["id"]
    pretty = JSON.pretty_generate @me_response_body
    puts pretty

    @my_mentor_id = @me_response_body["current_enrollment"]["mentor_id"]
    @my_enrollment_id = @me_response_body["current_enrollment"]["id"]
  end

  def get_mentor_availability
    self.get_me
    response = self.class.get("/mentors/#{@my_mentor_id}/student_availability", headers: { "authorization" => @auth_token })

    availability_response_body = JSON.parse(response.body)
    pretty = JSON.pretty_generate availability_response_body
    puts pretty
  end

  def get_messages(page = nil)
    response_array = []
    response = self.class.get("/message_threads", headers: { "authorization" => @auth_token})
    messages_response_body = JSON.parse(response.body)
    count = messages_response_body["count"]
    ceil = (count/10.to_f).ceil
    if page == nil
      (ceil).times do |ciel|
        response = self.class.get("/message_threads", body: {"page": (ciel+1)}, headers: { "authorization" => @auth_token})
        messages_response_body = JSON.parse(response.body)
        response_array[ciel] = messages_response_body
      end
      pretty = JSON.pretty_generate response_array
      puts pretty
    else
      response = self.class.get("/message_threads", body: {"page": page}, headers: { "authorization" => @auth_token})
      messages_response_body = JSON.parse(response.body)
      pretty = JSON.pretty_generate messages_response_body
      puts pretty
    end
  end

  def create_message(token, subject, stripped_text)
    self.get_me
    sender = @email
    recipient_id = @my_mentor_id

    body = {
      "sender": sender,
      "recipient_id": recipient_id,
      "token": token,
      "subject": subject,
      "stripped-text": stripped_text
    }

    response = self.class.post("/messages", body: body, headers: { "authorization" => @auth_token})

    create_message_response_body = JSON.parse(response.body)
    pretty = JSON.pretty_generate create_message_response_body
    puts pretty

  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment)
    self.get_me
    body = {
      "assignment_branch": assignment_branch,
      "assignment_commit_link": assignment_commit_link,
      "checkpoint_id": checkpoint_id,
      "comment": comment,
      "enrollment_id": @my_enrollment_id
    }

    response = self.class.post("/checkpoint_submissions", body: body, headers: { "authorization" => @auth_token})

    submission_response_body = JSON.parse(response.body)
    pretty = JSON.pretty_generate submission_response_body
    puts pretty
  end

  def update_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment)
    self.get_me
    body = {
      "assignment_branch": assignment_branch,
      "assignment_commit_link": assignment_commit_link,
      "checkpoint_id": checkpoint_id,
      "comment": comment,
      "enrollment_id": @my_enrollment_id
    }

    response = self.class.post("/:#{checkpoint_id}", body: body, headers: { "authorization" => @auth_token})

    submission_response_body = JSON.parse(response.body)
    pretty = JSON.pretty_generate submission_response_body
    puts pretty
    #add comment to update checkpoint
  end

end
