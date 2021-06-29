# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "CmdStanBinaries"
version = v"0.1.0"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://github.com/stan-dev/cmdstan/releases/download/v2.27.0/cmdstan-2.27.0.tar.gz", "ff71f4d255cf26c2d8366a8173402656a659399468871305056aa3d56329c1d5")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd cmdstan-2.27.0/
echo 'CXX=c++' >> make/local
echo 'TBB_CXX_TYPE=c++' >> make/local
echo 'STAN_THREADS=true' >> make/local
cd stan/lib/stan_math/lib/tbb_2020.3/build/
cp linux.inc x86_64-linux-gnu.inc
cp linux.gcc.inc x86_64-linux-gnu.c++.inc
cd ../../../../../..
make build
mkdir ${bindir}
mkdir ${libdir}

cp bin/stanc ${bindir}/stanc
cp bin/diagnose ${bindir}/diagnose
cp bin/print ${bindir}/print
cp bin/stansummary ${bindir}/stansummary

exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Platform("x86_64", "linux"; libc = "glibc")
]


# The products that we will ensure are always built
products = [
    ExecutableProduct("stanc", :stanc),
    ExecutableProduct("stansummary", :stansummary),
    ExecutableProduct("print", :print_deprecated),
    ExecutableProduct("diagnose", :diagnose)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", preferred_gcc_version = v"5.2.0")
