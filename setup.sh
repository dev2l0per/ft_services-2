BLUE_GREEN="\033[36m"
echo -n "${BLUE_GREEN}"
printf "%s" "
███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
                                                                                  
"
export MINIKUBE_HOME=~/goinfre
#if [ -d "$MINIKUBE_HOME/.minikube/machines/minikube" ]; then
#	minikube delete
#fi
minikube start --vm-driver virtualbox --extra-config=apiserver.service-node-port-range=21-32767
#export MINIKUBE_HOME=~/goinfre
#if [ -d "$MINIKUBE_HOME/.minikube/machines/minikube" ]; then
#	minikube delete
#fi
#minikube start --vm-driver virtualbox --extra-config=apiserver.service-node-port-range=21-32767
#minikube start --extra-config=apiserver.service-node-port-range=21-32767
minikube addons enable metrics-server
minikube dashboard &
eval $(minikube docker-env)
docker build -t ft_nginx ./srcs/nginx
docker build -t ft_ftps ./srcs/ftps
docker build -t ft_wordpress ./srcs/wordpress
docker build -t ft_mysql ./srcs/mysql
docker build -t ft_phpmyadmin ./srcs/phpmyadmin
docker build -t ft_grafana ./srcs/grafana
docker build -t ft_influxdb ./srcs/influxdb
docker build -t ft_telegraf ./srcs/telegraf

kubectl create -f ./srcs/yaml/metallb/metallb_control.yaml
kubectl create -f ./srcs/yaml/metallb/metallb_config.yaml
kubectl create -f ./srcs/yaml/nginx.yaml
kubectl create -f ./srcs/yaml/ftps.yaml
kubectl create -f ./srcs/yaml/grafana
kubectl create -f ./srcs/yaml/influxdb
kubectl create -f ./srcs/yaml/mysql
kubectl create -f ./srcs/yaml/phpmyadmin
kubectl create -f ./srcs/yaml/telegraf
kubectl create -f ./srcs/yaml/wordpress
export MINIKUBE_HOME=~/goinfre
