# Isabelle/HOL の nth prime を Wasmtime で実行する

`nth_prime` は 0 始まりです。たとえば `nth_prime 0 = 2`、
`nth_prime 4 = 11` です。[Nth_Prime.thy](Nth_Prime.thy) では、返り値が素数であり、
それ未満の素数がちょうど入力の個数だけ存在することを証明しています。
次の素数の探索には Isabelle 標準ライブラリの `smallest_prime_beyond` を使います。

## ビルドと実行

Isabelle2025-2、JDK 17 以上、sbt、GNU Make、Python 3 を用意します。
生成 Scala のクラス名には大文字小文字だけが異なる組があるため、
ビルドは大文字小文字を区別するファイルシステムで行ってください。

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
make build
.venv/bin/python nth_prime.py 99
make check PYTHON=.venv/bin/python
```

入力 `99` の出力は `541` です。

`make build` は Isabelle のセッションを検証して `PrimeCode.scala` を抽出し、
Scala.js 1.23.0 の `WasmModule` として `target/nth_prime.wasm` を生成します。
Python は Wasmtime でこのモジュールを読み込み、Wasm のエクスポート
`nth_prime(i32) -> i64` を直接呼び出します。実行に必要なのは Python、
Wasmtime と生成済みの Wasm です。

Python CLI は 0 から 2147483647 までの添字を受け付けます。
Wasm API は負の添字または i64 に収まらない結果に対して 0 を返します。
この入力範囲は ABI の範囲です。素数探索と再帰にかかる時間やスタック使用量は
入力に依存します。
