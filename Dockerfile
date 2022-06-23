FROM dev_env:base
LABEL maintainer=Ilan_Gofer
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace/
COPY . .
RUN  chsh -s /usr/bin/zsh root
RUN  /bin/sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN  apt-get install -y unixodbc*
RUN  apt-get install -y unixodbc-dev
RUN  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN  curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN  apt update
RUN  apt-get update \
    && ACCEPT_EULA=Y apt-get -y install msodbcsql17
RUN  ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN  echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN  echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN  wget https://github.com/VSCodium/vscodium/releases/download/1.66.1/codium_1.66.1-1649377139_amd64.deb
RUN  dpkg -i codium_1.66.1-1649377139_amd64.deb
RUN  wget -c https://github.com/quarto-dev/quarto-cli/releases/download/v0.9.209/quarto-0.9.209-linux-amd64.deb
RUN  dpkg -i quarto-0.9.209-linux-amd64.deb
RUN  wget --quiet https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh -b -p /opt/conda \
    && rm ~/anaconda.sh \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate base" >> ~/.bashrc
RUN  /opt/conda/bin/pip install -r requirements.txt
RUN  wget https://download.jetbrains.com/python/pycharm-community-2022.1.2.tar.gz
RUN  tar -xzf pycharm-community-2022.1.2.tar.gz
RUN  rm pycharm-community-2022.1.2.tar.gz
RUN  wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.3-linux-x86_64.tar.gz
RUN  tar -xzf julia-1.7.3-linux-x86_64.tar.gz
RUN  mkdir /usr/bin/julia \
    && mv /workspace/julia-1.7.3/* /usr/bin/julia
RUN  rm julia-1.7.3-linux-x86_64.tar.gz
RUN  echo 'export PATH="$PATH:/usr/bin/julia/bin"' >> ~/.bash_profile
RUN  echo 'export PATH="$PATH:/usr/bin/julia/bin"' >> ~/.bashrc
#RUN  /usr/bin/julia/bin/julia packages.jl
RUN  curl -fsSL https://code-server.dev/install.sh | sh
RUN  wget https://github.com/microsoft/vscode-python/releases/download/2020.10.332292344/ms-python-release.vsix
RUN  mkdir -p ~/.local/share/code-server/ \
    && mkdir -p ~/.local/share/code-server/User \
    && cp /workspace/settings.json ~/.local/share/code-server/User
RUN  code-server --force --install-extension ms-python.python \
    && code-server --force --install-extension ms-mssql.mssql \
    && code-server --force --install-extension Ikuyadeu.r \
    && code-server --force --install-extension julialang.language-julia-insider \
    && code-server --force --install-extension REditorSupport.r-lsp \
    && code-server --force --install-extension ms-toolsai.jupyter \
    && code-server --force --install-extension hdg.live-html-previewer-0.3.0.vsix \
    && code-server --force --install-extension ms-python.vscode-pylance \
    && code-server --force --install-extension neuron.neuron-IPE-1.0.4.vsix \
    && code-server --force --install-extension ms-toolsai.jupyter \
    && code-server --force --install-extension quarto.quarto \
    && code-server --force --install-extension ms-toolsai.jupyter-keymap \
    && code-server --force --install-extension NicolasVuillamy.vscode-groovy-lint-1.7.5.vsix
    

RUN  Rscript packages.r
RUN  cp -a /workspace/rstudio/. /usr/lib/rstudio-server/
