{ python3Packages, lib }:

python3Packages.buildPythonPackage rec {
  pname = "vunit_hdl";
  version = "4.7.0";
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [ colorama ];

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-ol+5kbq9LqhRlm4NvcX02PZJqz5lDjASmDsp/V0Y8i0=";
  };

  meta = with lib; {
    homepage = "https://vunit.github.io/";
    description =
      "VUnit is an open source unit testing framework for VHDL/SystemVerilog";
    license = licenses.mpl20;
  };
}
