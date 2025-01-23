#!/bin/bash

./build_overlays.sh

./build_icons.sh
cd icons
../build_svg_matrix.sh . ./icons.svg 
../build_svg_matrix.sh . ./icons_16x16.svg ./icons_16x16.png
../build_svg_matrix.sh . ./icons_20x20.svg ./icons_20x20.png
../build_svg_matrix.sh . ./icons_24x24.svg ./icons_24x24.png
../build_svg_matrix.sh . ./icons_32x32.svg ./icons_32x32.png
cd ..
./inc/legacy_png_matrix_from_subpixmaps.sh icons icons/16x16.png
eiffel tools/build_html_index.ecf ../png/icons.ini icons icons.html --svg --png
eiffel tools/build_html_index.ecf ../png/icons.ini icons icons/svg.html --svg
eiffel tools/build_html_index.ecf ../png/icons.ini icons icons/png.html --png

./build_small_icons.sh
cd small
../build_svg_matrix.sh . ./small_icons.svg
../build_svg_matrix.sh . ./small_12x12.svg ./small_12x12.png
../build_svg_matrix.sh . ./small_15x15.svg ./small_15x15.png
../build_svg_matrix.sh . ./small_18x18.svg ./small_18x18.png
../build_svg_matrix.sh . ./small_24x24.svg ./small_24x24.png
cd ..
./inc/legacy_png_matrix_from_subpixmaps.sh small small/12x12.png
eiffel tools/build_html_index.ecf ../png/small_icons.ini small small.html --svg --png
eiffel tools/build_html_index.ecf ../png/small_icons.ini small small/svg.html --svg
eiffel tools/build_html_index.ecf ../png/small_icons.ini small small/png.html --png


./build_mini_icons.sh
cd mini
../build_svg_matrix.sh . ./mini_icons.svg
../build_svg_matrix.sh . ./mini_10x10.svg ./mini_10x10.png
../build_svg_matrix.sh . ./mini_12x12.svg ./mini_12x12.png
../build_svg_matrix.sh . ./mini_15x15.svg ./mini_15x15.png
../build_svg_matrix.sh . ./mini_20x20.svg ./mini_20x20.png
cd ..
./inc/legacy_png_matrix_from_subpixmaps.sh mini mini/10x10.png
eiffel tools/build_html_index.ecf ../png/mini_icons.ini mini mini.html --svg --png
eiffel tools/build_html_index.ecf ../png/mini_icons.ini mini mini/svg.html --svg
eiffel tools/build_html_index.ecf ../png/mini_icons.ini mini mini/png.html --png

function build_matrix_png {
	k=$1
	m=$2
	echo DBG.build_matrix_png $k $m ...
	if [ ! -f $k/${k}_${m}.png ]; then
		echo Generate $k/${k}_${m}.png
		./inc/matrix_from_subpixmaps.sh $k $k/${k}_${m}.png
	else
		if [ $k/${k}_${m}.png -ot $k/${k}_${m}.svg ]; then
			echo Generate fresh $k/${k}_${m}.png
			./inc/matrix_from_subpixmaps.sh $k $k/${k}_${m}.png
		else
			echo Keep exiting $k/${k}_${m}.png
		fi
	fi
}

echo Build icons matrix files

#./inc/matrix_from_subpixmaps.sh icons icons/16x16.png
build_matrix_png icons 16x16
build_matrix_png icons 20x20
build_matrix_png icons 24x24
build_matrix_png icons 32x32

echo Build small matrix files
#./inc/matrix_from_subpixmaps.sh small small/12x12.png
build_matrix_png small 12x12
build_matrix_png small 15x15
build_matrix_png small 18x18
build_matrix_png small 24x24

echo Build mini matrix files
#./inc/matrix_from_subpixmaps.sh mini mini/10x10.png
build_matrix_png mini 10x10
build_matrix_png mini 12x12
build_matrix_png mini 15x15
build_matrix_png mini 20x20

