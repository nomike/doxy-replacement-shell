.PHONY: all	clean publish

all: doxy-shell-button-half.stl doxy-shell-nonbutton-half.stl

clean:
	rm -f doxy-shell-button-half.stl doxy-shell-nonbutton-half.stl

doxy-shell-button-half.stl: doxy-shell.scad
	openscad -o doxy-shell-button-half.stl doxy-shell.scad -D button_half=true

doxy-shell-nonbutton-half.stl: doxy-shell.scad
	openscad -o doxy-shell-nonbutton-half.stl doxy-shell.scad -D button_half=false

publish: doxy-shell-button-half.stl doxy-shell-nonbutton-half.stl
	thingiverse-publisher
