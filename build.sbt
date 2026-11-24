enablePlugins(ScalaJSPlugin)

scalaVersion := "2.13.18"
scalaJSLinkerConfig ~= (_.withModuleKind(ModuleKind.WasmModule).withSourceMap(false))

Compile / unmanagedSources +=
  baseDirectory.value / "target" / "isabelle" / "Nth_Prime.Nth_Prime" / "code" / "PrimeCode.scala"

Compile / fullLinkJS / scalaJSLinkerOutputDirectory :=
  baseDirectory.value / "target" / "wasm"

lazy val buildWasm = taskKey[File]("Build the standalone nth_prime.wasm")
buildWasm := {
  (Compile / fullLinkJS).value
  val output = (Compile / fullLinkJS / scalaJSLinkerOutputDirectory).value
  val modules = (output ** "*.wasm").get
  require(modules.size == 1, s"Expected a single Wasm module in $output: $modules")
  val destination = baseDirectory.value / "target" / "nth_prime.wasm"
  IO.copyFile(modules.head, destination)
  destination
}
