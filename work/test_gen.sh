#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "[test_gen] Running testgen..."
PYTHONPATH=../generators/tests/testgen/src \
python3 -m testgen.testgen ../tests

echo "[test_gen] Running illegal instruction tests..."
python3 ../generators/tests/scripts/illegalinstrtests.py

echo "[test_gen] Running CSR tests..."
python3 ../generators/tests/scripts/csrtests.py

echo "[test_gen] Running ACT4 framework..."
PYTHONPATH=../framework/src \
python3 ../framework/src/act/act_main.py \
    ../configs/duts/cvw/cvw-rv32imc/test_config.yaml \
    --test-dir ../tests \
    --coverpoint-dir ../coverpoints \
    --workdir .

echo "[test_gen] Running make..."
make -C .

echo "[test_gen] All steps completed successfully. Tests have been Generated!"
