#!/usr/bin/zsh

# Prepares my default VIM setup.

function fetchPathogen() {
    if [ $1 -ne 1 ]; then
        mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    else
        echo "Skipping Pathogen..."
    fi
}

function fetchMavenCompiler() {
    if [ $1 -ne 1 ]; then
        git clone https://github.com/JalaiAmitahl/maven-compiler.vim.git ~/.vim/bundle/maven-compiler.vim
    else
        echo "Skipping Maven Compiler Plugin..."
    fi
}

function fetchSolarized() {
    if [ $1 -ne 1 ]; then
        pushd ~/.vim/bundle/
        git clone git://github.com/altercation/vim-colors-solarized.git
        mkdir ../colors
        cp vim-colors-solarized/colors/* ../colors
        popd
    else
        echo "Skipping Solarized..."
    fi
}

function fetchVundle() {
    if [ $1 -ne 1 ]; then
        git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    else
        echo "Skipping Vundle..."
    fi
}

function fetchNerdTree() {
    if [ $1 -ne 1 ]; then
        git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
    else
        echo "Skipping NERDTree..."
    fi
}

function fetchFugitive() {
    if [ $1 -ne 1 ]; then
        pushd ~/.vim/bundle
        git clone git://github.com/tpope/vim-fugitive.git
        vim -u NONE -c "helptags vim-fugitive/doc" -c q
        popd
    else
        echo "Skipping VIM Fugitive..."
    fi
}

function copyVimRc() {
    if [ $1 -ne 1 ]; then
        mv ~/.vimrc ~/.vimrc_orig
        cp .vimrc ~/.vimrc
    else
        echo "Skipping .vimrc Copy..."
    fi
}

function doUsage() {
    echo "VIM preparation script created by Dan Taylor."
    echo "Usage:  ./prepareVim.sh <options>"
    echo "Where <options> include:"
    echo "\t -h Print this help message"
    echo "\t -nF Do not install fugitive"
    echo "\t -nP Do not fetch pathogen"
    echo "\t -nR Do not copy .vimrc"
    echo "\t -nS Do not fetch solarized"
    echo "\t -nT Do not fetch NERD Tree"
    echo "\t -nV Do not fetch Vundle"
}

function run() {
    local skipFugitive=0
    local skipPathogen=0
    local skipSolarized=0
    local skipVundle=0
    local skipNerdTree=0
    local skipVimRC=0
    local skipMavenCompiler=0
    if [ "$#" != 0 ]; then
        while (( $# )); do
            if [ "$1" = "-h" ]; then
                echo "Usage"
                doUsage
                exit
            fi
            if [ "$1" = "-nF" ]; then
                skipFugitive=1
            elif [ "$1" = "-nM" ]; then
                skipMavenCompiler=1
            elif [ "$1" = "-nP" ]; then
                skipPathogen=1
            elif [ "$1" = "-nS" ]; then
                skipSolarized=1
            elif [ "$1" = "-nV" ]; then
                skipVundle=1
            elif [ "$1" = "-nT" ]; then
                skipNerdTree=1
            elif [ "$1" = "-nR" ]; then
                skipVimRC=1
            fi
            shift 
        done
    fi

    fetchPathogen $skipPathogen
    fetchFugitive $skipFugitive
    fetchMavenCompiler $skipMavenCompiler
    fetchSolarized $skipSolarized
    fetchNerdTree $skipNerdTree
    fetchVundle $skipVundle
    copyVimRc $skipVimRC
}

run $@
