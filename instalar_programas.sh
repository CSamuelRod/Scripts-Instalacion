#!/bin/bash

# Función para verificar si un programa está instalado
function IsProgramInstalled {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Función para descargar e instalar un programa desde una URL
function DownloadAndInstall {
    local url="$1"
    local file="$2"
    
    echo "Descargando $file desde $url..."
    wget -O "$file" "$url"

    echo "Instalando $file..."
    sudo chmod +x "$file"
    sudo "$file"
    
    echo "$file instalado con éxito."
}

# Actualizar paquetes e instalar dependencias
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget curl

# Crear carpeta temporal para instaladores
TEMP_DIR="/tmp/software_installer"
mkdir -p "$TEMP_DIR"

# Instalar Git
if ! IsProgramInstalled git; then
    echo "Git no está instalado. Procediendo a la instalación..."
    sudo apt install -y git
else
    echo "Git ya está instalado. Omisión de la instalación."
fi

# Instalar JDK 21
if ! IsProgramInstalled java; then
    echo "JDK 21 no está instalado. Procediendo a la instalación..."
    sudo apt install -y openjdk-21-jdk
else
    echo "JDK 21 ya está instalado. Omisión de la instalación."
fi

# Instalar IntelliJ IDEA (Community Edition)
if ! IsProgramInstalled idea; then
    echo "IntelliJ IDEA Community Edition no está instalado. Procediendo a la instalación..."
    intelliJUrl="https://download.jetbrains.com/idea/ideaIC.tar.gz"
    intelliJInstaller="$TEMP_DIR/ideaIC.tar.gz"
    wget -O "$intelliJInstaller" "$intelliJUrl"
    sudo tar -xzf "$intelliJInstaller" -C /opt/
    sudo ln -s /opt/idea-IC*/bin/idea.sh /usr/local/bin/idea
    echo "IntelliJ IDEA instalado con éxito."
else
    echo "IntelliJ IDEA ya está instalado. Omisión de la instalación."
fi

# Instalar NetBeans 22
if ! IsProgramInstalled netbeans; then
    echo "NetBeans 22 no está instalado. Procediendo a la instalación..."
    netbeansUrl="https://dlcdn.apache.org/netbeans/netbeans-installers/22.0/Apache-NetBeans-22.0-bin-linux-x64.sh"
    netbeansInstaller="$TEMP_DIR/netbeans.sh"
    DownloadAndInstall "$netbeansUrl" "$netbeansInstaller"
else
    echo "NetBeans 22 ya está instalado. Omisión de la instalación."
fi

# Instalar Postman
if ! IsProgramInstalled postman; then
    echo "Postman no está instalado. Procediendo a la instalación..."
    postmanUrl="https://dl.pstmn.io/download/latest/linux64"
    postmanInstaller="$TEMP_DIR/postman.tar.gz"
    wget -O "$postmanInstaller" "$postmanUrl"
    sudo tar -xzf "$postmanInstaller" -C /opt/
    sudo ln -s /opt/Postman/Postman /usr/local/bin/postman
    echo "Postman instalado con éxito."
else
    echo "Postman ya está instalado. Omisión de la instalación."
fi

# Instalar Docker
if ! IsProgramInstalled docker; then
    echo "Docker no está instalado. Procediendo a la instalación..."
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
    echo "Docker instalado con éxito. Reinicia tu sesión para aplicar los cambios."
else
    echo "Docker ya está instalado. Omisión de la instalación."
fi

# Instalar Opera GX (a través de Opera GX Gaming Browser para Linux)
if ! IsProgramInstalled opera; then
    echo "Opera GX no está instalado. Procediendo a la instalación..."
    operaGXUrl="https://download4.operacdn.com/pub/opera/desktop/95.0.4635.84/linux/opera-stable_95.0.4635.84_amd64.deb"
    operaGXInstaller="$TEMP_DIR/opera-gx.deb"
    wget -O "$operaGXInstaller" "$operaGXUrl"
    sudo apt install -y "$operaGXInstaller"
    echo "Opera GX instalado con éxito."
else
    echo "Opera GX ya está instalado. Omisión de la instalación."
fi

# Limpiar la carpeta temporal
rm -rf "$TEMP_DIR"

echo "Proceso de instalación completado. Todos los programas han sido descargados e instalados correctamente (si era necesario)."
