import argparse
from pathlib import Path

from wasmtime import Config, Engine, Instance, Module, Store, Trap, WasmtimeError


def main() -> None:
    parser = argparse.ArgumentParser(description="0 始まりの添字で素数を求める")
    parser.add_argument("index", type=int)
    parser.add_argument(
        "--wasm", type=Path,
        default=Path(__file__).resolve().parent / "target/nth_prime.wasm",
    )
    args = parser.parse_args()
    if not 0 <= args.index <= 2**31 - 1:
        parser.error("index must be between 0 and 2147483647")

    config = Config()
    config.wasm_gc = True
    config.wasm_function_references = True
    config.wasm_exceptions = True
    engine = Engine(config)
    try:
        module = Module.from_file(engine, str(args.wasm))
        store = Store(engine)
        instance = Instance(store, module, [])
        result = instance.exports(store)["nth_prime"](store, args.index)
    except (OSError, WasmtimeError, Trap) as error:
        parser.exit(1, f"{error}\n")
    if result == 0:
        parser.exit(1, "nth_prime returned an out-of-range result\n")
    print(result)


if __name__ == "__main__":
    main()
