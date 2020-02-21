class Wrfhydro < Formula
  desc "WRF-Hydro model code"
  homepage "https://ral.ucar.edu/projects/wrf_hydro"
  url "https://github.com/NCAR/wrf_hydro_nwm_public/archive/v5.1.2.tar.gz"
  sha256 "203043916c94c597dd4204033715d0b2dc7907e2168cbe3dfef3cd9eef950eb7"
  head "https://github.com/NCAR/wrf_hydro_nwm_public.git"
  version "v5.1.2"
  revision 1

  depends_on "gcc"
  depends_on "netcdf"
  depends_on "openmpi"

  # handle options
  
  option "with-debug", "Build with HYDRO_D debugging statements"
  option "with-nudging", "Build with streamflow nudging support"
  option "without-spatial-soil", "Build without spatial soil support"
  option "without-large-file-support", "Build without support for large (>2GB) netCDF files"  
  
  def install
    ENV.deparallelize

    ENV.append "WRF_HYDRO", "1"
    ENV.append "RESERVOIR_D", "0"
    ENV.append "WRF_HYDRO_RAPID", "0"
    ENV.append "NCEP_WCOSS", "0"

    
    ohai "The following environment variables will be used in the compile:"

    ENV.append "HYDRO_D", (build.with? "debug") ? "1" : "0"
    ohai "  HYDRO_D = #{ENV['HYDRO_D']}"

    ENV.append "SPATIAL_SOIL", (build.with? "spatial-soil") ? "1" : "0"
    ohai "  SPATIAL_SOIL = #{ENV['SPATIAL_SOIL']}"

    ENV.append "WRF_HYDRO_NUDGING", (build.with? "nudging") ? "1" : "0"
    ohai "  WRF_HYDRO_NUDGING = #{ENV['WRF_HYDRO_NUDGING']}"

    Dir.chdir('trunk/NDHMS')
    system "./configure", "2"
    system "./compile_offline_NoahMP.sh"
    prefix.install Dir["Run"]
    bin.install_symlink "#{prefix}/Run/wrf_hydro.exe"
  end
  
  def caveats 
    message = <<-EOS
    The NoahMP-based standalone version of the WRF-Hydro Modeling system is
    installed as `wrf_hydro.exe`. 

    To run the model, you will need table files, runtime namelists, and domain files.
    Table files and sample namelists are installed into:
         
         #{prefix}/Run/ 
         
    but domain files must be generated or acquired elsewhere.
    
    Please see #{homepage} for more information.
    EOS
    message
  end  

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test wrfhydro`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
