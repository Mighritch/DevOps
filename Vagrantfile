# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Configuration de la VM Ubuntu 22.04
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "adoption-project-vm"

  # Configuration réseau (port forwarding pour Spring Boot)
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Configuration des ressources
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.name = "adoption-project-vm"
  end

  # Provisionnement avec shell inline
  config.vm.provision "shell", inline: <<-SHELL
    # Mise à jour et installation des dépendances
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y openjdk-17-jdk git curl unzip

    # Installation de Maven
    sudo apt-get install -y maven

    # Vérification des versions
    echo "=== Versions installées ==="
    java -version
    mvn --version

    # Configuration du projet
    PROJECT_DIR="/home/vagrant/adoption-project"
    sudo -u vagrant mkdir -p $PROJECT_DIR

    # Clone du dépôt GitHub (remplacez par votre URL)
    sudo -u vagrant git clone https://github.com/Mighritch/DevOps.git $PROJECT_DIR

    # Build du projet (optionnel)
    cd $PROJECT_DIR
    sudo -u vagrant mvn clean package -DskipTests

    echo "=========================================="
    echo "Provisionnement terminé avec succès !"
    echo "Accédez à la VM avec : vagrant ssh"
    echo "Projet disponible dans : $PROJECT_DIR"
    echo "Spring Boot sera accessible sur : http://localhost:8080"
    echo "=========================================="
  SHELL
end