import scala.scalajs.wasm.annotation.WasmExport

object PrimeWasm {
  @WasmExport("nth_prime")
  def nthPrime(index: Int): Long = {
    if (index < 0) 0L
    else {
      val prime = PrimeCode.nth_prime_integer(BigInt(index))
      if (prime.isValidLong) prime.toLong else 0L
    }
  }
}
