set dotenv-load
set export

DEVICE_ID := env_var_or_default("DEVICE_ID", "CI_" + file_name(home_directory()) + "_example-device-app" )
TEST_IMAGE := env_var_or_default("TEST_IMAGE", "debian-systemd-native")

# Initialize a dotenv file for usage with a local debugger
# WARNING: It will override any previously generated dotenv file
init-dotenv:
  @echo "Recreating .env file..."
  @echo "DEVICE_ID=$DEVICE_ID" > .env
  @echo "IMAGE=$IMAGE" >> .env
  @echo "IMAGE_SRC=$IMAGE_SRC" >> .env
  @echo "C8Y_BASEURL=$C8Y_BASEURL" >> .env
  @echo "C8Y_USER=$C8Y_USER" >> .env
  @echo "C8Y_PASSWORD=$C8Y_PASSWORD" >> .env


# Release all artifacts
build *ARGS='':
    ./ci/build.sh {{ARGS}}

# Install python virtual environment
venv:
  [ -d .venv ] || python3 -m venv .venv
  ./.venv/bin/pip3 install -r tests/requirements.txt

# Build test images and test artifacts
build-test: build
  echo "Creating test infrastructure image"
  [ -d "./test-images/{{TEST_IMAGE}}" ] && docker build --load -t {{TEST_IMAGE}} -f ./test-images/{{TEST_IMAGE}}/Dockerfile . || docker pull "{{TEST_IMAGE}}"

# Run tests
test *args='':
  ./.venv/bin/python3 -m robot.run --outputdir output {{args}} tests
