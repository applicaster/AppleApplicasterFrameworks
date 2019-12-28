require 'Plist'
require 'json'

class FileToUpdateModel
  def initialize(template_path, original_path)
    # puts("init template path:#{template_path}, original path:#{original_path}")
    @template_path = template_path
    @original_path = original_path
  end

  def get_template_path 
    @template_path
  end

  def get_original_path 
    @original_path
  end
end

task :test do
  frameworks_list = Plist.parse_xml('PodsVersions.plist')
  frameworks_list_automation = read_versions_data()

  items_to_update = []
  new_automation_hash = {}
  frameworks_list.each do |model|

    framework = model["framework"]
    version = model["version_id"]
    base_framework_path = model["folder_path"]

    automation_framework_version = frameworks_list_automation[framework]    
    if automation_framework_version == nil || Gem::Version.new(automation_framework_version) > Gem::Version.new(version)
      if base_framework_path == nil || framework == nil || version == nil
        puts("Unable to add framework to update list, one of keys is empty: #{model}")
      else 
        puts("Adding framework to update list: #{model}")
        items_to_update.push(model)
      end
    end

    new_automation_hash[framework] = version

  end
  puts items_to_update
  puts new_automation_hash

  if items_to_update.length() > 0
    new_git_tag = Time.now.strftime("%Y.%m.%d.%H-%M")
    update_relevant_templates(items_to_update, new_git_tag)
    generate_documentation(items_to_update)
    upload_manifests_to_zapp(items_to_update)
    commit_changes_push_and_tag(new_git_tag)
  end
  save_versions_data(new_automation_hash)
  puts("System update has been finished!")
end


def commit_changes_push_and_tag(items_to_update, new_git_tag)
  sh("git add docs")
  sh("git add Frameworks")
  commit_message = "System update, expected tag:#{new_git_tag} updated frameworks:"
  items_to_update.each do |path|
    framework = model["framework"]
    version = model["version_id"]
    sh("git add #{framework}.podspec")
    commit_message += " #{framework}, ver:#{version}"
  end
  sh("git commit -m #{commit_message}")
  sh("git push origin master")
  sh("git tag #{new_git_tag}")
  sh("git push origin #{new_git_tag}")
end

def generate_documentation(items_to_update) 
  puts("Generating documentation")

  items_to_update.each do |model|
    framework = model["framework"]
    base_framework_path = model["folder_path"]
    puts("Generation documentation for framework:#{framework}")
    sh("cd #{base_framework_path}/Project && jazzy ; cd -")
  end
end

def upload_manifests_to_zapp(items_to_update) {
  puts("Uploading manifests")
  items_to_update.each do |model|
    is_plugin = model["is_plugin"]
    base_framework_path = model["folder_path"]

    if is_plugin == true 
      ios_manifest_path = "#{base_framework_path}/Manifest/ios.json"
      tvos_manifest_path = "#{base_framework_path}/Manifest/tvos.json"

      if File.file?(ios_manifest_path)
        sh("./zappifest publish --manifest #{ios_manifest_path} --access-token #{ENV["ZappToken"]}")
      end
   
      if File.file?(tvos_manifest_path)
        sh("./zappifest publish --manifest #{tvos_manifest_path} --access-token #{ENV["ZappToken"]}")
      end

    end
  end
}

def update_relevant_templates(items_to_update, new_git_tag)
  items_to_update.each do |model|
    framework = model["framework"]
    version = model["version_id"]
    base_framework_path = model["folder_path"]
    is_plugin = model["is_plugin"]
    files_to_update = [
      FileToUpdateModel.new("#{base_framework_path}/templates/template_jazzy.yaml", "#{base_framework_path}/Project/.jazzy.yaml"),
      FileToUpdateModel.new("#{base_framework_path}/templates/template_#{framework}.podspec", "#{framework}.podspec")
    ]
    if is_plugin == true
      ios_manifest_path = "#{base_framework_path}/Manifest/ios.json"
      tvos_manifest_path = "#{base_framework_path}/Manifest/tvos.json"

      if File.file?(ios_manifest_path)
        files_to_update.push(FileToUpdateModel.new("#{base_framework_path}/templates/template_ios.json", "#{base_framework_path}/Manifest/ios.json"))
      end
   
      if File.file?(tvos_manifest_path)
        files_to_update.push(FileToUpdateModel.new("#{base_framework_path}/templates/template_tvos.json", "#{base_framework_path}/Manifest/tvos.json"))
      end

    end
    update_template(files_to_update, framework, version, new_git_tag)
  end
end

def update_template(models_to_update, framework_name , new_version_number, new_git_tag)
  framework_name_wildcard = "__#{framework_name}__"

  models_to_update.each do |model|
    puts(model)
  puts("template path:#{model.get_template_path}, original path:#{model.get_original_path}")
    text = File.read(model.get_template_path)
    new_contents = text.gsub(framework_name_wildcard, new_version_number)
    new_contents = text.gsub('__REPO_TAG__', new_git_tag)

    # To merely print the contents of the file, use:
    puts new_contents
  
    # To write changes to the file, use:
    File.open(model.get_original_path, "w") {|file| file.puts new_contents }
  end
end

def read_versions_data()
  versions_automation_file_name = ".versions_automation.json"

  if File.exists?(versions_automation_file_name)
    JSON.parse(File.read(versions_automation_file_name), :symbolize_names => false)
  else
    {}
  end
end

def save_versions_data(data)
  versions_automation_file_name = ".versions_automation.json"
  hash = { "anton" => "foo"}
  Dir.mkdir(versions_automation_file_name) unless File.exists?(versions_automation_file_name)
  File.open(versions_automation_file_name,"w") do |f|
     f.write(data.to_json)
  end
end