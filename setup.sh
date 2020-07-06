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
minikube start --vm-driver virtualbox --extra-config=apiserver.service-node-port-range=21-32767
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

sh wordpress_setup.sh

#cd ./srcs/wordpress/srcs
#kubectl get services | grep wordpress | awk '{print $4}' > WORDPRESS_IP
#kubectl get pods | grep wordpress | awk '{print $1}' > WORDPRESS_POD
#export WORDPRESS_IP=$(cat < WORDPRESS_IP)
#export WORDPRESS_POD=$(cat < WORDPRESS_POD)
#export PENDING=\<pending\>
#until [ $WORDPRESS_IP != $PENDING ]
#do
#	kubectl get services | grep wordpress | awk '{print $4}' > WORDPRESS_IP
#	export WORDPRESS_IP=$(cat < WORDPRESS_IP)
#done
#
#
#sed "s/WORD_IP/$WORDPRESS_IP/g" ./data/wordpress.sql > ./wordpress.sql
#sed "s/WORD_IP/$WORDPRESS_IP/g" ./data/wp-config.php > ./wp-config.php
#kubectl cp wordpress.sql $WORDPRESS_POD:/tmp/
#kubectl cp wp-config.php $WORDPRESS_POD:/etc/wordpress/
#kubectl exec $WORDPRESS_POD -- sh /tmp/init-wordpress.sh
#
#rm WORDPRESS_IP
#rm WORDPRESS_POD
export MINIKUBE_HOME=~/goinfre
