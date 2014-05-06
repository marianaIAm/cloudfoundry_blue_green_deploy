
class CloudFoundryFake
  def self.init_route_table(domain, web_app_name, hot_url, current_hot_color)
    @@web_app_name = web_app_name
    @@current_hot_color = current_hot_color
    @@hot_url = hot_url
    @@cf_route_table = [
      Route.new("#{web_app_name}-blue", domain, "#{web_app_name}-blue"),
      Route.new("#{web_app_name}-green", domain, "#{web_app_name}-green"),
      Route.new(hot_url, domain, "#{web_app_name}-#{current_hot_color}")
    ]
  end

  def self.init_app_list_with_workers_for(app_name)
    @@cf_app_list = [
      App.new(name: "#{app_name}-worker-green", state: 'stopped'),
      App.new(name: "#{app_name}-worker-blue", state: 'stopped')
    ]
  end

  def self.init_app_list(apps)
    @@cf_app_list = apps
  end

  # App List Helpers

  def self.replace_app(new_app)
    app_index = @@cf_app_list.find_index { |existing_app| existing_app.name == new_app.name }
    @@cf_app_list[app_index] = new_app
  end

  def self.apps
    @@cf_app_list
  end

  # Route Table Helpers
  def self.find_route(host)
    @@cf_route_table.find { |route| route.host == host }
  end

  def self.add_route(route)
    @@cf_route_table << route
  end

  def self.remove_route(host)
    @@cf_route_table.delete_if { |route| route.host == host }
  end

  # CloudFoundry fakes
  def self.push(app)
  end

  def self.stop(app)
  end

  def self.routes
    @@cf_route_table
  end

  def self.unmap_route(app, domain, host)
    @@cf_route_table.delete_if { |route| route.app == "#{@@web_app_name}-#{@@current_hot_color}" && route.host == @@hot_url }
  end

  def self.map_route(app, domain, host)
    @@cf_route_table.delete_if { |route| route.host == host }
    @@cf_route_table.push(Route.new(host, domain, app))
  end

end
