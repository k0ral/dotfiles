{ self, super }:

super.python3.pkgs.buildPythonApplication rec {
  pname = "pihello";
  version = "0.2.6";

  src = super.python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "zNMwm09vAA1mCOdT7V6HikQIbO8lXs2bxg+NSzYTZeA=";
  };

  meta = with super.lib; {
    description = "Fetch and display Pi-hole statistics in terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
    homepage = "https://github.com/pavelgar/${pname}";
  };
}

