# After getting current vim source...
# ./configure --with-features=huge --enable-pythoninterp --enable-rubyinterp --with-tlib=ncurses > ~/junk.txt

git submodule update --init --recursive
cp -R .vim* ~/
vim +PluginInstall +qall
cd ~/.vim/bundle/command-t
gem install bundler
bundle install #Get updated Ruby gems
rake make
cd ~/.vim/bundle/YouCompleteMe
./install.sh
