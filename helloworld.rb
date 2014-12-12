# Hello World docker images
@docker.merge!({
  :app           => "carlpulley/#{@application_name}:v0.1.0-SNAPSHOT"
})

# Hello World service templates
@service_templates = @service_templates + [
  "#{@application_name}/app@.service"
]

# Domain from which load balancer accepts REST API requests
@domain = "127.0.0.1"
