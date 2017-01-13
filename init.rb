# Write in this file customization code that will get executed before 
# autoproj is loaded.

# Set the path to 'make'
# Autobuild.commands['make'] = '/path/to/ccmake'

# Set the parallel build level (defaults to the number of CPUs)
# Autobuild.parallel_build_level = 10

# Uncomment to initialize the environment variables to default values. This is
# useful to ensure that the build is completely self-contained, but leads to
# miss external dependencies installed in non-standard locations.
#
# set_initial_env
#
# Additionally, you can set up your own custom environment with calls to env_add
# and env_set:
#
# env_add 'PATH', "/path/to/my/tool"
# env_set 'CMAKE_PREFIX_PATH', "/opt/boost;/opt/xerces"
# env_set 'CMAKE_INSTALL_PATH', "/opt/orocos"
#
# NOTE: Variables set like this are exported in the generated 'env.sh' script.
#

require 'mkmf'
require 'autoproj/gitorious'
Autoproj.gitorious_server_configuration('GITHUB', 'github.com', :http_url => 'https://github.com')

Autoproj.gitorious_server_configuration('SPACEGIT', 'git.hb.dfki.de', :fallback_to_http => false, default: 'ssh,ssh', disabled_methods: 'http,git' )
Autoproj.gitorious_server_configuration('DFKIGIT', 'git.hb.dfki.de', :fallback_to_http => false, default: 'ssh,ssh', disabled_methods: 'http,git')

Autoproj.env_inherit 'CMAKE_PREFIX_PATH'

# This option shows the full log output. Please don't activate this on default.
#Autobuild.displayed_error_line_count = 'ALL'

#Purge envirment variable first
env_set 'MONSTER_FRAME_NAMES', ''
    
def add_monster_system(robot_name,filename,package)
    f_name = File.join(Autoproj.root_dir,"install","configuration",filename)
    env_add 'MONSTER_FRAME_NAMES' , "#{robot_name},#{f_name},#{package}"
end

add_monster_system("Spaceclimber","spaceclimber_monster/FramesCombined.xml","limes/spaceclimber_monster")

Autobuild.env_set 'LC_NUMERIC','C'

# work around for base/orogen/types, in flavor stable, since it depends on tools/orogen_metadata, 
# which is only in flavor master currently
Autobuild.env_set 'ROCK_DISABLE_CROSS_FLAVOR_CHECKS', '1'
Autobuild.env_set 'ROCK_FORCE_FLAVOR', 'stable'
castxml = find_executable 'castxml'
if castxml
    Autobuild.env_set 'TYPELIB_CXX_LOADER', 'castxml'
end


# Add robot models paths
env_add 'ASGUARD4', "models/robots/asguard_v4/smurf/asguard_v4.smurf"
env_add 'SPACECLIMBER', "models/robots/spaceclimber/smurf/spaceclimber.smurf"
env_add 'CREX', "models/robots/crex/smurf/crex.smurf"
env_add 'SIMULATED_ROBOT', "models/robots/crex/smurf/crex.smurf"
