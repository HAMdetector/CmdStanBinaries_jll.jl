# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule CmdStanBinaries_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("CmdStanBinaries")
JLLWrappers.@generate_main_file("CmdStanBinaries", UUID("eecc378a-c28e-5a81-8849-a983a4161162"))
end  # module CmdStanBinaries_jll
