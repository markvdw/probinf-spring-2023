#!/bin/bash
set -e

cd ./slides/
for file_name in *.tex; do
    echo "Handout: ${file_name}"
    if ! grep -q 'handout]{beamer}' ${file_name}; then
        sed -i '' 's/]{beamer}/,handout]{beamer}/g' ${file_name}
    fi
    file_name_noext="${file_name%.*}"
    handout_name="${file_name_noext}_handout.pdf"
    slides_name="${file_name_noext}_slides.pdf"

    pdflatex ${file_name} > /dev/null
    bibtex ${file_name_noext} > /dev/null
    pdflatex ${file_name} > /dev/null
    mv ${file_name_noext}.pdf ${handout_name}

    echo "Slides: ${file_name}"
    if grep -q 'handout]{beamer}' ${file_name}; then
        sed -i '' 's/,handout]{beamer}/]{beamer}/g' ${file_name}
    fi
    pdflatex ${file_name} > /dev/null
    pdflatex ${file_name} > /dev/null  # Run again to get references right
    mv ${file_name_noext}.pdf ${slides_name}

    echo ""
done
