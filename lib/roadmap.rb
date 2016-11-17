module Roadmap

  def get_roadmap(roadmap_id)
    response = self.class.get("/roadmaps/#{roadmap_id}", headers: { "authorization" => @auth_token })

    roadmap_response_body = JSON.parse(response.body)
    puts roadmap_response_body
  end

  def get_checkpoint(checkpoint_id)
    #not authorized for checkpoints?
    response = self.class.get("/checkpoints/#{checkpoint_id}", headers: { "authorization" => @auth_token })
    checkpoint_response_body = JSON.parse(response.body)
    puts checkpoint_response_body
  end
end
