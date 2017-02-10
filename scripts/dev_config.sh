#!/bin/bash
# Add any custom setup instructions here

export PERL5LIB=$BUGZILLA_LIB

# Global Perl dependencies
export CPANM="sudo /usr/local/bin/cpanm --quiet --notest --skip-satisfied"

# Global dependencies
$CPANM --uninstall JSON::RPC
$CPANM JSON::RPC@1.01
$CPANM App::SimpleHTTPServer
$CPANM Devel::NYTProf
$CPANM Email::Sender;
$CPANM File::Slurp
$CPANM HTML::FormatText::WithLinks
$CPANM IPC::System::Simple
$CPANM Net::RabbitMQ
$CPANM Net::SMTP::SSL
$CPANM REST::Client
$CPANM Term::ReadKey
$CPANM Text::MultiMarkdown

sudo git clone https://github.com/mozilla-bteam/bmo.git $BUGZILLA_WWW/../bmo
cd $BUGZILLA_WWW/../bmo
$CPANM --installdeps --with-feature bmo .

# Bugzilla dev manager configuration
git clone https://github.com/dklawren/bugzilla-dev-manager.git \
    -b app $HOME/bugzilla-dev-manager
cd $HOME/bugzilla-dev-manager && $CPANM --installdeps .
mkdir $HOME/bin
ln -sf $HOME/bugzilla-dev-manager/bz-command $HOME/bin/bz
sudo cp $HOME/bugzilla-dev-manager/bz-dev.conf-sample /etc/bz-dev.conf

# Home dotfiles
git clone https://github.com/dklawren/homedir $HOME/homedir
cd $HOME/homedir && ./makedotfiles.sh

# Vim configuration
git clone https://github.com/dklawren/dotvim $HOME/.vim
cd $HOME/.vim
git submodule update --init
ln -sf $HOME/.vim/rc/vimrc $HOME/.vimrc
git clone https://github.com/powerline/fonts.git $HOME/powerline-fonts
cd $HOME/powerline-fonts && ./install.sh

localedef -i en_US -f UTF-8 en_US.UTF-8

# Remove CPAN build files to minimize disk usage
rm -rf ~/.cpan*
