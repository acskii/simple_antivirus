ANTIVIRUS := antivirusd.sh
RESTORE := restore.sh
MAL_DIR := mal
TARGET_DIR := .
DEFAULT_INTERVAL := 5

.DEFAULT_GOAL := all

all: prebuild virusd

# Retrieved target from previous project #
.PHONY: help
help: ## Display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z0-9_\/-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: prebuild
prebuild: ## Setup required files before running
	@if [ ! -d "$(MAL_DIR)" ]; then \
		mkdir -p "$(MAL_DIR)"; \
		echo "Created $(MAL_DIR)"; \
	else \
		echo "$(MAL_DIR) already exists"; \
	fi

.PHONY: virusd
virusd:	## Run antivirus daemon
	chmod +x "$(ANTIVIRUS)"
	"./$(ANTIVIRUS)" $(TARGET_DIR) $(MAL_DIR) $(DEFAULT_INTERVAL)

.PHONY: restore
restore: ## Run restore tool
	chmod +x "$(RESTORE)"
	"./$(RESTORE)" $(TARGET_DIR) $(MAL_DIR)