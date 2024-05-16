################################################################################
# Step 1: create base image for all stages.
################################################################################

FROM python:3.11-slim as python-base
ENV PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/app/.venv"
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
ENV POETRY_VERSION=1.8.3
WORKDIR /opt/app

################################################################################
# Step 2: define dependencies available in each stage. All release
# dependencies are added to test, and all test dependencies are added to
# development.
################################################################################

FROM python-base as release-dependencies
RUN apt update \
    # Pre-requisites for poetry
    && apt install --no-install-recommends -y curl build-essential
RUN curl -sSL https://install.python-poetry.org | python3 -
COPY ./poetry.lock ./pyproject.toml ./
RUN poetry install --only=main  # Install minimal dependencies

FROM release-dependencies as test-dependencies
RUN poetry install  # Install dev dependencies

FROM test-dependencies as development-dependencies
RUN apt install -y htop  # Example tool only required for local development

################################################################################
# Step 3: define final image for each stage. All code in release is included
# in test, and all code in test is included in development.
################################################################################

FROM release-dependencies as release
COPY ./app ./app

FROM test-dependencies as test
COPY --from=release /opt/app ./
COPY ./tests ./tests

FROM development-dependencies as development
COPY --from=test /opt/app ./

################################################################################
# Step 4: to be safe, release is defined as the default image.
################################################################################
FROM release as default
