#!/usr/bin/ruby
require 'erb'
require 'ostruct'

class String
def red;            "\033[31m#{self}\033[0m" end
def green;          "\033[32m#{self}\033[0m" end
end

def retrivePaths
    puts
    puts "Please enter project directory".green
    projectDirectory = gets.strip
    fileListToCheck = Dir.children("#{projectDirectory}")
    if fileListToCheck.include?('Assets.xcassets')
        puts
        puts "Please enter directory to create assets folder.".green
        assetsDirectory = gets.strip
        puts
        puts "Should public? [Y/N]"
        shouldPublic = gets.strip
        puts
        
        files = Dir.children("#{projectDirectory}/Assets.xcassets")
        if files.empty?
            puts "There is no colors!".red
        else
            colorArray = Array.new
            imageArray = Array.new
            files.each do |file|
                splittedFile = file.split(".")
                if splittedFile.include?('colorset')
                    colorArray.push(splittedFile[0])
                elsif splittedFile.include?('imageset')
                    imageArray.push(splittedFile[0])
                end
            end
            
            if !colorArray.empty? || !imageArray.empty?
                dirname = Dir.pwd
            
                parameters = OpenStruct.new(isPublic: shouldPublic.downcase.eql?("y"), colorList: colorArray, imageList: imageArray)
            
                template = File.read("#{dirname}/AssetsExtension.swift")
                result = ERB.new(template).result(parameters.instance_eval { binding })
                                                
                File.open("#{assetsDirectory}/AssetsExtension.swift", 'w') { |f| f.write(result) }
                
                puts "Assets successfuly created!!".green
            else
                puts "There is nothing to create.".red
            end
        end
    else
        puts "Please be sure that directory has Assets.xcassets file.".red
    end
end
retrivePaths
