# Usa una imagen base de Ubuntu
FROM ubuntu:latest

# Instala openssh-server, sudo y otras dependencias necesarias
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    net-tools \
    iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configura SSH
RUN mkdir /var/run/sshd
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Crea el usuario ansible con contraseña ansible y añade al grupo sudo
RUN useradd -rm -d /home/ansible -s /bin/bash -g root -G sudo ansible
RUN echo "ansible:ansible" | chpasswd
RUN echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible

# Expón el puerto SSH
EXPOSE 22

# Comando para iniciar el servidor SSH
CMD ["/usr/sbin/sshd", "-D"]
