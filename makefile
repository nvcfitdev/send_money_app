# Check if .fvm/flutter_sdk exists; if so, use fvm
USE_FVM := $(shell [ -d ".fvm/flutter_sdk" ] && echo true || echo false)


FLUTTER_CMD := $(if $(filter true,$(USE_FVM)),fvm flutter,flutter)
DART_CMD := $(if $(filter true,$(USE_FVM)),fvm dart,dart)
LCOV_REMOVE_PATHS := 'lib/core/*' 'lib/shared/*' '**/*.g.dart' 'lib/features/**/domain/mapper/*' 'lib/features/**/data/*' 'lib/features/**/domain/entities/*'

COV_DIR := coverage
LCOV_FILE := $(COV_DIR)/lcov.info
COV_HTML_DIR := $(COV_DIR)/html

# Clean up
clean: 
	$(FLUTTER_CMD) clean
	$(FLUTTER_CMD) pub get

# Code generation
codegen: 
	$(DART_CMD) run build_runner build --delete-conflicting-outputs

# Localization
il8ngen:
	$(DART_CMD) ../scripts/intl_cli_tools/intl_gen.dart -j assets/raw/intl_en.json -o lib/shared/localization/il8n/il8n.gen.dart

# Code coverage
codecov:
	$(FLUTTER_CMD) test --coverage
	lcov --remove coverage/lcov.info 'lib/core/*' 'lib/shared/*' '**/*.g.dart' 'lib/features/**/domain/mapper/*' 'lib/features/**/data/*' 'lib/features/**/domain/entities/*' -o coverage/lcov.info
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

certificate: 
	sudo gem install bundler
	sudo bundle install 
	bundle exec fastlane install_provisioning_profile_locally
