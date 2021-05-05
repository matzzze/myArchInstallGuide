#!/bin/bash


echo "==================> Downloading bash-completion"
sudo pacman -Sy --needed bash-completion

echo "==================> Modify .bashrc script"
cat  bashmodify.txt>> ${HOME}/.bashrc

echo "==================> Creating .inputrc with backward search over pg-up/pg-down"
cp  inputrc ${HOME}/.inputrc

echo "==================> Restarting bash"
exec bash

