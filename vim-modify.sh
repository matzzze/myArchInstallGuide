echo "==================> Downloading pathogen bundler for vim"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo "==================> Downloading Nerdtree "
git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree

echo "==================> Creating .vimrc with customization"
cp  vimrc ${HOME}/.vimrc
