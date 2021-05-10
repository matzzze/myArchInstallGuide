#create dirs for background
mkdir $HOME/backgrounds
mkdir $HOME/backgrounds/slideshow
#add background
cp default_arch.jpg $HOME/backgrounds
#restore cinnamon.conf
dconf load /org/cinnamon/ < cinnamon.conf
