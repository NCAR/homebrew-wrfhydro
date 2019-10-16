# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Wrfhydro < Formula
  desc "WRF-Hydro model code"
  homepage "https://ral.ucar.edu/projects/wrf_hydro"
  #url "https://github.com/NCAR/wrf_hydro_nwm_public/archive/v5.1.1-beta.tar.gz"
  url "https://github.com/NCAR/wrf_hydro_nwm_public.git"
  sha256 "07e327e04c545a4ddd227fe9f4c89efe9f04a0b13217c158beeb5e5fe18dfbb6"
  #head "https://github.com/NCAR/wrf_hydro_nwm_public.git"

  depends_on "gcc"
  depends_on "netcdf"
  depends_on "open-mpi"

  def install
    ENV.deparallelize

    ENV.append "WRF_HYDRO", "1"
    ENV.append "HYDRO_D", "0"
    ENV.append "RESERVOIR_D", "0"
    ENV.append "SPATIAL_SOIL", "1"
    ENV.append "WRF_HYDRO_RAPID", "0"
    ENV.append "WRFIO_NCD_LARGE_FILE_SUPPORT", "1"
    ENV.append "NCEP_WCOSS", "0"
    ENV.append "WRF_HYDRO_NUDGING", "0"

    Dir.chdir('trunk/NDHMS')
    system "./configure", "2"
    system "./compile_offline_NoahMP.sh"
    cp "Run/wrf_hydro_NoahMP.exe", "wrf_hydro.exe"
    bin.install "wrf_hydro.exe"
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
