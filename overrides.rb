# Write in this file customization code that will get executed after all the
# soures have beenloaded.

# Uncomment to reenable building the RTT test suite
# This is disabled by default as it requires a lot of time and memory
#
# Autobuild::Package['rtt'].define "BUILD_TESTING", "ON"

# Package specific prefix:
# Autobuild::Package['rtt'].prefix='/opt/autoproj/2.0'
#
# See config.yml to set the prefix:/opt/autoproj/2.0 globally for all packages.


#Autoproj.add_osdeps_overrides 'slam/pcl', :package => 'slam/pcl', :force => true


if Autoproj.respond_to?(:post_import)
    # Override the CMAKE_BUILD_TYPE if no tag is set
    Autoproj.post_import do |pkg|
        name = pkg.name

        if(!pkg.kind_of?(Autobuild::CMake))
            next
        end

#        pkg.define "ROCK_USE_CXX11", "TRUE"
        #external packages do not understand ROCK_USE_CXX11, use CMAKE_CXX_FLAGS instead
#        if( name =~ /external\/*/)
#            if(!pkg.defines['CMAKE_CXX_FLAGS'])
#                print("CXX FLAGS #{pkg.name} #{pkg.defines['CMAKE_CXX_FLAGS']}\n")
#                pkg.define "CMAKE_CXX_FLAGS", "-std=c++11"
#            end
#        end
        #mars packages also do not understand ROCK_USE_CXX11
#        if( name =~ /simulation\/entity_generation\/*/)
#            pkg.define "CMAKE_CXX_FLAGS", "-std=c++11 #{pkg.defines['CMAKE_CXX_FLAGS']}"
#        end

        #only touch the build type, if no tag was set
        # FIXME Apparently, this is broken sometimes, so we are ignore this for now
        # if(!pkg.tags.empty?)
        #     next
        # end

        buildType = "RelWithDebInfo"

        if( pkg.has_tag?('stable') or
            name =~ /external\/*/ or 
#            name =~ /tools\/*/ or
            name =~ /base\/*/ or
            name =~ /ndlcom\/*/ or
            name =~ /slam\/(pcl|g2o)\/*/)
            buildType = "Release"
        end

        pkg.define "CMAKE_BUILD_TYPE", buildType


    end
end

#build mars as Release, if the build type is not already defined
#Autobuild::Package.each do |name, pkg|
#    if name =~ /simulation\/*/ and pkg.kind_of?(Autobuild::CMake) and !pkg.defines.has_key?('CMAKE_BUILD_TYPE')
#        pkg.define "CMAKE_BUILD_TYPE", "Release"
#        #disable assertions
#        #pkg.define "CMAKE_CXX_FLAGS_INIT", "-DNDEBUG"
#    end
#end 

Autobuild::Package.each do |name, pkg|
    if pkg.kind_of?(Autobuild::CMake)
        cxx_flags = "#{pkg.defines['CMAKE_CXX_FLAGS']} #{ENV['CXXFLAGS']}"
        if cxx_flags !~ /-std=c\+\+11/
            pkg.define "CMAKE_CXX_FLAGS", "#{cxx_flags} -std=c++11"
        end
#    else
#        cxx_flags = ENV['CXXFLAGS']
#        if cxx_flags !~ /-std=c\+\+11/
#            ENV['CXXFLAGS'] = "#{cxx_flags} -std=c++11"
#        end
    end
end 

#if( name =~ /simulation\/entity_generation\/*/)
#    pkg.define "CMAKE_CXX_FLAGS", "-std=c++11 #{pkg.defines['CMAKE_CXX_FLAGS']}"
#end



#Autobuild::Package['tools/logger'].define "CMAKE_CXX_FLAGS", "-std=c++11"
