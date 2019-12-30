require 'Plist'
require 'json'

task :validate_framework, [:framework_to_check] do |t, args|
  frameworks_list = Plist.parse_xml('frameworksData.plist')
  framework_to_check = args[:framework_to_check]
  puts("\nChecking Framework '#{framework_to_check}'")
  is_framework_defined_in_plist = false
  is_all_pathes_valid = false

  framework = nil
  version = nil
  base_framework_path = nil
  is_plugin = nil
  
  frameworks_list.each do |model|
    if model["framework"] == nil 
      puts("ERROR: Argument 'framework' did not provided in plist")
    elsif model["framework"] == framework_to_check 
      framework = model["framework"]
      if model["version_id"] == nil 
        puts("ERROR: Argument 'version_id' did not provided in plist")
      end

      if model["folder_path"] == nil 
        puts("ERROR: Argument 'folder_path' did not provided in plist")
      end

      if model["is_plugin"] == nil 
        puts("ERROR: Argument 'is_plugin' did not provided in plist")
      end

      if model["version_id"] != nil && model["folder_path"] != nil && model["is_plugin"] != nil
        is_framework_defined_in_plist = true
        version =  model["version_id"]
        base_framework_path = model["folder_path"]
        is_plugin = model["is_plugin"]
      end
    end
  end
  if is_framework_defined_in_plist == false 
    puts("\nPlease define your framework in 'FrameworksData.plist'")
    puts("Mandatory keys: {framework:'MyFramework', version:'1.0.0', folder_path:'Frameworks/MyFramework, is_plugin:false'}")
    puts("\nKey:'framework' - Name of the framework")
    puts("Key:'version' - Version of the framework")
    puts("Key:'folder_path' - Base path to the framework. Example: `Frameworks/Plugins/Analytics/GoogleAnalytics`")
    puts("Key:'is_plugin' - Define if framework is a plugin. Value true inform publisher task that this plugin has manifests and need to be uploaded to Zapp")
  else
    puts("Framework: '#{framework_to_check}' all keys was defined in 'FrameworksData.plist'")
    files_not_defined = false
    if File.exist?(base_framework_path) == false
      puts("Error: Framework does not exist in defined path: #{base_framework_path}")
      files_not_defined = true
    end

    if File.file?("#{base_framework_path}/Templates/template_jazzy.yaml") == false
      puts("Error: 'template_jazzy.yaml' template yaml does not exist in required path: '#{base_framework_path}/Templates/template_jazzy.yaml'")
      files_not_defined = true
    end

    if File.file?("#{base_framework_path}/Templates/template_#{framework_to_check}.podspec") == false
      puts("Error: 'template_#{framework_to_check}.podspec' does not exist in required path: '#{base_framework_path}/Templates/template_#{framework_to_check}.podspec'")
      files_not_defined = true
    end

    if is_plugin
      if File.file?("#{base_framework_path}/Templates/template_ios.json") == false && File.file?("#{base_framework_path}/Templates/template_tvos.json") == false 
        puts("Error: Plugin must has at least one manifest for iOS or tvOS")
        puts("Expected pathes ios: #{base_framework_path}/Templates/template_ios.json\ntvos:#{base_framework_path}/Templates/template_tvos.json")
        files_not_defined = true
      end
  
      if File.file?("#{base_framework_path}/Manifest/ios.json") == false && File.file?("#{base_framework_path}/Manifest/tvos.json") == false
        puts("Error: Plugin must has at least one manifest for iOS or tvOS")
        puts("Expected pathes:\nios: #{base_framework_path}/Manifest/ios.json\ntvos:#{base_framework_path}/Manifest/tvos.json")
        files_not_defined = true
      end
    end

    if File.file?("#{framework_to_check}.podspec") == false
      puts("Error: '#{framework_to_check}.podspec' does not exist in required path: './#{framework_to_check}.podspec'")
      files_not_defined = true
    end

    if File.file?("#{base_framework_path}/Project/.jazzy.yaml") == false
      puts("Error: '.jazzy.yaml' does not exist in required path: '#{base_framework_path}/Project/.jazzy.yaml'")
      files_not_defined = true
    end
    
    if File.file?("#{base_framework_path}/Project/README.md") == false
      puts("Error: 'README.md' does not exist in required path: '#{base_framework_path}/Project/README.md'")
      files_not_defined = true
    end

    if File.exist?("#{base_framework_path}/Files") == false
      puts("Error: Folder does not exist required path: #{base_framework_path}")
      files_not_defined = true
    end

    if files_not_defined == false 
      is_all_pathes_valid = true
      puts("All required files exist for framework: #{framework_to_check}")
    end
  end

  if is_framework_defined_in_plist && is_all_pathes_valid
    puts("\n'#{framework_to_check}' is Valid")
  elsif
    abort("\nError: '#{framework_to_check}' Validation failed")
  end
  
end

task :validate_existing_frameworks do
  if ENV["CIRCLE_BRANCH"] != "master"
    frameworks_list = Plist.parse_xml('frameworksData.plist')
    frameworks_list.each do |model|
      if model["framework"] != nil
          Rake::Task["validate_framework"].reenable
        Rake::Task["validate_framework"].invoke(model["framework"])
      end
    end
  end
end
