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

minikube dashboard & > /dev/null
echo "대쉬보드를 실행합니다."

echo "metrics-server를 enable합니다."
minikube addons enable metrics-server > /dev/null
eval $(minikube docker-env)

echo "이미지 빌드를 시작합니다."
echo "ftps..."
docker build -t ft_ftps ./srcs/ftps > /dev/null
echo "wordpress..."
docker build -t ft_wordpress ./srcs/wordpress > /dev/null
echo "mysql..."
docker build -t ft_mysql ./srcs/mysql > /dev/null
echo "phpmyadmin..."
docker build -t ft_phpmyadmin ./srcs/phpmyadmin > /dev/null
echo "grafana..."
docker build -t ft_grafana ./srcs/grafana > /dev/null
echo "influxdb..."
docker build -t ft_influxdb ./srcs/influxdb > /dev/null
echo "telegraf..."
docker build -t ft_telegraf ./srcs/telegraf > /dev/null

echo "디플로이먼트와 서비스 객체를 생성합니다."
kubectl create -f ./srcs/yaml/metallb/metallb_control.yaml > /dev/null
kubectl create -f ./srcs/yaml/metallb/metallb_config.yaml > /dev/null
kubectl create -f ./srcs/yaml/ftps.yaml > /dev/null
kubectl create -f ./srcs/yaml/grafana > /dev/null
kubectl create -f ./srcs/yaml/influxdb > /dev/null
kubectl create -f ./srcs/yaml/mysql > /dev/null
kubectl create -f ./srcs/yaml/phpmyadmin > /dev/null
kubectl create -f ./srcs/yaml/telegraf > /dev/null
kubectl create -f ./srcs/yaml/wordpress > /dev/null

echo "워드프레스를 세팅합니다."
sh wordpress_setup.sh

echo "Nginx를 세팅합니다."
sh nginx_setup.sh

echo "설치가 완료되었습니다!"

export MINIKUBE_HOME=~/goinfre
