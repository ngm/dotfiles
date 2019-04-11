# boxstarter

Documenting the steps I take when bootstrapping a new install.
Assuming Debian and GNOME for now.

To eventually be automated, e.g. as a shell script or with something like ansible.

- installation
  - encrypt drive (is there a way to just encrypt home dir?)
  - create user with sudo 

- post installation
  - install guake
    - add as a startup application via gnome tweak tool
  - install tmux
  - install git
  - clone dotfiles repo to .dotfiles
      - symlink .dotfiles/spacemacs -> .spacemacs
      - symlink .dotfiles/tmux.conf -> .tmux.conf
  - switch to adwaita dark mode 
  - install syncthing
    - to pull down org files
    - add as a startup application (via gnome tweak tool)
  - install emacs
  - clone spacemacs files into .emacs.d
    - had to do this to fix org refile issue: https://github.com/syl20bnr/spacemacs/issues/11801#issuecomment-451755821
  - install keepassxc
