require 'Plist'
require 'json'

class FileToUpdateModel
  def initialize(template_path, original_path)
    puts("init template path:#{template_path}, original path:#{original_path}")
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

  item_to_update = []
  new_automation_hash = {}
  frameworks_list.each do |model|
    framework = model["framework"]
    version = model["version_id"]
    automation_framework_version = frameworks_list_automation[framework]    
    if automation_framework_version == nil || Gem::Version.new(automation_framework_version) > Gem::Version.new(version)
      puts("Adding framework to update list: #{model}")
      item_to_update.push(model)
    end

    new_automation_hash[framework] = version

    # puts foo
    # puts version
  end
  puts item_to_update
  puts new_automation_hash



  # save_versions_data(new_automation_hash)
end

task :update_relevant_templates do


  
framework_name = "ZappGoogleInteractiveMediaAds"

version_number = "1.3.4"


base_framework_path = "Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds"

models_to_update = [
  FileToUpdateModel.new("#{base_framework_path}/templates/template_ios.json", "#{base_framework_path}/Manifest/ios.json"),
  FileToUpdateModel.new("#{base_framework_path}/templates/template_tvos.json", "#{base_framework_path}/Manifest/tvos.json"),
  FileToUpdateModel.new("#{base_framework_path}/templates/template_jazzy.yaml", "#{base_framework_path}/Project/.jazzy.yaml"),
  FileToUpdateModel.new("#{base_framework_path}/templates/template_#{framework_name}.podspec", "#{framework_name}.podspec")
]

update_template(models_to_update, framework_name, version_number, "2")
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

def commit_changes_push_and_tag(item_pathes_to_add, new_git_tag)
  sh("git add docs")

  item_pathes_to_add.each do |path|
    sh("git add #{path}")
  end
  sh("git add #{path}")
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