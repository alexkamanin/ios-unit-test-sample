require 'xcodeproj'

projectPath = ARGV[0]
targetName = ARGV[1]
groupPath = ARGV[2]
fileName = ARGV[3]

def addFilesToGroup(aTarget, aGroup)
    Dir.foreach(aGroup.real_path) do |entry|
        filePath = File.join(aGroup.real_path, entry)
        if entry != ".DS_Store" && !filePath.to_s.end_with?(".meta") && entry != "." && entry != ".." then
            fileReference = aGroup.new_reference(filePath)
            aTarget.source_build_phase.add_file_reference(fileReference, true)
        end
    end
end

project = Xcodeproj::Project.open(projectPath)
target = project.targets.find { |target| target.name == targetName }

group = project.main_group.find_subpath(groupPath, true)
group.set_source_tree('<group>')
relativePath = '../' + groupPath.split('/').drop(1).join('/')
group.set_path(relativePath)

addFilesToGroup(target, group)

project.save