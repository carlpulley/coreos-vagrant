# Hello World docker images
@docker.merge!({
  :app           => "carlpulley/#{@application_name}:v0.1.0-SNAPSHOT"
})

# Hello World service templates (sidekicks are inferred by naming convention)
@service_templates = @service_templates + [
  "#{@application_name}/app@.service"
]

# Domain from which load balancer accepts REST API requests
@domain = "#{@application_name}.cakesolutions.net"
