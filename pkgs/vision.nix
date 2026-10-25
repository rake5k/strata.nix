{
  lib,
  stdenv,
  cmake,
  ninja,
  src,
  llamaSrc,
  version,
  pinChecked ? true,
}:

assert pinChecked;

# strata-vision on the CPU (tools/vision without CUDA): the image encoder for every backend. The portable AVX2 build
# is upstream's default and beats AVX-512 here, whose flash-attention fallback is several times slower (#660).
stdenv.mkDerivation {
  pname = "strata-vision";
  inherit version src;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeDir = "../tools/vision";
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLAMA_DIR=${llamaSrc}"
    "-DSTRATA_VISION_CUDA=OFF"
    "-DSTRATA_PORTABLE=ON"
  ];

  ninjaFlags = [ "strata-vision" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/strata-vision $out/bin/strata-vision
    runHook postInstall
  '';

  meta = {
    description = "Strata's CPU image encoder (llama.cpp mtmd) for Qwen3.8-Flash-Next";
    homepage = "https://github.com/Niko1221/Strata";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "strata-vision";
  };
}
