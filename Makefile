.DEFAULT_GOAL := help
.SUFFIXES:

# Name of entrypoint command that `make` is aliased as
export CRI_COMMAND = cri

# Extension 'cri' main/entrypoint file.
export CRI_FILE := cri

# Relative path within the repository where extension directories are stored.
export CRI_EXTENSIONS_DIR := $(PWD)/.cri/extensions

# Alias to help extension cri file to include to get 'help' functionality.
export HELP := $(CRI_EXTENSIONS_DIR)/help/$(CRI_FILE)
export SCRIPTS := $(CRI_EXTENSIONS_DIR)/scripts/$(CRI_FILE)

# List of all extension directory names (excluding help, scripts) without root, e.g. ".cri/extensions/docker" -> "docker"
CRI_EXTENSIONS := $(shell find -L $(CRI_EXTENSIONS_DIR) -depth 1 -type d -not -name 'help' -not -name 'scripts' -exec basename {} \;)

# List of all extensions with an escaped colon stem suffix, e.g, "docker" -> "docker\:%"
CRI_EXTENSION_COMMANDS := $(CRI_EXTENSIONS:%=%\:%)

.PHONY: $(CRI_EXTENSIONS)
## Runs extension in sub-make process using the default goal
$(CRI_EXTENSIONS):
	@$(MAKE) -C $(CRI_EXTENSIONS_DIR)/$@ -f $(CRI_FILE)

.PHONY: $(CRI_EXTENSION_COMMANDS)
## Runs extension in sub-make process using the given stem as a goal
$(CRI_EXTENSION_COMMANDS):
	@$(MAKE) -C $(CRI_EXTENSIONS_DIR)/$(word 1,$(subst :, ,$@)) -f $(CRI_FILE) $*

# Include 'help' extension to add 'cri help' target.
include $(HELP)
