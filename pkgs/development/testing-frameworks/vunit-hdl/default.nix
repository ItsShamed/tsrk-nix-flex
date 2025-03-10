{ python3Packages, lib }:

python3Packages.buildPythonPackage rec {
  pname = "vunit_hdl";
  version = "4.6.0";
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [ colorama ];

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "b405a97b5da4c26c99d8c726f38594c9173c0ac3f8a0832431c8e4920d2cacdf";
  };

  meta = with lib; {
    homepage = "https://vunit.github.io/";
    description =
      "VUnit is an open source unit testing framework for VHDL/SystemVerilog";
    license = licenses.mpl20;
  };
}
