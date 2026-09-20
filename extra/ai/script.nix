{ lib, python3Packages, makeWrapper }:
with python3Packages;
buildPythonApplication {
  pname = "ai-pipe";
  version = "0.1";
  propagatedBuildInputs = [ openai keyring ];
  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;
  src = ./.;
  format = "other";
  installPhase = ''
    mkdir -p $out/bin

    cp script.py $out/bin/ai
    chmod +x $out/bin/ai

    wrapProgram $out/bin/ai \
          --prefix PATH : ${lib.makeBinPath [ python3Packages.keyring ]} \
          --run 'export OPENROUTER_API_KEY=$(keyring get openrouter api-key)'    
  '';
}
