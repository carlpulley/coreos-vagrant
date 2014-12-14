# Lift docker images
@docker.merge!({
  :exercise     => "carlpulley/#{@application_name}:lift-exercise",
  :notification => "carlpulley/#{@application_name}:lift-notification",
  :profile      => "carlpulley/#{@application_name}:lift-profile"
})

# Lift service templates (sidekicks are inferred by naming convention)
@service_templates = @service_templates + [
  "#{@application_name}/exercise@.service",
  "#{@application_name}/notification@.service",
  "#{@application_name}/profile@.service"
]

# Domain from which load balancer accepts REST API requests
@domain = "#{@application_name}.eigengo.com"
