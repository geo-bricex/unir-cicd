# Configuración de Vagrant para instalar Jenkins en una máquina virtual con Ubuntu 20.04
Vagrant.configure("2") do |config|
  # Utilizar la caja base de Ubuntu 20.04
  config.vm.box = "ubuntu/focal64"

  # Configurar la red para permitir el acceso a Jenkins desde el host
  # Redirigir el puerto 8080 en la VM al puerto 8089 en el host
  config.vm.network "forwarded_port", guest: 8080, host: 8089
  config.ssh.insert_key = false

  # Aumentar los recursos asignados a la máquina virtual
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192" # Aumentar la memoria RAM a 8192 MB (8 GB)
    vb.cpus = 4       # Aumentar el número de CPUs a 4
  end

  # Provisión para configurar SSH, Docker, Jenkins y make utilizando un script de shell
  config.vm.provision "shell", inline: <<-SHELL
    # Actualizar la lista de paquetes
    sudo apt-get update

    # Instalar Java, que es un requisito necesario para Jenkins
    sudo apt-get install -y openjdk-11-jdk

    # Instalar Docker
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce

    # Agregar el usuario vagrant y jenkins al grupo docker
    sudo usermod -aG docker vagrant
    sudo usermod -aG docker jenkins

    # Instalar make y otras herramientas necesarias
    sudo apt-get install -y build-essential

    # Descargar la clave GPG de Jenkins y añadirla al keyring del sistema
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

    # Añadir el repositorio de Jenkins a la lista de fuentes de APT
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | 
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

    # Actualizar la lista de paquetes nuevamente para incluir Jenkins
    sudo apt-get update

    # Instalar Jenkins
    sudo apt-get install -y jenkins

    # Iniciar el servicio de Jenkins
    sudo systemctl start jenkins

    # Habilitar Jenkins para que se inicie automáticamente al arrancar el sistema
    sudo systemctl enable jenkins

    # Configurar SSH para permitir la autenticación por contraseña
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
    echo "AllowUsers vagrant jenkins" | sudo tee -a /etc/ssh/sshd_config
    echo "UsePAM yes" | sudo tee -a /etc/ssh/sshd_config
    sudo systemctl restart ssh

    # Establecer la contraseña para el usuario vagrant
    echo "vagrant:vagrant" | sudo chpasswd

    # Reiniciar el servicio de Jenkins para aplicar los cambios
    sudo systemctl restart jenkins

    sudo apt update
    sudo apt install python3-pip -y
    pip3 install flask
    
  SHELL

  # Configuración opcional para sincronizar una carpeta del host con la VM
  config.vm.synced_folder ".", "/vagrant"
end
