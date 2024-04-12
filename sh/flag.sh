# export RUSTFLAGS="-C target-cpu=native $RUSTFLAGS"
export RUSTFLAGS='--cfg reqwest_unstable -C target-feature=+aes'
