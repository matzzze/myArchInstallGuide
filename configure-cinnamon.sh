#create dirs for background
mkdir $HOME/backgrounds
mkdir $HOME/backgrounds/slideshow
#add background
cp default_arch.jpg $HOME/backgrounds
#restore cinnamon.conf
dconf load /org/cinnamon/ < cinnamon.conf
#set xfce4terminal as terminal to be opened from nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec xfce4-terminal
