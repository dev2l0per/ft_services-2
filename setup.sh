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

echo "Minikube start ..."
minikube start --vm-driver virtualbox --extra-config=apiserver.service-node-port-range=21-32767 > /dev/null
#minikube start --extra-config=apiserver.service-node-port-range=21-32767

echo "대쉬보드를 실행합니다."
minikube dashboard &

echo "metrics-server를 enable합니다."
minikube addons enable metrics-server > /dev/null
eval $(minikube docker-env)

echo "이미지 빌드를 시작합니다."
docker build -t ft_nginx ./srcs/nginx > /dev/null
docker build -t ft_ftps ./srcs/ftps > /dev/null
docker build -t ft_wordpress ./srcs/wordpress > /dev/null
docker build -t ft_mysql ./srcs/mysql > /dev/null
docker build -t ft_phpmyadmin ./srcs/phpmyadmin > /dev/null
docker build -t ft_grafana ./srcs/grafana > /dev/null
docker build -t ft_influxdb ./srcs/influxdb > /dev/null
docker build -t ft_telegraf ./srcs/telegraf > /dev/null

echo "디플로이먼트와 서비스 객체를 생성합니다."
kubectl create -f ./srcs/yaml/metallb/metallb_control.yaml > /dev/null
kubectl create -f ./srcs/yaml/metallb/metallb_config.yaml > /dev/null
kubectl create -f ./srcs/yaml/nginx.yaml > /dev/null
kubectl create -f ./srcs/yaml/ftps.yaml > /dev/null
kubectl create -f ./srcs/yaml/grafana > /dev/null
kubectl create -f ./srcs/yaml/influxdb > /dev/null
kubectl create -f ./srcs/yaml/mysql > /dev/null
kubectl create -f ./srcs/yaml/phpmyadmin > /dev/null
kubectl create -f ./srcs/yaml/telegraf > /dev/null
kubectl create -f ./srcs/yaml/wordpress > /dev/null

echo "워드프레스를 세팅합니다."
sh wordpress_setup.sh

echo "설치가 완료되었습니다!"

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
