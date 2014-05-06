require File.join(File.dirname(__FILE__), '.', 'blue_green_deploy')

namespace :cf do
  desc 'Only run on the first application instance'
  task :on_first_instance do
    instance_index = JSON.parse(ENV['VCAP_APPLICATION'])['instance_index'] rescue nil
    exit(0) unless instance_index == 0
  end

  desc 'Reroutes "live" traffic to specified app through provided URL'
  task :blue_green_deploy, :web_app_name do |t, args|
    web_app_name = args[:web_app_name]
    worker_app_names = args.extras.to_a
    target_color = worker_app_names.pop if args.extras.last == 'blue' || args.extras.last == 'green'

    deploy_config = BlueGreenDeployConfig.new(load_manifest, web_app_name, worker_app_names, target_color)
    BlueGreenDeploy.make_it_so(web_app_name, worker_app_names, deploy_config)
  end

  def load_manifest
    YAML.load_file('manifest.yml')
  end
end
