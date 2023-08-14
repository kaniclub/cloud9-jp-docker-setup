# ベースイメージとしてUbuntu 20.04を使用
FROM ubuntu:20.04

# 日本語ロケールの設定
RUN apt-get update && \
    apt-get install -y tzdata language-pack-ja && \
    update-locale LANG=ja_JP.UTF-8
ENV TZ=${TZ}
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# APTリポジトリの変更
RUN sed -i.bak -e "s%http://[^ ]\+%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list

# システムの最小化解除とアップデート
RUN yes | unminimize -y
RUN apt-get update && \
    apt-get upgrade -y

# 基本的なツールのインストール
RUN apt-get install -y sudo vim git build-essential openssh-server wget curl aria2 lsof apt-utils
RUN apt-get install -y python2.7 libevent-dev

# SSH設定の変更
RUN sed -i 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -i 's/^#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
RUN sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

# SSHサービスの開始と停止
RUN /etc/init.d/ssh start
RUN /etc/init.d/ssh stop

# Node.jsのインストール
RUN apt-get update -y && \
    apt-get install -y nodejs npm && \
    npm install -g n && \
    n 12 && \
    apt-get purge -y nodejs npm && \
    apt-get autoremove -y

# ユーザーの追加
ARG USER
ARG UID
ARG GID
ARG PASSWORD
RUN groupadd -g $GID $USER && \
    useradd -m -u $UID -g $GID -s /bin/bash $USER && \
    gpasswd -a $USER sudo && \
    echo "$USER:$PASSWORD" | chpasswd

# Cloud9 IDEのインストール
USER $USER
WORKDIR /home/$USER/
RUN /bin/bash -c "$(curl -fsSL https://d4gqi72cyl0m5.cloudfront.net/static/c9-install.sh)"
RUN echo 'if [ -f ~/.bashrc ]; then\n  . ~/.bashrc\nfi\n' >> ~/.bash_profile && \
    echo 'export LANG=ja_JP.UTF-8' >> ~/.bash_profile
USER root
RUN npm install -g c9

# rbenvおよびruby-buildのインストール
USER $USER
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

# 必要なライブラリのインストール
USER root
RUN apt-get update
RUN apt-get install -y \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libyaml-dev

# rbenv で指定の Ruby バージョンをインストールし、グローバルに設定
ARG RUBYVER

USER $USER
RUN /bin/bash -c "\
    export PATH=\"$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:\$PATH\" && \
    eval \"\$(~/.rbenv/bin/rbenv init -)\" && \
    rbenv install $RUBYVER && \
    rbenv global $RUBYVER"

# Railsのインストール
ARG RAILSVER

USER $USER
RUN /bin/bash -l -c "\
    export PATH=\"$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:\$PATH\" && \
    eval \"\$(~/.rbenv/bin/rbenv init -)\" && \
    gem install rails -v $RAILSVER"

# PostgreSQLのインストール
ARG POSTGRES_VER

USER root
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-client-${POSTGRES_VER}

USER root

# 起動コマンドの設定
CMD ["/usr/sbin/sshd", "-D"]