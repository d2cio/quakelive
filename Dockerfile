FROM python:3.5

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y build-essential libc6:i386 libstdc++6:i386

WORKDIR /home

RUN wget -q http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xzf steamcmd_linux.tar.gz
RUN rm -f steamcmd_linux.tar.gz

# install the quake live server program
RUN /home/steamcmd.sh +login anonymous +force_install_dir /home/steamapps/common/qlds/ +app_update 349090 +quit

RUN mkdir /home/steamapps/common/qlds/baseq3/configs/
RUN mv /home/steamapps/common/qlds/baseq3/*.cfg /home/steamapps/common/qlds/baseq3/configs/
RUN mv /home/steamapps/common/qlds/baseq3/*.txt /home/steamapps/common/qlds/baseq3/configs/

#RUN python -m easy_install pyzmq hiredis

RUN git clone https://github.com/MinoMino/minqlx-plugins.git /minqlx-plugins

RUN python -m pip install -r /minqlx-plugins/requirements.txt

RUN wget `curl -s https://api.github.com/repos/MinoMino/minqlx/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4` -O /tmp/minqlx.tar.gz

RUN tar -xzvf /tmp/minqlx.tar.gz -C /home/steamapps/common/qlds/

VOLUME ["/home/steamapps/common/qlds/baseq3/configs/"]

ENTRYPOINT ["/home/steamapps/common/qlds/run_server_x64_minqlx.sh", "+exec", "configs/server.cfg"]
