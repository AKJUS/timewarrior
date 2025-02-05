set -x

brew install pyenv
brew install asciidoctor

export PYTHON_VERSION="3.10.16"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$( pyenv init --path )"
pyenv install "${PYTHON_VERSION}"
pyenv global "${PYTHON_VERSION}"
pip install --upgrade pip
pip install python-dateutil

git clean -dfx
git submodule init
git submodule update
cmake -DCMAKE_BUILD_TYPE=debug .
make -j2
make install

pushd test || exit
make
./run_all -v
set +x
grep 'not ok' all.log
./problems
EXIT_CODE=$?
echo "timew $( timew --version )"
asciidoctor --version
python --version
cmake --version
clang --version
exit ${EXIT_CODE}
