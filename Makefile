test: test_rust test_python

test_rust:
	@echo ~~~~~~~~~~~~~~~ Running rust implementation unit tests ~~~~~~~~~~~~~~~
	cargo test test_

test_python:
	@echo ~~~~~~~~~~~~~~~ Running python binding tests ~~~~~~~~~~~~~~~
	tox

bench:
	@echo ~~~~~~~~~~~~~~~ Running rust implementation benchmarks ~~~~~~~~~~~~~~~
	cargo bench

test_rust_eip_152_vec_8:
	@echo ~~~~~~~~~~~~~~~ Running slow EIP 152 test vector 8 ~~~~~~~~~~~~~~~
	cargo test --release \
		test_f_compress_eip_152_vec_8 \
		-- --ignored --nocapture

test_all: test_rust test_python bench test_rust_eip_152_vec_8

clean:
	rm -rf *.egg-info build dist target pip-wheel-metadata

build_docker:
	docker build -f Dockerfile.circleci \
		--build-arg=PYTHON_VERSION=3.6 \
		--tag=davesque/rust-python:nightly-py36 .
	docker build -f Dockerfile.circleci \
		--build-arg=PYTHON_VERSION=3.7 \
		--tag=davesque/rust-python:nightly-py37 .

push_docker:
	docker push davesque/rust-python:nightly-py36
	docker push davesque/rust-python:nightly-py37

.PHONY: test_rust test_rust_eip_152_vec_8 bench test_python test_all clean
