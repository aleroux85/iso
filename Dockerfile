FROM iso:base
# FROM docker.pkg.github.com/<your-github-user>/iso/base:0.1

ARG USER
ARG GROUP
ARG UID=1000
ARG GID=1000
ARG FULL_NAME
ARG EMAIL

RUN groupadd -r -g ${GID} ${GROUP} && useradd -r -m -u ${UID} -g ${GROUP} -d /home/${USER} -s /bin/bash ${USER}
RUN usermod -aG docker ${USER}

RUN mkdir -p /run/sshd
RUN sed -i '/PubkeyAuthentication/s/^#//' /etc/ssh/sshd_config
RUN sed -i '/AuthorizedKeysFile/s/^#//' /etc/ssh/sshd_config
RUN sed -i '/AuthorizedKeysFile/s/.ssh\/authorized_keys/\/root\/.ssh\/authorized_keys/' /etc/ssh/sshd_config
RUN sed -i "/AuthorizedKeysFile/s/.ssh\/authorized_keys2/\/home\/${USER}\/.ssh\/authorized_keys/" /etc/ssh/sshd_config
RUN sed -i '/AllowAgentForwarding/s/^#//' /etc/ssh/sshd_config

RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
ADD ./id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN ssh-keygen -b 4096 -t rsa -f /root/.ssh/id_rsa -q -N ""

RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ${USER}
RUN mkdir -p /home/${USER}/.ssh
RUN chmod 700 /home/${USER}/.ssh
ADD ./id_rsa.pub /home/${USER}/.ssh/authorized_keys
USER root
RUN chown ${USER}:${USER} /home/${USER}/.ssh/authorized_keys
USER ${USER}
RUN chmod 600 /home/${USER}/.ssh/authorized_keys
RUN ssh-keygen -b 4096 -t rsa -f /home/${USER}/.ssh/id_rsa -q -N ""

RUN git config --global user.name "${FULL_NAME}"
RUN git config --global user.email "${EMAIL}"
RUN git config --global core.editor vim

# Add setup and configuration here that are be custom, yet general across
# your custom containers

# use oh-my-zsh
# RUN sudo apt-get update -y && sudo apt-get install zsh -y
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# RUN sudo sed -i "/${USER}/s/\/bin\/bash/\/usr\/bin\/zsh/" /etc/passwd
# RUN sed -i /ZSH_THEME/s/robbyrussell/bira/ ~/.zshrc

USER root
CMD ["/usr/sbin/sshd", "-D"]