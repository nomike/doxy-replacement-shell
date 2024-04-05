# Output directory for generated STL files
OUTPUT_DIR = output

.PHONY: all generate_stls clean

all: $(OUTPUT_DIR) generate_stls

$(OUTPUT_DIR):
	mkdir -p $@

generate_stls:
	openscad_stl_file_generator/generate_stls --output-dir="$(OUTPUT_DIR)"

clean:
	rm -rf $(OUTPUT_DIR)
