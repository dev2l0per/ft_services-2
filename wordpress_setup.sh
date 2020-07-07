#! /bin/bash
cd ./srcs/wordpress/srcs

# IP 처리하는 부분
# external ip가 아직 할당안되서 <pending> 이면 할당 될 때 까지 반복
kubectl get services | grep wordpress | awk '{print $4}' > WORDPRESS_IP
export WORDPRESS_IP=$(cat < WORDPRESS_IP)
export PENDING=\<pending\>
until [ $WORDPRESS_IP != $PENDING ]
do
	kubectl get services | grep wordpress | awk '{print $4}' > WORDPRESS_IP
	export WORDPRESS_IP=$(cat < WORDPRESS_IP)
done

# 파드 부분
kubectl get pods | grep wordpress | awk '{print $1}' > WORDPRESS_POD
export WORDPRESS_POD=$(cat < WORDPRESS_POD)
sed "s/WORD_IP/$WORDPRESS_IP/g" ./data/wordpress.sql > ./wordpress.sql
sed "s/WORD_IP/$WORDPRESS_IP/g" ./data/wp-config.php > ./wp-config.php
kubectl cp wordpress.sql $WORDPRESS_POD:/tmp/
kubectl cp wp-config.php $WORDPRESS_POD:/etc/wordpress/
kubectl exec $WORDPRESS_POD -- sh /tmp/init-wordpress.sh
# 필요없는 파일들 삭제
rm WORDPRESS_IP
rm WORDPRESS_POD
#rm wordpress.sql
#rm wp-config.php
export MINIKUBE_HOME=~/goinfre

# 만약 실패하면 다 삭제하고 처음부터 다시 시작

#until [ $? != 1 ]
#do
#	kubectl get pods | grep wordpress | awk '{print $1}' > WORDPRESS_POD
#	export WORDPRESS_POD=$(cat < WORDPRESS_POD)
#	kubectl cp wordpress.sql $WORDPRESS_POD:/tmp/
#done

#if [ $? == 1 ];
#then
#	echo "ft_services setdup again!"
#	cd ../../..
#	export MINIKUBE_HOME=~/goinfre
#	minikube delete
#	sh setup.sh
#elif [ $? == 0 ];
#then
#	echo in else!
#	kubectl cp wp-config.php $WORDPRESS_POD:/etc/wordpress/
#	kubectl exec $WORDPRESS_POD -- sh /tmp/init-wordpress.sh
#	# 필요없는 파일들 삭제
#	rm WORDPRESS_IP
#	rm WORDPRESS_POD
#	rm wordpress.sql
#	rm wp-config.php
#	export MINIKUBE_HOME=~/goinfre
#fi
